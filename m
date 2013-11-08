Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab3KHCQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:16:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:25806 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755988Ab3KHCQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:16:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,656,1378882800"; 
   d="log'?scan'208";a="424076860"
Date: Fri, 8 Nov 2013 10:15:45 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Joe Mario <jmario@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        "Kleen, Andi" <andi.kleen@intel.com>
Subject: [kbuild/init_mm] BUG: unable to handle kernel NULL pointer
 dereference at   (null)
Message-ID: <20131108021545.GA7191@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit eea0e9cbb9e65cd553d302a4aefd4c7b70d9fd90
Author: Joe Mario <jmario@redhat.com>
Date:   Wed Oct 23 15:06:53 2013 +0200

    kbuild: Increase kallsyms max symbol length
    
    [AK: This seems like a ticking time bomb even without LTO,
    so should be merged now. It causes very weird problems.
    Thanks to Joe for tracking them down.]
    
    With the added postfixes that LTO adds for local
    symbols, the longest name in the kernel overflows
    the namebuf[KSYM_NAME_LEN] array by two bytes.  That name is:
    __pci_fixup_resumePCI_VENDOR_ID_SERVERWORKSPCI_DEVICE_ID_SERVERWORKS_HT1000SBquirk_disable_broadcom_boot_interrupt.1488004.672802
    
    Double the max symbol name length.
    
    v2: Use 255  (Joe Perches)
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Michal Marek <mmarek@suse.cz>

===================================================
PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
===================================================

+---------------------------------------------------------------+--------------+--------------+
|                                                               | 80970472179a | 71cc615a91a4 |
+---------------------------------------------------------------+--------------+--------------+
| good_boots                                                    | 58           |              |
| has_kernel_error_warning                                      | 2            | 13           |
| kernel_BUG_at_include/linux/mm.h                              | 1            |              |
| invalid_opcode:PREEMPT_SMP_DEBUG_PAGEALLOC                    | 1            |              |
| Kernel_panic-not_syncing:Fatal_exception                      | 1            | 13           |
| BUG:Bad_page_map_in_process_killall5_pte:pmd                  | 1            |              |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference_at(null) | 0            | 13           |
| Oops:PREEMPT_SMP_DEBUG_PAGEALLOC                              | 0            | 13           |
+---------------------------------------------------------------+--------------+--------------+

[    1.380240] The force parameter has not been set to 1. The Iris poweroff handler will not be installed.
[    1.381547] audit: initializing netlink socket (disabled)
[    1.382099] type=2000 audit(1383814476.894:1): initialized
[    1.402375] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    1.403079] IP: [<415218f4>] init_mm+0x0/0x210
[    1.403511] *pde = 00000000 
[    1.403798] Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    1.404341] Modules linked in:
[    1.404647] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.12.0-09952-g71cc615 #916
[    1.405343] task: 4d41b440 ti: 4d428000 task.ti: 4d428000
[    1.405843] EIP: 0060:[<415218f4>] EFLAGS: 00010206 CPU: 1
[    1.406369] EIP is at init_mm+0x0/0x210
[    1.406729] EAX: 00000000 EBX: 000000ae ECX: 00000000 EDX: 00000001
[    1.407315] ESI: 00000006 EDI: 00000006 EBP: 41558416 ESP: 4d429f94
[    1.407894]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    1.408402] CR0: 8005003b CR2: 00000000 CR3: 015b0000 CR4: 000006d0
[    1.408980] Stack:
[    1.409181]  4d41b440 4e4ed440 4d429fac 41339741 415218f4 4d42bf88 4d428000 41348177
[    1.409993]  41339736 00000000 00000000 00000000 00000000 00000000 00000000 0000007b
[    1.410009]  0000007b 000000d8 00000000 ffffffff 00000000 00000060 00000202 00000000
[    1.410009] Call Trace:
[    1.410009]  [<41339741>] ? kernel_init+0xb/0xc3
[    1.410009]  [<41348177>] ? ret_from_kernel_thread+0x1b/0x28
[    1.410009]  [<41339736>] ? rest_init+0xb6/0xb6
[    1.410009] Code: 2a 49 41 38 91 40 4d 60 b6 4b 4d 06 06 00 00 ad 4e ad de ff ff ff ff ff ff ff ff e4 18 52 41 88 7f 70 41 00 00 00 00 61 2a 49 41 <00> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.410009] EIP: [<415218f4>] init_mm+0x0/0x210 SS:ESP 0068:4d429f94
[    1.410009] CR2: 0000000000000000
[    1.410009] ---[ end trace 18ed5cfe6232afc1 ]---
[    1.410009] Kernel panic - not syncing: Fatal exception

git bisect start 71cc615a91a49d83e839c4b46f1f001ccd88e21f v3.12 --
git bisect  bad 4b2a7a1745bc3cba30ffca03ce0393bf4274677b  # 20:42      0-      1  Merge remote-tracking branch 'wireless-next/master'
git bisect good a879ddf7603be2c4fba0bb111bcde226a75d7f8e  # 21:11     20+      0  Merge remote-tracking branch 'pci/next'
git bisect good 87bc0728d462ae37841a550542829aa65a97e7c2  # 21:20     20+      0  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next into for-davem
git bisect  bad a43048ff66b455ee230d7ec5f97947eb4e031ebc  # 21:27      0-      8  Merge remote-tracking branch 'libata/for-next'
git bisect good 5c52a0f259af02c716ad064d752cb6efb1d29ec0  # 21:40     20+      0  Merge branch 'build_fixes' into to_next
git bisect good 7661c3f099c0afda7305af912c03ebd1c761735a  # 21:50     20+      0  Merge remote-tracking branch 'i2c/i2c/for-next'
git bisect good 81a67c32df4da1dbf1cf3715610ea820068a5935  # 21:55     20+      0  Merge remote-tracking branch 'v4l-dvb/master'
git bisect good 9fbe8e5b9724e0034618bd512df9eda4694e77d5  # 22:09     20+      0  Merge branch 'kbuild/kconfig' into kbuild/for-next
git bisect good 18a558067d501a2ccda061f99800f3a978379dc6  # 22:21     20+      0  Merge branch 'for-3.13' into for-next
git bisect good 1ca953d5f992ff5fe63a22546a21b915238d2455  # 22:27     20+      0  Merge branch 'for-3.13' into for-next
git bisect  bad 849464d1ba97a13b388fee9a69fbbeee175b349c  # 22:34      0-     17  kbuild: replace unbounded sprintf call in modpost
git bisect  bad f3462aa952cfc8f4b095103cb9b3d306dd216558  # 22:36      0-      3  Kbuild: Handle longer symbols in kallsyms.c
git bisect  bad eea0e9cbb9e65cd553d302a4aefd4c7b70d9fd90  # 22:38      0-      2  kbuild: Increase kallsyms max symbol length
git bisect good 80970472179a45609c0b11b80619bc8c32b15f77  # 22:44     60+      2  Makefile: enable -Werror=implicit-int and -Werror=strict-prototypes by default
git bisect good 48da1a29f5883ef9d14c6b828e469d86b4fc0980  # 01:19     60+      0  Add linux-next specific files for 20131107
git bisect good 72a94a8f755e1be19f1341cb70f6212ab908376c  # 01:29     60+      0  Revert "kbuild: Increase kallsyms max symbol length"
git bisect good a1212d278c05ca0a38f5cbd7ae90ac2e367228a8  # 01:33     60+      0  Revert "sysfs: drop kobj_ns_type handling"
git bisect good 48da1a29f5883ef9d14c6b828e469d86b4fc0980  # 01:33     60+      0  Add linux-next specific files for 20131107

Thanks,
Fengguang

--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-roam-7:20131107165442:i386-randconfig-r9-1107:3.12.0-09952-g71cc615:916"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-09952-g71cc615 (kbuild@roam) (gcc versi=
on 4.8.1 (Debian 4.8.1-8) ) #916 SMP PREEMPT Thu Nov 7 16:52:09 CST 2013
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000]   UMC UMC UMC UMC
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
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[400fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x023fffff]
[    0.000000] Base memory trampoline at [4009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
[    0.000000]  [mem 0x0e000000-0x0e3fffff] page 4k
[    0.000000] BRK [0x01a7d000, 0x01a7dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
[    0.000000]  [mem 0x08000000-0x0dffffff] page 4k
[    0.000000] BRK [0x01a7e000, 0x01a7efff] PGTABLE
[    0.000000] BRK [0x01a7f000, 0x01a7ffff] PGTABLE
[    0.000000] BRK [0x01a80000, 0x01a80fff] PGTABLE
[    0.000000] BRK [0x01a81000, 0x01a81fff] PGTABLE
[    0.000000] BRK [0x01a82000, 0x01a82fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x07ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
[    0.000000]  [mem 0x0e400000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128348(97%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
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
[    0.000000] free_area_init_node: node 0, pgdat 41550760, node_mem_map 4e=
4ff024
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 540 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
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
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @4e4e7000 s27584 r0 d21568 u49=
152
[    0.000000] pcpu-alloc: s27584 r0 d21568 u49152 alloc=3D12*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr e4e9740
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64860
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/i386-randconfig-r9-1107/next:master/.vmlinuz=
-71cc615a91a49d83e839c4b46f1f001ccd88e21f-20131107165425-3-roam branch=3Dne=
xt/master BOOT_IMAGE=3D/kernel/i386-randconfig-r9-1107/71cc615a91a49d83e839=
c4b46f1f001ccd88e21f/vmlinuz-3.12.0-09952-g71cc615
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 214608K/261744K available (3362K kernel code, 302K r=
wdata, 1800K rodata, 332K init, 4892K bss, 47136K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff15000 - 0xfffff000   ( 936 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x507fe000 - 0xff7fe000   (2800 MB)
[    0.000000]     lowmem  : 0x40000000 - 0x4fffe000   ( 255 MB)
[    0.000000]       .init : 0x41558000 - 0x415ab000   ( 332 kB)
[    0.000000]       .data : 0x41348f41 - 0x41557980   (2106 kB)
[    0.000000]       .text : 0x41000000 - 0x41348f41   (3363 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3D4d404000 soft=3D4d406000
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
[    0.000000]  memory used by lock dependency info: 3551 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] ODEBUG: 4 of 4 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2892.982 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5785.96 Bogo=
MIPS (lpj=3D28929820)
[    0.020000] pid_max: default: 4096 minimum: 301
[    0.020000] Security Framework initialized
[    0.020000] Smack:  Initializing.
[    0.020000] AppArmor: AppArmor disabled by boot time parameter
[    0.020000] Yama: becoming mindful.
[    0.020000] Mount-cache hash table entries: 512
[    0.020000] Initializing cgroup subsys devices
[    0.020000] Initializing cgroup subsys freezer
[    0.020000] mce: CPU supports 10 MCE banks
[    0.020000] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020000] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020000] tlb_flushall_shift: 6
[    0.020000] debug: unmapping init [mem 0x415ab000-0x415acfff]
[    0.020000] ACPI: Core revision 20130927
[    0.022659] ACPI: All ACPI Tables successfully acquired
[    0.023421] Getting VERSION: 50014
[    0.023775] Getting VERSION: 50014
[    0.024121] Getting ID: 0
[    0.024402] Getting ID: f000000
[    0.024729] Getting LVT0: 8700
[    0.025040] Getting LVT1: 8400
[    0.025354] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.025960] enabled ExtINT on CPU#0
[    0.027226] ENABLING IO-APIC IRQs
[    0.027580] init IO_APIC IRQs
[    0.027880]  apic 0 pin 0 not connected
[    0.028272] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.029075] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.029880] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.030023] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.030813] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.031598] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.032377] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.033160] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.033948] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.034732] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.035526] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.036330] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.037138] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.037940] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.038746] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.040019]  apic 0 pin 16 not connected
[    0.040406]  apic 0 pin 17 not connected
[    0.040793]  apic 0 pin 18 not connected
[    0.041184]  apic 0 pin 19 not connected
[    0.041569]  apic 0 pin 20 not connected
[    0.041956]  apic 0 pin 21 not connected
[    0.042348]  apic 0 pin 22 not connected
[    0.042733]  apic 0 pin 23 not connected
[    0.043267] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.044004] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.045003] Using local APIC timer interrupts.
[    0.045003] calibrating APIC timer ...
[    0.050000] ... lapic delta =3D 6249745
[    0.050000] ... PM-Timer delta =3D 357890
[    0.050000] ... PM-Timer result ok
[    0.050000] ..... delta 6249745
[    0.050000] ..... mult: 268424503
[    0.050000] ..... calibration result: 9999592
[    0.050000] ..... CPU clock speed is 2892.4351 MHz.
[    0.050000] ..... host bus clock speed is 999.9592 MHz.
[    0.050000] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.120201] CPU 1 irqstacks, hard=3D4d46a000 soft=3D4d46c000
[    0.120884] x86: Booting SMP configuration:
[    0.121368] .... node  #0, CPUs:      #1
[    0.010000] Initializing CPU#1
[    0.020000] kvm-clock: cpu 1, msr 0:fffd021, secondary cpu clock
[    0.020000] masked ExtINT on CPU#1

