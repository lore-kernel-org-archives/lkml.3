Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbaBSMTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 07:19:23 -0500
Received: from mga14.intel.com ([143.182.124.37]:28469 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030AbaBSMTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 07:19:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,505,1389772800"; 
   d="log'?scan'208";a="477619217"
Date: Wed, 19 Feb 2014 20:18:55 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Alex Shi <alex.shi@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: [sched/balance] WARNING: CPU: 0 PID: 8 at kernel/sched/core.c:2939
 rt_mutex_setprio()
Message-ID: <20140219121855.GF7241@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="V0207lvV8h4k8FAm"
Content-Disposition: inline
In-Reply-To: <20140219121703.GD7241@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V0207lvV8h4k8FAm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

https://github.com/alexshi/power-scheduling.git single-balance
commit 98564060e5c360908d93f61a78ccbef4a082d3c2
Author:     Alex Shi <alex.shi@linaro.org>
AuthorDate: Tue Feb 18 21:01:54 2014 +0800
Commit:     Alex Shi <alex.shi@linaro.org>
CommitDate: Tue Feb 18 21:33:06 2014 +0800

    sched/balance: add balance_interval to tuning top level balance frequency
    
    Since central balance stains less cpu cache as current balance, we
    can set the balance interval more short.
    
    Signed-off-by: Alex Shi <alex.shi@linaro.org>

[    1.323527] WARNING: CPU: 0 PID: 8 at kernel/sched/core.c:2939 rt_mutex_setprio+0x646/0x8a3()

git bisect start 0d8b92f526636f83e3e9a295a5a0ee1a2bdcb09d 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2 --
git bisect  bad 7f3b48eb13c1d5daee3f7c93c0f69751b9c3ce85  # 06:22      1-      6  Merge 'hid/for-next' into devel-hourly-2014021904
git bisect  bad 722206b26319203cac0c4ba4bf252e5af46508db  # 06:29      4-      7  Merge 'keystone/keystone/master' into devel-hourly-2014021904
git bisect  bad 9473e52410408e4e1721b1d4a7056395374a69bc  # 06:35      1-      4  Merge 'nfs/testing' into devel-hourly-2014021904
git bisect good 3925e3c984d5ab31fe6dd0ee27ed2d50c8d512d9  # 06:41     33+      7  Merge 'microblaze/next' into devel-hourly-2014021904
git bisect good e30e77323f610bfb2d7d6fe5498a50f0c5bd2087  # 06:45     33+     13  Merge 'input/next' into devel-hourly-2014021904
git bisect  bad 58311fcd94b5f78faaa55959cbfcf8fbc4c7bac0  # 06:52      4-      5  Merge 'alexshi/single-balance' into devel-hourly-2014021904
git bisect good 4a5d7c9f371d437e80369739bc7c38743f0d87c3  # 06:57     60+     17  sched: rename update_*_cpu_load
git bisect good 480c3ba7685296b8da892020d408223e7abdc70b  # 07:01     60+     15  sched: remove un-used functions
git bisect good 0e32dab5df39cfb1be9a937d67c877404b964324  # 07:06     60+     18  sched/balance: rebuild ovutil tree after task moving
git bisect  bad 98564060e5c360908d93f61a78ccbef4a082d3c2  # 07:12      4-      6  sched/balance: add balance_interval to tuning top level balance frequency
git bisect good 34c6c7844fd7ac6b7636614534d83c1099ab6fc7  # 07:17     60+     19  sched/balance: add llc balance interval
# first bad commit: [98564060e5c360908d93f61a78ccbef4a082d3c2] sched/balance: add balance_interval to tuning top level balance frequency
git bisect good 34c6c7844fd7ac6b7636614534d83c1099ab6fc7  # 07:22    180+     62  sched/balance: add llc balance interval
git bisect  bad 0d8b92f526636f83e3e9a295a5a0ee1a2bdcb09d  # 07:22      0-     19  0day head guard for 'devel-hourly-2014021904'
git bisect good 7d4b82cdf527b65f50cbcde5d74dc4fc5ed8d1dc  # 07:31    180+     32  Revert "sched/balance: add balance_interval to tuning top level balance frequency"
git bisect good 805937cf45f9a9933e6b8e5c6660406e977a9a23  # 07:39    180+     24  Merge tag 'ext4_for_linus_stable' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
git bisect good 02d56d4d19b8aa889c856287729d89c805ee42ec  # 08:45    180+     57  Add linux-next specific files for 20140218

Thanks,
Fengguang

--V0207lvV8h4k8FAm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-snb-39:20140219054926:i386-randconfig-an0-02190423::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc3-02058-g0d8b92f (kbuild@ant) (gcc ve=
rsion 4.8.1 (Debian 4.8.1-8) ) #2 SMP PREEMPT Wed Feb 19 05:38:21 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x1000000
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
[800fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x02ffffff]
[    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
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
[    0.000000] BRK [0x02724000, 0x02724fff] PGTABLE
[    0.000000] BRK [0x02725000, 0x02727fff] PGTABLE
[    0.000000] BRK [0x02728000, 0x02728fff] PGTABLE
[    0.000000] BRK [0x02729000, 0x02729fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x0fcbd000-0x0ffeffff]
[    0.000000] ACPI: RSDP 0x000FD930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0FFFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x0FFFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x0FFFE490 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x0FFFFF40 000040
[    0.000000] ACPI: SSDT 0x0FFFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x0FFFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x0FFFF640 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0fffd000-0x0fffdfff]
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000] max_low_pfn =3D fffe, highstart_pfn =3D fffe
[    0.000000] Low memory ends at vaddr 8fffe000
[    0.000000] High memory starts at vaddr 8fffe000
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffc001, boot clock
[    0.000000] Node: 0, start_pfn: 1, end_pfn: 9f
[    0.000000]   Setting physnode_map array to node 0 for pfns:
[    0.000000]   0=20
[    0.000000] Node: 0, start_pfn: 100, end_pfn: fffe
[    0.000000]   Setting physnode_map array to node 0 for pfns:
[    0.000000]   0 4000 8000 c000=20
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000] free_area_init_node: node 0, pgdat 8fffd000, node_mem_map 8f=
a7d024
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
[    0.000000] PERCPU: Embedded 11 pages/cpu @8fa67000 s30656 r0 d14400 u45=
056
[    0.000000] pcpu-alloc: s30656 r0 d14400 u45056 alloc=3D11*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fffc001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr fa696c0
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 64860
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-an0-02190423/linux-devel:devel-hourly-2014021904/.vmlinu=
z-0d8b92f526636f83e3e9a295a5a0ee1a2bdcb09d-20140219054112-4-snb branch=3Dli=
nux-devel/devel-hourly-2014021904 BOOT_IMAGE=3D/kernel/i386-randconfig-an0-=
02190423/0d8b92f526636f83e3e9a295a5a0ee1a2bdcb09d/vmlinuz-3.14.0-rc3-02058-=
g0d8b92f
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 524264 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 231548K/261744K available (12238K kernel code, 1904K=
 rwdata, 4344K rodata, 772K init, 4276K bss, 30196K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffa95000 - 0xfffff000   (5544 kB)
[    0.000000]     pkmap   : 0xff600000 - 0xff800000   (2048 kB)
[    0.000000]     vmalloc : 0x907fe000 - 0xff5fe000   (1774 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x8fffe000   ( 255 MB)
[    0.000000]       .init : 0x82218000 - 0x822d9000   ( 772 kB)
[    0.000000]       .data : 0x81bf3e0b - 0x82217380   (6285 kB)
[    0.000000]       .text : 0x81000000 - 0x81bf3e0b   (12239 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3D80092000 soft=3D80094000
[    0.000000] ACPI: Core revision 20140114
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc3-02058-g0d8b92f (kbuild@ant) (gcc ve=
rsion 4.8.1 (Debian 4.8.1-8) ) #2 SMP PREEMPT Wed Feb 19 05:38:21 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x1000000
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
[800fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x02ffffff]
[    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
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
[    0.000000] BRK [0x02724000, 0x02724fff] PGTABLE
[    0.000000] BRK [0x02725000, 0x02727fff] PGTABLE
[    0.000000] BRK [0x02728000, 0x02728fff] PGTABLE
[    0.000000] BRK [0x02729000, 0x02729fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x0fcbd000-0x0ffeffff]
[    0.000000] ACPI: RSDP 0x000FD930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0FFFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x0FFFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x0FFFE490 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x0FFFFF40 000040
[    0.000000] ACPI: SSDT 0x0FFFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x0FFFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x0FFFF640 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0fffd000-0x0fffdfff]
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000] max_low_pfn =3D fffe, highstart_pfn =3D fffe
[    0.000000] Low memory ends at vaddr 8fffe000
[    0.000000] High memory starts at vaddr 8fffe000
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffc001, boot clock
[    0.000000] Node: 0, start_pfn: 1, end_pfn: 9f
[    0.000000]   Setting physnode_map array to node 0 for pfns:
[    0.000000]   0=20
[    0.000000] Node: 0, start_pfn: 100, end_pfn: fffe
[    0.000000]   Setting physnode_map array to node 0 for pfns:
[    0.000000]   0 4000 8000 c000=20
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000] free_area_init_node: node 0, pgdat 8fffd000, node_mem_map 8f=
a7d024
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
[    0.000000] PERCPU: Embedded 11 pages/cpu @8fa67000 s30656 r0 d14400 u45=
056
[    0.000000] pcpu-alloc: s30656 r0 d14400 u45056 alloc=3D11*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fffc001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr fa696c0
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 64860
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-an0-02190423/linux-devel:devel-hourly-2014021904/.vmlinu=
z-0d8b92f526636f83e3e9a295a5a0ee1a2bdcb09d-20140219054112-4-snb branch=3Dli=
nux-devel/devel-hourly-2014021904 BOOT_IMAGE=3D/kernel/i386-randconfig-an0-=
02190423/0d8b92f526636f83e3e9a295a5a0ee1a2bdcb09d/vmlinuz-3.14.0-rc3-02058-=
g0d8b92f
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 524264 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 231548K/261744K available (12238K kernel code, 1904K=
 rwdata, 4344K rodata, 772K init, 4276K bss, 30196K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffa95000 - 0xfffff000   (5544 kB)
[    0.000000]     pkmap   : 0xff600000 - 0xff800000   (2048 kB)
[    0.000000]     vmalloc : 0x907fe000 - 0xff5fe000   (1774 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x8fffe000   ( 255 MB)
[    0.000000]       .init : 0x82218000 - 0x822d9000   ( 772 kB)
[    0.000000]       .data : 0x81bf3e0b - 0x82217380   (6285 kB)
[    0.000000]       .text : 0x81000000 - 0x81bf3e0b   (12239 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3D80092000 soft=3D80094000
[    0.000000] ACPI: Core revision 20140114
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
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
[    0.000000]                      A-A deadlock:failed|failed|failed|faile=
d|  ok  |  ok  |failed|failed|failed|failed|failed|failed|

[    0.000000]                  A-B-B-A deadlock:
[    0.000000]                  A-B-B-A deadlock:failed|failed|failed|faile=
d|  ok  |  ok  |failed|failed|failed|failed|failed|failed|

[    0.000000]              A-B-B-C-C-A deadlock:
[    0.000000]              A-B-B-C-C-A deadlock:failed|failed|failed|faile=
d|  ok  |  ok  |failed|failed|failed|failed|failed|failed|

[    0.000000]              A-B-C-A-B-C deadlock:
[    0.000000]              A-B-C-A-B-C deadlock:failed|failed|failed|faile=
d|  ok  |  ok  |failed|failed|failed|failed|failed|failed|

[    0.000000]          A-B-B-C-C-D-D-A deadlock:
[    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|failed|faile=
d|  ok  |  ok  |failed|failed|failed|failed|failed|failed|

[    0.000000]          A-B-C-D-B-D-D-A deadlock:
[    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|failed|faile=
d|  ok  |  ok  |failed|failed|failed|failed|failed|failed|

[    0.000000]          A-B-C-D-B-C-D-A deadlock:
[    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|failed|faile=
d|  ok  |  ok  |failed|failed|failed|failed|failed|failed|

[    0.000000]                     double unlock:
[    0.000000]                     double unlock:failed|failed|failed|faile=
d|failed|failed|  ok  |  ok  |failed|failed|failed|failed|

[    0.000000]                   initialize held:
[    0.000000]                   initialize held:failed|failed|failed|faile=
d|failed|failed|failed|failed|failed|failed|failed|failed|

[    0.000000]                  bad unlock order:
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:
[    0.000000]               recursive read-lock:             |            =
 |  ok  |  ok  |             |             |failed|failed|

[    0.000000]            recursive read-lock #2:
[    0.000000]            recursive read-lock #2:             |            =
 |  ok  |  ok  |             |             |failed|failed|

[    0.000000]             mixed read-write-lock:
[    0.000000]             mixed read-write-lock:             |            =
 |failed|failed|             |             |failed|failed|

[    0.000000]             mixed write-read-lock:
[    0.000000]             mixed write-read-lock:             |            =
 |failed|failed|             |             |failed|failed|

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:
[    0.000000]      hard-irqs-on + irq-safe-A/12:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/12:
[    0.000000]      soft-irqs-on + irq-safe-A/12:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]      hard-irqs-on + irq-safe-A/21:
[    0.000000]      hard-irqs-on + irq-safe-A/21:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/21:
[    0.000000]      soft-irqs-on + irq-safe-A/21:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/12:
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:failed|failed|failed|fai=
led|  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/21:
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:failed|failed|failed|fai=
led|  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/12:
[    0.000000]          hard-safe-A + irqs-on/12:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/12:
[    0.000000]          soft-safe-A + irqs-on/12:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/21:
[    0.000000]          hard-safe-A + irqs-on/21:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/21:
[    0.000000]          soft-safe-A + irqs-on/21:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/123:
[    0.000000]     hard-safe-A + unsafe-B #1/123:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/123:
[    0.000000]     soft-safe-A + unsafe-B #1/123:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/132:
[    0.000000]     hard-safe-A + unsafe-B #1/132:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/132:
[    0.000000]     soft-safe-A + unsafe-B #1/132:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/213:
[    0.000000]     hard-safe-A + unsafe-B #1/213:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/213:
[    0.000000]     soft-safe-A + unsafe-B #1/213:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/231:
[    0.000000]     hard-safe-A + unsafe-B #1/231:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/231:
[    0.000000]     soft-safe-A + unsafe-B #1/231:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/312:
[    0.000000]     hard-safe-A + unsafe-B #1/312:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/312:
[    0.000000]     soft-safe-A + unsafe-B #1/312:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/321:
[    0.000000]     hard-safe-A + unsafe-B #1/321:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/321:
[    0.000000]     soft-safe-A + unsafe-B #1/321:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/123:
[    0.000000]     hard-safe-A + unsafe-B #2/123:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/123:
[    0.000000]     soft-safe-A + unsafe-B #2/123:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/132:
[    0.000000]     hard-safe-A + unsafe-B #2/132:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/132:
[    0.000000]     soft-safe-A + unsafe-B #2/132:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/213:
[    0.000000]     hard-safe-A + unsafe-B #2/213:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/213:
[    0.000000]     soft-safe-A + unsafe-B #2/213:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/231:
[    0.000000]     hard-safe-A + unsafe-B #2/231:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/231:
[    0.000000]     soft-safe-A + unsafe-B #2/231:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/312:
[    0.000000]     hard-safe-A + unsafe-B #2/312:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/312:
[    0.000000]     soft-safe-A + unsafe-B #2/312:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/321:
[    0.000000]     hard-safe-A + unsafe-B #2/321:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/321:
[    0.000000]     soft-safe-A + unsafe-B #2/321:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/123:
[    0.000000]       hard-irq lock-inversion/123:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/123:
[    0.000000]       soft-irq lock-inversion/123:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/132:
[    0.000000]       hard-irq lock-inversion/132:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/132:
[    0.000000]       soft-irq lock-inversion/132:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/213:
[    0.000000]       hard-irq lock-inversion/213:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/213:
[    0.000000]       soft-irq lock-inversion/213:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/231:
[    0.000000]       hard-irq lock-inversion/231:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/231:
[    0.000000]       soft-irq lock-inversion/231:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/312:
[    0.000000]       hard-irq lock-inversion/312:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/312:
[    0.000000]       soft-irq lock-inversion/312:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/321:
[    0.000000]       hard-irq lock-inversion/321:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/321:
[    0.000000]       soft-irq lock-inversion/321:failed|failed|failed|faile=
d|  ok  |  ok  |

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
[    0.000000]                ww contexts mixing:failed|failed|  ok  |  ok =
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
[    0.000000]            spinlock nest unlocked:failed|failed|

[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:
[    0.000000]                           context:failed|failed|  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                               try:
[    0.000000]                               try:failed|failed|  ok  |  ok =
 |failed|failed|

[    0.000000]                             block:
[    0.000000]                             block:failed|failed|  ok  |  ok =
 |failed|failed|

[    0.000000]                          spinlock:
[    0.000000]                          spinlock:failed|failed|  ok  |  ok =
 |failed|failed|

[    0.000000] --------------------------------------------------------
[    0.000000] --------------------------------------------------------
[    0.000000] 153 out of 253 testcases failed, as expected. |
[    0.000000] 153 out of 253 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] ----------------------------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2300.194 MHz processor
[    0.000000] tsc: Detected 2300.194 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.009999] Calibrating delay loop (skipped) preset value..=20
[    0.009999] Calibrating delay loop (skipped) preset value.. 4602.86 Bogo=
MIPS (lpj=3D7667313)
4602.86 BogoMIPS (lpj=3D7667313)
[    0.011039] pid_max: default: 4096 minimum: 301
[    0.011039] pid_max: default: 4096 minimum: 301
[    0.013757] Mount-cache hash table entries: 512
[    0.013757] Mount-cache hash table entries: 512
[    0.016995] Initializing cgroup subsys debug
[    0.016995] Initializing cgroup subsys debug
[    0.018526] Initializing cgroup subsys memory
[    0.018526] Initializing cgroup subsys memory
[    0.020050] Initializing cgroup subsys devices
[    0.020050] Initializing cgroup subsys devices
[    0.021748] Initializing cgroup subsys net_cls
[    0.021748] Initializing cgroup subsys net_cls
[    0.023502] mce: CPU supports 10 MCE banks
[    0.023502] mce: CPU supports 10 MCE banks
[    0.024940] mce: unknown CPU type - not enabling MCE support
[    0.024940] mce: unknown CPU type - not enabling MCE support
[    0.026721] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.026721] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.026721] tlb_flushall_shift: -1
[    0.026721] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.026721] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.026721] tlb_flushall_shift: -1
[    0.034696] Freeing SMP alternatives memory: 24K (822d9000 - 822df000)
[    0.034696] Freeing SMP alternatives memory: 24K (822d9000 - 822df000)
[    0.043042] Getting VERSION: 50014
[    0.043042] Getting VERSION: 50014
[    0.043362] Getting VERSION: 50014
[    0.043362] Getting VERSION: 50014
[    0.044566] Getting ID: 0
[    0.044566] Getting ID: 0
[    0.045512] Getting ID: f000000
[    0.045512] Getting ID: f000000
[    0.046699] Getting LVT0: 8700
[    0.046699] Getting LVT0: 8700
[    0.047862] Getting LVT1: 8400
[    0.047862] Getting LVT1: 8400
[    0.050017] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.050017] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.052034] enabled ExtINT on CPU#0
[    0.052034] enabled ExtINT on CPU#0
[    0.055208] ENABLING IO-APIC IRQs
[    0.055208] ENABLING IO-APIC IRQs
[    0.056692] init IO_APIC IRQs
[    0.056692] init IO_APIC IRQs
[    0.057732]  apic 0 pin 0 not connected
[    0.057732]  apic 0 pin 0 not connected
[    0.059140] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.059140] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.060086] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.060086] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.063390] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.063390] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.066725] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.066725] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.070058] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.070058] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.073405] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.073405] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.076731] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.076731] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.080056] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.080056] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.083386] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.083386] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.086308] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.086308] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.086726] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.086726] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.090054] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.090054] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.093387] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.093387] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.096717] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.096717] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.100051] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.100051] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.103377]  apic 0 pin 16 not connected
[    0.103377]  apic 0 pin 16 not connected
[    0.106678]  apic 0 pin 17 not connected
[    0.106678]  apic 0 pin 17 not connected
[    0.108109]  apic 0 pin 18 not connected
[    0.108109]  apic 0 pin 18 not connected
[    0.109542]  apic 0 pin 19 not connected
[    0.109542]  apic 0 pin 19 not connected
[    0.110013]  apic 0 pin 20 not connected
[    0.110013]  apic 0 pin 20 not connected
[    0.111490]  apic 0 pin 21 not connected
[    0.111490]  apic 0 pin 21 not connected
[    0.113345]  apic 0 pin 22 not connected
[    0.113345]  apic 0 pin 22 not connected
[    0.114781]  apic 0 pin 23 not connected
[    0.114781]  apic 0 pin 23 not connected
[    0.116854] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.116854] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.120012] smpboot: CPU0:=20
[    0.120012] smpboot: CPU0: GenuineIntel GenuineIntel Common KVM processo=
rCommon KVM processor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.125123] Using local APIC timer interrupts.
[    0.125123] calibrating APIC timer ...
[    0.125123] Using local APIC timer interrupts.
[    0.125123] calibrating APIC timer ...
[    0.129999] ... lapic delta =3D 6249548
[    0.129999] ... lapic delta =3D 6249548
[    0.129999] ... PM-Timer delta =3D 357932
[    0.129999] ... PM-Timer delta =3D 357932
[    0.129999] ... PM-Timer result ok
[    0.129999] ... PM-Timer result ok
[    0.129999] ..... delta 6249548
[    0.129999] ..... delta 6249548
[    0.129999] ..... mult: 268416069
[    0.129999] ..... mult: 268416069
[    0.129999] ..... calibration result: 3333092
[    0.129999] ..... calibration result: 3333092
[    0.129999] ..... CPU clock speed is 2300.0252 MHz.
[    0.129999] ..... CPU clock speed is 2300.0252 MHz.
[    0.129999] ..... host bus clock speed is 1000.0092 MHz.
[    0.129999] ..... host bus clock speed is 1000.0092 MHz.
[    0.130328] Performance Events:=20
[    0.130328] Performance Events: no PMU driver, software events only.
no PMU driver, software events only.
[    0.150067] ftrace: Allocated trace_printk buffers
[    0.150067] ftrace: Allocated trace_printk buffers
[    0.164316] CPU 1 irqstacks, hard=3D8f1e4000 soft=3D8f1e6000
[    0.164316] CPU 1 irqstacks, hard=3D8f1e4000 soft=3D8f1e6000
[    0.166684] x86: Booting SMP configuration:
[    0.166684] x86: Booting SMP configuration:
[    0.168718] .... node  #0, CPUs: =20
[    0.168718] .... node  #0, CPUs:         #1 #1
[    0.006666] Initializing CPU#1
[    0.009999] kvm-clock: cpu 1, msr 0:fffc041, secondary cpu clock
[    0.009999] masked ExtINT on CPU#1
[    0.184244] x86: Booted up 1 node, 2 CPUs
[    0.184244] x86: Booted up 1 node, 2 CPUs
[    0.184171] KVM setup async PF for cpu 1
[    0.184171] KVM setup async PF for cpu 1
[    0.184171] kvm-stealtime: cpu 1, msr fa746c0
[    0.184171] kvm-stealtime: cpu 1, msr fa746c0
[    0.186682] smpboot: Total of 2 processors activated (9204.72 BogoMIPS)
[    0.186682] smpboot: Total of 2 processors activated (9204.72 BogoMIPS)
[    0.192140] devtmpfs: initialized
[    0.192140] devtmpfs: initialized
[    0.193803] gcov: version magic: 0x3430382a
[    0.193803] gcov: version magic: 0x3430382a
[    0.200957] NET: Registered protocol family 16
[    0.200957] NET: Registered protocol family 16
[    0.203878] cpuidle: using governor ladder
[    0.203878] cpuidle: using governor ladder
[    0.205236] cpuidle: using governor menu
[    0.205236] cpuidle: using governor menu
[    0.207416] ACPI: bus type PCI registered
[    0.207416] ACPI: bus type PCI registered
[    0.210346] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.210346] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.212711] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.212711] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.213347] PCI: Using configuration type 1 for base access
[    0.213347] PCI: Using configuration type 1 for base access
[    0.233589] ACPI: Added _OSI(Module Device)
[    0.233589] ACPI: Added _OSI(Module Device)
[    0.235012] ACPI: Added _OSI(Processor Device)
[    0.235012] ACPI: Added _OSI(Processor Device)
[    0.236487] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.236487] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.236680] ACPI: Added _OSI(Processor Aggregator Device)
[    0.236680] ACPI: Added _OSI(Processor Aggregator Device)
[    0.251545] ACPI: Interpreter enabled
[    0.251545] ACPI: Interpreter enabled
[    0.252856] ACPI: (supports S0 S5)
[    0.252856] ACPI: (supports S0 S5)
[    0.253349] ACPI: Using IOAPIC for interrupt routing
[    0.253349] ACPI: Using IOAPIC for interrupt routing
[    0.254867] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.254867] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.272321] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.272321] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.273353] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.273353] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.274488] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.274488] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.276269] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.276269] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.276814] PCI host bridge to bus 0000:00
[    0.276814] PCI host bridge to bus 0000:00
[    0.277666] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.277666] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.280010] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.280010] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.281279] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.281279] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.283343] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.283343] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.284760] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.284760] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.286238] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.286238] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.287294] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.287294] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.290347] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.290347] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.295060] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.295060] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.298153] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.298153] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.299729] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.299729] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.300021] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.300021] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.301892] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.301892] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.307584] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.307584] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.310893] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.310893] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.320890] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.320890] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.324011] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.324011] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.326616] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.326616] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.328006] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.328006] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.336684] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.336684] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.338536] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.338536] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.341395] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.341395] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.344013] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.344013] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.351867] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.351867] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.354728] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.354728] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.357350] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.357350] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.365888] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.365888] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.368136] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.368136] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.370685] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.370685] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.379222] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.379222] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.381381] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.381381] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.384680] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.384680] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.393456] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.393456] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.396090] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.396090] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.398021] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.398021] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.407246] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.407246] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.409898] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.409898] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.411341] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.411341] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.420527] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.420527] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.422907] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.422907] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.432918] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.432918] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.433860] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.433860] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.435376] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.435376] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.437183] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.437183] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.438542] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.438542] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.440789] ACPI:=20
[    0.440789] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    0.442830] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.442830] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.443346] vgaarb: loaded
[    0.443346] vgaarb: loaded
[    0.443923] vgaarb: bridge control possible 0000:00:02.0
[    0.443923] vgaarb: bridge control possible 0000:00:02.0
[    0.446894] ACPI: bus type USB registered
[    0.446894] ACPI: bus type USB registered
[    0.447850] usbcore: registered new interface driver usbfs
[    0.447850] usbcore: registered new interface driver usbfs
[    0.449070] usbcore: registered new interface driver hub
[    0.449070] usbcore: registered new interface driver hub
[    0.450490] usbcore: registered new device driver usb
[    0.450490] usbcore: registered new device driver usb
[    0.451911] pps_core: LinuxPPS API ver. 1 registered
[    0.451911] pps_core: LinuxPPS API ver. 1 registered
[    0.452968] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.452968] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.453370] PTP clock support registered
[    0.453370] PTP clock support registered
[    0.454245] EDAC MC: Ver: 3.0.0
[    0.454245] EDAC MC: Ver: 3.0.0
[    0.458013] PCI: Using ACPI for IRQ routing
[    0.458013] PCI: Using ACPI for IRQ routing
[    0.458886] PCI: pci_cache_line_size set to 64 bytes
[    0.458886] PCI: pci_cache_line_size set to 64 bytes
[    0.460147] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.460147] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.461377] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.461377] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.463210] irda_init()
[    0.463210] irda_init()
[    0.463428] NET: Registered protocol family 23
[    0.463428] NET: Registered protocol family 23
[    0.464379] Bluetooth: Core ver 2.18
[    0.464379] Bluetooth: Core ver 2.18
[    0.465387] NET: Registered protocol family 31
[    0.465387] NET: Registered protocol family 31
[    0.466679] Bluetooth: HCI device and connection manager initialized
[    0.466679] Bluetooth: HCI device and connection manager initialized
[    0.467992] Bluetooth: HCI socket layer initialized
[    0.467992] Bluetooth: HCI socket layer initialized
[    0.469002] Bluetooth: L2CAP socket layer initialized
[    0.469002] Bluetooth: L2CAP socket layer initialized
[    0.470083] Bluetooth: SCO socket layer initialized
[    0.470083] Bluetooth: SCO socket layer initialized
[    0.471125] NET: Registered protocol family 8
[    0.471125] NET: Registered protocol family 8
[    0.472022] NET: Registered protocol family 20
[    0.472022] NET: Registered protocol family 20
[    0.474093] Switched to clocksource kvm-clock
[    0.474093] Switched to clocksource kvm-clock
[    0.476103] Warning: could not register annotated branches stats
[    0.476103] Warning: could not register annotated branches stats
[    0.499948] FS-Cache: Loaded
[    0.499948] FS-Cache: Loaded
[    0.500670] pnp: PnP ACPI init
[    0.500670] pnp: PnP ACPI init
[    0.501359] ACPI: bus type PNP registered
[    0.501359] ACPI: bus type PNP registered
[    0.502304] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.502304] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.504091] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.504091] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.505516] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.505516] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.507279] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.507279] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.508671] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.508671] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.510472] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.510472] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.511901] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.511901] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.513583] pnp 00:03: [dma 2]
[    0.513583] pnp 00:03: [dma 2]
[    0.514318] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.514318] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.515764] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.515764] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.517536] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.517536] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.518945] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.518945] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.520703] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.520703] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.522465] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.522465] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.524076] pnp: PnP ACPI: found 7 devices
[    0.524076] pnp: PnP ACPI: found 7 devices
[    0.524922] ACPI: bus type PNP unregistered
[    0.524922] ACPI: bus type PNP unregistered
[    0.563321] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.563321] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.565330] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.565330] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.567222] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.567222] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.569392] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.569392] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.571207] NET: Registered protocol family 1
[    0.571207] NET: Registered protocol family 1
[    0.572127] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.572127] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.573398] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.573398] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.574607] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.574607] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.575922] pci 0000:00:02.0: Boot video device
[    0.575922] pci 0000:00:02.0: Boot video device
[    0.576990] PCI: CLS 0 bytes, default 64
[    0.576990] PCI: CLS 0 bytes, default 64
[    0.578467] Unpacking initramfs...
[    0.578467] Unpacking initramfs...
[    0.801603] Freeing initrd memory: 3276K (8fcbd000 - 8fff0000)
[    0.801603] Freeing initrd memory: 3276K (8fcbd000 - 8fff0000)
[    0.803393] Machine check injector initialized
[    0.803393] Machine check injector initialized
[    0.805352] Scanning for low memory corruption every 60 seconds
[    0.805352] Scanning for low memory corruption every 60 seconds
[    0.807245] cryptomgr_test (30) used greatest stack depth: 7472 bytes le=
ft
[    0.807245] cryptomgr_test (30) used greatest stack depth: 7472 bytes le=
ft
[    0.808797] cryptomgr_test (31) used greatest stack depth: 7356 bytes le=
ft
[    0.808797] cryptomgr_test (31) used greatest stack depth: 7356 bytes le=
ft
[    0.812931] PCLMULQDQ-NI instructions are not detected.
[    0.812931] PCLMULQDQ-NI instructions are not detected.
[    0.814156] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    0.814156] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    0.816811] futex hash table entries: 16 (order: -2, 1024 bytes)
[    0.816811] futex hash table entries: 16 (order: -2, 1024 bytes)
[    1.192154] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.192154] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.194254] VFS: Disk quotas dquot_6.5.2
[    1.194254] VFS: Disk quotas dquot_6.5.2
[    1.195197] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.195197] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.197112] fuse init (API version 7.22)
[    1.197112] fuse init (API version 7.22)
[    1.198418] msgmni has been set to 458
[    1.198418] msgmni has been set to 458
[    1.211230] NET: Registered protocol family 38
[    1.211230] NET: Registered protocol family 38
[    1.212201] list_sort_test: start testing list_sort()
[    1.212201] list_sort_test: start testing list_sort()
[    1.213901] test_string_helpers: Running tests...
[    1.213901] test_string_helpers: Running tests...
[    1.215796] hgafb: HGA card not detected.
[    1.215796] hgafb: HGA card not detected.
[    1.216694] hgafb: probe of hgafb.0 failed with error -22
[    1.216694] hgafb: probe of hgafb.0 failed with error -22
[    1.218056] usbcore: registered new interface driver udlfb
[    1.218056] usbcore: registered new interface driver udlfb
[    1.219274] usbcore: registered new interface driver smscufx
[    1.219274] usbcore: registered new interface driver smscufx
[    1.228101] v86d (100) used greatest stack depth: 6968 bytes left
[    1.228101] v86d (100) used greatest stack depth: 6968 bytes left
[    1.230633] uvesafb:=20
[    1.230633] uvesafb: VGABIOS Cirrus extension, VGABIOS Cirrus extension,=
 VGABIOS Cirrus extension, VGABIOS Cirrus extension, 1.0, 1.0, OEM: VGABIOS=
 Cirrus extension, OEM: VGABIOS Cirrus extension, VBE v2.0
