Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbaGNQG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:06:27 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38499 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132AbaGNQGS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:06:18 -0400
Date: Mon, 14 Jul 2014 17:06:11 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Jet Chen <jet.chen@intel.com>
Cc: Su Tao <tao.su@intel.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [pci] BUG: unable to handle kernel NULL pointer dereference at
 00000064
Message-ID: <20140714160611.GC825@e106497-lin.cambridge.arm.com>
References: <53C14170.70106@intel.com>
MIME-Version: 1.0
In-Reply-To: <53C14170.70106@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 14 Jul 2014 16:06:12.0165 (UTC) FILETIME=[88309F50:01CF9F7D]
X-MC-Unique: 114071417061425301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 03:08:48PM +0100, Jet Chen wrote:
> Hi Liviu,
> 
> 0day kernel testing robot got the below dmesg and the first bad commit is
> 
> git://git.linaro.org/people/cdall/linux-kvm-arm apm_linux_v3.16-rc1
> commit 6f99bc949b1c90ff342a7d44ac4122322a7ccb78
> Author:     Liviu Dudau <Liviu.Dudau@arm.com>
> AuthorDate: Thu Jun 5 15:20:38 2014 +0530
> Commit:     Christoffer Dall <christoffer.dall@linaro.org>
> CommitDate: Fri Jul 11 06:34:50 2014 -0700
> 
>     pci: Create pci_host_bridge before its associated bus in pci_create_root_bus.
>         Before commit 7b5436635800 the pci_host_bridge was created before the root bus.
>     As that commit has added a needless dependency on the bus for pci_alloc_host_bridge()
>     the creation order has been changed for no good reason. Revert the order of
>     creation as we are going to depend on the pci_host_bridge structure to retrieve the
>     domain number of the root bus.
>         Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
>     Acked-by: Grant Likely <grant.likely@linaro.org>
>     Tested-by: Tanmay Inamdar <tinamdar@apm.com>

Jet,

This is the third time the patch I have provided you got lost and the bot sent this
email. Is it not possible to roll that patch into the stack that you have?

Best regards,
Liviu


> 
> +------------------------------------------------------------+------------+------------+
> |                                                            | 175e014331 | 6f99bc949b |
> +------------------------------------------------------------+------------+------------+
> | boot_successes                                             | 60         | 0          |
> | boot_failures                                              | 0          | 20         |
> | BUG:unable_to_handle_kernel_NULL_pointer_dereference       | 0          | 20         |
> | Oops                                                       | 0          | 20         |
> | EIP_is_at_pcibios_root_bridge_prepare                      | 0          | 20         |
> | WARNING:CPU:PID:at_kernel/smp.c:smp_call_function_single() | 0          | 20         |
> | Kernel_panic-not_syncing:Attempted_to_kill_init_exitcode=  | 0          | 20         |
> | backtrace:acpi_bus_scan                                    | 0          | 20         |
> | backtrace:acpi_scan_init                                   | 0          | 20         |
> | backtrace:acpi_init                                        | 0          | 20         |
> | backtrace:kernel_init_freeable                             | 0          | 20         |
> +------------------------------------------------------------+------------+------------+
> 
> [    0.351550] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    0.352949] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments]
> [    0.353402] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
> [    0.355122] BUG: unable to handle kernel NULL pointer dereference at 00000064
> [    0.356666] IP: [<c17b762e>] pcibios_root_bridge_prepare+0xe/0x20
> [    0.356666] *pde = 00000000 [    0.356666] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [    0.356666] Modules linked in:
> [    0.356666] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.16.0-rc1-00005-g6f99bc9 #2
> [    0.356666] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> [    0.356666] task: cfc7e010 ti: cfcc0000 task.ti: cfcc0000
> [    0.356666] EIP: 0060:[<c17b762e>] EFLAGS: 00010286 CPU: 0
> [    0.356666] EIP is at pcibios_root_bridge_prepare+0xe/0x20
> [    0.356666] EAX: cfe0a000 EBX: c1d83d20 ECX: 00000000 EDX: 00000000
> [    0.356666] ESI: 00000000 EDI: cfe0a000 EBP: cfcc1d20 ESP: cfcc1d20
> [    0.356666]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [    0.356666] CR0: 8005003b CR2: 00000064 CR3: 01e77000 CR4: 000006d0
> [    0.356666] Stack:
> [    0.356666]  cfcc1da4 c13d7a8b cfcc1dd4 cfe56e00 cfcc1dd4 cfe56d40 cfcc1dd4 cfc00180
> [    0.356666]  cfcc1d88 c11a77d2 cfe0a184 00000001 00000000 00000000 c1093cf9 00000246
> [    0.356666]  000080d0 00000282 00000010 000080d0 00000020 00000246 c13d5a48 cfcc1dd4
> [    0.356666] Call Trace:
> [    0.356666]  [<c13d7a8b>] pci_create_root_bus+0x5b/0x340
> [    0.356666]  [<c11a77d2>] ? kmem_cache_alloc_trace+0x3a2/0x4b0
> [    0.356666]  [<c1093cf9>] ? insert_resource_conflict+0x19/0x40
> [    0.356666]  [<c13d5a48>] ? pci_add_resource_offset+0x28/0x60
> [    0.356666]  [<c13d5a48>] ? pci_add_resource_offset+0x28/0x60
> [    0.356666]  [<c17b750b>] pci_acpi_scan_root+0x25b/0x370
> [    0.356666]  [<c1401686>] acpi_pci_root_add+0x223/0x2c9
> [    0.356666]  [<c13fc8ed>] ? acpi_bus_get_status_handle+0x18/0x3a
> [    0.356666]  [<c13fedb3>] acpi_bus_attach+0xb5/0x160
> [    0.356666]  [<c195d60d>] ? mutex_unlock+0xd/0x10
> [    0.356666]  [<c1474b9c>] ? device_attach+0x8c/0xa0
> [    0.356666]  [<c13fee1c>] acpi_bus_attach+0x11e/0x160
> [    0.356666]  [<c195d60d>] ? mutex_unlock+0xd/0x10
> [    0.356666]  [<c1474b9c>] ? device_attach+0x8c/0xa0
> [    0.356666]  [<c13fee1c>] acpi_bus_attach+0x11e/0x160
> [    0.356666]  [<c13feea7>] acpi_bus_scan+0x49/0x59
> [    0.356666]  [<c1ddfa74>] acpi_scan_init+0x5b/0x16b
> [    0.356666]  [<c1ddf8cc>] acpi_init+0x205/0x220
> [    0.356666]  [<c1ddf6c7>] ? acpi_sleep_proc_init+0x23/0x23
> [    0.356666]  [<c100044e>] do_one_initcall+0x7e/0x1b0
> [    0.356666]  [<c1ddf6c7>] ? acpi_sleep_proc_init+0x23/0x23
> [    0.356666]  [<c1da7500>] ? initcall_blacklist+0x23/0x81
> [    0.356666]  [<c10ae039>] ? parse_args+0x1d9/0x360
> [    0.356666]  [<c10a5361>] ? __usermodehelper_set_disable_depth+0x41/0x50
> [    0.356666]  [<c1da7d9c>] kernel_init_freeable+0x1b2/0x249
> [    0.356666]  [<c1da755e>] ? initcall_blacklist+0x81/0x81
> [    0.356666]  [<c194b840>] kernel_init+0x10/0xe0
> [    0.356666]  [<c195f681>] ret_from_kernel_thread+0x21/0x30
> [    0.356666]  [<c194b830>] ? rest_init+0x130/0x130
> [    0.356666] Code: 8b 45 e0 89 44 24 04 e8 26 ab 19 00 31 c0 e9 8f fd ff ff 8d 76 00 8d bc 27 00 00 00 00 55 89 e5 3e 8d 74 26 00 8b 90 80 01 00 00 <8b> 52 64 8b 52 08 89 90 28 01 00 00 31 c0 5d c3 66 90 55 89 e5
> [    0.356666] EIP: [<c17b762e>] pcibios_root_bridge_prepare+0xe/0x20 SS:ESP 0068:cfcc1d20
> [    0.356666] CR2: 0000000000000064
> [    0.356666] ---[ end trace 849b10f6fad5eb6f ]---
> [    0.356666] ------------[ cut here ]------------
> 
> git bisect start 263df82c9fb5fc5b3504d294f7ab813c274bf1d1 7171511eaec5bf23fb06078f59784a3a0626b38f --
> git bisect  bad 56485a95d9ffdb6b431ea00171e320112a992b40  # 01:09      0-      9  rtc: Fix suspend/resume for APM X-Gene SoC RTC driver
> git bisect  bad 2a146bde9a2b55d8d9e98a1f4b72ca694aa67879  # 01:22      0-     19  dt-bindings: pci: xgene pcie device tree bindings
> git bisect  bad 6f99bc949b1c90ff342a7d44ac4122322a7ccb78  # 02:11      0-      1  pci: Create pci_host_bridge before its associated bus in pci_create_root_bus.
> git bisect good d1eee6a841dd73ecd3cce0e70686152cc5789c91  # 02:14     20+      0  arm64: Add architecture support for PCI
> git bisect good ab84a1c5bef2092f87cf22239df5592c68a83978  # 02:17     20+      0  pci: Introduce pci_register_io_range() helper function.
> git bisect good 175e0143313927c52fd7b6b5b66c202e3d6ab31c  # 02:39     20+      0  pci: OF: Fix the conversion of IO ranges into IO resources.
> # first bad commit: [6f99bc949b1c90ff342a7d44ac4122322a7ccb78] pci: Create pci_host_bridge before its associated bus in pci_create_root_bus.
> git bisect good 175e0143313927c52fd7b6b5b66c202e3d6ab31c  # 02:40     60+      0  pci: OF: Fix the conversion of IO ranges into IO resources.
> git bisect  bad 263df82c9fb5fc5b3504d294f7ab813c274bf1d1  # 02:40      0-     11  arm64: Add defconfig and dts for Xen on APM X-Gene Mustang board
> git bisect good 67b9d76f9e2f9f87f94a11521cc996dc2e43ce14  # 02:45     60+      0  Merge tag 'dm-3.16-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm
> git bisect good b7079aa6ab3e23d080fa9b79d7f414d8287c32b4  # 02:48     60+      0  Add linux-next specific files for 20140711
> 
> 
> This script may reproduce the error.
> 
> ----------------------------------------------------------------------------
> #!/bin/bash
> 
> kernel=$1
> 
> kvm=(
> 	qemu-system-x86_64
> 	-cpu kvm64
> 	-enable-kvm
> 	-kernel $kernel
> 	-m 320
> 	-smp 2
> 	-net nic,vlan=1,model=e1000
> 	-net user,vlan=1
> 	-boot order=nc
> 	-no-reboot
> 	-watchdog i6300esb
> 	-rtc base=localtime
> 	-serial stdio
> 	-display none
> 	-monitor null )
> 
> append=(
> 	hung_task_panic=1
> 	earlyprintk=ttyS0,115200
> 	debug
> 	apic=debug
> 	sysrq_always_enabled
> 	rcupdate.rcu_cpu_stall_timeout=100
> 	panic=10
> 	softlockup_panic=1
> 	nmi_watchdog=panic
> 	prompt_ramdisk=0
> 	console=ttyS0,115200
> 	console=tty0
> 	vga=normal
> 	root=/dev/ram0
> 	rw
> 	drbd.minor_count=8
> )
> 
> "${kvm[@]}" --append "${append[*]}"
> ----------------------------------------------------------------------------
> 
> Thanks,
> Jet

