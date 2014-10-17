Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbaJQLJB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 07:09:01 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:59920 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbaJQLI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 07:08:57 -0400
Date: Fri, 17 Oct 2014 14:08:53 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: kernel BUG at kernel/sched/core.c:2702!
Message-ID: <alpine.LRH.2.11.1410171401110.25429@adalberg.ut.ee>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am seeing this BUG on 3 different sparc64 machines with yesterdays 
git. sparc64-specific known problems were just fixed before, 
3.17.0-07551-g052db7e + slab alignment fix patch + sparc64 SIGBUS fix 
patch is working stable for me, whereas 3.17.0-09670-g0429fbc + SIGBUS 
patch fails on 3 machines (all I tried). Will try bisecting later if I 
get time.

dmesg:

Software Power ON
3,0>ERROR: TEST=NVRAM Devices,SUBTEST=M48T59 (TOD) Init ID=8.1
3,0>Component under test: Board 1 Firehose Bus
3,0>TODC battery is low bit set
5-slot Sun Enterprise E3500, No Keyboard
OpenBoot 3.2.30, 2048 MB memory installed, Serial #11988706.
Copyright 2002 Sun Microsystems, Inc.  All rights reserved
Ethernet address 8:0:20:b6:ee:e2, Host ID: 80b6eee2.



Boot device: mydisk  File and args: 
SILO Version 1.4.14
boot: 
Linux                    LinuxOLD                 test                     
hea                      
boot: test
Allocated 64 Megs of memory at 0x40000000 for kernel
Uncompressing image...

PROMLIB: Sun IEEE Boot Prom 'OBP 3.2.30 2002/10/25 14:03'
PROMLIB: Root node compatible: 
Linux version 3.17.0-09670-g0429fbc-dirty (mroos@korvits) (gcc version 4.9.1 (Debian 4.9.1-16) ) #46 SMP Fri Oct 17 11:22:20 EEST 2014
debug: ignoring loglevel setting.
bootconsole [earlyprom0] enabled
ARCH: SUN4U
Ethernet address: 08:00:20:b6:ee:e2
MM: PAGE_OFFSET is 0xfffff80000000000 (max_phys_bits == 40)
MM: VMALLOC [0x0000000100000000 --> 0x0000060000000000]
MM: VMEMMAP [0x0000060000000000 --> 0x00000c0000000000]
Kernel: Using 6 locked TLB entries for main kernel image.
Remapping the kernel... done.
kmemleak: Kernel memory leak detector disabled
OF stdout device is: /central@1f,0/fhc@0,f8800000/zs@0,902000:a
PROM: Built device tree with 169763 bytes of memory.
Top of RAM: 0x7fcf2000, Total RAM: 0x7f8c0000
Memory hole size: 4MB
Allocated 2113536 bytes for kernel page tables.
Zone ranges:
  Normal   [mem 0x00000000-0x7fcf1fff]
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x00000000-0x7f7ddfff]
  node   0: [mem 0x7fc00000-0x7fcd1fff]
  node   0: [mem 0x7fce2000-0x7fcf1fff]
Initmem setup node 0 [mem 0x00000000-0x7fcf1fff]
On node 0 totalpages: 261216
  Normal zone: 2301 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 261216 pages, LIFO batch:15
Booting Linux...
CPU CAPS: [flush,stbar,swap,muldiv,v9,mul32,div32,v8plus]
CPU CAPS: [vis]
PERCPU: Embedded 7 pages/cpu @fffff8007f000000 s15808 r8192 d33344 u2097152
pcpu-alloc: s15808 r8192 d33344 u2097152 alloc=1*4194304
pcpu-alloc: [0] 6 7 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 258915
Kernel command line: root=/dev/sda2 ro debug ignore_loglevel
PID hash table entries: 4096 (order: 2, 32768 bytes)
Dentry cache hash table entries: 262144 (order: 8, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 7, 1048576 bytes)
Sorting __ex_table...
Memory: 2037864K/2089728K available (4482K kernel code, 291K rwdata, 1496K rodata, 576K init, 14532K bss, 51864K reserved)
Hierarchical RCU implementation.
	RCU lockdep checking is enabled.
	RCU restricting CPUs from NR_CPUS=16 to nr_cpu_ids=8.
RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
NR_IRQS:2048 nr_irqs:2048 1
clocksource: mult[2800000] shift[24]
clockevent: mult[66666666] shift[32]
Console: colour dummy device 80x25
console [tty0] enabled
bootconsole [earlyprom0] disabled
PROMLIB: Sun IEEE Boot Prom 'OBP 3.2.30 2002/10/25 14:03'
PROMLIB: Root node compatible: 
Linux version 3.17.0-09670-g0429fbc-dirty (mroos@korvits) (gcc version 4.9.1 (Debian 4.9.1-16) ) #46 SMP Fri Oct 17 11:22:20 EEST 2014
debug: ignoring loglevel setting.
bootconsole [earlyprom0] enabled
ARCH: SUN4U
Ethernet address: 08:00:20:b6:ee:e2
MM: PAGE_OFFSET is 0xfffff80000000000 (max_phys_bits == 40)
MM: VMALLOC [0x0000000100000000 --> 0x0000060000000000]
MM: VMEMMAP [0x0000060000000000 --> 0x00000c0000000000]
Kernel: Using 6 locked TLB entries for main kernel image.
Remapping the kernel... done.
kmemleak: Kernel memory leak detector disabled
OF stdout device is: /central@1f,0/fhc@0,f8800000/zs@0,902000:a
PROM: Built device tree with 169763 bytes of memory.
Top of RAM: 0x7fcf2000, Total RAM: 0x7f8c0000
Memory hole size: 4MB
Allocated 2113536 bytes for kernel page tables.
Zone ranges:
  Normal   [mem 0x00000000-0x7fcf1fff]
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x00000000-0x7f7ddfff]
  node   0: [mem 0x7fc00000-0x7fcd1fff]
  node   0: [mem 0x7fce2000-0x7fcf1fff]
Initmem setup node 0 [mem 0x00000000-0x7fcf1fff]
On node 0 totalpages: 261216
  Normal zone: 2301 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 261216 pages, LIFO batch:15
Booting Linux...
CPU CAPS: [flush,stbar,swap,muldiv,v9,mul32,div32,v8plus]
CPU CAPS: [vis]
PERCPU: Embedded 7 pages/cpu @fffff8007f000000 s15808 r8192 d33344 u2097152
pcpu-alloc: s15808 r8192 d33344 u2097152 alloc=1*4194304
pcpu-alloc: [0] 6 7 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 258915
Kernel command line: root=/dev/sda2 ro debug ignore_loglevel
PID hash table entries: 4096 (order: 2, 32768 bytes)
Dentry cache hash table entries: 262144 (order: 8, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 7, 1048576 bytes)
Sorting __ex_table...
Memory: 2037864K/2089728K available (4482K kernel code, 291K rwdata, 1496K rodata, 576K init, 14532K bss, 51864K reserved)
Hierarchical RCU implementation.
	RCU lockdep checking is enabled.
	RCU restricting CPUs from NR_CPUS=16 to nr_cpu_ids=8.
RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
NR_IRQS:2048 nr_irqs:2048 1
clocksource: mult[2800000] shift[24]
clockevent: mult[66666666] shift[32]
Console: colour dummy device 80x25
console [tty0] enabled
bootconsole [earlyprom0] disabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     32768
... MAX_LOCKDEP_CHAINS:      65536
... CHAINHASH_SIZE:          32768
 memory used by lock dependency info: 8159 kB
 per task-struct memory footprint: 1920 bytes
------------------------
| Locking API testsuite:
----------------------------------------------------------------------------
                                 | spin |wlock |rlock |mutex | wsem | rsem |
  --------------------------------------------------------------------------
                     A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
             A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
             A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                    double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                  initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
  --------------------------------------------------------------------------
              recursive read-lock:             |  ok  |             |  ok  |
           recursive read-lock #2:             |  ok  |             |  ok  |
            mixed read-write-lock:             |  ok  |             |  ok  |
            mixed write-read-lock:             |  ok  |             |  ok  |
  --------------------------------------------------------------------------
     hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
       sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
       sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
      hard-irq read-recursion/123:  ok  |
      soft-irq read-recursion/123:  ok  |
      hard-irq read-recursion/132:  ok  |
      soft-irq read-recursion/132:  ok  |
      hard-irq read-recursion/213:  ok  |
      soft-irq read-recursion/213:  ok  |
      hard-irq read-recursion/231:  ok  |
      soft-irq read-recursion/231:  ok  |
      hard-irq read-recursion/312:  ok  |
      soft-irq read-recursion/312:  ok  |
      hard-irq read-recursion/321:  ok  |
      soft-irq read-recursion/321:  ok  |
  --------------------------------------------------------------------------
  | Wound/wait tests |
  ---------------------
                  ww api failures:  ok  |  ok  |  ok  |
               ww contexts mixing:  ok  |  ok  |
             finishing ww context:  ok  |  ok  |  ok  |  ok  |
               locking mismatches:  ok  |  ok  |  ok  |
                 EDEADLK handling:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
           spinlock nest unlocked:  ok  |
  -----------------------------------------------------
                                 |block | try  |context|
  -----------------------------------------------------
                          context:  ok  |  ok  |  ok  |
                              try:  ok  |  ok  |  ok  |
                            block:  ok  |  ok  |  ok  |
                         spinlock:  ok  |  ok  |  ok  |
