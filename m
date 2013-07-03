Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab3GCHPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 03:15:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:20514 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767Ab3GCHPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 03:15:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,986,1363158000"; 
   d="log'?scan'208";a="359783343"
Date: Wed, 3 Jul 2013 15:15:40 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: fengguang.wu@intel.com, Alessandro Rubini <rubini@gnudd.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [FMC] BUG: scheduling while atomic: swapper/1/0x10000002
Message-ID: <20130703071540.GC25674@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit 4debfe409b6e550032bfef9733e9f6f7c5613617
Author: Alessandro Rubini <rubini@gnudd.com>
Date:   Tue Jun 18 23:48:07 2013 +0200

    FMC: add a char-device mezzanine driver
    
    This driver exports the memory area associated with the mezzanine card
    as a misc device, so users can access registers.
    
    Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
    Acked-by: Juan David Gonzalez Cobas <dcobas@cern.ch>
    Acked-by: Emilio G. Cota <cota@braap.org>
    Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[    8.099210] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eeprom: no busid passed, refusing all cards
[    8.101676] fmc fake-design-for-testing-f001: Driver has no ID: matches all
[    8.103293] BUG: scheduling while atomic: swapper/1/0x10000002
[    8.104703] CPU: 0 PID: 1 Comm: swapper Not tainted 3.10.0-wl-06036-gaf15f8d #1
[    8.106580] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    8.107966]  0000000000000000 ffff88000dc5bb00 ffffffff81b7bf27 ffff88000dc5bb10
[    8.110313]  ffffffff81b77ffd ffff88000dc5bb70 ffffffff81b848be ffffffff810dcf60
[    8.112635]  ffff88000dc5bfd8 ffff88000dc5bfd8 ffff88000dc5bfd8 ffff88000dc5bfd8
[    8.114976] Call Trace:
[    8.115743]  [<ffffffff81b7bf27>] dump_stack+0x19/0x1b
[    8.117044]  [<ffffffff81b77ffd>] __schedule_bug+0x42/0x50
[    8.118369]  [<ffffffff81b848be>] __schedule+0x50e/0x520
[    8.119657]  [<ffffffff810dcf60>] ? __enqueue_entity+0x70/0x80
[    8.121115]  [<ffffffff810d9710>] __cond_resched+0x20/0x30
[    8.122434]  [<ffffffff81b84a63>] _cond_resched+0x33/0x40
[    8.123749]  [<ffffffff81b84d5a>] wait_for_completion+0x2a/0x140
[    8.125215]  [<ffffffff815c3a54>] devtmpfs_create_node+0xf4/0x130
[    8.126664]  [<ffffffff815bbb8e>] device_add+0x23e/0x6f0
[    8.127969]  [<ffffffff815bca40>] device_create_vargs+0xd0/0x100
[    8.129430]  [<ffffffff815bca9f>] device_create+0x2f/0x40
[    8.130750]  [<ffffffff81b83980>] ? mutex_lock+0x20/0x30
[    8.132064]  [<ffffffff81587a56>] misc_register+0xc6/0x120
[    8.133397]  [<ffffffff8192c7a8>] fc_probe+0x98/0x140
[    8.134643]  [<ffffffff8192a652>] fmc_probe+0x12/0x20
[    8.135878]  [<ffffffff815bf4d2>] really_probe+0x52/0x1f0
[    8.137225]  [<ffffffff815bf771>] __driver_attach+0x91/0xa0
[    8.138564]  [<ffffffff815bf6e0>] ? __device_attach+0x50/0x50
[    8.139952]  [<ffffffff815bd9d3>] bus_for_each_dev+0x63/0xa0
[    8.141382]  [<ffffffff815bf409>] driver_attach+0x19/0x20
[    8.142703]  [<ffffffff815be418>] bus_add_driver+0x1c8/0x260
[    8.144091]  [<ffffffff8192c6d0>] ? fc_read+0xb0/0xb0
[    8.145336]  [<ffffffff815bff1f>] driver_register+0x6f/0x150
[    8.146700]  [<ffffffff8192c6d0>] ? fc_read+0xb0/0xb0
[    8.147960]  [<ffffffff8192a7f0>] fmc_driver_register+0x30/0x40
[    8.149415]  [<ffffffff8192c6e0>] fc_init+0x10/0x20
[    8.150635]  [<ffffffff82373feb>] do_one_initcall+0x79/0x117
[    8.152000]  [<ffffffff82374184>] kernel_init_freeable+0xfb/0x17c
[    8.153476]  [<ffffffff82373881>] ? do_early_param+0x88/0x88
[    8.154831]  [<ffffffff81b71c90>] ? rest_init+0x90/0x90
[    8.156144]  [<ffffffff81b71c99>] kernel_init+0x9/0x180
[    8.157424]  [<ffffffff81b86b7a>] ret_from_fork+0x7a/0xb0
[    8.158745]  [<ffffffff81b71c90>] ? rest_init+0x90/0x90
[    8.160103] fmc_chardev fake-design-for-testing-f001: Created misc device "fake-design-for-testing-f001"
[    8.162448] Audio Excel DSP 16 init driver Copyright (C) Riccardo Facchetti 1995-98

git bisect start af15f8de4f3a7b28e3a2c2064ad74106767516ca 8bb495e3f02401ee6f76d1b1d77f3ac9f079e376 --
git bisect good 42d40811bf7f97b6b7986bb117f3310243d91ffe  # 11:00     60+  Merge remote-tracking branch 'josef-btrfs/master' into devel-cairo-x86_64-201307012240
git bisect  bad 687e28600c4eb7737c036daa5c787227b3d1bb01  # 11:05      0-  Merge remote-tracking branch 'scsi/for-next' into devel-cairo-x86_64-201307012240
git bisect good 99f9e01bf87d4b8da68fd7795b0f05ab767b982e  # 11:11     60+  Merge remote-tracking branch 'm68k/m68k-queue' into devel-cairo-x86_64-201307012240
git bisect good 80d162c66bc6159efa67406d34757857628c5c02  # 13:53     60+  Merge remote-tracking branch 'pinchartl-fbdev/boards/ethernet' into devel-cairo-x86_64-201307012240
git bisect  bad 02b12c58897d1b25ad52ef5c81b29409ae5e9169  # 13:59      0-  Merge remote-tracking branch 'gregkh-char-misc/char-misc-next' into postmerge-base
git bisect  bad 34cb27528398738bea94852b99ef8fb05944ec41  # 14:03      0-  UIO: Fix concurrency issue
git bisect good 4cd5773a2ae6facdde3f563087a4cc50f00d9530  # 14:08     60+  net: core: move mac_pton() to lib/net_utils.c
git bisect good e31c51e4a1d11ed0b61557ca9da9cf18c8855531  # 14:15     60+  vme: tsi148: Only store VME bus errors if they will be checked
git bisect good 056d83f3c30c398f14eb879f1d1707e3a7808f4a  # 14:21     60+  FMC: add a software mezzanine driver
git bisect  bad c2955da0e101c3432ae21945e5d77786adf1f094  # 14:25      0-  fmc: avoid readl/writel namespace conflict
git bisect  bad 05c3e0bb5629b897b0459e4bfb1b93d729033b99  # 14:29      0-  UIO: allow binding uio_pdrv_genirq.c to devices using command line option
git bisect  bad 4debfe409b6e550032bfef9733e9f6f7c5613617  # 14:34      0-  FMC: add a char-device mezzanine driver
git bisect good 6007b1bd0f752a5c022f7944c65fb96c39d6db3d  # 14:40     60+  FMC: add a driver to write mezzanine EEPROM
git bisect good 6007b1bd0f752a5c022f7944c65fb96c39d6db3d  # 14:42    180+  FMC: add a driver to write mezzanine EEPROM
git bisect  bad af15f8de4f3a7b28e3a2c2064ad74106767516ca  # 14:42      0-  Merge remote-tracking branch 'xlnx/zynq/clk' into devel-cairo-x86_64-201307012240
git bisect  bad 0b0585c3e192967cb2ef0ac0816eb8a8c8d99840  # 14:47      0-  Merge branch 'for-3.11-cpuset' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup
git bisect  bad e8e1f4c8a798998aad598698b3dd44a95ab80573  # 14:58      0-  Add linux-next specific files for 20130702

Thanks,
Fengguang

--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-bay-28183-20130701233139-3.10.0-wl-06036-gaf15f8d-1"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.10.0-wl-06036-gaf15f8d (kbuild@cairo) (gcc v=
ersion 4.8.1 (Debian 4.8.1-3) ) #1 Mon Jul 1 23:30:57 CST 2013
[    0.000000] Command line: hung_task_panic=3D1 rcutree.rcu_cpu_stall_time=
out=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug d=
ynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/ke=
rnel-tests/run-queue/kvm/x86_64-randconfig-c25-0701/devel-cairo-x86_64-2013=
07012240/.vmlinuz-af15f8de4f3a7b28e3a2c2064ad74106767516ca-20130701233130-9=
-bay branch=3Dlinux-devel/devel-cairo-x86_64-201307012240  BOOT_IMAGE=3D/ke=
rnel/x86_64-randconfig-c25-0701/af15f8de4f3a7b28e3a2c2064ad74106767516ca/vm=
linuz-3.10.0-wl-06036-gaf15f8d
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
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02521000, 0x02521fff] PGTABLE
[    0.000000] BRK [0x02522000, 0x02522fff] PGTABLE
[    0.000000] BRK [0x02523000, 0x02523fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x02524000, 0x02524fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127612(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 00034 (v01 BOCHS  BXPCRSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000=
001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 011A9 (v01   BXPC   BXDSDT 00000=
001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 00080 (v01 BOCHS  BXPCAPIC 00000=
001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 00038 (v01 BOCHS  BXPCHPET 00000=
001 BXPC 00000001)
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
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 840 pages used for memmap
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
[    0.000000] kvm-stealtime: cpu 0, msr 222d240
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64519
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-c25-0701/devel-cairo-x86_6=
4-201307012240/.vmlinuz-af15f8de4f3a7b28e3a2c2064ad74106767516ca-2013070123=
3130-9-bay branch=3Dlinux-devel/devel-cairo-x86_64-201307012240  BOOT_IMAGE=
=3D/kernel/x86_64-randconfig-c25-0701/af15f8de4f3a7b28e3a2c2064ad7410676751=
6ca/vmlinuz-3.10.0-wl-06036-gaf15f8d
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 204124k/262136k available (11815k kernel code, 392k =
absent, 57620k reserved, 8095k data, 1036k init)
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2992.484 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5984.96 Bogo=
MIPS (lpj=3D11969936)
[    0.008004] pid_max: default: 32768 minimum: 301
[    0.009141] Mount-cache hash table entries: 256
[    0.010418] Initializing cgroup subsys debug
[    0.011447] Initializing cgroup subsys devices
[    0.012004] Initializing cgroup subsys freezer
[    0.013065] Initializing cgroup subsys net_prio
[    0.014138] Initializing cgroup subsys hugetlb
[    0.015305] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.015305] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.015305] tlb_flushall_shift: 6
[    0.016003] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.035820] ACPI: Core revision 20130517
[    0.036612] ACPI: All ACPI Tables successfully acquired
[    0.038143] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.041236] Getting VERSION: 50014
[    0.042141] Getting VERSION: 50014
[    0.043033] Getting ID: 0
[    0.044004] Getting ID: ff000000
[    0.044873] Getting LVT0: 8700
[    0.045700] Getting LVT1: 8400
[    0.046592] enabled ExtINT on CPU#0
[    0.048523] ENABLING IO-APIC IRQs
[    0.049411] init IO_APIC IRQs
[    0.050219]  apic 0 pin 0 not connected
[    0.051175] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.052020] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.053885] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.056017] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.057852] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.060017] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.061851] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.064018] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.065860] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.068026] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.070019] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.071867] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.072017] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.073879] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.076017] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.077882]  apic 0 pin 16 not connected
[    0.080002]  apic 0 pin 17 not connected
[    0.080953]  apic 0 pin 18 not connected
[    0.081905]  apic 0 pin 19 not connected
[    0.082862]  apic 0 pin 20 not connected
[    0.084001]  apic 0 pin 21 not connected
[    0.084955]  apic 0 pin 22 not connected
[    0.085927]  apic 0 pin 23 not connected
[    0.087034] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.088002] Using local APIC timer interrupts.
[    0.088002] calibrating APIC timer ...
[    0.092000] ... lapic delta =3D 6250058
[    0.092000] ... PM-Timer delta =3D 358045
[    0.092000] ... PM-Timer result ok
[    0.092000] ..... delta 6250058
[    0.092000] ..... mult: 268437947
[    0.092000] ..... calibration result: 4000037
[    0.092000] ..... CPU clock speed is 2993.2386 MHz.
[    0.092000] ..... host bus clock speed is 1000.0037 MHz.
[    0.092166] devtmpfs: initialized
[    0.093571] xor: measuring software checksum speed
[    0.132003]    prefetch64-sse: 10835.000 MB/sec
[    0.172002]    generic_sse:  9113.000 MB/sec
[    0.173114] xor: using function: prefetch64-sse (10835.000 MB/sec)
[    0.174640] regulator-dummy: no parameters
[    0.175747] NET: Registered protocol family 16
[    0.176506] ACPI: bus type PCI registered
[    0.177612] PCI: Using configuration type 1 for base access
[    0.182037] bio: create slab <bio-0> at 0
[    0.248010] raid6: sse2x1    4874 MB/s
[    0.316011] raid6: sse2x2    5322 MB/s
[    0.384005] raid6: sse2x4    8650 MB/s
[    0.385034] raid6: using algorithm sse2x4 (8650 MB/s)
[    0.386287] raid6: using intx1 recovery algorithm
[    0.387548] ACPI: Added _OSI(Module Device)
[    0.388002] ACPI: Added _OSI(Processor Device)
[    0.389137] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.390324] ACPI: Added _OSI(Processor Aggregator Device)
[    0.392520] ACPI: EC: Look up EC in DSDT
[    0.394729] ACPI: Interpreter enabled
[    0.396006] ACPI: (supports S0 S5)
[    0.396947] ACPI: Using IOAPIC for interrupt routing
[    0.398192] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.402430] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.404113] PCI host bridge to bus 0000:00
[    0.405187] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.406517] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.408002] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.409473] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.411065] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.412049] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.413872] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.416523] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.421142] pci 0000:00:01.1: reg 20: [io  0xc1e0-0xc1ef]
[    0.423726] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.424430] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.426281] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.428187] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.432027] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.434873] pci 0000:00:02.0: reg 14: [mem 0xfebe4000-0xfebe4fff]
[    0.443102] pci 0000:00:02.0: reg 30: [mem 0xfebc0000-0xfebcffff pref]
[    0.444202] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.446751] pci 0000:00:03.0: reg 10: [io  0xc1c0-0xc1df]
[    0.449067] pci 0000:00:03.0: reg 14: [mem 0xfebe5000-0xfebe5fff]
[    0.456544] pci 0000:00:03.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
[    0.458271] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.460548] pci 0000:00:04.0: reg 10: [mem 0xfeb80000-0xfeb9ffff]
[    0.463054] pci 0000:00:04.0: reg 14: [io  0xc000-0xc03f]
[    0.469612] pci 0000:00:04.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
[    0.471263] pci 0000:00:05.0: [8086:2668] type 00 class 0x040300
[    0.472629] pci 0000:00:05.0: reg 10: [mem 0xfebe0000-0xfebe3fff]
[    0.478791] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.481131] pci 0000:00:06.0: reg 10: [io  0xc040-0xc07f]
[    0.483514] pci 0000:00:06.0: reg 14: [mem 0xfebe6000-0xfebe6fff]
[    0.490367] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.493122] pci 0000:00:07.0: reg 10: [io  0xc080-0xc0bf]
[    0.495493] pci 0000:00:07.0: reg 14: [mem 0xfebe7000-0xfebe7fff]
[    0.502372] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.505126] pci 0000:00:08.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.507489] pci 0000:00:08.0: reg 14: [mem 0xfebe8000-0xfebe8fff]
[    0.514375] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.517125] pci 0000:00:09.0: reg 10: [io  0xc100-0xc13f]
[    0.519501] pci 0000:00:09.0: reg 14: [mem 0xfebe9000-0xfebe9fff]
[    0.526372] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.529156] pci 0000:00:0a.0: reg 10: [io  0xc140-0xc17f]
[    0.531560] pci 0000:00:0a.0: reg 14: [mem 0xfebea000-0xfebeafff]
[    0.538383] pci 0000:00:0b.0: [1af4:1001] type 00 class 0x010000
[    0.541126] pci 0000:00:0b.0: reg 10: [io  0xc180-0xc1bf]
[    0.543500] pci 0000:00:0b.0: reg 14: [mem 0xfebeb000-0xfebebfff]
[    0.550356] pci 0000:00:0c.0: [8086:25ab] type 00 class 0x088000
[    0.552297] pci 0000:00:0c.0: reg 10: [mem 0xfebec000-0xfebec00f]
[    0.557370] pci_bus 0000:00: on NUMA node 0
[    0.558449] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.560406] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.562375] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.564892] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.566870] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.568837] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.570929] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.572004] acpi root: \_SB_.PCI0 notify handler is installed
[    0.573376] Found 1 acpi root devices
[    0.574685] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.576003] vgaarb: loaded
[    0.576806] vgaarb: bridge control possible 0000:00:02.0
[    0.578125] Error: Driver '88PM80X' is already registered, aborting...
[    0.580021] tps65010: version 2 May 2005
[    0.612012] tps65010: no chip?
[    0.613078] SCSI subsystem initialized
[    0.614091] ACPI: bus type ATA registered
[    0.615199] libata version 3.00 loaded.
[    0.616062] Linux video capture interface: v2.00
[    0.617253] pps_core: LinuxPPS API ver. 1 registered
[    0.618482] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.620007] PTP clock support registered
[    0.621131] Advanced Linux Sound Architecture Driver Initialized.
[    0.622588] PCI: Using ACPI for IRQ routing
[    0.624008] PCI: pci_cache_line_size set to 64 bytes
[    0.625527] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.626961] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.628100] irda_init()
[    0.628897] NET: Registered protocol family 23
[    0.630052] Bluetooth: Core ver 2.16
[    0.632007] NET: Registered protocol family 31
[    0.633158] Bluetooth: HCI device and connection manager initialized
[    0.634631] Bluetooth: HCI socket layer initialized
[    0.635850] Bluetooth: L2CAP socket layer initialized
[    0.636007] Bluetooth: SCO socket layer initialized
[    0.637242] nfc: nfc_init: NFC Core ver 0.1
[    0.640017] NET: Registered protocol family 39
[    0.644223] Switching to clocksource kvm-clock
[    0.645415] pnp: PnP ACPI init
[    0.646294] ACPI: bus type PNP registered
[    0.647355] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.648078] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.649614] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.651628] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.653206] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.655258] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.656818] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.658829] pnp 00:03: [dma 2]
[    0.659726] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.661324] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.663369] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.664945] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.666966] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.668613] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.670256] pnp: PnP ACPI: found 7 devices
[    0.671330] ACPI: bus type PNP unregistered
[    0.677987] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.679344] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.680710] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.682190] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.683695] NET: Registered protocol family 2
[    0.684996] TCP established hash table entries: 2048 (order: 3, 32768 by=
tes)
[    0.686656] TCP bind hash table entries: 2048 (order: 2, 16384 bytes)
[    0.688203] TCP: Hash tables configured (established 2048 bind 2048)
[    0.689772] TCP: reno registered
[    0.690684] UDP hash table entries: 256 (order: 1, 8192 bytes)
[    0.692106] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
[    0.693613] NET: Registered protocol family 1
[    0.694733] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.696169] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.697569] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.699066] pci 0000:00:02.0: Boot video device
[    0.700348] PCI: CLS 0 bytes, default 64
[    0.701422] Unpacking initramfs...
[    1.128375] Freeing initrd memory: 23656k freed
[    1.137357] kvm: no hardware support
[    1.138600] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    1.139968] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    1.142239] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    1.144565] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.146038] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.147524] AVX or AES-NI instructions are not detected.
[    1.148825] AVX instructions are not detected.
[    1.149967] AVX instructions are not detected.
[    1.151104] AVX instructions are not detected.
[    1.152255] AVX2 or AES-NI instructions are not detected.
[    1.153570] AVX2 instructions are not detected.
[    1.154867] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.156426] VFS: Disk quotas dquot_6.5.2
[    1.157476] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.159074] DLM installed
[    1.159906] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    1.161410] NTFS driver 2.1.30 [Flags: R/W].
[    1.162529] QNX6 filesystem 1.0.0 registered.
[    1.163665] fuse init (API version 7.22)
[    1.164771] JFS: nTxBlock =3D 1779, nTxLock =3D 14236
[    1.166685] SGI XFS with security attributes, realtime, large block/inod=
e numbers, debug enabled
[    1.168967] BeFS version: 0.9.3
[    1.169869] bio: create slab <bio-1> at 1
[    1.170985] Btrfs loaded
[    1.171776] msgmni has been set to 444
[    1.173959] alg: No test for crc32 (crc32-table)
[    1.175199] alg: No test for stdrng (krng)
[    1.176299] NET: Registered protocol family 38
[    1.177451] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    1.179357] io scheduler noop registered (default)
[    1.180582] test_string_helpers: Running tests...
[    1.182240] crc32: CRC_LE_BITS =3D 32, CRC_BE BITS =3D 32
[    1.183499] crc32: self tests passed, processed 225944 bytes in 211036 n=
sec
[    1.185336] crc32c: CRC_LE_BITS =3D 32
[    1.186313] crc32c: self tests passed, processed 225944 bytes in 102419 =
nsec
[    1.188526] xz_dec_test: module loaded
[    1.189592] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
250 0' and write .xz files to it.
[    1.192070] no IO addresses supplied
[    1.193114] hgafb: HGA card not detected.
[    1.194180] hgafb: probe of hgafb.0 failed with error -22
[    1.195616] uvesafb: failed to execute /sbin/v86d
[    1.196824] uvesafb: make sure that the v86d helper is installed and exe=
cutable
[    1.198701] uvesafb: Getting VBE info block failed (eax=3D0x4f00, err=3D=
-2)
[    1.200255] uvesafb: vbe_init() failed with -22
[    1.201412] uvesafb: probe of uvesafb.0 failed with error -22
[    1.202830] ipmi message handler version 39.2
[    1.203969] ipmi device interface
[    1.204934] IPMI System Interface driver.
[    1.206015] ipmi_si: Adding default-specified kcs state machine
[    1.207529] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    1.209955] ipmi_si: Interface detection failed
[    1.211110] ipmi_si: Adding default-specified smic state machine
[    1.212652] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    1.215047] ipmi_si: Interface detection failed
[    1.216207] ipmi_si: Adding default-specified bt state machine
[    1.217698] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    1.220061] ipmi_si: Interface detection failed
[    1.221217] ipmi_si: Unable to find any System Interface(s)
[    1.222565] IPMI Watchdog: driver initialized
[    1.223725] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    1.225665] ACPI: Power Button [PWRF]
[    1.226754] xenfs: not registering filesystem on non-xen platform
[    1.232121] r3964: Philips r3964 Driver $Revision: 1.10 $
[    1.233474] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.257775] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    1.259584] lp: driver loaded but no devices found
[    1.260827] Non-volatile memory driver v1.3
[    1.261931] ppdev: user-space parallel port driver
[    1.263140] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    1.264408] smapi::smapi_init, ERROR invalid usSmapiID
[    1.265678] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    1.267932] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    1.269828] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    1.271299] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    1.273487] Hangcheck: Using getrawmonotonic().
[    1.274694] [drm] Initialized drm 1.1.0 20060810
[    1.276672] parport_pc 00:04: reported by Plug and Play ACPI
[    1.278100] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[    1.280106] lp0: using parport0 (interrupt-driven).
[    1.281323] lp0: console ready
[    1.282463] Floppy drive(s): fd0 is 1.44M
[    1.284053] loop: module loaded
[    1.285018] nbd: registered device at major 43
[    1.286615] events: mcg drbd: 6
[    1.289753] drbd: initialized. Version: 8.4.3 (api:1/proto:86-101)
[    1.291288] drbd: built-in
[    1.292141] drbd: registered as block device major 147
[    1.293474] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    1.295371] c2port c2port0: C2 port uc added
[    1.296495] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    1.298866] FDC 0 is a S82078B
[    1.300122] Uniform Multi-Platform E-IDE driver
[    1.301815] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[    1.304233] Loading iSCSI transport class v2.0-870.
[    1.305480] emc: device handler registered
[    1.306552] alua: device handler registered
[    1.307638] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    1.309172] osd: LOADED open-osd 0.2.1
[    1.310226] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    1.312509] vcan: Virtual CAN interface driver
[    1.313707] slcan: serial line CAN interface driver
[    1.314938] slcan: 10 dynamic interface channels.
[    1.316128] CAN device driver interface
[    1.317184] sja1000 CAN netdevice driver
[    1.318230] sja1000_isa: insufficient parameters supplied
[    1.319643] w83977af_init()
[    1.320484] w83977af_open()
[    1.321318] w83977af_probe()
[    1.322269] w83977af_probe(), Wrong chip version
[    1.323201] w83977af_probe()
[    1.324505] w83977af_probe(), Wrong chip versionparide: comm registered =
as protocol 0
[    1.326713] paride: k951 registered as protocol 1
[    1.327917] paride: k971 registered as protocol 2
[    1.329129] paride: epat registered as protocol 3
[    1.330333] pd: pd version 1.05, major 45, cluster 64, nice 0
[    2.174161] tsc: Refined TSC clocksource calibration: 2992.490 MHz
[    2.950051] pda: Autoprobe failed
[    2.955243] pd: no valid drive found
[    2.956286] pcd: pcd version 1.07, major 46, nice 0
[    4.596186] pcd0: Autoprobe failed
[    4.597142] pcd: No CD-ROM drive found
[    4.598151] pf: pf version 1.04, major 47, cluster 64, nice 0
[    4.599524] pf: No ATAPI disk detected
[    4.600546] pt: pt version 1.04, major 96
[    6.226006] pt0: Autoprobe failed
[    6.226951] pt: No ATAPI tape drive detected
[    6.228067] pg: pg version 1.02, major 97
[    7.841001] pga: Autoprobe failed
[    7.841972] pg: No ATAPI device detected
[    7.843189] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    7.846068] serio: i8042 KBD port at 0x60,0x64 irq 1
[    7.847343] serio: i8042 AUX port at 0x60,0x64 irq 12
[    7.848673] parport0: cannot grant exclusive access for device parkbd
[    7.918864] mousedev: PS/2 mouse device common for all mice
[    7.920297] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    7.922647] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    7.924765] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    7.927306] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    7.928891] rtc_cmos 00:00: RTC can wake from S4
[    7.930348] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    7.931905] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    7.933686] rtc-test rtc-test.0: rtc core: registered test as rtc1
[    7.935157] rtc-test rtc-test.1: rtc core: registered test as rtc2
[    7.936655] i2c /dev entries driver
[    7.937627] i2c-parport: adapter type unspecified
[    7.938805] i2c-parport-light: adapter type unspecified
[    7.940239] pps pps0: new PPS source ktimer
[    7.941323] pps pps0: ktimer PPS source registered
[    7.942522] pps_ldisc: PPS line discipline registered
[    7.943791] Driver for 1-wire Dallas network protocol.
[    7.945088] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    7.946507] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    7.949538] md: raid1 personality registered for level 1
[    7.950831] md: raid10 personality registered for level 10
[    7.952187] md: raid6 personality registered for level 6
[    7.953476] md: raid5 personality registered for level 5
[    7.954766] md: raid4 personality registered for level 4
[    7.956083] md: multipath personality registered for level -4
[    7.957460] md: faulty personality registered for level -5
[    7.958786] Bluetooth: Virtual HCI driver ver 1.3
[    7.959999] Bluetooth: HCI UART driver ver 2.2
[    7.961152] Bluetooth: HCI H4 protocol initialized
[    7.962358] Bluetooth: HCILL protocol initialized
[    7.963585] Bluetooth: HCIATH3K protocol initialized
[    7.964835] Bluetooth: HCI Three-wire UART (H5) protocol initialized
[    7.966326] cpuidle: using governor ladder
[    7.967397] cpuidle: using governor menu
[    7.968564] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    8.083118] panel: driver version 0.9.5 registered on parport0 (io=3D0x3=
78).
[    8.084835] zram: Created 1 device(s) ...
[    8.085969] ashmem: initialized
[    8.086880] logger: created 256K log 'log_main'
[    8.088074] logger: created 256K log 'log_events'
[    8.089281] logger: created 256K log 'log_radio'
[    8.090460] logger: created 256K log 'log_system'
[    8.091677] hdaps: supported laptop not found!
[    8.092833] hdaps: driver init failed (ret=3D-19)!
[    8.094137]  fake-fmc-carrier: mezzanine 0
[    8.095202]       Manufacturer: fake-vendor
[    8.096306]       Product name: fake-design-for-testing
[    8.097595] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    8.099210] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[    8.101676] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    8.103293] BUG: scheduling while atomic: swapper/1/0x10000002
[    8.104703] CPU: 0 PID: 1 Comm: swapper Not tainted 3.10.0-wl-06036-gaf1=
5f8d #1
[    8.106580] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    8.107966]  0000000000000000 ffff88000dc5bb00 ffffffff81b7bf27 ffff8800=
0dc5bb10
[    8.110313]  ffffffff81b77ffd ffff88000dc5bb70 ffffffff81b848be ffffffff=
810dcf60
[    8.112635]  ffff88000dc5bfd8 ffff88000dc5bfd8 ffff88000dc5bfd8 ffff8800=
0dc5bfd8
[    8.114976] Call Trace:
[    8.115743]  [<ffffffff81b7bf27>] dump_stack+0x19/0x1b
[    8.117044]  [<ffffffff81b77ffd>] __schedule_bug+0x42/0x50
[    8.118369]  [<ffffffff81b848be>] __schedule+0x50e/0x520
[    8.119657]  [<ffffffff810dcf60>] ? __enqueue_entity+0x70/0x80
[    8.121115]  [<ffffffff810d9710>] __cond_resched+0x20/0x30
[    8.122434]  [<ffffffff81b84a63>] _cond_resched+0x33/0x40
[    8.123749]  [<ffffffff81b84d5a>] wait_for_completion+0x2a/0x140
[    8.125215]  [<ffffffff815c3a54>] devtmpfs_create_node+0xf4/0x130
[    8.126664]  [<ffffffff815bbb8e>] device_add+0x23e/0x6f0
[    8.127969]  [<ffffffff815bca40>] device_create_vargs+0xd0/0x100
[    8.129430]  [<ffffffff815bca9f>] device_create+0x2f/0x40
[    8.130750]  [<ffffffff81b83980>] ? mutex_lock+0x20/0x30
[    8.132064]  [<ffffffff81587a56>] misc_register+0xc6/0x120
[    8.133397]  [<ffffffff8192c7a8>] fc_probe+0x98/0x140
[    8.134643]  [<ffffffff8192a652>] fmc_probe+0x12/0x20
[    8.135878]  [<ffffffff815bf4d2>] really_probe+0x52/0x1f0
[    8.137225]  [<ffffffff815bf771>] __driver_attach+0x91/0xa0
[    8.138564]  [<ffffffff815bf6e0>] ? __device_attach+0x50/0x50
[    8.139952]  [<ffffffff815bd9d3>] bus_for_each_dev+0x63/0xa0
[    8.141382]  [<ffffffff815bf409>] driver_attach+0x19/0x20
[    8.142703]  [<ffffffff815be418>] bus_add_driver+0x1c8/0x260
[    8.144091]  [<ffffffff8192c6d0>] ? fc_read+0xb0/0xb0
[    8.145336]  [<ffffffff815bff1f>] driver_register+0x6f/0x150
[    8.146700]  [<ffffffff8192c6d0>] ? fc_read+0xb0/0xb0
[    8.147960]  [<ffffffff8192a7f0>] fmc_driver_register+0x30/0x40
[    8.149415]  [<ffffffff8192c6e0>] fc_init+0x10/0x20
[    8.150635]  [<ffffffff82373feb>] do_one_initcall+0x79/0x117
[    8.152000]  [<ffffffff82374184>] kernel_init_freeable+0xfb/0x17c
[    8.153476]  [<ffffffff82373881>] ? do_early_param+0x88/0x88
[    8.154831]  [<ffffffff81b71c90>] ? rest_init+0x90/0x90
[    8.156144]  [<ffffffff81b71c99>] kernel_init+0x9/0x180
[    8.157424]  [<ffffffff81b86b7a>] ret_from_fork+0x7a/0xb0
[    8.158745]  [<ffffffff81b71c90>] ? rest_init+0x90/0x90
[    8.160103] fmc_chardev fake-design-for-testing-f001: Created misc devic=
e "fake-design-for-testing-f001"
[    8.162448] Audio Excel DSP 16 init driver Copyright (C) Riccardo Facche=
tti 1995-98
[    8.164419] aedsp16: I/O, IRQ and DMA are mandatory
[    8.165647] pss: mss_io, mss_dma, mss_irq and pss_io must be set.
[    8.167084] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen=
 1993-1996
