Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbaERBrs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 21:47:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:29722 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbaERBrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 21:47:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,860,1392192000"; 
   d="log'?scan'208";a="533607886"
Date: Sun, 18 May 2014 09:47:12 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [ACPI] WARNING: CPU: 0 PID: 1 at kernel/irq/manage.c:1325
 __free_irq()
Message-ID: <20140518014712.GB8448@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
commit 64acc0549fea1b404b88c1354813886364902488
Merge: 0856ad1 6456b00
Author:     Stephen Rothwell <sfr@canb.auug.org.au>
AuthorDate: Fri May 16 16:27:24 2014 +1000

    Merge branch 'akpm-current/current'
    
    Conflicts:
    	arch/x86/kernel/apic/hw_nmi.c
    	mm/memblock.c
    	mm/memcontrol.c

+-----------------------------------------------------+------------+------------+------------+---------------+
|                                                     | 0856ad1ef1 | 6456b00c4f | 64acc0549f | next-20140516 |
+-----------------------------------------------------+------------+------------+------------+---------------+
| boot_successes                                      | 60         | 60         | 0          | 0             |
| boot_failures                                       | 0          | 0          | 20         | 13            |
| WARNING:CPU:PID:at_kernel/irq/manage.c:__free_irq() | 0          | 0          | 20         | 13            |
| backtrace:acpi_terminate                            | 0          | 0          | 20         | 13            |
| backtrace:acpi_init                                 | 0          | 0          | 20         | 13            |
| backtrace:kernel_init_freeable                      | 0          | 0          | 20         | 13            |
+-----------------------------------------------------+------------+------------+------------+---------------+

[    0.947668] ACPI: Added _OSI(Processor Aggregator Device)
[    0.951373] ACPI: Unable to start the ACPI Interpreter
[    0.954908] ------------[ cut here ]------------
[    0.958496] WARNING: CPU: 0 PID: 1 at kernel/irq/manage.c:1325 __free_irq+0x10b/0x3c3()
[    0.960000] Trying to free already-free IRQ 9
[    0.960000] Modules linked in:
[    0.960000] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc5-06386-g64acc05 #1
[    0.960000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.960000]  0000000000000000 ffff88001150bc90 ffffffff8160618b ffff88001150bcd8
[    0.960000]  ffff88001150bcc8 ffffffff8105c54f ffffffff810ca9d7 0000000000000000
[    0.960000]  ffff8800000914a0 0000000000000009 ffffffff81315f00 ffff88001150bd28
[    0.960000] Call Trace:
[    0.960000]  [<ffffffff8160618b>] dump_stack+0xa1/0x124
[    0.960000]  [<ffffffff8105c54f>] warn_slowpath_common+0xb0/0xde
[    0.960000]  [<ffffffff810ca9d7>] ? __free_irq+0x10b/0x3c3
[    0.960000]  [<ffffffff81315f00>] ? acpi_map_lookup+0x3/0x63
[    0.960000]  [<ffffffff8105c663>] warn_slowpath_fmt+0x5a/0x63
[    0.960000]  [<ffffffff8161278e>] ? _raw_spin_lock_irqsave+0xd2/0xeb
[    0.960000]  [<ffffffff810ca9a2>] ? __free_irq+0xd6/0x3c3
[    0.960000]  [<ffffffff810ca9d7>] __free_irq+0x10b/0x3c3
[    0.960000]  [<ffffffff81315ffa>] ? acpi_os_drop_map_ref+0x57/0x57
[    0.960000]  [<ffffffff81315ffa>] ? acpi_os_drop_map_ref+0x57/0x57
[    0.960000]  [<ffffffff810caec9>] free_irq+0x167/0x197
[    0.960000]  [<ffffffff820732aa>] ? acpi_sleep_init+0x154/0x154
[    0.960000]  [<ffffffff81316a6d>] acpi_os_remove_interrupt_handler+0x33/0x49
[    0.960000]  [<ffffffff813304f3>] acpi_ev_remove_all_sci_handlers+0x26/0x9e
[    0.960000]  [<ffffffff820732aa>] ? acpi_sleep_init+0x154/0x154
[    0.960000]  [<ffffffff8132f287>] acpi_ev_terminate+0xcc/0x15f
[    0.960000]  [<ffffffff820732aa>] ? acpi_sleep_init+0x154/0x154
[    0.960000]  [<ffffffff8134e52f>] acpi_ut_subsystem_shutdown+0x1a/0xf5
[    0.960000]  [<ffffffff820732aa>] ? acpi_sleep_init+0x154/0x154
[    0.960000]  [<ffffffff820752e7>] acpi_terminate+0x56/0x77
[    0.960000]  [<ffffffff82073645>] acpi_init+0x39b/0x3c3
[    0.960000]  [<ffffffff81000367>] ? do_one_initcall+0xd2/0x2c1
[    0.960000]  [<ffffffff811c1095>] ? kfree+0xe8/0x17b
[    0.960000]  [<ffffffff820732aa>] ? acpi_sleep_init+0x154/0x154
[    0.960000]  [<ffffffff820732aa>] ? acpi_sleep_init+0x154/0x154
[    0.960000]  [<ffffffff81000418>] do_one_initcall+0x183/0x2c1
[    0.960000]  [<ffffffff81086df5>] ? parameq+0x29/0x32
[    0.960000]  [<ffffffff81087098>] ? parse_args+0x29a/0x3e8
[    0.960000]  [<ffffffff82036833>] kernel_init_freeable+0x1e9/0x2dc
[    0.960000]  [<ffffffff82035976>] ? do_early_param+0xd7/0xd7
[    0.960000]  [<ffffffff815fa8ba>] ? rest_init+0x15e/0x15e
[    0.960000]  [<ffffffff815fa8cf>] kernel_init+0x15/0x17a
[    0.960000]  [<ffffffff8161403c>] ret_from_fork+0x7c/0xb0
[    0.960000]  [<ffffffff815fa8ba>] ? rest_init+0x15e/0x15e
[    0.960000] ---[ end trace adcd8b06ce955289 ]---
[    0.980636] vgaarb: loaded

git bisect start 4151fa6adc65da14673ece623bbb2acc6936f8be 0856ad1ef175c45dc6a0bc629ca355fdfbb1001e --
git bisect  bad 64acc0549fea1b404b88c1354813886364902488  # 20:10      0-      1  Merge branch 'akpm-current/current'
git bisect good 894878f70476deaca209750445d5c6d370180a43  # 20:14     20+      0  mm-use-the-light-version-__mod_zone_page_state-in-mlocked_vma_newpage-checkpatch-fixes
git bisect good 1578d82c1dfd0faa67229a41aad15db5783db440  # 20:20     20+      0  rtc: rtc-ds1742: make of_device_id array const
git bisect good 9588c229c1e48d024a7ef34af489f576a395adf6  # 20:24     20+      0  smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix
git bisect good 146494976f9be2f0e38a291abe41f33f368a530e  # 20:29     20+      0  kernel/profile.c: use static const char instead of static char
git bisect good e217856eed37885172ae6762a78a6fad8a02b960  # 20:34     20+      0  ipc,shm: document new limits in the uapi header
git bisect good 98495af6a9ea22abc87ef5f800267f1536a3426f  # 20:40     20+      0  lib/scatterlist: make ARCH_HAS_SG_CHAIN an actual Kconfig
git bisect good 29bfc4afc4fe1f9337dc60e19015af02867c1844  # 20:45     20+      0  lib/scatterlist: clean up useless architecture versions of scatterlist.h
git bisect good d66cd3b40705c5873f81621a530d05b60544aee8  # 20:50     20+      0  sysrq: rcu-ify __handle_sysrq
git bisect good 6456b00c4f4ac3774506ff54242a8849172cb650  # 20:55     20+      0  sysrq,rcu: suppress RCU stall warnings while sysrq runs
# first bad commit: [64acc0549fea1b404b88c1354813886364902488] Merge branch 'akpm-current/current'
git bisect good 0856ad1ef175c45dc6a0bc629ca355fdfbb1001e  # 20:58     60+      0  Merge branch 'rd-docs/master'
git bisect good 6456b00c4f4ac3774506ff54242a8849172cb650  # 21:00     60+      0  sysrq,rcu: suppress RCU stall warnings while sysrq runs
git bisect  bad 4151fa6adc65da14673ece623bbb2acc6936f8be  # 21:00      0-     13  Add linux-next specific files for 20140516
git bisect good 14186fea0cb06bc43181ce239efe0df6f1af260a  # 21:05     60+      0  Merge tag 'locks-v3.15-4' of git://git.samba.org/jlayton/linux
git bisect  bad 4151fa6adc65da14673ece623bbb2acc6936f8be  # 21:05      0-     13  Add linux-next specific files for 20140516


This script may reproduce the error.

-----------------------------------------------------------------------------
#!/bin/bash

kernel=$1

kvm=(
	qemu-system-x86_64 -cpu kvm64 -enable-kvm 
	-kernel $kernel
	-smp 2
	-m 256M
	-net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio
	-net user,vlan=0
	-net nic,vlan=1,model=e1000
	-net user,vlan=1
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-serial stdio
	-display none
	-monitor null
)

append=(
	debug
	sched_debug
	apic=debug
	ignore_loglevel
	sysrq_always_enabled
	panic=10
	prompt_ramdisk=0
	earlyprintk=ttyS0,115200
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
)

"${kvm[@]}" --append "${append[*]}"
-----------------------------------------------------------------------------

Thanks,
Fengguang

--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-f3-39:20140517200915:x86_64-randconfig-iv1-05171949:3.15.0-rc5-06386-g64acc05:1"
Content-Transfer-Encoding: quoted-printable

