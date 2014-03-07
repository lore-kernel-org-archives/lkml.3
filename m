Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbaCGLIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 06:08:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:6085 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbaCGLIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 06:08:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,607,1389772800"; 
   d="scan'208";a="487848748"
Date: Fri, 7 Mar 2014 19:08:03 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [__slab_free]  BUG: using __this_cpu_add() in preemptible [00000000]
 code: init/1
Message-ID: <20140307110803.GA19196@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <20140307014233.GE8427@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Christoph,

FYI, here is one more back trace triggered by

commit a25982c15ae5298520033cd5848a82adf6a97376
Author:     Christoph Lameter <cl@linux.com>
AuthorDate: Thu Mar 6 11:05:21 2014 +1100

    percpu: add preemption checks to __this_cpu ops
    
+--------------------------------------------------------------+------------+------------+---------------+
|                                                              | 26d02cfa38 | a25982c15a | next-20140306 |
+--------------------------------------------------------------+------------+------------+---------------+
| boot_successes                                               | 73         | 0          | 0             |
| boot_failures                                                | 7          | 20         | 19            |
| BUG:unable_to_handle_kernel_paging_request                   | 1          |            |               |
| Oops:PREEMPT_SMP                                             | 1          |            |               |
| EIP_is_at_follow_page_mask                                   | 1          |            |               |
| backtrace:__mm_populate                                      | 1          |            |               |
| backtrace:SyS_mlockall                                       | 1          |            |               |
| WARNING:CPU:PID:at_arch/x86/kernel/cpu/amd.c:init_amd()      | 4          |            |               |
| backtrace:init_amd                                           | 4          |            |               |
| backtrace:warn_slowpath_fmt                                  | 4          |            |               |
| BUG:kernel_boot_hang                                         | 2          |            |               |
| BUG:using__this_cpu_add()in_preemptible_code:init            | 0          | 20         | 19            |
| BUG:using__this_cpu_add()in_preemptible_code:udevd           | 0          | 14         | 11            |
| backtrace:do_execve                                          | 0          | 20         | 19            |
| backtrace:run_init_process                                   | 0          | 20         | 19            |
| backtrace:user_path_at                                       | 0          | 20         | 19            |
| backtrace:SyS_faccessat                                      | 0          | 20         | 19            |
| backtrace:SyS_access                                         | 0          | 20         | 19            |
| BUG:using__this_cpu_add()in_preemptible_code:mountall        | 0          | 1          |               |
| backtrace:SyS_execve                                         | 0          | 1          | 3             |
| backtrace:do_sys_open                                        | 0          | 8          | 9             |
| backtrace:SyS_open                                           | 0          | 8          | 9             |
| backtrace:do_group_exit                                      | 0          | 2          | 4             |
| backtrace:SyS_exit_group                                     | 0          | 2          | 4             |
| BUG:using__this_cpu_add()in_preemptible_code:bootlogd        | 0          | 1          | 4             |
| BUG:using__this_cpu_add()in_p                                | 0          | 1          |               |
| BUG:using__this_cpu_add()in_preemptible_code:udevadm         | 0          | 0          | 5             |
| BUG:using__this_cpu_add()in_preemptible_code:-trinity        | 0          | 0          | 2             |
| BUG:using__this_cpu_add()in_preemptible_code:upstart-udev-br | 0          | 0          | 2             |
| BUG:using__this_cpu_add()in_preemptible_code:sh              | 0          | 0          | 1             |
| BUG:using__this_cpu_add()in_preemptible_code:update-modules  | 0          | 0          | 2             |
| BUG:using__this_cpu_add()in_preemptible_code:trinity         | 0          | 0          | 1             |
| backtrace:vfs_stat                                           | 0          | 0          | 1             |
| backtrace:SyS_stat64                                         | 0          | 0          | 1             |
+--------------------------------------------------------------+------------+------------+---------------+

[    4.164485] Write protecting the kernel text: 9076k
[    4.166234] Write protecting the kernel read-only data: 2904k
[    4.167832] NX-protecting the kernel data: 5260k
[    4.169996] BUG: using __this_cpu_add() in preemptible [00000000] code: init/1
[    4.172629] caller is __this_cpu_preempt_check+0x2d/0x40
[    4.174259] CPU: 1 PID: 1 Comm: init Not tainted 3.14.0-rc5-next-20140306-06952-g0ffb2fe #3
[    4.177120] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.178635]  00000000 00000000 cf477d3c c18d4eeb 00000001 cf477d60 c12e80b9 c1ace2c8
[    4.182201]  cf477d78 00000000 cf4782a4 00000001 cf477d78 cfc455c0 cf477da4 c12e810d
[    4.186749]  cf477d78 00000028 c1acdb6d c1b42ef1 68745f5f 635f7369 615f7570 29286464
[    4.190306] Call Trace:
[    4.191374]  [<c18d4eeb>] dump_stack+0x4b/0x75
[    4.192838]  [<c12e80b9>] check_preemption_disabled+0xc9/0xe0
[    4.194598]  [<c12e810d>] __this_cpu_preempt_check+0x2d/0x40
[    4.196363]  [<c10f7343>] ? __split_vma.isra.29+0x23/0x150
[    4.197913]  [<c18d4579>] __slab_free+0x1e/0x43c
[    4.199341]  [<c10f6825>] ? __remove_shared_vm_struct+0x35/0x50
[    4.201173]  [<c10f03b0>] ? free_pgtables+0x80/0xb0
[    4.202712]  [<c1068ecb>] ? get_parent_ip+0xb/0x40
[    4.204237]  [<c1068fff>] ? preempt_count_sub+0x5f/0xe0
[    4.205809]  [<c1104c08>] kmem_cache_free+0x138/0x190
[    4.207394]  [<c10f66c5>] ? remove_vma+0x45/0x50
[    4.208936]  [<c10f66c5>] ? remove_vma+0x45/0x50
[    4.210450]  [<c10f66c5>] remove_vma+0x45/0x50
[    4.212026]  [<c10f8225>] do_munmap+0x1f5/0x2a0
[    4.213596]  [<c10f8302>] vm_munmap+0x32/0x50
[    4.215039]  [<c1153772>] load_elf_binary+0x10c2/0x11d0
[    4.216750]  [<c1068fff>] ? preempt_count_sub+0x5f/0xe0
[    4.218388]  [<c11132c2>] search_binary_handler+0x62/0x170
[    4.220182]  [<c105a15e>] ? __task_pid_nr_ns+0x5e/0xa0
[    4.221864]  [<c11145d8>] do_execve+0x418/0x570
[    4.223313]  [<c100036c>] run_init_process+0x1c/0x20
[    4.224943]  [<c18ce7d7>] kernel_init+0x37/0xe0
[    4.226498]  [<c18dba37>] ret_from_kernel_thread+0x1b/0x28
[    4.228310]  [<c18ce7a0>] ? rest_init+0x70/0x70

git bisect start 0ffb2fe7b9c30082876fa3a17da018bf0632cf03 09de192242d86ede449146ac423effca53bc1810 --
git bisect  bad 439cde1f3d8230f858c0a55902381d24cd7a2df2  # 13:05      0-      4  Merge branch 'akpm/master'
git bisect good ce34778eb4d9fa0aaaeae76c1068026ee5255fd7  # 13:11     20+      0  Merge branch 'akpm-current/current'
git bisect good 117314461e82adabb6b78dcb03259da75b50833b  # 13:23     20+      1  mm: don't implictly include linux/mm.h in linux/sched.h
git bisect  bad 9d58cf7a388c1b4a06cb335980eb1bb1352ba876  # 13:41      0-      1  scheduler: replace __get_cpu_var with this_cpu_ptr
git bisect  bad b2ff2cfebad92bebfca28bad650045821ed270c4  # 13:49      0-      1  tracing: replace __get_cpu_var uses with this_cpu_ptr
git bisect good 6fb77936481538ba05726345d86af4b39128a8a9  # 14:41     20+      0  arm: move arm_dma_limit to setup_dma_zone
git bisect good d1cea07efbfa2723ca1b83d3a69d1f1000896d4d  # 15:06     20+      1  modules: use raw_cpu_write for initialization of per cpu refcount.
git bisect  bad a25982c15ae5298520033cd5848a82adf6a97376  # 15:16      0-      8  percpu: add preemption checks to __this_cpu ops
git bisect good 26d02cfa385067c39c0407b022c01a011c2fbb51  # 15:43     20+      1  net: replace __this_cpu_inc in route.c with raw_cpu_inc
# first bad commit: [a25982c15ae5298520033cd5848a82adf6a97376] percpu: add preemption checks to __this_cpu ops
git bisect good 26d02cfa385067c39c0407b022c01a011c2fbb51  # 16:02     60+      7  net: replace __this_cpu_inc in route.c with raw_cpu_inc
git bisect  bad 0ffb2fe7b9c30082876fa3a17da018bf0632cf03  # 16:03      0-     19  Add linux-next specific files for 20140306
git bisect good cc0ca6b3d97f5006e536a2601a3569baed920397  # 16:31     60+      1  Revert "percpu: add preemption checks to __this_cpu ops"
git bisect good c3bebc71c4bcdafa24b506adf0c1de3c1f77e2e0  # 17:02     60+      0  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect good 1b0a7e3263168a06d3858798e48c5a21d1c78d3c  # 18:40     60+      2  Add linux-next specific files for 20140307

Thanks,
Fengguang