[    8.169040] ad1848: No ISAPnP cards found, trying standard ones...
[    8.170497] Pro Audio Spectrum driver Copyright (C) by Hannu Savolainen =
1993-1996
[    8.172409] I/O, IRQ, DMA and type are mandatory
[    8.173583] sb: Init: Starting Probe...
[    8.174606] sb: Init: Done
[    8.175424] uart6850: irq and io must be set.
[    8.176578] YM3812 and OPL-3 driver Copyright (C) by Hannu Savolainen, R=
ob Hooft 1993-1996
[    8.178678] ALSA seq_oss.c:236 can't register device seq
[    8.180080] ALSA mtpav.c:589 MTVAP port 0x378 is busy
[    8.181342] snd_mtpav: probe of snd_mtpav failed with error -16
[    8.182783] snd_mts64: probe of snd_mts64.0 failed with error -5
[    8.184312] snd_portman2x4: probe of snd_portman2x4.0 failed with error =
-5
[    8.185996] input: PC Speaker as /devices/platform/pcspkr/input/input2
[    8.187589] evbug: Connected device: input2 (PC Speaker at isa0061/input=
0)
[    8.189339] ALSA pcm_oss.c:3016 unable to register OSS PCM device 0:0
[    8.192077] pktgen: Packet Generator for packet performance testing. Ver=
sion: 2.74
[    8.194155] NET: Registered protocol family 26
[    8.195353] gre: GRE over IPv4 demultiplexor driver
[    8.196619] ip_gre: GRE over IPv4 tunneling driver
[    8.197983] TCP: cubic registered
[    8.198941] Initializing XFRM netlink socket
[    8.200124] NET: Registered protocol family 17
[    8.201300] NET: Registered protocol family 4
[    8.202459] NET: Registered protocol family 5
[    8.203621] can: controller area network core (rev 20120528 abi 9)
[    8.205156] NET: Registered protocol family 29
[    8.206328] IrCOMM protocol (Dag Brattli)
[    8.207702] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    8.209069] Bluetooth: BNEP filters: protocol=20
[    8.210235] Bluetooth: BNEP socket layer initialized
[    8.211498] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    8.212967] Bluetooth: HIDP socket layer initialized
[    8.214249] NET: Registered protocol family 33
[    8.215420] Key type rxrpc registered
[    8.216449] Key type rxrpc_s registered
[    8.217531] RxRPC: Registered security type 2 'rxkad'
[    8.218851] sctp: Hash tables configured (established 8192 bind 8192)
[    8.220510] sctp: sctp_init_sock(sk: ffff880005e2fb80)
[    8.221852] NET: Registered protocol family 21
[    8.223030] Registered RDS/tcp transport
[    8.224120] tipc: Activated (version 2.0.0)
[    8.225310] NET: Registered protocol family 30
[    8.226491] tipc: Started in single node mode
[    8.227645] NET: Registered protocol family 36
[    8.228876] batman_adv: B.A.T.M.A.N. advanced 2013.2.0 (compatibility ve=
rsion 14) loaded
[    8.231191]=20
[    8.231191] printing PIC contents
[    8.232653] ... PIC  IMR: ffff
[    8.233561] ... PIC  IRR: 1153
[    8.234476] ... PIC  ISR: 0000
[    8.235387] ... PIC ELCR: 0c00
[    8.240583] printing local APIC contents on CPU#0/0:
[    8.241858] ... APIC ID:      00000000 (0)
[    8.242971] ... APIC VERSION: 00050014
[    8.244014] ... APIC TASKPRI: 00000000 (00)
[    8.244531] ... APIC PROCPRI: 00000000
[    8.244531] ... APIC LDR: 01000000
[    8.244531] ... APIC DFR: ffffffff
[    8.244531] ... APIC SPIV: 000001ff
[    8.244531] ... APIC ISR field:
[    8.244531] 000000000000000000000000000000000000000000000000000000000000=
0000
[    8.244531] ... APIC TMR field:
[    8.244531] 000000000200000000000000000000000000000000000000000000000000=
0000
[    8.244531] ... APIC IRR field:
[    8.244531] 000000000000000000000000000000000000000000000000000000000000=
8000
[    8.244531] ... APIC ESR: 00000000
[    8.244531] ... APIC ICR: 00000831
[    8.244531] ... APIC ICR2: 01000000
[    8.244531] ... APIC LVTT: 000000ef
[    8.244531] ... APIC LVTPC: 00010000
[    8.244531] ... APIC LVT0: 00010700
[    8.244531] ... APIC LVT1: 00000400
[    8.244531] ... APIC LVTERR: 000000fe
[    8.244531] ... APIC TMICT: 00034e89
[    8.244531] ... APIC TMCCT: 00000000
[    8.244531] ... APIC TDCR: 00000003
[    8.244531]=20
[    8.271396] number of MP IRQ sources: 15.
[    8.272496] number of IO-APIC #0 registers: 24.
[    8.273666] testing the IO APIC.......................
[    8.274993] IO APIC #0......
[    8.275855] .... register #00: 00000000
[    8.276930] .......    : physical APIC id: 00
[    8.278080] .......    : Delivery Type: 0
[    8.279160] .......    : LTS          : 0
[    8.280257] .... register #01: 00170011
[    8.281318] .......     : max redirection entries: 17
[    8.282598] .......     : PRQ implemented: 0
[    8.283725] .......     : IO APIC version: 11
[    8.284896] .... register #02: 00000000
[    8.285950] .......     : arbitration: 00
[    8.287032] .... IRQ redirection table:
[    8.288133] 1    0    0   0   0    0    0    00
[    8.289330] 0    0    0   0   0    1    1    31
[    8.290522] 0    0    0   0   0    1    1    30
[    8.291718] 0    0    0   0   0    1    1    33
[    8.292945] 1    0    0   0   0    1    1    34
[    8.294143] 1    1    0   0   0    1    1    35
[    8.295336] 0    0    0   0   0    1    1    36
[    8.296539] 0    0    0   0   0    1    1    37
[    8.297734] 0    0    0   0   0    1    1    38
[    8.298939] 0    1    0   0   0    1    1    39
[    8.300151] 1    1    0   0   0    1    1    3A
[    8.301342] 1    1    0   0   0    1    1    3B
[    8.302537] 0    0    0   0   0    1    1    3C
[    8.303730] 0    0    0   0   0    1    1    3D
[    8.304954] 0    0    0   0   0    1    1    3E
[    8.306144] 0    0    0   0   0    1    1    3F
[    8.307341] 1    0    0   0   0    0    0    00
[    8.308589] 1    0    0   0   0    0    0    00
[    8.309789] 1    0    0   0   0    0    0    00
[    8.310988] 1    0    0   0   0    0    0    00
[    8.312193] 1    0    0   0   0    0    0    00
[    8.313389] 1    0    0   0   0    0    0    00
[    8.314588] 1    0    0   0   0    0    0    00
[    8.315782] 1    0    0   0   0    0    0    00
[    8.316992] IRQ to pin mappings:
[    8.317923] IRQ0 -> 0:2
[    8.318910] IRQ1 -> 0:1
[    8.319902] IRQ3 -> 0:3
[    8.320907] IRQ4 -> 0:4
[    8.321895] IRQ5 -> 0:5
[    8.322883] IRQ6 -> 0:6
[    8.323872] IRQ7 -> 0:7
[    8.324835] IRQ8 -> 0:8
[    8.325821] IRQ9 -> 0:9
[    8.326799] IRQ10 -> 0:10
[    8.327813] IRQ11 -> 0:11
[    8.328878] IRQ12 -> 0:12
[    8.329881] IRQ13 -> 0:13
[    8.330882] IRQ14 -> 0:14
[    8.331883] IRQ15 -> 0:15
[    8.332901] .................................... done.
[    8.334264] registered taskstats version 1
[    8.335454] Key type encrypted registered
[    8.337076] hd: no drives specified - use hd=3Dcyl,head,sectors on kerne=
l command line
[    8.339183] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    8.340703] ALSA device list:
[    8.341573]   #0: Internal PC-Speaker at port 0x61
[    8.343518] Freeing unused kernel memory: 1036k freed
[    8.345255] Write protecting the kernel read-only data: 18432k
[    8.347853] Freeing unused kernel memory: 464k freed
[    8.350452] Freeing unused kernel memory: 616k freed
[    8.508690] init: Failed to create pty - disabling logging for job
[    8.510245] init: Temporary process spawn error: No such file or directo=
ry
[    8.536972] init: Failed to create pty - disabling logging for job
[    8.538526] init: Temporary process spawn error: No such file or directo=
ry
[    8.587755] init: mounted-tmp main process (136) terminated with status =
32
[    8.606007] init: Failed to create pty - disabling logging for job
[    8.607559] init: Temporary process spawn error: No such file or directo=
ry
[    8.620225] init: Failed to create pty - disabling logging for job
[    8.621798] init: Temporary process spawn error: No such file or directo=
ry
[    8.637122] init: Failed to create pty - disabling logging for job
[    8.638879] init: Temporary process spawn error: No such file or directo=
ry
[    8.653427] init: Failed to create pty - disabling logging for job
[    8.654972] init: Temporary process spawn error: No such file or directo=
ry
[    8.656962] udevd[166]: starting version 175
[    8.688306] init: Failed to create pty - disabling logging for job
[    8.689859] init: Temporary process spawn error: No such file or directo=
ry
[    8.697997] init: Failed to create pty - disabling logging for job
[    8.699543] init: Temporary process spawn error: No such file or directo=
ry
[    8.707302] init: plymouth-log main process (172) terminated with status=
 1
[    8.925427] init: Re-executing /init
[    9.987117] Unregister pv shared memory for cpu 0
[   10.010796] Restarting system.
[   10.011679] reboot: machine restart
Elapsed time: 15
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /tmp//kernel/x86_64-randc=
onfig-c25-0701/af15f8de4f3a7b28e3a2c2064ad74106767516ca/vmlinuz-3.10.0-wl-0=
6036-gaf15f8d-28183 -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_time=
out=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug d=
ynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/ke=
rnel-tests/run-queue/kvm/x86_64-randconfig-c25-0701/devel-cairo-x86_64-2013=
07012240/.vmlinuz-af15f8de4f3a7b28e3a2c2064ad74106767516ca-20130701233130-9=
-bay branch=3Dlinux-devel/devel-cairo-x86_64-201307012240  BOOT_IMAGE=3D/ke=
rnel/x86_64-randconfig-c25-0701/af15f8de4f3a7b28e3a2c2064ad74106767516ca/vm=
linuz-3.10.0-wl-06036-gaf15f8d'  -initrd /kernel-tests/initrd/quantal-core-=
x86_64.cgz -m 256M -smp 2 -net nic,vlan=3D0,macaddr=3D00:00:00:00:00:00,mod=
el=3Dvirtio -net user,vlan=3D0,hostfwd=3Dtcp::32279-:22 -net nic,vlan=3D1,m=
odel=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300=
esb -soundhw hda -drive file=3D/fs/sda3/diska-bay-28183,media=3Ddisk,if=3Dv=
irtio -drive file=3D/fs/sda3/diskb-bay-28183,media=3Ddisk,if=3Dvirtio -driv=
e file=3D/fs/sda3/diskc-bay-28183,media=3Ddisk,if=3Dvirtio -drive file=3D/f=
s/sda3/diskd-bay-28183,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sda3/disk=
e-bay-28183,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sda3/diskf-bay-28183=
,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-bay-lkp-28183 -serial=
 file:/dev/shm/kboot/serial-bay-lkp-28183 -daemonize -display none -monitor=
 null=20

