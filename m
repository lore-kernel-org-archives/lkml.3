Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbaBSMlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 07:41:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:49080 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbaBSMlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 07:41:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,505,1389772800"; 
   d="log'?scan'208";a="477627413"
Date: Wed, 19 Feb 2014 20:41:22 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [workqueue] BUG: unable to handle kernel paging request at
 ffff880000798f60
Message-ID: <20140219124122.GH7735@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7DO5AaGCk89r4vaK"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7DO5AaGCk89r4vaK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git

commit 84604340d034a074036e86e85c4055a1c7ea5529
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue Feb 11 12:00:36 2014 +0100
Commit:     Tejun Heo <tj@kernel.org>
CommitDate: Tue Feb 11 10:25:17 2014 -0500

    workqueue: Fix workqueue lockdep name
    
    Tommi noticed a 'funny' lock class name: "%s#5" from a lock acquired
    in process_one_work(). It turns out that commit b196be89cdc14 forgot
    to change the lockdep_init_map() when it changed the @lock_name
    argument from a string to a format.
    
    Fixes: b196be89cdc14 ("workqueue: make alloc_workqueue() take printf
    fmt and args for name")
    
    Reported-by: Tommi Rantala <tt.rantala@gmail.com>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Signed-off-by: Tejun Heo <tj@kernel.org>
    Cc: stable@vger.kernel.org

[   21.989145] rds_page_remainder_cpu_notify(): cpu 0 action 0x7
[   21.990793] rds_page_remainder_cpu_notify(): cpu 1 action 0x7
[   21.990793] rds_page_remainder_cpu_notify(): cpu 1 action 0x7
[   21.995278] BUG: unable to handle kernel 

git bisect start 84604340d034a074036e86e85c4055a1c7ea5529 38dbfb59d1175ef458d006556061adeaa8751b72 --
# first bad commit: [84604340d034a074036e86e85c4055a1c7ea5529] workqueue: Fix workqueue lockdep name
git bisect good 38dbfb59d1175ef458d006556061adeaa8751b72  # 11:55    285+    148  Linus 3.14-rc1
git bisect  bad 84604340d034a074036e86e85c4055a1c7ea5529  # 11:55      0-     19  workqueue: Fix workqueue lockdep name

Thanks,
Fengguang

--7DO5AaGCk89r4vaK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-xian-11:20140212211335:x86_64-randconfig-c4-0212:3.14.0-rc1-00001-g8460434:27"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc1-00001-g8460434 (kbuild@cairo) (gcc =
version 4.8.1 (Debian 4.8.1-8) ) #27 SMP Wed Feb 12 20:27:51 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=3D1 nm=
i_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty=
0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/x86_=
64-randconfig-c4-0212/wq:for-3.14-fixes/.vmlinuz-84604340d034a074036e86e85c=
4055a1c7ea5529-20140212202932-9-xian branch=3Dwq/for-3.14-fixes BOOT_IMAGE=
=3D/kernel/x86_64-randconfig-c4-0212/84604340d034a074036e86e85c4055a1c7ea55=
29/vmlinuz-3.14.0-rc1-00001-g8460434
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
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
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x03191000, 0x03191fff] PGTABLE
[    0.000000] BRK [0x03192000, 0x03192fff] PGTABLE
[    0.000000] BRK [0x03193000, 0x03193fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 4k
[    0.000000] BRK [0x03194000, 0x03194fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 4k
[    0.000000] BRK [0x03195000, 0x03195fff] PGTABLE
[    0.000000] BRK [0x03196000, 0x03196fff] PGTABLE
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
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0fffa000-0x0fffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fff9001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000da0000=
0-ffff88000ddfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA32 zone: 1024 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 65436 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 473 pages/cpu @ffff88000e200000 s1914960 r0=
 d22448 u2097152
[    0.000000] pcpu-alloc: s1914960 r0 d22448 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fff9001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr e20cb80
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 64391
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/x86_64-randconfig-c4-0212/wq:for-3.14-fixes/.vmlinuz-84604340d034a074036=
e86e85c4055a1c7ea5529-20140212202932-9-xian branch=3Dwq/for-3.14-fixes BOOT=
_IMAGE=3D/kernel/x86_64-randconfig-c4-0212/84604340d034a074036e86e85c4055a1=
c7ea5529/vmlinuz-3.14.0-rc1-00001-g8460434
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Memory: 195240K/261744K available (9482K kernel code, 5601K =
rwdata, 5956K rodata, 2816K init, 9544K bss, 66504K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc1-00001-g8460434 (kbuild@cairo) (gcc =
version 4.8.1 (Debian 4.8.1-8) ) #27 SMP Wed Feb 12 20:27:51 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=3D1 nm=
i_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty=
0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/x86_=
64-randconfig-c4-0212/wq:for-3.14-fixes/.vmlinuz-84604340d034a074036e86e85c=
4055a1c7ea5529-20140212202932-9-xian branch=3Dwq/for-3.14-fixes BOOT_IMAGE=
=3D/kernel/x86_64-randconfig-c4-0212/84604340d034a074036e86e85c4055a1c7ea55=
29/vmlinuz-3.14.0-rc1-00001-g8460434
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
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
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x03191000, 0x03191fff] PGTABLE
[    0.000000] BRK [0x03192000, 0x03192fff] PGTABLE
[    0.000000] BRK [0x03193000, 0x03193fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 4k
[    0.000000] BRK [0x03194000, 0x03194fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 4k
[    0.000000] BRK [0x03195000, 0x03195fff] PGTABLE
[    0.000000] BRK [0x03196000, 0x03196fff] PGTABLE
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
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0fffa000-0x0fffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fff9001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000da0000=
0-ffff88000ddfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA32 zone: 1024 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 65436 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 473 pages/cpu @ffff88000e200000 s1914960 r0=
 d22448 u2097152
[    0.000000] pcpu-alloc: s1914960 r0 d22448 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fff9001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr e20cb80
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 64391
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/x86_64-randconfig-c4-0212/wq:for-3.14-fixes/.vmlinuz-84604340d034a074036=
e86e85c4055a1c7ea5529-20140212202932-9-xian branch=3Dwq/for-3.14-fixes BOOT=
_IMAGE=3D/kernel/x86_64-randconfig-c4-0212/84604340d034a074036e86e85c4055a1=
c7ea5529/vmlinuz-3.14.0-rc1-00001-g8460434
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Memory: 195240K/261744K available (9482K kernel code, 5601K =
rwdata, 5956K rodata, 2816K init, 9544K bss, 66504K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
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
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  A-B-B-A deadlock:
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-B-C-C-A deadlock:
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-C-A-B-C deadlock:
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-B-C-C-D-D-A deadlock:
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-D-D-A deadlock:
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-C-D-A deadlock:
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                     double unlock:
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                   initialize held:
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  bad unlock order:
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:
[    0.000000]               recursive read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]            recursive read-lock #2:
[    0.000000]            recursive read-lock #2:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed read-write-lock:
[    0.000000]             mixed read-write-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed write-read-lock:
[    0.000000]             mixed write-read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/12:
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      hard-irqs-on + irq-safe-A/21:
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/21:
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/12:
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/21:
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/12:
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/12:
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/21:
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/21:
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/123:
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/123:
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/132:
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/132:
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/213:
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/213:
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/231:
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/231:
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/312:
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/312:
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/321:
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/321:
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/123:
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/123:
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/132:
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/132:
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/213:
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/213:
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/231:
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/231:
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/312:
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/312:
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/321:
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/321:
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/123:
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/123:
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/132:
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/132:
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/213:
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/213:
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/231:
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/231:
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/312:
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/312:
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/321:
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/321:
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/123:
[    0.000000]       hard-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/123:
[    0.000000]       soft-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/132:
[    0.000000]       hard-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/132:
[    0.000000]       soft-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/213:
[    0.000000]       hard-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/213:
[    0.000000]       soft-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/231:
[    0.000000]       hard-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/231:
[    0.000000]       soft-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/312:
[    0.000000]       hard-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/312:
[    0.000000]       soft-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/321:
[    0.000000]       hard-irq read-recursion/321:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/321:
[    0.000000]       soft-irq read-recursion/321:  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                ww contexts mixing:
[    0.000000]                ww contexts mixing:  ok  |  ok  |  ok  |  ok =
 |

[    0.000000]              finishing ww context:
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                locking mismatches:
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                  EDEADLK handling:
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]            spinlock nest unlocked:
[    0.000000]            spinlock nest unlocked:  ok  |  ok  |

[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:
[    0.000000]                           context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                               try:
[    0.000000]                               try:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                             block:
[    0.000000]                             block:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                          spinlock:
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000] -------------------------------------------------------
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ---------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2893.048 MHz processor
[    0.000000] tsc: Detected 2893.048 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value..=20
[    0.003000] Calibrating delay loop (skipped) preset value.. 5786.09 Bogo=
MIPS (lpj=3D2893048)
5786.09 BogoMIPS (lpj=3D2893048)
[    0.004029] pid_max: default: 32768 minimum: 301
[    0.004029] pid_max: default: 32768 minimum: 301
[    0.009326] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.009326] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.011278] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.011278] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.013076] Mount-cache hash table entries: 256
[    0.013076] Mount-cache hash table entries: 256
[    0.016749] Initializing cgroup subsys devices
[    0.016749] Initializing cgroup subsys devices
[    0.017127] Initializing cgroup subsys net_cls
[    0.017127] Initializing cgroup subsys net_cls
[    0.018090] Initializing cgroup subsys perf_event
[    0.018090] Initializing cgroup subsys perf_event
[    0.019438] numa_add_cpu cpu 0 node 0: mask now 0
[    0.019438] numa_add_cpu cpu 0 node 0: mask now 0
[    0.021045] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.021045] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.021045] tlb_flushall_shift: 6
[    0.021045] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.021045] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.021045] tlb_flushall_shift: 6
[    0.022110] debug: unmapping init [mem 0xffffffff8283a000-0xffffffff8283=
efff]
[    0.022110] debug: unmapping init [mem 0xffffffff8283a000-0xffffffff8283=
efff]
[    0.036304] Getting VERSION: 50014
[    0.036304] Getting VERSION: 50014
[    0.039027] Getting VERSION: 50014
[    0.039027] Getting VERSION: 50014
[    0.040032] Getting ID: 0
[    0.040032] Getting ID: 0
[    0.041030] Getting ID: ff000000
[    0.041030] Getting ID: ff000000
[    0.042038] Getting LVT0: 8700
[    0.042038] Getting LVT0: 8700
[    0.043028] Getting LVT1: 8400
[    0.043028] Getting LVT1: 8400
[    0.045100] enabled ExtINT on CPU#0
[    0.045100] enabled ExtINT on CPU#0
[    0.049423] ENABLING IO-APIC IRQs
[    0.049423] ENABLING IO-APIC IRQs
[    0.050035] init IO_APIC IRQs
[    0.050035] init IO_APIC IRQs
[    0.051025]  apic 0 pin 0 not connected
[    0.051025]  apic 0 pin 0 not connected
[    0.053086] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.053086] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.054083] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.054083] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.055065] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.055065] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.056083] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.056083] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.057073] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.057073] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.058088] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.058088] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.059079] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.059079] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.060079] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.060079] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.061081] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.061081] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.062078] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.062078] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.063075] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.063075] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.065071] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.065071] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.066078] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.066078] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.067079] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.067079] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.068073] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.068073] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.069065]  apic 0 pin 16 not connected
[    0.069065]  apic 0 pin 16 not connected
[    0.070022]  apic 0 pin 17 not connected
[    0.070022]  apic 0 pin 17 not connected
[    0.071027]  apic 0 pin 18 not connected
[    0.071027]  apic 0 pin 18 not connected
[    0.072017]  apic 0 pin 19 not connected
[    0.072017]  apic 0 pin 19 not connected
[    0.073018]  apic 0 pin 20 not connected
[    0.073018]  apic 0 pin 20 not connected
[    0.074026]  apic 0 pin 21 not connected
[    0.074026]  apic 0 pin 21 not connected
[    0.075025]  apic 0 pin 22 not connected
[    0.075025]  apic 0 pin 22 not connected
[    0.076015]  apic 0 pin 23 not connected
[    0.076015]  apic 0 pin 23 not connected
[    0.077190] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.077190] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.078026] smpboot: CPU0:=20
[    0.078026] smpboot: CPU0: Intel Intel Common KVM processorCommon KVM pr=
ocessor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.081012] Using local APIC timer interrupts.
[    0.081012] calibrating APIC timer ...
[    0.081012] Using local APIC timer interrupts.
[    0.081012] calibrating APIC timer ...
[    0.083000] ... lapic delta =3D 12496580
[    0.083000] ... lapic delta =3D 12496580
[    0.083000] ... PM-Timer delta =3D 715734
[    0.083000] ... PM-Timer delta =3D 715734
[    0.083000] APIC calibration not consistent with PM-Timer: 199ms instead=
 of 100ms