VBE v2.0
[    1.237594] uvesafb: NX protection is active, better not use the PMI.
[    1.237594] uvesafb: NX protection is active, better not use the PMI.
[    1.238953] uvesafb: no monitor limits have been set, default refresh ra=
te will be used
[    1.238953] uvesafb: no monitor limits have been set, default refresh ra=
te will be used
[    1.240926] uvesafb: VBE state buffer size cannot be determined (eax=3D0=
x14f, err=3D0)
[    1.240926] uvesafb: VBE state buffer size cannot be determined (eax=3D0=
x14f, err=3D0)
[    1.242542] uvesafb: scrolling: redraw
[    1.242542] uvesafb: scrolling: redraw
[    1.245255] uvesafb: framebuffer at 0xfc000000, mapped to 0x90880000, us=
ing 4096k, total 4096k
[    1.245255] uvesafb: framebuffer at 0xfc000000, mapped to 0x90880000, us=
ing 4096k, total 4096k
[    1.247068] fb0: VESA VGA frame buffer device
[    1.247068] fb0: VESA VGA frame buffer device
[    1.248356] ipmi message handler version 39.2
[    1.248356] ipmi message handler version 39.2
[    1.249366] IPMI System Interface driver.
[    1.249366] IPMI System Interface driver.
[    1.250496] ipmi_si: Adding default-specified kcs state machine
[    1.250496] ipmi_si: Adding default-specified kcs state machine

[    1.251818] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    1.251818] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    1.253930] ipmi_si: Interface detection failed
[    1.253930] ipmi_si: Interface detection failed
[    1.306521] ipmi_si: Adding default-specified smic state machine
[    1.306521] ipmi_si: Adding default-specified smic state machine

[    1.307881] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    1.307881] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    1.310018] ipmi_si: Interface detection failed
[    1.310018] ipmi_si: Interface detection failed
[    1.322511] ------------[ cut here ]------------
[    1.322511] ------------[ cut here ]------------
[    1.323527] WARNING: CPU: 0 PID: 8 at kernel/sched/core.c:2939 rt_mutex_=
setprio+0x646/0x8a3()
[    1.323527] WARNING: CPU: 0 PID: 8 at kernel/sched/core.c:2939 rt_mutex_=
setprio+0x646/0x8a3()
[    1.325721] CPU: 0 PID: 8 Comm: rcub/0 Not tainted 3.14.0-rc3-02058-g0d8=
b92f #2
[    1.325721] CPU: 0 PID: 8 Comm: rcub/0 Not tainted 3.14.0-rc3-02058-g0d8=
b92f #2
[    1.325757]  81f81cc4
[    1.325757]  81f81cc4 8005be24 8005be24 81bdf57a 81bdf57a 00000000 00000=
000 8005be54 8005be54 81075c46 81075c46 81f7fc88 81f7fc88 00000000 00000000

[    1.325757]  00000008
[    1.325757]  00000008 81f81cc4 81f81cc4 00000b7b 00000b7b 810c8a77 810c8=
a77 810c8a77 810c8a77 82042500 82042500 00000001 00000001 8fa6e001 8fa6e001

[    1.325757]  8005be64
[    1.325757]  8005be64 81075dd8 81075dd8 00000009 00000009 00000000 00000=
000 8005be8c 8005be8c 810c8a77 810c8a77 00000000 00000000 82042500 82042500

