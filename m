Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab3JEXsB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 19:48:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:29085 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593Ab3JEXr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 19:47:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1041,1371106800"; 
   d="log'?scan'208";a="405936490"
Date: Sun, 6 Oct 2013 07:47:28 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: [x86] BUG: unable to handle kernel paging request at 08000060
Message-ID: <20131005234728.GA22657@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <20131005234430.GA22485@localhost>
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi Peter,

Here is another bisect on a different kconfig.

[    6.612196] Write protecting the kernel text: 9752k
[    6.613078] Write protecting the kernel read-only data: 3444k
[    6.647222] BUG: unable to handle kernel paging request at 08000060
[    6.648030] IP: [<41046ab0>] task_work_run+0x60/0xa0
[    6.648030] *pde = 0686f067 *pte = 00000000 
[    6.648030] Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
[    6.648030] CPU: 0 PID: 131 Comm: rc.local Not tainted 3.12.0-rc2-02842-g45c4ea0 #2
[    6.648030] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    6.648030] task: 46865000 ti: 46874000 task.ti: 46874000
[    6.648030] EIP: 0060:[<41046ab0>] EFLAGS: 00010206 CPU: 0
[    6.648030] EIP is at task_work_run+0x60/0xa0
[    6.648030] EAX: 08000060 EBX: 46862f40 ECX: 00000000 EDX: 08000060
[    6.648030] ESI: 468652ac EDI: 46865000 EBP: 46875f9c ESP: 46875f90
[    6.648030]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    6.648030] CR0: 8005003b CR2: 08000060 CR3: 0686e000 CR4: 00000690
[    6.648030] Stack:
[    6.648030]  396f7903 396e0ee8 37642ff4 46875fac 41002310 41984ebc 4fff01bc 46874000
[    6.648030]  419848e6 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    6.648030]  0000007b 0000007b 00000000 00000000 0000000b 377a01d0 00000073 00000200
[    6.648030] Call Trace:
[    6.648030]  [<41002310>] do_notify_resume+0x50/0x60
[    6.648030]  [<41984ebc>] ? sysenter_do_call+0x1e/0x37
[    6.648030]  [<419848e6>] work_notifysig+0x26/0x30
[    6.648030] Code: eb 0b 89 f6 8d bc 27 00 00 00 00 31 c9 89 d0 0f b1 0e 39 c2 75 d5 85 d2 74 46 90 f3 90 8b 87 e4 02 00 00 85 c0 74 f4 31 db 66 90 <8b> 02 89 1a 85 c0 74 08 89 d3 89 c2 eb f2 66 90 89 d0 ff 52 04
[    6.648030] EIP: [<41046ab0>] task_work_run+0x60/0xa0 SS:ESP 0068:46875f90
[    6.648030] CR2: 0000000008000060
[    6.678032] CRED: Invalid credentials

git bisect start 45c4ea0c4c1b8abffb575b865243fd1c69bbecd9 v3.11 --
git bisect good 39eda2aba6be642b71f2e0ad623dcb09fd9d79cf  # 00:42    150+  Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc
git bisect good bff157b3ad4b9f6be0af6987fcd62deaf0f2b799  # 03:47    150+  Merge branch 'slab/next' of git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux
git bisect good f659a4f17bbecdbad57dd5c63a1783e5ec5fd792  # 09:17    150+  Merge remote-tracking branch 'drm-intel/for-linux-next'
git bisect  bad 6405cd58ac5c0a6ed5f4f1308892147870b9d5cf  # 09:22      1-  Merge remote-tracking branch 'regmap/for-next'
git bisect good 5094001bc464c12d3e04eb73a5e0d5e8436f09f7  # 12:28    150+  Merge remote-tracking branch 'omap_dss2/for-next'
git bisect good 8f31410ee9917e8648c7cf7f45e22320c166998a  # 17:48    150+  Merge remote-tracking branch 'spi/for-next'
git bisect  bad 6f014a7ea91f80f765ba700dcd1728680ba5c58e  # 17:52      0-  Merge remote-tracking branch 'tip/auto-latest'
git bisect  bad bce56fbc0f165658f7e0715fedc8d39840bae31c  # 17:57      0-  Merge branch 'sched/core'
git bisect  bad c2daa3bed53a81171cf8c1a36db798e82b91afe8  # 18:01      2-  sched, x86: Provide a per-cpu preempt_count implementation
git bisect good 4314895165623879937f46d767673654662b570c  # 18:18    150+  sched: Micro-optimize by dropping unnecessary task_rq() calls
git bisect  bad 4a2b4b222743bb07fedf985b884550f2ca067ea9  # 18:22      2-  sched: Introduce preempt_count accessor functions
git bisect  bad b021fe3e25094fbec22d0eff846d2adeee1b9736  # 18:26      0-  sched, rcu: Make RCU use resched_cpu()
git bisect  bad 0c44c2d0f459cd7e275242b72f500137c4fa834d  # 18:27      0-  x86: Use asm goto to implement better modify_and_test() functions
git bisect good 4314895165623879937f46d767673654662b570c  # 21:38    450+  sched: Micro-optimize by dropping unnecessary task_rq() calls
git bisect  bad a0cf1abc25ac197dd97b857c0f6341066a8cb1cf  # 21:38      0-  Add linux-next specific files for 20130927
git bisect good c31eeaced22ce8bd61268a3c595d542bb38c0a4f  # 21:59    450+  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect  bad a0cf1abc25ac197dd97b857c0f6341066a8cb1cf  # 21:59      0-  Add linux-next specific files for 20130927

Thanks,
Fengguang

--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-bay-1:20131001102547:3.12.0-rc2-02842-g45c4ea0:2"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Linux version 3.12.0-rc2-02842-g45c4ea0 (kbuild@jaketown) (g=
cc version 4.8.1 (Debian 4.8.1-8) ) #2 PREEMPT Tue Oct 1 02:36:58 CST 2013
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
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
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
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at =
[400fdab0]
[    0.000000]   mpc: fdac0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x02bfffff]
[    0.000000] Base memory trampoline at [4009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
[    0.000000]  [mem 0x0e000000-0x0e3fffff] page 4k
[    0.000000] BRK [0x022dd000, 0x022ddfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
[    0.000000]  [mem 0x08000000-0x0dffffff] page 4k
[    0.000000] BRK [0x022de000, 0x022defff] PGTABLE
[    0.000000] BRK [0x022df000, 0x022dffff] PGTABLE
[    0.000000] BRK [0x022e0000, 0x022e0fff] PGTABLE
[    0.000000] BRK [0x022e1000, 0x022e1fff] PGTABLE
[    0.000000] BRK [0x022e2000, 0x022e2fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x07ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
[    0.000000]  [mem 0x0e400000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127740(97%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC=
 00000001)
[    0.000000] ACPI: DSDT 0fffe490 011A9 (v01   BXPC   BXDSDT 00000001 INTL=
 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: APIC 0ffff680 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC=
 00000001)
[    0.000000] ACPI: HPET 0ffff640 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC=
 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000] free_area_init_node: node 0, pgdat 41d914e0, node_mem_map 4e=
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
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] Using ACPI for processor (LAPIC) configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000]   mpc: fdac0-fdbec
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1        =20
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC=
 LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, API=
C LINT 01
[    0.000000] Processors: 1
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1ceeac0
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64860
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/i386-randconfig-j4-09302234/next:master/.vml=
inuz-45c4ea0c4c1b8abffb575b865243fd1c69bbecd9-20131001090102-5-bay branch=
=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randconfig-j4-09302234/45c4ea0c4c1=
b8abffb575b865243fd1c69bbecd9/vmlinuz-3.12.0-rc2-02842-g45c4ea0
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 206108K/261744K available (9750K kernel code, 708K r=
wdata, 3440K rodata, 464K init, 4896K bss, 55636K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe1000 - 0xfffff000   ( 120 kB)
[    0.000000]     vmalloc : 0x507fe000 - 0xfffdf000   (2807 MB)
[    0.000000]     lowmem  : 0x40000000 - 0x4fffe000   ( 255 MB)
[    0.000000]       .init : 0x41d95000 - 0x41e09000   ( 464 kB)
[    0.000000]       .data : 0x41985cbb - 0x41d94320   (4153 kB)
[    0.000000]       .text : 0x41000000 - 0x41985cbb   (9751 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3D4d402000 soft=3D4d404000
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
[    0.000000] ODEBUG: 2 of 2 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2992.486 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 5984.97 Bogo=
MIPS (lpj=3D2992486)
[    0.003402] pid_max: default: 4096 minimum: 301
[    0.004095] Mount-cache hash table entries: 512
[    0.005357] mce: CPU supports 10 MCE banks
[    0.005927] mce: unknown CPU type - not enabling MCE support
[    0.006032] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.006032] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.006032] tlb_flushall_shift: -1
[    0.007005] CPU: GenuineIntel Common KVM processor (fam: 0f, model: 06, =
stepping: 01)
[    0.013813] ACPI: Core revision 20130823
[    0.017085] ACPI: All ACPI Tables successfully acquired
[    0.017861] ACPI: setting ELCR to 0200 (from 0c00)
[    0.018179] Performance Events: Getting VERSION: 50014
[    0.020635] Getting VERSION: 50014
[    0.021013] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.022014] Getting ID: 0
[    0.022397] Getting ID: f000000
[    0.023046] Getting LVT0: 8700
[    0.023481] Getting LVT1: 8400
[    0.024099] enabled ExtINT on CPU#0
[    0.024626] Using local APIC timer interrupts.
[    0.024626] calibrating APIC timer ...
[    0.026000] ... lapic delta =3D 6248755
[    0.026000] ... PM-Timer delta =3D 357882
[    0.026000] ... PM-Timer result ok
[    0.026000] ..... delta 6248755
[    0.026000] ..... mult: 268381983
[    0.026000] ..... calibration result: 999800
[    0.026000] ..... CPU clock speed is 2991.0889 MHz.
[    0.026000] ..... host bus clock speed is 999.0800 MHz.
[    0.026528] devtmpfs: initialized
[    0.028252] xor: measuring software checksum speed
[    0.038009]    pIII_sse  :  8880.000 MB/sec
[    0.048002]    prefetch64-sse: 10672.000 MB/sec
[    0.048627] xor: using function: prefetch64-sse (10672.000 MB/sec)
[    0.049028] atomic64 test passed for i386+ platform with CX8 and with SSE
[    0.050416] regulator-dummy: no parameters
[    0.051218] NET: Registered protocol family 16
[    0.053627] cpuidle: using governor ladder
[    0.054452] ACPI: bus type PCI registered
[    0.055264] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.056002] PCI: Using configuration type 1 for base access
[    0.085032] bio: create slab <bio-0> at 0
[    0.103015] raid6: mmxx1     3859 MB/s
[    0.120011] raid6: mmxx2     4238 MB/s
[    0.137004] raid6: sse1x1    2519 MB/s
[    0.154013] raid6: sse1x2    3195 MB/s
[    0.171002] raid6: sse2x1    4472 MB/s
[    0.188008] raid6: sse2x2    5214 MB/s
[    0.188532] raid6: using algorithm sse2x2 (5214 MB/s)
[    0.189002] raid6: using intx1 recovery algorithm
[    0.190025] ACPI: Added _OSI(Module Device)
[    0.190610] ACPI: Added _OSI(Processor Device)
[    0.191002] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.191651] ACPI: Added _OSI(Processor Aggregator Device)
[    0.199427] ACPI: Interpreter enabled
[    0.199950] ACPI: (supports S0 S5)
[    0.200002] ACPI: Using PIC for interrupt routing
[    0.201087] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.215357] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.216006] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.216764] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.218216] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.219111] PCI host bridge to bus 0000:00
[    0.220004] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.221003] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.222003] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.222846] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.223003] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.224089] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.226434] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.228025] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.231540] pci 0000:00:01.1: reg 0x20: [io  0xc1e0-0xc1ef]
[    0.233956] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.235259] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.236014] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.237424] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.240052] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.242636] pci 0000:00:02.0: reg 0x14: [mem 0xfebe4000-0xfebe4fff]
[    0.250636] pci 0000:00:02.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.252412] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.254003] pci 0000:00:03.0: reg 0x10: [io  0xc1c0-0xc1df]
[    0.256003] pci 0000:00:03.0: reg 0x14: [mem 0xfebe5000-0xfebe5fff]
[    0.261507] pci 0000:00:03.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.263207] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.265003] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.266517] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.272518] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.274044] pci 0000:00:05.0: [8086:2668] type 00 class 0x040300
[    0.275284] pci 0000:00:05.0: reg 0x10: [mem 0xfebe0000-0xfebe3fff]
[    0.280026] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.281514] pci 0000:00:06.0: reg 0x10: [io  0xc040-0xc07f]
[    0.283511] pci 0000:00:06.0: reg 0x14: [mem 0xfebe6000-0xfebe6fff]
[    0.290035] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.291508] pci 0000:00:07.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.293509] pci 0000:00:07.0: reg 0x14: [mem 0xfebe7000-0xfebe7fff]
[    0.299938] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.301509] pci 0000:00:08.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.303504] pci 0000:00:08.0: reg 0x14: [mem 0xfebe8000-0xfebe8fff]
[    0.309531] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.311506] pci 0000:00:09.0: reg 0x10: [io  0xc100-0xc13f]
[    0.313505] pci 0000:00:09.0: reg 0x14: [mem 0xfebe9000-0xfebe9fff]
[    0.319498] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.321505] pci 0000:00:0a.0: reg 0x10: [io  0xc140-0xc17f]
[    0.323008] pci 0000:00:0a.0: reg 0x14: [mem 0xfebea000-0xfebeafff]
[    0.329533] pci 0000:00:0b.0: [1af4:1001] type 00 class 0x010000
[    0.331511] pci 0000:00:0b.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.333003] pci 0000:00:0b.0: reg 0x14: [mem 0xfebeb000-0xfebebfff]
[    0.339439] pci 0000:00:0c.0: [8086:25ab] type 00 class 0x088000
[    0.341003] pci 0000:00:0c.0: reg 0x10: [mem 0xfebec000-0xfebec00f]
[    0.345536] pci_bus 0000:00: on NUMA node 0
[    0.346802] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.348019] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.349055] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.350102] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.351047] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.352700] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.353008] ACPI: \_SB_.PCI0: notify handler is installed
[    0.354060] Found 1 acpi root devices
[    0.357628] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.358007] vgaarb: loaded
[    0.359002] vgaarb: bridge control possible 0000:00:02.0
[    0.362355] SCSI subsystem initialized
[    0.363361] libata version 3.00 loaded.
[    0.364334] Linux video capture interface: v2.00
[    0.365421] pps_core: LinuxPPS API ver. 1 registered
[    0.366002] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.367088] PTP clock support registered
[    0.368298] EDAC MC: Ver: 3.0.0
[    0.369270] EDAC DEBUG: edac_mc_sysfs_init: device mc created
[    0.370700] PCI: Using ACPI for IRQ routing
[    0.371003] PCI: pci_cache_line_size set to 64 bytes
[    0.372298] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.373010] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.374616] irda_init()
[    0.375024] NET: Registered protocol family 23
[    0.375717] Bluetooth: Core ver 2.16
[    0.376127] NET: Registered protocol family 31
[    0.376733] Bluetooth: HCI device and connection manager initialized
[    0.377013] Bluetooth: HCI socket layer initialized
[    0.378003] Bluetooth: L2CAP socket layer initialized
[    0.379064] Bluetooth: SCO socket layer initialized
[    0.379730] NET: Registered protocol family 8
[    0.380007] NET: Registered protocol family 20
[    0.381738] nfc: nfc_init: NFC Core ver 0.1
[    0.382262] NET: Registered protocol family 39
[    0.383562] Switched to clocksource kvm-clock
[    0.384098] FS-Cache: Loaded
[    0.384699] CacheFiles: Loaded
[    0.385372] pnp: PnP ACPI init
[    0.385810] ACPI: bus type PNP registered
[    0.386557] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.387592] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.388782] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.389731] pnp 00:03: [dma 2]
[    0.390267] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.391327] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.392447] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.393699] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.395206] pnp: PnP ACPI: found 7 devices
[    0.395782] ACPI: bus type PNP unregistered
[    0.433161] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.433923] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.434710] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.435581] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.436454] NET: Registered protocol family 1
[    0.437074] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.437899] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.438739] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.439635] pci 0000:00:02.0: Boot video device
[    0.440386] PCI: CLS 0 bytes, default 64
[    0.442370] Unpacking initramfs...
[    5.700238] debug: unmapping init [mem 0x4e73f000-0x4ffeffff]
[    5.899707] DMA-API: preallocated 65536 debug entries
[    5.900451] DMA-API: debugging enabled by kernel config
[    5.901699] Machine check injector initialized
[    5.918430] PCLMULQDQ-NI instructions are not detected.
[    5.919346] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    5.925989] Initializing RT-Tester: OK
[    5.927654] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    5.930248] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    5.932742] jffs2: version 2.2. (NAND)=20
[    5.937636] ROMFS MTD (C) 2007 Red Hat, Inc.
[    5.938243] QNX4 filesystem 0.2.3 registered.
[    5.938847] QNX6 filesystem 1.0.0 registered.
[    5.939468] fuse init (API version 7.22)
[    5.940362] SGI XFS with ACLs, security attributes, realtime, debug enab=
led
[    5.942100] bio: create slab <bio-1> at 1
[    5.943303] Btrfs loaded, debug=3Don
[    5.943789] btrfs: selftest: Running btrfs free space cache tests
[    5.944651] btrfs: selftest: Running extent only tests
[    5.945384] btrfs: selftest: Running bitmap only tests
[    5.946495] btrfs: selftest: Running bitmap and extent tests
[    5.947953] btrfs: selftest: Free space cache tests finished
[    5.948782] msgmni has been set to 402
[    6.083604] alg: No test for crc32 (crc32-table)
[    6.088545] alg: No test for lz4 (lz4-generic)
[    6.089372] alg: No test for stdrng (krng)
[    6.095944] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    6.101985] async_tx: api initialized (async)
[    6.102684] Key type asymmetric registered
[    6.103420] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    6.104452] io scheduler noop registered
[    6.105002] io scheduler deadline registered
[    6.105619] io scheduler cfq registered (default)
[    6.112519] crc32: CRC_LE_BITS =3D 1, CRC_BE BITS =3D 1
[    6.113207] crc32: self tests passed, processed 225944 bytes in 2969244 =
nsec
[    6.117798] crc32c: CRC_LE_BITS =3D 1
[    6.118296] crc32c: self tests passed, processed 225944 bytes in 1798192=
 nsec
[    6.121125] ipmi message handler version 39.2
[    6.121729] ipmi device interface
[    6.122659] IPMI System Interface driver.
[    6.123554] ipmi_si: Adding default-specified kcs state machine
[    6.124405] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    6.125799] ipmi_si: Interface detection failed
[    6.126449] ipmi_si: Adding default-specified smic state machine
[    6.127315] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    6.128714] ipmi_si: Interface detection failed
[    6.129355] ipmi_si: Adding default-specified bt state machine
[    6.130192] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    6.131558] ipmi_si: Interface detection failed
[    6.132249] ipmi_si: Unable to find any System Interface(s)
[    6.133032] IPMI Watchdog: driver initialized
[    6.133638] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    6.135215] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    6.136240] ACPI: Power Button [PWRF]
[    6.137845] r3964: Philips r3964 Driver $Revision: 1.10 $
[    6.138616] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    6.161775] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    6.165142] STMicroelectronics ASC driver initialized
[    6.166407] serial: Freescale lpuart driver
[    6.168702] lp: driver loaded but no devices found
[    6.169638] Non-volatile memory driver v1.3
[    6.170240] toshiba: not a supported Toshiba laptop
[    6.171504] ppdev: user-space parallel port driver
[    6.172347] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    6.173348] platform pc8736x_gpio.0: no device found
[    6.174204] nsc_gpio initializing
[    6.174693] smapi::smapi_init, ERROR invalid usSmapiID
[    6.175406] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    6.176678] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    6.177678] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    6.178546] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    6.179785] Hangcheck: Using getrawmonotonic().
[    6.181115] [drm] Initialized drm 1.1.0 20060810
[    6.188669] Uniform Multi-Platform E-IDE driver
[    6.190186] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[    6.194517] Loading iSCSI transport class v2.0-870.
[    6.197917] rdac: device handler registered
[    6.198713] hp_sw: device handler registered
[    6.199317] emc: device handler registered
[    6.199883] alua: device handler registered
[    6.200479] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    6.202790] osd: LOADED open-osd 0.2.1
[    6.203959] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    6.211701] SSFDC read-only Flash Translation layer
[    6.212398] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    6.213312] Could not find PAR responsible for SC520CDP Flash Bank #1
[    6.214205] Trying default address 0x8c00000
[    6.214816] SC520 CDP flash device: 0x800000 at 0x8800000
[    6.215569] Failed to ioremap_nocache
[    6.216091] NetSc520 flash device: 0x100000 at 0x200000
[    6.216801] Failed to ioremap_nocache
[    6.217321] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    6.218493] slram: not enough parameters.
[    6.283494] No valid DiskOnChip devices found
[    6.284196] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    6.285495] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    6.286784] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    6.288077] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    6.289362] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    6.290659] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    6.291960] NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba N=
AND 128MiB 1,8V 8-bit), 128MiB, page size: 512, OOB size: 16
[    6.293659] flash size: 128 MiB
[    6.294112] page size: 512 bytes
[    6.294556] OOB area size: 16 bytes
[    6.295055] sector size: 16 KiB
[    6.295488] pages number: 262144
[    6.295938] pages per sector: 32
[    6.296402] bus width: 8
[    6.296760] bits in sector size: 14
[    6.297254] bits in page size: 9
[    6.297706] bits in OOB size: 4
[    6.298157] flash size with OOB: 135168 KiB
[    6.298734] page address bytes: 4
[    6.299208] sector address bytes: 3
[    6.299692] options: 0x42
[    6.303938] Scanning device for bad blocks
[    6.320719] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    6.321576] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    6.323942] dmascc: autoprobing (dangerous)
[    6.376027] dmascc: no adapters found
[    6.376535] AX.25: Z8530 SCC driver version 3.0.dl1bke
[    6.377759] AX.25: 6pack driver, Revision: 0.3.0
[    6.378415] YAM driver version 0.8 by F1OAT/F6FBB
[    6.380206] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    6.380206] baycom_ser_hdx: version 0.10
[    6.382803] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[    6.383613] hdlcdrv: version 0.8
[    6.384073] baycom_epp: (C) 1998-2000 Thomas Sailer, HB9JNX/AE4WA
[    6.384073] baycom_epp: version 0.7
[    6.386873] w83977af_init()
[    6.387289] w83977af_open()
[    6.387683] w83977af_probe()
[    6.388196] w83977af_probe(), Wrong chip version
[    6.388809] w83977af_probe()
[    6.389364] w83977af_probe(), Wrong chip version
[    6.390441] irda_register_dongle : registering dongle "Actisys ACT-220L"=
 (2).
