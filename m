Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbaHVOoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:44:09 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:37956 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756303AbaHVOoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:44:05 -0400
Date: Fri, 22 Aug 2014 07:43:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 1/2] rcu: Parallelize and economize NOCB
 kthread wakeups
Message-ID: <20140822144331.GF2663@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140812160621.GC4752@linux.vnet.ibm.com>
 <20140812213936.GA3106@linux.vnet.ibm.com>
 <20140812214151.GB3106@linux.vnet.ibm.com>
 <20140813054439.GA29913@grmbl.mre>
 <20140813130049.GS4752@linux.vnet.ibm.com>
 <20140815052411.GF1934@grmbl.mre>
 <20140815150402.GD4752@linux.vnet.ibm.com>
 <20140818175345.GD31856@grmbl.mre>
 <20140819040149.GJ4752@linux.vnet.ibm.com>
 <20140822122453.GG16198@grmbl.mre>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140822122453.GG16198@grmbl.mre>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082214-0928-0000-0000-00000440950B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 05:54:53PM +0530, Amit Shah wrote:
> On (Mon) 18 Aug 2014 [21:01:49], Paul E. McKenney wrote:
> 
> > The odds are low over the next few days.  I am adding nastier rcutorture
> > testing, however.  It would still be very good to get debug information
> > from your setup.  One approach would be to convert the trace function
> > calls into printk(), if that would help.
> 
> I added a few printks on the lines of the traces in cases where
> rcu_nocb_poll was checked -- since that reproduces the hang.  Are the
> following traces sufficient, or should I keep adding more printks?
> 
> In the case of rcu-trace-nopoll.txt, the messages stop after a while
> (when the guest locks up hard).  That's when I kill the qemu process.

Thank you very much for collecting this data!  I will dig through it and
see what I can come up with.

							Thanx, Paul

> 
> 		Amit

