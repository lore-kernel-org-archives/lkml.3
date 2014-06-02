Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaFBH0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 03:26:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:3478 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbaFBH0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 03:26:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,955,1392192000"; 
   d="log'?scan'208";a="541090657"
Date: Mon, 2 Jun 2014 15:26:07 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jet Chen <jet.chen@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [drm] INFO: possible recursive locking detected
Message-ID: <20140602072607.GA9088@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <20140602065357.GA8851@localhost>
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jesse,

Here is another warning message introduced by the same commit:

git://people.freedesktop.org/~jbarnes/linux async-fb-probe
commit b739c9982801e5f76097311b67dfd76891b10988
Author:     Jesse Barnes <jbarnes@virtuousgeek.org>
AuthorDate: Wed May 28 10:21:17 2014 -0700
Commit:     Jesse Barnes <jbarnes@virtuousgeek.org>
CommitDate: Wed May 28 12:17:34 2014 -0700

    drm: take modeset locks around initial fb helper probing
    
    Drivers ought to complain otherwise.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

+------------------------------------------+------------+------------+------------------+
|                                          | 071f9c57ee | b739c99828 | v3.15-rc8_060210 |
+------------------------------------------+------------+------------+------------------+
| boot_successes                           | 60         | 0          | 0                |
| boot_failures                            | 0          | 20         | 13               |
| INFO:possible_recursive_locking_detected | 0          | 20         | 13               |
| BUG:kernel_boot_hang                     | 0          | 20         | 13               |
| backtrace:drm_fb_helper_initial_config   | 0          | 20         | 13               |
| backtrace:cirrus_fbdev_init              | 0          | 20         | 13               |
| backtrace:cirrus_modeset_init            | 0          | 20         | 13               |
| backtrace:__pci_register_driver          | 0          | 20         | 13               |
| backtrace:drm_pci_init                   | 0          | 20         | 13               |
| backtrace:cirrus_init                    | 0          | 20         | 13               |
| backtrace:kernel_init_freeable           | 0          | 20         | 13               |
+------------------------------------------+------------+------------+------------------+

[    3.631605] [TTM] Initializing DMA pool allocator
[    3.633678] 
[    3.634003] =============================================
[    3.634003] [ INFO: possible recursive locking detected ]
[    3.634003] 3.15.0-rc5-00090-gb739c99 #1 Not tainted
[    3.634003] ---------------------------------------------
[    3.634003] swapper/0/1 is trying to acquire lock:
[    3.634003]  (&dev->mode_config.mutex){+.+.+.}, at: [<ffffffff81919245>] drm_modeset_lock_all+0x35/0x80
[    3.634003] 
[    3.634003] but task is already holding lock:
[    3.634003]  (&dev->mode_config.mutex){+.+.+.}, at: [<ffffffff81903a19>] drm_fb_helper_initial_config+0x119/0x730
[    3.634003] 
[    3.634003] other info that might help us debug this:
[    3.634003]  Possible unsafe locking scenario:
[    3.634003] 
[    3.634003]        CPU0
[    3.634003]        ----
[    3.634003]   lock(&dev->mode_config.mutex);
[    3.634003]   lock(&dev->mode_config.mutex);
[    3.634003] 
[    3.634003]  *** DEADLOCK ***
[    3.634003] 
[    3.634003]  May be due to missing lock nesting notation
[    3.634003] 
[    3.634003] 4 locks held by swapper/0/1:
[    3.634003]  #0:  (&dev->mutex){......}, at: [<ffffffff81b63363>] __driver_attach+0x73/0x100
[    3.634003]  #1:  (&dev->mutex){......}, at: [<ffffffff81b63379>] __driver_attach+0x89/0x100
[    3.634003]  #2:  (drm_global_mutex){+.+.+.}, at: [<ffffffff8191278a>] drm_dev_register+0x2a/0x1c0
[    3.634003]  #3:  (&dev->mode_config.mutex){+.+.+.}, at: [<ffffffff81903a19>] drm_fb_helper_initial_config+0x119/0x730
[    3.634003] 
[    3.634003] stack backtrace:
[    3.634003] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc5-00090-gb739c99 #1
[    3.634003] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.634003]  ffff8800121807a8 ffff8800121839e8 ffffffff82752935 ffff880012180010
[    3.634003]  ffff880012183a58 ffffffff8113c027 0000000000000000 ffff8800121807a8
[    3.634003]  ffff880012183a78 ffffffff00000000 27e13f0d1869834c 0000000000000a00
[    3.634003] Call Trace:
[    3.634003]  [<ffffffff82752935>] dump_stack+0x85/0xba
[    3.634003]  [<ffffffff8113c027>] __lock_acquire+0x1f37/0x22c0
[    3.634003]  [<ffffffff8113c49b>] lock_acquire+0xeb/0x1c0
[    3.634003]  [<ffffffff81919245>] ? drm_modeset_lock_all+0x35/0x80
[    3.634003]  [<ffffffff8276ad35>] mutex_lock_nested+0x85/0x600
[    3.634003]  [<ffffffff81919245>] ? drm_modeset_lock_all+0x35/0x80
[    3.634003]  [<ffffffff811378ad>] ? trace_hardirqs_on+0x1d/0x30
[    3.634003]  [<ffffffff81903a19>] ? drm_fb_helper_initial_config+0x119/0x730
[    3.634003]  [<ffffffff8171a24b>] ? fb_get_options+0x2b/0x240
[    3.634003]  [<ffffffff81919245>] drm_modeset_lock_all+0x35/0x80
[    3.634003]  [<ffffffff81903a29>] drm_fb_helper_initial_config+0x129/0x730
[    3.634003]  [<ffffffff811378ad>] ? trace_hardirqs_on+0x1d/0x30
[    3.634003]  [<ffffffff819192fa>] ? drm_modeset_unlock_all+0x6a/0x80
[    3.634003]  [<ffffffff81a0b42d>] cirrus_fbdev_init+0xcd/0x110
[    3.634003]  [<ffffffff81a0a744>] cirrus_modeset_init+0x234/0x2d0
[    3.634003]  [<ffffffff81a08d46>] cirrus_driver_load+0x96/0x1a0
[    3.634003]  [<ffffffff81912875>] drm_dev_register+0x115/0x1c0
[    3.634003]  [<ffffffff819159e8>] drm_get_pci_dev+0x138/0x320
[    3.634003]  [<ffffffff811378ad>] ? trace_hardirqs_on+0x1d/0x30
[    3.634003]  [<ffffffff81a0a975>] cirrus_pci_probe+0x105/0x140
[    3.634003]  [<ffffffff816c0840>] pci_device_probe+0xe0/0x1c0
[    3.634003]  [<ffffffff81b62e3c>] driver_probe_device+0xcc/0x580
[    3.634003]  [<ffffffff81b633db>] __driver_attach+0xeb/0x100
[    3.634003]  [<ffffffff81b632f0>] ? driver_probe_device+0x580/0x580
[    3.634003]  [<ffffffff81b5ff73>] bus_for_each_dev+0xb3/0x110
[    3.634003]  [<ffffffff81b62976>] driver_attach+0x26/0x30
[    3.634003]  [<ffffffff81b61048>] bus_add_driver+0x208/0x390
[    3.634003]  [<ffffffff83c6f5e0>] ? intel_no_lvds_dmi_callback+0x2b/0x2b
[    3.634003]  [<ffffffff81b63a70>] driver_register+0xb0/0x1a0
[    3.634003]  [<ffffffff83c6f5e0>] ? intel_no_lvds_dmi_callback+0x2b/0x2b
[    3.634003]  [<ffffffff816c098d>] __pci_register_driver+0x6d/0x80
[    3.634003]  [<ffffffff81915d19>] drm_pci_init+0x149/0x180
[    3.634003]  [<ffffffff83c6f5e0>] ? intel_no_lvds_dmi_callback+0x2b/0x2b
[    3.634003]  [<ffffffff83c6f643>] cirrus_init+0x63/0x6c
[    3.634003]  [<ffffffff83c085e5>] do_one_initcall+0xe8/0x1cc
[    3.634003]  [<ffffffff81101645>] ? parse_args+0x2a5/0x5c0
[    3.634003]  [<ffffffff83c08893>] kernel_init_freeable+0x1ca/0x2c9
[    3.634003]  [<ffffffff83c07ad7>] ? do_early_param+0xd7/0xd7
[    3.634003]  [<ffffffff8273fde0>] ? rest_init+0x120/0x120
[    3.634003]  [<ffffffff8273fdf6>] kernel_init+0x16/0x1b0
[    3.634003]  [<ffffffff82771dfc>] ret_from_fork+0x7c/0xb0
[    3.634003]  [<ffffffff8273fde0>] ? rest_init+0x120/0x120
[   61.168100] spin_lock-torture: Writes:  Total: 4  Max/Min: 0/0   Fail: 0 
[  121.169074] spin_lock-torture: Writes:  Total: 4  Max/Min: 0/0   Fail: 0 
[  181.170111] spin_lock-torture: Writes:  Total: 4  Max/Min: 0/0   Fail: 0 

git bisect start 5dba024fe84a491ec3ca15193923fcbb938e68f7 fad01e866afdbe01a1f3ec06a39c3a8b9e197014 --
git bisect good 12072cdd5c9b56bb6d4169c5a52c9d0bf64b7f84  # 12:04     19+      0  Merge 'gxt/unicore32' into devel-hourly-2014060210
git bisect good eb1a12ad1d5a7312a6f3dc6a8b77c51cbe58641e  # 12:10     19+      0  Merge 'luto/auditsc-lite' into devel-hourly-2014060210
git bisect good d641155270aff21eacd2622e30129cd91fe8d2d2  # 12:23     19+      0  Merge 'wsa/i2c/for-next' into devel-hourly-2014060210
git bisect good 002fa82dac6f0be486333e6424968c0c42c0e799  # 12:30     19+      0  Merge 'jbarnes/async' into devel-hourly-2014060210
git bisect  bad 1ea52a9605be1234b7da3e4d134917c7ba3be93d  # 12:57      0-     19  Merge 'jbarnes/async-fb-probe' into devel-hourly-2014060210
git bisect  bad f728080d6bac47aab2d570492acef88317ac8e03  # 13:52      0-     15  drm/i915: make fbdev initialization asynchronous v2
git bisect  bad b739c9982801e5f76097311b67dfd76891b10988  # 14:13      0-      5  drm: take modeset locks around initial fb helper probing
# first bad commit: [b739c9982801e5f76097311b67dfd76891b10988] drm: take modeset locks around initial fb helper probing
git bisect good 071f9c57eea4876288ba1254c9ac3b0f077c2dd6  # 14:30     60+      0  drm/i915/vlv: enable PPGTT
git bisect  bad 5dba024fe84a491ec3ca15193923fcbb938e68f7  # 14:30      0-     13  0day head guard for 'devel-hourly-2014060210'
git bisect good fad01e866afdbe01a1f3ec06a39c3a8b9e197014  # 14:42     60+      1  Linux 3.15-rc8
git bisect good 322c030f5462a44ce42f8804284eb52b7cd2ba41  # 14:55     60+      7  Add linux-next specific files for 20140530


This script may reproduce the error.

-----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=quantal-core-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/$initrd

kvm=(
	qemu-system-x86_64 -cpu kvm64 -enable-kvm 
	-kernel $kernel
	-initrd $initrd
	-smp 2
	-m 256M
	-net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio
	-net user,vlan=0
	-net nic,vlan=1,model=e1000
	-net user,vlan=1
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-serial stdio
	-display none
	-monitor null
)

append=(
	debug
	sched_debug
	apic=debug
	ignore_loglevel
	sysrq_always_enabled
	panic=10
	prompt_ramdisk=0
	earlyprintk=ttyS0,115200
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
)

"${kvm[@]}" --append "${append[*]}"
-----------------------------------------------------------------------------

Thanks,
Fengguang

--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-ivb43-29:20140602141427:x86_64-randconfig-hsxa0-06021100:3.15.0-rc5-00090-gb739c99:1"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Linux version 3.15.0-rc5-00090-gb739c99 (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP Mon Jun 2 13:57:59 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-06021100/linux-dev=
el:devel-hourly-2014060210:b739c9982801e5f76097311b67dfd76891b10988:bisect-=
linux6/.vmlinuz-b739c9982801e5f76097311b67dfd76891b10988-20140602135829-14-=
ivb43 branch=3Dlinux-devel/devel-hourly-2014060210 BOOT_IMAGE=3D/kernel/x86=
_64-randconfig-hsxa0-06021100/b739c9982801e5f76097311b67dfd76891b10988/vmli=
nuz-3.15.0-rc5-00090-gb739c99 drbd.minor_count=3D8
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
[    0.000000] No AGP bridge found
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
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0502a000, 0x0502afff] PGTABLE
[    0.000000] BRK [0x0502b000, 0x0502bfff] PGTABLE
[    0.000000] BRK [0x0502c000, 0x0502cfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
[    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x0502d000, 0x0502dfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
[    0.000000] ACPI: RSDP 0x00000000000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE450 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE490 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF680 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF640 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880011a0000=
0-ffff880011ffffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1064 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
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
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880012600000 s82048 r0 d2=
4448 u1048576
[    0.000000] pcpu-alloc: s82048 r0 d24448 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1260cec0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80679
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-06021100/li=
nux-devel:devel-hourly-2014060210:b739c9982801e5f76097311b67dfd76891b10988:=
bisect-linux6/.vmlinuz-b739c9982801e5f76097311b67dfd76891b10988-20140602135=
829-14-ivb43 branch=3Dlinux-devel/devel-hourly-2014060210 BOOT_IMAGE=3D/ker=
nel/x86_64-randconfig-hsxa0-06021100/b739c9982801e5f76097311b67dfd76891b109=
88/vmlinuz-3.15.0-rc5-00090-gb739c99 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 230480K/327280K available (24025K kernel code, 8130K=
 rwdata, 11460K rodata, 1904K init, 18760K bss, 96800K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Linux version 3.15.0-rc5-00090-gb739c99 (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP Mon Jun 2 13:57:59 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-06021100/linux-dev=
el:devel-hourly-2014060210:b739c9982801e5f76097311b67dfd76891b10988:bisect-=
linux6/.vmlinuz-b739c9982801e5f76097311b67dfd76891b10988-20140602135829-14-=
ivb43 branch=3Dlinux-devel/devel-hourly-2014060210 BOOT_IMAGE=3D/kernel/x86=
_64-randconfig-hsxa0-06021100/b739c9982801e5f76097311b67dfd76891b10988/vmli=
nuz-3.15.0-rc5-00090-gb739c99 drbd.minor_count=3D8
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
[    0.000000] No AGP bridge found
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
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0502a000, 0x0502afff] PGTABLE
[    0.000000] BRK [0x0502b000, 0x0502bfff] PGTABLE
[    0.000000] BRK [0x0502c000, 0x0502cfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
[    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x0502d000, 0x0502dfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
[    0.000000] ACPI: RSDP 0x00000000000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE450 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE490 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF680 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF640 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880011a0000=
0-ffff880011ffffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1064 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
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
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880012600000 s82048 r0 d2=
4448 u1048576
[    0.000000] pcpu-alloc: s82048 r0 d24448 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1260cec0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80679
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-06021100/li=
nux-devel:devel-hourly-2014060210:b739c9982801e5f76097311b67dfd76891b10988:=
bisect-linux6/.vmlinuz-b739c9982801e5f76097311b67dfd76891b10988-20140602135=
829-14-ivb43 branch=3Dlinux-devel/devel-hourly-2014060210 BOOT_IMAGE=3D/ker=
nel/x86_64-randconfig-hsxa0-06021100/b739c9982801e5f76097311b67dfd76891b109=
88/vmlinuz-3.15.0-rc5-00090-gb739c99 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 230480K/327280K available (24025K kernel code, 8130K=
 rwdata, 11460K rodata, 1904K init, 18760K bss, 96800K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
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
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
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
[    0.000000]                ww contexts mixing:  ok  |  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]            spinlock nest unlocked:  ok  |
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:  ok  |  ok  |  ok  |
[    0.000000]                               try:  ok  |  ok  |  ok  |
[    0.000000]                             block:  ok  |  ok  |  ok  |
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ODEBUG: 9 of 9 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.614 MHz processor
[    0.004000] Calibrating delay loop (skipped) preset value.. 5387.22 Bogo=
MIPS (lpj=3D2693614)
[    0.005010] pid_max: default: 32768 minimum: 301
[    0.006060] ACPI: Core revision 20140214
[    0.010752] ACPI: All ACPI Tables successfully acquired
[    0.011860] Security Framework initialized
[    0.012014] Yama: becoming mindful.
[    0.013081] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.014011] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.016392] mce: CPU supports 10 MCE banks
[    0.017053] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.017053] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.017053] tlb_flushall_shift: 6
[    0.018308] Freeing SMP alternatives memory: 36K (ffffffff83dce000 - fff=
fffff83dd7000)
[    0.023322] ftrace: allocating 55197 entries in 216 pages
[    0.036345] Getting VERSION: 50014
[    0.037021] Getting VERSION: 50014
[    0.038008] Getting ID: 0
[    0.038572] Getting ID: ff000000
[    0.039011] Getting LVT0: 8700
[    0.040007] Getting LVT1: 8400
[    0.040635] enabled ExtINT on CPU#0
[    0.042380] ENABLING IO-APIC IRQs
[    0.043007] init IO_APIC IRQs
[    0.043606]  apic 0 pin 0 not connected
[    0.044025] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.045027] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.046025] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.047024] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.048024] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.049029] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.051038] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.052030] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.053023] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.054024] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.055024] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.056023] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.057038] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.058024] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.059031] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.060020]  apic 0 pin 16 not connected
[    0.061005]  apic 0 pin 17 not connected
[    0.062005]  apic 0 pin 18 not connected
[    0.062702]  apic 0 pin 19 not connected
[    0.063008]  apic 0 pin 20 not connected
[    0.064009]  apic 0 pin 21 not connected
[    0.064723]  apic 0 pin 22 not connected
[    0.065005]  apic 0 pin 23 not connected
[    0.066149] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.067005] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.069005] Using local APIC timer interrupts.
[    0.069005] calibrating APIC timer ...
[    0.071000] ... lapic delta =3D 6312235
[    0.071000] ... PM-Timer delta =3D 361543
[    0.071000] APIC calibration not consistent with PM-Timer: 101ms instead=
 of 100ms
[    0.071000] APIC delta adjusted to PM-Timer: 6249574 (6312235)
[    0.071000] TSC delta adjusted to PM-Timer: 269347515 (272048109)
[    0.071000] ..... delta 6249574
[    0.071000] ..... mult: 268417159
[    0.071000] ..... calibration result: 999931
[    0.071000] ..... CPU clock speed is 2693.0475 MHz.
[    0.071000] ..... host bus clock speed is 999.0931 MHz.
[    0.071070] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.073554] ftrace: Allocated trace_printk buffers
[    0.078132] x86: Booting SMP configuration:
[    0.078939] .... node  #0, CPUs:      #1
[    0.077600] kvm-clock: cpu 1, msr 0:13ffd041, secondary cpu clock
[    0.077600] masked ExtINT on CPU#1
[    0.092067] KVM setup async PF for cpu 1
[    0.092109] x86: Booted up 1 node, 2 CPUs
[    0.092112] smpboot: Total of 2 processors activated (10774.45 BogoMIPS)
[    0.093000] kvm-stealtime: cpu 1, msr 1270cec0
[    0.098309] devtmpfs: initialized
[    0.102238] gcov: version magic: 0x3430382a
[    0.105149] evm: security.ima
[    0.105750] evm: security.capability
[    0.108275] regulator-dummy: no parameters
[    0.109433] NET: Registered protocol family 16
[    0.110708] cpuidle: using governor menu
[    0.112056] ACPI: bus type PCI registered
[    0.112762] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.114021] dca service started, version 1.12.1
[    0.114888] PCI: Using configuration type 1 for base access
[    0.132266] gpio-f7188x: Not a Fintek device at 0x0000002e
[    0.133038] gpio-f7188x: Not a Fintek device at 0x0000004e
[    0.134181] ACPI: Added _OSI(Module Device)
[    0.135006] ACPI: Added _OSI(Processor Device)
[    0.136006] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.137005] ACPI: Added _OSI(Processor Aggregator Device)
[    0.143978] ACPI: Interpreter enabled
[    0.144016] ACPI: (supports S0 S5)
[    0.145005] ACPI: Using IOAPIC for interrupt routing
[    0.146042] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.156968] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.157015] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MS=
I]
[    0.159004] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.160371] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.161469] acpiphp: Slot [3] registered
[    0.162073] acpiphp: Slot [4] registered
[    0.163094] acpiphp: Slot [5] registered
[    0.163856] acpiphp: Slot [6] registered
[    0.164071] acpiphp: Slot [7] registered
[    0.165083] acpiphp: Slot [8] registered
[    0.166071] acpiphp: Slot [9] registered
[    0.167005] acpiphp: Slot [10] registered
[    0.167816] acpiphp: Slot [11] registered
[    0.168072] acpiphp: Slot [12] registered
[    0.169091] acpiphp: Slot [13] registered
[    0.170080] acpiphp: Slot [14] registered
[    0.170862] acpiphp: Slot [15] registered
[    0.171257] acpiphp: Slot [24] registered
[    0.172087] acpiphp: Slot [25] registered
[    0.173072] acpiphp: Slot [26] registered
[    0.174070] acpiphp: Slot [27] registered
[    0.175099] acpiphp: Slot [28] registered
[    0.175906] acpiphp: Slot [29] registered
[    0.176070] acpiphp: Slot [30] registered
[    0.177087] acpiphp: Slot [31] registered
[    0.178017] PCI host bridge to bus 0000:00
[    0.178729] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.179007] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.180006] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.181006] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.182006] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.183043] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.185222] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.186707] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.190007] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.191696] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.192006] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.193005] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.194005] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.196248] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.197378] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.198016] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.200237] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.203057] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.205052] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.213046] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.214786] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.216439] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.218432] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.223432] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.224359] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.226237] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.230433] pci_bus 0000:00: on NUMA node 0
[    0.232155] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.233604] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.235124] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.236597] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.237780] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.239762] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.241616] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.242007] vgaarb: loaded
[    0.242575] vgaarb: bridge control possible 0000:00:02.0
[    0.244587] ACPI: bus type USB registered
[    0.245093] usbcore: registered new interface driver usbfs
[    0.246041] usbcore: registered new interface driver hub
[    0.247057] usbcore: registered new device driver usb
[    0.248138] pps_core: LinuxPPS API ver. 1 registered
[    0.249004] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.250021] PTP clock support registered
[    0.251222] wmi: Mapper loaded
[    0.252187] Advanced Linux Sound Architecture Driver Initialized.
[    0.253039] PCI: Using ACPI for IRQ routing
[    0.253767] PCI: pci_cache_line_size set to 64 bytes
[    0.254129] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.255019] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.257494] NET: Registered protocol family 8
[    0.258010] NET: Registered protocol family 20
[    0.259680] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.260028] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.262005] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.266138] Switched to clocksource kvm-clock
[    0.305838] pnp: PnP ACPI init
[    0.306572] ACPI: bus type PNP registered
[    0.307420] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.308930] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.310027] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.311522] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.312568] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.314062] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.315159] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.316573] pnp 00:03: [dma 2]
[    0.317274] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.318377] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.319809] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.320939] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.322397] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.323501] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:3)
[    0.324938] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.326299] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.327542] pnp: PnP ACPI: found 8 devices
[    0.328278] ACPI: bus type PNP unregistered
[    0.345953] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.346902] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.347780] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.348759] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.349799] NET: Registered protocol family 1
[    0.350612] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.351579] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.352521] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.353501] pci 0000:00:02.0: Boot video device
[    0.354335] PCI: CLS 0 bytes, default 64
[    0.355441] Unpacking initramfs...
[    1.127860] Freeing initrd memory: 23244K (ffff88001293d000 - ffff880013=
ff0000)
[    1.132603] Machine check injector initialized
[    1.134731] Scanning for low memory corruption every 60 seconds
[    1.136235] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    1.137795] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    1.139495] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    1.142827] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.143844] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.144819] AVX or AES-NI instructions are not detected.
[    1.145700] AVX instructions are not detected.
[    1.146502] AVX instructions are not detected.
[    1.147265] AVX instructions are not detected.
[    1.148055] AVX instructions are not detected.
[    1.148802] AVX2 or AES-NI instructions are not detected.
[    1.149663] AVX2 instructions are not detected.
[    1.150641] spin_lock-torture:--- Start of test: nwriters_stress=3D4 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    1.153015] spin_lock-torture: Creating torture_shuffle task
[    1.154089] spin_lock-torture: Creating torture_stutter task
[    1.154995] spin_lock-torture: torture_shuffle task started
[    1.155944] spin_lock-torture: Creating lock_torture_writer task
[    1.155976] spin_lock-torture: torture_stutter task started
[    1.157958] spin_lock-torture: Creating lock_torture_writer task
[    1.159048] spin_lock-torture: lock_torture_writer task started
[    1.160108] spin_lock-torture: Creating lock_torture_writer task
[    1.160130] spin_lock-torture: lock_torture_writer task started
[    1.162376] spin_lock-torture: lock_torture_writer task started
[    1.162391] spin_lock-torture: Creating lock_torture_writer task
[    1.164664] spin_lock-torture: Creating lock_torture_stats task
[    1.165637] spin_lock-torture: lock_torture_writer task started
[    1.166655] spin_lock-torture: lock_torture_stats task started
[    1.167228] futex hash table entries: 512 (order: 4, 65536 bytes)
[    2.072549] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.074286] VFS: Disk quotas dquot_6.5.2
[    2.075087] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.076504] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    2.077813] ntfs: driver 2.1.30 [Flags: R/W DEBUG].
[    2.078943] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    2.079849] QNX4 filesystem 0.2.3 registered.
[    2.080629] QNX6 filesystem 1.0.0 registered.
[    2.081599] fuse init (API version 7.23)
[    2.082675] JFS: nTxBlock =3D 1982, nTxLock =3D 15860
[    2.210537] SGI XFS with security attributes, realtime, large block/inod=
e numbers, no debug enabled
[    2.213823] NILFS version 2 loaded
[    2.215530] gfs2: GFS2 installed
[    2.216605] msgmni has been set to 495
[    2.230556] NET: Registered protocol family 38
[    2.231412] Key type asymmetric registered
[    2.232199] Asymmetric key parser 'x509' registered
[    2.233102] io scheduler noop registered (default)
[    2.233907] test_string_helpers: Running tests...
[    2.235214] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    2.236080] crc32: self tests passed, processed 225944 bytes in 147841 n=
sec
[    2.237301] crc32c: CRC_LE_BITS =3D 64
[    2.237972] crc32c: self tests passed, processed 225944 bytes in 74400 n=
sec
[    2.275214] tsc: Refined TSC clocksource calibration: 2693.502 MHz
[    2.433754] crc32_combine: 8373 self tests passed
[    2.629856] crc32c_combine: 8373 self tests passed
[    2.631117] xz_dec_test: module loaded
[    2.631812] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
250 0' and write .xz files to it.
[    2.634177] rbtree testing -> 7482 cycles
[    2.945113] augmented rbtree testing -> 10259 cycles
[    3.369975] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.371057] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    3.372105] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.375356] acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
[    3.376984] rivafb_setup START
[    3.377813] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    3.379050] vmlfb: initializing
[    3.379714] Could not find Carillo Ranch MCH device.
[    3.380767] hgafb: HGA card not detected.
[    3.381515] hgafb: probe of hgafb.0 failed with error -22
[    3.382548] usbcore: registered new interface driver smscufx
[    3.383762] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    3.385134] ACPI: Power Button [PWRF]
[    3.386110] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    3.500896] HDLC line discipline maxframe=3D4096
[    3.501733] N_HDLC line discipline registered.
[    3.502592] r3964: Philips r3964 Driver $Revision: 1.10 $
[    3.503517] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.530383] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    3.538266] serial: Freescale lpuart driver
[    3.539250] Initializing Nozomi driver 2.1d
[    3.540338] SyncLink serial driver $Revision: 4.38 $
[    3.599087] SyncLink serial driver $Revision: 4.38 $, tty major#244
[    3.600657] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    3.601905] ac.o: No PCI boards found.
[    3.602634] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    3.605419] Non-volatile memory driver v1.3
[    3.607188] smapi::smapi_init, ERROR invalid usSmapiID
[    3.608338] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    3.610448] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    3.612407] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    3.613690] Linux agpgart interface v0.103
[    3.617154] SyncLink PC Card driver $Revision: 4.34 $, tty major#242
[    3.619160] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    3.621781] Hangcheck: Using getrawmonotonic().
[    3.623675] [drm] Initialized drm 1.1.0 20060810
[    3.625232] drm/i810 does not support SMP
[    3.628664] [TTM] Zone  kernel: Available graphics memory: 126880 kiB
[    3.630197] [TTM] Initializing pool allocator
[    3.631605] [TTM] Initializing DMA pool allocator
[    3.633678]=20
[    3.634003] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[    3.634003] [ INFO: possible recursive locking detected ]
[    3.634003] 3.15.0-rc5-00090-gb739c99 #1 Not tainted
[    3.634003] ---------------------------------------------
[    3.634003] swapper/0/1 is trying to acquire lock:
[    3.634003]  (&dev->mode_config.mutex){+.+.+.}, at: [<ffffffff81919245>]=
 drm_modeset_lock_all+0x35/0x80