--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-xian-35:20140307044610:i386-randconfig-x0-03070431:3.14.0-rc5-next-20140306-06952-g0ffb2fe:3"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Linux version 3.14.0-rc5-next-20140306-06952-g0ffb2fe (kbuil=
d@xian) (gcc version 4.8.1 (Debian 4.8.1-8) ) #3 SMP PREEMPT Fri Mar 7 04:4=
3:34 CST 2014
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
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] initial memory mapped: [mem 0x00000000-0x021fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
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
[    0.000000] BRK [0x01d85000, 0x01d85fff] PGTABLE
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
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] BRK [0x01d86000, 0x01d86fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000] free_area_init_node: node 0, pgdat c1c38080, node_mem_map cf=
abd020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 480 pages used for memmap
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
[    0.000000] PERCPU: Embedded 13 pages/cpu @cfaa3000 s31808 r0 d21440 u53=
248
[    0.000000] pcpu-alloc: s31808 r0 d21440 u53248 alloc=3D13*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr faa5740
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64924
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-x0-03070431/next:master/.vmlinuz-0ffb2fe7b9c30082876fa3a=
17da018bf0632cf03-20140307044438-9-xian branch=3Dnext/master BOOT_IMAGE=3D/=
kernel/i386-randconfig-x0-03070431/0ffb2fe7b9c30082876fa3a17da018bf0632cf03=
/vmlinuz-3.14.0-rc5-next-20140306-06952-g0ffb2fe
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 242160K/261744K available (9073K kernel code, 597K r=
wdata, 2900K rodata, 580K init, 584K bss, 19584K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xffbfe000   ( 756 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc1c49000 - 0xc1cda000   ( 580 kB)
[    0.000000]       .data : 0xc18dca89 - 0xc1c48580   (3502 kB)
[    0.000000]       .text : 0xc1000000 - 0xc18dca89   (9074 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D2, =
Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3Dcf410000 soft=3Dcf412000
[    0.000000] ACPI: Core revision 20140214
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Linux version 3.14.0-rc5-next-20140306-06952-g0ffb2fe (kbuil=
d@xian) (gcc version 4.8.1 (Debian 4.8.1-8) ) #3 SMP PREEMPT Fri Mar 7 04:4=
3:34 CST 2014
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
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] initial memory mapped: [mem 0x00000000-0x021fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
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
[    0.000000] BRK [0x01d85000, 0x01d85fff] PGTABLE
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
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] BRK [0x01d86000, 0x01d86fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000] free_area_init_node: node 0, pgdat c1c38080, node_mem_map cf=
abd020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 480 pages used for memmap
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
[    0.000000] PERCPU: Embedded 13 pages/cpu @cfaa3000 s31808 r0 d21440 u53=
248
[    0.000000] pcpu-alloc: s31808 r0 d21440 u53248 alloc=3D13*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr faa5740
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64924
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-x0-03070431/next:master/.vmlinuz-0ffb2fe7b9c30082876fa3a=
17da018bf0632cf03-20140307044438-9-xian branch=3Dnext/master BOOT_IMAGE=3D/=
kernel/i386-randconfig-x0-03070431/0ffb2fe7b9c30082876fa3a17da018bf0632cf03=
/vmlinuz-3.14.0-rc5-next-20140306-06952-g0ffb2fe
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 242160K/261744K available (9073K kernel code, 597K r=
wdata, 2900K rodata, 580K init, 584K bss, 19584K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xffbfe000   ( 756 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc1c49000 - 0xc1cda000   ( 580 kB)
[    0.000000]       .data : 0xc18dca89 - 0xc1c48580   (3502 kB)
[    0.000000]       .text : 0xc1000000 - 0xc18dca89   (9074 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D2, =
Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3Dcf410000 soft=3Dcf412000
[    0.000000] ACPI: Core revision 20140214
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2892.992 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5785.98 Bogo=
MIPS (lpj=3D28929920)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] Mount-cache hash table entries: 512
[    0.020000] mce: CPU supports 10 MCE banks
[    0.020095] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020095] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.020095] tlb_flushall_shift: 6
[    0.025907] Freeing SMP alternatives memory: 28K (c1cda000 - c1ce1000)
[    0.034270] Getting VERSION: 50014
[    0.035607] Getting VERSION: 50014
[    0.037029] Getting ID: 0
[    0.038205] Getting ID: f000000
[    0.039429] Getting LVT0: 8700
[    0.040017] Getting LVT1: 8400
[    0.041188] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.043230] enabled ExtINT on CPU#0
[    0.046093] ENABLING IO-APIC IRQs
[    0.047484] init IO_APIC IRQs
[    0.048713]  apic 0 pin 0 not connected
[    0.050038] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.052931] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.055558] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.058261] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.060047] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.062566] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.065350] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.070053] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.072873] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.075500] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.078128] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.080051] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.082993] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.085655] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.090052] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.093007]  apic 0 pin 16 not connected
[    0.094411]  apic 0 pin 17 not connected
[    0.095744]  apic 0 pin 18 not connected
[    0.097211]  apic 0 pin 19 not connected
[    0.098514]  apic 0 pin 20 not connected
[    0.100010]  apic 0 pin 21 not connected
[    0.101373]  apic 0 pin 22 not connected
[    0.102760]  apic 0 pin 23 not connected
[    0.104324] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.106345] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.110011] Using local APIC timer interrupts.
[    0.110011] calibrating APIC timer ...
[    0.120000] ... lapic delta =3D 6251049
[    0.120000] ... PM-Timer delta =3D 358026
[    0.120000] ... PM-Timer result ok
[    0.120000] ..... delta 6251049
[    0.120000] ..... mult: 268480510
[    0.120000] ..... calibration result: 10001678
[    0.120000] ..... CPU clock speed is 2893.5714 MHz.
[    0.120000] ..... host bus clock speed is 1000.1678 MHz.
[    0.120120] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.180628] CPU 1 irqstacks, hard=3Dcf4c2000 soft=3Dcf4c4000
[    0.182409] x86: Booting SMP configuration:
[    0.183911] .... node  #0, CPUs:      #1
[    0.010000] Initializing CPU#1
[    0.020000] kvm-clock: cpu 1, msr 0:fffd041, secondary cpu clock
[    0.020000] masked ExtINT on CPU#1
[    0.200160] x86: Booted up 1 node, 2 CPUs
[    0.200058] KVM setup async PF for cpu 1
[    0.200058] kvm-stealtime: cpu 1, msr fab2740
[    0.210011] smpboot: Total of 2 processors activated (11571.96 BogoMIPS)
[    0.213170] devtmpfs: initialized
[    0.231931] prandom: seed boundary self test passed
[    0.235414] prandom: 100 self tests passed
[    0.236782] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.241193] regulator-dummy: no parameters
[    0.243726] NET: Registered protocol family 16
[    0.249382] cpuidle: using governor ladder
[    0.250009] cpuidle: using governor menu
[    0.252045] ACPI: bus type PCI registered
[    0.253413] PCI: Using configuration type 1 for base access
[    0.372856] ACPI: Added _OSI(Module Device)
[    0.373099] ACPI: Added _OSI(Processor Device)
[    0.374707] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.380009] ACPI: Added _OSI(Processor Aggregator Device)
[    0.499465] ACPI: Interpreter enabled
[    0.500077] ACPI: (supports S0 S5)
[    0.501300] ACPI: Using IOAPIC for interrupt routing
[    0.503361] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.698236] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.700070] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    0.701952] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.716816] PCI host bridge to bus 0000:00
[    0.718208] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.720028] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.721780] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.723526] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.725666] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.727956] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.735180] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.742181] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.748355] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.756685] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.759149] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.760033] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.767446] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.773383] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.777589] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.791058] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.799014] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.801788] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.805287] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.815582] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.823445] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.827051] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.830011] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.845706] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.849363] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.851683] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.867975] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.871836] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.875194] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.891442] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.895012] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.898432] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.915383] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.919219] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.921724] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.938273] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.941817] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.944991] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.961165] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.963979] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.976502] pci_bus 0000:00: on NUMA node 0
[    0.992051] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.998300] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.004831] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.011235] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.014739] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    1.029086] ACPI: Enabled 16 GPEs in block 00 to 0F
[    1.033183] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.033183] vgaarb: loaded
[    1.033183] vgaarb: bridge control possible 0000:00:02.0
[    1.046423] SCSI subsystem initialized
[    1.046423] libata version 3.00 loaded.
[    1.046423] ACPI: bus type USB registered
[    1.046423] usbcore: registered new interface driver usbfs
[    1.048064] usbcore: registered new interface driver hub
[    1.050216] usbcore: registered new device driver usb
[    1.052798] pps_core: LinuxPPS API ver. 1 registered
[    1.054211] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.057404] PTP clock support registered
[    1.060731] PCI: Using ACPI for IRQ routing
[    1.062163] PCI: pci_cache_line_size set to 64 bytes
[    1.063781] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.065411] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    1.071304] irda_init()
[    1.072557] NET: Registered protocol family 23
[    1.074548] nfc: nfc_init: NFC Core ver 0.1
[    1.076083] NET: Registered protocol family 39
[    1.078429] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    1.080241] Switched to clocksource kvm-clock
[    1.190713] FS-Cache: Loaded
[    1.192121] pnp: PnP ACPI init
[    1.193581] ACPI: bus type PNP registered
[    1.195317] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    1.198654] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.200772] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    1.203998] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.206258] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    1.213219] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.215911] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    1.218256] pnp 00:03: [dma 2]
[    1.220281] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.223053] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    1.226301] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.229045] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    1.232319] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.240137] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.245792] pnp: PnP ACPI: found 7 devices
[    1.247099] ACPI: bus type PNP unregistered
[    1.345011] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.346637] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.348722] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.350995] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.354807] NET: Registered protocol family 2
[    1.357971] TCP established hash table entries: 2048 (order: 1, 8192 byt=
es)
[    1.361168] TCP bind hash table entries: 2048 (order: 2, 16384 bytes)
[    1.364949] TCP: Hash tables configured (established 2048 bind 2048)
[    1.367102] TCP: reno registered
[    1.368673] UDP hash table entries: 256 (order: 1, 8192 bytes)
[    1.370642] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
[    1.374861] NET: Registered protocol family 1
[    1.387195] RPC: Registered named UNIX socket transport module.
[    1.389485] RPC: Registered udp transport module.
[    1.391117] RPC: Registered tcp transport module.
[    1.392836] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.394805] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.396767] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.398587] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.401045] pci 0000:00:02.0: Boot video device
[    1.402711] PCI: CLS 0 bytes, default 64
[    1.405162] Unpacking initramfs...
[    1.711807] Freeing initrd memory: 3276K (cfcbd000 - cfff0000)
[    2.356640] DMA-API: preallocated 65536 debug entries
[    2.358264] DMA-API: debugging enabled by kernel config
[    2.363450] Machine check injector initialized
[    2.369507] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    2.378009] futex hash table entries: 512 (order: 3, 32768 bytes)
[    2.380409] audit: initializing netlink subsys (disabled)
[    2.382267] audit: type=3D2000 audit(1394138757.940:1): initialized
[    2.617258] VFS: Disk quotas dquot_6.5.2
[    2.621106] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.632085] FS-Cache: Netfs 'nfs' registered for caching
[    2.648854] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    2.659736] JFS: nTxBlock =3D 1917, nTxLock =3D 15341
[    2.663570] SGI XFS with security attributes, debug enabled
[    2.710562] 9p: Installing v9fs 9p2000 file system support
[    2.714527] FS-Cache: Netfs '9p' registered for caching
[    2.725954] Key type asymmetric registered
[    2.729781] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 249)
[    2.732329] io scheduler noop registered
[    2.738252] io scheduler cfq registered (default)
[    2.742681] xz_dec_test: module loaded
[    2.744087] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
248 0' and write .xz files to it.
[    2.754706] ipmi message handler version 39.2
[    2.756245] ipmi device interface
[    2.757959] IPMI System Interface driver.
[    2.760249] ipmi_si: Adding default-specified kcs state machine
[    2.761970] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    2.765101] ipmi_si: Interface detection failed
[    2.788839] ipmi_si: Adding default-specified smic state machine
[    2.790837] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    2.793975] ipmi_si: Interface detection failed
[    2.818843] ipmi_si: Adding default-specified bt state machine
[    2.820728] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    2.823753] ipmi_si: Interface detection failed
[    2.849243] ipmi_si: Unable to find any System Interface(s)
[    2.853091] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    2.855701] ACPI: Power Button [PWRF]
[    3.267977] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.293982] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    3.305928] serial: Freescale lpuart driver
[    3.307785] Cyclades driver 2.6
[    3.309497] Initializing Nozomi driver 2.1d
[    3.311513] SyncLink MultiPort driver $Revision: 4.38 $
[    3.361157] tsc: Refined TSC clocksource calibration: 2892.983 MHz
[    3.415150] SyncLink MultiPort driver $Revision: 4.38 $, tty major#242
[    3.417875] Non-volatile memory driver v1.3
[    3.419249] toshiba: not a supported Toshiba laptop
[    3.420866] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    3.422493] Linux agpgart interface v0.103
[    3.425258] dummy-irq: no IRQ given.  Use irq=3DN
[    3.426826] lkdtm: No crash points registered, enable through debugfs
[    3.429788] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    3.433776] Guest personality initialized and is inactive
[    3.436178] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D62)
[    3.438116] Initialized host personality
[    3.443190] Loading iSCSI transport class v2.0-870.
[    3.449420] emc: device handler registered
[    3.450798] alua: device handler registered
[    3.458197] iscsi: registered transport (tcp)
[    3.459701] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    3.466635] isci: Intel(R) C600 SAS Controller Driver - version 1.1.0
[    3.471953] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.06.00.12-k.
[    3.476176] Brocade BFA FC/FCOE SCSI driver - version: 3.2.23.0
[    3.478882] DC390: clustering now enabled by default. If you get problem=
s load
[    3.481266]        with "disable_clustering=3D1" and report to maintaine=
rs
[    3.483657] mpt3sas version 02.100.00.00 loaded
[    3.486776] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    3.488895] 3ware 9000 Storage Controller device driver for Linux v2.26.=
02.014.
[    3.491797] ipr: IBM Power RAID SCSI Device Driver version: 2.6.0 (Novem=
ber 16, 2012)
[    3.494775] libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age =
0xf, 4 bits.
[    3.497268] libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx=
 0.
[    3.499176] Chelsio T4/T5 iSCSI Driver cxgb4i v0.9.4
[    3.501451] iscsi: registered transport (cxgb4i)
[    3.503299] osd: LOADED open-osd 0.2.1
[    3.512462] libphy: Fixed MDIO Bus: probed
[    3.514849] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.t=
c.umn.edu>
[    3.520634] ipddp0: Appletalk-IP Decap. mode by Jay Schulist <jschlst@sa=
mba.org>
[    3.523136] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    3.524808] Copyright (c) 2007 Atheros Corporation.
[    3.530190] jme: JMicron JMC2XX ethernet driver version 1.0.8
[    3.532380] myri10ge: Version 1.5.3-1.534
[    3.534262] pch_gbe: EG20T PCH Gigabit Ethernet Driver - version 1.01
[    3.538436] usbcore: registered new interface driver kingsun-sir
[    3.548352] x25_asy: X.25 async: version 0.00 ALPHA (dynamic channels, m=
ax=3D256)
[    3.550949] DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
[    3.552870] LAPB Ethernet driver version 0.02
[    3.554290] VMware vmxnet3 virtual NIC driver - version 1.2.0.0-k-NAPI
[    3.556921] usbcore: registered new interface driver kaweth
[    3.558813] usbcore: registered new interface driver rtl8150
[    3.562413] usbcore: registered new interface driver hwa-rc
[    3.564412] usbcore: registered new interface driver i1480-dfu-usb
[    3.566439] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.568281] ehci-pci: EHCI PCI platform driver
[    3.578198] ehci-platform: EHCI generic platform driver
[    3.581185] driver u132_hcd
[    3.583485] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    3.586356] usbcore: registered new interface driver cdc_acm
[    3.588015] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    3.591329] usbcore: registered new interface driver usbserial
[    3.593283] usbcore: registered new interface driver usbserial_generic
[    3.595405] usbserial: USB Serial support registered for generic
[    3.597434] usbcore: registered new interface driver aircable
[    3.599376] usbserial: USB Serial support registered for aircable
[    3.601406] usbcore: registered new interface driver ark3116
[    3.603389] usbserial: USB Serial support registered for ark3116
[    3.606411] usbcore: registered new interface driver belkin_sa
[    3.608360] usbserial: USB Serial support registered for Belkin / Peraco=
m / GoHubs USB Serial Adapter
[    3.611584] usbcore: registered new interface driver cyberjack
[    3.613559] usbserial: USB Serial support registered for Reiner SCT Cybe=
rjack USB card reader
[    3.616566] usbcore: registered new interface driver cypress_m8
[    3.618491] usbserial: USB Serial support registered for DeLorme Earthma=
te USB
[    3.621268] usbserial: USB Serial support registered for HID->COM RS232 =
Adapter
[    3.624006] usbserial: USB Serial support registered for Nokia CA-42 V2 =
Adapter
[    3.626885] usbcore: registered new interface driver usb_debug
[    3.628966] usbserial: USB Serial support registered for debug
[    3.631022] usbcore: registered new interface driver io_ti
[    3.632902] usbserial: USB Serial support registered for Edgeport TI 1 p=
ort adapter
[    3.635800] usbserial: USB Serial support registered for Edgeport TI 2 p=
ort adapter
[    3.638550] usbcore: registered new interface driver empeg
[    3.644709] usbserial: USB Serial support registered for empeg
[    3.646805] usbcore: registered new interface driver ftdi_sio
[    3.648833] usbserial: USB Serial support registered for FTDI USB Serial=
 Device
[    3.651700] usbcore: registered new interface driver ipw
[    3.653621] usbserial: USB Serial support registered for IPWireless conv=
erter
[    3.655933] usbcore: registered new interface driver keyspan
[    3.657973] usbserial: USB Serial support registered for Keyspan - (with=
out firmware)
[    3.660903] usbserial: USB Serial support registered for Keyspan 1 port =
adapter
[    3.663708] usbserial: USB Serial support registered for Keyspan 2 port =
adapter
[    3.666602] usbserial: USB Serial support registered for Keyspan 4 port =
adapter
[    3.669383] usbcore: registered new interface driver keyspan_pda
[    3.671486] usbserial: USB Serial support registered for Keyspan PDA
[    3.673714] usbserial: USB Serial support registered for Keyspan PDA - (=
prerenumeration)
[    3.676699] usbserial: USB Serial support registered for Xircom / Entreg=
ra PGS - (prerenumeration)
[    3.679906] usbcore: registered new interface driver kobil_sct
[    3.681910] usbserial: USB Serial support registered for KOBIL USB smart=
 card terminal