--zYM0uCDKw75PZbzx
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-af15f8de4f3a7b28e3a2c2064ad74106767516ca-x86_64-randconfig-c25-0701-fc_init+-x-63002.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgYWYxNWY4ZC4uLiBNZXJnZSByZW1vdGUtdHJh
Y2tpbmcgYnJhbmNoICd4bG54L3p5bnEvY2xrJyBpbnRvIGRldmVsLWNhaXJvLXg4Nl82NC0y
MDEzMDcwMTIyNDAKSEVBRCBpcyBub3cgYXQgOGJiNDk1ZS4uLiBMaW51eCAzLjEwCmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcw
MS9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxMzA3MDEyMjQwOjhiYjQ5NWUz
ZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzY6YmlzZWN0LXVzYgoKMjAxMy0wNy0w
My0xMDo0MjoxMSA4YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2IHJl
dXNlIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvOGJiNDk1ZTNmMDI0MDFl
ZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni92bWxpbnV6LTMuMTAuMAoKMjAxMy0wNy0wMy0x
MDo0MjoxMSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMjEJMjcJMjkJMzcJNTMJNjAgU1VDQ0VT
UwoKYmlzZWN0OiBnb29kIGNvbW1pdCA4YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2Fj
OWYwNzllMzc2CmdpdCBiaXNlY3Qgc3RhcnQgYWYxNWY4ZGU0ZjNhN2IyOGUzYTJjMjA2NGFk
NzQxMDY3Njc1MTZjYSA4YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2
IC0tClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDhiYjQ5NWUuLi4gTGludXggMy4xMApI
RUFEIGlzIG5vdyBhdCBjMWJlNWE1Li4uIExpbnV4IDMuOQpCaXNlY3Rpbmc6IDMwMzQgcmV2
aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEyIHN0ZXBzKQpbNDJk
NDA4MTFiZjdmOTdiNmI3OTg2YmIxMTdmMzMxMDI0M2Q5MWZmZV0gTWVyZ2UgcmVtb3RlLXRy
YWNraW5nIGJyYW5jaCAnam9zZWYtYnRyZnMvbWFzdGVyJyBpbnRvIGRldmVsLWNhaXJvLXg4
Nl82NC0yMDEzMDcwMTIyNDAKZ2l0IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2Vj
dC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dm
Zy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2
XzY0LXJhbmRjb25maWctYzI1LTA3MDEvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0
LTIwMTMwNzAxMjI0MDo0MmQ0MDgxMWJmN2Y5N2I2Yjc5ODZiYjExN2YzMzEwMjQzZDkxZmZl
OmJpc2VjdC11c2IKCjIwMTMtMDctMDMtMTA6NDU6MzAgNDJkNDA4MTFiZjdmOTdiNmI3OTg2
YmIxMTdmMzMxMDI0M2Q5MWZmZSBjb21waWxpbmcKNjM2IHJlYWwgIDE1NDkgdXNlciAgMTI2
IHN5cyAgMjYzLjQwJSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxCgoyMDEzLTA3
LTAzLTEwOjU3OjM2IGRldGVjdGluZyBib290IHN0YXRlIDMuMTAuMC0wMzYxNS1nNDJkNDA4
MS4JMjAJMjcJMzgJNTgJNjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxNTc1IHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMSBzdGVwcykKWzY4N2UyODYwMGM0
ZWI3NzM3YzAzNmRhYTVjNzg3MjI3YjNkMWJiMDFdIE1lcmdlIHJlbW90ZS10cmFja2luZyBi
cmFuY2ggJ3Njc2kvZm9yLW5leHQnIGludG8gZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMwNzAx
MjI0MApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9saW51eC1kZXZlbDpkZXZlbC1j
YWlyby14ODZfNjQtMjAxMzA3MDEyMjQwOjY4N2UyODYwMGM0ZWI3NzM3YzAzNmRhYTVjNzg3
MjI3YjNkMWJiMDE6YmlzZWN0LXVzYgoKMjAxMy0wNy0wMy0xMTowMDozOSA2ODdlMjg2MDBj
NGViNzczN2MwMzZkYWE1Yzc4NzIyN2IzZDFiYjAxIGNvbXBpbGluZwoyMzkgcmVhbCAgMTUz
MSB1c2VyICAxMjQgc3lzICA2OTAuMjUlIGNwdSAJeDg2XzY0LXJhbmRjb25maWctYzI1LTA3
MDEKCjIwMTMtMDctMDMtMTE6MDU6MjMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMC4wLTA1
MDc0LWc2ODdlMjg2LiBURVNUIEZBSUxVUkUKWyAgICA4Ljc5NTYxOV0gZm1jX3dyaXRlX2Vl
cHJvbSBmYWtlLWRlc2lnbi1mb3ItdGVzdGluZy1mMDAxOiBmbWNfd3JpdGVfZWVwcm9tOiBu
byBidXNpZCBwYXNzZWQsIHJlZnVzaW5nIGFsbCBjYXJkcwpbICAgIDguNzk4MTgzXSBmbWMg
ZmFrZS1kZXNpZ24tZm9yLXRlc3RpbmctZjAwMTogRHJpdmVyIGhhcyBubyBJRDogbWF0Y2hl
cyBhbGwKWyAgICA4Ljc5OTgwNF0gQlVHOiBzY2hlZHVsaW5nIHdoaWxlIGF0b21pYzogc3dh
cHBlci8xLzB4MTAwMDAwMDIKWyAgICA4LjgwMTMzNV0gQ1BVOiAwIFBJRDogMSBDb21tOiBz
d2FwcGVyIE5vdCB0YWludGVkIDMuMTAuMC0wNTA3NC1nNjg3ZTI4NiAjMTIxClsgICAgOC44
MDMxNjNdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIw
MTEKWyAgICA4LjgwNDYwMF0gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAwZGM1YmIwMCBm
ZmZmZmZmZjgxYjc0NWI1IGZmZmY4ODAwMGRjNWJiMTAKWyAgICA4LjgwNjg3OF0gIGZmZmZm
ZmZmODFiNzA2OGIgZmZmZjg4MDAwZGM1YmI3MCBmZmZmZmZmZjgxYjdjZTdlIGZmZmY4ODAw
MGRjNWJiMzAKWyAgICA4LjgwOTQxM10gIGZmZmY4ODAwMGRjNWJmZDggZmZmZjg4MDAwZGM1
YmZkOCBmZmZmODgwMDBkYzViZmQ4IGZmZmY4ODAwMGRjNWJmZDgKWyAgICA4LjgxMTc1OF0g
Q2FsbCBUcmFjZToKWyAgICA4LjgxMjU3NF0gIFs8ZmZmZmZmZmY4MWI3NDViNT5dIGR1bXBf
c3RhY2srMHgxOS8weDFiClsgICAgOC44MTM4MzFdICBbPGZmZmZmZmZmODFiNzA2OGI+XSBf
X3NjaGVkdWxlX2J1ZysweDQyLzB4NTAKWyAgICA4LjgxNTEyMV0gIFs8ZmZmZmZmZmY4MWI3
Y2U3ZT5dIF9fc2NoZWR1bGUrMHg1MGUvMHg1MjAKWyAgICA4LjgxNjUxM10gIFs8ZmZmZmZm
ZmY4MTBkOTIyMD5dIF9fY29uZF9yZXNjaGVkKzB4MjAvMHgzMApbICAgIDguODE3OTI4XSAg
WzxmZmZmZmZmZjgxYjdkMDIzPl0gX2NvbmRfcmVzY2hlZCsweDMzLzB4NDAKWyAgICA4Ljgx
OTIwMl0gIFs8ZmZmZmZmZmY4MWI3ZDMxYT5dIHdhaXRfZm9yX2NvbXBsZXRpb24rMHgyYS8w
eDE0MApbICAgIDguODIwNjgyXSAgWzxmZmZmZmZmZjgxMGQ5MWU1Pl0gPyBjaGVja19wcmVl
bXB0X2N1cnIrMHg4NS8weGEwClsgICAgOC44MjIwOTRdICBbPGZmZmZmZmZmODE1YzMwMjQ+
XSBkZXZ0bXBmc19jcmVhdGVfbm9kZSsweGY0LzB4MTMwClsgICAgOC44MjM1NDNdICBbPGZm
ZmZmZmZmODE1YmIxNWU+XSBkZXZpY2VfYWRkKzB4MjNlLzB4NmYwClsgICAgOC44MjQ4NzJd
ICBbPGZmZmZmZmZmODE1YmMwMTA+XSBkZXZpY2VfY3JlYXRlX3ZhcmdzKzB4ZDAvMHgxMDAK
WyAgICA4LjgyNjI4OV0gIFs8ZmZmZmZmZmY4MTViYzA2Zj5dIGRldmljZV9jcmVhdGUrMHgy
Zi8weDQwClsgICAgOC44Mjc3MDNdICBbPGZmZmZmZmZmODFiN2JmNDA+XSA/IG11dGV4X2xv
Y2srMHgyMC8weDMwClsgICAgOC44MjkwMzVdICBbPGZmZmZmZmZmODE1ODcwMjY+XSBtaXNj
X3JlZ2lzdGVyKzB4YzYvMHgxMjAKWyAgICA4LjgzMDM1NF0gIFs8ZmZmZmZmZmY4MTkyN2Ez
OD5dIGZjX3Byb2JlKzB4OTgvMHgxNDAKWyAgICA4LjgzMTYxNl0gIFs8ZmZmZmZmZmY4MTky
NThlMj5dIGZtY19wcm9iZSsweDEyLzB4MjAKWyAgICA4LjgzMjkyNV0gIFs8ZmZmZmZmZmY4
MTViZWFhMj5dIHJlYWxseV9wcm9iZSsweDUyLzB4MWYwClsgICAgOC44MzQxOTBdICBbPGZm
ZmZmZmZmODE1YmVkNDE+XSBfX2RyaXZlcl9hdHRhY2grMHg5MS8weGEwClsgICAgOC44MzU1
NjRdICBbPGZmZmZmZmZmODE1YmVjYjA+XSA/IF9fZGV2aWNlX2F0dGFjaCsweDUwLzB4NTAK
WyAgICA4LjgzNzA4N10gIFs8ZmZmZmZmZmY4MTViY2ZhMz5dIGJ1c19mb3JfZWFjaF9kZXYr
MHg2My8weGEwClsgICAgOC44Mzg1MDldICBbPGZmZmZmZmZmODE1YmU5ZDk+XSBkcml2ZXJf
YXR0YWNoKzB4MTkvMHgyMApbICAgIDguODM5ODI2XSAgWzxmZmZmZmZmZjgxNWJkOWU4Pl0g
YnVzX2FkZF9kcml2ZXIrMHgxYzgvMHgyNjAKWyAgICA4Ljg0MTI3OF0gIFs8ZmZmZmZmZmY4
MTkyNzk2MD5dID8gZmNfcmVhZCsweGIwLzB4YjAKWyAgICA4Ljg0MjQ5Nl0gIFs8ZmZmZmZm
ZmY4MTViZjRlZj5dIGRyaXZlcl9yZWdpc3RlcisweDZmLzB4MTUwClsgICAgOC44NDM4NjFd
ICBbPGZmZmZmZmZmODE5Mjc5NjA+XSA/IGZjX3JlYWQrMHhiMC8weGIwClsgICAgOC44NDUx
NjNdICBbPGZmZmZmZmZmODE5MjVhODA+XSBmbWNfZHJpdmVyX3JlZ2lzdGVyKzB4MzAvMHg0
MApbICAgIDguODQ2NTM4XSAgWzxmZmZmZmZmZjgxOTI3OTcwPl0gZmNfaW5pdCsweDEwLzB4
MjAKWyAgICA4Ljg0NzkxNV0gIFs8ZmZmZmZmZmY4MjM3MWZlYj5dIGRvX29uZV9pbml0Y2Fs
bCsweDc5LzB4MTE3ClsgICAgOC44NDkyNzJdICBbPGZmZmZmZmZmODIzNzIxODQ+XSBrZXJu
ZWxfaW5pdF9mcmVlYWJsZSsweGZiLzB4MTdjClsgICAgOC44NTA2ODZdICBbPGZmZmZmZmZm
ODIzNzE4ODE+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4ODgvMHg4OApbICAgIDguODUyMTIyXSAg
WzxmZmZmZmZmZjgxYjZhMzMwPl0gPyByZXN0X2luaXQrMHg5MC8weDkwClsgICAgOC44NTMz
NzVdICBbPGZmZmZmZmZmODFiNmEzMzk+XSBrZXJuZWxfaW5pdCsweDkvMHgxODAKWyAgICA4
Ljg1NDYzNV0gIFs8ZmZmZmZmZmY4MWI3ZjEzYT5dIHJldF9mcm9tX2ZvcmsrMHg3YS8weGIw
ClsgICAgOC44NTU5ODZdICBbPGZmZmZmZmZmODFiNmEzMzA+XSA/IHJlc3RfaW5pdCsweDkw
LzB4OTAKWyAgICA4Ljg1NzQ5N10gZm1jX2NoYXJkZXYgZmFrZS1kZXNpZ24tZm9yLXRlc3Rp
bmctZjAwMTogQ3JlYXRlZCBtaXNjIGRldmljZSAiZmFrZS1kZXNpZ24tZm9yLXRlc3Rpbmct
ZjAwMSIKWyAgICA4Ljg1OTgwN10gQXVkaW8gRXhjZWwgRFNQIDE2IGluaXQgZHJpdmVyIENv
cHlyaWdodCAoQykgUmljY2FyZG8gRmFjY2hldHRpIDE5OTUtOTgKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1jMjUtMDcwMS82ODdlMjg2MDBjNGViNzczN2MwMzZkYWE1Yzc4NzIyN2Iz
ZDFiYjAxL2RtZXNnLWt2bS12cC0xMjA5Ny0yMDEzMDcwMzExMDcwMi0zLjEwLjAtMDUwNzQt
ZzY4N2UyODYtMTIxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvNjg3ZTI4
NjAwYzRlYjc3MzdjMDM2ZGFhNWM3ODcyMjdiM2QxYmIwMS9kbWVzZy1rdm0tdnAtMTQ1Mzgt
MjAxMzA3MDMxMTA3MTAtMy4xMC4wLXJjMS0wMDI3My1nNWY3M2ZjMC0yMwova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxLzY4N2UyODYwMGM0ZWI3NzM3YzAzNmRhYTVjNzg3
MjI3YjNkMWJiMDEvZG1lc2cta3ZtLXZwLTI2NDQzLTIwMTMwNzAzMTEwNzA5LTMuMTAuMC1y
YzctMDA3MjctZzlhYzY2ZDktMjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcw
MS82ODdlMjg2MDBjNGViNzczN2MwMzZkYWE1Yzc4NzIyN2IzZDFiYjAxL2RtZXNnLWt2bS12
cC02NzEwLTIwMTMwNzAzMTEwNzEwLTMuMTAuMC1yYzctMDA3MjctZzlhYzY2ZDktNDAKCkJp
c2VjdGluZzogNzIwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hs
eSAxMCBzdGVwcykKWzk5ZjllMDFiZjg3ZDRiOGRhNjhmZDc3OTViMGYwNWFiNzY3Yjk4MmVd
IE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ202OGsvbTY4ay1xdWV1ZScgaW50byBk
ZXZlbC1jYWlyby14ODZfNjQtMjAxMzA3MDEyMjQwCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMy
NS0wNzAxL2xpbnV4LWRldmVsOmRldmVsLWNhaXJvLXg4Nl82NC0yMDEzMDcwMTIyNDA6OTlm
OWUwMWJmODdkNGI4ZGE2OGZkNzc5NWIwZjA1YWI3NjdiOTgyZTpiaXNlY3QtdXNiCgoyMDEz
LTA3LTAzLTExOjA1OjU3IDk5ZjllMDFiZjg3ZDRiOGRhNjhmZDc3OTViMGYwNWFiNzY3Yjk4
MmUgY29tcGlsaW5nCjIwMiByZWFsICAxNTE5IHVzZXIgIDEyNiBzeXMgIDgxNC44NSUgY3B1
IAl4ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMQoKMjAxMy0wNy0wMy0xMTowOTozNCBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAzLjEwLjAtMDQzNTMtZzk5ZjllMDEJMwkyMgk0MQk2MCBTVUND
RVNTCgpCaXNlY3Rpbmc6IDM1OCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgOSBzdGVwcykKWzgwZDE2MmM2NmJjNjE1OWVmYTY3NDA2ZDM0NzU3ODU3NjI4
YzVjMDJdIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ3BpbmNoYXJ0bC1mYmRldi9i
b2FyZHMvZXRoZXJuZXQnIGludG8gZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMwNzAxMjI0MApy
dW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hv
bWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2
bS94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14
ODZfNjQtMjAxMzA3MDEyMjQwOjgwZDE2MmM2NmJjNjE1OWVmYTY3NDA2ZDM0NzU3ODU3NjI4
YzVjMDI6YmlzZWN0LXVzYgoKMjAxMy0wNy0wMy0xMToxMTozNSA4MGQxNjJjNjZiYzYxNTll
ZmE2NzQwNmQzNDc1Nzg1NzYyOGM1YzAyIGNvbXBpbGluZwoxODYgcmVhbCAgMTUyNSB1c2Vy
ICAxMzAgc3lzICA4ODcuNTIlIGNwdSAJeDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEKCjIw
MTMtMDctMDMtMTE6MTU6MTIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMC4wLTA0NzE1LWc4
MGQxNjJjLgk1CTEwCTIzCTM5CTQ5Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLhtb
MTszNW1hZGRfdG9fcnVuX3F1ZXVlIDExG1swbQoJNTAJNTQuLi4uLgk1NQk2MCBTVUNDRVNT
CgpCaXNlY3Rpbmc6IDE2MSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgOCBzdGVwcykKWzAyYjEyYzU4ODk3ZDFiMjVhZDUyZWY1YzgxYjI5NDA5YWU1ZTkx
NjldIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ2dyZWdraC1jaGFyLW1pc2MvY2hh
ci1taXNjLW5leHQnIGludG8gcG9zdG1lcmdlLWJhc2UKcnVubmluZyAvYy9rZXJuZWwtdGVz
dHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2Vj
dApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWct
YzI1LTA3MDEvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMwNzAxMjI0MDow
MmIxMmM1ODg5N2QxYjI1YWQ1MmVmNWM4MWIyOTQwOWFlNWU5MTY5OmJpc2VjdC11c2IKCjIw
MTMtMDctMDMtMTM6NTM6MzIgMDJiMTJjNTg4OTdkMWIyNWFkNTJlZjVjODFiMjk0MDlhZTVl
OTE2OSBjb21waWxpbmcKMjQwIHJlYWwgIDE1MjQgdXNlciAgMTMzIHN5cyAgNjg4Ljc3JSBj
cHUgCXg4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxCgoyMDEzLTA3LTAzLTEzOjU3OjQ3IGRl
dGVjdGluZyBib290IHN0YXRlIDMuMTAuMC1yYzYtMDA0ODEtZzAyYjEyYzUuLi4gVEVTVCBG
QUlMVVJFClsgICAgOC4xNzUyNDddIGZtY193cml0ZV9lZXByb20gZmFrZS1kZXNpZ24tZm9y
LXRlc3RpbmctZjAwMTogZm1jX3dyaXRlX2VlcHJvbTogbm8gYnVzaWQgcGFzc2VkLCByZWZ1
c2luZyBhbGwgY2FyZHMKWyAgICA4LjE3NzcxMV0gZm1jIGZha2UtZGVzaWduLWZvci10ZXN0
aW5nLWYwMDE6IERyaXZlciBoYXMgbm8gSUQ6IG1hdGNoZXMgYWxsClsgICAgOC4xNzkzMzBd
IEJVRzogc2NoZWR1bGluZyB3aGlsZSBhdG9taWM6IHN3YXBwZXIvMS8weDEwMDAwMDAyClsg
ICAgOC4xODA3NDBdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAz
LjEwLjAtcmM2LTAwNDgxLWcwMmIxMmM1ICMxMjQKWyAgICA4LjE4MjY2Nl0gSGFyZHdhcmUg
bmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDguMTg0MDcz
XSAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDBkYzViYjAwIGZmZmZmZmZmODFiNjljMDEg
ZmZmZjg4MDAwZGM1YmIxMApbICAgIDguMTg2Mzk5XSAgZmZmZmZmZmY4MWI2NWY0MSBmZmZm
ODgwMDBkYzViYjcwIGZmZmZmZmZmODFiNzIyOGUgZmZmZjg4MDAwZGM1YmIzMApbICAgIDgu
MTg4NzM4XSAgZmZmZjg4MDAwZGM1YmZkOCBmZmZmODgwMDBkYzViZmQ4IGZmZmY4ODAwMGRj
NWJmZDggZmZmZjg4MDAwZGM1YmZkOApbICAgIDguMTkxMDc1XSBDYWxsIFRyYWNlOgpbICAg
IDguMTkxODUzXSAgWzxmZmZmZmZmZjgxYjY5YzAxPl0gZHVtcF9zdGFjaysweDE5LzB4MWIK
WyAgICA4LjE5MzE0Ml0gIFs8ZmZmZmZmZmY4MWI2NWY0MT5dIF9fc2NoZWR1bGVfYnVnKzB4
NDIvMHg1MApbICAgIDguMTk0NDcyXSAgWzxmZmZmZmZmZjgxYjcyMjhlPl0gX19zY2hlZHVs
ZSsweDUwZS8weDUyMApbICAgIDguMTk1NzYzXSAgWzxmZmZmZmZmZjgxMGQ5NWUwPl0gX19j
b25kX3Jlc2NoZWQrMHgyMC8weDMwClsgICAgOC4xOTcxNjFdICBbPGZmZmZmZmZmODFiNzI0
MzM+XSBfY29uZF9yZXNjaGVkKzB4MzMvMHg0MApbICAgIDguMTk4NDgwXSAgWzxmZmZmZmZm
ZjgxYjcyNzJhPl0gd2FpdF9mb3JfY29tcGxldGlvbisweDJhLzB4MTQwClsgICAgOC4xOTk5
MDhdICBbPGZmZmZmZmZmODEwZDk1YTU+XSA/IGNoZWNrX3ByZWVtcHRfY3VycisweDg1LzB4
YTAKWyAgICA4LjIwMTM2N10gIFs8ZmZmZmZmZmY4MTViZmI4ND5dIGRldnRtcGZzX2NyZWF0
ZV9ub2RlKzB4ZjQvMHgxMzAKWyAgICA4LjIwMjgxMF0gIFs8ZmZmZmZmZmY4MTViODA0ZT5d
IGRldmljZV9hZGQrMHgyM2UvMHg2YjAKWyAgICA4LjIwNDEyNF0gIFs8ZmZmZmZmZmY4MTVi
OGM1MD5dIGRldmljZV9jcmVhdGVfdmFyZ3MrMHhkMC8weDEwMApbICAgIDguMjA1NTQyXSAg
WzxmZmZmZmZmZjgxNWI4Y2FmPl0gZGV2aWNlX2NyZWF0ZSsweDJmLzB4NDAKWyAgICA4LjIw
Njg1OV0gIFs8ZmZmZmZmZmY4MWI3MTUxMD5dID8gbXV0ZXhfbG9jaysweDIwLzB4MzAKWyAg
ICA4LjIwODE3MV0gIFs8ZmZmZmZmZmY4MTU4NGEwNj5dIG1pc2NfcmVnaXN0ZXIrMHhjNi8w
eDEyMApbICAgIDguMjA5NTAxXSAgWzxmZmZmZmZmZjgxOTFlMjE4Pl0gZmNfcHJvYmUrMHg5
OC8weDE0MApbICAgIDguMjEwNzQwXSAgWzxmZmZmZmZmZjgxOTFjMGMyPl0gZm1jX3Byb2Jl
KzB4MTIvMHgyMApbICAgIDguMjExOTkwXSAgWzxmZmZmZmZmZjgxNWJiNjMyPl0gcmVhbGx5
X3Byb2JlKzB4NTIvMHgxZjAKWyAgICA4LjIxMzMzN10gIFs8ZmZmZmZmZmY4MTViYjhkMT5d
IF9fZHJpdmVyX2F0dGFjaCsweDkxLzB4YTAKWyAgICA4LjIxNDY5MF0gIFs8ZmZmZmZmZmY4
MTViYjg0MD5dID8gX19kZXZpY2VfYXR0YWNoKzB4NTAvMHg1MApbICAgIDguMjE2MTM0XSAg
WzxmZmZmZmZmZjgxNWI5YmQzPl0gYnVzX2Zvcl9lYWNoX2RldisweDYzLzB4YTAKWyAgICA4
LjIxNzQ5N10gIFs8ZmZmZmZmZmY4MTViYjU2OT5dIGRyaXZlcl9hdHRhY2grMHgxOS8weDIw
ClsgICAgOC4yMTg4MDddICBbPGZmZmZmZmZmODE1YmE1Yjg+XSBidXNfYWRkX2RyaXZlcisw
eDFiOC8weDI1MApbICAgIDguMjIwMTg1XSAgWzxmZmZmZmZmZjgxOTFlMTQwPl0gPyBmY19y
ZWFkKzB4YjAvMHhiMApbICAgIDguMjIxNDQyXSAgWzxmZmZmZmZmZjgxNWJjMDVjPl0gZHJp
dmVyX3JlZ2lzdGVyKzB4NmMvMHgxNTAKWyAgICA4LjIyMjgwNF0gIFs8ZmZmZmZmZmY4MTkx
ZTE0MD5dID8gZmNfcmVhZCsweGIwLzB4YjAKWyAgICA4LjIyNDA3N10gIFs8ZmZmZmZmZmY4
MTkxYzI2MD5dIGZtY19kcml2ZXJfcmVnaXN0ZXIrMHgzMC8weDQwClsgICAgOC4yMjU0ODJd
ICBbPGZmZmZmZmZmODE5MWUxNTA+XSBmY19pbml0KzB4MTAvMHgyMApbICAgIDguMjI2NzAx
XSAgWzxmZmZmZmZmZjgyMzcwZmU2Pl0gZG9fb25lX2luaXRjYWxsKzB4NzkvMHgxMTcKWyAg
ICA4LjIyODA3Ml0gIFs8ZmZmZmZmZmY4MjM3MTE3Zj5dIGtlcm5lbF9pbml0X2ZyZWVhYmxl
KzB4ZmIvMHgxN2MKWyAgICA4LjIyOTUyMV0gIFs8ZmZmZmZmZmY4MjM3MDg4MT5dID8gZG9f
ZWFybHlfcGFyYW0rMHg4OC8weDg4ClsgICAgOC4yMzA4OTJdICBbPGZmZmZmZmZmODFiNWZh
YjA+XSA/IHJlc3RfaW5pdCsweDkwLzB4OTAKWyAgICA4LjIzMjE4N10gIFs8ZmZmZmZmZmY4
MWI1ZmFiOT5dIGtlcm5lbF9pbml0KzB4OS8weDE4MApbICAgIDguMjMzNDY5XSAgWzxmZmZm
ZmZmZjgxYjc0NTNhPl0gcmV0X2Zyb21fZm9yaysweDdhLzB4YjAKWyAgICA4LjIzNDc5MF0g
IFs8ZmZmZmZmZmY4MWI1ZmFiMD5dID8gcmVzdF9pbml0KzB4OTAvMHg5MApbICAgIDguMjM2
MTQwXSBmbWNfY2hhcmRldiBmYWtlLWRlc2lnbi1mb3ItdGVzdGluZy1mMDAxOiBDcmVhdGVk
IG1pc2MgZGV2aWNlICJmYWtlLWRlc2lnbi1mb3ItdGVzdGluZy1mMDAxIgpbICAgIDguMjM4
NDg3XSBBdWRpbyBFeGNlbCBEU1AgMTYgaW5pdCBkcml2ZXIgQ29weXJpZ2h0IChDKSBSaWNj
YXJkbyBGYWNjaGV0dGkgMTk5NS05OAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0w
NzAxLzAyYjEyYzU4ODk3ZDFiMjVhZDUyZWY1YzgxYjI5NDA5YWU1ZTkxNjkvZG1lc2cta3Zt
LXZwLTI2NzQ0LTIwMTMwNzAzMTM1OTM3LTMuMTAuMC1yYzctMDAxOTQtZzViMGUyZTUtMTgK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS8wMmIxMmM1ODg5N2QxYjI1YWQ1
MmVmNWM4MWIyOTQwOWFlNWU5MTY5L2RtZXNnLWt2bS12cC0xMTI2NC0yMDEzMDcwMzEzNTk1
MC0zLjEwLjAtcmMxLTAwNTI1LWdhNTFkODFjLTM1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctYzI1LTA3MDEvMDJiMTJjNTg4OTdkMWIyNWFkNTJlZjVjODFiMjk0MDlhZTVlOTE2OS9k
bWVzZy1rdm0tYmF5LTI4MTgzLTIwMTMwNzAzMTQwMDQ1LTMuMTAuMC1yYzYtMDA0ODEtZzAy
YjEyYzUtMTI0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvMDJiMTJjNTg4
OTdkMWIyNWFkNTJlZjVjODFiMjk0MDlhZTVlOTE2OS9kbWVzZy1rdm0tYmF5LTI4MTgzLTIw
MTMwNzAzMTQwMTA1LTMuMTAuMC1yYzYtMDA0ODEtZzAyYjEyYzUtMTI0Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctYzI1LTA3MDEvMDJiMTJjNTg4OTdkMWIyNWFkNTJlZjVjODFiMjk0
MDlhZTVlOTE2OS9kbWVzZy1rdm0tYmVucy0zMjI4LTIwMTMwNzAzMTM1NzEzLTMuMTAuMC0w
NDcxNS1nODBkMTYyYy0xMjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS8w
MmIxMmM1ODg5N2QxYjI1YWQ1MmVmNWM4MWIyOTQwOWFlNWU5MTY5L2RtZXNnLWt2bS14Ym0t
MjQxODYtMjAxMzA3MDMxNDAwNTEtMy4xMC4wLXJjNi0wMDQ4MS1nMDJiMTJjNS0xMjQKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS8wMmIxMmM1ODg5N2QxYjI1YWQ1MmVm
NWM4MWIyOTQwOWFlNWU5MTY5L2RtZXNnLWt2bS14Ym0tMjQxODYtMjAxMzA3MDMxNDAxMTMt
My4xMC4wLXJjNi0wMDQ4MS1nMDJiMTJjNS0xMjQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1jMjUtMDcwMS8wMmIxMmM1ODg5N2QxYjI1YWQ1MmVmNWM4MWIyOTQwOWFlNWU5MTY5L2Rt
ZXNnLWt2bS14Ym0tMzI4MS0yMDEzMDcwMzE0MDA1Mi0zLjEwLjAtcmM3LTAwMTk0LWc1YjBl
MmU1LTE4Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvMDJiMTJjNTg4OTdk
MWIyNWFkNTJlZjVjODFiMjk0MDlhZTVlOTE2OS9kbWVzZy1rdm0tdnAtMjc4ODgtMjAxMzA3
MDMxMzU5MzctMy4xMC4wLXJjNy0wMDE5NC1nNWIwZTJlNS0xMgova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWMyNS0wNzAxLzAyYjEyYzU4ODk3ZDFiMjVhZDUyZWY1YzgxYjI5NDA5YWU1
ZTkxNjkvZG1lc2cta3ZtLXZwLTI4NDY3LTIwMTMwNzAzMTM1OTM5LTMuMTAuMC0wMDc5NS1n
NzVmZjU2YS02Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvMDJiMTJjNTg4
OTdkMWIyNWFkNTJlZjVjODFiMjk0MDlhZTVlOTE2OS9kbWVzZy1rdm0tYmVucy0zNjM2LTIw
MTMwNzAzMTM1NzE4LTMuMTAuMC1yYzYtMDA0ODEtZzAyYjEyYzUtMTI0Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctYzI1LTA3MDEvMDJiMTJjNTg4OTdkMWIyNWFkNTJlZjVjODFiMjk0
MDlhZTVlOTE2OS9kbWVzZy1rdm0tdnAtMTI3NDYtMjAxMzA3MDMxMzU5MzQtMy4xMC4wLTAw
MDkxLWdmYzdlZDg4LTEyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvMDJi
MTJjNTg4OTdkMWIyNWFkNTJlZjVjODFiMjk0MDlhZTVlOTE2OS9kbWVzZy1rdm0tdnAtMTMw
MzYtMjAxMzA3MDMxMzU5MzUtMy4xMC4wLXJjNS0wMDE2NC1nNTY1YWM5MS0yNgova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxLzAyYjEyYzU4ODk3ZDFiMjVhZDUyZWY1Yzgx
YjI5NDA5YWU1ZTkxNjkvZG1lc2cta3ZtLXZwLTEzNTM3LTIwMTMwNzAzMTM1OTM0LTMuMTAu
MC1yYzYtMDA4MDUtZzY2OWQ2YTItMTQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUt
MDcwMS8wMmIxMmM1ODg5N2QxYjI1YWQ1MmVmNWM4MWIyOTQwOWFlNWU5MTY5L2RtZXNnLWt2
bS14Z3dvLTExNDM5LTIwMTMwNzAzMTM1NzMxLTMuMTAuMC1yYzYtMDA0ODEtZzAyYjEyYzUt
MTI0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvMDJiMTJjNTg4OTdkMWIy
NWFkNTJlZjVjODFiMjk0MDlhZTVlOTE2OS9kbWVzZy1rdm0teGd3by0xMTQzOS0yMDEzMDcw
MzEzNTc1Ny0zLjEwLjAtcmM2LTAwNDgxLWcwMmIxMmM1LTEyNAova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWMyNS0wNzAxLzAyYjEyYzU4ODk3ZDFiMjVhZDUyZWY1YzgxYjI5NDA5YWU1
ZTkxNjkvZG1lc2cta3ZtLWJlbnMtMzc2MC0yMDEzMDcwMzEzNTcxOC0zLjEwLjAtcmM3LTAw
MTk0LWc1YjBlMmU1LTcKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS8wMmIx
MmM1ODg5N2QxYjI1YWQ1MmVmNWM4MWIyOTQwOWFlNWU5MTY5L2RtZXNnLWt2bS12cC0xNDgw
NS0yMDEzMDcwMzEzNTkzNy0zLjEwLjAtcmM2LTAxMjg2LWcyM2EzNjQ3LTMyCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvMDJiMTJjNTg4OTdkMWIyNWFkNTJlZjVjODFi
Mjk0MDlhZTVlOTE2OS9kbWVzZy1rdm0teGd3by0xMTg3NS0yMDEzMDcwMzEzNTc1NS0zLjEw
LjAtcmMxLTAwNTI1LWdhNTFkODFjLTM0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1
LTA3MDEvMDJiMTJjNTg4OTdkMWIyNWFkNTJlZjVjODFiMjk0MDlhZTVlOTE2OS9kbWVzZy1r
dm0tdnAtMTUzNDUtMjAxMzA3MDMxMzU5MzUtMy4xMC4wLXJjNy0wMDE5NC1nNWIwZTJlNS03
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvMDJiMTJjNTg4OTdkMWIyNWFk
NTJlZjVjODFiMjk0MDlhZTVlOTE2OS9kbWVzZy1rdm0teGd3by0xNjk3LTIwMTMwNzAzMTM1
NzU2LTMuMTAuMC1yYzEtMDA1MjUtZ2E1MWQ4MWMtMzUKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1jMjUtMDcwMS8wMmIxMmM1ODg5N2QxYjI1YWQ1MmVmNWM4MWIyOTQwOWFlNWU5MTY5
L2RtZXNnLWt2bS12cC01MTEyLTIwMTMwNzAzMTM1OTQ4LTMuMTAuMC0wMzI5Ni1nMGIwNTg1
Yy0yOAoKQmlzZWN0aW5nOiA5OCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgNyBzdGVwcykKWzM0Y2IyNzUyODM5ODczOGJlYTk0ODUyYjk5ZWY4ZmIwNTk0
NGVjNDFdIFVJTzogRml4IGNvbmN1cnJlbmN5IGlzc3VlCnJ1bm5pbmcgL2Mva2VybmVsLXRl
c3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNl
Y3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmln
LWMyNS0wNzAxL2xpbnV4LWRldmVsOmRldmVsLWNhaXJvLXg4Nl82NC0yMDEzMDcwMTIyNDA6
MzRjYjI3NTI4Mzk4NzM4YmVhOTQ4NTJiOTllZjhmYjA1OTQ0ZWM0MTpiaXNlY3QtdXNiCgoy
MDEzLTA3LTAzLTEzOjU5OjE5IDM0Y2IyNzUyODM5ODczOGJlYTk0ODUyYjk5ZWY4ZmIwNTk0
NGVjNDEgY29tcGlsaW5nCjE4MiByZWFsICAxNTI0IHVzZXIgIDEzOSBzeXMgIDkxMS45MSUg
Y3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMQoKMjAxMy0wNy0wMy0xNDowMjozMCBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEwLjAtcmM2LTAwMzgyLWczNGNiMjc1LiBURVNUIEZB
SUxVUkUKWyAgICA3Ljk5MTEwMF0gZm1jX3dyaXRlX2VlcHJvbSBmYWtlLWRlc2lnbi1mb3It
dGVzdGluZy1mMDAxOiBmbWNfd3JpdGVfZWVwcm9tOiBubyBidXNpZCBwYXNzZWQsIHJlZnVz
aW5nIGFsbCBjYXJkcwpbICAgIDcuOTkzNTc1XSBmbWMgZmFrZS1kZXNpZ24tZm9yLXRlc3Rp
bmctZjAwMTogRHJpdmVyIGhhcyBubyBJRDogbWF0Y2hlcyBhbGwKWyAgICA3Ljk5NTE4Nl0g
QlVHOiBzY2hlZHVsaW5nIHdoaWxlIGF0b21pYzogc3dhcHBlci8xLzB4MTAwMDAwMDIKWyAg
ICA3Ljk5NjU5NV0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMu
MTAuMC1yYzYtMDAzODItZzM0Y2IyNzUgIzEyNQpbICAgIDcuOTk4NTA2XSBIYXJkd2FyZSBu
YW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgNy45OTk4NzVd
ICAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMGRjNWJiMDAgZmZmZmZmZmY4MWI2OTlhMSBm
ZmZmODgwMDBkYzViYjEwClsgICAgOC4wMDIxOTldICBmZmZmZmZmZjgxYjY1Y2UxIGZmZmY4
ODAwMGRjNWJiNzAgZmZmZmZmZmY4MWI3MjAyZSBmZmZmODgwMDBkYzViYjMwClsgICAgOC4w
MDQ1MjZdICBmZmZmODgwMDBkYzViZmQ4IGZmZmY4ODAwMGRjNWJmZDggZmZmZjg4MDAwZGM1
YmZkOCBmZmZmODgwMDBkYzViZmQ4ClsgICAgOC4wMDY4MjldIENhbGwgVHJhY2U6ClsgICAg
OC4wMDc2MDFdICBbPGZmZmZmZmZmODFiNjk5YTE+XSBkdW1wX3N0YWNrKzB4MTkvMHgxYgpb
ICAgIDguMDA4ODcyXSAgWzxmZmZmZmZmZjgxYjY1Y2UxPl0gX19zY2hlZHVsZV9idWcrMHg0
Mi8weDUwClsgICAgOC4wMTAxODldICBbPGZmZmZmZmZmODFiNzIwMmU+XSBfX3NjaGVkdWxl
KzB4NTBlLzB4NTIwClsgICAgOC4wMTE0NzVdICBbPGZmZmZmZmZmODEwZDk1ZTA+XSBfX2Nv
bmRfcmVzY2hlZCsweDIwLzB4MzAKWyAgICA4LjAxMjg1MF0gIFs8ZmZmZmZmZmY4MWI3MjFk
Mz5dIF9jb25kX3Jlc2NoZWQrMHgzMy8weDQwClsgICAgOC4wMTQxNTRdICBbPGZmZmZmZmZm
ODFiNzI0Y2E+XSB3YWl0X2Zvcl9jb21wbGV0aW9uKzB4MmEvMHgxNDAKWyAgICA4LjAxNTYy
Nl0gIFs8ZmZmZmZmZmY4MTBkOTVhNT5dID8gY2hlY2tfcHJlZW1wdF9jdXJyKzB4ODUvMHhh
MApbICAgIDguMDE3MDgyXSAgWzxmZmZmZmZmZjgxNWJmYjk0Pl0gZGV2dG1wZnNfY3JlYXRl
X25vZGUrMHhmNC8weDEzMApbICAgIDguMDE4NTQxXSAgWzxmZmZmZmZmZjgxNWI4MDVlPl0g
ZGV2aWNlX2FkZCsweDIzZS8weDZiMApbICAgIDguMDE5ODQ3XSAgWzxmZmZmZmZmZjgxNWI4
YzYwPl0gZGV2aWNlX2NyZWF0ZV92YXJncysweGQwLzB4MTAwClsgICAgOC4wMjEzMDddICBb
PGZmZmZmZmZmODE1YjhjYmY+XSBkZXZpY2VfY3JlYXRlKzB4MmYvMHg0MApbICAgIDguMDIy
NjM2XSAgWzxmZmZmZmZmZjgxYjcxMmIwPl0gPyBtdXRleF9sb2NrKzB4MjAvMHgzMApbICAg
IDguMDIzOTQ2XSAgWzxmZmZmZmZmZjgxNTg0YTE2Pl0gbWlzY19yZWdpc3RlcisweGM2LzB4
MTIwClsgICAgOC4wMjUzMjFdICBbPGZmZmZmZmZmODE5MWRmYjg+XSBmY19wcm9iZSsweDk4
LzB4MTQwClsgICAgOC4wMjY1NzZdICBbPGZmZmZmZmZmODE5MWJlNjI+XSBmbWNfcHJvYmUr
MHgxMi8weDIwClsgICAgOC4wMjc4MTldICBbPGZmZmZmZmZmODE1YmI2NDI+XSByZWFsbHlf
cHJvYmUrMHg1Mi8weDFmMApbICAgIDguMDI5MTUxXSAgWzxmZmZmZmZmZjgxNWJiOGUxPl0g
X19kcml2ZXJfYXR0YWNoKzB4OTEvMHhhMApbICAgIDguMDMwNTAzXSAgWzxmZmZmZmZmZjgx
NWJiODUwPl0gPyBfX2RldmljZV9hdHRhY2grMHg1MC8weDUwClsgICAgOC4wMzE4NzddICBb
PGZmZmZmZmZmODE1YjliZTM+XSBidXNfZm9yX2VhY2hfZGV2KzB4NjMvMHhhMApbICAgIDgu
MDMzMjkzXSAgWzxmZmZmZmZmZjgxNWJiNTc5Pl0gZHJpdmVyX2F0dGFjaCsweDE5LzB4MjAK
WyAgICA4LjAzNDYxMF0gIFs8ZmZmZmZmZmY4MTViYTVjOD5dIGJ1c19hZGRfZHJpdmVyKzB4
MWI4LzB4MjUwClsgICAgOC4wMzU5NjNdICBbPGZmZmZmZmZmODE5MWRlZTA+XSA/IGZjX3Jl
YWQrMHhiMC8weGIwClsgICAgOC4wMzcyNDJdICBbPGZmZmZmZmZmODE1YmMwNmM+XSBkcml2
ZXJfcmVnaXN0ZXIrMHg2Yy8weDE1MApbICAgIDguMDM4NjEzXSAgWzxmZmZmZmZmZjgxOTFk
ZWUwPl0gPyBmY19yZWFkKzB4YjAvMHhiMApbICAgIDguMDM5ODY2XSAgWzxmZmZmZmZmZjgx
OTFjMDAwPl0gZm1jX2RyaXZlcl9yZWdpc3RlcisweDMwLzB4NDAKWyAgICA4LjA0MTI5OF0g
IFs8ZmZmZmZmZmY4MTkxZGVmMD5dIGZjX2luaXQrMHgxMC8weDIwClsgICAgOC4wNDI1MTdd
ICBbPGZmZmZmZmZmODIzNzBmZTY+XSBkb19vbmVfaW5pdGNhbGwrMHg3OS8weDExNwpbICAg
IDguMDQzODc4XSAgWzxmZmZmZmZmZjgyMzcxMTdmPl0ga2VybmVsX2luaXRfZnJlZWFibGUr
MHhmYi8weDE3YwpbICAgIDguMDQ1MzUyXSAgWzxmZmZmZmZmZjgyMzcwODgxPl0gPyBkb19l
YXJseV9wYXJhbSsweDg4LzB4ODgKWyAgICA4LjA0NjcyNF0gIFs8ZmZmZmZmZmY4MWI1Zjg1
MD5dID8gcmVzdF9pbml0KzB4OTAvMHg5MApbICAgIDguMDQ4MDIwXSAgWzxmZmZmZmZmZjgx
YjVmODU5Pl0ga2VybmVsX2luaXQrMHg5LzB4MTgwClsgICAgOC4wNDkzMDRdICBbPGZmZmZm
ZmZmODFiNzQyYmE+XSByZXRfZnJvbV9mb3JrKzB4N2EvMHhiMApbICAgIDguMDUwNjE5XSAg
WzxmZmZmZmZmZjgxYjVmODUwPl0gPyByZXN0X2luaXQrMHg5MC8weDkwClsgICAgOC4wNTE5
MTNdIGZtY19jaGFyZGV2IGZha2UtZGVzaWduLWZvci10ZXN0aW5nLWYwMDE6IENyZWF0ZWQg
bWlzYyBkZXZpY2UgImZha2UtZGVzaWduLWZvci10ZXN0aW5nLWYwMDEiClsgICAgOC4wNTQz
MzBdIEF1ZGlvIEV4Y2VsIERTUCAxNiBpbml0IGRyaXZlciBDb3B5cmlnaHQgKEMpIFJpY2Nh
cmRvIEZhY2NoZXR0aSAxOTk1LTk4Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3
MDEvMzRjYjI3NTI4Mzk4NzM4YmVhOTQ4NTJiOTllZjhmYjA1OTQ0ZWM0MS9kbWVzZy1rdm0t
YmF5LTEwNjc1LTIwMTMwNzAzMTQwNTM2LTMuMTAuMC1yYzYtMDAzODItZzM0Y2IyNzUtMTI1
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvMzRjYjI3NTI4Mzk4NzM4YmVh
OTQ4NTJiOTllZjhmYjA1OTQ0ZWM0MS9kbWVzZy1rdm0tcm9hbS0yMzMyNS0yMDEzMDcwMzE0
MDU0OC0zLjEwLjAtcmM2LTAwMzgyLWczNGNiMjc1LTEyNQova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWMyNS0wNzAxLzM0Y2IyNzUyODM5ODczOGJlYTk0ODUyYjk5ZWY4ZmIwNTk0NGVj
NDEvZG1lc2cta3ZtLXZwLTE2MjE3LTIwMTMwNzAzMTQwNDExLTMuMTAuMC1yYzYtMDAzODIt
ZzM0Y2IyNzUtMTI1CgpCaXNlY3Rpbmc6IDQ4IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0
ZXIgdGhpcyAocm91Z2hseSA2IHN0ZXBzKQpbNGNkNTc3M2EyYWU2ZmFjZGRlM2Y1NjMwODdh
NGNjNTBmMDBkOTUzMF0gbmV0OiBjb3JlOiBtb3ZlIG1hY19wdG9uKCkgdG8gbGliL25ldF91
dGlscy5jCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVy
ZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4t
cXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2xpbnV4LWRldmVsOmRldmVs
LWNhaXJvLXg4Nl82NC0yMDEzMDcwMTIyNDA6NGNkNTc3M2EyYWU2ZmFjZGRlM2Y1NjMwODdh
NGNjNTBmMDBkOTUzMDpiaXNlY3QtdXNiCgoyMDEzLTA3LTAzLTE0OjAzOjA0IDRjZDU3NzNh
MmFlNmZhY2RkZTNmNTYzMDg3YTRjYzUwZjAwZDk1MzAgY29tcGlsaW5nCjE4OCByZWFsICAx
NTIxIHVzZXIgIDEzNiBzeXMgIDg4MS4zOCUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1jMjUt
MDcwMQoKMjAxMy0wNy0wMy0xNDowNjoyNSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEwLjAt
cmMzLTAwMDQ5LWc0Y2Q1NzczLi4JNgk0Nwk2MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDI0IHJl
dmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA1IHN0ZXBzKQpbZTMx
YzUxZTRhMWQxMWVkMGI2MTU1N2NhOWRhOWNmMThjODg1NTUzMV0gdm1lOiB0c2kxNDg6IE9u
bHkgc3RvcmUgVk1FIGJ1cyBlcnJvcnMgaWYgdGhleSB3aWxsIGJlIGNoZWNrZWQKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dm
Zy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2
XzY0LXJhbmRjb25maWctYzI1LTA3MDEvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0
LTIwMTMwNzAxMjI0MDplMzFjNTFlNGExZDExZWQwYjYxNTU3Y2E5ZGE5Y2YxOGM4ODU1NTMx
OmJpc2VjdC11c2IKCjIwMTMtMDctMDMtMTQ6MDg6NTcgZTMxYzUxZTRhMWQxMWVkMGI2MTU1
N2NhOWRhOWNmMThjODg1NTUzMSBjb21waWxpbmcKMTkyIHJlYWwgIDE1MTAgdXNlciAgMTMz
IHN5cyAgODU1LjU0JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxCgoyMDEzLTA3
LTAzLTE0OjEyOjIxIGRldGVjdGluZyBib290IHN0YXRlIDMuMTAuMC1yYzYtMDAzNTctZ2Uz
MWM1MWUuLgkzMAk0Nwk1NAk2MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDEyIHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA0IHN0ZXBzKQpbMDU2ZDgzZjNjMzBj
Mzk4ZjE0ZWI4NzlmMWQxNzA3ZTNhNzgwOGY0YV0gRk1DOiBhZGQgYSBzb2Z0d2FyZSBtZXp6
YW5pbmUgZHJpdmVyCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2xpbnV4LWRldmVs
OmRldmVsLWNhaXJvLXg4Nl82NC0yMDEzMDcwMTIyNDA6MDU2ZDgzZjNjMzBjMzk4ZjE0ZWI4
NzlmMWQxNzA3ZTNhNzgwOGY0YTpiaXNlY3QtdXNiCgoyMDEzLTA3LTAzLTE0OjE1OjIyIDA1
NmQ4M2YzYzMwYzM5OGYxNGViODc5ZjFkMTcwN2UzYTc4MDhmNGEgY29tcGlsaW5nCjE4NyBy
ZWFsICAxNTE1IHVzZXIgIDEzOCBzeXMgIDg3OS45NyUgY3B1IAl4ODZfNjQtcmFuZGNvbmZp
Zy1jMjUtMDcwMQoKMjAxMy0wNy0wMy0xNDoxODozOSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAz
LjEwLjAtcmM2LTAwMzY5LWcwNTZkODNmLgkxNAkyMgk1MQk2MCBTVUNDRVNTCgpCaXNlY3Rp
bmc6IDYgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3Rl
cHMpCltjMjk1NWRhMGUxMDFjMzQzMmFlMjE5NDVlNWQ3Nzc4NmFkZjFmMDk0XSBmbWM6IGF2
b2lkIHJlYWRsL3dyaXRlbCBuYW1lc3BhY2UgY29uZmxpY3QKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJp
c2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25m
aWctYzI1LTA3MDEvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMwNzAxMjI0
MDpjMjk1NWRhMGUxMDFjMzQzMmFlMjE5NDVlNWQ3Nzc4NmFkZjFmMDk0OmJpc2VjdC11c2IK
CjIwMTMtMDctMDMtMTQ6MjE6MTAgYzI5NTVkYTBlMTAxYzM0MzJhZTIxOTQ1ZTVkNzc3ODZh
ZGYxZjA5NCBjb21waWxpbmcKMTgyIHJlYWwgIDE1MjYgdXNlciAgMTQyIHN5cyAgOTE2LjQ1
JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxCgoyMDEzLTA3LTAzLTE0OjI0OjIx
IGRldGVjdGluZyBib290IHN0YXRlIDMuMTAuMC1yYzYtMDAzNzUtZ2MyOTU1ZGEuLiBURVNU
IEZBSUxVUkUKWyAgIDEwLjYwODgzN10gZm1jX3dyaXRlX2VlcHJvbSBmYWtlLWRlc2lnbi1m
b3ItdGVzdGluZy1mMDAxOiBmbWNfd3JpdGVfZWVwcm9tOiBubyBidXNpZCBwYXNzZWQsIHJl
ZnVzaW5nIGFsbCBjYXJkcwpbICAgMTAuNjE1MzE1XSBmbWMgZmFrZS1kZXNpZ24tZm9yLXRl
c3RpbmctZjAwMTogRHJpdmVyIGhhcyBubyBJRDogbWF0Y2hlcyBhbGwKWyAgIDEwLjYyNjAz
M10gQlVHOiBzY2hlZHVsaW5nIHdoaWxlIGF0b21pYzogc3dhcHBlci8xLzB4MTAwMDAwMDIK
WyAgIDEwLjYyNzcxM10gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVk
IDMuMTAuMC1yYzYtMDAzNzUtZ2MyOTU1ZGEgIzEyOQpbICAgMTAuNjMwMDEwXSBIYXJkd2Fy
ZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAxMC42MzE2
MzRdICAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMGRjNWJiMDggZmZmZmZmZmY4MWI2OTk1
MSBmZmZmODgwMDBkYzViYjE4ClsgICAxMC42MzQzOTRdICBmZmZmZmZmZjgxYjY1YzkxIGZm
ZmY4ODAwMGRjNWJiNzggZmZmZmZmZmY4MWI3MWZkZSBmZmZmODgwMDBkYzViYjM4ClsgICAx
MC42NDkzMDZdICBmZmZmODgwMDBkYzViZmQ4IGZmZmY4ODAwMGRjNWJmZDggZmZmZjg4MDAw
ZGM1YmZkOCBmZmZmODgwMDBkYzViZmQ4ClsgICAxMC42NTIwNjJdIENhbGwgVHJhY2U6Clsg
ICAxMC42NTI5NjNdICBbPGZmZmZmZmZmODFiNjk5NTE+XSBkdW1wX3N0YWNrKzB4MTkvMHgx
YgpbICAgMTAuNjU0NDU4XSAgWzxmZmZmZmZmZjgxYjY1YzkxPl0gX19zY2hlZHVsZV9idWcr
MHg0Mi8weDUwClsgICAxMC42NTYwNTJdICBbPGZmZmZmZmZmODFiNzFmZGU+XSBfX3NjaGVk
dWxlKzB4NTBlLzB4NTIwClsgICAxMC42NTc1ODFdICBbPGZmZmZmZmZmODEwZDk1ZTA+XSBf
X2NvbmRfcmVzY2hlZCsweDIwLzB4MzAKWyAgIDEwLjY3MTI0OF0gIFs8ZmZmZmZmZmY4MWI3
MjE4Mz5dIF9jb25kX3Jlc2NoZWQrMHgzMy8weDQwClsgICAxMC42NzI4MDhdICBbPGZmZmZm
ZmZmODFiNzI0N2E+XSB3YWl0X2Zvcl9jb21wbGV0aW9uKzB4MmEvMHgxNDAKWyAgIDEwLjY3
NDQ3Nl0gIFs8ZmZmZmZmZmY4MTBkOTVhNT5dID8gY2hlY2tfcHJlZW1wdF9jdXJyKzB4ODUv
MHhhMApbICAgMTAuNjc2MTczXSAgWzxmZmZmZmZmZjgxNWJmYjg0Pl0gZGV2dG1wZnNfY3Jl
YXRlX25vZGUrMHhmNC8weDEzMApbICAgMTAuNjc3ODc4XSAgWzxmZmZmZmZmZjgxNWI4MDRl
Pl0gZGV2aWNlX2FkZCsweDIzZS8weDZiMApbICAgMTAuNjc5MzkyXSAgWzxmZmZmZmZmZjgx
NWI4YzUwPl0gZGV2aWNlX2NyZWF0ZV92YXJncysweGQwLzB4MTAwClsgICAxMC42OTMyODVd
ICBbPGZmZmZmZmZmODE1YjhjYWY+XSBkZXZpY2VfY3JlYXRlKzB4MmYvMHg0MApbICAgMTAu
Njk0ODM1XSAgWzxmZmZmZmZmZjgxYjcxMjYwPl0gPyBtdXRleF9sb2NrKzB4MjAvMHgzMApb
ICAgMTAuNjk2Mzg2XSAgWzxmZmZmZmZmZjgxNTg0YTA2Pl0gbWlzY19yZWdpc3RlcisweGM2
LzB4MTIwClsgICAxMC42OTc5NjNdICBbPGZmZmZmZmZmODE5MWRmODc+XSBmY19wcm9iZSsw
eDg3LzB4MTEwClsgICAxMC42OTk0NDNdICBbPGZmZmZmZmZmODE5MWJlNDI+XSBmbWNfcHJv
YmUrMHgxMi8weDIwClsgICAxMC43MDI0MTRdICBbPGZmZmZmZmZmODE1YmI2MzI+XSByZWFs
bHlfcHJvYmUrMHg1Mi8weDFmMApbICAgMTAuNzA1MzA1XSAgWzxmZmZmZmZmZjgxNWJiOGQx
Pl0gX19kcml2ZXJfYXR0YWNoKzB4OTEvMHhhMApbICAgMTAuNzA4MjI0XSAgWzxmZmZmZmZm
ZjgxNWJiODQwPl0gPyBfX2RldmljZV9hdHRhY2grMHg1MC8weDUwClsgICAxMC43MTA1MTRd
ICBbPGZmZmZmZmZmODE1YjliZDM+XSBidXNfZm9yX2VhY2hfZGV2KzB4NjMvMHhhMApbICAg
MTAuNzEyMTczXSAgWzxmZmZmZmZmZjgxNWJiNTY5Pl0gZHJpdmVyX2F0dGFjaCsweDE5LzB4
MjAKWyAgIDEwLjcxMzcyMF0gIFs8ZmZmZmZmZmY4MTViYTViOD5dIGJ1c19hZGRfZHJpdmVy
KzB4MWI4LzB4MjUwClsgICAxMC43MTUzMjFdICBbPGZmZmZmZmZmODE5MWRlYzA+XSA/IGZj
X3JlYWQrMHhiMC8weGIwClsgICAxMC43MTY4MTddICBbPGZmZmZmZmZmODE1YmMwNWM+XSBk
cml2ZXJfcmVnaXN0ZXIrMHg2Yy8weDE1MApbICAgMTAuNzE4NDEzXSAgWzxmZmZmZmZmZjgx
OTFkZWMwPl0gPyBmY19yZWFkKzB4YjAvMHhiMApbICAgMTAuNzIwMDU5XSAgWzxmZmZmZmZm
ZjgxOTFiZmUwPl0gZm1jX2RyaXZlcl9yZWdpc3RlcisweDMwLzB4NDAKWyAgIDEwLjcyMzA4
MV0gIFs8ZmZmZmZmZmY4MTkxZGVkMD5dIGZjX2luaXQrMHgxMC8weDIwClsgICAxMC43MjU3
MzddICBbPGZmZmZmZmZmODIzNzBmZTY+XSBkb19vbmVfaW5pdGNhbGwrMHg3OS8weDExNwpb
ICAgMTAuNzI4Njg1XSAgWzxmZmZmZmZmZjgyMzcxMTdmPl0ga2VybmVsX2luaXRfZnJlZWFi
bGUrMHhmYi8weDE3YwpbICAgMTAuNzMwODYzXSAgWzxmZmZmZmZmZjgyMzcwODgxPl0gPyBk
b19lYXJseV9wYXJhbSsweDg4LzB4ODgKWyAgIDEwLjczMjUxN10gIFs8ZmZmZmZmZmY4MWI1
ZjgwMD5dID8gcmVzdF9pbml0KzB4OTAvMHg5MApbICAgMTAuNzM0MDIyXSAgWzxmZmZmZmZm
ZjgxYjVmODA5Pl0ga2VybmVsX2luaXQrMHg5LzB4MTgwClsgICAxMC43MzU1NDFdICBbPGZm
ZmZmZmZmODFiNzQyN2E+XSByZXRfZnJvbV9mb3JrKzB4N2EvMHhiMApbICAgMTAuNzM3MTEw
XSAgWzxmZmZmZmZmZjgxYjVmODAwPl0gPyByZXN0X2luaXQrMHg5MC8weDkwClsgICAxMC43
Mzg2NzBdIGZtY19jaGFyZGV2IGZha2UtZGVzaWduLWZvci10ZXN0aW5nLWYwMDE6IENyZWF0
ZWQgbWlzYyBkZXZpY2UgImZha2UtZGVzaWduLWZvci10ZXN0aW5nLWYwMDEiClsgICAxMC43
NDI4OTZdIEF1ZGlvIEV4Y2VsIERTUCAxNiBpbml0IGRyaXZlciBDb3B5cmlnaHQgKEMpIFJp
Y2NhcmRvIEZhY2NoZXR0aSAxOTk1LTk4Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1
LTA3MDEvYzI5NTVkYTBlMTAxYzM0MzJhZTIxOTQ1ZTVkNzc3ODZhZGYxZjA5NC9kbWVzZy1r
dm0tYmVucy00NDUyLTIwMTMwNzAzMTQyNDExLTMuMTAuMC0wMDI4OS1nYmFkYzgxOC0yOAov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2MyOTU1ZGEwZTEwMWMzNDMyYWUy
MTk0NWU1ZDc3Nzg2YWRmMWYwOTQvZG1lc2cta3ZtLXZwLTczNzgtMjAxMzA3MDMxNDI2MTgt
My42LjAtNTgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9jMjk1NWRhMGUx
MDFjMzQzMmFlMjE5NDVlNWQ3Nzc4NmFkZjFmMDk0L2RtZXNnLWt2bS14Z3dvLTE2OTctMjAx
MzA3MDMxNDI0MTgtMy4xMC4wLXJjNi0wMDM3NS1nYzI5NTVkYS0xMjkKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9jMjk1NWRhMGUxMDFjMzQzMmFlMjE5NDVlNWQ3Nzc4
NmFkZjFmMDk0L2RtZXNnLWt2bS12cC04MTY1LTIwMTMwNzAzMTQyNTU4LTMuNy4wLXJjNC0w
MDE1Mi1nMTU4MmVlYS01Ngova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2My
OTU1ZGEwZTEwMWMzNDMyYWUyMTk0NWU1ZDc3Nzg2YWRmMWYwOTQvZG1lc2cta3ZtLXZwLTgx
NjUtMjAxMzA3MDMxNDI2MTYtMy43LjAtcmM0LTAwMTUyLWcxNTgyZWVhLTU2Ci9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvYzI5NTVkYTBlMTAxYzM0MzJhZTIxOTQ1ZTVk
Nzc3ODZhZGYxZjA5NC9kbWVzZy1rdm0tdnAtMTM1MzctMjAxMzA3MDMxNDI2MTctMy4xMC4w
LXJjMS0wMDI3NC1nN2QyMDRiNi0yNgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0w
NzAxL2MyOTU1ZGEwZTEwMWMzNDMyYWUyMTk0NWU1ZDc3Nzg2YWRmMWYwOTQvZG1lc2cta3Zt
LXZwLTEzOTYyLTIwMTMwNzAzMTQyNjAxLTMuMTAuMC1yYzQtMDAwMDMtZzU3MDBmNzQtNTkK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9jMjk1NWRhMGUxMDFjMzQzMmFl
MjE5NDVlNWQ3Nzc4NmFkZjFmMDk0L2RtZXNnLWt2bS14Z3dvLTE3MTEtMjAxMzA3MDMxNDI0
MjAtMy4xMC4wLXJjNy0wMDE5NC1nNWIwZTJlNS03Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctYzI1LTA3MDEvYzI5NTVkYTBlMTAxYzM0MzJhZTIxOTQ1ZTVkNzc3ODZhZGYxZjA5NC9k
bWVzZy1rdm0tdnAtMTM5NjItMjAxMzA3MDMxNDI2MTQtMy4xMC4wLXJjNC0wMDAwMy1nNTcw
MGY3NC01OQoKQmlzZWN0aW5nOiAyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSAyIHN0ZXBzKQpbMDVjM2UwYmI1NjI5Yjg5N2IwNDU5ZTRiZmIxYjkzZDcy
OTAzM2I5OV0gVUlPOiBhbGxvdyBiaW5kaW5nIHVpb19wZHJ2X2dlbmlycS5jIHRvIGRldmlj
ZXMgdXNpbmcgY29tbWFuZCBsaW5lIG9wdGlvbgpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0Cmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMjUt
MDcwMS9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxMzA3MDEyMjQwOjA1YzNl
MGJiNTYyOWI4OTdiMDQ1OWU0YmZiMWI5M2Q3MjkwMzNiOTk6YmlzZWN0LXVzYgoKMjAxMy0w
Ny0wMy0xNDoyNToyNSAwNWMzZTBiYjU2MjliODk3YjA0NTllNGJmYjFiOTNkNzI5MDMzYjk5
IGNvbXBpbGluZwoxODUgcmVhbCAgMTUyMSB1c2VyICAxNDUgc3lzICA5MDAuMTElIGNwdSAJ
eDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEKCjIwMTMtMDctMDMtMTQ6Mjg6NDAgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgMy4xMC4wLXJjNi0wMDM3Mi1nMDVjM2UwYi4uIFRFU1QgRkFJTFVS
RQpbICAgMTEuMzMyMjAwXSBmbWNfd3JpdGVfZWVwcm9tIGZha2UtZGVzaWduLWZvci10ZXN0
aW5nLWYwMDE6IGZtY193cml0ZV9lZXByb206IG5vIGJ1c2lkIHBhc3NlZCwgcmVmdXNpbmcg
YWxsIGNhcmRzClsgICAxMS4zNDQ2ODJdIGZtYyBmYWtlLWRlc2lnbi1mb3ItdGVzdGluZy1m
MDAxOiBEcml2ZXIgaGFzIG5vIElEOiBtYXRjaGVzIGFsbApbICAgMTEuMzQ2OTIzXSBCVUc6
IHNjaGVkdWxpbmcgd2hpbGUgYXRvbWljOiBzd2FwcGVyLzEvMHgxMDAwMDAwMgpbICAgMTEu
MzQ4OTExXSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xMC4w
LXJjNi0wMDM3Mi1nMDVjM2UwYiAjMTMwClsgICAxMS4zNTE1MzJdIEhhcmR3YXJlIG5hbWU6
IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgIDExLjM1MzQzNl0gIDAw
MDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAwZGM1YmIwOCBmZmZmZmZmZjgxYjY5OTUxIGZmZmY4
ODAwMGRjNWJiMTgKWyAgIDExLjM1OTM0Ml0gIGZmZmZmZmZmODFiNjVjOTEgZmZmZjg4MDAw
ZGM1YmI3OCBmZmZmZmZmZjgxYjcxZmRlIGZmZmY4ODAwMGRjNWJiMzgKWyAgIDExLjM2NTc5
MV0gIGZmZmY4ODAwMGRjNWJmZDggZmZmZjg4MDAwZGM1YmZkOCBmZmZmODgwMDBkYzViZmQ4
IGZmZmY4ODAwMGRjNWJmZDgKWyAgIDExLjM3MjMyN10gQ2FsbCBUcmFjZToKWyAgIDExLjM3
NDM5M10gIFs8ZmZmZmZmZmY4MWI2OTk1MT5dIGR1bXBfc3RhY2srMHgxOS8weDFiClsgICAx
MS4zNzgwNDFdICBbPGZmZmZmZmZmODFiNjVjOTE+XSBfX3NjaGVkdWxlX2J1ZysweDQyLzB4
NTAKWyAgIDExLjM4MzQ3NV0gIFs8ZmZmZmZmZmY4MWI3MWZkZT5dIF9fc2NoZWR1bGUrMHg1
MGUvMHg1MjAKWyAgIDExLjM4NTI2NV0gIFs8ZmZmZmZmZmY4MTBkOTVlMD5dIF9fY29uZF9y
ZXNjaGVkKzB4MjAvMHgzMApbICAgMTEuMzg5MDUwXSAgWzxmZmZmZmZmZjgxYjcyMTgzPl0g
X2NvbmRfcmVzY2hlZCsweDMzLzB4NDAKWyAgIDExLjM5MjczNl0gIFs8ZmZmZmZmZmY4MWI3
MjQ3YT5dIHdhaXRfZm9yX2NvbXBsZXRpb24rMHgyYS8weDE0MApbICAgMTEuMzk2Njg5XSAg
WzxmZmZmZmZmZjgxMGQ5NWE1Pl0gPyBjaGVja19wcmVlbXB0X2N1cnIrMHg4NS8weGEwClsg
ICAxMS40MDM1NjldICBbPGZmZmZmZmZmODE1YmZiODQ+XSBkZXZ0bXBmc19jcmVhdGVfbm9k
ZSsweGY0LzB4MTMwClsgICAxMS40MDU1ODldICBbPGZmZmZmZmZmODE1YjgwNGU+XSBkZXZp
Y2VfYWRkKzB4MjNlLzB4NmIwClsgICAxMS40MDgxNDBdICBbPGZmZmZmZmZmODE1YjhjNTA+
XSBkZXZpY2VfY3JlYXRlX3ZhcmdzKzB4ZDAvMHgxMDAKWyAgIDExLjQxMjEzOV0gIFs8ZmZm
ZmZmZmY4MTViOGNhZj5dIGRldmljZV9jcmVhdGUrMHgyZi8weDQwClsgICAxMS40MTU4Mjdd
ICBbPGZmZmZmZmZmODFiNzEyNjA+XSA/IG11dGV4X2xvY2srMHgyMC8weDMwClsgICAxMS40
MTk1MTVdICBbPGZmZmZmZmZmODE1ODRhMDY+XSBtaXNjX3JlZ2lzdGVyKzB4YzYvMHgxMjAK
WyAgIDExLjQyMzI2Ml0gIFs8ZmZmZmZmZmY4MTkxZGY4Nz5dIGZjX3Byb2JlKzB4ODcvMHgx
MTAKWyAgIDExLjQyNjc3NV0gIFs8ZmZmZmZmZmY4MTkxYmUzMj5dIGZtY19wcm9iZSsweDEy
LzB4MjAKWyAgIDExLjQzMDU5NV0gIFs8ZmZmZmZmZmY4MTViYjYzMj5dIHJlYWxseV9wcm9i
ZSsweDUyLzB4MWYwClsgICAxMS40MzQ3NjNdICBbPGZmZmZmZmZmODE1YmI4ZDE+XSBfX2Ry
aXZlcl9hdHRhY2grMHg5MS8weGEwClsgICAxMS40Mzc5NzldICBbPGZmZmZmZmZmODE1YmI4
NDA+XSA/IF9fZGV2aWNlX2F0dGFjaCsweDUwLzB4NTAKWyAgIDExLjQ0MTc3Nl0gIFs8ZmZm
ZmZmZmY4MTViOWJkMz5dIGJ1c19mb3JfZWFjaF9kZXYrMHg2My8weGEwClsgICAxMS40NDU2
MzRdICBbPGZmZmZmZmZmODE1YmI1Njk+XSBkcml2ZXJfYXR0YWNoKzB4MTkvMHgyMApbICAg
MTEuNDUyOTUzXSAgWzxmZmZmZmZmZjgxNWJhNWI4Pl0gYnVzX2FkZF9kcml2ZXIrMHgxYjgv
MHgyNTAKWyAgIDExLjQ1NDgzM10gIFs8ZmZmZmZmZmY4MTkxZGVjMD5dID8gZmNfcmVhZCsw
eGIwLzB4YjAKWyAgIDExLjQ1NjU2Ml0gIFs8ZmZmZmZmZmY4MTViYzA1Yz5dIGRyaXZlcl9y
ZWdpc3RlcisweDZjLzB4MTUwClsgICAxMS40NjE5NTRdICBbPGZmZmZmZmZmODE5MWRlYzA+
XSA/IGZjX3JlYWQrMHhiMC8weGIwClsgICAxMS40NjM2NzldICBbPGZmZmZmZmZmODE5MWJm
ZDA+XSBmbWNfZHJpdmVyX3JlZ2lzdGVyKzB4MzAvMHg0MApbICAgMTEuNDY4NTY1XSAgWzxm
ZmZmZmZmZjgxOTFkZWQwPl0gZmNfaW5pdCsweDEwLzB4MjAKWyAgIDExLjQ3MDU3NF0gIFs8
ZmZmZmZmZmY4MjM3MGZlNj5dIGRvX29uZV9pbml0Y2FsbCsweDc5LzB4MTE3ClsgICAxMS40
NzQ1OTldICBbPGZmZmZmZmZmODIzNzExN2Y+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweGZi
LzB4MTdjClsgICAxMS40NzkxNDldICBbPGZmZmZmZmZmODIzNzA4ODE+XSA/IGRvX2Vhcmx5
X3BhcmFtKzB4ODgvMHg4OApbICAgMTEuNDgyNTIzXSAgWzxmZmZmZmZmZjgxYjVmODAwPl0g
PyByZXN0X2luaXQrMHg5MC8weDkwClsgICAxMS40ODY4NjZdICBbPGZmZmZmZmZmODFiNWY4
MDk+XSBrZXJuZWxfaW5pdCsweDkvMHgxODAKWyAgIDExLjQ4OTQzNF0gIFs8ZmZmZmZmZmY4
MWI3NDI3YT5dIHJldF9mcm9tX2ZvcmsrMHg3YS8weGIwClsgICAxMS40OTQyMjZdICBbPGZm
ZmZmZmZmODFiNWY4MDA+XSA/IHJlc3RfaW5pdCsweDkwLzB4OTAKWyAgIDExLjQ5NjY0N10g
Zm1jX2NoYXJkZXYgZmFrZS1kZXNpZ24tZm9yLXRlc3RpbmctZjAwMTogQ3JlYXRlZCBtaXNj
IGRldmljZSAiZmFrZS1kZXNpZ24tZm9yLXRlc3RpbmctZjAwMSIKWyAgIDExLjUwNjkxNV0g
QXVkaW8gRXhjZWwgRFNQIDE2IGluaXQgZHJpdmVyIENvcHlyaWdodCAoQykgUmljY2FyZG8g
RmFjY2hldHRpIDE5OTUtOTgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS8w
NWMzZTBiYjU2MjliODk3YjA0NTllNGJmYjFiOTNkNzI5MDMzYjk5L2RtZXNnLWt2bS13YWlt
ZWEtNDIyNy0yMDEzMDcwMzE0MzIxNC0zLjEwLjAtcmM3LTAwMTk0LWc1YjBlMmU1LTcKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS8wNWMzZTBiYjU2MjliODk3YjA0NTll
NGJmYjFiOTNkNzI5MDMzYjk5L2RtZXNnLWt2bS1iZW5zLTMzMzgtMjAxMzA3MDMxNDI4MDYt
My4xMC4wLXJjNS0wMDE3OS1nM2M5ZjcyZS0yOQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWMyNS0wNzAxLzA1YzNlMGJiNTYyOWI4OTdiMDQ1OWU0YmZiMWI5M2Q3MjkwMzNiOTkvZG1l
c2cta3ZtLXdhaW1lYS00Njk2LTIwMTMwNzAzMTQzMjE2LTMuMTAuMC1yYzMtMDAwNDktZzRj
ZDU3NzMtMTI2Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvMDVjM2UwYmI1
NjI5Yjg5N2IwNDU5ZTRiZmIxYjkzZDcyOTAzM2I5OS9kbWVzZy1rdm0td2FpbWVhLTQ5OTEt
MjAxMzA3MDMxNDMyMDctMy4xMC4wLXJjNy0wMDE5NC1nNWIwZTJlNS03Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctYzI1LTA3MDEvMDVjM2UwYmI1NjI5Yjg5N2IwNDU5ZTRiZmIxYjkz
ZDcyOTAzM2I5OS9kbWVzZy1rdm0td2FpbWVhLTUxMjMtMjAxMzA3MDMxNDMyMDYtMy4xMC4w
LXJjNi0wMDM3Mi1nMDVjM2UwYi0xMzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUt
MDcwMS8wNWMzZTBiYjU2MjliODk3YjA0NTllNGJmYjFiOTNkNzI5MDMzYjk5L2RtZXNnLWt2
bS13YWltZWEtNTQ3My0yMDEzMDcwMzE0MzIxNS0zLjEwLjAtcmM1LTAwMTc5LWczYzlmNzJl
LTI5Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvMDVjM2UwYmI1NjI5Yjg5
N2IwNDU5ZTRiZmIxYjkzZDcyOTAzM2I5OS9kbWVzZy1rdm0td2FpbWVhLTY2MjItMjAxMzA3
MDMxNDMyMTQtMy4xMC4wLXJjMS0wMDUyNS1nYTUxZDgxYy0zNQova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWMyNS0wNzAxLzA1YzNlMGJiNTYyOWI4OTdiMDQ1OWU0YmZiMWI5M2Q3Mjkw
MzNiOTkvZG1lc2cta3ZtLWJlbnMtMzQ0OS0yMDEzMDcwMzE0MjgxMC0zLjEwLjAtcmM2LTAw
MzU3LWdlMzFjNTFlLTEyNwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxLzA1
YzNlMGJiNTYyOWI4OTdiMDQ1OWU0YmZiMWI5M2Q3MjkwMzNiOTkvZG1lc2cta3ZtLXhnd28t
MTE0MzktMjAxMzA3MDMxNDI4MzgtMy4xMC4wLXJjNi0wMDM3Mi1nMDVjM2UwYi0xMzAKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS8wNWMzZTBiYjU2MjliODk3YjA0NTll
NGJmYjFiOTNkNzI5MDMzYjk5L2RtZXNnLWt2bS14Z3dvLTEzMTkyLTIwMTMwNzAzMTQyODQz
LTMuMTAuMC1yYzctMDAxOTQtZzViMGUyZTUtNwova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWMyNS0wNzAxLzA1YzNlMGJiNTYyOWI4OTdiMDQ1OWU0YmZiMWI5M2Q3MjkwMzNiOTkvZG1l
c2cta3ZtLXhnd28tMTUyOTQtMjAxMzA3MDMxNDI4NDAtMy4xMC4wLXJjNS0wMDE3OS1nM2M5
ZjcyZS0yOQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxLzA1YzNlMGJiNTYy
OWI4OTdiMDQ1OWU0YmZiMWI5M2Q3MjkwMzNiOTkvZG1lc2cta3ZtLXhnd28tMTY5Ny0yMDEz
MDcwMzE0Mjg0Mi0zLjEwLjAtcmMxLTAwMjc0LWc3ZDIwNGI2LTI1Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctYzI1LTA3MDEvMDVjM2UwYmI1NjI5Yjg5N2IwNDU5ZTRiZmIxYjkzZDcy
OTAzM2I5OS9kbWVzZy1rdm0tYmVucy0zNTYxLTIwMTMwNzAzMTQyODExLTMuMTAuMC1yYzIt
MDAyMDItZzk1OTI5MTYtMzUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS8w
NWMzZTBiYjU2MjliODk3YjA0NTllNGJmYjFiOTNkNzI5MDMzYjk5L2RtZXNnLWt2bS1iZW5z
LTM4ODYtMjAxMzA3MDMxNDI4MTAtMy4xMC4wLXJjNi0wMDM3Mi1nMDVjM2UwYi0xMzAKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS8wNWMzZTBiYjU2MjliODk3YjA0NTll
NGJmYjFiOTNkNzI5MDMzYjk5L2RtZXNnLWt2bS1iZW5zLTQyMDctMjAxMzA3MDMxNDI4MDUt
My4xMC4wLXJjNi0wMDM3Mi1nMDVjM2UwYi0xMzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1jMjUtMDcwMS8wNWMzZTBiYjU2MjliODk3YjA0NTllNGJmYjFiOTNkNzI5MDMzYjk5L2Rt
ZXNnLWt2bS1iZW5zLTQ0NTItMjAxMzA3MDMxNDI4MTQtMy4xMC4wLTAwMjg5LWdiYWRjODE4
LTI4Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvMDVjM2UwYmI1NjI5Yjg5
N2IwNDU5ZTRiZmIxYjkzZDcyOTAzM2I5OS9kbWVzZy1rdm0tdnAtMTA2NjAtMjAxMzA3MDMx
NDMwMTctMy4xMC4wLTAwMjg5LWdiYWRjODE4LTI4Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctYzI1LTA3MDEvMDVjM2UwYmI1NjI5Yjg5N2IwNDU5ZTRiZmIxYjkzZDcyOTAzM2I5OS9k
bWVzZy1rdm0tdnAtMTM2NjktMjAxMzA3MDMxNDMwMjItMy4xMC4wLXJjNy0wMDE5NC1nNWIw
ZTJlNS0xMgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxLzA1YzNlMGJiNTYy
OWI4OTdiMDQ1OWU0YmZiMWI5M2Q3MjkwMzNiOTkvZG1lc2cta3ZtLXZwLTE2MjE3LTIwMTMw
NzAzMTQzMDMyLTMuMTAuMC1yYzctMDAxOTQtZzViMGUyZTUtNwova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWMyNS0wNzAxLzA1YzNlMGJiNTYyOWI4OTdiMDQ1OWU0YmZiMWI5M2Q3Mjkw
MzNiOTkvZG1lc2cta3ZtLXZwLTE3MTcyLTIwMTMwNzAzMTQzMDIzLTMuMTAuMC1yYzYtMDEw
NTQtZzAyODkwOTQtMTkKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS8wNWMz
ZTBiYjU2MjliODk3YjA0NTllNGJmYjFiOTNkNzI5MDMzYjk5L2RtZXNnLWt2bS12cC0xODk1
MC0yMDEzMDcwMzE0MzAyMi0zLjEwLjAtcmM2LTAwMzcyLWcwNWMzZTBiLTEzMAova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxLzA1YzNlMGJiNTYyOWI4OTdiMDQ1OWU0YmZi
MWI5M2Q3MjkwMzNiOTkvZG1lc2cta3ZtLXZwLTE5NjM4LTIwMTMwNzAzMTQzMDIzLTMuMTAu
MC1yYzYtMDEwNTItZzM4YWU5MmQtMjAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUt
MDcwMS8wNWMzZTBiYjU2MjliODk3YjA0NTllNGJmYjFiOTNkNzI5MDMzYjk5L2RtZXNnLWt2
bS12cC0yMDg4NC0yMDEzMDcwMzE0MzAyNS0zLjEwLjAtcmM2LTAwMzY5LWcwNTZkODNmLTEy
OAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxLzA1YzNlMGJiNTYyOWI4OTdi
MDQ1OWU0YmZiMWI5M2Q3MjkwMzNiOTkvZG1lc2cta3ZtLXZwLTIxNzE3LTIwMTMwNzAzMTQz
MDMyLTMuMTAuMC1yYzctMDAxOTQtZzViMGUyZTUtNwova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWMyNS0wNzAxLzA1YzNlMGJiNTYyOWI4OTdiMDQ1OWU0YmZiMWI5M2Q3MjkwMzNiOTkv
ZG1lc2cta3ZtLXZwLTIyNDIxLTIwMTMwNzAzMTQzMDIzLTMuMTAuMC1yYzEtMDAyNzMtZzVm
NzNmYzAtMjUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS8wNWMzZTBiYjU2
MjliODk3YjA0NTllNGJmYjFiOTNkNzI5MDMzYjk5L2RtZXNnLWt2bS12cC0yMjYzMy0yMDEz
MDcwMzE0MzAzNC0zLjEwLjAtcmM3LTAwMTk0LWc1YjBlMmU1LTEzCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctYzI1LTA3MDEvMDVjM2UwYmI1NjI5Yjg5N2IwNDU5ZTRiZmIxYjkzZDcy
OTAzM2I5OS9kbWVzZy1rdm0tdnAtMjM1NjEtMjAxMzA3MDMxNDMwMjMtMy4xMC4wLXJjMS0w
MDI3NC1nN2QyMDRiNi0yNgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxLzA1
YzNlMGJiNTYyOWI4OTdiMDQ1OWU0YmZiMWI5M2Q3MjkwMzNiOTkvZG1lc2cta3ZtLXZwLTI0
NTIxLTIwMTMwNzAzMTQzMDIzLTMuMTAuMC0wMDA5MS1nNjNjN2IxYy0xMwova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxLzA1YzNlMGJiNTYyOWI4OTdiMDQ1OWU0YmZiMWI5
M2Q3MjkwMzNiOTkvZG1lc2cta3ZtLXZwLTI3MTczLTIwMTMwNzAzMTQzMDMzLTMuMTAuMC1y
YzUtMDAxNjQtZzU2NWFjOTEtMjYKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcw
MS8wNWMzZTBiYjU2MjliODk3YjA0NTllNGJmYjFiOTNkNzI5MDMzYjk5L2RtZXNnLWt2bS12
cC0yODg4My0yMDEzMDcwMzE0MzAzMS0zLjEwLjAtMDQ3MTUtZzgwZDE2MmMtMTIzCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvMDVjM2UwYmI1NjI5Yjg5N2IwNDU5ZTRi
ZmIxYjkzZDcyOTAzM2I5OS9kbWVzZy1rdm0tdnAtNDY2NS0yMDEzMDcwMzE0MzAyNC0zLjEw
LjAtcmM3LTAwMTk0LWc1YjBlMmU1LTcKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUt
MDcwMS8wNWMzZTBiYjU2MjliODk3YjA0NTllNGJmYjFiOTNkNzI5MDMzYjk5L2RtZXNnLWt2
bS12cC00OTk2LTIwMTMwNzAzMTQzMDM0LTMuNy4wLXJjNC0wMDE1MC1nZTU1YjZhOC01Nwov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxLzA1YzNlMGJiNTYyOWI4OTdiMDQ1
OWU0YmZiMWI5M2Q3MjkwMzNiOTkvZG1lc2cta3ZtLXZwLTY4NjQtMjAxMzA3MDMxNDMwMjMt
My4xMC4wLXJjNi0wMTA1Mi1nMzhhZTkyZC0yMAova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWMyNS0wNzAxLzA1YzNlMGJiNTYyOWI4OTdiMDQ1OWU0YmZiMWI5M2Q3MjkwMzNiOTkvZG1l
c2cta3ZtLXZwLTc4MzUtMjAxMzA3MDMxNDMwMjQtMy4xMC4wLXJjNy0wMDEyMC1nZWNhYWRl
My0xMAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxLzA1YzNlMGJiNTYyOWI4
OTdiMDQ1OWU0YmZiMWI5M2Q3MjkwMzNiOTkvZG1lc2cta3ZtLXZwLTk0NDctMjAxMzA3MDMx
NDMwMjktMy4xMC4wLTAwMjg5LWdiYWRjODE4LTI3Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctYzI1LTA3MDEvMDVjM2UwYmI1NjI5Yjg5N2IwNDU5ZTRiZmIxYjkzZDcyOTAzM2I5OS9k
bWVzZy1rdm0tdnAtOTgwNy0yMDEzMDcwMzE0MzAzNC0zLjEwLjAtcmM3LTAwMTk0LWc1YjBl
MmU1LTcKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS8wNWMzZTBiYjU2Mjli
ODk3YjA0NTllNGJmYjFiOTNkNzI5MDMzYjk5L2RtZXNnLWt2bS13YWltZWEtMjEzNzgtMjAx
MzA3MDMxNDMyMTYtMy4xMC4wLXJjNy0wMDE5NC1nNWIwZTJlNS0yMAova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWMyNS0wNzAxLzA1YzNlMGJiNTYyOWI4OTdiMDQ1OWU0YmZiMWI5M2Q3
MjkwMzNiOTkvZG1lc2cta3ZtLXdhaW1lYS0yMTQxMy0yMDEzMDcwMzE0MzIxMy0zLjEwLjAt
MDAyODktZ2JhZGM4MTgtMjgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS8w
NWMzZTBiYjU2MjliODk3YjA0NTllNGJmYjFiOTNkNzI5MDMzYjk5L2RtZXNnLWt2bS13YWlt
ZWEtMzYwMi0yMDEzMDcwMzE0MzIwNi0zLjEwLjAtcmM3LTAwMTk0LWc1YjBlMmU1LTcKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS8wNWMzZTBiYjU2MjliODk3YjA0NTll
NGJmYjFiOTNkNzI5MDMzYjk5L2RtZXNnLWt2bS12cC0xMjc0Ni0yMDEzMDcwMzE0MzAzOC0z
LjEwLjAtcmM3LTAwMTk0LWc1YjBlMmU1LTEzCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
YzI1LTA3MDEvMDVjM2UwYmI1NjI5Yjg5N2IwNDU5ZTRiZmIxYjkzZDcyOTAzM2I5OS9kbWVz
Zy1rdm0tdnAtMTMwMzYtMjAxMzA3MDMxNDMwMzctMy4xMC4wLXJjMS0wMDI3My1nNWY3M2Zj
MC0yNQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxLzA1YzNlMGJiNTYyOWI4
OTdiMDQ1OWU0YmZiMWI5M2Q3MjkwMzNiOTkvZG1lc2cta3ZtLXZwLTEzMjg5LTIwMTMwNzAz
MTQzMDM4LTMuMTAuMC1yYzctMDAxOTQtZzViMGUyZTUtMTMKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1jMjUtMDcwMS8wNWMzZTBiYjU2MjliODk3YjA0NTllNGJmYjFiOTNkNzI5MDMz
Yjk5L2RtZXNnLWt2bS12cC0xNDUzOC0yMDEzMDcwMzE0MzAzNy0zLjEwLjAtcmMxLTAwMjc0
LWc3ZDIwNGI2LTI1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvMDVjM2Uw
YmI1NjI5Yjg5N2IwNDU5ZTRiZmIxYjkzZDcyOTAzM2I5OS9kbWVzZy1rdm0tdnAtMTQ4MDUt
MjAxMzA3MDMxNDMwMzgtMy43LjAtcmM0LTAwMTUyLWcxNTgyZWVhLTQ1Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctYzI1LTA3MDEvMDVjM2UwYmI1NjI5Yjg5N2IwNDU5ZTRiZmIxYjkz
ZDcyOTAzM2I5OS9kbWVzZy1rdm0tdnAtMTUwMDgtMjAxMzA3MDMxNDMwMzYtMy4xMC4wLXJj
MS0wMDUyNS1nYTUxZDgxYy0zNQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAx
LzA1YzNlMGJiNTYyOWI4OTdiMDQ1OWU0YmZiMWI5M2Q3MjkwMzNiOTkvZG1lc2cta3ZtLXZw
LTE1MzQ1LTIwMTMwNzAzMTQzMDM4LTMuMTAuMC1yYzctMDAxOTQtZzViMGUyZTUtNwova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxLzA1YzNlMGJiNTYyOWI4OTdiMDQ1OWU0
YmZiMWI5M2Q3MjkwMzNiOTkvZG1lc2cta3ZtLXZwLTE2OTA5LTIwMTMwNzAzMTQzMDM1LTMu
MTAuMC1yYzctMDAxOTQtZzViMGUyZTUtMTMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1j
MjUtMDcwMS8wNWMzZTBiYjU2MjliODk3YjA0NTllNGJmYjFiOTNkNzI5MDMzYjk5L2RtZXNn
LWt2bS12cC0xNzg4MS0yMDEzMDcwMzE0MzAzNi0zLjEwLjAtcmMxLTAwNTI1LWdhNTFkODFj
LTM1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvMDVjM2UwYmI1NjI5Yjg5
N2IwNDU5ZTRiZmIxYjkzZDcyOTAzM2I5OS9kbWVzZy1rdm0tdnAtMTg0MTMtMjAxMzA3MDMx
NDMwMzYtMy4xMC4wLXJjMi0wMDIwMi1nOTU5MjkxNi0zNQova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWMyNS0wNzAxLzA1YzNlMGJiNTYyOWI4OTdiMDQ1OWU0YmZiMWI5M2Q3MjkwMzNi
OTkvZG1lc2cta3ZtLXZwLTE4NzE2LTIwMTMwNzAzMTQzMDM4LTMuMTAuMC1tbTEtMDA3NTQt
ZzZmNjRiOTEtNTgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS8wNWMzZTBi
YjU2MjliODk3YjA0NTllNGJmYjFiOTNkNzI5MDMzYjk5L2RtZXNnLWt2bS12cC0xOTg4My0y
MDEzMDcwMzE0MzAzOC0zLjEwLjAtcmM3LTAwMTk0LWc1YjBlMmU1LTcKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1jMjUtMDcwMS8wNWMzZTBiYjU2MjliODk3YjA0NTllNGJmYjFiOTNk
NzI5MDMzYjk5L2RtZXNnLWt2bS12cC0yMDE3NS0yMDEzMDcwMzE0MzAzNy0zLjEwLjAtcmM3
LTAwMTk0LWc1YjBlMmU1LTEzCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEv
MDVjM2UwYmI1NjI5Yjg5N2IwNDU5ZTRiZmIxYjkzZDcyOTAzM2I5OS9kbWVzZy1rdm0tdnAt
MjU0ODAtMjAxMzA3MDMxNDMwMzYtMy4xMC4wLXJjNy0wMDE5NC1nNWIwZTJlNS03Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvMDVjM2UwYmI1NjI5Yjg5N2IwNDU5ZTRi
ZmIxYjkzZDcyOTAzM2I5OS9kbWVzZy1rdm0tdnAtMjU3MjUtMjAxMzA3MDMxNDMwMzgtMy4x
MC4wLXJjNi0wMTA1Mi1nMzhhZTkyZC0yMAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMy
NS0wNzAxLzA1YzNlMGJiNTYyOWI4OTdiMDQ1OWU0YmZiMWI5M2Q3MjkwMzNiOTkvZG1lc2ct
a3ZtLXZwLTI2NDQzLTIwMTMwNzAzMTQzMDM3LTMuMTAuMC0wMDcxMi1nMGRkZmQ0Ni0yNwov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxLzA1YzNlMGJiNTYyOWI4OTdiMDQ1
OWU0YmZiMWI5M2Q3MjkwMzNiOTkvZG1lc2cta3ZtLXZwLTYwMzItMjAxMzA3MDMxNDMwMzYt
My43LjAtcmM0LTAwMTUyLWcxNTgyZWVhLTQ1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
YzI1LTA3MDEvMDVjM2UwYmI1NjI5Yjg5N2IwNDU5ZTRiZmIxYjkzZDcyOTAzM2I5OS9kbWVz
Zy1rdm0tdnAtOTAxMi0yMDEzMDcwMzE0MzAzNS0zLjEwLjAtMDA3MTItZzBkZGZkNDYtMjcK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS8wNWMzZTBiYjU2MjliODk3YjA0
NTllNGJmYjFiOTNkNzI5MDMzYjk5L2RtZXNnLWt2bS14Z3dvLTExODc0LTIwMTMwNzAzMTQy
ODQ0LTMuMTAuMC1yYzEtMDAyNzQtZzdkMjA0YjYtMjYKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1jMjUtMDcwMS8wNWMzZTBiYjU2MjliODk3YjA0NTllNGJmYjFiOTNkNzI5MDMzYjk5
L2RtZXNnLWt2bS14Z3dvLTE1MjgzLTIwMTMwNzAzMTQyODQ0LTMuMTAuMC1yYzYtMDEwNTIt
ZzM4YWU5MmQtMjAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS8wNWMzZTBi
YjU2MjliODk3YjA0NTllNGJmYjFiOTNkNzI5MDMzYjk5L2RtZXNnLWt2bS14Z3dvLTE5OTQ3
LTIwMTMwNzAzMTQyODQ2LTMuMTAuMC1yYzctMDAxOTQtZzViMGUyZTUtNwoKQmlzZWN0aW5n
OiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0ZXAp
Cls0ZGViZmU0MDliNmU1NTAwMzJiZmVmOTczM2U5ZjZmN2M1NjEzNjE3XSBGTUM6IGFkZCBh
IGNoYXItZGV2aWNlIG1lenphbmluZSBkcml2ZXIKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdAps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzI1
LTA3MDEvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMwNzAxMjI0MDo0ZGVi
ZmU0MDliNmU1NTAwMzJiZmVmOTczM2U5ZjZmN2M1NjEzNjE3OmJpc2VjdC11c2IKCjIwMTMt
MDctMDMtMTQ6Mjk6NDMgNGRlYmZlNDA5YjZlNTUwMDMyYmZlZjk3MzNlOWY2ZjdjNTYxMzYx
NyBjb21waWxpbmcKMTg4IHJlYWwgIDE1MTggdXNlciAgMTQwIHN5cyAgODc5LjkxJSBjcHUg
CXg4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxCgoyMDEzLTA3LTAzLTE0OjMzOjA0IGRldGVj
dGluZyBib290IHN0YXRlIDMuMTAuMC1yYzYtMDAzNzEtZzRkZWJmZTQuLi4gVEVTVCBGQUlM
VVJFClsgICAgNi43OTcyNThdIGZtY193cml0ZV9lZXByb20gZmFrZS1kZXNpZ24tZm9yLXRl
c3RpbmctZjAwMTogZm1jX3dyaXRlX2VlcHJvbTogbm8gYnVzaWQgcGFzc2VkLCByZWZ1c2lu
ZyBhbGwgY2FyZHMKWyAgICA2Ljc5OTE3Nl0gZm1jIGZha2UtZGVzaWduLWZvci10ZXN0aW5n
LWYwMDE6IERyaXZlciBoYXMgbm8gSUQ6IG1hdGNoZXMgYWxsClsgICAgNi44MDA1MDFdIEJV
Rzogc2NoZWR1bGluZyB3aGlsZSBhdG9taWM6IHN3YXBwZXIvMS8weDEwMDAwMDAyClsgICAg
Ni44MDE2MDNdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjEw
LjAtcmM2LTAwMzcxLWc0ZGViZmU0ICMxMzEKWyAgICA2LjgwMzEzMl0gSGFyZHdhcmUgbmFt
ZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDYuODA0MjI2XSAg
MDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDBkYzViYjA4IGZmZmZmZmZmODFiNjk5NTEgZmZm
Zjg4MDAwZGM1YmIxOApbICAgIDYuODA2MDk0XSAgZmZmZmZmZmY4MWI2NWM5MSBmZmZmODgw
MDBkYzViYjc4IGZmZmZmZmZmODFiNzFmZGUgZmZmZjg4MDAwZGM1YmIzOApbICAgIDYuODA3
OTU0XSAgZmZmZjg4MDAwZGM1YmZkOCBmZmZmODgwMDBkYzViZmQ4IGZmZmY4ODAwMGRjNWJm
ZDggZmZmZjg4MDAwZGM1YmZkOApbICAgIDYuODA5ODE4XSBDYWxsIFRyYWNlOgpbICAgIDYu
ODEwNDIwXSAgWzxmZmZmZmZmZjgxYjY5OTUxPl0gZHVtcF9zdGFjaysweDE5LzB4MWIKWyAg
ICA2LjgxMTQzMF0gIFs8ZmZmZmZmZmY4MWI2NWM5MT5dIF9fc2NoZWR1bGVfYnVnKzB4NDIv
MHg1MApbICAgIDYuODEyNTAxXSAgWzxmZmZmZmZmZjgxYjcxZmRlPl0gX19zY2hlZHVsZSsw
eDUwZS8weDUyMApbICAgIDYuODEzNTMzXSAgWzxmZmZmZmZmZjgxMGQ5NWUwPl0gX19jb25k
X3Jlc2NoZWQrMHgyMC8weDMwClsgICAgNi44MTQ1ODZdICBbPGZmZmZmZmZmODFiNzIxODM+
XSBfY29uZF9yZXNjaGVkKzB4MzMvMHg0MApbICAgIDYuODE1NjM0XSAgWzxmZmZmZmZmZjgx
YjcyNDdhPl0gd2FpdF9mb3JfY29tcGxldGlvbisweDJhLzB4MTQwClsgICAgNi44MTY3ODdd
ICBbPGZmZmZmZmZmODEwZDk1YTU+XSA/IGNoZWNrX3ByZWVtcHRfY3VycisweDg1LzB4YTAK
WyAgICA2LjgxNzkxOF0gIFs8ZmZmZmZmZmY4MTViZmI4ND5dIGRldnRtcGZzX2NyZWF0ZV9u
b2RlKzB4ZjQvMHgxMzAKWyAgICA2LjgxOTA1N10gIFs8ZmZmZmZmZmY4MTViODA0ZT5dIGRl
dmljZV9hZGQrMHgyM2UvMHg2YjAKWyAgICA2LjgyMDEyMV0gIFs8ZmZmZmZmZmY4MTViOGM1
MD5dIGRldmljZV9jcmVhdGVfdmFyZ3MrMHhkMC8weDEwMApbICAgIDYuODIxMjQ2XSAgWzxm
ZmZmZmZmZjgxNWI4Y2FmPl0gZGV2aWNlX2NyZWF0ZSsweDJmLzB4NDAKWyAgICA2LjgyMjI4
M10gIFs8ZmZmZmZmZmY4MWI3MTI2MD5dID8gbXV0ZXhfbG9jaysweDIwLzB4MzAKWyAgICA2
LjgyMzMwN10gIFs8ZmZmZmZmZmY4MTU4NGEwNj5dIG1pc2NfcmVnaXN0ZXIrMHhjNi8weDEy
MApbICAgIDYuODI0MzcxXSAgWzxmZmZmZmZmZjgxOTFkZjg3Pl0gZmNfcHJvYmUrMHg4Ny8w
eDExMApbICAgIDYuODI1MzY0XSAgWzxmZmZmZmZmZjgxOTFiZTMyPl0gZm1jX3Byb2JlKzB4
MTIvMHgyMApbICAgIDYuODI2MzU1XSAgWzxmZmZmZmZmZjgxNWJiNjMyPl0gcmVhbGx5X3By
b2JlKzB4NTIvMHgxZjAKWyAgICA2LjgyNzM5Ml0gIFs8ZmZmZmZmZmY4MTViYjhkMT5dIF9f
ZHJpdmVyX2F0dGFjaCsweDkxLzB4YTAKWyAgICA2LjgyODQ2Nl0gIFs8ZmZmZmZmZmY4MTVi
Yjg0MD5dID8gX19kZXZpY2VfYXR0YWNoKzB4NTAvMHg1MApbICAgIDYuODI5NTQ2XSAgWzxm
ZmZmZmZmZjgxNWI5YmQzPl0gYnVzX2Zvcl9lYWNoX2RldisweDYzLzB4YTAKWyAgICA2Ljgz
MDYyM10gIFs8ZmZmZmZmZmY4MTViYjU2OT5dIGRyaXZlcl9hdHRhY2grMHgxOS8weDIwClsg
ICAgNi44MzE2NThdICBbPGZmZmZmZmZmODE1YmE1Yjg+XSBidXNfYWRkX2RyaXZlcisweDFi
OC8weDI1MApbICAgIDYuODMyNzU1XSAgWzxmZmZmZmZmZjgxOTFkZWMwPl0gPyBmY19yZWFk
KzB4YjAvMHhiMApbICAgIDYuODMzNzQyXSAgWzxmZmZmZmZmZjgxNWJjMDVjPl0gZHJpdmVy
X3JlZ2lzdGVyKzB4NmMvMHgxNTAKWyAgICA2LjgzNDgyM10gIFs8ZmZmZmZmZmY4MTkxZGVj
MD5dID8gZmNfcmVhZCsweGIwLzB4YjAKWyAgICA2LjgzNTgwMl0gIFs8ZmZmZmZmZmY4MTkx
YmZkMD5dIGZtY19kcml2ZXJfcmVnaXN0ZXIrMHgzMC8weDQwClsgICAgNi44MzY5NDRdICBb
PGZmZmZmZmZmODE5MWRlZDA+XSBmY19pbml0KzB4MTAvMHgyMApbICAgIDYuODM3OTA5XSAg
WzxmZmZmZmZmZjgyMzcwZmU2Pl0gZG9fb25lX2luaXRjYWxsKzB4NzkvMHgxMTcKWyAgICA2
LjgzODk4Ml0gIFs8ZmZmZmZmZmY4MjM3MTE3Zj5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4
ZmIvMHgxN2MKWyAgICA2Ljg0MDE1M10gIFs8ZmZmZmZmZmY4MjM3MDg4MT5dID8gZG9fZWFy
bHlfcGFyYW0rMHg4OC8weDg4ClsgICAgNi44NDEyMjJdICBbPGZmZmZmZmZmODFiNWY4MDA+
XSA/IHJlc3RfaW5pdCsweDkwLzB4OTAKWyAgICA2Ljg0MjIzMl0gIFs8ZmZmZmZmZmY4MWI1
ZjgwOT5dIGtlcm5lbF9pbml0KzB4OS8weDE4MApbICAgIDYuODQzMjQxXSAgWzxmZmZmZmZm
ZjgxYjc0MjdhPl0gcmV0X2Zyb21fZm9yaysweDdhLzB4YjAKWyAgICA2Ljg0NDI3OF0gIFs8
ZmZmZmZmZmY4MWI1ZjgwMD5dID8gcmVzdF9pbml0KzB4OTAvMHg5MApbICAgIDYuODQ1MzIy
XSBmbWNfY2hhcmRldiBmYWtlLWRlc2lnbi1mb3ItdGVzdGluZy1mMDAxOiBDcmVhdGVkIG1p
c2MgZGV2aWNlICJmYWtlLWRlc2lnbi1mb3ItdGVzdGluZy1mMDAxIgpbICAgIDYuODQ3MTcw
XSBBdWRpbyBFeGNlbCBEU1AgMTYgaW5pdCBkcml2ZXIgQ29weXJpZ2h0IChDKSBSaWNjYXJk
byBGYWNjaGV0dGkgMTk5NS05OAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAx
LzRkZWJmZTQwOWI2ZTU1MDAzMmJmZWY5NzMzZTlmNmY3YzU2MTM2MTcvZG1lc2cta3ZtLXZw
LTE3NTA5LTIwMTMwNzAzMTQzNTA5LTMuMTAuMC0wMDM0OS1nZGMyMGI0NC0zNwova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxLzRkZWJmZTQwOWI2ZTU1MDAzMmJmZWY5NzMz
ZTlmNmY3YzU2MTM2MTcvZG1lc2cta3ZtLXdhaW1lYS0yMTM3Ny0yMDEzMDcwMzE0MzY0Ny0z
LjEwLjAtcmM2LTAwMzc1LWdjMjk1NWRhLTEyOQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWMyNS0wNzAxLzRkZWJmZTQwOWI2ZTU1MDAzMmJmZWY5NzMzZTlmNmY3YzU2MTM2MTcvZG1l
c2cta3ZtLXdhaW1lYS0yMTQxMy0yMDEzMDcwMzE0MzY1OS0zLjEwLjAtMDAyODktZ2JhZGM4
MTgtMjgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS80ZGViZmU0MDliNmU1
NTAwMzJiZmVmOTczM2U5ZjZmN2M1NjEzNjE3L2RtZXNnLWt2bS13YWltZWEtMjE0MTYtMjAx
MzA3MDMxNDM2MjktMy4xMC4wLTAwMjg5LWdiYWRjODE4LTI4Ci9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctYzI1LTA3MDEvNGRlYmZlNDA5YjZlNTUwMDMyYmZlZjk3MzNlOWY2ZjdjNTYx
MzYxNy9kbWVzZy1rdm0td2FpbWVhLTIxNDE2LTIwMTMwNzAzMTQzNjQ3LTMuMTAuMC0wMDI4
OS1nYmFkYzgxOC0yOAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxLzRkZWJm
ZTQwOWI2ZTU1MDAzMmJmZWY5NzMzZTlmNmY3YzU2MTM2MTcvZG1lc2cta3ZtLXdhaW1lYS0y
MTQxOC0yMDEzMDcwMzE0MzYyNy0zLjEwLjAtcmM2LTAxMDUyLWczOGFlOTJkLTIwCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvNGRlYmZlNDA5YjZlNTUwMDMyYmZlZjk3
MzNlOWY2ZjdjNTYxMzYxNy9kbWVzZy1rdm0td2FpbWVhLTIxNDE4LTIwMTMwNzAzMTQzNjQ1
LTMuMTAuMC1yYzYtMDEwNTItZzM4YWU5MmQtMjAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1jMjUtMDcwMS80ZGViZmU0MDliNmU1NTAwMzJiZmVmOTczM2U5ZjZmN2M1NjEzNjE3L2Rt
ZXNnLWt2bS12cC0yMDQ5NC0yMDEzMDcwMzE0MzQ0Ni0zLjEwLjAtMDAyODktZ2JhZGM4MTgt
MjgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS80ZGViZmU0MDliNmU1NTAw
MzJiZmVmOTczM2U5ZjZmN2M1NjEzNjE3L2RtZXNnLWt2bS12cC0yMDQ5NC0yMDEzMDcwMzE0
MzUwNy0zLjEwLjAtMDAyODktZ2JhZGM4MTgtMjgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1jMjUtMDcwMS80ZGViZmU0MDliNmU1NTAwMzJiZmVmOTczM2U5ZjZmN2M1NjEzNjE3L2Rt
ZXNnLWt2bS13YWltZWEtMjE0MTktMjAxMzA3MDMxNDM2MjUtMy4xMC4wLXJjNi0wMDM3MS1n
NGRlYmZlNC0xMzEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS80ZGViZmU0
MDliNmU1NTAwMzJiZmVmOTczM2U5ZjZmN2M1NjEzNjE3L2RtZXNnLWt2bS13YWltZWEtMjE0
MTktMjAxMzA3MDMxNDM2NDMtMy4xMC4wLXJjNi0wMDM3MS1nNGRlYmZlNC0xMzEKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS80ZGViZmU0MDliNmU1NTAwMzJiZmVmOTcz
M2U5ZjZmN2M1NjEzNjE3L2RtZXNnLWt2bS12cC0yNjE0MC0yMDEzMDcwMzE0MzQ0MC0zLjEw
LjAtcmM3LTAwMTk0LWc1YjBlMmU1LTEzCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1
LTA3MDEvNGRlYmZlNDA5YjZlNTUwMDMyYmZlZjk3MzNlOWY2ZjdjNTYxMzYxNy9kbWVzZy1r
dm0tcm9hbS0yMTk3Ni0yMDEzMDcwMzE0MzYyMy0zLjEwLjAtcmM2LTAwMzcxLWc0ZGViZmU0
LTEzMQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxLzRkZWJmZTQwOWI2ZTU1
MDAzMmJmZWY5NzMzZTlmNmY3YzU2MTM2MTcvZG1lc2cta3ZtLXZwLTI2MTQwLTIwMTMwNzAz
MTQzNTAwLTMuMTAuMC1yYzctMDAxOTQtZzViMGUyZTUtMTMKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1jMjUtMDcwMS80ZGViZmU0MDliNmU1NTAwMzJiZmVmOTczM2U5ZjZmN2M1NjEz
NjE3L2RtZXNnLWt2bS1yb2FtLTIxOTc2LTIwMTMwNzAzMTQzNjQzLTMuMTAuMC1yYzYtMDAz
NzEtZzRkZWJmZTQtMTMxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvNGRl
YmZlNDA5YjZlNTUwMDMyYmZlZjk3MzNlOWY2ZjdjNTYxMzYxNy9kbWVzZy1rdm0tdnAtMjc1
NDktMjAxMzA3MDMxNDM0NDItMy4xMC4wLTAwNzEyLWcwZGRmZDQ2LTI3Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctYzI1LTA3MDEvNGRlYmZlNDA5YjZlNTUwMDMyYmZlZjk3MzNlOWY2
ZjdjNTYxMzYxNy9kbWVzZy1rdm0tcm9hbS0yMzc1My0yMDEzMDcwMzE0MzYzNy0tCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvNGRlYmZlNDA5YjZlNTUwMDMyYmZlZjk3
MzNlOWY2ZjdjNTYxMzYxNy9kbWVzZy1rdm0tdnAtMjc1NDktMjAxMzA3MDMxNDM1MDEtMy4x
MC4wLTAwNzEyLWcwZGRmZDQ2LTI3Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3
MDEvNGRlYmZlNDA5YjZlNTUwMDMyYmZlZjk3MzNlOWY2ZjdjNTYxMzYxNy9kbWVzZy1rdm0t
cm9hbS00NDU5LTIwMTMwNzAzMTQzNjQwLTMuMTAuMC0wMDA5MS1nZmM3ZWQ4OC0xMgova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxLzRkZWJmZTQwOWI2ZTU1MDAzMmJmZWY5
NzMzZTlmNmY3YzU2MTM2MTcvZG1lc2cta3ZtLXZwLTQ3NzItMjAxMzA3MDMxNDM0NDAtMy4x
MC4wLTAwMzQ5LWdkYzIwYjQ0LTM3Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3
MDEvNGRlYmZlNDA5YjZlNTUwMDMyYmZlZjk3MzNlOWY2ZjdjNTYxMzYxNy9kbWVzZy1rdm0t
cm9hbS00NzEyLTIwMTMwNzAzMTQzNjM3LTMuMTAuMC0wMjkyNS1nMDhmYjc1MjQtNAova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxLzRkZWJmZTQwOWI2ZTU1MDAzMmJmZWY5
NzMzZTlmNmY3YzU2MTM2MTcvZG1lc2cta3ZtLXZwLTEwMDkyLTIwMTMwNzAzMTQzNDQ3LTMu
MTAuMC0wMDI4OS1nYmFkYzgxOC0yOAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0w
NzAxLzRkZWJmZTQwOWI2ZTU1MDAzMmJmZWY5NzMzZTlmNmY3YzU2MTM2MTcvZG1lc2cta3Zt
LXZwLTEwMDkyLTIwMTMwNzAzMTQzNTA4LTMuMTAuMC0wMDI4OS1nYmFkYzgxOC0yOAova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxLzRkZWJmZTQwOWI2ZTU1MDAzMmJmZWY5
NzMzZTlmNmY3YzU2MTM2MTcvZG1lc2cta3ZtLXZwLTQ3NzItMjAxMzA3MDMxNDM1MTItMy4x
MC4wLTAwMzQ5LWdkYzIwYjQ0LTM3Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3
MDEvNGRlYmZlNDA5YjZlNTUwMDMyYmZlZjk3MzNlOWY2ZjdjNTYxMzYxNy9kbWVzZy1rdm0t
dnAtMTEwNTktMjAxMzA3MDMxNDM0MzktMy4xMC4wLXJjNi0wMDM3MS1nNGRlYmZlNC0xMzEK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS80ZGViZmU0MDliNmU1NTAwMzJi
ZmVmOTczM2U5ZjZmN2M1NjEzNjE3L2RtZXNnLWt2bS12cC0xMTA1OS0yMDEzMDcwMzE0MzUw
MC0zLjEwLjAtcmM2LTAwMzcxLWc0ZGViZmU0LTEzMQova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWMyNS0wNzAxLzRkZWJmZTQwOWI2ZTU1MDAzMmJmZWY5NzMzZTlmNmY3YzU2MTM2MTcv
ZG1lc2cta3ZtLXZwLTExMjY0LTIwMTMwNzAzMTQzNDQwLTMuMTAuMC1yYzItMDAyMDItZzk1
OTI5MTYtMzYKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS80ZGViZmU0MDli
NmU1NTAwMzJiZmVmOTczM2U5ZjZmN2M1NjEzNjE3L2RtZXNnLWt2bS13YWltZWEtNzg4MS0y
MDEzMDcwMzE0MzYyNS0zLjEwLjAtMDAyODktZ2JhZGM4MTgtMjgKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1jMjUtMDcwMS80ZGViZmU0MDliNmU1NTAwMzJiZmVmOTczM2U5ZjZmN2M1
NjEzNjE3L2RtZXNnLWt2bS13YWltZWEtNzg4MS0yMDEzMDcwMzE0MzY0OC0zLjEwLjAtMDAy
ODktZ2JhZGM4MTgtMjgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS80ZGVi
ZmU0MDliNmU1NTAwMzJiZmVmOTczM2U5ZjZmN2M1NjEzNjE3L2RtZXNnLWt2bS12cC01MTEy
LTIwMTMwNzAzMTQzNDQ1LTMuMTAuMC0wMzI5Ni1nMGIwNTg1Yy0yOAova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWMyNS0wNzAxLzRkZWJmZTQwOWI2ZTU1MDAzMmJmZWY5NzMzZTlmNmY3
YzU2MTM2MTcvZG1lc2cta3ZtLXZwLTUxMTItMjAxMzA3MDMxNDM1MDMtMy4xMC4wLTAzMjk2
LWcwYjA1ODVjLTI4Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvNGRlYmZl
NDA5YjZlNTUwMDMyYmZlZjk3MzNlOWY2ZjdjNTYxMzYxNy9kbWVzZy1rdm0tdnAtNTU0Ny0y
MDEzMDcwMzE0MzQ0MC0zLjEwLjAtMDQ3MTUtZzgwZDE2MmMtMTIzCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctYzI1LTA3MDEvNGRlYmZlNDA5YjZlNTUwMDMyYmZlZjk3MzNlOWY2Zjdj
NTYxMzYxNy9kbWVzZy1rdm0tdnAtMTEyNjQtMjAxMzA3MDMxNDM1MTQtMy4xMC4wLXJjMi0w
MDIwMi1nOTU5MjkxNi0zNgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxLzRk
ZWJmZTQwOWI2ZTU1MDAzMmJmZWY5NzMzZTlmNmY3YzU2MTM2MTcvZG1lc2cta3ZtLXZwLTU1
NDctMjAxMzA3MDMxNDM1MTQtMy4xMC4wLTA0NzE1LWc4MGQxNjJjLTEyMwova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxLzRkZWJmZTQwOWI2ZTU1MDAzMmJmZWY5NzMzZTlm
NmY3YzU2MTM2MTcvZG1lc2cta3ZtLXZwLTExNjkxLTIwMTMwNzAzMTQzNDQ4LTMuMTAuMC0w
MzI5Ni1nMGIwNTg1Yy0xOQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxLzRk
ZWJmZTQwOWI2ZTU1MDAzMmJmZWY5NzMzZTlmNmY3YzU2MTM2MTcvZG1lc2cta3ZtLXZwLTEx
NjkxLTIwMTMwNzAzMTQzNTA4LTMuMTAuMC0wMzI5Ni1nMGIwNTg1Yy0xOQova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxLzRkZWJmZTQwOWI2ZTU1MDAzMmJmZWY5NzMzZTlm
NmY3YzU2MTM2MTcvZG1lc2cta3ZtLXZwLTE1MDA4LTIwMTMwNzAzMTQzNTE4LTMuMTAuMC1y
YzEtMDA1MjUtZ2E1MWQ4MWMtMzUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcw
MS80ZGViZmU0MDliNmU1NTAwMzJiZmVmOTczM2U5ZjZmN2M1NjEzNjE3L2RtZXNnLWt2bS12
cC0xNTg4My0yMDEzMDcwMzE0MzQ0MC0zLjQuMC0wNTc0OC1nNTljZDM1OC02MQova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxLzRkZWJmZTQwOWI2ZTU1MDAzMmJmZWY5NzMz
ZTlmNmY3YzU2MTM2MTcvZG1lc2cta3ZtLXZwLTE1ODgzLTIwMTMwNzAzMTQzNTAwLTMuNC4w
LTA1NzQ4LWc1OWNkMzU4LTYxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEv
NGRlYmZlNDA5YjZlNTUwMDMyYmZlZjk3MzNlOWY2ZjdjNTYxMzYxNy9kbWVzZy1rdm0tdnAt
NzY4Ni0yMDEzMDcwMzE0MzQ0MC0zLjEwLjAtcmM1LTAwMTc5LWczYzlmNzJlLTI5Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvNGRlYmZlNDA5YjZlNTUwMDMyYmZlZjk3
MzNlOWY2ZjdjNTYxMzYxNy9kbWVzZy1rdm0tdnAtNzY4Ni0yMDEzMDcwMzE0MzUxMy0zLjEw
LjAtcmM1LTAwMTc5LWczYzlmNzJlLTI5Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1
LTA3MDEvNGRlYmZlNDA5YjZlNTUwMDMyYmZlZjk3MzNlOWY2ZjdjNTYxMzYxNy9kbWVzZy1r
dm0tdnAtMTY1MDAtMjAxMzA3MDMxNDM0NDktMy40LjAtMDQ0MTMtZ2ZiMDliYWYtNjMKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS80ZGViZmU0MDliNmU1NTAwMzJiZmVm
OTczM2U5ZjZmN2M1NjEzNjE3L2RtZXNnLWt2bS12cC0xNjUwMC0yMDEzMDcwMzE0MzUwOS0z
LjQuMC0wNDQxMy1nZmIwOWJhZi02Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0w
NzAxLzRkZWJmZTQwOWI2ZTU1MDAzMmJmZWY5NzMzZTlmNmY3YzU2MTM2MTcvZG1lc2cta3Zt
LXZwLTE2OTA5LTIwMTMwNzAzMTQzNTE3LTMuMTAuMC1yYzctMDAxOTQtZzViMGUyZTUtMTMK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS80ZGViZmU0MDliNmU1NTAwMzJi
ZmVmOTczM2U5ZjZmN2M1NjEzNjE3L2RtZXNnLWt2bS14Z3dvLTE1Mjk0LTIwMTMwNzAzMTQz
MjU0LTMuMTAuMC0wMDI4OS1nYmFkYzgxOC0yOAova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWMyNS0wNzAxLzRkZWJmZTQwOWI2ZTU1MDAzMmJmZWY5NzMzZTlmNmY3YzU2MTM2MTcvZG1l
c2cta3ZtLXhnd28tMTUyOTQtMjAxMzA3MDMxNDMzMTQtMy4xMC4wLTAwMjg5LWdiYWRjODE4
LTI4Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvNGRlYmZlNDA5YjZlNTUw
MDMyYmZlZjk3MzNlOWY2ZjdjNTYxMzYxNy9kbWVzZy1rdm0tdnAtNzgzNS0yMDEzMDcwMzE0
MzQ0OC0zLjEwLjAtcmM3LTAwMTIwLWdlY2FhZGUzLTEwCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctYzI1LTA3MDEvNGRlYmZlNDA5YjZlNTUwMDMyYmZlZjk3MzNlOWY2ZjdjNTYxMzYx
Ny9kbWVzZy1rdm0tdnAtNzgzNS0yMDEzMDcwMzE0MzUwNy0zLjEwLjAtcmM3LTAwMTIwLWdl
Y2FhZGUzLTEwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvNGRlYmZlNDA5
YjZlNTUwMDMyYmZlZjk3MzNlOWY2ZjdjNTYxMzYxNy9kbWVzZy1rdm0tdnAtOTAxMi0yMDEz
MDcwMzE0MzUxOC0zLjEwLjAtMDA3MTItZzBkZGZkNDYtMjcKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1jMjUtMDcwMS80ZGViZmU0MDliNmU1NTAwMzJiZmVmOTczM2U5ZjZmN2M1NjEz
NjE3L2RtZXNnLWt2bS14Z3dvLTE3MDktMjAxMzA3MDMxNDMyNDctMy4xMC4wLXJjNi0wMDM3
MS1nNGRlYmZlNC0xMzEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS80ZGVi
ZmU0MDliNmU1NTAwMzJiZmVmOTczM2U5ZjZmN2M1NjEzNjE3L2RtZXNnLWt2bS14Z3dvLTE3
MDktMjAxMzA3MDMxNDMzMDUtMy4xMC4wLXJjNi0wMDM3MS1nNGRlYmZlNC0xMzEKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS80ZGViZmU0MDliNmU1NTAwMzJiZmVmOTcz
M2U5ZjZmN2M1NjEzNjE3L2RtZXNnLWt2bS14Z3dvLTE3MDktMjAxMzA3MDMxNDMzMzEtMy4x
MC4wLXJjNi0wMDM3MS1nNGRlYmZlNC0xMzEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1j
MjUtMDcwMS80ZGViZmU0MDliNmU1NTAwMzJiZmVmOTczM2U5ZjZmN2M1NjEzNjE3L2RtZXNn
LWt2bS13YWltZWEtMjEzNzctMjAxMzA3MDMxNDM2MjgtMy4xMC4wLXJjNi0wMDM3NS1nYzI5
NTVkYS0xMjkKCkJpc2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgMCBzdGVwcykKWzYwMDdiMWJkMGY3NTJhNWMwMjJmNzk0NGM2NWZiOTZj
MzlkNmRiM2RdIEZNQzogYWRkIGEgZHJpdmVyIHRvIHdyaXRlIG1lenphbmluZSBFRVBST00K
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9o
b21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0veDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8t
eDg2XzY0LTIwMTMwNzAxMjI0MDo2MDA3YjFiZDBmNzUyYTVjMDIyZjc5NDRjNjVmYjk2YzM5
ZDZkYjNkOmJpc2VjdC11c2IKCjIwMTMtMDctMDMtMTQ6MzQ6MzYgNjAwN2IxYmQwZjc1MmE1
YzAyMmY3OTQ0YzY1ZmI5NmMzOWQ2ZGIzZCBjb21waWxpbmcKMTk0IHJlYWwgIDE1MjIgdXNl
ciAgMTMyIHN5cyAgODUwLjgyJSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxCgoy
MDEzLTA3LTAzLTE0OjM4OjAwIGRldGVjdGluZyBib290IHN0YXRlIDMuMTAuMC1yYzYtMDAz
NzAtZzYwMDdiMWIJMQkzMQk1Ngk2MCBTVUNDRVNTCgo0ZGViZmU0MDliNmU1NTAwMzJiZmVm
OTczM2U5ZjZmN2M1NjEzNjE3IGlzIHRoZSBmaXJzdCBiYWQgY29tbWl0CmNvbW1pdCA0ZGVi
ZmU0MDliNmU1NTAwMzJiZmVmOTczM2U5ZjZmN2M1NjEzNjE3CkF1dGhvcjogQWxlc3NhbmRy
byBSdWJpbmkgPHJ1YmluaUBnbnVkZC5jb20+CkRhdGU6ICAgVHVlIEp1biAxOCAyMzo0ODow
NyAyMDEzICswMjAwCgogICAgRk1DOiBhZGQgYSBjaGFyLWRldmljZSBtZXp6YW5pbmUgZHJp
dmVyCiAgICAKICAgIFRoaXMgZHJpdmVyIGV4cG9ydHMgdGhlIG1lbW9yeSBhcmVhIGFzc29j
aWF0ZWQgd2l0aCB0aGUgbWV6emFuaW5lIGNhcmQKICAgIGFzIGEgbWlzYyBkZXZpY2UsIHNv
IHVzZXJzIGNhbiBhY2Nlc3MgcmVnaXN0ZXJzLgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBB
bGVzc2FuZHJvIFJ1YmluaSA8cnViaW5pQGdudWRkLmNvbT4KICAgIEFja2VkLWJ5OiBKdWFu
IERhdmlkIEdvbnphbGV6IENvYmFzIDxkY29iYXNAY2Vybi5jaD4KICAgIEFja2VkLWJ5OiBF
bWlsaW8gRy4gQ290YSA8Y290YUBicmFhcC5vcmc+CiAgICBBY2tlZC1ieTogU2FtdWVsIEln
bGVzaWFzIEdvbnNhbHZleiA8c2lnbGVzaWFzQGlnYWxpYS5jb20+CiAgICBTaWduZWQtb2Zm
LWJ5OiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPgoK
OjA0MDAwMCAwNDAwMDAgMzI3ZmI0YjJiNDdkNjQyZDQ5YzBmZTkyNTZiZWRjM2U5OGYwNGVk
OSA3NzlkNDA3YTU3YjUyYTA2YjUwOGVlOGVmOWFjODg0OGViNjk3ZTc0IE0JRG9jdW1lbnRh
dGlvbgo6MDQwMDAwIDA0MDAwMCA5Mzk4YTc2YTZhMzJiYmJmZTI5N2E0OTQwNTY0NWFhMjFi
ZTA5NTRlIGRlZTdmNDc3MGJmZTFiYmNkMjYyYTNjMThhYzI3NTUzOTcyNDRiMmQgTQlkcml2
ZXJzCmJpc2VjdCBydW4gc3VjY2VzcwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0veDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8t
eDg2XzY0LTIwMTMwNzAxMjI0MDo2MDA3YjFiZDBmNzUyYTVjMDIyZjc5NDRjNjVmYjk2YzM5
ZDZkYjNkOmJpc2VjdC11c2IKCjIwMTMtMDctMDMtMTQ6NDA6MDEgNjAwN2IxYmQwZjc1MmE1
YzAyMmY3OTQ0YzY1ZmI5NmMzOWQ2ZGIzZCByZXVzZSAva2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWMyNS0wNzAxLzYwMDdiMWJkMGY3NTJhNWMwMjJmNzk0NGM2NWZiOTZjMzlkNmRiM2Qv
dm1saW51ei0zLjEwLjAtcmM2LTAwMzcwLWc2MDA3YjFiCgoyMDEzLTA3LTAzLTE0OjQwOjAy
IGRldGVjdGluZyBib290IHN0YXRlIC4uCTE0NgkxNzEJMTgwIFNVQ0NFU1MKCmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9s
aW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxMzA3MDEyMjQwOmFmMTVmOGRlNGYz
YTdiMjhlM2EyYzIwNjRhZDc0MTA2NzY3NTE2Y2E6YmlzZWN0LXVzYgogVEVTVCBGQUlMVVJF
ClsgICAgOC4wOTkyMTBdIGZtY193cml0ZV9lZXByb20gZmFrZS1kZXNpZ24tZm9yLXRlc3Rp
bmctZjAwMTogZm1jX3dyaXRlX2VlcHJvbTogbm8gYnVzaWQgcGFzc2VkLCByZWZ1c2luZyBh
bGwgY2FyZHMKWyAgICA4LjEwMTY3Nl0gZm1jIGZha2UtZGVzaWduLWZvci10ZXN0aW5nLWYw
MDE6IERyaXZlciBoYXMgbm8gSUQ6IG1hdGNoZXMgYWxsClsgICAgOC4xMDMyOTNdIEJVRzog
c2NoZWR1bGluZyB3aGlsZSBhdG9taWM6IHN3YXBwZXIvMS8weDEwMDAwMDAyClsgICAgOC4x
MDQ3MDNdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjEwLjAt
d2wtMDYwMzYtZ2FmMTVmOGQgIzEKWyAgICA4LjEwNjU4MF0gSGFyZHdhcmUgbmFtZTogQm9j
aHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDguMTA3OTY2XSAgMDAwMDAw
MDAwMDAwMDAwMCBmZmZmODgwMDBkYzViYjAwIGZmZmZmZmZmODFiN2JmMjcgZmZmZjg4MDAw
ZGM1YmIxMApbICAgIDguMTEwMzEzXSAgZmZmZmZmZmY4MWI3N2ZmZCBmZmZmODgwMDBkYzVi
YjcwIGZmZmZmZmZmODFiODQ4YmUgZmZmZmZmZmY4MTBkY2Y2MApbICAgIDguMTEyNjM1XSAg
ZmZmZjg4MDAwZGM1YmZkOCBmZmZmODgwMDBkYzViZmQ4IGZmZmY4ODAwMGRjNWJmZDggZmZm
Zjg4MDAwZGM1YmZkOApbICAgIDguMTE0OTc2XSBDYWxsIFRyYWNlOgpbICAgIDguMTE1NzQz
XSAgWzxmZmZmZmZmZjgxYjdiZjI3Pl0gZHVtcF9zdGFjaysweDE5LzB4MWIKWyAgICA4LjEx
NzA0NF0gIFs8ZmZmZmZmZmY4MWI3N2ZmZD5dIF9fc2NoZWR1bGVfYnVnKzB4NDIvMHg1MApb
ICAgIDguMTE4MzY5XSAgWzxmZmZmZmZmZjgxYjg0OGJlPl0gX19zY2hlZHVsZSsweDUwZS8w
eDUyMApbICAgIDguMTE5NjU3XSAgWzxmZmZmZmZmZjgxMGRjZjYwPl0gPyBfX2VucXVldWVf
ZW50aXR5KzB4NzAvMHg4MApbICAgIDguMTIxMTE1XSAgWzxmZmZmZmZmZjgxMGQ5NzEwPl0g
X19jb25kX3Jlc2NoZWQrMHgyMC8weDMwClsgICAgOC4xMjI0MzRdICBbPGZmZmZmZmZmODFi
ODRhNjM+XSBfY29uZF9yZXNjaGVkKzB4MzMvMHg0MApbICAgIDguMTIzNzQ5XSAgWzxmZmZm
ZmZmZjgxYjg0ZDVhPl0gd2FpdF9mb3JfY29tcGxldGlvbisweDJhLzB4MTQwClsgICAgOC4x
MjUyMTVdICBbPGZmZmZmZmZmODE1YzNhNTQ+XSBkZXZ0bXBmc19jcmVhdGVfbm9kZSsweGY0
LzB4MTMwClsgICAgOC4xMjY2NjRdICBbPGZmZmZmZmZmODE1YmJiOGU+XSBkZXZpY2VfYWRk
KzB4MjNlLzB4NmYwClsgICAgOC4xMjc5NjldICBbPGZmZmZmZmZmODE1YmNhNDA+XSBkZXZp
Y2VfY3JlYXRlX3ZhcmdzKzB4ZDAvMHgxMDAKWyAgICA4LjEyOTQzMF0gIFs8ZmZmZmZmZmY4
MTViY2E5Zj5dIGRldmljZV9jcmVhdGUrMHgyZi8weDQwClsgICAgOC4xMzA3NTBdICBbPGZm
ZmZmZmZmODFiODM5ODA+XSA/IG11dGV4X2xvY2srMHgyMC8weDMwClsgICAgOC4xMzIwNjRd
ICBbPGZmZmZmZmZmODE1ODdhNTY+XSBtaXNjX3JlZ2lzdGVyKzB4YzYvMHgxMjAKWyAgICA4
LjEzMzM5N10gIFs8ZmZmZmZmZmY4MTkyYzdhOD5dIGZjX3Byb2JlKzB4OTgvMHgxNDAKWyAg
ICA4LjEzNDY0M10gIFs8ZmZmZmZmZmY4MTkyYTY1Mj5dIGZtY19wcm9iZSsweDEyLzB4MjAK
WyAgICA4LjEzNTg3OF0gIFs8ZmZmZmZmZmY4MTViZjRkMj5dIHJlYWxseV9wcm9iZSsweDUy
LzB4MWYwClsgICAgOC4xMzcyMjVdICBbPGZmZmZmZmZmODE1YmY3NzE+XSBfX2RyaXZlcl9h
dHRhY2grMHg5MS8weGEwClsgICAgOC4xMzg1NjRdICBbPGZmZmZmZmZmODE1YmY2ZTA+XSA/
IF9fZGV2aWNlX2F0dGFjaCsweDUwLzB4NTAKWyAgICA4LjEzOTk1Ml0gIFs8ZmZmZmZmZmY4
MTViZDlkMz5dIGJ1c19mb3JfZWFjaF9kZXYrMHg2My8weGEwClsgICAgOC4xNDEzODJdICBb
PGZmZmZmZmZmODE1YmY0MDk+XSBkcml2ZXJfYXR0YWNoKzB4MTkvMHgyMApbICAgIDguMTQy
NzAzXSAgWzxmZmZmZmZmZjgxNWJlNDE4Pl0gYnVzX2FkZF9kcml2ZXIrMHgxYzgvMHgyNjAK
WyAgICA4LjE0NDA5MV0gIFs8ZmZmZmZmZmY4MTkyYzZkMD5dID8gZmNfcmVhZCsweGIwLzB4
YjAKWyAgICA4LjE0NTMzNl0gIFs8ZmZmZmZmZmY4MTViZmYxZj5dIGRyaXZlcl9yZWdpc3Rl
cisweDZmLzB4MTUwClsgICAgOC4xNDY3MDBdICBbPGZmZmZmZmZmODE5MmM2ZDA+XSA/IGZj
X3JlYWQrMHhiMC8weGIwClsgICAgOC4xNDc5NjBdICBbPGZmZmZmZmZmODE5MmE3ZjA+XSBm
bWNfZHJpdmVyX3JlZ2lzdGVyKzB4MzAvMHg0MApbICAgIDguMTQ5NDE1XSAgWzxmZmZmZmZm
ZjgxOTJjNmUwPl0gZmNfaW5pdCsweDEwLzB4MjAKWyAgICA4LjE1MDYzNV0gIFs8ZmZmZmZm
ZmY4MjM3M2ZlYj5dIGRvX29uZV9pbml0Y2FsbCsweDc5LzB4MTE3ClsgICAgOC4xNTIwMDBd
ICBbPGZmZmZmZmZmODIzNzQxODQ+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweGZiLzB4MTdj
ClsgICAgOC4xNTM0NzZdICBbPGZmZmZmZmZmODIzNzM4ODE+XSA/IGRvX2Vhcmx5X3BhcmFt
KzB4ODgvMHg4OApbICAgIDguMTU0ODMxXSAgWzxmZmZmZmZmZjgxYjcxYzkwPl0gPyByZXN0
X2luaXQrMHg5MC8weDkwClsgICAgOC4xNTYxNDRdICBbPGZmZmZmZmZmODFiNzFjOTk+XSBr
ZXJuZWxfaW5pdCsweDkvMHgxODAKWyAgICA4LjE1NzQyNF0gIFs8ZmZmZmZmZmY4MWI4NmI3
YT5dIHJldF9mcm9tX2ZvcmsrMHg3YS8weGIwClsgICAgOC4xNTg3NDVdICBbPGZmZmZmZmZm
ODFiNzFjOTA+XSA/IHJlc3RfaW5pdCsweDkwLzB4OTAKWyAgICA4LjE2MDEwM10gZm1jX2No
YXJkZXYgZmFrZS1kZXNpZ24tZm9yLXRlc3RpbmctZjAwMTogQ3JlYXRlZCBtaXNjIGRldmlj
ZSAiZmFrZS1kZXNpZ24tZm9yLXRlc3RpbmctZjAwMSIKWyAgICA4LjE2MjQ0OF0gQXVkaW8g
RXhjZWwgRFNQIDE2IGluaXQgZHJpdmVyIENvcHlyaWdodCAoQykgUmljY2FyZG8gRmFjY2hl
dHRpIDE5OTUtOTgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9hZjE1Zjhk
ZTRmM2E3YjI4ZTNhMmMyMDY0YWQ3NDEwNjc2NzUxNmNhL2RtZXNnLWt2bS1iYXktMjgxODMt
MjAxMzA3MDEyMzMxMzktMy4xMC4wLXdsLTA2MDM2LWdhZjE1ZjhkLTEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9hZjE1ZjhkZTRmM2E3YjI4ZTNhMmMyMDY0YWQ3NDEw
Njc2NzUxNmNhL2RtZXNnLWt2bS1iZW5zLTM2MzYtMjAxMzA3MDMxMDQwMDYtMy4xMC4wLXds
LTA2MDM2LWdhZjE1ZjhkLTEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9h
ZjE1ZjhkZTRmM2E3YjI4ZTNhMmMyMDY0YWQ3NDEwNjc2NzUxNmNhL2RtZXNnLWt2bS12cC0x
MDQyMy0yMDEzMDcwMzEwNDE1OS0zLjEwLjAtd2wtMDYwMzYtZ2FmMTVmOGQtMQova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2FmMTVmOGRlNGYzYTdiMjhlM2EyYzIwNjRh
ZDc0MTA2NzY3NTE2Y2EvZG1lc2cta3ZtLXZwLTEwNDIzLTIwMTMwNzAzMTA0MjE4LTMuMTAu
MC13bC0wNjAzNi1nYWYxNWY4ZC0xCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3
MDEvYWYxNWY4ZGU0ZjNhN2IyOGUzYTJjMjA2NGFkNzQxMDY3Njc1MTZjYS9kbWVzZy1rdm0t
dnAtMTA0MjMtMjAxMzA3MDMxMDQyMzEtMy4xMC4wLXdsLTA2MDM2LWdhZjE1ZjhkLTEKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9hZjE1ZjhkZTRmM2E3YjI4ZTNhMmMy
MDY0YWQ3NDEwNjc2NzUxNmNhL2RtZXNnLWt2bS12cC0xMzk2Mi0yMDEzMDcwMzEwNDIwOC0z
LjEwLjAtcmMxLTAwMDAxLWdmZmE1OWY1NS0xNQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWMyNS0wNzAxL2FmMTVmOGRlNGYzYTdiMjhlM2EyYzIwNjRhZDc0MTA2NzY3NTE2Y2EvZG1l
c2cta3ZtLXZwLTEzOTYyLTIwMTMwNzAzMTA0MjIzLTMuMTAuMC1yYzEtMDAwMDEtZ2ZmYTU5
ZjU1LTE1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvYWYxNWY4ZGU0ZjNh
N2IyOGUzYTJjMjA2NGFkNzQxMDY3Njc1MTZjYS9kbWVzZy1rdm0tdnAtMTQyMDktMjAxMzA3
MDEyMzMwMjUtMy4xMC4wLTAwNTgyLWc3YzliYWQwLTM3Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctYzI1LTA3MDEvYWYxNWY4ZGU0ZjNhN2IyOGUzYTJjMjA2NGFkNzQxMDY3Njc1MTZj
YS9kbWVzZy1rdm0tdnAtMTQ1MzgtMjAxMzA3MDEyMzMwMjAtMy4xMC4wLXdsLTA2MDM2LWdh
ZjE1ZjhkLTEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9hZjE1ZjhkZTRm
M2E3YjI4ZTNhMmMyMDY0YWQ3NDEwNjc2NzUxNmNhL2RtZXNnLWt2bS12cC0xNDgwNS0yMDEz
MDcwMTIzMzAyNy0zLjEwLjAtMDA1NzUtZzgyNGQyY2YtMjUKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1jMjUtMDcwMS9hZjE1ZjhkZTRmM2E3YjI4ZTNhMmMyMDY0YWQ3NDEwNjc2NzUx
NmNhL2RtZXNnLWt2bS12cC0xNjkwOS0yMDEzMDcwMzEwNDIzNS0zLjEwLjAtcmMxLTAwMjc0
LWc3ZDIwNGI2LTI1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvYWYxNWY4
ZGU0ZjNhN2IyOGUzYTJjMjA2NGFkNzQxMDY3Njc1MTZjYS9kbWVzZy1rdm0tdnAtMTcxNzIt
MjAxMzA3MDMxMDQyMDgtMy4xMC4wLTAyOTI1LWcwOGZiNzUyNC00Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctYzI1LTA3MDEvYWYxNWY4ZGU0ZjNhN2IyOGUzYTJjMjA2NGFkNzQxMDY3
Njc1MTZjYS9kbWVzZy1rdm0tdnAtMTcxNzItMjAxMzA3MDMxMDQyMjItMy4xMC4wLTAyOTI1
LWcwOGZiNzUyNC00Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvYWYxNWY4
ZGU0ZjNhN2IyOGUzYTJjMjA2NGFkNzQxMDY3Njc1MTZjYS9kbWVzZy1rdm0tdnAtMTc1MDkt
MjAxMzA3MDMxMDQyMTItMy4xMC4wLXJjMS0wMDI3NC1nN2QyMDRiNi0yNQova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2FmMTVmOGRlNGYzYTdiMjhlM2EyYzIwNjRhZDc0
MTA2NzY3NTE2Y2EvZG1lc2cta3ZtLXZwLTE3NTA5LTIwMTMwNzAzMTA0MjI3LTMuMTAuMC1y
YzEtMDAyNzQtZzdkMjA0YjYtMjUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcw
MS9hZjE1ZjhkZTRmM2E3YjI4ZTNhMmMyMDY0YWQ3NDEwNjc2NzUxNmNhL2RtZXNnLWt2bS12
cC0yMDE3NS0yMDEzMDcwMzEwNDIwOC0zLjEwLjAtMDI5MjUtZzNmZTk4MTEtOQova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2FmMTVmOGRlNGYzYTdiMjhlM2EyYzIwNjRh
ZDc0MTA2NzY3NTE2Y2EvZG1lc2cta3ZtLXZwLTIxNzE3LTIwMTMwNzAzMTA0MjM1LTMuMTAu
MC1yYzEtMDAyNzQtZzdkMjA0YjYtMjUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUt
MDcwMS9hZjE1ZjhkZTRmM2E3YjI4ZTNhMmMyMDY0YWQ3NDEwNjc2NzUxNmNhL2RtZXNnLWt2
bS12cC0yMjYzMy0yMDEzMDcwMTIzMzAyNy0zLjEwLjAtcmM0LTAwMDc5LWcwN2NlNzQwLTI1
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvYWYxNWY4ZGU0ZjNhN2IyOGUz
YTJjMjA2NGFkNzQxMDY3Njc1MTZjYS9kbWVzZy1rdm0tdnAtMjcxNzMtMjAxMzA3MDMxMDQy
MjAtMy4xMC4wLTAyOTI1LWdkMzA0ZjQwLTIxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
YzI1LTA3MDEvYWYxNWY4ZGU0ZjNhN2IyOGUzYTJjMjA2NGFkNzQxMDY3Njc1MTZjYS9kbWVz
Zy1rdm0tdnAtMjcxNzMtMjAxMzA3MDMxMDQyMzUtMy4xMC4wLTAyOTI1LWdkMzA0ZjQwLTIx
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvYWYxNWY4ZGU0ZjNhN2IyOGUz
YTJjMjA2NGFkNzQxMDY3Njc1MTZjYS9kbWVzZy1rdm0tdnAtOTYxNC0yMDEzMDcwMTIzMzAy
NS0zLjEwLjAtcmM1LXdsLTY4MjQ3LWc3MzlhN2M2LTQwCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctYzI1LTA3MDEvYWYxNWY4ZGU0ZjNhN2IyOGUzYTJjMjA2NGFkNzQxMDY3Njc1MTZj
YS9kbWVzZy1rdm0tdnAtOTgwNy0yMDEzMDcwMTIzMzAyMC0zLjEwLjAtMDA1NzUtZzllYWI5
ZTUtMjkKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9hZjE1ZjhkZTRmM2E3
YjI4ZTNhMmMyMDY0YWQ3NDEwNjc2NzUxNmNhL2RtZXNnLWt2bS13YWltZWEtMjE0MTQtMjAx
MzA3MDMxMDQzNDAtMy4xMC4wLXdsLTA2MDM2LWdhZjE1ZjhkLTEKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1jMjUtMDcwMS9hZjE1ZjhkZTRmM2E3YjI4ZTNhMmMyMDY0YWQ3NDEwNjc2
NzUxNmNhL2RtZXNnLWt2bS13YWltZWEtMjE0MTQtMjAxMzA3MDMxMDQzNTMtMy4xMC4wLXds
LTA2MDM2LWdhZjE1ZjhkLTEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9h
ZjE1ZjhkZTRmM2E3YjI4ZTNhMmMyMDY0YWQ3NDEwNjc2NzUxNmNhL2RtZXNnLWt2bS13YWlt
ZWEtMjE0MTUtMjAxMzA3MDMxMDQ0MDUtMy4xMC4wLTAyOTI1LWcwOGZiNzUyNC00Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvYWYxNWY4ZGU0ZjNhN2IyOGUzYTJjMjA2
NGFkNzQxMDY3Njc1MTZjYS9kbWVzZy1rdm0td2FpbWVhLTIxNDE4LTIwMTMwNzAxMjMzMjA2
LTMuMTAuMC0wMDUyNC1nZTQ3YmY0Mi0yMAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMy
NS0wNzAxL2FmMTVmOGRlNGYzYTdiMjhlM2EyYzIwNjRhZDc0MTA2NzY3NTE2Y2EvZG1lc2ct
a3ZtLXdhaW1lYS0zNzE1LTIwMTMwNzAxMjMzMjA2LTMuMTAuMC13bC0wNjAzNi1nYWYxNWY4
ZC0xCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvYWYxNWY4ZGU0ZjNhN2Iy
OGUzYTJjMjA2NGFkNzQxMDY3Njc1MTZjYS9kbWVzZy1rdm0td2FpbWVhLTM3MTUtMjAxMzA3
MDMxMDQzNDctMy4xMC4wLTAyOTI1LWcwOGZiNzUyNC00Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctYzI1LTA3MDEvYWYxNWY4ZGU0ZjNhN2IyOGUzYTJjMjA2NGFkNzQxMDY3Njc1MTZj
YS9kbWVzZy1rdm0teGd3by0xMTg3NC0yMDEzMDcwMzEwNDAwNy0zLjEwLjAtd2wtMDYwMzYt
Z2FmMTVmOGQtMQoKSEVBRCBpcyBub3cgYXQgYWYxNWY4ZCBNZXJnZSByZW1vdGUtdHJhY2tp
bmcgYnJhbmNoICd4bG54L3p5bnEvY2xrJyBpbnRvIGRldmVsLWNhaXJvLXg4Nl82NC0yMDEz
MDcwMTIyNDAKCj09PT09PT09PSB1cHN0cmVhbSA9PT09PT09PT0KRmV0Y2hpbmcgbGludXMK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMy
NS0wNzAxL2xpbnV4LWRldmVsOmRldmVsLWNhaXJvLXg4Nl82NC0yMDEzMDcwMTIyNDA6MGIw
NTg1YzNlMTkyOTY3Y2IyZWYwYWMwODE2ZWI4YThjOGQ5OTg0MDpiaXNlY3QtdXNiCgoyMDEz
LTA3LTAzLTE0OjQyOjQ4IDBiMDU4NWMzZTE5Mjk2N2NiMmVmMGFjMDgxNmViOGE4YzhkOTk4
NDAgY29tcGlsaW5nCgoyMDEzLTA3LTAzLTE0OjQ2OjQ4IGRldGVjdGluZyBib290IHN0YXRl
IDMuMTAuMC0wMzkxMC1nMGIwNTg1Yy4uIFRFU1QgRkFJTFVSRQpbICAgIDcuNzMyNzQ3XSBm
bWNfd3JpdGVfZWVwcm9tIGZha2UtZGVzaWduLWZvci10ZXN0aW5nLWYwMDE6IGZtY193cml0
ZV9lZXByb206IG5vIGJ1c2lkIHBhc3NlZCwgcmVmdXNpbmcgYWxsIGNhcmRzClsgICAgNy43
MzU5NTZdIGZtYyBmYWtlLWRlc2lnbi1mb3ItdGVzdGluZy1mMDAxOiBEcml2ZXIgaGFzIG5v
IElEOiBtYXRjaGVzIGFsbApbICAgIDcuNzM4MTQyXSBCVUc6IHNjaGVkdWxpbmcgd2hpbGUg
YXRvbWljOiBzd2FwcGVyLzEvMHgxMDAwMDAwMgpbICAgIDcuNzM5OTk0XSBDUFU6IDAgUElE
OiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xMC4wLTAzOTEwLWcwYjA1ODVjICMx
MzMKWyAgICA3Ljc0MjQ3Nl0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9j
aHMgMDEvMDEvMjAxMQpbICAgIDcuNzQ0MzIyXSAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgw
MDBkYzU3YjAwIGZmZmZmZmZmODFiNjFkNGQgZmZmZjg4MDAwZGM1N2IxMApbICAgIDcuNzQ3
Mjk0XSAgZmZmZmZmZmY4MWI1ZTBhMyBmZmZmODgwMDBkYzU3YjcwIGZmZmZmZmZmODFiNmE4
NGUgZmZmZmZmZmY4MTBkYzZjMApbICAgIDcuNzUwMzE0XSAgZmZmZjg4MDAwZGM1N2ZkOCBm
ZmZmODgwMDBkYzU3ZmQ4IGZmZmY4ODAwMGRjNTdmZDggZmZmZjg4MDAwZGM1N2ZkOApbICAg
IDcuNzUzMjg5XSBDYWxsIFRyYWNlOgpbICAgIDcuNzU0Mjc0XSAgWzxmZmZmZmZmZjgxYjYx
ZDRkPl0gZHVtcF9zdGFjaysweDE5LzB4MWIKWyAgICA3Ljc1NTk1MF0gIFs8ZmZmZmZmZmY4
MWI1ZTBhMz5dIF9fc2NoZWR1bGVfYnVnKzB4NDIvMHg1MApbICAgIDcuNzU3NzI3XSAgWzxm
ZmZmZmZmZjgxYjZhODRlPl0gX19zY2hlZHVsZSsweDUwZS8weDUyMApbICAgIDcuNzU5NDQy
XSAgWzxmZmZmZmZmZjgxMGRjNmMwPl0gPyBfX2VucXVldWVfZW50aXR5KzB4NzAvMHg4MApb
ICAgIDcuNzYxMzEwXSAgWzxmZmZmZmZmZjgxMGQ5MTUwPl0gX19jb25kX3Jlc2NoZWQrMHgy
MC8weDMwClsgICAgNy43NjMwNzhdICBbPGZmZmZmZmZmODFiNmE5ZjM+XSBfY29uZF9yZXNj
aGVkKzB4MzMvMHg0MApbICAgIDcuNzY0ODI4XSAgWzxmZmZmZmZmZjgxYjZhY2VhPl0gd2Fp
dF9mb3JfY29tcGxldGlvbisweDJhLzB4MTQwClsgICAgNy43NjY3MDddICBbPGZmZmZmZmZm
ODE1YmQ2NDQ+XSBkZXZ0bXBmc19jcmVhdGVfbm9kZSsweGY0LzB4MTMwClsgICAgNy43Njg2
NzJdICBbPGZmZmZmZmZmODE1YjViMGU+XSBkZXZpY2VfYWRkKzB4MjNlLzB4NmIwClsgICAg
Ny43NzAzODNdICBbPGZmZmZmZmZmODE1YjY3MTA+XSBkZXZpY2VfY3JlYXRlX3ZhcmdzKzB4
ZDAvMHgxMDAKWyAgICA3Ljc3MjI4Nl0gIFs8ZmZmZmZmZmY4MTViNjc2Zj5dIGRldmljZV9j
cmVhdGUrMHgyZi8weDQwClsgICAgNy43NzQwMjNdICBbPGZmZmZmZmZmODFiNjk5NjA+XSA/
IG11dGV4X2xvY2srMHgyMC8weDMwClsgICAgNy43NzU3MjldICBbPGZmZmZmZmZmODE1ODJj
OTY+XSBtaXNjX3JlZ2lzdGVyKzB4YzYvMHgxMjAKWyAgICA3Ljc3NzUxMl0gIFs8ZmZmZmZm
ZmY4MTkxYTcxOD5dIGZjX3Byb2JlKzB4OTgvMHgxNDAKWyAgICA3Ljc3OTE1NV0gIFs8ZmZm
ZmZmZmY4MTkxODUyMj5dIGZtY19wcm9iZSsweDEyLzB4MjAKWyAgICA3Ljc4MDgyNF0gIFs8
ZmZmZmZmZmY4MTViOTBmMj5dIHJlYWxseV9wcm9iZSsweDUyLzB4MWYwClsgICAgNy43ODI1
NTNdICBbPGZmZmZmZmZmODE1YjkzOTE+XSBfX2RyaXZlcl9hdHRhY2grMHg5MS8weGEwClsg
ICAgNy43ODQzNDhdICBbPGZmZmZmZmZmODE1YjkzMDA+XSA/IF9fZGV2aWNlX2F0dGFjaCsw
eDUwLzB4NTAKWyAgICA3Ljc4NjE3M10gIFs8ZmZmZmZmZmY4MTViNzY5Mz5dIGJ1c19mb3Jf
ZWFjaF9kZXYrMHg2My8weGEwClsgICAgNy43ODc5NzVdICBbPGZmZmZmZmZmODE1YjkwMjk+
XSBkcml2ZXJfYXR0YWNoKzB4MTkvMHgyMApbICAgIDcuNzg5Nzc4XSAgWzxmZmZmZmZmZjgx
NWI4MDc4Pl0gYnVzX2FkZF9kcml2ZXIrMHgxYjgvMHgyNTAKWyAgICA3Ljc5MTU2NF0gIFs8
ZmZmZmZmZmY4MTkxYTY0MD5dID8gZmNfcmVhZCsweGEwLzB4YTAKWyAgICA3Ljc5MzIyOF0g
IFs8ZmZmZmZmZmY4MTViOWIxYz5dIGRyaXZlcl9yZWdpc3RlcisweDZjLzB4MTUwClsgICAg
Ny43OTUwMzddICBbPGZmZmZmZmZmODE5MWE2NDA+XSA/IGZjX3JlYWQrMHhhMC8weGEwClsg
ICAgNy43OTY2OTVdICBbPGZmZmZmZmZmODE5MTg2YzA+XSBmbWNfZHJpdmVyX3JlZ2lzdGVy
KzB4MzAvMHg0MApbICAgIDcuNzk4NTYzXSAgWzxmZmZmZmZmZjgxOTFhNjUwPl0gZmNfaW5p
dCsweDEwLzB4MjAKWyAgICA3LjgwMDE4MV0gIFs8ZmZmZmZmZmY4MjM3MWZlYj5dIGRvX29u
ZV9pbml0Y2FsbCsweDc5LzB4MTE3ClsgICAgNy44MDE5ODFdICBbPGZmZmZmZmZmODIzNzIx
ODQ+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweGZiLzB4MTdjClsgICAgNy44MDM4OTZdICBb
PGZmZmZmZmZmODIzNzE4ODE+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4ODgvMHg4OApbICAgIDcu
ODA1NzE4XSAgWzxmZmZmZmZmZjgxYjU3YmUwPl0gPyByZXN0X2luaXQrMHg5MC8weDkwClsg
ICAgNy44MDc0MDVdICBbPGZmZmZmZmZmODFiNTdiZTk+XSBrZXJuZWxfaW5pdCsweDkvMHgx
ODAKWyAgICA3LjgwOTE1M10gIFs8ZmZmZmZmZmY4MWI2Y2VmYT5dIHJldF9mcm9tX2Zvcmsr
MHg3YS8weGIwClsgICAgNy44MTA4ODRdICBbPGZmZmZmZmZmODFiNTdiZTA+XSA/IHJlc3Rf
aW5pdCsweDkwLzB4OTAKWyAgICA3LjgxMjU5NF0gZm1jX2NoYXJkZXYgZmFrZS1kZXNpZ24t
Zm9yLXRlc3RpbmctZjAwMTogQ3JlYXRlZCBtaXNjIGRldmljZSAiZmFrZS1kZXNpZ24tZm9y
LXRlc3RpbmctZjAwMSIKWyAgICA3LjgxNTY4Ml0gQXVkaW8gRXhjZWwgRFNQIDE2IGluaXQg
ZHJpdmVyIENvcHlyaWdodCAoQykgUmljY2FyZG8gRmFjY2hldHRpIDE5OTUtOTgKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS8wYjA1ODVjM2UxOTI5NjdjYjJlZjBhYzA4
MTZlYjhhOGM4ZDk5ODQwL2RtZXNnLWt2bS12cC0xMzUzNy0yMDEzMDcwMzE0NDgyNy0zLjEw
LjAtMDAzNDktZzdlNmM4NGMtOAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAx
LzBiMDU4NWMzZTE5Mjk2N2NiMmVmMGFjMDgxNmViOGE4YzhkOTk4NDAvZG1lc2cta3ZtLXZw
LTE5NjM4LTIwMTMwNzAzMTQ0ODI4LTMuMTAuMC1yYzUtMDAwOTQtZzlmZjlmNmQtOAova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxLzBiMDU4NWMzZTE5Mjk2N2NiMmVmMGFj
MDgxNmViOGE4YzhkOTk4NDAvZG1lc2cta3ZtLXZwLTIwODg0LTIwMTMwNzAzMTQ0ODI5LTMu
MTAuMC0wMDI4OS1nMDIyNmIxMy0yMQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0w
NzAxLzBiMDU4NWMzZTE5Mjk2N2NiMmVmMGFjMDgxNmViOGE4YzhkOTk4NDAvZG1lc2cta3Zt
LXZwLTI4ODgzLTIwMTMwNzAzMTQ0ODIzLTMuMTAuMC0wMzkxMC1nMGIwNTg1Yy0xMzMKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS8wYjA1ODVjM2UxOTI5NjdjYjJlZjBh
YzA4MTZlYjhhOGM4ZDk5ODQwL2RtZXNnLWt2bS12cC02Mjk0LTIwMTMwNzAzMTQ0ODMxLTMu
MTAuMC1yYzEtMDAyNzQtZzdkMjA0YjYtMjUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1j
MjUtMDcwMS8wYjA1ODVjM2UxOTI5NjdjYjJlZjBhYzA4MTZlYjhhOGM4ZDk5ODQwL2RtZXNn
LWt2bS12cC02NTc2LTIwMTMwNzAzMTQ0ODMxLTMuMTAuMC1yYzctMDAxOTQtZzViMGUyZTUt
MTMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS8wYjA1ODVjM2UxOTI5Njdj
YjJlZjBhYzA4MTZlYjhhOGM4ZDk5ODQwL2RtZXNnLWt2bS12cC02ODY0LTIwMTMwNzAzMTQ0
ODMwLTMuMTAuMC0wMDI4OS1nMDIyNmIxMy0yMAova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWMyNS0wNzAxLzBiMDU4NWMzZTE5Mjk2N2NiMmVmMGFjMDgxNmViOGE4YzhkOTk4NDAvZG1l
c2cta3ZtLXdhaW1lYS0xNDgzMC0yMDEzMDcwMzE0NTAxNy0zLjEwLjAtcmM1LTAwMDk0LWc5
ZmY5ZjZkLTgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS8wYjA1ODVjM2Ux
OTI5NjdjYjJlZjBhYzA4MTZlYjhhOGM4ZDk5ODQwL2RtZXNnLWt2bS13YWltZWEtMjE0MTgt
MjAxMzA3MDMxNDUwMTktMy4xMC4wLXJjNy0wMDEyMC1nZWNhYWRlMy0xNQova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxLzBiMDU4NWMzZTE5Mjk2N2NiMmVmMGFjMDgxNmVi
OGE4YzhkOTk4NDAvZG1lc2cta3ZtLXdhaW1lYS0yMTQxOS0yMDEzMDcwMzE0NTAxNi0zLjEw
LjAtMDM5MTAtZzBiMDU4NWMtMTMzCgoKPT09PT09PT09IGxpbnV4LW5leHQgPT09PT09PT09
CkZldGNoaW5nIG5leHQKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82
NC1yYW5kY29uZmlnLWMyNS0wNzAxL2xpbnV4LWRldmVsOmRldmVsLWNhaXJvLXg4Nl82NC0y
MDEzMDcwMTIyNDA6ZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3Mzpi
aXNlY3QtdXNiCgoyMDEzLTA3LTAzLTE0OjUzOjI4IGU4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5
OGIzZGQ0NGE5NWFiODA1NzMgY29tcGlsaW5nCgoyMDEzLTA3LTAzLTE0OjU2OjUxIGRldGVj
dGluZyBib290IHN0YXRlIDMuMTAuMC1uZXh0LTIwMTMwNzAyLTEwNTk0LWdlOGUxZjRjLi4u
LiBURVNUIEZBSUxVUkUKWyAgIDEyLjY4MDQxMF0gZm1jX3dyaXRlX2VlcHJvbSBmYWtlLWRl
c2lnbi1mb3ItdGVzdGluZy1mMDAxOiBmbWNfd3JpdGVfZWVwcm9tOiBubyBidXNpZCBwYXNz
ZWQsIHJlZnVzaW5nIGFsbCBjYXJkcwpbICAgMTIuNjg0MTIyXSBmbWMgZmFrZS1kZXNpZ24t
Zm9yLXRlc3RpbmctZjAwMTogRHJpdmVyIGhhcyBubyBJRDogbWF0Y2hlcyBhbGwKWyAgIDEy
LjY4NjY4OV0gQlVHOiBzY2hlZHVsaW5nIHdoaWxlIGF0b21pYzogc3dhcHBlci8xLzB4MTAw
MDAwMDIKWyAgIDEyLjY4ODg1NF0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyIE5vdCB0
YWludGVkIDMuMTAuMC1uZXh0LTIwMTMwNzAyLTEwNTk0LWdlOGUxZjRjICMxMzQKWyAgIDEy
LjY5MTg0Nl0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEv
MjAxMQpbICAgMTIuNjk0MTA2XSAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDBkYzU3YWI4
IGZmZmZmZmZmODFiNjlhY2EgZmZmZjg4MDAwZGM1N2FjOApbICAgMTIuNjk3NTk2XSAgZmZm
ZmZmZmY4MWI2NWYwMyBmZmZmODgwMDBkYzU3YjI4IGZmZmZmZmZmODFiNzI4ZGUgZmZmZmZm
ZmY4MTBkMzhkMApbICAgMTIuNzAxMDMzXSAgZmZmZjg4MDAwZGM1N2ZkOCBmZmZmODgwMDBk
YzU3ZmQ4IGZmZmY4ODAwMGRjNTdmZDggZmZmZjg4MDAwZGM1N2ZkOApbICAgMTIuNzA0MzMw
XSBDYWxsIFRyYWNlOgpbICAgMTIuNzA1NDc3XSAgWzxmZmZmZmZmZjgxYjY5YWNhPl0gZHVt
cF9zdGFjaysweDE5LzB4MWIKWyAgIDEyLjcwNzQ5M10gIFs8ZmZmZmZmZmY4MWI2NWYwMz5d
IF9fc2NoZWR1bGVfYnVnKzB4NDIvMHg1MApbICAgMTIuNzA5NDI0XSAgWzxmZmZmZmZmZjgx
YjcyOGRlPl0gX19zY2hlZHVsZSsweDUwZS8weDUyMApbICAgMTIuNzExNDgxXSAgWzxmZmZm
ZmZmZjgxMGQzOGQwPl0gPyBfX2VucXVldWVfZW50aXR5KzB4NzAvMHg4MApbICAgMTIuNzEz
NjczXSAgWzxmZmZmZmZmZjgxMGQwMWYwPl0gX19jb25kX3Jlc2NoZWQrMHgyMC8weDMwClsg
ICAxMi43MTU2MTRdICBbPGZmZmZmZmZmODFiNzJhODM+XSBfY29uZF9yZXNjaGVkKzB4MzMv
MHg0MApbICAgMTIuNzE3ODE0XSAgWzxmZmZmZmZmZjgxYjcyZDdhPl0gd2FpdF9mb3JfY29t
cGxldGlvbisweDJhLzB4MTQwClsgICAxMi43MjAxMjRdICBbPGZmZmZmZmZmODE1YmE0NjQ+
XSBkZXZ0bXBmc19jcmVhdGVfbm9kZSsweGY0LzB4MTMwClsgICAxMi43MjIxOTJdICBbPGZm
ZmZmZmZmODE1YjI0NGU+XSBkZXZpY2VfYWRkKzB4MjNlLzB4NmYwClsgICAxMi43MjM5OTRd
ICBbPGZmZmZmZmZmODE1YjMzMDA+XSBkZXZpY2VfY3JlYXRlX3ZhcmdzKzB4ZDAvMHgxMDAK
WyAgIDEyLjcyNjA0Nl0gIFs8ZmZmZmZmZmY4MTViMzM1Zj5dIGRldmljZV9jcmVhdGUrMHgy
Zi8weDQwClsgICAxMi43MjgxMDVdICBbPGZmZmZmZmZmODFiNzE5YTA+XSA/IG11dGV4X2xv
Y2srMHgyMC8weDMwClsgICAxMi43MzAxMDddICBbPGZmZmZmZmZmODE1N2VhZjY+XSBtaXNj
X3JlZ2lzdGVyKzB4YzYvMHgxMjAKWyAgIDEyLjczMjIxMV0gIFs8ZmZmZmZmZmY4MTkxZDUz
OD5dIGZjX3Byb2JlKzB4OTgvMHgxNDAKWyAgIDEyLjczNDAyMV0gIFs8ZmZmZmZmZmY4MTkx
YjM0Mj5dIGZtY19wcm9iZSsweDEyLzB4MjAKWyAgIDEyLjczNTkwMF0gIFs8ZmZmZmZmZmY4
MTViNWQ5Mj5dIHJlYWxseV9wcm9iZSsweDUyLzB4MWYwClsgICAxMi43Mzc5NThdICBbPGZm
ZmZmZmZmODE1YjYwMzE+XSBfX2RyaXZlcl9hdHRhY2grMHg5MS8weGEwClsgICAxMi43Mzk4
NThdICBbPGZmZmZmZmZmODE1YjVmYTA+XSA/IF9fZGV2aWNlX2F0dGFjaCsweDUwLzB4NTAK
WyAgIDEyLjc0MTgwOV0gIFs8ZmZmZmZmZmY4MTViNDI5Mz5dIGJ1c19mb3JfZWFjaF9kZXYr
MHg2My8weGEwClsgICAxMi43NDM4MDZdICBbPGZmZmZmZmZmODE1YjVjYzk+XSBkcml2ZXJf
YXR0YWNoKzB4MTkvMHgyMApbICAgMTIuNzQ1NzYxXSAgWzxmZmZmZmZmZjgxNWI0Y2Q4Pl0g
YnVzX2FkZF9kcml2ZXIrMHgxYzgvMHgyNjAKWyAgIDEyLjc0NzcyMl0gIFs8ZmZmZmZmZmY4
MTkxZDQ2MD5dID8gZmNfcmVhZCsweGEwLzB4YTAKWyAgIDEyLjc0OTQ5M10gIFs8ZmZmZmZm
ZmY4MTViNjdkZj5dIGRyaXZlcl9yZWdpc3RlcisweDZmLzB4MTUwClsgICAxMi43NTE0MjNd
ICBbPGZmZmZmZmZmODE5MWQ0NjA+XSA/IGZjX3JlYWQrMHhhMC8weGEwClsgICAxMi43NTMx
NzddICBbPGZmZmZmZmZmODE5MWI0ZTA+XSBmbWNfZHJpdmVyX3JlZ2lzdGVyKzB4MzAvMHg0
MApbICAgMTIuNzU1MTU4XSAgWzxmZmZmZmZmZjgxOTFkNDcwPl0gZmNfaW5pdCsweDEwLzB4
MjAKWyAgIDEyLjc1NjkwNF0gIFs8ZmZmZmZmZmY4MjM3MmZmZT5dIGRvX29uZV9pbml0Y2Fs
bCsweDhjLzB4MTMzClsgICAxMi43NTg4NjBdICBbPGZmZmZmZmZmODEwYzU0YTg+XSA/IHBh
cnNlX2FyZ3MrMHgxZjgvMHgzMzAKWyAgIDEyLjc2MDgzNF0gIFs8ZmZmZmZmZmY4MjM3MzFh
MD5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4ZmIvMHgxN2MKWyAgIDEyLjc2Mjg5MV0gIFs8
ZmZmZmZmZmY4MjM3Mjg4MT5dID8gZG9fZWFybHlfcGFyYW0rMHg4OC8weDg4ClsgICAxMi43
NjQ5MTRdICBbPGZmZmZmZmZmODFiNWZlMTA+XSA/IHJlc3RfaW5pdCsweDkwLzB4OTAKWyAg
IDEyLjc2NjcyNV0gIFs8ZmZmZmZmZmY4MWI1ZmUxOT5dIGtlcm5lbF9pbml0KzB4OS8weDE4
MApbICAgMTIuNzY4NTY0XSAgWzxmZmZmZmZmZjgxYjc0ZjdhPl0gcmV0X2Zyb21fZm9yaysw
eDdhLzB4YjAKWyAgIDEyLjc3MDM5OV0gIFs8ZmZmZmZmZmY4MWI1ZmUxMD5dID8gcmVzdF9p
bml0KzB4OTAvMHg5MApbICAgMTIuNzcyMjkyXSBmbWNfY2hhcmRldiBmYWtlLWRlc2lnbi1m
b3ItdGVzdGluZy1mMDAxOiBDcmVhdGVkIG1pc2MgZGV2aWNlICJmYWtlLWRlc2lnbi1mb3It
dGVzdGluZy1mMDAxIgpbICAgMTIuNzc1NjUyXSBBdWRpbyBFeGNlbCBEU1AgMTYgaW5pdCBk
cml2ZXIgQ29weXJpZ2h0IChDKSBSaWNjYXJkbyBGYWNjaGV0dGkgMTk5NS05OAova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIz
ZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXZwLTI3ODg4LTIwMTMwNzAzMTQ1ODUyLTMuMTAu
MC0wMDI4OS1nMDIyNmIxMy0yMAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAx
L2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXZw
LTE5NjM4LTIwMTMwNzAzMTQ1ODI4LTMuMTAuMC1yYzUtMDAwOTQtZzlmZjlmNmQtOAova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5
OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLWF0aGVucy0yNjE1NC0yMDEzMDcwMzE1MDA0
MC0tCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4
YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0tdnAtNzUxNC0yMDEzMDcwMzE0
NTg1Ni0zLjQuMC02MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFm
NGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXdhaW1lYS0y
MTQyMC0yMDEzMDcwMzE1MDEwNS0zLjEwLjAtcmM3LTAwMTIwLWdlY2FhZGUzLTE1Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4
YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0teGd3by0zMjE5LTIwMTMwNzAzMTQ1NzI0LTMu
MTAuMC1yYzEtMDA1MjUtZ2E1MWQ4MWMtNjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1j
MjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgwNTczL2RtZXNn
LWt2bS12cC0xOTYzOC0yMDEzMDcwMzE0NTg1Ni0zLjEwLjAtcmM1LTAwMDk0LWc5ZmY5ZjZk
LTgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThh
YWQ1OTg2OThiM2RkNDRhOTVhYjgwNTczL2RtZXNnLWt2bS12cC03NTE0LTIwMTMwNzAzMTQ1
OTM5LTMuNC4wLTYwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0
YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0td2FpbWVhLTM2
MDItMjAxMzA3MDMxNTAxMDYtMy4xMC4wLTAwMjg5LWcxYzI0ZTE5LTMwCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0
YTk1YWI4MDU3My9kbWVzZy1rdm0tYXRoZW5zLTMwMjIwLTIwMTMwNzAzMTUwMDI3LTMuMTAu
MC1uZXh0LTIwMTMwNzAyLTEwNTk0LWdlOGUxZjRjLTEzNAova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1
NzMvZG1lc2cta3ZtLXZwLTI3ODg4LTIwMTMwNzAzMTQ1OTQxLTMuMTAuMC0wMDI4OS1nMDIy
NmIxMy0yMAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5
ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXZwLTE5NjM4LTIwMTMw
NzAzMTQ1OTQ1LTMuMTAuMC1yYzUtMDAwOTQtZzlmZjlmNmQtOAova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFi
ODA1NzMvZG1lc2cta3ZtLXZwLTc2ODYtMjAxMzA3MDMxNDU5MjctMy4xMC4wLXJjNS0wMDA5
NC1nOWZmOWY2ZC05Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0
YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0tYXRoZW5zLTMw
MjIwLTIwMTMwNzAzMTUwMDUzLTMuMTAuMC1uZXh0LTIwMTMwNzAyLTEwNTk0LWdlOGUxZjRj
LTEzNAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5
OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXdhaW1lYS00MjI3LTIwMTMw
NzAzMTUwMDExLTMuMTAuMC1uZXh0LTIwMTMwNzAyLTEwNTk0LWdlOGUxZjRjLTEzNAova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5
OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXZwLTc4MzUtMjAxMzA3MDMxNDU5NDItMy4x
MC4wLXJjNy0wMDEyMC1nZWNhYWRlMy0xMAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMy
NS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2ct
a3ZtLXZwLTI4MTYzLTIwMTMwNzAzMTQ1ODU1LTMuMTAuMC0wMDI4OS1nYmFkYzgxOC0yOAov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5
ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXZwLTE5ODgzLTIwMTMwNzAzMTQ1OTQx
LTMuMTAuMC1yYzctMDAxOTQtZzViMGUyZTUtNwova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1l
c2cta3ZtLWF0aGVucy0zNDcxOS0yMDEzMDcwMzE1MDA0MC0zLjEwLjAtMDI5MjUtZzNmZTk4
MTEtOQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5
OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXdhaW1lYS01MTIzLTIwMTMw
NzAzMTUwMTA3LTMuMTAuMC0wMDI4OS1nYjE5MGM1ZC0xNAova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1
NzMvZG1lc2cta3ZtLXZwLTc5OTktMjAxMzA3MDMxNDU5NDEtMy4xMC4wLXJjMS0wMDUyNS1n
YTUxZDgxYy02MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4
YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXZwLTI4MTYzLTIw
MTMwNzAzMTQ1OTQ0LTMuMTAuMC0wMDI4OS1nYmFkYzgxOC0yOAova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFi
ODA1NzMvZG1lc2cta3ZtLWF0aGVucy0zNTA3NS0yMDEzMDcwMzE1MDAzOS0tCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNk
ZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0td2FpbWVhLTU0NzMtMjAxMzA3MDMxNTAxMDMtMy4x
MC4wLTAwMjg5LWcwMjI2YjEzLTIxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3
MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0t
dnAtODE2NS0yMDEzMDcwMzE0NTk0My0zLjcuMC1yYzQtMDAxNTItZzE1ODJlZWEtNTYKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2
OThiM2RkNDRhOTVhYjgwNTczL2RtZXNnLWt2bS1hdGhlbnMtNDQxNTUtMjAxMzA3MDMxNTAw
NDAtLQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5
OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXdhaW1lYS02NjIyLTIwMTMw
NzAzMTUwMTA1LTMuMTAuMC1yYzEtMDA1MjUtZ2E1MWQ4MWMtMzUKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVh
YjgwNTczL2RtZXNnLWt2bS12cC04MzEzLTIwMTMwNzAzMTQ1ODI4LTMuMTAuMC1yYzctMDAx
OTQtZzViMGUyZTUtNwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFm
NGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLWJheS0xMDY3
NS0yMDEzMDcwMzE1MDAzOC0zLjEwLjAtMDM5MTAtZzBiMDU4NWMtMTMzCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0
YTk1YWI4MDU3My9kbWVzZy1rdm0tdnAtODMxMy0yMDEzMDcwMzE0NTg0OS0zLjEwLjAtcmM3
LTAwMTk0LWc1YjBlMmU1LTcKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9l
OGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgwNTczL2RtZXNnLWt2bS1iYXkt
MjgxODMtMjAxMzA3MDMxNDU5NDgtMy4xMC4wLW5leHQtMjAxMzA3MDItMTA1OTQtZ2U4ZTFm
NGMtMTM0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0YzhhNzk4
OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0td2FpbWVhLTcwMDQtMjAx
MzA3MDMxNTAxMDktMy4xMC4wLTAwMzQ5LWc3ZTZjODRjLTgKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgw
NTczL2RtZXNnLWt2bS1iYXktMjgxODMtMjAxMzA3MDMxNTAwMDYtMy4xMC4wLW5leHQtMjAx
MzA3MDItMTA1OTQtZ2U4ZTFmNGMtMTM0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1
LTA3MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1r
dm0td2FpbWVhLTg3NjgtMjAxMzA3MDMxNTAwMTItMy4xMC4wLTAwMjg5LWdiYWRjODE4LTI3
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4YWFk
NTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0tdnAtODMxMy0yMDEzMDcwMzE0NTkz
Ni0zLjEwLjAtcmM3LTAwMTk0LWc1YjBlMmU1LTcKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgwNTczL2Rt
ZXNnLWt2bS1iYXktMjgxODMtMjAxMzA3MDMxNTAwMjYtMy4xMC4wLW5leHQtMjAxMzA3MDIt
MTA1OTQtZ2U4ZTFmNGMtMTM0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEv
ZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0td2Fp
bWVhLTg3NjgtMjAxMzA3MDMxNTAwMzAtMy4xMC4wLTAwMjg5LWdiYWRjODE4LTI3Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4
YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0tdnAtODY2Mi0yMDEzMDcwMzE0NTgyNy0zLjEw
LjAtcmMxLTAwMjc0LWc3ZDIwNGI2LTI2Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1
LTA3MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1r
dm0tdnAtODgzNC0yMDEzMDcwMzE0NTg0MS0zLjEwLjAtMDAyODktZ2JhZGM4MTgtMjgKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2
OThiM2RkNDRhOTVhYjgwNTczL2RtZXNnLWt2bS13YWltZWEtODc2OC0yMDEzMDcwMzE1MDA0
OS0zLjEwLjAtMDAyODktZ2JhZGM4MTgtMjcKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1j
MjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgwNTczL2RtZXNn
LWt2bS1iZW5zLTMxMjEtMjAxMzA3MDMxNDU3MDktMy4xMC4wLTAwMzQ5LWc3ZTZjODRjLTgK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1
OTg2OThiM2RkNDRhOTVhYjgwNTczL2RtZXNnLWt2bS12cC04ODM0LTIwMTMwNzAzMTQ1OTEy
LTMuMTAuMC0wMDI4OS1nYmFkYzgxOC0yOAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMy
NS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2ct
a3ZtLWJlbnMtMzIyOC0yMDEzMDcwMzE0NTYyMS0zLjEwLjAtMDAyODktZ2IxOTBjNWQtMTQK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1
OTg2OThiM2RkNDRhOTVhYjgwNTczL2RtZXNnLWt2bS14Ym0tMTQyMzktMjAxMzA3MDMxNTAw
MDctMy4xMC4wLTAwMzQ5LWc3ZTZjODRjLTgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1j
MjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgwNTczL2RtZXNn
LWt2bS12cC05MDEyLTIwMTMwNzAzMTQ1OTM5LTMuMTAuMC0wMDI4OS1nYjE5MGM1ZC0xNAov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5
ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXZwLTkyMDMtMjAxMzA3MDMxNDU4MjYt
My4xMC4wLXJjNy0wMDE5NC1nNWIwZTJlNS03Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
YzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVz
Zy1rdm0tYmVucy0zMjI4LTIwMTMwNzAzMTQ1NjU3LTMuMTAuMC0wMDI4OS1nYjE5MGM1ZC0x
NAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFh
ZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXZwLTkyMDMtMjAxMzA3MDMxNDU4
NDctMy4xMC4wLXJjNy0wMDE5NC1nNWIwZTJlNS03Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctYzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9k
bWVzZy1rdm0tYmVucy0zMzM4LTIwMTMwNzAzMTQ1NzA4LTMuMTAuMC0wMDI4OS1nMWMyNGUx
OS0zMAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5
OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLWJlbnMtMzU2MS0yMDEzMDcw
MzE0NTYxNi0zLjEwLjAtMDAzNDktZzhmNTc1M2QtMjcKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgwNTcz
L2RtZXNnLWt2bS1iZW5zLTM1NjEtMjAxMzA3MDMxNDU2NDgtMy4xMC4wLTAwMzQ5LWc4ZjU3
NTNkLTI3Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0YzhhNzk4
OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0tdnAtOTIwMy0yMDEzMDcw
MzE0NTkyOC0zLjEwLjAtcmM3LTAwMTk0LWc1YjBlMmU1LTcKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgw
NTczL2RtZXNnLWt2bS1iZW5zLTM3NjAtMjAxMzA3MDMxNDU2MTgtMy4xMC4wLXJjNy0wMDEy
MC1nZWNhYWRlMy0xNQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFm
NGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXZwLTk0NDct
MjAxMzA3MDMxNDU4NDAtMy4xMC4wLTAwMjg5LWdiYWRjODE4LTI3Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1
YWI4MDU3My9kbWVzZy1rdm0tYmVucy0zNzYwLTIwMTMwNzAzMTQ1NjQ1LTMuMTAuMC1yYzct
MDAxMjAtZ2VjYWFkZTMtMTUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9l
OGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgwNTczL2RtZXNnLWt2bS12cC05
NDQ3LTIwMTMwNzAzMTQ1OTA2LTMuMTAuMC0wMDI4OS1nYmFkYzgxOC0yNwova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0
NGE5NWFiODA1NzMvZG1lc2cta3ZtLWJlbnMtMzg4Ni0yMDEzMDcwMzE0NTYxNi0zLjEwLjAt
cmMxLTAwNTI1LWdhNTFkODFjLTYxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3
MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0t
dnAtOTYxNC0yMDEzMDcwMzE0NTgyNy0zLjEwLjAtcmM3LTAwMTk0LWc1YjBlMmU1LTcKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2
OThiM2RkNDRhOTVhYjgwNTczL2RtZXNnLWt2bS12cC05NjE0LTIwMTMwNzAzMTQ1ODQ3LTMu
MTAuMC1yYzctMDAxOTQtZzViMGUyZTUtNwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMy
NS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2ct
a3ZtLWJlbnMtMzg4Ni0yMDEzMDcwMzE0NTY0Ny0zLjEwLjAtcmMxLTAwNTI1LWdhNTFkODFj
LTYxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4
YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0tdnAtOTYxNC0yMDEzMDcwMzE0
NTkyMy0zLjEwLjAtcmM3LTAwMTk0LWc1YjBlMmU1LTcKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgwNTcz
L2RtZXNnLWt2bS1iZW5zLTQwOTAtMjAxMzA3MDMxNDU2MTgtMy4xMC4wLW5leHQtMjAxMzA3
MDItMTA1OTQtZ2U4ZTFmNGMtMTM0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3
MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0t
dnAtOTgwNy0yMDEzMDcwMzE0NTkzMy0zLjEwLjAtcmM3LTAwMTk0LWc1YjBlMmU1LTcKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2
OThiM2RkNDRhOTVhYjgwNTczL2RtZXNnLWt2bS13YWltZWEtMTQ4MzAtMjAxMzA3MDMxNTAw
MjUtMy4xMC4wLXJjNS0wMDA5NC1nOWZmOWY2ZC04Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctYzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9k
bWVzZy1rdm0tYmVucy00MDkwLTIwMTMwNzAzMTQ1NjQ4LTMuMTAuMC1uZXh0LTIwMTMwNzAy
LTEwNTk0LWdlOGUxZjRjLTEzNAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAx
L2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLWJl
bnMtNDIwNy0yMDEzMDcwMzE0NTcwNi0zLjEwLjAtMDAzNDktZzM1YjIzYzItMzgKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThi
M2RkNDRhOTVhYjgwNTczL2RtZXNnLWt2bS13YWltZWEtMTQ4MzAtMjAxMzA3MDMxNTAwNDUt
My4xMC4wLXJjNS0wMDA5NC1nOWZmOWY2ZC04Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
YzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVz
Zy1rdm0td2FpbWVhLTE0ODMwLTIwMTMwNzAzMTUwMTA0LTMuMTAuMC1yYzUtMDAwOTQtZzlm
ZjlmNmQtOAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5
ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXdhaW1lYS0yMTM3Ny0y
MDEzMDcwMzE1MDAxNS0zLjEwLjAtMDAzNDktZ2I5ZjgyN2YtMzEKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVh
YjgwNTczL2RtZXNnLWt2bS13YWltZWEtMjEzNzgtMjAxMzA3MDMxNTAwMTEtMy4xMC4wLTAw
MzQ5LWc4ZjU3NTNkLTI3Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThl
MWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0td2FpbWVh
LTIxNDE0LTIwMTMwNzAzMTUwMDUwLTMuMTAuMC0wMDI4OS1nYjE5MGM1ZC0xNAova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIz
ZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXdhaW1lYS0yMTQxNi0yMDEzMDcwMzE1MDEwNC0z
LjEwLjAtMDAyODktZ2JhZGM4MTgtMjgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUt
MDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgwNTczL2RtZXNnLWt2
bS13YWltZWEtMjE0MTgtMjAxMzA3MDMxNTAwMjItMy4xMC4wLTAwMzQ5LWc4ZjU3NTNkLTI2
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4YWFk
NTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0tdnAtMjg4ODMtMjAxMzA3MDMxNDU4
MjYtMy4xMC4wLTAwMzQ5LWdiOWY4MjdmLTMxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
YzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVz
Zy1rdm0tdnAtNDY2NS0yMDEzMDcwMzE0NTkxNS0zLjEwLjAtcmM3LTAwMTk0LWc1YjBlMmU1
LTcKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThh
YWQ1OTg2OThiM2RkNDRhOTVhYjgwNTczL2RtZXNnLWt2bS13YWltZWEtMjE0MTgtMjAxMzA3
MDMxNTAwMzQtMy4xMC4wLTAwMzQ5LWc4ZjU3NTNkLTI2Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctYzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3
My9kbWVzZy1rdm0td2FpbWVhLTIxNDE4LTIwMTMwNzAzMTUwMDU0LTMuMTAuMC0wMDM0OS1n
OGY1NzUzZC0yNgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4
YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXZwLTQ3NzItMjAx
MzA3MDMxNDU5MzItMy4xMC4wLTAwMzQ5LWczNWIyM2MyLTM3Ci9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctYzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4
MDU3My9kbWVzZy1rdm0tdnAtNDg4Ni0yMDEzMDcwMzE0NTk0MC0zLjEwLjAtcmM3LTAwMTk0
LWc1YjBlMmU1LTcKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRj
OGE3OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgwNTczL2RtZXNnLWt2bS12cC00OTk2LTIw
MTMwNzAzMTQ1OTQyLTMuNy4wLXJjNC0wMDE1MC1nZTU1YjZhOC01Nwova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5
NWFiODA1NzMvZG1lc2cta3ZtLXZwLTUxMTItMjAxMzA3MDMxNDU5NDItMy4xMC4wLTAzMjk2
LWcwYjA1ODVjLTI4Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0
YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0tdnAtNTIyNi0y
MDEzMDcwMzE0NTk0My0zLjEwLjAtcmM1LTAwMDk0LWc5ZmY5ZjZkLTkKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRh
OTVhYjgwNTczL2RtZXNnLWt2bS12cC01NTQ3LTIwMTMwNzAzMTQ1ODM5LTMuMTAuMC0wNDcx
NS1nODBkMTYyYy0xMjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUx
ZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgwNTczL2RtZXNnLWt2bS12cC01NjU5
LTIwMTMwNzAzMTQ1ODI1LTMuMTAuMC0wMDM0OS1nZGMyMGI0NC0zNwova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5
NWFiODA1NzMvZG1lc2cta3ZtLXZwLTU2NTktMjAxMzA3MDMxNDU4NDYtMy4xMC4wLTAwMzQ5
LWdkYzIwYjQ0LTM3Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0
YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0tdnAtMjAxNzUt
MjAxMzA3MDMxNDU4MzYtMy42LjAtMDU0ODItZzE2NjQyYTItODEKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVh
YjgwNTczL2RtZXNnLWt2bS12cC0yMDE3NS0yMDEzMDcwMzE0NTkwMS0zLjYuMC0wNTQ4Mi1n
MTY2NDJhMi04MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4
YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXZwLTU2NTktMjAx
MzA3MDMxNDU5MjQtMy4xMC4wLTAwMzQ5LWdkYzIwYjQ0LTM3Ci9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctYzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4
MDU3My9kbWVzZy1rdm0tYmVucy00MzI5LTIwMTMwNzAzMTQ1NjI2LTMuMTAuMC0wMDI4OS1n
MDIyNmIxMy0yMAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4
YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXZwLTU3ODUtMjAx
MzA3MDMxNDU5MjktMy4xMC4wLTAwMjg5LWdiMTkwYzVkLTE0Ci9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctYzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4
MDU3My9kbWVzZy1rdm0tdnAtMjA0OTQtMjAxMzA3MDMxNDU5NDAtMy4xMC4wLTAwMjg5LWdi
YWRjODE4LTI4Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0Yzhh
Nzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0tYmVucy00MzI5LTIw
MTMwNzAzMTQ1NjU4LTMuMTAuMC0wMDI4OS1nMDIyNmIxMy0yMAova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFi
ODA1NzMvZG1lc2cta3ZtLXZwLTU5MTAtMjAxMzA3MDMxNDU5NDEtMy4xMC4wLTAwMzQ5LWc4
ZjU3NTNkLTI3Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0Yzhh
Nzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0tdnAtMjA4ODQtMjAx
MzA3MDMxNDU4MjYtMy4xMC4wLTAwMjg5LWcwMjI2YjEzLTIxCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctYzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4
MDU3My9kbWVzZy1rdm0tdnAtMjA4ODQtMjAxMzA3MDMxNDU4NDYtMy4xMC4wLTAwMjg5LWcw
MjI2YjEzLTIxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0Yzhh
Nzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0tYmVucy00NDUyLTIw
MTMwNzAzMTQ1NjMwLTMuMTAuMC0wMDM0OS1nOGY1NzUzZC0yNwova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFi
ODA1NzMvZG1lc2cta3ZtLXZwLTYwMzItMjAxMzA3MDMxNDU4MjUtMy4xMC4wLW5leHQtMjAx
MzA3MDItMTA1OTQtZ2U4ZTFmNGMtMTM0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1
LTA3MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1r
dm0teGJtLTE0MzQyLTIwMTMwNzAzMTUwMDEwLTMuMTAuMC0wMDM0OS1nYjlmODI3Zi0zMQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5
ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXZwLTIwODg0LTIwMTMwNzAzMTQ1OTI3
LTMuMTAuMC0wMDI4OS1nMDIyNmIxMy0yMQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMy
NS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2ct
a3ZtLWJlbnMtNDQ1Mi0yMDEzMDcwMzE0NTcwMi0zLjEwLjAtMDAzNDktZzhmNTc1M2QtMjcK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1
OTg2OThiM2RkNDRhOTVhYjgwNTczL2RtZXNnLWt2bS12cC02MDMyLTIwMTMwNzAzMTQ1ODQ0
LTMuMTAuMC1uZXh0LTIwMTMwNzAyLTEwNTk0LWdlOGUxZjRjLTEzNAova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5
NWFiODA1NzMvZG1lc2cta3ZtLXhibS0xNjk4MC0yMDEzMDcwMzE1MDAxNS0zLjEwLjAtMDAy
ODktZzAyMjZiMTMtMjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUx
ZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgwNTczL2RtZXNnLWt2bS14Ym0tMTc0
NDgtMjAxMzA3MDMxNTAwMDYtMy4xMC4wLW5leHQtMjAxMzA3MDItMTA1OTQtZ2U4ZTFmNGMt
MTM0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4
YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0tdnAtMjExOTAtMjAxMzA3MDMx
NDU4NDEtMy42LjAtMDUzNzQtZzdmZTBiMTQtODMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgwNTczL2Rt
ZXNnLWt2bS12cC02MDMyLTIwMTMwNzAzMTQ1OTIwLTMuMTAuMC1uZXh0LTIwMTMwNzAyLTEw
NTk0LWdlOGUxZjRjLTEzNAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4
ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXZwLTEx
NDY4LTIwMTMwNzAzMTQ1OTM0LTMuMTAuMC0wMzI5Ni1nMGIwNTg1Yy0yNwova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0
NGE5NWFiODA1NzMvZG1lc2cta3ZtLXZwLTYxNzQtMjAxMzA3MDMxNDU4MjYtMy4xMC4wLTAw
MzQ5LWczNWIyM2MyLTM4Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThl
MWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0tdnAtMjE0
NzItMjAxMzA3MDMxNDU5MzEtMy4xMC4wLTAwMjg5LWcxYzI0ZTE5LTMwCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0
YTk1YWI4MDU3My9kbWVzZy1rdm0tdnAtMTE2OTEtMjAxMzA3MDMxNDU5MjktMy4xMC4wLTAw
MzQ5LWc4ZjU3NTNkLTI3Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThl
MWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0tdnAtMjE3
MTctMjAxMzA3MDMxNDU4MzctMy4xMC4wLTAwMzQ5LWczNWIyM2MyLTM3Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0
YTk1YWI4MDU3My9kbWVzZy1rdm0tdnAtNjQzNi0yMDEzMDcwMzE0NTkyNi0zLjEwLjAtMDAz
NDktZzM1YjIzYzItMzgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUx
ZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgwNTczL2RtZXNnLWt2bS12cC0xMjA5
Ny0yMDEzMDcwMzE0NTkzNi0zLjEwLjAtcmM3LTAwMTk0LWc1YjBlMmU1LTcKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2Rk
NDRhOTVhYjgwNTczL2RtZXNnLWt2bS12cC0yMjA3Mi0yMDEzMDcwMzE0NTkzMC0zLjEwLjAt
cmMzLTAwMDQ5LWc0Y2Q1NzczLTEyNgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0w
NzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3Zt
LXZwLTY1NzYtMjAxMzA3MDMxNDU4MjYtMy4xMC4wLTAwMzQ5LWc4ZjU3NTNkLTI3Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4
YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0tdnAtMTI3NDYtMjAxMzA3MDMxNDU5NDMtMy4x
MC4wLTAwMzQ5LWc4ZjU3NTNkLTI2Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3
MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0t
dnAtNjU3Ni0yMDEzMDcwMzE0NTg0OC0zLjEwLjAtMDAzNDktZzhmNTc1M2QtMjcKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThi
M2RkNDRhOTVhYjgwNTczL2RtZXNnLWt2bS12cC0yMjQyMS0yMDEzMDcwMzE0NTkyMS0zLjEw
LjAtMDAyODktZ2IxOTBjNWQtMTQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcw
MS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgwNTczL2RtZXNnLWt2bS12
cC0xMzAzNi0yMDEzMDcwMzE0NTkzMS0zLjQuMC1yYzUtMDAzNTYtZzE1MzYyYzUtNjkKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2
OThiM2RkNDRhOTVhYjgwNTczL2RtZXNnLWt2bS12cC02NTc2LTIwMTMwNzAzMTQ1OTMwLTMu
MTAuMC0wMDM0OS1nOGY1NzUzZC0yNwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0w
NzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3Zt
LXZwLTIyNjMzLTIwMTMwNzAzMTQ1OTM5LTMuMTAuMC0wMDM0OS1nZGMyMGI0NC0zNgova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5
OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXZwLTEzMjg5LTIwMTMwNzAzMTQ1ODI3LTMu
MTAuMC1yYzctMDAxOTQtZzViMGUyZTUtMTMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1j
MjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgwNTczL2RtZXNn
LWt2bS12cC0yMzU2MS0yMDEzMDcwMzE0NTgzOS0zLjEwLjAtcmMxLTAwMjc0LWc3ZDIwNGI2
LTI2Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4
YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0tdnAtNjcxMC0yMDEzMDcwMzE0
NTkyNi0zLjEwLjAtMDAzNDktZzM1YjIzYzItMzgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgwNTczL2Rt
ZXNnLWt2bS12cC02ODY0LTIwMTMwNzAzMTQ1OTQwLTMuMTAuMC0wMDI4OS1nMDIyNmIxMy0y
MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFh
ZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXZwLTEzMjg5LTIwMTMwNzAzMTQ1
ODQ4LTMuMTAuMC1yYzctMDAxOTQtZzViMGUyZTUtMTMKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgwNTcz
L2RtZXNnLWt2bS12cC0yMzgxMS0yMDEzMDcwMzE0NTk0MC0zLjEwLjAtMDAwOTEtZ2ZjN2Vk
ODgtMTEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5
OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgwNTczL2RtZXNnLWt2bS12cC02OTk2LTIwMTMwNzAz
MTQ1ODU2LTMuMTAuMC0wMDI4OS1nYmFkYzgxOC0yOAova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMv
ZG1lc2cta3ZtLXZwLTEzMjg5LTIwMTMwNzAzMTQ1OTM2LTMuMTAuMC1yYzctMDAxOTQtZzVi
MGUyZTUtMTMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3
OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgwNTczL2RtZXNnLWt2bS12cC0yNDE4MC0yMDEz
MDcwMzE0NTk0MC0zLjEwLjAtMDAyODktZzAyMjZiMTMtMjEKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgw
NTczL2RtZXNnLWt2bS12cC0xMzUzNy0yMDEzMDcwMzE0NTg0MS0zLjEwLjAtMDAzNDktZzdl
NmM4NGMtOAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5
ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXZwLTcxODQtMjAxMzA3
MDMxNDU4MjUtMy4xMC4wLTAwMjg5LWcwMjI2YjEzLTIxCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctYzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3
My9kbWVzZy1rdm0tdnAtMjQ1MjEtMjAxMzA3MDMxNDU5MzktMy4xMC4wLTAwMDkxLWc2M2M3
YjFjLTEzCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0YzhhNzk4
OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0tdnAtMjQ5NzktMjAxMzA3
MDMxNDU5MzctMy4xMC4wLXJjMi0wMDIwMi1nOTU5MjkxNi0zNgova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFi
ODA1NzMvZG1lc2cta3ZtLXZwLTI1NDgwLTIwMTMwNzAzMTQ1OTM3LTMuMTAuMC0wMDM0OS1n
ZGMyMGI0NC0zNwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4
YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXZwLTI1NzI1LTIw
MTMwNzAzMTQ1ODI4LTMuMTAuMC1yYzYtMDEwNTItZzM4YWU5MmQtMjAKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRh
OTVhYjgwNTczL2RtZXNnLWt2bS12cC0yNjE0MC0yMDEzMDcwMzE0NTkyMS0zLjEwLjAtcmM3
LTAwMTk0LWc1YjBlMmU1LTEzCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEv
ZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0tdnAt
MTA2NjAtMjAxMzA3MDMxNDU5MjktMy42LjAtMDUyNzAtZ2ZjNDc5MTItODIKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2Rk
NDRhOTVhYjgwNTczL2RtZXNnLWt2bS12cC0xMTA1OS0yMDEzMDcwMzE0NTg0Mi0zLjEwLjAt
cmM2LTAwMzcxLWc0ZGViZmU0LTEzMQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0w
NzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3Zt
LXZwLTExMDU5LTIwMTMwNzAzMTQ1OTE0LTMuMTAuMC1yYzYtMDAzNzEtZzRkZWJmZTQtMTMx
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4YWFk
NTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0tdnAtMjY3NDQtMjAxMzA3MDMxNDU4
MjgtMy4xMC4wLXJjNy0wMDEyMC1nZWNhYWRlMy0xNQova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMv
ZG1lc2cta3ZtLXZwLTI2NzQ0LTIwMTMwNzAzMTQ1ODUxLTMuMTAuMC1yYzctMDAxMjAtZ2Vj
YWFkZTMtMTUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3
OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgwNTczL2RtZXNnLWt2bS12cC0yNjc0NC0yMDEz
MDcwMzE0NTkzOS0zLjEwLjAtcmM3LTAwMTIwLWdlY2FhZGUzLTE1Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1
YWI4MDU3My9kbWVzZy1rdm0tdnAtMjc1NDktMjAxMzA3MDMxNDU4MzktMy4xMC4wLTAwMjg5
LWcxYzI0ZTE5LTMwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0
YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0tdnAtMjc1NDkt
MjAxMzA3MDMxNDU5MDUtMy4xMC4wLTAwMjg5LWcxYzI0ZTE5LTMwCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1
YWI4MDU3My9kbWVzZy1rdm0tdnAtMjc4ODgtMjAxMzA3MDMxNDU4MjgtMy4xMC4wLTAwMjg5
LWcwMjI2YjEzLTIwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0
YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0teGJtLTI0MTg2
LTIwMTMwNzAzMTUwMDE1LTMuMTAuMC0wMzkxMC1nMGIwNTg1Yy0xMzMKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRh
OTVhYjgwNTczL2RtZXNnLWt2bS14Ym0tMjQ4MDUtMjAxMzA3MDMxNTAwMDktMy4xMC4wLTAw
MzQ5LWc4ZjU3NTNkLTI2Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThl
MWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0teGJtLTI0
ODA1LTIwMTMwNzAzMTUwMDI5LTMuMTAuMC0wMDM0OS1nOGY1NzUzZC0yNgova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0
NGE5NWFiODA1NzMvZG1lc2cta3ZtLXZwLTEzNjY5LTIwMTMwNzAzMTQ1ODMwLTMuMTAuMC0w
MDM0OS1nZGMyMGI0NC0zNwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4
ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXZwLTc1
MTQtMjAxMzA3MDMxNDU4MzAtMy40LjAtNjAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1j
MjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgwNTczL2RtZXNn
LWt2bS12cC0xMzY2OS0yMDEzMDcwMzE0NTg1MS0zLjEwLjAtMDAzNDktZ2RjMjBiNDQtMzcK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1
OTg2OThiM2RkNDRhOTVhYjgwNTczL2RtZXNnLWt2bS12cC0xMzY2OS0yMDEzMDcwMzE0NTkz
Ni0zLjEwLjAtMDAzNDktZ2RjMjBiNDQtMzcKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1j
MjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgwNTczL2RtZXNn
LWt2bS14Z3dvLTExODY3LTIwMTMwNzAzMTQ1NjUxLTMuMTAuMC1uZXh0LTIwMTMwNzAyLTEw
NTk0LWdlOGUxZjRjLTEzNAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4
ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXhnd28t
MTE4NjctMjAxMzA3MDMxNDU3MTctMy4xMC4wLW5leHQtMjAxMzA3MDItMTA1OTQtZ2U4ZTFm
NGMtMTM0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0YzhhNzk4
OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0tdnAtMTQyMDktMjAxMzA3
MDMxNDU5MzYtMy4xMC4wLTAwMzQ5LWc3ZTZjODRjLTgKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgwNTcz
L2RtZXNnLWt2bS12cC0xNDUzOC0yMDEzMDcwMzE0NTgzOC0zLjEwLjAtcmMxLTAwMjc0LWc3
ZDIwNGI2LTI1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0Yzhh
Nzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1YWI4MDU3My9kbWVzZy1rdm0tdnAtMTQ1MzgtMjAx
MzA3MDMxNDU5MDQtMy4xMC4wLXJjMS0wMDI3NC1nN2QyMDRiNi0yNQova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5
NWFiODA1NzMvZG1lc2cta3ZtLXZwLTE0ODA1LTIwMTMwNzAzMTQ1ODI4LTMuNy4wLXJjNC0w
MDE1Mi1nMTU4MmVlYS00NQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4
ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXZwLTE0
ODA1LTIwMTMwNzAzMTQ1ODQ3LTMuNy4wLXJjNC0wMDE1Mi1nMTU4MmVlYS00NQova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIz
ZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXZwLTE0ODA1LTIwMTMwNzAzMTQ1OTI4LTMuNy4w
LXJjNC0wMDE1Mi1nMTU4MmVlYS00NQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0w
NzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3Zt
LXZwLTE1MDA4LTIwMTMwNzAzMTQ1OTM1LTMuMTAuMC1yYzEtMDA1MjUtZ2E1MWQ4MWMtMzUK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1
OTg2OThiM2RkNDRhOTVhYjgwNTczL2RtZXNnLWt2bS12cC0xNTM0NS0yMDEzMDcwMzE0NTg0
MC0zLjEwLjAtcmM3LTAwMTk0LWc1YjBlMmU1LTcKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgwNTczL2Rt
ZXNnLWt2bS12cC0xNTM0NS0yMDEzMDcwMzE0NTkxMS0zLjEwLjAtcmM3LTAwMTk0LWc1YjBl
MmU1LTcKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5
OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgwNTczL2RtZXNnLWt2bS12cC0xNTYyMi0yMDEzMDcw
MzE0NTk0NC0zLjEwLjAtMDAzNDktZzdlNmM4NGMtOAova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMv
ZG1lc2cta3ZtLXZwLTE2MjE3LTIwMTMwNzAzMTQ1OTQzLTMuMTAuMC0wMDM0OS1nZGMyMGI0
NC0zMQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5
OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXZwLTE2OTA5LTIwMTMwNzAz
MTQ1OTI5LTMuMTAuMC0wMDM0OS1nMzViMjNjMi0zNwova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMv
ZG1lc2cta3ZtLXZwLTE3MTcyLTIwMTMwNzAzMTQ1OTM4LTMuMTAuMC0wMDI4OS1nMDIyNmIx
My0yMQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyNS0wNzAxL2U4ZTFmNGM4YTc5ODk5
OGFhZDU5ODY5OGIzZGQ0NGE5NWFiODA1NzMvZG1lc2cta3ZtLXZwLTE3NTA5LTIwMTMwNzAz
MTQ1ODQwLTMuMTAuMC1yYzctMDAxMjAtZ2VjYWFkZTMtMTUKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgw
NTczL2RtZXNnLWt2bS12cC0xNzg4MS0yMDEzMDcwMzE0NTkzOS0zLjEwLjAtMDAyODktZzFj
MjRlMTktMzAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjUtMDcwMS9lOGUxZjRjOGE3
OTg5OThhYWQ1OTg2OThiM2RkNDRhOTVhYjgwNTczL2RtZXNnLWt2bS12cC0xODQxMy0yMDEz
MDcwMzE0NTk0MC0zLjEwLjAtcmMyLTAwMjAyLWc5NTkyOTE2LTM1Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctYzI1LTA3MDEvZThlMWY0YzhhNzk4OTk4YWFkNTk4Njk4YjNkZDQ0YTk1
YWI4MDU3My9kbWVzZy1rdm0tdnAtMTg5NTAtMjAxMzA3MDMxNDU5MzktMy4xMC4wLTAwMjg5
LWcwMjI2YjEzLTIxCgo=