[    0.150092] x86: Booted up 1 node, 2 CPUs
[    0.150050] KVM setup async PF for cpu 1
[    0.150050] kvm-stealtime: cpu 1, msr e4f5740
[    0.151330] ----------------
[    0.151610] | NMI testsuite:
[    0.151897] --------------------
[    0.152207]   remote IPI:  ok  |
[    0.180157]    local IPI:  ok  |
[    0.240025] --------------------
[    0.240373] Good, all   2 testcases passed! |
[    0.240794] ---------------------------------
[    0.241209] smpboot: Total of 2 processors activated (11571.92 BogoMIPS)
[    0.242216] devtmpfs: initialized
[    0.242216] EVM: security.SMACK64
[    0.242216] EVM: security.capability
[    0.242335] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.243196] regulator-dummy: no parameters
[    0.243768] NET: Registered protocol family 16
[    0.244479] cpuidle: using governor ladder
[    0.244896] cpuidle: using governor menu
[    0.245577] ACPI: bus type PCI registered
[    0.246108] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.246719] PCI: Using configuration type 1 for base access
[    0.251783] ACPI: Added _OSI(Module Device)
[    0.251783] ACPI: Added _OSI(Processor Device)
[    0.251783] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.251783] ACPI: Added _OSI(Processor Aggregator Device)
[    0.260402] ACPI: Interpreter enabled
[    0.260783] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20130927/hwxface-580)
[    0.261694] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20130927/hwxface-580)
[    0.262621] ACPI: (supports S0 S3 S5)
[    0.262976] ACPI: Using IOAPIC for interrupt routing
[    0.263478] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.273244] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.273883] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.274417] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.275409] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.276576] PCI host bridge to bus 0000:00
[    0.276981] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.277502] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.278109] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.278719] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.279372] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.280054] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.281105] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.282269] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.285977] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.288018] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.288911] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.289611] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.290310] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.292319] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.294277] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.301323] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.302320] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.304099] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.305844] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.312302] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.313228] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.315023] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.316724] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.323331] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.325114] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.326803] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.333826] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.335611] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.337302] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.343851] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.345635] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.347334] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.354463] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.356233] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.357932] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.364420] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.366198] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.367892] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.375031] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.376224] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.380685] pci_bus 0000:00: on NUMA node 0
[    0.382013] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.382848] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.383696] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.384527] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.385223] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.386622] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.387126] ACPI: \_SB_.PCI0: notify handler is installed
[    0.387704] Found 1 acpi root devices
[    0.388246] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.388246] vgaarb: loaded
[    0.388246] vgaarb: bridge control possible 0000:00:02.0
[    0.390135] pps_core: LinuxPPS API ver. 1 registered
[    0.390625] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.391505] PTP clock support registered
[    0.391968] PCI: Using ACPI for IRQ routing
[    0.392385] PCI: pci_cache_line_size set to 64 bytes
[    0.393033] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.393628] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.394470] irda_init()
[    0.394784] NET: Registered protocol family 23
[    0.395253] NetLabel: Initializing
[    0.395593] NetLabel:  domain hash size =3D 128
[    0.396013] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.396538] NetLabel:  unlabeled traffic allowed by default
[    0.397286] Switched to clocksource kvm-clock
[    0.397355] FS-Cache: Loaded
[    0.397355] pnp: PnP ACPI init
[    0.397355] ACPI: bus type PNP registered
[    0.397355] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.397355] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.397355] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.397355] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.397355] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.397355] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.397355] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.397355] pnp 00:03: [dma 2]
[    0.397355] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.397988] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.398772] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.399491] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.400319] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.401255] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.402131] pnp: PnP ACPI: found 7 devices
[    0.402517] ACPI: bus type PNP unregistered
[    0.438297] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.438842] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.439370] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.439950] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.440598] NET: Registered protocol family 2
[    0.441345] TCP established hash table entries: 2048 (order: 1, 8192 byt=
es)
[    0.442108] TCP bind hash table entries: 2048 (order: 4, 73728 bytes)
[    0.442779] TCP: Hash tables configured (established 2048 bind 2048)
[    0.443423] TCP: reno registered
[    0.443742] UDP hash table entries: 128 (order: 1, 10240 bytes)
[    0.444315] UDP-Lite hash table entries: 128 (order: 1, 10240 bytes)
[    0.445081] NET: Registered protocol family 1
[    0.445509] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.446092] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.446643] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.447244] pci 0000:00:02.0: Boot video device
[    0.447729] PCI: CLS 0 bytes, default 64
[    0.448254] Unpacking initramfs...
[    1.377233] debug: unmapping init [mem 0x4e73f000-0x4ffeffff]
[    1.378500] Machine check injector initialized
[    1.379600] PCLMULQDQ-NI instructions are not detected.
[    1.380240] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    1.381547] audit: initializing netlink socket (disabled)
[    1.382099] type=3D2000 audit(1383814476.894:1): initialized
[    1.402375] BUG: unable to handle kernel NULL pointer dereference at   (=
null)
[    1.403079] IP: [<415218f4>] init_mm+0x0/0x210
[    1.403511] *pde =3D 00000000=20
[    1.403798] Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    1.404341] Modules linked in:
[    1.404647] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.12.0-09952-g71cc=
615 #916
[    1.405343] task: 4d41b440 ti: 4d428000 task.ti: 4d428000
[    1.405843] EIP: 0060:[<415218f4>] EFLAGS: 00010206 CPU: 1
[    1.406369] EIP is at init_mm+0x0/0x210
[    1.406729] EAX: 00000000 EBX: 000000ae ECX: 00000000 EDX: 00000001
[    1.407315] ESI: 00000006 EDI: 00000006 EBP: 41558416 ESP: 4d429f94
[    1.407894]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    1.408402] CR0: 8005003b CR2: 00000000 CR3: 015b0000 CR4: 000006d0
[    1.408980] Stack:
[    1.409181]  4d41b440 4e4ed440 4d429fac 41339741 415218f4 4d42bf88 4d428=
000 41348177
[    1.409993]  41339736 00000000 00000000 00000000 00000000 00000000 00000=
000 0000007b
[    1.410009]  0000007b 000000d8 00000000 ffffffff 00000000 00000060 00000=
202 00000000
[    1.410009] Call Trace:
[    1.410009]  [<41339741>] ? kernel_init+0xb/0xc3
[    1.410009]  [<41348177>] ? ret_from_kernel_thread+0x1b/0x28
[    1.410009]  [<41339736>] ? rest_init+0xb6/0xb6
[    1.410009] Code: 2a 49 41 38 91 40 4d 60 b6 4b 4d 06 06 00 00 ad 4e ad =
de ff ff ff ff ff ff ff ff e4 18 52 41 88 7f 70 41 00 00 00 00 61 2a 49 41 =
<00> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.410009] EIP: [<415218f4>] init_mm+0x0/0x210 SS:ESP 0068:4d429f94
[    1.410009] CR2: 0000000000000000
[    1.410009] ---[ end trace 18ed5cfe6232afc1 ]---
[    1.410009] Kernel panic - not syncing: Fatal exception
[    1.410009] Kernel Offset: 0x0 from 0x41000000 (relocation range: 0x4000=
0000-0x507fdfff)
[    1.410009] Rebooting in 10 seconds..
Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-r=
9-1107/71cc615a91a49d83e839c4b46f1f001ccd88e21f/vmlinuz-3.12.0-09952-g71cc6=
15 -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_timeout=3D100 log_buf=
_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_printk sys=
rq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200 con=
sole=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queu=
e/kvm/i386-randconfig-r9-1107/next:master/.vmlinuz-71cc615a91a49d83e839c4b4=
6f1f001ccd88e21f-20131107165425-3-roam branch=3Dnext/master BOOT_IMAGE=3D/k=
ernel/i386-randconfig-r9-1107/71cc615a91a49d83e839c4b46f1f001ccd88e21f/vmli=
nuz-3.12.0-09952-g71cc615'  -initrd /kernel-tests/initrd/quantal-core-i386.=
cgz -m 256M -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot=
 order=3Dnc -no-reboot -watchdog i6300esb -drive file=3D/fs/LABEL=3DKVM/dis=
k0-quantal-roam-7,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/di=
sk1-quantal-roam-7,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/d=
isk2-quantal-roam-7,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/=
disk3-quantal-roam-7,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM=
/disk4-quantal-roam-7,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKV=
M/disk5-quantal-roam-7,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid=
-quantal-roam-7 -serial file:/dev/shm/kboot/serial-quantal-roam-7 -daemoniz=
e -display none -monitor null=20