[    1.325757] Call Trace:
[    1.325757] Call Trace:
[    1.325757]  [<81bdf57a>] dump_stack+0xd7/0x1a2
[    1.325757]  [<81bdf57a>] dump_stack+0xd7/0x1a2
[    1.325757]  [<81075c46>] warn_slowpath_common+0xcd/0x10e
[    1.325757]  [<81075c46>] warn_slowpath_common+0xcd/0x10e
[    1.325757]  [<810c8a77>] ? rt_mutex_setprio+0x646/0x8a3
[    1.325757]  [<810c8a77>] ? rt_mutex_setprio+0x646/0x8a3
[    1.325757]  [<810c8a77>] ? rt_mutex_setprio+0x646/0x8a3
[    1.325757]  [<810c8a77>] ? rt_mutex_setprio+0x646/0x8a3
[    1.325757]  [<81075dd8>] warn_slowpath_null+0x3e/0x4e
[    1.325757]  [<81075dd8>] warn_slowpath_null+0x3e/0x4e
[    1.325757]  [<810c8a77>] rt_mutex_setprio+0x646/0x8a3
[    1.325757]  [<810c8a77>] rt_mutex_setprio+0x646/0x8a3
[    1.325757]  [<810f0c52>] __rt_mutex_adjust_prio+0x40/0xb8
[    1.325757]  [<810f0c52>] __rt_mutex_adjust_prio+0x40/0xb8
[    1.325757]  [<810f1a21>] task_blocks_on_rt_mutex+0x298/0x313
[    1.325757]  [<810f1a21>] task_blocks_on_rt_mutex+0x298/0x313
[    1.325757]  [<81bef49a>] rt_mutex_slowlock+0x127/0x2dd
[    1.325757]  [<81bef49a>] rt_mutex_slowlock+0x127/0x2dd
[    1.325757]  [<81be7915>] ? __schedule+0x82c/0x1310
[    1.325757]  [<81be7915>] ? __schedule+0x82c/0x1310
[    1.325757]  [<81bef6ff>] rt_mutex_lock+0xaf/0xbf
[    1.325757]  [<81bef6ff>] rt_mutex_lock+0xaf/0xbf
[    1.325757]  [<811071e9>] rcu_boost_kthread+0x1e9/0x913
[    1.325757]  [<811071e9>] rcu_boost_kthread+0x1e9/0x913
[    1.325757]  [<81bf0100>] ? alarm_timer_nsleep_restart+0xeb/0xff
[    1.325757]  [<81bf0100>] ? alarm_timer_nsleep_restart+0xeb/0xff
[    1.325757]  [<81107000>] ? rcu_spawn_one_boost_kthread+0x180/0x180
[    1.325757]  [<81107000>] ? rcu_spawn_one_boost_kthread+0x180/0x180
[    1.325757]  [<810af2e0>] kthread+0x115/0x152
[    1.325757]  [<810af2e0>] kthread+0x115/0x152
[    1.325757]  [<810c0000>] ? ftrace_raw_event_sched_process_fork+0x142/0x=
2a1
[    1.325757]  [<810c0000>] ? ftrace_raw_event_sched_process_fork+0x142/0x=
2a1
[    1.325757]  [<81bf2f77>] ret_from_kernel_thread+0x1b/0x28
[    1.325757]  [<81bf2f77>] ret_from_kernel_thread+0x1b/0x28
[    1.325757]  [<810af1cb>] ? __kthread_unpark+0xbd/0xbd
[    1.325757]  [<810af1cb>] ? __kthread_unpark+0xbd/0xbd
[    1.325757] ---[ end trace cc26ae3eefda6bb6 ]---
[    1.325757] ---[ end trace cc26ae3eefda6bb6 ]---
[    1.369842] ipmi_si: Adding default-specified bt state machine
[    1.369842] ipmi_si: Adding default-specified bt state machine

[    1.371159] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    1.371159] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    1.373246] ipmi_si: Interface detection failed
[    1.373246] ipmi_si: Interface detection failed
[    2.369836] ipmi_si: Unable to find any System Interface(s)
[    2.369836] ipmi_si: Unable to find any System Interface(s)
[    2.371075] IPMI Watchdog: driver initialized
[    2.371075] IPMI Watchdog: driver initialized
[    2.371972] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    2.371972] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    2.374111] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    2.374111] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    2.376048] ACPI: Power Button [PWRF]
[    2.376048] ACPI: Power Button [PWRF]
[    2.495631] HDLC line discipline maxframe=3D4096
[    2.495631] HDLC line discipline maxframe=3D4096
[    2.496654] N_HDLC line discipline registered.
[    2.496654] N_HDLC line discipline registered.
[    2.497591] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.497591] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.520939] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    2.520939] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    2.528202] STMicroelectronics ASC driver initialized
[    2.528202] STMicroelectronics ASC driver initialized
[    2.529491] serial: Freescale lpuart driver
[    2.529491] serial: Freescale lpuart driver
[    2.531013] toshiba: not a supported Toshiba laptop
[    2.531013] toshiba: not a supported Toshiba laptop
[    2.532040] nsc_gpio initializing
[    2.532040] nsc_gpio initializing
[    2.532753] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    2.532753] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    2.534215] [drm] Initialized drm 1.1.0 20060810
[    2.534215] [drm] Initialized drm 1.1.0 20060810
[    2.535276] usbcore: registered new interface driver udl
[    2.535276] usbcore: registered new interface driver udl
[    2.536653] dummy-irq: no IRQ given.  Use irq=3DN
[    2.536653] dummy-irq: no IRQ given.  Use irq=3DN
[    2.538049] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    2.538049] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    2.539837] c2port c2port0: C2 port uc added
[    2.539837] c2port c2port0: C2 port uc added
[    2.540729] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    2.540729] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    2.543359] usbcore: registered new interface driver viperboard
[    2.543359] usbcore: registered new interface driver viperboard
[    2.545526] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    2.545526] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    2.547293] platform physmap-flash.0: failed to claim resource 0
[    2.547293] platform physmap-flash.0: failed to claim resource 0
[    2.548618] Could not find PAR responsible for SC520CDP Flash Bank #1
[    2.548618] Could not find PAR responsible for SC520CDP Flash Bank #1
[    2.549965] Trying default address 0x8c00000
[    2.549965] Trying default address 0x8c00000
[    2.550867] SC520 CDP flash device: 0x800000 at 0x8800000
[    2.550867] SC520 CDP flash device: 0x800000 at 0x8800000
[    2.551994] Failed to ioremap_nocache
[    2.551994] Failed to ioremap_nocache
[    2.552769] Failed to ioremap_nocache
[    2.552769] Failed to ioremap_nocache
[    2.553716] slram: not enough parameters.
[    2.553716] slram: not enough parameters.
[    2.595917] No valid DiskOnChip devices found
[    2.595917] No valid DiskOnChip devices found
[    2.597847] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.t=
c.umn.edu>
[    2.597847] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.t=
c.umn.edu>
[    2.601387] ipddp0: Appletalk-IP Encap. mode by Bradford W. Johnson <joh=
ns393@maroon.tc.umn.edu>
[    2.601387] ipddp0: Appletalk-IP Encap. mode by Bradford W. Johnson <joh=
ns393@maroon.tc.umn.edu>
[    2.604655] usbcore: registered new interface driver irda-usb
[    2.604655] usbcore: registered new interface driver irda-usb
[    2.607338] usbcore: registered new interface driver mcs7780
[    2.607338] usbcore: registered new interface driver mcs7780
[    2.609300] usbcore: registered new interface driver kingsun-sir
[    2.609300] usbcore: registered new interface driver kingsun-sir
[    2.611527] usbcore: registered new interface driver ks959-sir
[    2.611527] usbcore: registered new interface driver ks959-sir
[    2.614849] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.614849] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.617226] ehci-pci: EHCI PCI platform driver
[    2.617226] ehci-pci: EHCI PCI platform driver
[    2.618932] ehci-platform: EHCI generic platform driver
[    2.618932] ehci-platform: EHCI generic platform driver
[    2.621114] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.621114] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.623438] ohci-pci: OHCI PCI platform driver
[    2.623438] ohci-pci: OHCI PCI platform driver
[    2.625106] ohci-platform: OHCI generic platform driver
[    2.625106] ohci-platform: OHCI generic platform driver
[    2.627844] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    2.627844] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    2.630042] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[    2.630042] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[    2.633512] usbcore: registered new interface driver cdc_acm
[    2.633512] usbcore: registered new interface driver cdc_acm
[    2.635476] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    2.635476] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    2.638382] usbcore: registered new interface driver cdc_wdm
[    2.638382] usbcore: registered new interface driver cdc_wdm
[    2.640474] usbcore: registered new interface driver usbtmc
[    2.640474] usbcore: registered new interface driver usbtmc
[    2.642489] usbcore: registered new interface driver mdc800
[    2.642489] usbcore: registered new interface driver mdc800
[    2.644507] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    2.644507] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    2.649113] usbcore: registered new interface driver appledisplay
[    2.649113] usbcore: registered new interface driver appledisplay
[    2.651397] usbcore: registered new interface driver cytherm
[    2.651397] usbcore: registered new interface driver cytherm
[    2.653552] usbcore: registered new interface driver iowarrior
[    2.653552] usbcore: registered new interface driver iowarrior
[    2.655639] usbcore: registered new interface driver isight_firmware
[    2.655639] usbcore: registered new interface driver isight_firmware
[    2.658017] usbcore: registered new interface driver usblcd
[    2.658017] usbcore: registered new interface driver usblcd
[    2.660069] usbcore: registered new interface driver usbled
[    2.660069] usbcore: registered new interface driver usbled
[    2.662112] usbcore: registered new interface driver legousbtower
[    2.662112] usbcore: registered new interface driver legousbtower
[    2.666392] usbcore: registered new interface driver usbtest
[    2.666392] usbcore: registered new interface driver usbtest
[    2.668486] usbcore: registered new interface driver trancevibrator
[    2.668486] usbcore: registered new interface driver trancevibrator
[    2.670800] usbcore: registered new interface driver yurex
[    2.670800] usbcore: registered new interface driver yurex
[    2.674441] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    2.674441] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    2.678566] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.678566] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.680535] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.680535] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.771183] mousedev: PS/2 mouse device common for all mice
[    2.771183] mousedev: PS/2 mouse device common for all mice
[    2.773170] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    2.773170] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    2.776797] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    2.776797] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    2.778621] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    2.778621] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    2.781660] usbcore: registered new interface driver xpad
[    2.781660] usbcore: registered new interface driver xpad
[    2.783018] cm109: Keymap for Komunikate KIP1000 phone loaded
[    2.783018] cm109: Keymap for Komunikate KIP1000 phone loaded
[    2.784379] usbcore: registered new interface driver cm109
[    2.784379] usbcore: registered new interface driver cm109
[    2.786077] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    2.786077] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    2.788582] usbcore: registered new interface driver ims_pcu
[    2.788582] usbcore: registered new interface driver ims_pcu
[    2.790641] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    2.790641] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    2.792014] evbug: Connected device: input3 (PC Speaker at isa0061/input=
0)
[    2.792014] evbug: Connected device: input3 (PC Speaker at isa0061/input=
0)
[    2.793588] usbcore: registered new interface driver powermate
[    2.793588] usbcore: registered new interface driver powermate
[    2.795430] usbcore: registered new interface driver yealink
[    2.795430] usbcore: registered new interface driver yealink
[    2.796634] ideapad_slidebar: DMI does not match
[    2.796634] ideapad_slidebar: DMI does not match
[    2.803014] rtc rtc0: test: dev (254:0)
[    2.803014] rtc rtc0: test: dev (254:0)
[    2.803830] rtc-test rtc-test.0: rtc core: registered test as rtc0
[    2.803830] rtc-test rtc-test.0: rtc core: registered test as rtc0
[    2.805652] rtc rtc1: test: dev (254:1)
[    2.805652] rtc rtc1: test: dev (254:1)
[    2.806505] rtc-test rtc-test.1: rtc core: registered test as rtc1
[    2.806505] rtc-test rtc-test.1: rtc core: registered test as rtc1
[    2.808079] i2c /dev entries driver
[    2.808079] i2c /dev entries driver
[    2.809285] usbcore: registered new interface driver i2c-diolan-u2c
[    2.809285] usbcore: registered new interface driver i2c-diolan-u2c
[    2.810688] usbcore: registered new interface driver RobotFuzz Open Sour=
ce InterFace, OSIF
[    2.810688] usbcore: registered new interface driver RobotFuzz Open Sour=
ce InterFace, OSIF
[    2.812581] usbcore: registered new interface driver i2c-tiny-usb
[    2.812581] usbcore: registered new interface driver i2c-tiny-usb
[    2.814093] Driver for 1-wire Dallas network protocol.
[    2.814093] Driver for 1-wire Dallas network protocol.
[    2.815451] usbcore: registered new interface driver DS9490R
[    2.815451] usbcore: registered new interface driver DS9490R
[    2.816715] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    2.816715] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    2.823019] pc87360: PC8736x not detected, module not inserted
[    2.823019] pc87360: PC8736x not detected, module not inserted
[    2.825107] Bluetooth: Virtual HCI driver ver 1.4
[    2.825107] Bluetooth: Virtual HCI driver ver 1.4
[    2.826464] usbcore: registered new interface driver bcm203x
[    2.826464] usbcore: registered new interface driver bcm203x
[    2.827707] usbcore: registered new interface driver bpa10x
[    2.827707] usbcore: registered new interface driver bpa10x
[    2.828942] usbcore: registered new interface driver bfusb
[    2.828942] usbcore: registered new interface driver bfusb
[    2.830205] usbcore: registered new interface driver btusb
[    2.830205] usbcore: registered new interface driver btusb
[    2.831407] usbcore: registered new interface driver ath3k
[    2.831407] usbcore: registered new interface driver ath3k
[    2.832655] lguest: mapped switcher at ffa8f000
[    2.832655] lguest: mapped switcher at ffa8f000
[    2.834079] sdhci: Secure Digital Host Controller Interface driver
[    2.834079] sdhci: Secure Digital Host Controller Interface driver
[    2.835373] sdhci: Copyright(c) Pierre Ossman
[    2.835373] sdhci: Copyright(c) Pierre Ossman
[    2.836464] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0400
[    2.836464] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0400

[    2.839906] usbcore: registered new interface driver vub300
[    2.839906] usbcore: registered new interface driver vub300
[    2.841240] usbcore: registered new interface driver ushc
[    2.841240] usbcore: registered new interface driver ushc
[    2.842362] sdhci-pltfm: SDHCI platform and OF driver helper
[    2.842362] sdhci-pltfm: SDHCI platform and OF driver helper
[    2.845626] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    2.845626] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    2.850767] usbcore: registered new interface driver usbhid
[    2.850767] usbcore: registered new interface driver usbhid
[    2.851928] usbhid: USB HID core driver
[    2.851928] usbhid: USB HID core driver
[    2.853118] usbcore: registered new interface driver tranzport
[    2.853118] usbcore: registered new interface driver tranzport
[    2.854410] usbcore: registered new interface driver alphatrack
[    2.854410] usbcore: registered new interface driver alphatrack
[    2.856917] beceem: Beceem Communications Inc. WiMAX driver, 5.2.45
[    2.856917] beceem: Beceem Communications Inc. WiMAX driver, 5.2.45
[    2.858243] Copyright 2010. Beceem Communications Inc
[    2.858243] Copyright 2010. Beceem Communications Inc
[    2.859409] usbcore: registered new interface driver usbbcm
[    2.859409] usbcore: registered new interface driver usbbcm
[    2.860659] usbcore: registered new interface driver ft1000usb
[    2.860659] usbcore: registered new interface driver ft1000usb
[    2.862506] ozwpan ozwpan: Ozmo Devices WPAN
[    2.862506] ozwpan ozwpan: Ozmo Devices WPAN
[    2.863736] ozwpan ozwpan: new USB bus registered, assigned bus number 1
[    2.863736] ozwpan ozwpan: new USB bus registered, assigned bus number 1
[    2.866255] hub 1-0:1.0: USB hub found
[    2.866255] hub 1-0:1.0: USB hub found
[    2.867111] hub 1-0:1.0: 8 ports detected
[    2.867111] hub 1-0:1.0: 8 ports detected
[    2.869477] dgap:=20
[    2.869477] dgap: dgap-1.3-16, Digi International Part Number 40002347_C
dgap-1.3-16, Digi International Part Number 40002347_C
[    2.870922] dgap:=20
[    2.870922] dgap: For the tools package or updated drivers please visit =
http://www.digi.com
For the tools package or updated drivers please visit http://www.digi.com
[    2.873277] hdaps: supported laptop not found!
[    2.873277] hdaps: supported laptop not found!
[    2.874219] hdaps: driver init failed (ret=3D-19)!
[    2.874219] hdaps: driver init failed (ret=3D-19)!
[    2.875248] goldfish_pdev_bus goldfish_pdev_bus: unable to reserve Goldf=
ish MMIO.
[    2.875248] goldfish_pdev_bus goldfish_pdev_bus: unable to reserve Goldf=
ish MMIO.
[    2.876825] goldfish_pdev_bus: probe of goldfish_pdev_bus failed with er=
ror -16
[    2.876825] goldfish_pdev_bus: probe of goldfish_pdev_bus failed with er=
ror -16
[    2.880436] oprofile: using timer interrupt.
[    2.880436] oprofile: using timer interrupt.
[    2.881522] NET: Registered protocol family 26
[    2.881522] NET: Registered protocol family 26
[    2.883051] netem: version 1.3
[    2.883051] netem: version 1.3
[    2.883767] NET: Registered protocol family 17
[    2.883767] NET: Registered protocol family 17
[   21.852235] INFO: rcu_preempt detected stalls on CPUs/tasks:
[   21.852235] INFO: rcu_preempt detected stalls on CPUs/tasks: { {} } (det=
ected by 0, t=3D6302 jiffies, g=3D4294967034, c=3D4294967033, q=3D120)
(detected by 0, t=3D6302 jiffies, g=3D4294967034, c=3D4294967033, q=3D120)
[   21.852235] INFO: Stall ended before state dump start
[   21.852235] INFO: Stall ended before state dump start
[   84.881373] INFO: rcu_preempt detected stalls on CPUs/tasks:
[   84.881373] INFO: rcu_preempt detected stalls on CPUs/tasks: { {} } (det=
ected by 0, t=3D25207 jiffies, g=3D4294967034, c=3D4294967033, q=3D120)
(detected by 0, t=3D25207 jiffies, g=3D4294967034, c=3D4294967033, q=3D120)
[   84.881373] INFO: Stall ended before state dump start
[   84.881373] INFO: Stall ended before state dump start
[  147.890488] INFO: rcu_preempt detected stalls on CPUs/tasks:
[  147.890488] INFO: rcu_preempt detected stalls on CPUs/tasks: { {} } (det=
ected by 0, t=3D44112 jiffies, g=3D4294967034, c=3D4294967033, q=3D120)
(detected by 0, t=3D44112 jiffies, g=3D4294967034, c=3D4294967033, q=3D120)
[  147.890488] INFO: Stall ended before state dump start
[  147.890488] INFO: Stall ended before state dump start
[  210.949597] INFO: rcu_preempt detected stalls on CPUs/tasks:
[  210.949597] INFO: rcu_preempt detected stalls on CPUs/tasks: { {} } (det=
ected by 0, t=3D63017 jiffies, g=3D4294967034, c=3D4294967033, q=3D120)
(detected by 0, t=3D63017 jiffies, g=3D4294967034, c=3D4294967033, q=3D120)
[  210.949597] INFO: Stall ended before state dump start
[  210.949597] INFO: Stall ended before state dump start
[  241.288436] INFO: task swapper/0:1 blocked for more than 120 seconds.
[  241.288436] INFO: task swapper/0:1 blocked for more than 120 seconds.
[  241.290845]       Tainted: G        W    3.14.0-rc3-02058-g0d8b92f #2
[  241.290845]       Tainted: G        W    3.14.0-rc3-02058-g0d8b92f #2
[  241.293317] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[  241.293317] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[  241.296192] swapper/0       D
[  241.296192] swapper/0       D 823517e0  823517e0  5712     1      0 0x00=
000000
 5712     1      0 0x00000000
