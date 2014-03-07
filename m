Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbaCGJLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:11:50 -0500
Received: from mga14.intel.com ([143.182.124.37]:37218 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbaCGJJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:09:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,606,1389772800"; 
   d="log'?scan'208";a="487805726"
Date: Fri, 7 Mar 2014 17:09:11 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [percpu]  BUG: using __this_cpu_add() in preemptible [00000000]
 code: init/1
Message-ID: <20140307090911.GA18207@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <20140307014233.GE8427@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Christoph,

FYI, here is another bisect result and call trace. Interestingly, next-20140307
no longer triggers this BUG message.

commit a25982c15ae5298520033cd5848a82adf6a97376
Author:     Christoph Lameter <cl@linux.com>
AuthorDate: Thu Mar 6 11:05:21 2014 +1100

    percpu: add preemption checks to __this_cpu ops

+---------------------------------------------------------+------------+------------+---------------+
|                                                         | 26d02cfa38 | a25982c15a | next-20140306 |
+---------------------------------------------------------+------------+------------+---------------+
| boot_successes                                          | 59         | 0          | 0             |
| boot_failures                                           | 1          | 20         | 19            |
| WARNING:CPU:PID:at_arch/x86/kernel/cpu/amd.c:init_amd() | 1          | 0          | 3             |
| backtrace:init_amd                                      | 1          | 0          | 3             |
| backtrace:warn_slowpath_fmt                             | 1          | 0          | 3             |
| BUG:using__this_cpu_add()in_preemptible_code:init       | 0          | 20         | 19            |
| BUG:using__this_cpu_add()in_preemptible_code:trinity    | 0          | 3          | 1             |
| backtrace:do_execve                                     | 0          | 20         | 19            |
| backtrace:run_init_process                              | 0          | 20         | 19            |
| backtrace:user_path_at                                  | 0          | 20         | 19            |
| backtrace:SyS_faccessat                                 | 0          | 20         | 19            |
| backtrace:SyS_access                                    | 0          | 20         | 19            |
| backtrace:do_sys_open                                   | 0          | 19         | 12            |
| backtrace:SyS_open                                      | 0          | 19         | 12            |
| backtrace:vm_mmap_pgoff                                 | 0          | 7          |               |
| backtrace:SyS_mmap_pgoff                                | 0          | 7          |               |
| BUG:using__this_cpu_add()in_preemptible_code:getty      | 0          | 1          |               |
| BUG:using__this_cpu_add()in_preemptible_code:kworker/u4 | 0          | 4          |               |
| backtrace:vm_munmap                                     | 0          | 4          |               |
| backtrace:SyS_munmap                                    | 0          | 4          |               |
| backtrace:____call_usermodehelper                       | 0          | 4          |               |
| backtrace:vfs_stat                                      | 0          | 1          | 3             |
| backtrace:SyS_stat64                                    | 0          | 1          | 3             |
| backtrace:do_group_exit                                 | 0          | 1          |               |
| backtrace:SyS_exit_group                                | 0          | 1          |               |
| BUG:using__this_cpu_add()in_preemptible_code:sh         | 0          | 0          | 2             |
| BUG:using__this_cpu_add()in_preemptible_code:rc.local   | 0          | 0          | 1             |
| backtrace:SyS_execve                                    | 0          | 0          | 3             |
| BUG:using__this_cpu_add()in_preemptible_code:grep       | 0          | 0          | 1             |
| BUG:using__this_cpu_add()in_preemptible_code:plymouthd  | 0          | 0          | 1             |
| BUG:using__this_cpu_add()in_preemptible_code:-trinity   | 0          | 0          | 1             |
+---------------------------------------------------------+------------+------------+---------------+

[    9.883984] Freeing unused kernel memory: 1780K (c1aab000 - c1c68000)
[    9.885550] Write protecting the kernel text: 7012k
[    9.886955] Write protecting the kernel read-only data: 3264k
[    9.888463] BUG: using __this_cpu_add() in preemptible [00000000] code: init/1
[    9.889377] caller is __this_cpu_preempt_check+0x1f/0x27
[    9.890038] CPU: 1 PID: 1 Comm: init Not tainted 3.14.0-rc5-next-20140306-07138-g0ffb2fe #3
[    9.891044] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    9.891728]  00000000 00000000 cdc6dd04 c16c7a68 00000001 cdc6dd28 c1273ca2 c191d4e5
[    9.892815]  cdc6dd40 00000000 cdc703b8 00000001 cdc6dd40 ce793cc0 cdc6dd6c c1273ce3
[    9.893897]  cdc6dd40 00000028 c191d539 c195d696 68745f5f 635f7369 615f7570 29286464
[    9.894983] Call Trace:
[    9.895312]  [<c16c7a68>] dump_stack+0x49/0x73
[    9.895849]  [<c1273ca2>] check_preemption_disabled+0xb0/0xc3
[    9.896557]  [<c1273ce3>] __this_cpu_preempt_check+0x1f/0x27
[    9.897391]  [<c10278bb>] ? kvm_clock_read+0x1e/0x31
[    9.898109]  [<c16c5c06>] __slab_free+0x2c/0x422
[    9.898756]  [<c104f65d>] ? sched_clock_local+0x11/0xfa
[    9.899498]  [<c10a9d49>] ? ptlock_free+0x10/0x12
[    9.900174]  [<c104f98c>] ? sched_clock_cpu+0xe3/0x10d
[    9.900884]  [<c1028f9e>] ? lookup_address+0x1c/0x1f
[    9.901584]  [<c10be778>] kmem_cache_free+0x142/0x14b
[    9.902322]  [<c10be778>] ? kmem_cache_free+0x142/0x14b
[    9.903065]  [<c10a9d49>] ? ptlock_free+0x10/0x12
[    9.903716]  [<c10a9d49>] ? ptlock_free+0x10/0x12
[    9.904382]  [<c10a9d49>] ptlock_free+0x10/0x12
[    9.905036]  [<c102a953>] ___pte_free_tlb+0x17/0x4c
[    9.905710]  [<c10a7fe8>] free_pgd_range+0x13f/0x160
[    9.906411]  [<c10c9628>] setup_arg_pages+0x235/0x27f
[    9.917213]  [<c12ed5a5>] ? get_random_int+0x60/0x77
[    9.917913]  [<c10f9c8b>] load_elf_binary+0x2e9/0xb95
[    9.918656]  [<c1273cc2>] ? debug_smp_processor_id+0xd/0xf
[    9.919439]  [<c10c9c0b>] search_binary_handler+0x65/0x130
[    9.920238]  [<c10ca90c>] do_execve+0x3a4/0x4ad
[    9.920874]  [<c100037c>] run_init_process+0x1c/0x1e
[    9.921610]  [<c16c1031>] kernel_init+0x34/0xb8
[    9.922260]  [<c16d8037>] ret_from_kernel_thread+0x1b/0x28
[    9.923067]  [<c16c0ffd>] ? rest_init+0xa1/0xa1

git bisect start 0ffb2fe7b9c30082876fa3a17da018bf0632cf03 09de192242d86ede449146ac423effca53bc1810 --
git bisect  bad 439cde1f3d8230f858c0a55902381d24cd7a2df2  # 12:13      0-      3  Merge branch 'akpm/master'
git bisect good ce34778eb4d9fa0aaaeae76c1068026ee5255fd7  # 13:30     20+      4  Merge branch 'akpm-current/current'
git bisect good 117314461e82adabb6b78dcb03259da75b50833b  # 13:43     20+      0  mm: don't implictly include linux/mm.h in linux/sched.h
git bisect  bad 9d58cf7a388c1b4a06cb335980eb1bb1352ba876  # 13:50      0-      3  scheduler: replace __get_cpu_var with this_cpu_ptr
git bisect  bad b2ff2cfebad92bebfca28bad650045821ed270c4  # 13:56      0-      6  tracing: replace __get_cpu_var uses with this_cpu_ptr
git bisect good 6fb77936481538ba05726345d86af4b39128a8a9  # 14:03     20+      1  arm: move arm_dma_limit to setup_dma_zone
git bisect good d1cea07efbfa2723ca1b83d3a69d1f1000896d4d  # 14:11     20+      0  modules: use raw_cpu_write for initialization of per cpu refcount.
git bisect  bad a25982c15ae5298520033cd5848a82adf6a97376  # 14:16      0-      1  percpu: add preemption checks to __this_cpu ops
git bisect good 26d02cfa385067c39c0407b022c01a011c2fbb51  # 14:30     20+      0  net: replace __this_cpu_inc in route.c with raw_cpu_inc
# first bad commit: [a25982c15ae5298520033cd5848a82adf6a97376] percpu: add preemption checks to __this_cpu ops
git bisect good 26d02cfa385067c39c0407b022c01a011c2fbb51  # 14:46     60+      1  net: replace __this_cpu_inc in route.c with raw_cpu_inc
git bisect  bad 0ffb2fe7b9c30082876fa3a17da018bf0632cf03  # 14:46      0-     19  Add linux-next specific files for 20140306
git bisect good 634e62cc4d41b66a249d3407e97fd57997dbf918  # 15:06     60+      1  Revert "percpu: add preemption checks to __this_cpu ops"
git bisect good c3bebc71c4bcdafa24b506adf0c1de3c1f77e2e0  # 15:20     60+      0  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect good 1b0a7e3263168a06d3858798e48c5a21d1c78d3c  # 15:47     60+      2  Add linux-next specific files for 20140307

Thanks,
Fengguang

--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-athens-25:20140306200018:i386-randconfig-st0-03061742:3.14.0-rc5-next-20140306-07138-g0ffb2fe:3"
Content-Transfer-Encoding: quoted-printable

early console in setup code
[    0.000000] Linux version 3.14.0-rc5-next-20140306-07138-g0ffb2fe (kbuil=
d@lkp-st01) (gcc version 4.8.1 (Debian 4.8.1-8) ) #3 SMP PREEMPT Thu Mar 6 =
19:22:22 CST 2014
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
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
[    0.000000] initial memory mapped: [mem 0x00000000-0x023fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
[    0.000000]  [mem 0x0e000000-0x0e3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
[    0.000000]  [mem 0x08000000-0x0dffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x07ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
[    0.000000]  [mem 0x0e400000-0x0fbfffff] page 2M
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x02103000, 0x02103fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x0e7ab000-0x0ffeffff]
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
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000] free_area_init_node: node 0, pgdat c1aa37c0, node_mem_map ce=
5ab020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 480 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffff9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 333 pages/cpu @ce311000 s1340288 r0 d23680 =
u1363968
[    0.000000] pcpu-alloc: s1340288 r0 d23680 u1363968 alloc=3D333*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr e3137c0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64924
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-st0-03061742/next:master/.vmlinuz-0ffb2fe7b9c30082876fa3=
a17da018bf0632cf03-20140306195620-4-athens branch=3Dnext/master BOOT_IMAGE=
=3D/kernel/i386-randconfig-st0-03061742/0ffb2fe7b9c30082876fa3a17da018bf063=
2cf03/vmlinuz-3.14.0-rc5-next-20140306-07138-g0ffb2fe
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 214440K/261744K available (7011K kernel code, 646K r=
wdata, 3260K rodata, 1780K init, 4648K bss, 47304K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd35000 - 0xfffff000   (2856 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xffd33000   ( 757 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc1aab000 - 0xc1c68000   (1780 kB)
[    0.000000]       .data : 0xc16d8f82 - 0xc1aaa800   (3910 kB)
[    0.000000]       .text : 0xc1000000 - 0xc16d8f82   (7011 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D2, =
Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:56 16
[    0.000000] CPU 0 irqstacks, hard=3Dcdc12000 soft=3Dcdc14000
[    0.000000] ACPI: Core revision 20140214
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
[    0.000000]  memory used by lock dependency info: 3807 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
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
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2893.018 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 5786.03 Bogo=
MIPS (lpj=3D2893018)
[    0.003012] pid_max: default: 32768 minimum: 301
[    0.004336] Security Framework initialized
[    0.005051] Mount-cache hash table entries: 512
[    0.007552] mce: CPU supports 10 MCE banks
[    0.008083] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.008083] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.008083] tlb_flushall_shift: 6
[    0.009711] Freeing SMP alternatives memory: 28K (c1c68000 - c1c6f000)
[    0.016325] Getting VERSION: 50014
[    0.016794] Getting VERSION: 50014
[    0.017019] Getting ID: 0
[    0.017370] Getting ID: f000000
[    0.018022] Getting LVT0: 8700
[    0.018425] Getting LVT1: 8400
[    0.019012] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.019786] enabled ExtINT on CPU#0
[    0.021721] ENABLING IO-APIC IRQs
[    0.022015] init IO_APIC IRQs
[    0.022393]  apic 0 pin 0 not connected
[    0.023040] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.024046] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.025048] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.026044] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.027043] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.028040] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.029041] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.031039] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.032048] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.033044] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.034058] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.035040] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.036040] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.037044] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.038041] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.039031]  apic 0 pin 16 not connected
[    0.039550]  apic 0 pin 17 not connected
[    0.040007]  apic 0 pin 18 not connected
[    0.040494]  apic 0 pin 19 not connected
[    0.041008]  apic 0 pin 20 not connected
[    0.041530]  apic 0 pin 21 not connected
[    0.042007]  apic 0 pin 22 not connected
[    0.042506]  apic 0 pin 23 not connected
[    0.043162] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.044007] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.046008] Using local APIC timer interrupts.
[    0.046008] calibrating APIC timer ...
[    0.048000] ... lapic delta =3D 6249950
[    0.048000] ... PM-Timer delta =3D 357973
[    0.048000] ... PM-Timer result ok
[    0.048000] ..... delta 6249950
[    0.048000] ..... mult: 268433308
[    0.048000] ..... calibration result: 999992
[    0.048000] ..... CPU clock speed is 2893.0123 MHz.
[    0.048000] ..... host bus clock speed is 999.0992 MHz.
[    0.048098] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.058284] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.061714] CPU 1 irqstacks, hard=3Dcdcd8000 soft=3Dcdcda000
[    0.062010] x86: Booting SMP configuration:
[    0.063008] .... node  #0, CPUs:      #1
[    0.002000] Initializing CPU#1
[    0.003000] kvm-clock: cpu 1, msr 0:fffd041, secondary cpu clock
[    0.003000] masked ExtINT on CPU#1
[    0.078171] x86: Booted up 1 node, 2 CPUs
[    0.078131] KVM setup async PF for cpu 1
[    0.078131] kvm-stealtime: cpu 1, msr e4607c0
[    0.079007] smpboot: Total of 2 processors activated (11572.07 BogoMIPS)
[    0.093511] devtmpfs: initialized
[    0.103260] regulator-dummy: no parameters
[    0.104316] RTC time: 20:00:02, date: 03/06/14
[    0.105773] NET: Registered protocol family 16
[    0.109701] cpuidle: using governor ladder
[    0.110008] cpuidle: using governor menu
[    0.120340] ACPI: bus type PCI registered
[    0.122666] PCI: Using configuration type 1 for base access
[    0.221523] ACPI: Added _OSI(Module Device)
[    0.222008] ACPI: Added _OSI(Processor Device)
[    0.222566] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.223007] ACPI: Added _OSI(Processor Aggregator Device)
[    0.325560] ACPI: Interpreter enabled
[    0.326048] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140214/hwxface-580)
[    0.327047] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140214/hwxface-580)
[    0.328417] ACPI: (supports S0 S3 S5)
[    0.329006] ACPI: Using IOAPIC for interrupt routing
[    0.330324] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.482343] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.483054] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.484124] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.494427] PCI host bridge to bus 0000:00
[    0.495024] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.495722] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.496020] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.497022] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.498020] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.499122] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.504243] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.509804] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.514852] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.521373] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.522483] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.523021] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.528648] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.531042] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.534036] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.545049] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.551560] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.554008] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.556009] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.565012] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.570469] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.573009] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.575009] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.588623] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.591015] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.593009] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.606744] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.609010] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.611010] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.624921] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.627009] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.629813] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.643153] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.645009] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.648008] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.661335] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.663009] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.666009] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.679347] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.680853] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.691144] pci_bus 0000:00: on NUMA node 0
[    0.703623] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.707663] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.711681] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.715649] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.717753] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.728602] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.739466] SCSI subsystem initialized
[    0.740679] libata version 3.00 loaded.
[    0.742077] ACPI: bus type USB registered
[    0.743530] usbcore: registered new interface driver usbfs
[    0.744380] usbcore: registered new interface driver hub
[    0.745468] usbcore: registered new device driver usb
[    0.747748] pps_core: LinuxPPS API ver. 1 registered
[    0.748006] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.749117] PTP clock support registered
[    0.751154] PCI: Using ACPI for IRQ routing
[    0.751684] PCI: pci_cache_line_size set to 64 bytes
[    0.752297] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.753033] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.757852] irda_init()
[    0.758309] NET: Registered protocol family 23
[    0.760218] Switched to clocksource kvm-clock
[    0.762389] FS-Cache: Loaded
[    0.763254] pnp: PnP ACPI init
[    0.763961] ACPI: bus type PNP registered
[    0.765203] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.767210] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.768752] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.770710] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.772286] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.774273] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.776446] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.787336] pnp 00:03: [dma 2]
[    0.788695] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.794052] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.797399] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.801721] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.805416] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.815898] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.821237] pnp: PnP ACPI: found 7 devices
[    0.821857] ACPI: bus type PNP unregistered
[    0.864838] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.865664] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.866405] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.868066] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.869353] NET: Registered protocol family 2
[    0.871733] TCP established hash table entries: 2048 (order: 1, 8192 byt=
es)
[    0.872790] TCP bind hash table entries: 2048 (order: 4, 90112 bytes)
[    0.874593] TCP: Hash tables configured (established 2048 bind 2048)
[    0.875698] TCP: reno registered
[    0.876247] UDP hash table entries: 256 (order: 2, 24576 bytes)
[    0.877142] UDP-Lite hash table entries: 256 (order: 2, 24576 bytes)
[    0.879001] NET: Registered protocol family 1
[    0.879732] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.880678] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.882267] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.883158] pci 0000:00:02.0: Boot video device
[    0.883975] PCI: CLS 0 bytes, default 64
[    0.885769] Trying to unpack rootfs image as initramfs...
[    3.940350] Freeing initrd memory: 24852K (ce7ab000 - cfff0000)
[    3.943907] Machine check injector initialized
[    3.945285] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    3.946146] microcode: CPU1 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    3.947785] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    3.949800] cryptomgr_test (35) used greatest stack depth: 7132 bytes le=
ft
[    3.969666] Initializing RT-Tester: OK
[    3.973711] futex hash table entries: 512 (order: 3, 32768 bytes)
[    3.974677] Initialise system trusted keyring
[    3.975486] audit: initializing netlink subsys (disabled)
[    3.976563] audit: type=3D2000 audit(1394107205.779:1): initialized
[    4.050723] bounce pool size: 64 pages
[    4.051502] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    4.298181] VFS: Disk quotas dquot_6.5.2
[    4.301281] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    4.362851] NTFS driver 2.1.30 [Flags: R/O DEBUG].
[    4.375359] SGI XFS with ACLs, security attributes, realtime, large bloc=
k/inode numbers, no debug enabled
[    4.427431] NILFS version 2 loaded
[    4.428038] msgmni has been set to 467
[    4.431427] Key type big_key registered
[    4.433002] cryptomgr_test (51) used greatest stack depth: 6724 bytes le=
ft
[    4.437376] cryptomgr_test (55) used greatest stack depth: 6696 bytes le=
ft
[    4.438391] cryptomgr_test (56) used greatest stack depth: 6456 bytes le=
ft
[    4.439989] cryptomgr_test (57) used greatest stack depth: 6376 bytes le=
ft
[    4.445482] cryptomgr_test (66) used greatest stack depth: 6300 bytes le=
ft
[    4.450590] alg: No test for lz4 (lz4-generic)
[    4.451523] alg: No test for stdrng (krng)
[    4.482747] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    4.485499] Key type asymmetric registered
[    4.488743] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    4.489889] io scheduler noop registered (default)
[    4.492960] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    4.493845] crc32: self tests passed, processed 225944 bytes in 220368 n=
sec
[    4.495093] crc32c: CRC_LE_BITS =3D 64
[    4.495604] crc32c: self tests passed, processed 225944 bytes in 110437 =
nsec
[    4.819973] crc32_combine: 8373 self tests passed
[    4.943144] tsc: Refined TSC clocksource calibration: 2892.947 MHz
[    5.138730] crc32c_combine: 8373 self tests passed
[    5.144260] ipmi message handler version 39.2
[    5.145247] IPMI System Interface driver.
[    5.146623] ipmi_si: Adding default-specified kcs state machine
[    5.147537] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    5.149080] ipmi_si: Interface detection failed
[    5.153130] ipmi_si: Adding default-specified smic state machine
[    5.154053] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    5.155507] ipmi_si: Interface detection failed
[    5.160119] ipmi_si: Adding default-specified bt state machine
[    5.160963] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    5.162403] ipmi_si: Interface detection failed
[    5.167654] ipmi_si: Unable to find any System Interface(s)
[    5.170544] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    5.171661] ACPI: Power Button [PWRF]
[    5.481435] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    5.505442] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    5.518814] lp: driver loaded but no devices found
[    5.521645] ppdev: user-space parallel port driver
[    5.522830] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    5.523894] platform pc8736x_gpio.0: no device found
[    5.524907] nsc_gpio initializing
[    5.525485] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    5.526318] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    5.536796] Hangcheck: Using getrawmonotonic().
[    5.605589] brd: module loaded
[    5.608304] MM: desc_per_page =3D 128
[    5.609141] mtip32xx Version 1.3.0
[    5.618592] lkdtm: No crash points registered, enable through debugfs
[    5.620252] Phantom Linux Driver, version n0.9.8, init OK
[    5.626983] usbcore: registered new interface driver viperboard
[    5.627862] Uniform Multi-Platform E-IDE driver
[    5.631508] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[    5.632816] piix 0000:00:01.1: not 100% native mode: will probe irqs lat=
er
[    5.634692]     ide0: BM-DMA at 0xc1c0-0xc1c7
[    5.635369]     ide1: BM-DMA at 0xc1c8-0xc1cf
[    5.636035] Probing IDE interface ide0...
[    6.161206] Probing IDE interface ide1...
[    6.836168] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[    7.452258] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[    7.453306] hdc: MWDMA2 mode selected
[    7.454207] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    7.455079] ide1 at 0x170-0x177,0x376 on irq 15
[    7.459453] Loading iSCSI transport class v2.0-870.
[    7.482352] fnic: Cisco FCoE HBA Driver, ver 1.5.0.45
[    7.483414] fnic: Successfully Initialized Trace Buffer
[    7.527808] bnx2fc: Broadcom NetXtreme II FCoE Driver bnx2fc v2.4.1 (Sep=
 17, 2013)
