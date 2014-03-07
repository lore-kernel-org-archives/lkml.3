Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbaCGJ5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:57:48 -0500
Received: from www84.your-server.de ([213.133.104.84]:48754 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaCGJ5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:57:39 -0500
Message-ID: <1394186248.28066.42.camel@wall-e.seibold.net>
Subject: Re: [x86, vdso]  BUG: unable to handle kernel paging request at
 d34bd000
From: Stefani Seibold <stefani@seibold.net>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Fri, 07 Mar 2014 10:57:28 +0100
In-Reply-To: <20140307091515.GA8888@localhost>
References: <20140307013833.GD8427@localhost>
	 <1394182034.21684.6.camel@wall-e.seibold.net>
	 <20140307091515.GA8888@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fengguang,

did you test the config i had sent to you?

My test was all done with current 3.14-rc tree. And with this i have no
problem. 

I just cloned the tip tree and i figured out that the patch was dropped
again (BTW: git log does not show that it was ever applied).

Okay, that's enough for me. If it nearly impossible to cut this gordian
knot without support and test from the intel kernel developer group.

The origin code was not in the best shape too. I cannot understand why
this was going into mainline without 32 bit support.

So i tried my best, but without support it is impossible to find all
issues. But mostly what i get was bureaucracy afflictions

I complied, but now it is time to help finding the issues. And not only
do a complain, sit back and wait.

If i haed a  8192 core i7 XEON machine i would be able to test all
mutations of kernels. But i have not (despite i cannot pay the invoice).

Also i get no support by people who ask me to do this work. I am really
pissed of.

- Stefani

Am Freitag, den 07.03.2014, 17:15 +0800 schrieb Fengguang Wu:

> Hi Stefani,
> 
> On Fri, Mar 07, 2014 at 09:47:14AM +0100, Stefani Seibold wrote:
> > Hi Fengguang,
> > 
> > i was now able to bring up the kernel on my KVM with some minior
> > changes. I kick out the PARIDE, switched to IDE and activated the VT
> > support. With this modifications the kernel boot and i get no BUG,
> > everything is fine!
> > 
> > So i can not reproduce the bug and i want ask you to check the attached
> > kernel config. If this also works for you the problem is maybe located
> > in the environment, f.e. gcc.
> 
> I'm using gcc 4.8.1, as you can see from the 2nd line of the below dmesg.
> I can reproduce it reliably - see the screen dump below. You can find
> the reproduce script at the end of this email.
> 
> wfg@bee /kernel/i386-randconfig-nh0-03070222/d478a960edf1ea61ca31a07a48a8771f043dba78% kvm-0day.sh vmlinuz-3.14.0-rc5-03765-gd478a96
> early console in setup code
> [    0.000000] Linux version 3.14.0-rc5-03765-gd478a96 (kbuild@nhm4) (gcc version 4.8.1 (Debian 4.8.1-8) ) #2 SMP PREEMPT Fri Mar 7 03:16:44 CST 2014
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] debug: ignoring loglevel setting.
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] Hypervisor detected: KVM
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x1000000
> [    0.000000] MTRR default type: write-back
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 0080000000 mask FF80000000 uncachable
> [    0.000000]   1 disabled
> [    0.000000]   2 disabled
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] initial memory mapped: [mem 0x00000000-0x023fffff]
> [    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x0fa00000-0x0fbfffff]
> [    0.000000]  [mem 0x0fa00000-0x0fbfffff] page 4k
> [    0.000000] BRK [0x01e02000, 0x01e02fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x0c000000-0x0f9fffff]
> [    0.000000]  [mem 0x0c000000-0x0f9fffff] page 4k
> [    0.000000] BRK [0x01e03000, 0x01e03fff] PGTABLE
> [    0.000000] BRK [0x01e04000, 0x01e04fff] PGTABLE
> [    0.000000] BRK [0x01e05000, 0x01e05fff] PGTABLE
> [    0.000000] BRK [0x01e06000, 0x01e06fff] PGTABLE
> [    0.000000] BRK [0x01e07000, 0x01e07fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
> [    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
> [    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
> [    0.000000] RAMDISK: [mem 0x0fce6000-0x0ffeffff]
> [    0.000000] ACPI: RSDP 0x000F16B0 000014 (v00 BOCHS )
> [    0.000000] ACPI: RSDT 0x0FFFE3F0 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACP 0x0FFFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> [    0.000000] ACPI: DSDT 0x0FFFE430 001137 (v01 BXPC   BXDSDT   00000001 INTL 20100528)
> [    0.000000] ACPI: FACS 0x0FFFFF40 000040
> [    0.000000] ACPI: SSDT 0x0FFFF6A0 000899 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: APIC 0x0FFFF5B0 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> [    0.000000] ACPI: HPET 0x0FFFF570 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to         ffff9000 (        fee00000)
> [    0.000000] 255MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 0fffe000
> [    0.000000]   low ram: 0 - 0fffe000
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
> [    0.000000] On node 0 totalpages: 65436
> [    0.000000] free_area_init_node: node 0, pgdat c17e5120, node_mem_map cf958024
> [    0.000000]   DMA zone: 36 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 3998 pages, LIFO batch:0
> [    0.000000]   Normal zone: 540 pages used for memmap
> [    0.000000]   Normal zone: 61438 pages, LIFO batch:15
> [    0.000000] Using APIC driver default
> [    0.000000] ACPI: PM-Timer IO Port: 0xb008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to         ffff9000 (        fee00000)
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC INT 05
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
> [    0.000000] ACPI: IRQ5 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] ACPI: IRQ10 used by override.
> [    0.000000] ACPI: IRQ11 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] mapped IOAPIC to ffff8000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on KVM
> [    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 17 pages/cpu @cfcc4000 s48368 r0 d21264 u69632
> [    0.000000] pcpu-alloc: s48368 r0 d21264 u69632 alloc=17*4096
> [    0.000000] pcpu-alloc: [0] 0 [0] 1
> [    0.000000] KVM setup async PF for cpu 0
> [    0.000000] kvm-stealtime: cpu 0, msr fcc6980
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64860
> [    0.000000] Kernel command line: debug sched_debug apic=debug ignore_loglevel earlyprintk=ttyS0,115200 sysrq_always_enabled panic=10 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal root=/dev/ram0 rw
> [    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
> [    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
> [    0.000000] Initializing CPU#0
> [    0.000000] Memory: 241112K/261744K available (5504K kernel code, 558K rwdata, 2224K rodata, 536K init, 5424K bss, 20632K reserved)
> [    0.000000] virtual kernel memory layout:
> [    0.000000]     fixmap  : 0xffd34000 - 0xfffff000   (2860 kB)
> [    0.000000]     vmalloc : 0xd07fe000 - 0xffd32000   ( 757 MB)
> [    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
> [    0.000000]       .init : 0xc181a000 - 0xc18a0000   ( 536 kB)
> [    0.000000]       .data : 0xc15603c2 - 0xc18189a0   (2785 kB)
> [    0.000000]       .text : 0xc1000000 - 0xc15603c2   (5504 kB)
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000]  Dump stacks of tasks blocking RCU-preempt GP.
> [    0.000000]  Additional per-CPU info printed with stalls.
> [    0.000000]  RCU restricting CPUs from NR_CPUS=32 to nr_cpu_ids=2.
> [    0.000000]  Offload RCU callbacks from all CPUs
> [    0.000000]  Offload RCU callbacks from CPUs: 0-1.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
> [    0.000000] NR_IRQS:2304 nr_irqs:512 16
> [    0.000000] CPU 0 irqstacks, hard=cf41c000 soft=cf41e000
> [    0.000000] ACPI: Core revision 20140214
> [    0.000000] ACPI: All ACPI Tables successfully acquired
> [    0.000000] console [ttyS0] enabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
> [    0.000000] ... CHAINHASH_SIZE:          16384
> [    0.000000]  memory used by lock dependency info: 3567 kB
> [    0.000000]  per task-struct memory footprint: 1152 bytes
> [    0.000000] ------------------------
> [    0.000000] | Locking API testsuite:
> [    0.000000] ----------------------------------------------------------------------------
> [    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
> [    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
> [    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
> [    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
> [    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
> [    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
> [    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
> [    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
> [    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
> [    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
> [    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
> [    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
> [    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
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
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]   | Wound/wait tests |
> [    0.000000]   ---------------------
> [    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
> [    0.000000]                ww contexts mixing:  ok  |  ok  |
> [    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
> [    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]            spinlock nest unlocked:  ok  |
> [    0.000000]   -----------------------------------------------------
> [    0.000000]                                  |block | try  |context|
> [    0.000000]   -----------------------------------------------------
> [    0.000000]                           context:  ok  |  ok  |  ok  |
> [    0.000000]                               try:  ok  |  ok  |  ok  |
> [    0.000000]                             block:  ok  |  ok  |  ok  |
> [    0.000000]                          spinlock:  ok  |  ok  |  ok  |
> [    0.000000] -------------------------------------------------------
> [    0.000000] Good, all 253 testcases passed! |
> [    0.000000] ---------------------------------
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Detected 2693.508 MHz processor
> [    0.003000] Calibrating delay loop (skipped) preset value.. 5387.01 BogoMIPS (lpj=2693508)
> [    0.004014] pid_max: default: 4096 minimum: 301
> [    0.006232] Mount-cache hash table entries: 512
> [    0.009437] mce: CPU supports 10 MCE banks
> [    0.010118] BUG: unable to handle kernel paging request at cf4be000
> [    0.011000] IP: [<c182dbca>] sysenter_setup+0x9a/0x2d4
> [    0.011000] *pdpt = 00000000018a4001 *pde = 000000000fbea067 *pte = 800000000f4be060
> [    0.011000] Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [    0.011000] Modules linked in:
> [    0.011000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc5-03765-gd478a96 #2
> [    0.011000] task: c17997c0 ti: c178e000 task.ti: c178e000
> [    0.011000] EIP: 0060:[<c182dbca>] EFLAGS: 00210212 CPU: 0
> [    0.011000] EIP is at sysenter_setup+0x9a/0x2d4
> [    0.011000] EAX: 078bfbfd EBX: cf4bd000 ECX: 00000004 EDX: 00001004
> [    0.011000] ESI: c186740c EDI: cf4be000 EBP: c178ff98 ESP: c178ff74
> [    0.011000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [    0.011000] CR0: 8005003b CR2: cf4be000 CR3: 018a7000 CR4: 000006f0
> [    0.011000] Stack:
> [    0.011000]  00200202 c1dbb0f0 00000f61 00000800 80002001 078bfbfd 00000000 00000000
> [    0.011000]  c18a8800 c178ffa0 c1821144 c178ffbc c182117d 00000000 c178ffbc 00000000
> [    0.011000]  00000000 c18a8800 c178ffec c181ab11 00000101 ffffffff ffffffff c181a549
> [    0.011000] Call Trace:
> [    0.011000]  [<c1821144>] identify_boot_cpu+0x17/0x28
> [    0.011000]  [<c182117d>] check_bugs+0xe/0x160
> [    0.011000]  [<c181ab11>] start_kernel+0x401/0x470
> [    0.011000]  [<c181a549>] ? repair_env_string+0x51/0x51
> [    0.011000]  [<c181a364>] i386_start_kernel+0x12e/0x131
> [    0.011000] Code: f6 c4 08 74 12 ba 10 74 86 c1 81 ea 0c 64 86 c1 be 0c 64 86 c1 eb 10 ba 0c 64 86 c1 81 ea 1c 54 86 c1 be 1c 54 86 c1 89 df 89 d1 <f3> a4 89 d8 e8 8b fe ff ff b9 04 00 00 00 ba d6 c2 6e c1 89 d8
> [    0.011000] EIP: [<c182dbca>] sysenter_setup+0x9a/0x2d4 SS:ESP 0068:c178ff74
> [    0.011000] CR2: 00000000cf4be000
> [    0.011000] ---[ end trace db4b7fde7786bb07 ]---
> [    0.011000] Kernel panic - not syncing: Fatal exception
> [    0.011000] Rebooting in 10 seconds..
> 
> wfg@bee /kernel/i386-randconfig-an1-03070605/d478a960edf1ea61ca31a07a48a8771f043dba78% kvm-0day.sh vmlinuz-3.14.0-rc5-03765-gd478a96
> early console in setup code
> Probing EDD (edd=off to disable)... ok
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.14.0-rc5-03765-gd478a96 (kbuild@ant) (gcc version 4.8.1 (Debian 4.8.1-8) ) #4 SMP Fri Mar 7 06:43:04 CST 2014
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   Centaur CentaurHauls
> [    0.000000]   UMC UMC UMC UMC
> [    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
> [    0.000000] CPU: Your system may be unstable.
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] debug: ignoring loglevel setting.
> [    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
> [    0.000000] SMBIOS 2.4 present.
> [    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
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
> [    0.000000]   0 base 0080000000 mask FF80000000 uncachable
> [    0.000000]   1 disabled
> [    0.000000]   2 disabled
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
> [    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
> [    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
> [    0.000000] found SMP MP-table at [mem 0x000f1840-0x000f184f] mapped at [800f1840]
> [    0.000000]   mpc: f1850-f193c
> [    0.000000] initial memory mapped: [mem 0x00000000-0x02bfffff]
> [    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x0f800000-0x0fbfffff]
> [    0.000000]  [mem 0x0f800000-0x0fbfffff] page 4k
> [    0.000000] BRK [0x027a7000, 0x027a7fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x08000000-0x0f7fffff]
> [    0.000000]  [mem 0x08000000-0x0f7fffff] page 4k
> [    0.000000] BRK [0x027a8000, 0x027a8fff] PGTABLE
> [    0.000000] BRK [0x027a9000, 0x027a9fff] PGTABLE
> [    0.000000] BRK [0x027aa000, 0x027aafff] PGTABLE
> [    0.000000] BRK [0x027ab000, 0x027abfff] PGTABLE
> [    0.000000] BRK [0x027ac000, 0x027acfff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
> [    0.000000]  [mem 0x00100000-0x07ffffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
> [    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
> [    0.000000] RAMDISK: [mem 0x0fce6000-0x0ffeffff]
> [    0.000000] ACPI: RSDP 0x000F16B0 000014 (v00 BOCHS )
> [    0.000000] ACPI: RSDT 0x0FFFE3F0 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACP 0x0FFFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> [    0.000000] ACPI: DSDT 0x0FFFE430 001137 (v01 BXPC   BXDSDT   00000001 INTL 20100528)
> [    0.000000] ACPI: FACS 0x0FFFFF40 000040
> [    0.000000] ACPI: SSDT 0x0FFFF6A0 000899 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: APIC 0x0FFFF5B0 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> [    0.000000] ACPI: HPET 0x0FFFF570 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to         ffff9000 (        fee00000)
> [    0.000000] 0MB HIGHMEM available.
> [    0.000000] 255MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 0fffe000
> [    0.000000]   low ram: 0 - 0fffe000
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:fffb001, primary cpu clock
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
> [    0.000000]   HighMem  empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
> [    0.000000] On node 0 totalpages: 65436
> [    0.000000] free_area_init_node: node 0, pgdat 82003620, node_mem_map 8f951028
> [    0.000000]   DMA zone: 40 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 3998 pages, LIFO batch:0
> [    0.000000]   Normal zone: 600 pages used for memmap
> [    0.000000]   Normal zone: 61438 pages, LIFO batch:15
> [    0.000000] Using APIC driver default
> [    0.000000] ACPI: PM-Timer IO Port: 0xb008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to         ffff9000 (        fee00000)
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC INT 05
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
> [    0.000000] ACPI: IRQ5 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] ACPI: IRQ10 used by override.
> [    0.000000] ACPI: IRQ11 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] mapped IOAPIC to ffff8000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on KVM
> [    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 334 pages/cpu @8f6b5000 s1355376 r0 d12688 u1368064
> [    0.000000] pcpu-alloc: s1355376 r0 d12688 u1368064 alloc=334*4096
> [    0.000000] pcpu-alloc: [0] 0 [0] 1
> [    0.000000] KVM setup async PF for cpu 0
> [    0.000000] kvm-stealtime: cpu 0, msr f6b7540
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64796
> [    0.000000] Kernel command line: debug sched_debug apic=debug ignore_loglevel earlyprintk=ttyS0,115200 sysrq_always_enabled panic=10 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal root=/dev/ram0 rw
> [    0.000000] sysrq: sysrq always enabled.
> [    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
> [    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
> [    0.000000] Initializing CPU#0
> [    0.000000] Initializing HighMem for node 0 (00000000:00000000)
> [    0.000000] Memory: 228660K/261744K available (11636K kernel code, 868K rwdata, 4068K rodata, 1956K init, 5592K bss, 33084K reserved, 0K highmem)
> [    0.000000] virtual kernel memory layout:
> [    0.000000]     fixmap  : 0xffa93000 - 0xfffff000   (5552 kB)
> [    0.000000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
> [    0.000000]     vmalloc : 0x907fe000 - 0xff3fe000   (1772 MB)
> [    0.000000]     lowmem  : 0x80000000 - 0x8fffe000   ( 255 MB)
> [    0.000000]       .init : 0x82033000 - 0x8221c000   (1956 kB)
> [    0.000000]       .data : 0x81b5d71f - 0x82031360   (4943 kB)
> [    0.000000]       .text : 0x81000000 - 0x81b5d71f   (11637 kB)
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000]  RCU debugfs-based tracing is enabled.
> [    0.000000]  Hierarchical RCU autobalancing is disabled.
> [    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
> [    0.000000]  Additional per-CPU info printed with stalls.
> [    0.000000]  RCU restricting CPUs from NR_CPUS=32 to nr_cpu_ids=2.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
> [    0.000000] NR_IRQS:2304 nr_irqs:512 16
> [    0.000000] CPU 0 irqstacks, hard=8f00a000 soft=8f00c000
> [    0.000000] ACPI: Core revision 20140214
> [    0.000000] ACPI: All ACPI Tables successfully acquired
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
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]   | Wound/wait tests |
> [    0.000000]   ---------------------
> [    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
> [    0.000000]                ww contexts mixing:failed|  ok  |
> [    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
> [    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]            spinlock nest unlocked:  ok  |
> [    0.000000]   -----------------------------------------------------
> [    0.000000]                                  |block | try  |context|
> [    0.000000]   -----------------------------------------------------
> [    0.000000]                           context:failed|  ok  |  ok  |
> [    0.000000]                               try:failed|  ok  |failed|
> [    0.000000]                             block:failed|  ok  |failed|
> [    0.000000]                          spinlock:failed|  ok  |failed|
> [    0.000000] --------------------------------------------------------
> [    0.000000] 141 out of 253 testcases failed, as expected. |
> [    0.000000] ----------------------------------------------------
> [    0.000000] ODEBUG: 12 of 12 active objects replaced
> [    0.000000] ODEBUG: selftest passed
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Detected 2693.508 MHz processor
> [    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
> [    0.012000] Calibrating delay loop (skipped) preset value.. 5387.01 BogoMIPS (lpj=10774032)
> [    0.012000] pid_max: default: 4096 minimum: 301
> [    0.012000] Mount-cache hash table entries: 512
> [    0.012478] Initializing cgroup subsys debug
> [    0.013140] Initializing cgroup subsys devices
> [    0.013910] Initializing cgroup subsys freezer
> [    0.014670] Initializing cgroup subsys net_cls
> [    0.015356] Initializing cgroup subsys blkio
> [    0.016026] Initializing cgroup subsys perf_event
> [    0.017443] Initializing cgroup subsys net_prio
> [    0.020061] BUG: unable to handle kernel paging request at 8f024000
> [    0.021717] IP: [<820444c8>] sysenter_setup+0x90/0x2b4
> [    0.023188] *pde = 0fbe8067 *pte = 0f024060
> [    0.024000] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
> [    0.024000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc5-03765-gd478a96 #4
> [    0.024000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    0.024000] task: 81f5ff20 ti: 81f58000 task.ti: 81f58000
> [    0.024000] EIP: 0060:[<820444c8>] EFLAGS: 00210206 CPU: 0
> [    0.024000] EIP is at sysenter_setup+0x90/0x2b4
> [    0.024000] EAX: 078bfbfd EBX: 8f023000 ECX: 00000044 EDX: 00001044
> [    0.024000] ESI: 82091418 EDI: 8f024000 EBP: 81f59fb4 ESP: 81f59f90
> [    0.024000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [    0.024000] CR0: 8005003b CR2: 8f024000 CR3: 02228000 CR4: 00000690
> [    0.024000] Stack:
> [    0.024000]  81f6d0c0 8f022b80 00000f61 00000800 80002001 078bfbfd 820850e0 00020800
> [    0.024000]  82229800 81f59fbc 82039789 81f59fcc 820397bf 820850e0 00020800 81f59fec
> [    0.024000]  82033a6d 0000027e ffffffff ffffffff 82033530 820850e0 00000800 81f59ff8
> [    0.024000] Call Trace:
> [    0.024000]  [<82039789>] identify_boot_cpu+0x17/0x28
> [    0.024000]  [<820397bf>] check_bugs+0xb/0xbb
> [    0.024000]  [<82033a6d>] start_kernel+0x376/0x381
> [    0.024000]  [<82033530>] ? repair_env_string+0x51/0x51
> [    0.024000]  [<82033364>] i386_start_kernel+0x12e/0x131
> [    0.024000] Code: f6 c4 08 74 12 ba 5c 14 09 82 be 18 04 09 82 81 ea 18 04 09 82 eb 10 ba 18 04 09 82 be e8 f3 08 82 81 ea e8 f3 08 82 89 d1 89 df <f3> a4 89 d8 e8 bf fe ff ff b9 04 00 00 00 ba c0 39 df 81 89 d8
> [    0.024000] EIP: [<820444c8>] sysenter_setup+0x90/0x2b4 SS:ESP 0068:81f59f90
> [    0.024000] CR2: 000000008f024000
> [    0.024000] ---[ end trace ebb41f6832ca3e69 ]---
> [    0.024000] Kernel panic - not syncing: Attempted to kill the idle task!
> [    0.024000] Rebooting in 10 seconds..
> 
> 
> % cat /home/wfg/bin/kvm-0day.sh                       
> #!/bin/bash
> 
> kvm=(
>         qemu-system-x86_64 -cpu kvm64 -enable-kvm
>         -kernel $1
>         # -initrd /kernel-tests/initrd/yocto-minimal-i386.cgz
>         -initrd /kernel-tests/initrd/yocto-minimal-x86_64.cgz
>         # -initrd /kernel-tests/initrd/quantal-core-i386.cgz
>         # -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz
>         -smp 2
>         -m 256M
>         -net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio
>         -net user,vlan=0
>         -net nic,vlan=1,model=e1000
>         -net user,vlan=1
>         -boot order=nc
>         -no-reboot
>         -watchdog i6300esb
>         -serial stdio
>         -display none
>         -monitor null
> )
> 
> append=(
>         debug
>         sched_debug
>         apic=debug
>         ignore_loglevel
>         # dyndbg=\"func kobject_release +p\"
>         earlyprintk=ttyS0,115200
>         sysrq_always_enabled
>         panic=10
>         prompt_ramdisk=0
>         console=ttyS0,115200
>         console=tty0
>         vga=normal
>         root=/dev/ram0
>         rw
> )
> 
> "${kvm[@]}" --append "${append[*]}"