[  241.298593]  80039e10
[  241.298593]  80039e10 00000046 00000046 00000006 00000006 823517e0 82351=
7e0 00000000 00000000 7dcae81f 7dcae81f 80038000 80038000 81f7dca2 81f7dca2

[  241.301690]  aa3e4ba5
[  241.301690]  aa3e4ba5 00000000 00000000 8e423550 8e423550 8002ba90 8002b=
a90 00000000 00000000 00000000 00000000 00000001 00000001 00000000 00000000

[  241.307468]  00000032
[  241.307468]  00000032 80039df4 80039df4 810c7db8 810c7db8 814cdcc2 814cd=
cc2 00000000 00000000 00000000 00000000 00000000 00000000 00000001 00000001

[  241.310609] Call Trace:
[  241.310609] Call Trace:
[  241.311555]  [<810c7db8>] ? preempt_count_sub+0x230/0x245
[  241.311555]  [<810c7db8>] ? preempt_count_sub+0x230/0x245
[  241.313818]  [<814cdcc2>] ? serial8250_console_putchar+0x3d/0x4f
[  241.313818]  [<814cdcc2>] ? serial8250_console_putchar+0x3d/0x4f
[  241.316064]  [<810c7db8>] ? preempt_count_sub+0x230/0x245
[  241.316064]  [<810c7db8>] ? preempt_count_sub+0x230/0x245
[  241.318066]  [<810c7afb>] ? preempt_count_add+0xad/0x13a
[  241.318066]  [<810c7afb>] ? preempt_count_add+0xad/0x13a
[  241.320071]  [<81be841c>] schedule+0x23/0x33
[  241.320071]  [<81be841c>] schedule+0x23/0x33
[  241.321747]  [<81be691e>] schedule_timeout+0x2be/0x3d0
[  241.321747]  [<81be691e>] schedule_timeout+0x2be/0x3d0
[  241.323738]  [<810c7db8>] ? preempt_count_sub+0x230/0x245
[  241.323738]  [<810c7db8>] ? preempt_count_sub+0x230/0x245
[  241.325752]  [<81be95f3>] wait_for_common+0xd9/0x268
[  241.325752]  [<81be95f3>] wait_for_common+0xd9/0x268
[  241.327510]  [<810cc7c5>] ? try_to_wake_up+0x517/0x517
[  241.327510]  [<810cc7c5>] ? try_to_wake_up+0x517/0x517
[  241.329412]  [<81be9944>] wait_for_completion+0x25/0x35
[  241.329412]  [<81be9944>] wait_for_completion+0x25/0x35
[  241.331313]  [<8110df49>] _rcu_barrier+0x42b/0x5c2
[  241.331313]  [<8110df49>] _rcu_barrier+0x42b/0x5c2
[  241.333238]  [<81110ad4>] rcu_barrier+0x20/0x30
[  241.333238]  [<81110ad4>] rcu_barrier+0x20/0x30
[  241.334920]  [<819d5250>] register_pernet_operations+0x1ed/0x268
[  241.334920]  [<819d5250>] register_pernet_operations+0x1ed/0x268
[  241.337144]  [<82298df3>] ? unix_diag_init+0x2b/0x2b
[  241.337144]  [<82298df3>] ? unix_diag_init+0x2b/0x2b
[  241.338995]  [<819d5d15>] register_pernet_subsys+0x3d/0x6a
[  241.338995]  [<819d5d15>] register_pernet_subsys+0x3d/0x6a
[  241.340996]  [<82298e55>] packet_init+0x62/0x8d
[  241.340996]  [<82298e55>] packet_init+0x62/0x8d
[  241.342746]  [<822198a6>] do_one_initcall+0x101/0x28f
[  241.342746]  [<822198a6>] do_one_initcall+0x101/0x28f
[  241.344768]  [<810abbf9>] ? parameq+0x26/0xef
[  241.344768]  [<810abbf9>] ? parameq+0x26/0xef
[  241.346448]  [<8137862e>] ? strlen+0x9/0x3a
[  241.346448]  [<8137862e>] ? strlen+0x9/0x3a
[  241.347987]  [<82218700>] ? do_early_param+0xfa/0x131
[  241.347987]  [<82218700>] ? do_early_param+0xfa/0x131
[  241.349859]  [<810abf9c>] ? parse_args+0x2da/0x5c7
[  241.349859]  [<810abf9c>] ? parse_args+0x2da/0x5c7
[  241.351504]  [<81bf0f9c>] ? _raw_spin_unlock_irqrestore+0xba/0x12c
[  241.351504]  [<81bf0f9c>] ? _raw_spin_unlock_irqrestore+0xba/0x12c
[  241.353903]  [<82219c7a>] kernel_init_freeable+0x246/0x3bb
[  241.353903]  [<82219c7a>] kernel_init_freeable+0x246/0x3bb
[  241.355971]  [<82218737>] ? do_early_param+0x131/0x131
[  241.355971]  [<82218737>] ? do_early_param+0x131/0x131
[  241.357866]  [<81bd417b>] kernel_init+0x1e/0x219
[  241.357866]  [<81bd417b>] kernel_init+0x1e/0x219
[  241.359599]  [<81bf2f77>] ret_from_kernel_thread+0x1b/0x28
[  241.359599]  [<81bf2f77>] ret_from_kernel_thread+0x1b/0x28
[  241.361599]  [<81bd415d>] ? rest_init+0x121/0x121
[  241.361599]  [<81bd415d>] ? rest_init+0x121/0x121
[  241.363486] sending NMI to all CPUs:
[  241.363486] sending NMI to all CPUs:
[  241.364857] NMI backtrace for cpu 1
[  241.364857] NMI backtrace for cpu 1
[  241.366161] CPU: 1 PID: 43 Comm: khungtaskd Tainted: G        W    3.14.=
0-rc3-02058-g0d8b92f #2
[  241.366161] CPU: 1 PID: 43 Comm: khungtaskd Tainted: G        W    3.14.=
0-rc3-02058-g0d8b92f #2
[  241.366801] task: 8f28e550 ti: 8e4cc000 task.ti: 8e4cc000
[  241.366801] task: 8f28e550 ti: 8e4cc000 task.ti: 8e4cc000
[  241.366801] EIP: 0060:[<81046109>] EFLAGS: 00010046 CPU: 1
[  241.366801] EIP: 0060:[<81046109>] EFLAGS: 00010046 CPU: 1
[  241.366801] EIP is at default_send_IPI_mask_logical+0x1a8/0x29d
[  241.366801] EIP is at default_send_IPI_mask_logical+0x1a8/0x29d
[  241.366801] EAX: fffff000 EBX: 03000000 ECX: 00000000 EDX: fffff000
[  241.366801] EAX: fffff000 EBX: 03000000 ECX: 00000000 EDX: fffff000
[  241.366801] ESI: 00000801 EDI: 00000c00 EBP: 8e4cdf0c ESP: 8e4cdef8
[  241.366801] ESI: 00000801 EDI: 00000c00 EBP: 8e4cdf0c ESP: 8e4cdef8
[  241.366801]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  241.366801]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  241.366801] CR0: 8005003b CR2: 47f12014 CR3: 022e3000 CR4: 00000630
[  241.366801] CR0: 8005003b CR2: 47f12014 CR3: 022e3000 CR4: 00000630
[  241.366801] Stack:
[  241.366801] Stack:
[  241.366801]  00000800
[  241.366801]  00000800 00000246 00000246 00002710 00002710 00007fff 00007=
fff 000003ff 000003ff 8e4cdf18 8e4cdf18 81046389 81046389 00002710 00002710

[  241.366801]  8e4cdf28
[  241.366801]  8e4cdf28 8104672b 8104672b 81f71204 81f71204 8002ba90 8002b=
a90 8e4cdf6c 8e4cdf6c 8113e6ee 8113e6ee 81f859c8 81f859c8 82321084 82321084

[  241.366801]  82041d46
[  241.366801]  82041d46 00000002 00000002 82041d87 82041d87 00000078 00000=
078 000002a3 000002a3 000003a2 000003a2 00000002 00000002 8002bc20 8002bc20

[  241.366801] Call Trace:
[  241.366801] Call Trace:
[  241.366801]  [<81046389>] default_send_IPI_all+0xaf/0xc0
[  241.366801]  [<81046389>] default_send_IPI_all+0xaf/0xc0
[  241.366801]  [<8104672b>] arch_trigger_all_cpu_backtrace+0x8c/0x116
[  241.366801]  [<8104672b>] arch_trigger_all_cpu_backtrace+0x8c/0x116
[  241.366801]  [<8113e6ee>] watchdog+0x70d/0x77a
[  241.366801]  [<8113e6ee>] watchdog+0x70d/0x77a
[  241.366801]  [<8113dfe1>] ? hung_task_panic+0x24/0x24
[  241.366801]  [<8113dfe1>] ? hung_task_panic+0x24/0x24
[  241.366801]  [<810af2e0>] kthread+0x115/0x152
[  241.366801]  [<810af2e0>] kthread+0x115/0x152
[  241.366801]  [<810c0000>] ? ftrace_raw_event_sched_process_fork+0x142/0x=
2a1
[  241.366801]  [<810c0000>] ? ftrace_raw_event_sched_process_fork+0x142/0x=
2a1
[  241.366801]  [<81bf2f77>] ret_from_kernel_thread+0x1b/0x28
[  241.366801]  [<81bf2f77>] ret_from_kernel_thread+0x1b/0x28
[  241.366801]  [<810af1cb>] ? __kthread_unpark+0xbd/0xbd
[  241.366801]  [<810af1cb>] ? __kthread_unpark+0xbd/0xbd
[  241.366801] Code:
[  241.366801] Code: 00 00 c1 c1 e3 e3 18 18 89 89 98 98 10 10 c3 c3 ff ff =
ff ff 83 83 ff ff 02 02 74 74 65 65 0b 0b 7d 7d ec ec 83 83 05 05 28 28 d0 =
d0 30 30 82 82 01 01 83 83 15 15 2c 2c d0 d0 30 30 82 82 00 00 a1 a1 f0 f0 =
64 64 05 05 82 82 89 89 b8 b8 00 00 c3 c3 ff ff ff ff <f7> <f7> 45 45 f0 f0=
 00 00 02 02 00 00 00 00 74 74 59 59 83 83 05 05 40 40 d0 d0 30 30 82 82 01=
 01 83 83 15 15 44 44 d0 d0 30 30

[  241.366801] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 54.090 msecs
[  241.366801] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 54.090 msecs
[  241.367676] NMI backtrace for cpu 0
[  241.367676] NMI backtrace for cpu 0
[  241.367676] CPU: 0 PID: 45 Comm: rb_producer Tainted: G        W    3.14=
=2E0-rc3-02058-g0d8b92f #2
[  241.367676] CPU: 0 PID: 45 Comm: rb_producer Tainted: G        W    3.14=
=2E0-rc3-02058-g0d8b92f #2
[  241.367676] task: 8e423010 ti: 8e6c0000 task.ti: 8e6c0000
[  241.367676] task: 8e423010 ti: 8e6c0000 task.ti: 8e6c0000
[  241.367676] EIP: 0060:[<81147ef0>] EFLAGS: 00000202 CPU: 0
[  241.367676] EIP: 0060:[<81147ef0>] EFLAGS: 00000202 CPU: 0
[  241.367676] EIP is at rb_update_write_stamp+0x3a/0xe2
[  241.367676] EIP is at rb_update_write_stamp+0x3a/0xe2
[  241.367676] EAX: 8e409a40 EBX: 000008bc ECX: 8e524000 EDX: 8e5248bc
[  241.367676] EAX: 8e409a40 EBX: 000008bc ECX: 8e524000 EDX: 8e5248bc
[  241.367676] ESI: 8f28f800 EDI: 8e5248bc EBP: 8e6c1ef0 ESP: 8e6c1ee4
[  241.367676] ESI: 8f28f800 EDI: 8e5248bc EBP: 8e6c1ef0 ESP: 8e6c1ee4
[  241.367676]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  241.367676]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  241.367676] CR0: 8005003b CR2: 08052680 CR3: 0e77b000 CR4: 00000630
[  241.367676] CR0: 8005003b CR2: 08052680 CR3: 0e77b000 CR4: 00000630
[  241.367676] Stack:
[  241.367676] Stack:
[  241.367676]  8e409a40 8f28f800 8e5248bc 8e6c1f04 81148295 8e409a40 8f28f=
800 8e5248bc
[  241.367676]  8e409a40 8f28f800 8e5248bc 8e6c1f04 81148295 8e409a40 8f28f=
800 8e5248bc
[  241.367676]  8e6c1f14 8114bb60 0000002f 8e5248c0 8e6c1f6c 8114e8c5 8114e=
dd5 81f7ead8
[  241.367676]  8e6c1f14 8114bb60 0000002f 8e5248c0 8e6c1f6c 8114e8c5 8114e=
dd5 81f7ead8
[  241.367676]  0000017e 00000000 8e423010 8e423010 00000000 00000000 00002=
3de 00000000
[  241.367676]  0000017e 00000000 8e423010 8e423010 00000000 00000000 00002=
3de 00000000
[  241.367676] Call Trace:
[  241.367676] Call Trace:
[  241.367676]  [<81148295>] rb_commit+0x2c/0x13b
[  241.367676]  [<81148295>] rb_commit+0x2c/0x13b
[  241.367676]  [<8114bb60>] ring_buffer_unlock_commit+0x29/0x136
[  241.367676]  [<8114bb60>] ring_buffer_unlock_commit+0x29/0x136
[  241.367676]  [<8114e8c5>] ring_buffer_producer_thread+0x1a5/0x9e3
[  241.367676]  [<8114e8c5>] ring_buffer_producer_thread+0x1a5/0x9e3
[  241.367676]  [<8114edd5>] ? ring_buffer_producer_thread+0x6b5/0x9e3
[  241.367676]  [<8114edd5>] ? ring_buffer_producer_thread+0x6b5/0x9e3
[  241.367676]  [<8114e720>] ? wait_to_die+0xaf/0xaf
[  241.367676]  [<8114e720>] ? wait_to_die+0xaf/0xaf
[  241.367676]  [<810af2e0>] kthread+0x115/0x152
[  241.367676]  [<810af2e0>] kthread+0x115/0x152
[  241.367676]  [<810c0000>] ? ftrace_raw_event_sched_process_fork+0x142/0x=
2a1
[  241.367676]  [<810c0000>] ? ftrace_raw_event_sched_process_fork+0x142/0x=
2a1
[  241.367676]  [<81bf2f77>] ret_from_kernel_thread+0x1b/0x28
[  241.367676]  [<81bf2f77>] ret_from_kernel_thread+0x1b/0x28
[  241.367676]  [<810af1cb>] ? __kthread_unpark+0xbd/0xbd
[  241.367676]  [<810af1cb>] ? __kthread_unpark+0xbd/0xbd
[  241.367676] Code: 48 20 55 89 e5 57 56 53 8b 49 18 89 d3 81 e3 00 f0 ff =
ff 39 d9 74 05 5b 5e 5f 5d c3 89 d3 81 e3 ff 0f 00 00 83 05 68 3b 39 82 01 =
<83> 15 6c 3b 39 82 00 8b 71 08 8d 7b f4 39 f7 74 13 83 05 70 3b
[  241.367676] Code: 48 20 55 89 e5 57 56 53 8b 49 18 89 d3 81 e3 00 f0 ff =
ff 39 d9 74 05 5b 5e 5f 5d c3 89 d3 81 e3 ff 0f 00 00 83 05 68 3b 39 82 01 =
<83> 15 6c 3b 39 82 00 8b 71 08 8d 7b f4 39 f7 74 13 83 05 70 3b
[  241.367676] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 54.348 msecs
[  241.367676] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 54.348 msecs
[  241.454130] Kernel panic - not syncing: hung_task: blocked tasks
[  241.454130] Kernel panic - not syncing: hung_task: blocked tasks
[  241.455405] CPU: 1 PID: 43 Comm: khungtaskd Tainted: G        W    3.14.=
0-rc3-02058-g0d8b92f #2
[  241.455405] CPU: 1 PID: 43 Comm: khungtaskd Tainted: G        W    3.14.=
0-rc3-02058-g0d8b92f #2
[  241.457224]  00007fff
[  241.457224]  00007fff 8e4cdf08 8e4cdf08 81bdf57a 81bdf57a 8002ba90 8002b=
a90 8e4cdf28 8e4cdf28 81bd9fe0 81bd9fe0 81f7fbec 81f7fbec 823210a0 823210a0

[  241.457434]  8e4cdf28
[  241.457434]  8e4cdf28 8002ba90 8002ba90 00007fff 00007fff 000003ff 00000=
3ff 8e4cdf6c 8e4cdf6c 8113e708 8113e708 81f7e91f 81f7e91f 82321084 82321084

[  241.457434]  82041d46
[  241.457434]  82041d46 00000002 00000002 82041d87 82041d87 00000078 00000=
078 000002a3 000002a3 000003a2 000003a2 00000002 00000002 8002bc20 8002bc20

