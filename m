Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab3FIWYe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 18:24:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:41957 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104Ab3FIWYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 18:24:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,833,1363158000"; 
   d="log'?scan'208";a="347251531"
Date: Mon, 10 Jun 2013 06:24:14 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: fengguang.wu@intel.com, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: [i386/load_elf_binary] BUG: unable to handle kernel paging request
 at c16561d0
Message-ID: <20130609222414.GA11410@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit bf400180b35912be07e8e22ddcb1e2b266b81067
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Jul 14 00:50:02 2010 -0700

    i386: NX emulation
    
    This is old code with some cruft, all originally by Ingo Molnar with
    much later rebasing by Fedora folks and at least one arcane fix by
    Roland McGrath a few years ago. No longer uses exec-shield sysctl,
    merged with disable_nx. Kees Cook fixed boottime NX reporting for various
    corner cases.
    
    Signed-off-by: Kees Cook <kees.cook@canonical.com>


Parent commit not clean. Look out for wrong bisect!

/kernel/i386-randconfig-r05-0609/29eb77825cc7da8d45b642de2de3d423dc8a363f/dmesg-kvm-bay-28398-20130610034933-3.10.0-rc4-00157-g29eb778-31
/kernel/i386-randconfig-r05-0609/29eb77825cc7da8d45b642de2de3d423dc8a363f/dmesg-kvm-bay-28446-20130610032719-3.10.0-rc4-00157-g29eb778-31
/kernel/i386-randconfig-r05-0609/29eb77825cc7da8d45b642de2de3d423dc8a363f/dmesg-kvm-bay-28446-20130610034919-3.10.0-rc4-00157-g29eb778-31
/kernel/i386-randconfig-r05-0609/29eb77825cc7da8d45b642de2de3d423dc8a363f/dmesg-kvm-bay-28494-20130610034912-3.10.0-rc4-00157-g29eb778-31
/kernel/i386-randconfig-r05-0609/29eb77825cc7da8d45b642de2de3d423dc8a363f/dmesg-kvm-bay-28541-20130610032701-3.10.0-rc4-00157-g29eb778-31
/kernel/i386-randconfig-r05-0609/29eb77825cc7da8d45b642de2de3d423dc8a363f/dmesg-kvm-bay-28541-20130610033845-3.10.0-rc4-00157-g29eb778-31
/kernel/i386-randconfig-r05-0609/29eb77825cc7da8d45b642de2de3d423dc8a363f/dmesg-kvm-bay-28541-20130610034930-3.10.0-rc4-00157-g29eb778-31

[  442.715828] Write protecting the kernel text: 3872k
[  442.724722] Write protecting the kernel read-only data: 1948k
[  443.053460] BUG: unable to handle kernel paging request at c16561d0
[  443.053460] IP: [<c1105fb1>] load_elf_binary+0x2e1/0xdb0
[  443.053460] *pde = 01b9b067 *pte = 01656062 
[  443.053460] Oops: 0000 [#1] DEBUG_PAGEALLOC
[  443.053460] Modules linked in:
[  443.053460] CPU: 0 PID: 1 Comm: swapper Not tainted 3.10.0-rc5-01256-g03a188b #1
[  443.053460] task: cb868000 ti: cb862000 task.ti: cb862000
[  443.053460] EIP: 0060:[<c1105fb1>] EFLAGS: 00000246 CPU: 0
[  443.053460] EIP is at load_elf_binary+0x2e1/0xdb0
[  443.053460] EAX: 00000000 EBX: c47aae40 ECX: 00000000 EDX: c471f510
[  443.053460] ESI: c471f544 EDI: 00000000 EBP: cb863f14 ESP: cb863e98
[  443.053460]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[  443.053460] CR0: 8005003b CR2: c16561d0 CR3: 047ab000 CR4: 00000690
[  443.053460] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  443.053460] DR6: 00000000 DR7: 00000000
[  443.053460] Stack:
[  443.053460]  c471f510 00000080 c15cadb0 cb863ec4 00000002 c1003955 0000007b cb868000
[  443.053460]  00000000 00000001 00000000 00000000 000002e9 00000000 cb868000 c15ca6b8
[  443.053460]  00000001 cb863f08 00000246 c47199c0 00000246 cb9df780 c11058c0 c10d2a7a
[  443.053460] Call Trace:
[  443.053460]  [<c1003955>] ? do_IRQ+0x75/0x90
[  443.053460]  [<c11058c0>] ? bm_status_write+0xe0/0xe0
[  443.053460]  [<c10d2a7a>] ? search_binary_handler+0x32a/0x380
[  443.053460]  [<c1105cd0>] ? load_elf_library+0x1d0/0x1d0
[  443.053460]  [<c10d2a87>] search_binary_handler+0x337/0x380
[  443.053460]  [<c10d2778>] ? search_binary_handler+0x28/0x380
[  443.053460]  [<c10d3adf>] do_execve+0x4af/0x660
[  443.053460]  [<c10d3708>] ? do_execve+0xd8/0x660
[  443.053460]  [<c10000f7>] run_init_process+0x17/0x20
[  443.053460]  [<c13ba1b7>] kernel_init+0x37/0xf0
[  443.053460]  [<c13c6b1b>] ret_from_kernel_thread+0x1b/0x30
[  443.053460]  [<c13ba180>] ? rest_init+0x130/0x130
[  443.053460] Code: 00 00 eb 15 c7 45 d0 00 00 00 00 c7 45 d8 00 00 00 00 c7 45 e4 00 00 00 00 8b 45 f0 e8 59 cd fc ff 89 c7 85 c0 0f 85 a1 09 00 00 <83> 3d d0 61 65 c1 00 75 0f 83 7d e4 01 0f 85 1a 0a 00 00 e9 d7
[  443.053460] EIP: [<c1105fb1>] load_elf_binary+0x2e1/0xdb0 SS:ESP 0068:cb863e98
[  443.053460] CR2: 00000000c16561d0
[  443.053460] ---[ end trace 25e1f5808e99ed0b ]---

git bisect start 03a188b29c8d5f332292e972a1d7eb1cd26d8109 317ddd256b9c24b0d78fa8018f80f1e495481a10 --
git bisect good 78f304d06c47d600ec1a4b0995f1f4c5667a677e  #   123  2013-06-09 23:49:17  iio:trigger:interrupt fix formatting of rsize variable in name
git bisect good 3fb09d4ffa0622bfacaf82f24779e3250ce3abd2  #   123  2013-06-10 00:18:42  Merge remote-tracking branch 'iwlwifi-fixes/for-john' into devel-roam-i386-201306090958
git bisect good f0562289c37ff287a0267c95b81d8c86ace11551  #   123  2013-06-10 00:41:45  Merge remote-tracking branch 'iwlwifi-next/for-john' into devel-roam-i386-201306090958
git bisect  bad 2d8e8d692a41906e559ca310fcd1db617c26859e  #     0  2013-06-10 00:44:24  Merge remote-tracking branch 'linuxtv-media/fixes' into devel-roam-i386-201306090958
git bisect good 6d0745447f0535bad8a4e1e4cd0689e7979c8bff  #   123  2013-06-10 01:12:38  btrfs: set readdir f_pos only after filldir
git bisect good 3cf138a6393d4ae2aeabce4c4b776d7d15cce69b  #   123  2013-06-10 01:37:17  [media] exynos4-is: Prevent NULL pointer dereference when firmware isn't loaded
git bisect good 7952870342ce33d4d0b633c83d2a9f15d916281a  #   123  2013-06-10 02:00:31  Merge remote-tracking branch 'kbuild/for-next' into devel-roam-i386-201306090958
git bisect good 560dde24adfdc9dbcd141c75faecc5e0402fe531  #   123  2013-06-10 02:35:20  [media] v4l2-ioctl: don't print the clips list
git bisect good af44ad5edd1eb6ca92ed5be48e0004e1f04bf219  #   123  2013-06-10 02:54:51  [media] soc_camera: error dev remove and v4l2 call
git bisect  bad e6cb273732d7ff79b8bf2be02556d26b6d3b928d  #     0  2013-06-10 02:58:30  i386: mmap randomization for executable mappings
git bisect  bad bf400180b35912be07e8e22ddcb1e2b266b81067  #     0  2013-06-10 03:04:33  i386: NX emulation
git bisect good 29eb77825cc7da8d45b642de2de3d423dc8a363f  #   369  2013-06-10 03:55:00  arch, mm: Remove tlb_fast_mode()
git bisect  bad 03a188b29c8d5f332292e972a1d7eb1cd26d8109  #     0  2013-06-10 03:55:03  Merge remote-tracking branch 'linuxtv-media/master' into devel-roam-i386-201306090958
git bisect good e0d76190b217582321a602041318b3b88c195193  #   372  2013-06-10 04:50:38  Revert "i386: NX emulation"
git bisect good 317ddd256b9c24b0d78fa8018f80f1e495481a10  #   369  2013-06-10 05:23:19  Linux 3.10-rc5
git bisect good c04efed734409f5a44715b54a6ca1b54b0ccf215  #   369  2013-06-10 05:59:16  Add linux-next specific files for 20130607

