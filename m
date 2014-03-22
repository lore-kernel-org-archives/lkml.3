Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317AbaCVLrA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 07:47:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:50606 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbaCVLq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 07:46:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,709,1389772800"; 
   d="log'?scan'208";a="497386713"
Date: Sat, 22 Mar 2014 19:47:00 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [x86,vdso32] kernel BUG at mm/swap.c:134!
Message-ID: <20140322114700.GA14326@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/vdso

commit 4e40112c4ff6a577dd06d92b2a54cdf06265bf74
Author:     Stefani Seibold <stefani@seibold.net>
AuthorDate: Mon Mar 17 23:22:13 2014 +0100
Commit:     H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue Mar 18 12:52:54 2014 -0700

    x86, vdso32: handle 32 bit vDSO larger one page
    
    This patch enables 32 bit vDSO which are larger than a page.
    
    Signed-off-by: Stefani Seibold <stefani@seibold.net>
    Link: http://lkml.kernel.org/r/1395094933-14252-14-git-send-email-stefani@seibold.net
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

+----------------------------------------+------------+---------------+
|                                        | 4e40112c4f | next-20140320 |
+----------------------------------------+------------+---------------+
| boot_successes                         | 0          | 0             |
| boot_failures                          | 21         | 19            |
| kernel_BUG_at_mm/swap.c                | 21         | 19            |
| invalid_opcode:PREEMPT_DEBUG_PAGEALLOC | 21         | 19            |
| EIP_is_at_put_compound_page            | 21         | 19            |
| backtrace:do_execve                    | 8          | 11            |
| backtrace:SyS_execve                   | 8          | 11            |
| backtrace:do_group_exit                | 13         | 8             |
| backtrace:SyS_exit_group               | 13         | 8             |
+----------------------------------------+------------+---------------+

[    9.196432] page:8670b3e8 count:0 mapcount:1 mapping:  (null) index:0x0
[    9.199071] page flags: 0x40008004(referenced|tail)
[    9.216380] ------------[ cut here ]------------
[    9.218008] kernel BUG at mm/swap.c:134!
[    9.220257] invalid opcode: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
[    9.222817] Modules linked in:
[    9.224080] CPU: 0 PID: 69 Comm: init Not tainted 3.14.0-rc7-next-20140320-10753-ga654dc7 #1
[    9.225460] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    9.225460] task: 7ef39880 ti: 78a02000 task.ti: 78a02000
[    9.225460] EIP: 0060:[<7907ae36>] EFLAGS: 00010246 CPU: 0
[    9.225460] EIP is at put_compound_page+0x7d/0x1da
[    9.225460] EAX: 795143df EBX: 8670b3c0 ECX: 7904b884 EDX: 00000001
[    9.225460] ESI: 8670b3e8 EDI: ffffffff EBP: 78a03d40 ESP: 78a03d34
[    9.225460]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    9.225460] CR0: 8005003b CR2: 77bd1f38 CR3: 00a05000 CR4: 000006d0
[    9.225460] Stack:
[    9.225460]  8670b3e8 00000000 ffffffff 78a03d78 7907b036 00000001 78a03d64 00000000
[    9.225460]  000000e1 78a0700c 00000246 00000092 865509a4 8654e26c 78a07000 78a03db0
[    9.225460]  78a03dc4 78a03d8c 79086cb7 78a03db0 78960280 00000000 78a03d9c 79086cd8
[    9.225460] Call Trace:
[    9.225460]  [<7907b036>] release_pages+0x58/0x175
[    9.225460]  [<79086cb7>] tlb_flush_mmu+0x30/0x45
[    9.225460]  [<79086cd8>] tlb_finish_mmu+0xc/0x2b
[    9.225460]  [<7908cab1>] exit_mmap+0x84/0xcb
[    9.225460]  [<79025a31>] mmput+0x2c/0xb1
[    9.225460]  [<790a2c79>] flush_old_exec+0x4af/0x564
[    9.225460]  [<790c3030>] load_elf_binary+0x272/0xb86
[    9.225460]  [<790a2220>] search_binary_handler+0x5f/0x145
[    9.225460]  [<790c2c06>] load_script+0x17a/0x183
[    9.225460]  [<79041c35>] ? sched_clock_cpu+0xaa/0xd3
[    9.225460]  [<790482bd>] ? lock_release+0x13c/0x19a
[    9.225460]  [<79311444>] ? _raw_read_unlock+0x27/0x38
[    9.225460]  [<790a2220>] search_binary_handler+0x5f/0x145
[    9.225460]  [<790a32eb>] do_execve+0x371/0x47c
[    9.225460]  [<790a354a>] SyS_execve+0x1c/0x20
[    9.225460]  [<793154d5>] sysenter_do_call+0x12/0x37
[    9.225460] Code: 0f 84 a3 00 00 00 89 d8 e8 73 fc ff ff 85 c0 75 0b 31 d2 89 d8 e8 f5 c5 ff ff 0f 0b 8b 46 0c 40 74 0b 31 d2 89 f0 e8 e4 c5 ff ff <0f> 0b 89 d8 e8 e5 fc ff ff 85 c0 0f 84 47 01 00 00 8b 03 a8 80
[    9.225460] EIP: [<7907ae36>] put_compound_page+0x7d/0x1da SS:ESP 0068:78a03d34
[    9.379006] ---[ end trace cdeaef9772248ae3 ]---

git bisect start 016319d375c00db40dac165fcdaec78b67094243 v3.11 --
git bisect good 843f4f4bb1a2c4c196a1af1d18bb6477a580ac78  # 16:35     21+      0  Merge tag 'trace-fixes-3.13-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
git bisect good 5a5e75f4714a592f31e57f248b8f5c866f278b8d  # 17:03     21+      0  tile: remove compat_sys_lookup_dcookie declaration to fix compile error
git bisect good 721f0c126075294e66df73051cc2e1d795ef2095  # 17:46     21+      0  Merge tag 'trace-fixes-v3.14-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
git bisect good 767a656e0f9139efcdcd0b64fc30e46e82d090b7  # 18:33     21+      0  Merge remote-tracking branch 'f2fs/dev'
git bisect good 8d5ec484dbbee2784e88974eca3249024e0c2bdd  # 19:13     21+      0  Merge remote-tracking branch 'omap_dss2/for-next'
git bisect  bad 4b797d758496f2a3142fd52f974587151692e1b2  # 19:49      0-     19  Merge remote-tracking branch 'leds/for-next'
git bisect good 5535681dc44e2050d9b4e4e756b7a1b47d770d72  # 20:39     21+      0  Merge remote-tracking branch 'dt-rh/for-next'
git bisect  bad ebcbda16d34470aca469fa93ba1523dcca5ea272  # 21:00      0-      3  Merge remote-tracking branch 'ftrace/for-next'
git bisect  bad 7bbcbf42f5d85f15ed4f28865e531d4c4984f591  # 21:35      0-      1  Merge remote-tracking branch 'tip/auto-latest'
git bisect good 8f752c4d5d976feb0640db091687ac5da714bf9a  # 22:06     21+      0  Merge remote-tracking branch 'spi/for-next'
git bisect good 10c8f975283dc6fe180d3dfd7e27968dcccfb81f  # 22:28     21+      1  Merge branch 'perf/core'
git bisect good 8061da5dffffc4399df17a517592a5652a3d931c  # 23:06     21+      0  Merge branch 'x86/apic'
git bisect good f06640d5519dd5f7ee211b530d9a44f5402fb302  # 00:07     21+      0  Merge branch 'x86/debug'
git bisect good c28087ca73812d93516a06099fe49997a0f8d2c0  # 00:36     21+      0  Merge branch 'x86/mm'
git bisect good 4dab93cc97ad85b7abbc6b70531b412a3b1d6aa2  # 01:27     21+      0  Merge branch 'x86/threadinfo'
git bisect good ef721987aef0cc0abba08c88810f2155f76b0b1f  # 01:52     21+      0  x86, vdso: Introduce VVAR marco for vdso32
git bisect good 008cc907de327d83a0be609cd495fccb0e5dfa4c  # 02:51     21+      0  x86, vdso32: Disable stack protector, adjust optimizations
git bisect good dce44e03b0a3448ad11ac6c6e0cbe299e0400791  # 04:14     21+      0  compat: Fix sparse address space warnings
git bisect  bad eb16b5ea273bd7b00f512d7ec3ad6070dd120623  # 04:32      0-     21  Merge branch 'x86/vdso'
git bisect  bad 4e40112c4ff6a577dd06d92b2a54cdf06265bf74  # 05:45      0-      4  x86, vdso32: handle 32 bit vDSO larger one page
# first bad commit: [4e40112c4ff6a577dd06d92b2a54cdf06265bf74] x86, vdso32: handle 32 bit vDSO larger one page
git bisect good 008cc907de327d83a0be609cd495fccb0e5dfa4c  # 05:49     63+      0  x86, vdso32: Disable stack protector, adjust optimizations
git bisect  bad a654dc797f3ea1cb5719a71a17af35f57fddb2d8  # 05:49      0-     19  Add linux-next specific files for 20140320
git bisect good 08edb33c4e1b810011f21d7705811b7b9a0535f0  # 06:29     63+     10  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux
git bisect  bad 06ed26d1de59ce7cbbe68378b7e470be169750e5  # 06:55      0-      1  Add linux-next specific files for 20140321

Thanks,
Fengguang

--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-jaketown-13:20140321125932:i386-randconfig-ba1-03211237::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc7-next-20140320-10753-ga654dc7 (kbuil=
d@bay) (gcc version 4.8.2 (Debian 4.8.2-16) ) #1 PREEMPT Fri Mar 21 12:47:2=
7 CST 2014
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
[    0.000000] Base memory trampoline at [7809b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
[    0.000000]  [mem 0x0e000000-0x0e3fffff] page 4k
[    0.000000] BRK [0x01bf7000, 0x01bf7fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
[    0.000000]  [mem 0x08000000-0x0dffffff] page 4k
[    0.000000] BRK [0x01bf8000, 0x01bf8fff] PGTABLE
[    0.000000] BRK [0x01bf9000, 0x01bf9fff] PGTABLE
[    0.000000] BRK [0x01bfa000, 0x01bfafff] PGTABLE
[    0.000000] BRK [0x01bfb000, 0x01bfbfff] PGTABLE
[    0.000000] BRK [0x01bfc000, 0x01bfcfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x07ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
[    0.000000]  [mem 0x0e400000-0x0fffdfff] page 4k
[    0.000000] cma: dma_contiguous_reserve(limit 00000000)
[    0.000000] cma: dma_contiguous_reserve: reserving 25 MiB for global area
[    0.000000] cma: dma_contiguous_reserve_area(size 198f000, base 00000000=
, limit 00000000)
[    0.000000] cma: CMA: reserved 28 MiB at 0c400000
[    0.000000] RAMDISK: [mem 0x0e7ab000-0x0ffeffff]
[    0.000000] ACPI: RSDP 0x000FD950 000014 (v00 BOCHS )
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
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
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
[    0.000000] free_area_init_node: node 0, pgdat 79724170, node_mem_map 86=
52b028
[    0.000000]   DMA zone: 40 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 600 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] Using ACPI for processor (LAPIC) configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1587bc0
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64796
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/i386-randconfig-ba1-03211237/next:m=
aster/.vmlinuz-a654dc797f3ea1cb5719a71a17af35f57fddb2d8-20140321125150-3-ja=
ketown branch=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randconfig-ba1-032112=
37/a654dc797f3ea1cb5719a71a17af35f57fddb2d8/vmlinuz-3.14.0-rc7-next-2014032=
0-10753-ga654dc7 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 192860K/261744K available (3159K kernel code, 1806K =
rwdata, 2420K rodata, 352K init, 4464K bss, 68884K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe2000 - 0xfffff000   ( 116 kB)
[    0.000000]     vmalloc : 0x887fe000 - 0xfffe0000   (1911 MB)
[    0.000000]     lowmem  : 0x78000000 - 0x87ffe000   ( 255 MB)
[    0.000000]       .init : 0x79739000 - 0x79791000   ( 352 kB)
[    0.000000]       .data : 0x79316244 - 0x797378c0   (4229 kB)
[    0.000000]       .text : 0x79000000 - 0x79316244   (3160 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D1, =
Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3D84006000 soft=3D84008000
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc7-next-20140320-10753-ga654dc7 (kbuil=
d@bay) (gcc version 4.8.2 (Debian 4.8.2-16) ) #1 PREEMPT Fri Mar 21 12:47:2=
7 CST 2014
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
[    0.000000] Base memory trampoline at [7809b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
[    0.000000]  [mem 0x0e000000-0x0e3fffff] page 4k
[    0.000000] BRK [0x01bf7000, 0x01bf7fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
[    0.000000]  [mem 0x08000000-0x0dffffff] page 4k
[    0.000000] BRK [0x01bf8000, 0x01bf8fff] PGTABLE
[    0.000000] BRK [0x01bf9000, 0x01bf9fff] PGTABLE
[    0.000000] BRK [0x01bfa000, 0x01bfafff] PGTABLE
[    0.000000] BRK [0x01bfb000, 0x01bfbfff] PGTABLE
[    0.000000] BRK [0x01bfc000, 0x01bfcfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x07ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
[    0.000000]  [mem 0x0e400000-0x0fffdfff] page 4k
[    0.000000] cma: dma_contiguous_reserve(limit 00000000)
[    0.000000] cma: dma_contiguous_reserve: reserving 25 MiB for global area
[    0.000000] cma: dma_contiguous_reserve_area(size 198f000, base 00000000=
, limit 00000000)
[    0.000000] cma: CMA: reserved 28 MiB at 0c400000
[    0.000000] RAMDISK: [mem 0x0e7ab000-0x0ffeffff]
[    0.000000] ACPI: RSDP 0x000FD950 000014 (v00 BOCHS )
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
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
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
[    0.000000] free_area_init_node: node 0, pgdat 79724170, node_mem_map 86=
52b028
[    0.000000]   DMA zone: 40 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 600 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] Using ACPI for processor (LAPIC) configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1587bc0
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64796
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/i386-randconfig-ba1-03211237/next:m=
aster/.vmlinuz-a654dc797f3ea1cb5719a71a17af35f57fddb2d8-20140321125150-3-ja=
ketown branch=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randconfig-ba1-032112=
37/a654dc797f3ea1cb5719a71a17af35f57fddb2d8/vmlinuz-3.14.0-rc7-next-2014032=
0-10753-ga654dc7 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 192860K/261744K available (3159K kernel code, 1806K =
rwdata, 2420K rodata, 352K init, 4464K bss, 68884K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe2000 - 0xfffff000   ( 116 kB)
[    0.000000]     vmalloc : 0x887fe000 - 0xfffe0000   (1911 MB)
[    0.000000]     lowmem  : 0x78000000 - 0x87ffe000   ( 255 MB)
[    0.000000]       .init : 0x79739000 - 0x79791000   ( 352 kB)
[    0.000000]       .data : 0x79316244 - 0x797378c0   (4229 kB)
[    0.000000]       .text : 0x79000000 - 0x79316244   (3160 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D1, =
Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3D84006000 soft=3D84008000
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
[    0.000000]  memory used by lock dependency info: 3807 kB
[    0.000000]  memory used by lock dependency info: 3807 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000]  per task-struct memory footprint: 1920 bytes
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
[    0.000000]            spinlock nest unlocked:  ok  |  ok  |

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
[    0.000000] 141 out of 253 testcases failed, as expected. |
[    0.000000] 141 out of 253 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] ----------------------------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 1600.074 MHz processor
[    0.000000] tsc: Detected 1600.074 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value..=20
[    0.020000] Calibrating delay loop (skipped) preset value.. 3200.14 Bogo=
MIPS (lpj=3D16000740)
3200.14 BogoMIPS (lpj=3D16000740)
[    0.022261] pid_max: default: 4096 minimum: 301
[    0.022261] pid_max: default: 4096 minimum: 301
[    0.025677] ACPI: Core revision 20140214
[    0.025677] ACPI: Core revision 20140214
[    0.036889] ACPI:=20
[    0.036889] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.040262] ACPI: setting ELCR to 0200 (from 0c00)
[    0.040262] ACPI: setting ELCR to 0200 (from 0c00)
[    0.044264] Security Framework initialized
[    0.044264] Security Framework initialized
[    0.047469] Yama: becoming mindful.
[    0.047469] Yama: becoming mindful.
[    0.050101] Mount-cache hash table entries: 512
[    0.050101] Mount-cache hash table entries: 512
[    0.054164] Initializing cgroup subsys debug
[    0.054164] Initializing cgroup subsys debug
[    0.057549] Initializing cgroup subsys devices
[    0.057549] Initializing cgroup subsys devices
[    0.060049] Initializing cgroup subsys freezer
[    0.060049] Initializing cgroup subsys freezer
[    0.063322] Initializing cgroup subsys net_cls
[    0.063322] Initializing cgroup subsys net_cls
[    0.066762] Initializing cgroup subsys hugetlb
[    0.066762] Initializing cgroup subsys hugetlb
[    0.070231] mce: CPU supports 10 MCE banks
[    0.070231] mce: CPU supports 10 MCE banks
[    0.073437] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.073437] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.073437] tlb_flushall_shift: 6
[    0.073437] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.073437] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.073437] tlb_flushall_shift: 6
[    0.080023] CPU:=20
[    0.080023] CPU: Intel Intel Common KVM processorCommon KVM processor (f=
am: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.094922] Performance Events:=20
[    0.094922] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.108457] Getting VERSION: 50014
[    0.108457] Getting VERSION: 50014
[    0.110045] Getting VERSION: 50014
[    0.110045] Getting VERSION: 50014
[    0.112559] Getting ID: 0
[    0.112559] Getting ID: 0
[    0.114489] Getting ID: f000000
[    0.114489] Getting ID: f000000
[    0.116837] Getting LVT0: 8700
[    0.116837] Getting LVT0: 8700
[    0.120081] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.120081] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.125444] Getting LVT1: 8400
[    0.125444] Getting LVT1: 8400
[    0.127950] enabled ExtINT on CPU#0
[    0.127950] enabled ExtINT on CPU#0
[    0.130129] Using local APIC timer interrupts.
[    0.130129] calibrating APIC timer ...
[    0.130129] Using local APIC timer interrupts.
[    0.130129] calibrating APIC timer ...
[    0.140000] ... lapic delta =3D 7997832
[    0.140000] ... lapic delta =3D 7997832
[    0.140000] ... PM-Timer delta =3D 458133
[    0.140000] ... PM-Timer delta =3D 458133
[    0.140000] APIC calibration not consistent with PM-Timer: 127ms instead=
 of 100ms
[    0.140000] APIC calibration not consistent with PM-Timer: 127ms instead=
 of 100ms
[    0.140000] APIC delta adjusted to PM-Timer: 6248962 (7997832)
[    0.140000] APIC delta adjusted to PM-Timer: 6248962 (7997832)
[    0.140000] TSC delta adjusted to PM-Timer: 159996544 (204774069)
[    0.140000] TSC delta adjusted to PM-Timer: 159996544 (204774069)
[    0.140000] ..... delta 6248962
[    0.140000] ..... delta 6248962
[    0.140000] ..... mult: 268390874
[    0.140000] ..... mult: 268390874
[    0.140000] ..... calibration result: 9998339
[    0.140000] ..... calibration result: 9998339
[    0.140000] ..... CPU clock speed is 1599.9654 MHz.
[    0.140000] ..... CPU clock speed is 1599.9654 MHz.
[    0.140000] ..... host bus clock speed is 999.8339 MHz.
[    0.140000] ..... host bus clock speed is 999.8339 MHz.
[    0.142808] atomic64 test passed for i386+ platform with CX8 and with SSE
[    0.142808] atomic64 test passed for i386+ platform with CX8 and with SSE
[    0.150891] regulator-dummy: no parameters
[    0.150891] regulator-dummy: no parameters
[    0.162194] NET: Registered protocol family 16
[    0.162194] NET: Registered protocol family 16
[    0.171363] cpuidle: using governor ladder
[    0.171363] cpuidle: using governor ladder
[    0.180018] cpuidle: using governor menu
[    0.180018] cpuidle: using governor menu
[    0.183595] ACPI: bus type PCI registered
[    0.183595] ACPI: bus type PCI registered
[    0.190149] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.190149] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.194691] PCI: Using configuration type 1 for base access
[    0.194691] PCI: Using configuration type 1 for base access
[    0.226392] ACPI: Added _OSI(Module Device)
[    0.226392] ACPI: Added _OSI(Module Device)
[    0.229415] ACPI: Added _OSI(Processor Device)
[    0.229415] ACPI: Added _OSI(Processor Device)
[    0.230018] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.230018] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.233375] ACPI: Added _OSI(Processor Aggregator Device)
[    0.233375] ACPI: Added _OSI(Processor Aggregator Device)
[    0.266009] ACPI: Interpreter enabled
[    0.266009] ACPI: Interpreter enabled
[    0.268767] ACPI: (supports S0 S5)
[    0.268767] ACPI: (supports S0 S5)
[    0.270016] ACPI: Using PIC for interrupt routing
[    0.270016] ACPI: Using PIC for interrupt routing
[    0.273835] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.273835] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.312807] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.312807] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.317451] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.317451] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.320074] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.320074] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.326197] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.326197] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.330323] PCI host bridge to bus 0000:00
[    0.330323] PCI host bridge to bus 0000:00
[    0.333263] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.333263] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.340019] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.340019] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.344470] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.344470] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.350020] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.350020] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.354990] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.354990] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.360185] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.360185] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.366344] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.366344] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.372306] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.372306] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.388483] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.388483] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.393572] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.393572] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.400018] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.400018] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.404658] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.404658] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.410018] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.410018] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.416238] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.416238] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.421266] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.421266] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.426413] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.426413] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.431367] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.431367] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.442176] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.442176] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.454352] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.454352] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.490208] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.490208] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.497234] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.497234] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.503385] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.503385] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.513291] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.513291] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.533276] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.533276] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.541246] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.541246] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.547356] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.547356] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.566989] pci_bus 0000:00: on NUMA node 0
[    0.566989] pci_bus 0000:00: on NUMA node 0
[    0.572428] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.572428] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.577351] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.577351] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.581589] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.581589] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.590272] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.590272] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.594896] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.594896] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.600914] ACPI:=20
[    0.600914] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    0.611757] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.611757] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.617653] vgaarb: loaded
[    0.617653] vgaarb: loaded
[    0.619715] vgaarb: bridge control possible 0000:00:02.0
[    0.619715] vgaarb: bridge control possible 0000:00:02.0
[    0.621885] ACPI: bus type USB registered
[    0.621885] ACPI: bus type USB registered
[    0.625135] usbcore: registered new interface driver usbfs
[    0.625135] usbcore: registered new interface driver usbfs
[    0.630166] usbcore: registered new interface driver hub
[    0.630166] usbcore: registered new interface driver hub
[    0.634504] usbcore: registered new device driver usb
[    0.634504] usbcore: registered new device driver usb
[    0.640874] pps_core: LinuxPPS API ver. 1 registered
[    0.640874] pps_core: LinuxPPS API ver. 1 registered
[    0.644407] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.644407] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.650064] PTP clock support registered
[    0.650064] PTP clock support registered
[    0.652970] EDAC MC: Ver: 3.0.0
[    0.652970] EDAC MC: Ver: 3.0.0
[    0.656012] EDAC DEBUG: edac_mc_sysfs_init: device mc created
[    0.656012] EDAC DEBUG: edac_mc_sysfs_init: device mc created
[    0.660523] PCI: Using ACPI for IRQ routing
[    0.660523] PCI: Using ACPI for IRQ routing
[    0.663546] PCI: pci_cache_line_size set to 64 bytes
[    0.663546] PCI: pci_cache_line_size set to 64 bytes
[    0.667533] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.667533] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.670064] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.670064] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.675770] irda_init()
[    0.675770] irda_init()
[    0.680221] NET: Registered protocol family 23
[    0.680221] NET: Registered protocol family 23
[    0.684387] Switched to clocksource kvm-clock
[    0.684387] Switched to clocksource kvm-clock
[    0.688149] pnp: PnP ACPI init
[    0.688149] pnp: PnP ACPI init
[    0.690000] ACPI: bus type PNP registered
[    0.690000] ACPI: bus type PNP registered
[    0.690000] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.690000] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.694681] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.694681] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.699635] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.699635] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.704645] pnp 00:03: [dma 2]
[    0.704645] pnp 00:03: [dma 2]
[    0.707026] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.707026] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.712117] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.712117] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.717145] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.717145] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.723381] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.723381] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.728731] pnp: PnP ACPI: found 7 devices
[    0.728731] pnp: PnP ACPI: found 7 devices
[    0.731843] ACPI: bus type PNP unregistered
[    0.731843] ACPI: bus type PNP unregistered
[    0.771551] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.771551] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.775508] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.775508] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.779433] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.779433] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.784006] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.784006] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.788484] NET: Registered protocol family 1
[    0.788484] NET: Registered protocol family 1
[    0.791712] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.791712] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.795931] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.795931] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.800155] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.800155] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.807460] pci 0000:00:02.0: Boot video device
[    0.807460] pci 0000:00:02.0: Boot video device
[    0.810867] PCI: CLS 0 bytes, default 64
[    0.810867] PCI: CLS 0 bytes, default 64
[    0.815099] Unpacking initramfs...
[    0.815099] Unpacking initramfs...
[    6.296730] debug: unmapping init [mem 0x867ab000-0x87feffff]
[    6.296730] debug: unmapping init [mem 0x867ab000-0x87feffff]
[    6.306870] futex hash table entries: 16 (order: -3, 768 bytes)
[    6.306870] futex hash table entries: 16 (order: -3, 768 bytes)
[    6.374455] Kprobe smoke test started
[    6.374455] Kprobe smoke test started
[    6.410545] Kprobe smoke test passed successfully
[    6.410545] Kprobe smoke test passed successfully
[    6.414758] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    6.414758] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    6.450342] ROMFS MTD (C) 2007 Red Hat, Inc.
[    6.450342] ROMFS MTD (C) 2007 Red Hat, Inc.
[    6.453892] msgmni has been set to 432
[    6.453892] msgmni has been set to 432
[    6.472272] alg: No test for lz4 (lz4-generic)
[    6.472272] alg: No test for lz4 (lz4-generic)
[    6.476255] alg: No test for stdrng (krng)
[    6.476255] alg: No test for stdrng (krng)
[    6.523547] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    6.523547] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    6.550407] crc32: CRC_LE_BITS =3D 8, CRC_BE BITS =3D 8
[    6.550407] crc32: CRC_LE_BITS =3D 8, CRC_BE BITS =3D 8
[    6.553930] crc32: self tests passed, processed 225944 bytes in 8548844 =
nsec
[    6.553930] crc32: self tests passed, processed 225944 bytes in 8548844 =
nsec
[    6.571255] crc32c: CRC_LE_BITS =3D 8
[    6.571255] crc32c: CRC_LE_BITS =3D 8
[    6.576047] crc32c: self tests passed, processed 225944 bytes in 899152 =
nsec
[    6.576047] crc32c: self tests passed, processed 225944 bytes in 899152 =
nsec
[    7.300248] tsc: Refined TSC clocksource calibration: 1599.922 MHz
[    7.300248] tsc: Refined TSC clocksource calibration: 1599.922 MHz
[    7.609505] crc32_combine: 8373 self tests passed
[    7.609505] crc32_combine: 8373 self tests passed
[    8.400722] crc32c_combine: 8373 self tests passed
[    8.400722] crc32c_combine: 8373 self tests passed
[    8.405829] usbcore: registered new interface driver smscufx
[    8.405829] usbcore: registered new interface driver smscufx
[    8.410558] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    8.410558] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    8.415434] ACPI: Power Button [PWRF]
[    8.415434] ACPI: Power Button [PWRF]
[    8.479057] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    8.479057] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    8.513674] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    8.513674] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    8.523768] Non-volatile memory driver v1.3
[    8.523768] Non-volatile memory driver v1.3
[    8.529413] toshiba: not a supported Toshiba laptop
[    8.529413] toshiba: not a supported Toshiba laptop
[    8.535743] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    8.535743] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    8.545900] platform pc8736x_gpio.0: no device found
[    8.545900] platform pc8736x_gpio.0: no device found
[    8.549414] nsc_gpio initializing
[    8.549414] nsc_gpio initializing
[    8.552167] [drm] Initialized drm 1.1.0 20060810
[    8.552167] [drm] Initialized drm 1.1.0 20060810
[    8.555703] dummy-irq: no IRQ given.  Use irq=3DN
[    8.555703] dummy-irq: no IRQ given.  Use irq=3DN
[    8.559089] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    8.559089] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    8.566559] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    8.566559] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    8.571182] slram: not enough parameters.
[    8.571182] slram: not enough parameters.
[    8.595123] libphy: Fixed MDIO Bus: probed
[    8.595123] libphy: Fixed MDIO Bus: probed
[    8.599618] usbcore: registered new interface driver kingsun-sir
[    8.599618] usbcore: registered new interface driver kingsun-sir
[    8.604209] usbcore: registered new interface driver ksdazzle-sir
[    8.604209] usbcore: registered new interface driver ksdazzle-sir
[    8.610342] hdlc: HDLC support module revision 1.22
[    8.610342] hdlc: HDLC support module revision 1.22
[    8.613827] usbcore: registered new interface driver catc
[    8.613827] usbcore: registered new interface driver catc
[    8.617675] usbcore: registered new interface driver kaweth
[    8.617675] usbcore: registered new interface driver kaweth
[    8.621669] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[    8.621669] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[    8.626750] usbcore: registered new interface driver pegasus
[    8.626750] usbcore: registered new interface driver pegasus
[    8.630620] usbcore: registered new interface driver rtl8150
[    8.630620] usbcore: registered new interface driver rtl8150
[    8.634586] usbcore: registered new interface driver ax88179_178a
[    8.634586] usbcore: registered new interface driver ax88179_178a
[    8.640545] usbcore: registered new interface driver cdc_eem
[    8.640545] usbcore: registered new interface driver cdc_eem
[    8.647664] usbcore: registered new interface driver sr9700
[    8.647664] usbcore: registered new interface driver sr9700
[    8.654968] usbcore: registered new interface driver gl620a
[    8.654968] usbcore: registered new interface driver gl620a
[    8.662165] usbcore: registered new interface driver cdc_ncm
[    8.662165] usbcore: registered new interface driver cdc_ncm
[    8.668593] usbcore: registered new interface driver huawei_cdc_ncm
[    8.668593] usbcore: registered new interface driver huawei_cdc_ncm
[    8.679403] usbcore: registered new interface driver cdc_mbim
[    8.679403] usbcore: registered new interface driver cdc_mbim
[    8.688783] usbcore: registered new interface driver usblp
[    8.688783] usbcore: registered new interface driver usblp
[    8.696827] usbcore: registered new interface driver cdc_wdm
[    8.696827] usbcore: registered new interface driver cdc_wdm
[    8.703797] usbcore: registered new interface driver mdc800
[    8.703797] usbcore: registered new interface driver mdc800
[    8.708394] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    8.708394] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    8.714769] usbcore: registered new interface driver appledisplay
[    8.714769] usbcore: registered new interface driver appledisplay
[    8.719635] usbcore: registered new interface driver cypress_cy7c63
[    8.719635] usbcore: registered new interface driver cypress_cy7c63
[    8.724236] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    8.724236] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    8.729651] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    8.729651] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    8.735124] usbcore: registered new interface driver iowarrior
[    8.735124] usbcore: registered new interface driver iowarrior
[    8.739212] usbcore: registered new interface driver isight_firmware
[    8.739212] usbcore: registered new interface driver isight_firmware
[    8.743918] usbcore: registered new interface driver ldusb
[    8.743918] usbcore: registered new interface driver ldusb
[    8.748078] usbcore: registered new interface driver usbtest
[    8.748078] usbcore: registered new interface driver usbtest
[    8.752399] usbcore: registered new interface driver usbsevseg
[    8.752399] usbcore: registered new interface driver usbsevseg
[    8.757523] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    8.757523] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    8.765506] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.765506] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.770183] serio: i8042 AUX port at 0x60,0x64 irq 12
[    8.770183] serio: i8042 AUX port at 0x60,0x64 irq 12
[    8.776092] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    8.776092] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    8.784014] i2c /dev entries driver
[    8.784014] i2c /dev entries driver
[    8.786736] usbcore: registered new interface driver RobotFuzz Open Sour=
ce InterFace, OSIF
[    8.786736] usbcore: registered new interface driver RobotFuzz Open Sour=
ce InterFace, OSIF
[    8.794204] usbcore: registered new interface driver i2c-tiny-usb
[    8.794204] usbcore: registered new interface driver i2c-tiny-usb
[    8.798776] Driver for 1-wire Dallas network protocol.
[    8.798776] Driver for 1-wire Dallas network protocol.
[    8.802904] usbcore: registered new interface driver DS9490R
[    8.802904] usbcore: registered new interface driver DS9490R
[    8.807023] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    8.807023] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    8.811771] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    8.811771] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    8.822927] pc87360: PC8736x not detected, module not inserted
[    8.822927] pc87360: PC8736x not detected, module not inserted
[    8.838694] beceem: Beceem Communications Inc. WiMAX driver, 5.2.45
[    8.838694] beceem: Beceem Communications Inc. WiMAX driver, 5.2.45
[    8.847061] Copyright 2010. Beceem Communications Inc
[    8.847061] Copyright 2010. Beceem Communications Inc
[    8.851316] usbcore: registered new interface driver usbbcm
[    8.851316] usbcore: registered new interface driver usbbcm
[    8.855938] FPGA DOWNLOAD --->
[    8.855938] FPGA DOWNLOAD --->
[    8.862442] built at Fri Mar 21 12:37:53 2014 UTC
[    8.862442] built at Fri Mar 21 12:37:53 2014 UTC
[    8.865896] FPGA image file name: xlinx_fpga_firmware.bit
[    8.865896] FPGA image file name: xlinx_fpga_firmware.bit
[    8.878144] GPIO INIT FAIL!!
[    8.878144] GPIO INIT FAIL!!
[    8.880592] intel_rapl: driver does not support CPU family 15 model 6
[    8.880592] intel_rapl: driver does not support CPU family 15 model 6
[    8.893213] NET: Registered protocol family 26
[    8.893213] NET: Registered protocol family 26
[    8.896366] NET: Registered protocol family 5
[    8.896366] NET: Registered protocol family 5
[    8.903601] NET: Registered protocol family 9
[    8.903601] NET: Registered protocol family 9
[    8.910730] X25: Linux Version 0.2
[    8.910730] X25: Linux Version 0.2
[    8.912978] can: controller area network core (rev 20120528 abi 9)
[    8.912978] can: controller area network core (rev 20120528 abi 9)
[    8.925440] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
[    8.925440] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
[    8.934284] NET: Registered protocol family 29
[    8.934284] NET: Registered protocol family 29
[    8.943969] can: raw protocol (rev 20120528)
[    8.943969] can: raw protocol (rev 20120528)
[    8.951853] can: broadcast manager protocol (rev 20120528 t)
[    8.951853] can: broadcast manager protocol (rev 20120528 t)
[    8.965584] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[    8.965584] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[    8.989574] DECnet: Routing cache hash table of 256 buckets, 11Kbytes
[    8.989574] DECnet: Routing cache hash table of 256 buckets, 11Kbytes
[    9.010728] NET: Registered protocol family 12
[    9.010728] NET: Registered protocol family 12
[    9.021110] 9pnet: Installing 9P2000 support
[    9.021110] 9pnet: Installing 9P2000 support
[    9.024370] openvswitch: Open vSwitch switching datapath
[    9.024370] openvswitch: Open vSwitch switching datapath
[    9.030247] Using IPI Shortcut mode
[    9.030247] Using IPI Shortcut mode
[    9.044665] bootconsole [earlyser0] disabled
[    9.044665] bootconsole [earlyser0] disabled
[    9.048366] ima: No TPM chip found, activating TPM-bypass!
[    9.051985] ima: Can not allocate sha256 (reason: -2)
[    9.056024] ### dt-test ### No testcase data in device tree; not running=
 tests
[    9.080438] debug: unmapping init [mem 0x79739000-0x79790fff]
[    9.082728] Write protecting the kernel text: 3164k
[    9.084801] Write protecting the kernel read-only data: 2420k
[    9.188668] random: init urandom read with 0 bits of entropy available
[    9.196432] page:8670b3e8 count:0 mapcount:1 mapping:  (null) index:0x0
[    9.199071] page flags: 0x40008004(referenced|tail)
[    9.216380] ------------[ cut here ]------------
[    9.218008] kernel BUG at mm/swap.c:134!
[    9.220257] invalid opcode: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
[    9.222817] Modules linked in:
[    9.224080] CPU: 0 PID: 69 Comm: init Not tainted 3.14.0-rc7-next-201403=
20-10753-ga654dc7 #1
[    9.225460] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    9.225460] task: 7ef39880 ti: 78a02000 task.ti: 78a02000
[    9.225460] EIP: 0060:[<7907ae36>] EFLAGS: 00010246 CPU: 0
[    9.225460] EIP is at put_compound_page+0x7d/0x1da
[    9.225460] EAX: 795143df EBX: 8670b3c0 ECX: 7904b884 EDX: 00000001
[    9.225460] ESI: 8670b3e8 EDI: ffffffff EBP: 78a03d40 ESP: 78a03d34
[    9.225460]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    9.225460] CR0: 8005003b CR2: 77bd1f38 CR3: 00a05000 CR4: 000006d0
[    9.225460] Stack:
[    9.225460]  8670b3e8 00000000 ffffffff 78a03d78 7907b036 00000001 78a03=
d64 00000000
[    9.225460]  000000e1 78a0700c 00000246 00000092 865509a4 8654e26c 78a07=
000 78a03db0
[    9.225460]  78a03dc4 78a03d8c 79086cb7 78a03db0 78960280 00000000 78a03=
d9c 79086cd8
[    9.225460] Call Trace:
[    9.225460]  [<7907b036>] release_pages+0x58/0x175
[    9.225460]  [<79086cb7>] tlb_flush_mmu+0x30/0x45
[    9.225460]  [<79086cd8>] tlb_finish_mmu+0xc/0x2b
[    9.225460]  [<7908cab1>] exit_mmap+0x84/0xcb
[    9.225460]  [<79025a31>] mmput+0x2c/0xb1
[    9.225460]  [<790a2c79>] flush_old_exec+0x4af/0x564
[    9.225460]  [<790c3030>] load_elf_binary+0x272/0xb86
[    9.225460]  [<790a2220>] search_binary_handler+0x5f/0x145
[    9.225460]  [<790c2c06>] load_script+0x17a/0x183
[    9.225460]  [<79041c35>] ? sched_clock_cpu+0xaa/0xd3
[    9.225460]  [<790482bd>] ? lock_release+0x13c/0x19a
[    9.225460]  [<79311444>] ? _raw_read_unlock+0x27/0x38
[    9.225460]  [<790a2220>] search_binary_handler+0x5f/0x145
[    9.225460]  [<790a32eb>] do_execve+0x371/0x47c
[    9.225460]  [<790a354a>] SyS_execve+0x1c/0x20
[    9.225460]  [<793154d5>] sysenter_do_call+0x12/0x37
[    9.225460] Code: 0f 84 a3 00 00 00 89 d8 e8 73 fc ff ff 85 c0 75 0b 31 =
d2 89 d8 e8 f5 c5 ff ff 0f 0b 8b 46 0c 40 74 0b 31 d2 89 f0 e8 e4 c5 ff ff =
<0f> 0b 89 d8 e8 e5 fc ff ff 85 c0 0f 84 47 01 00 00 8b 03 a8 80
[    9.225460] EIP: [<7907ae36>] put_compound_page+0x7d/0x1da SS:ESP 0068:7=
8a03d34
[    9.379006] ---[ end trace cdeaef9772248ae3 ]---

Elapsed time: 20
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-b=
a1-03211237/a654dc797f3ea1cb5719a71a17af35f57fddb2d8/vmlinuz-3.14.0-rc7-nex=
t-20140320-10753-ga654dc7 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,=
115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeo=
ut=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdi=
sk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0=
 rw link=3D/kernel-tests/run-queue/kvm/i386-randconfig-ba1-03211237/next:ma=
ster/.vmlinuz-a654dc797f3ea1cb5719a71a17af35f57fddb2d8-20140321125150-3-jak=
etown branch=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randconfig-ba1-0321123=
7/a654dc797f3ea1cb5719a71a17af35f57fddb2d8/vmlinuz-3.14.0-rc7-next-20140320=
-10753-ga654dc7 drbd.minor_count=3D8'  -initrd /kernel-tests/initrd/quantal=
-core-i386.cgz -m 256 -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=
=3D1,hostfwd=3Dtcp::10709-:22 -boot order=3Dnc -no-reboot -watchdog i6300es=
b -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-quantal-jaketown-13 -se=
rial file:/dev/shm/kboot/serial-quantal-jaketown-13 -daemonize -display non=
e -monitor null=20

--pWyiEgJYm5f9v55/
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-ba1-03211237-a654dc797f3ea1cb5719a71a17af35f57fddb2d8-kernel-BUG-at-mm-swap-c-130558.log"
Content-Transfer-Encoding: base64

Tm8gcGF0Y2ggcmVtb3ZlZApnaXQgY2hlY2tvdXQgMDE2MzE5ZDM3NWMwMGRiNDBkYWMxNjVm
Y2RhZWM3OGI2NzA5NDI0MwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4
Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy9uZXh0Om1hc3RlcjowMTYzMTlkMzc1YzAwZGI0
MGRhYzE2NWZjZGFlYzc4YjY3MDk0MjQzOmJpc2VjdC1zb3VuZAoKMjAxNC0wMy0yMS0xMzo0
NDo1MyAwMTYzMTlkMzc1YzAwZGI0MGRhYzE2NWZjZGFlYzc4YjY3MDk0MjQzIGNvbXBpbGlu
ZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYt
cmFuZGNvbmZpZy1iYTEtMDMyMTEyMzctMDE2MzE5ZDM3NWMwMGRiNDBkYWMxNjVmY2RhZWM3
OGI2NzA5NDI0MwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWJhMS0wMzIxMTIzNy8wMTYzMTlkMzc1YzAwZGI0MGRhYzE2NWZjZGFlYzc4YjY3MDk0MjQz
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9p
Mzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LTAxNjMxOWQzNzVjMDBkYjQwZGFjMTY1ZmNk
YWVjNzhiNjcwOTQyNDMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3Rz
L2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LTAxNjMxOWQzNzVj
MDBkYjQwZGFjMTY1ZmNkYWVjNzhiNjcwOTQyNDMKa2VybmVsOiAva2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1iYTEtMDMyMTEyMzcvMDE2MzE5ZDM3NWMwMGRiNDBkYWMxNjVmY2RhZWM3OGI2
NzA5NDI0My92bWxpbnV6LTMuMTQuMC1yYzctMTAyOTAtZzAxNjMxOWQKCjIwMTQtMDMtMjEt
MTQ6MDA6NTQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTIgVEVTVCBGQUlMVVJFClsgICAgMi43
MDcwODhdIHBhZ2U6OGE3MDE1MjggY291bnQ6MCBtYXBjb3VudDoxIG1hcHBpbmc6ICAobnVs
bCkgaW5kZXg6MHgwClsgICAgMi43MDc3ODZdIHBhZ2UgZmxhZ3M6IDB4NDAwMDgwMDQocmVm
ZXJlbmNlZHx0YWlsKQpbICAgIDIuNzA4MzM5XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0t
LS0tLS0tLS0tLS0KWyAgICAyLjcwODgzNF0ga2VybmVsIEJVRyBhdCBtbS9zd2FwLmM6MTM0
IQpbICAgIDIuNzA5NDYzXSBpbnZhbGlkIG9wY29kZTogMDAwMCBbIzFdIFBSRUVNUFQgREVC
VUdfUEFHRUFMTE9DClsgICAgMi43MTAwMTNdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDIu
NzEwMDEzXSBDUFU6IDAgUElEOiA2OCBDb21tOiBpbml0IE5vdCB0YWludGVkIDMuMTQuMC1y
YzctMTAyOTAtZzAxNjMxOWQgIzEKWyAgICAyLjcxMDAxM10gSGFyZHdhcmUgbmFtZTogQm9j
aHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDIuNzEwMDEzXSB0YXNrOiA4
MmIyM2NhMCB0aTogNzgwMzgwMDAgdGFzay50aTogNzgwMzgwMDAKWyAgICAyLjcxMDAxM10g
RUlQOiAwMDYwOls8NzkwN2EzZmM+XSBFRkxBR1M6IDAwMDEwMjQ2IENQVTogMApbICAgIDIu
NzEwMDEzXSBFSVAgaXMgYXQgcHV0X2NvbXBvdW5kX3BhZ2UrMHg3ZC8weDFkYQpbICAgIDIu
NzEwMDEzXSBFQVg6IDc5NTEzNmRlIEVCWDogOGE3MDE1MDAgRUNYOiA3OTA0YjU3YyBFRFg6
IDAwMDAwMDAxClsgICAgMi43MTAwMTNdIEVTSTogOGE3MDE1MjggRURJOiBmZmZmZmZmZiBF
QlA6IDc4MDM5ZDQwIEVTUDogNzgwMzlkMzQKWyAgICAyLjcxMDAxM10gIERTOiAwMDdiIEVT
OiAwMDdiIEZTOiAwMDAwIEdTOiAwMDAwIFNTOiAwMDY4ClsgICAgMi43MTAwMTNdIENSMDog
ODAwNTAwM2IgQ1IyOiA2ZjU2YjQ2MCBDUjM6IDBhN2RkMDAwIENSNDogMDAwMDA2ZDAKWyAg
ICAyLjcxMDAxM10gU3RhY2s6ClsgICAgMi43MTAwMTNdICA4YTcwMTUyOCAwMDAwMDAwMCBm
ZmZmZmZmZiA3ODAzOWQ3OCA3OTA3YTVmYyAwMDAwMDAwMSA3ODAzOWQ2NCAwMDAwMDAwMApb
ICAgIDIuNzEwMDEzXSAgMDAwMDAwNTcgODI3ZGYwMGMgMDAwMDAyNDYgMDAwMDAwMjEgOGE3
NjU0MjQgOGE3NjQ1NGMgODI3ZGYwMDAgNzgwMzlkYjAKWyAgICAyLjcxMDAxM10gIDc4MDM5
ZGM0IDc4MDM5ZDhjIDc5MDg1ZDgyIDc4MDM5ZGIwIDgyN2Q0MjgwIDAwMDAwMDAwIDc4MDM5
ZDljIDc5MDg1ZGEzClsgICAgMi43MTAwMTNdIENhbGwgVHJhY2U6ClsgICAgMi43MTAwMTNd
ICBbPDc5MDdhNWZjPl0gcmVsZWFzZV9wYWdlcysweDU4LzB4MTc1ClsgICAgMi43MTAwMTNd
ICBbPDc5MDg1ZDgyPl0gdGxiX2ZsdXNoX21tdSsweDMwLzB4NDUKWyAgICAyLjcxMDAxM10g
IFs8NzkwODVkYTM+XSB0bGJfZmluaXNoX21tdSsweGMvMHgyYgpbICAgIDIuNzEwMDEzXSAg
Wzw3OTA4YjZjMj5dIGV4aXRfbW1hcCsweDg0LzB4Y2IKWyAgICAyLjcxMDAxM10gIFs8Nzkw
MjU4MWY+XSBtbXB1dCsweDJjLzB4YjEKWyAgICAyLjcxMDAxM10gIFs8NzkwYTE2NDE+XSBm
bHVzaF9vbGRfZXhlYysweDQ5MS8weDU0NgpbICAgIDIuNzEwMDEzXSAgWzw3OTBjMTliMT5d
IGxvYWRfZWxmX2JpbmFyeSsweDI3Mi8weGI5NgpbICAgIDIuNzEwMDEzXSAgWzw3OTBhMGMw
Nj5dIHNlYXJjaF9iaW5hcnlfaGFuZGxlcisweDVmLzB4MTQ1ClsgICAgMi43MTAwMTNdICBb
PDc5MGMxNTg3Pl0gbG9hZF9zY3JpcHQrMHgxN2EvMHgxODMKWyAgICAyLjcxMDAxM10gIFs8
NzkwNDE4NzA+XSA/IHNjaGVkX2Nsb2NrX2NwdSsweGFhLzB4ZDMKWyAgICAyLjcxMDAxM10g
IFs8NzkwNDdmYjA+XSA/IGxvY2tfcmVsZWFzZSsweDEzOC8weDE5MgpbICAgIDIuNzEwMDEz
XSAgWzw3OTMwZmFlND5dID8gX3Jhd19yZWFkX3VubG9jaysweDI3LzB4MzgKWyAgICAyLjcx
MDAxM10gIFs8NzkwYTBjMDY+XSBzZWFyY2hfYmluYXJ5X2hhbmRsZXIrMHg1Zi8weDE0NQpb
ICAgIDIuNzEwMDEzXSAgWzw3OTBhMWNiMz5dIGRvX2V4ZWN2ZSsweDM3MS8weDQ3YwpbICAg
IDIuNzEwMDEzXSAgWzw3OTBhMWYxMj5dIFN5U19leGVjdmUrMHgxYy8weDIwClsgICAgMi43
MTAwMTNdICBbPDc5MzEzYTE1Pl0gc3lzZW50ZXJfZG9fY2FsbCsweDEyLzB4MzcKWyAgICAy
LjcxMDAxM10gQ29kZTogMGYgODQgYTMgMDAgMDAgMDAgODkgZDggZTggODEgZmMgZmYgZmYg
ODUgYzAgNzUgMGIgMzEgZDIgODkgZDggZTggMGEgYzYgZmYgZmYgMGYgMGIgOGIgNDYgMGMg
NDAgNzQgMGIgMzEgZDIgODkgZjAgZTggZjkgYzUgZmYgZmYgPDBmPiAwYiA4OSBkOCBlOCBk
MCBmYyBmZiBmZiA4NSBjMCAwZiA4NCA0NyAwMSAwMCAwMCA4YiAwMyBhOCA4MApbICAgIDIu
NzEwMDEzXSBFSVA6IFs8NzkwN2EzZmM+XSBwdXRfY29tcG91bmRfcGFnZSsweDdkLzB4MWRh
IFNTOkVTUCAwMDY4Ojc4MDM5ZDM0ClsgICAgMi43MzA2OTZdIC0tLVsgZW5kIHRyYWNlIDlm
NmE1Y2VmZDk4OTc5YjIgXS0tLQpbICAgIDIuOTcwMTUxXSB0c2M6IFJlZmluZWQgVFNDIGNs
b2Nrc291cmNlIGNhbGlicmF0aW9uOiAyNDkzLjk2MiBNSHoKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYmExLTAzMjExMjM3LzAxNjMxOWQzNzVjMDBkYjQwZGFjMTY1ZmNkYWVjNzhiNjcw
OTQyNDMvZG1lc2cteW9jdG8taXZ5dG93bjItMjI6MjAxNDAzMjExNDAxMDI6aTM4Ni1yYW5k
Y29uZmlnLWJhMS0wMzIxMTIzNzozLjE0LjAtcmM3LTEwMjkwLWcwMTYzMTlkOjEKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LzAxNjMxOWQzNzVjMDBkYjQwZGFjMTY1
ZmNkYWVjNzhiNjcwOTQyNDMvZG1lc2cteW9jdG8teHBzLTE6MjAxNDAzMjExNDAxMDI6aTM4
Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNzozLjE0LjAtcmM3LTEwMjkwLWcwMTYzMTlkOjEK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LzAxNjMxOWQzNzVjMDBkYjQw
ZGFjMTY1ZmNkYWVjNzhiNjcwOTQyNDMvZG1lc2cteW9jdG8taXZ5dG93bjItMzoyMDE0MDMy
MTE0MDEwNTppMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3OjMuMTQuMC1yYzctMTAyOTAt
ZzAxNjMxOWQ6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvMDE2MzE5
ZDM3NWMwMGRiNDBkYWMxNjVmY2RhZWM3OGI2NzA5NDI0My9kbWVzZy1xdWFudGFsLWl2eXRv
d24yLTE2OjIwMTQwMzIxMTQwMTA4OmkzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzc6My4x
NC4wLXJjNy0xMDI5MC1nMDE2MzE5ZDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0w
MzIxMTIzNy8wMTYzMTlkMzc1YzAwZGI0MGRhYzE2NWZjZGFlYzc4YjY3MDk0MjQzL2RtZXNn
LXF1YW50YWwtaXZ5dG93bjItNDoyMDE0MDMyMTE0MDExNDppMzg2LXJhbmRjb25maWctYmEx
LTAzMjExMjM3OjMuMTQuMC1yYzctMTAyOTAtZzAxNjMxOWQ6MQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1iYTEtMDMyMTEyMzcvMDE2MzE5ZDM3NWMwMGRiNDBkYWMxNjVmY2RhZWM3OGI2
NzA5NDI0My9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTY6MjAxNDAzMjExNDAxMDg6aTM4Ni1y
YW5kY29uZmlnLWJhMS0wMzIxMTIzNzozLjE0LjAtcmM3LTEwMjkwLWcwMTYzMTlkOjEKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LzAxNjMxOWQzNzVjMDBkYjQwZGFj
MTY1ZmNkYWVjNzhiNjcwOTQyNDMvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi05OjIwMTQwMzIx
MTQwMTA5OmkzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzc6My4xNC4wLXJjNy0xMDI5MC1n
MDE2MzE5ZDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy8wMTYzMTlk
Mzc1YzAwZGI0MGRhYzE2NWZjZGFlYzc4YjY3MDk0MjQzL2RtZXNnLXlvY3RvLWl2eXRvd24y
LTEyOjIwMTQwMzIxMTQwMTEzOmkzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzc6My4xNC4w
LXJjNy0xMDI5MC1nMDE2MzE5ZDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIx
MTIzNy8wMTYzMTlkMzc1YzAwZGI0MGRhYzE2NWZjZGFlYzc4YjY3MDk0MjQzL2RtZXNnLXlv
Y3RvLWl2eXRvd24yLTEzOjIwMTQwMzIxMTQwMTExOmkzODYtcmFuZGNvbmZpZy1iYTEtMDMy
MTEyMzc6My4xNC4wLXJjNy0xMDI5MC1nMDE2MzE5ZDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWJhMS0wMzIxMTIzNy8wMTYzMTlkMzc1YzAwZGI0MGRhYzE2NWZjZGFlYzc4YjY3MDk0
MjQzL2RtZXNnLXlvY3RvLWl2eXRvd24yLTI4OjIwMTQwMzIxMTQwMTA4OmkzODYtcmFuZGNv
bmZpZy1iYTEtMDMyMTEyMzc6My4xNC4wLXJjNy0xMDI5MC1nMDE2MzE5ZDoxCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy8wMTYzMTlkMzc1YzAwZGI0MGRhYzE2NWZj
ZGFlYzc4YjY3MDk0MjQzL2RtZXNnLXlvY3RvLWl2eXRvd24yLTMwOjIwMTQwMzIxMTQwMTEw
OmkzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzc6My4xNC4wLXJjNy0xMDI5MC1nMDE2MzE5
ZDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy8wMTYzMTlkMzc1YzAw
ZGI0MGRhYzE2NWZjZGFlYzc4YjY3MDk0MjQzL2RtZXNnLXlvY3RvLWl2eXRvd24yLTM6MjAx
NDAzMjExNDAxMTQ6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNzozLjE0LjAtcmM3LTEw
MjkwLWcwMTYzMTlkOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LzAx
NjMxOWQzNzVjMDBkYjQwZGFjMTY1ZmNkYWVjNzhiNjcwOTQyNDMvZG1lc2cteW9jdG8teHBz
LTI6MjAxNDAzMjExNDAxMTM6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNzozLjE0LjAt
cmM3LTEwMjkwLWcwMTYzMTlkOjEKMDoxMzoxNSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290
cwobWzE7MzVtMjAxNC0wMy0yMSAxNDowMToyNSBSRVBFQVQgQ09VTlQ6IDIxICAjIC9jYy93
Zmcvc291bmQtYmlzZWN0Ly5yZXBlYXQbWzBtCgpiaXNlY3Q6IGJhZCBjb21taXQgMDE2MzE5
ZDM3NWMwMGRiNDBkYWMxNjVmY2RhZWM3OGI2NzA5NDI0MwpnaXQgY2hlY2tvdXQgdjMuMTMK
ZXJyb3I6IHBhdGhzcGVjICd2My4xMycgZGlkIG5vdCBtYXRjaCBhbnkgZmlsZShzKSBrbm93
biB0byBnaXQuCjIwMTQtMDMtMjEgMTQ6MDE6Mjg6IGNtZF9mYWlsOiAnL3Vzci9sb2NhbC9i
aW4vZ2l0JyAnY2hlY2tvdXQnICctLXF1aWV0JyAndjMuMTMnICwgcmV0PTEsIHJlZjogL2tl
cm5lbC10ZXN0cy9mYWlsZWQtY21kL2JlZS1iaXNlY3QtY29tbW9uLnNoOjQwNDMtZ2l0LXdm
Zy5sb2cKSEVBRCBpcyBub3cgYXQgMDE2MzE5ZCBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJh
bmNoICdjb21wYXQvY29tcGF0JwplcnJvcjogcGF0aHNwZWMgJ3YzLjEzJyBkaWQgbm90IG1h
dGNoIGFueSBmaWxlKHMpIGtub3duIHRvIGdpdC4KMjAxNC0wMy0yMSAxNDowMTozNDogY21k
X2ZhaWw6ICcvdXNyL2xvY2FsL2Jpbi9naXQnICdjaGVja291dCcgJy0tcXVpZXQnICd2My4x
MycgLCByZXQ9MSwgcmVmOiAva2VybmVsLXRlc3RzL2ZhaWxlZC1jbWQvYmVlLWJpc2VjdC1j
b21tb24uc2g6NDA0Ny1naXQtd2ZnLmxvZwpIRUFEIGlzIG5vdyBhdCAwMTYzMTlkIE1lcmdl
IHJlbW90ZS10cmFja2luZyBicmFuY2ggJ2NvbXBhdC9jb21wYXQnCmVycm9yOiBwYXRoc3Bl
YyAndjMuMTMnIGRpZCBub3QgbWF0Y2ggYW55IGZpbGUocykga25vd24gdG8gZ2l0LgoyMDE0
LTAzLTIxIDE0OjAxOjM1OiBjbWRfZmFpbDogJy91c3IvbG9jYWwvYmluL2dpdCcgJ2NoZWNr
b3V0JyAnLS1xdWlldCcgJ3YzLjEzJyAsIHJldD0xLCByZWY6IC9rZXJuZWwtdGVzdHMvZmFp
bGVkLWNtZC9iZWUtYmlzZWN0LWNvbW1vbi5zaDo0MDUxLWdpdC13ZmcubG9nCi91c3IvYmlu
L2Jhc2VuYW1lOiBtaXNzaW5nIG9wZXJhbmQKVHJ5ICcvdXNyL2Jpbi9iYXNlbmFtZSAtLWhl
bHAnIGZvciBtb3JlIGluZm9ybWF0aW9uLgoyMDE0LTAzLTIxIDE0OjAxOjM1OiBjbWRfZmFp
bDogJy91c3IvYmluL2Jhc2VuYW1lJyAsIHJldD0xLCByZWY6IC9rZXJuZWwtdGVzdHMvZmFp
bGVkLWNtZC9iZWUtYmlzZWN0LWNvbW1vbi5zaDo0MDU1LWJhc2VuYW1lLXdmZy5sb2cKICAv
Yy9rZXJuZWwtdGVzdHMvY29tbW9uLnNoOjE2NzogZHVtcF9zdGFjawogIC9jL2tlcm5lbC10
ZXN0cy9jb21tb24uc2g6NDA1OTogZ2l0X2NoZWNrb3V0CiAgL2Mva2VybmVsLXRlc3RzL2Nv
bW1vbi5zaDo0MjEwOiB0ZXN0X2NvbW1pdAogIC9jL2tlcm5lbC10ZXN0cy9jb21tb24uc2g6
NDM0NjogdGVzdF9iYWNrd2FyZHMKICAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0OjU1OiBtYWlu
CkFDVElWRV9DT01QSUxFUlM9L2tlcm5lbC10ZXN0cy9hY3RpdmUtY29tcGlsZXJzCkFDVElW
RV9URVNUQk9YRVM9L2tlcm5lbC10ZXN0cy9hY3RpdmUtdGVzdGJveGVzCkFSQ0hJVkVfRElS
PS9rZXJuZWwtdGVzdHMvYXJjaGl2ZQpCQVNFTkFNRT0vdXNyL2Jpbi9iYXNlbmFtZQpCQVNI
PS9iaW4vYmFzaApCQVNIT1BUUz1jbWRoaXN0OmV4dHF1b3RlOmZvcmNlX2ZpZ25vcmU6aG9z
dGNvbXBsZXRlOmludGVyYWN0aXZlX2NvbW1lbnRzOm51bGxnbG9iOnByb2djb21wOnByb21w
dHZhcnM6c291cmNlcGF0aApCQVNIUElEPTMyNjM2CkJBU0hfQUxJQVNFUz0oKQpCQVNIX0FS
R0M9KFswXT0iNCIpCkJBU0hfQVJHVj0oWzBdPSJhNjU0ZGM3OTdmM2VhMWNiNTcxOWE3MWEx
N2FmMzVmNTdmZGRiMmQ4IiBbMV09IjAxNjMxOWQzNzVjMDBkYjQwZGFjMTY1ZmNkYWVjNzhi
NjcwOTQyNDMiIFsyXT0iaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNyIgWzNdPSIvaG9t
ZS93Zmcvc291bmQvb2JqLWJpc2VjdCIpCkJBU0hfQ01EUz0oKQpCQVNIX0xJTkVOTz0oWzBd
PSIxNjkiIFsxXT0iNDA1OSIgWzJdPSI0MjEwIiBbM109IjQzNDYiIFs0XT0iNTUiIFs1XT0i
MCIpCkJBU0hfUkVNQVRDSD0oWzBdPSItcmMiKQpCQVNIX1NPVVJDRT0oWzBdPSIvYy9rZXJu
ZWwtdGVzdHMvY29tbW9uLnNoIiBbMV09Ii9jL2tlcm5lbC10ZXN0cy9jb21tb24uc2giIFsy
XT0iL2Mva2VybmVsLXRlc3RzL2NvbW1vbi5zaCIgWzNdPSIvYy9rZXJuZWwtdGVzdHMvY29t
bW9uLnNoIiBbNF09Ii9jL2tlcm5lbC10ZXN0cy9jb21tb24uc2giIFs1XT0iL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdCIpCkJBU0hfVkVSU0lORk89KFswXT0iNCIgWzFdPSIyIiBbMl09IjIw
IiBbM109IjEiIFs0XT0icmVsZWFzZSIgWzVdPSJ4ODZfNjQtcGMtbGludXgtZ251IikKQkFT
SF9WRVJTSU9OPSc0LjIuMjAoMSktcmVsZWFzZScKQklTRUNUX0xPRz0va2VybmVsLXRlc3Rz
L2Jvb3QtYmlzZWN0L2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzctYTY1NGRjNzk3ZjNl
YTFjYjU3MTlhNzFhMTdhZjM1ZjU3ZmRkYjJkOC1rZXJuZWwtQlVHLWF0LW1tLXN3YXAtYy0x
MzA1NTgubG9nCkJJU0VDVF9RVUVVRV9TVUZGSVg9YmlzZWN0LXNvdW5kCkJJU0VDVF9TVEFS
VF9TRUNTPTEzOTUzODA2OTIKQklTRUNUX1RFU1Q9L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaApCT09URkFJTF9IRUFEU19ST09UPS9rZXJuZWwtdGVzdHMv
Ym9vdC1mYWlsLWhlYWRzCkJPT1RfQklTRUNUX0xPR19ESVI9L2tlcm5lbC10ZXN0cy9ib290
LWJpc2VjdApCT09UX0VSUk9SX0RJUj0va2VybmVsLXRlc3RzL2Jvb3QtZXJyb3IKQk9PVF9U
RVNUX0xPR19ESVI9L2tlcm5lbC10ZXN0cy9ib290LWxvZwpCUkFOQ0hfRVJST1I9L2tlcm5l
bC10ZXN0cy9icmFuY2gtZXJyb3IKQlJBTkNIX1FVRVVFPS9rZXJuZWwtdGVzdHMvYnJhbmNo
LXF1ZXVlCkJVSUxEX0JJU0VDVF9MT0dfRElSPS9rZXJuZWwtdGVzdHMvYnVpbGQtYmlzZWN0
CkJVSUxEX0NPTVBMRVRFPS9rZXJuZWwtdGVzdHMvYnVpbGQtY29tcGxldGUKQlVJTERfRVJS
T1JfRElSPS9rZXJuZWwtdGVzdHMvYnVpbGQtZXJyb3IKQlVJTERfTk9USUZZX1FVRVVFPS9r
ZXJuZWwtdGVzdHMvYnJhbmNoLXF1ZXVlL2J1aWxkLW5vdGlmeQpCVUlMRF9RVUVVRT0va2Vy
bmVsLXRlc3RzL2J1aWxkLXF1ZXVlCkJVSUxEX1NFUlZFRD0va2VybmVsLXRlc3RzL2J1aWxk
LXNlcnZlZApDQUxMX1RSQUNFX0ZVTkNTPSdbYS16QS1aMC05Ll9dK1wrMHhbMC05YS1mXStc
LzB4WzAtOWEtZl0rJwpDQ19ST09UPS9rZXJuZWwtdGVzdHMKQ0dST1VQX0NQVT0vY2dyb3Vw
L2NwdQpDR1JPVVBfQ1BVU0VUPS9jZ3JvdXAvY3B1c2V0CkNHUk9VUF9NRU1PUlk9L2Nncm91
cC9tZW1vcnkKQ01ETElORT0oWzBdPSIvaG9tZS93Zmcvc291bmQvb2JqLWJpc2VjdCIgWzFd
PSJpMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3IiBbMl09IjAxNjMxOWQzNzVjMDBkYjQw
ZGFjMTY1ZmNkYWVjNzhiNjcwOTQyNDMiIFszXT0iYTY1NGRjNzk3ZjNlYTFjYjU3MTlhNzFh
MTdhZjM1ZjU3ZmRkYjJkOCIpCkNPTU1JVF9MSVNUX1JPT1Q9L2tlcm5lbC10ZXN0cy9jb21t
aXQtbGlzdApDT01QSUxFRF9ST09UPS9rZXJuZWwtdGVzdHMvY29tcGlsZWQKQ19ST09UPS9j
L2tlcm5lbC10ZXN0cwpEQUlMWV9FTUFJTD0va2VybmVsLXRlc3RzL2RhaWx5LWVtYWlsCkRF
QkVNQUlMPWZlbmdndWFuZy53dUBpbnRlbC5jb20KREVCRlVMTE5BTUU9J0ZlbmdndWFuZyBX
dScKREVCVUdfSU5GT19ST09UPS9rZXJuZWwtdGVzdHMvZGVidWctaW5mbwpERUZBVUxUX1BB
VEg9L3Vzci9sb2NhbC9iaW46L3Vzci9zYmluOi91c3IvYmluOi9zYmluOi9iaW4KREVWRUxf
QkFEX0JPT1Q9L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUvZGV2ZWwtYmFkLWJvb3QKREVWRUxf
UVVFVUU9L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUvZGV2ZWwKRElSTkFNRT0vdXNyL2Jpbi9k
aXJuYW1lCkRJUlNUQUNLPSgpCkRNRVNHX1FVRVVFPS9rZXJuZWwtdGVzdHMvZG1lc2ctcXVl
dWUKRU1BSUw9J0ZlbmdndWFuZyBXdSA8ZmVuZ2d1YW5nLnd1QGludGVsLmNvbT4nCkVNQUlM
X1FVRVVFPS9rZXJuZWwtdGVzdHMvZW1haWwtcXVldWUKRVVJRD0xMDAwCkVYVFJBVkVSU0lP
Tj0tcmM3CkZBSUxFRF9DTURfRElSPS9rZXJuZWwtdGVzdHMvZmFpbGVkLWNtZApGSVJTVF9C
QURfQlJBTkNIRVM9L2tlcm5lbC10ZXN0cy9maXJzdF9iYWRfYnJhbmNoZXMKRlVOQ05BTUU9
KFswXT0iZHVtcF9zaGVsbF92YXJzIiBbMV09ImR1bXBfc3RhY2siIFsyXT0iZ2l0X2NoZWNr
b3V0IiBbM109InRlc3RfY29tbWl0IiBbNF09InRlc3RfYmFja3dhcmRzIiBbNV09Im1haW4i
KQpGVU5DX0VSUk9SX0RJUj0va2VybmVsLXRlc3RzL2Z1bmMtZXJyb3IKR0lUPS91c3IvbG9j
YWwvYmluL2dpdApHSVRfQklTRUNUX0xPRz0va2VybmVsLXRlc3RzL2Jvb3QtYmlzZWN0L2kz
ODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzctYTY1NGRjNzk3ZjNlYTFjYjU3MTlhNzFhMTdh
ZjM1ZjU3ZmRkYjJkOC1zb3VuZApHUEdfVFRZPS9kZXYvcHRzLzIzCkdSRVA9L2Jpbi9ncmVw
CkdST1VQUz0oKQpIQU1NRVJfQlJBTkNIPS9rZXJuZWwtdGVzdHMvaGFtbWVyLWJyYW5jaApI
SVNUU0laRT0zMDAwMApIT01FPS9ob21lL3dmZwpIT1NUTkFNRT1iZWUKSE9TVFRZUEU9eDg2
XzY0CklGUz0nIAkKJwpJR05PUkVfRVJSPTAKSU5ESUNBVE9SUz0va2VybmVsLXRlc3RzL2lu
ZGljYXRvcnMKSU5JVFJEX1JPT1Q9L2tlcm5lbC10ZXN0cy9pbml0cmQKS0JVSUxEX09VVFBV
VD0vaG9tZS93Zmcvc291bmQvb2JqLWJpc2VjdApLQ09ORklHX0FTU0lHTk1FTlQ9L2Mva2Vy
bmVsLXRlc3RzL2tjb25maWcvYmVlCktDT05GSUdfUkFORD0va2VybmVsLXRlc3RzL2tjb25m
aWcvcmFuZApLQ09ORklHX1NUQVRJQz0va2VybmVsLXRlc3RzL2tjb25maWcvc3RhdGljCktD
T05GSUdfVEVNUD0va2VybmVsLXRlc3RzL2tjb25maWcvdGVtcApLRVJORUxfUk9PVD0va2Vy
bmVsCkxBTkc9QwpMRVNTPS1NUmlxc2NqNQpMRVNTQ0xPU0U9Jy91c3IvYmluL2xlc3NwaXBl
ICVzICVzJwpMRVNTT1BFTj0nfCAvdXNyL2Jpbi9sZXNzcGlwZSAlcycKTElOVVhfTkVYVF9R
VUVVRT0va2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9saW51eC1uZXh0CkxJTlVYX05FWFRfUkVQ
T1JUUz0va2VybmVsLXRlc3RzL2xpbnV4LW5leHQvZW1haWxfZHVtcApMSVZFX0VSUk9SX0RJ
Uj0va2VybmVsLXRlc3RzL2xpdmUtZXJyb3IKTEtQX0NPTU1JVFNfUk9PVD0va2VybmVsLXRl
c3RzL2xrcC1jb21taXRzCkxLUF9IT01FPS9sa3Avd2ZnCkxLUF9TUkNfRElSPS9sa3Avd2Zn
L3NyYwpMS1BfVkVSQk9TRT0xCkxPR05BTUU9d2ZnCkxPR19ESVI9L2tlcm5lbC10ZXN0cy9s
b2cKTFNfQ09MT1JTPSdubz0wMDpmaT0wMDpkaT0wMTszNDpsbj0wMTszNjpwaT00MDszMzpz
bz0wMTszNTpkbz0wMTszNTpiZD00MDszMzswMTpjZD00MDszMzswMTpvcj00MDszMTswMTpl
eD0wMTszMjoqLnRhcj0wMTszMToqLnRnej0wMTszMToqLmFyaj0wMTszMToqLnRhej0wMTsz
MToqLmx6aD0wMTszMToqLnppcD0wMTszMToqLno9MDE7MzE6Ki5aPTAxOzMxOiouZ3o9MDE7
MzE6Ki5iejI9MDE7MzE6Ki5kZWI9MDE7MzE6Ki5ycG09MDE7MzE6Ki5qYXI9MDE7MzE6Ki5q
cGc9MDE7MzU6Ki5qcGVnPTAxOzM1OiouZ2lmPTAxOzM1OiouYm1wPTAxOzM1OioucGJtPTAx
OzM1OioucGdtPTAxOzM1OioucHBtPTAxOzM1OioudGdhPTAxOzM1OioueGJtPTAxOzM1Oiou
eHBtPTAxOzM1OioudGlmPTAxOzM1OioudGlmZj0wMTszNToqLnBuZz0wMTszNToqLm1vdj0w
MTszNToqLm1wZz0wMTszNToqLm1wZWc9MDE7MzU6Ki5hdmk9MDE7MzU6Ki5mbGk9MDE7MzU6
Ki5nbD0wMTszNToqLmRsPTAxOzM1OioueGNmPTAxOzM1OioueHdkPTAxOzM1Oioub2dnPTAx
OzM1OioubXAzPTAxOzM1Oioud2F2PTAxOzM1OiouZG9jPTAxOzMzOioucHB0PTAxOzMzOiou
eGxzPTAxOzMzOicKTUFDSFRZUEU9eDg2XzY0LXBjLWxpbnV4LWdudQpNQUlMPS92YXIvbWFp
bC93ZmcKTUVSR0VEX0hFQURTX1JPT1Q9L2tlcm5lbC10ZXN0cy9tZXJnZWQtaGVhZHMKTUVS
R0VfTElTVF9ST09UPS9rZXJuZWwtdGVzdHMvbWVyZ2UtbGlzdApNS0RJUj0vYmluL21rZGly
Ck5PREVfU1RBVFVTPS9rZXJuZWwtdGVzdHMvd3RtcApPTERfQlJBTkNIRVM9L2tlcm5lbC10
ZXN0cy9vbGQtYnJhbmNoZXMKT09QU19JRF9ESVI9L2tlcm5lbC10ZXN0cy9vb3BzLWlkCk9Q
VEVSUj0xCk9QVElORD0xCk9TVFlQRT1saW51eC1nbnUKUEFHRVI9bGVzcwpQQVRDSExFVkVM
PTE0ClBBVEg9L2hvbWUvd2ZnL2JpbjovdXNyL2xvY2FsL3NiaW46L3Vzci9sb2NhbC9iaW46
L3Vzci9saWIvZ2l0LWNvcmU6L3Vzci9zYmluOi91c3IvYmluOi9zYmluOi9iaW46L3Vzci9Y
MTFSNi9iaW46L3Vzci9nYW1lczovdXNyL2xpYi94c2NyZWVuc2F2ZXI6L2xrcC93Zmcvc3Jj
L3NiaW46L2xrcC93Zmcvc3JjL2JpbjovbGtwL3dmZy9zcmMvdG9vbHM6L2xrcC93Zmcvc3Jj
L3NiaW46L2xrcC93Zmcvc3JjL2JpbjovbGtwL3dmZy9zcmMvdG9vbHMKUElQRVNUQVRVUz0o
WzBdPSIwIikKUE9TSVhMWV9DT1JSRUNUPXkKUFBJRD0xMzA1NTgKUFM0PScrICcKUFdEPS9o
b21lL3dmZy9zb3VuZApSRU1PVEVTPS9rZXJuZWwtdGVzdHMvcmVtb3RlcwpSRVBPUlRFRF9P
T1BTX0RJUj0va2VybmVsLXRlc3RzL3JlcG9ydGVkLW9vcHMKUkVQT1JUX1JPT1Q9L2tlcm5l
bC10ZXN0cy9yZXBvcnRzClJFUFJPRFVDRUQ9L2tlcm5lbC10ZXN0cy9yZXByb2R1Y2VkClJF
UFJPRFVDRV9RVUVVRT0va2VybmVsLXRlc3RzL3JlcHJvZHVjZS1xdWV1ZQpSTT0vYmluL3Jt
ClJVTl9RVUVVRT0va2VybmVsLXRlc3RzL3J1bi1xdWV1ZQpTQ1JJUFQ9L2Mva2VybmVsLXRl
c3RzL2Jpc2VjdApTQ1JJUFRfRElSPS9jL2tlcm5lbC10ZXN0cwpTQ1JJUFRfVkVSPSc5NjMy
MjZhMTU0NGRiYjZhNDYyNDZiNzAxNjhmMDk0MiAgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdAo4
MGI2NjM1Yjk2OTM4OTFmM2JkMWExYzM0NTA4ODFjOSAgL2Mva2VybmVsLXRlc3RzL2NvbW1v
bi5zaCcKU0VEPS9iaW4vc2VkClNIRUxMPS9iaW4venNoClNIRUxMT1BUUz1icmFjZWV4cGFu
ZDpoYXNoYWxsOmludGVyYWN0aXZlLWNvbW1lbnRzOnBvc2l4ClNIRUxMX0RJUj0vaG9tZS93
ZmcvLnNoZWxsClNITFZMPTQKU1NIX0FVVEhfU09DSz0vdG1wL3NzaC0wS1ZmcTdDVVBhL2Fn
ZW50LjExOTY5ClNTSF9DTElFTlQ9JzEwLjI1NS4yMS4yMTQgNTcyMDggMjInClNTSF9DT05O
RUNUSU9OPScxMC4yNTUuMjEuMjE0IDU3MjA4IDEwLjIzOS45Ny4xNCAyMicKU1NIX1RUWT0v
ZGV2L3B0cy8wClNUWT0xMjA4OC5wdHMtMC5iZWUKU1VCTEVWRUw9MApURVJNPXNjcmVlbi1i
Y2UKVEVSTUNBUD0nU0N8c2NyZWVuLWJjZXxWVCAxMDAvQU5TSSBYMy42NCB2aXJ0dWFsIHRl
cm1pbmFsOlwKCTpETz1cRVslZEI6TEU9XEVbJWREOlJJPVxFWyVkQzpVUD1cRVslZEE6YnM6
YnQ9XEVbWjpcCgk6Y2Q9XEVbSjpjZT1cRVtLOmNsPVxFW0hcRVtKOmNtPVxFWyVpJWQ7JWRI
OmN0PVxFWzNnOlwKCTpkbz1eSjpuZD1cRVtDOnB0OnJjPVxFODpycz1cRWM6c2M9XEU3OnN0
PVxFSDp1cD1cRU06XAoJOmxlPV5IOmJsPV5HOmNyPV5NOml0Izg6aG89XEVbSDpudz1cRUU6
dGE9Xkk6aXM9XEUpMDpcCgk6bGkjNTY6Y28jMTY4OmFtOnhuOnh2OkxQOnNyPVxFTTphbD1c
RVtMOkFMPVxFWyVkTDpcCgk6Y3M9XEVbJWklZDslZHI6ZGw9XEVbTTpETD1cRVslZE06ZGM9
XEVbUDpEQz1cRVslZFA6XAoJOmltPVxFWzRoOmVpPVxFWzRsOm1pOklDPVxFWyVkQDprcz1c
RVs/MWhcRT06XAoJOmtlPVxFWz8xbFxFPjp2aT1cRVs/MjVsOnZlPVxFWzM0aFxFWz8yNWg6
dnM9XEVbMzRsOlwKCTp0aT1cRVs/MTA0OWg6dGU9XEVbPzEwNDlsOnVzPVxFWzRtOnVlPVxF
WzI0bTpzbz1cRVszbTpcCgk6c2U9XEVbMjNtOm1iPVxFWzVtOm1kPVxFWzFtOm1yPVxFWzdt
Om1lPVxFW206bXM6XAoJOkNvIzg6cGEjNjQ6QUY9XEVbMyVkbTpBQj1cRVs0JWRtOm9wPVxF
WzM5OzQ5bTpBWDpcCgk6dmI9XEVnOkcwOmFzPVxFKDA6YWU9XEUoQjpcCgk6YWM9XDE0MFwx
NDBhYWZmZ2dqamtrbGxtbW5ub29wcHFxcnJzc3R0dXV2dnd3eHh5eXp6e3t8fH19fn4uLi0t
KyssLGhoSUkwMDpcCgk6cG89XEVbNWk6cGY9XEVbNGk6azA9XEVbMTB+OmsxPVxFT1A6azI9
XEVPUTprMz1cRU9SOlwKCTprND1cRU9TOms1PVxFWzE1fjprNj1cRVsxN346azc9XEVbMTh+
Oms4PVxFWzE5fjpcCgk6azk9XEVbMjB+Oms7PVxFWzIxfjpGMT1cRVsyM346RjI9XEVbMjR+
OkYzPVxFWzI1fjpcCgk6RjQ9XEVbMjZ+OkY1PVxFWzI4fjpGNj1cRVsyOX46Rjc9XEVbMzF+
OkY4PVxFWzMyfjpcCgk6Rjk9XEVbMzN+OkZBPVxFWzM0fjprYj1/OksxPVxFT3c6SzI9XEVP
dTpLMz1cRU95OlwKCTpLND1cRU9xOks1PVxFT3M6a0I9XEVbWjprRT1cRVs4XF46KjQ9XEVb
MyQ6Kjc9XEVbOCQ6XAoJOiMyPVxFWzckOiMzPVxFWzIkOiM0PVxFW2Q6JWM9XEVbNiQ6JWU9
XEVbNSQ6JWk9XEVbYzpcCgk6a2g9XEVbMX46QDE9XEVbMX46a0g9XEVbNH46QDc9XEVbNH46
a049XEVbNn46a1A9XEVbNX46XAoJOmtEPVxFWzN+Omt1PVxFT0E6a2Q9XEVPQjprcj1cRU9D
OmtsPVxFT0Q6a206JwpVSUQ9MTAwMApVU0VSPXdmZwpWRVJTSU9OPTMKV0lORE9XPTEwClhB
VVRIT1JJVFk9L2hvbWUvd2ZnLy5YYXV0aG9yaXR5CllBTUxfVE9fU0hFTEw9L2Mva2VybmVs
LXRlc3RzL3lhbWwtdG8tc2hlbGwtdmFycwpfPXBvc2l4CmJhZF9jb21taXQ9MDE2MzE5ZDM3
NWMwMGRiNDBkYWMxNjVmY2RhZWM3OGI2NzA5NDI0MwpiYXNlX2NvbW1pdD0wMTYzMTlkMzc1
YzAwZGI0MGRhYzE2NWZjZGFlYzc4YjY3MDk0MjQzCmJyYW5jaD1uZXh0L21hc3RlcgpjX2Zp
bGVfcGF0dGVybj0nW2EtekEtWjAtOS9fLV17Mix9L1thLXpBLVowLTlfLV17MSx9XC5jJwpj
b2RlPQpjb2xvcj0oW2JvbGRdPSJcXGVbMDsxbSIgW0dSRUVOXT0iXFxlWzE7MzJtIiBbdW5k
ZXJsaW5lXT0iXFxlWzA7NG0iIFtncmF5XT0iXFxlWzA7MzdtIiBbWUVMTE9XXT0iXFxlWzE7
MzNtIiBbeWVsbG93XT0iXFxlWzA7MzNtIiBbYmxpbmtdPSJcXGVbMDs1bSIgW3JlZF09Ilxc
ZVswOzMxbSIgW3JldmVyc2VdPSJcXGVbMDs3bSIgW0JMVUVdPSJcXGVbMTszNG0iIFtibHVl
XT0iXFxlWzA7MzRtIiBbaW52aXNdPSJcXGVbMDs4bSIgW2RhcmstZ3JheV09IlxcZVsxOzMw
bSIgW3N0YW5kb3V0XT0iXFxlWzA7MTs3bSIgW01BR0VOVEFdPSJcXGVbMTszNW0iIFt3aGl0
ZV09IlxcZVsxOzM3bSIgW2dyZWVuXT0iXFxlWzA7MzJtIiBbYmxhY2tdPSJcXGVbMDszMG0i
IFtyZXNldF09IlxcZVswbSIgW1JFRF09IlxcZVsxOzMxbSIgW2Jyb3duXT0iXFxlWzA7MzNt
IiBbQ1lBTl09IlxcZVsxOzM2bSIgW2N5YW5dPSJcXGVbMDszNm0iIFttYWdlbnRhXT0iXFxl
WzA7MzVtIiBbV0hJVEVdPSJcXGVbMTszN20iICkKY29sb3JfbWFwPScKYmxhY2sJCVxcZVsw
OzMwbQpyZWQJCVxcZVswOzMxbQpncmVlbgkJXFxlWzA7MzJtCnllbGxvdwkJXFxlWzA7MzNt
CmJyb3duCQlcXGVbMDszM20KYmx1ZQkJXFxlWzA7MzRtCm1hZ2VudGEJCVxcZVswOzM1bQpj
eWFuCQlcXGVbMDszNm0KZ3JheQkJXFxlWzA7MzdtCmRhcmstZ3JheQlcXGVbMTszMG0KUkVE
CQlcXGVbMTszMW0KR1JFRU4JCVxcZVsxOzMybQpZRUxMT1cJCVxcZVsxOzMzbQpCTFVFCQlc
XGVbMTszNG0KTUFHRU5UQQkJXFxlWzE7MzVtCkNZQU4JCVxcZVsxOzM2bQpXSElURQkJXFxl
WzE7MzdtCndoaXRlCQlcXGVbMTszN20KCmJvbGQJCVxcZVswOzFtCnVuZGVybGluZQlcXGVb
MDs0bQpibGluawkJXFxlWzA7NW0KcmV2ZXJzZQkJXFxlWzA7N20KaW52aXMJCVxcZVswOzht
CnN0YW5kb3V0CVxcZVswOzE7N20KcmVzZXQJCVxcZVswbQonCmNvbW1lbnQ9CmNvbW1pdD12
My4xMwpjb21taXRzX2ZpbGU9L2tlcm5lbC10ZXN0cy9jb21taXQtbGlzdC9uZXh0Om1hc3Rl
cjphNjU0ZGM3OTdmM2VhMWNiNTcxOWE3MWExN2FmMzVmNTdmZGRiMmQ4CmV4ZWN1dG9yX2Vt
YWlsPQpmaWxlPS9kZXYvc2htLy0yMDE0LTAzLTIxCmhlYWRfY29tbWl0PWE2NTRkYzc5N2Yz
ZWExY2I1NzE5YTcxYTE3YWYzNWY1N2ZkZGIyZDgKaHR0cF9wcm94eT1odHRwOi8vcHJveHkt
c2h6LmludGVsLmNvbTo5MTEKaT0xCmludGVybmFsX2NoZWNrZXJfZW1haWxzPSdrYnVpbGQt
aW50ZXJuYWxAbGludXguaW50ZWwuY29tLCBmbnN0bWwta2J1aWxkLXJlcG9ydEBjbi5mdWpp
dHN1LmNvbScKaW50ZXJuYWxfZG9tYWluPWludGVsLmNvbQprY29uZmlnPWkzODYtcmFuZGNv
bmZpZy1iYTEtMDMyMTEyMzcKa2VybmVsX3ZlcnNpb249My4xNC1yYzcKa2VybmVsX3ZlcnNp
b25fbWFqb3I9MwprZXJuZWxfdmVyc2lvbl9taW5vcj0xMwpsa3BfZXJyb3JfY2hlY2tlcl9l
bWFpbHM9J3l1YW5oYW4ubGl1QGxpbnV4LmludGVsLmNvbSwgZmVuZ2d1YW5nLnd1QGludGVs
LmNvbScKbGtwX2xpc3Q9J0xLUCA8Zm5zdG1sLWxrcEBjbi5mdWppdHN1LmNvbT4nCm1heF9l
cnJvcnM9MTAKbWF4X2Vycm9yc19wZXJfZmlsZT0yMAptZXJnZV9iYXNlPTAxNjMxOWQzNzVj
MDBkYjQwZGFjMTY1ZmNkYWVjNzhiNjcwOTQyNDMKbmFtZT0KbnJfY29tbWl0cz00NjMKbnJf
Y3B1PTMyCnJlbW90ZT0KcmVtb3RlX3VybD0oW3RqLWxpYmF0YV09ImdpdDovL2dpdC5rZXJu
ZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90ai9saWJhdGEiIFtzaGF3bmd1b109
ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9zaGF3bmd1
by9saW51eC5naXQiIFt4ZW4tdGlwXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9s
aW51eC9rZXJuZWwvZ2l0L3hlbi90aXAiIFtmY29lXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcv
cHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3J3bG92ZS9mY29lLmdpdCIgW2YyZnNdPSJnaXQ6
Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvamFlZ2V1ay9mMmZz
IiBbbXNtXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0
L2RhdmlkYi9saW51eC1tc20iIFtzaXJmcHJpbWEyXT0iZ2l0Oi8vZ2l0b3Jpb3VzLm9yZy9z
aXJmcHJpbWEyLWtlcm5lbC9zaXJmcHJpbWEyLWtlcm5lbC5naXQiIFt0dHldPSJnaXQ6Ly9n
aXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZ3JlZ2toL3R0eS5naXQi
IFtyd109ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9y
dy9taXNjLmdpdCIgW3BlcmZdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4
L2tlcm5lbC9naXQvYWNtZS9saW51eC5naXQiIFtwZXJjcHVdPSJnaXQ6Ly9naXQua2VybmVs
Lm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGovcGVyY3B1LmdpdCIgW2RtXT0iZ2l0
Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2RldmljZS1tYXBw
ZXIvbGludXgtZG0uZ2l0IiBbaW50ZXJuYWwtYW5kcm9pZF09ImdpdDovL290Yy1hbmRyb2lk
LmludGVsLmNvbS9ic3Ava2VybmVsL2ludGVsLmdpdCIgW2ludGVybmFsLXJ0ZDNdPSJnaXQ6
Ly9iZWUuc2guaW50ZWwuY29tL2dpdC9ydGQzL3J0ZDMuZ2l0IiBbcmVhbG16Ni1ibGFja2Zp
bl09ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9yZWFs
bXo2L2JsYWNrZmluLWxpbnV4IiBbb3Byb2ZpbGVdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9w
dWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvcnJpYy9vcHJvZmlsZS5naXQiIFtsaW51eHR2LW1l
ZGlhXT0iZ2l0Oi8vbGludXh0di5vcmcvbWVkaWFfdHJlZS5naXQiIFtrYXNdPSJnaXQ6Ly9n
aXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQva2FzL2xpbnV4LmdpdCIg
W2l3bHdpZmktbmV4dF09ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2Vy
bmVsL2dpdC9pd2x3aWZpL2l3bHdpZmktbmV4dC5naXQiIFt0aW1lXT0iZ2l0Oi8vZ2l0Lmxp
bmFyby5vcmcvcGVvcGxlL2pzdHVsdHovbGludXguZ2l0IiBbc3BhcmMtbmV4dF09ImdpdDov
L2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9kYXZlbS9zcGFyYy1u
ZXh0LmdpdCIgW21hYzgwMjExLW5leHRdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2Nt
L2xpbnV4L2tlcm5lbC9naXQvamJlcmcvbWFjODAyMTEtbmV4dC5naXQiIFtod21vbl09Imdp
dDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9ncm9lY2svbGlu
dXgtc3RhZ2luZy5naXQiIFtlZGFjXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9s
aW51eC9rZXJuZWwvZ2l0L21jaGVoYWIvbGludXgtZWRhYy5naXQiIFtzY3RzY29yZV09Imdp
dDovL2dpdGh1Yi5jb20vc2N0c2NvcmUvb2ZmaWNpYWwtbGludXgiIFtycm5heWFrXT0iZ2l0
Oi8vZ2l0aHViLmNvbS9ycm5heWFrL2xpbnV4IiBbY2xrXT0iZ2l0Oi8vZ2l0LmxpbmFyby5v
cmcvcGVvcGxlL210dXJxdWV0dGUvbGludXguZ2l0IiBba3ZtLXBwY109ImdpdDovL2dpdGh1
Yi5jb20vYWdyYWYvbGludXgtMi42LmdpdCIgW3Zob3N0XT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5v
cmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L21zdC92aG9zdC5naXQiIFtjcHVmcmVxXT0i
Z2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2RhdmVqL2Nw
dWZyZXEuZ2l0IiBbaW50ZXJuYWwtZHJtLWludGVsXT0ic3NoOi8vZnd1QGdpdC1hbXItMS5k
ZXZ0b29scy5pbnRlbC5jb206Mjk0MTgvb3RjX2dlbl9ncmFwaGljcy1kcm0taW50ZWwiIFt4
MDE0ODQwNl09ImdpdDovL2dpdG9yaW91cy5vcmcveDAxNDg0MDYtcHVibGljL2xpbnV4LWtl
cm5lbCIgW2M2eF09ImdpdDovL2xpbnV4LWM2eC5vcmcvZ2l0L3Byb2plY3RzL2xpbnV4LWM2
eC11cHN0cmVhbWluZy5naXQiIFtocC1wYXJpc2NdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9w
dWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZGVsbGVyL3BhcmlzYy1saW51eCIgW2F0OTFdPSJn
aXQ6Ly9naXRodWIuY29tL2F0OTFsaW51eC9saW51eC1hdDkxLmdpdCIgW3RoZXJtYWxdPSJn
aXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvcnpoYW5nL2xp
bnV4LmdpdCIgW2RybS1nbWE1MDBdPSJnaXQ6Ly9naXRodWIuY29tL3BhdGphay9kcm0tZ21h
NTAwIiBbaXB2c109ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVs
L2dpdC9ob3Jtcy9pcHZzLmdpdCIgW2FibG9jazg0LWJ0cmZzXT0iZ2l0Oi8vZ2l0aHViLmNv
bS9hYmxvY2s4NC9saW51eC1idHJmcy5naXQiIFtyYXNdPSJnaXQ6Ly9naXQua2VybmVsLm9y
Zy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvcmFzL3Jhcy5naXQiIFtsZWRzXT0iZ2l0Oi8v
Z2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2Nvb2xvbmV5L2xpbnV4
LWxlZHMuZ2l0IiBbZHJpdmVyLWNvcmVdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2Nt
L2xpbnV4L2tlcm5lbC9naXQvZ3JlZ2toL2RyaXZlci1jb3JlLmdpdCIgW2Nhbl09ImdpdDov
L2dpdG9yaW91cy5vcmcvbGludXgtY2FuL2xpbnV4LWNhbi1uZXh0IiBbam9uaHVudGVyXT0i
Z2l0Oi8vZ2l0aHViLmNvbS9qb25odW50ZXIvbGludXgiIFtydXN0eV09ImdpdDovL2dpdC5r
ZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9ydXN0eS9saW51eC5naXQiIFtu
b3V2ZWF1XT0iZ2l0Oi8vZ2l0LmZyZWVkZXNrdG9wLm9yZy9naXQvbm91dmVhdS9saW51eC0y
LjYiIFttZmRdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9n
aXQvc2FtZW8vbWZkLTIuNi5naXQiIFtmdXNlXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHVi
L3NjbS9saW51eC9rZXJuZWwvZ2l0L21zemVyZWRpL2Z1c2UuZ2l0IiBbcHdtXT0iZ2l0Oi8v
Z2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RoaWVycnkucmVkaW5n
L2xpbnV4LXB3bSIgW2Jjb24yXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51
eC9rZXJuZWwvZ2l0L2pvZXJuL2Jjb24yLmdpdCIgW2ppbmdvb109ImdpdDovL2dpdGh1Yi5j
b20vamluZ29vL2xpbnV4IiBbaW50ZWwtbmV0LW5leHRdPSJnaXQ6Ly9naXQua2VybmVsLm9y
Zy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvcHB3YXNraWUvbmV0LW5leHQuZ2l0IiBbdWJp
Ml09ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9ydy91
YmkyLmdpdCIgW3NmYy1uZXh0XT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51
eC9rZXJuZWwvZ2l0L2J3aC9zZmMtbmV4dCIgW2RybS1pbnRlbF09ImdpdDovL2Fub25naXQu
ZnJlZWRlc2t0b3Aub3JnL2RybS1pbnRlbCIgW2NyeXB0b2Rldl09ImdpdDovL2dpdC5rZXJu
ZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9oZXJiZXJ0L2NyeXB0b2Rldi0yLjYu
Z2l0IiBbYmNtMTEzNTFdPSJnaXQ6Ly9naXRodWIuY29tL2Jyb2FkY29tL2JjbTExMzUxIiBb
c3Rlcmljc3Nvbl09ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVs
L2dpdC9saW51c3cvbGludXgtc3Rlcmljc3Nvbi5naXQiIFtyb21pZXVdPSJnaXQ6Ly92aW9s
ZXQuZnIuem9yZWlsLmNvbS9yb21pZXUvbGludXgiIFtoYW5zZW5kY109Imh0dHBzOi8vZ2l0
aHViLmNvbS9oYW5zZW5kYy9saW51eC5naXQiIFtkYW52ZXQtZHJtXT0iZ2l0Oi8vcGVvcGxl
LmZyZWVkZXNrdG9wLm9yZy9+ZGFudmV0L2RybSIgW2dmczItZml4ZXNdPSJnaXQ6Ly9naXQu
a2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvc3RldmUvZ2ZzMi0zLjAtZml4
ZXMuZ2l0IiBbaHdzcGlubG9ja109ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGlu
dXgva2VybmVsL2dpdC9vaGFkL2h3c3BpbmxvY2suZ2l0IiBbd2lyZWxlc3MtbmV4dF09Imdp
dDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9saW52aWxsZS93
aXJlbGVzcy1uZXh0LmdpdCIgW3VtbF09ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20v
bGludXgva2VybmVsL2dpdC9ydy91bWwuZ2l0IiBbZWNyeXB0ZnNdPSJnaXQ6Ly9naXQua2Vy
bmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdHloaWNrcy9lY3J5cHRmcy5naXQi
IFtjb25nd2FuZ109ImdpdDovL2dpdGh1Yi5jb20vY29uZ3dhbmcvbGludXguZ2l0IiBbbmZ0
YWJsZXNdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQv
cGFibG8vbmZ0YWJsZXMuZ2l0IiBbc3VueGldPSJnaXQ6Ly9naXRodWIuY29tL21yaXBhcmQv
bGludXgiIFthcm0tbHBdPSJnaXQ6Ly9saW51eC1hcm0ub3JnL2xpbnV4LTIuNi1scCIgW3Bz
dG9yZV09ImdpdDovL2dpdC5pbmZyYWRlYWQub3JnL3VzZXJzL2Nib3UvbGludXgtcHN0b3Jl
IiBba2dlbmUtc2Ftc3VuZ109ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgv
a2VybmVsL2dpdC9rZ2VuZS9saW51eC1zYW1zdW5nLmdpdCIgW25leHRdPSJnaXQ6Ly9naXQu
a2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvbmV4dC9saW51eC1uZXh0Lmdp
dCIgW2NyeXB0b109ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVs
L2dpdC9oZXJiZXJ0L2NyeXB0by0yLjYuZ2l0IiBbbmZdPSJnaXQ6Ly9naXQua2VybmVsLm9y
Zy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvcGFibG8vbmYiIFthbHNhLWtwcml2YXRlXT0i
Z2l0Oi8vZ2l0LmFsc2EtcHJvamVjdC5vcmcvYWxzYS1rcHJpdmF0ZSIgW21pY3JvYmxhemVd
PSJnaXQ6Ly9naXQubW9uc3RyLmV1L2xpbnV4LTIuNi1taWNyb2JsYXplIiBbbWlwcy1zamhp
bGxdPSJnaXQ6Ly9naXQubGludXgtbWlwcy5vcmcvcHViL3NjbS9zamhpbGwvbGludXgtc2po
aWxsIiBbbWVkaWFdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5l
bC9naXQvbWNoZWhhYi9saW51eC1tZWRpYSIgW2lucHV0XT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5v
cmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2R0b3IvaW5wdXQuZ2l0IiBbaWE2NF09Imdp
dDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9hZWdsL2xpbnV4
LmdpdCIgW2dmczJdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5l
bC9naXQvc3RldmUvZ2ZzMi0zLjAtbm13LmdpdCIgW2RtYWVuZ2luZV09ImdpdDovL2dpdC5r
ZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9kamJ3L2RtYWVuZ2luZS5naXQi
IFtpbnRlcm5hbC1hc2hpc2hraV09ImdpdDovL290Y2dpdC5qZi5pbnRlbC5jb20vYXNoaXNo
a2kvbGludXguZ2l0IiBbaW50ZXJuYWwtcHZyXT0iZ2l0Oi8vYmVlLnNoLmludGVsLmNvbS9n
aXQvcHZyL2tlcm5lbC5naXQiIFthaW8tbmV4dF09ImdpdDovL2dpdC5rdmFjay5vcmcvfmJj
cmwvYWlvLW5leHQiIFtjaGFud29vLWV4dGNvbl09ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1
Yi9zY20vbGludXgva2VybmVsL2dpdC9jaGFud29vL2V4dGNvbiIgW29tYXAtcGVuZGluZ109
ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9wancvb21h
cC1wZW5kaW5nLmdpdCIgW2FybS1qY29vcGVyXT0iZ2l0Oi8vZ2l0LmluZnJhZGVhZC5vcmcv
dXNlcnMvamNvb3Blci9saW51eC5naXQiIFtpZHJ5b21vdi1idHJmc109ImdpdDovL2dpdGh1
Yi5jb20vaWRyeW9tb3YvYnRyZnMtdW5zdGFibGUiIFtmYmRldl09ImdpdDovL2dpdGh1Yi5j
b20vc2NoYW5kaW5hdC9saW51eC0yLjYuZ2l0IiBbaW50ZXJuYWwtZXVnZW5pLWRybV09Imdp
dDovL290Y2dpdC5qZi5pbnRlbC5jb20vZWRvZG9ub3Yva2VybmVsLmdpdCIgW3BpbmNoYXJ0
bC1mYmRldl09ImdpdDovL2xpbnV4dHYub3JnL3BpbmNoYXJ0bC9mYmRldi5naXQiIFtzc3Rh
YmVsbGluaS14ZW5dPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5l
bC9naXQvc3N0YWJlbGxpbmkveGVuIiBbcnVpXT0iZ2l0Oi8vYmVlLnNoLmludGVsLmNvbS9n
aXQvcnVpL2xpbnV4LmdpdCIgW2lwdnMtbmV4dF09ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1
Yi9zY20vbGludXgva2VybmVsL2dpdC9ob3Jtcy9pcHZzLW5leHQuZ2l0IiBbZGF2aW5jaV09
ImdpdDovL2dpdG9yaW91cy5vcmcvbGludXgtZGF2aW5jaS9saW51eC1kYXZpbmNpLmdpdCIg
W2tnZGJdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQv
andlc3NlbC9rZ2RiLmdpdCIgW2V4dDNdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2Nt
L2xpbnV4L2tlcm5lbC9naXQvamFjay9saW51eC1mcy5naXQiIFticnlhbi1uZnNdPSJnaXQ6
Ly9naXQubGludXgtbmZzLm9yZy9wcm9qZWN0cy9ianNjaHVtYS9saW51eC1uZnMuZ2l0IiBb
aW50ZXJuYWwtcmVhbC1tb2RlXT0iZ2l0Oi8vb3RjZ2l0LmpmLmludGVsLmNvbS9qc2Fra2lu
ZS9saW51eC1yZWFsbW9kZS5naXQiIFtubWVub25dPSJnaXQ6Ly9naXRodWIuY29tL25tZW5v
bi9saW51eC0yLjYtcGxheWdyb3VuZC5naXQiIFtjbG9ja2V2ZW50c109ImdpdDovL2dpdC5s
aW5hcm8ub3JnL3Blb3BsZS9kbGV6Y2Fuby9jbG9ja2V2ZW50cyIgW21lbmdkb25nXT0iZ2l0
Oi8vYmVlLnNoLmludGVsLmNvbS9naXQvbWVuZ2Rvbmcvc291bmQuZ2l0IiBbYW5kcm9pZC10
ZWdyYV09Imh0dHBzOi8vYW5kcm9pZC5nb29nbGVzb3VyY2UuY29tL2tlcm5lbC90ZWdyYSIg
W3BoeV09ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9r
aXNob24vbGludXgtcGh5LmdpdCIgW2l3bHdpZmktZml4ZXNdPSJnaXQ6Ly9naXQua2VybmVs
Lm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvaXdsd2lmaS9pd2x3aWZpLWZpeGVzLmdp
dCIgW25zZWtoYXItZGF2aW5jaV09ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGlu
dXgva2VybmVsL2dpdC9uc2VraGFyL2xpbnV4LWRhdmluY2kiIFthcm0tcGxhdGZvcm1zXT0i
Z2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L21hei9hcm0t
cGxhdGZvcm1zLmdpdCIgW3N0YWJsZV09ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20v
bGludXgva2VybmVsL2dpdC9zdGFibGUvbGludXgtc3RhYmxlLmdpdCIgW3BhdWx1cy1wb3dl
cnBjXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3Bh
dWx1cy9wb3dlcnBjLmdpdCIgW25mc2RdPSJnaXQ6Ly9saW51eC1uZnMub3JnL35iZmllbGRz
L2xpbnV4LmdpdCIgW3NwaV09ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgv
a2VybmVsL2dpdC9icm9vbmllL3NwaSIgW3JvZ2VycV09ImdpdDovL2dpdGh1Yi5jb20vcm9n
ZXJxL2xpbnV4IiBbaWRvXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9r
ZXJuZWwvZ2l0L2lkby9saW51eC5naXQiIFtqZ2FyemlrXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5v
cmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2pnYXJ6aWsvbGludXguZ2l0IiBba3M4Njk1
XT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2dlcmcv
a3M4Njk1LmdpdCIgW3NvdW5kLXVuc3RhYmxlXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHVi
L3NjbS9saW51eC9rZXJuZWwvZ2l0L3Rpd2FpL3NvdW5kLXVuc3RhYmxlLmdpdCIgW2FhXT0i
Z2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2FuZHJlYS9h
YS5naXQiIFtybWstYXJtXT0iZ2l0Oi8vZnRwLmFybS5saW51eC5vcmcudWsvfnJtay9saW51
eC1hcm0iIFtyb2JoXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJu
ZWwvZ2l0L3JvYmgvbGludXgiIFtzb2MtdGhlcm1hbF09ImdpdDovL2dpdC5rZXJuZWwub3Jn
L3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9ldmFsZW50aS9saW51eC1zb2MtdGhlcm1hbCIg
W2t2bS10b29sXT0iZ2l0Oi8vZ2l0aHViLmNvbS9wZW5iZXJnL2xpbnV4LWt2bS5naXQiIFtn
eHRdPSJnaXQ6Ly9naXRodWIuY29tL2d4dC9saW51eCIgW25vdGlmeV09ImdpdDovL2dpdC5p
bmZyYWRlYWQub3JnL3VzZXJzL2VwYXJpcy9ub3RpZnkiIFtkZXZmcmVxXT0iZ2l0Oi8vZ2l0
Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L216eC9kZXZmcmVxIiBbZXh0
Y29uXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L216
eC9leHRjb24uZ2l0IiBbdHJhY2VdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xp
bnV4L2tlcm5lbC9naXQvcm9zdGVkdC9saW51eC10cmFjZS5naXQiIFtmaXJld2lyZV09Imdp
dDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9pZWVlMTM5NC9s
aW51eDEzOTQuZ2l0IiBbYXBtXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51
eC9rZXJuZWwvZ2l0L2ppa29zL2FwbSIgW2Jhb2h1YV09ImdpdDovL2dpdC5rZXJuZWwub3Jn
L3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9iYW9odWEvbGludXgiIFt5dWFuaGFuXT0iZ2l0
Oi8vYmVlLnNoLmludGVsLmNvbS9naXQveWxpdS9saW51eC5naXQiIFtvbWFwLWRzczJdPSJn
aXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdG9tYmEvbGlu
dXguZ2l0IiBbaW50ZXJuYWwtaGFzd2VsbF09ImdpdDovL290Y2dpdC5qZi5pbnRlbC5jb20v
ZWRvZG9ub3Yva2VybmVsLWhzdy5naXQiIFtzb2NmcGdhLW5leF09ImdpdDovL2dpdC5yb2Nr
ZXRib2FyZHMub3JnL2xpbnV4LXNvY2ZwZ2EtbmV4dCIgW21wYzV4eHhdPSJnaXQ6Ly9naXQu
ZGVueC5kZS9saW51eC0yLjYtYWd1c3QuZ2l0IiBbYmFsYW5jZW51bWFdPSJnaXQ6Ly9naXQu
a2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvbWVsL2xpbnV4LWJhbGFuY2Vu
dW1hIiBbbmV0LW5leHRdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tl
cm5lbC9naXQvZGF2ZW0vbmV0LW5leHQuZ2l0IiBba2J1aWxkXT0iZ2l0Oi8vZ2l0Lmtlcm5l
bC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L21tYXJlay9rYnVpbGQuZ2l0IiBbdnN5
cmphbGFdPSJnaXQ6Ly9naXRvcmlvdXMub3JnL3ZzeXJqYWxhL2xpbnV4IiBbZnJ2XT0iZ2l0
Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2Rob3dlbGxzL2xp
bnV4LWZydiIgW3JhZGVvbi1hbGV4XT0iZ2l0Oi8vcGVvcGxlLmZyZWVkZXNrdG9wLm9yZy9+
YWdkNWYvbGludXguZ2l0IiBbZXA5M3h4XT0iZ2l0Oi8vZ2l0aHViLmNvbS9SeWFuTWFsbG9u
L2xpbnV4LWVwOTN4eC5naXQiIFtyYWZhZWwtcmVuZXNhc109ImdpdDovL2dpdC5rZXJuZWwu
b3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9yYWZhZWwvcmVuZXNhcy5naXQiIFtzbWFj
a109ImdpdDovL2dpdC5naXRvcmlvdXMub3JnL3NtYWNrLW5leHQva2VybmVsLmdpdCIgW29j
ZnMyXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2ps
YmVjL29jZnMyLmdpdCIgW25mc109ImdpdDovL2dpdC5saW51eC1uZnMub3JnL3Byb2plY3Rz
L3Ryb25kbXkvbGludXgtbmZzLmdpdCIgW2V4dDRdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9w
dWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdHl0c28vZXh0NC5naXQiIFtkcm1dPSJnaXQ6Ly9w
ZW9wbGUuZnJlZWRlc2t0b3Aub3JnL35haXJsaWVkL2xpbnV4LmdpdCIgW250Yl09ImdpdDov
L2dpdGh1Yi5jb20vam9ubWFzb24vbnRiIiBbbHBjMzJ4eF09ImdpdDovL2dpdC5hbnRjb20u
ZGUvbGludXgtMi42LmdpdCIgW3dyaXRlYmFja109ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1
Yi9zY20vbGludXgva2VybmVsL2dpdC93ZmcvbGludXguZ2l0IiBbc2xhYl09ImdpdDovL2dp
dC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9wZW5iZXJnL2xpbnV4Lmdp
dCIgW2lkZV09ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dp
dC9kYXZlbS9pZGUuZ2l0IiBbZHJkYl09ImdpdDovL2dpdC5kcmJkLm9yZy9saW51eC1kcmJk
LmdpdCIgW2FrXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwv
Z2l0L2FrL2xpbnV4LW1pc2MuZ2l0IiBbdHBtZGRdPSJnaXQ6Ly9naXRodWIuY29tL3NocGVk
b2lrYWwvbGludXgiIFtsdW5uXT0iZ2l0Oi8vZ2l0aHViLmNvbS9sdW5uL2xpbnV4LmdpdCIg
W3hlbl09ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9r
b25yYWQveGVuLmdpdCIgW3JlZ3VsYXRvcl09ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9z
Y20vbGludXgva2VybmVsL2dpdC9icm9vbmllL3JlZ3VsYXRvci5naXQiIFtqYmFybmVzXT0i
Z2l0Oi8vcGVvcGxlLmZyZWVkZXNrdG9wLm9yZy9+amJhcm5lcy9saW51eCIgW2ludGVybmFs
LWF6YWJvcm93XT0iZ2l0Oi8vb3RjZ2l0LmpmLmludGVsLmNvbS9hemFib3Jvdy9saW51eC5n
aXQiIFthbGV4c2hpXT0iaHR0cHM6Ly9naXRodWIuY29tL2FsZXhzaGkvcG93ZXItc2NoZWR1
bGluZy5naXQiIFthbmRyb2lkLWdvbGRmaXNoXT0iaHR0cHM6Ly9hbmRyb2lkLmdvb2dsZXNv
dXJjZS5jb20va2VybmVsL2dvbGRmaXNoIiBbbHV0b109ImdpdDovL2dpdC5rZXJuZWwub3Jn
L3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9sdXRvL2xpbnV4LmdpdCIgW3ZleHByZXNzXT0i
Z2l0Oi8vZ2l0LmxpbmFyby5vcmcvcGVvcGxlL3Bhd2VsbW9sbC9saW51eC5naXQiIFtzYW1z
dW5nLWNsa109ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dp
dC90ZmlnYS9zYW1zdW5nLWNsayIgW29wZW5yaXNjLWpvbmFzXT0iZ2l0Oi8vb3BlbnJpc2Mu
bmV0L2pvbmFzL2xpbnV4IiBbcnBpXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9s
aW51eC9rZXJuZWwvZ2l0L3N3YXJyZW4vbGludXgtcnBpLmdpdCIgW3RqLW1pc2NdPSJnaXQ6
Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGovbWlzYy5naXQi
IFtrZWl0aHBdPSJnaXQ6Ly9wZW9wbGUuZnJlZWRlc2t0b3Aub3JnL35rZWl0aHAvbGludXgi
IFthbHBoYV09ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dp
dC9tYXR0c3Q4OC9hbHBoYSIgW3BjbW9vcmUtc2VsaW51eF09ImdpdDovL2dpdC5pbmZyYWRl
YWQub3JnL3VzZXJzL3BjbW9vcmUvc2VsaW51eCIgW2RsZXpjYW5vXT0iZ2l0Oi8vZ2l0Lmxp
bmFyby5vcmcvcGVvcGxlL2RsZXpjYW5vL2xpbnV4IiBba2V5c3RvbmVdPSJnaXQ6Ly9naXQu
a2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvc3NhbnRvc2gvbGludXgta2V5
c3RvbmUiIFt2aXJlc2hrXT0iZ2l0Oi8vZ2l0LmxpbmFyby5vcmcvcGVvcGxlL3ZpcmVzaGsv
bGludXgiIFtpcHNlYy1uZXh0XT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51
eC9rZXJuZWwvZ2l0L2tsYXNzZXJ0L2lwc2VjLW5leHQuZ2l0IiBbd210XT0iZ2l0Oi8vZ2l0
LmNvZGUuc2YubmV0L3AvbGludXh3bXQvY29kZSIgW3RpbGVdPSJnaXQ6Ly9naXQua2VybmVs
Lm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvY21ldGNhbGYvbGludXgtdGlsZS5naXQi
IFthcm0taW50ZWdyYXRvcl09ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgv
a2VybmVsL2dpdC9saW51c3cvbGludXgtaW50ZWdyYXRvci5naXQiIFtzaWduYWxdPSJnaXQ6
Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdmlyby9zaWduYWwu
Z2l0IiBba29ucmFkLW1tXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9r
ZXJuZWwvZ2l0L2tvbnJhZC9tbS5naXQiIFtpbmZpbmliYW5kXT0iZ2l0Oi8vZ2l0Lmtlcm5l
bC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3JvbGFuZC9pbmZpbmliYW5kLmdpdCIg
W2t2bXMzOTBdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9n
aXQva3ZtczM5MC9saW51eCIgW2R2ZGhybV09ImdpdDovL3Blb3BsZS5mcmVlZGVza3RvcC5v
cmcvfmR2ZGhybS9saW51eCIgW3dhdGNoZG9nLW5leHRdPSJnaXQ6Ly93d3cubGludXgtd2F0
Y2hkb2cub3JnL2xpbnV4LXdhdGNoZG9nLW5leHQuZ2l0IiBbcmFuZG9tXT0iZ2l0Oi8vZ2l0
Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3R5dHNvL3JhbmRvbS5naXQi
IFtqb2xzYS1wZXJmXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJu
ZWwvZ2l0L2pvbHNhL3BlcmYuZ2l0IiBbY2hhci1taXNjXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5v
cmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2dyZWdraC9jaGFyLW1pc2MuZ2l0IiBbYXZy
MzJdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZWd0
dmVkdC9saW51eC1hdnIzMiIgW252bWVdPSJnaXQ6Ly9naXQuaW5mcmFkZWFkLm9yZy91c2Vy
cy93aWxseS9saW51eC1udm1lIiBbaW50ZWwtbmV0XT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcv
cHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3Bwd2Fza2llL25ldC5naXQiIFt1YmldPSJnaXQ6
Ly9naXQuaW5mcmFkZWFkLm9yZy9saW51eC11YmkuZ2l0IiBbc2ZjXT0iZ2l0Oi8vZ2l0Lmtl
cm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2J3aC9zZmMiIFtyZW1vdGVwcm9j
XT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L29oYWQv
cmVtb3RlcHJvYy5naXQiIFthc29jXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9s
aW51eC9rZXJuZWwvZ2l0L2Jyb29uaWUvc291bmQuZ2l0IiBbcmVpc2VyZnNdPSJnaXQ6Ly9n
aXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvamVmZm0vbGludXgtcmVp
c2VyZnMuZ2l0IiBbcnlkYmVyZ109ImdpdDovL2dpdGh1Yi5jb20vcnlkYmVyZy9saW51eCIg
W2Jyb29uaWUtbWlzY109ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2Vy
bmVsL2dpdC9icm9vbmllL21pc2MuZ2l0IiBbd2lyZWxlc3MtdGVzdGluZ109ImdpdDovL2dp
dC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9saW52aWxsZS93aXJlbGVz
cy10ZXN0aW5nLmdpdCIgW3Zmc109ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGlu
dXgva2VybmVsL2dpdC92aXJvL3Zmcy5naXQiIFt0aXBdPSJnaXQ6Ly9naXQua2VybmVsLm9y
Zy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGlwL3RpcC5naXQiIFtkaWdzaWddPSJnaXQ6
Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQva2FzYXRraW4vbGlu
dXgtZGlnc2lnLmdpdCIgW3NyaXZhdHNhYmhhdF09ImdpdDovL2dpdGh1Yi5jb20vc3JpdmF0
c2FiaGF0L2xpbnV4LmdpdCIgW3RjaGVuXT0iZ2l0Oi8vYmVlLnNoLmludGVsLmNvbS9naXQv
dGNoZW4zNy9saW51eC5naXQiIFt1a2xdPSJnaXQ6Ly9naXQucGVuZ3V0cm9uaXguZGUvZ2l0
L3VrbC9saW51eCIgW3V4NTAwXT0iZ2l0Oi8vZ2l0LmxpbmFyby5vcmcvcGVvcGxlL2xqb25l
cy9saW51eC0zLjAtdXg1MDAuZ2l0IiBbc2Ftc3VuZ109ImdpdDovL2dpdC5pbmZyYWRlYWQu
b3JnL3VzZXJzL2ttcGFyay9saW51eC1zYW1zdW5nIiBbcGNpXT0iZ2l0Oi8vZ2l0Lmtlcm5l
bC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2hlbGdhYXMvcGNpLmdpdCIgW21uMTAz
MDBdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZGhv
d2VsbHMvbGludXgtbW4xMDMwMCIgW2dsb21tZXItbWVtY2ddPSJnaXQ6Ly9naXQua2VybmVs
Lm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZ2xvbW1lci9tZW1jZy5naXQiIFtrY29u
ZmlnXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3Jv
c3RlZHQvbGludXgta2NvbmZpZy5naXQiIFtzaF09ImdpdDovL2dpdGh1Yi5jb20vcG11bmR0
L2xpbnV4LXNoLmdpdCIgW25mYy1maXhlc109ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9z
Y20vbGludXgva2VybmVsL2dpdC9zYW1lby9uZmMtZml4ZXMiIFttaWtsb3MtdmZzXT0iZ2l0
Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L21zemVyZWRpL3Zm
cy5naXQiIFttZmQtZml4ZXNdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4
L2tlcm5lbC9naXQvc2FtZW8vbWZkLWZpeGVzIiBbbWVtY2ddPSJnaXQ6Ly9naXQua2VybmVs
Lm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvbWhvY2tvL21tLmdpdCIgW2RtYS1idWZd
PSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvc3VtaXRz
L2RtYS1idWYiIFttZXRhZ109ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgv
a2VybmVsL2dpdC9qaG9nYW4vbWV0YWciIFtzeXNjdGxdPSJnaXQ6Ly9naXQua2VybmVsLm9y
Zy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZWJpZWRlcm0vc3lzY3RsLmdpdCIgW2piYXJu
ZXMtZHJtLWludGVsXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJu
ZWwvZ2l0L2piYXJuZXMvZHJtLWludGVsLmdpdCIgW2dyYW50XT0iZ2l0Oi8vZ2l0LnNlY3Jl
dGxhYi5jYS9naXQvbGludXgtMi42LmdpdCIgW3lpbmdoYWldPSJnaXQ6Ly9naXQua2VybmVs
Lm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQveWluZ2hhaS9saW51eC15aW5naGFpLmdp
dCIgW3Bvd2VycGMtNHh4XT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9r
ZXJuZWwvZ2l0L2p3Ym95ZXIvcG93ZXJwYy00eHguZ2l0IiBbZ2FsYWstcG93ZXJwY109Imdp
dDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9nYWxhay9wb3dl
cnBjLmdpdCIgW21mbGVtaW5nXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51
eC9rZXJuZWwvZ2l0L21mbGVtaW5nL2xpbnV4LmdpdCIgW3Rob21hc2hdPSJnaXQ6Ly9wZW9w
bGUuZnJlZWRlc2t0b3Aub3JnL350aG9tYXNoL2xpbnV4IiBbYXJtLXNvY109ImdpdDovL2dp
dC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9hcm0vYXJtLXNvYy5naXQi
IFt3cV09ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90
ai93cS5naXQiIFt1c2VybnNdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4
L2tlcm5lbC9naXQvZWJpZWRlcm0vdXNlci1uYW1lc3BhY2UuZ2l0IiBbY2VwaF09ImdpdDov
L2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9zYWdlL2NlcGgtY2xp
ZW50LmdpdCIgW2F0aDZrbF09ImdpdDovL2dpdGh1Yi5jb20va3ZhbG8vYXRoIiBbbXJdPSJn
aXQ6Ly9saW51eC1hcm0ub3JnL2xpbnV4LW1yIiBbamRlbHZhcmUtc3RhZ2luZ109ImdpdDov
L2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9qZGVsdmFyZS9zdGFn
aW5nLmdpdCIgW2t2bS1hcm1dPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4
L2tlcm5lbC9naXQvcnVzdHkvbGludXgta3ZtLWFybS5naXQiIFtzMzkwXT0iZ2l0Oi8vZ2l0
Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3MzOTAvbGludXguZ2l0IiBb
aW50ZWdyaXR5XT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwv
Z2l0L3pvaGFyL2xpbnV4LWludGVncml0eS5naXQiIFthdWRpdF09ImdpdDovL2dpdC5rZXJu
ZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC92aXJvL2F1ZGl0LmdpdCIgW2ludGVy
bmFsLWJ5dF09Imh0dHA6Ly9iYXl0LWdpdC1zZXJ2ZXIuYmouaW50ZWwuY29tOjgwODAvYnl0
X3RfbGludXgiIFtraGlsbWFuXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51
eC9rZXJuZWwvZ2l0L2toaWxtYW4vbGludXguZ2l0IiBbcGxhdGZvcm0tZHJpdmVycy14ODZd
PSJnaXQ6Ly9jYXZhbi5jb2Rvbi5vcmcudWsvcGxhdGZvcm0tZHJpdmVycy14ODYiIFtqYmFy
bmVzLXBjaV09ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dp
dC9qYmFybmVzL3BjaS5naXQiIFtibHVldG9vdGhdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9w
dWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvYmx1ZXRvb3RoL2JsdWV0b290aC1uZXh0LmdpdCIg
W2JhY2tsaWdodF09ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVs
L2dpdC9sZWUvYmFja2xpZ2h0LmdpdCIgW3ViaWZzXT0iZ2l0Oi8vZ2l0LmluZnJhZGVhZC5v
cmcvbGludXgtdWJpZnMuZ2l0IiBbdWFwaV09ImdpdDovL2dpdC5pbmZyYWRlYWQub3JnL3Vz
ZXJzL2Rob3dlbGxzL2xpbnV4LWhlYWRlcnMuZ2l0IiBbbW9kc2lnbl09ImdpdDovL2dpdC5r
ZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9kaG93ZWxscy9saW51eC1tb2Rz
aWduLmdpdCIgW2pvc2VmLWJ0cmZzXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9s
aW51eC9rZXJuZWwvZ2l0L2pvc2VmL2J0cmZzLW5leHQuZ2l0IiBbaGlkXT0iZ2l0Oi8vZ2l0
Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2ppa29zL2hpZC5naXQiIFtz
a25dPSJnaXQ6Ly9saW51eC1hcm0ub3JnL2xpbnV4LXNrbiIgW21tb3RtXT0iZ2l0Oi8vZ2l0
LmNtcHhjaGcub3JnL2xpbnV4LW1tb3RtLmdpdCIgW2F0bV09ImdpdDovL2dpdC5pbmZyYWRl
YWQub3JnL3VzZXJzL2R3bXcyL2F0bSIgW2tlZXNdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9w
dWIvc2NtL2xpbnV4L2tlcm5lbC9naXQva2Vlcy9saW51eC5naXQiIFtwb3dlcnBjXT0iZ2l0
Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2JlbmgvcG93ZXJw
Yy5naXQiIFtuZXRkZXYtbmV4dF09ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGlu
dXgva2VybmVsL2dpdC9qa2lyc2hlci9uZXQtbmV4dC5naXQiIFtsMi1tdGRdPSJnaXQ6Ly9n
aXQuaW5mcmFkZWFkLm9yZy91c2Vycy9kZWRla2luZC9sMi1tdGQuZ2l0IiBba3ZtXT0iZ2l0
Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS92aXJ0L2t2bS9rdm0uZ2l0IiBbYWdrLWRtXT0i
Z2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2Fnay9saW51
eC1kbSIgW3JhZGVvbl09ImdpdDovL3Blb3BsZS5mcmVlZGVza3RvcC5vcmcvfmRlYXRoc2lt
cGxlL2xpbnV4LmdpdCIgW3ByZWV0aV09Imh0dHBzOi8vZ2l0aHViLmNvbS9wcmVldGktdS1t
dXJ0aHkvbGludXguZ2l0IiBbaWlvXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9s
aW51eC9rZXJuZWwvZ2l0L2ppYzIzL2lpby5naXQiIFtuZXRdPSJnaXQ6Ly9naXQua2VybmVs
Lm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZGF2ZW0vbmV0LmdpdCIgW2F1ZGl0LW5l
eHRdPSJnaXQ6Ly90b2NjYXRhMi50cmljb2xvdXIuY2EvbGludXgtMi42LXJnYi5naXQiIFth
Y3BpXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2xl
bmIvbGludXguZ2l0IiBbcHMzXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51
eC9rZXJuZWwvZ2l0L2dlb2ZmL3BzMy1saW51eC5naXQiIFtkaG93ZWxscy1mc109ImdpdDov
L2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9kaG93ZWxscy9saW51
eC1mcyIgW2lwc2VjXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJu
ZWwvZ2l0L2tsYXNzZXJ0L2lwc2VjLmdpdCIgW2lteF09ImdpdDovL2dpdC5wZW5ndXRyb25p
eC5kZS9naXQvaW14L2xpbnV4LTIuNi5naXQiIFtoemh1YW5nMV09ImdpdDovL2dpdC5rZXJu
ZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9oemh1YW5nMS9saW51eCIgW3BpbmN0
cmxdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvbGlu
dXN3L2xpbnV4LXBpbmN0cmwuZ2l0IiBbYXJtLXVjbGludXhdPSJnaXQ6Ly9naXQua2VybmVs
Lm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZ2VyZy91Y2xpbnV4LmdpdCIgW2R0Y109
ImdpdDovL2dpdC5qZGwuY29tL3NvZnR3YXJlL2R0Yy5naXQiIFtyZW5lc2FzXT0iZ2l0Oi8v
Z2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2hvcm1zL3JlbmVzYXMu
Z2l0IiBbY3JdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9n
aXQvZ29yY3Vub3YvbGludXgtY3IuZ2l0IiBbam9sc2EtdW53aW5kXT0iZ2l0Oi8vZ2l0Lmtl
cm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2pvbHNhL2xpbnV4LXVud2luZC5n
aXQiIFtjb25maWdmc109ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2Vy
bmVsL2dpdC9qbGJlYy9jb25maWdmcy5naXQiIFtibG9ja109ImdpdDovL2dpdC5rZXJuZWwu
ZGsvbGludXgtYmxvY2suZ2l0IiBbYmNhY2hlXT0iZ2l0Oi8vZXZpbHBpZXBpcmF0ZS5vcmcv
fmtlbnQvbGludXgtYmNhY2hlLmdpdCIgW2hleGFnb25dPSJnaXQ6Ly9naXQua2VybmVsLm9y
Zy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvcmt1by9saW51eC1oZXhhZ29uLWtlcm5lbC5n
aXQiIFtwanQtc2NoZWRdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tl
cm5lbC9naXQvcGp0L2xpbnNjaGVkLmdpdCIgW2xwMF09ImdpdDovL2dpdGh1Yi5jb20vbHAw
L2xpbnV4IiBbd2wxMnh4XT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9r
ZXJuZWwvZ2l0L2x1Y2Evd2wxMnh4LmdpdCIgW29tYXAtZHRdPSJnaXQ6Ly9naXQua2VybmVs
Lm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvYmNvdXNzb24vbGludXgtb21hcC1kdC5n
aXQiIFtrZXlzXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwv
Z2l0L2Rob3dlbGxzL3NlY3VyaXR5LWtleXMuZ2l0IiBbY2FseGVkYV09ImdpdDovL3NvdXJj
ZXMuY2FseGVkYS5jb20va2VybmVsL2xpbnV4LmdpdCIgW2xqb25lcy1tZmRdPSJnaXQ6Ly9n
aXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvbGVlL21mZC5naXQiIFth
bmRyb2lkLWxrXT0iaHR0cHM6Ly9hbmRyb2lkLmdvb2dsZXNvdXJjZS5jb20va2VybmVsL2xr
IiBbbWlwcy1qb2huXT0iZ2l0Oi8vZ2l0LmxpbnV4LW1pcHMub3JnL3B1Yi9zY20vam9obi9s
aW51eC1qb2huIiBbeHRlbnNhXT0iZ2l0Oi8vZ2l0aHViLmNvbS9jemFua2VsL3h0ZW5zYS1s
aW51eCIgW21pcHMtZGFuZXldPSJnaXQ6Ly9naXQubGludXgtbWlwcy5vcmcvcHViL3NjbS9k
YW5leS91cHN0cmVhbS1kYW5leSIgW3BhdWxnXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHVi
L3NjbS9saW51eC9rZXJuZWwvZ2l0L3BhdWxnL2xpbnV4LmdpdCIgW21tY109ImdpdDovL2dp
dC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9jamIvbW1jLmdpdCIgW21p
cHNdPSJnaXQ6Ly9naXQubGludXgtbWlwcy5vcmcvcHViL3NjbS9yYWxmL3Vwc3RyZWFtLWxp
bnVzLmdpdCIgW2RsbV09ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2Vy
bmVsL2dpdC90ZWlnbGFuZC9saW51eC1kbG0uZ2l0IiBbYnRyZnNdPSJnaXQ6Ly9naXQua2Vy
bmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvbWFzb24vbGludXgtYnRyZnMuZ2l0
IiBbY2hyb21lXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwv
Z2l0L29sb2YvY2hyb21lLXBsYXRmb3JtIiBbYW5kcm9pZC1zYW1zdW5nXT0iaHR0cHM6Ly9h
bmRyb2lkLmdvb2dsZXNvdXJjZS5jb20va2VybmVsL3NhbXN1bmciIFt3ZmddPSJnaXQ6Ly9i
ZWUuc2guaW50ZWwuY29tL2dpdC93ZmcvbGludXgtZGV2ZWwuZ2l0IiBbYWFyY2g2NF09Imdp
dDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9jbWFyaW5hcy9s
aW51eC1hYXJjaDY0LmdpdCIgW2lvbW11XT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3Nj
bS9saW51eC9rZXJuZWwvZ2l0L2pvcm8vaW9tbXUuZ2l0IiBbYmFsYmktdXNiXT0iZ2l0Oi8v
Z2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2JhbGJpL3VzYi5naXQi
IFthcm02NF09ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dp
dC9hcm02NC9saW51eCIgW2FyY109ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGlu
dXgva2VybmVsL2dpdC92Z3VwdGEvYXJjIiBbdmZpb109ImdpdDovL2dpdGh1Yi5jb20vYXdp
bGxpYW0vbGludXgtdmZpby5naXQiIFt4aGNpXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHVi
L3NjbS9saW51eC9rZXJuZWwvZ2l0L3NhcmFoL3hoY2kuZ2l0IiBbY2dyb3VwXT0iZ2l0Oi8v
Z2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RqL2Nncm91cC5naXQi
IFthbmRyb2lkLW9tYXBdPSJodHRwczovL2FuZHJvaWQuZ29vZ2xlc291cmNlLmNvbS9rZXJu
ZWwvb21hcCIgW3dhdGNoZG9nXT0iZ2l0Oi8vd3d3LmxpbnV4LXdhdGNoZG9nLm9yZy9saW51
eC13YXRjaGRvZy5naXQiIFtjaWZzXT0iZ2l0Oi8vZ2l0LnNhbWJhLm9yZy9zZnJlbmNoL2Np
ZnMtMi42LmdpdCIgW29tYXAtYXVkaW9dPSJnaXQ6Ly9naXRvcmlvdXMub3JnL29tYXAtYXVk
aW8vbGludXgtYXVkaW8iIFttNjhrbm9tbXVdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIv
c2NtL2xpbnV4L2tlcm5lbC9naXQvZ2VyZy9tNjhrbm9tbXUuZ2l0IiBbYXJtLXBlcmZdPSJn
aXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvd2lsbC9saW51
eC5naXQiIFtzZWN1cml0eV09ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgv
a2VybmVsL2dpdC9qbW9ycmlzL2xpbnV4LXNlY3VyaXR5LmdpdCIgW2VmaV09ImdpdDovL2dp
dC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9tZmxlbWluZy9lZmkuZ2l0
IiBbdGVncmFdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9n
aXQvdGVncmEvbGludXgiIFttZmQtbmV4dF09ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9z
Y20vbGludXgva2VybmVsL2dpdC9zYW1lby9tZmQtbmV4dC5naXQiIFthbmRyb2lkLW1zbV09
Imh0dHBzOi8vYW5kcm9pZC5nb29nbGVzb3VyY2UuY29tL2tlcm5lbC9tc20iIFt3c2FdPSJn
aXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvd3NhL2xpbnV4
IiBbaWFuY109ImdpdDovL3hlbmJpdHMueGVuLm9yZy9wZW9wbGUvaWFuYy9saW51eCIgW29t
YXBdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdG1s
aW5kL2xpbnV4LW9tYXAuZ2l0IiBbdGFyZ2V0XT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHVi
L3NjbS9saW51eC9rZXJuZWwvZ2l0L25hYi90YXJnZXQtcGVuZGluZy5naXQiIFtzdGFnaW5n
XT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2dyZWdr
aC9zdGFnaW5nLmdpdCIgW25mYy1uZXh0XT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3Nj
bS9saW51eC9rZXJuZWwvZ2l0L3NhbWVvL25mYy1uZXh0LmdpdCIgW21kXT0iZ2l0Oi8vbmVp
bC5icm93bi5uYW1lL21kIiBbY2RhbGwta3ZtLWFybV09ImdpdDovL2dpdC5saW5hcm8ub3Jn
L3Blb3BsZS9jZGFsbC9saW51eC1rdm0tYXJtIiBbcm9iY2xhcmtdPSJnaXQ6Ly9wZW9wbGUu
ZnJlZWRlc2t0b3Aub3JnL35yb2JjbGFyay9saW51eCIgW3BhcmlzY109ImdpdDovL2dpdC5r
ZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9qZWpiL3BhcmlzYy0yLjYuZ2l0
IiBbc2xhdmUtZG1hXT0iZ2l0Oi8vZ2l0LmluZnJhZGVhZC5vcmcvdXNlcnMvdmtvdWwvc2xh
dmUtZG1hLmdpdCIgW2plcmVteS14ZW5dPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2Nt
L2xpbnV4L2tlcm5lbC9naXQvamVyZW15L3hlbi5naXQiIFttdmVidV09ImdpdDovL2dpdC5p
bmZyYWRlYWQub3JnL2xpbnV4LW12ZWJ1IiBbZHZoYXJ0XT0iZ2l0Oi8vZ2l0LmluZnJhZGVh
ZC5vcmcvdXNlcnMvZHZoYXJ0L2xpbnV4LmdpdCIgW2FuZHJvaWQtY29tbW9uXT0iaHR0cHM6
Ly9hbmRyb2lkLmdvb2dsZXNvdXJjZS5jb20va2VybmVsL2NvbW1vbiIgW3N0cl09ImdpdDov
L2dpdC5wZW5ndXRyb25peC5kZS9naXQvc3RyL2xpbnV4IiBbbWxhbmtob3JzdF09ImdpdDov
L3Blb3BsZS5mcmVlZGVza3RvcC5vcmcvfm1sYW5raG9yc3QvbGludXgiIFthc20tZ2VuZXJp
Y109ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9hcm5k
L2FzbS1nZW5lcmljIiBbc2hhZ2d5XT0iZ2l0Oi8vZ2l0aHViLmNvbS9rbGVpa2FtcC9saW51
eC1zaGFnZ3kiIFtub21hZGlrXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51
eC9rZXJuZWwvZ2l0L2xpbnVzdy9saW51eC1ub21hZGlrLmdpdCIgW29sZWddPSJnaXQ6Ly9n
aXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvb2xlZy9taXNjLmdpdCIg
W3NvdW5kXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0
L3Rpd2FpL3NvdW5kLmdpdCIgW2ludGVybmFsLWFjcGljYV09ImdpdDovL2JlZS5zaC5pbnRl
bC5jb20vZ2l0L3pldGFsb2cvbGludXgtYWNwaWNhLmdpdCIgW3BsYWduaW9qLWZiZGV2XT0i
Z2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3BsYWduaW9q
L2xpbnV4LWZiZGV2LmdpdCIgW25mLW5leHRdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIv
c2NtL2xpbnV4L2tlcm5lbC9naXQvcGFibG8vbmYtbmV4dCIgW2FuZHJvaWQtZXh5bm9zXT0i
aHR0cHM6Ly9hbmRyb2lkLmdvb2dsZXNvdXJjZS5jb20va2VybmVsL2V4eW5vcyIgW2JwXT0i
Z2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2JwL2JwIiBb
YXJtLXRlZ3JhXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwv
Z2l0L3N3YXJyZW4vbGludXgtdGVncmEuZ2l0IiBbdjlmc109ImdpdDovL2dpdC5rZXJuZWwu
b3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9lcmljdmgvdjlmcy5naXQiIFt1c2JdPSJn
aXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZ3JlZ2toL3Vz
Yi5naXQiIFtzcXVhc2hmc109ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgv
a2VybmVsL2dpdC9wa2wvc3F1YXNoZnMtbmV4dC5naXQiIFtvcGVudnN3aXRjaF09ImdpdDov
L2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9qZXNzZS9vcGVudnN3
aXRjaC5naXQiIFttbGluXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9r
ZXJuZWwvZ2l0L21saW4vbGludXguZ2l0IiBbc3BhcmNdPSJnaXQ6Ly9naXQua2VybmVsLm9y
Zy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZGF2ZW0vc3BhcmMuZ2l0IiBbbWFjODAyMTFd
PSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvamJlcmcv
bWFjODAyMTEuZ2l0IiBbc3dpb3RsYl09ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20v
bGludXgva2VybmVsL2dpdC9rb25yYWQvc3dpb3RsYiIgW2RybS1leHlub3NdPSJnaXQ6Ly9n
aXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZGFlaW5raS9kcm0tZXh5
bm9zIiBbd2lyZWxlc3NdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tl
cm5lbC9naXQvbGludmlsbGUvd2lyZWxlc3MuZ2l0IiBbdXByb2Jlc109ImdpdDovL2dpdGh1
Yi5jb20vc3Jpa2FyZC9saW51eC5naXQiIFtpc2NpXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcv
cHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2RqYncvaXNjaS5naXQiIFtpbnRlcm5hbC1ibHVl
dG9vdGgtaHNdPSJnaXQ6Ly9vdGNnaXQuamYuaW50ZWwuY29tL2FlbWVsdGNoL2JsdWV0b290
aC1ocy5naXQiIFttaWNdPSJodHRwczovL2dpdGh1Yi5jb20vc3VkZWVwZHV0dC9taWMuZ2l0
IiBbZHludGlja3NdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5l
bC9naXQvZnJlZGVyaWMvbGludXgtZHludGlja3MuZ2l0IiBbb21hcC1wbV09ImdpdDovL2dp
dC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9raGlsbWFuL2xpbnV4LW9t
YXAtcG0uZ2l0IiBbeGZzXT0iZ2l0Oi8vb3NzLnNnaS5jb20veGZzL3hmcyIgW2xpbnVzXT0i
Z2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRz
L2xpbnV4LmdpdCIgW3BldGVyaHVld2UtdHBtZGRdPSJnaXQ6Ly9naXRodWIuY29tL1BldGVy
SHVld2UvbGludXgtdHBtZGQuZ2l0IiBbdGlhbnl1XT0iZ2l0Oi8vYmVlLnNoLmludGVsLmNv
bS9naXQvdGlhbnl1L3VzYi5naXQiIFttNjhrXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHVi
L3NjbS9saW51eC9rZXJuZWwvZ2l0L2dlZXJ0L2xpbnV4LW02OGsuZ2l0IiBbcmN1XT0iZ2l0
Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3BhdWxtY2svbGlu
dXgtcmN1LmdpdCIgW2ludGVybmFsLXdmZ109ImdpdDovL2JlZS5zaC5pbnRlbC5jb20vZ2l0
L3dmZy9saW51eC5naXQiIFt0cml2aWFsLW1vZHNdPSJnaXQ6Ly9yZXBvLm9yLmN6L2xpbnV4
LTIuNi90cml2aWFsLW1vZHMuZ2l0IiBbY3Jpc109ImdpdDovL2puaS5udS9jcmlzIiBbZG1h
LW1hcHBpbmddPSJnaXQ6Ly9naXQubGluYXJvLm9yZy9wZW9wbGUvbXN6eXByb3dza2kvbGlu
dXgtZG1hLW1hcHBpbmcuZ2l0IiBbbGliYXRhXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHVi
L3NjbS9saW51eC9rZXJuZWwvZ2l0L2pnYXJ6aWsvbGliYXRhLWRldi5naXQiIFtsaW51eC1k
ZXZlbF09ImludGVybmFsX21lcmdlX2FuZF90ZXN0X3RyZWUiIFtlcGFyaXMtYXVkaXRdPSJn
aXQ6Ly9naXQuaW5mcmFkZWFkLm9yZy91c2Vycy9lcGFyaXMvYXVkaXQiIFtqaWtvcy1ibG9j
a109ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9qaWtv
cy9saW51eC1ibG9jay5naXQiIFtyZWdtYXBdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIv
c2NtL2xpbnV4L2tlcm5lbC9naXQvYnJvb25pZS9yZWdtYXAuZ2l0IiBbdmNnb21lcy1uZmNd
PSJnaXQ6Ly9naXQuaW5mcmFkZWFkLm9yZy91c2Vycy92Y2dvbWVzL2xpbnV4LW5mYy5naXQi
IFtibGFja2Zpbl09ImdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVs
L2dpdC9sbGl1YmJvL2JsYWNrZmluLmdpdCIgW29wZW4tb3NkXT0iZ2l0Oi8vZ2l0Lm9wZW4t
b3NkLm9yZy9saW51eC1vcGVuLW9zZC5naXQiIFtycG1zZ109ImdpdDovL2dpdC5rZXJuZWwu
b3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9vaGFkL3JwbXNnLmdpdCIgW3BtXT0iZ2l0
Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3JhZmFlbC9saW51
eC1wbS5naXQiIFtwY21jaWFdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4
L2tlcm5lbC9naXQvYnJvZG8vcGNtY2lhLmdpdCIgW210ZF09ImdpdDovL2dpdC5pbmZyYWRl
YWQub3JnL2xpbnV4LW10ZC5naXQiIFtncGlvXT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHVi
L3NjbS9saW51eC9rZXJuZWwvZ2l0L2xpbnVzdy9saW51eC1ncGlvLmdpdCIgW2ludGVybmFs
LWhsZV09ImdpdDovL290Y2dpdC5qZi5pbnRlbC5jb20vYWtsZWVuL3RzeC9saW51eC1obGUi
IFtjb2x1bWJpYS1rdm0tYXJtXT0iZ2l0Oi8vZ2l0aHViLmNvbS9jb2x1bWJpYS9saW51eC1r
dm0tYXJtLmdpdCIgW3hsbnhdPSJnaXQ6Ly9naXQueGlsaW54LmNvbS9saW51eC14bG54IiBb
YXBwYXJtb3JdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9n
aXQvamovbGludXgtYXBwYXJtb3IuZ2l0IiBbYXJtXT0iZ2l0Oi8vZnRwLmFybS5saW51eC5v
cmcudWsvcHViL2xpbnV4L2FybS9rZXJuZWwvZ2l0LWN1ci9saW51eC1hcm0uZ2l0IiBbdHJh
Y2luZ109ImdpdDovL2dpdGh1Yi5jb20vZndlaXNiZWMvdHJhY2luZyIgW3NlbGludXhdPSJn
aXQ6Ly9naXQuaW5mcmFkZWFkLm9yZy91c2Vycy9lcGFyaXMvc2VsaW51eC5naXQiIFtzY3Np
XT0iZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2plamIv
c2NzaS5naXQiIFtuZXRkZXZdPSJnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4
L2tlcm5lbC9naXQvamtpcnNoZXIvbmV0LmdpdCIgW2N1Ym94XT0iZ2l0Oi8vZnRwLmFybS5s
aW51eC5vcmcudWsvfnJtay9saW51eC1jdWJveCIgW2xpbnV4dHYtc2Ftc3VuZ109ImdpdDov
L2xpbnV4dHYub3JnL3NuYXdyb2NraS9zYW1zdW5nLmdpdCIgW2J5dGVzd2FwXT0iZ2l0Oi8v
Z2l0LmluZnJhZGVhZC5vcmcvdXNlcnMvZHdtdzIvYnl0ZXN3YXAiIFtsb2dmc109ImdpdDov
L2dpdGh1Yi5jb20vcHJhc2FkLWpvc2hpL2xvZ2ZzX3Vwc3RyZWFtLmdpdCIgW2JhdHRlcnld
PSJnaXQ6Ly9naXQuaW5mcmFkZWFkLm9yZy9iYXR0ZXJ5LTIuNi5naXQiIFtiYXRtYW5dPSJn
aXQ6Ly9naXQub3Blbi1tZXNoLm9yZy9saW51eC1tZXJnZSIgKQpyZXBvcnRlcl9lbWFpbD1m
ZW5nZ3Vhbmcud3VAaW50ZWwuY29tCnJlcG9ydGVyX25hbWU9J2tlcm5lbCB0ZXN0IHJvYm90
JwpyZXNldF9jb2xvcj0nXGVbMG0nCnNtdHA9bWFpbC5pbnRlbC5jb20Kc3JjX29ial9maWxl
X3BhdHRlcm49J1thLXpBLVowLTkvXy1dezIsfS9bYS16QS1aMC05Xy1dezEsfVwuKGN8aHxT
fG98a28pJwp0b2RheT0yMDE0LTAzLTIxCnVybD0KZ2l0IGNoZWNrb3V0IHYzLjEyCmVycm9y
OiBwYXRoc3BlYyAndjMuMTInIGRpZCBub3QgbWF0Y2ggYW55IGZpbGUocykga25vd24gdG8g
Z2l0LgoyMDE0LTAzLTIxIDE0OjAxOjM2OiBjbWRfZmFpbDogJy91c3IvbG9jYWwvYmluL2dp
dCcgJ2NoZWNrb3V0JyAnLS1xdWlldCcgJ3YzLjEyJyAsIHJldD0xLCByZWY6IC9rZXJuZWwt
dGVzdHMvZmFpbGVkLWNtZC9iZWUtYmlzZWN0LWNvbW1vbi5zaDo0MDQzLWdpdC13ZmcubG9n
CkhFQUQgaXMgbm93IGF0IDAxNjMxOWQgTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAn
Y29tcGF0L2NvbXBhdCcKZXJyb3I6IHBhdGhzcGVjICd2My4xMicgZGlkIG5vdCBtYXRjaCBh
bnkgZmlsZShzKSBrbm93biB0byBnaXQuCjIwMTQtMDMtMjEgMTQ6MDE6Mzc6IGNtZF9mYWls
OiAnL3Vzci9sb2NhbC9iaW4vZ2l0JyAnY2hlY2tvdXQnICctLXF1aWV0JyAndjMuMTInICwg
cmV0PTEsIHJlZjogL2tlcm5lbC10ZXN0cy9mYWlsZWQtY21kL2JlZS1iaXNlY3QtY29tbW9u
LnNoOjQwNDctZ2l0LXdmZy5sb2cKSEVBRCBpcyBub3cgYXQgMDE2MzE5ZCBNZXJnZSByZW1v
dGUtdHJhY2tpbmcgYnJhbmNoICdjb21wYXQvY29tcGF0JwplcnJvcjogcGF0aHNwZWMgJ3Yz
LjEyJyBkaWQgbm90IG1hdGNoIGFueSBmaWxlKHMpIGtub3duIHRvIGdpdC4KMjAxNC0wMy0y
MSAxNDowMTozODogY21kX2ZhaWw6ICcvdXNyL2xvY2FsL2Jpbi9naXQnICdjaGVja291dCcg
Jy0tcXVpZXQnICd2My4xMicgLCByZXQ9MSwgcmVmOiAva2VybmVsLXRlc3RzL2ZhaWxlZC1j
bWQvYmVlLWJpc2VjdC1jb21tb24uc2g6NDA1MS1naXQtd2ZnLmxvZwovdXNyL2Jpbi9iYXNl
bmFtZTogbWlzc2luZyBvcGVyYW5kClRyeSAnL3Vzci9iaW4vYmFzZW5hbWUgLS1oZWxwJyBm
b3IgbW9yZSBpbmZvcm1hdGlvbi4KMjAxNC0wMy0yMSAxNDowMTozODogY21kX2ZhaWw6ICcv
dXNyL2Jpbi9iYXNlbmFtZScgLCByZXQ9MSwgcmVmOiAva2VybmVsLXRlc3RzL2ZhaWxlZC1j
bWQvYmVlLWJpc2VjdC1jb21tb24uc2g6NDA1NS1iYXNlbmFtZS13ZmcubG9nCmdpdCBjaGVj
a291dCB2My4xMQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5k
Y29uZmlnLWJhMS0wMzIxMTIzNy9uZXh0Om1hc3Rlcjo2ZTQ2NjQ1MjViMWRiMjhmOGM0ZTEx
MzA5NTdmNzBhOTRjMTkyMTNlOmJpc2VjdC1zb3VuZAoKMjAxNC0wMy0yMS0xNDowMTo0OCA2
ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlIGNvbXBpbGluZwpRdWV1
ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNv
bmZpZy1iYTEtMDMyMTEyMzctNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5
MjEzZQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0w
MzIxMTIzNy82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlCndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJh
bmRjb25maWctYmExLTAzMjExMjM3LTZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5
NGMxOTIxM2UKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxk
LXF1ZXVlLy5pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LTZlNDY2NDUyNWIxZGIyOGY4
YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1iYTEtMDMyMTEyMzcvNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEz
ZS92bWxpbnV6LTMuMTEuMAoKMjAxNC0wMy0yMS0xNToxMDo0OSBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAJMS4uCTQJNQk2CTgJMTEJMTIuLi4uLi4uLi4uLi4uLi4uLi4JMTUJMjEgU1VDQ0VT
UwoKYmlzZWN0OiBnb29kIGNvbW1pdCB2My4xMQpnaXQgYmlzZWN0IHN0YXJ0IDAxNjMxOWQz
NzVjMDBkYjQwZGFjMTY1ZmNkYWVjNzhiNjcwOTQyNDMgdjMuMTEgLS0KL2Mva2VybmVsLXRl
c3RzL2xpbmVhci1iaXNlY3Q6IFsiLWIiLCAiMDE2MzE5ZDM3NWMwMGRiNDBkYWMxNjVmY2Rh
ZWM3OGI2NzA5NDI0MyIsICItZyIsICJ2My4xMSIsICIvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIiwgIi9ob21lL3dmZy9zb3VuZC9vYmotYmlzZWN0Il0K
QmlzZWN0aW5nOiA0ODcwMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgMTYgc3RlcHMpCls4NDNmNGY0YmIxYTJjNGMxOTZhMWFmMWQxOGJiNjQ3N2E1ODBh
Yzc4XSBNZXJnZSB0YWcgJ3RyYWNlLWZpeGVzLTMuMTMtcmMyJyBvZiBnaXQ6Ly9naXQua2Vy
bmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvcm9zdGVkdC9saW51eC10cmFjZQpy
dW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hv
bWUvd2ZnL3NvdW5kL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUv
a3ZtL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvbmV4dDptYXN0ZXI6ODQzZjRmNGJi
MWEyYzRjMTk2YTFhZjFkMThiYjY0NzdhNTgwYWM3ODpiaXNlY3Qtc291bmQKCjIwMTQtMDMt
MjEtMTU6MjU6MjYgODQzZjRmNGJiMWEyYzRjMTk2YTFhZjFkMThiYjY0NzdhNTgwYWM3OCBj
b21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1
ZS9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LTg0M2Y0ZjRiYjFhMmM0YzE5NmExYWYx
ZDE4YmI2NDc3YTU4MGFjNzgKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1iYTEtMDMyMTEyMzcvODQzZjRmNGJiMWEyYzRjMTk2YTFhZjFkMThiYjY0Nzdh
NTgwYWM3OAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQt
cXVldWUvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy04NDNmNGY0YmIxYTJjNGMxOTZh
MWFmMWQxOGJiNjQ3N2E1ODBhYzc4CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5l
bC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy04NDNm
NGY0YmIxYTJjNGMxOTZhMWFmMWQxOGJiNjQ3N2E1ODBhYzc4Cmtlcm5lbDogL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3Lzg0M2Y0ZjRiYjFhMmM0YzE5NmExYWYxZDE4
YmI2NDc3YTU4MGFjNzgvdm1saW51ei0zLjEzLjAtcmMyLTAwMzI2LWc4NDNmNGY0CgoyMDE0
LTAzLTIxLTE2OjI2OjI3IGRldGVjdGluZyBib290IHN0YXRlIC4uCTEuCTIuCTQJNS4uLi4J
Nwk4CTExCTE2CTIwCTIxIFNVQ0NFU1MKCkJpc2VjdGluZzogMjQ4MDYgcmV2aXNpb25zIGxl
ZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDE1IHN0ZXBzKQpbNWE1ZTc1ZjQ3MTRh
NTkyZjMxZTU3ZjI0OGI4ZjVjODY2ZjI3OGI4ZF0gdGlsZTogcmVtb3ZlIGNvbXBhdF9zeXNf
bG9va3VwX2Rjb29raWUgZGVjbGFyYXRpb24gdG8gZml4IGNvbXBpbGUgZXJyb3IKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dm
Zy9zb3VuZC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9p
Mzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3L25leHQ6bWFzdGVyOjVhNWU3NWY0NzE0YTU5
MmYzMWU1N2YyNDhiOGY1Yzg2NmYyNzhiOGQ6YmlzZWN0LXNvdW5kCgoyMDE0LTAzLTIxLTE2
OjM1OjMyIDVhNWU3NWY0NzE0YTU5MmYzMWU1N2YyNDhiOGY1Yzg2NmYyNzhiOGQgY29tcGls
aW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4
Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy01YTVlNzVmNDcxNGE1OTJmMzFlNTdmMjQ4Yjhm
NWM4NjZmMjc4YjhkCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctYmExLTAzMjExMjM3LzVhNWU3NWY0NzE0YTU5MmYzMWU1N2YyNDhiOGY1Yzg2NmYyNzhi
OGQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVl
L2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzctNWE1ZTc1ZjQ3MTRhNTkyZjMxZTU3ZjI0
OGI4ZjVjODY2ZjI3OGI4ZAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVz
dHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzctNWE1ZTc1ZjQ3
MTRhNTkyZjMxZTU3ZjI0OGI4ZjVjODY2ZjI3OGI4ZAprZXJuZWw6IC9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWJhMS0wMzIxMTIzNy81YTVlNzVmNDcxNGE1OTJmMzFlNTdmMjQ4YjhmNWM4
NjZmMjc4YjhkL3ZtbGludXotMy4xMy4wLTEwODQ0LWc1YTVlNzVmCgoyMDE0LTAzLTIxLTE2
OjU4OjMyIGRldGVjdGluZyBib290IHN0YXRlIC4JMi4JOQkxMgkxNQkxOAkxOQkyMSBTVUND
RVNTCgpCaXNlY3Rpbmc6IDEyMjA5IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSAxNCBzdGVwcykKWzcyMWYwYzEyNjA3NTI5NGU2NmRmNzMwNTFjYzJlMWQ3
OTVlZjIwOTVdIE1lcmdlIHRhZyAndHJhY2UtZml4ZXMtdjMuMTQtcmM1JyBvZiBnaXQ6Ly9n
aXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvcm9zdGVkdC9saW51eC10
cmFjZQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2ggL2hvbWUvd2ZnL3NvdW5kL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4t
cXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvbmV4dDptYXN0ZXI6NzIx
ZjBjMTI2MDc1Mjk0ZTY2ZGY3MzA1MWNjMmUxZDc5NWVmMjA5NTpiaXNlY3Qtc291bmQKCjIw
MTQtMDMtMjEtMTc6MDM6MDggNzIxZjBjMTI2MDc1Mjk0ZTY2ZGY3MzA1MWNjMmUxZDc5NWVm
MjA5NSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWls
ZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LTcyMWYwYzEyNjA3NTI5NGU2
NmRmNzMwNTFjYzJlMWQ3OTVlZjIwOTUKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvNzIxZjBjMTI2MDc1Mjk0ZTY2ZGY3MzA1MWNj
MmUxZDc5NWVmMjA5NQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMv
YnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy03MjFmMGMxMjYwNzUy
OTRlNjZkZjczMDUxY2MyZTFkNzk1ZWYyMDk1CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2Yg
L2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIz
Ny03MjFmMGMxMjYwNzUyOTRlNjZkZjczMDUxY2MyZTFkNzk1ZWYyMDk1Cmtlcm5lbDogL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LzcyMWYwYzEyNjA3NTI5NGU2NmRm
NzMwNTFjYzJlMWQ3OTVlZjIwOTUvdm1saW51ei0zLjE0LjAtcmM1LTAwMjQ4LWc3MjFmMGMx
CgoyMDE0LTAzLTIxLTE3OjM5OjA4IGRldGVjdGluZyBib290IHN0YXRlIC4uLi4uLi4uLi4u
LgkzCTEyCTIxIFNVQ0NFU1MKCkJpc2VjdGluZzogMTA1NTYgcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDE0IHN0ZXBzKQpbNzY3YTY1NmUwZjkxMzllZmNk
Y2QwYjY0ZmMzMGU0NmU4MmQwOTBiN10gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAn
ZjJmcy9kZXYnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvaG9tZS93Zmcvc291bmQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy9uZXh0Om1hc3Rl
cjo3NjdhNjU2ZTBmOTEzOWVmY2RjZDBiNjRmYzMwZTQ2ZTgyZDA5MGI3OmJpc2VjdC1zb3Vu
ZAoKMjAxNC0wMy0yMS0xNzo0Njo0NSA3NjdhNjU2ZTBmOTEzOWVmY2RjZDBiNjRmYzMwZTQ2
ZTgyZDA5MGI3IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3Rz
L2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzctNzY3YTY1NmUwZjkx
MzllZmNkY2QwYjY0ZmMzMGU0NmU4MmQwOTBiNwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy83NjdhNjU2ZTBmOTEzOWVmY2RjZDBi
NjRmYzMwZTQ2ZTgyZDA5MGI3CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10
ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LTc2N2E2NTZl
MGY5MTM5ZWZjZGNkMGI2NGZjMzBlNDZlODJkMDkwYjcKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWctYmExLTAz
MjExMjM3LTc2N2E2NTZlMGY5MTM5ZWZjZGNkMGI2NGZjMzBlNDZlODJkMDkwYjcKa2VybmVs
OiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvNzY3YTY1NmUwZjkxMzll
ZmNkY2QwYjY0ZmMzMGU0NmU4MmQwOTBiNy92bWxpbnV6LTMuMTQuMC1yYzctMDE4NTUtZzc2
N2E2NTYKCjIwMTQtMDMtMjEtMTg6Mjk6NDYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uCTEJ
MTIJMTYJMTgJMjEgU1VDQ0VTUwoKQmlzZWN0aW5nOiA4NDM1IHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxNCBzdGVwcykKWzhkNWVjNDg0ZGJiZWUyNzg0
ZTg4OTc0ZWNhMzI0OTAyNGUwYzJiZGRdIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2gg
J29tYXBfZHNzMi9mb3ItbmV4dCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9zb3VuZC9vYmotYmlzZWN0CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3
L25leHQ6bWFzdGVyOjhkNWVjNDg0ZGJiZWUyNzg0ZTg4OTc0ZWNhMzI0OTAyNGUwYzJiZGQ6
YmlzZWN0LXNvdW5kCgoyMDE0LTAzLTIxLTE4OjMzOjUzIDhkNWVjNDg0ZGJiZWUyNzg0ZTg4
OTc0ZWNhMzI0OTAyNGUwYzJiZGQgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9r
ZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy04
ZDVlYzQ4NGRiYmVlMjc4NGU4ODk3NGVjYTMyNDkwMjRlMGMyYmRkCkNoZWNrIGZvciBrZXJu
ZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LzhkNWVjNDg0ZGJi
ZWUyNzg0ZTg4OTc0ZWNhMzI0OTAyNGUwYzJiZGQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEy
MzctOGQ1ZWM0ODRkYmJlZTI3ODRlODg5NzRlY2EzMjQ5MDI0ZTBjMmJkZAp3YWl0aW5nIGZv
ciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNv
bmZpZy1iYTEtMDMyMTEyMzctOGQ1ZWM0ODRkYmJlZTI3ODRlODg5NzRlY2EzMjQ5MDI0ZTBj
MmJkZAprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy84ZDVl
YzQ4NGRiYmVlMjc4NGU4ODk3NGVjYTMyNDkwMjRlMGMyYmRkL3ZtbGludXotMy4xNC4wLXJj
Ny0wNjYwMS1nOGQ1ZWM0OAoKMjAxNC0wMy0yMS0xOToxMDo1MyBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAuCTUJMTAJMTcJMjEgU1VDQ0VTUwoKQmlzZWN0aW5nOiAzNjg5IHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMiBzdGVwcykKWzRiNzk3ZDc1ODQ5
NmYyYTMxNDJmZDUyZjk3NDU4NzE1MTY5MmUxYjJdIE1lcmdlIHJlbW90ZS10cmFja2luZyBi
cmFuY2ggJ2xlZHMvZm9yLW5leHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcvc291bmQvb2JqLWJpc2VjdApscyAtYSAv
a2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIz
Ny9uZXh0Om1hc3Rlcjo0Yjc5N2Q3NTg0OTZmMmEzMTQyZmQ1MmY5NzQ1ODcxNTE2OTJlMWIy
OmJpc2VjdC1zb3VuZAoKMjAxNC0wMy0yMS0xOToxMzoyNyA0Yjc5N2Q3NTg0OTZmMmEzMTQy
ZmQ1MmY5NzQ1ODcxNTE2OTJlMWIyIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzct
NGI3OTdkNzU4NDk2ZjJhMzE0MmZkNTJmOTc0NTg3MTUxNjkyZTFiMgpDaGVjayBmb3Iga2Vy
bmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy80Yjc5N2Q3NTg0
OTZmMmEzMTQyZmQ1MmY5NzQ1ODcxNTE2OTJlMWIyCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYmExLTAzMjEx
MjM3LTRiNzk3ZDc1ODQ5NmYyYTMxNDJmZDUyZjk3NDU4NzE1MTY5MmUxYjIKd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRj
b25maWctYmExLTAzMjExMjM3LTRiNzk3ZDc1ODQ5NmYyYTMxNDJmZDUyZjk3NDU4NzE1MTY5
MmUxYjIKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvNGI3
OTdkNzU4NDk2ZjJhMzE0MmZkNTJmOTc0NTg3MTUxNjkyZTFiMi92bWxpbnV6LTMuMTQuMC1y
YzctMDc4NzEtZzRiNzk3ZDcKCjIwMTQtMDMtMjEtMTk6NDk6MjcgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgLiBURVNUIEZBSUxVUkUKWyAgICAzLjIyMDQ2Nl0gcGFnZTo4YTcwMTUyOCBjb3Vu
dDowIG1hcGNvdW50OjEgbWFwcGluZzogIChudWxsKSBpbmRleDoweDAKWyAgICAzLjIyMTE3
NF0gcGFnZSBmbGFnczogMHg0MDAwODAwNChyZWZlcmVuY2VkfHRhaWwpClsgICAgMy4yMjE4
MDZdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDMuMjIyMjU3
XSBrZXJuZWwgQlVHIGF0IG1tL3N3YXAuYzoxMzQhClsgICAgMy4yMjI5NTJdIGludmFsaWQg
b3Bjb2RlOiAwMDAwIFsjMV0gUFJFRU1QVCBERUJVR19QQUdFQUxMT0MKWyAgICAzLjIyMzYx
M10gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMy4yMjM5MzRdIENQVTogMCBQSUQ6IDY4IENv
bW06IGluaXQgTm90IHRhaW50ZWQgMy4xNC4wLXJjNy0wNzg3MS1nNGI3OTdkNyAjMQpbICAg
IDMuMjI0NzA5XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8w
MS8yMDExClsgICAgMy4yMjUyNjhdIHRhc2s6IDg3Y2ZlMTAwIHRpOiA4MjAyMjAwMCB0YXNr
LnRpOiA4MjAyMjAwMApbICAgIDMuMjI1OTM0XSBFSVA6IDAwNjA6Wzw3OTA3YTdlYj5dIEVG
TEFHUzogMDAwMTAyNDYgQ1BVOiAwClsgICAgMy4yMjY1MjNdIEVJUCBpcyBhdCBwdXRfY29t
cG91bmRfcGFnZSsweDdkLzB4MWRhClsgICAgMy4yMjcwMTJdIEVBWDogNzk1MGY5MDggRUJY
OiA4YTcwMTUwMCBFQ1g6IDc5MDRiNjljIEVEWDogMDAwMDAwMDEKWyAgICAzLjIyNzc5Ml0g
RVNJOiA4YTcwMTUyOCBFREk6IGZmZmZmZmZmIEVCUDogODIwMjNkNDAgRVNQOiA4MjAyM2Qz
NApbICAgIDMuMjI4NzU0XSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwMDAgR1M6IDAwMDAg
U1M6IDAwNjgKWyAgICAzLjIyOTMyM10gQ1IwOiA4MDA1MDAzYiBDUjI6IDZmNTVjNDYwIENS
MzogMGEwMjEwMDAgQ1I0OiAwMDAwMDZkMApbICAgIDMuMjI5OTg3XSBTdGFjazoKWyAgICAz
LjIzMDAxMV0gIDhhNzAxNTI4IDAwMDAwMDAwIGZmZmZmZmZmIDgyMDIzZDc4IDc5MDdhOWVi
IDAwMDAwMDAxIDgyMDIzZDY0IDAwMDAwMDAwClsgICAgMy4yMzAwMTFdICAwMDAwMDA1NyA4
MjAwOTAwYyAwMDAwMDI0NiAwMDAwMDAyMSA4YTc2NTNkNCA4YTRkMGY5YyA4MjAwOTAwMCA4
MjAyM2RiMApbICAgIDMuMjMwMDExXSAgODIwMjNkYzQgODIwMjNkOGMgNzkwODYxNzEgODIw
MjNkYjAgODIwMTAyODAgMDAwMDAwMDAgODIwMjNkOWMgNzkwODYxOTIKWyAgICAzLjIzMDAx
MV0gQ2FsbCBUcmFjZToKWyAgICAzLjIzMDAxMV0gIFs8NzkwN2E5ZWI+XSByZWxlYXNlX3Bh
Z2VzKzB4NTgvMHgxNzUKWyAgICAzLjIzMDAxMV0gIFs8NzkwODYxNzE+XSB0bGJfZmx1c2hf
bW11KzB4MzAvMHg0NQpbICAgIDMuMjMwMDExXSAgWzw3OTA4NjE5Mj5dIHRsYl9maW5pc2hf
bW11KzB4Yy8weDJiClsgICAgMy4yMzAwMTFdICBbPDc5MDhiYWIxPl0gZXhpdF9tbWFwKzB4
ODQvMHhjYgpbICAgIDMuMjMwMDExXSAgWzw3OTAyNThmZj5dIG1tcHV0KzB4MmMvMHhiMQpb
ICAgIDMuMjMwMDExXSAgWzw3OTBhMWEzMD5dIGZsdXNoX29sZF9leGVjKzB4NDkxLzB4NTQ2
ClsgICAgMy4yMzAwMTFdICBbPDc5MGMxZGEwPl0gbG9hZF9lbGZfYmluYXJ5KzB4MjcyLzB4
Yjk2ClsgICAgMy4yMzAwMTFdICBbPDc5MGEwZmY1Pl0gc2VhcmNoX2JpbmFyeV9oYW5kbGVy
KzB4NWYvMHgxNDUKWyAgICAzLjIzMDAxMV0gIFs8NzkwYzE5NzY+XSBsb2FkX3NjcmlwdCsw
eDE3YS8weDE4MwpbICAgIDMuMjMwMDExXSAgWzw3OTA0MTk5MD5dID8gc2NoZWRfY2xvY2tf
Y3B1KzB4YWEvMHhkMwpbICAgIDMuMjMwMDExXSAgWzw3OTA0ODBkMD5dID8gbG9ja19yZWxl
YXNlKzB4MTM4LzB4MTkyClsgICAgMy4yMzAwMTFdICBbPDc5MzBkYjljPl0gPyBfcmF3X3Jl
YWRfdW5sb2NrKzB4MjcvMHgzOApbICAgIDMuMjMwMDExXSAgWzw3OTBhMGZmNT5dIHNlYXJj
aF9iaW5hcnlfaGFuZGxlcisweDVmLzB4MTQ1ClsgICAgMy4yMzAwMTFdICBbPDc5MGEyMGEy
Pl0gZG9fZXhlY3ZlKzB4MzcxLzB4NDdjClsgICAgMy4yMzAwMTFdICBbPDc5MGEyMzAxPl0g
U3lTX2V4ZWN2ZSsweDFjLzB4MjAKWyAgICAzLjIzMDAxMV0gIFs8NzkzMTFhOTU+XSBzeXNl
bnRlcl9kb19jYWxsKzB4MTIvMHgzNwpbICAgIDMuMjMwMDExXSBDb2RlOiAwZiA4NCBhMyAw
MCAwMCAwMCA4OSBkOCBlOCA4MSBmYyBmZiBmZiA4NSBjMCA3NSAwYiAzMSBkMiA4OSBkOCBl
OCAwYSBjNiBmZiBmZiAwZiAwYiA4YiA0NiAwYyA0MCA3NCAwYiAzMSBkMiA4OSBmMCBlOCBm
OSBjNSBmZiBmZiA8MGY+IDBiIDg5IGQ4IGU4IGQwIGZjIGZmIGZmIDg1IGMwIDBmIDg0IDQ3
IDAxIDAwIDAwIDhiIDAzIGE4IDgwClsgICAgMy4yMzAwMTFdIEVJUDogWzw3OTA3YTdlYj5d
IHB1dF9jb21wb3VuZF9wYWdlKzB4N2QvMHgxZGEgU1M6RVNQIDAwNjg6ODIwMjNkMzQKWyAg
ICAzLjI0OTIyNV0gLS0tWyBlbmQgdHJhY2UgZjI4YTA1MWQ0OGZjMDA3NiBdLS0tClsgICAg
My4zOTAwOTRdIHRzYzogUmVmaW5lZCBUU0MgY2xvY2tzb3VyY2UgY2FsaWJyYXRpb246IDI0
OTMuOTYxIE1Iegova2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvNGI3OTdk
NzU4NDk2ZjJhMzE0MmZkNTJmOTc0NTg3MTUxNjkyZTFiMi9kbWVzZy15b2N0by1pdnl0b3du
Mi0zMjoyMDE0MDMyMTE5NDkxOTppMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3OjMuMTQu
MC1yYzctMDc4NzEtZzRiNzk3ZDc6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMy
MTEyMzcvNGI3OTdkNzU4NDk2ZjJhMzE0MmZkNTJmOTc0NTg3MTUxNjkyZTFiMi9kbWVzZy15
b2N0by1pdnl0b3duMi0yODoyMDE0MDMyMTE5NDkyMjppMzg2LXJhbmRjb25maWctYmExLTAz
MjExMjM3OjMuMTQuMC1yYzctMDc4NzEtZzRiNzk3ZDc6MQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1iYTEtMDMyMTEyMzcvNGI3OTdkNzU4NDk2ZjJhMzE0MmZkNTJmOTc0NTg3MTUxNjky
ZTFiMi9kbWVzZy15b2N0by1uaG00LTU6MjAxNDAzMjExOTQ5MjI6aTM4Ni1yYW5kY29uZmln
LWJhMS0wMzIxMTIzNzozLjE0LjAtcmM3LTA3ODcxLWc0Yjc5N2Q3OjEKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYmExLTAzMjExMjM3LzRiNzk3ZDc1ODQ5NmYyYTMxNDJmZDUyZjk3NDU4
NzE1MTY5MmUxYjIvZG1lc2cteW9jdG8taXZ5dG93bjItMTA6MjAxNDAzMjExOTQ5MjU6aTM4
Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNzozLjE0LjAtcmM3LTA3ODcxLWc0Yjc5N2Q3OjEK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LzRiNzk3ZDc1ODQ5NmYyYTMx
NDJmZDUyZjk3NDU4NzE1MTY5MmUxYjIvZG1lc2cteW9jdG8taXZ5dG93bjItNzE6MjAxNDAz
MjExOTQ5MjQ6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNzozLjE0LjAtcmM3LTA3ODcx
LWc0Yjc5N2Q3OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LzRiNzk3
ZDc1ODQ5NmYyYTMxNDJmZDUyZjk3NDU4NzE1MTY5MmUxYjIvZG1lc2cteW9jdG8taXZ5dG93
bjItNzQ6MjAxNDAzMjExOTQ5MjQ6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNzozLjE0
LjAtcmM3LTA3ODcxLWc0Yjc5N2Q3OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAz
MjExMjM3LzRiNzk3ZDc1ODQ5NmYyYTMxNDJmZDUyZjk3NDU4NzE1MTY5MmUxYjIvZG1lc2ct
cXVhbnRhbC1pdnl0b3duMi00MToyMDE0MDMyMTE5NDkzNDppMzg2LXJhbmRjb25maWctYmEx
LTAzMjExMjM3OjMuMTQuMC1yYzctMDc4NzEtZzRiNzk3ZDc6MQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1iYTEtMDMyMTEyMzcvNGI3OTdkNzU4NDk2ZjJhMzE0MmZkNTJmOTc0NTg3MTUx
NjkyZTFiMi9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTYyOjIwMTQwMzIxMTk0OTM4OmkzODYt
cmFuZGNvbmZpZy1iYTEtMDMyMTEyMzc6My4xNC4wLXJjNy0wNzg3MS1nNGI3OTdkNzoxCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy80Yjc5N2Q3NTg0OTZmMmEzMTQy
ZmQ1MmY5NzQ1ODcxNTE2OTJlMWIyL2RtZXNnLXF1YW50YWwtaXZ5dG93bjItODk6MjAxNDAz
MjExOTQ5MzQ6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNzozLjE0LjAtcmM3LTA3ODcx
LWc0Yjc5N2Q3OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LzRiNzk3
ZDc1ODQ5NmYyYTMxNDJmZDUyZjk3NDU4NzE1MTY5MmUxYjIvZG1lc2ctcXVhbnRhbC1uaG00
LTU6MjAxNDAzMjExOTQ5MzE6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNzozLjE0LjAt
cmM3LTA3ODcxLWc0Yjc5N2Q3OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMjEx
MjM3LzRiNzk3ZDc1ODQ5NmYyYTMxNDJmZDUyZjk3NDU4NzE1MTY5MmUxYjIvZG1lc2cteW9j
dG8taXZ5dG93bjItMTE6MjAxNDAzMjExOTQ5MzI6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIx
MTIzNzozLjE0LjAtcmM3LTA3ODcxLWc0Yjc5N2Q3OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctYmExLTAzMjExMjM3LzRiNzk3ZDc1ODQ5NmYyYTMxNDJmZDUyZjk3NDU4NzE1MTY5MmUx
YjIvZG1lc2cteW9jdG8taXZ5dG93bjItMjg6MjAxNDAzMjExOTQ5MzE6aTM4Ni1yYW5kY29u
ZmlnLWJhMS0wMzIxMTIzNzozLjE0LjAtcmM3LTA3ODcxLWc0Yjc5N2Q3OjEKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LzRiNzk3ZDc1ODQ5NmYyYTMxNDJmZDUyZjk3
NDU4NzE1MTY5MmUxYjIvZG1lc2cteW9jdG8taXZ5dG93bjItMzI6MjAxNDAzMjExOTQ5Mjk6
aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNzozLjE0LjAtcmM3LTA3ODcxLWc0Yjc5N2Q3
OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LzRiNzk3ZDc1ODQ5NmYy
YTMxNDJmZDUyZjk3NDU4NzE1MTY5MmUxYjIvZG1lc2cteW9jdG8taXZ5dG93bjItNzE6MjAx
NDAzMjExOTQ5MzQ6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNzozLjE0LjAtcmM3LTA3
ODcxLWc0Yjc5N2Q3OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LzRi
Nzk3ZDc1ODQ5NmYyYTMxNDJmZDUyZjk3NDU4NzE1MTY5MmUxYjIvZG1lc2cteW9jdG8taXZ5
dG93bjItODc6MjAxNDAzMjExOTQ5MzE6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNzoz
LjE0LjAtcmM3LTA3ODcxLWc0Yjc5N2Q3OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmEx
LTAzMjExMjM3LzRiNzk3ZDc1ODQ5NmYyYTMxNDJmZDUyZjk3NDU4NzE1MTY5MmUxYjIvZG1l
c2ctcXVhbnRhbC1pdnl0b3duMi0xNToyMDE0MDMyMTE5NDk0MTppMzg2LXJhbmRjb25maWct
YmExLTAzMjExMjM3OjMuMTQuMC1yYzctMDc4NzEtZzRiNzk3ZDc6MQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvNGI3OTdkNzU4NDk2ZjJhMzE0MmZkNTJmOTc0NTg3
MTUxNjkyZTFiMi9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTUzOjIwMTQwMzIxMTk0OTQzOmkz
ODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzc6My4xNC4wLXJjNy0wNzg3MS1nNGI3OTdkNzox
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy80Yjc5N2Q3NTg0OTZmMmEz
MTQyZmQ1MmY5NzQ1ODcxNTE2OTJlMWIyL2RtZXNnLXF1YW50YWwtbmhtNC0yOjIwMTQwMzIx
MTk0OTQxOmkzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzc6My4xNC4wLXJjNy0wNzg3MS1n
NGI3OTdkNzoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy80Yjc5N2Q3
NTg0OTZmMmEzMTQyZmQ1MmY5NzQ1ODcxNTE2OTJlMWIyL2RtZXNnLXlvY3RvLWl2eXRvd24y
LTg3OjIwMTQwMzIxMTk0OTQxOmkzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzc6My4xNC4w
LXJjNy0wNzg3MS1nNGI3OTdkNzoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIx
MTIzNy80Yjc5N2Q3NTg0OTZmMmEzMTQyZmQ1MmY5NzQ1ODcxNTE2OTJlMWIyL2RtZXNnLXF1
YW50YWwtaXZ5dG93bjItNTg6MjAxNDAzMjExOTQ5NDc6aTM4Ni1yYW5kY29uZmlnLWJhMS0w
MzIxMTIzNzozLjE0LjAtcmM3LTA3ODcxLWc0Yjc5N2Q3OjEKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYmExLTAzMjExMjM3LzRiNzk3ZDc1ODQ5NmYyYTMxNDJmZDUyZjk3NDU4NzE1MTY5
MmUxYjIvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi02NzoyMDE0MDMyMTE5NDk0NzppMzg2LXJh
bmRjb25maWctYmExLTAzMjExMjM3OjMuMTQuMC1yYzctMDc4NzEtZzRiNzk3ZDc6MQowOjIx
OjE5IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDEyNzAgcmV2aXNp
b25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDExIHN0ZXBzKQpbNTUzNTY4
MWRjNDRlMjA1MGQ5YjRlNGU3NTZiN2ExYjQ3ZDc3MGQ3Ml0gTWVyZ2UgcmVtb3RlLXRyYWNr
aW5nIGJyYW5jaCAnZHQtcmgvZm9yLW5leHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcvc291bmQvb2JqLWJpc2VjdAps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWJhMS0w
MzIxMTIzNy9uZXh0Om1hc3Rlcjo1NTM1NjgxZGM0NGUyMDUwZDliNGU0ZTc1NmI3YTFiNDdk
NzcwZDcyOmJpc2VjdC1zb3VuZAoKMjAxNC0wMy0yMS0xOTo1MDowMiA1NTM1NjgxZGM0NGUy
MDUwZDliNGU0ZTc1NmI3YTFiNDdkNzcwZDcyIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFz
ayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMy
MTEyMzctNTUzNTY4MWRjNDRlMjA1MGQ5YjRlNGU3NTZiN2ExYjQ3ZDc3MGQ3MgpDaGVjayBm
b3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy81NTM1
NjgxZGM0NGUyMDUwZDliNGU0ZTc1NmI3YTFiNDdkNzcwZDcyCndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYmEx
LTAzMjExMjM3LTU1MzU2ODFkYzQ0ZTIwNTBkOWI0ZTRlNzU2YjdhMWI0N2Q3NzBkNzIKd2Fp
dGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2
LXJhbmRjb25maWctYmExLTAzMjExMjM3LTU1MzU2ODFkYzQ0ZTIwNTBkOWI0ZTRlNzU2Yjdh
MWI0N2Q3NzBkNzIKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEy
MzcvNTUzNTY4MWRjNDRlMjA1MGQ5YjRlNGU3NTZiN2ExYjQ3ZDc3MGQ3Mi92bWxpbnV6LTMu
MTQuMC1yYzctMDY5MzMtZzU1MzU2ODEKCjIwMTQtMDMtMjEtMjA6Mzc6MDIgZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgLi4JNQk4CTIxIFNVQ0NFU1MKCkJpc2VjdGluZzogOTM4IHJldmlzaW9u
cyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMCBzdGVwcykKW2ViY2JkYTE2
ZDM0NDcwYWNhNDY5ZmE5M2JhMTUyM2RjY2E1ZWEyNzJdIE1lcmdlIHJlbW90ZS10cmFja2lu
ZyBicmFuY2ggJ2Z0cmFjZS9mb3ItbmV4dCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlz
ZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9zb3VuZC9vYmotYmlzZWN0Cmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYmExLTAz
MjExMjM3L25leHQ6bWFzdGVyOmViY2JkYTE2ZDM0NDcwYWNhNDY5ZmE5M2JhMTUyM2RjY2E1
ZWEyNzI6YmlzZWN0LXNvdW5kCgoyMDE0LTAzLTIxLTIwOjM5OjM2IGViY2JkYTE2ZDM0NDcw
YWNhNDY5ZmE5M2JhMTUyM2RjY2E1ZWEyNzIgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNr
IHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIx
MTIzNy1lYmNiZGExNmQzNDQ3MGFjYTQ2OWZhOTNiYTE1MjNkY2NhNWVhMjcyCkNoZWNrIGZv
ciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3L2ViY2Jk
YTE2ZDM0NDcwYWNhNDY5ZmE5M2JhMTUyM2RjY2E1ZWEyNzIKd2FpdGluZyBmb3IgY29tcGxl
dGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1iYTEt
MDMyMTEyMzctZWJjYmRhMTZkMzQ0NzBhY2E0NjlmYTkzYmExNTIzZGNjYTVlYTI3Mgp3YWl0
aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYt
cmFuZGNvbmZpZy1iYTEtMDMyMTEyMzctZWJjYmRhMTZkMzQ0NzBhY2E0NjlmYTkzYmExNTIz
ZGNjYTVlYTI3MgprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIz
Ny9lYmNiZGExNmQzNDQ3MGFjYTQ2OWZhOTNiYTE1MjNkY2NhNWVhMjcyL3ZtbGludXotMy4x
NC4wLXJjNy0wNzcxNi1nZWJjYmRhMQoKMjAxNC0wMy0yMS0yMDo1OTozNiBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVSRQpbICAgIDEuMjc4MzQ4XSBwYWdlOjg3YjZiNTI4
IGNvdW50OjAgbWFwY291bnQ6MiBtYXBwaW5nOiAgKG51bGwpIGluZGV4OjB4MApbICAgIDEu
Mjc5MjA3XSBwYWdlIGZsYWdzOiAweDQwMDA4MDA0KHJlZmVyZW5jZWR8dGFpbCkKWyAgICAx
LjI4MDAwMV0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMS4y
ODAwMjddIGtlcm5lbCBCVUcgYXQgbW0vc3dhcC5jOjEzNCEKWyAgICAxLjI4MDAyN10gaW52
YWxpZCBvcGNvZGU6IDAwMDAgWyMxXSBQUkVFTVBUIERFQlVHX1BBR0VBTExPQwpbICAgIDEu
MjgwMDI3XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAxLjI4MDAyN10gQ1BVOiAwIFBJRDog
NzAgQ29tbTogbW91bnQgTm90IHRhaW50ZWQgMy4xNC4wLXJjNy0wNzcxNi1nZWJjYmRhMSAj
MQpbICAgIDEuMjgwMDI3XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2No
cyAwMS8wMS8yMDExClsgICAgMS4yODAwMjddIHRhc2s6IDg1OGZlZDIwIHRpOiA3OGQ5NDAw
MCB0YXNrLnRpOiA3OGQ5NDAwMApbICAgIDEuMjgwMDI3XSBFSVA6IDAwNjA6Wzw3OTA3YTdl
Yj5dIEVGTEFHUzogMDAwMTAyNDYgQ1BVOiAwClsgICAgMS4yODAwMjddIEVJUCBpcyBhdCBw
dXRfY29tcG91bmRfcGFnZSsweDdkLzB4MWRhClsgICAgMS4yODAwMjddIEVBWDogNzk1MTAw
MjEgRUJYOiA4N2I2YjUwMCBFQ1g6IDc5MDRiNjljIEVEWDogMDAwMDAwMDEKWyAgICAxLjI4
MDAyN10gRVNJOiA4N2I2YjUyOCBFREk6IGZmZmZmZmZmIEVCUDogNzhkOTVlOGMgRVNQOiA3
OGQ5NWU4MApbICAgIDEuMjgwMDI3XSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwMDAgR1M6
IDAwMDAgU1M6IDAwNjgKWyAgICAxLjI4MDAyN10gQ1IwOiA4MDA1MDAzYiBDUjI6IDA4MDRl
MTAxIENSMzogMDBkYWIwMDAgQ1I0OiAwMDAwMDZkMApbICAgIDEuMjgwMDI3XSBTdGFjazoK
WyAgICAxLjI4MDAyN10gIDg3YjZiNTI4IDAwMDAwMDAwIGZmZmZmZmZmIDc4ZDk1ZWM0IDc5
MDdhOWViIDAwMDAwMDAxIDc4ZDk1ZWIwIDAwMDAwMDAwClsgICAgMS4yODAwMjddICAwMDAw
MDA4OCA3OGRhZDAwYyAwMDAwMDI0NiAwMDAwMDA4MiA4Nzk2MzNhYyA4Nzk2MzFjYyA3OGRh
ZDAwMCA3OGQ5NWVmYwpbICAgIDEuMjgwMDI3XSAgNzhkOTVmMTAgNzhkOTVlZDggNzkwODYx
ZGQgNzhkOTVlZmMgNzhkOGFhMDAgMDAwMDAwMDAgNzhkOTVlZTggNzkwODYxZmUKWyAgICAx
LjI4MDAyN10gQ2FsbCBUcmFjZToKWyAgICAxLjI4MDAyN10gIFs8NzkwN2E5ZWI+XSByZWxl
YXNlX3BhZ2VzKzB4NTgvMHgxNzUKWyAgICAxLjI4MDAyN10gIFs8NzkwODYxZGQ+XSB0bGJf
Zmx1c2hfbW11KzB4MzAvMHg0NQpbICAgIDEuMjgwMDI3XSAgWzw3OTA4NjFmZT5dIHRsYl9m
aW5pc2hfbW11KzB4Yy8weDJiClsgICAgMS4yODAwMjddICBbPDc5MDhiYjFkPl0gZXhpdF9t
bWFwKzB4ODQvMHhjYgpbICAgIDEuMjgwMDI3XSAgWzw3OTAyNThmZj5dIG1tcHV0KzB4MmMv
MHhiMQpbICAgIDEuMjgwMDI3XSAgWzw3OTAyN2YyZT5dIGRvX2V4aXQrMHgyMWUvMHg2Y2UK
WyAgICAxLjI4MDAyN10gIFs8NzkwOWQ2MjE+XSA/IHZmc193cml0ZSsweDk4LzB4YjAKWyAg
ICAxLjI4MDAyN10gIFs8NzkwMjhmMWU+XSBkb19ncm91cF9leGl0KzB4NTkvMHg4NgpbICAg
IDEuMjgwMDI3XSAgWzw3OTAyOGY1Yz5dIFN5U19leGl0X2dyb3VwKzB4MTEvMHgxMQpbICAg
IDEuMjgwMDI3XSAgWzw3OTMwZGU3Nj5dIHN5c2NhbGxfY2FsbCsweDcvMHhiClsgICAgMS4y
ODAwMjddIENvZGU6IDBmIDg0IGEzIDAwIDAwIDAwIDg5IGQ4IGU4IDgxIGZjIGZmIGZmIDg1
IGMwIDc1IDBiIDMxIGQyIDg5IGQ4IGU4IDBhIGM2IGZmIGZmIDBmIDBiIDhiIDQ2IDBjIDQw
IDc0IDBiIDMxIGQyIDg5IGYwIGU4IGY5IGM1IGZmIGZmIDwwZj4gMGIgODkgZDggZTggZDAg
ZmMgZmYgZmYgODUgYzAgMGYgODQgNDcgMDEgMDAgMDAgOGIgMDMgYTggODAKWyAgICAxLjI4
MDAyN10gRUlQOiBbPDc5MDdhN2ViPl0gcHV0X2NvbXBvdW5kX3BhZ2UrMHg3ZC8weDFkYSBT
UzpFU1AgMDA2ODo3OGQ5NWU4MApbICAgIDEuMzA1OTE5XSAtLS1bIGVuZCB0cmFjZSA3ZTM5
MmQyOGQzOTVkNWJjIF0tLS0KWyAgICAxLjMwNjYxMl0gRml4aW5nIHJlY3Vyc2l2ZSBmYXVs
dCBidXQgcmVib290IGlzIG5lZWRlZCEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAz
MjExMjM3L2ViY2JkYTE2ZDM0NDcwYWNhNDY5ZmE5M2JhMTUyM2RjY2E1ZWEyNzIvZG1lc2ct
eW9jdG8taW5uLTQwOjIwMTQwMzIxMjA1OTQxOmkzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEy
Mzc6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvZWJjYmRhMTZkMzQ0
NzBhY2E0NjlmYTkzYmExNTIzZGNjYTVlYTI3Mi9kbWVzZy15b2N0by1pbm4tMzM6MjAxNDAz
MjEyMDU5NTc6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNzo6Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWJhMS0wMzIxMTIzNy9lYmNiZGExNmQzNDQ3MGFjYTQ2OWZhOTNiYTE1MjNk
Y2NhNWVhMjcyL2RtZXNnLXlvY3RvLWlubi00MDoyMDE0MDMyMTIwNTk1MTppMzg2LXJhbmRj
b25maWctYmExLTAzMjExMjM3OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMjEx
MjM3L2ViY2JkYTE2ZDM0NDcwYWNhNDY5ZmE5M2JhMTUyM2RjY2E1ZWEyNzIvZG1lc2cteW9j
dG8teHBzLTU6MjAxNDAzMjEyMTAwMDI6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNzoz
LjE0LjAtcmM3LTA3NzE2LWdlYmNiZGExOjEKMDo0OjMgYWxsX2dvb2Q6YmFkOmFsbF9iYWQg
Ym9vdHMKCkJpc2VjdGluZzogNzgzIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSAxMCBzdGVwcykKWzdiYmNiZjQyZjVkODVmMTVlZDRmMjg4NjVlNTMxZDRj
NDk4NGY1OTFdIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ3RpcC9hdXRvLWxhdGVz
dCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9ob21lL3dmZy9zb3VuZC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3L25leHQ6bWFzdGVyOjdiYmNi
ZjQyZjVkODVmMTVlZDRmMjg4NjVlNTMxZDRjNDk4NGY1OTE6YmlzZWN0LXNvdW5kCgoyMDE0
LTAzLTIxLTIxOjAwOjEwIDdiYmNiZjQyZjVkODVmMTVlZDRmMjg4NjVlNTMxZDRjNDk4NGY1
OTEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQt
cXVldWUvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy03YmJjYmY0MmY1ZDg1ZjE1ZWQ0
ZjI4ODY1ZTUzMWQ0YzQ5ODRmNTkxCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYmExLTAzMjExMjM3LzdiYmNiZjQyZjVkODVmMTVlZDRmMjg4NjVlNTMx
ZDRjNDk4NGY1OTEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1
aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzctN2JiY2JmNDJmNWQ4NWYx
NWVkNGYyODg2NWU1MzFkNGM0OTg0ZjU5MQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9r
ZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzct
N2JiY2JmNDJmNWQ4NWYxNWVkNGYyODg2NWU1MzFkNGM0OTg0ZjU5MQprZXJuZWw6IC9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy83YmJjYmY0MmY1ZDg1ZjE1ZWQ0ZjI4
ODY1ZTUzMWQ0YzQ5ODRmNTkxL3ZtbGludXotMy4xNC4wLXJjNy0wNzY1Ny1nN2JiY2JmNAoK
MjAxNC0wMy0yMS0yMTozNToxMCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVS
RQpbICAgIDIuNjI1MjY4XSBwYWdlOjhhNzAxNTI4IGNvdW50OjAgbWFwY291bnQ6MSBtYXBw
aW5nOiAgKG51bGwpIGluZGV4OjB4MApbICAgIDIuNjI1OTIzXSBwYWdlIGZsYWdzOiAweDQw
MDA4MDA0KHJlZmVyZW5jZWR8dGFpbCkKWyAgICAyLjYyNjQ2M10gLS0tLS0tLS0tLS0tWyBj
dXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMi42MjY5MTBdIGtlcm5lbCBCVUcgYXQgbW0v
c3dhcC5jOjEzNCEKWyAgICAyLjYyNzUzNV0gaW52YWxpZCBvcGNvZGU6IDAwMDAgWyMxXSBQ
UkVFTVBUIERFQlVHX1BBR0VBTExPQwpbICAgIDIuNjI4MTM3XSBNb2R1bGVzIGxpbmtlZCBp
bjoKWyAgICAyLjYyODQ1OF0gQ1BVOiAwIFBJRDogNjggQ29tbTogaW5pdCBOb3QgdGFpbnRl
ZCAzLjE0LjAtcmM3LTA3NjU3LWc3YmJjYmY0ICMxClsgICAgMi42MjkxNDZdIEhhcmR3YXJl
IG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAyLjYyOTcw
M10gdGFzazogODJiMWM4YzAgdGk6IDgyMDA4MDAwIHRhc2sudGk6IDgyMDA4MDAwClsgICAg
Mi42MzAwMTNdIEVJUDogMDA2MDpbPDc5MDdhN2ViPl0gRUZMQUdTOiAwMDAxMDI0NiBDUFU6
IDAKWyAgICAyLjYzMDAxM10gRUlQIGlzIGF0IHB1dF9jb21wb3VuZF9wYWdlKzB4N2QvMHgx
ZGEKWyAgICAyLjYzMDAxM10gRUFYOiA3OTUwZmY3NSBFQlg6IDhhNzAxNTAwIEVDWDogNzkw
NGI2OWMgRURYOiAwMDAwMDAwMQpbICAgIDIuNjMwMDEzXSBFU0k6IDhhNzAxNTI4IEVESTog
ZmZmZmZmZmYgRUJQOiA4MjAwOWQ0MCBFU1A6IDgyMDA5ZDM0ClsgICAgMi42MzAwMTNdICBE
UzogMDA3YiBFUzogMDA3YiBGUzogMDAwMCBHUzogMDAwMCBTUzogMDA2OApbICAgIDIuNjMw
MDEzXSBDUjA6IDgwMDUwMDNiIENSMjogNmY1MzA0NjAgQ1IzOiAwYTAyMDAwMCBDUjQ6IDAw
MDAwNmQwClsgICAgMi42MzAwMTNdIFN0YWNrOgpbICAgIDIuNjMwMDEzXSAgOGE3MDE1Mjgg
MDAwMDAwMDAgZmZmZmZmZmYgODIwMDlkNzggNzkwN2E5ZWIgMDAwMDAwMDEgODIwMDlkNjQg
MDAwMDAwMDAKWyAgICAyLjYzMDAxM10gIDAwMDAwMDU3IDgyN2ZhMDBjIDAwMDAwMjQ2IDAw
MDAwMDIxIDhhNzY1M2Q0IDhhNGQwZjljIDgyN2ZhMDAwIDgyMDA5ZGIwClsgICAgMi42MzAw
MTNdICA4MjAwOWRjNCA4MjAwOWQ4YyA3OTA4NjFkZCA4MjAwOWRiMCA4MjAxMDI4MCAwMDAw
MDAwMCA4MjAwOWQ5YyA3OTA4NjFmZQpbICAgIDIuNjMwMDEzXSBDYWxsIFRyYWNlOgpbICAg
IDIuNjMwMDEzXSAgWzw3OTA3YTllYj5dIHJlbGVhc2VfcGFnZXMrMHg1OC8weDE3NQpbICAg
IDIuNjMwMDEzXSAgWzw3OTA4NjFkZD5dIHRsYl9mbHVzaF9tbXUrMHgzMC8weDQ1ClsgICAg
Mi42MzAwMTNdICBbPDc5MDg2MWZlPl0gdGxiX2ZpbmlzaF9tbXUrMHhjLzB4MmIKWyAgICAy
LjYzMDAxM10gIFs8NzkwOGJiMWQ+XSBleGl0X21tYXArMHg4NC8weGNiClsgICAgMi42MzAw
MTNdICBbPDc5MDI1OGZmPl0gbW1wdXQrMHgyYy8weGIxClsgICAgMi42MzAwMTNdICBbPDc5
MGExYTljPl0gZmx1c2hfb2xkX2V4ZWMrMHg0OTEvMHg1NDYKWyAgICAyLjYzMDAxM10gIFs8
NzkwYzFlMGM+XSBsb2FkX2VsZl9iaW5hcnkrMHgyNzIvMHhiOTYKWyAgICAyLjYzMDAxM10g
IFs8NzkwYTEwNjE+XSBzZWFyY2hfYmluYXJ5X2hhbmRsZXIrMHg1Zi8weDE0NQpbICAgIDIu
NjMwMDEzXSAgWzw3OTBjMTllMj5dIGxvYWRfc2NyaXB0KzB4MTdhLzB4MTgzClsgICAgMi42
MzAwMTNdICBbPDc5MDQxOTkwPl0gPyBzY2hlZF9jbG9ja19jcHUrMHhhYS8weGQzClsgICAg
Mi42MzAwMTNdICBbPDc5MDQ4MGQwPl0gPyBsb2NrX3JlbGVhc2UrMHgxMzgvMHgxOTIKWyAg
ICAyLjYzMDAxM10gIFs8NzkzMGQ4MzQ+XSA/IF9yYXdfcmVhZF91bmxvY2srMHgyNy8weDM4
ClsgICAgMi42MzAwMTNdICBbPDc5MGExMDYxPl0gc2VhcmNoX2JpbmFyeV9oYW5kbGVyKzB4
NWYvMHgxNDUKWyAgICAyLjYzMDAxM10gIFs8NzkwYTIxMGU+XSBkb19leGVjdmUrMHgzNzEv
MHg0N2MKWyAgICAyLjYzMDAxM10gIFs8NzkwYTIzNmQ+XSBTeVNfZXhlY3ZlKzB4MWMvMHgy
MApbICAgIDIuNjMwMDEzXSAgWzw3OTMxMTc1NT5dIHN5c2VudGVyX2RvX2NhbGwrMHgxMi8w
eDM3ClsgICAgMi42MzAwMTNdIENvZGU6IDBmIDg0IGEzIDAwIDAwIDAwIDg5IGQ4IGU4IDgx
IGZjIGZmIGZmIDg1IGMwIDc1IDBiIDMxIGQyIDg5IGQ4IGU4IDBhIGM2IGZmIGZmIDBmIDBi
IDhiIDQ2IDBjIDQwIDc0IDBiIDMxIGQyIDg5IGYwIGU4IGY5IGM1IGZmIGZmIDwwZj4gMGIg
ODkgZDggZTggZDAgZmMgZmYgZmYgODUgYzAgMGYgODQgNDcgMDEgMDAgMDAgOGIgMDMgYTgg
ODAKWyAgICAyLjYzMDAxM10gRUlQOiBbPDc5MDdhN2ViPl0gcHV0X2NvbXBvdW5kX3BhZ2Ur
MHg3ZC8weDFkYSBTUzpFU1AgMDA2ODo4MjAwOWQzNApbICAgIDIuNjQ3Njg5XSAtLS1bIGVu
ZCB0cmFjZSAwNTM5ODY3OWRmNDQxODY3IF0tLS0KWyAgICAyLjkyMDA3NV0gdHNjOiBSZWZp
bmVkIFRTQyBjbG9ja3NvdXJjZSBjYWxpYnJhdGlvbjogMjQ5My45NjQgTUh6Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy83YmJjYmY0MmY1ZDg1ZjE1ZWQ0ZjI4ODY1
ZTUzMWQ0YzQ5ODRmNTkxL2RtZXNnLXF1YW50YWwtaXZ5dG93bjItNTg6MjAxNDAzMjEyMTM1
MDI6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNzozLjE0LjAtcmM3LTA3NjU3LWc3YmJj
YmY0OjEKMDoxOjEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzogNzI0
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMCBzdGVwcykK
WzhmNzUyYzRkNWQ5NzZmZWIwNjQwZGIwOTE2ODdhYzVkYTcxNGJmOWFdIE1lcmdlIHJlbW90
ZS10cmFja2luZyBicmFuY2ggJ3NwaS9mb3ItbmV4dCcKcnVubmluZyAvYy9rZXJuZWwtdGVz
dHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9zb3VuZC9vYmotYmlz
ZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
YmExLTAzMjExMjM3L25leHQ6bWFzdGVyOjhmNzUyYzRkNWQ5NzZmZWIwNjQwZGIwOTE2ODdh
YzVkYTcxNGJmOWE6YmlzZWN0LXNvdW5kCgoyMDE0LTAzLTIxLTIxOjM1OjQ0IDhmNzUyYzRk
NWQ5NzZmZWIwNjQwZGIwOTE2ODdhYzVkYTcxNGJmOWEgY29tcGlsaW5nClF1ZXVlZCBidWls
ZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWJh
MS0wMzIxMTIzNy04Zjc1MmM0ZDVkOTc2ZmViMDY0MGRiMDkxNjg3YWM1ZGE3MTRiZjlhCkNo
ZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3
LzhmNzUyYzRkNWQ5NzZmZWIwNjQwZGIwOTE2ODdhYzVkYTcxNGJmOWEKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZp
Zy1iYTEtMDMyMTEyMzctOGY3NTJjNGQ1ZDk3NmZlYjA2NDBkYjA5MTY4N2FjNWRhNzE0YmY5
YQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUv
LmkzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzctOGY3NTJjNGQ1ZDk3NmZlYjA2NDBkYjA5
MTY4N2FjNWRhNzE0YmY5YQprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0w
MzIxMTIzNy84Zjc1MmM0ZDVkOTc2ZmViMDY0MGRiMDkxNjg3YWM1ZGE3MTRiZjlhL3ZtbGlu
dXotMy4xNC4wLXJjNy0wNzEyMS1nOGY3NTJjNAoKMjAxNC0wMy0yMS0yMjowMTo0NCBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAuLi4JMgk2CTEyCTE1CTE5CTIxIFNVQ0NFU1MKCmxpbmVhci1i
aXNlY3Q6IGJhZCBicmFuY2ggbWF5IGJlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ3RpcC9h
dXRvLWxhdGVzdCcKbGluZWFyLWJpc2VjdDogaGFuZGxlIG92ZXIgdG8gZ2l0IGJpc2VjdAps
aW5lYXItYmlzZWN0OiBnaXQgYmlzZWN0IHN0YXJ0IDdiYmNiZjQyZjVkODVmMTVlZDRmMjg4
NjVlNTMxZDRjNDk4NGY1OTEgOGY3NTJjNGQ1ZDk3NmZlYjA2NDBkYjA5MTY4N2FjNWRhNzE0
YmY5YSAtLQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA4Zjc1MmM0Li4uIE1lcmdlIHJl
bW90ZS10cmFja2luZyBicmFuY2ggJ3NwaS9mb3ItbmV4dCcKSEVBRCBpcyBub3cgYXQgYzFi
ZTVhNS4uLiBMaW51eCAzLjkKQmlzZWN0aW5nOiAyNjAgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDggc3RlcHMpClsxMGM4Zjk3NTI4M2RjNmZlMTgwZDNk
ZmQ3ZTI3OTY4ZGNjY2ZiODFmXSBNZXJnZSBicmFuY2ggJ3BlcmYvY29yZScKbGluZWFyLWJp
c2VjdDogZ2l0IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvaG9tZS93Zmcvc291bmQvb2JqLWJpc2VjdApydW5uaW5nIC9jL2tlcm5l
bC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3NvdW5kL29i
ai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNv
bmZpZy1iYTEtMDMyMTEyMzcvbmV4dDptYXN0ZXI6MTBjOGY5NzUyODNkYzZmZTE4MGQzZGZk
N2UyNzk2OGRjY2NmYjgxZjpiaXNlY3Qtc291bmQKCjIwMTQtMDMtMjEtMjI6MDY6NTQgMTBj
OGY5NzUyODNkYzZmZTE4MGQzZGZkN2UyNzk2OGRjY2NmYjgxZiBjb21waWxpbmcKUXVldWVk
IGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25m
aWctYmExLTAzMjExMjM3LTEwYzhmOTc1MjgzZGM2ZmUxODBkM2RmZDdlMjc5NjhkY2NjZmI4
MWYKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMy
MTEyMzcvMTBjOGY5NzUyODNkYzZmZTE4MGQzZGZkN2UyNzk2OGRjY2NmYjgxZgp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5k
Y29uZmlnLWJhMS0wMzIxMTIzNy0xMGM4Zjk3NTI4M2RjNmZlMTgwZDNkZmQ3ZTI3OTY4ZGNj
Y2ZiODFmCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1x
dWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy0xMGM4Zjk3NTI4M2RjNmZlMTgw
ZDNkZmQ3ZTI3OTY4ZGNjY2ZiODFmCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
YmExLTAzMjExMjM3LzEwYzhmOTc1MjgzZGM2ZmUxODBkM2RmZDdlMjc5NjhkY2NjZmI4MWYv
dm1saW51ei0zLjE0LjAtcmM3LTAwMzA0LWcxMGM4Zjk3CgoyMDE0LTAzLTIxLTIyOjI2OjU0
IGRldGVjdGluZyBib290IHN0YXRlIC4uCTgJMjEgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxMjkg
cmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDcgc3RlcHMpCls4
MDYxZGE1ZGZmZmZjNDM5OWRmMTdhNTE3NTkyYTU2NTJhM2Q5MzFjXSBNZXJnZSBicmFuY2gg
J3g4Ni9hcGljJwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2hvbWUvd2ZnL3NvdW5kL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvbmV4dDptYXN0
ZXI6ODA2MWRhNWRmZmZmYzQzOTlkZjE3YTUxNzU5MmE1NjUyYTNkOTMxYzpiaXNlY3Qtc291
bmQKCjIwMTQtMDMtMjEtMjI6Mjg6NTYgODA2MWRhNWRmZmZmYzQzOTlkZjE3YTUxNzU5MmE1
NjUyYTNkOTMxYyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0
cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LTgwNjFkYTVkZmZm
ZmM0Mzk5ZGYxN2E1MTc1OTJhNTY1MmEzZDkzMWMKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvODA2MWRhNWRmZmZmYzQzOTlkZjE3
YTUxNzU5MmE1NjUyYTNkOTMxYwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwt
dGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy04MDYxZGE1
ZGZmZmZjNDM5OWRmMTdhNTE3NTkyYTU2NTJhM2Q5MzFjCndhaXRpbmcgZm9yIGNvbXBsZXRp
b24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWJhMS0w
MzIxMTIzNy04MDYxZGE1ZGZmZmZjNDM5OWRmMTdhNTE3NTkyYTU2NTJhM2Q5MzFjCmtlcm5l
bDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LzgwNjFkYTVkZmZmZmM0
Mzk5ZGYxN2E1MTc1OTJhNTY1MmEzZDkzMWMvdm1saW51ei0zLjE0LjAtcmM3LTAwNDM2LWc4
MDYxZGE1CgoyMDE0LTAzLTIxLTIzOjA0OjU2IGRldGVjdGluZyBib290IHN0YXRlIC4JMQkx
NgkyMSBTVUNDRVNTCgpCaXNlY3Rpbmc6IDgxIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0
ZXIgdGhpcyAocm91Z2hseSA2IHN0ZXBzKQpbZjA2NjQwZDU1MTlkZDVmN2VlMjExYjUzMGQ5
YTQ0ZjU0MDJmYjMwMl0gTWVyZ2UgYnJhbmNoICd4ODYvZGVidWcnCnJ1bm5pbmcgL2Mva2Vy
bmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcvc291bmQv
b2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5k
Y29uZmlnLWJhMS0wMzIxMTIzNy9uZXh0Om1hc3RlcjpmMDY2NDBkNTUxOWRkNWY3ZWUyMTFi
NTMwZDlhNDRmNTQwMmZiMzAyOmJpc2VjdC1zb3VuZAoKMjAxNC0wMy0yMS0yMzowNjo1OSBm
MDY2NDBkNTUxOWRkNWY3ZWUyMTFiNTMwZDlhNDRmNTQwMmZiMzAyIGNvbXBpbGluZwpRdWV1
ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNv
bmZpZy1iYTEtMDMyMTEyMzctZjA2NjQwZDU1MTlkZDVmN2VlMjExYjUzMGQ5YTQ0ZjU0MDJm
YjMwMgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0w
MzIxMTIzNy9mMDY2NDBkNTUxOWRkNWY3ZWUyMTFiNTMwZDlhNDRmNTQwMmZiMzAyCndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJh
bmRjb25maWctYmExLTAzMjExMjM3LWYwNjY0MGQ1NTE5ZGQ1ZjdlZTIxMWI1MzBkOWE0NGY1
NDAyZmIzMDIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxk
LXF1ZXVlLy5pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LWYwNjY0MGQ1NTE5ZGQ1Zjdl
ZTIxMWI1MzBkOWE0NGY1NDAyZmIzMDIKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1iYTEtMDMyMTEyMzcvZjA2NjQwZDU1MTlkZDVmN2VlMjExYjUzMGQ5YTQ0ZjU0MDJmYjMw
Mi92bWxpbnV6LTMuMTQuMC1yYzctMDA0ODQtZ2YwNjY0MGQKCjIwMTQtMDMtMjItMDA6MDI6
NTkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4JMjEgU1VDQ0VTUwoKQmlzZWN0aW5n
OiA0MSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNSBzdGVw
cykKW2MyODA4N2NhNzM4MTJkOTM1MTZhMDYwOTlmZTQ5OTk3YTBmOGQyYzBdIE1lcmdlIGJy
YW5jaCAneDg2L21tJwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290
LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3NvdW5kL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10
ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvbmV4dDpt
YXN0ZXI6YzI4MDg3Y2E3MzgxMmQ5MzUxNmEwNjA5OWZlNDk5OTdhMGY4ZDJjMDpiaXNlY3Qt
c291bmQKCjIwMTQtMDMtMjItMDA6MDc6MzIgYzI4MDg3Y2E3MzgxMmQ5MzUxNmEwNjA5OWZl
NDk5OTdhMGY4ZDJjMCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10
ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LWMyODA4N2Nh
NzM4MTJkOTM1MTZhMDYwOTlmZTQ5OTk3YTBmOGQyYzAKQ2hlY2sgZm9yIGtlcm5lbCBpbiAv
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvYzI4MDg3Y2E3MzgxMmQ5MzUx
NmEwNjA5OWZlNDk5OTdhMGY4ZDJjMAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJu
ZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy1jMjgw
ODdjYTczODEyZDkzNTE2YTA2MDk5ZmU0OTk5N2EwZjhkMmMwCndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWJh
MS0wMzIxMTIzNy1jMjgwODdjYTczODEyZDkzNTE2YTA2MDk5ZmU0OTk5N2EwZjhkMmMwCmtl
cm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3L2MyODA4N2NhNzM4
MTJkOTM1MTZhMDYwOTlmZTQ5OTk3YTBmOGQyYzAvdm1saW51ei0zLjE0LjAtcmM3LTAwNTI0
LWdjMjgwODdjCgoyMDE0LTAzLTIyLTAwOjM0OjMzIGRldGVjdGluZyBib290IHN0YXRlIC4u
CTIxIFNVQ0NFU1MKCkJpc2VjdGluZzogMjAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRl
ciB0aGlzIChyb3VnaGx5IDQgc3RlcHMpCls0ZGFiOTNjYzk3YWQ4NWI3YWJiYzZiNzA1MzFi
NDEyYTNiMWQ2YWEyXSBNZXJnZSBicmFuY2ggJ3g4Ni90aHJlYWRpbmZvJwpydW5uaW5nIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3Nv
dW5kL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYt
cmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvbmV4dDptYXN0ZXI6NGRhYjkzY2M5N2FkODViN2Fi
YmM2YjcwNTMxYjQxMmEzYjFkNmFhMjpiaXNlY3Qtc291bmQKCjIwMTQtMDMtMjItMDA6MzY6
MDUgNGRhYjkzY2M5N2FkODViN2FiYmM2YjcwNTMxYjQxMmEzYjFkNmFhMiBjb21waWxpbmcK
UXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJh
bmRjb25maWctYmExLTAzMjExMjM3LTRkYWI5M2NjOTdhZDg1YjdhYmJjNmI3MDUzMWI0MTJh
M2IxZDZhYTIKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1i
YTEtMDMyMTEyMzcvNGRhYjkzY2M5N2FkODViN2FiYmM2YjcwNTMxYjQxMmEzYjFkNmFhMgp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4
Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy00ZGFiOTNjYzk3YWQ4NWI3YWJiYzZiNzA1MzFi
NDEyYTNiMWQ2YWEyCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9i
dWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy00ZGFiOTNjYzk3YWQ4
NWI3YWJiYzZiNzA1MzFiNDEyYTNiMWQ2YWEyCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYmExLTAzMjExMjM3LzRkYWI5M2NjOTdhZDg1YjdhYmJjNmI3MDUzMWI0MTJhM2Ix
ZDZhYTIvdm1saW51ei0zLjE0LjAtcmM3LTAwNTQ1LWc0ZGFiOTNjCgoyMDE0LTAzLTIyLTAx
OjI2OjA1IGRldGVjdGluZyBib290IHN0YXRlIAkxCTIxIFNVQ0NFU1MKCkJpc2VjdGluZzog
MTAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3RlcHMp
CltlZjcyMTk4N2FlZjBjYzBhYmJhMDhjODg4MTBmMjE1NWY3NmIwYjFmXSB4ODYsIHZkc286
IEludHJvZHVjZSBWVkFSIG1hcmNvIGZvciB2ZHNvMzIKcnVubmluZyAvYy9rZXJuZWwtdGVz
dHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9zb3VuZC9vYmotYmlz
ZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
YmExLTAzMjExMjM3L25leHQ6bWFzdGVyOmVmNzIxOTg3YWVmMGNjMGFiYmEwOGM4ODgxMGYy
MTU1Zjc2YjBiMWY6YmlzZWN0LXNvdW5kCgoyMDE0LTAzLTIyLTAxOjI3OjA5IGVmNzIxOTg3
YWVmMGNjMGFiYmEwOGM4ODgxMGYyMTU1Zjc2YjBiMWYgY29tcGlsaW5nClF1ZXVlZCBidWls
ZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWJh
MS0wMzIxMTIzNy1lZjcyMTk4N2FlZjBjYzBhYmJhMDhjODg4MTBmMjE1NWY3NmIwYjFmCkNo
ZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3
L2VmNzIxOTg3YWVmMGNjMGFiYmEwOGM4ODgxMGYyMTU1Zjc2YjBiMWYKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZp
Zy1iYTEtMDMyMTEyMzctZWY3MjE5ODdhZWYwY2MwYWJiYTA4Yzg4ODEwZjIxNTVmNzZiMGIx
Zgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUv
LmkzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzctZWY3MjE5ODdhZWYwY2MwYWJiYTA4Yzg4
ODEwZjIxNTVmNzZiMGIxZgprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0w
MzIxMTIzNy9lZjcyMTk4N2FlZjBjYzBhYmJhMDhjODg4MTBmMjE1NWY3NmIwYjFmL3ZtbGlu
dXotMy4xNC4wLXJjNi0wMDAxMC1nZWY3MjE5ODcKCjIwMTQtMDMtMjItMDE6NDk6MDkgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgLgkyCTExCTEzCTIwCTIxIFNVQ0NFU1MKCkJpc2VjdGluZzog
NSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMyBzdGVwcykK
WzAwOGNjOTA3ZGUzMjdkODNhMGJlNjA5Y2Q0OTVmY2NiMGU1ZGZhNGNdIHg4NiwgdmRzbzMy
OiBEaXNhYmxlIHN0YWNrIHByb3RlY3RvciwgYWRqdXN0IG9wdGltaXphdGlvbnMKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dm
Zy9zb3VuZC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9p
Mzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3L25leHQ6bWFzdGVyOjAwOGNjOTA3ZGUzMjdk
ODNhMGJlNjA5Y2Q0OTVmY2NiMGU1ZGZhNGM6YmlzZWN0LXNvdW5kCgoyMDE0LTAzLTIyLTAx
OjUyOjEzIDAwOGNjOTA3ZGUzMjdkODNhMGJlNjA5Y2Q0OTVmY2NiMGU1ZGZhNGMgY29tcGls
aW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4
Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy0wMDhjYzkwN2RlMzI3ZDgzYTBiZTYwOWNkNDk1
ZmNjYjBlNWRmYTRjCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctYmExLTAzMjExMjM3LzAwOGNjOTA3ZGUzMjdkODNhMGJlNjA5Y2Q0OTVmY2NiMGU1ZGZh
NGMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVl
L2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzctMDA4Y2M5MDdkZTMyN2Q4M2EwYmU2MDlj
ZDQ5NWZjY2IwZTVkZmE0Ywp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVz
dHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzctMDA4Y2M5MDdk
ZTMyN2Q4M2EwYmU2MDljZDQ5NWZjY2IwZTVkZmE0YwprZXJuZWw6IC9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWJhMS0wMzIxMTIzNy8wMDhjYzkwN2RlMzI3ZDgzYTBiZTYwOWNkNDk1ZmNj
YjBlNWRmYTRjL3ZtbGludXotMy4xNC4wLXJjNi0wMDAxNS1nMDA4Y2M5MAoKMjAxNC0wMy0y
Mi0wMjo0OToxMyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgk0CTIxIFNVQ0NFU1MKCkJpc2Vj
dGluZzogMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMiBz
dGVwcykKW2RjZTQ0ZTAzYjBhMzQ0OGFkMTFhYzZjNmUwY2JlMjk5ZTA0MDA3OTFdIGNvbXBh
dDogRml4IHNwYXJzZSBhZGRyZXNzIHNwYWNlIHdhcm5pbmdzCnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcvc291bmQvb2Jq
LWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLWJhMS0wMzIxMTIzNy9uZXh0Om1hc3RlcjpkY2U0NGUwM2IwYTM0NDhhZDExYWM2YzZl
MGNiZTI5OWUwNDAwNzkxOmJpc2VjdC1zb3VuZAoKMjAxNC0wMy0yMi0wMjo1MToxNyBkY2U0
NGUwM2IwYTM0NDhhZDExYWM2YzZlMGNiZTI5OWUwNDAwNzkxIGNvbXBpbGluZwpRdWV1ZWQg
YnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZp
Zy1iYTEtMDMyMTEyMzctZGNlNDRlMDNiMGEzNDQ4YWQxMWFjNmM2ZTBjYmUyOTllMDQwMDc5
MQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIx
MTIzNy9kY2U0NGUwM2IwYTM0NDhhZDExYWM2YzZlMGNiZTI5OWUwNDAwNzkxCndhaXRpbmcg
Zm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRj
b25maWctYmExLTAzMjExMjM3LWRjZTQ0ZTAzYjBhMzQ0OGFkMTFhYzZjNmUwY2JlMjk5ZTA0
MDA3OTEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1
ZXVlLy5pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LWRjZTQ0ZTAzYjBhMzQ0OGFkMTFh
YzZjNmUwY2JlMjk5ZTA0MDA3OTEKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1i
YTEtMDMyMTEyMzcvZGNlNDRlMDNiMGEzNDQ4YWQxMWFjNmM2ZTBjYmUyOTllMDQwMDc5MS92
bWxpbnV6LTMuMTMuMC0xMDg1My1nZGNlNDRlMAoKMjAxNC0wMy0yMi0wNDowODoxNyBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAuLi4JMS4uLi4JMwk3CTE0CTIxIFNVQ0NFU1MKCkJpc2VjdGlu
ZzogMSByZXZpc2lvbiBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0ZXAp
CltlYjE2YjVlYTI3M2JkN2IwMGY1MTJkN2VjM2FkNjA3MGRkMTIwNjIzXSBNZXJnZSBicmFu
Y2ggJ3g4Ni92ZHNvJwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290
LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3NvdW5kL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10
ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvbmV4dDpt
YXN0ZXI6ZWIxNmI1ZWEyNzNiZDdiMDBmNTEyZDdlYzNhZDYwNzBkZDEyMDYyMzpiaXNlY3Qt
c291bmQKCjIwMTQtMDMtMjItMDQ6MTQ6MjEgZWIxNmI1ZWEyNzNiZDdiMDBmNTEyZDdlYzNh
ZDYwNzBkZDEyMDYyMyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10
ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LWViMTZiNWVh
MjczYmQ3YjAwZjUxMmQ3ZWMzYWQ2MDcwZGQxMjA2MjMKQ2hlY2sgZm9yIGtlcm5lbCBpbiAv
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvZWIxNmI1ZWEyNzNiZDdiMDBm
NTEyZDdlYzNhZDYwNzBkZDEyMDYyMwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJu
ZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy1lYjE2
YjVlYTI3M2JkN2IwMGY1MTJkN2VjM2FkNjA3MGRkMTIwNjIzCndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWJh
MS0wMzIxMTIzNy1lYjE2YjVlYTI3M2JkN2IwMGY1MTJkN2VjM2FkNjA3MGRkMTIwNjIzCmtl
cm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3L2ViMTZiNWVhMjcz
YmQ3YjAwZjUxMmQ3ZWMzYWQ2MDcwZGQxMjA2MjMvdm1saW51ei0zLjE0LjAtcmM3LTAwNTYy
LWdlYjE2YjVlCgoyMDE0LTAzLTIyLTA0OjMyOjIxIGRldGVjdGluZyBib290IHN0YXRlIC4g
VEVTVCBGQUlMVVJFClsgICAgMi42MzU2NzddIHBhZ2U6OGE3MDE1MjggY291bnQ6MCBtYXBj
b3VudDoxIG1hcHBpbmc6ICAobnVsbCkgaW5kZXg6MHgwClsgICAgMi42MzYzMzZdIHBhZ2Ug
ZmxhZ3M6IDB4NDAwMDgwMDQocmVmZXJlbmNlZHx0YWlsKQpbICAgIDIuNjM2ODY3XSAtLS0t
LS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAyLjYzNzMyMF0ga2VybmVs
IEJVRyBhdCBtbS9zd2FwLmM6MTM0IQpbICAgIDIuNjM3ODk4XSBpbnZhbGlkIG9wY29kZTog
MDAwMCBbIzFdIFBSRUVNUFQgREVCVUdfUEFHRUFMTE9DClsgICAgMi42Mzg1MDddIE1vZHVs
ZXMgbGlua2VkIGluOgpbICAgIDIuNjM4ODIyXSBDUFU6IDAgUElEOiA2NyBDb21tOiBpbml0
IE5vdCB0YWludGVkIDMuMTQuMC1yYzctMDA1NjItZ2ViMTZiNWUgIzEKWyAgICAyLjYzOTUx
NV0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpb
ICAgIDIuNjQwMDEzXSB0YXNrOiA4MmIxZDRlMCB0aTogODIwMDAwMDAgdGFzay50aTogODIw
MDAwMDAKWyAgICAyLjY0MDAxM10gRUlQOiAwMDYwOls8NzkwN2E3NzU+XSBFRkxBR1M6IDAw
MDEwMjQ2IENQVTogMApbICAgIDIuNjQwMDEzXSBFSVAgaXMgYXQgcHV0X2NvbXBvdW5kX3Bh
Z2UrMHg3ZC8weDFkYQpbICAgIDIuNjQwMDEzXSBFQVg6IDc5NTBiNmQxIEVCWDogOGE3MDE1
MDAgRUNYOiA3OTA0YjY0YSBFRFg6IDAwMDAwMDAxClsgICAgMi42NDAwMTNdIEVTSTogOGE3
MDE1MjggRURJOiBmZmZmZmZmZiBFQlA6IDgyMDAxZDQwIEVTUDogODIwMDFkMzQKWyAgICAy
LjY0MDAxM10gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMDAwIEdTOiAwMDAwIFNTOiAwMDY4
ClsgICAgMi42NDAwMTNdIENSMDogODAwNTAwM2IgQ1IyOiA2ZjRmNzQ2MCBDUjM6IDBhMDFk
MDAwIENSNDogMDAwMDA2ZDAKWyAgICAyLjY0MDAxM10gU3RhY2s6ClsgICAgMi42NDAwMTNd
ICA4YTcwMTUyOCAwMDAwMDAwMCBmZmZmZmZmZiA4MjAwMWQ3OCA3OTA3YTk3NSAwMDAwMDAw
MSA4MjAwMWQ2NCAwMDAwMDAwMApbICAgIDIuNjQwMDEzXSAgMDAwMDAwNTcgODIwMWYwMGMg
MDAwMDAyNDYgMDAwMDAwMjEgOGE3NjUyZTQgOGE3NjQ1NGMgODIwMWYwMDAgODIwMDFkYjAK
WyAgICAyLjY0MDAxM10gIDgyMDAxZGM0IDgyMDAxZDhjIDc5MDg2MDM5IDgyMDAxZGIwIDgy
MDBlMjgwIDAwMDAwMDAwIDgyMDAxZDljIDc5MDg2MDVhClsgICAgMi42NDAwMTNdIENhbGwg
VHJhY2U6ClsgICAgMi42NDAwMTNdICBbPDc5MDdhOTc1Pl0gcmVsZWFzZV9wYWdlcysweDU4
LzB4MTc1ClsgICAgMi42NDAwMTNdICBbPDc5MDg2MDM5Pl0gdGxiX2ZsdXNoX21tdSsweDMw
LzB4NDUKWyAgICAyLjY0MDAxM10gIFs8NzkwODYwNWE+XSB0bGJfZmluaXNoX21tdSsweGMv
MHgyYgpbICAgIDIuNjQwMDEzXSAgWzw3OTA4Yjk3OT5dIGV4aXRfbW1hcCsweDg0LzB4Y2IK
WyAgICAyLjY0MDAxM10gIFs8NzkwMjU4ZjM+XSBtbXB1dCsweDJjLzB4YjEKWyAgICAyLjY0
MDAxM10gIFs8NzkwYTE4NjQ+XSBmbHVzaF9vbGRfZXhlYysweDQ5MS8weDU0NgpbICAgIDIu
NjQwMDEzXSAgWzw3OTBjMWJjYT5dIGxvYWRfZWxmX2JpbmFyeSsweDI3Mi8weGI5NgpbICAg
IDIuNjQwMDEzXSAgWzw3OTBhMGUyOT5dIHNlYXJjaF9iaW5hcnlfaGFuZGxlcisweDVmLzB4
MTQ1ClsgICAgMi42NDAwMTNdICBbPDc5MGMxN2EwPl0gbG9hZF9zY3JpcHQrMHgxN2EvMHgx
ODMKWyAgICAyLjY0MDAxM10gIFs8NzkwNDE5NDY+XSA/IHNjaGVkX2Nsb2NrX2NwdSsweGFh
LzB4ZDMKWyAgICAyLjY0MDAxM10gIFs8NzkwNDgwODY+XSA/IGxvY2tfcmVsZWFzZSsweDEz
OC8weDE5MgpbICAgIDIuNjQwMDEzXSAgWzw3OTMwYmM3ND5dID8gX3Jhd19yZWFkX3VubG9j
aysweDI3LzB4MzgKWyAgICAyLjY0MDAxM10gIFs8NzkwYTBlMjk+XSBzZWFyY2hfYmluYXJ5
X2hhbmRsZXIrMHg1Zi8weDE0NQpbICAgIDIuNjQwMDEzXSAgWzw3OTBhMWVkNj5dIGRvX2V4
ZWN2ZSsweDM3MS8weDQ3YwpbICAgIDIuNjQwMDEzXSAgWzw3OTBhMjEzNT5dIFN5U19leGVj
dmUrMHgxYy8weDIwClsgICAgMi42NDAwMTNdICBbPDc5MzBmYjk1Pl0gc3lzZW50ZXJfZG9f
Y2FsbCsweDEyLzB4MzcKWyAgICAyLjY0MDAxM10gQ29kZTogMGYgODQgYTMgMDAgMDAgMDAg
ODkgZDggZTggODEgZmMgZmYgZmYgODUgYzAgNzUgMGIgMzEgZDIgODkgZDggZTggMGEgYzYg
ZmYgZmYgMGYgMGIgOGIgNDYgMGMgNDAgNzQgMGIgMzEgZDIgODkgZjAgZTggZjkgYzUgZmYg
ZmYgPDBmPiAwYiA4OSBkOCBlOCBkMCBmYyBmZiBmZiA4NSBjMCAwZiA4NCA0NyAwMSAwMCAw
MCA4YiAwMyBhOCA4MApbICAgIDIuNjQwMDEzXSBFSVA6IFs8NzkwN2E3NzU+XSBwdXRfY29t
cG91bmRfcGFnZSsweDdkLzB4MWRhIFNTOkVTUCAwMDY4OjgyMDAxZDM0ClsgICAgMi42NTc3
NDFdIC0tLVsgZW5kIHRyYWNlIGMzYzVkYmFkOTYwNjY0ODUgXS0tLQpbICAgIDIuOTEwMTA4
XSB0c2M6IFJlZmluZWQgVFNDIGNsb2Nrc291cmNlIGNhbGlicmF0aW9uOiAyNDkzLjk1NyBN
SHoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3L2ViMTZiNWVhMjczYmQ3
YjAwZjUxMmQ3ZWMzYWQ2MDcwZGQxMjA2MjMvZG1lc2cteW9jdG8taXZ5dG93bjItMToyMDE0
MDMyMjA0MzIwODppMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3OjMuMTQuMC1yYzctMDA1
NjItZ2ViMTZiNWU6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvZWIx
NmI1ZWEyNzNiZDdiMDBmNTEyZDdlYzNhZDYwNzBkZDEyMDYyMy9kbWVzZy15b2N0by1pdnl0
b3duMi0yNzoyMDE0MDMyMjA0MzIwNzppMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3OjMu
MTQuMC1yYzctMDA1NjItZ2ViMTZiNWU6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEt
MDMyMTEyMzcvZWIxNmI1ZWEyNzNiZDdiMDBmNTEyZDdlYzNhZDYwNzBkZDEyMDYyMy9kbWVz
Zy1xdWFudGFsLWl2eXRvd24yLTI6MjAxNDAzMjIwNDMyMTk6aTM4Ni1yYW5kY29uZmlnLWJh
MS0wMzIxMTIzNzozLjE0LjAtcmM3LTAwNTYyLWdlYjE2YjVlOjEKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctYmExLTAzMjExMjM3L2ViMTZiNWVhMjczYmQ3YjAwZjUxMmQ3ZWMzYWQ2MDcw
ZGQxMjA2MjMvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi01NzoyMDE0MDMyMjA0MzIxODppMzg2
LXJhbmRjb25maWctYmExLTAzMjExMjM3OjMuMTQuMC1yYzctMDA1NjItZ2ViMTZiNWU6MQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvZWIxNmI1ZWEyNzNiZDdiMDBm
NTEyZDdlYzNhZDYwNzBkZDEyMDYyMy9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTYxOjIwMTQw
MzIyMDQzMjE5OmkzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzc6My4xNC4wLXJjNy0wMDU2
Mi1nZWIxNmI1ZToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy9lYjE2
YjVlYTI3M2JkN2IwMGY1MTJkN2VjM2FkNjA3MGRkMTIwNjIzL2RtZXNnLXF1YW50YWwtaXZ5
dG93bjItODE6MjAxNDAzMjIwNDMyMTc6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNzoz
LjE0LjAtcmM3LTAwNTYyLWdlYjE2YjVlOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmEx
LTAzMjExMjM3L2ViMTZiNWVhMjczYmQ3YjAwZjUxMmQ3ZWMzYWQ2MDcwZGQxMjA2MjMvZG1l
c2cteW9jdG8taXZ5dG93bjItMToyMDE0MDMyMjA0MzIxNzppMzg2LXJhbmRjb25maWctYmEx
LTAzMjExMjM3OjMuMTQuMC1yYzctMDA1NjItZ2ViMTZiNWU6MQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1iYTEtMDMyMTEyMzcvZWIxNmI1ZWEyNzNiZDdiMDBmNTEyZDdlYzNhZDYwNzBk
ZDEyMDYyMy9kbWVzZy15b2N0by1pdnl0b3duMi0yMToyMDE0MDMyMjA0MzIxOTppMzg2LXJh
bmRjb25maWctYmExLTAzMjExMjM3OjMuMTQuMC1yYzctMDA1NjItZ2ViMTZiNWU6MQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvZWIxNmI1ZWEyNzNiZDdiMDBmNTEy
ZDdlYzNhZDYwNzBkZDEyMDYyMy9kbWVzZy15b2N0by1pdnl0b3duMi0yNzoyMDE0MDMyMjA0
MzIxNzppMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3OjMuMTQuMC1yYzctMDA1NjItZ2Vi
MTZiNWU6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvZWIxNmI1ZWEy
NzNiZDdiMDBmNTEyZDdlYzNhZDYwNzBkZDEyMDYyMy9kbWVzZy15b2N0by1pdnl0b3duMi0z
NzoyMDE0MDMyMjA0MzIxNDppMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3OjMuMTQuMC1y
YzctMDA1NjItZ2ViMTZiNWU6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEy
MzcvZWIxNmI1ZWEyNzNiZDdiMDBmNTEyZDdlYzNhZDYwNzBkZDEyMDYyMy9kbWVzZy15b2N0
by1pdnl0b3duMi04MzoyMDE0MDMyMjA0MzIxNDppMzg2LXJhbmRjb25maWctYmExLTAzMjEx
MjM3OjMuMTQuMC1yYzctMDA1NjItZ2ViMTZiNWU6MQova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1iYTEtMDMyMTEyMzcvZWIxNmI1ZWEyNzNiZDdiMDBmNTEyZDdlYzNhZDYwNzBkZDEyMDYy
My9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTcyOjIwMTQwMzIyMDQzMjIxOmkzODYtcmFuZGNv
bmZpZy1iYTEtMDMyMTEyMzc6My4xNC4wLXJjNy0wMDU2Mi1nZWIxNmI1ZToxCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy9lYjE2YjVlYTI3M2JkN2IwMGY1MTJkN2Vj
M2FkNjA3MGRkMTIwNjIzL2RtZXNnLXF1YW50YWwtaXZ5dG93bjItODk6MjAxNDAzMjIwNDMy
MjI6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNzozLjE0LjAtcmM3LTAwNTYyLWdlYjE2
YjVlOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3L2ViMTZiNWVhMjcz
YmQ3YjAwZjUxMmQ3ZWMzYWQ2MDcwZGQxMjA2MjMvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi05
OjIwMTQwMzIyMDQzMjIxOmkzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzc6My4xNC4wLXJj
Ny0wMDU2Mi1nZWIxNmI1ZToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIz
Ny9lYjE2YjVlYTI3M2JkN2IwMGY1MTJkN2VjM2FkNjA3MGRkMTIwNjIzL2RtZXNnLXlvY3Rv
LWl2eXRvd24yLTgwOjIwMTQwMzIyMDQzMjIxOmkzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEy
Mzc6My4xNC4wLXJjNy0wMDU2Mi1nZWIxNmI1ZToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWJhMS0wMzIxMTIzNy9lYjE2YjVlYTI3M2JkN2IwMGY1MTJkN2VjM2FkNjA3MGRkMTIwNjIz
L2RtZXNnLXF1YW50YWwtaXZ5dG93bjItMTE6MjAxNDAzMjIwNDMyMjY6aTM4Ni1yYW5kY29u
ZmlnLWJhMS0wMzIxMTIzNzozLjE0LjAtcmM3LTAwNTYyLWdlYjE2YjVlOjEKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3L2ViMTZiNWVhMjczYmQ3YjAwZjUxMmQ3ZWMz
YWQ2MDcwZGQxMjA2MjMvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0xMzoyMDE0MDMyMjA0MzIy
MzppMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3OjMuMTQuMC1yYzctMDA1NjItZ2ViMTZi
NWU6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvZWIxNmI1ZWEyNzNi
ZDdiMDBmNTEyZDdlYzNhZDYwNzBkZDEyMDYyMy9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTM3
OjIwMTQwMzIyMDQzMjIzOmkzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzc6My4xNC4wLXJj
Ny0wMDU2Mi1nZWIxNmI1ZToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIz
Ny9lYjE2YjVlYTI3M2JkN2IwMGY1MTJkN2VjM2FkNjA3MGRkMTIwNjIzL2RtZXNnLXF1YW50
YWwtaXZ5dG93bjItNTg6MjAxNDAzMjIwNDMyMjQ6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIx
MTIzNzozLjE0LjAtcmM3LTAwNTYyLWdlYjE2YjVlOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctYmExLTAzMjExMjM3L2ViMTZiNWVhMjczYmQ3YjAwZjUxMmQ3ZWMzYWQ2MDcwZGQxMjA2
MjMvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi03NjoyMDE0MDMyMjA0MzIyNjppMzg2LXJhbmRj
b25maWctYmExLTAzMjExMjM3OjMuMTQuMC1yYzctMDA1NjItZ2ViMTZiNWU6MQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvZWIxNmI1ZWEyNzNiZDdiMDBmNTEyZDdl
YzNhZDYwNzBkZDEyMDYyMy9kbWVzZy1xdWFudGFsLXNuYi00OjIwMTQwMzIyMDQzMjI1Omkz
ODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzc6OgowOjIxOjIxIGFsbF9nb29kOmJhZDphbGxf
YmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0
aGlzIChyb3VnaGx5IDAgc3RlcHMpCls0ZTQwMTEyYzRmZjZhNTc3ZGQwNmQ5MmIyYTU0Y2Rm
MDYyNjViZjc0XSB4ODYsIHZkc28zMjogaGFuZGxlIDMyIGJpdCB2RFNPIGxhcmdlciBvbmUg
cGFnZQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2ggL2hvbWUvd2ZnL3NvdW5kL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4t
cXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvbmV4dDptYXN0ZXI6NGU0
MDExMmM0ZmY2YTU3N2RkMDZkOTJiMmE1NGNkZjA2MjY1YmY3NDpiaXNlY3Qtc291bmQKCjIw
MTQtMDMtMjItMDQ6MzI6NTYgNGU0MDExMmM0ZmY2YTU3N2RkMDZkOTJiMmE1NGNkZjA2MjY1
YmY3NCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWls
ZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LTRlNDAxMTJjNGZmNmE1Nzdk
ZDA2ZDkyYjJhNTRjZGYwNjI2NWJmNzQKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvNGU0MDExMmM0ZmY2YTU3N2RkMDZkOTJiMmE1
NGNkZjA2MjY1YmY3NAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMv
YnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy00ZTQwMTEyYzRmZjZh
NTc3ZGQwNmQ5MmIyYTU0Y2RmMDYyNjViZjc0CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2Yg
L2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIz
Ny00ZTQwMTEyYzRmZjZhNTc3ZGQwNmQ5MmIyYTU0Y2RmMDYyNjViZjc0Cmtlcm5lbDogL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LzRlNDAxMTJjNGZmNmE1NzdkZDA2
ZDkyYjJhNTRjZGYwNjI2NWJmNzQvdm1saW51ei0zLjE0LjAtcmM2LTAwMDE2LWc0ZTQwMTEy
CgoyMDE0LTAzLTIyLTA1OjQ0OjU2IGRldGVjdGluZyBib290IHN0YXRlIC4gVEVTVCBGQUlM
VVJFClsgICAgNi43NDk3MTJdIHBhZ2U6ODY3MGI1MjggY291bnQ6MCBtYXBjb3VudDoxIG1h
cHBpbmc6ICAobnVsbCkgaW5kZXg6MHgwClsgICAgNi43NTMwNThdIHBhZ2UgZmxhZ3M6IDB4
NDAwMDgwMDQocmVmZXJlbmNlZHx0YWlsKQpbICAgIDYuNzU1NzM2XSAtLS0tLS0tLS0tLS1b
IGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICA2Ljc1NzQ3M10ga2VybmVsIEJVRyBhdCBt
bS9zd2FwLmM6MTM0IQpbICAgIDYuNzYwNDExXSBpbnZhbGlkIG9wY29kZTogMDAwMCBbIzFd
IFBSRUVNUFQgREVCVUdfUEFHRUFMTE9DClsgICAgNi43NjI4NTJdIE1vZHVsZXMgbGlua2Vk
IGluOgpbICAgIDYuNzYyODUyXSBDUFU6IDAgUElEOiA2OCBDb21tOiBpbml0IE5vdCB0YWlu
dGVkIDMuMTQuMC1yYzYtMDAwMTYtZzRlNDAxMTIgIzEKWyAgICA2Ljc2Mjg1Ml0gSGFyZHdh
cmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDYuNzYy
ODUyXSB0YXNrOiA3ZWYzMjQ2MCB0aTogN2ViYTYwMDAgdGFzay50aTogN2ViYTYwMDAKWyAg
ICA2Ljc2Mjg1Ml0gRUlQOiAwMDYwOls8NzkwNzk2ZTM+XSBFRkxBR1M6IDAwMDEwMjQ2IENQ
VTogMApbICAgIDYuNzYyODUyXSBFSVAgaXMgYXQgcHV0X2NvbXBvdW5kX3BhZ2UrMHg3ZC8w
eDFkYQpbICAgIDYuNzYyODUyXSBFQVg6IDc5NTA5MmJlIEVCWDogODY3MGI1MDAgRUNYOiA3
OTA0YTcyYyBFRFg6IDAwMDAwMDAxClsgICAgNi43NjI4NTJdIEVTSTogODY3MGI1MjggRURJ
OiBmZmZmZmZmZiBFQlA6IDdlYmE3ZDQwIEVTUDogN2ViYTdkMzQKWyAgICA2Ljc2Mjg1Ml0g
IERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMDAwIEdTOiAwMDAwIFNTOiAwMDY4ClsgICAgNi43
NjI4NTJdIENSMDogODAwNTAwM2IgQ1IyOiA2ZjU5YjQ2MCBDUjM6IDA2YmE1MDAwIENSNDog
MDAwMDA2ZDAKWyAgICA2Ljc2Mjg1Ml0gU3RhY2s6ClsgICAgNi43NjI4NTJdICA4NjcwYjUy
OCAwMDAwMDAwMCBmZmZmZmZmZiA3ZWJhN2Q3OCA3OTA3OThlMyAwMDAwMDAwMSA3ZWJhN2Q2
NCAwMDAwMDAwMApbICAgIDYuNzYyODUyXSAgMDAwMDAwNTUgN2ViYjkwMGMgMDAwMDAyNDYg
MDAwMDAwMjEgODY3NjZmMDQgODY3Njc1YmMgN2ViYjkwMDAgN2ViYTdkYjAKWyAgICA2Ljc2
Mjg1Ml0gIDdlYmE3ZGM0IDdlYmE3ZDhjIDc5MDg0ZmEzIDdlYmE3ZGIwIDc4MDRlMjgwIDAw
MDAwMDAwIDdlYmE3ZDljIDc5MDg0ZmM0ClsgICAgNi43NjI4NTJdIENhbGwgVHJhY2U6Clsg
ICAgNi43NjI4NTJdICBbPDc5MDc5OGUzPl0gcmVsZWFzZV9wYWdlcysweDU4LzB4MTc1Clsg
ICAgNi43NjI4NTJdICBbPDc5MDg0ZmEzPl0gdGxiX2ZsdXNoX21tdSsweDMwLzB4NDUKWyAg
ICA2Ljc2Mjg1Ml0gIFs8NzkwODRmYzQ+XSB0bGJfZmluaXNoX21tdSsweGMvMHgyYgpbICAg
IDYuNzYyODUyXSAgWzw3OTA4YThlMT5dIGV4aXRfbW1hcCsweDg0LzB4Y2IKWyAgICA2Ljc2
Mjg1Ml0gIFs8NzkwMjRmNmE+XSBtbXB1dCsweDJjLzB4YjEKWyAgICA2Ljc2Mjg1Ml0gIFs8
NzkwYTA2Y2Q+XSBmbHVzaF9vbGRfZXhlYysweDQ5MS8weDU0NQpbICAgIDYuNzYyODUyXSAg
Wzw3OTBjMDk5YT5dIGxvYWRfZWxmX2JpbmFyeSsweDI3Mi8weGI5NgpbICAgIDYuNzYyODUy
XSAgWzw3OTA5ZmM5OT5dIHNlYXJjaF9iaW5hcnlfaGFuZGxlcisweDVmLzB4MTQ1ClsgICAg
Ni43NjI4NTJdICBbPDc5MGMwNTcwPl0gbG9hZF9zY3JpcHQrMHgxN2EvMHgxODMKWyAgICA2
Ljc2Mjg1Ml0gIFs8NzkwNDBlNDk+XSA/IHNjaGVkX2Nsb2NrX2NwdSsweGJlLzB4ZTcKWyAg
ICA2Ljc2Mjg1Ml0gIFs8NzkwNDcxODg+XSA/IGxvY2tfcmVsZWFzZSsweDEzYy8weDE5YQpb
ICAgIDYuNzYyODUyXSAgWzw3OTMwYTNkND5dID8gX3Jhd19yZWFkX3VubG9jaysweDI3LzB4
MzgKWyAgICA2Ljc2Mjg1Ml0gIFs8NzkwOWZjOTk+XSBzZWFyY2hfYmluYXJ5X2hhbmRsZXIr
MHg1Zi8weDE0NQpbICAgIDYuNzYyODUyXSAgWzw3OTBhMGQzZT5dIGRvX2V4ZWN2ZSsweDM3
MS8weDQ3YwpbICAgIDYuNzYyODUyXSAgWzw3OTBhMGY5ZD5dIFN5U19leGVjdmUrMHgxYy8w
eDIwClsgICAgNi43NjI4NTJdICBbPDc5MzBlMzA0Pl0gc3lzZW50ZXJfZG9fY2FsbCsweDEy
LzB4MzcKWyAgICA2Ljc2Mjg1Ml0gQ29kZTogMGYgODQgYTMgMDAgMDAgMDAgODkgZDggZTgg
ODEgZmMgZmYgZmYgODUgYzAgNzUgMGIgMzEgZDIgODkgZDggZTggMGEgYzYgZmYgZmYgMGYg
MGIgOGIgNDYgMGMgNDAgNzQgMGIgMzEgZDIgODkgZjAgZTggZjkgYzUgZmYgZmYgPDBmPiAw
YiA4OSBkOCBlOCBkMCBmYyBmZiBmZiA4NSBjMCAwZiA4NCA0NyAwMSAwMCAwMCA4YiAwMyBh
OCA4MApbICAgIDYuNzYyODUyXSBFSVA6IFs8NzkwNzk2ZTM+XSBwdXRfY29tcG91bmRfcGFn
ZSsweDdkLzB4MWRhIFNTOkVTUCAwMDY4OjdlYmE3ZDM0ClsgICAgNi44NTc2MjRdIC0tLVsg
ZW5kIHRyYWNlIDA3NGI5MWVjNDVlZTgxM2EgXS0tLQpbICAgIDYuODY0NjcxXSBwYWdlOjg2
NzBiNTI4IGNvdW50OjAgbWFwY291bnQ6MSBtYXBwaW5nOiAgKG51bGwpIGluZGV4OjB4MAov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvNGU0MDExMmM0ZmY2YTU3N2Rk
MDZkOTJiMmE1NGNkZjA2MjY1YmY3NC9kbWVzZy15b2N0by1pdnl0b3duMi0yOToyMDE0MDMy
MjA1NDQ1NTppMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3OjMuMTQuMC1yYzYtMDAwMTYt
ZzRlNDAxMTI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvNGU0MDEx
MmM0ZmY2YTU3N2RkMDZkOTJiMmE1NGNkZjA2MjY1YmY3NC9kbWVzZy15b2N0by1pdnl0b3du
Mi0zNjoyMDE0MDMyMjA1NDQ1MzppMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3OjMuMTQu
MC1yYzYtMDAwMTYtZzRlNDAxMTI6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMy
MTEyMzcvNGU0MDExMmM0ZmY2YTU3N2RkMDZkOTJiMmE1NGNkZjA2MjY1YmY3NC9kbWVzZy15
b2N0by14aWFuLTg6MjAxNDAzMjIwNTQ0NTQ6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIz
NzozLjE0LjAtcmM2LTAwMDE2LWc0ZTQwMTEyOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
YmExLTAzMjExMjM3LzRlNDAxMTJjNGZmNmE1NzdkZDA2ZDkyYjJhNTRjZGYwNjI2NWJmNzQv
ZG1lc2ctcXVhbnRhbC1qYWtldG93bi0yMDoyMDE0MDMyMjA1NDUwMzppMzg2LXJhbmRjb25m
aWctYmExLTAzMjExMjM3OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3
LzRlNDAxMTJjNGZmNmE1NzdkZDA2ZDkyYjJhNTRjZGYwNjI2NWJmNzQvZG1lc2cteW9jdG8t
aXZ5dG93bjItMzM6MjAxNDAzMjIwNTQ1MTI6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIz
NzozLjE0LjAtcmM2LTAwMDE2LWc0ZTQwMTEyOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
YmExLTAzMjExMjM3LzRlNDAxMTJjNGZmNmE1NzdkZDA2ZDkyYjJhNTRjZGYwNjI2NWJmNzQv
ZG1lc2cteW9jdG8taXZ5dG93bjItMzY6MjAxNDAzMjIwNTQ1MDk6aTM4Ni1yYW5kY29uZmln
LWJhMS0wMzIxMTIzNzozLjE0LjAtcmM2LTAwMDE2LWc0ZTQwMTEyOjEKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYmExLTAzMjExMjM3LzRlNDAxMTJjNGZmNmE1NzdkZDA2ZDkyYjJhNTRj
ZGYwNjI2NWJmNzQvZG1lc2cteW9jdG8taXZ5dG93bjItNjQ6MjAxNDAzMjIwNTQ1MTI6aTM4
Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNzozLjE0LjAtcmM2LTAwMDE2LWc0ZTQwMTEyOjEK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LzRlNDAxMTJjNGZmNmE1Nzdk
ZDA2ZDkyYjJhNTRjZGYwNjI2NWJmNzQvZG1lc2cteW9jdG8taXZ5dG93bjItNzE6MjAxNDAz
MjIwNTQ1MTA6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNzozLjE0LjAtcmM2LTAwMDE2
LWc0ZTQwMTEyOjEKMDo4OjQgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCjRlNDAxMTJj
NGZmNmE1NzdkZDA2ZDkyYjJhNTRjZGYwNjI2NWJmNzQgaXMgdGhlIGZpcnN0IGJhZCBjb21t
aXQKY29tbWl0IDRlNDAxMTJjNGZmNmE1NzdkZDA2ZDkyYjJhNTRjZGYwNjI2NWJmNzQKQXV0
aG9yOiBTdGVmYW5pIFNlaWJvbGQgPHN0ZWZhbmlAc2VpYm9sZC5uZXQ+CkRhdGU6ICAgTW9u
IE1hciAxNyAyMzoyMjoxMyAyMDE0ICswMTAwCgogICAgeDg2LCB2ZHNvMzI6IGhhbmRsZSAz
MiBiaXQgdkRTTyBsYXJnZXIgb25lIHBhZ2UKICAgIAogICAgVGhpcyBwYXRjaCBlbmFibGVz
IDMyIGJpdCB2RFNPIHdoaWNoIGFyZSBsYXJnZXIgdGhhbiBhIHBhZ2UuCiAgICAKICAgIFNp
Z25lZC1vZmYtYnk6IFN0ZWZhbmkgU2VpYm9sZCA8c3RlZmFuaUBzZWlib2xkLm5ldD4KICAg
IExpbms6IGh0dHA6Ly9sa21sLmtlcm5lbC5vcmcvci8xMzk1MDk0OTMzLTE0MjUyLTE0LWdp
dC1zZW5kLWVtYWlsLXN0ZWZhbmlAc2VpYm9sZC5uZXQKICAgIFNpZ25lZC1vZmYtYnk6IEgu
IFBldGVyIEFudmluIDxocGFAbGludXguaW50ZWwuY29tPgoKOjA0MDAwMCAwNDAwMDAgMjE1
YTQzYmY5N2I2NzdlMzE5MDU0NWM4OGYxNGM2YmZkNGI0NjgxMiAxZTg0OTQ1Y2NjNGY4Y2Zk
ZmM1YjBhODNkOGZhMmExNjFlODIxMDQ4IE0JYXJjaApiaXNlY3QgcnVuIHN1Y2Nlc3MKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMy
MTEyMzcvbmV4dDptYXN0ZXI6MDA4Y2M5MDdkZTMyN2Q4M2EwYmU2MDljZDQ5NWZjY2IwZTVk
ZmE0YzpiaXNlY3Qtc291bmQKCjIwMTQtMDMtMjItMDU6NDU6MzMgMDA4Y2M5MDdkZTMyN2Q4
M2EwYmU2MDljZDQ5NWZjY2IwZTVkZmE0YyByZXVzZSAva2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1iYTEtMDMyMTEyMzcvMDA4Y2M5MDdkZTMyN2Q4M2EwYmU2MDljZDQ5NWZjY2IwZTVkZmE0
Yy92bWxpbnV6LTMuMTQuMC1yYzYtMDAwMTUtZzAwOGNjOTAKCjIwMTQtMDMtMjItMDU6NDU6
MzMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMjMJMzgJNTEJNjAJNjMgU1VDQ0VTUwoKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMy
MTEyMzcvbmV4dDptYXN0ZXI6YTY1NGRjNzk3ZjNlYTFjYjU3MTlhNzFhMTdhZjM1ZjU3ZmRk
YjJkODpiaXNlY3Qtc291bmQKIFRFU1QgRkFJTFVSRQpbICAgIDMuMzMzMzIzXSBwYWdlOjg2
NzBiM2U4IGNvdW50OjAgbWFwY291bnQ6MSBtYXBwaW5nOiAgKG51bGwpIGluZGV4OjB4MApb
ICAgIDMuMzMzOTcxXSBwYWdlIGZsYWdzOiAweDQwMDA4MDA0KHJlZmVyZW5jZWR8dGFpbCkK
WyAgICAzLjMzNDQ4N10gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsg
ICAgMy4zMzQ5MDFdIGtlcm5lbCBCVUcgYXQgbW0vc3dhcC5jOjEzNCEKWyAgICAzLjMzNTQ2
NF0gaW52YWxpZCBvcGNvZGU6IDAwMDAgWyMxXSBQUkVFTVBUIERFQlVHX1BBR0VBTExPQwpb
ICAgIDMuMzM2MDI1XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAzLjMzNjMxN10gQ1BVOiAw
IFBJRDogNjggQ29tbTogaW5pdCBOb3QgdGFpbnRlZCAzLjE0LjAtcmM3LW5leHQtMjAxNDAz
MjAtMTA3NTMtZ2E2NTRkYzcgIzEKWyAgICAzLjMzNzA3N10gSGFyZHdhcmUgbmFtZTogQm9j
aHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDMuMzM3NjE5XSB0YXNrOiA4
NDBmZWU0MCB0aTogN2ViY2MwMDAgdGFzay50aTogN2ViY2MwMDAKWyAgICAzLjMzODA5Nl0g
RUlQOiAwMDYwOls8NzkwN2FlMzY+XSBFRkxBR1M6IDAwMDEwMjQ2IENQVTogMApbICAgIDMu
MzM4NjAxXSBFSVAgaXMgYXQgcHV0X2NvbXBvdW5kX3BhZ2UrMHg3ZC8weDFkYQpbICAgIDMu
MzM5MDI2XSBFQVg6IDc5NTE0M2RmIEVCWDogODY3MGIzYzAgRUNYOiA3OTA0Yjg4NCBFRFg6
IDAwMDAwMDAxClsgICAgMy4zMzk1OTddIEVTSTogODY3MGIzZTggRURJOiBmZmZmZmZmZiBF
QlA6IDdlYmNkZDQwIEVTUDogN2ViY2RkMzQKWyAgICAzLjM0MDE1N10gIERTOiAwMDdiIEVT
OiAwMDdiIEZTOiAwMDAwIEdTOiAwMDAwIFNTOiAwMDY4ClsgICAgMy4zNDA2NDRdIENSMDog
ODAwNTAwM2IgQ1IyOiA2ZjU1NDQ2MCBDUjM6IDA2YmNiMDAwIENSNDogMDAwMDA2ZDAKWyAg
ICAzLjM0MDY0NF0gU3RhY2s6ClsgICAgMy4zNDA2NDRdICA4NjcwYjNlOCAwMDAwMDAwMCBm
ZmZmZmZmZiA3ZWJjZGQ3OCA3OTA3YjAzNiAwMDAwMDAwMSA3ZWJjZGQ2NCAwMDAwMDAwMApb
ICAgIDMuMzQwNjQ0XSAgMDAwMDAwZjIgN2ViY2YwMGMgMDAwMDAyNDYgMDAwMDAwOWMgODY3
NjcxZmMgODY3Njc1OTQgN2ViY2YwMDAgN2ViY2RkYjAKWyAgICAzLjM0MDY0NF0gIDdlYmNk
ZGM0IDdlYmNkZDhjIDc5MDg2Y2I3IDdlYmNkZGIwIDdlYmJlMjgwIDAwMDAwMDAwIDdlYmNk
ZDljIDc5MDg2Y2Q4ClsgICAgMy4zNDA2NDRdIENhbGwgVHJhY2U6ClsgICAgMy4zNDA2NDRd
ICBbPDc5MDdiMDM2Pl0gcmVsZWFzZV9wYWdlcysweDU4LzB4MTc1ClsgICAgMy4zNDA2NDRd
ICBbPDc5MDg2Y2I3Pl0gdGxiX2ZsdXNoX21tdSsweDMwLzB4NDUKWyAgICAzLjM0MDY0NF0g
IFs8NzkwODZjZDg+XSB0bGJfZmluaXNoX21tdSsweGMvMHgyYgpbICAgIDMuMzQwNjQ0XSAg
Wzw3OTA4Y2FiMT5dIGV4aXRfbW1hcCsweDg0LzB4Y2IKWyAgICAzLjM0MDY0NF0gIFs8Nzkw
MjVhMzE+XSBtbXB1dCsweDJjLzB4YjEKWyAgICAzLjM0MDY0NF0gIFs8NzkwYTJjNzk+XSBm
bHVzaF9vbGRfZXhlYysweDRhZi8weDU2NApbICAgIDMuMzQwNjQ0XSAgWzw3OTBjMzAzMD5d
IGxvYWRfZWxmX2JpbmFyeSsweDI3Mi8weGI4NgpbICAgIDMuMzQwNjQ0XSAgWzw3OTBhMjIy
MD5dIHNlYXJjaF9iaW5hcnlfaGFuZGxlcisweDVmLzB4MTQ1ClsgICAgMy4zNDA2NDRdICBb
PDc5MGMyYzA2Pl0gbG9hZF9zY3JpcHQrMHgxN2EvMHgxODMKWyAgICAzLjM0MDY0NF0gIFs8
NzkwNDFjMzU+XSA/IHNjaGVkX2Nsb2NrX2NwdSsweGFhLzB4ZDMKWyAgICAzLjM0MDY0NF0g
IFs8NzkwNDgyYmQ+XSA/IGxvY2tfcmVsZWFzZSsweDEzYy8weDE5YQpbICAgIDMuMzQwNjQ0
XSAgWzw3OTMxMTQ0ND5dID8gX3Jhd19yZWFkX3VubG9jaysweDI3LzB4MzgKWyAgICAzLjM0
MDY0NF0gIFs8NzkwYTIyMjA+XSBzZWFyY2hfYmluYXJ5X2hhbmRsZXIrMHg1Zi8weDE0NQpb
ICAgIDMuMzQwNjQ0XSAgWzw3OTBhMzJlYj5dIGRvX2V4ZWN2ZSsweDM3MS8weDQ3YwpbICAg
IDMuMzQwNjQ0XSAgWzw3OTBhMzU0YT5dIFN5U19leGVjdmUrMHgxYy8weDIwClsgICAgMy4z
NDA2NDRdICBbPDc5MzE1NGQ1Pl0gc3lzZW50ZXJfZG9fY2FsbCsweDEyLzB4MzcKWyAgICAz
LjM0MDY0NF0gQ29kZTogMGYgODQgYTMgMDAgMDAgMDAgODkgZDggZTggNzMgZmMgZmYgZmYg
ODUgYzAgNzUgMGIgMzEgZDIgODkgZDggZTggZjUgYzUgZmYgZmYgMGYgMGIgOGIgNDYgMGMg
NDAgNzQgMGIgMzEgZDIgODkgZjAgZTggZTQgYzUgZmYgZmYgPDBmPiAwYiA4OSBkOCBlOCBl
NSBmYyBmZiBmZiA4NSBjMCAwZiA4NCA0NyAwMSAwMCAwMCA4YiAwMyBhOCA4MApbICAgIDMu
MzQwNjQ0XSBFSVA6IFs8NzkwN2FlMzY+XSBwdXRfY29tcG91bmRfcGFnZSsweDdkLzB4MWRh
IFNTOkVTUCAwMDY4OjdlYmNkZDM0ClsgICAgMy4zNTQ2MDJdIC0tLVsgZW5kIHRyYWNlIDA3
MzkwZTRmNjJjZTk5MGIgXS0tLQpbICAgIDMuNTQwMTU2XSB0c2M6IFJlZmluZWQgVFNDIGNs
b2Nrc291cmNlIGNhbGlicmF0aW9uOiAyODkyLjk0OSBNSHoKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYmExLTAzMjExMjM3L2E2NTRkYzc5N2YzZWExY2I1NzE5YTcxYTE3YWYzNWY1N2Zk
ZGIyZDgvZG1lc2ctcXVhbnRhbC1qYWtldG93bi0xMzoyMDE0MDMyMTEyNTkzMjppMzg2LXJh
bmRjb25maWctYmExLTAzMjExMjM3OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAz
MjExMjM3L2E2NTRkYzc5N2YzZWExY2I1NzE5YTcxYTE3YWYzNWY1N2ZkZGIyZDgvZG1lc2ct
cXVhbnRhbC1hdGhlbnMtMzc6MjAxNDAzMjExMzQzMzU6aTM4Ni1yYW5kY29uZmlnLWJhMS0w
MzIxMTIzNzozLjE0LjAtcmM3LW5leHQtMjAxNDAzMjAtMTA3NTMtZ2E2NTRkYzc6MQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvYTY1NGRjNzk3ZjNlYTFjYjU3MTlh
NzFhMTdhZjM1ZjU3ZmRkYjJkOC9kbWVzZy15b2N0by1hdGhlbnMtNDI6MjAxNDAzMjExMjU5
MDY6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNzozLjE0LjAtcmM3LW5leHQtMjAxNDAz
MjAtMTA3NTMtZ2E2NTRkYzc6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEy
MzcvYTY1NGRjNzk3ZjNlYTFjYjU3MTlhNzFhMTdhZjM1ZjU3ZmRkYjJkOC9kbWVzZy1xdWFu
dGFsLWl2eXRvd24yLTM6MjAxNDAzMjExMjU5Mjk6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIx
MTIzNzozLjE0LjAtcmM3LW5leHQtMjAxNDAzMjAtMTA3NTMtZ2E2NTRkYzc6MQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvYTY1NGRjNzk3ZjNlYTFjYjU3MTlhNzFh
MTdhZjM1ZjU3ZmRkYjJkOC9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTU6MjAxNDAzMjExMzQ0
MDE6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNzozLjE0LjAtcmM3LW5leHQtMjAxNDAz
MjAtMTA3NTMtZ2E2NTRkYzc6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEy
MzcvYTY1NGRjNzk3ZjNlYTFjYjU3MTlhNzFhMTdhZjM1ZjU3ZmRkYjJkOC9kbWVzZy1xdWFu
dGFsLXJvYW0tODoyMDE0MDMyMTEzNDUzMzppMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3
OjMuMTQuMC1yYzctbmV4dC0yMDE0MDMyMC0xMDc1My1nYTY1NGRjNzoxCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy9hNjU0ZGM3OTdmM2VhMWNiNTcxOWE3MWExN2Fm
MzVmNTdmZGRiMmQ4L2RtZXNnLXlvY3RvLXNuYi0zMjoyMDE0MDMyMTEzNDgyMzppMzg2LXJh
bmRjb25maWctYmExLTAzMjExMjM3OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAz
MjExMjM3L2E2NTRkYzc5N2YzZWExY2I1NzE5YTcxYTE3YWYzNWY1N2ZkZGIyZDgvZG1lc2ct
cXVhbnRhbC1yb2FtLTM6MjAxNDAzMjExMjU5MDE6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIx
MTIzNzozLjE0LjAtcmM3LW5leHQtMjAxNDAzMjAtMTA3NTMtZ2E2NTRkYzc6MQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvYTY1NGRjNzk3ZjNlYTFjYjU3MTlhNzFh
MTdhZjM1ZjU3ZmRkYjJkOC9kbWVzZy15b2N0by1pdnl0b3duMi0yMjoyMDE0MDMyMTEyNTkx
OTppMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3OjMuMTQuMC1yYzctbmV4dC0yMDE0MDMy
MC0xMDc1My1nYTY1NGRjNzoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIz
Ny9hNjU0ZGM3OTdmM2VhMWNiNTcxOWE3MWExN2FmMzVmNTdmZGRiMmQ4L2RtZXNnLXlvY3Rv
LXJvYW0tNDY6MjAxNDAzMjExMzQ4MjI6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNzoz
LjE0LjAtcmM3LW5leHQtMjAxNDAzMjAtMTA3NTMtZ2E2NTRkYzc6MQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvYTY1NGRjNzk3ZjNlYTFjYjU3MTlhNzFhMTdhZjM1
ZjU3ZmRkYjJkOC9kbWVzZy1xdWFudGFsLXJvYW0tMzg6MjAxNDAzMjExMjU5MzQ6aTM4Ni1y
YW5kY29uZmlnLWJhMS0wMzIxMTIzNzozLjE0LjAtcmM3LW5leHQtMjAxNDAzMjAtMTA3NTMt
Z2E2NTRkYzc6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvYTY1NGRj
Nzk3ZjNlYTFjYjU3MTlhNzFhMTdhZjM1ZjU3ZmRkYjJkOC9kbWVzZy15b2N0by14cHMtMjoy
MDE0MDMyMTEzNDUzMjppMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3OjMuMTQuMC1yYzct
bmV4dC0yMDE0MDMyMC0xMDc1My1nYTY1NGRjNzoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWJhMS0wMzIxMTIzNy9hNjU0ZGM3OTdmM2VhMWNiNTcxOWE3MWExN2FmMzVmNTdmZGRiMmQ4
L2RtZXNnLXF1YW50YWwtaXZ5dG93bjItMjoyMDE0MDMyMTEyNTkyNzppMzg2LXJhbmRjb25m
aWctYmExLTAzMjExMjM3OjMuMTQuMC1yYzctbmV4dC0yMDE0MDMyMC0xMDc1My1nYTY1NGRj
NzoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy9hNjU0ZGM3OTdmM2Vh
MWNiNTcxOWE3MWExN2FmMzVmNTdmZGRiMmQ4L2RtZXNnLXlvY3RvLWl2eXRvd24yLTU6MjAx
NDAzMjExMzQ4MTY6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNzozLjE0LjAtcmM3LW5l
eHQtMjAxNDAzMjAtMTA3NTMtZ2E2NTRkYzc6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1i
YTEtMDMyMTEyMzcvYTY1NGRjNzk3ZjNlYTFjYjU3MTlhNzFhMTdhZjM1ZjU3ZmRkYjJkOC9k
bWVzZy1xdWFudGFsLWl2eXRvd24yLTIwOjIwMTQwMzIxMTM0NDE3OmkzODYtcmFuZGNvbmZp
Zy1iYTEtMDMyMTEyMzc6My4xNC4wLXJjNy1uZXh0LTIwMTQwMzIwLTEwNzUzLWdhNjU0ZGM3
OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3L2E2NTRkYzc5N2YzZWEx
Y2I1NzE5YTcxYTE3YWYzNWY1N2ZkZGIyZDgvZG1lc2cteW9jdG8tamFrZXRvd24tMTU6MjAx
NDAzMjExMjU5Mjk6aTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNzo6Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy9hNjU0ZGM3OTdmM2VhMWNiNTcxOWE3MWExN2Fm
MzVmNTdmZGRiMmQ4L2RtZXNnLXlvY3RvLWpha2V0b3duLTIxOjIwMTQwMzIxMTI1OTIxOmkz
ODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzc6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1i
YTEtMDMyMTEyMzcvYTY1NGRjNzk3ZjNlYTFjYjU3MTlhNzFhMTdhZjM1ZjU3ZmRkYjJkOC9k
bWVzZy1xdWFudGFsLWl2eXRvd24yLTIxOjIwMTQwMzIxMTM0NTM0OmkzODYtcmFuZGNvbmZp
Zy1iYTEtMDMyMTEyMzc6My4xNC4wLXJjNy1uZXh0LTIwMTQwMzIwLTEwNzUzLWdhNjU0ZGM3
OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3L2E2NTRkYzc5N2YzZWEx
Y2I1NzE5YTcxYTE3YWYzNWY1N2ZkZGIyZDgvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi02OjIw
MTQwMzIxMTM0OTAzOmkzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzc6My4xNC4wLXJjNy1u
ZXh0LTIwMTQwMzIwLTEwNzUzLWdhNjU0ZGM3OjEKMDoxOToxOSBhbGxfZ29vZDpiYWQ6YWxs
X2JhZCBib290cwoKW2RldGFjaGVkIEhFQUQgNzNlOTFkMl0gUmV2ZXJ0ICJ4ODYsIHZkc28z
MjogaGFuZGxlIDMyIGJpdCB2RFNPIGxhcmdlciBvbmUgcGFnZSIKIDEgZmlsZSBjaGFuZ2Vk
LCA3IGluc2VydGlvbnMoKyksIDE1IGRlbGV0aW9ucygtKQpscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy9uZXh0Om1hc3Rl
cjo3M2U5MWQyNzZiNGE3NTA5MjYxOGZhMjFkMTMzZWMyNDA2OGZlYmQ4OmJpc2VjdC1zb3Vu
ZAoKMjAxNC0wMy0yMi0wNTo0OToxMiA3M2U5MWQyNzZiNGE3NTA5MjYxOGZhMjFkMTMzZWMy
NDA2OGZlYmQ4IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3Rz
L2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzctNzNlOTFkMjc2YjRh
NzUwOTI2MThmYTIxZDEzM2VjMjQwNjhmZWJkOApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy83M2U5MWQyNzZiNGE3NTA5MjYxOGZh
MjFkMTMzZWMyNDA2OGZlYmQ4CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10
ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LTczZTkxZDI3
NmI0YTc1MDkyNjE4ZmEyMWQxMzNlYzI0MDY4ZmViZDgKc3RhdHVzOiBGQUlMOiBubyBjb21t
aXQgNzNlOTFkMjc2YjRhNzUwOTI2MThmYTIxZDEzM2VjMjQwNjhmZWJkOCBmb3IgYnVpbGQg
dGFzayBpMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LTczZTkxZDI3NmI0YTc1MDkyNjE4
ZmEyMWQxMzNlYzI0MDY4ZmViZDgKMjAxNC0wMy0yMi0wNjowNzoxMiA3M2U5MWQyNzZiNGE3
NTA5MjYxOGZhMjFkMTMzZWMyNDA2OGZlYmQ4IFNLSVAgQlJPS0VOIEJVSUxECk5vIGtlcm5l
bCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvNzNlOTFkMjc2YjRh
NzUwOTI2MThmYTIxZDEzM2VjMjQwNjhmZWJkOAoKPT09PT09PT09IHVwc3RyZWFtID09PT09
PT09PQpGZXRjaGluZyBsaW51cwpGcm9tIGdpdDovL2dpdG1pcnJvci9saW51cwogICAzZmI3
MjVjLi4wOGVkYjMzICBtYXN0ZXIgICAgIC0+IGxpbnVzL21hc3RlcgpXYXJuaW5nOiB5b3Ug
YXJlIGxlYXZpbmcgMSBjb21taXQgYmVoaW5kLCBub3QgY29ubmVjdGVkIHRvCmFueSBvZiB5
b3VyIGJyYW5jaGVzOgoKICA3M2U5MWQyIFJldmVydCAieDg2LCB2ZHNvMzI6IGhhbmRsZSAz
MiBiaXQgdkRTTyBsYXJnZXIgb25lIHBhZ2UiCgpJZiB5b3Ugd2FudCB0byBrZWVwIHRoZW0g
YnkgY3JlYXRpbmcgYSBuZXcgYnJhbmNoLCB0aGlzIG1heSBiZSBhIGdvb2QgdGltZQp0byBk
byBzbyB3aXRoOgoKIGdpdCBicmFuY2ggbmV3X2JyYW5jaF9uYW1lIDczZTkxZDIKCkhFQUQg
aXMgbm93IGF0IDA4ZWRiMzMuLi4gTWVyZ2UgYnJhbmNoICdkcm0tZml4ZXMnIG9mIGdpdDov
L3Blb3BsZS5mcmVlZGVza3RvcC5vcmcvfmFpcmxpZWQvbGludXgKbHMgLWEgL2tlcm5lbC10
ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvbmV4dDpt
YXN0ZXI6MDhlZGIzM2M0ZTFiODEwMDExZjIxZDc3MDU4MTFiN2I5YTA1MzVmMDpiaXNlY3Qt
c291bmQKCjIwMTQtMDMtMjItMDY6MDc6MjQgMDhlZGIzM2M0ZTFiODEwMDExZjIxZDc3MDU4
MTFiN2I5YTA1MzVmMCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10
ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LTA4ZWRiMzNj
NGUxYjgxMDAxMWYyMWQ3NzA1ODExYjdiOWEwNTM1ZjAKQ2hlY2sgZm9yIGtlcm5lbCBpbiAv
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzcvMDhlZGIzM2M0ZTFiODEwMDEx
ZjIxZDc3MDU4MTFiN2I5YTA1MzVmMAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJu
ZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy0wOGVk
YjMzYzRlMWI4MTAwMTFmMjFkNzcwNTgxMWI3YjlhMDUzNWYwCndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWJh
MS0wMzIxMTIzNy0wOGVkYjMzYzRlMWI4MTAwMTFmMjFkNzcwNTgxMWI3YjlhMDUzNWYwCmtl
cm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LzA4ZWRiMzNjNGUx
YjgxMDAxMWYyMWQ3NzA1ODExYjdiOWEwNTM1ZjAvdm1saW51ei0zLjE0LjAtcmM3LTAwMDU5
LWcwOGVkYjMzCgoyMDE0LTAzLTIyLTA2OjI1OjI1IGRldGVjdGluZyBib290IHN0YXRlIC4J
OAk5CTEzCTI0CTMwCTQyCTU4CTYzIFNVQ0NFU1MKCgo9PT09PT09PT0gbGludXgtbmV4dCA9
PT09PT09PT0KRmV0Y2hpbmcgbmV4dApGcm9tIGdpdDovL2dpdG1pcnJvci9uZXh0CiArIDc1
Njc4MjQuLi45ZGQzNzc0IGFrcG0gICAgICAgLT4gbmV4dC9ha3BtICAoZm9yY2VkIHVwZGF0
ZSkKICsgMDE2MzE5ZC4uLjNiNTVjM2MgYWtwbS1iYXNlICAtPiBuZXh0L2FrcG0tYmFzZSAg
KGZvcmNlZCB1cGRhdGUpCiArIGE2NTRkYzc5Li4uMDZlZDI2ZCBtYXN0ZXIgICAgIC0+IG5l
eHQvbWFzdGVyICAoZm9yY2VkIHVwZGF0ZSkKICAgODg3ODQzOS4uM2ZiNzI1YyAgc3RhYmxl
ICAgICAtPiBuZXh0L3N0YWJsZQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyAwOGVkYjMz
Li4uIE1lcmdlIGJyYW5jaCAnZHJtLWZpeGVzJyBvZiBnaXQ6Ly9wZW9wbGUuZnJlZWRlc2t0
b3Aub3JnL35haXJsaWVkL2xpbnV4CkhFQUQgaXMgbm93IGF0IDA2ZWQyNmQuLi4gQWRkIGxp
bnV4LW5leHQgc3BlY2lmaWMgZmlsZXMgZm9yIDIwMTQwMzIxCmxzIC1hIC9rZXJuZWwtdGVz
dHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3L25leHQ6bWFz
dGVyOjA2ZWQyNmQxZGU1OWNlN2NiYmU2ODM3OGI3ZTQ3MGJlMTY5NzUwZTU6YmlzZWN0LXNv
dW5kCgoyMDE0LTAzLTIyLTA2OjMwOjE2IDA2ZWQyNmQxZGU1OWNlN2NiYmU2ODM3OGI3ZTQ3
MGJlMTY5NzUwZTUgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVz
dHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy0wNmVkMjZkMWRl
NTljZTdjYmJlNjgzNzhiN2U0NzBiZTE2OTc1MGU1CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYmExLTAzMjExMjM3LzA2ZWQyNmQxZGU1OWNlN2NiYmU2
ODM3OGI3ZTQ3MGJlMTY5NzUwZTUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVs
LXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMyMTEyMzctMDZlZDI2
ZDFkZTU5Y2U3Y2JiZTY4Mzc4YjdlNDcwYmUxNjk3NTBlNQp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1iYTEt
MDMyMTEyMzctMDZlZDI2ZDFkZTU5Y2U3Y2JiZTY4Mzc4YjdlNDcwYmUxNjk3NTBlNQprZXJu
ZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWJhMS0wMzIxMTIzNy8wNmVkMjZkMWRlNTlj
ZTdjYmJlNjgzNzhiN2U0NzBiZTE2OTc1MGU1L3ZtbGludXotMy4xNC4wLXJjNy1uZXh0LTIw
MTQwMzIxCgoyMDE0LTAzLTIyLTA2OjU1OjE2IGRldGVjdGluZyBib290IHN0YXRlIC4gVEVT
VCBGQUlMVVJFClsgICAgMS41NjMwMTldIHBhZ2U6OGJiNTE1MjggY291bnQ6MCBtYXBjb3Vu
dDoyIG1hcHBpbmc6ICAobnVsbCkgaW5kZXg6MHgwClsgICAgMS41NjQ5MDNdIHBhZ2UgZmxh
Z3M6IDB4NDAwMDgwMDQocmVmZXJlbmNlZHx0YWlsKQpbICAgIDEuNTY2NzA4XSAtLS0tLS0t
LS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAxLjU2NzQxOF0ga2VybmVsIEJV
RyBhdCBtbS9zd2FwLmM6MTM0IQpbICAgIDEuNTY4NTEwXSBpbnZhbGlkIG9wY29kZTogMDAw
MCBbIzFdIFBSRUVNUFQgREVCVUdfUEFHRUFMTE9DClsgICAgMS41NzAwMTldIE1vZHVsZXMg
bGlua2VkIGluOgpbICAgIDEuNTcwMDE5XSBDUFU6IDAgUElEOiA3MCBDb21tOiBtb3VudCBO
b3QgdGFpbnRlZCAzLjE0LjAtcmM3LW5leHQtMjAxNDAzMjEgIzEKWyAgICAxLjU3MDAxOV0g
SGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAg
IDEuNTcwMDE5XSB0YXNrOiA4OGFiYTRjMCB0aTogODg3OGMwMDAgdGFzay50aTogODg3OGMw
MDAKWyAgICAxLjU3MDAxOV0gRUlQOiAwMDYwOls8NzkwN2FjMzY+XSBFRkxBR1M6IDAwMDEw
MjQ2IENQVTogMApbICAgIDEuNTcwMDE5XSBFSVAgaXMgYXQgcHV0X2NvbXBvdW5kX3BhZ2Ur
MHg3ZC8weDFkYQpbICAgIDEuNTcwMDE5XSBFQVg6IDc5NTE0OTVjIEVCWDogOGJiNTE1MDAg
RUNYOiA3OTA0YjYzYyBFRFg6IDAwMDAwMDAxClsgICAgMS41NzAwMTldIEVTSTogOGJiNTE1
MjggRURJOiBmZmZmZmZmZiBFQlA6IDg4NzhkZThjIEVTUDogODg3OGRlODAKWyAgICAxLjU3
MDAxOV0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMDAwIEdTOiAwMDAwIFNTOiAwMDY4Clsg
ICAgMS41NzAwMTldIENSMDogODAwNTAwM2IgQ1IyOiA0N2ViOWRhMCBDUjM6IDEwNzkwMDAw
IENSNDogMDAwMDA2ZDAKWyAgICAxLjU3MDAxOV0gU3RhY2s6ClsgICAgMS41NzAwMTldICA4
YmI1MTUyOCAwMDAwMDAwMCBmZmZmZmZmZiA4ODc4ZGVjNCA3OTA3YWUzNiAwMDAwMDAwMSA4
ODc4ZGViMCAwMDAwMDAwMApbICAgIDEuNTcwMDE5XSAgMDAwMDAxNzEgODg3ODYwMGMgMDAw
MDAyNDYgMDAwMDAxNjkgOGJiYjViNTQgOGJiYjVjOTQgODg3ODYwMDAgODg3OGRlZmMKWyAg
ICAxLjU3MDAxOV0gIDg4NzhkZjEwIDg4NzhkZWQ4IDc5MDg2YWI3IDg4NzhkZWZjIDg4NzZj
YTAwIDAwMDAwMDAwIDg4NzhkZWU4IDc5MDg2YWQ4ClsgICAgMS41NzAwMTldIENhbGwgVHJh
Y2U6ClsgICAgMS41NzAwMTldICBbPDc5MDdhZTM2Pl0gcmVsZWFzZV9wYWdlcysweDU4LzB4
MTc1ClsgICAgMS41NzAwMTldICBbPDc5MDg2YWI3Pl0gdGxiX2ZsdXNoX21tdSsweDMwLzB4
NDUKWyAgICAxLjU3MDAxOV0gIFs8NzkwODZhZDg+XSB0bGJfZmluaXNoX21tdSsweGMvMHgy
YgpbICAgIDEuNTcwMDE5XSAgWzw3OTA4YzhiMT5dIGV4aXRfbW1hcCsweDg0LzB4Y2IKWyAg
ICAxLjU3MDAxOV0gIFs8NzkwMjU4YzU+XSBtbXB1dCsweDJjLzB4YjEKWyAgICAxLjU3MDAx
OV0gIFs8NzkwMjdmMWQ+XSBkb19leGl0KzB4MjFlLzB4NmRkClsgICAgMS41NzAwMTldICBb
PDc5MDllNWRjPl0gPyB2ZnNfd3JpdGUrMHg5OC8weGIwClsgICAgMS41NzAwMTldICBbPDc5
MDI4ZjMxPl0gZG9fZ3JvdXBfZXhpdCsweDU5LzB4ODYKWyAgICAxLjU3MDAxOV0gIFs8Nzkw
MjhmNmY+XSBTeVNfZXhpdF9ncm91cCsweDExLzB4MTEKWyAgICAxLjU3MDAxOV0gIFs8Nzkz
MTE4N2U+XSBzeXNjYWxsX2NhbGwrMHg3LzB4YgpbICAgIDEuNTcwMDE5XSBDb2RlOiAwZiA4
NCBhMyAwMCAwMCAwMCA4OSBkOCBlOCA3MyBmYyBmZiBmZiA4NSBjMCA3NSAwYiAzMSBkMiA4
OSBkOCBlOCBmNSBjNSBmZiBmZiAwZiAwYiA4YiA0NiAwYyA0MCA3NCAwYiAzMSBkMiA4OSBm
MCBlOCBlNCBjNSBmZiBmZiA8MGY+IDBiIDg5IGQ4IGU4IGU1IGZjIGZmIGZmIDg1IGMwIDBm
IDg0IDQ3IDAxIDAwIDAwIDhiIDAzIGE4IDgwClsgICAgMS41NzAwMTldIEVJUDogWzw3OTA3
YWMzNj5dIHB1dF9jb21wb3VuZF9wYWdlKzB4N2QvMHgxZGEgU1M6RVNQIDAwNjg6ODg3OGRl
ODAKWyAgICAxLjYyNjYzNl0gdHNjOiBSZWZpbmVkIFRTQyBjbG9ja3NvdXJjZSBjYWxpYnJh
dGlvbjogMjQ5My45NTkgTUh6ClsgICAgMS42Mjg4NTZdIC0tLVsgZW5kIHRyYWNlIGRmNmNm
ZDcwODRiMjhhYzYgXS0tLQpbICAgIDEuNjMwNjg0XSBGaXhpbmcgcmVjdXJzaXZlIGZhdWx0
IGJ1dCByZWJvb3QgaXMgbmVlZGVkIQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1iYTEtMDMy
MTEyMzcvMDZlZDI2ZDFkZTU5Y2U3Y2JiZTY4Mzc4YjdlNDcwYmUxNjk3NTBlNS9kbWVzZy15
b2N0by1pdnl0b3duMi0zMToyMDE0MDMyMjA2NTUzNDppMzg2LXJhbmRjb25maWctYmExLTAz
MjExMjM3OjMuMTQuMC1yYzctbmV4dC0yMDE0MDMyMToxCjA6MToxIGFsbF9nb29kOmJhZDph
bGxfYmFkIGJvb3RzCgo=

--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc7-next-20140320-10753-ga654dc7"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.14.0-rc7 Kernel Configuration
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
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
CONFIG_USELIB=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
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
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
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
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
# CONFIG_RCU_NOCB_CPU_ZERO is not set
CONFIG_RCU_NOCB_CPU_ALL=y
CONFIG_IKCONFIG=y
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
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_IPC_NS is not set
CONFIG_USER_NS=y
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
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
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
CONFIG_SYSFS_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
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
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_SLUB_DEBUG is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
# CONFIG_UPROBES is not set
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
CONFIG_GCOV_FORMAT_AUTODETECT=y
# CONFIG_GCOV_FORMAT_3_4 is not set
# CONFIG_GCOV_FORMAT_4_7 is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_MODULE_SIG is not set
# CONFIG_BLOCK is not set
CONFIG_ASN1=m
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_X86_32_IRIS=m
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
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
CONFIG_MCRUSOE=y
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
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
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
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_UP_APIC=y
# CONFIG_X86_UP_IOAPIC is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_ANCIENT_MCE=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=y
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=m
# CONFIG_X86_CPUID is not set
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
CONFIG_VMSPLIT_2G_OPT=y
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x78000000
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
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
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
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
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
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=m
# CONFIG_SCx200HR_TIMER is not set
CONFIG_OLPC=y
# CONFIG_OLPC_XO15_SCI is not set
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
# CONFIG_GEOS is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
CONFIG_PCMCIA=m
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
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
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_IOSF_MBI=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_ATM=m
CONFIG_ATM_LANE=m
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=m
# CONFIG_IPDDP is not set
CONFIG_X25=y
CONFIG_LAPB=m
CONFIG_PHONET=y
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=m
CONFIG_BATMAN_ADV=m
# CONFIG_BATMAN_ADV_NC is not set
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_OPENVSWITCH=y
# CONFIG_VSOCKETS is not set
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=m
CONFIG_NET_MPLS_GSO=m
CONFIG_HSR=m
# CONFIG_CGROUP_NET_PRIO is not set
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=y
CONFIG_CAN_GW=m

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
# CONFIG_CAN_SLCAN is not set
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
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
CONFIG_IRDA_CACHE_LAST_LSAP=y
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
# CONFIG_USB_IRDA is not set
CONFIG_SIGMATEL_FIR=m
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=m
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=m
CONFIG_ALI_FIR=y
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
# CONFIG_MCS_FIR is not set
# CONFIG_BT is not set
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
# CONFIG_RFKILL_INPUT is not set
CONFIG_RFKILL_REGULATOR=m
CONFIG_RFKILL_GPIO=y
CONFIG_NET_9P=y
# CONFIG_NET_9P_VIRTIO is not set
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
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
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_DMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_PERCENTAGE=10
# CONFIG_CMA_SIZE_SEL_MBYTES is not set
CONFIG_CMA_SIZE_SEL_PERCENTAGE=y
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7

#
# Bus devices
#
CONFIG_CONNECTOR=m
CONFIG_MTD=y
# CONFIG_MTD_TESTS is not set
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_OF_PARTS=y
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_OOPS=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
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
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PHYSMAP is not set
CONFIG_MTD_PHYSMAP_OF=m
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_SCx200_DOCFLASH=m
# CONFIG_MTD_AMD76XROM is not set
# CONFIG_MTD_ICHXROM is not set
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
CONFIG_MTD_DATAFLASH=m
# CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
# CONFIG_MTD_DATAFLASH_OTP is not set
# CONFIG_MTD_M25P80 is not set
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
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=m
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=m
CONFIG_MTD_NAND_BCH=m
CONFIG_MTD_NAND_ECC_BCH=y
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=m
# CONFIG_MTD_NAND_DENALI_PCI is not set
# CONFIG_MTD_NAND_GPIO is not set
CONFIG_MTD_NAND_IDS=m
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=m
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH is not set
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
CONFIG_MTD_NAND_DOCG4=m
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_CS553X=m
CONFIG_MTD_NAND_NANDSIM=m
# CONFIG_MTD_NAND_PLATFORM is not set
CONFIG_MTD_NAND_SH_FLCTL=m
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
CONFIG_MTD_UBI_GLUEBI=m
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
CONFIG_OF_SELFTEST=y
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_ADDRESS_PCI=y
CONFIG_OF_IRQ=y
CONFIG_OF_NET=y
CONFIG_OF_MDIO=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
CONFIG_OF_MTD=y
CONFIG_PARPORT=m
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT_PC=m
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_PC_PCMCIA=m
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=m
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=m
CONFIG_SENSORS_BH1770=m
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=m
CONFIG_DS1682=y
# CONFIG_TI_DAC7512 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
# CONFIG_BMP085_I2C is not set
CONFIG_BMP085_SPI=m
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_LATTICE_ECP3_CONFIG=y
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
# CONFIG_EEPROM_93XX46 is not set
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
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
CONFIG_DUMMY=m
CONFIG_EQUALIZER=m
CONFIG_NET_TEAM=y
# CONFIG_NET_TEAM_MODE_BROADCAST is not set
CONFIG_NET_TEAM_MODE_ROUNDROBIN=m
CONFIG_NET_TEAM_MODE_RANDOM=m
# CONFIG_NET_TEAM_MODE_ACTIVEBACKUP is not set
# CONFIG_NET_TEAM_MODE_LOADBALANCE is not set
CONFIG_MACVLAN=y
CONFIG_MACVTAP=y
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_TUN is not set
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=m
CONFIG_NLMON=m
CONFIG_ARCNET=m
CONFIG_ARCNET_1201=m
CONFIG_ARCNET_1051=m
CONFIG_ARCNET_RAW=m
CONFIG_ARCNET_CAP=m
CONFIG_ARCNET_COM90xx=m
CONFIG_ARCNET_COM90xxIO=m
CONFIG_ARCNET_RIM_I=m
CONFIG_ARCNET_COM20020=m
# CONFIG_ARCNET_COM20020_PCI is not set
# CONFIG_ARCNET_COM20020_CS is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
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

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=m
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
CONFIG_NET_DSA_MV88E6123_61_65=y
# CONFIG_ETHERNET is not set
# CONFIG_FDDI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=y
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=y
# CONFIG_SMSC_PHY is not set
CONFIG_BROADCOM_PHY=m
CONFIG_BCM7XXX_PHY=m
CONFIG_BCM87XX_PHY=y
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
CONFIG_LSI_ET1011C_PHY=y
# CONFIG_MICREL_PHY is not set
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=m
CONFIG_MDIO_GPIO=m
CONFIG_MDIO_BUS_MUX=m
CONFIG_MDIO_BUS_MUX_GPIO=m
CONFIG_MDIO_BUS_MUX_MMIOREG=m
CONFIG_MICREL_KS8995MA=m
# CONFIG_PLIP is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
CONFIG_USB_RTL8152=m
CONFIG_USB_USBNET=y
# CONFIG_USB_NET_AX8817X is not set
CONFIG_USB_NET_AX88179_178A=y
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=y
CONFIG_USB_NET_HUAWEI_CDC_NCM=y
CONFIG_USB_NET_CDC_MBIM=y
# CONFIG_USB_NET_DM9601 is not set
CONFIG_USB_NET_SR9700=y
CONFIG_USB_NET_SR9800=m
CONFIG_USB_NET_SMSC75XX=m
CONFIG_USB_NET_SMSC95XX=m
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
# CONFIG_USB_AN2720 is not set
# CONFIG_USB_BELKIN is not set
# CONFIG_USB_ARMLINUX is not set
# CONFIG_USB_EPSON2888 is not set
CONFIG_USB_KC2190=y
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
CONFIG_USB_NET_QMI_WWAN=m
# CONFIG_USB_HSO is not set
# CONFIG_USB_NET_INT51X1 is not set
CONFIG_USB_CDC_PHONET=m
# CONFIG_USB_IPHETH is not set
CONFIG_USB_SIERRA_NET=m
# CONFIG_USB_VL600 is not set
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#
# CONFIG_WIMAX_I2400M_USB is not set
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=y
CONFIG_HDLC_RAW=y
# CONFIG_HDLC_RAW_ETH is not set
CONFIG_HDLC_CISCO=y
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
CONFIG_LAPBETHER=m
# CONFIG_X25_ASY is not set
CONFIG_SBNI=m
CONFIG_SBNI_MULTILINE=y
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
CONFIG_ISDN_CAPI=m
# CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON is not set
CONFIG_CAPI_TRACE=y
# CONFIG_ISDN_CAPI_CAPI20 is not set

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
# CONFIG_ISDN_DRV_AVMB1_B1PCI is not set
# CONFIG_ISDN_DRV_AVMB1_B1PCMCIA is not set
# CONFIG_ISDN_DRV_AVMB1_T1PCI is not set
# CONFIG_ISDN_DRV_AVMB1_C4 is not set
# CONFIG_CAPI_EICON is not set
# CONFIG_ISDN_DRV_GIGASET is not set
CONFIG_MISDN=m
CONFIG_MISDN_DSP=m
CONFIG_MISDN_L1OIP=m

#
# mISDN hardware drivers
#
# CONFIG_MISDN_HFCPCI is not set
# CONFIG_MISDN_HFCMULTI is not set
CONFIG_MISDN_HFCUSB=m
# CONFIG_MISDN_AVMFRITZ is not set
# CONFIG_MISDN_SPEEDFAX is not set
# CONFIG_MISDN_INFINEON is not set
# CONFIG_MISDN_W6692 is not set
# CONFIG_MISDN_NETJET is not set

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
CONFIG_INPUT_MOUSEDEV=m
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
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
# CONFIG_KEYBOARD_SH_KEYSC is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=m
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=m
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
CONFIG_JOYSTICK_GUILLEMOT=m
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
CONFIG_JOYSTICK_TMDC=m
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
# CONFIG_JOYSTICK_ZHENHUA is not set
CONFIG_JOYSTICK_DB9=m
# CONFIG_JOYSTICK_GAMECON is not set
CONFIG_JOYSTICK_TURBOGRAFX=m
CONFIG_JOYSTICK_AS5011=m
CONFIG_JOYSTICK_JOYDUMP=m
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
# CONFIG_JOYSTICK_WALKERA0701 is not set
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
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PARKBD=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=m
CONFIG_SERIO_PS2MULT=m
CONFIG_SERIO_ARC_PS2=m
CONFIG_SERIO_APBPS2=m
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
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
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
# CONFIG_SERIAL_SH_SCI is not set
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
# CONFIG_SERIAL_ST_ASC is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
CONFIG_PPDEV=m
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_GEODE=m
CONFIG_HW_RANDOM_VIA=m
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_HW_RANDOM_TPM=m
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_SCx200_GPIO is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=m
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=m
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=m
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_ARB_GPIO_CHALLENGE is not set
CONFIG_I2C_MUX_GPIO=m
CONFIG_I2C_MUX_PCA9541=m
CONFIG_I2C_MUX_PCA954x=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=y
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
CONFIG_I2C_CBUS_GPIO=m
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
# CONFIG_I2C_KEMPLD is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_RIIC=m
CONFIG_I2C_SH_MOBILE=y
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set
CONFIG_I2C_RCAR=m

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT=m
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_ROBOTFUZZ_OSIF=y
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=y
CONFIG_I2C_VIPERBOARD=m

#
# Other I2C/SMBus bus drivers
#
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_STUB is not set
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
CONFIG_SPI_BCM2835=m
CONFIG_SPI_BCM63XX_HSSPI=y
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=m
# CONFIG_SPI_EP93XX is not set
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_IMX=y
CONFIG_SPI_LM70_LLP=m
CONFIG_SPI_FSL_LIB=y
CONFIG_SPI_FSL_SPI=y
# CONFIG_SPI_FSL_DSPI is not set
CONFIG_SPI_OC_TINY=y
CONFIG_SPI_TI_QSPI=y
# CONFIG_SPI_OMAP_100K is not set
CONFIG_SPI_ORION=y
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=m
# CONFIG_SPI_SH is not set
# CONFIG_SPI_SH_HSPI is not set
CONFIG_SPI_SUN4I=y
CONFIG_SPI_SUN6I=m
CONFIG_SPI_TEGRA114=y
CONFIG_SPI_TEGRA20_SFLASH=y
CONFIG_SPI_TEGRA20_SLINK=m
# CONFIG_SPI_TOPCLIFF_PCH is not set
# CONFIG_SPI_TXX9 is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
CONFIG_SPI_DESIGNWARE=m
# CONFIG_SPI_DW_PCI is not set
# CONFIG_SPI_DW_MMIO is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
# CONFIG_SPI_TLE62X0 is not set
CONFIG_SPMI=m
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
CONFIG_PPS_CLIENT_KTIMER=m
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_PARPORT is not set
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
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_CLPS711X=m
CONFIG_GPIO_GENERIC_PLATFORM=m
CONFIG_GPIO_DWAPB=y
CONFIG_GPIO_IT8761E=m
# CONFIG_GPIO_F7188X is not set
CONFIG_GPIO_SCH311X=y
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set
CONFIG_GPIO_GRGPIO=y

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_LP3943 is not set
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_TC3589X is not set
# CONFIG_GPIO_TWL6040 is not set
# CONFIG_GPIO_WM831X is not set
# CONFIG_GPIO_WM8994 is not set
# CONFIG_GPIO_ADP5588 is not set
# CONFIG_GPIO_ADNP is not set

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
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MCP23S08=y
CONFIG_GPIO_MC33880=m
CONFIG_GPIO_74X164=y

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
CONFIG_GPIO_TPS6586X=y
CONFIG_GPIO_BCM_KONA=y

#
# USB GPIO expanders:
#
CONFIG_GPIO_VIPERBOARD=m
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=m
# CONFIG_W1_MASTER_MXC is not set
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=m
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=m
# CONFIG_MAX8925_POWER is not set
# CONFIG_WM831X_BACKUP is not set
CONFIG_WM831X_POWER=y
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_88PM860X is not set
CONFIG_BATTERY_DS2760=m
CONFIG_BATTERY_DS2780=m
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_OLPC is not set
CONFIG_BATTERY_SBS=y
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9052 is not set
CONFIG_BATTERY_MAX17040=m
CONFIG_BATTERY_MAX17042=m
CONFIG_CHARGER_PCF50633=m
CONFIG_CHARGER_ISP1704=m
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_LP8788=m
CONFIG_CHARGER_GPIO=m
CONFIG_CHARGER_MANAGER=y
CONFIG_CHARGER_MAX14577=m
CONFIG_CHARGER_MAX8998=y
CONFIG_CHARGER_BQ2415X=m
CONFIG_CHARGER_BQ24190=m
# CONFIG_CHARGER_BQ24735 is not set
CONFIG_CHARGER_SMB347=m
CONFIG_CHARGER_TPS65090=m
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7314=m
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_DA9055=m
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
# CONFIG_SENSORS_MC13783_ADC is not set
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_GL518SM=m
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=m
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_IIO_HWMON=m
CONFIG_SENSORS_CORETEMP=m
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=m
CONFIG_SENSORS_LTC2945=y
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4222=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4260=y
CONFIG_SENSORS_LTC4261=m
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=m
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_HTU21=m
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=m
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=y
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=m
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_ADC128D818=m
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=m
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=m
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_WM831X=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_OF is not set
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_EMULATION=y
# CONFIG_RCAR_THERMAL is not set
CONFIG_INTEL_POWERCLAMP=m
CONFIG_X86_PKG_TEMP_THERMAL=m
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
# CONFIG_SSB_SILENT is not set
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
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_HOST_SOC=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_AS3711=y
# CONFIG_MFD_AS3722 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=m
CONFIG_MFD_CROS_EC_SPI=m
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_SPI=m
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=m
CONFIG_HTC_I2CPLD=y
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=m
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_VIPERBOARD=m
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=m
# CONFIG_PCF50633_ADC is not set
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RTSX_USB=m
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_SEC_CORE=y
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP3943=y
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=m
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=m
# CONFIG_MFD_TPS65218 is not set
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM5102 is not set
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=m
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
# CONFIG_REGULATOR_88PM800 is not set
# CONFIG_REGULATOR_88PM8607 is not set
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=m
# CONFIG_REGULATOR_AS3711 is not set
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9210=m
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=y
CONFIG_REGULATOR_MAX14577=y
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8925 is not set
CONFIG_REGULATOR_MAX8952=m
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MAX8998=y
CONFIG_REGULATOR_MAX77686=y
CONFIG_REGULATOR_MC13XXX_CORE=m
CONFIG_REGULATOR_MC13783=m
# CONFIG_REGULATOR_MC13892 is not set
CONFIG_REGULATOR_PCF50633=m
# CONFIG_REGULATOR_PFUZE100 is not set
CONFIG_REGULATOR_S2MPA01=m
# CONFIG_REGULATOR_S2MPS11 is not set
CONFIG_REGULATOR_S5M8767=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=m
CONFIG_REGULATOR_TPS65090=y
CONFIG_REGULATOR_TPS65217=m
# CONFIG_REGULATOR_TPS6524X is not set
# CONFIG_REGULATOR_TPS6586X is not set
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8400=m
CONFIG_REGULATOR_WM8994=y
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_VMALLOC=m
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_RC_CORE=m
CONFIG_RC_MAP=m
# CONFIG_RC_DECODERS is not set
CONFIG_RC_DEVICES=y
# CONFIG_RC_ATI_REMOTE is not set
# CONFIG_IR_ENE is not set
CONFIG_IR_IMON=m
CONFIG_IR_MCEUSB=m
# CONFIG_IR_ITE_CIR is not set
# CONFIG_IR_FINTEK is not set
# CONFIG_IR_NUVOTON is not set
# CONFIG_IR_REDRAT3 is not set
# CONFIG_IR_STREAMZAP is not set
# CONFIG_IR_WINBOND_CIR is not set
CONFIG_IR_IGUANA=m
# CONFIG_IR_TTUSBIR is not set
CONFIG_IR_IMG=m
CONFIG_IR_IMG_RAW=y
CONFIG_IR_IMG_HW=y
CONFIG_IR_IMG_NEC=y
CONFIG_IR_IMG_JVC=y
CONFIG_IR_IMG_SONY=y
# CONFIG_IR_IMG_SHARP is not set
# CONFIG_IR_IMG_SANYO is not set
CONFIG_RC_LOOPBACK=m
CONFIG_IR_GPIO_CIR=m
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_RADIO_ADAPTERS is not set
CONFIG_CYPRESS_FIRMWARE=m

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=m

#
# Audio decoders, processors and mixers
#

#
# RDS decoders
#

#
# Video decoders
#

#
# Video and audio decoders
#

#
# Video encoders
#

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#

#
# Audio/Video compression chips
#

#
# Miscellaneous helper chips
#

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MC44S803=m

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
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set

#
# Frame buffer Devices
#
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
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
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
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=m
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=m
CONFIG_FB_HGA=m
CONFIG_FB_OPENCORES=y
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
CONFIG_FB_TMIO=m
CONFIG_FB_TMIO_ACCELL=y
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=m
CONFIG_FB_GOLDFISH=m
CONFIG_FB_VIRTUAL=m
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
CONFIG_FB_SIMPLE=y
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_FB_SSD1307=m
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_PWM=m
CONFIG_BACKLIGHT_DA9052=y
CONFIG_BACKLIGHT_MAX8925=y
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_WM831X=m
CONFIG_BACKLIGHT_ADP8860=m
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_88PM860X is not set
CONFIG_BACKLIGHT_PCF50633=m
CONFIG_BACKLIGHT_LM3630A=y
CONFIG_BACKLIGHT_LM3639=m
CONFIG_BACKLIGHT_LP855X=m
CONFIG_BACKLIGHT_LP8788=m
# CONFIG_BACKLIGHT_TPS65217 is not set
CONFIG_BACKLIGHT_AS3711=m
CONFIG_BACKLIGHT_GPIO=y
# CONFIG_BACKLIGHT_LV5207LP is not set
CONFIG_BACKLIGHT_BD6107=m
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=m
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_APPLEIR is not set
CONFIG_HID_AUREAL=m
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=m
CONFIG_HID_CP2112=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=m
CONFIG_HID_ELECOM=m
CONFIG_HID_ELO=m
CONFIG_HID_EZKEY=m
CONFIG_HID_HOLTEK=m
CONFIG_HOLTEK_FF=y
CONFIG_HID_HUION=m
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=m
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
CONFIG_HID_LENOVO_TPKBD=m
# CONFIG_HID_LOGITECH is not set
CONFIG_HID_MAGICMOUSE=m
# CONFIG_HID_MICROSOFT is not set
CONFIG_HID_MONTEREY=m
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_NTRIG=m
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=m
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
# CONFIG_HID_PICOLCD_FB is not set
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
CONFIG_HID_PICOLCD_LEDS=y
# CONFIG_HID_PICOLCD_CIR is not set
CONFIG_HID_PRIMAX=m
CONFIG_HID_ROCCAT=m
CONFIG_HID_SAITEK=m
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SONY=m
CONFIG_SONY_FF=y
CONFIG_HID_SPEEDLINK=m
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=m
# CONFIG_HID_XINMO is not set
# CONFIG_HID_ZEROPLUS is not set
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
CONFIG_USB_DEFAULT_PERSIST=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG=y
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_MON=m
CONFIG_USB_WUSB_CBAF=m
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
# CONFIG_USB_XHCI_HCD is not set
# CONFIG_USB_EHCI_HCD is not set
CONFIG_USB_OXU210HP_HCD=m
CONFIG_USB_ISP116X_HCD=y
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_ISP1362_HCD=m
# CONFIG_USB_FUSBH200_HCD is not set
CONFIG_USB_FOTG210_HCD=m
CONFIG_USB_OHCI_HCD=m
CONFIG_USB_OHCI_HCD_PCI=m
CONFIG_USB_OHCI_HCD_SSB=y
CONFIG_USB_OHCI_HCD_PLATFORM=m
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_HCD_ISO is not set
# CONFIG_USB_SL811_CS is not set
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_RENESAS_USBHS_HCD=m
CONFIG_USB_HCD_BCMA=m
CONFIG_USB_HCD_SSB=y
CONFIG_USB_HCD_TEST_MODE=y
CONFIG_USB_RENESAS_USBHS=m

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
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
CONFIG_USB_MDC800=y
CONFIG_USB_MUSB_HDRC=m
# CONFIG_USB_MUSB_HOST is not set
CONFIG_USB_MUSB_GADGET=y
# CONFIG_USB_MUSB_DUAL_ROLE is not set
CONFIG_USB_MUSB_TUSB6010=m
# CONFIG_USB_MUSB_DSPS is not set
CONFIG_USB_MUSB_UX500=m
CONFIG_USB_MUSB_JZ4740=m
# CONFIG_USB_UX500_DMA is not set
CONFIG_MUSB_PIO_ONLY=y
# CONFIG_USB_DWC3 is not set
CONFIG_USB_DWC2=m
CONFIG_USB_DWC2_DEBUG=y
# CONFIG_USB_DWC2_VERBOSE is not set
CONFIG_USB_DWC2_TRACK_MISSED_SOFS=y
# CONFIG_USB_DWC2_DEBUG_PERIODIC is not set
CONFIG_USB_CHIPIDEA=m
CONFIG_USB_CHIPIDEA_UDC=y
# CONFIG_USB_CHIPIDEA_DEBUG is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=m
# CONFIG_USB_LEGOTOWER is not set
CONFIG_USB_LCD=m
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=y
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
CONFIG_USB_ISIGHTFW=y
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=y
# CONFIG_USB_ATM is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_USB_OTG_FSM=m
CONFIG_KEYSTONE_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_AM335X_CONTROL_USB=y
CONFIG_AM335X_PHY_USB=y
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
CONFIG_TAHVO_USB=y
CONFIG_TAHVO_USB_HOST_BY_DEFAULT=y
CONFIG_USB_ISP1301=y
CONFIG_USB_RCAR_PHY=y
# CONFIG_USB_RCAR_GEN2_PHY is not set
CONFIG_USB_GADGET=m
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
# CONFIG_USB_FUSB300 is not set
CONFIG_USB_FOTG210_UDC=m
# CONFIG_USB_GR_UDC is not set
# CONFIG_USB_R8A66597 is not set
# CONFIG_USB_RENESAS_USBHS_UDC is not set
CONFIG_USB_PXA27X=m
# CONFIG_USB_S3C_HSOTG is not set
CONFIG_USB_MV_UDC=m
CONFIG_USB_MV_U3D=m
CONFIG_USB_M66592=m
# CONFIG_USB_AMD5536UDC is not set
CONFIG_USB_NET2272=m
CONFIG_USB_NET2272_DMA=y
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
CONFIG_USB_DUMMY_HCD=m
CONFIG_USB_LIBCOMPOSITE=m
CONFIG_USB_F_SS_LB=m
CONFIG_USB_U_ETHER=m
CONFIG_USB_F_NCM=m
CONFIG_USB_F_ECM=m
CONFIG_USB_F_EEM=m
CONFIG_USB_F_SUBSET=m
CONFIG_USB_F_RNDIS=m
CONFIG_USB_F_FS=m
CONFIG_USB_CONFIGFS=m
# CONFIG_USB_CONFIGFS_SERIAL is not set
# CONFIG_USB_CONFIGFS_ACM is not set
# CONFIG_USB_CONFIGFS_OBEX is not set
CONFIG_USB_CONFIGFS_NCM=y
# CONFIG_USB_CONFIGFS_ECM is not set
# CONFIG_USB_CONFIGFS_ECM_SUBSET is not set
CONFIG_USB_CONFIGFS_RNDIS=y
CONFIG_USB_CONFIGFS_EEM=y
# CONFIG_USB_CONFIGFS_PHONET is not set
CONFIG_USB_CONFIGFS_F_LB_SS=y
# CONFIG_USB_CONFIGFS_F_FS is not set
CONFIG_USB_ZERO=m
# CONFIG_USB_ZERO_HNPTEST is not set
# CONFIG_USB_ETH is not set
CONFIG_USB_G_NCM=m
CONFIG_USB_GADGETFS=m
CONFIG_USB_FUNCTIONFS=m
CONFIG_USB_FUNCTIONFS_ETH=y
CONFIG_USB_FUNCTIONFS_RNDIS=y
CONFIG_USB_FUNCTIONFS_GENERIC=y
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_NOKIA is not set
CONFIG_USB_G_HID=m
# CONFIG_USB_G_DBGP is not set
CONFIG_USB_G_WEBCAM=m
# CONFIG_UWB is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

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
CONFIG_LEDS_88PM860X=m
CONFIG_LEDS_LM3530=m
CONFIG_LEDS_LM3642=m
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_LP5562=m
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_LP8788 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=m
CONFIG_LEDS_PCA963X=m
# CONFIG_LEDS_PCA9685 is not set
CONFIG_LEDS_WM831X_STATUS=m
CONFIG_LEDS_DA9052=m
CONFIG_LEDS_DAC124S085=m
CONFIG_LEDS_PWM=m
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_MC13783=m
CONFIG_LEDS_TCA6507=m
CONFIG_LEDS_LM355x=m
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
CONFIG_EDAC_DEBUG=y
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
# CONFIG_EDAC_I7CORE is not set
# CONFIG_EDAC_I82860 is not set
# CONFIG_EDAC_R82600 is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_88PM860X is not set
CONFIG_RTC_DRV_88PM80X=m
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_HYM8563=y
# CONFIG_RTC_DRV_LP8788 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_MAX8925 is not set
CONFIG_RTC_DRV_MAX8998=y
CONFIG_RTC_DRV_MAX77686=m
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_ISL12057=m
# CONFIG_RTC_DRV_X1205 is not set
CONFIG_RTC_DRV_PCF2127=y
CONFIG_RTC_DRV_PCF8523=y
CONFIG_RTC_DRV_PCF8563=m
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=m
# CONFIG_RTC_DRV_M41T80_WDT is not set
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_TPS6586X=y
CONFIG_RTC_DRV_S35390A=m
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=m
CONFIG_RTC_DRV_RV3029C2=y
# CONFIG_RTC_DRV_S5M is not set

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=m
CONFIG_RTC_DRV_M41T94=y
CONFIG_RTC_DRV_DS1305=y
CONFIG_RTC_DRV_DS1390=y
CONFIG_RTC_DRV_MAX6902=y
CONFIG_RTC_DRV_R9701=y
CONFIG_RTC_DRV_RS5C348=m
# CONFIG_RTC_DRV_DS3234 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
CONFIG_RTC_DRV_RX4581=y

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_DA9052 is not set
CONFIG_RTC_DRV_DA9055=m
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_M48T86=m
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=m
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=y
# CONFIG_RTC_DRV_DS2404 is not set
CONFIG_RTC_DRV_WM831X=m
# CONFIG_RTC_DRV_PCF50633 is not set

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=m
CONFIG_RTC_DRV_SNVS=m
CONFIG_RTC_DRV_MOXART=y

#
# HID Sensor RTC drivers
#
CONFIG_RTC_DRV_HID_SENSOR_TIME=m
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=m
CONFIG_UIO_DMEM_GENIRQ=m
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
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
# CONFIG_USBIP_CORE is not set
CONFIG_COMEDI=m
CONFIG_COMEDI_DEBUG=y
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
CONFIG_COMEDI_MISC_DRIVERS=y
CONFIG_COMEDI_KCOMEDILIB=m
CONFIG_COMEDI_BOND=m
CONFIG_COMEDI_TEST=m
CONFIG_COMEDI_PARPORT=m
CONFIG_COMEDI_SERIAL2002=m
CONFIG_COMEDI_SKEL=m
CONFIG_COMEDI_SSV_DNP=m
CONFIG_COMEDI_ISA_DRIVERS=y
CONFIG_COMEDI_PCL711=m
# CONFIG_COMEDI_PCL724 is not set
CONFIG_COMEDI_PCL726=m
CONFIG_COMEDI_PCL730=m
CONFIG_COMEDI_PCL812=m
CONFIG_COMEDI_PCL816=m
CONFIG_COMEDI_PCL818=m
CONFIG_COMEDI_PCM3724=m
# CONFIG_COMEDI_AMPLC_DIO200_ISA is not set
# CONFIG_COMEDI_AMPLC_PC236_ISA is not set
CONFIG_COMEDI_AMPLC_PC263_ISA=m
CONFIG_COMEDI_RTI800=m
CONFIG_COMEDI_RTI802=m
CONFIG_COMEDI_DAC02=m
CONFIG_COMEDI_DAS16M1=m
CONFIG_COMEDI_DAS08_ISA=m
CONFIG_COMEDI_DAS16=m
CONFIG_COMEDI_DAS800=m
# CONFIG_COMEDI_DAS1800 is not set
CONFIG_COMEDI_DAS6402=m
CONFIG_COMEDI_DT2801=m
# CONFIG_COMEDI_DT2811 is not set
# CONFIG_COMEDI_DT2814 is not set
CONFIG_COMEDI_DT2815=m
CONFIG_COMEDI_DT2817=m
# CONFIG_COMEDI_DT282X is not set
CONFIG_COMEDI_DMM32AT=m
CONFIG_COMEDI_UNIOXX5=m
# CONFIG_COMEDI_FL512 is not set
CONFIG_COMEDI_AIO_AIO12_8=m
CONFIG_COMEDI_AIO_IIRO_16=m
# CONFIG_COMEDI_II_PCI20KC is not set
# CONFIG_COMEDI_C6XDIGIO is not set
CONFIG_COMEDI_MPC624=m
CONFIG_COMEDI_ADQ12B=m
CONFIG_COMEDI_NI_AT_A2150=m
# CONFIG_COMEDI_NI_AT_AO is not set
CONFIG_COMEDI_NI_ATMIO=m
CONFIG_COMEDI_NI_ATMIO16D=m
CONFIG_COMEDI_NI_LABPC_ISA=m
CONFIG_COMEDI_PCMAD=m
CONFIG_COMEDI_PCMDA12=m
# CONFIG_COMEDI_PCMMIO is not set
CONFIG_COMEDI_PCMUIO=m
# CONFIG_COMEDI_MULTIQ3 is not set
CONFIG_COMEDI_POC=m
# CONFIG_COMEDI_S526 is not set
# CONFIG_COMEDI_PCI_DRIVERS is not set
# CONFIG_COMEDI_PCMCIA_DRIVERS is not set
CONFIG_COMEDI_USB_DRIVERS=y
CONFIG_COMEDI_DT9812=m
CONFIG_COMEDI_USBDUX=m
CONFIG_COMEDI_USBDUXFAST=m
CONFIG_COMEDI_USBDUXSIGMA=m
# CONFIG_COMEDI_VMK80XX is not set
CONFIG_COMEDI_8255=m
CONFIG_COMEDI_FC=m
CONFIG_COMEDI_DAS08=m
CONFIG_COMEDI_NI_LABPC=m
CONFIG_COMEDI_NI_LABPC_ISADMA=m
CONFIG_COMEDI_NI_TIO=m
CONFIG_FB_OLPC_DCON=y
CONFIG_FB_OLPC_DCON_1_5=y
CONFIG_PANEL=m
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
# CONFIG_PANEL_CHANGE_MESSAGE is not set
CONFIG_TRANZPORT=m
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#

#
# Accelerometers
#
CONFIG_ADIS16201=m
CONFIG_ADIS16203=m
CONFIG_ADIS16204=m
CONFIG_ADIS16209=m
# CONFIG_ADIS16220 is not set
# CONFIG_ADIS16240 is not set
CONFIG_LIS3L02DQ=m
# CONFIG_SCA3000 is not set

#
# Analog to digital converters
#
# CONFIG_AD7291 is not set
CONFIG_AD7606=m
# CONFIG_AD7606_IFACE_PARALLEL is not set
# CONFIG_AD7606_IFACE_SPI is not set
CONFIG_AD799X=m
CONFIG_AD799X_RING_BUFFER=y
CONFIG_AD7780=m
CONFIG_AD7816=m
CONFIG_AD7192=m
CONFIG_AD7280=m
CONFIG_LPC32XX_ADC=m
CONFIG_MXS_LRADC=m
CONFIG_SPEAR_ADC=m

#
# Analog digital bi-direction converters
#
# CONFIG_ADT7316 is not set

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
# CONFIG_AD7152 is not set
CONFIG_AD7746=m

#
# Direct Digital Synthesis
#
CONFIG_AD5930=m
CONFIG_AD9832=m
CONFIG_AD9834=m
CONFIG_AD9850=m
CONFIG_AD9852=m
CONFIG_AD9910=m
CONFIG_AD9951=m

#
# Digital gyroscope sensors
#
CONFIG_ADIS16060=m

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=m
CONFIG_SENSORS_ISL29028=m
CONFIG_TSL2583=m
# CONFIG_TSL2x7x is not set

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=m

#
# Active energy metering IC
#
CONFIG_ADE7753=m
# CONFIG_ADE7754 is not set
CONFIG_ADE7758=m
CONFIG_ADE7759=m
# CONFIG_ADE7854 is not set

#
# Resolver to digital converters
#
CONFIG_AD2S90=m
# CONFIG_AD2S1200 is not set
CONFIG_AD2S1210=m

#
# Triggers - standalone
#
CONFIG_IIO_PERIODIC_RTC_TRIGGER=m
CONFIG_IIO_DUMMY_EVGEN=m
CONFIG_IIO_SIMPLE_DUMMY=m
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
# CONFIG_CRYSTALHD is not set
# CONFIG_CXT1E1 is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_SBE_2T3E3 is not set
CONFIG_BCM_WIMAX=y
CONFIG_FT1000=m
CONFIG_FT1000_USB=m
CONFIG_FT1000_PCMCIA=m

#
# Speakup console speech
#
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=m
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_USB_WPAN_HCD=m
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_LTE_GDM724X is not set
# CONFIG_NET_VENDOR_SILICOM is not set
CONFIG_CED1401=m
# CONFIG_DGRP is not set
CONFIG_MTD_SPINAND_MT29F=m
# CONFIG_MTD_SPINAND_ONDIEECC is not set
CONFIG_XILLYBUS=m
# CONFIG_XILLYBUS_PCIE is not set
CONFIG_XILLYBUS_OF=m
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
CONFIG_GS_FPGABOOT=y
# CONFIG_X86_PLATFORM_DEVICES is not set
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_LAPTOP=m
CONFIG_CHROMEOS_PSTORE=m

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
CONFIG_SH_TIMER_MTU2=y
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
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
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=m
CONFIG_EXTCON_ADC_JACK=m
CONFIG_EXTCON_MAX14577=m
# CONFIG_MEMORY is not set
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_BUFFER_CB is not set
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
# CONFIG_BMA180 is not set
CONFIG_HID_SENSOR_ACCEL_3D=m
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
CONFIG_KXSD9=m

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=m
# CONFIG_AD7266 is not set
# CONFIG_AD7298 is not set
CONFIG_AD7476=m
CONFIG_AD7791=m
# CONFIG_AD7793 is not set
CONFIG_AD7887=m
CONFIG_AD7923=m
# CONFIG_EXYNOS_ADC is not set
CONFIG_LP8788_ADC=y
# CONFIG_MAX1363 is not set
# CONFIG_MCP320X is not set
# CONFIG_MCP3422 is not set
CONFIG_NAU7802=m
CONFIG_TI_ADC081C=m
# CONFIG_VF610_ADC is not set
CONFIG_VIPERBOARD_ADC=m
# CONFIG_XILINX_XADC is not set

#
# Amplifiers
#
CONFIG_AD8366=m

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_SPI=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Digital to analog converters
#
CONFIG_AD5064=m
CONFIG_AD5360=m
CONFIG_AD5380=m
# CONFIG_AD5421 is not set
# CONFIG_AD5446 is not set
# CONFIG_AD5449 is not set
# CONFIG_AD5504 is not set
CONFIG_AD5624R_SPI=m
# CONFIG_AD5686 is not set
# CONFIG_AD5755 is not set
# CONFIG_AD5764 is not set
CONFIG_AD5791=m
CONFIG_AD7303=m
CONFIG_MAX517=m
CONFIG_MCP4725=m

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
CONFIG_AD9523=m

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
# CONFIG_ADF4350 is not set

#
# Digital gyroscope sensors
#
CONFIG_ADIS16080=m
# CONFIG_ADIS16130 is not set
CONFIG_ADIS16136=m
# CONFIG_ADIS16260 is not set
# CONFIG_ADXRS450 is not set
# CONFIG_HID_SENSOR_GYRO_3D is not set
CONFIG_IIO_ST_GYRO_3AXIS=m
CONFIG_IIO_ST_GYRO_I2C_3AXIS=m
CONFIG_IIO_ST_GYRO_SPI_3AXIS=m
# CONFIG_ITG3200 is not set

#
# Humidity sensors
#
CONFIG_DHT11=m
CONFIG_SI7005=m

#
# Inertial measurement units
#
CONFIG_ADIS16400=m
CONFIG_ADIS16480=m
CONFIG_INV_MPU6050_IIO=m
CONFIG_IIO_ADIS_LIB=m
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
# CONFIG_APDS9300 is not set
CONFIG_CM32181=m
CONFIG_CM36651=m
CONFIG_GP2AP020A00F=m
CONFIG_HID_SENSOR_ALS=m
# CONFIG_HID_SENSOR_PROX is not set
CONFIG_LTR501=m
CONFIG_TCS3472=m
CONFIG_SENSORS_TSL2563=m
# CONFIG_TSL4531 is not set
# CONFIG_VCNL4000 is not set

#
# Magnetometer sensors
#
CONFIG_AK8975=m
CONFIG_MAG3110=m
# CONFIG_HID_SENSOR_MAGNETOMETER_3D is not set
# CONFIG_IIO_ST_MAGN_3AXIS is not set

#
# Inclinometer sensors
#
# CONFIG_HID_SENSOR_INCLINOMETER_3D is not set

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=m
CONFIG_IIO_SYSFS_TRIGGER=m

#
# Pressure sensors
#
# CONFIG_HID_SENSOR_PRESS is not set
CONFIG_MPL3115=m
CONFIG_IIO_ST_PRESS=m
CONFIG_IIO_ST_PRESS_I2C=m
CONFIG_IIO_ST_PRESS_SPI=m

#
# Temperature sensors
#
# CONFIG_TMP006 is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_CLPS711X=y
# CONFIG_PWM_FSL_FTM is not set
# CONFIG_PWM_LP3943 is not set
# CONFIG_PWM_PCA9685 is not set
# CONFIG_PWM_RENESAS_TPU is not set
CONFIG_IRQCHIP=y
# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=m
CONFIG_FMC_FAKEDEV=m
CONFIG_FMC_TRIVIAL=m
# CONFIG_FMC_WRITE_EEPROM is not set
# CONFIG_FMC_CHARDEV is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_EXYNOS_MIPI_VIDEO=y
# CONFIG_OMAP_CONTROL_PHY is not set
CONFIG_PHY_EXYNOS_DP_VIDEO=y
CONFIG_BCM_KONA_USB2_PHY=y
# CONFIG_PHY_SAMSUNG_USB2 is not set
CONFIG_PHY_XGENE=m
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y
# CONFIG_MCB is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
# CONFIG_DCDBAS is not set
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
CONFIG_FS_POSIX_ACL=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_DEBUG is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ECRYPT_FS=m
CONFIG_ECRYPT_FS_MESSAGING=y
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
# CONFIG_JFFS2_SUMMARY is not set
CONFIG_JFFS2_FS_XATTR=y
CONFIG_JFFS2_FS_POSIX_ACL=y
# CONFIG_JFFS2_FS_SECURITY is not set
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
CONFIG_UBIFS_FS=m
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
# CONFIG_UBIFS_FS_LZO is not set
CONFIG_UBIFS_FS_ZLIB=y
CONFIG_LOGFS=m
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_MTD=y
CONFIG_ROMFS_ON_MTD=y
# CONFIG_PSTORE is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=m
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=m
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
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
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
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
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
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_DEBUG_PREEMPT=y

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
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU_DELAY=y
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_TORTURE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
CONFIG_NOTIFIER_ERROR_INJECTION=m
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
# CONFIG_TEST_LIST_SORT is not set
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
CONFIG_PERCPU_TEST=m
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=m
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_MODULE=m
CONFIG_TEST_USER_COPY=m
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_STRESS is not set
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
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
# CONFIG_BIG_KEYS is not set
CONFIG_TRUSTED_KEYS=m
CONFIG_ENCRYPTED_KEYS=m
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
# CONFIG_INTEGRITY_ASYMMETRIC_KEYS is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
# CONFIG_IMA_TEMPLATE is not set
CONFIG_IMA_NG_TEMPLATE=y
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima-ng"
# CONFIG_IMA_DEFAULT_HASH_SHA1 is not set
CONFIG_IMA_DEFAULT_HASH_SHA256=y
# CONFIG_IMA_DEFAULT_HASH_WP512 is not set
CONFIG_IMA_DEFAULT_HASH="sha256"
CONFIG_IMA_APPRAISE=y
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_YAMA=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="yama"
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
CONFIG_CRYPTO_PCOMP=m
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
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=m
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST_COMMON=y
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=m
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=m
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=m
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=m
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=m
CONFIG_PUBLIC_KEY_ALGO_RSA=m
CONFIG_X509_CERTIFICATE_PARSER=m
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
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
CONFIG_STMP_DEVICE=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
# CONFIG_CRC64_ECMA is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=m
CONFIG_BTREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=m
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_OID_REGISTRY=m

--pWyiEgJYm5f9v55/--