[    7.547426] iscsi: registered transport (tcp)
[    7.549223] scsi: <fdomain> Detection failed (no card)
[    7.551002] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 ES=
T 2006)
[    7.552816] megasas: 06.700.06.00-rc1 Sat. Aug. 31 17:00:00 PDT 2013
[    7.554625] mpt3sas version 02.100.00.00 loaded
[    7.556835] 3ware 9000 Storage Controller device driver for Linux v2.26.=
02.014.
[    7.559129] iscsi: registered transport (be2iscsi)
[    7.559931] In beiscsi_module_init, tt=3Dc1a5c348
[    7.561735] esas2r: driver will not be loaded because no ATTO esas2r dev=
ices were found
[    7.606303] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.=
de
[    7.618217] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.19 (Decemb=
er 19, 2013)
[    7.626762] Brocade 10G Ethernet driver - version: 3.2.23.0
[    7.628628] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    7.629503] e100: Copyright(c) 1999-2006 Intel Corporation
[    7.630786] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.=
5-k
[    7.631784] igb: Copyright (c) 2007-2014 Intel Corporation.
[    7.633111] igbvf: Intel(R) Gigabit Virtual Function Network Driver - ve=
rsion 2.0.2-k
[    7.634209] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[    7.635490] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - vers=
ion 3.19.1-k
[    7.636596] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
[    7.638009] i40e: Intel(R) Ethernet Connection XL710 Network Driver - ve=
rsion 0.3.32-k
[    7.639124] i40e: Copyright (c) 2013 - 2014 Intel Corporation.
[    7.641122] sky2: driver version 1.30
[    7.646739] usbcore: registered new interface driver kingsun-sir
[    7.647855] usbcore: registered new interface driver ksdazzle-sir
[    7.648753] PPP generic driver version 2.4.2
[    7.650242] PPP MPPE Compression module registered
[    7.650895] NET: Registered protocol family 24
[    7.651869] usbcore: registered new interface driver rtl8150
[    7.652977] usbcore: registered new interface driver ax88179_178a
[    7.654149] usbcore: registered new interface driver cdc_ether
[    7.655266] usbcore: registered new interface driver r815x
[    7.656342] usbcore: registered new interface driver sr9700
[    7.657398] usbcore: registered new interface driver cdc_subset
[    7.658608] usbcore: registered new interface driver zaurus
[    7.659946] usbcore: registered new interface driver cdc_ncm
[    7.661093] usbcore: registered new interface driver qmi_wwan
[    7.662172] usbcore: registered new interface driver cdc_mbim
[    7.664801] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    7.665772] ehci-pci: EHCI PCI platform driver
[    7.667377] usbcore: registered new interface driver usblp
[    7.668586] usbcore: registered new interface driver cdc_wdm
[    7.669670] usbcore: registered new interface driver usbtmc
[    7.670840] usbcore: registered new interface driver adutux
[    7.671919] usbcore: registered new interface driver cytherm
[    7.673033] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    7.674327] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    7.675564] usbcore: registered new interface driver usb_ehset_test
[    7.676878] usbcore: registered new interface driver uss720
[    7.677837] uss720: v0.6:USB Parport Cable driver for Cables using the L=
ucent Technologies USS720 Chip
[    7.679380] uss720: NOTE: this is a special purpose driver to allow nons=
tandard
[    7.680599] uss720: protocols (eg. bitbang) over USS720 usb to parallel =
cables
[    7.681816] uss720: If you just want to connect to a printer, use usblp =
instead
[    7.683129] usbcore: registered new interface driver usbsevseg
[    7.688150] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    7.691288] serio: i8042 KBD port at 0x60,0x64 irq 1
[    7.692965] serio: i8042 AUX port at 0x60,0x64 irq 12
[    7.695358] parkbd: no such parport
[    7.697870] rtc_cmos 00:00: RTC can wake from S4
[    7.699373] rtc (null): alarm rollover: day
[    7.702511] rtc rtc0: rtc_cmos: dev (254:0)
[    7.703142] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    7.703391] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    7.705718] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    7.713428] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[    7.721250] usbcore: registered new interface driver RobotFuzz Open Sour=
ce InterFace, OSIF
[    7.724513] usbcore: registered new interface driver i2c-tiny-usb
[    7.727451] pps pps0: new PPS source ktimer
[    7.728100] pps pps0: ktimer PPS source registered
[    7.739109] w83793: Detection failed at check vendor id
[    7.745093] w83793: Detection failed at check vendor id
[    7.751093] w83793: Detection failed at check vendor id
[    7.757075] w83793: Detection failed at check vendor id
[    7.762087] i2c i2c-0: w83795: Detection failed at addr 0x2c, check bank
[    7.766075] i2c i2c-0: w83795: Detection failed at addr 0x2d, check bank
[    7.770093] i2c i2c-0: w83795: Detection failed at addr 0x2e, check bank
[    7.774076] i2c i2c-0: w83795: Detection failed at addr 0x2f, check bank
[    7.779110] i2c i2c-0: Detection of w83781d chip failed at step 3
[    7.783106] i2c i2c-0: Detection of w83781d chip failed at step 3
[    7.789100] i2c i2c-0: Detection of w83781d chip failed at step 3
[    7.793103] i2c i2c-0: Detection of w83781d chip failed at step 3
[    7.797103] i2c i2c-0: Detection of w83781d chip failed at step 3
[    7.801105] i2c i2c-0: Detection of w83781d chip failed at step 3
[    7.805104] i2c i2c-0: Detection of w83781d chip failed at step 3
[    7.809115] i2c i2c-0: Detection of w83781d chip failed at step 3
[    7.867100] i2c i2c-0: detect fail: address match, 0x2c
[    7.871094] i2c i2c-0: detect fail: address match, 0x2d
[    7.875094] i2c i2c-0: detect fail: address match, 0x2e
[    7.879109] i2c i2c-0: detect fail: address match, 0x2f
[    8.024088] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[    8.038084] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[    8.052086] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[    9.479083] i2c i2c-0: MAX1619 detection failed at 0x18
[    9.487080] i2c i2c-0: MAX1619 detection failed at 0x19
[    9.495123] i2c i2c-0: MAX1619 detection failed at 0x1a
[    9.504083] i2c i2c-0: MAX1619 detection failed at 0x29
[    9.512100] i2c i2c-0: MAX1619 detection failed at 0x2a
[    9.520285] i2c i2c-0: MAX1619 detection failed at 0x2b
[    9.528112] i2c i2c-0: MAX1619 detection failed at 0x4c
[    9.538104] i2c i2c-0: MAX1619 detection failed at 0x4d
[    9.547110] i2c i2c-0: MAX1619 detection failed at 0x4e
[    9.566808] sch56xx_common: Unsupported device id: 0xff
[    9.567710] sch56xx_common: Unsupported device id: 0xff
[    9.571081] i2c i2c-0: amc6821_detect called.
[    9.575110] i2c i2c-0: amc6821: detection failed at 0x18.
[    9.577101] i2c i2c-0: amc6821_detect called.
[    9.581093] i2c i2c-0: amc6821: detection failed at 0x19.
[    9.583089] i2c i2c-0: amc6821_detect called.
[    9.587083] i2c i2c-0: amc6821: detection failed at 0x1a.
[    9.589102] i2c i2c-0: amc6821_detect called.
[    9.593098] i2c i2c-0: amc6821: detection failed at 0x2c.
[    9.595087] i2c i2c-0: amc6821_detect called.
[    9.599168] i2c i2c-0: amc6821: detection failed at 0x2d.
[    9.601104] i2c i2c-0: amc6821_detect called.
[    9.605086] i2c i2c-0: amc6821: detection failed at 0x2e.
[    9.607070] i2c i2c-0: amc6821_detect called.
[    9.611072] i2c i2c-0: amc6821: detection failed at 0x4c.
[    9.613076] i2c i2c-0: amc6821_detect called.
[    9.617090] i2c i2c-0: amc6821: detection failed at 0x4d.
[    9.619079] i2c i2c-0: amc6821_detect called.
[    9.623083] i2c i2c-0: amc6821: detection failed at 0x4e.
[    9.657616] usbcore: registered new interface driver pcwd_usb
[    9.658625] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    9.660494] acquirewdt: I/O address 0x0043 already in use
[    9.661276] acquirewdt: probe of acquirewdt failed with error -5
[    9.662264] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver v0.05
[    9.664758] sc520_wdt: WDT driver for SC520 initialised. timeout=3D30 se=
c (nowayout=3D1)
[    9.665862] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    9.666928] sbc60xxwdt: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[    9.667999] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[    9.671329] smsc37b787_wdt: Unable to register miscdev on minor 130
[    9.672743] w83877f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    9.673673] w83977f_wdt: driver v1.00
[    9.674228] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    9.675223] sbc_epx_c3: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[    9.678858] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    9.684385] MediaTrix audio driver Copyright (C) by Hannu Savolainen 199=
3-1996
[    9.685551] I/O, IRQ, DMA and type are mandatory
[    9.686827] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen=
 1993-1996
[    9.687975] ad1848: No ISAPnP cards found, trying standard ones...
[    9.688895] uart6850: irq and io must be set.
[    9.689583] pktgen: Packet Generator for packet performance testing. Ver=
sion: 2.74
[    9.691619] NET: Registered protocol family 26
[    9.695721] u32 classifier
[    9.696820]     Performance counters on
[    9.697428] Netfilter messages via NETLINK v0.30.
[    9.698231] nf_conntrack version 0.5.0 (3739 buckets, 14956 max)
[    9.705417] ctnetlink v0.93: registering with nfnetlink.
[    9.706335] nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>
[    9.707390] TCP: cubic registered
[    9.707860] Initializing XFRM netlink socket
[    9.709425] NET: Registered protocol family 5
[    9.729125] NET: Registered protocol family 33
[    9.729731] Key type rxrpc registered
[    9.730227] Key type rxrpc_s registered
[    9.730923] NET: Registered protocol family 35
[    9.756146] DCCP: Activated CCID 2 (TCP-like)
[    9.761673] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
[    9.769855] NET: Registered protocol family 37
[    9.770729] Key type dns_resolver registered
[    9.771532] Key type ceph registered
[    9.799076] libceph: loaded (mon/osd proto 15/24)
[    9.803822]=20
[    9.803822] printing PIC contents
[    9.804528] ... PIC  IMR: ffff
[    9.804957] ... PIC  IRR: 1113
[    9.805420] ... PIC  ISR: 0000
[    9.805845] ... PIC ELCR: 0c00
[    9.806373] printing local APIC contents on CPU#0/0:
[    9.807103] ... APIC ID:      00000000 (0)
[    9.807342] ... APIC VERSION: 00050014
[    9.807342] ... APIC TASKPRI: 00000000 (00)
[    9.807342] ... APIC PROCPRI: 00000000
[    9.807342] ... APIC LDR: 01000000
[    9.807342] ... APIC DFR: ffffffff
[    9.807342] ... APIC SPIV: 000001ff
[    9.807342] ... APIC ISR field:
[    9.807342] 000000000000000000000000000000000000000000000000000000000000=
0000
[    9.807342] ... APIC TMR field:
[    9.807342] 000000000200000000000000000000000000000000000000000000000000=
0000
[    9.807342] ... APIC IRR field:
[    9.807342] 000000000000000000000000000000000000000000000000000000000000=
8000
[    9.807342] ... APIC ESR: 00000000
[    9.807342] ... APIC ICR: 000008fd
[    9.807342] ... APIC ICR2: 02000000
[    9.807342] ... APIC LVTT: 000000ef
[    9.807342] ... APIC LVTPC: 00010000
[    9.807342] ... APIC LVT0: 00010700
[    9.807342] ... APIC LVT1: 00000400
[    9.807342] ... APIC LVTERR: 000000fe
[    9.807342] ... APIC TMICT: 00009f5b
[    9.807342] ... APIC TMCCT: 00000000
[    9.807342] ... APIC TDCR: 00000003
[    9.807342]=20
[    9.821321] number of MP IRQ sources: 15.
[    9.821884] number of IO-APIC #0 registers: 24.
[    9.822484] testing the IO APIC.......................
[    9.823178] IO APIC #0......
[    9.823548] .... register #00: 00000000
[    9.824107] .......    : physical APIC id: 00
[    9.824674] .......    : Delivery Type: 0
[    9.825239] .......    : LTS          : 0
[    9.825811] .... register #01: 00170011
[    9.826436] .......     : max redirection entries: 17
[    9.827109] .......     : PRQ implemented: 0
[    9.827693] .......     : IO APIC version: 11
[    9.828318] .... register #02: 00000000
[    9.828929] .......     : arbitration: 00
[    9.829447] .... IRQ redirection table:
[    9.830000] 1    0    0   0   0    0    0    00
[    9.830632] 0    0    0   0   0    1    1    31
[    9.831385] 0    0    0   0   0    1    1    30
[    9.831990] 0    0    0   0   0    1    1    33
[    9.832661] 1    0    0   0   0    1    1    34
[    9.833293] 1    1    0   0   0    1    1    35
[    9.834045] 0    0    0   0   0    1    1    36
[    9.834618] 0    0    0   0   0    1    1    37
[    9.835294] 0    0    0   0   0    1    1    38
[    9.835892] 0    1    0   0   0    1    1    39
[    9.836510] 1    1    0   0   0    1    1    3A
[    9.837145] 1    1    0   0   0    1    1    3B
[    9.837843] 0    0    0   0   0    1    1    3C
[    9.838590] 0    0    0   0   0    1    1    3D
[    9.839256] 0    0    0   0   0    1    1    3E
[    9.839888] 0    0    0   0   0    1    1    3F
[    9.840504] 1    0    0   0   0    0    0    00
[    9.841188] 1    0    0   0   0    0    0    00
[    9.841804] 1    0    0   0   0    0    0    00
[    9.842413] 1    0    0   0   0    0    0    00
[    9.843171] 1    0    0   0   0    0    0    00
[    9.843746] 1    0    0   0   0    0    0    00
[    9.844438] 1    0    0   0   0    0    0    00
[    9.845071] 1    0    0   0   0    0    0    00
[    9.845632] IRQ to pin mappings:
[    9.846163] IRQ0 -> 0:2
[    9.846617] IRQ1 -> 0:1
[    9.847060] IRQ3 -> 0:3
[    9.847460] IRQ4 -> 0:4
[    9.847800] IRQ5 -> 0:5
[    9.848221] IRQ6 -> 0:6
[    9.848572] IRQ7 -> 0:7
[    9.848965] IRQ8 -> 0:8
[    9.849384] IRQ9 -> 0:9
[    9.849745] IRQ10 -> 0:10
[    9.850244] IRQ11 -> 0:11
[    9.850715] IRQ12 -> 0:12
[    9.851210] IRQ13 -> 0:13
[    9.851680] IRQ14 -> 0:14
[    9.852179] IRQ15 -> 0:15
[    9.852651] .................................... done.
[    9.853472] Using IPI No-Shortcut mode
[    9.858133] Loading compiled-in X.509 certificates
[    9.861614] Key type encrypted registered
[    9.862645] cryptomgr_test (98) used greatest stack depth: 6080 bytes le=
ft
[    9.864649] IMA: No TPM chip found, activating TPM-bypass!
[    9.870885]   Magic number: 6:514:42
[    9.871477] tty ttyeb: hash matches
[    9.872174] register_blkdev: cannot get major 3 for hd
[    9.873121] rtc_cmos 00:00: setting system clock to 2014-03-06 20:00:12 =
UTC (1394136012)
[    9.874955] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    9.875765] EDD information not available.
[    9.883984] Freeing unused kernel memory: 1780K (c1aab000 - c1c68000)
[    9.885550] Write protecting the kernel text: 7012k
[    9.886955] Write protecting the kernel read-only data: 3264k
[    9.888463] BUG: using __this_cpu_add() in preemptible [00000000] code: =
init/1
[    9.889377] caller is __this_cpu_preempt_check+0x1f/0x27
[    9.890038] CPU: 1 PID: 1 Comm: init Not tainted 3.14.0-rc5-next-2014030=
6-07138-g0ffb2fe #3
[    9.891044] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    9.891728]  00000000 00000000 cdc6dd04 c16c7a68 00000001 cdc6dd28 c1273=
ca2 c191d4e5
[    9.892815]  cdc6dd40 00000000 cdc703b8 00000001 cdc6dd40 ce793cc0 cdc6d=
d6c c1273ce3
[    9.893897]  cdc6dd40 00000028 c191d539 c195d696 68745f5f 635f7369 615f7=
570 29286464
[    9.894983] Call Trace:
[    9.895312]  [<c16c7a68>] dump_stack+0x49/0x73
[    9.895849]  [<c1273ca2>] check_preemption_disabled+0xb0/0xc3
[    9.896557]  [<c1273ce3>] __this_cpu_preempt_check+0x1f/0x27
[    9.897391]  [<c10278bb>] ? kvm_clock_read+0x1e/0x31
[    9.898109]  [<c16c5c06>] __slab_free+0x2c/0x422
[    9.898756]  [<c104f65d>] ? sched_clock_local+0x11/0xfa
[    9.899498]  [<c10a9d49>] ? ptlock_free+0x10/0x12
[    9.900174]  [<c104f98c>] ? sched_clock_cpu+0xe3/0x10d
[    9.900884]  [<c1028f9e>] ? lookup_address+0x1c/0x1f
[    9.901584]  [<c10be778>] kmem_cache_free+0x142/0x14b
[    9.902322]  [<c10be778>] ? kmem_cache_free+0x142/0x14b
[    9.903065]  [<c10a9d49>] ? ptlock_free+0x10/0x12
[    9.903716]  [<c10a9d49>] ? ptlock_free+0x10/0x12
[    9.904382]  [<c10a9d49>] ptlock_free+0x10/0x12
[    9.905036]  [<c102a953>] ___pte_free_tlb+0x17/0x4c
[    9.905710]  [<c10a7fe8>] free_pgd_range+0x13f/0x160
[    9.906411]  [<c10c9628>] setup_arg_pages+0x235/0x27f
[    9.917213]  [<c12ed5a5>] ? get_random_int+0x60/0x77
[    9.917913]  [<c10f9c8b>] load_elf_binary+0x2e9/0xb95
[    9.918656]  [<c1273cc2>] ? debug_smp_processor_id+0xd/0xf
[    9.919439]  [<c10c9c0b>] search_binary_handler+0x65/0x130
[    9.920238]  [<c10ca90c>] do_execve+0x3a4/0x4ad
[    9.920874]  [<c100037c>] run_init_process+0x1c/0x1e
[    9.921610]  [<c16c1031>] kernel_init+0x34/0xb8
[    9.922260]  [<c16d8037>] ret_from_kernel_thread+0x1b/0x28
[    9.923067]  [<c16c0ffd>] ? rest_init+0xa1/0xa1
[    9.923928] BUG: using __this_cpu_add() in preemptible [00000000] code: =
init/1
[    9.925228] caller is __this_cpu_preempt_check+0x1f/0x27
[    9.925984] CPU: 1 PID: 1 Comm: init Not tainted 3.14.0-rc5-next-2014030=
6-07138-g0ffb2fe #3
[    9.927176] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    9.927958]  00000000 00000000 cdc6dd7c c16c7a68 00000001 cdc6dda0 c1273=
ca2 c191d4e5
[    9.929250]  cdc6ddb8 00000000 cdc703b8 00000001 cdc6ddb8 ce793c80 cdc6d=
de4 c1273ce3
[    9.930516]  cdc6ddb8 00000028 c191d539 c195d696 68745f5f 635f7369 615f7=
570 29286464
[    9.931828] Call Trace:
[    9.932202]  [<c16c7a68>] dump_stack+0x49/0x73
[    9.932850]  [<c1273ca2>] check_preemption_disabled+0xb0/0xc3
[    9.933667]  [<c1273ce3>] __this_cpu_preempt_check+0x1f/0x27
[    9.934486]  [<c16c5c06>] __slab_free+0x2c/0x422
[    9.935431]  [<c10acd2d>] ? remove_vma+0x45/0x4b
[    9.936099]  [<c10a808c>] ? free_pgtables+0x83/0x91
[    9.936804]  [<c10a7e04>] ? tlb_finish_mmu+0xc/0x2b
[    9.937496]  [<c1028f9e>] ? lookup_address+0x1c/0x1f
[    9.938232]  [<c10be778>] kmem_cache_free+0x142/0x14b
[    9.938930]  [<c10be778>] ? kmem_cache_free+0x142/0x14b
[    9.939699]  [<c10acd2d>] ? remove_vma+0x45/0x4b
[    9.940356]  [<c10acd2d>] ? remove_vma+0x45/0x4b
[    9.941046]  [<c10acd2d>] remove_vma+0x45/0x4b
[    9.941668]  [<c10ae26f>] do_munmap+0x1e3/0x226
[    9.942343]  [<c10ae2e2>] vm_munmap+0x30/0x41
[    9.942964]  [<c10fa199>] load_elf_binary+0x7f7/0xb95
[    9.943704]  [<c10c9c0b>] search_binary_handler+0x65/0x130
[    9.944499]  [<c10ca90c>] do_execve+0x3a4/0x4ad
[    9.945168]  [<c100037c>] run_init_process+0x1c/0x1e
[    9.945859]  [<c16c1031>] kernel_init+0x34/0xb8
[    9.946520]  [<c16d8037>] ret_from_kernel_thread+0x1b/0x28
[    9.947326]  [<c16c0ffd>] ? rest_init+0xa1/0xa1
[    9.948105] BUG: using __this_cpu_add() in preemptible [00000000] code: =
init/1
[    9.949115] caller is __this_cpu_preempt_check+0x1f/0x27
[    9.949874] CPU: 1 PID: 1 Comm: init Not tainted 3.14.0-rc5-next-2014030=
6-07138-g0ffb2fe #3
[    9.951052] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    9.951844]  00000000 00000000 cdc6ddcc c16c7a68 00000001 cdc6ddf0 c1273=
ca2 c191d4e5
[    9.953148]  cdc6de08 00000000 cdc703b8 00000001 cdc6de08 ce793780 cdc6d=
e34 c1273ce3
[    9.954408]  cdc6de08 00000028 c191d539 c195d696 68745f5f 635f7369 615f7=
570 29286464
[    9.955683] Call Trace:
[    9.956053]  [<c16c7a68>] dump_stack+0x49/0x73
[    9.956702]  [<c1273ca2>] check_preemption_disabled+0xb0/0xc3
[    9.957515]  [<c1273ce3>] __this_cpu_preempt_check+0x1f/0x27
[    9.958330]  [<c104f65d>] ? sched_clock_local+0x11/0xfa
[    9.959097]  [<c16c5c06>] __slab_free+0x2c/0x422
[    9.959737]  [<c10fa2a1>] ? load_elf_binary+0x8ff/0xb95
[    9.960493]  [<c104c165>] ? get_parent_ip+0xb/0x31
[    9.961181]  [<c1273cc2>] ? debug_smp_processor_id+0xd/0xf
[    9.961954]  [<c1028f9e>] ? lookup_address+0x1c/0x1f
[    9.962684]  [<c10be8e5>] kfree+0x143/0x14c
[    9.963299]  [<c10be8e5>] ? kfree+0x143/0x14c
[    9.963907]  [<c10fa2a1>] ? load_elf_binary+0x8ff/0xb95
[    9.964672]  [<c10fa2a1>] ? load_elf_binary+0x8ff/0xb95
[    9.965409]  [<c10fa2a1>] load_elf_binary+0x8ff/0xb95
[    9.966149]  [<c10c9c0b>] search_binary_handler+0x65/0x130
[    9.966916]  [<c10ca90c>] do_execve+0x3a4/0x4ad
[    9.967578]  [<c100037c>] run_init_process+0x1c/0x1e
[    9.968292]  [<c16c1031>] kernel_init+0x34/0xb8
[    9.968934]  [<c16d8037>] ret_from_kernel_thread+0x1b/0x28
[    9.969716]  [<c16c0ffd>] ? rest_init+0xa1/0xa1
[    9.970380] BUG: using __this_cpu_add() in preemptible [00000000] code: =
init/1
[    9.971400] caller is __this_cpu_preempt_check+0x1f/0x27
[    9.972153] CPU: 1 PID: 1 Comm: init Not tainted 3.14.0-rc5-next-2014030=
6-07138-g0ffb2fe #3
[    9.973349] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    9.974183]  00000000 00000000 cdc6ddcc c16c7a68 00000001 cdc6ddf0 c1273=
ca2 c191d4e5
[    9.975445]  cdc6de08 00000000 cdc703b8 00000001 cdc6de08 ce7959a0 cdc6d=
e34 c1273ce3
[    9.976704]  cdc6de08 00000028 c191d539 c195d696 68745f5f 635f7369 615f7=
570 29286464
[    9.977966] Call Trace:
[    9.978363]  [<c16c7a68>] dump_stack+0x49/0x73
[    9.978978]  [<c1273ca2>] check_preemption_disabled+0xb0/0xc3
[    9.979817]  [<c1273ce3>] __this_cpu_preempt_check+0x1f/0x27
[    9.980627]  [<c104c165>] ? get_parent_ip+0xb/0x31
[    9.981334]  [<c16d6aaa>] ? preempt_count_add+0x6a/0x7c
[    9.982078]  [<c16c5c06>] __slab_free+0x2c/0x422
[    9.982748]  [<c10fa302>] ? load_elf_binary+0x960/0xb95
[    9.983480]  [<c104c165>] ? get_parent_ip+0xb/0x31
[    9.984189]  [<c1273cc2>] ? debug_smp_processor_id+0xd/0xf
[    9.984941]  [<c1028f9e>] ? lookup_address+0x1c/0x1f
[    9.985680]  [<c10be8e5>] kfree+0x143/0x14c
[    9.986280]  [<c10be8e5>] ? kfree+0x143/0x14c
[    9.986918]  [<c10fa302>] ? load_elf_binary+0x960/0xb95
[    9.987658]  [<c10fa302>] ? load_elf_binary+0x960/0xb95
[    9.988417]  [<c10fa302>] load_elf_binary+0x960/0xb95
[    9.989142]  [<c10c9c0b>] search_binary_handler+0x65/0x130
[    9.989918]  [<c10ca90c>] do_execve+0x3a4/0x4ad
[    9.990564]  [<c100037c>] run_init_process+0x1c/0x1e
[    9.991293]  [<c16c1031>] kernel_init+0x34/0xb8
[    9.991924]  [<c16d8037>] ret_from_kernel_thread+0x1b/0x28
[    9.992729]  [<c16c0ffd>] ? rest_init+0xa1/0xa1
[    9.993386] BUG: using __this_cpu_add() in preemptible [00000000] code: =
init/1
[    9.994411] caller is __this_cpu_preempt_check+0x1f/0x27
[    9.995190] CPU: 1 PID: 1 Comm: init Not tainted 3.14.0-rc5-next-2014030=
6-07138-g0ffb2fe #3
[    9.996371] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    9.997194]  00000000 00000000 cdc6ddcc c16c7a68 00000001 cdc6ddf0 c1273=
ca2 c191d4e5
[    9.998461]  cdc6de08 00000000 cdc703b8 00000001 cdc6de08 ce5ad080 cdc6d=
e34 c1273ce3
[    9.999735]  cdc6de08 00000028 c191d539 c195d696 68745f5f 635f7369 615f7=
570 29286464
[   10.001001] Call Trace:
[   10.001374]  [<c16c7a68>] dump_stack+0x49/0x73
[   10.002041]  [<c1273ca2>] check_preemption_disabled+0xb0/0xc3
[   10.002838]  [<c1273ce3>] __this_cpu_preempt_check+0x1f/0x27
[   10.003670]  [<c104c165>] ? get_parent_ip+0xb/0x31
[   10.004346]  [<c16d6aaa>] ? preempt_count_add+0x6a/0x7c
[   10.005114]  [<c16c5c06>] __slab_free+0x2c/0x422
[   10.005753]  [<c10fa334>] ? load_elf_binary+0x992/0xb95
[   10.006509]  [<c104c165>] ? get_parent_ip+0xb/0x31
[   10.007212]  [<c1273cc2>] ? debug_smp_processor_id+0xd/0xf
[   10.007988]  [<c1028f9e>] ? lookup_address+0x1c/0x1f
[   10.008711]  [<c10be8e5>] kfree+0x143/0x14c
[   10.009327]  [<c10be8e5>] ? kfree+0x143/0x14c
[   10.009934]  [<c10fa334>] ? load_elf_binary+0x992/0xb95
[   10.010707]  [<c10fa334>] ? load_elf_binary+0x992/0xb95
[   10.011454]  [<c10fa334>] load_elf_binary+0x992/0xb95
[   10.012191]  [<c10c9c0b>] search_binary_handler+0x65/0x130
[   10.012972]  [<c10ca90c>] do_execve+0x3a4/0x4ad
[   10.013630]  [<c100037c>] run_init_process+0x1c/0x1e
[   10.014352]  [<c16c1031>] kernel_init+0x34/0xb8
[   10.014984]  [<c16d8037>] ret_from_kernel_thread+0x1b/0x28
[   10.015787]  [<c16c0ffd>] ? rest_init+0xa1/0xa1
[   10.016518] BUG: using __this_cpu_add() in preemptible [00000000] code: =
init/1
[   10.017572] caller is __this_cpu_preempt_check+0x1f/0x27
[   10.018328] CPU: 1 PID: 1 Comm: init Not tainted 3.14.0-rc5-next-2014030=
6-07138-g0ffb2fe #3
[   10.019507] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   10.020342]  00000000 00000000 cdc6ddcc c16c7a68 00000001 cdc6ddf0 c1273=
ca2 c191d4e5
[   10.021616]  cdc6de08 00000000 cdc703b8 00000001 cdc6de08 ce796320 cdc6d=
e34 c1273ce3
[   10.022883]  cdc6de08 00000028 c191d539 c195d696 68745f5f 635f7369 615f7=
570 29286464
[   10.024183] Call Trace:
[   10.024534]  [<c16c7a68>] dump_stack+0x49/0x73
[   10.025453]  [<c1273ca2>] check_preemption_disabled+0xb0/0xc3
[   10.026272]  [<c1273ce3>] __this_cpu_preempt_check+0x1f/0x27
[   10.027110]  [<c16c5c06>] __slab_free+0x2c/0x422
[   10.027749]  [<c16d6243>] ? do_async_page_fault+0x23/0x4b
[   10.028534]  [<c10fa4d6>] ? load_elf_binary+0xb34/0xb95
[   10.029281]  [<c1262026>] ? _copy_to_user+0x39/0x44
[   10.029977]  [<c1028f9e>] ? lookup_address+0x1c/0x1f
[   10.030691]  [<c10be8e5>] kfree+0x143/0x14c
[   10.031314]  [<c10be8e5>] ? kfree+0x143/0x14c
[   10.031917]  [<c10fa4d6>] ? load_elf_binary+0xb34/0xb95
[   10.032688]  [<c10fa4d6>] ? load_elf_binary+0xb34/0xb95
[   10.033425]  [<c10fa4d6>] load_elf_binary+0xb34/0xb95
[   10.034174]  [<c10c9c0b>] search_binary_handler+0x65/0x130
[   10.035254]  [<c10ca90c>] do_execve+0x3a4/0x4ad
[   10.035886]  [<c100037c>] run_init_process+0x1c/0x1e
[   10.036630]  [<c16c1031>] kernel_init+0x34/0xb8
[   10.037281]  [<c16d8037>] ret_from_kernel_thread+0x1b/0x28
[   10.038119] BUG: using __this_cpu_add() in preemptible [00000000] code: =
init/1
[   10.039120] caller is __this_cpu_preempt_check+0x1f/0x27
[   10.039873] CPU: 1 PID: 1 Comm: init Not tainted 3.14.0-rc5-next-2014030=
6-07138-g0ffb2fe #3
[   10.041044] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   10.041830]  00000000 00000000 cdc6de4c c16c7a68 00000001 cdc6de70 c1273=
ca2 c191d4e5
[   10.043137]  cdc6de88 00000000 cdc703b8 00000001 cdc6de88 ce793780 cdc6d=
eb4 c1273ce3
[   10.044400]  cdc6de88 00000028 c191d539 c195d696 68745f5f 635f7369 615f7=
570 29286464
[   10.045674] Call Trace:
[   10.046046]  [<c16c7a68>] dump_stack+0x49/0x73
[   10.046700]  [<c1273ca2>] check_preemption_disabled+0xb0/0xc3
[   10.047507]  [<c1273ce3>] __this_cpu_preempt_check+0x1f/0x27
[   10.048342]  [<c10be8e5>] ? kfree+0x143/0x14c
[   10.048955]  [<c16c5c06>] __slab_free+0x2c/0x422
[   10.049648]  [<c10fa4d6>] ? load_elf_binary+0xb34/0xb95
[   10.050387]  [<c10fa4d6>] ? load_elf_binary+0xb34/0xb95
[   10.051149]  [<c10c98d0>] ? free_bprm+0x69/0x6c
[   10.051784]  [<c10fa4d6>] ? load_elf_binary+0xb34/0xb95
[   10.052549]  [<c1028f9e>] ? lookup_address+0x1c/0x1f
[   10.053267]  [<c10be8e5>] kfree+0x143/0x14c
[   10.053859]  [<c10be8e5>] ? kfree+0x143/0x14c
[   10.054478]  [<c10c98d0>] ? free_bprm+0x69/0x6c
[   10.055149]  [<c10c98d0>] ? free_bprm+0x69/0x6c
[   10.055781]  [<c10c98d0>] free_bprm+0x69/0x6c
[   10.056418]  [<c10ca964>] do_execve+0x3fc/0x4ad
[   10.057079]  [<c100037c>] run_init_process+0x1c/0x1e
[   10.057782]  [<c16c1031>] kernel_init+0x34/0xb8
[   10.058427]  [<c16d8037>] ret_from_kernel_thread+0x1b/0x28
[   10.059234] BUG: using __this_cpu_add() in preemptible [00000000] code: =
init/1
[   10.060259] caller is __this_cpu_preempt_check+0x1f/0x27
[   10.060988] CPU: 1 PID: 1 Comm: init Not tainted 3.14.0-rc5-next-2014030=
6-07138-g0ffb2fe #3
[   10.062163] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   10.062978]  00000000 00000000 cdc6de4c c16c7a68 00000001 cdc6de70 c1273=
ca2 c191d4e5
[   10.064263]  cdc6de88 00000000 cdc703b8 00000001 cdc6de88 ce765100 cdc6d=
eb4 c1273ce3
[   10.065515]  cdc6de88 00000028 c191d539 c195d696 68745f5f 635f7369 615f7=
570 29286464
[   10.066777] Call Trace:
[   10.067167]  [<c16c7a68>] dump_stack+0x49/0x73
[   10.067782]  [<c1273ca2>] check_preemption_disabled+0xb0/0xc3
[   10.068612]  [<c1273ce3>] __this_cpu_preempt_check+0x1f/0x27
[   10.069408]  [<c104c165>] ? get_parent_ip+0xb/0x31
[   10.070112]  [<c16d6aaa>] ? preempt_count_add+0x6a/0x7c
[   10.070838]  [<c16c5c06>] __slab_free+0x2c/0x422
[   10.071512]  [<c10cd47c>] ? final_putname+0x2d/0x30
[   10.072210]  [<c10fa4d6>] ? load_elf_binary+0xb34/0xb95
[   10.072957]  [<c1028f9e>] ? lookup_address+0x1c/0x1f
[   10.073669]  [<c10be778>] kmem_cache_free+0x142/0x14b
[   10.074410]  [<c10be778>] ? kmem_cache_free+0x142/0x14b
[   10.075169]  [<c10cd47c>] ? final_putname+0x2d/0x30
[   10.075848]  [<c10cd47c>] ? final_putname+0x2d/0x30
[   10.076557]  [<c10cd47c>] final_putname+0x2d/0x30
[   10.077255]  [<c10ca96c>] do_execve+0x404/0x4ad
[   10.077895]  [<c100037c>] run_init_process+0x1c/0x1e
[   10.078619]  [<c16c1031>] kernel_init+0x34/0xb8
[   10.079275]  [<c16d8037>] ret_from_kernel_thread+0x1b/0x28
[   10.080287] BUG: using __this_cpu_add() in preemptible [00000000] code: =
init/1
[   10.081352] caller is __this_cpu_preempt_check+0x1f/0x27
[   10.082138] CPU: 1 PID: 1 Comm: init Not tainted 3.14.0-rc5-next-2014030=
6-07138-g0ffb2fe #3
[   10.083323] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   10.084163]  00000000 00000000 cdc6ddc4 c16c7a68 00000001 cdc6dde8 c1273=
ca2 c191d4e5
[   10.085438]  cdc6de00 00000000 cdc703b8 00000001 cdc6de00 ce765100 cdc6d=
e2c c1273ce3
[   10.086724]  cdc6de00 00000028 c191d539 c195d696 68745f5f 635f7369 615f7=
570 29286464
[   10.087996] Call Trace:
[   10.088375]  [<c16c7a68>] dump_stack+0x49/0x73
[   10.089009]  [<c1273ca2>] check_preemption_disabled+0xb0/0xc3
[   10.089846]  [<c1273ce3>] __this_cpu_preempt_check+0x1f/0x27
[   10.090679]  [<c104c165>] ? get_parent_ip+0xb/0x31
[   10.091361]  [<c16c5c06>] __slab_free+0x2c/0x422
[   10.092060]  [<c105b537>] ? put_lock_stats.isra.19+0xd/0x1e
[   10.092845]  [<c10cd47c>] ? final_putname+0x2d/0x30
[   10.093563]  [<c10db8db>] ? mntput_no_expire+0x4c/0x1cd
[   10.094308]  [<c10dba7a>] ? mntput+0x1e/0x20
[   10.094926]  [<c1028f9e>] ? lookup_address+0x1c/0x1f
[   10.095642]  [<c10be778>] kmem_cache_free+0x142/0x14b
[   10.096387]  [<c10be778>] ? kmem_cache_free+0x142/0x14b
[   10.097150]  [<c10cd47c>] ? final_putname+0x2d/0x30
[   10.097847]  [<c10cd47c>] ? final_putname+0x2d/0x30
[   10.098543]  [<c10cd47c>] final_putname+0x2d/0x30
[   10.099248]  [<c10d0a2a>] user_path_at_empty+0x48/0x65
[   10.099955]  [<c10beab6>] ? kmem_cache_alloc+0x89/0x107
[   10.100729]  [<c10beab6>] ? kmem_cache_alloc+0x89/0x107
[   10.101472]  [<c1048254>] ? prepare_creds+0x2d/0xca
[   10.102195]  [<c10d0a54>] user_path_at+0xd/0xf
[   10.102822]  [<c10c481f>] SyS_faccessat+0x9e/0x188
[   10.103534]  [<c105ad50>] ? up_write+0x16/0x2b
[   10.104185]  [<c10c4919>] SyS_access+0x10/0x12
[   10.104831]  [<c16d4264>] syscall_call+0x7/0xb
[   10.105682] BUG: using __this_cpu_add() in preemptible [00000000] code: =
init/1
[   10.106691] caller is __this_cpu_preempt_check+0x1f/0x27
[   10.107421] CPU: 0 PID: 1 Comm: init Not tainted 3.14.0-rc5-next-2014030=
6-07138-g0ffb2fe #3
[   10.108608] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   10.109378]  00000000 00000000 cdc6ddc4 c16c7a68 00000000 cdc6dde8 c1273=
ca2 c191d4e5
[   10.110630]  cdc6de00 00000000 cdc703b8 00000001 cdc6de00 ce765100 cdc6d=
e2c c1273ce3
[   10.111845]  cdc6de00 00000028 c191d539 c195d696 68745f5f 635f7369 615f7=
570 29286464
[   10.113113] Call Trace:
[   10.113431]  [<c16c7a68>] dump_stack+0x49/0x73
[   10.114095]  [<c1273ca2>] check_preemption_disabled+0xb0/0xc3
[   10.114911]  [<c1273ce3>] __this_cpu_preempt_check+0x1f/0x27
[   10.115696]  [<c104c165>] ? get_parent_ip+0xb/0x31
[   10.116356]  [<c16c5c06>] __slab_free+0x2c/0x422
[   10.117114]  [<c105b537>] ? put_lock_stats.isra.19+0xd/0x1e
[   10.117869]  [<c10cd47c>] ? final_putname+0x2d/0x30
[   10.118981]  [<c10db8db>] ? mntput_no_expire+0x4c/0x1cd
[   10.119770]  [<c10dba7a>] ? mntput+0x1e/0x20
[   10.120396]  [<c1028f9e>] ? lookup_address+0x1c/0x1f
[   10.121090]  [<c10be778>] kmem_cache_free+0x142/0x14b
[   10.121906]  [<c10be778>] ? kmem_cache_free+0x142/0x14b
[   10.124654]  [<c10cd47c>] ? final_putname+0x2d/0x30
[   10.125480]  [<c10cd47c>] ? final_putname+0x2d/0x30
[   10.126314]  [<c10cd47c>] final_putname+0x2d/0x30
[   10.126932]  [<c10d0a2a>] user_path_at_empty+0x48/0x65
[   10.127690]  [<c10beab6>] ? kmem_cache_alloc+0x89/0x107
[   10.128500]  [<c10beab6>] ? kmem_cache_alloc+0x89/0x107
[   10.129225]  [<c1048254>] ? prepare_creds+0x2d/0xca
[   10.129862]  [<c10d0a54>] user_path_at+0xd/0xf
[   10.130612]  [<c10c481f>] SyS_faccessat+0x9e/0x188
[   10.131293]  [<c10c4919>] SyS_access+0x10/0x12
[   10.131978]  [<c16d4264>] syscall_call+0x7/0xb
[   10.152925] random: init urandom read with 4 bits of entropy available
[   10.442093] init: Failed to create pty - disabling logging for job
[   10.443461] init: Temporary process spawn error: No space left on device
udevd[183]: inotify_init failed: Function not implemented