[    0.083000] APIC calibration not consistent with PM-Timer: 199ms instead=
 of 100ms
[    0.083000] APIC delta adjusted to PM-Timer: 6249809 (12496580)
[    0.083000] APIC delta adjusted to PM-Timer: 6249809 (12496580)
[    0.083000] TSC delta adjusted to PM-Timer: 289278474 (578416332)
[    0.083000] TSC delta adjusted to PM-Timer: 289278474 (578416332)
[    0.083000] ..... delta 6249809
[    0.083000] ..... delta 6249809
[    0.083000] ..... mult: 268427252
[    0.083000] ..... mult: 268427252
[    0.083000] ..... calibration result: 999969
[    0.083000] ..... calibration result: 999969
[    0.083000] ..... CPU clock speed is 2892.0784 MHz.
[    0.083000] ..... CPU clock speed is 2892.0784 MHz.
[    0.083000] ..... host bus clock speed is 999.0969 MHz.
[    0.083000] ..... host bus clock speed is 999.0969 MHz.
[    0.083126] Performance Events:=20
[    0.083126] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.090486] ftrace: Allocated trace_printk buffers
[    0.090486] ftrace: Allocated trace_printk buffers
[    0.125664] x86: Booting SMP configuration:
[    0.125664] x86: Booting SMP configuration:
[    0.126025] .... node  #0, CPUs: =20
[    0.126025] .... node  #0, CPUs:         #1 #1
[    0.107634] kvm-clock: cpu 1, msr 0:fff9041, secondary cpu clock
[    0.107634] masked ExtINT on CPU#1
[    0.107634] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.146334] x86: Booted up 1 node, 2 CPUs
[    0.146334] x86: Booted up 1 node, 2 CPUs
[    0.146225] KVM setup async PF for cpu 1
[    0.146225] KVM setup async PF for cpu 1
[    0.146225] kvm-stealtime: cpu 1, msr e40cb80
[    0.146225] kvm-stealtime: cpu 1, msr e40cb80
[    0.147035] ----------------
[    0.147035] ----------------
[    0.148007] | NMI testsuite:
[    0.148007] | NMI testsuite:
[    0.149009] --------------------
[    0.149009] --------------------
[    0.150010]   remote IPI:
[    0.150010]   remote IPI:  ok  |  ok  |

[    0.154009]    local IPI:
[    0.154009]    local IPI:  ok  |  ok  |

[    0.158039] --------------------
[    0.158039] --------------------
[    0.159009] Good, all   2 testcases passed! |
[    0.159009] Good, all   2 testcases passed! |
[    0.160014] ---------------------------------
[    0.160014] ---------------------------------
[    0.161016] smpboot: Total of 2 processors activated (11572.19 BogoMIPS)
[    0.161016] smpboot: Total of 2 processors activated (11572.19 BogoMIPS)
[    0.167013] devtmpfs: initialized
[    0.167013] devtmpfs: initialized
[    0.188149] prandom: seed boundary self test passed
[    0.188149] prandom: seed boundary self test passed
[    0.189641] prandom: 100 self tests passed
[    0.189641] prandom: 100 self tests passed
[    0.191018] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.191018] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.195349] regulator-dummy: no parameters
[    0.195349] regulator-dummy: no parameters
[    0.199047] NET: Registered protocol family 16
[    0.199047] NET: Registered protocol family 16
[    0.204890] cpuidle: using governor menu
[    0.204890] cpuidle: using governor menu
[    0.206323] ACPI: bus type PCI registered
[    0.206323] ACPI: bus type PCI registered
[    0.207770] PCI: Using configuration type 1 for base access
[    0.207770] PCI: Using configuration type 1 for base access
[    0.220582] ACPI: Added _OSI(Module Device)
[    0.220582] ACPI: Added _OSI(Module Device)
[    0.221013] ACPI: Added _OSI(Processor Device)
[    0.221013] ACPI: Added _OSI(Processor Device)
[    0.222017] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.222017] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.224010] ACPI: Added _OSI(Processor Aggregator Device)
[    0.224010] ACPI: Added _OSI(Processor Aggregator Device)
[    0.332133] ACPI: Interpreter enabled
[    0.332133] ACPI: Interpreter enabled
[    0.333045] ACPI Exception: AE_NOT_FOUND,=20
[    0.333045] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_]While evaluating Sleep State [\_S1_] (20131218/hwxface-580)
 (20131218/hwxface-580)
[    0.336055] ACPI Exception: AE_NOT_FOUND,=20
[    0.336055] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_]While evaluating Sleep State [\_S2_] (20131218/hwxface-580)
 (20131218/hwxface-580)
[    0.339133] ACPI: (supports S0 S3 S5)
[    0.339133] ACPI: (supports S0 S3 S5)
[    0.340011] ACPI: Using IOAPIC for interrupt routing
[    0.340011] ACPI: Using IOAPIC for interrupt routing
[    0.341136] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.341136] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.426811] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.426811] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.427038] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.427038] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.428148] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.428148] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.435282] PCI host bridge to bus 0000:00
[    0.435282] PCI host bridge to bus 0000:00
[    0.436052] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.436052] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.437020] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.437020] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.438018] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.438018] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.439023] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.439023] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.440024] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.440024] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.441156] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.441156] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.445120] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.445120] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.450395] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.450395] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.458335] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.458335] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.463484] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.463484] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.465351] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.465351] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.466044] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.466044] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.469309] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.469309] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.472075] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.472075] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.475080] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.475080] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.488083] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.488083] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.495225] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.495225] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.498021] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.498021] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.503026] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.503026] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.515019] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.515019] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.518403] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.518403] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.522020] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.522020] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.526017] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.526017] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.539241] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.539241] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.544023] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.544023] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.547018] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.547018] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.563068] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.563068] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.568022] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.568022] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.573023] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.573023] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.589320] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.589320] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.593020] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.593020] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.596022] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.596022] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.612205] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.612205] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.616020] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.616020] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.620018] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.620018] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.633089] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.633089] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.636024] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.636024] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.639018] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.639018] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.649547] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.649547] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.651382] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.651382] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.671193] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.671193] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.676223] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.676223] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.681040] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.681040] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.686311] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.686311] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.690084] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.690084] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.701303] ACPI:=20
[    0.701303] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    0.710201] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.710201] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.711035] vgaarb: loaded
[    0.711035] vgaarb: loaded
[    0.712011] vgaarb: bridge control possible 0000:00:02.0
[    0.712011] vgaarb: bridge control possible 0000:00:02.0
[    0.719069] pps_core: LinuxPPS API ver. 1 registered
[    0.719069] pps_core: LinuxPPS API ver. 1 registered
[    0.720017] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.720017] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.722053] PTP clock support registered
[    0.722053] PTP clock support registered
[    0.723224] EDAC MC: Ver: 3.0.0
[    0.723224] EDAC MC: Ver: 3.0.0
[    0.730788] Advanced Linux Sound Architecture Driver Initialized.
[    0.730788] Advanced Linux Sound Architecture Driver Initialized.
[    0.731018] PCI: Using ACPI for IRQ routing
[    0.731018] PCI: Using ACPI for IRQ routing
[    0.732032] PCI: pci_cache_line_size set to 64 bytes
[    0.732032] PCI: pci_cache_line_size set to 64 bytes
[    0.734194] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.734194] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.735048] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.735048] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.739353] NET: Registered protocol family 8
[    0.739353] NET: Registered protocol family 8
[    0.740019] NET: Registered protocol family 20
[    0.740019] NET: Registered protocol family 20
[    0.742038] nfc: nfc_init: NFC Core ver 0.1
[    0.742038] nfc: nfc_init: NFC Core ver 0.1
[    0.743249] NET: Registered protocol family 39
[    0.743249] NET: Registered protocol family 39
[    0.752116] Switched to clocksource kvm-clock
[    0.752116] Switched to clocksource kvm-clock
[    0.760879] Warning: could not register all branches stats
[    0.760879] Warning: could not register all branches stats
[    0.762621] Warning: could not register annotated branches stats
[    0.762621] Warning: could not register annotated branches stats
[    1.219734] FS-Cache: Loaded
[    1.219734] FS-Cache: Loaded
[    1.221651] pnp: PnP ACPI init
[    1.221651] pnp: PnP ACPI init
[    1.222603] ACPI: bus type PNP registered
[    1.222603] ACPI: bus type PNP registered
[    1.229237] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    1.229237] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    1.237108] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.237108] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.245166] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    1.245166] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    1.249964] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.249964] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.263049] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    1.263049] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    1.266166] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.266166] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.289654] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    1.289654] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    1.300335] pnp 00:03: [dma 2]
[    1.300335] pnp 00:03: [dma 2]
[    1.301601] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.301601] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.311723] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    1.311723] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    1.319228] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.319228] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.340116] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    1.340116] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    1.350964] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.350964] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.358157] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.358157] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.366402] pnp: PnP ACPI: found 7 devices
[    1.366402] pnp: PnP ACPI: found 7 devices
[    1.374861] ACPI: bus type PNP unregistered
[    1.374861] ACPI: bus type PNP unregistered
[    1.400779] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.400779] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.402406] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.402406] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.412148] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.412148] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.413833] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.413833] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.428206] NET: Registered protocol family 2
[    1.428206] NET: Registered protocol family 2
[    1.464251] TCP established hash table entries: 2048 (order: 2, 16384 by=
tes)
[    1.464251] TCP established hash table entries: 2048 (order: 2, 16384 by=
tes)
[    1.472405] TCP bind hash table entries: 2048 (order: 5, 163840 bytes)
[    1.472405] TCP bind hash table entries: 2048 (order: 5, 163840 bytes)
[    1.478153] TCP: Hash tables configured (established 2048 bind 2048)
[    1.478153] TCP: Hash tables configured (established 2048 bind 2048)
[    1.485055] TCP: reno registered
[    1.485055] TCP: reno registered
[    1.485968] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    1.485968] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    1.495787] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    1.495787] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    1.504850] NET: Registered protocol family 1
[    1.504850] NET: Registered protocol family 1
[    1.506042] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.506042] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.512938] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.512938] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.519802] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.519802] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.522316] pci 0000:00:02.0: Boot video device
[    1.522316] pci 0000:00:02.0: Boot video device
[    1.528975] PCI: CLS 0 bytes, default 64
[    1.528975] PCI: CLS 0 bytes, default 64
[    1.536912] Unpacking initramfs...
[    1.536912] Unpacking initramfs...
[   11.073711] debug: unmapping init [mem 0xffff88000e93d000-0xffff88000ffe=
ffff]
[   11.073711] debug: unmapping init [mem 0xffff88000e93d000-0xffff88000ffe=
ffff]
[   11.082494] has_svm: not amd
[   11.082494] has_svm: not amd
[   11.083267] kvm: no hardware support
[   11.083267] kvm: no hardware support
[   11.091113] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[   11.091113] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[   11.118045] microcode: CPU1 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[   11.118045] microcode: CPU1 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[   11.119919] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[   11.119919] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[   11.127841] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[   11.127841] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[   11.138510] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[   11.138510] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[   11.178207] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[   11.178207] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[   11.220527] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[   11.220527] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[   11.223343] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[   11.223343] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[   11.233260] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[   11.233260] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[   11.239743] AVX or AES-NI instructions are not detected.
[   11.239743] AVX or AES-NI instructions are not detected.
[   11.243033] AVX instructions are not detected.
[   11.243033] AVX instructions are not detected.
[   11.247840] AVX instructions are not detected.
[   11.247840] AVX instructions are not detected.
[   11.253302] AVX instructions are not detected.
[   11.253302] AVX instructions are not detected.
[   11.264395] AVX2 instructions are not detected.
[   11.264395] AVX2 instructions are not detected.
[   11.276470] Initializing RT-Tester: OK
[   11.276470] Initializing RT-Tester: OK
[   11.284127] futex hash table entries: 512 (order: 4, 65536 bytes)
[   11.284127] futex hash table entries: 512 (order: 4, 65536 bytes)
[   11.360407] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   11.360407] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   11.384281] fuse init (API version 7.22)
[   11.384281] fuse init (API version 7.22)
[   12.116867] tsc: Refined TSC clocksource calibration: 2892.674 MHz
[   12.116867] tsc: Refined TSC clocksource calibration: 2892.674 MHz
[   20.591069] alg: No test for crc32 (crc32-table)
[   20.591069] alg: No test for crc32 (crc32-table)
[   20.606951] alg: No test for lz4 (lz4-generic)
[   20.606951] alg: No test for lz4 (lz4-generic)
[   20.608578] alg: No test for stdrng (krng)
[   20.608578] alg: No test for stdrng (krng)
[   20.668514] NET: Registered protocol family 38
[   20.668514] NET: Registered protocol family 38
[   20.669902] Key type asymmetric registered
[   20.669902] Key type asymmetric registered
[   20.683329] Asymmetric key parser 'x509' registered
[   20.683329] Asymmetric key parser 'x509' registered
[   20.721073] list_sort_test: start testing list_sort()
[   20.721073] list_sort_test: start testing list_sort()
[   20.739371] no IO addresses supplied
[   20.739371] no IO addresses supplied
[   20.752806] hgafb: HGA card not detected.
[   20.752806] hgafb: HGA card not detected.
[   20.753951] hgafb: probe of hgafb.0 failed with error -22
[   20.753951] hgafb: probe of hgafb.0 failed with error -22
[   20.767011] ipmi message handler version 39.2
[   20.767011] ipmi message handler version 39.2
[   20.768355] ipmi device interface
[   20.768355] ipmi device interface
[   20.769765] IPMI System Interface driver.
[   20.769765] IPMI System Interface driver.
[   20.788313] ipmi_si: Adding default-specified kcs state machine
[   20.788313] ipmi_si: Adding default-specified kcs state machine