[    6.391485] irda_register_dongle : registering dongle "Actisys ACT-220L+=
" (3).
[    6.392489] irda_register_dongle : registering dongle "Parallax LiteLink=
" (5).
[    6.393490] irda_register_dongle : registering dongle "Greenwich GIrBIL"=
 (4).
[    6.394487] irda_register_dongle : registering dongle "Old Belkin SmartB=
eam" (7).
[    6.395525] irda_register_dongle : registering dongle "Microchip MCP2120=
" (9).
[    6.396537] irda_register_dongle : registering dongle "ACTiSYS ACT-IR200=
L" (10).
[    6.397566] irda_register_dongle : registering dongle "Vishay TOIM3232" =
(12).
[    6.399101] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    6.400967] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.401788] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.402770] parkbd: no such parport
[    6.472843] mousedev: PS/2 mouse device common for all mice
[    6.473778] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    6.475533] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    6.476809] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    6.478842] walkera0701: parport 0 does not exist
[    6.480234] rtc_cmos 00:00: RTC can wake from S4
[    6.481398] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    6.482387] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    6.486442] rtc-test rtc-test.0: rtc core: registered test as rtc1
[    6.487501] rtc-test rtc-test.1: rtc core: registered test as rtc2
[    6.488491] i2c /dev entries driver
[    6.489384] i2c-parport: adapter type unspecified
[    6.492319] lirc_dev: IR Remote Control driver registered, major 245=20
[    6.493231] IR RC5(x) protocol handler initialized
[    6.493890] IR RC6 protocol handler initialized
[    6.494528] IR JVC protocol handler initialized
[    6.495165] IR Sony protocol handler initialized
[    6.495805] IR RC5 (streamzap) protocol handler initialized
[    6.496580] IR MCE Keyboard/mouse protocol handler initialized
[    6.497470] smssdio: Siano SMS1xxx SDIO driver
[    6.498166] smssdio: Copyright Pierre Ossman
[    6.499044] pps pps0: new PPS source ktimer
[    6.499629] pps pps0: ktimer PPS source registered
[    6.500301] pps_ldisc: PPS line discipline registered
[    6.500990] pps_parport: parallel port PPS client
[    6.501680] Driver for 1-wire Dallas network protocol.
[    6.502576] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    6.503958] power_supply test_ac: uevent
[    6.504519] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    6.505321] power_supply test_ac: prop ONLINE=3D1
[    6.505978] power_supply test_ac: power_supply_changed
[    6.506724] power_supply test_ac: power_supply_changed_work
[    6.507509] power_supply test_ac: uevent
[    6.508067] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    6.508855] power_supply test_ac: prop ONLINE=3D1
[    6.509560] power_supply test_battery: uevent
[    6.510180] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    6.511092] power_supply test_battery: prop STATUS=3DDischarging
[    6.511889] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    6.512689] power_supply test_battery: prop HEALTH=3DGood
[    6.513419] power_supply test_battery: prop PRESENT=3D1
[    6.514155] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    6.514941] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    6.515815] power_supply test_battery: prop CHARGE_FULL=3D100
[    6.516600] power_supply test_battery: prop CHARGE_NOW=3D50
[    6.517351] power_supply test_battery: prop CAPACITY=3D50
[    6.518080] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    6.518909] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    6.519777] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    6.520632] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    6.521503] power_supply test_battery: prop MANUFACTURER=3DLinux
[    6.522322] power_supply test_battery: prop SERIAL_NUMBER=3D3.12.0-rc2-0=
2842-g45c4ea0
[    6.523375] power_supply test_battery: prop TEMP=3D26
[    6.524060] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    6.525068] power_supply test_battery: power_supply_changed
[    6.525835] power_supply test_battery: power_supply_changed_work
[    6.526682] power_supply test_battery: uevent
[    6.527296] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    6.528218] power_supply test_battery: prop STATUS=3DDischarging
[    6.529031] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    6.529801] power_supply test_battery: prop HEALTH=3DGood
[    6.531110] power_supply test_usb: uevent
[    6.531690] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    6.532524] power_supply test_usb: prop ONLINE=3D1
[    6.533211] power_supply test_usb: power_supply_changed
[    6.534962] w83781d: Detection failed at step 2
[    6.535631] power_supply test_battery: prop PRESENT=3D1
[    6.536340] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    6.537143] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    6.537989] power_supply test_battery: prop CHARGE_FULL=3D100
[    6.538778] power_supply test_battery: prop CHARGE_NOW=3D50
[    6.539539] power_supply test_battery: prop CAPACITY=3D50
[    6.540883] applesmc: supported laptop not found!
[    6.541558] applesmc: driver init failed (ret=3D-19)!
[    6.544048] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    6.544890] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    6.545759] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    6.546612] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    6.547479] power_supply test_battery: prop MANUFACTURER=3DLinux
[    6.548879] pc87360: PC8736x not detected, module not inserted
[    6.550079] md: linear personality registered for level -1
[    6.550833] md: raid1 personality registered for level 1
[    6.551579] md: raid10 personality registered for level 10
[    6.552359] power_supply test_battery: prop SERIAL_NUMBER=3D3.12.0-rc2-0=
2842-g45c4ea0
[    6.553423] power_supply test_battery: prop TEMP=3D26
[    6.554110] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    6.554918] power_supply test_usb: power_supply_changed_work
[    6.555964] power_supply test_usb: uevent
[    6.556542] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    6.557363] power_supply test_usb: prop ONLINE=3D1
[    6.558064] md: raid6 personality registered for level 6
[    6.558792] md: raid5 personality registered for level 5
[    6.559538] md: raid4 personality registered for level 4
[    6.560462] device-mapper: uevent: version 1.0.3
[    6.561358] device-mapper: ioctl: 4.26.0-ioctl (2013-08-15) initialised:=
 dm-devel@redhat.com
[    6.562914] device-mapper: dm-log-userspace: version 1.1.0 loaded
[    6.563777] device-mapper: raid: Loading target version 1.5.2
[    6.564598] device-mapper: cache-policy-mq: version 1.0.0 loaded
[    6.565440] device-mapper: cache cleaner: version 1.0.0 loaded
[    6.566251] Bluetooth: Virtual HCI driver ver 1.4
[    6.566959] Bluetooth: HCI UART driver ver 2.2
[    6.567588] Bluetooth: HCI H4 protocol initialized
[    6.568261] Bluetooth: HCIATH3K protocol initialized
[    6.568939] Bluetooth: HCI Three-wire UART (H5) protocol initialized
[    6.569844] cpufreq-nforce2: No nForce2 chipset.
[    6.570594] sdhci: Secure Digital Host Controller Interface driver
[    6.571452] sdhci: Copyright(c) Pierre Ossman
[    6.572065] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    6.572869] wbsd: Copyright(c) Pierre Ossman
[    6.575515] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    6.579366] goldfish_pdev_bus goldfish_pdev_bus: unable to reserve Goldf=
ish MMIO.
[    6.580414] goldfish_pdev_bus: probe of goldfish_pdev_bus failed with er=
ror -16
[    6.584686] NET: Registered protocol family 26
[    6.585335] NET: Registered protocol family 17
[    6.586068] NET: Registered protocol family 4
[    6.586802] NET: Registered protocol family 5
[    6.587421] NET: Registered protocol family 3
[    6.588051] IrCOMM protocol (Dag Brattli)
[    6.591931] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    6.592776] Bluetooth: HIDP socket layer initialized
[    6.593471] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[    6.594612] DECnet: Routing cache hash table of 256 buckets, 9Kbytes
[    6.595509] NET: Registered protocol family 12
[    6.597111] 9pnet: Installing 9P2000 support
[    6.597863] NET: Registered protocol family 37
[    6.598509] NET: Registered protocol family 36
[    6.599266] Key type dns_resolver registered
[    6.599858] openvswitch: Open vSwitch switching datapath
[    6.601439] Using IPI Shortcut mode
[    6.603847] Key type trusted registered
[    6.606160] Key type encrypted registered
[    6.608314] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    6.609160] EDD information not available.
[    6.610712] debug: unmapping init [mem 0x41d95000-0x41e08fff]
[    6.612196] Write protecting the kernel text: 9752k
[    6.613078] Write protecting the kernel read-only data: 3444k
[    6.647222] BUG: unable to handle kernel paging request at 08000060
[    6.648030] IP: [<41046ab0>] task_work_run+0x60/0xa0
[    6.648030] *pde =3D 0686f067 *pte =3D 00000000=20
[    6.648030] Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
[    6.648030] CPU: 0 PID: 131 Comm: rc.local Not tainted 3.12.0-rc2-02842-=
g45c4ea0 #2
[    6.648030] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    6.648030] task: 46865000 ti: 46874000 task.ti: 46874000
[    6.648030] EIP: 0060:[<41046ab0>] EFLAGS: 00010206 CPU: 0
[    6.648030] EIP is at task_work_run+0x60/0xa0
[    6.648030] EAX: 08000060 EBX: 46862f40 ECX: 00000000 EDX: 08000060
[    6.648030] ESI: 468652ac EDI: 46865000 EBP: 46875f9c ESP: 46875f90
[    6.648030]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    6.648030] CR0: 8005003b CR2: 08000060 CR3: 0686e000 CR4: 00000690
[    6.648030] Stack:
[    6.648030]  396f7903 396e0ee8 37642ff4 46875fac 41002310 41984ebc 4fff0=
1bc 46874000
[    6.648030]  419848e6 00000000 00000000 00000000 00000000 00000000 00000=
000 00000000
[    6.648030]  0000007b 0000007b 00000000 00000000 0000000b 377a01d0 00000=
073 00000200
[    6.648030] Call Trace:
[    6.648030]  [<41002310>] do_notify_resume+0x50/0x60
[    6.648030]  [<41984ebc>] ? sysenter_do_call+0x1e/0x37
[    6.648030]  [<419848e6>] work_notifysig+0x26/0x30
[    6.648030] Code: eb 0b 89 f6 8d bc 27 00 00 00 00 31 c9 89 d0 0f b1 0e =
39 c2 75 d5 85 d2 74 46 90 f3 90 8b 87 e4 02 00 00 85 c0 74 f4 31 db 66 90 =
<8b> 02 89 1a 85 c0 74 08 89 d3 89 c2 eb f2 66 90 89 d0 ff 52 04
[    6.648030] EIP: [<41046ab0>] task_work_run+0x60/0xa0 SS:ESP 0068:46875f=
90
[    6.648030] CR2: 0000000008000060
[    6.678032] CRED: Invalid credentials
[    6.678556] CRED: At include/linux/cred.h:247
[    6.679461] CRED: Specified credentials: 4684e680=20
[    6.680132] CRED: ->magic=3D44656144, put_addr=3D410b3057
[    6.680822] CRED: ->usage=3D0, subscr=3D0
[    6.681342] CRED: ->*uid =3D { 0,0,0,0 }
[    6.681862] CRED: ->*gid =3D { 0,0,0,0 }
[    6.682398] ------------[ cut here ]------------
[    6.683032] Kernel BUG at 4104eed1 [verbose debug info unavailable]
[    6.683387] invalid opcode: 0000 [#2] PREEMPT DEBUG_PAGEALLOC
[    6.683387] CPU: 0 PID: 10 Comm: rcuop/0 Tainted: G      D      3.12.0-r=
c2-02842-g45c4ea0 #2
[    6.683387] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    6.683387] task: 4d437000 ti: 4d448000 task.ti: 4d448000
[    6.683387] EIP: 0060:[<4104eed1>] EFLAGS: 00010212 CPU: 0
[    6.683387] EIP is at __invalid_creds+0x41/0x50
[    6.683387] EAX: 0000001a EBX: 4684e680 ECX: 41059395 EDX: 00000201
[    6.683387] ESI: 41bd90ac EDI: 000000f7 EBP: 4d449ed0 ESP: 4d449eb8
[    6.683387]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    6.683387] CR0: 8005003b CR2: 377f8854 CR3: 0686a000 CR4: 00000690
[    6.683387] Stack:
[    6.683387]  41bd7b3d 41bd90ac 000000f7 4684e680 4686bb00 00000003 4d449=
ee0 410b3026
[    6.683387]  4686bb00 07580180 4d449f34 41074e62 00000000 41cf3d30 4d437=
000 4685e7c0
[    6.683387]  41cf3d18 41cf3d20 41cf3d24 00000ffe 41cf3c80 4686bb00 00000=
000 00000000
[    6.683387] Call Trace:
[    6.683387]  [<410b3026>] file_free_rcu+0x26/0x60
[    6.683387]  [<41074e62>] rcu_nocb_kthread+0x262/0x2e0
[    6.683387]  [<41049ec0>] ? abort_exclusive_wait+0x70/0x70
[    6.683387]  [<41074c00>] ? rcu_start_gp+0x30/0x30
[    6.683387]  [<41049513>] kthread+0x83/0xa0
[    6.683387]  [<41984e1b>] ret_from_kernel_thread+0x1b/0x30
[    6.683387]  [<41049490>] ? __kthread_unpark+0x40/0x40
[    6.683387] Code: e8 1f 23 92 00 89 7c 24 08 89 74 24 04 c7 04 24 3d 7b =
bd 41 e8 0b 23 92 00 8b 0d cc b9 ce 41 ba 4f 7b bd 41 89 d8 e8 af fc ff ff =
<0f> 0b 8d b6 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5 53 8b 15
[    6.683387] EIP: [<4104eed1>] __invalid_creds+0x41/0x50 SS:ESP 0068:4d44=
9eb8
[    6.706352] ---[ end trace d18e1b694b8f9417 ]---
[    6.706982] Kernel panic - not syncing: Fatal exception in interrupt
[    6.707344] Rebooting in 10 seconds..
BUG: kernel boot oops
Elapsed time: 15
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-j=
4-09302234/45c4ea0c4c1b8abffb575b865243fd1c69bbecd9/vmlinuz-3.12.0-rc2-0284=
2-g45c4ea0 -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_timeout=3D100=
 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_pr=
intk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,11=
5200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/=
run-queue/kvm/i386-randconfig-j4-09302234/next:master/.vmlinuz-45c4ea0c4c1b=
8abffb575b865243fd1c69bbecd9-20131001090102-5-bay branch=3Dnext/master BOOT=
_IMAGE=3D/kernel/i386-randconfig-j4-09302234/45c4ea0c4c1b8abffb575b865243fd=
1c69bbecd9/vmlinuz-3.12.0-rc2-02842-g45c4ea0'  -initrd /kernel-tests/initrd=
/quantal-core-i386.cgz -m 256M -smp 2 -net nic,vlan=3D0,macaddr=3D00:00:00:=
00:00:00,model=3Dvirtio -net user,vlan=3D0,hostfwd=3Dtcp::18061-:22 -net ni=
c,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -wa=
tchdog i6300esb -soundhw hda -drive file=3D/fs/sda3/disk0-quantal-bay-1,med=
ia=3Ddisk,if=3Dvirtio -drive file=3D/fs/sda3/disk1-quantal-bay-1,media=3Ddi=
sk,if=3Dvirtio -drive file=3D/fs/sda3/disk2-quantal-bay-1,media=3Ddisk,if=
=3Dvirtio -drive file=3D/fs/sda3/disk3-quantal-bay-1,media=3Ddisk,if=3Dvirt=
io -drive file=3D/fs/sda3/disk4-quantal-bay-1,media=3Ddisk,if=3Dvirtio -dri=
ve file=3D/fs/sda3/disk5-quantal-bay-1,media=3Ddisk,if=3Dvirtio -pidfile /d=
ev/shm/kboot/pid-quantal-bay-1 -serial file:/dev/shm/kboot/serial-quantal-b=
ay-1 -daemonize -display none -monitor null=20