[    3.684892] usbcore: registered new interface driver mos7840
[    3.686862] usbserial: USB Serial support registered for Moschip 7840/78=
20 USB Serial Driver
[    3.689927] usbcore: registered new interface driver option
[    3.692002] usbserial: USB Serial support registered for GSM modem (1-po=
rt)
[    3.694275] usbcore: registered new interface driver oti6858
[    3.696233] usbserial: USB Serial support registered for oti6858
[    3.698188] usbcore: registered new interface driver spcp8x5
[    3.700197] usbserial: USB Serial support registered for SPCP8x5
[    3.702140] usbcore: registered new interface driver ssu100
[    3.704133] usbserial: USB Serial support registered for Quatech SSU-100=
 USB to Serial Driver
[    3.707110] usbcore: registered new interface driver visor
[    3.709162] usbserial: USB Serial support registered for Handspring Viso=
r / Palm OS
[    3.712032] usbserial: USB Serial support registered for Sony Clie 5.0
[    3.714092] usbserial: USB Serial support registered for Sony Clie 3.5
[    3.716252] usbcore: registered new interface driver xsens_mt
[    3.718306] usbserial: USB Serial support registered for xsens_mt
[    3.720394] usbcore: registered new interface driver adutux
[    3.722473] usbcore: registered new interface driver cypress_cy7c63
[    3.724743] usbcore: registered new interface driver cytherm
[    3.726238] driver ftdi-elan
[    3.728555] usbcore: registered new interface driver ftdi-elan
[    3.730646] usbcore: registered new interface driver isight_firmware
[    3.732841] usbcore: registered new interface driver usblcd
[    3.734884] usbcore: registered new interface driver legousbtower
[    3.736779] usbcore: registered new interface driver usbsevseg
[    3.739774] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    3.745595] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.748168] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.754084] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    3.760394] usbcore: registered new interface driver appletouch
[    3.763658] mk712: device not present
[    3.765713] usbcore: registered new interface driver sur40
[    3.778354] rtc-test rtc-test.0: rtc core: registered test as rtc0
[    3.782304] rtc-test rtc-test.1: rtc core: registered test as rtc1
[    3.784902] i2c /dev entries driver
[    3.788814] i2c-parport: adapter type unspecified
[    3.790433] i2c-parport-light: adapter type unspecified
[    3.792371] usbcore: registered new interface driver i2c-tiny-usb
[    3.794266] pps_ldisc: PPS line discipline registered
[    3.796400] Driver for 1-wire Dallas network protocol.
[    3.807184] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver v0.05
[    3.810189] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[    3.814412] it87_wdt: no device
[    3.815622] pc87413_wdt: Version 1.1 at io 0x2E
[    3.817063] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    3.819002] sbc60xxwdt: I/O address 0x0443 already in use
[    3.820738] sbc8360: failed to register misc device
[    3.822324] cpu5wdt: misc_register failed
[    3.823865] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[    3.827557] smsc37b787_wdt: Unable to register miscdev on minor 130
[    3.829889] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    3.831681] wbsd: Copyright(c) Pierre Ossman
[    3.834125] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0400
[    3.836875] usbcore: registered new interface driver vub300
[    3.839586] usbcore: registered new interface driver ushc
[    3.844059] ledtrig-cpu: registered to indicate activity on CPUs
[    3.850360] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    3.853513] hidraw: raw HID events driver (C) Jiri Kosina
[    3.862414] hdaps: supported laptop not found!
[    3.863983] hdaps: driver init failed (ret=3D-19)!
[    3.868975]  fake-fmc-carrier: mezzanine 0
[    3.870431]       Manufacturer: fake-vendor
[    3.871884]       Product name: fake-design-for-testing
[    3.874243] pktgen: Packet Generator for packet performance testing. Ver=
sion: 2.74
[    3.919071] GACT probability NOT on
[    3.920566] Simple TC action Loaded
[    3.924034] u32 classifier
[    3.925230]     Actions configured
[    3.926568] ipip: IPv4 over IPv4 tunneling driver
[    3.931973] gre: GRE over IPv4 demultiplexor driver
[    3.933576] TCP: bic registered
[    3.935733] TCP: illinois registered
[    3.937017] NET: Registered protocol family 17
[    3.938756] NET: Registered protocol family 5
[    3.940529] NET: Registered protocol family 9
[    3.942051] X25: Linux Version 0.2
[    3.947292] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[    3.954810] DECnet: Routing cache hash table of 1024 buckets, 8Kbytes
[    3.959059] NET: Registered protocol family 12
[    3.960695] tipc: Activated (version 2.0.0)
[    3.966946] NET: Registered protocol family 30
[    3.973897] tipc: Started in single node mode
[    3.975406] 9pnet: Installing 9P2000 support
[    3.981199] NET: Registered protocol family 36
[    3.982741] Key type dns_resolver registered
[    3.985890] batman_adv: B.A.T.M.A.N. advanced 2014.1.0 (compatibility ve=
rsion 15) loaded
[    3.988519] mpls_gso: MPLS GSO support
[    3.994593]=20
[    3.994593] printing PIC contents
[    3.996623] ... PIC  IMR: ffff
[    3.997779] ... PIC  IRR: 1013
[    3.998805] ... PIC  ISR: 0000
[    4.000038] ... PIC ELCR: 0c00
[    4.001219] printing local APIC contents on CPU#0/0:
[    4.002757] ... APIC ID:      00000000 (0)
[    4.004078] ... APIC VERSION: 00050014
[    4.005336] ... APIC TASKPRI: 00000000 (00)
[    4.006757] ... APIC PROCPRI: 00000000
[    4.008053] ... APIC LDR: 01000000
[    4.009332] ... APIC DFR: ffffffff
[    4.010515] ... APIC SPIV: 000001ff
[    4.011197] ... APIC ISR field:
[    4.011197] 000000000000000000000000000000000000000000000000000000000000=
0000
[    4.011197] ... APIC TMR field:
[    4.011197] 000000000200000000000000000000000000000000000000000000000000=
0000
[    4.011197] ... APIC IRR field:
[    4.011197] 000000000000000000000000000000000000000000000000000000000000=
8000
[    4.011197] ... APIC ESR: 00000000
[    4.011197] ... APIC ICR: 000008fd
[    4.011197] ... APIC ICR2: 02000000
[    4.011197] ... APIC LVTT: 000200ef
[    4.011197] ... APIC LVTPC: 00010000
[    4.011197] ... APIC LVT0: 00010700
[    4.011197] ... APIC LVT1: 00000400
[    4.011197] ... APIC LVTERR: 000000fe
[    4.011197] ... APIC TMICT: 000989d0
[    4.011197] ... APIC TMCCT: 00055195
[    4.011197] ... APIC TDCR: 00000003
[    4.011197]=20
[    4.069078] number of MP IRQ sources: 15.
[    4.070340] number of IO-APIC #0 registers: 24.
[    4.071657] testing the IO APIC.......................
[    4.073121] IO APIC #0......
[    4.074202] .... register #00: 00000000
[    4.075517] .......    : physical APIC id: 00
[    4.076973] .......    : Delivery Type: 0
[    4.078295] .......    : LTS          : 0
[    4.079680] .... register #01: 00170011
[    4.081060] .......     : max redirection entries: 17
[    4.082640] .......     : PRQ implemented: 0
[    4.084038] .......     : IO APIC version: 11
[    4.085469] .... register #02: 00000000
[    4.086829] .......     : arbitration: 00
[    4.088217] .... IRQ redirection table:
[    4.089607] 1    0    0   0   0    0    0    00
[    4.091103] 0    0    0   0   0    1    1    31
[    4.092622] 0    0    0   0   0    1    1    30
[    4.094032] 0    0    0   0   0    1    1    33
[    4.095494] 1    0    0   0   0    1    1    34
[    4.097026] 1    1    0   0   0    1    1    35
[    4.098472] 0    0    0   0   0    1    1    36
[    4.099961] 0    0    0   0   0    1    1    37
[    4.101413] 0    0    0   0   0    1    1    38
[    4.102890] 0    1    0   0   0    1    1    39
[    4.104415] 1    1    0   0   0    1    1    3A
[    4.105934] 1    1    0   0   0    1    1    3B
[    4.111671] 0    0    0   0   0    1    1    3C
[    4.113132] 0    0    0   0   0    1    1    3D
[    4.114640] 0    0    0   0   0    1    1    3E
[    4.116129] 0    0    0   0   0    1    1    3F
[    4.117568] 1    0    0   0   0    0    0    00
[    4.119043] 1    0    0   0   0    0    0    00
[    4.120525] 1    0    0   0   0    0    0    00
[    4.121982] 1    0    0   0   0    0    0    00
[    4.123476] 1    0    0   0   0    0    0    00
[    4.125046] 1    0    0   0   0    0    0    00
[    4.126437] 1    0    0   0   0    0    0    00
[    4.127848] 1    0    0   0   0    0    0    00
[    4.129371] IRQ to pin mappings:
[    4.130614] IRQ0 -> 0:2
[    4.131851] IRQ1 -> 0:1
[    4.133127] IRQ3 -> 0:3
[    4.134419] IRQ4 -> 0:4
[    4.135676] IRQ5 -> 0:5
[    4.136994] IRQ6 -> 0:6
[    4.138336] IRQ7 -> 0:7
[    4.139683] IRQ8 -> 0:8
[    4.141063] IRQ9 -> 0:9
[    4.142410] IRQ10 -> 0:10
[    4.143783] IRQ11 -> 0:11
[    4.145154] IRQ12 -> 0:12
[    4.146417] IRQ13 -> 0:13
[    4.147709] IRQ14 -> 0:14
[    4.149054] IRQ15 -> 0:15
[    4.150389] .................................... done.
[    4.151953] Using IPI No-Shortcut mode
[    4.162517] Freeing unused kernel memory: 580K (c1c49000 - c1cda000)
[    4.164485] Write protecting the kernel text: 9076k
[    4.166234] Write protecting the kernel read-only data: 2904k
[    4.167832] NX-protecting the kernel data: 5260k
[    4.169996] BUG: using __this_cpu_add() in preemptible [00000000] code: =
init/1
[    4.172629] caller is __this_cpu_preempt_check+0x2d/0x40
[    4.174259] CPU: 1 PID: 1 Comm: init Not tainted 3.14.0-rc5-next-2014030=
6-06952-g0ffb2fe #3
[    4.177120] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.178635]  00000000 00000000 cf477d3c c18d4eeb 00000001 cf477d60 c12e8=
0b9 c1ace2c8
[    4.182201]  cf477d78 00000000 cf4782a4 00000001 cf477d78 cfc455c0 cf477=
da4 c12e810d
[    4.186749]  cf477d78 00000028 c1acdb6d c1b42ef1 68745f5f 635f7369 615f7=
570 29286464
[    4.190306] Call Trace:
[    4.191374]  [<c18d4eeb>] dump_stack+0x4b/0x75
[    4.192838]  [<c12e80b9>] check_preemption_disabled+0xc9/0xe0
[    4.194598]  [<c12e810d>] __this_cpu_preempt_check+0x2d/0x40
[    4.196363]  [<c10f7343>] ? __split_vma.isra.29+0x23/0x150
[    4.197913]  [<c18d4579>] __slab_free+0x1e/0x43c
[    4.199341]  [<c10f6825>] ? __remove_shared_vm_struct+0x35/0x50
[    4.201173]  [<c10f03b0>] ? free_pgtables+0x80/0xb0
[    4.202712]  [<c1068ecb>] ? get_parent_ip+0xb/0x40
[    4.204237]  [<c1068fff>] ? preempt_count_sub+0x5f/0xe0
[    4.205809]  [<c1104c08>] kmem_cache_free+0x138/0x190
[    4.207394]  [<c10f66c5>] ? remove_vma+0x45/0x50
[    4.208936]  [<c10f66c5>] ? remove_vma+0x45/0x50
[    4.210450]  [<c10f66c5>] remove_vma+0x45/0x50
[    4.212026]  [<c10f8225>] do_munmap+0x1f5/0x2a0
[    4.213596]  [<c10f8302>] vm_munmap+0x32/0x50
[    4.215039]  [<c1153772>] load_elf_binary+0x10c2/0x11d0
[    4.216750]  [<c1068fff>] ? preempt_count_sub+0x5f/0xe0
[    4.218388]  [<c11132c2>] search_binary_handler+0x62/0x170
[    4.220182]  [<c105a15e>] ? __task_pid_nr_ns+0x5e/0xa0
[    4.221864]  [<c11145d8>] do_execve+0x418/0x570
[    4.223313]  [<c100036c>] run_init_process+0x1c/0x20
[    4.224943]  [<c18ce7d7>] kernel_init+0x37/0xe0
[    4.226498]  [<c18dba37>] ret_from_kernel_thread+0x1b/0x28
[    4.228310]  [<c18ce7a0>] ? rest_init+0x70/0x70
[    4.229947] BUG: using __this_cpu_add() in preemptible [00000000] code: =
init/1
[    4.232435] caller is __this_cpu_preempt_check+0x2d/0x40
[    4.234102] CPU: 1 PID: 1 Comm: init Not tainted 3.14.0-rc5-next-2014030=
6-06952-g0ffb2fe #3
[    4.236828] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.238414]  00000000 00000000 cf477d9c c18d4eeb 00000001 cf477dc0 c12e8=
0b9 c1ace2c8
[    4.241970]  cf477dd8 00000000 cf4782a4 00000001 cf477dd8 cfc54a00 cf477=
e04 c12e810d
[    4.245564]  cf477dd8 00000028 c1acdb6d c1b42ef1 68745f5f 635f7369 615f7=
570 29286464
[    4.249245] Call Trace:
[    4.250317]  [<c18d4eeb>] dump_stack+0x4b/0x75
[    4.251797]  [<c12e80b9>] check_preemption_disabled+0xc9/0xe0
[    4.253561]  [<c12e810d>] __this_cpu_preempt_check+0x2d/0x40
[    4.255299]  [<c12e810d>] ? __this_cpu_preempt_check+0x2d/0x40
[    4.257034]  [<c18d4579>] __slab_free+0x1e/0x43c
[    4.258444]  [<c10347f0>] ? kvm_disable_steal_time.part.13+0x20/0x20
[    4.260391]  [<c1037118>] ? do_page_fault+0x8/0x10
[    4.261959]  [<c1034811>] ? do_async_page_fault+0x21/0x60
[    4.263585]  [<c1068ecb>] ? get_parent_ip+0xb/0x40
[    4.265189]  [<c1068fff>] ? preempt_count_sub+0x5f/0xe0
[    4.266817]  [<c1104dea>] kfree+0x15a/0x190
[    4.268242]  [<c1153549>] ? load_elf_binary+0xe99/0x11d0
[    4.269993]  [<c1153549>] ? load_elf_binary+0xe99/0x11d0
[    4.271707]  [<c1153549>] load_elf_binary+0xe99/0x11d0
[    4.273265]  [<c1068fff>] ? preempt_count_sub+0x5f/0xe0
[    4.274921]  [<c11132c2>] search_binary_handler+0x62/0x170
[    4.276654]  [<c105a15e>] ? __task_pid_nr_ns+0x5e/0xa0
[    4.278321]  [<c11145d8>] do_execve+0x418/0x570
[    4.279882]  [<c100036c>] run_init_process+0x1c/0x20
[    4.281458]  [<c18ce7d7>] kernel_init+0x37/0xe0
[    4.282955]  [<c18dba37>] ret_from_kernel_thread+0x1b/0x28
[    4.284704]  [<c18ce7a0>] ? rest_init+0x70/0x70
[    4.286262] BUG: using __this_cpu_add() in preemptible [00000000] code: =
init/1
[    4.288681] caller is __this_cpu_preempt_check+0x2d/0x40
[    4.290412] CPU: 1 PID: 1 Comm: init Not tainted 3.14.0-rc5-next-2014030=
6-06952-g0ffb2fe #3
[    4.293120] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.294940]  00000000 00000000 cf477d9c c18d4eeb 00000001 cf477dc0 c12e8=
0b9 c1ace2c8
[    4.298548]  cf477dd8 00000000 cf4782a4 00000001 cf477dd8 cfc454e0 cf477=
e04 c12e810d
[    4.302177]  cf477dd8 00000028 c1acdb6d c1b42ef1 68745f5f 635f7369 615f7=
570 29286464
[    4.306013] Call Trace:
[    4.307049]  [<c18d4eeb>] dump_stack+0x4b/0x75
[    4.308526]  [<c12e80b9>] check_preemption_disabled+0xc9/0xe0
[    4.310343]  [<c12e810d>] __this_cpu_preempt_check+0x2d/0x40
[    4.312058]  [<c1068fff>] ? preempt_count_sub+0x5f/0xe0
[    4.313746]  [<c18d4579>] __slab_free+0x1e/0x43c
[    4.315306]  [<c1153549>] ? load_elf_binary+0xe99/0x11d0
[    4.316957]  [<c10347f0>] ? kvm_disable_steal_time.part.13+0x20/0x20
[    4.318827]  [<c1034811>] ? do_async_page_fault+0x21/0x60
[    4.320640]  [<c1068ecb>] ? get_parent_ip+0xb/0x40
[    4.322269]  [<c1068fff>] ? preempt_count_sub+0x5f/0xe0
[    4.323954]  [<c1104dea>] kfree+0x15a/0x190
[    4.326424]  [<c1153588>] ? load_elf_binary+0xed8/0x11d0
[    4.328031]  [<c1153588>] ? load_elf_binary+0xed8/0x11d0
[    4.329718]  [<c1153588>] load_elf_binary+0xed8/0x11d0
[    4.331249]  [<c1068fff>] ? preempt_count_sub+0x5f/0xe0
[    4.332860]  [<c11132c2>] search_binary_handler+0x62/0x170
[    4.334529]  [<c105a15e>] ? __task_pid_nr_ns+0x5e/0xa0
[    4.336188]  [<c11145d8>] do_execve+0x418/0x570
[    4.337686]  [<c100036c>] run_init_process+0x1c/0x20
[    4.339262]  [<c18ce7d7>] kernel_init+0x37/0xe0
[    4.340824]  [<c18dba37>] ret_from_kernel_thread+0x1b/0x28
[    4.342517]  [<c18ce7a0>] ? rest_init+0x70/0x70
[    4.344171] BUG: using __this_cpu_add() in preemptible [00000000] code: =
init/1
[    4.346828] caller is __this_cpu_preempt_check+0x2d/0x40
[    4.348496] CPU: 1 PID: 1 Comm: init Not tainted 3.14.0-rc5-next-2014030=
6-06952-g0ffb2fe #3
[    4.351114] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.352856]  00000000 00000000 cf477d9c c18d4eeb 00000001 cf477dc0 c12e8=
0b9 c1ace2c8
[    4.356300]  cf477dd8 00000000 cf4782a4 00000001 cf477dd8 cfabf440 cf477=
e04 c12e810d
[    4.359768]  cf477dd8 00000028 c1acdb6d c1b42ef1 68745f5f 635f7369 615f7=
570 29286464
[    4.363327] Call Trace:
[    4.364426]  [<c18d4eeb>] dump_stack+0x4b/0x75
[    4.365874]  [<c12e80b9>] check_preemption_disabled+0xc9/0xe0
[    4.367642]  [<c12e810d>] __this_cpu_preempt_check+0x2d/0x40
[    4.369399]  [<c1068fff>] ? preempt_count_sub+0x5f/0xe0
[    4.371063]  [<c18d4579>] __slab_free+0x1e/0x43c
[    4.372588]  [<c1153588>] ? load_elf_binary+0xed8/0x11d0
[    4.374228]  [<c10347f0>] ? kvm_disable_steal_time.part.13+0x20/0x20
[    4.376179]  [<c1034811>] ? do_async_page_fault+0x21/0x60
[    4.377833]  [<c1068ecb>] ? get_parent_ip+0xb/0x40
[    4.379356]  [<c1068fff>] ? preempt_count_sub+0x5f/0xe0
[    4.381053]  [<c1104dea>] kfree+0x15a/0x190
[    4.382510]  [<c1152f6d>] ? load_elf_binary+0x8bd/0x11d0
[    4.384120]  [<c1152f6d>] ? load_elf_binary+0x8bd/0x11d0
[    4.385750]  [<c1152f6d>] load_elf_binary+0x8bd/0x11d0
[    4.387388]  [<c1068fff>] ? preempt_count_sub+0x5f/0xe0
[    4.389106]  [<c11132c2>] search_binary_handler+0x62/0x170
[    4.390875]  [<c105a15e>] ? __task_pid_nr_ns+0x5e/0xa0
[    4.392560]  [<c11145d8>] do_execve+0x418/0x570
[    4.394051]  [<c100036c>] run_init_process+0x1c/0x20
[    4.395630]  [<c18ce7d7>] kernel_init+0x37/0xe0
[    4.397169]  [<c18dba37>] ret_from_kernel_thread+0x1b/0x28
[    4.398700]  [<c18ce7a0>] ? rest_init+0x70/0x70
[    4.400291] BUG: using __this_cpu_add() in preemptible [00000000] code: =
init/1
[    4.402744] caller is __this_cpu_preempt_check+0x2d/0x40
[    4.404411] CPU: 1 PID: 1 Comm: init Not tainted 3.14.0-rc5-next-2014030=
6-06952-g0ffb2fe #3
[    4.411244] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.412954]  00000000 00000000 cf477d9c c18d4eeb 00000001 cf477dc0 c12e8=
0b9 c1ace2c8
[    4.416500]  cf477dd8 00000000 cf4782a4 00000001 cf477dd8 cfc54ac0 cf477=
e04 c12e810d
[    4.420049]  cf477dd8 00000028 c1acdb6d c1b42ef1 68745f5f 635f7369 615f7=
570 29286464
[    4.423686] Call Trace:
[    4.424779]  [<c18d4eeb>] dump_stack+0x4b/0x75
[    4.426237]  [<c12e80b9>] check_preemption_disabled+0xc9/0xe0
[    4.427985]  [<c12e810d>] __this_cpu_preempt_check+0x2d/0x40
[    4.429703]  [<c12e810d>] ? __this_cpu_preempt_check+0x2d/0x40
[    4.431275]  [<c18d4579>] __slab_free+0x1e/0x43c
[    4.432738]  [<c1068ecb>] ? get_parent_ip+0xb/0x40
[    4.434259]  [<c1068ecb>] ? get_parent_ip+0xb/0x40
[    4.435808]  [<c1068fff>] ? preempt_count_sub+0x5f/0xe0
[    4.437464]  [<c1104dea>] kfree+0x15a/0x190
[    4.438873]  [<c1152767>] ? load_elf_binary+0xb7/0x11d0
[    4.440547]  [<c1152767>] ? load_elf_binary+0xb7/0x11d0
[    4.442127]  [<c1152767>] load_elf_binary+0xb7/0x11d0
[    4.443635]  [<c11132c2>] search_binary_handler+0x62/0x170
[    4.445285]  [<c105a15e>] ? __task_pid_nr_ns+0x5e/0xa0
[    4.446835]  [<c11145d8>] do_execve+0x418/0x570
[    4.448337]  [<c100036c>] run_init_process+0x1c/0x20
[    4.449953]  [<c18ce7d7>] kernel_init+0x37/0xe0
[    4.451456]  [<c18dba37>] ret_from_kernel_thread+0x1b/0x28
[    4.453178] BUG: using __this_cpu_add() in preemptible [00000000] code: =
init/1
[    4.455574] caller is __this_cpu_preempt_check+0x2d/0x40
[    4.457143] CPU: 0 PID: 1 Comm: init Not tainted 3.14.0-rc5-next-2014030=
6-06952-g0ffb2fe #3
[    4.459762] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.461488]  00000000 00000000 cf477e3c c18d4eeb 00000000 cf477e60 c12e8=
0b9 c1ace2c8
[    4.464903]  cf477e78 00000000 cf4782a4 00000001 cf477e78 cfabf440 cf477=
ea4 c12e810d
[    4.468244]  cf477e78 00000028 c1acdb6d c1b42ef1 68745f5f 635f7369 615f7=
570 29286464
[    4.471677] Call Trace:
[    4.472760]  [<c18d4eeb>] dump_stack+0x4b/0x75
[    4.474211]  [<c12e80b9>] check_preemption_disabled+0xc9/0xe0
[    4.476008]  [<c12e810d>] __this_cpu_preempt_check+0x2d/0x40
[    4.477659]  [<c1152700>] ? load_elf_binary+0x50/0x11d0
[    4.479102]  [<c18d4579>] __slab_free+0x1e/0x43c
[    4.480507]  [<c1068ecb>] ? get_parent_ip+0xb/0x40
[    4.482073]  [<c1068fff>] ? preempt_count_sub+0x5f/0xe0
[    4.483649]  [<c1104dea>] kfree+0x15a/0x190
[    4.485030]  [<c111343a>] ? free_bprm+0x6a/0x70
[    4.486509]  [<c111343a>] ? free_bprm+0x6a/0x70
[    4.487882]  [<c111343a>] free_bprm+0x6a/0x70
[    4.489258]  [<c1114649>] do_execve+0x489/0x570
[    4.490695]  [<c100036c>] run_init_process+0x1c/0x20
[    4.492342]  [<c18ce7d7>] kernel_init+0x37/0xe0
[    4.493916]  [<c18dba37>] ret_from_kernel_thread+0x1b/0x28
[    4.495744] BUG: using __this_cpu_add() in preemptible [00000000] code: =
init/1
[    4.498323] caller is __this_cpu_preempt_check+0x2d/0x40
[    4.499886] CPU: 0 PID: 1 Comm: init Not tainted 3.14.0-rc5-next-2014030=
6-06952-g0ffb2fe #3
[    4.502484] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.504172]  00000000 00000000 cf477e34 c18d4eeb 00000000 cf477e58 c12e8=
0b9 c1ace2c8
[    4.507568]  cf477e70 00000000 cf4782a4 00000001 cf477e70 cfca7000 cf477=
e9c c12e810d
[    4.510857]  cf477e70 00000028 c1acdb6d c1b42ef1 68745f5f 635f7369 615f7=
570 29286464
[    4.514279] Call Trace:
[    4.515344]  [<c18d4eeb>] dump_stack+0x4b/0x75
[    4.516838]  [<c12e80b9>] check_preemption_disabled+0xc9/0xe0
[    4.518498]  [<c12e810d>] __this_cpu_preempt_check+0x2d/0x40
[    4.520174]  [<c1068e00>] ? task_sched_runtime+0xc0/0xc0
[    4.521781]  [<c1068fff>] ? preempt_count_sub+0x5f/0xe0
[    4.523390]  [<c18d4579>] __slab_free+0x1e/0x43c
[    4.524841]  [<c111343a>] ? free_bprm+0x6a/0x70
[    4.526149]  [<c1068ecb>] ? get_parent_ip+0xb/0x40
[    4.527657]  [<c1068fff>] ? preempt_count_sub+0x5f/0xe0
[    4.529230]  [<c1104c08>] kmem_cache_free+0x138/0x190
[    4.530654]  [<c11175e8>] ? final_putname+0x18/0x40
[    4.532165]  [<c11175e8>] ? final_putname+0x18/0x40
[    4.533640]  [<c11175e8>] final_putname+0x18/0x40
[    4.535011]  [<c11177ef>] putname+0x1f/0x40
[    4.536347]  [<c1114650>] do_execve+0x490/0x570
[    4.537723]  [<c100036c>] run_init_process+0x1c/0x20
[    4.539257]  [<c18ce7d7>] kernel_init+0x37/0xe0
[    4.540657]  [<c18dba37>] ret_from_kernel_thread+0x1b/0x28
[    4.542620] BUG: using __this_cpu_add() in preemptible [00000000] code: =
init/1
[    4.546028] caller is __this_cpu_preempt_check+0x2d/0x40
[    4.547553] CPU: 0 PID: 1 Comm: init Not tainted 3.14.0-rc5-next-2014030=
6-06952-g0ffb2fe #3
[    4.550218] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.551989]  00000000 00000000 cf477db4 c18d4eeb 00000000 cf477dd8 c12e8=
0b9 c1ace2c8
[    4.555367]  cf477df0 00000000 cf4782a4 00000001 cf477df0 cfca7000 cf477=
e1c c12e810d
[    4.558701]  cf477df0 00000028 c1acdb6d c1b42ef1 68745f5f 635f7369 615f7=
570 29286464
[    4.562077] Call Trace:
[    4.563129]  [<c18d4eeb>] dump_stack+0x4b/0x75
[    4.564577]  [<c12e80b9>] check_preemption_disabled+0xc9/0xe0
[    4.566322]  [<c12e810d>] __this_cpu_preempt_check+0x2d/0x40
[    4.567991]  [<c1068ecb>] ? get_parent_ip+0xb/0x40
[    4.569567]  [<c18d4579>] __slab_free+0x1e/0x43c
[    4.571070]  [<c1068ecb>] ? get_parent_ip+0xb/0x40
[    4.572719]  [<c1068fff>] ? preempt_count_sub+0x5f/0xe0
[    4.574262]  [<c18da9c0>] ? _raw_spin_unlock+0x10/0x30
[    4.575825]  [<c1127d61>] ? mntput_no_expire+0x21/0x140
[    4.577450]  [<c1127e98>] ? mntput+0x18/0x30
[    4.578880]  [<c1068ecb>] ? get_parent_ip+0xb/0x40
[    4.580382]  [<c1068fff>] ? preempt_count_sub+0x5f/0xe0
[    4.581942]  [<c1104c08>] kmem_cache_free+0x138/0x190
[    4.583529]  [<c11175e8>] ? final_putname+0x18/0x40
[    4.585155]  [<c11175e8>] ? final_putname+0x18/0x40
[    4.586597]  [<c11175e8>] final_putname+0x18/0x40
[    4.587901]  [<c11177ef>] putname+0x1f/0x40
[    4.589214]  [<c111ba44>] user_path_at_empty+0x44/0x70
[    4.590743]  [<c1104872>] ? kmem_cache_alloc+0x162/0x1a0
[    4.592354]  [<c1061194>] ? prepare_creds+0x14/0xf0
[    4.593830]  [<c111ba8a>] user_path_at+0x1a/0x20
[    4.595269]  [<c110d44a>] SyS_faccessat+0x9a/0x1e0
[    4.596731]  [<c10f77f0>] ? SyS_mmap_pgoff+0xc0/0xe0
[    4.598199]  [<c110d5b0>] SyS_access+0x20/0x30
[    4.599593]  [<c18db13c>] syscall_call+0x7/0xb
[    4.601045] BUG: using __this_cpu_add() in preemptible [00000000] code: =
init/1
[    4.603497] caller is __this_cpu_preempt_check+0x2d/0x40
[    4.605070] CPU: 0 PID: 1 Comm: init Not tainted 3.14.0-rc5-next-2014030=
6-06952-g0ffb2fe #3
[    4.607626] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.609238]  00000000 00000000 cf477e44 c18d4eeb 00000000 cf477e68 c12e8=
0b9 c1ace2c8
[    4.612587]  cf477e80 00000000 cf4782a4 00000001 cf477e80 cfca7000 cf477=
eac c12e810d
[    4.615907]  cf477e80 00000028 c1acdb6d c1b42ef1 68745f5f 635f7369 615f7=
570 29286464
[    4.619220] Call Trace:
[    4.620242]  [<c18d4eeb>] dump_stack+0x4b/0x75
[    4.621683]  [<c12e80b9>] check_preemption_disabled+0xc9/0xe0
[    4.623334]  [<c12e810d>] __this_cpu_preempt_check+0x2d/0x40
[    4.624975]  [<c111a7cb>] ? path_openat+0xab/0x5e0
[    4.626480]  [<c18d4579>] __slab_free+0x1e/0x43c
[    4.628219]  [<c111ba44>] ? user_path_at_empty+0x44/0x70
[    4.629994]  [<c111bb0c>] ? do_filp_open+0x2c/0x70
[    4.631653]  [<c1068ecb>] ? get_parent_ip+0xb/0x40
[    4.633341]  [<c1068fff>] ? preempt_count_sub+0x5f/0xe0
[    4.635185]  [<c1068ecb>] ? get_parent_ip+0xb/0x40
[    4.636913]  [<c1104c08>] kmem_cache_free+0x138/0x190
[    4.638510]  [<c11175e8>] ? final_putname+0x18/0x40
[    4.640015]  [<c11175e8>] ? final_putname+0x18/0x40
[    4.641481]  [<c11175e8>] final_putname+0x18/0x40
[    4.643106]  [<c11177ef>] putname+0x1f/0x40
[    4.644553]  [<c110ddef>] do_sys_open+0x18f/0x210
[    4.646020]  [<c10f0000>] ? __tlb_remove_page+0x10/0x80
[    4.647777]  [<c110de8d>] SyS_open+0x1d/0x20
[    4.649260]  [<c18db13c>] syscall_call+0x7/0xb
Kernel tests: Boot OK!
[    6.511025] random: trinity urandom read with 0 bits of entropy available

Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-x=
0-03070431/0ffb2fe7b9c30082876fa3a17da018bf0632cf03/vmlinuz-3.14.0-rc5-next=
-20140306-06952-g0ffb2fe -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,1=
15200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-x0-03070431/next:master/.vmlinuz-0ffb2fe7b9c30082876fa3a=
17da018bf0632cf03-20140307044438-9-xian branch=3Dnext/master BOOT_IMAGE=3D/=
kernel/i386-randconfig-x0-03070431/0ffb2fe7b9c30082876fa3a17da018bf0632cf03=
/vmlinuz-3.14.0-rc5-next-20140306-06952-g0ffb2fe'  -initrd /kernel-tests/in=
itrd/yocto-minimal-i386.cgz -m 256 -smp 2 -net nic,vlan=3D1,model=3De1000 -=
net user,vlan=3D1,hostfwd=3Dtcp::33847-:22 -boot order=3Dnc -no-reboot -wat=
chdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs/LABEL=3DKVM/disk0-yo=
cto-xian-35,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1-yo=
cto-xian-35,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk2-yo=
cto-xian-35,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-yo=
cto-xian-35,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk4-yo=
cto-xian-35,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk5-yo=
cto-xian-35,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-yocto-xian=
-35 -serial file:/dev/shm/kboot/serial-yocto-xian-35 -daemonize -display no=
ne -monitor null=20