[  241.457434] Call Trace:
[  241.457434] Call Trace:
[  241.457434]  [<81bdf57a>] dump_stack+0xd7/0x1a2
[  241.457434]  [<81bdf57a>] dump_stack+0xd7/0x1a2
[  241.457434]  [<81bd9fe0>] panic+0x136/0x366
[  241.457434]  [<81bd9fe0>] panic+0x136/0x366
[  241.457434]  [<8113e708>] watchdog+0x727/0x77a
[  241.457434]  [<8113e708>] watchdog+0x727/0x77a
[  241.457434]  [<8113dfe1>] ? hung_task_panic+0x24/0x24
[  241.457434]  [<8113dfe1>] ? hung_task_panic+0x24/0x24
[  241.457434]  [<810af2e0>] kthread+0x115/0x152
[  241.457434]  [<810af2e0>] kthread+0x115/0x152
[  241.457434]  [<810c0000>] ? ftrace_raw_event_sched_process_fork+0x142/0x=
2a1
[  241.457434]  [<810c0000>] ? ftrace_raw_event_sched_process_fork+0x142/0x=
2a1
[  241.457434]  [<81bf2f77>] ret_from_kernel_thread+0x1b/0x28
[  241.457434]  [<81bf2f77>] ret_from_kernel_thread+0x1b/0x28
[  241.457434]  [<810af1cb>] ? __kthread_unpark+0xbd/0xbd
[  241.457434]  [<810af1cb>] ? __kthread_unpark+0xbd/0xbd
[  241.457434] Kernel Offset: 0x0 from 0x81000000 (relocation range: 0x8000=
0000-0x907fdfff)
[  241.457434] Kernel Offset: 0x0 from 0x81000000 (relocation range: 0x8000=
0000-0x907fdfff)
[  241.457434] Rebooting in 10 seconds..
[  241.457434] Rebooting in 10 seconds..
Elapsed time: 245
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-a=
n0-02190423/0d8b92f526636f83e3e9a295a5a0ee1a2bdcb09d/vmlinuz-3.14.0-rc3-020=
58-g0d8b92f -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug a=
pic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=3D1 nmi_watchd=
og=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3D=
normal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/i386-randcon=
fig-an0-02190423/linux-devel:devel-hourly-2014021904/.vmlinuz-0d8b92f526636=
f83e3e9a295a5a0ee1a2bdcb09d-20140219054112-4-snb branch=3Dlinux-devel/devel=
-hourly-2014021904 BOOT_IMAGE=3D/kernel/i386-randconfig-an0-02190423/0d8b92=
f526636f83e3e9a295a5a0ee1a2bdcb09d/vmlinuz-3.14.0-rc3-02058-g0d8b92f'  -ini=
trd /kernel-tests/initrd/yocto-minimal-i386.cgz -m 256 -smp 2 -net nic,vlan=
=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::5538-:22 -boot order=
=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs=
/LABEL=3DKVM/disk0-yocto-snb-39,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/=
LABEL=3DKVM/disk1-yocto-snb-39,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/L=
ABEL=3DKVM/disk2-yocto-snb-39,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LA=
BEL=3DKVM/disk3-yocto-snb-39,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LAB=
EL=3DKVM/disk4-yocto-snb-39,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABE=
L=3DKVM/disk5-yocto-snb-39,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot=
/pid-yocto-snb-39 -serial file:/dev/shm/kboot/serial-yocto-snb-39 -daemoniz=
e -display none -monitor null=20