--MGYHOYXEY6WxJCY8
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-45c4ea0c4c1b8abffb575b865243fd1c69bbecd9-i386-randconfig-j4-09302234-BUG:-unable-to-handle-kernel-7881.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDQ1YzRlYTBjNGMxYjhhYmZmYjU3NWI4NjUyNDNmZDFjNjliYmVjZDkK
SEVBRCBpcyBub3cgYXQgNDVjNGVhMC4uLiBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNo
ICdsem8tdXBkYXRlL2x6by11cGRhdGUnCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWctajQtMDkzMDIyMzQvbmV4dDptYXN0ZXI6NDVjNGVhMGM0
YzFiOGFiZmZiNTc1Yjg2NTI0M2ZkMWM2OWJiZWNkOTpiaXNlY3QtdXNiCiBURVNUIEZBSUxV
UkUKQlVHOiBrZXJuZWwgZWFybHkgaGFuZyB3aXRob3V0IGFueSBwcmludGsgb3V0cHV0CkNv
bW1hbmQgbGluZTogaHVuZ190YXNrX3BhbmljPTEgcmN1dHJlZS5yY3VfY3B1X3N0YWxsX3Rp
bWVvdXQ9MTAwIGxvZ19idWZfbGVuPThNIGlnbm9yZV9sb2dsZXZlbCBkZWJ1ZyBzY2hlZF9k
ZWJ1ZyBhcGljPWRlYnVnIGR5bmFtaWNfcHJpbnRrIHN5c3JxX2Fsd2F5c19lbmFibGVkIHBh
bmljPTEwICBwcm9tcHRfcmFtZGlzaz0wIGNvbnNvbGU9dHR5UzAsMTE1MjAwIGNvbnNvbGU9
dHR5MCB2Z2E9bm9ybWFsICByb290PS9kZXYvcmFtMCBydyBsaW5rPS9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajQtMDkzMDIyMzQvbmV4dDptYXN0ZXIv
LnZtbGludXotNDVjNGVhMGM0YzFiOGFiZmZiNTc1Yjg2NTI0M2ZkMWM2OWJiZWNkOS0yMDEz
MTAwMTAyMzcxMS02LWFudCBicmFuY2g9bmV4dC9tYXN0ZXIgQk9PVF9JTUFHRT0va2VybmVs
L2kzODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIzNC80NWM0ZWEwYzRjMWI4YWJmZmI1NzViODY1
MjQzZmQxYzY5YmJlY2Q5L3ZtbGludXotMy4xMi4wLXJjMi0wMjg0Mi1nNDVjNGVhMCBub2Fw
aWMgbm9sYXBpYyBub2h6PW9mZgpFYXJseSBoYW5nIGtlcm5lbDogdm1saW51ei0zLjEyLjAt
cmMyLTAyODQyLWc0NWM0ZWEwIDMuMTIuMC1yYzItMDI4NDItZzQ1YzRlYTAgIzIKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctajQtMDkzMDIyMzQvNDVjNGVhMGM0YzFiOGFiZmZiNTc1Yjg2
NTI0M2ZkMWM2OWJiZWNkOS9kbWVzZy1xdWFudGFsLWJheS0xOjIwMTMxMDAxMTAyNTQ3OjMu
MTIuMC1yYzItMDI4NDItZzQ1YzRlYTA6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0w
OTMwMjIzNC80NWM0ZWEwYzRjMWI4YWJmZmI1NzViODY1MjQzZmQxYzY5YmJlY2Q5L2RtZXNn
LXF1YW50YWwtamFrZXRvd24tMTE6MjAxMzEwMDEwOTAxNTg6My4xMi4wLXJjMi0wMjg0Mi1n
NDVjNGVhMDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA5MzAyMjM0LzQ1YzRlYTBj
NGMxYjhhYmZmYjU3NWI4NjUyNDNmZDFjNjliYmVjZDkvZG1lc2ctcXVhbnRhbC1qYWtldG93
bi0xOToyMDEzMTAwMTAyNDA1NjozLjEyLjAtcmMyLTAyODQyLWc0NWM0ZWEwOjIKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctajQtMDkzMDIyMzQvNDVjNGVhMGM0YzFiOGFiZmZiNTc1Yjg2
NTI0M2ZkMWM2OWJiZWNkOS9kbWVzZy1xdWFudGFsLWxrcC10dDAyLTIyOjIwMTMwOTMwMjAw
ODQ1OjMuMTIuMC1yYzItMDI4NDItZzQ1YzRlYTA6Mgova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1qNC0wOTMwMjIzNC80NWM0ZWEwYzRjMWI4YWJmZmI1NzViODY1MjQzZmQxYzY5YmJlY2Q5
L2RtZXNnLXF1YW50YWwtbmhtNC0yOjIwMTMxMDAxMDUxNTA1OjMuMTIuMC1yYzItMDI4NDIt
ZzQ1YzRlYTA6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIzNC80NWM0ZWEw
YzRjMWI4YWJmZmI1NzViODY1MjQzZmQxYzY5YmJlY2Q5L2RtZXNnLXF1YW50YWwtbmhtNC0y
OjIwMTMxMDAxMDUxNTM2OjMuMTIuMC1yYzItMDI4NDItZzQ1YzRlYTA6Mgova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIzNC80NWM0ZWEwYzRjMWI4YWJmZmI1NzViODY1MjQz
ZmQxYzY5YmJlY2Q5L2RtZXNnLXF1YW50YWwtd2FpbWVhLTEwOjIwMTMxMDAxMTA0MzUwOjMu
MTIuMC1yYzItMDI4NDItZzQ1YzRlYTA6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0w
OTMwMjIzNC80NWM0ZWEwYzRjMWI4YWJmZmI1NzViODY1MjQzZmQxYzY5YmJlY2Q5L2RtZXNn
LXF1YW50YWwtd2FpbWVhLTE0OjIwMTMxMDAxMTMzODU0OjMuMTIuMC1yYzItMDI4NDItZzQ1
YzRlYTA6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIzNC80NWM0ZWEwYzRj
MWI4YWJmZmI1NzViODY1MjQzZmQxYzY5YmJlY2Q5L2RtZXNnLXF1YW50YWwteGlhbi0zOToy
MDEzMTAwMTA5MDk0NjozLjEyLjAtcmMyLTAyODQyLWc0NWM0ZWEwOjIKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctajQtMDkzMDIyMzQvNDVjNGVhMGM0YzFiOGFiZmZiNTc1Yjg2NTI0M2Zk
MWM2OWJiZWNkOS9kbWVzZy1xdWFudGFsLXhwcy00OjIwMTMxMDAxMDU0MDAxOjMuMTIuMC1y
YzItMDI4NDItZzQ1YzRlYTA6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIz
NC80NWM0ZWEwYzRjMWI4YWJmZmI1NzViODY1MjQzZmQxYzY5YmJlY2Q5L2RtZXNnLXF1YW50
YWwteHBzLTQ6MjAxMzEwMDEwNTQwMTY6My4xMi4wLXJjMi0wMjg0Mi1nNDVjNGVhMDoyCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA5MzAyMjM0LzQ1YzRlYTBjNGMxYjhhYmZmYjU3
NWI4NjUyNDNmZDFjNjliYmVjZDkvZG1lc2ctcXVhbnRhbC14cHMtNzoyMDEzMTAwMTA1NDAx
NzozLjEyLjAtcmMyLTAyODQyLWc0NWM0ZWEwOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
ajQtMDkzMDIyMzQvNDVjNGVhMGM0YzFiOGFiZmZiNTc1Yjg2NTI0M2ZkMWM2OWJiZWNkOS9k
bWVzZy15b2N0by1hbnQtMTQ6MjAxMzEwMDEwOTAzMTM6My4xMi4wLXJjMi0wMjg0Mi1nNDVj
NGVhMDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA5MzAyMjM0LzQ1YzRlYTBjNGMx
YjhhYmZmYjU3NWI4NjUyNDNmZDFjNjliYmVjZDkvZG1lc2cteW9jdG8tYmF5LTQ6MjAxMzEw
MDEwOTA0MDk6My4xMi4wLXJjMi0wMjg0Mi1nNDVjNGVhMDoyCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWo0LTA5MzAyMjM0LzQ1YzRlYTBjNGMxYjhhYmZmYjU3NWI4NjUyNDNmZDFjNjli
YmVjZDkvZG1lc2cteW9jdG8tbGtwLXR0MDItMzoyMDEzMDkzMDE3MTIxNzozLjEyLjAtcmMy
LTAyODQyLWc0NWM0ZWEwOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDkzMDIyMzQv
NDVjNGVhMGM0YzFiOGFiZmZiNTc1Yjg2NTI0M2ZkMWM2OWJiZWNkOS9kbWVzZy15b2N0by1u
aG00LTQ6MjAxMzA5MzAyMTQwMTU6My4xMi4wLXJjMi0wMjg0Mi1nNDVjNGVhMDoyCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA5MzAyMjM0LzQ1YzRlYTBjNGMxYjhhYmZmYjU3NWI4
NjUyNDNmZDFjNjliYmVjZDkvZG1lc2cteW9jdG8td2FpbWVhLTU6MjAxMzEwMDEyMTEyMTc6
My4xMi4wLXJjMi0wMjg0Mi1nNDVjNGVhMDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0
LTA5MzAyMjM0LzQ1YzRlYTBjNGMxYjhhYmZmYjU3NWI4NjUyNDNmZDFjNjliYmVjZDkvZG1l
c2cteW9jdG8td2FpbWVhLTg6MjAxMzEwMDIwNDU1NDg6My4xMi4wLXJjMi0wMjg0Mi1nNDVj
NGVhMDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA5MzAyMjM0LzQ1YzRlYTBjNGMx
YjhhYmZmYjU3NWI4NjUyNDNmZDFjNjliYmVjZDkvZG1lc2cteW9jdG8teGlhbi0yODoyMDEz
MTAwMTA5MDkzOTozLjEyLjAtcmMyLTAyODQyLWc0NWM0ZWEwOjIKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctajQtMDkzMDIyMzQvNDVjNGVhMGM0YzFiOGFiZmZiNTc1Yjg2NTI0M2ZkMWM2
OWJiZWNkOS9kbWVzZy15b2N0by14cHMtNToyMDEzMTAwMTA1MzkzODozLjEyLjAtcmMyLTAy
ODQyLWc0NWM0ZWEwOjIKCmJpc2VjdDogYmFkIGNvbW1pdCA0NWM0ZWEwYzRjMWI4YWJmZmI1
NzViODY1MjQzZmQxYzY5YmJlY2Q5CmdpdCBjaGVja291dCB2My4xMQpQcmV2aW91cyBIRUFE
IHBvc2l0aW9uIHdhcyA0NWM0ZWEwLi4uIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2gg
J2x6by11cGRhdGUvbHpvLXVwZGF0ZScKSEVBRCBpcyBub3cgYXQgNmU0NjY0NS4uLiBMaW51
eCAzLjExCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctajQtMDkzMDIyMzQvbmV4dDptYXN0ZXI6NmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3
ZjcwYTk0YzE5MjEzZTpiaXNlY3QtdXNiCgoyMDEzLTEwLTAxLTIxOjAwOjExIDZlNDY2NDUy
NWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UgY29tcGlsaW5nCjI5NyByZWFsICAx
MTc0IHVzZXIgIDEzNyBzeXMgIDQ0MS4yNSUgY3B1IAlpMzg2LXJhbmRjb25maWctajQtMDkz
MDIyMzQKCjIwMTMtMTAtMDEtMjE6MDU6MzggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4w
Li4uLgkxCTIJMwk1CTYJOQkxMAkxMi4JMTMJMTQJMTUJMTYuCTE3CTE4CTIxCTIzCTI1CTI3
CTMxLi4uCTMyLi4uLi4uLi4uLi4uCTE0MwkxNDgJMTUwIFNVQ0NFU1MKCmJpc2VjdDogZ29v
ZCBjb21taXQgdjMuMTEKZ2l0IGJpc2VjdCBzdGFydCA0NWM0ZWEwYzRjMWI4YWJmZmI1NzVi
ODY1MjQzZmQxYzY5YmJlY2Q5IHYzLjExIC0tClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2Fz
IDZlNDY2NDUuLi4gTGludXggMy4xMQpIRUFEIGlzIG5vdyBhdCBjMWJlNWE1Li4uIExpbnV4
IDMuOQpCaXNlY3Rpbmc6IDY2NDggcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlz
IChyb3VnaGx5IDEzIHN0ZXBzKQpbMzllZGEyYWJhNmJlNjQyYjcxZjJlMGFkNjIzZGNiMDlm
ZDlkNzljZl0gTWVyZ2UgYnJhbmNoICduZXh0JyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9w
dWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvYmVuaC9wb3dlcnBjCmdpdCBiaXNlY3QgcnVuIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3Vz
Yi9vYmotYmlzZWN0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIzNC9uZXh0Om1hc3Rl
cjozOWVkYTJhYmE2YmU2NDJiNzFmMmUwYWQ2MjNkY2IwOWZkOWQ3OWNmOmJpc2VjdC11c2IK
CjIwMTMtMTAtMDEtMjE6Mjc6NTMgMzllZGEyYWJhNmJlNjQyYjcxZjJlMGFkNjIzZGNiMDlm
ZDlkNzljZiBjb21waWxpbmcKMTk2IHJlYWwgIDEyNDkgdXNlciAgMTE5IHN5cyAgNjk2Ljgy
JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIzNAoKMjAxMy0xMC0wMS0yMTozMToy
NSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAtMDY3MzktZzM5ZWRhMmEuLi4uCTEJMi4u
Li4uCTMuLi4uCTQuCTUJNi4uLi4uLi4JNwk5CTEwLi4uLgkxMS4uCTEyLgkxNQkxNgkxNy4J
MTkJMjIuCTIzLi4uCTI0CTI2CTMwCTMyLgkzNAkzOC4uCTQzCTQ3CTQ5CTUyCTUzCTU2CTU3
Lgk2MQk2Mgk5MAkxMTAJMTIyCTEzMAkxNDYuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uG1sxOzM1bWFkZF90b19ydW5fcXVldWUgNBtbMG0KLi4uCTE0Ny4JMTQ5CTE1MCBTVUND
RVNTCgpCaXNlY3Rpbmc6IDMzMjMgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlz
IChyb3VnaGx5IDEyIHN0ZXBzKQpbYmZmMTU3YjNhZDRiOWY2YmUwYWY2OTg3ZmNkNjJkZWFm
MGYyYjc5OV0gTWVyZ2UgYnJhbmNoICdzbGFiL25leHQnIG9mIGdpdDovL2dpdC5rZXJuZWwu
b3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9wZW5iZXJnL2xpbnV4CnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNi
L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFu
ZGNvbmZpZy1qNC0wOTMwMjIzNC9uZXh0Om1hc3RlcjpiZmYxNTdiM2FkNGI5ZjZiZTBhZjY5
ODdmY2Q2MmRlYWYwZjJiNzk5OmJpc2VjdC11c2IKCjIwMTMtMTAtMDItMDA6NDI6MzQgYmZm
MTU3YjNhZDRiOWY2YmUwYWY2OTg3ZmNkNjJkZWFmMGYyYjc5OSBjb21waWxpbmcKMjA2IHJl
YWwgIDEzMTEgdXNlciAgMTI0IHN5cyAgNjk2LjI1JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1q
NC0wOTMwMjIzNAoKMjAxMy0xMC0wMi0wMDo0NjoxNCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAz
LjExLjAtMTAwNjQtZ2JmZjE1N2IuLgkyCTQJNQkxMAkxMS4JMTIJMTMJMTQuCTE1LgkxOQky
NQkyNy4JMzAJMzEuCTMyCTMzCTM0CTM1CTM2CTM3LgkzOAk0MAk0Mi4uLgk0My4uCTQ2Li4u
Li4uCTQ3CTQ4Li4uLgk1MQk1Mgk1NQk1Ni4JNzkJMTM3CTE0Ny4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSAzG1swbQouLgkxNDkJMTUw
IFNVQ0NFU1MKCkJpc2VjdGluZzogMTU5NSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgMTEgc3RlcHMpCltmNjU5YTRmMTdiYmVjZGJhZDU3ZGQ1YzYzYTE3
ODNlNWVjNWZkNzkyXSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdkcm0taW50ZWwv
Zm9yLWxpbnV4LW5leHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJv
b3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10
ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIzNC9uZXh0Om1h
c3RlcjpmNjU5YTRmMTdiYmVjZGJhZDU3ZGQ1YzYzYTE3ODNlNWVjNWZkNzkyOmJpc2VjdC11
c2IKCjIwMTMtMTAtMDItMDM6NDc6NTYgZjY1OWE0ZjE3YmJlY2RiYWQ1N2RkNWM2M2ExNzgz
ZTVlYzVmZDc5MiBjb21waWxpbmcKMTk3IHJlYWwgIDEzMjEgdXNlciAgMTI3IHN5cyAgNzM1
LjcyJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIzNAoKMjAxMy0xMC0wMi0wMzo1
MjoyNSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmMyLTAxMjQ2LWdmNjU5YTRmLi4u
LgkxCTEyCTE0CTE1CTE5CTI1CTI4CTMwCTMxCTMzCTM4CTQxCTQ0CTQ4CTUwCTU0Li4uCTU1
CTU2CTYxLgk2Mgk2OAk3NQk5OAkxMDUJMTQzLgkxNDUuLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uG1sxOzM1bWFkZF90b19ydW5fcXVldWUgNRtbMG0KLi4uCTE0Ny4uCTE0OC4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSAy
G1swbQouLi4JMTQ5CTE1MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDc5OCByZXZpc2lvbnMgbGVm
dCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTAgc3RlcHMpCls2NDA1Y2Q1OGFjNWMw
YTZlZDVmNGYxMzA4ODkyMTQ3ODcwYjlkNWNmXSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJh
bmNoICdyZWdtYXAvZm9yLW5leHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIzNC9u
ZXh0Om1hc3Rlcjo2NDA1Y2Q1OGFjNWMwYTZlZDVmNGYxMzA4ODkyMTQ3ODcwYjlkNWNmOmJp
c2VjdC11c2IKCjIwMTMtMTAtMDItMDk6MTc6MDMgNjQwNWNkNThhYzVjMGE2ZWQ1ZjRmMTMw
ODg5MjE0Nzg3MGI5ZDVjZiBjb21waWxpbmcKMjA2IHJlYWwgIDEyOTggdXNlciAgMTIxIHN5
cyAgNjg4LjI5JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIzNAoKMjAxMy0xMC0w
Mi0wOToyMDo0NCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmMyLTAyMDQzLWc2NDA1
Y2Q1CTEuLiBURVNUIEZBSUxVUkUKCm1vdW50OiBtb3VudGluZyBwcm9jIG9uIC9wcm9jIGZh
aWxlZDogTm8gc3VjaCBkZXZpY2UKWyAgICAxLjYyMjk4Ml0gQlVHOiB1bmFibGUgdG8gaGFu
ZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgMDAwMDAwMGMKWyAgICAx
LjYyMzQ0MF0gSVA6IFs8NDEwMzk3MDA+XSBfX2RlcXVldWVfc2lnbmFsKzB4ODAvMHgxOTAK
WyAgICAxLjYyMzQ0MF0gKnBkZSA9IDAwMDAwMDAwIApbICAgIDEuNjIzNDQwXSBPb3BzOiAw
MDAwIFsjMV0gUFJFRU1QVCBERUJVR19QQUdFQUxMT0MKWyAgICAxLjYyMzQ0MF0gQ1BVOiAw
IFBJRDogMTMxIENvbW06IHJjUyBOb3QgdGFpbnRlZCAzLjEyLjAtcmMyLTAyMDQzLWc2NDA1
Y2Q1ICM0NDcKWyAgICAxLjYyMzQ0MF0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJ
T1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDEuNjIzNDQwXSB0YXNrOiA0Y2NjNjAwMCB0aTog
NGNjZDgwMDAgdGFzay50aTogNGNjZDgwMDAKWyAgICAxLjYyMzQ0MF0gRUlQOiAwMDYwOls8
NDEwMzk3MDA+XSBFRkxBR1M6IDAwMDEwMDAyIENQVTogMApbICAgIDEuNjIzNDQwXSBFSVAg
aXMgYXQgX19kZXF1ZXVlX3NpZ25hbCsweDgwLzB4MTkwClsgICAgMS42MjM0NDBdIEVBWDog
MDAwMDAwMDAgRUJYOiAwMDAwMDAxMSBFQ1g6IDRjY2Q5ZjBjIEVEWDogNGNjYzRiMDAKWyAg
ICAxLjYyMzQ0MF0gRVNJOiAwMDAwMDAwMCBFREk6IDRjY2FlMDM4IEVCUDogNGNjZDllNjgg
RVNQOiA0Y2NkOWU1NApbICAgIDEuNjIzNDQwXSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAw
MDAgR1M6IDAwMzMgU1M6IDAwNjgKWyAgICAxLjYyMzQ0MF0gQ1IwOiA4MDA1MDAzYiBDUjI6
IDAwMDAwMDBjIENSMzogMGNjZDQwMDAgQ1I0OiAwMDAwMDY5MApbICAgIDEuNjIzNDQwXSBT
dGFjazoKWyAgICAxLjYyMzQ0MF0gIDAwMDAwMDQ2IDRjY2Q5ZjBjIDAwMDAwMDAwIDRjY2M2
MDAwIDRjY2Q5ZjBjIDRjY2Q5ZTk4IDQxMDNhYzM4IDRjY2M2ZDg0ClsgICAgMS42MjM0NDBd
ICA0Y2NjNjAwMCA0Y2NkOWYwYyA0Y2NkOWU5OCA0MTk3ZWNkYSA0Y2NjNjI3MCAwMDAwMDAw
MSAwMDAwMDAwMCA0Y2NjNjAwMApbICAgIDEuNjIzNDQwXSAgNGNjZDlmMGMgNGNjZDllZDgg
NDEwM2MyMWMgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDEgMDAwMDAwMDAgNGNjZDllZjgK
WyAgICAxLjYyMzQ0MF0gQ2FsbCBUcmFjZToKWyAgICAxLjYyMzQ0MF0gIFs8NDEwM2FjMzg+
XSBkZXF1ZXVlX3NpZ25hbCsweDM4LzB4MWMwClsgICAgMS42MjM0NDBdICBbPDQxOTdlY2Rh
Pl0gPyBfcmF3X3NwaW5fbG9ja19pcnErMHg0YS8weDUwClsgICAgMS42MjM0NDBdICBbPDQx
MDNjMjFjPl0gZ2V0X3NpZ25hbF90b19kZWxpdmVyKzB4MjBjLzB4NWIwClsgICAgMS42MjM0
NDBdICBbPDQxMDAxOTc0Pl0gZG9fc2lnbmFsKzB4MzQvMHg5ODAKWyAgICAxLjYyMzQ0MF0g
IFs8NDEwNDlkODI+XSA/IHJlbW92ZV93YWl0X3F1ZXVlKzB4MjIvMHgzMApbICAgIDEuNjIz
NDQwXSAgWzw0MTAzYzcxNj5dID8gX19zZXRfY3VycmVudF9ibG9ja2VkKzB4MzYvMHg0MApb
ICAgIDEuNjIzNDQwXSAgWzw0MTk3ZWRmZD5dID8gX3Jhd19zcGluX3VubG9ja19pcnErMHgy
ZC8weDUwClsgICAgMS42MjM0NDBdICBbPDQxMDNjNzE2Pl0gPyBfX3NldF9jdXJyZW50X2Js
b2NrZWQrMHgzNi8weDQwClsgICAgMS42MjM0NDBdICBbPDQxMDNjODgzPl0gPyBzaWdwcm9j
bWFzaysweDgzLzB4YTAKWyAgICAxLjYyMzQ0MF0gIFs8NDEwM2M5MTM+XSA/IFN5U19ydF9z
aWdwcm9jbWFzaysweDczLzB4YzAKWyAgICAxLjYyMzQ0MF0gIFs8NDEwMDIyZTk+XSBkb19u
b3RpZnlfcmVzdW1lKzB4MjkvMHg2MApbICAgIDEuNjIzNDQwXSAgWzw0MTk3Zjk0MT5dID8g
c3lzY2FsbF9leGl0KzB4OC8weDIxClsgICAgMS42MjM0NDBdICBbPDQxOTdmYTI2Pl0gd29y
a19ub3RpZnlzaWcrMHgyNi8weDMwClsgICAgMS42MjM0NDBdIENvZGU6IDg5IGUyIDgxIGUy
IDAwIGUwIGZmIGZmIDgwIDYyIDA4IGZiIGU5IDFhIDAxIDAwIDAwIDhkIDc2IDAwIDhkIGJj
IDI3IDAwIDAwIDAwIDAwIDhiIDM3IDM5IGY3IDBmIDg0IGZhIDAwIDAwIDAwIDMxIGQyIDhk
IDc0IDI2IDAwIDwzYj4gNWUgMGMgNzUgMDYgODUgZDIgNzUgMTcgODkgZjIgOGIgMzYgMzkg
ZjcgNzUgZWYgOGQgNDMgZmYgMGYKWyAgICAxLjYyMzQ0MF0gRUlQOiBbPDQxMDM5NzAwPl0g
X19kZXF1ZXVlX3NpZ25hbCsweDgwLzB4MTkwIFNTOkVTUCAwMDY4OjRjY2Q5ZTU0ClsgICAg
MS42MjM0NDBdIENSMjogMDAwMDAwMDAwMDAwMDAwYwpbICAgIDEuNjIzNDQwXSAtLS1bIGVu
ZCB0cmFjZSAxMmIyNmJkYjZkNjM2ZTY4IF0tLS0KL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
ajQtMDkzMDIyMzQvNjQwNWNkNThhYzVjMGE2ZWQ1ZjRmMTMwODg5MjE0Nzg3MGI5ZDVjZi9k
bWVzZy15b2N0by1qYWtldG93bi0yMjoyMDEzMTAwMjA5MjE0MzozLjEyLjAtcmMyLTAyMDQz
LWc2NDA1Y2Q1OjQ0Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIzNC82NDA1
Y2Q1OGFjNWMwYTZlZDVmNGYxMzA4ODkyMTQ3ODcwYjlkNWNmL2RtZXNnLXlvY3RvLWpha2V0
b3duLTQ4OjIwMTMxMDAyMDkyMTMxOjMuMTIuMC1yYzItMDIwNDMtZzY0MDVjZDU6NDQ3Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA5MzAyMjM0LzY0MDVjZDU4YWM1YzBhNmVkNWY0
ZjEzMDg4OTIxNDc4NzBiOWQ1Y2YvZG1lc2cteW9jdG8tY2Fpcm8tMTk6MjAxMzEwMDIwOTIy
MDE6My4xMi4wLXJjMi0wMjA0My1nNjQwNWNkNTo0NDcKCkJpc2VjdGluZzogMzU3IHJldmlz
aW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA5IHN0ZXBzKQpbNTA5NDAw
MWJjNDY0YzEyZDNlMDRlYjczYTVlMGQ1ZTg0MzZmMDlmN10gTWVyZ2UgcmVtb3RlLXRyYWNr
aW5nIGJyYW5jaCAnb21hcF9kc3MyL2Zvci1uZXh0JwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0
cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0
CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajQt
MDkzMDIyMzQvbmV4dDptYXN0ZXI6NTA5NDAwMWJjNDY0YzEyZDNlMDRlYjczYTVlMGQ1ZTg0
MzZmMDlmNzpiaXNlY3QtdXNiCgoyMDEzLTEwLTAyLTA5OjIyOjE4IDUwOTQwMDFiYzQ2NGMx
MmQzZTA0ZWI3M2E1ZTBkNWU4NDM2ZjA5ZjcgY29tcGlsaW5nCjE3OSByZWFsICAxMzA0IHVz
ZXIgIDEyMSBzeXMgIDc5NC45MiUgY3B1IAlpMzg2LXJhbmRjb25maWctajQtMDkzMDIyMzQK
CjIwMTMtMTAtMDItMDk6MjU6MzIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLXJjMi0w
MTY4NS1nNTA5NDAwMS4uCTEJNAk3CTguCTExCTEyCTEzCTE1CTE2LgkxNwkxOS4JMjEuLi4J
MjIuLi4uCTIzLi4uLi4uLgkyNi4JMjcJMjgJMzEuLi4uLi4JMzQJMzYJMzkuLgk0MAk0Ni4J
NjMJNjQJNjkJODIJMTA0CTExOQkxMjkJMTM4CTE0Mi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSA4G1swbQouLgkxNDQJMTUwIFNVQ0NF
U1MKCkJpc2VjdGluZzogMTU1IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAo
cm91Z2hseSA4IHN0ZXBzKQpbOGYzMTQxMGVlOTkxN2U4NjQ4YzdjZjdmNDVlMjIzMjBjMTY2
OTk4YV0gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnc3BpL2Zvci1uZXh0JwpydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUv
d2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9p
Mzg2LXJhbmRjb25maWctajQtMDkzMDIyMzQvbmV4dDptYXN0ZXI6OGYzMTQxMGVlOTkxN2U4
NjQ4YzdjZjdmNDVlMjIzMjBjMTY2OTk4YTpiaXNlY3QtdXNiCgoyMDEzLTEwLTAyLTEyOjI4
OjM2IDhmMzE0MTBlZTk5MTdlODY0OGM3Y2Y3ZjQ1ZTIyMzIwYzE2Njk5OGEgY29tcGlsaW5n
Cjg1IHJlYWwgIDM0NCB1c2VyICAzOCBzeXMgIDQ0OC44MSUgY3B1IAlpMzg2LXJhbmRjb25m
aWctajQtMDkzMDIyMzQKCjIwMTMtMTAtMDItMTI6MzA6MTYgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgMy4xMi4wLXJjMi0wMTg4Ny1nOGYzMTQxMC4JNgkxMAkxOAkzMQkzMwkzOAkzOQk0MQk0
Mi4uCTQ1CTQ2CTQ4CTU3CTY4CTc2CTgyCTkzCTEwMAkxMTAJMTE0CTEyNy4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSAyMxtbMG0KLi4J
MTMxCTE0NgkxNDkuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1bWFkZF90
b19ydW5fcXVldWUgMRtbMG0KLi4uLgkxNTAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA4NSByZXZp
c2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNiBzdGVwcykKWzZmMDE0
YTdlYTkxZjgwZjc2NWJhNzAwZGNkMTcyODY4MGJhNWM1OGVdIE1lcmdlIHJlbW90ZS10cmFj
a2luZyBicmFuY2ggJ3RpcC9hdXRvLWxhdGVzdCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdAps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWo0LTA5
MzAyMjM0L25leHQ6bWFzdGVyOjZmMDE0YTdlYTkxZjgwZjc2NWJhNzAwZGNkMTcyODY4MGJh
NWM1OGU6YmlzZWN0LXVzYgoKMjAxMy0xMC0wMi0xNzo0ODoyMiA2ZjAxNGE3ZWE5MWY4MGY3
NjViYTcwMGRjZDE3Mjg2ODBiYTVjNThlIGNvbXBpbGluZwoxODkgcmVhbCAgMTMyNCB1c2Vy
ICAxMjUgc3lzICA3NjQuODYlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWo0LTA5MzAyMjM0Cgoy
MDEzLTEwLTAyLTE3OjUxOjQzIGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1yYzItMDE5
NTctZzZmMDE0YTcuIFRFU1QgRkFJTFVSRQpbICAgIDEuODE0NzcyXSBXcml0ZSBwcm90ZWN0
aW5nIHRoZSBrZXJuZWwgcmVhZC1vbmx5IGRhdGE6IDM0MjBrClsgICAgMS44MjUxNDNdIC0t
LS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDEuODI1NjEzXSBXQVJO
SU5HOiBDUFU6IDAgUElEOiAxMCBhdCAvYy93ZmcvdXNiL2xpYi9kZWJ1Z29iamVjdHMuYzoy
NjAgZGVidWdfcHJpbnRfb2JqZWN0KzB4OGEvMHhhMCgpClsgICAgMS44MjYxMDldIE9ERUJV
RzogYWN0aXZlX3N0YXRlIGluYWN0aXZlIChhY3RpdmUgc3RhdGUgMCkgb2JqZWN0IHR5cGU6
IHJjdV9oZWFkIGhpbnQ6ICAgKG51bGwpClsgICAgMS44MjYxMDldIENQVTogMCBQSUQ6IDEw
IENvbW06IHJjdW9wLzAgTm90IHRhaW50ZWQgMy4xMi4wLXJjMi0wMTk1Ny1nNmYwMTRhNyAj
NDUwClsgICAgMS44MjYxMDldIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJv
Y2hzIDAxLzAxLzIwMTEKWyAgICAxLjgyNjEwOV0gIDQxYzI2OWE5IDRkNDQ5ZTJjIDQxOTcw
NWU5IDRkNDQ5ZTVjIDQxMDMxMmJiIDQxYzI3OTc4IDRkNDQ5ZTg4IDAwMDAwMDBhClsgICAg
MS44MjYxMDldICA0MWMyNjlhOSAwMDAwMDEwNCA0MTQyMTlmYSA0MTQyMTlmYSA0NjhkZjcx
MCA0MWNlNTUzYyA0MjIyZjY0YyA0ZDQ0OWU3NApbICAgIDEuODI2MTA5XSAgNDEwMzEzMmUg
MDAwMDAwMDkgNGQ0NDllNmMgNDFjMjc5NzggNGQ0NDllODggNGQ0NDllYTggNDE0MjE5ZmEg
NDFjMjY5YTkKWyAgICAxLjgyNjEwOV0gQ2FsbCBUcmFjZToKWyAgICAxLjgyNjEwOV0gIFs8
NDE5NzA1ZTk+XSBkdW1wX3N0YWNrKzB4MTYvMHgxOApbICAgIDEuODI2MTA5XSAgWzw0MTAz
MTJiYj5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4NmIvMHg5MApbICAgIDEuODI2MTA5XSAg
Wzw0MTQyMTlmYT5dID8gZGVidWdfcHJpbnRfb2JqZWN0KzB4OGEvMHhhMApbICAgIDEuODI2
MTA5XSAgWzw0MTQyMTlmYT5dID8gZGVidWdfcHJpbnRfb2JqZWN0KzB4OGEvMHhhMApbICAg
IDEuODI2MTA5XSAgWzw0MTAzMTMyZT5dIHdhcm5fc2xvd3BhdGhfZm10KzB4MmUvMHgzMApb
ICAgIDEuODI2MTA5XSAgWzw0MTQyMTlmYT5dIGRlYnVnX3ByaW50X29iamVjdCsweDhhLzB4
YTAKWyAgICAxLjgyNjEwOV0gIFs8NDE0MjI0NTM+XSA/IGRlYnVnX29iamVjdF9hY3RpdmVf
c3RhdGUrMHg1My8weGUwClsgICAgMS44MjYxMDldICBbPDQxNDIyNDhhPl0gZGVidWdfb2Jq
ZWN0X2FjdGl2ZV9zdGF0ZSsweDhhLzB4ZTAKWyAgICAxLjgyNjEwOV0gIFs8NDEwNzQ3Njg+
XSByY3Vfbm9jYl9rdGhyZWFkKzB4MjI4LzB4MmUwClsgICAgMS44MjYxMDldICBbPDQxMDQ5
ZTkwPl0gPyBhYm9ydF9leGNsdXNpdmVfd2FpdCsweDcwLzB4NzAKWyAgICAxLjgyNjEwOV0g
IFs8NDEwNzQ1NDA+XSA/IHJjdV9zdGFydF9ncCsweDMwLzB4MzAKWyAgICAxLjgyNjEwOV0g
IFs8NDEwNDk0ZTM+XSBrdGhyZWFkKzB4ODMvMHhhMApbICAgIDEuODI2MTA5XSAgWzw0MTk3
ZmVmYj5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDMwClsgICAgMS44MjYxMDld
ICBbPDQxMDQ5NDYwPl0gPyBfX2t0aHJlYWRfdW5wYXJrKzB4NDAvMHg0MApbICAgIDEuODI2
MTA5XSAtLS1bIGVuZCB0cmFjZSAxYzY1NWQ3M2ZlZjU4MjdmIF0tLS0KL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctajQtMDkzMDIyMzQvNmYwMTRhN2VhOTFmODBmNzY1YmE3MDBkY2QxNzI4
NjgwYmE1YzU4ZS9kbWVzZy1xdWFudGFsLXhwcy0yOjIwMTMxMDAyMTc1MTU1OjMuMTIuMC1y
YzItMDE5NTctZzZmMDE0YTc6NDUwCgpCaXNlY3Rpbmc6IDI0IHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA1IHN0ZXBzKQpbYmNlNTZmYmMwZjE2NTY1OGY3
ZTA3MTVmZWRjOGQzOTg0MGJhZTMxY10gTWVyZ2UgYnJhbmNoICdzY2hlZC9jb3JlJwpydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUv
d2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9p
Mzg2LXJhbmRjb25maWctajQtMDkzMDIyMzQvbmV4dDptYXN0ZXI6YmNlNTZmYmMwZjE2NTY1
OGY3ZTA3MTVmZWRjOGQzOTg0MGJhZTMxYzpiaXNlY3QtdXNiCgoyMDEzLTEwLTAyLTE3OjUy
OjE2IGJjZTU2ZmJjMGYxNjU2NThmN2UwNzE1ZmVkYzhkMzk4NDBiYWUzMWMgY29tcGlsaW5n
CjE4NiByZWFsICAxMzI2IHVzZXIgIDEyOCBzeXMgIDc3OS44MyUgY3B1IAlpMzg2LXJhbmRj
b25maWctajQtMDkzMDIyMzQKCjIwMTMtMTAtMDItMTc6NTU6MzMgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgMy4xMi4wLXJjMi0wMDA5NS1nYmNlNTZmYi4uLiBURVNUIEZBSUxVUkUKCm1vdW50
OiBtb3VudGluZyBwcm9jIG9uIC9wcm9jIGZhaWxlZDogTm8gc3VjaCBkZXZpY2UKWyAgICAy
LjkyNjE5NF0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVy
ZWZlcmVuY2UgYXQgICAobnVsbCkKWyAgICAyLjkyNzE1M10gSVA6IFs8NDEwYjMyNTY+XSBf
X2ZwdXQrMHg0Ni8weDIwMApbICAgIDIuOTI3MTUzXSAqcGRlID0gMDAwMDAwMDAgClsgICAg
Mi45MjcxNTNdIE9vcHM6IDAwMDAgWyMxXSBQUkVFTVBUIERFQlVHX1BBR0VBTExPQwpbICAg
IDIuOTI3MTUzXSBDUFU6IDAgUElEOiAyMyBDb21tOiBrd29ya2VyLzA6MSBOb3QgdGFpbnRl
ZCAzLjEyLjAtcmMyLTAwMDk1LWdiY2U1NmZiICM0NTEKWyAgICAyLjkyNzE1M10gSGFyZHdh
cmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDIuOTI3
MTUzXSBXb3JrcXVldWU6IGV2ZW50cyBkZWxheWVkX2ZwdXQKWyAgICAyLjkyNzE1M10gdGFz
azogNGVkZmYwMDAgdGk6IDRlZTA2MDAwIHRhc2sudGk6IDRlZTA2MDAwClsgICAgMi45Mjcx
NTNdIEVJUDogMDA2MDpbPDQxMGIzMjU2Pl0gRUZMQUdTOiAwMDAxMDIxMiBDUFU6IDAKWyAg
ICAyLjkyNzE1M10gRUlQIGlzIGF0IF9fZnB1dCsweDQ2LzB4MjAwClsgICAgMi45MjcxNTNd
IEVBWDogMDAwMDAwMDAgRUJYOiA0Y2M1ZDk4MCBFQ1g6IDAwMDAwMDAwIEVEWDogMDAwMDAw
MWQKWyAgICAyLjkyNzE1M10gRVNJOiAwMDAwMDAxMCBFREk6IDAwMDAwMDAwIEVCUDogNGVl
MDdlYjQgRVNQOiA0ZWUwN2U4YwpbICAgIDIuOTI3MTUzXSAgRFM6IDAwN2IgRVM6IDAwN2Ig
RlM6IDAwMDAgR1M6IDAwMDAgU1M6IDAwNjgKWyAgICAyLjkyNzE1M10gQ1IwOiA4MDA1MDAz
YiBDUjI6IDAwMDAwMDAwIENSMzogMDAwNzIwMDAgQ1I0OiAwMDAwMDY5MApbICAgIDIuOTI3
MTUzXSBTdGFjazoKWyAgICAyLjkyNzE1M10gIDRlZTA3ZWVjIDAwMDAwMDAwIDRlZTA3ZWMw
IDAwMDAwMjQ2IDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDRjYzVkZGY4ClsgICAgMi45
MjcxNTNdICAwMDAwMDAwMCAwMDAwMDAwMCA0ZWUwN2VjMCA0MTBiMzQyNyA0ZWQwZTY2MCA0
ZWUwN2YwOCA0MTA0MzcyYiAwMDAwMDAwMApbICAgIDIuOTI3MTUzXSAgMDAwMDAwMDEgMDAw
MDAwMDAgNDEwNDM2ZjggMDAwMDAwMDAgNGVjMWU3MzggNGZmZjAyMDAgNDFjZTBlYzAgNGVk
MGU2NjAKWyAgICAyLjkyNzE1M10gQ2FsbCBUcmFjZToKWyAgICAyLjkyNzE1M10gIFs8NDEw
YjM0Mjc+XSBkZWxheWVkX2ZwdXQrMHgxNy8weDMwClsgICAgMi45MjcxNTNdICBbPDQxMDQz
NzJiPl0gcHJvY2Vzc19vbmVfd29yaysweDI3Yi8weDQ0MApbICAgIDIuOTI3MTUzXSAgWzw0
MTA0MzZmOD5dID8gcHJvY2Vzc19vbmVfd29yaysweDI0OC8weDQ0MApbICAgIDIuOTI3MTUz
XSAgWzw0MTA0M2FkNz5dIHdvcmtlcl90aHJlYWQrMHgxZTcvMHgzNjAKWyAgICAyLjkyNzE1
M10gIFs8NDEwNDM4ZjA+XSA/IHByb2Nlc3Nfb25lX3dvcmsrMHg0NDAvMHg0NDAKWyAgICAy
LjkyNzE1M10gIFs8NDEwNDk3NjM+XSBrdGhyZWFkKzB4ODMvMHhhMApbICAgIDIuOTI3MTUz
XSAgWzw0MTk3YzMzYj5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDMwClsgICAg
Mi45MjcxNTNdICBbPDQxMDQ5NmUwPl0gPyBfX2t0aHJlYWRfdW5wYXJrKzB4NDAvMHg0MApb
ICAgIDIuOTI3MTUzXSBDb2RlOiBjOSBiYSBlOCAwMCAwMCAwMCBiOCAyNCA4ZCBjMCA0MSBl
OCBkNSAwYyBmYSBmZiA4YiA0MyAxMCA4OSBjMSA4OSA0NSBlOCA4YiA1MyA0MCA4OSBkMCA4
MyBlMCAwMiA4MyBmOCAwMSAxOSBmNiA4MyBlNiAwOCA4MyBjNiAwOCA8OGI+IDAxIDI1IDAw
IGYwIGZmIGZmIDY2IDNkIDAwIDQwIDc1IDA2IDgxIGNlIDAwIDAwIDAwIDQwIDgxIGUyClsg
ICAgMi45MjcxNTNdIEVJUDogWzw0MTBiMzI1Nj5dIF9fZnB1dCsweDQ2LzB4MjAwIFNTOkVT
UCAwMDY4OjRlZTA3ZThjClsgICAgMi45MjcxNTNdIENSMjogMDAwMDAwMDAwMDAwMDAwMApb
ICAgIDIuOTY4MDY0XSBpbnZhbGlkIG9wY29kZTogMDAwMCBbIzJdIFBSRUVNUFQgREVCVUdf
UEFHRUFMTE9DClsgICAgMi45NjkwMjFdIENQVTogMCBQSUQ6IDEwIENvbW06IHJjdW9wLzAg
VGFpbnRlZDogRyAgICAgIEQgICAgICAzLjEyLjAtcmMyLTAwMDk1LWdiY2U1NmZiICM0NTEK
WyAgICAyLjk2OTAyMV0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMg
MDEvMDEvMjAxMQpbICAgIDIuOTY5MDIxXSB0YXNrOiA0ZWMzNzAwMCB0aTogNGVjNDgwMDAg
dGFzay50aTogNGVjNDgwMDAKWyAgICAyLjk2OTAyMV0gRUlQOiAwMDYwOls8NGNjNzRkZTE+
XSBFRkxBR1M6IDAwMDEwMjAzIENQVTogMApbICAgIDIuOTY5MDIxXSBFSVAgaXMgYXQgMHg0
Y2M3NGRlMQpbICAgIDIuOTY5MDIxXSBFQVg6IGMwOTk4ZTliIEVCWDogNGNjN2MwYzAgRUNY
OiA0MTQxNjY0YyBFRFg6IDRjYzc0ZGMwClsgICAgMi45NjkwMjFdIEVTSTogNGNjNzRkYzUg
RURJOiAwMDAwMDAwMiBFQlA6IDRlYzQ5ZjM0IEVTUDogNGVjNDllZTQKWyAgICAyLjk2OTAy
MV0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMDAwIEdTOiAwMDAwIFNTOiAwMDY4ClsgICAg
Mi45NjkwMjFdIENSMDogODAwNTAwMzMgQ1IyOiAwODA1NDAwMCBDUjM6IDAwMDcyMDAwIENS
NDogMDAwMDA2OTAKWyAgICAyLjk2OTAyMV0gU3RhY2s6ClsgICAgMi45NjkwMjFdICA0MTA3
NDlkMiAwMDAwMDAwMCA0MWNlM2QzMCA0ZWMzNzAwMCA0Y2M3NDAwMCA0MWNlM2QxOCA0MWNl
M2QyMCA0MWNlM2QyNApbICAgIDIuOTY5MDIxXSAgMDAwMDAyMzYgNDFjZTNjODAgNGNjNWRk
MzQgMDAwMDAwMDAgMDAwMDAwMDAgNGVjMzcwMDAgNDEwNGExMTAgNGVjNDlmMjAKWyAgICAy
Ljk2OTAyMV0gIDRlYzQ5ZjIwIDRlYzI5ZTk4IDQxY2UzYzgwIDQxMDc0NzcwIDRlYzQ5ZmFj
IDQxMDQ5NzYzIDAwMDAwMDAwIDRlYzQ5ZjZjClsgICAgMi45NjkwMjFdIENhbGwgVHJhY2U6
ClsgICAgMi45NjkwMjFdICBbPDQxMDc0OWQyPl0gPyByY3Vfbm9jYl9rdGhyZWFkKzB4MjYy
LzB4MmUwClsgICAgMi45NjkwMjFdICBbPDQxMDRhMTEwPl0gPyBhYm9ydF9leGNsdXNpdmVf
d2FpdCsweDcwLzB4NzAKWyAgICAyLjk2OTAyMV0gIFs8NDEwNzQ3NzA+XSA/IHJjdV9zdGFy
dF9ncCsweDMwLzB4MzAKWyAgICAyLjk2OTAyMV0gIFs8NDEwNDk3NjM+XSBrdGhyZWFkKzB4
ODMvMHhhMApbICAgIDIuOTY5MDIxXSAgWzw0MTk3YzMzYj5dIHJldF9mcm9tX2tlcm5lbF90
aHJlYWQrMHgxYi8weDMwClsgICAgMi45NjkwMjFdICBbPDQxMDQ5NmUwPl0gPyBfX2t0aHJl
YWRfdW5wYXJrKzB4NDAvMHg0MApbICAgIDIuOTY5MDIxXSBDb2RlOiAwYSA0MSA1NCAwMCAw
MCAwMCAwMiAwMCAzZSAwNyA0MCA5YiA4ZSA5OSBjMCA0ZCBjNyA0YyA5MCBiNyBjMCA0ZSAw
MCBlMCBkMCA0ZSBkOCA4OSBkMCA0ZSA4MCBkZCA5OCA0MSAwMSAwMCAwMCAwMCBhZCA0ZSBh
ZCBkZSBmZiA8ZmY+IGZmIGZmIGZmIGZmIGZmIGZmIDA0IDNlIDIwIDQyIDAwIDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDUwIDhkClsgICAgMi45NjkwMjFdIEVJUDogWzw0Y2M3NGRlMT5dIDB4
NGNjNzRkZTEgU1M6RVNQIDAwNjg6NGVjNDllZTQKWyAgICAzLjAwMzQwNl0gLS0tWyBlbmQg
dHJhY2UgYjQ1NjZjNzNkN2M5MzY3NyBdLS0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0
LTA5MzAyMjM0L2JjZTU2ZmJjMGYxNjU2NThmN2UwNzE1ZmVkYzhkMzk4NDBiYWUzMWMvZG1l
c2cteW9jdG8tbGtwLXR0MDItMTY6MjAxMzEwMDIwODI0MDM6My4xMi4wLXJjMi0wMDA5NS1n
YmNlNTZmYjo0NTEKCkJpc2VjdGluZzogMjIgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRl
ciB0aGlzIChyb3VnaGx5IDUgc3RlcHMpCltjMmRhYTNiZWQ1M2E4MTE3MWNmOGMxYTM2ZGI3
OThlODJiOTFhZmU4XSBzY2hlZCwgeDg2OiBQcm92aWRlIGEgcGVyLWNwdSBwcmVlbXB0X2Nv
dW50IGltcGxlbWVudGF0aW9uCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5l
bC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIzNC9uZXh0
Om1hc3RlcjpjMmRhYTNiZWQ1M2E4MTE3MWNmOGMxYTM2ZGI3OThlODJiOTFhZmU4OmJpc2Vj
dC11c2IKCjIwMTMtMTAtMDItMTc6NTc6MDYgYzJkYWEzYmVkNTNhODExNzFjZjhjMWEzNmRi
Nzk4ZTgyYjkxYWZlOCBjb21waWxpbmcKMTg3IHJlYWwgIDEzMDYgdXNlciAgMTI5IHN5cyAg
NzY0Ljc0JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIzNAoKMjAxMy0xMC0wMi0x
ODowMDoyMyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmMxLTAwMDYwLWdjMmRhYTNi
Li4JMiBURVNUIEZBSUxVUkUKQlVHOiBrZXJuZWwgZWFybHkgaGFuZyB3aXRob3V0IGFueSBw
cmludGsgb3V0cHV0CkNvbW1hbmQgbGluZTogaHVuZ190YXNrX3BhbmljPTEgcmN1dHJlZS5y
Y3VfY3B1X3N0YWxsX3RpbWVvdXQ9MTAwIGxvZ19idWZfbGVuPThNIGlnbm9yZV9sb2dsZXZl
bCBkZWJ1ZyBzY2hlZF9kZWJ1ZyBhcGljPWRlYnVnIGR5bmFtaWNfcHJpbnRrIHN5c3JxX2Fs
d2F5c19lbmFibGVkIHBhbmljPTEwICBwcm9tcHRfcmFtZGlzaz0wIGNvbnNvbGU9dHR5UzAs
MTE1MjAwIGNvbnNvbGU9dHR5MCB2Z2E9bm9ybWFsICByb290PS9kZXYvcmFtMCBydyBsaW5r
PS9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajQtMDkzMDIy
MzQvbmV4dDptYXN0ZXI6YzJkYWEzYmVkNTNhODExNzFjZjhjMWEzNmRiNzk4ZTgyYjkxYWZl
ODpiaXNlY3QtdXNiLy52bWxpbnV6LWMyZGFhM2JlZDUzYTgxMTcxY2Y4YzFhMzZkYjc5OGU4
MmI5MWFmZTgtMjAxMzEwMDIxODAwMjEtMTMyLWFudCBicmFuY2g9bmV4dC9tYXN0ZXIgQk9P
VF9JTUFHRT0va2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIzNC9jMmRhYTNiZWQ1
M2E4MTE3MWNmOGMxYTM2ZGI3OThlODJiOTFhZmU4L3ZtbGludXotMy4xMi4wLXJjMS0wMDA2
MC1nYzJkYWEzYiBub2FwaWMgbm9sYXBpYyBub2h6PW9mZgpFYXJseSBoYW5nIGtlcm5lbDog
dm1saW51ei0zLjEyLjAtcmMxLTAwMDYwLWdjMmRhYTNiIDMuMTIuMC1yYzEtMDAwNjAtZ2My
ZGFhM2IgIzQ1Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIzNC9jMmRhYTNi
ZWQ1M2E4MTE3MWNmOGMxYTM2ZGI3OThlODJiOTFhZmU4L2RtZXNnLXF1YW50YWwtd2FpbWVh
LTEzOjIwMTMxMDAzMDE1ODA5OjMuMTIuMC1yYzEtMDAwNjAtZ2MyZGFhM2I6NDUyCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA5MzAyMjM0L2MyZGFhM2JlZDUzYTgxMTcxY2Y4YzFh
MzZkYjc5OGU4MmI5MWFmZTgvZG1lc2ctcXVhbnRhbC13YWltZWEtMTQ6MjAxMzEwMDMwMTU3
NTQ6My4xMi4wLXJjMS0wMDA2MC1nYzJkYWEzYjo0NTIKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctajQtMDkzMDIyMzQvYzJkYWEzYmVkNTNhODExNzFjZjhjMWEzNmRiNzk4ZTgyYjkxYWZl
OC9kbWVzZy1xdWFudGFsLXdhaW1lYS03OjIwMTMxMDAzMDE1NzQxOjMuMTIuMC1yYzEtMDAw
NjAtZ2MyZGFhM2I6NDUyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA5MzAyMjM0L2My
ZGFhM2JlZDUzYTgxMTcxY2Y4YzFhMzZkYjc5OGU4MmI5MWFmZTgvZG1lc2ctcXVhbnRhbC1i
ZW5zLTQ6MjAxMzEwMDIxODAxMzQ6My4xMi4wLXJjMS0wMDA2MC1nYzJkYWEzYjo0NTIKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctajQtMDkzMDIyMzQvYzJkYWEzYmVkNTNhODExNzFjZjhj
MWEzNmRiNzk4ZTgyYjkxYWZlOC9kbWVzZy1xdWFudGFsLWxrcC1zdDAxLTEwOjIwMTMxMDAy
MTgwMDU4OjMuMTIuMC1yYzEtMDAwNjAtZ2MyZGFhM2I6NDUyCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWo0LTA5MzAyMjM0L2MyZGFhM2JlZDUzYTgxMTcxY2Y4YzFhMzZkYjc5OGU4MmI5
MWFmZTgvZG1lc2ctcXVhbnRhbC1sa3Atc3QwMS05OjIwMTMxMDAyMTgwMTE0OjMuMTIuMC1y
YzEtMDAwNjAtZ2MyZGFhM2I6NDUyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA5MzAy
MjM0L2MyZGFhM2JlZDUzYTgxMTcxY2Y4YzFhMzZkYjc5OGU4MmI5MWFmZTgvZG1lc2ctcXVh
bnRhbC1sa3AtdHQwMi0xODoyMDEzMTAwMjA4MjkwMTozLjEyLjAtcmMxLTAwMDYwLWdjMmRh
YTNiOjQ1Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIzNC9jMmRhYTNiZWQ1
M2E4MTE3MWNmOGMxYTM2ZGI3OThlODJiOTFhZmU4L2RtZXNnLXF1YW50YWwtbGtwLXR0MDIt
MjE6MjAxMzEwMDIwODI4NDU6My4xMi4wLXJjMS0wMDA2MC1nYzJkYWEzYjo0NTIKCkJpc2Vj
dGluZzogMTAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDQg
c3RlcHMpCls0MzE0ODk1MTY1NjIzODc5OTM3ZjQ2ZDc2NzY3MzY1NDY2MmI1NzBjXSBzY2hl
ZDogTWljcm8tb3B0aW1pemUgYnkgZHJvcHBpbmcgdW5uZWNlc3NhcnkgdGFza19ycSgpIGNh
bGxzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIzNC9uZXh0Om1hc3Rlcjo0MzE0ODk1
MTY1NjIzODc5OTM3ZjQ2ZDc2NzY3MzY1NDY2MmI1NzBjOmJpc2VjdC11c2IKCjIwMTMtMTAt
MDItMTg6MDE6NTUgNDMxNDg5NTE2NTYyMzg3OTkzN2Y0NmQ3Njc2NzM2NTQ2NjJiNTcwYyBj
b21waWxpbmcKMTgxIHJlYWwgIDEyODYgdXNlciAgMTIzIHN5cyAgNzc1Ljc5JSBjcHUgCWkz
ODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIzNAoKMjAxMy0xMC0wMi0xODowNTowNyBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmMxLTAwMDQ5LWc0MzE0ODk1Li4JNAkxMwkyNwkzMQk0
MQk0Mwk0NQk1Mgk1Mwk2NQk3Ngk3Nwk4Ngk5NS4JMTAzCTEwOAkxMTAJMTEyCTExMwkxMTQJ
MTE3CTEyOAkxNDMJMTUwIFNVQ0NFU1MKCkJpc2VjdGluZzogNSByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMyBzdGVwcykKWzRhMmI0YjIyMjc0M2JiMDdm
ZWRmOTg1Yjg4NDU1MGYyY2EwNjdlYTldIHNjaGVkOiBJbnRyb2R1Y2UgcHJlZW1wdF9jb3Vu
dCBhY2Nlc3NvciBmdW5jdGlvbnMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWo0LTA5MzAyMjM0L25l
eHQ6bWFzdGVyOjRhMmI0YjIyMjc0M2JiMDdmZWRmOTg1Yjg4NDU1MGYyY2EwNjdlYTk6Ymlz
ZWN0LXVzYgoKMjAxMy0xMC0wMi0xODoxODozOCA0YTJiNGIyMjI3NDNiYjA3ZmVkZjk4NWI4
ODQ1NTBmMmNhMDY3ZWE5IGNvbXBpbGluZwoxOTcgcmVhbCAgMTMwMiB1c2VyICAxMTkgc3lz
ICA3MjAuNTklIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWo0LTA5MzAyMjM0CgoyMDEzLTEwLTAy
LTE4OjIyOjA3IGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1yYzEtMDAwNTQtZzRhMmI0
YjIJMiBURVNUIEZBSUxVUkUKWyAgICA1LjMxOTQ2M10gV3JpdGUgcHJvdGVjdGluZyB0aGUg
a2VybmVsIHRleHQ6IDk3MjBrClsgICAgNS4zMjE3MzddIFdyaXRlIHByb3RlY3RpbmcgdGhl
IGtlcm5lbCByZWFkLW9ubHkgZGF0YTogMzQxNmsKWyAgICA1LjM1NjQzMF0gQlVHOiB1bmFi
bGUgdG8gaGFuZGxlIGtlcm5lbCBwYWdpbmcgcmVxdWVzdCBhdCAwNWZlMDA2MApbICAgIDUu
MzU3MjUwXSBJUDogWzw0MTA0NmUzMD5dIHRhc2tfd29ya19ydW4rMHg2MC8weGEwClsgICAg
NS4zNTcyNTBdICpwZGUgPSAwMDAwMDAwMCAKWyAgICA1LjM1NzI1MF0gT29wczogMDAwMCBb
IzFdIFBSRUVNUFQgREVCVUdfUEFHRUFMTE9DClsgICAgNS4zNTcyNTBdIENQVTogMCBQSUQ6
IDEzMiBDb21tOiByYy5sb2NhbCBOb3QgdGFpbnRlZCAzLjEyLjAtcmMxLTAwMDU0LWc0YTJi
NGIyICM0NTQKWyAgICA1LjM1NzI1MF0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJ
T1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDUuMzU3MjUwXSB0YXNrOiA0NjhlNTAwMCB0aTog
NDY4ZjYwMDAgdGFzay50aTogNDY4ZjYwMDAKWyAgICA1LjM1NzI1MF0gRUlQOiAwMDYwOls8
NDEwNDZlMzA+XSBFRkxBR1M6IDAwMDEwMjA2IENQVTogMApbICAgIDUuMzU3MjUwXSBFSVAg
aXMgYXQgdGFza193b3JrX3J1bisweDYwLzB4YTAKWyAgICA1LjM1NzI1MF0gRUFYOiAwNWZl
MDA2MCBFQlg6IDQ2OGRmYTgwIEVDWDogMDAwMDAwMDAgRURYOiAwNWZlMDA2MApbICAgIDUu
MzU3MjUwXSBFU0k6IDQ2OGU1MmFjIEVESTogNDY4ZTUwMDAgRUJQOiA0NjhmN2Y5YyBFU1A6
IDQ2OGY3ZjkwClsgICAgNS4zNTcyNTBdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDAwMCBH
UzogMDAwMCBTUzogMDA2OApbICAgIDUuMzU3MjUwXSBDUjA6IDgwMDUwMDNiIENSMjogMDVm
ZTAwNjAgQ1IzOiAwNjhmMjAwMCBDUjQ6IDAwMDAwNjkwClsgICAgNS4zNTcyNTBdIFN0YWNr
OgpbICAgIDUuMzU3MjUwXSAgMzg1MWU5MDMgMzg1MDdlZTggMzc2NjRmZjQgNDY4ZjdmYWMg
NDEwMDIzMDAgNDE5N2NkOWMgNGZmZjAxYmMgNDY4ZjYwMDAKWyAgICA1LjM1NzI1MF0gIDQx
OTdjN2M2IDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAw
MDAwMDAwIDAwMDAwMDAwClsgICAgNS4zNTcyNTBdICAwMDAwMDA3YiAwMDAwMDA3YiAwMDAw
MDAwMCAwMDAwMDAwMCAwMDAwMDAwYiAzNzdjZjFkMCAwMDAwMDA3MyAwMDAwMDIwMApbICAg
IDUuMzU3MjUwXSBDYWxsIFRyYWNlOgpbICAgIDUuMzU3MjUwXSAgWzw0MTAwMjMwMD5dIGRv
X25vdGlmeV9yZXN1bWUrMHg1MC8weDYwClsgICAgNS4zNTcyNTBdICBbPDQxOTdjZDljPl0g
PyBzeXNlbnRlcl9kb19jYWxsKzB4MWUvMHgzNwpbICAgIDUuMzU3MjUwXSAgWzw0MTk3Yzdj
Nj5dIHdvcmtfbm90aWZ5c2lnKzB4MjYvMHgzMApbICAgIDUuMzU3MjUwXSBDb2RlOiBlYiAw
YiA4OSBmNiA4ZCBiYyAyNyAwMCAwMCAwMCAwMCAzMSBjOSA4OSBkMCAwZiBiMSAwZSAzOSBj
MiA3NSBkNSA4NSBkMiA3NCA0NiA5MCBmMyA5MCA4YiA4NyBlNCAwMiAwMCAwMCA4NSBjMCA3
NCBmNCAzMSBkYiA2NiA5MCA8OGI+IDAyIDg5IDFhIDg1IGMwIDc0IDA4IDg5IGQzIDg5IGMy
IGViIGYyIDY2IDkwIDg5IGQwIGZmIDUyIDA0ClsgICAgNS4zNTcyNTBdIEVJUDogWzw0MTA0
NmUzMD5dIHRhc2tfd29ya19ydW4rMHg2MC8weGEwIFNTOkVTUCAwMDY4OjQ2OGY3ZjkwClsg
ICAgNS4zNTcyNTBdIENSMjogMDAwMDAwMDAwNWZlMDA2MAova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1qNC0wOTMwMjIzNC80YTJiNGIyMjI3NDNiYjA3ZmVkZjk4NWI4ODQ1NTBmMmNhMDY3
ZWE5L2RtZXNnLXF1YW50YWwtamFrZXRvd24tMjoyMDEzMTAwMjE4MjIyNDozLjEyLjAtcmMx
LTAwMDU0LWc0YTJiNGIyOjQ1NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIz
NC80YTJiNGIyMjI3NDNiYjA3ZmVkZjk4NWI4ODQ1NTBmMmNhMDY3ZWE5L2RtZXNnLXF1YW50
YWwtamFrZXRvd24tNjoyMDEzMTAwMjE4MjIyNTozLjEyLjAtcmMxLTAwMDU0LWc0YTJiNGIy
OjQ1NAoKQmlzZWN0aW5nOiAyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAo
cm91Z2hseSAxIHN0ZXApCltiMDIxZmUzZTI1MDk0ZmJlYzIyZDBlZmY4NDZkMmFkZWVlMWI5
NzM2XSBzY2hlZCwgcmN1OiBNYWtlIFJDVSB1c2UgcmVzY2hlZF9jcHUoKQpydW5uaW5nIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3Vz
Yi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJh
bmRjb25maWctajQtMDkzMDIyMzQvbmV4dDptYXN0ZXI6YjAyMWZlM2UyNTA5NGZiZWMyMmQw
ZWZmODQ2ZDJhZGVlZTFiOTczNjpiaXNlY3QtdXNiCgoyMDEzLTEwLTAyLTE4OjIyOjQwIGIw
MjFmZTNlMjUwOTRmYmVjMjJkMGVmZjg0NmQyYWRlZWUxYjk3MzYgY29tcGlsaW5nCjE4MCBy
ZWFsICAxMzE0IHVzZXIgIDEyMiBzeXMgIDc5NS45NCUgY3B1IAlpMzg2LXJhbmRjb25maWct
ajQtMDkzMDIyMzQKCjIwMTMtMTAtMDItMTg6MjU6NTEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
My4xMi4wLXJjMS0wMDA1MS1nYjAyMWZlMy4uIFRFU1QgRkFJTFVSRQpbICAgIDcuNjQ3OTc3
XSBXcml0ZSBwcm90ZWN0aW5nIHRoZSBrZXJuZWwgdGV4dDogOTcyMGsKWyAgICA3LjY0OTA1
M10gV3JpdGUgcHJvdGVjdGluZyB0aGUga2VybmVsIHJlYWQtb25seSBkYXRhOiAzNDE2awpb
ICAgIDcuNjg4MDUyXSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIHBhZ2luZyByZXF1
ZXN0IGF0IDA1MWUwMGMwClsgICAgNy42ODkwMTNdIElQOiBbPDQxMDc0YTUwPl0gcmN1X25v
Y2Jfa3RocmVhZCsweDFmMC8weDJlMApbICAgIDcuNjg5MDEzXSAqcGRlID0gMDAwMDAwMDAg
ClsgICAgNy42ODkwMTNdIE9vcHM6IDAwMDAgWyMxXSBQUkVFTVBUIERFQlVHX1BBR0VBTExP
QwpbICAgIDcuNjg5MDEzXSBDUFU6IDAgUElEOiAxMCBDb21tOiByY3VvcC8wIE5vdCB0YWlu
dGVkIDMuMTIuMC1yYzEtMDAwNTEtZ2IwMjFmZTMgIzQ1NQpbICAgIDcuNjg5MDEzXSBIYXJk
d2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgNy42
ODkwMTNdIHRhc2s6IDRkNDM3MDAwIHRpOiA0ZDQ0ODAwMCB0YXNrLnRpOiA0ZDQ0ODAwMApb
ICAgIDcuNjg5MDEzXSBFSVA6IDAwNjA6Wzw0MTA3NGE1MD5dIEVGTEFHUzogMDAwMTAyMDYg
Q1BVOiAwClsgICAgNy42ODkwMTNdIEVJUCBpcyBhdCByY3Vfbm9jYl9rdGhyZWFkKzB4MWYw
LzB4MmUwClsgICAgNy42ODkwMTNdIEVBWDogMDAwMDAwMDAgRUJYOiAwNTFlMDBjMCBFQ1g6
IDAwMDAwMDAwIEVEWDogNGQ0NDgwMDAKWyAgICA3LjY4OTAxM10gRVNJOiAwNTFlMDBjMCBF
REk6IDAwMDAwMDBiIEVCUDogNGQ0NDlmMzQgRVNQOiA0ZDQ0OWVlOApbICAgIDcuNjg5MDEz
XSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwMDAgR1M6IDAwMDAgU1M6IDAwNjgKWyAgICA3
LjY4OTAxM10gQ1IwOiA4MDA1MDAzYiBDUjI6IDA1MWUwMGMwIENSMzogMDY4NmMwMDAgQ1I0
OiAwMDAwMDY5MApbICAgIDcuNjg5MDEzXSBTdGFjazoKWyAgICA3LjY4OTAxM10gIDAwMDAw
MDAwIDQxY2UzZDMwIDRkNDM3MDAwIDQ2ODUwNWUwIDQxY2UzZDE4IDQxY2UzZDIwIDQxY2Uz
ZDI0IDAwMDAxMjBkClsgICAgNy42ODkwMTNdICA0MWNlM2M4MCA0MDEwODMwMCAwMDAwMDAw
MCAwMDAwMDAwMCA0ZDQzNzAwMCA0MTA0YTI1MCA0ZDQ0OWYyMCA0ZDQ0OWYyMApbICAgIDcu
Njg5MDEzXSAgNGQ0MjllOTggNDFjZTNjODAgNDEwNzQ4NjAgNGQ0NDlmYWMgNDEwNDk4YTMg
MDAwMDAwMDAgNGQ0NDlmNmMgNDFjZTNjODAKWyAgICA3LjY4OTAxM10gQ2FsbCBUcmFjZToK
WyAgICA3LjY4OTAxM10gIFs8NDEwNGEyNTA+XSA/IGFib3J0X2V4Y2x1c2l2ZV93YWl0KzB4
NzAvMHg3MApbICAgIDcuNjg5MDEzXSAgWzw0MTA3NDg2MD5dID8gcmN1X3N0YXJ0X2dwKzB4
MzAvMHgzMApbICAgIDcuNjg5MDEzXSAgWzw0MTA0OThhMz5dIGt0aHJlYWQrMHg4My8weGEw
ClsgICAgNy42ODkwMTNdICBbPDQxOTdjZDViPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsw
eDFiLzB4MzAKWyAgICA3LjY4OTAxM10gIFs8NDEwNDk4MjA+XSA/IF9fa3RocmVhZF91bnBh
cmsrMHg0MC8weDQwClsgICAgNy42ODkwMTNdIENvZGU6IDBmIDg5IGY1IDAwIDAwIDAwIDhi
IDQzIDA0IDhiIDQwIDA4IGE4IDA0IDBmIDg1IGJmIDAwIDAwIDAwIGU4IDAyIDU4IDkwIDAw
IGViIGQwIDhiIDVkIGMwIGM3IDQ1IGRjIDAwIDAwIDAwIDAwIDMxIGZmIDhkIDc0IDI2IDAw
IDw4Yj4gMzMgODUgZjYgNzUgMWEgMzkgNWQgZDggNzQgMTUgOTAgOGQgNzQgMjYgMDAgYjgg
MDEgMDAgMDAgMDAKWyAgICA3LjY4OTAxM10gRUlQOiBbPDQxMDc0YTUwPl0gcmN1X25vY2Jf
a3RocmVhZCsweDFmMC8weDJlMCBTUzpFU1AgMDA2ODo0ZDQ0OWVlOApbICAgIDcuNjg5MDEz
XSBDUjI6IDAwMDAwMDAwMDUxZTAwYzAKWyAgICA3LjcxOTIyOF0gLS0tLS0tLS0tLS0tWyBj
dXQgaGVyZSBdLS0tLS0tLS0tLS0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA5MzAy
MjM0L2IwMjFmZTNlMjUwOTRmYmVjMjJkMGVmZjg0NmQyYWRlZWUxYjk3MzYvZG1lc2cteW9j
dG8teHBzLTM6MjAxMzEwMDIxODI2MDk6My4xMi4wLXJjMS0wMDA1MS1nYjAyMWZlMzo0NTUK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDkzMDIyMzQvYjAyMWZlM2UyNTA5NGZiZWMy
MmQwZWZmODQ2ZDJhZGVlZTFiOTczNi9kbWVzZy1xdWFudGFsLWxrcC1zdDAxLTExOjIwMTMx
MDAyMTgyNjE5OjMuMTIuMC1yYzEtMDAwNTEtZ2IwMjFmZTM6NDU1Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWo0LTA5MzAyMjM0L2IwMjFmZTNlMjUwOTRmYmVjMjJkMGVmZjg0NmQyYWRl
ZWUxYjk3MzYvZG1lc2ctcXVhbnRhbC1sa3AtdHQwMi0yMjoyMDEzMTAwMjA4NTM0MzozLjEy
LjAtcmMxLTAwMDUxLWdiMDIxZmUzOjQ1NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0w
OTMwMjIzNC9iMDIxZmUzZTI1MDk0ZmJlYzIyZDBlZmY4NDZkMmFkZWVlMWI5NzM2L2RtZXNn
LXlvY3RvLWxrcC1zdDAxLTc6MjAxMzEwMDIxODI2MTc6My4xMi4wLXJjMS0wMDA1MS1nYjAy
MWZlMzo0NTUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDkzMDIyMzQvYjAyMWZlM2Uy
NTA5NGZiZWMyMmQwZWZmODQ2ZDJhZGVlZTFiOTczNi9kbWVzZy1xdWFudGFsLWJlbnMtMzoy
MDEzMTAwMjE4MjYyMDozLjEyLjAtcmMxLTAwMDUxLWdiMDIxZmUzOjQ1NQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIzNC9iMDIxZmUzZTI1MDk0ZmJlYzIyZDBlZmY4NDZk
MmFkZWVlMWI5NzM2L2RtZXNnLXlvY3RvLWJlbnMtMzoyMDEzMTAwMjE4MjYyMTozLjEyLjAt
cmMxLTAwMDUxLWdiMDIxZmUzOjQ1NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wOTMw
MjIzNC9iMDIxZmUzZTI1MDk0ZmJlYzIyZDBlZmY4NDZkMmFkZWVlMWI5NzM2L2RtZXNnLXF1
YW50YWwtd2FpbWVhLTQ6MjAxMzEwMDMwMjIzMTQ6My4xMi4wLXJjMS0wMDA1MS1nYjAyMWZl
Mzo0NTUKCkJpc2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgMCBzdGVwcykKWzBjNDRjMmQwZjQ1OWNkN2UyNzUyNDJiNzJmNTAwMTM3YzRm
YTgzNGRdIHg4NjogVXNlIGFzbSBnb3RvIHRvIGltcGxlbWVudCBiZXR0ZXIgbW9kaWZ5X2Fu
ZF90ZXN0KCkgZnVuY3Rpb25zCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5l
bC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIzNC9uZXh0
Om1hc3RlcjowYzQ0YzJkMGY0NTljZDdlMjc1MjQyYjcyZjUwMDEzN2M0ZmE4MzRkOmJpc2Vj
dC11c2IKCjIwMTMtMTAtMDItMTg6MjY6NTIgMGM0NGMyZDBmNDU5Y2Q3ZTI3NTI0MmI3MmY1
MDAxMzdjNGZhODM0ZCBjb21waWxpbmcKMTkgcmVhbCAgMzYgdXNlciAgMTIgc3lzICAyNDcu
NDUlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWo0LTA5MzAyMjM0CgoyMDEzLTEwLTAyLTE4OjI3
OjIxIGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1yYzEtMDAwNTAtZzBjNDRjMmQuIFRF
U1QgRkFJTFVSRQpbICAgIDguNTMzNDIxXSBXcml0ZSBwcm90ZWN0aW5nIHRoZSBrZXJuZWwg
cmVhZC1vbmx5IGRhdGE6IDM0MTZrClsgICAgOC41NTIxMjJdIHRzYzogUmVmaW5lZCBUU0Mg
Y2xvY2tzb3VyY2UgY2FsaWJyYXRpb246IDIzOTMuOTA5IE1IegpbICAgIDguNTg0MjgwXSBC
VUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIHBhZ2luZyByZXF1ZXN0IGF0IDM3NmZkMDAw
ClsgICAgOC41ODUwMTVdIElQOiBbPDQxMDQ2ZTMwPl0gdGFza193b3JrX3J1bisweDYwLzB4
YTAKWyAgICA4LjU4NTAxNV0gKnBkZSA9IDA2OGY1MDY3ICpwdGUgPSAwMDAwMDAwMCAKWyAg
ICA4LjU4NTAxNV0gT29wczogMDAwMCBbIzFdIFBSRUVNUFQgREVCVUdfUEFHRUFMTE9DClsg
ICAgOC41ODUwMTVdIENQVTogMCBQSUQ6IDEzMiBDb21tOiByYy5sb2NhbCBOb3QgdGFpbnRl
ZCAzLjEyLjAtcmMxLTAwMDUwLWcwYzQ0YzJkICM0NTYKWyAgICA4LjU4NTAxNV0gSGFyZHdh
cmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDguNTg1
MDE1XSB0YXNrOiA0NjhlNzQ0MCB0aTogNDY4ZjYwMDAgdGFzay50aTogNDY4ZjYwMDAKWyAg
ICA4LjU4NTAxNV0gRUlQOiAwMDYwOls8NDEwNDZlMzA+XSBFRkxBR1M6IDAwMDEwMjA2IENQ
VTogMApbICAgIDguNTg1MDE1XSBFSVAgaXMgYXQgdGFza193b3JrX3J1bisweDYwLzB4YTAK
WyAgICA4LjU4NTAxNV0gRUFYOiAzNzZmZDAwMCBFQlg6IDQ2OGU1M2Q4IEVDWDogMDAwMDAw
MDAgRURYOiAzNzZmZDAwMApbICAgIDguNTg1MDE1XSBFU0k6IDQ2OGU3NmVjIEVESTogNDY4
ZTc0NDAgRUJQOiA0NjhmN2Y5YyBFU1A6IDQ2OGY3ZjkwClsgICAgOC41ODUwMTVdICBEUzog
MDA3YiBFUzogMDA3YiBGUzogMDAwMCBHUzogMDAwMCBTUzogMDA2OApbICAgIDguNTg1MDE1
XSBDUjA6IDgwMDUwMDNiIENSMjogMzc2ZmQwMDAgQ1IzOiAwNjhkNzAwMCBDUjQ6IDAwMDAw
NjkwClsgICAgOC41ODUwMTVdIFN0YWNrOgpbICAgIDguNTg1MDE1XSAgMzk0NzA5MDMgMzk0
NTllZTggMzc2ZDJmZjQgNDY4ZjdmYWMgNDEwMDIzMDAgNDE5N2NkYmMgNGZmZjAxYmMgNDY4
ZjYwMDAKWyAgICA4LjU4NTAxNV0gIDQxOTdjN2U2IDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAw
MDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwClsgICAgOC41ODUwMTVd
ICAwMDAwMDA3YiAwMDAwMDA3YiAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwYiAzNzZmZTFk
MCAwMDAwMDA3MyAwMDAwMDIwMApbICAgIDguNTg1MDE1XSBDYWxsIFRyYWNlOgpbICAgIDgu
NTg1MDE1XSAgWzw0MTAwMjMwMD5dIGRvX25vdGlmeV9yZXN1bWUrMHg1MC8weDYwClsgICAg
OC41ODUwMTVdICBbPDQxOTdjZGJjPl0gPyBzeXNlbnRlcl9kb19jYWxsKzB4MWUvMHgzNwpb
ICAgIDguNTg1MDE1XSAgWzw0MTk3YzdlNj5dIHdvcmtfbm90aWZ5c2lnKzB4MjYvMHgzMApb
ICAgIDguNTg1MDE1XSBDb2RlOiBlYiAwYiA4OSBmNiA4ZCBiYyAyNyAwMCAwMCAwMCAwMCAz
MSBjOSA4OSBkMCAwZiBiMSAwZSAzOSBjMiA3NSBkNSA4NSBkMiA3NCA0NiA5MCBmMyA5MCA4
YiA4NyBlNCAwMiAwMCAwMCA4NSBjMCA3NCBmNCAzMSBkYiA2NiA5MCA8OGI+IDAyIDg5IDFh
IDg1IGMwIDc0IDA4IDg5IGQzIDg5IGMyIGViIGYyIDY2IDkwIDg5IGQwIGZmIDUyIDA0Clsg
ICAgOC41ODUwMTVdIEVJUDogWzw0MTA0NmUzMD5dIHRhc2tfd29ya19ydW4rMHg2MC8weGEw
IFNTOkVTUCAwMDY4OjQ2OGY3ZjkwClsgICAgOC41ODUwMTVdIENSMjogMDAwMDAwMDAzNzZm
ZDAwMApbICAgIDguNjMxMDU1XSBDUkVEOiBJbnZhbGlkIGNyZWRlbnRpYWxzCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWo0LTA5MzAyMjM0LzBjNDRjMmQwZjQ1OWNkN2UyNzUyNDJiNzJm
NTAwMTM3YzRmYTgzNGQvZG1lc2ctcXVhbnRhbC14cHMtNjoyMDEzMTAwMjE4MjczMzozLjEy
LjAtcmMxLTAwMDUwLWcwYzQ0YzJkOjQ1Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0w
OTMwMjIzNC8wYzQ0YzJkMGY0NTljZDdlMjc1MjQyYjcyZjUwMDEzN2M0ZmE4MzRkL2RtZXNn
LXF1YW50YWwtbGtwLXR0MDItMjI6MjAxMzEwMDIwODU1MTE6My4xMi4wLXJjMS0wMDA1MC1n
MGM0NGMyZDo0NTYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDkzMDIyMzQvMGM0NGMy
ZDBmNDU5Y2Q3ZTI3NTI0MmI3MmY1MDAxMzdjNGZhODM0ZC9kbWVzZy1xdWFudGFsLXhwcy01
OjIwMTMxMDAyMTgyNzQwOjMuMTIuMC1yYzEtMDAwNTAtZzBjNDRjMmQ6NDU2Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWo0LTA5MzAyMjM0LzBjNDRjMmQwZjQ1OWNkN2UyNzUyNDJiNzJm
NTAwMTM3YzRmYTgzNGQvZG1lc2cteW9jdG8tY2Fpcm8tMTk6MjAxMzEwMDIxODI3NDE6My4x
Mi4wLXJjMS0wMDA1MC1nMGM0NGMyZDo0NTYKCjBjNDRjMmQwZjQ1OWNkN2UyNzUyNDJiNzJm
NTAwMTM3YzRmYTgzNGQgaXMgdGhlIGZpcnN0IGJhZCBjb21taXQKY29tbWl0IDBjNDRjMmQw
ZjQ1OWNkN2UyNzUyNDJiNzJmNTAwMTM3YzRmYTgzNGQKQXV0aG9yOiBQZXRlciBaaWpsc3Ry
YSA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+CkRhdGU6ICAgV2VkIFNlcCAxMSAxNToxOToyNCAy
MDEzICswMjAwCgogICAgeDg2OiBVc2UgYXNtIGdvdG8gdG8gaW1wbGVtZW50IGJldHRlciBt
b2RpZnlfYW5kX3Rlc3QoKSBmdW5jdGlvbnMKICAgIAogICAgTGludXMgc3VnZ2VzdGVkIHVz
aW5nIGFzbSBnb3RvIHRvIGdldCByaWQgb2YgdGhlIHR5cGljYWwgU0VUY2MgKyBURVNUCiAg
ICBpbnN0cnVjdGlvbiBwYWlyIC0tIHdoaWNoIGFsc28gY2xvYmJlcnMgYW4gZXh0cmEgcmVn
aXN0ZXIgLS0gZm9yIG91cgogICAgdHlwaWNhbCBtb2RpZnlfYW5kX3Rlc3QoKSBmdW5jdGlv
bnMuCiAgICAKICAgIEJlY2F1c2UgYXNtIGdvdG8gZG9lc24ndCBhbGxvdyBvdXRwdXQgZmll
bGRzIGl0IGhhcyB0byBpbmNsdWRlIGFuCiAgICB1bmNvbmRpdGluYWwgbWVtb3J5IGNsb2Ji
ZXIgd2hlbiBpdCBjaGFuZ2VzIGEgbWVtb3J5IHZhcmlhYmxlIHRvIGZvcmNlCiAgICBhIHJl
bG9hZC4KICAgIAogICAgTHVja2lseSBhbGwgYXRvbWljIG9wcyBhbHJlYWR5IGltcGx5IGEg
Y29tcGlsZXIgYmFycmllciB0byBnbyBhbG9uZwogICAgd2l0aCB0aGVpciBtZW1vcnkgYmFy
cmllciBzZW1hbnRpY3MuCiAgICAKICAgIFN1Z2dlc3RlZC1ieTogTGludXMgVG9ydmFsZHMg
PHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24ub3JnPgogICAgU2lnbmVkLW9mZi1ieTogUGV0
ZXIgWmlqbHN0cmEgPHBldGVyekBpbmZyYWRlYWQub3JnPgogICAgTGluazogaHR0cDovL2xr
bWwua2VybmVsLm9yZy9uL3RpcC0wbXRuOXNpd2JlbzFkMzNiYXAxNDIyc2VAZ2l0Lmtlcm5l
bC5vcmcKICAgIFNpZ25lZC1vZmYtYnk6IEluZ28gTW9sbmFyIDxtaW5nb0BrZXJuZWwub3Jn
PgoKOjA0MDAwMCAwNDAwMDAgNTEyYzc5NjU4NjQyMThlZjVhNDA1NjlmODBkZDYxN2ZjNzVi
NjBmOSAyMmM1Mjg2Y2MxYWExZTMzNmM4YjBkN2VmYmEwOGYzZjNlZmYwNjQwIE0JYXJjaApi
aXNlY3QgcnVuIHN1Y2Nlc3MKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kz
ODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIzNC9uZXh0Om1hc3Rlcjo0MzE0ODk1MTY1NjIzODc5
OTM3ZjQ2ZDc2NzY3MzY1NDY2MmI1NzBjOmJpc2VjdC11c2IKCjIwMTMtMTAtMDItMTg6Mjc6
NTQgNDMxNDg5NTE2NTYyMzg3OTkzN2Y0NmQ3Njc2NzM2NTQ2NjJiNTcwYyByZXVzZSAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIzNC80MzE0ODk1MTY1NjIzODc5OTM3ZjQ2
ZDc2NzY3MzY1NDY2MmI1NzBjL3ZtbGludXotMy4xMi4wLXJjMS0wMDA0OS1nNDMxNDg5NQoK
MjAxMy0xMC0wMi0xODoyNzo1NSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4JMwk2CTkJMTIJ
MTMJMTQJMTkJMjEJMjMJMjQJMjcuLgkyOQkzMAkzMS4JMzQuCTM4CTQyCTQ0Li4JNDYJNDcu
Lgk0OAk1MAk1MQk1Mgk1NQk1Ni4uCTYwCTY0CTY3CTc0CTgwCTExMQkxMzQJMTUxCTE3MQky
MDAJMjA5CTIzOAkyNjYJMjg0CTMwMQkzMTEJMzI2CTM2NgkzOTQJNDA0CTQxNAk0MjAJNDQ1
CTQ0Ni4JNDQ3Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLhtbMTszNW1hZGRfdG9f
cnVuX3F1ZXVlIDMbWzBtCi4uLi4uLgk0NDguCTQ0OS4uLi4uCTQ1MCBTVUNDRVNTCgpscyAt
YSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWo0LTA5MzAy
MjM0L25leHQ6bWFzdGVyOmEwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2Ix
Y2Y6YmlzZWN0LXVzYgogVEVTVCBGQUlMVVJFCkJVRzoga2VybmVsIGVhcmx5IGhhbmcgd2l0
aG91dCBhbnkgcHJpbnRrIG91dHB1dApDb21tYW5kIGxpbmU6IGh1bmdfdGFza19wYW5pYz0x
IHJjdXRyZWUucmN1X2NwdV9zdGFsbF90aW1lb3V0PTEwMCBsb2dfYnVmX2xlbj04TSBpZ25v
cmVfbG9nbGV2ZWwgZGVidWcgc2NoZWRfZGVidWcgYXBpYz1kZWJ1ZyBkeW5hbWljX3ByaW50
ayBzeXNycV9hbHdheXNfZW5hYmxlZCBwYW5pYz0xMCAgcHJvbXB0X3JhbWRpc2s9MCBjb25z
b2xlPXR0eVMwLDExNTIwMCBjb25zb2xlPXR0eTAgdmdhPW5vcm1hbCAgcm9vdD0vZGV2L3Jh
bTAgcncgbGluaz0va2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmln
LWo0LTA5MzAyMjM0L25leHQ6bWFzdGVyLy52bWxpbnV6LWEwY2YxYWJjMjVhYzE5N2RkOTdi
ODU3YzBmNjM0MTA2NmE4Y2IxY2YtMjAxMzEwMDEwMTQ3MTUtOS1hbnQgYnJhbmNoPW5leHQv
bWFzdGVyIEJPT1RfSU1BR0U9L2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDkzMDIyMzQv
YTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi92bWxpbnV6LTMuMTIu
MC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYiBub2FwaWMgbm9sYXBpYyBub2h6
PW9mZgpFYXJseSBoYW5nIGtlcm5lbDogdm1saW51ei0zLjEyLjAtcmMyLW5leHQtMjAxMzA5
MjctMDMxMDAtZ2EwY2YxYWIgMy4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNm
MWFiICMxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA5MzAyMjM0L2EwY2YxYWJjMjVh
YzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2ctcXVhbnRhbC1iZW5zLTI6MjAx
MzEwMDEwMTU1NDc6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjEK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDkzMDIyMzQvYTBjZjFhYmMyNWFjMTk3ZGQ5
N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy1xdWFudGFsLWJlbnMtMzoyMDEzMTAwMTAw
MTc1OTozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6MQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIzNC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2Mw
ZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXF1YW50YWwtbGtwLXN0MDEtMTE6MjAxMzEwMDEwMjE1
MjY6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjEKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctajQtMDkzMDIyMzQvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2
MzQxMDY2YThjYjFjZi9kbWVzZy1xdWFudGFsLWxrcC10dDAyLTE0OjIwMTMwOTMwMTQ0NDM5
OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjoxCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWo0LTA5MzAyMjM0L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0
MTA2NmE4Y2IxY2YvZG1lc2ctcXVhbnRhbC1sa3AtdHQwMi0xNDoyMDEzMDkzMDE2MzgyOToz
LjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6MQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1qNC0wOTMwMjIzNC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEw
NjZhOGNiMWNmL2RtZXNnLXF1YW50YWwtbGtwLXR0MDItMTU6MjAxMzA5MzAxNDQ0NDA6My4x
Mi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjEKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctajQtMDkzMDIyMzQvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2
YThjYjFjZi9kbWVzZy1xdWFudGFsLWxrcC10dDAyLTIzOjIwMTMwOTMwMTQ0NTA1OjMuMTIu
MC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjoxCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWo0LTA5MzAyMjM0L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4
Y2IxY2YvZG1lc2ctcXVhbnRhbC1sa3AtdHQwMi0zOjIwMTMwOTMwMTQ0NDUwOjMuMTIuMC1y
YzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjoxCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWo0LTA5MzAyMjM0L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2Ix
Y2YvZG1lc2ctcXVhbnRhbC1sa3AtdHQwMi04OjIwMTMwOTMwMTQ0NDMzOjMuMTIuMC1yYzIt
bmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWo0LTA5MzAyMjM0L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2Yv
ZG1lc2ctcXVhbnRhbC13YWltZWEtMjoyMDEzMTAwMTA5NTEwNDozLjEyLjAtcmMyLW5leHQt
MjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0w
OTMwMjIzNC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNn
LXF1YW50YWwtd2FpbWVhLTQ6MjAxMzEwMDExMDExMDQ6My4xMi4wLXJjMi1uZXh0LTIwMTMw
OTI3LTAzMTAwLWdhMGNmMWFiOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDkzMDIy
MzQvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy1xdWFu
dGFsLXdhaW1lYS05OjIwMTMxMDAxMjExMjEwOjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0w
MzEwMC1nYTBjZjFhYjoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA5MzAyMjM0L2Ew
Y2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2ctcXVhbnRhbC14
cHMtMjoyMDEzMTAwMTAwMTgyMzozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2Ew
Y2YxYWI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIzNC9hMGNmMWFiYzI1
YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLWJlbnMtNDoyMDEz
MTAwMTAyMTQxMjozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6MQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIzNC9hMGNmMWFiYzI1YWMxOTdkZDk3
Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLWxrcC1zdDAxLTM6MjAxMzEwMDEw
MjE1MTA6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjEKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctajQtMDkzMDIyMzQvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdj
MGY2MzQxMDY2YThjYjFjZi9kbWVzZy15b2N0by1sa3AtdHQwMi05OjIwMTMwOTMwMTQ0NDE2
OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjoxCgpbZGV0YWNoZWQg
SEVBRCBmMmU5YmIwXSBSZXZlcnQgIng4NjogVXNlIGFzbSBnb3RvIHRvIGltcGxlbWVudCBi
ZXR0ZXIgbW9kaWZ5X2FuZF90ZXN0KCkgZnVuY3Rpb25zIgogNSBmaWxlcyBjaGFuZ2VkLCA5
MiBpbnNlcnRpb25zKCspLCA1OCBkZWxldGlvbnMoLSkKIGRlbGV0ZSBtb2RlIDEwMDY0NCBh
cmNoL3g4Ni9pbmNsdWRlL2FzbS9ybXdjYy5oCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajQtMDkzMDIyMzQvbmV4dDptYXN0ZXI6ZjJlOWJi
MGFlYjk2NDBmM2NiZDNhYTVlNjQ4ZmE3NjA0YjZkMWY3YzpiaXNlY3QtdXNiCgoyMDEzLTEw
LTAyLTIxOjM4OjMzIGYyZTliYjBhZWI5NjQwZjNjYmQzYWE1ZTY0OGZhNzYwNGI2ZDFmN2Mg
Y29tcGlsaW5nChtbMTszNW1pMzg2LXJhbmRjb25maWctajQtMDkzMDIyMzQ6IG1ha2UgcHJl
cGFyZSBmYWlsZWQbWzBtCjIwMTMtMTAtMDItMjE6Mzg6NDEgZjJlOWJiMGFlYjk2NDBmM2Ni
ZDNhYTVlNjQ4ZmE3NjA0YjZkMWY3YyBTS0lQIEJST0tFTiBCVUlMRApDaGVjayBlcnJvcyBp
biAvY2Mvd2ZnL3VzYi1iaXNlY3QgYW5kIC90bXAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1q
NC0wOTMwMjIzNC9mMmU5YmIwYWViOTY0MGYzY2JkM2FhNWU2NDhmYTc2MDRiNmQxZjdjCgo9
PT09PT09PT0gdXBzdHJlYW0gPT09PT09PT09CkZldGNoaW5nIGxpbnVzCmxzIC1hIC9rZXJu
ZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajQtMDkzMDIyMzQvbmV4
dDptYXN0ZXI6YzMxZWVhY2VkMjJjZThiZDYxMjY4YTNjNTk1ZDU0MmJiMzhjMGE0ZjpiaXNl
Y3QtdXNiCgoyMDEzLTEwLTAyLTIxOjM4OjQ0IGMzMWVlYWNlZDIyY2U4YmQ2MTI2OGEzYzU5
NWQ1NDJiYjM4YzBhNGYgY29tcGlsaW5nCgoyMDEzLTEwLTAyLTIxOjQyOjA5IGRldGVjdGlu
ZyBib290IHN0YXRlIDMuMTIuMC1yYzMtMDAxODYtZ2MzMWVlYWMuLi4JMQk0Lgk3Lgk4CTEy
Li4uLgkxNC4JMTgJMzIJNTMJNzcJOTIJMTA3CTE0OAkxNjkJMTg5CTIxMAkyNTcJMjc4CTMx
NAkzMjQJMzcwCTM4NAk0MjEJNDUwIFNVQ0NFU1MKCgo9PT09PT09PT0gbGludXgtbmV4dCA9
PT09PT09PT0KRmV0Y2hpbmcgbmV4dApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0vaTM4Ni1yYW5kY29uZmlnLWo0LTA5MzAyMjM0L25leHQ6bWFzdGVyOmEwY2YxYWJjMjVh
YzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2Y6YmlzZWN0LXVzYgogVEVTVCBGQUlMVVJF
CkJVRzoga2VybmVsIGVhcmx5IGhhbmcgd2l0aG91dCBhbnkgcHJpbnRrIG91dHB1dApDb21t
YW5kIGxpbmU6IGh1bmdfdGFza19wYW5pYz0xIHJjdXRyZWUucmN1X2NwdV9zdGFsbF90aW1l
b3V0PTEwMCBsb2dfYnVmX2xlbj04TSBpZ25vcmVfbG9nbGV2ZWwgZGVidWcgc2NoZWRfZGVi
dWcgYXBpYz1kZWJ1ZyBkeW5hbWljX3ByaW50ayBzeXNycV9hbHdheXNfZW5hYmxlZCBwYW5p
Yz0xMCAgcHJvbXB0X3JhbWRpc2s9MCBjb25zb2xlPXR0eVMwLDExNTIwMCBjb25zb2xlPXR0
eTAgdmdhPW5vcm1hbCAgcm9vdD0vZGV2L3JhbTAgcncgbGluaz0va2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWo0LTA5MzAyMjM0L25leHQ6bWFzdGVyLy52
bWxpbnV6LWEwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YtMjAxMzEw
MDEwMTQ3MTUtOS1hbnQgYnJhbmNoPW5leHQvbWFzdGVyIEJPT1RfSU1BR0U9L2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctajQtMDkzMDIyMzQvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2
MzQxMDY2YThjYjFjZi92bWxpbnV6LTMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1n
YTBjZjFhYiBub2FwaWMgbm9sYXBpYyBub2h6PW9mZgpFYXJseSBoYW5nIGtlcm5lbDogdm1s
aW51ei0zLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWIgMy4xMi4wLXJj
Mi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiICMxCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWo0LTA5MzAyMjM0L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2Ix
Y2YvZG1lc2ctcXVhbnRhbC1iZW5zLTI6MjAxMzEwMDEwMTU1NDc6My4xMi4wLXJjMi1uZXh0
LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQt
MDkzMDIyMzQvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVz
Zy1xdWFudGFsLWJlbnMtMzoyMDEzMTAwMTAwMTc1OTozLjEyLjAtcmMyLW5leHQtMjAxMzA5
MjctMDMxMDAtZ2EwY2YxYWI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIz
NC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXF1YW50
YWwtbGtwLXN0MDEtMTE6MjAxMzEwMDEwMjE1MjY6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3
LTAzMTAwLWdhMGNmMWFiOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDkzMDIyMzQv
YTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy1xdWFudGFs
LWxrcC10dDAyLTE0OjIwMTMwOTMwMTQ0NDM5OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0w
MzEwMC1nYTBjZjFhYjoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA5MzAyMjM0L2Ew
Y2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2ctcXVhbnRhbC1s
a3AtdHQwMi0xNDoyMDEzMDkzMDE2MzgyOTozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMx
MDAtZ2EwY2YxYWI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIzNC9hMGNm
MWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXF1YW50YWwtbGtw
LXR0MDItMTU6MjAxMzA5MzAxNDQ0NDA6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAw
LWdhMGNmMWFiOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDkzMDIyMzQvYTBjZjFh
YmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy1xdWFudGFsLWxrcC10
dDAyLTIzOjIwMTMwOTMwMTQ0NTA1OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1n
YTBjZjFhYjoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA5MzAyMjM0L2EwY2YxYWJj
MjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2ctcXVhbnRhbC1sa3AtdHQw
Mi0zOjIwMTMwOTMwMTQ0NDUwOjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBj
ZjFhYjoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA5MzAyMjM0L2EwY2YxYWJjMjVh
YzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2ctcXVhbnRhbC1sa3AtdHQwMi04
OjIwMTMwOTMwMTQ0NDMzOjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFh
YjoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo0LTA5MzAyMjM0L2EwY2YxYWJjMjVhYzE5
N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2ctcXVhbnRhbC13YWltZWEtMjoyMDEz
MTAwMTA5NTEwNDozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6MQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0wOTMwMjIzNC9hMGNmMWFiYzI1YWMxOTdkZDk3
Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXF1YW50YWwtd2FpbWVhLTQ6MjAxMzEwMDEx
MDExMDQ6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjEKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctajQtMDkzMDIyMzQvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdj
MGY2MzQxMDY2YThjYjFjZi9kbWVzZy1xdWFudGFsLXdhaW1lYS05OjIwMTMxMDAxMjExMjEw
OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjoxCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWo0LTA5MzAyMjM0L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0
MTA2NmE4Y2IxY2YvZG1lc2ctcXVhbnRhbC14cHMtMjoyMDEzMTAwMTAwMTgyMzozLjEyLjAt
cmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6MQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1qNC0wOTMwMjIzNC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNi
MWNmL2RtZXNnLXlvY3RvLWJlbnMtNDoyMDEzMTAwMTAyMTQxMjozLjEyLjAtcmMyLW5leHQt
MjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNC0w
OTMwMjIzNC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNn
LXlvY3RvLWxrcC1zdDAxLTM6MjAxMzEwMDEwMjE1MTA6My4xMi4wLXJjMi1uZXh0LTIwMTMw
OTI3LTAzMTAwLWdhMGNmMWFiOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajQtMDkzMDIy
MzQvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy15b2N0
by1sa3AtdHQwMi05OjIwMTMwOTMwMTQ0NDE2OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0w
MzEwMC1nYTBjZjFhYjoxCgo=