--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.10.0-wl-06036-gaf15f8d"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.10.0 Kernel Configuration
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
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
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
# CONFIG_TICK_CPU_ACCOUNTING is not set
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_STALL_COMMON is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
CONFIG_CGROUP_HUGETLB=y
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_IPC_NS=y
# CONFIG_PID_NS is not set
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
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HOTPLUG=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
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
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
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
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_RELA=y

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

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
CONFIG_ATARI_PARTITION=y
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
# CONFIG_EFI_PARTITION is not set
CONFIG_SYSV68_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_FREEZER=y

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
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PRIVILEGED_GUEST=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=500
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
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
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
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
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_I8K=y
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
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
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
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
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
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_PM_SLEEP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
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
# CONFIG_ACPI_IPMI_TEST is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
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
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_XEN_PCIDEV_FRONTEND=y
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_BINFMT_SCRIPT is not set
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
# CONFIG_IA32_EMULATION is not set
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
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
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
# CONFIG_IP_MULTIPLE_TABLES is not set
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
CONFIG_NET_IPGRE=y
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_INET_UDP_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_MSG=y
CONFIG_SCTP_DBG_OBJCNT=y
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_RDS=y
CONFIG_RDS_TCP=y
CONFIG_RDS_DEBUG=y
CONFIG_TIPC=y
CONFIG_TIPC_PORTS=8191
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
CONFIG_ATALK=y
# CONFIG_DEV_APPLETALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
# CONFIG_PHONET is not set
CONFIG_IEEE802154=y
CONFIG_MAC802154=y
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
# CONFIG_DNS_RESOLVER is not set
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_BLA=y
CONFIG_BATMAN_ADV_DAT=y
CONFIG_BATMAN_ADV_NC=y
CONFIG_BATMAN_ADV_DEBUG=y
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=y
CONFIG_NETPRIO_CGROUP=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
# CONFIG_CAN_BCM is not set
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
CONFIG_CAN_SLCAN=y
CONFIG_CAN_DEV=y
# CONFIG_CAN_CALC_BITTIMING is not set
CONFIG_CAN_LEDS=y
# CONFIG_PCH_CAN is not set
CONFIG_CAN_SJA1000=y
CONFIG_CAN_SJA1000_ISA=y
CONFIG_CAN_SJA1000_PLATFORM=y
# CONFIG_CAN_EMS_PCI is not set
# CONFIG_CAN_PEAK_PCI is not set
# CONFIG_CAN_KVASER_PCI is not set
# CONFIG_CAN_PLX_PCI is not set
CONFIG_CAN_C_CAN=y
CONFIG_CAN_C_CAN_PLATFORM=y
# CONFIG_CAN_C_CAN_PCI is not set
# CONFIG_CAN_CC770 is not set
CONFIG_CAN_SOFTING=y
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
CONFIG_IRCOMM=y
CONFIG_IRDA_ULTRA=y

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
CONFIG_IRTTY_SIR=y

