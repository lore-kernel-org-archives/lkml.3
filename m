Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbaGUBQu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 21:16:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:20560 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbaGUBQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 21:16:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,697,1400050800"; 
   d="log'?scan'208";a="572819258"
Message-ID: <53CC695E.2050901@intel.com>
Date: Mon, 21 Jul 2014 09:14:06 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Pranith Kumar <bobby.prani@gmail.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Aaron Lu <aaron.lu@intel.com>, Su Tao <tao.su@intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [rcu] BUG: unable to handle kernel NULL pointer dereference at  
 (null)
Content-Type: multipart/mixed;
 boundary="------------000500000707070800080307"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000500000707070800080307
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Pranith,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
commit c6e2955266d149d207656d7a5b975ac28c27826a
Author:     Pranith Kumar <bobby.prani@gmail.com>
AuthorDate: Tue Jul 15 21:50:02 2014 -0400
Commit:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
CommitDate: Thu Jul 17 16:39:53 2014 -0700

     rcu: Remove redundant checks for rcu_scheduler_fully_active
         rcu_scheduler_fully_active is set to true early in the boot process.
         rcu_prepare_kthreads() is called in two locations. Once after setting the above
     flag and the other while hotplugging a CPU from rcu_cpu_notify(). CPU hotplug is
     enabled much later by which time the above flag is already set. Hence checking
     for this flag is redundant in this function.
         The checks in rcu_spawn_one_boost_kthread() and rcu_spawn_all_nocb_kthreads()
     are similarly redundant.
         This commit removes the redundant checks for this flag from the above
     locations.
         Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

+----------------------------------------------------------+------------+------------+
|                                                          | 34e82ed60a | c6e2955266 |
+----------------------------------------------------------+------------+------------+
| boot_successes                                           | 60         | 0          |
| boot_failures                                            | 0          | 20         |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference     | 0          | 20         |
| Oops                                                     | 0          | 20         |
| EIP_is_at_wake_up_process                                | 0          | 20         |
| Kernel_panic-not_syncing:Attempted_to_kill_the_idle_task | 0          | 20         |
| backtrace:kthread_create_on_node                         | 0          | 20         |
| backtrace:rcu_cpu_notify                                 | 0          | 20         |
| backtrace:rcu_init                                       | 0          | 20         |
+----------------------------------------------------------+------------+------------+

[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=1
[    0.000000] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.000000] IP: [<81048a68>] wake_up_process+0x6/0x2c
[    0.000000] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 [    0.000000] Oops: 0000 [#1] PREEMPT SMP [    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc1-00055-gc6e2955 #9
[    0.000000] task: 81957830 ti: 8194c000 task.ti: 8194c000
[    0.000000] EIP: 0060:[<81048a68>] EFLAGS: 00210082 CPU: 0
[    0.000000] EIP is at wake_up_process+0x6/0x2c
[    0.000000] EAX: 00000000 EBX: 00000000 ECX: 81957c40 EDX: 00000002
[    0.000000] ESI: 93403620 EDI: 8194dedc EBP: 8194dea0 ESP: 8194de9c
[    0.000000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.000000] CR0: 80050033 CR2: 00000000 CR3: 01a72000 CR4: 000406b0
[    0.000000] Stack:
[    0.000000]  8194deb0 8194df14 8103f651 81957c58 00000000 00000000 00030000 dead4ead
[    0.000000]  ffffffff ffffffff 81a7fbfc 00000000 00000000 81885cce 8194ded4 8194ded4
[    0.000000]  00000000 00030000 dead4ead ffffffff ffffffff 81a7fbfc 00000000 00000000
[    0.000000] Call Trace:
[    0.000000]  [<8103f651>] kthread_create_on_node+0x90/0x108
[    0.000000]  [<8106a5b0>] rcu_spawn_one_nocb_kthread+0xba/0xda
[    0.000000]  [<81067eb3>] ? rcu_start_future_gp+0x118/0x118
[    0.000000]  [<8106a723>] rcu_cpu_notify+0x153/0x5b8
[    0.000000]  [<81657ae3>] ? __mutex_unlock_slowpath+0x106/0x11d
[    0.000000]  [<810678d2>] ? cpumask_next+0x22/0x26
[    0.000000]  [<81a058cc>] rcu_init+0x291/0x29b
[    0.000000]  [<819f2965>] start_kernel+0x1fa/0x372
[    0.000000]  [<819f255d>] ? set_init_arg+0x49/0x49
[    0.000000]  [<819f22af>] i386_start_kernel+0x79/0x7d
[    0.000000] Code: 61 00 eb 07 89 f0 e8 df c4 ff ff be 01 00 00 00 8b 45 f0 8b 55 ec e8 b2 07 61 00 83 c4 10 89 f0 5b 5e 5f 5d c3 55 89 e5 53 89 c3 <8b> 00 a8 0c 74 0f ba e0 06 00 00 b8 8e 78 88 81 e8 0d 36 fe ff
[    0.000000] EIP: [<81048a68>] wake_up_process+0x6/0x2c SS:ESP 0068:8194de9c
[    0.000000] CR2: 0000000000000000
[    0.000000] ---[ end trace db4b7fde7786bb07 ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!

git bisect start 58e323c3ee94f1abcecdeeef211a27d1c106c2b3 1795cd9b3a91d4b5473c97f491d63892442212ab --
git bisect good 2a68fcd415ae2fa824ebb7c88f59d657f6669b72  # 17:07     20+      0  Merge remote-tracking branch 'kbuild/for-next'
git bisect good c6006742775b1c02e32d75a3aec8a26b587205b1  # 17:10     20+      0  Merge remote-tracking branch 'tip/auto-latest'
git bisect  bad 946edaf4f5889f86419444d51da2614a0a41371c  # 17:12      0-     20  Merge remote-tracking branch 'staging/staging-next'
git bisect  bad 42e17b0d47f73373c97261b63ec1ffe1f690dbf4  # 17:17      0-      8  Merge remote-tracking branch 'percpu/for-next'
git bisect good 57080e0a2472ad31c609217f6329233412321979  # 17:21     20+      0  Merge remote-tracking branch 'ftrace/for-next'
git bisect  bad ae885de230a4897c2bc0b324cb32f22c0b7c9747  # 17:29      0-     20  Merge remote-tracking branch 'kvm/linux-next'
git bisect  bad f63782f6953176276ab089434e9b8fbe672167ff  # 17:32      0-     20  Merge remote-tracking branch 'rcu/rcu/next'
git bisect good 1823172ab582eb54456fd1354869bb850a1196ba  # 17:37     20+      0  Merge branches 'doc.2014.07.08a', 'fixes.2014.07.09a', 'maintainers.2014.07.08b', 'nocbs.2014.07.07a' and 'torture.2014.07.07a' into HEAD
git bisect good 531f70396af7a4c4da733dd820af4289e887d0c2  # 17:51     20+      0  rcu: Return bool type in rcu_lockdep_current_cpu_online()
git bisect good 78d9b29a96b632c00fe8136dacb9a39532469f81  # 18:12     20+      0  rcu: Rationalize kthread spawning
git bisect good 94e336821b022b92b09d14792f512cb502b667f3  # 18:14     20+      0  rcu: Update tiny.c references to tree.c
git bisect  bad c6e2955266d149d207656d7a5b975ac28c27826a  # 18:19      0-     20  rcu: Remove redundant checks for rcu_scheduler_fully_active
git bisect good 34e82ed60aad3205657e276e4640c3ea60657048  # 18:21     20+      0  rcu: Remove stale comment in tree.c
# first bad commit: [c6e2955266d149d207656d7a5b975ac28c27826a] rcu: Remove redundant checks for rcu_scheduler_fully_active
git bisect good 34e82ed60aad3205657e276e4640c3ea60657048  # 18:26     60+      0  rcu: Remove stale comment in tree.c
git bisect  bad 58e323c3ee94f1abcecdeeef211a27d1c106c2b3  # 18:26      0-     11  Add linux-next specific files for 20140718
git bisect good 59ca9ee42838d0f597137cf811e47eaf42fdcb69  # 18:35     60+      0  Merge tag 'stable/for-linus-3.16-rc5-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip
git bisect  bad 58e323c3ee94f1abcecdeeef211a27d1c106c2b3  # 18:50      0-     11  Add linux-next specific files for 20140718


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1

kvm=(
	qemu-system-x86_64
	-enable-kvm
	-cpu Haswell,+smep,+smap
	-kernel $kernel
	-m 320
	-smp 1
	-net nic,vlan=1,model=e1000
	-net user,vlan=1
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-rtc base=localtime
	-serial stdio
	-display none
	-monitor null )

append=(
	hung_task_panic=1
	earlyprintk=ttyS0,115200
	debug
	apic=debug
	sysrq_always_enabled
	rcupdate.rcu_cpu_stall_timeout=100
	panic=10
	softlockup_panic=1
	nmi_watchdog=panic
	prompt_ramdisk=0
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
	drbd.minor_count=8
)

"${kvm[@]}" --append "${append[*]}"
----------------------------------------------------------------------------

Thanks,
Jet


--------------000500000707070800080307
Content-Type: text/plain; charset=UTF-8;
 name="dmesg-yocto-kbuild-3:20140718181657:i386-randconfig-ib1-07181646:3.16.0-rc1-00055-gc6e2955:9"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="dmesg-yocto-kbuild-3:20140718181657:i386-randconfig-ib1-0718";
 filename*1="1646:3.16.0-rc1-00055-gc6e2955:9"

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... No relocation needed... done.
Booting the kernel.
[    0.000000] Linux version 3.16.0-rc1-00055-gc6e2955 (kbuild@lkp-hsx01)=
 (gcc version 4.8.2 (Debian 4.8.2-18) ) #9 SMP PREEMPT Sat Jul 19 02:18:3=
2 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] res=
erved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdb00-0x000fdb0f] mapped a=
t [800fdb00]
[    0.000000]   mpc: fdb10-fdbf0
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x029fffff]
[    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x02068000, 0x02068fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000FD9A0 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFE4B0 000034 (v01 BOCHS  BXPCRSDT 00000001=
 BXPC 00000001)
[    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001=
 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE4F0 0011A9 (v01 BXPC   BXDSDT   00000001=
 INTL 20100528)
[    0.000000] ACPI: FACS 0x13FFFF40 000040
[    0.000000] ACPI: SSDT 0x13FFF800 000735 (v01 BOCHS  BXPCSSDT 00000001=
 BXPC 00000001)
[    0.000000] ACPI: APIC 0x13FFF6E0 000078 (v01 BOCHS  BXPCAPIC 00000001=
 BXPC 00000001)
[    0.000000] ACPI: HPET 0x13FFF6A0 000038 (v01 BOCHS  BXPCHPET 00000001=
 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] BRK [0x02069000, 0x02069fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat 819ec820, node_mem_map =
93a3d020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 608 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, API=
C INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level=
)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, API=
C INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level=
)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, API=
C INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high lev=
el)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, API=
C INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high lev=
el)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, API=
C INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, API=
C INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, API=
C INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, API=
C INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, API=
C INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, API=
C INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, API=
C INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, API=
C INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, API=
C INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, API=
C INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, API=
C INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 10 pages/cpu @93a33000 s27200 r0 d13760 u=
40960
[    0.000000] pcpu-alloc: s27200 r0 d13760 u40960 alloc=3D10*4096
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 13a35540
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  To=
tal pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3Dtty=
S0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_=
timeout=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  promp=
t_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D=
/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-ib1-07181=
646/next:master:c6e2955266d149d207656d7a5b975ac28c27826a:bisect-linux0/.v=
mlinuz-c6e2955266d149d207656d7a5b975ac28c27826a-20140719021844-4-kbuild b=
ranch=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randconfig-ib1-07181646/c6e=
2955266d149d207656d7a5b975ac28c27826a/vmlinuz-3.16.0-rc1-00055-gc6e2955 d=
rbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 b=
ytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 by=
tes)
[    0.000000] Initializing CPU#0
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 304080K/327280K available (6507K kernel code, 660K=
 rwdata, 3004K rodata, 480K init, 6036K bss, 23200K reserved, 0K highmem)=