--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.12.0-rc2-02842-g45c4ea0"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.12.0-rc2 Kernel Configuration
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
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
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
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
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
# CONFIG_CGROUPS is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_IPC_NS is not set
CONFIG_USER_NS=y
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
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
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
CONFIG_AIO=y
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
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
# CONFIG_PROFILING is not set
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
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set
# CONFIG_CMDLINE_PARSER is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_AMIGA_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y

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
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
CONFIG_GOLDFISH=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_GOLDFISH=y
CONFIG_X86_WANT_INTEL_MID=y
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_RDC321X is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
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
CONFIG_MWINCHIPC6=y
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
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_OOSTORE=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
# CONFIG_CPU_SUP_CYRIX_32 is not set
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
# CONFIG_CPU_SUP_TRANSMETA_32 is not set
# CONFIG_CPU_SUP_UMC_32 is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_UP_APIC=y
# CONFIG_X86_UP_IOAPIC is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
CONFIG_X86_ANCIENT_MCE=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=y
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
CONFIG_VMSPLIT_1G=y
CONFIG_PAGE_OFFSET=0x40000000
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
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
# CONFIG_X86_PAT is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set

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
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
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
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K6=y
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=y
CONFIG_X86_P4_CLOCKMOD=y
CONFIG_X86_CPUFREQ_NFORCE2=y
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
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_CPU_IDLE_GOV_MENU is not set
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
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
# CONFIG_GEOS is not set
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
# CONFIG_BINFMT_AOUT is not set
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
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=y
CONFIG_ATM=y
# CONFIG_ATM_LANE is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
CONFIG_ATALK=y
# CONFIG_DEV_APPLETALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
CONFIG_PHONET=y
CONFIG_IEEE802154=y
# CONFIG_MAC802154 is not set
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=y
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
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
CONFIG_6PACK=y
# CONFIG_BPQETHER is not set
CONFIG_DMASCC=y
CONFIG_SCC=y
# CONFIG_SCC_DELAY is not set
# CONFIG_SCC_TRXECHO is not set
# CONFIG_BAYCOM_SER_FDX is not set
CONFIG_BAYCOM_SER_HDX=y
# CONFIG_BAYCOM_PAR is not set
CONFIG_BAYCOM_EPP=y
CONFIG_YAM=y
# CONFIG_CAN is not set
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
CONFIG_IRDA_CACHE_LAST_LSAP=y
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
CONFIG_DONGLE=y
# CONFIG_ESI_DONGLE is not set
CONFIG_ACTISYS_DONGLE=y
# CONFIG_TEKRAM_DONGLE is not set
CONFIG_TOIM3232_DONGLE=y
CONFIG_LITELINK_DONGLE=y
# CONFIG_MA600_DONGLE is not set
CONFIG_GIRBIL_DONGLE=y
CONFIG_MCP2120_DONGLE=y
CONFIG_OLD_BELKIN_DONGLE=y
CONFIG_ACT200L_DONGLE=y