early console in setup code
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.15.0-rc5-06386-g64acc05 (kbuild@ivytown2) (g=
cc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP PREEMPT Sat May 17 20:06:45 CST=
 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-iv1-05171949/next:master=
:64acc0549fea1b404b88c1354813886364902488:bisect-linux9/.vmlinuz-64acc0549f=
ea1b404b88c1354813886364902488-20140517200713-15-f3 branch=3Dnext/master BO=
OT_IMAGE=3D/kernel/x86_64-randconfig-iv1-05171949/64acc0549fea1b404b88c1354=
813886364902488/vmlinuz-3.15.0-rc5-06386-g64acc05 drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   Centaur CentaurHauls
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0319d000, 0x0319dfff] PGTABLE
[    0.000000] BRK [0x0319e000, 0x0319efff] PGTABLE
[    0.000000] BRK [0x0319f000, 0x0319ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
[    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x031a0000, 0x031a0fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
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
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13ffdfff]
[    0.000000]   NODE_DATA [mem 0x13ffa000-0x13ffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ff9001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA32 zone: 1120 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 81820 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 475 pages/cpu @ffff880012400000 s1914432 r8=
192 d22976 u2097152
[    0.000000] pcpu-alloc: s1914432 r8192 d22976 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1240cc00
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80679
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-iv1-05171949/next=
:master:64acc0549fea1b404b88c1354813886364902488:bisect-linux9/.vmlinuz-64a=
cc0549fea1b404b88c1354813886364902488-20140517200713-15-f3 branch=3Dnext/ma=
ster BOOT_IMAGE=3D/kernel/x86_64-randconfig-iv1-05171949/64acc0549fea1b404b=
88c1354813886364902488/vmlinuz-3.15.0-rc5-06386-g64acc05 drbd.minor_count=
=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Memory: 260236K/327280K available (6234K kernel code, 3573K =
rwdata, 4876K rodata, 2748K init, 16936K bss, 67044K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8671 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] allocated 1572864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.438 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.030000] Calibrating delay loop (skipped) preset value.. 5386.87 Bogo=
MIPS (lpj=3D26934380)
[    0.030158] pid_max: default: 32768 minimum: 301
[    0.034655] ACPI: Core revision 20140214
[    0.079517] ACPI: All ACPI Tables successfully acquired
[    0.084065] Security Framework initialized
[    0.087795] AppArmor: AppArmor initialized
[    0.091138] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.102412] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.111293] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.116817] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.131692] Initializing cgroup subsys debug
[    0.137006] Initializing cgroup subsys memory
[    0.141749] Initializing cgroup subsys devices
[    0.146598] Initializing cgroup subsys net_cls
[    0.150652] Initializing cgroup subsys hugetlb
[    0.155144] numa_add_cpu cpu 0 node 0: mask now 0
[    0.160151] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.160151] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.160151] tlb_flushall_shift: -1
[    0.171055] Freeing SMP alternatives memory: 8K (ffffffff82110000 - ffff=
ffff82112000)
[    0.190141] Getting VERSION: 50014
[    0.193285] Getting VERSION: 50014
[    0.196377] Getting ID: 0
[    0.198930] Getting ID: ff000000
[    0.200185] Getting LVT0: 8700
[    0.202882] Getting LVT1: 8400
[    0.205907] enabled ExtINT on CPU#0
[    0.214631] ENABLING IO-APIC IRQs
[    0.217795] init IO_APIC IRQs
[    0.220127]  apic 0 pin 0 not connected
[    0.223823] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.230381] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.240325] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.247323] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.250331] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.260329] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.270354] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.277375] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.280345] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.290330] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.297370] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.300368] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.310330] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.320350] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.327479] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.330305]  apic 0 pin 16 not connected
[    0.333534]  apic 0 pin 17 not connected
[    0.340117]  apic 0 pin 18 not connected
[    0.343481]  apic 0 pin 19 not connected
[    0.350121]  apic 0 pin 20 not connected
[    0.353649]  apic 0 pin 21 not connected
[    0.357083]  apic 0 pin 22 not connected
[    0.360109]  apic 0 pin 23 not connected
[    0.363811] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.370088] smpboot: CPU0: GenuineIntel Common KVM processor (fam: 0f, m=
odel: 06, stepping: 01)
[    0.386721] Using local APIC timer interrupts.
[    0.386721] calibrating APIC timer ...
[    0.400000] ... lapic delta =3D 6250853
[    0.400000] ... PM-Timer delta =3D 357948
[    0.400000] ... PM-Timer result ok
[    0.400000] ..... delta 6250853
[    0.400000] ..... mult: 268472092
[    0.400000] ..... calibration result: 10001364
[    0.400000] ..... CPU clock speed is 2693.4602 MHz.
[    0.400000] ..... host bus clock speed is 1000.1364 MHz.
[    0.401294] Performance Events: no PMU driver, software events only.
[    0.482450] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.514111] x86: Booting SMP configuration:
[    0.517427] .... node  #0, CPUs:      #1
[    0.030000] kvm-clock: cpu 1, msr 0:13ff9041, secondary cpu clock
[    0.030000] masked ExtINT on CPU#1
[    0.030000] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.548189] x86: Booted up 1 node, 2 CPUs
[    0.547755] KVM setup async PF for cpu 1
[    0.547755] kvm-stealtime: cpu 1, msr 1260cc00
[    0.557117] smpboot: Total of 2 processors activated (10773.75 BogoMIPS)
[    0.579010] gcov: version magic: 0x3430382a
[    0.591045] evm: security.capability
[    0.618926] prandom: seed boundary self test passed
[    0.620739] prandom: 100 self tests passed
[    0.631557] NET: Registered protocol family 16
[    0.647714] cpuidle: using governor ladder
[    0.650226] cpuidle: using governor menu
[    0.657183] ACPI: bus type PCI registered
[    0.663742] PCI: Using configuration type 1 for base access
[    0.935792] ACPI: Added _OSI(Module Device)
[    0.940174] ACPI: Added _OSI(Processor Device)
[    0.943444] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.947668] ACPI: Added _OSI(Processor Aggregator Device)
[    0.951373] ACPI: Unable to start the ACPI Interpreter
[    0.954908] ------------[ cut here ]------------
[    0.958496] WARNING: CPU: 0 PID: 1 at kernel/irq/manage.c:1325 __free_ir=
q+0x10b/0x3c3()
[    0.960000] Trying to free already-free IRQ 9
[    0.960000] Modules linked in:
[    0.960000] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc5-06386-g=
64acc05 #1
[    0.960000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.960000]  0000000000000000 ffff88001150bc90 ffffffff8160618b ffff8800=
1150bcd8
[    0.960000]  ffff88001150bcc8 ffffffff8105c54f ffffffff810ca9d7 00000000=
00000000
[    0.960000]  ffff8800000914a0 0000000000000009 ffffffff81315f00 ffff8800=
1150bd28
[    0.960000] Call Trace:
[    0.960000]  [<ffffffff8160618b>] dump_stack+0xa1/0x124
[    0.960000]  [<ffffffff8105c54f>] warn_slowpath_common+0xb0/0xde
[    0.960000]  [<ffffffff810ca9d7>] ? __free_irq+0x10b/0x3c3
[    0.960000]  [<ffffffff81315f00>] ? acpi_map_lookup+0x3/0x63
[    0.960000]  [<ffffffff8105c663>] warn_slowpath_fmt+0x5a/0x63
[    0.960000]  [<ffffffff8161278e>] ? _raw_spin_lock_irqsave+0xd2/0xeb
[    0.960000]  [<ffffffff810ca9a2>] ? __free_irq+0xd6/0x3c3
[    0.960000]  [<ffffffff810ca9d7>] __free_irq+0x10b/0x3c3
[    0.960000]  [<ffffffff81315ffa>] ? acpi_os_drop_map_ref+0x57/0x57
[    0.960000]  [<ffffffff81315ffa>] ? acpi_os_drop_map_ref+0x57/0x57
[    0.960000]  [<ffffffff810caec9>] free_irq+0x167/0x197
[    0.960000]  [<ffffffff820732aa>] ? acpi_sleep_init+0x154/0x154
[    0.960000]  [<ffffffff81316a6d>] acpi_os_remove_interrupt_handler+0x33/=
0x49
[    0.960000]  [<ffffffff813304f3>] acpi_ev_remove_all_sci_handlers+0x26/0=
x9e
[    0.960000]  [<ffffffff820732aa>] ? acpi_sleep_init+0x154/0x154
[    0.960000]  [<ffffffff8132f287>] acpi_ev_terminate+0xcc/0x15f
[    0.960000]  [<ffffffff820732aa>] ? acpi_sleep_init+0x154/0x154
[    0.960000]  [<ffffffff8134e52f>] acpi_ut_subsystem_shutdown+0x1a/0xf5
[    0.960000]  [<ffffffff820732aa>] ? acpi_sleep_init+0x154/0x154
[    0.960000]  [<ffffffff820752e7>] acpi_terminate+0x56/0x77
[    0.960000]  [<ffffffff82073645>] acpi_init+0x39b/0x3c3
[    0.960000]  [<ffffffff81000367>] ? do_one_initcall+0xd2/0x2c1
[    0.960000]  [<ffffffff811c1095>] ? kfree+0xe8/0x17b
[    0.960000]  [<ffffffff820732aa>] ? acpi_sleep_init+0x154/0x154
[    0.960000]  [<ffffffff820732aa>] ? acpi_sleep_init+0x154/0x154
[    0.960000]  [<ffffffff81000418>] do_one_initcall+0x183/0x2c1
[    0.960000]  [<ffffffff81086df5>] ? parameq+0x29/0x32
[    0.960000]  [<ffffffff81087098>] ? parse_args+0x29a/0x3e8
[    0.960000]  [<ffffffff82036833>] kernel_init_freeable+0x1e9/0x2dc
[    0.960000]  [<ffffffff82035976>] ? do_early_param+0xd7/0xd7
[    0.960000]  [<ffffffff815fa8ba>] ? rest_init+0x15e/0x15e
[    0.960000]  [<ffffffff815fa8cf>] kernel_init+0x15/0x17a
[    0.960000]  [<ffffffff8161403c>] ret_from_fork+0x7c/0xb0
[    0.960000]  [<ffffffff815fa8ba>] ? rest_init+0x15e/0x15e
[    0.960000] ---[ end trace adcd8b06ce955289 ]---
[    0.980636] vgaarb: loaded
[    0.999675] usbcore: registered new interface driver usbfs
[    1.002070] usbcore: registered new interface driver hub
[    1.012115] usbcore: registered new device driver usb
[    1.023752] pps_core: LinuxPPS API ver. 1 registered
[    1.027883] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.030561] PTP clock support registered
[    1.040429] EDAC MC: Ver: 3.0.0
[    1.045753] EDAC DEBUG: edac_mc_sysfs_init: device mc created
[    1.061729] PCI: Probing PCI hardware
[    1.064831] PCI: root bus 00: using default resources
[    1.070160] PCI: Probing PCI hardware (bus 00)
[    1.076725] PCI host bridge to bus 0000:00
[    1.080187] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    1.085507] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffff=
fff]
[    1.090159] pci_bus 0000:00: No busn resource found for root bus, will u=
se [bus 00-ff]
[    1.093463] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.100850] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.111268] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.127538] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    1.134710] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    1.140187] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    1.145846] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    1.150182] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    1.166352] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.181667] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    1.189645] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    1.194107] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.223801] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.237112] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.280641] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.295940] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.301222] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.312015] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    1.322004] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.345655] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    1.353969] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    1.362628] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    1.387644] pci_bus 0000:00: busn_res: [bus 00-ff] end is updated to 00
[    1.390857] pci 0000:00:01.0: PIIX/ICH IRQ router [8086:7000]
[    1.395964] PCI: pci_cache_line_size set to 64 bytes
[    1.401578] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.410630] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    1.432242] irda_init()
[    1.436313] NET: Registered protocol family 23
[    1.448647] Switched to clocksource kvm-clock
[    1.461773] Warning: could not register annotated branches stats
[    2.387002] FS-Cache: Loaded
[    2.394774] AppArmor: AppArmor Filesystem Enabled
[    2.398695] pnp: PnP ACPI: disabled
[    2.419671] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    2.425150] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[    2.432374] NET: Registered protocol family 1
[    2.436399] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.441152] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    2.444123] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    2.448229] pci 0000:00:02.0: Boot video device
[    2.451830] PCI: CLS 0 bytes, default 64
[    2.459558] Unpacking initramfs...
[   15.818580] Freeing initrd memory: 23244K (ffff88001293d000 - ffff880013=
ff0000)
[   15.826077] platform rtc_cmos: registered platform RTC device (no PNP de=
vice found)
[   15.844887] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[   15.851956] AVX instructions are not detected.
[   15.856585] spin_lock-torture:--- Start of test: nwriters_stress=3D4 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[   15.866938] spin_lock-torture: Creating torture_shuffle task
[   15.872992] spin_lock-torture: torture_shuffle task started
[   15.876764] spin_lock-torture: Creating torture_stutter task
[   15.877985] spin_lock-torture: Creating lock_torture_writer task
[   15.878741] spin_lock-torture: torture_stutter task started
[   15.879211] spin_lock-torture: Creating lock_torture_writer task
[   15.881095] spin_lock-torture: lock_torture_writer task started
[   15.881770] spin_lock-torture: Creating lock_torture_writer task
[   15.882533] spin_lock-torture: lock_torture_writer task started
[   15.883010] spin_lock-torture: Creating lock_torture_writer task
[   15.883785] spin_lock-torture: lock_torture_writer task started
[   15.884189] spin_lock-torture: Creating lock_torture_stats task
[   15.884967] spin_lock-torture: lock_torture_writer task started
[   15.902261] spin_lock-torture: lock_torture_stats task started
[   15.923873] futex hash table entries: 512 (order: 4, 65536 bytes)
[   15.924915] Initialise system trusted keyring
[   15.926202] audit: initializing netlink subsys (disabled)
[   15.928428] audit: type=3D2000 audit(1400328476.029:1): initialized
[   19.971844] Kprobe smoke test started
[   20.051023] Kprobe smoke test passed successfully
[   20.066437] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   20.074584] VFS: Disk quotas dquot_6.5.2
[   20.077320] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   20.085946] msgmni has been set to 553
[   20.197055] NET: Registered protocol family 38
[   20.200365] Key type asymmetric registered
[   20.202514] Asymmetric key parser 'x509' registered
[   20.206294] start plist test
[   20.217691] end plist test
[   20.219713] list_sort_test: start testing list_sort()
[   20.238218] test_string_helpers: Running tests...
[   20.244490] xz_dec_test: module loaded
[   20.247844] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
252 0' and write .xz files to it.
[   20.256223] rbtree testing -> 14409 cycles
[   20.890916] augmented rbtree testing -> 20405 cycles
[   21.771158] no IO addresses supplied
[   21.774740] ipmi message handler version 39.2
[   21.777035] IPMI System Interface driver.
[   21.779807] ipmi_si: Adding default-specified kcs state machine
[   21.782731] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[   21.786551] ipmi_si: Interface detection failed
[   21.801058] ipmi_si: Adding default-specified smic state machine
[   21.806220] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[   21.814721] ipmi_si: Interface detection failed
[   21.831003] ipmi_si: Adding default-specified bt state machine
[   21.842064] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[   21.849570] ipmi_si: Interface detection failed
[   21.863868] ipmi_si: Unable to find any System Interface(s)
[   22.376867] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   22.426949] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115=
200) is a 16550A
[   22.463709] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[   22.475538] [drm] Initialized drm 1.1.0 20060810
[   22.482758] usbcore: registered new interface driver udl
[   22.493321] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[   22.507028] c2port c2port0: C2 port uc added
[   22.516785] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[   22.599046] tun: Universal TUN/TAP device driver, 1.6
[   22.605982] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   22.617610] vcan: Virtual CAN interface driver
[   22.628491] usbcore: registered new interface driver irda-usb
[   22.634379] w83977af_init()
[   22.637261] w83977af_open()
[   22.639910] w83977af_probe()
[   22.643932] w83977af_probe(), Wrong chip version
[   22.648094] w83977af_probe()
[   22.652415] w83977af_probe(), Wrong chip version
[   22.658092] usbcore: registered new interface driver ksdazzle-sir
[   22.665004] PPP generic driver version 2.4.2
[   22.674762] hdlc: HDLC support module revision 1.22
[   22.678761] usbcore: registered new interface driver kaweth
[   22.681620] usbcore: registered new interface driver asix
[   22.685072] usbcore: registered new interface driver ax88179_178a
[   22.688668] usbcore: registered new interface driver cdc_eem
[   22.691759] usbcore: registered new interface driver dm9601
[   22.694988] usbcore: registered new interface driver CoreChips
[   22.697910] usbcore: registered new interface driver smsc75xx
[   22.703604] usbcore: registered new interface driver cdc_subset
[   22.706788] usbcore: registered new interface driver kalmia
[   22.710922] usbcore: registered new interface driver cdc_ncm
[   22.714031] usbcore: registered new interface driver huawei_cdc_ncm
[   22.717950] usbcore: registered new interface driver qmi_wwan
[   22.731454] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[   22.734599] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[   22.738572] usbcore: registered new interface driver cdc_wdm
[   22.741903] usbcore: registered new interface driver usbtmc
[   22.745305] usbcore: registered new interface driver mdc800
[   22.747457] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[   22.750725] usbcore: registered new interface driver adutux
[   22.757138] usbcore: registered new interface driver appledisplay
[   22.764127] usbcore: registered new interface driver idmouse
[   22.769455] usbcore: registered new interface driver usblcd
[   22.775014] usbcore: registered new interface driver ldusb
[   22.777475] usbcore: registered new interface driver usbled
[   22.782226] usbcore: registered new interface driver legousbtower
[   22.785939] usbcore: registered new interface driver rio500
[   22.789980] usbcore: registered new interface driver usbtest
[   22.796145] usbcore: registered new interface driver usb_ehset_test
[   22.800574] usbcore: registered new interface driver trancevibrator
[   22.804867] usbcore: registered new interface driver yurex
[   22.808975] i8042: PNP: No PS/2 controller found. Probing ports directly.
[   22.817384] serio: i8042 KBD port at 0x60,0x64 irq 1
[   22.822030] serio: i8042 AUX port at 0x60,0x64 irq 12
[   23.245515] usbcore: registered new interface driver RobotFuzz Open Sour=
ce InterFace, OSIF
[   23.266956] Driver for 1-wire Dallas network protocol.
[   23.288469] usbcore: registered new interface driver DS9490R
[   23.295584] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[   23.296233] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[   23.303660] CAPI 2.0 started up with major 68 (no middleware)
[   23.305212] wbsd: Winbond W83L51xD SD/MMC card interface driver
[   23.305230] wbsd: Copyright(c) Pierre Ossman
[   23.308966] usbcore: registered new interface driver ushc
[   23.315026] ledtrig-cpu: registered to indicate activity on CPUs
[   23.339128] usbip_core: USB/IP Core v1.0.0
[   23.344507] usbcore: registered new interface driver tranzport
[   23.349953] usbcore: registered new interface driver alphatrack
[   23.361454] ozwpan ozwpan: Ozmo Devices WPAN
[   23.371678] ozwpan ozwpan: new USB bus registered, assigned bus number 1
[   23.379329] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[   23.383965] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   23.388164] usb usb1: Product: Ozmo Devices WPAN
[   23.391006] usb usb1: Manufacturer: Linux 3.15.0-rc5-06386-g64acc05 Ozmo=
 WPAN