[   20.790050] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[   20.790050] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[   20.805086] ipmi_si: Interface detection failed
[   20.805086] ipmi_si: Interface detection failed
[   20.833639] ipmi_si: Adding default-specified smic state machine
[   20.833639] ipmi_si: Adding default-specified smic state machine

[   20.844547] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[   20.844547] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[   20.847585] ipmi_si: Interface detection failed
[   20.847585] ipmi_si: Interface detection failed
[   20.873614] ipmi_si: Adding default-specified bt state machine
[   20.873614] ipmi_si: Adding default-specified bt state machine

[   20.875187] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[   20.875187] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[   20.886095] ipmi_si: Interface detection failed
[   20.886095] ipmi_si: Interface detection failed
[   20.915788] ipmi_si: Unable to find any System Interface(s)
[   20.915788] ipmi_si: Unable to find any System Interface(s)
[   20.917842] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   20.917842] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   20.928156] ACPI: Power Button [PWRF]
[   20.928156] ACPI: Power Button [PWRF]
[   21.304682] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   21.304682] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   21.356136] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[   21.356136] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[   21.367933] Non-volatile memory driver v1.3
[   21.367933] Non-volatile memory driver v1.3
[   21.370065] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[   21.370065] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[   21.371691] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[   21.371691] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[   21.377055] Hangcheck: Using getrawmonotonic().
[   21.377055] Hangcheck: Using getrawmonotonic().
[   21.379105] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[   21.379105] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[   21.381553] c2port c2port0: C2 port uc added
[   21.381553] c2port c2port0: C2 port uc added
[   21.382882] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[   21.382882] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[   21.385366] mic_init not running on X100 ret -19
[   21.385366] mic_init not running on X100 ret -19
[   21.398498] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[   21.398498] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[   21.400705] Could not find PAR responsible for SC520CDP Flash Bank #0
[   21.400705] Could not find PAR responsible for SC520CDP Flash Bank #0
[   21.402504] Trying default address 0x8400000
[   21.402504] Trying default address 0x8400000
[   21.403716] Could not find PAR responsible for SC520CDP Flash Bank #1
[   21.403716] Could not find PAR responsible for SC520CDP Flash Bank #1
[   21.405602] Trying default address 0x8c00000
[   21.405602] Trying default address 0x8c00000
[   21.409000] Could not find PAR responsible for SC520CDP DIL Flash
[   21.409000] Could not find PAR responsible for SC520CDP DIL Flash
[   21.410704] Trying default address 0x9400000
[   21.410704] Trying default address 0x9400000
[   21.412125] SC520 CDP flash device: 0x800000 at 0x8400000
[   21.412125] SC520 CDP flash device: 0x800000 at 0x8400000
[   21.413781] Failed to ioremap_nocache
[   21.413781] Failed to ioremap_nocache
[   21.414891] Failed to ioremap_nocache
[   21.414891] Failed to ioremap_nocache
[   21.416390] slram: not enough parameters.
[   21.416390] slram: not enough parameters.
[   21.434071] No valid DiskOnChip devices found
[   21.434071] No valid DiskOnChip devices found
[   21.438058] libphy: Fixed MDIO Bus: probed
[   21.438058] libphy: Fixed MDIO Bus: probed
[   21.439546] vcan: Virtual CAN interface driver
[   21.439546] vcan: Virtual CAN interface driver
[   21.442861] CAN device driver interface
[   21.442861] CAN device driver interface
[   21.444070] sja1000 CAN netdevice driver
[   21.444070] sja1000 CAN netdevice driver
[   21.445182] sja1000_isa: insufficient parameters supplied
[   21.445182] sja1000_isa: insufficient parameters supplied
[   21.446755] cc770: CAN netdevice driver
[   21.446755] cc770: CAN netdevice driver
[   21.448405] YAM driver version 0.8 by F1OAT/F6FBB
[   21.448405] YAM driver version 0.8 by F1OAT/F6FBB
[   21.450503] AX.25: bpqether driver version 004
[   21.450503] AX.25: bpqether driver version 004
[   21.452147] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   21.452147] baycom_ser_fdx: version 0.10
[   21.452147] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   21.452147] baycom_ser_fdx: version 0.10
[   21.456519] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[   21.456519] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[   21.458066] hdlcdrv: version 0.8
[   21.458066] hdlcdrv: version 0.8
[   21.458926] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   21.458926] baycom_ser_hdx: version 0.10
[   21.458926] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   21.458926] baycom_ser_hdx: version 0.10
[   21.470362] PPP generic driver version 2.4.2
[   21.470362] PPP generic driver version 2.4.2
[   21.472331] PPP BSD Compression module registered
[   21.472331] PPP BSD Compression module registered
[   21.473621] NET: Registered protocol family 24
[   21.473621] NET: Registered protocol family 24
[   21.474900] adummy: version 1.0
[   21.474900] adummy: version 1.0
[   21.476378] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   21.476378] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   21.506070] serio: i8042 KBD port at 0x60,0x64 irq 1
[   21.506070] serio: i8042 KBD port at 0x60,0x64 irq 1
[   21.507612] serio: i8042 AUX port at 0x60,0x64 irq 12
[   21.507612] serio: i8042 AUX port at 0x60,0x64 irq 12
[   21.516152] mousedev: PS/2 mouse device common for all mice
[   21.516152] mousedev: PS/2 mouse device common for all mice
[   21.536532] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   21.536532] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   21.547357] rtc-test rtc-test.0: rtc core: registered test as rtc0
[   21.547357] rtc-test rtc-test.0: rtc core: registered test as rtc0
[   21.549526] rtc-test rtc-test.1: rtc core: registered test as rtc1
[   21.549526] rtc-test rtc-test.1: rtc core: registered test as rtc1
[   21.551693] i2c-parport-light: adapter type unspecified
[   21.551693] i2c-parport-light: adapter type unspecified
[   21.553317] smssdio: Siano SMS1xxx SDIO driver
[   21.553317] smssdio: Siano SMS1xxx SDIO driver
[   21.554841] smssdio: Copyright Pierre Ossman
[   21.554841] smssdio: Copyright Pierre Ossman
[   21.574860] pps pps0: new PPS source ktimer
[   21.574860] pps pps0: new PPS source ktimer
[   21.576199] pps pps0: ktimer PPS source registered
[   21.576199] pps pps0: ktimer PPS source registered
[   21.577722] Driver for 1-wire Dallas network protocol.
[   21.577722] Driver for 1-wire Dallas network protocol.
[   21.583716] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[   21.583716] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[   21.585630] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[   21.585630] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[   21.609126] pc87360: PC8736x not detected, module not inserted
[   21.609126] pc87360: PC8736x not detected, module not inserted
[   21.626774] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[   21.626774] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[   21.629183] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[   21.629183] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[   21.636854] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D1)
[   21.636854] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D1)
[   21.639057] sc520_wdt: cannot register miscdev on minor=3D130 (err=3D-16)
[   21.639057] sc520_wdt: cannot register miscdev on minor=3D130 (err=3D-16)
[   21.663425] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[   21.663425] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[   21.666170] ib700wdt: START method I/O 443 is not available
[   21.666170] ib700wdt: START method I/O 443 is not available
[   21.667914] ib700wdt: probe of ib700wdt failed with error -5
[   21.667914] ib700wdt: probe of ib700wdt failed with error -5
[   21.669960] it87_wdt: no device
[   21.669960] it87_wdt: no device
[   21.671109] sc1200wdt: build 20020303
[   21.671109] sc1200wdt: build 20020303
[   21.672421] sc1200wdt: io parameter must be specified
[   21.672421] sc1200wdt: io parameter must be specified
[   21.674070] pc87413_wdt: Version 1.1 at io 0x2E
[   21.674070] pc87413_wdt: Version 1.1 at io 0x2E
[   21.688608] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[   21.688608] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[   21.691010] sbc60xxwdt: I/O address 0x0443 already in use
[   21.691010] sbc60xxwdt: I/O address 0x0443 already in use
[   21.693002] sbc8360: failed to register misc device
[   21.693002] sbc8360: failed to register misc device
[   21.694520] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[   21.694520] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[   21.709897] smsc37b787_wdt: Unable to register miscdev on minor 130
[   21.709897] smsc37b787_wdt: Unable to register miscdev on minor 130
[   21.711947] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[   21.711947] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[   21.714097] w83697hf_wdt: watchdog not found at address 0x2e
[   21.714097] w83697hf_wdt: watchdog not found at address 0x2e
[   21.728270] w83697hf_wdt: No W83697HF/HG could be found
[   21.728270] w83697hf_wdt: No W83697HF/HG could be found
[   21.729971] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[   21.729971] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[   21.733130] w83697ug_wdt: No W83697UG/UF could be found
[   21.733130] w83697ug_wdt: No W83697UG/UF could be found
[   21.734746] w83877f_wdt: I/O address 0x0443 already in use
[   21.734746] w83877f_wdt: I/O address 0x0443 already in use
[   21.748609] machzwd: MachZ ZF-Logic Watchdog driver initializing
[   21.748609] machzwd: MachZ ZF-Logic Watchdog driver initializing
[   21.750553] machzwd: no ZF-Logic found
[   21.750553] machzwd: no ZF-Logic found
[   21.752408] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[   21.752408] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[   21.754892] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[   21.754892] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[   21.769074] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D1)
[   21.769074] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D1)
[   21.775726] sdhci: Secure Digital Host Controller Interface driver
[   21.775726] sdhci: Secure Digital Host Controller Interface driver
[   21.790602] sdhci: Copyright(c) Pierre Ossman
[   21.790602] sdhci: Copyright(c) Pierre Ossman
[   21.792253] sdhci-pltfm: SDHCI platform and OF driver helper
[   21.792253] sdhci-pltfm: SDHCI platform and OF driver helper
[   21.795679] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[   21.795679] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[   21.828891] NET: Registered protocol family 26
[   21.828891] NET: Registered protocol family 26
[   21.830352] Netfilter messages via NETLINK v0.30.
[   21.830352] Netfilter messages via NETLINK v0.30.
[   21.831883] nfnl_acct: registering with nfnetlink.
[   21.831883] nfnl_acct: registering with nfnetlink.
[   21.839081] xt_time: kernel timezone is -0000
[   21.839081] xt_time: kernel timezone is -0000
[   21.840380] IPVS: Registered protocols (TCP, UDP, ESP)
[   21.840380] IPVS: Registered protocols (TCP, UDP, ESP)
[   21.842251] IPVS: Connection hash table configured (size=3D4096, memory=
=3D64Kbytes)
[   21.842251] IPVS: Connection hash table configured (size=3D4096, memory=
=3D64Kbytes)
[   21.844550] IPVS: Each connection entry needs 416 bytes at least
[   21.844550] IPVS: Each connection entry needs 416 bytes at least
[   21.852827] IPVS: Creating netns size=3D2120 id=3D0
[   21.852827] IPVS: Creating netns size=3D2120 id=3D0
[   21.854354] IPVS: ipvs loaded.
[   21.854354] IPVS: ipvs loaded.
[   21.855234] IPVS: [rr] scheduler registered.
[   21.855234] IPVS: [rr] scheduler registered.
[   21.856649] IPVS: [wlc] scheduler registered.
[   21.856649] IPVS: [wlc] scheduler registered.
[   21.857884] IPVS: [lblc] scheduler registered.
[   21.857884] IPVS: [lblc] scheduler registered.
[   21.859334] IPVS: [sh] scheduler registered.
[   21.859334] IPVS: [sh] scheduler registered.
[   21.860775] IPVS: [nq] scheduler registered.
[   21.860775] IPVS: [nq] scheduler registered.
[   21.862148] ipip: IPv4 over IPv4 tunneling driver
[   21.862148] ipip: IPv4 over IPv4 tunneling driver
[   21.864147] IPv4 over IPSec tunneling driver
[   21.864147] IPv4 over IPSec tunneling driver
[   21.869284] TCP: cubic registered
[   21.869284] TCP: cubic registered
[   21.870244] NET: Registered protocol family 17
[   21.870244] NET: Registered protocol family 17
[   21.892328] NET: Registered protocol family 15
[   21.892328] NET: Registered protocol family 15
[   21.896378] Bridge firewalling registered
[   21.896378] Bridge firewalling registered
[   21.897602] Ebtables v2.0 registered
[   21.897602] Ebtables v2.0 registered
[   21.899550] NET: Registered protocol family 4
[   21.899550] NET: Registered protocol family 4
[   21.900948] NET: Registered protocol family 5
[   21.900948] NET: Registered protocol family 5
[   21.902388] NET: Registered protocol family 9
[   21.902388] NET: Registered protocol family 9
[   21.903718] X25: Linux Version 0.2
[   21.903718] X25: Linux Version 0.2
[   21.908290] NET: Registered protocol family 3
[   21.908290] NET: Registered protocol family 3
[   21.909741] can: controller area network core (rev 20120528 abi 9)
[   21.909741] can: controller area network core (rev 20120528 abi 9)
[   21.911853] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
[   21.911853] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
[   21.914041] NET: Registered protocol family 29
[   21.914041] NET: Registered protocol family 29
[   21.918588] can: raw protocol (rev 20120528)
[   21.918588] can: raw protocol (rev 20120528)
[   21.920079] can: netlink gateway (rev 20130117) max_hops=3D1
[   21.920079] can: netlink gateway (rev 20130117) max_hops=3D1
[   21.942457] NET: Registered protocol family 33
[   21.942457] NET: Registered protocol family 33
[   21.943870] Key type rxrpc registered
[   21.943870] Key type rxrpc registered
[   21.945029] Key type rxrpc_s registered
[   21.945029] Key type rxrpc_s registered
[   21.946479] lec:lane_module_init: lec.c: initialized
[   21.946479] lec:lane_module_init: lec.c: initialized
[   21.948157] mpoa:atm_mpoa_init: mpc.c: initialized
[   21.948157] mpoa:atm_mpoa_init: mpc.c: initialized
[   21.949648] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[   21.949648] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[   21.956978] DECnet: Routing cache hash table of 64 buckets, 5Kbytes
[   21.956978] DECnet: Routing cache hash table of 64 buckets, 5Kbytes
[   21.958948] NET: Registered protocol family 12
[   21.958948] NET: Registered protocol family 12
[   21.960479] 8021q: 802.1Q VLAN Support v1.8
[   21.960479] 8021q: 802.1Q VLAN Support v1.8
[   21.967405] DCCP: Activated CCID 2 (TCP-like)
[   21.967405] DCCP: Activated CCID 2 (TCP-like)
[   21.989145] rds_page_remainder_cpu_notify(): cpu 0 action 0x7
[   21.989145] rds_page_remainder_cpu_notify(): cpu 0 action 0x7
[   21.990793] rds_page_remainder_cpu_notify(): cpu 1 action 0x7
[   21.990793] rds_page_remainder_cpu_notify(): cpu 1 action 0x7
[   21.995278] BUG: unable to handle kernel=20
[   21.995278] BUG: unable to handle kernel paging requestpaging request at=
 ffff880000798f60
 at ffff880000798f60