#
# FIR device drivers
#
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=y
# CONFIG_ALI_FIR is not set
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
CONFIG_BT=y
# CONFIG_BT_RFCOMM is not set
# CONFIG_BT_BNEP is not set
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTSDIO is not set
CONFIG_BT_HCIUART=y
CONFIG_BT_HCIUART_H4=y
# CONFIG_BT_HCIUART_BCSP is not set
CONFIG_BT_HCIUART_ATH3K=y
# CONFIG_BT_HCIUART_LL is not set
CONFIG_BT_HCIUART_3WIRE=y
CONFIG_BT_HCIVHCI=y
# CONFIG_BT_MRVL is not set
# CONFIG_WIRELESS is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
# CONFIG_RFKILL_INPUT is not set
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_NET_9P_DEBUG=y
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=y
CONFIG_CAIF_USB=y
CONFIG_NFC=y
CONFIG_NFC_NCI=y
CONFIG_NFC_NCI_SPI=y
CONFIG_NFC_HCI=y
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_SIM=y
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
# CONFIG_DEVTMPFS_MOUNT is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
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
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
CONFIG_SSFDC=y
# CONFIG_SM_FTL is not set
CONFIG_MTD_OOPS=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
# CONFIG_MTD_JEDECPROBE is not set
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
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PHYSMAP is not set
CONFIG_MTD_SC520CDP=y
CONFIG_MTD_NETSC520=y
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=y
CONFIG_MTD_DATAFLASH_WRITE_VERIFY=y
# CONFIG_MTD_DATAFLASH_OTP is not set
CONFIG_MTD_M25P80=y
CONFIG_M25PXX_USE_FAST_READ=y
# CONFIG_MTD_SST25L is not set
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=y
# CONFIG_MTD_NAND_DENALI_PCI is not set
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=y
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
# CONFIG_MTD_NAND_DOCG4 is not set
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_CS553X=y
CONFIG_MTD_NAND_NANDSIM=y
# CONFIG_MTD_NAND_PLATFORM is not set
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
CONFIG_MTD_ONENAND_GENERIC=y
# CONFIG_MTD_ONENAND_OTP is not set
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
# CONFIG_MTD_UBI is not set
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
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
# CONFIG_BLK_DEV_OSD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RSXX is not set
# CONFIG_BLOCKCONSOLE is not set

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
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_BMP085_SPI=y
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
CONFIG_EEPROM_93XX46=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set

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
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_LEGACY=y
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_IDE_GD is not set
# CONFIG_BLK_DEV_IDECD is not set
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
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
# CONFIG_BLK_DEV_4DRIVES is not set
CONFIG_BLK_DEV_ALI14XX=y
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
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_ENCLOSURE=y
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_FC_TGT_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_AHCI_PLATFORM is not set
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
# CONFIG_ATA_BMDMA is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_QDI is not set
# CONFIG_PATA_RZ1000 is not set
CONFIG_PATA_WINBOND_VLB=y

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_LEGACY=y
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_AUTODETECT is not set
CONFIG_MD_LINEAR=y
# CONFIG_MD_RAID0 is not set
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
CONFIG_BCACHE=y
# CONFIG_BCACHE_DEBUG is not set
CONFIG_BCACHE_CLOSURES_DEBUG=y
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=y
CONFIG_DM_BIO_PRISON=y
CONFIG_DM_PERSISTENT_DATA=y
# CONFIG_DM_CRYPT is not set
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_THIN_PROVISIONING=y
CONFIG_DM_DEBUG_BLOCK_STACK_TRACING=y
CONFIG_DM_CACHE=y
CONFIG_DM_CACHE_MQ=y
CONFIG_DM_CACHE_CLEANER=y
CONFIG_DM_MIRROR=y
CONFIG_DM_RAID=y
CONFIG_DM_LOG_USERSPACE=y
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
CONFIG_DM_DELAY=y
CONFIG_DM_UEVENT=y
# CONFIG_DM_FLAKEY is not set
CONFIG_DM_VERITY=y
# CONFIG_DM_SWITCH is not set
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=y
CONFIG_TCM_FILEIO=y
# CONFIG_TCM_PSCSI is not set
CONFIG_LOOPBACK_TARGET=y
CONFIG_ISCSI_TARGET=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set

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
# CONFIG_INPUT_JOYDEV is not set
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
CONFIG_KEYBOARD_QT2160=y
CONFIG_KEYBOARD_LKKBD=y
# CONFIG_KEYBOARD_TCA6416 is not set
CONFIG_KEYBOARD_TCA8418=y
# CONFIG_KEYBOARD_LM8323 is not set
CONFIG_KEYBOARD_LM8333=y
# CONFIG_KEYBOARD_MAX7359 is not set
CONFIG_KEYBOARD_MCS=y
# CONFIG_KEYBOARD_MPR121 is not set
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_OPENCORES=y
CONFIG_KEYBOARD_GOLDFISH_EVENTS=y
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_STMPE=y
CONFIG_KEYBOARD_TC3589X=y
CONFIG_KEYBOARD_TWL4030=y
CONFIG_KEYBOARD_XTKBD=y
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=y
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_DB9 is not set
CONFIG_JOYSTICK_GAMECON=y
# CONFIG_JOYSTICK_TURBOGRAFX is not set
# CONFIG_JOYSTICK_AS5011 is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_JOYSTICK_WALKERA0701=y
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
CONFIG_TOUCHSCREEN_AD7877=y
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
CONFIG_TOUCHSCREEN_AD7879_SPI=y
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP_I2C=y
CONFIG_TOUCHSCREEN_CYTTSP_SPI=y
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP4_I2C is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_SPI is not set
CONFIG_TOUCHSCREEN_DA9034=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
CONFIG_TOUCHSCREEN_EETI=y
CONFIG_TOUCHSCREEN_FUJITSU=y
CONFIG_TOUCHSCREEN_ILI210X=y
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=y
CONFIG_TOUCHSCREEN_MAX11801=y
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_HTCPEN=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_WM831X is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_MC13783=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC2005=y
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_ST1232=y
# CONFIG_TOUCHSCREEN_STMPE is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
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
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_GOLDFISH_TTY is not set
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
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=y
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_TIMBERDALE=y
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
CONFIG_SERIAL_ST_ASC=y
# CONFIG_SERIAL_ST_ASC_CONSOLE is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=y
# CONFIG_DTLK is not set
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
CONFIG_MWAVE=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
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
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=y
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_ELEKTOR=y
# CONFIG_I2C_PCA_ISA is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_ATMEL=y
# CONFIG_SPI_BCM2835 is not set
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
CONFIG_SPI_EP93XX=y
# CONFIG_SPI_IMX is not set
# CONFIG_SPI_LM70_LLP is not set
CONFIG_SPI_FSL_DSPI=y
# CONFIG_SPI_OMAP24XX is not set
CONFIG_SPI_TI_QSPI=y
CONFIG_SPI_OMAP_100K=y
CONFIG_SPI_ORION=y
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=y
CONFIG_SPI_SH=y
CONFIG_SPI_SH_HSPI=y
# CONFIG_SPI_TEGRA114 is not set
# CONFIG_SPI_TEGRA20_SFLASH is not set
# CONFIG_SPI_TEGRA20_SLINK is not set
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_XCOMM=y
CONFIG_SPI_XILINX=y
CONFIG_SPI_DESIGNWARE=y
# CONFIG_SPI_DW_PCI is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
# CONFIG_SPI_TLE62X0 is not set
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
CONFIG_NTP_PPS=y

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
CONFIG_PPS_CLIENT_LDISC=y
CONFIG_PPS_CLIENT_PARPORT=y
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
CONFIG_GPIO_DEVRES=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_DS1WM is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_MAX8925_POWER is not set
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9030=y
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_PCF50633=y
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_TWL4030 is not set
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_MANAGER=y
CONFIG_CHARGER_BQ2415X=y
# CONFIG_CHARGER_SMB347 is not set
CONFIG_BATTERY_GOLDFISH=y
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADCXX=y
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_HTU21 is not set
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
# CONFIG_SENSORS_IIO_HWMON is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=y
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MCP3021=y
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
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_APPLESMC=y
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
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_CPU_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set

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
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_HOST_SOC=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_CROS_EC is not set
CONFIG_PMIC_DA903X=y
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_RETU is not set
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
# CONFIG_AB3100_OTP is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
CONFIG_STMPE_SPI=y
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_MADC is not set
# CONFIG_MFD_TWL4030_AUDIO is not set
CONFIG_TWL6040_CORE=y
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM8997 is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_ANATOP is not set
# CONFIG_REGULATOR_AB3100 is not set
# CONFIG_REGULATOR_DA903X is not set
# CONFIG_REGULATOR_DA9055 is not set
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=y
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8907 is not set
# CONFIG_REGULATOR_MAX8925 is not set
# CONFIG_REGULATOR_MAX8952 is not set
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MAX77686=y
CONFIG_REGULATOR_MC13XXX_CORE=y
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
# CONFIG_REGULATOR_RC5T583 is not set
# CONFIG_REGULATOR_S2MPS11 is not set
# CONFIG_REGULATOR_S5M8767 is not set
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65217=y
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_TWL4030=y
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8400=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_V4L2_INT_DEVICE=y
CONFIG_DVB_CORE=y
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y

