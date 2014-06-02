Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbaFBIEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 04:04:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:1891 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbaFBIEm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 04:04:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,955,1392192000"; 
   d="scan'208";a="521325433"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Jet Chen <jet.chen@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [drm] INFO: possible recursive locking detected
In-Reply-To: <5388075D.4000809@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <5388075D.4000809@intel.com>
User-Agent: Notmuch/0.18+16~gec02089 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Mon, 02 Jun 2014 11:04:35 +0300
Message-ID: <87mwdvhh4c.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2014, Jet Chen <jet.chen@intel.com> wrote:
> Hi Jesse,
>
> 0day kernel testing robot got the below dmesg and the first bad commit is
>
> git://people.freedesktop.org/~jbarnes/linux async-fb-probe

Do I understand correctly that this is only present in one of Jesse's
personal branches? The distribution seems quite out of proportion...

BR,
Jani.


> commit b739c9982801e5f76097311b67dfd76891b10988
> Author:     Jesse Barnes <jbarnes@virtuousgeek.org>
> AuthorDate: Wed May 28 10:21:17 2014 -0700
> Commit:     Jesse Barnes <jbarnes@virtuousgeek.org>
> CommitDate: Wed May 28 12:17:34 2014 -0700
>
>     drm: take modeset locks around initial fb helper probing
>         Drivers ought to complain otherwise.
>         Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>
> +------------------------------------------+------------+------------+
> |                                          | 071f9c57ee | b739c99828 |
> +------------------------------------------+------------+------------+
> | boot_successes                           | 60         | 0          |
> | boot_failures                            | 0          | 20         |
> | INFO:possible_recursive_locking_detected | 0          | 20         |
> | BUG:kernel_boot_hang                     | 0          | 20         |
> | backtrace:drm_fb_helper_initial_config   | 0          | 20         |
> | backtrace:cirrus_fbdev_init              | 0          | 20         |
> | backtrace:cirrus_modeset_init            | 0          | 20         |
> | backtrace:__pci_register_driver          | 0          | 20         |
> | backtrace:drm_pci_init                   | 0          | 20         |
> | backtrace:cirrus_init                    | 0          | 20         |
> | backtrace:kernel_init_freeable           | 0          | 20         |
> +------------------------------------------+------------+------------+
>
>
> [    4.328875] [TTM] Initializing pool allocator
> [    4.329713] [    4.329843] =============================================
> [    4.330272] [ INFO: possible recursive locking detected ]
> [    4.330294] 3.15.0-rc5-00087-gb739c99 #636 Not tainted
> [    4.330294] ---------------------------------------------
> [    4.330294] swapper/1 is trying to acquire lock:
> [    4.330294]  (&dev->mode_config.mutex){+.+.+.}, at: [<8158fa28>] drm_modeset_lock_all+0x28/0xa0
> [    4.330294] [    4.330294] but task is already holding lock:
> [    4.330294]  (&dev->mode_config.mutex){+.+.+.}, at: [<8157720e>] drm_fb_helper_initial_config+0x6e/0x890
> [    4.330294] [    4.330294] other info that might help us debug this:
> [    4.330294]  Possible unsafe locking scenario:
> [    4.330294] [    4.330294]        CPU0
> [    4.330294]        ----
> [    4.330294]   lock(&dev->mode_config.mutex);
> [    4.330294]   lock(&dev->mode_config.mutex);
> [    4.330294] [    4.330294]  *** DEADLOCK ***
> [    4.330294] [    4.330294]  May be due to missing lock nesting notation
> [    4.330294] [    4.330294] 4 locks held by swapper/1:
> [    4.330294]  #0:  (&dev->mutex){......}, at: [<81770e9c>] __driver_attach+0x7c/0x140
> [    4.330294]  #1:  (&dev->mutex){......}, at: [<81770eb6>] __driver_attach+0x96/0x140
> [    4.330294]  #2:  (drm_global_mutex){+.+.+.}, at: [<81587f89>] drm_dev_register+0x29/0x210
> [    4.330294]  #3:  (&dev->mode_config.mutex){+.+.+.}, at: [<8157720e>] drm_fb_helper_initial_config+0x6e/0x890
> [    4.330294] [    4.330294] stack backtrace:
> [    4.330294] CPU: 0 PID: 1 Comm: swapper Not tainted 3.15.0-rc5-00087-gb739c99 #636
> [    4.330294]  82772bd0 91c25b70 81c8091f 91c25bf0 810a75e6 82031095 91c1922c 00000001
> [    4.330294]  e891fd4b 00000004 91c19478 82772bd0 00000000 91c19000 91c19478 8274ddb8
> [    4.330294]  82543d00 91c25bcc 0000073c 00000000 00000000 00000000 00000001 91c19478
> [    4.330294] Call Trace:
> [    4.330294]  [<81c8091f>] dump_stack+0x40/0x5e
> [    4.330294]  [<810a75e6>] validate_chain.isra.25+0xe66/0x1f70
> [    4.330294]  [<8109a413>] ? sched_clock_cpu+0x153/0x1c0
> [    4.330294]  [<810ae42e>] __lock_acquire+0x149e/0x1780
> [    4.330294]  [<810ae42e>] ? __lock_acquire+0x149e/0x1780
> [    4.330294]  [<810ae865>] lock_acquire+0x155/0x1d0
> [    4.330294]  [<8158fa28>] ? drm_modeset_lock_all+0x28/0xa0
> [    4.330294]  [<81c9f2a9>] mutex_lock_nested+0x99/0x6a0
> [    4.330294]  [<8158fa28>] ? drm_modeset_lock_all+0x28/0xa0
> [    4.330294]  [<8158fa28>] ? drm_modeset_lock_all+0x28/0xa0
> [    4.330294]  [<8157720e>] ? drm_fb_helper_initial_config+0x6e/0x890
> [    4.330294]  [<8157720e>] ? drm_fb_helper_initial_config+0x6e/0x890
> [    4.330294]  [<8158fa28>] drm_modeset_lock_all+0x28/0xa0
> [    4.330294]  [<81577223>] drm_fb_helper_initial_config+0x83/0x890
> [    4.330294]  [<810a97b2>] ? trace_hardirqs_on_caller+0x2d2/0x420
> [    4.330294]  [<810a9927>] ? trace_hardirqs_on+0x27/0x40
> [    4.330294]  [<8158fa78>] ? drm_modeset_lock_all+0x78/0xa0
> [    4.330294]  [<8156f4fe>] ? drm_helper_encoder_in_use+0xe/0x130
> [    4.330294]  [<8158fad9>] ? drm_modeset_unlock_all+0x39/0x80
> [    4.330294]  [<8174a06c>] cirrus_fbdev_init+0x10c/0x130
> [    4.330294]  [<8174917b>] cirrus_modeset_init+0x27b/0x340
> [    4.330294]  [<81747483>] cirrus_driver_load+0x113/0x1d0
> [    4.330294]  [<81588047>] drm_dev_register+0xe7/0x210
> [    4.330294]  [<8158ba80>] drm_get_pci_dev+0x200/0x340
> [    4.330294]  [<8118a93d>] ? slob_free+0x5dd/0x610
> [    4.330294]  [<81749416>] cirrus_pci_probe+0x126/0x160
> [    4.330294]  [<81338b7a>] pci_device_probe+0xda/0x1f0
> [    4.330294]  [<8120eef5>] ? sysfs_create_link+0x25/0x40
> [    4.330294]  [<81770b9f>] really_probe+0x16f/0x3f0
> [    4.330294]  [<81770ef9>] __driver_attach+0xd9/0x140
> [    4.330294]  [<81770e20>] ? really_probe+0x3f0/0x3f0
> [    4.330294]  [<8176d932>] bus_for_each_dev+0xb2/0x140
> [    4.330294]  [<817705cc>] driver_attach+0x2c/0x40
> [    4.330294]  [<81770e20>] ? really_probe+0x3f0/0x3f0
> [    4.330294]  [<8176ead9>] bus_add_driver+0x129/0x3e0
> [    4.330294]  [<81771855>] driver_register+0x165/0x1f0
> [    4.330294]  [<8249f39c>] ? mgag200_init+0x4f/0x4f
> [    4.330294]  [<81338cf6>] __pci_register_driver+0x66/0x80
> [    4.330294]  [<8158bc4b>] drm_pci_init+0x8b/0x1b0
> [    4.330294]  [<8249f39c>] ? mgag200_init+0x4f/0x4f
> [    4.330294]  [<8249f3d3>] cirrus_init+0x37/0x4f
> [    4.330294]  [<82458598>] do_one_initcall+0xf4/0x21e
> [    4.330294]  [<81080016>] ? parameq+0x26/0x110
> [    4.330294]  [<812dd939>] ? strlen+0x9/0x40
> [    4.330294]  [<82457735>] ? repair_env_string+0x32/0xd3
> [    4.330294]  [<81080522>] ? parse_args+0x422/0x610
> [    4.330294]  [<824588ca>] kernel_init_freeable+0x208/0x38b
> [    4.330294]  [<82457703>] ? do_early_param+0x12b/0x12b
> [    4.330294]  [<81c77fee>] kernel_init+0x1e/0x220
> [    4.330294]  [<81094e0f>] ? schedule_tail+0x1f/0xa0
> [    4.330294]  [<81ca7700>] ret_from_kernel_thread+0x20/0x30
> [    4.330294]  [<81c77fd0>] ? rest_init+0x180/0x180
> [   61.921707] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0 [   82.580118] random: nonblocking pool is initialized
> [  121.920851] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0
> git bisect start 05f78283c03d79d7d03af2ba7570156c71ba9b0d c7208164e66f63e3ec1759b98087849286410741 --
> git bisect good 8bc69a36895ecd9f0f7304b71d5dee85c5c35ee4  # 02:59     20+      0  Merge 'jbarnes/pm-fixes' into devel-roam-i386-201405300201
> git bisect good 369cef62bbd75688f151851a939b827391c8e62f  # 03:12     20+      0  Merge 'wireless-next/master' into devel-roam-i386-201405300201
> git bisect  bad fcb2133e3b5207d456c048ac4008681e012bb410  # 03:35      0-      5  Merge 'jbarnes/async-fb-probe' into devel-roam-i386-201405300201
> git bisect  bad b739c9982801e5f76097311b67dfd76891b10988  # 03:52      0-      6  drm: take modeset locks around initial fb helper probing
> git bisect good 071f9c57eea4876288ba1254c9ac3b0f077c2dd6  # 04:07     20+      0  drm/i915/vlv: enable PPGTT
> # first bad commit: [b739c9982801e5f76097311b67dfd76891b10988] drm: take modeset locks around initial fb helper probing
> git bisect good 071f9c57eea4876288ba1254c9ac3b0f077c2dd6  # 04:10     60+      0  drm/i915/vlv: enable PPGTT
> git bisect  bad 05f78283c03d79d7d03af2ba7570156c71ba9b0d  # 04:10      0-     13  0day head guard for 'devel-roam-i386-201405300201'
> git bisect good f2159d1e99612ceb94bf9a2dc2fbca409d828b1b  # 04:18     60+      0  Merge tag 'sound-3.15-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
> git bisect good 07dd999f99b1135fdece697e17c4f4248ab40f72  # 04:27     60+     60  Add linux-next specific files for 20140529
>
>
> This script may reproduce the error.
>
> -----------------------------------------------------------------------------
> #!/bin/bash
>
> kernel=$1
> initrd=quantal-core-i386.cgz
>
> wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/$initrd
>
> kvm=(
> 	qemu-system-x86_64 -cpu kvm64 -enable-kvm 	-kernel $kernel
> 	-initrd $initrd
> 	-smp 2
> 	-m 256M
> 	-net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio
> 	-net user,vlan=0
> 	-net nic,vlan=1,model=e1000
> 	-net user,vlan=1
> 	-boot order=nc
> 	-no-reboot
> 	-watchdog i6300esb
> 	-serial stdio
> 	-display none
> 	-monitor null
> )
>
> append=(
> 	debug
> 	sched_debug
> 	apic=debug
> 	ignore_loglevel
> 	sysrq_always_enabled
> 	panic=10
> 	prompt_ramdisk=0
> 	earlyprintk=ttyS0,115200
> 	console=ttyS0,115200
> 	console=tty0
> 	vga=normal
> 	root=/dev/ram0
> 	rw
> )
>
> "${kvm[@]}" --append "${append[*]}"
> -----------------------------------------------------------------------------
>
> Thanks,
> Jet
> early console in setup code
> [    0.000000] Linux version 3.15.0-rc5-00087-gb739c99 (kbuild@roam) (gcc version 4.8.2 (Debian 4.8.2-18) ) #636 Fri May 30 03:36:46 CST 2014
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   NSC Geode by NSC
> [    0.000000]   Cyrix CyrixInstead
> [    0.000000]   Transmeta GenuineTMx86
> [    0.000000]   Transmeta TransmetaCPU
> [    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
> [    0.000000] CPU: Your system may be unstable.
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
> [    0.000000] Hypervisor detected: KVM
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x13ffe max_arch_pfn = 0x100000
> [    0.000000] Scanning 1 areas for low memory corruption
> [    0.000000] initial memory mapped: [mem 0x00000000-0x033fffff]
> [    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x12000000-0x123fffff]
> [    0.000000]  [mem 0x12000000-0x123fffff] page 4k
> [    0.000000] BRK [0x02e1d000, 0x02e1dfff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x10000000-0x11ffffff]
> [    0.000000]  [mem 0x10000000-0x11ffffff] page 4k
> [    0.000000] BRK [0x02e1e000, 0x02e1efff] PGTABLE
> [    0.000000] BRK [0x02e1f000, 0x02e1ffff] PGTABLE
> [    0.000000] BRK [0x02e20000, 0x02e20fff] PGTABLE
> [    0.000000] BRK [0x02e21000, 0x02e21fff] PGTABLE
> [    0.000000] BRK [0x02e22000, 0x02e22fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
> [    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x12400000-0x13ffdfff]
> [    0.000000]  [mem 0x12400000-0x13ffdfff] page 4k
> [    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
> [    0.000000] ACPI: RSDP 0x000FD950 000014 (v00 BOCHS )
> [    0.000000] ACPI: RSDT 0x13FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> [    0.000000] ACPI: DSDT 0x13FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 INTL 20100528)
> [    0.000000] ACPI: FACS 0x13FFFF40 000040
> [    0.000000] ACPI: SSDT 0x13FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: APIC 0x13FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> [    0.000000] ACPI: HPET 0x13FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
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
> [    0.000000] free_area_init_node: node 0, pgdat 8244f020, node_mem_map 924db024
> [    0.000000]   DMA zone: 36 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 3998 pages, LIFO batch:0
> [    0.000000]   Normal zone: 684 pages used for memmap
> [    0.000000]   Normal zone: 77822 pages, LIFO batch:15
> [    0.000000] ACPI: PM-Timer IO Port: 0xb008
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] KVM setup async PF for cpu 0
> [    0.000000] kvm-stealtime: cpu 0, msr 2137100
> [    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on KVM
> [    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
> [    0.000000] pcpu-alloc: [0] 0 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 81100
> [    0.000000] Kernel command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/i386-randconfig-r3-0530/linux-devel:devel-roam-i386-201405300201:b739c9982801e5f76097311b67dfd76891b10988:bisect-linux/.vmlinuz-b739c9982801e5f76097311b67dfd76891b10988-20140530033701-10-ivb43 branch=linux-devel/devel-roam-i386-201405300201 BOOT_IMAGE=/kernel/i386-randconfig-r3-0530/b739c9982801e5f76097311b67dfd76891b10988/vmlinuz-3.15.0-rc5-00087-gb739c99 drbd.minor_count=8
> [    0.000000] sysrq: sysrq always enabled.
> [    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
> [    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.000000] Initializing CPU#0
> [    0.000000] Initializing HighMem for node 0 (00000000:00000000)
> [    0.000000] Memory: 267904K/327280K available (12960K kernel code, 3282K rwdata, 4536K rodata, 636K init, 9320K bss, 59376K reserved, 0K highmem)
> [    0.000000] virtual kernel memory layout:
> [    0.000000]     fixmap  : 0xfffcf000 - 0xfffff000   ( 192 kB)
> [    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
> [    0.000000]     vmalloc : 0x947fe000 - 0xff7fe000   (1712 MB)
> [    0.000000]     lowmem  : 0x80000000 - 0x93ffe000   ( 319 MB)
> [    0.000000]       .init : 0x82457000 - 0x824f6000   ( 636 kB)
> [    0.000000]       .data : 0x81ca8672 - 0x82455a40   (7860 kB)
> [    0.000000]       .text : 0x81000000 - 0x81ca8672   (12961 kB)
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000000] NR_IRQS:16 nr_irqs:16 16
> [    0.000000] CPU 0 irqstacks, hard=91c02000 soft=91c04000
> [    0.000000] console [ttyS0] enabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
> [    0.000000] ... CHAINHASH_SIZE:          16384
> [    0.000000]  memory used by lock dependency info: 3823 kB
> [    0.000000]  per task-struct memory footprint: 1920 bytes
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Detected 2693.356 MHz processor
> [    0.020000] Calibrating delay loop (skipped) preset value.. 5386.71 BogoMIPS (lpj=26933560)
> [    0.020000] pid_max: default: 4096 minimum: 301
> [    0.020000] ACPI: Core revision 20140214
> [    0.021393] ACPI: All ACPI Tables successfully acquired
> [    0.021846] ACPI: setting ELCR to 0200 (from 0c00)
> [    0.022271] Security Framework initialized
> [    0.022609] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
> [    0.023125] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
> [    0.024102] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.024102] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
> [    0.024102] tlb_flushall_shift: -1
> [    0.025217] CPU: GenuineIntel Common KVM processor (fam: 0f, model: 06, stepping: 01)
> [    0.028609] Performance Events: no PMU driver, software events only.
> [    0.029701] ftrace: Allocated trace_printk buffers
> [    0.033780] devtmpfs: initialized
> [    0.034347] gcov: version magic: 0x3430382a
> [    0.036658] evm: security.capability
> [    0.039560] prandom: seed boundary self test passed
> [    0.040594] prandom: 100 self tests passed
> [    0.040917] atomic64 test passed for i586+ platform with CX8 and with SSE
> [    0.041437] pinctrl core: initialized pinctrl subsystem
> [    0.042630] regulator-dummy: no parameters
> [    0.043303] NET: Registered protocol family 16
> [    0.044756] cpuidle: using governor ladder
> [    0.045086] cpuidle: using governor menu
> [    0.046089] ACPI: bus type PCI registered
> [    0.046462] PCI: Using configuration type 1 for base access
> [    0.068027] ACPI: Added _OSI(Module Device)
> [    0.068368] ACPI: Added _OSI(Processor Device)
> [    0.068713] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.069088] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.083702] ACPI: Interpreter enabled
> [    0.084027] ACPI: (supports S0 S5)
> [    0.084298] ACPI: Using PIC for interrupt routing
> [    0.084774] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    0.103567] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    0.104109] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments]
> [    0.104678] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
> [    0.106336] PCI host bridge to bus 0000:00
> [    0.106667] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    0.107119] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    0.107629] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    0.108131] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    0.108652] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
> [    0.109285] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
> [    0.110568] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
> [    0.111908] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
> [    0.114663] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
> [    0.116010] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
> [    0.116560] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
> [    0.117077] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
> [    0.117645] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
> [    0.118841] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
> [    0.119605] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
> [    0.120020] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
> [    0.121226] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
> [    0.123766] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
> [    0.125475] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
> [    0.131752] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
> [    0.133156] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
> [    0.134488] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
> [    0.135828] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
> [    0.140877] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
> [    0.142263] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
> [    0.143194] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
> [    0.146946] pci_bus 0000:00: on NUMA node 0
> [    0.149535] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
> [    0.150850] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
> [    0.152197] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
> [    0.153470] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
> [    0.154271] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
> [    0.156622] ACPI: Enabled 16 GPEs in block 00 to 0F
> [    0.160318] media: Linux media interface: v0.10
> [    0.160727] Linux video capture interface: v2.00
> [    0.161243] pps_core: LinuxPPS API ver. 1 registered
> [    0.161646] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    0.162731] PCI: Using ACPI for IRQ routing
> [    0.163097] PCI: pci_cache_line_size set to 64 bytes
> [    0.163569] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
> [    0.164042] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
> [    0.166354] Switched to clocksource kvm-clock
> [    0.225624] FS-Cache: Loaded
> [    0.225974] pnp: PnP ACPI init
> [    0.226256] ACPI: bus type PNP registered
> [    0.226914] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.227610] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
> [    0.228279] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
> [    0.228972] pnp 00:03: [dma 2]
> [    0.229347] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
> [    0.230224] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
> [    0.231039] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
> [    0.231831] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
> [    0.233093] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
> [    0.234054] pnp: PnP ACPI: found 8 devices
> [    0.234366] ACPI: bus type PNP unregistered
> [    0.271734] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    0.272196] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    0.272657] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.273162] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
> [    0.273678] NET: Registered protocol family 1
> [    0.274040] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> [    0.274552] pci 0000:00:01.0: PIIX3: Enabling Passive Release
> [    0.275016] pci 0000:00:01.0: Activating ISA DMA hang workarounds
> [    0.275559] pci 0000:00:02.0: Boot video device
> [    0.275953] PCI: CLS 0 bytes, default 64
> [    0.276674] Unpacking initramfs...
> [    1.410818] debug: unmapping init [mem 0x927ab000-0x93feffff]
> [    1.412621] microcode: no support for this CPU vendor
> [    1.413676] Scanning for low memory corruption every 60 seconds
> [    1.415512] PCLMULQDQ-NI instructions are not detected.
> [    1.416104] spin_lock-torture:--- Start of test: nwriters_stress=2 stat_interval=60 verbose=1 shuffle_interval=3 stutter=5 shutdown_secs=0 onoff_interval=0 onoff_holdoff=0
> [    1.417321] spin_lock-torture: Creating torture_shuffle task
> [    1.418026] spin_lock-torture: Creating torture_stutter task
> [    1.418508] spin_lock-torture: torture_shuffle task started
> [    1.418967] spin_lock-torture: Creating lock_torture_writer task
> [    1.419493] spin_lock-torture: torture_stutter task started
> [    1.419941] spin_lock-torture: Creating lock_torture_writer task
> [    1.420515] spin_lock-torture: lock_torture_writer task started
> [    1.420993] spin_lock-torture: Creating lock_torture_stats task
> [    1.421519] spin_lock-torture: lock_torture_writer task started
> [    1.422657] futex hash table entries: 16 (order: -3, 832 bytes)
> [    1.923788] spin_lock-torture: lock_torture_stats task started
> [    1.949322] HugeTLB registered 4 MB page size, pre-allocated 0 pages
> [    1.949915] VFS: Disk quotas dquot_6.5.2
> [    1.950334] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> [    1.952660] ROMFS MTD (C) 2007 Red Hat, Inc.
> [    1.953114] msgmni has been set to 523
> [    1.956782] Key type asymmetric registered
> [    1.957117] Asymmetric key parser 'x509' registered
> [    1.957484] test_string_helpers: Running tests...
> [    1.974997] crc32: CRC_LE_BITS = 1, CRC_BE BITS = 1
> [    1.975415] crc32: self tests passed, processed 225944 bytes in 8474709 nsec
> [    1.984252] crc32c: CRC_LE_BITS = 1
> [    1.984569] crc32c: self tests passed, processed 225944 bytes in 4164202 nsec
> [    2.410240] tsc: Refined TSC clocksource calibration: 2693.540 MHz
> [    2.550326] crc32_combine: 8373 self tests passed
> [    3.116509] crc32c_combine: 8373 self tests passed
> [    3.117347] xz_dec_test: module loaded
> [    3.117653] xz_dec_test: Create a device node with 'mknod xz_dec_test c 251 0' and write .xz files to it.
> [    3.118399] rbtree testing -> 9818 cycles
> [    3.529150] augmented rbtree testing -> 14704 cycles
> [    4.136536] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    4.137152] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> [    4.137674] cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
> [    4.138239] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver version: 0.1
> [    4.138848] cpcihp_generic: not configured, disabling.
> [    4.139300] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
> [    4.140719] rivafb_setup START
> [    4.141174] VIA Graphics Integration Chipset framebuffer 2.4 initializing
> [    4.143069] ipmi message handler version 39.2
> [    4.143459] IPMI System Interface driver.
> [    4.143902] ipmi_si: Adding default-specified kcs state machine
> [    4.144379] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
> [    4.145163] ipmi_si: Interface detection failed
> [    4.145619] ipmi_si: Adding default-specified smic state machine
> [    4.146112] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
> [    4.147074] ipmi_si: Interface detection failed
> [    4.147442] ipmi_si: Adding default-specified bt state machine
> [    4.147914] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
> [    4.148800] ipmi_si: Interface detection failed
> [    4.149299] ipmi_si: Unable to find any System Interface(s)
> [    4.149784] IPMI Watchdog: driver initialized
> [    4.152011] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [    4.152607] ACPI: Power Button [PWRF]
> [    4.154083] GHES: HEST is not enabled!
> [    4.291448] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [    4.317191] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> [    4.319720] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
> [    4.320340] ac.o: No PCI boards found.
> [    4.320635] ac.o: For an ISA board you must supply memory and irq parameters.
> [    4.321419] Non-volatile memory driver v1.3
> [    4.321763] toshiba: not a supported Toshiba laptop
> [    4.322330] Linux agpgart interface v0.103
> [    4.323596] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
> [    4.324288] Hangcheck: Using getrawmonotonic().
> [    4.324939] [drm] Initialized drm 1.1.0 20060810
> [    4.325517] [drm] radeon kernel modesetting enabled.
> [    4.328364] [TTM] Zone  kernel: Available graphics memory: 133952 kiB
> [    4.328875] [TTM] Initializing pool allocator
> [    4.329713] 
> [    4.329843] =============================================
> [    4.330272] [ INFO: possible recursive locking detected ]
> [    4.330294] 3.15.0-rc5-00087-gb739c99 #636 Not tainted
> [    4.330294] ---------------------------------------------
> [    4.330294] swapper/1 is trying to acquire lock:
> [    4.330294]  (&dev->mode_config.mutex){+.+.+.}, at: [<8158fa28>] drm_modeset_lock_all+0x28/0xa0
> [    4.330294] 
> [    4.330294] but task is already holding lock:
> [    4.330294]  (&dev->mode_config.mutex){+.+.+.}, at: [<8157720e>] drm_fb_helper_initial_config+0x6e/0x890
> [    4.330294] 
> [    4.330294] other info that might help us debug this:
> [    4.330294]  Possible unsafe locking scenario:
> [    4.330294] 
> [    4.330294]        CPU0
> [    4.330294]        ----
> [    4.330294]   lock(&dev->mode_config.mutex);
> [    4.330294]   lock(&dev->mode_config.mutex);
> [    4.330294] 
> [    4.330294]  *** DEADLOCK ***
> [    4.330294] 
> [    4.330294]  May be due to missing lock nesting notation
> [    4.330294] 
> [    4.330294] 4 locks held by swapper/1:
> [    4.330294]  #0:  (&dev->mutex){......}, at: [<81770e9c>] __driver_attach+0x7c/0x140
> [    4.330294]  #1:  (&dev->mutex){......}, at: [<81770eb6>] __driver_attach+0x96/0x140
> [    4.330294]  #2:  (drm_global_mutex){+.+.+.}, at: [<81587f89>] drm_dev_register+0x29/0x210
> [    4.330294]  #3:  (&dev->mode_config.mutex){+.+.+.}, at: [<8157720e>] drm_fb_helper_initial_config+0x6e/0x890
> [    4.330294] 
> [    4.330294] stack backtrace:
> [    4.330294] CPU: 0 PID: 1 Comm: swapper Not tainted 3.15.0-rc5-00087-gb739c99 #636
> [    4.330294]  82772bd0 91c25b70 81c8091f 91c25bf0 810a75e6 82031095 91c1922c 00000001
> [    4.330294]  e891fd4b 00000004 91c19478 82772bd0 00000000 91c19000 91c19478 8274ddb8
> [    4.330294]  82543d00 91c25bcc 0000073c 00000000 00000000 00000000 00000001 91c19478
> [    4.330294] Call Trace:
> [    4.330294]  [<81c8091f>] dump_stack+0x40/0x5e
> [    4.330294]  [<810a75e6>] validate_chain.isra.25+0xe66/0x1f70
> [    4.330294]  [<8109a413>] ? sched_clock_cpu+0x153/0x1c0
> [    4.330294]  [<810ae42e>] __lock_acquire+0x149e/0x1780
> [    4.330294]  [<810ae42e>] ? __lock_acquire+0x149e/0x1780
> [    4.330294]  [<810ae865>] lock_acquire+0x155/0x1d0
> [    4.330294]  [<8158fa28>] ? drm_modeset_lock_all+0x28/0xa0
> [    4.330294]  [<81c9f2a9>] mutex_lock_nested+0x99/0x6a0
> [    4.330294]  [<8158fa28>] ? drm_modeset_lock_all+0x28/0xa0
> [    4.330294]  [<8158fa28>] ? drm_modeset_lock_all+0x28/0xa0
> [    4.330294]  [<8157720e>] ? drm_fb_helper_initial_config+0x6e/0x890
> [    4.330294]  [<8157720e>] ? drm_fb_helper_initial_config+0x6e/0x890
> [    4.330294]  [<8158fa28>] drm_modeset_lock_all+0x28/0xa0
> [    4.330294]  [<81577223>] drm_fb_helper_initial_config+0x83/0x890
> [    4.330294]  [<810a97b2>] ? trace_hardirqs_on_caller+0x2d2/0x420
> [    4.330294]  [<810a9927>] ? trace_hardirqs_on+0x27/0x40
> [    4.330294]  [<8158fa78>] ? drm_modeset_lock_all+0x78/0xa0
> [    4.330294]  [<8156f4fe>] ? drm_helper_encoder_in_use+0xe/0x130
> [    4.330294]  [<8158fad9>] ? drm_modeset_unlock_all+0x39/0x80
> [    4.330294]  [<8174a06c>] cirrus_fbdev_init+0x10c/0x130
> [    4.330294]  [<8174917b>] cirrus_modeset_init+0x27b/0x340
> [    4.330294]  [<81747483>] cirrus_driver_load+0x113/0x1d0
> [    4.330294]  [<81588047>] drm_dev_register+0xe7/0x210
> [    4.330294]  [<8158ba80>] drm_get_pci_dev+0x200/0x340
> [    4.330294]  [<8118a93d>] ? slob_free+0x5dd/0x610
> [    4.330294]  [<81749416>] cirrus_pci_probe+0x126/0x160
> [    4.330294]  [<81338b7a>] pci_device_probe+0xda/0x1f0
> [    4.330294]  [<8120eef5>] ? sysfs_create_link+0x25/0x40
> [    4.330294]  [<81770b9f>] really_probe+0x16f/0x3f0
> [    4.330294]  [<81770ef9>] __driver_attach+0xd9/0x140
> [    4.330294]  [<81770e20>] ? really_probe+0x3f0/0x3f0
> [    4.330294]  [<8176d932>] bus_for_each_dev+0xb2/0x140
> [    4.330294]  [<817705cc>] driver_attach+0x2c/0x40
> [    4.330294]  [<81770e20>] ? really_probe+0x3f0/0x3f0
> [    4.330294]  [<8176ead9>] bus_add_driver+0x129/0x3e0
> [    4.330294]  [<81771855>] driver_register+0x165/0x1f0
> [    4.330294]  [<8249f39c>] ? mgag200_init+0x4f/0x4f
> [    4.330294]  [<81338cf6>] __pci_register_driver+0x66/0x80
> [    4.330294]  [<8158bc4b>] drm_pci_init+0x8b/0x1b0
> [    4.330294]  [<8249f39c>] ? mgag200_init+0x4f/0x4f
> [    4.330294]  [<8249f3d3>] cirrus_init+0x37/0x4f
> [    4.330294]  [<82458598>] do_one_initcall+0xf4/0x21e
> [    4.330294]  [<81080016>] ? parameq+0x26/0x110
> [    4.330294]  [<812dd939>] ? strlen+0x9/0x40
> [    4.330294]  [<82457735>] ? repair_env_string+0x32/0xd3
> [    4.330294]  [<81080522>] ? parse_args+0x422/0x610
> [    4.330294]  [<824588ca>] kernel_init_freeable+0x208/0x38b
> [    4.330294]  [<82457703>] ? do_early_param+0x12b/0x12b
> [    4.330294]  [<81c77fee>] kernel_init+0x1e/0x220
> [    4.330294]  [<81094e0f>] ? schedule_tail+0x1f/0xa0
> [    4.330294]  [<81ca7700>] ret_from_kernel_thread+0x20/0x30
> [    4.330294]  [<81c77fd0>] ? rest_init+0x180/0x180
> [   61.921707] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0 
> [   82.580118] random: nonblocking pool is initialized
> [  121.920851] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0 
> [  181.921621] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0 
> [  241.925890] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0 
> [  301.920225] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0 
> [  361.920189] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0 
> [  421.920171] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0 
> [  481.920169] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0 
> [  541.924232] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0 
> [  601.921669] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0 
> [  661.924925] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0 
> [  721.920136] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0 
> [  781.920169] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0 
> [  841.920185] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0 
> [  901.920149] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0 
>
> BUG: kernel boot hang
> Elapsed time: 905
> qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-r3-0530/b739c9982801e5f76097311b67dfd76891b10988/vmlinuz-3.15.0-rc5-00087-gb739c99 -append 'hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/i386-randconfig-r3-0530/linux-devel:devel-roam-i386-201405300201:b739c9982801e5f76097311b67dfd76891b10988:bisect-linux/.vmlinuz-b739c9982801e5f76097311b67dfd76891b10988-20140530033701-10-ivb43 branch=linux-devel/devel-roam-i386-201405300201 BOOT_IMAGE=/kernel/i386-randconfig-r3-0530/b739c9982801e5f76097311b67dfd76891b10988/vmlinuz-3.15.0-rc5-00087-gb739c99 drbd.minor_count=8'  -initrd /kernel-tests/initrd/quantal-core-i386.cgz -m 320 -smp 2 -net nic,vlan=1,model=e1000 -net user,vlan=1 -boot order=nc -no-reboot -watchdog i6300esb -rtc base=localtime -pidfile /dev/shm/kboot/pid-quantal-ivb43-67 -serial file:/dev/shm/kboot/serial-quantal-ivb43-67 -daemonize -display none -monitor null 
>
> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/i386 3.15.0-rc5 Kernel Configuration
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
> CONFIG_X86_32_LAZY_GS=y
> CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
> CONFIG_ARCH_SUPPORTS_UPROBES=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_CONSTRUCTORS=y
> CONFIG_IRQ_WORK=y
> CONFIG_BUILDTIME_EXTABLE_SORT=y
>
> #
> # General setup
> #
> CONFIG_BROKEN_ON_SMP=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_CROSS_COMPILE=""
> CONFIG_COMPILE_TEST=y
> CONFIG_LOCALVERSION=""
> CONFIG_LOCALVERSION_AUTO=y
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_HAVE_KERNEL_BZIP2=y
> CONFIG_HAVE_KERNEL_LZMA=y
> CONFIG_HAVE_KERNEL_XZ=y
> CONFIG_HAVE_KERNEL_LZO=y
> CONFIG_HAVE_KERNEL_LZ4=y
> CONFIG_KERNEL_GZIP=y
> # CONFIG_KERNEL_BZIP2 is not set
> # CONFIG_KERNEL_LZMA is not set
> # CONFIG_KERNEL_XZ is not set
> # CONFIG_KERNEL_LZO is not set
> # CONFIG_KERNEL_LZ4 is not set
> CONFIG_DEFAULT_HOSTNAME="(none)"
> CONFIG_SYSVIPC=y
> # CONFIG_POSIX_MQUEUE is not set
> CONFIG_FHANDLE=y
> CONFIG_USELIB=y
> # CONFIG_AUDIT is not set
> CONFIG_HAVE_ARCH_AUDITSYSCALL=y
>
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_IRQ_SHOW=y
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
> CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
> CONFIG_GENERIC_CMOS_UPDATE=y
>
> #
> # Timers subsystem
> #
> CONFIG_TICK_ONESHOT=y
> CONFIG_HZ_PERIODIC=y
> # CONFIG_NO_HZ_IDLE is not set
> # CONFIG_NO_HZ is not set
> CONFIG_HIGH_RES_TIMERS=y
>
> #
> # CPU/Task time and stats accounting
> #
> CONFIG_TICK_CPU_ACCOUNTING=y
> # CONFIG_IRQ_TIME_ACCOUNTING is not set
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
> CONFIG_LOG_BUF_SHIFT=17
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
> CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
> # CONFIG_CGROUPS is not set
> # CONFIG_CHECKPOINT_RESTORE is not set
> CONFIG_NAMESPACES=y
> CONFIG_UTS_NS=y
> CONFIG_IPC_NS=y
> CONFIG_USER_NS=y
> # CONFIG_PID_NS is not set
> CONFIG_NET_NS=y
> # CONFIG_SCHED_AUTOGROUP is not set
> # CONFIG_SYSFS_DEPRECATED is not set
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
> # CONFIG_SYSFS_SYSCALL is not set
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_ALL=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_PCSPKR_PLATFORM=y
> # CONFIG_BASE_FULL is not set
> CONFIG_FUTEX=y
> # CONFIG_EPOLL is not set
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
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
> # CONFIG_SLAB is not set
> # CONFIG_SLUB is not set
> CONFIG_SLOB=y
> # CONFIG_SYSTEM_TRUSTED_KEYRING is not set
> CONFIG_PROFILING=y
> CONFIG_TRACEPOINTS=y
> CONFIG_OPROFILE=y
> CONFIG_OPROFILE_EVENT_MULTIPLEX=y
> CONFIG_HAVE_OPROFILE=y
> CONFIG_OPROFILE_NMI_TIMER=y
> # CONFIG_JUMP_LABEL is not set
> CONFIG_UPROBES=y
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
> CONFIG_HAVE_CLK=y
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
> CONFIG_HAVE_ARCH_SOFT_DIRTY=y
> CONFIG_MODULES_USE_ELF_REL=y
> CONFIG_CLONE_BACKWARDS=y
> CONFIG_OLD_SIGSUSPEND3=y
> CONFIG_OLD_SIGACTION=y
>
> #
> # GCOV-based kernel profiling
> #
> CONFIG_GCOV_KERNEL=y
> CONFIG_GCOV_PROFILE_ALL=y
> CONFIG_GCOV_FORMAT_AUTODETECT=y
> # CONFIG_GCOV_FORMAT_3_4 is not set
> # CONFIG_GCOV_FORMAT_4_7 is not set
> CONFIG_HAVE_GENERIC_DMA_COHERENT=y
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=1
> # CONFIG_MODULES is not set
> # CONFIG_BLOCK is not set
> CONFIG_ASN1=y
> CONFIG_UNINLINE_SPIN_UNLOCK=y
> # CONFIG_FREEZER is not set
>
> #
> # Processor type and features
> #
> CONFIG_ZONE_DMA=y
> # CONFIG_SMP is not set
> CONFIG_GOLDFISH=y
> CONFIG_X86_EXTENDED_PLATFORM=y
> CONFIG_X86_GOLDFISH=y
> # CONFIG_X86_INTEL_CE is not set
> CONFIG_X86_INTEL_LPSS=y
> # CONFIG_X86_RDC321X is not set
> # CONFIG_X86_32_IRIS is not set
> # CONFIG_SCHED_OMIT_FRAME_POINTER is not set
> CONFIG_HYPERVISOR_GUEST=y
> CONFIG_PARAVIRT=y
> # CONFIG_PARAVIRT_DEBUG is not set
> CONFIG_KVM_GUEST=y
> # CONFIG_KVM_DEBUG_FS is not set
> # CONFIG_LGUEST_GUEST is not set
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
> CONFIG_MCORE2=y
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
> # CONFIG_CPU_SUP_INTEL is not set
> CONFIG_CPU_SUP_CYRIX_32=y
> CONFIG_CPU_SUP_AMD=y
> # CONFIG_CPU_SUP_CENTAUR is not set
> CONFIG_CPU_SUP_TRANSMETA_32=y
> # CONFIG_CPU_SUP_UMC_32 is not set
> CONFIG_HPET_TIMER=y
> # CONFIG_DMI is not set
> CONFIG_NR_CPUS=1
> CONFIG_PREEMPT_NONE=y
> # CONFIG_PREEMPT_VOLUNTARY is not set
> # CONFIG_PREEMPT is not set
> CONFIG_PREEMPT_COUNT=y
> # CONFIG_X86_UP_APIC is not set
> # CONFIG_X86_MCE is not set
> CONFIG_VM86=y
> CONFIG_TOSHIBA=y
> # CONFIG_I8K is not set
> CONFIG_X86_REBOOTFIXUPS=y
> CONFIG_MICROCODE=y
> CONFIG_MICROCODE_INTEL=y
> CONFIG_MICROCODE_AMD=y
> CONFIG_MICROCODE_OLD_INTERFACE=y
> CONFIG_MICROCODE_INTEL_EARLY=y
> CONFIG_MICROCODE_AMD_EARLY=y
> CONFIG_MICROCODE_EARLY=y
> CONFIG_X86_MSR=y
> # CONFIG_X86_CPUID is not set
> # CONFIG_NOHIGHMEM is not set
> CONFIG_HIGHMEM4G=y
> # CONFIG_HIGHMEM64G is not set
> # CONFIG_VMSPLIT_3G is not set
> # CONFIG_VMSPLIT_3G_OPT is not set
> CONFIG_VMSPLIT_2G=y
> # CONFIG_VMSPLIT_2G_OPT is not set
> # CONFIG_VMSPLIT_1G is not set
> CONFIG_PAGE_OFFSET=0x80000000
> CONFIG_HIGHMEM=y
> CONFIG_ARCH_FLATMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_ILLEGAL_POINTER_VALUE=0
> CONFIG_SELECT_MEMORY_MODEL=y
> CONFIG_FLATMEM_MANUAL=y
> # CONFIG_SPARSEMEM_MANUAL is not set
> CONFIG_FLATMEM=y
> CONFIG_FLAT_NODE_MEM_MAP=y
> CONFIG_SPARSEMEM_STATIC=y
> CONFIG_HAVE_MEMBLOCK=y
> CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
> CONFIG_ARCH_DISCARD_MEMBLOCK=y
> CONFIG_MEMORY_ISOLATION=y
> # CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_SPLIT_PTLOCK_CPUS=4
> # CONFIG_BALLOON_COMPACTION is not set
> CONFIG_COMPACTION=y
> CONFIG_MIGRATION=y
> # CONFIG_PHYS_ADDR_T_64BIT is not set
> CONFIG_ZONE_DMA_FLAG=1
> CONFIG_VIRT_TO_BUS=y
> CONFIG_KSM=y
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> CONFIG_TRANSPARENT_HUGEPAGE=y
> # CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
> CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
> CONFIG_CROSS_MEMORY_ATTACH=y
> CONFIG_NEED_PER_CPU_KM=y
> # CONFIG_CLEANCACHE is not set
> CONFIG_CMA=y
> # CONFIG_CMA_DEBUG is not set
> # CONFIG_ZBUD is not set
> CONFIG_ZSMALLOC=y
> CONFIG_PGTABLE_MAPPING=y
> CONFIG_GENERIC_EARLY_IOREMAP=y
> CONFIG_HIGHPTE=y
> CONFIG_X86_CHECK_BIOS_CORRUPTION=y
> CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
> CONFIG_X86_RESERVE_LOW=64
> # CONFIG_MATH_EMULATION is not set
> # CONFIG_MTRR is not set
> # CONFIG_ARCH_RANDOM is not set
> CONFIG_X86_SMAP=y
> # CONFIG_EFI is not set
> # CONFIG_SECCOMP is not set
> CONFIG_HZ_100=y
> # CONFIG_HZ_250 is not set
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=100
> CONFIG_SCHED_HRTICK=y
> # CONFIG_KEXEC is not set
> CONFIG_CRASH_DUMP=y
> CONFIG_PHYSICAL_START=0x1000000
> CONFIG_RELOCATABLE=y
> # CONFIG_RANDOMIZE_BASE is not set
> CONFIG_X86_NEED_RELOCS=y
> CONFIG_PHYSICAL_ALIGN=0x200000
> CONFIG_COMPAT_VDSO=y
> # CONFIG_CMDLINE_BOOL is not set
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
>
> #
> # Power management and ACPI options
> #
> # CONFIG_SUSPEND is not set
> # CONFIG_PM_RUNTIME is not set
> CONFIG_ACPI=y
> # CONFIG_ACPI_EC_DEBUGFS is not set
> CONFIG_ACPI_AC=y
> # CONFIG_ACPI_BATTERY is not set
> CONFIG_ACPI_BUTTON=y
> CONFIG_ACPI_VIDEO=y
> # CONFIG_ACPI_FAN is not set
> CONFIG_ACPI_DOCK=y
> CONFIG_ACPI_PROCESSOR=y
> CONFIG_ACPI_IPMI=y
> CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
> CONFIG_ACPI_THERMAL=y
> CONFIG_ACPI_CUSTOM_DSDT_FILE=""
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> # CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
> CONFIG_ACPI_DEBUG=y
> # CONFIG_ACPI_PCI_SLOT is not set
> CONFIG_X86_PM_TIMER=y
> # CONFIG_ACPI_CONTAINER is not set
> CONFIG_ACPI_SBS=y
> CONFIG_ACPI_HED=y
> # CONFIG_ACPI_CUSTOM_METHOD is not set
> # CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
> CONFIG_ACPI_APEI=y
> CONFIG_ACPI_APEI_GHES=y
> # CONFIG_ACPI_APEI_PCIEAER is not set
> # CONFIG_ACPI_APEI_EINJ is not set
> # CONFIG_ACPI_APEI_ERST_DEBUG is not set
> # CONFIG_SFI is not set
>
> #
> # CPU Frequency scaling
> #
> # CONFIG_CPU_FREQ is not set
>
> #
> # CPU Idle
> #
> CONFIG_CPU_IDLE=y
> CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
> CONFIG_CPU_IDLE_GOV_LADDER=y
> CONFIG_CPU_IDLE_GOV_MENU=y
> # CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
>
> #
> # Bus options (PCI etc.)
> #
> CONFIG_PCI=y
> # CONFIG_PCI_GOBIOS is not set
> # CONFIG_PCI_GOMMCONFIG is not set
> CONFIG_PCI_GODIRECT=y
> # CONFIG_PCI_GOANY is not set
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_DOMAINS=y
> CONFIG_PCI_CNB20LE_QUIRK=y
> CONFIG_PCIEPORTBUS=y
> CONFIG_HOTPLUG_PCI_PCIE=y
> CONFIG_PCIEAER=y
> # CONFIG_PCIE_ECRC is not set
> CONFIG_PCIEAER_INJECT=y
> CONFIG_PCIEASPM=y
> CONFIG_PCIEASPM_DEBUG=y
> # CONFIG_PCIEASPM_DEFAULT is not set
> # CONFIG_PCIEASPM_POWERSAVE is not set
> CONFIG_PCIEASPM_PERFORMANCE=y
> # CONFIG_PCI_MSI is not set
> # CONFIG_PCI_DEBUG is not set
> CONFIG_PCI_REALLOC_ENABLE_AUTO=y
> CONFIG_PCI_STUB=y
> CONFIG_PCI_ATS=y
> CONFIG_PCI_IOV=y
> CONFIG_PCI_PRI=y
> # CONFIG_PCI_PASID is not set
> CONFIG_PCI_LABEL=y
>
> #
> # PCI host controller drivers
> #
> CONFIG_ISA_DMA_API=y
> # CONFIG_ISA is not set
> # CONFIG_SCx200 is not set
> # CONFIG_OLPC is not set
> CONFIG_ALIX=y
> # CONFIG_NET5501 is not set
> CONFIG_AMD_NB=y
> CONFIG_PCCARD=y
> CONFIG_PCMCIA=y
> # CONFIG_PCMCIA_LOAD_CIS is not set
> # CONFIG_CARDBUS is not set
>
> #
> # PC-card bridges
> #
> # CONFIG_YENTA is not set
> CONFIG_PD6729=y
> CONFIG_I82092=y
> CONFIG_PCCARD_NONSTATIC=y
> CONFIG_HOTPLUG_PCI=y
> # CONFIG_HOTPLUG_PCI_ACPI is not set
> CONFIG_HOTPLUG_PCI_CPCI=y
> CONFIG_HOTPLUG_PCI_CPCI_ZT5550=y
> CONFIG_HOTPLUG_PCI_CPCI_GENERIC=y
> CONFIG_HOTPLUG_PCI_SHPC=y
> CONFIG_RAPIDIO=y
> CONFIG_RAPIDIO_TSI721=y
> CONFIG_RAPIDIO_DISC_TIMEOUT=30
> CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
> # CONFIG_RAPIDIO_DMA_ENGINE is not set
> CONFIG_RAPIDIO_DEBUG=y
> CONFIG_RAPIDIO_ENUM_BASIC=y
>
> #
> # RapidIO Switch drivers
> #
> # CONFIG_RAPIDIO_TSI57X is not set
> # CONFIG_RAPIDIO_CPS_XX is not set
> # CONFIG_RAPIDIO_TSI568 is not set
> CONFIG_RAPIDIO_CPS_GEN2=y
> CONFIG_X86_SYSFB=y
>
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
> CONFIG_BINFMT_SCRIPT=y
> CONFIG_HAVE_AOUT=y
> # CONFIG_BINFMT_AOUT is not set
> CONFIG_BINFMT_MISC=y
> # CONFIG_COREDUMP is not set
> CONFIG_HAVE_ATOMIC_IOMAP=y
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
> CONFIG_NET_RX_BUSY_POLL=y
> CONFIG_BQL=y
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
> CONFIG_UEVENT_HELPER_PATH=""
> CONFIG_DEVTMPFS=y
> # CONFIG_DEVTMPFS_MOUNT is not set
> # CONFIG_STANDALONE is not set
> # CONFIG_PREVENT_FIRMWARE_BUILD is not set
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
> CONFIG_REGMAP_SPI=y
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
> # CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
> CONFIG_MTD_CMDLINE_PARTS=y
> CONFIG_MTD_AR7_PARTS=y
>
> #
> # User Modules And Translation Layers
> #
> CONFIG_MTD_OOPS=y
>
> #
> # RAM/ROM/Flash chip drivers
> #
> CONFIG_MTD_CFI=y
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
> CONFIG_MTD_CFI_STAA=y
> CONFIG_MTD_CFI_UTIL=y
> CONFIG_MTD_RAM=y
> # CONFIG_MTD_ROM is not set
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
> # CONFIG_MTD_SC520CDP is not set
> # CONFIG_MTD_NETSC520 is not set
> # CONFIG_MTD_TS5500 is not set
> CONFIG_MTD_AMD76XROM=y
> CONFIG_MTD_ICHXROM=y
> CONFIG_MTD_ESB2ROM=y
> # CONFIG_MTD_CK804XROM is not set
> CONFIG_MTD_SCB2_FLASH=y
> # CONFIG_MTD_NETtel is not set
> CONFIG_MTD_L440GX=y
> CONFIG_MTD_INTEL_VR_NOR=y
> CONFIG_MTD_PLATRAM=y
>
> #
> # Self-contained MTD device drivers
> #
> CONFIG_MTD_PMC551=y
> CONFIG_MTD_PMC551_BUGFIX=y
> # CONFIG_MTD_PMC551_DEBUG is not set
> CONFIG_MTD_DATAFLASH=y
> # CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
> # CONFIG_MTD_DATAFLASH_OTP is not set
> CONFIG_MTD_M25P80=y
> # CONFIG_MTD_SST25L is not set
> CONFIG_MTD_SLRAM=y
> # CONFIG_MTD_PHRAM is not set
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
> CONFIG_MTD_ONENAND_VERIFY_WRITE=y
> CONFIG_MTD_ONENAND_GENERIC=y
> # CONFIG_MTD_ONENAND_OTP is not set
> CONFIG_MTD_ONENAND_2X_PROGRAM=y
>
> #
> # LPDDR flash memory drivers
> #
> CONFIG_MTD_LPDDR=y
> CONFIG_MTD_QINFO_PROBE=y
> CONFIG_MTD_UBI=y
> CONFIG_MTD_UBI_WL_THRESHOLD=4096
> CONFIG_MTD_UBI_BEB_LIMIT=20
> # CONFIG_MTD_UBI_FASTMAP is not set
> CONFIG_MTD_UBI_GLUEBI=y
> # CONFIG_PARPORT is not set
> CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
> CONFIG_PNP=y
> CONFIG_PNP_DEBUG_MESSAGES=y
>
> #
> # Protocols
> #
> CONFIG_PNPACPI=y
>
> #
> # Misc devices
> #
> CONFIG_SENSORS_LIS3LV02D=y
> CONFIG_AD525X_DPOT=y
> # CONFIG_AD525X_DPOT_I2C is not set
> # CONFIG_AD525X_DPOT_SPI is not set
> CONFIG_ATMEL_PWM=y
> # CONFIG_DUMMY_IRQ is not set
> # CONFIG_IBM_ASM is not set
> CONFIG_PHANTOM=y
> # CONFIG_INTEL_MID_PTI is not set
> CONFIG_SGI_IOC4=y
> CONFIG_TIFM_CORE=y
> CONFIG_TIFM_7XX1=y
> CONFIG_ICS932S401=y
> CONFIG_ATMEL_SSC=y
> # CONFIG_ENCLOSURE_SERVICES is not set
> # CONFIG_CS5535_MFGPT is not set
> CONFIG_HP_ILO=y
> CONFIG_APDS9802ALS=y
> CONFIG_ISL29003=y
> # CONFIG_ISL29020 is not set
> CONFIG_SENSORS_TSL2550=y
> CONFIG_SENSORS_BH1780=y
> # CONFIG_SENSORS_BH1770 is not set
> CONFIG_SENSORS_APDS990X=y
> # CONFIG_HMC6352 is not set
> CONFIG_DS1682=y
> CONFIG_TI_DAC7512=y
> CONFIG_VMWARE_BALLOON=y
> # CONFIG_BMP085_I2C is not set
> # CONFIG_BMP085_SPI is not set
> # CONFIG_PCH_PHUB is not set
> CONFIG_USB_SWITCH_FSA9480=y
> CONFIG_LATTICE_ECP3_CONFIG=y
> # CONFIG_SRAM is not set
> CONFIG_C2PORT=y
> CONFIG_C2PORT_DURAMAR_2150=y
>
> #
> # EEPROM support
> #
> # CONFIG_EEPROM_AT24 is not set
> CONFIG_EEPROM_AT25=y
> CONFIG_EEPROM_LEGACY=y
> # CONFIG_EEPROM_MAX6875 is not set
> CONFIG_EEPROM_93CX6=y
> CONFIG_EEPROM_93XX46=y
> CONFIG_CB710_CORE=y
> # CONFIG_CB710_DEBUG is not set
> CONFIG_CB710_DEBUG_ASSUMPTIONS=y
>
> #
> # Texas Instruments shared transport line discipline
> #
> # CONFIG_TI_ST is not set
> CONFIG_SENSORS_LIS3_I2C=y
>
> #
> # Altera FPGA firmware download module
> #
> CONFIG_ALTERA_STAPL=y
> CONFIG_INTEL_MEI=y
> # CONFIG_INTEL_MEI_ME is not set
> # CONFIG_INTEL_MEI_TXE is not set
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
> # CONFIG_FIREWIRE is not set
> CONFIG_FIREWIRE_NOSY=y
> CONFIG_I2O=y
> # CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
> # CONFIG_I2O_EXT_ADAPTEC is not set
> # CONFIG_I2O_CONFIG is not set
> CONFIG_I2O_BUS=y
> # CONFIG_I2O_PROC is not set
> # CONFIG_MACINTOSH_DRIVERS is not set
> # CONFIG_NETDEVICES is not set
> # CONFIG_VHOST_NET is not set
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
> CONFIG_INPUT_MOUSEDEV=y
> CONFIG_INPUT_MOUSEDEV_PSAUX=y
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
> CONFIG_KEYBOARD_ADP5588=y
> CONFIG_KEYBOARD_ADP5589=y
> CONFIG_KEYBOARD_ATKBD=y
> CONFIG_KEYBOARD_QT1070=y
> CONFIG_KEYBOARD_QT2160=y
> # CONFIG_KEYBOARD_LKKBD is not set
> CONFIG_KEYBOARD_GPIO=y
> CONFIG_KEYBOARD_GPIO_POLLED=y
> CONFIG_KEYBOARD_TCA6416=y
> CONFIG_KEYBOARD_TCA8418=y
> CONFIG_KEYBOARD_MATRIX=y
> # CONFIG_KEYBOARD_LM8323 is not set
> # CONFIG_KEYBOARD_LM8333 is not set
> # CONFIG_KEYBOARD_MAX7359 is not set
> CONFIG_KEYBOARD_MCS=y
> # CONFIG_KEYBOARD_MPR121 is not set
> CONFIG_KEYBOARD_NEWTON=y
> # CONFIG_KEYBOARD_OPENCORES is not set
> # CONFIG_KEYBOARD_SAMSUNG is not set
> CONFIG_KEYBOARD_GOLDFISH_EVENTS=y
> CONFIG_KEYBOARD_STOWAWAY=y
> CONFIG_KEYBOARD_SUNKBD=y
> CONFIG_KEYBOARD_SH_KEYSC=y
> CONFIG_KEYBOARD_TC3589X=y
> # CONFIG_KEYBOARD_XTKBD is not set
> # CONFIG_INPUT_MOUSE is not set
> # CONFIG_INPUT_JOYSTICK is not set
> CONFIG_INPUT_TABLET=y
> # CONFIG_TABLET_USB_ACECAD is not set
> # CONFIG_TABLET_USB_AIPTEK is not set
> # CONFIG_TABLET_USB_HANWANG is not set
> # CONFIG_TABLET_USB_KBTAB is not set
> # CONFIG_TABLET_USB_WACOM is not set
> CONFIG_INPUT_TOUCHSCREEN=y
> CONFIG_TOUCHSCREEN_88PM860X=y
> # CONFIG_TOUCHSCREEN_ADS7846 is not set
> CONFIG_TOUCHSCREEN_AD7877=y
> CONFIG_TOUCHSCREEN_AD7879=y
> CONFIG_TOUCHSCREEN_AD7879_I2C=y
> # CONFIG_TOUCHSCREEN_AD7879_SPI is not set
> CONFIG_TOUCHSCREEN_ATMEL_MXT=y
> # CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
> CONFIG_TOUCHSCREEN_BU21013=y
> CONFIG_TOUCHSCREEN_CY8CTMG110=y
> CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
> CONFIG_TOUCHSCREEN_CYTTSP_I2C=y
> CONFIG_TOUCHSCREEN_CYTTSP_SPI=y
> CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
> CONFIG_TOUCHSCREEN_CYTTSP4_I2C=y
> CONFIG_TOUCHSCREEN_CYTTSP4_SPI=y
> CONFIG_TOUCHSCREEN_DA9052=y
> # CONFIG_TOUCHSCREEN_DYNAPRO is not set
> CONFIG_TOUCHSCREEN_HAMPSHIRE=y
> # CONFIG_TOUCHSCREEN_EETI is not set
> CONFIG_TOUCHSCREEN_FUJITSU=y
> # CONFIG_TOUCHSCREEN_ILI210X is not set
> CONFIG_TOUCHSCREEN_GUNZE=y
> CONFIG_TOUCHSCREEN_ELO=y
> CONFIG_TOUCHSCREEN_WACOM_W8001=y
> CONFIG_TOUCHSCREEN_WACOM_I2C=y
> CONFIG_TOUCHSCREEN_MAX11801=y
> CONFIG_TOUCHSCREEN_MCS5000=y
> # CONFIG_TOUCHSCREEN_MMS114 is not set
> CONFIG_TOUCHSCREEN_MTOUCH=y
> CONFIG_TOUCHSCREEN_INEXIO=y
> CONFIG_TOUCHSCREEN_MK712=y
> CONFIG_TOUCHSCREEN_PENMOUNT=y
> # CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
> CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
> CONFIG_TOUCHSCREEN_TOUCHWIN=y
> CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
> CONFIG_TOUCHSCREEN_PIXCIR=y
> CONFIG_TOUCHSCREEN_WM831X=y
> # CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
> # CONFIG_TOUCHSCREEN_MC13783 is not set
> CONFIG_TOUCHSCREEN_TOUCHIT213=y
> # CONFIG_TOUCHSCREEN_TSC_SERIO is not set
> CONFIG_TOUCHSCREEN_TSC2005=y
> CONFIG_TOUCHSCREEN_TSC2007=y
> # CONFIG_TOUCHSCREEN_W90X900 is not set
> # CONFIG_TOUCHSCREEN_PCAP is not set
> CONFIG_TOUCHSCREEN_ST1232=y
> CONFIG_TOUCHSCREEN_TPS6507X=y
> CONFIG_TOUCHSCREEN_ZFORCE=y
> CONFIG_INPUT_MISC=y
> CONFIG_INPUT_88PM860X_ONKEY=y
> CONFIG_INPUT_AD714X=y
> CONFIG_INPUT_AD714X_I2C=y
> # CONFIG_INPUT_AD714X_SPI is not set
> # CONFIG_INPUT_BMA150 is not set
> CONFIG_INPUT_PCSPKR=y
> # CONFIG_INPUT_MAX8925_ONKEY is not set
> CONFIG_INPUT_MC13783_PWRBUTTON=y
> CONFIG_INPUT_MMA8450=y
> # CONFIG_INPUT_MPU3050 is not set
> CONFIG_INPUT_APANEL=y
> CONFIG_INPUT_GP2A=y
> # CONFIG_INPUT_GPIO_TILT_POLLED is not set
> CONFIG_INPUT_WISTRON_BTNS=y
> # CONFIG_INPUT_ATLAS_BTNS is not set
> # CONFIG_INPUT_ATI_REMOTE2 is not set
> # CONFIG_INPUT_KEYSPAN_REMOTE is not set
> CONFIG_INPUT_KXTJ9=y
> CONFIG_INPUT_KXTJ9_POLLED_MODE=y
> # CONFIG_INPUT_POWERMATE is not set
> # CONFIG_INPUT_YEALINK is not set
> # CONFIG_INPUT_CM109 is not set
> CONFIG_INPUT_RETU_PWRBUTTON=y
> # CONFIG_INPUT_UINPUT is not set
> CONFIG_INPUT_PCF8574=y
> CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
> CONFIG_INPUT_DA9052_ONKEY=y
> # CONFIG_INPUT_DA9055_ONKEY is not set
> CONFIG_INPUT_WM831X_ON=y
> # CONFIG_INPUT_PCAP is not set
> CONFIG_INPUT_ADXL34X=y
> CONFIG_INPUT_ADXL34X_I2C=y
> # CONFIG_INPUT_ADXL34X_SPI is not set
> CONFIG_INPUT_CMA3000=y
> # CONFIG_INPUT_CMA3000_I2C is not set
> CONFIG_INPUT_IDEAPAD_SLIDEBAR=y
> CONFIG_INPUT_SOC_BUTTON_ARRAY=y
>
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
> CONFIG_SERIO_I8042=y
> CONFIG_SERIO_SERPORT=y
> # CONFIG_SERIO_CT82C710 is not set
> CONFIG_SERIO_PCIPS2=y
> CONFIG_SERIO_LIBPS2=y
> # CONFIG_SERIO_RAW is not set
> CONFIG_SERIO_ALTERA_PS2=y
> # CONFIG_SERIO_PS2MULT is not set
> CONFIG_SERIO_ARC_PS2=y
> CONFIG_SERIO_OLPC_APSP=y
> # CONFIG_GAMEPORT is not set
>
> #
> # Character devices
> #
> CONFIG_TTY=y
> # CONFIG_VT is not set
> CONFIG_UNIX98_PTYS=y
> # CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
> CONFIG_LEGACY_PTYS=y
> CONFIG_LEGACY_PTY_COUNT=256
> # CONFIG_SERIAL_NONSTANDARD is not set
> # CONFIG_NOZOMI is not set
> # CONFIG_N_GSM is not set
> # CONFIG_TRACE_SINK is not set
> # CONFIG_GOLDFISH_TTY is not set
> # CONFIG_DEVKMEM is not set
>
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_SERIAL_8250_PCI=y
> # CONFIG_SERIAL_8250_CS is not set
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> # CONFIG_SERIAL_8250_EXTENDED is not set
> # CONFIG_SERIAL_8250_DW is not set
>
> #
> # Non-8250 serial port support
> #
> # CONFIG_SERIAL_CLPS711X is not set
> # CONFIG_SERIAL_MAX3100 is not set
> # CONFIG_SERIAL_MAX310X is not set
> # CONFIG_SERIAL_MRST_MAX3110 is not set
> # CONFIG_SERIAL_MFD_HSU is not set
> # CONFIG_SERIAL_UARTLITE is not set
> # CONFIG_SERIAL_SH_SCI is not set
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> # CONFIG_SERIAL_JSM is not set
> # CONFIG_SERIAL_SCCNXP is not set
> # CONFIG_SERIAL_TIMBERDALE is not set
> # CONFIG_SERIAL_ALTERA_JTAGUART is not set
> # CONFIG_SERIAL_ALTERA_UART is not set
> # CONFIG_SERIAL_IFX6X60 is not set
> # CONFIG_SERIAL_PCH_UART is not set
> # CONFIG_SERIAL_ARC is not set
> # CONFIG_SERIAL_RP2 is not set
> # CONFIG_SERIAL_FSL_LPUART is not set
> # CONFIG_SERIAL_ST_ASC is not set
> # CONFIG_TTY_PRINTK is not set
> # CONFIG_VIRTIO_CONSOLE is not set
> CONFIG_IPMI_HANDLER=y
> # CONFIG_IPMI_PANIC_EVENT is not set
> # CONFIG_IPMI_DEVICE_INTERFACE is not set
> CONFIG_IPMI_SI=y
> CONFIG_IPMI_SI_PROBE_DEFAULTS=y
> CONFIG_IPMI_WATCHDOG=y
> # CONFIG_IPMI_POWEROFF is not set
> CONFIG_HW_RANDOM=y
> CONFIG_HW_RANDOM_TIMERIOMEM=y
> CONFIG_HW_RANDOM_INTEL=y
> # CONFIG_HW_RANDOM_AMD is not set
> # CONFIG_HW_RANDOM_ATMEL is not set
> # CONFIG_HW_RANDOM_GEODE is not set
> CONFIG_HW_RANDOM_VIA=y
> # CONFIG_HW_RANDOM_VIRTIO is not set
> CONFIG_HW_RANDOM_EXYNOS=y
> CONFIG_NVRAM=y
> # CONFIG_R3964 is not set
> CONFIG_APPLICOM=y
> # CONFIG_SONYPI is not set
>
> #
> # PCMCIA character devices
> #
> # CONFIG_SYNCLINK_CS is not set
> # CONFIG_CARDMAN_4000 is not set
> CONFIG_CARDMAN_4040=y
> # CONFIG_MWAVE is not set
> # CONFIG_PC8736x_GPIO is not set
> # CONFIG_NSC_GPIO is not set
> # CONFIG_HPET is not set
> CONFIG_HANGCHECK_TIMER=y
> # CONFIG_TCG_TPM is not set
> # CONFIG_TELCLOCK is not set
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
> CONFIG_I2C_MUX_GPIO=y
> # CONFIG_I2C_MUX_PCA9541 is not set
> CONFIG_I2C_MUX_PCA954x=y
> CONFIG_I2C_MUX_PINCTRL=y
> # CONFIG_I2C_HELPER_AUTO is not set
> CONFIG_I2C_SMBUS=y
>
> #
> # I2C Algorithms
> #
> CONFIG_I2C_ALGOBIT=y
> CONFIG_I2C_ALGOPCF=y
> CONFIG_I2C_ALGOPCA=y
>
> #
> # I2C Hardware Bus support
> #
>
> #
> # PC SMBus host controller drivers
> #
> # CONFIG_I2C_ALI1535 is not set
> CONFIG_I2C_ALI1563=y
> CONFIG_I2C_ALI15X3=y
> CONFIG_I2C_AMD756=y
> # CONFIG_I2C_AMD756_S4882 is not set
> CONFIG_I2C_AMD8111=y
> # CONFIG_I2C_I801 is not set
> CONFIG_I2C_ISCH=y
> # CONFIG_I2C_ISMT is not set
> CONFIG_I2C_PIIX4=y
> CONFIG_I2C_NFORCE2=y
> CONFIG_I2C_NFORCE2_S4985=y
> CONFIG_I2C_SIS5595=y
> # CONFIG_I2C_SIS630 is not set
> CONFIG_I2C_SIS96X=y
> CONFIG_I2C_VIA=y
> # CONFIG_I2C_VIAPRO is not set
>
> #
> # ACPI drivers
> #
> CONFIG_I2C_SCMI=y
>
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> # CONFIG_I2C_CBUS_GPIO is not set
> CONFIG_I2C_DESIGNWARE_CORE=y
> CONFIG_I2C_DESIGNWARE_PLATFORM=y
> # CONFIG_I2C_DESIGNWARE_PCI is not set
> CONFIG_I2C_EFM32=y
> CONFIG_I2C_EG20T=y
> CONFIG_I2C_GPIO=y
> # CONFIG_I2C_KEMPLD is not set
> # CONFIG_I2C_OCORES is not set
> CONFIG_I2C_PCA_PLATFORM=y
> # CONFIG_I2C_PXA_PCI is not set
> # CONFIG_I2C_RIIC is not set
> CONFIG_I2C_SH_MOBILE=y
> CONFIG_I2C_SIMTEC=y
> # CONFIG_I2C_XILINX is not set
> CONFIG_I2C_RCAR=y
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
> CONFIG_SCx200_ACB=y
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> CONFIG_SPI=y
> # CONFIG_SPI_DEBUG is not set
> CONFIG_SPI_MASTER=y
>
> #
> # SPI Master Controller Drivers
> #
> CONFIG_SPI_ALTERA=y
> CONFIG_SPI_ATMEL=y
> CONFIG_SPI_BCM2835=y
> # CONFIG_SPI_BCM63XX_HSSPI is not set
> CONFIG_SPI_BITBANG=y
> CONFIG_SPI_CLPS711X=y
> # CONFIG_SPI_EP93XX is not set
> CONFIG_SPI_GPIO=y
> # CONFIG_SPI_IMX is not set
> # CONFIG_SPI_FSL_DSPI is not set
> CONFIG_SPI_OC_TINY=y
> # CONFIG_SPI_TI_QSPI is not set
> # CONFIG_SPI_OMAP_100K is not set
> CONFIG_SPI_ORION=y
> CONFIG_SPI_PXA2XX_DMA=y
> CONFIG_SPI_PXA2XX=y
> CONFIG_SPI_PXA2XX_PCI=y
> CONFIG_SPI_SC18IS602=y
> CONFIG_SPI_SH_MSIOF=y
> # CONFIG_SPI_SH is not set
> CONFIG_SPI_SH_HSPI=y
> CONFIG_SPI_SUN4I=y
> # CONFIG_SPI_TOPCLIFF_PCH is not set
> CONFIG_SPI_TXX9=y
> # CONFIG_SPI_XCOMM is not set
> CONFIG_SPI_XILINX=y
> # CONFIG_SPI_XTENSA_XTFPGA is not set
> CONFIG_SPI_DESIGNWARE=y
> CONFIG_SPI_DW_PCI=y
> # CONFIG_SPI_DW_MMIO is not set
>
> #
> # SPI Protocol Masters
> #
> CONFIG_SPI_SPIDEV=y
> # CONFIG_SPI_TLE62X0 is not set
> # CONFIG_SPMI is not set
> # CONFIG_HSI is not set
>
> #
> # PPS support
> #
> CONFIG_PPS=y
> # CONFIG_PPS_DEBUG is not set
> # CONFIG_NTP_PPS is not set
>
> #
> # PPS clients support
> #
> CONFIG_PPS_CLIENT_KTIMER=y
> # CONFIG_PPS_CLIENT_LDISC is not set
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
> CONFIG_PINCTRL=y
>
> #
> # Pin controllers
> #
> CONFIG_PINMUX=y
> CONFIG_PINCONF=y
> CONFIG_DEBUG_PINCTRL=y
> # CONFIG_PINCTRL_BAYTRAIL is not set
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> CONFIG_GPIOLIB=y
> CONFIG_GPIO_DEVRES=y
> CONFIG_GPIO_ACPI=y
> # CONFIG_DEBUG_GPIO is not set
> # CONFIG_GPIO_SYSFS is not set
> CONFIG_GPIO_GENERIC=y
> # CONFIG_GPIO_DA9052 is not set
> CONFIG_GPIO_DA9055=y
> CONFIG_GPIO_MAX730X=y
>
> #
> # Memory mapped GPIO drivers:
> #
> CONFIG_GPIO_CLPS711X=y
> # CONFIG_GPIO_GENERIC_PLATFORM is not set
> CONFIG_GPIO_IT8761E=y
> # CONFIG_GPIO_F7188X is not set
> # CONFIG_GPIO_SCH311X is not set
> CONFIG_GPIO_TS5500=y
> CONFIG_GPIO_SCH=y
> CONFIG_GPIO_ICH=y
> # CONFIG_GPIO_VX855 is not set
> # CONFIG_GPIO_LYNXPOINT is not set
>
> #
> # I2C GPIO expanders:
> #
> CONFIG_GPIO_ARIZONA=y
> # CONFIG_GPIO_MAX7300 is not set
> CONFIG_GPIO_MAX732X=y
> # CONFIG_GPIO_MAX732X_IRQ is not set
> CONFIG_GPIO_PCA953X=y
> # CONFIG_GPIO_PCA953X_IRQ is not set
> # CONFIG_GPIO_PCF857X is not set
> CONFIG_GPIO_RC5T583=y
> # CONFIG_GPIO_SX150X is not set
> CONFIG_GPIO_TC3589X=y
> CONFIG_GPIO_TPS65912=y
> CONFIG_GPIO_WM831X=y
> CONFIG_GPIO_ADP5588=y
> # CONFIG_GPIO_ADP5588_IRQ is not set
>
> #
> # PCI GPIO expanders:
> #
> CONFIG_GPIO_CS5535=y
> CONFIG_GPIO_BT8XX=y
> CONFIG_GPIO_AMD8111=y
> # CONFIG_GPIO_INTEL_MID is not set
> CONFIG_GPIO_PCH=y
> CONFIG_GPIO_ML_IOH=y
> # CONFIG_GPIO_TIMBERDALE is not set
> # CONFIG_GPIO_RDC321X is not set
>
> #
> # SPI GPIO expanders:
> #
> CONFIG_GPIO_MAX7301=y
> # CONFIG_GPIO_MC33880 is not set
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
> # CONFIG_GPIO_PALMAS is not set
> # CONFIG_GPIO_TPS6586X is not set
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
> # CONFIG_W1_MASTER_MXC is not set
> CONFIG_W1_MASTER_DS1WM=y
> # CONFIG_W1_MASTER_GPIO is not set
>
> #
> # 1-wire Slaves
> #
> CONFIG_W1_SLAVE_THERM=y
> CONFIG_W1_SLAVE_SMEM=y
> CONFIG_W1_SLAVE_DS2408=y
> CONFIG_W1_SLAVE_DS2408_READBACK=y
> CONFIG_W1_SLAVE_DS2413=y
> CONFIG_W1_SLAVE_DS2423=y
> # CONFIG_W1_SLAVE_DS2431 is not set
> CONFIG_W1_SLAVE_DS2433=y
> # CONFIG_W1_SLAVE_DS2433_CRC is not set
> CONFIG_W1_SLAVE_DS2760=y
> CONFIG_W1_SLAVE_DS2780=y
> CONFIG_W1_SLAVE_DS2781=y
> CONFIG_W1_SLAVE_DS28E04=y
> CONFIG_W1_SLAVE_BQ27000=y
> CONFIG_POWER_SUPPLY=y
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> CONFIG_PDA_POWER=y
> CONFIG_MAX8925_POWER=y
> # CONFIG_WM831X_BACKUP is not set
> # CONFIG_WM831X_POWER is not set
> # CONFIG_TEST_POWER is not set
> CONFIG_BATTERY_88PM860X=y
> CONFIG_BATTERY_DS2760=y
> CONFIG_BATTERY_DS2780=y
> # CONFIG_BATTERY_DS2781 is not set
> # CONFIG_BATTERY_DS2782 is not set
> CONFIG_BATTERY_SBS=y
> CONFIG_BATTERY_BQ27x00=y
> CONFIG_BATTERY_BQ27X00_I2C=y
> CONFIG_BATTERY_BQ27X00_PLATFORM=y
> CONFIG_BATTERY_DA9052=y
> # CONFIG_BATTERY_MAX17040 is not set
> CONFIG_BATTERY_MAX17042=y
> # CONFIG_CHARGER_88PM860X is not set
> CONFIG_CHARGER_MAX8903=y
> CONFIG_CHARGER_LP8727=y
> CONFIG_CHARGER_GPIO=y
> CONFIG_CHARGER_BQ2415X=y
> # CONFIG_CHARGER_BQ24190 is not set
> CONFIG_CHARGER_BQ24735=y
> CONFIG_CHARGER_SMB347=y
> CONFIG_CHARGER_TPS65090=y
> CONFIG_BATTERY_GOLDFISH=y
> CONFIG_POWER_RESET=y
> CONFIG_POWER_AVS=y
> CONFIG_HWMON=y
> CONFIG_HWMON_VID=y
> CONFIG_HWMON_DEBUG_CHIP=y
>
> #
> # Native drivers
> #
> # CONFIG_SENSORS_AD7314 is not set
> CONFIG_SENSORS_AD7414=y
> # CONFIG_SENSORS_AD7418 is not set
> CONFIG_SENSORS_ADM1021=y
> # CONFIG_SENSORS_ADM1025 is not set
> # CONFIG_SENSORS_ADM1026 is not set
> CONFIG_SENSORS_ADM1029=y
> # CONFIG_SENSORS_ADM1031 is not set
> # CONFIG_SENSORS_ADM9240 is not set
> CONFIG_SENSORS_ADT7X10=y
> # CONFIG_SENSORS_ADT7310 is not set
> CONFIG_SENSORS_ADT7410=y
> CONFIG_SENSORS_ADT7411=y
> # CONFIG_SENSORS_ADT7462 is not set
> # CONFIG_SENSORS_ADT7470 is not set
> # CONFIG_SENSORS_ADT7475 is not set
> # CONFIG_SENSORS_ASC7621 is not set
> CONFIG_SENSORS_K8TEMP=y
> # CONFIG_SENSORS_K10TEMP is not set
> # CONFIG_SENSORS_FAM15H_POWER is not set
> CONFIG_SENSORS_APPLESMC=y
> CONFIG_SENSORS_ASB100=y
> # CONFIG_SENSORS_ATXP1 is not set
> CONFIG_SENSORS_DS620=y
> # CONFIG_SENSORS_DS1621 is not set
> CONFIG_SENSORS_DA9052_ADC=y
> # CONFIG_SENSORS_DA9055 is not set
> # CONFIG_SENSORS_I5K_AMB is not set
> # CONFIG_SENSORS_F71805F is not set
> # CONFIG_SENSORS_F71882FG is not set
> CONFIG_SENSORS_F75375S=y
> CONFIG_SENSORS_MC13783_ADC=y
> # CONFIG_SENSORS_FSCHMD is not set
> # CONFIG_SENSORS_GL518SM is not set
> CONFIG_SENSORS_GL520SM=y
> # CONFIG_SENSORS_G760A is not set
> CONFIG_SENSORS_G762=y
> CONFIG_SENSORS_GPIO_FAN=y
> CONFIG_SENSORS_HIH6130=y
> CONFIG_SENSORS_IBMAEM=y
> # CONFIG_SENSORS_IBMPEX is not set
> # CONFIG_SENSORS_CORETEMP is not set
> CONFIG_SENSORS_IT87=y
> # CONFIG_SENSORS_JC42 is not set
> # CONFIG_SENSORS_LINEAGE is not set
> CONFIG_SENSORS_LTC2945=y
> CONFIG_SENSORS_LTC4151=y
> CONFIG_SENSORS_LTC4215=y
> # CONFIG_SENSORS_LTC4222 is not set
> CONFIG_SENSORS_LTC4245=y
> # CONFIG_SENSORS_LTC4260 is not set
> CONFIG_SENSORS_LTC4261=y
> CONFIG_SENSORS_MAX1111=y
> CONFIG_SENSORS_MAX16065=y
> CONFIG_SENSORS_MAX1619=y
> # CONFIG_SENSORS_MAX1668 is not set
> # CONFIG_SENSORS_MAX197 is not set
> CONFIG_SENSORS_MAX6639=y
> CONFIG_SENSORS_MAX6642=y
> CONFIG_SENSORS_MAX6650=y
> CONFIG_SENSORS_MAX6697=y
> # CONFIG_SENSORS_HTU21 is not set
> # CONFIG_SENSORS_MCP3021 is not set
> # CONFIG_SENSORS_ADCXX is not set
> # CONFIG_SENSORS_LM63 is not set
> CONFIG_SENSORS_LM70=y
> CONFIG_SENSORS_LM73=y
> CONFIG_SENSORS_LM75=y
> CONFIG_SENSORS_LM77=y
> # CONFIG_SENSORS_LM78 is not set
> CONFIG_SENSORS_LM80=y
> CONFIG_SENSORS_LM83=y
> CONFIG_SENSORS_LM85=y
> CONFIG_SENSORS_LM87=y
> CONFIG_SENSORS_LM90=y
> CONFIG_SENSORS_LM92=y
> # CONFIG_SENSORS_LM93 is not set
> CONFIG_SENSORS_LM95234=y
> # CONFIG_SENSORS_LM95241 is not set
> # CONFIG_SENSORS_LM95245 is not set
> CONFIG_SENSORS_PC87360=y
> # CONFIG_SENSORS_PC87427 is not set
> # CONFIG_SENSORS_NTC_THERMISTOR is not set
> CONFIG_SENSORS_NCT6775=y
> CONFIG_SENSORS_PCF8591=y
> # CONFIG_PMBUS is not set
> CONFIG_SENSORS_SHT15=y
> CONFIG_SENSORS_SHT21=y
> # CONFIG_SENSORS_SIS5595 is not set
> # CONFIG_SENSORS_DME1737 is not set
> CONFIG_SENSORS_EMC1403=y
> CONFIG_SENSORS_EMC2103=y
> CONFIG_SENSORS_EMC6W201=y
> # CONFIG_SENSORS_SMSC47M1 is not set
> CONFIG_SENSORS_SMSC47M192=y
> # CONFIG_SENSORS_SMSC47B397 is not set
> CONFIG_SENSORS_SCH56XX_COMMON=y
> # CONFIG_SENSORS_SCH5627 is not set
> CONFIG_SENSORS_SCH5636=y
> # CONFIG_SENSORS_SMM665 is not set
> # CONFIG_SENSORS_ADC128D818 is not set
> # CONFIG_SENSORS_ADS1015 is not set
> CONFIG_SENSORS_ADS7828=y
> # CONFIG_SENSORS_ADS7871 is not set
> # CONFIG_SENSORS_AMC6821 is not set
> CONFIG_SENSORS_INA209=y
> # CONFIG_SENSORS_INA2XX is not set
> # CONFIG_SENSORS_THMC50 is not set
> # CONFIG_SENSORS_TMP102 is not set
> CONFIG_SENSORS_TMP401=y
> CONFIG_SENSORS_TMP421=y
> CONFIG_SENSORS_VIA_CPUTEMP=y
> # CONFIG_SENSORS_VIA686A is not set
> CONFIG_SENSORS_VT1211=y
> CONFIG_SENSORS_VT8231=y
> CONFIG_SENSORS_W83781D=y
> CONFIG_SENSORS_W83791D=y
> # CONFIG_SENSORS_W83792D is not set
> CONFIG_SENSORS_W83793=y
> CONFIG_SENSORS_W83795=y
> # CONFIG_SENSORS_W83795_FANCTRL is not set
> CONFIG_SENSORS_W83L785TS=y
> CONFIG_SENSORS_W83L786NG=y
> CONFIG_SENSORS_W83627HF=y
> CONFIG_SENSORS_W83627EHF=y
> CONFIG_SENSORS_WM831X=y
>
> #
> # ACPI drivers
> #
> # CONFIG_SENSORS_ACPI_POWER is not set
> CONFIG_SENSORS_ATK0110=y
> CONFIG_THERMAL=y
> # CONFIG_THERMAL_HWMON is not set
> CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
> # CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
> # CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
> # CONFIG_THERMAL_GOV_FAIR_SHARE is not set
> CONFIG_THERMAL_GOV_STEP_WISE=y
> # CONFIG_THERMAL_GOV_USER_SPACE is not set
> CONFIG_THERMAL_EMULATION=y
> # CONFIG_RCAR_THERMAL is not set
> # CONFIG_ACPI_INT3403_THERMAL is not set
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
> CONFIG_SOFT_WATCHDOG=y
> # CONFIG_DA9052_WATCHDOG is not set
> # CONFIG_DA9055_WATCHDOG is not set
> # CONFIG_WM831X_WATCHDOG is not set
> # CONFIG_XILINX_WATCHDOG is not set
> CONFIG_DW_WATCHDOG=y
> CONFIG_RETU_WATCHDOG=y
> # CONFIG_TEGRA_WATCHDOG is not set
> CONFIG_ACQUIRE_WDT=y
> CONFIG_ADVANTECH_WDT=y
> # CONFIG_ALIM1535_WDT is not set
> CONFIG_ALIM7101_WDT=y
> CONFIG_F71808E_WDT=y
> CONFIG_SP5100_TCO=y
> # CONFIG_SBC_FITPC2_WATCHDOG is not set
> # CONFIG_EUROTECH_WDT is not set
> CONFIG_IB700_WDT=y
> CONFIG_IBMASR=y
> CONFIG_WAFER_WDT=y
> CONFIG_I6300ESB_WDT=y
> CONFIG_IE6XX_WDT=y
> CONFIG_ITCO_WDT=y
> CONFIG_ITCO_VENDOR_SUPPORT=y
> CONFIG_IT8712F_WDT=y
> CONFIG_IT87_WDT=y
> CONFIG_HP_WATCHDOG=y
> CONFIG_KEMPLD_WDT=y
> CONFIG_HPWDT_NMI_DECODING=y
> CONFIG_SC1200_WDT=y
> CONFIG_PC87413_WDT=y
> CONFIG_NV_TCO=y
> # CONFIG_60XX_WDT is not set
> CONFIG_SBC8360_WDT=y
> CONFIG_SBC7240_WDT=y
> # CONFIG_CPU5_WDT is not set
> # CONFIG_SMSC_SCH311X_WDT is not set
> # CONFIG_SMSC37B787_WDT is not set
> CONFIG_VIA_WDT=y
> CONFIG_W83627HF_WDT=y
> CONFIG_W83697HF_WDT=y
> CONFIG_W83697UG_WDT=y
> CONFIG_W83877F_WDT=y
> CONFIG_W83977F_WDT=y
> CONFIG_MACHZ_WDT=y
> CONFIG_SBC_EPX_C3_WATCHDOG=y
> # CONFIG_MEN_A21_WDT is not set
>
> #
> # PCI-based Watchdog Cards
> #
> CONFIG_PCIPCWATCHDOG=y
> CONFIG_WDTPCI=y
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
> CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
> # CONFIG_SSB_PCMCIAHOST is not set
> # CONFIG_SSB_SILENT is not set
> CONFIG_SSB_DEBUG=y
> CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
> CONFIG_SSB_DRIVER_PCICORE=y
> CONFIG_SSB_DRIVER_GPIO=y
> CONFIG_BCMA_POSSIBLE=y
>
> #
> # Broadcom specific AMBA
> #
> CONFIG_BCMA=y
> CONFIG_BCMA_HOST_PCI_POSSIBLE=y
> CONFIG_BCMA_HOST_PCI=y
> CONFIG_BCMA_HOST_SOC=y
> CONFIG_BCMA_DRIVER_GMAC_CMN=y
> CONFIG_BCMA_DRIVER_GPIO=y
> CONFIG_BCMA_DEBUG=y
>
> #
> # Multifunction device drivers
> #
> CONFIG_MFD_CORE=y
> CONFIG_MFD_CS5535=y
> # CONFIG_MFD_AS3711 is not set
> # CONFIG_PMIC_ADP5520 is not set
> CONFIG_MFD_AAT2870_CORE=y
> CONFIG_MFD_BCM590XX=y
> # CONFIG_MFD_CROS_EC is not set
> # CONFIG_PMIC_DA903X is not set
> CONFIG_PMIC_DA9052=y
> # CONFIG_MFD_DA9052_SPI is not set
> CONFIG_MFD_DA9052_I2C=y
> CONFIG_MFD_DA9055=y
> CONFIG_MFD_DA9063=y
> CONFIG_MFD_MC13XXX=y
> CONFIG_MFD_MC13XXX_SPI=y
> CONFIG_MFD_MC13XXX_I2C=y
> CONFIG_HTC_PASIC3=y
> # CONFIG_HTC_I2CPLD is not set
> CONFIG_LPC_ICH=y
> CONFIG_LPC_SCH=y
> # CONFIG_MFD_JANZ_CMODIO is not set
> CONFIG_MFD_KEMPLD=y
> # CONFIG_MFD_88PM800 is not set
> CONFIG_MFD_88PM805=y
> CONFIG_MFD_88PM860X=y
> # CONFIG_MFD_MAX14577 is not set
> CONFIG_MFD_MAX77686=y
> CONFIG_MFD_MAX77693=y
> # CONFIG_MFD_MAX8907 is not set
> CONFIG_MFD_MAX8925=y
> # CONFIG_MFD_MAX8997 is not set
> CONFIG_MFD_MAX8998=y
> CONFIG_EZX_PCAP=y
> CONFIG_MFD_RETU=y
> # CONFIG_MFD_PCF50633 is not set
> CONFIG_MFD_RDC321X=y
> CONFIG_MFD_RTSX_PCI=y
> CONFIG_MFD_RC5T583=y
> CONFIG_MFD_SEC_CORE=y
> CONFIG_MFD_SI476X_CORE=y
> CONFIG_MFD_SM501=y
> CONFIG_MFD_SM501_GPIO=y
> # CONFIG_MFD_SMSC is not set
> CONFIG_ABX500_CORE=y
> # CONFIG_AB3100_CORE is not set
> # CONFIG_MFD_STMPE is not set
> CONFIG_MFD_SYSCON=y
> CONFIG_MFD_TI_AM335X_TSCADC=y
> # CONFIG_MFD_LP3943 is not set
> # CONFIG_MFD_LP8788 is not set
> CONFIG_MFD_PALMAS=y
> # CONFIG_TPS6105X is not set
> # CONFIG_TPS65010 is not set
> CONFIG_TPS6507X=y
> CONFIG_MFD_TPS65090=y
> # CONFIG_MFD_TPS65217 is not set
> # CONFIG_MFD_TPS65218 is not set
> CONFIG_MFD_TPS6586X=y
> # CONFIG_MFD_TPS65910 is not set
> CONFIG_MFD_TPS65912=y
> CONFIG_MFD_TPS65912_I2C=y
> # CONFIG_MFD_TPS65912_SPI is not set
> # CONFIG_MFD_TPS80031 is not set
> # CONFIG_TWL4030_CORE is not set
> # CONFIG_TWL6040_CORE is not set
> CONFIG_MFD_WL1273_CORE=y
> CONFIG_MFD_LM3533=y
> CONFIG_MFD_TIMBERDALE=y
> CONFIG_MFD_TC3589X=y
> # CONFIG_MFD_TMIO is not set
> CONFIG_MFD_VX855=y
> CONFIG_MFD_ARIZONA=y
> CONFIG_MFD_ARIZONA_I2C=y
> CONFIG_MFD_ARIZONA_SPI=y
> CONFIG_MFD_WM5102=y
> # CONFIG_MFD_WM5110 is not set
> # CONFIG_MFD_WM8997 is not set
> # CONFIG_MFD_WM8400 is not set
> CONFIG_MFD_WM831X=y
> CONFIG_MFD_WM831X_I2C=y
> CONFIG_MFD_WM831X_SPI=y
> # CONFIG_MFD_WM8350_I2C is not set
> # CONFIG_MFD_WM8994 is not set
> CONFIG_REGULATOR=y
> # CONFIG_REGULATOR_DEBUG is not set
> CONFIG_REGULATOR_FIXED_VOLTAGE=y
> CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
> CONFIG_REGULATOR_USERSPACE_CONSUMER=y
> CONFIG_REGULATOR_88PM8607=y
> CONFIG_REGULATOR_ACT8865=y
> CONFIG_REGULATOR_AD5398=y
> # CONFIG_REGULATOR_ANATOP is not set
> CONFIG_REGULATOR_AAT2870=y
> CONFIG_REGULATOR_BCM590XX=y
> # CONFIG_REGULATOR_DA9052 is not set
> # CONFIG_REGULATOR_DA9055 is not set
> CONFIG_REGULATOR_DA9063=y
> # CONFIG_REGULATOR_DA9210 is not set
> CONFIG_REGULATOR_FAN53555=y
> CONFIG_REGULATOR_GPIO=y
> # CONFIG_REGULATOR_ISL6271A is not set
> CONFIG_REGULATOR_LP3971=y
> # CONFIG_REGULATOR_LP3972 is not set
> # CONFIG_REGULATOR_LP872X is not set
> CONFIG_REGULATOR_LP8755=y
> CONFIG_REGULATOR_MAX1586=y
> CONFIG_REGULATOR_MAX8649=y
> CONFIG_REGULATOR_MAX8660=y
> CONFIG_REGULATOR_MAX8925=y
> CONFIG_REGULATOR_MAX8952=y
> CONFIG_REGULATOR_MAX8973=y
> # CONFIG_REGULATOR_MAX8998 is not set
> CONFIG_REGULATOR_MAX77686=y
> # CONFIG_REGULATOR_MAX77693 is not set
> CONFIG_REGULATOR_MC13XXX_CORE=y
> # CONFIG_REGULATOR_MC13783 is not set
> CONFIG_REGULATOR_MC13892=y
> CONFIG_REGULATOR_PALMAS=y
> CONFIG_REGULATOR_PBIAS=y
> CONFIG_REGULATOR_PCAP=y
> # CONFIG_REGULATOR_PFUZE100 is not set
> # CONFIG_REGULATOR_RC5T583 is not set
> CONFIG_REGULATOR_S2MPA01=y
> # CONFIG_REGULATOR_S2MPS11 is not set
> # CONFIG_REGULATOR_S5M8767 is not set
> CONFIG_REGULATOR_TPS51632=y
> # CONFIG_REGULATOR_TPS62360 is not set
> # CONFIG_REGULATOR_TPS65023 is not set
> # CONFIG_REGULATOR_TPS6507X is not set
> CONFIG_REGULATOR_TPS65090=y
> # CONFIG_REGULATOR_TPS6524X is not set
> CONFIG_REGULATOR_TPS6586X=y
> CONFIG_REGULATOR_TPS65912=y
> CONFIG_REGULATOR_WM831X=y
> CONFIG_MEDIA_SUPPORT=y
>
> #
> # Multimedia core support
> #
> CONFIG_MEDIA_CAMERA_SUPPORT=y
> # CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
> CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
> CONFIG_MEDIA_RADIO_SUPPORT=y
> # CONFIG_MEDIA_RC_SUPPORT is not set
> CONFIG_MEDIA_CONTROLLER=y
> CONFIG_VIDEO_DEV=y
> # CONFIG_VIDEO_V4L2_SUBDEV_API is not set
> CONFIG_VIDEO_V4L2=y
> CONFIG_VIDEO_ADV_DEBUG=y
> # CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
> CONFIG_V4L2_MEM2MEM_DEV=y
> CONFIG_VIDEOBUF_GEN=y
> CONFIG_VIDEOBUF_DMA_SG=y
> CONFIG_VIDEOBUF2_CORE=y
> CONFIG_VIDEOBUF2_MEMOPS=y
> CONFIG_VIDEOBUF2_DMA_CONTIG=y
> CONFIG_DVB_CORE=y
> CONFIG_TTPCI_EEPROM=y
> CONFIG_DVB_MAX_ADAPTERS=8
> CONFIG_DVB_DYNAMIC_MINORS=y
>
> #
> # Media drivers
> #
> CONFIG_MEDIA_PCI_SUPPORT=y
>
> #
> # Media capture support
> #
>
> #
> # Media capture/analog/hybrid TV support
> #
> CONFIG_VIDEO_CX25821=y
> # CONFIG_VIDEO_SAA7134 is not set
> # CONFIG_VIDEO_SAA7164 is not set
>
> #
> # Media digital TV PCI Adapters
> #
> CONFIG_DVB_AV7110=y
> # CONFIG_DVB_AV7110_OSD is not set
> CONFIG_DVB_BUDGET_CORE=y
> # CONFIG_DVB_BUDGET is not set
> # CONFIG_DVB_BUDGET_AV is not set
> CONFIG_DVB_BUDGET_PATCH=y
> CONFIG_DVB_B2C2_FLEXCOP_PCI=y
> CONFIG_DVB_B2C2_FLEXCOP_PCI_DEBUG=y
> CONFIG_DVB_PLUTO2=y
> CONFIG_DVB_PT1=y
> # CONFIG_DVB_NGENE is not set
> CONFIG_DVB_DDBRIDGE=y
> # CONFIG_V4L_PLATFORM_DRIVERS is not set
> CONFIG_V4L_MEM2MEM_DRIVERS=y
> CONFIG_VIDEO_SH_VEU=y
> # CONFIG_V4L_TEST_DRIVERS is not set
>
> #
> # Supported MMC/SDIO adapters
> #
> CONFIG_RADIO_ADAPTERS=y
> CONFIG_RADIO_TEA575X=y
> # CONFIG_RADIO_SI470X is not set
> CONFIG_RADIO_SI4713=y
> # CONFIG_PLATFORM_SI4713 is not set
> CONFIG_I2C_SI4713=y
> CONFIG_RADIO_MAXIRADIO=y
> # CONFIG_RADIO_TEA5764 is not set
> CONFIG_RADIO_SAA7706H=y
> CONFIG_RADIO_TEF6862=y
> CONFIG_RADIO_TIMBERDALE=y
> CONFIG_RADIO_WL1273=y
>
> #
> # Texas Instruments WL128x FM driver (ST based)
> #
> CONFIG_VIDEO_BTCX=y
> CONFIG_DVB_B2C2_FLEXCOP=y
> CONFIG_DVB_B2C2_FLEXCOP_DEBUG=y
> CONFIG_VIDEO_SAA7146=y
> CONFIG_VIDEO_SAA7146_VV=y
>
> #
> # Media ancillary drivers (tuners, sensors, i2c, frontends)
> #
> # CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
>
> #
> # Encoders, decoders, sensors and other helper chips
> #
>
> #
> # Audio decoders, processors and mixers
> #
> CONFIG_VIDEO_TVAUDIO=y
> CONFIG_VIDEO_TDA7432=y
> CONFIG_VIDEO_TDA9840=y
> CONFIG_VIDEO_TEA6415C=y
> CONFIG_VIDEO_TEA6420=y
> CONFIG_VIDEO_MSP3400=y
> CONFIG_VIDEO_CS5345=y
> CONFIG_VIDEO_CS53L32A=y
> CONFIG_VIDEO_TLV320AIC23B=y
> # CONFIG_VIDEO_UDA1342 is not set
> CONFIG_VIDEO_WM8775=y
> CONFIG_VIDEO_WM8739=y
> CONFIG_VIDEO_VP27SMPX=y
> # CONFIG_VIDEO_SONY_BTF_MPX is not set
>
> #
> # RDS decoders
> #
> CONFIG_VIDEO_SAA6588=y
>
> #
> # Video decoders
> #
> CONFIG_VIDEO_ADV7180=y
> # CONFIG_VIDEO_ADV7183 is not set
> CONFIG_VIDEO_BT819=y
> CONFIG_VIDEO_BT856=y
> # CONFIG_VIDEO_BT866 is not set
> CONFIG_VIDEO_KS0127=y
> CONFIG_VIDEO_ML86V7667=y
> # CONFIG_VIDEO_SAA7110 is not set
> # CONFIG_VIDEO_SAA711X is not set
> # CONFIG_VIDEO_SAA7191 is not set
> # CONFIG_VIDEO_TVP514X is not set
> CONFIG_VIDEO_TVP5150=y
> # CONFIG_VIDEO_TVP7002 is not set
> CONFIG_VIDEO_TW2804=y
> CONFIG_VIDEO_TW9903=y
> CONFIG_VIDEO_TW9906=y
> # CONFIG_VIDEO_VPX3220 is not set
>
> #
> # Video and audio decoders
> #
> # CONFIG_VIDEO_SAA717X is not set
> CONFIG_VIDEO_CX25840=y
>
> #
> # Video encoders
> #
> # CONFIG_VIDEO_SAA7127 is not set
> # CONFIG_VIDEO_SAA7185 is not set
> CONFIG_VIDEO_ADV7170=y
> CONFIG_VIDEO_ADV7175=y
> # CONFIG_VIDEO_ADV7343 is not set
> # CONFIG_VIDEO_ADV7393 is not set
> CONFIG_VIDEO_AK881X=y
> CONFIG_VIDEO_THS8200=y
>
> #
> # Camera sensor devices
> #
> CONFIG_VIDEO_OV7640=y
> # CONFIG_VIDEO_OV7670 is not set
> CONFIG_VIDEO_VS6624=y
> # CONFIG_VIDEO_MT9V011 is not set
> # CONFIG_VIDEO_SR030PC30 is not set
>
> #
> # Flash devices
> #
> # CONFIG_VIDEO_ADP1653 is not set
> CONFIG_VIDEO_AS3645A=y
> # CONFIG_VIDEO_LM3560 is not set
> # CONFIG_VIDEO_LM3646 is not set
>
> #
> # Video improvement chips
> #
> # CONFIG_VIDEO_UPD64031A is not set
> CONFIG_VIDEO_UPD64083=y
>
> #
> # Audio/Video compression chips
> #
> CONFIG_VIDEO_SAA6752HS=y
>
> #
> # Miscellaneous helper chips
> #
> # CONFIG_VIDEO_THS7303 is not set
> CONFIG_VIDEO_M52790=y
>
> #
> # Sensors used on soc_camera driver
> #
> CONFIG_MEDIA_TUNER=y
>
> #
> # Customize TV tuners
> #
> CONFIG_MEDIA_TUNER_SIMPLE=y
> CONFIG_MEDIA_TUNER_TDA8290=y
> CONFIG_MEDIA_TUNER_TDA827X=y
> CONFIG_MEDIA_TUNER_TDA18271=y
> CONFIG_MEDIA_TUNER_TDA9887=y
> CONFIG_MEDIA_TUNER_TEA5761=y
> CONFIG_MEDIA_TUNER_TEA5767=y
> # CONFIG_MEDIA_TUNER_MT20XX is not set
> # CONFIG_MEDIA_TUNER_MT2060 is not set
> # CONFIG_MEDIA_TUNER_MT2063 is not set
> CONFIG_MEDIA_TUNER_MT2266=y
> CONFIG_MEDIA_TUNER_MT2131=y
> CONFIG_MEDIA_TUNER_QT1010=y
> CONFIG_MEDIA_TUNER_XC2028=y
> CONFIG_MEDIA_TUNER_XC5000=y
> # CONFIG_MEDIA_TUNER_XC4000 is not set
> # CONFIG_MEDIA_TUNER_MXL5005S is not set
> CONFIG_MEDIA_TUNER_MXL5007T=y
> CONFIG_MEDIA_TUNER_MC44S803=y
> CONFIG_MEDIA_TUNER_MAX2165=y
> CONFIG_MEDIA_TUNER_TDA18218=y
> # CONFIG_MEDIA_TUNER_FC0011 is not set
> CONFIG_MEDIA_TUNER_FC0012=y
> CONFIG_MEDIA_TUNER_FC0013=y
> CONFIG_MEDIA_TUNER_TDA18212=y
> CONFIG_MEDIA_TUNER_E4000=y
> CONFIG_MEDIA_TUNER_FC2580=y
> CONFIG_MEDIA_TUNER_M88TS2022=y
> CONFIG_MEDIA_TUNER_TUA9001=y
> # CONFIG_MEDIA_TUNER_IT913X is not set
> # CONFIG_MEDIA_TUNER_R820T is not set
>
> #
> # Customise DVB Frontends
> #
>
> #
> # Multistandard (satellite) frontends
> #
> CONFIG_DVB_STB0899=y
> CONFIG_DVB_STB6100=y
> CONFIG_DVB_STV090x=y
> # CONFIG_DVB_STV6110x is not set
> CONFIG_DVB_M88DS3103=y
>
> #
> # Multistandard (cable + terrestrial) frontends
> #
> CONFIG_DVB_DRXK=y
> # CONFIG_DVB_TDA18271C2DD is not set
>
> #
> # DVB-S (satellite) frontends
> #
> CONFIG_DVB_CX24110=y
> # CONFIG_DVB_CX24123 is not set
> CONFIG_DVB_MT312=y
> CONFIG_DVB_ZL10036=y
> # CONFIG_DVB_ZL10039 is not set
> CONFIG_DVB_S5H1420=y
> # CONFIG_DVB_STV0288 is not set
> CONFIG_DVB_STB6000=y
> CONFIG_DVB_STV0299=y
> # CONFIG_DVB_STV6110 is not set
> # CONFIG_DVB_STV0900 is not set
> # CONFIG_DVB_TDA8083 is not set
> # CONFIG_DVB_TDA10086 is not set
> # CONFIG_DVB_TDA8261 is not set
> CONFIG_DVB_VES1X93=y
> # CONFIG_DVB_TUNER_ITD1000 is not set
> # CONFIG_DVB_TUNER_CX24113 is not set
> # CONFIG_DVB_TDA826X is not set
> # CONFIG_DVB_TUA6100 is not set
> CONFIG_DVB_CX24116=y
> CONFIG_DVB_CX24117=y
> CONFIG_DVB_SI21XX=y
> CONFIG_DVB_TS2020=y
> CONFIG_DVB_DS3000=y
> CONFIG_DVB_MB86A16=y
> # CONFIG_DVB_TDA10071 is not set
>
> #
> # DVB-T (terrestrial) frontends
> #
> CONFIG_DVB_SP8870=y
> # CONFIG_DVB_SP887X is not set
> # CONFIG_DVB_CX22700 is not set
> CONFIG_DVB_CX22702=y
> # CONFIG_DVB_S5H1432 is not set
> # CONFIG_DVB_DRXD is not set
> CONFIG_DVB_L64781=y
> CONFIG_DVB_TDA1004X=y
> CONFIG_DVB_NXT6000=y
> # CONFIG_DVB_MT352 is not set
> # CONFIG_DVB_ZL10353 is not set
> # CONFIG_DVB_DIB3000MB is not set
> CONFIG_DVB_DIB3000MC=y
> CONFIG_DVB_DIB7000M=y
> # CONFIG_DVB_DIB7000P is not set
> CONFIG_DVB_DIB9000=y
> CONFIG_DVB_TDA10048=y
> CONFIG_DVB_AF9013=y
> CONFIG_DVB_EC100=y
> # CONFIG_DVB_HD29L2 is not set
> CONFIG_DVB_STV0367=y
> CONFIG_DVB_CXD2820R=y
> # CONFIG_DVB_RTL2830 is not set
> CONFIG_DVB_RTL2832=y
>
> #
> # DVB-C (cable) frontends
> #
> CONFIG_DVB_VES1820=y
> CONFIG_DVB_TDA10021=y
> CONFIG_DVB_TDA10023=y
> CONFIG_DVB_STV0297=y
>
> #
> # ATSC (North American/Korean Terrestrial/Cable DTV) frontends
> #
> CONFIG_DVB_NXT200X=y
> CONFIG_DVB_OR51211=y
> CONFIG_DVB_OR51132=y
> CONFIG_DVB_BCM3510=y
> CONFIG_DVB_LGDT330X=y
> CONFIG_DVB_LGDT3305=y
> # CONFIG_DVB_LG2160 is not set
> CONFIG_DVB_S5H1409=y
> CONFIG_DVB_AU8522=y
> # CONFIG_DVB_AU8522_DTV is not set
> CONFIG_DVB_AU8522_V4L=y
> CONFIG_DVB_S5H1411=y
>
> #
> # ISDB-T (terrestrial) frontends
> #
> # CONFIG_DVB_S921 is not set
> # CONFIG_DVB_DIB8000 is not set
> CONFIG_DVB_MB86A20S=y
>
> #
> # Digital terrestrial only tuners/PLL
> #
> CONFIG_DVB_PLL=y
> CONFIG_DVB_TUNER_DIB0070=y
> CONFIG_DVB_TUNER_DIB0090=y
>
> #
> # SEC control devices for DVB-S
> #
> # CONFIG_DVB_DRX39XYJ is not set
> # CONFIG_DVB_LNBP21 is not set
> CONFIG_DVB_LNBP22=y
> CONFIG_DVB_ISL6405=y
> CONFIG_DVB_ISL6421=y
> # CONFIG_DVB_ISL6423 is not set
> CONFIG_DVB_A8293=y
> # CONFIG_DVB_LGS8GL5 is not set
> # CONFIG_DVB_LGS8GXX is not set
> # CONFIG_DVB_ATBM8830 is not set
> CONFIG_DVB_TDA665x=y
> CONFIG_DVB_IX2505V=y
> # CONFIG_DVB_M88RS2000 is not set
> # CONFIG_DVB_AF9033 is not set
>
> #
> # Tools to develop new frontends
> #
> # CONFIG_DVB_DUMMY_FE is not set
>
> #
> # Graphics support
> #
> CONFIG_AGP=y
> CONFIG_AGP_ALI=y
> CONFIG_AGP_ATI=y
> # CONFIG_AGP_AMD is not set
> # CONFIG_AGP_AMD64 is not set
> CONFIG_AGP_INTEL=y
> CONFIG_AGP_NVIDIA=y
> CONFIG_AGP_SIS=y
> CONFIG_AGP_SWORKS=y
> CONFIG_AGP_VIA=y
> # CONFIG_AGP_EFFICEON is not set
> CONFIG_INTEL_GTT=y
> # CONFIG_VGA_ARB is not set
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
> # CONFIG_DRM_I2C_CH7006 is not set
> CONFIG_DRM_I2C_SIL164=y
> # CONFIG_DRM_I2C_NXP_TDA998X is not set
> # CONFIG_DRM_TDFX is not set
> CONFIG_DRM_R128=y
> CONFIG_DRM_RADEON=y
> # CONFIG_DRM_RADEON_UMS is not set
> # CONFIG_DRM_NOUVEAU is not set
> # CONFIG_DRM_I810 is not set
> # CONFIG_DRM_I915 is not set
> CONFIG_DRM_MGA=y
> CONFIG_DRM_SIS=y
> # CONFIG_DRM_VIA is not set
> CONFIG_DRM_SAVAGE=y
> # CONFIG_DRM_VMWGFX is not set
> # CONFIG_DRM_GMA500 is not set
> # CONFIG_DRM_UDL is not set
> # CONFIG_DRM_AST is not set
> CONFIG_DRM_MGAG200=y
> CONFIG_DRM_CIRRUS_QEMU=y
> # CONFIG_DRM_QXL is not set
> # CONFIG_DRM_BOCHS is not set
> CONFIG_DRM_PTN3460=y
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
> CONFIG_FB_FOREIGN_ENDIAN=y
> CONFIG_FB_BOTH_ENDIAN=y
> # CONFIG_FB_BIG_ENDIAN is not set
> # CONFIG_FB_LITTLE_ENDIAN is not set
> CONFIG_FB_SYS_FOPS=y
> CONFIG_FB_DEFERRED_IO=y
> CONFIG_FB_SVGALIB=y
> # CONFIG_FB_MACMODES is not set
> CONFIG_FB_BACKLIGHT=y
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
> # CONFIG_FB_VESA is not set
> # CONFIG_FB_N411 is not set
> # CONFIG_FB_HGA is not set
> # CONFIG_FB_OPENCORES is not set
> # CONFIG_FB_S1D13XXX is not set
> # CONFIG_FB_NVIDIA is not set
> CONFIG_FB_RIVA=y
> CONFIG_FB_RIVA_I2C=y
> CONFIG_FB_RIVA_DEBUG=y
> CONFIG_FB_RIVA_BACKLIGHT=y
> # CONFIG_FB_I740 is not set
> CONFIG_FB_I810=y
> CONFIG_FB_I810_GTF=y
> # CONFIG_FB_I810_I2C is not set
> # CONFIG_FB_LE80578 is not set
> CONFIG_FB_INTEL=y
> CONFIG_FB_INTEL_DEBUG=y
> # CONFIG_FB_INTEL_I2C is not set
> CONFIG_FB_MATROX=y
> CONFIG_FB_MATROX_MILLENIUM=y
> CONFIG_FB_MATROX_MYSTIQUE=y
> CONFIG_FB_MATROX_G=y
> # CONFIG_FB_MATROX_I2C is not set
> CONFIG_FB_RADEON=y
> # CONFIG_FB_RADEON_I2C is not set
> CONFIG_FB_RADEON_BACKLIGHT=y
> # CONFIG_FB_RADEON_DEBUG is not set
> CONFIG_FB_ATY128=y
> CONFIG_FB_ATY128_BACKLIGHT=y
> # CONFIG_FB_ATY is not set
> CONFIG_FB_S3=y
> CONFIG_FB_S3_DDC=y
> CONFIG_FB_SAVAGE=y
> CONFIG_FB_SAVAGE_I2C=y
> # CONFIG_FB_SAVAGE_ACCEL is not set
> CONFIG_FB_SIS=y
> CONFIG_FB_SIS_300=y
> CONFIG_FB_SIS_315=y
> CONFIG_FB_VIA=y
> # CONFIG_FB_VIA_DIRECT_PROCFS is not set
> CONFIG_FB_VIA_X_COMPATIBILITY=y
> CONFIG_FB_NEOMAGIC=y
> CONFIG_FB_KYRO=y
> CONFIG_FB_3DFX=y
> # CONFIG_FB_3DFX_ACCEL is not set
> CONFIG_FB_3DFX_I2C=y
> CONFIG_FB_VOODOO1=y
> CONFIG_FB_VT8623=y
> # CONFIG_FB_TRIDENT is not set
> CONFIG_FB_ARK=y
> CONFIG_FB_PM3=y
> CONFIG_FB_CARMINE=y
> # CONFIG_FB_CARMINE_DRAM_EVAL is not set
> CONFIG_CARMINE_DRAM_CUSTOM=y
> # CONFIG_FB_GEODE is not set
> CONFIG_FB_TMIO=y
> CONFIG_FB_TMIO_ACCELL=y
> CONFIG_FB_SM501=y
> # CONFIG_FB_GOLDFISH is not set
> CONFIG_FB_VIRTUAL=y
> CONFIG_FB_METRONOME=y
> # CONFIG_FB_MB862XX is not set
> # CONFIG_FB_BROADSHEET is not set
> # CONFIG_FB_AUO_K190X is not set
> # CONFIG_FB_SIMPLE is not set
> CONFIG_EXYNOS_VIDEO=y
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> # CONFIG_LCD_CLASS_DEVICE is not set
> CONFIG_BACKLIGHT_CLASS_DEVICE=y
> # CONFIG_BACKLIGHT_ATMEL_PWM is not set
> # CONFIG_BACKLIGHT_GENERIC is not set
> CONFIG_BACKLIGHT_LM3533=y
> # CONFIG_BACKLIGHT_DA9052 is not set
> # CONFIG_BACKLIGHT_MAX8925 is not set
> CONFIG_BACKLIGHT_APPLE=y
> CONFIG_BACKLIGHT_SAHARA=y
> CONFIG_BACKLIGHT_WM831X=y
> CONFIG_BACKLIGHT_ADP8860=y
> # CONFIG_BACKLIGHT_ADP8870 is not set
> # CONFIG_BACKLIGHT_88PM860X is not set
> # CONFIG_BACKLIGHT_AAT2870 is not set
> CONFIG_BACKLIGHT_LM3630A=y
> # CONFIG_BACKLIGHT_LM3639 is not set
> # CONFIG_BACKLIGHT_LP855X is not set
> CONFIG_BACKLIGHT_GPIO=y
> CONFIG_BACKLIGHT_LV5207LP=y
> # CONFIG_BACKLIGHT_BD6107 is not set
> CONFIG_VGASTATE=y
> CONFIG_HDMI=y
> CONFIG_LOGO=y
> # CONFIG_LOGO_LINUX_MONO is not set
> CONFIG_LOGO_LINUX_VGA16=y
> # CONFIG_LOGO_LINUX_CLUT224 is not set
> # CONFIG_SOUND is not set
>
> #
> # HID support
> #
> CONFIG_HID=y
> CONFIG_HID_BATTERY_STRENGTH=y
> CONFIG_HIDRAW=y
> # CONFIG_UHID is not set
> CONFIG_HID_GENERIC=y
>
> #
> # Special HID drivers
> #
> CONFIG_HID_A4TECH=y
> # CONFIG_HID_ACRUX is not set
> CONFIG_HID_APPLE=y
> CONFIG_HID_AUREAL=y
> CONFIG_HID_BELKIN=y
> CONFIG_HID_CHERRY=y
> CONFIG_HID_CHICONY=y
> CONFIG_HID_CYPRESS=y
> # CONFIG_HID_DRAGONRISE is not set
> CONFIG_HID_EMS_FF=y
> CONFIG_HID_ELECOM=y
> # CONFIG_HID_EZKEY is not set
> # CONFIG_HID_KEYTOUCH is not set
> CONFIG_HID_KYE=y
> CONFIG_HID_UCLOGIC=y
> CONFIG_HID_WALTOP=y
> CONFIG_HID_GYRATION=y
> CONFIG_HID_ICADE=y
> # CONFIG_HID_TWINHAN is not set
> CONFIG_HID_KENSINGTON=y
> CONFIG_HID_LCPOWER=y
> CONFIG_HID_LENOVO_TPKBD=y
> # CONFIG_HID_LOGITECH is not set
> CONFIG_HID_MAGICMOUSE=y
> # CONFIG_HID_MICROSOFT is not set
> CONFIG_HID_MONTEREY=y
> CONFIG_HID_MULTITOUCH=y
> # CONFIG_HID_ORTEK is not set
> # CONFIG_HID_PANTHERLORD is not set
> CONFIG_HID_PETALYNX=y
> CONFIG_HID_PICOLCD=y
> CONFIG_HID_PICOLCD_FB=y
> CONFIG_HID_PICOLCD_BACKLIGHT=y
> CONFIG_HID_PICOLCD_LEDS=y
> CONFIG_HID_PRIMAX=y
> # CONFIG_HID_SAITEK is not set
> CONFIG_HID_SAMSUNG=y
> CONFIG_HID_SPEEDLINK=y
> # CONFIG_HID_STEELSERIES is not set
> CONFIG_HID_SUNPLUS=y
> # CONFIG_HID_GREENASIA is not set
> # CONFIG_HID_SMARTJOYPLUS is not set
> CONFIG_HID_TIVO=y
> CONFIG_HID_TOPSEED=y
> CONFIG_HID_THINGM=y
> # CONFIG_HID_THRUSTMASTER is not set
> # CONFIG_HID_WACOM is not set
> CONFIG_HID_WIIMOTE=y
> # CONFIG_HID_XINMO is not set
> # CONFIG_HID_ZEROPLUS is not set
> CONFIG_HID_ZYDACRON=y
> CONFIG_HID_SENSOR_HUB=y
>
> #
> # I2C HID support
> #
> CONFIG_I2C_HID=y
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
> # CONFIG_KEYSTONE_USB_PHY is not set
> # CONFIG_NOP_USB_XCEIV is not set
> # CONFIG_AM335X_PHY_USB is not set
> # CONFIG_SAMSUNG_USB2PHY is not set
> # CONFIG_SAMSUNG_USB3PHY is not set
> # CONFIG_USB_GPIO_VBUS is not set
> # CONFIG_TAHVO_USB is not set
> # CONFIG_USB_RCAR_GEN2_PHY is not set
> # CONFIG_USB_GADGET is not set
> CONFIG_UWB=y
> CONFIG_UWB_WHCI=y
> # CONFIG_MMC is not set
> # CONFIG_MEMSTICK is not set
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=y
>
> #
> # LED drivers
> #
> CONFIG_LEDS_88PM860X=y
> # CONFIG_LEDS_ATMEL_PWM is not set
> # CONFIG_LEDS_LM3530 is not set
> CONFIG_LEDS_LM3533=y
> # CONFIG_LEDS_LM3642 is not set
> CONFIG_LEDS_PCA9532=y
> CONFIG_LEDS_PCA9532_GPIO=y
> CONFIG_LEDS_GPIO=y
> # CONFIG_LEDS_LP3944 is not set
> CONFIG_LEDS_LP55XX_COMMON=y
> # CONFIG_LEDS_LP5521 is not set
> CONFIG_LEDS_LP5523=y
> CONFIG_LEDS_LP5562=y
> # CONFIG_LEDS_LP8501 is not set
> CONFIG_LEDS_PCA955X=y
> CONFIG_LEDS_PCA963X=y
> CONFIG_LEDS_PCA9685=y
> CONFIG_LEDS_WM831X_STATUS=y
> CONFIG_LEDS_DA9052=y
> # CONFIG_LEDS_DAC124S085 is not set
> CONFIG_LEDS_REGULATOR=y
> # CONFIG_LEDS_BD2802 is not set
> CONFIG_LEDS_LT3593=y
> # CONFIG_LEDS_MC13783 is not set
> CONFIG_LEDS_TCA6507=y
> CONFIG_LEDS_LM355x=y
> CONFIG_LEDS_OT200=y
> CONFIG_LEDS_BLINKM=y
>
> #
> # LED Triggers
> #
> CONFIG_LEDS_TRIGGERS=y
> # CONFIG_LEDS_TRIGGER_TIMER is not set
> # CONFIG_LEDS_TRIGGER_ONESHOT is not set
> CONFIG_LEDS_TRIGGER_HEARTBEAT=y
> # CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
> CONFIG_LEDS_TRIGGER_CPU=y
> CONFIG_LEDS_TRIGGER_GPIO=y
> # CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
>
> #
> # iptables trigger is under Netfilter config (LED target)
> #
> CONFIG_LEDS_TRIGGER_TRANSIENT=y
> # CONFIG_LEDS_TRIGGER_CAMERA is not set
> CONFIG_ACCESSIBILITY=y
> # CONFIG_EDAC is not set
> CONFIG_RTC_LIB=y
> # CONFIG_RTC_CLASS is not set
> # CONFIG_DMADEVICES is not set
> CONFIG_AUXDISPLAY=y
> CONFIG_UIO=y
> # CONFIG_UIO_CIF is not set
> CONFIG_UIO_PDRV_GENIRQ=y
> CONFIG_UIO_DMEM_GENIRQ=y
> CONFIG_UIO_AEC=y
> CONFIG_UIO_SERCOS3=y
> CONFIG_UIO_PCI_GENERIC=y
> CONFIG_UIO_NETX=y
> CONFIG_UIO_MF624=y
> CONFIG_VIRT_DRIVERS=y
> CONFIG_VIRTIO=y
>
> #
> # Virtio drivers
> #
> CONFIG_VIRTIO_PCI=y
> CONFIG_VIRTIO_BALLOON=y
> # CONFIG_VIRTIO_MMIO is not set
>
> #
> # Microsoft Hyper-V guest support
> #
> CONFIG_STAGING=y
> # CONFIG_SLICOSS is not set
> CONFIG_DX_SEP=y
> # CONFIG_CRYSTALHD is not set
> # CONFIG_FB_XGI is not set
> # CONFIG_ACPI_QUICKSTART is not set
> CONFIG_FT1000=y
> # CONFIG_FT1000_PCMCIA is not set
>
> #
> # Speakup console speech
> #
> # CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
> CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
> # CONFIG_STAGING_MEDIA is not set
>
> #
> # Android
> #
> # CONFIG_ANDROID is not set
> # CONFIG_DGRP is not set
> CONFIG_GOLDFISH_AUDIO=y
> CONFIG_MTD_GOLDFISH_NAND=y
> # CONFIG_XILLYBUS is not set
> # CONFIG_DGNC is not set
> # CONFIG_DGAP is not set
> # CONFIG_GS_FPGABOOT is not set
> # CONFIG_X86_PLATFORM_DEVICES is not set
> CONFIG_GOLDFISH_PIPE=y
> CONFIG_CHROME_PLATFORMS=y
> CONFIG_CHROMEOS_PSTORE=y
> CONFIG_CLKDEV_LOOKUP=y
> CONFIG_HAVE_CLK_PREPARE=y
> CONFIG_COMMON_CLK=y
>
> #
> # Common Clock Framework
> #
> CONFIG_COMMON_CLK_WM831X=y
> # CONFIG_COMMON_CLK_MAX77686 is not set
> CONFIG_COMMON_CLK_SI5351=y
> # CONFIG_COMMON_CLK_S2MPS11 is not set
>
> #
> # Hardware Spinlock drivers
> #
> CONFIG_CLKSRC_I8253=y
> CONFIG_CLKEVT_I8253=y
> CONFIG_I8253_LOCK=y
> CONFIG_CLKBLD_I8253=y
> # CONFIG_SH_TIMER_CMT is not set
> CONFIG_SH_TIMER_MTU2=y
> CONFIG_SH_TIMER_TMU=y
> CONFIG_EM_TIMER_STI=y
> CONFIG_MAILBOX=y
> CONFIG_IOMMU_SUPPORT=y
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
> CONFIG_PM_DEVFREQ=y
>
> #
> # DEVFREQ Governors
> #
> CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
> CONFIG_DEVFREQ_GOV_PERFORMANCE=y
> CONFIG_DEVFREQ_GOV_POWERSAVE=y
> # CONFIG_DEVFREQ_GOV_USERSPACE is not set
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
> CONFIG_EXTCON_MAX77693=y
> # CONFIG_EXTCON_PALMAS is not set
> # CONFIG_MEMORY is not set
> # CONFIG_IIO is not set
> # CONFIG_NTB is not set
> # CONFIG_VME_BUS is not set
> # CONFIG_PWM is not set
> CONFIG_IPACK_BUS=y
> CONFIG_BOARD_TPCI200=y
> # CONFIG_SERIAL_IPOCTAL is not set
> # CONFIG_RESET_CONTROLLER is not set
> CONFIG_FMC=y
> # CONFIG_FMC_FAKEDEV is not set
> CONFIG_FMC_TRIVIAL=y
> CONFIG_FMC_WRITE_EEPROM=y
> # CONFIG_FMC_CHARDEV is not set
>
> #
> # PHY Subsystem
> #
> CONFIG_GENERIC_PHY=y
> # CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
> CONFIG_OMAP_CONTROL_PHY=y
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
> CONFIG_EDD=y
> CONFIG_EDD_OFF=y
> # CONFIG_FIRMWARE_MEMMAP is not set
> CONFIG_DELL_RBU=y
> CONFIG_DCDBAS=y
> # CONFIG_ISCSI_IBFT_FIND is not set
> # CONFIG_GOOGLE_FIRMWARE is not set
> CONFIG_UEFI_CPER=y
>
> #
> # File systems
> #
> CONFIG_DCACHE_WORD_ACCESS=y
> CONFIG_FS_POSIX_ACL=y
> CONFIG_EXPORTFS=y
> # CONFIG_FILE_LOCKING is not set
> # CONFIG_FSNOTIFY is not set
> # CONFIG_DNOTIFY is not set
> # CONFIG_INOTIFY_USER is not set
> # CONFIG_FANOTIFY is not set
> CONFIG_QUOTA=y
> # CONFIG_QUOTA_NETLINK_INTERFACE is not set
> # CONFIG_PRINT_QUOTA_WARNING is not set
> # CONFIG_QUOTA_DEBUG is not set
> CONFIG_QUOTA_TREE=y
> CONFIG_QFMT_V1=y
> CONFIG_QFMT_V2=y
> CONFIG_QUOTACTL=y
> CONFIG_AUTOFS4_FS=y
> # CONFIG_FUSE_FS is not set
>
> #
> # Caches
> #
> CONFIG_FSCACHE=y
> # CONFIG_FSCACHE_DEBUG is not set
>
> #
> # Pseudo filesystems
> #
> # CONFIG_PROC_FS is not set
> CONFIG_KERNFS=y
> CONFIG_SYSFS=y
> CONFIG_HUGETLBFS=y
> CONFIG_HUGETLB_PAGE=y
> CONFIG_CONFIGFS_FS=y
> CONFIG_MISC_FILESYSTEMS=y
> CONFIG_ECRYPT_FS=y
> CONFIG_ECRYPT_FS_MESSAGING=y
> CONFIG_JFFS2_FS=y
> CONFIG_JFFS2_FS_DEBUG=0
> # CONFIG_JFFS2_FS_WRITEBUFFER is not set
> # CONFIG_JFFS2_SUMMARY is not set
> CONFIG_JFFS2_FS_XATTR=y
> CONFIG_JFFS2_FS_POSIX_ACL=y
> CONFIG_JFFS2_FS_SECURITY=y
> CONFIG_JFFS2_COMPRESSION_OPTIONS=y
> # CONFIG_JFFS2_ZLIB is not set
> CONFIG_JFFS2_LZO=y
> # CONFIG_JFFS2_RTIME is not set
> CONFIG_JFFS2_RUBIN=y
> # CONFIG_JFFS2_CMODE_NONE is not set
> CONFIG_JFFS2_CMODE_PRIORITY=y
> # CONFIG_JFFS2_CMODE_SIZE is not set
> # CONFIG_JFFS2_CMODE_FAVOURLZO is not set
> # CONFIG_UBIFS_FS is not set
> # CONFIG_LOGFS is not set
> CONFIG_ROMFS_FS=y
> CONFIG_ROMFS_BACKED_BY_MTD=y
> CONFIG_ROMFS_ON_MTD=y
> CONFIG_PSTORE=y
> # CONFIG_PSTORE_CONSOLE is not set
> CONFIG_PSTORE_FTRACE=y
> # CONFIG_PSTORE_RAM is not set
> CONFIG_NETWORK_FILESYSTEMS=y
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-1"
> # CONFIG_NLS_CODEPAGE_437 is not set
> # CONFIG_NLS_CODEPAGE_737 is not set
> # CONFIG_NLS_CODEPAGE_775 is not set
> # CONFIG_NLS_CODEPAGE_850 is not set
> # CONFIG_NLS_CODEPAGE_852 is not set
> CONFIG_NLS_CODEPAGE_855=y
> # CONFIG_NLS_CODEPAGE_857 is not set
> CONFIG_NLS_CODEPAGE_860=y
> CONFIG_NLS_CODEPAGE_861=y
> # CONFIG_NLS_CODEPAGE_862 is not set
> # CONFIG_NLS_CODEPAGE_863 is not set
> CONFIG_NLS_CODEPAGE_864=y
> CONFIG_NLS_CODEPAGE_865=y
> CONFIG_NLS_CODEPAGE_866=y
> CONFIG_NLS_CODEPAGE_869=y
> CONFIG_NLS_CODEPAGE_936=y
> CONFIG_NLS_CODEPAGE_950=y
> CONFIG_NLS_CODEPAGE_932=y
> # CONFIG_NLS_CODEPAGE_949 is not set
> # CONFIG_NLS_CODEPAGE_874 is not set
> CONFIG_NLS_ISO8859_8=y
> CONFIG_NLS_CODEPAGE_1250=y
> CONFIG_NLS_CODEPAGE_1251=y
> CONFIG_NLS_ASCII=y
> CONFIG_NLS_ISO8859_1=y
> # CONFIG_NLS_ISO8859_2 is not set
> CONFIG_NLS_ISO8859_3=y
> CONFIG_NLS_ISO8859_4=y
> # CONFIG_NLS_ISO8859_5 is not set
> CONFIG_NLS_ISO8859_6=y
> CONFIG_NLS_ISO8859_7=y
> CONFIG_NLS_ISO8859_9=y
> # CONFIG_NLS_ISO8859_13 is not set
> CONFIG_NLS_ISO8859_14=y
> CONFIG_NLS_ISO8859_15=y
> # CONFIG_NLS_KOI8_R is not set
> # CONFIG_NLS_KOI8_U is not set
> # CONFIG_NLS_MAC_ROMAN is not set
> CONFIG_NLS_MAC_CELTIC=y
> # CONFIG_NLS_MAC_CENTEURO is not set
> # CONFIG_NLS_MAC_CROATIAN is not set
> CONFIG_NLS_MAC_CYRILLIC=y
> CONFIG_NLS_MAC_GAELIC=y
> CONFIG_NLS_MAC_GREEK=y
> CONFIG_NLS_MAC_ICELAND=y
> CONFIG_NLS_MAC_INUIT=y
> CONFIG_NLS_MAC_ROMANIAN=y
> CONFIG_NLS_MAC_TURKISH=y
> # CONFIG_NLS_UTF8 is not set
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
> # CONFIG_ENABLE_WARN_DEPRECATED is not set
> CONFIG_ENABLE_MUST_CHECK=y
> CONFIG_FRAME_WARN=1024
> CONFIG_STRIP_ASM_SYMS=y
> CONFIG_READABLE_ASM=y
> CONFIG_UNUSED_SYMBOLS=y
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
> # CONFIG_DEBUG_OBJECTS is not set
> CONFIG_HAVE_DEBUG_KMEMLEAK=y
> # CONFIG_DEBUG_KMEMLEAK is not set
> # CONFIG_DEBUG_STACK_USAGE is not set
> # CONFIG_DEBUG_VM is not set
> CONFIG_DEBUG_VIRTUAL=y
> CONFIG_DEBUG_MEMORY_INIT=y
> CONFIG_DEBUG_HIGHMEM=y
> CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
> # CONFIG_DEBUG_STACKOVERFLOW is not set
> CONFIG_HAVE_ARCH_KMEMCHECK=y
> CONFIG_DEBUG_SHIRQ=y
>
> #
> # Debug Lockups and Hangs
> #
> # CONFIG_LOCKUP_DETECTOR is not set
> # CONFIG_DETECT_HUNG_TASK is not set
> # CONFIG_PANIC_ON_OOPS is not set
> CONFIG_PANIC_ON_OOPS_VALUE=0
> CONFIG_PANIC_TIMEOUT=0
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
> CONFIG_PROVE_LOCKING=y
> CONFIG_LOCKDEP=y
> CONFIG_LOCK_STAT=y
> # CONFIG_DEBUG_LOCKDEP is not set
> CONFIG_DEBUG_ATOMIC_SLEEP=y
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> CONFIG_LOCK_TORTURE_TEST=y
> CONFIG_TRACE_IRQFLAGS=y
> CONFIG_STACKTRACE=y
> # CONFIG_DEBUG_KOBJECT is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> # CONFIG_DEBUG_LIST is not set
> CONFIG_DEBUG_SG=y
> CONFIG_DEBUG_NOTIFIERS=y
> # CONFIG_DEBUG_CREDENTIALS is not set
>
> #
> # RCU Debugging
> #
> # CONFIG_PROVE_RCU is not set
> # CONFIG_SPARSE_RCU_POINTER is not set
> CONFIG_TORTURE_TEST=y
> # CONFIG_RCU_TORTURE_TEST is not set
> # CONFIG_RCU_TRACE is not set
> CONFIG_NOTIFIER_ERROR_INJECTION=y
> CONFIG_FAULT_INJECTION=y
> CONFIG_FAIL_PAGE_ALLOC=y
> # CONFIG_FAULT_INJECTION_DEBUG_FS is not set
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
> # CONFIG_IRQSOFF_TRACER is not set
> # CONFIG_SCHED_TRACER is not set
> CONFIG_FTRACE_SYSCALLS=y
> # CONFIG_TRACER_SNAPSHOT is not set
> CONFIG_BRANCH_PROFILE_NONE=y
> # CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
> # CONFIG_PROFILE_ALL_BRANCHES is not set
> CONFIG_STACK_TRACER=y
> CONFIG_UPROBE_EVENT=y
> CONFIG_PROBE_EVENTS=y
> # CONFIG_DYNAMIC_FTRACE is not set
> CONFIG_FUNCTION_PROFILER=y
> # CONFIG_FTRACE_STARTUP_TEST is not set
> CONFIG_MMIOTRACE=y
> CONFIG_RING_BUFFER_BENCHMARK=y
> # CONFIG_RING_BUFFER_STARTUP_TEST is not set
>
> #
> # Runtime Testing
> #
> # CONFIG_TEST_LIST_SORT is not set
> # CONFIG_BACKTRACE_SELF_TEST is not set
> CONFIG_RBTREE_TEST=y
> CONFIG_ATOMIC64_SELFTEST=y
> CONFIG_TEST_STRING_HELPERS=y
> CONFIG_TEST_KSTRTOX=y
> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> # CONFIG_BUILD_DOCSRC is not set
> # CONFIG_DMA_API_DEBUG is not set
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_KGDB is not set
> CONFIG_STRICT_DEVMEM=y
> CONFIG_X86_VERBOSE_BOOTUP=y
> # CONFIG_EARLY_PRINTK is not set
> CONFIG_X86_PTDUMP=y
> # CONFIG_DEBUG_RODATA is not set
> # CONFIG_DOUBLEFAULT is not set
> CONFIG_DEBUG_TLBFLUSH=y
> # CONFIG_IOMMU_STRESS is not set
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
> # CONFIG_DEBUG_BOOT_PARAMS is not set
> # CONFIG_CPA_DEBUG is not set
> # CONFIG_OPTIMIZE_INLINING is not set
> CONFIG_X86_DEBUG_STATIC_CPU_HAS=y
>
> #
> # Security options
> #
> CONFIG_KEYS=y
> # CONFIG_PERSISTENT_KEYRINGS is not set
> CONFIG_ENCRYPTED_KEYS=y
> # CONFIG_KEYS_DEBUG_PROC_KEYS is not set
> # CONFIG_SECURITY_DMESG_RESTRICT is not set
> CONFIG_SECURITY=y
> CONFIG_SECURITYFS=y
> # CONFIG_SECURITY_NETWORK is not set
> # CONFIG_SECURITY_PATH is not set
> # CONFIG_SECURITY_TOMOYO is not set
> # CONFIG_SECURITY_APPARMOR is not set
> # CONFIG_SECURITY_YAMA is not set
> CONFIG_INTEGRITY=y
> # CONFIG_INTEGRITY_SIGNATURE is not set
> # CONFIG_IMA is not set
> CONFIG_EVM=y
> CONFIG_EVM_HMAC_VERSION=2
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
> # CONFIG_CRYPTO_CCM is not set
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
> # CONFIG_CRYPTO_PCBC is not set
> CONFIG_CRYPTO_XTS=y
>
> #
> # Hash modes
> #
> # CONFIG_CRYPTO_CMAC is not set
> CONFIG_CRYPTO_HMAC=y
> CONFIG_CRYPTO_XCBC=y
> # CONFIG_CRYPTO_VMAC is not set
>
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=y
> # CONFIG_CRYPTO_CRC32C_INTEL is not set
> CONFIG_CRYPTO_CRC32=y
> CONFIG_CRYPTO_CRC32_PCLMUL=y
> # CONFIG_CRYPTO_CRCT10DIF is not set
> CONFIG_CRYPTO_GHASH=y
> CONFIG_CRYPTO_MD4=y
> CONFIG_CRYPTO_MD5=y
> CONFIG_CRYPTO_MICHAEL_MIC=y
> CONFIG_CRYPTO_RMD128=y
> # CONFIG_CRYPTO_RMD160 is not set
> CONFIG_CRYPTO_RMD256=y
> CONFIG_CRYPTO_RMD320=y
> CONFIG_CRYPTO_SHA1=y
> CONFIG_CRYPTO_SHA256=y
> # CONFIG_CRYPTO_SHA512 is not set
> # CONFIG_CRYPTO_TGR192 is not set
> CONFIG_CRYPTO_WP512=y
>
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> CONFIG_CRYPTO_AES_586=y
> # CONFIG_CRYPTO_AES_NI_INTEL is not set
> CONFIG_CRYPTO_ANUBIS=y
> CONFIG_CRYPTO_ARC4=y
> CONFIG_CRYPTO_BLOWFISH=y
> CONFIG_CRYPTO_BLOWFISH_COMMON=y
> # CONFIG_CRYPTO_CAMELLIA is not set
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
> # CONFIG_CRYPTO_DEFLATE is not set
> CONFIG_CRYPTO_ZLIB=y
> CONFIG_CRYPTO_LZO=y
> # CONFIG_CRYPTO_LZ4 is not set
> CONFIG_CRYPTO_LZ4HC=y
>
> #
> # Random Number Generation
> #
> CONFIG_CRYPTO_ANSI_CPRNG=y
> # CONFIG_CRYPTO_USER_API_HASH is not set
> # CONFIG_CRYPTO_USER_API_SKCIPHER is not set
> CONFIG_CRYPTO_HASH_INFO=y
> CONFIG_CRYPTO_HW=y
> CONFIG_CRYPTO_DEV_PADLOCK=y
> CONFIG_CRYPTO_DEV_PADLOCK_AES=y
> # CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
> # CONFIG_CRYPTO_DEV_GEODE is not set
> CONFIG_CRYPTO_DEV_HIFN_795X=y
> CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
> # CONFIG_CRYPTO_DEV_CCP is not set
> CONFIG_ASYMMETRIC_KEY_TYPE=y
> CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
> CONFIG_PUBLIC_KEY_ALGO_RSA=y
> CONFIG_X509_CERTIFICATE_PARSER=y
> CONFIG_HAVE_KVM=y
> CONFIG_VIRTUALIZATION=y
> # CONFIG_KVM is not set
> # CONFIG_LGUEST is not set
> CONFIG_BINARY_PRINTF=y
>
> #
> # Library routines
> #
> CONFIG_BITREVERSE=y
> CONFIG_RATIONAL=y
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
> # CONFIG_CRC_T10DIF is not set
> CONFIG_CRC_ITU_T=y
> CONFIG_CRC32=y
> CONFIG_CRC32_SELFTEST=y
> # CONFIG_CRC32_SLICEBY8 is not set
> # CONFIG_CRC32_SLICEBY4 is not set
> # CONFIG_CRC32_SARWATE is not set
> CONFIG_CRC32_BIT=y
> # CONFIG_CRC7 is not set
> CONFIG_LIBCRC32C=y
> CONFIG_CRC8=y
> # CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
> CONFIG_RANDOM32_SELFTEST=y
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_LZO_COMPRESS=y
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_LZ4HC_COMPRESS=y
> CONFIG_LZ4_DECOMPRESS=y
> CONFIG_XZ_DEC=y
> CONFIG_XZ_DEC_X86=y
> CONFIG_XZ_DEC_POWERPC=y
> CONFIG_XZ_DEC_IA64=y
> # CONFIG_XZ_DEC_ARM is not set
> CONFIG_XZ_DEC_ARMTHUMB=y
> CONFIG_XZ_DEC_SPARC=y
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
> CONFIG_CHECK_SIGNATURE=y
> CONFIG_DQL=y
> CONFIG_NLATTR=y
> CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
> # CONFIG_AVERAGE is not set
> CONFIG_CLZ_TAB=y
> CONFIG_CORDIC=y
> CONFIG_DDR=y
> CONFIG_MPILIB=y
> CONFIG_OID_REGISTRY=y
>
> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Jani Nikula, Intel Open Source Technology Center