[   21.996025] IP:
[   21.996025] IP: [<ffffffff813534f2>] strcmp+0x6/0x55
 [<ffffffff813534f2>] strcmp+0x6/0x55
[   21.996025] PGD 3191067=20
[   21.996025] PGD 3191067 PUD 3192067 PUD 3192067 PMD e7ec067 PMD e7ec067 =
PTE 8000000000798060PTE 8000000000798060

[   21.996025] Oops: 0000 [#1]=20
[   21.996025] Oops: 0000 [#1] SMP SMP DEBUG_PAGEALLOCDEBUG_PAGEALLOC

[   21.996025] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc1-00001-g=
8460434 #27
[   21.996025] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc1-00001-g=
8460434 #27
[   21.996025] task: ffff88000d190010 ti: ffff88000d192000 task.ti: ffff880=
00d192000
[   21.996025] task: ffff88000d190010 ti: ffff88000d192000 task.ti: ffff880=
00d192000
[   21.996025] RIP: 0010:[<ffffffff813534f2>]=20
[   21.996025] RIP: 0010:[<ffffffff813534f2>]  [<ffffffff813534f2>] strcmp+=
0x6/0x55
 [<ffffffff813534f2>] strcmp+0x6/0x55
[   21.996025] RSP: 0000:ffff88000d193cd8  EFLAGS: 00010046
[   21.996025] RSP: 0000:ffff88000d193cd8  EFLAGS: 00010046
[   21.996025] RAX: 0000000000000000 RBX: ffffffff82c8cfd0 RCX: 00000000000=
00074
[   21.996025] RAX: 0000000000000000 RBX: ffffffff82c8cfd0 RCX: 00000000000=
00074
[   21.996025] RDX: 0000000000000000 RSI: ffffffff81fb6ca0 RDI: ffff8800007=
98f60
[   21.996025] RDX: 0000000000000000 RSI: ffffffff81fb6ca0 RDI: ffff8800007=
98f60
[   21.996025] RBP: ffff88000d193cd8 R08: ffffffff82c8d701 R09: 00000000000=
00003
[   21.996025] RBP: ffff88000d193cd8 R08: ffffffff82c8d701 R09: 00000000000=
00003
[   21.996025] R10: ffff88000fff7040 R11: 0000000000000246 R12: 00000000000=
00000
[   21.996025] R10: ffff88000fff7040 R11: 0000000000000246 R12: 00000000000=
00000
[   21.996025] R13: ffffffff82c8d790 R14: ffffffff81fb6ca0 R15: ffffffff820=
e4670
[   21.996025] R13: ffffffff82c8d790 R14: ffffffff81fb6ca0 R15: ffffffff820=
e4670
[   21.996025] FS:  0000000000000000(0000) GS:ffff88000e400000(0000) knlGS:=
0000000000000000
[   21.996025] FS:  0000000000000000(0000) GS:ffff88000e400000(0000) knlGS:=
0000000000000000
[   21.996025] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   21.996025] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   21.996025] CR2: ffff880000798f60 CR3: 000000000200f000 CR4: 00000000000=
006a0
[   21.996025] CR2: ffff880000798f60 CR3: 000000000200f000 CR4: 00000000000=
006a0
[   21.996025] Stack:
[   21.996025] Stack:
[   21.996025]  ffff88000d193d08
[   21.996025]  ffff88000d193d08 ffffffff8192bf5a ffffffff8192bf5a 00000000=
00000000 0000000000000000 0000000000000002 0000000000000002

