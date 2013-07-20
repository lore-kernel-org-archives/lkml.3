Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab3GTNMr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 09:12:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:4124 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723Ab3GTNMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 09:12:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,708,1367996400"; 
   d="log'?scan'208";a="368320141"
Date: Sat, 20 Jul 2013 21:12:26 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: fengguang.wu@intel.com, Jiri Kosina <jkosina@suse.cz>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [x86] Kernel panic - not syncing: Fatal exception in interrupt
Message-ID: <20130720131226.GA13893@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit 51b2c07b22261f19188d9a9071943d60a067481c
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Fri Jul 12 11:22:09 2013 +0200

    x86: Make jump_label use int3-based patching
    
    Make jump labels use text_poke_bp() for text patching instead of
    text_poke_smp(), avoiding the need for stop_machine().
    
    Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
    Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>
    Link: http://lkml.kernel.org/r/alpine.LNX.2.00.1307121120250.29788@pobox.suse.cz
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>


Parent commit not clean. Look out for wrong bisect!

BUG: kernel boot crashed

/kernel/x86_64-randconfig-c05-0718/fd4363fff3d96795d3feb1b3fb48ce590f186bdd/dmesg-kvm-xbm-7912-20130720142415-3.11.0-rc1-00166-g1faabf2-146

[    0.212429] devtmpfs: initialized
[    0.236027] int3: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    0.237157] Modules linked in:
[    0.237765] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.11.0-rc1-01429-g04bf576 #8
[    0.239129] task: ffff88000da1b040 ti: ffff88000da1c000 task.ti: ffff88000da1c000
[    0.240000] RIP: 0010:[<ffffffff811098cc>]  [<ffffffff811098cc>] ttwu_do_wakeup+0x28/0x225
[    0.240000] RSP: 0000:ffff88000dd03f10  EFLAGS: 00000006
[    0.240000] RAX: 0000000000000000 RBX: ffff88000dd12940 RCX: ffffffff81769c40
[    0.240000] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 0000000000000001
[    0.240000] RBP: ffff88000dd03f28 R08: ffffffff8176a8c0 R09: 0000000000000002
[    0.240000] R10: ffffffff810ff484 R11: ffff88000dd129e8 R12: ffff88000dbc90c0
[    0.240000] R13: ffff88000dbc90c0 R14: ffff88000da1dfd8 R15: ffff88000da1dfd8
[    0.240000] FS:  0000000000000000(0000) GS:ffff88000dd00000(0000) knlGS:0000000000000000
[    0.240000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.240000] CR2: 00000000ffffffff CR3: 0000000001c88000 CR4: 00000000000006e0
[    0.240000] Stack:
[    0.240000]  ffff88000dd12940 ffff88000dbc90c0 ffff88000da1dfd8 ffff88000dd03f48
[    0.240000]  ffffffff81109e2b ffff88000dd12940 0000000000000000 ffff88000dd03f68
[    0.240000]  ffffffff81109e9e 0000000000000000 0000000000012940 ffff88000dd03f98
[    0.240000] Call Trace:
[    0.240000]  <IRQ> 
[    0.240000]  [<ffffffff81109e2b>] ttwu_do_activate.constprop.56+0x6d/0x79
[    0.240000]  [<ffffffff81109e9e>] sched_ttwu_pending+0x67/0x84
[    0.240000]  [<ffffffff8110c845>] scheduler_ipi+0x15a/0x2b0
[    0.240000]  [<ffffffff8104dfb4>] smp_reschedule_interrupt+0x38/0x41
[    0.240000]  [<ffffffff8173bf5d>] reschedule_interrupt+0x6d/0x80
[    0.240000]  <EOI> 
[    0.240000]  [<ffffffff810ff484>] ? __atomic_notifier_call_chain+0x5/0xc1
[    0.240000]  [<ffffffff8105cc30>] ? native_safe_halt+0xd/0x16
[    0.240000]  [<ffffffff81015f10>] default_idle+0x147/0x282
[    0.240000]  [<ffffffff81017026>] arch_cpu_idle+0x3d/0x5d
[    0.240000]  [<ffffffff81127d6a>] cpu_idle_loop+0x46d/0x5db
[    0.240000]  [<ffffffff81127f5c>] cpu_startup_entry+0x84/0x84
[    0.240000]  [<ffffffff8104f4f8>] start_secondary+0x3c8/0x3d5
[    0.240000] Code: 5c 5d c3 e8 d7 0f 63 00 55 48 ff 05 1f 5d 1e 01 48 89 e5 41 55 49 89 f5 41 54 53 48 89 fb e8 8d fe ff ff 48 ff 05 0d 5d 1e 01 cc <1f> 44 00 00 31 c0 eb 0c 48 ff 05 05 5d 1e 01 b8 01 00 00 00 48 
[    0.240000] RIP  [<ffffffff811098cc>] ttwu_do_wakeup+0x28/0x225
[    0.240000]  RSP <ffff88000dd03f10>
[    0.240000] ---[ end trace 0d3288a047152a17 ]---

git bisect start 04bf57606b28bfa283bd118e4ea032151b02f6df 61f98b0fca802d7e0191072606519e2230a6226d --
git bisect good 4b6cd6e8fdab82632dff52f495ea60c712d3ce0e  # 11:12     55+  kvm tools: Update README
git bisect good c56875099528aa54eb28b5feb11935c4069b5835  # 11:46     55+  kvm tools: Fix 'lkvm stop' when guest is pasued.
git bisect good 3b1938c28d3f6e28d7ecf2e30324e80a5a7fff35  # 11:58     55+  kvm tools: move kvm_config into struct kvm
git bisect good 7c6238bf263d8488878d17377ae0f255a93f6927  # 12:22     55+  kvm tools: remove unneeded checks in qcow code
git bisect good 7160bbc1d66580a9eb7ee9251e4b58d34d264baa  # 12:58     55+  kvm tools: ioport: allow ioport devices to generate fdt nodes
git bisect  bad 54396a651817c510d8d5405cf2ddfce9d3a7108d  # 13:07     12-  Merge branch 'x86/urgent'
git bisect good b8e7b7b26a0082c461d1be51fbe411a0d1cf196f  # 13:27     55+  Merge branch 'x86/asm'
git bisect  bad 63a1d00d179f794012001c50afacadc98b2c4b81  # 13:32     12-  Merge branch 'x86/jumplabel'
git bisect good 237d1548543312fcc8c99d302ab68fbf8ef6f97f  # 13:44     75+  x86: Fix override new_cpu_data.x86 with 486
git bisect  bad 51b2c07b22261f19188d9a9071943d60a067481c  # 13:53     65-  x86: Make jump_label use int3-based patching
git bisect good fd4363fff3d96795d3feb1b3fb48ce590f186bdd  # 14:18    340+  x86: Introduce int3 (breakpoint)-based instruction patching
git bisect good fd4363fff3d96795d3feb1b3fb48ce590f186bdd  # 14:24   1020+  x86: Introduce int3 (breakpoint)-based instruction patching
git bisect  bad 04bf57606b28bfa283bd118e4ea032151b02f6df  # 14:25      0-  Merge branch 'sched/urgent'
git bisect good a1fab3cce9730d3ec8d5caf2e6acb0a0ff8dd240  # 14:39   1020+  Revert "x86: Make jump_label use int3-based patching"
git bisect good d471ce53b1fab60110e4e9f647a345cea31752de  # 17:31   1020+  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml
git bisect  bad c1f631b9a68251007a6353041ae90f9f7dca771c  # 17:31      0-  Add linux-next specific files for 20130719
git bisect  bad 5a69985392e60abcaeb2243faf040488330a6ae8  # 17:34     22-  Merge branch 'perf/core'

Thanks,
Fengguang

--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-snb-16313-20130718213435-3.11.0-rc1-00026-g0ec5f3a-58"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Linux version 3.11.0-rc1-01429-g04bf576 (kbuild@cairo) (gcc =
version 4.8.1 (Debian 4.8.1-3) ) #8 SMP PREEMPT Thu Jul 18 21:29:12 CST 2013
[    0.000000] Command line: hung_task_panic=3D1 rcutree.rcu_cpu_stall_time=
out=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug d=
ynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/ke=
rnel-tests/run-queue/kvm/x86_64-randconfig-c05-0718/tip:master/.vmlinuz-04b=
f57606b28bfa283bd118e4ea032151b02f6df-20130718213155-3-snb branch=3Dtip/mas=
ter  BOOT_IMAGE=3D/kernel/x86_64-randconfig-c05-0718/04bf57606b28bfa283bd11=
8e4ea032151b02f6df/vmlinuz-3.11.0-rc1-01429-g04bf576
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
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
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02d2d000, 0x02d2dfff] PGTABLE
[    0.000000] BRK [0x02d2e000, 0x02d2efff] PGTABLE
[    0.000000] BRK [0x02d2f000, 0x02d2ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 4k
[    0.000000] BRK [0x02d30000, 0x02d30fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 4k
[    0.000000] BRK [0x02d31000, 0x02d31fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127764(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 00034 (v01 BOCHS  BXPCRSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000=
001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 011A9 (v01   BXPC   BXDSDT 00000=
001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 00080 (v01 BOCHS  BXPCAPIC 00000=
001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 00038 (v01 BOCHS  BXPCHPET 00000=
001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 960 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88000dc00000 s79240 r8192=
 d23160 u1048576
[    0.000000] pcpu-alloc: s79240 r8192 d23160 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr dc0ce40
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64391
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-c05-0718/tip:master/.vmlin=
uz-04bf57606b28bfa283bd118e4ea032151b02f6df-20130718213155-3-snb branch=3Dt=
ip/master  BOOT_IMAGE=3D/kernel/x86_64-randconfig-c05-0718/04bf57606b28bfa2=
83bd118e4ea032151b02f6df/vmlinuz-3.11.0-rc1-01429-g04bf576
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 194116K/261744K available (7418K kernel code, 4879K =
rwdata, 5344K rodata, 944K init, 11228K bss, 67628K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
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
[    0.000000]  memory used by lock dependency info: 5823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
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
[    0.000000] ODEBUG: 13 of 13 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2300.192 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 4600.38 Bogo=
MIPS (lpj=3D9200768)
[    0.008000] pid_max: default: 32768 minimum: 301
[    0.008389] Mount-cache hash table entries: 256
[    0.009817] Initializing cgroup subsys debug
[    0.010661] Initializing cgroup subsys perf_event
[    0.012023] Initializing cgroup subsys hugetlb
[    0.013022] mce: CPU supports 10 MCE banks
[    0.013908] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.013908] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.013908] tlb_flushall_shift: 6
[    0.016155] debug: unmapping init [mem 0xffffffff82233000-0xffffffff8223=
5fff]
[    0.024574] ACPI: Core revision 20130517
[    0.030172] ACPI: All ACPI Tables successfully acquired
[    0.031611] Getting VERSION: 50014
[    0.032034] Getting VERSION: 50014
[    0.032703] Getting ID: 0
[    0.033231] Getting ID: ff000000
[    0.033895] Getting LVT0: 8700
[    0.034483] Getting LVT1: 8400
[    0.035182] enabled ExtINT on CPU#0
[    0.037629] ENABLING IO-APIC IRQs
[    0.038281] init IO_APIC IRQs
[    0.038862]  apic 0 pin 0 not connected
[    0.039620] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.040061] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.041573] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.044055] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.045548] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.047037] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.048055] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.049539] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.052054] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.053550] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.055142] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.056056] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.057582] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.060065] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.061590] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.063128]  apic 0 pin 16 not connected
[    0.064021]  apic 0 pin 17 not connected
[    0.064799]  apic 0 pin 18 not connected
[    0.065538]  apic 0 pin 19 not connected
[    0.066292]  apic 0 pin 20 not connected
[    0.067015]  apic 0 pin 21 not connected
[    0.067753]  apic 0 pin 22 not connected
[    0.068021]  apic 0 pin 23 not connected
[    0.068979] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.070555] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.073737] Using local APIC timer interrupts.
[    0.073737] calibrating APIC timer ...
[    0.080000] ... lapic delta =3D 6249949
[    0.080000] ... PM-Timer delta =3D 357952
[    0.080000] ... PM-Timer result ok
[    0.080000] ..... delta 6249949
[    0.080000] ..... mult: 268433265
[    0.080000] ..... calibration result: 3999967
[    0.080000] ..... CPU clock speed is 2299.3921 MHz.
[    0.080000] ..... host bus clock speed is 999.3967 MHz.
[    0.080298] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.096488] ftrace: Allocated trace_printk buffers
[    0.109854] SMP alternatives: lockdep: fixing up alternatives
[    0.111812] smpboot: Booting Node   0, Processors  #1 OK
[    0.008000] kvm-clock: cpu 1, msr 0:fffd041, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.148383] Brought up 2 CPUs
[    0.149013] ----------------
[    0.152017] | NMI testsuite:
[    0.152578] --------------------
[    0.153172]   remote IPI:
[    0.160016] KVM setup async PF for cpu 1
[    0.160773] kvm-stealtime: cpu 1, msr dd0ce40
  ok  |