[    3.634003]=20
[    3.634003] but task is already holding lock:
[    3.634003]  (&dev->mode_config.mutex){+.+.+.}, at: [<ffffffff81903a19>]=
 drm_fb_helper_initial_config+0x119/0x730
[    3.634003]=20
[    3.634003] other info that might help us debug this:
[    3.634003]  Possible unsafe locking scenario:
[    3.634003]=20
[    3.634003]        CPU0
[    3.634003]        ----
[    3.634003]   lock(&dev->mode_config.mutex);
[    3.634003]   lock(&dev->mode_config.mutex);
[    3.634003]=20
[    3.634003]  *** DEADLOCK ***
[    3.634003]=20
[    3.634003]  May be due to missing lock nesting notation
[    3.634003]=20
[    3.634003] 4 locks held by swapper/0/1:
[    3.634003]  #0:  (&dev->mutex){......}, at: [<ffffffff81b63363>] __driv=
er_attach+0x73/0x100
[    3.634003]  #1:  (&dev->mutex){......}, at: [<ffffffff81b63379>] __driv=
er_attach+0x89/0x100
[    3.634003]  #2:  (drm_global_mutex){+.+.+.}, at: [<ffffffff8191278a>] d=
rm_dev_register+0x2a/0x1c0
[    3.634003]  #3:  (&dev->mode_config.mutex){+.+.+.}, at: [<ffffffff81903=
a19>] drm_fb_helper_initial_config+0x119/0x730
[    3.634003]=20
[    3.634003] stack backtrace:
[    3.634003] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc5-00090-g=
b739c99 #1
[    3.634003] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.634003]  ffff8800121807a8 ffff8800121839e8 ffffffff82752935 ffff8800=
12180010
[    3.634003]  ffff880012183a58 ffffffff8113c027 0000000000000000 ffff8800=
121807a8
[    3.634003]  ffff880012183a78 ffffffff00000000 27e13f0d1869834c 00000000=
00000a00
[    3.634003] Call Trace:
[    3.634003]  [<ffffffff82752935>] dump_stack+0x85/0xba
[    3.634003]  [<ffffffff8113c027>] __lock_acquire+0x1f37/0x22c0
[    3.634003]  [<ffffffff8113c49b>] lock_acquire+0xeb/0x1c0
[    3.634003]  [<ffffffff81919245>] ? drm_modeset_lock_all+0x35/0x80
[    3.634003]  [<ffffffff8276ad35>] mutex_lock_nested+0x85/0x600
[    3.634003]  [<ffffffff81919245>] ? drm_modeset_lock_all+0x35/0x80
[    3.634003]  [<ffffffff811378ad>] ? trace_hardirqs_on+0x1d/0x30
[    3.634003]  [<ffffffff81903a19>] ? drm_fb_helper_initial_config+0x119/0=
x730
[    3.634003]  [<ffffffff8171a24b>] ? fb_get_options+0x2b/0x240
[    3.634003]  [<ffffffff81919245>] drm_modeset_lock_all+0x35/0x80
[    3.634003]  [<ffffffff81903a29>] drm_fb_helper_initial_config+0x129/0x7=
30
[    3.634003]  [<ffffffff811378ad>] ? trace_hardirqs_on+0x1d/0x30
[    3.634003]  [<ffffffff819192fa>] ? drm_modeset_unlock_all+0x6a/0x80
[    3.634003]  [<ffffffff81a0b42d>] cirrus_fbdev_init+0xcd/0x110
[    3.634003]  [<ffffffff81a0a744>] cirrus_modeset_init+0x234/0x2d0
[    3.634003]  [<ffffffff81a08d46>] cirrus_driver_load+0x96/0x1a0
[    3.634003]  [<ffffffff81912875>] drm_dev_register+0x115/0x1c0
[    3.634003]  [<ffffffff819159e8>] drm_get_pci_dev+0x138/0x320
[    3.634003]  [<ffffffff811378ad>] ? trace_hardirqs_on+0x1d/0x30
[    3.634003]  [<ffffffff81a0a975>] cirrus_pci_probe+0x105/0x140
[    3.634003]  [<ffffffff816c0840>] pci_device_probe+0xe0/0x1c0
[    3.634003]  [<ffffffff81b62e3c>] driver_probe_device+0xcc/0x580
[    3.634003]  [<ffffffff81b633db>] __driver_attach+0xeb/0x100
[    3.634003]  [<ffffffff81b632f0>] ? driver_probe_device+0x580/0x580
[    3.634003]  [<ffffffff81b5ff73>] bus_for_each_dev+0xb3/0x110
[    3.634003]  [<ffffffff81b62976>] driver_attach+0x26/0x30
[    3.634003]  [<ffffffff81b61048>] bus_add_driver+0x208/0x390
[    3.634003]  [<ffffffff83c6f5e0>] ? intel_no_lvds_dmi_callback+0x2b/0x2b
[    3.634003]  [<ffffffff81b63a70>] driver_register+0xb0/0x1a0
[    3.634003]  [<ffffffff83c6f5e0>] ? intel_no_lvds_dmi_callback+0x2b/0x2b
[    3.634003]  [<ffffffff816c098d>] __pci_register_driver+0x6d/0x80
[    3.634003]  [<ffffffff81915d19>] drm_pci_init+0x149/0x180
[    3.634003]  [<ffffffff83c6f5e0>] ? intel_no_lvds_dmi_callback+0x2b/0x2b
[    3.634003]  [<ffffffff83c6f643>] cirrus_init+0x63/0x6c
[    3.634003]  [<ffffffff83c085e5>] do_one_initcall+0xe8/0x1cc
[    3.634003]  [<ffffffff81101645>] ? parse_args+0x2a5/0x5c0
[    3.634003]  [<ffffffff83c08893>] kernel_init_freeable+0x1ca/0x2c9
[    3.634003]  [<ffffffff83c07ad7>] ? do_early_param+0xd7/0xd7
[    3.634003]  [<ffffffff8273fde0>] ? rest_init+0x120/0x120
[    3.634003]  [<ffffffff8273fdf6>] kernel_init+0x16/0x1b0
[    3.634003]  [<ffffffff82771dfc>] ret_from_fork+0x7c/0xb0
[    3.634003]  [<ffffffff8273fde0>] ? rest_init+0x120/0x120
[   61.168100] spin_lock-torture: Writes:  Total: 4  Max/Min: 0/0   Fail: 0=
=20
[  121.169074] spin_lock-torture: Writes:  Total: 4  Max/Min: 0/0   Fail: 0=
=20
[  181.170111] spin_lock-torture: Writes:  Total: 4  Max/Min: 0/0   Fail: 0=
=20
[  241.171059] spin_lock-torture: Writes:  Total: 4  Max/Min: 0/0   Fail: 0=
=20
[  301.172111] spin_lock-torture: Writes:  Total: 4  Max/Min: 0/0   Fail: 0=
=20
[  361.173061] spin_lock-torture: Writes:  Total: 4  Max/Min: 0/0   Fail: 0=
=20
[  421.174067] spin_lock-torture: Writes:  Total: 4  Max/Min: 0/0   Fail: 0=
=20
[  481.175065] spin_lock-torture: Writes:  Total: 4  Max/Min: 0/0   Fail: 0=
=20
[  541.176062] spin_lock-torture: Writes:  Total: 4  Max/Min: 0/0   Fail: 0=
=20
[  601.177225] spin_lock-torture: Writes:  Total: 4  Max/Min: 0/0   Fail: 0=
=20
[  661.178068] spin_lock-torture: Writes:  Total: 4  Max/Min: 0/0   Fail: 0=
=20
[  721.179107] spin_lock-torture: Writes:  Total: 4  Max/Min: 0/0   Fail: 0=
=20
[  781.180061] spin_lock-torture: Writes:  Total: 4  Max/Min: 0/0   Fail: 0=
=20
[  841.181068] spin_lock-torture: Writes:  Total: 4  Max/Min: 0/0   Fail: 0=
=20
[  901.182076] spin_lock-torture: Writes:  Total: 4  Max/Min: 0/0   Fail: 0=
=20

BUG: kernel boot hang
Elapsed time: 905
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-hsxa0-06021100/b739c9982801e5f76097311b67dfd76891b10988/vmlinuz-3.15.0-rc5=
-00090-gb739c99 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 deb=
ug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 p=
anic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 con=
sole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-06021100/linux-devel=
:devel-hourly-2014060210:b739c9982801e5f76097311b67dfd76891b10988:bisect-li=
nux6/.vmlinuz-b739c9982801e5f76097311b67dfd76891b10988-20140602135829-14-iv=
b43 branch=3Dlinux-devel/devel-hourly-2014060210 BOOT_IMAGE=3D/kernel/x86_6=
4-randconfig-hsxa0-06021100/b739c9982801e5f76097311b67dfd76891b10988/vmlinu=
z-3.15.0-rc5-00090-gb739c99 drbd.minor_count=3D8'  -initrd /kernel-tests/in=
itrd/quantal-core-x86_64.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=3De1000 =
-net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=
=3Dlocaltime -pidfile /dev/shm/kboot/pid-quantal-ivb43-29 -serial file:/dev=
/shm/kboot/serial-quantal-ivb43-29 -daemonize -display none -monitor null=
=20