--Qxx1br4bt0+wmkIi
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-71cc615a91a49d83e839c4b46f1f001ccd88e21f-i386-randconfig-r9-1107-Oops:-111860.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDcxY2M2MTVhOTFhNDlkODNlODM5YzRiNDZmMWYwMDFjY2Q4OGUyMWYK
SEVBRCBpcyBub3cgYXQgNzFjYzYxNS4uLiBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNo
ICdhaW8vbWFzdGVyJwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1y
YW5kY29uZmlnLXI5LTExMDcvbmV4dDptYXN0ZXI6NzFjYzYxNWE5MWE0OWQ4M2U4MzljNGI0
NmYxZjAwMWNjZDg4ZTIxZjpiaXNlY3QtdXNiCiBURVNUIEZBSUxVUkUKWyAgICAxLjg5NTg2
MF0gVGhlIGZvcmNlIHBhcmFtZXRlciBoYXMgbm90IGJlZW4gc2V0IHRvIDEuIFRoZSBJcmlz
IHBvd2Vyb2ZmIGhhbmRsZXIgd2lsbCBub3QgYmUgaW5zdGFsbGVkLgpbICAgIDEuODk5MDI5
XSBhdWRpdDogaW5pdGlhbGl6aW5nIG5ldGxpbmsgc29ja2V0IChkaXNhYmxlZCkKWyAgICAx
LjkwMDI1OV0gdHlwZT0yMDAwIGF1ZGl0KDEzODM4MTQ0NzcuOTY4OjEpOiBpbml0aWFsaXpl
ZApbICAgIDEuOTI2MDg1XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9p
bnRlciBkZXJlZmVyZW5jZSBhdCAgIChudWxsKQpbICAgIDEuOTI3MzQ0XSBJUDogWzw0MTUy
MThmND5dIGluaXRfbW0rMHgwLzB4MjEwClsgICAgMS45MjgxMDFdICpwZGUgPSAwMDAwMDAw
MCAKWyAgICAxLjkyODU5NF0gT29wczogMDAwMiBbIzFdIFBSRUVNUFQgU01QIERFQlVHX1BB
R0VBTExPQwpbICAgIDEuOTI5NTQzXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAxLjkzMDA0
MV0gQ1BVOiAxIFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xMi4wLTA5
OTUyLWc3MWNjNjE1ICM5MTYKWyAgICAxLjkzMDA0MV0gdGFzazogNGQ0MWI0NDAgdGk6IDRk
NDI4MDAwIHRhc2sudGk6IDRkNDI4MDAwClsgICAgMS45MzAwNDFdIEVJUDogMDA2MDpbPDQx
NTIxOGY0Pl0gRUZMQUdTOiAwMDAxMDIwNiBDUFU6IDEKWyAgICAxLjkzMDA0MV0gRUlQIGlz
IGF0IGluaXRfbW0rMHgwLzB4MjEwClsgICAgMS45MzAwNDFdIEVBWDogMDAwMDAwMDAgRUJY
OiAwMDAwMDBhZSBFQ1g6IDAwMDAwMDAwIEVEWDogMDAwMDAwMDEKWyAgICAxLjkzMDA0MV0g
RVNJOiAwMDAwMDAwNiBFREk6IDAwMDAwMDA2IEVCUDogNDE1NTg0MTYgRVNQOiA0ZDQyOWY5
NApbICAgIDEuOTMwMDQxXSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6IDAwMDAg
U1M6IDAwNjgKWyAgICAxLjkzMDA0MV0gQ1IwOiA4MDA1MDAzYiBDUjI6IDAwMDAwMDAwIENS
MzogMDE1YjAwMDAgQ1I0OiAwMDAwMDZkMApbICAgIDEuOTMwMDQxXSBTdGFjazoKWyAgICAx
LjkzMDA0MV0gIDRkNDFiNDQwIDRlNGVkNDQwIDRkNDI5ZmFjIDQxMzM5NzQxIDQxNTIxOGY0
IDRkNDJiZjg4IDRkNDI4MDAwIDQxMzQ4MTc3ClsgICAgMS45MzAwNDFdICA0MTMzOTczNiAw
MDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAw
MDAwMDA3YgpbICAgIDEuOTMwMDQxXSAgMDAwMDAwN2IgMDAwMDAwZDggMDAwMDAwMDAgZmZm
ZmZmZmYgMDAwMDAwMDAgMDAwMDAwNjAgMDAwMDAyMDIgMDAwMDAwMDAKWyAgICAxLjkzMDA0
MV0gQ2FsbCBUcmFjZToKWyAgICAxLjkzMDA0MV0gIFs8NDEzMzk3NDE+XSA/IGtlcm5lbF9p
bml0KzB4Yi8weGMzClsgICAgMS45MzAwNDFdICBbPDQxMzQ4MTc3Pl0gPyByZXRfZnJvbV9r
ZXJuZWxfdGhyZWFkKzB4MWIvMHgyOApbICAgIDEuOTMwMDQxXSAgWzw0MTMzOTczNj5dID8g
cmVzdF9pbml0KzB4YjYvMHhiNgpbICAgIDEuOTMwMDQxXSBDb2RlOiAyYSA0OSA0MSAzOCA5
MSA0MCA0ZCBmOCBiNiA0YiA0ZCAwNiAwNiAwMCAwMCBhZCA0ZSBhZCBkZSBmZiBmZiBmZiBm
ZiBmZiBmZiBmZiBmZiBlNCAxOCA1MiA0MSA4OCA3ZiA3MCA0MSAwMCAwMCAwMCAwMCA2MSAy
YSA0OSA0MSA8MDA+IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDAwClsgICAgMS45MzAwNDFdIEVJUDogWzw0MTUyMThmND5dIGlu
aXRfbW0rMHgwLzB4MjEwIFNTOkVTUCAwMDY4OjRkNDI5Zjk0ClsgICAgMS45MzAwNDFdIENS
MjogMDAwMDAwMDAwMDAwMDAwMApbICAgIDEuOTMwMDQxXSAtLS1bIGVuZCB0cmFjZSA5NWQ5
YmIxZDkxMjk0NGI5IF0tLS0KWyAgICAxLjkzMDA0MV0gS2VybmVsIHBhbmljIC0gbm90IHN5
bmNpbmc6IEZhdGFsIGV4Y2VwdGlvbgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yOS0xMTA3
LzcxY2M2MTVhOTFhNDlkODNlODM5YzRiNDZmMWYwMDFjY2Q4OGUyMWYvZG1lc2ctcXVhbnRh
bC1yb2FtLTc6MjAxMzExMDcxNjU0NDI6aTM4Ni1yYW5kY29uZmlnLXI5LTExMDc6My4xMi4w
LTA5OTUyLWc3MWNjNjE1OjkxNgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yOS0xMTA3Lzcx
Y2M2MTVhOTFhNDlkODNlODM5YzRiNDZmMWYwMDFjY2Q4OGUyMWYvZG1lc2ctcXVhbnRhbC1s
a3Atc3QwMS0xMToyMDEzMTEwODA0MjU1MjppMzg2LXJhbmRjb25maWctcjktMTEwNzozLjEy
LjAtMDk5NTItZzcxY2M2MTU6OTE2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI5LTExMDcv
NzFjYzYxNWE5MWE0OWQ4M2U4MzljNGI0NmYxZjAwMWNjZDg4ZTIxZi9kbWVzZy1xdWFudGFs
LXhwcy0zOjIwMTMxMTA4MDQyODUzOmkzODYtcmFuZGNvbmZpZy1yOS0xMTA3OjMuMTIuMC0w
OTk1Mi1nNzFjYzYxNTo5MTYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjktMTEwNy83MWNj
NjE1YTkxYTQ5ZDgzZTgzOWM0YjQ2ZjFmMDAxY2NkODhlMjFmL2RtZXNnLXF1YW50YWwtd2Fp
bWVhLTE6MjAxMzExMDgwNDI2NDQ6aTM4Ni1yYW5kY29uZmlnLXI5LTExMDc6My4xMi4wLTA5
OTUyLWc3MWNjNjE1OjkxNgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yOS0xMTA3LzcxY2M2
MTVhOTFhNDlkODNlODM5YzRiNDZmMWYwMDFjY2Q4OGUyMWYvZG1lc2cteW9jdG8td2FpbWVh
LTEwOjIwMTMxMTA4MDQyNjM3OmkzODYtcmFuZGNvbmZpZy1yOS0xMTA3OjMuMTIuMC0wOTk1
Mi1nNzFjYzYxNTo5MTYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjktMTEwNy83MWNjNjE1
YTkxYTQ5ZDgzZTgzOWM0YjQ2ZjFmMDAxY2NkODhlMjFmL2RtZXNnLXF1YW50YWwtYXRoZW5z
LTI4OjIwMTMxMTA3MjAyOTAwOmkzODYtcmFuZGNvbmZpZy1yOS0xMTA3OjMuMTIuMC0wOTk1
Mi1nNzFjYzYxNTo5MTYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjktMTEwNy83MWNjNjE1
YTkxYTQ5ZDgzZTgzOWM0YjQ2ZjFmMDAxY2NkODhlMjFmL2RtZXNnLXF1YW50YWwtbGtwLXR0
MDItMjA6MjAxMzExMDcwNzQ0MzE6aTM4Ni1yYW5kY29uZmlnLXI5LTExMDc6My4xMi4wLTA5
OTUyLWc3MWNjNjE1OjkxNgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yOS0xMTA3LzcxY2M2
MTVhOTFhNDlkODNlODM5YzRiNDZmMWYwMDFjY2Q4OGUyMWYvZG1lc2cteW9jdG8td2FpbWVh
LTQ6MjAxMzExMDgwNDI2MzU6aTM4Ni1yYW5kY29uZmlnLXI5LTExMDc6My4xMi4wLTA5OTUy
LWc3MWNjNjE1OjkxNgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yOS0xMTA3LzcxY2M2MTVh
OTFhNDlkODNlODM5YzRiNDZmMWYwMDFjY2Q4OGUyMWYvZG1lc2cteW9jdG8tbGtwLXN0MDEt
OToyMDEzMTEwODA0MjUzMDppMzg2LXJhbmRjb25maWctcjktMTEwNzozLjEyLjAtMDk5NTIt
ZzcxY2M2MTU6OTE2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI5LTExMDcvNzFjYzYxNWE5
MWE0OWQ4M2U4MzljNGI0NmYxZjAwMWNjZDg4ZTIxZi9kbWVzZy15b2N0by13YWltZWEtMzoy
MDEzMTEwODA0MjY0MDppMzg2LXJhbmRjb25maWctcjktMTEwNzozLjEyLjAtMDk5NTItZzcx
Y2M2MTU6OTE2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI5LTExMDcvNzFjYzYxNWE5MWE0
OWQ4M2U4MzljNGI0NmYxZjAwMWNjZDg4ZTIxZi9kbWVzZy1xdWFudGFsLWF0aGVucy0xMDoy
MDEzMTEwNzE2NTQ0MTppMzg2LXJhbmRjb25maWctcjktMTEwNzozLjEyLjAtMDk5NTItZzcx
Y2M2MTU6OTE2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI5LTExMDcvNzFjYzYxNWE5MWE0
OWQ4M2U4MzljNGI0NmYxZjAwMWNjZDg4ZTIxZi9kbWVzZy15b2N0by1hdGhlbnMtMzk6MjAx
MzExMDcyMDI5MTE6aTM4Ni1yYW5kY29uZmlnLXI5LTExMDc6My4xMi4wLTA5OTUyLWc3MWNj
NjE1OjkxNgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yOS0xMTA3LzcxY2M2MTVhOTFhNDlk
ODNlODM5YzRiNDZmMWYwMDFjY2Q4OGUyMWYvZG1lc2cteW9jdG8td2FpbWVhLTg6MjAxMzEx
MDgwNDI2NTc6aTM4Ni1yYW5kY29uZmlnLXI5LTExMDc6My4xMi4wLTA5OTUyLWc3MWNjNjE1
OjkxNgowOjEzOjEzIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW1SRVBFQVQg
Q09VTlQ6IDIwICAjIC9jYy93ZmcvdXNiLWJpc2VjdC8ucmVwZWF0G1swbQoKYmlzZWN0OiBi
YWQgY29tbWl0IDcxY2M2MTVhOTFhNDlkODNlODM5YzRiNDZmMWYwMDFjY2Q4OGUyMWYKZ2l0
IGNoZWNrb3V0IHYzLjEyClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDcxY2M2MTUuLi4g
TWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnYWlvL21hc3RlcicKSEVBRCBpcyBub3cg
YXQgNWUwMWRjNy4uLiBMaW51eCAzLjEyCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWctcjktMTEwNy9uZXh0Om1hc3Rlcjo1ZTAxZGM3YjI2ZDlm
MjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyOmJpc2VjdC11c2IKIFNVQ0NFU1MKCmJpc2Vj
dDogZ29vZCBjb21taXQgdjMuMTIKZ2l0IGJpc2VjdCBzdGFydCA3MWNjNjE1YTkxYTQ5ZDgz
ZTgzOWM0YjQ2ZjFmMDAxY2NkODhlMjFmIHYzLjEyIC0tClByZXZpb3VzIEhFQUQgcG9zaXRp
b24gd2FzIDVlMDFkYzcuLi4gTGludXggMy4xMgpIRUFEIGlzIG5vdyBhdCA2ZTQ2NjQ1Li4u
IExpbnV4IDMuMTEKQmlzZWN0aW5nOiA0OTE1IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0
ZXIgdGhpcyAocm91Z2hseSAxMiBzdGVwcykKWzRiMmE3YTE3NDViYzNjYmEzMGZmY2EwM2Nl
MDM5M2JmNDI3NDY3N2JdIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ3dpcmVsZXNz
LW5leHQvbWFzdGVyJwpnaXQgYmlzZWN0IHJ1biAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApydW5uaW5nIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3Vz
Yi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJh
bmRjb25maWctcjktMTEwNy9uZXh0Om1hc3Rlcjo0YjJhN2ExNzQ1YmMzY2JhMzBmZmNhMDNj
ZTAzOTNiZjQyNzQ2NzdiOmJpc2VjdC11c2IKCjIwMTMtMTEtMDctMjA6MzA6NDEgNGIyYTdh
MTc0NWJjM2NiYTMwZmZjYTAzY2UwMzkzYmY0Mjc0Njc3YiBjb21waWxpbmcKNjU5IHJlYWwg
IDEzMjEgdXNlciAgMTQ1IHN5cyAgMjIyLjQyJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1yOS0x
MTA3CgoyMDEzLTExLTA3LTIwOjQyOjI4IGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC0w
NTAzNi1nNGIyYTdhMS4gVEVTVCBGQUlMVVJFClsgICAgMC43ODYxODddIFRoZSBmb3JjZSBw
YXJhbWV0ZXIgaGFzIG5vdCBiZWVuIHNldCB0byAxLiBUaGUgSXJpcyBwb3dlcm9mZiBoYW5k
bGVyIHdpbGwgbm90IGJlIGluc3RhbGxlZC4KWyAgICAwLjc4ODA5N10gYXVkaXQ6IGluaXRp
YWxpemluZyBuZXRsaW5rIHNvY2tldCAoZGlzYWJsZWQpClsgICAgMC43ODg5ODZdIHR5cGU9
MjAwMCBhdWRpdCgxMzgzODI4MTU2LjI0MToxKTogaW5pdGlhbGl6ZWQKWyAgICAwLjgxODU5
OV0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVu
Y2UgYXQgMDAwMDAwMDYKWyAgICAwLjgxOTc2MV0gSVA6IFs8NDEwMDBhNDM+XSBzdGFydF90
aHJlYWQrMHgxOC8weDQ3ClsgICAgMC44MjAwMjddICpwZGUgPSAwMDAwMDAwMCAKWyAgICAw
LjgyMDAyN10gT29wczogMDAwMiBbIzFdIFBSRUVNUFQgU01QIERFQlVHX1BBR0VBTExPQwpb
ICAgIDAuODIwMDI3XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAwLjgyMDAyN10gQ1BVOiAw
IFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xMi4wLTA1MDM2LWc0YjJh
N2ExICM3MjkKWyAgICAwLjgyMDAyN10gdGFzazogNGVjMWI0NDAgdGk6IDRlYzI4MDAwIHRh
c2sudGk6IDRlYzI4MDAwClsgICAgMC44MjAwMjddIEVJUDogMDA2MDpbPDQxMDAwYTQzPl0g
RUZMQUdTOiAwMDAxMDIwNiBDUFU6IDAKWyAgICAwLjgyMDAyN10gRUlQIGlzIGF0IHN0YXJ0
X3RocmVhZCsweDE4LzB4NDcKWyAgICAwLjgyMDAyN10gRUFYOiAwMDAwMDAwMCBFQlg6IDAw
MDAwMDA2IEVDWDogMDAwMDAwMDAgRURYOiAwMDAwMDAwMQpbICAgIDAuODIwMDI3XSBFU0k6
IDAwMDAwMGFmIEVESTogNDE1OTY4OTAgRUJQOiA0ZWMyOWY5YyBFU1A6IDRlYzI5ZjgwClsg
ICAgMC44MjAwMjddICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDAwMCBTUzog
MDA2OApbICAgIDAuODIwMDI3XSBDUjA6IDgwMDUwMDNiIENSMjogMDAwMDAwMDYgQ1IzOiAw
MTVhODAwMCBDUjQ6IDAwMDAwNmQwClsgICAgMC44MjAwMjddIFN0YWNrOgpbICAgIDAuODIw
MDI3XSAgMDAwMDAwYWYgMDAwMDAwMDYgMDAwMDAwMDYgNDE1NTA0MTYgMDAwMDAwMDAgNDE1
MTk3OTQgNGZjZDI0NDAgNGVjMjlmYWMKWyAgICAwLjgyMDAyN10gIDQxMzM3MDFkIDAwMDAw
MDAwIDRlYzJiZjg4IDRlYzI4MDAwIDQxMzQ1ZTU3IDQxMzM3MDEyIDAwMDAwMDAwIDAwMDAw
MDAwClsgICAgMC44MjAwMjddICAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAw
MCAwMDAwMDA3YiAwMDAwMDA3YiAwMDAwMDBkOCAwMDAwMDAwMApbICAgIDAuODIwMDI3XSBD
YWxsIFRyYWNlOgpbICAgIDAuODIwMDI3XSAgWzw0MTU1MDQxNj5dID8gZG9fZWFybHlfcGFy
YW0rMHg3OC8weDc4ClsgICAgMC44MjAwMjddICBbPDQxMzM3MDFkPl0ga2VybmVsX2luaXQr
MHhiLzB4YzMKWyAgICAwLjgyMDAyN10gIFs8NDEzNDVlNTc+XSByZXRfZnJvbV9rZXJuZWxf
dGhyZWFkKzB4MWIvMHgyOApbICAgIDAuODIwMDI3XSAgWzw0MTMzNzAxMj5dID8gcmVzdF9p
bml0KzB4YjYvMHhiNgpbICAgIDAuODIwMDI3XSBDb2RlOiBlNSAwZiAxOCAwMCA5MCA1ZCBj
MyA1NSAzMSBkMiA4OSBlNSAwZiBhZSAwOCA4OSBkMCA1ZCBjMyA1NSA4OSBlNSA1MyAzMSBk
YiA4ZSBlYiBjNyA0MCAyNCAwMCAwMCAwMCAwMCBjNyA0MCAxYyA3YiAwMCAwMCAwMCBjNyA0
MCA8MjA+IDdiIDAwIDAwIDAwIGM3IDQwIDQwIDdiIDAwIDAwIDAwIGM3IDQwIDM0IDczIDAw
IDAwIDAwIDg5IDUwClsgICAgMC44MjAwMjddIEVJUDogWzw0MTAwMGE0Mz5dIHN0YXJ0X3Ro
cmVhZCsweDE4LzB4NDcgU1M6RVNQIDAwNjg6NGVjMjlmODAKWyAgICAwLjgyMDAyN10gQ1Iy
OiAwMDAwMDAwMDAwMDAwMDA2ClsgICAgMC44NDM4NTBdIC0tLVsgZW5kIHRyYWNlIDlkN2M2
ZWZjOTFhODE4NzQgXS0tLQpbICAgIDAuODQ0NTUzXSBLZXJuZWwgcGFuaWMgLSBub3Qgc3lu
Y2luZzogRmF0YWwgZXhjZXB0aW9uCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI5LTExMDcv
NGIyYTdhMTc0NWJjM2NiYTMwZmZjYTAzY2UwMzkzYmY0Mjc0Njc3Yi9kbWVzZy15b2N0by1h
dGhlbnMtMzA6MjAxMzExMDcyMDQyNDI6aTM4Ni1yYW5kY29uZmlnLXI5LTExMDc6My4xMi4w
LTA1MDM2LWc0YjJhN2ExOjcyOQowOjE6MSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwob
WzE7MzVtUkVQRUFUIENPVU5UOiAyMCAgIyAvY2Mvd2ZnL3VzYi1iaXNlY3QvLnJlcGVhdBtb
MG0KCkJpc2VjdGluZzogMjU0NiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgMTEgc3RlcHMpClthODc5ZGRmNzYwM2JlMmM0ZmJhMGJiMTExYmNkZTIyNmE3
NWQ3ZjhlXSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdwY2kvbmV4dCcKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dm
Zy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4
Ni1yYW5kY29uZmlnLXI5LTExMDcvbmV4dDptYXN0ZXI6YTg3OWRkZjc2MDNiZTJjNGZiYTBi
YjExMWJjZGUyMjZhNzVkN2Y4ZTpiaXNlY3QtdXNiCgoyMDEzLTExLTA3LTIwOjQzOjAzIGE4
NzlkZGY3NjAzYmUyYzRmYmEwYmIxMTFiY2RlMjI2YTc1ZDdmOGUgY29tcGlsaW5nCjI5OCBy
ZWFsICAxMzM2IHVzZXIgIDE0MCBzeXMgIDQ5NC4xMSUgY3B1IAlpMzg2LXJhbmRjb25maWct
cjktMTEwNwoKMjAxMy0xMS0wNy0yMDo0OTowNiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEy
LjAtMDI0ODktZ2E4NzlkZGYuLgkxCTMJNC4uCTUJNgk4Lgk5LgkxMC4JMTIuLgkxMwkxNC4u
Li4JMTUuLi4uCTE3Li4uLi4uLi4JMTguCTE5Li4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAx
MTcyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMCBzdGVw
cykKWzg3YmMwNzI4ZDQ2MmFlMzc4NDFhNTUwNTQyODI5YWE2NWE5N2U3YzJdIE1lcmdlIGJy
YW5jaCAnbWFzdGVyJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tl
cm5lbC9naXQvbGludmlsbGUvd2lyZWxlc3MtbmV4dCBpbnRvIGZvci1kYXZlbQpydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2Zn
L3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWctcjktMTEwNy9uZXh0Om1hc3Rlcjo4N2JjMDcyOGQ0NjJhZTM3ODQxYTU1
MDU0MjgyOWFhNjVhOTdlN2MyOmJpc2VjdC11c2IKCjIwMTMtMTEtMDctMjE6MTE6MTAgODdi
YzA3MjhkNDYyYWUzNzg0MWE1NTA1NDI4MjlhYTY1YTk3ZTdjMiBjb21waWxpbmcKMjEzIHJl
YWwgIDEzNzcgdXNlciAgMTQ1IHN5cyAgNzEyLjQxJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1y
OS0xMTA3CgoyMDEzLTExLTA3LTIxOjE1OjEwIGRldGVjdGluZyBib290IHN0YXRlIDMuMTIu
MC1yYzYtMDE2NjMtZzg3YmMwNzIuCTEJNAk1CTEwCTEyCTE0CTE1CTE4LgkyMCBTVUNDRVNT
CgpCaXNlY3Rpbmc6IDczNyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgOSBzdGVwcykKW2E0MzA0OGZmNjZiNDU1ZWUyMzBkN2VjNWY5Nzk0N2ViNGUwMzFl
YmNdIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ2xpYmF0YS9mb3ItbmV4dCcKcnVu
bmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21l
L3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
aTM4Ni1yYW5kY29uZmlnLXI5LTExMDcvbmV4dDptYXN0ZXI6YTQzMDQ4ZmY2NmI0NTVlZTIz
MGQ3ZWM1Zjk3OTQ3ZWI0ZTAzMWViYzpiaXNlY3QtdXNiCgoyMDEzLTExLTA3LTIxOjIwOjQ1
IGE0MzA0OGZmNjZiNDU1ZWUyMzBkN2VjNWY5Nzk0N2ViNGUwMzFlYmMgY29tcGlsaW5nCjI3
MyByZWFsICAxMzkyIHVzZXIgIDE0MCBzeXMgIDU1OS45OSUgY3B1IAlpMzg2LXJhbmRjb25m
aWctcjktMTEwNwoKMjAxMy0xMS0wNy0yMToyNjozOCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAz
LjEyLjAtMDI5MjQtZ2E0MzA0OGYuIFRFU1QgRkFJTFVSRQpbICAgIDEuOTMwMDczXSBUaGUg
Zm9yY2UgcGFyYW1ldGVyIGhhcyBub3QgYmVlbiBzZXQgdG8gMS4gVGhlIElyaXMgcG93ZXJv
ZmYgaGFuZGxlciB3aWxsIG5vdCBiZSBpbnN0YWxsZWQuClsgICAgMS45MzI1NjFdIGF1ZGl0
OiBpbml0aWFsaXppbmcgbmV0bGluayBzb2NrZXQgKGRpc2FibGVkKQpbICAgIDEuOTMzNjc4
XSB0eXBlPTIwMDAgYXVkaXQoMTM4MzgzMDgwNC43MDg6MSk6IGluaXRpYWxpemVkClsgICAg
MS45NjAxMTNdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3Qg
YXQgMDAwMDhjYTUKWyAgICAxLjk2MTEzOV0gSVA6IFs8NDEwMGVhNDM+XSB4ODZfc2V0dXBf
cGVyZmN0cisweDg3LzB4MWNhClsgICAgMS45NjE5OTFdICpwZGUgPSAwMDAwMDAwMCAKWyAg
ICAxLjk2MjQyN10gT29wczogMDAwMiBbIzFdIFBSRUVNUFQgU01QIERFQlVHX1BBR0VBTExP
QwpbICAgIDEuOTYzMjgxXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAxLjk2MzczM10gQ1BV
OiAxIFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xMi4wLTAyOTI0LWdh
NDMwNDhmICM3MzIKWyAgICAxLjk2NDg1NF0gdGFzazogNGQ0MWI0NDAgdGk6IDRkNDI4MDAw
IHRhc2sudGk6IDRkNDI4MDAwClsgICAgMS45NjU2NTJdIEVJUDogMDA2MDpbPDQxMDBlYTQz
Pl0gRUZMQUdTOiAwMDAxMDIwNiBDUFU6IDEKWyAgICAxLjk2NjQ2Nl0gRUlQIGlzIGF0IHg4
Nl9zZXR1cF9wZXJmY3RyKzB4ODcvMHgxY2EKWyAgICAxLjk2NzEzN10gRUFYOiAwMDAwMDAw
MCBFQlg6IDAwMDAwMDA2IEVDWDogMDAwMDAwMDAgRURYOiAwMDAwMDAwMQpbICAgIDEuOTY4
MDk1XSBFU0k6IDAwMDAwMGFmIEVESTogNDE1OTQ4NzAgRUJQOiA0ZDQyOWY5YyBFU1A6IDRk
NDI5ZjgwClsgICAgMS45NjkwMzZdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzog
MDAwMCBTUzogMDA2OApbICAgIDEuOTY5ODc4XSBDUjA6IDgwMDUwMDNiIENSMjogMDAwMDhj
YTUgQ1IzOiAwMTVhNjAwMCBDUjQ6IDAwMDAwNmQwClsgICAgMS45NzAwMjJdIFN0YWNrOgpb
ICAgIDEuOTcwMDIyXSAgMDAwMDAwYWYgMDAwMDAwMDYgMDAwMDAwMDYgNDE1NGU0MTYgMDAw
MDAwMDAgNDE1MTc3ZDQgNGU0ZWQ0NDAgNGQ0MjlmYWMKWyAgICAxLjk3MDAyMl0gIDQxMzM2
MWM1IDAwMDAwMDAwIDRkNDJiZjg4IDRkNDI4MDAwIDQxMzQ1MGI3IDQxMzM2MWJhIDAwMDAw
MDAwIDAwMDAwMDAwClsgICAgMS45NzAwMjJdICAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAw
MCAwMDAwMDAwMCAwMDAwMDA3YiAwMDAwMDA3YiAwMDAwMDBkOCAwMDAwMDAwMApbICAgIDEu
OTcwMDIyXSBDYWxsIFRyYWNlOgpbICAgIDEuOTcwMDIyXSAgWzw0MTU0ZTQxNj5dID8gZG9f
ZWFybHlfcGFyYW0rMHg3OC8weDc4ClsgICAgMS45NzAwMjJdICBbPDQxMzM2MWM1Pl0ga2Vy
bmVsX2luaXQrMHhiLzB4YzMKWyAgICAxLjk3MDAyMl0gIFs8NDEzNDUwYjc+XSByZXRfZnJv
bV9rZXJuZWxfdGhyZWFkKzB4MWIvMHgyOApbICAgIDEuOTcwMDIyXSAgWzw0MTMzNjFiYT5d
ID8gcmVzdF9pbml0KzB4YjYvMHhiNgpbICAgIDEuOTcwMDIyXSBDb2RlOiA4NyA4MCAwMCAw
MCAwMCA4MyBmOCAwNCA3NSAxMyA4YiA4NyA4OCAwMCAwMCAwMCA4OSBmOSA4YiA5NyA4YyAw
MCAwMCAwMCBlOSBhYiAwMCAwMCAwMCA4MyBmOCAwMyAwZiA4NSBhYyAwMCAwMCAwMCA4YiA4
ZiA4OCAwMCAwMCA8MDA+IDhiIDlmIDhjIDAwIDAwIDAwIDBmIGI2IGYxIDgzIGZlIDA2IDBm
IDg3IGIzIDAwIDAwIDAwIDg5IGM4ClsgICAgMS45NzAwMjJdIEVJUDogWzw0MTAwZWE0Mz5d
IHg4Nl9zZXR1cF9wZXJmY3RyKzB4ODcvMHgxY2EgU1M6RVNQIDAwNjg6NGQ0MjlmODAKWyAg
ICAxLjk3MDAyMl0gQ1IyOiAwMDAwMDAwMDAwMDA4Y2E1ClsgICAgMS45ODQzNDNdIC0tLVsg
ZW5kIHRyYWNlIDhmMzcxNmVjNjRhNGVhYTEgXS0tLQpbICAgIDEuOTg1MDI4XSBLZXJuZWwg
cGFuaWMgLSBub3Qgc3luY2luZzogRmF0YWwgZXhjZXB0aW9uCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXI5LTExMDcvYTQzMDQ4ZmY2NmI0NTVlZTIzMGQ3ZWM1Zjk3OTQ3ZWI0ZTAzMWVi
Yy9kbWVzZy1xdWFudGFsLWF0aGVucy0xOjIwMTMxMTA3MjEyNjQ4OmkzODYtcmFuZGNvbmZp
Zy1yOS0xMTA3OjMuMTIuMC0wMjkyNC1nYTQzMDQ4Zjo3MzIKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctcjktMTEwNy9hNDMwNDhmZjY2YjQ1NWVlMjMwZDdlYzVmOTc5NDdlYjRlMDMxZWJj
L2RtZXNnLXF1YW50YWwtYXRoZW5zLTI3OjIwMTMxMTA3MjEyNjQ2OmkzODYtcmFuZGNvbmZp
Zy1yOS0xMTA3OjMuMTIuMC0wMjkyNC1nYTQzMDQ4Zjo3MzIKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctcjktMTEwNy9hNDMwNDhmZjY2YjQ1NWVlMjMwZDdlYzVmOTc5NDdlYjRlMDMxZWJj
L2RtZXNnLXlvY3RvLWxrcC10dDAyLTExOjIwMTMxMTA3MTIxNjQwOmkzODYtcmFuZGNvbmZp
Zy1yOS0xMTA3OjMuMTIuMC0wMjkyNC1nYTQzMDQ4Zjo3MzIKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctcjktMTEwNy9hNDMwNDhmZjY2YjQ1NWVlMjMwZDdlYzVmOTc5NDdlYjRlMDMxZWJj
L2RtZXNnLXlvY3RvLWxrcC10dDAyLTE4OjIwMTMxMTA3MTIxNjM5OmkzODYtcmFuZGNvbmZp
Zy1yOS0xMTA3OjMuMTIuMC0wMjkyNC1nYTQzMDQ4Zjo3MzIKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctcjktMTEwNy9hNDMwNDhmZjY2YjQ1NWVlMjMwZDdlYzVmOTc5NDdlYjRlMDMxZWJj
L2RtZXNnLXlvY3RvLWxrcC10dDAyLTE6MjAxMzExMDcxMjE2NDA6aTM4Ni1yYW5kY29uZmln
LXI5LTExMDc6My4xMi4wLTAyOTI0LWdhNDMwNDhmOjczMgova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1yOS0xMTA3L2E0MzA0OGZmNjZiNDU1ZWUyMzBkN2VjNWY5Nzk0N2ViNGUwMzFlYmMv
ZG1lc2cteW9jdG8tbGtwLXR0MDItMjE6MjAxMzExMDcxMjE2Mzg6aTM4Ni1yYW5kY29uZmln
LXI5LTExMDc6My4xMi4wLTAyOTI0LWdhNDMwNDhmOjczMgova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1yOS0xMTA3L2E0MzA0OGZmNjZiNDU1ZWUyMzBkN2VjNWY5Nzk0N2ViNGUwMzFlYmMv
ZG1lc2cteW9jdG8teGlhbi00NjoyMDEzMTEwNzIxMjY1OTppMzg2LXJhbmRjb25maWctcjkt
MTEwNzozLjEyLjAtMDI5MjQtZ2E0MzA0OGY6NzMyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXI5LTExMDcvYTQzMDQ4ZmY2NmI0NTVlZTIzMGQ3ZWM1Zjk3OTQ3ZWI0ZTAzMWViYy9kbWVz
Zy15b2N0by1sa3Atc3QwMS01OjIwMTMxMTA4MDUyMzM5OmkzODYtcmFuZGNvbmZpZy1yOS0x
MTA3OjMuMTIuMC0wMjkyNC1nYTQzMDQ4Zjo3MzIKMDo4OjggYWxsX2dvb2Q6YmFkOmFsbF9i
YWQgYm9vdHMKG1sxOzM1bVJFUEVBVCBDT1VOVDogMjAgICMgL2NjL3dmZy91c2ItYmlzZWN0
Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDI1MCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgOCBzdGVwcykKWzVjNTJhMGYyNTlhZjAyYzcxNmFkMDY0ZDc1
MmNiNmVmYjFkMjllYzBdIE1lcmdlIGJyYW5jaCAnYnVpbGRfZml4ZXMnIGludG8gdG9fbmV4
dApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWctcjktMTEwNy9uZXh0Om1hc3Rlcjo1YzUyYTBmMjU5YWYw
MmM3MTZhZDA2NGQ3NTJjYjZlZmIxZDI5ZWMwOmJpc2VjdC11c2IKCjIwMTMtMTEtMDctMjE6
Mjc6MTQgNWM1MmEwZjI1OWFmMDJjNzE2YWQwNjRkNzUyY2I2ZWZiMWQyOWVjMCBjb21waWxp
bmcKNTEzIHJlYWwgIDEzODQgdXNlciAgMTQxIHN5cyAgMjk3LjA1JSBjcHUgCWkzODYtcmFu
ZGNvbmZpZy1yOS0xMTA3CgoyMDEzLTExLTA3LTIxOjM2OjExIGRldGVjdGluZyBib290IHN0
YXRlIDMuMTIuMC1yYzItMDAyMDMtZzVjNTJhMGYJMi4JNAk2CTEwCTE1CTE4CTIwIFNVQ0NF
U1MKCkJpc2VjdGluZzogMTI1IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAo
cm91Z2hseSA3IHN0ZXBzKQpbNzY2MWMzZjA5OWMwYWZkYTczMDVhZjkxMmMwM2ViZDFjNzYx
NzM1YV0gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnaTJjL2kyYy9mb3ItbmV4dCcK
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9o
b21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0vaTM4Ni1yYW5kY29uZmlnLXI5LTExMDcvbmV4dDptYXN0ZXI6NzY2MWMzZjA5OWMwYWZk
YTczMDVhZjkxMmMwM2ViZDFjNzYxNzM1YTpiaXNlY3QtdXNiCgoyMDEzLTExLTA3LTIxOjQw
OjE3IDc2NjFjM2YwOTljMGFmZGE3MzA1YWY5MTJjMDNlYmQxYzc2MTczNWEgY29tcGlsaW5n
CjI5MCByZWFsICAxMzg4IHVzZXIgIDE0MCBzeXMgIDUyNi43MyUgY3B1IAlpMzg2LXJhbmRj
b25maWctcjktMTEwNwoKMjAxMy0xMS0wNy0yMTo0NzowMSBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAzLjEyLjAtMDI2MTQtZzc2NjFjM2YJMgk2CTEyCTE3CTE4CTIwIFNVQ0NFU1MKCkJpc2Vj
dGluZzogNjcgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDYg
c3RlcHMpCls4MWE2N2MzMmRmNGRhMWRiZjFjZjM3MTU2MTBlYTgyMDA2OGE1OTM1XSBNZXJn
ZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICd2NGwtZHZiL21hc3RlcicKcnVubmluZyAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Iv
b2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5k
Y29uZmlnLXI5LTExMDcvbmV4dDptYXN0ZXI6ODFhNjdjMzJkZjRkYTFkYmYxY2YzNzE1NjEw
ZWE4MjAwNjhhNTkzNTpiaXNlY3QtdXNiCgoyMDEzLTExLTA3LTIxOjUwOjA0IDgxYTY3YzMy
ZGY0ZGExZGJmMWNmMzcxNTYxMGVhODIwMDY4YTU5MzUgY29tcGlsaW5nCjE0MyByZWFsICAx
ODkgdXNlciAgMzUgc3lzICAxNTYuMjAlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXI5LTExMDcK
CjIwMTMtMTEtMDctMjE6NTM6MjMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLTAyODU2
LWc4MWE2N2MzMi4JMgk4CTE1CTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMjkgcmV2aXNpb25z
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDUgc3RlcHMpCls5ZmJlOGU1Yjk3
MjRlMDAzNDYxOGJkNTEyZGY5ZWRhNDY5NGU3N2Q1XSBNZXJnZSBicmFuY2ggJ2tidWlsZC9r
Y29uZmlnJyBpbnRvIGtidWlsZC9mb3ItbmV4dApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0Cmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctcjktMTEw
Ny9uZXh0Om1hc3Rlcjo5ZmJlOGU1Yjk3MjRlMDAzNDYxOGJkNTEyZGY5ZWRhNDY5NGU3N2Q1
OmJpc2VjdC11c2IKCjIwMTMtMTEtMDctMjE6NTU6NTYgOWZiZThlNWI5NzI0ZTAwMzQ2MThi
ZDUxMmRmOWVkYTQ2OTRlNzdkNSBjb21waWxpbmcKNDAwIHJlYWwgIDEzNjIgdXNlciAgMTQz
IHN5cyAgMzc2LjYxJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1yOS0xMTA3CgoyMDEzLTExLTA3
LTIyOjAzOjExIGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1yYzEtMDAwMzktZzlmYmU4
ZTUJMQk0CTcJOS4JMTMJMTQJMTUJMTYJMTcJMTgJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAx
NCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNCBzdGVwcykK
WzE4YTU1ODA2N2Q1MDFhMmNjZGEwNjFmOTk4MDBmM2E5NzgzNzlkYzZdIE1lcmdlIGJyYW5j
aCAnZm9yLTMuMTMnIGludG8gZm9yLW5leHQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlz
ZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAt
YSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXI5LTExMDcv
bmV4dDptYXN0ZXI6MThhNTU4MDY3ZDUwMWEyY2NkYTA2MWY5OTgwMGYzYTk3ODM3OWRjNjpi
aXNlY3QtdXNiCgoyMDEzLTExLTA3LTIyOjA5OjE0IDE4YTU1ODA2N2Q1MDFhMmNjZGEwNjFm
OTk4MDBmM2E5NzgzNzlkYzYgY29tcGlsaW5nCjQ2OCByZWFsICAxMzgwIHVzZXIgIDE0OSBz
eXMgIDMyNi42OSUgY3B1IAlpMzg2LXJhbmRjb25maWctcjktMTEwNwoKMjAxMy0xMS0wNy0y
MjoxNzo1MiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmMxLTAwMDIwLWcxOGE1NTgw
Li4JMQk0CTExCTE5LgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDcgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3RlcHMpClsxY2E5NTNkNWY5OTJmZjVm
ZTYzYTIyNTQ2YTIxYjkxNTIzOGQyNDU1XSBNZXJnZSBicmFuY2ggJ2Zvci0zLjEzJyBpbnRv
IGZvci1uZXh0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yOS0xMTA3L25leHQ6bWFzdGVyOjFjYTk1
M2Q1Zjk5MmZmNWZlNjNhMjI1NDZhMjFiOTE1MjM4ZDI0NTU6YmlzZWN0LXVzYgoKMjAxMy0x
MS0wNy0yMjoyMTo1MyAxY2E5NTNkNWY5OTJmZjVmZTYzYTIyNTQ2YTIxYjkxNTIzOGQyNDU1
IGNvbXBpbGluZwoxMjQgcmVhbCAgMTU5IHVzZXIgIDM0IHN5cyAgMTU2LjA2JSBjcHUgCWkz
ODYtcmFuZGNvbmZpZy1yOS0xMTA3CgoyMDEzLTExLTA3LTIyOjI1OjQwIGRldGVjdGluZyBi
b290IHN0YXRlIDMuMTIuMC1yYzEtMDAwMjctZzFjYTk1M2QJMTAJMTMuCTIwIFNVQ0NFU1MK
CkJpc2VjdGluZzogMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdo
bHkgMiBzdGVwcykKWzg0OTQ2NGQxYmE5N2ExM2IzODhmZWU5YTY5ZmJiZWVlMTc1YjM0OWNd
IGtidWlsZDogcmVwbGFjZSB1bmJvdW5kZWQgc3ByaW50ZiBjYWxsIGluIG1vZHBvc3QKcnVu
bmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21l
L3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
aTM4Ni1yYW5kY29uZmlnLXI5LTExMDcvbmV4dDptYXN0ZXI6ODQ5NDY0ZDFiYTk3YTEzYjM4
OGZlZTlhNjlmYmJlZWUxNzViMzQ5YzpiaXNlY3QtdXNiCgoyMDEzLTExLTA3LTIyOjI3OjQy
IDg0OTQ2NGQxYmE5N2ExM2IzODhmZWU5YTY5ZmJiZWVlMTc1YjM0OWMgY29tcGlsaW5nCjI2
OCByZWFsICAxMzg2IHVzZXIgIDE0MSBzeXMgIDU2OS42NiUgY3B1IAlpMzg2LXJhbmRjb25m
aWctcjktMTEwNwoKMjAxMy0xMS0wNy0yMjozNDowNiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAz
LjEyLjAtcmMxLTAwMDA1LWc4NDk0NjRkLiBURVNUIEZBSUxVUkUKWyAgICA3Ljg3Mjk0Ml0g
VGhlIGZvcmNlIHBhcmFtZXRlciBoYXMgbm90IGJlZW4gc2V0IHRvIDEuIFRoZSBJcmlzIHBv
d2Vyb2ZmIGhhbmRsZXIgd2lsbCBub3QgYmUgaW5zdGFsbGVkLgpbICAgIDcuODc2MzEwXSBh
dWRpdDogaW5pdGlhbGl6aW5nIG5ldGxpbmsgc29ja2V0IChkaXNhYmxlZCkKWyAgICA3Ljg3
Nzc0NF0gdHlwZT0yMDAwIGF1ZGl0KDEzODM4MDE4NTcuNTg1OjEpOiBpbml0aWFsaXplZApb
ICAgIDcuOTEwMDM0XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRl
ciBkZXJlZmVyZW5jZSBhdCAwMDAwMDA2MgpbICAgIDcuOTExNTYyXSBJUDogWzw0MTAwYzlm
Yj5dIGludGVsX2RldGVjdF90bGIrMHhhYy8weDJkNgpbICAgIDcuOTEyNjUwXSAqcGRlID0g
MDAwMDAwMDAgClsgICAgNy45MTMyNDhdIE9vcHM6IDAwMDAgWyMxXSBQUkVFTVBUIFNNUCBE
RUJVR19QQUdFQUxMT0MKWyAgICA3LjkxNDQwMF0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAg
Ny45MTUwNjhdIENQVTogMSBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMu
MTIuMC1yYzEtMDAwMDUtZzg0OTQ2NGQgIzczOQpbICAgIDcuOTE2NjMxXSB0YXNrOiA0ZDQx
YjQ0MCB0aTogNGQ0MjgwMDAgdGFzay50aTogNGQ0MjgwMDAKWyAgICA3LjkxNzcwNV0gRUlQ
OiAwMDYwOls8NDEwMGM5ZmI+XSBFRkxBR1M6IDAwMDEwMjk3IENQVTogMQpbICAgIDcuOTE4
NzkxXSBFSVAgaXMgYXQgaW50ZWxfZGV0ZWN0X3RsYisweGFjLzB4MmQ2ClsgICAgNy45MTk3
MzFdIEVBWDogMDAwMDAwNjEgRUJYOiAwMDAwMGRkMCBFQ1g6IDAwMDAwMjAwIEVEWDogMDAw
MDAyMDAKWyAgICA3LjkyMDAxMF0gRVNJOiAwMDAwMDAxYSBFREk6IDQxNTkyODcwIEVCUDog
NGQ0MjlmOWMgRVNQOiA0ZDQyOWY4MApbICAgIDcuOTIwMDEwXSAgRFM6IDAwN2IgRVM6IDAw
N2IgRlM6IDAwZDggR1M6IDAwMDAgU1M6IDAwNjgKWyAgICA3LjkyMDAxMF0gQ1IwOiA4MDA1
MDAzYiBDUjI6IDAwMDAwMDYyIENSMzogMDE1YTQwMDAgQ1I0OiAwMDAwMDZkMApbICAgIDcu
OTIwMDEwXSBTdGFjazoKWyAgICA3LjkyMDAxMF0gIDAwMDAwMGFmIDAwMDAwMDA2IDAwMDAw
MDA2IDQxNTRjNDE2IDAwMDAwMDAwIDQxNTE1Nzk0IDRlNGVkNDQwIDRkNDI5ZmFjClsgICAg
Ny45MjAwMTBdICA0MTMzNTNmZCAwMDAwMDAwMCA0ZDQyYmY4OCA0ZDQyODAwMCA0MTM0NDI5
NyA0MTMzNTNmMiAwMDAwMDAwMCAwMDAwMDAwMApbICAgIDcuOTIwMDEwXSAgMDAwMDAwMDAg
MDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwN2IgMDAwMDAwN2IgMDAwMDAwZDgg
MDAwMDAwMDAKWyAgICA3LjkyMDAxMF0gQ2FsbCBUcmFjZToKWyAgICA3LjkyMDAxMF0gIFs8
NDE1NGM0MTY+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4NzgvMHg3OApbICAgIDcuOTIwMDEwXSAg
Wzw0MTMzNTNmZD5dIGtlcm5lbF9pbml0KzB4Yi8weGMzClsgICAgNy45MjAwMTBdICBbPDQx
MzQ0Mjk3Pl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDFiLzB4MjgKWyAgICA3LjkyMDAx
MF0gIFs8NDEzMzUzZjI+XSA/IHJlc3RfaW5pdCsweGI2LzB4YjYKWyAgICA3LjkyMDAxMF0g
Q29kZTogNjAgNTQgNDEgNjYgOGIgM2QgMTIgNjAgNTQgNDEgNjYgODkgNDUgZTAgNjYgYTEg
MTggNjAgNTQgNDEgNjYgODkgNDUgZTIgNjYgYTEgMTQgNjAgNTQgNDEgNjYgODkgNDUgZGEg
OGQgNDUgZTQgODkgNDUgZGMgOGIgNDUgZGMgPDhhPiA1OCAwMSA4NCBkYiAwZiA4NCA1NCAw
MSAwMCAwMCBjNiA0NSBkOSAwMCAwZiBiNiA3NSBkOSA2OSBjNgpbICAgIDcuOTIwMDEwXSBF
SVA6IFs8NDEwMGM5ZmI+XSBpbnRlbF9kZXRlY3RfdGxiKzB4YWMvMHgyZDYgU1M6RVNQIDAw
Njg6NGQ0MjlmODAKWyAgICA3LjkyMDAxMF0gQ1IyOiAwMDAwMDAwMDAwMDAwMDYyClsgICAg
Ny45NTU1NTddIC0tLVsgZW5kIHRyYWNlIDkzY2ZkZTE4ODZkN2MyOGQgXS0tLQpbICAgIDcu
OTU2NDYzXSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogRmF0YWwgZXhjZXB0aW9uCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI5LTExMDcvODQ5NDY0ZDFiYTk3YTEzYjM4OGZlZTlh
NjlmYmJlZWUxNzViMzQ5Yy9kbWVzZy15b2N0by1pbm4tMTM6MjAxMzExMDcyMjM0MTc6aTM4
Ni1yYW5kY29uZmlnLXI5LTExMDc6My4xMi4wLXJjMS0wMDAwNS1nODQ5NDY0ZDo3MzkKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctcjktMTEwNy84NDk0NjRkMWJhOTdhMTNiMzg4ZmVlOWE2
OWZiYmVlZTE3NWIzNDljL2RtZXNnLXlvY3RvLWxrcC10dDAyLTY6MjAxMzExMDcxMzI0MDY6
aTM4Ni1yYW5kY29uZmlnLXI5LTExMDc6My4xMi4wLXJjMS0wMDAwNS1nODQ5NDY0ZDo3MzkK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjktMTEwNy84NDk0NjRkMWJhOTdhMTNiMzg4ZmVl
OWE2OWZiYmVlZTE3NWIzNDljL2RtZXNnLXlvY3RvLXNuYi0xOjIwMTMxMTA3MjIzNDE4Omkz
ODYtcmFuZGNvbmZpZy1yOS0xMTA3OjMuMTIuMC1yYzEtMDAwMDUtZzg0OTQ2NGQ6NzM5Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI5LTExMDcvODQ5NDY0ZDFiYTk3YTEzYjM4OGZlZTlh
NjlmYmJlZWUxNzViMzQ5Yy9kbWVzZy15b2N0by1zbmItMjoyMDEzMTEwNzIyMzQxOTppMzg2
LXJhbmRjb25maWctcjktMTEwNzozLjEyLjAtcmMxLTAwMDA1LWc4NDk0NjRkOjczOQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1yOS0xMTA3Lzg0OTQ2NGQxYmE5N2ExM2IzODhmZWU5YTY5
ZmJiZWVlMTc1YjM0OWMvZG1lc2ctcXVhbnRhbC1zbmItMzk6MjAxMzExMDcyMjM0Mjc6aTM4
Ni1yYW5kY29uZmlnLXI5LTExMDc6My4xMi4wLXJjMS0wMDAwNS1nODQ5NDY0ZDo3MzkKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctcjktMTEwNy84NDk0NjRkMWJhOTdhMTNiMzg4ZmVlOWE2
OWZiYmVlZTE3NWIzNDljL2RtZXNnLXF1YW50YWwteHBzLTI6MjAxMzExMDgwNjMzNTM6aTM4
Ni1yYW5kY29uZmlnLXI5LTExMDc6My4xMi4wLXJjMS0wMDAwNS1nODQ5NDY0ZDo3MzkKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctcjktMTEwNy84NDk0NjRkMWJhOTdhMTNiMzg4ZmVlOWE2
OWZiYmVlZTE3NWIzNDljL2RtZXNnLXF1YW50YWwteHBzLTQ6MjAxMzExMDgwNjMzNTI6aTM4
Ni1yYW5kY29uZmlnLXI5LTExMDc6My4xMi4wLXJjMS0wMDAwNS1nODQ5NDY0ZDo3MzkKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctcjktMTEwNy84NDk0NjRkMWJhOTdhMTNiMzg4ZmVlOWE2
OWZiYmVlZTE3NWIzNDljL2RtZXNnLXlvY3RvLWFudC0xMDoyMDEzMTEwODA2MTM1NzppMzg2
LXJhbmRjb25maWctcjktMTEwNzozLjEyLjAtcmMxLTAwMDA1LWc4NDk0NjRkOjczOQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1yOS0xMTA3Lzg0OTQ2NGQxYmE5N2ExM2IzODhmZWU5YTY5
ZmJiZWVlMTc1YjM0OWMvZG1lc2cteW9jdG8tamFrZXRvd24tNDA6MjAxMzExMDcyMjM0MjE6
aTM4Ni1yYW5kY29uZmlnLXI5LTExMDc6My4xMi4wLXJjMS0wMDAwNS1nODQ5NDY0ZDo3MzkK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjktMTEwNy84NDk0NjRkMWJhOTdhMTNiMzg4ZmVl
OWE2OWZiYmVlZTE3NWIzNDljL2RtZXNnLXlvY3RvLWxrcC10dDAyLTEwOjIwMTMxMTA3MTMy
NDE4OmkzODYtcmFuZGNvbmZpZy1yOS0xMTA3OjMuMTIuMC1yYzEtMDAwMDUtZzg0OTQ2NGQ6
NzM5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI5LTExMDcvODQ5NDY0ZDFiYTk3YTEzYjM4
OGZlZTlhNjlmYmJlZWUxNzViMzQ5Yy9kbWVzZy15b2N0by1sa3AtdHQwMi0xNDoyMDEzMTEw
NzEzMjQxMjppMzg2LXJhbmRjb25maWctcjktMTEwNzozLjEyLjAtcmMxLTAwMDA1LWc4NDk0
NjRkOjczOQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yOS0xMTA3Lzg0OTQ2NGQxYmE5N2Ex
M2IzODhmZWU5YTY5ZmJiZWVlMTc1YjM0OWMvZG1lc2cteW9jdG8tbGtwLXR0MDItMjQ6MjAx
MzExMDcxMzI0MTc6aTM4Ni1yYW5kY29uZmlnLXI5LTExMDc6My4xMi4wLXJjMS0wMDAwNS1n
ODQ5NDY0ZDo3MzkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjktMTEwNy84NDk0NjRkMWJh
OTdhMTNiMzg4ZmVlOWE2OWZiYmVlZTE3NWIzNDljL2RtZXNnLXlvY3RvLXNuYi0xOjIwMTMx
MTA3MjIzNDI5OmkzODYtcmFuZGNvbmZpZy1yOS0xMTA3OjMuMTIuMC1yYzEtMDAwMDUtZzg0
OTQ2NGQ6NzM5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI5LTExMDcvODQ5NDY0ZDFiYTk3
YTEzYjM4OGZlZTlhNjlmYmJlZWUxNzViMzQ5Yy9kbWVzZy15b2N0by1zbmItNDA6MjAxMzEx
MDcyMjM0Mjk6aTM4Ni1yYW5kY29uZmlnLXI5LTExMDc6My4xMi4wLXJjMS0wMDAwNS1nODQ5
NDY0ZDo3MzkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjktMTEwNy84NDk0NjRkMWJhOTdh
MTNiMzg4ZmVlOWE2OWZiYmVlZTE3NWIzNDljL2RtZXNnLXlvY3RvLXNuYi00OjIwMTMxMTA3
MjIzNDI2OmkzODYtcmFuZGNvbmZpZy1yOS0xMTA3OjMuMTIuMC1yYzEtMDAwMDUtZzg0OTQ2
NGQ6NzM5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI5LTExMDcvODQ5NDY0ZDFiYTk3YTEz
YjM4OGZlZTlhNjlmYmJlZWUxNzViMzQ5Yy9kbWVzZy15b2N0by1zdG9ha2xleS01OjIwMTMx
MTA3MjIzNDI2OmkzODYtcmFuZGNvbmZpZy1yOS0xMTA3OjMuMTIuMC1yYzEtMDAwMDUtZzg0
OTQ2NGQ6NzM5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI5LTExMDcvODQ5NDY0ZDFiYTk3
YTEzYjM4OGZlZTlhNjlmYmJlZWUxNzViMzQ5Yy9kbWVzZy1xdWFudGFsLWxrcC10dDAyLTc6
MjAxMzExMDcxMzI0MjI6aTM4Ni1yYW5kY29uZmlnLXI5LTExMDc6My4xMi4wLXJjMS0wMDAw
NS1nODQ5NDY0ZDo3MzkKMDoxNzoxNyBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7
MzVtUkVQRUFUIENPVU5UOiAyMCAgIyAvY2Mvd2ZnL3VzYi1iaXNlY3QvLnJlcGVhdBtbMG0K
CkJpc2VjdGluZzogMSByZXZpc2lvbiBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hs
eSAxIHN0ZXApCltmMzQ2MmFhOTUyY2ZjOGY0YjA5NTEwM2NiOWIzZDMwNmRkMjE2NTU4XSBL
YnVpbGQ6IEhhbmRsZSBsb25nZXIgc3ltYm9scyBpbiBrYWxsc3ltcy5jCnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNi
L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFu
ZGNvbmZpZy1yOS0xMTA3L25leHQ6bWFzdGVyOmYzNDYyYWE5NTJjZmM4ZjRiMDk1MTAzY2I5
YjNkMzA2ZGQyMTY1NTg6YmlzZWN0LXVzYgoKMjAxMy0xMS0wNy0yMjozNDozNyBmMzQ2MmFh
OTUyY2ZjOGY0YjA5NTEwM2NiOWIzZDMwNmRkMjE2NTU4IGNvbXBpbGluZwo2NiByZWFsICAx
NTkgdXNlciAgMzYgc3lzICAyOTYuMDYlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXI5LTExMDcK
CjIwMTMtMTEtMDctMjI6MzY6MDQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLXJjMS0w
MDAwMy1nZjM0NjJhYS4gVEVTVCBGQUlMVVJFClsgICAgMC44MTI5OTZdIFRoZSBmb3JjZSBw
YXJhbWV0ZXIgaGFzIG5vdCBiZWVuIHNldCB0byAxLiBUaGUgSXJpcyBwb3dlcm9mZiBoYW5k
bGVyIHdpbGwgbm90IGJlIGluc3RhbGxlZC4KWyAgICAwLjgxNTA2Ml0gYXVkaXQ6IGluaXRp
YWxpemluZyBuZXRsaW5rIHNvY2tldCAoZGlzYWJsZWQpClsgICAgMC44MTYxMDJdIHR5cGU9
MjAwMCBhdWRpdCgxMzgzODM0OTcyLjQ3OToxKTogaW5pdGlhbGl6ZWQKWyAgICAwLjg1MDA1
OV0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVu
Y2UgYXQgMDAwMDAwNjIKWyAgICAwLjg1MTM2MV0gSVA6IFs8NDEwMGM5ZmI+XSBpbnRlbF9k
ZXRlY3RfdGxiKzB4YWMvMHgyZDYKWyAgICAwLjg1MjQxM10gKnBkZSA9IDAwMDAwMDAwIApb
ICAgIDAuODUyOTU1XSBPb3BzOiAwMDAwIFsjMV0gUFJFRU1QVCBTTVAgREVCVUdfUEFHRUFM
TE9DClsgICAgMC44NTM5NzRdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDAuODU0NTU0XSBD
UFU6IDEgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjEyLjAtcmMxLTAw
MDAzLWdmMzQ2MmFhICM3NDAKWyAgICAwLjg1NTkxMl0gdGFzazogNGVjMWI0NDAgdGk6IDRl
YzI4MDAwIHRhc2sudGk6IDRlYzI4MDAwClsgICAgMC44NTY4OTddIEVJUDogMDA2MDpbPDQx
MDBjOWZiPl0gRUZMQUdTOiAwMDAxMDI5NyBDUFU6IDEKWyAgICAwLjg1Nzg5MF0gRUlQIGlz
IGF0IGludGVsX2RldGVjdF90bGIrMHhhYy8weDJkNgpbICAgIDAuODU4NzE1XSBFQVg6IDAw
MDAwMDYxIEVCWDogMDAwMDBkZDAgRUNYOiAwMDAwMDIwMCBFRFg6IDAwMDAwMjAwClsgICAg
MC44NTk4MTRdIEVTSTogMDAwMDAwMWEgRURJOiA0MTU5Mjg3MCBFQlA6IDRlYzI5ZjljIEVT
UDogNGVjMjlmODAKWyAgICAwLjg2MDAzMF0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMGQ4
IEdTOiAwMDAwIFNTOiAwMDY4ClsgICAgMC44NjAwMzBdIENSMDogODAwNTAwM2IgQ1IyOiAw
MDAwMDA2MiBDUjM6IDAxNWE0MDAwIENSNDogMDAwMDA2ZDAKWyAgICAwLjg2MDAzMF0gU3Rh
Y2s6ClsgICAgMC44NjAwMzBdICAwMDAwMDBhZiAwMDAwMDAwNiAwMDAwMDAwNiA0MTU0YzQx
NiAwMDAwMDAwMCA0MTUxNTc5NCA0ZmNkMjQ0MCA0ZWMyOWZhYwpbICAgIDAuODYwMDMwXSAg
NDEzMzUzZmQgMDAwMDAwMDAgNGVjMmJmODggNGVjMjgwMDAgNDEzNDQyOTcgNDEzMzUzZjIg
MDAwMDAwMDAgMDAwMDAwMDAKWyAgICAwLjg2MDAzMF0gIDAwMDAwMDAwIDAwMDAwMDAwIDAw
MDAwMDAwIDAwMDAwMDAwIDAwMDAwMDdiIDAwMDAwMDdiIDAwMDAwMGQ4IDAwMDAwMDAwClsg
ICAgMC44NjAwMzBdIENhbGwgVHJhY2U6ClsgICAgMC44NjAwMzBdICBbPDQxNTRjNDE2Pl0g
PyBkb19lYXJseV9wYXJhbSsweDc4LzB4NzgKWyAgICAwLjg2MDAzMF0gIFs8NDEzMzUzZmQ+
XSBrZXJuZWxfaW5pdCsweGIvMHhjMwpbICAgIDAuODYwMDMwXSAgWzw0MTM0NDI5Nz5dIHJl
dF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDI4ClsgICAgMC44NjAwMzBdICBbPDQxMzM1
M2YyPl0gPyByZXN0X2luaXQrMHhiNi8weGI2ClsgICAgMC44NjAwMzBdIENvZGU6IDYwIDU0
IDQxIDY2IDhiIDNkIDEyIDYwIDU0IDQxIDY2IDg5IDQ1IGUwIDY2IGExIDE4IDYwIDU0IDQx
IDY2IDg5IDQ1IGUyIDY2IGExIDE0IDYwIDU0IDQxIDY2IDg5IDQ1IGRhIDhkIDQ1IGU0IDg5
IDQ1IGRjIDhiIDQ1IGRjIDw4YT4gNTggMDEgODQgZGIgMGYgODQgNTQgMDEgMDAgMDAgYzYg
NDUgZDkgMDAgMGYgYjYgNzUgZDkgNjkgYzYKWyAgICAwLjg2MDAzMF0gRUlQOiBbPDQxMDBj
OWZiPl0gaW50ZWxfZGV0ZWN0X3RsYisweGFjLzB4MmQ2IFNTOkVTUCAwMDY4OjRlYzI5Zjgw
ClsgICAgMC44NjAwMzBdIENSMjogMDAwMDAwMDAwMDAwMDA2MgpbICAgIDAuODc5MDk4XSAt
LS1bIGVuZCB0cmFjZSA4NTEzZDE5ZjM3ZDIwMzNhIF0tLS0KWyAgICAwLjg3OTkzOF0gS2Vy
bmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEZhdGFsIGV4Y2VwdGlvbgova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1yOS0xMTA3L2YzNDYyYWE5NTJjZmM4ZjRiMDk1MTAzY2I5YjNkMzA2ZGQy
MTY1NTgvZG1lc2cteW9jdG8tc25iLTQ3OjIwMTMxMTA3MjIzNjEyOmkzODYtcmFuZGNvbmZp
Zy1yOS0xMTA3OjMuMTIuMC1yYzEtMDAwMDMtZ2YzNDYyYWE6NzQwCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLXI5LTExMDcvZjM0NjJhYTk1MmNmYzhmNGIwOTUxMDNjYjliM2QzMDZkZDIx
NjU1OC9kbWVzZy15b2N0by1zbmItMjI6MjAxMzExMDcyMjM2MTg6aTM4Ni1yYW5kY29uZmln
LXI5LTExMDc6My4xMi4wLXJjMS0wMDAwMy1nZjM0NjJhYTo3NDAKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctcjktMTEwNy9mMzQ2MmFhOTUyY2ZjOGY0YjA5NTEwM2NiOWIzZDMwNmRkMjE2
NTU4L2RtZXNnLXlvY3RvLXhpYW4tNDc6MjAxMzExMDcyMjM2MTU6aTM4Ni1yYW5kY29uZmln
LXI5LTExMDc6My4xMi4wLXJjMS0wMDAwMy1nZjM0NjJhYTo3NDAKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctcjktMTEwNy9mMzQ2MmFhOTUyY2ZjOGY0YjA5NTEwM2NiOWIzZDMwNmRkMjE2
NTU4L2RtZXNnLXF1YW50YWwtbGtwLXR0MDItNjoyMDEzMTEwNzEzMjYxODppMzg2LXJhbmRj
b25maWctcjktMTEwNzozLjEyLjAtcmMxLTAwMDAzLWdmMzQ2MmFhOjc0MAova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1yOS0xMTA3L2YzNDYyYWE5NTJjZmM4ZjRiMDk1MTAzY2I5YjNkMzA2
ZGQyMTY1NTgvZG1lc2ctcXVhbnRhbC1sa3AtdHQwMi04OjIwMTMxMTA3MTMyNjIxOmkzODYt
cmFuZGNvbmZpZy1yOS0xMTA3OjMuMTIuMC1yYzEtMDAwMDMtZ2YzNDYyYWE6NzQwCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXI5LTExMDcvZjM0NjJhYTk1MmNmYzhmNGIwOTUxMDNjYjli
M2QzMDZkZDIxNjU1OC9kbWVzZy1xdWFudGFsLXNuYi0xNjoyMDEzMTEwNzIyMzYzMDppMzg2
LXJhbmRjb25maWctcjktMTEwNzozLjEyLjAtcmMxLTAwMDAzLWdmMzQ2MmFhOjc0MAova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1yOS0xMTA3L2YzNDYyYWE5NTJjZmM4ZjRiMDk1MTAzY2I5
YjNkMzA2ZGQyMTY1NTgvZG1lc2ctcXVhbnRhbC14cHMtMToyMDEzMTEwODA2MzU1NzppMzg2
LXJhbmRjb25maWctcjktMTEwNzozLjEyLjAtcmMxLTAwMDAzLWdmMzQ2MmFhOjc0MAova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1yOS0xMTA3L2YzNDYyYWE5NTJjZmM4ZjRiMDk1MTAzY2I5
YjNkMzA2ZGQyMTY1NTgvZG1lc2cteW9jdG8tbGtwLXN0MDEtNDoyMDEzMTEwODA2MzMwMzpp
Mzg2LXJhbmRjb25maWctcjktMTEwNzozLjEyLjAtcmMxLTAwMDAzLWdmMzQ2MmFhOjc0MAov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1yOS0xMTA3L2YzNDYyYWE5NTJjZmM4ZjRiMDk1MTAz
Y2I5YjNkMzA2ZGQyMTY1NTgvZG1lc2cteW9jdG8tc25iLTQ3OjIwMTMxMTA3MjIzNjI2Omkz
ODYtcmFuZGNvbmZpZy1yOS0xMTA3OjMuMTIuMC1yYzEtMDAwMDMtZ2YzNDYyYWE6NzQwCjA6
OTozIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25z
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDAgc3RlcHMpCltlZWEwZTljYmI5
ZTY1Y2Q1NTNkMzAyYTRhZWZkNGM3YjcwZDlmZDkwXSBrYnVpbGQ6IEluY3JlYXNlIGthbGxz
eW1zIG1heCBzeW1ib2wgbGVuZ3RoCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yOS0xMTA3L25leHQ6
bWFzdGVyOmVlYTBlOWNiYjllNjVjZDU1M2QzMDJhNGFlZmQ0YzdiNzBkOWZkOTA6YmlzZWN0
LXVzYgoKMjAxMy0xMS0wNy0yMjozNjozNSBlZWEwZTljYmI5ZTY1Y2Q1NTNkMzAyYTRhZWZk
NGM3YjcwZDlmZDkwIGNvbXBpbGluZwo4MSByZWFsICAxNjYgdXNlciAgMzYgc3lzICAyNTAu
NzglIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXI5LTExMDcKCjIwMTMtMTEtMDctMjI6Mzg6MTQg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLXJjMS0wMDAwMi1nZWVhMGU5Yy4gVEVTVCBG
QUlMVVJFClsgICAgMS41NjU0MzFdIFRoZSBmb3JjZSBwYXJhbWV0ZXIgaGFzIG5vdCBiZWVu
IHNldCB0byAxLiBUaGUgSXJpcyBwb3dlcm9mZiBoYW5kbGVyIHdpbGwgbm90IGJlIGluc3Rh
bGxlZC4KWyAgICAxLjU2OTg5OF0gYXVkaXQ6IGluaXRpYWxpemluZyBuZXRsaW5rIHNvY2tl
dCAoZGlzYWJsZWQpClsgICAgMS41NzA5ODldIHR5cGU9MjAwMCBhdWRpdCgxMzgzODYzNjk4
LjAxNzoxKTogaW5pdGlhbGl6ZWQKWyAgICAxLjYwMDA0M10gQlVHOiB1bmFibGUgdG8gaGFu
ZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgMDAwMDAwNjIKWyAgICAx
LjYwMTE4MV0gSVA6IFs8NDEwMGM5ZmI+XSBpbnRlbF9kZXRlY3RfdGxiKzB4YWMvMHgyZDYK
WyAgICAxLjYwMjAxNl0gKnBkZSA9IDAwMDAwMDAwIApbICAgIDEuNjAyNDk0XSBPb3BzOiAw
MDAwIFsjMV0gUFJFRU1QVCBTTVAgREVCVUdfUEFHRUFMTE9DClsgICAgMS42MDM0MDBdIE1v
ZHVsZXMgbGlua2VkIGluOgpbICAgIDEuNjAzODk4XSBDUFU6IDEgUElEOiAxIENvbW06IHN3
YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjEyLjAtcmMxLTAwMDAyLWdlZWEwZTljICM3NDEKWyAg
ICAxLjYwNTA1N10gdGFzazogNGVjMWI0NDAgdGk6IDRlYzI4MDAwIHRhc2sudGk6IDRlYzI4
MDAwClsgICAgMS42MDU4NzJdIEVJUDogMDA2MDpbPDQxMDBjOWZiPl0gRUZMQUdTOiAwMDAx
MDI5NyBDUFU6IDEKWyAgICAxLjYwNjY5NF0gRUlQIGlzIGF0IGludGVsX2RldGVjdF90bGIr
MHhhYy8weDJkNgpbICAgIDEuNjA3NDU0XSBFQVg6IDAwMDAwMDYxIEVCWDogMDAwMDg0NDgg
RUNYOiAwMDAwMDIwMCBFRFg6IDAwMDAwMjAwClsgICAgMS42MDg0MDFdIEVTSTogMDAwMDAw
ZjkgRURJOiA0MTU5Mjg3MCBFQlA6IDRlYzI5ZjljIEVTUDogNGVjMjlmODAKWyAgICAxLjYw
OTM0Nl0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMGQ4IEdTOiAwMDAwIFNTOiAwMDY4Clsg
ICAgMS42MTAwMDldIENSMDogODAwNTAwM2IgQ1IyOiAwMDAwMDA2MiBDUjM6IDAxNWE0MDAw
IENSNDogMDAwMDA2ZDAKWyAgICAxLjYxMDAwOV0gU3RhY2s6ClsgICAgMS42MTAwMDldICAw
MDAwMDBhZiAwMDAwMDAwNiAwMDAwMDAwNiA0MTU0YzQxNiAwMDAwMDAwMCA0MTUxNTc5NCA0
ZmNkMjQ0MCA0ZWMyOWZhYwpbICAgIDEuNjEwMDA5XSAgNDEzMzUzZmQgMDAwMDAwMDAgNGVj
MmJmODggNGVjMjgwMDAgNDEzNDQyOTcgNDEzMzUzZjIgMDAwMDAwMDAgMDAwMDAwMDAKWyAg
ICAxLjYxMDAwOV0gIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAw
MDdiIDAwMDAwMDdiIDAwMDAwMGQ4IDAwMDAwMDAwClsgICAgMS42MTAwMDldIENhbGwgVHJh
Y2U6ClsgICAgMS42MTAwMDldICBbPDQxNTRjNDE2Pl0gPyBkb19lYXJseV9wYXJhbSsweDc4
LzB4NzgKWyAgICAxLjYxMDAwOV0gIFs8NDEzMzUzZmQ+XSBrZXJuZWxfaW5pdCsweGIvMHhj
MwpbICAgIDEuNjEwMDA5XSAgWzw0MTM0NDI5Nz5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQr
MHgxYi8weDI4ClsgICAgMS42MTAwMDldICBbPDQxMzM1M2YyPl0gPyByZXN0X2luaXQrMHhi
Ni8weGI2ClsgICAgMS42MTAwMDldIENvZGU6IDYwIDU0IDQxIDY2IDhiIDNkIDEyIDYwIDU0
IDQxIDY2IDg5IDQ1IGUwIDY2IGExIDE4IDYwIDU0IDQxIDY2IDg5IDQ1IGUyIDY2IGExIDE0
IDYwIDU0IDQxIDY2IDg5IDQ1IGRhIDhkIDQ1IGU0IDg5IDQ1IGRjIDhiIDQ1IGRjIDw4YT4g
NTggMDEgODQgZGIgMGYgODQgNTQgMDEgMDAgMDAgYzYgNDUgZDkgMDAgMGYgYjYgNzUgZDkg
NjkgYzYKWyAgICAxLjYxMDAwOV0gRUlQOiBbPDQxMDBjOWZiPl0gaW50ZWxfZGV0ZWN0X3Rs
YisweGFjLzB4MmQ2IFNTOkVTUCAwMDY4OjRlYzI5ZjgwClsgICAgMS42MTAwMDldIENSMjog
MDAwMDAwMDAwMDAwMDA2MgpbICAgIDEuNjI1NzM0XSAtLS1bIGVuZCB0cmFjZSA4ZGMzY2Fi
YjExNWExZTEyIF0tLS0KWyAgICAxLjYyNjQzOF0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNp
bmc6IEZhdGFsIGV4Y2VwdGlvbgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yOS0xMTA3L2Vl
YTBlOWNiYjllNjVjZDU1M2QzMDJhNGFlZmQ0YzdiNzBkOWZkOTAvZG1lc2cteW9jdG8tbGtw
LXN0MDEtNToyMDEzMTEwODA2MzUwMjppMzg2LXJhbmRjb25maWctcjktMTEwNzozLjEyLjAt
cmMxLTAwMDAyLWdlZWEwZTljOjc0MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yOS0xMTA3
L2VlYTBlOWNiYjllNjVjZDU1M2QzMDJhNGFlZmQ0YzdiNzBkOWZkOTAvZG1lc2cteW9jdG8t
eHBzLTc6MjAxMzExMDgwNjM3NTk6aTM4Ni1yYW5kY29uZmlnLXI5LTExMDc6My4xMi4wLXJj
MS0wMDAwMi1nZWVhMGU5Yzo3NDEKMDoyOjIgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMK
G1sxOzM1bVJFUEVBVCBDT1VOVDogMjAgICMgL2NjL3dmZy91c2ItYmlzZWN0Ly5yZXBlYXQb
WzBtCgplZWEwZTljYmI5ZTY1Y2Q1NTNkMzAyYTRhZWZkNGM3YjcwZDlmZDkwIGlzIHRoZSBm
aXJzdCBiYWQgY29tbWl0CmNvbW1pdCBlZWEwZTljYmI5ZTY1Y2Q1NTNkMzAyYTRhZWZkNGM3
YjcwZDlmZDkwCkF1dGhvcjogSm9lIE1hcmlvIDxqbWFyaW9AcmVkaGF0LmNvbT4KRGF0ZTog
ICBXZWQgT2N0IDIzIDE1OjA2OjUzIDIwMTMgKzAyMDAKCiAgICBrYnVpbGQ6IEluY3JlYXNl
IGthbGxzeW1zIG1heCBzeW1ib2wgbGVuZ3RoCiAgICAKICAgIFtBSzogVGhpcyBzZWVtcyBs
aWtlIGEgdGlja2luZyB0aW1lIGJvbWIgZXZlbiB3aXRob3V0IExUTywKICAgIHNvIHNob3Vs
ZCBiZSBtZXJnZWQgbm93LiBJdCBjYXVzZXMgdmVyeSB3ZWlyZCBwcm9ibGVtcy4KICAgIFRo
YW5rcyB0byBKb2UgZm9yIHRyYWNraW5nIHRoZW0gZG93bi5dCiAgICAKICAgIFdpdGggdGhl
IGFkZGVkIHBvc3RmaXhlcyB0aGF0IExUTyBhZGRzIGZvciBsb2NhbAogICAgc3ltYm9scywg
dGhlIGxvbmdlc3QgbmFtZSBpbiB0aGUga2VybmVsIG92ZXJmbG93cwogICAgdGhlIG5hbWVi
dWZbS1NZTV9OQU1FX0xFTl0gYXJyYXkgYnkgdHdvIGJ5dGVzLiAgVGhhdCBuYW1lIGlzOgog
ICAgX19wY2lfZml4dXBfcmVzdW1lUENJX1ZFTkRPUl9JRF9TRVJWRVJXT1JLU1BDSV9ERVZJ
Q0VfSURfU0VSVkVSV09SS1NfSFQxMDAwU0JxdWlya19kaXNhYmxlX2Jyb2FkY29tX2Jvb3Rf
aW50ZXJydXB0LjE0ODgwMDQuNjcyODAyCiAgICAKICAgIERvdWJsZSB0aGUgbWF4IHN5bWJv
bCBuYW1lIGxlbmd0aC4KICAgIAogICAgdjI6IFVzZSAyNTUgIChKb2UgUGVyY2hlcykKICAg
IFNpZ25lZC1vZmYtYnk6IEFuZGkgS2xlZW4gPGFrQGxpbnV4LmludGVsLmNvbT4KICAgIFNp
Z25lZC1vZmYtYnk6IE1pY2hhbCBNYXJlayA8bW1hcmVrQHN1c2UuY3o+Cgo6MDQwMDAwIDA0
MDAwMCA3ZWI3YjhmMDk2OWU4ZjAyZTY3OWU1MTNmZWVkMGIzMWNhYTI3NzNiIDI1NmNlYWE4
ZTM3NDA5N2ZhMWYzYzJjMTJiZDJjMWNjMTcwZTE3YjEgTQlpbmNsdWRlCmJpc2VjdCBydW4g
c3VjY2VzcwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLXI5LTExMDcvbmV4dDptYXN0ZXI6ODA5NzA0NzIxNzlhNDU2MDljMGIxMWI4MDYxOWJj
OGMzMmIxNWY3NzpiaXNlY3QtdXNiCgoyMDEzLTExLTA3LTIyOjM4OjQ2IDgwOTcwNDcyMTc5
YTQ1NjA5YzBiMTFiODA2MTliYzhjMzJiMTVmNzcgY29tcGlsaW5nCgoyMDEzLTExLTA3LTIy
OjQwOjI1IGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1yYzEtMDAwMDEtZzgwOTcwNDcu
CTEJNwkxNgkyMQkzMwk0OQk1Mwk2MCBTVUNDRVNTCgpscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXI5LTExMDcvbmV4dDptYXN0ZXI6NDhkYTFh
MjlmNTg4M2VmOWQxNGM2YjgyOGU0NjlkODZiNGZjMDk4MDpiaXNlY3QtdXNiCgoyMDEzLTEx
LTA3LTIyOjQ1OjAyIDQ4ZGExYTI5ZjU4ODNlZjlkMTRjNmI4MjhlNDY5ZDg2YjRmYzA5ODAg
cmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjktMTEwNy80OGRhMWEyOWY1ODgzZWY5
ZDE0YzZiODI4ZTQ2OWQ4NmI0ZmMwOTgwL3ZtbGludXotMy4xMi4wLW5leHQtMjAxMzExMDct
MTAzODEtZzQ4ZGExYTIKCjIwMTMtMTEtMDctMjI6NDU6MDMgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgCTEyCTI1CTM2CTQ0CTUyCTU3CTU5Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
LhtbMTszNW1hZGRfdG9fcnVuX3F1ZXVlIDEbWzBtCgk2MCBTVUNDRVNTCgpbZGV0YWNoZWQg
SEVBRCA3MmE5NGE4XSBSZXZlcnQgImtidWlsZDogSW5jcmVhc2Uga2FsbHN5bXMgbWF4IHN5
bWJvbCBsZW5ndGgiCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRp
b24oLSkKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZp
Zy1yOS0xMTA3L25leHQ6bWFzdGVyOjcyYTk0YThmNzU1ZTFiZTE5ZjEzNDFjYjcwZjYyMTJh
YjkwODM3NmM6YmlzZWN0LXVzYgoKMjAxMy0xMS0wOC0wMToxOTo0MyA3MmE5NGE4Zjc1NWUx
YmUxOWYxMzQxY2I3MGY2MjEyYWI5MDgzNzZjIGNvbXBpbGluZwoKMjAxMy0xMS0wOC0wMToy
NDoxNCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtbmV4dC0yMDEzMTEwNy0xMDM4Mi1n
NzJhOTRhOC4JNQkxOAkzMwkzOQk0Ngk1MQk1Mgk1Nwk1OQk2MCBTVUNDRVNTCgoKPT09PT09
PT09IHVwc3RyZWFtID09PT09PT09PQpGZXRjaGluZyBsaW51cwpscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXI5LTExMDcvbmV4dDptYXN0ZXI6
YTEyMTJkMjc4YzA1Y2EwYTM4ZjVjYmQ3YWU5MGFjMmUzNjcyMjhhODpiaXNlY3QtdXNiCgoy
MDEzLTExLTA4LTAxOjI5OjUwIGExMjEyZDI3OGMwNWNhMGEzOGY1Y2JkN2FlOTBhYzJlMzY3
MjI4YTggcmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjktMTEwNy9hMTIxMmQyNzhj
MDVjYTBhMzhmNWNiZDdhZTkwYWMyZTM2NzIyOGE4L3ZtbGludXotMy4xMi4wLTAxNzE0LWdh
MTIxMmQyCgoyMDEzLTExLTA4LTAxOjI5OjUwIGRldGVjdGluZyBib290IHN0YXRlIAkxMAkx
MQkxMwkxNAkyOAk0MQk0OAk2MCBTVUNDRVNTCgoKPT09PT09PT09IGxpbnV4LW5leHQgPT09
PT09PT09CkZldGNoaW5nIG5leHQKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3Zt
L2kzODYtcmFuZGNvbmZpZy1yOS0xMTA3L25leHQ6bWFzdGVyOjQ4ZGExYTI5ZjU4ODNlZjlk
MTRjNmI4MjhlNDY5ZDg2YjRmYzA5ODA6YmlzZWN0LXVzYgogU1VDQ0VTUwoK