--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc5-next-20140306-06952-g0ffb2fe"

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
CONFIG_NEED_DMA_MAP_STATE=y
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
# CONFIG_KERNEL_LZO is not set
CONFIG_KERNEL_LZ4=y
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_FHANDLE=y
CONFIG_USELIB=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
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
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
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
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_BOOST is not set
CONFIG_RCU_NOCB_CPU=y
CONFIG_RCU_NOCB_CPU_NONE=y
# CONFIG_RCU_NOCB_CPU_ZERO is not set
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_CGROUPS is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
# CONFIG_SCHED_AUTOGROUP is not set
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
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
CONFIG_SYSFS_SYSCALL=y
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
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_SLUB_CPU_PARTIAL=y
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
CONFIG_JUMP_LABEL=y
CONFIG_UPROBES=y
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
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
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
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_ASN1=m
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_BIGSMP is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_CE is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_32_NON_STANDARD is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
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
CONFIG_MVIAC7=y
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
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
CONFIG_X86_ANCIENT_MCE=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_VM86=y
CONFIG_TOSHIBA=y
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
CONFIG_PAGE_OFFSET=0xC0000000
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
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
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
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
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
CONFIG_INTEL_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
CONFIG_PCI_GODIRECT=y
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_DIRECT=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=m
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
CONFIG_GEOS=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=m
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
# CONFIG_RAPIDIO_DMA_ENGINE is not set
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_ENUM_BASIC=m