--Kj7319i9nmIyA2yE
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-hsxa0-06021100-5dba024fe84a491ec3ca15193923fcbb938e68f7-INFO:-possible-recursive-locking-detected-102872.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgNWRiYTAyNC4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1o
b3VybHktMjAxNDA2MDIxMCcKZ2l0IGNoZWNrb3V0IGZhZDAxZTg2NmFmZGJlMDFhMWYzZWMw
NmEzOWMzYThiOWUxOTcwMTQKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIxMTAwL2xpbnV4LWRldmVsOmRldmVsLWhvdXJs
eS0yMDE0MDYwMjEwOmZhZDAxZTg2NmFmZGJlMDFhMWYzZWMwNmEzOWMzYThiOWUxOTcwMTQ6
YmlzZWN0LWxpbnV4NgoKMjAxNC0wNi0wMi0xMTo0MDo0NyBmYWQwMWU4NjZhZmRiZTAxYTFm
M2VjMDZhMzljM2E4YjllMTk3MDE0IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIx
MTAwLWZhZDAxZTg2NmFmZGJlMDFhMWYzZWMwNmEzOWMzYThiOWUxOTcwMTQKQ2hlY2sgZm9y
IGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIxMTAwL2Zh
ZDAxZTg2NmFmZGJlMDFhMWYzZWMwNmEzOWMzYThiOWUxOTcwMTQKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmln
LWhzeGEwLTA2MDIxMTAwLWZhZDAxZTg2NmFmZGJlMDFhMWYzZWMwNmEzOWMzYThiOWUxOTcw
MTQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
Ly54ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMC1mYWQwMWU4NjZhZmRiZTAxYTFm
M2VjMDZhMzljM2E4YjllMTk3MDE0Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMC0wNjAyMTEwMC9mYWQwMWU4NjZhZmRiZTAxYTFmM2VjMDZhMzljM2E4YjllMTk3
MDE0L3ZtbGludXotMy4xNS4wLXJjOAoKMjAxNC0wNi0wMi0xMTo0Mzo0NyBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAuLi4uLi4uLgkyCTYJMTEJMTYJMTkgU1VDQ0VTUwoKYmlzZWN0OiBnb29k
IGNvbW1pdCBmYWQwMWU4NjZhZmRiZTAxYTFmM2VjMDZhMzljM2E4YjllMTk3MDE0CmdpdCBi
aXNlY3Qgc3RhcnQgNWRiYTAyNGZlODRhNDkxZWMzY2ExNTE5MzkyM2ZjYmI5MzhlNjhmNyBm
YWQwMWU4NjZhZmRiZTAxYTFmM2VjMDZhMzljM2E4YjllMTk3MDE0IC0tCi9jL2tlcm5lbC10
ZXN0cy9saW5lYXItYmlzZWN0OiBbIi1iIiwgIjVkYmEwMjRmZTg0YTQ5MWVjM2NhMTUxOTM5
MjNmY2JiOTM4ZTY4ZjciLCAiLWciLCAiZmFkMDFlODY2YWZkYmUwMWExZjNlYzA2YTM5YzNh
OGI5ZTE5NzAxNCIsICIvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIiwgIi9jL2Jvb3QtYmlzZWN0L2xpbnV4Ni9vYmotYmlzZWN0Il0KQmlzZWN0aW5nOiAy
MTQ5IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMiBzdGVw
cykKWzEyMDcyY2RkNWM5YjU2YmI2ZDQxNjljNWE1MmM5ZDBiZjY0YjdmODRdIE1lcmdlICdn
eHQvdW5pY29yZTMyJyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDYwMjEwCnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2Vj
dC9saW51eDYvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDAvbGludXgtZGV2ZWw6ZGV2ZWwtaG91
cmx5LTIwMTQwNjAyMTA6MTIwNzJjZGQ1YzliNTZiYjZkNDE2OWM1YTUyYzlkMGJmNjRiN2Y4
NDpiaXNlY3QtbGludXg2CgoyMDE0LTA2LTAyLTExOjUwOjE5IDEyMDcyY2RkNWM5YjU2YmI2
ZDQxNjljNWE1MmM5ZDBiZjY0YjdmODQgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRv
IC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYw
MjExMDAtMTIwNzJjZGQ1YzliNTZiYjZkNDE2OWM1YTUyYzlkMGJmNjRiN2Y4NApDaGVjayBm
b3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDAv
MTIwNzJjZGQ1YzliNTZiYjZkNDE2OWM1YTUyYzlkMGJmNjRiN2Y4NAp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDYwMjExMDAtMTIwNzJjZGQ1YzliNTZiYjZkNDE2OWM1YTUyYzlkMGJmNjRi
N2Y4NAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUvLng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIxMTAwLTEyMDcyY2RkNWM5YjU2YmI2
ZDQxNjljNWE1MmM5ZDBiZjY0YjdmODQKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWhzeGEwLTA2MDIxMTAwLzEyMDcyY2RkNWM5YjU2YmI2ZDQxNjljNWE1MmM5ZDBiZjY0
YjdmODQvdm1saW51ei0zLjE1LjAtcmM4LTAxNTIyLWcxMjA3MmNkCgoyMDE0LTA2LTAyLTEx
OjU3OjE5IGRldGVjdGluZyBib290IHN0YXRlIC4uLi4uLi4uLgkxCTYJMTEJMTUJMTkgU1VD
Q0VTUwoKQmlzZWN0aW5nOiA2MjcgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlz
IChyb3VnaGx5IDEwIHN0ZXBzKQpbZWIxYTEyYWQxZDVhNzMxMmE2ZjNkYzZhOGI3N2M1MWNi
ZTU4NjQxZV0gTWVyZ2UgJ2x1dG8vYXVkaXRzYy1saXRlJyBpbnRvIGRldmVsLWhvdXJseS0y
MDE0MDYwMjEwCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDYvb2JqLWJpc2VjdApscyAtYSAva2J1aWxk
LXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDAv
bGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNjAyMTA6ZWIxYTEyYWQxZDVhNzMxMmE2
ZjNkYzZhOGI3N2M1MWNiZTU4NjQxZTpiaXNlY3QtbGludXg2CgoyMDE0LTA2LTAyLTEyOjA0
OjIwIGViMWExMmFkMWQ1YTczMTJhNmYzZGM2YThiNzdjNTFjYmU1ODY0MWUgY29tcGlsaW5n
ClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0
LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDAtZWIxYTEyYWQxZDVhNzMxMmE2ZjNkYzZhOGI3
N2M1MWNiZTU4NjQxZQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaHN4YTAtMDYwMjExMDAvZWIxYTEyYWQxZDVhNzMxMmE2ZjNkYzZhOGI3N2M1MWNi
ZTU4NjQxZQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQt
cXVldWUveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDAtZWIxYTEyYWQxZDVhNzMx
MmE2ZjNkYzZhOGI3N2M1MWNiZTU4NjQxZQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIx
MTAwLWViMWExMmFkMWQ1YTczMTJhNmYzZGM2YThiNzdjNTFjYmU1ODY0MWUKa2VybmVsOiAv
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIxMTAwL2ViMWExMmFkMWQ1YTcz
MTJhNmYzZGM2YThiNzdjNTFjYmU1ODY0MWUvdm1saW51ei0zLjE1LjAtcmM4LTAxOTMxLWdl
YjFhMTJhZAoKMjAxNC0wNi0wMi0xMjowNzoyMCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4u
CTE3CTE5IFNVQ0NFU1MKCkJpc2VjdGluZzogMjE4IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3Qg
YWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpbZDY0MTE1NTI3MGFmZjIxZWFjZDI2MjJl
MzAxMjljZDkxZmU4ZDJkMl0gTWVyZ2UgJ3dzYS9pMmMvZm9yLW5leHQnIGludG8gZGV2ZWwt
aG91cmx5LTIwMTQwNjAyMTAKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4Ni9vYmotYmlzZWN0CmxzIC1h
IC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0w
NjAyMTEwMC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA2MDIxMDpkNjQxMTU1Mjcw
YWZmMjFlYWNkMjYyMmUzMDEyOWNkOTFmZThkMmQyOmJpc2VjdC1saW51eDYKCjIwMTQtMDYt
MDItMTI6MTA6MjAgZDY0MTE1NTI3MGFmZjIxZWFjZDI2MjJlMzAxMjljZDkxZmU4ZDJkMiBj
b21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMC1kNjQxMTU1MjcwYWZmMjFlYWNk
MjYyMmUzMDEyOWNkOTFmZThkMmQyCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMC9kNjQxMTU1MjcwYWZmMjFlYWNkMjYyMmUz
MDEyOWNkOTFmZThkMmQyCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMC1kNjQxMTU1
MjcwYWZmMjFlYWNkMjYyMmUzMDEyOWNkOTFmZThkMmQyCndhaXRpbmcgZm9yIGNvbXBsZXRp
b24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctaHN4
YTAtMDYwMjExMDAtZDY0MTE1NTI3MGFmZjIxZWFjZDI2MjJlMzAxMjljZDkxZmU4ZDJkMgpr
ZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDAvZDY0MTE1
NTI3MGFmZjIxZWFjZDI2MjJlMzAxMjljZDkxZmU4ZDJkMi92bWxpbnV6LTMuMTUuMC1yYzgt
MDIwOTQtZ2Q2NDExNTUKCjIwMTQtMDYtMDItMTI6MTQ6MjAgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgLi4uLi4uLi4uLi4uCTIJMy4JNC4JMTIJMTkgU1VDQ0VTUwoKQmlzZWN0aW5nOiA1NSBy
ZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNiBzdGVwcykKWzAw
MmZhODJkYWM2ZjBiZTQ4NjMzM2U2NDI0OTY4YzBjNDJjMGU3OTldIE1lcmdlICdqYmFybmVz
L2FzeW5jJyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDYwMjEwCnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51
eDYvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDAvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIw
MTQwNjAyMTA6MDAyZmE4MmRhYzZmMGJlNDg2MzMzZTY0MjQ5NjhjMGM0MmMwZTc5OTpiaXNl
Y3QtbGludXg2CgoyMDE0LTA2LTAyLTEyOjIzOjUxIDAwMmZhODJkYWM2ZjBiZTQ4NjMzM2U2
NDI0OTY4YzBjNDJjMGU3OTkgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDAt
MDAyZmE4MmRhYzZmMGJlNDg2MzMzZTY0MjQ5NjhjMGM0MmMwZTc5OQpDaGVjayBmb3Iga2Vy
bmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDAvMDAyZmE4
MmRhYzZmMGJlNDg2MzMzZTY0MjQ5NjhjMGM0MmMwZTc5OQp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaHN4
YTAtMDYwMjExMDAtMDAyZmE4MmRhYzZmMGJlNDg2MzMzZTY0MjQ5NjhjMGM0MmMwZTc5OQp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvLng4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIxMTAwLTAwMmZhODJkYWM2ZjBiZTQ4NjMzM2U2
NDI0OTY4YzBjNDJjMGU3OTkKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhz
eGEwLTA2MDIxMTAwLzAwMmZhODJkYWM2ZjBiZTQ4NjMzM2U2NDI0OTY4YzBjNDJjMGU3OTkv
dm1saW51ei0zLjE1LjAtcmM4LTAyMDk5LWcwMDJmYTgyCgoyMDE0LTA2LTAyLTEyOjI1OjUx
IGRldGVjdGluZyBib290IHN0YXRlIC4uLi4uLgk1CTEzCTE1CTE5IFNVQ0NFU1MKCkJpc2Vj
dGluZzogNTAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDYg
c3RlcHMpClsxZWE1MmE5NjA1YmUxMjM0YjdkYTNlNGQxMzQ5MTdjN2JhM2JlOTNkXSBNZXJn
ZSAnamJhcm5lcy9hc3luYy1mYi1wcm9iZScgaW50byBkZXZlbC1ob3VybHktMjAxNDA2MDIx
MApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2MvYm9vdC1iaXNlY3QvbGludXg2L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIxMTAwL2xpbnV4LWRl
dmVsOmRldmVsLWhvdXJseS0yMDE0MDYwMjEwOjFlYTUyYTk2MDViZTEyMzRiN2RhM2U0ZDEz
NDkxN2M3YmEzYmU5M2Q6YmlzZWN0LWxpbnV4NgoKMjAxNC0wNi0wMi0xMjozMDo1MiAxZWE1
MmE5NjA1YmUxMjM0YjdkYTNlNGQxMzQ5MTdjN2JhM2JlOTNkIGNvbXBpbGluZwpRdWV1ZWQg
YnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29u
ZmlnLWhzeGEwLTA2MDIxMTAwLTFlYTUyYTk2MDViZTEyMzRiN2RhM2U0ZDEzNDkxN2M3YmEz
YmU5M2QKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhz
eGEwLTA2MDIxMTAwLzFlYTUyYTk2MDViZTEyMzRiN2RhM2U0ZDEzNDkxN2M3YmEzYmU5M2QK
d2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIxMTAwLTFlYTUyYTk2MDViZTEyMzRiN2RhM2U0
ZDEzNDkxN2M3YmEzYmU5M2QKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRl
c3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMC0xZWE1
MmE5NjA1YmUxMjM0YjdkYTNlNGQxMzQ5MTdjN2JhM2JlOTNkCmtlcm5lbDogL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMC8xZWE1MmE5NjA1YmUxMjM0YjdkYTNl
NGQxMzQ5MTdjN2JhM2JlOTNkL3ZtbGludXotMy4xNS4wLXJjOC0wMjEwMi1nMWVhNTJhOQoK
MjAxNC0wNi0wMi0xMjo0MTo1MiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLiBURVNUIEZBSUxVUkUKWyAgICAzLjk2MzgxOV0gW1RUTV0g
SW5pdGlhbGl6aW5nIERNQSBwb29sIGFsbG9jYXRvcgpbICAgIDMuOTY1NTM1XSAKWyAgICAz
Ljk2NjAxOV0gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
ClsgICAgMy45NjYwMTldIFsgSU5GTzogcG9zc2libGUgcmVjdXJzaXZlIGxvY2tpbmcgZGV0
ZWN0ZWQgXQpbICAgIDMuOTY2MDE5XSAzLjE1LjAtcmM4LTAyMTAyLWcxZWE1MmE5ICMxIE5v
dCB0YWludGVkClsgICAgMy45NjYwMTldIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLQpbICAgIDMuOTY2MDE5XSBzd2FwcGVyLzAvMSBpcyB0cnlpbmcg
dG8gYWNxdWlyZSBsb2NrOgpbICAgIDMuOTY2MDE5XSAgKCZkZXYtPm1vZGVfY29uZmlnLm11
dGV4KXsrLisuKy59LCBhdDogWzxmZmZmZmZmZjgxOTFkYjE1Pl0gZHJtX21vZGVzZXRfbG9j
a19hbGwrMHgzNS8weDgwClsgICAgMy45NjYwMTldIApbICAgIDMuOTY2MDE5XSBidXQgdGFz
ayBpcyBhbHJlYWR5IGhvbGRpbmcgbG9jazoKWyAgICAzLjk2NjAxOV0gICgmZGV2LT5tb2Rl
X2NvbmZpZy5tdXRleCl7Ky4rLisufSwgYXQ6IFs8ZmZmZmZmZmY4MTkwODJlOT5dIGRybV9m
Yl9oZWxwZXJfaW5pdGlhbF9jb25maWcrMHgxMTkvMHg3MzAKWyAgICAzLjk2NjAxOV0gClsg
ICAgMy45NjYwMTldIG90aGVyIGluZm8gdGhhdCBtaWdodCBoZWxwIHVzIGRlYnVnIHRoaXM6
ClsgICAgMy45NjYwMTldICBQb3NzaWJsZSB1bnNhZmUgbG9ja2luZyBzY2VuYXJpbzoKWyAg
ICAzLjk2NjAxOV0gClsgICAgMy45NjYwMTldICAgICAgICBDUFUwClsgICAgMy45NjYwMTld
ICAgICAgICAtLS0tClsgICAgMy45NjYwMTldICAgbG9jaygmZGV2LT5tb2RlX2NvbmZpZy5t
dXRleCk7ClsgICAgMy45NjYwMTldICAgbG9jaygmZGV2LT5tb2RlX2NvbmZpZy5tdXRleCk7
ClsgICAgMy45NjYwMTldIApbICAgIDMuOTY2MDE5XSAgKioqIERFQURMT0NLICoqKgpbICAg
IDMuOTY2MDE5XSAKWyAgICAzLjk2NjAxOV0gIE1heSBiZSBkdWUgdG8gbWlzc2luZyBsb2Nr
IG5lc3Rpbmcgbm90YXRpb24KWyAgICAzLjk2NjAxOV0gClsgICAgMy45NjYwMTldIDQgbG9j
a3MgaGVsZCBieSBzd2FwcGVyLzAvMToKWyAgICAzLjk2NjAxOV0gICMwOiAgKCZkZXYtPm11
dGV4KXsuLi4uLi59LCBhdDogWzxmZmZmZmZmZjgxYjY4MTIzPl0gX19kcml2ZXJfYXR0YWNo
KzB4NzMvMHgxMDAKWyAgICAzLjk2NjAxOV0gICMxOiAgKCZkZXYtPm11dGV4KXsuLi4uLi59
LCBhdDogWzxmZmZmZmZmZjgxYjY4MTM5Pl0gX19kcml2ZXJfYXR0YWNoKzB4ODkvMHgxMDAK
WyAgICAzLjk2NjAxOV0gICMyOiAgKGRybV9nbG9iYWxfbXV0ZXgpeysuKy4rLn0sIGF0OiBb
PGZmZmZmZmZmODE5MTcwNWE+XSBkcm1fZGV2X3JlZ2lzdGVyKzB4MmEvMHgxYzAKWyAgICAz
Ljk2NjAxOV0gICMzOiAgKCZkZXYtPm1vZGVfY29uZmlnLm11dGV4KXsrLisuKy59LCBhdDog
WzxmZmZmZmZmZjgxOTA4MmU5Pl0gZHJtX2ZiX2hlbHBlcl9pbml0aWFsX2NvbmZpZysweDEx
OS8weDczMApbICAgIDMuOTY2MDE5XSAKWyAgICAzLjk2NjAxOV0gc3RhY2sgYmFja3RyYWNl
OgpbICAgIDMuOTY2MDE5XSBDUFU6IDEgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFp
bnRlZCAzLjE1LjAtcmM4LTAyMTAyLWcxZWE1MmE5ICMxClsgICAgMy45NjYwMTldIEhhcmR3
YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAzLjk2
NjAxOV0gIGZmZmY4ODAwMTIxODA3YjAgZmZmZjg4MDAxMjE4NzllOCBmZmZmZmZmZjgyNzVi
ZjA1IGZmZmY4ODAwMTIxODAwMTAKWyAgICAzLjk2NjAxOV0gIGZmZmY4ODAwMTIxODdhNTgg
ZmZmZmZmZmY4MTEzYzkxMSAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMTIxODA3YjAKWyAg
ICAzLjk2NjAxOV0gIGZmZmY4ODAwMTIxODdhNzggZmZmZmZmZmYwMDAwMDAwMCAyN2UxM2Yw
ZDI0NjllMzRmIDAwMDAwMDAwMDAwMDBhMDAKWyAgICAzLjk2NjAxOV0gQ2FsbCBUcmFjZToK
WyAgICAzLjk2NjAxOV0gIFs8ZmZmZmZmZmY4Mjc1YmYwNT5dIGR1bXBfc3RhY2srMHg4NS8w
eGJhClsgICAgMy45NjYwMTldICBbPGZmZmZmZmZmODExM2M5MTE+XSBfX2xvY2tfYWNxdWly
ZSsweDFmNDEvMHgyMmQwClsgICAgMy45NjYwMTldICBbPGZmZmZmZmZmODExM2NkOGI+XSBs
b2NrX2FjcXVpcmUrMHhlYi8weDFjMApbICAgIDMuOTY2MDE5XSAgWzxmZmZmZmZmZjgxOTFk
YjE1Pl0gPyBkcm1fbW9kZXNldF9sb2NrX2FsbCsweDM1LzB4ODAKWyAgICAzLjk2NjAxOV0g
IFs8ZmZmZmZmZmY4Mjc3NDMzNT5dIG11dGV4X2xvY2tfbmVzdGVkKzB4ODUvMHg2MDAKWyAg
ICAzLjk2NjAxOV0gIFs8ZmZmZmZmZmY4MTkxZGIxNT5dID8gZHJtX21vZGVzZXRfbG9ja19h
bGwrMHgzNS8weDgwClsgICAgMy45NjYwMTldICBbPGZmZmZmZmZmODExMzgxOGQ+XSA/IHRy
YWNlX2hhcmRpcnFzX29uKzB4MWQvMHgzMApbICAgIDMuOTY2MDE5XSAgWzxmZmZmZmZmZjgx
OTA4MmU5Pl0gPyBkcm1fZmJfaGVscGVyX2luaXRpYWxfY29uZmlnKzB4MTE5LzB4NzMwClsg
ICAgMy45NjYwMTldICBbPGZmZmZmZmZmODE3MWIzMmI+XSA/IGZiX2dldF9vcHRpb25zKzB4
MmIvMHgyNDAKWyAgICAzLjk2NjAxOV0gIFs8ZmZmZmZmZmY4MTkxZGIxNT5dIGRybV9tb2Rl
c2V0X2xvY2tfYWxsKzB4MzUvMHg4MApbICAgIDMuOTY2MDE5XSAgWzxmZmZmZmZmZjgxOTA4
MmY5Pl0gZHJtX2ZiX2hlbHBlcl9pbml0aWFsX2NvbmZpZysweDEyOS8weDczMApbICAgIDMu
OTY2MDE5XSAgWzxmZmZmZmZmZjgxMTM4MThkPl0gPyB0cmFjZV9oYXJkaXJxc19vbisweDFk
LzB4MzAKWyAgICAzLjk2NjAxOV0gIFs8ZmZmZmZmZmY4MTkxZGJjYT5dID8gZHJtX21vZGVz
ZXRfdW5sb2NrX2FsbCsweDZhLzB4ODAKWyAgICAzLjk2NjAxOV0gIFs8ZmZmZmZmZmY4MWEx
MDFlZD5dIGNpcnJ1c19mYmRldl9pbml0KzB4Y2QvMHgxMTAKWyAgICAzLjk2NjAxOV0gIFs8
ZmZmZmZmZmY4MWEwZjUwND5dIGNpcnJ1c19tb2Rlc2V0X2luaXQrMHgyMzQvMHgyZDAKWyAg
ICAzLjk2NjAxOV0gIFs8ZmZmZmZmZmY4MWEwZGIwNj5dIGNpcnJ1c19kcml2ZXJfbG9hZCsw
eDk2LzB4MWEwClsgICAgMy45NjYwMTldICBbPGZmZmZmZmZmODE5MTcxNDU+XSBkcm1fZGV2
X3JlZ2lzdGVyKzB4MTE1LzB4MWMwClsgICAgMy45NjYwMTldICBbPGZmZmZmZmZmODE5MWEy
Yjg+XSBkcm1fZ2V0X3BjaV9kZXYrMHgxMzgvMHgzMjAKWyAgICAzLjk2NjAxOV0gIFs8ZmZm
ZmZmZmY4MTEzODE4ZD5dID8gdHJhY2VfaGFyZGlycXNfb24rMHgxZC8weDMwClsgICAgMy45
NjYwMTldICBbPGZmZmZmZmZmODFhMGY3MzU+XSBjaXJydXNfcGNpX3Byb2JlKzB4MTA1LzB4
MTQwClsgICAgMy45NjYwMTldICBbPGZmZmZmZmZmODE2YzE5MjA+XSBwY2lfZGV2aWNlX3By
b2JlKzB4ZTAvMHgxYzAKWyAgICAzLjk2NjAxOV0gIFs8ZmZmZmZmZmY4MWI2N2JmYz5dIGRy
aXZlcl9wcm9iZV9kZXZpY2UrMHhjYy8weDU4MApbICAgIDMuOTY2MDE5XSAgWzxmZmZmZmZm
ZjgxYjY4MTliPl0gX19kcml2ZXJfYXR0YWNoKzB4ZWIvMHgxMDAKWyAgICAzLjk2NjAxOV0g
IFs8ZmZmZmZmZmY4MWI2ODBiMD5dID8gZHJpdmVyX3Byb2JlX2RldmljZSsweDU4MC8weDU4
MApbICAgIDMuOTY2MDE5XSAgWzxmZmZmZmZmZjgxYjY0ZDMzPl0gYnVzX2Zvcl9lYWNoX2Rl
disweGIzLzB4MTEwClsgICAgMy45NjYwMTldICBbPGZmZmZmZmZmODFiNjc3MzY+XSBkcml2
ZXJfYXR0YWNoKzB4MjYvMHgzMApbICAgIDMuOTY2MDE5XSAgWzxmZmZmZmZmZjgxYjY1ZTA4
Pl0gYnVzX2FkZF9kcml2ZXIrMHgyMDgvMHgzOTAKWyAgICAzLjk2NjAxOV0gIFs8ZmZmZmZm
ZmY4M2M3NDYyMD5dID8gaW50ZWxfbm9fbHZkc19kbWlfY2FsbGJhY2srMHgyYi8weDJiClsg
ICAgMy45NjYwMTldICBbPGZmZmZmZmZmODFiNjg4MzA+XSBkcml2ZXJfcmVnaXN0ZXIrMHhi
MC8weDFhMApbICAgIDMuOTY2MDE5XSAgWzxmZmZmZmZmZjgzYzc0NjIwPl0gPyBpbnRlbF9u
b19sdmRzX2RtaV9jYWxsYmFjaysweDJiLzB4MmIKWyAgICAzLjk2NjAxOV0gIFs8ZmZmZmZm
ZmY4MTZjMWE2ZD5dIF9fcGNpX3JlZ2lzdGVyX2RyaXZlcisweDZkLzB4ODAKWyAgICAzLjk2
NjAxOV0gIFs8ZmZmZmZmZmY4MTkxYTVlOT5dIGRybV9wY2lfaW5pdCsweDE0OS8weDE4MApb
ICAgIDMuOTY2MDE5XSAgWzxmZmZmZmZmZjgzYzc0NjIwPl0gPyBpbnRlbF9ub19sdmRzX2Rt
aV9jYWxsYmFjaysweDJiLzB4MmIKWyAgICAzLjk2NjAxOV0gIFs8ZmZmZmZmZmY4M2M3NDY4
Mz5dIGNpcnJ1c19pbml0KzB4NjMvMHg2YwpbICAgIDMuOTY2MDE5XSAgWzxmZmZmZmZmZjgz
YzBkNWU1Pl0gZG9fb25lX2luaXRjYWxsKzB4ZTgvMHgxY2MKWyAgICAzLjk2NjAxOV0gIFs8
ZmZmZmZmZmY4MTEwMWRlNT5dID8gcGFyc2VfYXJncysweDJhNS8weDVjMApbICAgIDMuOTY2
MDE5XSAgWzxmZmZmZmZmZjgzYzBkODkzPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgxY2Ev
MHgyYzkKWyAgICAzLjk2NjAxOV0gIFs8ZmZmZmZmZmY4M2MwY2FkNz5dID8gZG9fZWFybHlf
cGFyYW0rMHhkNy8weGQ3ClsgICAgMy45NjYwMTldICBbPGZmZmZmZmZmODI3NDkzYjA+XSA/
IHJlc3RfaW5pdCsweDEyMC8weDEyMApbICAgIDMuOTY2MDE5XSAgWzxmZmZmZmZmZjgyNzQ5
M2M2Pl0ga2VybmVsX2luaXQrMHgxNi8weDFiMApbICAgIDMuOTY2MDE5XSAgWzxmZmZmZmZm
ZjgyNzdiM2ZjPl0gcmV0X2Zyb21fZm9yaysweDdjLzB4YjAKWyAgICAzLjk2NjAxOV0gIFs8
ZmZmZmZmZmY4Mjc0OTNiMD5dID8gcmVzdF9pbml0KzB4MTIwLzB4MTIwClsgICA2Mi4wNDIw
NjNdIHNwaW5fbG9jay10b3J0dXJlOiBXcml0ZXM6ICBUb3RhbDogNCAgTWF4L01pbjogMC8w
ICAgRmFpbDogMCAKWyAgMTMxLjYzMDg4Nl0gc3Bpbl9sb2NrLXRvcnR1cmU6IFdyaXRlczog
IFRvdGFsOiA0ICBNYXgvTWluOiAwLzAgICBGYWlsOiAwIApbICAxOTEuNjMyMDY5XSBzcGlu
X2xvY2stdG9ydHVyZTogV3JpdGVzOiAgVG90YWw6IDQgIE1heC9NaW46IDAvMCAgIEZhaWw6
IDAgCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDAvMWVhNTJhOTYw
NWJlMTIzNGI3ZGEzZTRkMTM0OTE3YzdiYTNiZTkzZC9kbWVzZy1xdWFudGFsLWl2YjQxLTEx
MzoyMDE0MDYwMjEyNTY1NDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMDozLjE1
LjAtcmM4LTAyMTAyLWcxZWE1MmE5OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MC0wNjAyMTEwMC8xZWE1MmE5NjA1YmUxMjM0YjdkYTNlNGQxMzQ5MTdjN2JhM2JlOTNkL2Rt
ZXNnLXF1YW50YWwtaXZiNDEtNDoyMDE0MDYwMjEyNTY1Mzp4ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMC0wNjAyMTEwMDozLjE1LjAtcmM4LTAyMTAyLWcxZWE1MmE5OjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMC8xZWE1MmE5NjA1YmUxMjM0YjdkYTNlNGQx
MzQ5MTdjN2JhM2JlOTNkL2RtZXNnLXF1YW50YWwtaXZiNDEtNjE6MjAxNDA2MDIxMjU2NTI6
eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDA6My4xNS4wLXJjOC0wMjEwMi1nMWVh
NTJhOToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDAvMWVhNTJh
OTYwNWJlMTIzNGI3ZGEzZTRkMTM0OTE3YzdiYTNiZTkzZC9kbWVzZy1xdWFudGFsLWl2YjQy
LTEyNToyMDE0MDYwMjEyNTY1NDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMDoz
LjE1LjAtcmM4LTAyMTAyLWcxZWE1MmE5OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMC0wNjAyMTEwMC8xZWE1MmE5NjA1YmUxMjM0YjdkYTNlNGQxMzQ5MTdjN2JhM2JlOTNk
L2RtZXNnLXF1YW50YWwtaXZiNDMtMjY6MjAxNDA2MDIxMjU2NTQ6eDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDYwMjExMDA6My4xNS4wLXJjOC0wMjEwMi1nMWVhNTJhOToxCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDAvMWVhNTJhOTYwNWJlMTIzNGI3ZGEz
ZTRkMTM0OTE3YzdiYTNiZTkzZC9kbWVzZy1xdWFudGFsLWl2YjQzLTI3OjIwMTQwNjAyMTI1
NjU0Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIxMTAwOjMuMTUuMC1yYzgtMDIxMDIt
ZzFlYTUyYTk6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIxMTAwLzFl
YTUyYTk2MDViZTEyMzRiN2RhM2U0ZDEzNDkxN2M3YmEzYmU5M2QvZG1lc2ctcXVhbnRhbC1p
dmI0My03ODoyMDE0MDYwMjEyNTY1NDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEw
MDozLjE1LjAtcmM4LTAyMTAyLWcxZWE1MmE5OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMC0wNjAyMTEwMC8xZWE1MmE5NjA1YmUxMjM0YjdkYTNlNGQxMzQ5MTdjN2JhM2Jl
OTNkL2RtZXNnLXlvY3RvLWl2YjQxLTI0OjIwMTQwNjAyMTI1NjUyOng4Nl82NC1yYW5kY29u
ZmlnLWhzeGEwLTA2MDIxMTAwOjMuMTUuMC1yYzgtMDIxMDItZzFlYTUyYTk6MQova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIxMTAwLzFlYTUyYTk2MDViZTEyMzRiN2Rh
M2U0ZDEzNDkxN2M3YmEzYmU5M2QvZG1lc2cteW9jdG8taXZiNDItMzc6MjAxNDA2MDIxMjU2
NTI6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDA6My4xNS4wLXJjOC0wMjEwMi1n
MWVhNTJhOToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDAvMWVh
NTJhOTYwNWJlMTIzNGI3ZGEzZTRkMTM0OTE3YzdiYTNiZTkzZC9kbWVzZy15b2N0by1pdmI0
Mi01MzoyMDE0MDYwMjEyNTY1NDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMDoz
LjE1LjAtcmM4LTAyMTAyLWcxZWE1MmE5OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMC0wNjAyMTEwMC8xZWE1MmE5NjA1YmUxMjM0YjdkYTNlNGQxMzQ5MTdjN2JhM2JlOTNk
L2RtZXNnLXlvY3RvLWl2YjQzLTExMToyMDE0MDYwMjEyNTY0OTp4ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMC0wNjAyMTEwMDozLjE1LjAtcmM4LTAyMTAyLWcxZWE1MmE5OjEKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMC8xZWE1MmE5NjA1YmUxMjM0YjdkYTNl
NGQxMzQ5MTdjN2JhM2JlOTNkL2RtZXNnLXlvY3RvLWl2YjQzLTMwOjIwMTQwNjAyMTI1NjQ5
Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIxMTAwOjMuMTUuMC1yYzgtMDIxMDItZzFl
YTUyYTk6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIxMTAwLzFlYTUy
YTk2MDViZTEyMzRiN2RhM2U0ZDEzNDkxN2M3YmEzYmU5M2QvZG1lc2cteW9jdG8taXZiNDMt
NDA6MjAxNDA2MDIxMjU2NTQ6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDA6My4x
NS4wLXJjOC0wMjEwMi1nMWVhNTJhOToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4
YTAtMDYwMjExMDAvMWVhNTJhOTYwNWJlMTIzNGI3ZGEzZTRkMTM0OTE3YzdiYTNiZTkzZC9k
bWVzZy15b2N0by1pdmI0My00MToyMDE0MDYwMjEyNTY0OTp4ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMC0wNjAyMTEwMDozLjE1LjAtcmM4LTAyMTAyLWcxZWE1MmE5OjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMC8xZWE1MmE5NjA1YmUxMjM0YjdkYTNlNGQx
MzQ5MTdjN2JhM2JlOTNkL2RtZXNnLXlvY3RvLWl2YjQ0LTEwODoyMDE0MDYwMjEyNTY1MTp4
ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMDozLjE1LjAtcmM4LTAyMTAyLWcxZWE1
MmE5OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMC8xZWE1MmE5
NjA1YmUxMjM0YjdkYTNlNGQxMzQ5MTdjN2JhM2JlOTNkL2RtZXNnLXlvY3RvLWl2YjQ0LTEy
NToyMDE0MDYwMjEyNTY1MTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMDozLjE1
LjAtcmM4LTAyMTAyLWcxZWE1MmE5OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MC0wNjAyMTEwMC8xZWE1MmE5NjA1YmUxMjM0YjdkYTNlNGQxMzQ5MTdjN2JhM2JlOTNkL2Rt
ZXNnLXlvY3RvLWl2YjQ0LTQ1OjIwMTQwNjAyMTI1NjU3Ong4Nl82NC1yYW5kY29uZmlnLWhz
eGEwLTA2MDIxMTAwOjMuMTUuMC1yYzgtMDIxMDItZzFlYTUyYTk6MQova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIxMTAwLzFlYTUyYTk2MDViZTEyMzRiN2RhM2U0ZDEz
NDkxN2M3YmEzYmU5M2QvZG1lc2cteW9jdG8taXZiNDQtNjU6MjAxNDA2MDIxMjU2NTc6eDg2
XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDA6My4xNS4wLXJjOC0wMjEwMi1nMWVhNTJh
OToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDAvMWVhNTJhOTYw
NWJlMTIzNGI3ZGEzZTRkMTM0OTE3YzdiYTNiZTkzZC9kbWVzZy15b2N0by1pdmI0NC04Njoy
MDE0MDYwMjEyNTY1MTp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMDozLjE1LjAt
cmM4LTAyMTAyLWcxZWE1MmE5OjEKMDoxOToxOSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290
cwobWzE7MzVtMjAxNC0wNi0wMiAxMjo1Nzo1MyBSRVBFQVQgQ09VTlQ6IDIwICAjIC9jL2Jv
b3QtYmlzZWN0L2xpbnV4Ni9vYmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpsaW5lYXItYmlzZWN0
OiBiYWQgYnJhbmNoIG1heSBiZSBqYmFybmVzL2FzeW5jLWZiLXByb2JlCmxpbmVhci1iaXNl
Y3Q6IGhhbmRsZSBvdmVyIHRvIGdpdCBiaXNlY3QKbGluZWFyLWJpc2VjdDogZ2l0IGJpc2Vj
dCBzdGFydCAxZWE1MmE5NjA1YmUxMjM0YjdkYTNlNGQxMzQ5MTdjN2JhM2JlOTNkIDAwMmZh
ODJkYWM2ZjBiZTQ4NjMzM2U2NDI0OTY4YzBjNDJjMGU3OTkgLS0KQmlzZWN0aW5nOiAwIHJl
dmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0ZXApCltmNzI4
MDgwZDZiYWM0N2FhYjJkNTcwNDkyYWNlZjg4MzE3YWM4ZTAzXSBkcm0vaTkxNTogbWFrZSBm
YmRldiBpbml0aWFsaXphdGlvbiBhc3luY2hyb25vdXMgdjIKbGluZWFyLWJpc2VjdDogZ2l0
IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aCAvYy9ib290LWJpc2VjdC9saW51eDYvb2JqLWJpc2VjdApydW5uaW5nIC9jL2tlcm5lbC10
ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXg2
L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1y
YW5kY29uZmlnLWhzeGEwLTA2MDIxMTAwL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0
MDYwMjEwOmY3MjgwODBkNmJhYzQ3YWFiMmQ1NzA0OTJhY2VmODgzMTdhYzhlMDM6YmlzZWN0
LWxpbnV4NgoKMjAxNC0wNi0wMi0xMjo1Nzo1NCBmNzI4MDgwZDZiYWM0N2FhYjJkNTcwNDky
YWNlZjg4MzE3YWM4ZTAzIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIxMTAwLWY3
MjgwODBkNmJhYzQ3YWFiMmQ1NzA0OTJhY2VmODgzMTdhYzhlMDMKQ2hlY2sgZm9yIGtlcm5l
bCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIxMTAwL2Y3MjgwODBk
NmJhYzQ3YWFiMmQ1NzA0OTJhY2VmODgzMTdhYzhlMDMKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEw
LTA2MDIxMTAwLWY3MjgwODBkNmJhYzQ3YWFiMmQ1NzA0OTJhY2VmODgzMTdhYzhlMDMKd2Fp
dGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMC1mNzI4MDgwZDZiYWM0N2FhYjJkNTcwNDky
YWNlZjg4MzE3YWM4ZTAzCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MC0wNjAyMTEwMC9mNzI4MDgwZDZiYWM0N2FhYjJkNTcwNDkyYWNlZjg4MzE3YWM4ZTAzL3Zt
bGludXotMy4xNS4wLXJjNS0wMDA4OC1nZjcyODA4MAoKMjAxNC0wNi0wMi0xMzozNTo1NCBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
IFRFU1QgRkFJTFVSRQpbICAgMTEuNzY1MTc1XSBbVFRNXSBJbml0aWFsaXppbmcgRE1BIHBv
b2wgYWxsb2NhdG9yClsgICAxMS43NjY5NjVdIApbICAgMTEuNzY3NDE1XSA9PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KWyAgIDExLjc2NzQxNV0gWyBJ
TkZPOiBwb3NzaWJsZSByZWN1cnNpdmUgbG9ja2luZyBkZXRlY3RlZCBdClsgICAxMS43Njc0
MTVdIDMuMTUuMC1yYzUtMDAwODgtZ2Y3MjgwODAgIzIgTm90IHRhaW50ZWQKWyAgIDExLjc2
NzQxNV0gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tClsg
ICAxMS43Njc0MTVdIHN3YXBwZXIvMC8xIGlzIHRyeWluZyB0byBhY3F1aXJlIGxvY2s6Clsg
ICAxMS43Njc0MTVdICAoJmRldi0+bW9kZV9jb25maWcubXV0ZXgpeysuKy4rLn0sIGF0OiBb
PGZmZmZmZmZmODE5MTkyNDU+XSBkcm1fbW9kZXNldF9sb2NrX2FsbCsweDM1LzB4ODAKWyAg
IDExLjc2NzQxNV0gClsgICAxMS43Njc0MTVdIGJ1dCB0YXNrIGlzIGFscmVhZHkgaG9sZGlu
ZyBsb2NrOgpbICAgMTEuNzY3NDE1XSAgKCZkZXYtPm1vZGVfY29uZmlnLm11dGV4KXsrLisu
Ky59LCBhdDogWzxmZmZmZmZmZjgxOTAzYTE5Pl0gZHJtX2ZiX2hlbHBlcl9pbml0aWFsX2Nv
bmZpZysweDExOS8weDczMApbICAgMTEuNzY3NDE1XSAKWyAgIDExLjc2NzQxNV0gb3RoZXIg
aW5mbyB0aGF0IG1pZ2h0IGhlbHAgdXMgZGVidWcgdGhpczoKWyAgIDExLjc2NzQxNV0gIFBv
c3NpYmxlIHVuc2FmZSBsb2NraW5nIHNjZW5hcmlvOgpbICAgMTEuNzY3NDE1XSAKWyAgIDEx
Ljc2NzQxNV0gICAgICAgIENQVTAKWyAgIDExLjc2NzQxNV0gICAgICAgIC0tLS0KWyAgIDEx
Ljc2NzQxNV0gICBsb2NrKCZkZXYtPm1vZGVfY29uZmlnLm11dGV4KTsKWyAgIDExLjc2NzQx
NV0gICBsb2NrKCZkZXYtPm1vZGVfY29uZmlnLm11dGV4KTsKWyAgIDExLjc2NzQxNV0gClsg
ICAxMS43Njc0MTVdICAqKiogREVBRExPQ0sgKioqClsgICAxMS43Njc0MTVdIApbICAgMTEu
NzY3NDE1XSAgTWF5IGJlIGR1ZSB0byBtaXNzaW5nIGxvY2sgbmVzdGluZyBub3RhdGlvbgpb
ICAgMTEuNzY3NDE1XSAKWyAgIDExLjc2NzQxNV0gNCBsb2NrcyBoZWxkIGJ5IHN3YXBwZXIv
MC8xOgpbICAgMTEuNzY3NDE1XSAgIzA6ICAoJmRldi0+bXV0ZXgpey4uLi4uLn0sIGF0OiBb
PGZmZmZmZmZmODFiNjMzNzM+XSBfX2RyaXZlcl9hdHRhY2grMHg3My8weDEwMApbICAgMTEu
NzY3NDE1XSAgIzE6ICAoJmRldi0+bXV0ZXgpey4uLi4uLn0sIGF0OiBbPGZmZmZmZmZmODFi
NjMzODk+XSBfX2RyaXZlcl9hdHRhY2grMHg4OS8weDEwMApbICAgMTEuNzY3NDE1XSAgIzI6
ICAoZHJtX2dsb2JhbF9tdXRleCl7Ky4rLisufSwgYXQ6IFs8ZmZmZmZmZmY4MTkxMjc4YT5d
IGRybV9kZXZfcmVnaXN0ZXIrMHgyYS8weDFjMApbICAgMTEuNzY3NDE1XSAgIzM6ICAoJmRl
di0+bW9kZV9jb25maWcubXV0ZXgpeysuKy4rLn0sIGF0OiBbPGZmZmZmZmZmODE5MDNhMTk+
XSBkcm1fZmJfaGVscGVyX2luaXRpYWxfY29uZmlnKzB4MTE5LzB4NzMwClsgICAxMS43Njc0
MTVdIApbICAgMTEuNzY3NDE1XSBzdGFjayBiYWNrdHJhY2U6ClsgICAxMS43Njc0MTVdIENQ
VTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTUuMC1yYzUtMDAw
ODgtZ2Y3MjgwODAgIzIKWyAgIDExLjc2NzQxNV0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9j
aHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgMTEuNzY3NDE1XSAgZmZmZjg4MDAxMjE4
MDdhOCBmZmZmODgwMDEyMTgzOWU4IGZmZmZmZmZmODI3NTI5NDUgZmZmZjg4MDAxMjE4MDAx
MApbICAgMTEuNzY3NDE1XSAgZmZmZjg4MDAxMjE4M2E1OCBmZmZmZmZmZjgxMTNjMDI3IDAw
MDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAxMjE4MDdhOApbICAgMTEuNzY3NDE1XSAgZmZmZjg4
MDAxMjE4M2E3OCBmZmZmZmZmZjAwMDAwMDAwIDI3ZDEzZThkMjQ2OWUzNGYgMDAwMDAwMDAw
MDAwMGEwMApbICAgMTEuNzY3NDE1XSBDYWxsIFRyYWNlOgpbICAgMTEuNzY3NDE1XSAgWzxm
ZmZmZmZmZjgyNzUyOTQ1Pl0gZHVtcF9zdGFjaysweDg1LzB4YmEKWyAgIDExLjc2NzQxNV0g
IFs8ZmZmZmZmZmY4MTEzYzAyNz5dIF9fbG9ja19hY3F1aXJlKzB4MWYzNy8weDIyYzAKWyAg
IDExLjc2NzQxNV0gIFs8ZmZmZmZmZmY4MTEzYzQ5Yj5dIGxvY2tfYWNxdWlyZSsweGViLzB4
MWMwClsgICAxMS43Njc0MTVdICBbPGZmZmZmZmZmODE5MTkyNDU+XSA/IGRybV9tb2Rlc2V0
X2xvY2tfYWxsKzB4MzUvMHg4MApbICAgMTEuNzY3NDE1XSAgWzxmZmZmZmZmZjgyNzZhZDQ1
Pl0gbXV0ZXhfbG9ja19uZXN0ZWQrMHg4NS8weDYwMApbICAgMTEuNzY3NDE1XSAgWzxmZmZm
ZmZmZjgxOTE5MjQ1Pl0gPyBkcm1fbW9kZXNldF9sb2NrX2FsbCsweDM1LzB4ODAKWyAgIDEx
Ljc2NzQxNV0gIFs8ZmZmZmZmZmY4MTEzNzhhZD5dID8gdHJhY2VfaGFyZGlycXNfb24rMHgx
ZC8weDMwClsgICAxMS43Njc0MTVdICBbPGZmZmZmZmZmODE5MDNhMTk+XSA/IGRybV9mYl9o
ZWxwZXJfaW5pdGlhbF9jb25maWcrMHgxMTkvMHg3MzAKWyAgIDExLjc2NzQxNV0gIFs8ZmZm
ZmZmZmY4MTcxYTI0Yj5dID8gZmJfZ2V0X29wdGlvbnMrMHgyYi8weDI0MApbICAgMTEuNzY3
NDE1XSAgWzxmZmZmZmZmZjgxOTE5MjQ1Pl0gZHJtX21vZGVzZXRfbG9ja19hbGwrMHgzNS8w
eDgwClsgICAxMS44NjUwMzZdICBbPGZmZmZmZmZmODE5MDNhMjk+XSBkcm1fZmJfaGVscGVy
X2luaXRpYWxfY29uZmlnKzB4MTI5LzB4NzMwClsgICAxMS44NjUwMzZdICBbPGZmZmZmZmZm
ODExMzc4YWQ+XSA/IHRyYWNlX2hhcmRpcnFzX29uKzB4MWQvMHgzMApbICAgMTEuODY1MDM2
XSAgWzxmZmZmZmZmZjgxOTE5MmZhPl0gPyBkcm1fbW9kZXNldF91bmxvY2tfYWxsKzB4NmEv
MHg4MApbICAgMTEuODY1MDM2XSAgWzxmZmZmZmZmZjgxYTBiNDNkPl0gY2lycnVzX2ZiZGV2
X2luaXQrMHhjZC8weDExMApbICAgMTEuODY1MDM2XSAgWzxmZmZmZmZmZjgxYTBhNzU0Pl0g
Y2lycnVzX21vZGVzZXRfaW5pdCsweDIzNC8weDJkMApbICAgMTEuODY1MDM2XSAgWzxmZmZm
ZmZmZjgxYTA4ZDU2Pl0gY2lycnVzX2RyaXZlcl9sb2FkKzB4OTYvMHgxYTAKWyAgIDExLjg2
NTAzNl0gIFs8ZmZmZmZmZmY4MTkxMjg3NT5dIGRybV9kZXZfcmVnaXN0ZXIrMHgxMTUvMHgx
YzAKWyAgIDExLjg2NTAzNl0gIFs8ZmZmZmZmZmY4MTkxNTllOD5dIGRybV9nZXRfcGNpX2Rl
disweDEzOC8weDMyMApbICAgMTEuODY1MDM2XSAgWzxmZmZmZmZmZjgxMTM3OGFkPl0gPyB0
cmFjZV9oYXJkaXJxc19vbisweDFkLzB4MzAKWyAgIDExLjg2NTAzNl0gIFs8ZmZmZmZmZmY4
MWEwYTk4NT5dIGNpcnJ1c19wY2lfcHJvYmUrMHgxMDUvMHgxNDAKWyAgIDExLjg2NTAzNl0g
IFs8ZmZmZmZmZmY4MTZjMDg0MD5dIHBjaV9kZXZpY2VfcHJvYmUrMHhlMC8weDFjMApbICAg
MTEuODY1MDM2XSAgWzxmZmZmZmZmZjgxYjYyZTRjPl0gZHJpdmVyX3Byb2JlX2RldmljZSsw
eGNjLzB4NTgwClsgICAxMS44NjUwMzZdICBbPGZmZmZmZmZmODFiNjMzZWI+XSBfX2RyaXZl
cl9hdHRhY2grMHhlYi8weDEwMApbICAgMTEuODY1MDM2XSAgWzxmZmZmZmZmZjgxYjYzMzAw
Pl0gPyBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4NTgwLzB4NTgwClsgICAxMS44NjUwMzZdICBb
PGZmZmZmZmZmODFiNWZmODM+XSBidXNfZm9yX2VhY2hfZGV2KzB4YjMvMHgxMTAKWyAgIDEx
Ljg2NTAzNl0gIFs8ZmZmZmZmZmY4MWI2Mjk4Nj5dIGRyaXZlcl9hdHRhY2grMHgyNi8weDMw
ClsgICAxMS44NjUwMzZdICBbPGZmZmZmZmZmODFiNjEwNTg+XSBidXNfYWRkX2RyaXZlcisw
eDIwOC8weDM5MApbICAgMTEuODY1MDM2XSAgWzxmZmZmZmZmZjgzYzZmNWUwPl0gPyBpbnRl
bF9ub19sdmRzX2RtaV9jYWxsYmFjaysweDJiLzB4MmIKWyAgIDExLjg2NTAzNl0gIFs8ZmZm
ZmZmZmY4MWI2M2E4MD5dIGRyaXZlcl9yZWdpc3RlcisweGIwLzB4MWEwClsgICAxMS44NjUw
MzZdICBbPGZmZmZmZmZmODNjNmY1ZTA+XSA/IGludGVsX25vX2x2ZHNfZG1pX2NhbGxiYWNr
KzB4MmIvMHgyYgpbICAgMTEuODY1MDM2XSAgWzxmZmZmZmZmZjgxNmMwOThkPl0gX19wY2lf
cmVnaXN0ZXJfZHJpdmVyKzB4NmQvMHg4MApbICAgMTEuODY1MDM2XSAgWzxmZmZmZmZmZjgx
OTE1ZDE5Pl0gZHJtX3BjaV9pbml0KzB4MTQ5LzB4MTgwClsgICAxMS44NjUwMzZdICBbPGZm
ZmZmZmZmODNjNmY1ZTA+XSA/IGludGVsX25vX2x2ZHNfZG1pX2NhbGxiYWNrKzB4MmIvMHgy
YgpbICAgMTEuODY1MDM2XSAgWzxmZmZmZmZmZjgzYzZmNjQzPl0gY2lycnVzX2luaXQrMHg2
My8weDZjClsgICAxMS44NjUwMzZdICBbPGZmZmZmZmZmODNjMDg1ZTU+XSBkb19vbmVfaW5p
dGNhbGwrMHhlOC8weDFjYwpbICAgMTEuODY1MDM2XSAgWzxmZmZmZmZmZjgzYzA4ODkzPl0g
a2VybmVsX2luaXRfZnJlZWFibGUrMHgxY2EvMHgyYzkKWyAgIDExLjg2NTAzNl0gIFs8ZmZm
ZmZmZmY4M2MwN2FkNz5dID8gZG9fZWFybHlfcGFyYW0rMHhkNy8weGQ3ClsgICAxMS44NjUw
MzZdICBbPGZmZmZmZmZmODI3M2ZkZjA+XSA/IHJlc3RfaW5pdCsweDEyMC8weDEyMApbICAg
MTEuODY1MDM2XSAgWzxmZmZmZmZmZjgyNzNmZTA2Pl0ga2VybmVsX2luaXQrMHgxNi8weDFi
MApbICAgMTEuODY1MDM2XSAgWzxmZmZmZmZmZjgyNzcxZGZjPl0gcmV0X2Zyb21fZm9yaysw
eDdjLzB4YjAKWyAgIDExLjg2NTAzNl0gIFs8ZmZmZmZmZmY4MjczZmRmMD5dID8gcmVzdF9p
bml0KzB4MTIwLzB4MTIwClsgICA2My4yODcwODBdIHNwaW5fbG9jay10b3J0dXJlOiBXcml0
ZXM6ICBUb3RhbDogNCAgTWF4L01pbjogMC8wICAgRmFpbDogMCAKWyAgMTIzLjI4ODA3MV0g
c3Bpbl9sb2NrLXRvcnR1cmU6IFdyaXRlczogIFRvdGFsOiA0ICBNYXgvTWluOiAwLzAgICBG
YWlsOiAwIApbICAxODMuMjg5MDY5XSBzcGluX2xvY2stdG9ydHVyZTogV3JpdGVzOiAgVG90
YWw6IDQgIE1heC9NaW46IDAvMCAgIEZhaWw6IDAgCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDYwMjExMDAvZjcyODA4MGQ2YmFjNDdhYWIyZDU3MDQ5MmFjZWY4ODMxN2Fj
OGUwMy9kbWVzZy1xdWFudGFsLWl2YjQ0LTExODoyMDE0MDYwMjEzNTIyODp4ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMC0wNjAyMTEwMDozLjE1LjAtcmM1LTAwMDg4LWdmNzI4MDgwOjIKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMC9mNzI4MDgwZDZiYWM0N2Fh
YjJkNTcwNDkyYWNlZjg4MzE3YWM4ZTAzL2RtZXNnLXF1YW50YWwtaXZiNDQtMTI2OjIwMTQw
NjAyMTM1MjI4Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIxMTAwOjMuMTUuMC1yYzUt
MDAwODgtZ2Y3MjgwODA6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIx
MTAwL2Y3MjgwODBkNmJhYzQ3YWFiMmQ1NzA0OTJhY2VmODgzMTdhYzhlMDMvZG1lc2ctcXVh
bnRhbC1pdmI0NC04MzoyMDE0MDYwMjEzNTIyODp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0w
NjAyMTEwMDozLjE1LjAtcmM1LTAwMDg4LWdmNzI4MDgwOjIKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1oc3hhMC0wNjAyMTEwMC9mNzI4MDgwZDZiYWM0N2FhYjJkNTcwNDkyYWNlZjg4
MzE3YWM4ZTAzL2RtZXNnLXF1YW50YWwtaXZiNDQtODY6MjAxNDA2MDIxMzUyMjg6eDg2XzY0
LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDA6My4xNS4wLXJjNS0wMDA4OC1nZjcyODA4MDoy
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDAvZjcyODA4MGQ2YmFj
NDdhYWIyZDU3MDQ5MmFjZWY4ODMxN2FjOGUwMy9kbWVzZy15b2N0by1pdmI0NC01NjoyMDE0
MDYwMjEzNTIyODp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMDozLjE1LjAtcmM1
LTAwMDg4LWdmNzI4MDgwOjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAy
MTEwMC9mNzI4MDgwZDZiYWM0N2FhYjJkNTcwNDkyYWNlZjg4MzE3YWM4ZTAzL2RtZXNnLXlv
Y3RvLWl2YjQ0LTY1OjIwMTQwNjAyMTM1MjI4Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2
MDIxMTAwOjMuMTUuMC1yYzUtMDAwODgtZ2Y3MjgwODA6Mgova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWhzeGEwLTA2MDIxMTAwL2Y3MjgwODBkNmJhYzQ3YWFiMmQ1NzA0OTJhY2VmODgz
MTdhYzhlMDMvZG1lc2cteW9jdG8taXZiNDQtNjY6MjAxNDA2MDIxMzUyMjg6eDg2XzY0LXJh
bmRjb25maWctaHN4YTAtMDYwMjExMDA6My4xNS4wLXJjNS0wMDA4OC1nZjcyODA4MDoyCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDAvZjcyODA4MGQ2YmFjNDdh
YWIyZDU3MDQ5MmFjZWY4ODMxN2FjOGUwMy9kbWVzZy15b2N0by1pdmI0NC02NzoyMDE0MDYw
MjEzNTIyODp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMDozLjE1LjAtcmM1LTAw
MDg4LWdmNzI4MDgwOjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEw
MC9mNzI4MDgwZDZiYWM0N2FhYjJkNTcwNDkyYWNlZjg4MzE3YWM4ZTAzL2RtZXNnLXlvY3Rv
LWl2YjQ0LTY4OjIwMTQwNjAyMTM1MjI4Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIx
MTAwOjMuMTUuMC1yYzUtMDAwODgtZ2Y3MjgwODA6Mgova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWhzeGEwLTA2MDIxMTAwL2Y3MjgwODBkNmJhYzQ3YWFiMmQ1NzA0OTJhY2VmODgzMTdh
YzhlMDMvZG1lc2cteW9jdG8taXZiNDQtNzA6MjAxNDA2MDIxMzUyMjY6eDg2XzY0LXJhbmRj
b25maWctaHN4YTAtMDYwMjExMDA6My4xNS4wLXJjNS0wMDA4OC1nZjcyODA4MDoyCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDAvZjcyODA4MGQ2YmFjNDdhYWIy
ZDU3MDQ5MmFjZWY4ODMxN2FjOGUwMy9kbWVzZy15b2N0by1pdmI0NC03MToyMDE0MDYwMjEz
NTIyODp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMDozLjE1LjAtcmM1LTAwMDg4
LWdmNzI4MDgwOjIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMC9m
NzI4MDgwZDZiYWM0N2FhYjJkNTcwNDkyYWNlZjg4MzE3YWM4ZTAzL2RtZXNnLXlvY3RvLWl2
YjQ0LTcyOjIwMTQwNjAyMTM1MjI4Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIxMTAw
OjMuMTUuMC1yYzUtMDAwODgtZ2Y3MjgwODA6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWhzeGEwLTA2MDIxMTAwL2Y3MjgwODBkNmJhYzQ3YWFiMmQ1NzA0OTJhY2VmODgzMTdhYzhl
MDMvZG1lc2ctcXVhbnRhbC1pdmI0NC00NDoyMDE0MDYwMjEzNTIzMjp4ODZfNjQtcmFuZGNv
bmZpZy1oc3hhMC0wNjAyMTEwMDozLjE1LjAtcmM1LTAwMDg4LWdmNzI4MDgwOjIKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMC9mNzI4MDgwZDZiYWM0N2FhYjJk
NTcwNDkyYWNlZjg4MzE3YWM4ZTAzL2RtZXNnLXlvY3RvLWl2YjQ0LTczOjIwMTQwNjAyMTM1
MjMzOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIxMTAwOjMuMTUuMC1yYzUtMDAwODgt
Z2Y3MjgwODA6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIxMTAwL2Y3
MjgwODBkNmJhYzQ3YWFiMmQ1NzA0OTJhY2VmODgzMTdhYzhlMDMvZG1lc2cteW9jdG8taXZi
NDQtNzQ6MjAxNDA2MDIxMzUyMzc6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDA6
My4xNS4wLXJjNS0wMDA4OC1nZjcyODA4MDoyCjA6MTU6MTUgYWxsX2dvb2Q6YmFkOmFsbF9i
YWQgYm9vdHMKG1sxOzM1bTIwMTQtMDYtMDIgMTM6NTI6NTYgUkVQRUFUIENPVU5UOiAyMCAg
IyAvYy9ib290LWJpc2VjdC9saW51eDYvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0
aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAwIHN0
ZXBzKQpbYjczOWM5OTgyODAxZTVmNzYwOTczMTFiNjdkZmQ3Njg5MWIxMDk4OF0gZHJtOiB0
YWtlIG1vZGVzZXQgbG9ja3MgYXJvdW5kIGluaXRpYWwgZmIgaGVscGVyIHByb2JpbmcKcnVu
bmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jv
b3QtYmlzZWN0L2xpbnV4Ni9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1
ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMC9saW51eC1kZXZlbDpk
ZXZlbC1ob3VybHktMjAxNDA2MDIxMDpiNzM5Yzk5ODI4MDFlNWY3NjA5NzMxMWI2N2RmZDc2
ODkxYjEwOTg4OmJpc2VjdC1saW51eDYKCjIwMTQtMDYtMDItMTM6NTI6NTYgYjczOWM5OTgy
ODAxZTVmNzYwOTczMTFiNjdkZmQ3Njg5MWIxMDk4OCBjb21waWxpbmcKUXVldWVkIGJ1aWxk
IHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMC0wNjAyMTEwMC1iNzM5Yzk5ODI4MDFlNWY3NjA5NzMxMWI2N2RmZDc2ODkxYjEwOTg4
CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0w
NjAyMTEwMC9iNzM5Yzk5ODI4MDFlNWY3NjA5NzMxMWI2N2RmZDc2ODkxYjEwOTg4CndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMC1iNzM5Yzk5ODI4MDFlNWY3NjA5NzMxMWI2N2Rm
ZDc2ODkxYjEwOTg4CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDAtYjczOWM5OTgy
ODAxZTVmNzYwOTczMTFiNjdkZmQ3Njg5MWIxMDk4OAprZXJuZWw6IC9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDAvYjczOWM5OTgyODAxZTVmNzYwOTczMTFiNjdk
ZmQ3Njg5MWIxMDk4OC92bWxpbnV6LTMuMTUuMC1yYzUtMDAwOTAtZ2I3MzljOTkKCjIwMTQt
MDYtMDItMTM6NTg6NTYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uIFRFU1QgRkFJTFVSRQpbICAgIDMuNzYwNjI5XSBbVFRNXSBJbml0aWFs
aXppbmcgRE1BIHBvb2wgYWxsb2NhdG9yClsgICAgMy43NjIwOTZdIApbICAgIDMuNzYyNTU3
XSA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KWyAgICAz
Ljc2MzAyNV0gWyBJTkZPOiBwb3NzaWJsZSByZWN1cnNpdmUgbG9ja2luZyBkZXRlY3RlZCBd
ClsgICAgMy43NjMwMjVdIDMuMTUuMC1yYzUtMDAwOTAtZ2I3MzljOTkgIzEgTm90IHRhaW50
ZWQKWyAgICAzLjc2MzAyNV0gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tClsgICAgMy43NjMwMjVdIHN3YXBwZXIvMC8xIGlzIHRyeWluZyB0byBhY3F1
aXJlIGxvY2s6ClsgICAgMy43NjMwMjVdICAoJmRldi0+bW9kZV9jb25maWcubXV0ZXgpeysu
Ky4rLn0sIGF0OiBbPGZmZmZmZmZmODE5MTkyNDU+XSBkcm1fbW9kZXNldF9sb2NrX2FsbCsw
eDM1LzB4ODAKWyAgICAzLjc2MzAyNV0gClsgICAgMy43NjMwMjVdIGJ1dCB0YXNrIGlzIGFs
cmVhZHkgaG9sZGluZyBsb2NrOgpbICAgIDMuNzYzMDI1XSAgKCZkZXYtPm1vZGVfY29uZmln
Lm11dGV4KXsrLisuKy59LCBhdDogWzxmZmZmZmZmZjgxOTAzYTE5Pl0gZHJtX2ZiX2hlbHBl
cl9pbml0aWFsX2NvbmZpZysweDExOS8weDczMApbICAgIDMuNzYzMDI1XSAKWyAgICAzLjc2
MzAyNV0gb3RoZXIgaW5mbyB0aGF0IG1pZ2h0IGhlbHAgdXMgZGVidWcgdGhpczoKWyAgICAz
Ljc2MzAyNV0gIFBvc3NpYmxlIHVuc2FmZSBsb2NraW5nIHNjZW5hcmlvOgpbICAgIDMuNzYz
MDI1XSAKWyAgICAzLjc2MzAyNV0gICAgICAgIENQVTAKWyAgICAzLjc2MzAyNV0gICAgICAg
IC0tLS0KWyAgICAzLjc2MzAyNV0gICBsb2NrKCZkZXYtPm1vZGVfY29uZmlnLm11dGV4KTsK
WyAgICAzLjc2MzAyNV0gICBsb2NrKCZkZXYtPm1vZGVfY29uZmlnLm11dGV4KTsKWyAgICAz
Ljc2MzAyNV0gClsgICAgMy43NjMwMjVdICAqKiogREVBRExPQ0sgKioqClsgICAgMy43NjMw
MjVdIApbICAgIDMuNzYzMDI1XSAgTWF5IGJlIGR1ZSB0byBtaXNzaW5nIGxvY2sgbmVzdGlu
ZyBub3RhdGlvbgpbICAgIDMuNzYzMDI1XSAKWyAgICAzLjc2MzAyNV0gNCBsb2NrcyBoZWxk
IGJ5IHN3YXBwZXIvMC8xOgpbICAgIDMuNzYzMDI1XSAgIzA6ICAoJmRldi0+bXV0ZXgpey4u
Li4uLn0sIGF0OiBbPGZmZmZmZmZmODFiNjMzNjM+XSBfX2RyaXZlcl9hdHRhY2grMHg3My8w
eDEwMApbICAgIDMuNzYzMDI1XSAgIzE6ICAoJmRldi0+bXV0ZXgpey4uLi4uLn0sIGF0OiBb
PGZmZmZmZmZmODFiNjMzNzk+XSBfX2RyaXZlcl9hdHRhY2grMHg4OS8weDEwMApbICAgIDMu
NzYzMDI1XSAgIzI6ICAoZHJtX2dsb2JhbF9tdXRleCl7Ky4rLisufSwgYXQ6IFs8ZmZmZmZm
ZmY4MTkxMjc4YT5dIGRybV9kZXZfcmVnaXN0ZXIrMHgyYS8weDFjMApbICAgIDMuNzYzMDI1
XSAgIzM6ICAoJmRldi0+bW9kZV9jb25maWcubXV0ZXgpeysuKy4rLn0sIGF0OiBbPGZmZmZm
ZmZmODE5MDNhMTk+XSBkcm1fZmJfaGVscGVyX2luaXRpYWxfY29uZmlnKzB4MTE5LzB4NzMw
ClsgICAgMy43NjMwMjVdIApbICAgIDMuNzYzMDI1XSBzdGFjayBiYWNrdHJhY2U6ClsgICAg
My43NjMwMjVdIENQVTogMSBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMu
MTUuMC1yYzUtMDAwOTAtZ2I3MzljOTkgIzEKWyAgICAzLjc2MzAyNV0gSGFyZHdhcmUgbmFt
ZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDMuNzYzMDI1XSAg
ZmZmZjg4MDAxMjE4MDdhOCBmZmZmODgwMDEyMTgzOWU4IGZmZmZmZmZmODI3NTI5MzUgZmZm
Zjg4MDAxMjE4MDAxMApbICAgIDMuNzYzMDI1XSAgZmZmZjg4MDAxMjE4M2E1OCBmZmZmZmZm
ZjgxMTNjMDI3IDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAxMjE4MDdhOApbICAgIDMuNzYz
MDI1XSAgZmZmZjg4MDAxMjE4M2E3OCBmZmZmZmZmZjAwMDAwMDAwIDI3ZTEzZjBkMjA2OWMz
NGUgMDAwMDAwMDAwMDAwMGEwMApbICAgIDMuNzYzMDI1XSBDYWxsIFRyYWNlOgpbICAgIDMu
NzYzMDI1XSAgWzxmZmZmZmZmZjgyNzUyOTM1Pl0gZHVtcF9zdGFjaysweDg1LzB4YmEKWyAg
ICAzLjc2MzAyNV0gIFs8ZmZmZmZmZmY4MTEzYzAyNz5dIF9fbG9ja19hY3F1aXJlKzB4MWYz
Ny8weDIyYzAKWyAgICAzLjc2MzAyNV0gIFs8ZmZmZmZmZmY4MTEzYzQ5Yj5dIGxvY2tfYWNx
dWlyZSsweGViLzB4MWMwClsgICAgMy43NjMwMjVdICBbPGZmZmZmZmZmODE5MTkyNDU+XSA/
IGRybV9tb2Rlc2V0X2xvY2tfYWxsKzB4MzUvMHg4MApbICAgIDMuNzYzMDI1XSAgWzxmZmZm
ZmZmZjgyNzZhZDM1Pl0gbXV0ZXhfbG9ja19uZXN0ZWQrMHg4NS8weDYwMApbICAgIDMuNzYz
MDI1XSAgWzxmZmZmZmZmZjgxOTE5MjQ1Pl0gPyBkcm1fbW9kZXNldF9sb2NrX2FsbCsweDM1
LzB4ODAKWyAgICAzLjc2MzAyNV0gIFs8ZmZmZmZmZmY4MTEzNzhhZD5dID8gdHJhY2VfaGFy
ZGlycXNfb24rMHgxZC8weDMwClsgICAgMy43NjMwMjVdICBbPGZmZmZmZmZmODE5MDNhMTk+
XSA/IGRybV9mYl9oZWxwZXJfaW5pdGlhbF9jb25maWcrMHgxMTkvMHg3MzAKWyAgICAzLjc2
MzAyNV0gIFs8ZmZmZmZmZmY4MTcxYTI0Yj5dID8gZmJfZ2V0X29wdGlvbnMrMHgyYi8weDI0
MApbICAgIDMuNzYzMDI1XSAgWzxmZmZmZmZmZjgxOTE5MjQ1Pl0gZHJtX21vZGVzZXRfbG9j
a19hbGwrMHgzNS8weDgwClsgICAgMy43NjMwMjVdICBbPGZmZmZmZmZmODE5MDNhMjk+XSBk
cm1fZmJfaGVscGVyX2luaXRpYWxfY29uZmlnKzB4MTI5LzB4NzMwClsgICAgMy43NjMwMjVd
ICBbPGZmZmZmZmZmODExMzc4YWQ+XSA/IHRyYWNlX2hhcmRpcnFzX29uKzB4MWQvMHgzMApb
ICAgIDMuNzYzMDI1XSAgWzxmZmZmZmZmZjgxOTE5MmZhPl0gPyBkcm1fbW9kZXNldF91bmxv
Y2tfYWxsKzB4NmEvMHg4MApbICAgIDMuNzYzMDI1XSAgWzxmZmZmZmZmZjgxYTBiNDJkPl0g
Y2lycnVzX2ZiZGV2X2luaXQrMHhjZC8weDExMApbICAgIDMuNzYzMDI1XSAgWzxmZmZmZmZm
ZjgxYTBhNzQ0Pl0gY2lycnVzX21vZGVzZXRfaW5pdCsweDIzNC8weDJkMApbICAgIDMuNzYz
MDI1XSAgWzxmZmZmZmZmZjgxYTA4ZDQ2Pl0gY2lycnVzX2RyaXZlcl9sb2FkKzB4OTYvMHgx
YTAKWyAgICAzLjc2MzAyNV0gIFs8ZmZmZmZmZmY4MTkxMjg3NT5dIGRybV9kZXZfcmVnaXN0
ZXIrMHgxMTUvMHgxYzAKWyAgICAzLjc2MzAyNV0gIFs8ZmZmZmZmZmY4MTkxNTllOD5dIGRy
bV9nZXRfcGNpX2RldisweDEzOC8weDMyMApbICAgIDMuNzYzMDI1XSAgWzxmZmZmZmZmZjgx
MTM3OGFkPl0gPyB0cmFjZV9oYXJkaXJxc19vbisweDFkLzB4MzAKWyAgICAzLjc2MzAyNV0g
IFs8ZmZmZmZmZmY4MWEwYTk3NT5dIGNpcnJ1c19wY2lfcHJvYmUrMHgxMDUvMHgxNDAKWyAg
ICAzLjc2MzAyNV0gIFs8ZmZmZmZmZmY4MTZjMDg0MD5dIHBjaV9kZXZpY2VfcHJvYmUrMHhl
MC8weDFjMApbICAgIDMuNzYzMDI1XSAgWzxmZmZmZmZmZjgxYjYyZTNjPl0gZHJpdmVyX3By
b2JlX2RldmljZSsweGNjLzB4NTgwClsgICAgMy43NjMwMjVdICBbPGZmZmZmZmZmODFiNjMz
ZGI+XSBfX2RyaXZlcl9hdHRhY2grMHhlYi8weDEwMApbICAgIDMuNzYzMDI1XSAgWzxmZmZm
ZmZmZjgxYjYzMmYwPl0gPyBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4NTgwLzB4NTgwClsgICAg
My43NjMwMjVdICBbPGZmZmZmZmZmODFiNWZmNzM+XSBidXNfZm9yX2VhY2hfZGV2KzB4YjMv
MHgxMTAKWyAgICAzLjc2MzAyNV0gIFs8ZmZmZmZmZmY4MWI2Mjk3Nj5dIGRyaXZlcl9hdHRh
Y2grMHgyNi8weDMwClsgICAgMy43NjMwMjVdICBbPGZmZmZmZmZmODFiNjEwNDg+XSBidXNf
YWRkX2RyaXZlcisweDIwOC8weDM5MApbICAgIDMuNzYzMDI1XSAgWzxmZmZmZmZmZjgzYzZm
NWUwPl0gPyBpbnRlbF9ub19sdmRzX2RtaV9jYWxsYmFjaysweDJiLzB4MmIKWyAgICAzLjc2
MzAyNV0gIFs8ZmZmZmZmZmY4MWI2M2E3MD5dIGRyaXZlcl9yZWdpc3RlcisweGIwLzB4MWEw
ClsgICAgMy43NjMwMjVdICBbPGZmZmZmZmZmODNjNmY1ZTA+XSA/IGludGVsX25vX2x2ZHNf
ZG1pX2NhbGxiYWNrKzB4MmIvMHgyYgpbICAgIDMuNzYzMDI1XSAgWzxmZmZmZmZmZjgxNmMw
OThkPl0gX19wY2lfcmVnaXN0ZXJfZHJpdmVyKzB4NmQvMHg4MApbICAgIDMuNzYzMDI1XSAg
WzxmZmZmZmZmZjgxOTE1ZDE5Pl0gZHJtX3BjaV9pbml0KzB4MTQ5LzB4MTgwClsgICAgMy43
NjMwMjVdICBbPGZmZmZmZmZmODNjNmY1ZTA+XSA/IGludGVsX25vX2x2ZHNfZG1pX2NhbGxi
YWNrKzB4MmIvMHgyYgpbICAgIDMuNzYzMDI1XSAgWzxmZmZmZmZmZjgzYzZmNjQzPl0gY2ly
cnVzX2luaXQrMHg2My8weDZjClsgICAgMy43NjMwMjVdICBbPGZmZmZmZmZmODNjMDg1ZTU+
XSBkb19vbmVfaW5pdGNhbGwrMHhlOC8weDFjYwpbICAgIDMuNzYzMDI1XSAgWzxmZmZmZmZm
ZjgxMTAxNjQ1Pl0gPyBwYXJzZV9hcmdzKzB4MmE1LzB4NWMwClsgICAgMy43NjMwMjVdICBb
PGZmZmZmZmZmODNjMDg4OTM+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDFjYS8weDJjOQpb
ICAgIDMuNzYzMDI1XSAgWzxmZmZmZmZmZjgzYzA3YWQ3Pl0gPyBkb19lYXJseV9wYXJhbSsw
eGQ3LzB4ZDcKWyAgICAzLjc2MzAyNV0gIFs8ZmZmZmZmZmY4MjczZmRlMD5dID8gcmVzdF9p
bml0KzB4MTIwLzB4MTIwClsgICAgMy43NjMwMjVdICBbPGZmZmZmZmZmODI3M2ZkZjY+XSBr
ZXJuZWxfaW5pdCsweDE2LzB4MWIwClsgICAgMy43NjMwMjVdICBbPGZmZmZmZmZmODI3NzFk
ZmM+XSByZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApbICAgIDMuNzYzMDI1XSAgWzxmZmZmZmZm
ZjgyNzNmZGUwPl0gPyByZXN0X2luaXQrMHgxMjAvMHgxMjAKWyAgIDYyLjE3MzAzNl0gc3Bp
bl9sb2NrLXRvcnR1cmU6IFdyaXRlczogIFRvdGFsOiA0ICBNYXgvTWluOiAwLzAgICBGYWls
OiAwIApbICAxMzEuNjMyMDczXSBzcGluX2xvY2stdG9ydHVyZTogV3JpdGVzOiAgVG90YWw6
IDQgIE1heC9NaW46IDAvMCAgIEZhaWw6IDAgClsgIDE5MS42MzMwNjJdIHNwaW5fbG9jay10
b3J0dXJlOiBXcml0ZXM6ICBUb3RhbDogNCAgTWF4L01pbjogMC8wICAgRmFpbDogMCAKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMC9iNzM5Yzk5ODI4MDFlNWY3
NjA5NzMxMWI2N2RmZDc2ODkxYjEwOTg4L2RtZXNnLXF1YW50YWwtaXZiNDEtMTAxOjIwMTQw
NjAyMTQxMzQ2Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIxMTAwOjMuMTUuMC1yYzUt
MDAwOTAtZ2I3MzljOTk6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIx
MTAwL2I3MzljOTk4MjgwMWU1Zjc2MDk3MzExYjY3ZGZkNzY4OTFiMTA5ODgvZG1lc2ctcXVh
bnRhbC1pdmI0MS0xMTI6MjAxNDA2MDIxNDEzNDY6eDg2XzY0LXJhbmRjb25maWctaHN4YTAt
MDYwMjExMDA6My4xNS4wLXJjNS0wMDA5MC1nYjczOWM5OToxCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctaHN4YTAtMDYwMjExMDAvYjczOWM5OTgyODAxZTVmNzYwOTczMTFiNjdkZmQ3
Njg5MWIxMDk4OC9kbWVzZy1xdWFudGFsLWl2YjQxLTExNzoyMDE0MDYwMjE0MTM0Njp4ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMDozLjE1LjAtcmM1LTAwMDkwLWdiNzM5Yzk5
OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMC9iNzM5Yzk5ODI4
MDFlNWY3NjA5NzMxMWI2N2RmZDc2ODkxYjEwOTg4L2RtZXNnLXF1YW50YWwtaXZiNDEtODA6
MjAxNDA2MDIxNDEzNDY6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDA6My4xNS4w
LXJjNS0wMDA5MC1nYjczOWM5OToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAt
MDYwMjExMDAvYjczOWM5OTgyODAxZTVmNzYwOTczMTFiNjdkZmQ3Njg5MWIxMDk4OC9kbWVz
Zy1xdWFudGFsLWl2YjQyLTEyMzoyMDE0MDYwMjE0MTM0Mzp4ODZfNjQtcmFuZGNvbmZpZy1o
c3hhMC0wNjAyMTEwMDozLjE1LjAtcmM1LTAwMDkwLWdiNzM5Yzk5OjEKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMC9iNzM5Yzk5ODI4MDFlNWY3NjA5NzMxMWI2
N2RmZDc2ODkxYjEwOTg4L2RtZXNnLXF1YW50YWwtaXZiNDItMjU6MjAxNDA2MDIxNDEzNDM6
eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDA6My4xNS4wLXJjNS0wMDA5MC1nYjcz
OWM5OToxCjA6Njo1IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpiNzM5Yzk5ODI4MDFl
NWY3NjA5NzMxMWI2N2RmZDc2ODkxYjEwOTg4IGlzIHRoZSBmaXJzdCBiYWQgY29tbWl0CmNv
bW1pdCBiNzM5Yzk5ODI4MDFlNWY3NjA5NzMxMWI2N2RmZDc2ODkxYjEwOTg4CkF1dGhvcjog
SmVzc2UgQmFybmVzIDxqYmFybmVzQHZpcnR1b3VzZ2Vlay5vcmc+CkRhdGU6ICAgV2VkIE1h
eSAyOCAxMDoyMToxNyAyMDE0IC0wNzAwCgogICAgZHJtOiB0YWtlIG1vZGVzZXQgbG9ja3Mg
YXJvdW5kIGluaXRpYWwgZmIgaGVscGVyIHByb2JpbmcKICAgIAogICAgRHJpdmVycyBvdWdo
dCB0byBjb21wbGFpbiBvdGhlcndpc2UuCiAgICAKICAgIFNpZ25lZC1vZmYtYnk6IEplc3Nl
IEJhcm5lcyA8amJhcm5lc0B2aXJ0dW91c2dlZWsub3JnPgoKOjA0MDAwMCAwNDAwMDAgMGM1
YjZjMTVkY2I3YjkyZjNmYWZmODg1NzY2M2Q4MGI3ODNjOTkwZSA4MzhmMjcyNzkwMWM1ZTc0
ZDRkMmE5Y2Y1YWJlYTdiMmI0MGNjNzcxIE0JZHJpdmVycwpiaXNlY3QgcnVuIHN1Y2Nlc3MK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgYjczOWM5OS4uLiBkcm06IHRha2UgbW9kZXNl
dCBsb2NrcyBhcm91bmQgaW5pdGlhbCBmYiBoZWxwZXIgcHJvYmluZwpIRUFEIGlzIG5vdyBh
dCAwNzFmOWM1Li4uIGRybS9pOTE1L3ZsdjogZW5hYmxlIFBQR1RUCmxzIC1hIC9rYnVpbGQt
dGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMC9s
aW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA2MDIxMDowNzFmOWM1N2VlYTQ4NzYyODhi
YTEyNTRjOWFjM2IwZjA3N2MyZGQ2OmJpc2VjdC1saW51eDYKCjIwMTQtMDYtMDItMTQ6MTQ6
MDEgMDcxZjljNTdlZWE0ODc2Mjg4YmExMjU0YzlhYzNiMGYwNzdjMmRkNiBjb21waWxpbmcK
UXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQt
cmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMC0wNzFmOWM1N2VlYTQ4NzYyODhiYTEyNTRjOWFj
M2IwZjA3N2MyZGQ2CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1oc3hhMC0wNjAyMTEwMC8wNzFmOWM1N2VlYTQ4NzYyODhiYTEyNTRjOWFjM2IwZjA3
N2MyZGQ2CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMC0wNzFmOWM1N2VlYTQ4NzYy
ODhiYTEyNTRjOWFjM2IwZjA3N2MyZGQ2CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2ti
dWlsZC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjEx
MDAtMDcxZjljNTdlZWE0ODc2Mjg4YmExMjU0YzlhYzNiMGYwNzdjMmRkNgprZXJuZWw6IC9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDAvMDcxZjljNTdlZWE0ODc2
Mjg4YmExMjU0YzlhYzNiMGYwNzdjMmRkNi92bWxpbnV6LTMuMTUuMC1yYzUtMDAwODYtZzA3
MWY5YzUKCjIwMTQtMDYtMDItMTQ6MjY6MDEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4J
MTYJMzUJNTQJNjAgU1VDQ0VTUwoKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgMDcxZjlj
NS4uLiBkcm0vaTkxNS92bHY6IGVuYWJsZSBQUEdUVApIRUFEIGlzIG5vdyBhdCA1ZGJhMDI0
Li4uIDBkYXkgaGVhZCBndWFyZCBmb3IgJ2RldmVsLWhvdXJseS0yMDE0MDYwMjEwJwpscyAt
YSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaHN4YTAt
MDYwMjExMDAvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNjAyMTA6NWRiYTAyNGZl
ODRhNDkxZWMzY2ExNTE5MzkyM2ZjYmI5MzhlNjhmNzpiaXNlY3QtbGludXg2CiBURVNUIEZB
SUxVUkUKWyAgICA0LjkyODM3M10gW1RUTV0gSW5pdGlhbGl6aW5nIERNQSBwb29sIGFsbG9j
YXRvcgpbICAgIDQuOTMwMTA5XSAKWyAgICA0LjkzMDc4OV0gPT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09ClsgICAgNC45MzEwNTBdIFsgSU5GTzogcG9z
c2libGUgcmVjdXJzaXZlIGxvY2tpbmcgZGV0ZWN0ZWQgXQpbICAgIDQuOTMxMDUwXSAzLjE1
LjAtcmM4LTAyMTQ5LWc1ZGJhMDI0ICM0IE5vdCB0YWludGVkClsgICAgNC45MzQwMjZdIC0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpbICAgIDQuOTM0
MDI2XSBzd2FwcGVyLzAvMSBpcyB0cnlpbmcgdG8gYWNxdWlyZSBsb2NrOgpbICAgIDQuOTM0
MDI2XSAgKCZkZXYtPm1vZGVfY29uZmlnLm11dGV4KXsrLisuKy59LCBhdDogWzxmZmZmZmZm
ZjgxOTFkYjE1Pl0gZHJtX21vZGVzZXRfbG9ja19hbGwrMHgzNS8weDgwClsgICAgNC45MzQw
MjZdIApbICAgIDQuOTM0MDI2XSBidXQgdGFzayBpcyBhbHJlYWR5IGhvbGRpbmcgbG9jazoK
WyAgICA0LjkzNDAyNl0gICgmZGV2LT5tb2RlX2NvbmZpZy5tdXRleCl7Ky4rLisufSwgYXQ6
IFs8ZmZmZmZmZmY4MTkwODJlOT5dIGRybV9mYl9oZWxwZXJfaW5pdGlhbF9jb25maWcrMHgx
MTkvMHg3MzAKWyAgICA0LjkzNDAyNl0gClsgICAgNC45MzQwMjZdIG90aGVyIGluZm8gdGhh
dCBtaWdodCBoZWxwIHVzIGRlYnVnIHRoaXM6ClsgICAgNC45MzQwMjZdICBQb3NzaWJsZSB1
bnNhZmUgbG9ja2luZyBzY2VuYXJpbzoKWyAgICA0LjkzNDAyNl0gClsgICAgNC45MzQwMjZd
ICAgICAgICBDUFUwClsgICAgNC45MzQwMjZdICAgICAgICAtLS0tClsgICAgNC45MzQwMjZd
ICAgbG9jaygmZGV2LT5tb2RlX2NvbmZpZy5tdXRleCk7ClsgICAgNC45MzQwMjZdICAgbG9j
aygmZGV2LT5tb2RlX2NvbmZpZy5tdXRleCk7ClsgICAgNC45MzQwMjZdIApbICAgIDQuOTM0
MDI2XSAgKioqIERFQURMT0NLICoqKgpbICAgIDQuOTM0MDI2XSAKWyAgICA0LjkzNDAyNl0g
IE1heSBiZSBkdWUgdG8gbWlzc2luZyBsb2NrIG5lc3Rpbmcgbm90YXRpb24KWyAgICA0Ljkz
NDAyNl0gClsgICAgNC45MzQwMjZdIDQgbG9ja3MgaGVsZCBieSBzd2FwcGVyLzAvMToKWyAg
ICA0LjkzNDAyNl0gICMwOiAgKCZkZXYtPm11dGV4KXsuLi4uLi59LCBhdDogWzxmZmZmZmZm
ZjgxYjY4MTIzPl0gX19kcml2ZXJfYXR0YWNoKzB4NzMvMHgxMDAKWyAgICA0LjkzNDAyNl0g
ICMxOiAgKCZkZXYtPm11dGV4KXsuLi4uLi59LCBhdDogWzxmZmZmZmZmZjgxYjY4MTM5Pl0g
X19kcml2ZXJfYXR0YWNoKzB4ODkvMHgxMDAKWyAgICA0LjkzNDAyNl0gICMyOiAgKGRybV9n
bG9iYWxfbXV0ZXgpeysuKy4rLn0sIGF0OiBbPGZmZmZmZmZmODE5MTcwNWE+XSBkcm1fZGV2
X3JlZ2lzdGVyKzB4MmEvMHgxYzAKWyAgICA0LjkzNDAyNl0gICMzOiAgKCZkZXYtPm1vZGVf
Y29uZmlnLm11dGV4KXsrLisuKy59LCBhdDogWzxmZmZmZmZmZjgxOTA4MmU5Pl0gZHJtX2Zi
X2hlbHBlcl9pbml0aWFsX2NvbmZpZysweDExOS8weDczMApbICAgIDQuOTM0MDI2XSAKWyAg
ICA0LjkzNDAyNl0gc3RhY2sgYmFja3RyYWNlOgpbICAgIDQuOTM0MDI2XSBDUFU6IDEgUElE
OiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE1LjAtcmM4LTAyMTQ5LWc1ZGJh
MDI0ICM0ClsgICAgNC45MzQwMjZdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9T
IEJvY2hzIDAxLzAxLzIwMTEKWyAgICA0LjkzNDAyNl0gIGZmZmY4ODAwMTIxODA3YjAgZmZm
Zjg4MDAxMjE4NzllOCBmZmZmZmZmZjgyNzVjZTE1IGZmZmY4ODAwMTIxODAwMTAKWyAgICA0
LjkzNDAyNl0gIGZmZmY4ODAwMTIxODdhNTggZmZmZmZmZmY4MTEzYzkxMSAwMDAwMDAwMDAw
MDAwMDAwIGZmZmY4ODAwMTIxODA3YjAKWyAgICA0LjkzNDAyNl0gIGZmZmY4ODAwMTIxODdh
NzggZmZmZmZmZmYwMDAwMDAwMCAyN2QxM2U4ZDI0NjllMzRmIDAwMDAwMDAwMDAwMDBhMDAK
WyAgICA0LjkzNDAyNl0gQ2FsbCBUcmFjZToKWyAgICA0LjkzNDAyNl0gIFs8ZmZmZmZmZmY4
Mjc1Y2UxNT5dIGR1bXBfc3RhY2srMHg4NS8weGJhClsgICAgNC45MzQwMjZdICBbPGZmZmZm
ZmZmODExM2M5MTE+XSBfX2xvY2tfYWNxdWlyZSsweDFmNDEvMHgyMmQwClsgICAgNC45MzQw
MjZdICBbPGZmZmZmZmZmODExM2NkOGI+XSBsb2NrX2FjcXVpcmUrMHhlYi8weDFjMApbICAg
IDQuOTM0MDI2XSAgWzxmZmZmZmZmZjgxOTFkYjE1Pl0gPyBkcm1fbW9kZXNldF9sb2NrX2Fs
bCsweDM1LzB4ODAKWyAgICA0LjkzNDAyNl0gIFs8ZmZmZmZmZmY4Mjc3NTI0NT5dIG11dGV4
X2xvY2tfbmVzdGVkKzB4ODUvMHg2MDAKWyAgICA0LjkzNDAyNl0gIFs8ZmZmZmZmZmY4MTkx
ZGIxNT5dID8gZHJtX21vZGVzZXRfbG9ja19hbGwrMHgzNS8weDgwClsgICAgNC45MzQwMjZd
ICBbPGZmZmZmZmZmODExMzgxOGQ+XSA/IHRyYWNlX2hhcmRpcnFzX29uKzB4MWQvMHgzMApb
ICAgIDQuOTM0MDI2XSAgWzxmZmZmZmZmZjgxOTA4MmU5Pl0gPyBkcm1fZmJfaGVscGVyX2lu
aXRpYWxfY29uZmlnKzB4MTE5LzB4NzMwClsgICAgNC45MzQwMjZdICBbPGZmZmZmZmZmODE3
MWIzMmI+XSA/IGZiX2dldF9vcHRpb25zKzB4MmIvMHgyNDAKWyAgICA0LjkzNDAyNl0gIFs8
ZmZmZmZmZmY4MTkxZGIxNT5dIGRybV9tb2Rlc2V0X2xvY2tfYWxsKzB4MzUvMHg4MApbICAg
IDQuOTM0MDI2XSAgWzxmZmZmZmZmZjgxOTA4MmY5Pl0gZHJtX2ZiX2hlbHBlcl9pbml0aWFs
X2NvbmZpZysweDEyOS8weDczMApbICAgIDQuOTM0MDI2XSAgWzxmZmZmZmZmZjgxMTM4MThk
Pl0gPyB0cmFjZV9oYXJkaXJxc19vbisweDFkLzB4MzAKWyAgICA0LjkzNDAyNl0gIFs8ZmZm
ZmZmZmY4MTkxZGJjYT5dID8gZHJtX21vZGVzZXRfdW5sb2NrX2FsbCsweDZhLzB4ODAKWyAg
ICA0LjkzNDAyNl0gIFs8ZmZmZmZmZmY4MWExMDFlZD5dIGNpcnJ1c19mYmRldl9pbml0KzB4
Y2QvMHgxMTAKWyAgICA0LjkzNDAyNl0gIFs8ZmZmZmZmZmY4MWEwZjUwND5dIGNpcnJ1c19t
b2Rlc2V0X2luaXQrMHgyMzQvMHgyZDAKWyAgICA0LjkzNDAyNl0gIFs8ZmZmZmZmZmY4MWEw
ZGIwNj5dIGNpcnJ1c19kcml2ZXJfbG9hZCsweDk2LzB4MWEwClsgICAgNC45MzQwMjZdICBb
PGZmZmZmZmZmODE5MTcxNDU+XSBkcm1fZGV2X3JlZ2lzdGVyKzB4MTE1LzB4MWMwClsgICAg
NC45MzQwMjZdICBbPGZmZmZmZmZmODE5MWEyYjg+XSBkcm1fZ2V0X3BjaV9kZXYrMHgxMzgv
MHgzMjAKWyAgICA0LjkzNDAyNl0gIFs8ZmZmZmZmZmY4MTEzODE4ZD5dID8gdHJhY2VfaGFy
ZGlycXNfb24rMHgxZC8weDMwClsgICAgNC45MzQwMjZdICBbPGZmZmZmZmZmODFhMGY3MzU+
XSBjaXJydXNfcGNpX3Byb2JlKzB4MTA1LzB4MTQwClsgICAgNC45MzQwMjZdICBbPGZmZmZm
ZmZmODE2YzE5MjA+XSBwY2lfZGV2aWNlX3Byb2JlKzB4ZTAvMHgxYzAKWyAgICA0LjkzNDAy
Nl0gIFs8ZmZmZmZmZmY4MWI2N2JmYz5dIGRyaXZlcl9wcm9iZV9kZXZpY2UrMHhjYy8weDU4
MApbICAgIDQuOTM0MDI2XSAgWzxmZmZmZmZmZjgxYjY4MTliPl0gX19kcml2ZXJfYXR0YWNo
KzB4ZWIvMHgxMDAKWyAgICA0LjkzNDAyNl0gIFs8ZmZmZmZmZmY4MWI2ODBiMD5dID8gZHJp
dmVyX3Byb2JlX2RldmljZSsweDU4MC8weDU4MApbICAgIDQuOTM0MDI2XSAgWzxmZmZmZmZm
ZjgxYjY0ZDMzPl0gYnVzX2Zvcl9lYWNoX2RldisweGIzLzB4MTEwClsgICAgNC45MzQwMjZd
ICBbPGZmZmZmZmZmODFiNjc3MzY+XSBkcml2ZXJfYXR0YWNoKzB4MjYvMHgzMApbICAgIDQu
OTM0MDI2XSAgWzxmZmZmZmZmZjgxYjY1ZTA4Pl0gYnVzX2FkZF9kcml2ZXIrMHgyMDgvMHgz
OTAKWyAgICA0LjkzNDAyNl0gIFs8ZmZmZmZmZmY4M2M3NTYyMD5dID8gaW50ZWxfbm9fbHZk
c19kbWlfY2FsbGJhY2srMHgyYi8weDJiClsgICAgNC45MzQwMjZdICBbPGZmZmZmZmZmODFi
Njg4MzA+XSBkcml2ZXJfcmVnaXN0ZXIrMHhiMC8weDFhMApbICAgIDQuOTM0MDI2XSAgWzxm
ZmZmZmZmZjgzYzc1NjIwPl0gPyBpbnRlbF9ub19sdmRzX2RtaV9jYWxsYmFjaysweDJiLzB4
MmIKWyAgICA0LjkzNDAyNl0gIFs8ZmZmZmZmZmY4MTZjMWE2ZD5dIF9fcGNpX3JlZ2lzdGVy
X2RyaXZlcisweDZkLzB4ODAKWyAgICA0LjkzNDAyNl0gIFs8ZmZmZmZmZmY4MTkxYTVlOT5d
IGRybV9wY2lfaW5pdCsweDE0OS8weDE4MApbICAgIDQuOTM0MDI2XSAgWzxmZmZmZmZmZjgz
Yzc1NjIwPl0gPyBpbnRlbF9ub19sdmRzX2RtaV9jYWxsYmFjaysweDJiLzB4MmIKWyAgICA0
LjkzNDAyNl0gIFs8ZmZmZmZmZmY4M2M3NTY4Mz5dIGNpcnJ1c19pbml0KzB4NjMvMHg2Ywpb
ICAgIDQuOTM0MDI2XSAgWzxmZmZmZmZmZjgzYzBlNWU1Pl0gZG9fb25lX2luaXRjYWxsKzB4
ZTgvMHgxY2MKWyAgICA0LjkzNDAyNl0gIFs8ZmZmZmZmZmY4MTEwMWRlNT5dID8gcGFyc2Vf
YXJncysweDJhNS8weDVjMApbICAgIDQuOTM0MDI2XSAgWzxmZmZmZmZmZjgzYzBlODkzPl0g
a2VybmVsX2luaXRfZnJlZWFibGUrMHgxY2EvMHgyYzkKWyAgICA0LjkzNDAyNl0gIFs8ZmZm
ZmZmZmY4M2MwZGFkNz5dID8gZG9fZWFybHlfcGFyYW0rMHhkNy8weGQ3ClsgICAgNC45MzQw
MjZdICBbPGZmZmZmZmZmODI3NGEyYzA+XSA/IHJlc3RfaW5pdCsweDEyMC8weDEyMApbICAg
IDQuOTM0MDI2XSAgWzxmZmZmZmZmZjgyNzRhMmQ2Pl0ga2VybmVsX2luaXQrMHgxNi8weDFi
MApbICAgIDQuOTM0MDI2XSAgWzxmZmZmZmZmZjgyNzdjMmZjPl0gcmV0X2Zyb21fZm9yaysw
eDdjLzB4YjAKWyAgICA0LjkzNDAyNl0gIFs8ZmZmZmZmZmY4Mjc0YTJjMD5dID8gcmVzdF9p
bml0KzB4MTIwLzB4MTIwClsgICA2MS42OTgxMjJdIHNwaW5fbG9jay10b3J0dXJlOiBXcml0
ZXM6ICBUb3RhbDogNCAgTWF4L01pbjogMC8wICAgRmFpbDogMCAKWyAgMTIxLjY5OTA5N10g
c3Bpbl9sb2NrLXRvcnR1cmU6IFdyaXRlczogIFRvdGFsOiA0ICBNYXgvTWluOiAwLzAgICBG
YWlsOiAwIApbICAxODEuNzAwMTEzXSBzcGluX2xvY2stdG9ydHVyZTogV3JpdGVzOiAgVG90
YWw6IDQgIE1heC9NaW46IDAvMCAgIEZhaWw6IDAgCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDYwMjExMDAvNWRiYTAyNGZlODRhNDkxZWMzY2ExNTE5MzkyM2ZjYmI5Mzhl
NjhmNy9kbWVzZy15b2N0by1pdmI0NC04NzoyMDE0MDYwMjExMzkxMTp4ODZfNjQtcmFuZGNv
bmZpZy1oc3hhMC0wNjAyMTEwMDozLjE1LjAtcmM4LTAyMTQ5LWc1ZGJhMDI0OjQKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMC81ZGJhMDI0ZmU4NGE0OTFlYzNj
YTE1MTkzOTIzZmNiYjkzOGU2OGY3L2RtZXNnLXlvY3RvLWl2YjQzLTgyOjIwMTQwNjAyMTEx
ODM1Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIxMTAwOjMuMTUuMC1yYzgtMDIxNDkt
ZzVkYmEwMjQ6NAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIxMTAwLzVk
YmEwMjRmZTg0YTQ5MWVjM2NhMTUxOTM5MjNmY2JiOTM4ZTY4ZjcvZG1lc2ctcXVhbnRhbC1p
dmI0NC05NToyMDE0MDYwMjExMTgzMzp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEw
MDozLjE1LjAtcmM4LTAyMTQ5LWc1ZGJhMDI0OjQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMC0wNjAyMTEwMC81ZGJhMDI0ZmU4NGE0OTFlYzNjYTE1MTkzOTIzZmNiYjkzOGU2
OGY3L2RtZXNnLXF1YW50YWwtaXZiNDEtMTg6MjAxNDA2MDIxMTM5MDU6eDg2XzY0LXJhbmRj
b25maWctaHN4YTAtMDYwMjExMDA6My4xNS4wLXJjOC0wMjE0OS1nNWRiYTAyNDo0Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDAvNWRiYTAyNGZlODRhNDkxZWMz
Y2ExNTE5MzkyM2ZjYmI5MzhlNjhmNy9kbWVzZy1xdWFudGFsLWl2YjQzLTQ6MjAxNDA2MDIx
MTM5MDU6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDA6My4xNS4wLXJjOC0wMjE0
OS1nNWRiYTAyNDo0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDAv
NWRiYTAyNGZlODRhNDkxZWMzY2ExNTE5MzkyM2ZjYmI5MzhlNjhmNy9kbWVzZy1xdWFudGFs
LWl2YjQxLTI0OjIwMTQwNjAyMTExODQyOng4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIx
MTAwOjMuMTUuMC1yYzgtMDIxNDktZzVkYmEwMjQ6NAova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWhzeGEwLTA2MDIxMTAwLzVkYmEwMjRmZTg0YTQ5MWVjM2NhMTUxOTM5MjNmY2JiOTM4
ZTY4ZjcvZG1lc2cteW9jdG8taXZiNDQtMTI1OjIwMTQwNjAyMTEzOTEyOng4Nl82NC1yYW5k
Y29uZmlnLWhzeGEwLTA2MDIxMTAwOjMuMTUuMC1yYzgtMDIxNDktZzVkYmEwMjQ6NAova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIxMTAwLzVkYmEwMjRmZTg0YTQ5MWVj
M2NhMTUxOTM5MjNmY2JiOTM4ZTY4ZjcvZG1lc2cteW9jdG8taXZiNDMtMTE4OjIwMTQwNjAy
MTEzOTA0Ong4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIxMTAwOjMuMTUuMC1yYzgtMDIx
NDktZzVkYmEwMjQ6NAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIxMTAw
LzVkYmEwMjRmZTg0YTQ5MWVjM2NhMTUxOTM5MjNmY2JiOTM4ZTY4ZjcvZG1lc2cteW9jdG8t
aXZiNDEtMzM6MjAxNDA2MDIxMTM5MDU6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjEx
MDA6My4xNS4wLXJjOC0wMjE0OS1nNWRiYTAyNDo0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaHN4YTAtMDYwMjExMDAvNWRiYTAyNGZlODRhNDkxZWMzY2ExNTE5MzkyM2ZjYmI5Mzhl
NjhmNy9kbWVzZy15b2N0by1pdmI0My05NDoyMDE0MDYwMjExMzkwNDp4ODZfNjQtcmFuZGNv
bmZpZy1oc3hhMC0wNjAyMTEwMDozLjE1LjAtcmM4LTAyMTQ5LWc1ZGJhMDI0OjQKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMC81ZGJhMDI0ZmU4NGE0OTFlYzNj
YTE1MTkzOTIzZmNiYjkzOGU2OGY3L2RtZXNnLXF1YW50YWwtaXZiNDEtODk6MjAxNDA2MDIx
MTM5MTA6eDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDA6My4xNS4wLXJjOC0wMjE0
OS1nNWRiYTAyNDo0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHN4YTAtMDYwMjExMDAv
NWRiYTAyNGZlODRhNDkxZWMzY2ExNTE5MzkyM2ZjYmI5MzhlNjhmNy9kbWVzZy15b2N0by1p
dmI0MS01NDoyMDE0MDYwMjExMzkwNDp4ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEw
MDozLjE1LjAtcmM4LTAyMTQ5LWc1ZGJhMDI0OjQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1oc3hhMC0wNjAyMTEwMC81ZGJhMDI0ZmU4NGE0OTFlYzNjYTE1MTkzOTIzZmNiYjkzOGU2
OGY3L2RtZXNnLXlvY3RvLWl2YjQ0LTk3OjIwMTQwNjAyMTEzOTExOng4Nl82NC1yYW5kY29u
ZmlnLWhzeGEwLTA2MDIxMTAwOjMuMTUuMC1yYzgtMDIxNDktZzVkYmEwMjQ6NAowOjEzOjEz
IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpIRUFEIGlzIG5vdyBhdCA1ZGJhMDI0IDBk
YXkgaGVhZCBndWFyZCBmb3IgJ2RldmVsLWhvdXJseS0yMDE0MDYwMjEwJwoKPT09PT09PT09
IHVwc3RyZWFtID09PT09PT09PQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA1ZGJhMDI0
Li4uIDBkYXkgaGVhZCBndWFyZCBmb3IgJ2RldmVsLWhvdXJseS0yMDE0MDYwMjEwJwpIRUFE
IGlzIG5vdyBhdCBmYWQwMWU4Li4uIExpbnV4IDMuMTUtcmM4CmxzIC1hIC9rYnVpbGQtdGVz
dHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMC9saW51
czptYXN0ZXI6ZmFkMDFlODY2YWZkYmUwMWExZjNlYzA2YTM5YzNhOGI5ZTE5NzAxNDpiaXNl
Y3QtbGludXg2CgoyMDE0LTA2LTAyLTE0OjMwOjM1IGZhZDAxZTg2NmFmZGJlMDFhMWYzZWMw
NmEzOWMzYThiOWUxOTcwMTQgcmV1c2UgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MC0wNjAyMTEwMC9mYWQwMWU4NjZhZmRiZTAxYTFmM2VjMDZhMzljM2E4YjllMTk3MDE0L3Zt
bGludXotMy4xNS4wLXJjOAoKMjAxNC0wNi0wMi0xNDozMDozNSBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAuLi4uLi4uLgkyCTcJMTcuLi4uLi4uLi4uCTIyCTQxCTYwIFNVQ0NFU1MKCgo9PT09
PT09PT0gbGludXgtbmV4dCA9PT09PT09PT0KRnJvbSBnaXQ6Ly9naXRtaXJyb3IvbmV4dAog
KiBbbmV3IGJyYW5jaF0gICAgICBha3BtICAgICAgIC0+IG5leHQvYWtwbQogKiBbbmV3IGJy
YW5jaF0gICAgICBha3BtLWJhc2UgIC0+IG5leHQvYWtwbS1iYXNlCiAqIFtuZXcgYnJhbmNo
XSAgICAgIG1hc3RlciAgICAgLT4gbmV4dC9tYXN0ZXIKICogW25ldyBicmFuY2hdICAgICAg
c3RhYmxlICAgICAtPiBuZXh0L3N0YWJsZQpGcm9tIGdpdDovL2dpdG1pcnJvci9uZXh0CiAq
IFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzAzMjAgLT4gbmV4dC0yMDEzMDMyMAogKiBb
bmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwMzIxIC0+IG5leHQtMjAxMzAzMjEKICogW25l
dyB0YWddICAgICAgICAgbmV4dC0yMDEzMDMyMiAtPiBuZXh0LTIwMTMwMzIyCiAqIFtuZXcg
dGFnXSAgICAgICAgIG5leHQtMjAxMzAzMjUgLT4gbmV4dC0yMDEzMDMyNQogKiBbbmV3IHRh
Z10gICAgICAgICBuZXh0LTIwMTMwMzI2IC0+IG5leHQtMjAxMzAzMjYKICogW25ldyB0YWdd
ICAgICAgICAgbmV4dC0yMDEzMDMyNyAtPiBuZXh0LTIwMTMwMzI3CiAqIFtuZXcgdGFnXSAg
ICAgICAgIG5leHQtMjAxMzAzMjggLT4gbmV4dC0yMDEzMDMyOAogKiBbbmV3IHRhZ10gICAg
ICAgICBuZXh0LTIwMTMwNDAyIC0+IG5leHQtMjAxMzA0MDIKICogW25ldyB0YWddICAgICAg
ICAgbmV4dC0yMDEzMDQwMyAtPiBuZXh0LTIwMTMwNDAzCiAqIFtuZXcgdGFnXSAgICAgICAg
IG5leHQtMjAxMzA0MDQgLT4gbmV4dC0yMDEzMDQwNAogKiBbbmV3IHRhZ10gICAgICAgICBu
ZXh0LTIwMTMwNDA1IC0+IG5leHQtMjAxMzA0MDUKICogW25ldyB0YWddICAgICAgICAgbmV4
dC0yMDEzMDQwOCAtPiBuZXh0LTIwMTMwNDA4CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQt
MjAxMzA0MDkgLT4gbmV4dC0yMDEzMDQwOQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIw
MTMwNDEwIC0+IG5leHQtMjAxMzA0MTAKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEz
MDQxMSAtPiBuZXh0LTIwMTMwNDExCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA0
MTIgLT4gbmV4dC0yMDEzMDQxMgogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwNDE1
IC0+IG5leHQtMjAxMzA0MTUKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDQxNiAt
PiBuZXh0LTIwMTMwNDE2CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA0MTcgLT4g
bmV4dC0yMDEzMDQxNwogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwNDE4IC0+IG5l
eHQtMjAxMzA0MTgKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDQxOSAtPiBuZXh0
LTIwMTMwNDE5CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA0MjIgLT4gbmV4dC0y
MDEzMDQyMgogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwNDIzIC0+IG5leHQtMjAx
MzA0MjMKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDQyNCAtPiBuZXh0LTIwMTMw
NDI0CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA0MjYgLT4gbmV4dC0yMDEzMDQy
NgogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwNDI5IC0+IG5leHQtMjAxMzA0MjkK
ICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDQzMCAtPiBuZXh0LTIwMTMwNDMwCiAq
IFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA1MDEgLT4gbmV4dC0yMDEzMDUwMQogKiBb
bmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwNTAyIC0+IG5leHQtMjAxMzA1MDIKICogW25l
dyB0YWddICAgICAgICAgbmV4dC0yMDEzMDUwMyAtPiBuZXh0LTIwMTMwNTAzCiAqIFtuZXcg
dGFnXSAgICAgICAgIG5leHQtMjAxMzA1MDYgLT4gbmV4dC0yMDEzMDUwNgogKiBbbmV3IHRh
Z10gICAgICAgICBuZXh0LTIwMTMwNTA3IC0+IG5leHQtMjAxMzA1MDcKICogW25ldyB0YWdd
ICAgICAgICAgbmV4dC0yMDEzMDUwOCAtPiBuZXh0LTIwMTMwNTA4CiAqIFtuZXcgdGFnXSAg
ICAgICAgIG5leHQtMjAxMzA1MDkgLT4gbmV4dC0yMDEzMDUwOQogKiBbbmV3IHRhZ10gICAg
ICAgICBuZXh0LTIwMTMwNTEwIC0+IG5leHQtMjAxMzA1MTAKICogW25ldyB0YWddICAgICAg
ICAgbmV4dC0yMDEzMDUxMyAtPiBuZXh0LTIwMTMwNTEzCiAqIFtuZXcgdGFnXSAgICAgICAg
IG5leHQtMjAxMzA1MTQgLT4gbmV4dC0yMDEzMDUxNAogKiBbbmV3IHRhZ10gICAgICAgICBu
ZXh0LTIwMTMwNTE1IC0+IG5leHQtMjAxMzA1MTUKICogW25ldyB0YWddICAgICAgICAgbmV4
dC0yMDEzMDUxNiAtPiBuZXh0LTIwMTMwNTE2CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQt
MjAxMzA1MTcgLT4gbmV4dC0yMDEzMDUxNwogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIw
MTMwNTIwIC0+IG5leHQtMjAxMzA1MjAKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEz
MDUyMSAtPiBuZXh0LTIwMTMwNTIxCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA1
MjIgLT4gbmV4dC0yMDEzMDUyMgogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwNTIz
IC0+IG5leHQtMjAxMzA1MjMKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDUyNyAt
PiBuZXh0LTIwMTMwNTI3CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA1MjggLT4g
bmV4dC0yMDEzMDUyOAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwNTI5IC0+IG5l
eHQtMjAxMzA1MjkKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDUzMCAtPiBuZXh0
LTIwMTMwNTMwCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA1MzEgLT4gbmV4dC0y
MDEzMDUzMQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwNjAzIC0+IG5leHQtMjAx
MzA2MDMKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDYwNCAtPiBuZXh0LTIwMTMw
NjA0CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA2MDUgLT4gbmV4dC0yMDEzMDYw
NQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwNjA2IC0+IG5leHQtMjAxMzA2MDYK
ICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDYwNyAtPiBuZXh0LTIwMTMwNjA3CiAq
IFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA2MTcgLT4gbmV4dC0yMDEzMDYxNwogKiBb
bmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwNjE4IC0+IG5leHQtMjAxMzA2MTgKICogW25l
dyB0YWddICAgICAgICAgbmV4dC0yMDEzMDYxOSAtPiBuZXh0LTIwMTMwNjE5CiAqIFtuZXcg
dGFnXSAgICAgICAgIG5leHQtMjAxMzA2MjAgLT4gbmV4dC0yMDEzMDYyMAogKiBbbmV3IHRh
Z10gICAgICAgICBuZXh0LTIwMTMwNjIxIC0+IG5leHQtMjAxMzA2MjEKICogW25ldyB0YWdd
ICAgICAgICAgbmV4dC0yMDEzMDYyNCAtPiBuZXh0LTIwMTMwNjI0CiAqIFtuZXcgdGFnXSAg
ICAgICAgIG5leHQtMjAxMzA2MjUgLT4gbmV4dC0yMDEzMDYyNQogKiBbbmV3IHRhZ10gICAg
ICAgICBuZXh0LTIwMTMwNjI2IC0+IG5leHQtMjAxMzA2MjYKICogW25ldyB0YWddICAgICAg
ICAgbmV4dC0yMDEzMDYyNyAtPiBuZXh0LTIwMTMwNjI3CiAqIFtuZXcgdGFnXSAgICAgICAg
IG5leHQtMjAxMzA2MjggLT4gbmV4dC0yMDEzMDYyOAogKiBbbmV3IHRhZ10gICAgICAgICBu
ZXh0LTIwMTMwNzAxIC0+IG5leHQtMjAxMzA3MDEKICogW25ldyB0YWddICAgICAgICAgbmV4
dC0yMDEzMDcwMiAtPiBuZXh0LTIwMTMwNzAyCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQt
MjAxMzA3MDMgLT4gbmV4dC0yMDEzMDcwMwogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIw
MTMwNzA0IC0+IG5leHQtMjAxMzA3MDQKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEz
MDcwNSAtPiBuZXh0LTIwMTMwNzA1CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA3
MDggLT4gbmV4dC0yMDEzMDcwOAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwNzA5
IC0+IG5leHQtMjAxMzA3MDkKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDcxMCAt
PiBuZXh0LTIwMTMwNzEwCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA3MTEgLT4g
bmV4dC0yMDEzMDcxMQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwNzEyIC0+IG5l
eHQtMjAxMzA3MTIKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDcxNSAtPiBuZXh0
LTIwMTMwNzE1CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA3MTYgLT4gbmV4dC0y
MDEzMDcxNgogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwNzE3IC0+IG5leHQtMjAx
MzA3MTcKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDcxOCAtPiBuZXh0LTIwMTMw
NzE4CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA3MTkgLT4gbmV4dC0yMDEzMDcx
OQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwNzIyIC0+IG5leHQtMjAxMzA3MjIK
ICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDcyMyAtPiBuZXh0LTIwMTMwNzIzCiAq
IFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA3MjQgLT4gbmV4dC0yMDEzMDcyNAogKiBb
bmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwNzI1IC0+IG5leHQtMjAxMzA3MjUKICogW25l
dyB0YWddICAgICAgICAgbmV4dC0yMDEzMDcyNiAtPiBuZXh0LTIwMTMwNzI2CiAqIFtuZXcg
dGFnXSAgICAgICAgIG5leHQtMjAxMzA3MjkgLT4gbmV4dC0yMDEzMDcyOQogKiBbbmV3IHRh
Z10gICAgICAgICBuZXh0LTIwMTMwNzMwIC0+IG5leHQtMjAxMzA3MzAKICogW25ldyB0YWdd
ICAgICAgICAgbmV4dC0yMDEzMDczMSAtPiBuZXh0LTIwMTMwNzMxCiAqIFtuZXcgdGFnXSAg
ICAgICAgIG5leHQtMjAxMzA4MDEgLT4gbmV4dC0yMDEzMDgwMQogKiBbbmV3IHRhZ10gICAg
ICAgICBuZXh0LTIwMTMwODAyIC0+IG5leHQtMjAxMzA4MDIKICogW25ldyB0YWddICAgICAg
ICAgbmV4dC0yMDEzMDgwNSAtPiBuZXh0LTIwMTMwODA1CiAqIFtuZXcgdGFnXSAgICAgICAg
IG5leHQtMjAxMzA4MDYgLT4gbmV4dC0yMDEzMDgwNgogKiBbbmV3IHRhZ10gICAgICAgICBu
ZXh0LTIwMTMwODA3IC0+IG5leHQtMjAxMzA4MDcKICogW25ldyB0YWddICAgICAgICAgbmV4
dC0yMDEzMDgwOCAtPiBuZXh0LTIwMTMwODA4CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQt
MjAxMzA4MDkgLT4gbmV4dC0yMDEzMDgwOQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIw
MTMwODEyIC0+IG5leHQtMjAxMzA4MTIKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEz
MDgxMyAtPiBuZXh0LTIwMTMwODEzCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA4
MTQgLT4gbmV4dC0yMDEzMDgxNAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwODE1
IC0+IG5leHQtMjAxMzA4MTUKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDgxNiAt
PiBuZXh0LTIwMTMwODE2CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA4MTkgLT4g
bmV4dC0yMDEzMDgxOQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwODIwIC0+IG5l
eHQtMjAxMzA4MjAKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDgyMSAtPiBuZXh0
LTIwMTMwODIxCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA4MjIgLT4gbmV4dC0y
MDEzMDgyMgogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwODI3IC0+IG5leHQtMjAx
MzA4MjcKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDgyOCAtPiBuZXh0LTIwMTMw
ODI4CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA4MjkgLT4gbmV4dC0yMDEzMDgy
OQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwODMwIC0+IG5leHQtMjAxMzA4MzAK
ICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDkwMiAtPiBuZXh0LTIwMTMwOTAyCiAq
IFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA5MDMgLT4gbmV4dC0yMDEzMDkwMwogKiBb
bmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwOTA0IC0+IG5leHQtMjAxMzA5MDQKICogW25l
dyB0YWddICAgICAgICAgbmV4dC0yMDEzMDkwNSAtPiBuZXh0LTIwMTMwOTA1CiAqIFtuZXcg
dGFnXSAgICAgICAgIG5leHQtMjAxMzA5MDYgLT4gbmV4dC0yMDEzMDkwNgogKiBbbmV3IHRh
Z10gICAgICAgICBuZXh0LTIwMTMwOTA5IC0+IG5leHQtMjAxMzA5MDkKICogW25ldyB0YWdd
ICAgICAgICAgbmV4dC0yMDEzMDkxMCAtPiBuZXh0LTIwMTMwOTEwCiAqIFtuZXcgdGFnXSAg
ICAgICAgIG5leHQtMjAxMzA5MTEgLT4gbmV4dC0yMDEzMDkxMQogKiBbbmV3IHRhZ10gICAg
ICAgICBuZXh0LTIwMTMwOTEyIC0+IG5leHQtMjAxMzA5MTIKICogW25ldyB0YWddICAgICAg
ICAgbmV4dC0yMDEzMDkxMyAtPiBuZXh0LTIwMTMwOTEzCiAqIFtuZXcgdGFnXSAgICAgICAg
IG5leHQtMjAxMzA5MTYgLT4gbmV4dC0yMDEzMDkxNgogKiBbbmV3IHRhZ10gICAgICAgICBu
ZXh0LTIwMTMwOTE3IC0+IG5leHQtMjAxMzA5MTcKICogW25ldyB0YWddICAgICAgICAgbmV4
dC0yMDEzMDkxOCAtPiBuZXh0LTIwMTMwOTE4CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQt
MjAxMzA5MTkgLT4gbmV4dC0yMDEzMDkxOQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIw
MTMwOTIwIC0+IG5leHQtMjAxMzA5MjAKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEz
MDkyMyAtPiBuZXh0LTIwMTMwOTIzCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA5
MjQgLT4gbmV4dC0yMDEzMDkyNAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwOTI1
IC0+IG5leHQtMjAxMzA5MjUKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDkyNiAt
PiBuZXh0LTIwMTMwOTI2CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA5MjcgLT4g
bmV4dC0yMDEzMDkyNwogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMxMDI5IC0+IG5l
eHQtMjAxMzEwMjkKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMTAzMCAtPiBuZXh0
LTIwMTMxMDMwCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzEwMzEgLT4gbmV4dC0y
MDEzMTAzMQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMxMTAxIC0+IG5leHQtMjAx
MzExMDEKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMTEwNCAtPiBuZXh0LTIwMTMx
MTA0CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzExMDUgLT4gbmV4dC0yMDEzMTEw
NQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMxMTA2IC0+IG5leHQtMjAxMzExMDYK
ICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMTEwNyAtPiBuZXh0LTIwMTMxMTA3CiAq
IFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzExMDggLT4gbmV4dC0yMDEzMTEwOAogKiBb
bmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMxMTExIC0+IG5leHQtMjAxMzExMTEKICogW25l
dyB0YWddICAgICAgICAgbmV4dC0yMDEzMTExMiAtPiBuZXh0LTIwMTMxMTEyCiAqIFtuZXcg
dGFnXSAgICAgICAgIG5leHQtMjAxMzExMTMgLT4gbmV4dC0yMDEzMTExMwogKiBbbmV3IHRh
Z10gICAgICAgICBuZXh0LTIwMTMxMTE0IC0+IG5leHQtMjAxMzExMTQKICogW25ldyB0YWdd
ICAgICAgICAgbmV4dC0yMDEzMTExNSAtPiBuZXh0LTIwMTMxMTE1CiAqIFtuZXcgdGFnXSAg
ICAgICAgIG5leHQtMjAxMzExMTggLT4gbmV4dC0yMDEzMTExOAogKiBbbmV3IHRhZ10gICAg
ICAgICBuZXh0LTIwMTMxMTE5IC0+IG5leHQtMjAxMzExMTkKICogW25ldyB0YWddICAgICAg
ICAgbmV4dC0yMDEzMTEyMCAtPiBuZXh0LTIwMTMxMTIwCiAqIFtuZXcgdGFnXSAgICAgICAg
IG5leHQtMjAxMzExMjEgLT4gbmV4dC0yMDEzMTEyMQogKiBbbmV3IHRhZ10gICAgICAgICBu
ZXh0LTIwMTMxMTIyIC0+IG5leHQtMjAxMzExMjIKICogW25ldyB0YWddICAgICAgICAgbmV4
dC0yMDEzMTEyNSAtPiBuZXh0LTIwMTMxMTI1CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQt
MjAxMzExMjYgLT4gbmV4dC0yMDEzMTEyNgogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIw
MTMxMTI3IC0+IG5leHQtMjAxMzExMjcKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEz
MTEyOCAtPiBuZXh0LTIwMTMxMTI4CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzEx
MjkgLT4gbmV4dC0yMDEzMTEyOQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMxMjAy
IC0+IG5leHQtMjAxMzEyMDIKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMTIwMyAt
PiBuZXh0LTIwMTMxMjAzCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzEyMDQgLT4g
bmV4dC0yMDEzMTIwNAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMxMjA1IC0+IG5l
eHQtMjAxMzEyMDUKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMTIwNiAtPiBuZXh0
LTIwMTMxMjA2CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzEyMDkgLT4gbmV4dC0y
MDEzMTIwOQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMxMjEwIC0+IG5leHQtMjAx
MzEyMTAKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMTIxMSAtPiBuZXh0LTIwMTMx
MjExCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzEyMTIgLT4gbmV4dC0yMDEzMTIx
MgogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMxMjEzIC0+IG5leHQtMjAxMzEyMTMK
ICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMTIxNiAtPiBuZXh0LTIwMTMxMjE2CiAq
IFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzEyMTcgLT4gbmV4dC0yMDEzMTIxNwogKiBb
bmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMxMjE4IC0+IG5leHQtMjAxMzEyMTgKICogW25l
dyB0YWddICAgICAgICAgbmV4dC0yMDEzMTIxOSAtPiBuZXh0LTIwMTMxMjE5CiAqIFtuZXcg
dGFnXSAgICAgICAgIG5leHQtMjAxMzEyMjAgLT4gbmV4dC0yMDEzMTIyMAogKiBbbmV3IHRh
Z10gICAgICAgICBuZXh0LTIwMTMxMjIzIC0+IG5leHQtMjAxMzEyMjMKICogW25ldyB0YWdd
ICAgICAgICAgbmV4dC0yMDEzMTIyNCAtPiBuZXh0LTIwMTMxMjI0CiAqIFtuZXcgdGFnXSAg
ICAgICAgIG5leHQtMjAxNDAxMDYgLT4gbmV4dC0yMDE0MDEwNgogKiBbbmV3IHRhZ10gICAg
ICAgICBuZXh0LTIwMTQwMTA3IC0+IG5leHQtMjAxNDAxMDcKICogW25ldyB0YWddICAgICAg
ICAgbmV4dC0yMDE0MDEwOCAtPiBuZXh0LTIwMTQwMTA4CiAqIFtuZXcgdGFnXSAgICAgICAg
IG5leHQtMjAxNDAxMDkgLT4gbmV4dC0yMDE0MDEwOQogKiBbbmV3IHRhZ10gICAgICAgICBu
ZXh0LTIwMTQwMTEwIC0+IG5leHQtMjAxNDAxMTAKICogW25ldyB0YWddICAgICAgICAgbmV4
dC0yMDE0MDExMyAtPiBuZXh0LTIwMTQwMTEzCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQt
MjAxNDAxMTQgLT4gbmV4dC0yMDE0MDExNAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIw
MTQwMTE1IC0+IG5leHQtMjAxNDAxMTUKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0
MDExNiAtPiBuZXh0LTIwMTQwMTE2CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDAx
MTcgLT4gbmV4dC0yMDE0MDExNwogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwMTIw
IC0+IG5leHQtMjAxNDAxMjAKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDEyMSAt
PiBuZXh0LTIwMTQwMTIxCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDAxMjIgLT4g
bmV4dC0yMDE0MDEyMgogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwMTIzIC0+IG5l
eHQtMjAxNDAxMjMKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDEyNCAtPiBuZXh0
LTIwMTQwMTI0CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDAxMjggLT4gbmV4dC0y
MDE0MDEyOAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwMTI5IC0+IG5leHQtMjAx
NDAxMjkKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDEzMCAtPiBuZXh0LTIwMTQw
MTMwCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDAxMzEgLT4gbmV4dC0yMDE0MDEz
MQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwMjAzIC0+IG5leHQtMjAxNDAyMDMK
ICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDIwNCAtPiBuZXh0LTIwMTQwMjA0CiAq
IFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDAyMDUgLT4gbmV4dC0yMDE0MDIwNQogKiBb
bmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwMjA2IC0+IG5leHQtMjAxNDAyMDYKICogW25l
dyB0YWddICAgICAgICAgbmV4dC0yMDE0MDIwNyAtPiBuZXh0LTIwMTQwMjA3CiAqIFtuZXcg
dGFnXSAgICAgICAgIG5leHQtMjAxNDAyMTAgLT4gbmV4dC0yMDE0MDIxMAogKiBbbmV3IHRh
Z10gICAgICAgICBuZXh0LTIwMTQwMjExIC0+IG5leHQtMjAxNDAyMTEKICogW25ldyB0YWdd
ICAgICAgICAgbmV4dC0yMDE0MDIxMiAtPiBuZXh0LTIwMTQwMjEyCiAqIFtuZXcgdGFnXSAg
ICAgICAgIG5leHQtMjAxNDAyMTMgLT4gbmV4dC0yMDE0MDIxMwogKiBbbmV3IHRhZ10gICAg
ICAgICBuZXh0LTIwMTQwMjE0IC0+IG5leHQtMjAxNDAyMTQKICogW25ldyB0YWddICAgICAg
ICAgbmV4dC0yMDE0MDIxNyAtPiBuZXh0LTIwMTQwMjE3CiAqIFtuZXcgdGFnXSAgICAgICAg
IG5leHQtMjAxNDAyMTggLT4gbmV4dC0yMDE0MDIxOAogKiBbbmV3IHRhZ10gICAgICAgICBu
ZXh0LTIwMTQwMjE5IC0+IG5leHQtMjAxNDAyMTkKICogW25ldyB0YWddICAgICAgICAgbmV4
dC0yMDE0MDIyMCAtPiBuZXh0LTIwMTQwMjIwCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQt
MjAxNDAyMjEgLT4gbmV4dC0yMDE0MDIyMQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIw
MTQwMjI0IC0+IG5leHQtMjAxNDAyMjQKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0
MDIyNSAtPiBuZXh0LTIwMTQwMjI1CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDAy
MjYgLT4gbmV4dC0yMDE0MDIyNgogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwMjI3
IC0+IG5leHQtMjAxNDAyMjcKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDIyOCAt
PiBuZXh0LTIwMTQwMjI4CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDAzMDMgLT4g
bmV4dC0yMDE0MDMwMwogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwMzA0IC0+IG5l
eHQtMjAxNDAzMDQKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDMwNSAtPiBuZXh0
LTIwMTQwMzA1CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDAzMDYgLT4gbmV4dC0y
MDE0MDMwNgogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwMzA3IC0+IG5leHQtMjAx
NDAzMDcKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDMxMSAtPiBuZXh0LTIwMTQw
MzExCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDAzMTIgLT4gbmV4dC0yMDE0MDMx
MgogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwMzEzIC0+IG5leHQtMjAxNDAzMTMK
ICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDMxNCAtPiBuZXh0LTIwMTQwMzE0CiAq
IFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDAzMTcgLT4gbmV4dC0yMDE0MDMxNwogKiBb
bmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwMzE4IC0+IG5leHQtMjAxNDAzMTgKICogW25l
dyB0YWddICAgICAgICAgbmV4dC0yMDE0MDMxOSAtPiBuZXh0LTIwMTQwMzE5CiAqIFtuZXcg
dGFnXSAgICAgICAgIG5leHQtMjAxNDAzMjAgLT4gbmV4dC0yMDE0MDMyMAogKiBbbmV3IHRh
Z10gICAgICAgICBuZXh0LTIwMTQwMzIxIC0+IG5leHQtMjAxNDAzMjEKICogW25ldyB0YWdd
ICAgICAgICAgbmV4dC0yMDE0MDMyNCAtPiBuZXh0LTIwMTQwMzI0CiAqIFtuZXcgdGFnXSAg
ICAgICAgIG5leHQtMjAxNDAzMjUgLT4gbmV4dC0yMDE0MDMyNQogKiBbbmV3IHRhZ10gICAg
ICAgICBuZXh0LTIwMTQwMzI2IC0+IG5leHQtMjAxNDAzMjYKICogW25ldyB0YWddICAgICAg
ICAgbmV4dC0yMDE0MDMyNyAtPiBuZXh0LTIwMTQwMzI3CiAqIFtuZXcgdGFnXSAgICAgICAg
IG5leHQtMjAxNDAzMjggLT4gbmV4dC0yMDE0MDMyOAogKiBbbmV3IHRhZ10gICAgICAgICBu
ZXh0LTIwMTQwMzMxIC0+IG5leHQtMjAxNDAzMzEKICogW25ldyB0YWddICAgICAgICAgbmV4
dC0yMDE0MDQwMSAtPiBuZXh0LTIwMTQwNDAxCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQt
MjAxNDA0MDIgLT4gbmV4dC0yMDE0MDQwMgogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIw
MTQwNDAzIC0+IG5leHQtMjAxNDA0MDMKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0
MDQwNyAtPiBuZXh0LTIwMTQwNDA3CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDA0
MDggLT4gbmV4dC0yMDE0MDQwOAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwNDA5
IC0+IG5leHQtMjAxNDA0MDkKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDQxMCAt
PiBuZXh0LTIwMTQwNDEwCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDA0MTEgLT4g
bmV4dC0yMDE0MDQxMQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwNDE0IC0+IG5l
eHQtMjAxNDA0MTQKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDQxNSAtPiBuZXh0
LTIwMTQwNDE1CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDA0MTYgLT4gbmV4dC0y
MDE0MDQxNgogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwNDE3IC0+IG5leHQtMjAx
NDA0MTcKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDQyMiAtPiBuZXh0LTIwMTQw
NDIyCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDA0MjMgLT4gbmV4dC0yMDE0MDQy
MwogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwNDI0IC0+IG5leHQtMjAxNDA0MjQK
ICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDQyOCAtPiBuZXh0LTIwMTQwNDI4CiAq
IFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDA0MjkgLT4gbmV4dC0yMDE0MDQyOQogKiBb
bmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwNDMwIC0+IG5leHQtMjAxNDA0MzAKICogW25l
dyB0YWddICAgICAgICAgbmV4dC0yMDE0MDUwMSAtPiBuZXh0LTIwMTQwNTAxCiAqIFtuZXcg
dGFnXSAgICAgICAgIG5leHQtMjAxNDA1MDIgLT4gbmV4dC0yMDE0MDUwMgogKiBbbmV3IHRh
Z10gICAgICAgICBuZXh0LTIwMTQwNTA1IC0+IG5leHQtMjAxNDA1MDUKICogW25ldyB0YWdd
ICAgICAgICAgbmV4dC0yMDE0MDUwNiAtPiBuZXh0LTIwMTQwNTA2CiAqIFtuZXcgdGFnXSAg
ICAgICAgIG5leHQtMjAxNDA1MDcgLT4gbmV4dC0yMDE0MDUwNwogKiBbbmV3IHRhZ10gICAg
ICAgICBuZXh0LTIwMTQwNTA4IC0+IG5leHQtMjAxNDA1MDgKICogW25ldyB0YWddICAgICAg
ICAgbmV4dC0yMDE0MDUwOSAtPiBuZXh0LTIwMTQwNTA5CiAqIFtuZXcgdGFnXSAgICAgICAg
IG5leHQtMjAxNDA1MTIgLT4gbmV4dC0yMDE0MDUxMgogKiBbbmV3IHRhZ10gICAgICAgICBu
ZXh0LTIwMTQwNTEzIC0+IG5leHQtMjAxNDA1MTMKICogW25ldyB0YWddICAgICAgICAgbmV4
dC0yMDE0MDUxNCAtPiBuZXh0LTIwMTQwNTE0CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQt
MjAxNDA1MTUgLT4gbmV4dC0yMDE0MDUxNQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIw
MTQwNTE2IC0+IG5leHQtMjAxNDA1MTYKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0
MDUxOSAtPiBuZXh0LTIwMTQwNTE5CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDA1
MjAgLT4gbmV4dC0yMDE0MDUyMAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwNTIx
IC0+IG5leHQtMjAxNDA1MjEKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDUyMiAt
PiBuZXh0LTIwMTQwNTIyCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDA1MjMgLT4g
bmV4dC0yMDE0MDUyMwogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwNTI2IC0+IG5l
eHQtMjAxNDA1MjYKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDUyNyAtPiBuZXh0
LTIwMTQwNTI3CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDA1MjggLT4gbmV4dC0y
MDE0MDUyOAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwNTI5IC0+IG5leHQtMjAx
NDA1MjkKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDUzMCAtPiBuZXh0LTIwMTQw
NTMwClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIGZhZDAxZTguLi4gTGludXggMy4xNS1y
YzgKSEVBRCBpcyBub3cgYXQgMzIyYzAzMC4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBm
aWxlcyBmb3IgMjAxNDA1MzAKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIxMTAwL25leHQ6bWFzdGVyOjMyMmMwMzBmNTQ2
MmE0NGNlNDJmODgwNDI4NGViNTJiN2NkMmJhNDE6YmlzZWN0LWxpbnV4NgoKMjAxNC0wNi0w
Mi0xNDo0NTowNCAzMjJjMDMwZjU0NjJhNDRjZTQyZjg4MDQyODRlYjUyYjdjZDJiYTQxIGNv
bXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
L3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIxMTAwLTMyMmMwMzBmNTQ2MmE0NGNlNDJm
ODgwNDI4NGViNTJiN2NkMmJhNDEKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIxMTAwLzMyMmMwMzBmNTQ2MmE0NGNlNDJmODgwNDI4
NGViNTJiN2NkMmJhNDEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhzeGEwLTA2MDIxMTAwLTMyMmMwMzBm
NTQ2MmE0NGNlNDJmODgwNDI4NGViNTJiN2NkMmJhNDEKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1oc3hh
MC0wNjAyMTEwMC0zMjJjMDMwZjU0NjJhNDRjZTQyZjg4MDQyODRlYjUyYjdjZDJiYTQxCmtl
cm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc3hhMC0wNjAyMTEwMC8zMjJjMDMw
ZjU0NjJhNDRjZTQyZjg4MDQyODRlYjUyYjdjZDJiYTQxL3ZtbGludXotMy4xNS4wLXJjNy1u
ZXh0LTIwMTQwNTMwCgoyMDE0LTA2LTAyLTE0OjUwOjA0IGRldGVjdGluZyBib290IHN0YXRl
IC4uCTkJMTgJMjUJMzMJNDQJNTMJNTgJNjAgU1VDQ0VTUwoK

