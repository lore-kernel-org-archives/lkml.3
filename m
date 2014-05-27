Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaE0P13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:27:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:51119 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbaE0P11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:27:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,920,1392192000"; 
   d="scan'208";a="437392533"
Message-ID: <5384AEC0.9010808@intel.com>
Date: Tue, 27 May 2014 23:26:56 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Rob Herring <robh@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [pci] BUG: unable to handle kernel NULL pointer dereference at
 00000000000000c8
References: <53843393.3070801@intel.com> <20140527091553.GC23120@e106497-lin.cambridge.arm.com>
In-Reply-To: <20140527091553.GC23120@e106497-lin.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for disturbing. I guess your commit was merge by other one then we got it again. Nothing changed since then. Feel sorry about this noise.

On 05/27/2014 05:15 PM, Liviu Dudau wrote:
> Jet,
> 
> I have replied two months ago with a patch and you have confirmed that the patch was
> sufficient to pas your tests. Has anything changed since then?
> 
> Best regards,
> Liviu
> 
> On Tue, May 27, 2014 at 07:41:23AM +0100, Jet Chen wrote:
>> Hi Liviu,
>>
>> 0day kernel testing robot got the below dmesg and the first bad commit is
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux versatile-mulitplatform
>> commit d4432d13bf37e7adc09ccf1100e8d22066ab3eb7
>> Author:     Liviu Dudau <Liviu.Dudau@arm.com>
>> AuthorDate: Fri Mar 14 15:34:29 2014 +0000
>> Commit:     Rob Herring <robh@kernel.org>
>> CommitDate: Wed May 21 15:29:31 2014 -0500
>>
>>     pci: Create pci_host_bridge before its associated bus in pci_create_root_bus.
>>         Before commit 7b5436635800 the pci_host_bridge was created before the root bus.
>>     As that commit has added a needless dependency on the bus for pci_alloc_host_bridge()
>>     the creation order has been changed for no good reason. Revert the order of
>>     creation as we are going to depend on the pci_host_bridge structure to retrieve the
>>     domain number of the root bus.
>>         Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
>>     Acked-by: Grant Likely <grant.likely@linaro.org>
>>     Tested-by: Tanmay Inamdar <tinamdar@apm.com>
>>
>> +------------------------------------------------------+------------+------------+
>> |                                                      | 8c64f463cf | d4432d13bf |
>> +------------------------------------------------------+------------+------------+
>> | boot_successes                                       | 60         | 0          |
>> | boot_failures                                        | 0          | 120        |
>> | BUG:unable_to_handle_kernel_NULL_pointer_dereference | 0          | 120        |
>> | Oops                                                 | 0          | 120        |
>> | RIP:pcibios_root_bridge_prepare                      | 0          | 120        |
>> | Kernel_panic-not_syncing:Fatal_exception             | 0          | 120        |
>> | backtrace:acpi_bus_scan                              | 0          | 120        |
>> | backtrace:acpi_scan_init                             | 0          | 120        |
>> | backtrace:acpi_init                                  | 0          | 120        |
>> | backtrace:kernel_init_freeable                       | 0          | 120        |
>> +------------------------------------------------------+------------+------------+
>>
>>
>> [    0.072806] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
>> [    0.073477] acpi PNP0A03:00: _OSC: OS supports [Segments]
>> [    0.074073] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
>> [    0.075212] BUG: unable to handle kernel NULL pointer dereference at 00000000000000c8
>> [    0.076055] IP: [<ffffffff812ebc2f>] pcibios_root_bridge_prepare+0xb/0x21
>> [    0.076772] PGD 0 [    0.077008] Oops: 0000 [#1] [    0.077350] Modules linked in:
>> [    0.077693] CPU: 0 PID: 1 Comm: swapper Not tainted 3.15.0-rc5-00014-gd4432d1 #7
>> [    0.078445] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
>> [    0.079029] task: ffff880000052010 ti: ffff880000054000 task.ti: ffff880000054000
>> [    0.079807] RIP: 0010:[<ffffffff812ebc2f>]  [<ffffffff812ebc2f>] pcibios_root_bridge_prepare+0xb/0x21
>> [    0.080000] RSP: 0000:ffff880000055c18  EFLAGS: 00010286
>> [    0.080000] RAX: 0000000000000000 RBX: ffff880000159440 RCX: 0000000000000400
>> [    0.080000] RDX: 00000000000002b0 RSI: ffff880000165800 RDI: ffff880000165800
>> [    0.080000] RBP: ffff880000055c18 R08: 00000000000080d0 R09: 0000000000000284
>> [    0.080000] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880000165800
>> [    0.080000] R13: 0000000000000000 R14: 0000000000000000 R15: ffff880000165a90
>> [    0.080000] FS:  0000000000000000(0000) GS:ffffffff81726000(0000) knlGS:0000000000000000
>> [    0.080000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [    0.080000] CR2: 00000000000000c8 CR3: 0000000001716000 CR4: 00000000000006b0
>> [    0.080000] Stack:
>> [    0.080000]  ffff880000055ca8 ffffffff811c4a4f ffff880000055cd0 ffff880000159470
>> [    0.080000]  ffffffff81987420 0000000000000020 ffff880000055c80 ffffffff811ac4cc
>> [    0.080000]  ffff880000055cd0 0000000000000000 0000000000000003 0000000000000003
>> [    0.080000] Call Trace:
>> [    0.080000]  [<ffffffff811c4a4f>] pci_create_root_bus+0x70/0x2ed
>> [    0.080000]  [<ffffffff811ac4cc>] ? __list_add+0x12b/0x146
>> [    0.080000]  [<ffffffff812ebb9c>] pci_acpi_scan_root+0x280/0x308
>> [    0.080000]  [<ffffffff811d9403>] acpi_pci_root_add+0x202/0x2dc
>> [    0.080000]  [<ffffffff811d686a>] acpi_bus_attach+0x8b/0x107
>> [    0.080000]  [<ffffffff8122a7f5>] ? device_attach+0x7c/0x85
>> [    0.080000]  [<ffffffff811d68cc>] acpi_bus_attach+0xed/0x107
>> [    0.080000]  [<ffffffff8122a7f5>] ? device_attach+0x7c/0x85
>> [    0.080000]  [<ffffffff811d68cc>] acpi_bus_attach+0xed/0x107
>> [    0.080000]  [<ffffffff811d693c>] acpi_bus_scan+0x56/0x66
>> [    0.080000]  [<ffffffff81a25051>] ? acpi_sleep_init+0xcc/0xcc
>> [    0.080000]  [<ffffffff81a25432>] acpi_scan_init+0x54/0x170
>> [    0.080000]  [<ffffffff81a25051>] ? acpi_sleep_init+0xcc/0xcc
>> [    0.080000]  [<ffffffff81a25240>] acpi_init+0x1ef/0x24b
>> [    0.080000]  [<ffffffff8100029b>] do_one_initcall+0x7d/0x13a
>> [    0.080000]  [<ffffffff8106d36b>] ? parse_args+0x180/0x246
>> [    0.080000]  [<ffffffff81a02f9d>] kernel_init_freeable+0x1c2/0x24e
>> [    0.080000]  [<ffffffff81a026ee>] ? do_early_param+0x8a/0x8a
>> [    0.080000]  [<ffffffff813f7a99>] ? rest_init+0xbd/0xbd
>> [    0.080000]  [<ffffffff813f7aa2>] kernel_init+0x9/0xd0
>> [    0.080000]  [<ffffffff8140b9ca>] ret_from_fork+0x7a/0xb0
>> [    0.080000]  [<ffffffff813f7a99>] ? rest_init+0xbd/0xbd
>> [    0.080000] Code: 48 c7 c7 27 12 65 81 31 c0 e8 92 b9 f3 ff 4c 89 e8 48 83 c4 28 5b 41 5c 41 5d 41 5e 41 5f 5d c3 48 8b 87 88 02 00 00 55 48 89 e5 <48> 8b 80 c8 00 00 00 5d 48 8b 40 08 48 89 87 d8 01 00 00 31 c0 [    0.080000] RIP  [<ffffffff812ebc2f>] pcibios_root_bridge_prepare+0xb/0x21
>> [    0.080000]  RSP <ffff880000055c18>
>> [    0.080000] CR2: 00000000000000c8
>> [    0.080000] ---[ end trace dbb81a2550228027 ]---
>> [    0.080000] Kernel panic - not syncing: Fatal exception
>>
>> git bisect start 7f3a02c2b0f2023dcf5dd98f2dc1524ed7b5b6c9 4b660a7f5c8099d88d1a43d8ae138965112592c7 --
>> git bisect good 4ed78930ecdc36fcb82d5de534c201593b8e228b  # 23:29     20+      0  Merge 'mvebu/mvebu/soc' into devel-cairo-x86_64-201405222248
>> git bisect good 52c86ac98d407f77d28b3cfec2a6095eeb796427  # 23:35     20+      0  Merge 'drm-intel/drm-intel-nightly' into devel-cairo-x86_64-201405222248
>> git bisect  bad ee958e5c81d886293628b6742e8b6d6c2900397c  # 23:49      0-     20  Merge 'robh/versatile-multiplatform' into devel-cairo-x86_64-201405222248
>> git bisect  bad f5305fb856fa29122994db5031ab781be4b2cb5d  # 00:12      0-     20  pci: Add support for creating a generic host_bridge from device tree
>> git bisect good 9968eb62ded650fb932a516a2a0ebce133b454fd  # 00:26     20+      0  dt/bindings: add compatible string for versatile osc clock
>> git bisect good cfb6a908184516c1337c9eb28c76235b42d55a2b  # 00:33     20+      0  pci: Introduce pci_register_io_range() helper function.
>> git bisect  bad d4432d13bf37e7adc09ccf1100e8d22066ab3eb7  # 00:42      0-     20  pci: Create pci_host_bridge before its associated bus in pci_create_root_bus.
>> git bisect good 8c64f463cf0babd75b7cc65517bb25e7c70bb5ed  # 00:56     20+      0  pci: OF: Fix the conversion of IO ranges into IO resources.
>> # first bad commit: [d4432d13bf37e7adc09ccf1100e8d22066ab3eb7] pci: Create pci_host_bridge before its associated bus in pci_create_root_bus.
>> git bisect good 8c64f463cf0babd75b7cc65517bb25e7c70bb5ed  # 00:58     60+      0  pci: OF: Fix the conversion of IO ranges into IO resources.
>> git bisect  bad 7f3a02c2b0f2023dcf5dd98f2dc1524ed7b5b6c9  # 00:58      0-     13  0day head guard for 'devel-cairo-x86_64-201405222248'
>> git bisect good 4b660a7f5c8099d88d1a43d8ae138965112592c7  # 01:01     60+      0  Linux 3.15-rc6
>> git bisect good 542a6299c6a30caaba4b9a3834fbc3f6f2bf959d  # 01:05     60+      0  Add linux-next specific files for 20140522
>>
>>
>> This script may reproduce the error.
>>
>> -----------------------------------------------------------------------------
>> #!/bin/bash
>>
>> kernel=$1
>>
>> kvm=(
>> 	qemu-system-x86_64 -cpu kvm64 -enable-kvm 	
>> 	-kernel $kernel
>> 	-smp 2
>> 	-m 256M
>> 	-net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio
>> 	-net user,vlan=0
>> 	-net nic,vlan=1,model=e1000
>> 	-net user,vlan=1
>> 	-boot order=nc
>> 	-no-reboot
>> 	-watchdog i6300esb
>> 	-serial stdio
>> 	-display none
>> 	-monitor null
>> )
>>
>> append=(
>> 	debug
>> 	sched_debug
>> 	apic=debug
>> 	ignore_loglevel
>> 	sysrq_always_enabled
>> 	panic=10
>> 	prompt_ramdisk=0
>> 	earlyprintk=ttyS0,115200
>> 	console=ttyS0,115200
>> 	console=tty0
>> 	vga=normal
>> 	root=/dev/ram0
>> 	rw
>> )
>>
>> "${kvm[@]}" --append "${append[*]}"
>> -----------------------------------------------------------------------------
>>
>> Thanks,
>> Jet
> 
>> early console in setup code
>> Probing EDD (edd=off to disable)... ok
>> [    0.000000] Initializing cgroup subsys cpuset
>> [    0.000000] Initializing cgroup subsys cpu
>> [    0.000000] Linux version 3.15.0-rc5-00014-gd4432d1 (kbuild@cairo) (gcc version 4.8.2 (Debian 4.8.2-18) ) #7 Fri May 23 00:41:13 CST 2014
>> [    0.000000] Command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-c0-0522/linux-devel:devel-cairo-x86_64-201405222248:d4432d13bf37e7adc09ccf1100e8d22066ab3eb7:bisect-linux5/.vmlinuz-d4432d13bf37e7adc09ccf1100e8d22066ab3eb7-20140523004131-6-ivb41 branch=linux-devel/devel-cairo-x86_64-201405222248 BOOT_IMAGE=/kernel/x86_64-randconfig-c0-0522/d4432d13bf37e7adc09ccf1100e8d22066ab3eb7/vmlinuz-3.15.0-rc5-00014-gd4432d1 drbd.minor_count=8
>> [    0.000000] KERNEL supported cpus:
>> [    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
>> [    0.000000] CPU: Your system may be unstable.
>> [    0.000000] e820: BIOS-provided physical RAM map:
>> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
>> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
>> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
>> [    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
>> [    0.000000] NX (Execute Disable) protection: active
>> [    0.000000] SMBIOS 2.4 present.
>> [    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
>> [    0.000000] Hypervisor detected: KVM
>> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
>> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
>> [    0.000000] e820: last_pfn = 0x13ffe max_arch_pfn = 0x400000000
>> [    0.000000] MTRR default type: write-back
>> [    0.000000] MTRR fixed ranges enabled:
>> [    0.000000]   00000-9FFFF write-back
>> [    0.000000]   A0000-BFFFF uncachable
>> [    0.000000]   C0000-FFFFF write-protect
>> [    0.000000] MTRR variable ranges enabled:
>> [    0.000000]   0 base 0080000000 mask FF80000000 uncachable
>> [    0.000000]   1 disabled
>> [    0.000000]   2 disabled
>> [    0.000000]   3 disabled
>> [    0.000000]   4 disabled
>> [    0.000000]   5 disabled
>> [    0.000000]   6 disabled
>> [    0.000000]   7 disabled
>> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
>> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
>> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
>> [    0.000000] BRK [0x0253d000, 0x0253dfff] PGTABLE
>> [    0.000000] BRK [0x0253e000, 0x0253efff] PGTABLE
>> [    0.000000] BRK [0x0253f000, 0x0253ffff] PGTABLE
>> [    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
>> [    0.000000]  [mem 0x13a00000-0x13bfffff] page 2M
>> [    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
>> [    0.000000]  [mem 0x10000000-0x139fffff] page 2M
>> [    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
>> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
>> [    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
>> [    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
>> [    0.000000]  [mem 0x13c00000-0x13dfffff] page 2M
>> [    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
>> [    0.000000] BRK [0x02540000, 0x02540fff] PGTABLE
>> [    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
>> [    0.000000] ACPI: RSDP 0x00000000000FD950 000014 (v00 BOCHS )
>> [    0.000000] ACPI: RSDT 0x0000000013FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
>> [    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
>> [    0.000000] ACPI: DSDT 0x0000000013FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 INTL 20100528)
>> [    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
>> [    0.000000] ACPI: SSDT 0x0000000013FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
>> [    0.000000] ACPI: APIC 0x0000000013FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
>> [    0.000000] ACPI: HPET 0x0000000013FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
>> [    0.000000] ACPI: Local APIC address 0xfee00000
>> [    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
>> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
>> [    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
>> [    0.000000] Zone ranges:
>> [    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
>> [    0.000000]   Normal   empty
>> [    0.000000] Movable zone start for each node
>> [    0.000000] Early memory node ranges
>> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
>> [    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
>> [    0.000000] On node 0 totalpages: 81820
>> [    0.000000]   DMA32 zone: 1120 pages used for memmap
>> [    0.000000]   DMA32 zone: 21 pages reserved
>> [    0.000000]   DMA32 zone: 81820 pages, LIFO batch:15
>> [    0.000000] ACPI: PM-Timer IO Port: 0xb008
>> [    0.000000] ACPI: Local APIC address 0xfee00000
>> [    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
>> [    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1/0x1 ignored.
>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
>> [    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
>> [    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
>> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
>> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC INT 05
>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
>> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
>> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
>> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
>> [    0.000000] ACPI: IRQ0 used by override.
>> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
>> [    0.000000] ACPI: IRQ2 used by override.
>> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
>> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
>> [    0.000000] ACPI: IRQ5 used by override.
>> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
>> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
>> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
>> [    0.000000] ACPI: IRQ9 used by override.
>> [    0.000000] ACPI: IRQ10 used by override.
>> [    0.000000] ACPI: IRQ11 used by override.
>> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
>> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
>> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
>> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
>> [    0.000000] Using ACPI (MADT) for SMP configuration information
>> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
>> [    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
>> [    0.000000] nr_irqs_gsi: 40
>> [    0.000000] KVM setup async PF for cpu 0
>> [    0.000000] kvm-stealtime: cpu 0, msr 172dc00
>> [    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
>> [    0.000000] Booting paravirtualized kernel on KVM
>> [    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
>> [    0.000000] pcpu-alloc: [0] 0 
>> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 80679
>> [    0.000000] Kernel command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-c0-0522/linux-devel:devel-cairo-x86_64-201405222248:d4432d13bf37e7adc09ccf1100e8d22066ab3eb7:bisect-linux5/.vmlinuz-d4432d13bf37e7adc09ccf1100e8d22066ab3eb7-20140523004131-6-ivb41 branch=linux-devel/devel-cairo-x86_64-201405222248 BOOT_IMAGE=/kernel/x86_64-randconfig-c0-0522/d4432d13bf37e7adc09ccf1100e8d22066ab3eb7/vmlinuz-3.15.0-rc5-00014-gd4432d1 drbd.minor_count=8
>> [    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
>> [    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
>> [    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
>> [    0.000000] Memory: 296056K/327280K available (4149K kernel code, 3068K rwdata, 3020K rodata, 724K init, 10772K bss, 31224K reserved)
>> [    0.000000] NR_IRQS:4352 nr_irqs:256 16
>> [    0.000000] console [ttyS0] enabled
>> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
>> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
>> [    0.000000] ... MAX_LOCK_DEPTH:          48
>> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
>> [    0.000000] ... CLASSHASH_SIZE:          4096
>> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
>> [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
>> [    0.000000] ... CHAINHASH_SIZE:          16384
>> [    0.000000]  memory used by lock dependency info: 6367 kB
>> [    0.000000]  per task-struct memory footprint: 2688 bytes
>> [    0.000000] ------------------------
>> [    0.000000] | Locking API testsuite:
>> [    0.000000] ----------------------------------------------------------------------------
>> [    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
>> [    0.000000]   --------------------------------------------------------------------------
>> [    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>> [    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>> [    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>> [    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>> [    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>> [    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>> [    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>> [    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>> [    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>> [    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>> [    0.000000]   --------------------------------------------------------------------------
>> [    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
>> [    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
>> [    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
>> [    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
>> [    0.000000]   --------------------------------------------------------------------------
>> [    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
>> [    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
>> [    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
>> [    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
>> [    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
>> [    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
>> [    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
>> [    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
>> [    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
>> [    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
>> [    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
>> [    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
>> [    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
>> [    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
>> [    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
>> [    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
>> [    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
>> [    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
>> [    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
>> [    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
>> [    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
>> [    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
>> [    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
>> [    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
>> [    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
>> [    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
>> [    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
>> [    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
>> [    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
>> [    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
>> [    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
>> [    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
>> [    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
>> [    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
>> [    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
>> [    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
>> [    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
>> [    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
>> [    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
>> [    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
>> [    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
>> [    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
>> [    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
>> [    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
>> [    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
>> [    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
>> [    0.000000]       hard-irq read-recursion/123:  ok  |
>> [    0.000000]       soft-irq read-recursion/123:  ok  |
>> [    0.000000]       hard-irq read-recursion/132:  ok  |
>> [    0.000000]       soft-irq read-recursion/132:  ok  |
>> [    0.000000]       hard-irq read-recursion/213:  ok  |
>> [    0.000000]       soft-irq read-recursion/213:  ok  |
>> [    0.000000]       hard-irq read-recursion/231:  ok  |
>> [    0.000000]       soft-irq read-recursion/231:  ok  |
>> [    0.000000]       hard-irq read-recursion/312:  ok  |
>> [    0.000000]       soft-irq read-recursion/312:  ok  |
>> [    0.000000]       hard-irq read-recursion/321:  ok  |
>> [    0.000000]       soft-irq read-recursion/321:  ok  |
>> [    0.000000]   --------------------------------------------------------------------------
>> [    0.000000]   | Wound/wait tests |
>> [    0.000000]   ---------------------
>> [    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
>> [    0.000000]                ww contexts mixing:  ok  |  ok  |
>> [    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok  |
>> [    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
>> [    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>> [    0.000000]            spinlock nest unlocked:  ok  |
>> [    0.000000]   -----------------------------------------------------
>> [    0.000000]                                  |block | try  |context|
>> [    0.000000]   -----------------------------------------------------
>> [    0.000000]                           context:  ok  |  ok  |  ok  |
>> [    0.000000]                               try:  ok  |  ok  |  ok  |
>> [    0.000000]                             block:  ok  |  ok  |  ok  |
>> [    0.000000]                          spinlock:  ok  |  ok  |  ok  |
>> [    0.000000] -------------------------------------------------------
>> [    0.000000] Good, all 253 testcases passed! |
>> [    0.000000] ---------------------------------
>> [    0.000000] ODEBUG: 8 of 8 active objects replaced
>> [    0.000000] ODEBUG: selftest passed
>> [    0.000000] hpet clockevent registered
>> [    0.000000] tsc: Detected 2693.414 MHz processor
>> [    0.020000] Calibrating delay loop (skipped) preset value.. 5386.82 BogoMIPS (lpj=26934140)
>> [    0.020000] pid_max: default: 32768 minimum: 301
>> [    0.020000] ACPI: Core revision 20140214
>> [    0.020000] ACPI: All ACPI Tables successfully acquired
>> [    0.020000] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
>> [    0.020000] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 bytes)
>> [    0.020000] Initializing cgroup subsys debug
>> [    0.020000] Initializing cgroup subsys devices
>> [    0.020000] Initializing cgroup subsys net_cls
>> [    0.020000] Initializing cgroup subsys hugetlb
>> [    0.020059] mce: CPU supports 10 MCE banks
>> [    0.020445] mce: unknown CPU type - not enabling MCE support
>> [    0.020954] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
>> [    0.020954] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
>> [    0.020954] tlb_flushall_shift: -1
>> [    0.022263] CPU: GenuineIntel Common KVM processor (fam: 0f, model: 06, stepping: 01)
>> [    0.023995] Performance Events: no PMU driver, software events only.
>> [    0.025641] Getting VERSION: 50014
>> [    0.025967] Getting VERSION: 50014
>> [    0.026287] Getting ID: 0
>> [    0.026535] Getting ID: ff000000
>> [    0.026835] Getting LVT0: 8700
>> [    0.027127] Getting LVT1: 8400
>> [    0.027427] enabled ExtINT on CPU#0
>> [    0.028439] ENABLING IO-APIC IRQs
>> [    0.028747] init IO_APIC IRQs
>> [    0.029019]  apic 0 pin 0 not connected
>> [    0.029388] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
>> [    0.030025] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
>> [    0.030743] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
>> [    0.031469] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
>> [    0.032196] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
>> [    0.032915] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
>> [    0.033639] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
>> [    0.034373] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
>> [    0.035100] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
>> [    0.035815] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
>> [    0.036557] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
>> [    0.037294] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
>> [    0.038040] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
>> [    0.038772] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
>> [    0.040022] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
>> [    0.040757]  apic 0 pin 16 not connected
>> [    0.041111]  apic 0 pin 17 not connected
>> [    0.041472]  apic 0 pin 18 not connected
>> [    0.041825]  apic 0 pin 19 not connected
>> [    0.042176]  apic 0 pin 20 not connected
>> [    0.042536]  apic 0 pin 21 not connected
>> [    0.042892]  apic 0 pin 22 not connected
>> [    0.043244]  apic 0 pin 23 not connected
>> [    0.043745] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
>> [    0.044363] Using local APIC timer interrupts.
>> [    0.044363] calibrating APIC timer ...
>> [    0.050000] ... lapic delta = 6250236
>> [    0.050000] ... PM-Timer delta = 357996
>> [    0.050000] ... PM-Timer result ok
>> [    0.050000] ..... delta 6250236
>> [    0.050000] ..... mult: 268445592
>> [    0.050000] ..... calibration result: 10000377
>> [    0.050000] ..... CPU clock speed is 2693.7589 MHz.
>> [    0.050000] ..... host bus clock speed is 1000.0377 MHz.
>> [    0.050000] devtmpfs: initialized
>> [    0.050000] atomic64 test passed for x86-64 platform with CX8 and with SSE
>> [    0.050000] regulator-dummy: no parameters
>> [    0.050000] NET: Registered protocol family 16
>> [    0.050000] cpuidle: using governor ladder
>> [    0.050000] cpuidle: using governor menu
>> [    0.050000] ACPI: bus type PCI registered
>> [    0.050000] PCI: Using configuration type 1 for base access
>> [    0.051081] ACPI: Added _OSI(Module Device)
>> [    0.051553] ACPI: Added _OSI(Processor Device)
>> [    0.052018] ACPI: Added _OSI(3.0 _SCP Extensions)
>> [    0.052514] ACPI: Added _OSI(Processor Aggregator Device)
>> [    0.060719] ACPI: Interpreter enabled
>> [    0.061140] ACPI: (supports S0 S5)
>> [    0.061501] ACPI: Using IOAPIC for interrupt routing
>> [    0.062043] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
>> [    0.072806] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
>> [    0.073477] acpi PNP0A03:00: _OSC: OS supports [Segments]
>> [    0.074073] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
>> [    0.075212] BUG: unable to handle kernel NULL pointer dereference at 00000000000000c8
>> [    0.076055] IP: [<ffffffff812ebc2f>] pcibios_root_bridge_prepare+0xb/0x21
>> [    0.076772] PGD 0 
>> [    0.077008] Oops: 0000 [#1] 
>> [    0.077350] Modules linked in:
>> [    0.077693] CPU: 0 PID: 1 Comm: swapper Not tainted 3.15.0-rc5-00014-gd4432d1 #7
>> [    0.078445] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
>> [    0.079029] task: ffff880000052010 ti: ffff880000054000 task.ti: ffff880000054000
>> [    0.079807] RIP: 0010:[<ffffffff812ebc2f>]  [<ffffffff812ebc2f>] pcibios_root_bridge_prepare+0xb/0x21
>> [    0.080000] RSP: 0000:ffff880000055c18  EFLAGS: 00010286
>> [    0.080000] RAX: 0000000000000000 RBX: ffff880000159440 RCX: 0000000000000400
>> [    0.080000] RDX: 00000000000002b0 RSI: ffff880000165800 RDI: ffff880000165800
>> [    0.080000] RBP: ffff880000055c18 R08: 00000000000080d0 R09: 0000000000000284
>> [    0.080000] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880000165800
>> [    0.080000] R13: 0000000000000000 R14: 0000000000000000 R15: ffff880000165a90
>> [    0.080000] FS:  0000000000000000(0000) GS:ffffffff81726000(0000) knlGS:0000000000000000
>> [    0.080000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [    0.080000] CR2: 00000000000000c8 CR3: 0000000001716000 CR4: 00000000000006b0
>> [    0.080000] Stack:
>> [    0.080000]  ffff880000055ca8 ffffffff811c4a4f ffff880000055cd0 ffff880000159470
>> [    0.080000]  ffffffff81987420 0000000000000020 ffff880000055c80 ffffffff811ac4cc
>> [    0.080000]  ffff880000055cd0 0000000000000000 0000000000000003 0000000000000003
>> [    0.080000] Call Trace:
>> [    0.080000]  [<ffffffff811c4a4f>] pci_create_root_bus+0x70/0x2ed
>> [    0.080000]  [<ffffffff811ac4cc>] ? __list_add+0x12b/0x146
>> [    0.080000]  [<ffffffff812ebb9c>] pci_acpi_scan_root+0x280/0x308
>> [    0.080000]  [<ffffffff811d9403>] acpi_pci_root_add+0x202/0x2dc
>> [    0.080000]  [<ffffffff811d686a>] acpi_bus_attach+0x8b/0x107
>> [    0.080000]  [<ffffffff8122a7f5>] ? device_attach+0x7c/0x85
>> [    0.080000]  [<ffffffff811d68cc>] acpi_bus_attach+0xed/0x107
>> [    0.080000]  [<ffffffff8122a7f5>] ? device_attach+0x7c/0x85
>> [    0.080000]  [<ffffffff811d68cc>] acpi_bus_attach+0xed/0x107
>> [    0.080000]  [<ffffffff811d693c>] acpi_bus_scan+0x56/0x66
>> [    0.080000]  [<ffffffff81a25051>] ? acpi_sleep_init+0xcc/0xcc
>> [    0.080000]  [<ffffffff81a25432>] acpi_scan_init+0x54/0x170
>> [    0.080000]  [<ffffffff81a25051>] ? acpi_sleep_init+0xcc/0xcc
>> [    0.080000]  [<ffffffff81a25240>] acpi_init+0x1ef/0x24b
>> [    0.080000]  [<ffffffff8100029b>] do_one_initcall+0x7d/0x13a
>> [    0.080000]  [<ffffffff8106d36b>] ? parse_args+0x180/0x246
>> [    0.080000]  [<ffffffff81a02f9d>] kernel_init_freeable+0x1c2/0x24e
>> [    0.080000]  [<ffffffff81a026ee>] ? do_early_param+0x8a/0x8a
>> [    0.080000]  [<ffffffff813f7a99>] ? rest_init+0xbd/0xbd
>> [    0.080000]  [<ffffffff813f7aa2>] kernel_init+0x9/0xd0
>> [    0.080000]  [<ffffffff8140b9ca>] ret_from_fork+0x7a/0xb0
>> [    0.080000]  [<ffffffff813f7a99>] ? rest_init+0xbd/0xbd
>> [    0.080000] Code: 48 c7 c7 27 12 65 81 31 c0 e8 92 b9 f3 ff 4c 89 e8 48 83 c4 28 5b 41 5c 41 5d 41 5e 41 5f 5d c3 48 8b 87 88 02 00 00 55 48 89 e5 <48> 8b 80 c8 00 00 00 5d 48 8b 40 08 48 89 87 d8 01 00 00 31 c0 
>> [    0.080000] RIP  [<ffffffff812ebc2f>] pcibios_root_bridge_prepare+0xb/0x21
>> [    0.080000]  RSP <ffff880000055c18>
>> [    0.080000] CR2: 00000000000000c8
>> [    0.080000] ---[ end trace dbb81a2550228027 ]---
>> [    0.080000] Kernel panic - not syncing: Fatal exception
>> [    0.080000] Rebooting in 10 seconds..
>> Elapsed time: 5
>> qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig-c0-0522/d4432d13bf37e7adc09ccf1100e8d22066ab3eb7/vmlinuz-3.15.0-rc5-00014-gd4432d1 -append 'hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-c0-0522/linux-devel:devel-cairo-x86_64-201405222248:d4432d13bf37e7adc09ccf1100e8d22066ab3eb7:bisect-linux5/.vmlinuz-d4432d13bf37e7adc09ccf1100e8d22066ab3eb7-20140523004131-6-ivb41 branch=linux-devel/devel-cairo-x86_64-201405222248 BOOT_IMAGE=/kernel/x86_64-randconfig-c0-0522/d4432d13bf37e7adc09ccf1100e8d22066ab3eb7/vmlinuz-3.15.0-rc5-00014-gd4432d1 drbd.minor_count=8'  -initrd /kernel-tests/initrd/yocto-minimal-x86_64.cgz -m 320 -smp 2 -net nic,vlan=1,model=e1000 -net user,vlan=1 -boot order=nc -no-reboot -watchdog i6300esb -r
tc base=localtime -pidfile /dev/shm/kboot/pid-yocto-ivb41-22 -serial file:/dev/shm/kboot/serial-yocto-ivb41-22 -daemonize -display none -monitor null 
>>
>>
> 
> 
>> #
>> # Automatically generated file; DO NOT EDIT.
>> # Linux/x86_64 3.15.0-rc5 Kernel Configuration
>> #
>> CONFIG_64BIT=y
>> CONFIG_X86_64=y
>> CONFIG_X86=y
>> CONFIG_INSTRUCTION_DECODER=y
>> CONFIG_OUTPUT_FORMAT="elf64-x86-64"
>> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
>> CONFIG_LOCKDEP_SUPPORT=y
>> CONFIG_STACKTRACE_SUPPORT=y
>> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
>> CONFIG_MMU=y
>> CONFIG_NEED_DMA_MAP_STATE=y
>> CONFIG_NEED_SG_DMA_LENGTH=y
>> CONFIG_GENERIC_BUG=y
>> CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
>> CONFIG_GENERIC_HWEIGHT=y
>> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
>> CONFIG_GENERIC_CALIBRATE_DELAY=y
>> CONFIG_ARCH_HAS_CPU_RELAX=y
>> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
>> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
>> CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
>> CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
>> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
>> CONFIG_ARCH_SUSPEND_POSSIBLE=y
>> CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
>> CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
>> CONFIG_ZONE_DMA32=y
>> CONFIG_AUDIT_ARCH=y
>> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
>> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
>> CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
>> CONFIG_ARCH_SUPPORTS_UPROBES=y
>> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
>> CONFIG_CONSTRUCTORS=y
>> CONFIG_IRQ_WORK=y
>> CONFIG_BUILDTIME_EXTABLE_SORT=y
>>
>> #
>> # General setup
>> #
>> CONFIG_BROKEN_ON_SMP=y
>> CONFIG_INIT_ENV_ARG_LIMIT=32
>> CONFIG_CROSS_COMPILE=""
>> CONFIG_COMPILE_TEST=y
>> CONFIG_LOCALVERSION=""
>> CONFIG_LOCALVERSION_AUTO=y
>> CONFIG_HAVE_KERNEL_GZIP=y
>> CONFIG_HAVE_KERNEL_BZIP2=y
>> CONFIG_HAVE_KERNEL_LZMA=y
>> CONFIG_HAVE_KERNEL_XZ=y
>> CONFIG_HAVE_KERNEL_LZO=y
>> CONFIG_HAVE_KERNEL_LZ4=y
>> # CONFIG_KERNEL_GZIP is not set
>> # CONFIG_KERNEL_BZIP2 is not set
>> CONFIG_KERNEL_LZMA=y
>> # CONFIG_KERNEL_XZ is not set
>> # CONFIG_KERNEL_LZO is not set
>> # CONFIG_KERNEL_LZ4 is not set
>> CONFIG_DEFAULT_HOSTNAME="(none)"
>> # CONFIG_SYSVIPC is not set
>> # CONFIG_POSIX_MQUEUE is not set
>> CONFIG_FHANDLE=y
>> # CONFIG_USELIB is not set
>> CONFIG_AUDIT=y
>> CONFIG_HAVE_ARCH_AUDITSYSCALL=y
>> CONFIG_AUDITSYSCALL=y
>> CONFIG_AUDIT_WATCH=y
>> CONFIG_AUDIT_TREE=y
>>
>> #
>> # IRQ subsystem
>> #
>> CONFIG_GENERIC_IRQ_PROBE=y
>> CONFIG_GENERIC_IRQ_SHOW=y
>> CONFIG_IRQ_DOMAIN=y
>> CONFIG_IRQ_DOMAIN_DEBUG=y
>> CONFIG_IRQ_FORCED_THREADING=y
>> CONFIG_SPARSE_IRQ=y
>> CONFIG_CLOCKSOURCE_WATCHDOG=y
>> CONFIG_ARCH_CLOCKSOURCE_DATA=y
>> CONFIG_GENERIC_TIME_VSYSCALL=y
>> CONFIG_GENERIC_CLOCKEVENTS=y
>> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
>> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
>> CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
>> CONFIG_GENERIC_CMOS_UPDATE=y
>>
>> #
>> # Timers subsystem
>> #
>> CONFIG_TICK_ONESHOT=y
>> CONFIG_NO_HZ_COMMON=y
>> # CONFIG_HZ_PERIODIC is not set
>> CONFIG_NO_HZ_IDLE=y
>> CONFIG_NO_HZ=y
>> # CONFIG_HIGH_RES_TIMERS is not set
>>
>> #
>> # CPU/Task time and stats accounting
>> #
>> CONFIG_TICK_CPU_ACCOUNTING=y
>> # CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
>> # CONFIG_IRQ_TIME_ACCOUNTING is not set
>> CONFIG_BSD_PROCESS_ACCT=y
>> CONFIG_BSD_PROCESS_ACCT_V3=y
>> CONFIG_TASKSTATS=y
>> # CONFIG_TASK_DELAY_ACCT is not set
>> # CONFIG_TASK_XACCT is not set
>>
>> #
>> # RCU Subsystem
>> #
>> CONFIG_TINY_RCU=y
>> # CONFIG_PREEMPT_RCU is not set
>> # CONFIG_RCU_STALL_COMMON is not set
>> # CONFIG_TREE_RCU_TRACE is not set
>> CONFIG_IKCONFIG=y
>> CONFIG_LOG_BUF_SHIFT=17
>> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
>> CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
>> CONFIG_ARCH_SUPPORTS_INT128=y
>> CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
>> CONFIG_CGROUPS=y
>> CONFIG_CGROUP_DEBUG=y
>> # CONFIG_CGROUP_FREEZER is not set
>> CONFIG_CGROUP_DEVICE=y
>> CONFIG_CPUSETS=y
>> CONFIG_PROC_PID_CPUSET=y
>> # CONFIG_CGROUP_CPUACCT is not set
>> CONFIG_RESOURCE_COUNTERS=y
>> # CONFIG_MEMCG is not set
>> CONFIG_CGROUP_HUGETLB=y
>> # CONFIG_CGROUP_PERF is not set
>> CONFIG_CGROUP_SCHED=y
>> CONFIG_FAIR_GROUP_SCHED=y
>> # CONFIG_CFS_BANDWIDTH is not set
>> # CONFIG_RT_GROUP_SCHED is not set
>> CONFIG_CHECKPOINT_RESTORE=y
>> CONFIG_NAMESPACES=y
>> # CONFIG_UTS_NS is not set
>> # CONFIG_USER_NS is not set
>> CONFIG_PID_NS=y
>> CONFIG_NET_NS=y
>> CONFIG_SCHED_AUTOGROUP=y
>> # CONFIG_SYSFS_DEPRECATED is not set
>> CONFIG_RELAY=y
>> CONFIG_BLK_DEV_INITRD=y
>> CONFIG_INITRAMFS_SOURCE=""
>> CONFIG_RD_GZIP=y
>> # CONFIG_RD_BZIP2 is not set
>> # CONFIG_RD_LZMA is not set
>> # CONFIG_RD_XZ is not set
>> # CONFIG_RD_LZO is not set
>> # CONFIG_RD_LZ4 is not set
>> CONFIG_CC_OPTIMIZE_FOR_SIZE=y
>> CONFIG_ANON_INODES=y
>> CONFIG_SYSCTL_EXCEPTION_TRACE=y
>> CONFIG_HAVE_PCSPKR_PLATFORM=y
>> CONFIG_EXPERT=y
>> CONFIG_SYSFS_SYSCALL=y
>> CONFIG_KALLSYMS=y
>> CONFIG_KALLSYMS_ALL=y
>> CONFIG_PRINTK=y
>> CONFIG_BUG=y
>> CONFIG_ELF_CORE=y
>> # CONFIG_PCSPKR_PLATFORM is not set
>> CONFIG_BASE_FULL=y
>> CONFIG_FUTEX=y
>> CONFIG_EPOLL=y
>> # CONFIG_SIGNALFD is not set
>> CONFIG_TIMERFD=y
>> # CONFIG_EVENTFD is not set
>> # CONFIG_SHMEM is not set
>> CONFIG_AIO=y
>> CONFIG_PCI_QUIRKS=y
>> # CONFIG_EMBEDDED is not set
>> CONFIG_HAVE_PERF_EVENTS=y
>>
>> #
>> # Kernel Performance Events And Counters
>> #
>> CONFIG_PERF_EVENTS=y
>> # CONFIG_DEBUG_PERF_USE_VMALLOC is not set
>> CONFIG_VM_EVENT_COUNTERS=y
>> CONFIG_COMPAT_BRK=y
>> CONFIG_SLAB=y
>> # CONFIG_SLUB is not set
>> # CONFIG_SLOB is not set
>> CONFIG_SYSTEM_TRUSTED_KEYRING=y
>> # CONFIG_PROFILING is not set
>> CONFIG_TRACEPOINTS=y
>> CONFIG_HAVE_OPROFILE=y
>> CONFIG_OPROFILE_NMI_TIMER=y
>> CONFIG_KPROBES=y
>> CONFIG_JUMP_LABEL=y
>> CONFIG_OPTPROBES=y
>> CONFIG_UPROBES=y
>> # CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
>> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
>> CONFIG_ARCH_USE_BUILTIN_BSWAP=y
>> CONFIG_KRETPROBES=y
>> CONFIG_HAVE_IOREMAP_PROT=y
>> CONFIG_HAVE_KPROBES=y
>> CONFIG_HAVE_KRETPROBES=y
>> CONFIG_HAVE_OPTPROBES=y
>> CONFIG_HAVE_KPROBES_ON_FTRACE=y
>> CONFIG_HAVE_ARCH_TRACEHOOK=y
>> CONFIG_HAVE_DMA_ATTRS=y
>> CONFIG_GENERIC_SMP_IDLE_THREAD=y
>> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
>> CONFIG_HAVE_DMA_API_DEBUG=y
>> CONFIG_HAVE_HW_BREAKPOINT=y
>> CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
>> CONFIG_HAVE_USER_RETURN_NOTIFIER=y
>> CONFIG_HAVE_PERF_EVENTS_NMI=y
>> CONFIG_HAVE_PERF_REGS=y
>> CONFIG_HAVE_PERF_USER_STACK_DUMP=y
>> CONFIG_HAVE_ARCH_JUMP_LABEL=y
>> CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
>> CONFIG_HAVE_CMPXCHG_LOCAL=y
>> CONFIG_HAVE_CMPXCHG_DOUBLE=y
>> CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
>> CONFIG_HAVE_CC_STACKPROTECTOR=y
>> # CONFIG_CC_STACKPROTECTOR is not set
>> CONFIG_CC_STACKPROTECTOR_NONE=y
>> # CONFIG_CC_STACKPROTECTOR_REGULAR is not set
>> # CONFIG_CC_STACKPROTECTOR_STRONG is not set
>> CONFIG_HAVE_CONTEXT_TRACKING=y
>> CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
>> CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
>> CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
>> CONFIG_HAVE_ARCH_SOFT_DIRTY=y
>> CONFIG_MODULES_USE_ELF_RELA=y
>> CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
>>
>> #
>> # GCOV-based kernel profiling
>> #
>> CONFIG_GCOV_KERNEL=y
>> # CONFIG_GCOV_PROFILE_ALL is not set
>> # CONFIG_GCOV_FORMAT_AUTODETECT is not set
>> CONFIG_GCOV_FORMAT_3_4=y
>> # CONFIG_GCOV_FORMAT_4_7 is not set
>> # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
>> CONFIG_RT_MUTEXES=y
>> CONFIG_BASE_SMALL=0
>> CONFIG_MODULES=y
>> # CONFIG_MODULE_FORCE_LOAD is not set
>> CONFIG_MODULE_UNLOAD=y
>> CONFIG_MODULE_FORCE_UNLOAD=y
>> CONFIG_MODVERSIONS=y
>> CONFIG_MODULE_SRCVERSION_ALL=y
>> CONFIG_MODULE_SIG=y
>> # CONFIG_MODULE_SIG_FORCE is not set
>> CONFIG_MODULE_SIG_ALL=y
>> # CONFIG_MODULE_SIG_SHA1 is not set
>> # CONFIG_MODULE_SIG_SHA224 is not set
>> CONFIG_MODULE_SIG_SHA256=y
>> # CONFIG_MODULE_SIG_SHA384 is not set
>> # CONFIG_MODULE_SIG_SHA512 is not set
>> CONFIG_MODULE_SIG_HASH="sha256"
>> # CONFIG_BLOCK is not set
>> CONFIG_ASN1=y
>> CONFIG_UNINLINE_SPIN_UNLOCK=y
>> # CONFIG_FREEZER is not set
>>
>> #
>> # Processor type and features
>> #
>> # CONFIG_ZONE_DMA is not set
>> # CONFIG_SMP is not set
>> # CONFIG_X86_MPPARSE is not set
>> CONFIG_X86_EXTENDED_PLATFORM=y
>> # CONFIG_X86_INTEL_LPSS is not set
>> CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
>> # CONFIG_SCHED_OMIT_FRAME_POINTER is not set
>> CONFIG_HYPERVISOR_GUEST=y
>> CONFIG_PARAVIRT=y
>> # CONFIG_PARAVIRT_DEBUG is not set
>> # CONFIG_XEN is not set
>> CONFIG_KVM_GUEST=y
>> # CONFIG_KVM_DEBUG_FS is not set
>> # CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
>> CONFIG_PARAVIRT_CLOCK=y
>> CONFIG_NO_BOOTMEM=y
>> CONFIG_MEMTEST=y
>> # CONFIG_MK8 is not set
>> # CONFIG_MPSC is not set
>> # CONFIG_MCORE2 is not set
>> # CONFIG_MATOM is not set
>> CONFIG_GENERIC_CPU=y
>> CONFIG_X86_INTERNODE_CACHE_SHIFT=6
>> CONFIG_X86_L1_CACHE_SHIFT=6
>> CONFIG_X86_TSC=y
>> CONFIG_X86_CMPXCHG64=y
>> CONFIG_X86_CMOV=y
>> CONFIG_X86_MINIMUM_CPU_FAMILY=64
>> CONFIG_X86_DEBUGCTLMSR=y
>> CONFIG_PROCESSOR_SELECT=y
>> # CONFIG_CPU_SUP_INTEL is not set
>> # CONFIG_CPU_SUP_AMD is not set
>> # CONFIG_CPU_SUP_CENTAUR is not set
>> CONFIG_HPET_TIMER=y
>> CONFIG_HPET_EMULATE_RTC=y
>> CONFIG_DMI=y
>> # CONFIG_CALGARY_IOMMU is not set
>> CONFIG_SWIOTLB=y
>> CONFIG_IOMMU_HELPER=y
>> CONFIG_NR_CPUS=1
>> CONFIG_PREEMPT_NONE=y
>> # CONFIG_PREEMPT_VOLUNTARY is not set
>> # CONFIG_PREEMPT is not set
>> CONFIG_PREEMPT_COUNT=y
>> CONFIG_X86_LOCAL_APIC=y
>> CONFIG_X86_IO_APIC=y
>> CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
>> CONFIG_X86_MCE=y
>> # CONFIG_X86_MCE_INTEL is not set
>> CONFIG_X86_MCE_AMD=y
>> CONFIG_X86_MCE_THRESHOLD=y
>> # CONFIG_X86_MCE_INJECT is not set
>> CONFIG_I8K=m
>> # CONFIG_MICROCODE_INTEL_EARLY is not set
>> # CONFIG_MICROCODE_AMD_EARLY is not set
>> CONFIG_X86_MSR=y
>> # CONFIG_X86_CPUID is not set
>> CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
>> CONFIG_ARCH_DMA_ADDR_T_64BIT=y
>> # CONFIG_DIRECT_GBPAGES is not set
>> CONFIG_ARCH_SPARSEMEM_ENABLE=y
>> CONFIG_ARCH_SPARSEMEM_DEFAULT=y
>> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
>> CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
>> CONFIG_SELECT_MEMORY_MODEL=y
>> CONFIG_SPARSEMEM_MANUAL=y
>> CONFIG_SPARSEMEM=y
>> CONFIG_HAVE_MEMORY_PRESENT=y
>> CONFIG_SPARSEMEM_EXTREME=y
>> CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
>> CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
>> # CONFIG_SPARSEMEM_VMEMMAP is not set
>> CONFIG_HAVE_MEMBLOCK=y
>> CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
>> CONFIG_ARCH_DISCARD_MEMBLOCK=y
>> CONFIG_MEMORY_ISOLATION=y
>> # CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
>> # CONFIG_MEMORY_HOTPLUG is not set
>> CONFIG_PAGEFLAGS_EXTENDED=y
>> CONFIG_SPLIT_PTLOCK_CPUS=4
>> CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
>> # CONFIG_COMPACTION is not set
>> CONFIG_PHYS_ADDR_T_64BIT=y
>> CONFIG_ZONE_DMA_FLAG=0
>> CONFIG_VIRT_TO_BUS=y
>> CONFIG_KSM=y
>> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
>> CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
>> CONFIG_MEMORY_FAILURE=y
>> # CONFIG_TRANSPARENT_HUGEPAGE is not set
>> # CONFIG_CROSS_MEMORY_ATTACH is not set
>> CONFIG_NEED_PER_CPU_KM=y
>> CONFIG_CLEANCACHE=y
>> # CONFIG_CMA is not set
>> # CONFIG_ZBUD is not set
>> CONFIG_ZSMALLOC=y
>> CONFIG_PGTABLE_MAPPING=y
>> CONFIG_GENERIC_EARLY_IOREMAP=y
>> CONFIG_X86_CHECK_BIOS_CORRUPTION=y
>> # CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
>> CONFIG_X86_RESERVE_LOW=64
>> CONFIG_MTRR=y
>> CONFIG_MTRR_SANITIZER=y
>> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
>> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
>> # CONFIG_X86_PAT is not set
>> CONFIG_ARCH_RANDOM=y
>> # CONFIG_X86_SMAP is not set
>> # CONFIG_EFI is not set
>> # CONFIG_SECCOMP is not set
>> CONFIG_HZ_100=y
>> # CONFIG_HZ_250 is not set
>> # CONFIG_HZ_300 is not set
>> # CONFIG_HZ_1000 is not set
>> CONFIG_HZ=100
>> # CONFIG_SCHED_HRTICK is not set
>> CONFIG_KEXEC=y
>> # CONFIG_CRASH_DUMP is not set
>> CONFIG_PHYSICAL_START=0x1000000
>> CONFIG_RELOCATABLE=y
>> # CONFIG_RANDOMIZE_BASE is not set
>> CONFIG_PHYSICAL_ALIGN=0x200000
>> # CONFIG_CMDLINE_BOOL is not set
>> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
>>
>> #
>> # Power management and ACPI options
>> #
>> # CONFIG_SUSPEND is not set
>> # CONFIG_PM_RUNTIME is not set
>> CONFIG_ACPI=y
>> # CONFIG_ACPI_EC_DEBUGFS is not set
>> CONFIG_ACPI_AC=y
>> CONFIG_ACPI_BATTERY=y
>> CONFIG_ACPI_BUTTON=y
>> # CONFIG_ACPI_VIDEO is not set
>> CONFIG_ACPI_FAN=y
>> # CONFIG_ACPI_DOCK is not set
>> CONFIG_ACPI_PROCESSOR=y
>> # CONFIG_ACPI_IPMI is not set
>> # CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
>> CONFIG_ACPI_THERMAL=y
>> # CONFIG_ACPI_CUSTOM_DSDT is not set
>> # CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
>> # CONFIG_ACPI_DEBUG is not set
>> # CONFIG_ACPI_PCI_SLOT is not set
>> CONFIG_X86_PM_TIMER=y
>> # CONFIG_ACPI_CONTAINER is not set
>> # CONFIG_ACPI_SBS is not set
>> # CONFIG_ACPI_HED is not set
>> # CONFIG_ACPI_CUSTOM_METHOD is not set
>> # CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
>> # CONFIG_ACPI_APEI is not set
>> # CONFIG_ACPI_EXTLOG is not set
>> CONFIG_SFI=y
>>
>> #
>> # CPU Frequency scaling
>> #
>> CONFIG_CPU_FREQ=y
>> CONFIG_CPU_FREQ_GOV_COMMON=y
>> CONFIG_CPU_FREQ_STAT=m
>> # CONFIG_CPU_FREQ_STAT_DETAILS is not set
>> # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
>> # CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
>> # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
>> CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
>> # CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
>> CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
>> CONFIG_CPU_FREQ_GOV_POWERSAVE=y
>> # CONFIG_CPU_FREQ_GOV_USERSPACE is not set
>> CONFIG_CPU_FREQ_GOV_ONDEMAND=y
>> CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
>>
>> #
>> # x86 CPU frequency scaling drivers
>> #
>> CONFIG_X86_INTEL_PSTATE=y
>> # CONFIG_X86_PCC_CPUFREQ is not set
>> # CONFIG_X86_ACPI_CPUFREQ is not set
>> # CONFIG_X86_SPEEDSTEP_CENTRINO is not set
>> # CONFIG_X86_P4_CLOCKMOD is not set
>>
>> #
>> # shared options
>> #
>> # CONFIG_X86_SPEEDSTEP_LIB is not set
>>
>> #
>> # CPU Idle
>> #
>> CONFIG_CPU_IDLE=y
>> # CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
>> CONFIG_CPU_IDLE_GOV_LADDER=y
>> CONFIG_CPU_IDLE_GOV_MENU=y
>> # CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
>>
>> #
>> # Memory power savings
>> #
>> # CONFIG_I7300_IDLE is not set
>>
>> #
>> # Bus options (PCI etc.)
>> #
>> CONFIG_PCI=y
>> CONFIG_PCI_DIRECT=y
>> # CONFIG_PCI_MMCONFIG is not set
>> CONFIG_PCI_DOMAINS=y
>> # CONFIG_PCI_CNB20LE_QUIRK is not set
>> # CONFIG_PCIEPORTBUS is not set
>> # CONFIG_PCI_MSI is not set
>> # CONFIG_PCI_DEBUG is not set
>> # CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
>> # CONFIG_PCI_STUB is not set
>> CONFIG_HT_IRQ=y
>> # CONFIG_PCI_IOV is not set
>> # CONFIG_PCI_PRI is not set
>> # CONFIG_PCI_PASID is not set
>> # CONFIG_PCI_IOAPIC is not set
>> CONFIG_PCI_LABEL=y
>>
>> #
>> # PCI host controller drivers
>> #
>> # CONFIG_ISA_DMA_API is not set
>> CONFIG_PCCARD=y
>> # CONFIG_PCMCIA is not set
>> CONFIG_CARDBUS=y
>>
>> #
>> # PC-card bridges
>> #
>> # CONFIG_YENTA is not set
>> # CONFIG_HOTPLUG_PCI is not set
>> # CONFIG_RAPIDIO is not set
>> CONFIG_X86_SYSFB=y
>>
>> #
>> # Executable file formats / Emulations
>> #
>> CONFIG_BINFMT_ELF=y
>> CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
>> # CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
>> CONFIG_BINFMT_SCRIPT=y
>> # CONFIG_HAVE_AOUT is not set
>> # CONFIG_BINFMT_MISC is not set
>> CONFIG_COREDUMP=y
>> # CONFIG_IA32_EMULATION is not set
>> CONFIG_X86_DEV_DMA_OPS=y
>> CONFIG_NET=y
>>
>> #
>> # Networking options
>> #
>> CONFIG_PACKET=y
>> CONFIG_PACKET_DIAG=y
>> CONFIG_UNIX=y
>> # CONFIG_UNIX_DIAG is not set
>> CONFIG_XFRM=y
>> CONFIG_XFRM_ALGO=y
>> CONFIG_XFRM_USER=y
>> CONFIG_XFRM_SUB_POLICY=y
>> CONFIG_XFRM_MIGRATE=y
>> CONFIG_XFRM_IPCOMP=y
>> CONFIG_NET_KEY=y
>> CONFIG_NET_KEY_MIGRATE=y
>> CONFIG_INET=y
>> CONFIG_IP_MULTICAST=y
>> # CONFIG_IP_ADVANCED_ROUTER is not set
>> # CONFIG_IP_PNP is not set
>> CONFIG_NET_IPIP=y
>> CONFIG_NET_IPGRE_DEMUX=y
>> CONFIG_NET_IP_TUNNEL=y
>> # CONFIG_NET_IPGRE is not set
>> # CONFIG_IP_MROUTE is not set
>> CONFIG_SYN_COOKIES=y
>> CONFIG_NET_IPVTI=m
>> # CONFIG_INET_AH is not set
>> CONFIG_INET_ESP=y
>> CONFIG_INET_IPCOMP=y
>> CONFIG_INET_XFRM_TUNNEL=y
>> CONFIG_INET_TUNNEL=y
>> CONFIG_INET_XFRM_MODE_TRANSPORT=m
>> CONFIG_INET_XFRM_MODE_TUNNEL=m
>> CONFIG_INET_XFRM_MODE_BEET=m
>> CONFIG_INET_LRO=m
>> # CONFIG_INET_DIAG is not set
>> CONFIG_TCP_CONG_ADVANCED=y
>> CONFIG_TCP_CONG_BIC=y
>> CONFIG_TCP_CONG_CUBIC=m
>> CONFIG_TCP_CONG_WESTWOOD=m
>> CONFIG_TCP_CONG_HTCP=y
>> CONFIG_TCP_CONG_HSTCP=y
>> # CONFIG_TCP_CONG_HYBLA is not set
>> CONFIG_TCP_CONG_VEGAS=m
>> CONFIG_TCP_CONG_SCALABLE=m
>> # CONFIG_TCP_CONG_LP is not set
>> # CONFIG_TCP_CONG_VENO is not set
>> CONFIG_TCP_CONG_YEAH=m
>> CONFIG_TCP_CONG_ILLINOIS=m
>> # CONFIG_DEFAULT_BIC is not set
>> CONFIG_DEFAULT_HTCP=y
>> # CONFIG_DEFAULT_RENO is not set
>> CONFIG_DEFAULT_TCP_CONG="htcp"
>> # CONFIG_TCP_MD5SIG is not set
>> CONFIG_IPV6=m
>> # CONFIG_IPV6_ROUTER_PREF is not set
>> # CONFIG_IPV6_OPTIMISTIC_DAD is not set
>> # CONFIG_INET6_AH is not set
>> CONFIG_INET6_ESP=m
>> CONFIG_INET6_IPCOMP=m
>> CONFIG_IPV6_MIP6=m
>> CONFIG_INET6_XFRM_TUNNEL=m
>> CONFIG_INET6_TUNNEL=m
>> CONFIG_INET6_XFRM_MODE_TRANSPORT=m
>> # CONFIG_INET6_XFRM_MODE_TUNNEL is not set
>> # CONFIG_INET6_XFRM_MODE_BEET is not set
>> CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
>> CONFIG_IPV6_SIT=m
>> CONFIG_IPV6_SIT_6RD=y
>> CONFIG_IPV6_NDISC_NODETYPE=y
>> CONFIG_IPV6_TUNNEL=m
>> CONFIG_IPV6_GRE=m
>> # CONFIG_IPV6_MULTIPLE_TABLES is not set
>> CONFIG_IPV6_MROUTE=y
>> # CONFIG_IPV6_MROUTE_MULTIPLE_TABLES is not set
>> # CONFIG_IPV6_PIMSM_V2 is not set
>> CONFIG_NETWORK_SECMARK=y
>> CONFIG_NET_PTP_CLASSIFY=y
>> CONFIG_NETWORK_PHY_TIMESTAMPING=y
>> CONFIG_NETFILTER=y
>> # CONFIG_NETFILTER_DEBUG is not set
>> # CONFIG_NETFILTER_ADVANCED is not set
>>
>> #
>> # Core Netfilter Configuration
>> #
>> CONFIG_NETFILTER_NETLINK=y
>> # CONFIG_NETFILTER_NETLINK_LOG is not set
>> # CONFIG_NF_CONNTRACK is not set
>> # CONFIG_NF_TABLES is not set
>> CONFIG_NETFILTER_XTABLES=m
>>
>> #
>> # Xtables combined modules
>> #
>> CONFIG_NETFILTER_XT_MARK=m
>>
>> #
>> # Xtables targets
>> #
>> CONFIG_NETFILTER_XT_TARGET_LOG=m
>> # CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
>> # CONFIG_NETFILTER_XT_TARGET_SECMARK is not set
>> CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
>>
>> #
>> # Xtables matches
>> #
>> # CONFIG_NETFILTER_XT_MATCH_POLICY is not set
>> CONFIG_IP_SET=y
>> CONFIG_IP_SET_MAX=256
>> # CONFIG_IP_SET_BITMAP_IP is not set
>> CONFIG_IP_SET_BITMAP_IPMAC=m
>> CONFIG_IP_SET_BITMAP_PORT=y
>> # CONFIG_IP_SET_HASH_IP is not set
>> # CONFIG_IP_SET_HASH_IPMARK is not set
>> CONFIG_IP_SET_HASH_IPPORT=m
>> CONFIG_IP_SET_HASH_IPPORTIP=y
>> CONFIG_IP_SET_HASH_IPPORTNET=y
>> CONFIG_IP_SET_HASH_NETPORTNET=y
>> CONFIG_IP_SET_HASH_NET=y
>> # CONFIG_IP_SET_HASH_NETNET is not set
>> CONFIG_IP_SET_HASH_NETPORT=m
>> # CONFIG_IP_SET_HASH_NETIFACE is not set
>> # CONFIG_IP_SET_LIST_SET is not set
>> CONFIG_IP_VS=y
>> # CONFIG_IP_VS_DEBUG is not set
>> CONFIG_IP_VS_TAB_BITS=12
>>
>> #
>> # IPVS transport protocol load balancing support
>> #
>> # CONFIG_IP_VS_PROTO_TCP is not set
>> # CONFIG_IP_VS_PROTO_UDP is not set
>> # CONFIG_IP_VS_PROTO_AH_ESP is not set
>> # CONFIG_IP_VS_PROTO_ESP is not set
>> # CONFIG_IP_VS_PROTO_AH is not set
>> # CONFIG_IP_VS_PROTO_SCTP is not set
>>
>> #
>> # IPVS scheduler
>> #
>> CONFIG_IP_VS_RR=m
>> CONFIG_IP_VS_WRR=y
>> # CONFIG_IP_VS_LC is not set
>> CONFIG_IP_VS_WLC=m
>> CONFIG_IP_VS_LBLC=m
>> CONFIG_IP_VS_LBLCR=m
>> # CONFIG_IP_VS_DH is not set
>> CONFIG_IP_VS_SH=y
>> # CONFIG_IP_VS_SED is not set
>> CONFIG_IP_VS_NQ=y
>>
>> #
>> # IPVS SH scheduler
>> #
>> CONFIG_IP_VS_SH_TAB_BITS=8
>>
>> #
>> # IPVS application helper
>> #
>>
>> #
>> # IP: Netfilter Configuration
>> #
>> # CONFIG_NF_DEFRAG_IPV4 is not set
>> # CONFIG_IP_NF_IPTABLES is not set
>>
>> #
>> # IPv6: Netfilter Configuration
>> #
>> # CONFIG_NF_DEFRAG_IPV6 is not set
>> CONFIG_IP6_NF_IPTABLES=m
>> CONFIG_IP6_NF_MATCH_IPV6HEADER=m
>> CONFIG_IP6_NF_FILTER=m
>> CONFIG_IP6_NF_TARGET_REJECT=m
>> CONFIG_IP6_NF_MANGLE=m
>> CONFIG_IP6_NF_RAW=m
>> # CONFIG_IP_DCCP is not set
>> CONFIG_IP_SCTP=m
>> # CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
>> # CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
>> CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE=y
>> # CONFIG_SCTP_COOKIE_HMAC_MD5 is not set
>> CONFIG_SCTP_COOKIE_HMAC_SHA1=y
>> # CONFIG_RDS is not set
>> CONFIG_TIPC=y
>> CONFIG_TIPC_PORTS=8191
>> CONFIG_ATM=m
>> CONFIG_ATM_CLIP=m
>> # CONFIG_ATM_CLIP_NO_ICMP is not set
>> # CONFIG_ATM_LANE is not set
>> CONFIG_ATM_BR2684=m
>> CONFIG_ATM_BR2684_IPFILTER=y
>> CONFIG_L2TP=m
>> CONFIG_L2TP_DEBUGFS=m
>> CONFIG_L2TP_V3=y
>> # CONFIG_L2TP_IP is not set
>> # CONFIG_L2TP_ETH is not set
>> CONFIG_STP=y
>> CONFIG_GARP=y
>> CONFIG_MRP=y
>> # CONFIG_BRIDGE is not set
>> CONFIG_VLAN_8021Q=y
>> CONFIG_VLAN_8021Q_GVRP=y
>> CONFIG_VLAN_8021Q_MVRP=y
>> # CONFIG_DECNET is not set
>> CONFIG_LLC=y
>> CONFIG_LLC2=y
>> CONFIG_IPX=m
>> # CONFIG_IPX_INTERN is not set
>> CONFIG_ATALK=y
>> # CONFIG_DEV_APPLETALK is not set
>> CONFIG_X25=y
>> # CONFIG_LAPB is not set
>> CONFIG_PHONET=m
>> CONFIG_IEEE802154=m
>> CONFIG_IEEE802154_6LOWPAN=m
>> CONFIG_6LOWPAN_IPHC=m
>> CONFIG_MAC802154=m
>> # CONFIG_NET_SCHED is not set
>> # CONFIG_DCB is not set
>> # CONFIG_DNS_RESOLVER is not set
>> CONFIG_BATMAN_ADV=y
>> CONFIG_BATMAN_ADV_BLA=y
>> # CONFIG_BATMAN_ADV_DAT is not set
>> CONFIG_BATMAN_ADV_NC=y
>> CONFIG_BATMAN_ADV_MCAST=y
>> CONFIG_BATMAN_ADV_DEBUG=y
>> # CONFIG_OPENVSWITCH is not set
>> CONFIG_VSOCKETS=y
>> CONFIG_NETLINK_MMAP=y
>> # CONFIG_NETLINK_DIAG is not set
>> # CONFIG_NET_MPLS_GSO is not set
>> # CONFIG_HSR is not set
>> # CONFIG_CGROUP_NET_PRIO is not set
>> CONFIG_CGROUP_NET_CLASSID=y
>> CONFIG_NET_RX_BUSY_POLL=y
>> CONFIG_BQL=y
>> # CONFIG_BPF_JIT is not set
>>
>> #
>> # Network testing
>> #
>> # CONFIG_NET_DROP_MONITOR is not set
>> # CONFIG_HAMRADIO is not set
>> # CONFIG_CAN is not set
>> CONFIG_IRDA=y
>>
>> #
>> # IrDA protocols
>> #
>> # CONFIG_IRLAN is not set
>> # CONFIG_IRCOMM is not set
>> CONFIG_IRDA_ULTRA=y
>>
>> #
>> # IrDA options
>> #
>> CONFIG_IRDA_CACHE_LAST_LSAP=y
>> # CONFIG_IRDA_FAST_RR is not set
>> # CONFIG_IRDA_DEBUG is not set
>>
>> #
>> # Infrared-port device drivers
>> #
>>
>> #
>> # SIR device drivers
>> #
>> # CONFIG_IRTTY_SIR is not set
>>
>> #
>> # Dongle support
>> #
>> # CONFIG_KINGSUN_DONGLE is not set
>> CONFIG_KSDAZZLE_DONGLE=m
>> CONFIG_KS959_DONGLE=m
>>
>> #
>> # FIR device drivers
>> #
>> CONFIG_USB_IRDA=m
>> CONFIG_SIGMATEL_FIR=m
>> # CONFIG_VLSI_FIR is not set
>> # CONFIG_MCS_FIR is not set
>> CONFIG_BT=m
>> CONFIG_BT_6LOWPAN=y
>> CONFIG_BT_RFCOMM=m
>> # CONFIG_BT_RFCOMM_TTY is not set
>> # CONFIG_BT_BNEP is not set
>> CONFIG_BT_HIDP=m
>>
>> #
>> # Bluetooth device drivers
>> #
>> CONFIG_BT_HCIBTUSB=m
>> CONFIG_BT_HCIBTSDIO=m
>> # CONFIG_BT_HCIUART is not set
>> # CONFIG_BT_HCIBCM203X is not set
>> # CONFIG_BT_HCIBPA10X is not set
>> CONFIG_BT_HCIBFUSB=m
>> # CONFIG_BT_HCIVHCI is not set
>> CONFIG_BT_MRVL=m
>> CONFIG_BT_MRVL_SDIO=m
>> CONFIG_BT_ATH3K=m
>> # CONFIG_AF_RXRPC is not set
>> CONFIG_WIRELESS=y
>> # CONFIG_CFG80211 is not set
>> # CONFIG_LIB80211 is not set
>>
>> #
>> # CFG80211 needs to be enabled for MAC80211
>> #
>> CONFIG_WIMAX=y
>> CONFIG_WIMAX_DEBUG_LEVEL=8
>> CONFIG_RFKILL=y
>> # CONFIG_RFKILL_INPUT is not set
>> CONFIG_RFKILL_REGULATOR=m
>> CONFIG_RFKILL_GPIO=y
>> # CONFIG_NET_9P is not set
>> # CONFIG_CAIF is not set
>> CONFIG_CEPH_LIB=m
>> CONFIG_CEPH_LIB_PRETTYDEBUG=y
>> # CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
>> CONFIG_NFC=y
>> CONFIG_NFC_DIGITAL=y
>> CONFIG_NFC_NCI=m
>> # CONFIG_NFC_HCI is not set
>>
>> #
>> # Near Field Communication (NFC) devices
>> #
>> CONFIG_NFC_PN533=m
>> CONFIG_NFC_SIM=y
>> CONFIG_NFC_PORT100=m
>> CONFIG_NFC_MRVL=m
>> CONFIG_NFC_MRVL_USB=m
>> CONFIG_HAVE_BPF_JIT=y
>>
>> #
>> # Device Drivers
>> #
>>
>> #
>> # Generic Driver Options
>> #
>> CONFIG_UEVENT_HELPER_PATH=""
>> CONFIG_DEVTMPFS=y
>> # CONFIG_DEVTMPFS_MOUNT is not set
>> CONFIG_STANDALONE=y
>> CONFIG_PREVENT_FIRMWARE_BUILD=y
>> CONFIG_FW_LOADER=y
>> CONFIG_FIRMWARE_IN_KERNEL=y
>> CONFIG_EXTRA_FIRMWARE=""
>> CONFIG_FW_LOADER_USER_HELPER=y
>> # CONFIG_DEBUG_DRIVER is not set
>> CONFIG_DEBUG_DEVRES=y
>> # CONFIG_SYS_HYPERVISOR is not set
>> # CONFIG_GENERIC_CPU_DEVICES is not set
>> CONFIG_GENERIC_CPU_AUTOPROBE=y
>> CONFIG_REGMAP=y
>> CONFIG_REGMAP_I2C=y
>> CONFIG_REGMAP_MMIO=y
>> CONFIG_REGMAP_IRQ=y
>> CONFIG_DMA_SHARED_BUFFER=y
>>
>> #
>> # Bus devices
>> #
>> CONFIG_CONNECTOR=m
>> CONFIG_MTD=m
>> # CONFIG_MTD_TESTS is not set
>> CONFIG_MTD_REDBOOT_PARTS=m
>> CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
>> # CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
>> CONFIG_MTD_REDBOOT_PARTS_READONLY=y
>> CONFIG_MTD_CMDLINE_PARTS=m
>> CONFIG_MTD_AR7_PARTS=m
>>
>> #
>> # User Modules And Translation Layers
>> #
>> CONFIG_MTD_OOPS=m
>>
>> #
>> # RAM/ROM/Flash chip drivers
>> #
>> CONFIG_MTD_CFI=m
>> CONFIG_MTD_JEDECPROBE=m
>> CONFIG_MTD_GEN_PROBE=m
>> # CONFIG_MTD_CFI_ADV_OPTIONS is not set
>> CONFIG_MTD_MAP_BANK_WIDTH_1=y
>> CONFIG_MTD_MAP_BANK_WIDTH_2=y
>> CONFIG_MTD_MAP_BANK_WIDTH_4=y
>> # CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
>> # CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
>> # CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
>> CONFIG_MTD_CFI_I1=y
>> CONFIG_MTD_CFI_I2=y
>> # CONFIG_MTD_CFI_I4 is not set
>> # CONFIG_MTD_CFI_I8 is not set
>> CONFIG_MTD_CFI_INTELEXT=m
>> # CONFIG_MTD_CFI_AMDSTD is not set
>> CONFIG_MTD_CFI_STAA=m
>> CONFIG_MTD_CFI_UTIL=m
>> CONFIG_MTD_RAM=m
>> # CONFIG_MTD_ROM is not set
>> CONFIG_MTD_ABSENT=m
>>
>> #
>> # Mapping drivers for chip access
>> #
>> CONFIG_MTD_COMPLEX_MAPPINGS=y
>> # CONFIG_MTD_PHYSMAP is not set
>> # CONFIG_MTD_SC520CDP is not set
>> # CONFIG_MTD_NETSC520 is not set
>> # CONFIG_MTD_TS5500 is not set
>> CONFIG_MTD_SBC_GXX=m
>> CONFIG_MTD_AMD76XROM=m
>> CONFIG_MTD_ICHXROM=m
>> # CONFIG_MTD_ESB2ROM is not set
>> # CONFIG_MTD_CK804XROM is not set
>> # CONFIG_MTD_SCB2_FLASH is not set
>> CONFIG_MTD_NETtel=m
>> CONFIG_MTD_L440GX=m
>> # CONFIG_MTD_PCI is not set
>> # CONFIG_MTD_GPIO_ADDR is not set
>> # CONFIG_MTD_INTEL_VR_NOR is not set
>> CONFIG_MTD_PLATRAM=m
>> # CONFIG_MTD_LATCH_ADDR is not set
>>
>> #
>> # Self-contained MTD device drivers
>> #
>> # CONFIG_MTD_PMC551 is not set
>> CONFIG_MTD_SLRAM=m
>> # CONFIG_MTD_PHRAM is not set
>> CONFIG_MTD_MTDRAM=m
>> CONFIG_MTDRAM_TOTAL_SIZE=4096
>> CONFIG_MTDRAM_ERASE_SIZE=128
>>
>> #
>> # Disk-On-Chip Device Drivers
>> #
>> CONFIG_MTD_DOCG3=m
>> CONFIG_BCH_CONST_M=14
>> CONFIG_BCH_CONST_T=4
>> CONFIG_MTD_NAND_ECC=m
>> # CONFIG_MTD_NAND_ECC_SMC is not set
>> CONFIG_MTD_NAND=m
>> # CONFIG_MTD_NAND_ECC_BCH is not set
>> # CONFIG_MTD_SM_COMMON is not set
>> CONFIG_MTD_NAND_DENALI=m
>> # CONFIG_MTD_NAND_DENALI_PCI is not set
>> CONFIG_MTD_NAND_GPIO=m
>> CONFIG_MTD_NAND_IDS=m
>> # CONFIG_MTD_NAND_RICOH is not set
>> # CONFIG_MTD_NAND_DISKONCHIP is not set
>> CONFIG_MTD_NAND_DOCG4=m
>> # CONFIG_MTD_NAND_CAFE is not set
>> # CONFIG_MTD_NAND_NANDSIM is not set
>> CONFIG_MTD_NAND_PLATFORM=m
>> # CONFIG_MTD_NAND_SH_FLCTL is not set
>> CONFIG_MTD_ONENAND=m
>> CONFIG_MTD_ONENAND_VERIFY_WRITE=y
>> # CONFIG_MTD_ONENAND_GENERIC is not set
>> # CONFIG_MTD_ONENAND_OTP is not set
>> # CONFIG_MTD_ONENAND_2X_PROGRAM is not set
>>
>> #
>> # LPDDR flash memory drivers
>> #
>> CONFIG_MTD_LPDDR=m
>> CONFIG_MTD_QINFO_PROBE=m
>> # CONFIG_MTD_UBI is not set
>> # CONFIG_PARPORT is not set
>> CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
>> CONFIG_PNP=y
>> CONFIG_PNP_DEBUG_MESSAGES=y
>>
>> #
>> # Protocols
>> #
>> CONFIG_PNPACPI=y
>>
>> #
>> # Misc devices
>> #
>> CONFIG_SENSORS_LIS3LV02D=m
>> CONFIG_AD525X_DPOT=y
>> # CONFIG_AD525X_DPOT_I2C is not set
>> CONFIG_DUMMY_IRQ=y
>> # CONFIG_IBM_ASM is not set
>> # CONFIG_PHANTOM is not set
>> # CONFIG_INTEL_MID_PTI is not set
>> # CONFIG_SGI_IOC4 is not set
>> # CONFIG_TIFM_CORE is not set
>> # CONFIG_ICS932S401 is not set
>> CONFIG_ATMEL_SSC=m
>> CONFIG_ENCLOSURE_SERVICES=m
>> # CONFIG_HP_ILO is not set
>> CONFIG_APDS9802ALS=m
>> CONFIG_ISL29003=m
>> CONFIG_ISL29020=m
>> CONFIG_SENSORS_TSL2550=y
>> CONFIG_SENSORS_BH1780=m
>> # CONFIG_SENSORS_BH1770 is not set
>> CONFIG_SENSORS_APDS990X=m
>> CONFIG_HMC6352=y
>> CONFIG_DS1682=y
>> # CONFIG_VMWARE_BALLOON is not set
>> CONFIG_BMP085=y
>> CONFIG_BMP085_I2C=m
>> # CONFIG_PCH_PHUB is not set
>> CONFIG_USB_SWITCH_FSA9480=y
>> CONFIG_SRAM=y
>> # CONFIG_C2PORT is not set
>>
>> #
>> # EEPROM support
>> #
>> CONFIG_EEPROM_AT24=y
>> # CONFIG_EEPROM_LEGACY is not set
>> CONFIG_EEPROM_MAX6875=m
>> CONFIG_EEPROM_93CX6=m
>> # CONFIG_CB710_CORE is not set
>>
>> #
>> # Texas Instruments shared transport line discipline
>> #
>> # CONFIG_TI_ST is not set
>> CONFIG_SENSORS_LIS3_I2C=m
>>
>> #
>> # Altera FPGA firmware download module
>> #
>> CONFIG_ALTERA_STAPL=m
>> # CONFIG_INTEL_MEI is not set
>> # CONFIG_INTEL_MEI_ME is not set
>> # CONFIG_INTEL_MEI_TXE is not set
>> # CONFIG_VMWARE_VMCI is not set
>>
>> #
>> # Intel MIC Host Driver
>> #
>> # CONFIG_INTEL_MIC_HOST is not set
>>
>> #
>> # Intel MIC Card Driver
>> #
>> # CONFIG_INTEL_MIC_CARD is not set
>> # CONFIG_GENWQE is not set
>> CONFIG_ECHO=m
>> CONFIG_HAVE_IDE=y
>>
>> #
>> # SCSI device support
>> #
>> CONFIG_SCSI_MOD=y
>> # CONFIG_SCSI_DMA is not set
>> # CONFIG_SCSI_NETLINK is not set
>> # CONFIG_FUSION is not set
>>
>> #
>> # IEEE 1394 (FireWire) support
>> #
>> # CONFIG_FIREWIRE is not set
>> # CONFIG_FIREWIRE_NOSY is not set
>> # CONFIG_I2O is not set
>> CONFIG_MACINTOSH_DRIVERS=y
>> # CONFIG_NETDEVICES is not set
>>
>> #
>> # Input device support
>> #
>> CONFIG_INPUT=y
>> CONFIG_INPUT_FF_MEMLESS=m
>> CONFIG_INPUT_POLLDEV=m
>> CONFIG_INPUT_SPARSEKMAP=m
>> CONFIG_INPUT_MATRIXKMAP=m
>>
>> #
>> # Userland interfaces
>> #
>> CONFIG_INPUT_MOUSEDEV=m
>> # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
>> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
>> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
>> # CONFIG_INPUT_JOYDEV is not set
>> CONFIG_INPUT_EVDEV=m
>> CONFIG_INPUT_EVBUG=m
>>
>> #
>> # Input Device Drivers
>> #
>> CONFIG_INPUT_KEYBOARD=y
>> # CONFIG_KEYBOARD_ADP5520 is not set
>> # CONFIG_KEYBOARD_ADP5588 is not set
>> # CONFIG_KEYBOARD_ADP5589 is not set
>> CONFIG_KEYBOARD_ATKBD=y
>> # CONFIG_KEYBOARD_QT1070 is not set
>> # CONFIG_KEYBOARD_QT2160 is not set
>> # CONFIG_KEYBOARD_LKKBD is not set
>> # CONFIG_KEYBOARD_GPIO is not set
>> # CONFIG_KEYBOARD_GPIO_POLLED is not set
>> # CONFIG_KEYBOARD_TCA6416 is not set
>> # CONFIG_KEYBOARD_TCA8418 is not set
>> # CONFIG_KEYBOARD_MATRIX is not set
>> # CONFIG_KEYBOARD_LM8323 is not set
>> # CONFIG_KEYBOARD_LM8333 is not set
>> # CONFIG_KEYBOARD_MAX7359 is not set
>> # CONFIG_KEYBOARD_MCS is not set
>> # CONFIG_KEYBOARD_MPR121 is not set
>> # CONFIG_KEYBOARD_NEWTON is not set
>> # CONFIG_KEYBOARD_OPENCORES is not set
>> # CONFIG_KEYBOARD_STOWAWAY is not set
>> # CONFIG_KEYBOARD_SUNKBD is not set
>> # CONFIG_KEYBOARD_SH_KEYSC is not set
>> # CONFIG_KEYBOARD_STMPE is not set
>> # CONFIG_KEYBOARD_XTKBD is not set
>> # CONFIG_KEYBOARD_CROS_EC is not set
>> CONFIG_INPUT_MOUSE=y
>> # CONFIG_MOUSE_PS2 is not set
>> CONFIG_MOUSE_SERIAL=m
>> CONFIG_MOUSE_APPLETOUCH=m
>> CONFIG_MOUSE_BCM5974=m
>> # CONFIG_MOUSE_CYAPA is not set
>> CONFIG_MOUSE_VSXXXAA=m
>> CONFIG_MOUSE_GPIO=m
>> CONFIG_MOUSE_SYNAPTICS_I2C=m
>> CONFIG_MOUSE_SYNAPTICS_USB=m
>> # CONFIG_INPUT_JOYSTICK is not set
>> # CONFIG_INPUT_TABLET is not set
>> CONFIG_INPUT_TOUCHSCREEN=y
>> CONFIG_TOUCHSCREEN_AD7879=m
>> CONFIG_TOUCHSCREEN_AD7879_I2C=m
>> CONFIG_TOUCHSCREEN_ATMEL_MXT=m
>> CONFIG_TOUCHSCREEN_AUO_PIXCIR=m
>> CONFIG_TOUCHSCREEN_BU21013=m
>> CONFIG_TOUCHSCREEN_CY8CTMG110=m
>> CONFIG_TOUCHSCREEN_CYTTSP_CORE=m
>> # CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
>> CONFIG_TOUCHSCREEN_CYTTSP4_CORE=m
>> CONFIG_TOUCHSCREEN_CYTTSP4_I2C=m
>> CONFIG_TOUCHSCREEN_DA9034=m
>> CONFIG_TOUCHSCREEN_DYNAPRO=m
>> # CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
>> # CONFIG_TOUCHSCREEN_EETI is not set
>> CONFIG_TOUCHSCREEN_FUJITSU=m
>> CONFIG_TOUCHSCREEN_ILI210X=m
>> CONFIG_TOUCHSCREEN_GUNZE=m
>> # CONFIG_TOUCHSCREEN_ELO is not set
>> CONFIG_TOUCHSCREEN_WACOM_W8001=m
>> CONFIG_TOUCHSCREEN_WACOM_I2C=m
>> # CONFIG_TOUCHSCREEN_MAX11801 is not set
>> # CONFIG_TOUCHSCREEN_MCS5000 is not set
>> CONFIG_TOUCHSCREEN_MMS114=m
>> # CONFIG_TOUCHSCREEN_MTOUCH is not set
>> # CONFIG_TOUCHSCREEN_INEXIO is not set
>> CONFIG_TOUCHSCREEN_MK712=m
>> # CONFIG_TOUCHSCREEN_PENMOUNT is not set
>> # CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
>> CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
>> CONFIG_TOUCHSCREEN_TOUCHWIN=m
>> # CONFIG_TOUCHSCREEN_TI_AM335X_TSC is not set
>> # CONFIG_TOUCHSCREEN_PIXCIR is not set
>> # CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
>> CONFIG_TOUCHSCREEN_MC13783=m
>> CONFIG_TOUCHSCREEN_TOUCHIT213=m
>> CONFIG_TOUCHSCREEN_TSC_SERIO=m
>> CONFIG_TOUCHSCREEN_TSC2007=m
>> CONFIG_TOUCHSCREEN_ST1232=m
>> CONFIG_TOUCHSCREEN_STMPE=m
>> CONFIG_TOUCHSCREEN_SUR40=m
>> # CONFIG_TOUCHSCREEN_TPS6507X is not set
>> CONFIG_TOUCHSCREEN_ZFORCE=m
>> CONFIG_INPUT_MISC=y
>> # CONFIG_INPUT_88PM80X_ONKEY is not set
>> CONFIG_INPUT_AD714X=m
>> CONFIG_INPUT_AD714X_I2C=m
>> CONFIG_INPUT_BMA150=m
>> # CONFIG_INPUT_MAX8925_ONKEY is not set
>> CONFIG_INPUT_MC13783_PWRBUTTON=m
>> CONFIG_INPUT_MMA8450=m
>> CONFIG_INPUT_MPU3050=m
>> # CONFIG_INPUT_APANEL is not set
>> CONFIG_INPUT_GP2A=m
>> # CONFIG_INPUT_GPIO_TILT_POLLED is not set
>> # CONFIG_INPUT_ATLAS_BTNS is not set
>> # CONFIG_INPUT_ATI_REMOTE2 is not set
>> CONFIG_INPUT_KEYSPAN_REMOTE=m
>> CONFIG_INPUT_KXTJ9=m
>> # CONFIG_INPUT_KXTJ9_POLLED_MODE is not set
>> CONFIG_INPUT_POWERMATE=m
>> CONFIG_INPUT_YEALINK=m
>> CONFIG_INPUT_CM109=m
>> CONFIG_INPUT_RETU_PWRBUTTON=m
>> # CONFIG_INPUT_TWL6040_VIBRA is not set
>> CONFIG_INPUT_UINPUT=m
>> CONFIG_INPUT_PCF50633_PMU=m
>> # CONFIG_INPUT_PCF8574 is not set
>> CONFIG_INPUT_PWM_BEEPER=m
>> CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
>> CONFIG_INPUT_DA9055_ONKEY=m
>> # CONFIG_INPUT_ADXL34X is not set
>> # CONFIG_INPUT_IMS_PCU is not set
>> CONFIG_INPUT_CMA3000=m
>> CONFIG_INPUT_CMA3000_I2C=m
>> # CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
>>
>> #
>> # Hardware I/O ports
>> #
>> CONFIG_SERIO=y
>> CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
>> CONFIG_SERIO_I8042=y
>> CONFIG_SERIO_SERPORT=y
>> CONFIG_SERIO_CT82C710=m
>> # CONFIG_SERIO_PCIPS2 is not set
>> CONFIG_SERIO_LIBPS2=y
>> CONFIG_SERIO_RAW=m
>> # CONFIG_SERIO_ALTERA_PS2 is not set
>> CONFIG_SERIO_PS2MULT=m
>> # CONFIG_SERIO_ARC_PS2 is not set
>> CONFIG_SERIO_OLPC_APSP=m
>> CONFIG_GAMEPORT=m
>> # CONFIG_GAMEPORT_NS558 is not set
>> # CONFIG_GAMEPORT_L4 is not set
>> # CONFIG_GAMEPORT_EMU10K1 is not set
>> # CONFIG_GAMEPORT_FM801 is not set
>>
>> #
>> # Character devices
>> #
>> CONFIG_TTY=y
>> # CONFIG_VT is not set
>> CONFIG_UNIX98_PTYS=y
>> # CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
>> CONFIG_LEGACY_PTYS=y
>> CONFIG_LEGACY_PTY_COUNT=256
>> # CONFIG_SERIAL_NONSTANDARD is not set
>> # CONFIG_NOZOMI is not set
>> # CONFIG_N_GSM is not set
>> # CONFIG_TRACE_SINK is not set
>> # CONFIG_DEVKMEM is not set
>>
>> #
>> # Serial drivers
>> #
>> CONFIG_SERIAL_8250=y
>> CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
>> CONFIG_SERIAL_8250_PNP=y
>> CONFIG_SERIAL_8250_CONSOLE=y
>> CONFIG_FIX_EARLYCON_MEM=y
>> CONFIG_SERIAL_8250_PCI=y
>> CONFIG_SERIAL_8250_NR_UARTS=4
>> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
>> # CONFIG_SERIAL_8250_EXTENDED is not set
>> # CONFIG_SERIAL_8250_DW is not set
>>
>> #
>> # Non-8250 serial port support
>> #
>> # CONFIG_SERIAL_CLPS711X is not set
>> # CONFIG_SERIAL_MFD_HSU is not set
>> # CONFIG_SERIAL_SH_SCI is not set
>> CONFIG_SERIAL_CORE=y
>> CONFIG_SERIAL_CORE_CONSOLE=y
>> # CONFIG_SERIAL_JSM is not set
>> # CONFIG_SERIAL_SCCNXP is not set
>> # CONFIG_SERIAL_TIMBERDALE is not set
>> # CONFIG_SERIAL_ALTERA_JTAGUART is not set
>> # CONFIG_SERIAL_ALTERA_UART is not set
>> # CONFIG_SERIAL_PCH_UART is not set
>> # CONFIG_SERIAL_ARC is not set
>> # CONFIG_SERIAL_RP2 is not set
>> # CONFIG_SERIAL_FSL_LPUART is not set
>> # CONFIG_SERIAL_ST_ASC is not set
>> # CONFIG_TTY_PRINTK is not set
>> # CONFIG_VIRTIO_CONSOLE is not set
>> CONFIG_IPMI_HANDLER=m
>> CONFIG_IPMI_PANIC_EVENT=y
>> CONFIG_IPMI_PANIC_STRING=y
>> # CONFIG_IPMI_DEVICE_INTERFACE is not set
>> CONFIG_IPMI_SI=m
>> CONFIG_IPMI_SI_PROBE_DEFAULTS=y
>> CONFIG_IPMI_WATCHDOG=m
>> CONFIG_IPMI_POWEROFF=m
>> CONFIG_HW_RANDOM=m
>> CONFIG_HW_RANDOM_TIMERIOMEM=m
>> CONFIG_HW_RANDOM_INTEL=m
>> CONFIG_HW_RANDOM_AMD=m
>> CONFIG_HW_RANDOM_VIA=m
>> CONFIG_HW_RANDOM_VIRTIO=m
>> CONFIG_NVRAM=y
>> # CONFIG_R3964 is not set
>> # CONFIG_APPLICOM is not set
>> # CONFIG_MWAVE is not set
>> # CONFIG_HPET is not set
>> # CONFIG_HANGCHECK_TIMER is not set
>> # CONFIG_TCG_TPM is not set
>> CONFIG_TELCLOCK=m
>> CONFIG_DEVPORT=y
>> CONFIG_I2C=y
>> CONFIG_I2C_BOARDINFO=y
>> CONFIG_I2C_COMPAT=y
>> # CONFIG_I2C_CHARDEV is not set
>> CONFIG_I2C_MUX=y
>>
>> #
>> # Multiplexer I2C Chip support
>> #
>> CONFIG_I2C_MUX_GPIO=m
>> # CONFIG_I2C_MUX_PCA9541 is not set
>> CONFIG_I2C_MUX_PCA954x=y
>> CONFIG_I2C_HELPER_AUTO=y
>> CONFIG_I2C_SMBUS=y
>> CONFIG_I2C_ALGOBIT=y
>> CONFIG_I2C_ALGOPCA=y
>>
>> #
>> # I2C Hardware Bus support
>> #
>>
>> #
>> # PC SMBus host controller drivers
>> #
>> # CONFIG_I2C_ALI1535 is not set
>> # CONFIG_I2C_ALI1563 is not set
>> # CONFIG_I2C_ALI15X3 is not set
>> # CONFIG_I2C_AMD756 is not set
>> # CONFIG_I2C_AMD8111 is not set
>> # CONFIG_I2C_I801 is not set
>> # CONFIG_I2C_ISCH is not set
>> # CONFIG_I2C_ISMT is not set
>> # CONFIG_I2C_PIIX4 is not set
>> # CONFIG_I2C_NFORCE2 is not set
>> # CONFIG_I2C_SIS5595 is not set
>> # CONFIG_I2C_SIS630 is not set
>> # CONFIG_I2C_SIS96X is not set
>> # CONFIG_I2C_VIA is not set
>> # CONFIG_I2C_VIAPRO is not set
>>
>> #
>> # ACPI drivers
>> #
>> # CONFIG_I2C_SCMI is not set
>>
>> #
>> # I2C system bus drivers (mostly embedded / system-on-chip)
>> #
>> CONFIG_I2C_CBUS_GPIO=m
>> # CONFIG_I2C_DESIGNWARE_PLATFORM is not set
>> # CONFIG_I2C_DESIGNWARE_PCI is not set
>> CONFIG_I2C_EFM32=m
>> # CONFIG_I2C_EG20T is not set
>> # CONFIG_I2C_GPIO is not set
>> CONFIG_I2C_OCORES=m
>> CONFIG_I2C_PCA_PLATFORM=y
>> # CONFIG_I2C_PXA_PCI is not set
>> CONFIG_I2C_RIIC=y
>> CONFIG_I2C_SH_MOBILE=y
>> CONFIG_I2C_SIMTEC=y
>> CONFIG_I2C_XILINX=y
>> CONFIG_I2C_RCAR=m
>>
>> #
>> # External I2C/SMBus adapter drivers
>> #
>> # CONFIG_I2C_DIOLAN_U2C is not set
>> CONFIG_I2C_PARPORT_LIGHT=y
>> CONFIG_I2C_ROBOTFUZZ_OSIF=m
>> # CONFIG_I2C_TAOS_EVM is not set
>> CONFIG_I2C_TINY_USB=m
>>
>> #
>> # Other I2C/SMBus bus drivers
>> #
>> CONFIG_I2C_STUB=m
>> # CONFIG_I2C_DEBUG_CORE is not set
>> # CONFIG_I2C_DEBUG_ALGO is not set
>> # CONFIG_I2C_DEBUG_BUS is not set
>> # CONFIG_SPI is not set
>> CONFIG_SPMI=y
>> # CONFIG_HSI is not set
>>
>> #
>> # PPS support
>> #
>> CONFIG_PPS=y
>> # CONFIG_PPS_DEBUG is not set
>>
>> #
>> # PPS clients support
>> #
>> CONFIG_PPS_CLIENT_KTIMER=m
>> # CONFIG_PPS_CLIENT_LDISC is not set
>> CONFIG_PPS_CLIENT_GPIO=y
>>
>> #
>> # PPS generators support
>> #
>>
>> #
>> # PTP clock support
>> #
>> CONFIG_PTP_1588_CLOCK=m
>>
>> #
>> # Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
>> #
>> CONFIG_PTP_1588_CLOCK_PCH=m
>> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
>> CONFIG_GPIOLIB=y
>> CONFIG_GPIO_DEVRES=y
>> CONFIG_GPIO_ACPI=y
>> # CONFIG_DEBUG_GPIO is not set
>> # CONFIG_GPIO_SYSFS is not set
>> CONFIG_GPIO_GENERIC=m
>> CONFIG_GPIO_DA9055=m
>>
>> #
>> # Memory mapped GPIO drivers:
>> #
>> # CONFIG_GPIO_CLPS711X is not set
>> CONFIG_GPIO_GENERIC_PLATFORM=m
>> CONFIG_GPIO_IT8761E=y
>> # CONFIG_GPIO_F7188X is not set
>> CONFIG_GPIO_SCH311X=m
>> # CONFIG_GPIO_TS5500 is not set
>> # CONFIG_GPIO_SCH is not set
>> # CONFIG_GPIO_ICH is not set
>> # CONFIG_GPIO_VX855 is not set
>> # CONFIG_GPIO_LYNXPOINT is not set
>>
>> #
>> # I2C GPIO expanders:
>> #
>> # CONFIG_GPIO_ARIZONA is not set
>> # CONFIG_GPIO_LP3943 is not set
>> # CONFIG_GPIO_MAX7300 is not set
>> # CONFIG_GPIO_MAX732X is not set
>> CONFIG_GPIO_PCA953X=m
>> CONFIG_GPIO_PCF857X=y
>> # CONFIG_GPIO_SX150X is not set
>> CONFIG_GPIO_STMPE=y
>> CONFIG_GPIO_TWL6040=y
>> CONFIG_GPIO_WM8350=m
>> # CONFIG_GPIO_WM8994 is not set
>> CONFIG_GPIO_ADP5520=m
>> # CONFIG_GPIO_ADP5588 is not set
>>
>> #
>> # PCI GPIO expanders:
>> #
>> # CONFIG_GPIO_BT8XX is not set
>> # CONFIG_GPIO_AMD8111 is not set
>> # CONFIG_GPIO_INTEL_MID is not set
>> # CONFIG_GPIO_PCH is not set
>> # CONFIG_GPIO_ML_IOH is not set
>> # CONFIG_GPIO_RDC321X is not set
>>
>> #
>> # SPI GPIO expanders:
>> #
>>
>> #
>> # AC97 GPIO expanders:
>> #
>>
>> #
>> # LPC GPIO expanders:
>> #
>>
>> #
>> # MODULbus GPIO expanders:
>> #
>> CONFIG_GPIO_TPS65910=y
>>
>> #
>> # USB GPIO expanders:
>> #
>> CONFIG_W1=m
>> CONFIG_W1_CON=y
>>
>> #
>> # 1-wire Bus Masters
>> #
>> # CONFIG_W1_MASTER_MATROX is not set
>> # CONFIG_W1_MASTER_DS2490 is not set
>> CONFIG_W1_MASTER_DS2482=m
>> # CONFIG_W1_MASTER_MXC is not set
>> CONFIG_W1_MASTER_DS1WM=m
>> CONFIG_W1_MASTER_GPIO=m
>>
>> #
>> # 1-wire Slaves
>> #
>> CONFIG_W1_SLAVE_THERM=m
>> # CONFIG_W1_SLAVE_SMEM is not set
>> # CONFIG_W1_SLAVE_DS2408 is not set
>> CONFIG_W1_SLAVE_DS2413=m
>> # CONFIG_W1_SLAVE_DS2423 is not set
>> CONFIG_W1_SLAVE_DS2431=m
>> # CONFIG_W1_SLAVE_DS2433 is not set
>> CONFIG_W1_SLAVE_DS2760=m
>> CONFIG_W1_SLAVE_DS2780=m
>> CONFIG_W1_SLAVE_DS2781=m
>> CONFIG_W1_SLAVE_DS28E04=m
>> CONFIG_W1_SLAVE_BQ27000=m
>> CONFIG_POWER_SUPPLY=y
>> CONFIG_POWER_SUPPLY_DEBUG=y
>> CONFIG_PDA_POWER=y
>> CONFIG_GENERIC_ADC_BATTERY=m
>> CONFIG_MAX8925_POWER=m
>> CONFIG_WM8350_POWER=y
>> # CONFIG_TEST_POWER is not set
>> CONFIG_BATTERY_DS2760=m
>> CONFIG_BATTERY_DS2780=m
>> # CONFIG_BATTERY_DS2781 is not set
>> CONFIG_BATTERY_DS2782=m
>> CONFIG_BATTERY_SBS=y
>> CONFIG_BATTERY_BQ27x00=y
>> # CONFIG_BATTERY_BQ27X00_I2C is not set
>> # CONFIG_BATTERY_BQ27X00_PLATFORM is not set
>> CONFIG_BATTERY_DA9030=m
>> # CONFIG_BATTERY_MAX17040 is not set
>> # CONFIG_BATTERY_MAX17042 is not set
>> CONFIG_CHARGER_PCF50633=m
>> CONFIG_CHARGER_ISP1704=m
>> # CONFIG_CHARGER_MAX8903 is not set
>> CONFIG_CHARGER_LP8727=m
>> CONFIG_CHARGER_LP8788=m
>> CONFIG_CHARGER_GPIO=y
>> # CONFIG_CHARGER_MANAGER is not set
>> CONFIG_CHARGER_MAX14577=y
>> # CONFIG_CHARGER_BQ2415X is not set
>> CONFIG_CHARGER_BQ24190=y
>> # CONFIG_CHARGER_BQ24735 is not set
>> # CONFIG_CHARGER_SMB347 is not set
>> CONFIG_CHARGER_TPS65090=m
>> CONFIG_BATTERY_GOLDFISH=m
>> # CONFIG_POWER_RESET is not set
>> # CONFIG_POWER_AVS is not set
>> CONFIG_HWMON=y
>> CONFIG_HWMON_VID=y
>> # CONFIG_HWMON_DEBUG_CHIP is not set
>>
>> #
>> # Native drivers
>> #
>> # CONFIG_SENSORS_ABITUGURU is not set
>> CONFIG_SENSORS_ABITUGURU3=y
>> CONFIG_SENSORS_AD7414=m
>> CONFIG_SENSORS_AD7418=y
>> # CONFIG_SENSORS_ADM1021 is not set
>> # CONFIG_SENSORS_ADM1025 is not set
>> CONFIG_SENSORS_ADM1026=y
>> CONFIG_SENSORS_ADM1029=y
>> CONFIG_SENSORS_ADM1031=y
>> CONFIG_SENSORS_ADM9240=y
>> # CONFIG_SENSORS_ADT7410 is not set
>> CONFIG_SENSORS_ADT7411=m
>> CONFIG_SENSORS_ADT7462=m
>> CONFIG_SENSORS_ADT7470=y
>> # CONFIG_SENSORS_ADT7475 is not set
>> CONFIG_SENSORS_ASC7621=y
>> # CONFIG_SENSORS_K8TEMP is not set
>> # CONFIG_SENSORS_K10TEMP is not set
>> # CONFIG_SENSORS_FAM15H_POWER is not set
>> CONFIG_SENSORS_APPLESMC=m
>> CONFIG_SENSORS_ASB100=y
>> CONFIG_SENSORS_ATXP1=y
>> CONFIG_SENSORS_DS620=y
>> CONFIG_SENSORS_DS1621=y
>> CONFIG_SENSORS_DA9055=y
>> # CONFIG_SENSORS_I5K_AMB is not set
>> CONFIG_SENSORS_F71805F=m
>> CONFIG_SENSORS_F71882FG=y
>> CONFIG_SENSORS_F75375S=y
>> CONFIG_SENSORS_MC13783_ADC=m
>> CONFIG_SENSORS_FSCHMD=y
>> CONFIG_SENSORS_GL518SM=m
>> # CONFIG_SENSORS_GL520SM is not set
>> CONFIG_SENSORS_G760A=y
>> CONFIG_SENSORS_G762=m
>> CONFIG_SENSORS_GPIO_FAN=y
>> CONFIG_SENSORS_HIH6130=m
>> CONFIG_SENSORS_IBMAEM=m
>> CONFIG_SENSORS_IBMPEX=m
>> CONFIG_SENSORS_IIO_HWMON=m
>> # CONFIG_SENSORS_CORETEMP is not set
>> # CONFIG_SENSORS_IT87 is not set
>> CONFIG_SENSORS_JC42=m
>> # CONFIG_SENSORS_LINEAGE is not set
>> # CONFIG_SENSORS_LTC2945 is not set
>> CONFIG_SENSORS_LTC4151=m
>> CONFIG_SENSORS_LTC4215=m
>> CONFIG_SENSORS_LTC4222=y
>> CONFIG_SENSORS_LTC4245=m
>> CONFIG_SENSORS_LTC4260=m
>> CONFIG_SENSORS_LTC4261=y
>> # CONFIG_SENSORS_MAX16065 is not set
>> CONFIG_SENSORS_MAX1619=m
>> CONFIG_SENSORS_MAX1668=y
>> # CONFIG_SENSORS_MAX197 is not set
>> # CONFIG_SENSORS_MAX6639 is not set
>> CONFIG_SENSORS_MAX6642=y
>> CONFIG_SENSORS_MAX6650=y
>> CONFIG_SENSORS_MAX6697=m
>> CONFIG_SENSORS_HTU21=m
>> # CONFIG_SENSORS_MCP3021 is not set
>> # CONFIG_SENSORS_LM63 is not set
>> CONFIG_SENSORS_LM73=y
>> CONFIG_SENSORS_LM75=m
>> # CONFIG_SENSORS_LM77 is not set
>> CONFIG_SENSORS_LM78=m
>> CONFIG_SENSORS_LM80=m
>> CONFIG_SENSORS_LM83=y
>> # CONFIG_SENSORS_LM85 is not set
>> # CONFIG_SENSORS_LM87 is not set
>> CONFIG_SENSORS_LM90=y
>> CONFIG_SENSORS_LM92=y
>> # CONFIG_SENSORS_LM93 is not set
>> CONFIG_SENSORS_LM95234=m
>> CONFIG_SENSORS_LM95241=m
>> # CONFIG_SENSORS_LM95245 is not set
>> # CONFIG_SENSORS_PC87360 is not set
>> CONFIG_SENSORS_PC87427=m
>> CONFIG_SENSORS_NCT6775=m
>> # CONFIG_SENSORS_PCF8591 is not set
>> CONFIG_PMBUS=m
>> CONFIG_SENSORS_PMBUS=m
>> CONFIG_SENSORS_ADM1275=m
>> CONFIG_SENSORS_LM25066=m
>> CONFIG_SENSORS_LTC2978=m
>> # CONFIG_SENSORS_MAX16064 is not set
>> CONFIG_SENSORS_MAX34440=m
>> # CONFIG_SENSORS_MAX8688 is not set
>> CONFIG_SENSORS_UCD9000=m
>> CONFIG_SENSORS_UCD9200=m
>> # CONFIG_SENSORS_ZL6100 is not set
>> CONFIG_SENSORS_SHT15=y
>> CONFIG_SENSORS_SHT21=m
>> # CONFIG_SENSORS_SIS5595 is not set
>> CONFIG_SENSORS_DME1737=m
>> CONFIG_SENSORS_EMC1403=y
>> CONFIG_SENSORS_EMC2103=m
>> # CONFIG_SENSORS_EMC6W201 is not set
>> # CONFIG_SENSORS_SMSC47M1 is not set
>> CONFIG_SENSORS_SMSC47M192=y
>> CONFIG_SENSORS_SMSC47B397=y
>> CONFIG_SENSORS_SCH56XX_COMMON=y
>> CONFIG_SENSORS_SCH5627=y
>> CONFIG_SENSORS_SCH5636=y
>> CONFIG_SENSORS_SMM665=m
>> # CONFIG_SENSORS_ADC128D818 is not set
>> CONFIG_SENSORS_ADS1015=m
>> CONFIG_SENSORS_ADS7828=m
>> CONFIG_SENSORS_AMC6821=m
>> CONFIG_SENSORS_INA209=m
>> CONFIG_SENSORS_INA2XX=y
>> CONFIG_SENSORS_THMC50=y
>> CONFIG_SENSORS_TMP102=m
>> CONFIG_SENSORS_TMP401=y
>> CONFIG_SENSORS_TMP421=y
>> CONFIG_SENSORS_VIA_CPUTEMP=y
>> # CONFIG_SENSORS_VIA686A is not set
>> CONFIG_SENSORS_VT1211=m
>> # CONFIG_SENSORS_VT8231 is not set
>> CONFIG_SENSORS_W83781D=y
>> CONFIG_SENSORS_W83791D=m
>> CONFIG_SENSORS_W83792D=m
>> CONFIG_SENSORS_W83793=m
>> CONFIG_SENSORS_W83795=m
>> # CONFIG_SENSORS_W83795_FANCTRL is not set
>> CONFIG_SENSORS_W83L785TS=m
>> # CONFIG_SENSORS_W83L786NG is not set
>> CONFIG_SENSORS_W83627HF=y
>> CONFIG_SENSORS_W83627EHF=m
>> # CONFIG_SENSORS_WM8350 is not set
>>
>> #
>> # ACPI drivers
>> #
>> # CONFIG_SENSORS_ACPI_POWER is not set
>> # CONFIG_SENSORS_ATK0110 is not set
>> CONFIG_THERMAL=y
>> CONFIG_THERMAL_HWMON=y
>> CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
>> # CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
>> # CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
>> # CONFIG_THERMAL_GOV_FAIR_SHARE is not set
>> CONFIG_THERMAL_GOV_STEP_WISE=y
>> # CONFIG_THERMAL_GOV_USER_SPACE is not set
>> # CONFIG_THERMAL_EMULATION is not set
>> # CONFIG_RCAR_THERMAL is not set
>> # CONFIG_ACPI_INT3403_THERMAL is not set
>>
>> #
>> # Texas Instruments thermal drivers
>> #
>> CONFIG_WATCHDOG=y
>> CONFIG_WATCHDOG_CORE=y
>> CONFIG_WATCHDOG_NOWAYOUT=y
>>
>> #
>> # Watchdog Device Drivers
>> #
>> CONFIG_SOFT_WATCHDOG=m
>> # CONFIG_DA9055_WATCHDOG is not set
>> # CONFIG_WM8350_WATCHDOG is not set
>> CONFIG_XILINX_WATCHDOG=y
>> # CONFIG_DW_WATCHDOG is not set
>> CONFIG_RETU_WATCHDOG=y
>> CONFIG_TEGRA_WATCHDOG=m
>> CONFIG_ACQUIRE_WDT=m
>> CONFIG_ADVANTECH_WDT=y
>> # CONFIG_ALIM1535_WDT is not set
>> # CONFIG_ALIM7101_WDT is not set
>> CONFIG_F71808E_WDT=m
>> # CONFIG_SP5100_TCO is not set
>> CONFIG_SBC_FITPC2_WATCHDOG=y
>> # CONFIG_EUROTECH_WDT is not set
>> CONFIG_IB700_WDT=y
>> CONFIG_IBMASR=y
>> CONFIG_WAFER_WDT=y
>> # CONFIG_I6300ESB_WDT is not set
>> # CONFIG_IE6XX_WDT is not set
>> # CONFIG_ITCO_WDT is not set
>> CONFIG_IT8712F_WDT=y
>> CONFIG_IT87_WDT=y
>> # CONFIG_HP_WATCHDOG is not set
>> CONFIG_SC1200_WDT=y
>> CONFIG_PC87413_WDT=m
>> # CONFIG_NV_TCO is not set
>> CONFIG_60XX_WDT=m
>> CONFIG_SBC8360_WDT=m
>> CONFIG_CPU5_WDT=y
>> # CONFIG_SMSC_SCH311X_WDT is not set
>> # CONFIG_SMSC37B787_WDT is not set
>> # CONFIG_VIA_WDT is not set
>> CONFIG_W83627HF_WDT=m
>> CONFIG_W83697HF_WDT=y
>> CONFIG_W83697UG_WDT=m
>> CONFIG_W83877F_WDT=y
>> CONFIG_W83977F_WDT=m
>> # CONFIG_MACHZ_WDT is not set
>> # CONFIG_SBC_EPX_C3_WATCHDOG is not set
>> CONFIG_MEN_A21_WDT=y
>>
>> #
>> # PCI-based Watchdog Cards
>> #
>> # CONFIG_PCIPCWATCHDOG is not set
>> # CONFIG_WDTPCI is not set
>>
>> #
>> # USB-based Watchdog Cards
>> #
>> CONFIG_USBPCWATCHDOG=m
>> CONFIG_SSB_POSSIBLE=y
>>
>> #
>> # Sonics Silicon Backplane
>> #
>> CONFIG_SSB=m
>> CONFIG_SSB_SPROM=y
>> CONFIG_SSB_PCIHOST_POSSIBLE=y
>> CONFIG_SSB_PCIHOST=y
>> # CONFIG_SSB_B43_PCI_BRIDGE is not set
>> CONFIG_SSB_SDIOHOST_POSSIBLE=y
>> CONFIG_SSB_SDIOHOST=y
>> # CONFIG_SSB_SILENT is not set
>> # CONFIG_SSB_DEBUG is not set
>> CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
>> # CONFIG_SSB_DRIVER_PCICORE is not set
>> CONFIG_SSB_DRIVER_GPIO=y
>> CONFIG_BCMA_POSSIBLE=y
>>
>> #
>> # Broadcom specific AMBA
>> #
>> # CONFIG_BCMA is not set
>>
>> #
>> # Multifunction device drivers
>> #
>> CONFIG_MFD_CORE=y
>> # CONFIG_MFD_CS5535 is not set
>> # CONFIG_MFD_AS3711 is not set
>> CONFIG_PMIC_ADP5520=y
>> CONFIG_MFD_AAT2870_CORE=y
>> CONFIG_MFD_BCM590XX=y
>> CONFIG_MFD_CROS_EC=y
>> CONFIG_MFD_CROS_EC_I2C=m
>> CONFIG_PMIC_DA903X=y
>> # CONFIG_MFD_DA9052_I2C is not set
>> CONFIG_MFD_DA9055=y
>> CONFIG_MFD_DA9063=y
>> CONFIG_MFD_MC13XXX=m
>> CONFIG_MFD_MC13XXX_I2C=m
>> CONFIG_HTC_PASIC3=m
>> # CONFIG_HTC_I2CPLD is not set
>> # CONFIG_LPC_ICH is not set
>> # CONFIG_LPC_SCH is not set
>> # CONFIG_MFD_JANZ_CMODIO is not set
>> # CONFIG_MFD_KEMPLD is not set
>> CONFIG_MFD_88PM800=y
>> CONFIG_MFD_88PM805=y
>> # CONFIG_MFD_88PM860X is not set
>> CONFIG_MFD_MAX14577=y
>> CONFIG_MFD_MAX77686=y
>> CONFIG_MFD_MAX77693=y
>> CONFIG_MFD_MAX8907=m
>> CONFIG_MFD_MAX8925=y
>> # CONFIG_MFD_MAX8997 is not set
>> CONFIG_MFD_MAX8998=y
>> # CONFIG_MFD_VIPERBOARD is not set
>> CONFIG_MFD_RETU=y
>> CONFIG_MFD_PCF50633=m
>> CONFIG_PCF50633_ADC=m
>> # CONFIG_PCF50633_GPIO is not set
>> # CONFIG_MFD_RDC321X is not set
>> # CONFIG_MFD_RTSX_PCI is not set
>> CONFIG_MFD_RTSX_USB=m
>> # CONFIG_MFD_RC5T583 is not set
>> # CONFIG_MFD_SEC_CORE is not set
>> CONFIG_MFD_SI476X_CORE=m
>> CONFIG_MFD_SM501=m
>> CONFIG_MFD_SM501_GPIO=y
>> CONFIG_MFD_SMSC=y
>> # CONFIG_ABX500_CORE is not set
>> CONFIG_MFD_STMPE=y
>>
>> #
>> # STMicroelectronics STMPE Interface Drivers
>> #
>> CONFIG_STMPE_I2C=y
>> CONFIG_MFD_SYSCON=y
>> CONFIG_MFD_TI_AM335X_TSCADC=y
>> CONFIG_MFD_LP3943=y
>> CONFIG_MFD_LP8788=y
>> # CONFIG_MFD_PALMAS is not set
>> CONFIG_TPS6105X=m
>> # CONFIG_TPS65010 is not set
>> CONFIG_TPS6507X=m
>> CONFIG_MFD_TPS65090=y
>> CONFIG_MFD_TPS65217=m
>> CONFIG_MFD_TPS65218=y
>> # CONFIG_MFD_TPS6586X is not set
>> CONFIG_MFD_TPS65910=y
>> # CONFIG_MFD_TPS65912 is not set
>> # CONFIG_MFD_TPS65912_I2C is not set
>> # CONFIG_MFD_TPS80031 is not set
>> # CONFIG_TWL4030_CORE is not set
>> CONFIG_TWL6040_CORE=y
>> # CONFIG_MFD_WL1273_CORE is not set
>> # CONFIG_MFD_LM3533 is not set
>> # CONFIG_MFD_TIMBERDALE is not set
>> # CONFIG_MFD_TC3589X is not set
>> # CONFIG_MFD_TMIO is not set
>> # CONFIG_MFD_VX855 is not set
>> CONFIG_MFD_ARIZONA=y
>> CONFIG_MFD_ARIZONA_I2C=y
>> # CONFIG_MFD_WM5102 is not set
>> CONFIG_MFD_WM5110=y
>> CONFIG_MFD_WM8997=y
>> # CONFIG_MFD_WM8400 is not set
>> # CONFIG_MFD_WM831X_I2C is not set
>> CONFIG_MFD_WM8350=y
>> CONFIG_MFD_WM8350_I2C=y
>> CONFIG_MFD_WM8994=y
>> CONFIG_REGULATOR=y
>> CONFIG_REGULATOR_DEBUG=y
>> CONFIG_REGULATOR_FIXED_VOLTAGE=m
>> # CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
>> CONFIG_REGULATOR_USERSPACE_CONSUMER=y
>> CONFIG_REGULATOR_88PM800=y
>> # CONFIG_REGULATOR_ACT8865 is not set
>> # CONFIG_REGULATOR_AD5398 is not set
>> CONFIG_REGULATOR_ANATOP=m
>> CONFIG_REGULATOR_AAT2870=y
>> CONFIG_REGULATOR_BCM590XX=m
>> CONFIG_REGULATOR_DA903X=m
>> CONFIG_REGULATOR_DA9055=m
>> CONFIG_REGULATOR_DA9063=m
>> # CONFIG_REGULATOR_DA9210 is not set
>> CONFIG_REGULATOR_FAN53555=m
>> CONFIG_REGULATOR_GPIO=y
>> CONFIG_REGULATOR_ISL6271A=m
>> # CONFIG_REGULATOR_LP3971 is not set
>> CONFIG_REGULATOR_LP3972=m
>> CONFIG_REGULATOR_LP872X=m
>> CONFIG_REGULATOR_LP8755=m
>> # CONFIG_REGULATOR_LP8788 is not set
>> # CONFIG_REGULATOR_MAX14577 is not set
>> CONFIG_REGULATOR_MAX1586=m
>> # CONFIG_REGULATOR_MAX8649 is not set
>> CONFIG_REGULATOR_MAX8660=y
>> CONFIG_REGULATOR_MAX8907=m
>> CONFIG_REGULATOR_MAX8925=m
>> CONFIG_REGULATOR_MAX8952=y
>> CONFIG_REGULATOR_MAX8973=y
>> # CONFIG_REGULATOR_MAX8998 is not set
>> CONFIG_REGULATOR_MAX77686=y
>> # CONFIG_REGULATOR_MAX77693 is not set
>> CONFIG_REGULATOR_MC13XXX_CORE=m
>> CONFIG_REGULATOR_MC13783=m
>> CONFIG_REGULATOR_MC13892=m
>> # CONFIG_REGULATOR_PBIAS is not set
>> # CONFIG_REGULATOR_PCF50633 is not set
>> CONFIG_REGULATOR_PFUZE100=y
>> CONFIG_REGULATOR_TPS51632=m
>> CONFIG_REGULATOR_TPS6105X=m
>> CONFIG_REGULATOR_TPS62360=m
>> CONFIG_REGULATOR_TPS65023=m
>> # CONFIG_REGULATOR_TPS6507X is not set
>> CONFIG_REGULATOR_TPS65090=y
>> # CONFIG_REGULATOR_TPS65217 is not set
>> CONFIG_REGULATOR_TPS65910=y
>> CONFIG_REGULATOR_WM8350=m
>> # CONFIG_REGULATOR_WM8994 is not set
>> CONFIG_MEDIA_SUPPORT=y
>>
>> #
>> # Multimedia core support
>> #
>> CONFIG_MEDIA_CAMERA_SUPPORT=y
>> # CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
>> # CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
>> CONFIG_MEDIA_RADIO_SUPPORT=y
>> CONFIG_MEDIA_RC_SUPPORT=y
>> # CONFIG_MEDIA_CONTROLLER is not set
>> CONFIG_VIDEO_DEV=y
>> CONFIG_VIDEO_V4L2=y
>> # CONFIG_VIDEO_ADV_DEBUG is not set
>> # CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
>> CONFIG_V4L2_MEM2MEM_DEV=y
>> CONFIG_VIDEOBUF_GEN=y
>> CONFIG_VIDEOBUF_DMA_CONTIG=y
>> CONFIG_VIDEOBUF2_CORE=y
>> CONFIG_VIDEOBUF2_MEMOPS=y
>> CONFIG_VIDEOBUF2_DMA_CONTIG=y
>> CONFIG_VIDEOBUF2_VMALLOC=m
>> # CONFIG_TTPCI_EEPROM is not set
>>
>> #
>> # Media drivers
>> #
>> CONFIG_RC_CORE=y
>> CONFIG_RC_MAP=m
>> CONFIG_RC_DECODERS=y
>> # CONFIG_LIRC is not set
>> CONFIG_IR_NEC_DECODER=m
>> # CONFIG_IR_RC5_DECODER is not set
>> # CONFIG_IR_RC6_DECODER is not set
>> # CONFIG_IR_JVC_DECODER is not set
>> # CONFIG_IR_SONY_DECODER is not set
>> CONFIG_IR_RC5_SZ_DECODER=m
>> CONFIG_IR_SANYO_DECODER=m
>> # CONFIG_IR_SHARP_DECODER is not set
>> # CONFIG_IR_MCE_KBD_DECODER is not set
>> CONFIG_RC_DEVICES=y
>> # CONFIG_RC_ATI_REMOTE is not set
>> # CONFIG_IR_ENE is not set
>> CONFIG_IR_IMON=m
>> # CONFIG_IR_MCEUSB is not set
>> # CONFIG_IR_ITE_CIR is not set
>> # CONFIG_IR_FINTEK is not set
>> # CONFIG_IR_NUVOTON is not set
>> CONFIG_IR_REDRAT3=m
>> CONFIG_IR_STREAMZAP=m
>> # CONFIG_IR_WINBOND_CIR is not set
>> CONFIG_IR_IGUANA=m
>> CONFIG_IR_TTUSBIR=m
>> CONFIG_IR_IMG=m
>> CONFIG_IR_IMG_RAW=y
>> # CONFIG_IR_IMG_HW is not set
>> CONFIG_RC_LOOPBACK=m
>> CONFIG_IR_GPIO_CIR=m
>> # CONFIG_MEDIA_USB_SUPPORT is not set
>> # CONFIG_MEDIA_PCI_SUPPORT is not set
>> CONFIG_V4L_PLATFORM_DRIVERS=y
>> # CONFIG_VIDEO_CAFE_CCIC is not set
>> CONFIG_VIDEO_SH_VOU=y
>> CONFIG_SOC_CAMERA=y
>> CONFIG_SOC_CAMERA_PLATFORM=m
>> # CONFIG_VIDEO_RCAR_VIN is not set
>> CONFIG_V4L_MEM2MEM_DRIVERS=y
>> CONFIG_VIDEO_SH_VEU=y
>> CONFIG_V4L_TEST_DRIVERS=y
>> CONFIG_VIDEO_VIVI=m
>> CONFIG_VIDEO_MEM2MEM_TESTDEV=m
>>
>> #
>> # Supported MMC/SDIO adapters
>> #
>> # CONFIG_RADIO_ADAPTERS is not set
>> CONFIG_CYPRESS_FIRMWARE=m
>>
>> #
>> # Media ancillary drivers (tuners, sensors, i2c, frontends)
>> #
>> CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
>> CONFIG_MEDIA_ATTACH=y
>> CONFIG_VIDEO_IR_I2C=y
>>
>> #
>> # Audio decoders, processors and mixers
>> #
>>
>> #
>> # RDS decoders
>> #
>>
>> #
>> # Video decoders
>> #
>>
>> #
>> # Video and audio decoders
>> #
>>
>> #
>> # Video encoders
>> #
>>
>> #
>> # Camera sensor devices
>> #
>>
>> #
>> # Flash devices
>> #
>>
>> #
>> # Video improvement chips
>> #
>>
>> #
>> # Audio/Video compression chips
>> #
>>
>> #
>> # Miscellaneous helper chips
>> #
>>
>> #
>> # Sensors used on soc_camera driver
>> #
>>
>> #
>> # soc_camera sensor drivers
>> #
>> CONFIG_SOC_CAMERA_IMX074=m
>> CONFIG_SOC_CAMERA_MT9M001=y
>> # CONFIG_SOC_CAMERA_MT9M111 is not set
>> CONFIG_SOC_CAMERA_MT9T031=y
>> CONFIG_SOC_CAMERA_MT9T112=m
>> CONFIG_SOC_CAMERA_MT9V022=y
>> CONFIG_SOC_CAMERA_OV2640=m
>> CONFIG_SOC_CAMERA_OV5642=y
>> # CONFIG_SOC_CAMERA_OV6650 is not set
>> CONFIG_SOC_CAMERA_OV772X=y
>> CONFIG_SOC_CAMERA_OV9640=y
>> # CONFIG_SOC_CAMERA_OV9740 is not set
>> CONFIG_SOC_CAMERA_RJ54N1=y
>> CONFIG_SOC_CAMERA_TW9910=m
>> CONFIG_MEDIA_TUNER=y
>> CONFIG_MEDIA_TUNER_SIMPLE=y
>> CONFIG_MEDIA_TUNER_TDA8290=y
>> CONFIG_MEDIA_TUNER_TDA827X=y
>> CONFIG_MEDIA_TUNER_TDA18271=y
>> CONFIG_MEDIA_TUNER_TDA9887=y
>> CONFIG_MEDIA_TUNER_TEA5761=y
>> CONFIG_MEDIA_TUNER_TEA5767=y
>> CONFIG_MEDIA_TUNER_MT20XX=y
>> CONFIG_MEDIA_TUNER_XC2028=y
>> CONFIG_MEDIA_TUNER_XC5000=y
>> CONFIG_MEDIA_TUNER_XC4000=y
>> CONFIG_MEDIA_TUNER_MC44S803=y
>>
>> #
>> # Tools to develop new frontends
>> #
>> # CONFIG_DVB_DUMMY_FE is not set
>>
>> #
>> # Graphics support
>> #
>> # CONFIG_AGP is not set
>> CONFIG_VGA_ARB=y
>> CONFIG_VGA_ARB_MAX_GPUS=16
>> # CONFIG_VGA_SWITCHEROO is not set
>>
>> #
>> # Direct Rendering Manager
>> #
>> CONFIG_DRM=m
>> CONFIG_DRM_KMS_HELPER=m
>> # CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
>>
>> #
>> # I2C encoder or helper chips
>> #
>> # CONFIG_DRM_I2C_CH7006 is not set
>> # CONFIG_DRM_I2C_SIL164 is not set
>> CONFIG_DRM_I2C_NXP_TDA998X=m
>> # CONFIG_DRM_TDFX is not set
>> # CONFIG_DRM_R128 is not set
>> # CONFIG_DRM_RADEON is not set
>> # CONFIG_DRM_NOUVEAU is not set
>> # CONFIG_DRM_I915 is not set
>> # CONFIG_DRM_MGA is not set
>> # CONFIG_DRM_VIA is not set
>> # CONFIG_DRM_SAVAGE is not set
>> # CONFIG_DRM_VMWGFX is not set
>> # CONFIG_DRM_GMA500 is not set
>> # CONFIG_DRM_UDL is not set
>> # CONFIG_DRM_AST is not set
>> # CONFIG_DRM_MGAG200 is not set
>> # CONFIG_DRM_CIRRUS_QEMU is not set
>> # CONFIG_DRM_QXL is not set
>> # CONFIG_DRM_BOCHS is not set
>> CONFIG_DRM_PTN3460=m
>>
>> #
>> # Frame buffer Devices
>> #
>> CONFIG_FB=m
>> CONFIG_FIRMWARE_EDID=y
>> # CONFIG_FB_DDC is not set
>> # CONFIG_FB_BOOT_VESA_SUPPORT is not set
>> CONFIG_FB_CFB_FILLRECT=m
>> CONFIG_FB_CFB_COPYAREA=m
>> CONFIG_FB_CFB_IMAGEBLIT=m
>> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
>> CONFIG_FB_SYS_FILLRECT=m
>> CONFIG_FB_SYS_COPYAREA=m
>> CONFIG_FB_SYS_IMAGEBLIT=m
>> # CONFIG_FB_FOREIGN_ENDIAN is not set
>> CONFIG_FB_SYS_FOPS=m
>> CONFIG_FB_DEFERRED_IO=y
>> CONFIG_FB_HECUBA=m
>> # CONFIG_FB_SVGALIB is not set
>> # CONFIG_FB_MACMODES is not set
>> # CONFIG_FB_BACKLIGHT is not set
>> CONFIG_FB_MODE_HELPERS=y
>> CONFIG_FB_TILEBLITTING=y
>>
>> #
>> # Frame buffer hardware drivers
>> #
>> # CONFIG_FB_CIRRUS is not set
>> # CONFIG_FB_PM2 is not set
>> # CONFIG_FB_CYBER2000 is not set
>> CONFIG_FB_ARC=m
>> # CONFIG_FB_VGA16 is not set
>> # CONFIG_FB_UVESA is not set
>> CONFIG_FB_N411=m
>> CONFIG_FB_HGA=m
>> CONFIG_FB_OPENCORES=m
>> CONFIG_FB_S1D13XXX=m
>> # CONFIG_FB_NVIDIA is not set
>> # CONFIG_FB_RIVA is not set
>> # CONFIG_FB_I740 is not set
>> # CONFIG_FB_LE80578 is not set
>> # CONFIG_FB_MATROX is not set
>> # CONFIG_FB_RADEON is not set
>> # CONFIG_FB_ATY128 is not set
>> # CONFIG_FB_ATY is not set
>> # CONFIG_FB_S3 is not set
>> # CONFIG_FB_SAVAGE is not set
>> # CONFIG_FB_SIS is not set
>> # CONFIG_FB_VIA is not set
>> # CONFIG_FB_NEOMAGIC is not set
>> # CONFIG_FB_KYRO is not set
>> # CONFIG_FB_3DFX is not set
>> # CONFIG_FB_VOODOO1 is not set
>> # CONFIG_FB_VT8623 is not set
>> # CONFIG_FB_TRIDENT is not set
>> # CONFIG_FB_ARK is not set
>> # CONFIG_FB_PM3 is not set
>> # CONFIG_FB_CARMINE is not set
>> # CONFIG_FB_GEODE is not set
>> CONFIG_FB_TMIO=m
>> CONFIG_FB_TMIO_ACCELL=y
>> CONFIG_FB_SM501=m
>> CONFIG_FB_SMSCUFX=m
>> CONFIG_FB_UDL=m
>> # CONFIG_FB_GOLDFISH is not set
>> # CONFIG_FB_VIRTUAL is not set
>> CONFIG_FB_METRONOME=m
>> # CONFIG_FB_MB862XX is not set
>> # CONFIG_FB_BROADSHEET is not set
>> CONFIG_FB_AUO_K190X=m
>> CONFIG_FB_AUO_K1900=m
>> # CONFIG_FB_AUO_K1901 is not set
>> # CONFIG_EXYNOS_VIDEO is not set
>> CONFIG_BACKLIGHT_LCD_SUPPORT=y
>> CONFIG_LCD_CLASS_DEVICE=y
>> CONFIG_LCD_PLATFORM=m
>> CONFIG_BACKLIGHT_CLASS_DEVICE=m
>> CONFIG_BACKLIGHT_GENERIC=m
>> CONFIG_BACKLIGHT_PWM=m
>> CONFIG_BACKLIGHT_DA903X=m
>> CONFIG_BACKLIGHT_MAX8925=m
>> # CONFIG_BACKLIGHT_APPLE is not set
>> CONFIG_BACKLIGHT_SAHARA=m
>> # CONFIG_BACKLIGHT_ADP5520 is not set
>> # CONFIG_BACKLIGHT_ADP8860 is not set
>> # CONFIG_BACKLIGHT_ADP8870 is not set
>> CONFIG_BACKLIGHT_PCF50633=m
>> # CONFIG_BACKLIGHT_AAT2870 is not set
>> CONFIG_BACKLIGHT_LM3630A=m
>> CONFIG_BACKLIGHT_LM3639=m
>> # CONFIG_BACKLIGHT_LP855X is not set
>> CONFIG_BACKLIGHT_LP8788=m
>> CONFIG_BACKLIGHT_TPS65217=m
>> CONFIG_BACKLIGHT_GPIO=m
>> CONFIG_BACKLIGHT_LV5207LP=m
>> # CONFIG_BACKLIGHT_BD6107 is not set
>> # CONFIG_VGASTATE is not set
>> CONFIG_HDMI=y
>> # CONFIG_LOGO is not set
>> CONFIG_SOUND=y
>> CONFIG_SOUND_OSS_CORE=y
>> # CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
>> # CONFIG_SND is not set
>> CONFIG_SOUND_PRIME=m
>>
>> #
>> # HID support
>> #
>> CONFIG_HID=m
>> # CONFIG_HIDRAW is not set
>> CONFIG_UHID=m
>> CONFIG_HID_GENERIC=m
>>
>> #
>> # Special HID drivers
>> #
>> # CONFIG_HID_A4TECH is not set
>> CONFIG_HID_ACRUX=m
>> # CONFIG_HID_ACRUX_FF is not set
>> CONFIG_HID_APPLE=m
>> # CONFIG_HID_APPLEIR is not set
>> # CONFIG_HID_AUREAL is not set
>> # CONFIG_HID_BELKIN is not set
>> CONFIG_HID_CHERRY=m
>> # CONFIG_HID_CHICONY is not set
>> CONFIG_HID_CP2112=m
>> CONFIG_HID_CYPRESS=m
>> CONFIG_HID_DRAGONRISE=m
>> # CONFIG_DRAGONRISE_FF is not set
>> CONFIG_HID_EMS_FF=m
>> CONFIG_HID_ELECOM=m
>> # CONFIG_HID_ELO is not set
>> # CONFIG_HID_EZKEY is not set
>> # CONFIG_HID_HOLTEK is not set
>> CONFIG_HID_HUION=m
>> CONFIG_HID_KEYTOUCH=m
>> CONFIG_HID_KYE=m
>> CONFIG_HID_UCLOGIC=m
>> CONFIG_HID_WALTOP=m
>> CONFIG_HID_GYRATION=m
>> # CONFIG_HID_ICADE is not set
>> CONFIG_HID_TWINHAN=m
>> CONFIG_HID_KENSINGTON=m
>> CONFIG_HID_LCPOWER=m
>> # CONFIG_HID_LENOVO_TPKBD is not set
>> CONFIG_HID_LOGITECH=m
>> # CONFIG_LOGITECH_FF is not set
>> CONFIG_LOGIRUMBLEPAD2_FF=y
>> # CONFIG_LOGIG940_FF is not set
>> CONFIG_LOGIWHEELS_FF=y
>> CONFIG_HID_MAGICMOUSE=m
>> CONFIG_HID_MICROSOFT=m
>> CONFIG_HID_MONTEREY=m
>> CONFIG_HID_MULTITOUCH=m
>> CONFIG_HID_NTRIG=m
>> # CONFIG_HID_ORTEK is not set
>> CONFIG_HID_PANTHERLORD=m
>> # CONFIG_PANTHERLORD_FF is not set
>> # CONFIG_HID_PETALYNX is not set
>> CONFIG_HID_PICOLCD=m
>> # CONFIG_HID_PICOLCD_FB is not set
>> # CONFIG_HID_PICOLCD_BACKLIGHT is not set
>> CONFIG_HID_PICOLCD_LCD=y
>> CONFIG_HID_PICOLCD_LEDS=y
>> # CONFIG_HID_PICOLCD_CIR is not set
>> CONFIG_HID_PRIMAX=m
>> # CONFIG_HID_ROCCAT is not set
>> CONFIG_HID_SAITEK=m
>> # CONFIG_HID_SAMSUNG is not set
>> # CONFIG_HID_SONY is not set
>> CONFIG_HID_SPEEDLINK=m
>> # CONFIG_HID_STEELSERIES is not set
>> CONFIG_HID_SUNPLUS=m
>> # CONFIG_HID_GREENASIA is not set
>> CONFIG_HID_SMARTJOYPLUS=m
>> CONFIG_SMARTJOYPLUS_FF=y
>> CONFIG_HID_TIVO=m
>> # CONFIG_HID_TOPSEED is not set
>> CONFIG_HID_THINGM=m
>> CONFIG_HID_THRUSTMASTER=m
>> CONFIG_THRUSTMASTER_FF=y
>> CONFIG_HID_WACOM=m
>> # CONFIG_HID_WIIMOTE is not set
>> CONFIG_HID_XINMO=m
>> CONFIG_HID_ZEROPLUS=m
>> CONFIG_ZEROPLUS_FF=y
>> CONFIG_HID_ZYDACRON=m
>> CONFIG_HID_SENSOR_HUB=m
>>
>> #
>> # USB HID support
>> #
>> CONFIG_USB_HID=m
>> # CONFIG_HID_PID is not set
>> # CONFIG_USB_HIDDEV is not set
>>
>> #
>> # USB HID Boot Protocol drivers
>> #
>> CONFIG_USB_KBD=m
>> # CONFIG_USB_MOUSE is not set
>>
>> #
>> # I2C HID support
>> #
>> CONFIG_I2C_HID=m
>> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
>> CONFIG_USB_SUPPORT=y
>> CONFIG_USB_COMMON=y
>> CONFIG_USB_ARCH_HAS_HCD=y
>> CONFIG_USB=m
>> # CONFIG_USB_DEBUG is not set
>> CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
>>
>> #
>> # Miscellaneous USB options
>> #
>> CONFIG_USB_DEFAULT_PERSIST=y
>> # CONFIG_USB_DYNAMIC_MINORS is not set
>> CONFIG_USB_OTG_WHITELIST=y
>> CONFIG_USB_OTG_BLACKLIST_HUB=y
>> CONFIG_USB_MON=m
>> # CONFIG_USB_WUSB_CBAF is not set
>>
>> #
>> # USB Host Controller Drivers
>> #
>> # CONFIG_USB_C67X00_HCD is not set
>> # CONFIG_USB_XHCI_HCD is not set
>> CONFIG_USB_EHCI_HCD=m
>> CONFIG_USB_EHCI_ROOT_HUB_TT=y
>> CONFIG_USB_EHCI_TT_NEWSCHED=y
>> CONFIG_USB_EHCI_PCI=m
>> # CONFIG_USB_EHCI_HCD_PLATFORM is not set
>> # CONFIG_USB_OXU210HP_HCD is not set
>> CONFIG_USB_ISP116X_HCD=m
>> CONFIG_USB_ISP1760_HCD=m
>> CONFIG_USB_ISP1362_HCD=m
>> CONFIG_USB_FUSBH200_HCD=m
>> # CONFIG_USB_FOTG210_HCD is not set
>> CONFIG_USB_OHCI_HCD=m
>> CONFIG_USB_OHCI_HCD_PCI=m
>> # CONFIG_USB_OHCI_HCD_SSB is not set
>> CONFIG_USB_OHCI_HCD_PLATFORM=m
>> # CONFIG_USB_UHCI_HCD is not set
>> # CONFIG_USB_SL811_HCD is not set
>> CONFIG_USB_R8A66597_HCD=m
>> # CONFIG_USB_RENESAS_USBHS_HCD is not set
>> # CONFIG_USB_HCD_SSB is not set
>> CONFIG_USB_HCD_TEST_MODE=y
>> CONFIG_USB_RENESAS_USBHS=m
>>
>> #
>> # USB Device Class drivers
>> #
>> # CONFIG_USB_ACM is not set
>> # CONFIG_USB_PRINTER is not set
>> CONFIG_USB_WDM=m
>> CONFIG_USB_TMC=m
>>
>> #
>> # NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
>> #
>>
>> #
>> # also be needed; see USB_STORAGE Help for more info
>> #
>>
>> #
>> # USB Imaging devices
>> #
>> CONFIG_USB_MDC800=m
>> CONFIG_USB_MUSB_HDRC=m
>> # CONFIG_USB_MUSB_HOST is not set
>> # CONFIG_USB_MUSB_GADGET is not set
>> CONFIG_USB_MUSB_DUAL_ROLE=y
>> # CONFIG_USB_MUSB_TUSB6010 is not set
>> CONFIG_USB_MUSB_UX500=m
>> CONFIG_USB_UX500_DMA=y
>> # CONFIG_MUSB_PIO_ONLY is not set
>> # CONFIG_USB_DWC3 is not set
>> CONFIG_USB_DWC2=m
>> # CONFIG_USB_DWC2_DEBUG is not set
>> # CONFIG_USB_DWC2_TRACK_MISSED_SOFS is not set
>> # CONFIG_USB_CHIPIDEA is not set
>>
>> #
>> # USB port drivers
>> #
>> # CONFIG_USB_SERIAL is not set
>>
>> #
>> # USB Miscellaneous drivers
>> #
>> CONFIG_USB_EMI62=m
>> CONFIG_USB_EMI26=m
>> CONFIG_USB_ADUTUX=m
>> # CONFIG_USB_SEVSEG is not set
>> CONFIG_USB_RIO500=m
>> CONFIG_USB_LEGOTOWER=m
>> # CONFIG_USB_LCD is not set
>> # CONFIG_USB_LED is not set
>> CONFIG_USB_CYPRESS_CY7C63=m
>> # CONFIG_USB_CYTHERM is not set
>> CONFIG_USB_IDMOUSE=m
>> # CONFIG_USB_FTDI_ELAN is not set
>> # CONFIG_USB_APPLEDISPLAY is not set
>> CONFIG_USB_SISUSBVGA=m
>> CONFIG_USB_LD=m
>> CONFIG_USB_TRANCEVIBRATOR=m
>> # CONFIG_USB_IOWARRIOR is not set
>> CONFIG_USB_TEST=m
>> # CONFIG_USB_EHSET_TEST_FIXTURE is not set
>> CONFIG_USB_ISIGHTFW=m
>> # CONFIG_USB_YUREX is not set
>> # CONFIG_USB_EZUSB_FX2 is not set
>> # CONFIG_USB_HSIC_USB3503 is not set
>> # CONFIG_USB_ATM is not set
>>
>> #
>> # USB Physical Layer drivers
>> #
>> CONFIG_USB_PHY=y
>> # CONFIG_USB_OTG_FSM is not set
>> CONFIG_KEYSTONE_USB_PHY=m
>> CONFIG_NOP_USB_XCEIV=y
>> CONFIG_AM335X_CONTROL_USB=y
>> CONFIG_AM335X_PHY_USB=y
>> CONFIG_SAMSUNG_USBPHY=y
>> CONFIG_SAMSUNG_USB2PHY=y
>> CONFIG_SAMSUNG_USB3PHY=m
>> # CONFIG_USB_GPIO_VBUS is not set
>> # CONFIG_USB_ISP1301 is not set
>> CONFIG_USB_RCAR_PHY=y
>> # CONFIG_USB_RCAR_GEN2_PHY is not set
>> CONFIG_USB_GADGET=y
>> # CONFIG_USB_GADGET_DEBUG is not set
>> # CONFIG_USB_GADGET_DEBUG_FS is not set
>> CONFIG_USB_GADGET_VBUS_DRAW=2
>> CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2
>>
>> #
>> # USB Peripheral Controller
>> #
>> CONFIG_USB_FOTG210_UDC=m
>> CONFIG_USB_GR_UDC=y
>> CONFIG_USB_R8A66597=m
>> CONFIG_USB_RENESAS_USBHS_UDC=m
>> CONFIG_USB_PXA27X=m
>> CONFIG_USB_S3C_HSOTG=m
>> CONFIG_USB_MV_UDC=y
>> CONFIG_USB_MV_U3D=m
>> # CONFIG_USB_M66592 is not set
>> # CONFIG_USB_AMD5536UDC is not set
>> CONFIG_USB_NET2272=m
>> # CONFIG_USB_NET2272_DMA is not set
>> # CONFIG_USB_NET2280 is not set
>> # CONFIG_USB_GOKU is not set
>> # CONFIG_USB_EG20T is not set
>> CONFIG_USB_LIBCOMPOSITE=m
>> CONFIG_USB_F_SS_LB=m
>> CONFIG_USB_U_ETHER=m
>> CONFIG_USB_F_ECM=m
>> CONFIG_USB_F_EEM=m
>> CONFIG_USB_F_SUBSET=m
>> CONFIG_USB_F_RNDIS=m
>> CONFIG_USB_F_FS=m
>> CONFIG_USB_CONFIGFS=m
>> # CONFIG_USB_CONFIGFS_SERIAL is not set
>> # CONFIG_USB_CONFIGFS_ACM is not set
>> # CONFIG_USB_CONFIGFS_OBEX is not set
>> # CONFIG_USB_CONFIGFS_NCM is not set
>> # CONFIG_USB_CONFIGFS_ECM is not set
>> CONFIG_USB_CONFIGFS_ECM_SUBSET=y
>> # CONFIG_USB_CONFIGFS_RNDIS is not set
>> # CONFIG_USB_CONFIGFS_EEM is not set
>> # CONFIG_USB_CONFIGFS_PHONET is not set
>> CONFIG_USB_CONFIGFS_F_LB_SS=y
>> CONFIG_USB_CONFIGFS_F_FS=y
>> # CONFIG_USB_ZERO is not set
>> CONFIG_USB_ETH=m
>> # CONFIG_USB_ETH_RNDIS is not set
>> CONFIG_USB_ETH_EEM=y
>> # CONFIG_USB_G_NCM is not set
>> CONFIG_USB_GADGETFS=m
>> CONFIG_USB_FUNCTIONFS=m
>> CONFIG_USB_FUNCTIONFS_ETH=y
>> CONFIG_USB_FUNCTIONFS_RNDIS=y
>> # CONFIG_USB_FUNCTIONFS_GENERIC is not set
>> # CONFIG_USB_G_SERIAL is not set
>> CONFIG_USB_G_PRINTER=m
>> # CONFIG_USB_CDC_COMPOSITE is not set
>> # CONFIG_USB_G_NOKIA is not set
>> CONFIG_USB_G_HID=m
>> # CONFIG_USB_G_DBGP is not set
>> # CONFIG_USB_G_WEBCAM is not set
>> # CONFIG_UWB is not set
>> CONFIG_MMC=y
>> # CONFIG_MMC_DEBUG is not set
>> CONFIG_MMC_CLKGATE=y
>>
>> #
>> # MMC/SD/SDIO Card Drivers
>> #
>> # CONFIG_SDIO_UART is not set
>> # CONFIG_MMC_TEST is not set
>>
>> #
>> # MMC/SD/SDIO Host Controller Drivers
>> #
>> CONFIG_MMC_SDHCI=m
>> # CONFIG_MMC_SDHCI_PCI is not set
>> # CONFIG_MMC_SDHCI_ACPI is not set
>> CONFIG_MMC_SDHCI_PLTFM=m
>> CONFIG_MMC_OMAP_HS=y
>> # CONFIG_MMC_TIFM_SD is not set
>> # CONFIG_MMC_CB710 is not set
>> # CONFIG_MMC_VIA_SDMMC is not set
>> # CONFIG_MMC_VUB300 is not set
>> # CONFIG_MMC_USHC is not set
>> # CONFIG_MEMSTICK is not set
>> CONFIG_NEW_LEDS=y
>> CONFIG_LEDS_CLASS=m
>>
>> #
>> # LED drivers
>> #
>> CONFIG_LEDS_LM3530=m
>> CONFIG_LEDS_LM3642=m
>> # CONFIG_LEDS_PCA9532 is not set
>> CONFIG_LEDS_GPIO=m
>> CONFIG_LEDS_LP3944=m
>> CONFIG_LEDS_LP55XX_COMMON=m
>> CONFIG_LEDS_LP5521=m
>> CONFIG_LEDS_LP5523=m
>> CONFIG_LEDS_LP5562=m
>> CONFIG_LEDS_LP8501=m
>> CONFIG_LEDS_LP8788=m
>> CONFIG_LEDS_CLEVO_MAIL=m
>> # CONFIG_LEDS_PCA955X is not set
>> CONFIG_LEDS_PCA963X=m
>> CONFIG_LEDS_PCA9685=m
>> CONFIG_LEDS_WM8350=m
>> CONFIG_LEDS_DA903X=m
>> # CONFIG_LEDS_PWM is not set
>> CONFIG_LEDS_REGULATOR=m
>> # CONFIG_LEDS_BD2802 is not set
>> # CONFIG_LEDS_INTEL_SS4200 is not set
>> # CONFIG_LEDS_LT3593 is not set
>> # CONFIG_LEDS_ADP5520 is not set
>> CONFIG_LEDS_MC13783=m
>> CONFIG_LEDS_TCA6507=m
>> CONFIG_LEDS_LM355x=m
>> CONFIG_LEDS_OT200=m
>> # CONFIG_LEDS_BLINKM is not set
>>
>> #
>> # LED Triggers
>> #
>> # CONFIG_LEDS_TRIGGERS is not set
>> CONFIG_ACCESSIBILITY=y
>> # CONFIG_INFINIBAND is not set
>> CONFIG_EDAC=y
>> CONFIG_EDAC_LEGACY_SYSFS=y
>> CONFIG_EDAC_DEBUG=y
>> CONFIG_EDAC_MM_EDAC=m
>> # CONFIG_EDAC_E752X is not set
>> # CONFIG_EDAC_I82975X is not set
>> # CONFIG_EDAC_I3000 is not set
>> # CONFIG_EDAC_I3200 is not set
>> # CONFIG_EDAC_X38 is not set
>> # CONFIG_EDAC_I5400 is not set
>> # CONFIG_EDAC_I5000 is not set
>> # CONFIG_EDAC_I5100 is not set
>> # CONFIG_EDAC_I7300 is not set
>> CONFIG_RTC_LIB=y
>> CONFIG_RTC_CLASS=y
>> CONFIG_RTC_HCTOSYS=y
>> CONFIG_RTC_SYSTOHC=y
>> CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
>> CONFIG_RTC_DEBUG=y
>>
>> #
>> # RTC interfaces
>> #
>> # CONFIG_RTC_INTF_SYSFS is not set
>> CONFIG_RTC_INTF_DEV=y
>> CONFIG_RTC_INTF_DEV_UIE_EMUL=y
>> CONFIG_RTC_DRV_TEST=m
>>
>> #
>> # I2C RTC drivers
>> #
>> # CONFIG_RTC_DRV_88PM80X is not set
>> CONFIG_RTC_DRV_DS1307=m
>> CONFIG_RTC_DRV_DS1374=m
>> # CONFIG_RTC_DRV_DS1672 is not set
>> CONFIG_RTC_DRV_DS3232=y
>> # CONFIG_RTC_DRV_LP8788 is not set
>> CONFIG_RTC_DRV_MAX6900=y
>> CONFIG_RTC_DRV_MAX8907=m
>> CONFIG_RTC_DRV_MAX8925=y
>> CONFIG_RTC_DRV_MAX8998=y
>> CONFIG_RTC_DRV_MAX77686=y
>> CONFIG_RTC_DRV_RS5C372=y
>> CONFIG_RTC_DRV_ISL1208=m
>> # CONFIG_RTC_DRV_ISL12022 is not set
>> CONFIG_RTC_DRV_ISL12057=m
>> CONFIG_RTC_DRV_X1205=m
>> CONFIG_RTC_DRV_PCF2127=m
>> CONFIG_RTC_DRV_PCF8523=y
>> CONFIG_RTC_DRV_PCF8563=y
>> CONFIG_RTC_DRV_PCF8583=y
>> CONFIG_RTC_DRV_M41T80=y
>> CONFIG_RTC_DRV_M41T80_WDT=y
>> CONFIG_RTC_DRV_BQ32K=y
>> CONFIG_RTC_DRV_TPS65910=m
>> CONFIG_RTC_DRV_S35390A=y
>> # CONFIG_RTC_DRV_FM3130 is not set
>> CONFIG_RTC_DRV_RX8581=m
>> CONFIG_RTC_DRV_RX8025=y
>> CONFIG_RTC_DRV_EM3027=m
>> CONFIG_RTC_DRV_RV3029C2=m
>>
>> #
>> # SPI RTC drivers
>> #
>>
>> #
>> # Platform RTC drivers
>> #
>> CONFIG_RTC_DRV_CMOS=m
>> CONFIG_RTC_DRV_DS1286=m
>> CONFIG_RTC_DRV_DS1511=m
>> # CONFIG_RTC_DRV_DS1553 is not set
>> CONFIG_RTC_DRV_DS1742=m
>> CONFIG_RTC_DRV_DA9055=y
>> CONFIG_RTC_DRV_STK17TA8=m
>> CONFIG_RTC_DRV_M48T86=m
>> # CONFIG_RTC_DRV_M48T35 is not set
>> # CONFIG_RTC_DRV_M48T59 is not set
>> # CONFIG_RTC_DRV_MSM6242 is not set
>> CONFIG_RTC_DRV_BQ4802=m
>> CONFIG_RTC_DRV_RP5C01=y
>> # CONFIG_RTC_DRV_V3020 is not set
>> # CONFIG_RTC_DRV_DS2404 is not set
>> # CONFIG_RTC_DRV_WM8350 is not set
>> CONFIG_RTC_DRV_PCF50633=m
>>
>> #
>> # on-CPU RTC drivers
>> #
>> CONFIG_RTC_DRV_MC13XXX=m
>> # CONFIG_RTC_DRV_MOXART is not set
>>
>> #
>> # HID Sensor RTC drivers
>> #
>> CONFIG_RTC_DRV_HID_SENSOR_TIME=m
>> # CONFIG_DMADEVICES is not set
>> CONFIG_AUXDISPLAY=y
>> # CONFIG_UIO is not set
>> # CONFIG_VIRT_DRIVERS is not set
>> CONFIG_VIRTIO=y
>>
>> #
>> # Virtio drivers
>> #
>> # CONFIG_VIRTIO_PCI is not set
>> CONFIG_VIRTIO_BALLOON=y
>> CONFIG_VIRTIO_MMIO=y
>> CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y
>>
>> #
>> # Microsoft Hyper-V guest support
>> #
>> # CONFIG_HYPERV is not set
>> # CONFIG_STAGING is not set
>> CONFIG_X86_PLATFORM_DEVICES=y
>> # CONFIG_ACERHDF is not set
>> # CONFIG_ASUS_LAPTOP is not set
>> # CONFIG_FUJITSU_LAPTOP is not set
>> # CONFIG_FUJITSU_TABLET is not set
>> CONFIG_AMILO_RFKILL=m
>> # CONFIG_HP_ACCEL is not set
>> # CONFIG_HP_WIRELESS is not set
>> # CONFIG_MSI_LAPTOP is not set
>> # CONFIG_PANASONIC_LAPTOP is not set
>> # CONFIG_COMPAL_LAPTOP is not set
>> # CONFIG_SONY_LAPTOP is not set
>> # CONFIG_IDEAPAD_LAPTOP is not set
>> # CONFIG_THINKPAD_ACPI is not set
>> CONFIG_SENSORS_HDAPS=m
>> # CONFIG_INTEL_MENLOW is not set
>> # CONFIG_ACPI_WMI is not set
>> # CONFIG_TOPSTAR_LAPTOP is not set
>> # CONFIG_TOSHIBA_BT_RFKILL is not set
>> # CONFIG_ACPI_CMPC is not set
>> # CONFIG_INTEL_IPS is not set
>> # CONFIG_IBM_RTL is not set
>> # CONFIG_XO15_EBOOK is not set
>> # CONFIG_SAMSUNG_LAPTOP is not set
>> # CONFIG_INTEL_OAKTRAIL is not set
>> # CONFIG_SAMSUNG_Q10 is not set
>> # CONFIG_APPLE_GMUX is not set
>> # CONFIG_INTEL_RST is not set
>> # CONFIG_INTEL_SMARTCONNECT is not set
>> # CONFIG_PVPANIC is not set
>> # CONFIG_CHROME_PLATFORMS is not set
>>
>> #
>> # Hardware Spinlock drivers
>> #
>> CONFIG_CLKEVT_I8253=y
>> CONFIG_CLKBLD_I8253=y
>> # CONFIG_SH_TIMER_CMT is not set
>> # CONFIG_SH_TIMER_MTU2 is not set
>> CONFIG_SH_TIMER_TMU=y
>> CONFIG_EM_TIMER_STI=y
>> # CONFIG_MAILBOX is not set
>> CONFIG_IOMMU_SUPPORT=y
>> # CONFIG_AMD_IOMMU is not set
>>
>> #
>> # Remoteproc drivers
>> #
>> # CONFIG_STE_MODEM_RPROC is not set
>>
>> #
>> # Rpmsg drivers
>> #
>> # CONFIG_PM_DEVFREQ is not set
>> # CONFIG_EXTCON is not set
>> CONFIG_MEMORY=y
>> CONFIG_IIO=y
>> CONFIG_IIO_BUFFER=y
>> CONFIG_IIO_BUFFER_CB=y
>> CONFIG_IIO_KFIFO_BUF=y
>> CONFIG_IIO_TRIGGERED_BUFFER=y
>> CONFIG_IIO_TRIGGER=y
>> CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
>>
>> #
>> # Accelerometers
>> #
>> CONFIG_BMA180=y
>> # CONFIG_HID_SENSOR_ACCEL_3D is not set
>> CONFIG_IIO_ST_ACCEL_3AXIS=y
>> CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y
>>
>> #
>> # Analog to digital converters
>> #
>> CONFIG_LP8788_ADC=y
>> CONFIG_MAX1363=y
>> # CONFIG_MCP3422 is not set
>> # CONFIG_MEN_Z188_ADC is not set
>> CONFIG_NAU7802=y
>> # CONFIG_TI_ADC081C is not set
>> CONFIG_TI_AM335X_ADC=y
>> CONFIG_XILINX_XADC=y
>>
>> #
>> # Amplifiers
>> #
>>
>> #
>> # Hid Sensor IIO Common
>> #
>> CONFIG_HID_SENSOR_IIO_COMMON=m
>> CONFIG_HID_SENSOR_IIO_TRIGGER=m
>> CONFIG_IIO_ST_SENSORS_I2C=y
>> CONFIG_IIO_ST_SENSORS_CORE=y
>>
>> #
>> # Digital to analog converters
>> #
>> CONFIG_AD5064=m
>> CONFIG_AD5380=m
>> CONFIG_AD5446=m
>> CONFIG_MAX517=y
>> CONFIG_MCP4725=m
>>
>> #
>> # Frequency Synthesizers DDS/PLL
>> #
>>
>> #
>> # Clock Generator/Distribution
>> #
>>
>> #
>> # Phase-Locked Loop (PLL) frequency synthesizers
>> #
>>
>> #
>> # Digital gyroscope sensors
>> #
>> CONFIG_HID_SENSOR_GYRO_3D=m
>> # CONFIG_IIO_ST_GYRO_3AXIS is not set
>> CONFIG_ITG3200=y
>>
>> #
>> # Humidity sensors
>> #
>> # CONFIG_DHT11 is not set
>> CONFIG_SI7005=y
>>
>> #
>> # Inertial measurement units
>> #
>> CONFIG_INV_MPU6050_IIO=m
>>
>> #
>> # Light sensors
>> #
>> CONFIG_ADJD_S311=y
>> CONFIG_APDS9300=m
>> CONFIG_CM32181=m
>> # CONFIG_CM36651 is not set
>> CONFIG_GP2AP020A00F=m
>> CONFIG_HID_SENSOR_ALS=m
>> CONFIG_HID_SENSOR_PROX=m
>> CONFIG_LTR501=m
>> CONFIG_TCS3472=y
>> CONFIG_SENSORS_TSL2563=m
>> # CONFIG_TSL4531 is not set
>> CONFIG_VCNL4000=y
>>
>> #
>> # Magnetometer sensors
>> #
>> CONFIG_AK8975=y
>> CONFIG_MAG3110=m
>> CONFIG_HID_SENSOR_MAGNETOMETER_3D=m
>> # CONFIG_IIO_ST_MAGN_3AXIS is not set
>>
>> #
>> # Inclinometer sensors
>> #
>> CONFIG_HID_SENSOR_INCLINOMETER_3D=m
>>
>> #
>> # Triggers - standalone
>> #
>> CONFIG_IIO_INTERRUPT_TRIGGER=y
>> CONFIG_IIO_SYSFS_TRIGGER=m
>>
>> #
>> # Pressure sensors
>> #
>> # CONFIG_HID_SENSOR_PRESS is not set
>> CONFIG_MPL3115=m
>> # CONFIG_IIO_ST_PRESS is not set
>>
>> #
>> # Temperature sensors
>> #
>> CONFIG_TMP006=m
>> # CONFIG_NTB is not set
>> # CONFIG_VME_BUS is not set
>> CONFIG_PWM=y
>> CONFIG_PWM_SYSFS=y
>> CONFIG_PWM_CLPS711X=y
>> CONFIG_PWM_LP3943=m
>> # CONFIG_PWM_LPSS is not set
>> CONFIG_PWM_RENESAS_TPU=m
>> CONFIG_IPACK_BUS=m
>> # CONFIG_BOARD_TPCI200 is not set
>> # CONFIG_SERIAL_IPOCTAL is not set
>> # CONFIG_RESET_CONTROLLER is not set
>> # CONFIG_FMC is not set
>>
>> #
>> # PHY Subsystem
>> #
>> CONFIG_GENERIC_PHY=y
>> CONFIG_PHY_EXYNOS_MIPI_VIDEO=m
>> CONFIG_OMAP_CONTROL_PHY=m
>> # CONFIG_BCM_KONA_USB2_PHY is not set
>> CONFIG_PHY_SAMSUNG_USB2=y
>> # CONFIG_POWERCAP is not set
>> CONFIG_MCB=y
>> # CONFIG_MCB_PCI is not set
>>
>> #
>> # Firmware Drivers
>> #
>> CONFIG_EDD=m
>> # CONFIG_EDD_OFF is not set
>> # CONFIG_FIRMWARE_MEMMAP is not set
>> CONFIG_DELL_RBU=m
>> # CONFIG_DCDBAS is not set
>> CONFIG_DMIID=y
>> CONFIG_DMI_SYSFS=m
>> CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
>> # CONFIG_ISCSI_IBFT_FIND is not set
>> # CONFIG_GOOGLE_FIRMWARE is not set
>>
>> #
>> # File systems
>> #
>> CONFIG_DCACHE_WORD_ACCESS=y
>> # CONFIG_FS_POSIX_ACL is not set
>> CONFIG_EXPORTFS=y
>> # CONFIG_FILE_LOCKING is not set
>> CONFIG_FSNOTIFY=y
>> CONFIG_DNOTIFY=y
>> # CONFIG_INOTIFY_USER is not set
>> CONFIG_FANOTIFY=y
>> CONFIG_QUOTA=y
>> CONFIG_QUOTA_NETLINK_INTERFACE=y
>> CONFIG_PRINT_QUOTA_WARNING=y
>> CONFIG_QUOTA_DEBUG=y
>> CONFIG_QUOTA_TREE=m
>> CONFIG_QFMT_V1=m
>> CONFIG_QFMT_V2=m
>> CONFIG_QUOTACTL=y
>> # CONFIG_AUTOFS4_FS is not set
>> CONFIG_FUSE_FS=m
>> CONFIG_CUSE=m
>>
>> #
>> # Caches
>> #
>> CONFIG_FSCACHE=y
>> # CONFIG_FSCACHE_DEBUG is not set
>>
>> #
>> # Pseudo filesystems
>> #
>> # CONFIG_PROC_FS is not set
>> CONFIG_KERNFS=y
>> CONFIG_SYSFS=y
>> CONFIG_HUGETLBFS=y
>> CONFIG_HUGETLB_PAGE=y
>> CONFIG_CONFIGFS_FS=m
>> # CONFIG_MISC_FILESYSTEMS is not set
>> # CONFIG_NETWORK_FILESYSTEMS is not set
>> CONFIG_NLS=y
>> CONFIG_NLS_DEFAULT="iso8859-1"
>> CONFIG_NLS_CODEPAGE_437=y
>> # CONFIG_NLS_CODEPAGE_737 is not set
>> CONFIG_NLS_CODEPAGE_775=y
>> CONFIG_NLS_CODEPAGE_850=m
>> # CONFIG_NLS_CODEPAGE_852 is not set
>> # CONFIG_NLS_CODEPAGE_855 is not set
>> # CONFIG_NLS_CODEPAGE_857 is not set
>> CONFIG_NLS_CODEPAGE_860=y
>> CONFIG_NLS_CODEPAGE_861=y
>> # CONFIG_NLS_CODEPAGE_862 is not set
>> CONFIG_NLS_CODEPAGE_863=y
>> CONFIG_NLS_CODEPAGE_864=y
>> CONFIG_NLS_CODEPAGE_865=y
>> CONFIG_NLS_CODEPAGE_866=m
>> CONFIG_NLS_CODEPAGE_869=m
>> CONFIG_NLS_CODEPAGE_936=m
>> CONFIG_NLS_CODEPAGE_950=y
>> CONFIG_NLS_CODEPAGE_932=y
>> CONFIG_NLS_CODEPAGE_949=m
>> CONFIG_NLS_CODEPAGE_874=y
>> CONFIG_NLS_ISO8859_8=m
>> # CONFIG_NLS_CODEPAGE_1250 is not set
>> # CONFIG_NLS_CODEPAGE_1251 is not set
>> CONFIG_NLS_ASCII=y
>> # CONFIG_NLS_ISO8859_1 is not set
>> CONFIG_NLS_ISO8859_2=y
>> CONFIG_NLS_ISO8859_3=y
>> # CONFIG_NLS_ISO8859_4 is not set
>> CONFIG_NLS_ISO8859_5=y
>> CONFIG_NLS_ISO8859_6=m
>> # CONFIG_NLS_ISO8859_7 is not set
>> # CONFIG_NLS_ISO8859_9 is not set
>> CONFIG_NLS_ISO8859_13=m
>> CONFIG_NLS_ISO8859_14=m
>> # CONFIG_NLS_ISO8859_15 is not set
>> # CONFIG_NLS_KOI8_R is not set
>> CONFIG_NLS_KOI8_U=y
>> CONFIG_NLS_MAC_ROMAN=y
>> CONFIG_NLS_MAC_CELTIC=m
>> CONFIG_NLS_MAC_CENTEURO=m
>> # CONFIG_NLS_MAC_CROATIAN is not set
>> CONFIG_NLS_MAC_CYRILLIC=m
>> CONFIG_NLS_MAC_GAELIC=y
>> # CONFIG_NLS_MAC_GREEK is not set
>> CONFIG_NLS_MAC_ICELAND=m
>> CONFIG_NLS_MAC_INUIT=y
>> CONFIG_NLS_MAC_ROMANIAN=y
>> # CONFIG_NLS_MAC_TURKISH is not set
>> CONFIG_NLS_UTF8=y
>> CONFIG_DLM=m
>> # CONFIG_DLM_DEBUG is not set
>>
>> #
>> # Kernel hacking
>> #
>> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
>>
>> #
>> # printk and dmesg options
>> #
>> CONFIG_PRINTK_TIME=y
>> CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
>> # CONFIG_BOOT_PRINTK_DELAY is not set
>> # CONFIG_DYNAMIC_DEBUG is not set
>>
>> #
>> # Compile-time checks and compiler options
>> #
>> CONFIG_ENABLE_WARN_DEPRECATED=y
>> CONFIG_ENABLE_MUST_CHECK=y
>> CONFIG_FRAME_WARN=2048
>> CONFIG_STRIP_ASM_SYMS=y
>> CONFIG_READABLE_ASM=y
>> # CONFIG_UNUSED_SYMBOLS is not set
>> CONFIG_DEBUG_FS=y
>> # CONFIG_HEADERS_CHECK is not set
>> CONFIG_DEBUG_SECTION_MISMATCH=y
>> CONFIG_ARCH_WANT_FRAME_POINTERS=y
>> CONFIG_FRAME_POINTER=y
>> # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
>> # CONFIG_MAGIC_SYSRQ is not set
>> CONFIG_DEBUG_KERNEL=y
>>
>> #
>> # Memory Debugging
>> #
>> # CONFIG_DEBUG_PAGEALLOC is not set
>> CONFIG_DEBUG_OBJECTS=y
>> CONFIG_DEBUG_OBJECTS_SELFTEST=y
>> CONFIG_DEBUG_OBJECTS_FREE=y
>> CONFIG_DEBUG_OBJECTS_TIMERS=y
>> # CONFIG_DEBUG_OBJECTS_WORK is not set
>> # CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
>> # CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
>> CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
>> # CONFIG_DEBUG_SLAB is not set
>> CONFIG_HAVE_DEBUG_KMEMLEAK=y
>> # CONFIG_DEBUG_KMEMLEAK is not set
>> CONFIG_DEBUG_STACK_USAGE=y
>> CONFIG_DEBUG_VM=y
>> CONFIG_DEBUG_VM_RB=y
>> CONFIG_DEBUG_VIRTUAL=y
>> # CONFIG_DEBUG_MEMORY_INIT is not set
>> CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
>> CONFIG_DEBUG_STACKOVERFLOW=y
>> CONFIG_HAVE_ARCH_KMEMCHECK=y
>> # CONFIG_DEBUG_SHIRQ is not set
>>
>> #
>> # Debug Lockups and Hangs
>> #
>> # CONFIG_LOCKUP_DETECTOR is not set
>> # CONFIG_DETECT_HUNG_TASK is not set
>> CONFIG_PANIC_ON_OOPS=y
>> CONFIG_PANIC_ON_OOPS_VALUE=1
>> CONFIG_PANIC_TIMEOUT=0
>>
>> #
>> # Lock Debugging (spinlocks, mutexes, etc...)
>> #
>> CONFIG_DEBUG_RT_MUTEXES=y
>> CONFIG_DEBUG_PI_LIST=y
>> CONFIG_RT_MUTEX_TESTER=y
>> CONFIG_DEBUG_SPINLOCK=y
>> CONFIG_DEBUG_MUTEXES=y
>> CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
>> CONFIG_DEBUG_LOCK_ALLOC=y
>> CONFIG_PROVE_LOCKING=y
>> CONFIG_LOCKDEP=y
>> CONFIG_LOCK_STAT=y
>> CONFIG_DEBUG_LOCKDEP=y
>> CONFIG_DEBUG_ATOMIC_SLEEP=y
>> CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
>> # CONFIG_LOCK_TORTURE_TEST is not set
>> CONFIG_TRACE_IRQFLAGS=y
>> CONFIG_STACKTRACE=y
>> # CONFIG_DEBUG_KOBJECT is not set
>> # CONFIG_DEBUG_KOBJECT_RELEASE is not set
>> CONFIG_DEBUG_BUGVERBOSE=y
>> CONFIG_DEBUG_LIST=y
>> CONFIG_DEBUG_SG=y
>> # CONFIG_DEBUG_NOTIFIERS is not set
>> # CONFIG_DEBUG_CREDENTIALS is not set
>>
>> #
>> # RCU Debugging
>> #
>> # CONFIG_PROVE_RCU is not set
>> # CONFIG_SPARSE_RCU_POINTER is not set
>> # CONFIG_TORTURE_TEST is not set
>> # CONFIG_RCU_TORTURE_TEST is not set
>> # CONFIG_RCU_TRACE is not set
>> CONFIG_NOTIFIER_ERROR_INJECTION=m
>> CONFIG_FAULT_INJECTION=y
>> # CONFIG_FAILSLAB is not set
>> CONFIG_FAIL_PAGE_ALLOC=y
>> CONFIG_FAIL_MMC_REQUEST=y
>> CONFIG_FAULT_INJECTION_DEBUG_FS=y
>> CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
>> CONFIG_USER_STACKTRACE_SUPPORT=y
>> CONFIG_NOP_TRACER=y
>> CONFIG_HAVE_FUNCTION_TRACER=y
>> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
>> CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
>> CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
>> CONFIG_HAVE_DYNAMIC_FTRACE=y
>> CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
>> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
>> CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
>> CONFIG_HAVE_FENTRY=y
>> CONFIG_HAVE_C_RECORDMCOUNT=y
>> CONFIG_TRACER_MAX_TRACE=y
>> CONFIG_TRACE_CLOCK=y
>> CONFIG_RING_BUFFER=y
>> CONFIG_EVENT_TRACING=y
>> CONFIG_CONTEXT_SWITCH_TRACER=y
>> CONFIG_RING_BUFFER_ALLOW_SWAP=y
>> CONFIG_TRACING=y
>> CONFIG_GENERIC_TRACER=y
>> CONFIG_TRACING_SUPPORT=y
>> CONFIG_FTRACE=y
>> # CONFIG_FUNCTION_TRACER is not set
>> CONFIG_IRQSOFF_TRACER=y
>> # CONFIG_SCHED_TRACER is not set
>> CONFIG_FTRACE_SYSCALLS=y
>> CONFIG_TRACER_SNAPSHOT=y
>> CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
>> CONFIG_TRACE_BRANCH_PROFILING=y
>> # CONFIG_BRANCH_PROFILE_NONE is not set
>> CONFIG_PROFILE_ANNOTATED_BRANCHES=y
>> # CONFIG_PROFILE_ALL_BRANCHES is not set
>> # CONFIG_BRANCH_TRACER is not set
>> # CONFIG_STACK_TRACER is not set
>> CONFIG_KPROBE_EVENT=y
>> CONFIG_UPROBE_EVENT=y
>> CONFIG_PROBE_EVENTS=y
>> # CONFIG_FTRACE_STARTUP_TEST is not set
>> # CONFIG_MMIOTRACE is not set
>> CONFIG_RING_BUFFER_BENCHMARK=m
>> # CONFIG_RING_BUFFER_STARTUP_TEST is not set
>>
>> #
>> # Runtime Testing
>> #
>> # CONFIG_TEST_LIST_SORT is not set
>> # CONFIG_KPROBES_SANITY_TEST is not set
>> # CONFIG_BACKTRACE_SELF_TEST is not set
>> CONFIG_RBTREE_TEST=m
>> CONFIG_INTERVAL_TREE_TEST=m
>> CONFIG_PERCPU_TEST=m
>> CONFIG_ATOMIC64_SELFTEST=y
>> CONFIG_TEST_STRING_HELPERS=m
>> CONFIG_TEST_KSTRTOX=y
>> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
>> # CONFIG_DMA_API_DEBUG is not set
>> # CONFIG_TEST_MODULE is not set
>> CONFIG_TEST_USER_COPY=m
>> # CONFIG_SAMPLES is not set
>> CONFIG_HAVE_ARCH_KGDB=y
>> # CONFIG_KGDB is not set
>> # CONFIG_STRICT_DEVMEM is not set
>> CONFIG_X86_VERBOSE_BOOTUP=y
>> # CONFIG_EARLY_PRINTK is not set
>> CONFIG_X86_PTDUMP=y
>> # CONFIG_DEBUG_RODATA is not set
>> CONFIG_DEBUG_SET_MODULE_RONX=y
>> CONFIG_DEBUG_NX_TEST=m
>> # CONFIG_DOUBLEFAULT is not set
>> CONFIG_DEBUG_TLBFLUSH=y
>> CONFIG_IOMMU_STRESS=y
>> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
>> CONFIG_IO_DELAY_TYPE_0X80=0
>> CONFIG_IO_DELAY_TYPE_0XED=1
>> CONFIG_IO_DELAY_TYPE_UDELAY=2
>> CONFIG_IO_DELAY_TYPE_NONE=3
>> CONFIG_IO_DELAY_0X80=y
>> # CONFIG_IO_DELAY_0XED is not set
>> # CONFIG_IO_DELAY_UDELAY is not set
>> # CONFIG_IO_DELAY_NONE is not set
>> CONFIG_DEFAULT_IO_DELAY_TYPE=0
>> # CONFIG_DEBUG_BOOT_PARAMS is not set
>> # CONFIG_CPA_DEBUG is not set
>> CONFIG_OPTIMIZE_INLINING=y
>> CONFIG_DEBUG_NMI_SELFTEST=y
>> CONFIG_X86_DEBUG_STATIC_CPU_HAS=y
>>
>> #
>> # Security options
>> #
>> CONFIG_KEYS=y
>> # CONFIG_PERSISTENT_KEYRINGS is not set
>> # CONFIG_ENCRYPTED_KEYS is not set
>> CONFIG_KEYS_DEBUG_PROC_KEYS=y
>> CONFIG_SECURITY_DMESG_RESTRICT=y
>> # CONFIG_SECURITY is not set
>> CONFIG_SECURITYFS=y
>> CONFIG_DEFAULT_SECURITY_DAC=y
>> CONFIG_DEFAULT_SECURITY=""
>> CONFIG_CRYPTO=y
>>
>> #
>> # Crypto core or helper
>> #
>> CONFIG_CRYPTO_FIPS=y
>> CONFIG_CRYPTO_ALGAPI=y
>> CONFIG_CRYPTO_ALGAPI2=y
>> CONFIG_CRYPTO_AEAD=y
>> CONFIG_CRYPTO_AEAD2=y
>> CONFIG_CRYPTO_BLKCIPHER=y
>> CONFIG_CRYPTO_BLKCIPHER2=y
>> CONFIG_CRYPTO_HASH=y
>> CONFIG_CRYPTO_HASH2=y
>> CONFIG_CRYPTO_RNG=y
>> CONFIG_CRYPTO_RNG2=y
>> CONFIG_CRYPTO_PCOMP2=y
>> CONFIG_CRYPTO_MANAGER=y
>> CONFIG_CRYPTO_MANAGER2=y
>> # CONFIG_CRYPTO_USER is not set
>> # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
>> CONFIG_CRYPTO_GF128MUL=y
>> CONFIG_CRYPTO_NULL=y
>> CONFIG_CRYPTO_WORKQUEUE=y
>> CONFIG_CRYPTO_CRYPTD=y
>> CONFIG_CRYPTO_AUTHENC=y
>> # CONFIG_CRYPTO_TEST is not set
>> CONFIG_CRYPTO_ABLK_HELPER=y
>> CONFIG_CRYPTO_GLUE_HELPER_X86=y
>>
>> #
>> # Authenticated Encryption with Associated Data
>> #
>> CONFIG_CRYPTO_CCM=m
>> CONFIG_CRYPTO_GCM=m
>> CONFIG_CRYPTO_SEQIV=y
>>
>> #
>> # Block modes
>> #
>> CONFIG_CRYPTO_CBC=y
>> CONFIG_CRYPTO_CTR=m
>> CONFIG_CRYPTO_CTS=y
>> CONFIG_CRYPTO_ECB=y
>> CONFIG_CRYPTO_LRW=y
>> CONFIG_CRYPTO_PCBC=m
>> CONFIG_CRYPTO_XTS=y
>>
>> #
>> # Hash modes
>> #
>> CONFIG_CRYPTO_CMAC=y
>> CONFIG_CRYPTO_HMAC=y
>> CONFIG_CRYPTO_XCBC=m
>> CONFIG_CRYPTO_VMAC=y
>>
>> #
>> # Digest
>> #
>> CONFIG_CRYPTO_CRC32C=y
>> CONFIG_CRYPTO_CRC32C_INTEL=m
>> CONFIG_CRYPTO_CRC32=y
>> CONFIG_CRYPTO_CRC32_PCLMUL=y
>> CONFIG_CRYPTO_CRCT10DIF=y
>> CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
>> CONFIG_CRYPTO_GHASH=y
>> CONFIG_CRYPTO_MD4=m
>> CONFIG_CRYPTO_MD5=y
>> # CONFIG_CRYPTO_MICHAEL_MIC is not set
>> CONFIG_CRYPTO_RMD128=y
>> CONFIG_CRYPTO_RMD160=y
>> # CONFIG_CRYPTO_RMD256 is not set
>> CONFIG_CRYPTO_RMD320=m
>> CONFIG_CRYPTO_SHA1=y
>> CONFIG_CRYPTO_SHA1_SSSE3=y
>> CONFIG_CRYPTO_SHA256_SSSE3=m
>> CONFIG_CRYPTO_SHA512_SSSE3=m
>> CONFIG_CRYPTO_SHA256=y
>> CONFIG_CRYPTO_SHA512=m
>> # CONFIG_CRYPTO_TGR192 is not set
>> CONFIG_CRYPTO_WP512=y
>> CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y
>>
>> #
>> # Ciphers
>> #
>> CONFIG_CRYPTO_AES=y
>> CONFIG_CRYPTO_AES_X86_64=y
>> CONFIG_CRYPTO_AES_NI_INTEL=y
>> CONFIG_CRYPTO_ANUBIS=m
>> # CONFIG_CRYPTO_ARC4 is not set
>> # CONFIG_CRYPTO_BLOWFISH is not set
>> CONFIG_CRYPTO_BLOWFISH_COMMON=y
>> CONFIG_CRYPTO_BLOWFISH_X86_64=y
>> CONFIG_CRYPTO_CAMELLIA=m
>> CONFIG_CRYPTO_CAMELLIA_X86_64=m
>> CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
>> CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
>> CONFIG_CRYPTO_CAST_COMMON=y
>> CONFIG_CRYPTO_CAST5=y
>> # CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
>> # CONFIG_CRYPTO_CAST6 is not set
>> # CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
>> CONFIG_CRYPTO_DES=y
>> # CONFIG_CRYPTO_FCRYPT is not set
>> CONFIG_CRYPTO_KHAZAD=y
>> CONFIG_CRYPTO_SALSA20=y
>> # CONFIG_CRYPTO_SALSA20_X86_64 is not set
>> CONFIG_CRYPTO_SEED=y
>> CONFIG_CRYPTO_SERPENT=y
>> CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
>> CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
>> # CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
>> CONFIG_CRYPTO_TEA=m
>> # CONFIG_CRYPTO_TWOFISH is not set
>> CONFIG_CRYPTO_TWOFISH_COMMON=y
>> CONFIG_CRYPTO_TWOFISH_X86_64=y
>> CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
>> # CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set
>>
>> #
>> # Compression
>> #
>> CONFIG_CRYPTO_DEFLATE=y
>> # CONFIG_CRYPTO_ZLIB is not set
>> CONFIG_CRYPTO_LZO=m
>> CONFIG_CRYPTO_LZ4=m
>> CONFIG_CRYPTO_LZ4HC=y
>>
>> #
>> # Random Number Generation
>> #
>> CONFIG_CRYPTO_ANSI_CPRNG=y
>> CONFIG_CRYPTO_USER_API=m
>> # CONFIG_CRYPTO_USER_API_HASH is not set
>> CONFIG_CRYPTO_USER_API_SKCIPHER=m
>> CONFIG_CRYPTO_HASH_INFO=y
>> CONFIG_CRYPTO_HW=y
>> # CONFIG_CRYPTO_DEV_PADLOCK is not set
>> # CONFIG_CRYPTO_DEV_CCP is not set
>> CONFIG_ASYMMETRIC_KEY_TYPE=y
>> CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
>> CONFIG_PUBLIC_KEY_ALGO_RSA=y
>> CONFIG_X509_CERTIFICATE_PARSER=y
>> CONFIG_HAVE_KVM=y
>> # CONFIG_VIRTUALIZATION is not set
>> CONFIG_BINARY_PRINTF=y
>>
>> #
>> # Library routines
>> #
>> CONFIG_BITREVERSE=y
>> CONFIG_GENERIC_STRNCPY_FROM_USER=y
>> CONFIG_GENERIC_STRNLEN_USER=y
>> CONFIG_GENERIC_NET_UTILS=y
>> CONFIG_GENERIC_FIND_FIRST_BIT=y
>> CONFIG_GENERIC_PCI_IOMAP=y
>> CONFIG_GENERIC_IOMAP=y
>> CONFIG_GENERIC_IO=y
>> CONFIG_PERCPU_RWSEM=y
>> CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
>> CONFIG_CRC_CCITT=y
>> CONFIG_CRC16=y
>> CONFIG_CRC_T10DIF=y
>> CONFIG_CRC_ITU_T=y
>> CONFIG_CRC32=y
>> CONFIG_CRC32_SELFTEST=y
>> CONFIG_CRC32_SLICEBY8=y
>> # CONFIG_CRC32_SLICEBY4 is not set
>> # CONFIG_CRC32_SARWATE is not set
>> # CONFIG_CRC32_BIT is not set
>> CONFIG_CRC7=m
>> CONFIG_LIBCRC32C=y
>> CONFIG_CRC8=y
>> # CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
>> # CONFIG_RANDOM32_SELFTEST is not set
>> CONFIG_ZLIB_INFLATE=y
>> CONFIG_ZLIB_DEFLATE=y
>> CONFIG_LZO_COMPRESS=y
>> CONFIG_LZO_DECOMPRESS=y
>> CONFIG_LZ4_COMPRESS=m
>> CONFIG_LZ4HC_COMPRESS=y
>> CONFIG_LZ4_DECOMPRESS=y
>> CONFIG_XZ_DEC=y
>> # CONFIG_XZ_DEC_X86 is not set
>> # CONFIG_XZ_DEC_POWERPC is not set
>> CONFIG_XZ_DEC_IA64=y
>> # CONFIG_XZ_DEC_ARM is not set
>> # CONFIG_XZ_DEC_ARMTHUMB is not set
>> CONFIG_XZ_DEC_SPARC=y
>> CONFIG_XZ_DEC_BCJ=y
>> CONFIG_XZ_DEC_TEST=m
>> CONFIG_DECOMPRESS_GZIP=y
>> CONFIG_GENERIC_ALLOCATOR=y
>> CONFIG_BCH=m
>> CONFIG_BCH_CONST_PARAMS=y
>> CONFIG_ASSOCIATIVE_ARRAY=y
>> CONFIG_HAS_IOMEM=y
>> CONFIG_HAS_IOPORT_MAP=y
>> CONFIG_HAS_DMA=y
>> CONFIG_DQL=y
>> CONFIG_NLATTR=y
>> CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
>> CONFIG_AVERAGE=y
>> CONFIG_CLZ_TAB=y
>> # CONFIG_CORDIC is not set
>> CONFIG_DDR=y
>> CONFIG_MPILIB=y
>> CONFIG_OID_REGISTRY=y
>> CONFIG_FONT_SUPPORT=m
>> CONFIG_FONT_8x16=y
>> CONFIG_FONT_AUTOSELECT=y
>>
>>
> 
>> _______________________________________________
>> LKP mailing list
>> LKP@linux.intel.com
>>
>>
> 
> 