> $ ~/build/qemu/x86_64-softmmu/qemu-system-x86_64 -m 256 -enable-kvm  -kernel ~/src/linux/arch/x86/boot/bzImage -vnc :1     -serial stdio -net none  -append 'root=/dev/sda2 console=ttyS0 console=tty0 trace_event=rcu:rcu_nocb_wake'
> Initializing cgroup subsys cpu
> Linux version 3.17.0-rc1+ (amit@grmbl.mre) (gcc version 4.8.3 20140624 (Red Hat 4.8.3-1) (GCC) ) #96 SMP PREEMPT Fri Aug 22 17:46:45 IST 2014
> Command line: root=/dev/sda2 console=ttyS0 console=tty0 trace_event=rcu:rcu_nocb_wake
> e820: BIOS-provided physical RAM map:
> BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> BIOS-e820: [mem 0x0000000000100000-0x000000000ffdffff] usable
> BIOS-e820: [mem 0x000000000ffe0000-0x000000000fffffff] reserved
> BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> NX (Execute Disable) protection: active
> SMBIOS 2.8 present.
> Hypervisor detected: KVM
> AGP: No AGP bridge found
> e820: last_pfn = 0xffe0 max_arch_pfn = 0x400000000
> PAT not supported by CPU.
> init_memory_mapping: [mem 0x00000000-0x000fffff]
> init_memory_mapping: [mem 0x0fc00000-0x0fdfffff]
> init_memory_mapping: [mem 0x0c000000-0x0fbfffff]
> init_memory_mapping: [mem 0x00100000-0x0bffffff]
> init_memory_mapping: [mem 0x0fe00000-0x0ffdffff]
> ACPI: Early table checksum verification disabled
> ACPI: RSDP 0x00000000000F0CB0 000014 (v00 BOCHS )
> ACPI: RSDT 0x000000000FFE1854 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> ACPI: FACP 0x000000000FFE0B37 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> ACPI: DSDT 0x000000000FFE0040 000AF7 (v01 BOCHS  BXPCDSDT 00000001 BXPC 00000001)
> ACPI: FACS 0x000000000FFE0000 000040
> ACPI: SSDT 0x000000000FFE0BAB 000BF9 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> ACPI: APIC 0x000000000FFE17A4 000078 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> ACPI: HPET 0x000000000FFE181C 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
> kvm-clock: Using msrs 4b564d01 and 4b564d00
> kvm-clock: cpu 0, msr 0:ffdf001, primary cpu clock
> Zone ranges:
>   DMA      [mem 0x00001000-0x00ffffff]
>   DMA32    [mem 0x01000000-0xffffffff]
>   Normal   empty
> Movable zone start for each node
> Early memory node ranges
>   node   0: [mem 0x00001000-0x0009efff]
>   node   0: [mem 0x00100000-0x0ffdffff]
> ACPI: PM-Timer IO Port: 0x608
> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
> ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
> IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
> Using ACPI (MADT) for SMP configuration information
> ACPI: HPET id: 0x8086a201 base: 0xfed00000
> smpboot: Allowing 1 CPUs, 0 hotplug CPUs
> PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
> PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
> PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
> e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
> Booting paravirtualized kernel on KVM
> setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:1 nr_node_ids:1
> PERCPU: Embedded 475 pages/cpu @ffff88000fa00000 s1916544 r8192 d20864 u2097152
> KVM setup async PF for cpu 0
> kvm-stealtime: cpu 0, msr fa0cbc0
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64361
> Kernel command line: root=/dev/sda2 console=ttyS0 console=tty0 trace_event=rcu:rcu_nocb_wake
> PID hash table entries: 1024 (order: 1, 8192 bytes)
> Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
> Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
> AGP: Checking aperture...
> AGP: No AGP bridge found
> Memory: 228588K/261624K available (4039K kernel code, 728K rwdata, 2188K rodata, 2872K init, 14176K bss, 33036K reserved)
> SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
> Preemptible hierarchical RCU implementation.
> 	RCU debugfs-based tracing is enabled.
> 	RCU lockdep checking is enabled.
> 	Additional per-CPU info printed with stalls.
> 	RCU restricting CPUs from NR_CPUS=4 to nr_cpu_ids=1.
> 	Offload RCU callbacks from all CPUs
> 	Offload RCU callbacks from CPUs: 0.
> RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=1
> NO_HZ: Full dynticks CPUs: 1-3.
> NR_IRQS:4352 nr_irqs:256 0
> Console: colour VGA+ 80x25
> console [tty0] enabled
> console [ttyS0] enabled
> Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> ... MAX_LOCKDEP_SUBCLASSES:  8
> ... MAX_LOCK_DEPTH:          48
> ... MAX_LOCKDEP_KEYS:        8191
> ... CLASSHASH_SIZE:          4096
> ... MAX_LOCKDEP_ENTRIES:     32768
> ... MAX_LOCKDEP_CHAINS:      65536
> ... CHAINHASH_SIZE:          32768
>  memory used by lock dependency info: 8671 kB
>  per task-struct memory footprint: 2688 bytes
> tsc: Detected 2790.936 MHz processor
> Calibrating delay loop (skipped) preset value.. 5581.87 BogoMIPS (lpj=11163744)
> pid_max: default: 32768 minimum: 301
> ACPI: Core revision 20140724
> ACPI: All ACPI Tables successfully acquired
> Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
> Mountpoint-cache hash table entries: 512 (order: 0, 4096 bytes)
> Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
> debug: unmapping init [mem 0xffffffff81b86000-0xffffffff81b88fff]
> ftrace: allocating 17909 entries in 70 pages
> ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> smpboot: CPU0: Intel QEMU Virtual CPU version 2.1.50 (fam: 06, model: 06, stepping: 03)
> Performance Events: Broken PMU hardware detected, using software events only.
> Failed to access perfctr msr (MSR c1 is 0)
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> x86: Booted up 1 node, 1 CPUs
> smpboot: Total of 1 processors activated (5581.87 BogoMIPS)
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> prandom: seed boundary self test passed
> prandom: 100 self tests passed
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> NET: Registered protocol family 16
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> cpuidle: using governor ladder
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> cpuidle: using governor menu
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> ACPI: bus type PCI registered
> acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> PCI: Using configuration type 1 for base access
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot
> qemu: terminating on signal 2
> 