[    0.172279]    local IPI:  ok  |
[    0.196037] --------------------
[    0.196696] Good, all   2 testcases passed! |
[    0.197497] ---------------------------------
[    0.198288] smpboot: Total of 2 processors activated (9200.76 BogoMIPS)
[    0.212429] devtmpfs: initialized
[    0.236027] int3: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    0.237157] Modules linked in:
[    0.237765] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.11.0-rc1-01429-g=
04bf576 #8
[    0.239129] task: ffff88000da1b040 ti: ffff88000da1c000 task.ti: ffff880=
00da1c000
[    0.240000] RIP: 0010:[<ffffffff811098cc>]  [<ffffffff811098cc>] ttwu_do=
_wakeup+0x28/0x225
[    0.240000] RSP: 0000:ffff88000dd03f10  EFLAGS: 00000006
[    0.240000] RAX: 0000000000000000 RBX: ffff88000dd12940 RCX: ffffffff817=
69c40
[    0.240000] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 00000000000=
00001
[    0.240000] RBP: ffff88000dd03f28 R08: ffffffff8176a8c0 R09: 00000000000=
00002
[    0.240000] R10: ffffffff810ff484 R11: ffff88000dd129e8 R12: ffff88000db=
c90c0
[    0.240000] R13: ffff88000dbc90c0 R14: ffff88000da1dfd8 R15: ffff88000da=
1dfd8
[    0.240000] FS:  0000000000000000(0000) GS:ffff88000dd00000(0000) knlGS:=
0000000000000000
[    0.240000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.240000] CR2: 00000000ffffffff CR3: 0000000001c88000 CR4: 00000000000=
006e0
[    0.240000] Stack:
[    0.240000]  ffff88000dd12940 ffff88000dbc90c0 ffff88000da1dfd8 ffff8800=
0dd03f48
[    0.240000]  ffffffff81109e2b ffff88000dd12940 0000000000000000 ffff8800=
0dd03f68
[    0.240000]  ffffffff81109e9e 0000000000000000 0000000000012940 ffff8800=
0dd03f98
[    0.240000] Call Trace:
[    0.240000]  <IRQ>=20
[    0.240000]  [<ffffffff81109e2b>] ttwu_do_activate.constprop.56+0x6d/0x79
[    0.240000]  [<ffffffff81109e9e>] sched_ttwu_pending+0x67/0x84
[    0.240000]  [<ffffffff8110c845>] scheduler_ipi+0x15a/0x2b0
[    0.240000]  [<ffffffff8104dfb4>] smp_reschedule_interrupt+0x38/0x41
[    0.240000]  [<ffffffff8173bf5d>] reschedule_interrupt+0x6d/0x80
[    0.240000]  <EOI>=20
[    0.240000]  [<ffffffff810ff484>] ? __atomic_notifier_call_chain+0x5/0xc1
[    0.240000]  [<ffffffff8105cc30>] ? native_safe_halt+0xd/0x16
[    0.240000]  [<ffffffff81015f10>] default_idle+0x147/0x282
[    0.240000]  [<ffffffff81017026>] arch_cpu_idle+0x3d/0x5d
[    0.240000]  [<ffffffff81127d6a>] cpu_idle_loop+0x46d/0x5db
[    0.240000]  [<ffffffff81127f5c>] cpu_startup_entry+0x84/0x84
[    0.240000]  [<ffffffff8104f4f8>] start_secondary+0x3c8/0x3d5
[    0.240000] Code: 5c 5d c3 e8 d7 0f 63 00 55 48 ff 05 1f 5d 1e 01 48 89 =
e5 41 55 49 89 f5 41 54 53 48 89 fb e8 8d fe ff ff 48 ff 05 0d 5d 1e 01 cc =
<1f> 44 00 00 31 c0 eb 0c 48 ff 05 05 5d 1e 01 b8 01 00 00 00 48=20
[    0.240000] RIP  [<ffffffff811098cc>] ttwu_do_wakeup+0x28/0x225
[    0.240000]  RSP <ffff88000dd03f10>
[    0.240000] ---[ end trace 0d3288a047152a17 ]---
[    0.240000] Kernel panic - not syncing: Fatal exception in interrupt
[    0.240000] Rebooting in 10 seconds..
BUG: kernel boot crashed
Elapsed time: 20
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /tmp//kernel/x86_64-randc=
onfig-c05-0718/04bf57606b28bfa283bd118e4ea032151b02f6df/vmlinuz-3.11.0-rc1-=
01429-g04bf576-16313 -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_tim=
eout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug =
dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/ke=
rnel-tests/run-queue/kvm/x86_64-randconfig-c05-0718/tip:master/.vmlinuz-04b=
f57606b28bfa283bd118e4ea032151b02f6df-20130718213155-3-snb branch=3Dtip/mas=
ter  BOOT_IMAGE=3D/kernel/x86_64-randconfig-c05-0718/04bf57606b28bfa283bd11=
8e4ea032151b02f6df/vmlinuz-3.11.0-rc1-01429-g04bf576'  -initrd /kernel-test=
s/initrd/quantal-core-x86_64.cgz -m 256M -smp 2 -net nic,vlan=3D0,macaddr=
=3D00:00:00:00:00:00,model=3Dvirtio -net user,vlan=3D0,hostfwd=3Dtcp::20409=
-:22 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -n=
o-reboot -watchdog i6300esb -drive file=3D/fs/LABEL=3DKVM/disk0-snb-16313,m=
edia=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1-snb-16313,media=
=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk2-snb-16313,media=3Dd=
isk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-snb-16313,media=3Ddisk,=
if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk4-snb-16313,media=3Ddisk,if=
=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk5-snb-16313,media=3Ddisk,if=3Dv=
irtio -pidfile /dev/shm/kboot/pid-snb-lkp-16313 -serial file:/dev/shm/kboot=
/serial-snb-lkp-16313 -daemonize -display none -monitor null=20

