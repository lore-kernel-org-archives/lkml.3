Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbaKLK0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 05:26:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:16243 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471AbaKLK0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 05:26:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,367,1413270000"; 
   d="scan'208";a="621094466"
Date: Wed, 12 Nov 2014 18:27:06 +0800
From: lkp@01.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [LKP] [ftrace/x86] WARNING: CPU: 0 PID: 1795 at
 kernel/trace/ftrace.c:2033 ftrace_get_addr_new+0x6e/0xb6()
Message-ID: <20141112102706.GF1705@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="dgjlcl3Tl+kb3YDk"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dgjlcl3Tl+kb3YDk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

FYI, we noticed the below changes on

git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
commit 12cce594fa8f12e002e7eb5d10141853c1e6a112 ("ftrace/x86: Allow !CONFIG_PREEMPT dynamic ops to use allocated trampolines")


+--------------------------------------------------------+------------+------------+
|                                                        | 15d5b02cc5 | 12cce594fa |
+--------------------------------------------------------+------------+------------+
| boot_successes                                         | 42         | 17         |
| boot_failures                                          | 4          | 4          |
| BUG:kernel_test_crashed                                | 4          | 1          |
| WARNING:at_kernel/trace/ftrace.c:ftrace_get_addr_new() | 0          | 3          |
| backtrace:perf_tp_event_init                           | 0          | 3          |
| backtrace:perf_init_event                              | 0          | 3          |
| backtrace:perf_event_alloc                             | 0          | 3          |
| backtrace:SyS_perf_event_open                          | 0          | 3          |
| backtrace:perf_ftrace_event_register                   | 0          | 3          |
| backtrace:perf_trace_init                              | 0          | 3          |
| backtrace:tipc_disc_init_msg                           | 0          | 1          |
| backtrace:tipc_msg_init                                | 0          | 1          |
| backtrace:tipc_nametbl_init                            | 0          | 1          |
| backtrace:tipc_sk_ref_table_init                       | 0          | 1          |
| backtrace:tipc_socket_init                             | 0          | 1          |
| backtrace:sysctl_net_init                              | 0          | 1          |
| backtrace:init_memory_mapping                          | 0          | 1          |
| backtrace:profile_init                                 | 0          | 1          |
| backtrace:zone_wait_table_init                         | 0          | 1          |
| backtrace:pcrypt_init_padata                           | 0          | 1          |
| backtrace:run_init_process                             | 0          | 2          |
| backtrace:try_to_run_init_process                      | 0          | 2          |
| backtrace:init_linuxrc                                 | 0          | 2          |
| backtrace:kvm_vcpu_init                                | 0          | 2          |
| backtrace:kvm_init                                     | 0          | 2          |
| backtrace:kvm_gfn_to_hva_cache_init                    | 0          | 2          |
| backtrace:kvm_ioapic_init                              | 0          | 2          |
| backtrace:kvm_coalesced_mmio_init                      | 0          | 2          |
| backtrace:kvm_eventfd_init                             | 0          | 2          |
| backtrace:kvm_irqfd_init                               | 0          | 2          |
| backtrace:kvm_vfio_ops_init                            | 0          | 2          |
| backtrace:kvm_async_pf_init                            | 0          | 2          |
| backtrace:kvm_async_pf_vcpu_init                       | 0          | 2          |
| backtrace:init_emulate_ctxt                            | 0          | 2          |
| backtrace:kvm_timer_init                               | 0          | 2          |
| backtrace:fx_init                                      | 0          | 2          |
| backtrace:kvm_arch_init                                | 0          | 2          |
| backtrace:kvm_arch_vcpu_init                           | 0          | 2          |
| backtrace:kvm_arch_init_vm                             | 0          | 2          |
| backtrace:shadow_walk_init                             | 0          | 2          |
+--------------------------------------------------------+------------+------------+


