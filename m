Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966258Ab3E2ONl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 10:13:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:50485 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966033Ab3E2ONj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 10:13:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,764,1363158000"; 
   d="log'?scan'208";a="341979820"
Date: Wed, 29 May 2013 22:13:33 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [ring_buffer_entries] BUG: unable to handle kernel NULL pointer
 dereference at   (null)
Message-ID: <20130529141333.GA24064@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Rostedt,

I got the below BUG and the first bad commit could be any of:

ce9bae55972b228cf7bac34350c4d2caf8ea0d0b
121aaee7b0a82605d33af200c7e9ebab6fd6e444
737223fbca3b1c91feb947c7f571b35749b743b6
45ad21ca5530efdca6a19e4a5ac5e7bd6e24f996
a695cb5816228f86576f5f5c6809fdf8ed382ece
6de58e6269cd0568ca5fbae14423914eff0f7811
ad909e21bbe69f1d39055d346540abd827190eca
0b85ffc293044393623059eda9904a7d5b644e36
f5eb5588262cab7232ed1d77cf612b327db50767
f1affcaaa861f27752a769f889bf1486ebd301fe
f4e781c0a89d5810729772290441ac7d61f321ec
12883efb670c28dff57dcd7f4f995a1ffe153b2d
55034cd6e648155393b0d665eef76b38d49ad6bf
153e8ed913b022d2003866a848af9fadc041403f

We cannot bisect more due to broken builds.

[    3.240151] PASSED
[    3.242098] Testing tracer branch: 
[    3.350189] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    3.358885] IP: [<c112ccbb>] ring_buffer_entries+0x14/0x39
[    3.360000] *pde = 00000000 
[    3.360000] Oops: 0000 [#1] PREEMPT 
[    3.360000] Modules linked in:
[    3.360000] CPU: 0 PID: 1 Comm: swapper Not tainted 3.10.0-rc3-00105-g854f5c1 #2
[    3.360000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[    3.360000] task: cbc58000 ti: cbc5a000 task.ti: cbc5a000
[    3.360000] EIP: 0060:[<c112ccbb>] EFLAGS: 00010046 CPU: 0
[    3.360000] EIP is at ring_buffer_entries+0x14/0x39
[    3.360000] EAX: 00000000 EBX: 00000000 ECX: 00000044 EDX: c113f95c
[    3.360000] ESI: c2062a80 EDI: cbc5befc EBP: cbc5bec4 ESP: cbc5bec4
[    3.360000]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[    3.360000] CR0: 8005003b CR2: 00000000 CR3: 01fb1000 CR4: 000006d0
[    3.360000] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    3.360000] DR6: ffff0ff0 DR7: 00000400
[    3.360000] Stack:
[    3.360000]  cbc5bef0 c1135a9d c11383c1 00000246 00000246 c2062a80 00000246 c1eae260
[    3.360000]  00000000 c1eae260 c2062a80 cbc5bf0c c113f95c 00000006 00000000 c1eae260
[    3.360000]  c1eae1e8 00000000 cbc5bf24 c1140372 c1bc30da c1bc33d6 00000001 c1eddd7f
[    3.360000] Call Trace:
[    3.360000]  [<c1135a9d>] trace_test_buffer+0x5a/0x29e
[    3.360000]  [<c11383c1>] ? tracing_stop+0x36/0x1d2
[    3.360000]  [<c113f95c>] trace_selftest_startup_branch+0x93/0x115
[    3.360000]  [<c1140372>] register_tracer+0x277/0x47d
[    3.360000]  [<c1eddd7f>] ? init_annotated_branch_stats+0x61/0x61
[    3.360000]  [<c1eddde6>] init_branch_tracer+0x67/0x77
[    3.360000]  [<c10002b3>] do_one_initcall+0x19e/0x31f
[    3.360000]  [<c10b08c8>] ? spin_unlock_irqrestore.isra.55+0xd7/0x10d
[    3.360000]  [<c1eb38a2>] kernel_init_freeable+0x3de/0x561
[    3.360000]  [<c1eb2521>] ? loglevel+0x55/0x55
[    3.360000]  [<c1a345bc>] kernel_init+0x1e/0x206
[    3.360000]  [<c1a689f7>] ret_from_kernel_thread+0x1b/0x28
[    3.360000]  [<c1a3459e>] ? rest_init+0x10e/0x10e
[    3.360000] Code: 83 05 c8 1b 06 c2 01 83 15 cc 1b 06 c2 00 8b 40 48 eb 02 31 c0 5d c3 55 8b 40 24 83 05 d8 1b 06 c2 01 89 e5 83 15 dc 1b 06 c2 00 <8b> 00 e8 0d fe ff ff 83 05 d0 1b 06 c2 01 83 15 d4 1b 06 c2 00
[    3.360000] EIP: [<c112ccbb>] ring_buffer_entries+0x14/0x39 SS:ESP 0068:cbc5bec4
[    3.360000] CR2: 0000000000000000
[    3.360000] ---[ end trace 066877a51305f5c2 ]---

git bisect start 854f5c142a3bed29985e281000ab5ff9e5913065 v3.9 --
git bisect  bad 73287a43cc79ca06629a88d1a199cd283f42456a  #     0  2013-05-29 17:31:04  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
git bisect  bad 5d434fcb255dec99189f1c58a06e4f56e12bf77d  #     0  2013-05-29 17:37:48  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial
git bisect good 507ffe4f3840ac24890a8123c702cf1b7fe4d33c  #    10  2013-05-29 17:55:33  Merge tag 'tty-3.10-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
git bisect good 4a7b4d2360175f67ab2c58effeeb8362a3057c25  #    10  2013-05-29 18:07:41  x86: pageattr-test: remove srandom32 call
git bisect  bad 46d9be3e5eb01f71fc02653755d970247174b400  #     3  2013-05-29 18:17:09  Merge branch 'for-3.10' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq
git bisect  bad 8ded8d4e4facab78acf616bc34085ddd15c2c21c  #     0  2013-05-29 18:26:21  Merge tag 'regulator-v3.10' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator
git bisect good 75f01f949902db68b7937dfbae71b0b46a398161  #    10  2013-05-29 18:33:41  Merge remote-tracking branch 'regulator/topic/mc13892' into v3.9-rc8
git bisect  bad f1943977e6648c1d42a78eda4ba4429a2bc0b786  #     0  2013-05-29 18:38:29  tracing: Get rid of unneeded key calculation in ftrace_hash_move()
git bisect  bad 417944c4c7a0f657158d0515f3b8e8c043fd788f  #     0  2013-05-29 18:57:44  tracing: Add a way to soft disable trace events
git bisect good 575380da8b46969a2c6a7e14a51056a63b30fe2e  #    10  2013-05-29 19:28:44  tracing: Only clear trace buffer on module unload if event was traced
git bisect  bad 57d01ad09721fb7719c4c8c72b434398186f35a0  #     0  2013-05-29 19:45:21  tracing: Fix comments for ftrace_event_file/call flags
git bisect  bad 09ae72348eccb60e304cf8ce94653f4a78fcd407  #     0  2013-05-29 20:06:00  tracing: Add trace_puts() for even faster trace_printk() tracing
git bisect good 22cffc2bb4a50d8c56f03c56f9f19dea85b78e30  #    10  2013-05-29 21:36:32  tracing: Enable snapshot when any latency tracer is enabled
git bisect  bad 153e8ed913b022d2003866a848af9fadc041403f  #     0  2013-05-29 22:01:44  tracing: Fix the branch tracer that broke with buffer change

Thanks,
Fengguang

--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-roam-18960-2013-05-29-01-32-01-3.10.0-rc3-00105-g854f5c1-2"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.10.0-rc3-00105-g854f5c1 (kbuild@cairo) (gcc =
version 4.7.2 (Debian 4.7.2-4) ) #2 PREEMPT Wed May 29 01:31:10 CST 2013
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reser=
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
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
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
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
[    0.000000] Base memory trampoline at [c008f000] 8f000 size 16384
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
[    0.000000] BRK [0x023c8000, 0x023c8fff] PGTABLE
[    0.000000] cma: CMA: reserved 28 MiB at 0c800000
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128180(97%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC=
 00000001)
[    0.000000] ACPI: DSDT 0fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL=
 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: APIC 0ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC=
 00000001)
[    0.000000] ACPI: HPET 0ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC=
 00000001)