--jI8keyz6grp/JLjh
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-04bf57606b28bfa283bd118e4ea032151b02f6df-x86_64-randconfig-c05-0718-Kernel-panic---not-syncing:-Fatal-exception-in-interrupt-81850.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDYxZjk4YjBmY2E4MDJkN2UwMTkxMDcyNjA2NTE5ZTIyMzBhNjIyNmQK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgMDRiZjU3Ni4uLiBNZXJnZSBicmFuY2ggJ3Nj
aGVkL3VyZ2VudCcKSEVBRCBpcyBub3cgYXQgNjFmOThiMC4uLiBNZXJnZSBicmFuY2ggJ2Zv
ci0zLjExJyBvZiBnaXQ6Ly9saW51eC1uZnMub3JnL35iZmllbGRzL2xpbnV4CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMDUtMDcxOC90
aXA6bWFzdGVyOjYxZjk4YjBmY2E4MDJkN2UwMTkxMDcyNjA2NTE5ZTIyMzBhNjIyNmQ6Ymlz
ZWN0LXRpcAoKMjAxMy0wNy0yMC0wOTo0OTo0NSA2MWY5OGIwZmNhODAyZDdlMDE5MTA3MjYw
NjUxOWUyMjMwYTYyMjZkIHJldXNlIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzA1LTA3
MTgvNjFmOThiMGZjYTgwMmQ3ZTAxOTEwNzI2MDY1MTllMjIzMGE2MjI2ZC92bWxpbnV6LTMu
MTEuMC1yYzEtMDAwMjMtZzYxZjk4YjAKCjIwMTMtMDctMjAtMDk6NDk6NDUgZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgLi4uLi4uLi4uLgkxMC4uCTExLi4uLi4uLi4JMTIJMTMuLgkxNAkxNi4u
LgkxOAkyMS4uCTIyCTIzCTI0Li4uCTI1Li4JMjYuLi4JMjcJMjguLi4uLi4JMzAJMzEJMzIu
LgkzMy4uLgkzNC4JMzYJMzcJNDAJNDUJNDkJNTMJNTUgU1VDQ0VTUwoKYmlzZWN0OiBnb29k
IGNvbW1pdCA2MWY5OGIwZmNhODAyZDdlMDE5MTA3MjYwNjUxOWUyMjMwYTYyMjZkCmdpdCBi
aXNlY3Qgc3RhcnQgMDRiZjU3NjA2YjI4YmZhMjgzYmQxMThlNGVhMDMyMTUxYjAyZjZkZiA2
MWY5OGIwZmNhODAyZDdlMDE5MTA3MjYwNjUxOWUyMjMwYTYyMjZkIC0tClByZXZpb3VzIEhF
QUQgcG9zaXRpb24gd2FzIDYxZjk4YjAuLi4gTWVyZ2UgYnJhbmNoICdmb3ItMy4xMScgb2Yg
Z2l0Oi8vbGludXgtbmZzLm9yZy9+YmZpZWxkcy9saW51eApIRUFEIGlzIG5vdyBhdCAzYzBl
ZWUzLi4uIExpbnV4IDIuNi4zNwpCaXNlY3Rpbmc6IDcwMiByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTAgc3RlcHMpCls0YjZjZDZlOGZkYWI4MjYzMmRm
ZjUyZjQ5NWVhNjBjNzEyZDNjZTBlXSBrdm0gdG9vbHM6IFVwZGF0ZSBSRUFETUUKZ2l0IGJp
c2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAv
aG9tZS93ZmcvdGlwL29iai1iaXNlY3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy90aXAvb2JqLWJpc2VjdApscyAtYSAv
a2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzA1LTA3MTgv
dGlwOm1hc3Rlcjo0YjZjZDZlOGZkYWI4MjYzMmRmZjUyZjQ5NWVhNjBjNzEyZDNjZTBlOmJp
c2VjdC10aXAKCjIwMTMtMDctMjAtMTA6Mjc6MTggNGI2Y2Q2ZThmZGFiODI2MzJkZmY1MmY0
OTVlYTYwYzcxMmQzY2UwZSBjb21waWxpbmcKMTk0OCByZWFsICAxMTc1IHVzZXIgIDkyIHN5
cyAgNjUuMDQlIGNwdSAJeDg2XzY0LXJhbmRjb25maWctYzA1LTA3MTgKCjIwMTMtMDctMjAt
MTE6MDM6NTAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4wLjAtcmM1LTAwNzAzLWc0YjZjZDZl
Li4uCTEJMgk0CTUJNgkxMgkxOAkyNQk0Mgk0NQk1MC4JNTEJNTMJNTUgU1VDQ0VTUwoKQmlz
ZWN0aW5nOiAzNTEgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDkgc3RlcHMpCltjNTY4NzUwOTk1MjhhYTU0ZWIyOGI1ZmViMTE5MzVjNDA2OWI1ODM1XSBr
dm0gdG9vbHM6IEZpeCAnbGt2bSBzdG9wJyB3aGVuIGd1ZXN0IGlzIHBhc3VlZC4KcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dm
Zy90aXAvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2
XzY0LXJhbmRjb25maWctYzA1LTA3MTgvdGlwOm1hc3RlcjpjNTY4NzUwOTk1MjhhYTU0ZWIy
OGI1ZmViMTE5MzVjNDA2OWI1ODM1OmJpc2VjdC10aXAKCjIwMTMtMDctMjAtMTE6MTI6NTYg
YzU2ODc1MDk5NTI4YWE1NGViMjhiNWZlYjExOTM1YzQwNjliNTgzNSBjb21waWxpbmcKOTgx
IHJlYWwgIDExODIgdXNlciAgODkgc3lzICAxMjkuNTclIGNwdSAJeDg2XzY0LXJhbmRjb25m
aWctYzA1LTA3MTgKCjIwMTMtMDctMjAtMTE6Mjk6NDUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
My4wLjAtcmM1LTAxMDU0LWdjNTY4NzUwLi4JMQkzCTQuCTcJMTAJMTEuCTE0CTE1CTE2Li4J
MTguLgkxOQkyMAkyMy4JMjYuLi4JMjguCTMwCTM1CTQxCTQ2CTQ4CTU1IFNVQ0NFU1MKCkJp
c2VjdGluZzogMTc1IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hs
eSA4IHN0ZXBzKQpbM2IxOTM4YzI4ZDNmNmUyOGQ3ZWNmMmUzMDMyNGU4MGE1YTdmZmYzNV0g
a3ZtIHRvb2xzOiBtb3ZlIGt2bV9jb25maWcgaW50byBzdHJ1Y3Qga3ZtCnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdGlw
L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1y
YW5kY29uZmlnLWMwNS0wNzE4L3RpcDptYXN0ZXI6M2IxOTM4YzI4ZDNmNmUyOGQ3ZWNmMmUz
MDMyNGU4MGE1YTdmZmYzNTpiaXNlY3QtdGlwCgoyMDEzLTA3LTIwLTExOjQ2OjU1IDNiMTkz
OGMyOGQzZjZlMjhkN2VjZjJlMzAzMjRlODBhNWE3ZmZmMzUgY29tcGlsaW5nCjI3MyByZWFs
ICAxNDYyIHVzZXIgIDEwNyBzeXMgIDU3NC42MiUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1j
MDUtMDcxOAoKMjAxMy0wNy0yMC0xMTo1MTo0OCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjUu
MC0wMTIzMC1nM2IxOTM4Yy4uLgkyCTUJNgkyMAkyNwkzMgkzOS4uLgk1NSBTVUNDRVNTCgpC
aXNlY3Rpbmc6IDg3IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hs
eSA3IHN0ZXBzKQpbN2M2MjM4YmYyNjNkODQ4ODg3OGQxNzM3N2FlMGYyNTVhOTNmNjkyN10g
a3ZtIHRvb2xzOiByZW1vdmUgdW5uZWVkZWQgY2hlY2tzIGluIHFjb3cgY29kZQpydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2Zn
L3RpcC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZf
NjQtcmFuZGNvbmZpZy1jMDUtMDcxOC90aXA6bWFzdGVyOjdjNjIzOGJmMjYzZDg0ODg4Nzhk
MTczNzdhZTBmMjU1YTkzZjY5Mjc6YmlzZWN0LXRpcAoKMjAxMy0wNy0yMC0xMTo1OTowMyA3
YzYyMzhiZjI2M2Q4NDg4ODc4ZDE3Mzc3YWUwZjI1NWE5M2Y2OTI3IGNvbXBpbGluZwoyNTIg
cmVhbCAgMTU2OSB1c2VyICAxMjAgc3lzICA2NjguNjElIGNwdSAJeDg2XzY0LXJhbmRjb25m
aWctYzA1LTA3MTgKCjIwMTMtMDctMjAtMTI6MDY6MTIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
My43LjAtcmMxLTAxMzE4LWc3YzYyMzhiLi4uCTEJNgkxOQk1MQk1My4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLgk1NSBTVUNDRVNTCgpCaXNlY3Rpbmc6IDQzIHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA2IHN0ZXBzKQpbNzE2MGJiYzFkNjY1ODBhOWVi
N2VlOTI1MWU0YjU4ZDM0ZDI2NGJhYV0ga3ZtIHRvb2xzOiBpb3BvcnQ6IGFsbG93IGlvcG9y
dCBkZXZpY2VzIHRvIGdlbmVyYXRlIGZkdCBub2RlcwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0
cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3RpcC9vYmotYmlzZWN0
CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1j
MDUtMDcxOC90aXA6bWFzdGVyOjcxNjBiYmMxZDY2NTgwYTllYjdlZTkyNTFlNGI1OGQzNGQy
NjRiYWE6YmlzZWN0LXRpcAoKMjAxMy0wNy0yMC0xMjoyMjo1MSA3MTYwYmJjMWQ2NjU4MGE5
ZWI3ZWU5MjUxZTRiNThkMzRkMjY0YmFhIGNvbXBpbGluZwo0MTUgcmVhbCAgMTYzMiB1c2Vy
ICAxMjcgc3lzICA0MjMuODIlIGNwdSAJeDg2XzY0LXJhbmRjb25maWctYzA1LTA3MTgKCjIw
MTMtMDctMjAtMTI6MzM6MDUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy45LjAtcmMxLTAxMzYy
LWc3MTYwYmJjLi4uLgk0CTE5CTM3CTQwCTQ2CTQ4CTUwLi4JNTIuLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4JNTUgU1VDQ0VTUwoKQmlzZWN0aW5nOiAyMCByZXZpc2lv
bnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNSBzdGVwcykKWzU0Mzk2YTY1
MTgxN2M1MTBkOGQ1NDA1Y2YyZGRmY2U5ZDNhNzEwOGRdIE1lcmdlIGJyYW5jaCAneDg2L3Vy
Z2VudCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9ob21lL3dmZy90aXAvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1x
dWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzA1LTA3MTgvdGlwOm1hc3Rlcjo1NDM5NmE2
NTE4MTdjNTEwZDhkNTQwNWNmMmRkZmNlOWQzYTcxMDhkOmJpc2VjdC10aXAKCjIwMTMtMDct
MjAtMTI6NTg6NDAgNTQzOTZhNjUxODE3YzUxMGQ4ZDU0MDVjZjJkZGZjZTlkM2E3MTA4ZCBj
b21waWxpbmcKNDQxIHJlYWwgIDE3NDYgdXNlciAgMTM1IHN5cyAgNDI2Ljc5JSBjcHUgCXg4
Nl82NC1yYW5kY29uZmlnLWMwNS0wNzE4CgoyMDEzLTA3LTIwLTEzOjA2OjI0IGRldGVjdGlu
ZyBib290IHN0YXRlIDMuMTEuMC1yYzEtMDAwNDYtZzU0Mzk2YTYJMwkxMiBURVNUIEZBSUxV
UkUKWyAgICAwLjE4MDU3NV0gZGV2dG1wZnM6IGluaXRpYWxpemVkClsgICAgMC4xOTYwNDFd
IGludDM6IDAwMDAgWyMxXSBQUkVFTVBUIFNNUCBERUJVR19QQUdFQUxMT0MKWyAgICAwLjE5
NzE5OV0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMC4xOTc3NDZdIENQVTogMSBQSUQ6IDAg
Q29tbTogc3dhcHBlci8xIE5vdCB0YWludGVkIDMuMTEuMC1yYzEtMDAwNDYtZzU0Mzk2YTYg
IzExOApbICAgIDAuMTk4OTg1XSB0YXNrOiBmZmZmODgwMDBkYTFiMDQwIHRpOiBmZmZmODgw
MDBkYTFjMDAwIHRhc2sudGk6IGZmZmY4ODAwMGRhMWMwMDAKWyAgICAwLjIwMDAwMF0gUklQ
OiAwMDEwOls8ZmZmZmZmZmY4MTEwOThjYz5dICBbPGZmZmZmZmZmODExMDk4Y2M+XSB0dHd1
X2RvX3dha2V1cCsweDI4LzB4MjI1ClsgICAgMC4yMDAwMDBdIFJTUDogMDAwMDpmZmZmODgw
MDBkZDAzZjEwICBFRkxBR1M6IDAwMDAwMDA2ClsgICAgMC4yMDAwMDBdIFJBWDogMDAwMDAw
MDAwMDAwMDAwMCBSQlg6IGZmZmY4ODAwMGRkMTI5NDAgUkNYOiBmZmZmZmZmZjgxNzY5YzQw
ClsgICAgMC4yMDAwMDBdIFJEWDogMDAwMDAwMDAwMDAwMDAwMiBSU0k6IDAwMDAwMDAwMDAw
MDAwMDAgUkRJOiAwMDAwMDAwMDAwMDAwMDAxClsgICAgMC4yMDAwMDBdIFJCUDogZmZmZjg4
MDAwZGQwM2YyOCBSMDg6IGZmZmZmZmZmODE3NmE4YzAgUjA5OiAwMDAwMDAwMDAwMDAwMDAy
ClsgICAgMC4yMDAwMDBdIFIxMDogZmZmZmZmZmY4MTBmZjQ4NCBSMTE6IGZmZmY4ODAwMGRk
MTI5ZTggUjEyOiBmZmZmODgwMDBkYmM5MGMwClsgICAgMC4yMDAwMDBdIFIxMzogZmZmZjg4
MDAwZGJjOTBjMCBSMTQ6IGZmZmY4ODAwMGRhMWRmZDggUjE1OiBmZmZmODgwMDBkYTFkZmQ4
ClsgICAgMC4yMDAwMDBdIEZTOiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmODgw
MDBkZDAwMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjIwMDAwMF0g
Q1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzYgpbICAg
IDAuMjAwMDAwXSBDUjI6IDAwMDAwMDAwZmZmZmZmZmYgQ1IzOiAwMDAwMDAwMDAxYzc2MDAw
IENSNDogMDAwMDAwMDAwMDAwMDZlMApbICAgIDAuMjAwMDAwXSBTdGFjazoKWyAgICAwLjIw
MDAwMF0gIGZmZmY4ODAwMGRkMTI5NDAgZmZmZjg4MDAwZGJjOTBjMCBmZmZmODgwMDBkYTFk
ZmQ4IGZmZmY4ODAwMGRkMDNmNDgKWyAgICAwLjIwMDAwMF0gIGZmZmZmZmZmODExMDllMmIg
ZmZmZjg4MDAwZGQxMjk0MCAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMGRkMDNmNjgKWyAg
ICAwLjIwMDAwMF0gIGZmZmZmZmZmODExMDllOWUgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAw
MDAwMDEyOTQwIGZmZmY4ODAwMGRkMDNmOTgKWyAgICAwLjIwMDAwMF0gQ2FsbCBUcmFjZToK
WyAgICAwLjIwMDAwMF0gIDxJUlE+IApbICAgIDAuMjAwMDAwXSAgWzxmZmZmZmZmZjgxMTA5
ZTJiPl0gdHR3dV9kb19hY3RpdmF0ZS5jb25zdHByb3AuNTYrMHg2ZC8weDc5ClsgICAgMC4y
MDAwMDBdICBbPGZmZmZmZmZmODExMDllOWU+XSBzY2hlZF90dHd1X3BlbmRpbmcrMHg2Ny8w
eDg0ClsgICAgMC4yMDAwMDBdICBbPGZmZmZmZmZmODExMGM4NDU+XSBzY2hlZHVsZXJfaXBp
KzB4MTVhLzB4MmIwClsgICAgMC4yMDAwMDBdICBbPGZmZmZmZmZmODEwNGRmYjQ+XSBzbXBf
cmVzY2hlZHVsZV9pbnRlcnJ1cHQrMHgzOC8weDQxClsgICAgMC4yMDAwMDBdICBbPGZmZmZm
ZmZmODE3M2JmNWQ+XSByZXNjaGVkdWxlX2ludGVycnVwdCsweDZkLzB4ODAKWyAgICAwLjIw
MDAwMF0gIDxFT0k+IApbICAgIDAuMjAwMDAwXSAgWzxmZmZmZmZmZjgxMGZmNDg0Pl0gPyBf
X2F0b21pY19ub3RpZmllcl9jYWxsX2NoYWluKzB4NS8weGMxClsgICAgMC4yMDAwMDBdICBb
PGZmZmZmZmZmODEwNWNjMzA+XSA/IG5hdGl2ZV9zYWZlX2hhbHQrMHhkLzB4MTYKWyAgICAw
LjIwMDAwMF0gIFs8ZmZmZmZmZmY4MTAxNWYxMD5dIGRlZmF1bHRfaWRsZSsweDE0Ny8weDI4
MgpbICAgIDAuMjAwMDAwXSAgWzxmZmZmZmZmZjgxMDE3MDI2Pl0gYXJjaF9jcHVfaWRsZSsw
eDNkLzB4NWQKWyAgICAwLjIwMDAwMF0gIFs8ZmZmZmZmZmY4MTEyN2Q2YT5dIGNwdV9pZGxl
X2xvb3ArMHg0NmQvMHg1ZGIKWyAgICAwLjIwMDAwMF0gIFs8ZmZmZmZmZmY4MTEyN2Y1Yz5d
IGNwdV9zdGFydHVwX2VudHJ5KzB4ODQvMHg4NApbICAgIDAuMjAwMDAwXSAgWzxmZmZmZmZm
ZjgxMDRmNGY4Pl0gc3RhcnRfc2Vjb25kYXJ5KzB4M2M4LzB4M2Q1ClsgICAgMC4yMDAwMDBd
IENvZGU6IDVjIDVkIGMzIGU4IGQ3IDBmIDYzIDAwIDU1IDQ4IGZmIDA1IDFmIDNkIDFkIDAx
IDQ4IDg5IGU1IDQxIDU1IDQ5IDg5IGY1IDQxIDU0IDUzIDQ4IDg5IGZiIGU4IDhkIGZlIGZm
IGZmIDQ4IGZmIDA1IDBkIDNkIDFkIDAxIGNjIDwxZj4gNDQgMDAgMDAgMzEgYzAgZWIgMGMg
NDggZmYgMDUgMDUgM2QgMWQgMDEgYjggMDEgMDAgMDAgMDAgNDggClsgICAgMC4yMDAwMDBd
IFJJUCAgWzxmZmZmZmZmZjgxMTA5OGNjPl0gdHR3dV9kb193YWtldXArMHgyOC8weDIyNQpb
ICAgIDAuMjAwMDAwXSAgUlNQIDxmZmZmODgwMDBkZDAzZjEwPgpbICAgIDAuMjAwMDAwXSAt
LS1bIGVuZCB0cmFjZSA2YzgwNTQxOTU0YTllMTBhIF0tLS0KL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1jMDUtMDcxOC81NDM5NmE2NTE4MTdjNTEwZDhkNTQwNWNmMmRkZmNlOWQzYTcx
MDhkL2RtZXNnLWt2bS1rYnVpbGQtMTczNzUtMjAxMzA3MjAxMzA5MzQtMy4xMS4wLXJjMS0w
MDAwNy1nYTIzMmUyNy04NAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMwNS0wNzE4LzU0
Mzk2YTY1MTgxN2M1MTBkOGQ1NDA1Y2YyZGRmY2U5ZDNhNzEwOGQvZG1lc2cta3ZtLWtidWls
ZC01MDIxNS0yMDEzMDcyMDEzMDkzNS0zLjExLjAtcmMxLTAzNDgxLWc2NDFlOTdkLTExCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzA1LTA3MTgvNTQzOTZhNjUxODE3YzUxMGQ4ZDU0
MDVjZjJkZGZjZTlkM2E3MTA4ZC9kbWVzZy1rdm0ta2J1aWxkLTUxMTkzLTIwMTMwNzIwMTMw
OTMxLTMuMTEuMC1yYzEtMDMxMzEtZ2EzYjAzYjUtMTIKCkJpc2VjdGluZzogMTIgcmV2aXNp
b25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDQgc3RlcHMpCltiOGU3Yjdi
MjZhMDA4MmM0NjFkMWJlNTFmYmU0MTFhMGQxY2YxOTZmXSBNZXJnZSBicmFuY2ggJ3g4Ni9h
c20nCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aCAvaG9tZS93ZmcvdGlwL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMwNS0wNzE4L3RpcDptYXN0ZXI6YjhlN2I3YjI2
YTAwODJjNDYxZDFiZTUxZmJlNDExYTBkMWNmMTk2ZjpiaXNlY3QtdGlwCgoyMDEzLTA3LTIw
LTEzOjA3OjI3IGI4ZTdiN2IyNmEwMDgyYzQ2MWQxYmU1MWZiZTQxMWEwZDFjZjE5NmYgY29t
cGlsaW5nCjQyNiByZWFsICAxNzUyIHVzZXIgIDEzNyBzeXMgIDQ0Mi43NiUgY3B1IAl4ODZf
NjQtcmFuZGNvbmZpZy1jMDUtMDcxOAoKMjAxMy0wNy0yMC0xMzoxODowMyBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAzLjExLjAtcmMxLTAwMDMzLWdiOGU3YjdiCTkJMzMJNDYJNDcJNTEuCTUy
Li4uLi4uLi4uLi4JNTUgU1VDQ0VTUwoKQmlzZWN0aW5nOiA1IHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbNjNhMWQwMGQxNzlmNzk0MDEy
MDAxYzUwYWZhY2FkYzk4YjJjNGI4MV0gTWVyZ2UgYnJhbmNoICd4ODYvanVtcGxhYmVsJwpy
dW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hv
bWUvd2ZnL3RpcC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2
bS94ODZfNjQtcmFuZGNvbmZpZy1jMDUtMDcxOC90aXA6bWFzdGVyOjYzYTFkMDBkMTc5Zjc5
NDAxMjAwMWM1MGFmYWNhZGM5OGIyYzRiODE6YmlzZWN0LXRpcAoKMjAxMy0wNy0yMC0xMzoy
NzozNiA2M2ExZDAwZDE3OWY3OTQwMTIwMDFjNTBhZmFjYWRjOThiMmM0YjgxIGNvbXBpbGlu
ZwoyMDQgcmVhbCAgMTc1NSB1c2VyICAxMjkgc3lzICA5MjMuNjMlIGNwdSAJeDg2XzY0LXJh
bmRjb25maWctYzA1LTA3MTgKCjIwMTMtMDctMjAtMTM6MzE6MTMgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgMy4xMS4wLXJjMS0wMDA0MC1nNjNhMWQwMAkzCTEyIFRFU1QgRkFJTFVSRQobWzE7
MzVtSW5jcmVhc2luZyByZXBlYXQgY291bnQgZnJvbSA1NSB0byA3NRtbMG0KWyAgICAwLjE2
ODMzNl0gZGV2dG1wZnM6IGluaXRpYWxpemVkClsgICAgMC4yMDAwMjhdIGludDM6IDAwMDAg
WyMxXSBQUkVFTVBUIFNNUCBERUJVR19QQUdFQUxMT0MKWyAgICAwLjIwMDgxOF0gTW9kdWxl
cyBsaW5rZWQgaW46ClsgICAgMC4yMDEyNjBdIENQVTogMSBQSUQ6IDAgQ29tbTogc3dhcHBl
ci8xIE5vdCB0YWludGVkIDMuMTEuMC1yYzEtMDAwNDAtZzYzYTFkMDAgIzEyMApbICAgIDAu
MjAyMjM3XSB0YXNrOiBmZmZmODgwMDBkYTFiMDQwIHRpOiBmZmZmODgwMDBkYTFjMDAwIHRh
c2sudGk6IGZmZmY4ODAwMGRhMWMwMDAKWyAgICAwLjIwMzE2MF0gUklQOiAwMDEwOls8ZmZm
ZmZmZmY4MTEwOThhYz5dICBbPGZmZmZmZmZmODExMDk4YWM+XSB0dHd1X2RvX3dha2V1cCsw
eDI4LzB4MjI1ClsgICAgMC4yMDQwMDBdIFJTUDogMDAwMDpmZmZmODgwMDBkZDAzZjEwICBF
RkxBR1M6IDAwMDAwMDAyClsgICAgMC4yMDQwMDBdIFJBWDogMDAwMDAwMDAwMDAwMDAwMCBS
Qlg6IGZmZmY4ODAwMGRkMTI5NDAgUkNYOiBmZmZmZmZmZjgxNzY5YzQwClsgICAgMC4yMDQw
MDBdIFJEWDogMDAwMDAwMDAwMDAwMDAwMiBSU0k6IDAwMDAwMDAwMDAwMDAwMDAgUkRJOiAw
MDAwMDAwMDAwMDAwMDAxClsgICAgMC4yMDQwMDBdIFJCUDogZmZmZjg4MDAwZGQwM2YyOCBS
MDg6IGZmZmZmZmZmODE3NmE4YzAgUjA5OiAwMDAwMDAwMDAwMDAwMDAyClsgICAgMC4yMDQw
MDBdIFIxMDogZmZmZmZmZmY4MTBmZjQ2NCBSMTE6IGZmZmY4ODAwMGRkMTI5ZTggUjEyOiBm
ZmZmODgwMDBkYmM5MGMwClsgICAgMC4yMDQwMDBdIFIxMzogZmZmZjg4MDAwZGJjOTBjMCBS
MTQ6IGZmZmY4ODAwMGRhMWRmZDggUjE1OiBmZmZmODgwMDBkYTFkZmQ4ClsgICAgMC4yMDQw
MDBdIEZTOiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmODgwMDBkZDAwMDAwKDAw
MDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjIwNDAwMF0gQ1M6ICAwMDEwIERT
OiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzYgpbICAgIDAuMjA0MDAwXSBD
UjI6IDAwMDAwMDAwZmZmZmZmZmYgQ1IzOiAwMDAwMDAwMDAxYzc2MDAwIENSNDogMDAwMDAw
MDAwMDAwMDZlMApbICAgIDAuMjA0MDAwXSBTdGFjazoKWyAgICAwLjIwNDAwMF0gIGZmZmY4
ODAwMGRkMTI5NDAgZmZmZjg4MDAwZGJjOTBjMCBmZmZmODgwMDBkYTFkZmQ4IGZmZmY4ODAw
MGRkMDNmNDgKWyAgICAwLjIwNDAwMF0gIGZmZmZmZmZmODExMDllMGIgZmZmZjg4MDAwZGQx
Mjk0MCAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMGRkMDNmNjgKWyAgICAwLjIwNDAwMF0g
IGZmZmZmZmZmODExMDllN2UgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDEyOTQwIGZm
ZmY4ODAwMGRkMDNmOTgKWyAgICAwLjIwNDAwMF0gQ2FsbCBUcmFjZToKWyAgICAwLjIwNDAw
MF0gIDxJUlE+IApbICAgIDAuMjA0MDAwXSAgWzxmZmZmZmZmZjgxMTA5ZTBiPl0gdHR3dV9k
b19hY3RpdmF0ZS5jb25zdHByb3AuNTYrMHg2ZC8weDc5ClsgICAgMC4yMDQwMDBdICBbPGZm
ZmZmZmZmODExMDllN2U+XSBzY2hlZF90dHd1X3BlbmRpbmcrMHg2Ny8weDg0ClsgICAgMC4y
MDQwMDBdICBbPGZmZmZmZmZmODExMGM4MjU+XSBzY2hlZHVsZXJfaXBpKzB4MTVhLzB4MmIw
ClsgICAgMC4yMDQwMDBdICBbPGZmZmZmZmZmODEwNGRmODQ+XSBzbXBfcmVzY2hlZHVsZV9p
bnRlcnJ1cHQrMHgzOC8weDQxClsgICAgMC4yMDQwMDBdICBbPGZmZmZmZmZmODE3M2JmMWQ+
XSByZXNjaGVkdWxlX2ludGVycnVwdCsweDZkLzB4ODAKWyAgICAwLjIwNDAwMF0gIDxFT0k+
IApbICAgIDAuMjA0MDAwXSAgWzxmZmZmZmZmZjgxMGZmNDY0Pl0gPyBfX2F0b21pY19ub3Rp
Zmllcl9jYWxsX2NoYWluKzB4NS8weGMxClsgICAgMC4yMDQwMDBdICBbPGZmZmZmZmZmODEw
NWNjMDA+XSA/IG5hdGl2ZV9zYWZlX2hhbHQrMHhkLzB4MTYKWyAgICAwLjIwNDAwMF0gIFs8
ZmZmZmZmZmY4MTAxNWYxMD5dIGRlZmF1bHRfaWRsZSsweDE0Ny8weDI4MgpbICAgIDAuMjA0
MDAwXSAgWzxmZmZmZmZmZjgxMDE3MDI2Pl0gYXJjaF9jcHVfaWRsZSsweDNkLzB4NWQKWyAg
ICAwLjIwNDAwMF0gIFs8ZmZmZmZmZmY4MTEyN2Q0YT5dIGNwdV9pZGxlX2xvb3ArMHg0NmQv
MHg1ZGIKWyAgICAwLjIwNDAwMF0gIFs8ZmZmZmZmZmY4MTEyN2YzYz5dIGNwdV9zdGFydHVw
X2VudHJ5KzB4ODQvMHg4NApbICAgIDAuMjA0MDAwXSAgWzxmZmZmZmZmZjgxMDRmNGM4Pl0g
c3RhcnRfc2Vjb25kYXJ5KzB4M2M4LzB4M2Q1ClsgICAgMC4yMDQwMDBdIENvZGU6IDVjIDVk
IGMzIGU4IGI3IDBmIDYzIDAwIDU1IDQ4IGZmIDA1IGZmIDNjIDFkIDAxIDQ4IDg5IGU1IDQx
IDU1IDQ5IDg5IGY1IDQxIDU0IDUzIDQ4IDg5IGZiIGU4IDhkIGZlIGZmIGZmIDQ4IGZmIDA1
IGVkIDNjIDFkIDAxIGNjIDwxZj4gNDQgMDAgMDAgMzEgYzAgZWIgMGMgNDggZmYgMDUgZTUg
M2MgMWQgMDEgYjggMDEgMDAgMDAgMDAgNDggClsgICAgMC4yMDQwMDBdIFJJUCAgWzxmZmZm
ZmZmZjgxMTA5OGFjPl0gdHR3dV9kb193YWtldXArMHgyOC8weDIyNQpbICAgIDAuMjA0MDAw
XSAgUlNQIDxmZmZmODgwMDBkZDAzZjEwPgpbICAgIDAuMjA0MDAwXSAtLS1bIGVuZCB0cmFj
ZSBkMDgzZGZiMGRiODc1NTY2IF0tLS0KL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMDUt
MDcxOC82M2ExZDAwZDE3OWY3OTQwMTIwMDFjNTBhZmFjYWRjOThiMmM0YjgxL2RtZXNnLWt2
bS1uaG0tMzE5ODUtMjAxMzA3MjAxMjU4MjAtMy4xMC4wLXJjNi0wMDA5Mi1nNDY0MGEzZi0x
ODEKCkJpc2VjdGluZzogMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgMiBzdGVwcykKWzIzN2QxNTQ4NTQzMzEyZmNjOGM5OWQzMDJhYjY4ZmJmOGVmNmY5
N2ZdIHg4NjogRml4IG92ZXJyaWRlIG5ld19jcHVfZGF0YS54ODYgd2l0aCA0ODYKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dm
Zy90aXAvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2
XzY0LXJhbmRjb25maWctYzA1LTA3MTgvdGlwOm1hc3RlcjoyMzdkMTU0ODU0MzMxMmZjYzhj
OTlkMzAyYWI2OGZiZjhlZjZmOTdmOmJpc2VjdC10aXAKCjIwMTMtMDctMjAtMTM6MzI6MTcg
MjM3ZDE1NDg1NDMzMTJmY2M4Yzk5ZDMwMmFiNjhmYmY4ZWY2Zjk3ZiBjb21waWxpbmcKMjE4
IHJlYWwgIDE3MzEgdXNlciAgMTM0IHN5cyAgODU0LjQ0JSBjcHUgCXg4Nl82NC1yYW5kY29u
ZmlnLWMwNS0wNzE4CgoyMDEzLTA3LTIwLTEzOjM2OjEzIGRldGVjdGluZyBib290IHN0YXRl
IDMuMTAuMC1yYzQtMDAwMTAtZzIzN2QxNTQuCTEJNAk1CTcuCTgJOQkxNwkyNS4JMzMJMzkJ
NDYJNjgJNzUgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxIHJldmlzaW9uIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKWzUxYjJjMDdiMjIyNjFmMTkxODhkOWE5MDcx
OTQzZDYwYTA2NzQ4MWNdIHg4NjogTWFrZSBqdW1wX2xhYmVsIHVzZSBpbnQzLWJhc2VkIHBh
dGNoaW5nCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVy
ZS5zaCAvaG9tZS93ZmcvdGlwL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4t
cXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMwNS0wNzE4L3RpcDptYXN0ZXI6NTFiMmMw
N2IyMjI2MWYxOTE4OGQ5YTkwNzE5NDNkNjBhMDY3NDgxYzpiaXNlY3QtdGlwCgoyMDEzLTA3
LTIwLTEzOjQ0OjIwIDUxYjJjMDdiMjIyNjFmMTkxODhkOWE5MDcxOTQzZDYwYTA2NzQ4MWMg
Y29tcGlsaW5nCjM1NCByZWFsICAxNzY4IHVzZXIgIDEzNiBzeXMgIDUzNy4xMiUgY3B1IAl4
ODZfNjQtcmFuZGNvbmZpZy1jMDUtMDcxOAoKMjAxMy0wNy0yMC0xMzo1MjowOCBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAzLjExLjAtcmMxLTAwMDAyLWc1MWIyYzA3CTcJMzgJNjUgVEVTVCBG
QUlMVVJFChtbMTszNW1JbmNyZWFzaW5nIHJlcGVhdCBjb3VudCBmcm9tIDc1IHRvIDM0MBtb
MG0KWyAgICAwLjE2ODM0OF0gZGV2dG1wZnM6IGluaXRpYWxpemVkClsgICAgMC4xOTIwMjZd
IGludDM6IDAwMDAgWyMxXSBQUkVFTVBUIFNNUCBERUJVR19QQUdFQUxMT0MKWyAgICAwLjE5
MjY4Ml0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMC4xOTMwNDRdIENQVTogMSBQSUQ6IDAg
Q29tbTogc3dhcHBlci8xIE5vdCB0YWludGVkIDMuMTEuMC1yYzEtMDAwMDItZzUxYjJjMDcg
IzEyMgpbICAgIDAuMTkzODYxXSB0YXNrOiBmZmZmODgwMDBkYTFiMDQwIHRpOiBmZmZmODgw
MDBkYTFjMDAwIHRhc2sudGk6IGZmZmY4ODAwMGRhMWMwMDAKWyAgICAwLjE5NDY2OF0gUklQ
OiAwMDEwOls8ZmZmZmZmZmY4MTEwOTc1ZT5dICBbPGZmZmZmZmZmODExMDk3NWU+XSB0dHd1
X2RvX3dha2V1cCsweDI4LzB4MjI1ClsgICAgMC4xOTU1NjddIFJTUDogMDAwMDpmZmZmODgw
MDBkZDAzZjEwICBFRkxBR1M6IDAwMDAwMDAyClsgICAgMC4xOTYwMDBdIFJBWDogMDAwMDAw
MDAwMDAwMDAwMCBSQlg6IGZmZmY4ODAwMGRkMTI5NDAgUkNYOiBmZmZmZmZmZjgxNzY5YzQw
ClsgICAgMC4xOTYwMDBdIFJEWDogMDAwMDAwMDAwMDAwMDAwMiBSU0k6IDAwMDAwMDAwMDAw
MDAwMDAgUkRJOiAwMDAwMDAwMDAwMDAwMDAxClsgICAgMC4xOTYwMDBdIFJCUDogZmZmZjg4
MDAwZGQwM2YyOCBSMDg6IGZmZmZmZmZmODE3NmE4YzAgUjA5OiAwMDAwMDAwMDAwMDAwMDAy
ClsgICAgMC4xOTYwMDBdIFIxMDogZmZmZmZmZmY4MTBmZjMyMiBSMTE6IGZmZmY4ODAwMGRk
MTI5ZTggUjEyOiBmZmZmODgwMDBkYmM5MGMwClsgICAgMC4xOTYwMDBdIFIxMzogZmZmZjg4
MDAwZGJjOTBjMCBSMTQ6IGZmZmY4ODAwMGRhMWRmZDggUjE1OiBmZmZmODgwMDBkYTFkZmQ4
ClsgICAgMC4xOTYwMDBdIEZTOiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmODgw
MDBkZDAwMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjE5NjAwMF0g
Q1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzYgpbICAg
IDAuMTk2MDAwXSBDUjI6IDAwMDAwMDAwZmZmZmZmZmYgQ1IzOiAwMDAwMDAwMDAxYzc2MDAw
IENSNDogMDAwMDAwMDAwMDAwMDZlMApbICAgIDAuMTk2MDAwXSBTdGFjazoKWyAgICAwLjE5
NjAwMF0gIGZmZmY4ODAwMGRkMTI5NDAgZmZmZjg4MDAwZGJjOTBjMCBmZmZmODgwMDBkYTFk
ZmQ4IGZmZmY4ODAwMGRkMDNmNDgKWyAgICAwLjE5NjAwMF0gIGZmZmZmZmZmODExMDljYmQg
ZmZmZjg4MDAwZGQxMjk0MCAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMGRkMDNmNjgKWyAg
ICAwLjE5NjAwMF0gIGZmZmZmZmZmODExMDlkMzAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAw
MDAwMDEyOTQwIGZmZmY4ODAwMGRkMDNmOTgKWyAgICAwLjE5NjAwMF0gQ2FsbCBUcmFjZToK
WyAgICAwLjE5NjAwMF0gIDxJUlE+IApbICAgIDAuMTk2MDAwXSAgWzxmZmZmZmZmZjgxMTA5
Y2JkPl0gdHR3dV9kb19hY3RpdmF0ZS5jb25zdHByb3AuNTYrMHg2ZC8weDc5ClsgICAgMC4x
OTYwMDBdICBbPGZmZmZmZmZmODExMDlkMzA+XSBzY2hlZF90dHd1X3BlbmRpbmcrMHg2Ny8w
eDg0ClsgICAgMC4xOTYwMDBdICBbPGZmZmZmZmZmODExMGM2Y2U+XSBzY2hlZHVsZXJfaXBp
KzB4MTVhLzB4MmIwClsgICAgMC4xOTYwMDBdICBbPGZmZmZmZmZmODEwNGRmMGU+XSBzbXBf
cmVzY2hlZHVsZV9pbnRlcnJ1cHQrMHgzOC8weDQxClsgICAgMC4xOTYwMDBdICBbPGZmZmZm
ZmZmODE3M2I5ZGQ+XSByZXNjaGVkdWxlX2ludGVycnVwdCsweDZkLzB4ODAKWyAgICAwLjE5
NjAwMF0gIDxFT0k+IApbICAgIDAuMTk2MDAwXSAgWzxmZmZmZmZmZjgxMGZmMzIyPl0gPyBf
X2F0b21pY19ub3RpZmllcl9jYWxsX2NoYWluKzB4NS8weGMxClsgICAgMC4xOTYwMDBdICBb
PGZmZmZmZmZmODEwNWNiMDg+XSA/IG5hdGl2ZV9zYWZlX2hhbHQrMHhkLzB4MTYKWyAgICAw
LjE5NjAwMF0gIFs8ZmZmZmZmZmY4MTAxNWYwNT5dIGRlZmF1bHRfaWRsZSsweDE0Ny8weDI4
MgpbICAgIDAuMTk2MDAwXSAgWzxmZmZmZmZmZjgxMDE3MDE3Pl0gYXJjaF9jcHVfaWRsZSsw
eDNkLzB4NWQKWyAgICAwLjE5NjAwMF0gIFs8ZmZmZmZmZmY4MTEyN2I0OT5dIGNwdV9pZGxl
X2xvb3ArMHg0NmEvMHg1ZDgKWyAgICAwLjE5NjAwMF0gIFs8ZmZmZmZmZmY4MTEyN2QzYj5d
IGNwdV9zdGFydHVwX2VudHJ5KzB4ODQvMHg4NApbICAgIDAuMTk2MDAwXSAgWzxmZmZmZmZm
ZjgxMDRmNDMzPl0gc3RhcnRfc2Vjb25kYXJ5KzB4M2MwLzB4M2NiClsgICAgMC4xOTYwMDBd
IENvZGU6IDVjIDVkIGMzIGU4IGM1IDBiIDYzIDAwIDU1IDQ4IGZmIDA1IDRkIDNlIDFkIDAx
IDQ4IDg5IGU1IDQxIDU1IDQ5IDg5IGY1IDQxIDU0IDUzIDQ4IDg5IGZiIGU4IDhkIGZlIGZm
IGZmIDQ4IGZmIDA1IDNiIDNlIDFkIDAxIGNjIDwxZj4gNDQgMDAgMDAgMzEgYzAgZWIgMGMg
NDggZmYgMDUgMzMgM2UgMWQgMDEgYjggMDEgMDAgMDAgMDAgNDggClsgICAgMC4xOTYwMDBd
IFJJUCAgWzxmZmZmZmZmZjgxMTA5NzVlPl0gdHR3dV9kb193YWtldXArMHgyOC8weDIyNQpb
ICAgIDAuMTk2MDAwXSAgUlNQIDxmZmZmODgwMDBkZDAzZjEwPgpbICAgIDAuMTk2MDAwXSAt
LS1bIGVuZCB0cmFjZSAyMzExMDBjMWRkMDZhZTcxIF0tLS0KL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1jMDUtMDcxOC81MWIyYzA3YjIyMjYxZjE5MTg4ZDlhOTA3MTk0M2Q2MGEwNjc0
ODFjL2RtZXNnLWt2bS1uaG0tMzIyMTItMjAxMzA3MjAxMzE5NDMtMy4xMS4wLXJjMS0wMDE4
MC1nMWZhYWJmMi0xODEKCkJpc2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgMCBzdGVwcykKW2ZkNDM2M2ZmZjNkOTY3OTVkM2ZlYjFiM2Zi
NDhjZTU5MGYxODZiZGRdIHg4NjogSW50cm9kdWNlIGludDMgKGJyZWFrcG9pbnQpLWJhc2Vk
IGluc3RydWN0aW9uIHBhdGNoaW5nCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdGlwL29iai1iaXNlY3QKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMwNS0wNzE4L3Rp
cDptYXN0ZXI6ZmQ0MzYzZmZmM2Q5Njc5NWQzZmViMWIzZmI0OGNlNTkwZjE4NmJkZDpiaXNl
Y3QtdGlwCgoyMDEzLTA3LTIwLTEzOjUzOjQwIGZkNDM2M2ZmZjNkOTY3OTVkM2ZlYjFiM2Zi
NDhjZTU5MGYxODZiZGQgY29tcGlsaW5nCjg1MSByZWFsICAxNzQ0IHVzZXIgIDE0MCBzeXMg
IDIyMS4yMSUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1jMDUtMDcxOAoKMjAxMy0wNy0yMC0x
NDowODoyNSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAtcmMxLTAwMDAxLWdmZDQzNjNm
LgkyCTcJMTMJMTUJMjMJMzUJNjQJODYJOTgJMTA0CTEzOQkxNzcJMTg3CTIwOQkyNzYJMzIx
CTMzNC4JMzM2CTM0MCBTVUNDRVNTCgo1MWIyYzA3YjIyMjYxZjE5MTg4ZDlhOTA3MTk0M2Q2
MGEwNjc0ODFjIGlzIHRoZSBmaXJzdCBiYWQgY29tbWl0CmNvbW1pdCA1MWIyYzA3YjIyMjYx
ZjE5MTg4ZDlhOTA3MTk0M2Q2MGEwNjc0ODFjCkF1dGhvcjogSmlyaSBLb3NpbmEgPGprb3Np
bmFAc3VzZS5jej4KRGF0ZTogICBGcmkgSnVsIDEyIDExOjIyOjA5IDIwMTMgKzAyMDAKCiAg
ICB4ODY6IE1ha2UganVtcF9sYWJlbCB1c2UgaW50My1iYXNlZCBwYXRjaGluZwogICAgCiAg
ICBNYWtlIGp1bXAgbGFiZWxzIHVzZSB0ZXh0X3Bva2VfYnAoKSBmb3IgdGV4dCBwYXRjaGlu
ZyBpbnN0ZWFkIG9mCiAgICB0ZXh0X3Bva2Vfc21wKCksIGF2b2lkaW5nIHRoZSBuZWVkIGZv
ciBzdG9wX21hY2hpbmUoKS4KICAgIAogICAgUmV2aWV3ZWQtYnk6IFN0ZXZlbiBSb3N0ZWR0
IDxyb3N0ZWR0QGdvb2RtaXMub3JnPgogICAgUmV2aWV3ZWQtYnk6IE1hc2FtaSBIaXJhbWF0
c3UgPG1hc2FtaS5oaXJhbWF0c3UucHRAaGl0YWNoaS5jb20+CiAgICBTaWduZWQtb2ZmLWJ5
OiBKaXJpIEtvc2luYSA8amtvc2luYUBzdXNlLmN6PgogICAgTGluazogaHR0cDovL2xrbWwu
a2VybmVsLm9yZy9yL2FscGluZS5MTlguMi4wMC4xMzA3MTIxMTIwMjUwLjI5Nzg4QHBvYm94
LnN1c2UuY3oKICAgIFNpZ25lZC1vZmYtYnk6IEguIFBldGVyIEFudmluIDxocGFAbGludXgu
aW50ZWwuY29tPgoKOjA0MDAwMCAwNDAwMDAgMDAxMGMwOWUzODcwODBkYzk4NzY1ZGExN2I0
MTQ0ZTFlMzRlNDE1YiBjZWVlMGRhZDllNjQ3NjIzNTM4YjkwMGU5NzVkNzg0YmY4ZDUyNDNk
IE0JYXJjaApiaXNlY3QgcnVuIHN1Y2Nlc3MKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMwNS0wNzE4L3RpcDptYXN0ZXI6ZmQ0MzYzZmZm
M2Q5Njc5NWQzZmViMWIzZmI0OGNlNTkwZjE4NmJkZDpiaXNlY3QtdGlwCgoyMDEzLTA3LTIw
LTE0OjE4OjU3IGZkNDM2M2ZmZjNkOTY3OTVkM2ZlYjFiM2ZiNDhjZTU5MGYxODZiZGQgcmV1
c2UgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMDUtMDcxOC9mZDQzNjNmZmYzZDk2Nzk1
ZDNmZWIxYjNmYjQ4Y2U1OTBmMTg2YmRkL3ZtbGludXotMy4xMS4wLXJjMS0wMDAwMS1nZmQ0
MzYzZgoKMjAxMy0wNy0yMC0xNDoxODo1NyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTM2NQk0
MjAJNDQ2CTUxMwk2MDgJNjEwCTc2Nwk5MzcJOTc2CTEwMTgJMTAyMCBTVUNDRVNTCgpscyAt
YSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzA1LTA3
MTgvdGlwOm1hc3RlcjowNGJmNTc2MDZiMjhiZmEyODNiZDExOGU0ZWEwMzIxNTFiMDJmNmRm
OmJpc2VjdC10aXAKIFRFU1QgRkFJTFVSRQpbICAgIDAuMjAwMzM4XSBkZXZ0bXBmczogaW5p
dGlhbGl6ZWQKWyAgICAwLjIyMDAyMl0gaW50MzogMDAwMCBbIzFdIFBSRUVNUFQgU01QIERF
QlVHX1BBR0VBTExPQwpbICAgIDAuMjIwODA2XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAw
LjIyMTIzOV0gQ1BVOiAxIFBJRDogMCBDb21tOiBzd2FwcGVyLzEgTm90IHRhaW50ZWQgMy4x
MS4wLXJjMS0wMTQyOS1nMDRiZjU3NiAjOApbICAgIDAuMjIyMjI1XSB0YXNrOiBmZmZmODgw
MDBkYTFiMDQwIHRpOiBmZmZmODgwMDBkYTFjMDAwIHRhc2sudGk6IGZmZmY4ODAwMGRhMWMw
MDAKWyAgICAwLjIyMzIzOV0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MTEwOThjYz5dICBbPGZm
ZmZmZmZmODExMDk4Y2M+XSB0dHd1X2RvX3dha2V1cCsweDI4LzB4MjI1ClsgICAgMC4yMjQw
MDBdIFJTUDogMDAwMDpmZmZmODgwMDBkZDAzZjEwICBFRkxBR1M6IDAwMDAwMDA2ClsgICAg
MC4yMjQwMDBdIFJBWDogMDAwMDAwMDAwMDAwMDAwMCBSQlg6IGZmZmY4ODAwMGRkMTI5NDAg
UkNYOiBmZmZmZmZmZjgxNzY5YzQwClsgICAgMC4yMjQwMDBdIFJEWDogMDAwMDAwMDAwMDAw
MDAwMiBSU0k6IDAwMDAwMDAwMDAwMDAwMDAgUkRJOiAwMDAwMDAwMDAwMDAwMDAxClsgICAg
MC4yMjQwMDBdIFJCUDogZmZmZjg4MDAwZGQwM2YyOCBSMDg6IGZmZmZmZmZmODE3NmE4YzAg
UjA5OiAwMDAwMDAwMDAwMDAwMDAyClsgICAgMC4yMjQwMDBdIFIxMDogZmZmZmZmZmY4MTBm
ZjQ4NCBSMTE6IGZmZmY4ODAwMGRkMTI5ZTggUjEyOiBmZmZmODgwMDBkYmM5MGMwClsgICAg
MC4yMjQwMDBdIFIxMzogZmZmZjg4MDAwZGJjOTBjMCBSMTQ6IGZmZmY4ODAwMGRhMWRmZDgg
UjE1OiBmZmZmODgwMDBkYTFkZmQ4ClsgICAgMC4yMjQwMDBdIEZTOiAgMDAwMDAwMDAwMDAw
MDAwMCgwMDAwKSBHUzpmZmZmODgwMDBkZDAwMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAw
MDAwMDAKWyAgICAwLjIyNDAwMF0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDog
MDAwMDAwMDA4MDA1MDAzYgpbICAgIDAuMjI0MDAwXSBDUjI6IDAwMDAwMDAwZmZmZmZmZmYg
Q1IzOiAwMDAwMDAwMDAxYzg4MDAwIENSNDogMDAwMDAwMDAwMDAwMDZlMApbICAgIDAuMjI0
MDAwXSBTdGFjazoKWyAgICAwLjIyNDAwMF0gIGZmZmY4ODAwMGRkMTI5NDAgZmZmZjg4MDAw
ZGJjOTBjMCBmZmZmODgwMDBkYTFkZmQ4IGZmZmY4ODAwMGRkMDNmNDgKWyAgICAwLjIyNDAw
MF0gIGZmZmZmZmZmODExMDllMmIgZmZmZjg4MDAwZGQxMjk0MCAwMDAwMDAwMDAwMDAwMDAw
IGZmZmY4ODAwMGRkMDNmNjgKWyAgICAwLjIyNDAwMF0gIGZmZmZmZmZmODExMDllOWUgMDAw
MDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDEyOTQwIGZmZmY4ODAwMGRkMDNmOTgKWyAgICAw
LjIyNDAwMF0gQ2FsbCBUcmFjZToKWyAgICAwLjIyNDAwMF0gIDxJUlE+IApbICAgIDAuMjI0
MDAwXSAgWzxmZmZmZmZmZjgxMTA5ZTJiPl0gdHR3dV9kb19hY3RpdmF0ZS5jb25zdHByb3Au
NTYrMHg2ZC8weDc5ClsgICAgMC4yMjQwMDBdICBbPGZmZmZmZmZmODExMDllOWU+XSBzY2hl
ZF90dHd1X3BlbmRpbmcrMHg2Ny8weDg0ClsgICAgMC4yMjQwMDBdICBbPGZmZmZmZmZmODEx
MGM4NDU+XSBzY2hlZHVsZXJfaXBpKzB4MTVhLzB4MmIwClsgICAgMC4yMjQwMDBdICBbPGZm
ZmZmZmZmODEwNGRmYjQ+XSBzbXBfcmVzY2hlZHVsZV9pbnRlcnJ1cHQrMHgzOC8weDQxClsg
ICAgMC4yMjQwMDBdICBbPGZmZmZmZmZmODE3M2JmNWQ+XSByZXNjaGVkdWxlX2ludGVycnVw
dCsweDZkLzB4ODAKWyAgICAwLjIyNDAwMF0gIDxFT0k+IApbICAgIDAuMjI0MDAwXSAgWzxm
ZmZmZmZmZjgxMGZmNDg0Pl0gPyBfX2F0b21pY19ub3RpZmllcl9jYWxsX2NoYWluKzB4NS8w
eGMxClsgICAgMC4yMjQwMDBdICBbPGZmZmZmZmZmODEwNWNjMzA+XSA/IG5hdGl2ZV9zYWZl
X2hhbHQrMHhkLzB4MTYKWyAgICAwLjIyNDAwMF0gIFs8ZmZmZmZmZmY4MTAxNWYxMD5dIGRl
ZmF1bHRfaWRsZSsweDE0Ny8weDI4MgpbICAgIDAuMjI0MDAwXSAgWzxmZmZmZmZmZjgxMDE3
MDI2Pl0gYXJjaF9jcHVfaWRsZSsweDNkLzB4NWQKWyAgICAwLjIyNDAwMF0gIFs8ZmZmZmZm
ZmY4MTEyN2Q2YT5dIGNwdV9pZGxlX2xvb3ArMHg0NmQvMHg1ZGIKWyAgICAwLjIyNDAwMF0g
IFs8ZmZmZmZmZmY4MTEyN2Y1Yz5dIGNwdV9zdGFydHVwX2VudHJ5KzB4ODQvMHg4NApbICAg
IDAuMjI0MDAwXSAgWzxmZmZmZmZmZjgxMDRmNGY4Pl0gc3RhcnRfc2Vjb25kYXJ5KzB4M2M4
LzB4M2Q1ClsgICAgMC4yMjQwMDBdIENvZGU6IDVjIDVkIGMzIGU4IGQ3IDBmIDYzIDAwIDU1
IDQ4IGZmIDA1IDFmIDVkIDFlIDAxIDQ4IDg5IGU1IDQxIDU1IDQ5IDg5IGY1IDQxIDU0IDUz
IDQ4IDg5IGZiIGU4IDhkIGZlIGZmIGZmIDQ4IGZmIDA1IDBkIDVkIDFlIDAxIGNjIDwxZj4g
NDQgMDAgMDAgMzEgYzAgZWIgMGMgNDggZmYgMDUgMDUgNWQgMWUgMDEgYjggMDEgMDAgMDAg
MDAgNDggClsgICAgMC4yMjQwMDBdIFJJUCAgWzxmZmZmZmZmZjgxMTA5OGNjPl0gdHR3dV9k
b193YWtldXArMHgyOC8weDIyNQpbICAgIDAuMjI0MDAwXSAgUlNQIDxmZmZmODgwMDBkZDAz
ZjEwPgpbICAgIDAuMjI0MDAwXSAtLS1bIGVuZCB0cmFjZSBhYTNlYjliMTZmNTgxYTEzIF0t
LS0KL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMDUtMDcxOC8wNGJmNTc2MDZiMjhiZmEy
ODNiZDExOGU0ZWEwMzIxNTFiMDJmNmRmL2RtZXNnLWt2bS1rYnVpbGQtMzQ3NDEtMjAxMzA3
MjAwOTUzMDgtMy4xMS4wLXJjMS0wMTQyOS1nMDRiZjU3Ni04Ci9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctYzA1LTA3MTgvMDRiZjU3NjA2YjI4YmZhMjgzYmQxMThlNGVhMDMyMTUxYjAy
ZjZkZi9kbWVzZy1rdm0ta2J1aWxkLTQwMjE1LTIwMTMwNzIwMTAwNjI3LTMuMTEuMC1yYzEt
MDAwMjItZzI0OTI0YTItMTE2Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzA1LTA3MTgv
MDRiZjU3NjA2YjI4YmZhMjgzYmQxMThlNGVhMDMyMTUxYjAyZjZkZi9kbWVzZy1rdm0ta2J1
aWxkLTQxOTQ5LTIwMTMwNzIwMTAyNjMwLTMuMTEuMC1yYzEtMDAwMjItZzI0OTI0YTItMTMw
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzA1LTA3MTgvMDRiZjU3NjA2YjI4YmZhMjgz
YmQxMThlNGVhMDMyMTUxYjAyZjZkZi9kbWVzZy1rdm0ta2J1aWxkLTQyMTUwLTIwMTMwNzIw
MDk0OTA2LTMuMTEuMC1yYzEtMDE0MjktZzA0YmY1NzYtOAova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWMwNS0wNzE4LzA0YmY1NzYwNmIyOGJmYTI4M2JkMTE4ZTRlYTAzMjE1MWIwMmY2
ZGYvZG1lc2cta3ZtLWtidWlsZC00Mjk4NS0yMDEzMDcyMDEwMDUzOS0zLjExLjAtcmMxLTAw
MTYyLWcyZjBhOWFmLTczCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzA1LTA3MTgvMDRi
ZjU3NjA2YjI4YmZhMjgzYmQxMThlNGVhMDMyMTUxYjAyZjZkZi9kbWVzZy1rdm0ta2J1aWxk
LTQ1MDM5LTIwMTMwNzIwMTAwNDQ1LTMuMTEuMC1yYzEtMDAxNzAtZzY0NmU4MzEtNQova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWMwNS0wNzE4LzA0YmY1NzYwNmIyOGJmYTI4M2JkMTE4
ZTRlYTAzMjE1MWIwMmY2ZGYvZG1lc2cta3ZtLWtidWlsZC00NTkzOS0yMDEzMDcyMDEwMjQz
NS0zLjExLjAtcmMxLTAwMDE5LWdjMGQxNWNjLTE4Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctYzA1LTA3MTgvMDRiZjU3NjA2YjI4YmZhMjgzYmQxMThlNGVhMDMyMTUxYjAyZjZkZi9k
bWVzZy1rdm0ta2J1aWxkLTUwMjE1LTIwMTMwNzIwMTAxMDM1LTMuMTEuMC1yYzEtMDE0Mjkt
ZzA0YmY1NzYtOAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMwNS0wNzE4LzA0YmY1NzYw
NmIyOGJmYTI4M2JkMTE4ZTRlYTAzMjE1MWIwMmY2ZGYvZG1lc2cta3ZtLWtidWlsZC02NDEw
LTIwMTMwNzIwMTAxMzAxLTMuMTEuMC1yYzEtMDAxODgtZzNmNDAyOWYtOQova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWMwNS0wNzE4LzA0YmY1NzYwNmIyOGJmYTI4M2JkMTE4ZTRlYTAz
MjE1MWIwMmY2ZGYvZG1lc2cta3ZtLWtidWlsZC05MTYzLTIwMTMwNzIwMTAxMjA0LTMuMTEu
MC1yYzEtMDE0MjktZzA0YmY1NzYtOAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMwNS0w
NzE4LzA0YmY1NzYwNmIyOGJmYTI4M2JkMTE4ZTRlYTAzMjE1MWIwMmY2ZGYvZG1lc2cta3Zt
LXNuYi0xNjMxMy0yMDEzMDcxODIxMzQzNS0zLjExLjAtcmMxLTAwMDI2LWcwZWM1ZjNhLTU4
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzA1LTA3MTgvMDRiZjU3NjA2YjI4YmZhMjgz
YmQxMThlNGVhMDMyMTUxYjAyZjZkZi9kbWVzZy1rdm0tc25iLTc1ODQtMjAxMzA3MTgyMTM0
MzUtMy4xMS4wLXJjMS0wMDAyNi1nMGVjNWYzYS01NgoKW2RldGFjaGVkIEhFQUQgYTFmYWIz
Y10gUmV2ZXJ0ICJ4ODY6IE1ha2UganVtcF9sYWJlbCB1c2UgaW50My1iYXNlZCBwYXRjaGlu
ZyIKIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDE0IGRlbGV0aW9ucygtKQps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzA1
LTA3MTgvdGlwOm1hc3RlcjphMWZhYjNjY2U5NzMwZDNlYzhkNWNhZjJlNmFjYjBhMGZmOGRk
MjQwOmJpc2VjdC10aXAKCjIwMTMtMDctMjAtMTQ6MjU6MDQgYTFmYWIzY2NlOTczMGQzZWM4
ZDVjYWYyZTZhY2IwYTBmZjhkZDI0MCBjb21waWxpbmcKCjIwMTMtMDctMjAtMTQ6MzE6NDkg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLXJjMS0wMTQzMC1nYTFmYWIzYy4JMTUJNTkJ
MTE4CTIwNAkzMDYJMzk2CTQ2Mwk1NDgJNjI5CTcyNAk4MDgJODk0CTk3NgkxMDA2CTEwMjAg
U1VDQ0VTUwoKCj09PT09PT09PSB1cHN0cmVhbSA9PT09PT09PT0KRmV0Y2hpbmcgbGludXMK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMw
NS0wNzE4L3RpcDptYXN0ZXI6ZDQ3MWNlNTNiMWZhYjYwMTEwZTRlOWY2NDdhMzQ1Y2VhMzE3
NTJkZTpiaXNlY3QtdGlwCgoyMDEzLTA3LTIwLTE0OjQwOjA1IGQ0NzFjZTUzYjFmYWI2MDEx
MGU0ZTlmNjQ3YTM0NWNlYTMxNzUyZGUgY29tcGlsaW5nCgoyMDEzLTA3LTIwLTE0OjQ3OjA5
IGRldGVjdGluZyBib290IHN0YXRlIDMuMTEuMC1yYzEtMDAyMDItZ2Q0NzFjZTUJMwkxNwk0
Mgk3NwkxMzUJMjExCTMzNAk0NjkJNTcwCTY1OAk3NjIJODY1CTk1NAk5OTMJMTAwNC4uLi4J
MTAwNS4uCTEwMDYJMTAxMQkxMDE0Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLhtb
MTszNW1hZGRfdG9fcnVuX3F1ZXVlIDYbWzBtCgkxMDE1CTEwMjAgU1VDQ0VTUwoKCj09PT09
PT09PSBsaW51eC1uZXh0ID09PT09PT09PQpGZXRjaGluZyBuZXh0CmxzIC1hIC9rZXJuZWwt
dGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMDUtMDcxOC90aXA6bWFz
dGVyOmMxZjYzMWI5YTY4MjUxMDA3YTYzNTMwNDFhZTkwZjlmN2RjYTc3MWM6YmlzZWN0LXRp
cAogVEVTVCBGQUlMVVJFClsgICAgMC4xODA0NDFdIGRldnRtcGZzOiBpbml0aWFsaXplZApb
ICAgIDAuMTk2MDI1XSBpbnQzOiAwMDAwIFsjMV0gUFJFRU1QVCBTTVAgREVCVUdfUEFHRUFM
TE9DClsgICAgMC4xOTY5MjJdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDAuMTk3NDEzXSBD
UFU6IDEgUElEOiAwIENvbW06IHN3YXBwZXIvMSBOb3QgdGFpbnRlZCAzLjExLjAtcmMxLW5l
eHQtMjAxMzA3MTkgIzcyClsgICAgMC4xOTg0OTNdIHRhc2s6IGZmZmY4ODAwMGRhMWIwNDAg
dGk6IGZmZmY4ODAwMGRhMWMwMDAgdGFzay50aTogZmZmZjg4MDAwZGExYzAwMApbICAgIDAu
MTk5NTQzXSBSSVA6IDAwMTA6WzxmZmZmZmZmZjgxMTAzYWIxPl0gIFs8ZmZmZmZmZmY4MTEw
M2FiMT5dIHR0d3VfZG9fd2FrZXVwKzB4MjgvMHgyMjUKWyAgICAwLjIwMDAwMF0gUlNQOiAw
MDAwOmZmZmY4ODAwMGRkMDNmMTAgIEVGTEFHUzogMDAwMDAwMDIKWyAgICAwLjIwMDAwMF0g
UkFYOiAwMDAwMDAwMDAwMDAwMDAwIFJCWDogZmZmZjg4MDAwZGQxMjkwMCBSQ1g6IGZmZmZm
ZmZmODE3NmE0ZjAKWyAgICAwLjIwMDAwMF0gUkRYOiAwMDAwMDAwMDAwMDAwMDAyIFJTSTog
MDAwMDAwMDAwMDAwMDAwMCBSREk6IDAwMDAwMDAwMDAwMDAwMDEKWyAgICAwLjIwMDAwMF0g
UkJQOiBmZmZmODgwMDBkZDAzZjI4IFIwODogZmZmZmZmZmY4MTc2YjE3MCBSMDk6IDAwMDAw
MDAwMDAwMDAwMDIKWyAgICAwLjIwMDAwMF0gUjEwOiBmZmZmZmZmZjgxMGY5NjY5IFIxMTog
ZmZmZjg4MDAwZGQxMjlhOCBSMTI6IGZmZmY4ODAwMGRiYzkwYzAKWyAgICAwLjIwMDAwMF0g
UjEzOiBmZmZmODgwMDBkYmM5MGMwIFIxNDogZmZmZjg4MDAwZGExZGZkOCBSMTU6IGZmZmY4
ODAwMGRhMWRmZDgKWyAgICAwLjIwMDAwMF0gRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDAp
IEdTOmZmZmY4ODAwMGRkMDAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAg
IDAuMjAwMDAwXSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgw
MDUwMDNiClsgICAgMC4yMDAwMDBdIENSMjogMDAwMDAwMDBmZmZmZmZmZiBDUjM6IDAwMDAw
MDAwMDFjOGEwMDAgQ1I0OiAwMDAwMDAwMDAwMDAwNmUwClsgICAgMC4yMDAwMDBdIFN0YWNr
OgpbICAgIDAuMjAwMDAwXSAgZmZmZjg4MDAwZGQxMjkwMCBmZmZmODgwMDBkYmM5MGMwIGZm
ZmY4ODAwMGRhMWRmZDggZmZmZjg4MDAwZGQwM2Y0OApbICAgIDAuMjAwMDAwXSAgZmZmZmZm
ZmY4MTEwNDAxMCBmZmZmODgwMDBkZDEyOTAwIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAw
ZGQwM2Y2OApbICAgIDAuMjAwMDAwXSAgZmZmZmZmZmY4MTEwNDA4MyAwMDAwMDAwMDAwMDAw
MDAwIDAwMDAwMDAwMDAwMTI5MDAgZmZmZjg4MDAwZGQwM2Y5OApbICAgIDAuMjAwMDAwXSBD
YWxsIFRyYWNlOgpbICAgIDAuMjAwMDAwXSAgPElSUT4gClsgICAgMC4yMDAwMDBdICBbPGZm
ZmZmZmZmODExMDQwMTA+XSB0dHd1X2RvX2FjdGl2YXRlLmNvbnN0cHJvcC41NisweDZkLzB4
NzkKWyAgICAwLjIwMDAwMF0gIFs8ZmZmZmZmZmY4MTEwNDA4Mz5dIHNjaGVkX3R0d3VfcGVu
ZGluZysweDY3LzB4ODQKWyAgICAwLjIwMDAwMF0gIFs8ZmZmZmZmZmY4MTEwNmEyYT5dIHNj
aGVkdWxlcl9pcGkrMHgxNWEvMHgyYjAKWyAgICAwLjIwMDAwMF0gIFs8ZmZmZmZmZmY4MTA0
ZGZiND5dIHNtcF9yZXNjaGVkdWxlX2ludGVycnVwdCsweDM4LzB4NDEKWyAgICAwLjIwMDAw
MF0gIFs8ZmZmZmZmZmY4MTczZDI1ZD5dIHJlc2NoZWR1bGVfaW50ZXJydXB0KzB4NmQvMHg4
MApbICAgIDAuMjAwMDAwXSAgPEVPST4gClsgICAgMC4yMDAwMDBdICBbPGZmZmZmZmZmODEw
Zjk2Njk+XSA/IF9fYXRvbWljX25vdGlmaWVyX2NhbGxfY2hhaW4rMHg1LzB4YzEKWyAgICAw
LjIwMDAwMF0gIFs8ZmZmZmZmZmY4MTA1Y2MzMD5dID8gbmF0aXZlX3NhZmVfaGFsdCsweGQv
MHgxNgpbICAgIDAuMjAwMDAwXSAgWzxmZmZmZmZmZjgxMDE1ZjEwPl0gZGVmYXVsdF9pZGxl
KzB4MTQ3LzB4MjgyClsgICAgMC4yMDAwMDBdICBbPGZmZmZmZmZmODEwMTcwMjY+XSBhcmNo
X2NwdV9pZGxlKzB4M2QvMHg1ZApbICAgIDAuMjAwMDAwXSAgWzxmZmZmZmZmZjgxMTI3ZTVl
Pl0gY3B1X2lkbGVfbG9vcCsweDQ2ZC8weDVkYgpbICAgIDAuMjAwMDAwXSAgWzxmZmZmZmZm
ZjgxMTI4MDUwPl0gY3B1X3N0YXJ0dXBfZW50cnkrMHg4NC8weDg0ClsgICAgMC4yMDAwMDBd
ICBbPGZmZmZmZmZmODEwNGY0Zjg+XSBzdGFydF9zZWNvbmRhcnkrMHgzYzgvMHgzZDUKWyAg
ICAwLjIwMDAwMF0gQ29kZTogNWMgNWQgYzMgZTggZjIgODAgNjMgMDAgNTUgNDggZmYgMDUg
YmEgYzggMWMgMDEgNDggODkgZTUgNDEgNTUgNDkgODkgZjUgNDEgNTQgNTMgNDggODkgZmIg
ZTggOGQgZmUgZmYgZmYgNDggZmYgMDUgYTggYzggMWMgMDEgY2MgPDFmPiA0NCAwMCAwMCAz
MSBjMCBlYiAwYyA0OCBmZiAwNSBhMCBjOCAxYyAwMSBiOCAwMSAwMCAwMCAwMCA0OCAKWyAg
ICAwLjIwMDAwMF0gUklQICBbPGZmZmZmZmZmODExMDNhYjE+XSB0dHd1X2RvX3dha2V1cCsw
eDI4LzB4MjI1ClsgICAgMC4yMDAwMDBdICBSU1AgPGZmZmY4ODAwMGRkMDNmMTA+ClsgICAg
MC4yMDAwMDBdIC0tLVsgZW5kIHRyYWNlIDNjYmM2YmMwMzVkYmQ3ZGQgXS0tLQova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWMwNS0wNzE4L2MxZjYzMWI5YTY4MjUxMDA3YTYzNTMwNDFh
ZTkwZjlmN2RjYTc3MWMvZG1lc2cta3ZtLWlubi0xOTI2OC0yMDEzMDcxOTIyNDUxNi0zLjEx
LjAtcmMxLW5leHQtMjAxMzA3MTktNzIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMDUt
MDcxOC9jMWY2MzFiOWE2ODI1MTAwN2E2MzUzMDQxYWU5MGY5ZjdkY2E3NzFjL2RtZXNnLWt2
bS1pbm4tMjc5NjctMjAxMzA3MTkyMjQ4MTYtMy4xMS4wLXJjMS1uZXh0LTIwMTMwNzE5LTcy
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzA1LTA3MTgvYzFmNjMxYjlhNjgyNTEwMDdh
NjM1MzA0MWFlOTBmOWY3ZGNhNzcxYy9kbWVzZy1rdm0ta2J1aWxkLTQyOTg1LTIwMTMwNzE5
MjAzMzA2LTMuMTEuMC1yYzEtbmV4dC0yMDEzMDcxOS03Mgova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWMwNS0wNzE4L2MxZjYzMWI5YTY4MjUxMDA3YTYzNTMwNDFhZTkwZjlmN2RjYTc3
MWMvZG1lc2cta3ZtLWtidWlsZC00Njc3OC0yMDEzMDcxOTIwNDUwOS0zLjExLjAtcmMxLTAw
MjA3LWdmNDZiNzcyLTE1CgoKPT09PT09PT09IHRpcC9tYXN0ZXIgPT09PT09PT09CkZldGNo
aW5nIHRpcApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRj
b25maWctYzA1LTA3MTgvdGlwOm1hc3Rlcjo1YTY5OTg1MzkyZTYwYWJjYWViMjI0M2ZhZjA0
MDQ4ODMzMGE2YWU4OmJpc2VjdC10aXAKCjIwMTMtMDctMjAtMTc6MzE6NDcgNWE2OTk4NTM5
MmU2MGFiY2FlYjIyNDNmYWYwNDA0ODgzMzBhNmFlOCByZXVzZSAva2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWMwNS0wNzE4LzVhNjk5ODUzOTJlNjBhYmNhZWIyMjQzZmFmMDQwNDg4MzMw
YTZhZTgvdm1saW51ei0zLjExLjAtcmMxLTAxNjM4LWc1YTY5OTg1CgoyMDEzLTA3LTIwLTE3
OjMxOjQ3IGRldGVjdGluZyBib290IHN0YXRlIC4JMTIJMTcuLgkyMiBURVNUIEZBSUxVUkUK
WyAgICAwLjE5MjA0N10gZGV2dG1wZnM6IGluaXRpYWxpemVkClsgICAgMC4yMTIwMjZdIGlu
dDM6IDAwMDAgWyMxXSBQUkVFTVBUIFNNUCBERUJVR19QQUdFQUxMT0MKWyAgICAwLjIxMjg3
Ml0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMC4yMTMzMTddIENQVTogMSBQSUQ6IDAgQ29t
bTogc3dhcHBlci8xIE5vdCB0YWludGVkIDMuMTEuMC1yYzEtMDE2MzgtZzVhNjk5ODUgIzc0
ClsgICAgMC4yMTQzMThdIHRhc2s6IGZmZmY4ODAwMGRhMWIwNDAgdGk6IGZmZmY4ODAwMGRh
MWMwMDAgdGFzay50aTogZmZmZjg4MDAwZGExYzAwMApbICAgIDAuMjE1MzAxXSBSSVA6IDAw
MTA6WzxmZmZmZmZmZjgxMTA5YTZjPl0gIFs8ZmZmZmZmZmY4MTEwOWE2Yz5dIHR0d3VfZG9f
d2FrZXVwKzB4MjgvMHgyMjUKWyAgICAwLjIxNjAwMF0gUlNQOiAwMDAwOmZmZmY4ODAwMGRk
MDNmMTAgIEVGTEFHUzogMDAwMDAwMDYKWyAgICAwLjIxNjAwMF0gUkFYOiAwMDAwMDAwMDAw
MDAwMDAwIFJCWDogZmZmZjg4MDAwZGQxMjk0MCBSQ1g6IGZmZmZmZmZmODE3NjljYzAKWyAg
ICAwLjIxNjAwMF0gUkRYOiAwMDAwMDAwMDAwMDAwMDAyIFJTSTogMDAwMDAwMDAwMDAwMDAw
MCBSREk6IDAwMDAwMDAwMDAwMDAwMDEKWyAgICAwLjIxNjAwMF0gUkJQOiBmZmZmODgwMDBk
ZDAzZjI4IFIwODogZmZmZmZmZmY4MTc2YTk0MCBSMDk6IDAwMDAwMDAwMDAwMDAwMDIKWyAg
ICAwLjIxNjAwMF0gUjEwOiBmZmZmZmZmZjgxMGZmNjI0IFIxMTogZmZmZjg4MDAwZGQxMjll
OCBSMTI6IGZmZmY4ODAwMGRiYzkwYzAKWyAgICAwLjIxNjAwMF0gUjEzOiBmZmZmODgwMDBk
YmM5MGMwIFIxNDogZmZmZjg4MDAwZGExZGZkOCBSMTU6IGZmZmY4ODAwMGRhMWRmZDgKWyAg
ICAwLjIxNjAwMF0gRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmY4ODAwMGRk
MDAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAgIDAuMjE2MDAwXSBDUzog
IDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDNiClsgICAgMC4y
MTYwMDBdIENSMjogMDAwMDAwMDBmZmZmZmZmZiBDUjM6IDAwMDAwMDAwMDFjODgwMDAgQ1I0
OiAwMDAwMDAwMDAwMDAwNmUwClsgICAgMC4yMTYwMDBdIFN0YWNrOgpbICAgIDAuMjE2MDAw
XSAgZmZmZjg4MDAwZGQxMjk0MCBmZmZmODgwMDBkYmM5MGMwIGZmZmY4ODAwMGRhMWRmZDgg
ZmZmZjg4MDAwZGQwM2Y0OApbICAgIDAuMjE2MDAwXSAgZmZmZmZmZmY4MTEwOWZjYiBmZmZm
ODgwMDBkZDEyOTQwIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAwZGQwM2Y2OApbICAgIDAu
MjE2MDAwXSAgZmZmZmZmZmY4MTEwYTAzZSAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAw
MTI5NDAgZmZmZjg4MDAwZGQwM2Y5OApbICAgIDAuMjE2MDAwXSBDYWxsIFRyYWNlOgpbICAg
IDAuMjE2MDAwXSAgPElSUT4gClsgICAgMC4yMTYwMDBdICBbPGZmZmZmZmZmODExMDlmY2I+
XSB0dHd1X2RvX2FjdGl2YXRlLmNvbnN0cHJvcC41NisweDZkLzB4NzkKWyAgICAwLjIxNjAw
MF0gIFs8ZmZmZmZmZmY4MTEwYTAzZT5dIHNjaGVkX3R0d3VfcGVuZGluZysweDY3LzB4ODQK
WyAgICAwLjIxNjAwMF0gIFs8ZmZmZmZmZmY4MTEwYzllNT5dIHNjaGVkdWxlcl9pcGkrMHgx
NWEvMHgyYjAKWyAgICAwLjIxNjAwMF0gIFs8ZmZmZmZmZmY4MTA0ZTE0ND5dIHNtcF9yZXNj
aGVkdWxlX2ludGVycnVwdCsweDM4LzB4NDEKWyAgICAwLjIxNjAwMF0gIFs8ZmZmZmZmZmY4
MTczYzE1ZD5dIHJlc2NoZWR1bGVfaW50ZXJydXB0KzB4NmQvMHg4MApbICAgIDAuMjE2MDAw
XSAgPEVPST4gClsgICAgMC4yMTYwMDBdICBbPGZmZmZmZmZmODEwZmY2MjQ+XSA/IF9fYXRv
bWljX25vdGlmaWVyX2NhbGxfY2hhaW4rMHg1LzB4YzEKWyAgICAwLjIxNjAwMF0gIFs8ZmZm
ZmZmZmY4MTA1Y2RjMD5dID8gbmF0aXZlX3NhZmVfaGFsdCsweGQvMHgxNgpbICAgIDAuMjE2
MDAwXSAgWzxmZmZmZmZmZjgxMDE1ZjEwPl0gZGVmYXVsdF9pZGxlKzB4MTQ3LzB4MjgyClsg
ICAgMC4yMTYwMDBdICBbPGZmZmZmZmZmODEwMTcwMjY+XSBhcmNoX2NwdV9pZGxlKzB4M2Qv
MHg1ZApbICAgIDAuMjE2MDAwXSAgWzxmZmZmZmZmZjgxMTI3ZjBhPl0gY3B1X2lkbGVfbG9v
cCsweDQ2ZC8weDVkYgpbICAgIDAuMjE2MDAwXSAgWzxmZmZmZmZmZjgxMTI4MGZjPl0gY3B1
X3N0YXJ0dXBfZW50cnkrMHg4NC8weDg0ClsgICAgMC4yMTYwMDBdICBbPGZmZmZmZmZmODEw
NGY2ODg+XSBzdGFydF9zZWNvbmRhcnkrMHgzYzgvMHgzZDUKWyAgICAwLjIxNjAwMF0gQ29k
ZTogNWMgNWQgYzMgZTggMzcgMTAgNjMgMDAgNTUgNDggZmYgMDUgM2YgNWMgMWUgMDEgNDgg
ODkgZTUgNDEgNTUgNDkgODkgZjUgNDEgNTQgNTMgNDggODkgZmIgZTggOGQgZmUgZmYgZmYg
NDggZmYgMDUgMmQgNWMgMWUgMDEgY2MgPDFmPiA0NCAwMCAwMCAzMSBjMCBlYiAwYyA0OCBm
ZiAwNSAyNSA1YyAxZSAwMSBiOCAwMSAwMCAwMCAwMCA0OCAKWyAgICAwLjIxNjAwMF0gUklQ
ICBbPGZmZmZmZmZmODExMDlhNmM+XSB0dHd1X2RvX3dha2V1cCsweDI4LzB4MjI1ClsgICAg
MC4yMTYwMDBdICBSU1AgPGZmZmY4ODAwMGRkMDNmMTA+ClsgICAgMC4yMTYwMDBdIC0tLVsg
ZW5kIHRyYWNlIDc2NWZkODkwMmJjNDI4ZDMgXS0tLQova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWMwNS0wNzE4LzVhNjk5ODUzOTJlNjBhYmNhZWIyMjQzZmFmMDQwNDg4MzMwYTZhZTgv
ZG1lc2cta3ZtLWtidWlsZC01MDUzNy0yMDEzMDcyMDE3MzY0NS0zLjExLjAtcmMxLTAxNjM4
LWc1YTY5OTg1LTc0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzA1LTA3MTgvNWE2OTk4
NTM5MmU2MGFiY2FlYjIyNDNmYWYwNDA0ODgzMzBhNmFlOC9kbWVzZy1rdm0ta2J1aWxkLTE3
Mzc1LTIwMTMwNzIwMTczNzAxLTMuMTEuMC1yYzEtMDAwMDctZ2EyMzJlMjctODQKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1jMDUtMDcxOC81YTY5OTg1MzkyZTYwYWJjYWViMjI0M2Zh
ZjA0MDQ4ODMzMGE2YWU4L2RtZXNnLWt2bS1rYnVpbGQtMTc2MzgtMjAxMzA3MjAxNzM2NTct
My4xMS4wLXJjMS0wMDE0NS1nOWJmMzFjNS0xMzcKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1jMDUtMDcxOC81YTY5OTg1MzkyZTYwYWJjYWViMjI0M2ZhZjA0MDQ4ODMzMGE2YWU4L2Rt
ZXNnLWt2bS1rYnVpbGQtMjE2ODMtMjAxMzA3MjAxNzM3MDEtMy4xMC4wLXJjNi0wMDA4Ni1n
NjAwN2IxYi0xODUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMDUtMDcxOC81YTY5OTg1
MzkyZTYwYWJjYWViMjI0M2ZhZjA0MDQ4ODMzMGE2YWU4L2RtZXNnLWt2bS1rYnVpbGQtMjIy
NTktMjAxMzA3MjAxNzM3MDQtMy4xMS4wLXJjMS0wMDAxMi1nY2Q0NThiYS05MAova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWMwNS0wNzE4LzVhNjk5ODUzOTJlNjBhYmNhZWIyMjQzZmFm
MDQwNDg4MzMwYTZhZTgvZG1lc2cta3ZtLWtidWlsZC0yOTA1MS0yMDEzMDcyMDE3MzY1Ny0z
LjExLjAtcmMxLTAwNTE0LWdmZjYwNDllLTI4NQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWMwNS0wNzE4LzVhNjk5ODUzOTJlNjBhYmNhZWIyMjQzZmFmMDQwNDg4MzMwYTZhZTgvZG1l
c2cta3ZtLWtidWlsZC0zNTc1NS0yMDEzMDcyMDE3MzY1Ny0zLjExLjAtcmMxLTAwMTUxLWdl
Y2IyY2YxLTIxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzA1LTA3MTgvNWE2OTk4NTM5
MmU2MGFiY2FlYjIyNDNmYWYwNDA0ODgzMzBhNmFlOC9kbWVzZy1rdm0ta2J1aWxkLTQxMDI2
LTIwMTMwNzIwMTczNjU2LTMuMTEuMC1yYzEtMDAxODAtZzFmYWFiZjItMTI4Cgo=