--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.15.0-rc5-00090-gb739c99"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.15.0-rc5 Kernel Configuration
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
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
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
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
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
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_FHANDLE=y
# CONFIG_USELIB is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
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
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
# CONFIG_NO_HZ_FULL_ALL is not set
# CONFIG_NO_HZ_FULL_SYSIDLE is not set
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_RCU_USER_QS=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_NOCB_CPU=y
CONFIG_RCU_NOCB_CPU_ALL=y
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_CGROUPS is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
CONFIG_USER_NS=y
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
CONFIG_SYSFS_SYSCALL=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
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
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
CONFIG_UPROBES=y
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
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
CONFIG_GCOV_FORMAT_AUTODETECT=y
# CONFIG_GCOV_FORMAT_3_4 is not set
# CONFIG_GCOV_FORMAT_4_7 is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_BSGLIB is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_AIX_PARTITION=y
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
# CONFIG_CMDLINE_PARTITION is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
# CONFIG_X86_X2APIC is not set
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
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
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_I8K=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
CONFIG_MICROCODE_AMD_EARLY=y
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=y
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_HOTPLUG_CPU is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_EC_DEBUGFS=y
# CONFIG_ACPI_AC is not set
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
# CONFIG_ACPI_FAN is not set
CONFIG_ACPI_DOCK=y
# CONFIG_ACPI_PROCESSOR is not set
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
CONFIG_ACPI_SBS=y
# CONFIG_ACPI_HED is not set
CONFIG_ACPI_CUSTOM_METHOD=y
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
CONFIG_ACPI_EXTLOG=y
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
CONFIG_X86_P4_CLOCKMOD=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
# CONFIG_PCIEAER is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=y
CONFIG_I82092=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=y
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_TSI721=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
CONFIG_RAPIDIO_DMA_ENGINE=y
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_ENUM_BASIC=y

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=y
CONFIG_RAPIDIO_CPS_XX=y
CONFIG_RAPIDIO_TSI568=y
# CONFIG_RAPIDIO_CPS_GEN2 is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_NETFILTER_XTABLES=y

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=y
CONFIG_BRIDGE_NF_EBTABLES=y
CONFIG_BRIDGE_EBT_BROUTE=y
CONFIG_BRIDGE_EBT_T_FILTER=y
# CONFIG_BRIDGE_EBT_T_NAT is not set
CONFIG_BRIDGE_EBT_802_3=y
CONFIG_BRIDGE_EBT_AMONG=y
# CONFIG_BRIDGE_EBT_ARP is not set
# CONFIG_BRIDGE_EBT_IP is not set
CONFIG_BRIDGE_EBT_LIMIT=y
# CONFIG_BRIDGE_EBT_MARK is not set
CONFIG_BRIDGE_EBT_PKTTYPE=y
# CONFIG_BRIDGE_EBT_STP is not set
# CONFIG_BRIDGE_EBT_VLAN is not set
# CONFIG_BRIDGE_EBT_DNAT is not set
CONFIG_BRIDGE_EBT_MARK_T=y
CONFIG_BRIDGE_EBT_REDIRECT=y
CONFIG_BRIDGE_EBT_SNAT=y
CONFIG_BRIDGE_EBT_LOG=y
# CONFIG_BRIDGE_EBT_ULOG is not set
CONFIG_BRIDGE_EBT_NFLOG=y
CONFIG_ATM=y
CONFIG_ATM_LANE=y
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_IPDDP=y
CONFIG_IPDDP_ENCAP=y
CONFIG_X25=y
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
CONFIG_IEEE802154=y
CONFIG_MAC802154=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
# CONFIG_NET_SCH_HFSC is not set
CONFIG_NET_SCH_ATM=y
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFB=y
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_MQPRIO=y
# CONFIG_NET_SCH_CHOKE is not set
CONFIG_NET_SCH_QFQ=y
CONFIG_NET_SCH_CODEL=y
# CONFIG_NET_SCH_FQ_CODEL is not set
# CONFIG_NET_SCH_FQ is not set
CONFIG_NET_SCH_HHF=y
CONFIG_NET_SCH_PIE=y
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_FW=y
# CONFIG_NET_CLS_U32 is not set
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_CLS_BPF=y
# CONFIG_NET_EMATCH is not set
# CONFIG_NET_CLS_ACT is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_NC is not set
# CONFIG_BATMAN_ADV_MCAST is not set
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_OPENVSWITCH=y
# CONFIG_VSOCKETS is not set
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=y
# CONFIG_NET_MPLS_GSO is not set
CONFIG_HSR=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
CONFIG_AX25_DAMA_SLAVE=y
# CONFIG_NETROM is not set
# CONFIG_ROSE is not set