#
# Media drivers
#
CONFIG_RC_CORE=y
# CONFIG_RC_MAP is not set
CONFIG_RC_DECODERS=y
CONFIG_LIRC=y
# CONFIG_IR_LIRC_CODEC is not set
# CONFIG_IR_NEC_DECODER is not set
CONFIG_IR_RC5_DECODER=y
CONFIG_IR_RC6_DECODER=y
CONFIG_IR_JVC_DECODER=y
CONFIG_IR_SONY_DECODER=y
CONFIG_IR_RC5_SZ_DECODER=y
# CONFIG_IR_SANYO_DECODER is not set
CONFIG_IR_MCE_KBD_DECODER=y
CONFIG_RC_DEVICES=y
# CONFIG_RC_ATI_REMOTE is not set
# CONFIG_IR_ENE is not set
# CONFIG_IR_IMON is not set
# CONFIG_IR_MCEUSB is not set
# CONFIG_IR_ITE_CIR is not set
# CONFIG_IR_FINTEK is not set
# CONFIG_IR_NUVOTON is not set
# CONFIG_IR_REDRAT3 is not set
# CONFIG_IR_STREAMZAP is not set
# CONFIG_IR_WINBOND_CIR is not set
# CONFIG_IR_IGUANA is not set
# CONFIG_IR_TTUSBIR is not set
# CONFIG_RC_LOOPBACK is not set
CONFIG_IR_GPIO_CIR=y
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=y
# CONFIG_RADIO_ADAPTERS is not set
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_SMS_SIANO_MDTV=y
# CONFIG_SMS_SIANO_RC is not set

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
# CONFIG_VIDEO_IR_I2C is not set

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_TVAUDIO is not set
CONFIG_VIDEO_TDA7432=y
# CONFIG_VIDEO_TDA9840 is not set
# CONFIG_VIDEO_TEA6415C is not set
CONFIG_VIDEO_TEA6420=y
# CONFIG_VIDEO_MSP3400 is not set
CONFIG_VIDEO_CS5345=y
CONFIG_VIDEO_CS53L32A=y
CONFIG_VIDEO_TLV320AIC23B=y
# CONFIG_VIDEO_UDA1342 is not set
# CONFIG_VIDEO_WM8775 is not set
CONFIG_VIDEO_WM8739=y
CONFIG_VIDEO_VP27SMPX=y
# CONFIG_VIDEO_SONY_BTF_MPX is not set

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set