--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.12.0-09952-g71cc615"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.12.0 Kernel Configuration
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
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
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
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
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
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_HUGETLB is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
CONFIG_SCHED_AUTOGROUP=y
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
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
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
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
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
CONFIG_BASE_SMALL=1
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
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
# CONFIG_X86_WANT_INTEL_MID is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_RDC321X is not set
CONFIG_X86_32_NON_STANDARD=y
# CONFIG_X86_NUMAQ is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_STA2X11 is not set
CONFIG_X86_SUMMIT=y
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
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_CYRIX_32 is not set
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
# CONFIG_CPU_SUP_TRANSMETA_32 is not set
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
# CONFIG_VM86 is not set
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=m
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
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
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=y
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_MEM_SOFT_DIRTY=y
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
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
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
CONFIG_DEBUG_HOTPLUG_CPU0=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_DPM_WATCHDOG is not set
# CONFIG_PM_TRACE_RTC is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
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
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
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
# CONFIG_ACPI_EXTLOG is not set
# CONFIG_SFI is not set
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
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_OLPC=y
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
# CONFIG_EISA is not set
CONFIG_SCx200=m
CONFIG_SCx200HR_TIMER=m
CONFIG_OLPC=y
# CONFIG_OLPC_XO15_SCI is not set
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
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
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_USER is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
# CONFIG_IP_PNP_DHCP is not set
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
# CONFIG_NET_IPGRE is not set
# CONFIG_SYN_COOKIES is not set
CONFIG_NET_IPVTI=m
CONFIG_INET_AH=y
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=m
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_INET_UDP_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=m
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=y
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=y
CONFIG_TCP_CONG_LP=y
CONFIG_TCP_CONG_VENO=y
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_DEFAULT_BIC=y
# CONFIG_DEFAULT_HYBLA is not set
# CONFIG_DEFAULT_VENO is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="bic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=y
# CONFIG_INET6_ESP is not set
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=y
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
CONFIG_INET6_XFRM_MODE_TUNNEL=y
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
# CONFIG_IPV6_VTI is not set
# CONFIG_IPV6_SIT is not set
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_GRE=y
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETLABEL=y
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
# CONFIG_NF_CONNTRACK_SECMARK is not set
# CONFIG_NF_CONNTRACK_PROCFS is not set
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_IRC is not set
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CT_NETLINK=m
# CONFIG_NF_TABLES is not set
CONFIG_NETFILTER_XTABLES=m

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_LOG=m
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_CONNTRACK is not set
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
# CONFIG_NETFILTER_XT_MATCH_STATE is not set
# CONFIG_IP_SET is not set
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
# CONFIG_IP_VS_PROTO_UDP is not set
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
# CONFIG_IP_VS_PROTO_SCTP is not set

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
# CONFIG_IP_VS_LC is not set
# CONFIG_IP_VS_WLC is not set
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#
# CONFIG_IP_VS_NFCT is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
# CONFIG_IP_NF_IPTABLES is not set

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=y

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
CONFIG_IP_DCCP_DEBUG=y
# CONFIG_NET_DCCPPROBE is not set
CONFIG_IP_SCTP=y
CONFIG_NET_SCTPPROBE=m
CONFIG_SCTP_DBG_OBJCNT=y
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_RDS=m
CONFIG_RDS_TCP=m
# CONFIG_RDS_DEBUG is not set
CONFIG_TIPC=y
CONFIG_TIPC_PORTS=8191
# CONFIG_ATM is not set
CONFIG_L2TP=m
# CONFIG_L2TP_DEBUGFS is not set
# CONFIG_L2TP_V3 is not set
# CONFIG_BRIDGE is not set
CONFIG_VLAN_8021Q=m
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_VLAN_8021Q_MVRP is not set
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=m
CONFIG_IPX_INTERN=y
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
CONFIG_PHONET=m
CONFIG_IEEE802154=y
CONFIG_IEEE802154_6LOWPAN=y
CONFIG_MAC802154=m
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
# CONFIG_OPENVSWITCH_GRE is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=m
CONFIG_NET_MPLS_GSO=m
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NETPRIO_CGROUP=m
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
CONFIG_NET_TCPPROBE=m
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=m
CONFIG_AX25_DAMA_SLAVE=y
CONFIG_NETROM=m
CONFIG_ROSE=m