#
# AX.25 network device drivers
#
CONFIG_MKISS=y
CONFIG_6PACK=y
CONFIG_BPQETHER=y
# CONFIG_BAYCOM_SER_FDX is not set
CONFIG_BAYCOM_SER_HDX=y
CONFIG_BAYCOM_PAR=y
CONFIG_YAM=y
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=y
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
CONFIG_CAN_SLCAN=y
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_REGULATOR=y
CONFIG_RFKILL_GPIO=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_NET_9P_DEBUG=y
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
# CONFIG_CAIF_NETDEV is not set
# CONFIG_CAIF_USB is not set
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
# CONFIG_DEVTMPFS_MOUNT is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
CONFIG_PARPORT=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_ZRAM is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SKD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
# CONFIG_ICS932S401 is not set
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_PCH_PHUB=y
CONFIG_USB_SWITCH_FSA9480=y
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
CONFIG_INTEL_MEI_TXE=y
CONFIG_VMWARE_VMCI=y

#
# Intel MIC Host Driver
#
CONFIG_INTEL_MIC_HOST=y

#
# Intel MIC Card Driver
#
CONFIG_INTEL_MIC_CARD=y
# CONFIG_GENWQE is not set
CONFIG_ECHO=y
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
# CONFIG_IDE_GD_ATA is not set
CONFIG_IDE_GD_ATAPI=y
CONFIG_BLK_DEV_IDECS=y
CONFIG_BLK_DEV_DELKIN=y
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=y
CONFIG_BLK_DEV_IDEACPI=y
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
CONFIG_BLK_DEV_IDEPNP=y
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=y
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
CONFIG_BLK_DEV_ALI15X3=y
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
CONFIG_BLK_DEV_TRIFLEX=y
# CONFIG_BLK_DEV_CS5520 is not set
CONFIG_BLK_DEV_CS5530=y
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
CONFIG_BLK_DEV_SC1200=y
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_IT8172 is not set
CONFIG_BLK_DEV_IT8213=y
# CONFIG_BLK_DEV_IT821X is not set
CONFIG_BLK_DEV_NS87415=y
CONFIG_BLK_DEV_PDC202XX_OLD=y
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
CONFIG_BLK_DEV_SVWKS=y
CONFIG_BLK_DEV_SIIMAGE=y
CONFIG_BLK_DEV_SIS5513=y
CONFIG_BLK_DEV_SLC90E66=y
CONFIG_BLK_DEV_TRM290=y
CONFIG_BLK_DEV_VIA82CXXX=y
CONFIG_BLK_DEV_TC86C001=y
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_ATA is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
CONFIG_BCACHE=y
CONFIG_BCACHE_DEBUG=y
CONFIG_BCACHE_CLOSURES_DEBUG=y
# CONFIG_BLK_DEV_DM is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
# CONFIG_NET_CORE is not set
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
# CONFIG_ARCNET_1051 is not set
# CONFIG_ARCNET_RAW is not set
CONFIG_ARCNET_CAP=y
CONFIG_ARCNET_COM90xx=y
CONFIG_ARCNET_COM90xxIO=y
# CONFIG_ARCNET_RIM_I is not set
CONFIG_ARCNET_COM20020=y
CONFIG_ARCNET_COM20020_PCI=y
# CONFIG_ARCNET_COM20020_CS is not set
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=y
CONFIG_CAIF_SPI_SLAVE=y
# CONFIG_CAIF_SPI_SYNC is not set
# CONFIG_CAIF_HSI is not set
CONFIG_CAIF_VIRTIO=y
# CONFIG_VHOST_NET is not set
CONFIG_VHOST_RING=y

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_ETHERNET=y
CONFIG_MDIO=y
CONFIG_NET_VENDOR_3COM=y
CONFIG_PCMCIA_3C574=y
CONFIG_PCMCIA_3C589=y
CONFIG_VORTEX=y
CONFIG_TYPHOON=y
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_NET_VENDOR_ALTEON is not set
CONFIG_ALTERA_TSE=y
# CONFIG_NET_VENDOR_AMD is not set
CONFIG_NET_VENDOR_ARC=y
# CONFIG_NET_VENDOR_ATHEROS is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
CONFIG_BNX2=y
CONFIG_CNIC=y
CONFIG_TIGON3=y
CONFIG_BNX2X=y
CONFIG_BNX2X_SRIOV=y
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
CONFIG_CHELSIO_T1=y
# CONFIG_CHELSIO_T1_1G is not set
CONFIG_CHELSIO_T4=y
CONFIG_CHELSIO_T4VF=y
# CONFIG_NET_VENDOR_CISCO is not set
CONFIG_DNET=y
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
CONFIG_DE2104X=y
CONFIG_DE2104X_DSL=0
CONFIG_TULIP=y
CONFIG_TULIP_MWI=y
CONFIG_TULIP_MMIO=y
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=y
# CONFIG_WINBOND_840 is not set
CONFIG_DM9102=y
CONFIG_ULI526X=y
CONFIG_PCMCIA_XIRCOM=y
# CONFIG_NET_VENDOR_DLINK is not set
# CONFIG_NET_VENDOR_EMULEX is not set
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
# CONFIG_NET_VENDOR_FUJITSU is not set
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
# CONFIG_NET_VENDOR_INTEL is not set
# CONFIG_IP1000 is not set
CONFIG_JME=y
# CONFIG_NET_VENDOR_MARVELL is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NVIDIA=y
CONFIG_FORCEDETH=y
# CONFIG_NET_VENDOR_OKI is not set
CONFIG_ETHOC=y
# CONFIG_NET_PACKET_ENGINE is not set
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=y
CONFIG_QLCNIC=y
# CONFIG_QLCNIC_SRIOV is not set
CONFIG_QLGE=y
CONFIG_NETXEN_NIC=y
# CONFIG_NET_VENDOR_REALTEK is not set
# CONFIG_SH_ETH is not set
# CONFIG_NET_VENDOR_RDC is not set
# CONFIG_NET_VENDOR_SAMSUNG is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
CONFIG_SFC=y
# CONFIG_SFC_MCDI_MON is not set
# CONFIG_SFC_SRIOV is not set
# CONFIG_NET_VENDOR_SMSC is not set
CONFIG_NET_VENDOR_STMICRO=y
CONFIG_STMMAC_ETH=y
CONFIG_STMMAC_PLATFORM=y
CONFIG_STMMAC_PCI=y
CONFIG_STMMAC_DEBUG_FS=y
CONFIG_STMMAC_DA=y
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
CONFIG_CASSINI=y
CONFIG_NIU=y
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
CONFIG_WIZNET_W5300=y
# CONFIG_WIZNET_BUS_DIRECT is not set
CONFIG_WIZNET_BUS_INDIRECT=y
# CONFIG_WIZNET_BUS_ANY is not set
CONFIG_NET_VENDOR_XIRCOM=y
CONFIG_PCMCIA_XIRC2PS=y
CONFIG_FDDI=y
CONFIG_DEFXX=y
CONFIG_DEFXX_MMIO=y
CONFIG_SKFP=y
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
# CONFIG_AMD_PHY is not set
# CONFIG_MARVELL_PHY is not set
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
# CONFIG_LXT_PHY is not set
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
# CONFIG_BROADCOM_PHY is not set
CONFIG_BCM7XXX_PHY=y
# CONFIG_BCM87XX_PHY is not set
CONFIG_ICPLUS_PHY=y
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MICREL_PHY=y
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
# CONFIG_MDIO_GPIO is not set
CONFIG_PLIP=y
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=y
CONFIG_PPPOE=y
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
# CONFIG_SLIP is not set
CONFIG_SLHC=y

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
CONFIG_USB_RTL8150=y
CONFIG_USB_RTL8152=y
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=y
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=y
CONFIG_USB_NET_HUAWEI_CDC_NCM=y
CONFIG_USB_NET_CDC_MBIM=y
CONFIG_USB_NET_DM9601=y
# CONFIG_USB_NET_SR9700 is not set
CONFIG_USB_NET_SR9800=y
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
# CONFIG_USB_NET_RNDIS_HOST is not set
# CONFIG_USB_NET_CDC_SUBSET is not set
CONFIG_USB_NET_ZAURUS=y
CONFIG_USB_NET_CX82310_ETH=y
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
CONFIG_USB_HSO=y
CONFIG_USB_NET_INT51X1=y
# CONFIG_USB_IPHETH is not set
# CONFIG_USB_SIERRA_NET is not set
CONFIG_USB_VL600=y
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=y
CONFIG_WIMAX_I2400M_USB=y
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
# CONFIG_WAN is not set
# CONFIG_IEEE802154_DRIVERS is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5520 is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
# CONFIG_MOUSE_PS2_SENTELIC is not set
CONFIG_MOUSE_PS2_TOUCHKIT=y
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
CONFIG_MOUSE_BCM5974=y
CONFIG_MOUSE_CYAPA=y
CONFIG_MOUSE_VSXXXAA=y
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=y
CONFIG_MOUSE_SYNAPTICS_USB=y
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
CONFIG_TABLET_USB_AIPTEK=y
# CONFIG_TABLET_USB_GTCO is not set
CONFIG_TABLET_USB_HANWANG=y
CONFIG_TABLET_USB_KBTAB=y
CONFIG_TABLET_USB_WACOM=y
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM860X_ONKEY=y
CONFIG_INPUT_88PM80X_ONKEY=y
CONFIG_INPUT_AD714X=y
# CONFIG_INPUT_AD714X_I2C is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_MAX8925_ONKEY is not set
# CONFIG_INPUT_MAX8997_HAPTIC is not set
CONFIG_INPUT_MC13783_PWRBUTTON=y
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=y
# CONFIG_INPUT_APANEL is not set
CONFIG_INPUT_GP2A=y
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=y
CONFIG_INPUT_KEYSPAN_REMOTE=y
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_POWERMATE=y
CONFIG_INPUT_YEALINK=y
CONFIG_INPUT_CM109=y
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF8574=y
CONFIG_INPUT_PWM_BEEPER=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=y
# CONFIG_INPUT_IMS_PCU is not set
CONFIG_INPUT_CMA3000=y
CONFIG_INPUT_CMA3000_I2C=y
CONFIG_INPUT_IDEAPAD_SLIDEBAR=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
CONFIG_GAMEPORT_EMU10K1=y
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
CONFIG_SYNCLINK=y
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
CONFIG_NOZOMI=y
# CONFIG_ISI is not set
CONFIG_N_HDLC=y
CONFIG_N_GSM=y
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_PCH_UART=y
# CONFIG_SERIAL_PCH_UART_CONSOLE is not set
# CONFIG_SERIAL_ARC is not set
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
CONFIG_SERIAL_FSL_LPUART=y
# CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=y
CONFIG_R3964=y
CONFIG_APPLICOM=y

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
# CONFIG_CARDMAN_4000 is not set
CONFIG_CARDMAN_4040=y
CONFIG_IPWIRELESS=y
CONFIG_MWAVE=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HPET_MMAP_DEFAULT is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_TIS_I2C_NUVOTON=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
CONFIG_TCG_INFINEON=y
# CONFIG_TCG_ST33_I2C is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
# CONFIG_I2C_ALI1563 is not set
CONFIG_I2C_ALI15X3=y
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=y
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
CONFIG_I2C_KEMPLD=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_ROBOTFUZZ_OSIF=y
CONFIG_I2C_TAOS_EVM=y
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIPERBOARD is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_SPMI is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
CONFIG_PPS_CLIENT_LDISC=y
CONFIG_PPS_CLIENT_PARPORT=y
CONFIG_PPS_CLIENT_GPIO=y

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_DP83640_PHY=y
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_SCH311X=y
CONFIG_GPIO_SCH=y
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_VX855=y
CONFIG_GPIO_LYNXPOINT=y

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_MAX7300=y
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_RC5T583 is not set
CONFIG_GPIO_SX150X=y
# CONFIG_GPIO_STMPE is not set
# CONFIG_GPIO_TC3589X is not set
CONFIG_GPIO_WM8350=y
# CONFIG_GPIO_WM8994 is not set
CONFIG_GPIO_ADP5520=y
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_INTEL_MID=y
CONFIG_GPIO_PCH=y
CONFIG_GPIO_ML_IOH=y
# CONFIG_GPIO_TIMBERDALE is not set
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
CONFIG_GPIO_KEMPLD=y

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=y
CONFIG_GPIO_TPS65910=y