-------------------------------------------------------
Good, all 253 testcases passed! |
---------------------------------
ODEBUG: selftest passed
kmemleak: Early log buffer exceeded (3329), please increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE
Calibrating delay using timer specific routine.. 804.11 BogoMIPS (lpj=4020575)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 4096 (order: 2, 32768 bytes)
Mountpoint-cache hash table entries: 4096 (order: 2, 32768 bytes)
CPU 7: synchronized TICK with master CPU (last diff -7 cycles, maxerr 671 cycles)
Brought up 2 CPUs
devtmpfs: initialized
Performance events: No support for PMU type 'ultra12'
atomic64_test: passed
kworker/u4:0 (20) used greatest stack depth: 10008 bytes left
device-tree: Duplicate name in base, renamed to "fhc#1"
device-tree: Duplicate name in base, renamed to "counter-timer#1"
device-tree: Duplicate name in base, renamed to "fhc#2"
device-tree: Duplicate name in base, renamed to "counter-timer#2"
device-tree: Duplicate name in base, renamed to "counter-timer#3"
device-tree: Duplicate name in base, renamed to "fhc#3"
device-tree: Duplicate name in base, renamed to "counter-timer#4"
device-tree: Duplicate name in base, renamed to "counter-timer#5"
NET: Registered protocol family 16
kworker/u4:0 (38) used greatest stack depth: 9688 bytes left
kworker/u4:0 (58) used greatest stack depth: 9592 bytes left
SYSIO: UPA portID ffffffff, at 000001c400000000
SYSIO: UPA portID ffffffff, at 000001c600000000
SYSIO: UPA portID ffffffff, at 000001d400000000
SYSIO: UPA portID ffffffff, at 000001d600000000
/pci@e,4000: PCI IO[1dc02010000] MEM[1dd80000000]
/pci@e,4000: PSYCHO PCI Bus Module ver[4:0]
PCI: Scanning PBM /pci@e,4000
psycho f01bf7bc: PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [io  0x1dc02010000-0x1dc0201ffff] (bus address [0x0000-0xffff])
pci_bus 0000:00: root bus resource [mem 0x1dd80000000-0x1ddffffffff] (bus address [0x00000000-0x7fffffff])
pci_bus 0000:00: root bus resource [bus 00]
/pci@e,2000: PCI IO[1dc02000000] MEM[1dd00000000]
/pci@e,2000: PSYCHO PCI Bus Module ver[4:0]
PCI: Scanning PBM /pci@e,2000
psycho f01c88e0: PCI host bridge to bus 0001:80
pci_bus 0001:80: root bus resource [io  0x1dc02000000-0x1dc0200ffff] (bus address [0x0000-0xffff])
pci_bus 0001:80: root bus resource [mem 0x1dd00000000-0x1dd7fffffff] (bus address [0x00000000-0x7fffffff])
pci_bus 0001:80: root bus resource [bus 80]
/pci@f,4000: PCI IO[1de02010000] MEM[1df80000000]
/pci@f,4000: PSYCHO PCI Bus Module ver[4:0]
PCI: Scanning PBM /pci@f,4000
psycho f01ca118: PCI host bridge to bus 0002:00
pci_bus 0002:00: root bus resource [io  0x1de02010000-0x1de0201ffff] (bus address [0x0000-0xffff])
pci_bus 0002:00: root bus resource [mem 0x1df80000000-0x1dfffffffff] (bus address [0x00000000-0x7fffffff])
pci_bus 0002:00: root bus resource [bus 00]
/pci@f,2000: PCI IO[1de02000000] MEM[1df00000000]
/pci@f,2000: PSYCHO PCI Bus Module ver[4:0]
PCI: Scanning PBM /pci@f,2000
psycho f01d320c: PCI host bridge to bus 0003:80
pci_bus 0003:80: root bus resource [io  0x1de02000000-0x1de0200ffff] (bus address [0x0000-0xffff])
pci_bus 0003:80: root bus resource [mem 0x1df00000000-0x1df7fffffff] (bus address [0x00000000-0x7fffffff])
pci_bus 0003:80: root bus resource [bus 80]
vgaarb: loaded
SCSI subsystem initialized
/central/fhc@0,f8800000/eeprom@0,908000: Mostek regs at 0x1fff8908000
fhc: Board #1, Version[1] PartID[fa0] Manuf[3e] (Central)
fhc: Board #3, Version[1] PartID[fa0] Manuf[3e] (JTAG Master)
fhc: Board #1, Version[1] PartID[fa0] Manuf[3e] 
fhc: Board #5, Version[1] PartID[fa0] Manuf[3e] 
fhc: Board #7, Version[1] PartID[fa0] Manuf[3e] 
clock_board: Detected 5 slot Enterprise system.
DMA-API: preallocated 32768 debug entries
DMA-API: debugging enabled by kernel config
Switched to clocksource tick
NET: Registered protocol family 2
TCP established hash table entries: 16384 (order: 4, 131072 bytes)
TCP bind hash table entries: 16384 (order: 7, 1048576 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP: reno registered
UDP hash table entries: 1024 (order: 4, 163840 bytes)
UDP-Lite hash table entries: 1024 (order: 4, 163840 bytes)
NET: Registered protocol family 1
PCI: CLS 0 bytes, default 64
futex hash table entries: 512 (order: 3, 65536 bytes)
====[ backtrace testing ]===========
Testing a backtrace from process context.
The following trace is a kernel self test and not a bug!
CPU: 6 PID: 1 Comm: swapper/6 Not tainted 3.17.0-09670-g0429fbc-dirty #46
Call Trace:
 [00000000004cd46c] backtrace_regression_test+0x2c/0x100
 [0000000000426ea4] do_one_initcall+0xe4/0x1e0
 [0000000000a2eb34] kernel_init_freeable+0x120/0x1d0
 [0000000000859144] kernel_init+0x4/0x100
 [0000000000406104] ret_from_fork+0x1c/0x2c
 [0000000000000000]           (null)
Testing a backtrace from irq context.
The following trace is a kernel self test and not a bug!
CPU: 6 PID: 3 Comm: ksoftirqd/6 Not tainted 3.17.0-09670-g0429fbc-dirty #46
Call Trace:
 [00000000004cd424] backtrace_test_irq_callback+0x4/0x20
 [000000000045f018] tasklet_action+0x98/0x120
 [000000000045f190] __do_softirq+0xf0/0x240
 [000000000045f308] run_ksoftirqd+0x28/0x80
 [000000000047e164] smpboot_thread_fn+0x244/0x280
 [0000000000479c70] kthread+0xb0/0xe0
 [0000000000406104] ret_from_fork+0x1c/0x2c
 [0000000000000000]           (null)
Testing a saved backtrace.
The following trace is a kernel self test and not a bug!
 [<00000000004cd508>] backtrace_regression_test+0xc8/0x100
 [<0000000000426ea4>] do_one_initcall+0xe4/0x1e0
 [<0000000000a2eb34>] kernel_init_freeable+0x120/0x1d0
 [<0000000000859144>] kernel_init+0x4/0x100
 [<0000000000406104>] ret_from_fork+0x1c/0x2c
 [<          (null)>]           (null)
====[ end of backtrace testing ]====
HugeTLB registered 8 MB page size, pre-allocated 0 pages
msgmni has been set to 3980
io scheduler noop registered
io scheduler cfq registered (default)
start plist test
end plist test
test_string_helpers: Running tests...
zs f005de3c: ttyS0 at MMIO 0x1fff8902000 (irq = 2, base_baud = 307200) is a zs (ESCC)
Console: ttyS0 (SunZilog zs0)
console [ttyS0] enabled
zs f005de3c: ttyS1 at MMIO 0x1fff8902004 (irq = 2, base_baud = 307200) is a zs (ESCC)
f005df14: Keyboard at MMIO 0x1fff8904000 (irq = 2) is a zs
f005df14: Mouse at MMIO 0x1fff8904004 (irq = 2) is a zs
loop: module loaded
PCI: Enabling device: (0003:80:02.0), cmd 3
scsi0: Missing case in ahd_handle_scsiint. status = 0
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x0 Mode 0x33
Card was paused
INTSTAT[0x8]:(SCSIINT) SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0] 
INTCTL[0x0] SEQINTSTAT[0x0] SAVED_MODE[0x25] DFFSTAT[0x33]:(CURRFIFO_NONE|FIFO0FREE|FIFO1FREE) 
SCSISIGI[0x0]:(P_DATAOUT) SCSIPHASE[0x0] SCSIBUS[0x0] 
LASTPHASE[0x1]:(P_DATAOUT|P_BUSFREE) SCSISEQ0[0x0] 
SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI) SEQCTL0[0x0] SEQINTCTL[0x0] 
SEQ_FLAGS[0x0] SEQ_FLAGS2[0x0] QFREEZE_COUNT[0x0] 
KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00] MK_MESSAGE_SCSIID[0xff] 
SSTAT0[0x0] SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x0] 
SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO) LQISTAT0[0x0] 
LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] LQOSTAT1[0x0] 
LQOSTAT2[0x0] 