udevd[183]: error initializing inotify

udevd[190]: inotify_init failed: Function not implemented

udevd[190]: error initializing inotify

udevd[192]: inotify_init failed: Function not implemented

udevd[192]: error initializing inotify

udevd[194]: inotify_init failed: Function not implemented

udevd[194]: error initializing inotify

udevd[196]: inotify_init failed: Function not implemented

udevd[196]: error initializing inotify

udevd[198]: inotify_init failed: Function not implemented

udevd[198]: error initializing inotify

udevd[200]: inotify_init failed: Function not implemented

udevd[200]: error initializing inotify

udevd[202]: inotify_init failed: Function not implemented

udevd[202]: error initializing inotify

udevd[204]: inotify_init failed: Function not implemented

udevd[204]: error initializing inotify

udevd[206]: inotify_init failed: Function not implemented

udevd[206]: error initializing inotify

udevd[208]: inotify_init failed: Function not implemented

udevd[208]: error initializing inotify

Kernel tests: Boot OK!
Kernel tests: Boot OK!
Trinity v1.4pre  Dave Jones <davej@redhat.com>
[init] Marking syscall get_robust_list (312) as to be disabled.
Done parsing arguments.
Marking all syscalls as enabled.
[init] Disabling syscalls marked as disabled by command line options
[init] Marked syscall get_robust_list (312) as deactivated.
[init] Enabled 350 syscalls. Disabled 1 syscalls.
DANGER: RUNNING AS ROOT.
Unless you are running in a virtual machine, this could cause serious probl=
ems such as overwriting CMOS
or similar which could potentially make this machine unbootable without a f=
irmware reset.

ctrl-c now unless you really know what you are doing.
Continuing in 10 seconds.
Elapsed time: 10
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-s=
t0-03061742/0ffb2fe7b9c30082876fa3a17da018bf0632cf03/vmlinuz-3.14.0-rc5-nex=
t-20140306-07138-g0ffb2fe -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,=
115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-st0-03061742/next:master/.vmlinuz-0ffb2fe7b9c30082876fa3=
a17da018bf0632cf03-20140306195620-4-athens branch=3Dnext/master BOOT_IMAGE=
=3D/kernel/i386-randconfig-st0-03061742/0ffb2fe7b9c30082876fa3a17da018bf063=
2cf03/vmlinuz-3.14.0-rc5-next-20140306-07138-g0ffb2fe'  -initrd /kernel-tes=
ts/initrd/quantal-core-i386.cgz -m 256 -smp 2 -net nic,vlan=3D1,model=3De10=
00 -net user,vlan=3D1,hostfwd=3Dtcp::13658-:22 -boot order=3Dnc -no-reboot =
-watchdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs/LABEL=3DKVM/disk=
0-quantal-athens-25,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/=
disk1-quantal-athens-25,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3D=
KVM/disk2-quantal-athens-25,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABE=
L=3DKVM/disk3-quantal-athens-25,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/=
LABEL=3DKVM/disk4-quantal-athens-25,media=3Ddisk,if=3Dvirtio -drive file=3D=
/fs/LABEL=3DKVM/disk5-quantal-athens-25,media=3Ddisk,if=3Dvirtio -pidfile /=
dev/shm/kboot/pid-quantal-athens-25 -serial file:/dev/shm/kboot/serial-quan=
tal-athens-25 -daemonize -display none -monitor null=20