> $ ~/build/qemu/x86_64-softmmu/qemu-system-x86_64 -m 256 -enable-kvm  -kernel ~/src/linux/arch/x86/boot/bzImage -vnc :1     -serial stdio -net none  -append 'root=/dev/sda2 console=ttyS0 console=tty0 trace_event=rcu:rcu_nocb_wake rcu_nocb_poll'
> Initializing cgroup subsys cpu
> Linux version 3.17.0-rc1+ (amit@grmbl.mre) (gcc version 4.8.3 20140624 (Red Hat 4.8.3-1) (GCC) ) #96 SMP PREEMPT Fri Aug 22 17:46:45 IST 2014
> Command line: root=/dev/sda2 console=ttyS0 console=tty0 trace_event=rcu:rcu_nocb_wake rcu_nocb_poll
> e820: BIOS-provided physical RAM map:
> BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> BIOS-e820: [mem 0x0000000000100000-0x000000000ffdffff] usable
> BIOS-e820: [mem 0x000000000ffe0000-0x000000000fffffff] reserved
> BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> NX (Execute Disable) protection: active
> SMBIOS 2.8 present.
> Hypervisor detected: KVM
> AGP: No AGP bridge found
> e820: last_pfn = 0xffe0 max_arch_pfn = 0x400000000
> PAT not supported by CPU.
> init_memory_mapping: [mem 0x00000000-0x000fffff]
> init_memory_mapping: [mem 0x0fc00000-0x0fdfffff]
> init_memory_mapping: [mem 0x0c000000-0x0fbfffff]
> init_memory_mapping: [mem 0x00100000-0x0bffffff]
> init_memory_mapping: [mem 0x0fe00000-0x0ffdffff]
> ACPI: Early table checksum verification disabled
> ACPI: RSDP 0x00000000000F0CB0 000014 (v00 BOCHS )
> ACPI: RSDT 0x000000000FFE1854 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> ACPI: FACP 0x000000000FFE0B37 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> ACPI: DSDT 0x000000000FFE0040 000AF7 (v01 BOCHS  BXPCDSDT 00000001 BXPC 00000001)
> ACPI: FACS 0x000000000FFE0000 000040
> ACPI: SSDT 0x000000000FFE0BAB 000BF9 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> ACPI: APIC 0x000000000FFE17A4 000078 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> ACPI: HPET 0x000000000FFE181C 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
> kvm-clock: Using msrs 4b564d01 and 4b564d00
> kvm-clock: cpu 0, msr 0:ffdf001, primary cpu clock
> Zone ranges:
>   DMA      [mem 0x00001000-0x00ffffff]
>   DMA32    [mem 0x01000000-0xffffffff]
>   Normal   empty
> Movable zone start for each node
> Early memory node ranges
>   node   0: [mem 0x00001000-0x0009efff]
>   node   0: [mem 0x00100000-0x0ffdffff]
> ACPI: PM-Timer IO Port: 0x608
> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
> ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
> IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
> Using ACPI (MADT) for SMP configuration information
> ACPI: HPET id: 0x8086a201 base: 0xfed00000
> smpboot: Allowing 1 CPUs, 0 hotplug CPUs
> PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
> PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
> PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
> e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
> Booting paravirtualized kernel on KVM
> setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:1 nr_node_ids:1
> PERCPU: Embedded 475 pages/cpu @ffff88000fa00000 s1916544 r8192 d20864 u2097152
> KVM setup async PF for cpu 0
> kvm-stealtime: cpu 0, msr fa0cbc0
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64361
> Kernel command line: root=/dev/sda2 console=ttyS0 console=tty0 trace_event=rcu:rcu_nocb_wake rcu_nocb_poll
> PID hash table entries: 1024 (order: 1, 8192 bytes)
> Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
> Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
> AGP: Checking aperture...
> AGP: No AGP bridge found
> Memory: 228588K/261624K available (4039K kernel code, 728K rwdata, 2188K rodata, 2872K init, 14176K bss, 33036K reserved)
> SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
> Preemptible hierarchical RCU implementation.
> 	RCU debugfs-based tracing is enabled.
> 	RCU lockdep checking is enabled.
> 	Additional per-CPU info printed with stalls.
> 	RCU restricting CPUs from NR_CPUS=4 to nr_cpu_ids=1.
> 	Offload RCU callbacks from all CPUs
> 	Offload RCU callbacks from CPUs: 0.
> 	Poll for callbacks from no-CBs CPUs.
> RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=1
> NO_HZ: Full dynticks CPUs: 1-3.
> NR_IRQS:4352 nr_irqs:256 0
> Console: colour VGA+ 80x25
> console [tty0] enabled
> console [ttyS0] enabled
> Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> ... MAX_LOCKDEP_SUBCLASSES:  8
> ... MAX_LOCK_DEPTH:          48
> ... MAX_LOCKDEP_KEYS:        8191
> ... CLASSHASH_SIZE:          4096
> ... MAX_LOCKDEP_ENTRIES:     32768
> ... MAX_LOCKDEP_CHAINS:      65536
> ... CHAINHASH_SIZE:          32768
>  memory used by lock dependency info: 8671 kB
>  per task-struct memory footprint: 2688 bytes
> tsc: Detected 2790.936 MHz processor
> Calibrating delay loop (skipped) preset value.. 5581.87 BogoMIPS (lpj=11163744)
> pid_max: default: 32768 minimum: 301
> ACPI: Core revision 20140724
> ACPI: All ACPI Tables successfully acquired
> Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
> Mountpoint-cache hash table entries: 512 (order: 0, 4096 bytes)
> Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
> debug: unmapping init [mem 0xffffffff81b86000-0xffffffff81b88fff]
> ftrace: allocating 17909 entries in 70 pages
> ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> smpboot: CPU0: Intel QEMU Virtual CPU version 2.1.50 (fam: 06, model: 06, stepping: 03)
> Performance Events: Broken PMU hardware detected, using software events only.
> Failed to access perfctr msr (MSR c1 is 0)
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_sched 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_bh 0 Poll
> x86: Booted up 1 node, 1 CPUs
> smpboot: Total of 1 processors activated (5581.87 BogoMIPS)
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> prandom: seed boundary self test passed
> prandom: 100 self tests passed
> NET: Registered protocol family 16
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> cpuidle: using governor ladder
> cpuidle: using governor menu
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> ACPI: bus type PCI registered
> acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> PCI: Using configuration type 1 for base access
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> ACPI: Added _OSI(Module Device)
> ACPI: Added _OSI(Processor Device)
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> ACPI: Added _OSI(3.0 _SCP Extensions)
> ACPI: Added _OSI(Processor Aggregator Device)
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> ACPI: Interpreter enabled
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140724/hwxface-580)
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140724/hwxface-580)
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> ACPI: (supports S0 S3 S4 S5)
> ACPI: Using IOAPIC for interrupt routing
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> acpiphp: Slot [3] registered
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> acpiphp: Slot [4] registered
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> acpiphp: Slot [5] registered
> acpiphp: Slot [6] registered
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> acpiphp: Slot [7] registered
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> acpiphp: Slot [8] registered
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> acpiphp: Slot [9] registered
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> acpiphp: Slot [10] registered
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> acpiphp: Slot [11] registered
> acpiphp: Slot [12] registered
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> acpiphp: Slot [13] registered
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> acpiphp: Slot [14] registered
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> acpiphp: Slot [15] registered
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> acpiphp: Slot [16] registered
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> acpiphp: Slot [17] registered
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> acpiphp: Slot [18] registered
> acpiphp: Slot [19] registered
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> acpiphp: Slot [20] registered
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> acpiphp: Slot [21] registered
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> acpiphp: Slot [22] registered
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> acpiphp: Slot [23] registered
> acpiphp: Slot [24] registered
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> acpiphp: Slot [25] registered
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> acpiphp: Slot [26] registered
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> acpiphp: Slot [27] registered
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> acpiphp: Slot [28] registered
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> acpiphp: Slot [29] registered
> acpiphp: Slot [30] registered
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> acpiphp: Slot [31] registered
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> PCI host bridge to bus 0000:00
> pci_bus 0000:00: root bus resource [bus 00-ff]
> pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
> pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
> pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
> pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
> pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> pci_bus 0000:00: root bus resource [mem 0x10000000-0xfebfffff]
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
> pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
> pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
> pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX4 ACPI
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX4 SMB
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> ACPI: PCI Interrupt Link [LNKB] (IRQs
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
>  5 *10 11)
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> ACPI: PCI Interrupt Link [LNKS] (IRQs *9
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> )
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> ACPI: Enabled 16 GPEs in block 00 to 0F
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> vgaarb: loaded
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> vgaarb: bridge control possible 0000:00:02.0
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> SCSI subsystem initialized
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> pps_core: LinuxPPS API ver. 1 registered
> pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> PTP clock support registered
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> PCI: Using ACPI for IRQ routing
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> Switched to clocksource kvm-clock
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> pnp: PnP ACPI init
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> pnp: PnP ACPI: found 6 devices
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> NET: Registered protocol family 2
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> TCP established hash table entries: 2048 (order: 2, 16384 bytes)
> TCP bind hash table entries: 2048 (order: 5, 163840 bytes)
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> TCP: Hash tables configured (established 2048 bind 2048)
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> TCP: reno registered
> UDP hash table entries: 256 (order: 3, 49152 bytes)
> UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> NET: Registered protocol family 1
> pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> pci 0000:00:01.0: PIIX3: Enabling Passive Release
> pci 0000:00:01.0: Activating ISA DMA hang workarounds
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> rcu-torture:--- Start of test: nreaders=1 nfakewriters=4 stat_interval=60 verbose=1 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 stall_cpu=0 stall_cpu_holdoff=10 n_barrier_cbs=0 onoff_interval=0 onoff_holdoff=0
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> rcu-torture: Creating rcu_torture_writer task
> rcu-torture: Creating rcu_torture_fakewriter task
> rcu-torture: rcu_torture_writer task started
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> rcu-torture: Creating rcu_torture_fakewriter task
> rcu-torture: rcu_torture_fakewriter task started
> rcu-torture: Creating rcu_torture_fakewriter task
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> rcu-torture: rcu_torture_fakewriter task started
> rcu-torture: Creating rcu_torture_fakewriter task
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> rcu-torture: rcu_torture_fakewriter task started
> rcu-torture: Creating rcu_torture_reader task
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> rcu-torture: rcu_torture_fakewriter task started
> rcu-torture: Creating rcu_torture_stats task
> rcu-torture: rcu_torture_reader task started
> rcu-torture: Creating torture_shuffle task
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> rcu-torture: rcu_torture_stats task started
> rcu-torture: Creating torture_stutter task
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> rcu-torture: torture_shuffle task started
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> rcu-torture: torture_stutter task started
> futex hash table entries: 256 (order: 3, 32768 bytes)
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> audit: initializing netlink subsys (disabled)
> audit: type=2000 audit(1408709846.260:1): initialized
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> HugeTLB registered 2 MB page size, pre-allocated 0 pages
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> msgmni has been set to 446
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> io scheduler noop registered (default)
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> ACPI: Power Button [PWRF]
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> Non-volatile memory driver v1.3
> Linux agpgart interface v0.103
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> brd: module loaded
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> loop: module loaded
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> scsi host0: ata_piix
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> scsi host1: ata_piix
> ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc000 irq 14
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc008 irq 15
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> libphy: Fixed MDIO Bus: probed
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
> e1000: Copyright (c) 1999-2006 Intel Corporation.
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> serio: i8042 KBD port at 0x60,0x64 irq 1
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> serio: i8042 AUX port at 0x60,0x64 irq 12
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> mousedev: PS/2 mouse device common for all mice
> input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> pps pps0: new PPS source ktimer
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> pps pps0: ktimer PPS source registered
> pps_ldisc: PPS line discipline registered
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> TCP: cubic registered
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> NET: Registered protocol family 17
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> kmemleak: Kernel memory leak detector initialized
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> kmemleak: Automatic memory scanning thread started
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> ata2.00: ATAPI: QEMU DVD-ROM, 2.1.50, max UDMA/100
> ata2.00: configured for MWDMA2
> scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     2.1. PQ: 0 ANSI: 5
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> sr 1:0:0:0: [sr0] scsi3-mmc drive: 4x/4x cd/rw xa/form2 tray
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> cdrom: Uniform CD-ROM driver Revision: 3.20
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> VFS: Cannot open root device "sda2" or unknown-block(0,0): error -6
> Please append a correct "root=" boot option; here are the available partitions:
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> 0b00         1048575 sr0  driver: sr
> RCUDEBUG nocb_leader_wait 2275 rcu_preempt 0 Poll
> Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc1+ #96
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
>  0000000000000000 00000000b5808356 ffff88000e953df0 ffffffff813e7be9
>  ffffffff8157cb44 ffff88000e953e70 ffffffff813e3e62 3030623000000010
>  ffff88000e953e80 ffff88000e953e20 00000000b5808356 0000000000000008
> Call Trace:
>  [<ffffffff813e7be9>] dump_stack+0x4e/0x7a
>  [<ffffffff813e3e62>] panic+0xec/0x20f
>  [<ffffffff81a8d46f>] mount_block_root+0x296/0x2a5
>  [<ffffffff81a8d61b>] mount_root+0x53/0x56
>  [<ffffffff81a8d785>] prepare_namespace+0x167/0x193
>  [<ffffffff81a8d102>] kernel_init_freeable+0x187/0x194
>  [<ffffffff81a8c7f0>] ? do_early_param+0x88/0x88
>  [<ffffffff813e083f>] ? rest_init+0x133/0x133
>  [<ffffffff813e084d>] kernel_init+0xe/0xda
>  [<ffffffff813eeebc>] ret_from_fork+0x7c/0xb0
>  [<ffffffff813e083f>] ? rest_init+0x133/0x133
> Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
> ---[ end Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
> qemu: terminating on signal 2