SCB Count = 8 CMDS_PENDING = 0 LASTSCB 0xffff CURRSCB 0x0 NEXTSCB 0x0
qinstart = 0 qinfifonext = 0
QINFIFO:
WAITING_TID_QUEUES:
Pending list:
Total 0
Kernel Free SCB list: 7 6 5 4 3 2 1 0 
Sequencer Complete DMA-inprog list: 
Sequencer Complete list: 
Sequencer DMA-Up and Complete list: 
Sequencer On QFreeze and Complete list: 


scsi0: FIFO0 Free, LONGJMP == 0x803b, SCB 0x0
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 
SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]:(SG_CACHE_AVAIL) 

scsi0: FIFO1 Free, LONGJMP == 0x80bc, SCB 0x0
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS) 
SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]:(SG_CACHE_AVAIL) 
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0

SIMODE0[0x6c]:(ENOVERRUN|ENIOERR|ENSELDI|ENSELDO) 
CCSCBCTL[0x0] 
scsi0: REG0 == 0x45d1, SINDEX = 0x0, DINDEX = 0x0
scsi0: SCBPTR == 0x1ff, SCB_NEXT == 0xff00, SCB_NEXT2 == 0x0
CDB ff 1 0 0 0 0
STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi host0: Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
        <Adaptec 29320ALP PCIx Ultra320 SCSI adapter>
        aic7901: Ultra320 Wide Channel A, SCSI Id=7, PCI 33 or 66MHz, 512 SCBs