[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffe6e000 - 0xfffff000   (1604 kB)
[    0.000000]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.000000]     vmalloc : 0x947fe000 - 0xff9fe000   (1714 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x93ffe000   ( 319 MB)
[    0.000000]       .init : 0x819f2000 - 0x81a6a000   ( 480 kB)
[    0.000000]       .data : 0x8165b009 - 0x819f03e0   (3668 kB)
[    0.000000]       .text : 0x81000000 - 0x8165b009   (6508 kB)
[    0.000000] Checking if this processor honours the WP bit even in supe=
rvisor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_i=
ds=3D1
[    0.000000] BUG: unable to handle kernel NULL pointer dereference at  =
 (null)
[    0.000000] IP: [<81048a68>] wake_up_process+0x6/0x2c
[    0.000000] *pdpt =3D 0000000000000000 *pde =3D f000ff53f000ff53=20
[    0.000000] Oops: 0000 [#1] PREEMPT SMP=20
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc1-00055=
-gc6e2955 #9
[    0.000000] task: 81957830 ti: 8194c000 task.ti: 8194c000
[    0.000000] EIP: 0060:[<81048a68>] EFLAGS: 00210082 CPU: 0
[    0.000000] EIP is at wake_up_process+0x6/0x2c
[    0.000000] EAX: 00000000 EBX: 00000000 ECX: 81957c40 EDX: 00000002
[    0.000000] ESI: 93403620 EDI: 8194dedc EBP: 8194dea0 ESP: 8194de9c
[    0.000000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.000000] CR0: 80050033 CR2: 00000000 CR3: 01a72000 CR4: 000406b0
[    0.000000] Stack:
[    0.000000]  8194deb0 8194df14 8103f651 81957c58 00000000 00000000 000=
30000 dead4ead
[    0.000000]  ffffffff ffffffff 81a7fbfc 00000000 00000000 81885cce 819=
4ded4 8194ded4
[    0.000000]  00000000 00030000 dead4ead ffffffff ffffffff 81a7fbfc 000=
00000 00000000
[    0.000000] Call Trace:
[    0.000000]  [<8103f651>] kthread_create_on_node+0x90/0x108
[    0.000000]  [<8106a5b0>] rcu_spawn_one_nocb_kthread+0xba/0xda
[    0.000000]  [<81067eb3>] ? rcu_start_future_gp+0x118/0x118
[    0.000000]  [<8106a723>] rcu_cpu_notify+0x153/0x5b8
[    0.000000]  [<81657ae3>] ? __mutex_unlock_slowpath+0x106/0x11d
[    0.000000]  [<810678d2>] ? cpumask_next+0x22/0x26
[    0.000000]  [<81a058cc>] rcu_init+0x291/0x29b
[    0.000000]  [<819f2965>] start_kernel+0x1fa/0x372
[    0.000000]  [<819f255d>] ? set_init_arg+0x49/0x49
[    0.000000]  [<819f22af>] i386_start_kernel+0x79/0x7d
[    0.000000] Code: 61 00 eb 07 89 f0 e8 df c4 ff ff be 01 00 00 00 8b 4=
5 f0 8b 55 ec e8 b2 07 61 00 83 c4 10 89 f0 5b 5e 5f 5d c3 55 89 e5 53 89=
 c3 <8b> 00 a8 0c 74 0f ba e0 06 00 00 b8 8e 78 88 81 e8 0d 36 fe ff
[    0.000000] EIP: [<81048a68>] wake_up_process+0x6/0x2c SS:ESP 0068:819=
4de9c
[    0.000000] CR2: 0000000000000000
[    0.000000] ---[ end trace db4b7fde7786bb07 ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle tas=
k!
[    0.000000] Rebooting in 10 seconds..
Elapsed time: 5
qemu-system-x86_64 -enable-kvm -cpu Haswell,+smep,+smap -kernel /kernel/i=
386-randconfig-ib1-07181646/c6e2955266d149d207656d7a5b975ac28c27826a/vmli=
nuz-3.16.0-rc1-00055-gc6e2955 -append 'hung_task_panic=3D1 earlyprintk=3D=
ttyS0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_sta=
ll_timeout=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  pr=
ompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=
=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-ib1-07=
181646/next:master:c6e2955266d149d207656d7a5b975ac28c27826a:bisect-linux0=
/.vmlinuz-c6e2955266d149d207656d7a5b975ac28c27826a-20140719021844-4-kbuil=
d branch=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randconfig-ib1-07181646/=
c6e2955266d149d207656d7a5b975ac28c27826a/vmlinuz-3.16.0-rc1-00055-gc6e295=
5 drbd.minor_count=3D8'  -initrd /kernel-tests/initrd/yocto-minimal-i386.=
cgz -m 320 -smp 1 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boo=
t order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile=
 /dev/shm/kboot/pid-yocto-kbuild-3 -serial file:/dev/shm/kboot/serial-yoc=
to-kbuild-3 -daemonize -display none -monitor null=20


--------------000500000707070800080307
Content-Type: application/octet-stream;
 name="i386-randconfig-ib1-07181646-58e323c3ee94f1abcecdeeef211a27d1c106c2b3-BUG:-unable-to-handle-kernel-NULL-pointer-dereference-63756.log"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="i386-randconfig-ib1-07181646-58e323c3ee94f1abcecdeeef211a27d";
 filename*1="1c106c2b3-BUG:-unable-to-handle-kernel-NULL-pointer-derefere";
 filename*2="nce-63756.log"

SEVBRCBpcyBub3cgYXQgNThlMzIzYzMuLi4gQWRkIGxpbnV4LW5leHQgc3BlY2lmaWMgZmls
ZXMgZm9yIDIwMTQwNzE4CmdpdCBjaGVja291dCAxNzk1Y2Q5YjNhOTFkNGI1NDczYzk3ZjQ5
MWQ2Mzg5MjQ0MjIxMmFiCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2L25leHQ6bWFzdGVyOjE3OTVjZDliM2E5MWQ0YjU0
NzNjOTdmNDkxZDYzODkyNDQyMjEyYWI6YmlzZWN0LWxpbnV4MAoKMjAxNC0wNy0xOC0xNjo1
MDoxNCAxNzk1Y2Q5YjNhOTFkNGI1NDczYzk3ZjQ5MWQ2Mzg5MjQ0MjIxMmFiIGNvbXBpbGlu
ZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDcxODE2NDYtMTc5NWNkOWIzYTkxZDRiNTQ3M2M5N2Y0OTFkNjM4
OTI0NDIyMTJhYgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWliMS0wNzE4MTY0Ni8xNzk1Y2Q5YjNhOTFkNGI1NDczYzk3ZjQ5MWQ2Mzg5MjQ0MjIxMmFi
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9p
Mzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2LTE3OTVjZDliM2E5MWQ0YjU0NzNjOTdmNDkx
ZDYzODkyNDQyMjEyYWIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL2pha2V0b3duLWNvbnN1bWVyL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcx
ODE2NDYtMTc5NWNkOWIzYTkxZDRiNTQ3M2M5N2Y0OTFkNjM4OTI0NDIyMTJhYgprZXJuZWw6
IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni8xNzk1Y2Q5YjNhOTFkNGI1
NDczYzk3ZjQ5MWQ2Mzg5MjQ0MjIxMmFiL3ZtbGludXotMy4xNi4wLXJjNQoKMjAxNC0wNy0x
OC0xNzowMToxNCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgkyMCBTVUNDRVNTCgpiaXNlY3Q6
IGdvb2QgY29tbWl0IDE3OTVjZDliM2E5MWQ0YjU0NzNjOTdmNDkxZDYzODkyNDQyMjEyYWIK
Z2l0IGJpc2VjdCBzdGFydCA1OGUzMjNjM2VlOTRmMWFiY2VjZGVlZWYyMTFhMjdkMWMxMDZj
MmIzIDE3OTVjZDliM2E5MWQ0YjU0NzNjOTdmNDkxZDYzODkyNDQyMjEyYWIgLS0KL2Mva2Vy
bmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6IFsiLWIiLCAiNThlMzIzYzNlZTk0ZjFhYmNlY2Rl
ZWVmMjExYTI3ZDFjMTA2YzJiMyIsICItZyIsICIxNzk1Y2Q5YjNhOTFkNGI1NDczYzk3ZjQ5
MWQ2Mzg5MjQ0MjIxMmFiIiwgIi9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2giLCAiL2MvYm9vdC1iaXNlY3QvbGludXgwL29iai1iaXNlY3QiXQpCaXNlY3Rp
bmc6IDczMjQgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEz
IHN0ZXBzKQpbMmE2OGZjZDQxNWFlMmZhODI0ZWJiN2M4OGY1OWQ2NTdmNjY2OWI3Ml0gTWVy
Z2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAna2J1aWxkL2Zvci1uZXh0JwpydW5uaW5nIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNl
Y3QvbGludXgwL29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3Zt
L2kzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDYvbmV4dDptYXN0ZXI6MmE2OGZjZDQxNWFl
MmZhODI0ZWJiN2M4OGY1OWQ2NTdmNjY2OWI3MjpiaXNlY3QtbGludXgwCgoyMDE0LTA3LTE4
LTE3OjAyOjQ3IDJhNjhmY2Q0MTVhZTJmYTgyNGViYjdjODhmNTlkNjU3ZjY2NjliNzIgY29t
cGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUv
aTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni0yYTY4ZmNkNDE1YWUyZmE4MjRlYmI3Yzg4
ZjU5ZDY1N2Y2NjY5YjcyCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctaWIxLTA3MTgxNjQ2LzJhNjhmY2Q0MTVhZTJmYTgyNGViYjdjODhmNTlkNjU3ZjY2
NjliNzIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDYtMmE2OGZjZDQxNWFlMmZhODI0ZWJi
N2M4OGY1OWQ2NTdmNjY2OWI3Mgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAxLWNvbnN1bWVyL2kzODYtcmFuZGNvbmZpZy1p
YjEtMDcxODE2NDYtMmE2OGZjZDQxNWFlMmZhODI0ZWJiN2M4OGY1OWQ2NTdmNjY2OWI3Mgpr
ZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni8yYTY4ZmNkNDE1
YWUyZmE4MjRlYmI3Yzg4ZjU5ZDY1N2Y2NjY5YjcyL3ZtbGludXotMy4xNi4wLXJjNS0wMTY0
Mi1nMmE2OGZjZAoKMjAxNC0wNy0xOC0xNzowNjo0NyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJ
MwkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDU2ODIgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDEzIHN0ZXBzKQpbYzYwMDY3NDI3NzViMWMwMmUzMmQ3NWEz
YWVjOGEyNmI1ODcyMDViMV0gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAndGlwL2F1
dG8tbGF0ZXN0JwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgwL29iai1iaXNlY3QKbHMgLWEgL2tidWls
ZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDYvbmV4
dDptYXN0ZXI6YzYwMDY3NDI3NzViMWMwMmUzMmQ3NWEzYWVjOGEyNmI1ODcyMDViMTpiaXNl
Y3QtbGludXgwCgoyMDE0LTA3LTE4LTE3OjA3OjUwIGM2MDA2NzQyNzc1YjFjMDJlMzJkNzVh
M2FlYzhhMjZiNTg3MjA1YjEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni1jNjAw
Njc0Mjc3NWIxYzAyZTMyZDc1YTNhZWM4YTI2YjU4NzIwNWIxCkNoZWNrIGZvciBrZXJuZWwg
aW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2L2M2MDA2NzQyNzc1YjFj
MDJlMzJkNzVhM2FlYzhhMjZiNTg3MjA1YjEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDYt
YzYwMDY3NDI3NzViMWMwMmUzMmQ3NWEzYWVjOGEyNmI1ODcyMDViMQprZXJuZWw6IC9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni9jNjAwNjc0Mjc3NWIxYzAyZTMyZDc1
YTNhZWM4YTI2YjU4NzIwNWIxL3ZtbGludXotMy4xNi4wLXJjNS0wNDM1MC1nYzYwMDY3NAoK
MjAxNC0wNy0xOC0xNzowOTo1MCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMjAgU1VDQ0VTUwoK
QmlzZWN0aW5nOiAyOTc0IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSAxMiBzdGVwcykKWzk0NmVkYWY0ZjU4ODlmODY0MTk0NDRkNTFkYTI2MTRhMGE0MTM3
MWNdIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ3N0YWdpbmcvc3RhZ2luZy1uZXh0
JwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2MvYm9vdC1iaXNlY3QvbGludXgwL29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9y
dW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDYvbmV4dDptYXN0ZXI6
OTQ2ZWRhZjRmNTg4OWY4NjQxOTQ0NGQ1MWRhMjYxNGEwYTQxMzcxYzpiaXNlY3QtbGludXgw
CgoyMDE0LTA3LTE4LTE3OjEwOjI0IDk0NmVkYWY0ZjU4ODlmODY0MTk0NDRkNTFkYTI2MTRh
MGE0MTM3MWMgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni05NDZlZGFmNGY1ODg5
Zjg2NDE5NDQ0ZDUxZGEyNjE0YTBhNDEzNzFjCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2Lzk0NmVkYWY0ZjU4ODlmODY0MTk0NDRk
NTFkYTI2MTRhMGE0MTM3MWMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRl
c3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDYtOTQ2ZWRhZjRm
NTg4OWY4NjQxOTQ0NGQ1MWRhMjYxNGEwYTQxMzcxYwprZXJuZWw6IC9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWliMS0wNzE4MTY0Ni85NDZlZGFmNGY1ODg5Zjg2NDE5NDQ0ZDUxZGEyNjE0
YTBhNDEzNzFjL3ZtbGludXotMy4xNi4wLXJjNS0wNjUxMC1nOTQ2ZWRhZgoKMjAxNC0wNy0x
OC0xNzoxMjoyNCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVSRQpbICAgIDAu
MDAwMDAwXSBDaGVja2luZyBpZiB0aGlzIHByb2Nlc3NvciBob25vdXJzIHRoZSBXUCBiaXQg
ZXZlbiBpbiBzdXBlcnZpc29yIG1vZGUuLi5Pay4KWyAgICAwLjAwMDAwMF0gUHJlZW1wdGli
bGUgaGllcmFyY2hpY2FsIFJDVSBpbXBsZW1lbnRhdGlvbi4KWyAgICAwLjAwMDAwMF0gUkNV
OiBBZGp1c3RpbmcgZ2VvbWV0cnkgZm9yIHJjdV9mYW5vdXRfbGVhZj0xNiwgbnJfY3B1X2lk
cz0xClsgICAgMC4wMDAwMDBdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBw
b2ludGVyIGRlcmVmZXJlbmNlIGF0ICAgKG51bGwpClsgICAgMC4wMDAwMDBdIElQOiBbPDgx
MDQ0MGEwPl0gd2FrZV91cF9wcm9jZXNzKzB4Ni8weDJjClsgICAgMC4wMDAwMDBdICpwZHB0
ID0gMDAwMDAwMDAwMDAwMDAwMCAqcGRlID0gZjAwMGZmNTNmMDAwZmY1MyAKWyAgICAwLjAw
MDAwMF0gT29wczogMDAwMCBbIzFdIFBSRUVNUFQgU01QIApbICAgIDAuMDAwMDAwXSBDUFU6
IDAgUElEOiAwIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE2LjAtcmM1LTA2NTEw
LWc5NDZlZGFmICMzClsgICAgMC4wMDAwMDBdIHRhc2s6IDgxOTYxODMwIHRpOiA4MTk1NjAw
MCB0YXNrLnRpOiA4MTk1NjAwMApbICAgIDAuMDAwMDAwXSBFSVA6IDAwNjA6Wzw4MTA0NDBh
MD5dIEVGTEFHUzogMDAyMTAwODIgQ1BVOiAwClsgICAgMC4wMDAwMDBdIEVJUCBpcyBhdCB3
YWtlX3VwX3Byb2Nlc3MrMHg2LzB4MmMKWyAgICAwLjAwMDAwMF0gRUFYOiAwMDAwMDAwMCBF
Qlg6IDAwMDAwMDAwIEVDWDogMDAwMDAwMDAgRURYOiAwMDAwMDAwMgpbICAgIDAuMDAwMDAw
XSBFU0k6IDkzNDAzNjIwIEVESTogODE5NTdlZGMgRUJQOiA4MTk1N2VhMCBFU1A6IDgxOTU3
ZTljClsgICAgMC4wMDAwMDBdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDAw
MCBTUzogMDA2OApbICAgIDAuMDAwMDAwXSBDUjA6IDgwMDUwMDMzIENSMjogMDAwMDAwMDAg
Q1IzOiAwMWE3ZDAwMCBDUjQ6IDAwMDQwNmIwClsgICAgMC4wMDAwMDBdIFN0YWNrOgpbICAg
IDAuMDAwMDAwXSAgODE5NTdlYjAgODE5NTdmMTQgODEwM2Q0YWYgMDAwMDAwMDIgMDAwMDAw
MDAgMDAwMDAwMDAgMDAwMDAwMDAgZGVhZDRlYWQKWyAgICAwLjAwMDAwMF0gIGZmZmZmZmZm
IGZmZmZmZmZmIDgxYTg5MjE4IDAwMDAwMDAwIDAwMDAwMDAwIDgxODkwMTY5IDgxOTU3ZWQ0
IDgxOTU3ZWQ0ClsgICAgMC4wMDAwMDBdICAwMDAwMDAwMCAwMDAwMDAwMCBkZWFkNGVhZCBm
ZmZmZmZmZiBmZmZmZmZmZiA4MWE4OTIxOCAwMDAwMDAwMCAwMDAwMDAwMApbICAgIDAuMDAw
MDAwXSBDYWxsIFRyYWNlOgpbICAgIDAuMDAwMDAwXSAgWzw4MTAzZDRhZj5dIGt0aHJlYWRf
Y3JlYXRlX29uX25vZGUrMHg5MC8weDEwOApbICAgIDAuMDAwMDAwXSAgWzw4MTA2NWU4Nz5d
IHJjdV9zcGF3bl9vbmVfbm9jYl9rdGhyZWFkKzB4YmEvMHhkYQpbICAgIDAuMDAwMDAwXSAg
Wzw4MTA2Mzc4YT5dID8gcmN1X3N0YXJ0X2Z1dHVyZV9ncCsweDExOC8weDExOApbICAgIDAu
MDAwMDAwXSAgWzw4MTA2NWZmYT5dIHJjdV9jcHVfbm90aWZ5KzB4MTUzLzB4NWI4ClsgICAg
MC4wMDAwMDBdICBbPDgxNjVkNTliPl0gPyBfX211dGV4X3VubG9ja19zbG93cGF0aCsweDEw
Ni8weDExZApbICAgIDAuMDAwMDAwXSAgWzw4MTA2MzFhOT5dID8gY3B1bWFza19uZXh0KzB4
MjIvMHgyNgpbICAgIDAuMDAwMDAwXSAgWzw4MWExMDhjYz5dIHJjdV9pbml0KzB4MjkxLzB4
MjliClsgICAgMC4wMDAwMDBdICBbPDgxOWZkOTY1Pl0gc3RhcnRfa2VybmVsKzB4MWZhLzB4
MzcyClsgICAgMC4wMDAwMDBdICBbPDgxOWZkNTVkPl0gPyBzZXRfaW5pdF9hcmcrMHg0OS8w
eDQ5ClsgICAgMC4wMDAwMDBdICBbPDgxOWZkMmFmPl0gaTM4Nl9zdGFydF9rZXJuZWwrMHg3
OS8weDdkClsgICAgMC4wMDAwMDBdIENvZGU6IDYxIDAwIGViIDA3IDg5IGYwIGU4IGQxIGM0
IGZmIGZmIGJlIDAxIDAwIDAwIDAwIDhiIDQ1IGYwIDhiIDU1IGVjIGU4IGEyIGFmIDYxIDAw
IDgzIGM0IDEwIDg5IGYwIDViIDVlIDVmIDVkIGMzIDU1IDg5IGU1IDUzIDg5IGMzIDw4Yj4g
MDAgYTggMGMgNzQgMGYgYmEgZTggMDYgMDAgMDAgYjggMjIgMWEgODkgODEgZTggMWQgODUg
ZmUgZmYKWyAgICAwLjAwMDAwMF0gRUlQOiBbPDgxMDQ0MGEwPl0gd2FrZV91cF9wcm9jZXNz
KzB4Ni8weDJjIFNTOkVTUCAwMDY4OjgxOTU3ZTljClsgICAgMC4wMDAwMDBdIENSMjogMDAw
MDAwMDAwMDAwMDAwMApbICAgIDAuMDAwMDAwXSAtLS1bIGVuZCB0cmFjZSBkYjRiN2ZkZTc3
ODZiYjA3IF0tLS0KWyAgICAwLjAwMDAwMF0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6
IEF0dGVtcHRlZCB0byBraWxsIHRoZSBpZGxlIHRhc2shCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWliMS0wNzE4MTY0Ni85NDZlZGFmNGY1ODg5Zjg2NDE5NDQ0ZDUxZGEyNjE0YTBhNDEz
NzFjL2RtZXNnLXlvY3RvLWtidWlsZC0xNzoyMDE0MDcxODE3MDk0NTppMzg2LXJhbmRjb25m
aWctaWIxLTA3MTgxNjQ2OjMuMTYuMC1yYzUtMDY1MTAtZzk0NmVkYWY6Mwova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDYvOTQ2ZWRhZjRmNTg4OWY4NjQxOTQ0NGQ1MWRh
MjYxNGEwYTQxMzcxYy9kbWVzZy15b2N0by1rYnVpbGQtMzI6MjAxNDA3MTgxNzA5NDU6aTM4
Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0NjozLjE2LjAtcmM1LTA2NTEwLWc5NDZlZGFmOjMK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2Lzk0NmVkYWY0ZjU4ODlmODY0
MTk0NDRkNTFkYTI2MTRhMGE0MTM3MWMvZG1lc2cteW9jdG8ta2J1aWxkLTM6MjAxNDA3MTgx
NzA5NDU6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0NjozLjE2LjAtcmM1LTA2NTEwLWc5
NDZlZGFmOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2Lzk0NmVkYWY0
ZjU4ODlmODY0MTk0NDRkNTFkYTI2MTRhMGE0MTM3MWMvZG1lc2cteW9jdG8ta2J1aWxkLTE1
OjIwMTQwNzE4MTcwOTQ1OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDY6My4xNi4wLXJj
NS0wNjUxMC1nOTQ2ZWRhZjozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0
Ni85NDZlZGFmNGY1ODg5Zjg2NDE5NDQ0ZDUxZGEyNjE0YTBhNDEzNzFjL2RtZXNnLXlvY3Rv
LWtidWlsZC0yNzoyMDE0MDcxODE3MDk0NTppMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2
OjMuMTYuMC1yYzUtMDY1MTAtZzk0NmVkYWY6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1p
YjEtMDcxODE2NDYvOTQ2ZWRhZjRmNTg4OWY4NjQxOTQ0NGQ1MWRhMjYxNGEwYTQxMzcxYy9k
bWVzZy15b2N0by1rYnVpbGQtMTE6MjAxNDA3MTgxNzA5NDY6aTM4Ni1yYW5kY29uZmlnLWli
MS0wNzE4MTY0NjozLjE2LjAtcmM1LTA2NTEwLWc5NDZlZGFmOjMKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctaWIxLTA3MTgxNjQ2Lzk0NmVkYWY0ZjU4ODlmODY0MTk0NDRkNTFkYTI2MTRh
MGE0MTM3MWMvZG1lc2cteW9jdG8ta2J1aWxkLTEyOjIwMTQwNzE4MTcwOTQ2OmkzODYtcmFu
ZGNvbmZpZy1pYjEtMDcxODE2NDY6My4xNi4wLXJjNS0wNjUxMC1nOTQ2ZWRhZjozCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni85NDZlZGFmNGY1ODg5Zjg2NDE5NDQ0
ZDUxZGEyNjE0YTBhNDEzNzFjL2RtZXNnLXlvY3RvLWtidWlsZC0xNDoyMDE0MDcxODE3MDk0
OTppMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2OjMuMTYuMC1yYzUtMDY1MTAtZzk0NmVk
YWY6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDYvOTQ2ZWRhZjRmNTg4
OWY4NjQxOTQ0NGQ1MWRhMjYxNGEwYTQxMzcxYy9kbWVzZy15b2N0by1rYnVpbGQtMTY6MjAx
NDA3MTgxNzA5NDc6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0NjozLjE2LjAtcmM1LTA2
NTEwLWc5NDZlZGFmOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2Lzk0
NmVkYWY0ZjU4ODlmODY0MTk0NDRkNTFkYTI2MTRhMGE0MTM3MWMvZG1lc2cteW9jdG8ta2J1
aWxkLTIwOjIwMTQwNzE4MTcwOTQ3OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDY6My4x
Ni4wLXJjNS0wNjUxMC1nOTQ2ZWRhZjozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0w
NzE4MTY0Ni85NDZlZGFmNGY1ODg5Zjg2NDE5NDQ0ZDUxZGEyNjE0YTBhNDEzNzFjL2RtZXNn
LXlvY3RvLWtidWlsZC0yMToyMDE0MDcxODE3MDk0ODppMzg2LXJhbmRjb25maWctaWIxLTA3
MTgxNjQ2OjMuMTYuMC1yYzUtMDY1MTAtZzk0NmVkYWY6Mwova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1pYjEtMDcxODE2NDYvOTQ2ZWRhZjRmNTg4OWY4NjQxOTQ0NGQ1MWRhMjYxNGEwYTQx
MzcxYy9kbWVzZy15b2N0by1rYnVpbGQtMjM6MjAxNDA3MTgxNzA5NDY6aTM4Ni1yYW5kY29u
ZmlnLWliMS0wNzE4MTY0NjozLjE2LjAtcmM1LTA2NTEwLWc5NDZlZGFmOjMKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2Lzk0NmVkYWY0ZjU4ODlmODY0MTk0NDRkNTFk
YTI2MTRhMGE0MTM3MWMvZG1lc2cteW9jdG8ta2J1aWxkLTI1OjIwMTQwNzE4MTcwOTQ4Omkz
ODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDY6My4xNi4wLXJjNS0wNjUxMC1nOTQ2ZWRhZjoz
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni85NDZlZGFmNGY1ODg5Zjg2
NDE5NDQ0ZDUxZGEyNjE0YTBhNDEzNzFjL2RtZXNnLXlvY3RvLWtidWlsZC0yNjoyMDE0MDcx
ODE3MDk0OTppMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2OjMuMTYuMC1yYzUtMDY1MTAt
Zzk0NmVkYWY6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDYvOTQ2ZWRh
ZjRmNTg4OWY4NjQxOTQ0NGQ1MWRhMjYxNGEwYTQxMzcxYy9kbWVzZy15b2N0by1rYnVpbGQt
Mjg6MjAxNDA3MTgxNzA5NDk6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0NjozLjE2LjAt
cmM1LTA2NTEwLWc5NDZlZGFmOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgx
NjQ2Lzk0NmVkYWY0ZjU4ODlmODY0MTk0NDRkNTFkYTI2MTRhMGE0MTM3MWMvZG1lc2cteW9j
dG8ta2J1aWxkLTMxOjIwMTQwNzE4MTcwOTQ5OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2
NDY6My4xNi4wLXJjNS0wNjUxMC1nOTQ2ZWRhZjozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWliMS0wNzE4MTY0Ni85NDZlZGFmNGY1ODg5Zjg2NDE5NDQ0ZDUxZGEyNjE0YTBhNDEzNzFj
L2RtZXNnLXlvY3RvLWtidWlsZC00OjIwMTQwNzE4MTcwOTQ3OmkzODYtcmFuZGNvbmZpZy1p
YjEtMDcxODE2NDY6My4xNi4wLXJjNS0wNjUxMC1nOTQ2ZWRhZjozCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWliMS0wNzE4MTY0Ni85NDZlZGFmNGY1ODg5Zjg2NDE5NDQ0ZDUxZGEyNjE0
YTBhNDEzNzFjL2RtZXNnLXlvY3RvLWtidWlsZC02OjIwMTQwNzE4MTcwOTQ3OmkzODYtcmFu
ZGNvbmZpZy1pYjEtMDcxODE2NDY6My4xNi4wLXJjNS0wNjUxMC1nOTQ2ZWRhZjozCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni85NDZlZGFmNGY1ODg5Zjg2NDE5NDQ0
ZDUxZGEyNjE0YTBhNDEzNzFjL2RtZXNnLXlvY3RvLWtidWlsZC04OjIwMTQwNzE4MTcwOTQ4
OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDY6My4xNi4wLXJjNS0wNjUxMC1nOTQ2ZWRh
ZjozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni85NDZlZGFmNGY1ODg5
Zjg2NDE5NDQ0ZDUxZGEyNjE0YTBhNDEzNzFjL2RtZXNnLXlvY3RvLWtidWlsZC05OjIwMTQw
NzE4MTcwOTQ4OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDY6My4xNi4wLXJjNS0wNjUx
MC1nOTQ2ZWRhZjozCjA6MjA6MjAgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1
bTIwMTQtMDctMTggMTc6MTI6NTUgUkVQRUFUIENPVU5UOiAyMCAgIyAvYy9ib290LWJpc2Vj
dC9saW51eDAvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiAyMTYwIHJldmlz
aW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMiBzdGVwcykKWzQyZTE3
YjBkNDdmNzMzNzNjOTcyNjFiNjNlYzFmZmUxZjY5MGRiZjRdIE1lcmdlIHJlbW90ZS10cmFj
a2luZyBicmFuY2ggJ3BlcmNwdS9mb3ItbmV4dCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4MC9vYmot
YmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctaWIxLTA3MTgxNjQ2L25leHQ6bWFzdGVyOjQyZTE3YjBkNDdmNzMzNzNjOTcyNjFiNjNl
YzFmZmUxZjY5MGRiZjQ6YmlzZWN0LWxpbnV4MAoKMjAxNC0wNy0xOC0xNzoxMjo1NiA0MmUx
N2IwZDQ3ZjczMzczYzk3MjYxYjYzZWMxZmZlMWY2OTBkYmY0IGNvbXBpbGluZwpRdWV1ZWQg
YnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZp
Zy1pYjEtMDcxODE2NDYtNDJlMTdiMGQ0N2Y3MzM3M2M5NzI2MWI2M2VjMWZmZTFmNjkwZGJm
NApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4
MTY0Ni80MmUxN2IwZDQ3ZjczMzczYzk3MjYxYjYzZWMxZmZlMWY2OTBkYmY0CndhaXRpbmcg
Zm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRj
b25maWctaWIxLTA3MTgxNjQ2LTQyZTE3YjBkNDdmNzMzNzNjOTcyNjFiNjNlYzFmZmUxZjY5
MGRiZjQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL2pha2V0b3duLWNvbnN1bWVyL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDYtNDJl
MTdiMGQ0N2Y3MzM3M2M5NzI2MWI2M2VjMWZmZTFmNjkwZGJmNAprZXJuZWw6IC9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni80MmUxN2IwZDQ3ZjczMzczYzk3MjYxYjYz
ZWMxZmZlMWY2OTBkYmY0L3ZtbGludXotMy4xNi4wLXJjNS0wNDU1MS1nNDJlMTdiMAoKMjAx
NC0wNy0xOC0xNzoxNjo1NiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVSRQpb
ICAgIDAuMDAwMDAwXSBDaGVja2luZyBpZiB0aGlzIHByb2Nlc3NvciBob25vdXJzIHRoZSBX
UCBiaXQgZXZlbiBpbiBzdXBlcnZpc29yIG1vZGUuLi5Pay4KWyAgICAwLjAwMDAwMF0gUHJl
ZW1wdGlibGUgaGllcmFyY2hpY2FsIFJDVSBpbXBsZW1lbnRhdGlvbi4KWyAgICAwLjAwMDAw
MF0gUkNVOiBBZGp1c3RpbmcgZ2VvbWV0cnkgZm9yIHJjdV9mYW5vdXRfbGVhZj0xNiwgbnJf
Y3B1X2lkcz0yClsgICAgMC4wMDAwMDBdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwg
TlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0ICAgKG51bGwpClsgICAgMC4wMDAwMDBdIElQ
OiBbPDgxMDQ0MGNhPl0gd2FrZV91cF9wcm9jZXNzKzB4Ni8weDJjClsgICAgMC4wMDAwMDBd
ICpwZHB0ID0gMDAwMDAwMDAwMDAwMDAwMCAqcGRlID0gZjAwMGZmNTNmMDAwZmY1MyAKWyAg
ICAwLjAwMDAwMF0gT29wczogMDAwMCBbIzFdIFBSRUVNUFQgU01QIApbICAgIDAuMDAwMDAw
XSBDUFU6IDAgUElEOiAwIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE2LjAtcmM1
LTA0NTUxLWc0MmUxN2IwICMyClsgICAgMC4wMDAwMDBdIHRhc2s6IDgxOTYxODMwIHRpOiA4
MTk1NjAwMCB0YXNrLnRpOiA4MTk1NjAwMApbICAgIDAuMDAwMDAwXSBFSVA6IDAwNjA6Wzw4
MTA0NDBjYT5dIEVGTEFHUzogMDAyMTAwODIgQ1BVOiAwClsgICAgMC4wMDAwMDBdIEVJUCBp
cyBhdCB3YWtlX3VwX3Byb2Nlc3MrMHg2LzB4MmMKWyAgICAwLjAwMDAwMF0gRUFYOiAwMDAw
MDAwMCBFQlg6IDAwMDAwMDAwIEVDWDogMDAwMDAwMDAgRURYOiAwMDAwMDAwMgpbICAgIDAu
MDAwMDAwXSBFU0k6IDkyMDA0NjIwIEVESTogODE5NTdlZGMgRUJQOiA4MTk1N2VhMCBFU1A6
IDgxOTU3ZTljClsgICAgMC4wMDAwMDBdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBH
UzogMDAwMCBTUzogMDA2OApbICAgIDAuMDAwMDAwXSBDUjA6IDgwMDUwMDNiIENSMjogMDAw
MDAwMDAgQ1IzOiAwMWE3ZDAwMCBDUjQ6IDAwMDAwNmIwClsgICAgMC4wMDAwMDBdIFN0YWNr
OgpbICAgIDAuMDAwMDAwXSAgODE5NTdlYjAgODE5NTdmMTQgODEwM2Q0ZDkgMDAwMDAwMDIg
MDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgZGVhZDRlYWQKWyAgICAwLjAwMDAwMF0gIGZm
ZmZmZmZmIGZmZmZmZmZmIDgxYTg5MjE4IDAwMDAwMDAwIDAwMDAwMDAwIDgxODhmZmU5IDgx
OTU3ZWQ0IDgxOTU3ZWQ0ClsgICAgMC4wMDAwMDBdICAwMDAwMDAwMCAwMDAwMDAwMCBkZWFk
NGVhZCBmZmZmZmZmZiBmZmZmZmZmZiA4MWE4OTIxOCAwMDAwMDAwMCAwMDAwMDAwMApbICAg
IDAuMDAwMDAwXSBDYWxsIFRyYWNlOgpbICAgIDAuMDAwMDAwXSAgWzw4MTAzZDRkOT5dIGt0
aHJlYWRfY3JlYXRlX29uX25vZGUrMHg5MC8weDEwOApbICAgIDAuMDAwMDAwXSAgWzw4MTA2
NWViMT5dIHJjdV9zcGF3bl9vbmVfbm9jYl9rdGhyZWFkKzB4YmEvMHhkYQpbICAgIDAuMDAw
MDAwXSAgWzw4MTA2MzdiND5dID8gcmN1X3N0YXJ0X2Z1dHVyZV9ncCsweDExOC8weDExOApb
ICAgIDAuMDAwMDAwXSAgWzw4MTA2NjAyND5dIHJjdV9jcHVfbm90aWZ5KzB4MTUzLzB4NWI4
ClsgICAgMC4wMDAwMDBdICBbPDgxNjVkMWZiPl0gPyBfX211dGV4X3VubG9ja19zbG93cGF0
aCsweDEwNi8weDExZApbICAgIDAuMDAwMDAwXSAgWzw4MTA2MzFkMz5dID8gY3B1bWFza19u
ZXh0KzB4MjIvMHgyNgpbICAgIDAuMDAwMDAwXSAgWzw4MWExMDhjYz5dIHJjdV9pbml0KzB4
MjkxLzB4MjliClsgICAgMC4wMDAwMDBdICBbPDgxOWZkOTY1Pl0gc3RhcnRfa2VybmVsKzB4
MWZhLzB4MzcyClsgICAgMC4wMDAwMDBdICBbPDgxOWZkNTVkPl0gPyBzZXRfaW5pdF9hcmcr
MHg0OS8weDQ5ClsgICAgMC4wMDAwMDBdICBbPDgxOWZkMmFmPl0gaTM4Nl9zdGFydF9rZXJu
ZWwrMHg3OS8weDdkClsgICAgMC4wMDAwMDBdIENvZGU6IDYxIDAwIGViIDA3IDg5IGYwIGU4
IGQxIGM0IGZmIGZmIGJlIDAxIDAwIDAwIDAwIDhiIDQ1IGYwIDhiIDU1IGVjIGU4IGQ4IGFi
IDYxIDAwIDgzIGM0IDEwIDg5IGYwIDViIDVlIDVmIDVkIGMzIDU1IDg5IGU1IDUzIDg5IGMz
IDw4Yj4gMDAgYTggMGMgNzQgMGYgYmEgZTggMDYgMDAgMDAgYjggYTIgMTggODkgODEgZTgg
ZjMgODQgZmUgZmYKWyAgICAwLjAwMDAwMF0gRUlQOiBbPDgxMDQ0MGNhPl0gd2FrZV91cF9w
cm9jZXNzKzB4Ni8weDJjIFNTOkVTUCAwMDY4OjgxOTU3ZTljClsgICAgMC4wMDAwMDBdIENS
MjogMDAwMDAwMDAwMDAwMDAwMApbICAgIDAuMDAwMDAwXSAtLS1bIGVuZCB0cmFjZSBkYjRi
N2ZkZTc3ODZiYjA3IF0tLS0KWyAgICAwLjAwMDAwMF0gS2VybmVsIHBhbmljIC0gbm90IHN5
bmNpbmc6IEF0dGVtcHRlZCB0byBraWxsIHRoZSBpZGxlIHRhc2shCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWliMS0wNzE4MTY0Ni80MmUxN2IwZDQ3ZjczMzczYzk3MjYxYjYzZWMxZmZl
MWY2OTBkYmY0L2RtZXNnLXF1YW50YWwtdnAtMTU6MjAxNDA3MTgxNzE3MzY6aTM4Ni1yYW5k
Y29uZmlnLWliMS0wNzE4MTY0NjozLjE2LjAtcmM1LTA0NTUxLWc0MmUxN2IwOjIKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2LzQyZTE3YjBkNDdmNzMzNzNjOTcyNjFi
NjNlYzFmZmUxZjY5MGRiZjQvZG1lc2ctcXVhbnRhbC12cC0xNzoyMDE0MDcxODE3MTczNTpp
Mzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2OjMuMTYuMC1yYzUtMDQ1NTEtZzQyZTE3YjA6
Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDYvNDJlMTdiMGQ0N2Y3MzM3
M2M5NzI2MWI2M2VjMWZmZTFmNjkwZGJmNC9kbWVzZy1xdWFudGFsLXZwLTE5OjIwMTQwNzE4
MTcxNzM1OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDY6My4xNi4wLXJjNS0wNDU1MS1n
NDJlMTdiMDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni80MmUxN2Iw
ZDQ3ZjczMzczYzk3MjYxYjYzZWMxZmZlMWY2OTBkYmY0L2RtZXNnLXF1YW50YWwtdnAtMjQ6
MjAxNDA3MTgxNzE3MzU6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0NjozLjE2LjAtcmM1
LTA0NTUxLWc0MmUxN2IwOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2
LzQyZTE3YjBkNDdmNzMzNzNjOTcyNjFiNjNlYzFmZmUxZjY5MGRiZjQvZG1lc2ctcXVhbnRh
bC12cC0yOToyMDE0MDcxODE3MTczNTppMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2OjMu
MTYuMC1yYzUtMDQ1NTEtZzQyZTE3YjA6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEt
MDcxODE2NDYvNDJlMTdiMGQ0N2Y3MzM3M2M5NzI2MWI2M2VjMWZmZTFmNjkwZGJmNC9kbWVz
Zy1xdWFudGFsLXZwLTI6MjAxNDA3MTgxNzE3MzY6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4
MTY0NjozLjE2LjAtcmM1LTA0NTUxLWc0MmUxN2IwOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaWIxLTA3MTgxNjQ2LzQyZTE3YjBkNDdmNzMzNzNjOTcyNjFiNjNlYzFmZmUxZjY5MGRi
ZjQvZG1lc2ctcXVhbnRhbC12cC00OjIwMTQwNzE4MTcxNzM1OmkzODYtcmFuZGNvbmZpZy1p
YjEtMDcxODE2NDY6My4xNi4wLXJjNS0wNDU1MS1nNDJlMTdiMDoyCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWliMS0wNzE4MTY0Ni80MmUxN2IwZDQ3ZjczMzczYzk3MjYxYjYzZWMxZmZl
MWY2OTBkYmY0L2RtZXNnLXF1YW50YWwtdnAtNjoyMDE0MDcxODE3MTczNTppMzg2LXJhbmRj
b25maWctaWIxLTA3MTgxNjQ2OjMuMTYuMC1yYzUtMDQ1NTEtZzQyZTE3YjA6MgowOjg6OCBh
bGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wNy0xOCAxNzoxNzoyNiBS
RVBFQVQgQ09VTlQ6IDIwICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4MC9vYmotYmlzZWN0Ly5y
ZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDIwMSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgOCBzdGVwcykKWzU3MDgwZTBhMjQ3MmFkMzFjNjA5MjE3ZjYzMjky
MzM0MTIzMjE5NzldIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ2Z0cmFjZS9mb3It
bmV4dCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4MC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVz
dHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2L25leHQ6bWFz
dGVyOjU3MDgwZTBhMjQ3MmFkMzFjNjA5MjE3ZjYzMjkyMzM0MTIzMjE5Nzk6YmlzZWN0LWxp
bnV4MAoKMjAxNC0wNy0xOC0xNzoxNzoyOCA1NzA4MGUwYTI0NzJhZDMxYzYwOTIxN2Y2MzI5
MjMzNDEyMzIxOTc5IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRl
c3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDYtNTcwODBlMGEy
NDcyYWQzMWM2MDkyMTdmNjMyOTIzMzQxMjMyMTk3OQpDaGVjayBmb3Iga2VybmVsIGluIC9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni81NzA4MGUwYTI0NzJhZDMxYzYw
OTIxN2Y2MzI5MjMzNDEyMzIxOTc5CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2LTU3MDgw
ZTBhMjQ3MmFkMzFjNjA5MjE3ZjYzMjkyMzM0MTIzMjE5NzkKd2FpdGluZyBmb3IgY29tcGxl
dGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMS1jb25zdW1lci9p
Mzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2LTU3MDgwZTBhMjQ3MmFkMzFjNjA5MjE3ZjYz
MjkyMzM0MTIzMjE5NzkKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcx
ODE2NDYvNTcwODBlMGEyNDcyYWQzMWM2MDkyMTdmNjMyOTIzMzQxMjMyMTk3OS92bWxpbnV6
LTMuMTYuMC1yYzUtMDQ0MTctZzU3MDgwZTAKCjIwMTQtMDctMTgtMTc6MjA6MjggZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgLi4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxMzQgcmV2aXNpb25z
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDggc3RlcHMpClthZTg4NWRlMjMw
YTQ4OTdjMmJjMGIzMjRjYjMyZjIyYzBiN2M5NzQ3XSBNZXJnZSByZW1vdGUtdHJhY2tpbmcg
YnJhbmNoICdrdm0vbGludXgtbmV4dCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4MC9vYmotYmlzZWN0
CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaWIx
LTA3MTgxNjQ2L25leHQ6bWFzdGVyOmFlODg1ZGUyMzBhNDg5N2MyYmMwYjMyNGNiMzJmMjJj
MGI3Yzk3NDc6YmlzZWN0LWxpbnV4MAoKMjAxNC0wNy0xOC0xNzoyMTo1OSBhZTg4NWRlMjMw
YTQ4OTdjMmJjMGIzMjRjYjMyZjIyYzBiN2M5NzQ3IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQg
dGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjEt
MDcxODE2NDYtYWU4ODVkZTIzMGE0ODk3YzJiYzBiMzI0Y2IzMmYyMmMwYjdjOTc0NwpDaGVj
ayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni9h
ZTg4NWRlMjMwYTQ4OTdjMmJjMGIzMjRjYjMyZjIyYzBiN2M5NzQ3CndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWct
aWIxLTA3MTgxNjQ2LWFlODg1ZGUyMzBhNDg5N2MyYmMwYjMyNGNiMzJmMjJjMGI3Yzk3NDcK
d2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xr
cC1oc3gwMS1jb25zdW1lci9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2LWFlODg1ZGUy
MzBhNDg5N2MyYmMwYjMyNGNiMzJmMjJjMGI3Yzk3NDcKa2VybmVsOiAva2VybmVsL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDcxODE2NDYvYWU4ODVkZTIzMGE0ODk3YzJiYzBiMzI0Y2IzMmYy
MmMwYjdjOTc0Ny92bWxpbnV6LTMuMTYuMC1yYzUtMDQ1MTAtZ2FlODg1ZGUKCjIwMTQtMDct
MTgtMTc6Mjg6NTkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLiBURVNUIEZBSUxVUkUKWyAgICAw
LjAwMDAwMF0gQ2hlY2tpbmcgaWYgdGhpcyBwcm9jZXNzb3IgaG9ub3VycyB0aGUgV1AgYml0
IGV2ZW4gaW4gc3VwZXJ2aXNvciBtb2RlLi4uT2suClsgICAgMC4wMDAwMDBdIFByZWVtcHRp
YmxlIGhpZXJhcmNoaWNhbCBSQ1UgaW1wbGVtZW50YXRpb24uClsgICAgMC4wMDAwMDBdIFJD
VTogQWRqdXN0aW5nIGdlb21ldHJ5IGZvciByY3VfZmFub3V0X2xlYWY9MTYsIG5yX2NwdV9p
ZHM9MQpbICAgIDAuMDAwMDAwXSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwg
cG9pbnRlciBkZXJlZmVyZW5jZSBhdCAgIChudWxsKQpbICAgIDAuMDAwMDAwXSBJUDogWzw4
MTA0NDBjYT5dIHdha2VfdXBfcHJvY2VzcysweDYvMHgyYwpbICAgIDAuMDAwMDAwXSAqcGRw
dCA9IDAwMDAwMDAwMDAwMDAwMDAgKnBkZSA9IGYwMDBmZjUzZjAwMGZmNTMgClsgICAgMC4w
MDAwMDBdIE9vcHM6IDAwMDAgWyMxXSBQUkVFTVBUIFNNUCAKWyAgICAwLjAwMDAwMF0gQ1BV
OiAwIFBJRDogMCBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xNi4wLXJjNS0wNDUx
MC1nYWU4ODVkZSAjNQpbICAgIDAuMDAwMDAwXSB0YXNrOiA4MTk2MTgzMCB0aTogODE5NTYw
MDAgdGFzay50aTogODE5NTYwMDAKWyAgICAwLjAwMDAwMF0gRUlQOiAwMDYwOls8ODEwNDQw
Y2E+XSBFRkxBR1M6IDAwMjEwMDgyIENQVTogMApbICAgIDAuMDAwMDAwXSBFSVAgaXMgYXQg
d2FrZV91cF9wcm9jZXNzKzB4Ni8weDJjClsgICAgMC4wMDAwMDBdIEVBWDogMDAwMDAwMDAg
RUJYOiAwMDAwMDAwMCBFQ1g6IDAwMDAwMDAwIEVEWDogMDAwMDAwMDIKWyAgICAwLjAwMDAw
MF0gRVNJOiA5MzQwNDYyMCBFREk6IDgxOTU3ZWRjIEVCUDogODE5NTdlYTAgRVNQOiA4MTk1
N2U5YwpbICAgIDAuMDAwMDAwXSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6IDAw
MDAgU1M6IDAwNjgKWyAgICAwLjAwMDAwMF0gQ1IwOiA4MDA1MDAzYiBDUjI6IDAwMDAwMDAw
IENSMzogMDFhN2QwMDAgQ1I0OiAwMDAwMDZiMApbICAgIDAuMDAwMDAwXSBTdGFjazoKWyAg
ICAwLjAwMDAwMF0gIDgxOTU3ZWIwIDgxOTU3ZjE0IDgxMDNkNGQ5IDAwMDAwMDAyIDAwMDAw
MDAwIDAwMDAwMDAwIDAwMDAwMDAwIGRlYWQ0ZWFkClsgICAgMC4wMDAwMDBdICBmZmZmZmZm
ZiBmZmZmZmZmZiA4MWE4OTIxOCAwMDAwMDAwMCAwMDAwMDAwMCA4MTg4ZmZlOSA4MTk1N2Vk
NCA4MTk1N2VkNApbICAgIDAuMDAwMDAwXSAgMDAwMDAwMDAgMDAwMDAwMDAgZGVhZDRlYWQg
ZmZmZmZmZmYgZmZmZmZmZmYgODFhODkyMTggMDAwMDAwMDAgMDAwMDAwMDAKWyAgICAwLjAw
MDAwMF0gQ2FsbCBUcmFjZToKWyAgICAwLjAwMDAwMF0gIFs8ODEwM2Q0ZDk+XSBrdGhyZWFk
X2NyZWF0ZV9vbl9ub2RlKzB4OTAvMHgxMDgKWyAgICAwLjAwMDAwMF0gIFs8ODEwNjVlYjE+
XSByY3Vfc3Bhd25fb25lX25vY2Jfa3RocmVhZCsweGJhLzB4ZGEKWyAgICAwLjAwMDAwMF0g
IFs8ODEwNjM3YjQ+XSA/IHJjdV9zdGFydF9mdXR1cmVfZ3ArMHgxMTgvMHgxMTgKWyAgICAw
LjAwMDAwMF0gIFs8ODEwNjYwMjQ+XSByY3VfY3B1X25vdGlmeSsweDE1My8weDViOApbICAg
IDAuMDAwMDAwXSAgWzw4MTY1ZDFmYj5dID8gX19tdXRleF91bmxvY2tfc2xvd3BhdGgrMHgx
MDYvMHgxMWQKWyAgICAwLjAwMDAwMF0gIFs8ODEwNjMxZDM+XSA/IGNwdW1hc2tfbmV4dCsw
eDIyLzB4MjYKWyAgICAwLjAwMDAwMF0gIFs8ODFhMTA4Y2M+XSByY3VfaW5pdCsweDI5MS8w
eDI5YgpbICAgIDAuMDAwMDAwXSAgWzw4MTlmZDk2NT5dIHN0YXJ0X2tlcm5lbCsweDFmYS8w
eDM3MgpbICAgIDAuMDAwMDAwXSAgWzw4MTlmZDU1ZD5dID8gc2V0X2luaXRfYXJnKzB4NDkv
MHg0OQpbICAgIDAuMDAwMDAwXSAgWzw4MTlmZDJhZj5dIGkzODZfc3RhcnRfa2VybmVsKzB4
NzkvMHg3ZApbICAgIDAuMDAwMDAwXSBDb2RlOiA2MSAwMCBlYiAwNyA4OSBmMCBlOCBkMSBj
NCBmZiBmZiBiZSAwMSAwMCAwMCAwMCA4YiA0NSBmMCA4YiA1NSBlYyBlOCBkOCBhYiA2MSAw
MCA4MyBjNCAxMCA4OSBmMCA1YiA1ZSA1ZiA1ZCBjMyA1NSA4OSBlNSA1MyA4OSBjMyA8OGI+
IDAwIGE4IDBjIDc0IDBmIGJhIGU4IDA2IDAwIDAwIGI4IGEyIDE4IDg5IDgxIGU4IGYzIDg0
IGZlIGZmClsgICAgMC4wMDAwMDBdIEVJUDogWzw4MTA0NDBjYT5dIHdha2VfdXBfcHJvY2Vz
cysweDYvMHgyYyBTUzpFU1AgMDA2ODo4MTk1N2U5YwpbICAgIDAuMDAwMDAwXSBDUjI6IDAw
MDAwMDAwMDAwMDAwMDAKWyAgICAwLjAwMDAwMF0gLS0tWyBlbmQgdHJhY2UgZGI0YjdmZGU3
Nzg2YmIwNyBdLS0tClsgICAgMC4wMDAwMDBdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5n
OiBBdHRlbXB0ZWQgdG8ga2lsbCB0aGUgaWRsZSB0YXNrIQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1pYjEtMDcxODE2NDYvYWU4ODVkZTIzMGE0ODk3YzJiYzBiMzI0Y2IzMmYyMmMwYjdj
OTc0Ny9kbWVzZy15b2N0by12cC0xMDoyMDE0MDcxODE3MjkyNjppMzg2LXJhbmRjb25maWct
aWIxLTA3MTgxNjQ2OjMuMTYuMC1yYzUtMDQ1MTAtZ2FlODg1ZGU6NQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDcxODE2NDYvYWU4ODVkZTIzMGE0ODk3YzJiYzBiMzI0Y2IzMmYy
MmMwYjdjOTc0Ny9kbWVzZy15b2N0by12cC0xNToyMDE0MDcxODE3MjkyNjppMzg2LXJhbmRj
b25maWctaWIxLTA3MTgxNjQ2OjMuMTYuMC1yYzUtMDQ1MTAtZ2FlODg1ZGU6NQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDYvYWU4ODVkZTIzMGE0ODk3YzJiYzBiMzI0
Y2IzMmYyMmMwYjdjOTc0Ny9kbWVzZy15b2N0by12cC0xNzoyMDE0MDcxODE3MjkyNDppMzg2
LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2OjMuMTYuMC1yYzUtMDQ1MTAtZ2FlODg1ZGU6NQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDYvYWU4ODVkZTIzMGE0ODk3YzJi
YzBiMzI0Y2IzMmYyMmMwYjdjOTc0Ny9kbWVzZy15b2N0by12cC0xOjIwMTQwNzE4MTcyOTI0
OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDY6My4xNi4wLXJjNS0wNDUxMC1nYWU4ODVk
ZTo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni9hZTg4NWRlMjMwYTQ4
OTdjMmJjMGIzMjRjYjMyZjIyYzBiN2M5NzQ3L2RtZXNnLXlvY3RvLXZwLTI2OjIwMTQwNzE4
MTcyOTI1OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDY6My4xNi4wLXJjNS0wNDUxMC1n
YWU4ODVkZTo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni9hZTg4NWRl
MjMwYTQ4OTdjMmJjMGIzMjRjYjMyZjIyYzBiN2M5NzQ3L2RtZXNnLXlvY3RvLXZwLTM0OjIw
MTQwNzE4MTcyOTI1OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDY6My4xNi4wLXJjNS0w
NDUxMC1nYWU4ODVkZTo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni9h
ZTg4NWRlMjMwYTQ4OTdjMmJjMGIzMjRjYjMyZjIyYzBiN2M5NzQ3L2RtZXNnLXlvY3RvLXZw
LTM4OjIwMTQwNzE4MTcyOTI4OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDY6My4xNi4w
LXJjNS0wNDUxMC1nYWU4ODVkZTo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4
MTY0Ni9hZTg4NWRlMjMwYTQ4OTdjMmJjMGIzMjRjYjMyZjIyYzBiN2M5NzQ3L2RtZXNnLXlv
Y3RvLXZwLTM6MjAxNDA3MTgxNzI5Mjg6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Njoz
LjE2LjAtcmM1LTA0NTEwLWdhZTg4NWRlOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIx
LTA3MTgxNjQ2L2FlODg1ZGUyMzBhNDg5N2MyYmMwYjMyNGNiMzJmMjJjMGI3Yzk3NDcvZG1l
c2cteW9jdG8tdnAtNDA6MjAxNDA3MTgxNzI5Mjg6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4
MTY0NjozLjE2LjAtcmM1LTA0NTEwLWdhZTg4NWRlOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaWIxLTA3MTgxNjQ2L2FlODg1ZGUyMzBhNDg5N2MyYmMwYjMyNGNiMzJmMjJjMGI3Yzk3
NDcvZG1lc2cteW9jdG8tdnAtNDE6MjAxNDA3MTgxNzI5Mjg6aTM4Ni1yYW5kY29uZmlnLWli
MS0wNzE4MTY0NjozLjE2LjAtcmM1LTA0NTEwLWdhZTg4NWRlOjUKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctaWIxLTA3MTgxNjQ2L2FlODg1ZGUyMzBhNDg5N2MyYmMwYjMyNGNiMzJmMjJj
MGI3Yzk3NDcvZG1lc2cteW9jdG8tdnAtNDI6MjAxNDA3MTgxNzI5MjU6aTM4Ni1yYW5kY29u
ZmlnLWliMS0wNzE4MTY0NjozLjE2LjAtcmM1LTA0NTEwLWdhZTg4NWRlOjUKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2L2FlODg1ZGUyMzBhNDg5N2MyYmMwYjMyNGNi
MzJmMjJjMGI3Yzk3NDcvZG1lc2cteW9jdG8tdnAtNDU6MjAxNDA3MTgxNzI5Mjg6aTM4Ni1y
YW5kY29uZmlnLWliMS0wNzE4MTY0NjozLjE2LjAtcmM1LTA0NTEwLWdhZTg4NWRlOjUKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2L2FlODg1ZGUyMzBhNDg5N2MyYmMw
YjMyNGNiMzJmMjJjMGI3Yzk3NDcvZG1lc2cteW9jdG8tdnAtNDc6MjAxNDA3MTgxNzI5Mjg6
aTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0NjozLjE2LjAtcmM1LTA0NTEwLWdhZTg4NWRl
OjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2L2FlODg1ZGUyMzBhNDg5
N2MyYmMwYjMyNGNiMzJmMjJjMGI3Yzk3NDcvZG1lc2cteW9jdG8tdnAtNDg6MjAxNDA3MTgx
NzI5Mjg6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0NjozLjE2LjAtcmM1LTA0NTEwLWdh
ZTg4NWRlOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2L2FlODg1ZGUy
MzBhNDg5N2MyYmMwYjMyNGNiMzJmMjJjMGI3Yzk3NDcvZG1lc2cteW9jdG8tdnAtNTM6MjAx
NDA3MTgxNzI5MjY6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0NjozLjE2LjAtcmM1LTA0
NTEwLWdhZTg4NWRlOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2L2Fl
ODg1ZGUyMzBhNDg5N2MyYmMwYjMyNGNiMzJmMjJjMGI3Yzk3NDcvZG1lc2cteW9jdG8tdnAt
NTU6MjAxNDA3MTgxNzI5MjY6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0NjozLjE2LjAt
cmM1LTA0NTEwLWdhZTg4NWRlOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgx
NjQ2L2FlODg1ZGUyMzBhNDg5N2MyYmMwYjMyNGNiMzJmMjJjMGI3Yzk3NDcvZG1lc2cteW9j
dG8tdnAtNTg6MjAxNDA3MTgxNzI5Mjg6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Njoz
LjE2LjAtcmM1LTA0NTEwLWdhZTg4NWRlOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIx
LTA3MTgxNjQ2L2FlODg1ZGUyMzBhNDg5N2MyYmMwYjMyNGNiMzJmMjJjMGI3Yzk3NDcvZG1l
c2cteW9jdG8tdnAtNjQ6MjAxNDA3MTgxNzI5MjU6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4
MTY0NjozLjE2LjAtcmM1LTA0NTEwLWdhZTg4NWRlOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaWIxLTA3MTgxNjQ2L2FlODg1ZGUyMzBhNDg5N2MyYmMwYjMyNGNiMzJmMjJjMGI3Yzk3
NDcvZG1lc2cteW9jdG8tdnAtNjoyMDE0MDcxODE3MjkyODppMzg2LXJhbmRjb25maWctaWIx
LTA3MTgxNjQ2OjMuMTYuMC1yYzUtMDQ1MTAtZ2FlODg1ZGU6NQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1pYjEtMDcxODE2NDYvYWU4ODVkZTIzMGE0ODk3YzJiYzBiMzI0Y2IzMmYyMmMw
YjdjOTc0Ny9kbWVzZy15b2N0by12cC04OjIwMTQwNzE4MTcyOTI2OmkzODYtcmFuZGNvbmZp
Zy1pYjEtMDcxODE2NDY6My4xNi4wLXJjNS0wNDUxMC1nYWU4ODVkZTo1CjA6MjA6MjAgYWxs
X2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDctMTggMTc6Mjk6MjkgUkVQ
RUFUIENPVU5UOiAyMCAgIyAvYy9ib290LWJpc2VjdC9saW51eDAvb2JqLWJpc2VjdC8ucmVw
ZWF0G1swbQoKQmlzZWN0aW5nOiA5MyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgNyBzdGVwcykKW2Y2Mzc4MmY2OTUzMTc2Mjc2YWIwODk0MzRlOWI4ZmJl
NjcyMTY3ZmZdIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ3JjdS9yY3UvbmV4dCcK
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9j
L2Jvb3QtYmlzZWN0L2xpbnV4MC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVu
LXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2L25leHQ6bWFzdGVyOmY2
Mzc4MmY2OTUzMTc2Mjc2YWIwODk0MzRlOWI4ZmJlNjcyMTY3ZmY6YmlzZWN0LWxpbnV4MAoK
MjAxNC0wNy0xOC0xNzoyOTozMCBmNjM3ODJmNjk1MzE3NjI3NmFiMDg5NDM0ZTliOGZiZTY3
MjE2N2ZmIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDYtZjYzNzgyZjY5NTMxNzYy
NzZhYjA4OTQzNGU5YjhmYmU2NzIxNjdmZgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni9mNjM3ODJmNjk1MzE3NjI3NmFiMDg5NDM0
ZTliOGZiZTY3MjE2N2ZmCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2LWY2Mzc4MmY2OTUz
MTc2Mjc2YWIwODk0MzRlOWI4ZmJlNjcyMTY3ZmYKa2VybmVsOiAva2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1pYjEtMDcxODE2NDYvZjYzNzgyZjY5NTMxNzYyNzZhYjA4OTQzNGU5YjhmYmU2
NzIxNjdmZi92bWxpbnV6LTMuMTYuMC1yYzUtMDQ0NzEtZ2Y2Mzc4MmYKCjIwMTQtMDctMTgt
MTc6MzE6MzAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLiBURVNUIEZBSUxVUkUKWyAgICAwLjAw
MDAwMF0gQ2hlY2tpbmcgaWYgdGhpcyBwcm9jZXNzb3IgaG9ub3VycyB0aGUgV1AgYml0IGV2
ZW4gaW4gc3VwZXJ2aXNvciBtb2RlLi4uT2suClsgICAgMC4wMDAwMDBdIFByZWVtcHRpYmxl
IGhpZXJhcmNoaWNhbCBSQ1UgaW1wbGVtZW50YXRpb24uClsgICAgMC4wMDAwMDBdIFJDVTog
QWRqdXN0aW5nIGdlb21ldHJ5IGZvciByY3VfZmFub3V0X2xlYWY9MTYsIG5yX2NwdV9pZHM9
MQpbICAgIDAuMDAwMDAwXSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9p
bnRlciBkZXJlZmVyZW5jZSBhdCAgIChudWxsKQpbICAgIDAuMDAwMDAwXSBJUDogWzw4MTA0
NDBjYT5dIHdha2VfdXBfcHJvY2VzcysweDYvMHgyYwpbICAgIDAuMDAwMDAwXSAqcGRwdCA9
IDAwMDAwMDAwMDAwMDAwMDAgKnBkZSA9IGYwMDBmZjUzZjAwMGZmNTMgClsgICAgMC4wMDAw
MDBdIE9vcHM6IDAwMDAgWyMxXSBQUkVFTVBUIFNNUCAKWyAgICAwLjAwMDAwMF0gQ1BVOiAw
IFBJRDogMCBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xNi4wLXJjNS0wNDQ3MS1n
ZjYzNzgyZiAjNgpbICAgIDAuMDAwMDAwXSB0YXNrOiA4MTk2MTgzMCB0aTogODE5NTYwMDAg
dGFzay50aTogODE5NTYwMDAKWyAgICAwLjAwMDAwMF0gRUlQOiAwMDYwOls8ODEwNDQwY2E+
XSBFRkxBR1M6IDAwMjEwMDgyIENQVTogMApbICAgIDAuMDAwMDAwXSBFSVAgaXMgYXQgd2Fr
ZV91cF9wcm9jZXNzKzB4Ni8weDJjClsgICAgMC4wMDAwMDBdIEVBWDogMDAwMDAwMDAgRUJY
OiAwMDAwMDAwMCBFQ1g6IDAwMDAwMDAwIEVEWDogMDAwMDAwMDIKWyAgICAwLjAwMDAwMF0g
RVNJOiA5MzQwNDYyMCBFREk6IDgxOTU3ZWRjIEVCUDogODE5NTdlYTAgRVNQOiA4MTk1N2U5
YwpbICAgIDAuMDAwMDAwXSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6IDAwMDAg
U1M6IDAwNjgKWyAgICAwLjAwMDAwMF0gQ1IwOiA4MDA1MDAzYiBDUjI6IDAwMDAwMDAwIENS
MzogMDFhN2QwMDAgQ1I0OiAwMDAwMDZiMApbICAgIDAuMDAwMDAwXSBTdGFjazoKWyAgICAw
LjAwMDAwMF0gIDgxOTU3ZWIwIDgxOTU3ZjE0IDgxMDNkNGQ5IDAwMDAwMDAyIDAwMDAwMDAw
IDAwMDAwMDAwIDAwMDAwMDAwIGRlYWQ0ZWFkClsgICAgMC4wMDAwMDBdICBmZmZmZmZmZiBm
ZmZmZmZmZiA4MWE4OTIxOCAwMDAwMDAwMCAwMDAwMDAwMCA4MTg4ZmZlOSA4MTk1N2VkNCA4
MTk1N2VkNApbICAgIDAuMDAwMDAwXSAgMDAwMDAwMDAgMDAwMDAwMDAgZGVhZDRlYWQgZmZm
ZmZmZmYgZmZmZmZmZmYgODFhODkyMTggMDAwMDAwMDAgMDAwMDAwMDAKWyAgICAwLjAwMDAw
MF0gQ2FsbCBUcmFjZToKWyAgICAwLjAwMDAwMF0gIFs8ODEwM2Q0ZDk+XSBrdGhyZWFkX2Ny
ZWF0ZV9vbl9ub2RlKzB4OTAvMHgxMDgKWyAgICAwLjAwMDAwMF0gIFs8ODEwNjVlYjE+XSBy
Y3Vfc3Bhd25fb25lX25vY2Jfa3RocmVhZCsweGJhLzB4ZGEKWyAgICAwLjAwMDAwMF0gIFs8
ODEwNjM3YjQ+XSA/IHJjdV9zdGFydF9mdXR1cmVfZ3ArMHgxMTgvMHgxMTgKWyAgICAwLjAw
MDAwMF0gIFs8ODEwNjYwMjQ+XSByY3VfY3B1X25vdGlmeSsweDE1My8weDViOApbICAgIDAu
MDAwMDAwXSAgWzw4MTY1ZDFmYj5dID8gX19tdXRleF91bmxvY2tfc2xvd3BhdGgrMHgxMDYv
MHgxMWQKWyAgICAwLjAwMDAwMF0gIFs8ODEwNjMxZDM+XSA/IGNwdW1hc2tfbmV4dCsweDIy
LzB4MjYKWyAgICAwLjAwMDAwMF0gIFs8ODFhMTA4Y2M+XSByY3VfaW5pdCsweDI5MS8weDI5
YgpbICAgIDAuMDAwMDAwXSAgWzw4MTlmZDk2NT5dIHN0YXJ0X2tlcm5lbCsweDFmYS8weDM3
MgpbICAgIDAuMDAwMDAwXSAgWzw4MTlmZDU1ZD5dID8gc2V0X2luaXRfYXJnKzB4NDkvMHg0
OQpbICAgIDAuMDAwMDAwXSAgWzw4MTlmZDJhZj5dIGkzODZfc3RhcnRfa2VybmVsKzB4Nzkv
MHg3ZApbICAgIDAuMDAwMDAwXSBDb2RlOiA2MSAwMCBlYiAwNyA4OSBmMCBlOCBkMSBjNCBm
ZiBmZiBiZSAwMSAwMCAwMCAwMCA4YiA0NSBmMCA4YiA1NSBlYyBlOCBkOCBhYiA2MSAwMCA4
MyBjNCAxMCA4OSBmMCA1YiA1ZSA1ZiA1ZCBjMyA1NSA4OSBlNSA1MyA4OSBjMyA8OGI+IDAw
IGE4IDBjIDc0IDBmIGJhIGU4IDA2IDAwIDAwIGI4IGEyIDE4IDg5IDgxIGU4IGYzIDg0IGZl
IGZmClsgICAgMC4wMDAwMDBdIEVJUDogWzw4MTA0NDBjYT5dIHdha2VfdXBfcHJvY2Vzcysw
eDYvMHgyYyBTUzpFU1AgMDA2ODo4MTk1N2U5YwpbICAgIDAuMDAwMDAwXSBDUjI6IDAwMDAw
MDAwMDAwMDAwMDAKWyAgICAwLjAwMDAwMF0gLS0tWyBlbmQgdHJhY2UgZGI0YjdmZGU3Nzg2
YmIwNyBdLS0tClsgICAgMC4wMDAwMDBdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBB
dHRlbXB0ZWQgdG8ga2lsbCB0aGUgaWRsZSB0YXNrIQova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1pYjEtMDcxODE2NDYvZjYzNzgyZjY5NTMxNzYyNzZhYjA4OTQzNGU5YjhmYmU2NzIxNjdm
Zi9kbWVzZy15b2N0by12cC0xMDoyMDE0MDcxODE3MzA1MzppMzg2LXJhbmRjb25maWctaWIx
LTA3MTgxNjQ2OjMuMTYuMC1yYzUtMDQ0NzEtZ2Y2Mzc4MmY6Ngova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1pYjEtMDcxODE2NDYvZjYzNzgyZjY5NTMxNzYyNzZhYjA4OTQzNGU5YjhmYmU2
NzIxNjdmZi9kbWVzZy15b2N0by12cC0xNToyMDE0MDcxODE3MzA1NTppMzg2LXJhbmRjb25m
aWctaWIxLTA3MTgxNjQ2OjMuMTYuMC1yYzUtMDQ0NzEtZ2Y2Mzc4MmY6Ngova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDYvZjYzNzgyZjY5NTMxNzYyNzZhYjA4OTQzNGU5
YjhmYmU2NzIxNjdmZi9kbWVzZy15b2N0by12cC0xNzoyMDE0MDcxODE3MzA1NTppMzg2LXJh
bmRjb25maWctaWIxLTA3MTgxNjQ2OjMuMTYuMC1yYzUtMDQ0NzEtZ2Y2Mzc4MmY6Ngova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDYvZjYzNzgyZjY5NTMxNzYyNzZhYjA4
OTQzNGU5YjhmYmU2NzIxNjdmZi9kbWVzZy15b2N0by12cC0yNDoyMDE0MDcxODE3MzA1Mzpp
Mzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2OjMuMTYuMC1yYzUtMDQ0NzEtZ2Y2Mzc4MmY6
Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDYvZjYzNzgyZjY5NTMxNzYy
NzZhYjA4OTQzNGU5YjhmYmU2NzIxNjdmZi9kbWVzZy15b2N0by12cC0zMjoyMDE0MDcxODE3
MzA1NDppMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2OjMuMTYuMC1yYzUtMDQ0NzEtZ2Y2
Mzc4MmY6Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDYvZjYzNzgyZjY5
NTMxNzYyNzZhYjA4OTQzNGU5YjhmYmU2NzIxNjdmZi9kbWVzZy15b2N0by12cC0zOjIwMTQw
NzE4MTczMDU1OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDY6My4xNi4wLXJjNS0wNDQ3
MS1nZjYzNzgyZjo2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni9mNjM3
ODJmNjk1MzE3NjI3NmFiMDg5NDM0ZTliOGZiZTY3MjE2N2ZmL2RtZXNnLXlvY3RvLXZwLTQ2
OjIwMTQwNzE4MTczMDU1OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDY6My4xNi4wLXJj
NS0wNDQ3MS1nZjYzNzgyZjo2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0
Ni9mNjM3ODJmNjk1MzE3NjI3NmFiMDg5NDM0ZTliOGZiZTY3MjE2N2ZmL2RtZXNnLXlvY3Rv
LXZwLTUxOjIwMTQwNzE4MTczMDU1OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDY6My4x
Ni4wLXJjNS0wNDQ3MS1nZjYzNzgyZjo2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0w
NzE4MTY0Ni9mNjM3ODJmNjk1MzE3NjI3NmFiMDg5NDM0ZTliOGZiZTY3MjE2N2ZmL2RtZXNn
LXlvY3RvLXZwLTUyOjIwMTQwNzE4MTczMDUzOmkzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2
NDY6My4xNi4wLXJjNS0wNDQ3MS1nZjYzNzgyZjo2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWliMS0wNzE4MTY0Ni9mNjM3ODJmNjk1MzE3NjI3NmFiMDg5NDM0ZTliOGZiZTY3MjE2N2Zm
L2RtZXNnLXlvY3RvLXZwLTU0OjIwMTQwNzE4MTczMDU1OmkzODYtcmFuZGNvbmZpZy1pYjEt
MDcxODE2NDY6My4xNi4wLXJjNS0wNDQ3MS1nZjYzNzgyZjo2Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWliMS0wNzE4MTY0Ni9mNjM3ODJmNjk1MzE3NjI3NmFiMDg5NDM0ZTliOGZiZTY3
MjE2N2ZmL2RtZXNnLXlvY3RvLXZwLTU1OjIwMTQwNzE4MTczMDUzOmkzODYtcmFuZGNvbmZp
Zy1pYjEtMDcxODE2NDY6My4xNi4wLXJjNS0wNDQ3MS1nZjYzNzgyZjo2Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni9mNjM3ODJmNjk1MzE3NjI3NmFiMDg5NDM0ZTli
OGZiZTY3MjE2N2ZmL2RtZXNnLXlvY3RvLXZwLTU2OjIwMTQwNzE4MTczMDUzOmkzODYtcmFu
ZGNvbmZpZy1pYjEtMDcxODE2NDY6My4xNi4wLXJjNS0wNDQ3MS1nZjYzNzgyZjo2Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni9mNjM3ODJmNjk1MzE3NjI3NmFiMDg5
NDM0ZTliOGZiZTY3MjE2N2ZmL2RtZXNnLXlvY3RvLXZwLTU5OjIwMTQwNzE4MTczMDU1Omkz
ODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDY6My4xNi4wLXJjNS0wNDQ3MS1nZjYzNzgyZjo2
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni9mNjM3ODJmNjk1MzE3NjI3
NmFiMDg5NDM0ZTliOGZiZTY3MjE2N2ZmL2RtZXNnLXlvY3RvLXZwLTU6MjAxNDA3MTgxNzMw
NTU6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0NjozLjE2LjAtcmM1LTA0NDcxLWdmNjM3
ODJmOjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2L2Y2Mzc4MmY2OTUz
MTc2Mjc2YWIwODk0MzRlOWI4ZmJlNjcyMTY3ZmYvZG1lc2cteW9jdG8tdnAtNjE6MjAxNDA3
MTgxNzMwNTU6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0NjozLjE2LjAtcmM1LTA0NDcx
LWdmNjM3ODJmOjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2L2Y2Mzc4
MmY2OTUzMTc2Mjc2YWIwODk0MzRlOWI4ZmJlNjcyMTY3ZmYvZG1lc2cteW9jdG8tdnAtNjM6
MjAxNDA3MTgxNzMwNTU6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0NjozLjE2LjAtcmM1
LTA0NDcxLWdmNjM3ODJmOjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2
L2Y2Mzc4MmY2OTUzMTc2Mjc2YWIwODk0MzRlOWI4ZmJlNjcyMTY3ZmYvZG1lc2cteW9jdG8t
dnAtNzoyMDE0MDcxODE3MzA1MzppMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2OjMuMTYu
MC1yYzUtMDQ0NzEtZ2Y2Mzc4MmY6Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcx
ODE2NDYvZjYzNzgyZjY5NTMxNzYyNzZhYjA4OTQzNGU5YjhmYmU2NzIxNjdmZi9kbWVzZy15
b2N0by12cC04OjIwMTQwNzE4MTczMDUzOmkzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDY6
My4xNi4wLXJjNS0wNDQ3MS1nZjYzNzgyZjo2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWli
MS0wNzE4MTY0Ni9mNjM3ODJmNjk1MzE3NjI3NmFiMDg5NDM0ZTliOGZiZTY3MjE2N2ZmL2Rt
ZXNnLXlvY3RvLXZwLTM3OjIwMTQwNzE4MTczMDU3OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcx
ODE2NDY6My4xNi4wLXJjNS0wNDQ3MS1nZjYzNzgyZjo2Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWliMS0wNzE4MTY0Ni9mNjM3ODJmNjk1MzE3NjI3NmFiMDg5NDM0ZTliOGZiZTY3MjE2
N2ZmL2RtZXNnLXlvY3RvLXZwLTQwOjIwMTQwNzE4MTczMDU2OmkzODYtcmFuZGNvbmZpZy1p
YjEtMDcxODE2NDY6My4xNi4wLXJjNS0wNDQ3MS1nZjYzNzgyZjo2CjA6MjA6MjAgYWxsX2dv
b2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDctMTggMTc6MzI6MDAgUkVQRUFU
IENPVU5UOiAyMCAgIyAvYy9ib290LWJpc2VjdC9saW51eDAvb2JqLWJpc2VjdC8ucmVwZWF0
G1swbQoKbGluZWFyLWJpc2VjdDogYmFkIGJyYW5jaCBtYXkgYmUgcmVtb3RlLXRyYWNraW5n
IGJyYW5jaCAncmN1L3JjdS9uZXh0JwpsaW5lYXItYmlzZWN0OiBoYW5kbGUgb3ZlciB0byBn
aXQgYmlzZWN0CmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3Qgc3RhcnQgZjYzNzgyZjY5NTMx
NzYyNzZhYjA4OTQzNGU5YjhmYmU2NzIxNjdmZiA1NzA4MGUwYTI0NzJhZDMxYzYwOTIxN2Y2
MzI5MjMzNDEyMzIxOTc5IC0tClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIGY2Mzc4MmYu
Li4gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAncmN1L3JjdS9uZXh0JwpIRUFEIGlz
IG5vdyBhdCBlMjQ0N2M1Li4uIE1lcmdlICdjcnlwdG9kZXYvbWFzdGVyJyBpbnRvIGRldmVs
LWhvdXJseS0yMDE0MDYyNzEzCkJpc2VjdGluZzogMjEgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDUgc3RlcHMpClsxODIzMTcyYWI1ODJlYjU0NDU2ZmQx
MzU0ODY5YmI4NTBhMTE5NmJhXSBNZXJnZSBicmFuY2hlcyAnZG9jLjIwMTQuMDcuMDhhJywg
J2ZpeGVzLjIwMTQuMDcuMDlhJywgJ21haW50YWluZXJzLjIwMTQuMDcuMDhiJywgJ25vY2Jz
LjIwMTQuMDcuMDdhJyBhbmQgJ3RvcnR1cmUuMjAxNC4wNy4wN2EnIGludG8gSEVBRApsaW5l
YXItYmlzZWN0OiBnaXQgYmlzZWN0IHJ1biAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4MC9vYmotYmlzZWN0CnJ1bm5p
bmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290
LWJpc2VjdC9saW51eDAvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni9uZXh0Om1hc3RlcjoxODIzMTcy
YWI1ODJlYjU0NDU2ZmQxMzU0ODY5YmI4NTBhMTE5NmJhOmJpc2VjdC1saW51eDAKCjIwMTQt
MDctMTgtMTc6MzI6MDUgMTgyMzE3MmFiNTgyZWI1NDQ1NmZkMTM1NDg2OWJiODUwYTExOTZi
YSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2LTE4MjMxNzJhYjU4MmViNTQ0NTZm
ZDEzNTQ4NjliYjg1MGExMTk2YmEKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDcxODE2NDYvMTgyMzE3MmFiNTgyZWI1NDQ1NmZkMTM1NDg2OWJi
ODUwYTExOTZiYQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVp
bGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni0xODIzMTcyYWI1ODJlYjU0
NDU2ZmQxMzU0ODY5YmI4NTBhMTE5NmJhCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2ti
dWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDEtY29uc3VtZXIvaTM4Ni1yYW5kY29u
ZmlnLWliMS0wNzE4MTY0Ni0xODIzMTcyYWI1ODJlYjU0NDU2ZmQxMzU0ODY5YmI4NTBhMTE5
NmJhCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2LzE4MjMx
NzJhYjU4MmViNTQ0NTZmZDEzNTQ4NjliYjg1MGExMTk2YmEvdm1saW51ei0zLjE2LjAtcmMx
LTAwMDM0LWcxODIzMTcyCgoyMDE0LTA3LTE4LTE3OjM2OjA1IGRldGVjdGluZyBib290IHN0
YXRlIC4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0
IGFmdGVyIHRoaXMgKHJvdWdobHkgNCBzdGVwcykKWzUzMWY3MDM5NmFmN2E0YzRkYTczM2Rk
ODIwYWY0Mjg5ZTg4N2QwYzJdIHJjdTogUmV0dXJuIGJvb2wgdHlwZSBpbiByY3VfbG9ja2Rl
cF9jdXJyZW50X2NwdV9vbmxpbmUoKQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgwL29iai1iaXNlY3QK
bHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pYjEt
MDcxODE2NDYvbmV4dDptYXN0ZXI6NTMxZjcwMzk2YWY3YTRjNGRhNzMzZGQ4MjBhZjQyODll
ODg3ZDBjMjpiaXNlY3QtbGludXgwCgoyMDE0LTA3LTE4LTE3OjM3OjA1IDUzMWY3MDM5NmFm
N2E0YzRkYTczM2RkODIwYWY0Mjg5ZTg4N2QwYzIgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0
YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWliMS0w
NzE4MTY0Ni01MzFmNzAzOTZhZjdhNGM0ZGE3MzNkZDgyMGFmNDI4OWU4ODdkMGMyCkNoZWNr
IGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2LzUz
MWY3MDM5NmFmN2E0YzRkYTczM2RkODIwYWY0Mjg5ZTg4N2QwYzIKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1p
YjEtMDcxODE2NDYtNTMxZjcwMzk2YWY3YTRjNGRhNzMzZGQ4MjBhZjQyODllODg3ZDBjMgpr
ZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni81MzFmNzAzOTZh
ZjdhNGM0ZGE3MzNkZDgyMGFmNDI4OWU4ODdkMGMyL3ZtbGludXotMy4xNi4wLXJjMS0wMDA0
NS1nNTMxZjcwMwoKMjAxNC0wNy0xOC0xNzo1MDowNSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJ
MTMJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA1IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0
ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbNzhkOWIyOWE5NmI2MzJjMDBmZTgxMzZkYWNi
OWEzOTUzMjQ2OWY4MV0gcmN1OiBSYXRpb25hbGl6ZSBrdGhyZWFkIHNwYXduaW5nCnJ1bm5p
bmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290
LWJpc2VjdC9saW51eDAvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni9uZXh0Om1hc3Rlcjo3OGQ5YjI5
YTk2YjYzMmMwMGZlODEzNmRhY2I5YTM5NTMyNDY5ZjgxOmJpc2VjdC1saW51eDAKCjIwMTQt
MDctMTgtMTc6NTE6MDYgNzhkOWIyOWE5NmI2MzJjMDBmZTgxMzZkYWNiOWEzOTUzMjQ2OWY4
MSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2LTc4ZDliMjlhOTZiNjMyYzAwZmU4
MTM2ZGFjYjlhMzk1MzI0NjlmODEKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDcxODE2NDYvNzhkOWIyOWE5NmI2MzJjMDBmZTgxMzZkYWNiOWEz
OTUzMjQ2OWY4MQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVp
bGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni03OGQ5YjI5YTk2YjYzMmMw
MGZlODEzNmRhY2I5YTM5NTMyNDY5ZjgxCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2ti
dWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9qYWtldG93bi1jb25zdW1lci9pMzg2LXJhbmRjb25m
aWctaWIxLTA3MTgxNjQ2LTc4ZDliMjlhOTZiNjMyYzAwZmU4MTM2ZGFjYjlhMzk1MzI0Njlm
ODEKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDYvNzhkOWIy
OWE5NmI2MzJjMDBmZTgxMzZkYWNiOWEzOTUzMjQ2OWY4MS92bWxpbnV6LTMuMTYuMC1yYzEt
MDAwNTAtZzc4ZDliMjkKCjIwMTQtMDctMTgtMTg6MTE6MDYgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgLgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDIgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDIgc3RlcHMpCls5NGUzMzY4MjFiMDIyYjkyYjA5ZDE0Nzky
ZjUxMmNiNTAyYjY2N2YzXSByY3U6IFVwZGF0ZSB0aW55LmMgcmVmZXJlbmNlcyB0byB0cmVl
LmMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9jL2Jvb3QtYmlzZWN0L2xpbnV4MC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2L25leHQ6bWFzdGVy
Ojk0ZTMzNjgyMWIwMjJiOTJiMDlkMTQ3OTJmNTEyY2I1MDJiNjY3ZjM6YmlzZWN0LWxpbnV4
MAoKMjAxNC0wNy0xOC0xODoxMjowNyA5NGUzMzY4MjFiMDIyYjkyYjA5ZDE0NzkyZjUxMmNi
NTAyYjY2N2YzIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDYtOTRlMzM2ODIxYjAy
MmI5MmIwOWQxNDc5MmY1MTJjYjUwMmI2NjdmMwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni85NGUzMzY4MjFiMDIyYjkyYjA5ZDE0
NzkyZjUxMmNiNTAyYjY2N2YzCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2LTk0ZTMzNjgy
MWIwMjJiOTJiMDlkMTQ3OTJmNTEyY2I1MDJiNjY3ZjMKa2VybmVsOiAva2VybmVsL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDcxODE2NDYvOTRlMzM2ODIxYjAyMmI5MmIwOWQxNDc5MmY1MTJj
YjUwMmI2NjdmMy92bWxpbnV6LTMuMTYuMC1yYzEtMDAwNTMtZzk0ZTMzNjgKCjIwMTQtMDct
MTgtMTg6MTQ6MDcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTIwIFNVQ0NFU1MKCkJpc2VjdGlu
ZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMSBzdGVw
KQpbYzZlMjk1NTI2NmQxNDlkMjA3NjU2ZDdhNWI5NzVhYzI4YzI3ODI2YV0gcmN1OiBSZW1v
dmUgcmVkdW5kYW50IGNoZWNrcyBmb3IgcmN1X3NjaGVkdWxlcl9mdWxseV9hY3RpdmUKcnVu
bmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jv
b3QtYmlzZWN0L2xpbnV4MC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2L25leHQ6bWFzdGVyOmM2ZTI5
NTUyNjZkMTQ5ZDIwNzY1NmQ3YTViOTc1YWMyOGMyNzgyNmE6YmlzZWN0LWxpbnV4MAoKMjAx
NC0wNy0xOC0xODoxNDozNyBjNmUyOTU1MjY2ZDE0OWQyMDc2NTZkN2E1Yjk3NWFjMjhjMjc4
MjZhIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDYtYzZlMjk1NTI2NmQxNDlkMjA3
NjU2ZDdhNWI5NzVhYzI4YzI3ODI2YQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni9jNmUyOTU1MjY2ZDE0OWQyMDc2NTZkN2E1Yjk3
NWFjMjhjMjc4MjZhCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2LWM2ZTI5NTUyNjZkMTQ5
ZDIwNzY1NmQ3YTViOTc1YWMyOGMyNzgyNmEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMS1jb25zdW1lci9pMzg2LXJhbmRj
b25maWctaWIxLTA3MTgxNjQ2LWM2ZTI5NTUyNjZkMTQ5ZDIwNzY1NmQ3YTViOTc1YWMyOGMy
NzgyNmEKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDYvYzZl
Mjk1NTI2NmQxNDlkMjA3NjU2ZDdhNWI5NzVhYzI4YzI3ODI2YS92bWxpbnV6LTMuMTYuMC1y
YzEtMDAwNTUtZ2M2ZTI5NTUKCjIwMTQtMDctMTgtMTg6MTg6MzcgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgLiBURVNUIEZBSUxVUkUKWyAgICAwLjAwMDAwMF0gQ2hlY2tpbmcgaWYgdGhpcyBw
cm9jZXNzb3IgaG9ub3VycyB0aGUgV1AgYml0IGV2ZW4gaW4gc3VwZXJ2aXNvciBtb2RlLi4u
T2suClsgICAgMC4wMDAwMDBdIFByZWVtcHRpYmxlIGhpZXJhcmNoaWNhbCBSQ1UgaW1wbGVt
ZW50YXRpb24uClsgICAgMC4wMDAwMDBdIFJDVTogQWRqdXN0aW5nIGdlb21ldHJ5IGZvciBy
Y3VfZmFub3V0X2xlYWY9MTYsIG5yX2NwdV9pZHM9MQpbICAgIDAuMDAwMDAwXSBCVUc6IHVu
YWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAgIChu
dWxsKQpbICAgIDAuMDAwMDAwXSBJUDogWzw4MTA0OGE2OD5dIHdha2VfdXBfcHJvY2Vzcysw
eDYvMHgyYwpbICAgIDAuMDAwMDAwXSAqcGRwdCA9IDAwMDAwMDAwMDAwMDAwMDAgKnBkZSA9
IGYwMDBmZjUzZjAwMGZmNTMgClsgICAgMC4wMDAwMDBdIE9vcHM6IDAwMDAgWyMxXSBQUkVF
TVBUIFNNUCAKWyAgICAwLjAwMDAwMF0gQ1BVOiAwIFBJRDogMCBDb21tOiBzd2FwcGVyLzAg
Tm90IHRhaW50ZWQgMy4xNi4wLXJjMS0wMDA1NS1nYzZlMjk1NSAjOQpbICAgIDAuMDAwMDAw
XSB0YXNrOiA4MTk1NzgzMCB0aTogODE5NGMwMDAgdGFzay50aTogODE5NGMwMDAKWyAgICAw
LjAwMDAwMF0gRUlQOiAwMDYwOls8ODEwNDhhNjg+XSBFRkxBR1M6IDAwMjEwMDgyIENQVTog
MApbICAgIDAuMDAwMDAwXSBFSVAgaXMgYXQgd2FrZV91cF9wcm9jZXNzKzB4Ni8weDJjClsg
ICAgMC4wMDAwMDBdIEVBWDogMDAwMDAwMDAgRUJYOiAwMDAwMDAwMCBFQ1g6IDgxOTU3YzQw
IEVEWDogMDAwMDAwMDIKWyAgICAwLjAwMDAwMF0gRVNJOiA5MzQwMzYyMCBFREk6IDgxOTRk
ZWRjIEVCUDogODE5NGRlYTAgRVNQOiA4MTk0ZGU5YwpbICAgIDAuMDAwMDAwXSAgRFM6IDAw
N2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6IDAwMDAgU1M6IDAwNjgKWyAgICAwLjAwMDAwMF0g
Q1IwOiA4MDA1MDAzMyBDUjI6IDAwMDAwMDAwIENSMzogMDFhNzIwMDAgQ1I0OiAwMDA0MDZi
MApbICAgIDAuMDAwMDAwXSBTdGFjazoKWyAgICAwLjAwMDAwMF0gIDgxOTRkZWIwIDgxOTRk
ZjE0IDgxMDNmNjUxIDgxOTU3YzU4IDAwMDAwMDAwIDAwMDAwMDAwIDAwMDMwMDAwIGRlYWQ0
ZWFkClsgICAgMC4wMDAwMDBdICBmZmZmZmZmZiBmZmZmZmZmZiA4MWE3ZmJmYyAwMDAwMDAw
MCAwMDAwMDAwMCA4MTg4NWNjZSA4MTk0ZGVkNCA4MTk0ZGVkNApbICAgIDAuMDAwMDAwXSAg
MDAwMDAwMDAgMDAwMzAwMDAgZGVhZDRlYWQgZmZmZmZmZmYgZmZmZmZmZmYgODFhN2ZiZmMg
MDAwMDAwMDAgMDAwMDAwMDAKWyAgICAwLjAwMDAwMF0gQ2FsbCBUcmFjZToKWyAgICAwLjAw
MDAwMF0gIFs8ODEwM2Y2NTE+XSBrdGhyZWFkX2NyZWF0ZV9vbl9ub2RlKzB4OTAvMHgxMDgK
WyAgICAwLjAwMDAwMF0gIFs8ODEwNmE1YjA+XSByY3Vfc3Bhd25fb25lX25vY2Jfa3RocmVh
ZCsweGJhLzB4ZGEKWyAgICAwLjAwMDAwMF0gIFs8ODEwNjdlYjM+XSA/IHJjdV9zdGFydF9m
dXR1cmVfZ3ArMHgxMTgvMHgxMTgKWyAgICAwLjAwMDAwMF0gIFs8ODEwNmE3MjM+XSByY3Vf
Y3B1X25vdGlmeSsweDE1My8weDViOApbICAgIDAuMDAwMDAwXSAgWzw4MTY1N2FlMz5dID8g
X19tdXRleF91bmxvY2tfc2xvd3BhdGgrMHgxMDYvMHgxMWQKWyAgICAwLjAwMDAwMF0gIFs8
ODEwNjc4ZDI+XSA/IGNwdW1hc2tfbmV4dCsweDIyLzB4MjYKWyAgICAwLjAwMDAwMF0gIFs8
ODFhMDU4Y2M+XSByY3VfaW5pdCsweDI5MS8weDI5YgpbICAgIDAuMDAwMDAwXSAgWzw4MTlm
Mjk2NT5dIHN0YXJ0X2tlcm5lbCsweDFmYS8weDM3MgpbICAgIDAuMDAwMDAwXSAgWzw4MTlm
MjU1ZD5dID8gc2V0X2luaXRfYXJnKzB4NDkvMHg0OQpbICAgIDAuMDAwMDAwXSAgWzw4MTlm
MjJhZj5dIGkzODZfc3RhcnRfa2VybmVsKzB4NzkvMHg3ZApbICAgIDAuMDAwMDAwXSBDb2Rl
OiA2MSAwMCBlYiAwNyA4OSBmMCBlOCBkZiBjNCBmZiBmZiBiZSAwMSAwMCAwMCAwMCA4YiA0
NSBmMCA4YiA1NSBlYyBlOCBiMiAwNyA2MSAwMCA4MyBjNCAxMCA4OSBmMCA1YiA1ZSA1ZiA1
ZCBjMyA1NSA4OSBlNSA1MyA4OSBjMyA8OGI+IDAwIGE4IDBjIDc0IDBmIGJhIGUwIDA2IDAw
IDAwIGI4IDhlIDc4IDg4IDgxIGU4IDBkIDM2IGZlIGZmClsgICAgMC4wMDAwMDBdIEVJUDog
Wzw4MTA0OGE2OD5dIHdha2VfdXBfcHJvY2VzcysweDYvMHgyYyBTUzpFU1AgMDA2ODo4MTk0
ZGU5YwpbICAgIDAuMDAwMDAwXSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjAwMDAw
MF0gLS0tWyBlbmQgdHJhY2UgZGI0YjdmZGU3Nzg2YmIwNyBdLS0tClsgICAgMC4wMDAwMDBd
IEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBBdHRlbXB0ZWQgdG8ga2lsbCB0aGUgaWRs
ZSB0YXNrIQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDYvYzZlMjk1NTI2
NmQxNDlkMjA3NjU2ZDdhNWI5NzVhYzI4YzI3ODI2YS9kbWVzZy15b2N0by1rYnVpbGQtMTE6
MjAxNDA3MTgxODE2NTU6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0NjozLjE2LjAtcmMx
LTAwMDU1LWdjNmUyOTU1OjkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2
L2M2ZTI5NTUyNjZkMTQ5ZDIwNzY1NmQ3YTViOTc1YWMyOGMyNzgyNmEvZG1lc2cteW9jdG8t
a2J1aWxkLTEzOjIwMTQwNzE4MTgxNjU2OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDY6
My4xNi4wLXJjMS0wMDA1NS1nYzZlMjk1NTo5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWli
MS0wNzE4MTY0Ni9jNmUyOTU1MjY2ZDE0OWQyMDc2NTZkN2E1Yjk3NWFjMjhjMjc4MjZhL2Rt
ZXNnLXlvY3RvLWtidWlsZC0xNDoyMDE0MDcxODE4MTY1ODppMzg2LXJhbmRjb25maWctaWIx
LTA3MTgxNjQ2OjMuMTYuMC1yYzEtMDAwNTUtZ2M2ZTI5NTU6OQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1pYjEtMDcxODE2NDYvYzZlMjk1NTI2NmQxNDlkMjA3NjU2ZDdhNWI5NzVhYzI4
YzI3ODI2YS9kbWVzZy15b2N0by1rYnVpbGQtMTY6MjAxNDA3MTgxODE2NTk6aTM4Ni1yYW5k
Y29uZmlnLWliMS0wNzE4MTY0NjozLjE2LjAtcmMxLTAwMDU1LWdjNmUyOTU1OjkKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2L2M2ZTI5NTUyNjZkMTQ5ZDIwNzY1NmQ3
YTViOTc1YWMyOGMyNzgyNmEvZG1lc2cteW9jdG8ta2J1aWxkLTE3OjIwMTQwNzE4MTgxNjU2
OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDY6My4xNi4wLXJjMS0wMDA1NS1nYzZlMjk1
NTo5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni9jNmUyOTU1MjY2ZDE0
OWQyMDc2NTZkN2E1Yjk3NWFjMjhjMjc4MjZhL2RtZXNnLXlvY3RvLWtidWlsZC0xOToyMDE0
MDcxODE4MTY1NjppMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2OjMuMTYuMC1yYzEtMDAw
NTUtZ2M2ZTI5NTU6OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDYvYzZl
Mjk1NTI2NmQxNDlkMjA3NjU2ZDdhNWI5NzVhYzI4YzI3ODI2YS9kbWVzZy15b2N0by1rYnVp
bGQtMToyMDE0MDcxODE4MTY1NjppMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2OjMuMTYu
MC1yYzEtMDAwNTUtZ2M2ZTI5NTU6OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcx
ODE2NDYvYzZlMjk1NTI2NmQxNDlkMjA3NjU2ZDdhNWI5NzVhYzI4YzI3ODI2YS9kbWVzZy15
b2N0by1rYnVpbGQtMjA6MjAxNDA3MTgxODE2NTY6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4
MTY0NjozLjE2LjAtcmMxLTAwMDU1LWdjNmUyOTU1OjkKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaWIxLTA3MTgxNjQ2L2M2ZTI5NTUyNjZkMTQ5ZDIwNzY1NmQ3YTViOTc1YWMyOGMyNzgy
NmEvZG1lc2cteW9jdG8ta2J1aWxkLTIxOjIwMTQwNzE4MTgxNjU3OmkzODYtcmFuZGNvbmZp
Zy1pYjEtMDcxODE2NDY6My4xNi4wLXJjMS0wMDA1NS1nYzZlMjk1NTo5Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni9jNmUyOTU1MjY2ZDE0OWQyMDc2NTZkN2E1Yjk3
NWFjMjhjMjc4MjZhL2RtZXNnLXlvY3RvLWtidWlsZC0yMjoyMDE0MDcxODE4MTY1NjppMzg2
LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2OjMuMTYuMC1yYzEtMDAwNTUtZ2M2ZTI5NTU6OQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDYvYzZlMjk1NTI2NmQxNDlkMjA3
NjU2ZDdhNWI5NzVhYzI4YzI3ODI2YS9kbWVzZy15b2N0by1rYnVpbGQtMjM6MjAxNDA3MTgx
ODE2NTc6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0NjozLjE2LjAtcmMxLTAwMDU1LWdj
NmUyOTU1OjkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2L2M2ZTI5NTUy
NjZkMTQ5ZDIwNzY1NmQ3YTViOTc1YWMyOGMyNzgyNmEvZG1lc2cteW9jdG8ta2J1aWxkLTI1
OjIwMTQwNzE4MTgxNjU3OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDY6My4xNi4wLXJj
MS0wMDA1NS1nYzZlMjk1NTo5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0
Ni9jNmUyOTU1MjY2ZDE0OWQyMDc2NTZkN2E1Yjk3NWFjMjhjMjc4MjZhL2RtZXNnLXlvY3Rv
LWtidWlsZC0yOToyMDE0MDcxODE4MTY1NjppMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2
OjMuMTYuMC1yYzEtMDAwNTUtZ2M2ZTI5NTU6OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1p
YjEtMDcxODE2NDYvYzZlMjk1NTI2NmQxNDlkMjA3NjU2ZDdhNWI5NzVhYzI4YzI3ODI2YS9k
bWVzZy15b2N0by1rYnVpbGQtMjoyMDE0MDcxODE4MTY1NjppMzg2LXJhbmRjb25maWctaWIx
LTA3MTgxNjQ2OjMuMTYuMC1yYzEtMDAwNTUtZ2M2ZTI5NTU6OQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1pYjEtMDcxODE2NDYvYzZlMjk1NTI2NmQxNDlkMjA3NjU2ZDdhNWI5NzVhYzI4
YzI3ODI2YS9kbWVzZy15b2N0by1rYnVpbGQtMzA6MjAxNDA3MTgxODE2NTY6aTM4Ni1yYW5k
Y29uZmlnLWliMS0wNzE4MTY0NjozLjE2LjAtcmMxLTAwMDU1LWdjNmUyOTU1OjkKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2L2M2ZTI5NTUyNjZkMTQ5ZDIwNzY1NmQ3
YTViOTc1YWMyOGMyNzgyNmEvZG1lc2cteW9jdG8ta2J1aWxkLTMyOjIwMTQwNzE4MTgxNjU2
OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDY6My4xNi4wLXJjMS0wMDA1NS1nYzZlMjk1
NTo5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni9jNmUyOTU1MjY2ZDE0
OWQyMDc2NTZkN2E1Yjk3NWFjMjhjMjc4MjZhL2RtZXNnLXlvY3RvLWtidWlsZC0zOjIwMTQw
NzE4MTgxNjU3OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDY6My4xNi4wLXJjMS0wMDA1
NS1nYzZlMjk1NTo5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni9jNmUy
OTU1MjY2ZDE0OWQyMDc2NTZkN2E1Yjk3NWFjMjhjMjc4MjZhL2RtZXNnLXlvY3RvLWtidWls
ZC00OjIwMTQwNzE4MTgxNjU2OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDY6My4xNi4w
LXJjMS0wMDA1NS1nYzZlMjk1NTo5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4
MTY0Ni9jNmUyOTU1MjY2ZDE0OWQyMDc2NTZkN2E1Yjk3NWFjMjhjMjc4MjZhL2RtZXNnLXlv
Y3RvLWtidWlsZC03OjIwMTQwNzE4MTgxNjU2OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2
NDY6My4xNi4wLXJjMS0wMDA1NS1nYzZlMjk1NTo5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWliMS0wNzE4MTY0Ni9jNmUyOTU1MjY2ZDE0OWQyMDc2NTZkN2E1Yjk3NWFjMjhjMjc4MjZh
L2RtZXNnLXlvY3RvLWtidWlsZC05OjIwMTQwNzE4MTgxNjU1OmkzODYtcmFuZGNvbmZpZy1p
YjEtMDcxODE2NDY6My4xNi4wLXJjMS0wMDA1NS1nYzZlMjk1NTo5CjA6MjA6MjAgYWxsX2dv
b2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDctMTggMTg6MTk6MDggUkVQRUFU
IENPVU5UOiAyMCAgIyAvYy9ib290LWJpc2VjdC9saW51eDAvb2JqLWJpc2VjdC8ucmVwZWF0
G1swbQoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAo
cm91Z2hseSAwIHN0ZXBzKQpbMzRlODJlZDYwYWFkMzIwNTY1N2UyNzZlNDY0MGMzZWE2MDY1
NzA0OF0gcmN1OiBSZW1vdmUgc3RhbGUgY29tbWVudCBpbiB0cmVlLmMKcnVubmluZyAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0
L2xpbnV4MC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9p
Mzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2L25leHQ6bWFzdGVyOjM0ZTgyZWQ2MGFhZDMy
MDU2NTdlMjc2ZTQ2NDBjM2VhNjA2NTcwNDg6YmlzZWN0LWxpbnV4MAoKMjAxNC0wNy0xOC0x
ODoxOTowOCAzNGU4MmVkNjBhYWQzMjA1NjU3ZTI3NmU0NjQwYzNlYTYwNjU3MDQ4IGNvbXBp
bGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kz
ODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDYtMzRlODJlZDYwYWFkMzIwNTY1N2UyNzZlNDY0
MGMzZWE2MDY1NzA0OApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWliMS0wNzE4MTY0Ni8zNGU4MmVkNjBhYWQzMjA1NjU3ZTI3NmU0NjQwYzNlYTYwNjU3
MDQ4CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2LTM0ZTgyZWQ2MGFhZDMyMDU2NTdlMjc2
ZTQ2NDBjM2VhNjA2NTcwNDgKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEt
MDcxODE2NDYvMzRlODJlZDYwYWFkMzIwNTY1N2UyNzZlNDY0MGMzZWE2MDY1NzA0OC92bWxp
bnV6LTMuMTYuMC1yYzEtMDAwNTQtZzM0ZTgyZWQKCjIwMTQtMDctMTgtMTg6MjE6MDkgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgCTIwIFNVQ0NFU1MKCmM2ZTI5NTUyNjZkMTQ5ZDIwNzY1NmQ3
YTViOTc1YWMyOGMyNzgyNmEgaXMgdGhlIGZpcnN0IGJhZCBjb21taXQKY29tbWl0IGM2ZTI5
NTUyNjZkMTQ5ZDIwNzY1NmQ3YTViOTc1YWMyOGMyNzgyNmEKQXV0aG9yOiBQcmFuaXRoIEt1
bWFyIDxib2JieS5wcmFuaUBnbWFpbC5jb20+CkRhdGU6ICAgVHVlIEp1bCAxNSAyMTo1MDow
MiAyMDE0IC0wNDAwCgogICAgcmN1OiBSZW1vdmUgcmVkdW5kYW50IGNoZWNrcyBmb3IgcmN1
X3NjaGVkdWxlcl9mdWxseV9hY3RpdmUKICAgIAogICAgcmN1X3NjaGVkdWxlcl9mdWxseV9h
Y3RpdmUgaXMgc2V0IHRvIHRydWUgZWFybHkgaW4gdGhlIGJvb3QgcHJvY2Vzcy4KICAgIAog
ICAgcmN1X3ByZXBhcmVfa3RocmVhZHMoKSBpcyBjYWxsZWQgaW4gdHdvIGxvY2F0aW9ucy4g
T25jZSBhZnRlciBzZXR0aW5nIHRoZSBhYm92ZQogICAgZmxhZyBhbmQgdGhlIG90aGVyIHdo
aWxlIGhvdHBsdWdnaW5nIGEgQ1BVIGZyb20gcmN1X2NwdV9ub3RpZnkoKS4gQ1BVIGhvdHBs
dWcgaXMKICAgIGVuYWJsZWQgbXVjaCBsYXRlciBieSB3aGljaCB0aW1lIHRoZSBhYm92ZSBm
bGFnIGlzIGFscmVhZHkgc2V0LiBIZW5jZSBjaGVja2luZwogICAgZm9yIHRoaXMgZmxhZyBp
cyByZWR1bmRhbnQgaW4gdGhpcyBmdW5jdGlvbi4KICAgIAogICAgVGhlIGNoZWNrcyBpbiBy
Y3Vfc3Bhd25fb25lX2Jvb3N0X2t0aHJlYWQoKSBhbmQgcmN1X3NwYXduX2FsbF9ub2NiX2t0
aHJlYWRzKCkKICAgIGFyZSBzaW1pbGFybHkgcmVkdW5kYW50LgogICAgCiAgICBUaGlzIGNv
bW1pdCByZW1vdmVzIHRoZSByZWR1bmRhbnQgY2hlY2tzIGZvciB0aGlzIGZsYWcgZnJvbSB0
aGUgYWJvdmUKICAgIGxvY2F0aW9ucy4KICAgIAogICAgU2lnbmVkLW9mZi1ieTogUHJhbml0
aCBLdW1hciA8Ym9iYnkucHJhbmlAZ21haWwuY29tPgogICAgU2lnbmVkLW9mZi1ieTogUGF1
bCBFLiBNY0tlbm5leSA8cGF1bG1ja0BsaW51eC52bmV0LmlibS5jb20+Cgo6MDQwMDAwIDA0
MDAwMCA1MDNlNmYwNWFlMTk3MzIzNGMxZGM2ZTkzZTIzODJkMmMyZDEyYmRlIDA4MWQzYTgx
MWZjZmVmNmY4Y2RjNWEwMGMzMDc2MDI1MWFiNGEwMzUgTQlrZXJuZWwKYmlzZWN0IHJ1biBz
dWNjZXNzCkhFQUQgaXMgbm93IGF0IDM0ZTgyZWQuLi4gcmN1OiBSZW1vdmUgc3RhbGUgY29t
bWVudCBpbiB0cmVlLmMKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDcxODE2NDYvbmV4dDptYXN0ZXI6MzRlODJlZDYwYWFkMzIwNTY1
N2UyNzZlNDY0MGMzZWE2MDY1NzA0ODpiaXNlY3QtbGludXgwCgoyMDE0LTA3LTE4LTE4OjIx
OjM5IDM0ZTgyZWQ2MGFhZDMyMDU2NTdlMjc2ZTQ2NDBjM2VhNjA2NTcwNDggcmV1c2UgL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2LzM0ZTgyZWQ2MGFhZDMyMDU2NTdl
Mjc2ZTQ2NDBjM2VhNjA2NTcwNDgvdm1saW51ei0zLjE2LjAtcmMxLTAwMDU0LWczNGU4MmVk
CgoyMDE0LTA3LTE4LTE4OjIxOjM5IGRldGVjdGluZyBib290IHN0YXRlIC4uCTIyLgkyMwkz
NAk0OAk1OQk2MCBTVUNDRVNTCgpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyAzNGU4MmVk
Li4uIHJjdTogUmVtb3ZlIHN0YWxlIGNvbW1lbnQgaW4gdHJlZS5jCkhFQUQgaXMgbm93IGF0
IDU4ZTMyM2MzLi4uIEFkZCBsaW51eC1uZXh0IHNwZWNpZmljIGZpbGVzIGZvciAyMDE0MDcx
OApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWli
MS0wNzE4MTY0Ni9uZXh0Om1hc3Rlcjo1OGUzMjNjM2VlOTRmMWFiY2VjZGVlZWYyMTFhMjdk
MWMxMDZjMmIzOmJpc2VjdC1saW51eDAKIFRFU1QgRkFJTFVSRQpbICAgIDAuMDAwMDAwXSBD
aGVja2luZyBpZiB0aGlzIHByb2Nlc3NvciBob25vdXJzIHRoZSBXUCBiaXQgZXZlbiBpbiBz
dXBlcnZpc29yIG1vZGUuLi5Pay4KWyAgICAwLjAwMDAwMF0gUHJlZW1wdGlibGUgaGllcmFy
Y2hpY2FsIFJDVSBpbXBsZW1lbnRhdGlvbi4KWyAgICAwLjAwMDAwMF0gUkNVOiBBZGp1c3Rp
bmcgZ2VvbWV0cnkgZm9yIHJjdV9mYW5vdXRfbGVhZj0xNiwgbnJfY3B1X2lkcz0xClsgICAg
MC4wMDAwMDBdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRl
cmVmZXJlbmNlIGF0ICAgKG51bGwpClsgICAgMC4wMDAwMDBdIElQOiBbPDgxMDQ0MzgxPl0g
d2FrZV91cF9wcm9jZXNzKzB4Ni8weDJjClsgICAgMC4wMDAwMDBdICpwZHB0ID0gMDAwMDAw
MDAwMDAwMDAwMCAqcGRlID0gZjAwMGZmNTNmMDAwZmY1MyAKWyAgICAwLjAwMDAwMF0gT29w
czogMDAwMCBbIzFdIFBSRUVNUFQgU01QIApbICAgIDAuMDAwMDAwXSBDUFU6IDAgUElEOiAw
IENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE2LjAtcmM1LW5leHQtMjAxNDA3MTgg
IzQzClsgICAgMC4wMDAwMDBdIHRhc2s6IDgxOTY5ODUwIHRpOiA4MTk1ZTAwMCB0YXNrLnRp
OiA4MTk1ZTAwMApbICAgIDAuMDAwMDAwXSBFSVA6IDAwNjA6Wzw4MTA0NDM4MT5dIEVGTEFH
UzogMDAyMTAwODIgQ1BVOiAwClsgICAgMC4wMDAwMDBdIEVJUCBpcyBhdCB3YWtlX3VwX3By
b2Nlc3MrMHg2LzB4MmMKWyAgICAwLjAwMDAwMF0gRUFYOiAwMDAwMDAwMCBFQlg6IDAwMDAw
MDAwIEVDWDogMDAwMDAwMDAgRURYOiAwMDAwMDAwMgpbICAgIDAuMDAwMDAwXSBFU0k6IDkz
NDAxYjgwIEVESTogODE5NWZlZGMgRUJQOiA4MTk1ZmVhMCBFU1A6IDgxOTVmZTljClsgICAg
MC4wMDAwMDBdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDAwMCBTUzogMDA2
OApbICAgIDAuMDAwMDAwXSBDUjA6IDgwMDUwMDMzIENSMjogMDAwMDAwMDAgQ1IzOiAwMWE4
NTAwMCBDUjQ6IDAwMDQwNmIwClsgICAgMC4wMDAwMDBdIFN0YWNrOgpbICAgIDAuMDAwMDAw
XSAgODE5NWZlYjAgODE5NWZmMTQgODEwM2Q3OTAgMDAwMDAwMDIgMDAwMDAwMDAgMDAwMDAw
MDAgMDAwMDAwMDAgZGVhZDRlYWQKWyAgICAwLjAwMDAwMF0gIGZmZmZmZmZmIGZmZmZmZmZm
IDgxYTkxMjIwIDAwMDAwMDAwIDAwMDAwMDAwIDgxODk2ZmEwIDgxOTVmZWQ0IDgxOTVmZWQ0
ClsgICAgMC4wMDAwMDBdICAwMDAwMDAwMCAwMDAwMDAwMCBkZWFkNGVhZCBmZmZmZmZmZiBm
ZmZmZmZmZiA4MWE5MTIyMCAwMDAwMDAwMCAwMDAwMDAwMApbICAgIDAuMDAwMDAwXSBDYWxs
IFRyYWNlOgpbICAgIDAuMDAwMDAwXSAgWzw4MTAzZDc5MD5dIGt0aHJlYWRfY3JlYXRlX29u
X25vZGUrMHg5MC8weDEwOApbICAgIDAuMDAwMDAwXSAgWzw4MTA2NjEyYT5dIHJjdV9zcGF3
bl9vbmVfbm9jYl9rdGhyZWFkKzB4YmEvMHhkYQpbICAgIDAuMDAwMDAwXSAgWzw4MTA2M2Ey
ZD5dID8gcmN1X3N0YXJ0X2Z1dHVyZV9ncCsweDExOC8weDExOApbICAgIDAuMDAwMDAwXSAg
Wzw4MTA2NjI5ZD5dIHJjdV9jcHVfbm90aWZ5KzB4MTUzLzB4NWI4ClsgICAgMC4wMDAwMDBd
ICBbPDgxNjYxMjQzPl0gPyBfX211dGV4X3VubG9ja19zbG93cGF0aCsweDEwNi8weDExZApb
ICAgIDAuMDAwMDAwXSAgWzw4MTA2MzQ0Yz5dID8gY3B1bWFza19uZXh0KzB4MjIvMHgyNgpb
ICAgIDAuMDAwMDAwXSAgWzw4MWExODliYz5dIHJjdV9pbml0KzB4Mjk3LzB4MmExClsgICAg
MC4wMDAwMDBdICBbPDgxYTA1OTg5Pl0gc3RhcnRfa2VybmVsKzB4MjA0LzB4MzdjClsgICAg
MC4wMDAwMDBdICBbPDgxYTA1NTVkPl0gPyBzZXRfaW5pdF9hcmcrMHg0OS8weDQ5ClsgICAg
MC4wMDAwMDBdICBbPDgxYTA1MmFmPl0gaTM4Nl9zdGFydF9rZXJuZWwrMHg3OS8weDdkClsg
ICAgMC4wMDAwMDBdIENvZGU6IDYxIDAwIGViIDA3IDg5IGYwIGU4IGQxIGM0IGZmIGZmIGJl
IDAxIDAwIDAwIDAwIDhiIDQ1IGYwIDhiIDU1IGVjIGU4IDY5IGU5IDYxIDAwIDgzIGM0IDEw
IDg5IGYwIDViIDVlIDVmIDVkIGMzIDU1IDg5IGU1IDUzIDg5IGMzIDw4Yj4gMDAgYTggMGMg
NzQgMGYgYmEgZTggMDYgMDAgMDAgYjggMTEgODggODkgODEgZTggMDAgODMgZmUgZmYKWyAg
ICAwLjAwMDAwMF0gRUlQOiBbPDgxMDQ0MzgxPl0gd2FrZV91cF9wcm9jZXNzKzB4Ni8weDJj
IFNTOkVTUCAwMDY4OjgxOTVmZTljClsgICAgMC4wMDAwMDBdIENSMjogMDAwMDAwMDAwMDAw
MDAwMApbICAgIDAuMDAwMDAwXSAtLS1bIGVuZCB0cmFjZSBjYjg4NTM3ZmRjOGZhMjAwIF0t
LS0KWyAgICAwLjAwMDAwMF0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEF0dGVtcHRl
ZCB0byBraWxsIHRoZSBpZGxlIHRhc2shCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0w
NzE4MTY0Ni81OGUzMjNjM2VlOTRmMWFiY2VjZGVlZWYyMTFhMjdkMWMxMDZjMmIzL2RtZXNn
LXlvY3RvLXZwLTMyOjIwMTQwNzE4MTY1MDA2OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2
NDY6My4xNi4wLXJjNS1uZXh0LTIwMTQwNzE4OjQzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWliMS0wNzE4MTY0Ni81OGUzMjNjM2VlOTRmMWFiY2VjZGVlZWYyMTFhMjdkMWMxMDZjMmIz
L2RtZXNnLXlvY3RvLXZwLTMwOjIwMTQwNzE4MTY1MDA1OmkzODYtcmFuZGNvbmZpZy1pYjEt
MDcxODE2NDY6My4xNi4wLXJjNS1uZXh0LTIwMTQwNzE4OjQzCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWliMS0wNzE4MTY0Ni81OGUzMjNjM2VlOTRmMWFiY2VjZGVlZWYyMTFhMjdkMWMx
MDZjMmIzL2RtZXNnLXlvY3RvLXZwLTExOjIwMTQwNzE4MTY1MDA2OmkzODYtcmFuZGNvbmZp
Zy1pYjEtMDcxODE2NDY6My4xNi4wLXJjNS1uZXh0LTIwMTQwNzE4OjQzCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni81OGUzMjNjM2VlOTRmMWFiY2VjZGVlZWYyMTFh
MjdkMWMxMDZjMmIzL2RtZXNnLXlvY3RvLXZwLTEzOjIwMTQwNzE4MTY1MDA1OmkzODYtcmFu
ZGNvbmZpZy1pYjEtMDcxODE2NDY6My4xNi4wLXJjNS1uZXh0LTIwMTQwNzE4OjQzCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni81OGUzMjNjM2VlOTRmMWFiY2VjZGVl
ZWYyMTFhMjdkMWMxMDZjMmIzL2RtZXNnLXlvY3RvLXZwLTE2OjIwMTQwNzE4MTY1MDA1Omkz
ODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDY6My4xNi4wLXJjNS1uZXh0LTIwMTQwNzE4OjQz
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni81OGUzMjNjM2VlOTRmMWFi
Y2VjZGVlZWYyMTFhMjdkMWMxMDZjMmIzL2RtZXNnLXlvY3RvLXZwLTIzOjIwMTQwNzE4MTY1
MDA2OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDY6My4xNi4wLXJjNS1uZXh0LTIwMTQw
NzE4OjQzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni81OGUzMjNjM2Vl
OTRmMWFiY2VjZGVlZWYyMTFhMjdkMWMxMDZjMmIzL2RtZXNnLXlvY3RvLXZwLTU0OjIwMTQw
NzE4MTY1MDA1OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDY6My4xNi4wLXJjNS1uZXh0
LTIwMTQwNzE4OjQzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni81OGUz
MjNjM2VlOTRmMWFiY2VjZGVlZWYyMTFhMjdkMWMxMDZjMmIzL2RtZXNnLXlvY3RvLXZwLTYy
OjIwMTQwNzE4MTY1MDA2OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDY6My4xNi4wLXJj
NS1uZXh0LTIwMTQwNzE4OjQzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0
Ni81OGUzMjNjM2VlOTRmMWFiY2VjZGVlZWYyMTFhMjdkMWMxMDZjMmIzL2RtZXNnLXlvY3Rv
LWtidWlsZC0yNzoyMDE0MDcxODE2NDYxNzppMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2
OjMuMTYuMC1yYzUtbmV4dC0yMDE0MDcxODo0Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1p
YjEtMDcxODE2NDYvNThlMzIzYzNlZTk0ZjFhYmNlY2RlZWVmMjExYTI3ZDFjMTA2YzJiMy9k
bWVzZy15b2N0by12cC0xODoyMDE0MDcxODE2NTAwNTppMzg2LXJhbmRjb25maWctaWIxLTA3
MTgxNjQ2OjMuMTYuMC1yYzUtbmV4dC0yMDE0MDcxODo0Mwova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1pYjEtMDcxODE2NDYvNThlMzIzYzNlZTk0ZjFhYmNlY2RlZWVmMjExYTI3ZDFjMTA2
YzJiMy9kbWVzZy15b2N0by12cC0zNToyMDE0MDcxODE2NTAwNjppMzg2LXJhbmRjb25maWct
aWIxLTA3MTgxNjQ2OjMuMTYuMC1yYzUtbmV4dC0yMDE0MDcxODo0MwowOjExOjExIGFsbF9n
b29kOmJhZDphbGxfYmFkIGJvb3RzCgpIRUFEIGlzIG5vdyBhdCA1OGUzMjNjMyBBZGQgbGlu
dXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAxNDA3MTgKCj09PT09PT09PSBsaW51cy9t
YXN0ZXIgPT09PT09PT09ClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDU4ZTMyM2MzLi4u
IEFkZCBsaW51eC1uZXh0IHNwZWNpZmljIGZpbGVzIGZvciAyMDE0MDcxOApIRUFEIGlzIG5v
dyBhdCA1OWNhOWVlLi4uIE1lcmdlIHRhZyAnc3RhYmxlL2Zvci1saW51cy0zLjE2LXJjNS10
YWcnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC94
ZW4vdGlwCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctaWIxLTA3MTgxNjQ2L2xpbnVzOm1hc3Rlcjo1OWNhOWVlNDI4MzhkMGY1OTcxMzdjZjgx
MWU0N2VhZjQyZmRjYjY5OmJpc2VjdC1saW51eDAKCjIwMTQtMDctMTgtMTg6MjY6MTcgNTlj
YTllZTQyODM4ZDBmNTk3MTM3Y2Y4MTFlNDdlYWY0MmZkY2I2OSBjb21waWxpbmcKUXVldWVk
IGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25m
aWctaWIxLTA3MTgxNjQ2LTU5Y2E5ZWU0MjgzOGQwZjU5NzEzN2NmODExZTQ3ZWFmNDJmZGNi
NjkKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcx
ODE2NDYvNTljYTllZTQyODM4ZDBmNTk3MTM3Y2Y4MTFlNDdlYWY0MmZkY2I2OQp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5k
Y29uZmlnLWliMS0wNzE4MTY0Ni01OWNhOWVlNDI4MzhkMGY1OTcxMzdjZjgxMWU0N2VhZjQy
ZmRjYjY5CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS9sa3AtaHN4MDEtY29uc3VtZXIvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni01
OWNhOWVlNDI4MzhkMGY1OTcxMzdjZjgxMWU0N2VhZjQyZmRjYjY5Cmtlcm5lbDogL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2LzU5Y2E5ZWU0MjgzOGQwZjU5NzEzN2Nm
ODExZTQ3ZWFmNDJmZGNiNjkvdm1saW51ei0zLjE2LjAtcmM1LTAwMTUyLWc1OWNhOWVlCgoy
MDE0LTA3LTE4LTE4OjMzOjE3IGRldGVjdGluZyBib290IHN0YXRlIC4uCTMwCTQ3CTYwIFNV
Q0NFU1MKCgo9PT09PT09PT0gbmV4dC9tYXN0ZXIgPT09PT09PT09ClByZXZpb3VzIEhFQUQg
cG9zaXRpb24gd2FzIDU5Y2E5ZWUuLi4gTWVyZ2UgdGFnICdzdGFibGUvZm9yLWxpbnVzLTMu
MTYtcmM1LXRhZycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJu
ZWwvZ2l0L3hlbi90aXAKSEVBRCBpcyBub3cgYXQgNThlMzIzYzMuLi4gQWRkIGxpbnV4LW5l
eHQgc3BlY2lmaWMgZmlsZXMgZm9yIDIwMTQwNzE4CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVu
LXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2L25leHQ6bWFzdGVyOjU4
ZTMyM2MzZWU5NGYxYWJjZWNkZWVlZjIxMWEyN2QxYzEwNmMyYjM6YmlzZWN0LWxpbnV4MAog
VEVTVCBGQUlMVVJFClsgICAgMC4wMDAwMDBdIENoZWNraW5nIGlmIHRoaXMgcHJvY2Vzc29y
IGhvbm91cnMgdGhlIFdQIGJpdCBldmVuIGluIHN1cGVydmlzb3IgbW9kZS4uLk9rLgpbICAg
IDAuMDAwMDAwXSBQcmVlbXB0aWJsZSBoaWVyYXJjaGljYWwgUkNVIGltcGxlbWVudGF0aW9u
LgpbICAgIDAuMDAwMDAwXSBSQ1U6IEFkanVzdGluZyBnZW9tZXRyeSBmb3IgcmN1X2Zhbm91
dF9sZWFmPTE2LCBucl9jcHVfaWRzPTEKWyAgICAwLjAwMDAwMF0gQlVHOiB1bmFibGUgdG8g
aGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgICAobnVsbCkKWyAg
ICAwLjAwMDAwMF0gSVA6IFs8ODEwNDQzODE+XSB3YWtlX3VwX3Byb2Nlc3MrMHg2LzB4MmMK
WyAgICAwLjAwMDAwMF0gKnBkcHQgPSAwMDAwMDAwMDAwMDAwMDAwICpwZGUgPSBmMDAwZmY1
M2YwMDBmZjUzIApbICAgIDAuMDAwMDAwXSBPb3BzOiAwMDAwIFsjMV0gUFJFRU1QVCBTTVAg
ClsgICAgMC4wMDAwMDBdIENQVTogMCBQSUQ6IDAgQ29tbTogc3dhcHBlci8wIE5vdCB0YWlu
dGVkIDMuMTYuMC1yYzUtbmV4dC0yMDE0MDcxOCAjNDMKWyAgICAwLjAwMDAwMF0gdGFzazog
ODE5Njk4NTAgdGk6IDgxOTVlMDAwIHRhc2sudGk6IDgxOTVlMDAwClsgICAgMC4wMDAwMDBd
IEVJUDogMDA2MDpbPDgxMDQ0MzgxPl0gRUZMQUdTOiAwMDIxMDA4MiBDUFU6IDAKWyAgICAw
LjAwMDAwMF0gRUlQIGlzIGF0IHdha2VfdXBfcHJvY2VzcysweDYvMHgyYwpbICAgIDAuMDAw
MDAwXSBFQVg6IDAwMDAwMDAwIEVCWDogMDAwMDAwMDAgRUNYOiAwMDAwMDAwMCBFRFg6IDAw
MDAwMDAyClsgICAgMC4wMDAwMDBdIEVTSTogOTM0MDFiODAgRURJOiA4MTk1ZmVkYyBFQlA6
IDgxOTVmZWEwIEVTUDogODE5NWZlOWMKWyAgICAwLjAwMDAwMF0gIERTOiAwMDdiIEVTOiAw
MDdiIEZTOiAwMGQ4IEdTOiAwMDAwIFNTOiAwMDY4ClsgICAgMC4wMDAwMDBdIENSMDogODAw
NTAwMzMgQ1IyOiAwMDAwMDAwMCBDUjM6IDAxYTg1MDAwIENSNDogMDAwNDA2YjAKWyAgICAw
LjAwMDAwMF0gU3RhY2s6ClsgICAgMC4wMDAwMDBdICA4MTk1ZmViMCA4MTk1ZmYxNCA4MTAz
ZDc5MCAwMDAwMDAwMiAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCBkZWFkNGVhZApbICAg
IDAuMDAwMDAwXSAgZmZmZmZmZmYgZmZmZmZmZmYgODFhOTEyMjAgMDAwMDAwMDAgMDAwMDAw
MDAgODE4OTZmYTAgODE5NWZlZDQgODE5NWZlZDQKWyAgICAwLjAwMDAwMF0gIDAwMDAwMDAw
IDAwMDAwMDAwIGRlYWQ0ZWFkIGZmZmZmZmZmIGZmZmZmZmZmIDgxYTkxMjIwIDAwMDAwMDAw
IDAwMDAwMDAwClsgICAgMC4wMDAwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4wMDAwMDBdICBb
PDgxMDNkNzkwPl0ga3RocmVhZF9jcmVhdGVfb25fbm9kZSsweDkwLzB4MTA4ClsgICAgMC4w
MDAwMDBdICBbPDgxMDY2MTJhPl0gcmN1X3NwYXduX29uZV9ub2NiX2t0aHJlYWQrMHhiYS8w
eGRhClsgICAgMC4wMDAwMDBdICBbPDgxMDYzYTJkPl0gPyByY3Vfc3RhcnRfZnV0dXJlX2dw
KzB4MTE4LzB4MTE4ClsgICAgMC4wMDAwMDBdICBbPDgxMDY2MjlkPl0gcmN1X2NwdV9ub3Rp
ZnkrMHgxNTMvMHg1YjgKWyAgICAwLjAwMDAwMF0gIFs8ODE2NjEyNDM+XSA/IF9fbXV0ZXhf
dW5sb2NrX3Nsb3dwYXRoKzB4MTA2LzB4MTFkClsgICAgMC4wMDAwMDBdICBbPDgxMDYzNDRj
Pl0gPyBjcHVtYXNrX25leHQrMHgyMi8weDI2ClsgICAgMC4wMDAwMDBdICBbPDgxYTE4OWJj
Pl0gcmN1X2luaXQrMHgyOTcvMHgyYTEKWyAgICAwLjAwMDAwMF0gIFs8ODFhMDU5ODk+XSBz
dGFydF9rZXJuZWwrMHgyMDQvMHgzN2MKWyAgICAwLjAwMDAwMF0gIFs8ODFhMDU1NWQ+XSA/
IHNldF9pbml0X2FyZysweDQ5LzB4NDkKWyAgICAwLjAwMDAwMF0gIFs8ODFhMDUyYWY+XSBp
Mzg2X3N0YXJ0X2tlcm5lbCsweDc5LzB4N2QKWyAgICAwLjAwMDAwMF0gQ29kZTogNjEgMDAg
ZWIgMDcgODkgZjAgZTggZDEgYzQgZmYgZmYgYmUgMDEgMDAgMDAgMDAgOGIgNDUgZjAgOGIg
NTUgZWMgZTggNjkgZTkgNjEgMDAgODMgYzQgMTAgODkgZjAgNWIgNWUgNWYgNWQgYzMgNTUg
ODkgZTUgNTMgODkgYzMgPDhiPiAwMCBhOCAwYyA3NCAwZiBiYSBlOCAwNiAwMCAwMCBiOCAx
MSA4OCA4OSA4MSBlOCAwMCA4MyBmZSBmZgpbICAgIDAuMDAwMDAwXSBFSVA6IFs8ODEwNDQz
ODE+XSB3YWtlX3VwX3Byb2Nlc3MrMHg2LzB4MmMgU1M6RVNQIDAwNjg6ODE5NWZlOWMKWyAg
ICAwLjAwMDAwMF0gQ1IyOiAwMDAwMDAwMDAwMDAwMDAwClsgICAgMC4wMDAwMDBdIC0tLVsg
ZW5kIHRyYWNlIGNiODg1MzdmZGM4ZmEyMDAgXS0tLQpbICAgIDAuMDAwMDAwXSBLZXJuZWwg
cGFuaWMgLSBub3Qgc3luY2luZzogQXR0ZW1wdGVkIHRvIGtpbGwgdGhlIGlkbGUgdGFzayEK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2LzU4ZTMyM2MzZWU5NGYxYWJj
ZWNkZWVlZjIxMWEyN2QxYzEwNmMyYjMvZG1lc2cteW9jdG8tdnAtMzI6MjAxNDA3MTgxNjUw
MDY6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0NjozLjE2LjAtcmM1LW5leHQtMjAxNDA3
MTg6NDMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2LzU4ZTMyM2MzZWU5
NGYxYWJjZWNkZWVlZjIxMWEyN2QxYzEwNmMyYjMvZG1lc2cteW9jdG8tdnAtMzA6MjAxNDA3
MTgxNjUwMDU6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0NjozLjE2LjAtcmM1LW5leHQt
MjAxNDA3MTg6NDMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2LzU4ZTMy
M2MzZWU5NGYxYWJjZWNkZWVlZjIxMWEyN2QxYzEwNmMyYjMvZG1lc2cteW9jdG8tdnAtMTE6
MjAxNDA3MTgxNjUwMDY6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0NjozLjE2LjAtcmM1
LW5leHQtMjAxNDA3MTg6NDMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2
LzU4ZTMyM2MzZWU5NGYxYWJjZWNkZWVlZjIxMWEyN2QxYzEwNmMyYjMvZG1lc2cteW9jdG8t
dnAtMTM6MjAxNDA3MTgxNjUwMDU6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0NjozLjE2
LjAtcmM1LW5leHQtMjAxNDA3MTg6NDMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3
MTgxNjQ2LzU4ZTMyM2MzZWU5NGYxYWJjZWNkZWVlZjIxMWEyN2QxYzEwNmMyYjMvZG1lc2ct
eW9jdG8tdnAtMTY6MjAxNDA3MTgxNjUwMDU6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0
NjozLjE2LjAtcmM1LW5leHQtMjAxNDA3MTg6NDMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aWIxLTA3MTgxNjQ2LzU4ZTMyM2MzZWU5NGYxYWJjZWNkZWVlZjIxMWEyN2QxYzEwNmMyYjMv
ZG1lc2cteW9jdG8tdnAtMjM6MjAxNDA3MTgxNjUwMDY6aTM4Ni1yYW5kY29uZmlnLWliMS0w
NzE4MTY0NjozLjE2LjAtcmM1LW5leHQtMjAxNDA3MTg6NDMKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctaWIxLTA3MTgxNjQ2LzU4ZTMyM2MzZWU5NGYxYWJjZWNkZWVlZjIxMWEyN2QxYzEw
NmMyYjMvZG1lc2cteW9jdG8tdnAtNTQ6MjAxNDA3MTgxNjUwMDU6aTM4Ni1yYW5kY29uZmln
LWliMS0wNzE4MTY0NjozLjE2LjAtcmM1LW5leHQtMjAxNDA3MTg6NDMKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2LzU4ZTMyM2MzZWU5NGYxYWJjZWNkZWVlZjIxMWEy
N2QxYzEwNmMyYjMvZG1lc2cteW9jdG8tdnAtNjI6MjAxNDA3MTgxNjUwMDY6aTM4Ni1yYW5k
Y29uZmlnLWliMS0wNzE4MTY0NjozLjE2LjAtcmM1LW5leHQtMjAxNDA3MTg6NDMKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaWIxLTA3MTgxNjQ2LzU4ZTMyM2MzZWU5NGYxYWJjZWNkZWVl
ZjIxMWEyN2QxYzEwNmMyYjMvZG1lc2cteW9jdG8ta2J1aWxkLTI3OjIwMTQwNzE4MTY0NjE3
OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDY6My4xNi4wLXJjNS1uZXh0LTIwMTQwNzE4
OjQzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni81OGUzMjNjM2VlOTRm
MWFiY2VjZGVlZWYyMTFhMjdkMWMxMDZjMmIzL2RtZXNnLXlvY3RvLXZwLTE4OjIwMTQwNzE4
MTY1MDA1OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDY6My4xNi4wLXJjNS1uZXh0LTIw
MTQwNzE4OjQzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzE4MTY0Ni81OGUzMjNj
M2VlOTRmMWFiY2VjZGVlZWYyMTFhMjdkMWMxMDZjMmIzL2RtZXNnLXlvY3RvLXZwLTM1OjIw
MTQwNzE4MTY1MDA2OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcxODE2NDY6My4xNi4wLXJjNS1u
ZXh0LTIwMTQwNzE4OjQzCjA6MTE6MTEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCg==
--------------000500000707070800080307
Content-Type: text/plain; charset=UTF-8;
 name="config-3.16.0-rc1-00055-gc6e2955"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="config-3.16.0-rc1-00055-gc6e2955"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.16.0-rc1 Kernel Configuration
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
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
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
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_FHANDLE is not set
CONFIG_USELIB=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
CONFIG_GENERIC_PENDING_IRQ=y
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
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_BSD_PROCESS_ACCT is not set
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
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_BOOST is not set
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
CONFIG_RCU_NOCB_CPU_ZERO=y
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
# CONFIG_CGROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
CONFIG_RD_LZMA=y
# CONFIG_RD_XZ is not set
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
# CONFIG_SGETMASK_SYSCALL is not set
# CONFIG_SYSFS_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
# CONFIG_EVENTFD is not set
# CONFIG_SHMEM is not set
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
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
# CONFIG_UPROBES is not set
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
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
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
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
# CONFIG_GCOV_FORMAT_3_4 is not set
CONFIG_GCOV_FORMAT_4_7=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_THROTTLING is not set
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
CONFIG_QUEUE_RWLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_BIGSMP is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_32_NON_STANDARD is not set
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_M486 is not set
CONFIG_M586=y
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
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
CONFIG_X86_F00F_BUG=y
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
# CONFIG_VM86 is not set
# CONFIG_X86_16BIT is not set
CONFIG_TOSHIBA=y
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_MICROCODE_EARLY is not set
CONFIG_X86_MSR=y
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
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
# CONFIG_COMPACTION is not set
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CLEANCACHE=y
# CONFIG_FRONTSWAP is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_HIGHPTE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
CONFIG_DEBUG_HOTPLUG_CPU0=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_DPM_WATCHDOG is not set
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
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
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
# CONFIG_APM_IGNORE_USER_SUSPEND is not set
CONFIG_APM_DO_ENABLE=y
# CONFIG_APM_CPU_IDLE is not set
CONFIG_APM_DISPLAY_BLANK=y
# CONFIG_APM_ALLOW_INTS is not set

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
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K7_ACPI=y
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=y
# CONFIG_X86_P4_CLOCKMOD is not set
CONFIG_X86_CPUFREQ_NFORCE2=y
# CONFIG_X86_LONGRUN is not set
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
# CONFIG_EISA_VIRTUAL_ROOT is not set
CONFIG_EISA_NAMES=y
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_I82365 is not set
CONFIG_TCIC=y
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
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
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_IOSF_MBI=y
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
# CONFIG_NET_PTP_CLASSIFY is not set
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
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

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
# CONFIG_UEVENT_HELPER is not set
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
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
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_CMDLINE_PARTS=y
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
CONFIG_FTL=y
# CONFIG_NFTL is not set
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
# CONFIG_SSFDC is not set
CONFIG_SM_FTL=y
CONFIG_MTD_OOPS=y
CONFIG_MTD_SWAP=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
CONFIG_MTD_CFI_LE_BYTE_SWAP=y
CONFIG_MTD_CFI_GEOMETRY=y
# CONFIG_MTD_MAP_BANK_WIDTH_1 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_2 is not set
CONFIG_MTD_MAP_BANK_WIDTH_4=y
CONFIG_MTD_MAP_BANK_WIDTH_8=y
CONFIG_MTD_MAP_BANK_WIDTH_16=y
CONFIG_MTD_MAP_BANK_WIDTH_32=y
# CONFIG_MTD_CFI_I1 is not set
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_OTP=y
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PHYSMAP is not set
CONFIG_MTD_SCx200_DOCFLASH=y
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=y
CONFIG_MTD_DATAFLASH_WRITE_VERIFY=y
# CONFIG_MTD_DATAFLASH_OTP is not set
# CONFIG_MTD_M25P80 is not set
CONFIG_MTD_SST25L=y
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
CONFIG_MTD_BLOCK2MTD=y

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
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=y
# CONFIG_MTD_NAND_DENALI_PCI is not set
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH=y
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
# CONFIG_MTD_NAND_DOCG4 is not set
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_CS553X=y
# CONFIG_MTD_NAND_NANDSIM is not set
CONFIG_MTD_NAND_PLATFORM=y
# CONFIG_MTD_ONENAND is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_SPI_NOR=y
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=y
# CONFIG_MTD_UBI_BLOCK is not set
# CONFIG_PARPORT is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

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
# CONFIG_ZRAM is not set
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
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_TI_DAC7512 is not set
CONFIG_VMWARE_BALLOON=y
CONFIG_BMP085=y
# CONFIG_BMP085_I2C is not set
CONFIG_BMP085_SPI=y
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
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

#
# Intel MIC Card Driver
#
CONFIG_ECHO=y
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_IDE_LEGACY=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=y
# CONFIG_IDE_GD_ATA is not set
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECS=y
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=y
# CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS is not set
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
CONFIG_BLK_DEV_PLATFORM=y
CONFIG_BLK_DEV_CMD640=y
CONFIG_BLK_DEV_CMD640_ENHANCED=y
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
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_CS5536 is not set
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

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
CONFIG_BLK_DEV_4DRIVES=y
# CONFIG_BLK_DEV_ALI14XX is not set
# CONFIG_BLK_DEV_DTC2278 is not set
CONFIG_BLK_DEV_HT6560B=y
CONFIG_BLK_DEV_QD65XX=y
CONFIG_BLK_DEV_UMC8672=y
# CONFIG_BLK_DEV_IDEDMA is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
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
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5520=y
CONFIG_KEYBOARD_ADP5588=y
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
CONFIG_KEYBOARD_QT2160=y
CONFIG_KEYBOARD_LKKBD=y
# CONFIG_KEYBOARD_TCA6416 is not set
CONFIG_KEYBOARD_TCA8418=y
# CONFIG_KEYBOARD_LM8323 is not set
CONFIG_KEYBOARD_LM8333=y
CONFIG_KEYBOARD_MAX7359=y
CONFIG_KEYBOARD_MCS=y
CONFIG_KEYBOARD_MPR121=y
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_TC3589X=y
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
CONFIG_MOUSE_SERIAL=y
CONFIG_MOUSE_APPLETOUCH=y
CONFIG_MOUSE_BCM5974=y
CONFIG_MOUSE_CYAPA=y
CONFIG_MOUSE_INPORT=y
# CONFIG_MOUSE_ATIXL is not set
CONFIG_MOUSE_LOGIBM=y
CONFIG_MOUSE_PC110PAD=y
CONFIG_MOUSE_VSXXXAA=y
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
CONFIG_MOUSE_SYNAPTICS_USB=y
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
CONFIG_JOYSTICK_GUILLEMOT=y
# CONFIG_JOYSTICK_INTERACT is not set
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=y
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=y
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=y
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=y
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_ZHENHUA=y
# CONFIG_JOYSTICK_AS5011 is not set
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
CONFIG_TABLET_USB_AIPTEK=y
CONFIG_TABLET_USB_GTCO=y
CONFIG_TABLET_USB_HANWANG=y
# CONFIG_TABLET_USB_KBTAB is not set
CONFIG_TABLET_USB_WACOM=y
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_88PM80X_ONKEY is not set
CONFIG_INPUT_AD714X=y
CONFIG_INPUT_AD714X_I2C=y
CONFIG_INPUT_AD714X_SPI=y
# CONFIG_INPUT_ARIZONA_HAPTICS is not set
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_PCSPKR=y
CONFIG_INPUT_MAX8925_ONKEY=y
CONFIG_INPUT_MC13783_PWRBUTTON=y
# CONFIG_INPUT_MMA8450 is not set
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=y
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
CONFIG_INPUT_POWERMATE=y
CONFIG_INPUT_YEALINK=y
CONFIG_INPUT_CM109=y
CONFIG_INPUT_RETU_PWRBUTTON=y
CONFIG_INPUT_TWL4030_PWRBUTTON=y
CONFIG_INPUT_TWL4030_VIBRA=y
CONFIG_INPUT_TWL6040_VIBRA=y
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_PCF50633_PMU is not set
CONFIG_INPUT_PCF8574=y
# CONFIG_INPUT_DA9052_ONKEY is not set
# CONFIG_INPUT_DA9055_ONKEY is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_IMS_PCU is not set
CONFIG_INPUT_CMA3000=y
CONFIG_INPUT_CMA3000_I2C=y
CONFIG_INPUT_IDEAPAD_SLIDEBAR=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
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
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
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
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_MEN_Z135 is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_TPM=y
# CONFIG_NVRAM is not set
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_MWAVE is not set
# CONFIG_SCx200_GPIO is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_ATMEL is not set
# CONFIG_TCG_TIS_I2C_INFINEON is not set
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
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
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
CONFIG_I2C_HELPER_AUTO=y
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
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_KEMPLD=y
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_ROBOTFUZZ_OSIF=y
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set
CONFIG_I2C_VIPERBOARD=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_ISA=y
# CONFIG_SCx200_ACB is not set
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
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=y
# CONFIG_SPI_TOPCLIFF_PCH is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
CONFIG_SPI_DESIGNWARE=y
# CONFIG_SPI_DW_PCI is not set
CONFIG_SPI_DW_MMIO=y

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_TLE62X0=y
# CONFIG_SPMI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
CONFIG_HSI_CHAR=y

#
# PPS support
#
# CONFIG_PPS is not set

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
# CONFIG_GPIOLIB is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_DS1WM is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_MAX8925_POWER=y
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_DS2780=y
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9030=y
# CONFIG_BATTERY_DA9052 is not set
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_PCF50633=y
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_TWL4030=y
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_MAX14577=y
CONFIG_CHARGER_MAX8998=y
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_SMB347=y
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_MC13783_ADC=y
CONFIG_SENSORS_FSCHMD=y
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
# CONFIG_SENSORS_LTC4222 is not set
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
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_HTU21 is not set
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_NTC_THERMISTOR=y
# CONFIG_SENSORS_NCT6683 is not set
# CONFIG_SENSORS_NCT6775 is not set
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SHTC1=y
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_ADC128D818 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
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
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=y
# CONFIG_ACPI_INT3403_THERMAL is not set
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

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
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_AS3711=y
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_BCM590XX=y
CONFIG_MFD_AXP20X=y
# CONFIG_MFD_CROS_EC is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX14577=y
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RTSX_USB is not set
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP3943=y
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS65218 is not set
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
CONFIG_MFD_TWL4030_AUDIO=y
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_ARIZONA_SPI is not set
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8400=y
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_88PM800=y
# CONFIG_REGULATOR_ACT8865 is not set
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_ANATOP=y
# CONFIG_REGULATOR_ARIZONA is not set
CONFIG_REGULATOR_AS3711=y
# CONFIG_REGULATOR_AXP20X is not set
# CONFIG_REGULATOR_BCM590XX is not set
CONFIG_REGULATOR_DA903X=y
CONFIG_REGULATOR_DA9052=y
# CONFIG_REGULATOR_DA9055 is not set
CONFIG_REGULATOR_DA9063=y
CONFIG_REGULATOR_DA9210=y
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=y
CONFIG_REGULATOR_LTC3589=y
CONFIG_REGULATOR_MAX14577=y
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8998=y
CONFIG_REGULATOR_MC13XXX_CORE=y
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_MC13892=y
# CONFIG_REGULATOR_PCF50633 is not set
CONFIG_REGULATOR_PFUZE100=y
# CONFIG_REGULATOR_RC5T583 is not set
CONFIG_REGULATOR_S2MPA01=y
CONFIG_REGULATOR_S2MPS11=y
CONFIG_REGULATOR_S5M8767=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_TPS6586X=y
CONFIG_REGULATOR_TPS80031=y
# CONFIG_REGULATOR_TWL4030 is not set
CONFIG_REGULATOR_WM8400=y
# CONFIG_MEDIA_SUPPORT is not set

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
# CONFIG_DRM is not set

#
# Frame buffer Devices
#
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
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
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_OPENCORES=y
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
# CONFIG_FB_SM501 is not set
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=y
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=y
# CONFIG_FB_AUO_K1900 is not set
CONFIG_FB_AUO_K1901=y
# CONFIG_FB_SIMPLE is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_LTV350QV is not set
CONFIG_LCD_ILI922X=y
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=y
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=y
# CONFIG_LCD_S6E63M0 is not set
CONFIG_LCD_LD9040=y
CONFIG_LCD_AMS369FG06=y
CONFIG_LCD_LMS501KF03=y
CONFIG_LCD_HX8357=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_LM3533 is not set
CONFIG_BACKLIGHT_DA903X=y
CONFIG_BACKLIGHT_DA9052=y
CONFIG_BACKLIGHT_MAX8925=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_PCF50633=y
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_PANDORA is not set
# CONFIG_BACKLIGHT_AS3711 is not set
CONFIG_BACKLIGHT_LV5207LP=y
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_VGASTATE is not set
# CONFIG_LOGO is not set
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
# CONFIG_SND_PCM_OSS_PLUGINS is not set
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
CONFIG_SND_OPL3_LIB_SEQ=y
CONFIG_SND_OPL4_LIB_SEQ=y
CONFIG_SND_SBAWE_SEQ=y
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_OPL4_LIB=y
CONFIG_SND_VX_LIB=y
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_WSS_LIB=y
CONFIG_SND_SB_COMMON=y
CONFIG_SND_SB16_DSP=y
CONFIG_SND_ISA=y
CONFIG_SND_ADLIB=y
# CONFIG_SND_AD1816A is not set
CONFIG_SND_AD1848=y
# CONFIG_SND_ALS100 is not set
CONFIG_SND_AZT1605=y
# CONFIG_SND_AZT2316 is not set
# CONFIG_SND_AZT2320 is not set
CONFIG_SND_CMI8328=y
# CONFIG_SND_CMI8330 is not set
CONFIG_SND_CS4231=y
CONFIG_SND_CS4236=y
# CONFIG_SND_ES1688 is not set
CONFIG_SND_ES18XX=y
CONFIG_SND_SC6000=y
# CONFIG_SND_GUSCLASSIC is not set
CONFIG_SND_GUSEXTREME=y
# CONFIG_SND_GUSMAX is not set
# CONFIG_SND_INTERWAVE is not set
# CONFIG_SND_INTERWAVE_STB is not set
# CONFIG_SND_JAZZ16 is not set
# CONFIG_SND_OPL3SA2 is not set
CONFIG_SND_OPTI92X_AD1848=y
CONFIG_SND_OPTI92X_CS4231=y
CONFIG_SND_OPTI93X=y
CONFIG_SND_MIRO=y
# CONFIG_SND_SB8 is not set
# CONFIG_SND_SB16 is not set
CONFIG_SND_SBAWE=y
CONFIG_SND_SB16_CSP=y
CONFIG_SND_SSCAPE=y
CONFIG_SND_WAVEFRONT=y
CONFIG_SND_MSND_PINNACLE=y
CONFIG_SND_MSND_CLASSIC=y
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

#
# HD-Audio
#
# CONFIG_SND_HDA_INTEL is not set
CONFIG_SND_SPI=y
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=y
# CONFIG_SND_USB_UA101 is not set
CONFIG_SND_USB_USX2Y=y
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_USB_US122L is not set
CONFIG_SND_USB_6FIRE=y
CONFIG_SND_USB_HIFACE=y
CONFIG_SND_BCD2000=y
CONFIG_SND_PCMCIA=y
CONFIG_SND_VXPOCKET=y
CONFIG_SND_PDAUDIOCF=y
CONFIG_SND_SOC=y
CONFIG_SND_ATMEL_SOC=y

#
# SoC Audio for Freescale CPUs
#

#
# Common SoC Audio options for Freescale CPUs:
#
# CONFIG_SND_SOC_FSL_SAI is not set
CONFIG_SND_SOC_FSL_SSI=y
CONFIG_SND_SOC_FSL_SPDIF=y
CONFIG_SND_SOC_FSL_ESAI=y
CONFIG_SND_SOC_FSL_UTILS=y
CONFIG_SND_SOC_IMX_AUDMUX=y
CONFIG_SND_SOC_INTEL_SST=y
CONFIG_SND_SOC_INTEL_SST_ACPI=y
CONFIG_SND_SOC_I2C_AND_SPI=y

#
# CODEC drivers
#
CONFIG_SND_SOC_ADAU1701=y
CONFIG_SND_SOC_AK4104=y
CONFIG_SND_SOC_AK4554=y
CONFIG_SND_SOC_AK4642=y
CONFIG_SND_SOC_AK5386=y
# CONFIG_SND_SOC_ALC5623 is not set
CONFIG_SND_SOC_CS42L52=y
CONFIG_SND_SOC_CS42L56=y
CONFIG_SND_SOC_CS42L73=y
CONFIG_SND_SOC_CS4270=y
CONFIG_SND_SOC_CS4271=y
CONFIG_SND_SOC_CS42XX8=y
CONFIG_SND_SOC_CS42XX8_I2C=y
CONFIG_SND_SOC_HDMI_CODEC=y
CONFIG_SND_SOC_PCM1681=y
CONFIG_SND_SOC_PCM1792A=y
# CONFIG_SND_SOC_PCM512x_I2C is not set
# CONFIG_SND_SOC_PCM512x_SPI is not set
CONFIG_SND_SOC_SGTL5000=y
CONFIG_SND_SOC_SIGMADSP=y
CONFIG_SND_SOC_SIRF_AUDIO_CODEC=y
CONFIG_SND_SOC_SPDIF=y
# CONFIG_SND_SOC_STA350 is not set
# CONFIG_SND_SOC_TAS5086 is not set
# CONFIG_SND_SOC_TLV320AIC3X is not set
# CONFIG_SND_SOC_WM8510 is not set
# CONFIG_SND_SOC_WM8523 is not set
CONFIG_SND_SOC_WM8580=y
CONFIG_SND_SOC_WM8711=y
CONFIG_SND_SOC_WM8728=y
# CONFIG_SND_SOC_WM8731 is not set
CONFIG_SND_SOC_WM8737=y
# CONFIG_SND_SOC_WM8741 is not set
CONFIG_SND_SOC_WM8750=y
CONFIG_SND_SOC_WM8753=y
CONFIG_SND_SOC_WM8770=y
CONFIG_SND_SOC_WM8776=y
CONFIG_SND_SOC_WM8804=y
CONFIG_SND_SOC_WM8903=y
CONFIG_SND_SOC_WM8962=y
# CONFIG_SND_SOC_TPA6130A2 is not set
CONFIG_SND_SIMPLE_CARD=y
CONFIG_SOUND_PRIME=y
# CONFIG_SOUND_OSS is not set

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
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=y
CONFIG_HID_PRODIKEYS=y
# CONFIG_HID_CYPRESS is not set
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
# CONFIG_HID_EZKEY is not set
CONFIG_HID_KEYTOUCH=y
# CONFIG_HID_KYE is not set
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
# CONFIG_HID_MONTEREY is not set
CONFIG_HID_MULTITOUCH=y
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_PRIMAX=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SPEEDLINK=y
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=y
CONFIG_HID_RMI=y
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=y
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
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEFAULT_PERSIST is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_OTG=y
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_OTG_FSM=y
CONFIG_USB_MON=y
CONFIG_USB_WUSB_CBAF=y
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_FUSBH200_HCD=y
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_MAX3421_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
CONFIG_USB_OHCI_HCD_PLATFORM=y
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_U132_HCD=y
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_HCD_ISO is not set
CONFIG_USB_SL811_CS=y
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_HCD_BCMA=y
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
# CONFIG_USB_MDC800 is not set
CONFIG_USB_MUSB_HDRC=y
CONFIG_USB_MUSB_HOST=y
CONFIG_USB_MUSB_TUSB6010=y
# CONFIG_USB_MUSB_UX500 is not set
CONFIG_MUSB_PIO_ONLY=y
# CONFIG_USB_DWC3 is not set
CONFIG_USB_DWC2=y
CONFIG_USB_DWC2_HOST=y
# CONFIG_USB_DWC2_PLATFORM is not set
CONFIG_USB_DWC2_PCI=y

#
# Gadget mode requires USB Gadget support to be enabled
#
CONFIG_USB_DWC2_DEBUG=y
CONFIG_USB_DWC2_VERBOSE=y
# CONFIG_USB_DWC2_TRACK_MISSED_SOFS is not set
# CONFIG_USB_DWC2_DEBUG_PERIODIC is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=y
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y
# CONFIG_USB_EZUSB_FX2 is not set
CONFIG_USB_HSIC_USB3503=y

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_TAHVO_USB=y
# CONFIG_TAHVO_USB_HOST_BY_DEFAULT is not set
CONFIG_USB_ISP1301=y
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_CLKGATE is not set

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
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_VUB300 is not set
# CONFIG_MMC_USHC is not set
CONFIG_MMC_USDHI6ROL0=y
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
# CONFIG_MSPRO_BLOCK is not set
# CONFIG_MS_BLOCK is not set

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
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_LP8788=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
# CONFIG_LEDS_DA903X is not set
CONFIG_LEDS_DA9052=y
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_ADP5520=y
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_ACCESSIBILITY=y
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_MM_EDAC is not set
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
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# SOC (System On Chip) specific Drivers
#

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
CONFIG_EXTCON_MAX14577=y
# CONFIG_EXTCON_ARIZONA is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_PHY_SAMSUNG_USB2 is not set
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y
CONFIG_MCB=y
# CONFIG_MCB_PCI is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4_USE_FOR_EXT23 is not set
# CONFIG_EXT4_FS_POSIX_ACL is not set
CONFIG_EXT4_FS_SECURITY=y
CONFIG_EXT4_DEBUG=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
# CONFIG_REISERFS_FS_SECURITY is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
# CONFIG_XFS_POSIX_ACL is not set
CONFIG_XFS_RT=y
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
CONFIG_BTRFS_ASSERT=y
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
# CONFIG_FSNOTIFY is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
CONFIG_FSCACHE_DEBUG=y
# CONFIG_FSCACHE_OBJECT_LIST is not set
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
# CONFIG_ADFS_FS_RW is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=y
CONFIG_HFSPLUS_FS_POSIX_ACL=y
CONFIG_BEFS_FS=y
CONFIG_BEFS_DEBUG=y
CONFIG_BFS_FS=y
# CONFIG_EFS_FS is not set
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
CONFIG_JFFS2_CMODE_NONE=y
# CONFIG_JFFS2_CMODE_PRIORITY is not set
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
CONFIG_UBIFS_FS=y
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_FILE_CACHE=y
# CONFIG_SQUASHFS_FILE_DIRECT is not set
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
CONFIG_SQUASHFS_DECOMP_MULTI=y
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
# CONFIG_SQUASHFS_XATTR is not set
# CONFIG_SQUASHFS_ZLIB is not set
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_RAM=y
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=y
CONFIG_UFS_FS_WRITE=y
# CONFIG_UFS_DEBUG is not set
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
# CONFIG_F2FS_FS_POSIX_ACL is not set
# CONFIG_F2FS_FS_SECURITY is not set
# CONFIG_F2FS_CHECK_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
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
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
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
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_DEBUG_SLAB=y
# CONFIG_DEBUG_SLAB_LEAK is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_VMACACHE is not set
# CONFIG_DEBUG_VM_RB is not set
CONFIG_DEBUG_VIRTUAL=y
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
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
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
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_PI_LIST=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
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
CONFIG_RING_BUFFER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
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
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
CONFIG_DOUBLEFAULT=y
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
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_YAMA_STACKED is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
# CONFIG_IMA is not set
CONFIG_EVM=y

#
# EVM options
#
CONFIG_EVM_ATTR_FSUUID=y
CONFIG_DEFAULT_SECURITY_YAMA=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="yama"
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
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y

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
# CONFIG_CRYPTO_XTS is not set

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
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y

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
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_CCP is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
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
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
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
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
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


--------------000500000707070800080307
Content-Type: text/plain; charset=UTF-8;
 name="Attached Message Part"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Attached Message Part"

_______________________________________________
LKP mailing list
LKP@linux.intel.com


--------------000500000707070800080307--