[   21.996025]  ffffffff82c8d790
[   21.996025]  ffffffff82c8d790 ffff88000d190010 ffff88000d190010 ffff8800=
0d193dc8 ffff88000d193dc8 ffffffff81181909 ffffffff81181909

[   21.996025]  0000000000008880
[   21.996025]  0000000000008880 ffffffff82c8d7a0 ffffffff82c8d7a0 00000000=
0006cdd0 000000000006cdd0 0000000000000046 0000000000000046

[   21.996025] Call Trace:
[   21.996025] Call Trace:
[   21.996025]  [<ffffffff8192bf5a>] count_matching_names+0x61/0x8e
[   21.996025]  [<ffffffff8192bf5a>] count_matching_names+0x61/0x8e
[   21.996025]  [<ffffffff81181909>] __lock_acquire+0x375/0x1850
[   21.996025]  [<ffffffff81181909>] __lock_acquire+0x375/0x1850
[   21.996025]  [<ffffffff8118041c>] ? trace_hardirqs_on_caller+0x17f/0x19b
[   21.996025]  [<ffffffff8118041c>] ? trace_hardirqs_on_caller+0x17f/0x19b
[   21.996025]  [<ffffffff81180445>] ? trace_hardirqs_on+0xd/0xf
[   21.996025]  [<ffffffff81180445>] ? trace_hardirqs_on+0xd/0xf
[   21.996025]  [<ffffffff811840bb>] lock_acquire+0xd8/0x1bd
[   21.996025]  [<ffffffff811840bb>] lock_acquire+0xd8/0x1bd
[   21.996025]  [<ffffffff8189303a>] ? rds_trans_register+0x53/0xb5
[   21.996025]  [<ffffffff8189303a>] ? rds_trans_register+0x53/0xb5
[   21.996025]  [<ffffffff8193c7fe>] down_write+0x47/0xbf
[   21.996025]  [<ffffffff8193c7fe>] down_write+0x47/0xbf
[   21.996025]  [<ffffffff8189303a>] ? rds_trans_register+0x53/0xb5
[   21.996025]  [<ffffffff8189303a>] ? rds_trans_register+0x53/0xb5
[   21.996025]  [<ffffffff8189303a>] rds_trans_register+0x53/0xb5
[   21.996025]  [<ffffffff8189303a>] rds_trans_register+0x53/0xb5
[   21.996025]  [<ffffffff8189604e>] rds_tcp_init+0x72/0xed
[   21.996025]  [<ffffffff8189604e>] rds_tcp_init+0x72/0xed
[   21.996025]  [<ffffffff81895fdc>] ? rds_tcp_laddr_check+0x34/0x34
[   21.996025]  [<ffffffff81895fdc>] ? rds_tcp_laddr_check+0x34/0x34
[   21.996025]  [<ffffffff8274f209>] do_one_initcall+0x9a/0x1b1
[   21.996025]  [<ffffffff8274f209>] do_one_initcall+0x9a/0x1b1
[   21.996025]  [<ffffffff812da32c>] ? __register_nls+0x35/0x9e
[   21.996025]  [<ffffffff812da32c>] ? __register_nls+0x35/0x9e
[   21.996025]  [<ffffffff82784a98>] ? init_nls_ascii+0x14/0x14
[   21.996025]  [<ffffffff82784a98>] ? init_nls_ascii+0x14/0x14
[   21.996025]  [<ffffffff8274f42b>] kernel_init_freeable+0x10b/0x1c9
[   21.996025]  [<ffffffff8274f42b>] kernel_init_freeable+0x10b/0x1c9
[   21.996025]  [<ffffffff8274e8d5>] ? do_early_param+0xc1/0xc1
[   21.996025]  [<ffffffff8274e8d5>] ? do_early_param+0xc1/0xc1
[   21.996025]  [<ffffffff8191eebe>] ? rest_init+0x162/0x162
[   21.996025]  [<ffffffff8191eebe>] ? rest_init+0x162/0x162
[   21.996025]  [<ffffffff8191eec7>] kernel_init+0x9/0x17e
[   21.996025]  [<ffffffff8191eec7>] kernel_init+0x9/0x17e
[   21.996025]  [<ffffffff8193f44c>] ret_from_fork+0x7c/0xb0
[   21.996025]  [<ffffffff8193f44c>] ret_from_fork+0x7c/0xb0
[   21.996025]  [<ffffffff8191eebe>] ? rest_init+0x162/0x162
[   21.996025]  [<ffffffff8191eebe>] ? rest_init+0x162/0x162
[   21.996025] Code:=20
[   21.996025] Code: 49 49 39 39 d0 d0 40 40 0f 0f 94 94 c7 c7 4c 4c 63 63 =
cf cf 49 49 83 83 c1 c1 02 02 4a 4a ff ff 04 04 cd cd d8 d8 6d 6d 2b 2b 82 =
82 85 85 ff ff 75 75 05 05 4c 4c 89 89 c1 c1 eb eb cb cb c6 c6 41 41 01 01 =
00 00 5d 5d c3 c3 55 55 31 31 c0 c0 48 48 89 89 e5 e5 <8a> <8a> 14 14 07 07=
 8a 8a 0c 0c 06 06 38 38 ca ca 41 41 0f 0f 95 95 c0 c0 4d 4d 89 89 c1 c1 41=
 41 83 83 e1 e1 01 01 49 49 83 83=20

[   21.996025] RIP=20
[   21.996025] RIP  [<ffffffff813534f2>] strcmp+0x6/0x55
 [<ffffffff813534f2>] strcmp+0x6/0x55
[   21.996025]  RSP <ffff88000d193cd8>
[   21.996025]  RSP <ffff88000d193cd8>
[   21.996025] CR2: ffff880000798f60
[   21.996025] CR2: ffff880000798f60
[   21.996025] ---[ end trace 64c1366dadb2917e ]---
[   21.996025] ---[ end trace 64c1366dadb2917e ]---
[   21.996025] Kernel panic - not syncing: Fatal exception
[   21.996025] Kernel panic - not syncing: Fatal exception
[   21.996025] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range=
: 0xffffffff80000000-0xffffffff9fffffff)
[   21.996025] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range=
: 0xffffffff80000000-0xffffffff9fffffff)
[   21.996025] Rebooting in 10 seconds..
[   21.996025] Rebooting in 10 seconds..
Elapsed time: 50
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-c4-0212/84604340d034a074036e86e85c4055a1c7ea5529/vmlinuz-3.14.0-rc1-00001-=
g8460434 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=3D1 nmi_watchdog=
=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dno=
rmal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/x86_64-randcon=
fig-c4-0212/wq:for-3.14-fixes/.vmlinuz-84604340d034a074036e86e85c4055a1c7ea=
5529-20140212202932-9-xian branch=3Dwq/for-3.14-fixes BOOT_IMAGE=3D/kernel/=
x86_64-randconfig-c4-0212/84604340d034a074036e86e85c4055a1c7ea5529/vmlinuz-=
3.14.0-rc1-00001-g8460434'  -initrd /kernel-tests/initrd/quantal-core-x86_6=
4.cgz -m 256M -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1,hos=
tfwd=3Dtcp::11303-:22 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc b=
ase=3Dlocaltime -drive file=3D/fs/LABEL=3DKVM/disk0-quantal-xian-11,media=
=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1-quantal-xian-11,med=
ia=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk2-quantal-xian-11,m=
edia=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-quantal-xian-11=
,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk4-quantal-xian-=
11,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk5-quantal-xia=
n-11,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-quantal-xian-11 -=
serial file:/dev/shm/kboot/serial-quantal-xian-11 -daemonize -display none =
-monitor null=20

--7DO5AaGCk89r4vaK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="x86_64-randconfig-c4-0212-84604340d034a074036e86e85c4055a1c7ea5529-rds_tcp_init+-x-113077.log"

git checkout 38dbfb59d1175ef458d006556061adeaa8751b72
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-c4-0212/wq:for-3.14-fixes:38dbfb59d1175ef458d006556061adeaa8751b72:bisect-net

2014-02-16-08:03:28 38dbfb59d1175ef458d006556061adeaa8751b72 reuse /kernel/x86_64-randconfig-c4-0212/38dbfb59d1175ef458d006556061adeaa8751b72/vmlinuz-3.14.0-rc1

2014-02-16-08:03:28 detecting boot state ..	2	4	11.	12.......	14...	16	17	18..	20	21	22	23...	24	26.	27.	29	30.	34.	36..	42...	43	44	48	49	50	52	53....	54......	55.	56.....	57...	58.	61...	62	63	71	81	91......	92...	93................	94...............	95 SUCCESS