--y0ulUmNC+osPPQO6
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-st0-03061742-0ffb2fe7b9c30082876fa3a17da018bf0632cf03-user_path_at+-x-57936.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDA5ZGUxOTIyNDJkODZlZGU0NDkxNDZhYzQyM2VmZmNhNTNiYzE4MTAK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zdDAt
MDMwNjE3NDIvbmV4dDptYXN0ZXI6MDlkZTE5MjI0MmQ4NmVkZTQ0OTE0NmFjNDIzZWZmY2E1
M2JjMTgxMDpiaXNlY3QtbGludXg0CgoyMDE0LTAzLTA3LTA5OjAxOjI1IDA5ZGUxOTIyNDJk
ODZlZGU0NDkxNDZhYzQyM2VmZmNhNTNiYzE4MTAgY29tcGlsaW5nCjE4OCByZWFsICAzMDU4
IHVzZXIgIDI2NiBzeXMgIDE3NjcuNjQlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA2
MTc0MgoKMjAxNC0wMy0wNy0wOTowNTo1OCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAt
cmM1LTA2NDk0LWcwOWRlMTkyLi4uCTEJNC4JOAkxMy4uLi4uLi4uLi4uLi4uLi4uLi4uLi4J
MTcJMTguLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1bTIwMTQtMDMtMDcg
MTE6NTI6NTYgYWRkX3RvX3J1bl9xdWV1ZSAyG1swbQouLgkxOQkyMCBTVUNDRVNTCgpiaXNl
Y3Q6IGdvb2QgY29tbWl0IDA5ZGUxOTIyNDJkODZlZGU0NDkxNDZhYzQyM2VmZmNhNTNiYzE4
MTAKZ2l0IGJpc2VjdCBzdGFydCAwZmZiMmZlN2I5YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2
MzJjZjAzIDA5ZGUxOTIyNDJkODZlZGU0NDkxNDZhYzQyM2VmZmNhNTNiYzE4MTAgLS0KL2Mv
a2VybmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6IFsiLWIiLCAiMGZmYjJmZTdiOWMzMDA4Mjg3
NmZhM2ExN2RhMDE4YmYwNjMyY2YwMyIsICItZyIsICIwOWRlMTkyMjQyZDg2ZWRlNDQ5MTQ2
YWM0MjNlZmZjYTUzYmMxODEwIiwgIi9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290
LWZhaWx1cmUuc2giLCAiL2tlcm5lbC10ZXN0cy9saW51eDQvb2JqLWJpc2VjdCJdCkJpc2Vj
dGluZzogNDU4IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA5
IHN0ZXBzKQpbNDM5Y2RlMWYzZDgyMzBmODU4YzBhNTU5MDIzODFkMjRjZDdhMmRmMl0gTWVy
Z2UgYnJhbmNoICdha3BtL21hc3RlcicKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg0L29iai1iaXNlY3QK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zdDAt
MDMwNjE3NDIvbmV4dDptYXN0ZXI6NDM5Y2RlMWYzZDgyMzBmODU4YzBhNTU5MDIzODFkMjRj
ZDdhMmRmMjpiaXNlY3QtbGludXg0CgoyMDE0LTAzLTA3LTExOjU1OjA1IDQzOWNkZTFmM2Q4
MjMwZjg1OGMwYTU1OTAyMzgxZDI0Y2Q3YTJkZjIgY29tcGlsaW5nCjIzMSByZWFsICAzMDk1
IHVzZXIgIDI2OCBzeXMgIDE0NTQuOTclIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA2
MTc0MgoKMjAxNC0wMy0wNy0xMjowMDoxNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAt
cmM1LTA2OTQ4LWc0MzljZGUxLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4gVEVTVCBGQUlM
VVJFClsgICAgOC42NDI5MzhdIEZyZWVpbmcgdW51c2VkIGtlcm5lbCBtZW1vcnk6IDE3ODBL
IChjMWE5NTAwMCAtIGMxYzUyMDAwKQpbICAgIDguNjQ1MTc4XSBXcml0ZSBwcm90ZWN0aW5n
IHRoZSBrZXJuZWwgdGV4dDogNjk3NmsKWyAgICA4LjY0Njc2NV0gV3JpdGUgcHJvdGVjdGlu
ZyB0aGUga2VybmVsIHJlYWQtb25seSBkYXRhOiAzMjI4awpbICAgIDguNjU2MDQzXSBCVUc6
IHVzaW5nIF9fdGhpc19jcHVfYWRkKCkgaW4gcHJlZW1wdGlibGUgWzAwMDAwMDAwXSBjb2Rl
OiBpbml0LzEKWyAgICA4LjY1NzUyMl0gY2FsbGVyIGlzIF9fdGhpc19jcHVfcHJlZW1wdF9j
aGVjaysweDFmLzB4MjcKWyAgICA4LjY1ODU3Ml0gQ1BVOiAxIFBJRDogMSBDb21tOiBpbml0
IE5vdCB0YWludGVkIDMuMTQuMC1yYzUtMDY5NDgtZzQzOWNkZTEgIzY0ClsgICAgOC42NTk5
NzNdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEK
WyAgICA4LjY2MTE5Ml0gIDAwMDAwMDAwIDAwMDAwMDAwIGQxYzZkZDA0IGMxNmJlOGEyIDAw
MDAwMDAxIGQxYzZkZDI4IGMxMjc0MGM1IGMxOTBjYmNkClsgICAgOC42NjI4MDNdICBkMWM2
ZGQ0MCAwMDAwMDAwMCBkMWM3MDNiOCAwMDAwMDAwMSBkMWM2ZGQ0MCBkMjc5NjdhMCBkMWM2
ZGQ2YyBjMTI3NDEwNgpbICAgIDguNjY0NDMyXSAgZDFjNmRkNDAgMDAwMDAwMjggYzE5MGNj
MjEgYzE5NGM5NTcgNjg3NDVmNWYgNjM1ZjczNjkgNjE1Zjc1NzAgMjkyODY0NjQKWyAgICA4
LjY2NjA2OF0gQ2FsbCBUcmFjZToKWyAgICA4LjY2NjU1Ml0gIFs8YzE2YmU4YTI+XSBkdW1w
X3N0YWNrKzB4NDkvMHg3MwpbICAgIDguNjY3MzYyXSAgWzxjMTI3NDBjNT5dIGNoZWNrX3By
ZWVtcHRpb25fZGlzYWJsZWQrMHhiMC8weGMzClsgICAgOC42NjgzOTVdICBbPGMxMjc0MTA2
Pl0gX190aGlzX2NwdV9wcmVlbXB0X2NoZWNrKzB4MWYvMHgyNwpbICAgIDguNjY5NDc2XSAg
WzxjMTAyNzkzMT5dID8ga3ZtX2Nsb2NrX3JlYWQrMHgxZS8weDMxClsgICAgOC42NzAzODhd
ICBbPGMxNmJjYTJiPl0gX19zbGFiX2ZyZWUrMHgyYy8weDQyOQpbICAgIDguNjcxMjIyXSAg
WzxjMTA0ZjZkOD5dID8gc2NoZWRfY2xvY2tfbG9jYWwrMHgxMS8weGZhClsgICAgOC42NzIz
MjhdICBbPGMxMGE5ZThmPl0gPyBwdGxvY2tfZnJlZSsweDEwLzB4MTIKWyAgICA4LjY3MzE4
MF0gIFs8YzEwNGZhMDc+XSA/IHNjaGVkX2Nsb2NrX2NwdSsweGUzLzB4MTBkClsgICAgOC42
NzQxNDFdICBbPGMxMDI5MDE0Pl0gPyBsb29rdXBfYWRkcmVzcysweDFjLzB4MWYKWyAgICA4
LjY3NTAwMF0gIFs8YzEwYmU5NDc+XSBrbWVtX2NhY2hlX2ZyZWUrMHgxNDIvMHgxNGIKWyAg
ICA4LjY3NTkzMl0gIFs8YzEwYmU5NDc+XSA/IGttZW1fY2FjaGVfZnJlZSsweDE0Mi8weDE0
YgpbICAgIDguNjc2ODkyXSAgWzxjMTBhOWU4Zj5dID8gcHRsb2NrX2ZyZWUrMHgxMC8weDEy
ClsgICAgOC42Nzc5NjRdICBbPGMxMGE5ZThmPl0gPyBwdGxvY2tfZnJlZSsweDEwLzB4MTIK
WyAgICA4LjY3ODkzNF0gIFs8YzEwYTllOGY+XSBwdGxvY2tfZnJlZSsweDEwLzB4MTIKWyAg
ICA4LjY3OTc4Ml0gIFs8YzEwMmE5Yzk+XSBfX19wdGVfZnJlZV90bGIrMHgxNy8weDRjClsg
ICAgOC42ODA2ODZdICBbPGMxMGE4MTJlPl0gZnJlZV9wZ2RfcmFuZ2UrMHgxM2YvMHgxNjAK
WyAgICA4LjY4MTY0Ml0gIFs8YzEwYzk4MGI+XSBzZXR1cF9hcmdfcGFnZXMrMHgyMzUvMHgy
N2YKWyAgICA4LjY4MjU5Ml0gIFs8YzEyZWM3MWM+XSA/IGdldF9yYW5kb21faW50KzB4NjAv
MHg3NwpbICAgIDguNjgzNTA4XSAgWzxjMTBmOWU5Mj5dIGxvYWRfZWxmX2JpbmFyeSsweDJl
OS8weGI5NQpbICAgIDguNjg0NDEzXSAgWzxjMTI3NDBlNT5dID8gZGVidWdfc21wX3Byb2Nl
c3Nvcl9pZCsweGQvMHhmClsgICAgOC42ODU0MjNdICBbPGMxMGM5ZGVlPl0gc2VhcmNoX2Jp
bmFyeV9oYW5kbGVyKzB4NjUvMHgxMzAKWyAgICA4LjY4NjQyN10gIFs8YzEwY2FhZWY+XSBk
b19leGVjdmUrMHgzYTQvMHg0YWQKWyAgICA4LjY4NzI0Ml0gIFs8YzEwMDAzN2M+XSBydW5f
aW5pdF9wcm9jZXNzKzB4MWMvMHgxZQpbICAgIDguNjg4MTUzXSAgWzxjMTZiN2U3ND5dIGtl
cm5lbF9pbml0KzB4MzQvMHhiOApbICAgIDguNjg4OTQ2XSAgWzxjMTZjZWU3Nz5dIHJldF9m
cm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDI4ClsgICAgOC42OTAzNjVdICBbPGMxNmI3ZTQw
Pl0gPyByZXN0X2luaXQrMHhhMS8weGExCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0w
MzA2MTc0Mi80MzljZGUxZjNkODIzMGY4NThjMGE1NTkwMjM4MWQyNGNkN2EyZGYyL2RtZXNn
LXlvY3RvLXhpYW4tNDA6MjAxNDAzMDcxMjEyNDk6aTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA2
MTc0MjozLjE0LjAtcmM1LTA2OTQ4LWc0MzljZGUxOjY0Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLXN0MC0wMzA2MTc0Mi80MzljZGUxZjNkODIzMGY4NThjMGE1NTkwMjM4MWQyNGNkN2Ey
ZGYyL2RtZXNnLXF1YW50YWwteGd3by0zOjIwMTQwMzA3MTIxMjU4OmkzODYtcmFuZGNvbmZp
Zy1zdDAtMDMwNjE3NDI6My4xNC4wLXJjNS0wNjk0OC1nNDM5Y2RlMTo2NAova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1zdDAtMDMwNjE3NDIvNDM5Y2RlMWYzZDgyMzBmODU4YzBhNTU5MDIz
ODFkMjRjZDdhMmRmMi9kbWVzZy15b2N0by1pbm4tNDA6MjAxNDAzMDcxMjEyNTg6aTM4Ni1y
YW5kY29uZmlnLXN0MC0wMzA2MTc0Mjo6CjA6MzozIGFsbF9nb29kOmJhZDphbGxfYmFkIGJv
b3RzChtbMTszNW0yMDE0LTAzLTA3IDEyOjEzOjIwIFJFUEVBVCBDT1VOVDogMjAgICMgL2tl
cm5lbC10ZXN0cy9saW51eDQvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiA0
NTQgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDkgc3RlcHMp
CltjZTM0Nzc4ZWI0ZDlmYTBhYWFlYWU3NmMxMDY4MDI2ZWU1MjU1ZmQ3XSBNZXJnZSBicmFu
Y2ggJ2FrcG0tY3VycmVudC9jdXJyZW50JwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDQvb2JqLWJpc2Vj
dApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXN0
MC0wMzA2MTc0Mi9uZXh0Om1hc3RlcjpjZTM0Nzc4ZWI0ZDlmYTBhYWFlYWU3NmMxMDY4MDI2
ZWU1MjU1ZmQ3OmJpc2VjdC1saW51eDQKCjIwMTQtMDMtMDctMTI6MTM6MjkgY2UzNDc3OGVi
NGQ5ZmEwYWFhZWFlNzZjMTA2ODAyNmVlNTI1NWZkNyBjb21waWxpbmcKMzI2IHJlYWwgIDMw
OTggdXNlciAgMjc1IHN5cyAgMTAzMy40MiUgY3B1IAlpMzg2LXJhbmRjb25maWctc3QwLTAz
MDYxNzQyCgoyMDE0LTAzLTA3LTEyOjIxOjA3IGRldGVjdGluZyBib290IHN0YXRlIDMuMTQu
MC1yYzUtMDY4OTMtZ2NlMzQ3NzguLgkxCTIuLgk0CTYuCTgJMTEJMTIJMTUuLi4uLi4uLgkx
Ni4uCTE3Li4uLi4uLi4uLi4uCTE4Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uCTE5Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA1NSByZXZpc2lvbnMgbGVm
dCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNiBzdGVwcykKWzExNzMxNDQ2MWU4MmFk
YWJiNmI3OGRjYjAzMjU5ZGE3NWI1MDgzM2JdIG1tOiBkb24ndCBpbXBsaWN0bHkgaW5jbHVk
ZSBsaW51eC9tbS5oIGluIGxpbnV4L3NjaGVkLmgKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg0L29iai1i
aXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZp
Zy1zdDAtMDMwNjE3NDIvbmV4dDptYXN0ZXI6MTE3MzE0NDYxZTgyYWRhYmI2Yjc4ZGNiMDMy
NTlkYTc1YjUwODMzYjpiaXNlY3QtbGludXg0CgoyMDE0LTAzLTA3LTEzOjMwOjExIDExNzMx
NDQ2MWU4MmFkYWJiNmI3OGRjYjAzMjU5ZGE3NWI1MDgzM2IgY29tcGlsaW5nCjE1MiByZWFs
ICAyNzMxIHVzZXIgIDIzMCBzeXMgIDE5MzYuNzElIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXN0
MC0wMzA2MTc0MgoKMjAxNC0wMy0wNy0xMzozMzowOSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAz
LjE0LjAtcmM1LTA2ODk0LWcxMTczMTQ0Li4uLi4uLi4uLi4uLi4uLi4uCTYJMjAgU1VDQ0VT
UwoKbGluZWFyLWJpc2VjdDogYmFkIGJyYW5jaCBtYXkgYmUgYnJhbmNoICdha3BtL21hc3Rl
cicKbGluZWFyLWJpc2VjdDogaGFuZGxlIG92ZXIgdG8gZ2l0IGJpc2VjdApsaW5lYXItYmlz
ZWN0OiBnaXQgYmlzZWN0IHN0YXJ0IDQzOWNkZTFmM2Q4MjMwZjg1OGMwYTU1OTAyMzgxZDI0
Y2Q3YTJkZjIgMTE3MzE0NDYxZTgyYWRhYmI2Yjc4ZGNiMDMyNTlkYTc1YjUwODMzYiAtLQpQ
cmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyAxMTczMTQ0Li4uIG1tOiBkb24ndCBpbXBsaWN0
bHkgaW5jbHVkZSBsaW51eC9tbS5oIGluIGxpbnV4L3NjaGVkLmgKSEVBRCBpcyBub3cgYXQg
ZmJlOTM4ZS4uLiBNZXJnZSAnYXJtLXNvYy9uZXh0L2RyaXZlcnMnIGludG8gZGV2ZWwtaG91
cmx5LTIwMTQwMzA2MTgKQmlzZWN0aW5nOiAyNiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgNSBzdGVwcykKWzlkNThjZjdhMzg4YzFiNGEwNmNiMzM1OTgw
ZWIxYmIxMzUyYmE4NzZdIHNjaGVkdWxlcjogcmVwbGFjZSBfX2dldF9jcHVfdmFyIHdpdGgg
dGhpc19jcHVfcHRyCmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3QgcnVuIC9jL2tlcm5lbC10
ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDQv
b2JqLWJpc2VjdApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDQvb2JqLWJpc2VjdApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA2MTc0Mi9uZXh0
Om1hc3Rlcjo5ZDU4Y2Y3YTM4OGMxYjRhMDZjYjMzNTk4MGViMWJiMTM1MmJhODc2OmJpc2Vj
dC1saW51eDQKCjIwMTQtMDMtMDctMTM6NDM6MjggOWQ1OGNmN2EzODhjMWI0YTA2Y2IzMzU5
ODBlYjFiYjEzNTJiYTg3NiBjb21waWxpbmcKMjI3IHJlYWwgIDMwNTUgdXNlciAgMjU2IHN5
cyAgMTQ1NC44NSUgY3B1IAlpMzg2LXJhbmRjb25maWctc3QwLTAzMDYxNzQyCgoyMDE0LTAz
LTA3LTEzOjQ5OjM5IGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1yYzUtMDY5MjEtZzlk
NThjZjcuLiBURVNUIEZBSUxVUkUKWyAgICA3LjEwMTMyM10gRnJlZWluZyB1bnVzZWQga2Vy
bmVsIG1lbW9yeTogMTc4MEsgKGMxYTk1MDAwIC0gYzFjNTIwMDApClsgICAgNy4xMDIzMDdd
IFdyaXRlIHByb3RlY3RpbmcgdGhlIGtlcm5lbCB0ZXh0OiA2OTc2awpbICAgIDcuMTAzMDYz
XSBXcml0ZSBwcm90ZWN0aW5nIHRoZSBrZXJuZWwgcmVhZC1vbmx5IGRhdGE6IDMyMjhrClsg
ICAgNy4xMDQwMzVdIEJVRzogdXNpbmcgX190aGlzX2NwdV9hZGQoKSBpbiBwcmVlbXB0aWJs
ZSBbMDAwMDAwMDBdIGNvZGU6IGluaXQvMQpbICAgIDcuMTA0NjkzXSBjYWxsZXIgaXMgX190
aGlzX2NwdV9wcmVlbXB0X2NoZWNrKzB4MWYvMHgyNwpbICAgIDcuMTA1MTgzXSBDUFU6IDAg
UElEOiAxIENvbW06IGluaXQgTm90IHRhaW50ZWQgMy4xNC4wLXJjNS0wNjkyMS1nOWQ1OGNm
NyAjNjcKWyAgICA3LjEwNTgwMV0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1Mg
Qm9jaHMgMDEvMDEvMjAxMQpbICAgIDcuMTA2MzE1XSAgMDAwMDAwMDAgMDAwMDAwMDAgZDFj
NmRkN2MgYzE2YmU4NDIgMDAwMDAwMDAgZDFjNmRkYTAgYzEyNzQwNjUgYzE5MGNiYTcKWyAg
ICA3LjEwNzExMF0gIGQxYzZkZGI4IDAwMDAwMDAwIGQxYzcwM2I4IDAwMDAwMDAxIGQxYzZk
ZGI4IGQyNzk0MWMwIGQxYzZkZGU0IGMxMjc0MGE2ClsgICAgNy4xMDc4ODZdICBkMWM2ZGRi
OCAwMDAwMDAyOCBjMTkwY2JmYiBjMTk0YzkzMSA2ODc0NWY1ZiA2MzVmNzM2OSA2MTVmNzU3
MCAyOTI4NjQ2NApbICAgIDcuMTA4Njg3XSBDYWxsIFRyYWNlOgpbICAgIDcuMTA4OTEwXSAg
WzxjMTZiZTg0Mj5dIGR1bXBfc3RhY2srMHg0OS8weDczClsgICAgNy4xMDkzMjVdICBbPGMx
Mjc0MDY1Pl0gY2hlY2tfcHJlZW1wdGlvbl9kaXNhYmxlZCsweGIwLzB4YzMKWyAgICA3LjEw
OTgzMl0gIFs8YzEyNzQwYTY+XSBfX3RoaXNfY3B1X3ByZWVtcHRfY2hlY2srMHgxZi8weDI3
ClsgICAgNy4xMTAzNDhdICBbPGMxNmJjOWNiPl0gX19zbGFiX2ZyZWUrMHgyYy8weDQyOQpb
ICAgIDcuMTEwNzYxXSAgWzxjMTBhY2UwZT5dID8gcmVtb3ZlX3ZtYSsweDQ1LzB4NGIKWyAg
ICA3LjExMTE4N10gIFs8YzEwYTgxNmQ+XSA/IGZyZWVfcGd0YWJsZXMrMHg4My8weDkxClsg
ICAgNy4xMTE2MTldICBbPGMxMGE3ZWU1Pl0gPyB0bGJfZmluaXNoX21tdSsweGMvMHgyYgpb
ICAgIDcuMTEyMDYzXSAgWzxjMTAyOTAyND5dID8gbG9va3VwX2FkZHJlc3MrMHgxYy8weDFm
ClsgICAgNy4xMTI1MTBdICBbPGMxMGJlOGUyPl0ga21lbV9jYWNoZV9mcmVlKzB4MTQyLzB4
MTRiClsgICAgNy4xMTI5NTRdICBbPGMxMGJlOGUyPl0gPyBrbWVtX2NhY2hlX2ZyZWUrMHgx
NDIvMHgxNGIKWyAgICA3LjExMzQzMF0gIFs8YzEwYWNlMGU+XSA/IHJlbW92ZV92bWErMHg0
NS8weDRiClsgICAgNy4xMTM4MzddICBbPGMxMGFjZTBlPl0gPyByZW1vdmVfdm1hKzB4NDUv
MHg0YgpbICAgIDcuMTE0MjY1XSAgWzxjMTBhY2UwZT5dIHJlbW92ZV92bWErMHg0NS8weDRi
ClsgICAgNy4xMTQ2NjRdICBbPGMxMGFlMzUwPl0gZG9fbXVubWFwKzB4MWUzLzB4MjI2Clsg
ICAgNy4xMTUwODFdICBbPGMxMGFlM2MzPl0gdm1fbXVubWFwKzB4MzAvMHg0MQpbICAgIDcu
MTE1NDcyXSAgWzxjMTBmYTMzYj5dIGxvYWRfZWxmX2JpbmFyeSsweDdmNy8weGI5NQpbICAg
IDcuMTE1OTE3XSAgWzxjMTBjOWQ4OT5dIHNlYXJjaF9iaW5hcnlfaGFuZGxlcisweDY1LzB4
MTMwClsgICAgNy4xMTY0MjBdICBbPGMxMGNhYThhPl0gZG9fZXhlY3ZlKzB4M2E0LzB4NGFk
ClsgICAgNy4xMTY4MjNdICBbPGMxMDAwMzdjPl0gcnVuX2luaXRfcHJvY2VzcysweDFjLzB4
MWUKWyAgICA3LjExNzI3OF0gIFs8YzE2YjdlMTQ+XSBrZXJuZWxfaW5pdCsweDM0LzB4YjgK
WyAgICA3LjExNzY4Ml0gIFs8YzE2Y2VkZjc+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4
MWIvMHgyOApbICAgIDcuMTE4MTgzXSAgWzxjMTZiN2RlMD5dID8gcmVzdF9pbml0KzB4YTEv
MHhhMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMwNjE3NDIvOWQ1OGNmN2EzODhj
MWI0YTA2Y2IzMzU5ODBlYjFiYjEzNTJiYTg3Ni9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTEz
OjIwMTQwMzA3MTM1MDAzOmkzODYtcmFuZGNvbmZpZy1zdDAtMDMwNjE3NDI6My4xNC4wLXJj
NS0wNjkyMS1nOWQ1OGNmNzo2Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMwNjE3
NDIvOWQ1OGNmN2EzODhjMWI0YTA2Y2IzMzU5ODBlYjFiYjEzNTJiYTg3Ni9kbWVzZy1xdWFu
dGFsLWl2eXRvd24yLTIyOjIwMTQwMzA3MTM1MDAzOmkzODYtcmFuZGNvbmZpZy1zdDAtMDMw
NjE3NDI6My4xNC4wLXJjNS0wNjkyMS1nOWQ1OGNmNzo2Nwova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1zdDAtMDMwNjE3NDIvOWQ1OGNmN2EzODhjMWI0YTA2Y2IzMzU5ODBlYjFiYjEzNTJi
YTg3Ni9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTEzOjIwMTQwMzA3MTM1MDIyOmkzODYtcmFu
ZGNvbmZpZy1zdDAtMDMwNjE3NDI6My4xNC4wLXJjNS0wNjkyMS1nOWQ1OGNmNzo2Nwova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMwNjE3NDIvOWQ1OGNmN2EzODhjMWI0YTA2Y2Iz
MzU5ODBlYjFiYjEzNTJiYTg3Ni9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTEzOjIwMTQwMzA3
MTM1MDQyOmkzODYtcmFuZGNvbmZpZy1zdDAtMDMwNjE3NDI6My4xNC4wLXJjNS0wNjkyMS1n
OWQ1OGNmNzo2NwowOjQ6MyBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKQmlzZWN0aW5n
OiAxMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNCBzdGVw
cykKW2IyZmYyY2ZlYmFkOTJiZWJmY2EyOGJhZDY1MDA0NTgyMWVkMjcwYzRdIHRyYWNpbmc6
IHJlcGxhY2UgX19nZXRfY3B1X3ZhciB1c2VzIHdpdGggdGhpc19jcHVfcHRyCnJ1bm5pbmcg
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRl
c3RzL2xpbnV4NC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2
bS9pMzg2LXJhbmRjb25maWctc3QwLTAzMDYxNzQyL25leHQ6bWFzdGVyOmIyZmYyY2ZlYmFk
OTJiZWJmY2EyOGJhZDY1MDA0NTgyMWVkMjcwYzQ6YmlzZWN0LWxpbnV4NAoKMjAxNC0wMy0w
Ny0xMzo1MDo1NyBiMmZmMmNmZWJhZDkyYmViZmNhMjhiYWQ2NTAwNDU4MjFlZDI3MGM0IGNv
bXBpbGluZwoxNzQgcmVhbCAgMzAyNyB1c2VyICAyODEgc3lzICAxOTAwLjUwJSBjcHUgCWkz
ODYtcmFuZGNvbmZpZy1zdDAtMDMwNjE3NDIKCjIwMTQtMDMtMDctMTM6NTU6MjEgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjNS0wNjkwNy1nYjJmZjJjZi4uIFRFU1QgRkFJTFVS
RQpbICAgIDcuMDE4OTcyXSBGcmVlaW5nIHVudXNlZCBrZXJuZWwgbWVtb3J5OiAxNzgwSyAo
YzFhOTUwMDAgLSBjMWM1MjAwMCkKWyAgICA3LjAxOTk2MF0gV3JpdGUgcHJvdGVjdGluZyB0
aGUga2VybmVsIHRleHQ6IDY5NzZrClsgICAgNy4wMjA3NTBdIFdyaXRlIHByb3RlY3Rpbmcg
dGhlIGtlcm5lbCByZWFkLW9ubHkgZGF0YTogMzIyOGsKWyAgICA3LjAyMTczNV0gQlVHOiB1
c2luZyBfX3RoaXNfY3B1X2FkZCgpIGluIHByZWVtcHRpYmxlIFswMDAwMDAwMF0gY29kZTog
aW5pdC8xClsgICAgNy4wMjIzOTFdIGNhbGxlciBpcyBfX3RoaXNfY3B1X3ByZWVtcHRfY2hl
Y2srMHgxZi8weDI3ClsgICAgNy4wMjI4NTJdIENQVTogMCBQSUQ6IDEgQ29tbTogaW5pdCBO
b3QgdGFpbnRlZCAzLjE0LjAtcmM1LTA2OTA3LWdiMmZmMmNmICM2OApbICAgIDcuMDIzNTEx
XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsg
ICAgNy4wMjQwMjJdICAwMDAwMDAwMCAwMDAwMDAwMCBkMWM2ZGQ3YyBjMTZiZTgzMiAwMDAw
MDAwMCBkMWM2ZGRhMCBjMTI3NDA1NSBjMTkwY2JhNwpbICAgIDcuMDI0Nzg0XSAgZDFjNmRk
YjggMDAwMDAwMDAgZDFjNzAzYjggMDAwMDAwMDEgZDFjNmRkYjggZDI3OTQzODAgZDFjNmRk
ZTQgYzEyNzQwOTYKWyAgICA3LjAyNTU1N10gIGQxYzZkZGI4IDAwMDAwMDI4IGMxOTBjYmZi
IGMxOTRjOTMxIDY4NzQ1ZjVmIDYzNWY3MzY5IDYxNWY3NTcwIDI5Mjg2NDY0ClsgICAgNy4w
MjYzMzZdIENhbGwgVHJhY2U6ClsgICAgNy4wMjY1NjFdICBbPGMxNmJlODMyPl0gZHVtcF9z
dGFjaysweDQ5LzB4NzMKWyAgICA3LjAyNjkzN10gIFs8YzEyNzQwNTU+XSBjaGVja19wcmVl
bXB0aW9uX2Rpc2FibGVkKzB4YjAvMHhjMwpbICAgIDcuMDI3NDMwXSAgWzxjMTI3NDA5Nj5d
IF9fdGhpc19jcHVfcHJlZW1wdF9jaGVjaysweDFmLzB4MjcKWyAgICA3LjAyNzkyMF0gIFs8
YzE2YmM5YmI+XSBfX3NsYWJfZnJlZSsweDJjLzB4NDI5ClsgICAgNy4wMjgzMzZdICBbPGMx
MGFjZTAxPl0gPyByZW1vdmVfdm1hKzB4NDUvMHg0YgpbICAgIDcuMDI4NzQyXSAgWzxjMTBh
ODE2MD5dID8gZnJlZV9wZ3RhYmxlcysweDgzLzB4OTEKWyAgICA3LjAyOTE3NF0gIFs8YzEw
YTdlZDg+XSA/IHRsYl9maW5pc2hfbW11KzB4Yy8weDJiClsgICAgNy4wMjk1OTldICBbPGMx
MDI5MDI0Pl0gPyBsb29rdXBfYWRkcmVzcysweDFjLzB4MWYKWyAgICA3LjAzMDA0MF0gIFs8
YzEwYmU4ZDU+XSBrbWVtX2NhY2hlX2ZyZWUrMHgxNDIvMHgxNGIKWyAgICA3LjAzMDQ3MV0g
IFs8YzEwYmU4ZDU+XSA/IGttZW1fY2FjaGVfZnJlZSsweDE0Mi8weDE0YgpbICAgIDcuMDMw
OTE1XSAgWzxjMTBhY2UwMT5dID8gcmVtb3ZlX3ZtYSsweDQ1LzB4NGIKWyAgICA3LjAzMTMy
MV0gIFs8YzEwYWNlMDE+XSA/IHJlbW92ZV92bWErMHg0NS8weDRiClsgICAgNy4wMzE3MjJd
ICBbPGMxMGFjZTAxPl0gcmVtb3ZlX3ZtYSsweDQ1LzB4NGIKWyAgICA3LjAzMjExNV0gIFs8
YzEwYWUzNDM+XSBkb19tdW5tYXArMHgxZTMvMHgyMjYKWyAgICA3LjAzMjUwNF0gIFs8YzEw
YWUzYjY+XSB2bV9tdW5tYXArMHgzMC8weDQxClsgICAgNy4wMzI4ODFdICBbPGMxMGZhMzJl
Pl0gbG9hZF9lbGZfYmluYXJ5KzB4N2Y3LzB4Yjk1ClsgICAgNy4wMzMzMjVdICBbPGMxMGM5
ZDdjPl0gc2VhcmNoX2JpbmFyeV9oYW5kbGVyKzB4NjUvMHgxMzAKWyAgICA3LjAzMzgyMV0g
IFs8YzEwY2FhN2Q+XSBkb19leGVjdmUrMHgzYTQvMHg0YWQKWyAgICA3LjAzNDIyM10gIFs8
YzEwMDAzN2M+XSBydW5faW5pdF9wcm9jZXNzKzB4MWMvMHgxZQpbICAgIDcuMDM0NjUzXSAg
WzxjMTZiN2UwND5dIGtlcm5lbF9pbml0KzB4MzQvMHhiOApbICAgIDcuMDM1MDUxXSAgWzxj
MTZjZWRmNz5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDI4ClsgICAgNy4wMzU1
MjNdICBbPGMxNmI3ZGQwPl0gPyByZXN0X2luaXQrMHhhMS8weGExCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLXN0MC0wMzA2MTc0Mi9iMmZmMmNmZWJhZDkyYmViZmNhMjhiYWQ2NTAwNDU4
MjFlZDI3MGM0L2RtZXNnLXF1YW50YWwtaXZ5dG93bjItMjY6MjAxNDAzMDcxMzU2MDU6aTM4
Ni1yYW5kY29uZmlnLXN0MC0wMzA2MTc0MjozLjE0LjAtcmM1LTA2OTA3LWdiMmZmMmNmOjY4
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA2MTc0Mi9iMmZmMmNmZWJhZDkyYmVi
ZmNhMjhiYWQ2NTAwNDU4MjFlZDI3MGM0L2RtZXNnLXF1YW50YWwtaXZ5dG93bjItMjoyMDE0
MDMwNzEzNTYwMjppMzg2LXJhbmRjb25maWctc3QwLTAzMDYxNzQyOjMuMTQuMC1yYzUtMDY5
MDctZ2IyZmYyY2Y6NjgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMDYxNzQyL2Iy
ZmYyY2ZlYmFkOTJiZWJmY2EyOGJhZDY1MDA0NTgyMWVkMjcwYzQvZG1lc2ctcXVhbnRhbC1p
dnl0b3duMi0zMDoyMDE0MDMwNzEzNTU1ODppMzg2LXJhbmRjb25maWctc3QwLTAzMDYxNzQy
OjMuMTQuMC1yYzUtMDY5MDctZ2IyZmYyY2Y6NjgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
c3QwLTAzMDYxNzQyL2IyZmYyY2ZlYmFkOTJiZWJmY2EyOGJhZDY1MDA0NTgyMWVkMjcwYzQv
ZG1lc2cteW9jdG8tYmVucy03OjIwMTQwMzA3MTM1NjAyOmkzODYtcmFuZGNvbmZpZy1zdDAt
MDMwNjE3NDI6My4xNC4wLXJjNS0wNjkwNy1nYjJmZjJjZjo2OAova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1zdDAtMDMwNjE3NDIvYjJmZjJjZmViYWQ5MmJlYmZjYTI4YmFkNjUwMDQ1ODIx
ZWQyNzBjNC9kbWVzZy15b2N0by1pdnl0b3duMi0zMToyMDE0MDMwNzEzNTYwMjppMzg2LXJh
bmRjb25maWctc3QwLTAzMDYxNzQyOjMuMTQuMC1yYzUtMDY5MDctZ2IyZmYyY2Y6NjgKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMDYxNzQyL2IyZmYyY2ZlYmFkOTJiZWJmY2Ey
OGJhZDY1MDA0NTgyMWVkMjcwYzQvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0yNzoyMDE0MDMw
NzEzNTYxNzppMzg2LXJhbmRjb25maWctc3QwLTAzMDYxNzQyOjMuMTQuMC1yYzUtMDY5MDct
Z2IyZmYyY2Y6NjgKMDo2OjYgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIw
MTQtMDMtMDcgMTM6NTY6MjMgUkVQRUFUIENPVU5UOiAyMCAgIyAva2VybmVsLXRlc3RzL2xp
bnV4NC9vYmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDYgcmV2aXNpb25zIGxl
ZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3RlcHMpCls2ZmI3NzkzNjQ4MTUz
OGJhMDU3MjYzNDVkODZhZjRiMzkxMjhhOGE5XSBhcm06IG1vdmUgYXJtX2RtYV9saW1pdCB0
byBzZXR1cF9kbWFfem9uZQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDQvb2JqLWJpc2VjdApscyAtYSAv
a2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA2MTc0
Mi9uZXh0Om1hc3Rlcjo2ZmI3NzkzNjQ4MTUzOGJhMDU3MjYzNDVkODZhZjRiMzkxMjhhOGE5
OmJpc2VjdC1saW51eDQKCjIwMTQtMDMtMDctMTM6NTY6MjMgNmZiNzc5MzY0ODE1MzhiYTA1
NzI2MzQ1ZDg2YWY0YjM5MTI4YThhOSBjb21waWxpbmcKMTY3IHJlYWwgIDMwMzYgdXNlciAg
Mjg1IHN5cyAgMTk4Ny4xNSUgY3B1IAlpMzg2LXJhbmRjb25maWctc3QwLTAzMDYxNzQyCgoy
MDE0LTAzLTA3LTEzOjU5OjM3IGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1yYzUtMDY5
MDAtZzZmYjc3OTMuLi4JNAk5CTE4CTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMyByZXZpc2lv
bnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMiBzdGVwcykKW2QxY2VhMDdl
ZmJmYTI3MjNjYTFiODNkM2E2OWQxZjEwMDA4OTZkNGRdIG1vZHVsZXM6IHVzZSByYXdfY3B1
X3dyaXRlIGZvciBpbml0aWFsaXphdGlvbiBvZiBwZXIgY3B1IHJlZmNvdW50LgpydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10
ZXN0cy9saW51eDQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0vaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA2MTc0Mi9uZXh0Om1hc3RlcjpkMWNlYTA3ZWZi
ZmEyNzIzY2ExYjgzZDNhNjlkMWYxMDAwODk2ZDRkOmJpc2VjdC1saW51eDQKCjIwMTQtMDMt
MDctMTQ6MDM6MDggZDFjZWEwN2VmYmZhMjcyM2NhMWI4M2QzYTY5ZDFmMTAwMDg5NmQ0ZCBj
b21waWxpbmcKMTc5IHJlYWwgIDMwNDAgdXNlciAgMjkwIHN5cyAgMTg2MC44MCUgY3B1IAlp
Mzg2LXJhbmRjb25maWctc3QwLTAzMDYxNzQyCgoyMDE0LTAzLTA3LTE0OjA2OjM0IGRldGVj
dGluZyBib290IHN0YXRlIDMuMTQuMC1yYzUtMDY5MDMtZ2QxY2VhMDcuLi4JMgk5CTE1Li4J
MTcJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxIHJldmlzaW9uIGxlZnQgdG8gdGVzdCBhZnRl
ciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKW2EyNTk4MmMxNWFlNTI5ODUyMDAzM2NkNTg0OGE4
MmFkZjZhOTczNzZdIHBlcmNwdTogYWRkIHByZWVtcHRpb24gY2hlY2tzIHRvIF9fdGhpc19j
cHUgb3BzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVy
ZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4NC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVz
dHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctc3QwLTAzMDYxNzQyL25leHQ6bWFz
dGVyOmEyNTk4MmMxNWFlNTI5ODUyMDAzM2NkNTg0OGE4MmFkZjZhOTczNzY6YmlzZWN0LWxp
bnV4NAoKMjAxNC0wMy0wNy0xNDoxMTozNSBhMjU5ODJjMTVhZTUyOTg1MjAwMzNjZDU4NDhh
ODJhZGY2YTk3Mzc2IGNvbXBpbGluZwoxNjggcmVhbCAgMzAyNSB1c2VyICAyODEgc3lzICAx
OTU4LjEzJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1zdDAtMDMwNjE3NDIKCjIwMTQtMDMtMDct
MTQ6MTQ6NDggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjNS0wNjkwNS1nYTI1OTgy
Yy4uLi4gVEVTVCBGQUlMVVJFClsgICAgNS42MTkyODRdIEZyZWVpbmcgdW51c2VkIGtlcm5l
bCBtZW1vcnk6IDE3ODBLIChjMWE5NTAwMCAtIGMxYzUyMDAwKQpbICAgIDUuNjIwMjQ3XSBX
cml0ZSBwcm90ZWN0aW5nIHRoZSBrZXJuZWwgdGV4dDogNjk3NmsKWyAgICA1LjYyMTAyMF0g
V3JpdGUgcHJvdGVjdGluZyB0aGUga2VybmVsIHJlYWQtb25seSBkYXRhOiAzMjI4awpbICAg
IDUuNjIxOTE5XSBCVUc6IHVzaW5nIF9fdGhpc19jcHVfYWRkKCkgaW4gcHJlZW1wdGlibGUg
WzAwMDAwMDAwXSBjb2RlOiBpbml0LzEKWyAgICA1LjYyMjU3Nl0gY2FsbGVyIGlzIF9fdGhp
c19jcHVfcHJlZW1wdF9jaGVjaysweDFmLzB4MjcKWyAgICA1LjYyMzA1N10gQ1BVOiAwIFBJ
RDogMSBDb21tOiBpbml0IE5vdCB0YWludGVkIDMuMTQuMC1yYzUtMDY5MDUtZ2EyNTk4MmMg
IzcxClsgICAgNS42MjM2NzBdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJv
Y2hzIDAxLzAxLzIwMTEKWyAgICA1LjYyNDE4NV0gIDAwMDAwMDAwIDAwMDAwMDAwIGQzMDZk
ZDA0IGMxNmJlODAyIDAwMDAwMDAwIGQzMDZkZDI4IGMxMjc0MDI1IGMxOTBjYmEzClsgICAg
NS42MjQ5NDldICBkMzA2ZGQ0MCAwMDAwMDAwMCBkMzA3MDNiOCAwMDAwMDAwMSBkMzA2ZGQ0
MCBkM2M2Zjc2MCBkMzA2ZGQ2YyBjMTI3NDA2NgpbICAgIDUuNjI1NzE4XSAgZDMwNmRkNDAg
MDAwMDAwMjggYzE5MGNiZjcgYzE5NGM5MmQgNjg3NDVmNWYgNjM1ZjczNjkgNjE1Zjc1NzAg
MjkyODY0NjQKWyAgICA1LjYyNjQ5M10gQ2FsbCBUcmFjZToKWyAgICA1LjYyNjcxMV0gIFs8
YzE2YmU4MDI+XSBkdW1wX3N0YWNrKzB4NDkvMHg3MwpbICAgIDUuNjI3MTEyXSAgWzxjMTI3
NDAyNT5dIGNoZWNrX3ByZWVtcHRpb25fZGlzYWJsZWQrMHhiMC8weGMzClsgICAgNS42Mjc2
MDZdICBbPGMxMjc0MDY2Pl0gX190aGlzX2NwdV9wcmVlbXB0X2NoZWNrKzB4MWYvMHgyNwpb
ICAgIDUuNjI4MTA5XSAgWzxjMTAyNzk0MT5dID8ga3ZtX2Nsb2NrX3JlYWQrMHgxZS8weDMx
ClsgICAgNS42Mjg1MzZdICBbPGMxNmJjOThiPl0gX19zbGFiX2ZyZWUrMHgyYy8weDQyOQpb
ICAgIDUuNjI4OTQxXSAgWzxjMTA0ZjZmMD5dID8gc2NoZWRfY2xvY2tfbG9jYWwrMHgxMS8w
eGZhClsgICAgNS42Mjk0MDldICBbPGMxMGE5ZTFkPl0gPyBwdGxvY2tfZnJlZSsweDEwLzB4
MTIKWyAgICA1LjYyOTgyMF0gIFs8YzEwNGZhMWY+XSA/IHNjaGVkX2Nsb2NrX2NwdSsweGUz
LzB4MTBkClsgICAgNS42MzAyNzRdICBbPGMxMDI5MDI0Pl0gPyBsb29rdXBfYWRkcmVzcysw
eDFjLzB4MWYKWyAgICA1LjYzMDY5OV0gIFs8YzEwYmU4Yzc+XSBrbWVtX2NhY2hlX2ZyZWUr
MHgxMzQvMHgxM2QKWyAgICA1LjYzMTE1MF0gIFs8YzEwYmU4Yzc+XSA/IGttZW1fY2FjaGVf
ZnJlZSsweDEzNC8weDEzZApbICAgIDUuNjMxNTk3XSAgWzxjMTBhOWUxZD5dID8gcHRsb2Nr
X2ZyZWUrMHgxMC8weDEyClsgICAgNS42MzIwMThdICBbPGMxMGE5ZTFkPl0gPyBwdGxvY2tf
ZnJlZSsweDEwLzB4MTIKWyAgICA1LjYzMjQyNF0gIFs8YzEwYTllMWQ+XSBwdGxvY2tfZnJl
ZSsweDEwLzB4MTIKWyAgICA1LjYzMjgyNV0gIFs8YzEwMmE5ZDk+XSBfX19wdGVfZnJlZV90
bGIrMHgxNy8weDRjClsgICAgNS42MzMyNTddICBbPGMxMGE4MGJjPl0gZnJlZV9wZ2RfcmFu
Z2UrMHgxM2YvMHgxNjAKWyAgICA1LjYzMzY4OF0gIFs8YzEwYzk3NzE+XSBzZXR1cF9hcmdf
cGFnZXMrMHgyMzUvMHgyN2YKWyAgICA1LjYzNDE0Nl0gIFs8YzEyZWM2N2M+XSA/IGdldF9y
YW5kb21faW50KzB4NjAvMHg3NwpbICAgIDUuNjM0NTczXSAgWzxjMTBmOWRmOD5dIGxvYWRf
ZWxmX2JpbmFyeSsweDJlOS8weGI5NQpbICAgIDUuNjM1MDI0XSAgWzxjMTI3NDA0NT5dID8g
ZGVidWdfc21wX3Byb2Nlc3Nvcl9pZCsweGQvMHhmClsgICAgNS42MzU0OTJdICBbPGMxMGM5
ZDU0Pl0gc2VhcmNoX2JpbmFyeV9oYW5kbGVyKzB4NjUvMHgxMzAKWyAgICA1LjYzNTk2NF0g
IFs8YzEwY2FhNTU+XSBkb19leGVjdmUrMHgzYTQvMHg0YWQKWyAgICA1LjYzNjM2OV0gIFs8
YzEwMDAzN2M+XSBydW5faW5pdF9wcm9jZXNzKzB4MWMvMHgxZQpbICAgIDUuNjM2Nzk5XSAg
WzxjMTZiN2RkND5dIGtlcm5lbF9pbml0KzB4MzQvMHhiOApbICAgIDUuNjM3MjAxXSAgWzxj
MTZjZWRiNz5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDI4ClsgICAgNS42Mzc2
NzVdICBbPGMxNmI3ZGEwPl0gPyByZXN0X2luaXQrMHhhMS8weGExCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLXN0MC0wMzA2MTc0Mi9hMjU5ODJjMTVhZTUyOTg1MjAwMzNjZDU4NDhhODJh
ZGY2YTk3Mzc2L2RtZXNnLXlvY3RvLWl2eXRvd24yLTExOjIwMTQwMzA3MTQxNjI4OmkzODYt
cmFuZGNvbmZpZy1zdDAtMDMwNjE3NDI6My4xNC4wLXJjNS0wNjkwNS1nYTI1OTgyYzo3MQow
OjE6MSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wMy0wNyAxNDox
Njo1MCBSRVBFQVQgQ09VTlQ6IDIwICAjIC9rZXJuZWwtdGVzdHMvbGludXg0L29iai1iaXNl
Y3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgMCBzdGVwcykKWzI2ZDAyY2ZhMzg1MDY3YzM5YzA0MDdiMDIy
YzAxYTAxMWMyZmJiNTFdIG5ldDogcmVwbGFjZSBfX3RoaXNfY3B1X2luYyBpbiByb3V0ZS5j
IHdpdGggcmF3X2NwdV9pbmMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg0L29iai1iaXNlY3QKbHMgLWEg
L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMwNjE3
NDIvbmV4dDptYXN0ZXI6MjZkMDJjZmEzODUwNjdjMzljMDQwN2IwMjJjMDFhMDExYzJmYmI1
MTpiaXNlY3QtbGludXg0CgoyMDE0LTAzLTA3LTE0OjE2OjUxIDI2ZDAyY2ZhMzg1MDY3YzM5
YzA0MDdiMDIyYzAxYTAxMWMyZmJiNTEgY29tcGlsaW5nCjE3MCByZWFsICAzMDExIHVzZXIg
IDI5MiBzeXMgIDE5MzQuMTElIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA2MTc0MgoK
MjAxNC0wMy0wNy0xNDoyMDowNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmM1LTA2
OTA0LWcyNmQwMmNmLi4uCTUJMTMuLi4uLi4uLi4uLi4JMTUJMTguCTIwIFNVQ0NFU1MKCmEy
NTk4MmMxNWFlNTI5ODUyMDAzM2NkNTg0OGE4MmFkZjZhOTczNzYgaXMgdGhlIGZpcnN0IGJh
ZCBjb21taXQKY29tbWl0IGEyNTk4MmMxNWFlNTI5ODUyMDAzM2NkNTg0OGE4MmFkZjZhOTcz
NzYKQXV0aG9yOiBDaHJpc3RvcGggTGFtZXRlciA8Y2xAbGludXguY29tPgpEYXRlOiAgIFRo
dSBNYXIgNiAxMTowNToyMSAyMDE0ICsxMTAwCgogICAgcGVyY3B1OiBhZGQgcHJlZW1wdGlv
biBjaGVja3MgdG8gX190aGlzX2NwdSBvcHMKICAgIAogICAgV2UgZGVmaW5lIGEgY2hlY2sg
ZnVuY3Rpb24gaW4gb3JkZXIgdG8gYXZvaWQgdHJvdWJsZSB3aXRoIHRoZSBpbmNsdWRlCiAg
ICBmaWxlcy4gIFRoZW4gdGhlIGhpZ2hlciBsZXZlbCBfX3RoaXNfY3B1IG1hY3JvcyBhcmUg
bW9kaWZpZWQgdG8gaW52b2tlIHRoZQogICAgcHJlZW1wdGlvbiBjaGVjay4KICAgIAogICAg
U2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIExhbWV0ZXIgPGNsQGxpbnV4LmNvbT4KICAgIEFj
a2VkLWJ5OiBJbmdvIE1vbG5hciA8bWluZ29Aa2VybmVsLm9yZz4KICAgIENjOiBUZWp1biBI
ZW8gPHRqQGtlcm5lbC5vcmc+CiAgICBTaWduZWQtb2ZmLWJ5OiBBbmRyZXcgTW9ydG9uIDxh
a3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnPgoKOjA0MDAwMCAwNDAwMDAgMzY3ZmM0NjA5YjNk
YTQzYjM3NmNkMmE1NTViNzIwODEwMzA4ZDA5NCAwOWIxMmMwYTQ5MWEzNWIzZGRjYmJkNmU5
ZDUwODRjNzE5NmE1M2YzIE0JaW5jbHVkZQo6MDQwMDAwIDA0MDAwMCBmZDIyNjY0YjBlNjQ2
OGY1NTAwNTk5ZjlhMjQ4OWJhYTM5NjYzOWM4IGVkMTdjY2FjZjE1NWZmNTdhNTlkYmY5MTVj
MWVlNGE0ZDUxMzdkM2IgTQlsaWIKYmlzZWN0IHJ1biBzdWNjZXNzCmxzIC1hIC9rZXJuZWwt
dGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctc3QwLTAzMDYxNzQyL25leHQ6
bWFzdGVyOjI2ZDAyY2ZhMzg1MDY3YzM5YzA0MDdiMDIyYzAxYTAxMWMyZmJiNTE6YmlzZWN0
LWxpbnV4NAoKMjAxNC0wMy0wNy0xNDozMDozOCAyNmQwMmNmYTM4NTA2N2MzOWMwNDA3YjAy
MmMwMWEwMTFjMmZiYjUxIHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA2
MTc0Mi8yNmQwMmNmYTM4NTA2N2MzOWMwNDA3YjAyMmMwMWEwMTFjMmZiYjUxL3ZtbGludXot
My4xNC4wLXJjNS0wNjkwNC1nMjZkMDJjZgoKMjAxNC0wMy0wNy0xNDozMDozOCBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAuLi4JMjQuCTI4CTQxCTU0CTU1CTU2Li4uLi4uLi4uLi4uLi4uCTU5
Li4uLi4JNjAgU1VDQ0VTUwoKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kz
ODYtcmFuZGNvbmZpZy1zdDAtMDMwNjE3NDIvbmV4dDptYXN0ZXI6MGZmYjJmZTdiOWMzMDA4
Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMzpiaXNlY3QtbGludXg0CiBURVNUIEZBSUxVUkUK
WyAgICA5Ljg4Mzk4NF0gRnJlZWluZyB1bnVzZWQga2VybmVsIG1lbW9yeTogMTc4MEsgKGMx
YWFiMDAwIC0gYzFjNjgwMDApClsgICAgOS44ODU1NTBdIFdyaXRlIHByb3RlY3RpbmcgdGhl
IGtlcm5lbCB0ZXh0OiA3MDEyawpbICAgIDkuODg2OTU1XSBXcml0ZSBwcm90ZWN0aW5nIHRo
ZSBrZXJuZWwgcmVhZC1vbmx5IGRhdGE6IDMyNjRrClsgICAgOS44ODg0NjNdIEJVRzogdXNp
bmcgX190aGlzX2NwdV9hZGQoKSBpbiBwcmVlbXB0aWJsZSBbMDAwMDAwMDBdIGNvZGU6IGlu
aXQvMQpbICAgIDkuODg5Mzc3XSBjYWxsZXIgaXMgX190aGlzX2NwdV9wcmVlbXB0X2NoZWNr
KzB4MWYvMHgyNwpbICAgIDkuODkwMDM4XSBDUFU6IDEgUElEOiAxIENvbW06IGluaXQgTm90
IHRhaW50ZWQgMy4xNC4wLXJjNS1uZXh0LTIwMTQwMzA2LTA3MTM4LWcwZmZiMmZlICMzClsg
ICAgOS44OTEwNDRdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAx
LzAxLzIwMTEKWyAgICA5Ljg5MTcyOF0gIDAwMDAwMDAwIDAwMDAwMDAwIGNkYzZkZDA0IGMx
NmM3YTY4IDAwMDAwMDAxIGNkYzZkZDI4IGMxMjczY2EyIGMxOTFkNGU1ClsgICAgOS44OTI4
MTVdICBjZGM2ZGQ0MCAwMDAwMDAwMCBjZGM3MDNiOCAwMDAwMDAwMSBjZGM2ZGQ0MCBjZTc5
M2NjMCBjZGM2ZGQ2YyBjMTI3M2NlMwpbICAgIDkuODkzODk3XSAgY2RjNmRkNDAgMDAwMDAw
MjggYzE5MWQ1MzkgYzE5NWQ2OTYgNjg3NDVmNWYgNjM1ZjczNjkgNjE1Zjc1NzAgMjkyODY0
NjQKWyAgICA5Ljg5NDk4M10gQ2FsbCBUcmFjZToKWyAgICA5Ljg5NTMxMl0gIFs8YzE2Yzdh
Njg+XSBkdW1wX3N0YWNrKzB4NDkvMHg3MwpbICAgIDkuODk1ODQ5XSAgWzxjMTI3M2NhMj5d
IGNoZWNrX3ByZWVtcHRpb25fZGlzYWJsZWQrMHhiMC8weGMzClsgICAgOS44OTY1NTddICBb
PGMxMjczY2UzPl0gX190aGlzX2NwdV9wcmVlbXB0X2NoZWNrKzB4MWYvMHgyNwpbICAgIDku
ODk3MzkxXSAgWzxjMTAyNzhiYj5dID8ga3ZtX2Nsb2NrX3JlYWQrMHgxZS8weDMxClsgICAg
OS44OTgxMDldICBbPGMxNmM1YzA2Pl0gX19zbGFiX2ZyZWUrMHgyYy8weDQyMgpbICAgIDku
ODk4NzU2XSAgWzxjMTA0ZjY1ZD5dID8gc2NoZWRfY2xvY2tfbG9jYWwrMHgxMS8weGZhClsg
ICAgOS44OTk0OThdICBbPGMxMGE5ZDQ5Pl0gPyBwdGxvY2tfZnJlZSsweDEwLzB4MTIKWyAg
ICA5LjkwMDE3NF0gIFs8YzEwNGY5OGM+XSA/IHNjaGVkX2Nsb2NrX2NwdSsweGUzLzB4MTBk
ClsgICAgOS45MDA4ODRdICBbPGMxMDI4ZjllPl0gPyBsb29rdXBfYWRkcmVzcysweDFjLzB4
MWYKWyAgICA5LjkwMTU4NF0gIFs8YzEwYmU3Nzg+XSBrbWVtX2NhY2hlX2ZyZWUrMHgxNDIv
MHgxNGIKWyAgICA5LjkwMjMyMl0gIFs8YzEwYmU3Nzg+XSA/IGttZW1fY2FjaGVfZnJlZSsw
eDE0Mi8weDE0YgpbICAgIDkuOTAzMDY1XSAgWzxjMTBhOWQ0OT5dID8gcHRsb2NrX2ZyZWUr
MHgxMC8weDEyClsgICAgOS45MDM3MTZdICBbPGMxMGE5ZDQ5Pl0gPyBwdGxvY2tfZnJlZSsw
eDEwLzB4MTIKWyAgICA5LjkwNDM4Ml0gIFs8YzEwYTlkNDk+XSBwdGxvY2tfZnJlZSsweDEw
LzB4MTIKWyAgICA5LjkwNTAzNl0gIFs8YzEwMmE5NTM+XSBfX19wdGVfZnJlZV90bGIrMHgx
Ny8weDRjClsgICAgOS45MDU3MTBdICBbPGMxMGE3ZmU4Pl0gZnJlZV9wZ2RfcmFuZ2UrMHgx
M2YvMHgxNjAKWyAgICA5LjkwNjQxMV0gIFs8YzEwYzk2Mjg+XSBzZXR1cF9hcmdfcGFnZXMr
MHgyMzUvMHgyN2YKWyAgICA5LjkxNzIxM10gIFs8YzEyZWQ1YTU+XSA/IGdldF9yYW5kb21f
aW50KzB4NjAvMHg3NwpbICAgIDkuOTE3OTEzXSAgWzxjMTBmOWM4Yj5dIGxvYWRfZWxmX2Jp
bmFyeSsweDJlOS8weGI5NQpbICAgIDkuOTE4NjU2XSAgWzxjMTI3M2NjMj5dID8gZGVidWdf
c21wX3Byb2Nlc3Nvcl9pZCsweGQvMHhmClsgICAgOS45MTk0MzldICBbPGMxMGM5YzBiPl0g
c2VhcmNoX2JpbmFyeV9oYW5kbGVyKzB4NjUvMHgxMzAKWyAgICA5LjkyMDIzOF0gIFs8YzEw
Y2E5MGM+XSBkb19leGVjdmUrMHgzYTQvMHg0YWQKWyAgICA5LjkyMDg3NF0gIFs8YzEwMDAz
N2M+XSBydW5faW5pdF9wcm9jZXNzKzB4MWMvMHgxZQpbICAgIDkuOTIxNjEwXSAgWzxjMTZj
MTAzMT5dIGtlcm5lbF9pbml0KzB4MzQvMHhiOApbICAgIDkuOTIyMjYwXSAgWzxjMTZkODAz
Nz5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDI4ClsgICAgOS45MjMwNjddICBb
PGMxNmMwZmZkPl0gPyByZXN0X2luaXQrMHhhMS8weGExCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLXN0MC0wMzA2MTc0Mi8wZmZiMmZlN2I5YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2MzJj
ZjAzL2RtZXNnLXF1YW50YWwtd2FpbWVhLTY6MjAxNDAzMDcwOTAyNTM6aTM4Ni1yYW5kY29u
ZmlnLXN0MC0wMzA2MTc0MjozLjE0LjAtcmM1LW5leHQtMjAxNDAzMDYtMDcxMzgtZzBmZmIy
ZmU6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMwNjE3NDIvMGZmYjJmZTdiOWMz
MDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMy9kbWVzZy15b2N0by1hdGhlbnMtMjU6MjAx
NDAzMDcwOTAwMjc6aTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA2MTc0MjozLjE0LjAtcmM1LW5l
eHQtMjAxNDAzMDYtMDcxMzgtZzBmZmIyZmU6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1z
dDAtMDMwNjE3NDIvMGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMy9k
bWVzZy1xdWFudGFsLWF0aGVucy0yNToyMDE0MDMwNjIwMDAxODppMzg2LXJhbmRjb25maWct
c3QwLTAzMDYxNzQyOjMuMTQuMC1yYzUtbmV4dC0yMDE0MDMwNi0wNzEzOC1nMGZmYjJmZToz
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA2MTc0Mi8wZmZiMmZlN2I5YzMwMDgy
ODc2ZmEzYTE3ZGEwMThiZjA2MzJjZjAzL2RtZXNnLXlvY3RvLWF0aGVucy0zMjoyMDE0MDMw
NjIwMDIxMjppMzg2LXJhbmRjb25maWctc3QwLTAzMDYxNzQyOjMuMTQuMC1yYzUtbmV4dC0y
MDE0MDMwNi0wNzEzOC1nMGZmYjJmZTozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0w
MzA2MTc0Mi8wZmZiMmZlN2I5YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2MzJjZjAzL2RtZXNn
LXF1YW50YWwtcm9hbS00NDoyMDE0MDMwNzA3MDMxNTppMzg2LXJhbmRjb25maWctc3QwLTAz
MDYxNzQyOjMuMTQuMC1yYzUtbmV4dC0yMDE0MDMwNi0wNzEzOC1nMGZmYjJmZTozCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA2MTc0Mi8wZmZiMmZlN2I5YzMwMDgyODc2ZmEz
YTE3ZGEwMThiZjA2MzJjZjAzL2RtZXNnLXF1YW50YWwteGd3by03OjIwMTQwMzA3MDkwMTQ1
OmkzODYtcmFuZGNvbmZpZy1zdDAtMDMwNjE3NDI6My4xNC4wLXJjNS1uZXh0LTIwMTQwMzA2
LTA3MTM4LWcwZmZiMmZlOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMDYxNzQy
LzBmZmIyZmU3YjljMzAwODI4NzZmYTNhMTdkYTAxOGJmMDYzMmNmMDMvZG1lc2ctcXVhbnRh
bC14aWFuLTE2OjIwMTQwMzA2MTk1OTQxOmkzODYtcmFuZGNvbmZpZy1zdDAtMDMwNjE3NDI6
My4xNC4wLXJjNS1uZXh0LTIwMTQwMzA2LTA3MTM4LWcwZmZiMmZlOjMKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctc3QwLTAzMDYxNzQyLzBmZmIyZmU3YjljMzAwODI4NzZmYTNhMTdkYTAx
OGJmMDYzMmNmMDMvZG1lc2ctcXVhbnRhbC1yb2FtLTE4OjIwMTQwMzA2MTk1OTE3OmkzODYt
cmFuZGNvbmZpZy1zdDAtMDMwNjE3NDI6My4xNC4wLXJjNS1uZXh0LTIwMTQwMzA2LTA3MTM4
LWcwZmZiMmZlOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMDYxNzQyLzBmZmIy
ZmU3YjljMzAwODI4NzZmYTNhMTdkYTAxOGJmMDYzMmNmMDMvZG1lc2cteW9jdG8tcm9hbS0y
MDoyMDE0MDMwNjIwMDQ0MzppMzg2LXJhbmRjb25maWctc3QwLTAzMDYxNzQyOjMuMTQuMC1y
YzUtbmV4dC0yMDE0MDMwNi0wNzEzOC1nMGZmYjJmZTozCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLXN0MC0wMzA2MTc0Mi8wZmZiMmZlN2I5YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2MzJj
ZjAzL2RtZXNnLXlvY3RvLWlubi03OjIwMTQwMzA2MTk1OTIzOmkzODYtcmFuZGNvbmZpZy1z
dDAtMDMwNjE3NDI6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMwNjE3NDIvMGZm
YjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMy9kbWVzZy1xdWFudGFsLXhn
d28tNjoyMDE0MDMwNzA5MDE1NTppMzg2LXJhbmRjb25maWctc3QwLTAzMDYxNzQyOjMuMTQu
MC1yYzUtbmV4dC0yMDE0MDMwNi0wNzEzOC1nMGZmYjJmZTozCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXN0MC0wMzA2MTc0Mi8wZmZiMmZlN2I5YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2
MzJjZjAzL2RtZXNnLXF1YW50YWwtaW5uLTY6MjAxNDAzMDYyMDA1MTk6aTM4Ni1yYW5kY29u
ZmlnLXN0MC0wMzA2MTc0Mjo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA2MTc0
Mi8wZmZiMmZlN2I5YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2MzJjZjAzL2RtZXNnLXlvY3Rv
LXhpYW4tMzE6MjAxNDAzMDcwOTAyMTA6aTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA2MTc0Mjoz
LjE0LjAtcmM1LW5leHQtMjAxNDAzMDYtMDcxMzgtZzBmZmIyZmU6Mwova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1zdDAtMDMwNjE3NDIvMGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4
YmYwNjMyY2YwMy9kbWVzZy15b2N0by1iZW5zLTQ6MjAxNDAzMDcwOTAxMzk6aTM4Ni1yYW5k
Y29uZmlnLXN0MC0wMzA2MTc0MjozLjE0LjAtcmM1LW5leHQtMjAxNDAzMDYtMDcxMzgtZzBm
ZmIyZmU6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMwNjE3NDIvMGZmYjJmZTdi
OWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMy9kbWVzZy1xdWFudGFsLWJlbnMtMToy
MDE0MDMwNzA5MDE0NTppMzg2LXJhbmRjb25maWctc3QwLTAzMDYxNzQyOjMuMTQuMC1yYzUt
bmV4dC0yMDE0MDMwNi0wNzEzOC1nMGZmYjJmZTozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXN0MC0wMzA2MTc0Mi8wZmZiMmZlN2I5YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2MzJjZjAz
L2RtZXNnLXF1YW50YWwtd2FpbWVhLTEwOjIwMTQwMzA3MDkwMjUwOmkzODYtcmFuZGNvbmZp
Zy1zdDAtMDMwNjE3NDI6My4xNC4wLXJjNS1uZXh0LTIwMTQwMzA2LTA3MTM4LWcwZmZiMmZl
OjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMDYxNzQyLzBmZmIyZmU3YjljMzAw
ODI4NzZmYTNhMTdkYTAxOGJmMDYzMmNmMDMvZG1lc2cteW9jdG8tYmVucy0zOjIwMTQwMzA3
MDkwMDIyOmkzODYtcmFuZGNvbmZpZy1zdDAtMDMwNjE3NDI6My4xNC4wLXJjNS1uZXh0LTIw
MTQwMzA2LTA3MTM4LWcwZmZiMmZlOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAz
MDYxNzQyLzBmZmIyZmU3YjljMzAwODI4NzZmYTNhMTdkYTAxOGJmMDYzMmNmMDMvZG1lc2ct
cXVhbnRhbC1yb2FtLTQ4OjIwMTQwMzA2MjAwNTAwOmkzODYtcmFuZGNvbmZpZy1zdDAtMDMw
NjE3NDI6My4xNC4wLXJjNS1uZXh0LTIwMTQwMzA2LTA3MTM4LWcwZmZiMmZlOjMKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctc3QwLTAzMDYxNzQyLzBmZmIyZmU3YjljMzAwODI4NzZmYTNh
MTdkYTAxOGJmMDYzMmNmMDMvZG1lc2ctcXVhbnRhbC13YWltZWEtMTM6MjAxNDAzMDcwOTAy
NTM6aTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA2MTc0MjozLjE0LjAtcmM1LW5leHQtMjAxNDAz
MDYtMDcxMzgtZzBmZmIyZmU6MwowOjE5OjE5IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3Rz
CgpbZGV0YWNoZWQgSEVBRCA2MzRlNjJjXSBSZXZlcnQgInBlcmNwdTogYWRkIHByZWVtcHRp
b24gY2hlY2tzIHRvIF9fdGhpc19jcHUgb3BzIgogQ29tbWl0dGVyOiBXdSBGZW5nZ3Vhbmcg
PGtidWlsZEBiZWU+CllvdXIgbmFtZSBhbmQgZW1haWwgYWRkcmVzcyB3ZXJlIGNvbmZpZ3Vy
ZWQgYXV0b21hdGljYWxseSBiYXNlZApvbiB5b3VyIHVzZXJuYW1lIGFuZCBob3N0bmFtZS4g
UGxlYXNlIGNoZWNrIHRoYXQgdGhleSBhcmUgYWNjdXJhdGUuCllvdSBjYW4gc3VwcHJlc3Mg
dGhpcyBtZXNzYWdlIGJ5IHNldHRpbmcgdGhlbSBleHBsaWNpdGx5OgoKICAgIGdpdCBjb25m
aWcgLS1nbG9iYWwgdXNlci5uYW1lICJZb3VyIE5hbWUiCiAgICBnaXQgY29uZmlnIC0tZ2xv
YmFsIHVzZXIuZW1haWwgeW91QGV4YW1wbGUuY29tCgpBZnRlciBkb2luZyB0aGlzLCB5b3Ug
bWF5IGZpeCB0aGUgaWRlbnRpdHkgdXNlZCBmb3IgdGhpcyBjb21taXQgd2l0aDoKCiAgICBn
aXQgY29tbWl0IC0tYW1lbmQgLS1yZXNldC1hdXRob3IKCiAyIGZpbGVzIGNoYW5nZWQsIDE0
IGluc2VydGlvbnMoKyksIDQ1IGRlbGV0aW9ucygtKQpscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA2MTc0Mi9uZXh0Om1hc3Rlcjo2
MzRlNjJjYzRkNDFiNjZhMjQ5ZDM0MDdlOTdmZDU3OTk3ZGJmOTE4OmJpc2VjdC1saW51eDQK
CjIwMTQtMDMtMDctMTQ6NDY6NDYgNjM0ZTYyY2M0ZDQxYjY2YTI0OWQzNDA3ZTk3ZmQ1Nzk5
N2RiZjkxOCBjb21waWxpbmcKCjIwMTQtMDMtMDctMTQ6NTA6NTEgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgMy4xNC4wLXJjNS1uZXh0LTIwMTQwMzA2LTAwMDAxLWc2MzRlNjJjLi4uLgk0CTE2
CTMxLi4uLi4uLgkzNwk0NAk0Ni4uLi4JNTEJNTYJNTkuLi4uLgk2MCBTVUNDRVNTCgoKPT09
PT09PT09IHVwc3RyZWFtID09PT09PT09PQpXYXJuaW5nOiB5b3UgYXJlIGxlYXZpbmcgMSBj
b21taXQgYmVoaW5kLCBub3QgY29ubmVjdGVkIHRvCmFueSBvZiB5b3VyIGJyYW5jaGVzOgoK
ICA2MzRlNjJjIFJldmVydCAicGVyY3B1OiBhZGQgcHJlZW1wdGlvbiBjaGVja3MgdG8gX190
aGlzX2NwdSBvcHMiCgpJZiB5b3Ugd2FudCB0byBrZWVwIHRoZW0gYnkgY3JlYXRpbmcgYSBu
ZXcgYnJhbmNoLCB0aGlzIG1heSBiZSBhIGdvb2QgdGltZQp0byBkbyBzbyB3aXRoOgoKIGdp
dCBicmFuY2ggbmV3X2JyYW5jaF9uYW1lIDYzNGU2MmMKCkhFQUQgaXMgbm93IGF0IGMzYmVi
YzcuLi4gTWVyZ2UgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwv
Z2l0L2RhdmVtL25ldApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1y
YW5kY29uZmlnLXN0MC0wMzA2MTc0Mi9uZXh0Om1hc3RlcjpjM2JlYmM3MWM0YmNkYWZhMjRi
NTA2YWRmMGMxZGUzYzFmNzdlMmUwOmJpc2VjdC1saW51eDQKCjIwMTQtMDMtMDctMTU6MDY6
MDIgYzNiZWJjNzFjNGJjZGFmYTI0YjUwNmFkZjBjMWRlM2MxZjc3ZTJlMCBjb21waWxpbmcK
CjIwMTQtMDMtMDctMTU6MTU6NTIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjNS0w
MDE4NS1nYzNiZWJjNy4uLgkxCTEwCTIwCTM2CTU0CTYwIFNVQ0NFU1MKCgo9PT09PT09PT0g
bGludXgtbmV4dCA9PT09PT09PT0KRmV0Y2hpbmcgbmV4dApGcm9tIGdpdDovL2dpdG1pcnJv
ci9uZXh0CiArIGQ0YmIyZWIuLi42ZjMzZjY5IGFrcG0gICAgICAgLT4gbmV4dC9ha3BtICAo
Zm9yY2VkIHVwZGF0ZSkKICsgMDlkZTE5Mi4uLjU2MDMyZmMgYWtwbS1iYXNlICAtPiBuZXh0
L2FrcG0tYmFzZSAgKGZvcmNlZCB1cGRhdGUpCiArIDBmZmIyZmUuLi4xYjBhN2UzIG1hc3Rl
ciAgICAgLT4gbmV4dC9tYXN0ZXIgIChmb3JjZWQgdXBkYXRlKQogKiBbbmV3IHRhZ10gICAg
ICAgICBuZXh0LTIwMTQwMzA3IC0+IG5leHQtMjAxNDAzMDcKUHJldmlvdXMgSEVBRCBwb3Np
dGlvbiB3YXMgYzNiZWJjNy4uLiBNZXJnZSBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2Nt
L2xpbnV4L2tlcm5lbC9naXQvZGF2ZW0vbmV0CkhFQUQgaXMgbm93IGF0IDFiMGE3ZTMuLi4g
QWRkIGxpbnV4LW5leHQgc3BlY2lmaWMgZmlsZXMgZm9yIDIwMTQwMzA3CmxzIC1hIC9rZXJu
ZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctc3QwLTAzMDYxNzQyL25l
eHQ6bWFzdGVyOjFiMGE3ZTMyNjMxNjhhMDZkMzg1ODc5OGU0OGM1YTIxZDFjNzhkM2M6Ymlz
ZWN0LWxpbnV4NAoKMjAxNC0wMy0wNy0xNToyMzoyNyAxYjBhN2UzMjYzMTY4YTA2ZDM4NTg3
OThlNDhjNWEyMWQxYzc4ZDNjIGNvbXBpbGluZwoKMjAxNC0wMy0wNy0xNToyODo1MyBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmM1LW5leHQtMjAxNDAzMDcuLi4JNwkxMwkyMQkz
MwkzNi4uLgk0NQk0OQk1NQk1Nwk1OC4uLi4uLi4uLi4uLi4uLi4uLgk1OQk2MCBTVUNDRVNT
Cgo=