#
# Dongle support
#
# CONFIG_DONGLE is not set

#
# FIR device drivers
#
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
# CONFIG_SMC_IRCC_FIR is not set
# CONFIG_ALI_FIR is not set
# CONFIG_VLSI_FIR is not set
CONFIG_VIA_FIR=y
CONFIG_BT=y
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=y
# CONFIG_BT_BNEP_MC_FILTER is not set
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUART=y
CONFIG_BT_HCIUART_H4=y
# CONFIG_BT_HCIUART_BCSP is not set
CONFIG_BT_HCIUART_ATH3K=y
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIUART_3WIRE=y
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=y
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
CONFIG_RFKILL_REGULATOR=y
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
CONFIG_NFC=y
CONFIG_NFC_NCI=y
# CONFIG_NFC_HCI is not set

#
# Near Field Communication (NFC) devices
#
# CONFIG_NFC_SIM is not set
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
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
CONFIG_SYS_HYPERVISOR=y
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
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
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
# CONFIG_PARIDE_ATEN is not set
# CONFIG_PARIDE_BPCK is not set
CONFIG_PARIDE_COMM=y
# CONFIG_PARIDE_DSTR is not set
# CONFIG_PARIDE_FIT2 is not set
# CONFIG_PARIDE_FIT3 is not set
CONFIG_PARIDE_EPAT=y
CONFIG_PARIDE_EPATC8=y
# CONFIG_PARIDE_EPIA is not set
# CONFIG_PARIDE_FRIQ is not set
# CONFIG_PARIDE_FRPW is not set
CONFIG_PARIDE_KBIC=y
# CONFIG_PARIDE_KTTI is not set
# CONFIG_PARIDE_ON20 is not set
# CONFIG_PARIDE_ON26 is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=y
CONFIG_BLK_DEV_DRBD=y
# CONFIG_DRBD_FAULT_INJECTION is not set
CONFIG_BLK_DEV_NBD=y
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_OSD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=y
# CONFIG_XEN_BLKDEV_BACKEND is not set
# CONFIG_VIRTIO_BLK is not set
CONFIG_BLK_DEV_HD=y
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=y
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_SRAM=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_IDE_GD is not set
# CONFIG_BLK_DEV_IDECD is not set
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_PLATFORM=y
CONFIG_BLK_DEV_CMD640=y
# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
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
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_ENCLOSURE=y
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_FC_TGT_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
# CONFIG_SCSI_DH_HP_SW is not set
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=y
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
CONFIG_SATA_HIGHBANK=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
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
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_AUTODETECT is not set
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MD_MULTIPATH=y
CONFIG_MD_FAULTY=y
# CONFIG_BCACHE is not set
# CONFIG_BLK_DEV_DM is not set
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=y
CONFIG_TCM_FILEIO=y
CONFIG_TCM_PSCSI=y
CONFIG_LOOPBACK_TARGET=y
CONFIG_ISCSI_TARGET=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
# CONFIG_NETDEVICES is not set
CONFIG_VHOST_NET=y
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
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5520=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ADP5589=y
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
CONFIG_KEYBOARD_MCS=y
CONFIG_KEYBOARD_MPR121=y
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_KEYBOARD_SUNKBD=y
# CONFIG_KEYBOARD_STMPE is not set
CONFIG_KEYBOARD_TC3589X=y
# CONFIG_KEYBOARD_TWL4030 is not set
CONFIG_KEYBOARD_XTKBD=y
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
CONFIG_MOUSE_VSXXXAA=y
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_AD7879=y
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
CONFIG_TOUCHSCREEN_CY8CTMG110=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP_I2C=y
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
CONFIG_TOUCHSCREEN_DA9034=y
CONFIG_TOUCHSCREEN_DA9052=y
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
CONFIG_TOUCHSCREEN_EETI=y
CONFIG_TOUCHSCREEN_FUJITSU=y
# CONFIG_TOUCHSCREEN_ILI210X is not set
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=y
CONFIG_TOUCHSCREEN_MAX11801=y
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
CONFIG_TOUCHSCREEN_MTOUCH=y
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_PENMOUNT=y
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_PIXCIR=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
CONFIG_TOUCHSCREEN_STMPE=y
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM80X_ONKEY=y
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_BMA150=y
# CONFIG_INPUT_PCSPKR is not set
CONFIG_INPUT_MAX8925_ONKEY=y
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=y
CONFIG_INPUT_GPIO_TILT_POLLED=y
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=y
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_RETU_PWRBUTTON is not set
# CONFIG_INPUT_TWL4030_PWRBUTTON is not set
# CONFIG_INPUT_TWL4030_VIBRA is not set
# CONFIG_INPUT_UINPUT is not set
CONFIG_INPUT_PCF50633_PMU=y
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
CONFIG_INPUT_DA9052_ONKEY=y
CONFIG_INPUT_ADXL34X=y
# CONFIG_INPUT_ADXL34X_I2C is not set
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

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
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
# CONFIG_N_HDLC is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y
CONFIG_STALDRV=y

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
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS=y
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
# CONFIG_HVC_XEN is not set
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
# CONFIG_IPMI_POWEROFF is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
CONFIG_MWAVE=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
CONFIG_TELCLOCK=y
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
CONFIG_I2C_ALGOPCF=y
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
# CONFIG_I2C_CBUS_GPIO is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set