bisect: good commit 38dbfb59d1175ef458d006556061adeaa8751b72
git bisect start 84604340d034a074036e86e85c4055a1c7ea5529 38dbfb59d1175ef458d006556061adeaa8751b72 --
/c/kernel-tests/linear-bisect: ["-b", "84604340d034a074036e86e85c4055a1c7ea5529", "-g", "38dbfb59d1175ef458d006556061adeaa8751b72", "/c/kernel-tests/bisect-test-boot-failure.sh", "/home/wfg/net/obj-bisect"]
84604340d034a074036e86e85c4055a1c7ea5529 is the first bad commit
commit 84604340d034a074036e86e85c4055a1c7ea5529
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue Feb 11 12:00:36 2014 +0100
Commit:     Tejun Heo <tj@kernel.org>
CommitDate: Tue Feb 11 10:25:17 2014 -0500

    workqueue: Fix workqueue lockdep name
    
    Tommi noticed a 'funny' lock class name: "%s#5" from a lock acquired
    in process_one_work(). It turns out that commit b196be89cdc14 forgot
    to change the lockdep_init_map() when it changed the @lock_name
    argument from a string to a format.
    
    Fixes: b196be89cdc14 ("workqueue: make alloc_workqueue() take printf
    fmt and args for name")
    
    Reported-by: Tommi Rantala <tt.rantala@gmail.com>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Signed-off-by: Tejun Heo <tj@kernel.org>
    Cc: stable@vger.kernel.org

 kernel/workqueue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
exit
/c/kernel-tests/linear-bisect:274:in `exit'
/c/kernel-tests/linear-bisect:274:in `linear_bisect'
/c/kernel-tests/linear-bisect:294:in `<main>'
exit
/c/kernel-tests/linear-bisect:274:in `exit'
/c/kernel-tests/linear-bisect:274:in `linear_bisect'
/c/kernel-tests/linear-bisect:294:in `<main>'
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-c4-0212/wq:for-3.14-fixes:38dbfb59d1175ef458d006556061adeaa8751b72:bisect-net

2014-02-16-09:09:29 38dbfb59d1175ef458d006556061adeaa8751b72 reuse /kernel/x86_64-randconfig-c4-0212/38dbfb59d1175ef458d006556061adeaa8751b72/vmlinuz-3.14.0-rc1

2014-02-16-09:09:30 detecting boot state ....	3.	8	10	12	13	18	21............	22	23	26..	27.	30	31	36	37	40.	41....	42.	46.	47	48..	50	52	53..	57.	58....	59.	60..	61.	62.	63.	65.	66	68	69	72	74..	77.	78	80	83	87	93.......	97	101	102	103.	104	105.	107	108	109	113.	114	116	119	121	123	130	131	132	133.	135..	138.	141..	143.	145.	146.	148	149	151	152..	153	154.......	155......	156.......	158.................	159	162	169	175	186	194	206	212....................	214..	216	218	219	221	222	224.............................	225	227	232	236	247	249...	250	251.	255.	256	257...	258	259...	260	263...	264...	265	266....	267..	268..	273	275	278	279	280....	281	282	283......................	284...	285 SUCCESS

ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-c4-0212/wq:for-3.14-fixes:84604340d034a074036e86e85c4055a1c7ea5529:bisect-net
 TEST FAILURE
[   35.542145] rtc-test rtc-test.0: setting system clock to 2014-02-16 00:00:56 UTC (1392508856)
[   35.544393] Unregister pv shared memory for cpu 0
[   35.567190] numa_remove_cpu cpu 0 node 0: mask now 1
[   35.600730] BUG: unable to handle kernel paging request at ffff880006be0f60
[   35.601197] IP: [<ffffffff813534f2>] strcmp+0x6/0x55
[   35.601197] PGD 3191067 PUD 3192067 PMD 127ba067 PTE 8000000006be0060
[   35.601197] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   35.601197] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc1-00001-g8460434 #27
[   35.601197] task: ffff8800111fa010 ti: ffff8800111fc000 task.ti: ffff8800111fc000
[   35.601197] RIP: 0010:[<ffffffff813534f2>]  [<ffffffff813534f2>] strcmp+0x6/0x55
[   35.601197] RSP: 0000:ffff8800111fda88  EFLAGS: 00010046
[   35.601197] RAX: 0000000000000000 RBX: ffffffff82c8cde0 RCX: 0000000000000064
[   35.601197] RDX: 0000000000000000 RSI: ffffffff81f62d7a RDI: ffff880006be0f60
[   35.601197] RBP: ffff8800111fda88 R08: ffffffff82c92301 R09: 0000000000000003
[   35.601197] R10: 0000000000000046 R11: 0000000000000046 R12: 0000000000000000
[   35.601197] R13: ffffffff82c92320 R14: ffffffff81f62d7a R15: ffffffff82085338
[   35.601197] FS:  0000000000000000(0000) GS:ffff880012400000(0000) knlGS:0000000000000000
[   35.601197] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   35.601197] CR2: ffff880006be0f60 CR3: 000000000200f000 CR4: 00000000000006a0
[   35.601197] Stack:
[   35.601197]  ffff8800111fdab8 ffffffff8192bf5a 0000000000000000 0000000000000002
[   35.601197]  ffffffff82c92320 ffff8800111fa010 ffff8800111fdb80 ffffffff81181909
[   35.601197]  000000000000c440 ffffffff82c92330 0000000000071960 0000000000000000
[   35.601197] Call Trace:
[   35.601197]  [<ffffffff8192bf5a>] count_matching_names+0x61/0x8e
[   35.601197]  [<ffffffff81181909>] __lock_acquire+0x375/0x1850
[   35.601197]  [<ffffffff810900b3>] ? pvclock_clocksource_read+0x9b/0x141
[   35.601197]  [<ffffffff811840bb>] lock_acquire+0xd8/0x1bd
[   35.601197]  [<ffffffff8147c06a>] ? dev_pm_qos_constraints_destroy+0x1e/0x143
[   35.601197]  [<ffffffff8147c06a>] ? dev_pm_qos_constraints_destroy+0x1e/0x143
[   35.601197]  [<ffffffff81938c0c>] mutex_lock_nested+0x70/0x5dd
[   35.601197]  [<ffffffff8147c06a>] ? dev_pm_qos_constraints_destroy+0x1e/0x143
[   35.601197]  [<ffffffff8118714f>] ? do_raw_spin_unlock+0xf7/0x131
[   35.601197]  [<ffffffff8147c06a>] dev_pm_qos_constraints_destroy+0x1e/0x143
[   35.601197]  [<ffffffff8147b7c0>] dpm_sysfs_remove+0x9/0xb
[   35.601197]  [<ffffffff81472569>] device_del+0x54/0x209
[   35.601197]  [<ffffffff81472741>] device_unregister+0x23/0x2e
[   35.601197]  [<ffffffff814731d4>] device_destroy+0x49/0x4d
[   35.601197]  [<ffffffff810821dc>] msr_device_destroy+0x18/0x1a
[   35.601197]  [<ffffffff8108220b>] msr_class_cpu_callback+0x2d/0x58
[   35.601197]  [<ffffffff8114a15b>] notifier_call_chain+0x197/0x1f5
[   35.601197]  [<ffffffff8114a60d>] __raw_notifier_call_chain+0x9/0xb
[   35.601197]  [<ffffffff8110f281>] __cpu_notify+0x1b/0x32
[   35.601197]  [<ffffffff8110f2a6>] cpu_notify+0xe/0x10
[   35.601197]  [<ffffffff8110f2b4>] cpu_notify_nofail+0xc/0x39
[   35.601197]  [<ffffffff8191ff4c>] _cpu_down+0x2cb/0x521
[   35.601197]  [<ffffffff8117eb00>] ? lock_release_holdtime.part.9+0xcc/0xd9
[   35.601197]  [<ffffffff81920229>] cpu_down+0x37/0x4b
[   35.601197]  [<ffffffff8191f090>] _debug_hotplug_cpu+0x54/0xee
[   35.601197]  [<ffffffff8275935e>] ? pci_iommu_alloc+0xb0/0xb0
[   35.601197]  [<ffffffff8275936b>] debug_hotplug_cpu+0xd/0x11
[   35.601197]  [<ffffffff8274f209>] do_one_initcall+0x9a/0x1b1
[   35.601197]  [<ffffffff811406ec>] ? parameq+0x1d/0x1f
[   35.601197]  [<ffffffff811409e2>] ? parse_args+0x2f4/0x3cb
[   35.601197]  [<ffffffff8274f42b>] kernel_init_freeable+0x10b/0x1c9
[   35.601197]  [<ffffffff8274e8d5>] ? do_early_param+0xc1/0xc1
[   35.601197]  [<ffffffff8191eebe>] ? rest_init+0x162/0x162
[   35.601197]  [<ffffffff8191eec7>] kernel_init+0x9/0x17e
[   35.601197]  [<ffffffff8193f44c>] ret_from_fork+0x7c/0xb0
[   35.601197]  [<ffffffff8191eebe>] ? rest_init+0x162/0x162
[   35.601197] Code: 49 39 d0 40 0f 94 c7 4c 63 cf 49 83 c1 02 4a ff 04 cd d8 6d 2b 82 85 ff 75 05 4c 89 c1 eb cb c6 41 01 00 5d c3 55 31 c0 48 89 e5 <8a> 14 07 8a 0c 06 38 ca 41 0f 95 c0 4d 89 c1 41 83 e1 01 49 83 
[   35.601197] RIP  [<ffffffff813534f2>] strcmp+0x6/0x55
[   35.601197]  RSP <ffff8800111fda88>
[   35.601197] CR2: ffff880006be0f60
[   35.601197] ---[ end trace 1d1495ec5cf6f812 ]---
[   35.601197] Kernel panic - not syncing: Fatal exception
/kernel/x86_64-randconfig-c4-0212/84604340d034a074036e86e85c4055a1c7ea5529/dmesg-quantal-xian-11:20140212211335:x86_64-randconfig-c4-0212:3.14.0-rc1-00001-g8460434:27
/kernel/x86_64-randconfig-c4-0212/84604340d034a074036e86e85c4055a1c7ea5529/dmesg-yocto-snb-6:20140216080155:x86_64-randconfig-c4-0212:3.14.0-rc1-00001-g8460434:27
/kernel/x86_64-randconfig-c4-0212/84604340d034a074036e86e85c4055a1c7ea5529/dmesg-quantal-xian-5:20140216080224:x86_64-randconfig-c4-0212:3.14.0-rc1-00001-g8460434:27
0:3:19 all_good:bad:all_bad boots

[detached HEAD 1311cda] Revert "workqueue: Fix workqueue lockdep name"
 1 file changed, 1 insertion(+), 1 deletion(-)
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-c4-0212/wq:for-3.14-fixes:1311cda258378c84741364b4ab09e14b979ab4ca:bisect-net

2014-02-16-11:55:16 1311cda258378c84741364b4ab09e14b979ab4ca compiling
2014-02-16-11:58:41 1311cda258378c84741364b4ab09e14b979ab4ca SKIP BROKEN BUILD
Check erros in /cc/wfg/net-bisect and /tmp/kernel/x86_64-randconfig-c4-0212/1311cda258378c84741364b4ab09e14b979ab4ca

========= upstream =========
Fetching linus
>From git://gitmirror/linus
   ca03339..946dd68  master     -> linus/master
Warning: you are leaving 1 commit behind, not connected to
any of your branches:

  1311cda Revert "workqueue: Fix workqueue lockdep name"

If you want to keep them by creating a new branch, this may be a good time
to do so with:

 git branch new_branch_name 1311cda

HEAD is now at 946dd68... Merge git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-c4-0212/wq:for-3.14-fixes:946dd683afb611721cce2cc7e76a19e74f58e067:bisect-net

2014-02-16-11:58:57 946dd683afb611721cce2cc7e76a19e74f58e067 compiling
2014-02-16-12:01:18 946dd683afb611721cce2cc7e76a19e74f58e067 SKIP BROKEN BUILD
Check erros in /cc/wfg/net-bisect and /tmp/kernel/x86_64-randconfig-c4-0212/946dd683afb611721cce2cc7e76a19e74f58e067

========= linux-next =========
Previous HEAD position was 946dd68... Merge git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending
HEAD is now at da8d308... Add linux-next specific files for 20140214
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-c4-0212/wq:for-3.14-fixes:da8d308fbdb8360078786b3e125238122c4fc611:bisect-net

2014-02-16-12:01:20 da8d308fbdb8360078786b3e125238122c4fc611 compiling
2014-02-16-12:07:02 da8d308fbdb8360078786b3e125238122c4fc611 SKIP BROKEN BUILD
Check erros in /cc/wfg/net-bisect and /tmp/kernel/x86_64-randconfig-c4-0212/da8d308fbdb8360078786b3e125238122c4fc611