--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.11.0-rc1-01429-g04bf576"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.11.0-rc1 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
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
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
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
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
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
# CONFIG_NO_HZ_FULL is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_RCU_USER_QS=y
CONFIG_CONTEXT_TRACKING_FORCE=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_RCU_FAST_NO_HZ is not set
CONFIG_TREE_RCU_TRACE=y
# CONFIG_RCU_BOOST is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
CONFIG_CGROUP_HUGETLB=y
CONFIG_CGROUP_PERF=y
# CONFIG_CGROUP_SCHED is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_UIDGID_CONVERTED=y
# CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
# CONFIG_SCHED_AUTOGROUP is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
# CONFIG_RD_LZMA is not set
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
# CONFIG_RD_LZ4 is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
CONFIG_JUMP_LABEL=y
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
CONFIG_USE_GENERIC_SMP_HELPERS=y
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
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
# CONFIG_MODULE_UNLOAD is not set
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
CONFIG_MODULE_SIG_SHA256=y
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha256"
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
# CONFIG_KVMTOOL_TEST_ENABLE is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_I8K=m
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_ZBUD is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
# CONFIG_X86_PAT is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
CONFIG_DEBUG_HOTPLUG_CPU0=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
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
# CONFIG_ISA_DMA_API is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=m
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
# CONFIG_COREDUMP is not set
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
CONFIG_X86_X32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_NET_LL_RX_POLL=y
# CONFIG_BPF_JIT is not set

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
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
# CONFIG_CONNECTOR is not set
CONFIG_MTD=m
CONFIG_MTD_TESTS=m
# CONFIG_MTD_REDBOOT_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
# CONFIG_MTD_OOPS is not set

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
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=m
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_SC520CDP=m
CONFIG_MTD_NETSC520=m
CONFIG_MTD_TS5500=m
CONFIG_MTD_AMD76XROM=m
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
CONFIG_MTD_NETtel=m
CONFIG_MTD_L440GX=m
# CONFIG_MTD_PCI is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=m
CONFIG_MTD_LATCH_ADDR=m

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_DATAFLASH is not set
# CONFIG_MTD_M25P80 is not set
# CONFIG_MTD_SST25L is not set
CONFIG_MTD_SLRAM=m
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=m
# CONFIG_MTD_NAND_ECC_SMC is not set
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
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH is not set
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
# CONFIG_MTD_NAND_DOCG4 is not set
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_NANDSIM=m
CONFIG_MTD_NAND_PLATFORM=m
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
# CONFIG_MTD_UBI_GLUEBI is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
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
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
CONFIG_ATMEL_SSC=y
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29020=m
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
CONFIG_DS1682=m
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
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
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5520=y
CONFIG_KEYBOARD_ADP5588=m
CONFIG_KEYBOARD_ADP5589=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
CONFIG_KEYBOARD_QT2160=y
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_TCA6416=y
# CONFIG_KEYBOARD_TCA8418 is not set
CONFIG_KEYBOARD_LM8323=y
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
CONFIG_KEYBOARD_MPR121=y
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_OPENCORES=m
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_XTKBD=m
CONFIG_KEYBOARD_CROS_EC=m
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
# CONFIG_MOUSE_PS2_SYNAPTICS is not set
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=m
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
CONFIG_MOUSE_VSXXXAA=m
CONFIG_MOUSE_SYNAPTICS_I2C=y
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
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
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
# CONFIG_N_HDLC is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
CONFIG_SERIAL_8250_DETECT_IRQ=y
# CONFIG_SERIAL_8250_RSA is not set
CONFIG_SERIAL_8250_DW=m

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_MAX310X=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=y
CONFIG_SERIAL_SCCNXP_CONSOLE=y
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=m
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
# CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_TPM=m
CONFIG_NVRAM=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=m
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_INFINEON=m
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_PCA9541=m
CONFIG_I2C_MUX_PCA954x=y
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
# CONFIG_I2C_ALGOPCA is not set

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
CONFIG_I2C_OCORES=m
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_TAOS_EVM=m

