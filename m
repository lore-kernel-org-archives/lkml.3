Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab3JGLc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 07:32:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:38040 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427Ab3JGLc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:32:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1049,1371106800"; 
   d="scan'208";a="406540978"
Date: Mon, 7 Oct 2013 19:32:48 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
Message-ID: <20131007113248.GA1188@localhost>
References: <20131005234430.GA22485@localhost>
 <20131007085533.GZ3081@twins.programming.kicks-ass.net>
 <20131007090856.GS26785@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131007090856.GS26785@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 11:08:56AM +0200, Peter Zijlstra wrote:
> On Mon, Oct 07, 2013 at 10:55:33AM +0200, Peter Zijlstra wrote:
> > Wu, do you use the same compiler version for all the builds that crash
> > like this (I'm assuming the other email was this same commit)? Does a
> > different compiler make things work again?
> 
> OK, so in a further email you say you use gcc-4.8.1 (which is actually
> newer than the one I used for most of the work although I do have it and
> tried it iirc).

Right. And I've got the boot result for gcc-4.6.3: the problem is
still there. Here is the qemu cmdline and new dmesg.

=============================================================================
cmd=(
qemu-system-x86_64 -cpu kvm64 -enable-kvm
-kernel $1
  -initrd /kernel-tests/initrd/quantal-core-i386.cgz -m 256M -smp 2 -net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio -net user,vlan=0,hostfwd=tcp::10661-:22
-net nic,vlan=1,model=e1000 -net user,vlan=1 -boot order=nc -no-reboot -watchdog i6300esb
-serial file:/dev/shm/serial-0day -daemonize -display none -monitor null
)

"${cmd[@]}" -append 'hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw'
=============================================================================

[    0.000000] Linux version 3.12.0-rc1-00081-g6bfa687 (wfg@bee) (gcc version 4.6.3 (Debian 4.6.3-1) ) #1 Mon Oct 7 19:18:22 CST 2013
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x1000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x029fffff]
[    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0e5fffff]
[    0.000000]  [mem 0x0e400000-0x0e5fffff] page 4k
[    0.000000] BRK [0x020a7000, 0x020a7fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e3fffff]
[    0.000000]  [mem 0x0c000000-0x0e3fffff] page 4k
[    0.000000] BRK [0x020a8000, 0x020a8fff] PGTABLE
[    0.000000] BRK [0x020a9000, 0x020a9fff] PGTABLE
[    0.000000] BRK [0x020aa000, 0x020aafff] PGTABLE
[    0.000000] BRK [0x020ab000, 0x020abfff] PGTABLE
[    0.000000] BRK [0x020ac000, 0x020acfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0fffdfff]
[    0.000000]  [mem 0x0e600000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128876(98%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000f16b0 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe3f0 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0fffe430 01137 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffff6a0 00899 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0ffff5b0 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0ffff570 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x0fffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   Normal zone: 576 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 65436 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 189e3c0
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64860
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 205852K/261744K available (6113K kernel code, 2123K rwdata, 2620K rodata, 460K init, 5644K bss, 55892K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe2000 - 0xfffff000   ( 116 kB)
[    0.000000]     vmalloc : 0x907fe000 - 0xfffe0000   (1783 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x8fffe000   ( 255 MB)
[    0.000000]       .init : 0x81a9c000 - 0x81b0f000   ( 460 kB)
[    0.000000]       .data : 0x815f8a07 - 0x81a9bf40   (4749 kB)
[    0.000000]       .text : 0x81000000 - 0x815f8a07   (6114 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=80090000 soft=80092000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
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
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:  ok  |  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok  |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]            spinlock nest unlocked:  ok  |
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:  ok  |  ok  |  ok  |
[    0.000000]                               try:  ok  |  ok  |  ok  |
[    0.000000]                             block:  ok  |  ok  |  ok  |
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5387.01 BogoMIPS (lpj=26935080)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] Mount-cache hash table entries: 512
[    0.020000] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020000] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020000] tlb_flushall_shift: 6
[    0.020000] CPU: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.022956] ACPI: Core revision 20130725
[    0.033753] ACPI: All ACPI Tables successfully acquired
[    0.034763] ACPI: setting ELCR to 0200 (from 0c00)
[    0.035542] ftrace: allocating 23377 entries in 46 pages
[    0.050381] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.060067] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.064402] regulator-dummy: no parameters
[    0.065415] NET: Registered protocol family 16
[    0.067278] cpuidle: using governor ladder
[    0.067735] cpuidle: using governor menu
[    0.068404] ACPI: bus type PCI registered
[    0.069307] PCI : PCI BIOS area is rw and x. Use pci=nobios if you want it NX.
[    0.070013] PCI: PCI BIOS revision 2.10 entry at 0xfd4e3, last bus=0
[    0.071070] PCI: Using configuration type 1 for base access
[    0.089117] ACPI: Added _OSI(Module Device)
[    0.089881] ACPI: Added _OSI(Processor Device)
[    0.090012] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.090631] ACPI: Added _OSI(Processor Aggregator Device)
[    0.096178] ACPI: EC: Look up EC in DSDT
[    0.115838] ACPI: Interpreter enabled
[    0.116581] ACPI: (supports S0 S5)
[    0.117112] ACPI: Using PIC for interrupt routing
[    0.117834] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.151281] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.152335] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.154411] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.156177] PCI host bridge to bus 0000:00
[    0.156847] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.157399] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.158287] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.159220] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.160016] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
[    0.161196] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.163474] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.165825] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.170626] pci 0000:00:01.1: reg 0x20: [io  0xc060-0xc06f]
[    0.174069] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.175269] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.176544] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.178543] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.181660] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.190077] pci 0000:00:02.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    0.211824] pci 0000:00:02.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.214279] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.216819] pci 0000:00:03.0: reg 0x10: [io  0xc040-0xc05f]
[    0.222049] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    0.234052] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.237266] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.240938] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.244141] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.254919] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.257620] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
[    0.259920] pci 0000:00:05.0: reg 0x10: [mem 0xfebe0000-0xfebe000f]
[    0.267967] pci_bus 0000:00: on NUMA node 0
[    0.274378] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.276511] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.278551] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.281169] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.282831] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.286803] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.287851] ACPI: \_SB_.PCI0: notify handler is installed
[    0.289291] Found 1 acpi root devices
[    0.292095] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.293693] vgaarb: loaded
[    0.294274] vgaarb: bridge control possible 0000:00:02.0
[    0.296221] ACPI: bus type USB registered
[    0.297194] usbcore: registered new interface driver usbfs
[    0.298419] usbcore: registered new interface driver hub
[    0.299362] usbcore: registered new device driver usb
[    0.300475] pps_core: LinuxPPS API ver. 1 registered
[    0.301594] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.303433] PTP clock support registered
[    0.304427] EDAC MC: Ver: 3.0.0
[    0.305686] EDAC DEBUG: edac_mc_sysfs_init: device mc created
[    0.307907] Advanced Linux Sound Architecture Driver Initialized.
[    0.308508] PCI: Using ACPI for IRQ routing
[    0.308981] PCI: pci_cache_line_size set to 64 bytes
[    0.310078] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.310735] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.313883] Switched to clocksource kvm-clock
[    0.316615] Warning: could not register annotated branches stats
[    0.347872] pnp: PnP ACPI init
[    0.348235] ACPI: bus type PNP registered
[    0.348796] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.349532] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.350357] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.352097] pnp 00:03: [dma 2]
[    0.352938] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.353730] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.355281] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.358842] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.360334] pnp: PnP ACPI: found 7 devices
[    0.361242] ACPI: bus type PNP unregistered
[    0.397904] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.398452] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.398969] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.399547] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.400137] NET: Registered protocol family 1
[    0.400616] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.401210] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.401780] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.402380] pci 0000:00:02.0: Boot video device
[    0.402849] PCI: CLS 0 bytes, default 64
[    0.403593] Unpacking initramfs...
[    4.037222] debug: unmapping init [mem 0x8e73f000-0x8ffeffff]
[    5.080498] DMA-API: preallocated 65536 debug entries
[    5.081150] DMA-API: debugging enabled by kernel config
[    5.085943] microcode: CPU0 sig=0xf61, pf=0x1, revision=0x1
[    5.088639] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    5.090438] Scanning for low memory corruption every 60 seconds
[    5.092318] cryptomgr_test (14) used greatest stack depth: 7244 bytes left
[    5.095634] The force parameter has not been set to 1. The Iris poweroff handler will not be installed.
[    5.097722] NatSemi SCx200 Driver
[    5.106939] VFS: Disk quotas dquot_6.5.2
[    5.107857] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    5.111720] jffs2: version 2.2. © 2001-2006 Red Hat, Inc.
[    5.113153] ROMFS MTD (C) 2007 Red Hat, Inc.
[    5.114072] fuse init (API version 7.22)
[    5.117217] msgmni has been set to 402
[    5.125805] Key type asymmetric registered
[    5.126822] Asymmetric key parser 'x509' registered
[    5.136605] list_sort_test: start testing list_sort()
[    5.141321] crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
[    5.142401] crc32: self tests passed, processed 225944 bytes in 637724 nsec
[    5.144315] crc32c: CRC_LE_BITS = 32
[    5.145010] crc32c: self tests passed, processed 225944 bytes in 141853 nsec
[    5.146590] rbtree testing -> 12500 cycles
[    5.698682] augmented rbtree testing -> 24366 cycles
[    6.715342] tsc: Refined TSC clocksource calibration: 2693.464 MHz
[    6.717936] no IO addresses supplied
[    6.718461] hgafb: HGA card not detected.
[    6.718854] hgafb: probe of hgafb.0 failed with error -22
[    6.719562] usbcore: registered new interface driver udlfb
[    6.720114] ipmi message handler version 39.2
[    6.720535] ipmi device interface
[    6.722655] IPMI System Interface driver.
[    6.723154] ipmi_si: Adding default-specified kcs state machine
[    6.723716] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[    6.724648] ipmi_si: Interface detection failed
[    6.725083] ipmi_si: Adding default-specified smic state machine
[    6.725647] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[    6.726785] ipmi_si: Interface detection failed
[    6.727203] ipmi_si: Adding default-specified bt state machine
[    6.727907] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[    6.729406] ipmi_si: Interface detection failed
[    6.730062] ipmi_si: Unable to find any System Interface(s)
[    6.730593] IPMI Watchdog: driver initialized
[    6.730991] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    6.732068] IPMI poweroff: Unable to register powercycle sysctl
[    6.733295] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    6.734592] ACPI: Power Button [PWRF]
[    6.736427] r3964: Philips r3964 Driver $Revision: 1.10 $
[    6.737171] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    6.760425] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    6.772174] lp: driver loaded but no devices found
[    6.772838] DoubleTalk PC - not found
[    6.773770] Non-volatile memory driver v1.3
[    6.774655] toshiba: not a supported Toshiba laptop
[    6.775966] ppdev: user-space parallel port driver
[    6.777839] scx200_gpio: no SCx200 gpio present
[    6.779303] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
[    6.781027] platform pc8736x_gpio.0: no device found
[    6.782029] nsc_gpio initializing
[    6.782769] telclk_interrupt = 0xf non-mcpbl0010 hw.
[    6.783853] smapi::smapi_init, ERROR invalid usSmapiID
[    6.784860] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[    6.787469] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[    6.788739] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    6.789307] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    6.790493] Hangcheck: Using getrawmonotonic().
[    6.792391] dummy-irq: no IRQ given.  Use irq=N
[    6.794921] usbcore: registered new interface driver viperboard
[    6.799656] Failed to ioremap_nocache
[    6.800616] slram: not enough parameters.
[    6.835859] No valid DiskOnChip devices found
[    6.837874] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    6.839561] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    6.841425] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    6.843027] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    6.844641] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    6.846607] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    6.848421] NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba NAND 128MiB 1,8V 8-bit), 128MiB, page size: 512, OOB size: 16
[    6.850970] flash size: 128 MiB
[    6.851645] page size: 512 bytes
[    6.852276] OOB area size: 16 bytes
[    6.853007] sector size: 16 KiB
[    6.853667] pages number: 262144
[    6.854345] pages per sector: 32
[    6.855024] bus width: 8
[    6.855555] bits in sector size: 14
[    6.855880] bits in page size: 9
[    6.856382] bits in OOB size: 4
[    6.856681] flash size with OOB: 135168 KiB
[    6.857063] page address bytes: 4
[    6.857369] sector address bytes: 3
[    6.858084] options: 0x42
[    6.861585] Scanning device for bad blocks
[    6.928354] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    6.928983] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    6.933140] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    6.933804] usbcore: registered new interface driver cdc_wdm
[    6.934363] usbcore: registered new interface driver mdc800
[    6.934881] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
[    6.938836] usbcore: registered new interface driver usbserial
[    6.939449] usbcore: registered new interface driver aircable
[    6.940069] usbserial: USB Serial support registered for aircable
[    6.940900] usbcore: registered new interface driver belkin_sa
[    6.942417] usbserial: USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
[    6.943755] usbcore: registered new interface driver ch341
[    6.944319] usbserial: USB Serial support registered for ch341-uart
[    6.944926] usbcore: registered new interface driver cyberjack
[    6.945599] usbserial: USB Serial support registered for Reiner SCT Cyberjack USB card reader
[    6.946888] usbcore: registered new interface driver usb_debug
[    6.947601] usbserial: USB Serial support registered for debug
[    6.948202] usbcore: registered new interface driver digi_acceleport
[    6.949240] usbserial: USB Serial support registered for Digi 2 port USB adapter
[    6.949950] usbserial: USB Serial support registered for Digi 4 port USB adapter
[    6.950651] usbcore: registered new interface driver io_ti
[    6.951255] usbserial: USB Serial support registered for Edgeport TI 1 port adapter
[    6.952094] usbserial: USB Serial support registered for Edgeport TI 2 port adapter
[    6.952909] usbcore: registered new interface driver f81232
[    6.953448] usbserial: USB Serial support registered for f81232
[    6.954221] usbcore: registered new interface driver ftdi_sio
[    6.954999] usbserial: USB Serial support registered for FTDI USB Serial Device
[    6.956307] usbcore: registered new interface driver ipaq
[    6.956954] usbserial: USB Serial support registered for PocketPC PDA
[    6.957642] usbcore: registered new interface driver ir_usb
[    6.958262] usbserial: USB Serial support registered for IR Dongle
[    6.959048] usbcore: registered new interface driver iuu_phoenix
[    6.959625] usbserial: USB Serial support registered for iuu_phoenix
[    6.960271] usbcore: registered new interface driver keyspan
[    6.961145] usbserial: USB Serial support registered for Keyspan - (without firmware)
[    6.962165] usbserial: USB Serial support registered for Keyspan 1 port adapter
[    6.963371] usbserial: USB Serial support registered for Keyspan 2 port adapter
[    6.964267] usbserial: USB Serial support registered for Keyspan 4 port adapter
[    6.965995] usbcore: registered new interface driver kl5kusb105
[    6.967858] usbserial: USB Serial support registered for KL5KUSB105D / PalmConnect
[    6.971077] usbcore: registered new interface driver kobil_sct
[    6.972422] usbserial: USB Serial support registered for KOBIL USB smart card terminal
[    6.974546] usbcore: registered new interface driver mos7720
[    6.975164] usbserial: USB Serial support registered for Moschip 2 port adapter
[    6.975878] usbcore: registered new interface driver mos7840
[    6.977411] usbserial: USB Serial support registered for Moschip 7840/7820 USB Serial Driver
[    6.981304] usbcore: registered new interface driver navman
[    6.982617] usbserial: USB Serial support registered for navman
[    6.983311] usbcore: registered new interface driver omninet
[    6.983855] usbserial: USB Serial support registered for ZyXEL - omni.net lcd plus usb
[    6.985640] usbcore: registered new interface driver opticon
[    6.986735] usbserial: USB Serial support registered for opticon
[    6.990513] usbcore: registered new interface driver oti6858
[    6.992070] usbserial: USB Serial support registered for oti6858
[    6.992687] usbcore: registered new interface driver qcaux
[    6.993360] usbserial: USB Serial support registered for qcaux
[    6.994325] usbcore: registered new interface driver qcserial
[    6.995046] usbserial: USB Serial support registered for Qualcomm USB modem
[    6.998341] usbcore: registered new interface driver quatech2
[    6.999933] usbserial: USB Serial support registered for Quatech 2nd gen USB to Serial Driver
[    7.000758] usbcore: registered new interface driver safe_serial
[    7.001503] usbserial: USB Serial support registered for safe_serial
[    7.002777] usbcore: registered new interface driver sierra
[    7.004519] usbserial: USB Serial support registered for Sierra USB modem
[    7.008017] usbcore: registered new interface driver usb_serial_simple
[    7.008722] usbserial: USB Serial support registered for zio
[    7.009291] usbserial: USB Serial support registered for funsoft
[    7.009929] usbserial: USB Serial support registered for flashloader
[    7.010672] usbserial: USB Serial support registered for vivopay
[    7.011616] usbserial: USB Serial support registered for moto_modem
[    7.012365] usbserial: USB Serial support registered for hp4x
[    7.012941] usbserial: USB Serial support registered for suunto
[    7.014066] usbserial: USB Serial support registered for siemens_mpi
[    7.015277] usbcore: registered new interface driver spcp8x5
[    7.016693] usbserial: USB Serial support registered for SPCP8x5
[    7.017729] usbcore: registered new interface driver symbolserial
[    7.018690] usbserial: USB Serial support registered for symbol
[    7.019315] usbcore: registered new interface driver visor
[    7.020082] usbserial: USB Serial support registered for Handspring Visor / Palm OS
[    7.020862] usbserial: USB Serial support registered for Sony Clie 5.0
[    7.021490] usbserial: USB Serial support registered for Sony Clie 3.5
[    7.024603] usbcore: registered new interface driver whiteheat
[    7.025516] usbserial: USB Serial support registered for Connect Tech - WhiteHEAT - (prerenumeration)
[    7.028060] usbserial: USB Serial support registered for Connect Tech - WhiteHEAT
[    7.029654] usbcore: registered new interface driver keyspan_pda
[    7.030675] usbserial: USB Serial support registered for Keyspan PDA
[    7.031754] usbserial: USB Serial support registered for Xircom / Entregra PGS - (prerenumeration)
[    7.035509] usbcore: registered new interface driver xsens_mt
[    7.037315] usbserial: USB Serial support registered for xsens_mt
[    7.038572] usbcore: registered new interface driver zte_ev
[    7.040254] usbserial: USB Serial support registered for zte_ev
[    7.041317] usbcore: registered new interface driver adutux
[    7.042927] usbcore: registered new interface driver appledisplay
[    7.044247] usbcore: registered new interface driver cytherm
[    7.045644] usbcore: registered new interface driver emi26 - firmware loader
[    7.047358] usbcore: registered new interface driver emi62 - firmware loader
[    7.049752] usbcore: registered new interface driver idmouse
[    7.051044] usbcore: registered new interface driver iowarrior
[    7.051606] usbcore: registered new interface driver isight_firmware
[    7.052732] usbcore: registered new interface driver usbled
[    7.054223] usbcore: registered new interface driver rio500
[    7.055721] usbcore: registered new interface driver trancevibrator
[    7.057825] usbcore: registered new interface driver uss720
[    7.058790] uss720: v0.6:USB Parport Cable driver for Cables using the Lucent Technologies USS720 Chip
[    7.061093] uss720: NOTE: this is a special purpose driver to allow nonstandard
[    7.062279] uss720: protocols (eg. bitbang) over USS720 usb to parallel cables
[    7.062924] uss720: If you just want to connect to a printer, use usblp instead
[    7.064435] usbcore: registered new interface driver usbsevseg
[    7.067683] userial_init: registered 4 ttyGS* devices
[    7.068486] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    7.071996] serio: i8042 KBD port at 0x60,0x64 irq 1
[    7.073187] serio: i8042 AUX port at 0x60,0x64 irq 12
[    7.077874] usbcore: registered new interface driver appletouch
[    7.078461] usbcore: registered new interface driver bcm5974
[    7.079722] logibm.c: Didn't find Logitech busmouse at 0x23c
[    7.085490] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    7.090318] usbcore: registered new interface driver xpad
[    7.094526] usbcore: registered new interface driver ati_remote2
[    7.095547] cm109: Keymap for Komunikate KIP1000 phone loaded
[    7.103015] usbcore: registered new interface driver cm109
[    7.104744] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    7.106135] usbcore: registered new interface driver ims_pcu
[    7.112730] input: PC Speaker as /devices/platform/pcspkr/input/input2
[    7.114002] usbcore: registered new interface driver powermate
[    7.114959] wistron_btns: System unknown
[    7.115359] ideapad_slidebar: DMI does not match
[    7.115818] i2c /dev entries driver
[    7.119698] i2c-parport-light: adapter type unspecified
[    7.121505] usbcore: registered new interface driver i2c-tiny-usb
[    7.125950] scx200_i2c: no SCx200 gpio pins available
[    7.126718] pps_ldisc: PPS line discipline registered
[    7.127184] pps_parport: parallel port PPS client
[    7.127645] Driver for 1-wire Dallas network protocol.
[    7.129758] usbcore: registered new interface driver DS9490R
[    7.131783] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
[    7.136990] applesmc: supported laptop not found!
[    7.137441] applesmc: driver init failed (ret=-19)!
[    7.150470] intel_powerclamp: Intel powerclamp does not run on family 15 model 6
[    7.152116] mixcomwd: No card detected, or port not available
[    7.152815] usbcore: registered new interface driver pcwd_usb
[    7.154245] acquirewdt: WDT driver for Acquire single board computer initialising
[    7.155369] acquirewdt: I/O address 0x0043 already in use
[    7.155953] acquirewdt: probe of acquirewdt failed with error -5
[    7.158166] sc1200wdt: build 20020303
[    7.161698] sc1200wdt: io parameter must be specified
[    7.162908] pc87413_wdt: Version 1.1 at io 0x2E
[    7.166079] pc87413_wdt: initialized. timeout=1 min
[    7.167339] pc87413_wdt: cannot request SWC region at 0xffff
[    7.169083] sbc8360: Timeout set at 60000 ms
[    7.169810] w83627hf_wdt: WDT driver for the Winbond(TM) W83627HF/THF/HG/DHG Super I/O chip initialising
[    7.171547] w83627hf_wdt: Watchdog already running. Resetting timeout to 60 sec
[    7.172885] w83627hf_wdt: cannot register miscdev on minor=130 (err=-16)
[    7.173890] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Super I/O chip initialising
[    7.174782] w83697ug_wdt: No W83697UG/UF could be found
[    7.175302] w83977f_wdt: driver v1.00
[    7.176042] w83977f_wdt: cannot register miscdev on minor=130 (err=-16)
[    7.177472] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    7.178627] machzwd: no ZF-Logic found
[    7.179455] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    7.180528] wbsd: Copyright(c) Pierre Ossman
[    7.181105] VUB300 Driver rom wait states = 1C irqpoll timeout = 0400
[    7.185276] usbcore: registered new interface driver vub300
[    7.187240] usbcore: registered new interface driver ushc
[    7.193051] ledtrig-cpu: registered to indicate activity on CPUs
[    7.197787] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    7.212856] usbcore: registered new interface driver usbhid
[    7.214049] usbhid: USB HID core driver
[    7.216540] goldfish_pdev_bus goldfish_pdev_bus: unable to reserve Goldfish MMIO.
[    7.217947] goldfish_pdev_bus: probe of goldfish_pdev_bus failed with error -16
[    7.235804]  fake-fmc-carrier: mezzanine 0
[    7.236506]       Manufacturer: fake-vendor
[    7.237148]       Product name: fake-design-for-testing
[    7.238295] fmc fake-design-for-testing-f001: Driver has no ID: matches all
[    7.239607] fmc_trivial: probe of fake-design-for-testing-f001 failed with error -95
[    7.240862] fmc fake-design-for-testing-f001: Driver has no ID: matches all
[    7.242270] fmc_chardev fake-design-for-testing-f001: Created misc device "fake-design-for-testing-f001"
[    7.251115] usbcore: registered new interface driver snd-usb-audio
[    7.252042] usbcore: registered new interface driver snd-ua101
[    7.253244] usbcore: registered new interface driver snd-usb-usx2y
[    7.254467] usbcore: registered new interface driver snd-usb-caiaq
[    7.255764] usbcore: registered new interface driver snd-usb-6fire
[    7.271905] ALSA device list:
[    7.272233]   No soundcards found.
[    7.273917] debug: unmapping init [mem 0x81a9c000-0x81b0efff]
[    7.275030] Write protecting the kernel text: 6116k
[    7.275992] Write protecting the kernel read-only data: 2624k
[    7.277371] NX-protecting the kernel data: 6172k
[    7.330701] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    7.331718] IP: [<  (null)>]   (null)
[    7.332189] *pdpt = 00000000072f0001 *pde = 0000000000000000 
[    7.332946] Oops: 0010 [#1] DEBUG_PAGEALLOC
[    7.333507] CPU: 0 PID: 84 Comm: rc.local Not tainted 3.12.0-rc1-00081-g6bfa687 #1
[    7.334828] task: 872fa000 ti: 872fc000 task.ti: 872fc000
[    7.335776] EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
[    7.336128] EIP is at 0x0
[    7.336128] EAX: 82078134 EBX: 872e5780 ECX: 00000000 EDX: 82078134
[    7.336128] ESI: 872fa000 EDI: 872fa388 EBP: 872fdf9c ESP: 872fdf8c
[    7.336128]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    7.336128] CR0: 8005003b CR2: 00000000 CR3: 072e6000 CR4: 000006b0
[    7.336128] Stack:
[    7.336128]  810545c9 00000001 77edff58 776efff4 872fdfac 81002358 00000000 77ef6903
[    7.336128]  872fc000 815f74a0 00000000 00000000 00000000 00000000 00000000 00000000
[    7.336128]  00000000 0000007b 0000007b 00000000 00000000 0000000b 777951d0 00000073
[    7.336128] Call Trace:
[    7.336128]  [<810545c9>] ? task_work_run+0x79/0xb0
[    7.336128]  [<81002358>] do_notify_resume+0x58/0x70
[    7.336128]  [<815f74a0>] work_notifysig+0x2b/0x3b
[    7.336128] Code:  Bad EIP value.
[    7.336128] EIP: [<00000000>] 0x0 SS:ESP 0068:872fdf8c
[    7.336128] CR2: 0000000000000000
[    7.350759] ---[ end trace c4767ad881866043 ]---
[    7.362185] BUG: unable to handle kernel paging request at 01ce0060
[    7.363460] IP: [<810545a4>] task_work_run+0x54/0xb0
[    7.364454] *pdpt = 00000000072d6001 *pde = 0000000000000000 
[    7.365574] Oops: 0000 [#2] DEBUG_PAGEALLOC
[    7.366102] CPU: 0 PID: 85 Comm: hostname Tainted: G      D      3.12.0-rc1-00081-g6bfa687 #1
[    7.366102] task: 872fe000 ti: 87300000 task.ti: 87300000
[    7.366102] EIP: 0060:[<810545a4>] EFLAGS: 00010206 CPU: 0
[    7.366102] EIP is at task_work_run+0x54/0xb0
[    7.366102] EAX: 01ce0060 EBX: 872ef280 ECX: 00000000 EDX: 01ce0060
[    7.366102] ESI: 872fe000 EDI: 872fe388 EBP: 87301f3c ESP: 87301f30
[    7.366102]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    7.366102] CR0: 8005003b CR2: 01ce0060 CR3: 072d1000 CR4: 000006b0
[    7.366102] Stack:
[    7.366102]  ffffffff 872e9580 872fe000 87301f8c 8103a03a 00000014 775fcfb8 8105b4ab
[    7.366102]  00000000 87301fac 00000001 00000015 61636f6c 736f686c 6f6c2e74 872e95d8
[    7.366102]  69616d6f 872e956e 872e95d8 00000000 00000000 872e9000 872fe000 87301fa4
[    7.366102] Call Trace:
[    7.366102]  [<8103a03a>] do_exit+0x2aa/0x920
[    7.366102]  [<8105b4ab>] ? up_write+0x1b/0x30
[    7.366102]  [<8103a742>] do_group_exit+0x52/0xb0
[    7.366102]  [<8103a7b8>] SyS_exit_group+0x18/0x20
[    7.366102]  [<815f7a10>] sysenter_do_call+0x12/0x3c
[    7.366102] Code: 36 31 c9 89 d0 0f b1 0f 39 c2 75 eb 85 d2 74 67 8d b4 26 00 00 00 00 f3 90 8b 86 c0 03 00 00 85 c0 74 f4 31 db eb 04 89 d3 89 c2 <8b> 02 89 1a 85 c0 75 f4 eb 16 66 90 f6 46 0c 04 74 c4 b9 04 f0
[    7.366102] EIP: [<810545a4>] task_work_run+0x54/0xb0 SS:ESP 0068:87301f30
[    7.366102] CR2: 0000000001ce0060
[    7.394265] ---[ end trace c4767ad881866044 ]---
[    7.395167] Fixing recursive fault but reboot is needed!