#
# USB GPIO expanders:
#
# CONFIG_GPIO_VIPERBOARD is not set
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
# CONFIG_W1_MASTER_DS2490 is not set
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
# CONFIG_MAX8925_POWER is not set
CONFIG_WM8350_POWER=y
CONFIG_TEST_POWER=y
CONFIG_BATTERY_88PM860X=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
CONFIG_BATTERY_BQ27X00_PLATFORM=y
# CONFIG_BATTERY_DA9030 is not set
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_88PM860X=y
CONFIG_CHARGER_ISP1704=y
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_MAX8997 is not set
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_BQ24735=y
CONFIG_CHARGER_SMB347=y
# CONFIG_CHARGER_TPS65090 is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_MC13783_ADC is not set
CONFIG_SENSORS_FSCHMD=y
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_IIO_HWMON is not set
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=y
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4222=y
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4260=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_MAX16065=y
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=y
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_HTU21=y
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SIS5595=y
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_ADC128D818 is not set
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=y
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_WM8350 is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
CONFIG_INTEL_POWERCLAMP=y
# CONFIG_ACPI_INT3403_THERMAL is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_WM8350_WATCHDOG is not set
CONFIG_XILINX_WATCHDOG=y
CONFIG_DW_WATCHDOG=y
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=y
# CONFIG_F71808E_WDT is not set
CONFIG_SP5100_TCO=y
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=y
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_KEMPLD_WDT is not set
CONFIG_SC1200_WDT=y
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
# CONFIG_SBC8360_WDT is not set
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
# CONFIG_SMSC37B787_WDT is not set
CONFIG_VIA_WDT=y
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_MEN_A21_WDT=y

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
CONFIG_WDTPCI=y

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
# CONFIG_SSB_PCIHOST is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_GPIO=y
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
CONFIG_MFD_AS3711=y
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_BCM590XX=y
# CONFIG_MFD_CROS_EC is not set
CONFIG_PMIC_DA903X=y
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
CONFIG_MFD_VIPERBOARD=y
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_UCB1400_CORE is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
# CONFIG_MFD_RTSX_USB is not set
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS65218 is not set
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_88PM800 is not set
# CONFIG_REGULATOR_88PM8607 is not set
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_AAT2870=y
CONFIG_REGULATOR_AS3711=y
CONFIG_REGULATOR_BCM590XX=y
CONFIG_REGULATOR_DA903X=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8997=y
# CONFIG_REGULATOR_MAX8998 is not set
CONFIG_REGULATOR_MAX77693=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
# CONFIG_REGULATOR_MC13892 is not set
CONFIG_REGULATOR_PFUZE100=y
# CONFIG_REGULATOR_RC5T583 is not set
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65090=y
CONFIG_REGULATOR_TPS65910=y
# CONFIG_REGULATOR_TPS80031 is not set
CONFIG_REGULATOR_WM8350=y
CONFIG_REGULATOR_WM8994=y
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
CONFIG_DRM_I2C_SIL164=y
CONFIG_DRM_I2C_NXP_TDA998X=y
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
CONFIG_DRM_I810=y
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
CONFIG_DRM_I915_FBDEV=y
CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT=y
# CONFIG_DRM_I915_UMS is not set
# CONFIG_DRM_MGA is not set
CONFIG_DRM_SIS=y
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
CONFIG_DRM_VMWGFX=y
# CONFIG_DRM_VMWGFX_FBCON is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=y
# CONFIG_DRM_MGAG200 is not set
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_DRM_QXL=y
# CONFIG_DRM_BOCHS is not set
# CONFIG_DRM_PTN3460 is not set