--7DO5AaGCk89r4vaK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc1-00001-g8460434"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.14.0-rc1 Kernel Configuration
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
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
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
CONFIG_KERNEL_XZ=y
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_FHANDLE=y
# CONFIG_AUDIT is not set

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
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
# CONFIG_RCU_USER_QS is not set
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
CONFIG_RCU_FAST_NO_HZ=y
CONFIG_TREE_RCU_TRACE=y
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
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_NUMA_BALANCING=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
# CONFIG_RD_LZMA is not set
CONFIG_RD_XZ=y
# CONFIG_RD_LZO is not set
CONFIG_RD_LZ4=y
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
# CONFIG_ELF_CORE is not set
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
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
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
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
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
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
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
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
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_EARLY=y
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
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
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_MOVABLE_NODE=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
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
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
CONFIG_DEBUG_HOTPLUG_CPU0=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

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
# CONFIG_PM_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
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
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
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
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

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
# CONFIG_ISA_DMA_API is not set
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_X86_X32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_KEYS_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
CONFIG_IP_PNP_RARP=y
CONFIG_NET_IPIP=y
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
# CONFIG_SYN_COOKIES is not set
CONFIG_NET_IPVTI=y
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_ACCT=y
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
CONFIG_NETFILTER_NETLINK_LOG=y
# CONFIG_NF_CONNTRACK is not set
# CONFIG_NF_TABLES is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=y

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
CONFIG_NETFILTER_XT_TARGET_HMARK=y
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=y
CONFIG_NETFILTER_XT_TARGET_LED=y
# CONFIG_NETFILTER_XT_TARGET_LOG is not set
CONFIG_NETFILTER_XT_TARGET_MARK=y
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
CONFIG_NETFILTER_XT_TARGET_RATEEST=y
# CONFIG_NETFILTER_XT_TARGET_TEE is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=y
# CONFIG_NETFILTER_XT_MATCH_BPF is not set
# CONFIG_NETFILTER_XT_MATCH_CGROUP is not set
CONFIG_NETFILTER_XT_MATCH_COMMENT=y
CONFIG_NETFILTER_XT_MATCH_CPU=y
CONFIG_NETFILTER_XT_MATCH_DCCP=y
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=y
CONFIG_NETFILTER_XT_MATCH_DSCP=y
CONFIG_NETFILTER_XT_MATCH_ECN=y
CONFIG_NETFILTER_XT_MATCH_ESP=y
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=y
# CONFIG_NETFILTER_XT_MATCH_HL is not set
CONFIG_NETFILTER_XT_MATCH_IPCOMP=y
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
# CONFIG_NETFILTER_XT_MATCH_L2TP is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=y
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
CONFIG_NETFILTER_XT_MATCH_MAC=y
CONFIG_NETFILTER_XT_MATCH_MARK=y
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
CONFIG_NETFILTER_XT_MATCH_NFACCT=y
CONFIG_NETFILTER_XT_MATCH_OSF=y
CONFIG_NETFILTER_XT_MATCH_OWNER=y
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=y
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=y
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
CONFIG_NETFILTER_XT_MATCH_RATEEST=y
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
CONFIG_NETFILTER_XT_MATCH_RECENT=y
CONFIG_NETFILTER_XT_MATCH_SCTP=y
CONFIG_NETFILTER_XT_MATCH_SOCKET=y
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
CONFIG_NETFILTER_XT_MATCH_STRING=y
CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
CONFIG_NETFILTER_XT_MATCH_TIME=y
CONFIG_NETFILTER_XT_MATCH_U32=y
# CONFIG_IP_SET is not set
CONFIG_IP_VS=y
CONFIG_IP_VS_DEBUG=y
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
# CONFIG_IP_VS_PROTO_AH is not set
# CONFIG_IP_VS_PROTO_SCTP is not set

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=y
# CONFIG_IP_VS_WRR is not set
# CONFIG_IP_VS_LC is not set
CONFIG_IP_VS_WLC=y
CONFIG_IP_VS_LBLC=y
# CONFIG_IP_VS_LBLCR is not set
# CONFIG_IP_VS_DH is not set
CONFIG_IP_VS_SH=y
# CONFIG_IP_VS_SED is not set
CONFIG_IP_VS_NQ=y

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
# CONFIG_IP_NF_IPTABLES is not set
# CONFIG_IP_NF_ARPTABLES is not set

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=y
CONFIG_BRIDGE_NF_EBTABLES=y
CONFIG_BRIDGE_EBT_BROUTE=y
CONFIG_BRIDGE_EBT_T_FILTER=y
CONFIG_BRIDGE_EBT_T_NAT=y
CONFIG_BRIDGE_EBT_802_3=y
CONFIG_BRIDGE_EBT_AMONG=y
# CONFIG_BRIDGE_EBT_ARP is not set
CONFIG_BRIDGE_EBT_IP=y
# CONFIG_BRIDGE_EBT_LIMIT is not set
# CONFIG_BRIDGE_EBT_MARK is not set
CONFIG_BRIDGE_EBT_PKTTYPE=y
# CONFIG_BRIDGE_EBT_STP is not set
# CONFIG_BRIDGE_EBT_VLAN is not set
# CONFIG_BRIDGE_EBT_ARPREPLY is not set
CONFIG_BRIDGE_EBT_DNAT=y
CONFIG_BRIDGE_EBT_MARK_T=y
CONFIG_BRIDGE_EBT_REDIRECT=y
# CONFIG_BRIDGE_EBT_SNAT is not set
CONFIG_BRIDGE_EBT_LOG=y
CONFIG_BRIDGE_EBT_ULOG=y
CONFIG_BRIDGE_EBT_NFLOG=y
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=y

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
# CONFIG_IP_DCCP_CCID3 is not set

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
# CONFIG_IP_SCTP is not set
CONFIG_RDS=y
CONFIG_RDS_TCP=y
CONFIG_RDS_DEBUG=y
CONFIG_TIPC=y
CONFIG_TIPC_PORTS=8191
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
CONFIG_ATM_CLIP_NO_ICMP=y
CONFIG_ATM_LANE=y
CONFIG_ATM_MPOA=y
CONFIG_ATM_BR2684=y
# CONFIG_ATM_BR2684_IPFILTER is not set
# CONFIG_L2TP is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_MRP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
# CONFIG_IPDDP is not set
CONFIG_X25=y
CONFIG_LAPB=y
# CONFIG_PHONET is not set
CONFIG_IEEE802154=y
# CONFIG_MAC802154 is not set
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_BLA is not set
CONFIG_BATMAN_ADV_DAT=y
# CONFIG_BATMAN_ADV_NC is not set
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=y
CONFIG_HSR=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y

#
# Network testing
#
# CONFIG_NET_DROP_MONITOR is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
# CONFIG_AX25_DAMA_SLAVE is not set
# CONFIG_NETROM is not set
# CONFIG_ROSE is not set

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
# CONFIG_6PACK is not set
CONFIG_BPQETHER=y
CONFIG_BAYCOM_SER_FDX=y
CONFIG_BAYCOM_SER_HDX=y
CONFIG_YAM=y
CONFIG_CAN=y
CONFIG_CAN_RAW=y
# CONFIG_CAN_BCM is not set
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=y
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_LEDS is not set
# CONFIG_CAN_MCP251X is not set
# CONFIG_PCH_CAN is not set
CONFIG_CAN_SJA1000=y
CONFIG_CAN_SJA1000_ISA=y
CONFIG_CAN_SJA1000_PLATFORM=y
# CONFIG_CAN_EMS_PCI is not set
# CONFIG_CAN_PEAK_PCI is not set
# CONFIG_CAN_KVASER_PCI is not set
# CONFIG_CAN_PLX_PCI is not set
CONFIG_CAN_C_CAN=y
# CONFIG_CAN_C_CAN_PLATFORM is not set
# CONFIG_CAN_C_CAN_PCI is not set
CONFIG_CAN_CC770=y
# CONFIG_CAN_CC770_ISA is not set
CONFIG_CAN_CC770_PLATFORM=y
CONFIG_CAN_SOFTING=y
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
# CONFIG_RXKAD is not set
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
# CONFIG_CFG80211 is not set
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
CONFIG_LIB80211_DEBUG=y

#
# CFG80211 needs to be enabled for MAC80211
#
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
CONFIG_RFKILL_REGULATOR=y
# CONFIG_NET_9P is not set
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=y
CONFIG_CAIF_USB=y
# CONFIG_CEPH_LIB is not set
CONFIG_NFC=y
# CONFIG_NFC_DIGITAL is not set
# CONFIG_NFC_NCI is not set
CONFIG_NFC_HCI=y
# CONFIG_NFC_SHDLC is not set

#
# Near Field Communication (NFC) devices
#
# CONFIG_NFC_SIM is not set
# CONFIG_NFC_PN544 is not set
CONFIG_NFC_MICROREAD=y
CONFIG_HAVE_BPF_JIT=y

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
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
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
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_OOPS=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
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
# CONFIG_MTD_RAM is not set
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PHYSMAP is not set
CONFIG_MTD_SC520CDP=y
# CONFIG_MTD_NETSC520 is not set
CONFIG_MTD_TS5500=y
# CONFIG_MTD_SBC_GXX is not set
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
# CONFIG_MTD_PCI is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=y
# CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
CONFIG_MTD_DATAFLASH_OTP=y
CONFIG_MTD_M25P80=y
CONFIG_MTD_SST25L=y
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=y
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
# CONFIG_MTD_NAND_DENALI is not set
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH=y
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
# CONFIG_MTD_NAND_DOCG4 is not set
# CONFIG_MTD_NAND_CAFE is not set
# CONFIG_MTD_NAND_NANDSIM is not set
CONFIG_MTD_NAND_PLATFORM=y
# CONFIG_MTD_NAND_SH_FLCTL is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
# CONFIG_MTD_UBI_GLUEBI is not set
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
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29020=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_DS1682=y
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_SRAM=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#
# CONFIG_INTEL_MIC_HOST is not set

#
# Intel MIC Card Driver
#
CONFIG_INTEL_MIC_CARD=y
# CONFIG_GENWQE is not set
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
# CONFIG_NET_CORE is not set
# CONFIG_ARCNET is not set
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=y
# CONFIG_ATM_TCP is not set
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_FIRESTREAM is not set
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_NICSTAR is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_AMBASSADOR is not set
# CONFIG_ATM_HORIZON is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
# CONFIG_ATM_SOLOS is not set

#
# CAIF transport drivers
#
# CONFIG_CAIF_TTY is not set
# CONFIG_CAIF_SPI_SLAVE is not set
# CONFIG_CAIF_HSI is not set
CONFIG_CAIF_VIRTIO=y
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y
CONFIG_VHOST=y

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
# CONFIG_NET_DSA_MV88E6060 is not set
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
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
CONFIG_ARM_AT91_ETHER=y
CONFIG_MACB=y
# CONFIG_NET_VENDOR_BROADCOM is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_CALXEDA_XGMAC=y
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_DNET=y
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
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
# CONFIG_IXGBE is not set
# CONFIG_I40E is not set
# CONFIG_NET_VENDOR_I825XX is not set
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
# CONFIG_NET_VENDOR_MARVELL is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_MLX5_CORE is not set
# CONFIG_NET_VENDOR_MICREL is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_ENC28J60 is not set
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
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
CONFIG_ETHOC=y
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
CONFIG_SH_ETH=y
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
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
CONFIG_STMMAC_PLATFORM=y
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
# CONFIG_NET_VENDOR_VIA is not set
CONFIG_NET_VENDOR_WIZNET=y
CONFIG_WIZNET_W5100=y
# CONFIG_WIZNET_W5300 is not set
# CONFIG_WIZNET_BUS_DIRECT is not set
# CONFIG_WIZNET_BUS_INDIRECT is not set
CONFIG_WIZNET_BUS_ANY=y
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
CONFIG_BROADCOM_PHY=y
# CONFIG_BCM87XX_PHY is not set
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=y
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
# CONFIG_MICREL_KS8995MA is not set
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
# CONFIG_PPP_DEFLATE is not set
# CONFIG_PPP_FILTER is not set
# CONFIG_PPP_MPPE is not set
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPPOATM=y
CONFIG_PPPOE=y
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y
CONFIG_WLAN=y
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
CONFIG_HOSTAP=y
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_HOSTAP_FIRMWARE_NVRAM=y
# CONFIG_HOSTAP_PLX is not set
# CONFIG_HOSTAP_PCI is not set
CONFIG_WL_TI=y