--V0207lvV8h4k8FAm
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-an0-02190423-0d8b92f526636f83e3e9a295a5a0ee1a2bdcb09d-WARNING:----at----rt_mutex_setprio+-x-113920.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDZkMGFiZWNhMzI0MmE4OGNhYjgyMzJlNGFjZDdlMmJmMDg4ZjNiYzIK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1hbjAt
MDIxOTA0MjMvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMjE5MDQ6NmQwYWJlY2Ez
MjQyYTg4Y2FiODIzMmU0YWNkN2UyYmYwODhmM2JjMjpiaXNlY3QtbGludXgzCgoyMDE0LTAy
LTE5LTA2OjExOjQ2IDZkMGFiZWNhMzI0MmE4OGNhYjgyMzJlNGFjZDdlMmJmMDg4ZjNiYzIg
cmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4wLTAyMTkwNDIzLzZkMGFiZWNhMzI0
MmE4OGNhYjgyMzJlNGFjZDdlMmJmMDg4ZjNiYzIvdm1saW51ei0zLjE0LjAtcmMzCgoyMDE0
LTAyLTE5LTA2OjExOjQ2IGRldGVjdGluZyBib290IHN0YXRlIC4uCTEJMTkJMjMuCTI1CTI3
CTI4IFNVQ0NFU1MKCmJpc2VjdDogZ29vZCBjb21taXQgNmQwYWJlY2EzMjQyYTg4Y2FiODIz
MmU0YWNkN2UyYmYwODhmM2JjMgpnaXQgYmlzZWN0IHN0YXJ0IDBkOGI5MmY1MjY2MzZmODNl
M2U5YTI5NWE1YTBlZTFhMmJkY2IwOWQgNmQwYWJlY2EzMjQyYTg4Y2FiODIzMmU0YWNkN2Uy
YmYwODhmM2JjMiAtLQovYy9rZXJuZWwtdGVzdHMvbGluZWFyLWJpc2VjdDogWyItYiIsICIw
ZDhiOTJmNTI2NjM2ZjgzZTNlOWEyOTVhNWEwZWUxYTJiZGNiMDlkIiwgIi1nIiwgIjZkMGFi
ZWNhMzI0MmE4OGNhYjgyMzJlNGFjZDdlMmJmMDg4ZjNiYzIiLCAiL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCIsICIva2VybmVsLXRlc3RzL2xpbnV4My9v
YmotYmlzZWN0Il0KQmlzZWN0aW5nOiAyMDU4IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0
ZXIgdGhpcyAocm91Z2hseSAxMiBzdGVwcykKWzdmM2I0OGViMTNjMWQ1ZGFlZTNmN2M5M2Mw
ZjY5NzUxYjljM2NlODVdIE1lcmdlICdoaWQvZm9yLW5leHQnIGludG8gZGV2ZWwtaG91cmx5
LTIwMTQwMjE5MDQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXgzL29iai1iaXNlY3QKbHMgLWEgL2tlcm5l
bC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1hbjAtMDIxOTA0MjMvbGlu
dXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMjE5MDQ6N2YzYjQ4ZWIxM2MxZDVkYWVlM2Y3
YzkzYzBmNjk3NTFiOWMzY2U4NTpiaXNlY3QtbGludXgzCjIwMTQtMDItMTkgMDY6MTY6MTk6
IGNtZF9mYWlsOiAnL2Jpbi9ncmVwJyAnLXInICctLWluY2x1ZGU9ZG1lc2ctKicgJy1zJyAn
LWwnICdXQVJOSU5HOiAuKiBhdCAuKiBydF9tdXRleF9zZXRwcmlvKzB4JyAnL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYW4wLTAyMTkwNDIzLzdmM2I0OGViMTNjMWQ1ZGFlZTNmN2M5M2Mw
ZjY5NzUxYjljM2NlODUnICwgcmV0PTIsIHJlZjogL2tlcm5lbC10ZXN0cy9mYWlsZWQtY21k
L2JlZS1ncmVwLWtidWlsZC5sb2cKCjIwMTQtMDItMTktMDY6MTY6MTkgN2YzYjQ4ZWIxM2Mx
ZDVkYWVlM2Y3YzkzYzBmNjk3NTFiOWMzY2U4NSBjb21waWxpbmcKMTA5IHJlYWwgIDE0NTcg
dXNlciAgMTA4IHN5cyAgMTQyNy4wNCUgY3B1IAlpMzg2LXJhbmRjb25maWctYW4wLTAyMTkw
NDIzCgoyMDE0LTAyLTE5LTA2OjE4OjIzIGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1y
YzMtMDA5OTEtZzdmM2I0OGUuLi4uLi4uLgkxIFRFU1QgRkFJTFVSRQpbICAgIDAuNTkxMDUy
XSBVbnBhY2tpbmcgaW5pdHJhbWZzLi4uClsgICAgMS42MTczOTFdIC0tLS0tLS0tLS0tLVsg
Y3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDEuNjE3MzkxXSAtLS0tLS0tLS0tLS1bIGN1
dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAxLjYxOTAyOV0gV0FSTklORzogQ1BVOiAwIFBJ
RDogOCBhdCAva2VybmVsLXRlc3RzL2xpbnV4My9rZXJuZWwvc2NoZWQvY29yZS5jOjI5Mzkg
cnRfbXV0ZXhfc2V0cHJpbysweDY0ZC8weDhkMCgpCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWFuMC0wMjE5MDQyMy83ZjNiNDhlYjEzYzFkNWRhZWUzZjdjOTNjMGY2OTc1MWI5YzNjZTg1
L2RtZXNnLXlvY3RvLWF0aGVucy0xOjIwMTQwMjE5MDYyMjM0OmkzODYtcmFuZGNvbmZpZy1h
bjAtMDIxOTA0MjM6My4xNC4wLXJjMy0wMDk5MS1nN2YzYjQ4ZTo4Ngova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1hbjAtMDIxOTA0MjMvN2YzYjQ4ZWIxM2MxZDVkYWVlM2Y3YzkzYzBmNjk3
NTFiOWMzY2U4NS9kbWVzZy15b2N0by1hdGhlbnMtNjI6MjAxNDAyMTkwNjIyMzU6aTM4Ni1y
YW5kY29uZmlnLWFuMC0wMjE5MDQyMzozLjE0LjAtcmMzLTAwOTkxLWc3ZjNiNDhlOjg2Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMC0wMjE5MDQyMy83ZjNiNDhlYjEzYzFkNWRhZWUz
ZjdjOTNjMGY2OTc1MWI5YzNjZTg1L2RtZXNnLXlvY3RvLXhpYW4tMzE6MjAxNDAyMTkwNjIy
MzQ6aTM4Ni1yYW5kY29uZmlnLWFuMC0wMjE5MDQyMzozLjE0LjAtcmMzLTAwOTkxLWc3ZjNi
NDhlOjg2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMC0wMjE5MDQyMy83ZjNiNDhlYjEz
YzFkNWRhZWUzZjdjOTNjMGY2OTc1MWI5YzNjZTg1L2RtZXNnLXlvY3RvLXhpYW4tNTk6MjAx
NDAyMTkwNjIyMzM6aTM4Ni1yYW5kY29uZmlnLWFuMC0wMjE5MDQyMzozLjE0LjAtcmMzLTAw
OTkxLWc3ZjNiNDhlOjg2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMC0wMjE5MDQyMy83
ZjNiNDhlYjEzYzFkNWRhZWUzZjdjOTNjMGY2OTc1MWI5YzNjZTg1L2RtZXNnLXF1YW50YWwt
YmVucy0zOjIwMTQwMjE5MDYyMjQ0OmkzODYtcmFuZGNvbmZpZy1hbjAtMDIxOTA0MjM6My4x
NC4wLXJjMy0wMDk5MS1nN2YzYjQ4ZTo4NgowOjU6NiBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBi
b290cwoKQmlzZWN0aW5nOiA5OTEgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlz
IChyb3VnaGx5IDEwIHN0ZXBzKQpbNzIyMjA2YjI2MzE5MjAzY2FjMGM0YmE0YmYyNTJlNWFm
NDY1MDhkYl0gTWVyZ2UgJ2tleXN0b25lL2tleXN0b25lL21hc3RlcicgaW50byBkZXZlbC1o
b3VybHktMjAxNDAyMTkwNApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDMvb2JqLWJpc2VjdApscyAtYSAv
a2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWFuMC0wMjE5MDQy
My9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAyMTkwNDo3MjIyMDZiMjYzMTkyMDNj
YWMwYzRiYTRiZjI1MmU1YWY0NjUwOGRiOmJpc2VjdC1saW51eDMKMjAxNC0wMi0xOSAwNjoy
Mjo1ODogY21kX2ZhaWw6ICcvYmluL2dyZXAnICctcicgJy0taW5jbHVkZT1kbWVzZy0qJyAn
LXMnICctbCcgJ1dBUk5JTkc6IC4qIGF0IC4qIHJ0X211dGV4X3NldHByaW8rMHgnICcva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1hbjAtMDIxOTA0MjMvNzIyMjA2YjI2MzE5MjAzY2FjMGM0
YmE0YmYyNTJlNWFmNDY1MDhkYicgLCByZXQ9MiwgcmVmOiAva2VybmVsLXRlc3RzL2ZhaWxl
ZC1jbWQvYmVlLWdyZXAta2J1aWxkLmxvZwoKMjAxNC0wMi0xOS0wNjoyMjo1OCA3MjIyMDZi
MjYzMTkyMDNjYWMwYzRiYTRiZjI1MmU1YWY0NjUwOGRiIGNvbXBpbGluZwo5NSByZWFsICAx
MzI4IHVzZXIgIDk3IHN5cyAgMTQ5OS4zNSUgY3B1IAlpMzg2LXJhbmRjb25maWctYW4wLTAy
MTkwNDIzCgoyMDE0LTAyLTE5LTA2OjI0OjQzIGRldGVjdGluZyBib290IHN0YXRlIDMuMTQu
MC1yYzMtMDA1MDItZzcyMjIwNmIuLi4uLi4uLgk0IFRFU1QgRkFJTFVSRQpbICAgIDEuOTk4
NDU1XSBuZXRlbTogdmVyc2lvbiAxLjMKWyAgICAxLjk5OTAxM10gTkVUOiBSZWdpc3RlcmVk
IHByb3RvY29sIGZhbWlseSAxNwpbICAgIDEuOTk5MDEzXSBORVQ6IFJlZ2lzdGVyZWQgcHJv
dG9jb2wgZmFtaWx5IDE3ClsgICAyMi4wNjMzMzNdIElORk86IHJjdV9wcmVlbXB0IGRldGVj
dGVkIHN0YWxscyBvbiBDUFVzL3Rhc2tzOgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjAt
MDIxOTA0MjMvNzIyMjA2YjI2MzE5MjAzY2FjMGM0YmE0YmYyNTJlNWFmNDY1MDhkYi9kbWVz
Zy15b2N0by1hdGhlbnMtMjk6MjAxNDAyMTkwNjI4NTU6aTM4Ni1yYW5kY29uZmlnLWFuMC0w
MjE5MDQyMzozLjE0LjAtcmMzLTAwNTAyLWc3MjIyMDZiOjg3Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWFuMC0wMjE5MDQyMy83MjIyMDZiMjYzMTkyMDNjYWMwYzRiYTRiZjI1MmU1YWY0
NjUwOGRiL2RtZXNnLXlvY3RvLXhpYW4tMjA6MjAxNDAyMTkwNjI4NTE6aTM4Ni1yYW5kY29u
ZmlnLWFuMC0wMjE5MDQyMzozLjE0LjAtcmMzLTAwNTAyLWc3MjIyMDZiOjg3Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWFuMC0wMjE5MDQyMy83MjIyMDZiMjYzMTkyMDNjYWMwYzRiYTRi
ZjI1MmU1YWY0NjUwOGRiL2RtZXNnLXlvY3RvLXhpYW4tMzc6MjAxNDAyMTkwNjI5MDI6aTM4
Ni1yYW5kY29uZmlnLWFuMC0wMjE5MDQyMzozLjE0LjAtcmMzLTAwNTAyLWc3MjIyMDZiOjg3
CjA6Mzo3IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTAyLTE5IDA2
OjI5OjE1IFJFUEVBVCBDT1VOVDogMzMgICMgL2tlcm5lbC10ZXN0cy9saW51eDMvb2JqLWJp
c2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiA1MDIgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDkgc3RlcHMpCls5NDczZTUyNDEwNDA4ZTRlMTcyMWIx
ZDRhNzA1NjM5NTM3NGE2OWJjXSBNZXJnZSAnbmZzL3Rlc3RpbmcnIGludG8gZGV2ZWwtaG91
cmx5LTIwMTQwMjE5MDQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXgzL29iai1iaXNlY3QKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1hbjAtMDIxOTA0MjMv
bGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMjE5MDQ6OTQ3M2U1MjQxMDQwOGU0ZTE3
MjFiMWQ0YTcwNTYzOTUzNzRhNjliYzpiaXNlY3QtbGludXgzCjIwMTQtMDItMTkgMDY6Mjk6
MTY6IGNtZF9mYWlsOiAnL2Jpbi9ncmVwJyAnLXInICctLWluY2x1ZGU9ZG1lc2ctKicgJy1z
JyAnLWwnICdXQVJOSU5HOiAuKiBhdCAuKiBydF9tdXRleF9zZXRwcmlvKzB4JyAnL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctYW4wLTAyMTkwNDIzLzk0NzNlNTI0MTA0MDhlNGUxNzIxYjFk
NGE3MDU2Mzk1Mzc0YTY5YmMnICwgcmV0PTIsIHJlZjogL2tlcm5lbC10ZXN0cy9mYWlsZWQt
Y21kL2JlZS1ncmVwLWtidWlsZC5sb2cKCjIwMTQtMDItMTktMDY6Mjk6MTYgOTQ3M2U1MjQx
MDQwOGU0ZTE3MjFiMWQ0YTcwNTYzOTUzNzRhNjliYyBjb21waWxpbmcKMTA5IHJlYWwgIDE0
MzEgdXNlciAgMTA3IHN5cyAgMTQwMi44NyUgY3B1IAlpMzg2LXJhbmRjb25maWctYW4wLTAy
MTkwNDIzCgoyMDE0LTAyLTE5LTA2OjMxOjE5IGRldGVjdGluZyBib290IHN0YXRlIDMuMTQu
MC1yYzMtMDAxMDYtZzk0NzNlNTIuLi4JMS4uLi4uIFRFU1QgRkFJTFVSRQpbICAgIDAuNTIw
NzU5XSBVbnBhY2tpbmcgaW5pdHJhbWZzLi4uClsgICAgMS41Nzk1MTRdIC0tLS0tLS0tLS0t
LVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDEuNTc5NTE0XSAtLS0tLS0tLS0tLS1b
IGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAxLjU4MDkwMF0gV0FSTklORzogQ1BVOiAw
IFBJRDogOCBhdCAva2VybmVsLXRlc3RzL2xpbnV4My9rZXJuZWwvc2NoZWQvY29yZS5jOjI5
MzkgcnRfbXV0ZXhfc2V0cHJpbysweDY0ZC8weDhkMCgpCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWFuMC0wMjE5MDQyMy85NDczZTUyNDEwNDA4ZTRlMTcyMWIxZDRhNzA1NjM5NTM3NGE2
OWJjL2RtZXNnLXlvY3RvLXhpYW4tNDE6MjAxNDAyMTkwNjM1Mjk6aTM4Ni1yYW5kY29uZmln
LWFuMC0wMjE5MDQyMzozLjE0LjAtcmMzLTAwMTA2LWc5NDczZTUyOjg4Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWFuMC0wMjE5MDQyMy85NDczZTUyNDEwNDA4ZTRlMTcyMWIxZDRhNzA1
NjM5NTM3NGE2OWJjL2RtZXNnLXF1YW50YWwtaW5uLTE6MjAxNDAyMTkwNjM1MzI6aTM4Ni1y
YW5kY29uZmlnLWFuMC0wMjE5MDQyMzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMC0w
MjE5MDQyMy85NDczZTUyNDEwNDA4ZTRlMTcyMWIxZDRhNzA1NjM5NTM3NGE2OWJjL2RtZXNn
LXlvY3RvLWF0aGVucy00OToyMDE0MDIxOTA2MzUzNTppMzg2LXJhbmRjb25maWctYW4wLTAy
MTkwNDIzOjMuMTQuMC1yYzMtMDAxMDYtZzk0NzNlNTI6ODgKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYW4wLTAyMTkwNDIzLzk0NzNlNTI0MTA0MDhlNGUxNzIxYjFkNGE3MDU2Mzk1Mzc0
YTY5YmMvZG1lc2cteW9jdG8tYXRoZW5zLTU6MjAxNDAyMTkwNjM1NDE6aTM4Ni1yYW5kY29u
ZmlnLWFuMC0wMjE5MDQyMzozLjE0LjAtcmMzLTAwMTA2LWc5NDczZTUyOjg4CjE6NDo0IGFs
bF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDEwNiByZXZpc2lvbnMgbGVm
dCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNyBzdGVwcykKWzM5MjVlM2M5ODRkNWFi
MzFmZTZkZDBlZTI3ZWQyZDUwYzhkNTEyZDldIE1lcmdlICdtaWNyb2JsYXplL25leHQnIGlu
dG8gZGV2ZWwtaG91cmx5LTIwMTQwMjE5MDQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlz
ZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXgzL29iai1iaXNl
Y3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1h
bjAtMDIxOTA0MjMvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMjE5MDQ6MzkyNWUz
Yzk4NGQ1YWIzMWZlNmRkMGVlMjdlZDJkNTBjOGQ1MTJkOTpiaXNlY3QtbGludXgzCjIwMTQt
MDItMTkgMDY6MzU6NTE6IGNtZF9mYWlsOiAnL2Jpbi9ncmVwJyAnLXInICctLWluY2x1ZGU9
ZG1lc2ctKicgJy1zJyAnLWwnICdXQVJOSU5HOiAuKiBhdCAuKiBydF9tdXRleF9zZXRwcmlv
KzB4JyAnL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4wLTAyMTkwNDIzLzM5MjVlM2M5ODRk
NWFiMzFmZTZkZDBlZTI3ZWQyZDUwYzhkNTEyZDknICwgcmV0PTIsIHJlZjogL2tlcm5lbC10
ZXN0cy9mYWlsZWQtY21kL2JlZS1ncmVwLWtidWlsZC5sb2cKCjIwMTQtMDItMTktMDY6MzU6
NTEgMzkyNWUzYzk4NGQ1YWIzMWZlNmRkMGVlMjdlZDJkNTBjOGQ1MTJkOSBjb21waWxpbmcK
MTAzIHJlYWwgIDE0NDcgdXNlciAgMTA3IHN5cyAgMTUwMS45MSUgY3B1IAlpMzg2LXJhbmRj
b25maWctYW4wLTAyMTkwNDIzCgoyMDE0LTAyLTE5LTA2OjM3OjQ2IGRldGVjdGluZyBib290
IHN0YXRlIDMuMTQuMC1yYzMtMDAwMDgtZzM5MjVlM2MuLi4JMTkJMzEJMzIJMzMgU1VDQ0VT
UwoKQmlzZWN0aW5nOiA5OCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgNyBzdGVwcykKW2UzMGU3NzMyM2Y2MTBiZmIyZDdkNmZlNTQ5OGE1MGYwYzViZDIw
ODddIE1lcmdlICdpbnB1dC9uZXh0JyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDIxOTA0CnJ1
bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2Vy
bmVsLXRlc3RzL2xpbnV4My9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYW4wLTAyMTkwNDIzL2xpbnV4LWRldmVsOmRldmVs
LWhvdXJseS0yMDE0MDIxOTA0OmUzMGU3NzMyM2Y2MTBiZmIyZDdkNmZlNTQ5OGE1MGYwYzVi
ZDIwODc6YmlzZWN0LWxpbnV4MwoyMDE0LTAyLTE5IDA2OjQxOjE3OiBjbWRfZmFpbDogJy9i
aW4vZ3JlcCcgJy1yJyAnLS1pbmNsdWRlPWRtZXNnLSonICctcycgJy1sJyAnV0FSTklORzog
LiogYXQgLiogcnRfbXV0ZXhfc2V0cHJpbysweCcgJy9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWFuMC0wMjE5MDQyMy9lMzBlNzczMjNmNjEwYmZiMmQ3ZDZmZTU0OThhNTBmMGM1YmQyMDg3
JyAsIHJldD0yLCByZWY6IC9rZXJuZWwtdGVzdHMvZmFpbGVkLWNtZC9iZWUtZ3JlcC1rYnVp
bGQubG9nCgoyMDE0LTAyLTE5LTA2OjQxOjE3IGUzMGU3NzMyM2Y2MTBiZmIyZDdkNmZlNTQ5
OGE1MGYwYzViZDIwODcgY29tcGlsaW5nCjQzIHJlYWwgIDk2IHVzZXIgIDExIHN5cyAgMjUw
LjMzJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1hbjAtMDIxOTA0MjMKCjIwMTQtMDItMTktMDY6
NDI6MTMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjMy0wMDA2Mi1nZTMwZTc3My4u
CTIJMTAJMTkJMjkJMzMgU1VDQ0VTUwoKQmlzZWN0aW5nOiA0NCByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNiBzdGVwcykKWzU4MzExZmNkOTRiNWY3OGZh
YWE1NTk1OWNiZmNmOGZiYzRjN2JhYzBdIE1lcmdlICdhbGV4c2hpL3NpbmdsZS1iYWxhbmNl
JyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDIxOTA0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4My9vYmot
YmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctYW4wLTAyMTkwNDIzL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDIxOTA0OjU4
MzExZmNkOTRiNWY3OGZhYWE1NTk1OWNiZmNmOGZiYzRjN2JhYzA6YmlzZWN0LWxpbnV4Mwoy
MDE0LTAyLTE5IDA2OjQ1OjQzOiBjbWRfZmFpbDogJy9iaW4vZ3JlcCcgJy1yJyAnLS1pbmNs
dWRlPWRtZXNnLSonICctcycgJy1sJyAnV0FSTklORzogLiogYXQgLiogcnRfbXV0ZXhfc2V0
cHJpbysweCcgJy9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMC0wMjE5MDQyMy81ODMxMWZj
ZDk0YjVmNzhmYWFhNTU5NTljYmZjZjhmYmM0YzdiYWMwJyAsIHJldD0yLCByZWY6IC9rZXJu
ZWwtdGVzdHMvZmFpbGVkLWNtZC9iZWUtZ3JlcC1rYnVpbGQubG9nCgoyMDE0LTAyLTE5LTA2
OjQ1OjQzIDU4MzExZmNkOTRiNWY3OGZhYWE1NTk1OWNiZmNmOGZiYzRjN2JhYzAgY29tcGls
aW5nCjEwMCByZWFsICAxNDQzIHVzZXIgIDEwNCBzeXMgIDE1MzYuNzIlIGNwdSAJaTM4Ni1y
YW5kY29uZmlnLWFuMC0wMjE5MDQyMwoKMjAxNC0wMi0xOS0wNjo0NzozNCBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAzLjE0LjAtcmMzLTAwMDgzLWc1ODMxMWZjLi4uLi4uLi4JNCBURVNUIEZB
SUxVUkUKWyAgICAxLjk3NTYyMV0gbmV0ZW06IHZlcnNpb24gMS4zClsgICAgMS45NzYxMThd
IE5FVDogUmVnaXN0ZXJlZCBwcm90b2NvbCBmYW1pbHkgMTcKWyAgICAxLjk3NjExOF0gTkVU
OiBSZWdpc3RlcmVkIHByb3RvY29sIGZhbWlseSAxNwpbICAgMjIuMDY1NzU5XSBJTkZPOiBy
Y3VfcHJlZW1wdCBkZXRlY3RlZCBzdGFsbHMgb24gQ1BVcy90YXNrczoKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYW4wLTAyMTkwNDIzLzU4MzExZmNkOTRiNWY3OGZhYWE1NTk1OWNiZmNm
OGZiYzRjN2JhYzAvZG1lc2cteW9jdG8tc25iLTI4OjIwMTQwMjE5MDY1MTQzOmkzODYtcmFu
ZGNvbmZpZy1hbjAtMDIxOTA0MjM6OgowOjE6NSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290
cwobWzE7MzVtMjAxNC0wMi0xOSAwNjo1MjowNSBSRVBFQVQgQ09VTlQ6IDYwICAjIC9rZXJu
ZWwtdGVzdHMvbGludXgzL29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCmxpbmVhci1iaXNlY3Q6
IGJhZCBicmFuY2ggbWF5IGJlIGFsZXhzaGkvc2luZ2xlLWJhbGFuY2UKbGluZWFyLWJpc2Vj
dDogaGFuZGxlIG92ZXIgdG8gZ2l0IGJpc2VjdApsaW5lYXItYmlzZWN0OiBnaXQgYmlzZWN0
IHN0YXJ0IDU4MzExZmNkOTRiNWY3OGZhYWE1NTk1OWNiZmNmOGZiYzRjN2JhYzAgZTMwZTc3
MzIzZjYxMGJmYjJkN2Q2ZmU1NDk4YTUwZjBjNWJkMjA4NyAtLQpQcmV2aW91cyBIRUFEIHBv
c2l0aW9uIHdhcyA1ODMxMWZjLi4uIE1lcmdlICdhbGV4c2hpL3NpbmdsZS1iYWxhbmNlJyBp
bnRvIGRldmVsLWhvdXJseS0yMDE0MDIxOTA0CkhFQUQgaXMgbm93IGF0IGY3MTE5NGEuLi4g
TWVyZ2UgYnJhbmNoICd4ODYvdXJnZW50JyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIv
c2NtL2xpbnV4L2tlcm5lbC9naXQvdGlwL3RpcApCaXNlY3Rpbmc6IDEwIHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbNGE1ZDdjOWYzNzFk
NDM3ZTgwMzY5NzM5YmM3YzM4NzQzZjBkODdjM10gc2NoZWQ6IHJlbmFtZSB1cGRhdGVfKl9j
cHVfbG9hZApsaW5lYXItYmlzZWN0OiBnaXQgYmlzZWN0IHJ1biAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXgzL29iai1i
aXNlY3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9rZXJuZWwtdGVzdHMvbGludXgzL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1hbjAtMDIxOTA0MjMvbGludXgtZGV2
ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMjE5MDQ6NGE1ZDdjOWYzNzFkNDM3ZTgwMzY5NzM5YmM3
YzM4NzQzZjBkODdjMzpiaXNlY3QtbGludXgzCjIwMTQtMDItMTkgMDY6NTI6MTM6IGNtZF9m
YWlsOiAnL2Jpbi9ncmVwJyAnLXInICctLWluY2x1ZGU9ZG1lc2ctKicgJy1zJyAnLWwnICdX
QVJOSU5HOiAuKiBhdCAuKiBydF9tdXRleF9zZXRwcmlvKzB4JyAnL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctYW4wLTAyMTkwNDIzLzRhNWQ3YzlmMzcxZDQzN2U4MDM2OTczOWJjN2MzODc0
M2YwZDg3YzMnICwgcmV0PTIsIHJlZjogL2tlcm5lbC10ZXN0cy9mYWlsZWQtY21kL2JlZS1n
cmVwLWtidWlsZC5sb2cKCjIwMTQtMDItMTktMDY6NTI6MTMgNGE1ZDdjOWYzNzFkNDM3ZTgw
MzY5NzM5YmM3YzM4NzQzZjBkODdjMyBjb21waWxpbmcKMTA4IHJlYWwgIDE0NjggdXNlciAg
MTEwIHN5cyAgMTQ1NC42NCUgY3B1IAlpMzg2LXJhbmRjb25maWctYW4wLTAyMTkwNDIzCgoy
MDE0LTAyLTE5LTA2OjU0OjE1IGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1yYzItMDAw
MTAtZzRhNWQ3YzkuCTQJMTUJNDAJNTkJNjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA1IHJldmlz
aW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbNDgwYzNi
YTc2ODUyOTZiOGRhODkyMDIwZDQwODIyM2U3YWJkYzcwYl0gc2NoZWQ6IHJlbW92ZSB1bi11
c2VkIGZ1bmN0aW9ucwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290
LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDMvb2JqLWJpc2VjdApscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWFuMC0wMjE5MDQyMy9s
aW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAyMTkwNDo0ODBjM2JhNzY4NTI5NmI4ZGE4
OTIwMjBkNDA4MjIzZTdhYmRjNzBiOmJpc2VjdC1saW51eDMKMjAxNC0wMi0xOSAwNjo1Nzox
NjogY21kX2ZhaWw6ICcvYmluL2dyZXAnICctcicgJy0taW5jbHVkZT1kbWVzZy0qJyAnLXMn
ICctbCcgJ1dBUk5JTkc6IC4qIGF0IC4qIHJ0X211dGV4X3NldHByaW8rMHgnICcva2VybmVs
L2kzODYtcmFuZGNvbmZpZy1hbjAtMDIxOTA0MjMvNDgwYzNiYTc2ODUyOTZiOGRhODkyMDIw
ZDQwODIyM2U3YWJkYzcwYicgLCByZXQ9MiwgcmVmOiAva2VybmVsLXRlc3RzL2ZhaWxlZC1j
bWQvYmVlLWdyZXAta2J1aWxkLmxvZwoKMjAxNC0wMi0xOS0wNjo1NzoxNiA0ODBjM2JhNzY4
NTI5NmI4ZGE4OTIwMjBkNDA4MjIzZTdhYmRjNzBiIGNvbXBpbGluZwo0NCByZWFsICA3MyB1
c2VyICA3IHN5cyAgMTgxLjY2JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1hbjAtMDIxOTA0MjMK
CjIwMTQtMDItMTktMDY6NTg6MTIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjMi0w
MDAxNS1nNDgwYzNiYS4JMwkxMAkxNwk1MQk1OAk2MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDIg
cmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDIgc3RlcHMpClsw
ZTMyZGFiNWRmMzljZmIxYmU5YTkzN2Q2N2M4Nzc0MDRiOTY0MzI0XSBzY2hlZC9iYWxhbmNl
OiByZWJ1aWxkIG92dXRpbCB0cmVlIGFmdGVyIHRhc2sgbW92aW5nCnJ1bm5pbmcgL2Mva2Vy
bmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xp
bnV4My9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWctYW4wLTAyMTkwNDIzL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0
MDIxOTA0OjBlMzJkYWI1ZGYzOWNmYjFiZTlhOTM3ZDY3Yzg3NzQwNGI5NjQzMjQ6YmlzZWN0
LWxpbnV4MwoyMDE0LTAyLTE5IDA3OjAxOjQzOiBjbWRfZmFpbDogJy9iaW4vZ3JlcCcgJy1y
JyAnLS1pbmNsdWRlPWRtZXNnLSonICctcycgJy1sJyAnV0FSTklORzogLiogYXQgLiogcnRf
bXV0ZXhfc2V0cHJpbysweCcgJy9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMC0wMjE5MDQy
My8wZTMyZGFiNWRmMzljZmIxYmU5YTkzN2Q2N2M4Nzc0MDRiOTY0MzI0JyAsIHJldD0yLCBy
ZWY6IC9rZXJuZWwtdGVzdHMvZmFpbGVkLWNtZC9iZWUtZ3JlcC1rYnVpbGQubG9nCgoyMDE0
LTAyLTE5LTA3OjAxOjQzIDBlMzJkYWI1ZGYzOWNmYjFiZTlhOTM3ZDY3Yzg3NzQwNGI5NjQz
MjQgY29tcGlsaW5nCjQ0IHJlYWwgIDY0IHVzZXIgIDYgc3lzICAxNjEuMTQlIGNwdSAJaTM4
Ni1yYW5kY29uZmlnLWFuMC0wMjE5MDQyMwoKMjAxNC0wMi0xOS0wNzowMjozOSBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmMyLTAwMDE4LWcwZTMyZGFiLi4JNAkyMwkzNQk0OQk1
Nwk2MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRl
ciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKWzk4NTY0MDYwZTVjMzYwOTA4ZDkzZjYxYTc4Y2Ni
ZWY0YTA4MmQzYzJdIHNjaGVkL2JhbGFuY2U6IGFkZCBiYWxhbmNlX2ludGVydmFsIHRvIHR1
bmluZyB0b3AgbGV2ZWwgYmFsYW5jZSBmcmVxdWVuY3kKcnVubmluZyAvYy9rZXJuZWwtdGVz
dHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXgzL29i
ai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNv
bmZpZy1hbjAtMDIxOTA0MjMvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMjE5MDQ6
OTg1NjQwNjBlNWMzNjA5MDhkOTNmNjFhNzhjY2JlZjRhMDgyZDNjMjpiaXNlY3QtbGludXgz
CjIwMTQtMDItMTkgMDc6MDY6Mzk6IGNtZF9mYWlsOiAnL2Jpbi9ncmVwJyAnLXInICctLWlu
Y2x1ZGU9ZG1lc2ctKicgJy1zJyAnLWwnICdXQVJOSU5HOiAuKiBhdCAuKiBydF9tdXRleF9z
ZXRwcmlvKzB4JyAnL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4wLTAyMTkwNDIzLzk4NTY0
MDYwZTVjMzYwOTA4ZDkzZjYxYTc4Y2NiZWY0YTA4MmQzYzInICwgcmV0PTIsIHJlZjogL2tl
cm5lbC10ZXN0cy9mYWlsZWQtY21kL2JlZS1ncmVwLWtidWlsZC5sb2cKCjIwMTQtMDItMTkt
MDc6MDY6MzkgOTg1NjQwNjBlNWMzNjA5MDhkOTNmNjFhNzhjY2JlZjRhMDgyZDNjMiBjb21w
aWxpbmcKNDYgcmVhbCAgNzcgdXNlciAgNyBzeXMgIDE4My45MCUgY3B1IAlpMzg2LXJhbmRj
b25maWctYW4wLTAyMTkwNDIzCgoyMDE0LTAyLTE5LTA3OjA3OjM1IGRldGVjdGluZyBib290
IHN0YXRlIDMuMTQuMC1yYzItMDAwMjAtZzk4NTY0MDYuLi4uLi4uLgk0IFRFU1QgRkFJTFVS
RQpbICAgIDIuMDg5MDE3XSBuZXRlbTogdmVyc2lvbiAxLjMKWyAgICAyLjA4OTU2M10gTkVU
OiBSZWdpc3RlcmVkIHByb3RvY29sIGZhbWlseSAxNwpbICAgIDIuMDg5NTYzXSBORVQ6IFJl
Z2lzdGVyZWQgcHJvdG9jb2wgZmFtaWx5IDE3ClsgICAyMi4wNzAyMzhdIElORk86IHJjdV9w
cmVlbXB0IGRldGVjdGVkIHN0YWxscyBvbiBDUFVzL3Rhc2tzOgova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1hbjAtMDIxOTA0MjMvOTg1NjQwNjBlNWMzNjA5MDhkOTNmNjFhNzhjY2JlZjRh
MDgyZDNjMi9kbWVzZy15b2N0by14aWFuLTM2OjIwMTQwMjE5MDcxMTUwOmkzODYtcmFuZGNv
bmZpZy1hbjAtMDIxOTA0MjM6My4xNC4wLXJjMi0wMDAyMC1nOTg1NjQwNjo5NQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1hbjAtMDIxOTA0MjMvOTg1NjQwNjBlNWMzNjA5MDhkOTNmNjFh
NzhjY2JlZjRhMDgyZDNjMi9kbWVzZy15b2N0by1hdGhlbnMtNDc6MjAxNDAyMTkwNzExNTE6
aTM4Ni1yYW5kY29uZmlnLWFuMC0wMjE5MDQyMzozLjE0LjAtcmMyLTAwMDIwLWc5ODU2NDA2
Ojk1CjA6Mjo2IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDAgcmV2
aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDAgc3RlcHMpClszNGM2
Yzc4NDRmZDdhYzZiNzYzNjYxNDUzNGQ4M2MxMDk5YWI2ZmM3XSBzY2hlZC9iYWxhbmNlOiBh
ZGQgbGxjIGJhbGFuY2UgaW50ZXJ2YWwKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXgzL29iai1iaXNlY3QK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1hbjAt
MDIxOTA0MjMvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMjE5MDQ6MzRjNmM3ODQ0
ZmQ3YWM2Yjc2MzY2MTQ1MzRkODNjMTA5OWFiNmZjNzpiaXNlY3QtbGludXgzCjIwMTQtMDIt
MTkgMDc6MTI6MDY6IGNtZF9mYWlsOiAnL2Jpbi9ncmVwJyAnLXInICctLWluY2x1ZGU9ZG1l
c2ctKicgJy1zJyAnLWwnICdXQVJOSU5HOiAuKiBhdCAuKiBydF9tdXRleF9zZXRwcmlvKzB4
JyAnL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4wLTAyMTkwNDIzLzM0YzZjNzg0NGZkN2Fj
NmI3NjM2NjE0NTM0ZDgzYzEwOTlhYjZmYzcnICwgcmV0PTIsIHJlZjogL2tlcm5lbC10ZXN0
cy9mYWlsZWQtY21kL2JlZS1ncmVwLWtidWlsZC5sb2cKCjIwMTQtMDItMTktMDc6MTI6MDYg
MzRjNmM3ODQ0ZmQ3YWM2Yjc2MzY2MTQ1MzRkODNjMTA5OWFiNmZjNyBjb21waWxpbmcKMzUg
cmVhbCAgNjkgdXNlciAgNiBzeXMgIDIxNC4xMSUgY3B1IAlpMzg2LXJhbmRjb25maWctYW4w
LTAyMTkwNDIzCgoyMDE0LTAyLTE5LTA3OjEyOjUyIGRldGVjdGluZyBib290IHN0YXRlIDMu
MTQuMC1yYzItMDAwMTktZzM0YzZjNzguLgkyCTEwCTM0CTQ4CTU2CTU5CTYwIFNVQ0NFU1MK
Cjk4NTY0MDYwZTVjMzYwOTA4ZDkzZjYxYTc4Y2NiZWY0YTA4MmQzYzIgaXMgdGhlIGZpcnN0
IGJhZCBjb21taXQKY29tbWl0IDk4NTY0MDYwZTVjMzYwOTA4ZDkzZjYxYTc4Y2NiZWY0YTA4
MmQzYzIKQXV0aG9yOiBBbGV4IFNoaSA8YWxleC5zaGlAbGluYXJvLm9yZz4KRGF0ZTogICBU
dWUgRmViIDE4IDIxOjAxOjU0IDIwMTQgKzA4MDAKCiAgICBzY2hlZC9iYWxhbmNlOiBhZGQg
YmFsYW5jZV9pbnRlcnZhbCB0byB0dW5pbmcgdG9wIGxldmVsIGJhbGFuY2UgZnJlcXVlbmN5
CiAgICAKICAgIFNpbmNlIGNlbnRyYWwgYmFsYW5jZSBzdGFpbnMgbGVzcyBjcHUgY2FjaGUg
YXMgY3VycmVudCBiYWxhbmNlLCB3ZQogICAgY2FuIHNldCB0aGUgYmFsYW5jZSBpbnRlcnZh
bCBtb3JlIHNob3J0LgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBBbGV4IFNoaSA8YWxleC5z
aGlAbGluYXJvLm9yZz4KCjowNDAwMDAgMDQwMDAwIDFhNWI1ZTA4ZDkzMGYxYTg4OTA3YjUy
ZTVjODQwM2RmMGVhMGJiMjEgMWFjOTMwZTNmOTFkNjcwZTM3ZDgyYTZiN2U5ZDU0ZTFmMzU1
ZjhkOCBNCWluY2x1ZGUKOjA0MDAwMCAwNDAwMDAgYmM3ZWE3NGFkYTVkNzU0MGUyMDVjM2Zl
ZWE2OWJkZmQwYzYxNTViNiA5YzI3ZTZhZjYzMDgzMGExYTY5NzMzNzNhYmZiMzBhODkyOWM1
YzhlIE0Ja2VybmVsCmJpc2VjdCBydW4gc3VjY2VzcwpscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWFuMC0wMjE5MDQyMy9saW51eC1kZXZlbDpk
ZXZlbC1ob3VybHktMjAxNDAyMTkwNDozNGM2Yzc4NDRmZDdhYzZiNzYzNjYxNDUzNGQ4M2Mx
MDk5YWI2ZmM3OmJpc2VjdC1saW51eDMKCjIwMTQtMDItMTktMDc6MTc6MjIgMzRjNmM3ODQ0
ZmQ3YWM2Yjc2MzY2MTQ1MzRkODNjMTA5OWFiNmZjNyByZXVzZSAva2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1hbjAtMDIxOTA0MjMvMzRjNmM3ODQ0ZmQ3YWM2Yjc2MzY2MTQ1MzRkODNjMTA5
OWFiNmZjNy92bWxpbnV6LTMuMTQuMC1yYzItMDAwMTktZzM0YzZjNzgKCjIwMTQtMDItMTkt
MDc6MTc6MjMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMwkyMAk0Mwk2OAkxMDcJMTM5CTE3
MAkxODAgU1VDQ0VTUwoKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYt
cmFuZGNvbmZpZy1hbjAtMDIxOTA0MjMvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQw
MjE5MDQ6MGQ4YjkyZjUyNjYzNmY4M2UzZTlhMjk1YTVhMGVlMWEyYmRjYjA5ZDpiaXNlY3Qt
bGludXgzCiBURVNUIEZBSUxVUkUKWyAgICAyLjM1ODM4NF0gbmV0ZW06IHZlcnNpb24gMS4z
ClsgICAgMi4zNTg5MThdIE5FVDogUmVnaXN0ZXJlZCBwcm90b2NvbCBmYW1pbHkgMTcKWyAg
ICAyLjM1ODkxOF0gTkVUOiBSZWdpc3RlcmVkIHByb3RvY29sIGZhbWlseSAxNwpbICAgMjIu
MDY2MTI1XSBJTkZPOiByY3VfcHJlZW1wdCBkZXRlY3RlZCBzdGFsbHMgb24gQ1BVcy90YXNr
czoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4wLTAyMTkwNDIzLzBkOGI5MmY1MjY2MzZm
ODNlM2U5YTI5NWE1YTBlZTFhMmJkY2IwOWQvZG1lc2cteW9jdG8tc25iLTM5OjIwMTQwMjE5
MDU0OTI2OmkzODYtcmFuZGNvbmZpZy1hbjAtMDIxOTA0MjM6Ogova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1hbjAtMDIxOTA0MjMvMGQ4YjkyZjUyNjYzNmY4M2UzZTlhMjk1YTVhMGVlMWEy
YmRjYjA5ZC9kbWVzZy1xdWFudGFsLXNuYi0yMzoyMDE0MDIxOTA1NDkyOTppMzg2LXJhbmRj
b25maWctYW4wLTAyMTkwNDIzOjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4wLTAyMTkw
NDIzLzBkOGI5MmY1MjY2MzZmODNlM2U5YTI5NWE1YTBlZTFhMmJkY2IwOWQvZG1lc2cteW9j
dG8teGlhbi0yMzoyMDE0MDIxOTA2MTAyMzppMzg2LXJhbmRjb25maWctYW4wLTAyMTkwNDIz
OjMuMTQuMC1yYzMtMDIwNTgtZzBkOGI5MmY6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1h
bjAtMDIxOTA0MjMvMGQ4YjkyZjUyNjYzNmY4M2UzZTlhMjk1YTVhMGVlMWEyYmRjYjA5ZC9k
bWVzZy15b2N0by1pbm4tMTQ6MjAxNDAyMTkwNjEwMjc6aTM4Ni1yYW5kY29uZmlnLWFuMC0w
MjE5MDQyMzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMC0wMjE5MDQyMy8wZDhiOTJm
NTI2NjM2ZjgzZTNlOWEyOTVhNWEwZWUxYTJiZGNiMDlkL2RtZXNnLXlvY3RvLWF0aGVucy01
MzoyMDE0MDIxOTA1NDkzNjppMzg2LXJhbmRjb25maWctYW4wLTAyMTkwNDIzOjMuMTQuMC1y
YzMtMDIwNTgtZzBkOGI5MmY6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjAtMDIxOTA0
MjMvMGQ4YjkyZjUyNjYzNmY4M2UzZTlhMjk1YTVhMGVlMWEyYmRjYjA5ZC9kbWVzZy15b2N0
by14aWFuLTM4OjIwMTQwMjE5MDU0OTM2OmkzODYtcmFuZGNvbmZpZy1hbjAtMDIxOTA0MjM6
My4xNC4wLXJjMy0wMjA1OC1nMGQ4YjkyZjoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFu
MC0wMjE5MDQyMy8wZDhiOTJmNTI2NjM2ZjgzZTNlOWEyOTVhNWEwZWUxYTJiZGNiMDlkL2Rt
ZXNnLXlvY3RvLWF0aGVucy0yMToyMDE0MDIxOTA1NDkyNTppMzg2LXJhbmRjb25maWctYW4w
LTAyMTkwNDIzOjMuMTQuMC1yYzMtMDIwNTgtZzBkOGI5MmY6MgowOjc6MTkgYWxsX2dvb2Q6
YmFkOmFsbF9iYWQgYm9vdHMKCltkZXRhY2hlZCBIRUFEIDdkNGI4MmNdIFJldmVydCAic2No
ZWQvYmFsYW5jZTogYWRkIGJhbGFuY2VfaW50ZXJ2YWwgdG8gdHVuaW5nIHRvcCBsZXZlbCBi
YWxhbmNlIGZyZXF1ZW5jeSIKIENvbW1pdHRlcjogV3UgRmVuZ2d1YW5nIDxrYnVpbGRAYmVl
PgpZb3VyIG5hbWUgYW5kIGVtYWlsIGFkZHJlc3Mgd2VyZSBjb25maWd1cmVkIGF1dG9tYXRp
Y2FsbHkgYmFzZWQKb24geW91ciB1c2VybmFtZSBhbmQgaG9zdG5hbWUuIFBsZWFzZSBjaGVj
ayB0aGF0IHRoZXkgYXJlIGFjY3VyYXRlLgpZb3UgY2FuIHN1cHByZXNzIHRoaXMgbWVzc2Fn
ZSBieSBzZXR0aW5nIHRoZW0gZXhwbGljaXRseToKCiAgICBnaXQgY29uZmlnIC0tZ2xvYmFs
IHVzZXIubmFtZSAiWW91ciBOYW1lIgogICAgZ2l0IGNvbmZpZyAtLWdsb2JhbCB1c2VyLmVt
YWlsIHlvdUBleGFtcGxlLmNvbQoKQWZ0ZXIgZG9pbmcgdGhpcywgeW91IG1heSBmaXggdGhl
IGlkZW50aXR5IHVzZWQgZm9yIHRoaXMgY29tbWl0IHdpdGg6CgogICAgZ2l0IGNvbW1pdCAt
LWFtZW5kIC0tcmVzZXQtYXV0aG9yCgogMyBmaWxlcyBjaGFuZ2VkLCAxOSBkZWxldGlvbnMo
LSkKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1h
bjAtMDIxOTA0MjMvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMjE5MDQ6N2Q0Yjgy
Y2RmNTI3YjY1ZjUwY2JjZGU1ZDc0ZGM0ZmM1ZWQ4ZDFkYzpiaXNlY3QtbGludXgzCgoyMDE0
LTAyLTE5LTA3OjIyOjI2IDdkNGI4MmNkZjUyN2I2NWY1MGNiY2RlNWQ3NGRjNGZjNWVkOGQx
ZGMgY29tcGlsaW5nCgoyMDE0LTAyLTE5LTA3OjI0OjIzIGRldGVjdGluZyBib290IHN0YXRl
IDMuMTQuMC1yYzMtMDIwNTktZzdkNGI4MmMuLgkyCTEyCTMzCTU4CTc5CTEwMgkxMjEJMTUx
CTE2NwkxNzYJMTc4CTE4MCBTVUNDRVNTCgoKPT09PT09PT09IHVwc3RyZWFtID09PT09PT09
PQpXYXJuaW5nOiB5b3UgYXJlIGxlYXZpbmcgMSBjb21taXQgYmVoaW5kLCBub3QgY29ubmVj
dGVkIHRvCmFueSBvZiB5b3VyIGJyYW5jaGVzOgoKICA3ZDRiODJjIFJldmVydCAic2NoZWQv
YmFsYW5jZTogYWRkIGJhbGFuY2VfaW50ZXJ2YWwgdG8gdHVuaW5nIHRvcCBsZXZlbCBiYWxh
bmNlIGZyZXF1ZW5jeSIKCklmIHlvdSB3YW50IHRvIGtlZXAgdGhlbSBieSBjcmVhdGluZyBh
IG5ldyBicmFuY2gsIHRoaXMgbWF5IGJlIGEgZ29vZCB0aW1lCnRvIGRvIHNvIHdpdGg6Cgog
Z2l0IGJyYW5jaCBuZXdfYnJhbmNoX25hbWUgN2Q0YjgyYwoKSEVBRCBpcyBub3cgYXQgODA1
OTM3Yy4uLiBNZXJnZSB0YWcgJ2V4dDRfZm9yX2xpbnVzX3N0YWJsZScgb2YgZ2l0Oi8vZ2l0
Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3R5dHNvL2V4dDQKbHMgLWEg
L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1hbjAtMDIxOTA0
MjMvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMjE5MDQ6ODA1OTM3Y2Y0NWY5YTk5
MzNlNmI4ZTVjNjY2MDQwNmU5NzdhOWEyMzpiaXNlY3QtbGludXgzCgoyMDE0LTAyLTE5LTA3
OjMxOjI1IDgwNTkzN2NmNDVmOWE5OTMzZTZiOGU1YzY2NjA0MDZlOTc3YTlhMjMgY29tcGls
aW5nCgoyMDE0LTAyLTE5LTA3OjMzOjI2IGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1y
YzMtMDAwNDMtZzgwNTkzN2MuLgk3CTE3CTM1CTYzCTk3CTEzMQkxNjYJMTc0CTE3NwkxODAg
U1VDQ0VTUwoKCj09PT09PT09PSBsaW51eC1uZXh0ID09PT09PT09PQpQcmV2aW91cyBIRUFE
IHBvc2l0aW9uIHdhcyA4MDU5MzdjLi4uIE1lcmdlIHRhZyAnZXh0NF9mb3JfbGludXNfc3Rh
YmxlJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQv
dHl0c28vZXh0NApIRUFEIGlzIG5vdyBhdCAwMmQ1NmQ0Li4uIEFkZCBsaW51eC1uZXh0IHNw
ZWNpZmljIGZpbGVzIGZvciAyMDE0MDIxOApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWFuMC0wMjE5MDQyMy9saW51eC1kZXZlbDpkZXZlbC1o
b3VybHktMjAxNDAyMTkwNDowMmQ1NmQ0ZDE5YjhhYTg4OWM4NTYyODc3MjlkODljODA1ZWU0
MmVjOmJpc2VjdC1saW51eDMKCjIwMTQtMDItMTktMDc6Mzk6MjcgMDJkNTZkNGQxOWI4YWE4
ODljODU2Mjg3NzI5ZDg5YzgwNWVlNDJlYyByZXVzZSAva2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1hbjAtMDIxOTA0MjMvMDJkNTZkNGQxOWI4YWE4ODljODU2Mjg3NzI5ZDg5YzgwNWVlNDJl
Yy92bWxpbnV6LTMuMTQuMC1yYzMtbmV4dC0yMDE0MDIxOC0wMzQ3NS1nMDJkNTZkNAoKMjAx
NC0wMi0xOS0wNzozOToyNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgkzCTEwCTI0CTI2CTQ5
CTY4CTEwNAkxMzQJMTQwCTE0NwkxNTMJMTYwCTE2NAkxNjYJMTY4CTE3MC4uLi4uLi4uLgkx
NzEJMTcyLgkxNzMuLi4uLgkxNzUuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4JMTc5Li4JMTgwIFNVQ0NFU1MKCg==