#
# Frame buffer Devices
#
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=y
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=y
CONFIG_FB_CYBER2000_DDC=y
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=y
# CONFIG_FB_OPENCORES is not set
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
CONFIG_FB_RIVA=y
# CONFIG_FB_RIVA_I2C is not set
CONFIG_FB_RIVA_DEBUG=y
CONFIG_FB_RIVA_BACKLIGHT=y
# CONFIG_FB_I740 is not set
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=y
# CONFIG_FB_ATY128_BACKLIGHT is not set
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=y
CONFIG_FB_S3_DDC=y
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
# CONFIG_FB_SAVAGE_ACCEL is not set
CONFIG_FB_SIS=y
# CONFIG_FB_SIS_300 is not set
# CONFIG_FB_SIS_315 is not set
CONFIG_FB_VIA=y
# CONFIG_FB_VIA_DIRECT_PROCFS is not set
CONFIG_FB_VIA_X_COMPATIBILITY=y
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
# CONFIG_FB_3DFX_I2C is not set
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=y
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=y
# CONFIG_FB_PM3 is not set
CONFIG_FB_CARMINE=y
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
CONFIG_FB_TMIO=y
CONFIG_FB_TMIO_ACCELL=y
CONFIG_FB_SMSCUFX=y
# CONFIG_FB_UDL is not set
CONFIG_FB_GOLDFISH=y
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
CONFIG_FB_SIMPLE=y
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_LM3533=y
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_DA903X=y
# CONFIG_BACKLIGHT_MAX8925 is not set
CONFIG_BACKLIGHT_APPLE=y
CONFIG_BACKLIGHT_SAHARA=y
# CONFIG_BACKLIGHT_ADP5520 is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_88PM860X is not set
# CONFIG_BACKLIGHT_AAT2870 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
# CONFIG_BACKLIGHT_AS3711 is not set
CONFIG_BACKLIGHT_GPIO=y
# CONFIG_BACKLIGHT_LV5207LP is not set
CONFIG_BACKLIGHT_BD6107=y
CONFIG_VGASTATE=y
CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
CONFIG_SND_OPL3_LIB_SEQ=y
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_VX_LIB=y
CONFIG_SND_AC97_CODEC=y
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_SB_COMMON=y
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
CONFIG_SND_ALS4000=y
# CONFIG_SND_ALI5451 is not set
CONFIG_SND_ASIHPI=y
CONFIG_SND_ATIIXP=y
CONFIG_SND_ATIIXP_MODEM=y
CONFIG_SND_AU8810=y
CONFIG_SND_AU8820=y
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
CONFIG_SND_AZT3328=y
CONFIG_SND_BT87X=y
# CONFIG_SND_BT87X_OVERCLOCK is not set
# CONFIG_SND_CA0106 is not set
CONFIG_SND_CMIPCI=y
CONFIG_SND_OXYGEN_LIB=y
CONFIG_SND_OXYGEN=y
CONFIG_SND_CS4281=y
CONFIG_SND_CS46XX=y
CONFIG_SND_CS46XX_NEW_DSP=y
# CONFIG_SND_CTXFI is not set
CONFIG_SND_DARLA20=y
CONFIG_SND_GINA20=y
CONFIG_SND_LAYLA20=y
CONFIG_SND_DARLA24=y
CONFIG_SND_GINA24=y
# CONFIG_SND_LAYLA24 is not set
CONFIG_SND_MONA=y
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
CONFIG_SND_INDIGOIO=y
CONFIG_SND_INDIGODJ=y
CONFIG_SND_INDIGOIOX=y
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
CONFIG_SND_EMU10K1X=y
CONFIG_SND_ENS1370=y
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
CONFIG_SND_ES1968=y
# CONFIG_SND_ES1968_INPUT is not set
CONFIG_SND_FM801=y
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
CONFIG_SND_ICE1712=y
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
CONFIG_SND_INTEL8X0M=y
CONFIG_SND_KORG1212=y
CONFIG_SND_LOLA=y
CONFIG_SND_LX6464ES=y
CONFIG_SND_MAESTRO3=y
CONFIG_SND_MAESTRO3_INPUT=y
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
CONFIG_SND_PCXHR=y
# CONFIG_SND_RIPTIDE is not set
CONFIG_SND_RME32=y
CONFIG_SND_RME96=y
CONFIG_SND_RME9652=y
CONFIG_SND_SONICVIBES=y
# CONFIG_SND_TRIDENT is not set
CONFIG_SND_VIA82XX=y
# CONFIG_SND_VIA82XX_MODEM is not set
CONFIG_SND_VIRTUOSO=y
# CONFIG_SND_VX222 is not set
CONFIG_SND_YMFPCI=y