#
# WiMAX Wireless Broadband devices
#

#
# Enable USB support to see WiMAX USB drivers
#
# CONFIG_WAN is not set
# CONFIG_IEEE802154_DRIVERS is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set

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
# CONFIG_KEYBOARD_SH_KEYSC is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
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
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
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
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_CLPS711X is not set
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
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_ST_ASC is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
# CONFIG_IPMI_WATCHDOG is not set
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_ATMEL=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=y
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
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
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_KEMPLD is not set
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_RIIC is not set
CONFIG_I2C_SH_MOBILE=y
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y
CONFIG_I2C_RCAR=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
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
# CONFIG_SPI_ATMEL is not set
CONFIG_SPI_BCM2835=y
CONFIG_SPI_BCM63XX_HSSPI=y
CONFIG_SPI_BITBANG=y
CONFIG_SPI_EP93XX=y
CONFIG_SPI_IMX=y
CONFIG_SPI_FSL_DSPI=y
CONFIG_SPI_TI_QSPI=y
CONFIG_SPI_OMAP_100K=y
CONFIG_SPI_ORION=y
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_SH is not set
CONFIG_SPI_SH_HSPI=y
CONFIG_SPI_TEGRA114=y
CONFIG_SPI_TEGRA20_SFLASH=y
CONFIG_SPI_TEGRA20_SLINK=y
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_XCOMM=y
CONFIG_SPI_XILINX=y
CONFIG_SPI_DESIGNWARE=y
# CONFIG_SPI_DW_PCI is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
# CONFIG_HSI is not set

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
# CONFIG_PPS_CLIENT_GPIO is not set

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
# CONFIG_GPIOLIB is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_88PM860X is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_PCF50633 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_MANAGER is not set
# CONFIG_CHARGER_MAX14577 is not set
# CONFIG_CHARGER_MAX8997 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_CHARGER_TPS65090 is not set
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_AD7314 is not set
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADCXX=y
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
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
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IBMAEM=y
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_IIO_HWMON is not set
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=y
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX1111=y
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_WM831X is not set
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_EMULATION=y
CONFIG_RCAR_THERMAL=y
CONFIG_INTEL_POWERCLAMP=y
# CONFIG_ACPI_INT3403_THERMAL is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_DA9052_WATCHDOG=y
CONFIG_DA9055_WATCHDOG=y
# CONFIG_WM831X_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
CONFIG_RETU_WATCHDOG=y
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
CONFIG_SC520_WDT=y
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
CONFIG_KEMPLD_WDT=y
CONFIG_SC1200_WDT=y
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=y
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=y
# CONFIG_W83977F_WDT is not set
CONFIG_MACHZ_WDT=y
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set
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
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=y
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_EZX_PCAP=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
# CONFIG_MFD_SM501 is not set
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
# CONFIG_AB3100_OTP is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP3943=y
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_ARIZONA_SPI=y
# CONFIG_MFD_WM5102 is not set
# CONFIG_MFD_WM5110 is not set
# CONFIG_MFD_WM8997 is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_88PM800 is not set
# CONFIG_REGULATOR_88PM8607 is not set
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_AB3100=y
CONFIG_REGULATOR_DA9052=y
# CONFIG_REGULATOR_DA9055 is not set
# CONFIG_REGULATOR_DA9063 is not set
# CONFIG_REGULATOR_DA9210 is not set
# CONFIG_REGULATOR_FAN53555 is not set
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
# CONFIG_REGULATOR_LP8788 is not set
CONFIG_REGULATOR_MAX14577=y
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8997=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
# CONFIG_REGULATOR_MC13892 is not set
# CONFIG_REGULATOR_PCAP is not set
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_RC5T583=y
# CONFIG_REGULATOR_S2MPS11 is not set
CONFIG_REGULATOR_S5M8767=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_TPS65090 is not set
CONFIG_REGULATOR_TPS65217=y
CONFIG_REGULATOR_TPS6524X=y
# CONFIG_REGULATOR_TPS80031 is not set
# CONFIG_REGULATOR_WM831X is not set
CONFIG_REGULATOR_WM8994=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
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
CONFIG_SMS_SDIO_DRV=y
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_SMS_SIANO_MDTV=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

#
# Multistandard (satellite) frontends
#

#
# Multistandard (cable + terrestrial) frontends
#

#
# DVB-S (satellite) frontends
#

#
# DVB-T (terrestrial) frontends
#

#
# DVB-C (cable) frontends
#

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#

#
# ISDB-T (terrestrial) frontends
#

#
# Digital terrestrial only tuners/PLL
#

#
# SEC control devices for DVB-S
#

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
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
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
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
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
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
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
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
CONFIG_FB_AUO_K1901=y
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_DA9052=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
# CONFIG_BACKLIGHT_WM831X is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=y
# CONFIG_BACKLIGHT_88PM860X is not set
# CONFIG_BACKLIGHT_PCF50633 is not set
CONFIG_BACKLIGHT_LM3630A=y
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_LP855X is not set
CONFIG_BACKLIGHT_LP8788=y
CONFIG_BACKLIGHT_TPS65217=y
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
CONFIG_SND_PCM_OSS=y
# CONFIG_SND_PCM_OSS_PLUGINS is not set
CONFIG_SND_SEQUENCER_OSS=y
# CONFIG_SND_HRTIMER is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
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
# CONFIG_SND_SPI is not set
# CONFIG_SND_SOC is not set
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
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_PRODIKEYS is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_EZKEY is not set
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
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
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
# CONFIG_KEYSTONE_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_OMAP_CONTROL_USB is not set
# CONFIG_OMAP_USB3 is not set
# CONFIG_AM335X_PHY_USB is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_RCAR_GEN2_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
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
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_OMAP_HS=y
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_SPI=y
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_LP8788 is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
CONFIG_LEDS_PCA9685=y
CONFIG_LEDS_WM831X_STATUS=y
# CONFIG_LEDS_DA9052 is not set
# CONFIG_LEDS_DAC124S085 is not set
CONFIG_LEDS_PWM=y
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_MAX8997 is not set
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
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
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
# CONFIG_EDAC_DEBUG is not set
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
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM860X=y
CONFIG_RTC_DRV_88PM80X=y
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
# CONFIG_RTC_DRV_DS1672 is not set
CONFIG_RTC_DRV_DS3232=y
# CONFIG_RTC_DRV_LP8788 is not set
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8907=y
# CONFIG_RTC_DRV_MAX8997 is not set
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
# CONFIG_RTC_DRV_ISL12022 is not set
CONFIG_RTC_DRV_ISL12057=y
CONFIG_RTC_DRV_X1205=y
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_PCF8523=y
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=y
CONFIG_RTC_DRV_TPS80031=y
# CONFIG_RTC_DRV_RC5T583 is not set
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=y
CONFIG_RTC_DRV_RV3029C2=y
CONFIG_RTC_DRV_S5M=y

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
CONFIG_RTC_DRV_M41T94=y
# CONFIG_RTC_DRV_DS1305 is not set
CONFIG_RTC_DRV_DS1390=y
CONFIG_RTC_DRV_MAX6902=y
CONFIG_RTC_DRV_R9701=y
CONFIG_RTC_DRV_RS5C348=y
CONFIG_RTC_DRV_DS3234=y
CONFIG_RTC_DRV_PCF2123=y
# CONFIG_RTC_DRV_RX4581 is not set

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DA9052=y
# CONFIG_RTC_DRV_DA9055 is not set
CONFIG_RTC_DRV_STK17TA8=y
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set
CONFIG_RTC_DRV_DS2404=y
# CONFIG_RTC_DRV_WM831X is not set
# CONFIG_RTC_DRV_PCF50633 is not set
CONFIG_RTC_DRV_AB3100=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_PCAP=y
CONFIG_RTC_DRV_MC13XXX=y
# CONFIG_RTC_DRV_MOXART is not set

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
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
# CONFIG_DW_DMAC_PCI is not set
CONFIG_TIMB_DMA=y
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
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
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
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
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
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
# CONFIG_BMA180 is not set
CONFIG_KXSD9=y

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
CONFIG_AD7266=y
CONFIG_AD7298=y
CONFIG_AD7476=y
CONFIG_AD7791=y
# CONFIG_AD7793 is not set
# CONFIG_AD7887 is not set
CONFIG_AD7923=y
# CONFIG_LP8788_ADC is not set
CONFIG_MAX1363=y
CONFIG_MCP320X=y
# CONFIG_MCP3422 is not set
CONFIG_NAU7802=y
CONFIG_TI_ADC081C=y

#
# Amplifiers
#
# CONFIG_AD8366 is not set

#
# Hid Sensor IIO Common
#

#
# Digital to analog converters
#
CONFIG_AD5064=y
CONFIG_AD5360=y
CONFIG_AD5380=y
# CONFIG_AD5421 is not set
# CONFIG_AD5446 is not set
# CONFIG_AD5449 is not set
CONFIG_AD5504=y
CONFIG_AD5624R_SPI=y
# CONFIG_AD5686 is not set
CONFIG_AD5755=y
CONFIG_AD5764=y
CONFIG_AD5791=y
# CONFIG_AD7303 is not set
CONFIG_MAX517=y
CONFIG_MCP4725=y

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
CONFIG_AD9523=y

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
# CONFIG_ADF4350 is not set

#
# Digital gyroscope sensors
#
# CONFIG_ADIS16080 is not set
CONFIG_ADIS16130=y
# CONFIG_ADIS16136 is not set
CONFIG_ADIS16260=y
CONFIG_ADXRS450=y
CONFIG_ITG3200=y

#
# Humidity sensors
#

#
# Inertial measurement units
#
# CONFIG_ADIS16400 is not set
CONFIG_ADIS16480=y
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
CONFIG_APDS9300=y
# CONFIG_CM32181 is not set
CONFIG_CM36651=y
CONFIG_GP2AP020A00F=y
# CONFIG_SENSORS_LM3533 is not set
# CONFIG_TCS3472 is not set
CONFIG_SENSORS_TSL2563=y
CONFIG_TSL4531=y
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
CONFIG_MAG3110=y

#
# Inclinometer sensors
#

#
# Triggers - standalone
#
# CONFIG_IIO_INTERRUPT_TRIGGER is not set

#
# Pressure sensors
#
CONFIG_MPL3115=y

#
# Temperature sensors
#
CONFIG_TMP006=y
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_LP3943=y
CONFIG_PWM_RENESAS_TPU=y
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
# CONFIG_FMC_FAKEDEV is not set
# CONFIG_FMC_TRIVIAL is not set
# CONFIG_FMC_WRITE_EEPROM is not set
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
# CONFIG_POWERCAP is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_DEBUG is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
# CONFIG_SYSFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
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
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
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
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_DEBUG_SLAB=y
CONFIG_DEBUG_SLAB_LEAK=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

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
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
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
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAIL_MMC_REQUEST=y
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
# CONFIG_FUNCTION_TRACER is not set
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
# CONFIG_STACK_TRACER is not set
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
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
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
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
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
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
CONFIG_CRYPTO_CTS=y
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
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
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
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=y
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
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
CONFIG_KVM=y
# CONFIG_KVM_INTEL is not set
CONFIG_KVM_AMD=y
# CONFIG_KVM_MMU_AUDIT is not set
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
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
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
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y

--7DO5AaGCk89r4vaK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--7DO5AaGCk89r4vaK--
