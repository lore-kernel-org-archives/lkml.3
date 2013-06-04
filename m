Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658Ab3FDFXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 01:23:07 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:41001 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab3FDFWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 01:22:55 -0400
Date: Mon, 3 Jun 2013 22:22:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [bisect done] [    0.000000] WARNING: at mm/nobootmem.c:215
 ___alloc_bootmem_nopanic.constprop.5()
Message-ID: <20130604052240.GC11597@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130603105754.GA6595@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130603105754.GA6595@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060405-5518-0000-0000-00000F4E62C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 06:57:54PM +0800, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> commit 911af505ef407c2511106c224dd640f882f0f590
> Author: Paul E. McKenney <paul.mckenney@linaro.org>
> Date:   Mon Feb 11 10:23:27 2013 -0800

Hello, Fengguang,

This is now in mainline, as is the fix for this bug:

615ee544 (rcu: Don't allocate bootmem from rcu_init())

							Thanx, Paul

>     rcu: Provide compile-time control for no-CBs CPUs
>     
>     Currently, the only way to specify no-CBs CPUs is via the rcu_nocbs
>     kernel command-line parameter.  This is inconvenient in some cases,
>     particularly for randconfig testing, so this commit adds a new set of
>     kernel configuration parameters.  CONFIG_RCU_NOCB_CPU_NONE (the default)
>     retains the old behavior, CONFIG_RCU_NOCB_CPU_ZERO offloads callback
>     processing from CPU 0 (along with any other CPUs specified by the
>     rcu_nocbs boot-time parameter), and CONFIG_RCU_NOCB_CPU_ALL offloads
>     callback processing from all CPUs.
>     
>     Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000000] SLUB: HWalign=128, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] 
> [    0.000000] 
> [    0.000000] 
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at /c/kernel-tests/src/linux/mm/nobootmem.c:215 ___alloc_bootmem_nopanic.constprop.5+0x79/0x15f()
> [    0.000000] Modules linked in:
> [    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10.0-rc1-00035-g297e580 #40
> [    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [    0.000000]  00000000 00000000 c1a71ef8 c1588367 c1a71f20 c104d6d0 c199e148 c19b2567
> [    0.000000]  000000d7 c1cec5a5 c1cec5a5 00000001 00000001 00000000 c1a71f30 c104d709
> [    0.000000]  00000009 00000000 c1a71f64 c1cec5a5 00000000 00000000 00000000 c1ef260a
> [    0.000000] Call Trace:
> [    0.000000]  [<c1588367>] dump_stack+0x16/0x18
> [    0.000000]  [<c104d6d0>] warn_slowpath_common+0x74/0x8b
> [    0.000000]  [<c1cec5a5>] ? ___alloc_bootmem_nopanic.constprop.5+0x79/0x15f
> [    0.000000]  [<c1cec5a5>] ? ___alloc_bootmem_nopanic.constprop.5+0x79/0x15f
> [    0.000000]  [<c104d709>] warn_slowpath_null+0x22/0x24                     
> [    0.000000]  [<c1cec5a5>] ___alloc_bootmem_nopanic.constprop.5+0x79/0x15f
> [    0.000000]  [<c1cec699>] ___alloc_bootmem.constprop.4+0xe/0x49          
> [    0.000000]  [<c1583dc5>] ? printk+0x3d/0x3f                   
> [    0.000000]  [<c1cec859>] __alloc_bootmem+0x8/0xa
> [    0.000000]  [<c1cf4f03>] alloc_bootmem_cpumask_var+0x17/0x1c
> [    0.000000]  [<c1ce473b>] rcu_init+0xb9/0x309                
> [    0.000000]  [<c1ce7303>] ? perf_event_init+0x173/0x17a
> [    0.000000]  [<c1cc1aa7>] start_kernel+0x22d/0x453     
> [    0.000000]  [<c1cc14cd>] ? repair_env_string+0x97/0x97
> [    0.000000]  [<c1cc12da>] i386_start_kernel+0x90/0x94
> [    0.000000] ---[ end trace 5b01275a6144debd ]---
> 
> git bisect start 4237c09a63906b980741725da63f85e454caec02 v3.9 --
> git bisect  bad 73287a43cc79ca06629a88d1a199cd283f42456a  #     0  2013-06-03 15:02:18  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
> git bisect  bad 5d434fcb255dec99189f1c58a06e4f56e12bf77d  #     0  2013-06-03 15:08:57  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial
> git bisect good 507ffe4f3840ac24890a8123c702cf1b7fe4d33c  #    10  2013-06-03 15:21:41  Merge tag 'tty-3.10-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
> git bisect good 4a7b4d2360175f67ab2c58effeeb8362a3057c25  #    10  2013-06-03 15:28:44  x86: pageattr-test: remove srandom32 call
> git bisect good 46d9be3e5eb01f71fc02653755d970247174b400  #    10  2013-06-03 16:30:29  Merge branch 'for-3.10' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq
> git bisect  bad e0972916e8fe943f342b0dd1c9d43dbf5bc261c2  #     0  2013-06-03 16:34:11  Merge branch 'perf-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good 457d1772f1c1bcf37b2ae7fc8f1d6f303d1d5cf9  #    10  2013-06-03 16:52:58  uprobes/tracing: Generalize struct uprobe_trace_entry_head
> git bisect good 56847d857cb0c3ee78c22ce776a26f88d9ffd4d4  #    10  2013-06-03 17:45:40  Merge branch 'akpm' (incoming from Andrew)
> git bisect  bad 8fcfae31719c0a6c03f2cf63f815b46d378d8be4  #     0  2013-06-03 17:49:28  Merge branch 'rcu/next' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu into core/rcu
> git bisect  bad 8b425aa8f1acfe48aed919c7aadff2ed290fe969  #     0  2013-06-03 17:53:00  rcu: Rename n_nocb_gp_requests to need_future_gp
> git bisect  bad a488985851cf2facd2227bd982cc2c251df56268  #     0  2013-06-03 17:56:38  rcu: Distinguish "rcuo" kthreads by RCU flavor
> git bisect  bad dae6e64d2bcfd4b06304ab864c7e3a4f6b5fedf4  #     0  2013-06-03 18:00:10  rcu: Introduce proper blocking to no-CBs kthreads GP waits
> git bisect  bad 911af505ef407c2511106c224dd640f882f0f590  #     0  2013-06-03 18:03:42  rcu: Provide compile-time control for no-CBs CPUs
> git bisect good 34ed62461ae4970695974afb9a60ac3df0086830  #    10  2013-06-03 18:09:43  rcu: Remove restrictions on no-CBs CPUs
> git bisect good 34ed62461ae4970695974afb9a60ac3df0086830  #    38  2013-06-03 18:12:45  rcu: Remove restrictions on no-CBs CPUs
> git bisect  bad 297e5804fbed91ac58027d04e033540681763283  #     0  2013-06-03 18:13:19  exynos4-is: Add isp_dbg() macro
> git bisect good 6318c0ec14d5f7aea22987223e1a99dbda7b1fd0  #    30  2013-06-03 18:49:20  Add linux-next specific files for 20130603
> 
> Thanks,
> Fengguang

> [    0.000000] Linux version 3.10.0-rc1-00035-g297e580 (kbuild@snb) (gcc version 4.7.2 (Debian 4.7.2-4) ) #40 SMP Sat Jun 1 18:10:48 CST 2013
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] debug: ignoring loglevel setting.
> [    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
> [    0.000000] SMBIOS 2.4 present.
> [    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
> [    0.000000] Hypervisor detected: KVM
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x100000
> [    0.000000] MTRR default type: write-back
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
> [    0.000000]   1 disabled
> [    0.000000]   2 disabled
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
> [    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
> [    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
> [    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
> [    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at [c00fdab0]
> [    0.000000]   mpc: fdac0-fdbe4
> [    0.000000] Scanning 1 areas for low memory corruption
> [    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
> [    0.000000] Base memory trampoline at [c008f000] 8f000 size 16384
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
> [    0.000000]  [mem 0x0e000000-0x0e3fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
> [    0.000000]  [mem 0x08000000-0x0dffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
> [    0.000000]  [mem 0x00100000-0x003fffff] page 4k
> [    0.000000]  [mem 0x00400000-0x07ffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
> [    0.000000]  [mem 0x0e400000-0x0fbfffff] page 2M
> [    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
> [    0.000000] BRK [0x02370000, 0x02370fff] PGTABLE
> [    0.000000] cma: dma_contiguous_reserve(limit 00000000)
> [    0.000000] cma: dma_contiguous_reserve: reserving 16 MiB for global area
> [    0.000000] cma: dma_declare_contiguous(size 1000000, base 00000000, limit 00000000)
> [    0.000000] cma: CMA: reserved 16 MiB at 0d400000
> [    0.000000] log_buf_len: 8388608
> [    0.000000] early log buf free: 127712(97%)
> [    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
> [    0.000000] ACPI: RSDP 000fd920 00014 (v00 BOCHS )
> [    0.000000] ACPI: RSDT 0fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> [    0.000000] ACPI: DSDT 0fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
> [    0.000000] ACPI: FACS 0fffff40 00040
> [    0.000000] ACPI: SSDT 0ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: APIC 0ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> [    0.000000] ACPI: HPET 0ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
> [    0.000000] ACPI: SSDT 0ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to         ffffa000 (        fee00000)
> [    0.000000] 0MB HIGHMEM available.
> [    0.000000] 255MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 0fffe000
> [    0.000000]   low ram: 0 - 0fffe000
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
> [    0.000000] BRK [0x02371000, 0x02371fff] PGTABLE
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
> [    0.000000]   HighMem  empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x00092fff]
> [    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
> [    0.000000] On node 0 totalpages: 65424
> [    0.000000] free_area_init_node: node 0, pgdat c1b0ca00, node_mem_map ce53f020
> [    0.000000]   DMA zone: 32 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 3986 pages, LIFO batch:0
> [    0.000000]   Normal zone: 480 pages used for memmap
> [    0.000000]   Normal zone: 61438 pages, LIFO batch:15
> [    0.000000] Using APIC driver default
> [    0.000000] ACPI: PM-Timer IO Port: 0xb008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to         ffffa000 (        fee00000)
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC INT 05
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
> [    0.000000] ACPI: IRQ5 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] ACPI: IRQ10 used by override.
> [    0.000000] ACPI: IRQ11 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] mapped IOAPIC to ffff9000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on KVM
> [    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 333 pages/cpu @cc966000 s1342144 r0 d21824 u1363968
> [    0.000000] pcpu-alloc: s1342144 r0 d21824 u1363968 alloc=333*4096
> [    0.000000] pcpu-alloc: [0] 0 [0] 1 
> [    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
> [    0.000000] KVM setup async PF for cpu 0
> [    0.000000] kvm-stealtime: cpu 0, msr c9687c0
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64912
> [    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=linuxtv-samsung/for-next log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/i386-randconfig-s10-0601/linuxtv-samsung:for-next/.vmlinuz-2013-06-01-18-12-10-linuxtv-samsung:for-next:297e5804fbed91ac58027d04e033540681763283-297e5804fbed91ac58027d04e033540681763283-i386-randconfig-s10-0601-4-kbuild  BOOT_IMAGE=/kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/vmlinuz-3.10.0-rc1-00035-g297e580
> [    0.000000] sysrq: sysrq always enabled.
> [    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
> [    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
> [    0.000000] Initializing CPU#0
> [    0.000000] Initializing HighMem for node 0 (00000000:00000000)
> [    0.000000] Memory: 186904k/262136k available (5693k kernel code, 74792k reserved, 7365k data, 2040k init, 0k highmem)
> [    0.000000] virtual kernel memory layout:
> [    0.000000]     fixmap  : 0xffd34000 - 0xfffff000   (2860 kB)
> [    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
> [    0.000000]     vmalloc : 0xd07fe000 - 0xff7fe000   ( 752 MB)
> [    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
> [    0.000000]       .init : 0xc1cc1000 - 0xc1ebf000   (2040 kB)
> [    0.000000]       .data : 0xc158f61e - 0xc1cc0c00   (7365 kB)
> [    0.000000]       .text : 0xc1000000 - 0xc158f61e   (5693 kB)
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000000] SLUB: HWalign=128, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] 
> [    0.000000] 
> [    0.000000] 
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at /c/kernel-tests/src/linux/mm/nobootmem.c:215 ___alloc_bootmem_nopanic.constprop.5+0x79/0x15f()
> [    0.000000] Modules linked in:
> [    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10.0-rc1-00035-g297e580 #40
> [    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [    0.000000]  00000000 00000000 c1a71ef8 c1588367 c1a71f20 c104d6d0 c199e148 c19b2567
> [    0.000000]  000000d7 c1cec5a5 c1cec5a5 00000001 00000001 00000000 c1a71f30 c104d709
> [    0.000000]  00000009 00000000 c1a71f64 c1cec5a5 00000000 00000000 00000000 c1ef260a
> [    0.000000] Call Trace:
> [    0.000000]  [<c1588367>] dump_stack+0x16/0x18
> [    0.000000]  [<c104d6d0>] warn_slowpath_common+0x74/0x8b
> [    0.000000]  [<c1cec5a5>] ? ___alloc_bootmem_nopanic.constprop.5+0x79/0x15f
> [    0.000000]  [<c1cec5a5>] ? ___alloc_bootmem_nopanic.constprop.5+0x79/0x15f
> [    0.000000]  [<c104d709>] warn_slowpath_null+0x22/0x24
> [    0.000000]  [<c1cec5a5>] ___alloc_bootmem_nopanic.constprop.5+0x79/0x15f
> [    0.000000]  [<c1cec699>] ___alloc_bootmem.constprop.4+0xe/0x49
> [    0.000000]  [<c1583dc5>] ? printk+0x3d/0x3f
> [    0.000000]  [<c1cec859>] __alloc_bootmem+0x8/0xa
> [    0.000000]  [<c1cf4f03>] alloc_bootmem_cpumask_var+0x17/0x1c
> [    0.000000]  [<c1ce473b>] rcu_init+0xb9/0x309
> [    0.000000]  [<c1ce7303>] ? perf_event_init+0x173/0x17a
> [    0.000000]  [<c1cc1aa7>] start_kernel+0x22d/0x453
> [    0.000000]  [<c1cc14cd>] ? repair_env_string+0x97/0x97
> [    0.000000]  [<c1cc12da>] i386_start_kernel+0x90/0x94
> [    0.000000] ---[ end trace 5b01275a6144debd ]---
> [    0.000000] 
> [    0.000000] 
> [    0.000000] NR_IRQS:2304 nr_irqs:512 16
> [    0.000000] CPU 0 irqstacks, hard=cc41a000 soft=cc41c000
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] console [ttyS0] enabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
> [    0.000000] ... CHAINHASH_SIZE:          16384
> [    0.000000]  memory used by lock dependency info: 3807 kB
> [    0.000000]  per task-struct memory footprint: 1920 bytes
> [    0.000000] ------------------------
> [    0.000000] | Locking API testsuite:
> [    0.000000] ----------------------------------------------------------------------------
> [    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]                      A-A deadlock:failed|failed|  ok  |failed|failed|failed|
> [    0.000000]                  A-B-B-A deadlock:failed|failed|  ok  |failed|failed|failed|
> [    0.000000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |failed|failed|failed|
> [    0.000000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |failed|failed|failed|
> [    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
> [    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
> [    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
> [    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]               recursive read-lock:             |  ok  |             |failed|
> [    0.000000]            recursive read-lock #2:             |  ok  |             |failed|
> [    0.000000]             mixed read-write-lock:             |failed|             |failed|
> [    0.000000]             mixed write-read-lock:             |failed|             |failed|
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
> [    0.000000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
> [    0.000000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
> [    0.000000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
> [    0.000000]        sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
> [    0.000000]        sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
> [    0.000000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
> [    0.000000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
> [    0.000000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
> [    0.000000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
> [    0.000000]       hard-irq lock-inversion/123:failed|failed|  ok  |
> [    0.000000]       soft-irq lock-inversion/123:failed|failed|  ok  |
> [    0.000000]       hard-irq lock-inversion/132:failed|failed|  ok  |
> [    0.000000]       soft-irq lock-inversion/132:failed|failed|  ok  |
> [    0.000000]       hard-irq lock-inversion/213:failed|failed|  ok  |
> [    0.000000]       soft-irq lock-inversion/213:failed|failed|  ok  |
> [    0.000000]       hard-irq lock-inversion/231:failed|failed|  ok  |
> [    0.000000]       soft-irq lock-inversion/231:failed|failed|  ok  |
> [    0.000000]       hard-irq lock-inversion/312:failed|failed|  ok  |
> [    0.000000]       soft-irq lock-inversion/312:failed|failed|  ok  |
> [    0.000000]       hard-irq lock-inversion/321:failed|failed|  ok  |
> [    0.000000]       soft-irq lock-inversion/321:failed|failed|  ok  |
> [    0.000000]       hard-irq read-recursion/123:  ok  |
> [    0.000000]       soft-irq read-recursion/123:  ok  |
> [    0.000000]       hard-irq read-recursion/132:  ok  |
> [    0.000000]       soft-irq read-recursion/132:  ok  |
> [    0.000000]       hard-irq read-recursion/213:  ok  |
> [    0.000000]       soft-irq read-recursion/213:  ok  |
> [    0.000000]       hard-irq read-recursion/231:  ok  |
> [    0.000000]       soft-irq read-recursion/231:  ok  |
> [    0.000000]       hard-irq read-recursion/312:  ok  |
> [    0.000000]       soft-irq read-recursion/312:  ok  |
> [    0.000000]       hard-irq read-recursion/321:  ok  |
> [    0.000000]       soft-irq read-recursion/321:  ok  |
> [    0.000000] --------------------------------------------------------
> [    0.000000] 133 out of 218 testcases failed, as expected. |
> [    0.000000] ----------------------------------------------------
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Detected 2693.446 MHz processor
> [    0.020000] Calibrating delay loop (skipped) preset value.. 5386.89 BogoMIPS (lpj=26934460)
> [    0.020000] pid_max: default: 32768 minimum: 301
> [    0.020635] Mount-cache hash table entries: 512
> [    0.025187] mce: CPU supports 10 MCE banks
> [    0.027402] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.027402] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.027402] tlb_flushall_shift: 6
> [    0.030813] Freeing SMP alternatives: 8k freed
> [    0.041653] ACPI: Core revision 20130328
> [    0.134472] ACPI: All ACPI Tables successfully acquired
> [    0.138519] ftrace: allocating 20882 entries in 41 pages
> [    0.151032] Getting VERSION: 50014
> [    0.153887] Getting VERSION: 50014
> [    0.155599] Getting ID: 0
> [    0.157119] Getting ID: f000000
> [    0.158748] Getting LVT0: 8700
> [    0.160014] Getting LVT1: 8400
> [    0.161775] Enabling APIC mode:  Flat.  Using 1 I/O APICs
> [    0.164035] enabled ExtINT on CPU#0
> [    0.166920] ENABLING IO-APIC IRQs
> [    0.168603] init IO_APIC IRQs
> [    0.170010]  apic 2 pin 0 not connected
> [    0.171867] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
> [    0.175457] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
> [    0.180007] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
> [    0.183568] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
> [    0.187124] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
> [    0.190057] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
> [    0.193645] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
> [    0.197190] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
> [    0.200075] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
> [    0.203662] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
> [    0.207240] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
> [    0.210059] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
> [    0.213661] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
> [    0.217257] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
> [    0.220058] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
> [    0.223622]  apic 2 pin 16 not connected
> [    0.225422]  apic 2 pin 17 not connected
> [    0.230006]  apic 2 pin 18 not connected
> [    0.231823]  apic 2 pin 19 not connected
> [    0.233629]  apic 2 pin 20 not connected
> [    0.235437]  apic 2 pin 21 not connected
> [    0.237229]  apic 2 pin 22 not connected
> [    0.239032]  apic 2 pin 23 not connected
> [    0.240192] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.242903] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
> [    0.247544] Using local APIC timer interrupts.
> [    0.247544] calibrating APIC timer ...
> [    0.260000] ... lapic delta = 6251042
> [    0.260000] ... PM-Timer delta = 357954
> [    0.260000] ... PM-Timer result ok
> [    0.260000] ..... delta 6251042
> [    0.260000] ..... mult: 268480209
> [    0.260000] ..... calibration result: 10001667
> [    0.260000] ..... CPU clock speed is 2693.4993 MHz.
> [    0.260000] ..... host bus clock speed is 1000.1667 MHz.
> [    0.260109] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
> [    0.273912] NMI watchdog: disabled (cpu0): hardware events not enabled
> [    0.278620] SMP alternatives: lockdep: fixing up alternatives
> [    0.280042] CPU 1 irqstacks, hard=cc532000 soft=cc534000
> [    0.282670] smpboot: Booting Node   0, Processors  #1 OK
> [    0.010000] Initializing CPU#1
> [    0.020000] kvm-clock: cpu 1, msr 0:fffd041, secondary cpu clock
> [    0.020000] masked ExtINT on CPU#1
> [    0.320129] Brought up 2 CPUs
> [    0.320050] KVM setup async PF for cpu 1
> [    0.320050] kvm-stealtime: cpu 1, msr cab57c0
> [    0.325767] ----------------
> [    0.327449] | NMI testsuite:
> [    0.329133] --------------------
> [    0.330005]   remote IPI:  ok  |
> [    0.352380]    local IPI:  ok  |
> [    0.390427] --------------------
> [    0.393869] Good, all   2 testcases passed! |
> [    0.398178] ---------------------------------
> [    0.400007] smpboot: Total of 2 processors activated (10773.78 BogoMIPS)
> [    0.405567] CPU0 attaching sched-domain:
> [    0.408024]  domain 0: span 0-1 level CPU
> [    0.411640]   groups: 0 (cpu_power = 1023) 1
> [    0.414575] CPU1 attaching sched-domain:
> [    0.416733]  domain 0: span 0-1 level CPU
> [    0.419488]   groups: 1 0 (cpu_power = 1023)
> [    0.424130] device: 'platform': device_add
> [    0.427125] PM: Adding info for No Bus:platform
> [    0.430188] bus: 'platform': registered
> [    0.432223] bus: 'cpu': registered
> [    0.433944] device: 'cpu': device_add
> [    0.435942] PM: Adding info for No Bus:cpu
> [    0.441939] bus: 'workqueue': registered
> [    0.444014] device: 'workqueue': device_add
> [    0.446375] PM: Adding info for No Bus:workqueue
> [    0.459195] bus: 'virtio': registered
> [    0.460007] device class 'regulator': registering
> [    0.462357] Registering platform device 'reg-dummy'. Parent at platform
> [    0.464795] device: 'reg-dummy': device_add
> [    0.466769] bus: 'platform': add device reg-dummy
> [    0.470231] PM: Adding info for platform:reg-dummy
> [    0.472361] bus: 'platform': add driver reg-dummy
> [    0.474420] bus: 'platform': driver_probe_device: matched device reg-dummy with driver reg-dummy
> [    0.478203] bus: 'platform': really_probe: probing driver reg-dummy with device reg-dummy
> [    0.480164] device: 'regulator.0': device_add
> [    0.482524] PM: Adding info for No Bus:regulator.0
> [    0.484610] regulator-dummy: no parameters
> [    0.486669] driver: 'reg-dummy': driver_bound: bound to device 'reg-dummy'
> [    0.490020] bus: 'platform': really_probe: bound device reg-dummy to driver reg-dummy
> [    0.493860] cma: cma_init_reserved_areas()
> [    0.495749] cma: cma_create_area(base 0000d400, count 1000)
> [    0.498098] cma: cma_create_area: returned cc5b1300
> [    0.500641] NET: Registered protocol family 16
> [    0.503244] device class 'bdi': registering
> [    0.505208] bus: 'platform': add driver ramoops
> [    0.507377] device class 'pci_bus': registering
> [    0.510279] bus: 'pci': registered
> [    0.511972] device class 'video_output': registering
> [    0.514119] device class 'tty': registering
> [    0.516342] device class 'vtconsole': registering
> [    0.518469] device: 'vtcon0': device_add
> [    0.520213] PM: Adding info for No Bus:vtcon0
> [    0.522434] bus: 'platform': add driver sram
> [    0.524758] bus: 'platform': add driver syscon
> [    0.527139] bus: 'spi': registered
> [    0.530005] device class 'spi_master': registering
> [    0.532389] bus: 'hsi': registered
> [    0.534256] bus: 'i2c': registered
> [    0.535994] bus: 'i2c': add driver dummy
> [    0.538128] i2c-core: driver [dummy] registered
> [    0.540182] bus: 'eisa': registered
> [    0.541888] EISA bus registered
> [    0.544118] ACPI: bus type PCI registered
> [    0.545974] device class 'dma': registering
> [    0.548515] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=0
> [    0.550005] PCI: Using configuration type 1 for base access
> [    0.552484] device: 'cpu0': device_add
> [    0.554479] bus: 'cpu': add device cpu0
> [    0.556448] PM: Adding info for cpu:cpu0
> [    0.558540] device: 'cpu1': device_add
> [    0.560042] bus: 'cpu': add device cpu1
> [    0.562340] PM: Adding info for cpu:cpu1
> [    0.613794] device: 'writeback': device_add
> [    0.617473] bus: 'workqueue': add device writeback
> [    0.620285] PM: Adding info for workqueue:writeback
> [    0.624356] device: 'default': device_add
> [    0.628285] PM: Adding info for No Bus:default
> [    0.631018] bio: create slab <bio-0> at 0
> [    0.635552] device class 'block': registering
> [    0.640831] bus: 'i2c': add driver max732x
> [    0.644592] i2c-core: driver [max732x] registered
> [    0.650016] bus: 'spi': add driver mc33880
> [    0.653734] bus: 'spi': add driver mcp23s08
> [    0.657471] bus: 'i2c': add driver mcp230xx
> [    0.660205] i2c-core: driver [mcp230xx] registered
> [    0.664016] bus: 'i2c': add driver pcf857x
> [    0.667731] i2c-core: driver [pcf857x] registered
> [    0.670016] bus: 'platform': add driver stmpe-gpio
> [    0.674026] bus: 'i2c': add driver sx150x
> [    0.680192] i2c-core: driver [sx150x] registered
> [    0.683955] bus: 'platform': add driver tc3589x-gpio
> [    0.688063] bus: 'platform': add driver tps65912-gpio
> [    0.690194] bus: 'platform': add driver wm831x-gpio
> [    0.694236] bus: 'platform': add driver wm8350-gpio
> [    0.700585] ACPI: Added _OSI(Module Device)
> [    0.704218] ACPI: Added _OSI(Processor Device)
> [    0.707919] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.710051] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.723698] ACPI: EC: Look up EC in DSDT
> [    0.817121] ACPI: Interpreter enabled
> [    0.818940] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130328/hwxface-568)
> [    0.821423] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130328/hwxface-568)
> [    0.830177] ACPI: (supports S0 S3 S5)
> [    0.840005] ACPI: Using IOAPIC for interrupt routing
> [    0.842333] bus: 'acpi': registered
> [    0.844042] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
> [    0.850374] device: 'LNXSYSTM:00': device_add
> [    0.852316] bus: 'acpi': add device LNXSYSTM:00
> [    0.854397] PM: Adding info for acpi:LNXSYSTM:00
> [    0.860864] device: 'device:00': device_add
> [    0.862766] bus: 'acpi': add device device:00
> [    0.864813] PM: Adding info for acpi:device:00
> [    0.869226] device: 'PNP0A03:00': device_add
> [    0.870053] bus: 'acpi': add device PNP0A03:00
> [    0.872133] PM: Adding info for acpi:PNP0A03:00
> [    0.881855] device: 'device:01': device_add
> [    0.883767] bus: 'acpi': add device device:01
> [    0.885831] PM: Adding info for acpi:device:01
> [    0.889943] device: 'device:02': device_add
> [    0.890053] bus: 'acpi': add device device:02
> [    0.892114] PM: Adding info for acpi:device:02
> [    0.896220] device: 'PNP0B00:00': device_add
> [    0.900008] bus: 'acpi': add device PNP0B00:00
> [    0.902091] PM: Adding info for acpi:PNP0B00:00
> [    0.907102] device: 'PNP0303:00': device_add
> [    0.908996] bus: 'acpi': add device PNP0303:00
> [    0.910171] PM: Adding info for acpi:PNP0303:00
> [    0.915213] device: 'PNP0F13:00': device_add
> [    0.917147] bus: 'acpi': add device PNP0F13:00
> [    0.920195] PM: Adding info for acpi:PNP0F13:00
> [    0.925406] device: 'PNP0700:00': device_add
> [    0.927420] bus: 'acpi': add device PNP0700:00
> [    0.929595] PM: Adding info for acpi:PNP0700:00
> [    0.936773] device: 'PNP0400:00': device_add
> [    0.940057] bus: 'acpi': add device PNP0400:00
> [    0.942234] PM: Adding info for acpi:PNP0400:00
> [    0.951387] device: 'PNP0501:00': device_add
> [    0.954223] bus: 'acpi': add device PNP0501:00
> [    0.957818] PM: Adding info for acpi:PNP0501:00
> [    0.966701] device: 'device:03': device_add
> [    0.968945] bus: 'acpi': add device device:03
> [    0.970249] PM: Adding info for acpi:device:03
> [    0.974981] device: 'device:04': device_add
> [    0.977400] bus: 'acpi': add device device:04
> [    0.980198] PM: Adding info for acpi:device:04
> [    0.985064] device: 'device:05': device_add
> [    0.987377] bus: 'acpi': add device device:05
> [    0.990163] PM: Adding info for acpi:device:05
> [    0.994974] device: 'device:06': device_add
> [    0.997066] bus: 'acpi': add device device:06
> [    1.000163] PM: Adding info for acpi:device:06
> [    1.004947] device: 'device:07': device_add
> [    1.007004] bus: 'acpi': add device device:07
> [    1.009210] PM: Adding info for acpi:device:07
> [    1.012694] device: 'device:08': device_add
> [    1.014930] bus: 'acpi': add device device:08
> [    1.017154] PM: Adding info for acpi:device:08
> [    1.022683] device: 'device:09': device_add
> [    1.024720] bus: 'acpi': add device device:09
> [    1.026942] PM: Adding info for acpi:device:09
> [    1.032759] device: 'device:0a': device_add
> [    1.034818] bus: 'acpi': add device device:0a
> [    1.037076] PM: Adding info for acpi:device:0a
> [    1.041834] device: 'device:0b': device_add
> [    1.043877] bus: 'acpi': add device device:0b
> [    1.046113] PM: Adding info for acpi:device:0b
> [    1.050833] device: 'device:0c': device_add
> [    1.052885] bus: 'acpi': add device device:0c
> [    1.055105] PM: Adding info for acpi:device:0c
> [    1.059807] device: 'device:0d': device_add
> [    1.060054] bus: 'acpi': add device device:0d
> [    1.062279] PM: Adding info for acpi:device:0d
> [    1.066974] device: 'device:0e': device_add
> [    1.070055] bus: 'acpi': add device device:0e
> [    1.072286] PM: Adding info for acpi:device:0e
> [    1.076965] device: 'device:0f': device_add
> [    1.079009] bus: 'acpi': add device device:0f
> [    1.080359] PM: Adding info for acpi:device:0f
> [    1.085067] device: 'device:10': device_add
> [    1.087141] bus: 'acpi': add device device:10
> [    1.090197] PM: Adding info for acpi:device:10
> [    1.094912] device: 'device:11': device_add
> [    1.096942] bus: 'acpi': add device device:11
> [    1.100183] PM: Adding info for acpi:device:11
> [    1.104865] device: 'device:12': device_add
> [    1.106904] bus: 'acpi': add device device:12
> [    1.109093] PM: Adding info for acpi:device:12
> [    1.112631] device: 'device:13': device_add
> [    1.114711] bus: 'acpi': add device device:13
> [    1.116894] PM: Adding info for acpi:device:13
> [    1.122621] device: 'device:14': device_add
> [    1.124657] bus: 'acpi': add device device:14
> [    1.126866] PM: Adding info for acpi:device:14
> [    1.131883] device: 'device:15': device_add
> [    1.133935] bus: 'acpi': add device device:15
> [    1.136132] PM: Adding info for acpi:device:15
> [    1.140806] device: 'device:16': device_add
> [    1.142852] bus: 'acpi': add device device:16
> [    1.145072] PM: Adding info for acpi:device:16
> [    1.149721] device: 'device:17': device_add
> [    1.150055] bus: 'acpi': add device device:17
> [    1.152276] PM: Adding info for acpi:device:17
> [    1.157019] device: 'device:18': device_add
> [    1.160055] bus: 'acpi': add device device:18
> [    1.162295] PM: Adding info for acpi:device:18
> [    1.166994] device: 'device:19': device_add
> [    1.169038] bus: 'acpi': add device device:19
> [    1.170212] PM: Adding info for acpi:device:19
> [    1.175036] device: 'device:1a': device_add
> [    1.177077] bus: 'acpi': add device device:1a
> [    1.180209] PM: Adding info for acpi:device:1a
> [    1.184917] device: 'device:1b': device_add
> [    1.186961] bus: 'acpi': add device device:1b
> [    1.190210] PM: Adding info for acpi:device:1b
> [    1.194905] device: 'device:1c': device_add
> [    1.196951] bus: 'acpi': add device device:1c
> [    1.199136] PM: Adding info for acpi:device:1c
> [    1.202662] device: 'device:1d': device_add
> [    1.204711] bus: 'acpi': add device device:1d
> [    1.206942] PM: Adding info for acpi:device:1d
> [    1.212725] device: 'device:1e': device_add
> [    1.214822] bus: 'acpi': add device device:1e
> [    1.217081] PM: Adding info for acpi:device:1e
> [    1.222282] device: 'device:1f': device_add
> [    1.224380] bus: 'acpi': add device device:1f
> [    1.226619] PM: Adding info for acpi:device:1f
> [    1.231518] device: 'device:20': device_add
> [    1.233620] bus: 'acpi': add device device:20
> [    1.235865] PM: Adding info for acpi:device:20
> [    1.240762] device: 'device:21': device_add
> [    1.242856] bus: 'acpi': add device device:21
> [    1.245121] PM: Adding info for acpi:device:21
> [    1.249941] device: 'device:22': device_add
> [    1.250056] bus: 'acpi': add device device:22
> [    1.252325] PM: Adding info for acpi:device:22
> [    1.268027] device: 'PNP0103:00': device_add
> [    1.270075] bus: 'acpi': add device PNP0103:00
> [    1.272339] PM: Adding info for acpi:PNP0103:00
> [    1.281104] device: 'PNP0C0F:00': device_add
> [    1.283236] bus: 'acpi': add device PNP0C0F:00
> [    1.285501] PM: Adding info for acpi:PNP0C0F:00
> [    1.293587] device: 'PNP0C0F:01': device_add
> [    1.295709] bus: 'acpi': add device PNP0C0F:01
> [    1.297955] PM: Adding info for acpi:PNP0C0F:01
> [    1.305970] device: 'PNP0C0F:02': device_add
> [    1.308096] bus: 'acpi': add device PNP0C0F:02
> [    1.310179] PM: Adding info for acpi:PNP0C0F:02
> [    1.318333] device: 'PNP0C0F:03': device_add
> [    1.320055] bus: 'acpi': add device PNP0C0F:03
> [    1.322400] PM: Adding info for acpi:PNP0C0F:03
> [    1.331292] device: 'PNP0C0F:04': device_add
> [    1.333412] bus: 'acpi': add device PNP0C0F:04
> [    1.335681] PM: Adding info for acpi:PNP0C0F:04
> [    1.339891] device: 'LNXCPU:00': device_add
> [    1.340068] bus: 'acpi': add device LNXCPU:00
> [    1.342333] PM: Adding info for acpi:LNXCPU:00
> [    1.346471] device: 'LNXCPU:01': device_add
> [    1.350055] bus: 'acpi': add device LNXCPU:01
> [    1.352326] PM: Adding info for acpi:LNXCPU:01
> [    1.356659] device: 'device:23': device_add
> [    1.358752] bus: 'acpi': add device device:23
> [    1.360187] PM: Adding info for acpi:device:23
> [    1.362972] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    1.365931] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
> [    1.370008] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
> [    1.372760] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
> [    1.376544] acpi PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
> [    1.380048] PCI: root bus 00: using default resources
> [    1.382368] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
> [    1.387316] device: 'pci0000:00': device_add
> [    1.390269] PM: Adding info for No Bus:pci0000:00
> [    1.392513] device: '0000:00': device_add
> [    1.394933] PM: Adding info for No Bus:0000:00
> [    1.397187] PCI host bridge to bus 0000:00
> [    1.399245] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    1.400022] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
> [    1.402639] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
> [    1.405504] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
> [    1.410459] device: '0000:00:00.0': device_add
> [    1.433278] bus: 'pci': add device 0000:00:00.0
> [    1.435850] PM: Adding info for pci:0000:00:00.0
> [    1.438216] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
> [    1.440740] device: '0000:00:01.0': device_add
> [    1.443272] bus: 'pci': add device 0000:00:01.0
> [    1.445883] PM: Adding info for pci:0000:00:01.0
> [    1.448238] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
> [    1.452183] pci 0000:00:01.1: reg 20: [io  0xc1e0-0xc1ef]
> [    1.455515] device: '0000:00:01.1': device_add
> [    1.463488] bus: 'pci': add device 0000:00:01.1
> [    1.466943] PM: Adding info for pci:0000:00:01.1
> [    1.469064] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
> [    1.470922] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
> [    1.474801] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
> [    1.480199] device: '0000:00:01.3': device_add
> [    1.483452] bus: 'pci': add device 0000:00:01.3
> [    1.485879] PM: Adding info for pci:0000:00:01.3
> [    1.488180] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
> [    1.492782] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
> [    1.496625] pci 0000:00:02.0: reg 14: [mem 0xfebe0000-0xfebe0fff]
> [    1.506527] pci 0000:00:02.0: reg 30: [mem 0xfebc0000-0xfebcffff pref]
> [    1.510068] device: '0000:00:02.0': device_add
> [    1.512494] bus: 'pci': add device 0000:00:02.0
> [    1.515883] PM: Adding info for pci:0000:00:02.0
> [    1.519208] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
> [    1.521064] pci 0000:00:03.0: reg 10: [io  0xc1c0-0xc1df]
> [    1.525348] pci 0000:00:03.0: reg 14: [mem 0xfebe1000-0xfebe1fff]
> [    1.534417] pci 0000:00:03.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
> [    1.537305] device: '0000:00:03.0': device_add
> [    1.541054] bus: 'pci': add device 0000:00:03.0
> [    1.543464] PM: Adding info for pci:0000:00:03.0
> [    1.546367] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
> [    1.550776] pci 0000:00:04.0: reg 10: [mem 0xfeb80000-0xfeb9ffff]
> [    1.553781] pci 0000:00:04.0: reg 14: [io  0xc000-0xc03f]
> [    1.560714] pci 0000:00:04.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
> [    1.563467] device: '0000:00:04.0': device_add
> [    1.566374] bus: 'pci': add device 0000:00:04.0
> [    1.568746] PM: Adding info for pci:0000:00:04.0
> [    1.570201] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
> [    1.573351] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
> [    1.576230] pci 0000:00:05.0: reg 14: [mem 0xfebe2000-0xfebe2fff]
> [    1.583163] device: '0000:00:05.0': device_add
> [    1.586132] bus: 'pci': add device 0000:00:05.0
> [    1.588504] PM: Adding info for pci:0000:00:05.0
> [    1.590263] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
> [    1.593337] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
> [    1.596187] pci 0000:00:06.0: reg 14: [mem 0xfebe3000-0xfebe3fff]
> [    1.602815] device: '0000:00:06.0': device_add
> [    1.605882] bus: 'pci': add device 0000:00:06.0
> [    1.608262] PM: Adding info for pci:0000:00:06.0
> [    1.610192] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
> [    1.613260] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
> [    1.616113] pci 0000:00:07.0: reg 14: [mem 0xfebe4000-0xfebe4fff]
> [    1.622817] device: '0000:00:07.0': device_add
> [    1.625999] bus: 'pci': add device 0000:00:07.0
> [    1.628362] PM: Adding info for pci:0000:00:07.0
> [    1.630190] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
> [    1.633263] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
> [    1.636122] pci 0000:00:08.0: reg 14: [mem 0xfebe5000-0xfebe5fff]
> [    1.642428] device: '0000:00:08.0': device_add
> [    1.645730] bus: 'pci': add device 0000:00:08.0
> [    1.648091] PM: Adding info for pci:0000:00:08.0
> [    1.650208] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
> [    1.653282] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
> [    1.656140] pci 0000:00:09.0: reg 14: [mem 0xfebe6000-0xfebe6fff]
> [    1.662427] device: '0000:00:09.0': device_add
> [    1.665853] bus: 'pci': add device 0000:00:09.0
> [    1.668223] PM: Adding info for pci:0000:00:09.0
> [    1.670191] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
> [    1.673264] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
> [    1.676115] pci 0000:00:0a.0: reg 14: [mem 0xfebe7000-0xfebe7fff]
> [    1.682766] device: '0000:00:0a.0': device_add
> [    1.686285] bus: 'pci': add device 0000:00:0a.0
> [    1.688651] PM: Adding info for pci:0000:00:0a.0
> [    1.690156] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
> [    1.692848] pci 0000:00:0b.0: reg 10: [mem 0xfebe8000-0xfebe800f]
> [    1.697557] device: '0000:00:0b.0': device_add
> [    1.701729] bus: 'pci': add device 0000:00:0b.0
> [    1.704100] PM: Adding info for pci:0000:00:0b.0
> [    1.706379] pci_bus 0000:00: on NUMA node 0
> [    1.708267] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
> [    1.724317] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
> [    1.730600] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
> [    1.736820] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
> [    1.743086] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
> [    1.749149] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
> [    1.754911] device: 'LNXPWRBN:00': device_add
> [    1.756858] bus: 'acpi': add device LNXPWRBN:00
> [    1.758941] PM: Adding info for acpi:LNXPWRBN:00
> [    1.760571] ACPI: Enabled 16 GPEs in block 00 to 0F
> [    1.762867] acpi root: \_SB_.PCI0 notify handler is installed
> [    1.765265] Found 1 acpi root devices
> [    1.767004] bus: 'acpi': add driver ec
> [    1.770691] bus: 'pnp': registered
> [    1.772399] bus: 'platform': add driver dw_dmac
> [    1.774495] bus: 'platform': add driver reg-fixed-voltage
> [    1.776715] bus: 'platform': add driver 88pm860x-regulator
> [    1.779066] bus: 'platform': add driver as3711-regulator
> [    1.780129] bus: 'platform': add driver gpio-regulator
> [    1.782326] bus: 'platform': add driver lp8788-buck
> [    1.784493] bus: 'platform': add driver lp8788-dldo
> [    1.786655] bus: 'platform': add driver lp8788-aldo
> [    1.790103] bus: 'i2c': add driver lp8755-regulator
> [    1.792305] i2c-core: driver [lp8755-regulator] registered
> [    1.794493] bus: 'i2c': add driver tps62360
> [    1.796465] i2c-core: driver [tps62360] registered
> [    1.798486] bus: 'platform': add driver tps65912-pmic
> [    1.800113] bus: 'platform': add driver tps80031-pmic
> [    1.802867] bus: 'platform': add driver wm8350-regulator
> [    1.806078] device class 'misc': registering
> [    1.808275] device: 'vga_arbiter': device_add
> [    1.810287] PM: Adding info for No Bus:vga_arbiter
> [    1.812555] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> [    1.816061] vgaarb: loaded
> [    1.817708] vgaarb: bridge control possible 0000:00:02.0
> [    1.820136] bus: 'i2c': add driver 88PM860x
> [    1.822109] i2c-core: driver [88PM860x] registered
> [    1.824113] bus: 'i2c': add driver 88PM80X
> [    1.826076] i2c-core: driver [88PM80X] registered
> [    1.828059] bus: 'spi': add driver stmpe-spi
> [    1.830130] bus: 'i2c': add driver tc3589x
> [    1.832250] i2c-core: driver [tc3589x] registered
> [    1.834257] bus: 'i2c': add driver wm831x
> [    1.836182] i2c-core: driver [wm831x] registered
> [    1.838144] bus: 'i2c': add driver wm8350
> [    1.840117] i2c-core: driver [wm8350] registered
> [    1.842076] bus: 'i2c': add driver tps6105x
> [    1.844051] i2c-core: driver [tps6105x] registered
> [    1.846022] tps65010: version 2 May 2005
> [    1.847817] bus: 'i2c': add driver tps65010
> [    1.850118] i2c-core: driver [tps65010] registered
> [    1.852182] bus: 'i2c': remove driver tps65010
> [    1.854167] driver: 'tps65010': driver_release
> [    1.856117] i2c-core: driver [tps65010] unregistered
> [    1.870041] bus: 'i2c': add driver tps65010
> [    1.872793] i2c-core: driver [tps65010] registered
> [    1.874800] bus: 'i2c': remove driver tps65010
> [    1.877426] driver: 'tps65010': driver_release
> [    1.880034] i2c-core: driver [tps65010] unregistered
> [    1.900046] bus: 'i2c': add driver tps65010
> [    1.902676] i2c-core: driver [tps65010] registered
> [    1.905146] bus: 'i2c': remove driver tps65010
> [    1.907500] driver: 'tps65010': driver_release
> [    1.909758] i2c-core: driver [tps65010] unregistered
> [    1.910006] tps65010: no chip?
> [    1.911933] bus: 'spi': add driver tps65912
> [    1.914175] bus: 'i2c': add driver tps80031
> [    1.916480] i2c-core: driver [tps80031] registered
> [    1.920019] bus: 'i2c': add driver lp8788
> [    1.922474] i2c-core: driver [lp8788] registered
> [    1.924624] bus: 'i2c': add driver max77686
> [    1.926867] i2c-core: driver [max77686] registered
> [    1.930014] bus: 'i2c': add driver max77693
> [    1.932157] i2c-core: driver [max77693] registered
> [    1.934574] bus: 'i2c': add driver tps6586x
> [    1.936675] i2c-core: driver [tps6586x] registered
> [    1.938852] bus: 'i2c': add driver tps65090
> [    1.940132] i2c-core: driver [tps65090] registered
> [    1.942273] bus: 'i2c': add driver lm3533
> [    1.944671] i2c-core: driver [lm3533] registered
> [    1.946705] bus: 'i2c': add driver as3711
> [    1.948620] i2c-core: driver [as3711] registered
> [    1.950020] device class 'pcmcia_socket': registering
> [    1.952177] bus: 'platform': add driver usbmisc_imx
> [    1.954832] device class 'udc': registering
> [    1.957597] bus: 'serio': registered
> [    1.960258] bus: 'gameport': registered
> [    1.962507] device class 'input': registering
> [    1.965184] bus: 'platform': add driver i2c-gpio
> [    1.967335] device class 'pps': registering
> [    1.970110] pps_core: LinuxPPS API ver. 1 registered
> [    1.972188] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    1.976078] device class 'ptp': registering
> [    1.978324] PTP clock support registered
> [    1.980015] device class 'power_supply': registering
> [    1.990129] device class 'hwmon': registering
> [    2.000523] bus: 'mmc': registered
> [    2.002279] device class 'mmc_host': registering
> [    2.004486] bus: 'sdio': registered
> [    2.006205] device class 'leds': registering
> [    2.008224] device class 'sound': registering
> [    2.010495] Advanced Linux Sound Architecture Driver Initialized.
> [    2.012775] PCI: Using ACPI for IRQ routing
> [    2.014616] PCI: pci_cache_line_size set to 64 bytes
> [    2.017071] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
> [    2.020033] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
> [    2.023218] device class 'net': registering
> [    2.025373] device: 'lo': device_add
> [    2.027908] PM: Adding info for No Bus:lo
> [    2.031872] Switching to clocksource kvm-clock
> [    2.039049] Warning: could not register all branches stats
> [    2.040000] Warning: could not register annotated branches stats
> [    2.198266] FS-Cache: Loaded
> [    2.200326] bus: 'pnp': add driver system
> [    2.202529] pnp: PnP ACPI init
> [    2.204852] device: 'pnp0': device_add
> [    2.206832] PM: Adding info for No Bus:pnp0
> [    2.209151] ACPI: bus type PNP registered
> [    2.211628] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
> [    2.215556] device: '00:00': device_add
> [    2.217647] bus: 'pnp': add device 00:00
> [    2.220009] PM: Adding info for pnp:00:00
> [    2.222097] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    2.225803] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
> [    2.229589] device: '00:01': device_add
> [    2.231951] bus: 'pnp': add device 00:01
> [    2.234148] PM: Adding info for pnp:00:01
> [    2.236152] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
> [    2.239742] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
> [    2.243960] device: '00:02': device_add
> [    2.245978] bus: 'pnp': add device 00:02
> [    2.248094] PM: Adding info for pnp:00:02
> [    2.250154] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
> [    2.254184] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
> [    2.258002] pnp 00:03: [dma 2]
> [    2.259648] device: '00:03': device_add
> [    2.261701] bus: 'pnp': add device 00:03
> [    2.263905] PM: Adding info for pnp:00:03
> [    2.266520] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
> [    2.272437] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
> [    2.277200] device: '00:04': device_add
> [    2.279291] bus: 'pnp': add device 00:04
> [    2.281499] PM: Adding info for pnp:00:04
> [    2.283504] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
> [    2.288536] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
> [    2.292399] device: '00:05': device_add
> [    2.294508] bus: 'pnp': add device 00:05
> [    2.296909] PM: Adding info for pnp:00:05
> [    2.299163] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
> [    2.307249] device: '00:06': device_add
> [    2.309604] bus: 'pnp': add device 00:06
> [    2.311691] PM: Adding info for pnp:00:06
> [    2.313849] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
> [    2.322637] pnp: PnP ACPI: found 7 devices
> [    2.324771] ACPI: bus type PNP unregistered
> [    2.326989] device class 'mem': registering
> [    2.329034] device: 'mem': device_add
> [    2.331185] PM: Adding info for No Bus:mem
> [    2.333205] device: 'kmem': device_add
> [    2.335346] PM: Adding info for No Bus:kmem
> [    2.337622] device: 'null': device_add
> [    2.339657] PM: Adding info for No Bus:null
> [    2.341789] device: 'port': device_add
> [    2.343822] PM: Adding info for No Bus:port
> [    2.345901] device: 'zero': device_add
> [    2.348189] PM: Adding info for No Bus:zero
> [    2.350301] device: 'full': device_add
> [    2.352730] PM: Adding info for No Bus:full
> [    2.354931] device: 'random': device_add
> [    2.356940] PM: Adding info for No Bus:random
> [    2.359221] device: 'urandom': device_add
> [    2.361371] PM: Adding info for No Bus:urandom
> [    2.363959] device: 'kmsg': device_add
> [    2.366148] PM: Adding info for No Bus:kmsg
> [    2.368078] device: 'oldmem': device_add
> [    2.370494] PM: Adding info for No Bus:oldmem
> [    2.372492] device: 'tty': device_add
> [    2.375192] PM: Adding info for No Bus:tty
> [    2.377225] device: 'console': device_add
> [    2.379439] PM: Adding info for No Bus:console
> [    2.381783] device: 'tty0': device_add
> [    2.383923] PM: Adding info for No Bus:tty0
> [    2.386292] device class 'vc': registering
> [    2.388250] device: 'vcs': device_add
> [    2.390349] PM: Adding info for No Bus:vcs
> [    2.392711] device: 'vcsa': device_add
> [    2.394933] PM: Adding info for No Bus:vcsa
> [    2.397311] device: 'vcs1': device_add
> [    2.399399] PM: Adding info for No Bus:vcs1
> [    2.401536] device: 'vcsa1': device_add
> [    2.403801] PM: Adding info for No Bus:vcsa1
> [    2.405961] device: 'tty1': device_add
> [    2.408370] PM: Adding info for No Bus:tty1
> [    2.410377] device: 'tty2': device_add
> [    2.412455] PM: Adding info for No Bus:tty2
> [    2.414814] device: 'tty3': device_add
> [    2.416885] PM: Adding info for No Bus:tty3
> [    2.419238] device: 'tty4': device_add
> [    2.421357] PM: Adding info for No Bus:tty4
> [    2.423383] device: 'tty5': device_add
> [    2.425672] PM: Adding info for No Bus:tty5
> [    2.427642] device: 'tty6': device_add
> [    2.430086] PM: Adding info for No Bus:tty6
> [    2.432045] device: 'tty7': device_add
> [    2.434210] PM: Adding info for No Bus:tty7
> [    2.436528] device: 'tty8': device_add
> [    2.438716] PM: Adding info for No Bus:tty8
> [    2.441244] device: 'tty9': device_add
> [    2.443346] PM: Adding info for No Bus:tty9
> [    2.445530] device: 'tty10': device_add
> [    2.447682] PM: Adding info for No Bus:tty10
> [    2.449799] device: 'tty11': device_add
> [    2.452267] PM: Adding info for No Bus:tty11
> [    2.454463] device: 'tty12': device_add
> [    2.456606] PM: Adding info for No Bus:tty12
> [    2.458731] device: 'tty13': device_add
> [    2.460897] PM: Adding info for No Bus:tty13
> [    2.463243] device: 'tty14': device_add
> [    2.465428] PM: Adding info for No Bus:tty14
> [    2.467532] device: 'tty15': device_add
> [    2.469695] PM: Adding info for No Bus:tty15
> [    2.471804] device: 'tty16': device_add
> [    2.474362] PM: Adding info for No Bus:tty16
> [    2.476463] device: 'tty17': device_add
> [    2.478642] PM: Adding info for No Bus:tty17
> [    2.480754] device: 'tty18': device_add
> [    2.482895] PM: Adding info for No Bus:tty18
> [    2.485285] device: 'tty19': device_add
> [    2.487387] PM: Adding info for No Bus:tty19
> [    2.489514] device: 'tty20': device_add
> [    2.491653] PM: Adding info for No Bus:tty20
> [    2.493814] device: 'tty21': device_add
> [    2.496355] PM: Adding info for No Bus:tty21
> [    2.498436] device: 'tty22': device_add
> [    2.500570] PM: Adding info for No Bus:tty22
> [    2.502717] device: 'tty23': device_add
> [    2.504908] PM: Adding info for No Bus:tty23
> [    2.507210] device: 'tty24': device_add
> [    2.509340] PM: Adding info for No Bus:tty24
> [    2.511463] device: 'tty25': device_add
> [    2.513627] PM: Adding info for No Bus:tty25
> [    2.515810] device: 'tty26': device_add
> [    2.518322] PM: Adding info for No Bus:tty26
> [    2.520418] device: 'tty27': device_add
> [    2.522538] PM: Adding info for No Bus:tty27
> [    2.524690] device: 'tty28': device_add
> [    2.526890] PM: Adding info for No Bus:tty28
> [    2.529314] device: 'tty29': device_add
> [    2.531423] PM: Adding info for No Bus:tty29
> [    2.533556] device: 'tty30': device_add
> [    2.535723] PM: Adding info for No Bus:tty30
> [    2.537881] device: 'tty31': device_add
> [    2.540355] PM: Adding info for No Bus:tty31
> [    2.542505] device: 'tty32': device_add
> [    2.544703] PM: Adding info for No Bus:tty32
> [    2.546822] device: 'tty33': device_add
> [    2.548952] PM: Adding info for No Bus:tty33
> [    2.551107] device: 'tty34': device_add
> [    2.553262] PM: Adding info for No Bus:tty34
> [    2.555413] device: 'tty35': device_add
> [    2.557646] PM: Adding info for No Bus:tty35
> [    2.559794] device: 'tty36': device_add
> [    2.562666] PM: Adding info for No Bus:tty36
> [    2.564826] device: 'tty37': device_add
> [    2.566975] PM: Adding info for No Bus:tty37
> [    2.569091] device: 'tty38': device_add
> [    2.571264] PM: Adding info for No Bus:tty38
> [    2.573395] device: 'tty39': device_add
> [    2.575544] PM: Adding info for No Bus:tty39
> [    2.593757] device: 'tty40': device_add
> [    2.595944] PM: Adding info for No Bus:tty40
> [    2.598045] device: 'tty41': device_add
> [    2.600210] PM: Adding info for No Bus:tty41
> [    2.602315] device: 'tty42': device_add
> [    2.604491] PM: Adding info for No Bus:tty42
> [    2.606593] device: 'tty43': device_add
> [    2.608728] PM: Adding info for No Bus:tty43
> [    2.610846] device: 'tty44': device_add
> [    2.612965] PM: Adding info for No Bus:tty44
> [    2.615105] device: 'tty45': device_add
> [    2.617281] PM: Adding info for No Bus:tty45
> [    2.619382] device: 'tty46': device_add
> [    2.621663] PM: Adding info for No Bus:tty46
> [    2.623776] device: 'tty47': device_add
> [    2.626010] PM: Adding info for No Bus:tty47
> [    2.628163] device: 'tty48': device_add
> [    2.630305] PM: Adding info for No Bus:tty48
> [    2.632413] device: 'tty49': device_add
> [    2.634586] PM: Adding info for No Bus:tty49
> [    2.636736] device: 'tty50': device_add
> [    2.638868] PM: Adding info for No Bus:tty50
> [    2.640961] device: 'tty51': device_add
> [    2.643077] PM: Adding info for No Bus:tty51
> [    2.645264] device: 'tty52': device_add
> [    2.647364] PM: Adding info for No Bus:tty52
> [    2.649466] device: 'tty53': device_add
> [    2.651608] PM: Adding info for No Bus:tty53
> [    2.653713] device: 'tty54': device_add
> [    2.655882] PM: Adding info for No Bus:tty54
> [    2.657988] device: 'tty55': device_add
> [    2.660145] PM: Adding info for No Bus:tty55
> [    2.662303] device: 'tty56': device_add

> git checkout 4237c09a63906b980741725da63f85e454caec02
> Previous HEAD position was 297e580... exynos4-is: Add isp_dbg() macro
> HEAD is now at 4237c09... Merge tag 'v3.10-rc1' into patchwork
> 
> 2013-06-03-14:34:48 4237c09a63906b980741725da63f85e454caec02 reuse /kernel/i386-randconfig-s10-0601/4237c09a63906b980741725da63f85e454caec02/vmlinuz-3.10.0-rc1-00001-g4237c09
> 
> 2013-06-03-14:34:48 detecting boot state 	0 TEST FAILURE
> /kernel/i386-randconfig-s10-0601/4237c09a63906b980741725da63f85e454caec02/dmesg-kvm-inn-55311-2013-06-01-17-42-24-3.10.0-rc1-00001-g4237c09-39
> /kernel/i386-randconfig-s10-0601/4237c09a63906b980741725da63f85e454caec02/dmesg-kvm-kbuild-47719-2013-06-01-17-38-23-3.10.0-rc1-00001-g4237c09-39
> /kernel/i386-randconfig-s10-0601/4237c09a63906b980741725da63f85e454caec02/dmesg-kvm-xian-65125-2013-06-01-17-45-42-3.10.0-rc1-00001-g4237c09-39
> rm -fr /kernel-tests/run-queue/kvm/i386-randconfig-s10-0601/linuxtv-samsung:for-next:4237c09a63906b980741725da63f85e454caec02:bisect-stable /kernel-tests/run-queue/kvm/i386-randconfig-s10-0601/linuxtv-samsung:for-next:4237c09a63906b980741725da63f85e454caec02:bisect-stable-dmesg
> bisect: bad commit 4237c09a63906b980741725da63f85e454caec02
> git checkout v3.9
> Previous HEAD position was 4237c09... Merge tag 'v3.10-rc1' into patchwork
> HEAD is now at c1be5a5... Linux 3.9
> 
> 2013-06-03-14:35:22 c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1 compiling
> 144 real  1860 user  149 sys  1387.79% cpu 	i386-randconfig-s10-0601
> 
> 2013-06-03-14:38:04 detecting boot state 3.9.0	0.....	1..	2...................	4..	5	6	7.	9	10 SUCCESS
> rm -fr /kernel-tests/run-queue/kvm/i386-randconfig-s10-0601/linuxtv-samsung:for-next:c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1:bisect-stable /kernel-tests/run-queue/kvm/i386-randconfig-s10-0601/linuxtv-samsung:for-next:c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1:bisect-stable-dmesg
> bisect: good commit v3.9
> git bisect start 4237c09a63906b980741725da63f85e454caec02 v3.9 --
> Previous HEAD position was c1be5a5... Linux 3.9
> HEAD is now at 521cb40... Linux 2.6.38
> Bisecting: 5547 revisions left to test after this (roughly 13 steps)
> [73287a43cc79ca06629a88d1a199cd283f42456a] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
> git bisect run /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
> running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
> 
> 2013-06-03-14:57:30 73287a43cc79ca06629a88d1a199cd283f42456a compiling
> 234 real  1922 user  155 sys  885.82% cpu 	i386-randconfig-s10-0601
> 
> 2013-06-03-15:01:48 detecting boot state 3.9.0-07168-g73287a4	0 TEST FAILURE
> dmesg-kvm-inn-47998-2013-06-03-14-59-56-3.9.0-07168-g73287a4-30
> dmesg-kvm-inn-62403-2013-06-03-14-59-56-3.9.0-07168-g73287a4-30
> dmesg-kvm-xian-55155-2013-06-03-15-03-14-3.9.0-07168-g73287a4-30
> dmesg-kvm-athens-15558-2013-06-03-15-02-34-3.9.0-07168-g73287a4-30
> dmesg-kvm-athens-31396-2013-06-03-15-02-39-3.9.0-07168-g73287a4-30
> dmesg-kvm-snb-24489-2013-06-03-15-05-05-3.9.0-07168-g73287a4-30
> dmesg-kvm-waimea-3976-2013-06-03-15-05-05-3.9.0-07168-g73287a4-30
> dmesg-kvm-waimea-26426-2013-06-03-15-05-09-3.9.0-07168-g73287a4-30
> rm -fr /kernel-tests/run-queue/kvm/i386-randconfig-s10-0601/linuxtv-samsung:for-next:73287a43cc79ca06629a88d1a199cd283f42456a:bisect-stable /kernel-tests/run-queue/kvm/i386-randconfig-s10-0601/linuxtv-samsung:for-next:73287a43cc79ca06629a88d1a199cd283f42456a:bisect-stable-dmesg
> Bisecting: 3600 revisions left to test after this (roughly 12 steps)
> [5d434fcb255dec99189f1c58a06e4f56e12bf77d] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial
> running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
> 
> 2013-06-03-15:02:21 5d434fcb255dec99189f1c58a06e4f56e12bf77d compiling
> 179 real  1901 user  155 sys  1144.09% cpu 	i386-randconfig-s10-0601
> 
> 2013-06-03-15:08:27 detecting boot state 3.9.0-03567-g5d434fc	0 TEST FAILURE
> dmesg-kvm-kbuild-34988-2013-06-03-15-02-42-3.9.0-03567-g5d434fc-31
> rm -fr /kernel-tests/run-queue/kvm/i386-randconfig-s10-0601/linuxtv-samsung:for-next:5d434fcb255dec99189f1c58a06e4f56e12bf77d:bisect-stable /kernel-tests/run-queue/kvm/i386-randconfig-s10-0601/linuxtv-samsung:for-next:5d434fcb255dec99189f1c58a06e4f56e12bf77d:bisect-stable-dmesg
> Bisecting: 1989 revisions left to test after this (roughly 11 steps)
> [507ffe4f3840ac24890a8123c702cf1b7fe4d33c] Merge tag 'tty-3.10-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
> running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
> 
> 2013-06-03-15:09:02 507ffe4f3840ac24890a8123c702cf1b7fe4d33c compiling
> 474 real  1909 user  153 sys  435.02% cpu 	i386-randconfig-s10-0601
> 
> 2013-06-03-15:18:40 detecting boot state 3.9.0-01577-g507ffe4	0...	4	10 SUCCESS
> rm -fr /kernel-tests/run-queue/kvm/i386-randconfig-s10-0601/linuxtv-samsung:for-next:507ffe4f3840ac24890a8123c702cf1b7fe4d33c:bisect-stable /kernel-tests/run-queue/kvm/i386-randconfig-s10-0601/linuxtv-samsung:for-next:507ffe4f3840ac24890a8123c702cf1b7fe4d33c:bisect-stable-dmesg
> Bisecting: 994 revisions left to test after this (roughly 10 steps)
> [4a7b4d2360175f67ab2c58effeeb8362a3057c25] x86: pageattr-test: remove srandom32 call
> running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
> 
> 2013-06-03-15:21:43 4a7b4d2360175f67ab2c58effeeb8362a3057c25 compiling
> 182 real  1908 user  155 sys  1131.22% cpu 	i386-randconfig-s10-0601
> 
> 2013-06-03-15:25:13 detecting boot state 3.9.0-02572-g4a7b4d2	0...	7	8	10 SUCCESS
> rm -fr /kernel-tests/run-queue/kvm/i386-randconfig-s10-0601/linuxtv-samsung:for-next:4a7b4d2360175f67ab2c58effeeb8362a3057c25:bisect-stable /kernel-tests/run-queue/kvm/i386-randconfig-s10-0601/linuxtv-samsung:for-next:4a7b4d2360175f67ab2c58effeeb8362a3057c25:bisect-stable-dmesg
> Bisecting: 486 revisions left to test after this (roughly 9 steps)
> [46d9be3e5eb01f71fc02653755d970247174b400] Merge branch 'for-3.10' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq
> running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
> 
> 2013-06-03-15:28:45 46d9be3e5eb01f71fc02653755d970247174b400 compiling
> 178 real  1893 user  157 sys  1148.02% cpu 	i386-randconfig-s10-0601
> 
> 2013-06-03-15:31:58 detecting boot state 3.9.0-02811-g46d9be3	0...	5	8......	9.......................................................................................................	10 SUCCESS
> Bisecting: 249 revisions left to test after this (roughly 8 steps)
> [e0972916e8fe943f342b0dd1c9d43dbf5bc261c2] Merge branch 'perf-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
> 
> 2013-06-03-16:30:30 e0972916e8fe943f342b0dd1c9d43dbf5bc261c2 compiling
> 179 real  1920 user  154 sys  1153.82% cpu 	i386-randconfig-s10-0601
> 
> 2013-06-03-16:33:41 detecting boot state 3.9.0-03317-ge097291	0 TEST FAILURE
> dmesg-kvm-inn-57527-2013-06-03-16-32-00-3.9.0-03317-ge097291-35
> dmesg-kvm-inn-60618-2013-06-03-16-32-06-3.9.0-03317-ge097291-35
> dmesg-kvm-xian-8467-2013-06-03-16-35-16-3.9.0-03317-ge097291-35
> Bisecting: 118 revisions left to test after this (roughly 7 steps)
> [457d1772f1c1bcf37b2ae7fc8f1d6f303d1d5cf9] uprobes/tracing: Generalize struct uprobe_trace_entry_head
> running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
> 
> 2013-06-03-16:34:14 457d1772f1c1bcf37b2ae7fc8f1d6f303d1d5cf9 compiling
> 176 real  1888 user  153 sys  1160.03% cpu 	i386-randconfig-s10-0601
> 
> 2013-06-03-16:37:28 detecting boot state 3.9.0-rc2-00423-g457d177	0..	3	8	9........................	10 SUCCESS
> Bisecting: 55 revisions left to test after this (roughly 6 steps)
> [56847d857cb0c3ee78c22ce776a26f88d9ffd4d4] Merge branch 'akpm' (incoming from Andrew)
> running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
> 
> 2013-06-03-16:53:00 56847d857cb0c3ee78c22ce776a26f88d9ffd4d4 compiling
> 174 real  1916 user  155 sys  1189.65% cpu 	i386-randconfig-s10-0601
> 
> 2013-06-03-16:56:10 detecting boot state 3.9.0-03143-g56847d8	0......	1...........................	2.............................................................	4	10 SUCCESS
> Bisecting: 29 revisions left to test after this (roughly 5 steps)
> [8fcfae31719c0a6c03f2cf63f815b46d378d8be4] Merge branch 'rcu/next' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu into core/rcu
> running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
> 
> 2013-06-03-17:45:43 8fcfae31719c0a6c03f2cf63f815b46d378d8be4 compiling
> 178 real  1880 user  150 sys  1139.38% cpu 	i386-randconfig-s10-0601
> 
> 2013-06-03-17:48:58 detecting boot state 3.9.0-rc6-00069-g8fcfae3	0 TEST FAILURE
> dmesg-kvm-inn-756-2013-06-03-17-47-11-3.9.0-rc6-00069-g8fcfae3-38
> Bisecting: 12 revisions left to test after this (roughly 4 steps)
> [8b425aa8f1acfe48aed919c7aadff2ed290fe969] rcu: Rename n_nocb_gp_requests to need_future_gp
> running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
> 
> 2013-06-03-17:49:30 8b425aa8f1acfe48aed919c7aadff2ed290fe969 compiling
> 166 real  1886 user  148 sys  1219.22% cpu 	i386-randconfig-s10-0601
> 
> 2013-06-03-17:52:30 detecting boot state 3.9.0-rc2-00013-g8b425aa	0 TEST FAILURE
> dmesg-kvm-kbuild-4882-2013-06-03-17-46-40-3.9.0-rc2-00013-g8b425aa-39
> dmesg-kvm-roam-16987-2013-06-03-17-53-19-3.9.0-rc2-00013-g8b425aa-39
> dmesg-kvm-waimea-26426-2013-06-03-17-55-45-3.9.0-rc2-00013-g8b425aa-39
> Bisecting: 6 revisions left to test after this (roughly 3 steps)
> [a488985851cf2facd2227bd982cc2c251df56268] rcu: Distinguish "rcuo" kthreads by RCU flavor
> running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
> 
> 2013-06-03-17:53:02 a488985851cf2facd2227bd982cc2c251df56268 compiling
> 173 real  1844 user  148 sys  1146.36% cpu 	i386-randconfig-s10-0601
> 
> 2013-06-03-17:56:08 detecting boot state 3.9.0-rc2-00006-ga488985	0 TEST FAILURE
> dmesg-kvm-cairo-48496-2013-06-03-17-57-29-3.9.0-rc2-00006-ga488985-40
> dmesg-kvm-vp-30656-2013-06-03-17-58-48-3.9.0-rc2-00006-ga488985-40
> Bisecting: 2 revisions left to test after this (roughly 2 steps)
> [dae6e64d2bcfd4b06304ab864c7e3a4f6b5fedf4] rcu: Introduce proper blocking to no-CBs kthreads GP waits
> running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
> 
> 2013-06-03-17:56:40 dae6e64d2bcfd4b06304ab864c7e3a4f6b5fedf4 compiling
> 167 real  1861 user  145 sys  1202.08% cpu 	i386-randconfig-s10-0601
> 
> 2013-06-03-17:59:40 detecting boot state 3.9.0-rc2-00003-gdae6e64	0 TEST FAILURE
> dmesg-kvm-vp-26910-2013-06-03-18-02-16-3.9.0-rc2-00003-gdae6e64-41
> Bisecting: 0 revisions left to test after this (roughly 1 step)
> [911af505ef407c2511106c224dd640f882f0f590] rcu: Provide compile-time control for no-CBs CPUs
> running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
> 
> 2013-06-03-18:00:11 911af505ef407c2511106c224dd640f882f0f590 compiling
> 167 real  1880 user  148 sys  1209.35% cpu 	i386-randconfig-s10-0601
> 
> 2013-06-03-18:03:12 detecting boot state 3.9.0-rc2-00002-g911af50	0 TEST FAILURE
> dmesg-kvm-inn-47043-2013-06-03-18-01-29-3.9.0-rc2-00002-g911af50-42
> dmesg-kvm-xian-57097-2013-06-03-18-04-47-3.9.0-rc2-00002-g911af50-42
> Bisecting: 0 revisions left to test after this (roughly 0 steps)
> [34ed62461ae4970695974afb9a60ac3df0086830] rcu: Remove restrictions on no-CBs CPUs
> running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect
> 
> 2013-06-03-18:03:43 34ed62461ae4970695974afb9a60ac3df0086830 compiling
> 166 real  1852 user  147 sys  1204.75% cpu 	i386-randconfig-s10-0601
> 
> 2013-06-03-18:06:43 detecting boot state 3.9.0-rc2-00001-g34ed6246	0..	7	9	10 SUCCESS
> 911af505ef407c2511106c224dd640f882f0f590 is the first bad commit
> commit 911af505ef407c2511106c224dd640f882f0f590
> Author: Paul E. McKenney <paul.mckenney@linaro.org>
> Date:   Mon Feb 11 10:23:27 2013 -0800
> 
>     rcu: Provide compile-time control for no-CBs CPUs
>     
>     Currently, the only way to specify no-CBs CPUs is via the rcu_nocbs
>     kernel command-line parameter.  This is inconvenient in some cases,
>     particularly for randconfig testing, so this commit adds a new set of
>     kernel configuration parameters.  CONFIG_RCU_NOCB_CPU_NONE (the default)
>     retains the old behavior, CONFIG_RCU_NOCB_CPU_ZERO offloads callback
>     processing from CPU 0 (along with any other CPUs specified by the
>     rcu_nocbs boot-time parameter), and CONFIG_RCU_NOCB_CPU_ALL offloads
>     callback processing from all CPUs.
>     
>     Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> :040000 040000 f31eb6019851f4b5b62c9cd601dbf4b6373a325b 3147b61df34103ec2ec67bc19b683bd00d262911 M	init
> :040000 040000 741cfcf516c3da43d946d8a9c6b90b4e0f733cef a1ceda8303d1c283479c4dd7166b46522df5089b M	kernel
> bisect run success
> 
> 2013-06-03-18:09:45 34ed62461ae4970695974afb9a60ac3df0086830 reuse /kernel/i386-randconfig-s10-0601/34ed62461ae4970695974afb9a60ac3df0086830/vmlinuz-3.9.0-rc2-00001-g34ed6246
> 
> 2013-06-03-18:09:45 detecting boot state 	10..	16	28	38 SUCCESS
> 
> 2013-06-03-18:12:49 297e5804fbed91ac58027d04e033540681763283 reuse /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/vmlinuz-3.10.0-rc1-00035-g297e580
> 
> 2013-06-03-18:12:49 detecting boot state 	0 TEST FAILURE
> /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/dmesg-kvm-athens-30226-2013-06-03-14-44-28-3.10.0-rc1-00035-g297e580-40
> /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/dmesg-kvm-athens-32310-2013-06-03-14-36-42-3.10.0-rc1-00035-g297e580-40
> /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/dmesg-kvm-athens-44751-2013-06-03-14-55-24-3.10.0-rc1-00035-g297e580-40
> /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/dmesg-kvm-bay-28541-2013-06-03-14-41-41-3.10.0-rc1-00035-g297e580-40
> /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/dmesg-kvm-bens-7956-2013-06-03-14-53-29-3.10.0-rc1-00035-g297e580-40
> /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/dmesg-kvm-inn-2539-2013-06-03-14-47-50-3.10.0-rc1-00035-g297e580-40
> /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/dmesg-kvm-kbuild-1567-2013-06-01-18-03-22-3.10.0-rc1-00035-g297e580-40
> /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/dmesg-kvm-roam-23533-2013-06-03-14-55-54-3.10.0-rc1-00035-g297e580-40
> /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/dmesg-kvm-roam-28220-2013-06-03-14-54-54-3.10.0-rc1-00035-g297e580-40
> /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/dmesg-kvm-snb-28902-2013-06-03-14-50-16-3.10.0-rc1-00035-g297e580-40
> /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/dmesg-kvm-snb-30380-2013-06-03-14-55-57-3.10.0-rc1-00035-g297e580-40
> /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/dmesg-kvm-snb-3369-2013-06-01-18-12-25-3.10.0-rc1-00035-g297e580-40
> /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/dmesg-kvm-snb-3369-2013-06-03-14-58-45-3.10.0-rc1-00035-g297e580-40
> /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/dmesg-kvm-snb-42045-2013-06-01-18-12-17-3.10.0-rc1-00035-g297e580-40
> /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/dmesg-kvm-snb-8849-2013-06-03-14-58-09-3.10.0-rc1-00035-g297e580-40
> /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/dmesg-kvm-stoakley-3542-2013-06-01-18-08-47-3.10.0-rc1-00035-g297e580-40
> /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/dmesg-kvm-vp-25931-2013-06-03-14-57-51-3.10.0-rc1-00035-g297e580-40
> /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/dmesg-kvm-vp-28116-2013-06-03-14-50-52-3.10.0-rc1-00035-g297e580-40
> /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/dmesg-kvm-vp-29039-2013-06-03-14-44-43-3.10.0-rc1-00035-g297e580-40
> /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/dmesg-kvm-vp-29181-2013-06-01-18-09-50-3.10.0-rc1-00035-g297e580-40
> /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/dmesg-kvm-vp-29934-2013-06-01-18-09-53-3.10.0-rc1-00035-g297e580-40
> /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/dmesg-kvm-vp-31768-2013-06-01-21-42-35-3.10.0-rc1-00035-g297e580-40
> /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/dmesg-kvm-vp-33016-2013-06-03-14-56-10-3.10.0-rc1-00035-g297e580-40
> /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/dmesg-kvm-waimea-26279-2013-06-03-14-58-51-3.10.0-rc1-00035-g297e580-40
> /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/dmesg-kvm-waimea-3282-2013-06-03-14-58-07-3.10.0-rc1-00035-g297e580-40
> /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/dmesg-kvm-waimea-3976-2013-06-01-18-12-29-3.10.0-rc1-00035-g297e580-40
> /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/dmesg-kvm-xbm-4854-2013-06-03-14-57-40-3.10.0-rc1-00035-g297e580-40
> /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/dmesg-kvm-xian-2307-2013-06-03-14-56-57-3.10.0-rc1-00035-g297e580-40
> /kernel/i386-randconfig-s10-0601/297e5804fbed91ac58027d04e033540681763283/dmesg-kvm-xian-4465-2013-06-01-18-10-39-3.10.0-rc1-00035-g297e580-40
> dmesg-kvm-athens-27243-2013-06-03-18-13-37-3.10.0-rc1-00035-g297e580-40
> dmesg-kvm-cairo-2888-2013-06-03-18-14-10-3.10.0-rc1-00035-g297e580-40
> dmesg-kvm-cairo-44463-2013-06-03-18-14-13-3.10.0-rc1-00035-g297e580-40
> dmesg-kvm-cairo-58633-2013-06-03-18-14-12-3.10.0-rc1-00035-g297e580-40
> dmesg-kvm-vp-30497-2013-06-03-18-15-28-3.10.0-rc1-00035-g297e580-40
> dmesg-kvm-vp-27412-2013-06-03-18-15-31-3.10.0-rc1-00035-g297e580-40
> dmesg-kvm-xian-5232-2013-06-03-18-14-28-3.10.0-rc1-00035-g297e580-40
> HEAD is now at 297e580 exynos4-is: Add isp_dbg() macro
> 
> ========= linux-next =========
> Fetching next
> 
> 2013-06-03-18:23:31 6318c0ec14d5f7aea22987223e1a99dbda7b1fd0 compiling
> 
> 2013-06-03-18:32:49 detecting boot state 3.10.0-rc4-next-20130603	0..	6	21	28	29.........................	30 SUCCESS

> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/i386 3.10.0-rc1 Kernel Configuration
> #
> # CONFIG_64BIT is not set
> CONFIG_X86_32=y
> CONFIG_X86=y
> CONFIG_INSTRUCTION_DECODER=y
> CONFIG_OUTPUT_FORMAT="elf32-i386"
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> CONFIG_MMU=y
> CONFIG_NEED_DMA_MAP_STATE=y
> CONFIG_NEED_SG_DMA_LENGTH=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_ARCH_HAS_CPU_RELAX=y
> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
> CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> # CONFIG_ZONE_DMA32 is not set
> # CONFIG_AUDIT_ARCH is not set
> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> CONFIG_X86_32_SMP=y
> CONFIG_X86_HT=y
> CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
> CONFIG_ARCH_CPU_PROBE_RELEASE=y
> CONFIG_ARCH_SUPPORTS_UPROBES=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_IRQ_WORK=y
> CONFIG_BUILDTIME_EXTABLE_SORT=y
> 
> #
> # General setup
> #
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_CROSS_COMPILE=""
> CONFIG_LOCALVERSION=""
> CONFIG_LOCALVERSION_AUTO=y
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_HAVE_KERNEL_BZIP2=y
> CONFIG_HAVE_KERNEL_LZMA=y
> CONFIG_HAVE_KERNEL_XZ=y
> CONFIG_HAVE_KERNEL_LZO=y
> CONFIG_KERNEL_GZIP=y
> # CONFIG_KERNEL_BZIP2 is not set
> # CONFIG_KERNEL_LZMA is not set
> # CONFIG_KERNEL_XZ is not set
> # CONFIG_KERNEL_LZO is not set
> CONFIG_DEFAULT_HOSTNAME="(none)"
> # CONFIG_SWAP is not set
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> # CONFIG_POSIX_MQUEUE is not set
> # CONFIG_FHANDLE is not set
> # CONFIG_AUDIT is not set
> CONFIG_HAVE_GENERIC_HARDIRQS=y
> 
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_HARDIRQS=y
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_IRQ_SHOW=y
> CONFIG_GENERIC_PENDING_IRQ=y
> CONFIG_IRQ_DOMAIN=y
> CONFIG_IRQ_DOMAIN_DEBUG=y
> CONFIG_IRQ_FORCED_THREADING=y
> CONFIG_SPARSE_IRQ=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_ALWAYS_USE_PERSISTENT_CLOCK=y
> CONFIG_KTIME_SCALAR=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> 
> #
> # Timers subsystem
> #
> CONFIG_HZ_PERIODIC=y
> # CONFIG_NO_HZ_IDLE is not set
> # CONFIG_NO_HZ is not set
> # CONFIG_HIGH_RES_TIMERS is not set
> 
> #
> # CPU/Task time and stats accounting
> #
> CONFIG_TICK_CPU_ACCOUNTING=y
> # CONFIG_IRQ_TIME_ACCOUNTING is not set
> # CONFIG_BSD_PROCESS_ACCT is not set
> # CONFIG_TASKSTATS is not set
> 
> #
> # RCU Subsystem
> #
> CONFIG_TREE_RCU=y
> # CONFIG_PREEMPT_RCU is not set
> CONFIG_RCU_STALL_COMMON=y
> CONFIG_RCU_FANOUT=32
> CONFIG_RCU_FANOUT_LEAF=16
> CONFIG_RCU_FANOUT_EXACT=y
> # CONFIG_TREE_RCU_TRACE is not set
> CONFIG_RCU_NOCB_CPU=y
> # CONFIG_RCU_NOCB_CPU_NONE is not set
> # CONFIG_RCU_NOCB_CPU_ZERO is not set
> CONFIG_RCU_NOCB_CPU_ALL=y
> CONFIG_IKCONFIG=y
> # CONFIG_IKCONFIG_PROC is not set
> CONFIG_LOG_BUF_SHIFT=17
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
> CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
> # CONFIG_CGROUPS is not set
> # CONFIG_CHECKPOINT_RESTORE is not set
> CONFIG_NAMESPACES=y
> # CONFIG_UTS_NS is not set
> CONFIG_IPC_NS=y
> # CONFIG_PID_NS is not set
> CONFIG_NET_NS=y
> # CONFIG_SCHED_AUTOGROUP is not set
> # CONFIG_SYSFS_DEPRECATED is not set
> CONFIG_RELAY=y
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_RD_GZIP=y
> CONFIG_RD_BZIP2=y
> CONFIG_RD_LZMA=y
> CONFIG_RD_XZ=y
> CONFIG_RD_LZO=y
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> CONFIG_SYSCTL=y
> CONFIG_ANON_INODES=y
> CONFIG_HAVE_UID16=y
> CONFIG_SYSCTL_EXCEPTION_TRACE=y
> CONFIG_HOTPLUG=y
> CONFIG_HAVE_PCSPKR_PLATFORM=y
> # CONFIG_EXPERT is not set
> CONFIG_UID16=y
> # CONFIG_SYSCTL_SYSCALL is not set
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_ALL=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_PCSPKR_PLATFORM=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_AIO=y
> CONFIG_PCI_QUIRKS=y
> # CONFIG_EMBEDDED is not set
> CONFIG_HAVE_PERF_EVENTS=y
> 
> #
> # Kernel Performance Events And Counters
> #
> CONFIG_PERF_EVENTS=y
> # CONFIG_DEBUG_PERF_USE_VMALLOC is not set
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_SLUB_DEBUG=y
> # CONFIG_COMPAT_BRK is not set
> # CONFIG_SLAB is not set
> CONFIG_SLUB=y
> CONFIG_PROFILING=y
> CONFIG_TRACEPOINTS=y
> # CONFIG_OPROFILE is not set
> CONFIG_HAVE_OPROFILE=y
> CONFIG_OPROFILE_NMI_TIMER=y
> # CONFIG_KPROBES is not set
> CONFIG_JUMP_LABEL=y
> # CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_ARCH_USE_BUILTIN_BSWAP=y
> CONFIG_HAVE_IOREMAP_PROT=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> CONFIG_HAVE_OPTPROBES=y
> CONFIG_HAVE_KPROBES_ON_FTRACE=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> CONFIG_HAVE_DMA_ATTRS=y
> CONFIG_HAVE_DMA_CONTIGUOUS=y
> CONFIG_USE_GENERIC_SMP_HELPERS=y
> CONFIG_GENERIC_SMP_IDLE_THREAD=y
> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
> CONFIG_HAVE_DMA_API_DEBUG=y
> CONFIG_HAVE_HW_BREAKPOINT=y
> CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
> CONFIG_HAVE_USER_RETURN_NOTIFIER=y
> CONFIG_HAVE_PERF_EVENTS_NMI=y
> CONFIG_HAVE_PERF_REGS=y
> CONFIG_HAVE_PERF_USER_STACK_DUMP=y
> CONFIG_HAVE_ARCH_JUMP_LABEL=y
> CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
> CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
> CONFIG_HAVE_CMPXCHG_LOCAL=y
> CONFIG_HAVE_CMPXCHG_DOUBLE=y
> CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
> CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
> CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
> CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
> CONFIG_MODULES_USE_ELF_REL=y
> CONFIG_CLONE_BACKWARDS=y
> CONFIG_OLD_SIGSUSPEND3=y
> CONFIG_OLD_SIGACTION=y
> 
> #
> # GCOV-based kernel profiling
> #
> # CONFIG_GCOV_KERNEL is not set
> CONFIG_HAVE_GENERIC_DMA_COHERENT=y
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=0
> CONFIG_MODULES=y
> # CONFIG_MODULE_FORCE_LOAD is not set
> CONFIG_MODULE_UNLOAD=y
> CONFIG_MODULE_FORCE_UNLOAD=y
> CONFIG_MODVERSIONS=y
> # CONFIG_MODULE_SRCVERSION_ALL is not set
> CONFIG_MODULE_SIG=y
> CONFIG_MODULE_SIG_FORCE=y
> CONFIG_MODULE_SIG_ALL=y
> # CONFIG_MODULE_SIG_SHA1 is not set
> CONFIG_MODULE_SIG_SHA224=y
> # CONFIG_MODULE_SIG_SHA256 is not set
> # CONFIG_MODULE_SIG_SHA384 is not set
> # CONFIG_MODULE_SIG_SHA512 is not set
> CONFIG_MODULE_SIG_HASH="sha224"
> CONFIG_STOP_MACHINE=y
> CONFIG_BLOCK=y
> CONFIG_LBDAF=y
> # CONFIG_BLK_DEV_BSG is not set
> # CONFIG_BLK_DEV_BSGLIB is not set
> CONFIG_BLK_DEV_INTEGRITY=y
> 
> #
> # Partition Types
> #
> # CONFIG_PARTITION_ADVANCED is not set
> CONFIG_MSDOS_PARTITION=y
> CONFIG_EFI_PARTITION=y
> 
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> # CONFIG_IOSCHED_DEADLINE is not set
> # CONFIG_IOSCHED_CFQ is not set
> CONFIG_DEFAULT_NOOP=y
> CONFIG_DEFAULT_IOSCHED="noop"
> CONFIG_ASN1=y
> CONFIG_UNINLINE_SPIN_UNLOCK=y
> CONFIG_FREEZER=y
> 
> #
> # Processor type and features
> #
> CONFIG_ZONE_DMA=y
> CONFIG_SMP=y
> CONFIG_X86_MPPARSE=y
> CONFIG_X86_BIGSMP=y
> CONFIG_GOLDFISH=y
> CONFIG_X86_EXTENDED_PLATFORM=y
> CONFIG_X86_GOLDFISH=y
> # CONFIG_X86_WANT_INTEL_MID is not set
> # CONFIG_X86_INTEL_LPSS is not set
> CONFIG_X86_RDC321X=y
> # CONFIG_X86_32_NON_STANDARD is not set
> CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
> CONFIG_X86_32_IRIS=m
> # CONFIG_SCHED_OMIT_FRAME_POINTER is not set
> CONFIG_HYPERVISOR_GUEST=y
> CONFIG_PARAVIRT=y
> CONFIG_PARAVIRT_DEBUG=y
> # CONFIG_PARAVIRT_SPINLOCKS is not set
> # CONFIG_XEN_PRIVILEGED_GUEST is not set
> CONFIG_KVM_GUEST=y
> CONFIG_LGUEST_GUEST=y
> CONFIG_PARAVIRT_TIME_ACCOUNTING=y
> CONFIG_PARAVIRT_CLOCK=y
> CONFIG_NO_BOOTMEM=y
> # CONFIG_MEMTEST is not set
> # CONFIG_M486 is not set
> # CONFIG_M586 is not set
> # CONFIG_M586TSC is not set
> # CONFIG_M586MMX is not set
> CONFIG_M686=y
> # CONFIG_MPENTIUMII is not set
> # CONFIG_MPENTIUMIII is not set
> # CONFIG_MPENTIUMM is not set
> # CONFIG_MPENTIUM4 is not set
> # CONFIG_MK6 is not set
> # CONFIG_MK7 is not set
> # CONFIG_MK8 is not set
> # CONFIG_MCRUSOE is not set
> # CONFIG_MEFFICEON is not set
> # CONFIG_MWINCHIPC6 is not set
> # CONFIG_MWINCHIP3D is not set
> # CONFIG_MELAN is not set
> # CONFIG_MGEODEGX1 is not set
> # CONFIG_MGEODE_LX is not set
> # CONFIG_MCYRIXIII is not set
> # CONFIG_MVIAC3_2 is not set
> # CONFIG_MVIAC7 is not set
> # CONFIG_MCORE2 is not set
> # CONFIG_MATOM is not set
> CONFIG_X86_GENERIC=y
> CONFIG_X86_INTERNODE_CACHE_SHIFT=6
> CONFIG_X86_L1_CACHE_SHIFT=6
> CONFIG_X86_PPRO_FENCE=y
> CONFIG_X86_INTEL_USERCOPY=y
> CONFIG_X86_USE_PPRO_CHECKSUM=y
> CONFIG_X86_TSC=y
> CONFIG_X86_CMPXCHG64=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=5
> CONFIG_X86_DEBUGCTLMSR=y
> CONFIG_CPU_SUP_INTEL=y
> CONFIG_CPU_SUP_AMD=y
> CONFIG_CPU_SUP_CENTAUR=y
> CONFIG_CPU_SUP_TRANSMETA_32=y
> CONFIG_HPET_TIMER=y
> CONFIG_DMI=y
> CONFIG_NR_CPUS=32
> # CONFIG_SCHED_SMT is not set
> CONFIG_SCHED_MC=y
> # CONFIG_PREEMPT_NONE is not set
> CONFIG_PREEMPT_VOLUNTARY=y
> # CONFIG_PREEMPT is not set
> CONFIG_PREEMPT_COUNT=y
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
> CONFIG_X86_MCE=y
> # CONFIG_X86_MCE_INTEL is not set
> CONFIG_X86_MCE_AMD=y
> # CONFIG_X86_ANCIENT_MCE is not set
> CONFIG_X86_MCE_THRESHOLD=y
> CONFIG_X86_MCE_INJECT=m
> CONFIG_VM86=y
> # CONFIG_TOSHIBA is not set
> CONFIG_I8K=y
> CONFIG_X86_REBOOTFIXUPS=y
> # CONFIG_MICROCODE is not set
> # CONFIG_X86_MSR is not set
> # CONFIG_X86_CPUID is not set
> # CONFIG_NOHIGHMEM is not set
> CONFIG_HIGHMEM4G=y
> # CONFIG_HIGHMEM64G is not set
> CONFIG_PAGE_OFFSET=0xC0000000
> CONFIG_HIGHMEM=y
> CONFIG_ARCH_FLATMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_ILLEGAL_POINTER_VALUE=0
> CONFIG_SELECT_MEMORY_MODEL=y
> CONFIG_FLATMEM_MANUAL=y
> # CONFIG_SPARSEMEM_MANUAL is not set
> CONFIG_FLATMEM=y
> CONFIG_FLAT_NODE_MEM_MAP=y
> CONFIG_SPARSEMEM_STATIC=y
> CONFIG_HAVE_MEMBLOCK=y
> CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
> CONFIG_ARCH_DISCARD_MEMBLOCK=y
> CONFIG_MEMORY_ISOLATION=y
> # CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_SPLIT_PTLOCK_CPUS=999999
> CONFIG_BALLOON_COMPACTION=y
> CONFIG_COMPACTION=y
> CONFIG_MIGRATION=y
> # CONFIG_PHYS_ADDR_T_64BIT is not set
> CONFIG_ZONE_DMA_FLAG=1
> # CONFIG_BOUNCE is not set
> CONFIG_VIRT_TO_BUS=y
> # CONFIG_KSM is not set
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
> CONFIG_MEMORY_FAILURE=y
> CONFIG_HWPOISON_INJECT=m
> CONFIG_TRANSPARENT_HUGEPAGE=y
> CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
> # CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
> # CONFIG_CROSS_MEMORY_ATTACH is not set
> CONFIG_CLEANCACHE=y
> # CONFIG_HIGHPTE is not set
> CONFIG_X86_CHECK_BIOS_CORRUPTION=y
> CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
> CONFIG_X86_RESERVE_LOW=64
> # CONFIG_MATH_EMULATION is not set
> CONFIG_MTRR=y
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> CONFIG_X86_PAT=y
> CONFIG_ARCH_USES_PG_UNCACHED=y
> CONFIG_ARCH_RANDOM=y
> CONFIG_X86_SMAP=y
> # CONFIG_EFI is not set
> # CONFIG_SECCOMP is not set
> CONFIG_CC_STACKPROTECTOR=y
> CONFIG_HZ_100=y
> # CONFIG_HZ_250 is not set
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=100
> # CONFIG_SCHED_HRTICK is not set
> CONFIG_KEXEC=y
> CONFIG_CRASH_DUMP=y
> CONFIG_PHYSICAL_START=0x1000000
> # CONFIG_RELOCATABLE is not set
> CONFIG_PHYSICAL_ALIGN=0x1000000
> CONFIG_HOTPLUG_CPU=y
> # CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
> # CONFIG_DEBUG_HOTPLUG_CPU0 is not set
> # CONFIG_COMPAT_VDSO is not set
> # CONFIG_CMDLINE_BOOL is not set
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> 
> #
> # Power management and ACPI options
> #
> CONFIG_SUSPEND=y
> CONFIG_SUSPEND_FREEZER=y
> CONFIG_PM_SLEEP=y
> CONFIG_PM_SLEEP_SMP=y
> # CONFIG_PM_AUTOSLEEP is not set
> CONFIG_PM_WAKELOCKS=y
> CONFIG_PM_WAKELOCKS_LIMIT=100
> CONFIG_PM_WAKELOCKS_GC=y
> CONFIG_PM_RUNTIME=y
> CONFIG_PM=y
> # CONFIG_PM_DEBUG is not set
> CONFIG_ACPI=y
> CONFIG_ACPI_SLEEP=y
> # CONFIG_ACPI_PROCFS is not set
> # CONFIG_ACPI_PROCFS_POWER is not set
> # CONFIG_ACPI_EC_DEBUGFS is not set
> CONFIG_ACPI_PROC_EVENT=y
> CONFIG_ACPI_AC=y
> CONFIG_ACPI_BATTERY=y
> CONFIG_ACPI_BUTTON=y
> # CONFIG_ACPI_VIDEO is not set
> CONFIG_ACPI_FAN=y
> # CONFIG_ACPI_DOCK is not set
> CONFIG_ACPI_I2C=y
> CONFIG_ACPI_PROCESSOR=y
> # CONFIG_ACPI_IPMI is not set
> CONFIG_ACPI_HOTPLUG_CPU=y
> # CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
> CONFIG_ACPI_THERMAL=y
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> # CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
> CONFIG_ACPI_BLACKLIST_YEAR=0
> # CONFIG_ACPI_DEBUG is not set
> # CONFIG_ACPI_PCI_SLOT is not set
> CONFIG_X86_PM_TIMER=y
> CONFIG_ACPI_CONTAINER=y
> # CONFIG_ACPI_SBS is not set
> # CONFIG_ACPI_HED is not set
> # CONFIG_ACPI_CUSTOM_METHOD is not set
> # CONFIG_ACPI_APEI is not set
> # CONFIG_SFI is not set
> # CONFIG_APM is not set
> 
> #
> # CPU Frequency scaling
> #
> CONFIG_CPU_FREQ=y
> CONFIG_CPU_FREQ_TABLE=y
> CONFIG_CPU_FREQ_GOV_COMMON=y
> CONFIG_CPU_FREQ_STAT=m
> CONFIG_CPU_FREQ_STAT_DETAILS=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
> CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
> CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
> # CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
> CONFIG_CPU_FREQ_GOV_USERSPACE=m
> CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> # CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set
> 
> #
> # x86 CPU frequency scaling drivers
> #
> # CONFIG_X86_INTEL_PSTATE is not set
> # CONFIG_X86_PCC_CPUFREQ is not set
> # CONFIG_X86_ACPI_CPUFREQ is not set
> # CONFIG_X86_POWERNOW_K6 is not set
> # CONFIG_X86_POWERNOW_K7 is not set
> # CONFIG_X86_GX_SUSPMOD is not set
> CONFIG_X86_SPEEDSTEP_CENTRINO=m
> CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
> CONFIG_X86_SPEEDSTEP_ICH=y
> CONFIG_X86_SPEEDSTEP_SMI=m
> CONFIG_X86_P4_CLOCKMOD=y
> # CONFIG_X86_CPUFREQ_NFORCE2 is not set
> CONFIG_X86_LONGRUN=m
> # CONFIG_X86_LONGHAUL is not set
> # CONFIG_X86_E_POWERSAVER is not set
> 
> #
> # shared options
> #
> CONFIG_X86_SPEEDSTEP_LIB=y
> # CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set
> CONFIG_CPU_IDLE=y
> # CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
> CONFIG_CPU_IDLE_GOV_LADDER=y
> # CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
> # CONFIG_INTEL_IDLE is not set
> 
> #
> # Bus options (PCI etc.)
> #
> CONFIG_PCI=y
> # CONFIG_PCI_GOBIOS is not set
> # CONFIG_PCI_GOMMCONFIG is not set
> # CONFIG_PCI_GODIRECT is not set
> # CONFIG_PCI_GOOLPC is not set
> CONFIG_PCI_GOANY=y
> CONFIG_PCI_BIOS=y
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_MMCONFIG=y
> CONFIG_PCI_OLPC=y
> CONFIG_PCI_DOMAINS=y
> # CONFIG_PCIEPORTBUS is not set
> CONFIG_ARCH_SUPPORTS_MSI=y
> # CONFIG_PCI_MSI is not set
> # CONFIG_PCI_DEBUG is not set
> # CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
> # CONFIG_PCI_STUB is not set
> CONFIG_HT_IRQ=y
> # CONFIG_PCI_IOV is not set
> # CONFIG_PCI_PRI is not set
> # CONFIG_PCI_PASID is not set
> # CONFIG_PCI_IOAPIC is not set
> CONFIG_PCI_LABEL=y
> CONFIG_ISA_DMA_API=y
> CONFIG_ISA=y
> CONFIG_EISA=y
> CONFIG_EISA_VLB_PRIMING=y
> CONFIG_EISA_PCI_EISA=y
> CONFIG_EISA_VIRTUAL_ROOT=y
> CONFIG_EISA_NAMES=y
> # CONFIG_SCx200 is not set
> CONFIG_OLPC=y
> # CONFIG_OLPC_XO15_SCI is not set
> CONFIG_ALIX=y
> # CONFIG_NET5501 is not set
> # CONFIG_GEOS is not set
> CONFIG_AMD_NB=y
> CONFIG_PCCARD=y
> # CONFIG_PCMCIA is not set
> CONFIG_CARDBUS=y
> 
> #
> # PC-card bridges
> #
> # CONFIG_YENTA is not set
> CONFIG_PCMCIA_PROBE=y
> # CONFIG_HOTPLUG_PCI is not set
> # CONFIG_RAPIDIO is not set
> 
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
> CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
> CONFIG_BINFMT_SCRIPT=y
> CONFIG_HAVE_AOUT=y
> CONFIG_BINFMT_AOUT=m
> # CONFIG_BINFMT_MISC is not set
> CONFIG_COREDUMP=y
> CONFIG_HAVE_ATOMIC_IOMAP=y
> CONFIG_HAVE_TEXT_POKE_SMP=y
> CONFIG_NET=y
> 
> #
> # Networking options
> #
> # CONFIG_PACKET is not set
> CONFIG_UNIX=y
> # CONFIG_UNIX_DIAG is not set
> # CONFIG_NET_KEY is not set
> # CONFIG_INET is not set
> # CONFIG_NETWORK_SECMARK is not set
> # CONFIG_NETWORK_PHY_TIMESTAMPING is not set
> # CONFIG_NETFILTER is not set
> # CONFIG_ATM is not set
> # CONFIG_BRIDGE is not set
> # CONFIG_VLAN_8021Q is not set
> # CONFIG_DECNET is not set
> # CONFIG_LLC2 is not set
> # CONFIG_IPX is not set
> # CONFIG_ATALK is not set
> # CONFIG_X25 is not set
> # CONFIG_LAPB is not set
> # CONFIG_PHONET is not set
> # CONFIG_IEEE802154 is not set
> # CONFIG_NET_SCHED is not set
> # CONFIG_DCB is not set
> # CONFIG_DNS_RESOLVER is not set
> # CONFIG_BATMAN_ADV is not set
> # CONFIG_OPENVSWITCH is not set
> # CONFIG_VSOCKETS is not set
> # CONFIG_NETLINK_MMAP is not set
> # CONFIG_NETLINK_DIAG is not set
> CONFIG_RPS=y
> CONFIG_RFS_ACCEL=y
> CONFIG_XPS=y
> CONFIG_BQL=y
> 
> #
> # Network testing
> #
> # CONFIG_NET_PKTGEN is not set
> # CONFIG_HAMRADIO is not set
> # CONFIG_CAN is not set
> # CONFIG_IRDA is not set
> # CONFIG_BT is not set
> CONFIG_WIRELESS=y
> # CONFIG_CFG80211 is not set
> # CONFIG_LIB80211 is not set
> 
> #
> # CFG80211 needs to be enabled for MAC80211
> #
> # CONFIG_WIMAX is not set
> # CONFIG_RFKILL is not set
> # CONFIG_RFKILL_REGULATOR is not set
> # CONFIG_NET_9P is not set
> # CONFIG_CAIF is not set
> # CONFIG_NFC is not set
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER_PATH=""
> # CONFIG_DEVTMPFS is not set
> CONFIG_STANDALONE=y
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> CONFIG_FIRMWARE_IN_KERNEL=y
> CONFIG_EXTRA_FIRMWARE=""
> CONFIG_FW_LOADER_USER_HELPER=y
> CONFIG_DEBUG_DRIVER=y
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_GENERIC_CPU_DEVICES is not set
> CONFIG_REGMAP=y
> CONFIG_REGMAP_I2C=y
> CONFIG_REGMAP_SPI=y
> CONFIG_REGMAP_MMIO=y
> CONFIG_REGMAP_IRQ=y
> CONFIG_DMA_SHARED_BUFFER=y
> CONFIG_CMA=y
> CONFIG_CMA_DEBUG=y
> 
> #
> # Default contiguous memory area size:
> #
> CONFIG_CMA_SIZE_MBYTES=16
> CONFIG_CMA_SIZE_SEL_MBYTES=y
> # CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
> # CONFIG_CMA_SIZE_SEL_MIN is not set
> # CONFIG_CMA_SIZE_SEL_MAX is not set
> CONFIG_CMA_ALIGNMENT=8
> CONFIG_CMA_AREAS=7
> 
> #
> # Bus devices
> #
> # CONFIG_CONNECTOR is not set
> CONFIG_MTD=m
> CONFIG_MTD_TESTS=m
> CONFIG_MTD_REDBOOT_PARTS=m
> CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
> CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
> # CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
> # CONFIG_MTD_CMDLINE_PARTS is not set
> # CONFIG_MTD_OF_PARTS is not set
> CONFIG_MTD_AR7_PARTS=m
> 
> #
> # User Modules And Translation Layers
> #
> CONFIG_MTD_BLKDEVS=m
> CONFIG_MTD_BLOCK=m
> # CONFIG_MTD_BLOCK_RO is not set
> CONFIG_FTL=m
> CONFIG_NFTL=m
> CONFIG_NFTL_RW=y
> # CONFIG_INFTL is not set
> # CONFIG_RFD_FTL is not set
> # CONFIG_SSFDC is not set
> CONFIG_SM_FTL=m
> CONFIG_MTD_OOPS=m
> 
> #
> # RAM/ROM/Flash chip drivers
> #
> CONFIG_MTD_CFI=m
> CONFIG_MTD_JEDECPROBE=m
> CONFIG_MTD_GEN_PROBE=m
> CONFIG_MTD_CFI_ADV_OPTIONS=y
> # CONFIG_MTD_CFI_NOSWAP is not set
> CONFIG_MTD_CFI_BE_BYTE_SWAP=y
> # CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
> # CONFIG_MTD_CFI_GEOMETRY is not set
> CONFIG_MTD_MAP_BANK_WIDTH_1=y
> CONFIG_MTD_MAP_BANK_WIDTH_2=y
> CONFIG_MTD_MAP_BANK_WIDTH_4=y
> # CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
> # CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
> # CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
> CONFIG_MTD_CFI_I1=y
> CONFIG_MTD_CFI_I2=y
> # CONFIG_MTD_CFI_I4 is not set
> # CONFIG_MTD_CFI_I8 is not set
> # CONFIG_MTD_OTP is not set
> CONFIG_MTD_CFI_INTELEXT=m
> CONFIG_MTD_CFI_AMDSTD=m
> CONFIG_MTD_CFI_STAA=m
> CONFIG_MTD_CFI_UTIL=m
> # CONFIG_MTD_RAM is not set
> CONFIG_MTD_ROM=m
> # CONFIG_MTD_ABSENT is not set
> 
> #
> # Mapping drivers for chip access
> #
> # CONFIG_MTD_COMPLEX_MAPPINGS is not set
> CONFIG_MTD_PHYSMAP=m
> CONFIG_MTD_PHYSMAP_COMPAT=y
> CONFIG_MTD_PHYSMAP_START=0x8000000
> CONFIG_MTD_PHYSMAP_LEN=0
> CONFIG_MTD_PHYSMAP_BANKWIDTH=2
> CONFIG_MTD_PHYSMAP_OF=m
> # CONFIG_MTD_SC520CDP is not set
> # CONFIG_MTD_NETSC520 is not set
> CONFIG_MTD_TS5500=m
> CONFIG_MTD_AMD76XROM=m
> CONFIG_MTD_ICHXROM=m
> # CONFIG_MTD_ESB2ROM is not set
> # CONFIG_MTD_CK804XROM is not set
> # CONFIG_MTD_SCB2_FLASH is not set
> # CONFIG_MTD_NETtel is not set
> CONFIG_MTD_L440GX=m
> # CONFIG_MTD_INTEL_VR_NOR is not set
> # CONFIG_MTD_PLATRAM is not set
> 
> #
> # Self-contained MTD device drivers
> #
> # CONFIG_MTD_PMC551 is not set
> # CONFIG_MTD_DATAFLASH is not set
> # CONFIG_MTD_M25P80 is not set
> CONFIG_MTD_SST25L=m
> CONFIG_MTD_SLRAM=m
> CONFIG_MTD_PHRAM=m
> CONFIG_MTD_MTDRAM=m
> CONFIG_MTDRAM_TOTAL_SIZE=4096
> CONFIG_MTDRAM_ERASE_SIZE=128
> CONFIG_MTD_BLOCK2MTD=m
> 
> #
> # Disk-On-Chip Device Drivers
> #
> # CONFIG_MTD_DOCG3 is not set
> CONFIG_MTD_NAND_ECC=m
> CONFIG_MTD_NAND_ECC_SMC=y
> # CONFIG_MTD_NAND is not set
> # CONFIG_MTD_ONENAND is not set
> 
> #
> # LPDDR flash memory drivers
> #
> # CONFIG_MTD_LPDDR is not set
> CONFIG_MTD_UBI=m
> CONFIG_MTD_UBI_WL_THRESHOLD=4096
> CONFIG_MTD_UBI_BEB_LIMIT=20
> # CONFIG_MTD_UBI_FASTMAP is not set
> CONFIG_MTD_UBI_GLUEBI=m
> CONFIG_OF=y
> 
> #
> # Device Tree and Open Firmware support
> #
> CONFIG_PROC_DEVICETREE=y
> # CONFIG_OF_SELFTEST is not set
> CONFIG_OF_PROMTREE=y
> CONFIG_OF_ADDRESS=y
> CONFIG_OF_IRQ=y
> CONFIG_OF_DEVICE=y
> CONFIG_OF_I2C=y
> CONFIG_OF_PCI=y
> CONFIG_OF_PCI_IRQ=y
> CONFIG_OF_MTD=y
> # CONFIG_PARPORT is not set
> CONFIG_PNP=y
> # CONFIG_PNP_DEBUG_MESSAGES is not set
> 
> #
> # Protocols
> #
> # CONFIG_ISAPNP is not set
> # CONFIG_PNPBIOS is not set
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> # CONFIG_BLK_DEV_FD is not set
> # CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
> # CONFIG_BLK_CPQ_DA is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_UMEM is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> # CONFIG_BLK_DEV_LOOP is not set
> 
> #
> # DRBD disabled because PROC_FS or INET not selected
> #
> # CONFIG_BLK_DEV_NBD is not set
> # CONFIG_BLK_DEV_NVME is not set
> # CONFIG_BLK_DEV_SX8 is not set
> # CONFIG_BLK_DEV_RAM is not set
> # CONFIG_CDROM_PKTCDVD is not set
> # CONFIG_ATA_OVER_ETH is not set
> # CONFIG_VIRTIO_BLK is not set
> # CONFIG_BLK_DEV_HD is not set
> # CONFIG_BLK_DEV_RSXX is not set
> 
> #
> # Misc devices
> #
> CONFIG_SENSORS_LIS3LV02D=y
> CONFIG_AD525X_DPOT=m
> CONFIG_AD525X_DPOT_I2C=m
> CONFIG_AD525X_DPOT_SPI=m
> CONFIG_DUMMY_IRQ=m
> # CONFIG_IBM_ASM is not set
> # CONFIG_PHANTOM is not set
> # CONFIG_INTEL_MID_PTI is not set
> # CONFIG_SGI_IOC4 is not set
> # CONFIG_TIFM_CORE is not set
> CONFIG_ICS932S401=m
> CONFIG_ATMEL_SSC=m
> CONFIG_ENCLOSURE_SERVICES=m
> # CONFIG_HP_ILO is not set
> # CONFIG_APDS9802ALS is not set
> # CONFIG_ISL29003 is not set
> # CONFIG_ISL29020 is not set
> # CONFIG_SENSORS_TSL2550 is not set
> CONFIG_SENSORS_BH1780=y
> CONFIG_SENSORS_BH1770=m
> CONFIG_SENSORS_APDS990X=m
> CONFIG_HMC6352=m
> CONFIG_DS1682=m
> # CONFIG_TI_DAC7512 is not set
> CONFIG_VMWARE_BALLOON=m
> CONFIG_BMP085=y
> CONFIG_BMP085_I2C=m
> CONFIG_BMP085_SPI=m
> # CONFIG_PCH_PHUB is not set
> CONFIG_USB_SWITCH_FSA9480=m
> # CONFIG_LATTICE_ECP3_CONFIG is not set
> CONFIG_SRAM=y
> CONFIG_C2PORT=y
> # CONFIG_C2PORT_DURAMAR_2150 is not set
> 
> #
> # EEPROM support
> #
> CONFIG_EEPROM_AT24=y
> CONFIG_EEPROM_AT25=y
> # CONFIG_EEPROM_LEGACY is not set
> # CONFIG_EEPROM_MAX6875 is not set
> CONFIG_EEPROM_93CX6=y
> CONFIG_EEPROM_93XX46=y
> # CONFIG_CB710_CORE is not set
> 
> #
> # Texas Instruments shared transport line discipline
> #
> # CONFIG_TI_ST is not set
> CONFIG_SENSORS_LIS3_I2C=y
> 
> #
> # Altera FPGA firmware download module
> #
> CONFIG_ALTERA_STAPL=m
> # CONFIG_VMWARE_VMCI is not set
> CONFIG_HAVE_IDE=y
> # CONFIG_IDE is not set
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=y
> CONFIG_RAID_ATTRS=y
> # CONFIG_SCSI is not set
> # CONFIG_SCSI_DMA is not set
> # CONFIG_SCSI_NETLINK is not set
> # CONFIG_ATA is not set
> # CONFIG_MD is not set
> # CONFIG_FUSION is not set
> 
> #
> # IEEE 1394 (FireWire) support
> #
> # CONFIG_FIREWIRE is not set
> # CONFIG_FIREWIRE_NOSY is not set
> # CONFIG_I2O is not set
> CONFIG_MACINTOSH_DRIVERS=y
> CONFIG_MAC_EMUMOUSEBTN=m
> # CONFIG_NETDEVICES is not set
> # CONFIG_VHOST_NET is not set
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> # CONFIG_INPUT_FF_MEMLESS is not set
> CONFIG_INPUT_POLLDEV=y
> CONFIG_INPUT_SPARSEKMAP=m
> CONFIG_INPUT_MATRIXKMAP=y
> 
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=y
> CONFIG_INPUT_MOUSEDEV_PSAUX=y
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> CONFIG_INPUT_JOYDEV=m
> CONFIG_INPUT_EVDEV=y
> CONFIG_INPUT_EVBUG=m
> 
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> CONFIG_KEYBOARD_ADP5520=m
> # CONFIG_KEYBOARD_ADP5588 is not set
> CONFIG_KEYBOARD_ADP5589=m
> CONFIG_KEYBOARD_ATKBD=y
> CONFIG_KEYBOARD_QT1070=m
> CONFIG_KEYBOARD_QT2160=m
> CONFIG_KEYBOARD_LKKBD=m
> CONFIG_KEYBOARD_GPIO=y
> CONFIG_KEYBOARD_GPIO_POLLED=m
> # CONFIG_KEYBOARD_TCA6416 is not set
> CONFIG_KEYBOARD_TCA8418=m
> CONFIG_KEYBOARD_MATRIX=y
> CONFIG_KEYBOARD_LM8323=y
> CONFIG_KEYBOARD_LM8333=y
> CONFIG_KEYBOARD_MAX7359=y
> CONFIG_KEYBOARD_MCS=y
> CONFIG_KEYBOARD_MPR121=m
> # CONFIG_KEYBOARD_NEWTON is not set
> CONFIG_KEYBOARD_OPENCORES=y
> CONFIG_KEYBOARD_GOLDFISH_EVENTS=y
> # CONFIG_KEYBOARD_STOWAWAY is not set
> CONFIG_KEYBOARD_SUNKBD=y
> # CONFIG_KEYBOARD_STMPE is not set
> # CONFIG_KEYBOARD_TC3589X is not set
> # CONFIG_KEYBOARD_XTKBD is not set
> # CONFIG_KEYBOARD_CROS_EC is not set
> # CONFIG_INPUT_MOUSE is not set
> # CONFIG_INPUT_JOYSTICK is not set
> CONFIG_INPUT_TABLET=y
> # CONFIG_TABLET_USB_ACECAD is not set
> # CONFIG_TABLET_USB_AIPTEK is not set
> # CONFIG_TABLET_USB_HANWANG is not set
> # CONFIG_TABLET_USB_KBTAB is not set
> # CONFIG_TABLET_USB_WACOM is not set
> # CONFIG_INPUT_TOUCHSCREEN is not set
> # CONFIG_INPUT_MISC is not set
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_SERIO_I8042=y
> CONFIG_SERIO_SERPORT=m
> CONFIG_SERIO_CT82C710=y
> # CONFIG_SERIO_PCIPS2 is not set
> CONFIG_SERIO_LIBPS2=y
> # CONFIG_SERIO_RAW is not set
> CONFIG_SERIO_ALTERA_PS2=y
> # CONFIG_SERIO_PS2MULT is not set
> # CONFIG_SERIO_ARC_PS2 is not set
> CONFIG_SERIO_APBPS2=m
> CONFIG_GAMEPORT=y
> CONFIG_GAMEPORT_NS558=y
> CONFIG_GAMEPORT_L4=m
> # CONFIG_GAMEPORT_EMU10K1 is not set
> # CONFIG_GAMEPORT_FM801 is not set
> 
> #
> # Character devices
> #
> CONFIG_TTY=y
> CONFIG_VT=y
> CONFIG_CONSOLE_TRANSLATIONS=y
> CONFIG_VT_CONSOLE=y
> CONFIG_VT_CONSOLE_SLEEP=y
> CONFIG_HW_CONSOLE=y
> # CONFIG_VT_HW_CONSOLE_BINDING is not set
> CONFIG_UNIX98_PTYS=y
> # CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
> CONFIG_LEGACY_PTYS=y
> CONFIG_LEGACY_PTY_COUNT=256
> # CONFIG_SERIAL_NONSTANDARD is not set
> # CONFIG_NOZOMI is not set
> # CONFIG_N_GSM is not set
> CONFIG_TRACE_ROUTER=y
> CONFIG_TRACE_SINK=y
> CONFIG_GOLDFISH_TTY=y
> CONFIG_DEVKMEM=y
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_SERIAL_8250_DMA=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> # CONFIG_SERIAL_8250_EXTENDED is not set
> # CONFIG_SERIAL_8250_DW is not set
> 
> #
> # Non-8250 serial port support
> #
> CONFIG_SERIAL_MAX3100=m
> CONFIG_SERIAL_MAX310X=y
> # CONFIG_SERIAL_MFD_HSU is not set
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> # CONFIG_SERIAL_JSM is not set
> # CONFIG_SERIAL_OF_PLATFORM is not set
> CONFIG_SERIAL_SCCNXP=m
> # CONFIG_SERIAL_TIMBERDALE is not set
> # CONFIG_SERIAL_ALTERA_JTAGUART is not set
> CONFIG_SERIAL_ALTERA_UART=y
> CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
> CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
> CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
> CONFIG_SERIAL_IFX6X60=y
> # CONFIG_SERIAL_PCH_UART is not set
> CONFIG_SERIAL_XILINX_PS_UART=y
> # CONFIG_SERIAL_XILINX_PS_UART_CONSOLE is not set
> # CONFIG_SERIAL_ARC is not set
> # CONFIG_SERIAL_RP2 is not set
> CONFIG_HVC_DRIVER=y
> CONFIG_VIRTIO_CONSOLE=y
> CONFIG_IPMI_HANDLER=m
> CONFIG_IPMI_PANIC_EVENT=y
> CONFIG_IPMI_PANIC_STRING=y
> # CONFIG_IPMI_DEVICE_INTERFACE is not set
> CONFIG_IPMI_SI=m
> CONFIG_IPMI_WATCHDOG=m
> CONFIG_IPMI_POWEROFF=m
> CONFIG_HW_RANDOM=m
> CONFIG_HW_RANDOM_TIMERIOMEM=m
> CONFIG_HW_RANDOM_INTEL=m
> CONFIG_HW_RANDOM_AMD=m
> CONFIG_HW_RANDOM_GEODE=m
> CONFIG_HW_RANDOM_VIA=m
> CONFIG_HW_RANDOM_VIRTIO=m
> # CONFIG_HW_RANDOM_TPM is not set
> CONFIG_NVRAM=m
> CONFIG_DTLK=y
> # CONFIG_R3964 is not set
> # CONFIG_APPLICOM is not set
> # CONFIG_SONYPI is not set
> # CONFIG_MWAVE is not set
> CONFIG_PC8736x_GPIO=y
> CONFIG_NSC_GPIO=y
> # CONFIG_RAW_DRIVER is not set
> # CONFIG_HPET is not set
> CONFIG_HANGCHECK_TIMER=y
> CONFIG_TCG_TPM=y
> # CONFIG_TCG_TIS is not set
> # CONFIG_TCG_TIS_I2C_INFINEON is not set
> CONFIG_TCG_NSC=m
> CONFIG_TCG_ATMEL=m
> CONFIG_TCG_INFINEON=m
> # CONFIG_TCG_ST33_I2C is not set
> CONFIG_TELCLOCK=y
> CONFIG_DEVPORT=y
> CONFIG_I2C=y
> CONFIG_I2C_BOARDINFO=y
> CONFIG_I2C_COMPAT=y
> CONFIG_I2C_CHARDEV=y
> CONFIG_I2C_MUX=y
> 
> #
> # Multiplexer I2C Chip support
> #
> # CONFIG_I2C_ARB_GPIO_CHALLENGE is not set
> # CONFIG_I2C_MUX_GPIO is not set
> CONFIG_I2C_MUX_PCA9541=y
> CONFIG_I2C_MUX_PCA954x=y
> CONFIG_I2C_HELPER_AUTO=y
> CONFIG_I2C_SMBUS=y
> CONFIG_I2C_ALGOBIT=y
> CONFIG_I2C_ALGOPCA=m
> 
> #
> # I2C Hardware Bus support
> #
> 
> #
> # PC SMBus host controller drivers
> #
> # CONFIG_I2C_ALI1535 is not set
> # CONFIG_I2C_ALI1563 is not set
> # CONFIG_I2C_ALI15X3 is not set
> # CONFIG_I2C_AMD756 is not set
> # CONFIG_I2C_AMD8111 is not set
> # CONFIG_I2C_I801 is not set
> # CONFIG_I2C_ISCH is not set
> # CONFIG_I2C_ISMT is not set
> # CONFIG_I2C_PIIX4 is not set
> # CONFIG_I2C_NFORCE2 is not set
> # CONFIG_I2C_SIS5595 is not set
> # CONFIG_I2C_SIS630 is not set
> # CONFIG_I2C_SIS96X is not set
> # CONFIG_I2C_VIA is not set
> # CONFIG_I2C_VIAPRO is not set
> 
> #
> # ACPI drivers
> #
> # CONFIG_I2C_SCMI is not set
> 
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> CONFIG_I2C_CBUS_GPIO=m
> # CONFIG_I2C_DESIGNWARE_PCI is not set
> # CONFIG_I2C_EG20T is not set
> CONFIG_I2C_GPIO=y
> # CONFIG_I2C_INTEL_MID is not set
> # CONFIG_I2C_OCORES is not set
> CONFIG_I2C_PCA_PLATFORM=m
> # CONFIG_I2C_PXA is not set
> # CONFIG_I2C_PXA_PCI is not set
> CONFIG_I2C_SIMTEC=y
> # CONFIG_I2C_XILINX is not set
> 
> #
> # External I2C/SMBus adapter drivers
> #
> CONFIG_I2C_PARPORT_LIGHT=y
> # CONFIG_I2C_TAOS_EVM is not set
> 
> #
> # Other I2C/SMBus bus drivers
> #
> CONFIG_I2C_PCA_ISA=m
> # CONFIG_SCx200_ACB is not set
> # CONFIG_I2C_STUB is not set
> CONFIG_I2C_DEBUG_CORE=y
> # CONFIG_I2C_DEBUG_ALGO is not set
> CONFIG_I2C_DEBUG_BUS=y
> CONFIG_SPI=y
> CONFIG_SPI_DEBUG=y
> CONFIG_SPI_MASTER=y
> 
> #
> # SPI Master Controller Drivers
> #
> CONFIG_SPI_ALTERA=m
> CONFIG_SPI_BITBANG=y
> CONFIG_SPI_GPIO=y
> # CONFIG_SPI_FSL_SPI is not set
> CONFIG_SPI_OC_TINY=m
> # CONFIG_SPI_PXA2XX is not set
> # CONFIG_SPI_PXA2XX_PCI is not set
> # CONFIG_SPI_SC18IS602 is not set
> # CONFIG_SPI_TOPCLIFF_PCH is not set
> CONFIG_SPI_XCOMM=m
> # CONFIG_SPI_XILINX is not set
> CONFIG_SPI_DESIGNWARE=y
> # CONFIG_SPI_DW_PCI is not set
> 
> #
> # SPI Protocol Masters
> #
> CONFIG_SPI_SPIDEV=y
> CONFIG_SPI_TLE62X0=y
> 
> #
> # Qualcomm MSM SSBI bus support
> #
> # CONFIG_SSBI is not set
> CONFIG_HSI=y
> CONFIG_HSI_BOARDINFO=y
> 
> #
> # HSI clients
> #
> CONFIG_HSI_CHAR=y
> 
> #
> # PPS support
> #
> CONFIG_PPS=y
> CONFIG_PPS_DEBUG=y
> # CONFIG_NTP_PPS is not set
> 
> #
> # PPS clients support
> #
> CONFIG_PPS_CLIENT_KTIMER=m
> # CONFIG_PPS_CLIENT_LDISC is not set
> CONFIG_PPS_CLIENT_GPIO=y
> 
> #
> # PPS generators support
> #
> 
> #
> # PTP clock support
> #
> CONFIG_PTP_1588_CLOCK=y
> 
> #
> # Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
> #
> CONFIG_PTP_1588_CLOCK_PCH=y
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> CONFIG_GPIO_DEVRES=y
> CONFIG_GPIOLIB=y
> CONFIG_OF_GPIO=y
> CONFIG_GPIO_ACPI=y
> CONFIG_DEBUG_GPIO=y
> # CONFIG_GPIO_SYSFS is not set
> CONFIG_GPIO_GENERIC=y
> 
> #
> # Memory mapped GPIO drivers:
> #
> CONFIG_GPIO_GENERIC_PLATFORM=y
> CONFIG_GPIO_IT8761E=m
> # CONFIG_GPIO_TS5500 is not set
> # CONFIG_GPIO_SCH is not set
> # CONFIG_GPIO_ICH is not set
> # CONFIG_GPIO_VX855 is not set
> # CONFIG_GPIO_LYNXPOINT is not set
> CONFIG_GPIO_GRGPIO=m
> 
> #
> # I2C GPIO expanders:
> #
> # CONFIG_GPIO_ARIZONA is not set
> # CONFIG_GPIO_MAX7300 is not set
> CONFIG_GPIO_MAX732X=y
> # CONFIG_GPIO_MAX732X_IRQ is not set
> CONFIG_GPIO_PCA953X=m
> CONFIG_GPIO_PCF857X=y
> CONFIG_GPIO_SX150X=y
> CONFIG_GPIO_STMPE=y
> CONFIG_GPIO_TC3589X=y
> CONFIG_GPIO_TPS65912=y
> CONFIG_GPIO_WM831X=y
> CONFIG_GPIO_WM8350=y
> CONFIG_GPIO_ADP5520=y
> # CONFIG_GPIO_ADP5588 is not set
> CONFIG_GPIO_ADNP=y
> 
> #
> # PCI GPIO expanders:
> #
> # CONFIG_GPIO_BT8XX is not set
> # CONFIG_GPIO_AMD8111 is not set
> # CONFIG_GPIO_LANGWELL is not set
> # CONFIG_GPIO_PCH is not set
> # CONFIG_GPIO_ML_IOH is not set
> # CONFIG_GPIO_SODAVILLE is not set
> # CONFIG_GPIO_RDC321X is not set
> 
> #
> # SPI GPIO expanders:
> #
> # CONFIG_GPIO_MAX7301 is not set
> CONFIG_GPIO_MCP23S08=y
> CONFIG_GPIO_MC33880=y
> CONFIG_GPIO_74X164=m
> 
> #
> # AC97 GPIO expanders:
> #
> 
> #
> # MODULbus GPIO expanders:
> #
> # CONFIG_GPIO_TPS6586X is not set
> 
> #
> # USB GPIO expanders:
> #
> CONFIG_W1=m
> 
> #
> # 1-wire Bus Masters
> #
> # CONFIG_W1_MASTER_MATROX is not set
> # CONFIG_W1_MASTER_DS2482 is not set
> CONFIG_W1_MASTER_DS1WM=m
> CONFIG_W1_MASTER_GPIO=m
> 
> #
> # 1-wire Slaves
> #
> CONFIG_W1_SLAVE_THERM=m
> # CONFIG_W1_SLAVE_SMEM is not set
> CONFIG_W1_SLAVE_DS2408=m
> CONFIG_W1_SLAVE_DS2408_READBACK=y
> CONFIG_W1_SLAVE_DS2413=m
> # CONFIG_W1_SLAVE_DS2423 is not set
> CONFIG_W1_SLAVE_DS2431=m
> CONFIG_W1_SLAVE_DS2433=m
> CONFIG_W1_SLAVE_DS2433_CRC=y
> # CONFIG_W1_SLAVE_DS2760 is not set
> # CONFIG_W1_SLAVE_DS2780 is not set
> CONFIG_W1_SLAVE_DS2781=m
> CONFIG_W1_SLAVE_DS28E04=m
> # CONFIG_W1_SLAVE_BQ27000 is not set
> CONFIG_POWER_SUPPLY=y
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> # CONFIG_PDA_POWER is not set
> # CONFIG_GENERIC_ADC_BATTERY is not set
> # CONFIG_WM831X_BACKUP is not set
> # CONFIG_WM831X_POWER is not set
> # CONFIG_WM8350_POWER is not set
> # CONFIG_TEST_POWER is not set
> # CONFIG_BATTERY_88PM860X is not set
> # CONFIG_BATTERY_DS2780 is not set
> # CONFIG_BATTERY_DS2781 is not set
> # CONFIG_BATTERY_DS2782 is not set
> # CONFIG_BATTERY_OLPC is not set
> # CONFIG_BATTERY_SBS is not set
> # CONFIG_BATTERY_BQ27x00 is not set
> # CONFIG_BATTERY_MAX17040 is not set
> # CONFIG_BATTERY_MAX17042 is not set
> # CONFIG_CHARGER_PCF50633 is not set
> # CONFIG_CHARGER_ISP1704 is not set
> # CONFIG_CHARGER_MAX8903 is not set
> # CONFIG_CHARGER_LP8727 is not set
> # CONFIG_CHARGER_GPIO is not set
> # CONFIG_CHARGER_BQ2415X is not set
> # CONFIG_CHARGER_SMB347 is not set
> # CONFIG_CHARGER_TPS65090 is not set
> # CONFIG_BATTERY_GOLDFISH is not set
> # CONFIG_POWER_RESET is not set
> CONFIG_POWER_AVS=y
> CONFIG_HWMON=y
> CONFIG_HWMON_VID=y
> # CONFIG_HWMON_DEBUG_CHIP is not set
> 
> #
> # Native drivers
> #
> CONFIG_SENSORS_ABITUGURU=m
> CONFIG_SENSORS_ABITUGURU3=y
> CONFIG_SENSORS_AD7314=y
> CONFIG_SENSORS_AD7414=y
> CONFIG_SENSORS_AD7418=y
> CONFIG_SENSORS_ADCXX=m
> CONFIG_SENSORS_ADM1021=m
> # CONFIG_SENSORS_ADM1025 is not set
> CONFIG_SENSORS_ADM1026=m
> CONFIG_SENSORS_ADM1029=y
> CONFIG_SENSORS_ADM1031=y
> CONFIG_SENSORS_ADM9240=y
> CONFIG_SENSORS_ADT7X10=y
> CONFIG_SENSORS_ADT7310=y
> CONFIG_SENSORS_ADT7410=m
> # CONFIG_SENSORS_ADT7411 is not set
> CONFIG_SENSORS_ADT7462=m
> CONFIG_SENSORS_ADT7470=y
> CONFIG_SENSORS_ADT7475=y
> # CONFIG_SENSORS_ASC7621 is not set
> # CONFIG_SENSORS_K8TEMP is not set
> # CONFIG_SENSORS_K10TEMP is not set
> # CONFIG_SENSORS_FAM15H_POWER is not set
> # CONFIG_SENSORS_ASB100 is not set
> CONFIG_SENSORS_ATXP1=m
> CONFIG_SENSORS_DS620=y
> # CONFIG_SENSORS_DS1621 is not set
> # CONFIG_SENSORS_I5K_AMB is not set
> CONFIG_SENSORS_F71805F=m
> CONFIG_SENSORS_F71882FG=m
> CONFIG_SENSORS_F75375S=m
> # CONFIG_SENSORS_FSCHMD is not set
> # CONFIG_SENSORS_G760A is not set
> # CONFIG_SENSORS_GL518SM is not set
> CONFIG_SENSORS_GL520SM=y
> # CONFIG_SENSORS_GPIO_FAN is not set
> # CONFIG_SENSORS_HIH6130 is not set
> CONFIG_SENSORS_CORETEMP=m
> # CONFIG_SENSORS_IBMAEM is not set
> # CONFIG_SENSORS_IBMPEX is not set
> # CONFIG_SENSORS_IIO_HWMON is not set
> CONFIG_SENSORS_IT87=y
> # CONFIG_SENSORS_JC42 is not set
> # CONFIG_SENSORS_LINEAGE is not set
> CONFIG_SENSORS_LM63=m
> # CONFIG_SENSORS_LM70 is not set
> CONFIG_SENSORS_LM73=m
> CONFIG_SENSORS_LM75=m
> CONFIG_SENSORS_LM77=m
> CONFIG_SENSORS_LM78=m
> CONFIG_SENSORS_LM80=m
> # CONFIG_SENSORS_LM83 is not set
> CONFIG_SENSORS_LM85=y
> CONFIG_SENSORS_LM87=y
> CONFIG_SENSORS_LM90=m
> CONFIG_SENSORS_LM92=y
> CONFIG_SENSORS_LM93=y
> CONFIG_SENSORS_LTC4151=m
> CONFIG_SENSORS_LTC4215=m
> # CONFIG_SENSORS_LTC4245 is not set
> # CONFIG_SENSORS_LTC4261 is not set
> # CONFIG_SENSORS_LM95234 is not set
> # CONFIG_SENSORS_LM95241 is not set
> CONFIG_SENSORS_LM95245=m
> CONFIG_SENSORS_MAX1111=y
> CONFIG_SENSORS_MAX16065=m
> CONFIG_SENSORS_MAX1619=y
> CONFIG_SENSORS_MAX1668=y
> # CONFIG_SENSORS_MAX197 is not set
> # CONFIG_SENSORS_MAX6639 is not set
> # CONFIG_SENSORS_MAX6642 is not set
> # CONFIG_SENSORS_MAX6650 is not set
> # CONFIG_SENSORS_MAX6697 is not set
> CONFIG_SENSORS_MCP3021=m
> CONFIG_SENSORS_NCT6775=m
> # CONFIG_SENSORS_NTC_THERMISTOR is not set
> CONFIG_SENSORS_PC87360=y
> CONFIG_SENSORS_PC87427=y
> # CONFIG_SENSORS_PCF8591 is not set
> # CONFIG_PMBUS is not set
> CONFIG_SENSORS_SHT15=y
> # CONFIG_SENSORS_SHT21 is not set
> # CONFIG_SENSORS_SIS5595 is not set
> # CONFIG_SENSORS_SMM665 is not set
> # CONFIG_SENSORS_DME1737 is not set
> CONFIG_SENSORS_EMC1403=m
> # CONFIG_SENSORS_EMC2103 is not set
> CONFIG_SENSORS_EMC6W201=m
> # CONFIG_SENSORS_SMSC47M1 is not set
> # CONFIG_SENSORS_SMSC47M192 is not set
> CONFIG_SENSORS_SMSC47B397=m
> # CONFIG_SENSORS_SCH56XX_COMMON is not set
> CONFIG_SENSORS_ADS1015=y
> CONFIG_SENSORS_ADS7828=y
> CONFIG_SENSORS_ADS7871=m
> CONFIG_SENSORS_AMC6821=m
> CONFIG_SENSORS_INA209=m
> # CONFIG_SENSORS_INA2XX is not set
> CONFIG_SENSORS_THMC50=y
> CONFIG_SENSORS_TMP102=y
> # CONFIG_SENSORS_TMP401 is not set
> CONFIG_SENSORS_TMP421=y
> CONFIG_SENSORS_VIA_CPUTEMP=m
> # CONFIG_SENSORS_VIA686A is not set
> CONFIG_SENSORS_VT1211=m
> # CONFIG_SENSORS_VT8231 is not set
> CONFIG_SENSORS_W83781D=m
> CONFIG_SENSORS_W83791D=y
> CONFIG_SENSORS_W83792D=m
> # CONFIG_SENSORS_W83793 is not set
> CONFIG_SENSORS_W83795=y
> CONFIG_SENSORS_W83795_FANCTRL=y
> # CONFIG_SENSORS_W83L785TS is not set
> CONFIG_SENSORS_W83L786NG=m
> CONFIG_SENSORS_W83627HF=y
> CONFIG_SENSORS_W83627EHF=y
> CONFIG_SENSORS_WM831X=y
> CONFIG_SENSORS_WM8350=m
> CONFIG_SENSORS_APPLESMC=y
> CONFIG_SENSORS_MC13783_ADC=m
> 
> #
> # ACPI drivers
> #
> # CONFIG_SENSORS_ACPI_POWER is not set
> # CONFIG_SENSORS_ATK0110 is not set
> CONFIG_THERMAL=y
> CONFIG_THERMAL_HWMON=y
> CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
> # CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
> # CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
> # CONFIG_THERMAL_GOV_FAIR_SHARE is not set
> CONFIG_THERMAL_GOV_STEP_WISE=y
> # CONFIG_THERMAL_GOV_USER_SPACE is not set
> # CONFIG_CPU_THERMAL is not set
> # CONFIG_THERMAL_EMULATION is not set
> # CONFIG_INTEL_POWERCLAMP is not set
> # CONFIG_WATCHDOG is not set
> CONFIG_SSB_POSSIBLE=y
> 
> #
> # Sonics Silicon Backplane
> #
> # CONFIG_SSB is not set
> CONFIG_BCMA_POSSIBLE=y
> 
> #
> # Broadcom specific AMBA
> #
> CONFIG_BCMA=y
> CONFIG_BCMA_HOST_PCI_POSSIBLE=y
> # CONFIG_BCMA_HOST_PCI is not set
> # CONFIG_BCMA_DRIVER_GMAC_CMN is not set
> CONFIG_BCMA_DRIVER_GPIO=y
> CONFIG_BCMA_DEBUG=y
> 
> #
> # Multifunction device drivers
> #
> CONFIG_MFD_CORE=y
> # CONFIG_MFD_CS5535 is not set
> CONFIG_MFD_AS3711=y
> CONFIG_PMIC_ADP5520=y
> # CONFIG_MFD_AAT2870_CORE is not set
> CONFIG_MFD_CROS_EC=m
> CONFIG_MFD_CROS_EC_I2C=m
> CONFIG_MFD_CROS_EC_SPI=m
> # CONFIG_PMIC_DA903X is not set
> # CONFIG_MFD_DA9052_SPI is not set
> # CONFIG_MFD_DA9052_I2C is not set
> # CONFIG_MFD_DA9055 is not set
> CONFIG_MFD_MC13783=m
> CONFIG_MFD_MC13XXX=m
> # CONFIG_MFD_MC13XXX_SPI is not set
> CONFIG_MFD_MC13XXX_I2C=m
> CONFIG_HTC_PASIC3=m
> # CONFIG_HTC_I2CPLD is not set
> # CONFIG_LPC_ICH is not set
> # CONFIG_LPC_SCH is not set
> # CONFIG_MFD_JANZ_CMODIO is not set
> CONFIG_MFD_88PM800=y
> CONFIG_MFD_88PM805=m
> CONFIG_MFD_88PM860X=y
> CONFIG_MFD_MAX77686=y
> CONFIG_MFD_MAX77693=y
> # CONFIG_MFD_MAX8907 is not set
> # CONFIG_MFD_MAX8925 is not set
> # CONFIG_MFD_MAX8997 is not set
> # CONFIG_MFD_MAX8998 is not set
> # CONFIG_EZX_PCAP is not set
> # CONFIG_MFD_RETU is not set
> CONFIG_MFD_PCF50633=m
> # CONFIG_PCF50633_ADC is not set
> CONFIG_PCF50633_GPIO=m
> # CONFIG_MFD_RDC321X is not set
> # CONFIG_MFD_RTSX_PCI is not set
> # CONFIG_MFD_RC5T583 is not set
> # CONFIG_MFD_SEC_CORE is not set
> CONFIG_MFD_SI476X_CORE=m
> # CONFIG_MFD_SM501 is not set
> CONFIG_MFD_SMSC=y
> # CONFIG_ABX500_CORE is not set
> CONFIG_MFD_STMPE=y
> 
> #
> # STMicroelectronics STMPE Interface Drivers
> #
> # CONFIG_STMPE_I2C is not set
> CONFIG_STMPE_SPI=y
> CONFIG_MFD_SYSCON=y
> CONFIG_MFD_TI_AM335X_TSCADC=m
> CONFIG_MFD_LP8788=y
> # CONFIG_MFD_PALMAS is not set
> CONFIG_TPS6105X=y
> CONFIG_TPS65010=y
> # CONFIG_TPS6507X is not set
> CONFIG_MFD_TPS65090=y
> CONFIG_MFD_TPS65217=m
> CONFIG_MFD_TPS6586X=y
> # CONFIG_MFD_TPS65910 is not set
> CONFIG_MFD_TPS65912=y
> # CONFIG_MFD_TPS65912_I2C is not set
> CONFIG_MFD_TPS65912_SPI=y
> CONFIG_MFD_TPS80031=y
> # CONFIG_TWL4030_CORE is not set
> # CONFIG_TWL6040_CORE is not set
> CONFIG_MFD_WL1273_CORE=m
> CONFIG_MFD_LM3533=y
> # CONFIG_MFD_TIMBERDALE is not set
> CONFIG_MFD_TC3589X=y
> # CONFIG_MFD_TMIO is not set
> # CONFIG_MFD_VX855 is not set
> CONFIG_MFD_ARIZONA=y
> CONFIG_MFD_ARIZONA_I2C=m
> # CONFIG_MFD_ARIZONA_SPI is not set
> # CONFIG_MFD_WM5102 is not set
> CONFIG_MFD_WM5110=y
> # CONFIG_MFD_WM8400 is not set
> CONFIG_MFD_WM831X=y
> CONFIG_MFD_WM831X_I2C=y
> # CONFIG_MFD_WM831X_SPI is not set
> CONFIG_MFD_WM8350=y
> CONFIG_MFD_WM8350_I2C=y
> # CONFIG_MFD_WM8994 is not set
> CONFIG_REGULATOR=y
> CONFIG_REGULATOR_DEBUG=y
> CONFIG_REGULATOR_DUMMY=y
> CONFIG_REGULATOR_FIXED_VOLTAGE=y
> CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
> CONFIG_REGULATOR_USERSPACE_CONSUMER=y
> CONFIG_REGULATOR_GPIO=y
> CONFIG_REGULATOR_AD5398=m
> CONFIG_REGULATOR_ARIZONA=m
> CONFIG_REGULATOR_FAN53555=y
> CONFIG_REGULATOR_ANATOP=m
> CONFIG_REGULATOR_MC13XXX_CORE=m
> CONFIG_REGULATOR_MC13783=m
> CONFIG_REGULATOR_MC13892=m
> CONFIG_REGULATOR_ISL6271A=m
> CONFIG_REGULATOR_88PM8607=y
> # CONFIG_REGULATOR_MAX1586 is not set
> # CONFIG_REGULATOR_MAX8649 is not set
> CONFIG_REGULATOR_MAX8660=m
> CONFIG_REGULATOR_MAX8952=m
> # CONFIG_REGULATOR_MAX8973 is not set
> CONFIG_REGULATOR_MAX77686=m
> # CONFIG_REGULATOR_LP3971 is not set
> CONFIG_REGULATOR_LP3972=m
> CONFIG_REGULATOR_LP872X=y
> CONFIG_REGULATOR_LP8755=y
> CONFIG_REGULATOR_LP8788=y
> CONFIG_REGULATOR_PCF50633=m
> CONFIG_REGULATOR_TPS51632=m
> CONFIG_REGULATOR_TPS6105X=m
> CONFIG_REGULATOR_TPS62360=y
> # CONFIG_REGULATOR_TPS65023 is not set
> CONFIG_REGULATOR_TPS6507X=m
> CONFIG_REGULATOR_TPS65090=m
> # CONFIG_REGULATOR_TPS65217 is not set
> CONFIG_REGULATOR_TPS6524X=m
> # CONFIG_REGULATOR_TPS6586X is not set
> CONFIG_REGULATOR_TPS65912=y
> CONFIG_REGULATOR_TPS80031=y
> # CONFIG_REGULATOR_WM831X is not set
> CONFIG_REGULATOR_WM8350=y
> CONFIG_REGULATOR_AS3711=y
> # CONFIG_MEDIA_SUPPORT is not set
> 
> #
> # Graphics support
> #
> # CONFIG_AGP is not set
> CONFIG_VGA_ARB=y
> CONFIG_VGA_ARB_MAX_GPUS=16
> # CONFIG_VGA_SWITCHEROO is not set
> CONFIG_DRM=y
> # CONFIG_DRM_TDFX is not set
> # CONFIG_DRM_R128 is not set
> # CONFIG_DRM_RADEON is not set
> # CONFIG_DRM_NOUVEAU is not set
> # CONFIG_DRM_MGA is not set
> # CONFIG_DRM_VIA is not set
> # CONFIG_DRM_SAVAGE is not set
> # CONFIG_DRM_VMWGFX is not set
> # CONFIG_DRM_GMA500 is not set
> # CONFIG_DRM_UDL is not set
> # CONFIG_DRM_AST is not set
> # CONFIG_DRM_MGAG200 is not set
> # CONFIG_DRM_CIRRUS_QEMU is not set
> # CONFIG_DRM_QXL is not set
> # CONFIG_VGASTATE is not set
> CONFIG_VIDEO_OUTPUT_CONTROL=y
> CONFIG_HDMI=y
> CONFIG_FB=m
> CONFIG_FIRMWARE_EDID=y
> # CONFIG_FB_DDC is not set
> # CONFIG_FB_BOOT_VESA_SUPPORT is not set
> CONFIG_FB_CFB_FILLRECT=m
> CONFIG_FB_CFB_COPYAREA=m
> CONFIG_FB_CFB_IMAGEBLIT=m
> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> CONFIG_FB_SYS_FILLRECT=m
> CONFIG_FB_SYS_COPYAREA=m
> CONFIG_FB_SYS_IMAGEBLIT=m
> CONFIG_FB_FOREIGN_ENDIAN=y
> # CONFIG_FB_BOTH_ENDIAN is not set
> CONFIG_FB_BIG_ENDIAN=y
> # CONFIG_FB_LITTLE_ENDIAN is not set
> CONFIG_FB_SYS_FOPS=m
> CONFIG_FB_DEFERRED_IO=y
> CONFIG_FB_HECUBA=m
> # CONFIG_FB_SVGALIB is not set
> # CONFIG_FB_MACMODES is not set
> # CONFIG_FB_BACKLIGHT is not set
> CONFIG_FB_MODE_HELPERS=y
> # CONFIG_FB_TILEBLITTING is not set
> 
> #
> # Frame buffer hardware drivers
> #
> # CONFIG_FB_CIRRUS is not set
> # CONFIG_FB_PM2 is not set
> # CONFIG_FB_CYBER2000 is not set
> CONFIG_FB_ARC=m
> # CONFIG_FB_VGA16 is not set
> CONFIG_FB_N411=m
> CONFIG_FB_HGA=m
> # CONFIG_FB_S1D13XXX is not set
> # CONFIG_FB_NVIDIA is not set
> # CONFIG_FB_RIVA is not set
> # CONFIG_FB_I740 is not set
> # CONFIG_FB_LE80578 is not set
> # CONFIG_FB_MATROX is not set
> # CONFIG_FB_RADEON is not set
> # CONFIG_FB_ATY128 is not set
> # CONFIG_FB_ATY is not set
> # CONFIG_FB_S3 is not set
> # CONFIG_FB_SAVAGE is not set
> # CONFIG_FB_SIS is not set
> # CONFIG_FB_VIA is not set
> # CONFIG_FB_NEOMAGIC is not set
> # CONFIG_FB_KYRO is not set
> # CONFIG_FB_3DFX is not set
> # CONFIG_FB_VOODOO1 is not set
> # CONFIG_FB_VT8623 is not set
> # CONFIG_FB_TRIDENT is not set
> # CONFIG_FB_ARK is not set
> # CONFIG_FB_PM3 is not set
> # CONFIG_FB_CARMINE is not set
> # CONFIG_FB_GEODE is not set
> CONFIG_FB_TMIO=m
> # CONFIG_FB_TMIO_ACCELL is not set
> # CONFIG_FB_GOLDFISH is not set
> CONFIG_FB_VIRTUAL=m
> # CONFIG_FB_METRONOME is not set
> # CONFIG_FB_MB862XX is not set
> CONFIG_FB_BROADSHEET=m
> CONFIG_FB_AUO_K190X=m
> CONFIG_FB_AUO_K1900=m
> CONFIG_FB_AUO_K1901=m
> CONFIG_EXYNOS_VIDEO=y
> # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
> CONFIG_BACKLIGHT_CLASS_DEVICE=m
> 
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> CONFIG_VGACON_SOFT_SCROLLBACK=y
> CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
> # CONFIG_MDA_CONSOLE is not set
> CONFIG_DUMMY_CONSOLE=y
> # CONFIG_FRAMEBUFFER_CONSOLE is not set
> CONFIG_LOGO=y
> CONFIG_LOGO_LINUX_MONO=y
> CONFIG_LOGO_LINUX_VGA16=y
> CONFIG_LOGO_LINUX_CLUT224=y
> # CONFIG_FB_SSD1307 is not set
> CONFIG_SOUND=y
> CONFIG_SOUND_OSS_CORE=y
> CONFIG_SOUND_OSS_CORE_PRECLAIM=y
> CONFIG_SND=y
> CONFIG_SND_TIMER=y
> CONFIG_SND_PCM=y
> CONFIG_SND_RAWMIDI=m
> CONFIG_SND_COMPRESS_OFFLOAD=y
> CONFIG_SND_JACK=y
> CONFIG_SND_SEQUENCER=y
> CONFIG_SND_SEQ_DUMMY=y
> CONFIG_SND_OSSEMUL=y
> CONFIG_SND_MIXER_OSS=m
> # CONFIG_SND_PCM_OSS is not set
> CONFIG_SND_SEQUENCER_OSS=y
> # CONFIG_SND_DYNAMIC_MINORS is not set
> # CONFIG_SND_SUPPORT_OLD_API is not set
> # CONFIG_SND_VERBOSE_PROCFS is not set
> CONFIG_SND_VERBOSE_PRINTK=y
> # CONFIG_SND_DEBUG is not set
> CONFIG_SND_DMA_SGBUF=y
> CONFIG_SND_RAWMIDI_SEQ=m
> # CONFIG_SND_OPL3_LIB_SEQ is not set
> # CONFIG_SND_OPL4_LIB_SEQ is not set
> # CONFIG_SND_SBAWE_SEQ is not set
> # CONFIG_SND_EMU10K1_SEQ is not set
> # CONFIG_SND_DRIVERS is not set
> # CONFIG_SND_ISA is not set
> CONFIG_SND_PCI=y
> # CONFIG_SND_AD1889 is not set
> # CONFIG_SND_ALS300 is not set
> # CONFIG_SND_ALS4000 is not set
> # CONFIG_SND_ALI5451 is not set
> # CONFIG_SND_ASIHPI is not set
> # CONFIG_SND_ATIIXP is not set
> # CONFIG_SND_ATIIXP_MODEM is not set
> # CONFIG_SND_AU8810 is not set
> # CONFIG_SND_AU8820 is not set
> # CONFIG_SND_AU8830 is not set
> # CONFIG_SND_AW2 is not set
> # CONFIG_SND_AZT3328 is not set
> # CONFIG_SND_BT87X is not set
> # CONFIG_SND_CA0106 is not set
> # CONFIG_SND_CMIPCI is not set
> # CONFIG_SND_OXYGEN is not set
> # CONFIG_SND_CS4281 is not set
> # CONFIG_SND_CS46XX is not set
> # CONFIG_SND_CS5530 is not set
> # CONFIG_SND_CS5535AUDIO is not set
> # CONFIG_SND_CTXFI is not set
> # CONFIG_SND_DARLA20 is not set
> # CONFIG_SND_GINA20 is not set
> # CONFIG_SND_LAYLA20 is not set
> # CONFIG_SND_DARLA24 is not set
> # CONFIG_SND_GINA24 is not set
> # CONFIG_SND_LAYLA24 is not set
> # CONFIG_SND_MONA is not set
> # CONFIG_SND_MIA is not set
> # CONFIG_SND_ECHO3G is not set
> # CONFIG_SND_INDIGO is not set
> # CONFIG_SND_INDIGOIO is not set
> # CONFIG_SND_INDIGODJ is not set
> # CONFIG_SND_INDIGOIOX is not set
> # CONFIG_SND_INDIGODJX is not set
> # CONFIG_SND_EMU10K1 is not set
> # CONFIG_SND_EMU10K1X is not set
> # CONFIG_SND_ENS1370 is not set
> # CONFIG_SND_ENS1371 is not set
> # CONFIG_SND_ES1938 is not set
> # CONFIG_SND_ES1968 is not set
> # CONFIG_SND_FM801 is not set
> # CONFIG_SND_HDA_INTEL is not set
> # CONFIG_SND_HDSP is not set
> # CONFIG_SND_HDSPM is not set
> # CONFIG_SND_ICE1712 is not set
> # CONFIG_SND_ICE1724 is not set
> # CONFIG_SND_INTEL8X0 is not set
> # CONFIG_SND_INTEL8X0M is not set
> # CONFIG_SND_KORG1212 is not set
> # CONFIG_SND_LOLA is not set
> # CONFIG_SND_LX6464ES is not set
> # CONFIG_SND_MAESTRO3 is not set
> # CONFIG_SND_MIXART is not set
> # CONFIG_SND_NM256 is not set
> # CONFIG_SND_PCXHR is not set
> # CONFIG_SND_RIPTIDE is not set
> # CONFIG_SND_RME32 is not set
> # CONFIG_SND_RME96 is not set
> # CONFIG_SND_RME9652 is not set
> # CONFIG_SND_SIS7019 is not set
> # CONFIG_SND_SONICVIBES is not set
> # CONFIG_SND_TRIDENT is not set
> # CONFIG_SND_VIA82XX is not set
> # CONFIG_SND_VIA82XX_MODEM is not set
> # CONFIG_SND_VIRTUOSO is not set
> # CONFIG_SND_VX222 is not set
> # CONFIG_SND_YMFPCI is not set
> CONFIG_SND_SPI=y
> CONFIG_SND_AT73C213=m
> CONFIG_SND_AT73C213_TARGET_BITRATE=48000
> CONFIG_SND_SOC=y
> # CONFIG_SND_ATMEL_SOC is not set
> CONFIG_SND_SOC_I2C_AND_SPI=y
> CONFIG_SND_SOC_ALL_CODECS=y
> CONFIG_SND_SOC_88PM860X=y
> CONFIG_SND_SOC_ARIZONA=y
> CONFIG_SND_SOC_WM_HUBS=y
> CONFIG_SND_SOC_WM_ADSP=y
> CONFIG_SND_SOC_AD1836=y
> CONFIG_SND_SOC_AD193X=y
> CONFIG_SND_SOC_AD73311=y
> CONFIG_SND_SOC_ADAU1373=y
> CONFIG_SND_SOC_ADAV80X=y
> CONFIG_SND_SOC_ADS117X=y
> CONFIG_SND_SOC_AK4104=y
> CONFIG_SND_SOC_AK4535=y
> CONFIG_SND_SOC_AK4641=y
> CONFIG_SND_SOC_AK4642=y
> CONFIG_SND_SOC_AK4671=y
> CONFIG_SND_SOC_AK5386=y
> CONFIG_SND_SOC_ALC5623=y
> CONFIG_SND_SOC_ALC5632=y
> CONFIG_SND_SOC_CS42L51=y
> CONFIG_SND_SOC_CS42L52=y
> CONFIG_SND_SOC_CS42L73=y
> CONFIG_SND_SOC_CS4270=y
> CONFIG_SND_SOC_CS4271=y
> CONFIG_SND_SOC_CX20442=y
> CONFIG_SND_SOC_JZ4740_CODEC=y
> CONFIG_SND_SOC_L3=y
> CONFIG_SND_SOC_DA7210=y
> CONFIG_SND_SOC_DA7213=y
> CONFIG_SND_SOC_DA732X=y
> CONFIG_SND_SOC_DA9055=y
> CONFIG_SND_SOC_DFBMCS320=y
> CONFIG_SND_SOC_ISABELLE=y
> CONFIG_SND_SOC_LM49453=y
> CONFIG_SND_SOC_MAX98088=y
> CONFIG_SND_SOC_MAX98090=y
> CONFIG_SND_SOC_MAX98095=y
> CONFIG_SND_SOC_MAX9850=y
> CONFIG_SND_SOC_PCM3008=y
> CONFIG_SND_SOC_RT5631=y
> CONFIG_SND_SOC_SGTL5000=y
> CONFIG_SND_SOC_SI476X=m
> CONFIG_SND_SOC_SPDIF=y
> CONFIG_SND_SOC_SSM2602=y
> CONFIG_SND_SOC_STA32X=y
> CONFIG_SND_SOC_STA529=y
> CONFIG_SND_SOC_TAS5086=y
> CONFIG_SND_SOC_TLV320AIC23=y
> CONFIG_SND_SOC_TLV320AIC26=y
> CONFIG_SND_SOC_TLV320AIC32X4=y
> CONFIG_SND_SOC_TLV320AIC3X=y
> CONFIG_SND_SOC_TLV320DAC33=y
> CONFIG_SND_SOC_UDA134X=y
> CONFIG_SND_SOC_UDA1380=y
> CONFIG_SND_SOC_WL1273=m
> CONFIG_SND_SOC_WM0010=y
> CONFIG_SND_SOC_WM1250_EV1=y
> CONFIG_SND_SOC_WM2000=y
> CONFIG_SND_SOC_WM2200=y
> CONFIG_SND_SOC_WM5100=y
> CONFIG_SND_SOC_WM5110=y
> CONFIG_SND_SOC_WM8350=y
> CONFIG_SND_SOC_WM8510=y
> CONFIG_SND_SOC_WM8523=y
> CONFIG_SND_SOC_WM8580=y
> CONFIG_SND_SOC_WM8711=y
> CONFIG_SND_SOC_WM8727=y
> CONFIG_SND_SOC_WM8728=y
> CONFIG_SND_SOC_WM8731=y
> CONFIG_SND_SOC_WM8737=y
> CONFIG_SND_SOC_WM8741=y
> CONFIG_SND_SOC_WM8750=y
> CONFIG_SND_SOC_WM8753=y
> CONFIG_SND_SOC_WM8770=y
> CONFIG_SND_SOC_WM8776=y
> CONFIG_SND_SOC_WM8782=y
> CONFIG_SND_SOC_WM8804=y
> CONFIG_SND_SOC_WM8900=y
> CONFIG_SND_SOC_WM8903=y
> CONFIG_SND_SOC_WM8904=y
> CONFIG_SND_SOC_WM8940=y
> CONFIG_SND_SOC_WM8955=y
> CONFIG_SND_SOC_WM8960=y
> CONFIG_SND_SOC_WM8961=y
> CONFIG_SND_SOC_WM8962=y
> CONFIG_SND_SOC_WM8971=y
> CONFIG_SND_SOC_WM8974=y
> CONFIG_SND_SOC_WM8978=y
> CONFIG_SND_SOC_WM8983=y
> CONFIG_SND_SOC_WM8985=y
> CONFIG_SND_SOC_WM8988=y
> CONFIG_SND_SOC_WM8990=y
> CONFIG_SND_SOC_WM8991=y
> CONFIG_SND_SOC_WM8993=y
> CONFIG_SND_SOC_WM8995=y
> CONFIG_SND_SOC_WM8996=y
> CONFIG_SND_SOC_WM9081=y
> CONFIG_SND_SOC_WM9090=y
> CONFIG_SND_SOC_LM4857=y
> CONFIG_SND_SOC_MAX9768=y
> CONFIG_SND_SOC_MAX9877=y
> CONFIG_SND_SOC_MC13783=m
> CONFIG_SND_SOC_ML26124=y
> CONFIG_SND_SOC_TPA6130A2=y
> CONFIG_SND_SIMPLE_CARD=y
> CONFIG_SOUND_PRIME=y
> # CONFIG_SOUND_MSNDCLAS is not set
> # CONFIG_SOUND_MSNDPIN is not set
> CONFIG_SOUND_OSS=m
> # CONFIG_SOUND_TRACEINIT is not set
> # CONFIG_SOUND_DMAP is not set
> # CONFIG_SOUND_VMIDI is not set
> CONFIG_SOUND_TRIX=m
> # CONFIG_SOUND_MSS is not set
> CONFIG_SOUND_MPU401=m
> # CONFIG_SOUND_PAS is not set
> CONFIG_SOUND_PSS=m
> CONFIG_PSS_MIXER=y
> CONFIG_SOUND_SB=m
> CONFIG_SOUND_YM3812=m
> CONFIG_SOUND_UART6850=m
> CONFIG_SOUND_AEDSP16=m
> CONFIG_SC6600=y
> CONFIG_SC6600_JOY=y
> CONFIG_SC6600_CDROM=4
> CONFIG_SC6600_CDROMBASE=0
> CONFIG_SOUND_KAHLUA=m
> 
> #
> # HID support
> #
> # CONFIG_HID is not set
> 
> #
> # I2C HID support
> #
> # CONFIG_I2C_HID is not set
> CONFIG_USB_ARCH_HAS_OHCI=y
> CONFIG_USB_ARCH_HAS_EHCI=y
> CONFIG_USB_ARCH_HAS_XHCI=y
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_COMMON=y
> CONFIG_USB_ARCH_HAS_HCD=y
> # CONFIG_USB is not set
> CONFIG_USB_DWC3=y
> CONFIG_USB_DWC3_GADGET=y
> CONFIG_USB_DWC3_DEBUG=y
> CONFIG_USB_DWC3_VERBOSE=y
> CONFIG_USB_CHIPIDEA=y
> # CONFIG_USB_CHIPIDEA_UDC is not set
> CONFIG_USB_CHIPIDEA_DEBUG=y
> 
> #
> # USB port drivers
> #
> CONFIG_USB_PHY=y
> # CONFIG_NOP_USB_XCEIV is not set
> # CONFIG_OMAP_CONTROL_USB is not set
> # CONFIG_OMAP_USB3 is not set
> CONFIG_SAMSUNG_USBPHY=y
> CONFIG_SAMSUNG_USB2PHY=y
> # CONFIG_SAMSUNG_USB3PHY is not set
> CONFIG_USB_GPIO_VBUS=m
> # CONFIG_USB_ISP1301 is not set
> CONFIG_USB_RCAR_PHY=y
> CONFIG_USB_GADGET=y
> CONFIG_USB_GADGET_DEBUG=y
> CONFIG_USB_GADGET_DEBUG_FILES=y
> CONFIG_USB_GADGET_DEBUG_FS=y
> CONFIG_USB_GADGET_VBUS_DRAW=2
> CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2
> 
> #
> # USB Peripheral Controller
> #
> CONFIG_USB_FUSB300=y
> # CONFIG_USB_R8A66597 is not set
> CONFIG_USB_PXA27X=y
> CONFIG_USB_MV_UDC=y
> # CONFIG_USB_MV_U3D is not set
> CONFIG_USB_M66592=m
> # CONFIG_USB_AMD5536UDC is not set
> # CONFIG_USB_NET2272 is not set
> # CONFIG_USB_NET2280 is not set
> # CONFIG_USB_GOKU is not set
> # CONFIG_USB_EG20T is not set
> CONFIG_USB_LIBCOMPOSITE=m
> CONFIG_USB_F_SS_LB=m
> CONFIG_USB_ZERO=m
> CONFIG_USB_AUDIO=m
> CONFIG_GADGET_UAC1=y
> # CONFIG_USB_ETH is not set
> # CONFIG_USB_G_NCM is not set
> # CONFIG_USB_GADGETFS is not set
> CONFIG_USB_FUNCTIONFS=m
> # CONFIG_USB_FUNCTIONFS_ETH is not set
> # CONFIG_USB_FUNCTIONFS_RNDIS is not set
> CONFIG_USB_FUNCTIONFS_GENERIC=y
> CONFIG_USB_MASS_STORAGE=m
> # CONFIG_USB_G_SERIAL is not set
> CONFIG_USB_MIDI_GADGET=m
> CONFIG_USB_G_PRINTER=m
> # CONFIG_USB_CDC_COMPOSITE is not set
> # CONFIG_USB_G_ACM_MS is not set
> # CONFIG_USB_G_MULTI is not set
> CONFIG_USB_G_HID=m
> # CONFIG_USB_G_DBGP is not set
> # CONFIG_UWB is not set
> CONFIG_MMC=y
> CONFIG_MMC_DEBUG=y
> CONFIG_MMC_UNSAFE_RESUME=y
> # CONFIG_MMC_CLKGATE is not set
> 
> #
> # MMC/SD/SDIO Card Drivers
> #
> CONFIG_MMC_BLOCK=m
> CONFIG_MMC_BLOCK_MINORS=8
> # CONFIG_MMC_BLOCK_BOUNCE is not set
> # CONFIG_SDIO_UART is not set
> # CONFIG_MMC_TEST is not set
> 
> #
> # MMC/SD/SDIO Host Controller Drivers
> #
> CONFIG_MMC_SDHCI=m
> # CONFIG_MMC_SDHCI_PCI is not set
> # CONFIG_MMC_SDHCI_ACPI is not set
> CONFIG_MMC_SDHCI_PLTFM=m
> # CONFIG_MMC_WBSD is not set
> # CONFIG_MMC_TIFM_SD is not set
> # CONFIG_MMC_GOLDFISH is not set
> # CONFIG_MMC_CB710 is not set
> # CONFIG_MMC_VIA_SDMMC is not set
> CONFIG_MEMSTICK=m
> # CONFIG_MEMSTICK_DEBUG is not set
> 
> #
> # MemoryStick drivers
> #
> CONFIG_MEMSTICK_UNSAFE_RESUME=y
> # CONFIG_MSPRO_BLOCK is not set
> 
> #
> # MemoryStick Host Controller Drivers
> #
> # CONFIG_MEMSTICK_TIFM_MS is not set
> # CONFIG_MEMSTICK_JMICRON_38X is not set
> # CONFIG_MEMSTICK_R592 is not set
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=y
> 
> #
> # LED drivers
> #
> # CONFIG_LEDS_88PM860X is not set
> CONFIG_LEDS_LM3530=m
> CONFIG_LEDS_LM3533=m
> # CONFIG_LEDS_LM3642 is not set
> CONFIG_LEDS_PCA9532=m
> # CONFIG_LEDS_PCA9532_GPIO is not set
> CONFIG_LEDS_GPIO=y
> # CONFIG_LEDS_LP3944 is not set
> CONFIG_LEDS_LP55XX_COMMON=y
> CONFIG_LEDS_LP5521=m
> CONFIG_LEDS_LP5523=y
> CONFIG_LEDS_LP5562=y
> # CONFIG_LEDS_LP8788 is not set
> CONFIG_LEDS_CLEVO_MAIL=y
> CONFIG_LEDS_PCA955X=y
> # CONFIG_LEDS_PCA9633 is not set
> CONFIG_LEDS_WM831X_STATUS=y
> CONFIG_LEDS_WM8350=y
> # CONFIG_LEDS_DAC124S085 is not set
> CONFIG_LEDS_REGULATOR=y
> CONFIG_LEDS_BD2802=y
> # CONFIG_LEDS_INTEL_SS4200 is not set
> # CONFIG_LEDS_LT3593 is not set
> # CONFIG_LEDS_ADP5520 is not set
> # CONFIG_LEDS_MC13783 is not set
> # CONFIG_LEDS_TCA6507 is not set
> # CONFIG_LEDS_LM355x is not set
> CONFIG_LEDS_OT200=m
> # CONFIG_LEDS_BLINKM is not set
> 
> #
> # LED Triggers
> #
> # CONFIG_LEDS_TRIGGERS is not set
> # CONFIG_ACCESSIBILITY is not set
> # CONFIG_INFINIBAND is not set
> # CONFIG_EDAC is not set
> CONFIG_RTC_LIB=y
> # CONFIG_RTC_CLASS is not set
> CONFIG_DMADEVICES=y
> CONFIG_DMADEVICES_DEBUG=y
> # CONFIG_DMADEVICES_VDEBUG is not set
> 
> #
> # DMA Devices
> #
> # CONFIG_INTEL_MID_DMAC is not set
> # CONFIG_INTEL_IOATDMA is not set
> CONFIG_DW_DMAC=y
> # CONFIG_DW_DMAC_BIG_ENDIAN_IO is not set
> CONFIG_TIMB_DMA=m
> # CONFIG_PCH_DMA is not set
> CONFIG_DMA_ENGINE=y
> CONFIG_DMA_ACPI=y
> CONFIG_DMA_OF=y
> 
> #
> # DMA Clients
> #
> # CONFIG_NET_DMA is not set
> CONFIG_ASYNC_TX_DMA=y
> CONFIG_DMATEST=y
> # CONFIG_AUXDISPLAY is not set
> CONFIG_UIO=y
> # CONFIG_UIO_CIF is not set
> # CONFIG_UIO_PDRV is not set
> CONFIG_UIO_PDRV_GENIRQ=y
> CONFIG_UIO_DMEM_GENIRQ=y
> # CONFIG_UIO_AEC is not set
> # CONFIG_UIO_SERCOS3 is not set
> # CONFIG_UIO_PCI_GENERIC is not set
> # CONFIG_UIO_NETX is not set
> CONFIG_VIRT_DRIVERS=y
> CONFIG_VIRTIO=y
> 
> #
> # Virtio drivers
> #
> # CONFIG_VIRTIO_PCI is not set
> CONFIG_VIRTIO_BALLOON=m
> CONFIG_VIRTIO_MMIO=m
> CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y
> 
> #
> # Microsoft Hyper-V guest support
> #
> # CONFIG_HYPERV is not set
> # CONFIG_STAGING is not set
> CONFIG_X86_PLATFORM_DEVICES=y
> # CONFIG_ACERHDF is not set
> # CONFIG_ASUS_LAPTOP is not set
> CONFIG_CHROMEOS_LAPTOP=y
> # CONFIG_DELL_LAPTOP is not set
> # CONFIG_FUJITSU_LAPTOP is not set
> # CONFIG_FUJITSU_TABLET is not set
> # CONFIG_HP_ACCEL is not set
> # CONFIG_PANASONIC_LAPTOP is not set
> # CONFIG_THINKPAD_ACPI is not set
> CONFIG_SENSORS_HDAPS=m
> # CONFIG_INTEL_MENLOW is not set
> # CONFIG_ACPI_WMI is not set
> # CONFIG_TOPSTAR_LAPTOP is not set
> # CONFIG_TOSHIBA_BT_RFKILL is not set
> # CONFIG_ACPI_CMPC is not set
> # CONFIG_INTEL_IPS is not set
> # CONFIG_IBM_RTL is not set
> # CONFIG_XO15_EBOOK is not set
> CONFIG_SAMSUNG_LAPTOP=m
> CONFIG_SAMSUNG_Q10=m
> # CONFIG_APPLE_GMUX is not set
> # CONFIG_PVPANIC is not set
> CONFIG_GOLDFISH_PIPE=m
> 
> #
> # Hardware Spinlock drivers
> #
> CONFIG_CLKSRC_I8253=y
> CONFIG_CLKEVT_I8253=y
> CONFIG_I8253_LOCK=y
> CONFIG_CLKBLD_I8253=y
> CONFIG_MAILBOX=y
> CONFIG_IOMMU_SUPPORT=y
> CONFIG_OF_IOMMU=y
> 
> #
> # Remoteproc drivers
> #
> # CONFIG_STE_MODEM_RPROC is not set
> 
> #
> # Rpmsg drivers
> #
> # CONFIG_PM_DEVFREQ is not set
> CONFIG_EXTCON=m
> 
> #
> # Extcon Device Drivers
> #
> CONFIG_EXTCON_GPIO=m
> CONFIG_EXTCON_ADC_JACK=m
> CONFIG_EXTCON_MAX77693=m
> # CONFIG_EXTCON_ARIZONA is not set
> # CONFIG_MEMORY is not set
> CONFIG_IIO=m
> CONFIG_IIO_BUFFER=y
> # CONFIG_IIO_BUFFER_CB is not set
> CONFIG_IIO_KFIFO_BUF=m
> CONFIG_IIO_TRIGGERED_BUFFER=m
> CONFIG_IIO_TRIGGER=y
> CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
> 
> #
> # Accelerometers
> #
> CONFIG_KXSD9=m
> # CONFIG_IIO_ST_ACCEL_3AXIS is not set
> 
> #
> # Analog to digital converters
> #
> CONFIG_AD_SIGMA_DELTA=m
> CONFIG_AD7266=m
> CONFIG_AD7298=m
> # CONFIG_AD7923 is not set
> CONFIG_AD7791=m
> # CONFIG_AD7793 is not set
> # CONFIG_AD7476 is not set
> # CONFIG_AD7887 is not set
> CONFIG_EXYNOS_ADC=y
> # CONFIG_LP8788_ADC is not set
> # CONFIG_MAX1363 is not set
> CONFIG_TI_ADC081C=m
> CONFIG_TI_AM335X_ADC=m
> 
> #
> # Amplifiers
> #
> # CONFIG_AD8366 is not set
> 
> #
> # Hid Sensor IIO Common
> #
> CONFIG_IIO_ST_SENSORS_I2C=m
> CONFIG_IIO_ST_SENSORS_SPI=m
> CONFIG_IIO_ST_SENSORS_CORE=m
> 
> #
> # Digital to analog converters
> #
> CONFIG_AD5064=m
> CONFIG_AD5360=m
> CONFIG_AD5380=m
> CONFIG_AD5421=m
> # CONFIG_AD5624R_SPI is not set
> CONFIG_AD5446=m
> CONFIG_AD5449=m
> CONFIG_AD5504=m
> CONFIG_AD5755=m
> CONFIG_AD5764=m
> CONFIG_AD5791=m
> CONFIG_AD5686=m
> CONFIG_MAX517=m
> CONFIG_MCP4725=m
> 
> #
> # Frequency Synthesizers DDS/PLL
> #
> 
> #
> # Clock Generator/Distribution
> #
> CONFIG_AD9523=m
> 
> #
> # Phase-Locked Loop (PLL) frequency synthesizers
> #
> # CONFIG_ADF4350 is not set
> 
> #
> # Digital gyroscope sensors
> #
> # CONFIG_ADIS16080 is not set
> CONFIG_ADIS16136=m
> CONFIG_ADXRS450=m
> CONFIG_IIO_ST_GYRO_3AXIS=m
> CONFIG_IIO_ST_GYRO_I2C_3AXIS=m
> CONFIG_IIO_ST_GYRO_SPI_3AXIS=m
> CONFIG_ITG3200=m
> 
> #
> # Inertial measurement units
> #
> CONFIG_ADIS16400=m
> CONFIG_ADIS16480=m
> CONFIG_IIO_ADIS_LIB=m
> CONFIG_IIO_ADIS_LIB_BUFFER=y
> # CONFIG_INV_MPU6050_IIO is not set
> 
> #
> # Light sensors
> #
> CONFIG_ADJD_S311=m
> # CONFIG_SENSORS_LM3533 is not set
> CONFIG_SENSORS_TSL2563=m
> CONFIG_VCNL4000=m
> 
> #
> # Magnetometer sensors
> #
> CONFIG_AK8975=m
> # CONFIG_IIO_ST_MAGN_3AXIS is not set
> # CONFIG_VME_BUS is not set
> # CONFIG_PWM is not set
> CONFIG_IRQCHIP=y
> CONFIG_IPACK_BUS=m
> # CONFIG_BOARD_TPCI200 is not set
> CONFIG_SERIAL_IPOCTAL=m
> # CONFIG_RESET_CONTROLLER is not set
> 
> #
> # Firmware Drivers
> #
> CONFIG_EDD=m
> # CONFIG_EDD_OFF is not set
> CONFIG_FIRMWARE_MEMMAP=y
> CONFIG_DELL_RBU=y
> CONFIG_DCDBAS=m
> # CONFIG_DMIID is not set
> CONFIG_DMI_SYSFS=y
> # CONFIG_ISCSI_IBFT_FIND is not set
> # CONFIG_GOOGLE_FIRMWARE is not set
> 
> #
> # File systems
> #
> CONFIG_DCACHE_WORD_ACCESS=y
> # CONFIG_EXT2_FS is not set
> # CONFIG_EXT3_FS is not set
> # CONFIG_EXT4_FS is not set
> CONFIG_REISERFS_FS=y
> CONFIG_REISERFS_CHECK=y
> # CONFIG_REISERFS_PROC_INFO is not set
> CONFIG_REISERFS_FS_XATTR=y
> CONFIG_REISERFS_FS_POSIX_ACL=y
> CONFIG_REISERFS_FS_SECURITY=y
> CONFIG_JFS_FS=m
> # CONFIG_JFS_POSIX_ACL is not set
> # CONFIG_JFS_SECURITY is not set
> # CONFIG_JFS_DEBUG is not set
> # CONFIG_JFS_STATISTICS is not set
> CONFIG_XFS_FS=m
> CONFIG_XFS_QUOTA=y
> # CONFIG_XFS_POSIX_ACL is not set
> # CONFIG_XFS_RT is not set
> CONFIG_XFS_WARN=y
> # CONFIG_XFS_DEBUG is not set
> CONFIG_GFS2_FS=m
> # CONFIG_OCFS2_FS is not set
> # CONFIG_BTRFS_FS is not set
> CONFIG_NILFS2_FS=m
> CONFIG_FS_POSIX_ACL=y
> CONFIG_EXPORTFS=m
> CONFIG_FILE_LOCKING=y
> CONFIG_FSNOTIFY=y
> CONFIG_DNOTIFY=y
> CONFIG_INOTIFY_USER=y
> # CONFIG_FANOTIFY is not set
> CONFIG_QUOTA=y
> # CONFIG_QUOTA_NETLINK_INTERFACE is not set
> CONFIG_PRINT_QUOTA_WARNING=y
> CONFIG_QUOTA_DEBUG=y
> CONFIG_QUOTA_TREE=m
> # CONFIG_QFMT_V1 is not set
> CONFIG_QFMT_V2=m
> CONFIG_QUOTACTL=y
> # CONFIG_AUTOFS4_FS is not set
> # CONFIG_FUSE_FS is not set
> 
> #
> # Caches
> #
> CONFIG_FSCACHE=y
> # CONFIG_FSCACHE_STATS is not set
> # CONFIG_FSCACHE_HISTOGRAM is not set
> # CONFIG_FSCACHE_DEBUG is not set
> CONFIG_FSCACHE_OBJECT_LIST=y
> CONFIG_CACHEFILES=m
> CONFIG_CACHEFILES_DEBUG=y
> CONFIG_CACHEFILES_HISTOGRAM=y
> 
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=m
> CONFIG_JOLIET=y
> # CONFIG_ZISOFS is not set
> CONFIG_UDF_FS=y
> CONFIG_UDF_NLS=y
> 
> #
> # DOS/FAT/NT Filesystems
> #
> # CONFIG_MSDOS_FS is not set
> # CONFIG_VFAT_FS is not set
> CONFIG_NTFS_FS=m
> # CONFIG_NTFS_DEBUG is not set
> CONFIG_NTFS_RW=y
> 
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> # CONFIG_PROC_KCORE is not set
> # CONFIG_PROC_VMCORE is not set
> CONFIG_PROC_SYSCTL=y
> CONFIG_PROC_PAGE_MONITOR=y
> CONFIG_SYSFS=y
> # CONFIG_TMPFS is not set
> CONFIG_HUGETLBFS=y
> CONFIG_HUGETLB_PAGE=y
> CONFIG_CONFIGFS_FS=y
> CONFIG_MISC_FILESYSTEMS=y
> CONFIG_ADFS_FS=m
> CONFIG_ADFS_FS_RW=y
> # CONFIG_AFFS_FS is not set
> # CONFIG_ECRYPT_FS is not set
> CONFIG_HFS_FS=m
> # CONFIG_HFSPLUS_FS is not set
> CONFIG_BEFS_FS=m
> # CONFIG_BEFS_DEBUG is not set
> # CONFIG_BFS_FS is not set
> # CONFIG_EFS_FS is not set
> CONFIG_JFFS2_FS=m
> CONFIG_JFFS2_FS_DEBUG=0
> CONFIG_JFFS2_FS_WRITEBUFFER=y
> CONFIG_JFFS2_FS_WBUF_VERIFY=y
> # CONFIG_JFFS2_SUMMARY is not set
> # CONFIG_JFFS2_FS_XATTR is not set
> # CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
> CONFIG_JFFS2_ZLIB=y
> # CONFIG_JFFS2_LZO is not set
> CONFIG_JFFS2_RTIME=y
> # CONFIG_JFFS2_RUBIN is not set
> # CONFIG_UBIFS_FS is not set
> CONFIG_LOGFS=y
> CONFIG_CRAMFS=y
> CONFIG_SQUASHFS=y
> CONFIG_SQUASHFS_XATTR=y
> CONFIG_SQUASHFS_ZLIB=y
> # CONFIG_SQUASHFS_LZO is not set
> # CONFIG_SQUASHFS_XZ is not set
> CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
> CONFIG_SQUASHFS_EMBEDDED=y
> CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
> CONFIG_VXFS_FS=m
> CONFIG_MINIX_FS=y
> CONFIG_OMFS_FS=y
> # CONFIG_HPFS_FS is not set
> # CONFIG_QNX4FS_FS is not set
> # CONFIG_QNX6FS_FS is not set
> CONFIG_ROMFS_FS=m
> # CONFIG_ROMFS_BACKED_BY_BLOCK is not set
> # CONFIG_ROMFS_BACKED_BY_MTD is not set
> CONFIG_ROMFS_BACKED_BY_BOTH=y
> CONFIG_ROMFS_ON_BLOCK=y
> CONFIG_ROMFS_ON_MTD=y
> CONFIG_PSTORE=y
> # CONFIG_PSTORE_CONSOLE is not set
> # CONFIG_PSTORE_FTRACE is not set
> CONFIG_PSTORE_RAM=y
> CONFIG_SYSV_FS=m
> # CONFIG_UFS_FS is not set
> CONFIG_F2FS_FS=m
> # CONFIG_F2FS_STAT_FS is not set
> CONFIG_F2FS_FS_XATTR=y
> # CONFIG_F2FS_FS_POSIX_ACL is not set
> CONFIG_NETWORK_FILESYSTEMS=y
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-1"
> # CONFIG_NLS_CODEPAGE_437 is not set
> CONFIG_NLS_CODEPAGE_737=m
> CONFIG_NLS_CODEPAGE_775=m
> # CONFIG_NLS_CODEPAGE_850 is not set
> CONFIG_NLS_CODEPAGE_852=m
> CONFIG_NLS_CODEPAGE_855=y
> CONFIG_NLS_CODEPAGE_857=m
> CONFIG_NLS_CODEPAGE_860=y
> # CONFIG_NLS_CODEPAGE_861 is not set
> CONFIG_NLS_CODEPAGE_862=y
> CONFIG_NLS_CODEPAGE_863=y
> # CONFIG_NLS_CODEPAGE_864 is not set
> CONFIG_NLS_CODEPAGE_865=y
> # CONFIG_NLS_CODEPAGE_866 is not set
> CONFIG_NLS_CODEPAGE_869=y
> CONFIG_NLS_CODEPAGE_936=m
> # CONFIG_NLS_CODEPAGE_950 is not set
> # CONFIG_NLS_CODEPAGE_932 is not set
> # CONFIG_NLS_CODEPAGE_949 is not set
> CONFIG_NLS_CODEPAGE_874=m
> # CONFIG_NLS_ISO8859_8 is not set
> CONFIG_NLS_CODEPAGE_1250=y
> CONFIG_NLS_CODEPAGE_1251=y
> # CONFIG_NLS_ASCII is not set
> CONFIG_NLS_ISO8859_1=m
> # CONFIG_NLS_ISO8859_2 is not set
> # CONFIG_NLS_ISO8859_3 is not set
> CONFIG_NLS_ISO8859_4=y
> CONFIG_NLS_ISO8859_5=m
> CONFIG_NLS_ISO8859_6=m
> CONFIG_NLS_ISO8859_7=y
> # CONFIG_NLS_ISO8859_9 is not set
> CONFIG_NLS_ISO8859_13=m
> CONFIG_NLS_ISO8859_14=m
> CONFIG_NLS_ISO8859_15=y
> CONFIG_NLS_KOI8_R=m
> # CONFIG_NLS_KOI8_U is not set
> # CONFIG_NLS_MAC_ROMAN is not set
> CONFIG_NLS_MAC_CELTIC=m
> # CONFIG_NLS_MAC_CENTEURO is not set
> # CONFIG_NLS_MAC_CROATIAN is not set
> CONFIG_NLS_MAC_CYRILLIC=y
> CONFIG_NLS_MAC_GAELIC=m
> CONFIG_NLS_MAC_GREEK=y
> # CONFIG_NLS_MAC_ICELAND is not set
> CONFIG_NLS_MAC_INUIT=m
> CONFIG_NLS_MAC_ROMANIAN=y
> CONFIG_NLS_MAC_TURKISH=y
> CONFIG_NLS_UTF8=y
> 
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> CONFIG_PRINTK_TIME=y
> CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
> CONFIG_ENABLE_WARN_DEPRECATED=y
> # CONFIG_ENABLE_MUST_CHECK is not set
> CONFIG_FRAME_WARN=1024
> CONFIG_MAGIC_SYSRQ=y
> # CONFIG_STRIP_ASM_SYMS is not set
> CONFIG_READABLE_ASM=y
> CONFIG_UNUSED_SYMBOLS=y
> CONFIG_DEBUG_FS=y
> # CONFIG_HEADERS_CHECK is not set
> # CONFIG_DEBUG_SECTION_MISMATCH is not set
> CONFIG_DEBUG_KERNEL=y
> # CONFIG_DEBUG_SHIRQ is not set
> CONFIG_LOCKUP_DETECTOR=y
> CONFIG_HARDLOCKUP_DETECTOR=y
> CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
> CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
> CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
> CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
> CONFIG_PANIC_ON_OOPS=y
> CONFIG_PANIC_ON_OOPS_VALUE=1
> CONFIG_DETECT_HUNG_TASK=y
> CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
> # CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
> CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
> CONFIG_SCHED_DEBUG=y
> # CONFIG_SCHEDSTATS is not set
> # CONFIG_TIMER_STATS is not set
> # CONFIG_DEBUG_OBJECTS is not set
> CONFIG_SLUB_DEBUG_ON=y
> # CONFIG_SLUB_STATS is not set
> CONFIG_HAVE_DEBUG_KMEMLEAK=y
> # CONFIG_DEBUG_KMEMLEAK is not set
> # CONFIG_DEBUG_RT_MUTEXES is not set
> # CONFIG_RT_MUTEX_TESTER is not set
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> CONFIG_DEBUG_LOCK_ALLOC=y
> # CONFIG_PROVE_LOCKING is not set
> CONFIG_LOCKDEP=y
> CONFIG_LOCK_STAT=y
> # CONFIG_DEBUG_LOCKDEP is not set
> CONFIG_DEBUG_ATOMIC_SLEEP=y
> CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
> CONFIG_STACKTRACE=y
> # CONFIG_DEBUG_STACK_USAGE is not set
> # CONFIG_DEBUG_KOBJECT is not set
> # CONFIG_DEBUG_HIGHMEM is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> CONFIG_DEBUG_INFO=y
> # CONFIG_DEBUG_VM is not set
> CONFIG_DEBUG_VIRTUAL=y
> # CONFIG_DEBUG_WRITECOUNT is not set
> CONFIG_DEBUG_MEMORY_INIT=y
> CONFIG_DEBUG_LIST=y
> # CONFIG_TEST_LIST_SORT is not set
> CONFIG_DEBUG_SG=y
> CONFIG_DEBUG_NOTIFIERS=y
> # CONFIG_DEBUG_CREDENTIALS is not set
> CONFIG_ARCH_WANT_FRAME_POINTERS=y
> CONFIG_FRAME_POINTER=y
> CONFIG_BOOT_PRINTK_DELAY=y
> 
> #
> # RCU Debugging
> #
> CONFIG_SPARSE_RCU_POINTER=y
> CONFIG_RCU_TORTURE_TEST=y
> CONFIG_RCU_TORTURE_TEST_RUNNABLE=y
> CONFIG_RCU_CPU_STALL_TIMEOUT=21
> # CONFIG_RCU_CPU_STALL_INFO is not set
> # CONFIG_RCU_TRACE is not set
> # CONFIG_BACKTRACE_SELF_TEST is not set
> # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
> CONFIG_DEBUG_PER_CPU_MAPS=y
> CONFIG_LKDTM=y
> CONFIG_NOTIFIER_ERROR_INJECTION=m
> # CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
> # CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
> # CONFIG_FAULT_INJECTION is not set
> # CONFIG_LATENCYTOP is not set
> CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
> # CONFIG_DEBUG_PAGEALLOC is not set
> CONFIG_USER_STACKTRACE_SUPPORT=y
> CONFIG_NOP_TRACER=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
> CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
> CONFIG_HAVE_C_RECORDMCOUNT=y
> CONFIG_TRACER_MAX_TRACE=y
> CONFIG_TRACE_CLOCK=y
> CONFIG_RING_BUFFER=y
> CONFIG_EVENT_TRACING=y
> CONFIG_CONTEXT_SWITCH_TRACER=y
> CONFIG_TRACING=y
> CONFIG_GENERIC_TRACER=y
> CONFIG_TRACING_SUPPORT=y
> CONFIG_FTRACE=y
> CONFIG_FUNCTION_TRACER=y
> # CONFIG_IRQSOFF_TRACER is not set
> CONFIG_SCHED_TRACER=y
> CONFIG_FTRACE_SYSCALLS=y
> CONFIG_TRACER_SNAPSHOT=y
> # CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
> CONFIG_TRACE_BRANCH_PROFILING=y
> # CONFIG_BRANCH_PROFILE_NONE is not set
> # CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
> CONFIG_PROFILE_ALL_BRANCHES=y
> CONFIG_TRACING_BRANCHES=y
> CONFIG_BRANCH_TRACER=y
> # CONFIG_STACK_TRACER is not set
> CONFIG_BLK_DEV_IO_TRACE=y
> # CONFIG_UPROBE_EVENT is not set
> # CONFIG_PROBE_EVENTS is not set
> CONFIG_DYNAMIC_FTRACE=y
> CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
> CONFIG_FUNCTION_PROFILER=y
> CONFIG_FTRACE_MCOUNT_RECORD=y
> # CONFIG_FTRACE_STARTUP_TEST is not set
> # CONFIG_MMIOTRACE is not set
> CONFIG_RING_BUFFER_BENCHMARK=m
> CONFIG_RING_BUFFER_STARTUP_TEST=y
> CONFIG_RBTREE_TEST=m
> CONFIG_INTERVAL_TREE_TEST=m
> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> CONFIG_DYNAMIC_DEBUG=y
> CONFIG_DMA_API_DEBUG=y
> # CONFIG_ATOMIC64_SELFTEST is not set
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_KGDB is not set
> CONFIG_HAVE_ARCH_KMEMCHECK=y
> CONFIG_TEST_STRING_HELPERS=m
> CONFIG_TEST_KSTRTOX=y
> CONFIG_STRICT_DEVMEM=y
> CONFIG_X86_VERBOSE_BOOTUP=y
> CONFIG_EARLY_PRINTK=y
> # CONFIG_EARLY_PRINTK_DBGP is not set
> # CONFIG_DEBUG_STACKOVERFLOW is not set
> CONFIG_X86_PTDUMP=y
> # CONFIG_DEBUG_RODATA is not set
> # CONFIG_DEBUG_SET_MODULE_RONX is not set
> CONFIG_DEBUG_NX_TEST=m
> CONFIG_DOUBLEFAULT=y
> CONFIG_DEBUG_TLBFLUSH=y
> # CONFIG_IOMMU_STRESS is not set
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> # CONFIG_IO_DELAY_0X80 is not set
> CONFIG_IO_DELAY_0XED=y
> # CONFIG_IO_DELAY_UDELAY is not set
> # CONFIG_IO_DELAY_NONE is not set
> CONFIG_DEFAULT_IO_DELAY_TYPE=1
> CONFIG_DEBUG_BOOT_PARAMS=y
> # CONFIG_CPA_DEBUG is not set
> CONFIG_OPTIMIZE_INLINING=y
> CONFIG_DEBUG_NMI_SELFTEST=y
> 
> #
> # Security options
> #
> CONFIG_KEYS=y
> CONFIG_TRUSTED_KEYS=y
> CONFIG_ENCRYPTED_KEYS=y
> # CONFIG_KEYS_DEBUG_PROC_KEYS is not set
> CONFIG_SECURITY_DMESG_RESTRICT=y
> # CONFIG_SECURITY is not set
> CONFIG_SECURITYFS=y
> CONFIG_DEFAULT_SECURITY_DAC=y
> CONFIG_DEFAULT_SECURITY=""
> CONFIG_CRYPTO=y
> 
> #
> # Crypto core or helper
> #
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_ALGAPI2=y
> CONFIG_CRYPTO_AEAD=m
> CONFIG_CRYPTO_AEAD2=y
> CONFIG_CRYPTO_BLKCIPHER=y
> CONFIG_CRYPTO_BLKCIPHER2=y
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_HASH2=y
> CONFIG_CRYPTO_RNG=y
> CONFIG_CRYPTO_RNG2=y
> CONFIG_CRYPTO_PCOMP=m
> CONFIG_CRYPTO_PCOMP2=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> # CONFIG_CRYPTO_USER is not set
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
> CONFIG_CRYPTO_GF128MUL=y
> CONFIG_CRYPTO_NULL=y
> # CONFIG_CRYPTO_PCRYPT is not set
> CONFIG_CRYPTO_WORKQUEUE=y
> CONFIG_CRYPTO_CRYPTD=y
> CONFIG_CRYPTO_AUTHENC=m
> CONFIG_CRYPTO_TEST=m
> CONFIG_CRYPTO_ABLK_HELPER_X86=y
> CONFIG_CRYPTO_GLUE_HELPER_X86=y
> 
> #
> # Authenticated Encryption with Associated Data
> #
> # CONFIG_CRYPTO_CCM is not set
> # CONFIG_CRYPTO_GCM is not set
> CONFIG_CRYPTO_SEQIV=m
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=y
> CONFIG_CRYPTO_CTR=m
> # CONFIG_CRYPTO_CTS is not set
> # CONFIG_CRYPTO_ECB is not set
> CONFIG_CRYPTO_LRW=y
> CONFIG_CRYPTO_PCBC=y
> CONFIG_CRYPTO_XTS=y
> 
> #
> # Hash modes
> #
> CONFIG_CRYPTO_CMAC=m
> CONFIG_CRYPTO_HMAC=y
> CONFIG_CRYPTO_XCBC=y
> CONFIG_CRYPTO_VMAC=m
> 
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=m
> CONFIG_CRYPTO_CRC32C_INTEL=m
> CONFIG_CRYPTO_CRC32=m
> CONFIG_CRYPTO_CRC32_PCLMUL=y
> CONFIG_CRYPTO_GHASH=y
> CONFIG_CRYPTO_MD4=y
> CONFIG_CRYPTO_MD5=m
> # CONFIG_CRYPTO_MICHAEL_MIC is not set
> # CONFIG_CRYPTO_RMD128 is not set
> CONFIG_CRYPTO_RMD160=m
> CONFIG_CRYPTO_RMD256=y
> CONFIG_CRYPTO_RMD320=m
> CONFIG_CRYPTO_SHA1=y
> CONFIG_CRYPTO_SHA256=y
> CONFIG_CRYPTO_SHA512=m
> # CONFIG_CRYPTO_TGR192 is not set
> CONFIG_CRYPTO_WP512=m
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> CONFIG_CRYPTO_AES_586=y
> # CONFIG_CRYPTO_AES_NI_INTEL is not set
> # CONFIG_CRYPTO_ANUBIS is not set
> CONFIG_CRYPTO_ARC4=y
> CONFIG_CRYPTO_BLOWFISH=y
> CONFIG_CRYPTO_BLOWFISH_COMMON=y
> CONFIG_CRYPTO_CAMELLIA=y
> # CONFIG_CRYPTO_CAST5 is not set
> # CONFIG_CRYPTO_CAST6 is not set
> CONFIG_CRYPTO_DES=y
> # CONFIG_CRYPTO_FCRYPT is not set
> # CONFIG_CRYPTO_KHAZAD is not set
> CONFIG_CRYPTO_SALSA20=y
> CONFIG_CRYPTO_SALSA20_586=m
> # CONFIG_CRYPTO_SEED is not set
> CONFIG_CRYPTO_SERPENT=y
> CONFIG_CRYPTO_SERPENT_SSE2_586=y
> # CONFIG_CRYPTO_TEA is not set
> CONFIG_CRYPTO_TWOFISH=y
> CONFIG_CRYPTO_TWOFISH_COMMON=y
> CONFIG_CRYPTO_TWOFISH_586=y
> 
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=y
> CONFIG_CRYPTO_ZLIB=m
> CONFIG_CRYPTO_LZO=m
> 
> #
> # Random Number Generation
> #
> CONFIG_CRYPTO_ANSI_CPRNG=y
> # CONFIG_CRYPTO_USER_API_HASH is not set
> # CONFIG_CRYPTO_USER_API_SKCIPHER is not set
> # CONFIG_CRYPTO_HW is not set
> CONFIG_ASYMMETRIC_KEY_TYPE=y
> CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
> CONFIG_PUBLIC_KEY_ALGO_RSA=y
> CONFIG_X509_CERTIFICATE_PARSER=y
> CONFIG_HAVE_KVM=y
> CONFIG_VIRTUALIZATION=y
> CONFIG_LGUEST=m
> CONFIG_BINARY_PRINTF=y
> 
> #
> # Library routines
> #
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_STRNCPY_FROM_USER=y
> CONFIG_GENERIC_STRNLEN_USER=y
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_GENERIC_PCI_IOMAP=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_IO=y
> CONFIG_CRC_CCITT=y
> CONFIG_CRC16=y
> CONFIG_CRC_T10DIF=m
> CONFIG_CRC_ITU_T=y
> CONFIG_CRC32=y
> CONFIG_CRC32_SELFTEST=y
> # CONFIG_CRC32_SLICEBY8 is not set
> # CONFIG_CRC32_SLICEBY4 is not set
> # CONFIG_CRC32_SARWATE is not set
> CONFIG_CRC32_BIT=y
> CONFIG_CRC7=y
> CONFIG_LIBCRC32C=m
> CONFIG_CRC8=y
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_LZO_COMPRESS=y
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_XZ_DEC=y
> CONFIG_XZ_DEC_X86=y
> # CONFIG_XZ_DEC_POWERPC is not set
> # CONFIG_XZ_DEC_IA64 is not set
> # CONFIG_XZ_DEC_ARM is not set
> # CONFIG_XZ_DEC_ARMTHUMB is not set
> # CONFIG_XZ_DEC_SPARC is not set
> CONFIG_XZ_DEC_BCJ=y
> # CONFIG_XZ_DEC_TEST is not set
> CONFIG_DECOMPRESS_GZIP=y
> CONFIG_DECOMPRESS_BZIP2=y
> CONFIG_DECOMPRESS_LZMA=y
> CONFIG_DECOMPRESS_XZ=y
> CONFIG_DECOMPRESS_LZO=y
> CONFIG_GENERIC_ALLOCATOR=y
> CONFIG_REED_SOLOMON=y
> CONFIG_REED_SOLOMON_ENC8=y
> CONFIG_REED_SOLOMON_DEC8=y
> CONFIG_BTREE=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y
> CONFIG_CPUMASK_OFFSTACK=y
> CONFIG_CPU_RMAP=y
> CONFIG_DQL=y
> CONFIG_NLATTR=y
> CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
> CONFIG_AVERAGE=y
> CONFIG_CLZ_TAB=y
> CONFIG_CORDIC=y
> CONFIG_DDR=y
> CONFIG_MPILIB=y
> CONFIG_OID_REGISTRY=y
> # CONFIG_IIO_SIMPLE_DUMMY is not set
> # CONFIG_ATA_SFF is not set
> # CONFIG_DRM_TTM is not set
> # CONFIG_ISDN_DRV_LOOP is not set
> # CONFIG_PCI_ATS is not set