qla1280: QLA1040 found on PCI bus 0, dev 3
PCI: Enabling device: (0002:00:03.0), cmd 7

===============================
[ INFO: suspicious RCU usage. ]
3.17.0-09670-g0429fbc-dirty #46 Not tainted
-------------------------------
include/linux/rcupdate.h:868 rcu_read_lock() used illegally while idle!

other info that might help us debug this:


RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 0
RCU used illegally from extended quiescent state!
3 locks held by swapper/7/0:
 #0:  (&x->wait#11){......}, at: [<0000000000495ae8>] complete+0x8/0x60
 #1:  (&p->pi_lock){-.-.-.}, at: [<0000000000484e8c>] try_to_wake_up+0xc/0x400
 #2:  (rcu_read_lock){......}, at: [<000000000048a690>] select_task_rq_fair+0x90/0xb40

stack backtrace:
CPU: 7 PID: 0 Comm: swapper/7 Not tainted 3.17.0-09670-g0429fbc-dirty #46
Call Trace:
 [0000000000499060] lockdep_rcu_suspicious+0xe0/0x100
 [000000000048a71c] select_task_rq_fair+0x11c/0xb40
 [0000000000485058] try_to_wake_up+0x1d8/0x400
 [00000000004852cc] default_wake_function+0xc/0x20
 [0000000000495254] __wake_up_common+0x34/0x80
 [00000000004952b4] __wake_up_locked+0x14/0x40
 [0000000000495b08] complete+0x28/0x60
 [000000000062bd48] blk_end_sync_rq+0x8/0x20
 [000000000062e7f8] __blk_mq_end_io+0x18/0x60
 [00000000006e1774] scsi_end_request+0x94/0x180
 [00000000006e1a94] scsi_io_completion+0x1d4/0x600
 [00000000006d8984] scsi_finish_command+0xc4/0xe0
 [00000000006e10b8] scsi_softirq_done+0x118/0x140
 [000000000062e84c] __blk_mq_complete_request_remote+0xc/0x20
 [00000000004c7250] generic_smp_call_function_single_interrupt+0x150/0x1c0
 [000000000043e514] smp_call_function_single_client+0x14/0x40