#
# RapidIO Switch drivers
#
# CONFIG_RAPIDIO_TSI57X is not set
CONFIG_RAPIDIO_CPS_XX=m
CONFIG_RAPIDIO_TSI568=m
# CONFIG_RAPIDIO_CPS_GEN2 is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_IOSF_MBI=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
# CONFIG_IP_MULTIPLE_TABLES is not set
# CONFIG_IP_ROUTE_MULTIPATH is not set
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
CONFIG_NET_IPGRE=m
# CONFIG_SYN_COOKIES is not set
CONFIG_NET_IPVTI=m
CONFIG_INET_AH=y
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=m
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
# CONFIG_TCP_CONG_CUBIC is not set
CONFIG_TCP_CONG_WESTWOOD=m
# CONFIG_TCP_CONG_HTCP is not set
CONFIG_TCP_CONG_HSTCP=m
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
# CONFIG_TCP_CONG_YEAH is not set
CONFIG_TCP_CONG_ILLINOIS=y
CONFIG_DEFAULT_BIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="bic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
# CONFIG_IP_DCCP_CCID3 is not set

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
# CONFIG_SCTP_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_RDS=m
CONFIG_RDS_RDMA=m
CONFIG_RDS_TCP=m
# CONFIG_RDS_DEBUG is not set
CONFIG_TIPC=y
CONFIG_TIPC_PORTS=8191
CONFIG_TIPC_MEDIA_IB=y
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_IPDDP=y
# CONFIG_IPDDP_ENCAP is not set
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_PHONET=m
CONFIG_IEEE802154=y
CONFIG_6LOWPAN_IPHC=m
# CONFIG_MAC802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=y
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
# CONFIG_NET_SCH_NETEM is not set
CONFIG_NET_SCH_DRR=y
# CONFIG_NET_SCH_MQPRIO is not set
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=m
# CONFIG_NET_SCH_FQ_CODEL is not set
CONFIG_NET_SCH_FQ=y
CONFIG_NET_SCH_HHF=m
CONFIG_NET_SCH_PIE=y
CONFIG_NET_SCH_INGRESS=y
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=y
# CONFIG_CLS_U32_PERF is not set
CONFIG_CLS_U32_MARK=y
# CONFIG_NET_CLS_RSVP is not set
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=y
# CONFIG_NET_CLS_BPF is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=y
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=y
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=y
# CONFIG_GACT_PROB is not set
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_NAT=y
CONFIG_NET_ACT_PEDIT=y
CONFIG_NET_ACT_SIMP=y
CONFIG_NET_ACT_SKBEDIT=m
# CONFIG_NET_ACT_CSUM is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_BLA is not set
CONFIG_BATMAN_ADV_DAT=y
CONFIG_BATMAN_ADV_NC=y
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=m
# CONFIG_OPENVSWITCH_GRE is not set
CONFIG_VSOCKETS=y
# CONFIG_VMWARE_VMCI_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
CONFIG_NET_MPLS_GSO=y
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
CONFIG_NET_DROP_MONITOR=m
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
CONFIG_IRCOMM=m
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
# CONFIG_KSDAZZLE_DONGLE is not set
# CONFIG_KS959_DONGLE is not set

