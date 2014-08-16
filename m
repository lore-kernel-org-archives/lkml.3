Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbaHPUJj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 16:09:39 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46204 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbaHPUJg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 16:09:36 -0400
Date: Sat, 16 Aug 2014 21:09:30 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>,
        Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [pcibios_root_bridge_prepare] BUG: unable to handle kernel NULL
 pointer dereference
Message-ID: <20140816200930.GB25439@e106497-lin.cambridge.arm.com>
References: <20140816060851.GA22098@localhost>
MIME-Version: 1.0
In-Reply-To: <20140816060851.GA22098@localhost>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 16 Aug 2014 20:09:31.0023 (UTC) FILETIME=[FD6B51F0:01CFB98D]
X-MC-Unique: 114081621093200201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2014 at 07:08:51AM +0100, Fengguang Wu wrote:
> Greetings,
> 
> 0day kernel testing robot got the below dmesg and the first bad commit is
> 
> git://git.linaro.org/people/cdall/linux-kvm-arm apm_linux_v3.16-rc1
> commit 6f99bc949b1c90ff342a7d44ac4122322a7ccb78
> Author:     Liviu Dudau <Liviu.Dudau@arm.com>
> AuthorDate: Thu Jun 5 15:20:38 2014 +0530
> Commit:     Christoffer Dall <christoffer.dall@linaro.org>
> CommitDate: Fri Jul 11 06:34:50 2014 -0700

There is a newer version of this patch series. Can you drop your existing one (that I have
sent a patch for but it seems to drop out of your stack every now and then) and switch to
the v9 patch series?

Best regards,
Liviu