--V0207lvV8h4k8FAm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc3-02058-g0d8b92f"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.14.0-rc3 Kernel Configuration
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
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
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
CONFIG_KERNEL_LZMA=y
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
# CONFIG_POSIX_MQUEUE is not set
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
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
CONFIG_RCU_NOCB_CPU_ZERO=y
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
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
CONFIG_MEMCG_KMEM=y
# CONFIG_CGROUP_HUGETLB is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
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
CONFIG_UID16=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
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
CONFIG_HAVE_CC_STACKPROTECTOR=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR_NONE is not set
CONFIG_CC_STACKPROTECTOR_REGULAR=y
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
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
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
# CONFIG_GCOV_FORMAT_3_4 is not set
CONFIG_GCOV_FORMAT_4_7=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
# CONFIG_MODULES is not set
# CONFIG_BLOCK is not set
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_BIGSMP=y
CONFIG_GOLDFISH=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_GOLDFISH=y
# CONFIG_X86_INTEL_MID is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_RDC321X is not set
CONFIG_X86_32_NON_STANDARD=y
# CONFIG_X86_NUMAQ is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_STA2X11 is not set
# CONFIG_X86_SUMMIT is not set
CONFIG_X86_ES7000=y
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
CONFIG_X86_SUMMIT_NUMA=y
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
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
# CONFIG_CPU_SUP_CYRIX_32 is not set
CONFIG_CPU_SUP_AMD=y
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_CPU_SUP_TRANSMETA_32=y
# CONFIG_CPU_SUP_UMC_32 is not set
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=y
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
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
CONFIG_NUMA=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=3
CONFIG_ARCH_HAVE_MEMORY_PRESENT=y
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
CONFIG_ARCH_DISCONTIGMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_DISCONTIGMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_DISCONTIGMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
# CONFIG_X86_PAT is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
# CONFIG_HZ_1500 is not set
# CONFIG_HZ_2000 is not set
# CONFIG_HZ_3000 is not set
# CONFIG_HZ_4000 is not set
# CONFIG_HZ_5000 is not set
# CONFIG_HZ_7500 is not set
# CONFIG_HZ_10000 is not set
CONFIG_HZ=300
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_HOTPLUG_CPU is not set
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_NUMA is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
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
# CONFIG_ISA is not set
# CONFIG_SCx200 is not set
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
CONFIG_AMD_NB=y
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
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
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
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set
CONFIG_ATM=y
CONFIG_ATM_LANE=y
CONFIG_MRP=y
# CONFIG_BRIDGE is not set
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
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
CONFIG_IEEE802154=y
CONFIG_6LOWPAN_IPHC=y
# CONFIG_MAC802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_ATM=y
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_MULTIQ=y
CONFIG_NET_SCH_RED=y
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
CONFIG_NET_SCH_TEQL=y
# CONFIG_NET_SCH_TBF is not set
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_MQPRIO is not set
CONFIG_NET_SCH_CHOKE=y
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_CODEL is not set
CONFIG_NET_SCH_FQ_CODEL=y
# CONFIG_NET_SCH_FQ is not set
# CONFIG_NET_SCH_HHF is not set
# CONFIG_NET_SCH_PIE is not set
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=y
# CONFIG_NET_EMATCH_NBYTE is not set
CONFIG_NET_EMATCH_U32=y
CONFIG_NET_EMATCH_META=y
CONFIG_NET_EMATCH_TEXT=y
# CONFIG_NET_CLS_ACT is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_NC is not set
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_OPENVSWITCH=y
# CONFIG_VSOCKETS is not set
CONFIG_NETLINK_MMAP=y
# CONFIG_NETLINK_DIAG is not set
CONFIG_NET_MPLS_GSO=y
CONFIG_HSR=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
# CONFIG_IRCOMM is not set
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
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
CONFIG_KINGSUN_DONGLE=y
# CONFIG_KSDAZZLE_DONGLE is not set
CONFIG_KS959_DONGLE=y