#
# Qualcomm MSM SSBI bus support
#
# CONFIG_SSBI is not set
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
CONFIG_PPS_CLIENT_KTIMER=y
CONFIG_PPS_CLIENT_LDISC=y
# CONFIG_PPS_CLIENT_PARPORT is not set
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
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_DA9052=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=y
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_STMPE is not set
CONFIG_GPIO_TC3589X=y
# CONFIG_GPIO_TPS65912 is not set
CONFIG_GPIO_TWL4030=y
CONFIG_GPIO_WM8994=y
# CONFIG_GPIO_ADP5520 is not set
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set

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
CONFIG_GPIO_MCP23S08=y

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_TPS65910=y

#
# USB GPIO expanders:
#
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_MAX8925_POWER=y
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9030=y
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=y
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_PCF50633 is not set
# CONFIG_BATTERY_RX51 is not set
CONFIG_CHARGER_ISP1704=y
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_TWL4030=y
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MANAGER=y
# CONFIG_CHARGER_MAX8998 is not set
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_SMB347=y
CONFIG_BATTERY_GOLDFISH=y
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_GPIO_FAN=y
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IIO_HWMON=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
# CONFIG_SENSORS_MAX8688 is not set
CONFIG_SENSORS_UCD9000=y
# CONFIG_SENSORS_UCD9200 is not set
# CONFIG_SENSORS_ZL6100 is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_TWL4030_MADC=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=y
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_APPLESMC is not set

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
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
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
CONFIG_MFD_AS3711=y
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_CROS_EC is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
CONFIG_TPS65010=y
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
CONFIG_TWL4030_MADC=y
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_GPIO=y
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_AAT2870=y
CONFIG_REGULATOR_DA903X=y
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_ANATOP is not set
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8907=y
# CONFIG_REGULATOR_MAX8925 is not set
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8998=y
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
# CONFIG_REGULATOR_LP8788 is not set
# CONFIG_REGULATOR_PCF50633 is not set
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65217=y
CONFIG_REGULATOR_TPS65910=y
# CONFIG_REGULATOR_TPS65912 is not set
# CONFIG_REGULATOR_TWL4030 is not set
# CONFIG_REGULATOR_WM8994 is not set
CONFIG_REGULATOR_AS3711=y
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
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_V4L2_INT_DEVICE=y
CONFIG_DVB_CORE=y
CONFIG_DVB_NET=y
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y