#
# FIR device drivers
#
CONFIG_USB_IRDA=m
# CONFIG_SIGMATEL_FIR is not set
# CONFIG_NSC_FIR is not set
CONFIG_WINBOND_FIR=m
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=y
CONFIG_ALI_FIR=y
CONFIG_VLSI_FIR=m
# CONFIG_VIA_FIR is not set
CONFIG_MCS_FIR=m
CONFIG_BT=m
# CONFIG_BT_RFCOMM is not set
# CONFIG_BT_BNEP is not set
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
# CONFIG_BT_HCIUART_H4 is not set
CONFIG_BT_HCIUART_BCSP=y
# CONFIG_BT_HCIUART_ATH3K is not set
# CONFIG_BT_HCIUART_LL is not set
# CONFIG_BT_HCIUART_3WIRE is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIVHCI=m
# CONFIG_BT_MRVL is not set
CONFIG_BT_ATH3K=m
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=m
CONFIG_NL80211_TESTMODE=y
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
# CONFIG_CFG80211_DEFAULT_PS is not set
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
# CONFIG_LIB80211 is not set
# CONFIG_MAC80211 is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
CONFIG_RFKILL_REGULATOR=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=m
CONFIG_NET_9P_RDMA=m
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=m
# CONFIG_CAIF_DEBUG is not set
# CONFIG_CAIF_NETDEV is not set
CONFIG_CAIF_USB=m
# CONFIG_CEPH_LIB is not set
CONFIG_NFC=y
# CONFIG_NFC_DIGITAL is not set
# CONFIG_NFC_NCI is not set
CONFIG_NFC_HCI=m
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_PN533=m
# CONFIG_NFC_MEI_PHY is not set
CONFIG_NFC_SIM=m
# CONFIG_NFC_PN544 is not set
# CONFIG_NFC_MICROREAD is not set

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
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
CONFIG_PARPORT=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT_PC=m
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
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
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_ZRAM is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_OSD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=m
CONFIG_AD525X_DPOT_I2C=m
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=m
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_CS5535_MFGPT=m
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
CONFIG_CS5535_CLOCK_EVENT_SRC=m
CONFIG_HP_ILO=m
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=m
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=m
CONFIG_DS1682=m
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_PCH_PHUB=m
CONFIG_USB_SWITCH_FSA9480=m
CONFIG_SRAM=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
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
CONFIG_INTEL_MEI=y
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_INTEL_MEI_TXE is not set
CONFIG_VMWARE_VMCI=y

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_ECHO=m
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_ENCLOSURE=m
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
CONFIG_ISCSI_BOOT_SYSFS=m
# CONFIG_SCSI_CXGB3_ISCSI is not set
CONFIG_SCSI_CXGB4_ISCSI=y
# CONFIG_SCSI_BNX2_ISCSI is not set
CONFIG_SCSI_BNX2X_FCOE=m
CONFIG_BE2ISCSI=m
CONFIG_BLK_DEV_3W_XXXX_RAID=m
CONFIG_SCSI_HPSA=m
CONFIG_SCSI_3W_9XXX=y
# CONFIG_SCSI_3W_SAS is not set
CONFIG_SCSI_ACARD=y
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC79XX is not set
CONFIG_SCSI_AIC94XX=y
CONFIG_AIC94XX_DEBUG=y
CONFIG_SCSI_MVSAS=m
CONFIG_SCSI_MVSAS_DEBUG=y
CONFIG_SCSI_MVSAS_TASKLET=y
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
CONFIG_SCSI_ADVANSYS=m
# CONFIG_SCSI_ARCMSR is not set
CONFIG_SCSI_ESAS2R=m
CONFIG_MEGARAID_NEWGEN=y
# CONFIG_MEGARAID_MM is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
CONFIG_SCSI_MPT2SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS_LOGGING is not set
CONFIG_SCSI_MPT3SAS=y
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_LOGGING=y
CONFIG_SCSI_UFSHCD=m
# CONFIG_SCSI_UFSHCD_PCI is not set
CONFIG_SCSI_UFSHCD_PLATFORM=m
CONFIG_SCSI_HPTIOP=m
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
CONFIG_FCOE=m
# CONFIG_FCOE_FNIC is not set
CONFIG_SCSI_DMX3191D=y
CONFIG_SCSI_EATA=m
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
# CONFIG_SCSI_EATA_LINKED_COMMANDS is not set
CONFIG_SCSI_EATA_MAX_TAGS=16
# CONFIG_SCSI_FUTURE_DOMAIN is not set
CONFIG_SCSI_GDTH=y
CONFIG_SCSI_ISCI=y
CONFIG_SCSI_IPS=y
# CONFIG_SCSI_INITIO is not set
CONFIG_SCSI_INIA100=m
CONFIG_SCSI_PPA=m
CONFIG_SCSI_IMM=m
CONFIG_SCSI_IZIP_EPP16=y
CONFIG_SCSI_IZIP_SLOW_CTR=y
CONFIG_SCSI_STEX=m
CONFIG_SCSI_SYM53C8XX_2=m
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
CONFIG_SCSI_IPR=y
# CONFIG_SCSI_IPR_TRACE is not set
CONFIG_SCSI_IPR_DUMP=y
CONFIG_SCSI_QLOGIC_1280=m
CONFIG_SCSI_QLA_FC=y
CONFIG_TCM_QLA2XXX=m
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_DC395x=m
CONFIG_SCSI_DC390T=y
CONFIG_SCSI_NSP32=m
# CONFIG_SCSI_DEBUG is not set
CONFIG_SCSI_PMCRAID=m
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
CONFIG_SCSI_BFA_FC=y
CONFIG_SCSI_VIRTIO=m
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
CONFIG_SCSI_DH_HP_SW=m
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
CONFIG_SATA_AHCI=m
# CONFIG_SATA_AHCI_PLATFORM is not set
CONFIG_SATA_INIC162X=m
CONFIG_SATA_ACARD_AHCI=m
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=y
CONFIG_SATA_SX4=m
# CONFIG_ATA_BMDMA is not set

#
# PIO-only SFF controllers
#
CONFIG_PATA_CMD640_PCI=m
CONFIG_PATA_MPIIX=m
CONFIG_PATA_NS87410=y
CONFIG_PATA_OPTI=m
CONFIG_PATA_RZ1000=y

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_LEGACY=m
# CONFIG_MD is not set
CONFIG_TARGET_CORE=m
# CONFIG_TCM_IBLOCK is not set
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_LOOPBACK_TARGET=m
CONFIG_TCM_FC=m
CONFIG_ISCSI_TARGET=m
CONFIG_SBP_TARGET=m
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
CONFIG_FIREWIRE_NOSY=m
CONFIG_I2O=m
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
# CONFIG_I2O_EXT_ADAPTEC_DMA64 is not set
CONFIG_I2O_CONFIG=m
CONFIG_I2O_CONFIG_OLD_IOCTL=y
# CONFIG_I2O_BUS is not set
# CONFIG_I2O_BLOCK is not set
# CONFIG_I2O_SCSI is not set
CONFIG_I2O_PROC=m
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
# CONFIG_NET_CORE is not set
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=m
CONFIG_CAIF_SPI_SLAVE=m
# CONFIG_CAIF_SPI_SYNC is not set
CONFIG_CAIF_HSI=m
CONFIG_CAIF_VIRTIO=m
CONFIG_VHOST_NET=y
CONFIG_VHOST_SCSI=m
CONFIG_VHOST_RING=y
CONFIG_VHOST=y

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
CONFIG_NET_DSA_MV88E6060=y
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_VENDOR_ARC is not set
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
CONFIG_ATL1=m
CONFIG_ATL1E=y
# CONFIG_ATL1C is not set
CONFIG_ALX=m
CONFIG_NET_CADENCE=y
CONFIG_ARM_AT91_ETHER=m
CONFIG_MACB=y
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=y
CONFIG_CNIC=m
CONFIG_TIGON3=y
CONFIG_BNX2X=m
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=m
CONFIG_NET_CALXEDA_XGMAC=m
CONFIG_NET_VENDOR_CHELSIO=y
CONFIG_CHELSIO_T1=y
CONFIG_CHELSIO_T1_1G=y
# CONFIG_CHELSIO_T3 is not set
CONFIG_CHELSIO_T4=y
CONFIG_CHELSIO_T4VF=m
# CONFIG_NET_VENDOR_CISCO is not set
CONFIG_DNET=y
# CONFIG_NET_VENDOR_DEC is not set
# CONFIG_NET_VENDOR_DLINK is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=y
# CONFIG_NET_VENDOR_EXAR is not set
# CONFIG_NET_VENDOR_HP is not set
# CONFIG_NET_VENDOR_INTEL is not set
CONFIG_IP1000=m
CONFIG_JME=y
# CONFIG_NET_VENDOR_MARVELL is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
# CONFIG_MLX5_CORE is not set
# CONFIG_NET_VENDOR_MICREL is not set
CONFIG_NET_VENDOR_MYRI=y
CONFIG_MYRI10GE=y
CONFIG_FEALNX=m
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NVIDIA=y
CONFIG_FORCEDETH=m
CONFIG_NET_VENDOR_OKI=y
CONFIG_PCH_GBE=y
# CONFIG_ETHOC is not set
CONFIG_NET_PACKET_ENGINE=y
CONFIG_HAMACHI=m
CONFIG_YELLOWFIN=m
# CONFIG_NET_VENDOR_QLOGIC is not set
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_ATP=m
# CONFIG_8139CP is not set
CONFIG_8139TOO=m
# CONFIG_8139TOO_PIO is not set
CONFIG_8139TOO_TUNE_TWISTER=y
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=y
CONFIG_SH_ETH=m
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
CONFIG_SC92031=m
# CONFIG_NET_VENDOR_SIS is not set
CONFIG_SFC=m
CONFIG_SFC_MCDI_MON=y
# CONFIG_NET_VENDOR_SMSC is not set
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
CONFIG_NET_VENDOR_VIA=y
CONFIG_VIA_RHINE=m
CONFIG_VIA_RHINE_MMIO=y
# CONFIG_VIA_VELOCITY is not set
# CONFIG_NET_VENDOR_WIZNET is not set
CONFIG_FDDI=y
CONFIG_DEFXX=m
# CONFIG_DEFXX_MMIO is not set
CONFIG_SKFP=m
CONFIG_HIPPI=y
CONFIG_ROADRUNNER=m
CONFIG_ROADRUNNER_LARGE_RINGS=y
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
CONFIG_AMD_PHY=m
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=m
# CONFIG_SMSC_PHY is not set
CONFIG_BROADCOM_PHY=y
# CONFIG_BCM7XXX_PHY is not set
CONFIG_BCM87XX_PHY=y
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
# CONFIG_STE10XP is not set
CONFIG_LSI_ET1011C_PHY=m
# CONFIG_MICREL_PHY is not set
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=m
CONFIG_MDIO_GPIO=m
CONFIG_PLIP=y
# CONFIG_PPP is not set
CONFIG_SLIP=m
CONFIG_SLHC=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=y
CONFIG_USB_RTL8152=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_AX88179_178A=m
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_CDC_EEM=m
CONFIG_USB_NET_CDC_NCM=m
CONFIG_USB_NET_HUAWEI_CDC_NCM=m
# CONFIG_USB_NET_CDC_MBIM is not set
CONFIG_USB_NET_DM9601=m
# CONFIG_USB_NET_SR9700 is not set
# CONFIG_USB_NET_SR9800 is not set
CONFIG_USB_NET_SMSC75XX=m
# CONFIG_USB_NET_SMSC95XX is not set
# CONFIG_USB_NET_GL620A is not set
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
# CONFIG_USB_NET_CDC_SUBSET is not set
CONFIG_USB_NET_ZAURUS=m
CONFIG_USB_NET_CX82310_ETH=m
# CONFIG_USB_NET_KALMIA is not set
CONFIG_USB_NET_QMI_WWAN=m
CONFIG_USB_NET_INT51X1=m
CONFIG_USB_CDC_PHONET=m
# CONFIG_USB_IPHETH is not set
CONFIG_USB_SIERRA_NET=m
# CONFIG_USB_VL600 is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
CONFIG_WAN=y
# CONFIG_HDLC is not set
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
CONFIG_LAPBETHER=y
CONFIG_X25_ASY=y
# CONFIG_SBNI is not set
CONFIG_IEEE802154_DRIVERS=m
CONFIG_IEEE802154_FAKEHARD=m
CONFIG_VMXNET3=y
CONFIG_ISDN=y
CONFIG_ISDN_I4L=m
# CONFIG_ISDN_PPP is not set
CONFIG_ISDN_AUDIO=y
# CONFIG_ISDN_TTY_FAX is not set
# CONFIG_ISDN_X25 is not set

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=m

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=m

#
# D-channel protocol features
#
# CONFIG_HISAX_EURO is not set
CONFIG_HISAX_1TR6=y
# CONFIG_HISAX_NI1 is not set
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
CONFIG_HISAX_16_3=y
CONFIG_HISAX_TELESPCI=y
CONFIG_HISAX_S0BOX=y
# CONFIG_HISAX_FRITZPCI is not set
CONFIG_HISAX_AVM_A1_PCMCIA=y
CONFIG_HISAX_ELSA=y
CONFIG_HISAX_DIEHLDIVA=y
CONFIG_HISAX_SEDLBAUER=y
CONFIG_HISAX_NETJET=y
CONFIG_HISAX_NETJET_U=y
# CONFIG_HISAX_NICCY is not set
CONFIG_HISAX_BKM_A4T=y
# CONFIG_HISAX_SCT_QUADRO is not set
# CONFIG_HISAX_GAZEL is not set
# CONFIG_HISAX_HFC_PCI is not set
# CONFIG_HISAX_W6692 is not set
# CONFIG_HISAX_HFC_SX is not set
CONFIG_HISAX_ENTERNOW_PCI=y
CONFIG_HISAX_DEBUG=y

#
# HiSax PCMCIA card service modules
#

#
# HiSax sub driver modules
#
CONFIG_HISAX_ST5481=m
CONFIG_HISAX_HFCUSB=m
CONFIG_HISAX_HFC4S8S=m
# CONFIG_HISAX_FRITZ_PCIPNP is not set