#
# FIR device drivers
#
CONFIG_USB_IRDA=y
# CONFIG_SIGMATEL_FIR is not set
# CONFIG_NSC_FIR is not set
# CONFIG_WINBOND_FIR is not set
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=y
# CONFIG_ALI_FIR is not set
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
CONFIG_MCS_FIR=y
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
CONFIG_BT_RFCOMM_TTY=y
# CONFIG_BT_BNEP is not set
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
# CONFIG_BT_HCIBTSDIO is not set
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIBCM203X=y
CONFIG_BT_HCIBPA10X=y
CONFIG_BT_HCIBFUSB=y
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
# CONFIG_BT_MRVL_SDIO is not set
CONFIG_BT_ATH3K=y
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_NET_9P_DEBUG=y
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
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
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
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_FENCE_TRACE is not set

#
# Bus devices
#
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
CONFIG_MTD=y
# CONFIG_MTD_REDBOOT_PARTS is not set
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
CONFIG_MTD_CFI_NOSWAP=y
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
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
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
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
CONFIG_MTD_SC520CDP=y
# CONFIG_MTD_NETSC520 is not set
CONFIG_MTD_TS5500=y
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
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
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=y
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=y
# CONFIG_MTD_NAND_DENALI_PCI is not set
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=y
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
CONFIG_MTD_NAND_DOCG4=y
# CONFIG_MTD_NAND_CAFE is not set
# CONFIG_MTD_NAND_CS553X is not set
# CONFIG_MTD_NAND_NANDSIM is not set
CONFIG_MTD_NAND_PLATFORM=y
# CONFIG_MTD_NAND_SH_FLCTL is not set
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
# CONFIG_MTD_ONENAND_GENERIC is not set
CONFIG_MTD_ONENAND_OTP=y
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
# CONFIG_MTD_UBI is not set
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
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=y
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
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
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_NETDEVICES is not set
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y
CONFIG_VHOST=y

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

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
# CONFIG_KEYBOARD_GOLDFISH_EVENTS is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_SH_KEYSC is not set
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=y
# CONFIG_JOYSTICK_IFORCE_USB is not set
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=y
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
# CONFIG_JOYSTICK_AS5011 is not set
CONFIG_JOYSTICK_JOYDUMP=y
CONFIG_JOYSTICK_XPAD=y
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_88PM80X_ONKEY is not set
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_BMA150=y
CONFIG_INPUT_PCSPKR=y
# CONFIG_INPUT_MMA8450 is not set
CONFIG_INPUT_MPU3050=y
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_POWERMATE=y
CONFIG_INPUT_YEALINK=y
CONFIG_INPUT_CM109=y
CONFIG_INPUT_RETU_PWRBUTTON=y
CONFIG_INPUT_TWL4030_PWRBUTTON=y
CONFIG_INPUT_TWL4030_VIBRA=y
CONFIG_INPUT_TWL6040_VIBRA=y
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_DA9052_ONKEY is not set
CONFIG_INPUT_DA9055_ONKEY=y
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=y
CONFIG_INPUT_IMS_PCU=y
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
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
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
CONFIG_N_HDLC=y
# CONFIG_N_GSM is not set
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
CONFIG_GOLDFISH_TTY=y
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
CONFIG_SERIAL_CLPS711X=y
CONFIG_SERIAL_CLPS711X_CONSOLE=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=y
CONFIG_SERIAL_SCCNXP_CONSOLE=y
CONFIG_SERIAL_TIMBERDALE=y
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
CONFIG_SERIAL_ST_ASC=y
# CONFIG_SERIAL_ST_ASC_CONSOLE is not set
CONFIG_TTY_PRINTK=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=y
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_ATMEL is not set
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_TIS_I2C_NUVOTON=y
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
CONFIG_I2C_HELPER_AUTO=y
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
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_RIIC=y
# CONFIG_I2C_SH_MOBILE is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y
CONFIG_I2C_RCAR=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_ROBOTFUZZ_OSIF=y
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=y
CONFIG_I2C_VIPERBOARD=y

#
# Other I2C/SMBus bus drivers
#
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
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
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
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=y
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
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2780=y
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
# CONFIG_BATTERY_DA9030 is not set
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_ISP1704=y
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_TWL4030=y
CONFIG_CHARGER_LP8727=y
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_SMB347=y
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
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
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=y
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_DA9055 is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_HTU21=y
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=y
# CONFIG_SENSORS_IIO_HWMON is not set
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_NCT6775 is not set
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1275=y
# CONFIG_SENSORS_LM25066 is not set
# CONFIG_SENSORS_LTC2978 is not set
CONFIG_SENSORS_MAX16064=y
# CONFIG_SENSORS_MAX34440 is not set
CONFIG_SENSORS_MAX8688=y
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_RCAR_THERMAL is not set
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
CONFIG_SSB_DEBUG=y
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
CONFIG_MFD_AS3711=y
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=y
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_SEC_CORE=y
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=y
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=y
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_PALMAS=y
# CONFIG_TPS6105X is not set
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_MADC is not set
CONFIG_MFD_TWL4030_AUDIO=y
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
# CONFIG_MFD_LM3533 is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM8997 is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

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
CONFIG_DRM_LOAD_EDID_FIRMWARE=y

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
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
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
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
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
# CONFIG_FB_N411 is not set
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
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_SM501=y
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=y
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
CONFIG_FB_AUO_K1901=y
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_PWM=y
CONFIG_BACKLIGHT_DA903X=y
CONFIG_BACKLIGHT_DA9052=y
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_LM3630A=y
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=y
# CONFIG_BACKLIGHT_PANDORA is not set
CONFIG_BACKLIGHT_TPS65217=y
CONFIG_BACKLIGHT_AS3711=y
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
CONFIG_UHID=y
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=y
# CONFIG_HID_APPLEIR is not set
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_ELO=y
CONFIG_HID_EZKEY=y
CONFIG_HID_HOLTEK=y
CONFIG_HOLTEK_FF=y
CONFIG_HID_HUION=y
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=y
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LCPOWER=y
# CONFIG_HID_LENOVO_TPKBD is not set
# CONFIG_HID_LOGITECH is not set
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MICROSOFT is not set
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
# CONFIG_HID_PICOLCD_LCD is not set
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=y
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SONY=y
CONFIG_SONY_FF=y
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=y
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

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
CONFIG_USB_OTG_WHITELIST=y
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_MON=y
CONFIG_USB_WUSB_CBAF=y
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
CONFIG_USB_OXU210HP_HCD=y
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_FUSBH200_HCD=y
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_SSB is not set
CONFIG_USB_OHCI_HCD_PLATFORM=y
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_HCD_ISO is not set
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_RENESAS_USBHS_HCD=y
CONFIG_USB_HCD_SSB=y
CONFIG_USB_HCD_TEST_MODE=y
CONFIG_USB_RENESAS_USBHS=y

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
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
CONFIG_USB_MUSB_HDRC=y
# CONFIG_USB_MUSB_HOST is not set
# CONFIG_USB_MUSB_GADGET is not set
CONFIG_USB_MUSB_DUAL_ROLE=y
CONFIG_USB_MUSB_TUSB6010=y
# CONFIG_USB_MUSB_UX500 is not set
CONFIG_MUSB_PIO_ONLY=y
CONFIG_USB_DWC3=y
CONFIG_USB_DWC3_HOST=y
# CONFIG_USB_DWC3_GADGET is not set
# CONFIG_USB_DWC3_DUAL_ROLE is not set

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
# CONFIG_USB_DWC2_DEBUG is not set
# CONFIG_USB_DWC2_TRACK_MISSED_SOFS is not set
CONFIG_USB_CHIPIDEA=y
CONFIG_USB_CHIPIDEA_UDC=y
CONFIG_USB_CHIPIDEA_HOST=y
# CONFIG_USB_CHIPIDEA_DEBUG is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=y
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y
# CONFIG_USB_EZUSB_FX2 is not set
CONFIG_USB_HSIC_USB3503=y
# CONFIG_USB_ATM is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_USB_OTG_FSM=y
# CONFIG_KEYSTONE_USB_PHY is not set
CONFIG_NOP_USB_XCEIV=y
CONFIG_OMAP_CONTROL_USB=y
# CONFIG_OMAP_USB3 is not set
# CONFIG_AM335X_PHY_USB is not set
CONFIG_SAMSUNG_USBPHY=y
# CONFIG_SAMSUNG_USB2PHY is not set
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_TAHVO_USB=y
# CONFIG_TAHVO_USB_HOST_BY_DEFAULT is not set
CONFIG_USB_ISP1301=y
CONFIG_USB_RCAR_PHY=y
# CONFIG_USB_RCAR_GEN2_PHY is not set
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
# CONFIG_USB_FOTG210_UDC is not set
# CONFIG_USB_GR_UDC is not set
# CONFIG_USB_R8A66597 is not set
CONFIG_USB_RENESAS_USBHS_UDC=y
CONFIG_USB_PXA27X=y
# CONFIG_USB_MV_UDC is not set
CONFIG_USB_MV_U3D=y
CONFIG_USB_M66592=y
# CONFIG_USB_AMD5536UDC is not set
# CONFIG_USB_NET2272 is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
# CONFIG_USB_DUMMY_HCD is not set
CONFIG_USB_LIBCOMPOSITE=y
CONFIG_USB_U_ETHER=y
CONFIG_USB_F_ECM=y
CONFIG_USB_F_EEM=y
CONFIG_USB_F_SUBSET=y
CONFIG_USB_F_RNDIS=y
# CONFIG_USB_CONFIGFS is not set
# CONFIG_USB_ZERO is not set
CONFIG_USB_ETH=y
CONFIG_USB_ETH_RNDIS=y
CONFIG_USB_ETH_EEM=y
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_NOKIA is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
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
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_OMAP_HS=y
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_GOLDFISH=y
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_VUB300=y
CONFIG_MMC_USHC=y
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

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
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_PCA9532=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
# CONFIG_LEDS_PCA9685 is not set
CONFIG_LEDS_DA903X=y
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_PWM=y
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_ADP5520=y
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_MAX8997 is not set
CONFIG_LEDS_LM355x=y
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
# CONFIG_ACCESSIBILITY is not set
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=y
CONFIG_EDAC_MCE_INJ=y
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_AMD76X is not set
# CONFIG_EDAC_E7XXX is not set
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82875P is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I82860 is not set
# CONFIG_EDAC_R82600 is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_SYSTOHC is not set
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_88PM80X is not set
CONFIG_RTC_DRV_DS1307=y
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=y
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_MAX6900=y
# CONFIG_RTC_DRV_MAX8997 is not set
CONFIG_RTC_DRV_MAX77686=y
CONFIG_RTC_DRV_RS5C372=y
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_ISL12022=y
CONFIG_RTC_DRV_ISL12057=y
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PALMAS is not set
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_PCF8523=y
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=y
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_TWL4030=y
CONFIG_RTC_DRV_TPS80031=y
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
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=y
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_DA9052=y
CONFIG_RTC_DRV_DA9055=y
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_RP5C01=y
CONFIG_RTC_DRV_V3020=y
# CONFIG_RTC_DRV_DS2404 is not set

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MOXART=y

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
# CONFIG_DW_DMAC_PCI is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
CONFIG_AUXDISPLAY=y
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
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_USBIP_CORE is not set
CONFIG_ECHO=y
CONFIG_TRANZPORT=y
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
# CONFIG_AD799X is not set
CONFIG_LPC32XX_ADC=y
CONFIG_MXS_LRADC=y
# CONFIG_SPEAR_ADC is not set

#
# Analog digital bi-direction converters
#

#
# Capacitance to digital converters
#
CONFIG_AD7150=y
CONFIG_AD7152=y
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
# CONFIG_SENSORS_HMC5843 is not set

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
# CONFIG_IIO_PERIODIC_RTC_TRIGGER is not set
CONFIG_IIO_SIMPLE_DUMMY=y
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
# CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_BCM_WIMAX=y
CONFIG_FT1000=y
CONFIG_FT1000_USB=y

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
CONFIG_STAGING_MEDIA=y

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_USB_WPAN_HCD=y
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_CED1401 is not set
CONFIG_DGRP=y
CONFIG_GOLDFISH_AUDIO=y
CONFIG_MTD_GOLDFISH_NAND=y
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
CONFIG_DGAP=y
# CONFIG_GS_FPGABOOT is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
CONFIG_DELL_LAPTOP=y
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
CONFIG_AMILO_RFKILL=y
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
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
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
CONFIG_GOLDFISH_PIPE=y
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_PSTORE=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
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
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_ADC_JACK=y
CONFIG_EXTCON_MAX8997=y
# CONFIG_EXTCON_PALMAS is not set
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
# CONFIG_HID_SENSOR_ACCEL_3D is not set
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y

#
# Analog to digital converters
#
CONFIG_MAX1363=y
# CONFIG_MCP3422 is not set
CONFIG_NAU7802=y
CONFIG_TI_ADC081C=y
# CONFIG_TI_AM335X_ADC is not set
CONFIG_TWL6030_GPADC=y
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
# CONFIG_AD5064 is not set
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
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
# CONFIG_ITG3200 is not set

#
# Humidity sensors
#
CONFIG_SI7005=y

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=y

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
CONFIG_APDS9300=y
CONFIG_CM32181=y
CONFIG_CM36651=y
CONFIG_GP2AP020A00F=y
# CONFIG_HID_SENSOR_ALS is not set
CONFIG_LTR501=y
CONFIG_TCS3472=y
CONFIG_SENSORS_TSL2563=y
CONFIG_TSL4531=y
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
# CONFIG_MAG3110 is not set
# CONFIG_HID_SENSOR_MAGNETOMETER_3D is not set
# CONFIG_IIO_ST_MAGN_3AXIS is not set

#
# Inclinometer sensors
#
CONFIG_HID_SENSOR_INCLINOMETER_3D=y

#
# Triggers - standalone
#
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure sensors
#
# CONFIG_MPL3115 is not set
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y

#
# Temperature sensors
#
CONFIG_TMP006=y
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_LP3943 is not set
CONFIG_PWM_RENESAS_TPU=y
CONFIG_PWM_TWL=y
CONFIG_PWM_TWL_LED=y
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=y
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
# CONFIG_FMC_FAKEDEV is not set
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
CONFIG_PHY_EXYNOS_MIPI_VIDEO=y
# CONFIG_POWERCAP is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

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
CONFIG_FANOTIFY=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_DEBUG=y

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NCP_FS=y
# CONFIG_NCPFS_PACKET_SIGNING is not set
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
# CONFIG_NCPFS_NFS_NS is not set
# CONFIG_NCPFS_OS2_NS is not set
# CONFIG_NCPFS_SMALLDOS is not set
# CONFIG_NCPFS_NLS is not set
# CONFIG_NCPFS_EXTRAS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
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
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
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
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_DEBUG_HIGHMEM=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_DEBUG_PREEMPT=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
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
# CONFIG_RCU_TRACE is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
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
# CONFIG_FUNCTION_GRAPH_TRACER is not set
CONFIG_IRQSOFF_TRACER=y
# CONFIG_PREEMPT_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
# CONFIG_STACK_TRACER is not set
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
# CONFIG_DYNAMIC_FTRACE is not set
# CONFIG_FUNCTION_PROFILER is not set
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
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
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
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
# CONFIG_TRUSTED_KEYS is not set
# CONFIG_ENCRYPTED_KEYS is not set
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
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
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
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

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
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
# CONFIG_CRYPTO_SHA1 is not set
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
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

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
CONFIG_CRYPTO_USER_API_HASH=y
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_CCP is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_LGUEST=y
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
CONFIG_STMP_DEVICE=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
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
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CORDIC=y
# CONFIG_DDR is not set

--V0207lvV8h4k8FAm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--V0207lvV8h4k8FAm--
