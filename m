Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaCUTKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 15:10:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39434 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbaCUTKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 15:10:48 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CAHdzE-88ZPTs_QvVLZsHs=O6TNKG61+iLH+ctGKLMdG5h6G0sg@mail.gmail.com>
References: <4055058.qLAukpngnj@al> <1834280.dSicCcN9uU@al> <CAHdzE-88ZPTs_QvVLZsHs=O6TNKG61+iLH+ctGKLMdG5h6G0sg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: GPF in intel_pmu_lbr_reset() with qemu -cpu host
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 21 Mar 2014 12:09:35 -0700
To: Venkatesh Srinivas <venkateshs@google.com>, Peter Wu <peter@lekensteyn.nl>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <57783d0c-3e75-47e1-a22a-818ad12e5f5c@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling this a bug in the PMU code is ridiculous.  If KVM tells the system it os a specific vendor-family-model-stepping but diverges in behavior then it, by definition, is broken.

On March 21, 2014 12:04:32 PM PDT, Venkatesh Srinivas <venkateshs@google.com> wrote:
>On Fri, Mar 21, 2014 at 10:46 AM, Peter Wu <peter@lekensteyn.nl> wrote:
>> cc'ing kvm people and list.
>>
>> On Friday 21 March 2014 18:42:40 Peter Wu wrote:
>>> Hi,
>>>
>>> While trying to run QEMU with `-enable-kvm -host cpu`, I get a GPF
>in
>>> intel_pmu_lbr_reset():
>>>
>>> [    0.024000] general protection fault: 0000 [#1]
>>> [    0.024000] CPU: 0 PID: 1 Comm: swapper Not tainted
>3.14.0-rc7-qemu-00059-g08edb33 #14
>>> [    0.024000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
>>> [    0.024000] task: ffff88003e050000 ti: ffff88003e054000 task.ti:
>ffff88003e054000
>>> [    0.024000] RIP: 0010:[<ffffffff8101148a>]  [<ffffffff8101148a>]
>intel_pmu_lbr_reset+0x2a/0x80
>>> [    0.024000] RSP: 0000:ffff88003e055e78  EFLAGS: 00000002
>>> [    0.024000] RAX: 0000000000000000 RBX: 0000000000000286 RCX:
>0000000000000680
>>> [    0.024000] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
>0000000000000000
>>> [    0.024000] RBP: ffffffff81622120 R08: ffff88003ffee0e0 R09:
>ffff88003e00bf00
>>> [    0.024000] R10: 0000000000000000 R11: 0000000000000004 R12:
>0000000000000000
>>> [    0.024000] R13: 0000000000000000 R14: 0000000000000000 R15:
>0000000000000000
>>> [    0.024000] FS:  0000000000000000(0000) GS:ffffffff8161e000(0000)
>knlGS:0000000000000000
>>> [    0.024000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [    0.024000] CR2: ffff8800019bb000 CR3: 0000000001611000 CR4:
>00000000001407b0
>>> [    0.024000] Stack:
>>> [    0.024000]  ffffffff8101308a ffffffff8100e3da ffffffff8165ba62
>0000000000000000
>>> [    0.024000]  ffffffff8165b5bd 0000000000000000 0000000000000000
>0000000000000000
>>> [    0.024000]  ffffffff81655dcd 0000000000000000 0000000000000000
>0000000000000000
>>> [    0.024000] Call Trace:
>>> [    0.024000]  [<ffffffff8101308a>] ?
>intel_pmu_cpu_starting+0xa/0x80
>>> [    0.024000]  [<ffffffff8100e3da>] ? x86_pmu_notifier+0x5a/0xc0
>>> [    0.024000]  [<ffffffff8165ba62>] ?
>init_hw_perf_events+0x4a5/0x4dd
>>> [    0.024000]  [<ffffffff8165b5bd>] ? check_bugs+0x42/0x42
>>> [    0.024000]  [<ffffffff81655dcd>] ? do_one_initcall+0x76/0xf9
>>> [    0.024000]  [<ffffffff81276b70>] ? rest_init+0x70/0x70
>>> [    0.024000]  [<ffffffff81655ea7>] ?
>kernel_init_freeable+0x57/0x177
>>> [    0.024000]  [<ffffffff81276b70>] ? rest_init+0x70/0x70
>>> [    0.024000]  [<ffffffff81276b75>] ? kernel_init+0x5/0xe0
>>> [    0.024000]  [<ffffffff8128067a>] ? ret_from_fork+0x7a/0xb0
>>> [    0.024000]  [<ffffffff81276b70>] ? rest_init+0x70/0x70
>>> [    0.024000] Code: 00 8b 15 02 c4 63 00 85 d2 74 69 f6 05 af c3 63
>00 3f 75 2d 85 d2 7e 5c 31 f6 31 c0 0f 1f 44 00 00 8b 0d d2 c3 63 00 89
>c2 01 f1 <0f> 30 83 c6 01 3b 35 d3 c3 63 00 7c e9 f3 c3 0f 1f 80 00 00
>00
>>> [    0.024000] RIP  [<ffffffff8101148a>]
>intel_pmu_lbr_reset+0x2a/0x80
>>> [    0.024000]  RSP <ffff88003e055e78>
>>> [    0.024000] ---[ end trace ecbd794f78441b2c ]---
>>> [    0.024002] Kernel panic - not syncing: Attempted to kill init!
>exitcode=0x0000000b
>>>
>>>
>>> It possibly has something to do with the msr write. Reproducable
>with:
>>>
>>>     qemu-system-x86_64 -enable-kvm -cpu host -kernel bzImage -m 1G
>-serial file:ser.txt
>>>
>>> In the host dmesg, the following is visible when qemu:
>>>
>>>     kvm [4939]: vcpu0 unhandled wrmsr: 0x680 data 0
>>>
>>> The full guest dmesg is shown below. The issue occurs also with
>>> v3.13.6, v3.12.14, v3.10.33 (other versions are not tested).
>>>
>>> QEMU: 1.7.0
>>> Host kernel: v3.14-rc5
>>> Guest kernel: v3.14-rc7-59-g08edb33 (.config on the bottom)
>>>
>>> Kind regards,
>>> Peter
>>>
>>> ### dmesg
>>> [    0.000000] Linux version 3.14.0-rc7-qemu-00059-g08edb33
>(pc@antartica) (gcc version 4.8.2 (Ubuntu 4.8.2-16ubuntu6) ) #14 Fri
>Mar 21 17:30:49 CET 2014
>>> [    0.000000] Command line: console=ttyS0 loglevel=8
>>> [    0.000000] KERNEL supported cpus:
>>> [    0.000000]   Intel GenuineIntel
>>> [    0.000000] e820: BIOS-provided physical RAM map:
>>> [    0.000000] BIOS-e820: [mem
>0x0000000000000000-0x000000000009fbff] usable
>>> [    0.000000] BIOS-e820: [mem
>0x000000000009fc00-0x000000000009ffff] reserved
>>> [    0.000000] BIOS-e820: [mem
>0x00000000000f0000-0x00000000000fffff] reserved
>>> [    0.000000] BIOS-e820: [mem
>0x0000000000100000-0x000000003fffdfff] usable
>>> [    0.000000] BIOS-e820: [mem
>0x000000003fffe000-0x000000003fffffff] reserved
>>> [    0.000000] BIOS-e820: [mem
>0x00000000feffc000-0x00000000feffffff] reserved
>>> [    0.000000] BIOS-e820: [mem
>0x00000000fffc0000-0x00000000ffffffff] reserved
>>> [    0.000000] NX (Execute Disable) protection: active
>>> [    0.000000] SMBIOS 2.4 present.
>>> [    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
>>> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==>
>reserved
>>> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
>>> [    0.000000] e820: last_pfn = 0x3fffe max_arch_pfn = 0x400000000
>>> [    0.000000] MTRR default type: write-back
>>> [    0.000000] MTRR fixed ranges enabled:
>>> [    0.000000]   00000-9FFFF write-back
>>> [    0.000000]   A0000-BFFFF uncachable
>>> [    0.000000]   C0000-FFFFF write-protect
>>> [    0.000000] MTRR variable ranges enabled:
>>> [    0.000000]   0 base 0080000000 mask FF80000000 uncachable
>>> [    0.000000]   1 disabled
>>> [    0.000000]   2 disabled
>>> [    0.000000]   3 disabled
>>> [    0.000000]   4 disabled
>>> [    0.000000]   5 disabled
>>> [    0.000000]   6 disabled
>>> [    0.000000]   7 disabled
>>> [    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new
>0x7010600070106
>>> [    0.000000] found SMP MP-table at [mem 0x000f1b10-0x000f1b1f]
>mapped at [ffff8800000f1b10]
>>> [    0.000000] Base memory trampoline at [ffff880000099000] 99000
>size 24576
>>> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
>>> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
>>> [    0.000000] BRK [0x019bb000, 0x019bbfff] PGTABLE
>>> [    0.000000] BRK [0x019bc000, 0x019bcfff] PGTABLE
>>> [    0.000000] BRK [0x019bd000, 0x019bdfff] PGTABLE
>>> [    0.000000] init_memory_mapping: [mem 0x3fc00000-0x3fdfffff]
>>> [    0.000000]  [mem 0x3fc00000-0x3fdfffff] page 2M
>>> [    0.000000] init_memory_mapping: [mem 0x3c000000-0x3fbfffff]
>>> [    0.000000]  [mem 0x3c000000-0x3fbfffff] page 2M
>>> [    0.000000] init_memory_mapping: [mem 0x00100000-0x3bffffff]
>>> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
>>> [    0.000000]  [mem 0x00200000-0x3bffffff] page 2M
>>> [    0.000000] init_memory_mapping: [mem 0x3fe00000-0x3fffdfff]
>>> [    0.000000]  [mem 0x3fe00000-0x3fffdfff] page 4k
>>> [    0.000000] BRK [0x019be000, 0x019befff] PGTABLE
>>> [    0.000000] ACPI: RSDP 00000000000f19b0 000014 (v00 BOCHS )
>>> [    0.000000] ACPI: RSDT 000000003ffffad3 000034 (v01 BOCHS 
>BXPCRSDT 00000001 BXPC 00000001)
>>> [    0.000000] ACPI: FACP 000000003ffff177 000074 (v01 BOCHS 
>BXPCFACP 00000001 BXPC 00000001)
>>> [    0.000000] ACPI: DSDT 000000003fffe040 001137 (v01   BXPC  
>BXDSDT 00000001 INTL 20130823)
>>> [    0.000000] ACPI: FACS 000000003fffe000 000040
>>> [    0.000000] ACPI: SSDT 000000003ffff1eb 000838 (v01 BOCHS 
>BXPCSSDT 00000001 BXPC 00000001)
>>> [    0.000000] ACPI: APIC 000000003ffffa23 000078 (v01 BOCHS 
>BXPCAPIC 00000001 BXPC 00000001)
>>> [    0.000000] ACPI: HPET 000000003ffffa9b 000038 (v01 BOCHS 
>BXPCHPET 00000001 BXPC 00000001)
>>> [    0.000000] ACPI: Local APIC address 0xfee00000
>>> [    0.000000]  [ffffea0000000000-ffffea0000ffffff] PMD ->
>[ffff88003e600000-ffff88003f5fffff] on node 0
>>> [    0.000000] Zone ranges:
>>> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
>>> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
>>> [    0.000000]   Normal   empty
>>> [    0.000000] Movable zone start for each node
>>> [    0.000000] Early memory node ranges
>>> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
>>> [    0.000000]   node   0: [mem 0x00100000-0x3fffdfff]
>>> [    0.000000] On node 0 totalpages: 262044
>>> [    0.000000]   DMA zone: 64 pages used for memmap
>>> [    0.000000]   DMA zone: 21 pages reserved
>>> [    0.000000]   DMA zone: 3998 pages, LIFO batch:0
>>> [    0.000000]   DMA32 zone: 4032 pages used for memmap
>>> [    0.000000]   DMA32 zone: 258046 pages, LIFO batch:31
>>> [    0.000000] ACPI: PM-Timer IO Port: 0xb008
>>> [    0.000000] ACPI: Local APIC address 0xfee00000
>>> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
>>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
>>> [    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000]
>gsi_base[0])
>>> [    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000,
>GSI 0-23
>>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl
>dfl)
>>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high
>level)
>>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high
>level)
>>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10
>high level)
>>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11
>high level)
>>> [    0.000000] ACPI: IRQ0 used by override.
>>> [    0.000000] ACPI: IRQ2 used by override.
>>> [    0.000000] ACPI: IRQ5 used by override.
>>> [    0.000000] ACPI: IRQ9 used by override.
>>> [    0.000000] ACPI: IRQ10 used by override.
>>> [    0.000000] ACPI: IRQ11 used by override.
>>> [    0.000000] Using ACPI (MADT) for SMP configuration information
>>> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
>>> [    0.000000] nr_irqs_gsi: 40
>>> [    0.000000] e820: [mem 0x40000000-0xfeffbfff] available for PCI
>devices
>>> [    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
>>> [    0.000000] pcpu-alloc: [0] 0
>>> [    0.000000] Built 1 zonelists in Zone order, mobility grouping
>on.  Total pages: 257927
>>> [    0.000000] Kernel command line: console=ttyS0 loglevel=8
>>> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
>>> [    0.000000] Dentry cache hash table entries: 131072 (order: 8,
>1048576 bytes)
>>> [    0.000000] Inode-cache hash table entries: 65536 (order: 7,
>524288 bytes)
>>> [    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
>>> [    0.000000] Memory: 1020072K/1048176K available (2567K kernel
>code, 332K rwdata, 704K rodata, 3052K init, 424K bss, 28104K reserved)
>>> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1,
>Nodes=1
>>> [    0.000000] NR_IRQS:4352 nr_irqs:256 16
>>> [    0.000000] Console: colour VGA+ 80x25
>>> [    0.000000] console [ttyS0] enabled
>>> [    0.000000] hpet clockevent registered
>>> [    0.000000] tsc: Fast TSC calibration using PIT
>>> [    0.000000] tsc: Detected 3392.306 MHz processor
>>> [    0.008008] Calibrating delay loop (skipped), value calculated
>using timer frequency.. 6784.61 BogoMIPS (lpj=13569224)
>>> [    0.009740] pid_max: default: 32768 minimum: 301
>>> [    0.010391] ACPI: Core revision 20131218
>>> [    0.012206] ACPI: All ACPI Tables successfully acquired
>>> [    0.013024] Mount-cache hash table entries: 256
>>> [    0.013776] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
>>> [    0.013776] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB
>0
>>> [    0.013776] tlb_flushall_shift: 2
>>> [    0.016002] CPU: Intel(R) Core(TM) i7-3770 CPU @ 3.40GHz (fam:
>06, model: 3a, stepping: 09)
>>> [    0.017519] Performance Events: 16-deep LBR, IvyBridge events,
>Intel PMU driver.
>>> [    0.018732] ... version:                2
>>> [    0.019362] ... bit width:              48
>>> [    0.020002] ... generic registers:      4
>>> [    0.020574] ... value mask:             0000ffffffffffff
>>> [    0.021324] ... max period:             000000007fffffff
>>> [    0.022096] ... fixed-purpose events:   3
>>> [    0.022664] ... event mask:             000000070000000f
>>> [    0.024000] general protection fault: 0000 [#1]
>>> [    0.024000] CPU: 0 PID: 1 Comm: swapper Not tainted
>3.14.0-rc7-qemu-00059-g08edb33 #14
>>> [    0.024000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
>>> [    0.024000] task: ffff88003e050000 ti: ffff88003e054000 task.ti:
>ffff88003e054000
>>> [    0.024000] RIP: 0010:[<ffffffff8101148a>]  [<ffffffff8101148a>]
>intel_pmu_lbr_reset+0x2a/0x80
>>> [    0.024000] RSP: 0000:ffff88003e055e78  EFLAGS: 00000002
>>> [    0.024000] RAX: 0000000000000000 RBX: 0000000000000286 RCX:
>0000000000000680
>>> [    0.024000] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
>0000000000000000
>>> [    0.024000] RBP: ffffffff81622120 R08: ffff88003ffee0e0 R09:
>ffff88003e00bf00
>>> [    0.024000] R10: 0000000000000000 R11: 0000000000000004 R12:
>0000000000000000
>>> [    0.024000] R13: 0000000000000000 R14: 0000000000000000 R15:
>0000000000000000
>>> [    0.024000] FS:  0000000000000000(0000) GS:ffffffff8161e000(0000)
>knlGS:0000000000000000
>>> [    0.024000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [    0.024000] CR2: ffff8800019bb000 CR3: 0000000001611000 CR4:
>00000000001407b0
>>> [    0.024000] Stack:
>>> [    0.024000]  ffffffff8101308a ffffffff8100e3da ffffffff8165ba62
>0000000000000000
>>> [    0.024000]  ffffffff8165b5bd 0000000000000000 0000000000000000
>0000000000000000
>>> [    0.024000]  ffffffff81655dcd 0000000000000000 0000000000000000
>0000000000000000
>>> [    0.024000] Call Trace:
>>> [    0.024000]  [<ffffffff8101308a>] ?
>intel_pmu_cpu_starting+0xa/0x80
>>> [    0.024000]  [<ffffffff8100e3da>] ? x86_pmu_notifier+0x5a/0xc0
>>> [    0.024000]  [<ffffffff8165ba62>] ?
>init_hw_perf_events+0x4a5/0x4dd
>>> [    0.024000]  [<ffffffff8165b5bd>] ? check_bugs+0x42/0x42
>>> [    0.024000]  [<ffffffff81655dcd>] ? do_one_initcall+0x76/0xf9
>>> [    0.024000]  [<ffffffff81276b70>] ? rest_init+0x70/0x70
>>> [    0.024000]  [<ffffffff81655ea7>] ?
>kernel_init_freeable+0x57/0x177
>>> [    0.024000]  [<ffffffff81276b70>] ? rest_init+0x70/0x70
>>> [    0.024000]  [<ffffffff81276b75>] ? kernel_init+0x5/0xe0
>>> [    0.024000]  [<ffffffff8128067a>] ? ret_from_fork+0x7a/0xb0
>>> [    0.024000]  [<ffffffff81276b70>] ? rest_init+0x70/0x70
>>> [    0.024000] Code: 00 8b 15 02 c4 63 00 85 d2 74 69 f6 05 af c3 63
>00 3f 75 2d 85 d2 7e 5c 31 f6 31 c0 0f 1f 44 00 00 8b 0d d2 c3 63 00 89
>c2 01 f1 <0f> 30 83 c6 01 3b 35 d3 c3 63 00 7c e9 f3 c3 0f 1f 80 00 00
>00
>>> [    0.024000] RIP  [<ffffffff8101148a>]
>intel_pmu_lbr_reset+0x2a/0x80
>>> [    0.024000]  RSP <ffff88003e055e78>
>>> [    0.024000] ---[ end trace ecbd794f78441b2c ]---
>>> [    0.024002] Kernel panic - not syncing: Attempted to kill init!
>exitcode=0x0000000b
>
>When -cpu host is used, qemu/kvm passed the host CPUID F/M/S to the
>guest. intel_pmu_cpu_*() -> intel_pmu_lbr_reset() uses rdmsr() /
>wrmsr(), rather than the safe variants; if KVM does not support the
>particular MSRs in question, you will see a #GP(0) there. See
>https://lkml.org/lkml/2014/3/13/453 for a similar bug other PMU code.
>
>HTH,
>-- vs;

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
