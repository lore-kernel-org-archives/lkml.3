Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbaGNQ5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:57:17 -0400
Received: from mail-yk0-f174.google.com ([209.85.160.174]:37563 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278AbaGNQ5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:57:04 -0400
Date: Mon, 14 Jul 2014 11:56:59 -0500
From: Greg Donald <gdonald@gmail.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: find_busiest_group divide error
Message-ID: <20140714165659.GA9289@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
X-PGP-Key: http://pgp.mit.edu/pks/lookup?search=0x42C14D83&op=vindex
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


[1.] One line summary of the problem:

find_busiest_group divide error

[2.] Full description of the problem/report:

Around June 7th I found I could no longer boot a mainline kernel.  I
posted about it here on June 9th:

http://lists.kernelnewbies.org/pipermail/kernelnewbies/2014-June/010914.html

I bisected two complete times but never got to a commit that made any
sense:

https://bugzilla.kernel.org/show_bug.cgi?id=3D77711

I see a lot of kernel/sched/fair.c patching appeared in mainline on June
5th:

https://github.com/torvalds/linux/commits/master/kernel/sched/fair.c

So I tried checking out specific revisions and found
09dc4ab03936df5c5aa711d27c81283c6d09f495 is the latest good revision I
can boot.  The first bad revision I hit is
51f2176d74ace4c3f58579a605ef5a9720befb00.

I have no idea how to fix it.  I'm just a web developer/kernel tester :(

The issue affects both of my identical 32-bit file servers while all my
64-bit systems have no issues.

I'd be happy to test any patches anyone has to offer.

[3.] Keywords (i.e., modules, networking, kernel):

scheduler, find_busiest_group

[4.] Kernel information
[4.1.] Kernel version (from /proc/version):

Linux version 3.15.0-rc2-4+ (root@mars) (gcc version 4.7.2 (Debian
4.7.2-5) ) #1 SMP Thu Jul 10 17:24:56 CDT 2014

[4.2.] Kernel .config file:

Attached.

[5.] Most recent kernel version which did not have the bug:

09dc4ab03936df5c5aa711d27c81283c6d09f495

[6.] Output of Oops.. message (if applicable) with symbolic information
     resolved (see Documentation/oops-tracing.txt)

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.15.0-1+ (root at mars) (gcc version 4.7.2
(Debian 4.7.2-5) ) #1 SMP Mon Jun 9 11:43:45 CDT 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009dfff]
usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff]
reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000003fffb9ff]
usable
[    0.000000] BIOS-e820: [mem 0x000000003fffba00-0x000000003fffffff]
ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000ffffffff]
reserved
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
[    0.000000] SMBIOS 2.3 present.
[    0.000000] e820: last_pfn =3D 0x3fffb max_arch_pfn =3D 0x100000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new
0x7010600070106
[    0.000000] found SMP MP-table at [mem 0x0009e140-0x0009e14f]
mapped at [c009e140]
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000] init_memory_mapping: [mem 0x37000000-0x373fffff]
[    0.000000] init_memory_mapping: [mem 0x30000000-0x36ffffff]
[    0.000000] init_memory_mapping: [mem 0x00100000-0x2fffffff]
[    0.000000] init_memory_mapping: [mem 0x37400000-0x377fdfff]
[    0.000000] RAMDISK: [mem 0x37844000-0x37c19fff]
[    0.000000] Allocated new RAMDISK: [mem 0x37428000-0x377fd57f]
[    0.000000] Move RAMDISK from [mem 0x37844000-0x37c1957f] to [mem
0x37428000-0x377fd57f]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000FDFC0 000014 (v00 IBM   )
[    0.000000] ACPI: RSDT 0x3FFFFF80 000030 (v01 IBM    SERONYXP
00001000 IBM  45444F43)
[    0.000000] ACPI: FACP 0x3FFFFF00 000074 (v01 IBM    SERONYXP
00001000 IBM  45444F43)
[    0.000000] ACPI: DSDT 0x3FFFBA00 0042FA (v01 IBM    SERTURQU
00001000 MSFT 0100000B)
[    0.000000] ACPI: FACS 0x3FFFFE00 000040
[    0.000000] ACPI: APIC 0x3FFFFE40 000092 (v01 IBM    SERONYXP
00001000 IBM  45444F43)
[    0.000000] ACPI: ASF! 0x3FFFFD80 00004B (v16 IBM    SERONYXP
00000001 IBM  45444F43)
[    0.000000] 135MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x377fdfff]
[    0.000000]   HighMem  [mem 0x377fe000-0x3fffafff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x3fffafff]
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x488
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 14, version 17, address 0xfec00000,
GSI 0-15
[    0.000000] ACPI: IOAPIC (id[0x0d] address[0xfec01000] gsi_base[16])
[    0.000000] IOAPIC[1]: apic_id 13, version 17, address 0xfec01000,
GSI 16-31
[    0.000000] ACPI: IOAPIC (id[0x0c] address[0xfec02000] gsi_base[32])
[    0.000000] IOAPIC[2]: apic_id 12, version 17, address 0xfec02000,
GSI 32-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] e820: [mem 0x40000000-0xfebfffff] available for PCI
devices
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4
nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @f6bf1000 s27520 r0 d21632
u49152
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 260264
[    0.000000] Kernel command line: BOOT_IMAGE=3D/vmlinuz-3.15.0-1+
root=3D/dev/mapper/g-root ro console=3DttyS0,115200n8 console=3Dtty0
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288
bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144
bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:0003fffb)
[    0.000000] Initializing Movable for node 0 (00000000:00000000)
[    0.000000] Memory: 1030380K/1048160K available (2660K kernel code,
229K rwdata, 880K rodata, 392K init, 340K bss, 17780K reserved,
139252K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff67000 - 0xfffff000   ( 608 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc13b2000 - 0xc1414000   ( 392 kB)
[    0.000000]       .data : 0xc1299387 - 0xc13b0600   (1116 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1299387   (2660 kB)
[    0.000000] Checking if this processor honours the WP bit even in
supervisor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D4,
Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304 nr_irqs:1024 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1993.504 MHz processor
[    0.012005] Calibrating delay loop (skipped), value calculated
using timer frequency.. 3987.00 BogoMIPS (lpj=3D7974016)
[    0.020007] pid_max: default: 32768 minimum: 301
[    0.024019] ACPI: Core revision 20140424
[    0.034484] ACPI: All ACPI Tables successfully acquired
[    0.041027] Security Framework initialized
[    0.044029] Mount-cache hash table entries: 2048 (order: 1, 8192
bytes)
[    0.048008] Mountpoint-cache hash table entries: 2048 (order: 1, 8192
bytes)
[    0.052395] Initializing cgroup subsys devices
[    0.060007] Initializing cgroup subsys freezer
[    0.064007] Initializing cgroup subsys net_cls
[    0.068049] CPU: Physical Processor ID: 0
[    0.072005] CPU: Processor Core ID: 0
[    0.076006] mce: CPU supports 4 MCE banks
[    0.080016] CPU0: Thermal monitoring enabled (TM1)
[    0.084023] Last level iTLB entries: 4KB 64, 2MB 64, 4MB 64
[    0.084023] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 64, 1GB 0
[    0.084023] tlb_flushall_shift: 6
[    0.088172] Freeing SMP alternatives memory: 16K (c1414000 -
c1418000)
[    0.092142] Enabling APIC mode:  Flat.  Using 3 I/O APICs
[    0.100585] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.146513] smpboot: CPU0: Intel(R) Xeon(TM) CPU 2.00GHz (fam: 0f,
model: 02, stepping: 07)
[    0.156000] Performance Events: Netburst events, Netburst P4/Xeon PMU
driver.
[    0.158862] ... version:                0
[    0.160004] ... bit width:              40
[    0.164004] ... generic registers:      18
[    0.168004] ... value mask:             000000ffffffffff
[    0.172004] ... max period:             0000007fffffffff
[    0.176004] ... fixed-purpose events:   0
[    0.180004] ... event mask:             000000000003ffff
[    0.184602] x86: Booting SMP configuration:
[    0.188007] .... node  #0, CPUs:      #1
[    0.016000] Initializing CPU#1
[    0.288215]  #2
[    0.016000] Initializing CPU#2
[    0.382274]  #3
[    0.016000] Initializing CPU#3
[    0.478166] x86: Booted up 1 node, 4 CPUs
[    0.480006] smpboot: Total of 4 processors activated (15949.07
BogoMIPS)
[    0.485095] divide error: 0000 [#1] SMP
[    0.488000] Modules linked in:
[    0.488000] CPU: 2 PID: 6 Comm: kworker/u8:0 Not tainted 3.15.0-1+ #1
[    0.488000] Hardware name: IBM eserver xSeries 335 -[867642X]-/,
BIOS -[T2E114AUS-1.03]- 11/14/2002
[    0.488000] task: f6469860 ti: f6484000 task.ti: f6484000
[    0.488000] EIP: 0060:[<c10500b3>] EFLAGS: 00010046 CPU: 2
[    0.488000] EIP is at find_busiest_group+0x18a/0x583
[    0.488000] EAX: 00000000 EBX: f6485db0 ECX: 00000000 EDX: 00000000
[    0.488000] ESI: 00000004 EDI: 00000000 EBP: f6485de8 ESP: f6485d14
[    0.488000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.488000] CR0: 8005003b CR2: 00000068 CR3: 0141b000 CR4: 000007d0
[    0.488000] Stack:
[    0.488000]  00000000 00000001 00000002 000006f2 00000000 c1413280
ffffffff 00000000
[    0.488000]  f6c0f280 00000000 f6485e34 f6403460 000006f2 000003ff
000003ff 000001ff
[    0.488000]  0000024d 00000002 00000001 00000000 00000001 00000000
00000000 00000000
[    0.488000] Call Trace:
[    0.488000]  [<c105059b>] load_balance+0xef/0x5cb
[    0.488000]  [<c104b509>] ? sched_clock_local+0x11/0x139
[    0.488000]  [<c1050ffe>] pick_next_task_fair+0x28e/0x398
[    0.488000]  [<c1046ee9>] ? dequeue_task+0x8a/0x92
[    0.488000]  [<c1291b51>] __schedule+0x1f5/0x673
[    0.488000]  [<c1291e96>] ? __schedule+0x53a/0x673
[    0.488000]  [<c104967d>] ? default_wake_function+0xb/0xd
[    0.488000]  [<c10549db>] ? __wake_up_common+0x34/0x5a
[    0.488000]  [<c1292071>] schedule+0x56/0x58
[    0.488000]  [<c103dbbc>] worker_thread+0x244/0x27d
[    0.488000]  [<c103d978>] ? manage_workers.isra.28+0x189/0x189
[    0.488000]  [<c1041668>] kthread+0x9f/0xa4
[    0.488000]  [<c1298241>] ret_from_kernel_thread+0x21/0x30
[    0.488000]  [<c10415c9>] ? kthread_freezable_should_stop+0x40/0x40
[    0.488000] Code: 72 0e 00 3b 05 a0 d9 3a c1 89 c6 0f 8c 7b ff ff
ff 8b 95 58 ff ff ff 8b 7b 14 8b 42 0c 31 d2 8b 48 04 8b 43 04 89 4b
10 c1 e0 0a <f7> f1 85 ff 89 85 38 ff ff ff 89 03 7
[    0.488000] EIP: [<c10500b3>] find_busiest_group+0x18a/0x583 SS:ESP
0068:f6485d14
[    0.488000] divide error: 0000 [#2] [    0.488000] ---[ end trace
242397e5073f2949 ]---

[    0.488000] SMP
[    0.488000] Modules linked in:
[    0.488000] CPU: 0 PID: 2 Comm: kthreadd Tainted: G      D
3.15.0-1+ #1
[    0.488000] Hardware name: IBM eserver xSeries 335 -[867642X]-/,
BIOS -[T2E114AUS-1.03]- 11/14/2002
[    0.488000] task: f64684e0 ti: f647c000 task.ti: f647c000
[    0.488000] EIP: 0060:[<c104ccc9>] EFLAGS: 00010046 CPU: 0
[    0.488000] EIP is at select_task_rq_fair+0x3f5/0x546
[    0.488000] EAX: 00000000 EBX: f6403460 ECX: f6403480 EDX: 00000000
[    0.488000] ESI: f643ca00 EDI: 00000000 EBP: f647df2c ESP: f647dec8
[    0.488000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.488000] CR0: 8005003b CR2: ffe67000 CR3: 0141b000 CR4: 000007d0
[    0.488000] Stack:
[    0.488000]  f646f500 00000002 00000000 f647dedc c1087da7 f647df40
c102d562 f6403470
[    0.488000]  00000070 00000008 00000000 00000379 f6bf4a80 00000000
c1413280 f646f500
[    0.488000]  00000000 f64684e0 f6403420 00000000 00000000 00000000
f646f500 c12a14ec
[    0.488000] Call Trace:
[    0.488000]  [<c1087da7>] ? perf_event_fork+0xf/0x11
[    0.488000]  [<c102d562>] ? copy_process.part.42+0x1068/0x1255
[    0.488000]  [<c10496e7>] wake_up_new_task+0x30/0xea
[    0.488000]  [<c10415c9>] ? kthread_freezable_should_stop+0x40/0x40
[    0.488000]  [<c102d90c>] do_fork+0x10c/0x237
[    0.488000]  [<c10493a4>] ? do_set_cpus_allowed+0x2d/0x37
[    0.488000]  [<c10415c9>] ? kthread_freezable_should_stop+0x40/0x40
[    0.488000]  [<c102da51>] kernel_thread+0x1a/0x1f
[    0.488000]  [<c1041ad5>] kthreadd+0xc7/0x10e
[    0.488000]  [<c1298241>] ret_from_kernel_thread+0x21/0x30
[    0.488000]  [<c1041a0e>] ? kthread_create_on_cpu+0x44/0x44
[    0.488000] Code: ff ff 8b 4d a0 01 45 f0 8b 45 b8 41 ba 04 00 00
00 e8 10 57 0f 00 3b 05 a0 d9 3a c1 89 c1 7c c8 8b 45 f0 31 d2 8b 4b
0c c1 e0 0a <f7> 71 04 83 7d c4 00 75 07 3b 45 dc 6
[    0.488000] EIP: [<c104ccc9>] select_task_rq_fair+0x3f5/0x546
SS:ESP 0068:f647dec8
[    0.488000] ---[ end trace 242397e5073f294a ]---
[    0.488000] BUG: unable to handle kernel paging request at ffffffec
[    0.488000] IP: [<c1041927>] kthread_data+0xa/0xe
[    0.488000] *pde =3D 0141d067 *pte =3D 00000000
[    0.488000] Oops: 0000 [#3] SMP
[    0.488000] Modules linked in:
[    0.488000] CPU: 2 PID: 6 Comm: kworker/u8:0 Tainted: G      D
 3.15.0-1+ #1
[    0.488000] Hardware name: IBM eserver xSeries 335 -[867642X]-/,
BIOS -[T2E114AUS-1.03]- 11/14/2002
[    0.488000] task: f6469860 ti: f6484000 task.ti: f6484000
[    0.488000] EIP: 0060:[<c1041927>] EFLAGS: 00010002 CPU: 2
[    0.488000] EIP is at kthread_data+0xa/0xe
[    0.488000] EAX: 00000000 EBX: 00000002 ECX: 00000000 EDX: 00000002
[    0.488000] ESI: 00000002 EDI: f6469860 EBP: f6485b2c ESP: f6485b24
[    0.488000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.488000] CR0: 8005003b CR2: 00000014 CR3: 0141b000 CR4: 000007d0
[    0.488000] Stack:
[    0.488000]  c103dd15 f6469ad8 f6485ba0 c1291a39 f6485b48 c1413280
c1413280 f640e100
[    0.488000]  c10b6499 f6c0f280 f6469860 f6471b80 f6485b70 00000246
00406408 00000246
[    0.488000]  f6469860 f6469860 00000000 f6485b7c c105f724 00000000
f6485ba8 c102eba0
[    0.488000] Call Trace:
[    0.488000]  [<c103dd15>] ? wq_worker_sleeping+0xb/0x76
[    0.488000]  [<c1291a39>] __schedule+0xdd/0x673
[    0.488000]  [<c10b6499>] ? kmem_cache_free+0xd0/0xd9
[    0.488000]  [<c105f724>] ? call_rcu_sched+0xf/0x12
[    0.488000]  [<c102eba0>] ? release_task+0x387/0x399
[    0.488000]  [<c1292071>] schedule+0x56/0x58
[    0.488000]  [<c102feaf>] do_exit+0x75d/0x7b3
[    0.488000]  [<c128f935>] ? printk+0x17/0x19
[    0.488000]  [<c1294d00>] oops_end+0x8e/0x96
[    0.488000]  [<c1004094>] die+0x54/0x5c
[    0.488000]  [<c12948e7>] do_trap+0x69/0xa4
[    0.488000]  [<c1002080>] ? math_state_restore+0x180/0x180
[    0.488000]  [<c10020ee>] do_divide_error+0x6e/0x78
[    0.488000]  [<c10500b3>] ? find_busiest_group+0x18a/0x583
[    0.488000]  [<c12946ce>] error_code+0x5a/0x60
[    0.488000]  [<c1002080>] ? math_state_restore+0x180/0x180
[    0.488000]  [<c10500b3>] ? find_busiest_group+0x18a/0x583
[    0.488000]  [<c105059b>] load_balance+0xef/0x5cb
[    0.488000]  [<c104b509>] ? sched_clock_local+0x11/0x139
[    0.488000]  [<c1050ffe>] pick_next_task_fair+0x28e/0x398
[    0.488000]  [<c1046ee9>] ? dequeue_task+0x8a/0x92
[    0.488000]  [<c1291b51>] __schedule+0x1f5/0x673
[    0.488000]  [<c1291e96>] ? __schedule+0x53a/0x673
[    0.488000]  [<c104967d>] ? default_wake_function+0xb/0xd
[    0.488000]  [<c10549db>] ? __wake_up_common+0x34/0x5a
[    0.488000]  [<c1292071>] schedule+0x56/0x58
[    0.488000]  [<c103dbbc>] worker_thread+0x244/0x27d
[    0.488000]  [<c103d978>] ? manage_workers.isra.28+0x189/0x189
[    0.488000]  [<c1041668>] kthread+0x9f/0xa4
[    0.488000]  [<c1298241>] ret_from_kernel_thread+0x21/0x30
[    0.488000]  [<c10415c9>] ? kthread_freezable_should_stop+0x40/0x40
[    0.488000] Code: c4 3c 5b 5e 5f 5d c3 55 64 a1 ac e6 40 c1 8b 80
4c 02 00 00 89 e5 5d 8b 40 e4 c1 e8 02 83 e0 01 c3 55 8b 80 4c 02 00
00 89 e5 5d <8b> 40 ec c3 55 b9 04 00 00 00 89 e5 5
[    0.488000] EIP: [<c1041927>] kthread_data+0xa/0xe SS:ESP
0068:f6485b24
[    0.488000] CR2: 00000000ffffffec
[    0.488000] ---[ end trace 242397e5073f294b ]---
[    0.488000] Fixing recursive fault but reboot is needed!
[    0.488051] divide error: 0000 [#4] SMP
[    0.492000] Modules linked in:
[    0.492000] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G      D
3.15.0-1+ #1
[    0.492000] Hardware name: IBM eserver xSeries 335 -[867642X]-/,
BIOS -[T2E114AUS-1.03]- 11/14/2002
[    0.492000] task: f6468000 ti: f644c000 task.ti: f644c000
[    0.492000] EIP: 0060:[<c10500b3>] EFLAGS: 00010046 CPU: 0
[    0.492000] EIP is at find_busiest_group+0x18a/0x583
[    0.492000] EAX: 00000000 EBX: f644dc9c ECX: 00000000 EDX: 00000000
[    0.492000] ESI: 00000004 EDI: ffffffff EBP: f644dd40 ESP: f644dc6c
[    0.492000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.492000] CR0: 8005003b CR2: ffe67000 CR3: 0141b000 CR4: 000007d0
[    0.492000] Stack:
[    0.492000]  b6cb9571 00000001 00000001 00000000 00000000 c1413280
00000000 00000000
[    0.492000]  f6c0f280 00000000 f644dd8c f6403460 00000000 00000000
00000000 00000000
[    0.492000]  00000000 ffffffff 00000000 00000000 00000000 00000000
00000000 00000000
[    0.492000] Call Trace:
[    0.492000]  [<c105059b>] load_balance+0xef/0x5cb
[    0.492000]  [<c104b509>] ? sched_clock_local+0x11/0x139
[    0.492000]  [<c1050ffe>] pick_next_task_fair+0x28e/0x398
[    0.492000]  [<c1046ee9>] ? dequeue_task+0x8a/0x92
[    0.492000]  [<c1291b51>] __schedule+0x1f5/0x673
[    0.492000]  [<c1291e96>] ? __schedule+0x53a/0x673
[    0.492000]  [<c104d006>] ? check_preempt_wakeup+0xf9/0x13f
[    0.492000]  [<c1292071>] schedule+0x56/0x58
[    0.492000]  [<c12915ef>] schedule_timeout+0x17/0x10e
[    0.492000]  [<c104738a>] ? check_preempt_curr+0x27/0x62
[    0.492000]  [<c10473d6>] ? ttwu_do_wakeup+0x11/0xba
[    0.492000]  [<c129269c>] wait_for_common+0xc0/0xe3
[    0.492000]  [<c1049672>] ? try_to_wake_up+0x1aa/0x1aa
[    0.492000]  [<c1292724>] wait_for_completion_killable+0x12/0x21
[    0.492000]  [<c10416f8>] kthread_create_on_node+0x8b/0xf9
[    0.492000]  [<c103ea61>] __alloc_workqueue_key+0x21a/0x302
[    0.492000]  [<c103d4f2>] ? process_scheduled_works+0x21/0x21
[    0.492000]  [<c13c3a16>] usermodehelper_init+0x1a/0x2a
[    0.492000]  [<c13b2a65>] kernel_init_freeable+0xb6/0x19d
[    0.492000]  [<c128d68f>] kernel_init+0x8/0xb3
[    0.492000]  [<c1298241>] ret_from_kernel_thread+0x21/0x30
[    0.492000]  [<c128d687>] ? rest_init+0x5f/0x5f
[    0.492000] Code: 72 0e 00 3b 05 a0 d9 3a c1 89 c6 0f 8c 7b ff ff
ff 8b 95 58 ff ff ff 8b 7b 14 8b 42 0c 31 d2 8b 48 04 8b 43 04 89 4b
10 c1 e0 0a <f7> f1 85 ff 89 85 38 ff ff ff 89 03 7
[    0.492000] EIP: [<c10500b3>] find_busiest_group+0x18a/0x583 SS:ESP
0068:f644dc6c
[    0.492000] ---[ end trace 242397e5073f294c ]---
[    0.492000] divide error: 0000 [#5] SMP
[    0.492000] Modules linked in:
[    0.492000] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G      D
3.15.0-1+ #1
[    0.492000] Hardware name: IBM eserver xSeries 335 -[867642X]-/,
BIOS -[T2E114AUS-1.03]- 11/14/2002
[    0.492000] task: f646b5a0 ti: f6490000 task.ti: f6490000
[    0.492000] EIP: 0060:[<c10500b3>] EFLAGS: 00210246 CPU: 3
[    0.492000] EIP is at find_busiest_group+0x18a/0x583
[    0.492000] EAX: 00000000 EBX: f64bde38 ECX: 00000000 EDX: 00000000
[    0.492000] ESI: 00000004 EDI: ffffffff EBP: f64bdedc ESP: f64bde08
[    0.492000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.492000] CR0: 8005003b CR2: 00000000 CR3: 0141b000 CR4: 000007d0
[    0.492000] Stack:
[    0.492000]  00000000 00000001 00000001 00000000 00000000 c1413280
00000000 00000001
[    0.492000]  f6c0f280 00000000 f64bdf28 f6403460 00000000 00000000
00000000 00000000
[    0.492000]  00000000 ffffffff 00000000 00000000 00000000 00000000
00000000 00000000
[    0.492000] Call Trace:
[    0.492000]  [<c105059b>] load_balance+0xef/0x5cb
[    0.492000]  [<c104d9bb>] ? update_blocked_averages+0x53f/0x547
[    0.492000]  [<c1050bac>] rebalance_domains+0x135/0x1ed
[    0.492000]  [<c1050c92>] run_rebalance_domains+0x2e/0x10c
[    0.492000]  [<c10312c5>] __do_softirq+0x91/0x174
[    0.492000]  [<c1031234>] ? __hrtimer_tasklet_trampoline+0x1a/0x1a
[    0.492000]  [<c10032ff>] do_softirq_own_stack+0x1d/0x23
[    0.492000]  <IRQ>
[    0.492000]  [<c10314e7>] irq_exit+0x34/0x75
[    0.492000]  [<c102148d>] smp_apic_timer_interrupt+0x33/0x3d
[    0.492000]  [<c12944a5>] apic_timer_interrupt+0x2d/0x34
[    0.492000]  [<c104007b>] ? param_array_set+0x23/0xc0
[    0.492000]  [<c10076b5>] ? default_idle+0x5/0x7
[    0.492000]  [<c1007bcd>] arch_cpu_idle+0x9/0xb
[    0.492000]  [<c10550c1>] cpu_startup_entry+0xe6/0x1c9
[    0.492000]  [<c101ffad>] start_secondary+0x1a6/0x1ab
[    0.492000] Code: 72 0e 00 3b 05 a0 d9 3a c1 89 c6 0f 8c 7b ff ff
ff 8b 95 58 ff ff ff 8b 7b 14 8b 42 0c 31 d2 8b 48 04 8b 43 04 89 4b
10 c1 e0 0a <f7> f1 85 ff 89 85 38 ff ff ff 89 03 7
[    0.492000] EIP: [<c10500b3>] find_busiest_group+0x18a/0x583 SS:ESP
0068:f64bde08
[    0.492000] divide error: 0000 [#6]
[    0.492000] ---[ end trace 242397e5073f294d ]---
[    0.492000] SMP
[    0.492000] Kernel panic - not syncing: Fatal exception in interrupt
[    0.492000] Modules linked in:
[    0.492000] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G      D
3.15.0-1+ #1
[    0.492000] Hardware name: IBM eserver xSeries 335 -[867642X]-/,
BIOS -[T2E114AUS-1.03]- 11/14/2002
[    0.492000] task: f646abe0 ti: f648c000 task.ti: f648c000
[    0.492000] EIP: 0060:[<c10500b3>] EFLAGS: 00210246 CPU: 1
[    0.492000] EIP is at find_busiest_group+0x18a/0x583
[    0.492000] EAX: 00000000 EBX: f649de38 ECX: 00000000 EDX: 00000000
[    0.492000] ESI: 00000004 EDI: ffffffff EBP: f649dedc ESP: f649de08
[    0.492000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.492000] CR0: 8005003b CR2: 00000000 CR3: 0141b000 CR4: 000007d0
[    0.492000] Stack:
[    0.492000]  00000000 00000001 00000001 00000000 00000000 c1413280
00000000 00000001
[    0.492000]  f6c0f280 00000000 f649df28 f6403460 00000000 00000000
00000000 00000000
[    0.492000]  00000000 ffffffff 00000000 00000000 00000000 00000000
00000000 00000000
[    0.492000] Call Trace:
[    0.492000]  [<c105059b>] load_balance+0xef/0x5cb
[    0.492000]  [<c104d9bb>] ? update_blocked_averages+0x53f/0x547
[    0.492000]  [<c1050bac>] rebalance_domains+0x135/0x1ed
[    0.492000]  [<c1050c92>] run_rebalance_domains+0x2e/0x10c
[    0.492000]  [<c10312c5>] __do_softirq+0x91/0x174
[    0.492000]  [<c1031234>] ? __hrtimer_tasklet_trampoline+0x1a/0x1a
[    0.492000]  [<c10032ff>] do_softirq_own_stack+0x1d/0x23
[    0.492000]  <IRQ>
[    0.492000]  [<c10314e7>] irq_exit+0x34/0x75
[    0.492000]  [<c102148d>] smp_apic_timer_interrupt+0x33/0x3d
[    0.492000]  [<c12944a5>] apic_timer_interrupt+0x2d/0x34
[    0.492000]  [<c104007b>] ? param_array_set+0x23/0xc0
[    0.492000]  [<c10076b5>] ? default_idle+0x5/0x7
[    0.492000]  [<c1007bcd>] arch_cpu_idle+0x9/0xb
[    0.492000]  [<c10550c1>] cpu_startup_entry+0xe6/0x1c9
[    0.492000]  [<c101ffad>] start_secondary+0x1a6/0x1ab
[    0.492000] Code: 72 0e 00 3b 05 a0 d9 3a c1 89 c6 0f 8c 7b ff ff
ff 8b 95 58 ff ff ff 8b 7b 14 8b 42 0c 31 d2 8b 48 04 8b 43 04 89 4b
10 c1 e0 0a <f7> f1 85 ff 89 85 38 ff ff ff 89 03 7
[    0.492000] EIP: [<c10500b3>] find_busiest_group+0x18a/0x583 SS:ESP
0068:f649de08
[    0.492000] Shutting down cpus with NMI
[    0.492000] ---[ end Kernel panic - not syncing: Fatal exception in
interrupt

[7.] A small shell script or example program which triggers the
     problem (if possible)

Happens on boot.

[8.] Environment
[8.1.] Software (add the output of the ver_linux script here)

Linux mars 3.15.0-rc2-4+ #1 SMP Thu Jul 10 17:24:56 CDT 2014 i686
GNU/Linux
=20
Gnu C                  4.7
Gnu make               3.81
binutils               2.22
util-linux             2.20.1
mount                  support
module-init-tools      9
e2fsprogs              1.42.5
PPP                    2.4.5
Linux C Library        2.13
Dynamic linker (ldd)   2.13
Procps                 3.3.3
Net-tools              1.60
Kbd                    1.15.3
Sh-utils               8.13
Modules Loaded         speedstep_lib cpufreq_userspace cpufreq_powersave
cpufreq_stats cpufreq_conservative binfmt_misc fuse nfsd auth_rpcgss
oid_registry nfs_acl nfs lockd fscache sunrpc loop psmouse serio_raw
pcspkr evdev i2c_piix4 i2c_core parport_pc parport processor button
thermal_sys ext4 crc16 jbd2 mbcache dm_mod raid0 md_mod sg sd_mod sr_mod
cdrom crc_t10dif crct10dif_common ata_generic tg3 pata_serverworks
mptspi scsi_transport_spi mptscsih ptp floppy mptbase libata pps_core
libphy scsi_mod

[8.2.] Processor information (from /proc/cpuinfo):

Linux mars 3.15.0-rc2-4+ #1 SMP Thu Jul 10 17:24:56 CDT 2014 i686
GNU/Linux
=20
Gnu C                  4.7
Gnu make               3.81
binutils               2.22
util-linux             2.20.1
mount                  support
module-init-tools      9
e2fsprogs              1.42.5
PPP                    2.4.5
Linux C Library        2.13
Dynamic linker (ldd)   2.13
Procps                 3.3.3
Net-tools              1.60
Kbd                    1.15.3
Sh-utils               8.13
Modules Loaded         speedstep_lib cpufreq_userspace cpufreq_powersave
cpufreq_stats cpufreq_conservative binfmt_misc fuse nfsd auth_rpcgss
oid_registry nfs_acl nfs lockd fscache sunrpc loop psmouse serio_raw
pcspkr evdev i2c_piix4 i2c_core parport_pc parport processor button
thermal_sys ext4 crc16 jbd2 mbcache dm_mod raid0 md_mod sg sd_mod sr_mod
cdrom crc_t10dif crct10dif_common ata_generic tg3 pata_serverworks
mptspi scsi_transport_spi mptscsih ptp floppy mptbase libata pps_core
libphy scsi_mod

[8.3.] Module information (from /proc/modules):

speedstep_lib 12463 0 - Live 0xf8330000
cpufreq_userspace 12477 0 - Live 0xf832b000
cpufreq_powersave 12422 0 - Live 0xf8508000
cpufreq_stats 12767 0 - Live 0xf8590000
cpufreq_conservative 13872 0 - Live 0xf88e8000
binfmt_misc 12768 1 - Live 0xf8a99000
fuse 61916 1 - Live 0xf8777000
nfsd 165008 2 - Live 0xf8487000
auth_rpcgss 33963 1 nfsd, Live 0xf83e4000
oid_registry 12387 1 auth_rpcgss, Live 0xf83df000
nfs_acl 12463 1 nfsd, Live 0xf8395000
nfs 111573 0 - Live 0xf84bb000
lockd 49499 2 nfsd,nfs, Live 0xf840c000
fscache 37619 1 nfs, Live 0xf83f1000
sunrpc 138905 6 nfsd,auth_rpcgss,nfs_acl,nfs,lockd, Live 0xf8e02000
loop 22223 0 - Live 0xf8647000
psmouse 65105 0 - Live 0xf83c2000
serio_raw 12774 0 - Live 0xf8316000
pcspkr 12531 0 - Live 0xf8286000
evdev 17224 4 - Live 0xf83b1000
i2c_piix4 12592 0 - Live 0xf831c000
i2c_core 28790 1 i2c_piix4, Live 0xf83d6000
parport_pc 22073 0 - Live 0xf83bb000
parport 31658 1 parport_pc, Live 0xf8322000
processor 23363 0 - Live 0xf830f000
button 12824 0 - Live 0xf839a000
thermal_sys 23022 1 processor, Live 0xf8405000
ext4 341852 5 - Live 0xf8432000
crc16 12327 1 ext4, Live 0xf8281000
jbd2 58144 1 ext4, Live 0xf8385000
mbcache 13277 1 ext4, Live 0xf8276000
dm_mod 66924 15 - Live 0xf8373000
raid0 12829 1 - Live 0xf8269000
md_mod 86257 2 raid0, Live 0xf835c000
sg 21617 0 - Live 0xf8335000
sd_mod 35752 5 - Live 0xf82b5000
sr_mod 17541 0 - Live 0xf8298000
cdrom 30473 1 sr_mod, Live 0xf828c000
crc_t10dif 12399 1 sd_mod, Live 0xf8233000
crct10dif_common 12340 1 crc_t10dif, Live 0xf823f000
ata_generic 12450 0 - Live 0xf821f000
tg3 123463 0 - Live 0xf833c000
pata_serverworks 12791 3 - Live 0xf8224000
mptspi 17723 0 - Live 0xf827b000
scsi_transport_spi 19126 1 mptspi, Live 0xf8239000
mptscsih 22338 1 mptspi, Live 0xf826f000
ptp 17498 1 tg3, Live 0xf822d000
floppy 48260 0 - Live 0xf8302000
mptbase 52200 2 mptspi,mptscsih, Live 0xf82f4000
libata 126031 2 ata_generic,pata_serverworks, Live 0xf82c0000
pps_core 13016 1 ptp, Live 0xf820f000
libphy 23524 1 tg3, Live 0xf8214000
scsi_mod 140155 7
sg,sd_mod,sr_mod,mptspi,scsi_transport_spi,mptscsih,libata, Live
0xf8245000

[8.4.] Loaded driver and hardware information (/proc/ioports,
/proc/iomem)

0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0073 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:0f.1
  0170-0177 : pata_serverworks
01f0-01f7 : 0000:00:0f.1
  01f0-01f7 : pata_serverworks
0376-0376 : 0000:00:0f.1
  0376-0376 : pata_serverworks
03c0-03df : vga+
03f2-03f2 : floppy
03f4-03f5 : floppy
03f6-03f6 : 0000:00:0f.1
  03f6-03f6 : pata_serverworks
03f7-03f7 : floppy
03f8-03ff : serial
0420-0427 : pnp 00:00
0440-0447 : piix4_smbus
0460-0461 : pnp 00:00
0480-0483 : ACPI PM1a_EVT_BLK
0484-0485 : ACPI PM1a_CNT_BLK
0488-048b : ACPI PM_TMR
0498-049f : ACPI GPE0_BLK
0500-0503 : pnp 00:00
  0500-0503 : ACPI PM1b_EVT_BLK
0504-0507 : pnp 00:00
  0504-0505 : ACPI PM1b_CNT_BLK
0510-0517 : pnp 00:00
  0510-0517 : ACPI GPE1_BLK
0600-0600 : pnp 00:0a
0700-070f : 0000:00:0f.1
  0700-070f : pata_serverworks
0cf8-0cff : PCI conf1
0f50-0f58 : pnp 00:0a
2200-22ff : 0000:00:01.0
2300-23ff : 0000:01:01.0
  2300-23ff : mpt


00000000-00000fff : reserved
00001000-0009dfff : System RAM
0009e000-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000c8000-000c87ff : Adapter ROM
000c8800-000c9fff : Adapter ROM
000e0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-3fffb9ff : System RAM
  01000000-012fe0a0 : Kernel code
  012fe0a1-014850ff : Kernel data
  014f7000-01580fff : Kernel bss
3fffba00-3fffffff : ACPI Tables
40000000-4001ffff : 0000:00:01.0
40100000-401fffff : 0000:01:01.0
f9fe0000-f9feffff : 0000:02:02.0
  f9fe0000-f9feffff : tg3
f9ff0000-f9ffffff : 0000:02:01.0
  f9ff0000-f9ffffff : tg3
fbfe0000-fbfeffff : 0000:01:01.0
  fbfe0000-fbfeffff : mpt
fbff0000-fbffffff : 0000:01:01.0
  fbff0000-fbffffff : mpt
fd000000-fdffffff : 0000:00:01.0
febfe000-febfefff : 0000:00:0f.2
febff000-febfffff : 0000:00:01.0
fec00000-ffffffff : reserved
  fec00000-fec003ff : IOAPIC 0
  fec01000-fec013ff : IOAPIC 1
  fec02000-fec023ff : IOAPIC 2
  fee00000-fee00fff : Local APIC


[8.5.] PCI information ('lspci -vvv' as root)

00:00.0 Host bridge: Broadcom CMIC-WS Host Bridge (GC-LE chipset) (rev
13)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:00.1 Host bridge: Broadcom CMIC-WS Host Bridge (GC-LE chipset)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:00.2 Host bridge: Broadcom CMIC-LE
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:01.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI
Rage XL (rev 27) (prog-if 00 [VGA controller])
	Subsystem: IBM eServer xSeries server mainboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping+ SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (2000ns min), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at fd000000 (32-bit, non-prefetchable)
[size=3D16M]
	Region 1: I/O ports at 2200 [size=3D256]
	Region 2: Memory at febff000 (32-bit, non-prefetchable)
[size=3D4K]
	[virtual] Expansion ROM at 40000000 [disabled] [size=3D128K]
	Capabilities: [5c] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-

00:0f.0 Host bridge: Broadcom CSB5 South Bridge (rev 93)
	Subsystem: Broadcom CSB5 South Bridge
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Kernel driver in use: piix4_smbus

00:0f.1 IDE interface: Broadcom CSB5 IDE Controller (rev 93) (prog-if 8a
[Master SecP PriP])
	Subsystem: Broadcom CSB5 IDE Controller
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Region 0: I/O ports at 01f0 [size=3D8]
	Region 1: I/O ports at 03f4 [size=3D1]
	Region 2: I/O ports at 0170 [size=3D8]
	Region 3: I/O ports at 0374 [size=3D1]
	Region 4: I/O ports at 0700 [size=3D16]
	Kernel driver in use: pata_serverworks

00:0f.2 USB controller: Broadcom OSB4/CSB5 OHCI USB Controller (rev 05)
(prog-if 10 [OHCI])
	Subsystem: Broadcom OSB4/CSB5 OHCI USB Controller
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV+ VGASnoop-
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at febfe000 (32-bit, non-prefetchable)
[size=3D4K]

00:0f.3 ISA bridge: Broadcom CSB5 LPC bridge
	Subsystem: Broadcom Device 0230
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:11.0 Host bridge: Broadcom CIOB-X2 PCI-X I/O Bridge (rev 03)
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
	Capabilities: [60] PCI-X non-bridge device
		Command: DPERE- ERO- RBC=3D512 OST=3D8
		Status: Dev=3D00:00.0 64bit+ 133MHz+ SCD- USC- DC=3Dbridge
DMMRBC=3D512 DMOST=3D8 DMCRS=3D8 RSCEM- 266MHz- 533MHz-

00:11.2 Host bridge: Broadcom CIOB-X2 PCI-X I/O Bridge (rev 03)
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
	Capabilities: [60] PCI-X non-bridge device
		Command: DPERE- ERO- RBC=3D512 OST=3D8
		Status: Dev=3D00:00.0 64bit+ 133MHz+ SCD- USC- DC=3Dbridge
DMMRBC=3D512 DMOST=3D8 DMCRS=3D8 RSCEM- 266MHz- 533MHz-

01:01.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X
Fusion-MPT Dual Ultra320 SCSI (rev 07)
	Subsystem: IBM Device 026d
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 72 (4250ns min, 4500ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 22
	Region 0: I/O ports at 2300 [size=3D256]
	Region 1: Memory at fbff0000 (64-bit, non-prefetchable)
[size=3D64K]
	Region 3: Memory at fbfe0000 (64-bit, non-prefetchable)
[size=3D64K]
	[virtual] Expansion ROM at 40100000 [disabled] [size=3D1M]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [58] MSI: Enable- Count=3D1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [68] PCI-X non-bridge device
		Command: DPERE- ERO- RBC=3D512 OST=3D1
		Status: Dev=3D01:01.0 64bit+ 133MHz+ SCD- USC- DC=3Dsimple
DMMRBC=3D2048 DMOST=3D8 DMCRS=3D16 RSCEM- 266MHz- 533MHz-
	Kernel driver in use: mptspi

02:01.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5703X
Gigabit Ethernet (rev 02)
	Subsystem: IBM eServer xSeries server mainboard
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (16000ns min), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 24
	Region 0: Memory at f9ff0000 (64-bit, non-prefetchable)
[size=3D64K]
	Capabilities: [40] PCI-X non-bridge device
		Command: DPERE- ERO- RBC=3D2048 OST=3D1
		Status: Dev=3D02:01.1 64bit+ 133MHz+ SCD- USC- DC=3Dsimple
DMMRBC=3D2048 DMOST=3D1 DMCRS=3D16 RSCEM- 266MHz- 533MHz-
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D1 PME-
	Capabilities: [50] Vital Product Data
		Product Name: Broadcom NetXtreme Gigabit Ethernet
Controller
		Read-only fields:
			[PN] Part number: BCM95703A30
			[EC] Engineering changes: 106679-15
			[SN] Serial number: 0123456789
			[MN] Manufacture ID: 31 34 65 34
			[RV] Reserved: checksum bad, 25 byte(s) reserved
		Read/write fields:
			[YA] Asset tag: XYZ01234567
			[RW] Read-write area: 107 byte(s) free
		End
	Capabilities: [58] MSI: Enable- Count=3D1/8 Maskable- 64bit+
		Address: ffff577dfffff3e4  Data: ffbf
	Kernel driver in use: tg3

02:02.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5703X
Gigabit Ethernet (rev 02)
	Subsystem: IBM eServer xSeries server mainboard
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (16000ns min), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 25
	Region 0: Memory at f9fe0000 (64-bit, non-prefetchable)
[size=3D64K]
	Capabilities: [40] PCI-X non-bridge device
		Command: DPERE- ERO- RBC=3D2048 OST=3D1
		Status: Dev=3D02:02.1 64bit+ 133MHz+ SCD- USC- DC=3Dsimple
DMMRBC=3D2048 DMOST=3D1 DMCRS=3D16 RSCEM- 266MHz- 533MHz-
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D1 PME-
	Capabilities: [50] Vital Product Data
		Product Name: Broadcom NetXtreme Gigabit Ethernet
Controller
		Read-only fields:
			[PN] Part number: BCM95703A30
			[EC] Engineering changes: 106679-15
			[SN] Serial number: 0123456789
			[MN] Manufacture ID: 31 34 65 34
			[RV] Reserved: checksum bad, 25 byte(s) reserved
		Read/write fields:
			[YA] Asset tag: XYZ01234567
			[RW] Read-write area: 107 byte(s) free
		End
	Capabilities: [58] MSI: Enable- Count=3D1/8 Maskable- 64bit+
		Address: f7fbdf77ffefbfdc  Data: fdff
	Kernel driver in use: tg3

[8.6.] SCSI information (from /proc/scsi/scsi)

/proc/scsi/scsi: No such file or directory

[8.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):

[X.] Other notes, patches, fixes, workarounds:



--=20
Greg Donald

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJTxAvbAAoJEHjl9MlCwU2DA0cIAMqKAT0RximQn39FtMCimMH4
w3gAtmD8ZT9VjE6j30Ehzl/qQAgnvTOgzrp76/IY5DEAMyhOjLCEiEja7EHMY3L2
qRpOnJCz1+cUINaXvlZ7XGjcK+b+oGCfRx8iNYPRuWMyiHI+d7SOOuIlESdyXdeU
IDc1AWoGX6oHXnISoYgw6im/ioDrsYFLL0WkGYGa1COnk5YBqQ6oaFUZxdB1VB0P
BHSRw4mvdt3n2cjQCj0himwKJwavaW/UoLqEJS6KhcciuZ3fnM2Xx28xTsRBaS6O
8LBGsUT8TPrF0tL1rxhQbucHHA+gJxWtCA2t0vAhSPCDm/H/AG8O9FrwDVXMX4Q=
=bVL6
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