#
# Media drivers
#
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#

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
CONFIG_VIDEO_TEA6420=y
# CONFIG_VIDEO_MSP3400 is not set
CONFIG_VIDEO_CS5345=y
CONFIG_VIDEO_CS53L32A=y
# CONFIG_VIDEO_TLV320AIC23B is not set
# CONFIG_VIDEO_UDA1342 is not set
# CONFIG_VIDEO_WM8775 is not set
# CONFIG_VIDEO_WM8739 is not set
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
# CONFIG_VIDEO_ADV7183 is not set
CONFIG_VIDEO_BT819=y
# CONFIG_VIDEO_BT856 is not set
CONFIG_VIDEO_BT866=y
CONFIG_VIDEO_KS0127=y
# CONFIG_VIDEO_ML86V7667 is not set
# CONFIG_VIDEO_SAA7110 is not set
CONFIG_VIDEO_SAA711X=y
# CONFIG_VIDEO_SAA7191 is not set
CONFIG_VIDEO_TVP514X=y
CONFIG_VIDEO_TVP5150=y
CONFIG_VIDEO_TVP7002=y
CONFIG_VIDEO_TW2804=y
CONFIG_VIDEO_TW9903=y
# CONFIG_VIDEO_TW9906 is not set
CONFIG_VIDEO_VPX3220=y

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
# CONFIG_VIDEO_ADV7175 is not set
CONFIG_VIDEO_ADV7343=y
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
CONFIG_VIDEO_UPD64031A=y
CONFIG_VIDEO_UPD64083=y