#
# Other I2C/SMBus bus drivers
#
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
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=m
CONFIG_SPI_LM70_LLP=m
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=y
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_XCOMM=m
CONFIG_SPI_XILINX=y
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=m
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=y

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
CONFIG_PPS_CLIENT_LDISC=y
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=y

#
# PPS generators support
#

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=m

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=m
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2423=m
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=m
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_GENERIC_ADC_BATTERY is not set
CONFIG_MAX8925_POWER=y
CONFIG_WM831X_BACKUP=m
CONFIG_WM831X_POWER=m
CONFIG_WM8350_POWER=y
CONFIG_TEST_POWER=m
# CONFIG_BATTERY_88PM860X is not set
CONFIG_BATTERY_DS2780=m
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=m
# CONFIG_BATTERY_BQ27X00_I2C is not set
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9030=y
# CONFIG_BATTERY_DA9052 is not set
CONFIG_BATTERY_MAX17040=m
CONFIG_BATTERY_MAX17042=m
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_LP8727=y
# CONFIG_CHARGER_LP8788 is not set
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_SMB347=m
CONFIG_BATTERY_GOLDFISH=m
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_AD7314=m
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADCXX=y
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=m
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=m
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DA9052_ADC=m
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_G762=m
CONFIG_SENSORS_GL518SM=y
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IIO_HWMON=m
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=m
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=m
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=m
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MCP3021=m
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
# CONFIG_SENSORS_PMBUS is not set
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_LM25066 is not set
# CONFIG_SENSORS_LTC2978 is not set
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=m
# CONFIG_SENSORS_ZL6100 is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=m
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=m
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=m
# CONFIG_SENSORS_SCH5627 is not set
CONFIG_SENSORS_SCH5636=m
CONFIG_SENSORS_ADS1015=m
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_ADS7871=m
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA_CPUTEMP=m
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=m
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_WM831X is not set
# CONFIG_SENSORS_WM8350 is not set
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
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_CPU_THERMAL=y
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=m
CONFIG_X86_PKG_TEMP_THERMAL=m

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_DA9052_WATCHDOG=m
# CONFIG_WM831X_WATCHDOG is not set
CONFIG_WM8350_WATCHDOG=m
CONFIG_RETU_WATCHDOG=m
CONFIG_ACQUIRE_WDT=y
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=m
# CONFIG_SP5100_TCO is not set
CONFIG_SC520_WDT=m
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
CONFIG_IT87_WDT=m
# CONFIG_HP_WATCHDOG is not set
CONFIG_SC1200_WDT=y
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=m
# CONFIG_SBC8360_WDT is not set
CONFIG_CPU5_WDT=m
# CONFIG_SMSC_SCH311X_WDT is not set
CONFIG_SMSC37B787_WDT=m
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=y
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=y
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
CONFIG_SBC_EPX_C3_WATCHDOG=y

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
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_CROS_EC=m
CONFIG_MFD_CROS_EC_I2C=m
CONFIG_MFD_CROS_EC_SPI=m
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=m
# CONFIG_HTC_PASIC3 is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_88PM800=m
CONFIG_MFD_88PM805=m
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_RETU=m
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
CONFIG_TPS6507X=m
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=m
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_ARIZONA_SPI=m
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_DA903X=m
CONFIG_REGULATOR_DA9052=y
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_88PM8607=y
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
# CONFIG_REGULATOR_MAX8925 is not set
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
# CONFIG_REGULATOR_MAX77693 is not set
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_LP8788=y
CONFIG_REGULATOR_RC5T583=y
CONFIG_REGULATOR_PALMAS=m
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS6105X=m
CONFIG_REGULATOR_TPS62360=y
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_TPS65217 is not set
# CONFIG_REGULATOR_TPS6524X is not set
CONFIG_REGULATOR_TPS6586X=y
CONFIG_REGULATOR_TPS80031=y
CONFIG_REGULATOR_WM831X=m
CONFIG_REGULATOR_WM8350=m
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
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
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_SMS_SDIO_DRV is not set

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
CONFIG_MEDIA_ATTACH=y

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9840=y
# CONFIG_VIDEO_TEA6415C is not set
# CONFIG_VIDEO_TEA6420 is not set
# CONFIG_VIDEO_MSP3400 is not set
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_TLV320AIC23B=y
CONFIG_VIDEO_UDA1342=y
# CONFIG_VIDEO_WM8775 is not set
CONFIG_VIDEO_WM8739=m
# CONFIG_VIDEO_VP27SMPX is not set
CONFIG_VIDEO_SONY_BTF_MPX=m

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=y
CONFIG_VIDEO_ADV7183=y
# CONFIG_VIDEO_BT819 is not set
# CONFIG_VIDEO_BT856 is not set
CONFIG_VIDEO_BT866=m
# CONFIG_VIDEO_KS0127 is not set
CONFIG_VIDEO_ML86V7667=m
CONFIG_VIDEO_SAA7110=m
CONFIG_VIDEO_SAA711X=y
CONFIG_VIDEO_SAA7191=y
# CONFIG_VIDEO_TVP514X is not set
# CONFIG_VIDEO_TVP5150 is not set
# CONFIG_VIDEO_TVP7002 is not set
CONFIG_VIDEO_TW2804=m
# CONFIG_VIDEO_TW9903 is not set
CONFIG_VIDEO_TW9906=m
CONFIG_VIDEO_VPX3220=m

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_CX25840=m

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=y
CONFIG_VIDEO_SAA7185=m
CONFIG_VIDEO_ADV7170=m
CONFIG_VIDEO_ADV7175=y
# CONFIG_VIDEO_ADV7343 is not set
# CONFIG_VIDEO_ADV7393 is not set
CONFIG_VIDEO_AK881X=y
CONFIG_VIDEO_THS8200=m

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#
# CONFIG_VIDEO_UPD64031A is not set
# CONFIG_VIDEO_UPD64083 is not set