random: nonblocking pool is initialized
scsi(1:0): Resetting SCSI BUS
scsi host1: QLogic QLA1040 PCI to SCSI Host Adapter
       Firmware version:  7.65.06, Driver version 3.27.1
blk-mq: reduced tag depth to 10240
qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.07.00.16-k.
PCI: Enabling device: (0001:80:02.0), cmd 3
qla2xxx [0001:80:02.0]-001d: : Found an ISP2200 irq 49 iobase 0x000001dd00002000.
qla2xxx 0001:80:02.0: Direct firmware load for ql2200_fw.bin failed with error -2
qla2xxx [0001:80:02.0]-0063:2: Failed to load firmware image (ql2200_fw.bin).
qla2xxx [0001:80:02.0]-0083:2: Fimware image unavailable.
qla2xxx [0001:80:02.0]-0084:2: Firmware images can be retrieved from: http://ldriver.qlogic.com/firmware/.
scsi 1:0:2:0: Direct-Access     IBM      DDYS-T18350M     S96H PQ: 0 ANSI: 3
qla2xxx [0001:80:02.0]-00cf:2: Setup chip ****FAILED****.
qla2xxx [0001:80:02.0]-00d6:2: Failed to initialize adapter - Adapter flags 2.
scsi(1:0:2:0): Sync: period 10, offset 12, Wide, Tagged queuing: depth 31
sunhme.c:v3.10 August 26, 2008 David S. Miller (davem@davemloft.net)
eth0: HAPPY MEAL (SBUS) 10/100baseT Ethernet 08:00:20:b6:ee:e2
eth1: Quattro HME slot 0 (SBUS) 10/100baseT Ethernet 08:00:20:93:79:94
eth2: Quattro HME slot 1 (SBUS) 10/100baseT Ethernet 08:00:20:93:79:95
scsi 1:0:4:0: Direct-Access     IBM      DDYS-T18350M     S80D PQ: 0 ANSI: 3
eth3: Quattro HME slot 2 (SBUS) 10/100baseT Ethernet 08:00:20:93:79:96
scsi(1:0:4:0): Sync: period 10, offset 12, Wideeth4: Quattro HME slot 3 (SBUS) 10/100baseT Ethernet 08:00:20:93:79:97
eth5: HAPPY MEAL (SBUS) 10/100baseT Ethernet 08:00:20:b6:ee:e2
PCI: Enabling device: (0000:00:01.1), cmd 2
eth6: HAPPY MEAL (PCI/CheerIO) 10/100BaseT Ethernet 08:00:20:b6:ee:e2
mousedev: PS/2 mouse device common for all mice

, Tagged queuing: depth 31rtc-m48t59 rtc-m48t59.0: rtc core: registered m48t59 as rtc0
TCP: cubic registered
NET: Registered protocol family 17
registered taskstats version 1