--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc5-next-20140306-07138-g0ffb2fe"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.14.0-rc5 Kernel Configuration
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
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_FHANDLE is not set
CONFIG_USELIB=y
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set

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
CONFIG_TICK_ONESHOT=y
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
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
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
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
# CONFIG_CGROUPS is not set
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
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
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
# CONFIG_SYSFS_SYSCALL is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
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
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_PROFILING=y
CONFIG_OPROFILE=m
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
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
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
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
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
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
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
# CONFIG_ACORN_PARTITION_EESOX is not set
# CONFIG_ACORN_PARTITION_ICS is not set
# CONFIG_ACORN_PARTITION_ADFS is not set
# CONFIG_ACORN_PARTITION_POWERTEC is not set
# CONFIG_ACORN_PARTITION_RISCIX is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_CMDLINE_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PADATA=y
CONFIG_ASN1=m
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_BIGSMP=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_X86_32_IRIS is not set
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
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_NR_CPUS=32
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
CONFIG_VM86=y
CONFIG_TOSHIBA=m
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_EARLY=y
CONFIG_MICROCODE_AMD_EARLY=y
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
# CONFIG_X86_PAE is not set
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
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
# CONFIG_FRONTSWAP is not set
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_ZBUD is not set
CONFIG_MEM_SOFT_DIRTY=y
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
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
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
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
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
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
# CONFIG_ACPI_EXTLOG is not set
CONFIG_SFI=y
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
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

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
CONFIG_X86_SPEEDSTEP_CENTRINO=m
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
# CONFIG_X86_SPEEDSTEP_SMI is not set
CONFIG_X86_P4_CLOCKMOD=y
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set

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
CONFIG_PCI_GODIRECT=y
# CONFIG_PCI_GOOLPC is not set
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_DIRECT=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_SCx200 is not set
CONFIG_OLPC=y
CONFIG_OLPC_XO1_PM=y
CONFIG_OLPC_XO1_RTC=y
# CONFIG_OLPC_XO1_SCI is not set
# CONFIG_OLPC_XO15_SCI is not set
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
# CONFIG_GEOS is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PD6729=m
CONFIG_I82092=m
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
# CONFIG_RAPIDIO_DMA_ENGINE is not set
# CONFIG_RAPIDIO_DEBUG is not set
CONFIG_RAPIDIO_ENUM_BASIC=m