#
# HD-Audio
#
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_USB is not set
# CONFIG_SND_FIREWIRE is not set
CONFIG_SND_PCMCIA=y
CONFIG_SND_VXPOCKET=y
# CONFIG_SND_PDAUDIOCF is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=y

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
CONFIG_HID_APPLEIR=y
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_PRODIKEYS=y
# CONFIG_HID_CP2112 is not set
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_HOLTEK=y
CONFIG_HOLTEK_FF=y
CONFIG_HID_HUION=y
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
CONFIG_HID_ICADE=y
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
# CONFIG_LOGITECH_FF is not set
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_NTRIG=y
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_ROCCAT=y
CONFIG_HID_SAITEK=y
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SONY=y
CONFIG_SONY_FF=y
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=y
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# I2C HID support
#
CONFIG_I2C_HID=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=y
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_FUSBH200_HCD=y
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_U132_HCD is not set
CONFIG_USB_SL811_HCD=y
CONFIG_USB_SL811_HCD_ISO=y
CONFIG_USB_SL811_CS=y
CONFIG_USB_R8A66597_HCD=y
# CONFIG_USB_RENESAS_USBHS_HCD is not set
CONFIG_USB_WHCI_HCD=y
CONFIG_USB_HWA_HCD=y
CONFIG_USB_HCD_SSB=y
# CONFIG_USB_HCD_TEST_MODE is not set
CONFIG_USB_RENESAS_USBHS=y

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MUSB_HDRC=y
CONFIG_USB_MUSB_HOST=y
# CONFIG_USB_MUSB_GADGET is not set
# CONFIG_USB_MUSB_DUAL_ROLE is not set
CONFIG_USB_MUSB_TUSB6010=y
# CONFIG_USB_MUSB_UX500 is not set
CONFIG_MUSB_PIO_ONLY=y
CONFIG_USB_DWC3=y
CONFIG_USB_DWC3_HOST=y
# CONFIG_USB_DWC3_GADGET is not set
# CONFIG_USB_DWC3_DUAL_ROLE is not set

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_OMAP=y
CONFIG_USB_DWC3_EXYNOS=y
CONFIG_USB_DWC3_PCI=y
CONFIG_USB_DWC3_KEYSTONE=y

#
# Debugging features
#
CONFIG_USB_DWC3_DEBUG=y
CONFIG_USB_DWC3_VERBOSE=y
CONFIG_USB_DWC2=y
CONFIG_USB_DWC2_DEBUG=y
# CONFIG_USB_DWC2_VERBOSE is not set
# CONFIG_USB_DWC2_TRACK_MISSED_SOFS is not set
CONFIG_USB_DWC2_DEBUG_PERIODIC=y
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
CONFIG_USB_USS720=y
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
# CONFIG_USB_SERIAL_GENERIC is not set
# CONFIG_USB_SERIAL_SIMPLE is not set
CONFIG_USB_SERIAL_AIRCABLE=y
CONFIG_USB_SERIAL_ARK3116=y
CONFIG_USB_SERIAL_BELKIN=y
CONFIG_USB_SERIAL_CH341=y
# CONFIG_USB_SERIAL_WHITEHEAT is not set
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
CONFIG_USB_SERIAL_CP210X=y
CONFIG_USB_SERIAL_CYPRESS_M8=y
# CONFIG_USB_SERIAL_EMPEG is not set
CONFIG_USB_SERIAL_FTDI_SIO=y
CONFIG_USB_SERIAL_VISOR=y
CONFIG_USB_SERIAL_IPAQ=y
# CONFIG_USB_SERIAL_IR is not set
CONFIG_USB_SERIAL_EDGEPORT=y
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
CONFIG_USB_SERIAL_F81232=y
CONFIG_USB_SERIAL_GARMIN=y
CONFIG_USB_SERIAL_IPW=y
# CONFIG_USB_SERIAL_IUU is not set
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
# CONFIG_USB_SERIAL_KEYSPAN is not set
CONFIG_USB_SERIAL_KLSI=y
CONFIG_USB_SERIAL_KOBIL_SCT=y
CONFIG_USB_SERIAL_MCT_U232=y
# CONFIG_USB_SERIAL_METRO is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
CONFIG_USB_SERIAL_MOS7840=y
CONFIG_USB_SERIAL_MXUPORT=y
CONFIG_USB_SERIAL_NAVMAN=y
CONFIG_USB_SERIAL_PL2303=y
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
CONFIG_USB_SERIAL_SPCP8X5=y
CONFIG_USB_SERIAL_SAFE=y
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
CONFIG_USB_SERIAL_SYMBOL=y
CONFIG_USB_SERIAL_TI=y
# CONFIG_USB_SERIAL_CYBERJACK is not set
CONFIG_USB_SERIAL_XIRCOM=y
CONFIG_USB_SERIAL_WWAN=y
# CONFIG_USB_SERIAL_OPTION is not set
CONFIG_USB_SERIAL_OMNINET=y
CONFIG_USB_SERIAL_OPTICON=y
CONFIG_USB_SERIAL_XSENS_MT=y
CONFIG_USB_SERIAL_WISHBONE=y
# CONFIG_USB_SERIAL_ZTE is not set
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
# CONFIG_USB_LCD is not set
CONFIG_USB_LED=y
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_USB_SISUSBVGA=y
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=y
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
CONFIG_USB_YUREX=y
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=y
CONFIG_USB_ATM=y
CONFIG_USB_SPEEDTOUCH=y
CONFIG_USB_CXACRU=y
CONFIG_USB_UEAGLEATM=y
CONFIG_USB_XUSBATM=y

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
# CONFIG_USB_OTG_FSM is not set
# CONFIG_NOP_USB_XCEIV is not set
CONFIG_SAMSUNG_USBPHY=y
# CONFIG_SAMSUNG_USB2PHY is not set
CONFIG_SAMSUNG_USB3PHY=y
# CONFIG_USB_GPIO_VBUS is not set
CONFIG_USB_ISP1301=y
CONFIG_USB_RCAR_PHY=y
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
CONFIG_USB_GADGET_DEBUG_FILES=y
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FOTG210_UDC=y
CONFIG_USB_GR_UDC=y
CONFIG_USB_R8A66597=y
# CONFIG_USB_RENESAS_USBHS_UDC is not set
# CONFIG_USB_PXA27X is not set
CONFIG_USB_S3C_HSOTG=y
CONFIG_USB_MV_UDC=y
# CONFIG_USB_MV_U3D is not set
CONFIG_USB_M66592=y
CONFIG_USB_AMD5536UDC=y
CONFIG_USB_NET2272=y
CONFIG_USB_NET2272_DMA=y
CONFIG_USB_NET2280=y
CONFIG_USB_GOKU=y
CONFIG_USB_EG20T=y
# CONFIG_USB_DUMMY_HCD is not set
CONFIG_USB_LIBCOMPOSITE=y
# CONFIG_USB_CONFIGFS is not set
# CONFIG_USB_ZERO is not set
# CONFIG_USB_AUDIO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_MIDI_GADGET is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
CONFIG_USB_G_HID=y
# CONFIG_USB_G_DBGP is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
# CONFIG_UWB_I1480U is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_WBSD=y
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_SDRICOH_CS=y
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
# CONFIG_MMC_VUB300 is not set
# CONFIG_MMC_USHC is not set
# CONFIG_MMC_REALTEK_PCI is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
# CONFIG_MSPRO_BLOCK is not set
CONFIG_MS_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_MEMSTICK_R592=y
CONFIG_MEMSTICK_REALTEK_PCI=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_CLEVO_MAIL=y
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_PCA9685=y
# CONFIG_LEDS_WM8350 is not set
CONFIG_LEDS_DA903X=y
CONFIG_LEDS_PWM=y
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_ADP5520=y
CONFIG_LEDS_DELL_NETBOOKS=y
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_MAX8997 is not set
CONFIG_LEDS_LM355x=y
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
CONFIG_INTEL_IOATDMA=y
# CONFIG_DW_DMAC_CORE is not set
# CONFIG_DW_DMAC is not set
# CONFIG_DW_DMAC_PCI is not set
# CONFIG_TIMB_DMA is not set
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DMA_ENGINE_RAID=y
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
# CONFIG_UIO_NETX is not set
CONFIG_UIO_MF624=y
# CONFIG_VFIO is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_ET131X is not set
CONFIG_SLICOSS=y
CONFIG_USBIP_CORE=y
CONFIG_USBIP_VHCI_HCD=y
CONFIG_USBIP_HOST=y
CONFIG_USBIP_DEBUG=y
# CONFIG_PANEL is not set
# CONFIG_TRANZPORT is not set
CONFIG_LINE6_USB=y
CONFIG_LINE6_USB_IMPULSE_RESPONSE=y
CONFIG_USB_SERIAL_QUATECH2=y
CONFIG_DX_SEP=y

#
# IIO staging drivers
#

#
# Accelerometers
#

#
# Analog to digital converters
#
CONFIG_AD7291=y
# CONFIG_AD7606 is not set
CONFIG_AD799X=y
CONFIG_AD799X_RING_BUFFER=y

#
# Analog digital bi-direction converters
#
# CONFIG_ADT7316 is not set

#
# Capacitance to digital converters
#
CONFIG_AD7150=y
# CONFIG_AD7152 is not set
# CONFIG_AD7746 is not set

#
# Direct Digital Synthesis
#

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=y

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=y
CONFIG_SENSORS_ISL29028=y
# CONFIG_TSL2583 is not set
# CONFIG_TSL2x7x is not set

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=y

#
# Active energy metering IC
#
# CONFIG_ADE7854 is not set

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
CONFIG_IIO_SIMPLE_DUMMY=y
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
CONFIG_CRYSTALHD=y
CONFIG_FB_XGI=y
CONFIG_ACPI_QUICKSTART=y
CONFIG_BCM_WIMAX=y
CONFIG_FT1000=y
CONFIG_FT1000_USB=y
CONFIG_FT1000_PCMCIA=y

#
# Speakup console speech
#
CONFIG_SPEAKUP=y
CONFIG_SPEAKUP_SYNTH_ACNTSA=y
CONFIG_SPEAKUP_SYNTH_APOLLO=y
# CONFIG_SPEAKUP_SYNTH_AUDPTR is not set
CONFIG_SPEAKUP_SYNTH_BNS=y
CONFIG_SPEAKUP_SYNTH_DECTLK=y
CONFIG_SPEAKUP_SYNTH_DECEXT=y
CONFIG_SPEAKUP_SYNTH_LTLK=y
# CONFIG_SPEAKUP_SYNTH_SOFT is not set
# CONFIG_SPEAKUP_SYNTH_SPKOUT is not set
# CONFIG_SPEAKUP_SYNTH_TXPRT is not set
CONFIG_SPEAKUP_SYNTH_DUMMY=y
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_USB_WPAN_HCD=y
CONFIG_WIMAX_GDM72XX=y
CONFIG_WIMAX_GDM72XX_QOS=y
# CONFIG_WIMAX_GDM72XX_K_MODE is not set
# CONFIG_WIMAX_GDM72XX_WIMAX2 is not set
CONFIG_WIMAX_GDM72XX_USB=y
# CONFIG_WIMAX_GDM72XX_SDIO is not set
# CONFIG_WIMAX_GDM72XX_USB_PM is not set
# CONFIG_NET_VENDOR_SILICOM is not set
CONFIG_CED1401=y
# CONFIG_DGRP is not set
CONFIG_FIREWIRE_SERIAL=y
CONFIG_FWTTY_MAX_TOTAL_PORTS=64
CONFIG_FWTTY_MAX_CARD_PORTS=32
CONFIG_XILLYBUS=y
CONFIG_XILLYBUS_PCIE=y
CONFIG_DGNC=y
# CONFIG_DGAP is not set
# CONFIG_GS_FPGABOOT is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=y
CONFIG_ACERHDF=y
CONFIG_ALIENWARE_WMI=y
# CONFIG_ASUS_LAPTOP is not set
CONFIG_DELL_LAPTOP=y
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
CONFIG_FUJITSU_LAPTOP=y
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
CONFIG_FUJITSU_TABLET=y
CONFIG_AMILO_RFKILL=y
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
CONFIG_HP_WMI=y
CONFIG_MSI_LAPTOP=y
CONFIG_PANASONIC_LAPTOP=y
# CONFIG_COMPAL_LAPTOP is not set
CONFIG_SONY_LAPTOP=y
CONFIG_SONYPI_COMPAT=y
CONFIG_IDEAPAD_LAPTOP=y
CONFIG_THINKPAD_ACPI=y
# CONFIG_THINKPAD_ACPI_ALSA_SUPPORT is not set
CONFIG_THINKPAD_ACPI_DEBUGFACILITIES=y
# CONFIG_THINKPAD_ACPI_DEBUG is not set
CONFIG_THINKPAD_ACPI_UNSAFE_LEDS=y
CONFIG_THINKPAD_ACPI_VIDEO=y
# CONFIG_THINKPAD_ACPI_HOTKEY_POLL is not set
CONFIG_SENSORS_HDAPS=y
CONFIG_EEEPC_LAPTOP=y
CONFIG_ASUS_WMI=y
# CONFIG_ASUS_NB_WMI is not set
# CONFIG_EEEPC_WMI is not set
CONFIG_ACPI_WMI=y
# CONFIG_MSI_WMI is not set
CONFIG_TOPSTAR_LAPTOP=y
CONFIG_ACPI_TOSHIBA=y
CONFIG_TOSHIBA_BT_RFKILL=y
CONFIG_ACPI_CMPC=y
CONFIG_INTEL_IPS=y
CONFIG_IBM_RTL=y
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_MXM_WMI=y
# CONFIG_INTEL_OAKTRAIL is not set
CONFIG_SAMSUNG_Q10=y
CONFIG_APPLE_GMUX=y
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
CONFIG_PVPANIC=y
# CONFIG_CHROME_PLATFORMS is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_AMD_IOMMU=y
CONFIG_AMD_IOMMU_STATS=y
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
CONFIG_IRQ_REMAP=y

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
# CONFIG_EXTCON_ADC_JACK is not set
# CONFIG_EXTCON_MAX77693 is not set
CONFIG_EXTCON_MAX8997=y
# CONFIG_MEMORY is not set
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_BUFFER_CB is not set
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
# CONFIG_BMA180 is not set
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y

#
# Analog to digital converters
#
CONFIG_MAX1363=y
# CONFIG_MCP3422 is not set
# CONFIG_MEN_Z188_ADC is not set
CONFIG_NAU7802=y
# CONFIG_TI_ADC081C is not set
# CONFIG_TI_AM335X_ADC is not set
CONFIG_VIPERBOARD_ADC=y

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
# CONFIG_AD5380 is not set
CONFIG_AD5446=y
# CONFIG_MAX517 is not set
CONFIG_MCP4725=y

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital gyroscope sensors
#
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_ITG3200=y

#
# Humidity sensors
#
CONFIG_DHT11=y
# CONFIG_SI7005 is not set

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=y

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
# CONFIG_APDS9300 is not set
CONFIG_CM32181=y
CONFIG_CM36651=y
CONFIG_GP2AP020A00F=y
CONFIG_SENSORS_LM3533=y
CONFIG_LTR501=y
CONFIG_TCS3472=y
# CONFIG_SENSORS_TSL2563 is not set
# CONFIG_TSL4531 is not set
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
CONFIG_MAG3110=y
# CONFIG_IIO_ST_MAGN_3AXIS is not set

#
# Inclinometer sensors
#

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
# CONFIG_MPL3115 is not set
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y

#
# Temperature sensors
#
CONFIG_TMP006=y
# CONFIG_NTB is not set
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
# CONFIG_VME_TSI148 is not set

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=y

#
# VME Device Drivers
#
CONFIG_VME_USER=y
CONFIG_VME_PIO2=y
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_LPSS=y
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
CONFIG_SERIAL_IPOCTAL=y
CONFIG_RESET_CONTROLLER=y
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_PHY_SAMSUNG_USB2=y
# CONFIG_POWERCAP is not set
CONFIG_MCB=y
CONFIG_MCB_PCI=y

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set
CONFIG_UEFI_CPER=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
# CONFIG_EXT2_FS_POSIX_ACL is not set
# CONFIG_EXT2_FS_SECURITY is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4_FS is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
# CONFIG_XFS_POSIX_ACL is not set
CONFIG_XFS_RT=y
CONFIG_XFS_WARN=y
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=y
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=y
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=y
CONFIG_HFSPLUS_FS_POSIX_ACL=y
# CONFIG_BEFS_FS is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_FILE_CACHE=y
# CONFIG_SQUASHFS_FILE_DIRECT is not set
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
CONFIG_SQUASHFS_DECOMP_MULTI=y
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
CONFIG_SQUASHFS_LZO=y
# CONFIG_SQUASHFS_XZ is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
# CONFIG_MINIX_FS is not set
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=y
# CONFIG_QNX6FS_DEBUG is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
# CONFIG_PSTORE_FTRACE is not set
# CONFIG_PSTORE_RAM is not set
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=y
CONFIG_UFS_FS_WRITE=y
# CONFIG_UFS_DEBUG is not set
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
# CONFIG_F2FS_FS_POSIX_ACL is not set
CONFIG_F2FS_FS_SECURITY=y
CONFIG_F2FS_CHECK_FS=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
CONFIG_DEBUG_OBJECTS_TIMERS=y
# CONFIG_DEBUG_OBJECTS_WORK is not set
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAIL_MMC_REQUEST is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
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
CONFIG_IRQSOFF_TRACER=y
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_STACK_TRACER=y
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_DEBUG=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
# CONFIG_BIG_KEYS is not set
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_PATH=y
# CONFIG_INTEL_TXT is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_YAMA=y
CONFIG_SECURITY_YAMA_STACKED=y
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_TEMPLATE=y
# CONFIG_IMA_NG_TEMPLATE is not set
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
CONFIG_IMA_DEFAULT_HASH="sha1"
CONFIG_IMA_APPRAISE=y
CONFIG_EVM=y
CONFIG_EVM_HMAC_VERSION=2
CONFIG_DEFAULT_SECURITY_YAMA=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="yama"
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
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
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_CRCT10DIF_PCLMUL is not set
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
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
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
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
CONFIG_PERCPU_RWSEM=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y

--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--Kj7319i9nmIyA2yE--