#
# Miscelaneous helper chips
#
CONFIG_VIDEO_THS7303=y
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
# CONFIG_MEDIA_TUNER_TEA5761 is not set
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_MT2060=y
# CONFIG_MEDIA_TUNER_MT2063 is not set
# CONFIG_MEDIA_TUNER_MT2266 is not set
CONFIG_MEDIA_TUNER_MT2131=y
# CONFIG_MEDIA_TUNER_QT1010 is not set
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MXL5005S=y
# CONFIG_MEDIA_TUNER_MXL5007T is not set
# CONFIG_MEDIA_TUNER_MC44S803 is not set
CONFIG_MEDIA_TUNER_MAX2165=y
CONFIG_MEDIA_TUNER_TDA18218=y
CONFIG_MEDIA_TUNER_FC0011=y
# CONFIG_MEDIA_TUNER_FC0012 is not set
CONFIG_MEDIA_TUNER_FC0013=y
CONFIG_MEDIA_TUNER_TDA18212=y
CONFIG_MEDIA_TUNER_E4000=y
CONFIG_MEDIA_TUNER_FC2580=y
CONFIG_MEDIA_TUNER_TUA9001=y
CONFIG_MEDIA_TUNER_IT913X=y
# CONFIG_MEDIA_TUNER_R820T is not set

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
# CONFIG_DVB_STB0899 is not set
CONFIG_DVB_STB6100=y
# CONFIG_DVB_STV090x is not set
# CONFIG_DVB_STV6110x is not set

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=y
CONFIG_DVB_TDA18271C2DD=y

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=y
# CONFIG_DVB_CX24123 is not set
CONFIG_DVB_MT312=y
# CONFIG_DVB_ZL10036 is not set
CONFIG_DVB_ZL10039=y
CONFIG_DVB_S5H1420=y
# CONFIG_DVB_STV0288 is not set
CONFIG_DVB_STB6000=y
CONFIG_DVB_STV0299=y
CONFIG_DVB_STV6110=y
# CONFIG_DVB_STV0900 is not set
CONFIG_DVB_TDA8083=y
CONFIG_DVB_TDA10086=y
# CONFIG_DVB_TDA8261 is not set
CONFIG_DVB_VES1X93=y
CONFIG_DVB_TUNER_ITD1000=y
CONFIG_DVB_TUNER_CX24113=y
CONFIG_DVB_TDA826X=y
# CONFIG_DVB_TUA6100 is not set
CONFIG_DVB_CX24116=y
CONFIG_DVB_SI21XX=y
# CONFIG_DVB_TS2020 is not set
# CONFIG_DVB_DS3000 is not set
CONFIG_DVB_MB86A16=y
CONFIG_DVB_TDA10071=y

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=y
# CONFIG_DVB_SP887X is not set
CONFIG_DVB_CX22700=y
CONFIG_DVB_CX22702=y
CONFIG_DVB_S5H1432=y
CONFIG_DVB_DRXD=y
CONFIG_DVB_L64781=y
CONFIG_DVB_TDA1004X=y
# CONFIG_DVB_NXT6000 is not set
CONFIG_DVB_MT352=y
CONFIG_DVB_ZL10353=y
CONFIG_DVB_DIB3000MB=y
# CONFIG_DVB_DIB3000MC is not set
CONFIG_DVB_DIB7000M=y
CONFIG_DVB_DIB7000P=y
# CONFIG_DVB_DIB9000 is not set
CONFIG_DVB_TDA10048=y
# CONFIG_DVB_AF9013 is not set
# CONFIG_DVB_EC100 is not set
CONFIG_DVB_HD29L2=y
CONFIG_DVB_STV0367=y
CONFIG_DVB_CXD2820R=y
CONFIG_DVB_RTL2830=y
CONFIG_DVB_RTL2832=y

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
CONFIG_DVB_BCM3510=y
# CONFIG_DVB_LGDT330X is not set
CONFIG_DVB_LGDT3305=y
CONFIG_DVB_LG2160=y
# CONFIG_DVB_S5H1409 is not set
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
# CONFIG_DVB_TUNER_DIB0070 is not set
# CONFIG_DVB_TUNER_DIB0090 is not set

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=y
# CONFIG_DVB_LNBP22 is not set
CONFIG_DVB_ISL6405=y
# CONFIG_DVB_ISL6421 is not set
# CONFIG_DVB_ISL6423 is not set
CONFIG_DVB_A8293=y
# CONFIG_DVB_LGS8GL5 is not set
CONFIG_DVB_LGS8GXX=y
CONFIG_DVB_ATBM8830=y
# CONFIG_DVB_TDA665x is not set
CONFIG_DVB_IX2505V=y
CONFIG_DVB_IT913X_FE=y
CONFIG_DVB_M88RS2000=y
CONFIG_DVB_AF9033=y

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
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
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
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
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
CONFIG_FB_HECUBA=y
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
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
CONFIG_FB_VESA=y
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_S1D13XXX=y
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
CONFIG_FB_TMIO=y
CONFIG_FB_TMIO_ACCELL=y
CONFIG_FB_SM501=y
# CONFIG_FB_GOLDFISH is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_XEN_FBDEV_FRONTEND is not set
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_LM3533 is not set
# CONFIG_BACKLIGHT_DA903X is not set
CONFIG_BACKLIGHT_DA9052=y
CONFIG_BACKLIGHT_MAX8925=y
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_AAT2870=y
CONFIG_BACKLIGHT_LM3630=y
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_LP855X is not set
CONFIG_BACKLIGHT_LP8788=y
CONFIG_BACKLIGHT_PANDORA=y
CONFIG_BACKLIGHT_TPS65217=y
CONFIG_BACKLIGHT_AS3711=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=y
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
# CONFIG_SND_PCM_OSS_PLUGINS is not set
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=y
# CONFIG_SND_SEQ_HRTIMER_DEFAULT is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PROCFS is not set
CONFIG_SND_VERBOSE_PRINTK=y
# CONFIG_SND_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=y
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_ALOOP is not set
# CONFIG_SND_VIRMIDI is not set
CONFIG_SND_MTPAV=y
CONFIG_SND_MTS64=y
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
CONFIG_SND_PORTMAN2X4=y
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
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_SOC=y
CONFIG_SND_ATMEL_SOC=y
CONFIG_SND_SOC_I2C_AND_SPI=y
CONFIG_SND_SOC_ALL_CODECS=y
CONFIG_SND_SOC_WM_HUBS=y
CONFIG_SND_SOC_WM_ADSP=y
CONFIG_SND_SOC_AD193X=y
CONFIG_SND_SOC_AD73311=y
CONFIG_SND_SOC_ADAU1373=y
CONFIG_SND_SOC_ADAV80X=y
CONFIG_SND_SOC_ADS117X=y
CONFIG_SND_SOC_AK4535=y
CONFIG_SND_SOC_AK4641=y
CONFIG_SND_SOC_AK4642=y
CONFIG_SND_SOC_AK4671=y
CONFIG_SND_SOC_AK5386=y
CONFIG_SND_SOC_ALC5623=y
CONFIG_SND_SOC_ALC5632=y
CONFIG_SND_SOC_CS42L51=y
CONFIG_SND_SOC_CS42L52=y
CONFIG_SND_SOC_CS42L73=y
CONFIG_SND_SOC_CS4270=y
CONFIG_SND_SOC_CS4271=y
CONFIG_SND_SOC_CX20442=y
CONFIG_SND_SOC_JZ4740_CODEC=y
CONFIG_SND_SOC_L3=y
CONFIG_SND_SOC_DA7210=y
CONFIG_SND_SOC_DA7213=y
CONFIG_SND_SOC_DA732X=y
CONFIG_SND_SOC_DA9055=y
CONFIG_SND_SOC_BT_SCO=y
CONFIG_SND_SOC_ISABELLE=y
CONFIG_SND_SOC_LM49453=y
CONFIG_SND_SOC_MAX98088=y
CONFIG_SND_SOC_MAX98090=y
CONFIG_SND_SOC_MAX98095=y
CONFIG_SND_SOC_MAX9850=y
CONFIG_SND_SOC_HDMI_CODEC=y
CONFIG_SND_SOC_PCM3008=y
CONFIG_SND_SOC_RT5631=y
CONFIG_SND_SOC_RT5640=y
CONFIG_SND_SOC_SGTL5000=y
CONFIG_SND_SOC_SI476X=y
CONFIG_SND_SOC_SPDIF=y
CONFIG_SND_SOC_SSM2518=y
CONFIG_SND_SOC_SSM2602=y
CONFIG_SND_SOC_STA32X=y
CONFIG_SND_SOC_STA529=y
CONFIG_SND_SOC_TAS5086=y
CONFIG_SND_SOC_TLV320AIC23=y
CONFIG_SND_SOC_TLV320AIC32X4=y
CONFIG_SND_SOC_TLV320AIC3X=y
CONFIG_SND_SOC_TLV320DAC33=y
CONFIG_SND_SOC_TWL4030=y
CONFIG_SND_SOC_UDA134X=y
CONFIG_SND_SOC_UDA1380=y
CONFIG_SND_SOC_WL1273=y
CONFIG_SND_SOC_WM1250_EV1=y
CONFIG_SND_SOC_WM2000=y
CONFIG_SND_SOC_WM2200=y
CONFIG_SND_SOC_WM5100=y
CONFIG_SND_SOC_WM8510=y
CONFIG_SND_SOC_WM8523=y
CONFIG_SND_SOC_WM8580=y
CONFIG_SND_SOC_WM8711=y
CONFIG_SND_SOC_WM8727=y
CONFIG_SND_SOC_WM8728=y
CONFIG_SND_SOC_WM8731=y
CONFIG_SND_SOC_WM8737=y
CONFIG_SND_SOC_WM8741=y
CONFIG_SND_SOC_WM8750=y
CONFIG_SND_SOC_WM8753=y
CONFIG_SND_SOC_WM8776=y
CONFIG_SND_SOC_WM8782=y
CONFIG_SND_SOC_WM8804=y
CONFIG_SND_SOC_WM8900=y
CONFIG_SND_SOC_WM8903=y
CONFIG_SND_SOC_WM8904=y
CONFIG_SND_SOC_WM8940=y
CONFIG_SND_SOC_WM8955=y
CONFIG_SND_SOC_WM8960=y
CONFIG_SND_SOC_WM8961=y
CONFIG_SND_SOC_WM8962=y
CONFIG_SND_SOC_WM8971=y
CONFIG_SND_SOC_WM8974=y
CONFIG_SND_SOC_WM8978=y
CONFIG_SND_SOC_WM8983=y
CONFIG_SND_SOC_WM8985=y
CONFIG_SND_SOC_WM8988=y
CONFIG_SND_SOC_WM8990=y
CONFIG_SND_SOC_WM8991=y
CONFIG_SND_SOC_WM8993=y
CONFIG_SND_SOC_WM8994=y
CONFIG_SND_SOC_WM8995=y
CONFIG_SND_SOC_WM8996=y
CONFIG_SND_SOC_WM9081=y
CONFIG_SND_SOC_WM9090=y
CONFIG_SND_SOC_LM4857=y
CONFIG_SND_SOC_MAX9768=y
CONFIG_SND_SOC_MAX9877=y
CONFIG_SND_SOC_ML26124=y
CONFIG_SND_SOC_TPA6130A2=y
# CONFIG_SND_SIMPLE_CARD is not set
CONFIG_SOUND_PRIME=y
CONFIG_SOUND_OSS=y
# CONFIG_SOUND_TRACEINIT is not set
# CONFIG_SOUND_DMAP is not set
# CONFIG_SOUND_VMIDI is not set
# CONFIG_SOUND_TRIX is not set
CONFIG_SOUND_MSS=y
CONFIG_SOUND_MPU401=y
CONFIG_SOUND_PAS=y
# CONFIG_PAS_JOYSTICK is not set
CONFIG_SOUND_PSS=y
# CONFIG_PSS_MIXER is not set
# CONFIG_PSS_HAVE_BOOT is not set
CONFIG_SOUND_SB=y
CONFIG_SOUND_YM3812=y
CONFIG_SOUND_UART6850=y
CONFIG_SOUND_AEDSP16=y
CONFIG_SC6600=y
# CONFIG_SC6600_JOY is not set
CONFIG_SC6600_CDROM=4
CONFIG_SC6600_CDROMBASE=0
# CONFIG_SOUND_KAHLUA is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
CONFIG_UHID=y
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_PRODIKEYS=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_PRIMAX=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SPEEDLINK=y
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=y
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=y
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=y
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_HID_SENSOR_HUB=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set
CONFIG_USB_DWC3=y
CONFIG_USB_DWC3_GADGET=y
CONFIG_USB_DWC3_DEBUG=y
# CONFIG_USB_DWC3_VERBOSE is not set
CONFIG_USB_CHIPIDEA=y
# CONFIG_USB_CHIPIDEA_UDC is not set
CONFIG_USB_CHIPIDEA_DEBUG=y

#
# USB port drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_OMAP_CONTROL_USB=y
CONFIG_OMAP_USB3=y
CONFIG_SAMSUNG_USBPHY=y
# CONFIG_SAMSUNG_USB2PHY is not set
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_USB_GPIO_VBUS=y
CONFIG_USB_ISP1301=y
CONFIG_USB_RCAR_PHY=y
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
CONFIG_USB_GADGET_DEBUG_FILES=y
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
# CONFIG_USB_R8A66597 is not set
CONFIG_USB_PXA27X=y
CONFIG_USB_MV_UDC=y
CONFIG_USB_MV_U3D=y
# CONFIG_USB_M66592 is not set
# CONFIG_USB_AMD5536UDC is not set
CONFIG_USB_NET2272=y
CONFIG_USB_NET2272_DMA=y
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
CONFIG_USB_LIBCOMPOSITE=y
# CONFIG_USB_ZERO is not set
# CONFIG_USB_AUDIO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_MASS_STORAGE is not set
CONFIG_USB_GADGET_TARGET=y
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
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
# CONFIG_MSPRO_BLOCK is not set

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
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8788=y
CONFIG_LEDS_CLEVO_MAIL=y
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA9633=y
# CONFIG_LEDS_DA903X is not set
# CONFIG_LEDS_DA9052 is not set
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_ADP5520 is not set
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_LM355x=y
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

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
# CONFIG_RTC_HCTOSYS is not set
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
CONFIG_RTC_DRV_DS1307=y
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_DS3232=y
# CONFIG_RTC_DRV_LP8788 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
CONFIG_RTC_DRV_MAX8907=y
# CONFIG_RTC_DRV_MAX8925 is not set
CONFIG_RTC_DRV_MAX8998=y
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=y
# CONFIG_RTC_DRV_X1205 is not set
CONFIG_RTC_DRV_PCF8523=y
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=y
CONFIG_RTC_DRV_M41T80_WDT=y
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_TWL4030=y
CONFIG_RTC_DRV_TPS65910=y
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=y
# CONFIG_RTC_DRV_RV3029C2 is not set

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
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_DS2404=y
# CONFIG_RTC_DRV_PCF50633 is not set

#
# on-CPU RTC drivers
#

#
# HID Sensor RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV=y
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_VIRT_DRIVERS is not set
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

#
# Xen driver support
#
# CONFIG_XEN_BALLOON is not set
# CONFIG_XEN_DEV_EVTCHN is not set
CONFIG_XEN_BACKEND=y
CONFIG_XENFS=y
# CONFIG_XEN_COMPAT_XENFS is not set
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
CONFIG_XEN_GRANT_DEV_ALLOC=y
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_TMEM=y
CONFIG_XEN_PCIDEV_BACKEND=y
CONFIG_XEN_PRIVCMD=y
CONFIG_XEN_HAVE_PVMMU=y
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_ECHO is not set
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
# CONFIG_PANEL_CHANGE_MESSAGE is not set
# CONFIG_IDE_PHISON is not set
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
CONFIG_AD7291=y
CONFIG_AD7606=y
CONFIG_AD7606_IFACE_PARALLEL=y
CONFIG_AD799X=y
CONFIG_AD799X_RING_BUFFER=y

#
# Analog digital bi-direction converters
#
# CONFIG_ADT7316 is not set

#
# Capacitance to digital converters
#
CONFIG_AD7150=y
# CONFIG_AD7152 is not set
# CONFIG_AD7746 is not set

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
# CONFIG_IIO_SIMPLE_DUMMY is not set
CONFIG_ZSMALLOC=y
CONFIG_ZRAM=y
# CONFIG_ZRAM_DEBUG is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_FT1000=y

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ASHMEM=y
CONFIG_ANDROID_LOGGER=y
# CONFIG_ANDROID_TIMED_OUTPUT is not set
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
# CONFIG_ANDROID_INTF_ALARM_DEV is not set
# CONFIG_SYNC is not set
# CONFIG_NET_VENDOR_SILICOM is not set
CONFIG_DGRP=y
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
CONFIG_CHROMEOS_LAPTOP=y
CONFIG_DELL_LAPTOP=y
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_SAMSUNG_Q10=y
# CONFIG_APPLE_GMUX is not set
# CONFIG_PVPANIC is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
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
# CONFIG_EXTCON_GPIO is not set
# CONFIG_EXTCON_ADC_JACK is not set
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
CONFIG_HID_SENSOR_ACCEL_3D=y
# CONFIG_IIO_ST_ACCEL_3AXIS is not set

#
# Analog to digital converters
#
# CONFIG_LP8788_ADC is not set
CONFIG_MAX1363=y
# CONFIG_TI_ADC081C is not set

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS=y
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
# CONFIG_AD5380 is not set
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
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_ITG3200=y

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
# CONFIG_SENSORS_LM3533 is not set
CONFIG_SENSORS_TSL2563=y
CONFIG_VCNL4000=y
CONFIG_HID_SENSOR_ALS=y

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
# CONFIG_HID_SENSOR_MAGNETOMETER_3D is not set
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y

#
# Triggers - standalone
#
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure sensors
#
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=y
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4_USE_FOR_EXT23 is not set
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
# CONFIG_REISERFS_FS_POSIX_ACL is not set
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
CONFIG_JFS_DEBUG=y
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y
# CONFIG_OVERLAYFS_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
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
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=y
CONFIG_ECRYPT_FS_MESSAGING=y
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_XATTR is not set
CONFIG_SQUASHFS_ZLIB=y
CONFIG_SQUASHFS_LZO=y
# CONFIG_SQUASHFS_XZ is not set
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_EXOFS_FS=y
# CONFIG_EXOFS_DEBUG is not set
CONFIG_F2FS_FS=y
# CONFIG_F2FS_STAT_FS is not set
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
# CONFIG_F2FS_FS_SECURITY is not set
CONFIG_ORE=y
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=y
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
CONFIG_DLM_DEBUG=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
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
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set

#
# RCU Debugging
#
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_LKDTM is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
# CONFIG_DEBUG_PAGEALLOC is not set
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
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
CONFIG_IOMMU_STRESS=y
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
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set

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
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
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
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
# CONFIG_CRYPTO_GHASH is not set
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
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
# CONFIG_KVM_AMD is not set
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
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_LRU_CACHE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
CONFIG_DDR=y
CONFIG_FONT_SUPPORT=y
CONFIG_FONTS=y
# CONFIG_FONT_8x8 is not set
CONFIG_FONT_8x16=y
CONFIG_FONT_6x11=y
# CONFIG_FONT_7x14 is not set
CONFIG_FONT_PEARL_8x8=y
# CONFIG_FONT_ACORN_8x8 is not set
# CONFIG_FONT_MINI_4x6 is not set
CONFIG_FONT_SUN8x16=y
# CONFIG_FONT_SUN12x22 is not set
# CONFIG_FONT_10x18 is not set

--zYM0uCDKw75PZbzx--