#
# Video decoders
#
# CONFIG_VIDEO_ADV7180 is not set
# CONFIG_VIDEO_ADV7183 is not set
# CONFIG_VIDEO_BT819 is not set
CONFIG_VIDEO_BT856=y
CONFIG_VIDEO_BT866=y
# CONFIG_VIDEO_KS0127 is not set
CONFIG_VIDEO_ML86V7667=y
# CONFIG_VIDEO_SAA7110 is not set
CONFIG_VIDEO_SAA711X=y
CONFIG_VIDEO_SAA7191=y
CONFIG_VIDEO_TVP514X=y
CONFIG_VIDEO_TVP5150=y
CONFIG_VIDEO_TVP7002=y
CONFIG_VIDEO_TW2804=y
CONFIG_VIDEO_TW9903=y
CONFIG_VIDEO_TW9906=y
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=y
# CONFIG_VIDEO_CX25840 is not set

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=y
CONFIG_VIDEO_SAA7185=y
# CONFIG_VIDEO_ADV7170 is not set
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
# CONFIG_MEDIA_TUNER_TEA5761 is not set
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_MT2060=y
CONFIG_MEDIA_TUNER_MT2063=y
CONFIG_MEDIA_TUNER_MT2266=y
# CONFIG_MEDIA_TUNER_MT2131 is not set
# CONFIG_MEDIA_TUNER_QT1010 is not set
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MXL5005S=y
CONFIG_MEDIA_TUNER_MXL5007T=y
CONFIG_MEDIA_TUNER_MC44S803=y
# CONFIG_MEDIA_TUNER_MAX2165 is not set
CONFIG_MEDIA_TUNER_TDA18218=y
# CONFIG_MEDIA_TUNER_FC0011 is not set
CONFIG_MEDIA_TUNER_FC0012=y
# CONFIG_MEDIA_TUNER_FC0013 is not set
# CONFIG_MEDIA_TUNER_TDA18212 is not set
CONFIG_MEDIA_TUNER_E4000=y
CONFIG_MEDIA_TUNER_FC2580=y
CONFIG_MEDIA_TUNER_TUA9001=y
CONFIG_MEDIA_TUNER_IT913X=y
CONFIG_MEDIA_TUNER_R820T=y

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=y
CONFIG_DVB_STB6100=y
CONFIG_DVB_STV090x=y
# CONFIG_DVB_STV6110x is not set

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=y
# CONFIG_DVB_TDA18271C2DD is not set

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=y
# CONFIG_DVB_CX24123 is not set
CONFIG_DVB_MT312=y
CONFIG_DVB_ZL10036=y
CONFIG_DVB_ZL10039=y
CONFIG_DVB_S5H1420=y
CONFIG_DVB_STV0288=y
# CONFIG_DVB_STB6000 is not set
CONFIG_DVB_STV0299=y
CONFIG_DVB_STV6110=y
CONFIG_DVB_STV0900=y
# CONFIG_DVB_TDA8083 is not set
CONFIG_DVB_TDA10086=y
CONFIG_DVB_TDA8261=y
CONFIG_DVB_VES1X93=y
CONFIG_DVB_TUNER_ITD1000=y
# CONFIG_DVB_TUNER_CX24113 is not set
CONFIG_DVB_TDA826X=y
# CONFIG_DVB_TUA6100 is not set
CONFIG_DVB_CX24116=y
# CONFIG_DVB_SI21XX is not set
# CONFIG_DVB_TS2020 is not set
CONFIG_DVB_DS3000=y
# CONFIG_DVB_MB86A16 is not set
CONFIG_DVB_TDA10071=y

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=y
# CONFIG_DVB_SP887X is not set
# CONFIG_DVB_CX22700 is not set
CONFIG_DVB_CX22702=y
CONFIG_DVB_S5H1432=y
CONFIG_DVB_DRXD=y
CONFIG_DVB_L64781=y
CONFIG_DVB_TDA1004X=y
# CONFIG_DVB_NXT6000 is not set
# CONFIG_DVB_MT352 is not set
CONFIG_DVB_ZL10353=y
CONFIG_DVB_DIB3000MB=y
CONFIG_DVB_DIB3000MC=y
# CONFIG_DVB_DIB7000M is not set
CONFIG_DVB_DIB7000P=y
CONFIG_DVB_DIB9000=y
CONFIG_DVB_TDA10048=y
# CONFIG_DVB_AF9013 is not set
# CONFIG_DVB_EC100 is not set
# CONFIG_DVB_HD29L2 is not set
CONFIG_DVB_STV0367=y
# CONFIG_DVB_CXD2820R is not set
CONFIG_DVB_RTL2830=y
CONFIG_DVB_RTL2832=y