[    5.251562] random: trinity urandom read with 7 bits of entropy available
[   15.332185] sock: process `trinity-main' is using obsolete setsockopt SO_BSDCOMPAT
[   16.288125] ------------[ cut here ]------------
[   16.290326] WARNING: CPU: 0 PID: 1795 at kernel/trace/ftrace.c:2033 ftrace_get_addr_new+0x6e/0xb6()
[   16.294978] Modules linked in:
[   16.296969] CPU: 0 PID: 1795 Comm: trinity-main Not tainted 3.18.0-rc4-wl-g55fe5ef #1
[   16.300668] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   16.303231]  0000000000000009 ffff88001025fbe8 ffffffff819ef520 00000000000033e2
[   16.307863]  0000000000000000 ffff88001025fc28 ffffffff810e6d54 0000000000000000
[   16.312524]  ffffffff81164804 ffffffff8205e000 ffff880013700000 ffffffff810001c8
[   16.317320] Call Trace:
[   16.318874]  [<ffffffff819ef520>] dump_stack+0x4e/0x68
[   16.321334]  [<ffffffff810e6d54>] warn_slowpath_common+0x81/0x9b
[   16.324410]  [<ffffffff81164804>] ? ftrace_get_addr_new+0x6e/0xb6
[   16.326934]  [<ffffffff810001c8>] ? 0xffffffff810001c8
[   16.329336]  [<ffffffff810e6e11>] warn_slowpath_null+0x1a/0x1c
[   16.331850]  [<ffffffff81164804>] ftrace_get_addr_new+0x6e/0xb6
[   16.334488]  [<ffffffff81064ec9>] ftrace_replace_code+0xda/0x330
[   16.337164]  [<ffffffff8116520a>] ftrace_modify_all_code+0x44/0xcf
[   16.339768]  [<ffffffff8106512f>] arch_ftrace_update_code+0x10/0x19
[   16.342442]  [<ffffffff81165695>] ftrace_run_update_code+0x21/0x42
[   16.345128]  [<ffffffff811656e8>] ftrace_startup_enable+0x32/0x34
[   16.347724]  [<ffffffff8116583d>] ftrace_startup+0x153/0x166
[   16.350306]  [<ffffffff8116589f>] register_ftrace_function+0x4f/0x68
[   16.352935]  [<ffffffff8117e28c>] perf_ftrace_event_register+0x3e/0xf2
[   16.355626]  [<ffffffff8117e10a>] perf_trace_init+0x256/0x28a
[   16.358275]  [<ffffffff8118bf49>] perf_tp_event_init+0x27/0x3a
[   16.360813]  [<ffffffff811923b5>] perf_init_event+0xc6/0xfd
[   16.363320]  [<ffffffff81192699>] perf_event_alloc+0x2ad/0x336
[   16.365990]  [<ffffffff81192e5b>] SyS_perf_event_open+0x42b/0x97d
[   16.368650]  [<ffffffff811c5a00>] ? do_brk+0x175/0x267
[   16.370981]  [<ffffffff819f8b89>] ia32_do_call+0x13/0x13
[   16.373447] ---[ end trace 15858d6d5a0d0548 ]---
[   16.375508] Bad trampoline accounting at: ffffffff810001c8 (run_init_process+0x0/0x2d) (10000001)

--dgjlcl3Tl+kb3YDk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".dmesg"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel
input_data: 0x0000000001f8a3b4
input_len: 0x000000000075b3f8
output: 0x0000000001000000
output_len: 0x00000000016d39f0
run_size: 0x000000000188f000

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc4-wl-g55fe5ef (kbuild@xian) (gcc vers=
ion 4.9.1 (Debian 4.9.1-19) ) #1 SMP Wed Nov 12 11:43:49 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vm-kbuild-yoct=
o-ia32-18/boot_boot-1-yocto-minimal-i386.cgz-x86_64-lkp-55fe5efe40700541a2e=
77a7afa247c7e4c58bfe2-0.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/=
55fe5efe40700541a2e77a7afa247c7e4c58bfe2/vmlinuz-3.18.0-rc4-wl-g55fe5ef kco=
nfig=3Dx86_64-lkp commit=3D55fe5efe40700541a2e77a7afa247c7e4c58bfe2 branch=
=3Dlinux-devel/devel-hourly-2014111210 root=3D/dev/ram0 max_uptime=3D3600 R=
ESULT_ROOT=3D/result/vm-kbuild-yocto-ia32/boot/1/yocto-minimal-i386.cgz/x86=
_64-lkp/55fe5efe40700541a2e77a7afa247c7e4c58bfe2/0 ip=3D::::vm-kbuild-yocto=
-ia32-18::dhcp earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_e=
nabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D-1 softlockup_panic=3D1=
 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 cons=
ole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal rw drbd.minor_count=3D8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdaf0-0x000fdaff] mapped at =
[ffff8800000fdaf0]
[    0.000000]   mpc: fdb00-fdbe8
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0246a000, 0x0246afff] PGTABLE
[    0.000000] BRK [0x0246b000, 0x0246bfff] PGTABLE
[    0.000000] BRK [0x0246c000, 0x0246cfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13800000-0x139fffff]
[    0.000000]  [mem 0x13800000-0x139fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x137fffff]
[    0.000000]  [mem 0x10000000-0x137fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13ffdfff]
[    0.000000]  [mem 0x13a00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x0246d000, 0x0246dfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13b20000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD990 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE4B0 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE4F0 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF800 000735 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF6E0 000078 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF6A0 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f5000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] NODE_DATA(0) allocated [mem 0x13ffa000-0x13ffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ff2001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880012c0000=
0-ffff8800131fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f5000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
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
[    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f4000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:1 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff880013800000 s81920 r8192=
 d28672 u2097152
[    0.000000] pcpu-alloc: s81920 r8192 d28672 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1380d140
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vm-kbui=
ld-yocto-ia32-18/boot_boot-1-yocto-minimal-i386.cgz-x86_64-lkp-55fe5efe4070=
0541a2e77a7afa247c7e4c58bfe2-0.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_=
64-lkp/55fe5efe40700541a2e77a7afa247c7e4c58bfe2/vmlinuz-3.18.0-rc4-wl-g55fe=
5ef kconfig=3Dx86_64-lkp commit=3D55fe5efe40700541a2e77a7afa247c7e4c58bfe2 =
branch=3Dlinux-devel/devel-hourly-2014111210 root=3D/dev/ram0 max_uptime=3D=
3600 RESULT_ROOT=3D/result/vm-kbuild-yocto-ia32/boot/1/yocto-minimal-i386.c=
gz/x86_64-lkp/55fe5efe40700541a2e77a7afa247c7e4c58bfe2/0 ip=3D::::vm-kbuild=
-yocto-ia32-18::dhcp earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_al=
ways_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D-1 softlockup_pan=
ic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D=
0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal rw drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 294796K/327280K available (10225K kernel code, 1390K=
 rwdata, 4336K rodata, 1452K init, 1624K bss, 32484K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D1
[    0.000000] NR_IRQS:33024 nr_irqs:256 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc4-wl-g55fe5ef (kbuild@xian) (gcc vers=
ion 4.9.1 (Debian 4.9.1-19) ) #1 SMP Wed Nov 12 11:43:49 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vm-kbuild-yoct=
o-ia32-18/boot_boot-1-yocto-minimal-i386.cgz-x86_64-lkp-55fe5efe40700541a2e=
77a7afa247c7e4c58bfe2-0.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/=
55fe5efe40700541a2e77a7afa247c7e4c58bfe2/vmlinuz-3.18.0-rc4-wl-g55fe5ef kco=
nfig=3Dx86_64-lkp commit=3D55fe5efe40700541a2e77a7afa247c7e4c58bfe2 branch=
=3Dlinux-devel/devel-hourly-2014111210 root=3D/dev/ram0 max_uptime=3D3600 R=
ESULT_ROOT=3D/result/vm-kbuild-yocto-ia32/boot/1/yocto-minimal-i386.cgz/x86=
_64-lkp/55fe5efe40700541a2e77a7afa247c7e4c58bfe2/0 ip=3D::::vm-kbuild-yocto=
-ia32-18::dhcp earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_e=
nabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D-1 softlockup_panic=3D1=
 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 cons=
ole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal rw drbd.minor_count=3D8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdaf0-0x000fdaff] mapped at =
[ffff8800000fdaf0]
[    0.000000]   mpc: fdb00-fdbe8
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0246a000, 0x0246afff] PGTABLE
[    0.000000] BRK [0x0246b000, 0x0246bfff] PGTABLE
[    0.000000] BRK [0x0246c000, 0x0246cfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13800000-0x139fffff]
[    0.000000]  [mem 0x13800000-0x139fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x137fffff]
[    0.000000]  [mem 0x10000000-0x137fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13ffdfff]
[    0.000000]  [mem 0x13a00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x0246d000, 0x0246dfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13b20000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD990 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE4B0 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE4F0 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF800 000735 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF6E0 000078 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF6A0 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f5000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] NODE_DATA(0) allocated [mem 0x13ffa000-0x13ffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ff2001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880012c0000=
0-ffff8800131fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f5000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
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
[    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f4000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:1 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff880013800000 s81920 r8192=
 d28672 u2097152
[    0.000000] pcpu-alloc: s81920 r8192 d28672 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1380d140
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vm-kbui=
ld-yocto-ia32-18/boot_boot-1-yocto-minimal-i386.cgz-x86_64-lkp-55fe5efe4070=
0541a2e77a7afa247c7e4c58bfe2-0.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_=
64-lkp/55fe5efe40700541a2e77a7afa247c7e4c58bfe2/vmlinuz-3.18.0-rc4-wl-g55fe=
5ef kconfig=3Dx86_64-lkp commit=3D55fe5efe40700541a2e77a7afa247c7e4c58bfe2 =
branch=3Dlinux-devel/devel-hourly-2014111210 root=3D/dev/ram0 max_uptime=3D=
3600 RESULT_ROOT=3D/result/vm-kbuild-yocto-ia32/boot/1/yocto-minimal-i386.c=
gz/x86_64-lkp/55fe5efe40700541a2e77a7afa247c7e4c58bfe2/0 ip=3D::::vm-kbuild=
-yocto-ia32-18::dhcp earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_al=
ways_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D-1 softlockup_pan=
ic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D=
0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal rw drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 294796K/327280K available (10225K kernel code, 1390K=
 rwdata, 4336K rodata, 1452K init, 1624K bss, 32484K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D1
[    0.000000] NR_IRQS:33024 nr_irqs:256 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 1572864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.418 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5386.83 Bogo=
MIPS (lpj=3D10773672)
[    0.009804] pid_max: default: 32768 minimum: 301
[    0.011324] ACPI: Core revision 20140926
[    0.016809] ACPI: All ACPI Tables successfully acquired
[    0.018764] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.020168] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.022156] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.024020] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.028289] Initializing cgroup subsys memory
[    0.029771] Initializing cgroup subsys devices
[    0.032011] Initializing cgroup subsys freezer
[    0.033494] Initializing cgroup subsys blkio
[    0.036010] Initializing cgroup subsys perf_event
[    0.037551] Initializing cgroup subsys hugetlb
[    0.040105] mce: CPU supports 10 MCE banks
[    0.044063] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.044063] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.084398] Freeing SMP alternatives memory: 40K (ffffffff822c8000 - fff=
fffff822d2000)
[    0.092934] ftrace: allocating 39769 entries in 156 pages
[    0.112132] Getting VERSION: 50014
[    0.116015] Getting VERSION: 50014
[    0.117675] Getting ID: 0
[    0.120018] Getting ID: ff000000
[    0.124019] Getting LVT0: 8700
[    0.125593] Getting LVT1: 8400
[    0.127267] enabled ExtINT on CPU#0
[    0.129410] ENABLING IO-APIC IRQs
[    0.131061] init IO_APIC IRQs
[    0.132008]  apic 0 pin 0 not connected
[    0.136013] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.140033] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.144030] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.148029] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.152028] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.156031] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.160029] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.164024] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.168024] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.170675] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.172030] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.174720] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.176024] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.180024] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.184025] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.188025] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.192022]  apic 0 pin 16 not connected
[    0.196005]  apic 0 pin 17 not connected
[    0.200005]  apic 0 pin 18 not connected
[    0.201405]  apic 0 pin 19 not connected
[    0.204005]  apic 0 pin 20 not connected
[    0.208005]  apic 0 pin 21 not connected
[    0.212004]  apic 0 pin 22 not connected
[    0.213411]  apic 0 pin 23 not connected
[    0.216156] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.220004] smpboot: CPU0: Intel Westmere E56xx/L56xx/X56xx (Nehalem-C) =
(fam: 06, model: 2c, stepping: 01)
[    0.228005] Using local APIC timer interrupts.
[    0.228005] calibrating APIC timer ...
[    0.236000] ... lapic delta =3D 7333478
[    0.236000] ... PM-Timer delta =3D 420016
[    0.236000] APIC calibration not consistent with PM-Timer: 117ms instead=
 of 100ms
[    0.236000] APIC delta adjusted to PM-Timer: 6249875 (7333478)
[    0.236000] TSC delta adjusted to PM-Timer: 269354345 (316054953)
[    0.236000] ..... delta 6249875
[    0.236000] ..... mult: 268430087
[    0.236000] ..... calibration result: 3999920
[    0.236000] ..... CPU clock speed is 2693.2173 MHz.
[    0.236000] ..... host bus clock speed is 999.3920 MHz.
[    0.236115] Performance Events: unsupported p6 CPU model 44 no PMU drive=
r, software events only.
[    0.245179] x86: Booted up 1 node, 1 CPUs
[    0.246521] smpboot: Total of 1 processors activated (5386.83 BogoMIPS)
[    0.248447] devtmpfs: initialized
[    0.254260] xor: measuring software checksum speed
[    0.292034]    prefetch64-sse:   113.000 MB/sec
[    0.332036]    generic_sse:   112.000 MB/sec
[    0.333674] xor: using function: prefetch64-sse (113.000 MB/sec)
[    0.335513] atomic64_test: passed for x86-64 platform with CX8 and with =
SSE
[    0.336261] NET: Registered protocol family 16
[    0.340317] cpuidle: using governor ladder
[    0.342086] cpuidle: using governor menu
[    0.344478] ACPI: bus type PCI registered
[    0.345854] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.347874] PCI: Using configuration type 1 for base access
[    0.424015] raid6: sse2x1    4643 MB/s
[    0.492014] raid6: sse2x2    6114 MB/s
[    0.564008] raid6: sse2x4    5704 MB/s
[    0.568006] raid6: using algorithm sse2x2 (6114 MB/s)
[    0.569553] raid6: using ssse3x2 recovery algorithm
[    0.578300] ACPI: Added _OSI(Module Device)
[    0.579711] ACPI: Added _OSI(Processor Device)
[    0.580016] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.581496] ACPI: Added _OSI(Processor Aggregator Device)
[    0.584889] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.590004] ACPI: Interpreter enabled
[    0.591330] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140926/hwxface-580)
[    0.600240] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140926/hwxface-580)
[    0.603323] ACPI: (supports S0 S3 S4 S5)
[    0.604007] ACPI: Using IOAPIC for interrupt routing
[    0.605637] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.615083] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.616060] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MS=
I]
[    0.618278] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.620272] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.624613] acpiphp: Slot [3] registered
[    0.626015] acpiphp: Slot [4] registered
[    0.628065] acpiphp: Slot [5] registered
[    0.629680] acpiphp: Slot [6] registered
[    0.631456] acpiphp: Slot [7] registered
[    0.632132] acpiphp: Slot [8] registered
[    0.633912] acpiphp: Slot [9] registered
[    0.636105] acpiphp: Slot [10] registered
[    0.637895] acpiphp: Slot [11] registered
[    0.640054] acpiphp: Slot [12] registered
[    0.641465] acpiphp: Slot [13] registered
[    0.642876] acpiphp: Slot [14] registered
[    0.644115] acpiphp: Slot [15] registered
[    0.645666] acpiphp: Slot [24] registered
[    0.647073] acpiphp: Slot [25] registered
[    0.648100] acpiphp: Slot [26] registered
[    0.649874] acpiphp: Slot [27] registered
[    0.652136] acpiphp: Slot [28] registered
[    0.653953] acpiphp: Slot [29] registered
[    0.656069] acpiphp: Slot [30] registered
[    0.657859] acpiphp: Slot [31] registered
[    0.659360] PCI host bridge to bus 0000:00
[    0.660075] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.661711] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.664107] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.665845] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.668064] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.672158] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.676627] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.679133] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.684336] pci 0000:00:01.1: reg 0x20: [io  0xc080-0xc08f]
[    0.687236] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.688068] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.692009] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.696005] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.700062] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.702733] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.704022] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.708619] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.716069] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.720104] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.731089] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.733768] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.737272] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.741204] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.750418] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.752433] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.757710] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.760668] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.774554] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
[    0.777284] pci 0000:00:05.0: reg 0x10: [mem 0xfebf2000-0xfebf200f]
[    0.785167] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.788308] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.790744] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.793581] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.796151] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.799584] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.800423] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.802103] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.804007] vgaarb: loaded
[    0.805316] vgaarb: bridge control possible 0000:00:02.0
[    0.808367] SCSI subsystem initialized
[    0.809908] libata version 3.00 loaded.
[    0.812146] ACPI: bus type USB registered
[    0.813679] usbcore: registered new interface driver usbfs
[    0.816046] usbcore: registered new interface driver hub
[    0.818099] usbcore: registered new device driver usb
[    0.819886] pps_core: LinuxPPS API ver. 1 registered
[    0.820014] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.824051] PTP clock support registered
[    0.825633] EDAC MC: Ver: 3.0.0
[    0.829592] PCI: Using ACPI for IRQ routing
[    0.832021] PCI: pci_cache_line_size set to 64 bytes
[    0.833750] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.835473] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.837280] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.840143] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.842126] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.848257] Switched to clocksource kvm-clock
[    0.883239] pnp: PnP ACPI init
[    0.884697] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.897758] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.899609] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.902411] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.904305] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.917360] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.919221] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.921977] pnp 00:03: [dma 2]
[    0.923279] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.935502] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.938314] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.946849] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.949653] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.951520] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.954316] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.966724] pnp: PnP ACPI: found 7 devices
[    0.986007] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.987640] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.989304] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.991045] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.993026] NET: Registered protocol family 2
[    1.006697] TCP established hash table entries: 4096 (order: 3, 32768 by=
tes)
[    1.008713] TCP bind hash table entries: 4096 (order: 4, 65536 bytes)
[    1.010536] TCP: Hash tables configured (established 4096 bind 4096)
[    1.012486] TCP: reno registered
[    1.013726] UDP hash table entries: 256 (order: 1, 8192 bytes)
[    1.025473] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
[    1.027607] NET: Registered protocol family 1
[    1.029308] RPC: Registered named UNIX socket transport module.
[    1.031007] RPC: Registered udp transport module.
[    1.032508] RPC: Registered tcp transport module.
[    1.033979] RPC: Registered tcp NFSv4.1 backchannel transport module
--dgjlcl3Tl+kb3YDk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--dgjlcl3Tl+kb3YDk--