#
# RapidIO Switch drivers
#
# CONFIG_RAPIDIO_TSI57X is not set
# CONFIG_RAPIDIO_CPS_XX is not set
# CONFIG_RAPIDIO_TSI568 is not set
CONFIG_RAPIDIO_CPS_GEN2=m
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
# CONFIG_IOSF_MBI is not set
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
# CONFIG_IP_PNP_DHCP is not set
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
# CONFIG_SYN_COOKIES is not set
CONFIG_NET_IPVTI=m
CONFIG_INET_AH=m
# CONFIG_INET_ESP is not set
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=m
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=m
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=m
# CONFIG_INET6_ESP is not set
CONFIG_INET6_IPCOMP=m
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_VTI=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_GRE=m
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_PROCFS=y
# CONFIG_NF_CONNTRACK_FTP is not set
CONFIG_NF_CONNTRACK_IRC=y
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_SIP is not set
CONFIG_NF_CT_NETLINK=y
CONFIG_NF_TABLES=y
CONFIG_NF_TABLES_INET=m
CONFIG_NFT_EXTHDR=m
CONFIG_NFT_META=y
CONFIG_NFT_CT=m
CONFIG_NFT_RBTREE=y
# CONFIG_NFT_HASH is not set
CONFIG_NFT_COUNTER=m
CONFIG_NFT_LOG=y
# CONFIG_NFT_LIMIT is not set
CONFIG_NFT_REJECT=y
CONFIG_NFT_REJECT_INET=m
CONFIG_NFT_COMPAT=m
CONFIG_NETFILTER_XTABLES=m

#
# Xtables combined modules
#
# CONFIG_NETFILTER_XT_MARK is not set

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
# CONFIG_NETFILTER_XT_MATCH_STATE is not set
# CONFIG_IP_SET is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_NF_TABLES_IPV4=m
CONFIG_NFT_CHAIN_ROUTE_IPV4=m
CONFIG_NFT_REJECT_IPV4=m
CONFIG_NF_TABLES_ARP=m
# CONFIG_IP_NF_IPTABLES is not set

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV6 is not set
# CONFIG_NF_CONNTRACK_IPV6 is not set
CONFIG_NF_TABLES_IPV6=m
CONFIG_NFT_CHAIN_ROUTE_IPV6=m
CONFIG_NFT_REJECT_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
# CONFIG_IP6_NF_FILTER is not set
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
# CONFIG_NF_TABLES_BRIDGE is not set
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
# CONFIG_BRIDGE_EBT_ARP is not set
CONFIG_BRIDGE_EBT_IP=m
# CONFIG_BRIDGE_EBT_IP6 is not set
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
# CONFIG_BRIDGE_EBT_PKTTYPE is not set
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
# CONFIG_BRIDGE_EBT_ARPREPLY is not set
# CONFIG_BRIDGE_EBT_DNAT is not set
CONFIG_BRIDGE_EBT_MARK_T=m
# CONFIG_BRIDGE_EBT_REDIRECT is not set
# CONFIG_BRIDGE_EBT_SNAT is not set
CONFIG_BRIDGE_EBT_LOG=m
# CONFIG_BRIDGE_EBT_ULOG is not set
# CONFIG_BRIDGE_EBT_NFLOG is not set
CONFIG_IP_DCCP=y

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
CONFIG_IP_DCCP_CCID3_DEBUG=y
CONFIG_IP_DCCP_TFRC_LIB=y
CONFIG_IP_DCCP_TFRC_DEBUG=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_NET_DCCPPROBE=m
CONFIG_IP_SCTP=m
CONFIG_NET_SCTPPROBE=m
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE=y
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
# CONFIG_RDS is not set
CONFIG_TIPC=m
CONFIG_TIPC_PORTS=8191
CONFIG_ATM=m
# CONFIG_ATM_CLIP is not set
CONFIG_ATM_LANE=m
CONFIG_ATM_MPOA=m
# CONFIG_ATM_BR2684 is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
# CONFIG_L2TP_V3 is not set
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_MRP=m
CONFIG_BRIDGE=m
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_DECNET=m
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
# CONFIG_IPDDP is not set
CONFIG_X25=m
CONFIG_LAPB=y
CONFIG_PHONET=y
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=y
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=y
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=y
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_MQPRIO=y
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_QFQ is not set
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=y
# CONFIG_NET_SCH_FQ is not set
CONFIG_NET_SCH_HHF=y
CONFIG_NET_SCH_PIE=m
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_ROUTE4=m
# CONFIG_NET_CLS_FW is not set
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=y
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_CLS_BPF=m
# CONFIG_NET_EMATCH is not set
# CONFIG_NET_CLS_ACT is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=m
CONFIG_BATMAN_ADV_BLA=y
# CONFIG_BATMAN_ADV_DAT is not set
CONFIG_BATMAN_ADV_NC=y
# CONFIG_BATMAN_ADV_DEBUG is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=y
CONFIG_VMWARE_VMCI_VSOCKETS=m
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=m
# CONFIG_NET_MPLS_GSO is not set
CONFIG_HSR=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
# CONFIG_NET_TCPPROBE is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=m
CONFIG_AX25_DAMA_SLAVE=y
# CONFIG_NETROM is not set
CONFIG_ROSE=m

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
# CONFIG_6PACK is not set
CONFIG_BPQETHER=m
CONFIG_BAYCOM_SER_FDX=m
# CONFIG_BAYCOM_SER_HDX is not set
# CONFIG_BAYCOM_PAR is not set
CONFIG_BAYCOM_EPP=m
CONFIG_YAM=m
CONFIG_CAN=m
CONFIG_CAN_RAW=m
# CONFIG_CAN_BCM is not set
CONFIG_CAN_GW=m

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_SLCAN is not set
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRNET=m
# CONFIG_IRCOMM is not set
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
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#
CONFIG_KINGSUN_DONGLE=y
CONFIG_KSDAZZLE_DONGLE=y
# CONFIG_KS959_DONGLE is not set