#
# AX.25 network device drivers
#
CONFIG_MKISS=m
CONFIG_6PACK=m
CONFIG_BPQETHER=m
CONFIG_SCC=m
CONFIG_SCC_DELAY=y
CONFIG_SCC_TRXECHO=y
CONFIG_BAYCOM_SER_FDX=m
# CONFIG_BAYCOM_SER_HDX is not set
CONFIG_YAM=m
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
CONFIG_CAN_SLCAN=y
CONFIG_CAN_DEV=m
# CONFIG_CAN_CALC_BITTIMING is not set
# CONFIG_CAN_LEDS is not set
# CONFIG_PCH_CAN is not set
CONFIG_CAN_GRCAN=m
CONFIG_CAN_SJA1000=m
# CONFIG_CAN_SJA1000_ISA is not set
CONFIG_CAN_SJA1000_PLATFORM=m
CONFIG_CAN_SJA1000_OF_PLATFORM=m
# CONFIG_CAN_EMS_PCI is not set
# CONFIG_CAN_PEAK_PCI is not set
# CONFIG_CAN_KVASER_PCI is not set
# CONFIG_CAN_PLX_PCI is not set
CONFIG_CAN_TSCAN1=m
# CONFIG_CAN_C_CAN is not set
# CONFIG_CAN_CC770 is not set

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=m
# CONFIG_CAN_ESD_USB2 is not set
# CONFIG_CAN_KVASER_USB is not set
# CONFIG_CAN_PEAK_USB is not set
CONFIG_CAN_8DEV_USB=m
# CONFIG_CAN_SOFTING is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
CONFIG_IRCOMM=y
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
CONFIG_IRTTY_SIR=m