#
# DVB-C (cable) frontends
#
# CONFIG_DVB_VES1820 is not set
CONFIG_DVB_TDA10021=y
# CONFIG_DVB_TDA10023 is not set
CONFIG_DVB_STV0297=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
# CONFIG_DVB_NXT200X is not set
# CONFIG_DVB_OR51211 is not set
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
# CONFIG_DVB_MB86A20S is not set

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
CONFIG_DVB_ISL6421=y
CONFIG_DVB_ISL6423=y
CONFIG_DVB_A8293=y
CONFIG_DVB_LGS8GL5=y
CONFIG_DVB_LGS8GXX=y
# CONFIG_DVB_ATBM8830 is not set
CONFIG_DVB_TDA665x=y
CONFIG_DVB_IX2505V=y
CONFIG_DVB_IT913X_FE=y
CONFIG_DVB_M88RS2000=y
CONFIG_DVB_AF9033=y

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
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
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
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
CONFIG_FB_AUO_K1901=y
CONFIG_FB_SIMPLE=y
CONFIG_EXYNOS_VIDEO=y
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
CONFIG_LOGO_LINUX_VGA16=y
# CONFIG_LOGO_LINUX_CLUT224 is not set
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
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
# CONFIG_HID_PICOLCD_FB is not set
# CONFIG_HID_PICOLCD_LEDS is not set
# CONFIG_HID_PICOLCD_CIR is not set
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=y
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
# CONFIG_HID_THRUSTMASTER is not set
CONFIG_HID_WACOM=y
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
# CONFIG_HID_ZYDACRON is not set
CONFIG_HID_SENSOR_HUB=y

#
# I2C HID support
#
CONFIG_I2C_HID=y
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
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_OMAP_CONTROL_USB is not set
# CONFIG_OMAP_USB3 is not set
# CONFIG_AM335X_PHY_USB is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
CONFIG_MMC_UNSAFE_RESUME=y
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
# CONFIG_MMC_SDHCI_PLTFM is not set
# CONFIG_MMC_OMAP_HS is not set
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_GOLDFISH=y
CONFIG_MMC_SPI=y
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

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
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3533=y
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_LP8788=y
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_DA903X=y
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_REGULATOR=y
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_OT200=y
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_DECODE_MCE=y
# CONFIG_EDAC_MCE_INJ is not set
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
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=y
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_DS3232=y
CONFIG_RTC_DRV_LP8788=y
# CONFIG_RTC_DRV_MAX6900 is not set
CONFIG_RTC_DRV_MAX8907=y
CONFIG_RTC_DRV_MAX8925=y
# CONFIG_RTC_DRV_MAX77686 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_ISL12022=y
# CONFIG_RTC_DRV_X1205 is not set
CONFIG_RTC_DRV_PCF2127=y
CONFIG_RTC_DRV_PCF8523=y
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
# CONFIG_RTC_DRV_M41T80_WDT is not set
CONFIG_RTC_DRV_BQ32K=y
# CONFIG_RTC_DRV_TWL4030 is not set
# CONFIG_RTC_DRV_RC5T583 is not set
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=y
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
# CONFIG_RTC_DRV_M41T94 is not set
CONFIG_RTC_DRV_DS1305=y
CONFIG_RTC_DRV_DS1390=y
CONFIG_RTC_DRV_MAX6902=y
CONFIG_RTC_DRV_R9701=y
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_DS3234 is not set
CONFIG_RTC_DRV_PCF2123=y
CONFIG_RTC_DRV_RX4581=y

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DA9055=y
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set
CONFIG_RTC_DRV_DS2404=y
CONFIG_RTC_DRV_WM831X=y
CONFIG_RTC_DRV_PCF50633=y
# CONFIG_RTC_DRV_AB3100 is not set

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=y
# CONFIG_RTC_DRV_MOXART is not set

#
# HID Sensor RTC drivers
#
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

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
CONFIG_NET_DMA=y
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=y
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
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
CONFIG_GOLDFISH_PIPE=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y

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
CONFIG_BMA180=y
# CONFIG_HID_SENSOR_ACCEL_3D is not set
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
CONFIG_KXSD9=y

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
CONFIG_AD7266=y
CONFIG_AD7298=y
# CONFIG_AD7476 is not set
# CONFIG_AD7791 is not set
CONFIG_AD7793=y
CONFIG_AD7887=y
# CONFIG_AD7923 is not set
# CONFIG_LP8788_ADC is not set
CONFIG_MAX1363=y
# CONFIG_MCP320X is not set
CONFIG_MCP3422=y
CONFIG_NAU7802=y
CONFIG_TI_ADC081C=y
CONFIG_TI_AM335X_ADC=y
# CONFIG_TWL6030_GPADC is not set

#
# Amplifiers
#
CONFIG_AD8366=y

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
# CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS is not set
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_SPI=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
CONFIG_AD5360=y
# CONFIG_AD5380 is not set
CONFIG_AD5421=y
CONFIG_AD5446=y
CONFIG_AD5449=y
# CONFIG_AD5504 is not set
CONFIG_AD5624R_SPI=y
CONFIG_AD5686=y
CONFIG_AD5755=y
CONFIG_AD5764=y
CONFIG_AD5791=y
CONFIG_AD7303=y
CONFIG_MAX517=y
CONFIG_MCP4725=y

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
# CONFIG_AD9523 is not set

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=y

#
# Digital gyroscope sensors
#
# CONFIG_ADIS16080 is not set
CONFIG_ADIS16130=y
# CONFIG_ADIS16136 is not set
# CONFIG_ADIS16260 is not set
CONFIG_ADXRS450=y
CONFIG_HID_SENSOR_GYRO_3D=y
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_IIO_ST_GYRO_SPI_3AXIS=y
CONFIG_ITG3200=y

#
# Inertial measurement units
#
# CONFIG_ADIS16400 is not set
CONFIG_ADIS16480=y
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y
# CONFIG_INV_MPU6050_IIO is not set

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
CONFIG_APDS9300=y
CONFIG_GP2AP020A00F=y
CONFIG_HID_SENSOR_ALS=y
# CONFIG_SENSORS_LM3533 is not set
CONFIG_TCS3472=y
CONFIG_SENSORS_TSL2563=y
CONFIG_TSL4531=y
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
CONFIG_IIO_ST_MAGN_SPI_3AXIS=y

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure sensors
#
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y
CONFIG_IIO_ST_PRESS_SPI=y

#
# Temperature sensors
#
# CONFIG_TMP006 is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
# CONFIG_FMC is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_DMIID is not set
CONFIG_DMI_SYSFS=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
# CONFIG_EXT3_FS_SECURITY is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
CONFIG_BTRFS_DEBUG=y
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_DEBUG=y
CONFIG_CACHEFILES=y
CONFIG_CACHEFILES_DEBUG=y

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
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
CONFIG_ADFS_FS_RW=y
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=y
CONFIG_ECRYPT_FS_MESSAGING=y
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
CONFIG_HFSPLUS_FS_POSIX_ACL=y
# CONFIG_BEFS_FS is not set
CONFIG_BFS_FS=y
# CONFIG_EFS_FS is not set
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
# CONFIG_JFFS2_SUMMARY is not set
CONFIG_JFFS2_FS_XATTR=y
CONFIG_JFFS2_FS_POSIX_ACL=y
CONFIG_JFFS2_FS_SECURITY=y
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
# CONFIG_JFFS2_ZLIB is not set
CONFIG_JFFS2_LZO=y
CONFIG_JFFS2_RTIME=y
CONFIG_JFFS2_RUBIN=y
CONFIG_JFFS2_CMODE_NONE=y
# CONFIG_JFFS2_CMODE_PRIORITY is not set
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
CONFIG_LOGFS=y
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_XATTR=y
# CONFIG_SQUASHFS_ZLIB is not set
CONFIG_SQUASHFS_LZO=y
# CONFIG_SQUASHFS_XZ is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
# CONFIG_OMFS_FS is not set
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=y
# CONFIG_QNX6FS_DEBUG is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
# CONFIG_ROMFS_BACKED_BY_MTD is not set
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_RAM=y
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=y
CONFIG_UFS_FS_WRITE=y
CONFIG_UFS_DEBUG=y
CONFIG_EXOFS_FS=y
# CONFIG_EXOFS_DEBUG is not set
CONFIG_F2FS_FS=y
# CONFIG_F2FS_STAT_FS is not set
# CONFIG_F2FS_FS_XATTR is not set
CONFIG_ORE=y
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NCP_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=y
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
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
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
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
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
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_KOBJECT_RELEASE=y
# CONFIG_DEBUG_BUGVERBOSE is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_PROVE_RCU_DELAY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_VERBOSE=y
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
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
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
CONFIG_DMA_API_DEBUG=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DOUBLEFAULT is not set
# CONFIG_DEBUG_TLBFLUSH is not set
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
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
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
CONFIG_CRYPTO_FIPS=y
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
# CONFIG_CRYPTO_AUTHENC is not set
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
CONFIG_CRYPTO_XCBC=y
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
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_586=y
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_ZLIB=y
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_LZ4=y
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
# CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_LGUEST is not set
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
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set

--MGYHOYXEY6WxJCY8--