Thanks,
Fengguang

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-ant-25539-20130609144605-3.10.0-rc5-01256-g03a188b-1"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.10.0-rc5-01256-g03a188b (kbuild@roam) (gcc version 4.7.2 (Debian 4.7.2-4) ) #1 Sun Jun 9 10:17:49 CST 2013
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled in hardware: non-PAE kernel!
[    0.000000] NX (Execute Disable) protection: approximated by x86 segment limits
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x100000
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped: [mem 0x00000000-0x01ffffff]
[    0.000000] Base memory trampoline at [c008f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
[    0.000000]  [mem 0x0e000000-0x0e3fffff] page 4k
[    0.000000] BRK [0x01b9e000, 0x01b9efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
[    0.000000]  [mem 0x08000000-0x0dffffff] page 4k
[    0.000000] BRK [0x01b9f000, 0x01b9ffff] PGTABLE
[    0.000000] BRK [0x01ba0000, 0x01ba0fff] PGTABLE
[    0.000000] BRK [0x01ba1000, 0x01ba1fff] PGTABLE
[    0.000000] BRK [0x01ba2000, 0x01ba2fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x07ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
[    0.000000]  [mem 0x0e400000-0x0fffdfff] page 4k
[    0.000000] cma: dma_contiguous_reserve(limit 00000000)
[    0.000000] cma: dma_contiguous_reserve: reserving 25 MiB for global area
[    0.000000] cma: dma_declare_contiguous(size 198e000, base 00000000, limit 00000000)
[    0.000000] cma: CMA: reserved 28 MiB at 0c400000
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128036(97%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 0ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65424
[    0.000000] free_area_init_node: node 0, pgdat c16136e0, node_mem_map ce4bf028
[    0.000000]   DMA zone: 40 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3986 pages, LIFO batch:0
[    0.000000]   Normal zone: 600 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] e820: [mem 0x10000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64784
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/i386-randconfig-r05-0609/linux-devel:devel-roam-i386-201306090958/.vmlinuz-03a188b29c8d5f332292e972a1d7eb1cd26d8109-20130609121223-6-ant branch=linux-devel/devel-roam-i386-201306090958 noapic nolapic nohz=off BOOT_IMAGE=/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/vmlinuz-3.10.0-rc5-01256-g03a188b
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 184540k/262136k available (3870k kernel code, 77156k reserved, 2371k data, 312k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe1000 - 0xfffff000   ( 120 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff7fe000   ( 752 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc1619000 - 0xc1667000   ( 312 kB)
[    0.000000]       .data : 0xc13c7a78 - 0xc16189f0   (2371 kB)
[    0.000000]       .text : 0xc1000000 - 0xc13c7a78   (3870 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=cb80e000 soft=cb810000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
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
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: Detected 3192.003 MHz processor
[    0.051087] Calibrating delay loop (skipped), value calculated using timer frequency.. 6386.00 BogoMIPS (lpj=10640010)
[    0.056881] pid_max: default: 32768 minimum: 301
[    0.132845] Mount-cache hash table entries: 512
[    0.365112] Initializing cgroup subsys devices
[    0.371368] Initializing cgroup subsys perf_event
[    0.417919] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.417919] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.417919] tlb_flushall_shift: -1
[    0.420314] CPU: AMD QEMU Virtual CPU version 1.1.2 (fam: 06, model: 02, stepping: 03)
[    0.530509] ACPI: Core revision 20130328
[    3.504417] ACPI: All ACPI Tables successfully acquired
[    3.506127] ACPI: setting ELCR to 0200 (from 0c00)
[    3.651004] Performance Events: Broken PMU hardware detected, using software events only.
[    3.660354] Failed to access perfctr msr (MSR c0010004 is 0)
[    3.837226] NMI watchdog: disabled (cpu0): hardware events not enabled
[    4.150714] atomic64 test passed for i386+ platform with CX8 and with SSE
[    4.373660] regulator-dummy: no parameters
[    4.412387] cma: cma_init_reserved_areas()
[    4.413801] cma: cma_create_area(base 0000c400, count 1c00)
[    4.441666] cma: cma_create_area: returned cb897d80
[    4.517589] NET: Registered protocol family 16
[    4.727743] ACPI: bus type PCI registered
[    4.750542] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=0
[    4.751861] PCI: Using configuration type 1 for base access
[    6.500868] ACPI: Added _OSI(Module Device)
[    6.502193] ACPI: Added _OSI(Processor Device)
[    6.503970] ACPI: Added _OSI(3.0 _SCP Extensions)
[    6.507160] ACPI: Added _OSI(Processor Aggregator Device)
[    6.730957] ACPI: EC: Look up EC in DSDT
[   13.980761] ACPI: Interpreter enabled
[   13.983940] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130328/hwxface-568)
[   13.990535] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130328/hwxface-568)
[   14.023753] ACPI: (supports S0 S3 S5)
[   14.024661] ACPI: Using PIC for interrupt routing
[   14.050900] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[   29.729999] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[   29.803333] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[   29.908914] PCI host bridge to bus 0000:00
[   29.914150] pci_bus 0000:00: root bus resource [bus 00-ff]
[   29.924947] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[   29.930409] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[   29.932156] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[   29.934062] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebfffff]
[   29.952839] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[   30.499181] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[   30.609267] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[   30.638553] pci 0000:00:01.1: reg 20: [io  0xc1e0-0xc1ef]
[   31.034269] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[   31.045673] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[   31.049852] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[   31.150539] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[   31.165005] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[   31.176989] pci 0000:00:02.0: reg 14: [mem 0xfebe0000-0xfebe0fff]
[   31.200391] pci 0000:00:02.0: reg 30: [mem 0xfebc0000-0xfebcffff pref]
[   31.288556] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[   31.300358] pci 0000:00:03.0: reg 10: [io  0xc1c0-0xc1df]
[   31.306936] pci 0000:00:03.0: reg 14: [mem 0xfebe1000-0xfebe1fff]
[   31.334911] pci 0000:00:03.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
[   31.467763] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[   31.474993] pci 0000:00:04.0: reg 10: [mem 0xfeb80000-0xfeb9ffff]
[   31.478303] pci 0000:00:04.0: reg 14: [io  0xc000-0xc03f]
[   31.513333] pci 0000:00:04.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
[   31.630741] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[   31.644853] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[   31.648353] pci 0000:00:05.0: reg 14: [mem 0xfebe2000-0xfebe2fff]
[   31.817067] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[   31.831646] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[   31.834906] pci 0000:00:06.0: reg 14: [mem 0xfebe3000-0xfebe3fff]
[   32.021313] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[   32.024927] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[   32.037009] pci 0000:00:07.0: reg 14: [mem 0xfebe4000-0xfebe4fff]
[   32.231362] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[   32.241742] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[   32.249999] pci 0000:00:08.0: reg 14: [mem 0xfebe5000-0xfebe5fff]
[   32.450454] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[   32.457033] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[   32.468306] pci 0000:00:09.0: reg 14: [mem 0xfebe6000-0xfebe6fff]
[   32.700261] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[   32.708338] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[   32.711574] pci 0000:00:0a.0: reg 14: [mem 0xfebe7000-0xfebe7fff]
[   32.929999] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[   32.933753] pci 0000:00:0b.0: reg 10: [mem 0xfebe8000-0xfebe800f]
[   33.151714] pci_bus 0000:00: on NUMA node 0
[   33.152814] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[   34.247284] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[   34.550343] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[   34.818161] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[   35.087837] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[   35.343881] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[   35.659999] ACPI: Enabled 16 GPEs in block 00 to 0F
[   35.670186] acpi root: \_SB_.PCI0 notify handler is installed
[   35.689002] Found 1 acpi root devices
[   35.926666] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[   35.934091] vgaarb: loaded
[   35.934784] vgaarb: bridge control possible 0000:00:02.0
[   36.250185] Linux video capture interface: v2.00
[   36.271287] pps_core: LinuxPPS API ver. 1 registered
[   36.272312] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[   36.378112] PCI: Using ACPI for IRQ routing
[   36.380264] PCI: pci_cache_line_size set to 64 bytes
[   36.394955] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[   36.404298] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[   36.725465] irda_init()
[   36.763865] NET: Registered protocol family 23
[   36.797095] NET: Registered protocol family 8
[   36.803818] NET: Registered protocol family 20
[   36.834422] Switching to clocksource hpet
[   36.932018] pnp: PnP ACPI init
[   36.953304] ACPI: bus type PNP registered
[   37.083286] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[   37.236283] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[   37.372964] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[   37.476158] pnp 00:03: [dma 2]
[   37.525428] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[   37.792713] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[   38.052367] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[   38.702180] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[   39.213199] pnp: PnP ACPI: found 7 devices
[   39.221239] ACPI: bus type PNP unregistered
[   39.721425] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[   39.722615] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[   39.731032] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[   39.732134] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[   39.745853] NET: Registered protocol family 1
[   39.751984] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[   39.753214] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[   39.762235] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[   39.771257] pci 0000:00:02.0: Boot video device
[   39.773067] PCI: CLS 0 bytes, default 64
[   39.971356] Unpacking initramfs...
[  351.027723] debug: unmapping init [mem 0xce73f000-0xcffeffff]
[  415.082995] DMA-API: preallocated 65536 debug entries
[  415.095891] DMA-API: debugging enabled by kernel config
[  415.292118] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[  415.299308] apm: overridden by ACPI.
[  415.940673] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[  416.892700] tsc: Refined TSC clocksource calibration: 3192.001 MHz
[  416.931845] Switching to clocksource tsc
[  426.478638] VFS: Disk quotas dquot_6.5.2
[  426.614745] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[  427.198779] msgmni has been set to 416
[  428.825199] alg: No test for crc32 (crc32-table)
[  428.978268] alg: No test for stdrng (krng)
[  429.082373] NET: Registered protocol family 38
[  429.441224] list_sort_test: start testing list_sort()
[  431.075436] hgafb: HGA card not detected.
[  431.098636] hgafb: probe of hgafb.0 failed with error -22
[  431.337193] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[  431.351536] ACPI: Power Button [PWRF]
[  433.052630] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[  433.237915] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[  434.115932] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
[  434.128444] platform pc8736x_gpio.0: no device found
[  434.248220] nsc_gpio initializing
[  434.257736] telclk_interrupt = 0xf non-mcpbl0010 hw.
[  434.284396] smapi::smapi_init, ERROR invalid usSmapiID
[  434.285489] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[  434.294357] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[  434.295624] mwave: mwavedd::mwave_init: Error: Failed to initialize
[  434.355590] SyncLink PC Card driver $Revision: 4.34 $, tty major#251
[  434.392855] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[  434.407767] Hangcheck: Using getrawmonotonic().
[  434.485191] dummy-irq: no IRQ given.  Use irq=N
[  434.802572] vcan: Virtual CAN interface driver
[  434.814585] CAN device driver interface
[  434.899497] w83977af_init()
[  434.903982] w83977af_open()
[  434.905266] w83977af_probe()
[  434.906152] w83977af_probe(), Wrong chip version
[  434.915525] w83977af_probe()
[  434.920293] w83977af_probe(), Wrong chip version
[  435.047619] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[  435.209383] serio: i8042 KBD port at 0x60,0x64 irq 1
[  435.231958] serio: i8042 AUX port at 0x60,0x64 irq 12
[  435.547975] mousedev: PS/2 mouse device common for all mice
[  435.692573] i2c /dev entries driver
[  435.910570] Driver for 1-wire Dallas network protocol.
[  436.022484] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[  436.230833] power_supply test_ac: uevent
[  436.231797] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
[  436.247453] power_supply test_ac: prop ONLINE=1
[  436.258803] power_supply test_ac: power_supply_changed
[  436.272403] power_supply test_ac: power_supply_changed_work
[  436.296221] power_supply test_ac: uevent
[  436.300656] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
[  436.302177] power_supply test_ac: prop ONLINE=1
[  436.377335] power_supply test_battery: uevent
[  436.378256] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
[  436.391377] power_supply test_battery: prop STATUS=Discharging
[  436.404062] power_supply test_battery: prop CHARGE_TYPE=Fast
[  436.406054] power_supply test_battery: prop HEALTH=Good
[  436.416173] power_supply test_battery: prop PRESENT=1
[  436.421311] power_supply test_battery: prop TECHNOLOGY=Li-ion
[  436.422767] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
[  436.432241] power_supply test_battery: prop CHARGE_FULL=100
[  436.441663] power_supply test_battery: prop CHARGE_NOW=50
[  436.454494] power_supply test_battery: prop CAPACITY=50
[  436.456046] power_supply test_battery: prop CAPACITY_LEVEL=Normal
[  436.468738] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
[  436.475582] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
[  436.488124] power_supply test_battery: prop MODEL_NAME=Test battery
[  436.494972] power_supply test_battery: prop MANUFACTURER=Linux
[  436.504362] power_supply test_battery: prop SERIAL_NUMBER=3.10.0-rc5-01256-g03a188b
[  436.514850] power_supply test_battery: prop TEMP=26
[  436.522822] power_supply test_battery: prop VOLTAGE_NOW=3300
[  436.742562] power_supply test_battery: power_supply_changed
[  436.755881] power_supply test_battery: power_supply_changed_work
[  436.771773] power_supply test_battery: uevent
[  436.772734] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
[  436.794905] power_supply test_battery: prop STATUS=Discharging
[  436.819471] power_supply test_battery: prop CHARGE_TYPE=Fast
[  436.844390] power_supply test_battery: prop HEALTH=Good
[  436.846058] power_supply test_battery: prop PRESENT=1
[  436.871449] power_supply test_battery: prop TECHNOLOGY=Li-ion
[  436.893754] power_supply test_usb: uevent
[  436.894581] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
[  436.902672] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
[  436.908609] power_supply test_usb: prop ONLINE=1
[  436.921451] power_supply test_battery: prop CHARGE_FULL=100
[  436.935111] power_supply test_battery: prop CHARGE_NOW=50
[  436.941630] power_supply test_usb: power_supply_changed
[  436.964913] power_supply test_battery: prop CAPACITY=50
[  436.981573] power_supply test_battery: prop CAPACITY_LEVEL=Normal
[  437.014497] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
[  437.016228] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
[  437.047618] power_supply test_battery: prop MODEL_NAME=Test battery
[  437.049426] power_supply test_battery: prop MANUFACTURER=Linux
[  437.115230] power_supply test_battery: prop SERIAL_NUMBER=3.10.0-rc5-01256-g03a188b
[  437.151250] power_supply test_battery: prop TEMP=26
[  437.164057] power_supply test_battery: prop VOLTAGE_NOW=3300
[  437.180379] power_supply test_usb: power_supply_changed_work
[  437.192201] power_supply test_usb: uevent
[  437.198900] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
[  437.225056] power_supply test_usb: prop ONLINE=1
[  438.030541] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input1
[  438.594821] advantechwdt: WDT driver for Advantech single board computer initialising
[  438.818481] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[  438.900390] advantechwdt: initialized. timeout=60 sec (nowayout=1)
[  438.914596] sc520_wdt: cannot register miscdev on minor=130 (err=-16)
[  438.932009] it87_wdt: no device
[  438.932874] pc87413_wdt: Version 1.1 at io 0x2E
[  438.944646] pc87413_wdt: cannot register miscdev on minor=130 (err=-16)
[  438.968448] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 initialising...
[  438.995672] smsc37b787_wdt: Unable to register miscdev on minor 130
[  438.998119] w83627hf_wdt: WDT driver for the Winbond(TM) W83627HF/THF/HG/DHG Super I/O chip initialising
[  439.008395] w83627hf_wdt: Watchdog already running. Resetting timeout to 60 sec
[  439.018066] w83627hf_wdt: cannot register miscdev on minor=130 (err=-16)
[  439.030854] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Super I/O chip initialising
[  439.042847] w83697ug_wdt: No W83697UG/UF could be found
[  439.046048] w83877f_wdt: I/O address 0x0443 already in use
[  439.055897] w83977f_wdt: driver v1.00
[  439.061028] w83977f_wdt: cannot register miscdev on minor=130 (err=-16)
[  439.062525] machzwd: MachZ ZF-Logic Watchdog driver initializing
[  439.074263] machzwd: no ZF-Logic found
[  439.115604] watchdog: Software Watchdog: cannot register miscdev on minor=130 (err=-16).
[  439.127881] watchdog: Software Watchdog: a legacy watchdog module is probably present.
[  439.192629] softdog: Software Watchdog Timer: 0.08 initialized. soft_noboot=0 soft_margin=60 sec soft_panic=0 (nowayout=1)
[  439.215721] cpuidle: using governor ladder
[  439.558287] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[  439.640271] goldfish_pdev_bus goldfish_pdev_bus: unable to reserve Goldfish MMIO.
[  439.664815] goldfish_pdev_bus: probe of goldfish_pdev_bus failed with error -16
[  440.209468] pktgen: Packet Generator for packet performance testing. Version: 2.74
[  440.308999] Mirror/redirect action on
[  440.322501] u32 classifier
[  440.330675]     Performance counters on
[  440.331512]     Actions configured
[  440.345285] can: controller area network core (rev 20120528 abi 9)
[  440.554237] NET: Registered protocol family 29
[  440.555667] can: raw protocol (rev 20120528)
[  440.567102] can: netlink gateway (rev 20130117) max_hops=1
[  441.045782] NET: Registered protocol family 35
[  441.408246] NET: Registered protocol family 37
[  442.219035] dmaengine: __dma_request_channel: fail ((null))
[  442.684575] debug: unmapping init [mem 0xc1619000-0xc1666fff]
[  442.715828] Write protecting the kernel text: 3872k
[  442.724722] Write protecting the kernel read-only data: 1948k
[  443.053460] BUG: unable to handle kernel paging request at c16561d0
[  443.053460] IP: [<c1105fb1>] load_elf_binary+0x2e1/0xdb0
[  443.053460] *pde = 01b9b067 *pte = 01656062 
[  443.053460] Oops: 0000 [#1] DEBUG_PAGEALLOC
[  443.053460] Modules linked in:
[  443.053460] CPU: 0 PID: 1 Comm: swapper Not tainted 3.10.0-rc5-01256-g03a188b #1
[  443.053460] task: cb868000 ti: cb862000 task.ti: cb862000
[  443.053460] EIP: 0060:[<c1105fb1>] EFLAGS: 00000246 CPU: 0
[  443.053460] EIP is at load_elf_binary+0x2e1/0xdb0
[  443.053460] EAX: 00000000 EBX: c47aae40 ECX: 00000000 EDX: c471f510
[  443.053460] ESI: c471f544 EDI: 00000000 EBP: cb863f14 ESP: cb863e98
[  443.053460]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[  443.053460] CR0: 8005003b CR2: c16561d0 CR3: 047ab000 CR4: 00000690
[  443.053460] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  443.053460] DR6: 00000000 DR7: 00000000
[  443.053460] Stack:
[  443.053460]  c471f510 00000080 c15cadb0 cb863ec4 00000002 c1003955 0000007b cb868000
[  443.053460]  00000000 00000001 00000000 00000000 000002e9 00000000 cb868000 c15ca6b8
[  443.053460]  00000001 cb863f08 00000246 c47199c0 00000246 cb9df780 c11058c0 c10d2a7a
[  443.053460] Call Trace:
[  443.053460]  [<c1003955>] ? do_IRQ+0x75/0x90
[  443.053460]  [<c11058c0>] ? bm_status_write+0xe0/0xe0
[  443.053460]  [<c10d2a7a>] ? search_binary_handler+0x32a/0x380
[  443.053460]  [<c1105cd0>] ? load_elf_library+0x1d0/0x1d0
[  443.053460]  [<c10d2a87>] search_binary_handler+0x337/0x380
[  443.053460]  [<c10d2778>] ? search_binary_handler+0x28/0x380
[  443.053460]  [<c10d3adf>] do_execve+0x4af/0x660
[  443.053460]  [<c10d3708>] ? do_execve+0xd8/0x660
[  443.053460]  [<c10000f7>] run_init_process+0x17/0x20
[  443.053460]  [<c13ba1b7>] kernel_init+0x37/0xf0
[  443.053460]  [<c13c6b1b>] ret_from_kernel_thread+0x1b/0x30
[  443.053460]  [<c13ba180>] ? rest_init+0x130/0x130
[  443.053460] Code: 00 00 eb 15 c7 45 d0 00 00 00 00 c7 45 d8 00 00 00 00 c7 45 e4 00 00 00 00 8b 45 f0 e8 59 cd fc ff 89 c7 85 c0 0f 85 a1 09 00 00 <83> 3d d0 61 65 c1 00 75 0f 83 7d e4 01 0f 85 1a 0a 00 00 e9 d7
[  443.053460] EIP: [<c1105fb1>] load_elf_binary+0x2e1/0xdb0 SS:ESP 0068:cb863e98
[  443.053460] CR2: 00000000c16561d0
[  443.053460] ---[ end trace 25e1f5808e99ed0b ]---
[  443.053460] BUG: sleeping function called from invalid context at /c/kernel-tests/src/linux/kernel/rwsem.c:20
[  443.053460] in_atomic(): 0, irqs_disabled(): 1, pid: 1, name: swapper
[  443.053460] INFO: lockdep is turned off.
[  443.053460] irq event stamp: 1801250
[  443.053460] hardirqs last  enabled at (1801249): [<c13c65b1>] restore_all_notrace+0x0/0x18
[  443.053460] hardirqs last disabled at (1801250): [<c13c68e9>] error_code+0x59/0x70
[  443.053460] softirqs last  enabled at (1801248): [<c10305fa>] __do_softirq+0x13a/0x160
[  443.053460] softirqs last disabled at (1801241): [<c103072a>] irq_exit+0x4a/0x70
[  443.053460] CPU: 0 PID: 1 Comm: swapper Tainted: G      D      3.10.0-rc5-01256-g03a188b #1
[  443.053460]  00000001 cb863c90 c13c0460 cb863cb8 c105155a c1520078 00000000 00000001
[  443.053460]  00000001 cb8682b0 cb864224 00000009 00000000 cb863cd4 c13c3e1a 00000024
[  443.053460]  00000006 c106d75b cb863d04 cb868000 cb863ce8 c1039679 00000000 cb863d14
[  443.053460] Call Trace:
[  443.053460]  [<c13c0460>] dump_stack+0x16/0x18
[  443.053460]  [<c105155a>] __might_sleep+0x1ca/0x1e0
[  443.053460]  [<c13c3e1a>] down_read+0x1a/0x5a
[  443.053460]  [<c106d75b>] ? trace_hardirqs_off+0xb/0x10
[  443.053460]  [<c1039679>] exit_signals+0x19/0x120
[  443.053460]  [<c102df64>] do_exit+0xa4/0x850
[  443.053460]  [<c102c227>] ? kmsg_dump+0x27/0x1f0
[  443.053460]  [<c102c3c0>] ? kmsg_dump+0x1c0/0x1f0
[  443.053460]  [<c102c3d4>] ? kmsg_dump+0x1d4/0x1f0
[  443.053460]  [<c102c227>] ? kmsg_dump+0x27/0x1f0
[  443.053460]  [<c1004c47>] oops_end+0x97/0xb0
[  443.053460]  [<c13bd4d7>] no_context+0x179/0x181
[  443.053460]  [<c106f3db>] ? trace_hardirqs_on+0xb/0x10
[  443.053460]  [<c13bd629>] __bad_area_nosemaphore+0x14a/0x152
[  443.053460]  [<c102ffbe>] ? __local_bh_enable+0x8e/0xb0
[  443.053460]  [<c1021100>] ? vmalloc_sync_all+0x160/0x160
[  443.053460]  [<c13bd643>] bad_area_nosemaphore+0x12/0x14
[  443.053460]  [<c1020f0e>] __do_page_fault+0x40e/0x4a0
[  443.053460]  [<c106d75b>] ? trace_hardirqs_off+0xb/0x10
[  443.053460]  [<c1003955>] ? do_IRQ+0x75/0x90
[  443.053460]  [<c115b240>] ? trace_hardirqs_on_thunk+0xc/0x10
[  443.053460]  [<c115b240>] ? trace_hardirqs_on_thunk+0xc/0x10
[  443.053460]  [<c13c65b1>] ? restore_all+0xf/0xf
[  443.053460]  [<c1021100>] ? vmalloc_sync_all+0x160/0x160
[  443.053460]  [<c1021108>] do_page_fault+0x8/0x10
[  443.053460]  [<c13c68ed>] error_code+0x5d/0x70
[  443.053460]  [<c1021100>] ? vmalloc_sync_all+0x160/0x160
[  443.053460]  [<c1105fb1>] ? load_elf_binary+0x2e1/0xdb0
[  443.053460]  [<c1003955>] ? do_IRQ+0x75/0x90
[  443.053460]  [<c11058c0>] ? bm_status_write+0xe0/0xe0
[  443.053460]  [<c10d2a7a>] ? search_binary_handler+0x32a/0x380
[  443.053460]  [<c1105cd0>] ? load_elf_library+0x1d0/0x1d0
[  443.053460]  [<c10d2a87>] search_binary_handler+0x337/0x380
[  443.053460]  [<c10d2778>] ? search_binary_handler+0x28/0x380
[  443.053460]  [<c10d3adf>] do_execve+0x4af/0x660
[  443.053460]  [<c10d3708>] ? do_execve+0xd8/0x660
[  443.053460]  [<c10000f7>] run_init_process+0x17/0x20
[  443.053460]  [<c13ba1b7>] kernel_init+0x37/0xf0
[  443.053460]  [<c13c6b1b>] ret_from_kernel_thread+0x1b/0x30
[  443.053460]  [<c13ba180>] ? rest_init+0x130/0x130
[  443.624656] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
[  443.624656] 
[  443.627558] Rebooting in 10 seconds..
BUG: kernel boot crashed
Elapsed time: 540

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="bisect-03a188b29c8d5f332292e972a1d7eb1cd26d8109-i386-randconfig-r05-0609-BUG:-unable-to-handle-kernel-paging-request-at-41404.log"

git checkout 317ddd256b9c24b0d78fa8018f80f1e495481a10
Previous HEAD position was 03a188b... Merge remote-tracking branch 'linuxtv-media/master' into devel-roam-i386-201306090958
HEAD is now at 317ddd2... Linux 3.10-rc5
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r05-0609/linux-devel:devel-roam-i386-201306090958:317ddd256b9c24b0d78fa8018f80f1e495481a10:bisect-linux-drm

2013-06-09-22:53:17 317ddd256b9c24b0d78fa8018f80f1e495481a10 reuse /kernel/i386-randconfig-r05-0609/317ddd256b9c24b0d78fa8018f80f1e495481a10/vmlinuz-3.10.0-rc5

2013-06-09-22:53:17 detecting boot state ..	11	12	13	14	19..	21	24	34.	39.	43	62	85	88.	91	109	119	120	121...............	122..............................	123 SUCCESS

bisect: good commit 317ddd256b9c24b0d78fa8018f80f1e495481a10
git bisect start 03a188b29c8d5f332292e972a1d7eb1cd26d8109 317ddd256b9c24b0d78fa8018f80f1e495481a10 --
Previous HEAD position was 317ddd2... Linux 3.10-rc5
HEAD is now at 3c0eee3... Linux 2.6.37
Bisecting: 714 revisions left to test after this (roughly 9 steps)
[78f304d06c47d600ec1a4b0995f1f4c5667a677e] iio:trigger:interrupt fix formatting of rsize variable in name
git bisect run /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/tip/obj-bisect
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/tip/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r05-0609/linux-devel:devel-roam-i386-201306090958:78f304d06c47d600ec1a4b0995f1f4c5667a677e:bisect-linux-drm

2013-06-09-23:29:44 78f304d06c47d600ec1a4b0995f1f4c5667a677e compiling
152 real  918 user  101 sys  667.22% cpu 	i386-randconfig-r05-0609

2013-06-09-23:32:40 detecting boot state 3.10.0-rc3-00541-g78f304d0..	1.	10	18	23	24	28	42	52	57	59.	62	64	72	76.	81	84	92	93	94	96	99	103	104	109	110	117	120	123 SUCCESS

Bisecting: 395 revisions left to test after this (roughly 9 steps)
[3fb09d4ffa0622bfacaf82f24779e3250ce3abd2] Merge remote-tracking branch 'iwlwifi-fixes/for-john' into devel-roam-i386-201306090958
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/tip/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r05-0609/linux-devel:devel-roam-i386-201306090958:3fb09d4ffa0622bfacaf82f24779e3250ce3abd2:bisect-linux-drm

2013-06-09-23:49:18 3fb09d4ffa0622bfacaf82f24779e3250ce3abd2 compiling
102 real  927 user  100 sys  1002.59% cpu 	i386-randconfig-r05-0609

2013-06-09-23:51:12 detecting boot state 3.10.0-rc5-00860-g3fb09d4....	1...	2	8	17	36	39	43	47.	48	54	59	60.	62	73	79...	81	84	93	96	98	100	106	118	122..................	123 SUCCESS

Bisecting: 229 revisions left to test after this (roughly 8 steps)
[f0562289c37ff287a0267c95b81d8c86ace11551] Merge remote-tracking branch 'iwlwifi-next/for-john' into devel-roam-i386-201306090958
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/tip/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r05-0609/linux-devel:devel-roam-i386-201306090958:f0562289c37ff287a0267c95b81d8c86ace11551:bisect-linux-drm

2013-06-10-00:18:43 f0562289c37ff287a0267c95b81d8c86ace11551 compiling
111 real  918 user  94 sys  906.93% cpu 	i386-randconfig-r05-0609

2013-06-10-00:20:45 detecting boot state 3.10.0-rc5-01026-gf056228...	3	6	7	11..	20	24	26.	27	34	43.	44.	47	68	72	74	77	82	103	121.............	122	123 SUCCESS

Bisecting: 114 revisions left to test after this (roughly 7 steps)
[2d8e8d692a41906e559ca310fcd1db617c26859e] Merge remote-tracking branch 'linuxtv-media/fixes' into devel-roam-i386-201306090958
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/tip/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r05-0609/linux-devel:devel-roam-i386-201306090958:2d8e8d692a41906e559ca310fcd1db617c26859e:bisect-linux-drm

2013-06-10-00:41:46 2d8e8d692a41906e559ca310fcd1db617c26859e compiling
115 real  912 user  92 sys  873.28% cpu 	i386-randconfig-r05-0609

2013-06-10-00:43:54 detecting boot state 3.10.0-rc5-01141-g2d8e8d6. TEST FAILURE
dmesg-kvm-waimea-27557-20130610004732-3.10.0-rc5-01141-g2d8e8d6-23

Bisecting: 57 revisions left to test after this (roughly 6 steps)
[6d0745447f0535bad8a4e1e4cd0689e7979c8bff] btrfs: set readdir f_pos only after filldir
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/tip/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r05-0609/linux-devel:devel-roam-i386-201306090958:6d0745447f0535bad8a4e1e4cd0689e7979c8bff:bisect-linux-drm

2013-06-10-00:44:29 6d0745447f0535bad8a4e1e4cd0689e7979c8bff compiling
107 real  923 user  94 sys  949.99% cpu 	i386-randconfig-r05-0609

2013-06-10-00:46:34 detecting boot state 3.9.0-00184-g6d07454..	7	16	27	30	32	38	46	56	65	66	70	81	87	92	101	109	113	120.............	121	122................	123 SUCCESS

Bisecting: 28 revisions left to test after this (roughly 5 steps)
[3cf138a6393d4ae2aeabce4c4b776d7d15cce69b] [media] exynos4-is: Prevent NULL pointer dereference when firmware isn't loaded
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/tip/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r05-0609/linux-devel:devel-roam-i386-201306090958:3cf138a6393d4ae2aeabce4c4b776d7d15cce69b:bisect-linux-drm

2013-06-10-01:12:40 3cf138a6393d4ae2aeabce4c4b776d7d15cce69b compiling
112 real  902 user  97 sys  889.94% cpu 	i386-randconfig-r05-0609

2013-06-10-01:14:46 detecting boot state 3.9.0-00867-g3cf138a...	2	18.	19	20	24	32	33	35	36	50	58	59.	61	69	80.	81.	82	89	90	92	99	107	109	110	119	121.........	122.	123 SUCCESS

Bisecting: 14 revisions left to test after this (roughly 4 steps)
[7952870342ce33d4d0b633c83d2a9f15d916281a] Merge remote-tracking branch 'kbuild/for-next' into devel-roam-i386-201306090958
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/tip/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r05-0609/linux-devel:devel-roam-i386-201306090958:7952870342ce33d4d0b633c83d2a9f15d916281a:bisect-linux-drm

2013-06-10-01:37:21 7952870342ce33d4d0b633c83d2a9f15d916281a compiling
113 real  934 user  98 sys  911.45% cpu 	i386-randconfig-r05-0609

2013-06-10-01:39:31 detecting boot state 3.10.0-rc5-01097-g7952870..	11	19..	20	27	34	35.	39.	41	51	53	56	57	60	69	73	77	78.	80	95	103	114.	118	120..........	123 SUCCESS

Bisecting: 7 revisions left to test after this (roughly 3 steps)
[560dde24adfdc9dbcd141c75faecc5e0402fe531] [media] v4l2-ioctl: don't print the clips list
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/tip/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r05-0609/linux-devel:devel-roam-i386-201306090958:560dde24adfdc9dbcd141c75faecc5e0402fe531:bisect-linux-drm

2013-06-10-02:00:35 560dde24adfdc9dbcd141c75faecc5e0402fe531 compiling
117 real  928 user  95 sys  875.37% cpu 	i386-randconfig-r05-0609

2013-06-10-02:02:50 detecting boot state 3.9.0-00874-g560dde2...	9	15	17	18..	26	29.	30.	38	40	41.	42	51	60...	64	74	79	83	86	87	100	103	110	115..	121	122..........................	123 SUCCESS

Bisecting: 3 revisions left to test after this (roughly 2 steps)
[af44ad5edd1eb6ca92ed5be48e0004e1f04bf219] [media] soc_camera: error dev remove and v4l2 call
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/tip/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r05-0609/linux-devel:devel-roam-i386-201306090958:af44ad5edd1eb6ca92ed5be48e0004e1f04bf219:bisect-linux-drm

2013-06-10-02:35:21 af44ad5edd1eb6ca92ed5be48e0004e1f04bf219 compiling
105 real  892 user  90 sys  928.22% cpu 	i386-randconfig-r05-0609

2013-06-10-02:37:21 detecting boot state 3.9.0-00878-gaf44ad5..	1.	6	9	12	13	16	33	50.	55	70	90	96	98	104	109	122..............	123 SUCCESS

Bisecting: 1 revision left to test after this (roughly 1 step)
[e6cb273732d7ff79b8bf2be02556d26b6d3b928d] i386: mmap randomization for executable mappings
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/tip/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r05-0609/linux-devel:devel-roam-i386-201306090958:e6cb273732d7ff79b8bf2be02556d26b6d3b928d:bisect-linux-drm

2013-06-10-02:54:54 e6cb273732d7ff79b8bf2be02556d26b6d3b928d compiling
108 real  941 user  97 sys  954.15% cpu 	i386-randconfig-r05-0609

2013-06-10-02:57:00 detecting boot state 3.10.0-rc4-00159-ge6cb273... TEST FAILURE
dmesg-kvm-waimea-28704-20130610030111-3.10.0-rc4-00159-ge6cb273-29

Bisecting: 0 revisions left to test after this (roughly 0 steps)
[bf400180b35912be07e8e22ddcb1e2b266b81067] i386: NX emulation
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/tip/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r05-0609/linux-devel:devel-roam-i386-201306090958:bf400180b35912be07e8e22ddcb1e2b266b81067:bisect-linux-drm

2013-06-10-02:58:31 bf400180b35912be07e8e22ddcb1e2b266b81067 compiling
109 real  909 user  92 sys  914.71% cpu 	i386-randconfig-r05-0609

2013-06-10-03:00:33 detecting boot state 3.10.0-rc4-00158-gbf40018........ TEST FAILURE
dmesg-kvm-vp-26388-20130610030613-3.10.0-rc4-00158-gbf40018-30

bf400180b35912be07e8e22ddcb1e2b266b81067 is the first bad commit
commit bf400180b35912be07e8e22ddcb1e2b266b81067
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Jul 14 00:50:02 2010 -0700

    i386: NX emulation
    
    This is old code with some cruft, all originally by Ingo Molnar with
    much later rebasing by Fedora folks and at least one arcane fix by
    Roland McGrath a few years ago. No longer uses exec-shield sysctl,
    merged with disable_nx. Kees Cook fixed boottime NX reporting for various
    corner cases.
    
    Signed-off-by: Kees Cook <kees.cook@canonical.com>

:040000 040000 40b3a25ca5a84c1499f9192061d5f741212a5f6c 2d6e2f4296f1f8334110976b33c01c7eadf82db3 M	arch
:040000 040000 550398a58b7826261676973f8f61c02b9e576ed9 8fc24e477623818343e57674997630946ffe6b8a M	fs
:040000 040000 a8718471f6fa303e8ce06c5cb67bde86b80b942a c30378f7d8a2f94be35e5aa8da3be934440938f8 M	include
:040000 040000 1ef5879b7b2169f11b0b7f4ea82f21cb517211fd cbe2c7a00860705c1dc5c84b5af4123cabe62339 M	mm
bisect run success
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r05-0609/linux-devel:devel-roam-i386-201306090958:29eb77825cc7da8d45b642de2de3d423dc8a363f:bisect-linux-drm

2013-06-10-03:04:35 29eb77825cc7da8d45b642de2de3d423dc8a363f compiling

2013-06-10-03:06:29 detecting boot state 3.10.0-rc4-00157-g29eb778...	1.	2	4	6.	8	14	15	24	28	31	35	36	41	45	46	52	54	55	58	64	66.	69	74	75	79	80.	82	85.	88	93	97	102	109	121.	123	128	130.	132	133	134	138	145	150	169	177	185	200	211	216	218	228	240	243	250	254	255	265	277	281	290	292	302	307	310	318	319	323	333	356	362	365	368..............	369 SUCCESS

ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r05-0609/linux-devel:devel-roam-i386-201306090958:03a188b29c8d5f332292e972a1d7eb1cd26d8109:bisect-linux-drm
 TEST FAILURE
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-ant-25539-20130609144605-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-athens-16566-20130609103050-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-athens-17740-20130609142342-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-athens-22863-20130609113715-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-athens-22863-20130609124152-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-athens-28071-20130609142706-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-athens-29231-20130609133415-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-athens-30226-20130609152243-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-athens-31396-20130609150756-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-athens-33303-20130609121205-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-athens-36513-20130609125404-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-athens-37459-20130609124617-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-athens-40194-20130609105111-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-athens-40194-20130609123505-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-athens-42104-20130609114900-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-bens-7545-20130609225135-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-bens-7838-20130609144536-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-bens-7838-20130609144613-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-cairo-1331-20130609133802-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-cairo-2888-20130609125056-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-cairo-4264-20130609132335-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-cairo-45075-20130609225246-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-cairo-47254-20130609114418-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-cairo-48496-20130609150136-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-cairo-49773-20130609142351-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-cairo-49826-20130609225245-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-cairo-52278-20130609225250-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-cairo-53368-20130609225250-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-cairo-53557-20130609121902-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-cairo-5565-20130609104058-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-cairo-5565-20130609133446-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-cairo-5565-20130609225249-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-cairo-57656-20130609151017-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-cairo-60613-20130609125345-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-cairo-61526-20130609122731-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-cairo-61526-20130609142052-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-cairo-6877-20130609105243-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-cairo-9920-20130609114341-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-inn-58752-20130609134505-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-inn-59786-20130609103535-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-inn-60618-20130609133454-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-inn-61472-20130609150756-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-inn-63292-20130609142858-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-inn-65002-20130609113901-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-kbuild-3352-20130609131829-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-kbuild-34988-20130609133126-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-kbuild-35087-20130609130438-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-kbuild-35288-20130609134320-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-kbuild-35321-20130609151039-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-kbuild-36657-20130609142412-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-kbuild-4882-20130609124431-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-kbuild-4882-20130609141948-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-kbuild-52119-20130609114651-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-kbuild-52119-20130609151246-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-kbuild-60163-20130609134240-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-kbuild-60163-20130609140702-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-kbuild-64981-20130609115742-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-roam-1005-20130609225258-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-roam-13414-20130609225257-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-roam-15882-20130609104846-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-roam-17983-20130609132529-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-roam-21616-20130609115014-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-roam-23533-20130609104530-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-roam-23533-20130609123627-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-roam-27037-20130609225251-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-roam-28220-20130609135309-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-roam-34541-20130609130408-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-roam-6702-20130609225255-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-snb-2166-20130609120438-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-snb-45298-20130609133228-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-snb-45298-20130609134916-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-snb-46605-20130609124319-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-snb-467-20130609130508-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-snb-48683-20130609121923-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-snb-48683-20130609124604-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-snb-51548-20130609115404-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-snb-51548-20130609123857-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-snb-53784-20130609102959-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-snb-55791-20130609112832-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-snb-57604-20130609143437-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-snb-59678-20130609225612-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-snb-60655-20130609144545-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-snb-61865-20130609113429-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-snb-62556-20130609225552-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-vp-26102-20130609150443-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-vp-26278-20130609125557-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-vp-26910-20130609113646-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-vp-27323-20130609103037-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-vp-27323-20130609114149-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-vp-27886-20130609123818-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-vp-27886-20130609144444-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-vp-28116-20130609144500-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-vp-28721-20130609143610-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-vp-30656-20130609132313-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-vp-30656-20130609135943-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-vp-31283-20130609112641-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-vp-31768-20130609122944-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-vp-32100-20130609133540-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-vp-33325-20130609114617-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-waimea-26234-20130609114636-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-waimea-26529-20130609151731-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-waimea-3282-20130609132929-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-waimea-3282-20130609152910-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-waimea-3671-20130609132021-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-waimea-3823-20130609114737-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-waimea-3823-20130609130702-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-waimea-3938-20130609141503-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-xgwo-20218-20130609133056-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-xgwo-24772-20130609140448-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-xian-50350-20130609113235-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-xian-50350-20130609121702-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-xian-50350-20130609133422-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-xian-50350-20130609142257-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-xian-51270-20130609134821-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-xian-52158-20130609124408-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-xian-5232-20130609114231-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-xian-57840-20130609134526-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-xian-60614-20130609121631-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-xian-64330-20130609120445-3.10.0-rc5-01256-g03a188b-1
/kernel/i386-randconfig-r05-0609/03a188b29c8d5f332292e972a1d7eb1cd26d8109/dmesg-kvm-xian-65125-20130609135147-3.10.0-rc5-01256-g03a188b-1

[detached HEAD e0d7619] Revert "i386: NX emulation"
 17 files changed, 5 insertions(+), 315 deletions(-)
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r05-0609/linux-devel:devel-roam-i386-201306090958:e0d76190b217582321a602041318b3b88c195193:bisect-linux-drm

2013-06-10-03:55:04 e0d76190b217582321a602041318b3b88c195193 compiling

2013-06-10-03:57:06 detecting boot state 3.10.0-rc5-01257-ge0d7619..	6	11........	12.........	13.	16.	17...	18	19......	23.............	24...........	25.	79	110	116..	122..	132..	169	171.	173	178	188	192	194	200	216	227.	229	234	239	240	246.	249	271	284	286	289	296	307	310	312	339	365	372 SUCCESS


========= upstream =========
Fetching linus
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r05-0609/linux-devel:devel-roam-i386-201306090958:317ddd256b9c24b0d78fa8018f80f1e495481a10:bisect-linux-drm

2013-06-10-04:50:48 317ddd256b9c24b0d78fa8018f80f1e495481a10 reuse /kernel/i386-randconfig-r05-0609/317ddd256b9c24b0d78fa8018f80f1e495481a10/vmlinuz-3.10.0-rc5

2013-06-10-04:50:48 detecting boot state ..	5	16.	17	30	43	59	63	64	68	69	70....	76	77	83	85	94	108	120	133	141	148	159	166	176	177.	181	188	196.	201	207	214	219	222	230	233	236	239	245	248.	251	254	263	281	295	301	314	322.	338	348	353	356	360	364	369 SUCCESS


========= linux-next =========
Fetching next
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-r05-0609/linux-devel:devel-roam-i386-201306090958:c04efed734409f5a44715b54a6ca1b54b0ccf215:bisect-linux-drm

2013-06-10-05:23:28 c04efed734409f5a44715b54a6ca1b54b0ccf215 compiling

2013-06-10-05:25:42 detecting boot state 3.10.0-rc4-next-20130607..	2	3	6	10	12	16	24	28	31	34	50	62	68	83	90	99	104	107	109.	133	137	146	148	167	179	187	188	191	200	208	213	215	223	245	267	290	291	293	298	308	334	344	355	364	367	368.................	369 SUCCESS


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.10.0-rc5 Kernel Configuration
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
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
CONFIG_KERNEL_LZMA=y
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
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
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_STALL_COMMON is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
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
CONFIG_RT_GROUP_SCHED=y
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
CONFIG_UIDGID_CONVERTED=y
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
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HOTPLUG=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
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
# CONFIG_SHMEM is not set
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
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
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
# CONFIG_GCOV_PROFILE_ALL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
# CONFIG_MODULE_UNLOAD is not set
CONFIG_MODVERSIONS=y
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
CONFIG_GOLDFISH=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_GOLDFISH=y
CONFIG_X86_WANT_INTEL_MID=y
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_RDC321X=y
CONFIG_X86_32_IRIS=m
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
CONFIG_LGUEST_GUEST=y
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
CONFIG_MELAN=y
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=4
CONFIG_X86_L1_CACHE_SHIFT=4
CONFIG_X86_ALIGNMENT_16=y
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
# CONFIG_DMI is not set
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
# CONFIG_X86_UP_APIC is not set
# CONFIG_X86_MCE is not set
# CONFIG_VM86 is not set
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
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
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
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
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
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
CONFIG_ACPI_I2C=y
CONFIG_ACPI_PROCESSOR=y
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
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
# CONFIG_APM_IGNORE_USER_SUSPEND is not set
CONFIG_APM_DO_ENABLE=y
# CONFIG_APM_CPU_IDLE is not set
# CONFIG_APM_DISPLAY_BLANK is not set
# CONFIG_APM_ALLOW_INTS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=m
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_ELAN_CPUFREQ=y
CONFIG_SC520_CPUFREQ=m
# CONFIG_X86_POWERNOW_K6 is not set
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K7_ACPI=y
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=m
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=m
CONFIG_X86_P4_CLOCKMOD=m
CONFIG_X86_CPUFREQ_NFORCE2=m
CONFIG_X86_LONGRUN=m
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
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
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
CONFIG_TS5500=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

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
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=m
CONFIG_XFRM_SUB_POLICY=y
# CONFIG_XFRM_MIGRATE is not set
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
# CONFIG_NETFILTER_ADVANCED is not set
CONFIG_ATM=y
CONFIG_ATM_LANE=m
CONFIG_MRP=m
# CONFIG_BRIDGE is not set
CONFIG_VLAN_8021Q=m
# CONFIG_VLAN_8021Q_GVRP is not set
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_DECNET=m
# CONFIG_DECNET_ROUTER is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
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
CONFIG_NET_SCH_ATM=y
CONFIG_NET_SCH_PRIO=m
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=y
# CONFIG_NET_SCH_SFB is not set
CONFIG_NET_SCH_SFQ=y
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=y
# CONFIG_NET_SCH_MQPRIO is not set
CONFIG_NET_SCH_CHOKE=y
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_CODEL is not set
CONFIG_NET_SCH_FQ_CODEL=y
# CONFIG_NET_SCH_INGRESS is not set
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
# CONFIG_NET_CLS_TCINDEX is not set
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=y
# CONFIG_NET_CLS_CGROUP is not set
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
# CONFIG_NET_ACT_GACT is not set
CONFIG_NET_ACT_MIRRED=y
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=y
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=m
CONFIG_NETLINK_MMAP=y
# CONFIG_NETLINK_DIAG is not set
CONFIG_NETPRIO_CGROUP=m
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
# CONFIG_CAN_BCM is not set
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
CONFIG_CAN_SLCAN=m
CONFIG_CAN_DEV=y
# CONFIG_CAN_CALC_BITTIMING is not set
# CONFIG_CAN_LEDS is not set
# CONFIG_CAN_MCP251X is not set
# CONFIG_PCH_CAN is not set
CONFIG_CAN_SJA1000=m
CONFIG_CAN_SJA1000_ISA=m
# CONFIG_CAN_SJA1000_PLATFORM is not set
CONFIG_CAN_EMS_PCMCIA=m
# CONFIG_CAN_EMS_PCI is not set
CONFIG_CAN_PEAK_PCMCIA=m
# CONFIG_CAN_PEAK_PCI is not set
# CONFIG_CAN_KVASER_PCI is not set
# CONFIG_CAN_PLX_PCI is not set
CONFIG_CAN_C_CAN=y
# CONFIG_CAN_C_CAN_PLATFORM is not set
# CONFIG_CAN_C_CAN_PCI is not set
CONFIG_CAN_CC770=m
CONFIG_CAN_CC770_ISA=m
CONFIG_CAN_CC770_PLATFORM=m
# CONFIG_CAN_SOFTING is not set
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

#
# FIR device drivers
#
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=m
CONFIG_ALI_FIR=m
# CONFIG_VLSI_FIR is not set
CONFIG_VIA_FIR=y
CONFIG_BT=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
# CONFIG_BT_BNEP_MC_FILTER is not set
CONFIG_BT_BNEP_PROTO_FILTER=y
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTSDIO=m
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIDTL1=m
CONFIG_BT_HCIBT3C=m
CONFIG_BT_HCIBLUECARD=m
# CONFIG_BT_HCIBTUART is not set
# CONFIG_BT_HCIVHCI is not set
CONFIG_BT_MRVL=m
# CONFIG_BT_MRVL_SDIO is not set
# CONFIG_BT_WILINK is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_NET_9P=m
CONFIG_NET_9P_VIRTIO=m
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=y
# CONFIG_CAIF_USB is not set
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
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
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
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y

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
# CONFIG_MTD is not set
CONFIG_PARPORT=m
# CONFIG_PARPORT_PC is not set
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
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=m
# CONFIG_AD525X_DPOT_I2C is not set
# CONFIG_AD525X_DPOT_SPI is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=m
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=y
CONFIG_DS1682=m
CONFIG_TI_DAC7512=m
CONFIG_VMWARE_BALLOON=y
CONFIG_BMP085=y
# CONFIG_BMP085_I2C is not set
CONFIG_BMP085_SPI=m
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=m
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
CONFIG_C2PORT=m
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=m
CONFIG_EEPROM_93XX46=m
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_VMWARE_VMCI is not set
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
# CONFIG_VHOST_NET is not set

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
# CONFIG_KEYBOARD_GOLDFISH_EVENTS is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TWL4030 is not set
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
# CONFIG_MOUSE_GPIO is not set
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
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
CONFIG_SERIO_PS2MULT=m
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=m
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
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
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
# CONFIG_N_HDLC is not set
CONFIG_N_GSM=m
# CONFIG_TRACE_SINK is not set
# CONFIG_GOLDFISH_TTY is not set
CONFIG_DEVKMEM=y
# CONFIG_STALDRV is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
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
CONFIG_SERIAL_MAX3100=m
CONFIG_SERIAL_MAX310X=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=y
CONFIG_SERIAL_SCCNXP_CONSOLE=y
CONFIG_SERIAL_TIMBERDALE=m
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_IFX6X60=m
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_R3964=m
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=y
CONFIG_MWAVE=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=m
# CONFIG_TCG_TIS_I2C_INFINEON is not set
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_ST33_I2C is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=m
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
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
# CONFIG_I2C_CBUS_GPIO is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_OCORES=m
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=m
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_STUB=m
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
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=m
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_LM70_LLP=m
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=m
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_XCOMM=m
CONFIG_SPI_XILINX=m
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
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=m
# CONFIG_PPS_CLIENT_GPIO is not set

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
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=m
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=m
CONFIG_GPIO_IT8761E=m
CONFIG_GPIO_TS5500=m
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=m
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_TPS65912=y
# CONFIG_GPIO_TWL4030 is not set
# CONFIG_GPIO_WM831X is not set
CONFIG_GPIO_WM8350=y
# CONFIG_GPIO_WM8994 is not set
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
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MCP23S08=y
# CONFIG_GPIO_MC33880 is not set
CONFIG_GPIO_74X164=y

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_PALMAS=y
CONFIG_GPIO_TPS6586X=y

#
# USB GPIO expanders:
#
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=m
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=m
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=m
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=m
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
CONFIG_GENERIC_ADC_BATTERY=m
# CONFIG_MAX8925_POWER is not set
CONFIG_WM831X_BACKUP=m
CONFIG_WM831X_POWER=m
# CONFIG_WM8350_POWER is not set
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2760=m
CONFIG_BATTERY_DS2780=y
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9030=y
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=m
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_PCF50633=m
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_TWL4030=m
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_SMB347=y
# CONFIG_BATTERY_GOLDFISH is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=m
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=y
# CONFIG_SENSORS_DA9052_ADC is not set
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_GPIO_FAN=y
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IIO_HWMON=y
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=m
CONFIG_SENSORS_LM73=m
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=y
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=m
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX16065=m
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_NCT6775 is not set
CONFIG_SENSORS_PC87360=m
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=m
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_WM831X is not set
# CONFIG_SENSORS_WM8350 is not set
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_MC13783_ADC=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_CPU_THERMAL is not set
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=m
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_DA9052_WATCHDOG=m
# CONFIG_DA9055_WATCHDOG is not set
CONFIG_WM831X_WATCHDOG=y
# CONFIG_WM8350_WATCHDOG is not set
CONFIG_TWL4030_WATCHDOG=m
CONFIG_RETU_WATCHDOG=m
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=m
# CONFIG_SP5100_TCO is not set
CONFIG_SC520_WDT=y
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=y
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
CONFIG_SC1200_WDT=m
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
CONFIG_RDC321X_WDT=y
# CONFIG_60XX_WDT is not set
CONFIG_SBC8360_WDT=m
# CONFIG_SBC7240_WDT is not set
CONFIG_CPU5_WDT=m
CONFIG_SMSC_SCH311X_WDT=m
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=m
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=m

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
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
# CONFIG_BCMA_HOST_PCI is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_CROS_EC is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=m
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_RETU=m
CONFIG_MFD_PCF50633=m
# CONFIG_PCF50633_ADC is not set
CONFIG_PCF50633_GPIO=m
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=m
CONFIG_TPS65010=m
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=m
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS65912_SPI is not set
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_MADC is not set
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=m
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_ARIZONA_SPI is not set
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=m
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_AAT2870=m
CONFIG_REGULATOR_DA903X=m
# CONFIG_REGULATOR_DA9052 is not set
CONFIG_REGULATOR_DA9055=y
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_ISL6271A=m
# CONFIG_REGULATOR_MAX1586 is not set
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=m
CONFIG_REGULATOR_MAX8925=m
CONFIG_REGULATOR_MAX8952=m
# CONFIG_REGULATOR_MAX8973 is not set
# CONFIG_REGULATOR_MAX77686 is not set
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=m
CONFIG_REGULATOR_PCF50633=m
# CONFIG_REGULATOR_S2MPS11 is not set
# CONFIG_REGULATOR_S5M8767 is not set
CONFIG_REGULATOR_PALMAS=y
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS6105X=m
CONFIG_REGULATOR_TPS62360=m
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65217=m
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_TPS6586X=y
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_TPS80031=y
CONFIG_REGULATOR_TWL4030=y
# CONFIG_REGULATOR_WM831X is not set
CONFIG_REGULATOR_WM8350=m
CONFIG_REGULATOR_WM8994=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_RC_SUPPORT is not set
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_V4L2_MEM2MEM_DEV=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_CONTIG=y
# CONFIG_VIDEO_V4L2_INT_DEVICE is not set
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
# CONFIG_MEDIA_PCI_SUPPORT is not set
CONFIG_V4L_PLATFORM_DRIVERS=y
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_VIDEO_TIMBERDALE is not set
# CONFIG_SOC_CAMERA is not set
CONFIG_V4L_MEM2MEM_DRIVERS=y
CONFIG_VIDEO_MEM2MEM_DEINTERLACE=y
CONFIG_VIDEO_SH_VEU=y
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_MEDIA_PARPORT_SUPPORT is not set
# CONFIG_RADIO_ADAPTERS is not set

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

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
# Miscelaneous helper chips
#

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MC44S803=y

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
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
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
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=m
CONFIG_FB_HGA=y
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
CONFIG_FB_TMIO=m
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_SM501=m
CONFIG_FB_GOLDFISH=m
CONFIG_FB_VIRTUAL=m
CONFIG_FB_METRONOME=m
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=m
CONFIG_FB_AUO_K1900=m
CONFIG_FB_AUO_K1901=m
CONFIG_EXYNOS_VIDEO=y
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
# CONFIG_LOGO_LINUX_CLUT224 is not set
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_SND is not set
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
# CONFIG_HID_PS3REMOTE is not set
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
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
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
CONFIG_MMC_UNSAFE_RESUME=y
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_GOLDFISH=y
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MEMSTICK=y
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
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA9633=m
CONFIG_LEDS_WM831X_STATUS=m
# CONFIG_LEDS_WM8350 is not set
CONFIG_LEDS_DA903X=m
CONFIG_LEDS_DA9052=m
CONFIG_LEDS_DAC124S085=m
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_MC13783=m
CONFIG_LEDS_TCA6507=m
CONFIG_LEDS_LM355x=y
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC=m
# CONFIG_DW_DMAC_BIG_ENDIAN_IO is not set
CONFIG_TIMB_DMA=y
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV is not set
CONFIG_UIO_PDRV_GENIRQ=m
CONFIG_UIO_DMEM_GENIRQ=m
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
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
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
CONFIG_DELL_LAPTOP=m
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_SAMSUNG_Q10=m
# CONFIG_APPLE_GMUX is not set
# CONFIG_PVPANIC is not set
CONFIG_GOLDFISH_PIPE=m

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
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
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
CONFIG_EXTCON_ADC_JACK=m
# CONFIG_EXTCON_MAX77693 is not set
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
# CONFIG_KXSD9 is not set
# CONFIG_IIO_ST_ACCEL_3AXIS is not set

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
CONFIG_AD7266=m
# CONFIG_AD7298 is not set
CONFIG_AD7923=m
CONFIG_AD7791=y
CONFIG_AD7793=y
CONFIG_AD7476=m
CONFIG_AD7887=y
CONFIG_MAX1363=m
# CONFIG_MCP320X is not set
CONFIG_TI_ADC081C=y
# CONFIG_TI_AM335X_ADC is not set

#
# Amplifiers
#
CONFIG_AD8366=m

#
# Hid Sensor IIO Common
#
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_SPI=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
CONFIG_AD5360=m
CONFIG_AD5380=y
CONFIG_AD5421=m
CONFIG_AD5624R_SPI=m
# CONFIG_AD5446 is not set
CONFIG_AD5449=y
CONFIG_AD5504=m
CONFIG_AD5755=m
CONFIG_AD5764=m
# CONFIG_AD5791 is not set
CONFIG_AD5686=m
CONFIG_MAX517=m
# CONFIG_MCP4725 is not set

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
CONFIG_ADF4350=m

#
# Digital gyroscope sensors
#
# CONFIG_ADIS16080 is not set
# CONFIG_ADIS16136 is not set
# CONFIG_ADXRS450 is not set
CONFIG_IIO_ST_GYRO_3AXIS=m
CONFIG_IIO_ST_GYRO_I2C_3AXIS=m
CONFIG_IIO_ST_GYRO_SPI_3AXIS=m
CONFIG_ITG3200=y

#
# Inertial measurement units
#
CONFIG_ADIS16400=m
CONFIG_ADIS16480=m
CONFIG_IIO_ADIS_LIB=m
CONFIG_IIO_ADIS_LIB_BUFFER=y
CONFIG_INV_MPU6050_IIO=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
# CONFIG_SENSORS_LM3533 is not set
CONFIG_SENSORS_TSL2563=m
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
CONFIG_AK8975=y
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
CONFIG_IIO_ST_MAGN_SPI_3AXIS=y

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=m
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure Sensors
#
# CONFIG_IIO_ST_PRESS is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=m
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=m
CONFIG_RESET_CONTROLLER=y

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
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=m
CONFIG_QFMT_V1=m
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_CUSE=m

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_SYSCTL is not set
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=m
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=m
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=m
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
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
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
CONFIG_TEST_LIST_SORT=y
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_MMC_REQUEST is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
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
# CONFIG_RBTREE_TEST is not set
CONFIG_INTERVAL_TREE_TEST=m
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_SET_MODULE_RONX=y
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
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_TRUSTED_KEYS=m
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
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set

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
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=m
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=m
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=m
CONFIG_PUBLIC_KEY_ALGO_RSA=m
CONFIG_X509_CERTIFICATE_PARSER=m
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
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
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
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_MPILIB=m
CONFIG_OID_REGISTRY=m
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_ATA_SFF is not set
# CONFIG_DRM_TTM is not set
# CONFIG_ISDN_DRV_LOOP is not set
# CONFIG_PCI_ATS is not set

--/04w6evG8XlLl3ft--