#
# Dongle support
#
CONFIG_DONGLE=y
CONFIG_ESI_DONGLE=m
CONFIG_ACTISYS_DONGLE=m
CONFIG_TEKRAM_DONGLE=m
CONFIG_TOIM3232_DONGLE=m
CONFIG_LITELINK_DONGLE=m
CONFIG_MA600_DONGLE=m
# CONFIG_GIRBIL_DONGLE is not set
CONFIG_MCP2120_DONGLE=m
CONFIG_OLD_BELKIN_DONGLE=m
CONFIG_ACT200L_DONGLE=m
CONFIG_KINGSUN_DONGLE=m
CONFIG_KSDAZZLE_DONGLE=m
CONFIG_KS959_DONGLE=m

#
# FIR device drivers
#
CONFIG_USB_IRDA=m
# CONFIG_SIGMATEL_FIR is not set
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=m
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=m
CONFIG_ALI_FIR=y
# CONFIG_VLSI_FIR is not set
CONFIG_VIA_FIR=m
# CONFIG_MCS_FIR is not set
CONFIG_BT=m
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
# CONFIG_BT_HCIBTSDIO is not set
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM203X is not set
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
# CONFIG_BT_MRVL_SDIO is not set
CONFIG_BT_ATH3K=m
CONFIG_AF_RXRPC=m
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=m
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
CONFIG_RFKILL_REGULATOR=m
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=m
CONFIG_NET_9P_DEBUG=y
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
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
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
# CONFIG_PROC_DEVICETREE is not set
# CONFIG_OF_SELFTEST is not set
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
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

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=m
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1780=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=m
CONFIG_DS1682=m
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=m
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
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
# CONFIG_ALTERA_STAPL is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
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
CONFIG_VHOST_NET=m
CONFIG_VHOST_RING=m
CONFIG_VHOST=m

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=m
CONFIG_KEYBOARD_ADP5589=m
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=m
CONFIG_KEYBOARD_QT2160=m
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_GPIO=y
# CONFIG_KEYBOARD_GPIO_POLLED is not set
CONFIG_KEYBOARD_TCA6416=m
CONFIG_KEYBOARD_TCA8418=m
# CONFIG_KEYBOARD_MATRIX is not set
CONFIG_KEYBOARD_LM8323=m
CONFIG_KEYBOARD_LM8333=m
CONFIG_KEYBOARD_MAX7359=m
CONFIG_KEYBOARD_MCS=m
CONFIG_KEYBOARD_MPR121=m
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_OPENCORES=y
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_SH_KEYSC is not set
CONFIG_KEYBOARD_XTKBD=y
CONFIG_KEYBOARD_CROS_EC=m
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=m
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
# CONFIG_JOYSTICK_SIDEWINDER is not set
CONFIG_JOYSTICK_TMDC=y
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=m
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=m
# CONFIG_JOYSTICK_AS5011 is not set
CONFIG_JOYSTICK_JOYDUMP=m
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_AD7879=m
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=m
CONFIG_TOUCHSCREEN_AUO_PIXCIR=m
CONFIG_TOUCHSCREEN_BU21013=m
CONFIG_TOUCHSCREEN_CY8CTMG110=m
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=m
# CONFIG_TOUCHSCREEN_CYTTSP4_I2C is not set
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=m
CONFIG_TOUCHSCREEN_EETI=m
# CONFIG_TOUCHSCREEN_EGALAX is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=m
CONFIG_TOUCHSCREEN_WACOM_I2C=m
CONFIG_TOUCHSCREEN_MAX11801=m
# CONFIG_TOUCHSCREEN_MCS5000 is not set
CONFIG_TOUCHSCREEN_MMS114=m
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=m
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_HTCPEN=m
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=m
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=m
# CONFIG_TOUCHSCREEN_TI_AM335X_TSC is not set
CONFIG_TOUCHSCREEN_PIXCIR=m
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
# CONFIG_TOUCHSCREEN_USB_EGALAX is not set
# CONFIG_TOUCHSCREEN_USB_PANJIT is not set
# CONFIG_TOUCHSCREEN_USB_3M is not set
# CONFIG_TOUCHSCREEN_USB_ITM is not set
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
# CONFIG_TOUCHSCREEN_USB_IRTOUCH is not set
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
# CONFIG_TOUCHSCREEN_USB_JASTEC is not set
# CONFIG_TOUCHSCREEN_USB_ELO is not set
# CONFIG_TOUCHSCREEN_USB_E2I is not set
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
CONFIG_TOUCHSCREEN_TPS6507X=m
# CONFIG_TOUCHSCREEN_ZFORCE is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_BMA150=m
CONFIG_INPUT_PCSPKR=m
CONFIG_INPUT_MMA8450=m
CONFIG_INPUT_MPU3050=m
CONFIG_INPUT_APANEL=m
CONFIG_INPUT_GP2A=m
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=m
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=m
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=m
CONFIG_INPUT_RETU_PWRBUTTON=m
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF50633_PMU=m
CONFIG_INPUT_PCF8574=m
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=m
# CONFIG_INPUT_IMS_PCU is not set
CONFIG_INPUT_CMA3000=m
CONFIG_INPUT_CMA3000_I2C=m
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=m
CONFIG_SERIO_ARC_PS2=m
# CONFIG_SERIO_APBPS2 is not set
CONFIG_SERIO_OLPC_APSP=m
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
# CONFIG_UNIX98_PTYS is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=y
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
CONFIG_MOXA_SMARTIO=m
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
# CONFIG_N_HDLC is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=y
CONFIG_DEVKMEM=y

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
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_FOURPORT=y
# CONFIG_SERIAL_8250_ACCENT is not set
# CONFIG_SERIAL_8250_BOCA is not set
# CONFIG_SERIAL_8250_EXAR_ST16C554 is not set
# CONFIG_SERIAL_8250_HUB6 is not set
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set
CONFIG_SERIAL_8250_DW=m

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_OF_PLATFORM=m
CONFIG_SERIAL_SCCNXP=m
CONFIG_SERIAL_TIMBERDALE=m
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_XILINX_PS_UART=m
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
CONFIG_SERIAL_ST_ASC=m
CONFIG_TTY_PRINTK=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=m
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=m
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_GEODE=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_HW_RANDOM_TPM=m
CONFIG_NVRAM=m
CONFIG_DTLK=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
CONFIG_MWAVE=y
CONFIG_SCx200_GPIO=m
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_ATMEL is not set
# CONFIG_TCG_TIS_I2C_INFINEON is not set
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=m
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_ARB_GPIO_CHALLENGE is not set
# CONFIG_I2C_MUX_GPIO is not set
CONFIG_I2C_MUX_PCA9541=m
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

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
CONFIG_I2C_GPIO=m
CONFIG_I2C_KEMPLD=m
CONFIG_I2C_OCORES=m
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SH_MOBILE is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=m
# CONFIG_I2C_RCAR is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_TAOS_EVM=m
CONFIG_I2C_TINY_USB=m
CONFIG_I2C_VIPERBOARD=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_ISA=m
CONFIG_SCx200_I2C=m
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=m

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_GPIO=m

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
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=m
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_F7188X is not set
CONFIG_GPIO_TS5500=m
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set
CONFIG_GPIO_GRGPIO=m

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=m
CONFIG_GPIO_MAX7300=m
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=m
# CONFIG_GPIO_PCF857X is not set
CONFIG_GPIO_ADP5588=m
CONFIG_GPIO_ADNP=m

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_INTEL_MID is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_SODAVILLE is not set
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
CONFIG_GPIO_KEMPLD=m

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_BCM_KONA is not set