[    0.000000] ACPI: SSDT 0ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL=
 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] BRK [0x023c9000, 0x023c9fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65424
[    0.000000] free_area_init_node: node 0, pgdat c1e59948, node_mem_map ce=
53f020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3986 pages, LIFO batch:0
[    0.000000]   Normal zone: 480 pages used for memmap
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
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64912
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 branch=3Dlinux-devel/devel-cairo-i386-2013-05-29-01-28 log=
_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_printk=
 sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200=
 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-=
queue/kvm/i386-randconfig-c04-0529/854f5c142a3bed29985e281000ab5ff9e5913065=
/.vmlinuz-2013-05-29-01-31-53-devel-cairo-i386-2013-05-29-01-28:854f5c142a3=
bed29985e281000ab5ff9e5913065-854f5c142a3bed29985e281000ab5ff9e5913065-i386=
-randconfig-c04-0529-2-roam  BOOT_IMAGE=3D/kernel/i386-randconfig-c04-0529/=
854f5c142a3bed29985e281000ab5ff9e5913065/vmlinuz-3.10.0-rc3-00105-g854f5c1
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 176908k/262136k available (10662k kernel code, 84788=
k reserved, 4377k data, 1008k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa2000 - 0xfffff000   ( 372 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff7fe000   ( 752 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc1eb2000 - 0xc1fae000   (1008 kB)
[    0.000000]       .data : 0xc1a69b43 - 0xc1eb01e0   (4377 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1a69b43   (10662 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D1, =
Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3Dcbc08000 soft=3Dcbc0a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: Detected 2893.029 MHz processor
[    0.060008] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 5786.05 BogoMIPS (lpj=3D28930290)
[    0.072467] pid_max: default: 32768 minimum: 301
[    0.075919] Mount-cache hash table entries: 512
[    0.080645] Initializing cgroup subsys debug
[    0.083964] Initializing cgroup subsys blkio
[    0.086987] Initializing cgroup subsys perf_event
[    0.090035] Initializing cgroup subsys net_prio
[    0.093457] mce: CPU supports 10 MCE banks
[    0.096717] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.096717] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.096717] tlb_flushall_shift: 6
[    0.100024] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.114276] ACPI: Core revision 20130328
[    0.121943] ACPI: All ACPI Tables successfully acquired
[    0.126152] ftrace: allocating 23419 entries in 46 pages
[    0.150298] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.164906] Testing tracer nop: PASSED
[    0.168721] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.170057] Getting VERSION: 50014
[    0.173005] Getting VERSION: 50014
[    0.175935] Getting ID: 0
[    0.180043] Getting ID: f000000
[    0.182629] Getting LVT0: 8700
[    0.185240] Getting LVT1: 8400
[    0.187965] enabled ExtINT on CPU#0
[    0.191815] ENABLING IO-APIC IRQs
[    0.194775] init IO_APIC IRQs
[    0.200028]  apic 2 pin 0 not connected
[    0.202958] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.208779] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.210075] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.220073] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.226060] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.230077] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.236005] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.240073] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.250064] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.255926] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.260071] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.265802] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.270065] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.280063] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.286371] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.290061]  apic 2 pin 16 not connected
[    0.293461]  apic 2 pin 17 not connected
[    0.300021]  apic 2 pin 18 not connected
[    0.303201]  apic 2 pin 19 not connected
[    0.306591]  apic 2 pin 20 not connected
[    0.310022]  apic 2 pin 21 not connected
[    0.313222]  apic 2 pin 22 not connected
[    0.316459]  apic 2 pin 23 not connected
[    0.320209] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.425422] Using local APIC timer interrupts.
[    0.425422] calibrating APIC timer ...
[    0.440000] ... lapic delta =3D 6249762
[    0.440000] ... PM-Timer delta =3D 357930
[    0.440000] ... PM-Timer result ok
[    0.440000] ..... delta 6249762
[    0.440000] ..... mult: 268425233
[    0.440000] ..... calibration result: 9999619
[    0.440000] ..... CPU clock speed is 2892.8110 MHz.
[    0.440000] ..... host bus clock speed is 999.9619 MHz.
[    0.440929] devtmpfs: initialized
[    0.445382] Testing tracer function: PASSED
[    0.662900] Testing dynamic ftrace: PASSED
[    0.991659] Testing dynamic ftrace ops #1: (1 0 1 1 0) (1 1 2 1 0) (2 1 =
3 1 7) (2 2 4 1 221) PASSED
[    1.340059] Testing dynamic ftrace ops #2: (1 0 1 7 0) (1 1 2 202 0) (2 =
1 3 1 12) (2 2 4 225 236) PASSED
[    1.687366] Testing ftrace recursion: PASSED
[    1.715113] Testing ftrace recursion safe: PASSED
[    1.742460] Testing ftrace regs: PASSED
[    1.770029] Testing tracer irqsoff: PASSED
[    2.020026] Testing tracer preemptoff: PASSED
[    2.290025] Testing tracer preemptirqsoff: PASSED
[    2.556409] Testing tracer wakeup: ret =3D 0
[    2.900154] PASSED
[    2.902522] Testing tracer wakeup_rt: ret =3D 0
[    3.240151] PASSED
[    3.242098] Testing tracer branch:=20
[    3.350189] BUG: unable to handle kernel NULL pointer dereference at   (=
null)
[    3.358885] IP: [<c112ccbb>] ring_buffer_entries+0x14/0x39
[    3.360000] *pde =3D 00000000=20
[    3.360000] Oops: 0000 [#1] PREEMPT=20
[    3.360000] Modules linked in:
[    3.360000] CPU: 0 PID: 1 Comm: swapper Not tainted 3.10.0-rc3-00105-g85=
4f5c1 #2
[    3.360000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[    3.360000] task: cbc58000 ti: cbc5a000 task.ti: cbc5a000
[    3.360000] EIP: 0060:[<c112ccbb>] EFLAGS: 00010046 CPU: 0
[    3.360000] EIP is at ring_buffer_entries+0x14/0x39
[    3.360000] EAX: 00000000 EBX: 00000000 ECX: 00000044 EDX: c113f95c
[    3.360000] ESI: c2062a80 EDI: cbc5befc EBP: cbc5bec4 ESP: cbc5bec4
[    3.360000]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[    3.360000] CR0: 8005003b CR2: 00000000 CR3: 01fb1000 CR4: 000006d0
[    3.360000] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    3.360000] DR6: ffff0ff0 DR7: 00000400
[    3.360000] Stack:
[    3.360000]  cbc5bef0 c1135a9d c11383c1 00000246 00000246 c2062a80 00000=
246 c1eae260
[    3.360000]  00000000 c1eae260 c2062a80 cbc5bf0c c113f95c 00000006 00000=
000 c1eae260
[    3.360000]  c1eae1e8 00000000 cbc5bf24 c1140372 c1bc30da c1bc33d6 00000=
001 c1eddd7f
[    3.360000] Call Trace:
[    3.360000]  [<c1135a9d>] trace_test_buffer+0x5a/0x29e
[    3.360000]  [<c11383c1>] ? tracing_stop+0x36/0x1d2
[    3.360000]  [<c113f95c>] trace_selftest_startup_branch+0x93/0x115
[    3.360000]  [<c1140372>] register_tracer+0x277/0x47d
[    3.360000]  [<c1eddd7f>] ? init_annotated_branch_stats+0x61/0x61
[    3.360000]  [<c1eddde6>] init_branch_tracer+0x67/0x77
[    3.360000]  [<c10002b3>] do_one_initcall+0x19e/0x31f
[    3.360000]  [<c10b08c8>] ? spin_unlock_irqrestore.isra.55+0xd7/0x10d
[    3.360000]  [<c1eb38a2>] kernel_init_freeable+0x3de/0x561
[    3.360000]  [<c1eb2521>] ? loglevel+0x55/0x55
[    3.360000]  [<c1a345bc>] kernel_init+0x1e/0x206
[    3.360000]  [<c1a689f7>] ret_from_kernel_thread+0x1b/0x28
[    3.360000]  [<c1a3459e>] ? rest_init+0x10e/0x10e
[    3.360000] Code: 83 05 c8 1b 06 c2 01 83 15 cc 1b 06 c2 00 8b 40 48 eb =
02 31 c0 5d c3 55 8b 40 24 83 05 d8 1b 06 c2 01 89 e5 83 15 dc 1b 06 c2 00 =
<8b> 00 e8 0d fe ff ff 83 05 d0 1b 06 c2 01 83 15 d4 1b 06 c2 00
[    3.360000] EIP: [<c112ccbb>] ring_buffer_entries+0x14/0x39 SS:ESP 0068:=
cbc5bec4
[    3.360000] CR2: 0000000000000000
[    3.360000] ---[ end trace 066877a51305f5c2 ]---
[    3.370064] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x00000009
[    3.370064]=20
[    3.380000] Rebooting in 10 seconds..
--LQksG6bCIzRHxTLp
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="854f5c142a3bed29985e281000ab5ff9e5913065-bisect.log"
Content-Transfer-Encoding: base64

YmlzZWN0OiBza2lwIDU4ZjhiYmQyZTM5YzM3MzJjNTU2OTg0OTQzMzhlZTE5YTkyYzUzYTA6
IG5vdCBhIGdvb2QgbWVyZ2UgYmFzZQpnaXQgY2hlY2tvdXQgdjMuOQpQcmV2aW91cyBIRUFE
IHBvc2l0aW9uIHdhcyA4NTRmNWMxLi4uIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2gg
J3Y5ZnMvdjlmcy1kZXZlbCcgaW50byBkZXZlbC1jYWlyby1pMzg2LTIwMTMtMDUtMjktMDEt
MjgKSEVBRCBpcyBub3cgYXQgYzFiZTVhNS4uLiBMaW51eCAzLjkKCjIwMTMtMDUtMjktMTc6
MDU6MTYgYzFiZTVhNWIxYjM1NWQ0MGU2Y2Y3OWNjOTc5ZWI2NmRhZmEyNGFkMSBjb21waWxp
bmcKMTE2IHJlYWwgIDE5MTQgdXNlciAgMTQ4IHN5cyAgMTc3MS4xMCUgY3B1IAlpMzg2LXJh
bmRjb25maWctYzA0LTA1MjkKCjIwMTMtMDUtMjktMTc6MDc6NDEgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgMy45LjAtYmlzZWN0My1zb3VuZCAjMTggCTAuLgk1CTcJOS4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4JMTAgU1VDQ0VTUwpiaXNlY3Q6IGdvb2QgY29tbWl0IHYzLjkKZ2l0IGJp
c2VjdCBzdGFydCA4NTRmNWMxNDJhM2JlZDI5OTg1ZTI4MTAwMGFiNWZmOWU1OTEzMDY1IHYz
LjkgLS0KQmlzZWN0aW5nOiA2NTI5IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSAxMyBzdGVwcykKWzczMjg3YTQzY2M3OWNhMDY2MjlhODhkMWExOTljZDI4
M2Y0MjQ1NmFdIE1lcmdlIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2Vy
bmVsL2dpdC9kYXZlbS9uZXQtbmV4dApnaXQgYmlzZWN0IHJ1biAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIG9iai1iaXNlY3QKcnVubmluZyAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIG9iai1iaXNlY3QKCjIwMTMt
MDUtMjktMTc6MjM6NDkgNzMyODdhNDNjYzc5Y2EwNjYyOWE4OGQxYTE5OWNkMjgzZjQyNDU2
YSBjb21waWxpbmcKMzA5IHJlYWwgIDE4NDAgdXNlciAgMTUwIHN5cyAgNjQzLjY1JSBjcHUg
CWkzODYtcmFuZGNvbmZpZy1jMDQtMDUyOQoKMjAxMy0wNS0yOS0xNzozMDozNCBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAzLjkuMC1iaXNlY3QzLXNvdW5kLTA3MTY4LWc3MzI4N2E0ICMxOSAJ
MCBURVNUIEZBSUxVUkUKQmlzZWN0aW5nOiAzNjAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3Qg
YWZ0ZXIgdGhpcyAocm91Z2hseSAxMiBzdGVwcykKWzVkNDM0ZmNiMjU1ZGVjOTkxODlmMWM1
OGEwNmU0ZjU2ZTEyYmY3N2RdIE1lcmdlIGJyYW5jaCAnZm9yLWxpbnVzJyBvZiBnaXQ6Ly9n
aXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvamlrb3MvdHJpdmlhbApy
dW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggb2Jq
LWJpc2VjdAoKMjAxMy0wNS0yOS0xNzozMToxMSA1ZDQzNGZjYjI1NWRlYzk5MTg5ZjFjNThh
MDZlNGY1NmUxMmJmNzdkIGNvbXBpbGluZwoyMjggcmVhbCAgMTgxNCB1c2VyICAxNTEgc3lz
ICA4NjAuMTIlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWMwNC0wNTI5CgoyMDEzLTA1LTI5LTE3
OjM3OjE4IGRldGVjdGluZyBib290IHN0YXRlIDMuOS4wLWJpc2VjdDMtc291bmQtMDM1Njct
ZzVkNDM0ZmMgIzIwIAkwIFRFU1QgRkFJTFVSRQpCaXNlY3Rpbmc6IDE5ODkgcmV2aXNpb25z
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDExIHN0ZXBzKQpbNTA3ZmZlNGYz
ODQwYWMyNDg5MGE4MTIzYzcwMmNmMWI3ZmU0ZDMzY10gTWVyZ2UgdGFnICd0dHktMy4xMC1y
YzEnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9n
cmVna2gvdHR5CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCBvYmotYmlzZWN0CgoyMDEzLTA1LTI5LTE3OjM3OjUyIDUwN2ZmZTRmMzg0MGFj
MjQ4OTBhODEyM2M3MDJjZjFiN2ZlNGQzM2MgY29tcGlsaW5nCjg4NSByZWFsICAxOTM5IHVz
ZXIgIDE1NyBzeXMgIDIzNi44NiUgY3B1IAlpMzg2LXJhbmRjb25maWctYzA0LTA1MjkKCjIw
MTMtMDUtMjktMTc6NTM6MDMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy45LjAtYmlzZWN0My1z
b3VuZC0wMTU3Ny1nNTA3ZmZlNCAjMjEgCTAuLgk4CTEwIFNVQ0NFU1MKQmlzZWN0aW5nOiA5
OTQgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEwIHN0ZXBz
KQpbNGE3YjRkMjM2MDE3NWY2N2FiMmM1OGVmZmVlYjgzNjJhMzA1N2MyNV0geDg2OiBwYWdl
YXR0ci10ZXN0OiByZW1vdmUgc3JhbmRvbTMyIGNhbGwKcnVubmluZyAvYy9rZXJuZWwtdGVz
dHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIG9iai1iaXNlY3QKCjIwMTMtMDUtMjkt
MTc6NTU6MzUgNGE3YjRkMjM2MDE3NWY2N2FiMmM1OGVmZmVlYjgzNjJhMzA1N2MyNSBjb21w
aWxpbmcKNTQ5IHJlYWwgIDE5MTAgdXNlciAgMTU1IHN5cyAgMzc1Ljc5JSBjcHUgCWkzODYt
cmFuZGNvbmZpZy1jMDQtMDUyOQoKMjAxMy0wNS0yOS0xODowNToxMCBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAzLjkuMC1iaXNlY3QzLXNvdW5kLTAyNTcyLWc0YTdiNGQyICMyMiAJMC4uCTIJ
MTAgU1VDQ0VTUwpCaXNlY3Rpbmc6IDQ4NiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgOSBzdGVwcykKWzQ2ZDliZTNlNWViMDFmNzFmYzAyNjUzNzU1ZDk3
MDI0NzE3NGI0MDBdIE1lcmdlIGJyYW5jaCAnZm9yLTMuMTAnIG9mIGdpdDovL2dpdC5rZXJu
ZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90ai93cQpydW5uaW5nIC9jL2tlcm5l
bC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggb2JqLWJpc2VjdAoKMjAxMy0w
NS0yOS0xODowNzo0NSA0NmQ5YmUzZTVlYjAxZjcxZmMwMjY1Mzc1NWQ5NzAyNDcxNzRiNDAw
IGNvbXBpbGluZwo0ODcgcmVhbCAgMTkwMCB1c2VyICAxNTkgc3lzICA0MjIuNzIlIGNwdSAJ
aTM4Ni1yYW5kY29uZmlnLWMwNC0wNTI5CgoyMDEzLTA1LTI5LTE4OjE2OjM5IGRldGVjdGlu
ZyBib290IHN0YXRlIDMuOS4wLWJpc2VjdDMtc291bmQtMDI4MTEtZzQ2ZDliZTMgIzIzIAkz
IFRFU1QgRkFJTFVSRQpCaXNlY3Rpbmc6IDIwOSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgOCBzdGVwcykKWzhkZWQ4ZDRlNGZhY2FiNzhhY2Y2MTZiYzM0
MDg1ZGRkMTVjMmMyMWNdIE1lcmdlIHRhZyAncmVndWxhdG9yLXYzLjEwJyBvZiBnaXQ6Ly9n
aXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvYnJvb25pZS9yZWd1bGF0
b3IKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IG9iai1iaXNlY3QKCjIwMTMtMDUtMjktMTg6MTc6MTEgOGRlZDhkNGU0ZmFjYWI3OGFjZjYx
NmJjMzQwODVkZGQxNWMyYzIxYyBjb21waWxpbmcKNDk5IHJlYWwgIDE4OTYgdXNlciAgMTU1
IHN5cyAgNDEwLjkwJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1jMDQtMDUyOQoKMjAxMy0wNS0y
OS0xODoyNTo1MSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjkuMC1iaXNlY3QzLXNvdW5kLTAy
NDUyLWc4ZGVkOGQ0ICMyNCAJMCBURVNUIEZBSUxVUkUKQmlzZWN0aW5nOiAxNTMgcmV2aXNp
b25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDcgc3RlcHMpCls3NWYwMWY5
NDk5MDJkYjY4Yjc5MzdkZmJhZTcxYjBiNDZhMzk4MTYxXSBNZXJnZSByZW1vdGUtdHJhY2tp
bmcgYnJhbmNoICdyZWd1bGF0b3IvdG9waWMvbWMxMzg5MicgaW50byB2My45LXJjOApydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggb2JqLWJp
c2VjdAoKMjAxMy0wNS0yOS0xODoyNjoyNCA3NWYwMWY5NDk5MDJkYjY4Yjc5MzdkZmJhZTcx
YjBiNDZhMzk4MTYxIGNvbXBpbGluZwoyNDEgcmVhbCAgMTkxMiB1c2VyICAxNTQgc3lzICA4
NTQuODclIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWMwNC0wNTI5CgoyMDEzLTA1LTI5LTE4OjMx
OjA3IGRldGVjdGluZyBib290IHN0YXRlIDMuOS4wLXJjOC1iaXNlY3QzLXNvdW5kLTAwMTQ0
LWc3NWYwMWY5ICMyNSAJMC4uCTkJMTAgU1VDQ0VTUwpCaXNlY3Rpbmc6IDc2IHJldmlzaW9u
cyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA2IHN0ZXBzKQpbZjE5NDM5Nzdl
NjY0OGMxZDQyYTc4ZWRhNGJhNDQyOWEyYmMwYjc4Nl0gdHJhY2luZzogR2V0IHJpZCBvZiB1
bm5lZWRlZCBrZXkgY2FsY3VsYXRpb24gaW4gZnRyYWNlX2hhc2hfbW92ZSgpCnJ1bm5pbmcg
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCBvYmotYmlzZWN0
CgoyMDEzLTA1LTI5LTE4OjMzOjQ1IGYxOTQzOTc3ZTY2NDhjMWQ0MmE3OGVkYTRiYTQ0Mjlh
MmJjMGI3ODYgY29tcGlsaW5nCjIxOSByZWFsICAxNjcwIHVzZXIgIDE0MSBzeXMgIDgyNS41
NiUgY3B1IAlpMzg2LXJhbmRjb25maWctYzA0LTA1MjkKCjIwMTMtMDUtMjktMTg6Mzc6NTkg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy44LjAtYmlzZWN0My1zb3VuZC0wMDYxNC1nZjE5NDM5
NyAjMjYgCTAgVEVTVCBGQUlMVVJFCkJpc2VjdGluZzogMzggcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDUgc3RlcHMpCltmNGU3ODFjMGE4OWQ1ODEwNzI5
NzcyMjkwNDQxYWM3ZDYxZjMyMWVjXSB0cmFjaW5nOiBNb3ZlIHRoZSB0cmFjaW5nIHNlbGZ0
ZXN0IGNvZGUgaW50byBpdHMgb3duIGZ1bmN0aW9uCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCBvYmotYmlzZWN0CgoyMDEzLTA1LTI5LTE4
OjM4OjMzIGY0ZTc4MWMwYTg5ZDU4MTA3Mjk3NzIyOTA0NDFhYzdkNjFmMzIxZWMgY29tcGls
aW5nCjM2NCByZWFsICAxNTk2IHVzZXIgIDEyOSBzeXMgIDQ3My4wOCUgY3B1IAlpMzg2LXJh
bmRjb25maWctYzA0LTA1MjkKMjAxMy0wNS0yOS0xODo0NjoxOCBmNGU3ODFjMGE4OWQ1ODEw
NzI5NzcyMjkwNDQxYWM3ZDYxZjMyMWVjIFNLSVAgQlJPS0VOIEJVSUxECkxBTkc9QyBNQUtF
PS91c3IvYmluL21ha2UgLS1rZWVwLWdvaW5nIC91c3IvYmluL21ha2UgLUMgc291cmNlIE89
L2NjL3dmZy9zb3VuZC1iaXNlY3QgLWo2NCAtbDE2MyBBUkNIPWkzODYgZGlzdGNsZWFuCm1h
a2U6IEVudGVyaW5nIGRpcmVjdG9yeSBgL2Mvd2ZnL3NvdW5kJwogIENMRUFOICAgLgogIENM
RUFOICAgYXJjaC94ODYvcmVhbG1vZGUvcm0KICBDTEVBTiAgIGFyY2gveDg2L3Zkc28KICBD
TEVBTiAgIGFyY2gveDg2L2tlcm5lbC9jcHUKICBDTEVBTiAgIGFyY2gveDg2L2tlcm5lbAog
IENMRUFOICAgYXJjaC94ODYvbGliCiAgQ0xFQU4gICBjcnlwdG8vYXN5bW1ldHJpY19rZXlz
CiAgQ0xFQU4gICBkcml2ZXJzL2Vpc2EKICBDTEVBTiAgIGRyaXZlcnMvZ3B1L2RybS9yYWRl
b24KICBDTEVBTiAgIGRyaXZlcnMvbmV0L3dhbgogIENMRUFOICAgZmlybXdhcmUKICBDTEVB
TiAgIGRyaXZlcnMvc2NzaS9haWM3eHh4CiAgQ0xFQU4gICBkcml2ZXJzL3R0eS92dAogIENM
RUFOICAgZHJpdmVycy92aWRlby9sb2dvCiAgQ0xFQU4gICBkcml2ZXJzL3Njc2kKICBDTEVB
TiAgIGxpYi9yYWlkNgogIENMRUFOICAgbGliCiAgQ0xFQU4gICBzZWN1cml0eS9hcHBhcm1v
cgogIENMRUFOICAgc2VjdXJpdHkvc2VsaW51eAogIENMRUFOICAgdXNyCiAgQ0xFQU4gICBz
Y3JpcHRzL2Jhc2ljCiAgQ0xFQU4gICBzY3JpcHRzL2dlbmtzeW1zCiAgQ0xFQU4gICBzY3Jp
cHRzL21vZAogIENMRUFOICAgc2NyaXB0cy9rY29uZmlnCiAgQ0xFQU4gICBzY3JpcHRzL3Nl
bGludXgvZ2VuaGVhZGVycwogIENMRUFOICAgc2NyaXB0cy9zZWxpbnV4L21kcAogIENMRUFO
ICAgc2NyaXB0cwogIENMRUFOICAga2VybmVsCiAgQ0xFQU4gICBhcmNoL3g4Ni9ib290L2Nv
bXByZXNzZWQKICBDTEVBTiAgIGFyY2gveDg2L2Jvb3QKICBDTEVBTiAgIGFyY2gveDg2L3Rv
b2xzCiAgQ0xFQU4gICAudG1wX3ZlcnNpb25zCiAgQ0xFQU4gICBpbmNsdWRlL2NvbmZpZyBp
bmNsdWRlL2dlbmVyYXRlZCBhcmNoL3g4Ni9pbmNsdWRlL2dlbmVyYXRlZAogIENMRUFOICAg
LmNvbmZpZyAuY29uZmlnLm9sZCAudmVyc2lvbiBpbmNsdWRlL2dlbmVyYXRlZC91YXBpL2xp
bnV4L3ZlcnNpb24uaCBNb2R1bGUuc3ltdmVycyBzaWduaW5nX2tleS5wcml2IHNpZ25pbmdf
a2V5Lng1MDkgeDUwOS5nZW5rZXkgZXh0cmFfY2VydGlmaWNhdGVzCm1ha2U6IExlYXZpbmcg
ZGlyZWN0b3J5IGAvYy93Zmcvc291bmQnCkJpc2VjdGluZzogMzcgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDUgc3RlcHMpCls1NTAzNGNkNmU2NDgxNTUz
OTNiMGQ2NjVlZWY3NmIzOGQ0OWFkNmJmXSB0cmFjaW5nOiBBZGQgYWxsb2Nfc25hcHNob3Qg
a2VybmVsIGNvbW1hbmQgbGluZSBwYXJhbWV0ZXIKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIG9iai1iaXNlY3QKCjIwMTMtMDUtMjktMTg6
NDY6NDEgNTUwMzRjZDZlNjQ4MTU1MzkzYjBkNjY1ZWVmNzZiMzhkNDlhZDZiZiBjb21waWxp
bmcKMjQyIHJlYWwgIDE2MDIgdXNlciAgMTMwIHN5cyAgNzEzLjg1JSBjcHUgCWkzODYtcmFu
ZGNvbmZpZy1jMDQtMDUyOQoyMDEzLTA1LTI5LTE4OjU0OjE4IDU1MDM0Y2Q2ZTY0ODE1NTM5
M2IwZDY2NWVlZjc2YjM4ZDQ5YWQ2YmYgU0tJUCBCUk9LRU4gQlVJTEQKTEFORz1DIE1BS0U9
L3Vzci9iaW4vbWFrZSAtLWtlZXAtZ29pbmcgL3Vzci9iaW4vbWFrZSAtQyBzb3VyY2UgTz0v
Y2Mvd2ZnL3NvdW5kLWJpc2VjdCAtajY0IC1sMjYxIEFSQ0g9aTM4NiBkaXN0Y2xlYW4KbWFr
ZTogRW50ZXJpbmcgZGlyZWN0b3J5IGAvYy93Zmcvc291bmQnCiAgQ0xFQU4gICAuCiAgQ0xF
QU4gICBhcmNoL3g4Ni9yZWFsbW9kZS9ybQogIENMRUFOICAgYXJjaC94ODYvdmRzbwogIENM
RUFOICAgYXJjaC94ODYva2VybmVsL2NwdQogIENMRUFOICAgYXJjaC94ODYva2VybmVsCiAg
Q0xFQU4gICBhcmNoL3g4Ni9saWIKICBDTEVBTiAgIGNyeXB0by9hc3ltbWV0cmljX2tleXMK
ICBDTEVBTiAgIGRyaXZlcnMvZWlzYQogIENMRUFOICAgZHJpdmVycy90dHkvdnQKICBDTEVB
TiAgIGRyaXZlcnMvc2NzaQogIENMRUFOICAga2VybmVsCiAgQ0xFQU4gICBsaWIKICBDTEVB
TiAgIHVzcgogIENMRUFOICAgYXJjaC94ODYvdG9vbHMKICBDTEVBTiAgIHNjcmlwdHMvZ2Vu
a3N5bXMKICBDTEVBTiAgIHNjcmlwdHMvYmFzaWMKICBDTEVBTiAgIHNjcmlwdHMva2NvbmZp
ZwogIENMRUFOICAgc2NyaXB0cy9tb2QKICBDTEVBTiAgIHNjcmlwdHMKICBDTEVBTiAgIC50
bXBfdmVyc2lvbnMKICBDTEVBTiAgIGluY2x1ZGUvY29uZmlnIGluY2x1ZGUvZ2VuZXJhdGVk
IGFyY2gveDg2L2luY2x1ZGUvZ2VuZXJhdGVkCiAgQ0xFQU4gICAuY29uZmlnIC5jb25maWcu
b2xkIC52ZXJzaW9uIGluY2x1ZGUvZ2VuZXJhdGVkL3VhcGkvbGludXgvdmVyc2lvbi5oIHNp
Z25pbmdfa2V5LnByaXYgc2lnbmluZ19rZXkueDUwOSB4NTA5LmdlbmtleSBleHRyYV9jZXJ0
aWZpY2F0ZXMKbWFrZTogTGVhdmluZyBkaXJlY3RvcnkgYC9jL3dmZy9zb3VuZCcKQmlzZWN0
aW5nOiAzNyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNSBz
dGVwcykKWzQxNzk0NGM0YzdhMGY2NTcxNThkMDUxNWYzYjhlOGMwNDNmZDc4OGZdIHRyYWNp
bmc6IEFkZCBhIHdheSB0byBzb2Z0IGRpc2FibGUgdHJhY2UgZXZlbnRzCnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCBvYmotYmlzZWN0Cgoy
MDEzLTA1LTI5LTE4OjU0OjI3IDQxNzk0NGM0YzdhMGY2NTcxNThkMDUxNWYzYjhlOGMwNDNm
ZDc4OGYgY29tcGlsaW5nCjExNCByZWFsICAxNjYyIHVzZXIgIDEzMiBzeXMgIDE1NzEuMzgl
IGNwdSAJaTM4Ni1yYW5kY29uZmlnLWMwNC0wNTI5CgoyMDEzLTA1LTI5LTE4OjU3OjE0IGRl
dGVjdGluZyBib290IHN0YXRlIDMuOC4wLWJpc2VjdDMtc291bmQtMDA1OTEtZzQxNzk0NGMg
IzEgCTAgVEVTVCBGQUlMVVJFCkJpc2VjdGluZzogMjYgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDUgc3RlcHMpClsxMjg4M2VmYjY3MGMyOGRmZjU3ZGNk
N2Y0Zjk5NWExZmZlMTUzYjJkXSB0cmFjaW5nOiBDb25zb2xpZGF0ZSBtYXhfdHIgaW50byBt
YWluIHRyYWNlX2FycmF5IHN0cnVjdHVyZQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggb2JqLWJpc2VjdAoKMjAxMy0wNS0yOS0xODo1Nzo0
NiAxMjg4M2VmYjY3MGMyOGRmZjU3ZGNkN2Y0Zjk5NWExZmZlMTUzYjJkIGNvbXBpbGluZwoy
MjAgcmVhbCAgMTYxMSB1c2VyICAxMzAgc3lzICA3OTAuODQlIGNwdSAJaTM4Ni1yYW5kY29u
ZmlnLWMwNC0wNTI5CjIwMTMtMDUtMjktMTk6MDM6MjIgMTI4ODNlZmI2NzBjMjhkZmY1N2Rj
ZDdmNGY5OTVhMWZmZTE1M2IyZCBTS0lQIEJST0tFTiBCVUlMRApMQU5HPUMgTUFLRT0vdXNy
L2Jpbi9tYWtlIC0ta2VlcC1nb2luZyAvdXNyL2Jpbi9tYWtlIC1DIHNvdXJjZSBPPS9jYy93
Zmcvc291bmQtYmlzZWN0IC1qNjQgLWwxMzQgQVJDSD1pMzg2IGRpc3RjbGVhbgptYWtlOiBF
bnRlcmluZyBkaXJlY3RvcnkgYC9jL3dmZy9zb3VuZCcKICBDTEVBTiAgIC4KICBDTEVBTiAg
IGFyY2gveDg2L3Zkc28KICBDTEVBTiAgIGFyY2gveDg2L3JlYWxtb2RlL3JtCiAgQ0xFQU4g
ICBhcmNoL3g4Ni9rZXJuZWwvY3B1CiAgQ0xFQU4gICBhcmNoL3g4Ni9rZXJuZWwKICBDTEVB
TiAgIGFyY2gveDg2L2xpYgogIENMRUFOICAgY3J5cHRvL2FzeW1tZXRyaWNfa2V5cwogIENM
RUFOICAgZHJpdmVycy9laXNhCiAgQ0xFQU4gICBmaXJtd2FyZQogIENMRUFOICAgZHJpdmVy
cy90dHkvdnQKICBDTEVBTiAgIGRyaXZlcnMvc2NzaQogIENMRUFOICAga2VybmVsCiAgQ0xF
QU4gICBsaWIKICBDTEVBTiAgIHVzcgogIENMRUFOICAgYXJjaC94ODYvYm9vdC9jb21wcmVz
c2VkCiAgQ0xFQU4gICBhcmNoL3g4Ni9ib290CiAgQ0xFQU4gICBhcmNoL3g4Ni90b29scwog
IENMRUFOICAgc2NyaXB0cy9iYXNpYwogIENMRUFOICAgc2NyaXB0cy9tb2QKICBDTEVBTiAg
IHNjcmlwdHMvZ2Vua3N5bXMKICBDTEVBTiAgIHNjcmlwdHMva2NvbmZpZwogIENMRUFOICAg
c2NyaXB0cwogIENMRUFOICAgLnRtcF92ZXJzaW9ucwogIENMRUFOICAgaW5jbHVkZS9jb25m
aWcgaW5jbHVkZS9nZW5lcmF0ZWQgYXJjaC94ODYvaW5jbHVkZS9nZW5lcmF0ZWQKICBDTEVB
TiAgIC5jb25maWcgLmNvbmZpZy5vbGQgLnZlcnNpb24gaW5jbHVkZS9nZW5lcmF0ZWQvdWFw
aS9saW51eC92ZXJzaW9uLmggTW9kdWxlLnN5bXZlcnMgc2lnbmluZ19rZXkucHJpdiBzaWdu
aW5nX2tleS54NTA5IHg1MDkuZ2Vua2V5IGV4dHJhX2NlcnRpZmljYXRlcwptYWtlOiBMZWF2
aW5nIGRpcmVjdG9yeSBgL2Mvd2ZnL3NvdW5kJwpCaXNlY3Rpbmc6IDI2IHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA1IHN0ZXBzKQpbNTc1MzgwZGE4YjQ2
OTY5YTJjNmE3ZTE0YTUxMDU2YTYzYjMwZmUyZV0gdHJhY2luZzogT25seSBjbGVhciB0cmFj
ZSBidWZmZXIgb24gbW9kdWxlIHVubG9hZCBpZiBldmVudCB3YXMgdHJhY2VkCnJ1bm5pbmcg
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCBvYmotYmlzZWN0
CgoyMDEzLTA1LTI5LTE5OjAzOjI3IDU3NTM4MGRhOGI0Njk2OWEyYzZhN2UxNGE1MTA1NmE2
M2IzMGZlMmUgY29tcGlsaW5nCjE5NSByZWFsICAxNjgzIHVzZXIgIDEzNiBzeXMgIDkzMi40
OSUgY3B1IAlpMzg2LXJhbmRjb25maWctYzA0LTA1MjkKCjIwMTMtMDUtMjktMTk6MDc6MTMg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy44LjAtYmlzZWN0My1zb3VuZC0wMDU2MS1nNTc1Mzgw
ZCAjMSAJMC4uCTcJOS4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMTAg
U1VDQ0VTUwpCaXNlY3Rpbmc6IDE0IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSA0IHN0ZXBzKQpbNTdkMDFhZDA5NzIxZmI3NzE5YzRjOGM3MmI0MzQzOTgx
ODZmMzVhMF0gdHJhY2luZzogRml4IGNvbW1lbnRzIGZvciBmdHJhY2VfZXZlbnRfZmlsZS9j
YWxsIGZsYWdzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCBvYmotYmlzZWN0CgoyMDEzLTA1LTI5LTE5OjI4OjQ3IDU3ZDAxYWQwOTcyMWZi
NzcxOWM0YzhjNzJiNDM0Mzk4MTg2ZjM1YTAgY29tcGlsaW5nCjg3NSByZWFsICAxNjU4IHVz
ZXIgIDE0MSBzeXMgIDIwNS40OSUgY3B1IAlpMzg2LXJhbmRjb25maWctYzA0LTA1MjkKCjIw
MTMtMDUtMjktMTk6NDQ6NTEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy44LjAtYmlzZWN0My1z
b3VuZC0wMDU4OC1nNTdkMDFhZCAjMiAJMCBURVNUIEZBSUxVUkUKQmlzZWN0aW5nOiAxMiBy
ZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNCBzdGVwcykKWzA5
YWU3MjM0OGVjY2I2MGUzMDRjZjhjZTk0NjUzZjRhNzhmY2Q0MDddIHRyYWNpbmc6IEFkZCB0
cmFjZV9wdXRzKCkgZm9yIGV2ZW4gZmFzdGVyIHRyYWNlX3ByaW50aygpIHRyYWNpbmcKcnVu
bmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIG9iai1i
aXNlY3QKCjIwMTMtMDUtMjktMTk6NDU6MjUgMDlhZTcyMzQ4ZWNjYjYwZTMwNGNmOGNlOTQ2
NTNmNGE3OGZjZDQwNyBjb21waWxpbmcKOTc3IHJlYWwgIDE2ODAgdXNlciAgMTQ2IHN5cyAg
MTg2LjkzJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1jMDQtMDUyOQoKMjAxMy0wNS0yOS0yMDow
NTozMCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjguMC1iaXNlY3QzLXNvdW5kLTAwNTc4LWcw
OWFlNzIzICMzIAkwIFRFU1QgRkFJTFVSRQpCaXNlY3Rpbmc6IDggcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3RlcHMpCls3MzcyMjNmYmNhM2IxYzkx
ZmViOTQ3YzdmNTcxYjM1NzQ5Yjc0M2I2XSB0cmFjaW5nOiBDb25zb2xpZGF0ZSBidWZmZXIg
YWxsb2NhdGlvbiBjb2RlCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJv
b3QtZmFpbHVyZS5zaCBvYmotYmlzZWN0CgoyMDEzLTA1LTI5LTIwOjA2OjA0IDczNzIyM2Zi
Y2EzYjFjOTFmZWI5NDdjN2Y1NzFiMzU3NDliNzQzYjYgY29tcGlsaW5nCjE0MTIgcmVhbCAg
MTYxMSB1c2VyICAxMjkgc3lzICAxMjMuMjklIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWMwNC0w
NTI5CjIwMTMtMDUtMjktMjA6MzE6MzQgNzM3MjIzZmJjYTNiMWM5MWZlYjk0N2M3ZjU3MWIz
NTc0OWI3NDNiNiBTS0lQIEJST0tFTiBCVUlMRApMQU5HPUMgTUFLRT0vdXNyL2Jpbi9tYWtl
IC0ta2VlcC1nb2luZyAvdXNyL2Jpbi9tYWtlIC1DIHNvdXJjZSBPPS9jYy93Zmcvc291bmQt
YmlzZWN0IC1qNjQgLWwxMzkgQVJDSD1pMzg2IGRpc3RjbGVhbgptYWtlOiBFbnRlcmluZyBk
aXJlY3RvcnkgYC9jL3dmZy9zb3VuZCcKICBDTEVBTiAgIC4KICBDTEVBTiAgIHNjcmlwdHMv
YmFzaWMKICBDTEVBTiAgIHNjcmlwdHMvbW9kCiAgQ0xFQU4gICBzY3JpcHRzL2tjb25maWcK
ICBDTEVBTiAgIHNjcmlwdHMvZ2Vua3N5bXMKICBDTEVBTiAgIHNjcmlwdHMKICBDTEVBTiAg
IGFyY2gveDg2L2Jvb3QvY29tcHJlc3NlZAogIENMRUFOICAgYXJjaC94ODYvYm9vdAogIENM
RUFOICAgYXJjaC94ODYvdG9vbHMKICBDTEVBTiAgIHVzcgogIENMRUFOICAgbGliCiAgQ0xF
QU4gICBrZXJuZWwKICBDTEVBTiAgIGZpcm13YXJlCiAgQ0xFQU4gICBkcml2ZXJzL3Njc2kK
ICBDTEVBTiAgIGRyaXZlcnMvdHR5L3Z0CiAgQ0xFQU4gICBkcml2ZXJzL2Vpc2EKICBDTEVB
TiAgIGNyeXB0by9hc3ltbWV0cmljX2tleXMKICBDTEVBTiAgIGFyY2gveDg2L2xpYgogIENM
RUFOICAgYXJjaC94ODYvcmVhbG1vZGUvcm0KICBDTEVBTiAgIGFyY2gveDg2L2tlcm5lbC9j
cHUKICBDTEVBTiAgIGFyY2gveDg2L2tlcm5lbAogIENMRUFOICAgYXJjaC94ODYvdmRzbwog
IENMRUFOICAgLnRtcF92ZXJzaW9ucwogIENMRUFOICAgaW5jbHVkZS9jb25maWcgaW5jbHVk
ZS9nZW5lcmF0ZWQgYXJjaC94ODYvaW5jbHVkZS9nZW5lcmF0ZWQKICBDTEVBTiAgIC5jb25m
aWcgLmNvbmZpZy5vbGQgLnZlcnNpb24gaW5jbHVkZS9nZW5lcmF0ZWQvdWFwaS9saW51eC92
ZXJzaW9uLmggTW9kdWxlLnN5bXZlcnMgc2lnbmluZ19rZXkucHJpdiBzaWduaW5nX2tleS54
NTA5IHg1MDkuZ2Vua2V5IGV4dHJhX2NlcnRpZmljYXRlcwptYWtlOiBMZWF2aW5nIGRpcmVj
dG9yeSBgL2Mvd2ZnL3NvdW5kJwpCaXNlY3Rpbmc6IDggcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3RlcHMpClthZDkwOWUyMWJiZTY5ZjFkMzkwNTVk
MzQ2NTQwYWJkODI3MTkwZWNhXSB0cmFjaW5nOiBBZGQgaW50ZXJuYWwgdHJhY2luZ19zbmFw
c2hvdCgpIGZ1bmN0aW9ucwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggb2JqLWJpc2VjdAoKMjAxMy0wNS0yOS0yMDozMTo1NiBhZDkwOWUy
MWJiZTY5ZjFkMzkwNTVkMzQ2NTQwYWJkODI3MTkwZWNhIGNvbXBpbGluZwoxOTEgcmVhbCAg
MTU5NyB1c2VyICAxMjMgc3lzICA5MDEuMDklIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWMwNC0w
NTI5CjIwMTMtMDUtMjktMjA6Mzg6NDIgYWQ5MDllMjFiYmU2OWYxZDM5MDU1ZDM0NjU0MGFi
ZDgyNzE5MGVjYSBTS0lQIEJST0tFTiBCVUlMRApMQU5HPUMgTUFLRT0vdXNyL2Jpbi9tYWtl
IC0ta2VlcC1nb2luZyAvdXNyL2Jpbi9tYWtlIC1DIHNvdXJjZSBPPS9jYy93Zmcvc291bmQt
YmlzZWN0IC1qNjQgLWwyNjMgQVJDSD1pMzg2IGRpc3RjbGVhbgptYWtlOiBFbnRlcmluZyBk
aXJlY3RvcnkgYC9jL3dmZy9zb3VuZCcKICBDTEVBTiAgIC4KICBDTEVBTiAgIGFyY2gveDg2
L3Zkc28KICBDTEVBTiAgIGFyY2gveDg2L3JlYWxtb2RlL3JtCiAgQ0xFQU4gICBhcmNoL3g4
Ni9rZXJuZWwvY3B1CiAgQ0xFQU4gICBhcmNoL3g4Ni9rZXJuZWwKICBDTEVBTiAgIGFyY2gv
eDg2L2xpYgogIENMRUFOICAgY3J5cHRvL2FzeW1tZXRyaWNfa2V5cwogIENMRUFOICAgZHJp
dmVycy9laXNhCiAgQ0xFQU4gICBkcml2ZXJzL3R0eS92dAogIENMRUFOICAgZHJpdmVycy9z
Y3NpCiAgQ0xFQU4gICBrZXJuZWwKICBDTEVBTiAgIGxpYgogIENMRUFOICAgdXNyCiAgQ0xF
QU4gICBhcmNoL3g4Ni90b29scwogIENMRUFOICAgc2NyaXB0cy9iYXNpYwogIENMRUFOICAg
c2NyaXB0cy9rY29uZmlnCiAgQ0xFQU4gICBzY3JpcHRzL2dlbmtzeW1zCiAgQ0xFQU4gICBz
Y3JpcHRzL21vZAogIENMRUFOICAgc2NyaXB0cwogIENMRUFOICAgLnRtcF92ZXJzaW9ucwog
IENMRUFOICAgaW5jbHVkZS9jb25maWcgaW5jbHVkZS9nZW5lcmF0ZWQgYXJjaC94ODYvaW5j
bHVkZS9nZW5lcmF0ZWQKICBDTEVBTiAgIC5jb25maWcgLmNvbmZpZy5vbGQgLnZlcnNpb24g
aW5jbHVkZS9nZW5lcmF0ZWQvdWFwaS9saW51eC92ZXJzaW9uLmggc2lnbmluZ19rZXkucHJp
diBzaWduaW5nX2tleS54NTA5IHg1MDkuZ2Vua2V5IGV4dHJhX2NlcnRpZmljYXRlcwptYWtl
OiBMZWF2aW5nIGRpcmVjdG9yeSBgL2Mvd2ZnL3NvdW5kJwpCaXNlY3Rpbmc6IDggcmV2aXNp
b25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3RlcHMpCltjZTliYWU1
NTk3MmIyMjhjZjdiYWMzNDM1MGM0ZDJjYWY4ZWEwZDBiXSB0cmFjaW5nOiBBZGQgc25hcHNo
b3QgZmVhdHVyZSB0byBpbnN0YW5jZXMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIG9iai1iaXNlY3QKCjIwMTMtMDUtMjktMjA6Mzk6NTIg
Y2U5YmFlNTU5NzJiMjI4Y2Y3YmFjMzQzNTBjNGQyY2FmOGVhMGQwYiBjb21waWxpbmcKODA0
IHJlYWwgIDE1ODIgdXNlciAgMTIzIHN5cyAgMjEyLjAzJSBjcHUgCWkzODYtcmFuZGNvbmZp
Zy1jMDQtMDUyOQoyMDEzLTA1LTI5LTIwOjU3OjIxIGNlOWJhZTU1OTcyYjIyOGNmN2JhYzM0
MzUwYzRkMmNhZjhlYTBkMGIgU0tJUCBCUk9LRU4gQlVJTEQKTEFORz1DIE1BS0U9L3Vzci9i
aW4vbWFrZSAtLWtlZXAtZ29pbmcgL3Vzci9iaW4vbWFrZSAtQyBzb3VyY2UgTz0vY2Mvd2Zn
L3NvdW5kLWJpc2VjdCAtajY0IC1sMTMzIEFSQ0g9aTM4NiBkaXN0Y2xlYW4KbWFrZTogRW50
ZXJpbmcgZGlyZWN0b3J5IGAvYy93Zmcvc291bmQnCiAgQ0xFQU4gICAuCiAgQ0xFQU4gICBz
Y3JpcHRzL2Jhc2ljCiAgQ0xFQU4gICBzY3JpcHRzL21vZAogIENMRUFOICAgc2NyaXB0cy9r
Y29uZmlnCiAgQ0xFQU4gICBzY3JpcHRzL2dlbmtzeW1zCiAgQ0xFQU4gICBzY3JpcHRzCiAg
Q0xFQU4gICBhcmNoL3g4Ni90b29scwogIENMRUFOICAgdXNyCiAgQ0xFQU4gICBsaWIKICBD
TEVBTiAgIGtlcm5lbAogIENMRUFOICAgZHJpdmVycy9zY3NpCiAgQ0xFQU4gICBkcml2ZXJz
L3R0eS92dAogIENMRUFOICAgZHJpdmVycy9laXNhCiAgQ0xFQU4gICBjcnlwdG8vYXN5bW1l
dHJpY19rZXlzCiAgQ0xFQU4gICBhcmNoL3g4Ni9saWIKICBDTEVBTiAgIGFyY2gveDg2L2tl
cm5lbC9jcHUKICBDTEVBTiAgIGFyY2gveDg2L2tlcm5lbAogIENMRUFOICAgYXJjaC94ODYv
dmRzbwogIENMRUFOICAgYXJjaC94ODYvcmVhbG1vZGUvcm0KICBDTEVBTiAgIC50bXBfdmVy
c2lvbnMKICBDTEVBTiAgIGluY2x1ZGUvY29uZmlnIGluY2x1ZGUvZ2VuZXJhdGVkIGFyY2gv
eDg2L2luY2x1ZGUvZ2VuZXJhdGVkCiAgQ0xFQU4gICAuY29uZmlnIC5jb25maWcub2xkIC52
ZXJzaW9uIGluY2x1ZGUvZ2VuZXJhdGVkL3VhcGkvbGludXgvdmVyc2lvbi5oIHNpZ25pbmdf
a2V5LnByaXYgc2lnbmluZ19rZXkueDUwOSB4NTA5LmdlbmtleSBleHRyYV9jZXJ0aWZpY2F0
ZXMKbWFrZTogTGVhdmluZyBkaXJlY3RvcnkgYC9jL3dmZy9zb3VuZCcKQmlzZWN0aW5nOiA4
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpb
ZjFhZmZjYWFhODYxZjI3NzUyYTc2OWY4ODliZjE0ODZlYmQzMDFmZV0gdHJhY2luZzogQWRk
IHNuYXBzaG90IGluIHRoZSBwZXJfY3B1IHRyYWNlIGRpcmVjdG9yaWVzCnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCBvYmotYmlzZWN0Cgoy
MDEzLTA1LTI5LTIwOjU3OjU0IGYxYWZmY2FhYTg2MWYyNzc1MmE3NjlmODg5YmYxNDg2ZWJk
MzAxZmUgY29tcGlsaW5nCjEzNiByZWFsICAxNTc3IHVzZXIgIDEyMSBzeXMgIDEyNDIuODYl
IGNwdSAJaTM4Ni1yYW5kY29uZmlnLWMwNC0wNTI5CjIwMTMtMDUtMjktMjE6MDM6MjAgZjFh
ZmZjYWFhODYxZjI3NzUyYTc2OWY4ODliZjE0ODZlYmQzMDFmZSBTS0lQIEJST0tFTiBCVUlM
RApMQU5HPUMgTUFLRT0vdXNyL2Jpbi9tYWtlIC0ta2VlcC1nb2luZyAvdXNyL2Jpbi9tYWtl
IC1DIHNvdXJjZSBPPS9jYy93Zmcvc291bmQtYmlzZWN0IC1qNjQgLWwyNDkgQVJDSD1pMzg2
IGRpc3RjbGVhbgptYWtlOiBFbnRlcmluZyBkaXJlY3RvcnkgYC9jL3dmZy9zb3VuZCcKICBD
TEVBTiAgIC4KICBDTEVBTiAgIGFyY2gveDg2L3Zkc28KICBDTEVBTiAgIGFyY2gveDg2L3Jl
YWxtb2RlL3JtCiAgQ0xFQU4gICBjcnlwdG8vYXN5bW1ldHJpY19rZXlzCiAgQ0xFQU4gICBk
cml2ZXJzL2Vpc2EKICBDTEVBTiAgIGRyaXZlcnMvdHR5L3Z0CiAgQ0xFQU4gICBkcml2ZXJz
L3Njc2kKICBDTEVBTiAgIGtlcm5lbAogIENMRUFOICAgbGliCiAgQ0xFQU4gICB1c3IKICBD
TEVBTiAgIGFyY2gveDg2L3Rvb2xzCiAgQ0xFQU4gICBhcmNoL3g4Ni9saWIKICBDTEVBTiAg
IGFyY2gveDg2L2tlcm5lbC9jcHUKICBDTEVBTiAgIHNjcmlwdHMvYmFzaWMKICBDTEVBTiAg
IHNjcmlwdHMvZ2Vua3N5bXMKICBDTEVBTiAgIHNjcmlwdHMvbW9kCiAgQ0xFQU4gICBzY3Jp
cHRzL2tjb25maWcKICBDTEVBTiAgIHNjcmlwdHMKICBDTEVBTiAgIGFyY2gveDg2L2tlcm5l
bAogIENMRUFOICAgLnRtcF92ZXJzaW9ucwogIENMRUFOICAgaW5jbHVkZS9jb25maWcgaW5j
bHVkZS9nZW5lcmF0ZWQgYXJjaC94ODYvaW5jbHVkZS9nZW5lcmF0ZWQKICBDTEVBTiAgIC5j
b25maWcgLmNvbmZpZy5vbGQgLnZlcnNpb24gaW5jbHVkZS9nZW5lcmF0ZWQvdWFwaS9saW51
eC92ZXJzaW9uLmggc2lnbmluZ19rZXkucHJpdiBzaWduaW5nX2tleS54NTA5IHg1MDkuZ2Vu
a2V5IGV4dHJhX2NlcnRpZmljYXRlcwptYWtlOiBMZWF2aW5nIGRpcmVjdG9yeSBgL2Mvd2Zn
L3NvdW5kJwpCaXNlY3Rpbmc6IDggcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlz
IChyb3VnaGx5IDMgc3RlcHMpClsxMjFhYWVlN2IwYTgyNjA1ZDMzYWYyMDBjN2U5ZWJhYjZm
ZDZlNDQ0XSB0cmFjaW5nOiBBZGQgcGVyX2NwdSBkaXJlY3RvcnkgaW50byB0cmFjaW5nIGlu
c3RhbmNlcwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1
cmUuc2ggb2JqLWJpc2VjdAoKMjAxMy0wNS0yOS0yMTowNDowMyAxMjFhYWVlN2IwYTgyNjA1
ZDMzYWYyMDBjN2U5ZWJhYjZmZDZlNDQ0IGNvbXBpbGluZwoxNDYgcmVhbCAgMTU4NiB1c2Vy
ICAxMjEgc3lzICAxMTY1LjE4JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1jMDQtMDUyOQoyMDEz
LTA1LTI5LTIxOjA4OjM2IDEyMWFhZWU3YjBhODI2MDVkMzNhZjIwMGM3ZTllYmFiNmZkNmU0
NDQgU0tJUCBCUk9LRU4gQlVJTEQKTEFORz1DIE1BS0U9L3Vzci9iaW4vbWFrZSAtLWtlZXAt
Z29pbmcgL3Vzci9iaW4vbWFrZSAtQyBzb3VyY2UgTz0vY2Mvd2ZnL3NvdW5kLWJpc2VjdCAt
ajY0IC1sMTM2IEFSQ0g9aTM4NiBkaXN0Y2xlYW4KbWFrZTogRW50ZXJpbmcgZGlyZWN0b3J5
IGAvYy93Zmcvc291bmQnCiAgQ0xFQU4gICAuCiAgQ0xFQU4gICBhcmNoL3g4Ni9yZWFsbW9k
ZS9ybQogIENMRUFOICAgYXJjaC94ODYva2VybmVsL2NwdQogIENMRUFOICAgYXJjaC94ODYv
dmRzbwogIENMRUFOICAgYXJjaC94ODYva2VybmVsCiAgQ0xFQU4gICBhcmNoL3g4Ni9saWIK
ICBDTEVBTiAgIGNyeXB0by9hc3ltbWV0cmljX2tleXMKICBDTEVBTiAgIGRyaXZlcnMvZWlz
YQogIENMRUFOICAgZHJpdmVycy90dHkvdnQKICBDTEVBTiAgIGRyaXZlcnMvc2NzaQogIENM
RUFOICAga2VybmVsCiAgQ0xFQU4gICBsaWIKICBDTEVBTiAgIHVzcgogIENMRUFOICAgYXJj
aC94ODYvdG9vbHMKICBDTEVBTiAgIHNjcmlwdHMvYmFzaWMKICBDTEVBTiAgIHNjcmlwdHMv
Z2Vua3N5bXMKICBDTEVBTiAgIHNjcmlwdHMvbW9kCiAgQ0xFQU4gICBzY3JpcHRzL2tjb25m
aWcKICBDTEVBTiAgIHNjcmlwdHMKICBDTEVBTiAgIC50bXBfdmVyc2lvbnMKICBDTEVBTiAg
IGluY2x1ZGUvY29uZmlnIGluY2x1ZGUvZ2VuZXJhdGVkIGFyY2gveDg2L2luY2x1ZGUvZ2Vu
ZXJhdGVkCiAgQ0xFQU4gICAuY29uZmlnIC5jb25maWcub2xkIC52ZXJzaW9uIGluY2x1ZGUv
Z2VuZXJhdGVkL3VhcGkvbGludXgvdmVyc2lvbi5oIHNpZ25pbmdfa2V5LnByaXYgc2lnbmlu
Z19rZXkueDUwOSB4NTA5LmdlbmtleSBleHRyYV9jZXJ0aWZpY2F0ZXMKbWFrZTogTGVhdmlu
ZyBkaXJlY3RvcnkgYC9jL3dmZy9zb3VuZCcKQmlzZWN0aW5nOiA4IHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbMGI4NWZmYzI5MzA0NDM5
MzYyMzA1OWVkYTk5MDRhN2Q1YjY0NGUzNl0gdHJhY2luZzogQWRkIGNvbmZpZyBvcHRpb24g
dG8gYWxsb3cgc25hcHNob3QgdG8gc3dhcCBwZXIgY3B1CnJ1bm5pbmcgL2Mva2VybmVsLXRl
c3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCBvYmotYmlzZWN0CgoyMDEzLTA1LTI5
LTIxOjA5OjE3IDBiODVmZmMyOTMwNDQzOTM2MjMwNTllZGE5OTA0YTdkNWI2NDRlMzYgY29t
cGlsaW5nCjI2NSByZWFsICAxNTkzIHVzZXIgIDEyMiBzeXMgIDY0Ni41OCUgY3B1IAlpMzg2
LXJhbmRjb25maWctYzA0LTA1MjkKMjAxMy0wNS0yOS0yMToxNzowOCAwYjg1ZmZjMjkzMDQ0
MzkzNjIzMDU5ZWRhOTkwNGE3ZDViNjQ0ZTM2IFNLSVAgQlJPS0VOIEJVSUxECkxBTkc9QyBN
QUtFPS91c3IvYmluL21ha2UgLS1rZWVwLWdvaW5nIC91c3IvYmluL21ha2UgLUMgc291cmNl
IE89L2NjL3dmZy9zb3VuZC1iaXNlY3QgLWo2NCAtbDE1NCBBUkNIPWkzODYgZGlzdGNsZWFu
Cm1ha2U6IEVudGVyaW5nIGRpcmVjdG9yeSBgL2Mvd2ZnL3NvdW5kJwogIENMRUFOICAgLgog
IENMRUFOICAgYXJjaC94ODYvdmRzbwogIENMRUFOICAgYXJjaC94ODYva2VybmVsL2NwdQog
IENMRUFOICAgYXJjaC94ODYvcmVhbG1vZGUvcm0KICBDTEVBTiAgIGFyY2gveDg2L2tlcm5l
bAogIENMRUFOICAgYXJjaC94ODYvbGliCiAgQ0xFQU4gICBjcnlwdG8vYXN5bW1ldHJpY19r
ZXlzCiAgQ0xFQU4gICBkcml2ZXJzL2Vpc2EKICBDTEVBTiAgIGRyaXZlcnMvdHR5L3Z0CiAg
Q0xFQU4gICBkcml2ZXJzL3Njc2kKICBDTEVBTiAgIGtlcm5lbAogIENMRUFOICAgbGliCiAg
Q0xFQU4gICB1c3IKICBDTEVBTiAgIGFyY2gveDg2L3Rvb2xzCiAgQ0xFQU4gICBzY3JpcHRz
L2Jhc2ljCiAgQ0xFQU4gICBzY3JpcHRzL2dlbmtzeW1zCiAgQ0xFQU4gICBzY3JpcHRzL2tj
b25maWcKICBDTEVBTiAgIHNjcmlwdHMvbW9kCiAgQ0xFQU4gICBzY3JpcHRzCiAgQ0xFQU4g
ICAudG1wX3ZlcnNpb25zCiAgQ0xFQU4gICBpbmNsdWRlL2NvbmZpZyBpbmNsdWRlL2dlbmVy
YXRlZCBhcmNoL3g4Ni9pbmNsdWRlL2dlbmVyYXRlZAogIENMRUFOICAgLmNvbmZpZyAuY29u
ZmlnLm9sZCAudmVyc2lvbiBpbmNsdWRlL2dlbmVyYXRlZC91YXBpL2xpbnV4L3ZlcnNpb24u
aCBzaWduaW5nX2tleS5wcml2IHNpZ25pbmdfa2V5Lng1MDkgeDUwOS5nZW5rZXkgZXh0cmFf
Y2VydGlmaWNhdGVzCm1ha2U6IExlYXZpbmcgZGlyZWN0b3J5IGAvYy93Zmcvc291bmQnCkJp
c2VjdGluZzogOCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
MyBzdGVwcykKWzQ1YWQyMWNhNTUzMGVmZGNhNmExOWU0YTVhYzVlN2JkNmUyNGY5OTZdIHRy
YWNpbmc6IEhhdmUgdHJhY2VfYXJyYXkga2VlcCB0cmFjayBpZiBzbmFwc2hvdCBidWZmZXIg
aXMgYWxsb2NhdGVkCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCBvYmotYmlzZWN0CgoyMDEzLTA1LTI5LTIxOjE4OjI5IDQ1YWQyMWNhNTUz
MGVmZGNhNmExOWU0YTVhYzVlN2JkNmUyNGY5OTYgY29tcGlsaW5nCjI0MyByZWFsICAxNTk4
IHVzZXIgIDEyNSBzeXMgIDcwNy4zNSUgY3B1IAlpMzg2LXJhbmRjb25maWctYzA0LTA1MjkK
MjAxMy0wNS0yOS0yMToyNjoxMyA0NWFkMjFjYTU1MzBlZmRjYTZhMTllNGE1YWM1ZTdiZDZl
MjRmOTk2IFNLSVAgQlJPS0VOIEJVSUxECkxBTkc9QyBNQUtFPS91c3IvYmluL21ha2UgLS1r
ZWVwLWdvaW5nIC91c3IvYmluL21ha2UgLUMgc291cmNlIE89L2NjL3dmZy9zb3VuZC1iaXNl
Y3QgLWo2NCAtbDI2NSBBUkNIPWkzODYgZGlzdGNsZWFuCm1ha2U6IEVudGVyaW5nIGRpcmVj
dG9yeSBgL2Mvd2ZnL3NvdW5kJwogIENMRUFOICAgLgogIENMRUFOICAgYXJjaC94ODYva2Vy
bmVsL2NwdQogIENMRUFOICAgYXJjaC94ODYvcmVhbG1vZGUvcm0KICBDTEVBTiAgIGFyY2gv
eDg2L2xpYgogIENMRUFOICAgYXJjaC94ODYvdmRzbwogIENMRUFOICAgYXJjaC94ODYva2Vy
bmVsCiAgQ0xFQU4gICBjcnlwdG8vYXN5bW1ldHJpY19rZXlzCiAgQ0xFQU4gICBkcml2ZXJz
L2Vpc2EKICBDTEVBTiAgIGRyaXZlcnMvdHR5L3Z0CiAgQ0xFQU4gICBkcml2ZXJzL3Njc2kK
ICBDTEVBTiAgIGtlcm5lbAogIENMRUFOICAgbGliCiAgQ0xFQU4gICB1c3IKICBDTEVBTiAg
IGFyY2gveDg2L3Rvb2xzCiAgQ0xFQU4gICBzY3JpcHRzL2Jhc2ljCiAgQ0xFQU4gICBzY3Jp
cHRzL2dlbmtzeW1zCiAgQ0xFQU4gICBzY3JpcHRzL2tjb25maWcKICBDTEVBTiAgIHNjcmlw
dHMvbW9kCiAgQ0xFQU4gICBzY3JpcHRzCiAgQ0xFQU4gICAudG1wX3ZlcnNpb25zCiAgQ0xF
QU4gICBpbmNsdWRlL2NvbmZpZyBpbmNsdWRlL2dlbmVyYXRlZCBhcmNoL3g4Ni9pbmNsdWRl
L2dlbmVyYXRlZAogIENMRUFOICAgLmNvbmZpZyAuY29uZmlnLm9sZCAudmVyc2lvbiBpbmNs
dWRlL2dlbmVyYXRlZC91YXBpL2xpbnV4L3ZlcnNpb24uaCBzaWduaW5nX2tleS5wcml2IHNp
Z25pbmdfa2V5Lng1MDkgeDUwOS5nZW5rZXkgZXh0cmFfY2VydGlmaWNhdGVzCm1ha2U6IExl
YXZpbmcgZGlyZWN0b3J5IGAvYy93Zmcvc291bmQnCkJpc2VjdGluZzogOCByZXZpc2lvbnMg
bGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMyBzdGVwcykKWzIyY2ZmYzJiYjRh
NTBkOGM1NmYwM2M1NmY5ZjE5ZGVhODViNzhlMzBdIHRyYWNpbmc6IEVuYWJsZSBzbmFwc2hv
dCB3aGVuIGFueSBsYXRlbmN5IHRyYWNlciBpcyBlbmFibGVkCnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCBvYmotYmlzZWN0CgoyMDEzLTA1
LTI5LTIxOjI3OjM2IDIyY2ZmYzJiYjRhNTBkOGM1NmYwM2M1NmY5ZjE5ZGVhODViNzhlMzAg
Y29tcGlsaW5nCjIyNCByZWFsICAxNjgxIHVzZXIgIDEzMSBzeXMgIDgwNy45OCUgY3B1IAlp
Mzg2LXJhbmRjb25maWctYzA0LTA1MjkKCjIwMTMtMDUtMjktMjE6MzQ6MDAgZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgMy44LjAtYmlzZWN0My1zb3VuZC0wMDU2My1nMjJjZmZjMiAjMSAJMC4u
CTkJMTAgU1VDQ0VTUwpCaXNlY3Rpbmc6IDYgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRl
ciB0aGlzIChyb3VnaGx5IDMgc3RlcHMpCls2ZGU1OGU2MjY5Y2QwNTY4Y2E1ZmJhZTE0NDIz
OTE0ZWZmMGY3ODExXSB0cmFjaW5nOiBBZGQgc25hcHNob3RfcmF3IHRvIGV4dHJhY3QgdGhl
IHJhdyBkYXRhIGZyb20gc25hcHNob3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIG9iai1iaXNlY3QKCjIwMTMtMDUtMjktMjE6MzY6MzMg
NmRlNThlNjI2OWNkMDU2OGNhNWZiYWUxNDQyMzkxNGVmZjBmNzgxMSBjb21waWxpbmcKNTE1
IHJlYWwgIDE1OTEgdXNlciAgMTMwIHN5cyAgMzM0LjM4JSBjcHUgCWkzODYtcmFuZGNvbmZp
Zy1jMDQtMDUyOQoyMDEzLTA1LTI5LTIxOjQ5OjA5IDZkZTU4ZTYyNjljZDA1NjhjYTVmYmFl
MTQ0MjM5MTRlZmYwZjc4MTEgU0tJUCBCUk9LRU4gQlVJTEQKTEFORz1DIE1BS0U9L3Vzci9i
aW4vbWFrZSAtLWtlZXAtZ29pbmcgL3Vzci9iaW4vbWFrZSAtQyBzb3VyY2UgTz0vY2Mvd2Zn
L3NvdW5kLWJpc2VjdCAtajY0IC1sMTgwIEFSQ0g9aTM4NiBkaXN0Y2xlYW4KbWFrZTogRW50
ZXJpbmcgZGlyZWN0b3J5IGAvYy93Zmcvc291bmQnCiAgQ0xFQU4gICAuCiAgQ0xFQU4gICBh
cmNoL3g4Ni92ZHNvCiAgQ0xFQU4gICBhcmNoL3g4Ni9yZWFsbW9kZS9ybQogIENMRUFOICAg
YXJjaC94ODYva2VybmVsL2NwdQogIENMRUFOICAgYXJjaC94ODYva2VybmVsCiAgQ0xFQU4g
ICBhcmNoL3g4Ni9saWIKICBDTEVBTiAgIGNyeXB0by9hc3ltbWV0cmljX2tleXMKICBDTEVB
TiAgIGRyaXZlcnMvZWlzYQogIENMRUFOICAgZmlybXdhcmUKICBDTEVBTiAgIGRyaXZlcnMv
dHR5L3Z0CiAgQ0xFQU4gICBkcml2ZXJzL3Njc2kKICBDTEVBTiAgIGtlcm5lbAogIENMRUFO
ICAgbGliCiAgQ0xFQU4gICB1c3IKICBDTEVBTiAgIGFyY2gveDg2L2Jvb3QvY29tcHJlc3Nl
ZAogIENMRUFOICAgYXJjaC94ODYvYm9vdAogIENMRUFOICAgYXJjaC94ODYvdG9vbHMKICBD
TEVBTiAgIHNjcmlwdHMvYmFzaWMKICBDTEVBTiAgIHNjcmlwdHMvZ2Vua3N5bXMKICBDTEVB
TiAgIHNjcmlwdHMva2NvbmZpZwogIENMRUFOICAgc2NyaXB0cy9tb2QKICBDTEVBTiAgIHNj
cmlwdHMKICBDTEVBTiAgIC50bXBfdmVyc2lvbnMKICBDTEVBTiAgIGluY2x1ZGUvY29uZmln
IGluY2x1ZGUvZ2VuZXJhdGVkIGFyY2gveDg2L2luY2x1ZGUvZ2VuZXJhdGVkCiAgQ0xFQU4g
ICAuY29uZmlnIC5jb25maWcub2xkIC52ZXJzaW9uIGluY2x1ZGUvZ2VuZXJhdGVkL3VhcGkv
bGludXgvdmVyc2lvbi5oIE1vZHVsZS5zeW12ZXJzIHNpZ25pbmdfa2V5LnByaXYgc2lnbmlu
Z19rZXkueDUwOSB4NTA5LmdlbmtleSBleHRyYV9jZXJ0aWZpY2F0ZXMKbWFrZTogTGVhdmlu
ZyBkaXJlY3RvcnkgYC9jL3dmZy9zb3VuZCcKQmlzZWN0aW5nOiA2IHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbYTY5NWNiNTgxNjIyOGY4
NjU3NmY1ZjVjNjgwOWZkZjhlZDM4MmVjZV0gdHJhY2luZzogUHJldmVudCBkZWxldGluZyBp
bnN0YW5jZXMgd2hlbiB0aGV5IGFyZSBiZWluZyByZWFkCnJ1bm5pbmcgL2Mva2VybmVsLXRl
c3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCBvYmotYmlzZWN0CgoyMDEzLTA1LTI5
LTIxOjQ5OjE0IGE2OTVjYjU4MTYyMjhmODY1NzZmNWY1YzY4MDlmZGY4ZWQzODJlY2UgY29t
cGlsaW5nCjExNCByZWFsICAxNTgxIHVzZXIgIDEyMiBzeXMgIDE0OTAuMDYlIGNwdSAJaTM4
Ni1yYW5kY29uZmlnLWMwNC0wNTI5CjIwMTMtMDUtMjktMjE6NTE6MzAgYTY5NWNiNTgxNjIy
OGY4NjU3NmY1ZjVjNjgwOWZkZjhlZDM4MmVjZSBTS0lQIEJST0tFTiBCVUlMRApMQU5HPUMg
TUFLRT0vdXNyL2Jpbi9tYWtlIC0ta2VlcC1nb2luZyAvdXNyL2Jpbi9tYWtlIC1DIHNvdXJj
ZSBPPS9jYy93Zmcvc291bmQtYmlzZWN0IC1qNjQgLWwxMjkgQVJDSD1pMzg2IGRpc3RjbGVh
bgptYWtlOiBFbnRlcmluZyBkaXJlY3RvcnkgYC9jL3dmZy9zb3VuZCcKICBDTEVBTiAgIC4K
ICBDTEVBTiAgIGFyY2gveDg2L3JlYWxtb2RlL3JtCiAgQ0xFQU4gICBhcmNoL3g4Ni9rZXJu
ZWwvY3B1CiAgQ0xFQU4gICBhcmNoL3g4Ni92ZHNvCiAgQ0xFQU4gICBhcmNoL3g4Ni9rZXJu
ZWwKICBDTEVBTiAgIGFyY2gveDg2L2xpYgogIENMRUFOICAgY3J5cHRvL2FzeW1tZXRyaWNf
a2V5cwogIENMRUFOICAgZHJpdmVycy9laXNhCiAgQ0xFQU4gICBkcml2ZXJzL3R0eS92dAog
IENMRUFOICAgZHJpdmVycy9zY3NpCiAgQ0xFQU4gICBrZXJuZWwKICBDTEVBTiAgIGxpYgog
IENMRUFOICAgdXNyCiAgQ0xFQU4gICBhcmNoL3g4Ni90b29scwogIENMRUFOICAgc2NyaXB0
cy9nZW5rc3ltcwogIENMRUFOICAgc2NyaXB0cy9iYXNpYwogIENMRUFOICAgc2NyaXB0cy9t
b2QKICBDTEVBTiAgIHNjcmlwdHMva2NvbmZpZwogIENMRUFOICAgc2NyaXB0cwogIENMRUFO
ICAgLnRtcF92ZXJzaW9ucwogIENMRUFOICAgaW5jbHVkZS9jb25maWcgaW5jbHVkZS9nZW5l
cmF0ZWQgYXJjaC94ODYvaW5jbHVkZS9nZW5lcmF0ZWQKICBDTEVBTiAgIC5jb25maWcgLmNv
bmZpZy5vbGQgLnZlcnNpb24gaW5jbHVkZS9nZW5lcmF0ZWQvdWFwaS9saW51eC92ZXJzaW9u
Lmggc2lnbmluZ19rZXkucHJpdiBzaWduaW5nX2tleS54NTA5IHg1MDkuZ2Vua2V5IGV4dHJh
X2NlcnRpZmljYXRlcwptYWtlOiBMZWF2aW5nIGRpcmVjdG9yeSBgL2Mvd2ZnL3NvdW5kJwpC
aXNlY3Rpbmc6IDYgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDMgc3RlcHMpCltmNWViNTU4ODI2MmNhYjcyMzJlZDFkNzdjZjYxMmIzMjdkYjUwNzY3XSBy
aW5nLWJ1ZmZlcjogRG8gbm90IHVzZSBzY2hlZHVsZV93b3JrX29uKCkgZm9yIGN1cnJlbnQg
Q1BVCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aCBvYmotYmlzZWN0CgoyMDEzLTA1LTI5LTIxOjUxOjUwIGY1ZWI1NTg4MjYyY2FiNzIzMmVk
MWQ3N2NmNjEyYjMyN2RiNTA3NjcgY29tcGlsaW5nCjI3NiByZWFsICAxNTg0IHVzZXIgIDEy
NSBzeXMgIDYxOC4wMyUgY3B1IAlpMzg2LXJhbmRjb25maWctYzA0LTA1MjkKMjAxMy0wNS0y
OS0yMTo1Njo1MCBmNWViNTU4ODI2MmNhYjcyMzJlZDFkNzdjZjYxMmIzMjdkYjUwNzY3IFNL
SVAgQlJPS0VOIEJVSUxECkxBTkc9QyBNQUtFPS91c3IvYmluL21ha2UgLS1rZWVwLWdvaW5n
IC91c3IvYmluL21ha2UgLUMgc291cmNlIE89L2NjL3dmZy9zb3VuZC1iaXNlY3QgLWo2NCAt
bDEyOCBBUkNIPWkzODYgZGlzdGNsZWFuCm1ha2U6IEVudGVyaW5nIGRpcmVjdG9yeSBgL2Mv
d2ZnL3NvdW5kJwogIENMRUFOICAgLgogIENMRUFOICAgYXJjaC94ODYvcmVhbG1vZGUvcm0K
ICBDTEVBTiAgIGFyY2gveDg2L3Zkc28KICBDTEVBTiAgIGFyY2gveDg2L2tlcm5lbC9jcHUK
ICBDTEVBTiAgIGFyY2gveDg2L2tlcm5lbAogIENMRUFOICAgYXJjaC94ODYvbGliCiAgQ0xF
QU4gICBjcnlwdG8vYXN5bW1ldHJpY19rZXlzCiAgQ0xFQU4gICBkcml2ZXJzL2Vpc2EKICBD
TEVBTiAgIGRyaXZlcnMvdHR5L3Z0CiAgQ0xFQU4gICBkcml2ZXJzL3Njc2kKICBDTEVBTiAg
IGtlcm5lbAogIENMRUFOICAgbGliCiAgQ0xFQU4gICB1c3IKICBDTEVBTiAgIGFyY2gveDg2
L3Rvb2xzCiAgQ0xFQU4gICBzY3JpcHRzL2dlbmtzeW1zCiAgQ0xFQU4gICBzY3JpcHRzL2tj
b25maWcKICBDTEVBTiAgIHNjcmlwdHMvYmFzaWMKICBDTEVBTiAgIHNjcmlwdHMvbW9kCiAg
Q0xFQU4gICBzY3JpcHRzCiAgQ0xFQU4gICAudG1wX3ZlcnNpb25zCiAgQ0xFQU4gICBpbmNs
dWRlL2NvbmZpZyBpbmNsdWRlL2dlbmVyYXRlZCBhcmNoL3g4Ni9pbmNsdWRlL2dlbmVyYXRl
ZAogIENMRUFOICAgLmNvbmZpZyAuY29uZmlnLm9sZCAudmVyc2lvbiBpbmNsdWRlL2dlbmVy
YXRlZC91YXBpL2xpbnV4L3ZlcnNpb24uaCBzaWduaW5nX2tleS5wcml2IHNpZ25pbmdfa2V5
Lng1MDkgeDUwOS5nZW5rZXkgZXh0cmFfY2VydGlmaWNhdGVzCm1ha2U6IExlYXZpbmcgZGly
ZWN0b3J5IGAvYy93Zmcvc291bmQnCkJpc2VjdGluZzogNiByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMyBzdGVwcykKWzE1M2U4ZWQ5MTNiMDIyZDIwMDM4
NjZhODQ4YWY5ZmFkYzA0MTQwM2ZdIHRyYWNpbmc6IEZpeCB0aGUgYnJhbmNoIHRyYWNlciB0
aGF0IGJyb2tlIHdpdGggYnVmZmVyIGNoYW5nZQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggb2JqLWJpc2VjdAoKMjAxMy0wNS0yOS0yMTo1
Njo1OCAxNTNlOGVkOTEzYjAyMmQyMDAzODY2YTg0OGFmOWZhZGMwNDE0MDNmIGNvbXBpbGlu
ZwoxNTAgcmVhbCAgMTY3NSB1c2VyICAxMzQgc3lzICAxMjAwLjkyJSBjcHUgCWkzODYtcmFu
ZGNvbmZpZy1jMDQtMDUyOQoKMjAxMy0wNS0yOS0yMjowMToxNCBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAzLjguMC1iaXNlY3QzLXNvdW5kLTAwNTc3LWcxNTNlOGVkICMxIAkwIFRFU1QgRkFJ
TFVSRQpUaGVyZSBhcmUgb25seSAnc2tpcCdwZWQgY29tbWl0cyBsZWZ0IHRvIHRlc3QuClRo
ZSBmaXJzdCBiYWQgY29tbWl0IGNvdWxkIGJlIGFueSBvZjoKY2U5YmFlNTU5NzJiMjI4Y2Y3
YmFjMzQzNTBjNGQyY2FmOGVhMGQwYgoxMjFhYWVlN2IwYTgyNjA1ZDMzYWYyMDBjN2U5ZWJh
YjZmZDZlNDQ0CjczNzIyM2ZiY2EzYjFjOTFmZWI5NDdjN2Y1NzFiMzU3NDliNzQzYjYKNDVh
ZDIxY2E1NTMwZWZkY2E2YTE5ZTRhNWFjNWU3YmQ2ZTI0Zjk5NgphNjk1Y2I1ODE2MjI4Zjg2
NTc2ZjVmNWM2ODA5ZmRmOGVkMzgyZWNlCjZkZTU4ZTYyNjljZDA1NjhjYTVmYmFlMTQ0MjM5
MTRlZmYwZjc4MTEKYWQ5MDllMjFiYmU2OWYxZDM5MDU1ZDM0NjU0MGFiZDgyNzE5MGVjYQow
Yjg1ZmZjMjkzMDQ0MzkzNjIzMDU5ZWRhOTkwNGE3ZDViNjQ0ZTM2CmY1ZWI1NTg4MjYyY2Fi
NzIzMmVkMWQ3N2NmNjEyYjMyN2RiNTA3NjcKZjFhZmZjYWFhODYxZjI3NzUyYTc2OWY4ODli
ZjE0ODZlYmQzMDFmZQpmNGU3ODFjMGE4OWQ1ODEwNzI5NzcyMjkwNDQxYWM3ZDYxZjMyMWVj
CjEyODgzZWZiNjcwYzI4ZGZmNTdkY2Q3ZjRmOTk1YTFmZmUxNTNiMmQKNTUwMzRjZDZlNjQ4
MTU1MzkzYjBkNjY1ZWVmNzZiMzhkNDlhZDZiZgoxNTNlOGVkOTEzYjAyMmQyMDAzODY2YTg0
OGFmOWZhZGMwNDE0MDNmCldlIGNhbm5vdCBiaXNlY3QgbW9yZSEKYmlzZWN0IHJ1biBjYW5u
b3QgY29udGludWUgYW55IG1vcmUKG1sxOzM1bWNhbm5vdCBmaW5kIHRoZSBmaXJzdCBiYWQg
Y29tbWl0G1swbQo=

--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.10.0-rc3 Kernel Configuration
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
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
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
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set
CONFIG_AUDIT_LOGINUID_IMMUTABLE=y
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
# CONFIG_TINY_PREEMPT_RCU is not set
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_BOOST is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HOTPLUG=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
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
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_KPROBES_ON_FTRACE=y
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
CONFIG_SECCOMP_FILTER=y
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
CONFIG_GCOV_PROFILE_ALL=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
CONFIG_MODULE_SIG_FORCE=y
# CONFIG_MODULE_SIG_ALL is not set

#
# Do not forget to sign required modules with scripts/sign-file
#
CONFIG_MODULE_SIG_SHA1=y
# CONFIG_MODULE_SIG_SHA224 is not set
# CONFIG_MODULE_SIG_SHA256 is not set
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha1"
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_THROTTLING=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
CONFIG_ACORN_PARTITION_POWERTEC=y
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_BSD_DISKLABEL is not set
# CONFIG_MINIX_SUBPARTITION is not set
CONFIG_SOLARIS_X86_PARTITION=y
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
# CONFIG_HYPERVISOR_GUEST is not set
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
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
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
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
# CONFIG_TOSHIBA is not set
CONFIG_I8K=m
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
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
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_FRONTSWAP is not set
# CONFIG_HIGHPTE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
CONFIG_PM_SLEEP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=m
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
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
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=m
# CONFIG_APM_IGNORE_USER_SUSPEND is not set
CONFIG_APM_DO_ENABLE=y
# CONFIG_APM_CPU_IDLE is not set
CONFIG_APM_DISPLAY_BLANK=y
# CONFIG_APM_ALLOW_INTS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K6=m
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K7_ACPI=y
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=m
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
CONFIG_X86_LONGRUN=m
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set
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
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
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
# CONFIG_EISA_VLB_PRIMING is not set
CONFIG_EISA_PCI_EISA=y
CONFIG_EISA_VIRTUAL_ROOT=y
CONFIG_EISA_NAMES=y
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
CONFIG_ALIX=y
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
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_I82365=m
CONFIG_TCIC=m
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_BINFMT_SCRIPT is not set
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
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
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETWORK_PHY_TIMESTAMPING=y
# CONFIG_NETFILTER is not set
CONFIG_ATM=y
CONFIG_ATM_LANE=m
CONFIG_STP=m
CONFIG_BRIDGE=m
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=m
CONFIG_IPX_INTERN=y
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=m
CONFIG_LTPC=m
# CONFIG_COPS is not set
CONFIG_IPDDP=m
CONFIG_IPDDP_ENCAP=y
CONFIG_X25=m
CONFIG_LAPB=m
CONFIG_PHONET=m
CONFIG_IEEE802154=y
# CONFIG_MAC802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=y
# CONFIG_NET_SCH_ATM is not set
CONFIG_NET_SCH_PRIO=y
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=y
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_MQPRIO is not set
CONFIG_NET_SCH_CHOKE=y
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=y
CONFIG_NET_SCH_FQ_CODEL=m
# CONFIG_NET_SCH_INGRESS is not set
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
# CONFIG_CLS_U32_MARK is not set
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_CLS_CGROUP=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
CONFIG_NET_EMATCH_NBYTE=y
CONFIG_NET_EMATCH_U32=y
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=y
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=y
# CONFIG_NET_ACT_NAT is not set
CONFIG_NET_ACT_PEDIT=y
CONFIG_NET_ACT_SIMP=y
CONFIG_NET_ACT_SKBEDIT=m
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
CONFIG_BATMAN_ADV=m
CONFIG_BATMAN_ADV_NC=y
CONFIG_BATMAN_ADV_DEBUG=y
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=m
CONFIG_NETPRIO_CGROUP=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
CONFIG_IRCOMM=m
# CONFIG_IRDA_ULTRA is not set

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

#
# FIR device drivers
#
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=m
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=m
CONFIG_ALI_FIR=m
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
CONFIG_BT=m
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
# CONFIG_BT_BNEP_PROTO_FILTER is not set
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
# CONFIG_BT_HCIUART_BCSP is not set
# CONFIG_BT_HCIUART_ATH3K is not set
# CONFIG_BT_HCIUART_LL is not set
CONFIG_BT_HCIUART_3WIRE=y
CONFIG_BT_HCIDTL1=m
# CONFIG_BT_HCIBT3C is not set
# CONFIG_BT_HCIBLUECARD is not set
# CONFIG_BT_HCIBTUART is not set
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
CONFIG_BT_MRVL_SDIO=m
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=m
CONFIG_RFKILL_INPUT=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=m
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=y
CONFIG_CAIF_USB=m
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
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
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=16
CONFIG_CMA_SIZE_PERCENTAGE=10
# CONFIG_CMA_SIZE_SEL_MBYTES is not set
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
CONFIG_CMA_SIZE_SEL_MAX=y
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7

#
# Bus devices
#
CONFIG_CONNECTOR=m
CONFIG_MTD=m
CONFIG_MTD_TESTS=m
# CONFIG_MTD_REDBOOT_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
# CONFIG_MTD_BLOCK_RO is not set
# CONFIG_FTL is not set
CONFIG_NFTL=m
CONFIG_NFTL_RW=y
CONFIG_INFTL=m
CONFIG_RFD_FTL=m
CONFIG_SSFDC=m
# CONFIG_SM_FTL is not set
CONFIG_MTD_OOPS=m
# CONFIG_MTD_SWAP is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
CONFIG_MTD_CFI_ADV_OPTIONS=y
CONFIG_MTD_CFI_NOSWAP=y
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
CONFIG_MTD_CFI_GEOMETRY=y
# CONFIG_MTD_MAP_BANK_WIDTH_1 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_2 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_4 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
# CONFIG_MTD_CFI_I2 is not set
CONFIG_MTD_CFI_I4=y
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_OTP=y
CONFIG_MTD_CFI_INTELEXT=m
# CONFIG_MTD_CFI_AMDSTD is not set
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PHYSMAP is not set
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_AMD76XROM=m
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
CONFIG_MTD_NETtel=m
CONFIG_MTD_L440GX=m
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=m

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=m
CONFIG_MTD_DATAFLASH_WRITE_VERIFY=y
# CONFIG_MTD_DATAFLASH_OTP is not set
CONFIG_MTD_M25P80=m
CONFIG_M25PXX_USE_FAST_READ=y
CONFIG_MTD_SST25L=m
CONFIG_MTD_SLRAM=m
CONFIG_MTD_PHRAM=m
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
# CONFIG_MTD_BLOCK2MTD is not set

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
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=m
# CONFIG_MTD_NAND_DENALI_PCI is not set
CONFIG_MTD_NAND_IDS=m
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=m
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH=y
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
# CONFIG_MTD_NAND_DOCG4 is not set
# CONFIG_MTD_NAND_CAFE is not set
# CONFIG_MTD_NAND_CS553X is not set
CONFIG_MTD_NAND_NANDSIM=m
CONFIG_MTD_NAND_PLATFORM=m
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
# CONFIG_MTD_UBI is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_ISAPNP=y
CONFIG_PNPBIOS=y
# CONFIG_PNPBIOS_PROC_FS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
CONFIG_BLK_DEV_OSD=m
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
CONFIG_ATA_OVER_ETH=m
CONFIG_VIRTIO_BLK=m
CONFIG_BLK_DEV_HD=y
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=m
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
CONFIG_ATMEL_SSC=m
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=m
CONFIG_ISL29020=m
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
CONFIG_DS1682=m
CONFIG_TI_DAC7512=y
CONFIG_BMP085=y
# CONFIG_BMP085_I2C is not set
CONFIG_BMP085_SPI=m
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=m
# CONFIG_LATTICE_ECP3_CONFIG is not set
CONFIG_SRAM=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_AT25=m
CONFIG_EEPROM_LEGACY=m
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
CONFIG_EEPROM_93XX46=m
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_IDE_LEGACY=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
# CONFIG_IDE_GD_ATA is not set
CONFIG_IDE_GD_ATAPI=y
CONFIG_BLK_DEV_IDECS=m
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
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
CONFIG_BLK_DEV_ALI14XX=m
CONFIG_BLK_DEV_DTC2278=m
CONFIG_BLK_DEV_HT6560B=m
CONFIG_BLK_DEV_QD65XX=m
CONFIG_BLK_DEV_UMC8672=y
# CONFIG_BLK_DEV_IDEDMA is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=y
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_BOOT_SYSFS=y
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
CONFIG_SCSI_7000FASST=y
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AHA152X=m
CONFIG_SCSI_AHA1542=m
# CONFIG_SCSI_AHA1740 is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
CONFIG_SCSI_ADVANSYS=m
# CONFIG_SCSI_IN2000 is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPT3SAS is not set
CONFIG_SCSI_UFSHCD=y
# CONFIG_SCSI_UFSHCD_PCI is not set
CONFIG_SCSI_UFSHCD_PLATFORM=m
# CONFIG_SCSI_HPTIOP is not set
CONFIG_SCSI_BUSLOGIC=y
# CONFIG_SCSI_FLASHPOINT is not set
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
CONFIG_SCSI_DTC3280=y
CONFIG_SCSI_EATA=m
# CONFIG_SCSI_EATA_TAGGED_QUEUE is not set
# CONFIG_SCSI_EATA_LINKED_COMMANDS is not set
CONFIG_SCSI_EATA_MAX_TAGS=16
# CONFIG_SCSI_FUTURE_DOMAIN is not set
CONFIG_SCSI_GDTH=y
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_GENERIC_NCR5380 is not set
CONFIG_SCSI_GENERIC_NCR5380_MMIO=y
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
CONFIG_SCSI_NCR53C406A=m
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_PAS16=y
CONFIG_SCSI_QLOGIC_FAS=y
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_SIM710=y
CONFIG_SCSI_SYM53C416=m
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_T128=y
CONFIG_SCSI_U14_34F=m
CONFIG_SCSI_U14_34F_TAGGED_QUEUE=y
CONFIG_SCSI_U14_34F_LINKED_COMMANDS=y
CONFIG_SCSI_U14_34F_MAX_TAGS=8
CONFIG_SCSI_ULTRASTOR=m
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_VIRTIO is not set
# CONFIG_SCSI_CHELSIO_FCOE is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
CONFIG_SCSI_DH=m
CONFIG_SCSI_DH_RDAC=m
CONFIG_SCSI_DH_HP_SW=m
CONFIG_SCSI_DH_EMC=m
CONFIG_SCSI_DH_ALUA=m
CONFIG_SCSI_OSD_INITIATOR=y
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
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set

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
CONFIG_SATA_MV=y
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
# CONFIG_PATA_CS5535 is not set
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
# CONFIG_PATA_ISAPNP is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PCMCIA is not set
CONFIG_PATA_QDI=y
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_WINBOND_VLB is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
CONFIG_PATA_LEGACY=y
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
# CONFIG_NETDEVICES is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
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
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=m

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
CONFIG_KEYBOARD_GPIO=m
CONFIG_KEYBOARD_GPIO_POLLED=y
CONFIG_KEYBOARD_TCA6416=m
CONFIG_KEYBOARD_TCA8418=m
CONFIG_KEYBOARD_MATRIX=m
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
CONFIG_KEYBOARD_MAX7359=m
# CONFIG_KEYBOARD_MCS is not set
CONFIG_KEYBOARD_MPR121=m
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_KEYBOARD_SUNKBD=m
CONFIG_KEYBOARD_STMPE=y
CONFIG_KEYBOARD_XTKBD=m
CONFIG_KEYBOARD_CROS_EC=m
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
# CONFIG_MOUSE_PS2_SENTELIC is not set
CONFIG_MOUSE_PS2_TOUCHKIT=y
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=m
# CONFIG_MOUSE_INPORT is not set
CONFIG_MOUSE_LOGIBM=m
CONFIG_MOUSE_PC110PAD=m
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=m
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=m
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
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
CONFIG_N_GSM=y
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_FOURPORT=m
CONFIG_SERIAL_8250_ACCENT=m
# CONFIG_SERIAL_8250_BOCA is not set
CONFIG_SERIAL_8250_EXAR_ST16C554=m
# CONFIG_SERIAL_8250_HUB6 is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
# CONFIG_SERIAL_8250_RSA is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_MAX310X=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=m
CONFIG_SERIAL_TIMBERDALE=y
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_IFX6X60=y
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
CONFIG_DTLK=m
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
CONFIG_CARDMAN_4000=m
# CONFIG_CARDMAN_4040 is not set
CONFIG_MWAVE=y
CONFIG_PC8736x_GPIO=m
CONFIG_NSC_GPIO=m
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_MUX is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
# CONFIG_I2C_ALGOPCF is not set
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
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_TAOS_EVM=m

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_ELEKTOR is not set
CONFIG_I2C_PCA_ISA=m
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_STUB=m
CONFIG_I2C_DEBUG_CORE=y
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_OC_TINY=m
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=m
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_XCOMM=m
CONFIG_SPI_XILINX=y
CONFIG_SPI_DESIGNWARE=m
# CONFIG_SPI_DW_PCI is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=m

#
# Qualcomm MSM SSBI bus support
#
# CONFIG_SSBI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

#
# PPS support
#
CONFIG_PPS=m
CONFIG_PPS_DEBUG=y

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=m

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_MAX7300=m
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=m
CONFIG_GPIO_STMPE=y
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_WM831X=m
# CONFIG_GPIO_ADP5588 is not set

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
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MCP23S08 is not set
CONFIG_GPIO_MC33880=m
CONFIG_GPIO_74X164=y

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#

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
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
# CONFIG_W1_SLAVE_DS2413 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
CONFIG_WM831X_BACKUP=m
CONFIG_WM831X_POWER=m
CONFIG_TEST_POWER=m
CONFIG_BATTERY_DS2780=m
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=m
CONFIG_BATTERY_BQ27x00=m
CONFIG_BATTERY_BQ27X00_I2C=y
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
# CONFIG_BATTERY_DA9052 is not set
CONFIG_BATTERY_MAX17040=m
CONFIG_BATTERY_MAX17042=m
CONFIG_CHARGER_MAX8903=m
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=m
CONFIG_CHARGER_BQ2415X=m
CONFIG_CHARGER_SMB347=m
# CONFIG_BATTERY_GOLDFISH is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7314=m
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADCXX=m
CONFIG_SENSORS_ADM1021=m
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=m
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=m
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_DA9052_ADC is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_GL518SM=m
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_GPIO_FAN=m
CONFIG_SENSORS_HIH6130=m
CONFIG_SENSORS_CORETEMP=m
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM70=m
CONFIG_SENSORS_LM73=m
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=m
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_MAX1111=m
CONFIG_SENSORS_MAX16065=m
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=m
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=m
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_NCT6775 is not set
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
# CONFIG_SENSORS_PMBUS is not set
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_LM25066 is not set
CONFIG_SENSORS_LTC2978=m
# CONFIG_SENSORS_MAX16064 is not set
CONFIG_SENSORS_MAX34440=m
# CONFIG_SENSORS_MAX8688 is not set
CONFIG_SENSORS_UCD9000=m
# CONFIG_SENSORS_UCD9200 is not set
# CONFIG_SENSORS_ZL6100 is not set
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=m
CONFIG_SENSORS_ADS1015=m
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
CONFIG_SENSORS_THMC50=m
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
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
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_WM831X=m
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_MC13783_ADC=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_CPU_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
CONFIG_INTEL_POWERCLAMP=m
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_DA9052_WATCHDOG=y
# CONFIG_WM831X_WATCHDOG is not set
CONFIG_RETU_WATCHDOG=m
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=m
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
CONFIG_SC520_WDT=y
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
CONFIG_SC1200_WDT=y
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=m
# CONFIG_SBC8360_WDT is not set
# CONFIG_SBC7240_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=m
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=y
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
CONFIG_SBC_EPX_C3_WATCHDOG=m

#
# ISA-based Watchdog Cards
#
CONFIG_PCWATCHDOG=m
CONFIG_MIXCOMWD=m
# CONFIG_WDT is not set

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
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=m
CONFIG_MFD_CROS_EC_SPI=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_MC13783=m
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_SPI=m
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_EZX_PCAP=y
CONFIG_MFD_RETU=m
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_SI476X_CORE=m
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
CONFIG_ABX500_CORE=y
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
CONFIG_STMPE_SPI=y
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_TPS6105X is not set
CONFIG_TPS65010=m
CONFIG_TPS6507X=m
CONFIG_MFD_TPS65217=m
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_SPI=y
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=m
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_ARIZONA_SPI=m
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_SPI=y
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=m
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
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
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
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
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
CONFIG_FB_ARC=m
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=m
CONFIG_FB_N411=m
# CONFIG_FB_HGA is not set
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
# CONFIG_FB_TMIO is not set
CONFIG_FB_SM501=m
CONFIG_FB_GOLDFISH=m
CONFIG_FB_VIRTUAL=m
CONFIG_FB_METRONOME=m
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=m
CONFIG_FB_AUO_K190X=m
CONFIG_FB_AUO_K1900=m
CONFIG_FB_AUO_K1901=m
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_LM3533=m
# CONFIG_BACKLIGHT_PWM is not set
# CONFIG_BACKLIGHT_DA9052 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=m
CONFIG_BACKLIGHT_ADP8860=m
CONFIG_BACKLIGHT_ADP8870=m
CONFIG_BACKLIGHT_LM3630=m
CONFIG_BACKLIGHT_LM3639=m
# CONFIG_BACKLIGHT_LP855X is not set
CONFIG_BACKLIGHT_TPS65217=m

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_MDA_CONSOLE=m
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=m
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
CONFIG_FONTS=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_FONT_6x11 is not set
CONFIG_FONT_7x14=y
# CONFIG_FONT_PEARL_8x8 is not set
# CONFIG_FONT_ACORN_8x8 is not set
# CONFIG_FONT_MINI_4x6 is not set
CONFIG_FONT_SUN8x16=y
# CONFIG_FONT_SUN12x22 is not set
CONFIG_FONT_10x18=y
# CONFIG_LOGO is not set
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_COMPRESS_OFFLOAD=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=m
# CONFIG_SND_SEQ_HRTIMER_DEFAULT is not set
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
CONFIG_SND_OPL3_LIB_SEQ=m
CONFIG_SND_OPL4_LIB_SEQ=m
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_OPL4_LIB=m
CONFIG_SND_VX_LIB=m
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_WSS_LIB=m
CONFIG_SND_SB_COMMON=m
CONFIG_SND_SB8_DSP=m
CONFIG_SND_SB16_DSP=m
CONFIG_SND_ISA=y
# CONFIG_SND_ADLIB is not set
# CONFIG_SND_AD1816A is not set
CONFIG_SND_AD1848=m
CONFIG_SND_ALS100=m
CONFIG_SND_AZT1605=m
# CONFIG_SND_AZT2316 is not set
# CONFIG_SND_AZT2320 is not set
CONFIG_SND_CMI8328=m
# CONFIG_SND_CMI8330 is not set
CONFIG_SND_CS4231=m
# CONFIG_SND_CS4236 is not set
CONFIG_SND_ES1688=m
# CONFIG_SND_ES18XX is not set
CONFIG_SND_SC6000=m
CONFIG_SND_GUSCLASSIC=m
CONFIG_SND_GUSEXTREME=m
CONFIG_SND_GUSMAX=m
# CONFIG_SND_INTERWAVE is not set
CONFIG_SND_INTERWAVE_STB=m
# CONFIG_SND_JAZZ16 is not set
CONFIG_SND_OPL3SA2=m
CONFIG_SND_OPTI92X_AD1848=m
# CONFIG_SND_OPTI92X_CS4231 is not set
# CONFIG_SND_OPTI93X is not set
CONFIG_SND_MIRO=m
CONFIG_SND_SB8=m
# CONFIG_SND_SB16 is not set
# CONFIG_SND_SBAWE is not set
# CONFIG_SND_SSCAPE is not set
CONFIG_SND_WAVEFRONT=m
CONFIG_SND_MSND_PINNACLE=m
CONFIG_SND_MSND_CLASSIC=m
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
# CONFIG_SND_SPI is not set
CONFIG_SND_PCMCIA=y
CONFIG_SND_VXPOCKET=m
CONFIG_SND_PDAUDIOCF=m
CONFIG_SND_SOC=m
CONFIG_SND_ATMEL_SOC=m
CONFIG_SND_SOC_I2C_AND_SPI=m
# CONFIG_SND_SOC_ALL_CODECS is not set
# CONFIG_SND_SIMPLE_CARD is not set
CONFIG_SOUND_PRIME=m
# CONFIG_SOUND_MSNDCLAS is not set
# CONFIG_SOUND_MSNDPIN is not set
# CONFIG_SOUND_OSS is not set

#
# HID support
#
CONFIG_HID=m
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=m

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=m
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_PRODIKEYS=m
CONFIG_HID_CYPRESS=m
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=m
CONFIG_HID_ELECOM=m
CONFIG_HID_EZKEY=m
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LOGITECH=m
CONFIG_HID_LOGITECH_DJ=m
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=m
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
CONFIG_PANTHERLORD_FF=y
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_PRIMAX=m
CONFIG_HID_PS3REMOTE=m
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_GREENASIA=m
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=m
CONFIG_SMARTJOYPLUS_FF=y
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
# CONFIG_HID_THRUSTMASTER is not set
CONFIG_HID_WACOM=m
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_ZEROPLUS=m
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=m
# CONFIG_HID_SENSOR_HUB is not set

#
# I2C HID support
#
CONFIG_I2C_HID=m
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
# CONFIG_MMC_SDHCI_PLTFM is not set
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MEMSTICK=m
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=m

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
CONFIG_LEDS_LM3530=m
CONFIG_LEDS_LM3533=m
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=m
# CONFIG_LEDS_PCA9532_GPIO is not set
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=m
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_LP5562=m
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA9633=m
CONFIG_LEDS_WM831X_STATUS=m
CONFIG_LEDS_DA9052=m
CONFIG_LEDS_DAC124S085=m
# CONFIG_LEDS_PWM is not set
CONFIG_LEDS_BD2802=m
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=m
CONFIG_LEDS_MC13783=m
CONFIG_LEDS_TCA6507=m
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_OT200=m
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_A11Y_BRAILLE_CONSOLE is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=m
# CONFIG_EDAC_MCE_INJ is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=m

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=m
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

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
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=m
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=m

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=m
# CONFIG_EXTCON_ARIZONA is not set
CONFIG_MEMORY=y
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_IPACK_BUS=m
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4_USE_FOR_EXT23 is not set
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_EXT4_DEBUG=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
# CONFIG_XFS_POSIX_ACL is not set
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
CONFIG_OCFS2_FS=m
# CONFIG_OCFS2_FS_O2CB is not set
# CONFIG_OCFS2_FS_STATS is not set
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
CONFIG_NILFS2_FS=m
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=m
# CONFIG_QFMT_V1 is not set
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=m
# CONFIG_CUSE is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
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
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=m
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=m
CONFIG_ECRYPT_FS=m
CONFIG_ECRYPT_FS_MESSAGING=y
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=m
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
# CONFIG_JFFS2_FS is not set
CONFIG_LOGFS=y
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_XATTR is not set
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZO is not set
# CONFIG_SQUASHFS_XZ is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=m
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=m
# CONFIG_QNX6FS_FS is not set
CONFIG_ROMFS_FS=m
# CONFIG_ROMFS_BACKED_BY_BLOCK is not set
CONFIG_ROMFS_BACKED_BY_MTD=y
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_FTRACE=y
# CONFIG_PSTORE_RAM is not set
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
# CONFIG_EXOFS_FS is not set
# CONFIG_F2FS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NCP_FS=y
CONFIG_NCPFS_PACKET_SIGNING=y
# CONFIG_NCPFS_IOCTL_LOCKING is not set
CONFIG_NCPFS_STRONG=y
# CONFIG_NCPFS_NFS_NS is not set
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=m
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=m
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=m
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=m
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=m
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_PREEMPT=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
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
# CONFIG_PROVE_RCU_DELAY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_VERBOSE=y
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_LKDTM is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_PAGEALLOC is not set
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
CONFIG_IRQSOFF_TRACER=y
CONFIG_PREEMPT_TRACER=y
CONFIG_SCHED_TRACER=y
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
# CONFIG_KPROBE_EVENT is not set
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_EVENT_TRACE_TEST_SYSCALLS=y
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_DYNAMIC_DEBUG=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_SET_MODULE_RONX=y
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_STRESS=y
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
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
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
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER_X86=m

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=m
# CONFIG_CRYPTO_DES is not set
CONFIG_CRYPTO_FCRYPT=m
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=y
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=m

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
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
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_DRM_TTM is not set
# CONFIG_ISDN_DRV_LOOP is not set
# CONFIG_PCI_ATS is not set

--LQksG6bCIzRHxTLp--