#
# Miscelaneous helper chips
#
CONFIG_VIDEO_THS7303=y
# CONFIG_VIDEO_M52790 is not set

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=y
# CONFIG_MEDIA_TUNER_TDA8290 is not set
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_MT2060=y
CONFIG_MEDIA_TUNER_MT2063=m
CONFIG_MEDIA_TUNER_MT2266=y
CONFIG_MEDIA_TUNER_MT2131=y
# CONFIG_MEDIA_TUNER_QT1010 is not set
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MXL5005S=y
# CONFIG_MEDIA_TUNER_MXL5007T is not set
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_MEDIA_TUNER_MAX2165=m
CONFIG_MEDIA_TUNER_TDA18218=m
# CONFIG_MEDIA_TUNER_FC0011 is not set
# CONFIG_MEDIA_TUNER_FC0012 is not set
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=y
# CONFIG_MEDIA_TUNER_E4000 is not set
CONFIG_MEDIA_TUNER_FC2580=y
CONFIG_MEDIA_TUNER_TUA9001=y
CONFIG_MEDIA_TUNER_IT913X=m
# CONFIG_MEDIA_TUNER_R820T is not set

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=y
# CONFIG_DVB_STB6100 is not set
CONFIG_DVB_STV090x=m
CONFIG_DVB_STV6110x=y

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=m
CONFIG_DVB_TDA18271C2DD=m