rtc-m48t59 rtc-m48t59.0: setting system clock to 2014-10-17 09:29:00 UTC (1413538140)
kworker/u4:0 (446) used greatest stack depth: 9288 bytes left
scsi 1:0:10:0: Direct-Access     HP       9.10GB A 80-6331      PQ: 0 ANSI: 2
scsi(1:0:10:0): Sync: period 10, offset 12, Wide, Tagged queuing: depth 31
scsi 1:0:11:0: Direct-Access     IBM      DDRS-34560D      DC1B PQ: 0 ANSI: 2
scsi(1:0:11:0): Sync: period 10, offset 12, Wide, Tagged queuing: depth 31
scsi 1:0:12:0: Direct-Access     HP       4.26GB A 80-0430 0430 PQ: 0 ANSI: 2
scsi(1:0:12:0): Sync: period 10, offset 12, Wide, Tagged queuing: depth 31
scsi 1:0:13:0: Direct-Access     HP       2.13GB A 80-0430 0430 PQ: 0 ANSI: 2
scsi(1:0:13:0): Sync: period 10, offset 12, Wide, Tagged queuing: depth 31
kworker/u4:4 (477) used greatest stack depth: 8824 bytes left
sd 1:0:2:0: [sda] 35843670 512-byte logical blocks: (18.3 GB/17.0 GiB)
sd 1:0:4:0: [sdb] 35843670 512-byte logical blocks: (18.3 GB/17.0 GiB)
sd 1:0:2:0: [sda] Write Protect is off
sd 1:0:2:0: [sda] Mode Sense: cb 00 00 08
sd 1:0:4:0: [sdb] Write Protect is off
sd 1:0:4:0: [sdb] Mode Sense: cb 00 00 08
sd 1:0:13:0: [sdf] 4165272 512-byte logical blocks: (2.13 GB/1.98 GiB)
sd 1:0:11:0: [sdd] 8925000 512-byte logical blocks: (4.56 GB/4.25 GiB)
sd 1:0:13:0: [sdf] Write Protect is off
sd 1:0:13:0: [sdf] Mode Sense: 9f 00 10 08
sd 1:0:11:0: [sdd] Write Protect is off
sd 1:0:11:0: [sdd] Mode Sense: b9 00 00 08
sd 1:0:13:0: [sdf] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 1:0:11:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:10:0: [sdc] 17773524 512-byte logical blocks: (9.10 GB/8.47 GiB)
sd 1:0:2:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:4:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:12:0: [sde] 8330543 512-byte logical blocks: (4.26 GB/3.97 GiB)
sd 1:0:10:0: [sdc] Write Protect is off
 sdd: unknown partition table
sd 1:0:10:0: [sdc] Mode Sense: 9f 00 10 08
sd 1:0:12:0: [sde] Write Protect is off
sd 1:0:12:0: [sde] Mode Sense: 9f 00 10 08
sd 1:0:10:0: [sdc] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdf: unknown partition table
sd 1:0:12:0: [sde] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdb: unknown partition table
sd 1:0:11:0: [sdd] Attached SCSI disk
 sda: sda1 sda2 sda3 sda4
sd 1:0:13:0: [sdf] Attached SCSI disk
 sdc: unknown partition table
sd 1:0:4:0: [sdb] Attached SCSI disk
sd 1:0:2:0: [sda] Attached SCSI disk
sd 1:0:10:0: [sdc] Attached SCSI disk
 sde: unknown partition table
sd 1:0:12:0: [sde] Attached SCSI disk
EXT4-fs (sda2): mounting ext3 file system using the ext4 subsystem
EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
VFS: Mounted root (ext3 filesystem) readonly on device 8:2.
devtmpfs: mounted
Mount failed for selinuxfs on /sys/fs/selinux:  No such file or directory
INIT: version 2.88 booting
stty (518) used greatest stack depth: 7464 bytes left
[info] Using makefile-style concurrent boot in runlevel S.
ls (555) used greatest stack depth: 7128 bytes left
kernel BUG at kernel/sched/core.c:2702!
              \|/ ____ \|/
              "@'/ .. \`@"
              /_| \__/ |_\
                 \__U_/