#
# Active cards
#
# CONFIG_ISDN_CAPI is not set
# CONFIG_ISDN_DRV_GIGASET is not set
CONFIG_HYSDN=m
CONFIG_MISDN=m
# CONFIG_MISDN_DSP is not set
CONFIG_MISDN_L1OIP=m

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=m
# CONFIG_MISDN_HFCMULTI is not set
CONFIG_MISDN_HFCUSB=m
CONFIG_MISDN_AVMFRITZ=m
CONFIG_MISDN_SPEEDFAX=m
CONFIG_MISDN_INFINEON=m
CONFIG_MISDN_W6692=m
# CONFIG_MISDN_NETJET is not set
CONFIG_MISDN_IPAC=m
CONFIG_MISDN_ISAR=m
CONFIG_ISDN_HDLC=m

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
# CONFIG_KEYBOARD_ADP5520 is not set
CONFIG_KEYBOARD_ADP5588=y
CONFIG_KEYBOARD_ADP5589=m
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
CONFIG_KEYBOARD_LKKBD=m
CONFIG_KEYBOARD_GPIO=m
# CONFIG_KEYBOARD_GPIO_POLLED is not set
CONFIG_KEYBOARD_TCA6416=y
# CONFIG_KEYBOARD_TCA8418 is not set
CONFIG_KEYBOARD_MATRIX=y
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_LM8333=m
CONFIG_KEYBOARD_MAX7359=y
CONFIG_KEYBOARD_MCS=m
CONFIG_KEYBOARD_MPR121=y
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_STOWAWAY=m
CONFIG_KEYBOARD_SUNKBD=m
CONFIG_KEYBOARD_STMPE=y
CONFIG_KEYBOARD_TC3589X=m
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=y
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_CYAPA=m
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_MOUSE_GPIO=y
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_AUO_PIXCIR=m
# CONFIG_TOUCHSCREEN_BU21013 is not set
CONFIG_TOUCHSCREEN_CY8CTMG110=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=m
CONFIG_TOUCHSCREEN_CYTTSP_I2C=m
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=m
# CONFIG_TOUCHSCREEN_DA9034 is not set
CONFIG_TOUCHSCREEN_DYNAPRO=m
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=y
CONFIG_TOUCHSCREEN_FUJITSU=m
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_WACOM_W8001=y
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
# CONFIG_TOUCHSCREEN_MAX11801 is not set
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MMS114=m
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=m
CONFIG_TOUCHSCREEN_EDT_FT5X06=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=m
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_WM831X=m
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
# CONFIG_TOUCHSCREEN_MC13783 is not set
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_ELO=y
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_ST1232=m
CONFIG_TOUCHSCREEN_STMPE=y
CONFIG_TOUCHSCREEN_SUR40=y
CONFIG_TOUCHSCREEN_TPS6507X=y
# CONFIG_TOUCHSCREEN_ZFORCE is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
CONFIG_GAMEPORT_EMU10K1=m
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=y
CONFIG_CYZ_INTR=y
# CONFIG_MOXA_INTELLIO is not set
CONFIG_MOXA_SMARTIO=m
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=y
CONFIG_SYNCLINK_GT=m
CONFIG_NOZOMI=y
# CONFIG_ISI is not set
# CONFIG_N_HDLC is not set
CONFIG_N_GSM=y
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
CONFIG_SERIAL_MFD_HSU=m
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
CONFIG_SERIAL_TIMBERDALE=m
CONFIG_SERIAL_ALTERA_JTAGUART=m
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_PCH_UART=y
# CONFIG_SERIAL_PCH_UART_CONSOLE is not set
# CONFIG_SERIAL_ARC is not set
CONFIG_SERIAL_RP2=m
CONFIG_SERIAL_RP2_NR_UARTS=32
CONFIG_SERIAL_FSL_LPUART=y
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=m
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
CONFIG_SONYPI=m
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=m
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=m
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
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
CONFIG_I2C_DESIGNWARE_PLATFORM=y
CONFIG_I2C_DESIGNWARE_PCI=m
CONFIG_I2C_EG20T=y
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_ROBOTFUZZ_OSIF=m
CONFIG_I2C_TAOS_EVM=m
CONFIG_I2C_TINY_USB=y
CONFIG_I2C_VIPERBOARD=m

#
# Other I2C/SMBus bus drivers
#
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_SPMI=y
CONFIG_HSI=y
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
CONFIG_NTP_PPS=y

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=y
# CONFIG_PPS_CLIENT_PARPORT is not set
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
# CONFIG_DP83640_PHY is not set
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=m
CONFIG_GPIO_DA9055=m
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=m
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_F7188X=m
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_SCH is not set
CONFIG_GPIO_ICH=m
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_LP3943 is not set
CONFIG_GPIO_MAX7300=m
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_RC5T583 is not set
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_STMPE is not set
# CONFIG_GPIO_TC3589X is not set
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TWL6040=m
# CONFIG_GPIO_WM831X is not set
# CONFIG_GPIO_WM8994 is not set
# CONFIG_GPIO_ADP5520 is not set
CONFIG_GPIO_ADP5588=m

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=m
CONFIG_GPIO_BT8XX=y
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_INTEL_MID is not set
CONFIG_GPIO_PCH=m
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_TIMBERDALE is not set
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

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_PALMAS=y

#
# USB GPIO expanders:
#
CONFIG_GPIO_VIPERBOARD=m
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_DS1WM=m
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=m
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_MAX8925_POWER is not set
CONFIG_WM831X_BACKUP=m
# CONFIG_WM831X_POWER is not set
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=m
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9030=y
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_CHARGER_ISP1704=m
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_LP8788=y
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_MANAGER is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24190 is not set
# CONFIG_CHARGER_BQ24735 is not set
CONFIG_CHARGER_SMB347=m
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
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
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=m
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9055=m
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_MC13783_ADC=m
CONFIG_SENSORS_FSCHMD=y
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GPIO_FAN=m
CONFIG_SENSORS_HIH6130=m
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=y
# CONFIG_SENSORS_IIO_HWMON is not set
CONFIG_SENSORS_CORETEMP=m
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=y
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4222=m
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=m
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=m
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_HTU21=m
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=m
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_NCT6775=m
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
CONFIG_SENSORS_SIS5595=y
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=y
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=m
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=m
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_WM831X is not set

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
CONFIG_INTEL_POWERCLAMP=m
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
CONFIG_SOFT_WATCHDOG=m
CONFIG_DA9055_WATCHDOG=y
# CONFIG_WM831X_WATCHDOG is not set
# CONFIG_XILINX_WATCHDOG is not set
CONFIG_DW_WATCHDOG=y
# CONFIG_RETU_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=m
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=m
CONFIG_F71808E_WDT=m
CONFIG_SP5100_TCO=y
CONFIG_GEODE_WDT=m
CONFIG_SC520_WDT=m
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
CONFIG_ITCO_WDT=m
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
CONFIG_HP_WATCHDOG=m
# CONFIG_HPWDT_NMI_DECODING is not set
# CONFIG_SC1200_WDT is not set
CONFIG_PC87413_WDT=y
CONFIG_NV_TCO=m
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
CONFIG_SBC7240_WDT=m
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=m
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_MEN_A21_WDT=y

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=y

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
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
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=m
# CONFIG_MFD_AS3711 is not set
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_CROS_EC is not set
CONFIG_PMIC_DA903X=y
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_I2C=m
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
CONFIG_LPC_ICH=m
CONFIG_LPC_SCH=y
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
CONFIG_MFD_VIPERBOARD=m
CONFIG_MFD_RETU=m
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_RDC321X=y
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RTSX_USB is not set
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=m
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=m
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=m
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS65218 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
CONFIG_MFD_TIMBERDALE=m
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
CONFIG_REGULATOR_FIXED_VOLTAGE=m
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_88PM800=m
CONFIG_REGULATOR_ACT8865=y
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_ANATOP=m
CONFIG_REGULATOR_DA903X=m
CONFIG_REGULATOR_DA9055=m
CONFIG_REGULATOR_DA9063=m
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_FAN53555=m
CONFIG_REGULATOR_GPIO=m
CONFIG_REGULATOR_ISL6271A=m
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=m
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=y
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=m
# CONFIG_REGULATOR_MAX8660 is not set
# CONFIG_REGULATOR_MAX8925 is not set
CONFIG_REGULATOR_MAX8952=y
# CONFIG_REGULATOR_MAX8973 is not set
# CONFIG_REGULATOR_MAX8998 is not set
CONFIG_REGULATOR_MAX77686=y
CONFIG_REGULATOR_MAX77693=m
# CONFIG_REGULATOR_MC13783 is not set
# CONFIG_REGULATOR_MC13892 is not set
CONFIG_REGULATOR_PALMAS=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_RC5T583=m
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS6105X=m
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS65023 is not set
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65912=y
# CONFIG_REGULATOR_WM831X is not set
# CONFIG_REGULATOR_WM8400 is not set
CONFIG_REGULATOR_WM8994=y
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
CONFIG_AGP_ATI=m
# CONFIG_AGP_AMD is not set
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=m
CONFIG_AGP_NVIDIA=m
CONFIG_AGP_SIS=m
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
CONFIG_AGP_EFFICEON=m
CONFIG_INTEL_GTT=m
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
CONFIG_DRM=m
CONFIG_DRM_USB=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=m

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
CONFIG_DRM_I2C_NXP_TDA998X=m
CONFIG_DRM_TDFX=m
CONFIG_DRM_R128=m
CONFIG_DRM_RADEON=m
CONFIG_DRM_RADEON_UMS=y
CONFIG_DRM_NOUVEAU=m
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
CONFIG_DRM_I915=m
CONFIG_DRM_I915_KMS=y
CONFIG_DRM_I915_FBDEV=y
CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT=y
# CONFIG_DRM_I915_UMS is not set
CONFIG_DRM_MGA=m
CONFIG_DRM_SIS=m
CONFIG_DRM_VIA=m
CONFIG_DRM_SAVAGE=m
CONFIG_DRM_VMWGFX=m
# CONFIG_DRM_VMWGFX_FBCON is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=m
# CONFIG_DRM_AST is not set
CONFIG_DRM_MGAG200=m
# CONFIG_DRM_CIRRUS_QEMU is not set
CONFIG_DRM_QXL=m
CONFIG_DRM_BOCHS=m

#
# Frame buffer Devices
#
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
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
CONFIG_FB_CIRRUS=m
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
# CONFIG_FB_ARC is not set
CONFIG_FB_ASILIANT=y
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=m
CONFIG_FB_OPENCORES=m
CONFIG_FB_S1D13XXX=m
CONFIG_FB_LE80578=m
# CONFIG_FB_CARILLO_RANCH is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
# CONFIG_FB_ATY is not set
CONFIG_FB_SIS=m
# CONFIG_FB_SIS_300 is not set
CONFIG_FB_SIS_315=y
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=m
CONFIG_FB_VOODOO1=m
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=m
# CONFIG_FB_PM3 is not set
CONFIG_FB_CARMINE=m
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=m
# CONFIG_FB_GEODE_GX is not set
CONFIG_FB_GEODE_GX1=y
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_SM501=y
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=m
# CONFIG_FB_AUO_K1900 is not set
CONFIG_FB_AUO_K1901=m
CONFIG_FB_SIMPLE=y
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_CARILLO_RANCH=m
CONFIG_BACKLIGHT_PWM=m
CONFIG_BACKLIGHT_DA903X=m
# CONFIG_BACKLIGHT_MAX8925 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP5520=m
CONFIG_BACKLIGHT_ADP8860=m
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_LM3630A=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
# CONFIG_BACKLIGHT_LP8788 is not set
# CONFIG_BACKLIGHT_OT200 is not set
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
# CONFIG_LOGO_LINUX_CLUT224 is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
CONFIG_UHID=y
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
CONFIG_HID_APPLEIR=m
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_CP2112 is not set
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EMS_FF=m
CONFIG_HID_ELECOM=y
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_HOLTEK is not set
CONFIG_HID_HUION=m
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=m
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=m
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_PRIMAX=y
CONFIG_HID_ROCCAT=m
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=m
CONFIG_HID_GREENASIA=m
CONFIG_GREENASIA_FF=y
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
CONFIG_ZEROPLUS_FF=y
# CONFIG_HID_ZYDACRON is not set
CONFIG_HID_SENSOR_HUB=m

#
# USB HID support
#
CONFIG_USB_HID=m
CONFIG_HID_PID=y
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
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEFAULT_PERSIST is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=m
CONFIG_USB_WUSB=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_PLATFORM=m
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=m
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_FUSBH200_HCD is not set
CONFIG_USB_FOTG210_HCD=y
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=m
CONFIG_USB_U132_HCD=y
CONFIG_USB_SL811_HCD=m
# CONFIG_USB_SL811_HCD_ISO is not set
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_RENESAS_USBHS_HCD=m
CONFIG_USB_WHCI_HCD=y
CONFIG_USB_HWA_HCD=m
CONFIG_USB_HCD_BCMA=y
CONFIG_USB_HCD_SSB=y
CONFIG_USB_HCD_TEST_MODE=y
CONFIG_USB_RENESAS_USBHS=m

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=m
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
CONFIG_USB_MDC800=m
# CONFIG_USB_MICROTEK is not set
CONFIG_USB_MUSB_HDRC=y
CONFIG_USB_MUSB_HOST=y
# CONFIG_USB_MUSB_TUSB6010 is not set
CONFIG_USB_MUSB_UX500=m
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
CONFIG_USB_DWC3_PCI=m
# CONFIG_USB_DWC3_KEYSTONE is not set