#
# DVB-S (satellite) frontends
#
# CONFIG_DVB_CX24110 is not set
# CONFIG_DVB_CX24123 is not set
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=m
# CONFIG_DVB_ZL10039 is not set
# CONFIG_DVB_S5H1420 is not set
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=y
CONFIG_DVB_STV0299=y
CONFIG_DVB_STV6110=m
CONFIG_DVB_STV0900=m
# CONFIG_DVB_TDA8083 is not set
CONFIG_DVB_TDA10086=m
# CONFIG_DVB_TDA8261 is not set
CONFIG_DVB_VES1X93=y
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TUNER_CX24113=y
# CONFIG_DVB_TDA826X is not set
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
# CONFIG_DVB_SI21XX is not set
# CONFIG_DVB_TS2020 is not set
# CONFIG_DVB_DS3000 is not set
# CONFIG_DVB_MB86A16 is not set
CONFIG_DVB_TDA10071=y

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=y
CONFIG_DVB_CX22700=y
# CONFIG_DVB_CX22702 is not set
# CONFIG_DVB_S5H1432 is not set
CONFIG_DVB_DRXD=y
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
# CONFIG_DVB_NXT6000 is not set
# CONFIG_DVB_MT352 is not set
# CONFIG_DVB_ZL10353 is not set
CONFIG_DVB_DIB3000MB=m
# CONFIG_DVB_DIB3000MC is not set
# CONFIG_DVB_DIB7000M is not set
CONFIG_DVB_DIB7000P=m
# CONFIG_DVB_DIB9000 is not set
CONFIG_DVB_TDA10048=y
CONFIG_DVB_AF9013=y
CONFIG_DVB_EC100=y
# CONFIG_DVB_HD29L2 is not set
CONFIG_DVB_STV0367=m
CONFIG_DVB_CXD2820R=m
CONFIG_DVB_RTL2830=m
CONFIG_DVB_RTL2832=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=y
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=y
CONFIG_DVB_OR51211=y
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_LGDT3305=m
# CONFIG_DVB_LG2160 is not set
CONFIG_DVB_S5H1409=y
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_DTV=m
CONFIG_DVB_AU8522_V4L=m
# CONFIG_DVB_S5H1411 is not set

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m
CONFIG_DVB_DIB8000=y
# CONFIG_DVB_MB86A20S is not set