startpar(528): Kernel bad sw trap 5 [#1]
CPU: 7 PID: 528 Comm: startpar Not tainted 3.17.0-09670-g0429fbc-dirty #46
task: fffff8007dc840e0 ti: fffff800796d8000 task.ti: fffff800796d8000
TSTATE: 0000004411001607 TPC: 000000000085ec34 TNPC: 000000000085ec38 Y: 00000000    Not tainted
TPC: <__schedule+0x74/0x808>
g0: fffff80079571188 g1: 0000000000000000 g2: 00000000009fba90 g3: fffff8007e82df4e
g4: fffff8007dc840e0 g5: fffff8007e746000 g6: fffff800796d8000 g7: fffff8007e82df00
o0: 0000000000961250 o1: 0000000000000a8e o2: 0000000000000000 o3: 0000000000000002
o4: 000000000177f400 o5: 0000000000abae50 sp: fffff800796db211 ret_pc: 000000000085ec2c
RPC: <__schedule+0x6c/0x808>
l0: 0000000000000000 l1: 0000000000a0a400 l2: fffff800795711c0 l3: fffff800796d7ae0
l4: fffff80000001ae0 l5: 0000000000000000 l6: 0000000000001268 l7: 0000000000000010
i0: 0000000000000000 i1: 0000000000000001 i2: 000000000045e620 i3: fffff8007dc840e0
i4: 0000000000000007 i5: fffff8007f203140 i6: fffff800796db371 i7: 000000000085f5c0
I7: <schedule+0x60/0x80>
Call Trace:
 [000000000085f5c0] schedule+0x60/0x80
 [000000000045e65c] do_wait+0x19c/0x200
 [000000000045ea74] SyS_wait4+0x94/0xc0
 [000000000045eab0] SyS_waitpid+0x10/0x20
 [00000000004061f4] linux_sparc_syscall32+0x34/0x60
Caller[000000000085f5c0]: schedule+0x60/0x80
Caller[000000000045e65c]: do_wait+0x19c/0x200
Caller[000000000045ea74]: SyS_wait4+0x94/0xc0
Caller[000000000045eab0]: SyS_waitpid+0x10/0x20
Caller[00000000004061f4]: linux_sparc_syscall32+0x34/0x60
Caller[0000000000014ef4]: 0x14ef4
Instruction DUMP: 92102a8e  7fef241d  90122250 <91d02005> 05000800  82284002  80a06001  02680008  01000000 
note: startpar[528] exited with preempt_count 1
startpar (528) used greatest stack depth: 8 bytes left
kernel BUG at kernel/sched/core.c:2702!
              \|/ ____ \|/
              "@'/ .. \`@"
              /_| \__/ |_\
                 \__U_/
startpar(528): Kernel bad sw trap 5 [#2]
CPU: 7 PID: 528 Comm: startpar Tainted: G      D        3.17.0-09670-g0429fbc-dirty #46
task: fffff8007dc840e0 ti: fffff800796d8000 task.ti: fffff800796d8000
TSTATE: 0000004411001605 TPC: 000000000085ec34 TNPC: 000000000085ec38 Y: 00000000    Tainted: G      D       
TPC: <__schedule+0x74/0x808>
g0: 000000000175e840 g1: 0000000000000000 g2: 00000000009fba90 g3: fffff8007e82df4e
g4: fffff8007dc840e0 g5: fffff8007e746000 g6: fffff800796d8000 g7: fffff8007e82df00
o0: 0000000000961250 o1: 0000000000000a8e o2: 000000000177f400 o3: 0000000000000000
o4: 0000000000000002 o5: ffffffffffffffe1 sp: fffff800796dabc1 ret_pc: 000000000085ec2c
RPC: <__schedule+0x6c/0x808>
l0: 0000000000000036 l1: 00000000009fb800 l2: 0000000000000000 l3: 0000000000000000
l4: 00000000009fb800 l5: 0000000000000000 l6: 000000000175ec62 l7: 0000000000000004
i0: 0000000000000000 i1: 0000000000000001 i2: 000000000045d2b4 i3: fffff8007dc840e0
i4: 0000000000000007 i5: fffff8007f203140 i6: fffff800796dad21 i7: 000000000085f5c0
I7: <schedule+0x60/0x80>
Call Trace:
 [000000000085f5c0] schedule+0x60/0x80
 [000000000045d318] do_exit+0x938/0xa80
 [0000000000428be8] die_if_kernel+0x288/0x2e0
 [0000000000428dd0] bad_trap+0x70/0x100
 [00000000004220b0] tl0_resv104+0x30/0xa0
 [000000000085ec34] __schedule+0x74/0x808
 [000000000085f5c0] schedule+0x60/0x80
 [000000000045e65c] do_wait+0x19c/0x200
 [000000000045ea74] SyS_wait4+0x94/0xc0
 [000000000045eab0] SyS_waitpid+0x10/0x20
 [00000000004061f4] linux_sparc_syscall32+0x34/0x60
Caller[000000000085f5c0]: schedule+0x60/0x80
Caller[000000000045d318]: do_exit+0x938/0xa80
Caller[0000000000428be8]: die_if_kernel+0x288/0x2e0
Caller[0000000000428dd0]: bad_trap+0x70/0x100
Caller[00000000004220b0]: tl0_resv104+0x30/0xa0
Caller[000000000085ec2c]: __schedule+0x6c/0x808
Caller[000000000085f5c0]: schedule+0x60/0x80
Caller[000000000045e65c]: do_wait+0x19c/0x200
Caller[000000000045ea74]: SyS_wait4+0x94/0xc0
Caller[000000000045eab0]: SyS_waitpid+0x10/0x20
Caller[00000000004061f4]: linux_sparc_syscall32+0x34/0x60
Caller[0000000000014ef4]: 0x14ef4
Instruction DUMP: 92102a8e  7fef241d  90122250 <91d02005> 05000800  82284002  80a06001  02680008  01000000 

-- 
Meelis Roos (mroos@linux.ee)