#
# Debugging features
#
# CONFIG_USB_DWC3_DEBUG is not set
CONFIG_USB_DWC2=m
CONFIG_USB_DWC2_DEBUG=y
CONFIG_USB_DWC2_VERBOSE=y
# CONFIG_USB_DWC2_TRACK_MISSED_SOFS is not set
# CONFIG_USB_DWC2_DEBUG_PERIODIC is not set
CONFIG_USB_CHIPIDEA=m
CONFIG_USB_CHIPIDEA_UDC=y
CONFIG_USB_CHIPIDEA_HOST=y
CONFIG_USB_CHIPIDEA_DEBUG=y

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=y
# CONFIG_USB_SERIAL_CONSOLE is not set
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_SIMPLE=m
CONFIG_USB_SERIAL_AIRCABLE=y
CONFIG_USB_SERIAL_ARK3116=y
CONFIG_USB_SERIAL_BELKIN=y
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP210X is not set
CONFIG_USB_SERIAL_CYPRESS_M8=y
CONFIG_USB_SERIAL_EMPEG=y
CONFIG_USB_SERIAL_FTDI_SIO=y
CONFIG_USB_SERIAL_VISOR=y
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
CONFIG_USB_SERIAL_EDGEPORT_TI=y
# CONFIG_USB_SERIAL_F81232 is not set
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=y
# CONFIG_USB_SERIAL_IUU is not set
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
CONFIG_USB_SERIAL_KEYSPAN=y
CONFIG_USB_SERIAL_KEYSPAN_MPR=y
# CONFIG_USB_SERIAL_KEYSPAN_USA28 is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA28X is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA28XA is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA28XB is not set
CONFIG_USB_SERIAL_KEYSPAN_USA19=y
# CONFIG_USB_SERIAL_KEYSPAN_USA18X is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA19W is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA19QW is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA19QI is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA49W is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA49WLC is not set
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=y
CONFIG_USB_SERIAL_MCT_U232=m
# CONFIG_USB_SERIAL_METRO is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
CONFIG_USB_SERIAL_MOS7840=y
CONFIG_USB_SERIAL_MXUPORT=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=y
# CONFIG_USB_SERIAL_QCAUX is not set
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=y
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=y
CONFIG_USB_SERIAL_XIRCOM=y
CONFIG_USB_SERIAL_WWAN=y
CONFIG_USB_SERIAL_OPTION=y
CONFIG_USB_SERIAL_OMNINET=m
# CONFIG_USB_SERIAL_OPTICON is not set
CONFIG_USB_SERIAL_XSENS_MT=y
# CONFIG_USB_SERIAL_WISHBONE is not set
CONFIG_USB_SERIAL_ZTE=m
CONFIG_USB_SERIAL_SSU100=y
# CONFIG_USB_SERIAL_QT2 is not set
CONFIG_USB_SERIAL_DEBUG=y

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
# CONFIG_USB_SISUSBVGA_CON is not set
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=m
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=m
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=m

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
# CONFIG_USB_OTG_FSM is not set
CONFIG_NOP_USB_XCEIV=m
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=m
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_USB_GPIO_VBUS=m
CONFIG_TAHVO_USB=m
CONFIG_TAHVO_USB_HOST_BY_DEFAULT=y
CONFIG_USB_ISP1301=y
# CONFIG_USB_RCAR_PHY is not set
CONFIG_USB_GADGET=m
# CONFIG_USB_GADGET_DEBUG is not set
CONFIG_USB_GADGET_DEBUG_FILES=y
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
# CONFIG_USB_FOTG210_UDC is not set
# CONFIG_USB_GR_UDC is not set
# CONFIG_USB_R8A66597 is not set
CONFIG_USB_RENESAS_USBHS_UDC=m
# CONFIG_USB_PXA27X is not set
CONFIG_USB_S3C_HSOTG=m
CONFIG_USB_MV_UDC=m
CONFIG_USB_MV_U3D=m
CONFIG_USB_M66592=m
# CONFIG_USB_AMD5536UDC is not set
CONFIG_USB_NET2272=m
# CONFIG_USB_NET2272_DMA is not set
CONFIG_USB_NET2280=m
CONFIG_USB_GOKU=m
CONFIG_USB_EG20T=m
CONFIG_USB_DUMMY_HCD=m
CONFIG_USB_LIBCOMPOSITE=m
CONFIG_USB_F_ACM=m
CONFIG_USB_U_SERIAL=m
CONFIG_USB_U_ETHER=m
CONFIG_USB_F_SERIAL=m
CONFIG_USB_F_OBEX=m
CONFIG_USB_F_NCM=m
CONFIG_USB_F_ECM=m
CONFIG_USB_F_PHONET=m
CONFIG_USB_F_EEM=m
CONFIG_USB_F_SUBSET=m
CONFIG_USB_F_RNDIS=m
CONFIG_USB_F_MASS_STORAGE=m
CONFIG_USB_F_FS=m
CONFIG_USB_CONFIGFS=m
CONFIG_USB_CONFIGFS_SERIAL=y
CONFIG_USB_CONFIGFS_ACM=y
# CONFIG_USB_CONFIGFS_OBEX is not set
CONFIG_USB_CONFIGFS_NCM=y
# CONFIG_USB_CONFIGFS_ECM is not set
# CONFIG_USB_CONFIGFS_ECM_SUBSET is not set
CONFIG_USB_CONFIGFS_RNDIS=y
CONFIG_USB_CONFIGFS_EEM=y
CONFIG_USB_CONFIGFS_PHONET=y
CONFIG_USB_CONFIGFS_MASS_STORAGE=y
# CONFIG_USB_CONFIGFS_F_LB_SS is not set
CONFIG_USB_CONFIGFS_F_FS=y
# CONFIG_USB_ZERO is not set
CONFIG_USB_ETH=m
CONFIG_USB_ETH_RNDIS=y
CONFIG_USB_ETH_EEM=y
CONFIG_USB_G_NCM=m
CONFIG_USB_GADGETFS=m
CONFIG_USB_FUNCTIONFS=m
CONFIG_USB_FUNCTIONFS_ETH=y
# CONFIG_USB_FUNCTIONFS_RNDIS is not set
# CONFIG_USB_FUNCTIONFS_GENERIC is not set
# CONFIG_USB_MASS_STORAGE is not set
CONFIG_USB_GADGET_TARGET=m
CONFIG_USB_G_SERIAL=m
CONFIG_USB_G_PRINTER=m
CONFIG_USB_CDC_COMPOSITE=m
CONFIG_USB_G_NOKIA=m
CONFIG_USB_G_ACM_MS=m
CONFIG_USB_G_MULTI=m
CONFIG_USB_G_MULTI_RNDIS=y
CONFIG_USB_G_MULTI_CDC=y
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
CONFIG_UWB_I1480U=y
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
# CONFIG_MMC_BLOCK_BOUNCE is not set
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_WBSD=y
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MMC_VUB300=y
CONFIG_MMC_USHC=y
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=y
CONFIG_MS_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_MEMSTICK_R592=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8501=m
CONFIG_LEDS_LP8788=m
CONFIG_LEDS_CLEVO_MAIL=m
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_PCA9685=m
CONFIG_LEDS_WM831X_STATUS=y
# CONFIG_LEDS_DA903X is not set
# CONFIG_LEDS_PWM is not set
CONFIG_LEDS_REGULATOR=m
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_ADP5520=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_MC13783=m
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_OT200=m
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=m
CONFIG_ACCESSIBILITY=y
# CONFIG_A11Y_BRAILLE_CONSOLE is not set
CONFIG_INFINIBAND=m
# CONFIG_INFINIBAND_USER_MAD is not set
# CONFIG_INFINIBAND_USER_ACCESS is not set
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_AMSO1100=m
# CONFIG_INFINIBAND_AMSO1100_DEBUG is not set
CONFIG_INFINIBAND_CXGB4=m
CONFIG_MLX4_INFINIBAND=m
# CONFIG_MLX5_INFINIBAND is not set
CONFIG_INFINIBAND_NES=m
CONFIG_INFINIBAND_NES_DEBUG=y
CONFIG_INFINIBAND_OCRDMA=m
CONFIG_INFINIBAND_IPOIB=m
CONFIG_INFINIBAND_IPOIB_CM=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_SRPT=m
CONFIG_INFINIBAND_ISER=m
CONFIG_INFINIBAND_ISERT=m
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_DECODE_MCE is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_SYSTOHC is not set
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
# CONFIG_RTC_INTF_PROC is not set
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM80X=y
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1374=m
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_DS3232=y
CONFIG_RTC_DRV_LP8788=y
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8925=m
CONFIG_RTC_DRV_MAX8998=m
CONFIG_RTC_DRV_MAX77686=y
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_ISL12022=m
# CONFIG_RTC_DRV_ISL12057 is not set
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PALMAS=y
CONFIG_RTC_DRV_PCF2127=m
CONFIG_RTC_DRV_PCF8523=y
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
CONFIG_RTC_DRV_RC5T583=y
CONFIG_RTC_DRV_S35390A=m
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=m
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
# CONFIG_RTC_DRV_DA9055 is not set
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_RP5C01=y
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_DS2404 is not set
CONFIG_RTC_DRV_WM831X=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=m
CONFIG_RTC_DRV_MOXART=m

#
# HID Sensor RTC drivers
#
CONFIG_RTC_DRV_HID_SENSOR_TIME=m
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=m
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
CONFIG_UIO_NETX=y
CONFIG_UIO_MF624=m
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=m

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MMIO=m
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_HP_WMI is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
CONFIG_ACPI_WMI=m
# CONFIG_MSI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=y
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_MXM_WMI=m
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_INTEL_IOMMU is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=m
CONFIG_STE_MODEM_RPROC=m

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=m
CONFIG_EXTCON_ADC_JACK=m
CONFIG_EXTCON_MAX77693=m
# CONFIG_EXTCON_PALMAS is not set
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
CONFIG_HID_SENSOR_ACCEL_3D=m
# CONFIG_IIO_ST_ACCEL_3AXIS is not set

#
# Analog to digital converters
#
CONFIG_LP8788_ADC=y
# CONFIG_MAX1363 is not set
CONFIG_MCP3422=m
# CONFIG_NAU7802 is not set
CONFIG_TI_ADC081C=y
CONFIG_TI_AM335X_ADC=m
# CONFIG_VIPERBOARD_ADC is not set

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=m
CONFIG_AD5380=m
# CONFIG_AD5446 is not set
CONFIG_MAX517=m
# CONFIG_MCP4725 is not set

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
# CONFIG_HID_SENSOR_GYRO_3D is not set
CONFIG_IIO_ST_GYRO_3AXIS=m
CONFIG_IIO_ST_GYRO_I2C_3AXIS=m
# CONFIG_ITG3200 is not set

#
# Humidity sensors
#
CONFIG_DHT11=m
# CONFIG_SI7005 is not set

#
# Inertial measurement units
#
# CONFIG_INV_MPU6050_IIO is not set

#
# Light sensors
#
CONFIG_ADJD_S311=m
CONFIG_APDS9300=y
CONFIG_CM32181=y
# CONFIG_CM36651 is not set
# CONFIG_GP2AP020A00F is not set
CONFIG_HID_SENSOR_ALS=m
# CONFIG_HID_SENSOR_PROX is not set
CONFIG_LTR501=y
# CONFIG_TCS3472 is not set
CONFIG_SENSORS_TSL2563=y
CONFIG_TSL4531=m
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
CONFIG_MAG3110=m
CONFIG_HID_SENSOR_MAGNETOMETER_3D=m
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y

#
# Inclinometer sensors
#
# CONFIG_HID_SENSOR_INCLINOMETER_3D is not set

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=m
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure sensors
#
CONFIG_HID_SENSOR_PRESS=m
CONFIG_MPL3115=y
CONFIG_IIO_ST_PRESS=m
CONFIG_IIO_ST_PRESS_I2C=m

#
# Temperature sensors
#
CONFIG_TMP006=y
CONFIG_NTB=m
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_LP3943=m
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=m
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
CONFIG_FMC_TRIVIAL=m
# CONFIG_FMC_WRITE_EEPROM is not set
CONFIG_FMC_CHARDEV=m

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
CONFIG_PHY_EXYNOS_MIPI_VIDEO=y
# CONFIG_POWERCAP is not set
CONFIG_MCB=y

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=y
# CONFIG_DMIID is not set
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=m
# CONFIG_EXT4_USE_FOR_EXT23 is not set
CONFIG_EXT4_FS_POSIX_ACL=y
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_JBD2=m
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
CONFIG_XFS_DEBUG=y
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
# CONFIG_OCFS2_FS_USERSPACE_CLUSTER is not set
CONFIG_OCFS2_FS_STATS=y
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
CONFIG_NILFS2_FS=m
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=m
CONFIG_QFMT_V1=m
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_FSCACHE_OBJECT_LIST=y
CONFIG_CACHEFILES=m
CONFIG_CACHEFILES_DEBUG=y
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
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
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V2 is not set
# CONFIG_NFS_V3 is not set
# CONFIG_NFS_V4 is not set
# CONFIG_NFS_SWAP is not set
CONFIG_ROOT_NFS=y
CONFIG_NFS_FSCACHE=y
CONFIG_NFSD=y
# CONFIG_NFSD_V3 is not set
# CONFIG_NFSD_V4 is not set
CONFIG_LOCKD=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_XPRT_RDMA=m
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_SUNRPC_DEBUG is not set
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
# CONFIG_CIFS_POSIX is not set
# CONFIG_CIFS_ACL is not set
CONFIG_CIFS_DEBUG=y
CONFIG_CIFS_DEBUG2=y
CONFIG_CIFS_DFS_UPCALL=y
CONFIG_CIFS_SMB2=y
# CONFIG_CIFS_FSCACHE is not set
CONFIG_NCP_FS=m
CONFIG_NCPFS_PACKET_SIGNING=y
CONFIG_NCPFS_IOCTL_LOCKING=y
# CONFIG_NCPFS_STRONG is not set
CONFIG_NCPFS_NFS_NS=y
# CONFIG_NCPFS_OS2_NS is not set
# CONFIG_NCPFS_SMALLDOS is not set
# CONFIG_NCPFS_NLS is not set
# CONFIG_NCPFS_EXTRAS is not set
CONFIG_CODA_FS=m
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=y
CONFIG_9P_FSCACHE=y
CONFIG_9P_FS_POSIX_ACL=y
# CONFIG_9P_FS_SECURITY is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=m
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=m
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=m
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=m
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=m
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y
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
CONFIG_HEADERS_CHECK=y
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
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
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
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_PROVE_RCU_DELAY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_TORTURE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_VERBOSE=y
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
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
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_PREEMPT_TRACER=y
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=m
CONFIG_TEST_KSTRTOX=m
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
CONFIG_DMA_API_DEBUG=y
CONFIG_TEST_MODULE=m
# CONFIG_TEST_USER_COPY is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_SET_MODULE_RONX=y
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
# CONFIG_BIG_KEYS is not set
CONFIG_ENCRYPTED_KEYS=m
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=m
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
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=y
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_GHASH is not set
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=m
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_586=m
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=m
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_USER_API=m
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=m
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
CONFIG_CRYPTO_DEV_GEODE=m
# CONFIG_CRYPTO_DEV_CCP is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=m
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=m
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_LGUEST is not set
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
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_CRC64_ECMA=m
CONFIG_AUDIT_GENERIC=y
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_BTREE=y
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
# CONFIG_CORDIC is not set
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=m
CONFIG_FONT_SUPPORT=y
CONFIG_FONTS=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_FONT_6x11=y
CONFIG_FONT_7x14=y
CONFIG_FONT_PEARL_8x8=y
CONFIG_FONT_ACORN_8x8=y
CONFIG_FONT_MINI_4x6=y
CONFIG_FONT_SUN8x16=y
CONFIG_FONT_SUN12x22=y
CONFIG_FONT_10x18=y

--ikeVEW9yuYc//A+q--