#
# USB GPIO expanders:
#
# CONFIG_GPIO_VIPERBOARD is not set
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_DS1WM=m
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=m
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
# CONFIG_W1_SLAVE_DS2413 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=m
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=m
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=m
# CONFIG_BATTERY_OLPC is not set
CONFIG_BATTERY_SBS=m
CONFIG_BATTERY_BQ27x00=m
# CONFIG_BATTERY_BQ27X00_I2C is not set
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
CONFIG_BATTERY_MAX17040=m
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_CHARGER_PCF50633=m
CONFIG_CHARGER_ISP1704=y
CONFIG_CHARGER_MAX8903=m
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_BQ2415X=m
# CONFIG_CHARGER_BQ24190 is not set
# CONFIG_CHARGER_BQ24735 is not set
CONFIG_CHARGER_SMB347=m
CONFIG_BATTERY_GOLDFISH=y
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_GPIO is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_AD7414=m
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=m
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=m
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_G762=m
CONFIG_SENSORS_GL518SM=m
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_GPIO_FAN=m
CONFIG_SENSORS_HIH6130=m
# CONFIG_SENSORS_HTU21 is not set
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=m
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4245=m
CONFIG_SENSORS_LTC4261=m
CONFIG_SENSORS_LM95234=m
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=m
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=m
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_LM25066 is not set
CONFIG_SENSORS_LTC2978=m
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX34440 is not set
# CONFIG_SENSORS_MAX8688 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
CONFIG_SENSORS_ZL6100=m
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=m
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=m
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=m
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
CONFIG_SENSORS_THMC50=m
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=m
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=m
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_APPLESMC=m

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
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3722 is not set
CONFIG_MFD_CROS_EC=m
CONFIG_MFD_CROS_EC_I2C=m
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=m
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=m
CONFIG_MFD_VIPERBOARD=m
CONFIG_MFD_RETU=m
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
CONFIG_ABX500_CORE=y
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=m
CONFIG_TPS6105X=m
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65217=m
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=m
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM8997 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=m
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_ANATOP=m
# CONFIG_REGULATOR_DA9210 is not set
# CONFIG_REGULATOR_FAN53555 is not set
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_ISL6271A=m
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=m
CONFIG_REGULATOR_LP8755=m
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_MAX8649=m
CONFIG_REGULATOR_MAX8660=m
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8973=m
CONFIG_REGULATOR_PCF50633=m
CONFIG_REGULATOR_PFUZE100=m
CONFIG_REGULATOR_TPS51632=m
CONFIG_REGULATOR_TPS6105X=m
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS65023 is not set
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65217=m
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=m
CONFIG_DRM_USB=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
CONFIG_DRM_I2C_NXP_TDA998X=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=m
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
CONFIG_FB=m
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
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
# CONFIG_FB_ARC is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=m
CONFIG_FB_N411=m
CONFIG_FB_HGA=m
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
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=m
# CONFIG_FB_TMIO_ACCELL is not set
# CONFIG_FB_SMSCUFX is not set
CONFIG_FB_UDL=m
# CONFIG_FB_GOLDFISH is not set
CONFIG_FB_VIRTUAL=m
CONFIG_FB_METRONOME=m
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=m
CONFIG_FB_AUO_K190X=m
# CONFIG_FB_AUO_K1900 is not set
# CONFIG_FB_AUO_K1901 is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_BACKLIGHT_GENERIC=m
# CONFIG_BACKLIGHT_LM3533 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=m
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=m
CONFIG_BACKLIGHT_PCF50633=m
CONFIG_BACKLIGHT_LM3630=m
CONFIG_BACKLIGHT_LM3639=m
CONFIG_BACKLIGHT_LP855X=m
CONFIG_BACKLIGHT_TPS65217=m
CONFIG_BACKLIGHT_GPIO=m
CONFIG_BACKLIGHT_LV5207LP=m
CONFIG_BACKLIGHT_BD6107=m
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
# CONFIG_LOGO_LINUX_CLUT224 is not set
# CONFIG_FB_SSD1307 is not set
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
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
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
# CONFIG_SND_MTPAV is not set
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
# CONFIG_SND_ISA is not set
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
# CONFIG_SND_USB is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=m
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_GENERIC=m

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=m
# CONFIG_HID_APPLEIR is not set
CONFIG_HID_AUREAL=m
# CONFIG_HID_BELKIN is not set
CONFIG_HID_CHERRY=m
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_PRODIKEYS is not set
# CONFIG_HID_CYPRESS is not set
CONFIG_HID_DRAGONRISE=m
CONFIG_DRAGONRISE_FF=y
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=m
CONFIG_HID_ELO=m
CONFIG_HID_EZKEY=m
# CONFIG_HID_HOLTEK is not set
CONFIG_HID_HUION=m
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=m
CONFIG_HID_LOGITECH_DJ=m
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTRIG is not set
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
# CONFIG_HID_PICOLCD_LCD is not set
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=m
CONFIG_HID_ROCCAT=m
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=m
# CONFIG_HID_SONY is not set
CONFIG_HID_SPEEDLINK=m
CONFIG_HID_STEELSERIES=m
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=m
CONFIG_GREENASIA_FF=y
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
# CONFIG_HID_THRUSTMASTER is not set
CONFIG_HID_WACOM=m
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=m
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=m
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
# CONFIG_USB_MOUSE is not set