[   23.393745] usb usb1: SerialNumber: ozwpan
[   23.402830] hub 1-0:1.0: USB hub found
[   23.407386] hub 1-0:1.0: 8 ports detected
[   23.429848] oprofile: using timer interrupt.
[   23.433531] Mirror/redirect action on
[   23.436225] Simple TC action Loaded
[   23.446255] u32 classifier
[   23.448384]     Performance counters on
[   23.452148]     input device check on
[   23.454612]     Actions configured
[   23.457968] can: controller area network core (rev 20120528 abi 9)
[   23.462901] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
[   23.467120] NET: Registered protocol family 29
[   23.469865] can: raw protocol (rev 20120528)
[   23.474575] 9pnet: Installing 9P2000 support
[   23.478212] NET: Registered protocol family 36
[   23.481289] mpls_gso: MPLS GSO support
[   23.485457]=20
[   23.485457] printing PIC contents
[   23.489205] ... PIC  IMR: ffff
[   23.491142] ... PIC  IRR: 1013
[   23.493905] ... PIC  ISR: 0000
[   23.495147] ... PIC ELCR: 0c00
[   23.497246] printing local APIC contents on CPU#0/0:
[   23.506930] ... APIC ID:      00000000 (0)
[   23.506930] ... APIC VERSION: 00050014
[   23.506930] ... APIC TASKPRI: 00000000 (00)
[   23.506930] ... APIC PROCPRI: 00000000
[   23.506930] ... APIC LDR: 01000000
[   23.506930] ... APIC DFR: ffffffff
[   23.506930] ... APIC SPIV: 000001ff
[   23.506930] ... APIC ISR field:
[   23.506930] 000000000000000000000000000000000000000000000000000000000000=
0000
[   23.506930] ... APIC TMR field:
[   23.506930] 000000000000000000000000000000000000000000000000000000000000=
0000
[   23.506930] ... APIC IRR field:
[   23.506930] 000000000000000000000000000000000000000000000000000000002000=
8000
[   23.506930] ... APIC ESR: 00000000
[   23.506930] ... APIC ICR: 000008fd
[   23.506930] ... APIC ICR2: 02000000
[   23.506930] ... APIC LVTT: 000000ef
[   23.506930] ... APIC LVTPC: 00010000
[   23.506930] ... APIC LVT0: 00010700
[   23.506930] ... APIC LVT1: 00000400
[   23.506930] ... APIC LVTERR: 000000fe
[   23.506930] ... APIC TMICT: 0007f606
[   23.506930] ... APIC TMCCT: 00000000
[   23.506930] ... APIC TDCR: 00000003
[   23.506930]=20
[   23.642669] number of MP IRQ sources: 15.
[   23.646705] number of IO-APIC #0 registers: 24.
[   23.651728] testing the IO APIC.......................
[   23.656980] IO APIC #0......
[   23.660807] .... register #00: 00000000
[   23.664650] .......    : physical APIC id: 00
[   23.668929] .......    : Delivery Type: 0
[   23.677343] .......    : LTS          : 0
[   23.687208] .... register #01: 00170011
[   23.694223] .......     : max redirection entries: 17
[   23.698803] .......     : PRQ implemented: 0
[   23.701834] .......     : IO APIC version: 11
[   23.706973] .... register #02: 00000000
[   23.709327] .......     : arbitration: 00
[   23.712528] .... IRQ redirection table:
[   23.715990] 1    0    0   0   0    0    0    00
[   23.719717] 0    0    0   0   0    1    1    31
[   23.723917] 0    0    0   0   0    1    1    30
[   23.726954] 0    0    0   0   0    1    1    33
[   23.731312] 1    0    0   0   0    1    1    34
[   23.733197] 1    1    0   0   0    1    1    35
[   23.734802] 0    0    0   0   0    1    1    36
[   23.736427] 0    0    0   0   0    1    1    37
[   23.738066] 0    0    0   0   0    1    1    38
[   23.741166] 1    1    0   0   0    1    1    39
[   23.743454] 1    1    0   0   0    1    1    3A
[   23.745174] 1    1    0   0   0    1    1    3B
[   23.746752] 0    0    0   0   0    1    1    3C
[   23.748446] 0    0    0   0   0    1    1    3D
[   23.750206] 0    0    0   0   0    1    1    3E
[   23.752753] 0    0    0   0   0    1    1    3F
[   23.754463] 1    0    0   0   0    0    0    00
[   23.756161] 1    0    0   0   0    0    0    00
[   23.757797] 1    0    0   0   0    0    0    00
[   23.760928] 1    0    0   0   0    0    0    00
[   23.763212] 1    0    0   0   0    0    0    00
[   23.765678] 1    0    0   0   0    0    0    00
[   23.767429] 1    0    0   0   0    0    0    00
[   23.769031] 1    0    0   0   0    0    0    00
[   23.770814] IRQ to pin mappings:
[   23.772041] IRQ0 -> 0:2
[   23.773936] IRQ1 -> 0:1
[   23.775258] IRQ3 -> 0:3
[   23.776361] IRQ4 -> 0:4
[   23.777981] IRQ5 -> 0:5
[   23.780809] IRQ6 -> 0:6
[   23.782780] IRQ7 -> 0:7
[   23.783866] IRQ8 -> 0:8
[   23.784991] IRQ9 -> 0:9
[   23.787285] IRQ10 -> 0:10
[   23.789525] IRQ11 -> 0:11
[   23.794324] IRQ12 -> 0:12
[   23.797349] IRQ13 -> 0:13
[   23.800299] IRQ14 -> 0:14
[   23.802631] IRQ15 -> 0:15
[   23.804588] .................................... done.
[   23.816072] Loading compiled-in X.509 certificates
[   23.822467] Loaded X.509 cert 'Magrathea: Glacier signing key: 580d3a2dd=
ad1380c43f7ecc3b90696bf27f764c6'
[   23.865213] Key type encrypted registered
[   23.889934] AppArmor: AppArmor sha1 policy hashing enabled
[   23.906860] console [netcon0] enabled
[   23.908763] netconsole: network logging started
[   23.959906] Freeing unused kernel memory: 2748K (ffffffff81e61000 - ffff=
ffff82110000)
[   24.135191] random: init urandom read with 69 bits of entropy available
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
[   64.480667] random: nonblocking pool is initialized
[   75.900112] spin_lock-torture: Writes:  Total: 4  Max/Min: 0/0   Fail: 0=
=20
plymouth-upstart-bridge: ply-event-loop.c:497: ply_event_loop_new: Assertio=
n `loop->epoll_fd >=3D 0' failed.
/etc/lsb-base-logging.sh: line 5:   129 Aborted                 plymouth --=
ping > /dev/null 2>&1
/etc/lsb-base-logging.sh: line 5:   136 Aborted                 plymouth --=
ping > /dev/null 2>&1
mount: proc has wrong device number or fs type proc not supported
/etc/lsb-base-logging.sh: line 5:   154 Aborted                 plymouth --=
ping > /dev/null 2>&1
/etc/rc6.d/S40umountfs: line 20: /proc/mounts: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
umount: /var/run: not mounted
umount: /var/lock: not mounted
umount: /dev/shm: not mounted
mount: / is busy
 * Will now restart
[   93.148770] Unregister pv shared memory for cpu 1
[   93.149248] Unregister pv shared memory for cpu 0
[   93.149817] spin_lock-torture: Unscheduled system shutdown detected
[   93.152038] reboot: Restarting system
[   93.152421] reboot: machine restart
Elapsed time: 100
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-iv1-05171949/64acc0549fea1b404b88c1354813886364902488/vmlinuz-3.15.0-rc5-0=
6386-g64acc05 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug=
 apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 pan=
ic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 conso=
le=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/=
kbuild-tests/run-queue/kvm/x86_64-randconfig-iv1-05171949/next:master:64acc=
0549fea1b404b88c1354813886364902488:bisect-linux9/.vmlinuz-64acc0549fea1b40=
4b88c1354813886364902488-20140517200713-15-f3 branch=3Dnext/master BOOT_IMA=
GE=3D/kernel/x86_64-randconfig-iv1-05171949/64acc0549fea1b404b88c1354813886=
364902488/vmlinuz-3.15.0-rc5-06386-g64acc05 drbd.minor_count=3D8'  -initrd =
/kernel-tests/initrd/quantal-core-x86_64.cgz -m 320 -smp 2 -net nic,vlan=3D=
1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6=
300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-quantal-f3-39 -ser=
ial file:/dev/shm/kboot/serial-quantal-f3-39 -daemonize -display none -moni=
tor null=20

--KsGdsel6WgEHnImy
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-iv1-05171949-4151fa6adc65da14673ece623bbb2acc6936f8be-WARNING:---at----__free_irq+-x-4377.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgNDE1MWZhNi4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxl
cyBmb3IgMjAxNDA1MTYKZ2l0IGNoZWNrb3V0IDA4NTZhZDFlZjE3NWM0NWRjNmEwYmM2Mjlj
YTM1NWZkZmJiMTAwMWUKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82
NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0OS9uZXh0Om1hc3RlcjowODU2YWQxZWYxNzVjNDVk
YzZhMGJjNjI5Y2EzNTVmZGZiYjEwMDFlOmJpc2VjdC1saW51eDkKCjIwMTQtMDUtMTctMTk6
NTk6MDYgMDg1NmFkMWVmMTc1YzQ1ZGM2YTBiYzYyOWNhMzU1ZmRmYmIxMDAxZSBjb21waWxp
bmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZf
NjQtcmFuZGNvbmZpZy1pdjEtMDUxNzE5NDktMDg1NmFkMWVmMTc1YzQ1ZGM2YTBiYzYyOWNh
MzU1ZmRmYmIxMDAxZQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaXYxLTA1MTcxOTQ5LzA4NTZhZDFlZjE3NWM0NWRjNmEwYmM2MjljYTM1NWZkZmJi
MTAwMWUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0OS0wODU2YWQxZWYxNzVjNDVkYzZh
MGJjNjI5Y2EzNTVmZGZiYjEwMDFlCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5LTA4
NTZhZDFlZjE3NWM0NWRjNmEwYmM2MjljYTM1NWZkZmJiMTAwMWUKa2VybmVsOiAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0OS8wODU2YWQxZWYxNzVjNDVkYzZhMGJj
NjI5Y2EzNTVmZGZiYjEwMDFlL3ZtbGludXotMy4xNS4wLXJjNS0wNTkzNS1nMDg1NmFkMQoK
MjAxNC0wNS0xNy0yMDowMjowNiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMQkyMCBTVUNDRVNT
CgpiaXNlY3Q6IGdvb2QgY29tbWl0IDA4NTZhZDFlZjE3NWM0NWRjNmEwYmM2MjljYTM1NWZk
ZmJiMTAwMWUKZ2l0IGJpc2VjdCBzdGFydCA0MTUxZmE2YWRjNjVkYTE0NjczZWNlNjIzYmJi
MmFjYzY5MzZmOGJlIDA4NTZhZDFlZjE3NWM0NWRjNmEwYmM2MjljYTM1NWZkZmJiMTAwMWUg
LS0KL2Mva2VybmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6IFsiLWIiLCAiNDE1MWZhNmFkYzY1
ZGExNDY3M2VjZTYyM2JiYjJhY2M2OTM2ZjhiZSIsICItZyIsICIwODU2YWQxZWYxNzVjNDVk
YzZhMGJjNjI5Y2EzNTVmZGZiYjEwMDFlIiwgIi9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVz
dC1ib290LWZhaWx1cmUuc2giLCAiL2tlcm5lbC10ZXN0cy9saW51eDkvb2JqLWJpc2VjdCJd
CkJpc2VjdGluZzogNDkxIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSA5IHN0ZXBzKQpbNjRhY2MwNTQ5ZmVhMWI0MDRiODhjMTM1NDgxMzg4NjM2NDkwMjQ4
OF0gTWVyZ2UgYnJhbmNoICdha3BtLWN1cnJlbnQvY3VycmVudCcKcnVubmluZyAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGlu
dXg5L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82
NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0OS9uZXh0Om1hc3Rlcjo2NGFjYzA1NDlmZWExYjQw
NGI4OGMxMzU0ODEzODg2MzY0OTAyNDg4OmJpc2VjdC1saW51eDkKCjIwMTQtMDUtMTctMjA6
MDM6MDcgNjRhY2MwNTQ5ZmVhMWI0MDRiODhjMTM1NDgxMzg4NjM2NDkwMjQ4OCBjb21waWxp
bmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZf
NjQtcmFuZGNvbmZpZy1pdjEtMDUxNzE5NDktNjRhY2MwNTQ5ZmVhMWI0MDRiODhjMTM1NDgx
Mzg4NjM2NDkwMjQ4OApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaXYxLTA1MTcxOTQ5LzY0YWNjMDU0OWZlYTFiNDA0Yjg4YzEzNTQ4MTM4ODYzNjQ5
MDI0ODgKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0OS02NGFjYzA1NDlmZWExYjQwNGI4
OGMxMzU0ODEzODg2MzY0OTAyNDg4CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5LTY0
YWNjMDU0OWZlYTFiNDA0Yjg4YzEzNTQ4MTM4ODYzNjQ5MDI0ODgKa2VybmVsOiAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0OS82NGFjYzA1NDlmZWExYjQwNGI4OGMx
MzU0ODEzODg2MzY0OTAyNDg4L3ZtbGludXotMy4xNS4wLXJjNS0wNjM4Ni1nNjRhY2MwNQoK
MjAxNC0wNS0xNy0yMDowOTowNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLiBURVNUIEZBSUxV
UkUKWyAgICAwLjE4MjI3Ml0gQUNQSTogQWRkZWQgX09TSShQcm9jZXNzb3IgQWdncmVnYXRv
ciBEZXZpY2UpClsgICAgMC4xODMxODRdIEFDUEk6IFVuYWJsZSB0byBzdGFydCB0aGUgQUNQ
SSBJbnRlcnByZXRlcgpbICAgIDAuMTgzNjY5XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0t
LS0tLS0tLS0tLS0KWyAgICAwLjE4NDEzNF0gV0FSTklORzogQ1BVOiAwIFBJRDogMSBhdCAv
a2J1aWxkL3NyYy9zbW9rZS9rZXJuZWwvaXJxL21hbmFnZS5jOjEzMjUgX19mcmVlX2lycSsw
eDEwYi8weDNjMygpClsgICAgMC4xODUwMjZdIFRyeWluZyB0byBmcmVlIGFscmVhZHktZnJl
ZSBJUlEgOQpbICAgIDAuMTg1NDQ2XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAwLjE4NTc2
Ml0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xNS4wLXJj
NS0wNjM4Ni1nNjRhY2MwNSAjMQpbICAgIDAuMTg2NDY3XSBIYXJkd2FyZSBuYW1lOiBCb2No
cyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMC4xODcwMTBdICAwMDAwMDAw
MDAwMDAwMDAwIGZmZmY4ODAwMTE1MGJjOTAgZmZmZmZmZmY4MTYwNjE4YiBmZmZmODgwMDEx
NTBiY2Q4ClsgICAgMC4xODc3ODFdICBmZmZmODgwMDExNTBiY2M4IGZmZmZmZmZmODEwNWM1
NGYgZmZmZmZmZmY4MTBjYTlkNyAwMDAwMDAwMDAwMDAwMDAwClsgICAgMC4xODg1NTVdICBm
ZmZmODgwMDAwMDkxNGEwIDAwMDAwMDAwMDAwMDAwMDkgZmZmZmZmZmY4MTMxNWYwMCBmZmZm
ODgwMDExNTBiZDI4ClsgICAgMC4xODkzMjhdIENhbGwgVHJhY2U6ClsgICAgMC4xODk1NzZd
ICBbPGZmZmZmZmZmODE2MDYxOGI+XSBkdW1wX3N0YWNrKzB4YTEvMHgxMjQKWyAgICAwLjE5
MDAwMF0gIFs8ZmZmZmZmZmY4MTA1YzU0Zj5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4YjAv
MHhkZQpbICAgIDAuMTkwMDAwXSAgWzxmZmZmZmZmZjgxMGNhOWQ3Pl0gPyBfX2ZyZWVfaXJx
KzB4MTBiLzB4M2MzClsgICAgMC4xOTAwMDBdICBbPGZmZmZmZmZmODEzMTVmMDA+XSA/IGFj
cGlfbWFwX2xvb2t1cCsweDMvMHg2MwpbICAgIDAuMTkwMDAwXSAgWzxmZmZmZmZmZjgxMDVj
NjYzPl0gd2Fybl9zbG93cGF0aF9mbXQrMHg1YS8weDYzClsgICAgMC4xOTAwMDBdICBbPGZm
ZmZmZmZmODE2MTI3OGU+XSA/IF9yYXdfc3Bpbl9sb2NrX2lycXNhdmUrMHhkMi8weGViClsg
ICAgMC4xOTAwMDBdICBbPGZmZmZmZmZmODEwY2E5YTI+XSA/IF9fZnJlZV9pcnErMHhkNi8w
eDNjMwpbICAgIDAuMTkwMDAwXSAgWzxmZmZmZmZmZjgxMGNhOWQ3Pl0gX19mcmVlX2lycSsw
eDEwYi8weDNjMwpbICAgIDAuMTkwMDAwXSAgWzxmZmZmZmZmZjgxMzE1ZmZhPl0gPyBhY3Bp
X29zX2Ryb3BfbWFwX3JlZisweDU3LzB4NTcKWyAgICAwLjE5MDAwMF0gIFs8ZmZmZmZmZmY4
MTMxNWZmYT5dID8gYWNwaV9vc19kcm9wX21hcF9yZWYrMHg1Ny8weDU3ClsgICAgMC4xOTAw
MDBdICBbPGZmZmZmZmZmODEwY2FlYzk+XSBmcmVlX2lycSsweDE2Ny8weDE5NwpbICAgIDAu
MTkwMDAwXSAgWzxmZmZmZmZmZjgyMDczMmFhPl0gPyBhY3BpX3NsZWVwX2luaXQrMHgxNTQv
MHgxNTQKWyAgICAwLjE5MDAwMF0gIFs8ZmZmZmZmZmY4MTMxNmE2ZD5dIGFjcGlfb3NfcmVt
b3ZlX2ludGVycnVwdF9oYW5kbGVyKzB4MzMvMHg0OQpbICAgIDAuMTkwMDAwXSAgWzxmZmZm
ZmZmZjgxMzMwNGYzPl0gYWNwaV9ldl9yZW1vdmVfYWxsX3NjaV9oYW5kbGVycysweDI2LzB4
OWUKWyAgICAwLjE5MDAwMF0gIFs8ZmZmZmZmZmY4MjA3MzJhYT5dID8gYWNwaV9zbGVlcF9p
bml0KzB4MTU0LzB4MTU0ClsgICAgMC4xOTAwMDBdICBbPGZmZmZmZmZmODEzMmYyODc+XSBh
Y3BpX2V2X3Rlcm1pbmF0ZSsweGNjLzB4MTVmClsgICAgMC4xOTAwMDBdICBbPGZmZmZmZmZm
ODIwNzMyYWE+XSA/IGFjcGlfc2xlZXBfaW5pdCsweDE1NC8weDE1NApbICAgIDAuMTkwMDAw
XSAgWzxmZmZmZmZmZjgxMzRlNTJmPl0gYWNwaV91dF9zdWJzeXN0ZW1fc2h1dGRvd24rMHgx
YS8weGY1ClsgICAgMC4xOTAwMDBdICBbPGZmZmZmZmZmODIwNzMyYWE+XSA/IGFjcGlfc2xl
ZXBfaW5pdCsweDE1NC8weDE1NApbICAgIDAuMTkwMDAwXSAgWzxmZmZmZmZmZjgyMDc1MmU3
Pl0gYWNwaV90ZXJtaW5hdGUrMHg1Ni8weDc3ClsgICAgMC4xOTAwMDBdICBbPGZmZmZmZmZm
ODIwNzM2NDU+XSBhY3BpX2luaXQrMHgzOWIvMHgzYzMKWyAgICAwLjE5MDAwMF0gIFs8ZmZm
ZmZmZmY4MTAwMDM2Nz5dID8gZG9fb25lX2luaXRjYWxsKzB4ZDIvMHgyYzEKWyAgICAwLjE5
MDAwMF0gIFs8ZmZmZmZmZmY4MTFjMTA5NT5dID8ga2ZyZWUrMHhlOC8weDE3YgpbICAgIDAu
MTkwMDAwXSAgWzxmZmZmZmZmZjgyMDczMmFhPl0gPyBhY3BpX3NsZWVwX2luaXQrMHgxNTQv
MHgxNTQKWyAgICAwLjE5MDAwMF0gIFs8ZmZmZmZmZmY4MjA3MzJhYT5dID8gYWNwaV9zbGVl
cF9pbml0KzB4MTU0LzB4MTU0ClsgICAgMC4xOTAwMDBdICBbPGZmZmZmZmZmODEwMDA0MTg+
XSBkb19vbmVfaW5pdGNhbGwrMHgxODMvMHgyYzEKWyAgICAwLjE5MDAwMF0gIFs8ZmZmZmZm
ZmY4MTA4NmRmNT5dID8gcGFyYW1lcSsweDI5LzB4MzIKWyAgICAwLjE5MDAwMF0gIFs8ZmZm
ZmZmZmY4MTA4NzA5OD5dID8gcGFyc2VfYXJncysweDI5YS8weDNlOApbICAgIDAuMTkwMDAw
XSAgWzxmZmZmZmZmZjgyMDM2ODMzPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgxZTkvMHgy
ZGMKWyAgICAwLjE5MDAwMF0gIFs8ZmZmZmZmZmY4MjAzNTk3Nj5dID8gZG9fZWFybHlfcGFy
YW0rMHhkNy8weGQ3ClsgICAgMC4xOTAwMDBdICBbPGZmZmZmZmZmODE1ZmE4YmE+XSA/IHJl
c3RfaW5pdCsweDE1ZS8weDE1ZQpbICAgIDAuMTkwMDAwXSAgWzxmZmZmZmZmZjgxNWZhOGNm
Pl0ga2VybmVsX2luaXQrMHgxNS8weDE3YQpbICAgIDAuMTkwMDAwXSAgWzxmZmZmZmZmZjgx
NjE0MDNjPl0gcmV0X2Zyb21fZm9yaysweDdjLzB4YjAKWyAgICAwLjE5MDAwMF0gIFs8ZmZm
ZmZmZmY4MTVmYThiYT5dID8gcmVzdF9pbml0KzB4MTVlLzB4MTVlClsgICAgMC4xOTAwMDBd
IC0tLVsgZW5kIHRyYWNlIGJhYzc3YzRiZDM3NmQ3MWIgXS0tLQpbICAgIDAuMjAxMjM2XSB2
Z2FhcmI6IGxvYWRlZAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0OS82
NGFjYzA1NDlmZWExYjQwNGI4OGMxMzU0ODEzODg2MzY0OTAyNDg4L2RtZXNnLXF1YW50YWwt
ZjItNjg6MjAxNDA1MTcyMDA4NTk6eDg2XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5OjMu
MTUuMC1yYzUtMDYzODYtZzY0YWNjMDU6MQowOjE6MSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBi
b290cwobWzE7MzVtMjAxNC0wNS0xNyAyMDoxMDowOCBSRVBFQVQgQ09VTlQ6IDIwICAjIC9r
ZXJuZWwtdGVzdHMvbGludXg5L29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCmxpbmVhci1iaXNl
Y3Q6IGJhZCBicmFuY2ggbWF5IGJlIGJyYW5jaCAnYWtwbS1jdXJyZW50L2N1cnJlbnQnCmxp
bmVhci1iaXNlY3Q6IGhhbmRsZSBvdmVyIHRvIGdpdCBiaXNlY3QKbGluZWFyLWJpc2VjdDog
Z2l0IGJpc2VjdCBzdGFydCA2NGFjYzA1NDlmZWExYjQwNGI4OGMxMzU0ODEzODg2MzY0OTAy
NDg4IDA4NTZhZDFlZjE3NWM0NWRjNmEwYmM2MjljYTM1NWZkZmJiMTAwMWUgLS0KUHJldmlv
dXMgSEVBRCBwb3NpdGlvbiB3YXMgNjRhY2MwNS4uLiBNZXJnZSBicmFuY2ggJ2FrcG0tY3Vy
cmVudC9jdXJyZW50JwpIRUFEIGlzIG5vdyBhdCA2ZTQ2NjQ1Li4uIExpbnV4IDMuMTEKQmlz
ZWN0aW5nOiAyMjUgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDggc3RlcHMpCls4OTQ4NzhmNzA0NzZkZWFjYTIwOTc1MDQ0NWQ1YzZkMzcwMTgwYTQzXSBt
bS11c2UtdGhlLWxpZ2h0LXZlcnNpb24tX19tb2Rfem9uZV9wYWdlX3N0YXRlLWluLW1sb2Nr
ZWRfdm1hX25ld3BhZ2UtY2hlY2twYXRjaC1maXhlcwpsaW5lYXItYmlzZWN0OiBnaXQgYmlz
ZWN0IHJ1biAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9r
ZXJuZWwtdGVzdHMvbGludXg5L29iai1iaXNlY3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg5L29iai1i
aXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29u
ZmlnLWl2MS0wNTE3MTk0OS9uZXh0Om1hc3Rlcjo4OTQ4NzhmNzA0NzZkZWFjYTIwOTc1MDQ0
NWQ1YzZkMzcwMTgwYTQzOmJpc2VjdC1saW51eDkKCjIwMTQtMDUtMTctMjA6MTA6MTUgODk0
ODc4ZjcwNDc2ZGVhY2EyMDk3NTA0NDVkNWM2ZDM3MDE4MGE0MyBjb21waWxpbmcKUXVldWVk
IGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNv
bmZpZy1pdjEtMDUxNzE5NDktODk0ODc4ZjcwNDc2ZGVhY2EyMDk3NTA0NDVkNWM2ZDM3MDE4
MGE0MwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYx
LTA1MTcxOTQ5Lzg5NDg3OGY3MDQ3NmRlYWNhMjA5NzUwNDQ1ZDVjNmQzNzAxODBhNDMKd2Fp
dGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82
NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0OS04OTQ4NzhmNzA0NzZkZWFjYTIwOTc1MDQ0NWQ1
YzZkMzcwMTgwYTQzCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5LTg5NDg3OGY3MDQ3
NmRlYWNhMjA5NzUwNDQ1ZDVjNmQzNzAxODBhNDMKa2VybmVsOiAva2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWl2MS0wNTE3MTk0OS84OTQ4NzhmNzA0NzZkZWFjYTIwOTc1MDQ0NWQ1YzZk
MzcwMTgwYTQzL3ZtbGludXotMy4xNS4wLXJjNS0wMDMwMi1nODk0ODc4ZgoKMjAxNC0wNS0x
Ny0yMDoxMzoxNSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTIwIFNVQ0NFU1MKCkJpc2VjdGlu
ZzogMTEyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA3IHN0
ZXBzKQpbMTU3OGQ4MmMxZGZkMGZhYTY3MjI5YTQxYWFkMTVkYjU3ODNkYjQ0MF0gcnRjOiBy
dGMtZHMxNzQyOiBtYWtlIG9mX2RldmljZV9pZCBhcnJheSBjb25zdApydW5uaW5nIC9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9s
aW51eDkvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2
XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5L25leHQ6bWFzdGVyOjE1NzhkODJjMWRmZDBm
YWE2NzIyOWE0MWFhZDE1ZGI1NzgzZGI0NDA6YmlzZWN0LWxpbnV4OQoKMjAxNC0wNS0xNy0y
MDoxNDoxNiAxNTc4ZDgyYzFkZmQwZmFhNjcyMjlhNDFhYWQxNWRiNTc4M2RiNDQwIGNvbXBp
bGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4
Nl82NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0OS0xNTc4ZDgyYzFkZmQwZmFhNjcyMjlhNDFh
YWQxNWRiNTc4M2RiNDQwCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1pdjEtMDUxNzE5NDkvMTU3OGQ4MmMxZGZkMGZhYTY3MjI5YTQxYWFkMTVkYjU3
ODNkYjQ0MAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQt
cXVldWUveDg2XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5LTE1NzhkODJjMWRmZDBmYWE2
NzIyOWE0MWFhZDE1ZGI1NzgzZGI0NDAKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDUxNzE5NDkt
MTU3OGQ4MmMxZGZkMGZhYTY3MjI5YTQxYWFkMTVkYjU3ODNkYjQ0MAprZXJuZWw6IC9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5LzE1NzhkODJjMWRmZDBmYWE2NzIy
OWE0MWFhZDE1ZGI1NzgzZGI0NDAvdm1saW51ei0zLjE1LjAtcmM1LTAwNDE1LWcxNTc4ZDgy
CgoyMDE0LTA1LTE3LTIwOjE5OjE2IGRldGVjdGluZyBib290IHN0YXRlIC4JMTMJMjAgU1VD
Q0VTUwoKQmlzZWN0aW5nOiA1NiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgNiBzdGVwcykKWzk1ODhjMjI5YzFlNDhkMDI0YTdlZjM0YWY0ODlmNTc2YTM5
NWFkZjZdIHNtcC1wcmludC1tb3JlLXVzZWZ1bC1kZWJ1Zy1pbmZvLXVwb24tcmVjZWl2aW5n
LWlwaS1vbi1hbi1vZmZsaW5lLWNwdS1maXgKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlz
ZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg5L29iai1iaXNl
Y3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmln
LWl2MS0wNTE3MTk0OS9uZXh0Om1hc3Rlcjo5NTg4YzIyOWMxZTQ4ZDAyNGE3ZWYzNGFmNDg5
ZjU3NmEzOTVhZGY2OmJpc2VjdC1saW51eDkKCjIwMTQtMDUtMTctMjA6MjA6NDYgOTU4OGMy
MjljMWU0OGQwMjRhN2VmMzRhZjQ4OWY1NzZhMzk1YWRmNiBjb21waWxpbmcKUXVldWVkIGJ1
aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZp
Zy1pdjEtMDUxNzE5NDktOTU4OGMyMjljMWU0OGQwMjRhN2VmMzRhZjQ4OWY1NzZhMzk1YWRm
NgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA1
MTcxOTQ5Lzk1ODhjMjI5YzFlNDhkMDI0YTdlZjM0YWY0ODlmNTc2YTM5NWFkZjYKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1y
YW5kY29uZmlnLWl2MS0wNTE3MTk0OS05NTg4YzIyOWMxZTQ4ZDAyNGE3ZWYzNGFmNDg5ZjU3
NmEzOTVhZGY2CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5LTk1ODhjMjI5YzFlNDhk
MDI0YTdlZjM0YWY0ODlmNTc2YTM5NWFkZjYKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWl2MS0wNTE3MTk0OS85NTg4YzIyOWMxZTQ4ZDAyNGE3ZWYzNGFmNDg5ZjU3NmEz
OTVhZGY2L3ZtbGludXotMy4xNS4wLXJjNS0wMDQ3MS1nOTU4OGMyMgoKMjAxNC0wNS0xNy0y
MDoyMjo0NiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgkxOQkyMCBTVUNDRVNTCgpCaXNlY3Rp
bmc6IDI4IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA1IHN0
ZXBzKQpbMTQ2NDk0OTc2ZjliZTJmMGUzOGEyOTFhYmU0MWYzM2YzNjhhNTMwZV0ga2VybmVs
L3Byb2ZpbGUuYzogdXNlIHN0YXRpYyBjb25zdCBjaGFyIGluc3RlYWQgb2Ygc3RhdGljIGNo
YXIKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9rZXJuZWwtdGVzdHMvbGludXg5L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0OS9uZXh0Om1hc3Rl
cjoxNDY0OTQ5NzZmOWJlMmYwZTM4YTI5MWFiZTQxZjMzZjM2OGE1MzBlOmJpc2VjdC1saW51
eDkKCjIwMTQtMDUtMTctMjA6MjQ6NDcgMTQ2NDk0OTc2ZjliZTJmMGUzOGEyOTFhYmU0MWYz
M2YzNjhhNTMwZSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDUxNzE5NDktMTQ2NDk0OTc2
ZjliZTJmMGUzOGEyOTFhYmU0MWYzM2YzNjhhNTMwZQpDaGVjayBmb3Iga2VybmVsIGluIC9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5LzE0NjQ5NDk3NmY5YmUyZjBl
MzhhMjkxYWJlNDFmMzNmMzY4YTUzMGUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0OS0x
NDY0OTQ5NzZmOWJlMmYwZTM4YTI5MWFiZTQxZjMzZjM2OGE1MzBlCndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25m
aWctaXYxLTA1MTcxOTQ5LTE0NjQ5NDk3NmY5YmUyZjBlMzhhMjkxYWJlNDFmMzNmMzY4YTUz
MGUKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0OS8xNDY0
OTQ5NzZmOWJlMmYwZTM4YTI5MWFiZTQxZjMzZjM2OGE1MzBlL3ZtbGludXotMy4xNS4wLXJj
NS0wMDQ5OS1nMTQ2NDk0OQoKMjAxNC0wNS0xNy0yMDoyODo0NyBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAJNgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDE0IHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA0IHN0ZXBzKQpbZTIxNzg1NmVlZDM3ODg1MTcyYWU2
NzYyYTc4YTZmYWQ4YTAyYjk2MF0gaXBjLHNobTogZG9jdW1lbnQgbmV3IGxpbWl0cyBpbiB0
aGUgdWFwaSBoZWFkZXIKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg5L29iai1iaXNlY3QKbHMgLWEgL2ti
dWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0
OS9uZXh0Om1hc3RlcjplMjE3ODU2ZWVkMzc4ODUxNzJhZTY3NjJhNzhhNmZhZDhhMDJiOTYw
OmJpc2VjdC1saW51eDkKCjIwMTQtMDUtMTctMjA6Mjk6NDcgZTIxNzg1NmVlZDM3ODg1MTcy
YWU2NzYyYTc4YTZmYWQ4YTAyYjk2MCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8g
L2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDUxNzE5
NDktZTIxNzg1NmVlZDM3ODg1MTcyYWU2NzYyYTc4YTZmYWQ4YTAyYjk2MApDaGVjayBmb3Ig
a2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5L2UyMTc4
NTZlZWQzNzg4NTE3MmFlNjc2MmE3OGE2ZmFkOGEwMmI5NjAKd2FpdGluZyBmb3IgY29tcGxl
dGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWl2
MS0wNTE3MTk0OS1lMjE3ODU2ZWVkMzc4ODUxNzJhZTY3NjJhNzhhNmZhZDhhMDJiOTYwCndh
aXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2
XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5LWUyMTc4NTZlZWQzNzg4NTE3MmFlNjc2MmE3
OGE2ZmFkOGEwMmI5NjAKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0w
NTE3MTk0OS9lMjE3ODU2ZWVkMzc4ODUxNzJhZTY3NjJhNzhhNmZhZDhhMDJiOTYwL3ZtbGlu
dXotMy4xNS4wLXJjNS0wMDUxMy1nZTIxNzg1NgoKMjAxNC0wNS0xNy0yMDozMTo0NyBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAuLgk0CTE4CTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogNyByZXZp
c2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMyBzdGVwcykKWzk4NDk1
YWY2YTllYTIyYWJjODdlZjVmODAwMjY3ZjE1MzZhMzQyNmZdIGxpYi9zY2F0dGVybGlzdDog
bWFrZSBBUkNIX0hBU19TR19DSEFJTiBhbiBhY3R1YWwgS2NvbmZpZwpydW5uaW5nIC9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9s
aW51eDkvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2
XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5L25leHQ6bWFzdGVyOjk4NDk1YWY2YTllYTIy
YWJjODdlZjVmODAwMjY3ZjE1MzZhMzQyNmY6YmlzZWN0LWxpbnV4OQoKMjAxNC0wNS0xNy0y
MDozNDoxOCA5ODQ5NWFmNmE5ZWEyMmFiYzg3ZWY1ZjgwMDI2N2YxNTM2YTM0MjZmIGNvbXBp
bGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4
Nl82NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0OS05ODQ5NWFmNmE5ZWEyMmFiYzg3ZWY1Zjgw
MDI2N2YxNTM2YTM0MjZmCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1pdjEtMDUxNzE5NDkvOTg0OTVhZjZhOWVhMjJhYmM4N2VmNWY4MDAyNjdmMTUz
NmEzNDI2Zgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQt
cXVldWUveDg2XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5LTk4NDk1YWY2YTllYTIyYWJj
ODdlZjVmODAwMjY3ZjE1MzZhMzQyNmYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDUxNzE5NDkt
OTg0OTVhZjZhOWVhMjJhYmM4N2VmNWY4MDAyNjdmMTUzNmEzNDI2ZgprZXJuZWw6IC9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5Lzk4NDk1YWY2YTllYTIyYWJjODdl
ZjVmODAwMjY3ZjE1MzZhMzQyNmYvdm1saW51ei0zLjE1LjAtcmM1LTAwNTIwLWc5ODQ5NWFm
CgoyMDE0LTA1LTE3LTIwOjM4OjE4IGRldGVjdGluZyBib290IHN0YXRlIC4uCTEJMTMJMjAg
U1VDQ0VTUwoKQmlzZWN0aW5nOiAzIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSAyIHN0ZXBzKQpbMjliZmM0YWZjNGZlMWY5MzM3ZGM2MGUxOTAxNWFmMDI4
NjdjMTg0NF0gbGliL3NjYXR0ZXJsaXN0OiBjbGVhbiB1cCB1c2VsZXNzIGFyY2hpdGVjdHVy
ZSB2ZXJzaW9ucyBvZiBzY2F0dGVybGlzdC5oCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4OS9vYmotYmlz
ZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZp
Zy1pdjEtMDUxNzE5NDkvbmV4dDptYXN0ZXI6MjliZmM0YWZjNGZlMWY5MzM3ZGM2MGUxOTAx
NWFmMDI4NjdjMTg0NDpiaXNlY3QtbGludXg5CgoyMDE0LTA1LTE3LTIwOjQwOjQ4IDI5YmZj
NGFmYzRmZTFmOTMzN2RjNjBlMTkwMTVhZjAyODY3YzE4NDQgY29tcGlsaW5nClF1ZXVlZCBi
dWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25m
aWctaXYxLTA1MTcxOTQ5LTI5YmZjNGFmYzRmZTFmOTMzN2RjNjBlMTkwMTVhZjAyODY3YzE4
NDQKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0w
NTE3MTk0OS8yOWJmYzRhZmM0ZmUxZjkzMzdkYzYwZTE5MDE1YWYwMjg2N2MxODQ0CndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQt
cmFuZGNvbmZpZy1pdjEtMDUxNzE5NDktMjliZmM0YWZjNGZlMWY5MzM3ZGM2MGUxOTAxNWFm
MDI4NjdjMTg0NAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVp
bGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0OS0yOWJmYzRhZmM0ZmUx
ZjkzMzdkYzYwZTE5MDE1YWYwMjg2N2MxODQ0Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1pdjEtMDUxNzE5NDkvMjliZmM0YWZjNGZlMWY5MzM3ZGM2MGUxOTAxNWFmMDI4
NjdjMTg0NC92bWxpbnV6LTMuMTUuMC1yYzUtMDA1MjQtZzI5YmZjNGEKCjIwMTQtMDUtMTct
MjA6NDQ6NDggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6
IDEgcmV2aXNpb24gbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMSBzdGVwKQpb
ZDY2Y2QzYjQwNzA1YzU4NzNmODE2MjFhNTMwZDA1YjYwNTQ0YWVlOF0gc3lzcnE6IHJjdS1p
ZnkgX19oYW5kbGVfc3lzcnEKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg5L29iai1iaXNlY3QKbHMgLWEg
L2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNTE3
MTk0OS9uZXh0Om1hc3RlcjpkNjZjZDNiNDA3MDVjNTg3M2Y4MTYyMWE1MzBkMDViNjA1NDRh
ZWU4OmJpc2VjdC1saW51eDkKCjIwMTQtMDUtMTctMjA6NDU6NDkgZDY2Y2QzYjQwNzA1YzU4
NzNmODE2MjFhNTMwZDA1YjYwNTQ0YWVlOCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sg
dG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDUx
NzE5NDktZDY2Y2QzYjQwNzA1YzU4NzNmODE2MjFhNTMwZDA1YjYwNTQ0YWVlOApDaGVjayBm
b3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5L2Q2
NmNkM2I0MDcwNWM1ODczZjgxNjIxYTUzMGQwNWI2MDU0NGFlZTgKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmln
LWl2MS0wNTE3MTk0OS1kNjZjZDNiNDA3MDVjNTg3M2Y4MTYyMWE1MzBkMDViNjA1NDRhZWU4
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS8u
eDg2XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5LWQ2NmNkM2I0MDcwNWM1ODczZjgxNjIx
YTUzMGQwNWI2MDU0NGFlZTgKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2
MS0wNTE3MTk0OS9kNjZjZDNiNDA3MDVjNTg3M2Y4MTYyMWE1MzBkMDViNjA1NDRhZWU4L3Zt
bGludXotMy4xNS4wLXJjNS0wMDUyNi1nZDY2Y2QzYgoKMjAxNC0wNS0xNy0yMDo0ODo0OSBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMQkxNQkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDAgcmV2
aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDAgc3RlcHMpCls2NDU2
YjAwYzRmNGFjMzc3NDUwNmZmNTQyNDJhODg0OTE3MmNiNjUwXSBzeXNycSxyY3U6IHN1cHBy
ZXNzIFJDVSBzdGFsbCB3YXJuaW5ncyB3aGlsZSBzeXNycSBydW5zCnJ1bm5pbmcgL2Mva2Vy
bmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xp
bnV4OS9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZf
NjQtcmFuZGNvbmZpZy1pdjEtMDUxNzE5NDkvbmV4dDptYXN0ZXI6NjQ1NmIwMGM0ZjRhYzM3
NzQ1MDZmZjU0MjQyYTg4NDkxNzJjYjY1MDpiaXNlY3QtbGludXg5CgoyMDE0LTA1LTE3LTIw
OjUwOjE5IDY0NTZiMDBjNGY0YWMzNzc0NTA2ZmY1NDI0MmE4ODQ5MTcyY2I2NTAgY29tcGls
aW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2
XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5LTY0NTZiMDBjNGY0YWMzNzc0NTA2ZmY1NDI0
MmE4ODQ5MTcyY2I2NTAKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWl2MS0wNTE3MTk0OS82NDU2YjAwYzRmNGFjMzc3NDUwNmZmNTQyNDJhODg0OTE3
MmNiNjUwCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDUxNzE5NDktNjQ1NmIwMGM0ZjRhYzM3NzQ1
MDZmZjU0MjQyYTg4NDkxNzJjYjY1MAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0OS02
NDU2YjAwYzRmNGFjMzc3NDUwNmZmNTQyNDJhODg0OTE3MmNiNjUwCmtlcm5lbDogL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDUxNzE5NDkvNjQ1NmIwMGM0ZjRhYzM3NzQ1MDZm
ZjU0MjQyYTg4NDkxNzJjYjY1MC92bWxpbnV6LTMuMTUuMC1yYzUtMDA1MjctZzY0NTZiMDAK
CjIwMTQtMDUtMTctMjA6NTM6MTkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMTQJMjAgU1VD
Q0VTUwoKNjRhY2MwNTQ5ZmVhMWI0MDRiODhjMTM1NDgxMzg4NjM2NDkwMjQ4OCBpcyB0aGUg
Zmlyc3QgYmFkIGNvbW1pdApiaXNlY3QgcnVuIHN1Y2Nlc3MKUHJldmlvdXMgSEVBRCBwb3Np
dGlvbiB3YXMgNjQ1NmIwMC4uLiBzeXNycSxyY3U6IHN1cHByZXNzIFJDVSBzdGFsbCB3YXJu
aW5ncyB3aGlsZSBzeXNycSBydW5zCkhFQUQgaXMgbm93IGF0IDA4NTZhZDEuLi4gTWVyZ2Ug
YnJhbmNoICdyZC1kb2NzL21hc3RlcicKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUv
a3ZtL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0OS9uZXh0Om1hc3RlcjowODU2YWQx
ZWYxNzVjNDVkYzZhMGJjNjI5Y2EzNTVmZGZiYjEwMDFlOmJpc2VjdC1saW51eDkKCjIwMTQt
MDUtMTctMjA6NTU6MjEgMDg1NmFkMWVmMTc1YzQ1ZGM2YTBiYzYyOWNhMzU1ZmRmYmIxMDAx
ZSByZXVzZSAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0OS8wODU2YWQx
ZWYxNzVjNDVkYzZhMGJjNjI5Y2EzNTVmZGZiYjEwMDFlL3ZtbGludXotMy4xNS4wLXJjNS0w
NTkzNS1nMDg1NmFkMQoKMjAxNC0wNS0xNy0yMDo1NToyMSBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAuLgkzMQk0NAk1Nwk2MCBTVUNDRVNTCgpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyAw
ODU2YWQxLi4uIE1lcmdlIGJyYW5jaCAncmQtZG9jcy9tYXN0ZXInCkhFQUQgaXMgbm93IGF0
IDY0NTZiMDAuLi4gc3lzcnEscmN1OiBzdXBwcmVzcyBSQ1Ugc3RhbGwgd2FybmluZ3Mgd2hp
bGUgc3lzcnEgcnVucwpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5L25leHQ6bWFzdGVyOjY0NTZiMDBjNGY0YWMzNzc0
NTA2ZmY1NDI0MmE4ODQ5MTcyY2I2NTA6YmlzZWN0LWxpbnV4OQoKMjAxNC0wNS0xNy0yMDo1
ODoyMyA2NDU2YjAwYzRmNGFjMzc3NDUwNmZmNTQyNDJhODg0OTE3MmNiNjUwIHJldXNlIC9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5LzY0NTZiMDBjNGY0YWMzNzc0
NTA2ZmY1NDI0MmE4ODQ5MTcyY2I2NTAvdm1saW51ei0zLjE1LjAtcmM1LTAwNTI3LWc2NDU2
YjAwCgoyMDE0LTA1LTE3LTIwOjU4OjIzIGRldGVjdGluZyBib290IHN0YXRlIC4uCTI1CTU3
CTYwIFNVQ0NFU1MKClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDY0NTZiMDAuLi4gc3lz
cnEscmN1OiBzdXBwcmVzcyBSQ1Ugc3RhbGwgd2FybmluZ3Mgd2hpbGUgc3lzcnEgcnVucwpI
RUFEIGlzIG5vdyBhdCA0MTUxZmE2Li4uIEFkZCBsaW51eC1uZXh0IHNwZWNpZmljIGZpbGVz
IGZvciAyMDE0MDUxNgpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5L25leHQ6bWFzdGVyOjQxNTFmYTZhZGM2NWRhMTQ2
NzNlY2U2MjNiYmIyYWNjNjkzNmY4YmU6YmlzZWN0LWxpbnV4OQogVEVTVCBGQUlMVVJFClsg
ICAgMC4xODMyMzFdIEFDUEk6IEFkZGVkIF9PU0koUHJvY2Vzc29yIEFnZ3JlZ2F0b3IgRGV2
aWNlKQpbICAgIDAuMTg0MTMyXSBBQ1BJOiBVbmFibGUgdG8gc3RhcnQgdGhlIEFDUEkgSW50
ZXJwcmV0ZXIKWyAgICAwLjE4NDYxN10gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0t
LS0tLS0tClsgICAgMC4xODUwNjFdIFdBUk5JTkc6IENQVTogMCBQSUQ6IDEgYXQgL2tidWls
ZC9zcmMvc21va2Uva2VybmVsL2lycS9tYW5hZ2UuYzoxMzI1IF9fZnJlZV9pcnErMHgxMGIv
MHgzYzMoKQpbICAgIDAuMTg1OTMxXSBUcnlpbmcgdG8gZnJlZSBhbHJlYWR5LWZyZWUgSVJR
IDkKWyAgICAwLjE4NjM0Nl0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMC4xODY2NTldIENQ
VTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTUuMC1yYzUtbmV4
dC0yMDE0MDUxNiAjNApbICAgIDAuMTg3MzUzXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2No
cywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMC4xODc4ODRdICAwMDAwMDAwMDAwMDAw
MDAwIGZmZmY4ODAwMTE1MGJjOTAgZmZmZmZmZmY4MTYwNjJlYiBmZmZmODgwMDExNTBiY2Q4
ClsgICAgMC4xODg2NDFdICBmZmZmODgwMDExNTBiY2M4IGZmZmZmZmZmODEwNWM1NGYgZmZm
ZmZmZmY4MTBjYTlkNyAwMDAwMDAwMDAwMDAwMDAwClsgICAgMC4xODkzOTldICBmZmZmODgw
MDAwMDkxNGEwIDAwMDAwMDAwMDAwMDAwMDkgZmZmZmZmZmY4MTMxNjEwMCBmZmZmODgwMDEx
NTBiZDI4ClsgICAgMC4xOTAwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4xOTAwMDBdICBbPGZm
ZmZmZmZmODE2MDYyZWI+XSBkdW1wX3N0YWNrKzB4YTEvMHgxMjQKWyAgICAwLjE5MDAwMF0g
IFs8ZmZmZmZmZmY4MTA1YzU0Zj5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4YjAvMHhkZQpb
ICAgIDAuMTkwMDAwXSAgWzxmZmZmZmZmZjgxMGNhOWQ3Pl0gPyBfX2ZyZWVfaXJxKzB4MTBi
LzB4M2MzClsgICAgMC4xOTAwMDBdICBbPGZmZmZmZmZmODEzMTYxMDA+XSA/IGFjcGlfbWFw
X3ZhZGRyX2xvb2t1cCsweDMwLzB4NDMKWyAgICAwLjE5MDAwMF0gIFs8ZmZmZmZmZmY4MTA1
YzY2Mz5dIHdhcm5fc2xvd3BhdGhfZm10KzB4NWEvMHg2MwpbICAgIDAuMTkwMDAwXSAgWzxm
ZmZmZmZmZjgxNjEyOGVlPl0gPyBfcmF3X3NwaW5fbG9ja19pcnFzYXZlKzB4ZDIvMHhlYgpb
ICAgIDAuMTkwMDAwXSAgWzxmZmZmZmZmZjgxMGNhOWEyPl0gPyBfX2ZyZWVfaXJxKzB4ZDYv
MHgzYzMKWyAgICAwLjE5MDAwMF0gIFs8ZmZmZmZmZmY4MTBjYTlkNz5dIF9fZnJlZV9pcnEr
MHgxMGIvMHgzYzMKWyAgICAwLjE5MDAwMF0gIFs8ZmZmZmZmZmY4MTMxNjE2YT5dID8gYWNw
aV9vc19kcm9wX21hcF9yZWYrMHg1Ny8weDU3ClsgICAgMC4xOTAwMDBdICBbPGZmZmZmZmZm
ODEzMTYxNmE+XSA/IGFjcGlfb3NfZHJvcF9tYXBfcmVmKzB4NTcvMHg1NwpbICAgIDAuMTkw
MDAwXSAgWzxmZmZmZmZmZjgxMGNhZWM5Pl0gZnJlZV9pcnErMHgxNjcvMHgxOTcKWyAgICAw
LjE5MDAwMF0gIFs8ZmZmZmZmZmY4MjA3MzJkYj5dID8gYWNwaV9zbGVlcF9pbml0KzB4MTU0
LzB4MTU0ClsgICAgMC4xOTAwMDBdICBbPGZmZmZmZmZmODEzMTZiZGQ+XSBhY3BpX29zX3Jl
bW92ZV9pbnRlcnJ1cHRfaGFuZGxlcisweDMzLzB4NDkKWyAgICAwLjE5MDAwMF0gIFs8ZmZm
ZmZmZmY4MTMzMDY2Mz5dIGFjcGlfZXZfcmVtb3ZlX2FsbF9zY2lfaGFuZGxlcnMrMHgyNi8w
eDllClsgICAgMC4xOTAwMDBdICBbPGZmZmZmZmZmODIwNzMyZGI+XSA/IGFjcGlfc2xlZXBf
aW5pdCsweDE1NC8weDE1NApbICAgIDAuMTkwMDAwXSAgWzxmZmZmZmZmZjgxMzJmM2Y3Pl0g
YWNwaV9ldl90ZXJtaW5hdGUrMHhjYy8weDE1ZgpbICAgIDAuMTkwMDAwXSAgWzxmZmZmZmZm
ZjgyMDczMmRiPl0gPyBhY3BpX3NsZWVwX2luaXQrMHgxNTQvMHgxNTQKWyAgICAwLjE5MDAw
MF0gIFs8ZmZmZmZmZmY4MTM0ZTY5Zj5dIGFjcGlfdXRfc3Vic3lzdGVtX3NodXRkb3duKzB4
MWEvMHhmNQpbICAgIDAuMTkwMDAwXSAgWzxmZmZmZmZmZjgyMDczMmRiPl0gPyBhY3BpX3Ns
ZWVwX2luaXQrMHgxNTQvMHgxNTQKWyAgICAwLjE5MDAwMF0gIFs8ZmZmZmZmZmY4MjA3NTMx
OD5dIGFjcGlfdGVybWluYXRlKzB4NTYvMHg3NwpbICAgIDAuMTkwMDAwXSAgWzxmZmZmZmZm
ZjgyMDczNjc2Pl0gYWNwaV9pbml0KzB4MzliLzB4M2MzClsgICAgMC4xOTAwMDBdICBbPGZm
ZmZmZmZmODEwMDAzNjc+XSA/IGRvX29uZV9pbml0Y2FsbCsweGQyLzB4MmMxClsgICAgMC4x
OTAwMDBdICBbPGZmZmZmZmZmODExYzEyMGU+XSA/IGtmcmVlKzB4ZTgvMHgxN2IKWyAgICAw
LjE5MDAwMF0gIFs8ZmZmZmZmZmY4MjA3MzJkYj5dID8gYWNwaV9zbGVlcF9pbml0KzB4MTU0
LzB4MTU0ClsgICAgMC4xOTAwMDBdICBbPGZmZmZmZmZmODIwNzMyZGI+XSA/IGFjcGlfc2xl
ZXBfaW5pdCsweDE1NC8weDE1NApbICAgIDAuMTkwMDAwXSAgWzxmZmZmZmZmZjgxMDAwNDE4
Pl0gZG9fb25lX2luaXRjYWxsKzB4MTgzLzB4MmMxClsgICAgMC4xOTAwMDBdICBbPGZmZmZm
ZmZmODEwODZkZjU+XSA/IHBhcmFtZXErMHgyOS8weDMyClsgICAgMC4xOTAwMDBdICBbPGZm
ZmZmZmZmODEwODcwOTg+XSA/IHBhcnNlX2FyZ3MrMHgyOWEvMHgzZTgKWyAgICAwLjE5MDAw
MF0gIFs8ZmZmZmZmZmY4MjAzNjgzMz5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MWU5LzB4
MmRjClsgICAgMC4xOTAwMDBdICBbPGZmZmZmZmZmODIwMzU5NzY+XSA/IGRvX2Vhcmx5X3Bh
cmFtKzB4ZDcvMHhkNwpbICAgIDAuMTkwMDAwXSAgWzxmZmZmZmZmZjgxNWZhYTFhPl0gPyBy
ZXN0X2luaXQrMHgxNWUvMHgxNWUKWyAgICAwLjE5MDAwMF0gIFs8ZmZmZmZmZmY4MTVmYWEy
Zj5dIGtlcm5lbF9pbml0KzB4MTUvMHgxN2EKWyAgICAwLjE5MDAwMF0gIFs8ZmZmZmZmZmY4
MTYxNDFiYz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIwClsgICAgMC4xOTAwMDBdICBbPGZm
ZmZmZmZmODE1ZmFhMWE+XSA/IHJlc3RfaW5pdCsweDE1ZS8weDE1ZQpbICAgIDAuMTkwMDAw
XSAtLS1bIGVuZCB0cmFjZSBhNTVjNTYyMmQ5MmFiZmJhIF0tLS0KWyAgICAwLjIxMTQ0MF0g
dmdhYXJiOiBsb2FkZWQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDUxNzE5NDkv
NDE1MWZhNmFkYzY1ZGExNDY3M2VjZTYyM2JiYjJhY2M2OTM2ZjhiZS9kbWVzZy15b2N0by1m
MS0zNToyMDE0MDUxNzE5NTc0MTp4ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDUxNzE5NDk6My4x
NS4wLXJjNS1uZXh0LTIwMTQwNTE2OjQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjEt
MDUxNzE5NDkvNDE1MWZhNmFkYzY1ZGExNDY3M2VjZTYyM2JiYjJhY2M2OTM2ZjhiZS9kbWVz
Zy15b2N0by1mMy0xMjY6MjAxNDA1MTcxOTU3Mjk6eDg2XzY0LXJhbmRjb25maWctaXYxLTA1
MTcxOTQ5OjMuMTUuMC1yYzUtbmV4dC0yMDE0MDUxNjo0Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaXYxLTA1MTcxOTQ5LzQxNTFmYTZhZGM2NWRhMTQ2NzNlY2U2MjNiYmIyYWNjNjkz
NmY4YmUvZG1lc2cteW9jdG8tZjEtMTA0OjIwMTQwNTE3MTk1NzQ0Ong4Nl82NC1yYW5kY29u
ZmlnLWl2MS0wNTE3MTk0OTozLjE1LjAtcmM1LW5leHQtMjAxNDA1MTY6NAova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0OS80MTUxZmE2YWRjNjVkYTE0NjczZWNlNjIz
YmJiMmFjYzY5MzZmOGJlL2RtZXNnLXlvY3RvLWYxLTEwMzoyMDE0MDUxNzE5NTc0NDp4ODZf
NjQtcmFuZGNvbmZpZy1pdjEtMDUxNzE5NDk6My4xNS4wLXJjNS1uZXh0LTIwMTQwNTE2OjQK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDUxNzE5NDkvNDE1MWZhNmFkYzY1ZGEx
NDY3M2VjZTYyM2JiYjJhY2M2OTM2ZjhiZS9kbWVzZy1xdWFudGFsLWYxLTEyMzoyMDE0MDUx
NzE5NTc0Mzp4ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDUxNzE5NDk6My4xNS4wLXJjNS1uZXh0
LTIwMTQwNTE2OjQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDUxNzE5NDkvNDE1
MWZhNmFkYzY1ZGExNDY3M2VjZTYyM2JiYjJhY2M2OTM2ZjhiZS9kbWVzZy15b2N0by1mMi01
OjIwMTQwNTE3MTk1NzUyOng4Nl82NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0OTozLjE1LjAt
cmM1LW5leHQtMjAxNDA1MTY6NAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNTE3
MTk0OS80MTUxZmE2YWRjNjVkYTE0NjczZWNlNjIzYmJiMmFjYzY5MzZmOGJlL2RtZXNnLXlv
Y3RvLWYxLTExMToyMDE0MDUxNzE5NTMyMTp4ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDUxNzE5
NDk6My4xNS4wLXJjNS1uZXh0LTIwMTQwNTE2OjQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1pdjEtMDUxNzE5NDkvNDE1MWZhNmFkYzY1ZGExNDY3M2VjZTYyM2JiYjJhY2M2OTM2Zjhi
ZS9kbWVzZy1xdWFudGFsLWYyLTQ0OjIwMTQwNTE3MTk1MzM0Ong4Nl82NC1yYW5kY29uZmln
LWl2MS0wNTE3MTk0OTozLjE1LjAtcmM1LW5leHQtMjAxNDA1MTY6NAova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0OS80MTUxZmE2YWRjNjVkYTE0NjczZWNlNjIzYmJi
MmFjYzY5MzZmOGJlL2RtZXNnLXF1YW50YWwtZjMtNzc6MjAxNDA1MTcxOTU3Mjk6eDg2XzY0
LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5OjMuMTUuMC1yYzUtbmV4dC0yMDE0MDUxNjo0Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5LzQxNTFmYTZhZGM2NWRhMTQ2
NzNlY2U2MjNiYmIyYWNjNjkzNmY4YmUvZG1lc2cteW9jdG8tZjEtMTI3OjIwMTQwNTE3MTk1
NzQ0Ong4Nl82NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0OTozLjE1LjAtcmM1LW5leHQtMjAx
NDA1MTY6NAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0OS80MTUxZmE2
YWRjNjVkYTE0NjczZWNlNjIzYmJiMmFjYzY5MzZmOGJlL2RtZXNnLXF1YW50YWwtZjEtOTg6
MjAxNDA1MTcxOTUzMTI6eDg2XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5OjMuMTUuMC1y
YzUtbmV4dC0yMDE0MDUxNjo0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA1MTcx
OTQ5LzQxNTFmYTZhZGM2NWRhMTQ2NzNlY2U2MjNiYmIyYWNjNjkzNmY4YmUvZG1lc2ctcXVh
bnRhbC1mNC0xOjIwMTQwNTE3MTk1NzQ3Ong4Nl82NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0
OTozLjE1LjAtcmM1LW5leHQtMjAxNDA1MTY6NAova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWl2MS0wNTE3MTk0OS80MTUxZmE2YWRjNjVkYTE0NjczZWNlNjIzYmJiMmFjYzY5MzZmOGJl
L2RtZXNnLXlvY3RvLWYxLTc2OjIwMTQwNTE3MTk1NzQxOng4Nl82NC1yYW5kY29uZmlnLWl2
MS0wNTE3MTk0OTozLjE1LjAtcmM1LW5leHQtMjAxNDA1MTY6NAowOjEzOjEzIGFsbF9nb29k
OmJhZDphbGxfYmFkIGJvb3RzCgpIRUFEIGlzIG5vdyBhdCA0MTUxZmE2IEFkZCBsaW51eC1u
ZXh0IHNwZWNpZmljIGZpbGVzIGZvciAyMDE0MDUxNgoKPT09PT09PT09IHVwc3RyZWFtID09
PT09PT09PQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA0MTUxZmE2Li4uIEFkZCBsaW51
eC1uZXh0IHNwZWNpZmljIGZpbGVzIGZvciAyMDE0MDUxNgpIRUFEIGlzIG5vdyBhdCAxNDE4
NmZlLi4uIE1lcmdlIHRhZyAnbG9ja3MtdjMuMTUtNCcgb2YgZ2l0Oi8vZ2l0LnNhbWJhLm9y
Zy9qbGF5dG9uL2xpbnV4CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZf
NjQtcmFuZGNvbmZpZy1pdjEtMDUxNzE5NDkvbGludXM6bWFzdGVyOjE0MTg2ZmVhMGNiMDZi
YzQzMTgxY2UyMzllZmUwZGY2ZjFhZjI2MGE6YmlzZWN0LWxpbnV4OQoKMjAxNC0wNS0xNy0y
MTowMDo1OCAxNDE4NmZlYTBjYjA2YmM0MzE4MWNlMjM5ZWZlMGRmNmYxYWYyNjBhIGNvbXBp
bGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4
Nl82NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0OS0xNDE4NmZlYTBjYjA2YmM0MzE4MWNlMjM5
ZWZlMGRmNmYxYWYyNjBhCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1pdjEtMDUxNzE5NDkvMTQxODZmZWEwY2IwNmJjNDMxODFjZTIzOWVmZTBkZjZm
MWFmMjYwYQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQt
cXVldWUveDg2XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5LTE0MTg2ZmVhMGNiMDZiYzQz
MTgxY2UyMzllZmUwZGY2ZjFhZjI2MGEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDUxNzE5NDkt
MTQxODZmZWEwY2IwNmJjNDMxODFjZTIzOWVmZTBkZjZmMWFmMjYwYQprZXJuZWw6IC9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5LzE0MTg2ZmVhMGNiMDZiYzQzMTgx
Y2UyMzllZmUwZGY2ZjFhZjI2MGEvdm1saW51ei0zLjE1LjAtcmM1LTAwMDc3LWcxNDE4NmZl
CgoyMDE0LTA1LTE3LTIxOjAyOjU5IGRldGVjdGluZyBib290IHN0YXRlIC4uCTIJMjgJNjAg
U1VDQ0VTUwoKCj09PT09PT09PSBsaW51eC1uZXh0ID09PT09PT09PQpQcmV2aW91cyBIRUFE
IHBvc2l0aW9uIHdhcyAxNDE4NmZlLi4uIE1lcmdlIHRhZyAnbG9ja3MtdjMuMTUtNCcgb2Yg
Z2l0Oi8vZ2l0LnNhbWJhLm9yZy9qbGF5dG9uL2xpbnV4CkhFQUQgaXMgbm93IGF0IDQxNTFm
YTYuLi4gQWRkIGxpbnV4LW5leHQgc3BlY2lmaWMgZmlsZXMgZm9yIDIwMTQwNTE2CmxzIC1h
IC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDUx
NzE5NDkvbmV4dDptYXN0ZXI6NDE1MWZhNmFkYzY1ZGExNDY3M2VjZTYyM2JiYjJhY2M2OTM2
ZjhiZTpiaXNlY3QtbGludXg5CiBURVNUIEZBSUxVUkUKWyAgICAwLjE4MzIzMV0gQUNQSTog
QWRkZWQgX09TSShQcm9jZXNzb3IgQWdncmVnYXRvciBEZXZpY2UpClsgICAgMC4xODQxMzJd
IEFDUEk6IFVuYWJsZSB0byBzdGFydCB0aGUgQUNQSSBJbnRlcnByZXRlcgpbICAgIDAuMTg0
NjE3XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAwLjE4NTA2
MV0gV0FSTklORzogQ1BVOiAwIFBJRDogMSBhdCAva2J1aWxkL3NyYy9zbW9rZS9rZXJuZWwv
aXJxL21hbmFnZS5jOjEzMjUgX19mcmVlX2lycSsweDEwYi8weDNjMygpClsgICAgMC4xODU5
MzFdIFRyeWluZyB0byBmcmVlIGFscmVhZHktZnJlZSBJUlEgOQpbICAgIDAuMTg2MzQ2XSBN
b2R1bGVzIGxpbmtlZCBpbjoKWyAgICAwLjE4NjY1OV0gQ1BVOiAwIFBJRDogMSBDb21tOiBz
d2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xNS4wLXJjNS1uZXh0LTIwMTQwNTE2ICM0ClsgICAg
MC4xODczNTNdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAx
LzIwMTEKWyAgICAwLjE4Nzg4NF0gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAxMTUwYmM5
MCBmZmZmZmZmZjgxNjA2MmViIGZmZmY4ODAwMTE1MGJjZDgKWyAgICAwLjE4ODY0MV0gIGZm
ZmY4ODAwMTE1MGJjYzggZmZmZmZmZmY4MTA1YzU0ZiBmZmZmZmZmZjgxMGNhOWQ3IDAwMDAw
MDAwMDAwMDAwMDAKWyAgICAwLjE4OTM5OV0gIGZmZmY4ODAwMDAwOTE0YTAgMDAwMDAwMDAw
MDAwMDAwOSBmZmZmZmZmZjgxMzE2MTAwIGZmZmY4ODAwMTE1MGJkMjgKWyAgICAwLjE5MDAw
MF0gQ2FsbCBUcmFjZToKWyAgICAwLjE5MDAwMF0gIFs8ZmZmZmZmZmY4MTYwNjJlYj5dIGR1
bXBfc3RhY2srMHhhMS8weDEyNApbICAgIDAuMTkwMDAwXSAgWzxmZmZmZmZmZjgxMDVjNTRm
Pl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHhiMC8weGRlClsgICAgMC4xOTAwMDBdICBbPGZm
ZmZmZmZmODEwY2E5ZDc+XSA/IF9fZnJlZV9pcnErMHgxMGIvMHgzYzMKWyAgICAwLjE5MDAw
MF0gIFs8ZmZmZmZmZmY4MTMxNjEwMD5dID8gYWNwaV9tYXBfdmFkZHJfbG9va3VwKzB4MzAv
MHg0MwpbICAgIDAuMTkwMDAwXSAgWzxmZmZmZmZmZjgxMDVjNjYzPl0gd2Fybl9zbG93cGF0
aF9mbXQrMHg1YS8weDYzClsgICAgMC4xOTAwMDBdICBbPGZmZmZmZmZmODE2MTI4ZWU+XSA/
IF9yYXdfc3Bpbl9sb2NrX2lycXNhdmUrMHhkMi8weGViClsgICAgMC4xOTAwMDBdICBbPGZm
ZmZmZmZmODEwY2E5YTI+XSA/IF9fZnJlZV9pcnErMHhkNi8weDNjMwpbICAgIDAuMTkwMDAw
XSAgWzxmZmZmZmZmZjgxMGNhOWQ3Pl0gX19mcmVlX2lycSsweDEwYi8weDNjMwpbICAgIDAu
MTkwMDAwXSAgWzxmZmZmZmZmZjgxMzE2MTZhPl0gPyBhY3BpX29zX2Ryb3BfbWFwX3JlZisw
eDU3LzB4NTcKWyAgICAwLjE5MDAwMF0gIFs8ZmZmZmZmZmY4MTMxNjE2YT5dID8gYWNwaV9v
c19kcm9wX21hcF9yZWYrMHg1Ny8weDU3ClsgICAgMC4xOTAwMDBdICBbPGZmZmZmZmZmODEw
Y2FlYzk+XSBmcmVlX2lycSsweDE2Ny8weDE5NwpbICAgIDAuMTkwMDAwXSAgWzxmZmZmZmZm
ZjgyMDczMmRiPl0gPyBhY3BpX3NsZWVwX2luaXQrMHgxNTQvMHgxNTQKWyAgICAwLjE5MDAw
MF0gIFs8ZmZmZmZmZmY4MTMxNmJkZD5dIGFjcGlfb3NfcmVtb3ZlX2ludGVycnVwdF9oYW5k
bGVyKzB4MzMvMHg0OQpbICAgIDAuMTkwMDAwXSAgWzxmZmZmZmZmZjgxMzMwNjYzPl0gYWNw
aV9ldl9yZW1vdmVfYWxsX3NjaV9oYW5kbGVycysweDI2LzB4OWUKWyAgICAwLjE5MDAwMF0g
IFs8ZmZmZmZmZmY4MjA3MzJkYj5dID8gYWNwaV9zbGVlcF9pbml0KzB4MTU0LzB4MTU0Clsg
ICAgMC4xOTAwMDBdICBbPGZmZmZmZmZmODEzMmYzZjc+XSBhY3BpX2V2X3Rlcm1pbmF0ZSsw
eGNjLzB4MTVmClsgICAgMC4xOTAwMDBdICBbPGZmZmZmZmZmODIwNzMyZGI+XSA/IGFjcGlf
c2xlZXBfaW5pdCsweDE1NC8weDE1NApbICAgIDAuMTkwMDAwXSAgWzxmZmZmZmZmZjgxMzRl
NjlmPl0gYWNwaV91dF9zdWJzeXN0ZW1fc2h1dGRvd24rMHgxYS8weGY1ClsgICAgMC4xOTAw
MDBdICBbPGZmZmZmZmZmODIwNzMyZGI+XSA/IGFjcGlfc2xlZXBfaW5pdCsweDE1NC8weDE1
NApbICAgIDAuMTkwMDAwXSAgWzxmZmZmZmZmZjgyMDc1MzE4Pl0gYWNwaV90ZXJtaW5hdGUr
MHg1Ni8weDc3ClsgICAgMC4xOTAwMDBdICBbPGZmZmZmZmZmODIwNzM2NzY+XSBhY3BpX2lu
aXQrMHgzOWIvMHgzYzMKWyAgICAwLjE5MDAwMF0gIFs8ZmZmZmZmZmY4MTAwMDM2Nz5dID8g
ZG9fb25lX2luaXRjYWxsKzB4ZDIvMHgyYzEKWyAgICAwLjE5MDAwMF0gIFs8ZmZmZmZmZmY4
MTFjMTIwZT5dID8ga2ZyZWUrMHhlOC8weDE3YgpbICAgIDAuMTkwMDAwXSAgWzxmZmZmZmZm
ZjgyMDczMmRiPl0gPyBhY3BpX3NsZWVwX2luaXQrMHgxNTQvMHgxNTQKWyAgICAwLjE5MDAw
MF0gIFs8ZmZmZmZmZmY4MjA3MzJkYj5dID8gYWNwaV9zbGVlcF9pbml0KzB4MTU0LzB4MTU0
ClsgICAgMC4xOTAwMDBdICBbPGZmZmZmZmZmODEwMDA0MTg+XSBkb19vbmVfaW5pdGNhbGwr
MHgxODMvMHgyYzEKWyAgICAwLjE5MDAwMF0gIFs8ZmZmZmZmZmY4MTA4NmRmNT5dID8gcGFy
YW1lcSsweDI5LzB4MzIKWyAgICAwLjE5MDAwMF0gIFs8ZmZmZmZmZmY4MTA4NzA5OD5dID8g
cGFyc2VfYXJncysweDI5YS8weDNlOApbICAgIDAuMTkwMDAwXSAgWzxmZmZmZmZmZjgyMDM2
ODMzPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgxZTkvMHgyZGMKWyAgICAwLjE5MDAwMF0g
IFs8ZmZmZmZmZmY4MjAzNTk3Nj5dID8gZG9fZWFybHlfcGFyYW0rMHhkNy8weGQ3ClsgICAg
MC4xOTAwMDBdICBbPGZmZmZmZmZmODE1ZmFhMWE+XSA/IHJlc3RfaW5pdCsweDE1ZS8weDE1
ZQpbICAgIDAuMTkwMDAwXSAgWzxmZmZmZmZmZjgxNWZhYTJmPl0ga2VybmVsX2luaXQrMHgx
NS8weDE3YQpbICAgIDAuMTkwMDAwXSAgWzxmZmZmZmZmZjgxNjE0MWJjPl0gcmV0X2Zyb21f
Zm9yaysweDdjLzB4YjAKWyAgICAwLjE5MDAwMF0gIFs8ZmZmZmZmZmY4MTVmYWExYT5dID8g
cmVzdF9pbml0KzB4MTVlLzB4MTVlClsgICAgMC4xOTAwMDBdIC0tLVsgZW5kIHRyYWNlIGE1
NWM1NjIyZDkyYWJmYmEgXS0tLQpbICAgIDAuMjExNDQwXSB2Z2FhcmI6IGxvYWRlZAova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0OS80MTUxZmE2YWRjNjVkYTE0Njcz
ZWNlNjIzYmJiMmFjYzY5MzZmOGJlL2RtZXNnLXlvY3RvLWYxLTM1OjIwMTQwNTE3MTk1NzQx
Ong4Nl82NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0OTozLjE1LjAtcmM1LW5leHQtMjAxNDA1
MTY6NAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0OS80MTUxZmE2YWRj
NjVkYTE0NjczZWNlNjIzYmJiMmFjYzY5MzZmOGJlL2RtZXNnLXlvY3RvLWYzLTEyNjoyMDE0
MDUxNzE5NTcyOTp4ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDUxNzE5NDk6My4xNS4wLXJjNS1u
ZXh0LTIwMTQwNTE2OjQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDUxNzE5NDkv
NDE1MWZhNmFkYzY1ZGExNDY3M2VjZTYyM2JiYjJhY2M2OTM2ZjhiZS9kbWVzZy15b2N0by1m
MS0xMDQ6MjAxNDA1MTcxOTU3NDQ6eDg2XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5OjMu
MTUuMC1yYzUtbmV4dC0yMDE0MDUxNjo0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYx
LTA1MTcxOTQ5LzQxNTFmYTZhZGM2NWRhMTQ2NzNlY2U2MjNiYmIyYWNjNjkzNmY4YmUvZG1l
c2cteW9jdG8tZjEtMTAzOjIwMTQwNTE3MTk1NzQ0Ong4Nl82NC1yYW5kY29uZmlnLWl2MS0w
NTE3MTk0OTozLjE1LjAtcmM1LW5leHQtMjAxNDA1MTY6NAova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWl2MS0wNTE3MTk0OS80MTUxZmE2YWRjNjVkYTE0NjczZWNlNjIzYmJiMmFjYzY5
MzZmOGJlL2RtZXNnLXF1YW50YWwtZjEtMTIzOjIwMTQwNTE3MTk1NzQzOng4Nl82NC1yYW5k
Y29uZmlnLWl2MS0wNTE3MTk0OTozLjE1LjAtcmM1LW5leHQtMjAxNDA1MTY6NAova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0OS80MTUxZmE2YWRjNjVkYTE0NjczZWNl
NjIzYmJiMmFjYzY5MzZmOGJlL2RtZXNnLXlvY3RvLWYyLTU6MjAxNDA1MTcxOTU3NTI6eDg2
XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5OjMuMTUuMC1yYzUtbmV4dC0yMDE0MDUxNjo0
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5LzQxNTFmYTZhZGM2NWRh
MTQ2NzNlY2U2MjNiYmIyYWNjNjkzNmY4YmUvZG1lc2cteW9jdG8tZjEtMTExOjIwMTQwNTE3
MTk1MzIxOng4Nl82NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0OTozLjE1LjAtcmM1LW5leHQt
MjAxNDA1MTY6NAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWl2MS0wNTE3MTk0OS80MTUx
ZmE2YWRjNjVkYTE0NjczZWNlNjIzYmJiMmFjYzY5MzZmOGJlL2RtZXNnLXF1YW50YWwtZjIt
NDQ6MjAxNDA1MTcxOTUzMzQ6eDg2XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5OjMuMTUu
MC1yYzUtbmV4dC0yMDE0MDUxNjo0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA1
MTcxOTQ5LzQxNTFmYTZhZGM2NWRhMTQ2NzNlY2U2MjNiYmIyYWNjNjkzNmY4YmUvZG1lc2ct
cXVhbnRhbC1mMy03NzoyMDE0MDUxNzE5NTcyOTp4ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDUx
NzE5NDk6My4xNS4wLXJjNS1uZXh0LTIwMTQwNTE2OjQKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1pdjEtMDUxNzE5NDkvNDE1MWZhNmFkYzY1ZGExNDY3M2VjZTYyM2JiYjJhY2M2OTM2
ZjhiZS9kbWVzZy15b2N0by1mMS0xMjc6MjAxNDA1MTcxOTU3NDQ6eDg2XzY0LXJhbmRjb25m
aWctaXYxLTA1MTcxOTQ5OjMuMTUuMC1yYzUtbmV4dC0yMDE0MDUxNjo0Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5LzQxNTFmYTZhZGM2NWRhMTQ2NzNlY2U2MjNi
YmIyYWNjNjkzNmY4YmUvZG1lc2ctcXVhbnRhbC1mMS05ODoyMDE0MDUxNzE5NTMxMjp4ODZf
NjQtcmFuZGNvbmZpZy1pdjEtMDUxNzE5NDk6My4xNS4wLXJjNS1uZXh0LTIwMTQwNTE2OjQK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1pdjEtMDUxNzE5NDkvNDE1MWZhNmFkYzY1ZGEx
NDY3M2VjZTYyM2JiYjJhY2M2OTM2ZjhiZS9kbWVzZy1xdWFudGFsLWY0LTE6MjAxNDA1MTcx
OTU3NDc6eDg2XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5OjMuMTUuMC1yYzUtbmV4dC0y
MDE0MDUxNjo0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5LzQxNTFm
YTZhZGM2NWRhMTQ2NzNlY2U2MjNiYmIyYWNjNjkzNmY4YmUvZG1lc2cteW9jdG8tZjEtNzY6
MjAxNDA1MTcxOTU3NDE6eDg2XzY0LXJhbmRjb25maWctaXYxLTA1MTcxOTQ5OjMuMTUuMC1y
YzUtbmV4dC0yMDE0MDUxNjo0CjA6MTM6MTMgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMK
Cg==

--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.15.0-rc5-06386-g64acc05"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.15.0-rc5 Kernel Configuration
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
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
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
# CONFIG_KERNEL_LZO is not set
CONFIG_KERNEL_LZ4=y
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=y
CONFIG_FHANDLE=y
CONFIG_USELIB=y
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
# CONFIG_AUDITSYSCALL is not set

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
# CONFIG_NO_HZ_FULL is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

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
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_RCU_USER_QS=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_RCU_FAST_NO_HZ is not set
CONFIG_TREE_RCU_TRACE=y
# CONFIG_RCU_BOOST is not set
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
CONFIG_RCU_NOCB_CPU_ZERO=y
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_ARCH_USES_NUMA_PROT_NONE=y
# CONFIG_NUMA_BALANCING_DEFAULT_ENABLED is not set
CONFIG_NUMA_BALANCING=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
CONFIG_CGROUP_HUGETLB=y
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
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
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_SGETMASK_SYSCALL=y
# CONFIG_SYSFS_SYSCALL is not set
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
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_UPROBES=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
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
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
# CONFIG_GCOV_FORMAT_3_4 is not set
CONFIG_GCOV_FORMAT_4_7=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
CONFIG_MODULE_SIG_FORCE=y
CONFIG_MODULE_SIG_ALL=y
CONFIG_MODULE_SIG_SHA1=y
# CONFIG_MODULE_SIG_SHA224 is not set
# CONFIG_MODULE_SIG_SHA256 is not set
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha1"
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
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
# CONFIG_CPU_SUP_AMD is not set
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_I8K=m
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MOVABLE_NODE=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
CONFIG_DEBUG_HOTPLUG_CPU0=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

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
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

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
CONFIG_I7300_IDLE=y

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
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
# CONFIG_COREDUMP is not set
# CONFIG_IA32_EMULATION is not set
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set
CONFIG_NETFILTER_XTABLES=m
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
# CONFIG_BRIDGE_EBT_ARP is not set
CONFIG_BRIDGE_EBT_IP=m
# CONFIG_BRIDGE_EBT_LIMIT is not set
# CONFIG_BRIDGE_EBT_MARK is not set
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
# CONFIG_BRIDGE_EBT_DNAT is not set
CONFIG_BRIDGE_EBT_MARK_T=m
# CONFIG_BRIDGE_EBT_REDIRECT is not set
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
CONFIG_ATM=m
# CONFIG_ATM_LANE is not set
CONFIG_STP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=m
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=m
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_VLAN_8021Q_MVRP is not set
CONFIG_DECNET=m
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
CONFIG_ATALK=m
# CONFIG_DEV_APPLETALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=m
# CONFIG_PHONET is not set
CONFIG_IEEE802154=y
CONFIG_MAC802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
# CONFIG_NET_SCH_HTB is not set
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=m
# CONFIG_NET_SCH_NETEM is not set
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=y
CONFIG_NET_SCH_CHOKE=m
# CONFIG_NET_SCH_QFQ is not set
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=m
CONFIG_NET_SCH_FQ=y
# CONFIG_NET_SCH_HHF is not set
# CONFIG_NET_SCH_PIE is not set
CONFIG_NET_SCH_INGRESS=y
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=y
# CONFIG_NET_CLS_FW is not set
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=y
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_EMATCH_CANID=m
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
CONFIG_NET_ACT_GACT=m
# CONFIG_GACT_PROB is not set
CONFIG_NET_ACT_MIRRED=y
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=y
# CONFIG_NET_ACT_SKBEDIT is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_VSOCKETS=m
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=m
CONFIG_NET_MPLS_GSO=y
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_JIT=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=m
# CONFIG_AX25_DAMA_SLAVE is not set
CONFIG_NETROM=m
CONFIG_ROSE=m

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
# CONFIG_6PACK is not set
CONFIG_BPQETHER=m
# CONFIG_BAYCOM_SER_FDX is not set
# CONFIG_BAYCOM_SER_HDX is not set
CONFIG_YAM=m
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m

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
CONFIG_IRLAN=m
CONFIG_IRNET=y
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
CONFIG_KINGSUN_DONGLE=m
CONFIG_KSDAZZLE_DONGLE=y
# CONFIG_KS959_DONGLE is not set

#
# FIR device drivers
#
CONFIG_USB_IRDA=y
CONFIG_SIGMATEL_FIR=m
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=y
# CONFIG_SMC_IRCC_FIR is not set
# CONFIG_ALI_FIR is not set
# CONFIG_VLSI_FIR is not set
CONFIG_VIA_FIR=m
# CONFIG_MCS_FIR is not set
# CONFIG_SH_IRDA is not set
# CONFIG_BT is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=m
CONFIG_NL80211_TESTMODE=y
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
# CONFIG_CFG80211_REG_DEBUG is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_LIB80211=m
CONFIG_LIB80211_DEBUG=y
# CONFIG_MAC80211 is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=m
CONFIG_NET_9P_DEBUG=y
CONFIG_CAIF=m
# CONFIG_CAIF_DEBUG is not set
# CONFIG_CAIF_NETDEV is not set
# CONFIG_CAIF_USB is not set
CONFIG_NFC=m
CONFIG_NFC_DIGITAL=m
CONFIG_NFC_NCI=m
CONFIG_NFC_HCI=m
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
# CONFIG_NFC_PN533 is not set
CONFIG_NFC_SIM=m
# CONFIG_NFC_PORT100 is not set
CONFIG_NFC_PN544=m
# CONFIG_NFC_PN544_I2C is not set
# CONFIG_NFC_MICROREAD is not set
CONFIG_NFC_MRVL=m
CONFIG_NFC_MRVL_USB=m
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=y
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
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=m
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
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
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=m
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=m
CONFIG_DS1682=m
CONFIG_VMWARE_BALLOON=m
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
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=m
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
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
CONFIG_INTEL_MIC_CARD=m
# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
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
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
CONFIG_DUMMY=y
# CONFIG_EQUALIZER is not set
# CONFIG_IFB is not set
# CONFIG_NET_TEAM is not set
CONFIG_MACVLAN=y
CONFIG_MACVTAP=m
CONFIG_NETCONSOLE=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=y
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=m
# CONFIG_NLMON is not set
# CONFIG_ARCNET is not set
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#
# CONFIG_CAIF_TTY is not set
CONFIG_CAIF_SPI_SLAVE=m
# CONFIG_CAIF_SPI_SYNC is not set
# CONFIG_CAIF_HSI is not set
# CONFIG_CAIF_VIRTIO is not set
CONFIG_VHOST_NET=m
CONFIG_VHOST_RING=m
CONFIG_VHOST=m

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
CONFIG_NET_DSA_MV88E6060=m
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_ALX is not set
CONFIG_NET_CADENCE=y
CONFIG_ARM_AT91_ETHER=m
CONFIG_MACB=y
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
# CONFIG_CX_ECAT is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
# CONFIG_NET_VENDOR_INTEL is not set
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_MLX5_CORE is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_8390=y
# CONFIG_NE2K_PCI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
# CONFIG_ETHOC is not set
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R8169 is not set
CONFIG_SH_ETH=m
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_SAMSUNG=y
CONFIG_SXGBE_ETH=y
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_STMICRO=y
CONFIG_STMMAC_ETH=y
# CONFIG_STMMAC_PLATFORM is not set
# CONFIG_STMMAC_PCI is not set
# CONFIG_STMMAC_DEBUG_FS is not set
CONFIG_STMMAC_DA=y
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_NET_VENDOR_WIZNET is not set
# CONFIG_FDDI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=m
# CONFIG_AMD_PHY is not set
CONFIG_MARVELL_PHY=y
# CONFIG_DAVICOM_PHY is not set
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=m
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM7XXX_PHY is not set
CONFIG_BCM87XX_PHY=m
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=m
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
CONFIG_LSI_ET1011C_PHY=m
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=m
CONFIG_MDIO_GPIO=m
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_FILTER=y
# CONFIG_PPP_MPPE is not set
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPPOATM=m
# CONFIG_PPPOE is not set
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=m
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_RTL8152 is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=y
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=y
CONFIG_USB_NET_HUAWEI_CDC_NCM=y
# CONFIG_USB_NET_CDC_MBIM is not set
CONFIG_USB_NET_DM9601=y
# CONFIG_USB_NET_SR9700 is not set
CONFIG_USB_NET_SR9800=y
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=m
# CONFIG_USB_NET_GL620A is not set
CONFIG_USB_NET_NET1080=m
# CONFIG_USB_NET_PLUSB is not set
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
# CONFIG_USB_BELKIN is not set
# CONFIG_USB_ARMLINUX is not set
# CONFIG_USB_EPSON2888 is not set
# CONFIG_USB_KC2190 is not set
CONFIG_USB_NET_ZAURUS=m
# CONFIG_USB_NET_CX82310_ETH is not set
CONFIG_USB_NET_KALMIA=y
CONFIG_USB_NET_QMI_WWAN=y
# CONFIG_USB_HSO is not set
CONFIG_USB_NET_INT51X1=m
CONFIG_USB_IPHETH=m
# CONFIG_USB_SIERRA_NET is not set
# CONFIG_USB_VL600 is not set
CONFIG_WLAN=y
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
CONFIG_USB_ZD1201=m
CONFIG_USB_NET_RNDIS_WLAN=m
CONFIG_ATH_CARDS=m
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K_PCI is not set
CONFIG_ATH6KL=m
# CONFIG_ATH6KL_SDIO is not set
# CONFIG_ATH6KL_USB is not set
# CONFIG_ATH6KL_DEBUG is not set
# CONFIG_ATH6KL_TRACING is not set
# CONFIG_WIL6210 is not set
CONFIG_BRCMUTIL=m
CONFIG_BRCMFMAC=m
CONFIG_BRCMFMAC_SDIO=y
# CONFIG_BRCMFMAC_USB is not set
# CONFIG_BRCM_TRACING is not set
# CONFIG_BRCMDBG is not set
# CONFIG_HOSTAP is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_HERMES is not set
CONFIG_WL_TI=y
# CONFIG_MWIFIEX is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=m
CONFIG_WIMAX_I2400M_USB=m
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=y
CONFIG_HDLC_RAW=m
# CONFIG_HDLC_RAW_ETH is not set
CONFIG_HDLC_CISCO=m
CONFIG_HDLC_FR=y
# CONFIG_HDLC_PPP is not set

#
# X.25/LAPB support is disabled
#
# CONFIG_PCI200SYN is not set
# CONFIG_WANXL is not set
# CONFIG_PC300TOO is not set
# CONFIG_FARSYNC is not set
# CONFIG_DSCC4 is not set
# CONFIG_DLCI is not set
CONFIG_SBNI=y
# CONFIG_SBNI_MULTILINE is not set
# CONFIG_IEEE802154_DRIVERS is not set
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
CONFIG_ISDN_CAPI=y
# CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON is not set
# CONFIG_CAPI_TRACE is not set
CONFIG_ISDN_CAPI_CAPI20=y
# CONFIG_ISDN_CAPI_MIDDLEWARE is not set

#
# CAPI hardware drivers
#
# CONFIG_CAPI_AVM is not set
# CONFIG_CAPI_EICON is not set
# CONFIG_ISDN_DRV_GIGASET is not set
# CONFIG_MISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
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
# CONFIG_KEYBOARD_ST_KEYSCAN is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_SH_KEYSC is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_LEDS is not set
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_CYAPA=m
CONFIG_MOUSE_VSXXXAA=m
CONFIG_MOUSE_GPIO=m
CONFIG_MOUSE_SYNAPTICS_I2C=m
CONFIG_MOUSE_SYNAPTICS_USB=m
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=m
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=m
CONFIG_JOYSTICK_GRIP=m
# CONFIG_JOYSTICK_GRIP_MP is not set
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=m
# CONFIG_JOYSTICK_SIDEWINDER is not set
CONFIG_JOYSTICK_TMDC=m
CONFIG_JOYSTICK_IFORCE=m
CONFIG_JOYSTICK_IFORCE_USB=y
# CONFIG_JOYSTICK_IFORCE_232 is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
CONFIG_JOYSTICK_SPACEBALL=m
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_ZHENHUA=m
# CONFIG_JOYSTICK_AS5011 is not set
CONFIG_JOYSTICK_JOYDUMP=m
CONFIG_JOYSTICK_XPAD=m
# CONFIG_JOYSTICK_XPAD_FF is not set
CONFIG_JOYSTICK_XPAD_LEDS=y
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM80X_ONKEY=m
CONFIG_INPUT_AD714X=m
CONFIG_INPUT_AD714X_I2C=m
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_MMA8450=m
# CONFIG_INPUT_MPU3050 is not set
CONFIG_INPUT_APANEL=m
CONFIG_INPUT_GP2A=m
# CONFIG_INPUT_GPIO_BEEPER is not set
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=m
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=m
# CONFIG_INPUT_KXTJ9_POLLED_MODE is not set
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=m
# CONFIG_INPUT_RETU_PWRBUTTON is not set
CONFIG_INPUT_TWL4030_PWRBUTTON=m
# CONFIG_INPUT_TWL4030_VIBRA is not set
# CONFIG_INPUT_TWL6040_VIBRA is not set
CONFIG_INPUT_UINPUT=m
# CONFIG_INPUT_PCF50633_PMU is not set
# CONFIG_INPUT_PCF8574 is not set
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
CONFIG_INPUT_DA9052_ONKEY=m
CONFIG_INPUT_DA9055_ONKEY=m
# CONFIG_INPUT_WM831X_ON is not set
CONFIG_INPUT_ADXL34X=m
CONFIG_INPUT_ADXL34X_I2C=m
CONFIG_INPUT_IMS_PCU=m
CONFIG_INPUT_CMA3000=m
CONFIG_INPUT_CMA3000_I2C=m
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=m
CONFIG_SERIO_OLPC_APSP=m
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
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
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

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
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_ST_ASC is not set
# CONFIG_SERIAL_MEN_Z135 is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
CONFIG_IPMI_SI_PROBE_DEFAULTS=y
CONFIG_IPMI_WATCHDOG=m
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
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
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
# CONFIG_I2C_ALGOPCA is not set

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
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_EFM32=y
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_KEMPLD=m
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_RIIC=m
CONFIG_I2C_SH_MOBILE=m
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set
# CONFIG_I2C_RCAR is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_ROBOTFUZZ_OSIF=y
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=m
CONFIG_I2C_VIPERBOARD=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_SPMI=m
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
CONFIG_PPS_CLIENT_KTIMER=m
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
# CONFIG_DP83640_PHY is not set
CONFIG_PTP_1588_CLOCK_PCH=m
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_CLPS711X=m
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_F7188X=m
# CONFIG_GPIO_SCH311X is not set
CONFIG_GPIO_TS5500=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_LP3943=m
CONFIG_GPIO_MAX7300=y
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=m
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TWL4030=m
# CONFIG_GPIO_TWL6040 is not set
CONFIG_GPIO_WM831X=m
CONFIG_GPIO_WM8350=m
CONFIG_GPIO_WM8994=y
# CONFIG_GPIO_ADP5520 is not set
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y

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
CONFIG_GPIO_KEMPLD=m

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_PALMAS is not set
CONFIG_GPIO_TPS65910=y

#
# USB GPIO expanders:
#
CONFIG_GPIO_VIPERBOARD=m
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_MXC=m
# CONFIG_W1_MASTER_DS1WM is not set
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=m
CONFIG_W1_SLAVE_DS2423=m
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
# CONFIG_WM831X_BACKUP is not set
CONFIG_WM831X_POWER=m
# CONFIG_WM8350_POWER is not set
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=m
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=m
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9030=m
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_CHARGER_ISP1704=m
CONFIG_CHARGER_MAX8903=m
# CONFIG_CHARGER_TWL4030 is not set
CONFIG_CHARGER_LP8727=m
# CONFIG_CHARGER_GPIO is not set
CONFIG_CHARGER_BQ2415X=m
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_BQ24735=y
CONFIG_CHARGER_SMB347=m
CONFIG_CHARGER_TPS65090=y
CONFIG_BATTERY_GOLDFISH=m
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=m
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7410=m
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=m
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_DA9052_ADC is not set
# CONFIG_SENSORS_DA9055 is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_G762=m
CONFIG_SENSORS_GPIO_FAN=m
CONFIG_SENSORS_HIH6130=m
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4222=m
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=m
CONFIG_SENSORS_MAX6639=m
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
CONFIG_SENSORS_HTU21=m
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM73=m
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_NCT6775 is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
# CONFIG_SENSORS_PMBUS is not set
CONFIG_SENSORS_ADM1275=m
CONFIG_SENSORS_LM25066=m
# CONFIG_SENSORS_LTC2978 is not set
CONFIG_SENSORS_MAX16064=m
CONFIG_SENSORS_MAX34440=m
# CONFIG_SENSORS_MAX8688 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
CONFIG_SENSORS_ZL6100=m
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_ADC128D818=m
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP401=m
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=m
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_WM831X is not set
CONFIG_SENSORS_WM8350=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_THERMAL_EMULATION is not set
CONFIG_RCAR_THERMAL=m
# CONFIG_ACPI_INT3403_THERMAL is not set

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
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_HOST_SOC=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_BCM590XX=y
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=m
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=m
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_VIPERBOARD=m
CONFIG_MFD_RETU=m
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
CONFIG_PCF50633_GPIO=y
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RTSX_USB=m
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=m
CONFIG_MFD_LP3943=y
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_PALMAS=y
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65090=y
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS65218 is not set
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
CONFIG_MFD_TWL4030_AUDIO=y
CONFIG_TWL6040_CORE=y
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=m
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
# CONFIG_REGULATOR is not set
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
CONFIG_VIDEO_TUNER=m
CONFIG_V4L2_MEM2MEM_DEV=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_VMALLOC=m
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
CONFIG_RC_DECODERS=y
CONFIG_LIRC=m
CONFIG_IR_LIRC_CODEC=m
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
# CONFIG_IR_RC6_DECODER is not set
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_RC5_SZ_DECODER=m
# CONFIG_IR_SANYO_DECODER is not set
CONFIG_IR_SHARP_DECODER=m
# CONFIG_IR_MCE_KBD_DECODER is not set
CONFIG_RC_DEVICES=y
CONFIG_RC_ATI_REMOTE=m
# CONFIG_IR_ENE is not set
CONFIG_IR_IMON=m
# CONFIG_IR_MCEUSB is not set
# CONFIG_IR_ITE_CIR is not set
# CONFIG_IR_FINTEK is not set
# CONFIG_IR_NUVOTON is not set
CONFIG_IR_REDRAT3=m
CONFIG_IR_STREAMZAP=m
# CONFIG_IR_WINBOND_CIR is not set
CONFIG_IR_IGUANA=m
CONFIG_IR_TTUSBIR=m
# CONFIG_IR_IMG is not set
# CONFIG_RC_LOOPBACK is not set
CONFIG_IR_GPIO_CIR=m
CONFIG_MEDIA_USB_SUPPORT=y

#
# Webcam devices
#
# CONFIG_USB_VIDEO_CLASS is not set
CONFIG_USB_GSPCA=m
# CONFIG_USB_M5602 is not set
# CONFIG_USB_STV06XX is not set
# CONFIG_USB_GL860 is not set
CONFIG_USB_GSPCA_BENQ=m
CONFIG_USB_GSPCA_CONEX=m
CONFIG_USB_GSPCA_CPIA1=m
# CONFIG_USB_GSPCA_DTCS033 is not set
CONFIG_USB_GSPCA_ETOMS=m
# CONFIG_USB_GSPCA_FINEPIX is not set
CONFIG_USB_GSPCA_JEILINJ=m
CONFIG_USB_GSPCA_JL2005BCD=m
CONFIG_USB_GSPCA_KINECT=m
CONFIG_USB_GSPCA_KONICA=m
CONFIG_USB_GSPCA_MARS=m
CONFIG_USB_GSPCA_MR97310A=m
CONFIG_USB_GSPCA_NW80X=m
# CONFIG_USB_GSPCA_OV519 is not set
CONFIG_USB_GSPCA_OV534=m
# CONFIG_USB_GSPCA_OV534_9 is not set
CONFIG_USB_GSPCA_PAC207=m
CONFIG_USB_GSPCA_PAC7302=m
CONFIG_USB_GSPCA_PAC7311=m
CONFIG_USB_GSPCA_SE401=m
CONFIG_USB_GSPCA_SN9C2028=m
CONFIG_USB_GSPCA_SN9C20X=m
CONFIG_USB_GSPCA_SONIXB=m
CONFIG_USB_GSPCA_SONIXJ=m
CONFIG_USB_GSPCA_SPCA500=m
# CONFIG_USB_GSPCA_SPCA501 is not set
CONFIG_USB_GSPCA_SPCA505=m
CONFIG_USB_GSPCA_SPCA506=m
CONFIG_USB_GSPCA_SPCA508=m
# CONFIG_USB_GSPCA_SPCA561 is not set
CONFIG_USB_GSPCA_SPCA1528=m
CONFIG_USB_GSPCA_SQ905=m
CONFIG_USB_GSPCA_SQ905C=m
CONFIG_USB_GSPCA_SQ930X=m
# CONFIG_USB_GSPCA_STK014 is not set
# CONFIG_USB_GSPCA_STK1135 is not set
CONFIG_USB_GSPCA_STV0680=m
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
# CONFIG_USB_GSPCA_TOPRO is not set
# CONFIG_USB_GSPCA_TV8532 is not set
# CONFIG_USB_GSPCA_VC032X is not set
CONFIG_USB_GSPCA_VICAM=m
CONFIG_USB_GSPCA_XIRLINK_CIT=m
CONFIG_USB_GSPCA_ZC3XX=m
# CONFIG_USB_PWC is not set
CONFIG_VIDEO_CPIA2=m
CONFIG_USB_ZR364XX=m
# CONFIG_USB_STKWEBCAM is not set
# CONFIG_USB_S2255 is not set
# CONFIG_VIDEO_USBTV is not set

#
# Analog TV USB devices
#
CONFIG_VIDEO_PVRUSB2=m
CONFIG_VIDEO_PVRUSB2_SYSFS=y
CONFIG_VIDEO_PVRUSB2_DEBUGIFC=y
CONFIG_VIDEO_HDPVR=m
# CONFIG_VIDEO_USBVISION is not set
# CONFIG_VIDEO_STK1160_COMMON is not set

#
# Analog/digital TV USB devices
#
CONFIG_VIDEO_CX231XX=m
CONFIG_VIDEO_CX231XX_RC=y
CONFIG_VIDEO_TM6000=m

#
# Webcam, TV (analog/digital) USB devices
#
CONFIG_VIDEO_EM28XX=m
CONFIG_VIDEO_EM28XX_V4L2=m
CONFIG_VIDEO_EM28XX_RC=m
# CONFIG_MEDIA_PCI_SUPPORT is not set
CONFIG_V4L_PLATFORM_DRIVERS=y
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_VIDEO_SH_VOU is not set
CONFIG_SOC_CAMERA=m
# CONFIG_SOC_CAMERA_PLATFORM is not set
# CONFIG_VIDEO_RCAR_VIN is not set
CONFIG_V4L_MEM2MEM_DRIVERS=y
CONFIG_VIDEO_SH_VEU=m
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_RADIO_ADAPTERS is not set
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_CYPRESS_FIRMWARE=m

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
CONFIG_MEDIA_ATTACH=y
# CONFIG_VIDEO_IR_I2C is not set

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_TVAUDIO is not set
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9840=m
# CONFIG_VIDEO_TEA6415C is not set
CONFIG_VIDEO_TEA6420=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_TLV320AIC23B=m
# CONFIG_VIDEO_UDA1342 is not set
CONFIG_VIDEO_WM8775=m
# CONFIG_VIDEO_WM8739 is not set
CONFIG_VIDEO_VP27SMPX=m
CONFIG_VIDEO_SONY_BTF_MPX=m

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=m
CONFIG_VIDEO_ADV7183=m
CONFIG_VIDEO_BT819=m
CONFIG_VIDEO_BT856=m
CONFIG_VIDEO_BT866=m
# CONFIG_VIDEO_KS0127 is not set
# CONFIG_VIDEO_ML86V7667 is not set
CONFIG_VIDEO_SAA7110=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_SAA7191=m
# CONFIG_VIDEO_TVP514X is not set
CONFIG_VIDEO_TVP5150=m
# CONFIG_VIDEO_TVP7002 is not set
CONFIG_VIDEO_TW2804=m
# CONFIG_VIDEO_TW9903 is not set
CONFIG_VIDEO_TW9906=m
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_CX25840=m

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m
# CONFIG_VIDEO_SAA7185 is not set
# CONFIG_VIDEO_ADV7170 is not set
CONFIG_VIDEO_ADV7175=m
CONFIG_VIDEO_ADV7343=m
# CONFIG_VIDEO_ADV7393 is not set
# CONFIG_VIDEO_AK881X is not set
CONFIG_VIDEO_THS8200=m

#
# Camera sensor devices
#
CONFIG_VIDEO_OV7640=m
CONFIG_VIDEO_OV7670=m
# CONFIG_VIDEO_VS6624 is not set
# CONFIG_VIDEO_MT9V011 is not set
# CONFIG_VIDEO_SR030PC30 is not set

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m

#
# Audio/Video compression chips
#
# CONFIG_VIDEO_SAA6752HS is not set

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
CONFIG_SOC_CAMERA_IMX074=m
CONFIG_SOC_CAMERA_MT9M001=m
# CONFIG_SOC_CAMERA_MT9M111 is not set
CONFIG_SOC_CAMERA_MT9T031=m
# CONFIG_SOC_CAMERA_MT9T112 is not set
CONFIG_SOC_CAMERA_MT9V022=m
# CONFIG_SOC_CAMERA_OV2640 is not set
CONFIG_SOC_CAMERA_OV5642=m
CONFIG_SOC_CAMERA_OV6650=m
CONFIG_SOC_CAMERA_OV772X=m
# CONFIG_SOC_CAMERA_OV9640 is not set
CONFIG_SOC_CAMERA_OV9740=m
# CONFIG_SOC_CAMERA_RJ54N1 is not set
CONFIG_SOC_CAMERA_TW9910=m
CONFIG_MEDIA_TUNER=m

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=m
# CONFIG_MEDIA_TUNER_TDA8290 is not set
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
# CONFIG_MEDIA_TUNER_MT20XX is not set
# CONFIG_MEDIA_TUNER_MT2060 is not set
# CONFIG_MEDIA_TUNER_MT2063 is not set
# CONFIG_MEDIA_TUNER_MT2266 is not set
# CONFIG_MEDIA_TUNER_MT2131 is not set
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
# CONFIG_MEDIA_TUNER_MXL5005S is not set
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
# CONFIG_MEDIA_TUNER_MAX2165 is not set
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_MEDIA_TUNER_FC0011=m
# CONFIG_MEDIA_TUNER_FC0012 is not set
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=m
# CONFIG_MEDIA_TUNER_E4000 is not set
# CONFIG_MEDIA_TUNER_FC2580 is not set
CONFIG_MEDIA_TUNER_M88TS2022=m
CONFIG_MEDIA_TUNER_TUA9001=m
CONFIG_MEDIA_TUNER_SI2157=m
CONFIG_MEDIA_TUNER_IT913X=m
CONFIG_MEDIA_TUNER_R820T=m

#
# Customise DVB Frontends
#
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_V4L=m
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

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
CONFIG_DRM=y
CONFIG_DRM_USB=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
# CONFIG_DRM_I2C_SIL164 is not set
CONFIG_DRM_I2C_NXP_TDA998X=m
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
CONFIG_DRM_PTN3460=m

#
# Frame buffer Devices
#
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
CONFIG_FB_BIG_ENDIAN=y
# CONFIG_FB_LITTLE_ENDIAN is not set
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
CONFIG_FB_VESA=y
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
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
# CONFIG_FB_SMSCUFX is not set
CONFIG_FB_UDL=m
# CONFIG_FB_GOLDFISH is not set
CONFIG_FB_VIRTUAL=m
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=m
# CONFIG_FB_AUO_K1900 is not set
CONFIG_FB_AUO_K1901=m
CONFIG_FB_SIMPLE=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=m
CONFIG_BACKLIGHT_LM3533=m
CONFIG_BACKLIGHT_DA903X=m
CONFIG_BACKLIGHT_DA9052=m
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=m
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP5520=y
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_PCF50633=m
CONFIG_BACKLIGHT_AAT2870=y
CONFIG_BACKLIGHT_LM3630A=m
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_PANDORA=y
CONFIG_BACKLIGHT_GPIO=y
# CONFIG_BACKLIGHT_LV5207LP is not set
CONFIG_BACKLIGHT_BD6107=m
# CONFIG_VGASTATE is not set
CONFIG_HDMI=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
# CONFIG_LOGO_LINUX_CLUT224 is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=m
# CONFIG_HIDRAW is not set
CONFIG_UHID=m
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=m
# CONFIG_HID_APPLEIR is not set
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
# CONFIG_HID_CHICONY is not set
CONFIG_HID_CP2112=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=m
# CONFIG_HID_ELO is not set
# CONFIG_HID_EZKEY is not set
CONFIG_HID_HOLTEK=m
# CONFIG_HOLTEK_FF is not set
CONFIG_HID_HUION=m
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=m
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LENOVO_TPKBD=m
CONFIG_HID_LOGITECH=m
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
# CONFIG_HID_NTRIG is not set
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
# CONFIG_HID_PICOLCD_FB is not set
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PRIMAX=m
CONFIG_HID_ROCCAT=m
CONFIG_HID_SAITEK=m
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SONY=m
# CONFIG_SONY_FF is not set
CONFIG_HID_SPEEDLINK=m
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_RMI=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=m
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=m
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=m

#
# USB HID support
#
CONFIG_USB_HID=m
CONFIG_HID_PID=y
# CONFIG_USB_HIDDEV is not set

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=m

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
CONFIG_USB_DEFAULT_PERSIST=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG=y
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB_CBAF=m
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=m
CONFIG_USB_XHCI_PLATFORM=m
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=m
CONFIG_USB_EHCI_HCD_PLATFORM=m
CONFIG_USB_OXU210HP_HCD=m
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=m
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_FUSBH200_HCD=y
CONFIG_USB_FOTG210_HCD=y
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_RENESAS_USBHS_HCD=m
# CONFIG_USB_HCD_BCMA is not set
CONFIG_USB_HCD_SSB=m
CONFIG_USB_HCD_TEST_MODE=y
CONFIG_USB_RENESAS_USBHS=m

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=y
CONFIG_USB_TMC=y

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
# CONFIG_USB_MUSB_HDRC is not set
CONFIG_USB_DWC3=y
CONFIG_USB_DWC3_HOST=y

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_EXYNOS=y
CONFIG_USB_DWC3_PCI=y
# CONFIG_USB_DWC3_KEYSTONE is not set

#
# Debugging features
#
# CONFIG_USB_DWC3_DEBUG is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
# CONFIG_USB_EMI26 is not set
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=m
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
CONFIG_USB_IDMOUSE=y
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=m
CONFIG_USB_TEST=y
CONFIG_USB_EHSET_TEST_FIXTURE=y
# CONFIG_USB_ISIGHTFW is not set
CONFIG_USB_YUREX=y
# CONFIG_USB_EZUSB_FX2 is not set
CONFIG_USB_HSIC_USB3503=y
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
# CONFIG_USB_CXACRU is not set
# CONFIG_USB_UEAGLEATM is not set
CONFIG_USB_XUSBATM=m

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_USB_OTG_FSM=m
CONFIG_KEYSTONE_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_AM335X_CONTROL_USB=m
CONFIG_AM335X_PHY_USB=m
CONFIG_SAMSUNG_USBPHY=m
# CONFIG_SAMSUNG_USB2PHY is not set
CONFIG_SAMSUNG_USB3PHY=m
CONFIG_USB_GPIO_VBUS=y
CONFIG_USB_ISP1301=m
# CONFIG_USB_MSM_OTG is not set
# CONFIG_USB_RCAR_PHY is not set
# CONFIG_USB_RCAR_GEN2_PHY is not set
CONFIG_USB_GADGET=m
# CONFIG_USB_GADGET_DEBUG is not set
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
# CONFIG_USB_FOTG210_UDC is not set
CONFIG_USB_GR_UDC=m
CONFIG_USB_R8A66597=m
CONFIG_USB_RENESAS_USBHS_UDC=m
# CONFIG_USB_PXA27X is not set
CONFIG_USB_MV_UDC=m
CONFIG_USB_MV_U3D=m
# CONFIG_USB_M66592 is not set
# CONFIG_USB_AMD5536UDC is not set
CONFIG_USB_NET2272=m
# CONFIG_USB_NET2272_DMA is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
CONFIG_USB_DUMMY_HCD=m
CONFIG_USB_LIBCOMPOSITE=m
CONFIG_USB_F_SS_LB=m
CONFIG_USB_U_ETHER=m
CONFIG_USB_F_NCM=m
CONFIG_USB_F_ECM=m
CONFIG_USB_F_SUBSET=m
CONFIG_USB_CONFIGFS=m
# CONFIG_USB_CONFIGFS_SERIAL is not set
# CONFIG_USB_CONFIGFS_ACM is not set
# CONFIG_USB_CONFIGFS_OBEX is not set
# CONFIG_USB_CONFIGFS_NCM is not set
CONFIG_USB_CONFIGFS_ECM=y
CONFIG_USB_CONFIGFS_ECM_SUBSET=y
# CONFIG_USB_CONFIGFS_RNDIS is not set
# CONFIG_USB_CONFIGFS_EEM is not set
# CONFIG_USB_CONFIGFS_F_LB_SS is not set
# CONFIG_USB_CONFIGFS_F_FS is not set
CONFIG_USB_ZERO=m
# CONFIG_USB_ZERO_HNPTEST is not set
# CONFIG_USB_ETH is not set
CONFIG_USB_G_NCM=m
CONFIG_USB_GADGETFS=m
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_G_SERIAL is not set
CONFIG_USB_G_PRINTER=m
# CONFIG_USB_CDC_COMPOSITE is not set
CONFIG_USB_G_HID=m
# CONFIG_USB_G_DBGP is not set
# CONFIG_USB_G_WEBCAM is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_OMAP_HS=y
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_VUB300 is not set
CONFIG_MMC_USHC=y
# CONFIG_MMC_REALTEK_USB is not set
CONFIG_MEMSTICK=m
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set

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
CONFIG_LEDS_LM3530=m
CONFIG_LEDS_LM3533=m
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=m
CONFIG_LEDS_LP8501=y
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA963X is not set
CONFIG_LEDS_WM831X_STATUS=m
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DA903X=m
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_BD2802=m
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_ADP5520=m
CONFIG_LEDS_TCA6507=m
CONFIG_LEDS_MAX8997=m
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_OT200=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=m
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_ACCESSIBILITY=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
CONFIG_EDAC_DEBUG=y
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
# CONFIG_UIO is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
CONFIG_USBIP_CORE=y
# CONFIG_USBIP_VHCI_HCD is not set
CONFIG_USBIP_HOST=m
# CONFIG_USBIP_DEBUG is not set
CONFIG_PRISM2_USB=m
CONFIG_COMEDI=m
# CONFIG_COMEDI_DEBUG is not set
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
CONFIG_COMEDI_MISC_DRIVERS=y
# CONFIG_COMEDI_KCOMEDILIB is not set
# CONFIG_COMEDI_TEST is not set
CONFIG_COMEDI_PARPORT=m
CONFIG_COMEDI_SERIAL2002=m
# CONFIG_COMEDI_SKEL is not set
# CONFIG_COMEDI_SSV_DNP is not set
CONFIG_COMEDI_ISA_DRIVERS=y
# CONFIG_COMEDI_PCL711 is not set
CONFIG_COMEDI_PCL724=m
# CONFIG_COMEDI_PCL726 is not set
CONFIG_COMEDI_PCL730=m
CONFIG_COMEDI_PCL812=m
CONFIG_COMEDI_PCL816=m
CONFIG_COMEDI_PCL818=m
# CONFIG_COMEDI_PCM3724 is not set
CONFIG_COMEDI_AMPLC_DIO200_ISA=m
# CONFIG_COMEDI_AMPLC_PC236_ISA is not set
CONFIG_COMEDI_AMPLC_PC263_ISA=m
# CONFIG_COMEDI_RTI800 is not set
# CONFIG_COMEDI_RTI802 is not set
# CONFIG_COMEDI_DAC02 is not set
CONFIG_COMEDI_DAS16M1=m
CONFIG_COMEDI_DAS08_ISA=m
CONFIG_COMEDI_DAS16=m
CONFIG_COMEDI_DAS800=m
CONFIG_COMEDI_DAS1800=m
# CONFIG_COMEDI_DAS6402 is not set
CONFIG_COMEDI_DT2801=m
CONFIG_COMEDI_DT2811=m
CONFIG_COMEDI_DT2814=m
CONFIG_COMEDI_DT2815=m
CONFIG_COMEDI_DT2817=m
# CONFIG_COMEDI_DT282X is not set
# CONFIG_COMEDI_DMM32AT is not set
# CONFIG_COMEDI_UNIOXX5 is not set
# CONFIG_COMEDI_FL512 is not set
# CONFIG_COMEDI_AIO_AIO12_8 is not set
# CONFIG_COMEDI_AIO_IIRO_16 is not set
CONFIG_COMEDI_II_PCI20KC=m
CONFIG_COMEDI_C6XDIGIO=m
CONFIG_COMEDI_MPC624=m
# CONFIG_COMEDI_ADQ12B is not set
# CONFIG_COMEDI_NI_AT_A2150 is not set
CONFIG_COMEDI_NI_AT_AO=m
CONFIG_COMEDI_NI_ATMIO=m
CONFIG_COMEDI_NI_ATMIO16D=m
# CONFIG_COMEDI_NI_LABPC_ISA is not set
CONFIG_COMEDI_PCMAD=m
# CONFIG_COMEDI_PCMDA12 is not set
CONFIG_COMEDI_PCMMIO=m
# CONFIG_COMEDI_PCMUIO is not set
# CONFIG_COMEDI_MULTIQ3 is not set
CONFIG_COMEDI_S526=m
# CONFIG_COMEDI_PCI_DRIVERS is not set
# CONFIG_COMEDI_USB_DRIVERS is not set
CONFIG_COMEDI_8255=m
CONFIG_COMEDI_FC=m
CONFIG_COMEDI_AMPLC_DIO200=m
CONFIG_COMEDI_DAS08=m
CONFIG_COMEDI_NI_TIO=m
# CONFIG_RTL8192U is not set
CONFIG_RTLLIB=m
CONFIG_RTLLIB_CRYPTO_CCMP=m
CONFIG_RTLLIB_CRYPTO_TKIP=m
CONFIG_RTLLIB_CRYPTO_WEP=m
# CONFIG_RTL8192E is not set
# CONFIG_R8712U is not set
# CONFIG_R8188EU is not set
CONFIG_R8723AU=m
CONFIG_8723AU_AP_MODE=y
CONFIG_8723AU_BT_COEXIST=y
CONFIG_TRANZPORT=y
# CONFIG_VT6655 is not set
CONFIG_VT6656=m
# CONFIG_DX_SEP is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_CXT1E1 is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_BCM_WIMAX=m
CONFIG_FT1000=m
# CONFIG_FT1000_USB is not set

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=m
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_USB_WPAN_HCD=y
CONFIG_WIMAX_GDM72XX=y
# CONFIG_WIMAX_GDM72XX_QOS is not set
# CONFIG_WIMAX_GDM72XX_K_MODE is not set
CONFIG_WIMAX_GDM72XX_WIMAX2=y
# CONFIG_WIMAX_GDM72XX_USB is not set
CONFIG_WIMAX_GDM72XX_SDIO=y
# CONFIG_LTE_GDM724X is not set
# CONFIG_NET_VENDOR_SILICOM is not set
CONFIG_CED1401=m
# CONFIG_DGRP is not set
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
# CONFIG_GS_FPGABOOT is not set
CONFIG_CRYPTO_SKEIN=y
CONFIG_CRYPTO_THREEFISH=y
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_AMILO_RFKILL is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
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
CONFIG_SAMSUNG_LAPTOP=y
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
CONFIG_SH_TIMER_TMU=y
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
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=m

#
# DEVFREQ Drivers
#
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
# CONFIG_FMC_FAKEDEV is not set
CONFIG_FMC_TRIVIAL=m
CONFIG_FMC_WRITE_EEPROM=m
# CONFIG_FMC_CHARDEV is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_EXYNOS_MIPI_VIDEO=y
CONFIG_OMAP_CONTROL_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
# CONFIG_PHY_SAMSUNG_USB2 is not set
# CONFIG_POWERCAP is not set
CONFIG_MCB=m
# CONFIG_MCB_PCI is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
# CONFIG_GOOGLE_MEMCONSOLE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=m
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=m
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_DEBUG is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ECRYPT_FS=m
CONFIG_ECRYPT_FS_MESSAGING=y
# CONFIG_PSTORE is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=m
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=m
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=m
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=y
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=y
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
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_VMACACHE is not set
CONFIG_DEBUG_VM_RB=y
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
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
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
# CONFIG_DEBUG_PREEMPT is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_PI_LIST=y
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
CONFIG_PROVE_RCU_DELAY=y
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
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
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
CONFIG_STACK_TRACER=y
CONFIG_KPROBE_EVENT=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_DYNAMIC_FTRACE is not set
CONFIG_FUNCTION_PROFILER=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_TEST_LIST_SORT=y
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
CONFIG_INTERVAL_TREE_TEST=m
# CONFIG_PERCPU_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=m
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_TEST_MODULE is not set
CONFIG_TEST_USER_COPY=m
CONFIG_TEST_BPF=m
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
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
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_ENCRYPTED_KEYS=y
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
CONFIG_SECURITY_APPARMOR_HASH=y
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
# CONFIG_INTEGRITY_AUDIT is not set
# CONFIG_INTEGRITY_ASYMMETRIC_KEYS is not set
# CONFIG_IMA is not set
CONFIG_EVM=y
CONFIG_EVM_HMAC_VERSION=2
CONFIG_DEFAULT_SECURITY_APPARMOR=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="apparmor"
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
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
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
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
# CONFIG_CRYPTO_DES is not set
CONFIG_CRYPTO_FCRYPT=m
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_X86_64=y
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=m
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=m
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
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
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_CRC8=y
# CONFIG_CRC64_ECMA is not set
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_INTERVAL_TREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
# CONFIG_CPUMASK_OFFSTACK is not set
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_OID_REGISTRY=y
CONFIG_ARCH_HAS_SG_CHAIN=y

--KsGdsel6WgEHnImy--