#
# FIR device drivers
#
CONFIG_USB_IRDA=m
# CONFIG_SIGMATEL_FIR is not set
CONFIG_NSC_FIR=y
# CONFIG_WINBOND_FIR is not set
CONFIG_TOSHIBA_FIR=m
CONFIG_SMC_IRCC_FIR=y
CONFIG_ALI_FIR=y
CONFIG_VLSI_FIR=y
# CONFIG_VIA_FIR is not set
CONFIG_MCS_FIR=m
# CONFIG_BT is not set
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
# CONFIG_RXKAD is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_CERTIFICATION_ONUS=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
# CONFIG_LIB80211 is not set
# CONFIG_MAC80211 is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_RFKILL_GPIO=m
CONFIG_NET_9P=m
CONFIG_NET_9P_VIRTIO=m
CONFIG_NET_9P_DEBUG=y
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
# CONFIG_CAIF_NETDEV is not set
CONFIG_CAIF_USB=y
CONFIG_CEPH_LIB=y
CONFIG_CEPH_LIB_PRETTYDEBUG=y
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
CONFIG_NFC=m
# CONFIG_NFC_DIGITAL is not set
CONFIG_NFC_NCI=m
# CONFIG_NFC_NCI_SPI is not set
CONFIG_NFC_HCI=m
# CONFIG_NFC_SHDLC is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_PN533=m
CONFIG_NFC_MEI_PHY=m
# CONFIG_NFC_SIM is not set
# CONFIG_NFC_PN544 is not set
CONFIG_NFC_MICROREAD=m
CONFIG_NFC_MICROREAD_MEI=m
CONFIG_NFC_MRVL=m
CONFIG_NFC_MRVL_USB=m

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
# CONFIG_FW_LOADER_USER_HELPER is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=m
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_CMA is not set

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=m
# CONFIG_MTD_TESTS is not set
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_CMDLINE_PARTS=m
CONFIG_MTD_OF_PARTS=m
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
CONFIG_MTD_BLOCK_RO=m
CONFIG_FTL=m
CONFIG_NFTL=m
CONFIG_NFTL_RW=y
CONFIG_INFTL=m
# CONFIG_RFD_FTL is not set
CONFIG_SSFDC=m
CONFIG_SM_FTL=m
CONFIG_MTD_OOPS=m
CONFIG_MTD_SWAP=m

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
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PHYSMAP is not set
# CONFIG_MTD_PHYSMAP_OF is not set
CONFIG_MTD_SC520CDP=m
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=m

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=m
# CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
# CONFIG_MTD_DATAFLASH_OTP is not set
CONFIG_MTD_M25P80=m
CONFIG_MTD_SST25L=m
CONFIG_MTD_SLRAM=m
CONFIG_MTD_PHRAM=m
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
CONFIG_MTD_NAND=m
CONFIG_MTD_NAND_BCH=m
CONFIG_MTD_NAND_ECC_BCH=y
CONFIG_MTD_SM_COMMON=m
CONFIG_MTD_NAND_DENALI=m
# CONFIG_MTD_NAND_DENALI_PCI is not set
CONFIG_MTD_NAND_GPIO=m
CONFIG_MTD_NAND_IDS=m
CONFIG_MTD_NAND_RICOH=m
# CONFIG_MTD_NAND_DISKONCHIP is not set
CONFIG_MTD_NAND_DOCG4=m
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_CS553X=m
CONFIG_MTD_NAND_NANDSIM=m
CONFIG_MTD_NAND_PLATFORM=m
CONFIG_MTD_ONENAND=m
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
# CONFIG_MTD_ONENAND_GENERIC is not set
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
# CONFIG_MTD_UBI is not set
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
# CONFIG_PROC_DEVICETREE is not set
# CONFIG_OF_SELFTEST is not set
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_ADDRESS_PCI=y
CONFIG_OF_IRQ=y
CONFIG_OF_NET=y
CONFIG_OF_MDIO=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
CONFIG_OF_MTD=y
CONFIG_PARPORT=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=m
# CONFIG_BLK_DEV_FD is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
# CONFIG_ZRAM is not set
CONFIG_BLK_CPQ_CISS_DA=m
# CONFIG_CISS_SCSI_TAPE is not set
CONFIG_BLK_DEV_DAC960=m
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=m
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
CONFIG_ATA_OVER_ETH=m
CONFIG_VIRTIO_BLK=y
CONFIG_BLK_DEV_HD=y
# CONFIG_BLK_DEV_RBD is not set
CONFIG_BLK_DEV_RSXX=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
CONFIG_IBM_ASM=m
CONFIG_PHANTOM=y
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
# CONFIG_ATMEL_SSC is not set
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_CS5535_MFGPT=m
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
CONFIG_CS5535_CLOCK_EVENT_SRC=m
CONFIG_HP_ILO=y
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=y
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=y
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=m
CONFIG_DS1682=m
# CONFIG_TI_DAC7512 is not set
CONFIG_VMWARE_BALLOON=y
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
CONFIG_BMP085_SPI=y
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=m
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
CONFIG_C2PORT=m
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_AT25=m
CONFIG_EEPROM_LEGACY=m
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
CONFIG_EEPROM_93XX46=y
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_INTEL_MEI=m
# CONFIG_INTEL_MEI_ME is not set
CONFIG_INTEL_MEI_TXE=m
CONFIG_VMWARE_VMCI=m

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
# CONFIG_ECHO is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=m
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECS=m
CONFIG_BLK_DEV_DELKIN=y
# CONFIG_BLK_DEV_IDECD is not set
CONFIG_BLK_DEV_IDETAPE=m
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
CONFIG_BLK_DEV_PLATFORM=m
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
CONFIG_BLK_DEV_OFFBOARD=y
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
CONFIG_BLK_DEV_RZ1000=m
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=m
CONFIG_BLK_DEV_ALI15X3=m
CONFIG_BLK_DEV_AMD74XX=y
# CONFIG_BLK_DEV_ATIIXP is not set
CONFIG_BLK_DEV_CMD64X=y
CONFIG_BLK_DEV_TRIFLEX=y
CONFIG_BLK_DEV_CS5520=m
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
CONFIG_BLK_DEV_CS5536=m
CONFIG_BLK_DEV_HPT366=y
CONFIG_BLK_DEV_JMICRON=m
CONFIG_BLK_DEV_SC1200=y
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_IT8172 is not set
CONFIG_BLK_DEV_IT8213=m
# CONFIG_BLK_DEV_IT821X is not set
CONFIG_BLK_DEV_NS87415=y
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
CONFIG_BLK_DEV_PDC202XX_NEW=y
CONFIG_BLK_DEV_SVWKS=m
CONFIG_BLK_DEV_SIIMAGE=m
CONFIG_BLK_DEV_SIS5513=y
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
CONFIG_BLK_DEV_TC86C001=y
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
CONFIG_ISCSI_BOOT_SYSFS=y
CONFIG_SCSI_CXGB3_ISCSI=m
# CONFIG_SCSI_CXGB4_ISCSI is not set
CONFIG_SCSI_BNX2_ISCSI=m
CONFIG_SCSI_BNX2X_FCOE=y
CONFIG_BE2ISCSI=y
CONFIG_BLK_DEV_3W_XXXX_RAID=m
CONFIG_SCSI_HPSA=y
CONFIG_SCSI_3W_9XXX=y
CONFIG_SCSI_3W_SAS=m
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_BUILD_FIRMWARE is not set
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC79XX is not set
CONFIG_SCSI_AIC94XX=m
# CONFIG_AIC94XX_DEBUG is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
CONFIG_SCSI_ADVANSYS=m
CONFIG_SCSI_ARCMSR=y
CONFIG_SCSI_ESAS2R=y
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
# CONFIG_MEGARAID_MAILBOX is not set
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
# CONFIG_SCSI_MPT2SAS is not set
CONFIG_SCSI_MPT3SAS=y
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_LOGGING=y
CONFIG_SCSI_UFSHCD=y
CONFIG_SCSI_UFSHCD_PCI=m
# CONFIG_SCSI_UFSHCD_PLATFORM is not set
# CONFIG_SCSI_HPTIOP is not set
CONFIG_SCSI_BUSLOGIC=m
# CONFIG_SCSI_FLASHPOINT is not set
CONFIG_VMWARE_PVSCSI=m
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
CONFIG_FCOE=m
CONFIG_FCOE_FNIC=y
CONFIG_SCSI_DMX3191D=m
CONFIG_SCSI_EATA=m
# CONFIG_SCSI_EATA_TAGGED_QUEUE is not set
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=y
CONFIG_SCSI_GDTH=m
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_IPS is not set
CONFIG_SCSI_INITIO=y
CONFIG_SCSI_INIA100=m
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=m
CONFIG_SCSI_QLA_ISCSI=m
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_NSP32=m
# CONFIG_SCSI_DEBUG is not set
CONFIG_SCSI_PMCRAID=y
CONFIG_SCSI_PM8001=m
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=m
CONFIG_SCSI_CHELSIO_FCOE=m
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
# CONFIG_PCMCIA_AHA152X is not set
# CONFIG_PCMCIA_FDOMAIN is not set
CONFIG_PCMCIA_NINJA_SCSI=m
CONFIG_PCMCIA_QLOGIC=m
# CONFIG_PCMCIA_SYM53C500 is not set
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=y
# CONFIG_SCSI_OSD_ULD is not set
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=y
CONFIG_SATA_INIC162X=y
# CONFIG_SATA_ACARD_AHCI is not set
CONFIG_SATA_SIL24=y
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
CONFIG_SATA_QSTOR=m
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
CONFIG_SATA_HIGHBANK=m
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
CONFIG_SATA_PROMISE=m
# CONFIG_SATA_RCAR is not set
# CONFIG_SATA_SIL is not set
CONFIG_SATA_SIS=m
# CONFIG_SATA_SVW is not set
CONFIG_SATA_ULI=y
CONFIG_SATA_VIA=y
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
CONFIG_PATA_ALI=y
# CONFIG_PATA_AMD is not set
CONFIG_PATA_ARASAN_CF=m
# CONFIG_PATA_ARTOP is not set
CONFIG_PATA_ATIIXP=m
CONFIG_PATA_ATP867X=m
CONFIG_PATA_CMD64X=y
# CONFIG_PATA_CS5520 is not set
CONFIG_PATA_CS5530=m
CONFIG_PATA_CS5535=y
CONFIG_PATA_CS5536=y
CONFIG_PATA_CYPRESS=m
CONFIG_PATA_EFAR=y
# CONFIG_PATA_HPT366 is not set
CONFIG_PATA_HPT37X=m
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
CONFIG_PATA_NINJA32=m
CONFIG_PATA_NS87415=m
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
CONFIG_PATA_PDC2027X=m
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
CONFIG_PATA_RDC=y
CONFIG_PATA_SC1200=y
CONFIG_PATA_SCH=y
CONFIG_PATA_SERVERWORKS=m
CONFIG_PATA_SIL680=y
CONFIG_PATA_SIS=y
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
CONFIG_PATA_WINBOND=m

#
# PIO-only SFF controllers
#
CONFIG_PATA_CMD640_PCI=y
CONFIG_PATA_MPIIX=m
# CONFIG_PATA_NS87410 is not set
CONFIG_PATA_OPTI=m
CONFIG_PATA_PCMCIA=m
# CONFIG_PATA_PLATFORM is not set
CONFIG_PATA_RZ1000=y

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
CONFIG_ATA_GENERIC=y
CONFIG_PATA_LEGACY=m
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
CONFIG_BONDING=m
CONFIG_DUMMY=y
# CONFIG_EQUALIZER is not set
CONFIG_NET_FC=y
# CONFIG_NET_TEAM is not set
CONFIG_MACVLAN=y
CONFIG_MACVTAP=m
CONFIG_VXLAN=y
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
CONFIG_NTB_NETDEV=m
# CONFIG_RIONET is not set
CONFIG_TUN=m
# CONFIG_VETH is not set
# CONFIG_VIRTIO_NET is not set
CONFIG_NLMON=m
CONFIG_SUNGEM_PHY=m
CONFIG_ARCNET=m
CONFIG_ARCNET_1201=m
CONFIG_ARCNET_1051=m
CONFIG_ARCNET_RAW=m
CONFIG_ARCNET_CAP=m
# CONFIG_ARCNET_COM90xx is not set
CONFIG_ARCNET_COM90xxIO=m
CONFIG_ARCNET_RIM_I=m
# CONFIG_ARCNET_COM20020 is not set
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#
# CONFIG_CAIF_TTY is not set
CONFIG_CAIF_SPI_SLAVE=m
CONFIG_CAIF_SPI_SYNC=y
# CONFIG_CAIF_HSI is not set
# CONFIG_CAIF_VIRTIO is not set
CONFIG_VHOST_NET=m
CONFIG_VHOST_RING=m
CONFIG_VHOST=m

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
# CONFIG_NET_DSA_MV88E6060 is not set
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=m
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
CONFIG_NET_VENDOR_ALTEON=y
CONFIG_ACENIC=m
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_NET_VENDOR_AMD=y
CONFIG_AMD8111_ETH=y
CONFIG_PCNET32=y
# CONFIG_PCMCIA_NMCLAN is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_ARC_EMAC=m
# CONFIG_NET_VENDOR_ATHEROS is not set
# CONFIG_NET_CADENCE is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
CONFIG_BCMGENET=m
CONFIG_BNX2=y
CONFIG_CNIC=y
# CONFIG_TIGON3 is not set
CONFIG_BNX2X=m
CONFIG_BNX2X_SRIOV=y
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=y
CONFIG_NET_CALXEDA_XGMAC=m
CONFIG_NET_VENDOR_CHELSIO=y
CONFIG_CHELSIO_T1=y
CONFIG_CHELSIO_T1_1G=y
CONFIG_CHELSIO_T3=m
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_DNET=y
# CONFIG_NET_VENDOR_DEC is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=m
# CONFIG_NET_VENDOR_EXAR is not set
CONFIG_NET_VENDOR_FUJITSU=y
CONFIG_PCMCIA_FMVJ18X=m
# CONFIG_NET_VENDOR_HP is not set
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=y
# CONFIG_E1000 is not set
CONFIG_E1000E=m
CONFIG_IGB=y
# CONFIG_IGB_HWMON is not set
CONFIG_IGBVF=y
# CONFIG_IXGB is not set
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
CONFIG_I40E=y
CONFIG_I40E_VXLAN=y
# CONFIG_NET_VENDOR_I825XX is not set
CONFIG_IP1000=y
CONFIG_JME=m
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_MVMDIO=y
CONFIG_SKGE=m
# CONFIG_SKGE_DEBUG is not set
# CONFIG_SKGE_GENESIS is not set
CONFIG_SKY2=y
CONFIG_SKY2_DEBUG=y
CONFIG_NET_VENDOR_MELLANOX=y
CONFIG_MLX4_EN=m
CONFIG_MLX4_CORE=m
# CONFIG_MLX4_DEBUG is not set
# CONFIG_MLX5_CORE is not set
# CONFIG_NET_VENDOR_MICREL is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_ENC28J60 is not set
# CONFIG_NET_VENDOR_MYRI is not set
CONFIG_FEALNX=y
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NVIDIA=y
CONFIG_FORCEDETH=y
# CONFIG_NET_VENDOR_OKI is not set
CONFIG_ETHOC=y
# CONFIG_NET_PACKET_ENGINE is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
# CONFIG_NET_VENDOR_REALTEK is not set
CONFIG_SH_ETH=y
# CONFIG_NET_VENDOR_RDC is not set
# CONFIG_NET_VENDOR_SEEQ is not set
CONFIG_NET_VENDOR_SILAN=y
CONFIG_SC92031=y
CONFIG_NET_VENDOR_SIS=y
CONFIG_SIS900=y
CONFIG_SIS190=m
# CONFIG_SFC is not set
# CONFIG_NET_VENDOR_SMSC is not set
# CONFIG_NET_VENDOR_STMICRO is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
CONFIG_SUNGEM=m
CONFIG_CASSINI=m
CONFIG_NIU=m
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
CONFIG_NET_VENDOR_WIZNET=y
CONFIG_WIZNET_W5100=m
CONFIG_WIZNET_W5300=m
# CONFIG_WIZNET_BUS_DIRECT is not set
CONFIG_WIZNET_BUS_INDIRECT=y
# CONFIG_WIZNET_BUS_ANY is not set
CONFIG_NET_VENDOR_XIRCOM=y
CONFIG_PCMCIA_XIRC2PS=m
CONFIG_FDDI=m
CONFIG_DEFXX=m
CONFIG_DEFXX_MMIO=y
CONFIG_SKFP=m
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=y
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=m
CONFIG_BCM7XXX_PHY=y
CONFIG_BCM87XX_PHY=y
# CONFIG_ICPLUS_PHY is not set
CONFIG_REALTEK_PHY=m
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=m
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=m
CONFIG_MDIO_BUS_MUX=y
CONFIG_MDIO_BUS_MUX_GPIO=y
# CONFIG_MDIO_BUS_MUX_MMIOREG is not set
CONFIG_MICREL_KS8995MA=y
CONFIG_PLIP=m
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=m
# CONFIG_PPP_DEFLATE is not set
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=y
CONFIG_PPP_MULTILINK=y
# CONFIG_PPPOATM is not set
CONFIG_PPPOE=y
CONFIG_PPPOL2TP=m
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=y
CONFIG_USB_RTL8152=m
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_AX88179_178A=y
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=m
CONFIG_USB_NET_CDC_NCM=y
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
CONFIG_USB_NET_CDC_MBIM=y
CONFIG_USB_NET_DM9601=m
CONFIG_USB_NET_SR9700=y
CONFIG_USB_NET_SR9800=m
# CONFIG_USB_NET_SMSC75XX is not set
CONFIG_USB_NET_SMSC95XX=m
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
# CONFIG_USB_NET_MCS7830 is not set
# CONFIG_USB_NET_RNDIS_HOST is not set
CONFIG_USB_NET_CDC_SUBSET=y
# CONFIG_USB_ALI_M5632 is not set
# CONFIG_USB_AN2720 is not set
CONFIG_USB_BELKIN=y
# CONFIG_USB_ARMLINUX is not set
# CONFIG_USB_EPSON2888 is not set
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=y
CONFIG_USB_NET_CX82310_ETH=m
# CONFIG_USB_NET_KALMIA is not set
CONFIG_USB_NET_QMI_WWAN=y
# CONFIG_USB_HSO is not set
# CONFIG_USB_NET_INT51X1 is not set
# CONFIG_USB_CDC_PHONET is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_USB_SIERRA_NET is not set
# CONFIG_USB_VL600 is not set
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=m
CONFIG_WIMAX_I2400M_USB=m
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
# CONFIG_WAN is not set
CONFIG_VMXNET3=m
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
# CONFIG_INPUT_SPARSEKMAP is not set
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=m
CONFIG_INPUT_EVBUG=m

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
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
CONFIG_TABLET_USB_GTCO=m
CONFIG_TABLET_USB_HANWANG=m
# CONFIG_TABLET_USB_KBTAB is not set
CONFIG_TABLET_USB_WACOM=m
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM80X_ONKEY=m
CONFIG_INPUT_AD714X=m
CONFIG_INPUT_AD714X_I2C=m
CONFIG_INPUT_AD714X_SPI=m
CONFIG_INPUT_BMA150=m
CONFIG_INPUT_MC13783_PWRBUTTON=m
CONFIG_INPUT_MMA8450=m
CONFIG_INPUT_MPU3050=m
CONFIG_INPUT_APANEL=m
CONFIG_INPUT_GP2A=m
# CONFIG_INPUT_GPIO_BEEPER is not set
CONFIG_INPUT_GPIO_TILT_POLLED=m
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=m
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=m
# CONFIG_INPUT_RETU_PWRBUTTON is not set
CONFIG_INPUT_TWL4030_PWRBUTTON=m
CONFIG_INPUT_TWL4030_VIBRA=m
CONFIG_INPUT_UINPUT=m
CONFIG_INPUT_PCF8574=m
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
# CONFIG_INPUT_DA9052_ONKEY is not set
# CONFIG_INPUT_DA9055_ONKEY is not set
CONFIG_INPUT_PCAP=m
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_IMS_PCU is not set
CONFIG_INPUT_CMA3000=m
CONFIG_INPUT_CMA3000_I2C=m
CONFIG_INPUT_IDEAPAD_SLIDEBAR=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PARKBD=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=m
CONFIG_SERIO_PS2MULT=m
CONFIG_SERIO_ARC_PS2=y
# CONFIG_SERIO_APBPS2 is not set
CONFIG_SERIO_OLPC_APSP=y
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
CONFIG_GAMEPORT_EMU10K1=m
CONFIG_GAMEPORT_FM801=m

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
# CONFIG_SERIAL_MRST_MAX3110 is not set
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_OF_PLATFORM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=m
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_GEODE is not set
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_TPM=y
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
CONFIG_SONYPI=m

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=m
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_ATMEL is not set
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_TIS_I2C_NUVOTON=y
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_ST33_I2C is not set
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
CONFIG_I2C_ARB_GPIO_CHALLENGE=y
CONFIG_I2C_MUX_GPIO=m
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=y
CONFIG_I2C_PIIX4=y
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=m
CONFIG_I2C_SIS630=y
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=m
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EG20T=m
CONFIG_I2C_GPIO=m
CONFIG_I2C_KEMPLD=y
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
CONFIG_I2C_PXA=m
CONFIG_I2C_PXA_PCI=y
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_ROBOTFUZZ_OSIF=y
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=y
# CONFIG_I2C_VIPERBOARD is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_SCx200_ACB=m
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=m
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=m
CONFIG_SPI_GPIO=y
CONFIG_SPI_LM70_LLP=m
# CONFIG_SPI_FSL_SPI is not set
CONFIG_SPI_OC_TINY=m
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=m
CONFIG_SPI_PXA2XX_PCI=m
# CONFIG_SPI_SC18IS602 is not set
CONFIG_SPI_TOPCLIFF_PCH=y
CONFIG_SPI_XCOMM=y
# CONFIG_SPI_XILINX is not set
CONFIG_SPI_DESIGNWARE=m
CONFIG_SPI_DW_PCI=m
CONFIG_SPI_DW_MMIO=m

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=m
CONFIG_SPI_TLE62X0=y
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
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_DA9055=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_DWAPB=y
CONFIG_GPIO_IT8761E=m
CONFIG_GPIO_F7188X=m
CONFIG_GPIO_SCH311X=y
CONFIG_GPIO_SCH=y
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_VX855=m
# CONFIG_GPIO_LYNXPOINT is not set
CONFIG_GPIO_GRGPIO=y

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=m
# CONFIG_GPIO_PCF857X is not set
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_TC3589X=y
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TWL4030=m
CONFIG_GPIO_WM8350=m
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y
CONFIG_GPIO_ADNP=y

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=m
# CONFIG_GPIO_BT8XX is not set
CONFIG_GPIO_AMD8111=m
# CONFIG_GPIO_INTEL_MID is not set
CONFIG_GPIO_PCH=y
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_SODAVILLE is not set
# CONFIG_GPIO_TIMBERDALE is not set
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
CONFIG_GPIO_MCP23S08=y
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_74X164 is not set

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
# CONFIG_GPIO_JANZ_TTL is not set
# CONFIG_GPIO_TPS6586X is not set
# CONFIG_GPIO_BCM_KONA is not set

#
# USB GPIO expanders:
#
CONFIG_GPIO_VIPERBOARD=m
CONFIG_W1=m

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=m
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_DS1WM=m
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2408=m
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=m
CONFIG_W1_SLAVE_DS2423=m
CONFIG_W1_SLAVE_DS2431=m
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=m
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=m
CONFIG_W1_SLAVE_DS28E04=m
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_WM8350_POWER=m
CONFIG_TEST_POWER=m
CONFIG_BATTERY_DS2760=m
CONFIG_BATTERY_DS2780=m
CONFIG_BATTERY_DS2781=m
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_OLPC=m
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9052=m
CONFIG_BATTERY_MAX17040=m
CONFIG_BATTERY_MAX17042=y
CONFIG_BATTERY_TWL4030_MADC=y
CONFIG_BATTERY_RX51=m
CONFIG_CHARGER_ISP1704=y
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_TWL4030=m
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MANAGER=y
CONFIG_CHARGER_MAX14577=y
CONFIG_CHARGER_MAX8998=m
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_BQ24735=y
CONFIG_CHARGER_SMB347=y
CONFIG_POWER_RESET=y
CONFIG_POWER_RESET_GPIO=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=m
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=m
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=m
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_MC13783_ADC is not set
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=m
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=y
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=y
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4260=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_MAX1111=y
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_HTU21=y
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_ADCXX=y
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=m
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_PC87360=m
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_NCT6775 is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
# CONFIG_SENSORS_PMBUS is not set
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_LM25066 is not set
CONFIG_SENSORS_LTC2978=m
CONFIG_SENSORS_MAX16064=m
CONFIG_SENSORS_MAX34440=m
# CONFIG_SENSORS_MAX8688 is not set
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=m
CONFIG_SENSORS_ZL6100=m
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=y
# CONFIG_SENSORS_SCH5627 is not set
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_ADC128D818=y
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_ADS7871=m
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_TWL4030_MADC=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM8350=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_OF=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_CPU_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
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
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_DA9052_WATCHDOG=y
CONFIG_DA9055_WATCHDOG=y
CONFIG_GPIO_WATCHDOG=m
CONFIG_WM8350_WATCHDOG=y
CONFIG_XILINX_WATCHDOG=y
CONFIG_DW_WATCHDOG=y
# CONFIG_TWL4030_WATCHDOG is not set
CONFIG_RETU_WATCHDOG=m
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=m
CONFIG_ALIM1535_WDT=y
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
CONFIG_SP5100_TCO=y
CONFIG_GEODE_WDT=m
CONFIG_SC520_WDT=y
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
CONFIG_IE6XX_WDT=y
CONFIG_ITCO_WDT=y
# CONFIG_ITCO_VENDOR_SUPPORT is not set
CONFIG_IT8712F_WDT=m
# CONFIG_IT87_WDT is not set
CONFIG_HP_WATCHDOG=m
# CONFIG_KEMPLD_WDT is not set
# CONFIG_HPWDT_NMI_DECODING is not set
CONFIG_SC1200_WDT=m
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=m
CONFIG_60XX_WDT=y
# CONFIG_SBC8360_WDT is not set
CONFIG_SBC7240_WDT=m
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
CONFIG_VIA_WDT=y
CONFIG_W83627HF_WDT=y
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=m
CONFIG_SBC_EPX_C3_WATCHDOG=y
# CONFIG_MEN_A21_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
CONFIG_WDTPCI=y

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
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
CONFIG_BCMA_HOST_SOC=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=m
CONFIG_MFD_AS3711=y
# CONFIG_MFD_AS3722 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_CROS_EC=m
CONFIG_MFD_CROS_EC_I2C=m
# CONFIG_MFD_CROS_EC_SPI is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=m
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
CONFIG_EZX_PCAP=y
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=m
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_RDC321X=y
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RTSX_USB is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=m
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=m
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=m
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS65218 is not set
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS65912_SPI=y
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
CONFIG_TWL4030_MADC=y
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=m
CONFIG_MFD_TIMBERDALE=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
CONFIG_MFD_ARIZONA_SPI=y
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_88PM800 is not set
# CONFIG_REGULATOR_ACT8865 is not set
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_AS3711=y
CONFIG_REGULATOR_DA9052=m
CONFIG_REGULATOR_DA9055=m
CONFIG_REGULATOR_DA9210=m
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_ISL6271A=m
CONFIG_REGULATOR_LP3971=m
CONFIG_REGULATOR_LP3972=m
# CONFIG_REGULATOR_LP872X is not set
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_MAX14577=m
CONFIG_REGULATOR_MAX1586=m
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=m
CONFIG_REGULATOR_MAX8952=m
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MAX8998=m
CONFIG_REGULATOR_MAX77686=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=m
CONFIG_REGULATOR_PCAP=y
# CONFIG_REGULATOR_PFUZE100 is not set
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=m
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=m
CONFIG_REGULATOR_TPS65217=m
# CONFIG_REGULATOR_TPS6524X is not set
CONFIG_REGULATOR_TPS6586X=m
CONFIG_REGULATOR_TPS65912=m
CONFIG_REGULATOR_TWL4030=y
CONFIG_REGULATOR_WM8350=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_DVB_CORE=y
CONFIG_DVB_NET=y
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
CONFIG_RC_MAP=m
CONFIG_RC_DECODERS=y
# CONFIG_LIRC is not set
# CONFIG_IR_NEC_DECODER is not set
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
# CONFIG_IR_JVC_DECODER is not set
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_RC5_SZ_DECODER=m
CONFIG_IR_SANYO_DECODER=m
# CONFIG_IR_MCE_KBD_DECODER is not set
# CONFIG_RC_DEVICES is not set
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=m
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
# CONFIG_CYPRESS_FIRMWARE is not set
CONFIG_SMS_SIANO_MDTV=m
CONFIG_SMS_SIANO_RC=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
CONFIG_MEDIA_ATTACH=y

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=y
# CONFIG_MEDIA_TUNER_MT2063 is not set
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=y
# CONFIG_MEDIA_TUNER_QT1010 is not set
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=m
# CONFIG_MEDIA_TUNER_XC4000 is not set
CONFIG_MEDIA_TUNER_MXL5005S=y
CONFIG_MEDIA_TUNER_MXL5007T=y
# CONFIG_MEDIA_TUNER_MC44S803 is not set
# CONFIG_MEDIA_TUNER_MAX2165 is not set
CONFIG_MEDIA_TUNER_TDA18218=y
# CONFIG_MEDIA_TUNER_FC0011 is not set
CONFIG_MEDIA_TUNER_FC0012=m
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=y
CONFIG_MEDIA_TUNER_E4000=m
# CONFIG_MEDIA_TUNER_FC2580 is not set
CONFIG_MEDIA_TUNER_M88TS2022=y
# CONFIG_MEDIA_TUNER_TUA9001 is not set
CONFIG_MEDIA_TUNER_IT913X=y
# CONFIG_MEDIA_TUNER_R820T is not set

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
# CONFIG_DVB_STB0899 is not set
CONFIG_DVB_STB6100=m
CONFIG_DVB_STV090x=y
# CONFIG_DVB_STV6110x is not set
# CONFIG_DVB_M88DS3103 is not set

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=m
CONFIG_DVB_TDA18271C2DD=y