> early console in setup code
> early console in decompress_kernel
> 
> Decompressing Linux... Parsing ELF... No relocation needed... done.
> Booting the kernel.
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.16.0-rc1-00005-g6f99bc9 (kbuild@lkp-hsx01) (gcc version 4.8.2 (Debian 4.8.2-18) ) #2 SMP PREEMPT Sat Jul 12 09:26:37 CST 2014
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] bootconsole [earlyser0] enabled
> [    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
> [    0.000000] SMBIOS 2.4 present.
> [    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> [    0.000000] Hypervisor detected: KVM
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x13ffe max_arch_pfn = 0x100000
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
> [    0.000000]   8 disabled
> [    0.000000]   9 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
> [    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
> [    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
> [    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at [c00f0eb0]
> [    0.000000]   mpc: f0ec0-f0fa4
> [    0.000000] initial memory mapped: [mem 0x00000000-0x02bfffff]
> [    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x12000000-0x123fffff]
> [    0.000000]  [mem 0x12000000-0x123fffff] page 4k
> [    0.000000] BRK [0x026fd000, 0x026fdfff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x10000000-0x11ffffff]
> [    0.000000]  [mem 0x10000000-0x11ffffff] page 4k
> [    0.000000] BRK [0x026fe000, 0x026fefff] PGTABLE
> [    0.000000] BRK [0x026ff000, 0x026fffff] PGTABLE
> [    0.000000] BRK [0x02700000, 0x02700fff] PGTABLE
> [    0.000000] BRK [0x02701000, 0x02701fff] PGTABLE
> [    0.000000] BRK [0x02702000, 0x02702fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
> [    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x12400000-0x13ffdfff]
> [    0.000000]  [mem 0x12400000-0x13ffdfff] page 4k
> [    0.000000] cma: dma_contiguous_reserve(limit 13ffe000)
> [    0.000000] cma: dma_contiguous_reserve: reserving 31 MiB for global area
> [    0.000000] cma: dma_contiguous_reserve_area(size 1ff6000, base 00000000, limit 13ffe000)
> [    0.000000] cma: CMA: reserved 32 MiB at 10000000
> [    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
> [    0.000000] ACPI: Early table checksum verification disabled
> [    0.000000] ACPI: RSDP 0x000F0D00 000014 (v00 BOCHS )
> [    0.000000] ACPI: RSDT 0x13FFFC2A 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACP 0x13FFF1C0 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> [    0.000000] ACPI: DSDT 0x13FFE040 001180 (v01 BOCHS  BXPCDSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACS 0x13FFE000 000040
> [    0.000000] ACPI: SSDT 0x13FFF234 00093E (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: APIC 0x13FFFB72 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> [    0.000000] ACPI: HPET 0x13FFFBF2 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to         ffffc000 (        fee00000)
> [    0.000000] 0MB HIGHMEM available.
> [    0.000000] 319MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 13ffe000
> [    0.000000]   low ram: 0 - 13ffe000
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
> [    0.000000]   HighMem  empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
> [    0.000000] On node 0 totalpages: 81820
> [    0.000000]   DMA zone: 36 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 3998 pages, LIFO batch:0
> [    0.000000]   Normal zone: 684 pages used for memmap
> [    0.000000]   Normal zone: 77822 pages, LIFO batch:15
> [    0.000000] Using APIC driver default
> [    0.000000] ACPI: PM-Timer IO Port: 0x608
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to         ffffc000 (        fee00000)
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
> [    0.000000] mapped IOAPIC to ffffb000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on KVM
> [    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 14 pages/cpu @d246f000 s32928 r0 d24416 u57344
> [    0.000000] pcpu-alloc: s32928 r0 d24416 u57344 alloc=14*4096
> [    0.000000] pcpu-alloc: [0] 0 [0] 1 
> [    0.000000] KVM setup async PF for cpu 0
> [    0.000000] kvm-stealtime: cpu 0, msr 12471840
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 81100
> [    0.000000] Kernel command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/i386-randconfig-r1-0711/cdall-kvm-arm:apm_linux_v3.16-rc1:6f99bc949b1c90ff342a7d44ac4122322a7ccb78:bisect-linux-1/.vmlinuz-6f99bc949b1c90ff342a7d44ac4122322a7ccb78-20140712092656-2-ivb41 branch=cdall-kvm-arm/apm_linux_v3.16-rc1 BOOT_IMAGE=/kernel/i386-randconfig-r1-0711/6f99bc949b1c90ff342a7d44ac4122322a7ccb78/vmlinuz-3.16.0-rc1-00005-g6f99bc9 drbd.minor_count=8
> [    0.000000] sysrq: sysrq always enabled.
> [    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
> [    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.000000] Initializing CPU#0
> [    0.000000] Initializing HighMem for node 0 (00000000:00000000)
> [    0.000000] Memory: 242052K/327280K available (9609K kernel code, 727K rwdata, 3632K rodata, 788K init, 8692K bss, 85228K reserved, 0K highmem)
> [    0.000000] virtual kernel memory layout:
> [    0.000000]     fixmap  : 0xffe6f000 - 0xfffff000   (1600 kB)
> [    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
> [    0.000000]     vmalloc : 0xd47fe000 - 0xff7fe000   ( 688 MB)
> [    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
> [    0.000000]       .init : 0xc1da7000 - 0xc1e6c000   ( 788 kB)
> [    0.000000]       .data : 0xc1962957 - 0xc1da5c00   (4364 kB)
> [    0.000000]       .text : 0xc1000000 - 0xc1962957   (9610 kB)
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
> [    0.000000] NR_IRQS:2304 nr_irqs:512 16
> [    0.000000] CPU 0 irqstacks, hard=cfc0a000 soft=cfc0c000
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] bootconsole [earlyser0] disabled
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.16.0-rc1-00005-g6f99bc9 (kbuild@lkp-hsx01) (gcc version 4.8.2 (Debian 4.8.2-18) ) #2 SMP PREEMPT Sat Jul 12 09:26:37 CST 2014
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] bootconsole [earlyser0] enabled
> [    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
> [    0.000000] SMBIOS 2.4 present.
> [    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> [    0.000000] Hypervisor detected: KVM
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x13ffe max_arch_pfn = 0x100000
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
> [    0.000000]   8 disabled
> [    0.000000]   9 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
> [    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
> [    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
> [    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at [c00f0eb0]
> [    0.000000]   mpc: f0ec0-f0fa4
> [    0.000000] initial memory mapped: [mem 0x00000000-0x02bfffff]
> [    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x12000000-0x123fffff]
> [    0.000000]  [mem 0x12000000-0x123fffff] page 4k
> [    0.000000] BRK [0x026fd000, 0x026fdfff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x10000000-0x11ffffff]
> [    0.000000]  [mem 0x10000000-0x11ffffff] page 4k
> [    0.000000] BRK [0x026fe000, 0x026fefff] PGTABLE
> [    0.000000] BRK [0x026ff000, 0x026fffff] PGTABLE
> [    0.000000] BRK [0x02700000, 0x02700fff] PGTABLE
> [    0.000000] BRK [0x02701000, 0x02701fff] PGTABLE
> [    0.000000] BRK [0x02702000, 0x02702fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
> [    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x12400000-0x13ffdfff]
> [    0.000000]  [mem 0x12400000-0x13ffdfff] page 4k
> [    0.000000] cma: dma_contiguous_reserve(limit 13ffe000)
> [    0.000000] cma: dma_contiguous_reserve: reserving 31 MiB for global area
> [    0.000000] cma: dma_contiguous_reserve_area(size 1ff6000, base 00000000, limit 13ffe000)
> [    0.000000] cma: CMA: reserved 32 MiB at 10000000
> [    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
> [    0.000000] ACPI: Early table checksum verification disabled
> [    0.000000] ACPI: RSDP 0x000F0D00 000014 (v00 BOCHS )
> [    0.000000] ACPI: RSDT 0x13FFFC2A 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACP 0x13FFF1C0 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> [    0.000000] ACPI: DSDT 0x13FFE040 001180 (v01 BOCHS  BXPCDSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACS 0x13FFE000 000040
> [    0.000000] ACPI: SSDT 0x13FFF234 00093E (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: APIC 0x13FFFB72 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> [    0.000000] ACPI: HPET 0x13FFFBF2 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to         ffffc000 (        fee00000)
> [    0.000000] 0MB HIGHMEM available.
> [    0.000000] 319MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 13ffe000
> [    0.000000]   low ram: 0 - 13ffe000
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
> [    0.000000]   HighMem  empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
> [    0.000000] On node 0 totalpages: 81820
> [    0.000000]   DMA zone: 36 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 3998 pages, LIFO batch:0
> [    0.000000]   Normal zone: 684 pages used for memmap
> [    0.000000]   Normal zone: 77822 pages, LIFO batch:15
> [    0.000000] Using APIC driver default
> [    0.000000] ACPI: PM-Timer IO Port: 0x608
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to         ffffc000 (        fee00000)
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
> [    0.000000] mapped IOAPIC to ffffb000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on KVM
> [    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 14 pages/cpu @d246f000 s32928 r0 d24416 u57344
> [    0.000000] pcpu-alloc: s32928 r0 d24416 u57344 alloc=14*4096
> [    0.000000] pcpu-alloc: [0] 0 [0] 1 
> [    0.000000] KVM setup async PF for cpu 0
> [    0.000000] kvm-stealtime: cpu 0, msr 12471840
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 81100
> [    0.000000] Kernel command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/i386-randconfig-r1-0711/cdall-kvm-arm:apm_linux_v3.16-rc1:6f99bc949b1c90ff342a7d44ac4122322a7ccb78:bisect-linux-1/.vmlinuz-6f99bc949b1c90ff342a7d44ac4122322a7ccb78-20140712092656-2-ivb41 branch=cdall-kvm-arm/apm_linux_v3.16-rc1 BOOT_IMAGE=/kernel/i386-randconfig-r1-0711/6f99bc949b1c90ff342a7d44ac4122322a7ccb78/vmlinuz-3.16.0-rc1-00005-g6f99bc9 drbd.minor_count=8
> [    0.000000] sysrq: sysrq always enabled.
> [    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
> [    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.000000] Initializing CPU#0
> [    0.000000] Initializing HighMem for node 0 (00000000:00000000)
> [    0.000000] Memory: 242052K/327280K available (9609K kernel code, 727K rwdata, 3632K rodata, 788K init, 8692K bss, 85228K reserved, 0K highmem)
> [    0.000000] virtual kernel memory layout:
> [    0.000000]     fixmap  : 0xffe6f000 - 0xfffff000   (1600 kB)
> [    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
> [    0.000000]     vmalloc : 0xd47fe000 - 0xff7fe000   ( 688 MB)
> [    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
> [    0.000000]       .init : 0xc1da7000 - 0xc1e6c000   ( 788 kB)
> [    0.000000]       .data : 0xc1962957 - 0xc1da5c00   (4364 kB)
> [    0.000000]       .text : 0xc1000000 - 0xc1962957   (9610 kB)
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
> [    0.000000] NR_IRQS:2304 nr_irqs:512 16
> [    0.000000] CPU 0 irqstacks, hard=cfc0a000 soft=cfc0c000
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] bootconsole [earlyser0] disabled
> [    0.000000] console [ttyS0] enabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
> [    0.000000] ... CHAINHASH_SIZE:          32768
> [    0.000000]  memory used by lock dependency info: 4911 kB
> [    0.000000]  per task-struct memory footprint: 1152 bytes
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Detected 2693.508 MHz processor
> [    0.006666] Calibrating delay loop (skipped) preset value.. 5389.47 BogoMIPS (lpj=8978360)
> [    0.006678] pid_max: default: 32768 minimum: 301
> [    0.007825] ACPI: Core revision 20140424
> [    0.014195] ACPI: All ACPI Tables successfully acquired
> [    0.015744] Security Framework initialized
> [    0.016679] SELinux:  Initializing.
> [    0.017847] SELinux:  Starting in enforcing mode
> [    0.019055] AppArmor: AppArmor disabled by boot time parameter
> [    0.020011] Yama: becoming mindful.
> [    0.021253] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
> [    0.023349] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
> [    0.027014] Initializing cgroup subsys devices
> [    0.028398] Initializing cgroup subsys freezer
> [    0.029557] Initializing cgroup subsys perf_event
> [    0.030112] mce: CPU supports 10 MCE banks
> [    0.031198] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.031198] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
> [    0.031198] tlb_flushall_shift: 6
> [    0.034225] debug: unmapping init [mem 0xc1e6c000-0xc1e73fff]
> [    0.042587] ftrace: allocating 32816 entries in 65 pages
> [    0.053751] Getting VERSION: 1050014
> [    0.054729] Getting VERSION: 1050014
> [    0.056676] Getting ID: 0
> [    0.057474] Getting ID: f000000
> [    0.058360] Getting LVT0: 8700
> [    0.059226] Getting LVT1: 8400
> [    0.060011] Enabling APIC mode:  Flat.  Using 1 I/O APICs
> [    0.061283] enabled ExtINT on CPU#0
> [    0.063447] ENABLING IO-APIC IRQs
> [    0.064398] init IO_APIC IRQs
> [    0.065309]  apic 0 pin 0 not connected
> [    0.066365] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
> [    0.066705] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
> [    0.070036] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
> [    0.072048] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
> [    0.073368] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
> [    0.076701] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
> [    0.078887] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
> [    0.080040] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
> [    0.083366] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
> [    0.086697] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
> [    0.088699] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
> [    0.090033] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
> [    0.093372] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
> [    0.096710] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
> [    0.100028] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
> [    0.101870]  apic 0 pin 16 not connected
> [    0.103339]  apic 0 pin 17 not connected
> [    0.104274]  apic 0 pin 18 not connected
> [    0.105212]  apic 0 pin 19 not connected
> [    0.106674]  apic 0 pin 20 not connected
> [    0.107685]  apic 0 pin 21 not connected
> [    0.108681]  apic 0 pin 22 not connected
> [    0.110006]  apic 0 pin 23 not connected
> [    0.111195] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.113338] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
> [    0.116674] Using local APIC timer interrupts.
> [    0.116674] calibrating APIC timer ...
> [    0.123333] ... lapic delta = 7487116
> [    0.123333] ... PM-Timer delta = 428799
> [    0.123333] APIC calibration not consistent with PM-Timer: 119ms instead of 100ms
> [    0.123333] APIC delta adjusted to PM-Timer: 6250115 (7487116)
> [    0.123333] TSC delta adjusted to PM-Timer: 269346507 (322654623)
> [    0.123333] ..... delta 6250115
> [    0.123333] ..... mult: 268440422
> [    0.123333] ..... calibration result: 3333394
> [    0.123333] ..... CPU clock speed is 2693.2447 MHz.
> [    0.123333] ..... host bus clock speed is 1000.0394 MHz.
> [    0.123426] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
> [    0.143512] NMI watchdog: disabled (cpu0): hardware events not enabled
> [    0.150705] CPU 1 irqstacks, hard=cfd90000 soft=cfd92000
> [    0.153349] x86: Booting SMP configuration:
> [    0.154411] .... node  #0, CPUs:      #1
> [    0.006666] Initializing CPU#1
> [    0.006666] kvm-clock: cpu 1, msr 0:13ffd021, secondary cpu clock
> [    0.006666] masked ExtINT on CPU#1
> [    0.176816] x86: Booted up 1 node, 2 CPUs
> [    0.178159] smpboot: Total of 2 processors activated (10778.95 BogoMIPS)
> [    0.176678] KVM setup async PF for cpu 1
> [    0.176678] kvm-stealtime: cpu 1, msr 1247f840
> [    0.197498] devtmpfs: initialized
> [    0.201230] evm: security.selinux
> [    0.202202] evm: security.SMACK64
> [    0.203186] evm: security.SMACK64EXEC
> [    0.204389] evm: security.SMACK64TRANSMUTE
> [    0.205490] evm: security.SMACK64MMAP
> [    0.206518] evm: security.ima
> [    0.206673] evm: security.capability
> [    0.213547] prandom: seed boundary self test passed
> [    0.215534] prandom: 100 self tests passed
> [    0.216679] atomic64_test: passed for i386+ platform with CX8 and with SSE
> [    0.218941] regulator-dummy: no parameters
> [    0.223210] RTC time:  2:11:48, date: 07/12/14
> [    0.223724] NET: Registered protocol family 16
> [    0.226729] cpuidle: using governor ladder
> [    0.227863] cpuidle: using governor menu
> [    0.229391] ACPI: bus type PCI registered
> [    0.230257] PCI: Using configuration type 1 for base access
> [    0.232081] mtrr: your CPUs had inconsistent variable MTRR settings
> [    0.233346] mtrr: your CPUs had inconsistent MTRRdefType settings
> [    0.234811] mtrr: probably your BIOS does not setup all CPUs.
> [    0.236672] mtrr: corrected configuration.
> [    0.320070] ACPI: Added _OSI(Module Device)
> [    0.321186] ACPI: Added _OSI(Processor Device)
> [    0.322362] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.323340] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.332583] ACPI: Interpreter enabled
> [    0.333346] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140424/hwxface-580)
> [    0.335632] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140424/hwxface-580)
> [    0.337450] ACPI: (supports S0 S3 S5)
> [    0.338417] ACPI: Using IOAPIC for interrupt routing
> [    0.340054] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    0.351550] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    0.352949] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments]
> [    0.353402] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
> [    0.355122] BUG: unable to handle kernel NULL pointer dereference at 00000064
> [    0.356666] IP: [<c17b762e>] pcibios_root_bridge_prepare+0xe/0x20
> [    0.356666] *pde = 00000000 
> [    0.356666] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [    0.356666] Modules linked in:
> [    0.356666] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.16.0-rc1-00005-g6f99bc9 #2
> [    0.356666] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> [    0.356666] task: cfc7e010 ti: cfcc0000 task.ti: cfcc0000
> [    0.356666] EIP: 0060:[<c17b762e>] EFLAGS: 00010286 CPU: 0
> [    0.356666] EIP is at pcibios_root_bridge_prepare+0xe/0x20
> [    0.356666] EAX: cfe0a000 EBX: c1d83d20 ECX: 00000000 EDX: 00000000
> [    0.356666] ESI: 00000000 EDI: cfe0a000 EBP: cfcc1d20 ESP: cfcc1d20
> [    0.356666]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [    0.356666] CR0: 8005003b CR2: 00000064 CR3: 01e77000 CR4: 000006d0
> [    0.356666] Stack:
> [    0.356666]  cfcc1da4 c13d7a8b cfcc1dd4 cfe56e00 cfcc1dd4 cfe56d40 cfcc1dd4 cfc00180
> [    0.356666]  cfcc1d88 c11a77d2 cfe0a184 00000001 00000000 00000000 c1093cf9 00000246
> [    0.356666]  000080d0 00000282 00000010 000080d0 00000020 00000246 c13d5a48 cfcc1dd4
> [    0.356666] Call Trace:
> [    0.356666]  [<c13d7a8b>] pci_create_root_bus+0x5b/0x340
> [    0.356666]  [<c11a77d2>] ? kmem_cache_alloc_trace+0x3a2/0x4b0
> [    0.356666]  [<c1093cf9>] ? insert_resource_conflict+0x19/0x40
> [    0.356666]  [<c13d5a48>] ? pci_add_resource_offset+0x28/0x60
> [    0.356666]  [<c13d5a48>] ? pci_add_resource_offset+0x28/0x60
> [    0.356666]  [<c17b750b>] pci_acpi_scan_root+0x25b/0x370
> [    0.356666]  [<c1401686>] acpi_pci_root_add+0x223/0x2c9
> [    0.356666]  [<c13fc8ed>] ? acpi_bus_get_status_handle+0x18/0x3a
> [    0.356666]  [<c13fedb3>] acpi_bus_attach+0xb5/0x160
> [    0.356666]  [<c195d60d>] ? mutex_unlock+0xd/0x10
> [    0.356666]  [<c1474b9c>] ? device_attach+0x8c/0xa0
> [    0.356666]  [<c13fee1c>] acpi_bus_attach+0x11e/0x160
> [    0.356666]  [<c195d60d>] ? mutex_unlock+0xd/0x10
> [    0.356666]  [<c1474b9c>] ? device_attach+0x8c/0xa0
> [    0.356666]  [<c13fee1c>] acpi_bus_attach+0x11e/0x160
> [    0.356666]  [<c13feea7>] acpi_bus_scan+0x49/0x59
> [    0.356666]  [<c1ddfa74>] acpi_scan_init+0x5b/0x16b
> [    0.356666]  [<c1ddf8cc>] acpi_init+0x205/0x220
> [    0.356666]  [<c1ddf6c7>] ? acpi_sleep_proc_init+0x23/0x23
> [    0.356666]  [<c100044e>] do_one_initcall+0x7e/0x1b0
> [    0.356666]  [<c1ddf6c7>] ? acpi_sleep_proc_init+0x23/0x23
> [    0.356666]  [<c1da7500>] ? initcall_blacklist+0x23/0x81
> [    0.356666]  [<c10ae039>] ? parse_args+0x1d9/0x360
> [    0.356666]  [<c10a5361>] ? __usermodehelper_set_disable_depth+0x41/0x50
> [    0.356666]  [<c1da7d9c>] kernel_init_freeable+0x1b2/0x249
> [    0.356666]  [<c1da755e>] ? initcall_blacklist+0x81/0x81
> [    0.356666]  [<c194b840>] kernel_init+0x10/0xe0
> [    0.356666]  [<c195f681>] ret_from_kernel_thread+0x21/0x30
> [    0.356666]  [<c194b830>] ? rest_init+0x130/0x130
> [    0.356666] Code: 8b 45 e0 89 44 24 04 e8 26 ab 19 00 31 c0 e9 8f fd ff ff 8d 76 00 8d bc 27 00 00 00 00 55 89 e5 3e 8d 74 26 00 8b 90 80 01 00 00 <8b> 52 64 8b 52 08 89 90 28 01 00 00 31 c0 5d c3 66 90 55 89 e5
> [    0.356666] EIP: [<c17b762e>] pcibios_root_bridge_prepare+0xe/0x20 SS:ESP 0068:cfcc1d20
> [    0.356666] CR2: 0000000000000064
> [    0.356666] ---[ end trace 849b10f6fad5eb6f ]---
> [    0.356666] ------------[ cut here ]------------
> [    0.356666] WARNING: CPU: 0 PID: 1 at kernel/smp.c:242 smp_call_function_single+0x9c/0xc0()
> [    0.356666] Modules linked in:
> [    0.356666] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G      D       3.16.0-rc1-00005-g6f99bc9 #2
> [    0.356666] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> [    0.356666]  00000000 00000000 cfcc1aa0 c1955423 00000000 cfcc1ad0 c108c29e c1bc72f8
> [    0.356666]  00000000 00000001 c1bccf80 000000f2 c110fb2c c110fb2c ffffffff 00000000
> [    0.356666]  c1159340 cfcc1ae0 c108c362 00000009 00000000 cfcc1b00 c110fb2c cfcc1af0
> [    0.356666] Call Trace:
> [    0.356666]  [<c1955423>] dump_stack+0x48/0x69
> [    0.356666]  [<c108c29e>] warn_slowpath_common+0x7e/0xa0
> [    0.356666]  [<c110fb2c>] ? smp_call_function_single+0x9c/0xc0
> [    0.356666]  [<c110fb2c>] ? smp_call_function_single+0x9c/0xc0
> [    0.356666]  [<c1159340>] ? rcu_read_lock_held+0x40/0x40
> [    0.356666]  [<c108c362>] warn_slowpath_null+0x22/0x30
> [    0.356666]  [<c110fb2c>] smp_call_function_single+0x9c/0xc0
> [    0.356666]  [<c10de04b>] ? trace_hardirqs_off+0xb/0x10
> [    0.356666]  [<c11587bc>] task_function_call+0x3c/0x50
> [    0.356666]  [<c115fb50>] ? perf_cgroup_switch+0x380/0x380
> [    0.356666]  [<c115942d>] perf_cgroup_exit+0x1d/0x20
> [    0.356666]  [<c111e65f>] cgroup_exit+0xcf/0x220
> [    0.356666]  [<c108dca6>] do_exit+0x276/0xaf0
> [    0.356666]  [<c10ed2c0>] ? kmsg_dump+0x190/0x200
> [    0.356666]  [<c10ed151>] ? kmsg_dump+0x21/0x200
> [    0.356666]  [<c1049027>] oops_end+0x77/0xa0
> [    0.356666]  [<c1950975>] no_context+0x1a9/0x1b1
> [    0.356666]  [<c1950af6>] __bad_area_nosemaphore+0x179/0x181
> [    0.356666]  [<c10ddd43>] ? __bfs+0x13/0x1e0
> [    0.356666]  [<c10dd990>] ? noop_count+0x10/0x10
> [    0.356666]  [<c1950b15>] bad_area_nosemaphore+0x17/0x19
> [    0.356666]  [<c107f975>] __do_page_fault+0x85/0x4b0
> [    0.356666]  [<c1115904>] ? is_module_text_address+0x14/0x30
> [    0.356666]  [<c10ad21f>] ? __kernel_text_address+0x4f/0x70
> [    0.356666]  [<c1048deb>] ? print_context_stack+0x5b/0xa0
> [    0.356666]  [<c1047ead>] ? dump_trace+0xbd/0x1d0
> [    0.356666]  [<c10dff5e>] ? mark_held_locks+0x5e/0x80
> [    0.356666]  [<c107ff6a>] trace_do_page_fault+0x3a/0x200
> [    0.356666]  [<c107d350>] ? kvm_read_and_reset_pf_reason+0x40/0x40
> [    0.356666]  [<c107d373>] do_async_page_fault+0x23/0x80
> [    0.356666]  [<c196066f>] error_code+0x5f/0x70
> [    0.356666]  [<c107d350>] ? kvm_read_and_reset_pf_reason+0x40/0x40
> [    0.356666]  [<c17b762e>] ? pcibios_root_bridge_prepare+0xe/0x20
> [    0.356666]  [<c13d7a8b>] pci_create_root_bus+0x5b/0x340
> [    0.356666]  [<c11a77d2>] ? kmem_cache_alloc_trace+0x3a2/0x4b0
> [    0.356666]  [<c1093cf9>] ? insert_resource_conflict+0x19/0x40
> [    0.356666]  [<c13d5a48>] ? pci_add_resource_offset+0x28/0x60
> [    0.356666]  [<c13d5a48>] ? pci_add_resource_offset+0x28/0x60
> [    0.356666]  [<c17b750b>] pci_acpi_scan_root+0x25b/0x370
> [    0.356666]  [<c1401686>] acpi_pci_root_add+0x223/0x2c9
> [    0.356666]  [<c13fc8ed>] ? acpi_bus_get_status_handle+0x18/0x3a
> [    0.356666]  [<c13fedb3>] acpi_bus_attach+0xb5/0x160
> [    0.356666]  [<c195d60d>] ? mutex_unlock+0xd/0x10
> [    0.356666]  [<c1474b9c>] ? device_attach+0x8c/0xa0
> [    0.356666]  [<c13fee1c>] acpi_bus_attach+0x11e/0x160
> [    0.356666]  [<c195d60d>] ? mutex_unlock+0xd/0x10
> [    0.356666]  [<c1474b9c>] ? device_attach+0x8c/0xa0
> [    0.356666]  [<c13fee1c>] acpi_bus_attach+0x11e/0x160
> [    0.356666]  [<c13feea7>] acpi_bus_scan+0x49/0x59
> [    0.356666]  [<c1ddfa74>] acpi_scan_init+0x5b/0x16b
> [    0.356666]  [<c1ddf8cc>] acpi_init+0x205/0x220
> [    0.356666]  [<c1ddf6c7>] ? acpi_sleep_proc_init+0x23/0x23
> [    0.356666]  [<c100044e>] do_one_initcall+0x7e/0x1b0
> [    0.356666]  [<c1ddf6c7>] ? acpi_sleep_proc_init+0x23/0x23
> [    0.356666]  [<c1da7500>] ? initcall_blacklist+0x23/0x81
> [    0.356666]  [<c10ae039>] ? parse_args+0x1d9/0x360
> [    0.356666]  [<c10a5361>] ? __usermodehelper_set_disable_depth+0x41/0x50
> [    0.356666]  [<c1da7d9c>] kernel_init_freeable+0x1b2/0x249
> [    0.356666]  [<c1da755e>] ? initcall_blacklist+0x81/0x81
> [    0.356666]  [<c194b840>] kernel_init+0x10/0xe0
> [    0.356666]  [<c195f681>] ret_from_kernel_thread+0x21/0x30
> [    0.356666]  [<c194b830>] ? rest_init+0x130/0x130
> [    0.356666] ---[ end trace 849b10f6fad5eb70 ]---
> [    0.356673] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
> [    0.356673] 
> [    0.359999] Rebooting in 10 seconds..
> Elapsed time: 10
> qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-r1-0711/6f99bc949b1c90ff342a7d44ac4122322a7ccb78/vmlinuz-3.16.0-rc1-00005-g6f99bc9 -append 'hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/i386-randconfig-r1-0711/cdall-kvm-arm:apm_linux_v3.16-rc1:6f99bc949b1c90ff342a7d44ac4122322a7ccb78:bisect-linux-1/.vmlinuz-6f99bc949b1c90ff342a7d44ac4122322a7ccb78-20140712092656-2-ivb41 branch=cdall-kvm-arm/apm_linux_v3.16-rc1 BOOT_IMAGE=/kernel/i386-randconfig-r1-0711/6f99bc949b1c90ff342a7d44ac4122322a7ccb78/vmlinuz-3.16.0-rc1-00005-g6f99bc9 drbd.minor_count=8'  -initrd /kernel-tests/initrd/quantal-core-i386.cgz -m 320 -smp 2 -net nic,vlan=1,model=e1000 -net user,vlan=1 -boot order=nc -no-reboot -watchdog i6300esb -rtc base=localtime -pidfile /dev/shm/kboot/pid-quantal-ivb41-111 -serial file:/dev/shm/kboot/serial-quantal-ivb41-111 -daemonize -display none -monitor null 


> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/i386 3.16.0-rc1 Kernel Configuration
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
> CONFIG_NEED_SG_DMA_LENGTH=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_ARCH_HAS_CPU_RELAX=y
> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
> CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
> CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
> # CONFIG_ZONE_DMA32 is not set
> # CONFIG_AUDIT_ARCH is not set
> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> CONFIG_X86_32_SMP=y
> CONFIG_X86_HT=y
> CONFIG_X86_32_LAZY_GS=y
> CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
> CONFIG_ARCH_SUPPORTS_UPROBES=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_IRQ_WORK=y
> CONFIG_BUILDTIME_EXTABLE_SORT=y
> 
> #
> # General setup
> #
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_CROSS_COMPILE=""
> # CONFIG_COMPILE_TEST is not set
> CONFIG_LOCALVERSION=""
> CONFIG_LOCALVERSION_AUTO=y
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_HAVE_KERNEL_BZIP2=y
> CONFIG_HAVE_KERNEL_LZMA=y
> CONFIG_HAVE_KERNEL_XZ=y
> CONFIG_HAVE_KERNEL_LZO=y
> CONFIG_HAVE_KERNEL_LZ4=y
> # CONFIG_KERNEL_GZIP is not set
> CONFIG_KERNEL_BZIP2=y
> # CONFIG_KERNEL_LZMA is not set
> # CONFIG_KERNEL_XZ is not set
> # CONFIG_KERNEL_LZO is not set
> # CONFIG_KERNEL_LZ4 is not set
> CONFIG_DEFAULT_HOSTNAME="(none)"
> # CONFIG_SWAP is not set
> # CONFIG_SYSVIPC is not set
> CONFIG_POSIX_MQUEUE=y
> CONFIG_POSIX_MQUEUE_SYSCTL=y
> CONFIG_CROSS_MEMORY_ATTACH=y
> CONFIG_FHANDLE=y
> # CONFIG_USELIB is not set
> CONFIG_AUDIT=y
> CONFIG_HAVE_ARCH_AUDITSYSCALL=y
> CONFIG_AUDITSYSCALL=y
> CONFIG_AUDIT_WATCH=y
> CONFIG_AUDIT_TREE=y
> 
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_IRQ_SHOW=y
> CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
> CONFIG_GENERIC_PENDING_IRQ=y
> CONFIG_GENERIC_IRQ_CHIP=y
> CONFIG_IRQ_DOMAIN=y
> # CONFIG_IRQ_DOMAIN_DEBUG is not set
> CONFIG_IRQ_FORCED_THREADING=y
> CONFIG_SPARSE_IRQ=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_ARCH_CLOCKSOURCE_DATA=y
> CONFIG_GENERIC_TIME_VSYSCALL=y
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
> CONFIG_TICK_ONESHOT=y
> CONFIG_HZ_PERIODIC=y
> # CONFIG_NO_HZ_IDLE is not set
> CONFIG_NO_HZ=y
> CONFIG_HIGH_RES_TIMERS=y
> 
> #
> # CPU/Task time and stats accounting
> #
> CONFIG_TICK_CPU_ACCOUNTING=y
> # CONFIG_IRQ_TIME_ACCOUNTING is not set
> # CONFIG_BSD_PROCESS_ACCT is not set
> CONFIG_TASKSTATS=y
> CONFIG_TASK_DELAY_ACCT=y
> CONFIG_TASK_XACCT=y
> CONFIG_TASK_IO_ACCOUNTING=y
> 
> #
> # RCU Subsystem
> #
> CONFIG_TREE_PREEMPT_RCU=y
> CONFIG_PREEMPT_RCU=y
> CONFIG_RCU_STALL_COMMON=y
> CONFIG_RCU_FANOUT=32
> CONFIG_RCU_FANOUT_LEAF=16
> # CONFIG_RCU_FANOUT_EXACT is not set
> CONFIG_TREE_RCU_TRACE=y
> # CONFIG_RCU_BOOST is not set
> CONFIG_RCU_NOCB_CPU=y
> # CONFIG_RCU_NOCB_CPU_NONE is not set
> CONFIG_RCU_NOCB_CPU_ZERO=y
> # CONFIG_RCU_NOCB_CPU_ALL is not set
> CONFIG_IKCONFIG=y
> # CONFIG_IKCONFIG_PROC is not set
> CONFIG_LOG_BUF_SHIFT=17
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
> CONFIG_CGROUPS=y
> # CONFIG_CGROUP_DEBUG is not set
> CONFIG_CGROUP_FREEZER=y
> CONFIG_CGROUP_DEVICE=y
> CONFIG_CPUSETS=y
> # CONFIG_PROC_PID_CPUSET is not set
> # CONFIG_CGROUP_CPUACCT is not set
> CONFIG_RESOURCE_COUNTERS=y
> # CONFIG_MEMCG is not set
> # CONFIG_CGROUP_HUGETLB is not set
> CONFIG_CGROUP_PERF=y
> CONFIG_CGROUP_SCHED=y
> CONFIG_FAIR_GROUP_SCHED=y
> CONFIG_CFS_BANDWIDTH=y
> CONFIG_RT_GROUP_SCHED=y
> # CONFIG_BLK_CGROUP is not set
> # CONFIG_CHECKPOINT_RESTORE is not set
> CONFIG_NAMESPACES=y
> CONFIG_UTS_NS=y
> CONFIG_IPC_NS=y
> # CONFIG_USER_NS is not set
> CONFIG_PID_NS=y
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
> CONFIG_RD_LZ4=y
> # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> CONFIG_SYSCTL=y
> CONFIG_ANON_INODES=y
> CONFIG_HAVE_UID16=y
> CONFIG_SYSCTL_EXCEPTION_TRACE=y
> CONFIG_HAVE_PCSPKR_PLATFORM=y
> # CONFIG_EXPERT is not set
> CONFIG_UID16=y
> CONFIG_SGETMASK_SYSCALL=y
> CONFIG_SYSFS_SYSCALL=y
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
> CONFIG_PERF_USE_VMALLOC=y
> 
> #
> # Kernel Performance Events And Counters
> #
> CONFIG_PERF_EVENTS=y
> CONFIG_DEBUG_PERF_USE_VMALLOC=y
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_COMPAT_BRK=y
> CONFIG_SLAB=y
> # CONFIG_SLUB is not set
> CONFIG_SYSTEM_TRUSTED_KEYRING=y
> # CONFIG_PROFILING is not set
> CONFIG_TRACEPOINTS=y
> CONFIG_HAVE_OPROFILE=y
> CONFIG_OPROFILE_NMI_TIMER=y
> # CONFIG_KPROBES is not set
> # CONFIG_JUMP_LABEL is not set
> CONFIG_UPROBES=y
> # CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_ARCH_USE_BUILTIN_BSWAP=y
> CONFIG_USER_RETURN_NOTIFIER=y
> CONFIG_HAVE_IOREMAP_PROT=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> CONFIG_HAVE_OPTPROBES=y
> CONFIG_HAVE_KPROBES_ON_FTRACE=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> CONFIG_HAVE_DMA_ATTRS=y
> CONFIG_HAVE_DMA_CONTIGUOUS=y
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
> CONFIG_HAVE_CMPXCHG_LOCAL=y
> CONFIG_HAVE_CMPXCHG_DOUBLE=y
> CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
> CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
> CONFIG_HAVE_CC_STACKPROTECTOR=y
> # CONFIG_CC_STACKPROTECTOR is not set
> CONFIG_CC_STACKPROTECTOR_NONE=y
> # CONFIG_CC_STACKPROTECTOR_REGULAR is not set
> # CONFIG_CC_STACKPROTECTOR_STRONG is not set
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
> CONFIG_MODULE_FORCE_LOAD=y
> # CONFIG_MODULE_UNLOAD is not set
> CONFIG_MODVERSIONS=y
> CONFIG_MODULE_SRCVERSION_ALL=y
> CONFIG_MODULE_SIG=y
> # CONFIG_MODULE_SIG_FORCE is not set
> # CONFIG_MODULE_SIG_ALL is not set
> # CONFIG_MODULE_SIG_SHA1 is not set
> # CONFIG_MODULE_SIG_SHA224 is not set
> # CONFIG_MODULE_SIG_SHA256 is not set
> CONFIG_MODULE_SIG_SHA384=y
> # CONFIG_MODULE_SIG_SHA512 is not set
> CONFIG_MODULE_SIG_HASH="sha384"
> CONFIG_STOP_MACHINE=y
> CONFIG_BLOCK=y
> # CONFIG_LBDAF is not set
> CONFIG_BLK_DEV_BSG=y
> CONFIG_BLK_DEV_BSGLIB=y
> CONFIG_BLK_DEV_INTEGRITY=y
> # CONFIG_BLK_CMDLINE_PARSER is not set
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
> CONFIG_IOSCHED_DEADLINE=m
> # CONFIG_IOSCHED_CFQ is not set
> CONFIG_DEFAULT_NOOP=y
> CONFIG_DEFAULT_IOSCHED="noop"
> CONFIG_PREEMPT_NOTIFIERS=y
> CONFIG_ASN1=y
> CONFIG_UNINLINE_SPIN_UNLOCK=y
> CONFIG_ARCH_USE_QUEUE_RWLOCK=y
> CONFIG_QUEUE_RWLOCK=y
> CONFIG_FREEZER=y
> 
> #
> # Processor type and features
> #
> CONFIG_ZONE_DMA=y
> CONFIG_SMP=y
> CONFIG_X86_MPPARSE=y
> # CONFIG_X86_BIGSMP is not set
> CONFIG_X86_EXTENDED_PLATFORM=y
> # CONFIG_X86_GOLDFISH is not set
> # CONFIG_X86_INTEL_LPSS is not set
> # CONFIG_X86_RDC321X is not set
> CONFIG_X86_32_NON_STANDARD=y
> # CONFIG_STA2X11 is not set
> # CONFIG_X86_32_IRIS is not set
> # CONFIG_SCHED_OMIT_FRAME_POINTER is not set
> CONFIG_HYPERVISOR_GUEST=y
> CONFIG_PARAVIRT=y
> # CONFIG_PARAVIRT_DEBUG is not set
> # CONFIG_PARAVIRT_SPINLOCKS is not set
> CONFIG_KVM_GUEST=y
> # CONFIG_KVM_DEBUG_FS is not set
> # CONFIG_LGUEST_GUEST is not set
> # CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
> CONFIG_PARAVIRT_CLOCK=y
> CONFIG_NO_BOOTMEM=y
> CONFIG_MEMTEST=y
> # CONFIG_M486 is not set
> # CONFIG_M586 is not set
> CONFIG_M586TSC=y
> # CONFIG_M586MMX is not set
> # CONFIG_M686 is not set
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
> # CONFIG_X86_GENERIC is not set
> CONFIG_X86_INTERNODE_CACHE_SHIFT=5
> CONFIG_X86_L1_CACHE_SHIFT=5
> # CONFIG_X86_PPRO_FENCE is not set
> CONFIG_X86_F00F_BUG=y
> CONFIG_X86_ALIGNMENT_16=y
> CONFIG_X86_TSC=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=4
> CONFIG_CPU_SUP_INTEL=y
> CONFIG_CPU_SUP_CYRIX_32=y
> CONFIG_CPU_SUP_AMD=y
> CONFIG_CPU_SUP_CENTAUR=y
> CONFIG_CPU_SUP_TRANSMETA_32=y
> CONFIG_HPET_TIMER=y
> CONFIG_DMI=y
> CONFIG_NR_CPUS=8
> # CONFIG_SCHED_SMT is not set
> CONFIG_SCHED_MC=y
> # CONFIG_PREEMPT_NONE is not set
> # CONFIG_PREEMPT_VOLUNTARY is not set
> CONFIG_PREEMPT=y
> CONFIG_PREEMPT_COUNT=y
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
> CONFIG_X86_MCE=y
> CONFIG_X86_MCE_INTEL=y
> CONFIG_X86_MCE_AMD=y
> # CONFIG_X86_ANCIENT_MCE is not set
> CONFIG_X86_MCE_THRESHOLD=y
> CONFIG_X86_MCE_INJECT=y
> CONFIG_X86_THERMAL_VECTOR=y
> CONFIG_VM86=y
> CONFIG_X86_16BIT=y
> CONFIG_X86_ESPFIX32=y
> # CONFIG_TOSHIBA is not set
> # CONFIG_I8K is not set
> CONFIG_X86_REBOOTFIXUPS=y
> # CONFIG_MICROCODE is not set
> # CONFIG_MICROCODE_INTEL_EARLY is not set
> # CONFIG_MICROCODE_AMD_EARLY is not set
> CONFIG_X86_MSR=m
> # CONFIG_X86_CPUID is not set
> # CONFIG_NOHIGHMEM is not set
> CONFIG_HIGHMEM4G=y
> # CONFIG_HIGHMEM64G is not set
> CONFIG_PAGE_OFFSET=0xC0000000
> CONFIG_HIGHMEM=y
> CONFIG_NEED_NODE_MEMMAP_SIZE=y
> CONFIG_ARCH_FLATMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_ILLEGAL_POINTER_VALUE=0
> CONFIG_SELECT_MEMORY_MODEL=y
> # CONFIG_FLATMEM_MANUAL is not set
> CONFIG_SPARSEMEM_MANUAL=y
> CONFIG_SPARSEMEM=y
> CONFIG_HAVE_MEMORY_PRESENT=y
> CONFIG_SPARSEMEM_STATIC=y
> CONFIG_HAVE_MEMBLOCK=y
> CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
> CONFIG_ARCH_DISCARD_MEMBLOCK=y
> CONFIG_MEMORY_ISOLATION=y
> # CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
> CONFIG_MEMORY_HOTPLUG=y
> CONFIG_MEMORY_HOTPLUG_SPARSE=y
> # CONFIG_MEMORY_HOTREMOVE is not set
> CONFIG_SPLIT_PTLOCK_CPUS=4
> CONFIG_BALLOON_COMPACTION=y
> CONFIG_COMPACTION=y
> CONFIG_MIGRATION=y
> # CONFIG_PHYS_ADDR_T_64BIT is not set
> CONFIG_ZONE_DMA_FLAG=1
> # CONFIG_BOUNCE is not set
> CONFIG_NEED_BOUNCE_POOL=y
> CONFIG_VIRT_TO_BUS=y
> CONFIG_MMU_NOTIFIER=y
> CONFIG_KSM=y
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> CONFIG_TRANSPARENT_HUGEPAGE=y
> # CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
> CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
> CONFIG_CLEANCACHE=y
> CONFIG_CMA=y
> CONFIG_CMA_DEBUG=y
> # CONFIG_ZBUD is not set
> # CONFIG_ZSMALLOC is not set
> CONFIG_GENERIC_EARLY_IOREMAP=y
> # CONFIG_HIGHPTE is not set
> CONFIG_X86_CHECK_BIOS_CORRUPTION=y
> # CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
> CONFIG_X86_RESERVE_LOW=64
> CONFIG_MATH_EMULATION=y
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
> # CONFIG_HZ_100 is not set
> # CONFIG_HZ_250 is not set
> CONFIG_HZ_300=y
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=300
> CONFIG_SCHED_HRTICK=y
> # CONFIG_KEXEC is not set
> CONFIG_CRASH_DUMP=y
> CONFIG_PHYSICAL_START=0x1000000
> CONFIG_RELOCATABLE=y
> # CONFIG_RANDOMIZE_BASE is not set
> CONFIG_X86_NEED_RELOCS=y
> CONFIG_PHYSICAL_ALIGN=0x200000
> CONFIG_HOTPLUG_CPU=y
> # CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
> # CONFIG_DEBUG_HOTPLUG_CPU0 is not set
> CONFIG_COMPAT_VDSO=y
> # CONFIG_CMDLINE_BOOL is not set
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
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
> # CONFIG_PM_RUNTIME is not set
> CONFIG_PM=y
> CONFIG_PM_DEBUG=y
> # CONFIG_PM_ADVANCED_DEBUG is not set
> # CONFIG_PM_TEST_SUSPEND is not set
> CONFIG_PM_SLEEP_DEBUG=y
> CONFIG_PM_TRACE=y
> CONFIG_PM_TRACE_RTC=y
> # CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
> CONFIG_ACPI=y
> CONFIG_ACPI_SLEEP=y
> # CONFIG_ACPI_PROCFS_POWER is not set
> # CONFIG_ACPI_EC_DEBUGFS is not set
> CONFIG_ACPI_AC=y
> CONFIG_ACPI_BATTERY=y
> CONFIG_ACPI_BUTTON=y
> # CONFIG_ACPI_VIDEO is not set
> CONFIG_ACPI_FAN=y
> # CONFIG_ACPI_DOCK is not set
> CONFIG_ACPI_PROCESSOR=y
> # CONFIG_ACPI_IPMI is not set
> CONFIG_ACPI_HOTPLUG_CPU=y
> # CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
> CONFIG_ACPI_THERMAL=y
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> # CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
> # CONFIG_ACPI_DEBUG is not set
> # CONFIG_ACPI_PCI_SLOT is not set
> CONFIG_X86_PM_TIMER=y
> CONFIG_ACPI_CONTAINER=y
> # CONFIG_ACPI_HOTPLUG_MEMORY is not set
> # CONFIG_ACPI_SBS is not set
> # CONFIG_ACPI_HED is not set
> # CONFIG_ACPI_CUSTOM_METHOD is not set
> # CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
> # CONFIG_ACPI_APEI is not set
> # CONFIG_ACPI_EXTLOG is not set
> # CONFIG_SFI is not set
> CONFIG_X86_APM_BOOT=y
> CONFIG_APM=m
> # CONFIG_APM_IGNORE_USER_SUSPEND is not set
> # CONFIG_APM_DO_ENABLE is not set
> # CONFIG_APM_CPU_IDLE is not set
> # CONFIG_APM_DISPLAY_BLANK is not set
> # CONFIG_APM_ALLOW_INTS is not set
> 
> #
> # CPU Frequency scaling
> #
> CONFIG_CPU_FREQ=y
> CONFIG_CPU_FREQ_GOV_COMMON=y
> CONFIG_CPU_FREQ_STAT=m
> # CONFIG_CPU_FREQ_STAT_DETAILS is not set
> CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
> CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
> CONFIG_CPU_FREQ_GOV_POWERSAVE=y
> CONFIG_CPU_FREQ_GOV_USERSPACE=y
> CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> # CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set
> 
> #
> # x86 CPU frequency scaling drivers
> #
> # CONFIG_X86_INTEL_PSTATE is not set
> # CONFIG_X86_PCC_CPUFREQ is not set
> # CONFIG_X86_ACPI_CPUFREQ is not set
> CONFIG_X86_POWERNOW_K6=m
> CONFIG_X86_POWERNOW_K7=m
> CONFIG_X86_POWERNOW_K7_ACPI=y
> CONFIG_X86_GX_SUSPMOD=m
> CONFIG_X86_SPEEDSTEP_CENTRINO=m
> CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
> # CONFIG_X86_SPEEDSTEP_ICH is not set
> # CONFIG_X86_SPEEDSTEP_SMI is not set
> CONFIG_X86_P4_CLOCKMOD=y
> # CONFIG_X86_CPUFREQ_NFORCE2 is not set
> # CONFIG_X86_LONGRUN is not set
> # CONFIG_X86_LONGHAUL is not set
> # CONFIG_X86_E_POWERSAVER is not set
> 
> #
> # shared options
> #
> CONFIG_X86_SPEEDSTEP_LIB=y
> 
> #
> # CPU Idle
> #
> CONFIG_CPU_IDLE=y
> # CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
> CONFIG_CPU_IDLE_GOV_LADDER=y
> CONFIG_CPU_IDLE_GOV_MENU=y
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
> CONFIG_PCI_GOOLPC=y
> # CONFIG_PCI_GOANY is not set
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_OLPC=y
> CONFIG_PCI_DOMAINS=y
> CONFIG_PCIEPORTBUS=y
> CONFIG_HOTPLUG_PCI_PCIE=y
> # CONFIG_PCIEAER is not set
> CONFIG_PCIEASPM=y
> # CONFIG_PCIEASPM_DEBUG is not set
> CONFIG_PCIEASPM_DEFAULT=y
> # CONFIG_PCIEASPM_POWERSAVE is not set
> # CONFIG_PCIEASPM_PERFORMANCE is not set
> # CONFIG_PCI_MSI is not set
> # CONFIG_PCI_DEBUG is not set
> # CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
> # CONFIG_PCI_STUB is not set
> CONFIG_HT_IRQ=y
> CONFIG_PCI_ATS=y
> CONFIG_PCI_IOV=y
> CONFIG_PCI_PRI=y
> # CONFIG_PCI_PASID is not set
> # CONFIG_PCI_IOAPIC is not set
> CONFIG_PCI_LABEL=y
> 
> #
> # PCI host controller drivers
> #
> CONFIG_ISA_DMA_API=y
> # CONFIG_ISA is not set
> # CONFIG_SCx200 is not set
> CONFIG_OLPC=y
> CONFIG_OLPC_XO1_PM=y
> # CONFIG_OLPC_XO1_SCI is not set
> # CONFIG_OLPC_XO15_SCI is not set
> # CONFIG_ALIX is not set
> CONFIG_NET5501=y
> CONFIG_GEOS=y
> CONFIG_AMD_NB=y
> CONFIG_PCCARD=m
> CONFIG_PCMCIA=m
> CONFIG_PCMCIA_LOAD_CIS=y
> # CONFIG_CARDBUS is not set
> 
> #
> # PC-card bridges
> #
> # CONFIG_YENTA is not set
> # CONFIG_PD6729 is not set
> CONFIG_I82092=m
> CONFIG_PCCARD_NONSTATIC=y
> CONFIG_HOTPLUG_PCI=y
> # CONFIG_HOTPLUG_PCI_ACPI is not set
> CONFIG_HOTPLUG_PCI_CPCI=y
> CONFIG_HOTPLUG_PCI_CPCI_ZT5550=y
> # CONFIG_HOTPLUG_PCI_CPCI_GENERIC is not set
> CONFIG_HOTPLUG_PCI_SHPC=y
> CONFIG_RAPIDIO=m
> CONFIG_RAPIDIO_TSI721=m
> CONFIG_RAPIDIO_DISC_TIMEOUT=30
> CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
> # CONFIG_RAPIDIO_DMA_ENGINE is not set
> # CONFIG_RAPIDIO_DEBUG is not set
> CONFIG_RAPIDIO_ENUM_BASIC=m
> 
> #
> # RapidIO Switch drivers
> #
> # CONFIG_RAPIDIO_TSI57X is not set
> CONFIG_RAPIDIO_CPS_XX=m
> CONFIG_RAPIDIO_TSI568=m
> CONFIG_RAPIDIO_CPS_GEN2=m
> # CONFIG_X86_SYSFB is not set
> 
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
> # CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
> CONFIG_BINFMT_SCRIPT=y
> CONFIG_HAVE_AOUT=y
> # CONFIG_BINFMT_AOUT is not set
> CONFIG_BINFMT_MISC=y
> CONFIG_COREDUMP=y
> CONFIG_HAVE_ATOMIC_IOMAP=y
> CONFIG_IOSF_MBI=m
> CONFIG_NET=y
> 
> #
> # Networking options
> #
> CONFIG_PACKET=m
> # CONFIG_PACKET_DIAG is not set
> CONFIG_UNIX=y
> CONFIG_UNIX_DIAG=m
> CONFIG_XFRM=y
> CONFIG_XFRM_ALGO=y
> CONFIG_XFRM_USER=m
> # CONFIG_XFRM_SUB_POLICY is not set
> # CONFIG_XFRM_MIGRATE is not set
> # CONFIG_XFRM_STATISTICS is not set
> CONFIG_XFRM_IPCOMP=y
> CONFIG_NET_KEY=y
> # CONFIG_NET_KEY_MIGRATE is not set
> CONFIG_INET=y
> CONFIG_IP_MULTICAST=y
> # CONFIG_IP_ADVANCED_ROUTER is not set
> # CONFIG_IP_PNP is not set
> CONFIG_NET_IPIP=y
> CONFIG_NET_IPGRE_DEMUX=m
> CONFIG_NET_IP_TUNNEL=y
> CONFIG_NET_IPGRE=m
> # CONFIG_NET_IPGRE_BROADCAST is not set
> # CONFIG_IP_MROUTE is not set
> CONFIG_SYN_COOKIES=y
> CONFIG_NET_IPVTI=m
> CONFIG_INET_AH=y
> CONFIG_INET_ESP=y
> CONFIG_INET_IPCOMP=y
> CONFIG_INET_XFRM_TUNNEL=y
> CONFIG_INET_TUNNEL=y
> CONFIG_INET_XFRM_MODE_TRANSPORT=m
> CONFIG_INET_XFRM_MODE_TUNNEL=m
> CONFIG_INET_XFRM_MODE_BEET=m
> # CONFIG_INET_LRO is not set
> CONFIG_INET_DIAG=y
> CONFIG_INET_TCP_DIAG=y
> CONFIG_INET_UDP_DIAG=m
> # CONFIG_TCP_CONG_ADVANCED is not set
> CONFIG_TCP_CONG_CUBIC=y
> CONFIG_DEFAULT_TCP_CONG="cubic"
> CONFIG_TCP_MD5SIG=y
> # CONFIG_IPV6 is not set
> CONFIG_NETLABEL=y
> CONFIG_NETWORK_SECMARK=y
> CONFIG_NET_PTP_CLASSIFY=y
> # CONFIG_NETWORK_PHY_TIMESTAMPING is not set
> CONFIG_NETFILTER=y
> # CONFIG_NETFILTER_DEBUG is not set
> # CONFIG_NETFILTER_ADVANCED is not set
> 
> #
> # Core Netfilter Configuration
> #
> CONFIG_NETFILTER_NETLINK=y
> # CONFIG_NETFILTER_NETLINK_LOG is not set
> # CONFIG_NF_CONNTRACK is not set
> CONFIG_NF_TABLES=y
> CONFIG_NFT_EXTHDR=m
> CONFIG_NFT_META=m
> CONFIG_NFT_RBTREE=m
> CONFIG_NFT_HASH=m
> # CONFIG_NFT_COUNTER is not set
> # CONFIG_NFT_LOG is not set
> CONFIG_NFT_LIMIT=m
> CONFIG_NFT_REJECT=m
> # CONFIG_NFT_COMPAT is not set
> CONFIG_NETFILTER_XTABLES=y
> 
> #
> # Xtables combined modules
> #
> CONFIG_NETFILTER_XT_MARK=m
> 
> #
> # Xtables targets
> #
> CONFIG_NETFILTER_XT_TARGET_LOG=m
> # CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
> CONFIG_NETFILTER_XT_TARGET_SECMARK=y
> # CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
> 
> #
> # Xtables matches
> #
> # CONFIG_NETFILTER_XT_MATCH_POLICY is not set
> # CONFIG_IP_SET is not set
> CONFIG_IP_VS=y
> # CONFIG_IP_VS_DEBUG is not set
> CONFIG_IP_VS_TAB_BITS=12
> 
> #
> # IPVS transport protocol load balancing support
> #
> # CONFIG_IP_VS_PROTO_TCP is not set
> CONFIG_IP_VS_PROTO_UDP=y
> # CONFIG_IP_VS_PROTO_AH_ESP is not set
> # CONFIG_IP_VS_PROTO_ESP is not set
> # CONFIG_IP_VS_PROTO_AH is not set
> # CONFIG_IP_VS_PROTO_SCTP is not set
> 
> #
> # IPVS scheduler
> #
> # CONFIG_IP_VS_RR is not set
> CONFIG_IP_VS_WRR=y
> CONFIG_IP_VS_LC=m
> CONFIG_IP_VS_WLC=m
> CONFIG_IP_VS_LBLC=y
> # CONFIG_IP_VS_LBLCR is not set
> # CONFIG_IP_VS_DH is not set
> CONFIG_IP_VS_SH=m
> # CONFIG_IP_VS_SED is not set
> CONFIG_IP_VS_NQ=y
> 
> #
> # IPVS SH scheduler
> #
> CONFIG_IP_VS_SH_TAB_BITS=8
> 
> #
> # IPVS application helper
> #
> 
> #
> # IP: Netfilter Configuration
> #
> # CONFIG_NF_DEFRAG_IPV4 is not set
> CONFIG_NF_TABLES_IPV4=m
> CONFIG_NFT_CHAIN_ROUTE_IPV4=m
> CONFIG_NFT_REJECT_IPV4=m
> CONFIG_NF_TABLES_ARP=m
> CONFIG_IP_NF_IPTABLES=m
> CONFIG_IP_NF_FILTER=m
> # CONFIG_IP_NF_TARGET_REJECT is not set
> CONFIG_IP_NF_TARGET_ULOG=m
> CONFIG_IP_NF_MANGLE=m
> CONFIG_IP_NF_RAW=m
> CONFIG_NF_TABLES_BRIDGE=m
> CONFIG_NFT_BRIDGE_META=m
> CONFIG_BRIDGE_NF_EBTABLES=y
> # CONFIG_BRIDGE_EBT_BROUTE is not set
> CONFIG_BRIDGE_EBT_T_FILTER=y
> CONFIG_BRIDGE_EBT_T_NAT=y
> CONFIG_BRIDGE_EBT_802_3=y
> # CONFIG_BRIDGE_EBT_AMONG is not set
> # CONFIG_BRIDGE_EBT_ARP is not set
> # CONFIG_BRIDGE_EBT_IP is not set
> # CONFIG_BRIDGE_EBT_LIMIT is not set
> CONFIG_BRIDGE_EBT_MARK=y
> # CONFIG_BRIDGE_EBT_PKTTYPE is not set
> CONFIG_BRIDGE_EBT_STP=y
> CONFIG_BRIDGE_EBT_VLAN=y
> # CONFIG_BRIDGE_EBT_ARPREPLY is not set
> CONFIG_BRIDGE_EBT_DNAT=m
> CONFIG_BRIDGE_EBT_MARK_T=m
> CONFIG_BRIDGE_EBT_REDIRECT=y
> CONFIG_BRIDGE_EBT_SNAT=m
> CONFIG_BRIDGE_EBT_LOG=m
> # CONFIG_BRIDGE_EBT_ULOG is not set
> # CONFIG_BRIDGE_EBT_NFLOG is not set
> # CONFIG_IP_DCCP is not set
> CONFIG_IP_SCTP=m
> # CONFIG_SCTP_DBG_OBJCNT is not set
> CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
> # CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
> # CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
> CONFIG_SCTP_COOKIE_HMAC_MD5=y
> CONFIG_SCTP_COOKIE_HMAC_SHA1=y
> # CONFIG_RDS is not set
> # CONFIG_TIPC is not set
> # CONFIG_ATM is not set
> # CONFIG_L2TP is not set
> CONFIG_STP=y
> CONFIG_BRIDGE=y
> # CONFIG_BRIDGE_IGMP_SNOOPING is not set
> CONFIG_HAVE_NET_DSA=y
> CONFIG_NET_DSA=y
> CONFIG_NET_DSA_TAG_DSA=y
> # CONFIG_VLAN_8021Q is not set
> CONFIG_DECNET=m
> CONFIG_DECNET_ROUTER=y
> CONFIG_LLC=y
> # CONFIG_LLC2 is not set
> CONFIG_IPX=y
> # CONFIG_IPX_INTERN is not set
> CONFIG_ATALK=m
> CONFIG_DEV_APPLETALK=m
> # CONFIG_IPDDP is not set
> # CONFIG_X25 is not set
> CONFIG_LAPB=y
> CONFIG_PHONET=m
> CONFIG_IEEE802154=y
> CONFIG_MAC802154=m
> # CONFIG_NET_SCHED is not set
> CONFIG_DCB=y
> CONFIG_DNS_RESOLVER=y
> # CONFIG_BATMAN_ADV is not set
> # CONFIG_OPENVSWITCH is not set
> CONFIG_VSOCKETS=m
> # CONFIG_VMWARE_VMCI_VSOCKETS is not set
> CONFIG_NETLINK_MMAP=y
> # CONFIG_NETLINK_DIAG is not set
> CONFIG_NET_MPLS_GSO=m
> # CONFIG_HSR is not set
> CONFIG_RPS=y
> CONFIG_RFS_ACCEL=y
> CONFIG_XPS=y
> # CONFIG_CGROUP_NET_PRIO is not set
> # CONFIG_CGROUP_NET_CLASSID is not set
> CONFIG_NET_RX_BUSY_POLL=y
> CONFIG_BQL=y
> CONFIG_NET_FLOW_LIMIT=y
> 
> #
> # Network testing
> #
> # CONFIG_NET_PKTGEN is not set
> # CONFIG_NET_DROP_MONITOR is not set
> CONFIG_HAMRADIO=y
> 
> #
> # Packet Radio protocols
> #
> # CONFIG_AX25 is not set
> CONFIG_CAN=y
> # CONFIG_CAN_RAW is not set
> CONFIG_CAN_BCM=m
> CONFIG_CAN_GW=y
> 
> #
> # CAN Device Drivers
> #
> # CONFIG_CAN_VCAN is not set
> # CONFIG_CAN_SLCAN is not set
> # CONFIG_CAN_DEV is not set
> # CONFIG_CAN_DEBUG_DEVICES is not set
> CONFIG_IRDA=y
> 
> #
> # IrDA protocols
> #
> CONFIG_IRLAN=m
> CONFIG_IRNET=m
> CONFIG_IRCOMM=y
> # CONFIG_IRDA_ULTRA is not set
> 
> #
> # IrDA options
> #
> # CONFIG_IRDA_CACHE_LAST_LSAP is not set
> CONFIG_IRDA_FAST_RR=y
> # CONFIG_IRDA_DEBUG is not set
> 
> #
> # Infrared-port device drivers
> #
> 
> #
> # SIR device drivers
> #
> CONFIG_IRTTY_SIR=m
> 
> #
> # Dongle support
> #
> # CONFIG_DONGLE is not set
> 
> #
> # FIR device drivers
> #
> CONFIG_NSC_FIR=y
> # CONFIG_WINBOND_FIR is not set
> CONFIG_TOSHIBA_FIR=m
> # CONFIG_SMC_IRCC_FIR is not set
> CONFIG_ALI_FIR=m
> CONFIG_VLSI_FIR=y
> CONFIG_VIA_FIR=m
> # CONFIG_BT is not set
> CONFIG_AF_RXRPC=y
> CONFIG_AF_RXRPC_DEBUG=y
> CONFIG_RXKAD=y
> CONFIG_FIB_RULES=y
> CONFIG_WIRELESS=y
> CONFIG_WIRELESS_EXT=y
> CONFIG_WEXT_CORE=y
> CONFIG_WEXT_PROC=y
> CONFIG_WEXT_SPY=y
> CONFIG_WEXT_PRIV=y
> CONFIG_CFG80211=y
> CONFIG_NL80211_TESTMODE=y
> CONFIG_CFG80211_DEVELOPER_WARNINGS=y
> CONFIG_CFG80211_REG_DEBUG=y
> CONFIG_CFG80211_DEFAULT_PS=y
> # CONFIG_CFG80211_DEBUGFS is not set
> # CONFIG_CFG80211_INTERNAL_REGDB is not set
> # CONFIG_CFG80211_WEXT is not set
> CONFIG_LIB80211=m
> CONFIG_LIB80211_CRYPT_WEP=m
> CONFIG_LIB80211_CRYPT_CCMP=m
> CONFIG_LIB80211_CRYPT_TKIP=m
> CONFIG_LIB80211_DEBUG=y
> # CONFIG_MAC80211 is not set
> # CONFIG_WIMAX is not set
> CONFIG_RFKILL=y
> CONFIG_RFKILL_LEDS=y
> CONFIG_RFKILL_INPUT=y
> # CONFIG_RFKILL_REGULATOR is not set
> CONFIG_RFKILL_GPIO=y
> # CONFIG_NET_9P is not set
> CONFIG_CAIF=y
> CONFIG_CAIF_DEBUG=y
> # CONFIG_CAIF_NETDEV is not set
> CONFIG_CAIF_USB=m
> # CONFIG_CEPH_LIB is not set
> CONFIG_NFC=y
> CONFIG_NFC_DIGITAL=m
> CONFIG_NFC_NCI=y
> # CONFIG_NFC_HCI is not set
> 
> #
> # Near Field Communication (NFC) devices
> #
> # CONFIG_NFC_SIM is not set
> CONFIG_NFC_MRVL=y
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER=y
> CONFIG_UEVENT_HELPER_PATH=""
> CONFIG_DEVTMPFS=y
> CONFIG_DEVTMPFS_MOUNT=y
> CONFIG_STANDALONE=y
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> # CONFIG_FIRMWARE_IN_KERNEL is not set
> CONFIG_EXTRA_FIRMWARE=""
> CONFIG_FW_LOADER_USER_HELPER=y
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_GENERIC_CPU_DEVICES is not set
> CONFIG_GENERIC_CPU_AUTOPROBE=y
> CONFIG_REGMAP=y
> CONFIG_REGMAP_I2C=m
> CONFIG_REGMAP_MMIO=y
> CONFIG_REGMAP_IRQ=y
> # CONFIG_DMA_SHARED_BUFFER is not set
> CONFIG_DMA_CMA=y
> 
> #
> # Default contiguous memory area size:
> #
> CONFIG_CMA_SIZE_MBYTES=16
> CONFIG_CMA_SIZE_PERCENTAGE=10
> # CONFIG_CMA_SIZE_SEL_MBYTES is not set
> # CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
> # CONFIG_CMA_SIZE_SEL_MIN is not set
> CONFIG_CMA_SIZE_SEL_MAX=y
> CONFIG_CMA_ALIGNMENT=8
> CONFIG_CMA_AREAS=7
> 
> #
> # Bus devices
> #
> CONFIG_CONNECTOR=m
> # CONFIG_MTD is not set
> CONFIG_OF=y
> 
> #
> # Device Tree and Open Firmware support
> #
> # CONFIG_OF_SELFTEST is not set
> CONFIG_OF_PROMTREE=y
> CONFIG_OF_ADDRESS=y
> CONFIG_OF_ADDRESS_PCI=y
> CONFIG_OF_IRQ=y
> CONFIG_OF_NET=y
> CONFIG_OF_MDIO=y
> CONFIG_OF_PCI=y
> CONFIG_OF_PCI_IRQ=y
> # CONFIG_PARPORT is not set
> CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
> CONFIG_PNP=y
> CONFIG_PNP_DEBUG_MESSAGES=y
> 
> #
> # Protocols
> #
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> # CONFIG_BLK_DEV_NULL_BLK is not set
> # CONFIG_BLK_DEV_FD is not set
> # CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_UMEM is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> # CONFIG_BLK_DEV_LOOP is not set
> # CONFIG_BLK_DEV_DRBD is not set
> # CONFIG_BLK_DEV_NBD is not set
> # CONFIG_BLK_DEV_NVME is not set
> # CONFIG_BLK_DEV_SX8 is not set
> # CONFIG_BLK_DEV_RAM is not set
> # CONFIG_CDROM_PKTCDVD is not set
> # CONFIG_ATA_OVER_ETH is not set
> # CONFIG_VIRTIO_BLK is not set
> # CONFIG_BLK_DEV_HD is not set
> # CONFIG_BLK_DEV_RBD is not set
> # CONFIG_BLK_DEV_RSXX is not set
> 
> #
> # Misc devices
> #
> CONFIG_SENSORS_LIS3LV02D=m
> CONFIG_AD525X_DPOT=m
> CONFIG_AD525X_DPOT_I2C=m
> CONFIG_DUMMY_IRQ=y
> CONFIG_IBM_ASM=y
> CONFIG_PHANTOM=m
> CONFIG_SGI_IOC4=y
> CONFIG_TIFM_CORE=m
> CONFIG_TIFM_7XX1=m
> # CONFIG_ICS932S401 is not set
> CONFIG_ENCLOSURE_SERVICES=m
> CONFIG_CS5535_MFGPT=y
> CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
> CONFIG_CS5535_CLOCK_EVENT_SRC=y
> CONFIG_HP_ILO=y
> CONFIG_APDS9802ALS=m
> CONFIG_ISL29003=m
> CONFIG_ISL29020=m
> # CONFIG_SENSORS_TSL2550 is not set
> CONFIG_SENSORS_BH1780=m
> CONFIG_SENSORS_BH1770=m
> # CONFIG_SENSORS_APDS990X is not set
> CONFIG_HMC6352=m
> CONFIG_DS1682=m
> # CONFIG_VMWARE_BALLOON is not set
> # CONFIG_BMP085_I2C is not set
> CONFIG_PCH_PHUB=m
> # CONFIG_USB_SWITCH_FSA9480 is not set
> CONFIG_SRAM=y
> # CONFIG_C2PORT is not set
> 
> #
> # EEPROM support
> #
> CONFIG_EEPROM_AT24=m
> CONFIG_EEPROM_LEGACY=m
> CONFIG_EEPROM_MAX6875=m
> CONFIG_EEPROM_93CX6=m
> # CONFIG_CB710_CORE is not set
> 
> #
> # Texas Instruments shared transport line discipline
> #
> # CONFIG_TI_ST is not set
> CONFIG_SENSORS_LIS3_I2C=m
> 
> #
> # Altera FPGA firmware download module
> #
> CONFIG_ALTERA_STAPL=m
> CONFIG_INTEL_MEI=m
> CONFIG_INTEL_MEI_ME=m
> CONFIG_INTEL_MEI_TXE=m
> CONFIG_VMWARE_VMCI=y
> 
> #
> # Intel MIC Host Driver
> #
> 
> #
> # Intel MIC Card Driver
> #
> CONFIG_ECHO=m
> CONFIG_HAVE_IDE=y
> CONFIG_IDE=m
> 
> #
> # Please see Documentation/ide/ide.txt for help/info on IDE drives
> #
> CONFIG_IDE_XFER_MODE=y
> CONFIG_IDE_TIMINGS=y
> CONFIG_IDE_ATAPI=y
> # CONFIG_BLK_DEV_IDE_SATA is not set
> # CONFIG_IDE_GD is not set
> # CONFIG_BLK_DEV_IDECS is not set
> # CONFIG_BLK_DEV_IDECD is not set
> CONFIG_BLK_DEV_IDETAPE=m
> # CONFIG_BLK_DEV_IDEACPI is not set
> CONFIG_IDE_TASK_IOCTL=y
> # CONFIG_IDE_PROC_FS is not set
> 
> #
> # IDE chipset support/bugfixes
> #
> # CONFIG_IDE_GENERIC is not set
> CONFIG_BLK_DEV_PLATFORM=m
> CONFIG_BLK_DEV_CMD640=m
> # CONFIG_BLK_DEV_CMD640_ENHANCED is not set
> # CONFIG_BLK_DEV_IDEPNP is not set
> CONFIG_BLK_DEV_IDEDMA_SFF=y
> 
> #
> # PCI IDE chipsets support
> #
> CONFIG_BLK_DEV_IDEPCI=y
> CONFIG_BLK_DEV_OFFBOARD=y
> CONFIG_BLK_DEV_GENERIC=m
> # CONFIG_BLK_DEV_OPTI621 is not set
> CONFIG_BLK_DEV_RZ1000=m
> CONFIG_BLK_DEV_IDEDMA_PCI=y
> # CONFIG_BLK_DEV_AEC62XX is not set
> # CONFIG_BLK_DEV_ALI15X3 is not set
> CONFIG_BLK_DEV_AMD74XX=m
> # CONFIG_BLK_DEV_ATIIXP is not set
> # CONFIG_BLK_DEV_CMD64X is not set
> CONFIG_BLK_DEV_TRIFLEX=m
> CONFIG_BLK_DEV_CS5520=m
> # CONFIG_BLK_DEV_CS5530 is not set
> CONFIG_BLK_DEV_CS5535=m
> # CONFIG_BLK_DEV_CS5536 is not set
> # CONFIG_BLK_DEV_HPT366 is not set
> # CONFIG_BLK_DEV_JMICRON is not set
> CONFIG_BLK_DEV_SC1200=m
> # CONFIG_BLK_DEV_PIIX is not set
> CONFIG_BLK_DEV_IT8172=m
> # CONFIG_BLK_DEV_IT8213 is not set
> CONFIG_BLK_DEV_IT821X=m
> CONFIG_BLK_DEV_NS87415=m
> CONFIG_BLK_DEV_PDC202XX_OLD=m
> CONFIG_BLK_DEV_PDC202XX_NEW=m
> # CONFIG_BLK_DEV_SVWKS is not set
> CONFIG_BLK_DEV_SIIMAGE=m
> # CONFIG_BLK_DEV_SIS5513 is not set
> CONFIG_BLK_DEV_SLC90E66=m
> CONFIG_BLK_DEV_TRM290=m
> CONFIG_BLK_DEV_VIA82CXXX=m
> # CONFIG_BLK_DEV_TC86C001 is not set
> CONFIG_BLK_DEV_IDEDMA=y
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=y
> CONFIG_RAID_ATTRS=m
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> CONFIG_SCSI_TGT=m
> CONFIG_SCSI_NETLINK=y
> # CONFIG_SCSI_PROC_FS is not set
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=m
> # CONFIG_CHR_DEV_ST is not set
> CONFIG_CHR_DEV_OSST=m
> CONFIG_BLK_DEV_SR=m
> CONFIG_BLK_DEV_SR_VENDOR=y
> CONFIG_CHR_DEV_SG=m
> CONFIG_CHR_DEV_SCH=m
> CONFIG_SCSI_ENCLOSURE=m
> # CONFIG_SCSI_MULTI_LUN is not set
> # CONFIG_SCSI_CONSTANTS is not set
> CONFIG_SCSI_LOGGING=y
> # CONFIG_SCSI_SCAN_ASYNC is not set
> 
> #
> # SCSI Transports
> #
> CONFIG_SCSI_SPI_ATTRS=y
> CONFIG_SCSI_FC_ATTRS=y
> CONFIG_SCSI_ISCSI_ATTRS=y
> CONFIG_SCSI_SAS_ATTRS=y
> CONFIG_SCSI_SAS_LIBSAS=y
> # CONFIG_SCSI_SAS_ATA is not set
> CONFIG_SCSI_SAS_HOST_SMP=y
> CONFIG_SCSI_SRP_ATTRS=y
> CONFIG_SCSI_LOWLEVEL=y
> CONFIG_ISCSI_TCP=m
> CONFIG_ISCSI_BOOT_SYSFS=y
> # CONFIG_SCSI_CXGB3_ISCSI is not set
> CONFIG_SCSI_CXGB4_ISCSI=m
> CONFIG_SCSI_BNX2_ISCSI=m
> # CONFIG_SCSI_BNX2X_FCOE is not set
> # CONFIG_BE2ISCSI is not set
> CONFIG_BLK_DEV_3W_XXXX_RAID=m
> # CONFIG_SCSI_HPSA is not set
> CONFIG_SCSI_3W_9XXX=y
> CONFIG_SCSI_3W_SAS=y
> CONFIG_SCSI_ACARD=m
> CONFIG_SCSI_AACRAID=m
> CONFIG_SCSI_AIC7XXX=y
> CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
> CONFIG_AIC7XXX_RESET_DELAY_MS=5000
> CONFIG_AIC7XXX_DEBUG_ENABLE=y
> CONFIG_AIC7XXX_DEBUG_MASK=0
> CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
> CONFIG_SCSI_AIC79XX=m
> CONFIG_AIC79XX_CMDS_PER_DEVICE=32
> CONFIG_AIC79XX_RESET_DELAY_MS=5000
> CONFIG_AIC79XX_DEBUG_ENABLE=y
> CONFIG_AIC79XX_DEBUG_MASK=0
> # CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
> CONFIG_SCSI_AIC94XX=y
> # CONFIG_AIC94XX_DEBUG is not set
> # CONFIG_SCSI_MVSAS is not set
> CONFIG_SCSI_MVUMI=y
> # CONFIG_SCSI_DPT_I2O is not set
> CONFIG_SCSI_ADVANSYS=y
> CONFIG_SCSI_ARCMSR=m
> CONFIG_SCSI_ESAS2R=y
> # CONFIG_MEGARAID_NEWGEN is not set
> CONFIG_MEGARAID_LEGACY=y
> CONFIG_MEGARAID_SAS=m
> # CONFIG_SCSI_MPT2SAS is not set
> # CONFIG_SCSI_MPT3SAS is not set
> CONFIG_SCSI_UFSHCD=m
> # CONFIG_SCSI_UFSHCD_PCI is not set
> CONFIG_SCSI_UFSHCD_PLATFORM=m
> CONFIG_SCSI_HPTIOP=y
> CONFIG_SCSI_BUSLOGIC=y
> CONFIG_SCSI_FLASHPOINT=y
> CONFIG_VMWARE_PVSCSI=m
> CONFIG_LIBFC=m
> CONFIG_LIBFCOE=m
> CONFIG_FCOE=m
> CONFIG_FCOE_FNIC=m
> CONFIG_SCSI_DMX3191D=m
> CONFIG_SCSI_EATA=y
> CONFIG_SCSI_EATA_TAGGED_QUEUE=y
> # CONFIG_SCSI_EATA_LINKED_COMMANDS is not set
> CONFIG_SCSI_EATA_MAX_TAGS=16
> # CONFIG_SCSI_FUTURE_DOMAIN is not set
> CONFIG_SCSI_GDTH=m
> # CONFIG_SCSI_ISCI is not set
> # CONFIG_SCSI_IPS is not set
> # CONFIG_SCSI_INITIO is not set
> CONFIG_SCSI_INIA100=m
> CONFIG_SCSI_STEX=m
> # CONFIG_SCSI_SYM53C8XX_2 is not set
> CONFIG_SCSI_IPR=m
> # CONFIG_SCSI_IPR_TRACE is not set
> CONFIG_SCSI_IPR_DUMP=y
> CONFIG_SCSI_QLOGIC_1280=m
> # CONFIG_SCSI_QLA_FC is not set
> CONFIG_SCSI_QLA_ISCSI=y
> # CONFIG_SCSI_LPFC is not set
> CONFIG_SCSI_DC395x=m
> # CONFIG_SCSI_DC390T is not set
> CONFIG_SCSI_NSP32=y
> # CONFIG_SCSI_DEBUG is not set
> CONFIG_SCSI_PMCRAID=m
> # CONFIG_SCSI_PM8001 is not set
> CONFIG_SCSI_SRP=m
> # CONFIG_SCSI_BFA_FC is not set
> # CONFIG_SCSI_VIRTIO is not set
> CONFIG_SCSI_CHELSIO_FCOE=y
> CONFIG_SCSI_LOWLEVEL_PCMCIA=y
> CONFIG_PCMCIA_AHA152X=m
> # CONFIG_PCMCIA_FDOMAIN is not set
> # CONFIG_PCMCIA_NINJA_SCSI is not set
> # CONFIG_PCMCIA_QLOGIC is not set
> # CONFIG_PCMCIA_SYM53C500 is not set
> CONFIG_SCSI_DH=y
> CONFIG_SCSI_DH_RDAC=m
> CONFIG_SCSI_DH_HP_SW=y
> CONFIG_SCSI_DH_EMC=m
> CONFIG_SCSI_DH_ALUA=y
> CONFIG_SCSI_OSD_INITIATOR=y
> # CONFIG_SCSI_OSD_ULD is not set
> CONFIG_SCSI_OSD_DPRINT_SENSE=1
> # CONFIG_SCSI_OSD_DEBUG is not set
> CONFIG_ATA=y
> # CONFIG_ATA_NONSTANDARD is not set
> CONFIG_ATA_VERBOSE_ERROR=y
> CONFIG_ATA_ACPI=y
> CONFIG_SATA_PMP=y
> 
> #
> # Controllers with non-SFF native interface
> #
> CONFIG_SATA_AHCI=m
> CONFIG_SATA_AHCI_PLATFORM=y
> CONFIG_SATA_INIC162X=m
> CONFIG_SATA_ACARD_AHCI=y
> # CONFIG_SATA_SIL24 is not set
> CONFIG_ATA_SFF=y
> 
> #
> # SFF controllers with custom DMA interface
> #
> CONFIG_PDC_ADMA=m
> CONFIG_SATA_QSTOR=y
> CONFIG_SATA_SX4=y
> CONFIG_ATA_BMDMA=y
> 
> #
> # SATA SFF controllers with BMDMA
> #
> CONFIG_ATA_PIIX=m
> CONFIG_SATA_MV=m
> CONFIG_SATA_NV=y
> CONFIG_SATA_PROMISE=y
> # CONFIG_SATA_SIL is not set
> CONFIG_SATA_SIS=m
> CONFIG_SATA_SVW=y
> CONFIG_SATA_ULI=y
> CONFIG_SATA_VIA=m
> CONFIG_SATA_VITESSE=y
> 
> #
> # PATA SFF controllers with BMDMA
> #
> CONFIG_PATA_ALI=y
> # CONFIG_PATA_AMD is not set
> CONFIG_PATA_ARTOP=y
> CONFIG_PATA_ATIIXP=y
> # CONFIG_PATA_ATP867X is not set
> # CONFIG_PATA_CMD64X is not set
> CONFIG_PATA_CS5520=m
> # CONFIG_PATA_CS5530 is not set
> # CONFIG_PATA_CS5535 is not set
> # CONFIG_PATA_CS5536 is not set
> CONFIG_PATA_CYPRESS=y
> CONFIG_PATA_EFAR=m
> CONFIG_PATA_HPT366=m
> # CONFIG_PATA_HPT37X is not set
> CONFIG_PATA_HPT3X2N=m
> CONFIG_PATA_HPT3X3=y
> CONFIG_PATA_HPT3X3_DMA=y
> # CONFIG_PATA_IT8213 is not set
> CONFIG_PATA_IT821X=y
> CONFIG_PATA_JMICRON=m
> # CONFIG_PATA_MARVELL is not set
> CONFIG_PATA_NETCELL=m
> CONFIG_PATA_NINJA32=m
> CONFIG_PATA_NS87415=y
> # CONFIG_PATA_OLDPIIX is not set
> CONFIG_PATA_OPTIDMA=y
> # CONFIG_PATA_PDC2027X is not set
> CONFIG_PATA_PDC_OLD=m
> # CONFIG_PATA_RADISYS is not set
> CONFIG_PATA_RDC=y
> # CONFIG_PATA_SC1200 is not set
> # CONFIG_PATA_SCH is not set
> # CONFIG_PATA_SERVERWORKS is not set
> CONFIG_PATA_SIL680=y
> CONFIG_PATA_SIS=m
> CONFIG_PATA_TOSHIBA=y
> # CONFIG_PATA_TRIFLEX is not set
> # CONFIG_PATA_VIA is not set
> # CONFIG_PATA_WINBOND is not set
> 
> #
> # PIO-only SFF controllers
> #
> CONFIG_PATA_CMD640_PCI=y
> CONFIG_PATA_MPIIX=m
> CONFIG_PATA_NS87410=m
> CONFIG_PATA_OPTI=y
> # CONFIG_PATA_PCMCIA is not set
> CONFIG_PATA_RZ1000=y
> 
> #
> # Generic fallback / legacy drivers
> #
> # CONFIG_PATA_ACPI is not set
> # CONFIG_ATA_GENERIC is not set
> # CONFIG_PATA_LEGACY is not set
> # CONFIG_MD is not set
> CONFIG_TARGET_CORE=m
> CONFIG_TCM_IBLOCK=m
> # CONFIG_TCM_FILEIO is not set
> # CONFIG_TCM_PSCSI is not set
> CONFIG_LOOPBACK_TARGET=m
> # CONFIG_TCM_FC is not set
> CONFIG_ISCSI_TARGET=m
> # CONFIG_FUSION is not set
> 
> #
> # IEEE 1394 (FireWire) support
> #
> # CONFIG_FIREWIRE is not set
> # CONFIG_FIREWIRE_NOSY is not set
> CONFIG_I2O=m
> # CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
> # CONFIG_I2O_EXT_ADAPTEC is not set
> CONFIG_I2O_CONFIG=m
> CONFIG_I2O_CONFIG_OLD_IOCTL=y
> CONFIG_I2O_BUS=m
> CONFIG_I2O_BLOCK=m
> CONFIG_I2O_SCSI=m
> # CONFIG_I2O_PROC is not set
> CONFIG_MACINTOSH_DRIVERS=y
> # CONFIG_MAC_EMUMOUSEBTN is not set
> CONFIG_NETDEVICES=y
> CONFIG_MII=y
> # CONFIG_NET_CORE is not set
> CONFIG_ARCNET=m
> CONFIG_ARCNET_1201=m
> # CONFIG_ARCNET_1051 is not set
> CONFIG_ARCNET_RAW=m
> CONFIG_ARCNET_CAP=m
> CONFIG_ARCNET_COM90xx=m
> # CONFIG_ARCNET_COM90xxIO is not set
> CONFIG_ARCNET_RIM_I=m
> CONFIG_ARCNET_COM20020=m
> CONFIG_ARCNET_COM20020_PCI=m
> CONFIG_ARCNET_COM20020_CS=m
> 
> #
> # CAIF transport drivers
> #
> # CONFIG_CAIF_TTY is not set
> CONFIG_CAIF_SPI_SLAVE=y
> # CONFIG_CAIF_SPI_SYNC is not set
> # CONFIG_CAIF_HSI is not set
> CONFIG_CAIF_VIRTIO=y
> CONFIG_VHOST_NET=m
> CONFIG_VHOST_SCSI=m
> CONFIG_VHOST_RING=y
> CONFIG_VHOST=m
> 
> #
> # Distributed Switch Architecture drivers
> #
> CONFIG_NET_DSA_MV88E6XXX=y
> # CONFIG_NET_DSA_MV88E6060 is not set
> CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
> CONFIG_NET_DSA_MV88E6131=y
> # CONFIG_NET_DSA_MV88E6123_61_65 is not set
> CONFIG_ETHERNET=y
> CONFIG_MDIO=y
> # CONFIG_NET_VENDOR_3COM is not set
> # CONFIG_NET_VENDOR_ADAPTEC is not set
> # CONFIG_NET_VENDOR_ALTEON is not set
> CONFIG_ALTERA_TSE=y
> CONFIG_NET_VENDOR_AMD=y
> CONFIG_AMD8111_ETH=m
> CONFIG_PCNET32=y
> CONFIG_PCMCIA_NMCLAN=m
> CONFIG_AMD_XGBE=y
> # CONFIG_NET_VENDOR_ARC is not set
> # CONFIG_NET_VENDOR_ATHEROS is not set
> CONFIG_NET_VENDOR_BROADCOM=y
> CONFIG_B44=y
> CONFIG_B44_PCI_AUTOSELECT=y
> CONFIG_B44_PCICORE_AUTOSELECT=y
> CONFIG_B44_PCI=y
> CONFIG_BCMGENET=m
> CONFIG_BNX2=m
> CONFIG_CNIC=m
> CONFIG_TIGON3=y
> CONFIG_BNX2X=y
> CONFIG_BNX2X_SRIOV=y
> # CONFIG_SYSTEMPORT is not set
> CONFIG_NET_VENDOR_BROCADE=y
> # CONFIG_BNA is not set
> CONFIG_NET_CALXEDA_XGMAC=y
> CONFIG_NET_VENDOR_CHELSIO=y
> CONFIG_CHELSIO_T1=y
> # CONFIG_CHELSIO_T1_1G is not set
> # CONFIG_CHELSIO_T3 is not set
> CONFIG_CHELSIO_T4=y
> # CONFIG_CHELSIO_T4VF is not set
> # CONFIG_NET_VENDOR_CISCO is not set
> # CONFIG_CX_ECAT is not set
> CONFIG_DNET=y
> CONFIG_NET_VENDOR_DEC=y
> # CONFIG_NET_TULIP is not set
> # CONFIG_NET_VENDOR_DLINK is not set
> CONFIG_NET_VENDOR_EMULEX=y
> CONFIG_BE2NET=y
> # CONFIG_NET_VENDOR_EXAR is not set
> # CONFIG_NET_VENDOR_FUJITSU is not set
> CONFIG_NET_VENDOR_HP=y
> CONFIG_HP100=m
> # CONFIG_NET_VENDOR_INTEL is not set
> CONFIG_IP1000=m
> # CONFIG_JME is not set
> # CONFIG_NET_VENDOR_MARVELL is not set
> CONFIG_NET_VENDOR_MELLANOX=y
> # CONFIG_MLX4_EN is not set
> CONFIG_MLX4_CORE=m
> CONFIG_MLX4_DEBUG=y
> CONFIG_MLX5_CORE=m
> # CONFIG_NET_VENDOR_MICREL is not set
> CONFIG_NET_VENDOR_MYRI=y
> # CONFIG_MYRI10GE is not set
> CONFIG_FEALNX=m
> # CONFIG_NET_VENDOR_NATSEMI is not set
> # CONFIG_NET_VENDOR_NVIDIA is not set
> # CONFIG_NET_VENDOR_OKI is not set
> CONFIG_ETHOC=y
> CONFIG_NET_PACKET_ENGINE=y
> CONFIG_HAMACHI=m
> CONFIG_YELLOWFIN=m
> CONFIG_NET_VENDOR_QLOGIC=y
> CONFIG_QLA3XXX=y
> CONFIG_QLCNIC=m
> CONFIG_QLCNIC_SRIOV=y
> CONFIG_QLCNIC_DCB=y
> # CONFIG_QLCNIC_HWMON is not set
> # CONFIG_QLGE is not set
> CONFIG_NETXEN_NIC=y
> # CONFIG_NET_VENDOR_REALTEK is not set
> # CONFIG_SH_ETH is not set
> # CONFIG_NET_VENDOR_RDC is not set
> CONFIG_NET_VENDOR_SAMSUNG=y
> CONFIG_SXGBE_ETH=m
> CONFIG_NET_VENDOR_SEEQ=y
> # CONFIG_NET_VENDOR_SILAN is not set
> CONFIG_NET_VENDOR_SIS=y
> # CONFIG_SIS900 is not set
> CONFIG_SIS190=m
> # CONFIG_SFC is not set
> # CONFIG_NET_VENDOR_SMSC is not set
> CONFIG_NET_VENDOR_STMICRO=y
> # CONFIG_STMMAC_ETH is not set
> # CONFIG_NET_VENDOR_SUN is not set
> # CONFIG_NET_VENDOR_TEHUTI is not set
> # CONFIG_NET_VENDOR_TI is not set
> # CONFIG_NET_VENDOR_VIA is not set
> CONFIG_NET_VENDOR_WIZNET=y
> CONFIG_WIZNET_W5100=m
> CONFIG_WIZNET_W5300=m
> # CONFIG_WIZNET_BUS_DIRECT is not set
> # CONFIG_WIZNET_BUS_INDIRECT is not set
> CONFIG_WIZNET_BUS_ANY=y
> CONFIG_NET_VENDOR_XIRCOM=y
> CONFIG_PCMCIA_XIRC2PS=m
> CONFIG_FDDI=m
> CONFIG_DEFXX=m
> # CONFIG_DEFXX_MMIO is not set
> CONFIG_SKFP=m
> CONFIG_HIPPI=y
> CONFIG_ROADRUNNER=m
> CONFIG_ROADRUNNER_LARGE_RINGS=y
> # CONFIG_NET_SB1000 is not set
> CONFIG_PHYLIB=y
> 
> #
> # MII PHY device drivers
> #
> CONFIG_AT803X_PHY=y
> CONFIG_AMD_PHY=m
> CONFIG_AMD_XGBE_PHY=y
> CONFIG_MARVELL_PHY=y
> CONFIG_DAVICOM_PHY=y
> CONFIG_QSEMI_PHY=y
> CONFIG_LXT_PHY=y
> CONFIG_CICADA_PHY=m
> CONFIG_VITESSE_PHY=m
> CONFIG_SMSC_PHY=y
> # CONFIG_BROADCOM_PHY is not set
> CONFIG_BCM7XXX_PHY=m
> # CONFIG_BCM87XX_PHY is not set
> # CONFIG_ICPLUS_PHY is not set
> CONFIG_REALTEK_PHY=y
> # CONFIG_NATIONAL_PHY is not set
> CONFIG_STE10XP=y
> CONFIG_LSI_ET1011C_PHY=m
> # CONFIG_MICREL_PHY is not set
> CONFIG_FIXED_PHY=y
> CONFIG_MDIO_BITBANG=y
> # CONFIG_MDIO_GPIO is not set
> CONFIG_MDIO_BUS_MUX=y
> # CONFIG_MDIO_BUS_MUX_GPIO is not set
> CONFIG_MDIO_BUS_MUX_MMIOREG=y
> CONFIG_PPP=m
> CONFIG_PPP_BSDCOMP=m
> CONFIG_PPP_DEFLATE=m
> # CONFIG_PPP_FILTER is not set
> CONFIG_PPP_MPPE=m
> CONFIG_PPP_MULTILINK=y
> # CONFIG_PPPOE is not set
> CONFIG_PPTP=m
> CONFIG_PPP_ASYNC=m
> CONFIG_PPP_SYNC_TTY=m
> # CONFIG_SLIP is not set
> CONFIG_SLHC=y
> CONFIG_WLAN=y
> CONFIG_PCMCIA_RAYCS=m
> CONFIG_AIRO=m
> CONFIG_ATMEL=y
> CONFIG_PCI_ATMEL=y
> # CONFIG_PCMCIA_ATMEL is not set
> CONFIG_AIRO_CS=m
> # CONFIG_PCMCIA_WL3501 is not set
> # CONFIG_PRISM54 is not set
> # CONFIG_ATH_CARDS is not set
> CONFIG_BRCMUTIL=m
> CONFIG_BRCMFMAC=m
> # CONFIG_BRCM_TRACING is not set
> # CONFIG_BRCMDBG is not set
> # CONFIG_HOSTAP is not set
> CONFIG_IPW2100=m
> CONFIG_IPW2100_MONITOR=y
> CONFIG_IPW2100_DEBUG=y
> CONFIG_LIBIPW=m
> # CONFIG_LIBIPW_DEBUG is not set
> # CONFIG_LIBERTAS is not set
> CONFIG_WL_TI=y
> CONFIG_MWIFIEX=m
> # CONFIG_MWIFIEX_PCIE is not set
> 
> #
> # Enable WiMAX (Networking options) to see the WiMAX drivers
> #
> # CONFIG_WAN is not set
> CONFIG_IEEE802154_DRIVERS=y
> CONFIG_IEEE802154_FAKEHARD=y
> CONFIG_IEEE802154_FAKELB=m
> # CONFIG_VMXNET3 is not set
> CONFIG_ISDN=y
> CONFIG_ISDN_I4L=y
> CONFIG_ISDN_PPP=y
> # CONFIG_ISDN_PPP_VJ is not set
> # CONFIG_ISDN_MPP is not set
> # CONFIG_IPPP_FILTER is not set
> # CONFIG_ISDN_PPP_BSDCOMP is not set
> # CONFIG_ISDN_AUDIO is not set
> 
> #
> # ISDN feature submodules
> #
> # CONFIG_ISDN_DIVERSION is not set
> 
> #
> # ISDN4Linux hardware drivers
> #
> 
> #
> # Passive cards
> #
> CONFIG_ISDN_DRV_HISAX=y
> 
> #
> # D-channel protocol features
> #
> # CONFIG_HISAX_EURO is not set
> CONFIG_HISAX_1TR6=y
> CONFIG_HISAX_NI1=y
> CONFIG_HISAX_MAX_CARDS=8
> 
> #
> # HiSax supported cards
> #
> CONFIG_HISAX_16_3=y
> CONFIG_HISAX_TELESPCI=y
> CONFIG_HISAX_S0BOX=y
> CONFIG_HISAX_FRITZPCI=y
> # CONFIG_HISAX_AVM_A1_PCMCIA is not set
> # CONFIG_HISAX_ELSA is not set
> CONFIG_HISAX_DIEHLDIVA=y
> # CONFIG_HISAX_SEDLBAUER is not set
> CONFIG_HISAX_NETJET=y
> # CONFIG_HISAX_NETJET_U is not set
> # CONFIG_HISAX_NICCY is not set
> # CONFIG_HISAX_BKM_A4T is not set
> # CONFIG_HISAX_SCT_QUADRO is not set
> CONFIG_HISAX_GAZEL=y
> # CONFIG_HISAX_HFC_PCI is not set
> CONFIG_HISAX_W6692=y
> # CONFIG_HISAX_HFC_SX is not set
> # CONFIG_HISAX_ENTERNOW_PCI is not set
> CONFIG_HISAX_DEBUG=y
> 
> #
> # HiSax PCMCIA card service modules
> #
> CONFIG_HISAX_AVM_A1_CS=m
> CONFIG_HISAX_TELES_CS=m
> 
> #
> # HiSax sub driver modules
> #
> CONFIG_HISAX_HFC4S8S=m
> CONFIG_HISAX_FRITZ_PCIPNP=m
> 
> #
> # Active cards
> #
> # CONFIG_ISDN_CAPI is not set
> CONFIG_ISDN_DRV_GIGASET=m
> CONFIG_GIGASET_I4L=y
> # CONFIG_GIGASET_DUMMYLL is not set
> # CONFIG_GIGASET_M101 is not set
> CONFIG_GIGASET_DEBUG=y
> CONFIG_HYSDN=m
> # CONFIG_MISDN is not set
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> CONFIG_INPUT_FF_MEMLESS=y
> CONFIG_INPUT_POLLDEV=y
> CONFIG_INPUT_SPARSEKMAP=y
> CONFIG_INPUT_MATRIXKMAP=m
> 
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=m
> # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> # CONFIG_INPUT_JOYDEV is not set
> # CONFIG_INPUT_EVDEV is not set
> CONFIG_INPUT_EVBUG=y
> 
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> # CONFIG_KEYBOARD_ADP5588 is not set
> CONFIG_KEYBOARD_ADP5589=m
> CONFIG_KEYBOARD_ATKBD=y
> CONFIG_KEYBOARD_QT1070=m
> CONFIG_KEYBOARD_QT2160=m
> # CONFIG_KEYBOARD_LKKBD is not set
> CONFIG_KEYBOARD_GPIO=m
> CONFIG_KEYBOARD_GPIO_POLLED=y
> CONFIG_KEYBOARD_TCA6416=m
> CONFIG_KEYBOARD_TCA8418=m
> # CONFIG_KEYBOARD_MATRIX is not set
> CONFIG_KEYBOARD_LM8323=m
> # CONFIG_KEYBOARD_LM8333 is not set
> CONFIG_KEYBOARD_MAX7359=m
> CONFIG_KEYBOARD_MCS=m
> # CONFIG_KEYBOARD_MPR121 is not set
> CONFIG_KEYBOARD_NEWTON=y
> CONFIG_KEYBOARD_OPENCORES=m
> CONFIG_KEYBOARD_STOWAWAY=y
> CONFIG_KEYBOARD_SUNKBD=y
> # CONFIG_KEYBOARD_OMAP4 is not set
> # CONFIG_KEYBOARD_XTKBD is not set
> CONFIG_KEYBOARD_CROS_EC=m
> # CONFIG_INPUT_MOUSE is not set
> # CONFIG_INPUT_JOYSTICK is not set
> CONFIG_INPUT_TABLET=y
> # CONFIG_TABLET_USB_ACECAD is not set
> # CONFIG_TABLET_USB_AIPTEK is not set
> # CONFIG_TABLET_USB_HANWANG is not set
> # CONFIG_TABLET_USB_KBTAB is not set
> # CONFIG_TABLET_USB_WACOM is not set
> CONFIG_INPUT_TOUCHSCREEN=y
> CONFIG_OF_TOUCHSCREEN=y
> # CONFIG_TOUCHSCREEN_AD7879 is not set
> CONFIG_TOUCHSCREEN_ATMEL_MXT=m
> CONFIG_TOUCHSCREEN_AUO_PIXCIR=m
> # CONFIG_TOUCHSCREEN_BU21013 is not set
> # CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
> CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
> # CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
> CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
> CONFIG_TOUCHSCREEN_CYTTSP4_I2C=m
> CONFIG_TOUCHSCREEN_DYNAPRO=m
> CONFIG_TOUCHSCREEN_HAMPSHIRE=m
> CONFIG_TOUCHSCREEN_EETI=m
> CONFIG_TOUCHSCREEN_EGALAX=m
> CONFIG_TOUCHSCREEN_FUJITSU=y
> # CONFIG_TOUCHSCREEN_ILI210X is not set
> CONFIG_TOUCHSCREEN_GUNZE=y
> CONFIG_TOUCHSCREEN_ELO=m
> CONFIG_TOUCHSCREEN_WACOM_W8001=m
> CONFIG_TOUCHSCREEN_WACOM_I2C=m
> CONFIG_TOUCHSCREEN_MAX11801=m
> # CONFIG_TOUCHSCREEN_MCS5000 is not set
> # CONFIG_TOUCHSCREEN_MMS114 is not set
> CONFIG_TOUCHSCREEN_MTOUCH=m
> # CONFIG_TOUCHSCREEN_INEXIO is not set
> # CONFIG_TOUCHSCREEN_MK712 is not set
> CONFIG_TOUCHSCREEN_PENMOUNT=m
> CONFIG_TOUCHSCREEN_EDT_FT5X06=m
> CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
> CONFIG_TOUCHSCREEN_TOUCHWIN=y
> CONFIG_TOUCHSCREEN_TI_AM335X_TSC=m
> CONFIG_TOUCHSCREEN_PIXCIR=m
> # CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
> CONFIG_TOUCHSCREEN_TOUCHIT213=m
> CONFIG_TOUCHSCREEN_TSC_SERIO=m
> CONFIG_TOUCHSCREEN_TSC2007=m
> CONFIG_TOUCHSCREEN_ST1232=m
> CONFIG_TOUCHSCREEN_TPS6507X=m
> CONFIG_TOUCHSCREEN_ZFORCE=m
> CONFIG_INPUT_MISC=y
> CONFIG_INPUT_AD714X=m
> CONFIG_INPUT_AD714X_I2C=m
> # CONFIG_INPUT_BMA150 is not set
> CONFIG_INPUT_PCSPKR=m
> CONFIG_INPUT_MMA8450=m
> CONFIG_INPUT_MPU3050=m
> CONFIG_INPUT_APANEL=m
> # CONFIG_INPUT_GP2A is not set
> # CONFIG_INPUT_GPIO_BEEPER is not set
> CONFIG_INPUT_GPIO_TILT_POLLED=y
> # CONFIG_INPUT_WISTRON_BTNS is not set
> # CONFIG_INPUT_ATLAS_BTNS is not set
> # CONFIG_INPUT_ATI_REMOTE2 is not set
> # CONFIG_INPUT_KEYSPAN_REMOTE is not set
> CONFIG_INPUT_KXTJ9=m
> CONFIG_INPUT_KXTJ9_POLLED_MODE=y
> # CONFIG_INPUT_POWERMATE is not set
> # CONFIG_INPUT_YEALINK is not set
> # CONFIG_INPUT_CM109 is not set
> # CONFIG_INPUT_UINPUT is not set
> CONFIG_INPUT_PCF50633_PMU=m
> CONFIG_INPUT_PCF8574=m
> CONFIG_INPUT_PWM_BEEPER=y
> CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
> # CONFIG_INPUT_ADXL34X is not set
> CONFIG_INPUT_CMA3000=m
> # CONFIG_INPUT_CMA3000_I2C is not set
> CONFIG_INPUT_IDEAPAD_SLIDEBAR=m
> CONFIG_INPUT_SOC_BUTTON_ARRAY=m
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
> CONFIG_SERIO_I8042=y
> CONFIG_SERIO_SERPORT=m
> CONFIG_SERIO_CT82C710=m
> CONFIG_SERIO_PCIPS2=m
> CONFIG_SERIO_LIBPS2=y
> CONFIG_SERIO_RAW=m
> CONFIG_SERIO_ALTERA_PS2=m
> CONFIG_SERIO_PS2MULT=m
> # CONFIG_SERIO_ARC_PS2 is not set
> CONFIG_SERIO_APBPS2=y
> CONFIG_SERIO_OLPC_APSP=m
> # CONFIG_GAMEPORT is not set
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
> CONFIG_VT_HW_CONSOLE_BINDING=y
> CONFIG_UNIX98_PTYS=y
> CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
> CONFIG_LEGACY_PTYS=y
> CONFIG_LEGACY_PTY_COUNT=256
> # CONFIG_SERIAL_NONSTANDARD is not set
> CONFIG_NOZOMI=m
> CONFIG_N_GSM=m
> # CONFIG_TRACE_SINK is not set
> # CONFIG_DEVKMEM is not set
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_EARLYCON=y
> CONFIG_SERIAL_8250=y
> # CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_CS=m
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> # CONFIG_SERIAL_8250_EXTENDED is not set
> # CONFIG_SERIAL_8250_DW is not set
> 
> #
> # Non-8250 serial port support
> #
> CONFIG_SERIAL_MFD_HSU=y
> # CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
> CONFIG_SERIAL_UARTLITE=m
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> CONFIG_SERIAL_JSM=m
> CONFIG_SERIAL_OF_PLATFORM=m
> CONFIG_SERIAL_SCCNXP=m
> # CONFIG_SERIAL_SC16IS7XX is not set
> # CONFIG_SERIAL_TIMBERDALE is not set
> CONFIG_SERIAL_ALTERA_JTAGUART=y
> CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
> CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS=y
> # CONFIG_SERIAL_ALTERA_UART is not set
> CONFIG_SERIAL_PCH_UART=y
> # CONFIG_SERIAL_PCH_UART_CONSOLE is not set
> CONFIG_SERIAL_XILINX_PS_UART=y
> CONFIG_SERIAL_XILINX_PS_UART_CONSOLE=y
> # CONFIG_SERIAL_ARC is not set
> # CONFIG_SERIAL_RP2 is not set
> CONFIG_SERIAL_FSL_LPUART=m
> CONFIG_HVC_DRIVER=y
> CONFIG_VIRTIO_CONSOLE=y
> CONFIG_IPMI_HANDLER=m
> CONFIG_IPMI_PANIC_EVENT=y
> # CONFIG_IPMI_PANIC_STRING is not set
> # CONFIG_IPMI_DEVICE_INTERFACE is not set
> CONFIG_IPMI_SI=m
> CONFIG_IPMI_SI_PROBE_DEFAULTS=y
> # CONFIG_IPMI_WATCHDOG is not set
> CONFIG_IPMI_POWEROFF=m
> CONFIG_HW_RANDOM=m
> # CONFIG_HW_RANDOM_TIMERIOMEM is not set
> CONFIG_HW_RANDOM_INTEL=m
> # CONFIG_HW_RANDOM_AMD is not set
> CONFIG_HW_RANDOM_GEODE=m
> CONFIG_HW_RANDOM_VIA=m
> CONFIG_HW_RANDOM_VIRTIO=m
> CONFIG_HW_RANDOM_TPM=m
> CONFIG_NVRAM=y
> CONFIG_R3964=m
> CONFIG_APPLICOM=m
> # CONFIG_SONYPI is not set
> 
> #
> # PCMCIA character devices
> #
> CONFIG_SYNCLINK_CS=m
> # CONFIG_CARDMAN_4000 is not set
> CONFIG_CARDMAN_4040=m
> CONFIG_IPWIRELESS=m
> CONFIG_MWAVE=m
> # CONFIG_PC8736x_GPIO is not set
> # CONFIG_NSC_GPIO is not set
> # CONFIG_RAW_DRIVER is not set
> # CONFIG_HPET is not set
> # CONFIG_HANGCHECK_TIMER is not set
> CONFIG_TCG_TPM=y
> CONFIG_TCG_TIS=y
> # CONFIG_TCG_TIS_I2C_ATMEL is not set
> CONFIG_TCG_TIS_I2C_INFINEON=m
> CONFIG_TCG_TIS_I2C_NUVOTON=m
> CONFIG_TCG_NSC=m
> CONFIG_TCG_ATMEL=m
> # CONFIG_TCG_INFINEON is not set
> # CONFIG_TCG_ST33_I2C is not set
> CONFIG_TELCLOCK=y
> CONFIG_DEVPORT=y
> CONFIG_I2C=m
> CONFIG_I2C_BOARDINFO=y
> # CONFIG_I2C_COMPAT is not set
> CONFIG_I2C_CHARDEV=m
> CONFIG_I2C_MUX=m
> 
> #
> # Multiplexer I2C Chip support
> #
> CONFIG_I2C_ARB_GPIO_CHALLENGE=m
> CONFIG_I2C_MUX_GPIO=m
> CONFIG_I2C_MUX_PCA9541=m
> # CONFIG_I2C_MUX_PCA954x is not set
> # CONFIG_I2C_HELPER_AUTO is not set
> CONFIG_I2C_SMBUS=m
> 
> #
> # I2C Algorithms
> #
> CONFIG_I2C_ALGOBIT=m
> CONFIG_I2C_ALGOPCF=m
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
> CONFIG_I2C_ALI1563=m
> CONFIG_I2C_ALI15X3=m
> CONFIG_I2C_AMD756=m
> # CONFIG_I2C_AMD756_S4882 is not set
> # CONFIG_I2C_AMD8111 is not set
> CONFIG_I2C_I801=m
> CONFIG_I2C_ISCH=m
> CONFIG_I2C_ISMT=m
> CONFIG_I2C_PIIX4=m
> CONFIG_I2C_NFORCE2=m
> CONFIG_I2C_NFORCE2_S4985=m
> CONFIG_I2C_SIS5595=m
> # CONFIG_I2C_SIS630 is not set
> CONFIG_I2C_SIS96X=m
> CONFIG_I2C_VIA=m
> CONFIG_I2C_VIAPRO=m
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
> CONFIG_I2C_DESIGNWARE_CORE=m
> # CONFIG_I2C_DESIGNWARE_PLATFORM is not set
> CONFIG_I2C_DESIGNWARE_PCI=m
> CONFIG_I2C_EG20T=m
> CONFIG_I2C_GPIO=m
> CONFIG_I2C_OCORES=m
> # CONFIG_I2C_PCA_PLATFORM is not set
> # CONFIG_I2C_PXA is not set
> # CONFIG_I2C_PXA_PCI is not set
> # CONFIG_I2C_SIMTEC is not set
> # CONFIG_I2C_XILINX is not set
> 
> #
> # External I2C/SMBus adapter drivers
> #
> CONFIG_I2C_PARPORT_LIGHT=m
> CONFIG_I2C_TAOS_EVM=m
> 
> #
> # Other I2C/SMBus bus drivers
> #
> CONFIG_I2C_CROS_EC_TUNNEL=m
> # CONFIG_SCx200_ACB is not set
> # CONFIG_I2C_STUB is not set
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> # CONFIG_SPI is not set
> # CONFIG_SPMI is not set
> CONFIG_HSI=m
> CONFIG_HSI_BOARDINFO=y
> 
> #
> # HSI controllers
> #
> 
> #
> # HSI clients
> #
> CONFIG_HSI_CHAR=m
> 
> #
> # PPS support
> #
> CONFIG_PPS=y
> # CONFIG_PPS_DEBUG is not set
> 
> #
> # PPS clients support
> #
> # CONFIG_PPS_CLIENT_KTIMER is not set
> # CONFIG_PPS_CLIENT_LDISC is not set
> # CONFIG_PPS_CLIENT_GPIO is not set
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
> CONFIG_GPIOLIB=y
> CONFIG_GPIO_DEVRES=y
> CONFIG_OF_GPIO=y
> CONFIG_GPIO_ACPI=y
> CONFIG_GPIOLIB_IRQCHIP=y
> CONFIG_DEBUG_GPIO=y
> CONFIG_GPIO_SYSFS=y
> CONFIG_GPIO_GENERIC=y
> CONFIG_GPIO_MAX730X=m
> 
> #
> # Memory mapped GPIO drivers:
> #
> # CONFIG_GPIO_GENERIC_PLATFORM is not set
> # CONFIG_GPIO_DWAPB is not set
> CONFIG_GPIO_IT8761E=y
> # CONFIG_GPIO_F7188X is not set
> CONFIG_GPIO_SCH311X=y
> # CONFIG_GPIO_SYSCON is not set
> CONFIG_GPIO_SCH=m
> CONFIG_GPIO_ICH=m
> # CONFIG_GPIO_VX855 is not set
> # CONFIG_GPIO_LYNXPOINT is not set
> CONFIG_GPIO_GRGPIO=y
> 
> #
> # I2C GPIO expanders:
> #
> CONFIG_GPIO_ARIZONA=y
> CONFIG_GPIO_LP3943=m
> CONFIG_GPIO_MAX7300=m
> # CONFIG_GPIO_MAX732X is not set
> # CONFIG_GPIO_PCA953X is not set
> CONFIG_GPIO_PCF857X=m
> CONFIG_GPIO_ADP5588=m
> # CONFIG_GPIO_ADNP is not set
> 
> #
> # PCI GPIO expanders:
> #
> # CONFIG_GPIO_CS5535 is not set
> # CONFIG_GPIO_BT8XX is not set
> # CONFIG_GPIO_AMD8111 is not set
> CONFIG_GPIO_INTEL_MID=y
> CONFIG_GPIO_PCH=y
> CONFIG_GPIO_ML_IOH=y
> CONFIG_GPIO_SODAVILLE=y
> CONFIG_GPIO_TIMBERDALE=y
> # CONFIG_GPIO_RDC321X is not set
> 
> #
> # SPI GPIO expanders:
> #
> CONFIG_GPIO_MCP23S08=m
> 
> #
> # AC97 GPIO expanders:
> #
> 
> #
> # LPC GPIO expanders:
> #
> 
> #
> # MODULbus GPIO expanders:
> #
> # CONFIG_GPIO_JANZ_TTL is not set
> CONFIG_GPIO_BCM_KONA=y
> 
> #
> # USB GPIO expanders:
> #
> CONFIG_W1=m
> # CONFIG_W1_CON is not set
> 
> #
> # 1-wire Bus Masters
> #
> # CONFIG_W1_MASTER_MATROX is not set
> CONFIG_W1_MASTER_DS2482=m
> CONFIG_W1_MASTER_DS1WM=m
> CONFIG_W1_MASTER_GPIO=m
> 
> #
> # 1-wire Slaves
> #
> # CONFIG_W1_SLAVE_THERM is not set
> CONFIG_W1_SLAVE_SMEM=m
> CONFIG_W1_SLAVE_DS2408=m
> CONFIG_W1_SLAVE_DS2408_READBACK=y
> CONFIG_W1_SLAVE_DS2413=m
> CONFIG_W1_SLAVE_DS2423=m
> # CONFIG_W1_SLAVE_DS2431 is not set
> # CONFIG_W1_SLAVE_DS2433 is not set
> # CONFIG_W1_SLAVE_DS2760 is not set
> CONFIG_W1_SLAVE_DS2780=m
> CONFIG_W1_SLAVE_DS2781=m
> CONFIG_W1_SLAVE_DS28E04=m
> CONFIG_W1_SLAVE_BQ27000=m
> CONFIG_POWER_SUPPLY=y
> CONFIG_POWER_SUPPLY_DEBUG=y
> CONFIG_PDA_POWER=m
> CONFIG_TEST_POWER=y
> CONFIG_BATTERY_DS2780=m
> CONFIG_BATTERY_DS2781=m
> CONFIG_BATTERY_DS2782=m
> CONFIG_BATTERY_OLPC=m
> # CONFIG_BATTERY_SBS is not set
> # CONFIG_BATTERY_BQ27x00 is not set
> # CONFIG_BATTERY_MAX17040 is not set
> CONFIG_BATTERY_MAX17042=m
> # CONFIG_CHARGER_PCF50633 is not set
> # CONFIG_CHARGER_MAX8903 is not set
> CONFIG_CHARGER_LP8727=m
> # CONFIG_CHARGER_GPIO is not set
> CONFIG_CHARGER_MANAGER=y
> CONFIG_CHARGER_BQ2415X=m
> # CONFIG_CHARGER_BQ24190 is not set
> CONFIG_CHARGER_BQ24735=m
> CONFIG_CHARGER_SMB347=m
> CONFIG_POWER_RESET=y
> CONFIG_POWER_RESET_GPIO=y
> CONFIG_POWER_AVS=y
> CONFIG_HWMON=y
> CONFIG_HWMON_VID=y
> # CONFIG_HWMON_DEBUG_CHIP is not set
> 
> #
> # Native drivers
> #
> # CONFIG_SENSORS_ABITUGURU is not set
> CONFIG_SENSORS_ABITUGURU3=y
> CONFIG_SENSORS_AD7414=m
> CONFIG_SENSORS_AD7418=m
> # CONFIG_SENSORS_ADM1021 is not set
> CONFIG_SENSORS_ADM1025=m
> CONFIG_SENSORS_ADM1026=m
> CONFIG_SENSORS_ADM1029=m
> CONFIG_SENSORS_ADM1031=m
> # CONFIG_SENSORS_ADM9240 is not set
> CONFIG_SENSORS_ADT7X10=m
> CONFIG_SENSORS_ADT7410=m
> CONFIG_SENSORS_ADT7411=m
> CONFIG_SENSORS_ADT7462=m
> # CONFIG_SENSORS_ADT7470 is not set
> CONFIG_SENSORS_ADT7475=m
> CONFIG_SENSORS_ASC7621=m
> CONFIG_SENSORS_K8TEMP=m
> CONFIG_SENSORS_K10TEMP=y
> # CONFIG_SENSORS_FAM15H_POWER is not set
> # CONFIG_SENSORS_APPLESMC is not set
> CONFIG_SENSORS_ASB100=m
> # CONFIG_SENSORS_ATXP1 is not set
> CONFIG_SENSORS_DS620=m
> CONFIG_SENSORS_DS1621=m
> CONFIG_SENSORS_I5K_AMB=y
> # CONFIG_SENSORS_F71805F is not set
> CONFIG_SENSORS_F71882FG=m
> CONFIG_SENSORS_F75375S=m
> CONFIG_SENSORS_FSCHMD=m
> # CONFIG_SENSORS_GL518SM is not set
> CONFIG_SENSORS_GL520SM=m
> CONFIG_SENSORS_G760A=m
> # CONFIG_SENSORS_G762 is not set
> CONFIG_SENSORS_GPIO_FAN=y
> CONFIG_SENSORS_HIH6130=m
> CONFIG_SENSORS_IBMAEM=m
> CONFIG_SENSORS_IBMPEX=m
> CONFIG_SENSORS_CORETEMP=y
> # CONFIG_SENSORS_IT87 is not set
> CONFIG_SENSORS_JC42=m
> CONFIG_SENSORS_LINEAGE=m
> CONFIG_SENSORS_LTC2945=m
> CONFIG_SENSORS_LTC4151=m
> CONFIG_SENSORS_LTC4215=m
> # CONFIG_SENSORS_LTC4222 is not set
> CONFIG_SENSORS_LTC4245=m
> CONFIG_SENSORS_LTC4260=m
> CONFIG_SENSORS_LTC4261=m
> CONFIG_SENSORS_MAX16065=m
> CONFIG_SENSORS_MAX1619=m
> # CONFIG_SENSORS_MAX1668 is not set
> # CONFIG_SENSORS_MAX197 is not set
> # CONFIG_SENSORS_MAX6639 is not set
> CONFIG_SENSORS_MAX6642=m
> CONFIG_SENSORS_MAX6650=m
> # CONFIG_SENSORS_MAX6697 is not set
> CONFIG_SENSORS_HTU21=m
> CONFIG_SENSORS_MCP3021=m
> # CONFIG_SENSORS_LM63 is not set
> # CONFIG_SENSORS_LM73 is not set
> CONFIG_SENSORS_LM75=m
> # CONFIG_SENSORS_LM77 is not set
> # CONFIG_SENSORS_LM78 is not set
> CONFIG_SENSORS_LM80=m
> CONFIG_SENSORS_LM83=m
> # CONFIG_SENSORS_LM85 is not set
> CONFIG_SENSORS_LM87=m
> CONFIG_SENSORS_LM90=m
> # CONFIG_SENSORS_LM92 is not set
> CONFIG_SENSORS_LM93=m
> # CONFIG_SENSORS_LM95234 is not set
> CONFIG_SENSORS_LM95241=m
> CONFIG_SENSORS_LM95245=m
> # CONFIG_SENSORS_PC87360 is not set
> CONFIG_SENSORS_PC87427=y
> # CONFIG_SENSORS_NTC_THERMISTOR is not set
> CONFIG_SENSORS_NCT6683=y
> # CONFIG_SENSORS_NCT6775 is not set
> # CONFIG_SENSORS_PCF8591 is not set
> # CONFIG_PMBUS is not set
> CONFIG_SENSORS_SHT15=y
> CONFIG_SENSORS_SHT21=m
> CONFIG_SENSORS_SHTC1=m
> CONFIG_SENSORS_SIS5595=m
> # CONFIG_SENSORS_DME1737 is not set
> # CONFIG_SENSORS_EMC1403 is not set
> # CONFIG_SENSORS_EMC2103 is not set
> # CONFIG_SENSORS_EMC6W201 is not set
> # CONFIG_SENSORS_SMSC47M1 is not set
> # CONFIG_SENSORS_SMSC47M192 is not set
> # CONFIG_SENSORS_SMSC47B397 is not set
> CONFIG_SENSORS_SCH56XX_COMMON=y
> CONFIG_SENSORS_SCH5627=y
> CONFIG_SENSORS_SCH5636=y
> CONFIG_SENSORS_SMM665=m
> CONFIG_SENSORS_ADC128D818=m
> # CONFIG_SENSORS_ADS1015 is not set
> # CONFIG_SENSORS_ADS7828 is not set
> CONFIG_SENSORS_AMC6821=m
> # CONFIG_SENSORS_INA209 is not set
> # CONFIG_SENSORS_INA2XX is not set
> CONFIG_SENSORS_THMC50=m
> # CONFIG_SENSORS_TMP102 is not set
> CONFIG_SENSORS_TMP401=m
> CONFIG_SENSORS_TMP421=m
> CONFIG_SENSORS_VIA_CPUTEMP=y
> # CONFIG_SENSORS_VIA686A is not set
> # CONFIG_SENSORS_VT1211 is not set
> CONFIG_SENSORS_VT8231=m
> CONFIG_SENSORS_W83781D=m
> CONFIG_SENSORS_W83791D=m
> # CONFIG_SENSORS_W83792D is not set
> CONFIG_SENSORS_W83793=m
> # CONFIG_SENSORS_W83795 is not set
> CONFIG_SENSORS_W83L785TS=m
> CONFIG_SENSORS_W83L786NG=m
> CONFIG_SENSORS_W83627HF=m
> # CONFIG_SENSORS_W83627EHF is not set
> 
> #
> # ACPI drivers
> #
> # CONFIG_SENSORS_ACPI_POWER is not set
> # CONFIG_SENSORS_ATK0110 is not set
> CONFIG_THERMAL=y
> CONFIG_THERMAL_HWMON=y
> CONFIG_THERMAL_OF=y
> CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
> # CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
> # CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
> # CONFIG_THERMAL_GOV_FAIR_SHARE is not set
> CONFIG_THERMAL_GOV_STEP_WISE=y
> CONFIG_THERMAL_GOV_USER_SPACE=y
> # CONFIG_CPU_THERMAL is not set
> # CONFIG_THERMAL_EMULATION is not set
> # CONFIG_INTEL_POWERCLAMP is not set
> CONFIG_X86_PKG_TEMP_THERMAL=m
> # CONFIG_ACPI_INT3403_THERMAL is not set
> # CONFIG_INTEL_SOC_DTS_THERMAL is not set
> 
> #
> # Texas Instruments thermal drivers
> #
> CONFIG_WATCHDOG=y
> CONFIG_WATCHDOG_CORE=y
> # CONFIG_WATCHDOG_NOWAYOUT is not set
> 
> #
> # Watchdog Device Drivers
> #
> CONFIG_SOFT_WATCHDOG=m
> CONFIG_GPIO_WATCHDOG=m
> CONFIG_XILINX_WATCHDOG=m
> CONFIG_DW_WATCHDOG=m
> CONFIG_ACQUIRE_WDT=y
> CONFIG_ADVANTECH_WDT=y
> # CONFIG_ALIM1535_WDT is not set
> CONFIG_ALIM7101_WDT=m
> CONFIG_F71808E_WDT=m
> CONFIG_SP5100_TCO=m
> CONFIG_GEODE_WDT=m
> CONFIG_SBC_FITPC2_WATCHDOG=m
> # CONFIG_EUROTECH_WDT is not set
> # CONFIG_IB700_WDT is not set
> CONFIG_IBMASR=m
> CONFIG_WAFER_WDT=m
> CONFIG_I6300ESB_WDT=m
> CONFIG_IE6XX_WDT=m
> CONFIG_ITCO_WDT=y
> # CONFIG_ITCO_VENDOR_SUPPORT is not set
> # CONFIG_IT8712F_WDT is not set
> # CONFIG_IT87_WDT is not set
> # CONFIG_HP_WATCHDOG is not set
> CONFIG_SC1200_WDT=m
> # CONFIG_PC87413_WDT is not set
> CONFIG_NV_TCO=m
> CONFIG_60XX_WDT=y
> CONFIG_SBC8360_WDT=y
> # CONFIG_SBC7240_WDT is not set
> # CONFIG_CPU5_WDT is not set
> # CONFIG_SMSC_SCH311X_WDT is not set
> CONFIG_SMSC37B787_WDT=y
> # CONFIG_VIA_WDT is not set
> CONFIG_W83627HF_WDT=m
> CONFIG_W83877F_WDT=y
> CONFIG_W83977F_WDT=m
> # CONFIG_MACHZ_WDT is not set
> # CONFIG_SBC_EPX_C3_WATCHDOG is not set
> # CONFIG_MEN_A21_WDT is not set
> 
> #
> # PCI-based Watchdog Cards
> #
> CONFIG_PCIPCWATCHDOG=m
> # CONFIG_WDTPCI is not set
> CONFIG_SSB_POSSIBLE=y
> 
> #
> # Sonics Silicon Backplane
> #
> CONFIG_SSB=y
> CONFIG_SSB_SPROM=y
> CONFIG_SSB_PCIHOST_POSSIBLE=y
> CONFIG_SSB_PCIHOST=y
> # CONFIG_SSB_B43_PCI_BRIDGE is not set
> # CONFIG_SSB_DEBUG is not set
> CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
> CONFIG_SSB_DRIVER_PCICORE=y
> CONFIG_SSB_DRIVER_GPIO=y
> CONFIG_BCMA_POSSIBLE=y
> 
> #
> # Broadcom specific AMBA
> #
> # CONFIG_BCMA is not set
> 
> #
> # Multifunction device drivers
> #
> CONFIG_MFD_CORE=y
> CONFIG_MFD_CS5535=y
> # CONFIG_MFD_BCM590XX is not set
> CONFIG_MFD_CROS_EC=m
> # CONFIG_MFD_CROS_EC_I2C is not set
> # CONFIG_MFD_MC13XXX_I2C is not set
> # CONFIG_HTC_PASIC3 is not set
> CONFIG_LPC_ICH=y
> CONFIG_LPC_SCH=m
> CONFIG_MFD_JANZ_CMODIO=y
> # CONFIG_MFD_KEMPLD is not set
> # CONFIG_MFD_RETU is not set
> CONFIG_MFD_PCF50633=m
> # CONFIG_PCF50633_ADC is not set
> # CONFIG_PCF50633_GPIO is not set
> # CONFIG_MFD_RDC321X is not set
> CONFIG_MFD_RTSX_PCI=y
> CONFIG_MFD_SI476X_CORE=m
> CONFIG_MFD_SM501=m
> # CONFIG_MFD_SM501_GPIO is not set
> CONFIG_ABX500_CORE=y
> CONFIG_MFD_SYSCON=y
> CONFIG_MFD_TI_AM335X_TSCADC=m
> CONFIG_MFD_LP3943=m
> CONFIG_TPS6105X=m
> # CONFIG_TPS65010 is not set
> CONFIG_TPS6507X=m
> # CONFIG_MFD_TPS65217 is not set
> # CONFIG_MFD_TPS65218 is not set
> CONFIG_MFD_TPS65912=y
> CONFIG_MFD_WL1273_CORE=m
> CONFIG_MFD_LM3533=m
> CONFIG_MFD_TIMBERDALE=y
> # CONFIG_MFD_TMIO is not set
> # CONFIG_MFD_VX855 is not set
> CONFIG_MFD_ARIZONA=y
> CONFIG_MFD_ARIZONA_I2C=m
> CONFIG_MFD_WM5102=y
> CONFIG_MFD_WM5110=y
> CONFIG_MFD_WM8997=y
> CONFIG_REGULATOR=y
> # CONFIG_REGULATOR_DEBUG is not set
> CONFIG_REGULATOR_FIXED_VOLTAGE=y
> CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
> CONFIG_REGULATOR_USERSPACE_CONSUMER=m
> CONFIG_REGULATOR_ACT8865=m
> # CONFIG_REGULATOR_AD5398 is not set
> # CONFIG_REGULATOR_ANATOP is not set
> CONFIG_REGULATOR_DA9210=m
> CONFIG_REGULATOR_FAN53555=m
> CONFIG_REGULATOR_GPIO=y
> # CONFIG_REGULATOR_ISL6271A is not set
> CONFIG_REGULATOR_LP3971=m
> CONFIG_REGULATOR_LP3972=m
> # CONFIG_REGULATOR_LP872X is not set
> # CONFIG_REGULATOR_LP8755 is not set
> CONFIG_REGULATOR_LTC3589=m
> CONFIG_REGULATOR_MAX1586=m
> # CONFIG_REGULATOR_MAX8649 is not set
> CONFIG_REGULATOR_MAX8660=m
> # CONFIG_REGULATOR_MAX8952 is not set
> CONFIG_REGULATOR_MAX8973=m
> CONFIG_REGULATOR_PCF50633=m
> # CONFIG_REGULATOR_PFUZE100 is not set
> CONFIG_REGULATOR_TPS51632=m
> # CONFIG_REGULATOR_TPS6105X is not set
> CONFIG_REGULATOR_TPS62360=m
> # CONFIG_REGULATOR_TPS65023 is not set
> # CONFIG_REGULATOR_TPS6507X is not set
> CONFIG_MEDIA_SUPPORT=y
> 
> #
> # Multimedia core support
> #
> # CONFIG_MEDIA_CAMERA_SUPPORT is not set
> # CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
> # CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
> CONFIG_MEDIA_RADIO_SUPPORT=y
> CONFIG_MEDIA_RC_SUPPORT=y
> CONFIG_VIDEO_DEV=y
> CONFIG_VIDEO_V4L2=m
> CONFIG_VIDEO_ADV_DEBUG=y
> CONFIG_VIDEO_FIXED_MINOR_RANGES=y
> # CONFIG_TTPCI_EEPROM is not set
> 
> #
> # Media drivers
> #
> CONFIG_RC_CORE=y
> CONFIG_RC_MAP=m
> CONFIG_RC_DECODERS=y
> # CONFIG_LIRC is not set
> CONFIG_IR_NEC_DECODER=m
> # CONFIG_IR_RC5_DECODER is not set
> # CONFIG_IR_RC6_DECODER is not set
> CONFIG_IR_JVC_DECODER=y
> CONFIG_IR_SONY_DECODER=y
> CONFIG_IR_RC5_SZ_DECODER=y
> # CONFIG_IR_SANYO_DECODER is not set
> CONFIG_IR_SHARP_DECODER=m
> # CONFIG_IR_MCE_KBD_DECODER is not set
> # CONFIG_RC_DEVICES is not set
> CONFIG_MEDIA_PCI_SUPPORT=y
> 
> #
> # Supported MMC/SDIO adapters
> #
> # CONFIG_RADIO_ADAPTERS is not set
> 
> #
> # Media ancillary drivers (tuners, sensors, i2c, frontends)
> #
> CONFIG_MEDIA_ATTACH=y
> CONFIG_VIDEO_IR_I2C=m
> 
> #
> # Encoders, decoders, sensors and other helper chips
> #
> 
> #
> # Audio decoders, processors and mixers
> #
> # CONFIG_VIDEO_TVAUDIO is not set
> CONFIG_VIDEO_TDA7432=m
> CONFIG_VIDEO_TDA9840=m
> # CONFIG_VIDEO_TEA6415C is not set
> CONFIG_VIDEO_TEA6420=m
> # CONFIG_VIDEO_MSP3400 is not set
> # CONFIG_VIDEO_CS5345 is not set
> # CONFIG_VIDEO_CS53L32A is not set
> CONFIG_VIDEO_TLV320AIC23B=m
> CONFIG_VIDEO_UDA1342=m
> CONFIG_VIDEO_WM8775=m
> CONFIG_VIDEO_WM8739=m
> # CONFIG_VIDEO_VP27SMPX is not set
> CONFIG_VIDEO_SONY_BTF_MPX=m
> 
> #
> # RDS decoders
> #
> CONFIG_VIDEO_SAA6588=m
> 
> #
> # Video decoders
> #
> CONFIG_VIDEO_ADV7180=m
> CONFIG_VIDEO_ADV7183=m
> # CONFIG_VIDEO_BT819 is not set
> # CONFIG_VIDEO_BT856 is not set
> # CONFIG_VIDEO_BT866 is not set
> # CONFIG_VIDEO_KS0127 is not set
> # CONFIG_VIDEO_ML86V7667 is not set
> CONFIG_VIDEO_SAA7110=m
> CONFIG_VIDEO_SAA711X=m
> # CONFIG_VIDEO_SAA7191 is not set
> CONFIG_VIDEO_TVP514X=m
> # CONFIG_VIDEO_TVP5150 is not set
> CONFIG_VIDEO_TVP7002=m
> CONFIG_VIDEO_TW2804=m
> CONFIG_VIDEO_TW9903=m
> CONFIG_VIDEO_TW9906=m
> CONFIG_VIDEO_VPX3220=m
> 
> #
> # Video and audio decoders
> #
> CONFIG_VIDEO_SAA717X=m
> CONFIG_VIDEO_CX25840=m
> 
> #
> # Video encoders
> #
> CONFIG_VIDEO_SAA7127=m
> CONFIG_VIDEO_SAA7185=m
> CONFIG_VIDEO_ADV7170=m
> CONFIG_VIDEO_ADV7175=m
> CONFIG_VIDEO_ADV7343=m
> CONFIG_VIDEO_ADV7393=m
> CONFIG_VIDEO_AK881X=m
> # CONFIG_VIDEO_THS8200 is not set
> 
> #
> # Camera sensor devices
> #
> 
> #
> # Flash devices
> #
> 
> #
> # Video improvement chips
> #
> # CONFIG_VIDEO_UPD64031A is not set
> CONFIG_VIDEO_UPD64083=m
> 
> #
> # Audio/Video compression chips
> #
> CONFIG_VIDEO_SAA6752HS=m
> 
> #
> # Miscellaneous helper chips
> #
> # CONFIG_VIDEO_THS7303 is not set
> CONFIG_VIDEO_M52790=m
> 
> #
> # Sensors used on soc_camera driver
> #
> CONFIG_MEDIA_TUNER=m
> 
> #
> # Customize TV tuners
> #
> CONFIG_MEDIA_TUNER_SIMPLE=m
> CONFIG_MEDIA_TUNER_TDA8290=m
> CONFIG_MEDIA_TUNER_TDA827X=m
> CONFIG_MEDIA_TUNER_TDA18271=m
> CONFIG_MEDIA_TUNER_TDA9887=m
> CONFIG_MEDIA_TUNER_TEA5761=m
> CONFIG_MEDIA_TUNER_TEA5767=m
> # CONFIG_MEDIA_TUNER_MT20XX is not set
> CONFIG_MEDIA_TUNER_MT2060=m
> CONFIG_MEDIA_TUNER_MT2063=m
> # CONFIG_MEDIA_TUNER_MT2266 is not set
> # CONFIG_MEDIA_TUNER_MT2131 is not set
> CONFIG_MEDIA_TUNER_QT1010=m
> # CONFIG_MEDIA_TUNER_XC2028 is not set
> # CONFIG_MEDIA_TUNER_XC5000 is not set
> CONFIG_MEDIA_TUNER_XC4000=m
> CONFIG_MEDIA_TUNER_MXL5005S=m
> # CONFIG_MEDIA_TUNER_MXL5007T is not set
> CONFIG_MEDIA_TUNER_MC44S803=m
> CONFIG_MEDIA_TUNER_MAX2165=m
> # CONFIG_MEDIA_TUNER_TDA18218 is not set
> # CONFIG_MEDIA_TUNER_FC0011 is not set
> CONFIG_MEDIA_TUNER_FC0012=m
> # CONFIG_MEDIA_TUNER_FC0013 is not set
> CONFIG_MEDIA_TUNER_TDA18212=m
> CONFIG_MEDIA_TUNER_E4000=m
> CONFIG_MEDIA_TUNER_FC2580=m
> CONFIG_MEDIA_TUNER_M88TS2022=m
> CONFIG_MEDIA_TUNER_TUA9001=m
> CONFIG_MEDIA_TUNER_SI2157=m
> # CONFIG_MEDIA_TUNER_IT913X is not set
> CONFIG_MEDIA_TUNER_R820T=m
> 
> #
> # Customise DVB Frontends
> #
> CONFIG_DVB_AU8522=m
> CONFIG_DVB_AU8522_V4L=m
> # CONFIG_DVB_TUNER_DIB0070 is not set
> CONFIG_DVB_TUNER_DIB0090=m
> 
> #
> # Tools to develop new frontends
> #
> CONFIG_DVB_DUMMY_FE=m
> 
> #
> # Graphics support
> #
> CONFIG_AGP=y
> CONFIG_AGP_ALI=m
> CONFIG_AGP_ATI=y
> CONFIG_AGP_AMD=m
> CONFIG_AGP_AMD64=y
> # CONFIG_AGP_INTEL is not set
> CONFIG_AGP_NVIDIA=m
> # CONFIG_AGP_SIS is not set
> CONFIG_AGP_SWORKS=m
> CONFIG_AGP_VIA=m
> CONFIG_AGP_EFFICEON=y
> CONFIG_VGA_ARB=y
> CONFIG_VGA_ARB_MAX_GPUS=16
> # CONFIG_VGA_SWITCHEROO is not set
> 
> #
> # Direct Rendering Manager
> #
> # CONFIG_DRM is not set
> 
> #
> # Frame buffer Devices
> #
> CONFIG_FB=m
> CONFIG_FIRMWARE_EDID=y
> CONFIG_FB_DDC=m
> # CONFIG_FB_BOOT_VESA_SUPPORT is not set
> CONFIG_FB_CFB_FILLRECT=m
> CONFIG_FB_CFB_COPYAREA=m
> CONFIG_FB_CFB_IMAGEBLIT=m
> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> CONFIG_FB_SYS_FILLRECT=m
> CONFIG_FB_SYS_COPYAREA=m
> CONFIG_FB_SYS_IMAGEBLIT=m
> CONFIG_FB_FOREIGN_ENDIAN=y
> CONFIG_FB_BOTH_ENDIAN=y
> # CONFIG_FB_BIG_ENDIAN is not set
> # CONFIG_FB_LITTLE_ENDIAN is not set
> CONFIG_FB_SYS_FOPS=m
> CONFIG_FB_DEFERRED_IO=y
> CONFIG_FB_HECUBA=m
> CONFIG_FB_SVGALIB=m
> # CONFIG_FB_MACMODES is not set
> CONFIG_FB_BACKLIGHT=y
> CONFIG_FB_MODE_HELPERS=y
> CONFIG_FB_TILEBLITTING=y
> 
> #
> # Frame buffer hardware drivers
> #
> CONFIG_FB_CIRRUS=m
> CONFIG_FB_PM2=m
> CONFIG_FB_PM2_FIFO_DISCONNECT=y
> # CONFIG_FB_CYBER2000 is not set
> CONFIG_FB_ARC=m
> # CONFIG_FB_VGA16 is not set
> CONFIG_FB_UVESA=m
> CONFIG_FB_N411=m
> CONFIG_FB_HGA=m
> CONFIG_FB_OPENCORES=m
> CONFIG_FB_S1D13XXX=m
> CONFIG_FB_NVIDIA=m
> CONFIG_FB_NVIDIA_I2C=y
> # CONFIG_FB_NVIDIA_DEBUG is not set
> # CONFIG_FB_NVIDIA_BACKLIGHT is not set
> CONFIG_FB_RIVA=m
> CONFIG_FB_RIVA_I2C=y
> CONFIG_FB_RIVA_DEBUG=y
> CONFIG_FB_RIVA_BACKLIGHT=y
> CONFIG_FB_I740=m
> CONFIG_FB_LE80578=m
> CONFIG_FB_CARILLO_RANCH=m
> # CONFIG_FB_MATROX is not set
> CONFIG_FB_RADEON=m
> # CONFIG_FB_RADEON_I2C is not set
> CONFIG_FB_RADEON_BACKLIGHT=y
> CONFIG_FB_RADEON_DEBUG=y
> CONFIG_FB_ATY128=m
> # CONFIG_FB_ATY128_BACKLIGHT is not set
> CONFIG_FB_ATY=m
> CONFIG_FB_ATY_CT=y
> CONFIG_FB_ATY_GENERIC_LCD=y
> CONFIG_FB_ATY_GX=y
> CONFIG_FB_ATY_BACKLIGHT=y
> CONFIG_FB_S3=m
> CONFIG_FB_S3_DDC=y
> CONFIG_FB_SAVAGE=m
> CONFIG_FB_SAVAGE_I2C=y
> # CONFIG_FB_SAVAGE_ACCEL is not set
> CONFIG_FB_SIS=m
> CONFIG_FB_SIS_300=y
> # CONFIG_FB_SIS_315 is not set
> # CONFIG_FB_VIA is not set
> CONFIG_FB_NEOMAGIC=m
> # CONFIG_FB_KYRO is not set
> # CONFIG_FB_3DFX is not set
> # CONFIG_FB_VOODOO1 is not set
> CONFIG_FB_VT8623=m
> # CONFIG_FB_TRIDENT is not set
> CONFIG_FB_ARK=m
> CONFIG_FB_PM3=m
> # CONFIG_FB_CARMINE is not set
> CONFIG_FB_GEODE=y
> CONFIG_FB_GEODE_LX=m
> # CONFIG_FB_GEODE_GX is not set
> # CONFIG_FB_GEODE_GX1 is not set
> # CONFIG_FB_SM501 is not set
> # CONFIG_FB_VIRTUAL is not set
> CONFIG_FB_METRONOME=m
> CONFIG_FB_MB862XX=m
> CONFIG_FB_MB862XX_PCI_GDC=y
> CONFIG_FB_MB862XX_I2C=y
> CONFIG_FB_BROADSHEET=m
> CONFIG_FB_AUO_K190X=m
> # CONFIG_FB_AUO_K1900 is not set
> # CONFIG_FB_AUO_K1901 is not set
> CONFIG_FB_SSD1307=m
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> # CONFIG_LCD_CLASS_DEVICE is not set
> CONFIG_BACKLIGHT_CLASS_DEVICE=m
> # CONFIG_BACKLIGHT_GENERIC is not set
> # CONFIG_BACKLIGHT_LM3533 is not set
> # CONFIG_BACKLIGHT_PWM is not set
> # CONFIG_BACKLIGHT_APPLE is not set
> CONFIG_BACKLIGHT_SAHARA=m
> # CONFIG_BACKLIGHT_ADP8860 is not set
> # CONFIG_BACKLIGHT_ADP8870 is not set
> CONFIG_BACKLIGHT_PCF50633=m
> CONFIG_BACKLIGHT_LM3630A=m
> CONFIG_BACKLIGHT_LM3639=m
> CONFIG_BACKLIGHT_LP855X=m
> # CONFIG_BACKLIGHT_GPIO is not set
> CONFIG_BACKLIGHT_LV5207LP=m
> # CONFIG_BACKLIGHT_BD6107 is not set
> CONFIG_VGASTATE=m
> 
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> CONFIG_VGACON_SOFT_SCROLLBACK=y
> CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
> CONFIG_DUMMY_CONSOLE=y
> CONFIG_FRAMEBUFFER_CONSOLE=m
> CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
> # CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
> # CONFIG_LOGO is not set
> # CONFIG_SOUND is not set
> 
> #
> # HID support
> #
> CONFIG_HID=m
> # CONFIG_HIDRAW is not set
> CONFIG_UHID=m
> # CONFIG_HID_GENERIC is not set
> 
> #
> # Special HID drivers
> #
> CONFIG_HID_A4TECH=m
> CONFIG_HID_ACRUX=m
> # CONFIG_HID_ACRUX_FF is not set
> CONFIG_HID_APPLE=m
> # CONFIG_HID_AUREAL is not set
> CONFIG_HID_BELKIN=m
> CONFIG_HID_CHERRY=m
> CONFIG_HID_CHICONY=m
> CONFIG_HID_CYPRESS=m
> CONFIG_HID_DRAGONRISE=m
> # CONFIG_DRAGONRISE_FF is not set
> CONFIG_HID_EMS_FF=m
> CONFIG_HID_ELECOM=m
> CONFIG_HID_EZKEY=m
> CONFIG_HID_KEYTOUCH=m
> CONFIG_HID_KYE=m
> CONFIG_HID_UCLOGIC=m
> CONFIG_HID_WALTOP=m
> # CONFIG_HID_GYRATION is not set
> # CONFIG_HID_ICADE is not set
> # CONFIG_HID_TWINHAN is not set
> CONFIG_HID_KENSINGTON=m
> CONFIG_HID_LCPOWER=m
> # CONFIG_HID_LENOVO_TPKBD is not set
> CONFIG_HID_LOGITECH=m
> CONFIG_LOGITECH_FF=y
> # CONFIG_LOGIRUMBLEPAD2_FF is not set
> CONFIG_LOGIG940_FF=y
> CONFIG_LOGIWHEELS_FF=y
> CONFIG_HID_MAGICMOUSE=m
> CONFIG_HID_MICROSOFT=m
> CONFIG_HID_MONTEREY=m
> CONFIG_HID_MULTITOUCH=m
> CONFIG_HID_ORTEK=m
> CONFIG_HID_PANTHERLORD=m
> # CONFIG_PANTHERLORD_FF is not set
> # CONFIG_HID_PETALYNX is not set
> # CONFIG_HID_PICOLCD is not set
> CONFIG_HID_PRIMAX=m
> CONFIG_HID_SAITEK=m
> # CONFIG_HID_SAMSUNG is not set
> CONFIG_HID_SPEEDLINK=m
> CONFIG_HID_STEELSERIES=m
> # CONFIG_HID_SUNPLUS is not set
> CONFIG_HID_RMI=m
> # CONFIG_HID_GREENASIA is not set
> # CONFIG_HID_SMARTJOYPLUS is not set
> CONFIG_HID_TIVO=m
> CONFIG_HID_TOPSEED=m
> CONFIG_HID_THINGM=m
> CONFIG_HID_THRUSTMASTER=m
> CONFIG_THRUSTMASTER_FF=y
> # CONFIG_HID_WACOM is not set
> CONFIG_HID_WIIMOTE=m
> # CONFIG_HID_XINMO is not set
> # CONFIG_HID_ZEROPLUS is not set
> # CONFIG_HID_ZYDACRON is not set
> CONFIG_HID_SENSOR_HUB=m
> 
> #
> # I2C HID support
> #
> CONFIG_I2C_HID=m
> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_ARCH_HAS_HCD=y
> # CONFIG_USB is not set
> 
> #
> # USB port drivers
> #
> 
> #
> # USB Physical Layer drivers
> #
> # CONFIG_USB_PHY is not set
> # CONFIG_NOP_USB_XCEIV is not set
> # CONFIG_SAMSUNG_USB2PHY is not set
> # CONFIG_SAMSUNG_USB3PHY is not set
> # CONFIG_USB_GPIO_VBUS is not set
> # CONFIG_USB_GADGET is not set
> CONFIG_UWB=m
> # CONFIG_UWB_WHCI is not set
> # CONFIG_MMC is not set
> # CONFIG_MEMSTICK is not set
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=m
> 
> #
> # LED drivers
> #
> CONFIG_LEDS_LM3530=m
> CONFIG_LEDS_LM3533=m
> CONFIG_LEDS_LM3642=m
> # CONFIG_LEDS_PCA9532 is not set
> # CONFIG_LEDS_GPIO is not set
> CONFIG_LEDS_LP3944=m
> CONFIG_LEDS_LP55XX_COMMON=m
> CONFIG_LEDS_LP5521=m
> CONFIG_LEDS_LP5523=m
> # CONFIG_LEDS_LP5562 is not set
> CONFIG_LEDS_LP8501=m
> CONFIG_LEDS_CLEVO_MAIL=m
> CONFIG_LEDS_PCA955X=m
> CONFIG_LEDS_PCA963X=m
> CONFIG_LEDS_PWM=m
> # CONFIG_LEDS_REGULATOR is not set
> # CONFIG_LEDS_BD2802 is not set
> # CONFIG_LEDS_INTEL_SS4200 is not set
> # CONFIG_LEDS_LT3593 is not set
> # CONFIG_LEDS_TCA6507 is not set
> CONFIG_LEDS_LM355x=m
> CONFIG_LEDS_OT200=m
> 
> #
> # LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
> #
> # CONFIG_LEDS_BLINKM is not set
> 
> #
> # LED Triggers
> #
> CONFIG_LEDS_TRIGGERS=y
> CONFIG_LEDS_TRIGGER_TIMER=m
> CONFIG_LEDS_TRIGGER_ONESHOT=m
> CONFIG_LEDS_TRIGGER_HEARTBEAT=m
> # CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
> # CONFIG_LEDS_TRIGGER_CPU is not set
> CONFIG_LEDS_TRIGGER_GPIO=y
> # CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
> 
> #
> # iptables trigger is under Netfilter config (LED target)
> #
> CONFIG_LEDS_TRIGGER_TRANSIENT=m
> CONFIG_LEDS_TRIGGER_CAMERA=m
> CONFIG_ACCESSIBILITY=y
> # CONFIG_A11Y_BRAILLE_CONSOLE is not set
> CONFIG_INFINIBAND=m
> CONFIG_INFINIBAND_USER_MAD=m
> CONFIG_INFINIBAND_USER_ACCESS=m
> CONFIG_INFINIBAND_USER_MEM=y
> CONFIG_INFINIBAND_ADDR_TRANS=y
> CONFIG_INFINIBAND_MTHCA=m
> CONFIG_INFINIBAND_MTHCA_DEBUG=y
> # CONFIG_INFINIBAND_AMSO1100 is not set
> CONFIG_INFINIBAND_CXGB4=m
> CONFIG_MLX4_INFINIBAND=m
> CONFIG_MLX5_INFINIBAND=m
> # CONFIG_INFINIBAND_NES is not set
> CONFIG_INFINIBAND_OCRDMA=m
> CONFIG_INFINIBAND_IPOIB=m
> # CONFIG_INFINIBAND_IPOIB_CM is not set
> CONFIG_INFINIBAND_IPOIB_DEBUG=y
> # CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
> CONFIG_INFINIBAND_SRP=m
> CONFIG_INFINIBAND_SRPT=m
> CONFIG_INFINIBAND_ISER=m
> # CONFIG_INFINIBAND_ISERT is not set
> CONFIG_EDAC=y
> # CONFIG_EDAC_LEGACY_SYSFS is not set
> CONFIG_EDAC_DEBUG=y
> CONFIG_EDAC_DECODE_MCE=m
> # CONFIG_EDAC_MCE_INJ is not set
> CONFIG_EDAC_MM_EDAC=y
> CONFIG_EDAC_AMD76X=m
> CONFIG_EDAC_E7XXX=y
> CONFIG_EDAC_E752X=m
> # CONFIG_EDAC_I82875P is not set
> # CONFIG_EDAC_I82975X is not set
> # CONFIG_EDAC_I3000 is not set
> CONFIG_EDAC_I3200=m
> CONFIG_EDAC_X38=y
> # CONFIG_EDAC_I5400 is not set
> CONFIG_EDAC_I7CORE=y
> CONFIG_EDAC_I82860=y
> CONFIG_EDAC_R82600=m
> CONFIG_EDAC_I5000=y
> CONFIG_EDAC_I5100=y
> CONFIG_EDAC_I7300=m
> CONFIG_RTC_LIB=y
> CONFIG_RTC_CLASS=y
> # CONFIG_RTC_HCTOSYS is not set
> CONFIG_RTC_SYSTOHC=y
> CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
> CONFIG_RTC_DEBUG=y
> 
> #
> # RTC interfaces
> #
> CONFIG_RTC_INTF_SYSFS=y
> CONFIG_RTC_INTF_PROC=y
> # CONFIG_RTC_INTF_DEV is not set
> # CONFIG_RTC_DRV_TEST is not set
> 
> #
> # I2C RTC drivers
> #
> # CONFIG_RTC_DRV_DS1307 is not set
> CONFIG_RTC_DRV_DS1374=m
> # CONFIG_RTC_DRV_DS1672 is not set
> CONFIG_RTC_DRV_DS3232=m
> # CONFIG_RTC_DRV_HYM8563 is not set
> # CONFIG_RTC_DRV_MAX6900 is not set
> CONFIG_RTC_DRV_RS5C372=m
> # CONFIG_RTC_DRV_ISL1208 is not set
> # CONFIG_RTC_DRV_ISL12022 is not set
> # CONFIG_RTC_DRV_ISL12057 is not set
> # CONFIG_RTC_DRV_X1205 is not set
> CONFIG_RTC_DRV_PCF2127=m
> CONFIG_RTC_DRV_PCF8523=m
> CONFIG_RTC_DRV_PCF8563=m
> # CONFIG_RTC_DRV_PCF8583 is not set
> CONFIG_RTC_DRV_M41T80=m
> CONFIG_RTC_DRV_M41T80_WDT=y
> CONFIG_RTC_DRV_BQ32K=m
> CONFIG_RTC_DRV_S35390A=m
> CONFIG_RTC_DRV_FM3130=m
> CONFIG_RTC_DRV_RX8581=m
> CONFIG_RTC_DRV_RX8025=m
> CONFIG_RTC_DRV_EM3027=m
> CONFIG_RTC_DRV_RV3029C2=m
> 
> #
> # SPI RTC drivers
> #
> 
> #
> # Platform RTC drivers
> #
> # CONFIG_RTC_DRV_CMOS is not set
> CONFIG_RTC_DRV_DS1286=m
> # CONFIG_RTC_DRV_DS1511 is not set
> CONFIG_RTC_DRV_DS1553=y
> CONFIG_RTC_DRV_DS1742=m
> CONFIG_RTC_DRV_STK17TA8=y
> # CONFIG_RTC_DRV_M48T86 is not set
> # CONFIG_RTC_DRV_M48T35 is not set
> # CONFIG_RTC_DRV_M48T59 is not set
> CONFIG_RTC_DRV_MSM6242=y
> CONFIG_RTC_DRV_BQ4802=m
> CONFIG_RTC_DRV_RP5C01=y
> # CONFIG_RTC_DRV_V3020 is not set
> CONFIG_RTC_DRV_DS2404=m
> CONFIG_RTC_DRV_PCF50633=m
> 
> #
> # on-CPU RTC drivers
> #
> # CONFIG_RTC_DRV_SNVS is not set
> # CONFIG_RTC_DRV_MOXART is not set
> CONFIG_RTC_DRV_XGENE=y
> 
> #
> # HID Sensor RTC drivers
> #
> # CONFIG_DMADEVICES is not set
> CONFIG_AUXDISPLAY=y
> CONFIG_UIO=y
> CONFIG_UIO_CIF=y
> CONFIG_UIO_PDRV_GENIRQ=y
> CONFIG_UIO_DMEM_GENIRQ=y
> CONFIG_UIO_AEC=y
> CONFIG_UIO_SERCOS3=m
> # CONFIG_UIO_PCI_GENERIC is not set
> CONFIG_UIO_NETX=m
> # CONFIG_UIO_MF624 is not set
> # CONFIG_VIRT_DRIVERS is not set
> CONFIG_VIRTIO=y
> 
> #
> # Virtio drivers
> #
> CONFIG_VIRTIO_PCI=m
> CONFIG_VIRTIO_BALLOON=y
> CONFIG_VIRTIO_MMIO=m
> # CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set
> 
> #
> # Microsoft Hyper-V guest support
> #
> # CONFIG_HYPERV is not set
> CONFIG_STAGING=y
> CONFIG_ET131X=y
> CONFIG_SLICOSS=y
> CONFIG_COMEDI=m
> CONFIG_COMEDI_DEBUG=y
> CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
> CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
> # CONFIG_COMEDI_MISC_DRIVERS is not set
> CONFIG_COMEDI_ISA_DRIVERS=y
> CONFIG_COMEDI_PCL711=m
> CONFIG_COMEDI_PCL724=m
> # CONFIG_COMEDI_PCL726 is not set
> CONFIG_COMEDI_PCL730=m
> CONFIG_COMEDI_PCL812=m
> CONFIG_COMEDI_PCL816=m
> CONFIG_COMEDI_PCL818=m
> CONFIG_COMEDI_PCM3724=m
> # CONFIG_COMEDI_AMPLC_DIO200_ISA is not set
> CONFIG_COMEDI_AMPLC_PC236_ISA=m
> # CONFIG_COMEDI_AMPLC_PC263_ISA is not set
> # CONFIG_COMEDI_RTI800 is not set
> CONFIG_COMEDI_RTI802=m
> # CONFIG_COMEDI_DAC02 is not set
> CONFIG_COMEDI_DAS16M1=m
> # CONFIG_COMEDI_DAS08_ISA is not set
> CONFIG_COMEDI_DAS16=m
> CONFIG_COMEDI_DAS800=m
> CONFIG_COMEDI_DAS1800=m
> # CONFIG_COMEDI_DAS6402 is not set
> # CONFIG_COMEDI_DT2801 is not set
> # CONFIG_COMEDI_DT2811 is not set
> CONFIG_COMEDI_DT2814=m
> CONFIG_COMEDI_DT2815=m
> CONFIG_COMEDI_DT2817=m
> CONFIG_COMEDI_DT282X=m
> CONFIG_COMEDI_DMM32AT=m
> CONFIG_COMEDI_UNIOXX5=m
> CONFIG_COMEDI_FL512=m
> # CONFIG_COMEDI_AIO_AIO12_8 is not set
> CONFIG_COMEDI_AIO_IIRO_16=m
> CONFIG_COMEDI_II_PCI20KC=m
> CONFIG_COMEDI_C6XDIGIO=m
> # CONFIG_COMEDI_MPC624 is not set
> CONFIG_COMEDI_ADQ12B=m
> CONFIG_COMEDI_NI_AT_A2150=m
> CONFIG_COMEDI_NI_AT_AO=m
> # CONFIG_COMEDI_NI_ATMIO is not set
> CONFIG_COMEDI_NI_ATMIO16D=m
> # CONFIG_COMEDI_NI_LABPC_ISA is not set
> CONFIG_COMEDI_PCMAD=m
> # CONFIG_COMEDI_PCMDA12 is not set
> # CONFIG_COMEDI_PCMMIO is not set
> # CONFIG_COMEDI_PCMUIO is not set
> # CONFIG_COMEDI_MULTIQ3 is not set
> CONFIG_COMEDI_S526=m
> # CONFIG_COMEDI_PCI_DRIVERS is not set
> # CONFIG_COMEDI_PCMCIA_DRIVERS is not set
> CONFIG_COMEDI_8255=m
> CONFIG_COMEDI_FC=m
> CONFIG_COMEDI_AMPLC_PC236=m
> CONFIG_FB_OLPC_DCON=m
> CONFIG_FB_OLPC_DCON_1_5=y
> CONFIG_RTLLIB=m
> # CONFIG_RTLLIB_CRYPTO_CCMP is not set
> CONFIG_RTLLIB_CRYPTO_TKIP=m
> CONFIG_RTLLIB_CRYPTO_WEP=m
> # CONFIG_RTL8192E is not set
> CONFIG_RTS5208=y
> # CONFIG_RTS5208_DEBUG is not set
> CONFIG_IDE_PHISON=y
> CONFIG_VT6655=m
> # CONFIG_DX_SEP is not set
> CONFIG_WLAGS49_H2=m
> # CONFIG_WLAGS49_H25 is not set
> CONFIG_CRYSTALHD=y
> # CONFIG_FB_XGI is not set
> # CONFIG_ACPI_QUICKSTART is not set
> CONFIG_FT1000=y
> CONFIG_FT1000_PCMCIA=m
> 
> #
> # Speakup console speech
> #
> CONFIG_SPEAKUP=y
> CONFIG_SPEAKUP_SYNTH_ACNTSA=m
> # CONFIG_SPEAKUP_SYNTH_APOLLO is not set
> # CONFIG_SPEAKUP_SYNTH_AUDPTR is not set
> CONFIG_SPEAKUP_SYNTH_BNS=m
> CONFIG_SPEAKUP_SYNTH_DECTLK=y
> CONFIG_SPEAKUP_SYNTH_DECEXT=m
> # CONFIG_SPEAKUP_SYNTH_LTLK is not set
> CONFIG_SPEAKUP_SYNTH_SOFT=y
> CONFIG_SPEAKUP_SYNTH_SPKOUT=y
> CONFIG_SPEAKUP_SYNTH_TXPRT=y
> # CONFIG_SPEAKUP_SYNTH_DUMMY is not set
> CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=m
> # CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
> # CONFIG_STAGING_MEDIA is not set
> 
> #
> # Android
> #
> CONFIG_ANDROID=y
> # CONFIG_ANDROID_BINDER_IPC is not set
> CONFIG_ASHMEM=y
> # CONFIG_ANDROID_LOGGER is not set
> CONFIG_ANDROID_TIMED_OUTPUT=y
> CONFIG_ANDROID_TIMED_GPIO=y
> CONFIG_ANDROID_LOW_MEMORY_KILLER=y
> # CONFIG_ANDROID_INTF_ALARM_DEV is not set
> # CONFIG_SYNC is not set
> # CONFIG_ION is not set
> # CONFIG_NET_VENDOR_SILICOM is not set
> CONFIG_DGRP=m
> # CONFIG_LUSTRE_FS is not set
> # CONFIG_XILLYBUS is not set
> CONFIG_DGNC=y
> CONFIG_DGAP=m
> CONFIG_GS_FPGABOOT=m
> CONFIG_X86_PLATFORM_DEVICES=y
> # CONFIG_ACERHDF is not set
> # CONFIG_ASUS_LAPTOP is not set
> CONFIG_DELL_LAPTOP=m
> # CONFIG_DELL_SMO8800 is not set
> # CONFIG_FUJITSU_LAPTOP is not set
> # CONFIG_FUJITSU_TABLET is not set
> CONFIG_AMILO_RFKILL=m
> # CONFIG_HP_ACCEL is not set
> # CONFIG_HP_WIRELESS is not set
> # CONFIG_MSI_LAPTOP is not set
> # CONFIG_PANASONIC_LAPTOP is not set
> # CONFIG_COMPAL_LAPTOP is not set
> # CONFIG_SONY_LAPTOP is not set
> # CONFIG_IDEAPAD_LAPTOP is not set
> # CONFIG_THINKPAD_ACPI is not set
> # CONFIG_SENSORS_HDAPS is not set
> # CONFIG_INTEL_MENLOW is not set
> # CONFIG_EEEPC_LAPTOP is not set
> # CONFIG_ACPI_WMI is not set
> # CONFIG_TOPSTAR_LAPTOP is not set
> # CONFIG_TOSHIBA_BT_RFKILL is not set
> # CONFIG_ACPI_CMPC is not set
> # CONFIG_INTEL_IPS is not set
> # CONFIG_IBM_RTL is not set
> # CONFIG_XO1_RFKILL is not set
> # CONFIG_XO15_EBOOK is not set
> CONFIG_SAMSUNG_LAPTOP=m
> # CONFIG_INTEL_OAKTRAIL is not set
> # CONFIG_SAMSUNG_Q10 is not set
> # CONFIG_APPLE_GMUX is not set
> # CONFIG_INTEL_RST is not set
> # CONFIG_INTEL_SMARTCONNECT is not set
> # CONFIG_PVPANIC is not set
> CONFIG_CHROME_PLATFORMS=y
> # CONFIG_CHROMEOS_LAPTOP is not set
> CONFIG_CHROMEOS_PSTORE=m
> 
> #
> # SOC (System On Chip) specific Drivers
> #
> 
> #
> # Hardware Spinlock drivers
> #
> CONFIG_CLKSRC_I8253=y
> CONFIG_CLKEVT_I8253=y
> CONFIG_I8253_LOCK=y
> CONFIG_CLKBLD_I8253=y
> # CONFIG_SH_TIMER_CMT is not set
> # CONFIG_SH_TIMER_MTU2 is not set
> # CONFIG_SH_TIMER_TMU is not set
> # CONFIG_EM_TIMER_STI is not set
> # CONFIG_MAILBOX is not set
> # CONFIG_IOMMU_SUPPORT is not set
> 
> #
> # Remoteproc drivers
> #
> # CONFIG_STE_MODEM_RPROC is not set
> 
> #
> # Rpmsg drivers
> #
> CONFIG_PM_DEVFREQ=y
> 
> #
> # DEVFREQ Governors
> #
> CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=m
> CONFIG_DEVFREQ_GOV_PERFORMANCE=y
> CONFIG_DEVFREQ_GOV_POWERSAVE=m
> CONFIG_DEVFREQ_GOV_USERSPACE=m
> 
> #
> # DEVFREQ Drivers
> #
> CONFIG_EXTCON=y
> 
> #
> # Extcon Device Drivers
> #
> CONFIG_EXTCON_GPIO=y
> CONFIG_MEMORY=y
> # CONFIG_IIO is not set
> CONFIG_NTB=y
> # CONFIG_VME_BUS is not set
> CONFIG_PWM=y
> CONFIG_PWM_SYSFS=y
> # CONFIG_PWM_FSL_FTM is not set
> # CONFIG_PWM_LP3943 is not set
> # CONFIG_PWM_LPSS is not set
> CONFIG_PWM_PCA9685=m
> CONFIG_IRQCHIP=y
> CONFIG_IPACK_BUS=y
> CONFIG_BOARD_TPCI200=y
> # CONFIG_SERIAL_IPOCTAL is not set
> # CONFIG_RESET_CONTROLLER is not set
> # CONFIG_FMC is not set
> 
> #
> # PHY Subsystem
> #
> CONFIG_GENERIC_PHY=y
> # CONFIG_BCM_KONA_USB2_PHY is not set
> # CONFIG_PHY_SAMSUNG_USB2 is not set
> # CONFIG_POWERCAP is not set
> # CONFIG_MCB is not set
> 
> #
> # Firmware Drivers
> #
> # CONFIG_EDD is not set
> CONFIG_FIRMWARE_MEMMAP=y
> CONFIG_DELL_RBU=m
> CONFIG_DCDBAS=y
> CONFIG_DMIID=y
> # CONFIG_DMI_SYSFS is not set
> CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
> # CONFIG_ISCSI_IBFT_FIND is not set
> CONFIG_GOOGLE_FIRMWARE=y
> 
> #
> # Google Firmware Drivers
> #
> # CONFIG_GOOGLE_MEMCONSOLE is not set
> 
> #
> # File systems
> #
> CONFIG_DCACHE_WORD_ACCESS=y
> # CONFIG_EXT2_FS is not set
> CONFIG_EXT3_FS=m
> # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
> # CONFIG_EXT3_FS_XATTR is not set
> CONFIG_EXT4_FS=y
> CONFIG_EXT4_USE_FOR_EXT23=y
> CONFIG_EXT4_FS_POSIX_ACL=y
> CONFIG_EXT4_FS_SECURITY=y
> # CONFIG_EXT4_DEBUG is not set
> CONFIG_JBD=m
> CONFIG_JBD_DEBUG=y
> CONFIG_JBD2=y
> CONFIG_JBD2_DEBUG=y
> CONFIG_FS_MBCACHE=y
> # CONFIG_REISERFS_FS is not set
> CONFIG_JFS_FS=y
> CONFIG_JFS_POSIX_ACL=y
> # CONFIG_JFS_SECURITY is not set
> CONFIG_JFS_DEBUG=y
> # CONFIG_JFS_STATISTICS is not set
> # CONFIG_XFS_FS is not set
> CONFIG_OCFS2_FS=m
> # CONFIG_OCFS2_FS_O2CB is not set
> # CONFIG_OCFS2_FS_USERSPACE_CLUSTER is not set
> # CONFIG_OCFS2_FS_STATS is not set
> CONFIG_OCFS2_DEBUG_MASKLOG=y
> # CONFIG_OCFS2_DEBUG_FS is not set
> # CONFIG_BTRFS_FS is not set
> CONFIG_NILFS2_FS=y
> CONFIG_FS_POSIX_ACL=y
> CONFIG_EXPORTFS=y
> CONFIG_FILE_LOCKING=y
> CONFIG_FSNOTIFY=y
> CONFIG_DNOTIFY=y
> # CONFIG_INOTIFY_USER is not set
> CONFIG_FANOTIFY=y
> # CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
> CONFIG_QUOTA=y
> CONFIG_QUOTA_NETLINK_INTERFACE=y
> # CONFIG_PRINT_QUOTA_WARNING is not set
> CONFIG_QUOTA_DEBUG=y
> CONFIG_QUOTA_TREE=y
> # CONFIG_QFMT_V1 is not set
> CONFIG_QFMT_V2=y
> CONFIG_QUOTACTL=y
> CONFIG_AUTOFS4_FS=m
> CONFIG_FUSE_FS=y
> CONFIG_CUSE=y
> 
> #
> # Caches
> #
> # CONFIG_FSCACHE is not set
> 
> #
> # CD-ROM/DVD Filesystems
> #
> # CONFIG_ISO9660_FS is not set
> CONFIG_UDF_FS=m
> CONFIG_UDF_NLS=y
> 
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=y
> CONFIG_MSDOS_FS=y
> # CONFIG_VFAT_FS is not set
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_NTFS_FS=y
> CONFIG_NTFS_DEBUG=y
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
> CONFIG_KERNFS=y
> CONFIG_SYSFS=y
> # CONFIG_TMPFS is not set
> CONFIG_HUGETLBFS=y
> CONFIG_HUGETLB_PAGE=y
> CONFIG_CONFIGFS_FS=m
> # CONFIG_MISC_FILESYSTEMS is not set
> CONFIG_NETWORK_FILESYSTEMS=y
> # CONFIG_NFS_FS is not set
> CONFIG_NFSD=m
> CONFIG_NFSD_V2_ACL=y
> CONFIG_NFSD_V3=y
> CONFIG_NFSD_V3_ACL=y
> # CONFIG_NFSD_V4 is not set
> CONFIG_LOCKD=m
> CONFIG_LOCKD_V4=y
> CONFIG_NFS_ACL_SUPPORT=m
> CONFIG_NFS_COMMON=y
> CONFIG_SUNRPC=m
> CONFIG_SUNRPC_DEBUG=y
> CONFIG_SUNRPC_XPRT_RDMA_CLIENT=m
> CONFIG_SUNRPC_XPRT_RDMA_SERVER=m
> # CONFIG_CEPH_FS is not set
> # CONFIG_CIFS is not set
> # CONFIG_NCP_FS is not set
> CONFIG_CODA_FS=y
> # CONFIG_AFS_FS is not set
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-1"
> CONFIG_NLS_CODEPAGE_437=y
> # CONFIG_NLS_CODEPAGE_737 is not set
> CONFIG_NLS_CODEPAGE_775=m
> # CONFIG_NLS_CODEPAGE_850 is not set
> CONFIG_NLS_CODEPAGE_852=m
> # CONFIG_NLS_CODEPAGE_855 is not set
> CONFIG_NLS_CODEPAGE_857=m
> CONFIG_NLS_CODEPAGE_860=m
> CONFIG_NLS_CODEPAGE_861=m
> CONFIG_NLS_CODEPAGE_862=m
> CONFIG_NLS_CODEPAGE_863=y
> # CONFIG_NLS_CODEPAGE_864 is not set
> CONFIG_NLS_CODEPAGE_865=m
> # CONFIG_NLS_CODEPAGE_866 is not set
> # CONFIG_NLS_CODEPAGE_869 is not set
> CONFIG_NLS_CODEPAGE_936=m
> # CONFIG_NLS_CODEPAGE_950 is not set
> # CONFIG_NLS_CODEPAGE_932 is not set
> CONFIG_NLS_CODEPAGE_949=m
> CONFIG_NLS_CODEPAGE_874=y
> # CONFIG_NLS_ISO8859_8 is not set
> CONFIG_NLS_CODEPAGE_1250=y
> CONFIG_NLS_CODEPAGE_1251=m
> # CONFIG_NLS_ASCII is not set
> CONFIG_NLS_ISO8859_1=m
> CONFIG_NLS_ISO8859_2=y
> # CONFIG_NLS_ISO8859_3 is not set
> CONFIG_NLS_ISO8859_4=m
> CONFIG_NLS_ISO8859_5=m
> CONFIG_NLS_ISO8859_6=y
> # CONFIG_NLS_ISO8859_7 is not set
> CONFIG_NLS_ISO8859_9=m
> # CONFIG_NLS_ISO8859_13 is not set
> # CONFIG_NLS_ISO8859_14 is not set
> # CONFIG_NLS_ISO8859_15 is not set
> CONFIG_NLS_KOI8_R=y
> CONFIG_NLS_KOI8_U=y
> CONFIG_NLS_MAC_ROMAN=y
> CONFIG_NLS_MAC_CELTIC=m
> CONFIG_NLS_MAC_CENTEURO=y
> CONFIG_NLS_MAC_CROATIAN=m
> # CONFIG_NLS_MAC_CYRILLIC is not set
> CONFIG_NLS_MAC_GAELIC=m
> CONFIG_NLS_MAC_GREEK=m
> CONFIG_NLS_MAC_ICELAND=y
> CONFIG_NLS_MAC_INUIT=y
> # CONFIG_NLS_MAC_ROMANIAN is not set
> CONFIG_NLS_MAC_TURKISH=y
> CONFIG_NLS_UTF8=m
> CONFIG_DLM=m
> # CONFIG_DLM_DEBUG is not set
> 
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> 
> #
> # printk and dmesg options
> #
> CONFIG_PRINTK_TIME=y
> CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
> # CONFIG_BOOT_PRINTK_DELAY is not set
> # CONFIG_DYNAMIC_DEBUG is not set
> 
> #
> # Compile-time checks and compiler options
> #
> # CONFIG_DEBUG_INFO is not set
> CONFIG_ENABLE_WARN_DEPRECATED=y
> # CONFIG_ENABLE_MUST_CHECK is not set
> CONFIG_FRAME_WARN=1024
> CONFIG_STRIP_ASM_SYMS=y
> # CONFIG_READABLE_ASM is not set
> # CONFIG_UNUSED_SYMBOLS is not set
> CONFIG_DEBUG_FS=y
> CONFIG_HEADERS_CHECK=y
> # CONFIG_DEBUG_SECTION_MISMATCH is not set
> CONFIG_ARCH_WANT_FRAME_POINTERS=y
> CONFIG_FRAME_POINTER=y
> # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
> CONFIG_MAGIC_SYSRQ=y
> CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
> CONFIG_DEBUG_KERNEL=y
> 
> #
> # Memory Debugging
> #
> CONFIG_DEBUG_PAGEALLOC=y
> CONFIG_WANT_PAGE_DEBUG_FLAGS=y
> CONFIG_PAGE_GUARD=y
> CONFIG_DEBUG_OBJECTS=y
> # CONFIG_DEBUG_OBJECTS_SELFTEST is not set
> CONFIG_DEBUG_OBJECTS_FREE=y
> CONFIG_DEBUG_OBJECTS_TIMERS=y
> # CONFIG_DEBUG_OBJECTS_WORK is not set
> # CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
> # CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
> CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
> # CONFIG_DEBUG_SLAB is not set
> CONFIG_HAVE_DEBUG_KMEMLEAK=y
> # CONFIG_DEBUG_KMEMLEAK is not set
> CONFIG_DEBUG_STACK_USAGE=y
> # CONFIG_DEBUG_VM is not set
> CONFIG_DEBUG_VIRTUAL=y
> CONFIG_DEBUG_MEMORY_INIT=y
> CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=m
> CONFIG_DEBUG_PER_CPU_MAPS=y
> CONFIG_DEBUG_HIGHMEM=y
> CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
> CONFIG_DEBUG_STACKOVERFLOW=y
> CONFIG_HAVE_ARCH_KMEMCHECK=y
> # CONFIG_DEBUG_SHIRQ is not set
> 
> #
> # Debug Lockups and Hangs
> #
> CONFIG_LOCKUP_DETECTOR=y
> CONFIG_HARDLOCKUP_DETECTOR=y
> # CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
> CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
> CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
> CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
> # CONFIG_DETECT_HUNG_TASK is not set
> # CONFIG_PANIC_ON_OOPS is not set
> CONFIG_PANIC_ON_OOPS_VALUE=0
> CONFIG_PANIC_TIMEOUT=0
> CONFIG_SCHED_DEBUG=y
> CONFIG_SCHEDSTATS=y
> # CONFIG_TIMER_STATS is not set
> # CONFIG_DEBUG_PREEMPT is not set
> 
> #
> # Lock Debugging (spinlocks, mutexes, etc...)
> #
> CONFIG_DEBUG_RT_MUTEXES=y
> CONFIG_RT_MUTEX_TESTER=y
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> # CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
> CONFIG_DEBUG_LOCK_ALLOC=y
> CONFIG_PROVE_LOCKING=y
> CONFIG_LOCKDEP=y
> # CONFIG_LOCK_STAT is not set
> # CONFIG_DEBUG_LOCKDEP is not set
> CONFIG_DEBUG_ATOMIC_SLEEP=y
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> # CONFIG_LOCK_TORTURE_TEST is not set
> CONFIG_TRACE_IRQFLAGS=y
> CONFIG_STACKTRACE=y
> # CONFIG_DEBUG_KOBJECT is not set
> # CONFIG_DEBUG_KOBJECT_RELEASE is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> # CONFIG_DEBUG_LIST is not set
> # CONFIG_DEBUG_PI_LIST is not set
> # CONFIG_DEBUG_SG is not set
> # CONFIG_DEBUG_NOTIFIERS is not set
> # CONFIG_DEBUG_CREDENTIALS is not set
> 
> #
> # RCU Debugging
> #
> CONFIG_PROVE_RCU=y
> # CONFIG_PROVE_RCU_REPEATEDLY is not set
> # CONFIG_PROVE_RCU_DELAY is not set
> # CONFIG_SPARSE_RCU_POINTER is not set
> # CONFIG_TORTURE_TEST is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> CONFIG_RCU_CPU_STALL_TIMEOUT=21
> CONFIG_RCU_CPU_STALL_VERBOSE=y
> CONFIG_RCU_CPU_STALL_INFO=y
> CONFIG_RCU_TRACE=y
> # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> CONFIG_NOTIFIER_ERROR_INJECTION=y
> CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
> CONFIG_PM_NOTIFIER_ERROR_INJECT=y
> # CONFIG_FAULT_INJECTION is not set
> CONFIG_LATENCYTOP=y
> CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
> # CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
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
> CONFIG_RING_BUFFER_ALLOW_SWAP=y
> CONFIG_TRACING=y
> CONFIG_GENERIC_TRACER=y
> CONFIG_TRACING_SUPPORT=y
> CONFIG_FTRACE=y
> CONFIG_FUNCTION_TRACER=y
> # CONFIG_FUNCTION_GRAPH_TRACER is not set
> CONFIG_IRQSOFF_TRACER=y
> # CONFIG_PREEMPT_TRACER is not set
> # CONFIG_SCHED_TRACER is not set
> CONFIG_FTRACE_SYSCALLS=y
> CONFIG_TRACER_SNAPSHOT=y
> CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
> CONFIG_BRANCH_PROFILE_NONE=y
> # CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
> # CONFIG_PROFILE_ALL_BRANCHES is not set
> # CONFIG_STACK_TRACER is not set
> # CONFIG_BLK_DEV_IO_TRACE is not set
> CONFIG_UPROBE_EVENT=y
> CONFIG_PROBE_EVENTS=y
> CONFIG_DYNAMIC_FTRACE=y
> CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
> # CONFIG_FUNCTION_PROFILER is not set
> CONFIG_FTRACE_MCOUNT_RECORD=y
> # CONFIG_FTRACE_STARTUP_TEST is not set
> CONFIG_MMIOTRACE=y
> # CONFIG_MMIOTRACE_TEST is not set
> # CONFIG_TRACEPOINT_BENCHMARK is not set
> CONFIG_RING_BUFFER_BENCHMARK=m
> # CONFIG_RING_BUFFER_STARTUP_TEST is not set
> 
> #
> # Runtime Testing
> #
> # CONFIG_LKDTM is not set
> # CONFIG_TEST_LIST_SORT is not set
> # CONFIG_BACKTRACE_SELF_TEST is not set
> CONFIG_RBTREE_TEST=m
> # CONFIG_INTERVAL_TREE_TEST is not set
> CONFIG_PERCPU_TEST=m
> CONFIG_ATOMIC64_SELFTEST=y
> CONFIG_TEST_STRING_HELPERS=y
> # CONFIG_TEST_KSTRTOX is not set
> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> # CONFIG_BUILD_DOCSRC is not set
> # CONFIG_DMA_API_DEBUG is not set
> CONFIG_TEST_MODULE=m
> # CONFIG_TEST_USER_COPY is not set
> CONFIG_TEST_BPF=m
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_KGDB is not set
> # CONFIG_STRICT_DEVMEM is not set
> CONFIG_X86_VERBOSE_BOOTUP=y
> CONFIG_EARLY_PRINTK=y
> CONFIG_EARLY_PRINTK_DBGP=y
> CONFIG_X86_PTDUMP=y
> CONFIG_DEBUG_RODATA=y
> CONFIG_DEBUG_RODATA_TEST=y
> CONFIG_DEBUG_SET_MODULE_RONX=y
> # CONFIG_DEBUG_NX_TEST is not set
> CONFIG_DOUBLEFAULT=y
> CONFIG_DEBUG_TLBFLUSH=y
> # CONFIG_IOMMU_STRESS is not set
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> # CONFIG_IO_DELAY_0X80 is not set
> # CONFIG_IO_DELAY_0XED is not set
> CONFIG_IO_DELAY_UDELAY=y
> # CONFIG_IO_DELAY_NONE is not set
> CONFIG_DEFAULT_IO_DELAY_TYPE=2
> CONFIG_DEBUG_BOOT_PARAMS=y
> # CONFIG_CPA_DEBUG is not set
> CONFIG_OPTIMIZE_INLINING=y
> # CONFIG_DEBUG_NMI_SELFTEST is not set
> CONFIG_X86_DEBUG_STATIC_CPU_HAS=y
> 
> #
> # Security options
> #
> CONFIG_KEYS=y
> # CONFIG_PERSISTENT_KEYRINGS is not set
> CONFIG_TRUSTED_KEYS=m
> CONFIG_ENCRYPTED_KEYS=y
> CONFIG_KEYS_DEBUG_PROC_KEYS=y
> # CONFIG_SECURITY_DMESG_RESTRICT is not set
> CONFIG_SECURITY=y
> CONFIG_SECURITYFS=y
> CONFIG_SECURITY_NETWORK=y
> # CONFIG_SECURITY_NETWORK_XFRM is not set
> CONFIG_SECURITY_PATH=y
> CONFIG_LSM_MMAP_MIN_ADDR=65536
> CONFIG_SECURITY_SELINUX=y
> # CONFIG_SECURITY_SELINUX_BOOTPARAM is not set
> CONFIG_SECURITY_SELINUX_DISABLE=y
> # CONFIG_SECURITY_SELINUX_DEVELOP is not set
> # CONFIG_SECURITY_SELINUX_AVC_STATS is not set
> CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
> CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX=y
> CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX_VALUE=19
> CONFIG_SECURITY_SMACK=y
> # CONFIG_SECURITY_TOMOYO is not set
> CONFIG_SECURITY_APPARMOR=y
> CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
> # CONFIG_SECURITY_APPARMOR_HASH is not set
> CONFIG_SECURITY_YAMA=y
> CONFIG_SECURITY_YAMA_STACKED=y
> CONFIG_INTEGRITY=y
> # CONFIG_INTEGRITY_SIGNATURE is not set
> CONFIG_INTEGRITY_AUDIT=y
> CONFIG_IMA=y
> CONFIG_IMA_MEASURE_PCR_IDX=10
> CONFIG_IMA_LSM_RULES=y
> # CONFIG_IMA_TEMPLATE is not set
> CONFIG_IMA_NG_TEMPLATE=y
> # CONFIG_IMA_SIG_TEMPLATE is not set
> CONFIG_IMA_DEFAULT_TEMPLATE="ima-ng"
> # CONFIG_IMA_DEFAULT_HASH_SHA1 is not set
> # CONFIG_IMA_DEFAULT_HASH_SHA256 is not set
> CONFIG_IMA_DEFAULT_HASH_SHA512=y
> # CONFIG_IMA_DEFAULT_HASH_WP512 is not set
> CONFIG_IMA_DEFAULT_HASH="sha512"
> CONFIG_IMA_APPRAISE=y
> CONFIG_EVM=y
> 
> #
> # EVM options
> #
> CONFIG_EVM_ATTR_FSUUID=y
> CONFIG_EVM_EXTRA_SMACK_XATTRS=y
> CONFIG_DEFAULT_SECURITY_SELINUX=y
> # CONFIG_DEFAULT_SECURITY_SMACK is not set
> # CONFIG_DEFAULT_SECURITY_APPARMOR is not set
> # CONFIG_DEFAULT_SECURITY_YAMA is not set
> # CONFIG_DEFAULT_SECURITY_DAC is not set
> CONFIG_DEFAULT_SECURITY="selinux"
> CONFIG_CRYPTO=y
> 
> #
> # Crypto core or helper
> #
> # CONFIG_CRYPTO_FIPS is not set
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_ALGAPI2=y
> CONFIG_CRYPTO_AEAD=y
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
> # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
> CONFIG_CRYPTO_GF128MUL=y
> CONFIG_CRYPTO_NULL=y
> # CONFIG_CRYPTO_PCRYPT is not set
> CONFIG_CRYPTO_WORKQUEUE=y
> CONFIG_CRYPTO_CRYPTD=y
> CONFIG_CRYPTO_AUTHENC=y
> CONFIG_CRYPTO_TEST=m
> CONFIG_CRYPTO_ABLK_HELPER=m
> 
> #
> # Authenticated Encryption with Associated Data
> #
> CONFIG_CRYPTO_CCM=m
> CONFIG_CRYPTO_GCM=y
> CONFIG_CRYPTO_SEQIV=y
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=y
> CONFIG_CRYPTO_CTR=y
> # CONFIG_CRYPTO_CTS is not set
> CONFIG_CRYPTO_ECB=m
> CONFIG_CRYPTO_LRW=y
> CONFIG_CRYPTO_PCBC=y
> CONFIG_CRYPTO_XTS=m
> 
> #
> # Hash modes
> #
> CONFIG_CRYPTO_CMAC=m
> CONFIG_CRYPTO_HMAC=y
> CONFIG_CRYPTO_XCBC=m
> CONFIG_CRYPTO_VMAC=y
> 
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=y
> CONFIG_CRYPTO_CRC32C_INTEL=m
> # CONFIG_CRYPTO_CRC32 is not set
> # CONFIG_CRYPTO_CRC32_PCLMUL is not set
> CONFIG_CRYPTO_CRCT10DIF=y
> CONFIG_CRYPTO_GHASH=y
> CONFIG_CRYPTO_MD4=y
> CONFIG_CRYPTO_MD5=y
> CONFIG_CRYPTO_MICHAEL_MIC=m
> # CONFIG_CRYPTO_RMD128 is not set
> CONFIG_CRYPTO_RMD160=y
> # CONFIG_CRYPTO_RMD256 is not set
> CONFIG_CRYPTO_RMD320=y
> CONFIG_CRYPTO_SHA1=y
> CONFIG_CRYPTO_SHA256=y
> CONFIG_CRYPTO_SHA512=y
> CONFIG_CRYPTO_TGR192=y
> CONFIG_CRYPTO_WP512=y
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> CONFIG_CRYPTO_AES_586=m
> CONFIG_CRYPTO_AES_NI_INTEL=m
> # CONFIG_CRYPTO_ANUBIS is not set
> CONFIG_CRYPTO_ARC4=y
> # CONFIG_CRYPTO_BLOWFISH is not set
> # CONFIG_CRYPTO_CAMELLIA is not set
> CONFIG_CRYPTO_CAST_COMMON=y
> CONFIG_CRYPTO_CAST5=y
> # CONFIG_CRYPTO_CAST6 is not set
> CONFIG_CRYPTO_DES=y
> CONFIG_CRYPTO_FCRYPT=y
> # CONFIG_CRYPTO_KHAZAD is not set
> # CONFIG_CRYPTO_SALSA20 is not set
> CONFIG_CRYPTO_SALSA20_586=m
> CONFIG_CRYPTO_SEED=y
> CONFIG_CRYPTO_SERPENT=y
> # CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
> CONFIG_CRYPTO_TEA=y
> CONFIG_CRYPTO_TWOFISH=m
> CONFIG_CRYPTO_TWOFISH_COMMON=m
> CONFIG_CRYPTO_TWOFISH_586=m
> 
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=y
> CONFIG_CRYPTO_ZLIB=m
> CONFIG_CRYPTO_LZO=m
> # CONFIG_CRYPTO_LZ4 is not set
> CONFIG_CRYPTO_LZ4HC=m
> 
> #
> # Random Number Generation
> #
> CONFIG_CRYPTO_ANSI_CPRNG=y
> CONFIG_CRYPTO_USER_API=m
> # CONFIG_CRYPTO_USER_API_HASH is not set
> CONFIG_CRYPTO_USER_API_SKCIPHER=m
> CONFIG_CRYPTO_HASH_INFO=y
> # CONFIG_CRYPTO_HW is not set
> CONFIG_ASYMMETRIC_KEY_TYPE=y
> CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
> CONFIG_PUBLIC_KEY_ALGO_RSA=y
> CONFIG_X509_CERTIFICATE_PARSER=y
> CONFIG_HAVE_KVM=y
> CONFIG_HAVE_KVM_IRQCHIP=y
> CONFIG_HAVE_KVM_IRQ_ROUTING=y
> CONFIG_HAVE_KVM_EVENTFD=y
> CONFIG_KVM_APIC_ARCHITECTURE=y
> CONFIG_KVM_MMIO=y
> CONFIG_KVM_ASYNC_PF=y
> CONFIG_HAVE_KVM_MSI=y
> CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
> CONFIG_KVM_VFIO=y
> CONFIG_VIRTUALIZATION=y
> CONFIG_KVM=y
> CONFIG_KVM_INTEL=y
> CONFIG_KVM_AMD=m
> CONFIG_KVM_MMU_AUDIT=y
> CONFIG_LGUEST=m
> CONFIG_BINARY_PRINTF=y
> 
> #
> # Library routines
> #
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_STRNCPY_FROM_USER=y
> CONFIG_GENERIC_STRNLEN_USER=y
> CONFIG_GENERIC_NET_UTILS=y
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_GENERIC_PCI_IOMAP=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_IO=y
> CONFIG_PERCPU_RWSEM=y
> CONFIG_CRC_CCITT=y
> CONFIG_CRC16=y
> CONFIG_CRC_T10DIF=y
> CONFIG_CRC_ITU_T=y
> CONFIG_CRC32=y
> CONFIG_CRC32_SELFTEST=y
> # CONFIG_CRC32_SLICEBY8 is not set
> CONFIG_CRC32_SLICEBY4=y
> # CONFIG_CRC32_SARWATE is not set
> # CONFIG_CRC32_BIT is not set
> CONFIG_CRC7=y
> CONFIG_LIBCRC32C=y
> CONFIG_CRC8=m
> CONFIG_AUDIT_GENERIC=y
> # CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
> CONFIG_RANDOM32_SELFTEST=y
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_LZO_COMPRESS=y
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_LZ4HC_COMPRESS=m
> CONFIG_LZ4_DECOMPRESS=y
> CONFIG_XZ_DEC=y
> CONFIG_XZ_DEC_X86=y
> CONFIG_XZ_DEC_POWERPC=y
> CONFIG_XZ_DEC_IA64=y
> CONFIG_XZ_DEC_ARM=y
> CONFIG_XZ_DEC_ARMTHUMB=y
> CONFIG_XZ_DEC_SPARC=y
> CONFIG_XZ_DEC_BCJ=y
> CONFIG_XZ_DEC_TEST=m
> CONFIG_DECOMPRESS_GZIP=y
> CONFIG_DECOMPRESS_BZIP2=y
> CONFIG_DECOMPRESS_LZMA=y
> CONFIG_DECOMPRESS_XZ=y
> CONFIG_DECOMPRESS_LZO=y
> CONFIG_DECOMPRESS_LZ4=y
> CONFIG_GENERIC_ALLOCATOR=y
> CONFIG_ASSOCIATIVE_ARRAY=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT_MAP=y
> CONFIG_HAS_DMA=y
> CONFIG_CHECK_SIGNATURE=y
> # CONFIG_CPUMASK_OFFSTACK is not set
> CONFIG_CPU_RMAP=y
> CONFIG_DQL=y
> CONFIG_NLATTR=y
> CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
> CONFIG_AVERAGE=y
> CONFIG_CLZ_TAB=y
> # CONFIG_CORDIC is not set
> # CONFIG_DDR is not set
> CONFIG_MPILIB=y
> CONFIG_OID_REGISTRY=y
> CONFIG_FONT_SUPPORT=m
> # CONFIG_FONTS is not set
> CONFIG_FONT_8x8=y
> CONFIG_FONT_8x16=y

> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com


-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