> 
>     pci: Create pci_host_bridge before its associated bus in pci_create_root_bus.
>     
>     Before commit 7b5436635800 the pci_host_bridge was created before the root bus.
>     As that commit has added a needless dependency on the bus for pci_alloc_host_bridge()
>     the creation order has been changed for no good reason. Revert the order of
>     creation as we are going to depend on the pci_host_bridge structure to retrieve the
>     domain number of the root bus.
>     
>     Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
>     Acked-by: Grant Likely <grant.likely@linaro.org>
>     Tested-by: Tanmay Inamdar <tinamdar@apm.com>
> 
> +---------------------------------------------------------+------------+------------+------------+
> |                                                         | 175e014331 | 6f99bc949b | 2af469d82f |
> +---------------------------------------------------------+------------+------------+------------+
> | boot_successes                                          | 65         | 0          | 0          |
> | boot_failures                                           | 15         | 20         | 11         |
> | WARNING:CPU:PID:at_mm/early_ioremap.c:__early_ioremap() | 15         | 20         | 10         |
> | backtrace:acpi_initialize_tables                        | 15         | 20         | 10         |
> | backtrace:acpi_table_init                               | 15         | 20         | 10         |
> | backtrace:acpi_boot_table_init                          | 15         | 20         | 10         |
> | BUG:unable_to_handle_kernel_NULL_pointer_dereference    | 0          | 20         | 11         |
> | Oops                                                    | 0          | 20         | 11         |
> | EIP_is_at_pcibios_root_bridge_prepare                   | 0          | 20         | 11         |
> | Kernel_panic-not_syncing:Fatal_exception                | 0          | 20         | 11         |
> | backtrace:pcibios_scan_root                             | 0          | 20         | 10         |
> | backtrace:pci_legacy_init                               | 0          | 20         | 10         |
> | backtrace:pci_subsys_init                               | 0          | 20         | 10         |
> | backtrace:kernel_init_freeable                          | 0          | 20         | 11         |
> | backtrace:acpi_bus_scan                                 | 0          | 0          | 1          |
> | backtrace:acpi_scan_init                                | 0          | 0          | 1          |
> | backtrace:acpi_init                                     | 0          | 0          | 1          |
> +---------------------------------------------------------+------------+------------+------------+
> 
> [    0.167350] PCI: Probing PCI hardware
> [    0.167350] PCI: Probing PCI hardware
> [    0.168140] PCI: root bus 00: using default resources
> [    0.168140] PCI: root bus 00: using default resources
> [    0.169232] PCI: Probing PCI hardware (bus 00)
> [    0.169232] PCI: Probing PCI hardware (bus 00)
> [    0.170009] BUG: unable to handle kernel
> [    0.170009] BUG: unable to handle kernel NULL pointer dereferenceNULL pointer dereference at 00000064
>  at 00000064
> [    0.171553] IP:
> [    0.171553] IP: [<41726569>] pcibios_root_bridge_prepare+0x9/0x20
>  [<41726569>] pcibios_root_bridge_prepare+0x9/0x20
> [    0.172863] *pde = 00000000
> [    0.172863] *pde = 00000000
> 
> [    0.173498] Oops: 0000 [#1]
> [    0.173498] Oops: 0000 [#1] DEBUG_PAGEALLOCDEBUG_PAGEALLOC
> 
> [    0.174407] CPU: 0 PID: 1 Comm: swapper Tainted: G        W     3.16.0-rc1-00005-g6f99bc9 #1
> [    0.174407] CPU: 0 PID: 1 Comm: swapper Tainted: G        W     3.16.0-rc1-00005-g6f99bc9 #1
> [    0.176197] task: 40020d50 ti: 40022000 task.ti: 40022000
> [    0.176197] task: 40020d50 ti: 40022000 task.ti: 40022000
> [    0.177338] EIP: 0060:[<41726569>] EFLAGS: 00010206 CPU: 0
> [    0.177338] EIP: 0060:[<41726569>] EFLAGS: 00010206 CPU: 0
> [    0.178508] EIP is at pcibios_root_bridge_prepare+0x9/0x20
> [    0.178508] EIP is at pcibios_root_bridge_prepare+0x9/0x20
> [    0.179660] EAX: 40076c00 EBX: 40060880 ECX: 00000000 EDX: 00000000
> [    0.179660] EAX: 40076c00 EBX: 40060880 ECX: 00000000 EDX: 00000000
> [    0.180000] ESI: 40076c00 EDI: 00000000 EBP: 40023e14 ESP: 40023e14
> [    0.180000] ESI: 40076c00 EDI: 00000000 EBP: 40023e14 ESP: 40023e14
> [    0.180000]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
> [    0.180000]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
> [    0.180000] CR0: 8005003b CR2: 00000064 CR3: 01cd8000 CR4: 000006d0
> [    0.180000] CR0: 8005003b CR2: 00000064 CR3: 01cd8000 CR4: 000006d0
> 
> git bisect start 2af469d82fdf68c8315d47c424c614f097f34bfe c77dcacb397519b6ade8f08201a4a90a7f4f751e --
> git bisect good e854c688381e070be212422fce2cea1fb9d7c2ef  # 20:39     20+      5  arm/arm64: KVM: vgic: Improve handling of GICD_I{CS}PENDRn
> git bisect good 1b233bf6034bea4b76c8c0b17e4efd5971689ca9  # 20:44     20+      0  arm/arm64: KVM: vgic: Clarify and correct vgic documentation
> git bisect good e216fd3bc192cc5aadac841938d1eb4c8911d30f  # 20:47     20+      0  WIP: arm/arm64: KVM: Implement support for unqueueing active interrupts
> git bisect  bad 56485a95d9ffdb6b431ea00171e320112a992b40  # 20:50      0-     20  rtc: Fix suspend/resume for APM X-Gene SoC RTC driver
> git bisect  bad 2a146bde9a2b55d8d9e98a1f4b72ca694aa67879  # 20:53      0-     20  dt-bindings: pci: xgene pcie device tree bindings
> git bisect  bad 6f99bc949b1c90ff342a7d44ac4122322a7ccb78  # 20:56      0-     20  pci: Create pci_host_bridge before its associated bus in pci_create_root_bus.
> git bisect good d1eee6a841dd73ecd3cce0e70686152cc5789c91  # 21:01     20+     20  arm64: Add architecture support for PCI
> git bisect good 175e0143313927c52fd7b6b5b66c202e3d6ab31c  # 21:05     20+     15  pci: OF: Fix the conversion of IO ranges into IO resources.
> # first bad commit: [6f99bc949b1c90ff342a7d44ac4122322a7ccb78] pci: Create pci_host_bridge before its associated bus in pci_create_root_bus.
> git bisect good 175e0143313927c52fd7b6b5b66c202e3d6ab31c  # 21:07     60+     15  pci: OF: Fix the conversion of IO ranges into IO resources.
> git bisect  bad 2af469d82fdf68c8315d47c424c614f097f34bfe  # 21:07      0-     11  Merge remote-tracking branch 'linaro/apm_linux_v3.16-rc1' into mustang/vgic-active-unqueue
> git bisect good c9d26423e56ce1ab4d786f92aebecf859d419293  # 21:16     60+     60  Merge tag 'pm+acpi-3.17-rc1-2' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
> git bisect good 7bef919141fc53b780070a0aec3ddd893eeece8f  # 21:27     60+     60  Add linux-next specific files for 20140815
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
> 	-monitor null 
> )
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
> 	load_ramdisk=2
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
> Fengguang

> early console in setup code
> early console in decompress_kernel
> 
> Decompressing Linux... Parsing ELF... No relocation needed... done.
> Booting the kernel.
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.16.0-rc1-00005-g6f99bc9 (kbuild@lkp-hsx01) (gcc version 4.8.2 (Debian 4.8.2-18) ) #1 Fri Aug 15 20:54:48 CST 2014
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   NSC Geode by NSC
> [    0.000000]   Cyrix CyrixInstead
> [    0.000000]   Transmeta GenuineTMx86
> [    0.000000]   Transmeta TransmetaCPU
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] bootconsole [earlyser0] enabled
> [    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
> [    0.000000] Hypervisor detected: KVM
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x13fe0 max_arch_pfn = 0x100000
> [    0.000000] initial memory mapped: [mem 0x00000000-0x02bfffff]
> [    0.000000] Base memory trampoline at [4009b000] 9b000 size 16384
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x12000000-0x123fffff]
> [    0.000000]  [mem 0x12000000-0x123fffff] page 4k
> [    0.000000] BRK [0x0231a000, 0x0231afff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x10000000-0x11ffffff]
> [    0.000000]  [mem 0x10000000-0x11ffffff] page 4k
> [    0.000000] BRK [0x0231b000, 0x0231bfff] PGTABLE
> [    0.000000] BRK [0x0231c000, 0x0231cfff] PGTABLE
> [    0.000000] BRK [0x0231d000, 0x0231dfff] PGTABLE
> [    0.000000] BRK [0x0231e000, 0x0231efff] PGTABLE
> [    0.000000] BRK [0x0231f000, 0x0231ffff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
> [    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x12400000-0x13fdffff]
> [    0.000000]  [mem 0x12400000-0x13fdffff] page 4k
> [    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
> [    0.000000] Allocated new RAMDISK: [mem 0x10b7c000-0x123c03cc]
> [    0.000000] Move RAMDISK from [mem 0x127ab000-0x13fef3cc] to [mem 0x10b7c000-0x123c03cc]
> [    0.000000] ACPI: Early table checksum verification disabled
> [    0.000000] ACPI: RSDP 0x000F0C90 000014 (v00 BOCHS )
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: CPU: 0 PID: 0 at mm/early_ioremap.c:121 __early_ioremap+0x98/0x1a7()
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.16.0-rc1-00005-g6f99bc9 #1
> [    0.000000]  00000000 00000000 41a77e1c 417683d0 41a77e4c 41041d9f 419bb740 00000000
> [    0.000000]  00000000 419c1d18 00000079 41c8960c 41c8960c 13fe18bd f86b52b5 00000000
> [    0.000000]  41a77e5c 41041e6b 00000009 00000000 41a77eb0 41c8960c 0000015b 41a77e74
> [    0.000000] Call Trace:
> [    0.000000]  [<417683d0>] dump_stack+0x16/0x18
> [    0.000000]  [<41041d9f>] warn_slowpath_common+0x6f/0x90
> [    0.000000]  [<41c8960c>] ? __early_ioremap+0x98/0x1a7
> [    0.000000]  [<41c8960c>] ? __early_ioremap+0x98/0x1a7
> [    0.000000]  [<41041e6b>] warn_slowpath_null+0x1b/0x20
> [    0.000000]  [<41c8960c>] __early_ioremap+0x98/0x1a7
> [    0.000000]  [<41034264>] ? native_set_fixmap+0x34/0x40
> [    0.000000]  [<41c89897>] ? early_iounmap+0x108/0x126
> [    0.000000]  [<41c898c2>] early_ioremap+0xd/0xf
> [    0.000000]  [<41c7bd23>] __acpi_map_table+0x10/0x15
> [    0.000000]  [<41763c59>] acpi_os_map_iomem+0x1b/0x115
> [    0.000000]  [<41763d5b>] acpi_os_map_memory+0x8/0xa
> [    0.000000]  [<41c8fd30>] acpi_tb_parse_root_table+0x14e/0x29a
> [    0.000000]  [<41c8ff2d>] acpi_initialize_tables+0xb1/0xdc
> [    0.000000]  [<41c8e979>] acpi_table_init+0x48/0xc4
> [    0.000000]  [<41c7c074>] acpi_boot_table_init+0x12/0x71
> [    0.000000]  [<41c7571c>] setup_arch+0xb0b/0xbf1
> [    0.000000]  [<41c728af>] start_kernel+0xae/0x3f5
> [    0.000000]  [<41c723b0>] i386_start_kernel+0x15e/0x161
> [    0.000000] ---[ end trace 05e0c07eb1c663a6 ]---
> [    0.000000] 0MB HIGHMEM available.
> [    0.000000] 319MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 13fe0000
> [    0.000000]   low ram: 0 - 13fe0000
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:13fdf001, primary cpu clock
> [    0.000000] Zone ranges:
> [    0.000000]   Normal   [mem 0x00001000-0x13fdffff]
> [    0.000000]   HighMem  empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
> [    0.000000] On node 0 totalpages: 81790
> [    0.000000]   Normal zone: 720 pages used for memmap
> [    0.000000]   Normal zone: 0 pages reserved
> [    0.000000]   Normal zone: 81790 pages, LIFO batch:15
> [    0.000000] Using APIC driver default
> [    0.000000] Found and enabled local APIC!
> [    0.000000] mapped APIC to         ffffc000 (        fee00000)
> [    0.000000] nr_irqs_gsi: 16
> [    0.000000] KVM setup async PF for cpu 0
> [    0.000000] kvm-stealtime: cpu 0, msr 1a8d380
> [    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on KVM
> [    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
> [    0.000000] pcpu-alloc: [0] 0 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 81070
> [    0.000000] Kernel command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/i386-randconfig-ha1-0814/cdall-kvm-arm:mustang:vgic-active-unqueue:6f99bc949b1c90ff342a7d44ac4122322a7ccb78:bisect-linux-8/.vmlinuz-6f99bc949b1c90ff342a7d44ac4122322a7ccb78-20140815205453-3-lkp-nex04 branch=cdall-kvm-arm/mustang/vgic-active-unqueue BOOT_IMAGE=/kernel/i386-randconfig-ha1-0814/6f99bc949b1c90ff342a7d44ac4122322a7ccb78/vmlinuz-3.16.0-rc1-00005-g6f99bc9 drbd.minor_count=8
> [    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
> [    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.000000] Initializing CPU#0
> [    0.000000] Initializing HighMem for node 0 (00000000:00000000)
> [    0.000000] Memory: 279052K/327160K available (7645K kernel code, 2030K rwdata, 3056K rodata, 396K init, 6376K bss, 48108K reserved, 0K highmem)
> [    0.000000] virtual kernel memory layout:
> [    0.000000]     fixmap  : 0xfffa3000 - 0xfffff000   ( 368 kB)
> [    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
> [    0.000000]     vmalloc : 0x547e0000 - 0xff7fe000   (2736 MB)
> [    0.000000]     lowmem  : 0x40000000 - 0x53fe0000   ( 319 MB)
> [    0.000000]       .init : 0x41c72000 - 0x41cd5000   ( 396 kB)
> [    0.000000]       .data : 0x41777821 - 0x41c70800   (5091 kB)
> [    0.000000]       .text : 0x41000000 - 0x41777821   (7646 kB)
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000000] NR_IRQS:2304 nr_irqs:256 16
> [    0.000000] CPU 0 irqstacks, hard=40094000 soft=40096000
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.16.0-rc1-00005-g6f99bc9 (kbuild@lkp-hsx01) (gcc version 4.8.2 (Debian 4.8.2-18) ) #1 Fri Aug 15 20:54:48 CST 2014
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   NSC Geode by NSC
> [    0.000000]   Cyrix CyrixInstead
> [    0.000000]   Transmeta GenuineTMx86
> [    0.000000]   Transmeta TransmetaCPU
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] bootconsole [earlyser0] enabled
> [    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
> [    0.000000] Hypervisor detected: KVM
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x13fe0 max_arch_pfn = 0x100000
> [    0.000000] initial memory mapped: [mem 0x00000000-0x02bfffff]
> [    0.000000] Base memory trampoline at [4009b000] 9b000 size 16384
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x12000000-0x123fffff]
> [    0.000000]  [mem 0x12000000-0x123fffff] page 4k
> [    0.000000] BRK [0x0231a000, 0x0231afff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x10000000-0x11ffffff]
> [    0.000000]  [mem 0x10000000-0x11ffffff] page 4k
> [    0.000000] BRK [0x0231b000, 0x0231bfff] PGTABLE
> [    0.000000] BRK [0x0231c000, 0x0231cfff] PGTABLE
> [    0.000000] BRK [0x0231d000, 0x0231dfff] PGTABLE
> [    0.000000] BRK [0x0231e000, 0x0231efff] PGTABLE
> [    0.000000] BRK [0x0231f000, 0x0231ffff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
> [    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x12400000-0x13fdffff]
> [    0.000000]  [mem 0x12400000-0x13fdffff] page 4k
> [    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
> [    0.000000] Allocated new RAMDISK: [mem 0x10b7c000-0x123c03cc]
> [    0.000000] Move RAMDISK from [mem 0x127ab000-0x13fef3cc] to [mem 0x10b7c000-0x123c03cc]
> [    0.000000] ACPI: Early table checksum verification disabled
> [    0.000000] ACPI: RSDP 0x000F0C90 000014 (v00 BOCHS )
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: CPU: 0 PID: 0 at mm/early_ioremap.c:121 __early_ioremap+0x98/0x1a7()
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.16.0-rc1-00005-g6f99bc9 #1
> [    0.000000]  00000000 00000000 41a77e1c 417683d0 41a77e4c 41041d9f 419bb740 00000000
> [    0.000000]  00000000 419c1d18 00000079 41c8960c 41c8960c 13fe18bd f86b52b5 00000000
> [    0.000000]  41a77e5c 41041e6b 00000009 00000000 41a77eb0 41c8960c 0000015b 41a77e74
> [    0.000000] Call Trace:
> [    0.000000]  [<417683d0>] dump_stack+0x16/0x18
> [    0.000000]  [<41041d9f>] warn_slowpath_common+0x6f/0x90
> [    0.000000]  [<41c8960c>] ? __early_ioremap+0x98/0x1a7
> [    0.000000]  [<41c8960c>] ? __early_ioremap+0x98/0x1a7
> [    0.000000]  [<41041e6b>] warn_slowpath_null+0x1b/0x20
> [    0.000000]  [<41c8960c>] __early_ioremap+0x98/0x1a7
> [    0.000000]  [<41034264>] ? native_set_fixmap+0x34/0x40
> [    0.000000]  [<41c89897>] ? early_iounmap+0x108/0x126
> [    0.000000]  [<41c898c2>] early_ioremap+0xd/0xf
> [    0.000000]  [<41c7bd23>] __acpi_map_table+0x10/0x15
> [    0.000000]  [<41763c59>] acpi_os_map_iomem+0x1b/0x115
> [    0.000000]  [<41763d5b>] acpi_os_map_memory+0x8/0xa
> [    0.000000]  [<41c8fd30>] acpi_tb_parse_root_table+0x14e/0x29a
> [    0.000000]  [<41c8ff2d>] acpi_initialize_tables+0xb1/0xdc
> [    0.000000]  [<41c8e979>] acpi_table_init+0x48/0xc4
> [    0.000000]  [<41c7c074>] acpi_boot_table_init+0x12/0x71
> [    0.000000]  [<41c7571c>] setup_arch+0xb0b/0xbf1
> [    0.000000]  [<41c728af>] start_kernel+0xae/0x3f5
> [    0.000000]  [<41c723b0>] i386_start_kernel+0x15e/0x161
> [    0.000000] ---[ end trace 05e0c07eb1c663a6 ]---
> [    0.000000] 0MB HIGHMEM available.
> [    0.000000] 319MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 13fe0000
> [    0.000000]   low ram: 0 - 13fe0000
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:13fdf001, primary cpu clock
> [    0.000000] Zone ranges:
> [    0.000000]   Normal   [mem 0x00001000-0x13fdffff]
> [    0.000000]   HighMem  empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
> [    0.000000] On node 0 totalpages: 81790
> [    0.000000]   Normal zone: 720 pages used for memmap
> [    0.000000]   Normal zone: 0 pages reserved
> [    0.000000]   Normal zone: 81790 pages, LIFO batch:15
> [    0.000000] Using APIC driver default
> [    0.000000] Found and enabled local APIC!
> [    0.000000] mapped APIC to         ffffc000 (        fee00000)
> [    0.000000] nr_irqs_gsi: 16
> [    0.000000] KVM setup async PF for cpu 0
> [    0.000000] kvm-stealtime: cpu 0, msr 1a8d380
> [    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on KVM
> [    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
> [    0.000000] pcpu-alloc: [0] 0 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 81070
> [    0.000000] Kernel command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/i386-randconfig-ha1-0814/cdall-kvm-arm:mustang:vgic-active-unqueue:6f99bc949b1c90ff342a7d44ac4122322a7ccb78:bisect-linux-8/.vmlinuz-6f99bc949b1c90ff342a7d44ac4122322a7ccb78-20140815205453-3-lkp-nex04 branch=cdall-kvm-arm/mustang/vgic-active-unqueue BOOT_IMAGE=/kernel/i386-randconfig-ha1-0814/6f99bc949b1c90ff342a7d44ac4122322a7ccb78/vmlinuz-3.16.0-rc1-00005-g6f99bc9 drbd.minor_count=8
> [    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
> [    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.000000] Initializing CPU#0
> [    0.000000] Initializing HighMem for node 0 (00000000:00000000)
> [    0.000000] Memory: 279052K/327160K available (7645K kernel code, 2030K rwdata, 3056K rodata, 396K init, 6376K bss, 48108K reserved, 0K highmem)
> [    0.000000] virtual kernel memory layout:
> [    0.000000]     fixmap  : 0xfffa3000 - 0xfffff000   ( 368 kB)
> [    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
> [    0.000000]     vmalloc : 0x547e0000 - 0xff7fe000   (2736 MB)
> [    0.000000]     lowmem  : 0x40000000 - 0x53fe0000   ( 319 MB)
> [    0.000000]       .init : 0x41c72000 - 0x41cd5000   ( 396 kB)
> [    0.000000]       .data : 0x41777821 - 0x41c70800   (5091 kB)
> [    0.000000]       .text : 0x41000000 - 0x41777821   (7646 kB)
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000000] NR_IRQS:2304 nr_irqs:256 16
> [    0.000000] CPU 0 irqstacks, hard=40094000 soft=40096000
> [    0.000000] console [ttyS0] enabled
> [    0.000000] console [ttyS0] enabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
> [    0.000000] ... CHAINHASH_SIZE:          32768
> [    0.000000] ... CHAINHASH_SIZE:          32768
> [    0.000000]  memory used by lock dependency info: 5151 kB
> [    0.000000]  memory used by lock dependency info: 5151 kB
> [    0.000000]  per task-struct memory footprint: 1920 bytes
> [    0.000000]  per task-struct memory footprint: 1920 bytes
> [    0.000000] tsc: Detected 2260.998 MHz processor
> [    0.000000] tsc: Detected 2260.998 MHz processor
> [    0.020000] Calibrating delay loop (skipped) preset value.. 
> [    0.020000] Calibrating delay loop (skipped) preset value.. 4521.99 BogoMIPS (lpj=22609980)
> 4521.99 BogoMIPS (lpj=22609980)
> [    0.020000] pid_max: default: 32768 minimum: 301
> [    0.020000] pid_max: default: 32768 minimum: 301
> [    0.020000] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
> [    0.020000] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
> [    0.020000] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
> [    0.020000] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
> [    0.020000] Initializing cgroup subsys perf_event
> [    0.020000] Initializing cgroup subsys perf_event
> [    0.020000] Initializing cgroup subsys debug
> [    0.020000] Initializing cgroup subsys debug
> [    0.020000] mce: CPU supports 10 MCE banks
> [    0.020000] mce: CPU supports 10 MCE banks
> [    0.020061] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.020061] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
> [    0.020061] tlb_flushall_shift: 6
> [    0.020061] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.020061] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
> [    0.020061] tlb_flushall_shift: 6
> [    0.023128] CPU: 
> [    0.023128] CPU: Intel Intel Common KVM processorCommon KVM processor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
> , stepping: 01)
> [    0.027904] Performance Events: 
> [    0.027904] Performance Events: unsupported Netburst CPU model 6 unsupported Netburst CPU model 6 no PMU driver, software events only.
> no PMU driver, software events only.
> [    0.030555] Enabling APIC mode:  Flat.  Using 0 I/O APICs
> [    0.030555] Enabling APIC mode:  Flat.  Using 0 I/O APICs
> [    0.031715] Getting VERSION: 1050014
> [    0.031715] Getting VERSION: 1050014
> [    0.032512] Getting VERSION: 1050014
> [    0.032512] Getting VERSION: 1050014
> [    0.033296] Getting ID: 0
> [    0.033296] Getting ID: 0
> [    0.033893] Getting ID: f000000
> [    0.033893] Getting ID: f000000
> [    0.034567] Getting LVT0: 700
> [    0.034567] Getting LVT0: 700
> [    0.035237] Getting LVT1: 400
> [    0.035237] Getting LVT1: 400
> [    0.035958] enabled ExtINT on CPU#0
> [    0.035958] enabled ExtINT on CPU#0
> [    0.036721] Using local APIC timer interrupts.
> [    0.036721] calibrating APIC timer ...
> [    0.036721] Using local APIC timer interrupts.
> [    0.036721] calibrating APIC timer ...
> [    0.040000] ... lapic delta = 6249335
> [    0.040000] ... lapic delta = 6249335
> [    0.040000] ... PM-Timer delta = 0
> [    0.040000] ... PM-Timer delta = 0
> [    0.040000] ..... delta 6249335
> [    0.040000] ..... delta 6249335
> [    0.040000] ..... mult: 268406894
> [    0.040000] ..... mult: 268406894
> [    0.040000] ..... calibration result: 9998936
> [    0.040000] ..... calibration result: 9998936
> [    0.040000] ..... CPU clock speed is 2260.7578 MHz.
> [    0.040000] ..... CPU clock speed is 2260.7578 MHz.
> [    0.040000] ..... host bus clock speed is 999.8936 MHz.
> [    0.040000] ..... host bus clock speed is 999.8936 MHz.
> [    0.040000] ... verify APIC timer
> [    0.040000] ... verify APIC timer
> [    0.156740] ... jiffies delta = 10
> [    0.156740] ... jiffies delta = 10
> [    0.157478] ... jiffies result ok
> [    0.157478] ... jiffies result ok
> [    0.158287] NMI watchdog: disabled (cpu0): hardware events not enabled
> [    0.158287] NMI watchdog: disabled (cpu0): hardware events not enabled
> [    0.159937] devtmpfs: initialized
> [    0.159937] devtmpfs: initialized
> [    0.160000] prandom: seed boundary self test passed
> [    0.160000] prandom: seed boundary self test passed
> [    0.160000] prandom: 100 self tests passed
> [    0.160000] prandom: 100 self tests passed
> [    0.160000] regulator-dummy: no parameters
> [    0.160000] regulator-dummy: no parameters
> [    0.160000] NET: Registered protocol family 16
> [    0.160000] NET: Registered protocol family 16
> [    0.160000] dca service started, version 1.12.1
> [    0.160000] dca service started, version 1.12.1
> [    0.160070] PCI: Using configuration type 1 for base access
> [    0.160070] PCI: Using configuration type 1 for base access
> [    0.162216] ACPI: Interpreter disabled.
> [    0.162216] ACPI: Interpreter disabled.
> [    0.163404] vgaarb: loaded
> [    0.163404] vgaarb: loaded
> [    0.164292] pps_core: LinuxPPS API ver. 1 registered
> [    0.164292] pps_core: LinuxPPS API ver. 1 registered
> [    0.165360] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    0.165360] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    0.167350] PCI: Probing PCI hardware
> [    0.167350] PCI: Probing PCI hardware
> [    0.168140] PCI: root bus 00: using default resources
> [    0.168140] PCI: root bus 00: using default resources
> [    0.169232] PCI: Probing PCI hardware (bus 00)
> [    0.169232] PCI: Probing PCI hardware (bus 00)
> [    0.170009] BUG: unable to handle kernel 
> [    0.170009] BUG: unable to handle kernel NULL pointer dereferenceNULL pointer dereference at 00000064
>  at 00000064
> [    0.171553] IP:
> [    0.171553] IP: [<41726569>] pcibios_root_bridge_prepare+0x9/0x20
>  [<41726569>] pcibios_root_bridge_prepare+0x9/0x20
> [    0.172863] *pde = 00000000 
> [    0.172863] *pde = 00000000 
> 
> [    0.173498] Oops: 0000 [#1] 
> [    0.173498] Oops: 0000 [#1] DEBUG_PAGEALLOCDEBUG_PAGEALLOC
> 
> [    0.174407] CPU: 0 PID: 1 Comm: swapper Tainted: G        W     3.16.0-rc1-00005-g6f99bc9 #1
> [    0.174407] CPU: 0 PID: 1 Comm: swapper Tainted: G        W     3.16.0-rc1-00005-g6f99bc9 #1
> [    0.176197] task: 40020d50 ti: 40022000 task.ti: 40022000
> [    0.176197] task: 40020d50 ti: 40022000 task.ti: 40022000
> [    0.177338] EIP: 0060:[<41726569>] EFLAGS: 00010206 CPU: 0
> [    0.177338] EIP: 0060:[<41726569>] EFLAGS: 00010206 CPU: 0
> [    0.178508] EIP is at pcibios_root_bridge_prepare+0x9/0x20
> [    0.178508] EIP is at pcibios_root_bridge_prepare+0x9/0x20
> [    0.179660] EAX: 40076c00 EBX: 40060880 ECX: 00000000 EDX: 00000000
> [    0.179660] EAX: 40076c00 EBX: 40060880 ECX: 00000000 EDX: 00000000
> [    0.180000] ESI: 40076c00 EDI: 00000000 EBP: 40023e14 ESP: 40023e14
> [    0.180000] ESI: 40076c00 EDI: 00000000 EBP: 40023e14 ESP: 40023e14
> [    0.180000]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
> [    0.180000]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
> [    0.180000] CR0: 8005003b CR2: 00000064 CR3: 01cd8000 CR4: 000006d0
> [    0.180000] CR0: 8005003b CR2: 00000064 CR3: 01cd8000 CR4: 000006d0
> [    0.180000] Stack:
> [    0.180000] Stack:
> [    0.180000]  40023ea0
> [    0.180000]  40023ea0 411fc037 411fc037 40023e60 40023e60 41077055 41077055 422af9a0 422af9a0 00000400 00000400 00000000 00000000 00000000 00000000
> 
> [    0.180000]  00000206
> [    0.180000]  00000206 06010001 06010001 40076d6c 40076d6c 41c6ab48 41c6ab48 40023ed0 40023ed0 00000000 00000000 000000aa 000000aa 000000aa 000000aa
> 
> [    0.180000]  00000007
> [    0.180000]  00000007 00000022 00000022 00000006 00000006 40023ea0 40023ea0 410775c5 410775c5 00000000 00000000 00000000 00000000 00000000 00000000
> 
> [    0.180000] Call Trace:
> [    0.180000] Call Trace:
> [    0.180000]  [<411fc037>] pci_create_root_bus+0x67/0x350
> [    0.180000]  [<411fc037>] pci_create_root_bus+0x67/0x350
> [    0.180000]  [<41077055>] ? console_unlock+0x315/0x5c0
> [    0.180000]  [<41077055>] ? console_unlock+0x315/0x5c0
> [    0.180000]  [<410775c5>] ? vprintk_emit+0x2c5/0x520
> [    0.180000]  [<410775c5>] ? vprintk_emit+0x2c5/0x520
> [    0.180000]  [<411f9ce8>] ? pci_add_resource_offset+0x38/0x60
> [    0.180000]  [<411f9ce8>] ? pci_add_resource_offset+0x38/0x60
> [    0.180000]  [<411fcbd1>] pci_scan_root_bus+0x71/0xc0
> [    0.180000]  [<411fcbd1>] pci_scan_root_bus+0x71/0xc0
> [    0.180000]  [<41727767>] pcibios_scan_root+0x67/0xb0
> [    0.180000]  [<41727767>] pcibios_scan_root+0x67/0xb0
> [    0.180000]  [<41cac34e>] pci_legacy_init+0x2e/0x32
> [    0.180000]  [<41cac34e>] pci_legacy_init+0x2e/0x32
> [    0.180000]  [<41cac365>] pci_subsys_init+0x13/0x44
> [    0.180000]  [<41cac365>] pci_subsys_init+0x13/0x44
> [    0.180000]  [<41c72d84>] do_one_initcall+0x18e/0x19d
> [    0.180000]  [<41c72d84>] do_one_initcall+0x18e/0x19d
> [    0.180000]  [<41cac352>] ? pci_legacy_init+0x32/0x32
> [    0.180000]  [<41cac352>] ? pci_legacy_init+0x32/0x32
> [    0.180000]  [<41cac352>] ? pci_legacy_init+0x32/0x32
> [    0.180000]  [<41cac352>] ? pci_legacy_init+0x32/0x32
> [    0.180000]  [<41c72500>] ? do_early_param+0x56/0x78
> [    0.180000]  [<41c72500>] ? do_early_param+0x56/0x78
> [    0.180000]  [<41057c49>] ? parse_args+0x219/0x390
> [    0.180000]  [<41057c49>] ? parse_args+0x219/0x390
> [    0.180000]  [<41c72f0f>] kernel_init_freeable+0x17c/0x20e
> [    0.180000]  [<41c72f0f>] kernel_init_freeable+0x17c/0x20e
> [    0.180000]  [<41c7259e>] ? initcall_blacklist+0x7c/0x7c
> [    0.180000]  [<41c7259e>] ? initcall_blacklist+0x7c/0x7c
> [    0.180000]  [<4176311b>] kernel_init+0xb/0xe0
> [    0.180000]  [<4176311b>] kernel_init+0xb/0xe0
> [    0.180000]  [<41062402>] ? schedule_tail+0x12/0x40
> [    0.180000]  [<41062402>] ? schedule_tail+0x12/0x40
> [    0.180000]  [<41776240>] ret_from_kernel_thread+0x20/0x30
> [    0.180000]  [<41776240>] ret_from_kernel_thread+0x20/0x30
> [    0.180000]  [<41763110>] ? rest_init+0xc0/0xc0
> [    0.180000]  [<41763110>] ? rest_init+0xc0/0xc0
> [    0.180000] Code:
> [    0.180000] Code: 59 59 a6 a6 41 41 89 89 44 44 24 24 08 08 e8 e8 5e 5e fd fd 03 03 00 00 31 31 c0 c0 e9 e9 a3 a3 fd fd ff ff ff ff eb eb 0d 0d 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 55 55 8b 8b 90 90 68 68 01 01 00 00 00 00 89 89 e5 e5 <8b> <8b> 52 52 64 64 8b 8b 52 52 08 08 89 89 90 90 08 08 01 01 00 00 00 00 31 31 c0 c0 5d 5d c3 c3 66 66 90 90 66 66 90 90 66 66
> 
> [    0.180000] EIP: [<41726569>] 
> [    0.180000] EIP: [<41726569>] pcibios_root_bridge_prepare+0x9/0x20pcibios_root_bridge_prepare+0x9/0x20 SS:ESP 0068:40023e14
>  SS:ESP 0068:40023e14
> [    0.180000] CR2: 0000000000000064
> [    0.180000] CR2: 0000000000000064
> [    0.180000] ---[ end trace 05e0c07eb1c663a7 ]---
> [    0.180000] ---[ end trace 05e0c07eb1c663a7 ]---
> [    0.180000] Kernel panic - not syncing: Fatal exception
> [    0.180000] Kernel panic - not syncing: Fatal exception
> [    0.180000] Rebooting in 10 seconds..
> [    0.180000] Rebooting in 10 seconds..
> Elapsed time: 5
> qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-ha1-0814/6f99bc949b1c90ff342a7d44ac4122322a7ccb78/vmlinuz-3.16.0-rc1-00005-g6f99bc9 -append 'hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/i386-randconfig-ha1-0814/cdall-kvm-arm:mustang:vgic-active-unqueue:6f99bc949b1c90ff342a7d44ac4122322a7ccb78:bisect-linux-8/.vmlinuz-6f99bc949b1c90ff342a7d44ac4122322a7ccb78-20140815205453-3-lkp-nex04 branch=cdall-kvm-arm/mustang/vgic-active-unqueue BOOT_IMAGE=/kernel/i386-randconfig-ha1-0814/6f99bc949b1c90ff342a7d44ac4122322a7ccb78/vmlinuz-3.16.0-rc1-00005-g6f99bc9 drbd.minor_count=8'  -initrd /kernel-tests/initrd/quantal-core-i386.cgz -m 320 -smp 2 -net nic,vlan=1,model=e1000 -net user,vlan=1 -boot order=nc -no-reboot -watchdog i6300esb -rtc base=localtime -pidfile /dev/shm/kboot/pid-quantal-lkp-nex04-171 -serial file:/dev/shm/kboot/serial-quantal-lkp-nex04-171 -daemonize -display none -monitor null 


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
> CONFIG_NEED_DMA_MAP_STATE=y
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
> CONFIG_HAVE_INTEL_TXT=y
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
> CONFIG_BROKEN_ON_SMP=y
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
> # CONFIG_SYSVIPC is not set
> # CONFIG_POSIX_MQUEUE is not set
> CONFIG_CROSS_MEMORY_ATTACH=y
> # CONFIG_FHANDLE is not set
> # CONFIG_USELIB is not set
> # CONFIG_AUDIT is not set
> CONFIG_HAVE_ARCH_AUDITSYSCALL=y
> 
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_IRQ_SHOW=y
> CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
> CONFIG_GENERIC_IRQ_CHIP=y
> CONFIG_IRQ_DOMAIN=y
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
> CONFIG_NO_HZ_COMMON=y
> # CONFIG_HZ_PERIODIC is not set
> CONFIG_NO_HZ_IDLE=y
> CONFIG_NO_HZ=y
> CONFIG_HIGH_RES_TIMERS=y
> 
> #
> # CPU/Task time and stats accounting
> #
> # CONFIG_TICK_CPU_ACCOUNTING is not set
> CONFIG_IRQ_TIME_ACCOUNTING=y
> CONFIG_BSD_PROCESS_ACCT=y
> CONFIG_BSD_PROCESS_ACCT_V3=y
> # CONFIG_TASKSTATS is not set
> 
> #
> # RCU Subsystem
> #
> CONFIG_TINY_RCU=y
> # CONFIG_PREEMPT_RCU is not set
> # CONFIG_RCU_STALL_COMMON is not set
> # CONFIG_TREE_RCU_TRACE is not set
> CONFIG_IKCONFIG=y
> # CONFIG_IKCONFIG_PROC is not set
> CONFIG_LOG_BUF_SHIFT=17
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
> CONFIG_CGROUPS=y
> CONFIG_CGROUP_DEBUG=y
> # CONFIG_CGROUP_FREEZER is not set
> # CONFIG_CGROUP_DEVICE is not set
> CONFIG_CPUSETS=y
> CONFIG_PROC_PID_CPUSET=y
> # CONFIG_CGROUP_CPUACCT is not set
> # CONFIG_RESOURCE_COUNTERS is not set
> CONFIG_CGROUP_PERF=y
> CONFIG_CGROUP_SCHED=y
> # CONFIG_FAIR_GROUP_SCHED is not set
> CONFIG_RT_GROUP_SCHED=y
> # CONFIG_CHECKPOINT_RESTORE is not set
> # CONFIG_NAMESPACES is not set
> # CONFIG_SCHED_AUTOGROUP is not set
> # CONFIG_RELAY is not set
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_RD_GZIP=y
> # CONFIG_RD_BZIP2 is not set
> # CONFIG_RD_LZMA is not set
> # CONFIG_RD_XZ is not set
> # CONFIG_RD_LZO is not set
> # CONFIG_RD_LZ4 is not set
> # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> CONFIG_ANON_INODES=y
> CONFIG_HAVE_UID16=y
> CONFIG_SYSCTL_EXCEPTION_TRACE=y
> CONFIG_HAVE_PCSPKR_PLATFORM=y
> CONFIG_EXPERT=y
> # CONFIG_UID16 is not set
> # CONFIG_SGETMASK_SYSCALL is not set
> CONFIG_SYSFS_SYSCALL=y
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_ALL=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> # CONFIG_ELF_CORE is not set
> CONFIG_PCSPKR_PLATFORM=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> # CONFIG_EPOLL is not set
> CONFIG_SIGNALFD=y
> # CONFIG_TIMERFD is not set
> # CONFIG_EVENTFD is not set
> # CONFIG_SHMEM is not set
> # CONFIG_AIO is not set
> CONFIG_PCI_QUIRKS=y
> CONFIG_EMBEDDED=y
> CONFIG_HAVE_PERF_EVENTS=y
> 
> #
> # Kernel Performance Events And Counters
> #
> CONFIG_PERF_EVENTS=y
> # CONFIG_DEBUG_PERF_USE_VMALLOC is not set
> CONFIG_VM_EVENT_COUNTERS=y
> # CONFIG_COMPAT_BRK is not set
> CONFIG_SLAB=y
> # CONFIG_SLUB is not set
> # CONFIG_SLOB is not set
> # CONFIG_SYSTEM_TRUSTED_KEYRING is not set
> CONFIG_PROFILING=y
> # CONFIG_OPROFILE is not set
> CONFIG_HAVE_OPROFILE=y
> CONFIG_OPROFILE_NMI_TIMER=y
> CONFIG_JUMP_LABEL=y
> # CONFIG_UPROBES is not set
> # CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_ARCH_USE_BUILTIN_BSWAP=y
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
> CONFIG_CC_STACKPROTECTOR=y
> # CONFIG_CC_STACKPROTECTOR_NONE is not set
> CONFIG_CC_STACKPROTECTOR_REGULAR=y
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
> CONFIG_HAVE_GENERIC_DMA_COHERENT=y
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=0
> # CONFIG_MODULES is not set
> # CONFIG_BLOCK is not set
> CONFIG_UNINLINE_SPIN_UNLOCK=y
> CONFIG_ARCH_USE_QUEUE_RWLOCK=y
> # CONFIG_FREEZER is not set
> 
> #
> # Processor type and features
> #
> # CONFIG_ZONE_DMA is not set
> # CONFIG_SMP is not set
> # CONFIG_X86_MPPARSE is not set
> # CONFIG_X86_EXTENDED_PLATFORM is not set
> # CONFIG_X86_INTEL_LPSS is not set
> # CONFIG_X86_32_IRIS is not set
> # CONFIG_SCHED_OMIT_FRAME_POINTER is not set
> CONFIG_HYPERVISOR_GUEST=y
> CONFIG_PARAVIRT=y
> CONFIG_PARAVIRT_DEBUG=y
> CONFIG_KVM_GUEST=y
> CONFIG_LGUEST_GUEST=y
> # CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
> CONFIG_PARAVIRT_CLOCK=y
> CONFIG_NO_BOOTMEM=y
> # CONFIG_MEMTEST is not set
> # CONFIG_M486 is not set
> # CONFIG_M586 is not set
> # CONFIG_M586TSC is not set
> # CONFIG_M586MMX is not set
> # CONFIG_M686 is not set
> # CONFIG_MPENTIUMII is not set
> # CONFIG_MPENTIUMIII is not set
> CONFIG_MPENTIUMM=y
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
> CONFIG_X86_INTERNODE_CACHE_SHIFT=6
> CONFIG_X86_L1_CACHE_SHIFT=6
> CONFIG_X86_INTEL_USERCOPY=y
> CONFIG_X86_USE_PPRO_CHECKSUM=y
> CONFIG_X86_TSC=y
> CONFIG_X86_CMPXCHG64=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=5
> CONFIG_X86_DEBUGCTLMSR=y
> CONFIG_PROCESSOR_SELECT=y
> CONFIG_CPU_SUP_INTEL=y
> CONFIG_CPU_SUP_CYRIX_32=y
> CONFIG_CPU_SUP_AMD=y
> # CONFIG_CPU_SUP_CENTAUR is not set
> CONFIG_CPU_SUP_TRANSMETA_32=y
> # CONFIG_CPU_SUP_UMC_32 is not set
> CONFIG_HPET_TIMER=y
> CONFIG_HPET_EMULATE_RTC=y
> # CONFIG_DMI is not set
> CONFIG_NR_CPUS=1
> CONFIG_PREEMPT_NONE=y
> # CONFIG_PREEMPT_VOLUNTARY is not set
> # CONFIG_PREEMPT is not set
> CONFIG_PREEMPT_COUNT=y
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
> CONFIG_X86_MCE=y
> CONFIG_X86_MCE_INTEL=y
> CONFIG_X86_MCE_AMD=y
> CONFIG_X86_ANCIENT_MCE=y
> CONFIG_X86_MCE_THRESHOLD=y
> CONFIG_X86_MCE_INJECT=y
> CONFIG_X86_THERMAL_VECTOR=y
> # CONFIG_VM86 is not set
> CONFIG_X86_16BIT=y
> CONFIG_X86_ESPFIX32=y
> # CONFIG_TOSHIBA is not set
> CONFIG_I8K=y
> CONFIG_X86_REBOOTFIXUPS=y
> CONFIG_MICROCODE=y
> CONFIG_MICROCODE_INTEL=y
> # CONFIG_MICROCODE_AMD is not set
> CONFIG_MICROCODE_OLD_INTERFACE=y
> CONFIG_MICROCODE_INTEL_EARLY=y
> # CONFIG_MICROCODE_AMD_EARLY is not set
> CONFIG_MICROCODE_EARLY=y
> CONFIG_X86_MSR=y
> CONFIG_X86_CPUID=y
> # CONFIG_NOHIGHMEM is not set
> CONFIG_HIGHMEM4G=y
> # CONFIG_HIGHMEM64G is not set
> # CONFIG_VMSPLIT_3G is not set
> # CONFIG_VMSPLIT_3G_OPT is not set
> # CONFIG_VMSPLIT_2G is not set
> # CONFIG_VMSPLIT_2G_OPT is not set
> CONFIG_VMSPLIT_1G=y
> CONFIG_PAGE_OFFSET=0x40000000
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
> # CONFIG_MEMORY_HOTPLUG is not set
> CONFIG_SPLIT_PTLOCK_CPUS=4
> # CONFIG_COMPACTION is not set
> CONFIG_MIGRATION=y
> # CONFIG_PHYS_ADDR_T_64BIT is not set
> CONFIG_ZONE_DMA_FLAG=0
> CONFIG_VIRT_TO_BUS=y
> CONFIG_KSM=y
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> # CONFIG_TRANSPARENT_HUGEPAGE is not set
> CONFIG_NEED_PER_CPU_KM=y
> # CONFIG_CLEANCACHE is not set
> CONFIG_CMA=y
> CONFIG_CMA_DEBUG=y
> # CONFIG_ZBUD is not set
> # CONFIG_ZSMALLOC is not set
> CONFIG_GENERIC_EARLY_IOREMAP=y
> # CONFIG_HIGHPTE is not set
> CONFIG_X86_CHECK_BIOS_CORRUPTION=y
> # CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
> CONFIG_X86_RESERVE_LOW=64
> # CONFIG_MATH_EMULATION is not set
> # CONFIG_MTRR is not set
> # CONFIG_ARCH_RANDOM is not set
> CONFIG_X86_SMAP=y
> CONFIG_EFI=y
> CONFIG_EFI_STUB=y
> # CONFIG_SECCOMP is not set
> CONFIG_HZ_100=y
> # CONFIG_HZ_250 is not set
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=100
> CONFIG_SCHED_HRTICK=y
> # CONFIG_KEXEC is not set
> # CONFIG_CRASH_DUMP is not set
> CONFIG_PHYSICAL_START=0x1000000
> CONFIG_RELOCATABLE=y
> # CONFIG_RANDOMIZE_BASE is not set
> CONFIG_X86_NEED_RELOCS=y
> CONFIG_PHYSICAL_ALIGN=0x200000
> # CONFIG_COMPAT_VDSO is not set
> # CONFIG_CMDLINE_BOOL is not set
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> 
> #
> # Power management and ACPI options
> #
> # CONFIG_SUSPEND is not set
> # CONFIG_PM_RUNTIME is not set
> CONFIG_ACPI=y
> # CONFIG_ACPI_PROCFS_POWER is not set
> CONFIG_ACPI_EC_DEBUGFS=y
> CONFIG_ACPI_AC=y
> # CONFIG_ACPI_BATTERY is not set
> # CONFIG_ACPI_BUTTON is not set
> CONFIG_ACPI_VIDEO=y
> CONFIG_ACPI_FAN=y
> CONFIG_ACPI_DOCK=y
> # CONFIG_ACPI_PROCESSOR is not set
> CONFIG_ACPI_IPMI=y
> CONFIG_ACPI_CUSTOM_DSDT_FILE=""
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> # CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
> CONFIG_ACPI_DEBUG=y
> CONFIG_X86_PM_TIMER=y
> # CONFIG_ACPI_CONTAINER is not set
> # CONFIG_ACPI_SBS is not set
> CONFIG_ACPI_HED=y
> # CONFIG_ACPI_BGRT is not set
> CONFIG_ACPI_REDUCED_HARDWARE_ONLY=y
> # CONFIG_ACPI_APEI is not set
> CONFIG_ACPI_EXTLOG=y
> # CONFIG_SFI is not set
> 
> #
> # CPU Frequency scaling
> #
> CONFIG_CPU_FREQ=y
> CONFIG_CPU_FREQ_GOV_COMMON=y
> # CONFIG_CPU_FREQ_STAT is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
> CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
> CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
> CONFIG_CPU_FREQ_GOV_POWERSAVE=y
> # CONFIG_CPU_FREQ_GOV_USERSPACE is not set
> CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> # CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set
> 
> #
> # x86 CPU frequency scaling drivers
> #
> CONFIG_X86_INTEL_PSTATE=y
> CONFIG_X86_POWERNOW_K6=y
> CONFIG_X86_POWERNOW_K7=y
> CONFIG_X86_GX_SUSPMOD=y
> CONFIG_X86_SPEEDSTEP_CENTRINO=y
> CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
> CONFIG_X86_SPEEDSTEP_ICH=y
> CONFIG_X86_SPEEDSTEP_SMI=y
> CONFIG_X86_P4_CLOCKMOD=y
> CONFIG_X86_CPUFREQ_NFORCE2=y
> CONFIG_X86_LONGRUN=y
> 
> #
> # shared options
> #
> CONFIG_X86_SPEEDSTEP_LIB=y
> CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
> 
> #
> # CPU Idle
> #
> # CONFIG_CPU_IDLE is not set
> # CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
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
> CONFIG_PCI_CNB20LE_QUIRK=y
> CONFIG_PCIEPORTBUS=y
> CONFIG_PCIEAER=y
> # CONFIG_PCIE_ECRC is not set
> CONFIG_PCIEAER_INJECT=y
> # CONFIG_PCIEASPM is not set
> CONFIG_PCI_MSI=y
> # CONFIG_PCI_DEBUG is not set
> # CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
> CONFIG_PCI_STUB=y
> # CONFIG_HT_IRQ is not set
> CONFIG_PCI_ATS=y
> CONFIG_PCI_IOV=y
> CONFIG_PCI_PRI=y
> CONFIG_PCI_PASID=y
> # CONFIG_PCI_IOAPIC is not set
> CONFIG_PCI_LABEL=y
> 
> #
> # PCI host controller drivers
> #
> CONFIG_ISA_DMA_API=y
> CONFIG_ISA=y
> # CONFIG_EISA is not set
> CONFIG_SCx200=y
> # CONFIG_SCx200HR_TIMER is not set
> CONFIG_OLPC=y
> # CONFIG_OLPC_XO15_SCI is not set
> CONFIG_ALIX=y
> CONFIG_NET5501=y
> CONFIG_AMD_NB=y
> CONFIG_PCCARD=y
> # CONFIG_PCMCIA is not set
> # CONFIG_CARDBUS is not set
> 
> #
> # PC-card bridges
> #
> CONFIG_YENTA=y
> CONFIG_YENTA_O2=y
> CONFIG_YENTA_RICOH=y
> # CONFIG_YENTA_TI is not set
> CONFIG_YENTA_TOSHIBA=y
> CONFIG_PCMCIA_PROBE=y
> CONFIG_RAPIDIO=y
> CONFIG_RAPIDIO_TSI721=y
> CONFIG_RAPIDIO_DISC_TIMEOUT=30
> # CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
> CONFIG_RAPIDIO_DMA_ENGINE=y
> CONFIG_RAPIDIO_DEBUG=y
> CONFIG_RAPIDIO_ENUM_BASIC=y
> 
> #
> # RapidIO Switch drivers
> #
> CONFIG_RAPIDIO_TSI57X=y
> # CONFIG_RAPIDIO_CPS_XX is not set
> # CONFIG_RAPIDIO_TSI568 is not set
> CONFIG_RAPIDIO_CPS_GEN2=y
> # CONFIG_X86_SYSFB is not set
> 
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
> CONFIG_BINFMT_SCRIPT=y
> CONFIG_HAVE_AOUT=y
> CONFIG_BINFMT_AOUT=y
> CONFIG_BINFMT_MISC=y
> CONFIG_COREDUMP=y
> CONFIG_HAVE_ATOMIC_IOMAP=y
> CONFIG_IOSF_MBI=y
> CONFIG_NET=y
> 
> #
> # Networking options
> #
> # CONFIG_PACKET is not set
> CONFIG_UNIX=y
> # CONFIG_UNIX_DIAG is not set
> # CONFIG_NET_KEY is not set
> # CONFIG_INET is not set
> # CONFIG_NETWORK_SECMARK is not set
> # CONFIG_NET_PTP_CLASSIFY is not set
> # CONFIG_NETWORK_PHY_TIMESTAMPING is not set
> # CONFIG_NETFILTER is not set
> # CONFIG_ATM is not set
> # CONFIG_BRIDGE is not set
> # CONFIG_VLAN_8021Q is not set
> # CONFIG_DECNET is not set
> # CONFIG_LLC2 is not set
> # CONFIG_IPX is not set
> # CONFIG_ATALK is not set
> # CONFIG_X25 is not set
> # CONFIG_LAPB is not set
> # CONFIG_PHONET is not set
> # CONFIG_IEEE802154 is not set
> # CONFIG_NET_SCHED is not set
> # CONFIG_DCB is not set
> # CONFIG_DNS_RESOLVER is not set
> # CONFIG_BATMAN_ADV is not set
> # CONFIG_OPENVSWITCH is not set
> # CONFIG_VSOCKETS is not set
> # CONFIG_NETLINK_MMAP is not set
> # CONFIG_NETLINK_DIAG is not set
> # CONFIG_NET_MPLS_GSO is not set
> # CONFIG_HSR is not set
> # CONFIG_CGROUP_NET_PRIO is not set
> # CONFIG_CGROUP_NET_CLASSID is not set
> CONFIG_NET_RX_BUSY_POLL=y
> 
> #
> # Network testing
> #
> # CONFIG_HAMRADIO is not set
> # CONFIG_CAN is not set
> # CONFIG_IRDA is not set
> # CONFIG_BT is not set
> CONFIG_WIRELESS=y
> # CONFIG_CFG80211 is not set
> # CONFIG_LIB80211 is not set
> 
> #
> # CFG80211 needs to be enabled for MAC80211
> #
> # CONFIG_WIMAX is not set
> # CONFIG_RFKILL is not set
> # CONFIG_RFKILL_REGULATOR is not set
> # CONFIG_NET_9P is not set
> # CONFIG_CAIF is not set
> # CONFIG_NFC is not set
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> # CONFIG_UEVENT_HELPER is not set
> CONFIG_DEVTMPFS=y
> # CONFIG_DEVTMPFS_MOUNT is not set
> # CONFIG_STANDALONE is not set
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> # CONFIG_FIRMWARE_IN_KERNEL is not set
> CONFIG_EXTRA_FIRMWARE=""
> CONFIG_FW_LOADER_USER_HELPER=y
> # CONFIG_DEBUG_DRIVER is not set
> CONFIG_DEBUG_DEVRES=y
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_GENERIC_CPU_DEVICES is not set
> CONFIG_GENERIC_CPU_AUTOPROBE=y
> CONFIG_REGMAP=y
> CONFIG_REGMAP_I2C=y
> CONFIG_REGMAP_MMIO=y
> CONFIG_REGMAP_IRQ=y
> CONFIG_DMA_SHARED_BUFFER=y
> # CONFIG_DMA_CMA is not set
> 
> #
> # Bus devices
> #
> # CONFIG_CONNECTOR is not set
> CONFIG_MTD=y
> CONFIG_MTD_REDBOOT_PARTS=y
> CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
> CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
> CONFIG_MTD_REDBOOT_PARTS_READONLY=y
> CONFIG_MTD_CMDLINE_PARTS=y
> # CONFIG_MTD_OF_PARTS is not set
> # CONFIG_MTD_AR7_PARTS is not set
> 
> #
> # User Modules And Translation Layers
> #
> # CONFIG_MTD_OOPS is not set
> 
> #
> # RAM/ROM/Flash chip drivers
> #
> # CONFIG_MTD_CFI is not set
> CONFIG_MTD_JEDECPROBE=y
> CONFIG_MTD_GEN_PROBE=y
> # CONFIG_MTD_CFI_ADV_OPTIONS is not set
> CONFIG_MTD_MAP_BANK_WIDTH_1=y
> CONFIG_MTD_MAP_BANK_WIDTH_2=y
> CONFIG_MTD_MAP_BANK_WIDTH_4=y
> # CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
> # CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
> # CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
> CONFIG_MTD_CFI_I1=y
> CONFIG_MTD_CFI_I2=y
> # CONFIG_MTD_CFI_I4 is not set
> # CONFIG_MTD_CFI_I8 is not set
> CONFIG_MTD_CFI_INTELEXT=y
> CONFIG_MTD_CFI_AMDSTD=y
> # CONFIG_MTD_CFI_STAA is not set
> CONFIG_MTD_CFI_UTIL=y
> CONFIG_MTD_RAM=y
> CONFIG_MTD_ROM=y
> CONFIG_MTD_ABSENT=y
> 
> #
> # Mapping drivers for chip access
> #
> # CONFIG_MTD_COMPLEX_MAPPINGS is not set
> CONFIG_MTD_PHYSMAP=y
> CONFIG_MTD_PHYSMAP_COMPAT=y
> CONFIG_MTD_PHYSMAP_START=0x8000000
> CONFIG_MTD_PHYSMAP_LEN=0
> CONFIG_MTD_PHYSMAP_BANKWIDTH=2
> CONFIG_MTD_PHYSMAP_OF=y
> CONFIG_MTD_AMD76XROM=y
> CONFIG_MTD_ICHXROM=y
> # CONFIG_MTD_ESB2ROM is not set
> CONFIG_MTD_CK804XROM=y
> # CONFIG_MTD_SCB2_FLASH is not set
> # CONFIG_MTD_NETtel is not set
> # CONFIG_MTD_L440GX is not set
> CONFIG_MTD_INTEL_VR_NOR=y
> CONFIG_MTD_PLATRAM=y
> 
> #
> # Self-contained MTD device drivers
> #
> # CONFIG_MTD_PMC551 is not set
> CONFIG_MTD_SLRAM=y
> CONFIG_MTD_PHRAM=y
> CONFIG_MTD_MTDRAM=y
> CONFIG_MTDRAM_TOTAL_SIZE=4096
> CONFIG_MTDRAM_ERASE_SIZE=128
> CONFIG_MTDRAM_ABS_POS=0
> 
> #
> # Disk-On-Chip Device Drivers
> #
> CONFIG_MTD_DOCG3=y
> CONFIG_BCH_CONST_M=14
> CONFIG_BCH_CONST_T=4
> # CONFIG_MTD_NAND is not set
> CONFIG_MTD_ONENAND=y
> # CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
> # CONFIG_MTD_ONENAND_GENERIC is not set
> CONFIG_MTD_ONENAND_OTP=y
> CONFIG_MTD_ONENAND_2X_PROGRAM=y
> 
> #
> # LPDDR & LPDDR2 PCM memory drivers
> #
> CONFIG_MTD_LPDDR=y
> CONFIG_MTD_QINFO_PROBE=y
> # CONFIG_MTD_SPI_NOR is not set
> CONFIG_MTD_UBI=y
> CONFIG_MTD_UBI_WL_THRESHOLD=4096
> CONFIG_MTD_UBI_BEB_LIMIT=20
> # CONFIG_MTD_UBI_FASTMAP is not set
> # CONFIG_MTD_UBI_GLUEBI is not set
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
> CONFIG_OF_PCI=y
> CONFIG_OF_PCI_IRQ=y
> CONFIG_OF_MTD=y
> # CONFIG_PARPORT is not set
> CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
> CONFIG_PNP=y
> # CONFIG_PNP_DEBUG_MESSAGES is not set
> 
> #
> # Protocols
> #
> # CONFIG_ISAPNP is not set
> # CONFIG_PNPBIOS is not set
> CONFIG_PNPACPI=y
> 
> #
> # Misc devices
> #
> CONFIG_SENSORS_LIS3LV02D=y
> CONFIG_DUMMY_IRQ=y
> # CONFIG_IBM_ASM is not set
> CONFIG_PHANTOM=y
> CONFIG_SGI_IOC4=y
> CONFIG_TIFM_CORE=y
> CONFIG_TIFM_7XX1=y
> CONFIG_ICS932S401=y
> CONFIG_ENCLOSURE_SERVICES=y
> # CONFIG_CS5535_MFGPT is not set
> CONFIG_HP_ILO=y
> CONFIG_APDS9802ALS=y
> CONFIG_ISL29020=y
> # CONFIG_SENSORS_BH1770 is not set
> CONFIG_SENSORS_APDS990X=y
> # CONFIG_HMC6352 is not set
> # CONFIG_DS1682 is not set
> # CONFIG_VMWARE_BALLOON is not set
> # CONFIG_PCH_PHUB is not set
> # CONFIG_USB_SWITCH_FSA9480 is not set
> CONFIG_SRAM=y
> # CONFIG_C2PORT is not set
> 
> #
> # EEPROM support
> #
> # CONFIG_EEPROM_MAX6875 is not set
> # CONFIG_EEPROM_93CX6 is not set
> CONFIG_CB710_CORE=y
> CONFIG_CB710_DEBUG=y
> CONFIG_CB710_DEBUG_ASSUMPTIONS=y
> 
> #
> # Texas Instruments shared transport line discipline
> #
> # CONFIG_TI_ST is not set
> # CONFIG_SENSORS_LIS3_I2C is not set
> 
> #
> # Altera FPGA firmware download module
> #
> CONFIG_ALTERA_STAPL=y
> CONFIG_INTEL_MEI=y
> CONFIG_INTEL_MEI_ME=y
> CONFIG_INTEL_MEI_TXE=y
> CONFIG_VMWARE_VMCI=y
> 
> #
> # Intel MIC Host Driver
> #
> 
> #
> # Intel MIC Card Driver
> #
> # CONFIG_ECHO is not set
> CONFIG_HAVE_IDE=y
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=y
> # CONFIG_SCSI_DMA is not set
> # CONFIG_SCSI_NETLINK is not set
> CONFIG_FUSION=y
> CONFIG_FUSION_MAX_SGE=128
> CONFIG_FUSION_LOGGING=y
> 
> #
> # IEEE 1394 (FireWire) support
> #
> CONFIG_FIREWIRE=y
> # CONFIG_FIREWIRE_OHCI is not set
> # CONFIG_FIREWIRE_NOSY is not set
> # CONFIG_I2O is not set
> CONFIG_MACINTOSH_DRIVERS=y
> # CONFIG_NETDEVICES is not set
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> CONFIG_INPUT_FF_MEMLESS=y
> CONFIG_INPUT_POLLDEV=y
> CONFIG_INPUT_SPARSEKMAP=y
> CONFIG_INPUT_MATRIXKMAP=y
> 
> #
> # Userland interfaces
> #
> # CONFIG_INPUT_MOUSEDEV is not set
> CONFIG_INPUT_JOYDEV=y
> CONFIG_INPUT_EVDEV=y
> # CONFIG_INPUT_EVBUG is not set
> 
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> # CONFIG_KEYBOARD_ADP5588 is not set
> # CONFIG_KEYBOARD_ADP5589 is not set
> CONFIG_KEYBOARD_ATKBD=y
> # CONFIG_KEYBOARD_QT1070 is not set
> # CONFIG_KEYBOARD_QT2160 is not set
> # CONFIG_KEYBOARD_LKKBD is not set
> # CONFIG_KEYBOARD_GPIO is not set
> # CONFIG_KEYBOARD_GPIO_POLLED is not set
> # CONFIG_KEYBOARD_TCA6416 is not set
> # CONFIG_KEYBOARD_TCA8418 is not set
> # CONFIG_KEYBOARD_MATRIX is not set
> # CONFIG_KEYBOARD_LM8323 is not set
> # CONFIG_KEYBOARD_LM8333 is not set
> # CONFIG_KEYBOARD_MAX7359 is not set
> # CONFIG_KEYBOARD_MCS is not set
> # CONFIG_KEYBOARD_MPR121 is not set
> # CONFIG_KEYBOARD_NEWTON is not set
> # CONFIG_KEYBOARD_OPENCORES is not set
> # CONFIG_KEYBOARD_STOWAWAY is not set
> # CONFIG_KEYBOARD_SUNKBD is not set
> # CONFIG_KEYBOARD_OMAP4 is not set
> # CONFIG_KEYBOARD_TC3589X is not set
> # CONFIG_KEYBOARD_XTKBD is not set
> CONFIG_INPUT_MOUSE=y
> CONFIG_MOUSE_PS2=y
> CONFIG_MOUSE_PS2_ALPS=y
> CONFIG_MOUSE_PS2_LOGIPS2PP=y
> # CONFIG_MOUSE_PS2_SYNAPTICS is not set
> CONFIG_MOUSE_PS2_CYPRESS=y
> CONFIG_MOUSE_PS2_TRACKPOINT=y
> CONFIG_MOUSE_PS2_ELANTECH=y
> CONFIG_MOUSE_PS2_SENTELIC=y
> CONFIG_MOUSE_PS2_TOUCHKIT=y
> # CONFIG_MOUSE_PS2_OLPC is not set
> CONFIG_MOUSE_SERIAL=y
> # CONFIG_MOUSE_APPLETOUCH is not set
> # CONFIG_MOUSE_BCM5974 is not set
> CONFIG_MOUSE_CYAPA=y
> CONFIG_MOUSE_INPORT=y
> # CONFIG_MOUSE_ATIXL is not set
> CONFIG_MOUSE_LOGIBM=y
> # CONFIG_MOUSE_PC110PAD is not set
> CONFIG_MOUSE_VSXXXAA=y
> CONFIG_MOUSE_GPIO=y
> CONFIG_MOUSE_SYNAPTICS_I2C=y
> # CONFIG_MOUSE_SYNAPTICS_USB is not set
> CONFIG_INPUT_JOYSTICK=y
> CONFIG_JOYSTICK_ANALOG=y
> CONFIG_JOYSTICK_A3D=y
> CONFIG_JOYSTICK_ADI=y
> CONFIG_JOYSTICK_COBRA=y
> CONFIG_JOYSTICK_GF2K=y
> # CONFIG_JOYSTICK_GRIP is not set
> # CONFIG_JOYSTICK_GRIP_MP is not set
> CONFIG_JOYSTICK_GUILLEMOT=y
> CONFIG_JOYSTICK_INTERACT=y
> CONFIG_JOYSTICK_SIDEWINDER=y
> CONFIG_JOYSTICK_TMDC=y
> CONFIG_JOYSTICK_IFORCE=y
> CONFIG_JOYSTICK_IFORCE_232=y
> # CONFIG_JOYSTICK_WARRIOR is not set
> CONFIG_JOYSTICK_MAGELLAN=y
> CONFIG_JOYSTICK_SPACEORB=y
> CONFIG_JOYSTICK_SPACEBALL=y
> CONFIG_JOYSTICK_STINGER=y
> # CONFIG_JOYSTICK_TWIDJOY is not set
> # CONFIG_JOYSTICK_ZHENHUA is not set
> # CONFIG_JOYSTICK_AS5011 is not set
> CONFIG_JOYSTICK_JOYDUMP=y
> # CONFIG_JOYSTICK_XPAD is not set
> CONFIG_INPUT_TABLET=y
> # CONFIG_TABLET_USB_ACECAD is not set
> # CONFIG_TABLET_USB_AIPTEK is not set
> # CONFIG_TABLET_USB_HANWANG is not set
> # CONFIG_TABLET_USB_KBTAB is not set
> # CONFIG_TABLET_USB_WACOM is not set
> CONFIG_INPUT_TOUCHSCREEN=y
> CONFIG_OF_TOUCHSCREEN=y
> # CONFIG_TOUCHSCREEN_88PM860X is not set
> # CONFIG_TOUCHSCREEN_AD7879 is not set
> CONFIG_TOUCHSCREEN_ATMEL_MXT=y
> CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
> # CONFIG_TOUCHSCREEN_BU21013 is not set
> CONFIG_TOUCHSCREEN_CY8CTMG110=y
> # CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
> # CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
> CONFIG_TOUCHSCREEN_DA9052=y
> # CONFIG_TOUCHSCREEN_DYNAPRO is not set
> # CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
> CONFIG_TOUCHSCREEN_EETI=y
> CONFIG_TOUCHSCREEN_EGALAX=y
> # CONFIG_TOUCHSCREEN_FUJITSU is not set
> CONFIG_TOUCHSCREEN_ILI210X=y
> CONFIG_TOUCHSCREEN_GUNZE=y
> # CONFIG_TOUCHSCREEN_ELO is not set
> CONFIG_TOUCHSCREEN_WACOM_W8001=y
> CONFIG_TOUCHSCREEN_WACOM_I2C=y
> # CONFIG_TOUCHSCREEN_MAX11801 is not set
> CONFIG_TOUCHSCREEN_MCS5000=y
> # CONFIG_TOUCHSCREEN_MMS114 is not set
> CONFIG_TOUCHSCREEN_MTOUCH=y
> CONFIG_TOUCHSCREEN_INEXIO=y
> CONFIG_TOUCHSCREEN_MK712=y
> CONFIG_TOUCHSCREEN_HTCPEN=y
> CONFIG_TOUCHSCREEN_PENMOUNT=y
> CONFIG_TOUCHSCREEN_EDT_FT5X06=y
> CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
> CONFIG_TOUCHSCREEN_TOUCHWIN=y
> CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
> CONFIG_TOUCHSCREEN_PIXCIR=y
> # CONFIG_TOUCHSCREEN_WM831X is not set
> # CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
> CONFIG_TOUCHSCREEN_MC13783=y
> CONFIG_TOUCHSCREEN_TOUCHIT213=y
> # CONFIG_TOUCHSCREEN_TSC_SERIO is not set
> # CONFIG_TOUCHSCREEN_TSC2007 is not set
> CONFIG_TOUCHSCREEN_ST1232=y
> CONFIG_TOUCHSCREEN_TPS6507X=y
> # CONFIG_TOUCHSCREEN_ZFORCE is not set
> # CONFIG_INPUT_MISC is not set
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
> CONFIG_SERIO_I8042=y
> # CONFIG_SERIO_SERPORT is not set
> CONFIG_SERIO_CT82C710=y
> CONFIG_SERIO_PCIPS2=y
> CONFIG_SERIO_LIBPS2=y
> # CONFIG_SERIO_RAW is not set
> CONFIG_SERIO_ALTERA_PS2=y
> CONFIG_SERIO_PS2MULT=y
> CONFIG_SERIO_ARC_PS2=y
> CONFIG_SERIO_APBPS2=y
> CONFIG_SERIO_OLPC_APSP=y
> CONFIG_HYPERV_KEYBOARD=y
> CONFIG_GAMEPORT=y
> CONFIG_GAMEPORT_NS558=y
> CONFIG_GAMEPORT_L4=y
> # CONFIG_GAMEPORT_EMU10K1 is not set
> CONFIG_GAMEPORT_FM801=y
> 
> #
> # Character devices
> #
> CONFIG_TTY=y
> # CONFIG_VT is not set
> CONFIG_UNIX98_PTYS=y
> CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
> # CONFIG_LEGACY_PTYS is not set
> CONFIG_SERIAL_NONSTANDARD=y
> CONFIG_ROCKETPORT=y
> CONFIG_CYCLADES=y
> # CONFIG_CYZ_INTR is not set
> # CONFIG_MOXA_INTELLIO is not set
> CONFIG_MOXA_SMARTIO=y
> # CONFIG_SYNCLINK is not set
> CONFIG_SYNCLINKMP=y
> CONFIG_SYNCLINK_GT=y
> CONFIG_NOZOMI=y
> CONFIG_ISI=y
> CONFIG_N_HDLC=y
> # CONFIG_N_GSM is not set
> CONFIG_TRACE_ROUTER=y
> CONFIG_TRACE_SINK=y
> # CONFIG_DEVKMEM is not set
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_EARLYCON=y
> CONFIG_SERIAL_8250=y
> # CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
> # CONFIG_SERIAL_8250_PNP is not set
> CONFIG_SERIAL_8250_CONSOLE=y
> # CONFIG_SERIAL_8250_DMA is not set
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> CONFIG_SERIAL_8250_EXTENDED=y
> # CONFIG_SERIAL_8250_MANY_PORTS is not set
> CONFIG_SERIAL_8250_SHARE_IRQ=y
> CONFIG_SERIAL_8250_DETECT_IRQ=y
> CONFIG_SERIAL_8250_RSA=y
> CONFIG_SERIAL_8250_DW=y
> 
> #
> # Non-8250 serial port support
> #
> CONFIG_SERIAL_MFD_HSU=y
> # CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
> CONFIG_SERIAL_UARTLITE=y
> # CONFIG_SERIAL_UARTLITE_CONSOLE is not set
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> # CONFIG_SERIAL_JSM is not set
> CONFIG_SERIAL_OF_PLATFORM=y
> CONFIG_SERIAL_SCCNXP=y
> CONFIG_SERIAL_SCCNXP_CONSOLE=y
> CONFIG_SERIAL_SC16IS7XX=y
> CONFIG_SERIAL_TIMBERDALE=y
> CONFIG_SERIAL_ALTERA_JTAGUART=y
> CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
> # CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS is not set
> CONFIG_SERIAL_ALTERA_UART=y
> CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
> CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
> # CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
> CONFIG_SERIAL_PCH_UART=y
> CONFIG_SERIAL_PCH_UART_CONSOLE=y
> CONFIG_SERIAL_XILINX_PS_UART=y
> CONFIG_SERIAL_XILINX_PS_UART_CONSOLE=y
> CONFIG_SERIAL_ARC=y
> CONFIG_SERIAL_ARC_CONSOLE=y
> CONFIG_SERIAL_ARC_NR_PORTS=1
> CONFIG_SERIAL_RP2=y
> CONFIG_SERIAL_RP2_NR_UARTS=32
> CONFIG_SERIAL_FSL_LPUART=y
> # CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
> # CONFIG_SERIAL_MEN_Z135 is not set
> CONFIG_TTY_PRINTK=y
> CONFIG_HVC_DRIVER=y
> CONFIG_VIRTIO_CONSOLE=y
> CONFIG_IPMI_HANDLER=y
> # CONFIG_IPMI_PANIC_EVENT is not set
> CONFIG_IPMI_DEVICE_INTERFACE=y
> CONFIG_IPMI_SI=y
> CONFIG_IPMI_SI_PROBE_DEFAULTS=y
> # CONFIG_IPMI_WATCHDOG is not set
> # CONFIG_IPMI_POWEROFF is not set
> # CONFIG_HW_RANDOM is not set
> CONFIG_NVRAM=y
> # CONFIG_DTLK is not set
> # CONFIG_R3964 is not set
> CONFIG_APPLICOM=y
> # CONFIG_SONYPI is not set
> # CONFIG_MWAVE is not set
> CONFIG_SCx200_GPIO=y
> # CONFIG_PC8736x_GPIO is not set
> CONFIG_NSC_GPIO=y
> CONFIG_HPET=y
> CONFIG_HPET_MMAP=y
> CONFIG_HPET_MMAP_DEFAULT=y
> CONFIG_HANGCHECK_TIMER=y
> # CONFIG_TCG_TPM is not set
> CONFIG_TELCLOCK=y
> CONFIG_DEVPORT=y
> CONFIG_I2C=y
> CONFIG_I2C_BOARDINFO=y
> # CONFIG_I2C_COMPAT is not set
> # CONFIG_I2C_CHARDEV is not set
> CONFIG_I2C_MUX=y
> 
> #
> # Multiplexer I2C Chip support
> #
> CONFIG_I2C_ARB_GPIO_CHALLENGE=y
> CONFIG_I2C_MUX_GPIO=y
> # CONFIG_I2C_MUX_PCA9541 is not set
> # CONFIG_I2C_MUX_PCA954x is not set
> CONFIG_I2C_HELPER_AUTO=y
> CONFIG_I2C_SMBUS=y
> CONFIG_I2C_ALGOBIT=y
> CONFIG_I2C_ALGOPCA=y
> 
> #
> # I2C Hardware Bus support
> #
> 
> #
> # PC SMBus host controller drivers
> #
> CONFIG_I2C_ALI1535=y
> CONFIG_I2C_ALI1563=y
> CONFIG_I2C_ALI15X3=y
> # CONFIG_I2C_AMD756 is not set
> CONFIG_I2C_AMD8111=y
> CONFIG_I2C_I801=y
> # CONFIG_I2C_ISCH is not set
> CONFIG_I2C_ISMT=y
> # CONFIG_I2C_PIIX4 is not set
> CONFIG_I2C_NFORCE2=y
> CONFIG_I2C_NFORCE2_S4985=y
> CONFIG_I2C_SIS5595=y
> # CONFIG_I2C_SIS630 is not set
> CONFIG_I2C_SIS96X=y
> # CONFIG_I2C_VIA is not set
> CONFIG_I2C_VIAPRO=y
> 
> #
> # ACPI drivers
> #
> # CONFIG_I2C_SCMI is not set
> 
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> CONFIG_I2C_CBUS_GPIO=y
> CONFIG_I2C_DESIGNWARE_CORE=y
> CONFIG_I2C_DESIGNWARE_PLATFORM=y
> # CONFIG_I2C_DESIGNWARE_PCI is not set
> # CONFIG_I2C_EG20T is not set
> CONFIG_I2C_GPIO=y
> CONFIG_I2C_KEMPLD=y
> CONFIG_I2C_OCORES=y
> CONFIG_I2C_PCA_PLATFORM=y
> CONFIG_I2C_PXA=y
> CONFIG_I2C_PXA_PCI=y
> # CONFIG_I2C_SIMTEC is not set
> CONFIG_I2C_XILINX=y
> 
> #
> # External I2C/SMBus adapter drivers
> #
> CONFIG_I2C_PARPORT_LIGHT=y
> # CONFIG_I2C_TAOS_EVM is not set
> 
> #
> # Other I2C/SMBus bus drivers
> #
> # CONFIG_I2C_ELEKTOR is not set
> # CONFIG_I2C_PCA_ISA is not set
> CONFIG_SCx200_I2C=y
> CONFIG_SCx200_I2C_SCL=12
> CONFIG_SCx200_I2C_SDA=13
> # CONFIG_SCx200_ACB is not set
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> # CONFIG_SPI is not set
> CONFIG_SPMI=y
> # CONFIG_HSI is not set
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
> CONFIG_PPS_CLIENT_KTIMER=y
> CONFIG_PPS_CLIENT_LDISC=y
> CONFIG_PPS_CLIENT_GPIO=y
> 
> #
> # PPS generators support
> #
> 
> #
> # PTP clock support
> #
> # CONFIG_PTP_1588_CLOCK is not set
> 
> #
> # Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
> #
> # CONFIG_PTP_1588_CLOCK_PCH is not set
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> CONFIG_GPIOLIB=y
> CONFIG_GPIO_DEVRES=y
> CONFIG_OF_GPIO=y
> CONFIG_GPIO_ACPI=y
> CONFIG_GPIOLIB_IRQCHIP=y
> # CONFIG_DEBUG_GPIO is not set
> CONFIG_GPIO_GENERIC=y
> CONFIG_GPIO_DA9052=y
> CONFIG_GPIO_MAX730X=y
> 
> #
> # Memory mapped GPIO drivers:
> #
> CONFIG_GPIO_GENERIC_PLATFORM=y
> CONFIG_GPIO_DWAPB=y
> CONFIG_GPIO_IT8761E=y
> CONFIG_GPIO_F7188X=y
> CONFIG_GPIO_SCH311X=y
> CONFIG_GPIO_SYSCON=y
> CONFIG_GPIO_SCH=y
> # CONFIG_GPIO_ICH is not set
> CONFIG_GPIO_VX855=y
> CONFIG_GPIO_LYNXPOINT=y
> # CONFIG_GPIO_GRGPIO is not set
> 
> #
> # I2C GPIO expanders:
> #
> CONFIG_GPIO_ARIZONA=y
> CONFIG_GPIO_MAX7300=y
> CONFIG_GPIO_MAX732X=y
> CONFIG_GPIO_MAX732X_IRQ=y
> CONFIG_GPIO_PCA953X=y
> # CONFIG_GPIO_PCA953X_IRQ is not set
> CONFIG_GPIO_PCF857X=y
> CONFIG_GPIO_SX150X=y
> CONFIG_GPIO_TC3589X=y
> # CONFIG_GPIO_TWL6040 is not set
> # CONFIG_GPIO_WM831X is not set
> # CONFIG_GPIO_WM8350 is not set
> CONFIG_GPIO_WM8994=y
> # CONFIG_GPIO_ADP5588 is not set
> CONFIG_GPIO_ADNP=y
> 
> #
> # PCI GPIO expanders:
> #
> CONFIG_GPIO_CS5535=y
> # CONFIG_GPIO_BT8XX is not set
> CONFIG_GPIO_AMD8111=y
> # CONFIG_GPIO_INTEL_MID is not set
> # CONFIG_GPIO_PCH is not set
> # CONFIG_GPIO_ML_IOH is not set
> # CONFIG_GPIO_SODAVILLE is not set
> CONFIG_GPIO_TIMBERDALE=y
> CONFIG_GPIO_RDC321X=y
> 
> #
> # SPI GPIO expanders:
> #
> CONFIG_GPIO_MCP23S08=y
> 
> #
> # AC97 GPIO expanders:
> #
> 
> #
> # LPC GPIO expanders:
> #
> CONFIG_GPIO_KEMPLD=y
> 
> #
> # MODULbus GPIO expanders:
> #
> CONFIG_GPIO_JANZ_TTL=y
> CONFIG_GPIO_PALMAS=y
> CONFIG_GPIO_TPS65910=y
> CONFIG_GPIO_BCM_KONA=y
> 
> #
> # USB GPIO expanders:
> #
> CONFIG_W1=y
> 
> #
> # 1-wire Bus Masters
> #
> CONFIG_W1_MASTER_MATROX=y
> CONFIG_W1_MASTER_DS2482=y
> CONFIG_W1_MASTER_DS1WM=y
> # CONFIG_W1_MASTER_GPIO is not set
> 
> #
> # 1-wire Slaves
> #
> CONFIG_W1_SLAVE_THERM=y
> CONFIG_W1_SLAVE_SMEM=y
> # CONFIG_W1_SLAVE_DS2408 is not set
> CONFIG_W1_SLAVE_DS2413=y
> # CONFIG_W1_SLAVE_DS2423 is not set
> # CONFIG_W1_SLAVE_DS2431 is not set
> # CONFIG_W1_SLAVE_DS2433 is not set
> CONFIG_W1_SLAVE_DS2760=y
> CONFIG_W1_SLAVE_DS2780=y
> # CONFIG_W1_SLAVE_DS2781 is not set
> # CONFIG_W1_SLAVE_DS28E04 is not set
> CONFIG_W1_SLAVE_BQ27000=y
> CONFIG_POWER_SUPPLY=y
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> CONFIG_PDA_POWER=y
> # CONFIG_GENERIC_ADC_BATTERY is not set
> # CONFIG_WM831X_BACKUP is not set
> CONFIG_WM831X_POWER=y
> # CONFIG_WM8350_POWER is not set
> CONFIG_TEST_POWER=y
> CONFIG_BATTERY_88PM860X=y
> CONFIG_BATTERY_DS2760=y
> CONFIG_BATTERY_DS2780=y
> # CONFIG_BATTERY_DS2781 is not set
> # CONFIG_BATTERY_DS2782 is not set
> # CONFIG_BATTERY_OLPC is not set
> # CONFIG_BATTERY_SBS is not set
> # CONFIG_BATTERY_BQ27x00 is not set
> CONFIG_BATTERY_DA9052=y
> # CONFIG_BATTERY_MAX17040 is not set
> CONFIG_BATTERY_MAX17042=y
> CONFIG_CHARGER_88PM860X=y
> # CONFIG_CHARGER_PCF50633 is not set
> # CONFIG_CHARGER_MAX8903 is not set
> # CONFIG_CHARGER_LP8727 is not set
> # CONFIG_CHARGER_GPIO is not set
> CONFIG_CHARGER_MANAGER=y
> # CONFIG_CHARGER_MAX14577 is not set
> CONFIG_CHARGER_BQ2415X=y
> CONFIG_CHARGER_BQ24190=y
> CONFIG_CHARGER_BQ24735=y
> CONFIG_CHARGER_SMB347=y
> CONFIG_POWER_RESET=y
> # CONFIG_POWER_RESET_GPIO is not set
> # CONFIG_POWER_AVS is not set
> CONFIG_HWMON=y
> CONFIG_HWMON_VID=y
> # CONFIG_HWMON_DEBUG_CHIP is not set
> 
> #
> # Native drivers
> #
> # CONFIG_SENSORS_AD7414 is not set
> CONFIG_SENSORS_AD7418=y
> # CONFIG_SENSORS_ADM1021 is not set
> # CONFIG_SENSORS_ADM1025 is not set
> CONFIG_SENSORS_ADM1026=y
> CONFIG_SENSORS_ADM1029=y
> CONFIG_SENSORS_ADM1031=y
> # CONFIG_SENSORS_ADM9240 is not set
> CONFIG_SENSORS_ADT7X10=y
> CONFIG_SENSORS_ADT7410=y
> CONFIG_SENSORS_ADT7411=y
> CONFIG_SENSORS_ADT7462=y
> CONFIG_SENSORS_ADT7470=y
> CONFIG_SENSORS_ADT7475=y
> # CONFIG_SENSORS_ASC7621 is not set
> CONFIG_SENSORS_K8TEMP=y
> # CONFIG_SENSORS_K10TEMP is not set
> CONFIG_SENSORS_FAM15H_POWER=y
> CONFIG_SENSORS_APPLESMC=y
> CONFIG_SENSORS_ASB100=y
> CONFIG_SENSORS_ATXP1=y
> CONFIG_SENSORS_DS620=y
> # CONFIG_SENSORS_DS1621 is not set
> CONFIG_SENSORS_DA9052_ADC=y
> CONFIG_SENSORS_I5K_AMB=y
> CONFIG_SENSORS_F71805F=y
> # CONFIG_SENSORS_F71882FG is not set
> CONFIG_SENSORS_F75375S=y
> # CONFIG_SENSORS_MC13783_ADC is not set
> CONFIG_SENSORS_FSCHMD=y
> CONFIG_SENSORS_GL518SM=y
> CONFIG_SENSORS_GL520SM=y
> # CONFIG_SENSORS_G760A is not set
> CONFIG_SENSORS_G762=y
> CONFIG_SENSORS_GPIO_FAN=y
> # CONFIG_SENSORS_HIH6130 is not set
> CONFIG_SENSORS_IBMAEM=y
> CONFIG_SENSORS_IBMPEX=y
> # CONFIG_SENSORS_IIO_HWMON is not set
> CONFIG_SENSORS_CORETEMP=y
> CONFIG_SENSORS_IT87=y
> CONFIG_SENSORS_JC42=y
> # CONFIG_SENSORS_LINEAGE is not set
> CONFIG_SENSORS_LTC2945=y
> CONFIG_SENSORS_LTC4151=y
> CONFIG_SENSORS_LTC4215=y
> CONFIG_SENSORS_LTC4222=y
> CONFIG_SENSORS_LTC4245=y
> CONFIG_SENSORS_LTC4260=y
> # CONFIG_SENSORS_LTC4261 is not set
> CONFIG_SENSORS_MAX16065=y
> CONFIG_SENSORS_MAX1619=y
> CONFIG_SENSORS_MAX1668=y
> # CONFIG_SENSORS_MAX197 is not set
> CONFIG_SENSORS_MAX6639=y
> # CONFIG_SENSORS_MAX6642 is not set
> CONFIG_SENSORS_MAX6650=y
> # CONFIG_SENSORS_MAX6697 is not set
> # CONFIG_SENSORS_HTU21 is not set
> # CONFIG_SENSORS_MCP3021 is not set
> CONFIG_SENSORS_LM63=y
> CONFIG_SENSORS_LM73=y
> CONFIG_SENSORS_LM75=y
> CONFIG_SENSORS_LM77=y
> CONFIG_SENSORS_LM78=y
> CONFIG_SENSORS_LM80=y
> # CONFIG_SENSORS_LM83 is not set
> # CONFIG_SENSORS_LM85 is not set
> CONFIG_SENSORS_LM87=y
> CONFIG_SENSORS_LM90=y
> CONFIG_SENSORS_LM92=y
> # CONFIG_SENSORS_LM93 is not set
> CONFIG_SENSORS_LM95234=y
> CONFIG_SENSORS_LM95241=y
> CONFIG_SENSORS_LM95245=y
> CONFIG_SENSORS_PC87360=y
> # CONFIG_SENSORS_PC87427 is not set
> # CONFIG_SENSORS_NTC_THERMISTOR is not set
> # CONFIG_SENSORS_NCT6683 is not set
> CONFIG_SENSORS_NCT6775=y
> CONFIG_SENSORS_PCF8591=y
> CONFIG_PMBUS=y
> CONFIG_SENSORS_PMBUS=y
> # CONFIG_SENSORS_ADM1275 is not set
> CONFIG_SENSORS_LM25066=y
> # CONFIG_SENSORS_LTC2978 is not set
> # CONFIG_SENSORS_MAX16064 is not set
> CONFIG_SENSORS_MAX34440=y
> CONFIG_SENSORS_MAX8688=y
> CONFIG_SENSORS_UCD9000=y
> # CONFIG_SENSORS_UCD9200 is not set
> CONFIG_SENSORS_ZL6100=y
> CONFIG_SENSORS_SHT15=y
> # CONFIG_SENSORS_SHT21 is not set
> # CONFIG_SENSORS_SHTC1 is not set
> # CONFIG_SENSORS_SIS5595 is not set
> # CONFIG_SENSORS_DME1737 is not set
> CONFIG_SENSORS_EMC1403=y
> CONFIG_SENSORS_EMC2103=y
> # CONFIG_SENSORS_EMC6W201 is not set
> CONFIG_SENSORS_SMSC47M1=y
> CONFIG_SENSORS_SMSC47M192=y
> CONFIG_SENSORS_SMSC47B397=y
> # CONFIG_SENSORS_SCH56XX_COMMON is not set
> # CONFIG_SENSORS_SCH5627 is not set
> # CONFIG_SENSORS_SCH5636 is not set
> CONFIG_SENSORS_SMM665=y
> CONFIG_SENSORS_ADC128D818=y
> # CONFIG_SENSORS_ADS1015 is not set
> CONFIG_SENSORS_ADS7828=y
> CONFIG_SENSORS_AMC6821=y
> CONFIG_SENSORS_INA209=y
> CONFIG_SENSORS_INA2XX=y
> CONFIG_SENSORS_THMC50=y
> CONFIG_SENSORS_TMP102=y
> # CONFIG_SENSORS_TMP401 is not set
> CONFIG_SENSORS_TMP421=y
> CONFIG_SENSORS_VIA_CPUTEMP=y
> CONFIG_SENSORS_VIA686A=y
> CONFIG_SENSORS_VT1211=y
> CONFIG_SENSORS_VT8231=y
> CONFIG_SENSORS_W83781D=y
> CONFIG_SENSORS_W83791D=y
> CONFIG_SENSORS_W83792D=y
> # CONFIG_SENSORS_W83793 is not set
> CONFIG_SENSORS_W83795=y
> CONFIG_SENSORS_W83795_FANCTRL=y
> CONFIG_SENSORS_W83L785TS=y
> CONFIG_SENSORS_W83L786NG=y
> CONFIG_SENSORS_W83627HF=y
> CONFIG_SENSORS_W83627EHF=y
> # CONFIG_SENSORS_WM831X is not set
> CONFIG_SENSORS_WM8350=y
> 
> #
> # ACPI drivers
> #
> CONFIG_SENSORS_ACPI_POWER=y
> CONFIG_SENSORS_ATK0110=y
> CONFIG_THERMAL=y
> CONFIG_THERMAL_HWMON=y
> CONFIG_THERMAL_OF=y
> CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
> # CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
> # CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
> # CONFIG_THERMAL_GOV_FAIR_SHARE is not set
> CONFIG_THERMAL_GOV_STEP_WISE=y
> CONFIG_THERMAL_GOV_USER_SPACE=y
> CONFIG_CPU_THERMAL=y
> # CONFIG_THERMAL_EMULATION is not set
> CONFIG_IMX_THERMAL=y
> # CONFIG_INTEL_POWERCLAMP is not set
> CONFIG_X86_PKG_TEMP_THERMAL=y
> CONFIG_ACPI_INT3403_THERMAL=y
> CONFIG_INTEL_SOC_DTS_THERMAL=y
> 
> #
> # Texas Instruments thermal drivers
> #
> CONFIG_WATCHDOG=y
> CONFIG_WATCHDOG_CORE=y
> CONFIG_WATCHDOG_NOWAYOUT=y
> 
> #
> # Watchdog Device Drivers
> #
> CONFIG_SOFT_WATCHDOG=y
> CONFIG_DA9052_WATCHDOG=y
> # CONFIG_GPIO_WATCHDOG is not set
> # CONFIG_WM831X_WATCHDOG is not set
> # CONFIG_WM8350_WATCHDOG is not set
> CONFIG_XILINX_WATCHDOG=y
> CONFIG_DW_WATCHDOG=y
> CONFIG_RETU_WATCHDOG=y
> CONFIG_ACQUIRE_WDT=y
> CONFIG_ADVANTECH_WDT=y
> CONFIG_ALIM1535_WDT=y
> CONFIG_ALIM7101_WDT=y
> CONFIG_F71808E_WDT=y
> CONFIG_SP5100_TCO=y
> CONFIG_SBC_FITPC2_WATCHDOG=y
> # CONFIG_EUROTECH_WDT is not set
> CONFIG_IB700_WDT=y
> CONFIG_IBMASR=y
> CONFIG_WAFER_WDT=y
> # CONFIG_I6300ESB_WDT is not set
> CONFIG_IE6XX_WDT=y
> # CONFIG_ITCO_WDT is not set
> CONFIG_IT8712F_WDT=y
> # CONFIG_IT87_WDT is not set
> CONFIG_HP_WATCHDOG=y
> CONFIG_KEMPLD_WDT=y
> CONFIG_HPWDT_NMI_DECODING=y
> CONFIG_SC1200_WDT=y
> CONFIG_SCx200_WDT=y
> # CONFIG_PC87413_WDT is not set
> CONFIG_NV_TCO=y
> # CONFIG_60XX_WDT is not set
> # CONFIG_SBC8360_WDT is not set
> CONFIG_SBC7240_WDT=y
> # CONFIG_CPU5_WDT is not set
> # CONFIG_SMSC_SCH311X_WDT is not set
> # CONFIG_SMSC37B787_WDT is not set
> CONFIG_VIA_WDT=y
> # CONFIG_W83627HF_WDT is not set
> CONFIG_W83877F_WDT=y
> CONFIG_W83977F_WDT=y
> CONFIG_MACHZ_WDT=y
> # CONFIG_SBC_EPX_C3_WATCHDOG is not set
> CONFIG_MEN_A21_WDT=y
> 
> #
> # ISA-based Watchdog Cards
> #
> # CONFIG_PCWATCHDOG is not set
> CONFIG_MIXCOMWD=y
> # CONFIG_WDT is not set
> 
> #
> # PCI-based Watchdog Cards
> #
> # CONFIG_PCIPCWATCHDOG is not set
> # CONFIG_WDTPCI is not set
> CONFIG_SSB_POSSIBLE=y
> 
> #
> # Sonics Silicon Backplane
> #
> # CONFIG_SSB is not set
> CONFIG_BCMA_POSSIBLE=y
> 
> #
> # Broadcom specific AMBA
> #
> CONFIG_BCMA=y
> CONFIG_BCMA_HOST_PCI_POSSIBLE=y
> CONFIG_BCMA_HOST_PCI=y
> # CONFIG_BCMA_HOST_SOC is not set
> # CONFIG_BCMA_DRIVER_GMAC_CMN is not set
> CONFIG_BCMA_DRIVER_GPIO=y
> # CONFIG_BCMA_DEBUG is not set
> 
> #
> # Multifunction device drivers
> #
> CONFIG_MFD_CORE=y
> CONFIG_MFD_CS5535=y
> # CONFIG_MFD_AS3711 is not set
> # CONFIG_MFD_AS3722 is not set
> # CONFIG_PMIC_ADP5520 is not set
> CONFIG_MFD_AAT2870_CORE=y
> # CONFIG_MFD_BCM590XX is not set
> # CONFIG_MFD_AXP20X is not set
> # CONFIG_MFD_CROS_EC is not set
> # CONFIG_PMIC_DA903X is not set
> CONFIG_PMIC_DA9052=y
> CONFIG_MFD_DA9052_I2C=y
> # CONFIG_MFD_DA9055 is not set
> # CONFIG_MFD_DA9063 is not set
> CONFIG_MFD_MC13XXX=y
> CONFIG_MFD_MC13XXX_I2C=y
> CONFIG_HTC_PASIC3=y
> # CONFIG_HTC_I2CPLD is not set
> CONFIG_LPC_ICH=y
> CONFIG_LPC_SCH=y
> CONFIG_MFD_JANZ_CMODIO=y
> CONFIG_MFD_KEMPLD=y
> CONFIG_MFD_88PM800=y
> CONFIG_MFD_88PM805=y
> CONFIG_MFD_88PM860X=y
> CONFIG_MFD_MAX14577=y
> # CONFIG_MFD_MAX77686 is not set
> CONFIG_MFD_MAX77693=y
> CONFIG_MFD_MAX8907=y
> # CONFIG_MFD_MAX8925 is not set
> # CONFIG_MFD_MAX8997 is not set
> # CONFIG_MFD_MAX8998 is not set
> CONFIG_MFD_RETU=y
> CONFIG_MFD_PCF50633=y
> CONFIG_PCF50633_ADC=y
> # CONFIG_PCF50633_GPIO is not set
> CONFIG_MFD_RDC321X=y
> CONFIG_MFD_RTSX_PCI=y
> # CONFIG_MFD_RC5T583 is not set
> # CONFIG_MFD_SEC_CORE is not set
> # CONFIG_MFD_SI476X_CORE is not set
> # CONFIG_MFD_SM501 is not set
> # CONFIG_MFD_SMSC is not set
> CONFIG_ABX500_CORE=y
> # CONFIG_AB3100_CORE is not set
> # CONFIG_MFD_STMPE is not set
> CONFIG_MFD_SYSCON=y
> CONFIG_MFD_TI_AM335X_TSCADC=y
> # CONFIG_MFD_LP3943 is not set
> CONFIG_MFD_LP8788=y
> CONFIG_MFD_PALMAS=y
> CONFIG_TPS6105X=y
> # CONFIG_TPS65010 is not set
> CONFIG_TPS6507X=y
> # CONFIG_MFD_TPS65090 is not set
> CONFIG_MFD_TPS65217=y
> CONFIG_MFD_TPS65218=y
> # CONFIG_MFD_TPS6586X is not set
> CONFIG_MFD_TPS65910=y
> CONFIG_MFD_TPS65912=y
> # CONFIG_MFD_TPS65912_I2C is not set
> CONFIG_MFD_TPS80031=y
> # CONFIG_TWL4030_CORE is not set
> CONFIG_TWL6040_CORE=y
> # CONFIG_MFD_WL1273_CORE is not set
> CONFIG_MFD_LM3533=y
> CONFIG_MFD_TIMBERDALE=y
> CONFIG_MFD_TC3589X=y
> # CONFIG_MFD_TMIO is not set
> CONFIG_MFD_VX855=y
> CONFIG_MFD_ARIZONA=y
> CONFIG_MFD_ARIZONA_I2C=y
> # CONFIG_MFD_WM5102 is not set
> # CONFIG_MFD_WM5110 is not set
> CONFIG_MFD_WM8997=y
> CONFIG_MFD_WM8400=y
> CONFIG_MFD_WM831X=y
> CONFIG_MFD_WM831X_I2C=y
> CONFIG_MFD_WM8350=y
> CONFIG_MFD_WM8350_I2C=y
> CONFIG_MFD_WM8994=y
> CONFIG_REGULATOR=y
> CONFIG_REGULATOR_DEBUG=y
> CONFIG_REGULATOR_FIXED_VOLTAGE=y
> # CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
> CONFIG_REGULATOR_USERSPACE_CONSUMER=y
> # CONFIG_REGULATOR_88PM800 is not set
> CONFIG_REGULATOR_88PM8607=y
> # CONFIG_REGULATOR_ACT8865 is not set
> CONFIG_REGULATOR_AD5398=y
> # CONFIG_REGULATOR_ANATOP is not set
> CONFIG_REGULATOR_AAT2870=y
> CONFIG_REGULATOR_DA9052=y
> CONFIG_REGULATOR_DA9210=y
> CONFIG_REGULATOR_FAN53555=y
> # CONFIG_REGULATOR_GPIO is not set
> # CONFIG_REGULATOR_ISL6271A is not set
> CONFIG_REGULATOR_LP3971=y
> CONFIG_REGULATOR_LP3972=y
> # CONFIG_REGULATOR_LP872X is not set
> CONFIG_REGULATOR_LP8755=y
> CONFIG_REGULATOR_LP8788=y
> CONFIG_REGULATOR_LTC3589=y
> CONFIG_REGULATOR_MAX14577=y
> # CONFIG_REGULATOR_MAX1586 is not set
> CONFIG_REGULATOR_MAX8649=y
> CONFIG_REGULATOR_MAX8660=y
> CONFIG_REGULATOR_MAX8907=y
> CONFIG_REGULATOR_MAX8952=y
> # CONFIG_REGULATOR_MAX8973 is not set
> CONFIG_REGULATOR_MAX77693=y
> CONFIG_REGULATOR_MC13XXX_CORE=y
> CONFIG_REGULATOR_MC13783=y
> CONFIG_REGULATOR_MC13892=y
> CONFIG_REGULATOR_PALMAS=y
> CONFIG_REGULATOR_PCF50633=y
> # CONFIG_REGULATOR_PFUZE100 is not set
> # CONFIG_REGULATOR_TPS51632 is not set
> # CONFIG_REGULATOR_TPS6105X is not set
> CONFIG_REGULATOR_TPS62360=y
> CONFIG_REGULATOR_TPS65023=y
> CONFIG_REGULATOR_TPS6507X=y
> CONFIG_REGULATOR_TPS65217=y
> CONFIG_REGULATOR_TPS65218=y
> CONFIG_REGULATOR_TPS65910=y
> CONFIG_REGULATOR_TPS80031=y
> CONFIG_REGULATOR_WM831X=y
> # CONFIG_REGULATOR_WM8350 is not set
> CONFIG_REGULATOR_WM8400=y
> CONFIG_REGULATOR_WM8994=y
> CONFIG_MEDIA_SUPPORT=y
> 
> #
> # Multimedia core support
> #
> # CONFIG_MEDIA_CAMERA_SUPPORT is not set
> # CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
> # CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
> # CONFIG_MEDIA_RADIO_SUPPORT is not set
> # CONFIG_MEDIA_RC_SUPPORT is not set
> # CONFIG_VIDEO_ADV_DEBUG is not set
> # CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
> # CONFIG_TTPCI_EEPROM is not set
> 
> #
> # Media drivers
> #
> # CONFIG_MEDIA_PCI_SUPPORT is not set
> 
> #
> # Supported MMC/SDIO adapters
> #
> 
> #
> # Media ancillary drivers (tuners, sensors, i2c, frontends)
> #
> 
> #
> # Customise DVB Frontends
> #
> CONFIG_DVB_TUNER_DIB0070=y
> CONFIG_DVB_TUNER_DIB0090=y
> 
> #
> # Tools to develop new frontends
> #
> # CONFIG_DVB_DUMMY_FE is not set
> 
> #
> # Graphics support
> #
> # CONFIG_AGP is not set
> CONFIG_VGA_ARB=y
> CONFIG_VGA_ARB_MAX_GPUS=16
> # CONFIG_VGA_SWITCHEROO is not set
> 
> #
> # Direct Rendering Manager
> #
> CONFIG_DRM=y
> CONFIG_DRM_KMS_HELPER=y
> CONFIG_DRM_KMS_FB_HELPER=y
> # CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
> CONFIG_DRM_TTM=y
> 
> #
> # I2C encoder or helper chips
> #
> CONFIG_DRM_I2C_CH7006=y
> # CONFIG_DRM_I2C_SIL164 is not set
> # CONFIG_DRM_I2C_NXP_TDA998X is not set
> # CONFIG_DRM_PTN3460 is not set
> CONFIG_DRM_TDFX=y
> CONFIG_DRM_R128=y
> CONFIG_DRM_RADEON=y
> CONFIG_DRM_RADEON_UMS=y
> CONFIG_DRM_NOUVEAU=y
> CONFIG_NOUVEAU_DEBUG=5
> CONFIG_NOUVEAU_DEBUG_DEFAULT=3
> # CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
> # CONFIG_DRM_I915 is not set
> CONFIG_DRM_MGA=y
> CONFIG_DRM_VIA=y
> CONFIG_DRM_SAVAGE=y
> CONFIG_DRM_VMWGFX=y
> CONFIG_DRM_VMWGFX_FBCON=y
> CONFIG_DRM_GMA500=y
> # CONFIG_DRM_GMA600 is not set
> CONFIG_DRM_GMA3600=y
> # CONFIG_DRM_UDL is not set
> CONFIG_DRM_AST=y
> CONFIG_DRM_MGAG200=y
> # CONFIG_DRM_CIRRUS_QEMU is not set
> CONFIG_DRM_QXL=y
> CONFIG_DRM_BOCHS=y
> 
> #
> # Frame buffer Devices
> #
> CONFIG_FB=y
> # CONFIG_FIRMWARE_EDID is not set
> CONFIG_FB_DDC=y
> CONFIG_FB_BOOT_VESA_SUPPORT=y
> CONFIG_FB_CFB_FILLRECT=y
> CONFIG_FB_CFB_COPYAREA=y
> CONFIG_FB_CFB_IMAGEBLIT=y
> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> CONFIG_FB_SYS_FILLRECT=y
> CONFIG_FB_SYS_COPYAREA=y
> CONFIG_FB_SYS_IMAGEBLIT=y
> # CONFIG_FB_FOREIGN_ENDIAN is not set
> CONFIG_FB_SYS_FOPS=y
> CONFIG_FB_DEFERRED_IO=y
> CONFIG_FB_HECUBA=y
> CONFIG_FB_SVGALIB=y
> # CONFIG_FB_MACMODES is not set
> # CONFIG_FB_BACKLIGHT is not set
> CONFIG_FB_MODE_HELPERS=y
> CONFIG_FB_TILEBLITTING=y
> 
> #
> # Frame buffer hardware drivers
> #
> # CONFIG_FB_CIRRUS is not set
> # CONFIG_FB_PM2 is not set
> # CONFIG_FB_CYBER2000 is not set
> CONFIG_FB_ARC=y
> CONFIG_FB_ASILIANT=y
> # CONFIG_FB_IMSTT is not set
> # CONFIG_FB_VGA16 is not set
> CONFIG_FB_VESA=y
> CONFIG_FB_EFI=y
> CONFIG_FB_N411=y
> CONFIG_FB_HGA=y
> # CONFIG_FB_OPENCORES is not set
> CONFIG_FB_S1D13XXX=y
> # CONFIG_FB_NVIDIA is not set
> CONFIG_FB_RIVA=y
> CONFIG_FB_RIVA_I2C=y
> CONFIG_FB_RIVA_DEBUG=y
> # CONFIG_FB_RIVA_BACKLIGHT is not set
> # CONFIG_FB_I740 is not set
> CONFIG_FB_LE80578=y
> CONFIG_FB_CARILLO_RANCH=y
> # CONFIG_FB_MATROX is not set
> CONFIG_FB_RADEON=y
> CONFIG_FB_RADEON_I2C=y
> # CONFIG_FB_RADEON_BACKLIGHT is not set
> # CONFIG_FB_RADEON_DEBUG is not set
> CONFIG_FB_ATY128=y
> # CONFIG_FB_ATY128_BACKLIGHT is not set
> # CONFIG_FB_ATY is not set
> CONFIG_FB_S3=y
> # CONFIG_FB_S3_DDC is not set
> # CONFIG_FB_SAVAGE is not set
> # CONFIG_FB_SIS is not set
> # CONFIG_FB_VIA is not set
> CONFIG_FB_NEOMAGIC=y
> # CONFIG_FB_KYRO is not set
> CONFIG_FB_3DFX=y
> # CONFIG_FB_3DFX_ACCEL is not set
> CONFIG_FB_3DFX_I2C=y
> # CONFIG_FB_VOODOO1 is not set
> CONFIG_FB_VT8623=y
> CONFIG_FB_TRIDENT=y
> CONFIG_FB_ARK=y
> CONFIG_FB_PM3=y
> # CONFIG_FB_CARMINE is not set
> # CONFIG_FB_GEODE is not set
> # CONFIG_FB_VIRTUAL is not set
> # CONFIG_FB_METRONOME is not set
> # CONFIG_FB_MB862XX is not set
> # CONFIG_FB_BROADSHEET is not set
> CONFIG_FB_AUO_K190X=y
> CONFIG_FB_AUO_K1900=y
> CONFIG_FB_AUO_K1901=y
> CONFIG_FB_HYPERV=y
> CONFIG_FB_SIMPLE=y
> # CONFIG_FB_SSD1307 is not set
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> CONFIG_LCD_CLASS_DEVICE=y
> CONFIG_LCD_PLATFORM=y
> CONFIG_BACKLIGHT_CLASS_DEVICE=y
> # CONFIG_BACKLIGHT_GENERIC is not set
> # CONFIG_BACKLIGHT_LM3533 is not set
> CONFIG_BACKLIGHT_CARILLO_RANCH=y
> CONFIG_BACKLIGHT_DA9052=y
> CONFIG_BACKLIGHT_APPLE=y
> CONFIG_BACKLIGHT_SAHARA=y
> CONFIG_BACKLIGHT_WM831X=y
> CONFIG_BACKLIGHT_ADP8860=y
> # CONFIG_BACKLIGHT_ADP8870 is not set
> CONFIG_BACKLIGHT_88PM860X=y
> CONFIG_BACKLIGHT_PCF50633=y
> CONFIG_BACKLIGHT_AAT2870=y
> CONFIG_BACKLIGHT_LM3639=y
> # CONFIG_BACKLIGHT_TPS65217 is not set
> CONFIG_BACKLIGHT_GPIO=y
> # CONFIG_BACKLIGHT_LV5207LP is not set
> CONFIG_BACKLIGHT_BD6107=y
> CONFIG_VGASTATE=y
> CONFIG_HDMI=y
> # CONFIG_LOGO is not set
> # CONFIG_SOUND is not set
> 
> #
> # HID support
> #
> CONFIG_HID=y
> CONFIG_HID_BATTERY_STRENGTH=y
> # CONFIG_HIDRAW is not set
> # CONFIG_UHID is not set
> CONFIG_HID_GENERIC=y
> 
> #
> # Special HID drivers
> #
> CONFIG_HID_A4TECH=y
> # CONFIG_HID_ACRUX is not set
> CONFIG_HID_APPLE=y
> # CONFIG_HID_AUREAL is not set
> CONFIG_HID_BELKIN=y
> CONFIG_HID_CHERRY=y
> CONFIG_HID_CHICONY=y
> # CONFIG_HID_CYPRESS is not set
> # CONFIG_HID_DRAGONRISE is not set
> CONFIG_HID_EMS_FF=y
> CONFIG_HID_ELECOM=y
> CONFIG_HID_EZKEY=y
> CONFIG_HID_KEYTOUCH=y
> # CONFIG_HID_KYE is not set
> CONFIG_HID_UCLOGIC=y
> CONFIG_HID_WALTOP=y
> # CONFIG_HID_GYRATION is not set
> CONFIG_HID_ICADE=y
> CONFIG_HID_TWINHAN=y
> CONFIG_HID_KENSINGTON=y
> CONFIG_HID_LCPOWER=y
> # CONFIG_HID_LENOVO_TPKBD is not set
> # CONFIG_HID_LOGITECH is not set
> CONFIG_HID_MAGICMOUSE=y
> CONFIG_HID_MICROSOFT=y
> # CONFIG_HID_MONTEREY is not set
> CONFIG_HID_MULTITOUCH=y
> # CONFIG_HID_ORTEK is not set
> CONFIG_HID_PANTHERLORD=y
> CONFIG_PANTHERLORD_FF=y
> CONFIG_HID_PETALYNX=y
> CONFIG_HID_PICOLCD=y
> # CONFIG_HID_PICOLCD_FB is not set
> # CONFIG_HID_PICOLCD_BACKLIGHT is not set
> CONFIG_HID_PICOLCD_LCD=y
> CONFIG_HID_PICOLCD_LEDS=y
> CONFIG_HID_PRIMAX=y
> # CONFIG_HID_SAITEK is not set
> CONFIG_HID_SAMSUNG=y
> CONFIG_HID_SPEEDLINK=y
> CONFIG_HID_STEELSERIES=y
> CONFIG_HID_SUNPLUS=y
> # CONFIG_HID_RMI is not set
> CONFIG_HID_GREENASIA=y
> CONFIG_GREENASIA_FF=y
> CONFIG_HID_HYPERV_MOUSE=y
> CONFIG_HID_SMARTJOYPLUS=y
> # CONFIG_SMARTJOYPLUS_FF is not set
> # CONFIG_HID_TIVO is not set
> CONFIG_HID_TOPSEED=y
> # CONFIG_HID_THINGM is not set
> # CONFIG_HID_THRUSTMASTER is not set
> CONFIG_HID_WACOM=y
> # CONFIG_HID_WIIMOTE is not set
> CONFIG_HID_XINMO=y
> # CONFIG_HID_ZEROPLUS is not set
> CONFIG_HID_ZYDACRON=y
> CONFIG_HID_SENSOR_HUB=y
> 
> #
> # I2C HID support
> #
> # CONFIG_I2C_HID is not set
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
> # CONFIG_TAHVO_USB is not set
> # CONFIG_USB_GADGET is not set
> CONFIG_UWB=y
> CONFIG_UWB_WHCI=y
> # CONFIG_MMC is not set
> CONFIG_MEMSTICK=y
> # CONFIG_MEMSTICK_DEBUG is not set
> 
> #
> # MemoryStick drivers
> #
> # CONFIG_MEMSTICK_UNSAFE_RESUME is not set
> 
> #
> # MemoryStick Host Controller Drivers
> #
> CONFIG_MEMSTICK_TIFM_MS=y
> # CONFIG_MEMSTICK_JMICRON_38X is not set
> CONFIG_MEMSTICK_R592=y
> # CONFIG_MEMSTICK_REALTEK_PCI is not set
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=y
> 
> #
> # LED drivers
> #
> CONFIG_LEDS_88PM860X=y
> CONFIG_LEDS_LM3530=y
> CONFIG_LEDS_LM3533=y
> # CONFIG_LEDS_LM3642 is not set
> # CONFIG_LEDS_NET48XX is not set
> CONFIG_LEDS_WRAP=y
> CONFIG_LEDS_PCA9532=y
> # CONFIG_LEDS_PCA9532_GPIO is not set
> CONFIG_LEDS_GPIO=y
> # CONFIG_LEDS_LP3944 is not set
> CONFIG_LEDS_LP55XX_COMMON=y
> CONFIG_LEDS_LP5521=y
> CONFIG_LEDS_LP5523=y
> # CONFIG_LEDS_LP5562 is not set
> CONFIG_LEDS_LP8501=y
> CONFIG_LEDS_LP8788=y
> CONFIG_LEDS_PCA955X=y
> CONFIG_LEDS_PCA963X=y
> CONFIG_LEDS_WM831X_STATUS=y
> CONFIG_LEDS_WM8350=y
> # CONFIG_LEDS_DA9052 is not set
> CONFIG_LEDS_REGULATOR=y
> CONFIG_LEDS_BD2802=y
> CONFIG_LEDS_LT3593=y
> # CONFIG_LEDS_DELL_NETBOOKS is not set
> CONFIG_LEDS_MC13783=y
> # CONFIG_LEDS_TCA6507 is not set
> CONFIG_LEDS_LM355x=y
> # CONFIG_LEDS_OT200 is not set
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
> CONFIG_LEDS_TRIGGER_TIMER=y
> CONFIG_LEDS_TRIGGER_ONESHOT=y
> # CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
> CONFIG_LEDS_TRIGGER_BACKLIGHT=y
> # CONFIG_LEDS_TRIGGER_CPU is not set
> # CONFIG_LEDS_TRIGGER_GPIO is not set
> # CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
> 
> #
> # iptables trigger is under Netfilter config (LED target)
> #
> # CONFIG_LEDS_TRIGGER_TRANSIENT is not set
> CONFIG_LEDS_TRIGGER_CAMERA=y
> # CONFIG_ACCESSIBILITY is not set
> # CONFIG_EDAC is not set
> CONFIG_RTC_LIB=y
> CONFIG_RTC_CLASS=y
> # CONFIG_RTC_HCTOSYS is not set
> # CONFIG_RTC_SYSTOHC is not set
> # CONFIG_RTC_DEBUG is not set
> 
> #
> # RTC interfaces
> #
> # CONFIG_RTC_INTF_PROC is not set
> CONFIG_RTC_INTF_DEV=y
> CONFIG_RTC_INTF_DEV_UIE_EMUL=y
> # CONFIG_RTC_DRV_TEST is not set
> 
> #
> # I2C RTC drivers
> #
> # CONFIG_RTC_DRV_88PM860X is not set
> CONFIG_RTC_DRV_88PM80X=y
> CONFIG_RTC_DRV_DS1307=y
> CONFIG_RTC_DRV_DS1374=y
> # CONFIG_RTC_DRV_DS1672 is not set
> # CONFIG_RTC_DRV_DS3232 is not set
> # CONFIG_RTC_DRV_HYM8563 is not set
> CONFIG_RTC_DRV_LP8788=y
> # CONFIG_RTC_DRV_MAX6900 is not set
> CONFIG_RTC_DRV_MAX8907=y
> CONFIG_RTC_DRV_RS5C372=y
> # CONFIG_RTC_DRV_ISL1208 is not set
> # CONFIG_RTC_DRV_ISL12022 is not set
> # CONFIG_RTC_DRV_ISL12057 is not set
> # CONFIG_RTC_DRV_X1205 is not set
> CONFIG_RTC_DRV_PALMAS=y
> # CONFIG_RTC_DRV_PCF2127 is not set
> # CONFIG_RTC_DRV_PCF8523 is not set
> CONFIG_RTC_DRV_PCF8563=y
> CONFIG_RTC_DRV_PCF8583=y
> CONFIG_RTC_DRV_M41T80=y
> # CONFIG_RTC_DRV_M41T80_WDT is not set
> CONFIG_RTC_DRV_BQ32K=y
> CONFIG_RTC_DRV_TPS65910=y
> CONFIG_RTC_DRV_TPS80031=y
> CONFIG_RTC_DRV_S35390A=y
> # CONFIG_RTC_DRV_FM3130 is not set
> # CONFIG_RTC_DRV_RX8581 is not set
> CONFIG_RTC_DRV_RX8025=y
> CONFIG_RTC_DRV_EM3027=y
> CONFIG_RTC_DRV_RV3029C2=y
> 
> #
> # SPI RTC drivers
> #
> 
> #
> # Platform RTC drivers
> #
> CONFIG_RTC_DRV_CMOS=y
> # CONFIG_RTC_DRV_DS1286 is not set
> CONFIG_RTC_DRV_DS1511=y
> # CONFIG_RTC_DRV_DS1553 is not set
> CONFIG_RTC_DRV_DS1742=y
> # CONFIG_RTC_DRV_DA9052 is not set
> # CONFIG_RTC_DRV_STK17TA8 is not set
> CONFIG_RTC_DRV_M48T86=y
> CONFIG_RTC_DRV_M48T35=y
> CONFIG_RTC_DRV_M48T59=y
> # CONFIG_RTC_DRV_MSM6242 is not set
> # CONFIG_RTC_DRV_BQ4802 is not set
> CONFIG_RTC_DRV_RP5C01=y
> CONFIG_RTC_DRV_V3020=y
> CONFIG_RTC_DRV_DS2404=y
> CONFIG_RTC_DRV_WM831X=y
> CONFIG_RTC_DRV_WM8350=y
> # CONFIG_RTC_DRV_PCF50633 is not set
> 
> #
> # on-CPU RTC drivers
> #
> CONFIG_RTC_DRV_MC13XXX=y
> # CONFIG_RTC_DRV_SNVS is not set
> # CONFIG_RTC_DRV_MOXART is not set
> CONFIG_RTC_DRV_XGENE=y
> 
> #
> # HID Sensor RTC drivers
> #
> CONFIG_DMADEVICES=y
> CONFIG_DMADEVICES_DEBUG=y
> CONFIG_DMADEVICES_VDEBUG=y
> 
> #
> # DMA Devices
> #
> # CONFIG_INTEL_MID_DMAC is not set
> CONFIG_INTEL_IOATDMA=y
> CONFIG_DW_DMAC_CORE=y
> CONFIG_DW_DMAC=y
> CONFIG_DW_DMAC_PCI=y
> CONFIG_TIMB_DMA=y
> # CONFIG_PCH_DMA is not set
> CONFIG_FSL_EDMA=y
> CONFIG_DMA_ENGINE=y
> CONFIG_DMA_VIRTUAL_CHANNELS=y
> CONFIG_DMA_ACPI=y
> CONFIG_DMA_OF=y
> 
> #
> # DMA Clients
> #
> # CONFIG_ASYNC_TX_DMA is not set
> CONFIG_DMATEST=y
> CONFIG_DMA_ENGINE_RAID=y
> CONFIG_DCA=y
> CONFIG_AUXDISPLAY=y
> CONFIG_UIO=y
> # CONFIG_UIO_CIF is not set
> # CONFIG_UIO_PDRV_GENIRQ is not set
> CONFIG_UIO_DMEM_GENIRQ=y
> CONFIG_UIO_AEC=y
> CONFIG_UIO_SERCOS3=y
> # CONFIG_UIO_PCI_GENERIC is not set
> # CONFIG_UIO_NETX is not set
> # CONFIG_UIO_MF624 is not set
> CONFIG_VFIO_IOMMU_TYPE1=y
> CONFIG_VFIO=y
> CONFIG_VIRT_DRIVERS=y
> CONFIG_VIRTIO=y
> 
> #
> # Virtio drivers
> #
> # CONFIG_VIRTIO_PCI is not set
> CONFIG_VIRTIO_BALLOON=y
> CONFIG_VIRTIO_MMIO=y
> # CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set
> 
> #
> # Microsoft Hyper-V guest support
> #
> CONFIG_HYPERV=y
> # CONFIG_HYPERV_BALLOON is not set
> CONFIG_STAGING=y
> # CONFIG_SLICOSS is not set
> CONFIG_FB_OLPC_DCON=y
> CONFIG_FB_OLPC_DCON_1=y
> # CONFIG_FB_OLPC_DCON_1_5 is not set
> CONFIG_DX_SEP=y
> 
> #
> # IIO staging drivers
> #
> 
> #
> # Accelerometers
> #
> 
> #
> # Analog to digital converters
> #
> CONFIG_AD7291=y
> # CONFIG_AD7606 is not set
> 
> #
> # Analog digital bi-direction converters
> #
> CONFIG_ADT7316=y
> CONFIG_ADT7316_I2C=y
> 
> #
> # Capacitance to digital converters
> #
> CONFIG_AD7150=y
> CONFIG_AD7152=y
> # CONFIG_AD7746 is not set
> 
> #
> # Direct Digital Synthesis
> #
> 
> #
> # Digital gyroscope sensors
> #
> 
> #
> # Network Analyzer, Impedance Converters
> #
> # CONFIG_AD5933 is not set
> 
> #
> # Light sensors
> #
> # CONFIG_SENSORS_ISL29018 is not set
> CONFIG_SENSORS_ISL29028=y
> # CONFIG_TSL2583 is not set
> # CONFIG_TSL2x7x is not set
> 
> #
> # Magnetometer sensors
> #
> CONFIG_SENSORS_HMC5843=y
> 
> #
> # Active energy metering IC
> #
> CONFIG_ADE7854=y
> # CONFIG_ADE7854_I2C is not set
> 
> #
> # Resolver to digital converters
> #
> 
> #
> # Triggers - standalone
> #
> CONFIG_IIO_PERIODIC_RTC_TRIGGER=y
> # CONFIG_IIO_SIMPLE_DUMMY is not set
> CONFIG_CRYSTALHD=y
> # CONFIG_FB_XGI is not set
> CONFIG_ACPI_QUICKSTART=y
> CONFIG_FT1000=y
> 
> #
> # Speakup console speech
> #
> CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
> CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
> CONFIG_STAGING_MEDIA=y
> 
> #
> # Android
> #
> CONFIG_ANDROID=y
> CONFIG_ANDROID_BINDER_IPC=y
> CONFIG_ANDROID_BINDER_IPC_32BIT=y
> # CONFIG_ANDROID_LOGGER is not set
> CONFIG_ANDROID_TIMED_OUTPUT=y
> CONFIG_ANDROID_TIMED_GPIO=y
> # CONFIG_ANDROID_LOW_MEMORY_KILLER is not set
> # CONFIG_ANDROID_INTF_ALARM_DEV is not set
> # CONFIG_SYNC is not set
> # CONFIG_ION is not set
> CONFIG_FIREWIRE_SERIAL=y
> CONFIG_FWTTY_MAX_TOTAL_PORTS=64
> CONFIG_FWTTY_MAX_CARD_PORTS=32
> # CONFIG_XILLYBUS is not set
> # CONFIG_DGNC is not set
> CONFIG_DGAP=y
> # CONFIG_GS_FPGABOOT is not set
> CONFIG_X86_PLATFORM_DEVICES=y
> # CONFIG_ACER_WMI is not set
> CONFIG_ACERHDF=y
> # CONFIG_ALIENWARE_WMI is not set
> CONFIG_ASUS_LAPTOP=y
> # CONFIG_DELL_WMI is not set
> CONFIG_DELL_WMI_AIO=y
> # CONFIG_DELL_SMO8800 is not set
> CONFIG_FUJITSU_LAPTOP=y
> CONFIG_FUJITSU_LAPTOP_DEBUG=y
> CONFIG_FUJITSU_TABLET=y
> CONFIG_TC1100_WMI=y
> CONFIG_HP_ACCEL=y
> CONFIG_HP_WIRELESS=y
> CONFIG_HP_WMI=y
> CONFIG_PANASONIC_LAPTOP=y
> CONFIG_THINKPAD_ACPI=y
> CONFIG_THINKPAD_ACPI_DEBUGFACILITIES=y
> CONFIG_THINKPAD_ACPI_DEBUG=y
> # CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
> CONFIG_THINKPAD_ACPI_VIDEO=y
> CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
> # CONFIG_SENSORS_HDAPS is not set
> CONFIG_ACPI_WMI=y
> CONFIG_MSI_WMI=y
> # CONFIG_TOPSTAR_LAPTOP is not set
> CONFIG_ACPI_TOSHIBA=y
> # CONFIG_TOSHIBA_BT_RFKILL is not set
> # CONFIG_ACPI_CMPC is not set
> # CONFIG_INTEL_IPS is not set
> CONFIG_IBM_RTL=y
> CONFIG_XO15_EBOOK=y
> # CONFIG_SAMSUNG_LAPTOP is not set
> CONFIG_MXM_WMI=y
> CONFIG_SAMSUNG_Q10=y
> CONFIG_APPLE_GMUX=y
> # CONFIG_INTEL_RST is not set
> # CONFIG_INTEL_SMARTCONNECT is not set
> # CONFIG_PVPANIC is not set
> CONFIG_CHROME_PLATFORMS=y
> # CONFIG_CHROMEOS_PSTORE is not set
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
> CONFIG_IOMMU_API=y
> CONFIG_IOMMU_SUPPORT=y
> CONFIG_OF_IOMMU=y
> CONFIG_DMAR_TABLE=y
> CONFIG_INTEL_IOMMU=y
> # CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
> CONFIG_INTEL_IOMMU_FLOPPY_WA=y
> 
> #
> # Remoteproc drivers
> #
> CONFIG_REMOTEPROC=y
> CONFIG_STE_MODEM_RPROC=y
> 
> #
> # Rpmsg drivers
> #
> # CONFIG_PM_DEVFREQ is not set
> CONFIG_EXTCON=y
> 
> #
> # Extcon Device Drivers
> #
> # CONFIG_EXTCON_GPIO is not set
> CONFIG_EXTCON_ADC_JACK=y
> CONFIG_EXTCON_MAX14577=y
> # CONFIG_EXTCON_MAX77693 is not set
> CONFIG_EXTCON_PALMAS=y
> CONFIG_MEMORY=y
> CONFIG_IIO=y
> CONFIG_IIO_BUFFER=y
> CONFIG_IIO_BUFFER_CB=y
> CONFIG_IIO_KFIFO_BUF=y
> CONFIG_IIO_TRIGGERED_BUFFER=y
> CONFIG_IIO_TRIGGER=y
> CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
> 
> #
> # Accelerometers
> #
> CONFIG_BMA180=y
> CONFIG_HID_SENSOR_ACCEL_3D=y
> CONFIG_MMA8452=y
> 
> #
> # Analog to digital converters
> #
> # CONFIG_AD799X is not set
> # CONFIG_LP8788_ADC is not set
> # CONFIG_MAX1363 is not set
> # CONFIG_MCP3422 is not set
> CONFIG_MEN_Z188_ADC=y
> CONFIG_NAU7802=y
> CONFIG_TI_ADC081C=y
> CONFIG_TI_AM335X_ADC=y
> CONFIG_VF610_ADC=y
> 
> #
> # Amplifiers
> #
> 
> #
> # Hid Sensor IIO Common
> #
> CONFIG_HID_SENSOR_IIO_COMMON=y
> CONFIG_HID_SENSOR_IIO_TRIGGER=y
> 
> #
> # Digital to analog converters
> #
> CONFIG_AD5064=y
> CONFIG_AD5380=y
> CONFIG_AD5446=y
> CONFIG_MAX517=y
> CONFIG_MCP4725=y
> 
> #
> # Frequency Synthesizers DDS/PLL
> #
> 
> #
> # Clock Generator/Distribution
> #
> 
> #
> # Phase-Locked Loop (PLL) frequency synthesizers
> #
> 
> #
> # Digital gyroscope sensors
> #
> CONFIG_HID_SENSOR_GYRO_3D=y
> CONFIG_ITG3200=y
> 
> #
> # Humidity sensors
> #
> CONFIG_DHT11=y
> # CONFIG_SI7005 is not set
> 
> #
> # Inertial measurement units
> #
> 
> #
> # Light sensors
> #
> # CONFIG_ADJD_S311 is not set
> CONFIG_APDS9300=y
> CONFIG_CM32181=y
> # CONFIG_CM36651 is not set
> CONFIG_GP2AP020A00F=y
> # CONFIG_HID_SENSOR_ALS is not set
> CONFIG_HID_SENSOR_PROX=y
> # CONFIG_SENSORS_LM3533 is not set
> # CONFIG_LTR501 is not set
> CONFIG_TCS3472=y
> CONFIG_SENSORS_TSL2563=y
> CONFIG_TSL4531=y
> CONFIG_VCNL4000=y
> 
> #
> # Magnetometer sensors
> #
> CONFIG_AK8975=y
> CONFIG_MAG3110=y
> CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
> 
> #
> # Inclinometer sensors
> #
> CONFIG_HID_SENSOR_INCLINOMETER_3D=y
> CONFIG_HID_SENSOR_DEVICE_ROTATION=y
> 
> #
> # Triggers - standalone
> #
> CONFIG_IIO_INTERRUPT_TRIGGER=y
> 
> #
> # Pressure sensors
> #
> CONFIG_HID_SENSOR_PRESS=y
> CONFIG_MPL115=y
> # CONFIG_MPL3115 is not set
> 
> #
> # Lightning sensors
> #
> 
> #
> # Temperature sensors
> #
> CONFIG_MLX90614=y
> # CONFIG_TMP006 is not set
> CONFIG_NTB=y
> CONFIG_VME_BUS=y
> 
> #
> # VME Bridge Drivers
> #
> # CONFIG_VME_CA91CX42 is not set
> # CONFIG_VME_TSI148 is not set
> 
> #
> # VME Board Drivers
> #
> # CONFIG_VMIVME_7805 is not set
> 
> #
> # VME Device Drivers
> #
> CONFIG_VME_USER=y
> CONFIG_VME_PIO2=y
> # CONFIG_PWM is not set
> CONFIG_IRQCHIP=y
> CONFIG_IPACK_BUS=y
> CONFIG_BOARD_TPCI200=y
> CONFIG_SERIAL_IPOCTAL=y
> # CONFIG_RESET_CONTROLLER is not set
> CONFIG_FMC=y
> CONFIG_FMC_FAKEDEV=y
> # CONFIG_FMC_TRIVIAL is not set
> CONFIG_FMC_WRITE_EEPROM=y
> CONFIG_FMC_CHARDEV=y
> 
> #
> # PHY Subsystem
> #
> CONFIG_GENERIC_PHY=y
> # CONFIG_BCM_KONA_USB2_PHY is not set
> CONFIG_PHY_SAMSUNG_USB2=y
> CONFIG_POWERCAP=y
> CONFIG_INTEL_RAPL=y
> CONFIG_MCB=y
> CONFIG_MCB_PCI=y
> 
> #
> # Firmware Drivers
> #
> # CONFIG_EDD is not set
> # CONFIG_FIRMWARE_MEMMAP is not set
> CONFIG_DELL_RBU=y
> # CONFIG_DCDBAS is not set
> CONFIG_ISCSI_IBFT_FIND=y
> # CONFIG_GOOGLE_FIRMWARE is not set
> 
> #
> # EFI (Extensible Firmware Interface) Support
> #
> CONFIG_EFI_VARS=y
> CONFIG_UEFI_CPER=y
> 
> #
> # File systems
> #
> CONFIG_DCACHE_WORD_ACCESS=y
> CONFIG_FS_POSIX_ACL=y
> CONFIG_FILE_LOCKING=y
> CONFIG_FSNOTIFY=y
> CONFIG_DNOTIFY=y
> # CONFIG_INOTIFY_USER is not set
> CONFIG_FANOTIFY=y
> CONFIG_QUOTA=y
> # CONFIG_QUOTA_NETLINK_INTERFACE is not set
> CONFIG_PRINT_QUOTA_WARNING=y
> CONFIG_QUOTA_DEBUG=y
> CONFIG_QUOTA_TREE=y
> CONFIG_QFMT_V1=y
> CONFIG_QFMT_V2=y
> CONFIG_QUOTACTL=y
> CONFIG_AUTOFS4_FS=y
> CONFIG_FUSE_FS=y
> CONFIG_CUSE=y
> 
> #
> # Caches
> #
> # CONFIG_FSCACHE is not set
> 
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> CONFIG_PROC_KCORE=y
> # CONFIG_PROC_SYSCTL is not set
> # CONFIG_PROC_PAGE_MONITOR is not set
> CONFIG_KERNFS=y
> # CONFIG_SYSFS is not set
> # CONFIG_HUGETLBFS is not set
> # CONFIG_HUGETLB_PAGE is not set
> # CONFIG_CONFIGFS_FS is not set
> CONFIG_MISC_FILESYSTEMS=y
> # CONFIG_ECRYPT_FS is not set
> CONFIG_JFFS2_FS=y
> CONFIG_JFFS2_FS_DEBUG=0
> CONFIG_JFFS2_FS_WRITEBUFFER=y
> # CONFIG_JFFS2_FS_WBUF_VERIFY is not set
> # CONFIG_JFFS2_SUMMARY is not set
> CONFIG_JFFS2_FS_XATTR=y
> CONFIG_JFFS2_FS_POSIX_ACL=y
> CONFIG_JFFS2_FS_SECURITY=y
> CONFIG_JFFS2_COMPRESSION_OPTIONS=y
> CONFIG_JFFS2_ZLIB=y
> CONFIG_JFFS2_LZO=y
> CONFIG_JFFS2_RTIME=y
> # CONFIG_JFFS2_RUBIN is not set
> # CONFIG_JFFS2_CMODE_NONE is not set
> # CONFIG_JFFS2_CMODE_PRIORITY is not set
> CONFIG_JFFS2_CMODE_SIZE=y
> # CONFIG_JFFS2_CMODE_FAVOURLZO is not set
> CONFIG_UBIFS_FS=y
> # CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
> CONFIG_UBIFS_FS_LZO=y
> CONFIG_UBIFS_FS_ZLIB=y
> # CONFIG_LOGFS is not set
> CONFIG_ROMFS_FS=y
> CONFIG_ROMFS_BACKED_BY_MTD=y
> CONFIG_ROMFS_ON_MTD=y
> # CONFIG_PSTORE is not set
> CONFIG_EFIVAR_FS=y
> CONFIG_NETWORK_FILESYSTEMS=y
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-1"
> CONFIG_NLS_CODEPAGE_437=y
> CONFIG_NLS_CODEPAGE_737=y
> # CONFIG_NLS_CODEPAGE_775 is not set
> CONFIG_NLS_CODEPAGE_850=y
> # CONFIG_NLS_CODEPAGE_852 is not set
> # CONFIG_NLS_CODEPAGE_855 is not set
> # CONFIG_NLS_CODEPAGE_857 is not set
> CONFIG_NLS_CODEPAGE_860=y
> CONFIG_NLS_CODEPAGE_861=y
> CONFIG_NLS_CODEPAGE_862=y
> # CONFIG_NLS_CODEPAGE_863 is not set
> # CONFIG_NLS_CODEPAGE_864 is not set
> CONFIG_NLS_CODEPAGE_865=y
> CONFIG_NLS_CODEPAGE_866=y
> CONFIG_NLS_CODEPAGE_869=y
> CONFIG_NLS_CODEPAGE_936=y
> CONFIG_NLS_CODEPAGE_950=y
> # CONFIG_NLS_CODEPAGE_932 is not set
> CONFIG_NLS_CODEPAGE_949=y
> CONFIG_NLS_CODEPAGE_874=y
> CONFIG_NLS_ISO8859_8=y
> CONFIG_NLS_CODEPAGE_1250=y
> CONFIG_NLS_CODEPAGE_1251=y
> CONFIG_NLS_ASCII=y
> CONFIG_NLS_ISO8859_1=y
> # CONFIG_NLS_ISO8859_2 is not set
> CONFIG_NLS_ISO8859_3=y
> # CONFIG_NLS_ISO8859_4 is not set
> CONFIG_NLS_ISO8859_5=y
> CONFIG_NLS_ISO8859_6=y
> CONFIG_NLS_ISO8859_7=y
> CONFIG_NLS_ISO8859_9=y
> # CONFIG_NLS_ISO8859_13 is not set
> CONFIG_NLS_ISO8859_14=y
> # CONFIG_NLS_ISO8859_15 is not set
> CONFIG_NLS_KOI8_R=y
> CONFIG_NLS_KOI8_U=y
> # CONFIG_NLS_MAC_ROMAN is not set
> CONFIG_NLS_MAC_CELTIC=y
> CONFIG_NLS_MAC_CENTEURO=y
> CONFIG_NLS_MAC_CROATIAN=y
> CONFIG_NLS_MAC_CYRILLIC=y
> # CONFIG_NLS_MAC_GAELIC is not set
> CONFIG_NLS_MAC_GREEK=y
> CONFIG_NLS_MAC_ICELAND=y
> # CONFIG_NLS_MAC_INUIT is not set
> CONFIG_NLS_MAC_ROMANIAN=y
> # CONFIG_NLS_MAC_TURKISH is not set
> CONFIG_NLS_UTF8=y
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
> 
> #
> # Compile-time checks and compiler options
> #
> # CONFIG_DEBUG_INFO is not set
> # CONFIG_ENABLE_WARN_DEPRECATED is not set
> # CONFIG_ENABLE_MUST_CHECK is not set
> CONFIG_FRAME_WARN=1024
> CONFIG_STRIP_ASM_SYMS=y
> # CONFIG_READABLE_ASM is not set
> # CONFIG_UNUSED_SYMBOLS is not set
> # CONFIG_DEBUG_FS is not set
> CONFIG_HEADERS_CHECK=y
> CONFIG_DEBUG_SECTION_MISMATCH=y
> CONFIG_ARCH_WANT_FRAME_POINTERS=y
> CONFIG_FRAME_POINTER=y
> # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
> # CONFIG_MAGIC_SYSRQ is not set
> CONFIG_DEBUG_KERNEL=y
> 
> #
> # Memory Debugging
> #
> CONFIG_DEBUG_PAGEALLOC=y
> CONFIG_WANT_PAGE_DEBUG_FLAGS=y
> CONFIG_PAGE_GUARD=y
> # CONFIG_DEBUG_OBJECTS is not set
> # CONFIG_DEBUG_SLAB is not set
> CONFIG_HAVE_DEBUG_KMEMLEAK=y
> # CONFIG_DEBUG_KMEMLEAK is not set
> # CONFIG_DEBUG_STACK_USAGE is not set
> # CONFIG_DEBUG_VM is not set
> # CONFIG_DEBUG_VIRTUAL is not set
> # CONFIG_DEBUG_MEMORY_INIT is not set
> # CONFIG_DEBUG_HIGHMEM is not set
> CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
> # CONFIG_DEBUG_STACKOVERFLOW is not set
> CONFIG_HAVE_ARCH_KMEMCHECK=y
> # CONFIG_KMEMCHECK is not set
> CONFIG_DEBUG_SHIRQ=y
> 
> #
> # Debug Lockups and Hangs
> #
> CONFIG_LOCKUP_DETECTOR=y
> CONFIG_HARDLOCKUP_DETECTOR=y
> CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
> CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
> # CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
> CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
> CONFIG_DETECT_HUNG_TASK=y
> CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
> # CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
> CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
> CONFIG_PANIC_ON_OOPS=y
> CONFIG_PANIC_ON_OOPS_VALUE=1
> CONFIG_PANIC_TIMEOUT=0
> CONFIG_SCHED_DEBUG=y
> CONFIG_SCHEDSTATS=y
> CONFIG_TIMER_STATS=y
> 
> #
> # Lock Debugging (spinlocks, mutexes, etc...)
> #
> # CONFIG_DEBUG_RT_MUTEXES is not set
> # CONFIG_RT_MUTEX_TESTER is not set
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
> CONFIG_DEBUG_LOCK_ALLOC=y
> # CONFIG_PROVE_LOCKING is not set
> CONFIG_LOCKDEP=y
> CONFIG_LOCK_STAT=y
> CONFIG_DEBUG_LOCKDEP=y
> CONFIG_DEBUG_ATOMIC_SLEEP=y
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> CONFIG_LOCK_TORTURE_TEST=y
> CONFIG_STACKTRACE=y
> # CONFIG_DEBUG_KOBJECT is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> CONFIG_DEBUG_LIST=y
> CONFIG_DEBUG_PI_LIST=y
> # CONFIG_DEBUG_SG is not set
> CONFIG_DEBUG_NOTIFIERS=y
> # CONFIG_DEBUG_CREDENTIALS is not set
> 
> #
> # RCU Debugging
> #
> CONFIG_SPARSE_RCU_POINTER=y
> CONFIG_TORTURE_TEST=y
> # CONFIG_RCU_TORTURE_TEST is not set
> # CONFIG_RCU_TRACE is not set
> # CONFIG_NOTIFIER_ERROR_INJECTION is not set
> CONFIG_FAULT_INJECTION=y
> CONFIG_FAILSLAB=y
> # CONFIG_FAIL_PAGE_ALLOC is not set
> # CONFIG_LATENCYTOP is not set
> CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
> # CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
> CONFIG_USER_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
> CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
> CONFIG_HAVE_C_RECORDMCOUNT=y
> CONFIG_TRACING_SUPPORT=y
> # CONFIG_FTRACE is not set
> 
> #
> # Runtime Testing
> #
> # CONFIG_TEST_LIST_SORT is not set
> # CONFIG_BACKTRACE_SELF_TEST is not set
> # CONFIG_RBTREE_TEST is not set
> # CONFIG_ATOMIC64_SELFTEST is not set
> # CONFIG_TEST_STRING_HELPERS is not set
> # CONFIG_TEST_KSTRTOX is not set
> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> # CONFIG_BUILD_DOCSRC is not set
> # CONFIG_DMA_API_DEBUG is not set
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_KGDB is not set
> # CONFIG_STRICT_DEVMEM is not set
> CONFIG_X86_VERBOSE_BOOTUP=y
> CONFIG_EARLY_PRINTK=y
> CONFIG_EARLY_PRINTK_DBGP=y
> CONFIG_EARLY_PRINTK_EFI=y
> # CONFIG_X86_PTDUMP is not set
> CONFIG_DEBUG_RODATA=y
> # CONFIG_DEBUG_RODATA_TEST is not set
> CONFIG_DOUBLEFAULT=y
> CONFIG_DEBUG_TLBFLUSH=y
> CONFIG_IOMMU_STRESS=y
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> CONFIG_IO_DELAY_0X80=y
> # CONFIG_IO_DELAY_0XED is not set
> # CONFIG_IO_DELAY_UDELAY is not set
> # CONFIG_IO_DELAY_NONE is not set
> CONFIG_DEFAULT_IO_DELAY_TYPE=0
> # CONFIG_CPA_DEBUG is not set
> CONFIG_OPTIMIZE_INLINING=y
> # CONFIG_DEBUG_NMI_SELFTEST is not set
> # CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set
> 
> #
> # Security options
> #
> CONFIG_KEYS=y
> # CONFIG_PERSISTENT_KEYRINGS is not set
> # CONFIG_ENCRYPTED_KEYS is not set
> # CONFIG_KEYS_DEBUG_PROC_KEYS is not set
> # CONFIG_SECURITY_DMESG_RESTRICT is not set
> # CONFIG_SECURITYFS is not set
> # CONFIG_INTEL_TXT is not set
> CONFIG_DEFAULT_SECURITY_DAC=y
> CONFIG_DEFAULT_SECURITY=""
> CONFIG_CRYPTO=y
> 
> #
> # Crypto core or helper
> #
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
> CONFIG_CRYPTO_PCOMP=y
> CONFIG_CRYPTO_PCOMP2=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> # CONFIG_CRYPTO_USER is not set
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
> CONFIG_CRYPTO_GF128MUL=y
> CONFIG_CRYPTO_NULL=y
> CONFIG_CRYPTO_WORKQUEUE=y
> CONFIG_CRYPTO_CRYPTD=y
> CONFIG_CRYPTO_AUTHENC=y
> CONFIG_CRYPTO_ABLK_HELPER=y
> CONFIG_CRYPTO_GLUE_HELPER_X86=y
> 
> #
> # Authenticated Encryption with Associated Data
> #
> CONFIG_CRYPTO_CCM=y
> CONFIG_CRYPTO_GCM=y
> CONFIG_CRYPTO_SEQIV=y
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=y
> CONFIG_CRYPTO_CTR=y
> CONFIG_CRYPTO_CTS=y
> CONFIG_CRYPTO_ECB=y
> CONFIG_CRYPTO_LRW=y
> CONFIG_CRYPTO_PCBC=y
> CONFIG_CRYPTO_XTS=y
> 
> #
> # Hash modes
> #
> # CONFIG_CRYPTO_CMAC is not set
> CONFIG_CRYPTO_HMAC=y
> # CONFIG_CRYPTO_XCBC is not set
> # CONFIG_CRYPTO_VMAC is not set
> 
> #
> # Digest
> #
> # CONFIG_CRYPTO_CRC32C is not set
> CONFIG_CRYPTO_CRC32C_INTEL=y
> # CONFIG_CRYPTO_CRC32 is not set
> # CONFIG_CRYPTO_CRC32_PCLMUL is not set
> CONFIG_CRYPTO_CRCT10DIF=y
> CONFIG_CRYPTO_GHASH=y
> CONFIG_CRYPTO_MD4=y
> # CONFIG_CRYPTO_MD5 is not set
> CONFIG_CRYPTO_MICHAEL_MIC=y
> # CONFIG_CRYPTO_RMD128 is not set
> CONFIG_CRYPTO_RMD160=y
> CONFIG_CRYPTO_RMD256=y
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
> CONFIG_CRYPTO_AES_586=y
> # CONFIG_CRYPTO_AES_NI_INTEL is not set
> CONFIG_CRYPTO_ANUBIS=y
> # CONFIG_CRYPTO_ARC4 is not set
> CONFIG_CRYPTO_BLOWFISH=y
> CONFIG_CRYPTO_BLOWFISH_COMMON=y
> CONFIG_CRYPTO_CAMELLIA=y
> CONFIG_CRYPTO_CAST_COMMON=y
> CONFIG_CRYPTO_CAST5=y
> CONFIG_CRYPTO_CAST6=y
> CONFIG_CRYPTO_DES=y
> # CONFIG_CRYPTO_FCRYPT is not set
> # CONFIG_CRYPTO_KHAZAD is not set
> CONFIG_CRYPTO_SALSA20=y
> CONFIG_CRYPTO_SALSA20_586=y
> CONFIG_CRYPTO_SEED=y
> CONFIG_CRYPTO_SERPENT=y
> CONFIG_CRYPTO_SERPENT_SSE2_586=y
> CONFIG_CRYPTO_TEA=y
> CONFIG_CRYPTO_TWOFISH=y
> CONFIG_CRYPTO_TWOFISH_COMMON=y
> CONFIG_CRYPTO_TWOFISH_586=y
> 
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=y
> CONFIG_CRYPTO_ZLIB=y
> CONFIG_CRYPTO_LZO=y
> CONFIG_CRYPTO_LZ4=y
> CONFIG_CRYPTO_LZ4HC=y
> 
> #
> # Random Number Generation
> #
> # CONFIG_CRYPTO_ANSI_CPRNG is not set
> # CONFIG_CRYPTO_USER_API_HASH is not set
> # CONFIG_CRYPTO_USER_API_SKCIPHER is not set
> CONFIG_CRYPTO_HW=y
> CONFIG_CRYPTO_DEV_PADLOCK=y
> CONFIG_CRYPTO_DEV_PADLOCK_AES=y
> # CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
> CONFIG_CRYPTO_DEV_GEODE=y
> # CONFIG_CRYPTO_DEV_HIFN_795X is not set
> # CONFIG_CRYPTO_DEV_CCP is not set
> CONFIG_ASYMMETRIC_KEY_TYPE=y
> # CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE is not set
> CONFIG_PUBLIC_KEY_ALGO_RSA=y
> CONFIG_HAVE_KVM=y
> CONFIG_VIRTUALIZATION=y
> # CONFIG_KVM is not set
> # CONFIG_BINARY_PRINTF is not set
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
> # CONFIG_CRC_CCITT is not set
> CONFIG_CRC16=y
> CONFIG_CRC_T10DIF=y
> CONFIG_CRC_ITU_T=y
> CONFIG_CRC32=y
> CONFIG_CRC32_SELFTEST=y
> # CONFIG_CRC32_SLICEBY8 is not set
> # CONFIG_CRC32_SLICEBY4 is not set
> CONFIG_CRC32_SARWATE=y
> # CONFIG_CRC32_BIT is not set
> # CONFIG_CRC7 is not set
> # CONFIG_LIBCRC32C is not set
> CONFIG_CRC8=y
> # CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
> CONFIG_RANDOM32_SELFTEST=y
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_LZO_COMPRESS=y
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_LZ4_COMPRESS=y
> CONFIG_LZ4HC_COMPRESS=y
> CONFIG_LZ4_DECOMPRESS=y
> CONFIG_XZ_DEC=y
> CONFIG_XZ_DEC_X86=y
> # CONFIG_XZ_DEC_POWERPC is not set
> # CONFIG_XZ_DEC_IA64 is not set
> # CONFIG_XZ_DEC_ARM is not set
> CONFIG_XZ_DEC_ARMTHUMB=y
> # CONFIG_XZ_DEC_SPARC is not set
> CONFIG_XZ_DEC_BCJ=y
> CONFIG_XZ_DEC_TEST=y
> CONFIG_DECOMPRESS_GZIP=y
> CONFIG_GENERIC_ALLOCATOR=y
> CONFIG_BCH=y
> CONFIG_BCH_CONST_PARAMS=y
> CONFIG_ASSOCIATIVE_ARRAY=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT_MAP=y
> CONFIG_HAS_DMA=y
> CONFIG_NLATTR=y
> CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
> # CONFIG_AVERAGE is not set
> CONFIG_CLZ_TAB=y
> # CONFIG_CORDIC is not set
> CONFIG_DDR=y
> CONFIG_MPILIB=y
> CONFIG_UCS2_STRING=y
> CONFIG_FONT_SUPPORT=y
> CONFIG_FONT_8x16=y
> CONFIG_FONT_AUTOSELECT=y


-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