#
# DVB-S (satellite) frontends
#
# CONFIG_DVB_CX24110 is not set
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=y
CONFIG_DVB_ZL10039=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=y
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=y
CONFIG_DVB_STV6110=y
# CONFIG_DVB_STV0900 is not set
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=y
CONFIG_DVB_TDA8261=y
CONFIG_DVB_VES1X93=y
CONFIG_DVB_TUNER_ITD1000=y
# CONFIG_DVB_TUNER_CX24113 is not set
CONFIG_DVB_TDA826X=y
# CONFIG_DVB_TUA6100 is not set
CONFIG_DVB_CX24116=y
CONFIG_DVB_CX24117=y
# CONFIG_DVB_SI21XX is not set
# CONFIG_DVB_TS2020 is not set
# CONFIG_DVB_DS3000 is not set
CONFIG_DVB_MB86A16=m
# CONFIG_DVB_TDA10071 is not set

#
# DVB-T (terrestrial) frontends
#
# CONFIG_DVB_SP8870 is not set
# CONFIG_DVB_SP887X is not set
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_S5H1432=y
CONFIG_DVB_DRXD=y
# CONFIG_DVB_L64781 is not set
CONFIG_DVB_TDA1004X=y
# CONFIG_DVB_NXT6000 is not set
# CONFIG_DVB_MT352 is not set
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=y
# CONFIG_DVB_DIB3000MC is not set
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=y
CONFIG_DVB_DIB9000=y
# CONFIG_DVB_TDA10048 is not set
# CONFIG_DVB_AF9013 is not set
CONFIG_DVB_EC100=m
# CONFIG_DVB_HD29L2 is not set
CONFIG_DVB_STV0367=y
# CONFIG_DVB_CXD2820R is not set
CONFIG_DVB_RTL2830=m
# CONFIG_DVB_RTL2832 is not set

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
# CONFIG_DVB_TDA10021 is not set
# CONFIG_DVB_TDA10023 is not set
CONFIG_DVB_STV0297=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=y
# CONFIG_DVB_BCM3510 is not set
CONFIG_DVB_LGDT330X=y
# CONFIG_DVB_LGDT3305 is not set
# CONFIG_DVB_LG2160 is not set
CONFIG_DVB_S5H1409=y
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_DTV=m
CONFIG_DVB_S5H1411=y

#
# ISDB-T (terrestrial) frontends
#
# CONFIG_DVB_S921 is not set
CONFIG_DVB_DIB8000=y
CONFIG_DVB_MB86A20S=m

#
# Digital terrestrial only tuners/PLL
#
# CONFIG_DVB_PLL is not set
# CONFIG_DVB_TUNER_DIB0070 is not set
# CONFIG_DVB_TUNER_DIB0090 is not set

#
# SEC control devices for DVB-S
#
# CONFIG_DVB_LNBP21 is not set
CONFIG_DVB_LNBP22=m
# CONFIG_DVB_ISL6405 is not set
CONFIG_DVB_ISL6421=m
# CONFIG_DVB_ISL6423 is not set
CONFIG_DVB_A8293=y
CONFIG_DVB_LGS8GL5=m
CONFIG_DVB_LGS8GXX=y
# CONFIG_DVB_ATBM8830 is not set
# CONFIG_DVB_TDA665x is not set
CONFIG_DVB_IX2505V=y
CONFIG_DVB_IT913X_FE=y
# CONFIG_DVB_M88RS2000 is not set
CONFIG_DVB_AF9033=m

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=m

#
# Graphics support
#
CONFIG_AGP=m
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
CONFIG_AGP_AMD=m
CONFIG_AGP_AMD64=m
CONFIG_AGP_INTEL=m
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
CONFIG_AGP_SWORKS=m
CONFIG_AGP_VIA=m
# CONFIG_AGP_EFFICEON is not set
CONFIG_INTEL_GTT=m
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
CONFIG_DRM=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=m

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
CONFIG_DRM_I2C_SIL164=m
CONFIG_DRM_I2C_NXP_TDA998X=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_NOUVEAU=m
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
CONFIG_DRM_I915=m
# CONFIG_DRM_I915_KMS is not set
CONFIG_DRM_I915_FBDEV=y
# CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT is not set
CONFIG_DRM_I915_UMS=y
# CONFIG_DRM_MGA is not set
CONFIG_DRM_SIS=m
CONFIG_DRM_VIA=m
CONFIG_DRM_SAVAGE=m
CONFIG_DRM_VMWGFX=m
# CONFIG_DRM_VMWGFX_FBCON is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
CONFIG_DRM_MGAG200=m
CONFIG_DRM_CIRRUS_QEMU=m
CONFIG_DRM_QXL=m
CONFIG_DRM_BOCHS=m

#
# Frame buffer Devices
#
CONFIG_FB=m
CONFIG_FIRMWARE_EDID=y
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
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
CONFIG_FB_ARC=m
# CONFIG_FB_VGA16 is not set
CONFIG_FB_N411=m
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
CONFIG_FB_S1D13XXX=m
CONFIG_FB_LE80578=m
CONFIG_FB_CARILLO_RANCH=m
CONFIG_FB_ATY128=m
# CONFIG_FB_ATY128_BACKLIGHT is not set
CONFIG_FB_ATY=m
# CONFIG_FB_ATY_CT is not set
CONFIG_FB_ATY_GX=y
# CONFIG_FB_ATY_BACKLIGHT is not set
CONFIG_FB_SIS=m
# CONFIG_FB_SIS_300 is not set
CONFIG_FB_SIS_315=y
CONFIG_FB_NEOMAGIC=m
CONFIG_FB_KYRO=m
CONFIG_FB_VOODOO1=m
CONFIG_FB_VT8623=m
CONFIG_FB_TRIDENT=m
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=m
# CONFIG_FB_CARMINE is not set
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=m
# CONFIG_FB_GEODE_GX is not set
CONFIG_FB_GEODE_GX1=m
CONFIG_FB_TMIO=m
CONFIG_FB_TMIO_ACCELL=y
# CONFIG_FB_SM501 is not set
CONFIG_FB_SMSCUFX=m
CONFIG_FB_UDL=m
# CONFIG_FB_GOLDFISH is not set
CONFIG_FB_VIRTUAL=m
# CONFIG_FB_METRONOME is not set
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
CONFIG_FB_BROADSHEET=m
CONFIG_FB_AUO_K190X=m
# CONFIG_FB_AUO_K1900 is not set
CONFIG_FB_AUO_K1901=m
CONFIG_EXYNOS_VIDEO=y
# CONFIG_FB_SSD1307 is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_L4F00242T03=m
# CONFIG_LCD_LMS283GF05 is not set
CONFIG_LCD_LTV350QV=y
# CONFIG_LCD_ILI922X is not set
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_TDO24M=m
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=y
CONFIG_LCD_S6E63M0=m
# CONFIG_LCD_LD9040 is not set
# CONFIG_LCD_AMS369FG06 is not set
CONFIG_LCD_LMS501KF03=m
# CONFIG_LCD_HX8357 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_BACKLIGHT_GENERIC=m
CONFIG_BACKLIGHT_LM3533=m
CONFIG_BACKLIGHT_CARILLO_RANCH=m
CONFIG_BACKLIGHT_DA9052=m
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=m
CONFIG_BACKLIGHT_ADP8860=m
CONFIG_BACKLIGHT_ADP8870=m
# CONFIG_BACKLIGHT_LM3630A is not set
CONFIG_BACKLIGHT_LM3639=m
CONFIG_BACKLIGHT_LP855X=m
# CONFIG_BACKLIGHT_OT200 is not set
# CONFIG_BACKLIGHT_PANDORA is not set
CONFIG_BACKLIGHT_TPS65217=m
CONFIG_BACKLIGHT_AS3711=m
CONFIG_BACKLIGHT_GPIO=m
CONFIG_BACKLIGHT_LV5207LP=m
# CONFIG_BACKLIGHT_BD6107 is not set
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_HDMI=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_SEQUENCER_OSS is not set
# CONFIG_SND_HRTIMER is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_DRIVERS=y
CONFIG_SND_DUMMY=m
CONFIG_SND_ALOOP=m
CONFIG_SND_VIRMIDI=m
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
CONFIG_SND_PORTMAN2X4=m
# CONFIG_SND_PCI is not set

#
# HD-Audio
#
# CONFIG_SND_SPI is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_UA101=m
CONFIG_SND_USB_USX2Y=m
# CONFIG_SND_USB_CAIAQ is not set
CONFIG_SND_USB_US122L=m
CONFIG_SND_USB_6FIRE=m
# CONFIG_SND_USB_HIFACE is not set
# CONFIG_SND_PCMCIA is not set
# CONFIG_SND_SOC is not set
CONFIG_SOUND_PRIME=y
CONFIG_SOUND_OSS=y
CONFIG_SOUND_TRACEINIT=y
# CONFIG_SOUND_DMAP is not set
CONFIG_SOUND_VMIDI=m
CONFIG_SOUND_TRIX=y
# CONFIG_SOUND_MSS is not set
CONFIG_SOUND_MPU401=y
# CONFIG_SOUND_PAS is not set
# CONFIG_SOUND_PSS is not set
CONFIG_SOUND_SB=m
CONFIG_SOUND_YM3812=m
CONFIG_SOUND_UART6850=y
# CONFIG_SOUND_AEDSP16 is not set
CONFIG_SOUND_KAHLUA=m

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
CONFIG_HID_ACRUX=m
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=m
CONFIG_HID_APPLEIR=m
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CP2112=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
CONFIG_DRAGONRISE_FF=y
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=m
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=m
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_HUION is not set
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=m
# CONFIG_HID_GYRATION is not set
CONFIG_HID_ICADE=m
CONFIG_HID_TWINHAN=m
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LCPOWER=m
CONFIG_HID_LENOVO_TPKBD=m
# CONFIG_HID_LOGITECH is not set
CONFIG_HID_MAGICMOUSE=m
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
CONFIG_HID_MULTITOUCH=m
# CONFIG_HID_NTRIG is not set
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=m
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_PRIMAX=m
CONFIG_HID_ROCCAT=m
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
# CONFIG_HID_SONY is not set
CONFIG_HID_SPEEDLINK=m
CONFIG_HID_STEELSERIES=m
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=m
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=m
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=m
# CONFIG_HID_THRUSTMASTER is not set
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=m
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=m
CONFIG_HID_PID=y
# CONFIG_USB_HIDDEV is not set

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set

#
# I2C HID support
#
CONFIG_I2C_HID=m
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
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_OTG=y
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_MON=y
CONFIG_USB_WUSB_CBAF=m
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=m
CONFIG_USB_XHCI_PLATFORM=m
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=m
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=m
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_FUSBH200_HCD=m
CONFIG_USB_FOTG210_HCD=m
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_U132_HCD is not set
CONFIG_USB_SL811_HCD=m
CONFIG_USB_SL811_HCD_ISO=y
CONFIG_USB_SL811_CS=m
CONFIG_USB_R8A66597_HCD=m
CONFIG_USB_RENESAS_USBHS_HCD=m
# CONFIG_USB_HCD_BCMA is not set
CONFIG_USB_HCD_SSB=m
CONFIG_USB_HCD_TEST_MODE=y
CONFIG_USB_RENESAS_USBHS=m

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
CONFIG_USB_TMC=y

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
CONFIG_USB_MDC800=m
# CONFIG_USB_MICROTEK is not set
CONFIG_USB_MUSB_HDRC=m
CONFIG_USB_MUSB_HOST=y
# CONFIG_USB_MUSB_GADGET is not set
# CONFIG_USB_MUSB_DUAL_ROLE is not set
CONFIG_USB_MUSB_TUSB6010=m
CONFIG_USB_MUSB_DSPS=m
CONFIG_USB_MUSB_UX500=m
CONFIG_USB_MUSB_AM335X_CHILD=m
CONFIG_USB_UX500_DMA=y
# CONFIG_MUSB_PIO_ONLY is not set
CONFIG_USB_DWC3=m
# CONFIG_USB_DWC3_HOST is not set
CONFIG_USB_DWC3_GADGET=y
# CONFIG_USB_DWC3_DUAL_ROLE is not set

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_OMAP=m
CONFIG_USB_DWC3_EXYNOS=m
# CONFIG_USB_DWC3_PCI is not set
# CONFIG_USB_DWC3_KEYSTONE is not set

#
# Debugging features
#
CONFIG_USB_DWC3_DEBUG=y
# CONFIG_USB_DWC3_VERBOSE is not set
CONFIG_USB_DWC2=y
CONFIG_USB_DWC2_DEBUG=y
# CONFIG_USB_DWC2_VERBOSE is not set
# CONFIG_USB_DWC2_TRACK_MISSED_SOFS is not set
CONFIG_USB_DWC2_DEBUG_PERIODIC=y
CONFIG_USB_CHIPIDEA=y
# CONFIG_USB_CHIPIDEA_UDC is not set
CONFIG_USB_CHIPIDEA_HOST=y
# CONFIG_USB_CHIPIDEA_DEBUG is not set

#
# USB port drivers
#
CONFIG_USB_USS720=y
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=m
# CONFIG_USB_LCD is not set
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=y
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=m
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=m
CONFIG_USB_EHSET_TEST_FIXTURE=y
# CONFIG_USB_ISIGHTFW is not set
CONFIG_USB_YUREX=m
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HSIC_USB3503 is not set
CONFIG_USB_ATM=m
# CONFIG_USB_SPEEDTOUCH is not set
# CONFIG_USB_CXACRU is not set
# CONFIG_USB_UEAGLEATM is not set
CONFIG_USB_XUSBATM=m

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_USB_OTG_FSM=y
# CONFIG_NOP_USB_XCEIV is not set
CONFIG_SAMSUNG_USBPHY=y
# CONFIG_SAMSUNG_USB2PHY is not set
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_USB_GPIO_VBUS=y
CONFIG_TAHVO_USB=m
CONFIG_TAHVO_USB_HOST_BY_DEFAULT=y
CONFIG_USB_ISP1301=m
CONFIG_USB_RCAR_PHY=m
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_DEBUG=y
# CONFIG_USB_GADGET_VERBOSE is not set
CONFIG_USB_GADGET_DEBUG_FILES=y
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
# CONFIG_USB_FUSB300 is not set
# CONFIG_USB_FOTG210_UDC is not set
CONFIG_USB_GR_UDC=m
CONFIG_USB_R8A66597=m
CONFIG_USB_RENESAS_USBHS_UDC=m
CONFIG_USB_PXA27X=m
CONFIG_USB_S3C_HSOTG=m
CONFIG_USB_MV_UDC=m
# CONFIG_USB_MV_U3D is not set
CONFIG_USB_M66592=y
CONFIG_USB_AMD5536UDC=y
CONFIG_USB_NET2272=y
# CONFIG_USB_NET2272_DMA is not set
# CONFIG_USB_NET2280 is not set
CONFIG_USB_GOKU=y
# CONFIG_USB_EG20T is not set
# CONFIG_USB_DUMMY_HCD is not set
CONFIG_USB_LIBCOMPOSITE=m
CONFIG_USB_F_SS_LB=m
CONFIG_USB_U_ETHER=m
CONFIG_USB_F_NCM=m
CONFIG_USB_F_ECM=m
CONFIG_USB_F_SUBSET=m
CONFIG_USB_F_RNDIS=m
CONFIG_USB_F_MASS_STORAGE=m
# CONFIG_USB_CONFIGFS is not set
CONFIG_USB_ZERO=m
CONFIG_USB_ZERO_HNPTEST=y
CONFIG_USB_AUDIO=m
CONFIG_GADGET_UAC1=y
CONFIG_USB_ETH=m
CONFIG_USB_ETH_RNDIS=y
# CONFIG_USB_ETH_EEM is not set
CONFIG_USB_G_NCM=m
CONFIG_USB_GADGETFS=m
# CONFIG_USB_FUNCTIONFS is not set
CONFIG_USB_MASS_STORAGE=m
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_MIDI_GADGET is not set
CONFIG_USB_G_PRINTER=m
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_NOKIA is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
CONFIG_USB_G_HID=m
# CONFIG_USB_G_DBGP is not set
# CONFIG_UWB is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
# CONFIG_MMC_BLOCK_BOUNCE is not set
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
# CONFIG_MMC_WBSD is not set
CONFIG_MMC_TIFM_SD=m
# CONFIG_MMC_SPI is not set
CONFIG_MMC_SDRICOH_CS=m
# CONFIG_MMC_CB710 is not set
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MMC_VUB300=m
CONFIG_MMC_USHC=m
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=m
CONFIG_LEDS_PCA9532=m
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=m
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8501=m
CONFIG_LEDS_CLEVO_MAIL=m
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA963X=m
CONFIG_LEDS_PCA9685=m
# CONFIG_LEDS_WM8350 is not set
CONFIG_LEDS_DA9052=m
CONFIG_LEDS_DAC124S085=m
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_MC13783=m
CONFIG_LEDS_TCA6507=m
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_IDE_DISK=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=y
# CONFIG_EDAC_MCE_INJ is not set
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC_AMD76X=m
CONFIG_EDAC_E7XXX=m
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82875P=m
CONFIG_EDAC_I82975X=m
# CONFIG_EDAC_I3000 is not set
CONFIG_EDAC_I3200=m
CONFIG_EDAC_X38=m
# CONFIG_EDAC_I5400 is not set
CONFIG_EDAC_I82860=m
CONFIG_EDAC_R82600=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
# CONFIG_RTC_INTF_PROC is not set
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM80X=y
# CONFIG_RTC_DRV_DS1307 is not set
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=m
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_HYM8563 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
CONFIG_RTC_DRV_MAX8998=m
CONFIG_RTC_DRV_MAX77686=y
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=y
CONFIG_RTC_DRV_ISL12057=y
# CONFIG_RTC_DRV_X1205 is not set
CONFIG_RTC_DRV_PCF2127=m
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=y
CONFIG_RTC_DRV_TWL4030=y
CONFIG_RTC_DRV_TPS6586X=m
CONFIG_RTC_DRV_S35390A=y
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=y
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=m
CONFIG_RTC_DRV_M41T94=m
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1390 is not set
CONFIG_RTC_DRV_MAX6902=y
# CONFIG_RTC_DRV_R9701 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
CONFIG_RTC_DRV_DS3234=y
# CONFIG_RTC_DRV_PCF2123 is not set
CONFIG_RTC_DRV_RX4581=y

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=y
# CONFIG_RTC_DRV_DA9052 is not set
CONFIG_RTC_DRV_DA9055=m
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=m
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=y
# CONFIG_RTC_DRV_DS2404 is not set
CONFIG_RTC_DRV_WM8350=y

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_PCAP is not set
# CONFIG_RTC_DRV_MC13XXX is not set
# CONFIG_RTC_DRV_SNVS is not set
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
CONFIG_INTEL_IOATDMA=m
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
CONFIG_DW_DMAC_PCI=y
CONFIG_TIMB_DMA=m
CONFIG_PCH_DMA=m
CONFIG_FSL_EDMA=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
CONFIG_DMA_OF=y

#
# DMA Clients
#
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=y
CONFIG_DMA_ENGINE_RAID=y
CONFIG_DCA=m
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
CONFIG_UIO_CIF=m
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=m
CONFIG_UIO_AEC=m
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
CONFIG_UIO_MF624=m
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
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
CONFIG_DELL_LAPTOP=m
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
CONFIG_AMILO_RFKILL=m
# CONFIG_TC1100_WMI is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_HP_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=m
# CONFIG_INTEL_MENLOW is not set
CONFIG_ACPI_WMI=m
# CONFIG_MSI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
CONFIG_XO1_RFKILL=m
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_MXM_WMI=m
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
CONFIG_CHROME_PLATFORMS=y
# CONFIG_CHROMEOS_LAPTOP is not set
# CONFIG_CHROMEOS_PSTORE is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
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
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
CONFIG_DEVFREQ_GOV_USERSPACE=m

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_OF_EXTCON=y
CONFIG_EXTCON_GPIO=m
# CONFIG_EXTCON_MAX14577 is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
CONFIG_NTB=y
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IRQCHIP=y
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_EXYNOS_MIPI_VIDEO=m
CONFIG_PHY_EXYNOS_DP_VIDEO=m
# CONFIG_BCM_KONA_USB2_PHY is not set
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=m
# CONFIG_MCB is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=m
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
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
# CONFIG_EXT3_FS_POSIX_ACL is not set
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=m
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
CONFIG_JFS_DEBUG=y
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_WARN=y
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=m
# CONFIG_GFS2_FS_LOCKING_DLM is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=m
# CONFIG_BTRFS_FS_POSIX_ACL is not set
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
CONFIG_BTRFS_ASSERT=y
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_FSCACHE_OBJECT_LIST=y
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
CONFIG_CACHEFILES_HISTOGRAM=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
# CONFIG_JOLIET is not set
# CONFIG_ZISOFS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=m
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=m
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=m
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=m
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=m
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=m
# CONFIG_NLS_UTF8 is not set
CONFIG_DLM=m
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
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
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
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_PREEMPT=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_LOCK_TORTURE_TEST=m
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_PROVE_RCU_DELAY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=m
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_VERBOSE=y
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
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
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=m
CONFIG_INTERVAL_TREE_TEST=m
CONFIG_PERCPU_TEST=m
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=m
# CONFIG_TEST_KSTRTOX is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_TEST_MODULE is not set
CONFIG_TEST_USER_COPY=m
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
CONFIG_DEBUG_NX_TEST=m
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
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
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
CONFIG_BIG_KEYS=y
CONFIG_TRUSTED_KEYS=m
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
CONFIG_INTEGRITY_AUDIT=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_TEMPLATE=y
# CONFIG_IMA_NG_TEMPLATE is not set
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
CONFIG_IMA_DEFAULT_HASH="sha1"
CONFIG_IMA_APPRAISE=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
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
CONFIG_CRYPTO_USER=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
# CONFIG_CRYPTO_AUTHENC is not set
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER=m
CONFIG_CRYPTO_GLUE_HELPER_X86=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
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
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=m
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_586=y
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_586=m
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_LZ4=y
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=m
CONFIG_CRYPTO_USER_API_HASH=m
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=m
CONFIG_PUBLIC_KEY_ALGO_RSA=m
CONFIG_X509_CERTIFICATE_PARSER=m
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_LGUEST is not set
# CONFIG_BINARY_PRINTF is not set

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
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
# CONFIG_CRC64_ECMA is not set
CONFIG_AUDIT_GENERIC=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
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
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=m
CONFIG_DDR=y
CONFIG_MPILIB=m
CONFIG_OID_REGISTRY=m

--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--y0ulUmNC+osPPQO6--