#
# I2C HID support
#
CONFIG_I2C_HID=m
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=m
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=m
CONFIG_USB_WUSB_CBAF=m
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
CONFIG_USB_XHCI_HCD=m
CONFIG_USB_EHCI_HCD=m
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_EHCI_PCI=m
CONFIG_USB_EHCI_HCD_PLATFORM=m
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=m
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_FUSBH200_HCD=m
CONFIG_USB_FOTG210_HCD=m
CONFIG_USB_OHCI_HCD=m
CONFIG_USB_OHCI_HCD_PCI=m
CONFIG_USB_OHCI_HCD_SSB=y
CONFIG_USB_OHCI_HCD_PLATFORM=m
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_U132_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_HCD_BCMA=m
CONFIG_USB_HCD_SSB=m
CONFIG_USB_HCD_TEST_MODE=y
CONFIG_USB_MUSB_HDRC=m
# CONFIG_USB_MUSB_HOST is not set
# CONFIG_USB_MUSB_GADGET is not set
CONFIG_USB_MUSB_DUAL_ROLE=y
CONFIG_USB_MUSB_TUSB6010=m
CONFIG_USB_MUSB_DSPS=m
# CONFIG_USB_MUSB_UX500 is not set
CONFIG_USB_MUSB_AM335X_CHILD=m
CONFIG_MUSB_PIO_ONLY=y
# CONFIG_USB_RENESAS_USBHS is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
# CONFIG_USB_DWC3 is not set
CONFIG_USB_CHIPIDEA=m
# CONFIG_USB_CHIPIDEA_UDC is not set
# CONFIG_USB_CHIPIDEA_HOST is not set
# CONFIG_USB_CHIPIDEA_DEBUG is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=m
# CONFIG_USB_SERIAL_GENERIC is not set
CONFIG_USB_SERIAL_SIMPLE=m
# CONFIG_USB_SERIAL_AIRCABLE is not set
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
# CONFIG_USB_SERIAL_FTDI_SIO is not set
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
# CONFIG_USB_SERIAL_EDGEPORT is not set
CONFIG_USB_SERIAL_EDGEPORT_TI=m
# CONFIG_USB_SERIAL_F81232 is not set
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
# CONFIG_USB_SERIAL_METRO is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_QCAUX=m
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_SAFE=m
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_WWAN=m
# CONFIG_USB_SERIAL_OPTION is not set
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
CONFIG_USB_SERIAL_XSENS_MT=m
CONFIG_USB_SERIAL_WISHBONE=m
# CONFIG_USB_SERIAL_ZTE is not set
# CONFIG_USB_SERIAL_SSU100 is not set
CONFIG_USB_SERIAL_QT2=m
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=m
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=m
CONFIG_USB_TEST=m
CONFIG_USB_EHSET_TEST_FIXTURE=m
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=m
CONFIG_USB_HSIC_USB3503=m

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=m
CONFIG_OMAP_CONTROL_USB=y
CONFIG_OMAP_USB3=y
CONFIG_AM335X_CONTROL_USB=m
CONFIG_AM335X_PHY_USB=m
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_USB_GPIO_VBUS=m
# CONFIG_USB_ISP1301 is not set
CONFIG_USB_RCAR_PHY=m
# CONFIG_USB_RCAR_GEN2_PHY is not set
CONFIG_USB_GADGET=m
# CONFIG_USB_GADGET_DEBUG is not set
CONFIG_USB_GADGET_DEBUG_FILES=y
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FUSB300=m
CONFIG_USB_FOTG210_UDC=m
CONFIG_USB_R8A66597=m
CONFIG_USB_PXA27X=m
# CONFIG_USB_MV_UDC is not set
# CONFIG_USB_MV_U3D is not set
# CONFIG_USB_M66592 is not set
# CONFIG_USB_AMD5536UDC is not set
# CONFIG_USB_NET2272 is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
CONFIG_USB_DUMMY_HCD=m
CONFIG_USB_LIBCOMPOSITE=m
CONFIG_USB_F_ACM=m
CONFIG_USB_F_SS_LB=m
CONFIG_USB_U_SERIAL=m
CONFIG_USB_U_ETHER=m
CONFIG_USB_U_RNDIS=m
CONFIG_USB_F_OBEX=m
CONFIG_USB_F_NCM=m
CONFIG_USB_F_ECM=m
CONFIG_USB_F_PHONET=m
CONFIG_USB_F_SUBSET=m
# CONFIG_USB_CONFIGFS is not set
CONFIG_USB_ZERO=m
CONFIG_USB_AUDIO=m
CONFIG_GADGET_UAC1=y
CONFIG_USB_ETH=m
# CONFIG_USB_ETH_RNDIS is not set
# CONFIG_USB_ETH_EEM is not set
CONFIG_USB_G_NCM=m
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_G_SERIAL is not set
CONFIG_USB_MIDI_GADGET=m
CONFIG_USB_G_PRINTER=m
CONFIG_USB_CDC_COMPOSITE=m
CONFIG_USB_G_NOKIA=m
CONFIG_USB_G_HID=m
# CONFIG_USB_G_DBGP is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
# CONFIG_MMC_OMAP_HS is not set
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_VUB300=m
# CONFIG_MMC_USHC is not set
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
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=m
CONFIG_LEDS_NET48XX=m
CONFIG_LEDS_WRAP=m
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_PCA9532_GPIO=y
CONFIG_LEDS_GPIO=m
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_LP5562=m
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_PCA955X=m
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_PCA9685 is not set
CONFIG_LEDS_REGULATOR=m
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_TCA6507=m
CONFIG_LEDS_LM355x=m
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_DECODE_MCE is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_SYSTOHC is not set
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=m
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF2127=m
CONFIG_RTC_DRV_PCF8523=m
# CONFIG_RTC_DRV_PCF8563 is not set
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_S35390A=m
# CONFIG_RTC_DRV_FM3130 is not set
CONFIG_RTC_DRV_RX8581=m
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=m
CONFIG_RTC_DRV_RV3029C2=m

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=m
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_DS2404=m
CONFIG_RTC_DRV_PCF50633=m

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_SNVS is not set
CONFIG_RTC_DRV_MOXART=m

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=m

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MMIO=m
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_ARM_ARCH_TIMER_EVTSTREAM is not set
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
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IRQCHIP=y
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=y
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
# CONFIG_FMC_FAKEDEV is not set
CONFIG_FMC_TRIVIAL=m
# CONFIG_FMC_WRITE_EEPROM is not set
CONFIG_FMC_CHARDEV=y
# CONFIG_POWERCAP is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
# CONFIG_PHY_EXYNOS_DP_VIDEO is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
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
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=m
# CONFIG_CUSE is not set

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
CONFIG_FSCACHE_DEBUG=y
CONFIG_FSCACHE_OBJECT_LIST=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ECRYPT_FS=m
CONFIG_ECRYPT_FS_MESSAGING=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
CONFIG_PSTORE_RAM=m
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_ACL=y
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_SMB2 is not set
# CONFIG_CIFS_FSCACHE is not set
CONFIG_NCP_FS=y
CONFIG_NCPFS_PACKET_SIGNING=y
# CONFIG_NCPFS_IOCTL_LOCKING is not set
# CONFIG_NCPFS_STRONG is not set
CONFIG_NCPFS_NFS_NS=y
# CONFIG_NCPFS_OS2_NS is not set
CONFIG_NCPFS_SMALLDOS=y
# CONFIG_NCPFS_NLS is not set
# CONFIG_NCPFS_EXTRAS is not set
CONFIG_CODA_FS=y
CONFIG_AFS_FS=m
CONFIG_AFS_DEBUG=y
CONFIG_AFS_FSCACHE=y
# CONFIG_9P_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=m
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=y
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
# CONFIG_DLM_DEBUG is not set

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
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
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
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
CONFIG_DEBUG_OBJECTS_WORK=y
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
# CONFIG_SCHED_DEBUG is not set
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_PREEMPT is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
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
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_PROVE_RCU_DELAY is not set
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
CONFIG_NOTIFIER_ERROR_INJECTION=m
CONFIG_CPU_NOTIFIER_ERROR_INJECT=m
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
CONFIG_FAULT_INJECTION=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MMC_REQUEST=y
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
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
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=m
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_SET_MODULE_RONX=y
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
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
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_SELINUX is not set
CONFIG_SECURITY_SMACK=y
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
CONFIG_SECURITY_APPARMOR_HASH=y
CONFIG_SECURITY_YAMA=y
CONFIG_SECURITY_YAMA_STACKED=y
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
# CONFIG_INTEGRITY_AUDIT is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_LSM_RULES=y
# CONFIG_IMA_TEMPLATE is not set
CONFIG_IMA_NG_TEMPLATE=y
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima-ng"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
# CONFIG_IMA_DEFAULT_HASH_SHA256 is not set
# CONFIG_IMA_DEFAULT_HASH_WP512 is not set
CONFIG_IMA_DEFAULT_HASH="sha1"
# CONFIG_IMA_APPRAISE is not set
CONFIG_EVM=y
CONFIG_EVM_HMAC_VERSION=2
CONFIG_DEFAULT_SECURITY_SMACK=y
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
# CONFIG_DEFAULT_SECURITY_YAMA is not set
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="smack"
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
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
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=m
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=m
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
# CONFIG_CRYPTO_TWOFISH_586 is not set

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
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_LGUEST=m
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
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
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
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
CONFIG_DDR=y

--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--Qxx1br4bt0+wmkIi--