#
# Digital terrestrial only tuners/PLL
#
# CONFIG_DVB_PLL is not set
# CONFIG_DVB_TUNER_DIB0070 is not set
# CONFIG_DVB_TUNER_DIB0090 is not set

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=m
CONFIG_DVB_LNBP22=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=y
# CONFIG_DVB_ISL6423 is not set
# CONFIG_DVB_A8293 is not set
# CONFIG_DVB_LGS8GL5 is not set
CONFIG_DVB_LGS8GXX=m
CONFIG_DVB_ATBM8830=m
CONFIG_DVB_TDA665x=m
# CONFIG_DVB_IX2505V is not set
CONFIG_DVB_IT913X_FE=m
CONFIG_DVB_M88RS2000=y
CONFIG_DVB_AF9033=m

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=m

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
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_HDMI=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
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
CONFIG_FB_BIG_ENDIAN=y
# CONFIG_FB_LITTLE_ENDIAN is not set
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
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=m
CONFIG_FB_HGA=m
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
# CONFIG_FB_TMIO is not set
CONFIG_FB_GOLDFISH=m
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=m
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=m
CONFIG_FB_AUO_K190X=y
# CONFIG_FB_AUO_K1900 is not set
CONFIG_FB_AUO_K1901=y
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_PWM=m
# CONFIG_BACKLIGHT_DA903X is not set
CONFIG_BACKLIGHT_DA9052=m
CONFIG_BACKLIGHT_MAX8925=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
# CONFIG_BACKLIGHT_ADP5520 is not set
CONFIG_BACKLIGHT_ADP8860=m
CONFIG_BACKLIGHT_ADP8870=m
CONFIG_BACKLIGHT_88PM860X=m
# CONFIG_BACKLIGHT_LM3630 is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=m
CONFIG_BACKLIGHT_LP8788=m
CONFIG_BACKLIGHT_TPS65217=m
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
# CONFIG_LOGO_LINUX_VGA16 is not set
# CONFIG_LOGO_LINUX_CLUT224 is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_HRTIMER=y
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
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
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_SPI is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
CONFIG_UHID=y
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=m
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=y
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_PRODIKEYS=m
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=m
CONFIG_HID_EZKEY=m
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=m
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=m
CONFIG_HID_LOGITECH=m
# CONFIG_HID_LOGITECH_DJ is not set
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=y
# CONFIG_HID_PICOLCD_FB is not set
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=y
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SPEEDLINK=y
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=m
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=m
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_ZEROPLUS is not set
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=m

#
# I2C HID support
#
CONFIG_I2C_HID=y
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
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SPI is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MEMSTICK=m
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
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
CONFIG_LEDS_LM3530=m
CONFIG_LEDS_LM3642=m
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_LP5562=y
# CONFIG_LEDS_LP8788 is not set
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA9633=m
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_WM8350=m
CONFIG_LEDS_DA903X=m
CONFIG_LEDS_DA9052=m
CONFIG_LEDS_DAC124S085=m
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=m
# CONFIG_LEDS_ADP5520 is not set
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=m
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=m
CONFIG_EDAC_MCE_INJ=m
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_AMD64 is not set
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I7CORE is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
# CONFIG_CFAG12864B is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV=m
CONFIG_UIO_PDRV_GENIRQ=y
# CONFIG_UIO_DMEM_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_VIRT_DRIVERS is not set

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
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
CONFIG_SENSORS_HDAPS=y
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
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=m

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_ADC_JACK is not set
# CONFIG_EXTCON_MAX77693 is not set
CONFIG_EXTCON_PALMAS=m
CONFIG_MEMORY=y
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
# CONFIG_HID_SENSOR_ACCEL_3D is not set
CONFIG_KXSD9=m

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=m
CONFIG_AD7266=m
# CONFIG_AD7298 is not set
CONFIG_AD7923=m
CONFIG_AD7791=m
CONFIG_AD7793=m
# CONFIG_AD7476 is not set
# CONFIG_AD7887 is not set
CONFIG_LP8788_ADC=y
CONFIG_MAX1363=m
CONFIG_MCP320X=m
CONFIG_TI_ADC081C=m
CONFIG_TI_AM335X_ADC=m

#
# Amplifiers
#
CONFIG_AD8366=m

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS=y

#
# Digital to analog converters
#
CONFIG_AD5064=m
CONFIG_AD5360=m
CONFIG_AD5380=m
# CONFIG_AD5421 is not set
CONFIG_AD5624R_SPI=m
CONFIG_AD5446=m
CONFIG_AD5449=m
# CONFIG_AD5504 is not set
CONFIG_AD5755=m
CONFIG_AD5764=m
CONFIG_AD5791=m
CONFIG_AD5686=m
CONFIG_AD7303=m
# CONFIG_MAX517 is not set
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
CONFIG_ADF4350=m

#
# Digital gyroscope sensors
#
CONFIG_ADIS16080=m
CONFIG_ADIS16130=m
# CONFIG_ADIS16136 is not set
# CONFIG_ADXRS450 is not set
# CONFIG_HID_SENSOR_GYRO_3D is not set
# CONFIG_ITG3200 is not set

#
# Inertial measurement units
#
CONFIG_ADIS16400=m
# CONFIG_ADIS16480 is not set
CONFIG_IIO_ADIS_LIB=m
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
CONFIG_ADJD_S311=m
CONFIG_SENSORS_TSL2563=m
CONFIG_VCNL4000=m
# CONFIG_HID_SENSOR_ALS is not set

#
# Magnetometer sensors
#
CONFIG_HID_SENSOR_MAGNETOMETER_3D=m

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=m

#
# Pressure Sensors
#
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
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
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=m
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_DEBUG=y

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
# CONFIG_SYSFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=m
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=m
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=m
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
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
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_MEMORY_NOTIFIER_ERROR_INJECT is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_DEBUG_PREEMPT is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU_DELAY=y
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=m
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
# CONFIG_FAULT_INJECTION is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
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
CONFIG_HAVE_FENTRY=y
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
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_PREEMPT_TRACER is not set
CONFIG_SCHED_TRACER=y
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
# CONFIG_STACK_TRACER is not set
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
# CONFIG_DYNAMIC_FTRACE is not set
# CONFIG_FUNCTION_PROFILER is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=m
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=m
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
CONFIG_DEBUG_NX_TEST=m
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
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
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=m
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=m
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
# CONFIG_CRYPTO_MD5 is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=m
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=y
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
# CONFIG_CRYPTO_DES is not set
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
CONFIG_CRYPTO_TEA=m
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
CONFIG_BINARY_PRINTF=y

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
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m
CONFIG_ZLIB_INFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y

--jI8keyz6grp/JLjh--
