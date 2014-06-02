Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaFBGyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 02:54:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:50237 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbaFBGyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 02:54:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,955,1392192000"; 
   d="log'?scan'208";a="541074338"
Date: Mon, 2 Jun 2014 14:53:57 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jet Chen <jet.chen@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [drm] INFO: task swapper:1 blocked for more than 120 seconds.
Message-ID: <20140602065357.GA8851@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jesse,

0day kernel testing robot got the below dmesg and the first bad commit is

git://people.freedesktop.org/~jbarnes/linux async-fb-probe
commit b739c9982801e5f76097311b67dfd76891b10988
Author:     Jesse Barnes <jbarnes@virtuousgeek.org>
AuthorDate: Wed May 28 10:21:17 2014 -0700
Commit:     Jesse Barnes <jbarnes@virtuousgeek.org>
CommitDate: Wed May 28 12:17:34 2014 -0700

    drm: take modeset locks around initial fb helper probing
    
    Drivers ought to complain otherwise.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

===================================================
PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
===================================================
1 /kernel/i386-randconfig-c1-06021140/071f9c57eea4876288ba1254c9ac3b0f077c2dd6

Attached dmesg for the parent commit, too, to help confirm whether it is a noise error.

+-------------------------------------------------------------+------------+------------+
|                                                             | 071f9c57ee | b739c99828 |
+-------------------------------------------------------------+------------+------------+
| boot_successes                                              | 59         | 0          |
| boot_failures                                               | 1          | 20         |
| WARNING:CPU:PID:at_mm/page_alloc.c:__alloc_pages_slowpath() | 1          |            |
| backtrace:SYSC_socketcall                                   | 1          |            |
| backtrace:SyS_socketcall                                    | 1          |            |
| INFO:task_blocked_for_more_than_seconds                     | 0          | 20         |
| EIP_is_at_native_apic_mem_write                             | 0          | 20         |
| Kernel_panic-not_syncing:hung_task:blocked_tasks            | 0          | 20         |
| backtrace:drm_fb_helper_initial_config                      | 0          | 20         |
| backtrace:cirrus_fbdev_init                                 | 0          | 20         |
| backtrace:cirrus_modeset_init                               | 0          | 20         |
| backtrace:__pci_register_driver                             | 0          | 20         |
| backtrace:drm_pci_init                                      | 0          | 20         |
| backtrace:cirrus_init                                       | 0          | 20         |
| backtrace:kernel_init_freeable                              | 0          | 20         |
| backtrace:watchdog                                          | 0          | 20         |
+-------------------------------------------------------------+------------+------------+

[    8.873617] [drm] Initialized drm 1.1.0 20060810
[    8.874286] [drm] radeon kernel modesetting enabled.
[    8.876773] [TTM] Zone  kernel: Available graphics memory: 135440 kiB
[    8.877424] [TTM] Initializing pool allocator
[   61.017759] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0 
[  121.025590] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0 
[  181.030819] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0 
[  240.212728] INFO: task swapper:1 blocked for more than 120 seconds.
[  240.213429]       Not tainted 3.15.0-rc5-00087-gb739c99 #1
[  240.213994] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.214777] swapper         D d3429c24  5944     1      0 0x00000000
[  240.215484]  d3429c48 00000046 00000000 d3429c24 c184af4c c2f31008 d3422000 d1f2d034
[  240.216408]  c2f31008 d1f2d034 c2f30fe0 c2f30fe0 d3429c1c c10bbfe0 d1f2d02c c2f30fe0
[  240.217339]  d3429c2c c10bc022 d1f2d02c 00000001 00000001 c10bc839 00000002 c2f30fe0
[  240.218258] Call Trace:
[  240.218551]  [<c184af4c>] ? rb_erase+0x3d/0x576
[  240.219043]  [<c10bbfe0>] ? __dequeue_entity+0x4d/0x5f
[  240.219573]  [<c10bc022>] ? set_next_entity+0x30/0x63
[  240.220108]  [<c10bc839>] ? pick_next_task_fair+0x267/0x29a
[  240.220698]  [<c25fab5f>] __schedule+0x893/0xa1b
[  240.221178]  [<c25fae2c>] schedule+0x145/0x155
[  240.221629]  [<c25fae66>] schedule_preempt_disabled+0x2a/0x4e
[  240.222220]  [<c25fc513>] mutex_lock_nested+0x470/0x8cd
[  240.222763]  [<c1a52953>] ? drm_modeset_lock_all+0x23/0x80
[  240.223321]  [<c1a52953>] ? drm_modeset_lock_all+0x23/0x80
[  240.223872]  [<c1a52953>] drm_modeset_lock_all+0x23/0x80
[  240.224418]  [<c1a3c19f>] drm_fb_helper_initial_config+0x2d0/0x78e
[  240.225059]  [<c10c411d>] ? debug_mutex_unlock+0x31a/0x3ca
[  240.225629]  [<c25fd107>] ? _mutex_lock_nest_lock+0x797/0x8c9
[  240.226213]  [<c25fe6cc>] ? __mutex_unlock_slowpath+0x2eb/0x30f
[  240.226811]  [<c1a52a13>] ? drm_modeset_unlock_all+0x63/0x76
[  240.227406]  [<c1cbd75d>] cirrus_fbdev_init+0xf8/0x115
[  240.227947]  [<c1cbc61b>] cirrus_modeset_init+0x2ee/0x3a9
[  240.228505]  [<c1cba8f8>] ? cirrus_device_init+0x153/0x1e9
[  240.229083]  [<c1cbabeb>] cirrus_driver_load+0x134/0x1c3
[  240.229633]  [<c1a4bd17>] drm_dev_register+0xf0/0x1f4
[  240.230149]  [<c1a4e5ea>] drm_get_pci_dev+0x207/0x336
[  240.230668]  [<c1cbc9e9>] ? cirrus_kick_out_firmware_fb+0x11c/0x137
[  240.231312]  [<c11d5f8e>] ? kfree+0x14e/0x1d4
[  240.231764]  [<c1cbca50>] cirrus_pci_probe+0x4c/0x5e
[  240.232279]  [<c18a468b>] pci_device_probe+0xd0/0x1a5
[  240.232824]  [<c127c9fc>] ? sysfs_create_link+0x20/0x30
[  240.233376]  [<c1e212f8>] driver_probe_device+0x137/0x3fe
[  240.233926]  [<c1e2165f>] __driver_attach+0xa0/0xf4
[  240.234420]  [<c1e1e4ee>] bus_for_each_dev+0x96/0xf3
[  240.234926]  [<c1e20df6>] driver_attach+0x25/0x35
[  240.235413]  [<c1e215bf>] ? driver_probe_device+0x3fe/0x3fe
[  240.235976]  [<c1e1f40a>] bus_add_driver+0x161/0x389
[  240.236483]  [<c1e225eb>] driver_register+0x16e/0x1f6
[  240.237006]  [<c10cbcfb>] ? __raw_spin_lock_init+0x49/0x78
[  240.237570]  [<c18a4305>] __pci_register_driver+0x61/0x72
[  240.238129]  [<c1a4e7b6>] drm_pci_init+0x9d/0x18c
[  240.238623]  [<c33bb5ca>] ? ftrace_define_fields_i915_gem_object_create+0xa9/0xa9
[  240.239367]  [<c33bb601>] cirrus_init+0x37/0x4f
[  240.239838]  [<c333e5fb>] do_one_initcall+0xf4/0x26c
[  240.240346]  [<c1854fe9>] ? trace_hardirqs_on_thunk+0xc/0x10
[  240.240959]  [<c26039d6>] ? restore_all+0xf/0xf
[  240.241420]  [<c333ec04>] kernel_init_freeable+0x491/0x62a
[  240.241990]  [<c333d652>] ? do_early_param+0x12b/0x12b
[  240.242531]  [<c259fe0e>] kernel_init+0x19/0x1f6
[  240.243013]  [<c10b4d92>] ? schedule_tail+0x1a/0xa9
[  240.243517]  [<c26042a0>] ret_from_kernel_thread+0x20/0x30
[  240.244076]  [<c259fdf5>] ? rest_init+0x1dd/0x1dd
[  240.244565] 5 locks held by swapper/1:
[  240.244959]  #0:  (&dev->mutex){......}, at: [<c1e20553>] device_lock+0x1b/0x2b
[  240.245769]  #1:  (&dev->mutex){......}, at: [<c1e20553>] device_lock+0x1b/0x2b
[  240.246599]  #2:  (drm_global_mutex){......}, at: [<c1a4bc4b>] drm_dev_register+0x24/0x1f4
[  240.247513]  #3:  (&dev->mode_config.mutex){......}, at: [<c1a3c18a>] drm_fb_helper_initial_config+0x2bb/0x78e
[  240.248628]  #4:  (&dev->mode_config.mutex){......}, at: [<c1a52953>] drm_modeset_lock_all+0x23/0x80
[  240.249627] sending NMI to all CPUs:
[  240.250023] NMI backtrace for cpu 0
[  240.250387] CPU: 0 PID: 8 Comm: khungtaskd Not tainted 3.15.0-rc5-00087-gb739c99 #1
[  240.251155] task: d35d0410 ti: d35f8000 task.ti: d35f8000
[  240.251694] EIP: 0060:[<c10458b6>] EFLAGS: 00000046 CPU: 0
[  240.252263] EIP is at native_apic_mem_write+0x20/0x30
[  240.252623] EAX: ffffb300 EBX: 00000201 ECX: fffff000 EDX: 00000c00
[  240.252623] ESI: 00000002 EDI: 01000000 EBP: d35f9e9c ESP: d35f9e9c
[  240.252623]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[  240.252623] CR0: 8005003b CR2: 00000000 CR3: 11ec1000 CR4: 000006d0
[  240.252623] Stack:
[  240.252623]  d35f9eb4 c1045a5c 00000800 00000246 00000001 00000000 d35f9ed0 c1045f92
[  240.252623]  00000002 00000000 00000002 d3422000 d3422000 d35f9ed8 c1045fee d35f9ee8
[  240.252623]  c10462cd c2d5dce2 00000002 d35f9f30 c111fecf c2d6bb8b c3480e6c c2ef6456
[  240.252623] Call Trace:
[  240.252623]  [<c1045a5c>] __default_send_IPI_dest_field+0xec/0x100
[  240.252623]  [<c1045f92>] default_send_IPI_mask_logical+0x16c/0x17d
[  240.252623]  [<c1045fee>] default_send_IPI_all+0x38/0x94
[  240.252623]  [<c10462cd>] arch_trigger_all_cpu_backtrace+0xc5/0x1b8
[  240.252623]  [<c111fecf>] watchdog+0x55d/0x61a
[  240.252623]  [<c111f972>] ? rcu_read_lock+0x81/0x81
[  240.252623]  [<c10a2581>] kthread+0x115/0x128
[  240.252623]  [<c10c7fed>] ? lock_release+0x3ca/0x48a
[  240.252623]  [<c26042a0>] ret_from_kernel_thread+0x20/0x30
[  240.252623]  [<c10a246c>] ? __kthread_unpark+0x9b/0x9b
[  240.252623] Code: 83 15 f4 db 46 c3 00 89 c8 5d c3 55 89 e5 83 05 08 dc 46 c3 01 83 15 0c dc 46 c3 00 8b 0d 74 bd f1 c2 8d 84 08 00 c0 ff ff 89 10 <83> 05 10 dc 46 c3 01 83 15 14 dc 46 c3 00 5d c3 55 89 e5 09 c8

git bisect start 5dba024fe84a491ec3ca15193923fcbb938e68f7 fad01e866afdbe01a1f3ec06a39c3a8b9e197014 --
git bisect good 12072cdd5c9b56bb6d4169c5a52c9d0bf64b7f84  # 12:32     20+      0  Merge 'gxt/unicore32' into devel-hourly-2014060210
git bisect good eb1a12ad1d5a7312a6f3dc6a8b77c51cbe58641e  # 12:42     20+      0  Merge 'luto/auditsc-lite' into devel-hourly-2014060210
git bisect good d641155270aff21eacd2622e30129cd91fe8d2d2  # 12:51     20+      0  Merge 'wsa/i2c/for-next' into devel-hourly-2014060210
git bisect good 002fa82dac6f0be486333e6424968c0c42c0e799  # 13:01     20+      0  Merge 'jbarnes/async' into devel-hourly-2014060210
git bisect  bad 1ea52a9605be1234b7da3e4d134917c7ba3be93d  # 13:15      0-      5  Merge 'jbarnes/async-fb-probe' into devel-hourly-2014060210
git bisect  bad f728080d6bac47aab2d570492acef88317ac8e03  # 13:41      0-     10  drm/i915: make fbdev initialization asynchronous v2
git bisect  bad b739c9982801e5f76097311b67dfd76891b10988  # 13:50      0-     11  drm: take modeset locks around initial fb helper probing
# first bad commit: [b739c9982801e5f76097311b67dfd76891b10988] drm: take modeset locks around initial fb helper probing
git bisect good 071f9c57eea4876288ba1254c9ac3b0f077c2dd6  # 14:01     60+      1  drm/i915/vlv: enable PPGTT
git bisect  bad 5dba024fe84a491ec3ca15193923fcbb938e68f7  # 14:01      0-     13  0day head guard for 'devel-hourly-2014060210'
git bisect good fad01e866afdbe01a1f3ec06a39c3a8b9e197014  # 14:08     60+      0  Linux 3.15-rc8
git bisect good 322c030f5462a44ce42f8804284eb52b7cd2ba41  # 14:25     60+     60  Add linux-next specific files for 20140530


This script may reproduce the error.

-----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-i386.cgz

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

--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-ivb42-69:20140602135027:i386-randconfig-c1-06021140:3.15.0-rc5-00087-gb739c99:1"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.15.0-rc5-00087-gb739c99 (kbuild@cairo) (gcc =
version 4.8.2 (Debian 4.8.2-18) ) #1 Mon Jun 2 13:45:33 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
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
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x100000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[c00fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x043fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13800000-0x13bfffff]
[    0.000000]  [mem 0x13800000-0x13bfffff] page 4k
[    0.000000] BRK [0x0404c000, 0x0404cfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x137fffff]
[    0.000000]  [mem 0x10000000-0x137fffff] page 4k
[    0.000000] BRK [0x0404d000, 0x0404dfff] PGTABLE
[    0.000000] BRK [0x0404e000, 0x0404efff] PGTABLE
[    0.000000] BRK [0x0404f000, 0x0404ffff] PGTABLE
[    0.000000] BRK [0x04050000, 0x04050fff] PGTABLE
[    0.000000] BRK [0x04051000, 0x04051fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
[    0.000000] ACPI: RSDP 0x000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x13FFFF40 000040
[    0.000000] ACPI: SSDT 0x13FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat c32bd944, node_mem_map d3=
8f7024
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 684 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
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
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 2f17740
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81100
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-c1-06021140/linux-d=
evel:devel-hourly-2014060210:b739c9982801e5f76097311b67dfd76891b10988:bisec=
t-linux4/.vmlinuz-b739c9982801e5f76097311b67dfd76891b10988-20140602134606-1=
3-ivb42 branch=3Dlinux-devel/devel-hourly-2014060210 BOOT_IMAGE=3D/kernel/i=
386-randconfig-c1-06021140/b739c9982801e5f76097311b67dfd76891b10988/vmlinuz=
-3.15.0-rc5-00087-gb739c99 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 270880K/327280K available (22547K kernel code, 4403K=
 rwdata, 9068K rodata, 1056K init, 12248K bss, 56400K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff8d000 - 0xfffff000   ( 456 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xff7fe000   ( 688 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xc333d000 - 0xc3445000   (1056 kB)
[    0.000000]       .data : 0xc26051ae - 0xc333be40   (13531 kB)
[    0.000000]       .text : 0xc1000000 - 0xc26051ae   (22548 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:2304 nr_irqs:48 16
[    0.000000] CPU 0 irqstacks, hard=3Dd3402000 soft=3Dd3404000
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
[    0.000000]  memory used by lock dependency info: 3551 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] ODEBUG: 12 of 12 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.368 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5386.73 Bogo=
MIPS (lpj=3D10773472)
[    0.008000] pid_max: default: 4096 minimum: 301
[    0.008000] ACPI: Core revision 20140214
[    0.013767] ACPI: All ACPI Tables successfully acquired
[    0.014307] Security Framework initialized
[    0.014671] AppArmor: AppArmor disabled by boot time parameter
[    0.015190] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.015759] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.016390] Initializing cgroup subsys devices
[    0.016789] Initializing cgroup subsys freezer
[    0.017186] Initializing cgroup subsys blkio
[    0.017555] Initializing cgroup subsys net_prio
[    0.017943] Initializing cgroup subsys hugetlb
[    0.018402] mce: CPU supports 10 MCE banks
[    0.018819] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.018819] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.018819] tlb_flushall_shift: 6
[    0.020008] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.022113] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.023359] ftrace: Allocated trace_printk buffers
[    0.026397] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.026862] Getting VERSION: 50014
[    0.027165] Getting VERSION: 50014
[    0.027457] Getting ID: 0
[    0.027690] Getting ID: f000000
[    0.028012] Getting LVT0: 8700
[    0.028292] Getting LVT1: 8400
[    0.028577] enabled ExtINT on CPU#0
[    0.029589] ENABLING IO-APIC IRQs
[    0.029877] init IO_APIC IRQs
[    0.030143]  apic 0 pin 0 not connected
[    0.030493] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.031186] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.032025] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.032716] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.033405] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.034082] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.034772] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.035463] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.036025] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.036704] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.037405] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.038104] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.038799] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.039500] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.040024] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.040717]  apic 0 pin 16 not connected
[    0.041061]  apic 0 pin 17 not connected
[    0.041398]  apic 0 pin 18 not connected
[    0.041734]  apic 0 pin 19 not connected
[    0.042079]  apic 0 pin 20 not connected
[    0.042416]  apic 0 pin 21 not connected
[    0.042751]  apic 0 pin 22 not connected
[    0.043094]  apic 0 pin 23 not connected
[    0.044146] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.044746] Using local APIC timer interrupts.
[    0.044746] calibrating APIC timer ...
[    0.048000] ... lapic delta =3D 6250396
[    0.048000] ... PM-Timer delta =3D 357984
[    0.048000] ... PM-Timer result ok
[    0.048000] ..... delta 6250396
[    0.048000] ..... mult: 268452464
[    0.048000] ..... calibration result: 4000253
[    0.048000] ..... CPU clock speed is 2693.3724 MHz.
[    0.048000] ..... host bus clock speed is 1000.0253 MHz.
[    0.048000] gcov: version magic: 0x3430382a
[    0.049069] xor: measuring software checksum speed
[    0.088021]    pIII_sse  :   143.000 MB/sec
[    0.128024]    prefetch64-sse:   145.000 MB/sec
[    0.128479] xor: using function: prefetch64-sse (145.000 MB/sec)
[    0.129521] regulator-dummy: no parameters
[    0.130204] NET: Registered protocol family 16
[    0.132125] EISA bus registered
[    0.132466] cpuidle: using governor menu
[    0.133848] ACPI: bus type PCI registered
[    0.134304] dca service started, version 1.12.1
[    0.134846] PCI: Using configuration type 1 for base access
[    0.224077] raid6: mmxx1      792 MB/s
[    0.292056] raid6: mmxx2      912 MB/s
[    0.360085] raid6: sse1x1     730 MB/s
[    0.428018] raid6: sse1x2     831 MB/s
[    0.496021] raid6: sse2x1    1511 MB/s
[    0.564036] raid6: sse2x2    1684 MB/s
[    0.564420] raid6: using algorithm sse2x2 (1684 MB/s)
[    0.564923] raid6: using intx1 recovery algorithm
[    0.565979] ACPI: Added _OSI(Module Device)
[    0.566415] ACPI: Added _OSI(Processor Device)
[    0.566868] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.567339] ACPI: Added _OSI(Processor Aggregator Device)
[    0.579817] ACPI: Interpreter enabled
[    0.580010] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140214/hwxface-580)
[    0.580955] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140214/hwxface-580)
[    0.581920] ACPI: (supports S0 S3 S5)
[    0.582293] ACPI: Using IOAPIC for interrupt routing
[    0.582851] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.599957] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.600014] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.600583] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.602304] PCI host bridge to bus 0000:00
[    0.602728] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.603288] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.604008] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.604648] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.605362] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.606136] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.607363] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.608817] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.612007] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.613440] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.614143] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.614794] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.615492] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.616394] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.617294] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.618019] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.619330] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.623401] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.625249] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.632092] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.633579] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.635020] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.636424] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.641228] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.642495] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.643565] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.647211] pci_bus 0000:00: on NUMA node 0
[    0.648996] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.649948] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.650887] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.651819] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.652324] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.653966] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.656800] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.657606] vgaarb: loaded
[    0.657890] vgaarb: bridge control possible 0000:00:02.0
[    0.660399] SCSI subsystem initialized
[    0.660910] libata version 3.00 loaded.
[    0.661763] Linux video capture interface: v2.00
[    0.662389] pps_core: LinuxPPS API ver. 1 registered
[    0.662935] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.663878] PTP clock support registered
[    0.664211] wmi: Mapper loaded
[    0.664874] PCI: Using ACPI for IRQ routing
[    0.665327] PCI: pci_cache_line_size set to 64 bytes
[    0.665953] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.666576] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.668282] Bluetooth: Core ver 2.19
[    0.668736] NET: Registered protocol family 31
[    0.669207] Bluetooth: HCI device and connection manager initialized
[    0.669875] Bluetooth: HCI socket layer initialized
[    0.670395] Bluetooth: L2CAP socket layer initialized
[    0.671100] Bluetooth: SCO socket layer initialized
[    0.671681] NET: Registered protocol family 8
[    0.672008] NET: Registered protocol family 20
[    0.673407] Switched to clocksource kvm-clock
[    0.674662] Warning: could not register annotated branches stats
[    0.764234] FS-Cache: Loaded
[    0.764663] CacheFiles: Loaded
[    0.765086] pnp: PnP ACPI init
[    0.765451] ACPI: bus type PNP registered
[    0.765988] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.766941] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.767654] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.768541] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.769253] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.770192] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.770946] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.771804] pnp 00:03: [dma 2]
[    0.772207] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.772995] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.773867] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.774762] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.775654] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.776409] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.777491] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.778646] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.779808] pnp: PnP ACPI: found 8 devices
[    0.780226] ACPI: bus type PNP unregistered
[    0.816717] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.817295] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.817839] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.818455] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.819174] NET: Registered protocol family 2
[    0.820268] TCP established hash table entries: 4096 (order: 2, 16384 by=
tes)
[    0.821081] TCP bind hash table entries: 4096 (order: 5, 147456 bytes)
[    0.822081] TCP: Hash tables configured (established 4096 bind 4096)
[    0.822791] TCP: reno registered
[    0.823144] UDP hash table entries: 256 (order: 2, 20480 bytes)
[    0.823781] UDP-Lite hash table entries: 256 (order: 2, 20480 bytes)
[    0.824654] NET: Registered protocol family 1
[    0.825109] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.825708] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.826303] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.826969] pci 0000:00:02.0: Boot video device
[    0.827452] PCI: CLS 0 bytes, default 64
[    0.828372] Unpacking initramfs...
[    0.967922] debug: unmapping init [mem 0xd3cbd000-0xd3feffff]
[    0.969528] Machine check injector initialized
[    0.970241] apm: BIOS not found.
[    0.971130] cryptomgr_test (18) used greatest stack depth: 7376 bytes le=
ft
[    0.972700] PCLMULQDQ-NI instructions are not detected.
[    0.973322] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    0.974257] NatSemi SCx200 Driver
[    0.975980] Initializing RT-Tester: OK
[    0.976396] spin_lock-torture:--- Start of test: nwriters_stress=3D2 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    0.977874] spin_lock-torture: Creating torture_shuffle task
[    0.978546] spin_lock-torture: Creating torture_stutter task
[    0.979164] spin_lock-torture: torture_shuffle task started
[    0.979742] spin_lock-torture: Creating lock_torture_writer task
[    0.980516] spin_lock-torture: torture_stutter task started
[    0.981090] spin_lock-torture: Creating lock_torture_writer task
[    0.981727] spin_lock-torture: lock_torture_writer task started
[    0.982349] spin_lock-torture: Creating lock_torture_stats task
[    0.983021] spin_lock-torture: lock_torture_writer task started
[    0.984233] futex hash table entries: 16 (order: -3, 704 bytes)
[    0.984841] Initialise system trusted keyring
[    0.985345] audit: initializing netlink subsys (disabled)
[    0.986127] audit: type=3D2000 audit(1401687982.223:1): initialized
[    0.986790] spin_lock-torture: lock_torture_stats task started
[    1.966975] tsc: Refined TSC clocksource calibration: 2693.496 MHz
[    2.019434] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    2.020278] VFS: Disk quotas dquot_6.5.2
[    2.020700] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.022234] DLM installed
[    2.023332] ntfs: driver 2.1.30 [Flags: R/W DEBUG].
[    2.023948] fuse init (API version 7.23)
[    2.024551] SGI XFS with security attributes, no debug enabled
[    2.026454] ocfs2 stack glue: unable to register sysctl
[    2.027004] ocfs2: Registered cluster interface o2cb
[    2.027648] OCFS2 User DLM kernel interface loaded
[    2.052634] Key type asymmetric registered
[    2.053108] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    2.054269] io scheduler noop registered
[    2.054708] io scheduler cfq registered (default)
[    2.061376] xz_dec_test: module loaded
[    2.061760] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
249 0' and write .xz files to it.
[    2.062703] rbtree testing -> 16114 cycles
[    2.755281] augmented rbtree testing -> 22218 cycles
[    3.709213] no IO addresses supplied
[    3.709805] hgafb: HGA card not detected.
[    3.710223] hgafb: probe of hgafb.0 failed with error -22
[    3.714646] v86d (100) used greatest stack depth: 6852 bytes left
[    3.716737] v86d[101]: segfault at 0 ip 080492bf sp bfdd2cd0 error 4 in =
v86d[8047000+1c000]
[    3.717899] v86d (101) used greatest stack depth: 6596 bytes left
[    8.718356] uvesafb: Getting VBE info block failed (eax=3D0x4f00, err=3D=
1)
[    8.719054] uvesafb: vbe_init() failed with -22
[    8.723368] uvesafb: probe of uvesafb.0 failed with error -22
[    8.724128] ipmi message handler version 39.2
[    8.724581] ipmi device interface
[    8.725044] IPMI System Interface driver.
[    8.726377] ipmi_si: Adding default-specified kcs state machine
[    8.727000] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    8.728086] ipmi_si: Interface detection failed
[    8.728577] ipmi_si: Adding default-specified smic state machine
[    8.729191] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    8.730203] ipmi_si: Interface detection failed
[    8.730664] ipmi_si: Adding default-specified bt state machine
[    8.731261] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    8.732283] ipmi_si: Interface detection failed
[    8.732905] ipmi_si: Unable to find any System Interface(s)
[    8.733464] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    8.734588] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    8.735348] ACPI: Power Button [PWRF]
[    8.736747] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    8.838014] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    8.864174] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    8.867622] sonypi: Sony Programmable I/O Controller Driver v1.26.
[    8.868278] toshiba: not a supported Toshiba laptop
[    8.868907] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    8.869679] platform pc8736x_gpio.0: no device found
[    8.870271] nsc_gpio initializing
[    8.870637] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    8.871288] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    8.872218] Hangcheck: Using getrawmonotonic().
[    8.873617] [drm] Initialized drm 1.1.0 20060810
[    8.874286] [drm] radeon kernel modesetting enabled.
[    8.876773] [TTM] Zone  kernel: Available graphics memory: 135440 kiB
[    8.877424] [TTM] Initializing pool allocator
[   61.017759] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  121.025590] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  181.030819] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[  240.212728] INFO: task swapper:1 blocked for more than 120 seconds.
[  240.213429]       Not tainted 3.15.0-rc5-00087-gb739c99 #1
[  240.213994] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[  240.214777] swapper         D d3429c24  5944     1      0 0x00000000
[  240.215484]  d3429c48 00000046 00000000 d3429c24 c184af4c c2f31008 d3422=
000 d1f2d034
[  240.216408]  c2f31008 d1f2d034 c2f30fe0 c2f30fe0 d3429c1c c10bbfe0 d1f2d=
02c c2f30fe0
[  240.217339]  d3429c2c c10bc022 d1f2d02c 00000001 00000001 c10bc839 00000=
002 c2f30fe0
[  240.218258] Call Trace:
[  240.218551]  [<c184af4c>] ? rb_erase+0x3d/0x576
[  240.219043]  [<c10bbfe0>] ? __dequeue_entity+0x4d/0x5f
[  240.219573]  [<c10bc022>] ? set_next_entity+0x30/0x63
[  240.220108]  [<c10bc839>] ? pick_next_task_fair+0x267/0x29a
[  240.220698]  [<c25fab5f>] __schedule+0x893/0xa1b
[  240.221178]  [<c25fae2c>] schedule+0x145/0x155
[  240.221629]  [<c25fae66>] schedule_preempt_disabled+0x2a/0x4e
[  240.222220]  [<c25fc513>] mutex_lock_nested+0x470/0x8cd
[  240.222763]  [<c1a52953>] ? drm_modeset_lock_all+0x23/0x80
[  240.223321]  [<c1a52953>] ? drm_modeset_lock_all+0x23/0x80
[  240.223872]  [<c1a52953>] drm_modeset_lock_all+0x23/0x80
[  240.224418]  [<c1a3c19f>] drm_fb_helper_initial_config+0x2d0/0x78e
[  240.225059]  [<c10c411d>] ? debug_mutex_unlock+0x31a/0x3ca
[  240.225629]  [<c25fd107>] ? _mutex_lock_nest_lock+0x797/0x8c9
[  240.226213]  [<c25fe6cc>] ? __mutex_unlock_slowpath+0x2eb/0x30f
[  240.226811]  [<c1a52a13>] ? drm_modeset_unlock_all+0x63/0x76
[  240.227406]  [<c1cbd75d>] cirrus_fbdev_init+0xf8/0x115
[  240.227947]  [<c1cbc61b>] cirrus_modeset_init+0x2ee/0x3a9
[  240.228505]  [<c1cba8f8>] ? cirrus_device_init+0x153/0x1e9
[  240.229083]  [<c1cbabeb>] cirrus_driver_load+0x134/0x1c3
[  240.229633]  [<c1a4bd17>] drm_dev_register+0xf0/0x1f4
[  240.230149]  [<c1a4e5ea>] drm_get_pci_dev+0x207/0x336
[  240.230668]  [<c1cbc9e9>] ? cirrus_kick_out_firmware_fb+0x11c/0x137
[  240.231312]  [<c11d5f8e>] ? kfree+0x14e/0x1d4
[  240.231764]  [<c1cbca50>] cirrus_pci_probe+0x4c/0x5e
[  240.232279]  [<c18a468b>] pci_device_probe+0xd0/0x1a5
[  240.232824]  [<c127c9fc>] ? sysfs_create_link+0x20/0x30
[  240.233376]  [<c1e212f8>] driver_probe_device+0x137/0x3fe
[  240.233926]  [<c1e2165f>] __driver_attach+0xa0/0xf4
[  240.234420]  [<c1e1e4ee>] bus_for_each_dev+0x96/0xf3
[  240.234926]  [<c1e20df6>] driver_attach+0x25/0x35
[  240.235413]  [<c1e215bf>] ? driver_probe_device+0x3fe/0x3fe
[  240.235976]  [<c1e1f40a>] bus_add_driver+0x161/0x389
[  240.236483]  [<c1e225eb>] driver_register+0x16e/0x1f6
[  240.237006]  [<c10cbcfb>] ? __raw_spin_lock_init+0x49/0x78
[  240.237570]  [<c18a4305>] __pci_register_driver+0x61/0x72
[  240.238129]  [<c1a4e7b6>] drm_pci_init+0x9d/0x18c
[  240.238623]  [<c33bb5ca>] ? ftrace_define_fields_i915_gem_object_create+=
0xa9/0xa9
[  240.239367]  [<c33bb601>] cirrus_init+0x37/0x4f
[  240.239838]  [<c333e5fb>] do_one_initcall+0xf4/0x26c
[  240.240346]  [<c1854fe9>] ? trace_hardirqs_on_thunk+0xc/0x10
[  240.240959]  [<c26039d6>] ? restore_all+0xf/0xf
[  240.241420]  [<c333ec04>] kernel_init_freeable+0x491/0x62a
[  240.241990]  [<c333d652>] ? do_early_param+0x12b/0x12b
[  240.242531]  [<c259fe0e>] kernel_init+0x19/0x1f6
[  240.243013]  [<c10b4d92>] ? schedule_tail+0x1a/0xa9
[  240.243517]  [<c26042a0>] ret_from_kernel_thread+0x20/0x30
[  240.244076]  [<c259fdf5>] ? rest_init+0x1dd/0x1dd
[  240.244565] 5 locks held by swapper/1:
[  240.244959]  #0:  (&dev->mutex){......}, at: [<c1e20553>] device_lock+0x=
1b/0x2b
[  240.245769]  #1:  (&dev->mutex){......}, at: [<c1e20553>] device_lock+0x=
1b/0x2b
[  240.246599]  #2:  (drm_global_mutex){......}, at: [<c1a4bc4b>] drm_dev_r=
egister+0x24/0x1f4
[  240.247513]  #3:  (&dev->mode_config.mutex){......}, at: [<c1a3c18a>] dr=
m_fb_helper_initial_config+0x2bb/0x78e
[  240.248628]  #4:  (&dev->mode_config.mutex){......}, at: [<c1a52953>] dr=
m_modeset_lock_all+0x23/0x80
[  240.249627] sending NMI to all CPUs:
[  240.250023] NMI backtrace for cpu 0
[  240.250387] CPU: 0 PID: 8 Comm: khungtaskd Not tainted 3.15.0-rc5-00087-=
gb739c99 #1
[  240.251155] task: d35d0410 ti: d35f8000 task.ti: d35f8000
[  240.251694] EIP: 0060:[<c10458b6>] EFLAGS: 00000046 CPU: 0
[  240.252263] EIP is at native_apic_mem_write+0x20/0x30
[  240.252623] EAX: ffffb300 EBX: 00000201 ECX: fffff000 EDX: 00000c00
[  240.252623] ESI: 00000002 EDI: 01000000 EBP: d35f9e9c ESP: d35f9e9c
[  240.252623]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[  240.252623] CR0: 8005003b CR2: 00000000 CR3: 11ec1000 CR4: 000006d0
[  240.252623] Stack:
[  240.252623]  d35f9eb4 c1045a5c 00000800 00000246 00000001 00000000 d35f9=
ed0 c1045f92
[  240.252623]  00000002 00000000 00000002 d3422000 d3422000 d35f9ed8 c1045=
fee d35f9ee8
[  240.252623]  c10462cd c2d5dce2 00000002 d35f9f30 c111fecf c2d6bb8b c3480=
e6c c2ef6456
[  240.252623] Call Trace:
[  240.252623]  [<c1045a5c>] __default_send_IPI_dest_field+0xec/0x100
[  240.252623]  [<c1045f92>] default_send_IPI_mask_logical+0x16c/0x17d
[  240.252623]  [<c1045fee>] default_send_IPI_all+0x38/0x94
[  240.252623]  [<c10462cd>] arch_trigger_all_cpu_backtrace+0xc5/0x1b8
[  240.252623]  [<c111fecf>] watchdog+0x55d/0x61a
[  240.252623]  [<c111f972>] ? rcu_read_lock+0x81/0x81
[  240.252623]  [<c10a2581>] kthread+0x115/0x128
[  240.252623]  [<c10c7fed>] ? lock_release+0x3ca/0x48a
[  240.252623]  [<c26042a0>] ret_from_kernel_thread+0x20/0x30
[  240.252623]  [<c10a246c>] ? __kthread_unpark+0x9b/0x9b
[  240.252623] Code: 83 15 f4 db 46 c3 00 89 c8 5d c3 55 89 e5 83 05 08 dc =
46 c3 01 83 15 0c dc 46 c3 00 8b 0d 74 bd f1 c2 8d 84 08 00 c0 ff ff 89 10 =
<83> 05 10 dc 46 c3 01 83 15 14 dc 46 c3 00 5d c3 55 89 e5 09 c8
[  240.252623] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 16.768 msecs
[  240.267835] Kernel panic - not syncing: hung_task: blocked tasks
[  240.268444] CPU: 0 PID: 8 Comm: khungtaskd Not tainted 3.15.0-rc5-00087-=
gb739c99 #1
[  240.269224]  d3422000 d35f9ec8 c25e2715 d35f9ee8 c25a7df7 c2d62b0f c3480=
e84 d35f9ee8
[  240.270125]  00000002 d3422000 d3422000 d35f9f30 c111fee9 c2d6bbd8 c3480=
e6c c2ef6456
[  240.271030]  00000002 c2ef6497 000000d6 d3422120 00000000 00007fff 00007=
fff 000003ff
[  240.271818] Call Trace:
[  240.271818]  [<c25e2715>] dump_stack+0x40/0x5e
[  240.271818]  [<c25a7df7>] panic+0x17a/0x3c1
[  240.271818]  [<c111fee9>] watchdog+0x577/0x61a
[  240.271818]  [<c111f972>] ? rcu_read_lock+0x81/0x81
[  240.271818]  [<c10a2581>] kthread+0x115/0x128
[  240.271818]  [<c10c7fed>] ? lock_release+0x3ca/0x48a
[  240.271818]  [<c26042a0>] ret_from_kernel_thread+0x20/0x30
[  240.271818]  [<c10a246c>] ? __kthread_unpark+0x9b/0x9b
[  240.271818] Kernel Offset: 0x0 from 0xc1000000 (relocation range: 0xc000=
0000-0xd47fdfff)

Elapsed time: 245
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-c=
1-06021140/b739c9982801e5f76097311b67dfd76891b10988/vmlinuz-3.15.0-rc5-0008=
7-gb739c99 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug ap=
ic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=
=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kb=
uild-tests/run-queue/kvm/i386-randconfig-c1-06021140/linux-devel:devel-hour=
ly-2014060210:b739c9982801e5f76097311b67dfd76891b10988:bisect-linux4/.vmlin=
uz-b739c9982801e5f76097311b67dfd76891b10988-20140602134606-13-ivb42 branch=
=3Dlinux-devel/devel-hourly-2014060210 BOOT_IMAGE=3D/kernel/i386-randconfig=
-c1-06021140/b739c9982801e5f76097311b67dfd76891b10988/vmlinuz-3.15.0-rc5-00=
087-gb739c99 drbd.minor_count=3D8'  -initrd /kernel-tests/initrd/yocto-mini=
mal-i386.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=
=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -=
pidfile /dev/shm/kboot/pid-yocto-ivb42-69 -serial file:/dev/shm/kboot/seria=
l-yocto-ivb42-69 -daemonize -display none -monitor null=20

--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-ivb42-28:20140602135742:i386-randconfig-c1-06021140:3.15.0-rc5-00086-g071f9c5:1"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.15.0-rc5-00086-g071f9c5 (kbuild@cairo) (gcc =
version 4.8.2 (Debian 4.8.2-18) ) #1 Mon Jun 2 13:54:11 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
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
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x100000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[c00fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x043fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12000000-0x123fffff]
[    0.000000]  [mem 0x12000000-0x123fffff] page 4k
[    0.000000] BRK [0x0404c000, 0x0404cfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x11ffffff]
[    0.000000]  [mem 0x10000000-0x11ffffff] page 4k
[    0.000000] BRK [0x0404d000, 0x0404dfff] PGTABLE
[    0.000000] BRK [0x0404e000, 0x0404efff] PGTABLE
[    0.000000] BRK [0x0404f000, 0x0404ffff] PGTABLE
[    0.000000] BRK [0x04050000, 0x04050fff] PGTABLE
[    0.000000] BRK [0x04051000, 0x04051fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12400000-0x13ffdfff]
[    0.000000]  [mem 0x12400000-0x13ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
[    0.000000] ACPI: RSDP 0x000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x13FFFF40 000040
[    0.000000] ACPI: SSDT 0x13FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat c32bd944, node_mem_map d2=
4db024
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 684 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
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
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 2f17740
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81100
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-c1-06021140/linux-d=
evel:devel-hourly-2014060210:071f9c57eea4876288ba1254c9ac3b0f077c2dd6:bisec=
t-linux4/.vmlinuz-071f9c57eea4876288ba1254c9ac3b0f077c2dd6-20140602135444-1=
4-ivb42 branch=3Dlinux-devel/devel-hourly-2014060210 BOOT_IMAGE=3D/kernel/i=
386-randconfig-c1-06021140/071f9c57eea4876288ba1254c9ac3b0f077c2dd6/vmlinuz=
-3.15.0-rc5-00086-g071f9c5 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 249304K/327280K available (22547K kernel code, 4403K=
 rwdata, 9068K rodata, 1056K init, 12248K bss, 77976K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff8d000 - 0xfffff000   ( 456 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xff7fe000   ( 688 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xc333d000 - 0xc3445000   (1056 kB)
[    0.000000]       .data : 0xc260518e - 0xc333be40   (13531 kB)
[    0.000000]       .text : 0xc1000000 - 0xc260518e   (22548 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:2304 nr_irqs:48 16
[    0.000000] CPU 0 irqstacks, hard=3Dd1c02000 soft=3Dd1c04000
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
[    0.000000]  memory used by lock dependency info: 3551 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] ODEBUG: 12 of 12 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.368 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5386.73 Bogo=
MIPS (lpj=3D10773472)
[    0.008000] pid_max: default: 4096 minimum: 301
[    0.008000] ACPI: Core revision 20140214
[    0.021014] ACPI: All ACPI Tables successfully acquired
[    0.021901] Security Framework initialized
[    0.022487] AppArmor: AppArmor disabled by boot time parameter
[    0.023285] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.024022] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.025582] Initializing cgroup subsys devices
[    0.026165] Initializing cgroup subsys freezer
[    0.028057] Initializing cgroup subsys blkio
[    0.028780] Initializing cgroup subsys net_prio
[    0.029419] Initializing cgroup subsys hugetlb
[    0.030175] mce: CPU supports 10 MCE banks
[    0.030826] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.030826] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.030826] tlb_flushall_shift: 6
[    0.032020] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.041526] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.043427] ftrace: Allocated trace_printk buffers
[    0.048671] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.049351] Getting VERSION: 50014
[    0.049747] Getting VERSION: 50014
[    0.050188] Getting ID: 0
[    0.050508] Getting ID: f000000
[    0.051014] Getting LVT0: 8700
[    0.051372] Getting LVT1: 8400
[    0.051767] enabled ExtINT on CPU#0
[    0.053253] ENABLING IO-APIC IRQs
[    0.053693] init IO_APIC IRQs
[    0.054035]  apic 0 pin 0 not connected
[    0.056050] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.057361] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.058423] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.060041] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.061010] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.064041] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.065000] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.068041] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.069008] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.072050] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.073374] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.074503] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.076037] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.077102] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.078172] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.080041]  apic 0 pin 16 not connected
[    0.080560]  apic 0 pin 17 not connected
[    0.084013]  apic 0 pin 18 not connected
[    0.084483]  apic 0 pin 19 not connected
[    0.088014]  apic 0 pin 20 not connected
[    0.088490]  apic 0 pin 21 not connected
[    0.089169]  apic 0 pin 22 not connected
[    0.089616]  apic 0 pin 23 not connected
[    0.090260] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.092014] Using local APIC timer interrupts.
[    0.092014] calibrating APIC timer ...
[    0.096000] ... lapic delta =3D 8666787
[    0.096000] ... PM-Timer delta =3D 496382
[    0.096000] APIC calibration not consistent with PM-Timer: 138ms instead=
 of 100ms
[    0.096000] APIC delta adjusted to PM-Timer: 6249846 (8666787)
[    0.096000] TSC delta adjusted to PM-Timer: 269347764 (373509954)
[    0.096000] ..... delta 6249846
[    0.096000] ..... mult: 268428841
[    0.096000] ..... calibration result: 3999901
[    0.096000] ..... CPU clock speed is 2693.1910 MHz.
[    0.096000] ..... host bus clock speed is 999.3901 MHz.
[    0.096896] gcov: version magic: 0x3430382a
[    0.110047] xor: measuring software checksum speed
[    0.148023]    pIII_sse  :   118.000 MB/sec
[    0.188017]    prefetch64-sse:   140.000 MB/sec
[    0.188685] xor: using function: prefetch64-sse (140.000 MB/sec)
[    0.192174] regulator-dummy: no parameters
[    0.193349] NET: Registered protocol family 16
[    0.199755] EISA bus registered
[    0.200025] cpuidle: using governor menu
[    0.202184] ACPI: bus type PCI registered
[    0.202964] dca service started, version 1.12.1
[    0.204134] PCI: Using configuration type 1 for base access
[    0.320116] raid6: mmxx1      399 MB/s
[    0.388020] raid6: mmxx2      528 MB/s
[    0.456134] raid6: sse1x1     351 MB/s
[    0.524061] raid6: sse1x2     365 MB/s
[    0.592073] raid6: sse2x1     634 MB/s
[    0.660079] raid6: sse2x2     730 MB/s
[    0.661017] raid6: using algorithm sse2x2 (730 MB/s)
[    0.661826] raid6: using intx1 recovery algorithm
[    0.663704] ACPI: Added _OSI(Module Device)
[    0.664011] ACPI: Added _OSI(Processor Device)
[    0.664652] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.665357] ACPI: Added _OSI(Processor Aggregator Device)
[    0.688759] ACPI: Interpreter enabled
[    0.689338] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140214/hwxface-580)
[    0.691068] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140214/hwxface-580)
[    0.692360] ACPI: (supports S0 S3 S5)
[    0.692928] ACPI: Using IOAPIC for interrupt routing
[    0.693802] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.724341] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.725435] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.726305] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.729181] PCI host bridge to bus 0000:00
[    0.729906] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.731219] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.732015] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.732988] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.733948] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.735049] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.737038] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.739246] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.743509] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.745235] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.746415] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.748010] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.749137] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.752511] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.753927] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.755250] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.757022] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.764838] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.769789] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.778294] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.781369] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.784012] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.786090] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.792804] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.794908] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.796615] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.802227] pci_bus 0000:00: on NUMA node 0
[    0.808263] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.812012] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.813695] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.816247] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.820793] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.824411] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.832241] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.833446] vgaarb: loaded
[    0.833839] vgaarb: bridge control possible 0000:00:02.0
[    0.838100] SCSI subsystem initialized
[    0.839342] libata version 3.00 loaded.
[    0.840731] Linux video capture interface: v2.00
[    0.841859] pps_core: LinuxPPS API ver. 1 registered
[    0.842640] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.844055] PTP clock support registered
[    0.844988] wmi: Mapper loaded
[    0.846026] PCI: Using ACPI for IRQ routing
[    0.846667] PCI: pci_cache_line_size set to 64 bytes
[    0.847565] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.848019] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.850261] Bluetooth: Core ver 2.19
[    0.851005] NET: Registered protocol family 31
[    0.852011] Bluetooth: HCI device and connection manager initialized
[    0.853325] Bluetooth: HCI socket layer initialized
[    0.854301] Bluetooth: L2CAP socket layer initialized
[    0.856202] Bluetooth: SCO socket layer initialized
[    0.857171] NET: Registered protocol family 8
[    0.858073] NET: Registered protocol family 20
[    0.860592] Switched to clocksource kvm-clock
[    0.863093] Warning: could not register annotated branches stats
[    1.069314] FS-Cache: Loaded
[    1.070150] CacheFiles: Loaded
[    1.070895] pnp: PnP ACPI init
[    1.071584] ACPI: bus type PNP registered
[    1.072534] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    1.074210] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.075528] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    1.077133] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.078517] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    1.080405] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.081883] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    1.083628] pnp 00:03: [dma 2]
[    1.084385] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.087001] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    1.091089] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.100260] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    1.102041] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.103574] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    1.105677] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.107842] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.111702] pnp: PnP ACPI: found 8 devices
[    1.120449] ACPI: bus type PNP unregistered
[    1.159876] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.160988] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.162090] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.163302] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.164682] NET: Registered protocol family 2
[    1.166385] TCP established hash table entries: 4096 (order: 2, 16384 by=
tes)
[    1.167977] TCP bind hash table entries: 4096 (order: 5, 147456 bytes)
[    1.170895] TCP: Hash tables configured (established 4096 bind 4096)
[    1.181234] TCP: reno registered
[    1.181917] UDP hash table entries: 256 (order: 2, 20480 bytes)
[    1.183311] UDP-Lite hash table entries: 256 (order: 2, 20480 bytes)
[    1.185009] NET: Registered protocol family 1
[    1.185905] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.187182] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.188572] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.189856] pci 0000:00:02.0: Boot video device
[    1.190948] PCI: CLS 0 bytes, default 64
[    1.192303] Unpacking initramfs...
[    3.923824] debug: unmapping init [mem 0xd27ab000-0xd3feffff]
[    3.927444] Machine check injector initialized
[    3.938730] apm: BIOS not found.
[    3.940866] cryptomgr_test (21) used greatest stack depth: 7376 bytes le=
ft
[    3.945051] PCLMULQDQ-NI instructions are not detected.
[    3.946199] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    3.947745] NatSemi SCx200 Driver
[    3.961616] Initializing RT-Tester: OK
[    3.962385] spin_lock-torture:--- Start of test: nwriters_stress=3D2 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    3.970659] spin_lock-torture: Creating torture_shuffle task
[    3.971848] spin_lock-torture: torture_shuffle task started
[    3.972937] spin_lock-torture: Creating torture_stutter task
[    3.978716] spin_lock-torture: Creating lock_torture_writer task
[    3.979929] spin_lock-torture: torture_stutter task started
[    3.985646] spin_lock-torture: Creating lock_torture_writer task
[    3.986748] spin_lock-torture: lock_torture_writer task started
[    3.987743] spin_lock-torture: Creating lock_torture_stats task
[    3.989078] spin_lock-torture: lock_torture_writer task started
[    4.000886] spin_lock-torture: lock_torture_stats task started
[    4.002543] futex hash table entries: 16 (order: -3, 704 bytes)
[    4.003517] Initialise system trusted keyring
[    4.004706] audit: initializing netlink subsys (disabled)
[    4.006249] audit: type=3D2000 audit(1401688580.347:1): initialized
[    5.123742] tsc: Refined TSC clocksource calibration: 2693.494 MHz
[    6.355837] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    6.361712] VFS: Disk quotas dquot_6.5.2
[    6.409589] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    6.413791] DLM installed
[    6.416054] ntfs: driver 2.1.30 [Flags: R/W DEBUG].
[    6.417158] fuse init (API version 7.23)
[    6.418235] SGI XFS with security attributes, no debug enabled
[    6.422670] ocfs2 stack glue: unable to register sysctl
[    6.423878] ocfs2: Registered cluster interface o2cb
[    6.425356] OCFS2 User DLM kernel interface loaded
[    6.474087] Key type asymmetric registered
[    6.474882] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    6.477080] io scheduler noop registered
[    6.477874] io scheduler cfq registered (default)
[    6.494481] xz_dec_test: module loaded
[    6.495243] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
249 0' and write .xz files to it.
[    6.497069] rbtree testing -> 44461 cycles
[    8.433053] augmented rbtree testing -> 57696 cycles
[   10.976593] no IO addresses supplied
[   10.977575] hgafb: HGA card not detected.
[   10.978283] hgafb: probe of hgafb.0 failed with error -22
[   10.983955] kworker/u2:0 (100) used greatest stack depth: 6964 bytes left
[   10.985444] uvesafb: failed to execute /sbin/v86d
[   10.986394] uvesafb: make sure that the v86d helper is installed and exe=
cutable
[   10.988017] uvesafb: Getting VBE info block failed (eax=3D0x4f00, err=3D=
-2)
[   10.989415] uvesafb: vbe_init() failed with -22
[   10.990343] uvesafb: probe of uvesafb.0 failed with error -22
[   10.991703] ipmi message handler version 39.2
[   10.992636] ipmi device interface
[   10.994485] IPMI System Interface driver.
[   10.995392] ipmi_si: Adding default-specified kcs state machine
[   10.996544] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[   10.998358] ipmi_si: Interface detection failed
[   10.999322] ipmi_si: Adding default-specified smic state machine
[   11.000752] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[   11.002879] ipmi_si: Interface detection failed
[   11.003859] ipmi_si: Adding default-specified bt state machine
[   11.005042] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[   11.007220] ipmi_si: Interface detection failed
[   11.008386] ipmi_si: Unable to find any System Interface(s)
[   11.009625] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[   11.013057] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   11.014677] ACPI: Power Button [PWRF]
[   11.017355] ioatdma: Intel(R) QuickData Technology Driver 4.00
[   11.295578] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   11.368015] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[   11.374580] sonypi: Sony Programmable I/O Controller Driver v1.26.
[   11.375416] toshiba: not a supported Toshiba laptop
[   11.376542] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[   11.377733] platform pc8736x_gpio.0: no device found
[   11.378834] nsc_gpio initializing
[   11.379434] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[   11.393691] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[   11.395145] Hangcheck: Using getrawmonotonic().
[   11.398480] [drm] Initialized drm 1.1.0 20060810
[   11.399438] [drm] radeon kernel modesetting enabled.
[   11.404530] [TTM] Zone  kernel: Available graphics memory: 124652 kiB
[   11.405542] [TTM] Initializing pool allocator
[   11.424444] [drm] fb mappable at 0xFC000000
[   11.425074] [drm] vram aper at 0xFC000000
[   11.425813] [drm] size 4194304
[   11.426396] [drm] fb depth is 24
[   11.426802] [drm]    pitch is 3072
[   11.427793] cirrus 0000:00:02.0: fb0: cirrusdrmfb frame buffer device
[   11.428785] cirrus 0000:00:02.0: registered panic notifier
[   11.429710] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on =
minor 0
[   11.448729] lkdtm: No crash points registered, enable through debugfs
[   11.456379] Uniform Multi-Platform E-IDE driver
[   11.471866] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[   11.473918] piix 0000:00:01.1: not 100% native mode: will probe irqs lat=
er
[   11.475558]     ide0: BM-DMA at 0xc040-0xc047
[   11.476381]     ide1: BM-DMA at 0xc048-0xc04f
[   11.477035] Probing IDE interface ide0...
[   12.189850] Probing IDE interface ide1...
[   13.175844] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[   14.036478] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[   14.037931] hdc: MWDMA2 mode selected
[   14.038915] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   14.043776] ide1 at 0x170-0x177,0x376 on irq 15
[   14.053093] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[   14.055243] ide-gd driver 1.18
[   14.058833] Loading iSCSI transport class v2.0-870.
[   14.062330] rdac: device handler registered
[   14.063510] emc: device handler registered
[   14.064625] alua: device handler registered
[   14.065443] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[   14.068173] osd: LOADED open-osd 0.2.1
[   14.070688] HSI/SSI char device loaded
[   14.071903] Intel ISA PCIC probe: not found.
[   14.073197] Databook TCIC-2 PCMCIA probe: not found.
[   14.074962] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   14.079417] serio: i8042 KBD port at 0x60,0x64 irq 1
[   14.080709] serio: i8042 AUX port at 0x60,0x64 irq 12
[   14.084116] mousedev: PS/2 mouse device common for all mice
[   14.097543] inport.c: Didn't find InPort mouse at 0x23c
[   14.101419] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   14.120222] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[   14.125290] wistron_btns: System unknown
[   14.126172] ideapad_slidebar: DMI does not match
[   14.127121] I2O subsystem v1.325
[   14.127812] i2o: max drivers =3D 8
[   14.129913] I2O Configuration OSM v1.323
[   14.130843] I2O Block Device OSM v1.325
[   14.133406] I2O SCSI Peripheral OSM v1.316
[   14.134582] I2O ProcFS OSM v1.316
[   14.143799] i2c-parport-light: adapter type unspecified
[   14.157690] pps pps0: new PPS source ktimer
[   14.158555] pps pps0: ktimer PPS source registered
[   14.170262] applesmc: supported laptop not found!
[   14.171189] applesmc: driver init failed (ret=3D-19)!
[   14.182493] pc87360: PC8736x not detected, module not inserted
[   14.188980] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[   14.190861] acquirewdt: I/O address 0x0043 already in use
[   14.201238] acquirewdt: probe of acquirewdt failed with error -5
[   14.202832] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[   14.204909] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D0)
[   14.206188] alim7101_wdt: Steve Hill <steve@navaho.co.uk>
[   14.207297] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[   14.208773] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver v0.05
[   14.212005] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[   14.213730] ib700wdt: START method I/O 443 is not available
[   14.215047] ib700wdt: probe of ib700wdt failed with error -5
[   14.216386] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   14.217569] iTCO_vendor_support: vendor-support=3D0
[   14.218659] sc1200wdt: build 20020303
[   14.219473] sc1200wdt: io parameter must be specified
[   14.220540] pc87413_wdt: Version 1.1 at io 0x2E
[   14.221471] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[   14.222997] nv_tco: NV TCO WatchDog Timer Driver v0.01
[   14.224449] sbc8360: failed to register misc device
[   14.225449] sbc7240_wdt: I/O address 0x0443 already in use
[   14.226663] cpu5wdt: misc_register failed
[   14.227737] w83977f_wdt: driver v1.00
[   14.228467] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[   14.239389] rdma_ucm: couldn't register sysctl paths
[   14.244423] iscsi: registered transport (iser)
[   14.245820] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[   14.256117] goldfish_pdev_bus goldfish_pdev_bus: unable to reserve Goldf=
ish MMIO.
[   14.257884] goldfish_pdev_bus: probe of goldfish_pdev_bus failed with er=
ror -16
[   14.266203] drop_monitor: Initializing network drop monitor service
[   14.270392] NET: Registered protocol family 26
[   14.272051] ipip: IPv4 over IPv4 tunneling driver
[   14.275295] gre: GRE over IPv4 demultiplexor driver
[   14.276368] TCP: bic registered
[   14.276973] TCP: cubic registered
[   14.277638] TCP: hybla registered
[   14.278323] TCP: vegas registered
[   14.278977] TCP: veno registered
[   14.279635] TCP: scalable registered
[   14.280331] TCP: lp registered
[   14.280948] TCP: yeah registered
[   14.281620] TCP: illinois registered
[   14.282434] NET: Registered protocol family 10
[   14.286229] mip6: Mobile IPv6
[   14.292908] NET: Registered protocol family 17
[   14.294322] NET: Registered protocol family 4
[   14.295643] NET: Registered protocol family 9
[   14.296557] X25: Linux Version 0.2
[   14.297381] Bluetooth: RFCOMM socket layer initialized
[   14.298433] Bluetooth: RFCOMM ver 1.11
[   14.299181] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   14.300274] Bluetooth: BNEP filters: protocol multicast
[   14.301311] Bluetooth: BNEP socket layer initialized
[   14.302260] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   14.303431] Bluetooth: HIDP socket layer initialized
[   14.305386] NET: Registered protocol family 33
[   14.306427] Key type rxrpc registered
[   14.307195] Key type rxrpc_s registered
[   14.308047] lec:lane_module_init: lec.c: initialized
[   14.309031] mpoa:atm_mpoa_init: mpc.c: initialized
[   14.309955] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[   14.311616] DECnet: Routing cache hash table of 256 buckets, 9Kbytes
[   14.312964] NET: Registered protocol family 12
[   14.314172] 8021q: 802.1Q VLAN Support v1.8
[   14.315632] sctp: Hash tables configured (established 2048 bind 1820)
[   14.318905] NET: Registered protocol family 37
[   14.319887] NET: Registered protocol family 36
[   14.320856] Key type dns_resolver registered
[   14.321736] Key type ceph registered
[   14.322540] libceph: loaded (mon/osd proto 15/24)
[   14.324209] batman_adv: B.A.T.M.A.N. advanced 2014.2.0 (compatibility ve=
rsion 15) loaded
[   14.325868] openvswitch: Open vSwitch switching datapath
[   14.330591]=20
[   14.330591] printing PIC contents
[   14.331518] ... PIC  IMR: ffff
[   14.332158] ... PIC  IRR: 1013
[   14.332795] ... PIC  ISR: 0000
[   14.333402] ... PIC ELCR: 0c00
[   14.334267] printing local APIC contents on CPU#0/0:
[   14.335277] ... APIC ID:      00000000 (0)
[   14.336099] ... APIC VERSION: 00050014
[   14.336774] ... APIC TASKPRI: 00000000 (00)
[   14.336774] ... APIC PROCPRI: 00000000
[   14.336774] ... APIC LDR: 01000000
[   14.336774] ... APIC DFR: ffffffff
[   14.336774] ... APIC SPIV: 000001ff
[   14.336774] ... APIC ISR field:
[   14.336774] 000000000000000000000000000000000000000000000000000000000000=
0000
[   14.336774] ... APIC TMR field:
[   14.336774] 000000000200000000000000000000000000000000000000000000000000=
0000
[   14.336774] ... APIC IRR field:
[   14.336774] 000000000000000000000000000000000000000000000000000000000000=
8000
[   14.336774] ... APIC ESR: 00000000
[   14.336774] ... APIC ICR: 00000831
[   14.336774] ... APIC ICR2: 01000000
[   14.336774] ... APIC LVTT: 000200ef
[   14.336774] ... APIC LVTPC: 00010000
[   14.336774] ... APIC LVT0: 00010700
[   14.336774] ... APIC LVT1: 00000400
[   14.336774] ... APIC LVTERR: 000000fe
[   14.336774] ... APIC TMICT: 0003d089
[   14.336774] ... APIC TMCCT: 00015371
[   14.336774] ... APIC TDCR: 00000003
[   14.336774]=20
[   14.356079] number of MP IRQ sources: 15.
[   14.356887] number of IO-APIC #0 registers: 24.
[   14.357790] testing the IO APIC.......................
[   14.358812] IO APIC #0......
[   14.359379] .... register #00: 00000000
[   14.360172] .......    : physical APIC id: 00
[   14.361009] .......    : Delivery Type: 0
[   14.361813] .......    : LTS          : 0
[   14.362602] .... register #01: 00170011
[   14.363363] .......     : max redirection entries: 17
[   14.364584] .......     : PRQ implemented: 0
[   14.365447] .......     : IO APIC version: 11
[   14.366281] .... register #02: 00000000
[   14.367050] .......     : arbitration: 00
[   14.367838] .... IRQ redirection table:
[   14.368626] 1    0    0   0   0    0    0    00
[   14.369547] 0    0    0   0   0    1    1    31
[   14.370461] 0    0    0   0   0    1    1    30
[   14.371367] 0    0    0   0   0    1    1    33
[   14.372294] 1    0    0   0   0    1    1    34
[   14.373217] 1    1    0   0   0    1    1    35
[   14.374330] 0    0    0   0   0    1    1    36
[   14.375306] 0    0    0   0   0    1    1    37
[   14.376224] 0    0    0   0   0    1    1    38
[   14.377127] 0    1    0   0   0    1    1    39
[   14.378015] 1    1    0   0   0    1    1    3A
[   14.378916] 1    1    0   0   0    1    1    3B
[   14.379996] 0    0    0   0   0    1    1    3C
[   14.380859] 0    0    0   0   0    1    1    3D
[   14.381616] 0    0    0   0   0    1    1    3E
[   14.382358] 0    0    0   0   0    1    1    3F
[   14.383113] 1    0    0   0   0    0    0    00
[   14.384055] 1    0    0   0   0    0    0    00
[   14.384890] 1    0    0   0   0    0    0    00
[   14.385828] 1    0    0   0   0    0    0    00
[   14.386779] 1    0    0   0   0    0    0    00
[   14.387708] 1    0    0   0   0    0    0    00
[   14.388631] 1    0    0   0   0    0    0    00
[   14.389577] 1    0    0   0   0    0    0    00
[   14.390459] IRQ to pin mappings:
[   14.391184] IRQ0 -> 0:2
[   14.391713] IRQ1 -> 0:1
[   14.392299] IRQ3 -> 0:3
[   14.392870] IRQ4 -> 0:4
[   14.393406] IRQ5 -> 0:5
[   14.394025] IRQ6 -> 0:6
[   14.394594] IRQ7 -> 0:7
[   14.395185] IRQ8 -> 0:8
[   14.395742] IRQ9 -> 0:9
[   14.396298] IRQ10 -> 0:10
[   14.396886] IRQ11 -> 0:11
[   14.397483] IRQ12 -> 0:12
[   14.398028] IRQ13 -> 0:13
[   14.398608] IRQ14 -> 0:14
[   14.399221] IRQ15 -> 0:15
[   14.399836] .................................... done.
[   14.400842] Using IPI Shortcut mode
[   14.403667] Loading compiled-in X.509 certificates
[   14.404975] registered taskstats version 1
[   14.409608] Btrfs loaded, debug=3Don, assert=3Don
[   14.410662] ima: No TPM chip found, activating TPM-bypass!
[   14.415079] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[   14.418224] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   14.419410] EDD information not available.
[   14.420254] ### dt-test ### No testcase data in device tree; not running=
 tests
[   14.422837] debug: unmapping init [mem 0xc333d000-0xc3444fff]
[   14.448892] random: init urandom read with 1 bits of entropy available
[   14.512035] sh (123) used greatest stack depth: 6748 bytes left
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
[   24.732724] ------------[ cut here ]------------
[   24.733644] WARNING: CPU: 0 PID: 142 at mm/page_alloc.c:2497 __alloc_pag=
es_slowpath+0x100/0xc95()
[   24.735364] CPU: 0 PID: 142 Comm: trinity-main Not tainted 3.15.0-rc5-00=
086-g071f9c5 #1
[   24.736721]  c2d70c3e cbbdfc20 c25e26e5 cbbdfc50 c106dfa6 c2d62bef 00000=
000 0000008e
[   24.738198]  c2d70c3e 000009c1 c11818ea c11818ea 00000001 00000001 00000=
001 cbbdfc60
[   24.745545]  c106e124 00000009 00000000 cbbdfcc8 c11818ea 00000001 00000=
001 ffff8f8c
[   24.747185] Call Trace:
[   24.747623]  [<c25e26e5>] dump_stack+0x40/0x5e
[   24.748353]  [<c106dfa6>] warn_slowpath_common+0xc4/0x105
[   24.759590]  [<c11818ea>] ? __alloc_pages_slowpath+0x100/0xc95
[   24.760637]  [<c11818ea>] ? __alloc_pages_slowpath+0x100/0xc95
[   24.769931]  [<c106e124>] warn_slowpath_null+0x39/0x49
[   24.770705]  [<c11818ea>] __alloc_pages_slowpath+0x100/0xc95
[   24.771706]  [<c119f9f7>] ? next_zones_zonelist+0x2f/0x9d
[   24.772633]  [<c11808eb>] ? get_page_from_freelist+0x262/0x2a7
[   24.773571]  [<c1182965>] __alloc_pages_nodemask+0x4e6/0x6c8
[   24.774579]  [<c11d51aa>] slob_new_pages.isra.7+0x3f/0x94
[   24.775481]  [<c11d5c71>] __kmalloc+0x150/0x198
[   24.776283]  [<c10c6f12>] ? __lock_acquire.isra.17+0x328/0xade
[   24.777219]  [<c2420054>] ? packet_set_ring+0x40c/0xcf4
[   24.778104]  [<c2420054>] packet_set_ring+0x40c/0xcf4
[   24.778959]  [<c185556c>] ? _copy_from_user+0x86/0xc5
[   24.790225]  [<c241e94e>] ? copy_from_user+0x3e/0x4e
[   24.791038]  [<c2420e43>] packet_setsockopt+0x507/0xf1a
[   24.792034]  [<c22aae6a>] ? sockfd_lookup_light+0xb4/0x130
[   24.793050]  [<c22ab4d0>] SYSC_setsockopt+0xf0/0x12c
[   24.793872]  [<c22afd83>] SYSC_socketcall+0x58c/0x780
[   24.794714]  [<c10c6f12>] ? __lock_acquire.isra.17+0x328/0xade
[   24.795759]  [<c10c411d>] ? debug_mutex_unlock+0x31a/0x3ca
[   24.796682]  [<c10c7fed>] ? lock_release+0x3ca/0x48a
[   24.797539]  [<c124fc08>] ? fsnotify+0xd7/0x454
[   24.798298]  [<c124ff41>] ? fsnotify+0x410/0x454
[   24.798965]  [<c124fc08>] ? fsnotify+0xd7/0x454
[   24.810100]  [<c10c411d>] ? debug_mutex_unlock+0x31a/0x3ca
[   24.811010]  [<c25fe69c>] ? __mutex_unlock_slowpath+0x2eb/0x30f
[   24.812087]  [<c11f065c>] ? __sb_end_write+0xcd/0xe0
[   24.812976]  [<c11eb028>] ? vfs_read+0x1e8/0x1e8
[   24.813702]  [<c260038f>] ? mutex_unlock+0x16/0x26
[   24.814531]  [<c11e9c86>] ? fdput_pos+0x4b/0x5d
[   24.815335]  [<c113e8cd>] ? trace_hardirqs_on_caller+0x19/0x62
[   24.816306]  [<c22affe0>] SyS_socketcall+0x1c/0x3a
[   24.817057]  [<c2604317>] sysenter_do_call+0x12/0x38
[   24.817896] ---[ end trace 1f05c7c121b234b4 ]---
[   25.033086] sock: process `trinity-main' is using obsolete setsockopt SO=
_BSDCOMPAT
[   27.318444] VFS: Warning: trinity-c0 using old stat() call. Recompile yo=
ur binary.
[   27.334549] trinity-main (142) used greatest stack depth: 6160 bytes left
[   69.309476] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
[   74.617419] random: nonblocking pool is initialized
mount: proc has wrong device number or fs type proc not supported
/etc/rc6.d/S40umountfs: line 20: /proc/mounts: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
umount: /var/run: not mounted
umount: /var/lock: not mounted
umount: /dev/shm: not mounted
 * Will now restart
[   80.365768] Unregister pv shared memory for cpu 0
[   80.366617] spin_lock-torture: Unscheduled system shutdown detected
[   80.368817] reboot: Restarting system
[   80.369400] reboot: machine restart
Elapsed time: 95
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-c=
1-06021140/071f9c57eea4876288ba1254c9ac3b0f077c2dd6/vmlinuz-3.15.0-rc5-0008=
6-g071f9c5 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug ap=
ic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=
=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kb=
uild-tests/run-queue/kvm/i386-randconfig-c1-06021140/linux-devel:devel-hour=
ly-2014060210:071f9c57eea4876288ba1254c9ac3b0f077c2dd6:bisect-linux4/.vmlin=
uz-071f9c57eea4876288ba1254c9ac3b0f077c2dd6-20140602135444-14-ivb42 branch=
=3Dlinux-devel/devel-hourly-2014060210 BOOT_IMAGE=3D/kernel/i386-randconfig=
-c1-06021140/071f9c57eea4876288ba1254c9ac3b0f077c2dd6/vmlinuz-3.15.0-rc5-00=
086-g071f9c5 drbd.minor_count=3D8'  -initrd /kernel-tests/initrd/quantal-co=
re-i386.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D=
1 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -pid=
file /dev/shm/kboot/pid-quantal-ivb42-28 -serial file:/dev/shm/kboot/serial=
-quantal-ivb42-28 -daemonize -display none -monitor null=20

--3MwIy2ne0vdjdPXF
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-c1-06021140-5dba024fe84a491ec3ca15193923fcbb938e68f7-blocked-for-more-than-----seconds-128869.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgNWRiYTAyNC4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1o
b3VybHktMjAxNDA2MDIxMCcKZ2l0IGNoZWNrb3V0IGZhZDAxZTg2NmFmZGJlMDFhMWYzZWMw
NmEzOWMzYThiOWUxOTcwMTQKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kz
ODYtcmFuZGNvbmZpZy1jMS0wNjAyMTE0MC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAx
NDA2MDIxMDpmYWQwMWU4NjZhZmRiZTAxYTFmM2VjMDZhMzljM2E4YjllMTk3MDE0OmJpc2Vj
dC1saW51eDQKCjIwMTQtMDYtMDItMTI6MDc6MTAgZmFkMDFlODY2YWZkYmUwMWExZjNlYzA2
YTM5YzNhOGI5ZTE5NzAxNCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDAtZmFkMDFl
ODY2YWZkYmUwMWExZjNlYzA2YTM5YzNhOGI5ZTE5NzAxNApDaGVjayBmb3Iga2VybmVsIGlu
IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA2MDIxMTQwL2ZhZDAxZTg2NmFmZGJlMDFh
MWYzZWMwNmEzOWMzYThiOWUxOTcwMTQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1jMS0wNjAyMTE0MC1mYWQw
MWU4NjZhZmRiZTAxYTFmM2VjMDZhMzljM2E4YjllMTk3MDE0CndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWMx
LTA2MDIxMTQwLWZhZDAxZTg2NmFmZGJlMDFhMWYzZWMwNmEzOWMzYThiOWUxOTcwMTQKa2Vy
bmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNjAyMTE0MC9mYWQwMWU4NjZhZmRi
ZTAxYTFmM2VjMDZhMzljM2E4YjllMTk3MDE0L3ZtbGludXotMy4xNS4wLXJjOAoKMjAxNC0w
Ni0wMi0xMjoxMzoxMCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLi4uLi4uLi4uLgk0CTcJ
MTEJMTMJMTgJMjAgU1VDQ0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCBmYWQwMWU4NjZhZmRi
ZTAxYTFmM2VjMDZhMzljM2E4YjllMTk3MDE0CmdpdCBiaXNlY3Qgc3RhcnQgNWRiYTAyNGZl
ODRhNDkxZWMzY2ExNTE5MzkyM2ZjYmI5MzhlNjhmNyBmYWQwMWU4NjZhZmRiZTAxYTFmM2Vj
MDZhMzljM2E4YjllMTk3MDE0IC0tCi9jL2tlcm5lbC10ZXN0cy9saW5lYXItYmlzZWN0OiBb
Ii1iIiwgIjVkYmEwMjRmZTg0YTQ5MWVjM2NhMTUxOTM5MjNmY2JiOTM4ZTY4ZjciLCAiLWci
LCAiZmFkMDFlODY2YWZkYmUwMWExZjNlYzA2YTM5YzNhOGI5ZTE5NzAxNCIsICIvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIiwgIi9jL2Jvb3QtYmlzZWN0
L2xpbnV4NC9vYmotYmlzZWN0Il0KQmlzZWN0aW5nOiAyMTQ5IHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMiBzdGVwcykKWzEyMDcyY2RkNWM5YjU2YmI2
ZDQxNjljNWE1MmM5ZDBiZjY0YjdmODRdIE1lcmdlICdneHQvdW5pY29yZTMyJyBpbnRvIGRl
dmVsLWhvdXJseS0yMDE0MDYwMjEwCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDQvb2JqLWJpc2VjdAps
cyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWMxLTA2
MDIxMTQwL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDYwMjEwOjEyMDcyY2RkNWM5
YjU2YmI2ZDQxNjljNWE1MmM5ZDBiZjY0YjdmODQ6YmlzZWN0LWxpbnV4NAoKMjAxNC0wNi0w
Mi0xMjoyMzoxMiAxMjA3MmNkZDVjOWI1NmJiNmQ0MTY5YzVhNTJjOWQwYmY2NGI3Zjg0IGNv
bXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
L2kzODYtcmFuZGNvbmZpZy1jMS0wNjAyMTE0MC0xMjA3MmNkZDVjOWI1NmJiNmQ0MTY5YzVh
NTJjOWQwYmY2NGI3Zjg0CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYzEtMDYwMjExNDAvMTIwNzJjZGQ1YzliNTZiYjZkNDE2OWM1YTUyYzlkMGJmNjRi
N2Y4NAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUvaTM4Ni1yYW5kY29uZmlnLWMxLTA2MDIxMTQwLTEyMDcyY2RkNWM5YjU2YmI2ZDQxNjlj
NWE1MmM5ZDBiZjY0YjdmODQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRl
c3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDAtMTIwNzJjZGQ1
YzliNTZiYjZkNDE2OWM1YTUyYzlkMGJmNjRiN2Y4NAprZXJuZWw6IC9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWMxLTA2MDIxMTQwLzEyMDcyY2RkNWM5YjU2YmI2ZDQxNjljNWE1MmM5ZDBi
ZjY0YjdmODQvdm1saW51ei0zLjE1LjAtcmM4LTAxNTIyLWcxMjA3MmNkCgoyMDE0LTA2LTAy
LTEyOjMwOjEyIGRldGVjdGluZyBib290IHN0YXRlIC4uCTgJMjAgU1VDQ0VTUwoKQmlzZWN0
aW5nOiA2MjcgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEw
IHN0ZXBzKQpbZWIxYTEyYWQxZDVhNzMxMmE2ZjNkYzZhOGI3N2M1MWNiZTU4NjQxZV0gTWVy
Z2UgJ2x1dG8vYXVkaXRzYy1saXRlJyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDYwMjEwCnJ1
bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9i
b290LWJpc2VjdC9saW51eDQvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1x
dWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWMxLTA2MDIxMTQwL2xpbnV4LWRldmVsOmRldmVs
LWhvdXJseS0yMDE0MDYwMjEwOmViMWExMmFkMWQ1YTczMTJhNmYzZGM2YThiNzdjNTFjYmU1
ODY0MWU6YmlzZWN0LWxpbnV4NAoKMjAxNC0wNi0wMi0xMjozMjoxMyBlYjFhMTJhZDFkNWE3
MzEyYTZmM2RjNmE4Yjc3YzUxY2JlNTg2NDFlIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFz
ayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1jMS0wNjAy
MTE0MC1lYjFhMTJhZDFkNWE3MzEyYTZmM2RjNmE4Yjc3YzUxY2JlNTg2NDFlCkNoZWNrIGZv
ciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDAvZWIxYTEy
YWQxZDVhNzMxMmE2ZjNkYzZhOGI3N2M1MWNiZTU4NjQxZQp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWMxLTA2
MDIxMTQwLWViMWExMmFkMWQ1YTczMTJhNmYzZGM2YThiNzdjNTFjYmU1ODY0MWUKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJh
bmRjb25maWctYzEtMDYwMjExNDAtZWIxYTEyYWQxZDVhNzMxMmE2ZjNkYzZhOGI3N2M1MWNi
ZTU4NjQxZQprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA2MDIxMTQwL2Vi
MWExMmFkMWQ1YTczMTJhNmYzZGM2YThiNzdjNTFjYmU1ODY0MWUvdm1saW51ei0zLjE1LjAt
cmM4LTAxOTMxLWdlYjFhMTJhZAoKMjAxNC0wNi0wMi0xMjozOToxMyBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAuLi4uCTExCTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMjE4IHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpbZDY0MTE1NTI3MGFm
ZjIxZWFjZDI2MjJlMzAxMjljZDkxZmU4ZDJkMl0gTWVyZ2UgJ3dzYS9pMmMvZm9yLW5leHQn
IGludG8gZGV2ZWwtaG91cmx5LTIwMTQwNjAyMTAKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4NC9vYmot
YmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctYzEtMDYwMjExNDAvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNjAyMTA6ZDY0
MTE1NTI3MGFmZjIxZWFjZDI2MjJlMzAxMjljZDkxZmU4ZDJkMjpiaXNlY3QtbGludXg0Cgoy
MDE0LTA2LTAyLTEyOjQyOjE0IGQ2NDExNTUyNzBhZmYyMWVhY2QyNjIyZTMwMTI5Y2Q5MWZl
OGQyZDIgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVp
bGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWMxLTA2MDIxMTQwLWQ2NDExNTUyNzBhZmYyMWVh
Y2QyNjIyZTMwMTI5Y2Q5MWZlOGQyZDIKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1jMS0wNjAyMTE0MC9kNjQxMTU1MjcwYWZmMjFlYWNkMjYyMmUzMDEy
OWNkOTFmZThkMmQyCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDAtZDY0MTE1NTI3MGFmZjIx
ZWFjZDI2MjJlMzAxMjljZDkxZmU4ZDJkMgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1jMS0wNjAyMTE0MC1k
NjQxMTU1MjcwYWZmMjFlYWNkMjYyMmUzMDEyOWNkOTFmZThkMmQyCmtlcm5lbDogL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDAvZDY0MTE1NTI3MGFmZjIxZWFjZDI2MjJl
MzAxMjljZDkxZmU4ZDJkMi92bWxpbnV6LTMuMTUuMC1yYzgtMDIwOTQtZ2Q2NDExNTUKCjIw
MTQtMDYtMDItMTI6NDU6MTQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4uCTMJMTIJ
MTUJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA1NSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgNiBzdGVwcykKWzAwMmZhODJkYWM2ZjBiZTQ4NjMzM2U2NDI0
OTY4YzBjNDJjMGU3OTldIE1lcmdlICdqYmFybmVzL2FzeW5jJyBpbnRvIGRldmVsLWhvdXJs
eS0yMDE0MDYwMjEwCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDQvb2JqLWJpc2VjdApscyAtYSAva2J1
aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWMxLTA2MDIxMTQwL2xp
bnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDYwMjEwOjAwMmZhODJkYWM2ZjBiZTQ4NjMz
M2U2NDI0OTY4YzBjNDJjMGU3OTk6YmlzZWN0LWxpbnV4NAoKMjAxNC0wNi0wMi0xMjo1MTo0
NSAwMDJmYTgyZGFjNmYwYmU0ODYzMzNlNjQyNDk2OGMwYzQyYzBlNzk5IGNvbXBpbGluZwpR
dWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFu
ZGNvbmZpZy1jMS0wNjAyMTE0MC0wMDJmYTgyZGFjNmYwYmU0ODYzMzNlNjQyNDk2OGMwYzQy
YzBlNzk5CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEt
MDYwMjExNDAvMDAyZmE4MmRhYzZmMGJlNDg2MzMzZTY0MjQ5NjhjMGM0MmMwZTc5OQp3YWl0
aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1y
YW5kY29uZmlnLWMxLTA2MDIxMTQwLTAwMmZhODJkYWM2ZjBiZTQ4NjMzM2U2NDI0OTY4YzBj
NDJjMGU3OTkKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlLy5pMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDAtMDAyZmE4MmRhYzZmMGJlNDg2
MzMzZTY0MjQ5NjhjMGM0MmMwZTc5OQprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWMxLTA2MDIxMTQwLzAwMmZhODJkYWM2ZjBiZTQ4NjMzM2U2NDI0OTY4YzBjNDJjMGU3OTkv
dm1saW51ei0zLjE1LjAtcmM4LTAyMDk5LWcwMDJmYTgyCgoyMDE0LTA2LTAyLTEyOjU2OjQ1
IGRldGVjdGluZyBib290IHN0YXRlIC4uLi4uLi4JOAkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6
IDUwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA2IHN0ZXBz
KQpbMWVhNTJhOTYwNWJlMTIzNGI3ZGEzZTRkMTM0OTE3YzdiYTNiZTkzZF0gTWVyZ2UgJ2pi
YXJuZXMvYXN5bmMtZmItcHJvYmUnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwNjAyMTAKcnVu
bmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jv
b3QtYmlzZWN0L2xpbnV4NC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDAvbGludXgtZGV2ZWw6ZGV2ZWwt
aG91cmx5LTIwMTQwNjAyMTA6MWVhNTJhOTYwNWJlMTIzNGI3ZGEzZTRkMTM0OTE3YzdiYTNi
ZTkzZDpiaXNlY3QtbGludXg0CgoyMDE0LTA2LTAyLTEzOjAxOjE1IDFlYTUyYTk2MDViZTEy
MzRiN2RhM2U0ZDEzNDkxN2M3YmEzYmU5M2QgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNr
IHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWMxLTA2MDIx
MTQwLTFlYTUyYTk2MDViZTEyMzRiN2RhM2U0ZDEzNDkxN2M3YmEzYmU5M2QKQ2hlY2sgZm9y
IGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNjAyMTE0MC8xZWE1MmE5
NjA1YmUxMjM0YjdkYTNlNGQxMzQ5MTdjN2JhM2JlOTNkCndhaXRpbmcgZm9yIGNvbXBsZXRp
b24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzEtMDYw
MjExNDAtMWVhNTJhOTYwNWJlMTIzNGI3ZGEzZTRkMTM0OTE3YzdiYTNiZTkzZAp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFu
ZGNvbmZpZy1jMS0wNjAyMTE0MC0xZWE1MmE5NjA1YmUxMjM0YjdkYTNlNGQxMzQ5MTdjN2Jh
M2JlOTNkCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDAvMWVh
NTJhOTYwNWJlMTIzNGI3ZGEzZTRkMTM0OTE3YzdiYTNiZTkzZC92bWxpbnV6LTMuMTUuMC1y
YzgtMDIxMDItZzFlYTUyYTkKCjIwMTQtMDYtMDItMTM6MTI6MTUgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgLi4uLi4uLiBURVNUIEZBSUxVUkUKWyAgIDYyLjE3MjgzMV0gc3Bpbl9sb2NrLXRv
cnR1cmU6IFdyaXRlczogIFRvdGFsOiAyICBNYXgvTWluOiAwLzAgICBGYWlsOiAwIApbICAx
MjIuMTY2NzU2XSBzcGluX2xvY2stdG9ydHVyZTogV3JpdGVzOiAgVG90YWw6IDIgIE1heC9N
aW46IDAvMCAgIEZhaWw6IDAgClsgIDE4Mi4xNTYwMzhdIHNwaW5fbG9jay10b3J0dXJlOiBX
cml0ZXM6ICBUb3RhbDogMiAgTWF4L01pbjogMC8wICAgRmFpbDogMCAKWyAgMjQwLjE1MTc3
MF0gSU5GTzogdGFzayBzd2FwcGVyOjEgYmxvY2tlZCBmb3IgbW9yZSB0aGFuIDEyMCBzZWNv
bmRzLgpbICAyNDAuMTUyNTAxXSAgICAgICBOb3QgdGFpbnRlZCAzLjE1LjAtcmM4LTAyMTAy
LWcxZWE1MmE5ICMxClsgIDI0MC4xNTMwNzNdICJlY2hvIDAgPiAvcHJvYy9zeXMva2VybmVs
L2h1bmdfdGFza190aW1lb3V0X3NlY3MiIGRpc2FibGVzIHRoaXMgbWVzc2FnZS4KWyAgMjQw
LjE1Mzc5NV0gc3dhcHBlciAgICAgICAgIEQgZDFjMjljMjQgIDU5NDQgICAgIDEgICAgICAw
IDB4MDAwMDAwMDAKWyAgMjQwLjE1NDQ2Nl0gIGQxYzI5YzQ4IDAwMDAwMDQ2IDAwMDAwMDAw
IGQxYzI5YzI0IGMxODNmYTZjIGMyZjI1MDY4IGQxYzIyMDAwIGQxYmMzMDM0ClsgIDI0MC4x
NTUzNTVdICBjMmYyNTA2OCBkMWJjMzAzNCBjMmYyNTA0MCBjMmYyNTA0MCBkMWMyOWMxYyBj
MTBiYzI5ZiBkMWJjMzAyYyBjMmYyNTA0MApbICAyNDAuMTU2Mjk3XSAgZDFjMjljMmMgYzEw
YmMyZTEgZDFiYzMwMmMgMDAwMDAwMDEgMDAwMDAwMDEgYzEwYmNhZjggMDAwMDAwMDIgYzJm
MjUwNDAKWyAgMjQwLjE1NzEyMV0gQ2FsbCBUcmFjZToKWyAgMjQwLjE1NzQ0NV0gIFs8YzE4
M2ZhNmM+XSA/IHJiX2VyYXNlKzB4M2QvMHg1NzYKWyAgMjQwLjE1Nzk0Nl0gIFs8YzEwYmMy
OWY+XSA/IF9fZGVxdWV1ZV9lbnRpdHkrMHg0ZC8weDVmClsgIDI0MC4xNTg0MjFdICBbPGMx
MGJjMmUxPl0gPyBzZXRfbmV4dF9lbnRpdHkrMHgzMC8weDYzClsgIDI0MC4xNTg4NTZdICBb
PGMxMGJjYWY4Pl0gPyBwaWNrX25leHRfdGFza19mYWlyKzB4MjY3LzB4MjlhClsgIDI0MC4x
NTk0MDVdICBbPGMyNWYwY2Y2Pl0gX19zY2hlZHVsZSsweDhmYS8weGE4MgpbICAyNDAuMTU5
ODY2XSAgWzxjMjVmMGZjMz5dIHNjaGVkdWxlKzB4MTQ1LzB4MTU1ClsgIDI0MC4xNjAzMjNd
ICBbPGMyNWYwZmZkPl0gc2NoZWR1bGVfcHJlZW1wdF9kaXNhYmxlZCsweDJhLzB4NGUKWyAg
MjQwLjE2MDg5MF0gIFs8YzI1ZjI2YWE+XSBtdXRleF9sb2NrX25lc3RlZCsweDQ3MC8weDhj
ZApbICAyNDAuMTYxNDc0XSAgWzxjMWE0N2Y2OD5dID8gZHJtX21vZGVzZXRfbG9ja19hbGwr
MHgyMy8weDgwClsgIDI0MC4xNjIwMDJdICBbPGMxYTQ3ZjY4Pl0gPyBkcm1fbW9kZXNldF9s
b2NrX2FsbCsweDIzLzB4ODAKWyAgMjQwLjE2MjUzMF0gIFs8YzFhNDdmNjg+XSBkcm1fbW9k
ZXNldF9sb2NrX2FsbCsweDIzLzB4ODAKWyAgMjQwLjE2MzAyNV0gIFs8YzFhMzE3YjQ+XSBk
cm1fZmJfaGVscGVyX2luaXRpYWxfY29uZmlnKzB4MmQwLzB4NzhlClsgIDI0MC4xNjM1ODJd
ICBbPGMxMGM0M2UzPl0gPyBkZWJ1Z19tdXRleF91bmxvY2srMHgzMWEvMHgzY2EKWyAgMjQw
LjE2NDE3NF0gIFs8YzI1ZjMyOWU+XSA/IF9tdXRleF9sb2NrX25lc3RfbG9jaysweDc5Ny8w
eDhjOQpbICAyNDAuMTY0NzI3XSAgWzxjMjVmNDg2Mz5dID8gX19tdXRleF91bmxvY2tfc2xv
d3BhdGgrMHgyZWIvMHgzMGYKWyAgMjQwLjE2NTMyOF0gIFs8YzFhNDgwMjg+XSA/IGRybV9t
b2Rlc2V0X3VubG9ja19hbGwrMHg2My8weDc2ClsgIDI0MC4xNjU5NTRdICBbPGMxY2IzOWE2
Pl0gY2lycnVzX2ZiZGV2X2luaXQrMHhmOC8weDExNQpbICAyNDAuMTY2NDQ4XSAgWzxjMWNi
Mjg2ND5dIGNpcnJ1c19tb2Rlc2V0X2luaXQrMHgyZWUvMHgzYTkKWyAgMjQwLjE2Njk2OF0g
IFs8YzFjYjBiNDE+XSA/IGNpcnJ1c19kZXZpY2VfaW5pdCsweDE1My8weDFlOQpbICAyNDAu
MTY3NDg2XSAgWzxjMWNiMGUzND5dIGNpcnJ1c19kcml2ZXJfbG9hZCsweDEzNC8weDFjMwpb
ICAyNDAuMTY4MDU3XSAgWzxjMWE0MTMyYz5dIGRybV9kZXZfcmVnaXN0ZXIrMHhmMC8weDFm
NApbICAyNDAuMTY4NTk3XSAgWzxjMWE0M2JmZj5dIGRybV9nZXRfcGNpX2RldisweDIwNy8w
eDMzNgpbICAyNDAuMTY5MDQ3XSAgWzxjMWNiMmMzMj5dID8gY2lycnVzX2tpY2tfb3V0X2Zp
cm13YXJlX2ZiKzB4MTFjLzB4MTM3ClsgIDI0MC4xNjk3MDVdICBbPGMxMWNiN2Y3Pl0gPyBr
ZnJlZSsweDE0ZS8weDFkNApbICAyNDAuMTcwMDk1XSAgWzxjMWNiMmM5OT5dIGNpcnJ1c19w
Y2lfcHJvYmUrMHg0Yy8weDVlClsgIDI0MC4xNzA1NjNdICBbPGMxODk5MWFjPl0gcGNpX2Rl
dmljZV9wcm9iZSsweGQwLzB4MWE1ClsgIDI0MC4xNzEwNzZdICBbPGMxMjcxZGUzPl0gPyBz
eXNmc19jcmVhdGVfbGluaysweDIwLzB4MzAKWyAgMjQwLjE3MTYwNV0gIFs8YzFlMTc1M2U+
XSBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4MTM3LzB4M2ZlClsgIDI0MC4xNzIxMzRdICBbPGMx
ZTE3OGE1Pl0gX19kcml2ZXJfYXR0YWNoKzB4YTAvMHhmNApbICAyNDAuMTcyNjQzXSAgWzxj
MWUxNDczND5dIGJ1c19mb3JfZWFjaF9kZXYrMHg5Ni8weGYzClsgIDI0MC4xNzMxMTBdICBb
PGMxZTE3MDNjPl0gZHJpdmVyX2F0dGFjaCsweDI1LzB4MzUKWyAgMjQwLjE3MzU0NV0gIFs8
YzFlMTc4MDU+XSA/IGRyaXZlcl9wcm9iZV9kZXZpY2UrMHgzZmUvMHgzZmUKWyAgMjQwLjE3
NDEwOF0gIFs8YzFlMTU2NTA+XSBidXNfYWRkX2RyaXZlcisweDE2MS8weDM4OQpbICAyNDAu
MTc0NTk5XSAgWzxjMWUxODgzMT5dIGRyaXZlcl9yZWdpc3RlcisweDE2ZS8weDFmNgpbICAy
NDAuMTc1MDM4XSAgWzxjMTBjYzAwMT5dID8gX19yYXdfc3Bpbl9sb2NrX2luaXQrMHg0OS8w
eDc4ClsgIDI0MC4xNzU1ODJdICBbPGMxODk4ZTI2Pl0gX19wY2lfcmVnaXN0ZXJfZHJpdmVy
KzB4NjEvMHg3MgpbICAyNDAuMTc2MTUyXSAgWzxjMWE0M2RjYj5dIGRybV9wY2lfaW5pdCsw
eDlkLzB4MThjClsgIDI0MC4xNzY2NDJdICBbPGMzM2FlNGE2Pl0gPyBmdHJhY2VfZGVmaW5l
X2ZpZWxkc19pOTE1X2dlbV9vYmplY3RfY3JlYXRlKzB4YTkvMHhhOQpbICAyNDAuMTc3MzUz
XSAgWzxjMzNhZTRkZD5dIGNpcnJ1c19pbml0KzB4MzcvMHg0ZgpbICAyNDAuMTc3ODM5XSAg
WzxjMzMzMTVmYj5dIGRvX29uZV9pbml0Y2FsbCsweGY0LzB4MjZjClsgIDI0MC4xNzgzMDVd
ICBbPGMxMGMwMDAwPl0gPyBlbnF1ZXVlX3Rhc2tfZGwrMHgzNTgvMHg3MDUKWyAgMjQwLjE3
ODgxMV0gIFs8YzE4NDk5ZDk+XSA/IHN0cmxlbisweDFiLzB4MzMKWyAgMjQwLjE3OTI1NV0g
IFs8YzMzMzA2ODQ+XSA/IHJlcGFpcl9lbnZfc3RyaW5nKzB4MzIvMHhkMwpbICAyNDAuMTc5
Nzk5XSAgWzxjMTA5Zjk5Mj5dID8gcGFyc2VfYXJncysweDMyOC8weDRjZApbICAyNDAuMTgw
MzAxXSAgWzxjMzMzMWMwND5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4NDkxLzB4NjJhClsg
IDI0MC4xODA4MzVdICBbPGMzMzMwNjUyPl0gPyBkb19lYXJseV9wYXJhbSsweDEyYi8weDEy
YgpbICAyNDAuMTgxNDEyXSAgWzxjMjU5NWYwZT5dIGtlcm5lbF9pbml0KzB4MTkvMHgxZjYK
WyAgMjQwLjE4MTg2OV0gIFs8YzEwYjUwNWQ+XSA/IHNjaGVkdWxlX3RhaWwrMHgxYS8weGE5
ClsgIDI0MC4xODIzMzddICBbPGMyNWZhNDQwPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsw
eDIwLzB4MzAKWyAgMjQwLjE4Mjg3NV0gIFs8YzI1OTVlZjU+XSA/IHJlc3RfaW5pdCsweDFk
ZC8weDFkZApbICAyNDAuMTgzMzAxXSA1IGxvY2tzIGhlbGQgYnkgc3dhcHBlci8xOgpbICAy
NDAuMTgzNjY1XSAgIzA6ICAoJmRldi0+bXV0ZXgpey4uLi4uLn0sIGF0OiBbPGMxZTE2Nzk5
Pl0gZGV2aWNlX2xvY2srMHgxYi8weDJiClsgIDI0MC4xODQ1NTldICAjMTogICgmZGV2LT5t
dXRleCl7Li4uLi4ufSwgYXQ6IFs8YzFlMTY3OTk+XSBkZXZpY2VfbG9jaysweDFiLzB4MmIK
WyAgMjQwLjE4NTMxOV0gICMyOiAgKGRybV9nbG9iYWxfbXV0ZXgpey4uLi4uLn0sIGF0OiBb
PGMxYTQxMjYwPl0gZHJtX2Rldl9yZWdpc3RlcisweDI0LzB4MWY0ClsgIDI0MC4xODYxOThd
ICAjMzogICgmZGV2LT5tb2RlX2NvbmZpZy5tdXRleCl7Li4uLi4ufSwgYXQ6IFs8YzFhMzE3
OWY+XSBkcm1fZmJfaGVscGVyX2luaXRpYWxfY29uZmlnKzB4MmJiLzB4NzhlClsgIDI0MC4x
ODcxNzldICAjNDogICgmZGV2LT5tb2RlX2NvbmZpZy5tdXRleCl7Li4uLi4ufSwgYXQ6IFs8
YzFhNDdmNjg+XSBkcm1fbW9kZXNldF9sb2NrX2FsbCsweDIzLzB4ODAKWyAgMjQwLjE4ODIy
MV0gc2VuZGluZyBOTUkgdG8gYWxsIENQVXM6ClsgIDI0MC4xODg1OTRdIE5NSSBiYWNrdHJh
Y2UgZm9yIGNwdSAwClsgIDI0MC4xODg5MDddIENQVTogMCBQSUQ6IDggQ29tbToga2h1bmd0
YXNrZCBOb3QgdGFpbnRlZCAzLjE1LjAtcmM4LTAyMTAyLWcxZWE1MmE5ICMxClsgIDI0MC4x
ODkzMTVdIHRhc2s6IGQxZGQwNDEwIHRpOiBkMWRmODAwMCB0YXNrLnRpOiBkMWRmODAwMApb
ICAyNDAuMTg5MzE1XSBFSVA6IDAwNjA6WzxjMTA0NTdjNj5dIEVGTEFHUzogMDAwMDAwNDYg
Q1BVOiAwClsgIDI0MC4xODkzMTVdIEVJUCBpcyBhdCBuYXRpdmVfYXBpY19tZW1fd3JpdGUr
MHgyMC8weDMwClsgIDI0MC4xODkzMTVdIEVBWDogZmZmZmIzMDAgRUJYOiAwMDAwMDIwMSBF
Q1g6IGZmZmZmMDAwIEVEWDogMDAwMDBjMDAKWyAgMjQwLjE4OTMxNV0gRVNJOiAwMDAwMDAw
MiBFREk6IDAxMDAwMDAwIEVCUDogZDFkZjllOWMgRVNQOiBkMWRmOWU5YwpbICAyNDAuMTg5
MzE1XSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwMDAgR1M6IDAwMDAgU1M6IDAwNjgKWyAg
MjQwLjE4OTMxNV0gQ1IwOiA4MDA1MDAzYiBDUjI6IDAwMDAwMDAwIENSMzogMDM0M2IwMDAg
Q1I0OiAwMDAwMDZkMApbICAyNDAuMTg5MzE1XSBTdGFjazoKWyAgMjQwLjE4OTMxNV0gIGQx
ZGY5ZWI0IGMxMDQ1OTZjIDAwMDAwODAwIDAwMDAwMjQ2IDAwMDAwMDAxIDAwMDAwMDAwIGQx
ZGY5ZWQwIGMxMDQ1ZWEyClsgIDI0MC4xODkzMTVdICAwMDAwMDAwMiAwMDAwMDAwMCAwMDAw
MDAwMiBkMWMyMjAwMCBkMWMyMjAwMCBkMWRmOWVkOCBjMTA0NWVmZSBkMWRmOWVlOApbICAy
NDAuMTg5MzE1XSAgYzEwNDYxZGQgYzJkNTFmOGIgMDAwMDAwMDIgZDFkZjlmMzAgYzExMTU1
YzUgYzJkNWY4ZDcgYzM0NzQwMzQgYzJlZWE0NTYKWyAgMjQwLjE4OTMxNV0gQ2FsbCBUcmFj
ZToKWyAgMjQwLjE4OTMxNV0gIFs8YzEwNDU5NmM+XSBfX2RlZmF1bHRfc2VuZF9JUElfZGVz
dF9maWVsZCsweGVjLzB4MTAwClsgIDI0MC4xODkzMTVdICBbPGMxMDQ1ZWEyPl0gZGVmYXVs
dF9zZW5kX0lQSV9tYXNrX2xvZ2ljYWwrMHgxNmMvMHgxN2QKWyAgMjQwLjE4OTMxNV0gIFs8
YzEwNDVlZmU+XSBkZWZhdWx0X3NlbmRfSVBJX2FsbCsweDM4LzB4OTQKWyAgMjQwLjE4OTMx
NV0gIFs8YzEwNDYxZGQ+XSBhcmNoX3RyaWdnZXJfYWxsX2NwdV9iYWNrdHJhY2UrMHhjNS8w
eDFiOApbICAyNDAuMTg5MzE1XSAgWzxjMTExNTVjNT5dIHdhdGNoZG9nKzB4NTVkLzB4NjFh
ClsgIDI0MC4xODkzMTVdICBbPGMxMTE1MDY4Pl0gPyByY3VfcmVhZF9sb2NrKzB4ODEvMHg4
MQpbICAyNDAuMTg5MzE1XSAgWzxjMTBhMjg0Mj5dIGt0aHJlYWQrMHgxMTUvMHgxMjgKWyAg
MjQwLjE4OTMxNV0gIFs8YzEwYzgyYjM+XSA/IGxvY2tfcmVsZWFzZSsweDNjYS8weDQ4YQpb
ICAyNDAuMTg5MzE1XSAgWzxjMjVmYTQ0MD5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgy
MC8weDMwClsgIDI0MC4xODkzMTVdICBbPGMxMGEyNzJkPl0gPyBfX2t0aHJlYWRfdW5wYXJr
KzB4OWIvMHg5YgpbICAyNDAuMTg5MzE1XSBDb2RlOiA4MyAxNSBiYyAwYiA0NiBjMyAwMCA4
OSBjOCA1ZCBjMyA1NSA4OSBlNSA4MyAwNSBkMCAwYiA0NiBjMyAwMSA4MyAxNSBkNCAwYiA0
NiBjMyAwMCA4YiAwZCBiNCBmZSBmMCBjMiA4ZCA4NCAwOCAwMCBjMCBmZiBmZiA4OSAxMCA8
ODM+IDA1IGQ4IDBiIDQ2IGMzIDAxIDgzIDE1IGRjIDBiIDQ2IGMzIDAwIDVkIGMzIDU1IDg5
IGU1IDA5IGM4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA2MDIxMTQwLzFlYTUyYTk2
MDViZTEyMzRiN2RhM2U0ZDEzNDkxN2M3YmEzYmU5M2QvZG1lc2ctcXVhbnRhbC1pdmI0My0x
Mjc6MjAxNDA2MDIxMzE1Mzc6aTM4Ni1yYW5kY29uZmlnLWMxLTA2MDIxMTQwOjMuMTUuMC1y
YzgtMDIxMDItZzFlYTUyYTk6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNjAyMTE0
MC8xZWE1MmE5NjA1YmUxMjM0YjdkYTNlNGQxMzQ5MTdjN2JhM2JlOTNkL2RtZXNnLXlvY3Rv
LWl2YjQ0LTExMDoyMDE0MDYwMjEzMTUzNzppMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDA6
My4xNS4wLXJjOC0wMjEwMi1nMWVhNTJhOToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMx
LTA2MDIxMTQwLzFlYTUyYTk2MDViZTEyMzRiN2RhM2U0ZDEzNDkxN2M3YmEzYmU5M2QvZG1l
c2cteW9jdG8taXZiNDQtMjI6MjAxNDA2MDIxMzE1Mzc6aTM4Ni1yYW5kY29uZmlnLWMxLTA2
MDIxMTQwOjMuMTUuMC1yYzgtMDIxMDItZzFlYTUyYTk6MQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1jMS0wNjAyMTE0MC8xZWE1MmE5NjA1YmUxMjM0YjdkYTNlNGQxMzQ5MTdjN2JhM2Jl
OTNkL2RtZXNnLXF1YW50YWwtaXZiNDEtMTg6MjAxNDA2MDIxMzE1NDE6aTM4Ni1yYW5kY29u
ZmlnLWMxLTA2MDIxMTQwOjMuMTUuMC1yYzgtMDIxMDItZzFlYTUyYTk6MQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1jMS0wNjAyMTE0MC8xZWE1MmE5NjA1YmUxMjM0YjdkYTNlNGQxMzQ5
MTdjN2JhM2JlOTNkL2RtZXNnLXF1YW50YWwtaXZiNDItMTEzOjIwMTQwNjAyMTMxNTQwOmkz
ODYtcmFuZGNvbmZpZy1jMS0wNjAyMTE0MDozLjE1LjAtcmM4LTAyMTAyLWcxZWE1MmE5OjEK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDAvMWVhNTJhOTYwNWJlMTIzNGI3
ZGEzZTRkMTM0OTE3YzdiYTNiZTkzZC9kbWVzZy1xdWFudGFsLWl2YjQyLTk4OjIwMTQwNjAy
MTMxNTM5OmkzODYtcmFuZGNvbmZpZy1jMS0wNjAyMTE0MDozLjE1LjAtcmM4LTAyMTAyLWcx
ZWE1MmE5OjEKMDo2OjUgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCmxpbmVhci1iaXNl
Y3Q6IGJhZCBicmFuY2ggbWF5IGJlIGpiYXJuZXMvYXN5bmMtZmItcHJvYmUKbGluZWFyLWJp
c2VjdDogaGFuZGxlIG92ZXIgdG8gZ2l0IGJpc2VjdApsaW5lYXItYmlzZWN0OiBnaXQgYmlz
ZWN0IHN0YXJ0IDFlYTUyYTk2MDViZTEyMzRiN2RhM2U0ZDEzNDkxN2M3YmEzYmU5M2QgMDAy
ZmE4MmRhYzZmMGJlNDg2MzMzZTY0MjQ5NjhjMGM0MmMwZTc5OSAtLQpCaXNlY3Rpbmc6IDAg
cmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKW2Y3
MjgwODBkNmJhYzQ3YWFiMmQ1NzA0OTJhY2VmODgzMTdhYzhlMDNdIGRybS9pOTE1OiBtYWtl
IGZiZGV2IGluaXRpYWxpemF0aW9uIGFzeW5jaHJvbm91cyB2MgpsaW5lYXItYmlzZWN0OiBn
aXQgYmlzZWN0IHJ1biAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4NC9vYmotYmlzZWN0CnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51
eDQvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1y
YW5kY29uZmlnLWMxLTA2MDIxMTQwL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDYw
MjEwOmY3MjgwODBkNmJhYzQ3YWFiMmQ1NzA0OTJhY2VmODgzMTdhYzhlMDM6YmlzZWN0LWxp
bnV4NAoKMjAxNC0wNi0wMi0xMzoxNTo0NyBmNzI4MDgwZDZiYWM0N2FhYjJkNTcwNDkyYWNl
Zjg4MzE3YWM4ZTAzIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRl
c3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1jMS0wNjAyMTE0MC1mNzI4MDgwZDZi
YWM0N2FhYjJkNTcwNDkyYWNlZjg4MzE3YWM4ZTAzCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDAvZjcyODA4MGQ2YmFjNDdhYWIyZDU3
MDQ5MmFjZWY4ODMxN2FjOGUwMwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWMxLTA2MDIxMTQwLWY3MjgwODBk
NmJhYzQ3YWFiMmQ1NzA0OTJhY2VmODgzMTdhYzhlMDMKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWctYzEtMDYw
MjExNDAtZjcyODA4MGQ2YmFjNDdhYWIyZDU3MDQ5MmFjZWY4ODMxN2FjOGUwMwprZXJuZWw6
IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA2MDIxMTQwL2Y3MjgwODBkNmJhYzQ3YWFi
MmQ1NzA0OTJhY2VmODgzMTdhYzhlMDMvdm1saW51ei0zLjE1LjAtcmM1LTAwMDg4LWdmNzI4
MDgwCgoyMDE0LTA2LTAyLTEzOjM0OjQ4IGRldGVjdGluZyBib290IHN0YXRlIC4uLi4uLi4u
Li4uLi4gVEVTVCBGQUlMVVJFClsgICA2Ny4yNzQxNTVdIHNwaW5fbG9jay10b3J0dXJlOiBX
cml0ZXM6ICBUb3RhbDogMiAgTWF4L01pbjogMC8wICAgRmFpbDogMCAKWyAgMTI3LjM4NDYw
NV0gc3Bpbl9sb2NrLXRvcnR1cmU6IFdyaXRlczogIFRvdGFsOiAyICBNYXgvTWluOiAwLzAg
ICBGYWlsOiAwIApbICAxODcuMzk5NjAyXSBzcGluX2xvY2stdG9ydHVyZTogV3JpdGVzOiAg
VG90YWw6IDIgIE1heC9NaW46IDAvMCAgIEZhaWw6IDAgClsgIDI0My42Nzc1OTldIElORk86
IHRhc2sgc3dhcHBlcjoxIGJsb2NrZWQgZm9yIG1vcmUgdGhhbiAxMjAgc2Vjb25kcy4KWyAg
MjQzLjY3ODM5OV0gICAgICAgTm90IHRhaW50ZWQgMy4xNS4wLXJjNS0wMDA4OC1nZjcyODA4
MCAjMQpbICAyNDMuNjc5MDQ0XSAiZWNobyAwID4gL3Byb2Mvc3lzL2tlcm5lbC9odW5nX3Rh
c2tfdGltZW91dF9zZWNzIiBkaXNhYmxlcyB0aGlzIG1lc3NhZ2UuClsgIDI0My42Nzk5OTdd
IHN3YXBwZXIgICAgICAgICBEIGQxYzI5YzBjICA1OTQ0ICAgICAxICAgICAgMCAweDAwMDAw
MDAwClsgIDI0My42ODA4MDldICBkMWMyOWM0OCAwMDAwMDA0NiAwMDAwMDAwMCBkMWMyOWMw
YyBjMTg0YjE5YSBjMmYzMTAwOCBkMWMyMjAwMCBjYmU1ZjAzNApbICAyNDMuNjgyMDM3XSAg
YzJmMzEwMDggY2JlNWYwMzQgYzJmMzBmZTAgYzJmMzBmZTAgZDFjMjljMWMgYzEwYmJmZTAg
Y2JlNWYwMmMgYzJmMzBmZTAKWyAgMjQzLjY4MzI2N10gIGQxYzI5YzJjIGMxMGJjMDIyIGNi
ZTVmMDJjIDAwMDAwMDAxIDAwMDAwMDAxIGMxMGJjODM5IDAwMDAwMDAyIGMyZjMwZmUwClsg
IDI0My42ODQzMjBdIENhbGwgVHJhY2U6ClsgIDI0My42ODQ2OTJdICBbPGMxODRiMTlhPl0g
PyByYl9lcmFzZSsweDI4Yi8weDU3NgpbICAyNDMuNjg1Mjc5XSAgWzxjMTBiYmZlMD5dID8g
X19kZXF1ZXVlX2VudGl0eSsweDRkLzB4NWYKWyAgMjQzLjY4NTk5MV0gIFs8YzEwYmMwMjI+
XSA/IHNldF9uZXh0X2VudGl0eSsweDMwLzB4NjMKWyAgMjQzLjY4Njc1Ml0gIFs8YzEwYmM4
Mzk+XSA/IHBpY2tfbmV4dF90YXNrX2ZhaXIrMHgyNjcvMHgyOWEKWyAgMjQzLjY4NzYxOF0g
IFs8YzI1ZmFiN2Y+XSBfX3NjaGVkdWxlKzB4ODkzLzB4YTFiClsgIDI0My42ODgxNjZdICBb
PGMyNWZhZTRjPl0gc2NoZWR1bGUrMHgxNDUvMHgxNTUKWyAgMjQzLjY4ODc3MF0gIFs8YzI1
ZmFlODY+XSBzY2hlZHVsZV9wcmVlbXB0X2Rpc2FibGVkKzB4MmEvMHg0ZQpbICAyNDMuNjg5
NDc1XSAgWzxjMjVmYzUzMz5dIG11dGV4X2xvY2tfbmVzdGVkKzB4NDcwLzB4OGNkClsgIDI0
My42OTAyNDJdICBbPGMxYTUyOTUzPl0gPyBkcm1fbW9kZXNldF9sb2NrX2FsbCsweDIzLzB4
ODAKWyAgMjQzLjY5MDg5M10gIFs8YzFhNTI5NTM+XSA/IGRybV9tb2Rlc2V0X2xvY2tfYWxs
KzB4MjMvMHg4MApbICAyNDMuNjkxNjgwXSAgWzxjMWE1Mjk1Mz5dIGRybV9tb2Rlc2V0X2xv
Y2tfYWxsKzB4MjMvMHg4MApbICAyNDMuNjkyMzIyXSAgWzxjMWEzYzE5Zj5dIGRybV9mYl9o
ZWxwZXJfaW5pdGlhbF9jb25maWcrMHgyZDAvMHg3OGUKWyAgMjQzLjY5MzE3N10gIFs8YzEw
YzQxMWQ+XSA/IGRlYnVnX211dGV4X3VubG9jaysweDMxYS8weDNjYQpbICAyNDMuNjkzODcx
XSAgWzxjMjVmZDEyNz5dID8gX211dGV4X2xvY2tfbmVzdF9sb2NrKzB4Nzk3LzB4OGM5Clsg
IDI0My42OTQ1ODFdICBbPGMyNWZlNmVjPl0gPyBfX211dGV4X3VubG9ja19zbG93cGF0aCsw
eDJlYi8weDMwZgpbICAyNDMuNjk1MzQ2XSAgWzxjMWE1MmExMz5dID8gZHJtX21vZGVzZXRf
dW5sb2NrX2FsbCsweDYzLzB4NzYKWyAgMjQzLjY5NjAzN10gIFs8YzFjYmQ3N2I+XSBjaXJy
dXNfZmJkZXZfaW5pdCsweGY4LzB4MTE1ClsgIDI0My42OTY3NTldICBbPGMxY2JjNjM5Pl0g
Y2lycnVzX21vZGVzZXRfaW5pdCsweDJlZS8weDNhOQpbICAyNDMuNjk3NDY5XSAgWzxjMWNi
YTkxNj5dID8gY2lycnVzX2RldmljZV9pbml0KzB4MTUzLzB4MWU5ClsgIDI0My42OTgyMDNd
ICBbPGMxY2JhYzA5Pl0gY2lycnVzX2RyaXZlcl9sb2FkKzB4MTM0LzB4MWMzClsgIDI0My42
OTg4NzVdICBbPGMxYTRiZDE3Pl0gZHJtX2Rldl9yZWdpc3RlcisweGYwLzB4MWY0ClsgIDI0
My42OTk2MzVdICBbPGMxYTRlNWVhPl0gZHJtX2dldF9wY2lfZGV2KzB4MjA3LzB4MzM2Clsg
IDI0My43MDAyMzZdICBbPGMxY2JjYTA3Pl0gPyBjaXJydXNfa2lja19vdXRfZmlybXdhcmVf
ZmIrMHgxMWMvMHgxMzcKWyAgMjQzLjcwMTAzMl0gIFs8YzExZDVmOGU+XSA/IGtmcmVlKzB4
MTRlLzB4MWQ0ClsgIDI0My43MDE2MTJdICBbPGMxY2JjYTZlPl0gY2lycnVzX3BjaV9wcm9i
ZSsweDRjLzB4NWUKWyAgMjQzLjcwMjIzNl0gIFs8YzE4YTQ2OGI+XSBwY2lfZGV2aWNlX3By
b2JlKzB4ZDAvMHgxYTUKWyAgMjQzLjcwMjk5OF0gIFs8YzEyN2M5ZmM+XSA/IHN5c2ZzX2Ny
ZWF0ZV9saW5rKzB4MjAvMHgzMApbICAyNDMuNzAzNzkzXSAgWzxjMWUyMTMxNj5dIGRyaXZl
cl9wcm9iZV9kZXZpY2UrMHgxMzcvMHgzZmUKWyAgMjQzLjcwNDU1NV0gIFs8YzFlMjE2N2Q+
XSBfX2RyaXZlcl9hdHRhY2grMHhhMC8weGY0ClsgIDI0My43MDUyODVdICBbPGMxZTFlNTBj
Pl0gYnVzX2Zvcl9lYWNoX2RldisweDk2LzB4ZjMKWyAgMjQzLjcwNTkwMV0gIFs8YzFlMjBl
MTQ+XSBkcml2ZXJfYXR0YWNoKzB4MjUvMHgzNQpbICAyNDMuNzA2Mzk3XSAgWzxjMWUyMTVk
ZD5dID8gZHJpdmVyX3Byb2JlX2RldmljZSsweDNmZS8weDNmZQpbICAyNDMuNzA3MTA1XSAg
WzxjMWUxZjQyOD5dIGJ1c19hZGRfZHJpdmVyKzB4MTYxLzB4Mzg5ClsgIDI0My43MDc3Mjld
ICBbPGMxZTIyNjA5Pl0gZHJpdmVyX3JlZ2lzdGVyKzB4MTZlLzB4MWY2ClsgIDI0My43MDgz
MTldICBbPGMxMGNiY2ZiPl0gPyBfX3Jhd19zcGluX2xvY2tfaW5pdCsweDQ5LzB4NzgKWyAg
MjQzLjcwODk0Ml0gIFs8YzE4YTQzMDU+XSBfX3BjaV9yZWdpc3Rlcl9kcml2ZXIrMHg2MS8w
eDcyClsgIDI0My43MDk1OTVdICBbPGMxYTRlN2I2Pl0gZHJtX3BjaV9pbml0KzB4OWQvMHgx
OGMKWyAgMjQzLjcxMDE4MF0gIFs8YzMzYmI1Y2E+XSA/IGZ0cmFjZV9kZWZpbmVfZmllbGRz
X2k5MTVfZ2VtX29iamVjdF9jcmVhdGUrMHhhOS8weGE5ClsgIDI0My43MTEwNjRdICBbPGMz
M2JiNjAxPl0gY2lycnVzX2luaXQrMHgzNy8weDRmClsgIDI0My43MTE2OTZdICBbPGMzMzNl
NWZiPl0gZG9fb25lX2luaXRjYWxsKzB4ZjQvMHgyNmMKWyAgMjQzLjcxMjM0Ml0gIFs8YzE4
NTRlYjk+XSA/IHN0cmxlbisweDFiLzB4MzMKWyAgMjQzLjcxMjg2NV0gIFs8YzMzM2Q2ODQ+
XSA/IHJlcGFpcl9lbnZfc3RyaW5nKzB4MzIvMHhkMwpbICAyNDMuNzEzNDg2XSAgWzxjMTA5
ZjZkMT5dID8gcGFyc2VfYXJncysweDMyOC8weDRjZApbICAyNDMuNzE0MTI0XSAgWzxjMzMz
ZWMwND5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4NDkxLzB4NjJhClsgIDI0My43MTQ4MzJd
ICBbPGMzMzNkNjUyPl0gPyBkb19lYXJseV9wYXJhbSsweDEyYi8weDEyYgpbICAyNDMuNzE1
NDAxXSAgWzxjMjU5ZmUyZT5dIGtlcm5lbF9pbml0KzB4MTkvMHgxZjYKWyAgMjQzLjcxNTkz
NV0gIFs8YzEwYjRkOTI+XSA/IHNjaGVkdWxlX3RhaWwrMHgxYS8weGE5ClsgIDI0My43MTY2
MDddICBbPGMyNjA0MmMwPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDIwLzB4MzAKWyAg
MjQzLjcxNzMwMF0gIFs8YzI1OWZlMTU+XSA/IHJlc3RfaW5pdCsweDFkZC8weDFkZApbICAy
NDMuNzE3OTAzXSA1IGxvY2tzIGhlbGQgYnkgc3dhcHBlci8xOgpbICAyNDMuNzE4Mzk4XSAg
IzA6ICAoJmRldi0+bXV0ZXgpey4uLi4uLn0sIGF0OiBbPGMxZTIwNTcxPl0gZGV2aWNlX2xv
Y2srMHgxYi8weDJiClsgIDI0My43MTk1MzJdICAjMTogICgmZGV2LT5tdXRleCl7Li4uLi4u
fSwgYXQ6IFs8YzFlMjA1NzE+XSBkZXZpY2VfbG9jaysweDFiLzB4MmIKWyAgMjQzLjcyMDU4
Ml0gICMyOiAgKGRybV9nbG9iYWxfbXV0ZXgpey4uLi4uLn0sIGF0OiBbPGMxYTRiYzRiPl0g
ZHJtX2Rldl9yZWdpc3RlcisweDI0LzB4MWY0ClsgIDI0My43MjIwMDBdICAjMzogICgmZGV2
LT5tb2RlX2NvbmZpZy5tdXRleCl7Li4uLi4ufSwgYXQ6IFs8YzFhM2MxOGE+XSBkcm1fZmJf
aGVscGVyX2luaXRpYWxfY29uZmlnKzB4MmJiLzB4NzhlClsgIDI0My43MjM1NTZdICAjNDog
ICgmZGV2LT5tb2RlX2NvbmZpZy5tdXRleCl7Li4uLi4ufSwgYXQ6IFs8YzFhNTI5NTM+XSBk
cm1fbW9kZXNldF9sb2NrX2FsbCsweDIzLzB4ODAKWyAgMjQzLjcyNDg5N10gc2VuZGluZyBO
TUkgdG8gYWxsIENQVXM6ClsgIDI0My43MjUzNTddIE5NSSBiYWNrdHJhY2UgZm9yIGNwdSAw
ClsgIDI0My43MjU4MzJdIENQVTogMCBQSUQ6IDggQ29tbToga2h1bmd0YXNrZCBOb3QgdGFp
bnRlZCAzLjE1LjAtcmM1LTAwMDg4LWdmNzI4MDgwICMxClsgIDI0My43MjU5OTJdIHRhc2s6
IGQxZGQwNDEwIHRpOiBkMWRmODAwMCB0YXNrLnRpOiBkMWRmODAwMApbICAyNDMuNzI1OTky
XSBFSVA6IDAwNjA6WzxjMTA0NThiNj5dIEVGTEFHUzogMDAwMDAwNDYgQ1BVOiAwClsgIDI0
My43MjU5OTJdIEVJUCBpcyBhdCBuYXRpdmVfYXBpY19tZW1fd3JpdGUrMHgyMC8weDMwClsg
IDI0My43MjU5OTJdIEVBWDogZmZmZmIzMDAgRUJYOiAwMDAwMDIwMSBFQ1g6IGZmZmZmMDAw
IEVEWDogMDAwMDBjMDAKWyAgMjQzLjcyNTk5Ml0gRVNJOiAwMDAwMDAwMiBFREk6IDAxMDAw
MDAwIEVCUDogZDFkZjllOWMgRVNQOiBkMWRmOWU5YwpbICAyNDMuNzI1OTkyXSAgRFM6IDAw
N2IgRVM6IDAwN2IgRlM6IDAwMDAgR1M6IDAwMDAgU1M6IDAwNjgKWyAgMjQzLjcyNTk5Ml0g
Q1IwOiA4MDA1MDAzYiBDUjI6IDAwMDAwMDAwIENSMzogMDM0NDgwMDAgQ1I0OiAwMDAwMDZk
MApbICAyNDMuNzI1OTkyXSBTdGFjazoKWyAgMjQzLjcyNTk5Ml0gIGQxZGY5ZWI0IGMxMDQ1
YTVjIDAwMDAwODAwIDAwMDAwMjQ2IDAwMDAwMDAxIDAwMDAwMDAwIGQxZGY5ZWQwIGMxMDQ1
ZjkyClsgIDI0My43MjU5OTJdICAwMDAwMDAwMiAwMDAwMDAwMCAwMDAwMDAwMiBkMWMyMjAw
MCBkMWMyMjAwMCBkMWRmOWVkOCBjMTA0NWZlZSBkMWRmOWVlOApbICAyNDMuNzI1OTkyXSAg
YzEwNDYyY2QgYzJkNWRjZGUgMDAwMDAwMDIgZDFkZjlmMzAgYzExMWZlY2YgYzJkNmJiODcg
YzM0ODBlNmMgYzJlZjY0NTYKWyAgMjQzLjcyNTk5Ml0gQ2FsbCBUcmFjZToKWyAgMjQzLjcy
NTk5Ml0gIFs8YzEwNDVhNWM+XSBfX2RlZmF1bHRfc2VuZF9JUElfZGVzdF9maWVsZCsweGVj
LzB4MTAwClsgIDI0My43MjU5OTJdICBbPGMxMDQ1ZjkyPl0gZGVmYXVsdF9zZW5kX0lQSV9t
YXNrX2xvZ2ljYWwrMHgxNmMvMHgxN2QKWyAgMjQzLjcyNTk5Ml0gIFs8YzEwNDVmZWU+XSBk
ZWZhdWx0X3NlbmRfSVBJX2FsbCsweDM4LzB4OTQKWyAgMjQzLjcyNTk5Ml0gIFs8YzEwNDYy
Y2Q+XSBhcmNoX3RyaWdnZXJfYWxsX2NwdV9iYWNrdHJhY2UrMHhjNS8weDFiOApbICAyNDMu
NzI1OTkyXSAgWzxjMTExZmVjZj5dIHdhdGNoZG9nKzB4NTVkLzB4NjFhClsgIDI0My43MjU5
OTJdICBbPGMxMTFmOTcyPl0gPyByY3VfcmVhZF9sb2NrKzB4ODEvMHg4MQpbICAyNDMuNzI1
OTkyXSAgWzxjMTBhMjU4MT5dIGt0aHJlYWQrMHgxMTUvMHgxMjgKWyAgMjQzLjcyNTk5Ml0g
IFs8YzEwYzdmZWQ+XSA/IGxvY2tfcmVsZWFzZSsweDNjYS8weDQ4YQpbICAyNDMuNzI1OTky
XSAgWzxjMjYwNDJjMD5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgyMC8weDMwClsgIDI0
My43MjU5OTJdICBbPGMxMGEyNDZjPl0gPyBfX2t0aHJlYWRfdW5wYXJrKzB4OWIvMHg5Ygpb
ICAyNDMuNzI1OTkyXSBDb2RlOiA4MyAxNSBmNCBkYiA0NiBjMyAwMCA4OSBjOCA1ZCBjMyA1
NSA4OSBlNSA4MyAwNSAwOCBkYyA0NiBjMyAwMSA4MyAxNSAwYyBkYyA0NiBjMyAwMCA4YiAw
ZCA3NCBiZCBmMSBjMiA4ZCA4NCAwOCAwMCBjMCBmZiBmZiA4OSAxMCA8ODM+IDA1IDEwIGRj
IDQ2IGMzIDAxIDgzIDE1IDE0IGRjIDQ2IGMzIDAwIDVkIGMzIDU1IDg5IGU1IDA5IGM4Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA2MDIxMTQwL2Y3MjgwODBkNmJhYzQ3YWFiMmQ1
NzA0OTJhY2VmODgzMTdhYzhlMDMvZG1lc2ctcXVhbnRhbC1pdmI0NC0zMToyMDE0MDYwMjEz
NDA0NjppMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDA6My4xNS4wLXJjNS0wMDA4OC1nZjcy
ODA4MDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA2MDIxMTQwL2Y3MjgwODBkNmJh
YzQ3YWFiMmQ1NzA0OTJhY2VmODgzMTdhYzhlMDMvZG1lc2ctcXVhbnRhbC1pdmI0NC0zNDoy
MDE0MDYwMjEzNDA0NjppMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDA6My4xNS4wLXJjNS0w
MDA4OC1nZjcyODA4MDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA2MDIxMTQwL2Y3
MjgwODBkNmJhYzQ3YWFiMmQ1NzA0OTJhY2VmODgzMTdhYzhlMDMvZG1lc2ctcXVhbnRhbC1p
dmI0NC01NjoyMDE0MDYwMjEzNDA0NjppMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDA6My4x
NS4wLXJjNS0wMDA4OC1nZjcyODA4MDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA2
MDIxMTQwL2Y3MjgwODBkNmJhYzQ3YWFiMmQ1NzA0OTJhY2VmODgzMTdhYzhlMDMvZG1lc2ct
cXVhbnRhbC1pdmI0NC01NzoyMDE0MDYwMjEzNDA0NjppMzg2LXJhbmRjb25maWctYzEtMDYw
MjExNDA6My4xNS4wLXJjNS0wMDA4OC1nZjcyODA4MDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWMxLTA2MDIxMTQwL2Y3MjgwODBkNmJhYzQ3YWFiMmQ1NzA0OTJhY2VmODgzMTdhYzhl
MDMvZG1lc2ctcXVhbnRhbC1pdmI0NC03NDoyMDE0MDYwMjEzNDA0NjppMzg2LXJhbmRjb25m
aWctYzEtMDYwMjExNDA6My4xNS4wLXJjNS0wMDA4OC1nZjcyODA4MDoxCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWMxLTA2MDIxMTQwL2Y3MjgwODBkNmJhYzQ3YWFiMmQ1NzA0OTJhY2Vm
ODgzMTdhYzhlMDMvZG1lc2ctcXVhbnRhbC1pdmI0NC05NToyMDE0MDYwMjEzNDA0NjppMzg2
LXJhbmRjb25maWctYzEtMDYwMjExNDA6My4xNS4wLXJjNS0wMDA4OC1nZjcyODA4MDoxCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA2MDIxMTQwL2Y3MjgwODBkNmJhYzQ3YWFiMmQ1
NzA0OTJhY2VmODgzMTdhYzhlMDMvZG1lc2cteW9jdG8taXZiNDQtMjc6MjAxNDA2MDIxMzQw
MzI6aTM4Ni1yYW5kY29uZmlnLWMxLTA2MDIxMTQwOjMuMTUuMC1yYzUtMDAwODgtZ2Y3Mjgw
ODA6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNjAyMTE0MC9mNzI4MDgwZDZiYWM0
N2FhYjJkNTcwNDkyYWNlZjg4MzE3YWM4ZTAzL2RtZXNnLXlvY3RvLWl2YjQ0LTU6MjAxNDA2
MDIxMzQwMzI6aTM4Ni1yYW5kY29uZmlnLWMxLTA2MDIxMTQwOjMuMTUuMC1yYzUtMDAwODgt
Z2Y3MjgwODA6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNjAyMTE0MC9mNzI4MDgw
ZDZiYWM0N2FhYjJkNTcwNDkyYWNlZjg4MzE3YWM4ZTAzL2RtZXNnLXlvY3RvLWl2YjQ0LTYz
OjIwMTQwNjAyMTM0MDMyOmkzODYtcmFuZGNvbmZpZy1jMS0wNjAyMTE0MDozLjE1LjAtcmM1
LTAwMDg4LWdmNzI4MDgwOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDAv
ZjcyODA4MGQ2YmFjNDdhYWIyZDU3MDQ5MmFjZWY4ODMxN2FjOGUwMy9kbWVzZy15b2N0by1p
dmI0NC02NDoyMDE0MDYwMjEzNDAzMjppMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDA6My4x
NS4wLXJjNS0wMDA4OC1nZjcyODA4MDoxCjA6MTA6MTAgYWxsX2dvb2Q6YmFkOmFsbF9iYWQg
Ym9vdHMKG1sxOzM1bTIwMTQtMDYtMDIgMTM6NDE6MTggUkVQRUFUIENPVU5UOiAyMCAgIyAv
Yy9ib290LWJpc2VjdC9saW51eDQvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5n
OiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAwIHN0ZXBz
KQpbYjczOWM5OTgyODAxZTVmNzYwOTczMTFiNjdkZmQ3Njg5MWIxMDk4OF0gZHJtOiB0YWtl
IG1vZGVzZXQgbG9ja3MgYXJvdW5kIGluaXRpYWwgZmIgaGVscGVyIHByb2JpbmcKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3Qt
YmlzZWN0L2xpbnV4NC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDAvbGludXgtZGV2ZWw6ZGV2ZWwtaG91
cmx5LTIwMTQwNjAyMTA6YjczOWM5OTgyODAxZTVmNzYwOTczMTFiNjdkZmQ3Njg5MWIxMDk4
ODpiaXNlY3QtbGludXg0CgoyMDE0LTA2LTAyLTEzOjQxOjE5IGI3MzljOTk4MjgwMWU1Zjc2
MDk3MzExYjY3ZGZkNzY4OTFiMTA5ODggY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRv
IC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWMxLTA2MDIxMTQw
LWI3MzljOTk4MjgwMWU1Zjc2MDk3MzExYjY3ZGZkNzY4OTFiMTA5ODgKQ2hlY2sgZm9yIGtl
cm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNjAyMTE0MC9iNzM5Yzk5ODI4
MDFlNWY3NjA5NzMxMWI2N2RmZDc2ODkxYjEwOTg4CndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzEtMDYwMjEx
NDAtYjczOWM5OTgyODAxZTVmNzYwOTczMTFiNjdkZmQ3Njg5MWIxMDk4OAp3YWl0aW5nIGZv
ciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNv
bmZpZy1jMS0wNjAyMTE0MC1iNzM5Yzk5ODI4MDFlNWY3NjA5NzMxMWI2N2RmZDc2ODkxYjEw
OTg4Cmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDAvYjczOWM5
OTgyODAxZTVmNzYwOTczMTFiNjdkZmQ3Njg5MWIxMDk4OC92bWxpbnV6LTMuMTUuMC1yYzUt
MDAwODctZ2I3MzljOTkKCjIwMTQtMDYtMDItMTM6NDY6MTkgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgLi4uLi4uLi4uIFRFU1QgRkFJTFVSRQpbICAgNjIuMTcwNTQ0XSBzcGluX2xvY2stdG9y
dHVyZTogV3JpdGVzOiAgVG90YWw6IDIgIE1heC9NaW46IDAvMCAgIEZhaWw6IDAgClsgIDEy
Mi4xNjExNDJdIHNwaW5fbG9jay10b3J0dXJlOiBXcml0ZXM6ICBUb3RhbDogMiAgTWF4L01p
bjogMC8wICAgRmFpbDogMCAKWyAgMTgyLjE1Mjk4Nl0gc3Bpbl9sb2NrLXRvcnR1cmU6IFdy
aXRlczogIFRvdGFsOiAyICBNYXgvTWluOiAwLzAgICBGYWlsOiAwIApbICAyNDAuMTM1OTM3
XSBJTkZPOiB0YXNrIHN3YXBwZXI6MSBibG9ja2VkIGZvciBtb3JlIHRoYW4gMTIwIHNlY29u
ZHMuClsgIDI0MC4xMzY2NTNdICAgICAgIE5vdCB0YWludGVkIDMuMTUuMC1yYzUtMDAwODct
Z2I3MzljOTkgIzEKWyAgMjQwLjEzNzE4N10gImVjaG8gMCA+IC9wcm9jL3N5cy9rZXJuZWwv
aHVuZ190YXNrX3RpbWVvdXRfc2VjcyIgZGlzYWJsZXMgdGhpcyBtZXNzYWdlLgpbICAyNDAu
MTM3OTg3XSBzd2FwcGVyICAgICAgICAgRCBkMWMyOWMyNCAgNTk0NCAgICAgMSAgICAgIDAg
MHgwMDAwMDAwMApbICAyNDAuMTM4NjkxXSAgZDFjMjljNDggMDAwMDAwNDYgMDAwMDAwMDAg
ZDFjMjljMjQgYzE4NGFmNGMgYzJmMzEwMDggZDFjMjIwMDAgY2M2ZjMwMzQKWyAgMjQwLjEz
OTU2MF0gIGMyZjMxMDA4IGNjNmYzMDM0IGMyZjMwZmUwIGMyZjMwZmUwIGQxYzI5YzFjIGMx
MGJiZmUwIGNjNmYzMDJjIGMyZjMwZmUwClsgIDI0MC4xNDA0OTRdICBkMWMyOWMyYyBjMTBi
YzAyMiBjYzZmMzAyYyAwMDAwMDAwMSAwMDAwMDAwMSBjMTBiYzgzOSAwMDAwMDAwMiBjMmYz
MGZlMApbICAyNDAuMTQxNDI1XSBDYWxsIFRyYWNlOgpbICAyNDAuMTQxNzM3XSAgWzxjMTg0
YWY0Yz5dID8gcmJfZXJhc2UrMHgzZC8weDU3NgpbICAyNDAuMTQyMjE0XSAgWzxjMTBiYmZl
MD5dID8gX19kZXF1ZXVlX2VudGl0eSsweDRkLzB4NWYKWyAgMjQwLjE0MjcyOV0gIFs8YzEw
YmMwMjI+XSA/IHNldF9uZXh0X2VudGl0eSsweDMwLzB4NjMKWyAgMjQwLjE0MzIwOV0gIFs8
YzEwYmM4Mzk+XSA/IHBpY2tfbmV4dF90YXNrX2ZhaXIrMHgyNjcvMHgyOWEKWyAgMjQwLjE0
MzgwOV0gIFs8YzI1ZmFiNWY+XSBfX3NjaGVkdWxlKzB4ODkzLzB4YTFiClsgIDI0MC4xNDQy
OTNdICBbPGMyNWZhZTJjPl0gc2NoZWR1bGUrMHgxNDUvMHgxNTUKWyAgMjQwLjE0NDc5NF0g
IFs8YzI1ZmFlNjY+XSBzY2hlZHVsZV9wcmVlbXB0X2Rpc2FibGVkKzB4MmEvMHg0ZQpbICAy
NDAuMTQ1Mzk0XSAgWzxjMjVmYzUxMz5dIG11dGV4X2xvY2tfbmVzdGVkKzB4NDcwLzB4OGNk
ClsgIDI0MC4xNDU5NTNdICBbPGMxYTUyOTUzPl0gPyBkcm1fbW9kZXNldF9sb2NrX2FsbCsw
eDIzLzB4ODAKWyAgMjQwLjE0NjQ4N10gIFs8YzFhNTI5NTM+XSA/IGRybV9tb2Rlc2V0X2xv
Y2tfYWxsKzB4MjMvMHg4MApbICAyNDAuMTQ3MDQ2XSAgWzxjMWE1Mjk1Mz5dIGRybV9tb2Rl
c2V0X2xvY2tfYWxsKzB4MjMvMHg4MApbICAyNDAuMTQ3NTc5XSAgWzxjMWEzYzE5Zj5dIGRy
bV9mYl9oZWxwZXJfaW5pdGlhbF9jb25maWcrMHgyZDAvMHg3OGUKWyAgMjQwLjE0ODIxMl0g
IFs8YzEwYzQxMWQ+XSA/IGRlYnVnX211dGV4X3VubG9jaysweDMxYS8weDNjYQpbICAyNDAu
MTQ4NzgyXSAgWzxjMjVmZDEwNz5dID8gX211dGV4X2xvY2tfbmVzdF9sb2NrKzB4Nzk3LzB4
OGM5ClsgIDI0MC4xNDkzODldICBbPGMyNWZlNmNjPl0gPyBfX211dGV4X3VubG9ja19zbG93
cGF0aCsweDJlYi8weDMwZgpbICAyNDAuMTUwMDAxXSAgWzxjMWE1MmExMz5dID8gZHJtX21v
ZGVzZXRfdW5sb2NrX2FsbCsweDYzLzB4NzYKWyAgMjQwLjE1MDYwMV0gIFs8YzFjYmQ3NWQ+
XSBjaXJydXNfZmJkZXZfaW5pdCsweGY4LzB4MTE1ClsgIDI0MC4xNTExMDldICBbPGMxY2Jj
NjFiPl0gY2lycnVzX21vZGVzZXRfaW5pdCsweDJlZS8weDNhOQpbICAyNDAuMTUxNjI4XSAg
WzxjMWNiYThmOD5dID8gY2lycnVzX2RldmljZV9pbml0KzB4MTUzLzB4MWU5ClsgIDI0MC4x
NTIyMTNdICBbPGMxY2JhYmViPl0gY2lycnVzX2RyaXZlcl9sb2FkKzB4MTM0LzB4MWMzClsg
IDI0MC4xNTI3NzFdICBbPGMxYTRiZDE3Pl0gZHJtX2Rldl9yZWdpc3RlcisweGYwLzB4MWY0
ClsgIDI0MC4xNTMzMTJdICBbPGMxYTRlNWVhPl0gZHJtX2dldF9wY2lfZGV2KzB4MjA3LzB4
MzM2ClsgIDI0MC4xNTM4MjBdICBbPGMxY2JjOWU5Pl0gPyBjaXJydXNfa2lja19vdXRfZmly
bXdhcmVfZmIrMHgxMWMvMHgxMzcKWyAgMjQwLjE1NDQ4NF0gIFs8YzExZDVmOGU+XSA/IGtm
cmVlKzB4MTRlLzB4MWQ0ClsgIDI0MC4xNTQ5MzVdICBbPGMxY2JjYTUwPl0gY2lycnVzX3Bj
aV9wcm9iZSsweDRjLzB4NWUKWyAgMjQwLjE1NTQxMV0gIFs8YzE4YTQ2OGI+XSBwY2lfZGV2
aWNlX3Byb2JlKzB4ZDAvMHgxYTUKWyAgMjQwLjE1NTk2MV0gIFs8YzEyN2M5ZmM+XSA/IHN5
c2ZzX2NyZWF0ZV9saW5rKzB4MjAvMHgzMApbICAyNDAuMTU2NTIzXSAgWzxjMWUyMTJmOD5d
IGRyaXZlcl9wcm9iZV9kZXZpY2UrMHgxMzcvMHgzZmUKWyAgMjQwLjE1NzA3MF0gIFs8YzFl
MjE2NWY+XSBfX2RyaXZlcl9hdHRhY2grMHhhMC8weGY0ClsgIDI0MC4xNTc1NzhdICBbPGMx
ZTFlNGVlPl0gYnVzX2Zvcl9lYWNoX2RldisweDk2LzB4ZjMKWyAgMjQwLjE1ODA5OV0gIFs8
YzFlMjBkZjY+XSBkcml2ZXJfYXR0YWNoKzB4MjUvMHgzNQpbICAyNDAuMTU4NTg4XSAgWzxj
MWUyMTViZj5dID8gZHJpdmVyX3Byb2JlX2RldmljZSsweDNmZS8weDNmZQpbICAyNDAuMTU5
MTE4XSAgWzxjMWUxZjQwYT5dIGJ1c19hZGRfZHJpdmVyKzB4MTYxLzB4Mzg5ClsgIDI0MC4x
NTk2MDRdICBbPGMxZTIyNWViPl0gZHJpdmVyX3JlZ2lzdGVyKzB4MTZlLzB4MWY2ClsgIDI0
MC4xNjAxNjFdICBbPGMxMGNiY2ZiPl0gPyBfX3Jhd19zcGluX2xvY2tfaW5pdCsweDQ5LzB4
NzgKWyAgMjQwLjE2MDc4NV0gIFs8YzE4YTQzMDU+XSBfX3BjaV9yZWdpc3Rlcl9kcml2ZXIr
MHg2MS8weDcyClsgIDI0MC4xNjEzNTddICBbPGMxYTRlN2I2Pl0gZHJtX3BjaV9pbml0KzB4
OWQvMHgxOGMKWyAgMjQwLjE2MTg3N10gIFs8YzMzYmI1Y2E+XSA/IGZ0cmFjZV9kZWZpbmVf
ZmllbGRzX2k5MTVfZ2VtX29iamVjdF9jcmVhdGUrMHhhOS8weGE5ClsgIDI0MC4xNjI2MzBd
ICBbPGMzM2JiNjAxPl0gY2lycnVzX2luaXQrMHgzNy8weDRmClsgIDI0MC4xNjMwNzNdICBb
PGMzMzNlNWZiPl0gZG9fb25lX2luaXRjYWxsKzB4ZjQvMHgyNmMKWyAgMjQwLjE2MzU1Nl0g
IFs8YzEwYzAwMDA+XSA/IGVucXVldWVfdGFza19kbCsweDYxNy8weDcwNQpbICAyNDAuMTY0
MTEyXSAgWzxjMTg1NGViNz5dID8gc3RybGVuKzB4MTkvMHgzMwpbICAyNDAuMTY0NTQ5XSAg
WzxjMzMzZDY4ND5dID8gcmVwYWlyX2Vudl9zdHJpbmcrMHgzMi8weGQzClsgIDI0MC4xNjUw
ODNdICBbPGMxMDlmNmQxPl0gPyBwYXJzZV9hcmdzKzB4MzI4LzB4NGNkClsgIDI0MC4xNjU1
OTNdICBbPGMzMzNlYzA0Pl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHg0OTEvMHg2MmEKWyAg
MjQwLjE2NjE1NV0gIFs8YzMzM2Q2NTI+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4MTJiLzB4MTJi
ClsgIDI0MC4xNjY2OTJdICBbPGMyNTlmZTBlPl0ga2VybmVsX2luaXQrMHgxOS8weDFmNgpb
ICAyNDAuMTY3MTYxXSAgWzxjMTBiNGQ5Mj5dID8gc2NoZWR1bGVfdGFpbCsweDFhLzB4YTkK
WyAgMjQwLjE2NzY0M10gIFs8YzI2MDQyYTA+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4
MjAvMHgzMApbICAyNDAuMTY4MTk3XSAgWzxjMjU5ZmRmNT5dID8gcmVzdF9pbml0KzB4MWRk
LzB4MWRkClsgIDI0MC4xNjg2OTVdIDUgbG9ja3MgaGVsZCBieSBzd2FwcGVyLzE6ClsgIDI0
MC4xNjkwNzhdICAjMDogICgmZGV2LT5tdXRleCl7Li4uLi4ufSwgYXQ6IFs8YzFlMjA1NTM+
XSBkZXZpY2VfbG9jaysweDFiLzB4MmIKWyAgMjQwLjE2OTk0NV0gICMxOiAgKCZkZXYtPm11
dGV4KXsuLi4uLi59LCBhdDogWzxjMWUyMDU1Mz5dIGRldmljZV9sb2NrKzB4MWIvMHgyYgpb
ICAyNDAuMTcwNzU2XSAgIzI6ICAoZHJtX2dsb2JhbF9tdXRleCl7Li4uLi4ufSwgYXQ6IFs8
YzFhNGJjNGI+XSBkcm1fZGV2X3JlZ2lzdGVyKzB4MjQvMHgxZjQKWyAgMjQwLjE3MTY0M10g
ICMzOiAgKCZkZXYtPm1vZGVfY29uZmlnLm11dGV4KXsuLi4uLi59LCBhdDogWzxjMWEzYzE4
YT5dIGRybV9mYl9oZWxwZXJfaW5pdGlhbF9jb25maWcrMHgyYmIvMHg3OGUKWyAgMjQwLjE3
Mjc3M10gICM0OiAgKCZkZXYtPm1vZGVfY29uZmlnLm11dGV4KXsuLi4uLi59LCBhdDogWzxj
MWE1Mjk1Mz5dIGRybV9tb2Rlc2V0X2xvY2tfYWxsKzB4MjMvMHg4MApbICAyNDAuMTczODIw
XSBzZW5kaW5nIE5NSSB0byBhbGwgQ1BVczoKWyAgMjQwLjE3NDIyMV0gTk1JIGJhY2t0cmFj
ZSBmb3IgY3B1IDAKWyAgMjQwLjE3NDU4M10gQ1BVOiAwIFBJRDogOCBDb21tOiBraHVuZ3Rh
c2tkIE5vdCB0YWludGVkIDMuMTUuMC1yYzUtMDAwODctZ2I3MzljOTkgIzEKWyAgMjQwLjE3
NTMwOV0gdGFzazogZDFkZDA0MTAgdGk6IGQxZGY4MDAwIHRhc2sudGk6IGQxZGY4MDAwClsg
IDI0MC4xNzU4ODNdIEVJUDogMDA2MDpbPGMxMDQ1OGI2Pl0gRUZMQUdTOiAwMDAwMDA0NiBD
UFU6IDAKWyAgMjQwLjE3NTkwM10gRUlQIGlzIGF0IG5hdGl2ZV9hcGljX21lbV93cml0ZSsw
eDIwLzB4MzAKWyAgMjQwLjE3NTkwM10gRUFYOiBmZmZmYjMwMCBFQlg6IDAwMDAwMjAxIEVD
WDogZmZmZmYwMDAgRURYOiAwMDAwMGMwMApbICAyNDAuMTc1OTAzXSBFU0k6IDAwMDAwMDAy
IEVESTogMDEwMDAwMDAgRUJQOiBkMWRmOWU5YyBFU1A6IGQxZGY5ZTljClsgIDI0MC4xNzU5
MDNdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDAwMCBHUzogMDAwMCBTUzogMDA2OApbICAy
NDAuMTc1OTAzXSBDUjA6IDgwMDUwMDNiIENSMjogMDAwMDAwMDAgQ1IzOiAwMzQ0ODAwMCBD
UjQ6IDAwMDAwNmQwClsgIDI0MC4xNzU5MDNdIFN0YWNrOgpbICAyNDAuMTc1OTAzXSAgZDFk
ZjllYjQgYzEwNDVhNWMgMDAwMDA4MDAgMDAwMDAyNDYgMDAwMDAwMDEgMDAwMDAwMDAgZDFk
ZjllZDAgYzEwNDVmOTIKWyAgMjQwLjE3NTkwM10gIDAwMDAwMDAyIDAwMDAwMDAwIDAwMDAw
MDAyIGQxYzIyMDAwIGQxYzIyMDAwIGQxZGY5ZWQ4IGMxMDQ1ZmVlIGQxZGY5ZWU4ClsgIDI0
MC4xNzU5MDNdICBjMTA0NjJjZCBjMmQ1ZGNlMiAwMDAwMDAwMiBkMWRmOWYzMCBjMTExZmVj
ZiBjMmQ2YmI4YiBjMzQ4MGU2YyBjMmVmNjQ1NgpbICAyNDAuMTc1OTAzXSBDYWxsIFRyYWNl
OgpbICAyNDAuMTc1OTAzXSAgWzxjMTA0NWE1Yz5dIF9fZGVmYXVsdF9zZW5kX0lQSV9kZXN0
X2ZpZWxkKzB4ZWMvMHgxMDAKWyAgMjQwLjE3NTkwM10gIFs8YzEwNDVmOTI+XSBkZWZhdWx0
X3NlbmRfSVBJX21hc2tfbG9naWNhbCsweDE2Yy8weDE3ZApbICAyNDAuMTc1OTAzXSAgWzxj
MTA0NWZlZT5dIGRlZmF1bHRfc2VuZF9JUElfYWxsKzB4MzgvMHg5NApbICAyNDAuMTc1OTAz
XSAgWzxjMTA0NjJjZD5dIGFyY2hfdHJpZ2dlcl9hbGxfY3B1X2JhY2t0cmFjZSsweGM1LzB4
MWI4ClsgIDI0MC4xNzU5MDNdICBbPGMxMTFmZWNmPl0gd2F0Y2hkb2crMHg1NWQvMHg2MWEK
WyAgMjQwLjE3NTkwM10gIFs8YzExMWY5NzI+XSA/IHJjdV9yZWFkX2xvY2srMHg4MS8weDgx
ClsgIDI0MC4xNzU5MDNdICBbPGMxMGEyNTgxPl0ga3RocmVhZCsweDExNS8weDEyOApbICAy
NDAuMTc1OTAzXSAgWzxjMTBjN2ZlZD5dID8gbG9ja19yZWxlYXNlKzB4M2NhLzB4NDhhClsg
IDI0MC4xNzU5MDNdICBbPGMyNjA0MmEwPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDIw
LzB4MzAKWyAgMjQwLjE3NTkwM10gIFs8YzEwYTI0NmM+XSA/IF9fa3RocmVhZF91bnBhcmsr
MHg5Yi8weDliClsgIDI0MC4xNzU5MDNdIENvZGU6IDgzIDE1IGY0IGRiIDQ2IGMzIDAwIDg5
IGM4IDVkIGMzIDU1IDg5IGU1IDgzIDA1IDA4IGRjIDQ2IGMzIDAxIDgzIDE1IDBjIGRjIDQ2
IGMzIDAwIDhiIDBkIDc0IGJkIGYxIGMyIDhkIDg0IDA4IDAwIGMwIGZmIGZmIDg5IDEwIDw4
Mz4gMDUgMTAgZGMgNDYgYzMgMDEgODMgMTUgMTQgZGMgNDYgYzMgMDAgNWQgYzMgNTUgODkg
ZTUgMDkgYzgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDAvYjczOWM5OTgy
ODAxZTVmNzYwOTczMTFiNjdkZmQ3Njg5MWIxMDk4OC9kbWVzZy15b2N0by1pdmI0NC0xMjoy
MDE0MDYwMjEzNTAyNTppMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDA6My4xNS4wLXJjNS0w
MDA4Ny1nYjczOWM5OToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA2MDIxMTQwL2I3
MzljOTk4MjgwMWU1Zjc2MDk3MzExYjY3ZGZkNzY4OTFiMTA5ODgvZG1lc2cteW9jdG8taXZi
NDQtMTk6MjAxNDA2MDIxMzUwMjU6aTM4Ni1yYW5kY29uZmlnLWMxLTA2MDIxMTQwOjMuMTUu
MC1yYzUtMDAwODctZ2I3MzljOTk6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNjAy
MTE0MC9iNzM5Yzk5ODI4MDFlNWY3NjA5NzMxMWI2N2RmZDc2ODkxYjEwOTg4L2RtZXNnLXlv
Y3RvLWl2YjQ0LTQ4OjIwMTQwNjAyMTM1MDI1OmkzODYtcmFuZGNvbmZpZy1jMS0wNjAyMTE0
MDozLjE1LjAtcmM1LTAwMDg3LWdiNzM5Yzk5OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
YzEtMDYwMjExNDAvYjczOWM5OTgyODAxZTVmNzYwOTczMTFiNjdkZmQ3Njg5MWIxMDk4OC9k
bWVzZy15b2N0by1pdmI0Mi0zMzoyMDE0MDYwMjEzNTAyNjppMzg2LXJhbmRjb25maWctYzEt
MDYwMjExNDA6My4xNS4wLXJjNS0wMDA4Ny1nYjczOWM5OToxCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWMxLTA2MDIxMTQwL2I3MzljOTk4MjgwMWU1Zjc2MDk3MzExYjY3ZGZkNzY4OTFi
MTA5ODgvZG1lc2cteW9jdG8taXZiNDItNTI6MjAxNDA2MDIxMzUwMjY6aTM4Ni1yYW5kY29u
ZmlnLWMxLTA2MDIxMTQwOjMuMTUuMC1yYzUtMDAwODctZ2I3MzljOTk6MQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1jMS0wNjAyMTE0MC9iNzM5Yzk5ODI4MDFlNWY3NjA5NzMxMWI2N2Rm
ZDc2ODkxYjEwOTg4L2RtZXNnLXlvY3RvLWl2YjQyLTY5OjIwMTQwNjAyMTM1MDI3OmkzODYt
cmFuZGNvbmZpZy1jMS0wNjAyMTE0MDozLjE1LjAtcmM1LTAwMDg3LWdiNzM5Yzk5OjEKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDAvYjczOWM5OTgyODAxZTVmNzYwOTcz
MTFiNjdkZmQ3Njg5MWIxMDk4OC9kbWVzZy1xdWFudGFsLWl2YjQxLTQ5OjIwMTQwNjAyMTM1
MDM2OmkzODYtcmFuZGNvbmZpZy1jMS0wNjAyMTE0MDozLjE1LjAtcmM1LTAwMDg3LWdiNzM5
Yzk5OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDAvYjczOWM5OTgyODAx
ZTVmNzYwOTczMTFiNjdkZmQ3Njg5MWIxMDk4OC9kbWVzZy1xdWFudGFsLWl2YjQxLTk5OjIw
MTQwNjAyMTM1MDM2OmkzODYtcmFuZGNvbmZpZy1jMS0wNjAyMTE0MDozLjE1LjAtcmM1LTAw
MDg3LWdiNzM5Yzk5OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDAvYjcz
OWM5OTgyODAxZTVmNzYwOTczMTFiNjdkZmQ3Njg5MWIxMDk4OC9kbWVzZy1xdWFudGFsLWl2
YjQyLTEwNToyMDE0MDYwMjEzNTAzNjppMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDA6My4x
NS4wLXJjNS0wMDA4Ny1nYjczOWM5OToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA2
MDIxMTQwL2I3MzljOTk4MjgwMWU1Zjc2MDk3MzExYjY3ZGZkNzY4OTFiMTA5ODgvZG1lc2ct
cXVhbnRhbC1pdmI0Mi0yMToyMDE0MDYwMjEzNTA0MDppMzg2LXJhbmRjb25maWctYzEtMDYw
MjExNDA6My4xNS4wLXJjNS0wMDA4Ny1nYjczOWM5OToxCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWMxLTA2MDIxMTQwL2I3MzljOTk4MjgwMWU1Zjc2MDk3MzExYjY3ZGZkNzY4OTFiMTA5
ODgvZG1lc2ctcXVhbnRhbC1pdmI0Mi0yODoyMDE0MDYwMjEzNTAzNjppMzg2LXJhbmRjb25m
aWctYzEtMDYwMjExNDA6My4xNS4wLXJjNS0wMDA4Ny1nYjczOWM5OToxCjA6MTI6MTEgYWxs
X2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCmI3MzljOTk4MjgwMWU1Zjc2MDk3MzExYjY3ZGZk
NzY4OTFiMTA5ODggaXMgdGhlIGZpcnN0IGJhZCBjb21taXQKY29tbWl0IGI3MzljOTk4Mjgw
MWU1Zjc2MDk3MzExYjY3ZGZkNzY4OTFiMTA5ODgKQXV0aG9yOiBKZXNzZSBCYXJuZXMgPGpi
YXJuZXNAdmlydHVvdXNnZWVrLm9yZz4KRGF0ZTogICBXZWQgTWF5IDI4IDEwOjIxOjE3IDIw
MTQgLTA3MDAKCiAgICBkcm06IHRha2UgbW9kZXNldCBsb2NrcyBhcm91bmQgaW5pdGlhbCBm
YiBoZWxwZXIgcHJvYmluZwogICAgCiAgICBEcml2ZXJzIG91Z2h0IHRvIGNvbXBsYWluIG90
aGVyd2lzZS4KICAgIAogICAgU2lnbmVkLW9mZi1ieTogSmVzc2UgQmFybmVzIDxqYmFybmVz
QHZpcnR1b3VzZ2Vlay5vcmc+Cgo6MDQwMDAwIDA0MDAwMCAwYzViNmMxNWRjYjdiOTJmM2Zh
ZmY4ODU3NjYzZDgwYjc4M2M5OTBlIDgzOGYyNzI3OTAxYzVlNzRkNGQyYTljZjVhYmVhN2Iy
YjQwY2M3NzEgTQlkcml2ZXJzCmJpc2VjdCBydW4gc3VjY2VzcwpQcmV2aW91cyBIRUFEIHBv
c2l0aW9uIHdhcyBiNzM5Yzk5Li4uIGRybTogdGFrZSBtb2Rlc2V0IGxvY2tzIGFyb3VuZCBp
bml0aWFsIGZiIGhlbHBlciBwcm9iaW5nCkhFQUQgaXMgbm93IGF0IDA3MWY5YzUuLi4gZHJt
L2k5MTUvdmx2OiBlbmFibGUgUFBHVFQKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUv
a3ZtL2kzODYtcmFuZGNvbmZpZy1jMS0wNjAyMTE0MC9saW51eC1kZXZlbDpkZXZlbC1ob3Vy
bHktMjAxNDA2MDIxMDowNzFmOWM1N2VlYTQ4NzYyODhiYTEyNTRjOWFjM2IwZjA3N2MyZGQ2
OmJpc2VjdC1saW51eDQKCjIwMTQtMDYtMDItMTM6NTA6NTEgMDcxZjljNTdlZWE0ODc2Mjg4
YmExMjU0YzlhYzNiMGYwNzdjMmRkNiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8g
L2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDAt
MDcxZjljNTdlZWE0ODc2Mjg4YmExMjU0YzlhYzNiMGYwNzdjMmRkNgpDaGVjayBmb3Iga2Vy
bmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA2MDIxMTQwLzA3MWY5YzU3ZWVh
NDg3NjI4OGJhMTI1NGM5YWMzYjBmMDc3YzJkZDYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1jMS0wNjAyMTE0
MC0wNzFmOWM1N2VlYTQ4NzYyODhiYTEyNTRjOWFjM2IwZjA3N2MyZGQ2CndhaXRpbmcgZm9y
IGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29u
ZmlnLWMxLTA2MDIxMTQwLTA3MWY5YzU3ZWVhNDg3NjI4OGJhMTI1NGM5YWMzYjBmMDc3YzJk
ZDYKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNjAyMTE0MC8wNzFmOWM1
N2VlYTQ4NzYyODhiYTEyNTRjOWFjM2IwZjA3N2MyZGQ2L3ZtbGludXotMy4xNS4wLXJjNS0w
MDA4Ni1nMDcxZjljNQoKMjAxNC0wNi0wMi0xMzo1NDo1MSBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAuLi4uLgkxCTQuCTYJOC4JMjcJNDgJNjAgU1VDQ0VTUwoKUHJldmlvdXMgSEVBRCBwb3Np
dGlvbiB3YXMgMDcxZjljNS4uLiBkcm0vaTkxNS92bHY6IGVuYWJsZSBQUEdUVApIRUFEIGlz
IG5vdyBhdCA1ZGJhMDI0Li4uIDBkYXkgaGVhZCBndWFyZCBmb3IgJ2RldmVsLWhvdXJseS0y
MDE0MDYwMjEwJwpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5k
Y29uZmlnLWMxLTA2MDIxMTQwL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDYwMjEw
OjVkYmEwMjRmZTg0YTQ5MWVjM2NhMTUxOTM5MjNmY2JiOTM4ZTY4Zjc6YmlzZWN0LWxpbnV4
NAogVEVTVCBGQUlMVVJFClsgICA2OC4wNTkwMDldIHNwaW5fbG9jay10b3J0dXJlOiBXcml0
ZXM6ICBUb3RhbDogMiAgTWF4L01pbjogMC8wICAgRmFpbDogMCAKWyAgMTI5LjE2MzE1Nl0g
c3Bpbl9sb2NrLXRvcnR1cmU6IFdyaXRlczogIFRvdGFsOiAyICBNYXgvTWluOiAwLzAgICBG
YWlsOiAwIApbICAxODkuMjI0NDY2XSBzcGluX2xvY2stdG9ydHVyZTogV3JpdGVzOiAgVG90
YWw6IDIgIE1heC9NaW46IDAvMCAgIEZhaWw6IDAgClsgIDI0Ni41NDI0MjZdIElORk86IHRh
c2sgc3dhcHBlcjoxIGJsb2NrZWQgZm9yIG1vcmUgdGhhbiAxMjAgc2Vjb25kcy4KWyAgMjQ2
LjU0MzQzN10gICAgICAgTm90IHRhaW50ZWQgMy4xNS4wLXJjOC0wMjE0OS1nNWRiYTAyNCAj
OQpbICAyNDYuNTQ0Mjk5XSAiZWNobyAwID4gL3Byb2Mvc3lzL2tlcm5lbC9odW5nX3Rhc2tf
dGltZW91dF9zZWNzIiBkaXNhYmxlcyB0aGlzIG1lc3NhZ2UuClsgIDI0Ni41NDU1MjVdIHN3
YXBwZXIgICAgICAgICBEIGQxYzI5YzI0ICA1OTQ0ICAgICAxICAgICAgMCAweDAwMDAwMDAw
ClsgIDI0Ni41NDY1NzldICBkMWMyOWM0OCAwMDAwMDA0NiAwMDAwMDAwMCBkMWMyOWMyNCBj
MTgzZmE2YyBjMmYyNzA2OCBkMWMyMjAwMCBjYjgxMDAzNApbICAyNDYuNTQ3OTIxXSAgYzJm
MjcwNjggY2I4MTAwMzQgYzJmMjcwNDAgYzJmMjcwNDAgZDFjMjljMWMgYzEwYmMyOWYgY2I4
MTAwMmMgYzJmMjcwNDAKWyAgMjQ2LjU0OTMzM10gIGQxYzI5YzJjIGMxMGJjMmUxIGNiODEw
MDJjIDAwMDAwMDAxIDAwMDAwMDAxIGMxMGJjYWY4IDAwMDAwMDAyIGMyZjI3MDQwClsgIDI0
Ni41NTA3MDhdIENhbGwgVHJhY2U6ClsgIDI0Ni41NTExNjZdICBbPGMxODNmYTZjPl0gPyBy
Yl9lcmFzZSsweDNkLzB4NTc2ClsgIDI0Ni41NjUwMjRdICBbPGMxMGJjMjlmPl0gPyBfX2Rl
cXVldWVfZW50aXR5KzB4NGQvMHg1ZgpbICAyNDYuNTY1ODEyXSAgWzxjMTBiYzJlMT5dID8g
c2V0X25leHRfZW50aXR5KzB4MzAvMHg2MwpbICAyNDYuNTY2NjM3XSAgWzxjMTBiY2FmOD5d
ID8gcGlja19uZXh0X3Rhc2tfZmFpcisweDI2Ny8weDI5YQpbICAyNDYuNTY3NTEzXSAgWzxj
MjVmMWYyNj5dIF9fc2NoZWR1bGUrMHg4ZmEvMHhhODIKWyAgMjQ2LjU2ODIyN10gIFs8YzI1
ZjIxZjM+XSBzY2hlZHVsZSsweDE0NS8weDE1NQpbICAyNDYuNTY4OTcxXSAgWzxjMjVmMjIy
ZD5dIHNjaGVkdWxlX3ByZWVtcHRfZGlzYWJsZWQrMHgyYS8weDRlClsgIDI0Ni41Njk4NDZd
ICBbPGMyNWYzOGRhPl0gbXV0ZXhfbG9ja19uZXN0ZWQrMHg0NzAvMHg4Y2QKWyAgMjQ2LjU3
MDY3M10gIFs8YzFhNDdmNjg+XSA/IGRybV9tb2Rlc2V0X2xvY2tfYWxsKzB4MjMvMHg4MApb
ICAyNDYuNTcxNTE4XSAgWzxjMWE0N2Y2OD5dID8gZHJtX21vZGVzZXRfbG9ja19hbGwrMHgy
My8weDgwClsgIDI0Ni41NzIzOThdICBbPGMxYTQ3ZjY4Pl0gZHJtX21vZGVzZXRfbG9ja19h
bGwrMHgyMy8weDgwClsgIDI0Ni41NzMyMTNdICBbPGMxYTMxN2I0Pl0gZHJtX2ZiX2hlbHBl
cl9pbml0aWFsX2NvbmZpZysweDJkMC8weDc4ZQpbICAyNDYuNTc0MTYwXSAgWzxjMTBjNDNl
Mz5dID8gZGVidWdfbXV0ZXhfdW5sb2NrKzB4MzFhLzB4M2NhClsgIDI0Ni41NzUwODZdICBb
PGMyNWY0NGNlPl0gPyBfbXV0ZXhfbG9ja19uZXN0X2xvY2srMHg3OTcvMHg4YzkKWyAgMjQ2
LjU3NTk4OF0gIFs8YzI1ZjVhOTM+XSA/IF9fbXV0ZXhfdW5sb2NrX3Nsb3dwYXRoKzB4MmVi
LzB4MzBmClsgIDI0Ni41NzY5MzJdICBbPGMxYTQ4MDI4Pl0gPyBkcm1fbW9kZXNldF91bmxv
Y2tfYWxsKzB4NjMvMHg3NgpbICAyNDYuNTc3ODQzXSAgWzxjMWNiMzlhNj5dIGNpcnJ1c19m
YmRldl9pbml0KzB4ZjgvMHgxMTUKWyAgMjQ2LjU3ODYzMl0gIFs8YzFjYjI4NjQ+XSBjaXJy
dXNfbW9kZXNldF9pbml0KzB4MmVlLzB4M2E5ClsgIDI0Ni41Nzk0NzRdICBbPGMxY2IwYjQx
Pl0gPyBjaXJydXNfZGV2aWNlX2luaXQrMHgxNTMvMHgxZTkKWyAgMjQ2LjU4MDI3MV0gIFs8
YzFjYjBlMzQ+XSBjaXJydXNfZHJpdmVyX2xvYWQrMHgxMzQvMHgxYzMKWyAgMjQ2LjU4MTEz
M10gIFs8YzFhNDEzMmM+XSBkcm1fZGV2X3JlZ2lzdGVyKzB4ZjAvMHgxZjQKWyAgMjQ2LjU4
MTkxNF0gIFs8YzFhNDNiZmY+XSBkcm1fZ2V0X3BjaV9kZXYrMHgyMDcvMHgzMzYKWyAgMjQ2
LjU4MjY3NF0gIFs8YzFjYjJjMzI+XSA/IGNpcnJ1c19raWNrX291dF9maXJtd2FyZV9mYisw
eDExYy8weDEzNwpbICAyNDYuNTgzNjc5XSAgWzxjMTFjYjdmNz5dID8ga2ZyZWUrMHgxNGUv
MHgxZDQKWyAgMjQ2LjU4NDM2MF0gIFs8YzFjYjJjOTk+XSBjaXJydXNfcGNpX3Byb2JlKzB4
NGMvMHg1ZQpbICAyNDYuNTg1MTM2XSAgWzxjMTg5OTFhYz5dIHBjaV9kZXZpY2VfcHJvYmUr
MHhkMC8weDFhNQpbICAyNDYuNTg1OTA1XSAgWzxjMTI3MWRlMz5dID8gc3lzZnNfY3JlYXRl
X2xpbmsrMHgyMC8weDMwClsgIDI0Ni41ODY3NDBdICBbPGMxZTE3NTNlPl0gZHJpdmVyX3By
b2JlX2RldmljZSsweDEzNy8weDNmZQpbICAyNDYuNTg3NjE1XSAgWzxjMWUxNzhhNT5dIF9f
ZHJpdmVyX2F0dGFjaCsweGEwLzB4ZjQKWyAgMjQ2LjU4ODMzNV0gIFs8YzFlMTQ3MzQ+XSBi
dXNfZm9yX2VhY2hfZGV2KzB4OTYvMHhmMwpbICAyNDYuNTg5MTU5XSAgWzxjMWUxNzAzYz5d
IGRyaXZlcl9hdHRhY2grMHgyNS8weDM1ClsgIDI0Ni41ODk5MDZdICBbPGMxZTE3ODA1Pl0g
PyBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4M2ZlLzB4M2ZlClsgIDI0Ni42MDM4NzNdICBbPGMx
ZTE1NjUwPl0gYnVzX2FkZF9kcml2ZXIrMHgxNjEvMHgzODkKWyAgMjQ2LjYwNDY3Nl0gIFs8
YzFlMTg4MzE+XSBkcml2ZXJfcmVnaXN0ZXIrMHgxNmUvMHgxZjYKWyAgMjQ2LjYwNTQ2NV0g
IFs8YzEwY2MwMDE+XSA/IF9fcmF3X3NwaW5fbG9ja19pbml0KzB4NDkvMHg3OApbICAyNDYu
NjA2MjY3XSAgWzxjMTg5OGUyNj5dIF9fcGNpX3JlZ2lzdGVyX2RyaXZlcisweDYxLzB4NzIK
WyAgMjQ2LjYwNzEzOF0gIFs8YzFhNDNkY2I+XSBkcm1fcGNpX2luaXQrMHg5ZC8weDE4Ywpb
ICAyNDYuNjA3ODk1XSAgWzxjMzNiMTRhNj5dID8gZnRyYWNlX2RlZmluZV9maWVsZHNfaTkx
NV9nZW1fb2JqZWN0X2NyZWF0ZSsweGE5LzB4YTkKWyAgMjQ2LjYwOTAyOF0gIFs8YzMzYjE0
ZGQ+XSBjaXJydXNfaW5pdCsweDM3LzB4NGYKWyAgMjQ2LjYwOTc2Ml0gIFs8YzMzMzQ1ZmI+
XSBkb19vbmVfaW5pdGNhbGwrMHhmNC8weDI2YwpbICAyNDYuNjEwNTQ4XSAgWzxjMzMzMzY4
ND5dID8gcmVwYWlyX2Vudl9zdHJpbmcrMHgzMi8weGQzClsgIDI0Ni42MTEzODFdICBbPGMx
MDlmOTkyPl0gPyBwYXJzZV9hcmdzKzB4MzI4LzB4NGNkClsgIDI0Ni42MTIxMDhdICBbPGMz
MzM0YzA0Pl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHg0OTEvMHg2MmEKWyAgMjQ2LjYxMzAx
NV0gIFs8YzMzMzM2NTI+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4MTJiLzB4MTJiClsgIDI0Ni42
MTM4MzNdICBbPGMyNTk3MTNlPl0ga2VybmVsX2luaXQrMHgxOS8weDFmNgpbICAyNDYuNjE0
NTQ4XSAgWzxjMTBiNTA1ZD5dID8gc2NoZWR1bGVfdGFpbCsweDFhLzB4YTkKWyAgMjQ2LjYx
NTMyOV0gIFs8YzI1ZmI2NjA+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MjAvMHgzMApb
ICAyNDYuNjE2MTgzXSAgWzxjMjU5NzEyNT5dID8gcmVzdF9pbml0KzB4MWRkLzB4MWRkClsg
IDI0Ni42Mjk5ODhdIDUgbG9ja3MgaGVsZCBieSBzd2FwcGVyLzE6ClsgIDI0Ni42MzA1ODld
ICAjMDogICgmZGV2LT5tdXRleCl7Li4uLi4ufSwgYXQ6IFs8YzFlMTY3OTk+XSBkZXZpY2Vf
bG9jaysweDFiLzB4MmIKWyAgMjQ2LjYzMTg2OV0gICMxOiAgKCZkZXYtPm11dGV4KXsuLi4u
Li59LCBhdDogWzxjMWUxNjc5OT5dIGRldmljZV9sb2NrKzB4MWIvMHgyYgpbICAyNDYuNjMz
MTI0XSAgIzI6ICAoZHJtX2dsb2JhbF9tdXRleCl7Li4uLi4ufSwgYXQ6IFs8YzFhNDEyNjA+
XSBkcm1fZGV2X3JlZ2lzdGVyKzB4MjQvMHgxZjQKWyAgMjQ2LjYzNDUyOF0gICMzOiAgKCZk
ZXYtPm1vZGVfY29uZmlnLm11dGV4KXsuLi4uLi59LCBhdDogWzxjMWEzMTc5Zj5dIGRybV9m
Yl9oZWxwZXJfaW5pdGlhbF9jb25maWcrMHgyYmIvMHg3OGUKWyAgMjQ2LjYzNjIwM10gICM0
OiAgKCZkZXYtPm1vZGVfY29uZmlnLm11dGV4KXsuLi4uLi59LCBhdDogWzxjMWE0N2Y2OD5d
IGRybV9tb2Rlc2V0X2xvY2tfYWxsKzB4MjMvMHg4MApbICAyNDYuNjM3NzQ4XSBzZW5kaW5n
IE5NSSB0byBhbGwgQ1BVczoKWyAgMjQ2LjYzODM0OF0gTk1JIGJhY2t0cmFjZSBmb3IgY3B1
IDAKWyAgMjQ2LjYzODg5Ml0gQ1BVOiAwIFBJRDogOCBDb21tOiBraHVuZ3Rhc2tkIE5vdCB0
YWludGVkIDMuMTUuMC1yYzgtMDIxNDktZzVkYmEwMjQgIzkKWyAgMjQ2LjY0MDA2Nl0gdGFz
azogZDFkZDA0MTAgdGk6IGQxZGY4MDAwIHRhc2sudGk6IGQxZGY4MDAwClsgIDI0Ni42NDA4
NTRdIEVJUDogMDA2MDpbPGMxMDQ1N2M2Pl0gRUZMQUdTOiAwMDAwMDA0NiBDUFU6IDAKWyAg
MjQ2LjY0MDg1NF0gRUlQIGlzIGF0IG5hdGl2ZV9hcGljX21lbV93cml0ZSsweDIwLzB4MzAK
WyAgMjQ2LjY0MDg1NF0gRUFYOiBmZmZmYjMwMCBFQlg6IDAwMDAwMjAxIEVDWDogZmZmZmYw
MDAgRURYOiAwMDAwMGMwMApbICAyNDYuNjQwODU0XSBFU0k6IDAwMDAwMDAyIEVESTogMDEw
MDAwMDAgRUJQOiBkMWRmOWU5YyBFU1A6IGQxZGY5ZTljClsgIDI0Ni42NDA4NTRdICBEUzog
MDA3YiBFUzogMDA3YiBGUzogMDAwMCBHUzogMDAwMCBTUzogMDA2OApbICAyNDYuNjQwODU0
XSBDUjA6IDgwMDUwMDNiIENSMjogMDAwMDAwMDAgQ1IzOiAwMzQzZTAwMCBDUjQ6IDAwMDAw
NmQwClsgIDI0Ni42NDA4NTRdIFN0YWNrOgpbICAyNDYuNjQwODU0XSAgZDFkZjllYjQgYzEw
NDU5NmMgMDAwMDA4MDAgMDAwMDAyNDYgMDAwMDAwMDEgMDAwMDAwMDAgZDFkZjllZDAgYzEw
NDVlYTIKWyAgMjQ2LjY0MDg1NF0gIDAwMDAwMDAyIDAwMDAwMDAwIDAwMDAwMDAyIGQxYzIy
MDAwIGQxYzIyMDAwIGQxZGY5ZWQ4IGMxMDQ1ZWZlIGQxZGY5ZWU4ClsgIDI0Ni42NDA4NTRd
ICBjMTA0NjFkZCBjMmQ1Mzg3NyAwMDAwMDAwMiBkMWRmOWYzMCBjMTExNTVjNSBjMmQ2MTFj
MyBjMzQ3NzAzNCBjMmVlYzQ1NgpbICAyNDYuNjQwODU0XSBDYWxsIFRyYWNlOgpbICAyNDYu
NjQwODU0XSAgWzxjMTA0NTk2Yz5dIF9fZGVmYXVsdF9zZW5kX0lQSV9kZXN0X2ZpZWxkKzB4
ZWMvMHgxMDAKWyAgMjQ2LjY0MDg1NF0gIFs8YzEwNDVlYTI+XSBkZWZhdWx0X3NlbmRfSVBJ
X21hc2tfbG9naWNhbCsweDE2Yy8weDE3ZApbICAyNDYuNjQwODU0XSAgWzxjMTA0NWVmZT5d
IGRlZmF1bHRfc2VuZF9JUElfYWxsKzB4MzgvMHg5NApbICAyNDYuNjQwODU0XSAgWzxjMTA0
NjFkZD5dIGFyY2hfdHJpZ2dlcl9hbGxfY3B1X2JhY2t0cmFjZSsweGM1LzB4MWI4ClsgIDI0
Ni42NDA4NTRdICBbPGMxMTE1NWM1Pl0gd2F0Y2hkb2crMHg1NWQvMHg2MWEKWyAgMjQ2LjY0
MDg1NF0gIFs8YzExMTUwNjg+XSA/IHJjdV9yZWFkX2xvY2srMHg4MS8weDgxClsgIDI0Ni42
NDA4NTRdICBbPGMxMGEyODQyPl0ga3RocmVhZCsweDExNS8weDEyOApbICAyNDYuNjQwODU0
XSAgWzxjMTBjODJiMz5dID8gbG9ja19yZWxlYXNlKzB4M2NhLzB4NDhhClsgIDI0Ni42NDA4
NTRdICBbPGMyNWZiNjYwPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDIwLzB4MzAKWyAg
MjQ2LjY0MDg1NF0gIFs8YzEwYTI3MmQ+XSA/IF9fa3RocmVhZF91bnBhcmsrMHg5Yi8weDli
ClsgIDI0Ni42NDA4NTRdIENvZGU6IDgzIDE1IGJjIDNiIDQ2IGMzIDAwIDg5IGM4IDVkIGMz
IDU1IDg5IGU1IDgzIDA1IGQwIDNiIDQ2IGMzIDAxIDgzIDE1IGQ0IDNiIDQ2IGMzIDAwIDhi
IDBkIGI0IDFlIGYxIGMyIDhkIDg0IDA4IDAwIGMwIGZmIGZmIDg5IDEwIDw4Mz4gMDUgZDgg
M2IgNDYgYzMgMDEgODMgMTUgZGMgM2IgNDYgYzMgMDAgNWQgYzMgNTUgODkgZTUgMDkgYzgK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDAvNWRiYTAyNGZlODRhNDkxZWMz
Y2ExNTE5MzkyM2ZjYmI5MzhlNjhmNy9kbWVzZy15b2N0by1pdmI0Mi0yNzoyMDE0MDYwMjEy
MDQ0MjppMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDA6My4xNS4wLXJjOC0wMjE0OS1nNWRi
YTAyNDo5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA2MDIxMTQwLzVkYmEwMjRmZTg0
YTQ5MWVjM2NhMTUxOTM5MjNmY2JiOTM4ZTY4ZjcvZG1lc2ctcXVhbnRhbC1pdmI0NC05ODoy
MDE0MDYwMjEyMDQzMjppMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDA6My4xNS4wLXJjOC0w
MjE0OS1nNWRiYTAyNDo5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA2MDIxMTQwLzVk
YmEwMjRmZTg0YTQ5MWVjM2NhMTUxOTM5MjNmY2JiOTM4ZTY4ZjcvZG1lc2cteW9jdG8taXZi
NDQtMTI3OjIwMTQwNjAyMTIwNDI2OmkzODYtcmFuZGNvbmZpZy1jMS0wNjAyMTE0MDozLjE1
LjAtcmM4LTAyMTQ5LWc1ZGJhMDI0OjkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDYw
MjExNDAvNWRiYTAyNGZlODRhNDkxZWMzY2ExNTE5MzkyM2ZjYmI5MzhlNjhmNy9kbWVzZy15
b2N0by1pdmI0NC0xNToyMDE0MDYwMjEyMDQyNzppMzg2LXJhbmRjb25maWctYzEtMDYwMjEx
NDA6My4xNS4wLXJjOC0wMjE0OS1nNWRiYTAyNDo5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWMxLTA2MDIxMTQwLzVkYmEwMjRmZTg0YTQ5MWVjM2NhMTUxOTM5MjNmY2JiOTM4ZTY4Zjcv
ZG1lc2ctcXVhbnRhbC1pdmI0My05ODoyMDE0MDYwMjEyMDQzMzppMzg2LXJhbmRjb25maWct
YzEtMDYwMjExNDA6My4xNS4wLXJjOC0wMjE0OS1nNWRiYTAyNDo5Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWMxLTA2MDIxMTQwLzVkYmEwMjRmZTg0YTQ5MWVjM2NhMTUxOTM5MjNmY2Ji
OTM4ZTY4ZjcvZG1lc2cteW9jdG8taXZiNDQtMzk6MjAxNDA2MDIxMTUwMzI6aTM4Ni1yYW5k
Y29uZmlnLWMxLTA2MDIxMTQwOjMuMTUuMC1yYzgtMDIxNDktZzVkYmEwMjQ6OQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1jMS0wNjAyMTE0MC81ZGJhMDI0ZmU4NGE0OTFlYzNjYTE1MTkz
OTIzZmNiYjkzOGU2OGY3L2RtZXNnLXlvY3RvLWl2YjQ0LTI6MjAxNDA2MDIxMjA0MDY6aTM4
Ni1yYW5kY29uZmlnLWMxLTA2MDIxMTQwOjMuMTUuMC1yYzgtMDIxNDktZzVkYmEwMjQ6OQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNjAyMTE0MC81ZGJhMDI0ZmU4NGE0OTFlYzNj
YTE1MTkzOTIzZmNiYjkzOGU2OGY3L2RtZXNnLXlvY3RvLWl2YjQzLTcxOjIwMTQwNjAyMTIw
NDUwOmkzODYtcmFuZGNvbmZpZy1jMS0wNjAyMTE0MDozLjE1LjAtcmM4LTAyMTQ5LWc1ZGJh
MDI0OjkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDAvNWRiYTAyNGZlODRh
NDkxZWMzY2ExNTE5MzkyM2ZjYmI5MzhlNjhmNy9kbWVzZy1xdWFudGFsLWl2YjQ0LTc4OjIw
MTQwNjAyMTIwNDMyOmkzODYtcmFuZGNvbmZpZy1jMS0wNjAyMTE0MDozLjE1LjAtcmM4LTAy
MTQ5LWc1ZGJhMDI0OjkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDAvNWRi
YTAyNGZlODRhNDkxZWMzY2ExNTE5MzkyM2ZjYmI5MzhlNjhmNy9kbWVzZy15b2N0by1pdmI0
NC04MDoyMDE0MDYwMjExNTAyNzppMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDA6My4xNS4w
LXJjOC0wMjE0OS1nNWRiYTAyNDo5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA2MDIx
MTQwLzVkYmEwMjRmZTg0YTQ5MWVjM2NhMTUxOTM5MjNmY2JiOTM4ZTY4ZjcvZG1lc2cteW9j
dG8taXZiNDEtMjc6MjAxNDA2MDIxMjA0MzU6aTM4Ni1yYW5kY29uZmlnLWMxLTA2MDIxMTQw
OjMuMTUuMC1yYzgtMDIxNDktZzVkYmEwMjQ6OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1j
MS0wNjAyMTE0MC81ZGJhMDI0ZmU4NGE0OTFlYzNjYTE1MTkzOTIzZmNiYjkzOGU2OGY3L2Rt
ZXNnLXF1YW50YWwtaXZiNDQtNjc6MjAxNDA2MDIxMjA0MzI6aTM4Ni1yYW5kY29uZmlnLWMx
LTA2MDIxMTQwOjMuMTUuMC1yYzgtMDIxNDktZzVkYmEwMjQ6OQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1jMS0wNjAyMTE0MC81ZGJhMDI0ZmU4NGE0OTFlYzNjYTE1MTkzOTIzZmNiYjkz
OGU2OGY3L2RtZXNnLXF1YW50YWwtaXZiNDQtMTU6MjAxNDA2MDIxMTUwMjc6aTM4Ni1yYW5k
Y29uZmlnLWMxLTA2MDIxMTQwOjMuMTUuMC1yYzgtMDIxNDktZzVkYmEwMjQ6OQowOjEzOjEz
IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpIRUFEIGlzIG5vdyBhdCA1ZGJhMDI0IDBk
YXkgaGVhZCBndWFyZCBmb3IgJ2RldmVsLWhvdXJseS0yMDE0MDYwMjEwJwoKPT09PT09PT09
IHVwc3RyZWFtID09PT09PT09PQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA1ZGJhMDI0
Li4uIDBkYXkgaGVhZCBndWFyZCBmb3IgJ2RldmVsLWhvdXJseS0yMDE0MDYwMjEwJwpIRUFE
IGlzIG5vdyBhdCBmYWQwMWU4Li4uIExpbnV4IDMuMTUtcmM4CmxzIC1hIC9rYnVpbGQtdGVz
dHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDAvbGludXM6bWFz
dGVyOmZhZDAxZTg2NmFmZGJlMDFhMWYzZWMwNmEzOWMzYThiOWUxOTcwMTQ6YmlzZWN0LWxp
bnV4NAoKMjAxNC0wNi0wMi0xNDowMTo1NSBmYWQwMWU4NjZhZmRiZTAxYTFmM2VjMDZhMzlj
M2E4YjllMTk3MDE0IHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA2MDIxMTQw
L2ZhZDAxZTg2NmFmZGJlMDFhMWYzZWMwNmEzOWMzYThiOWUxOTcwMTQvdm1saW51ei0zLjE1
LjAtcmM4CgoyMDE0LTA2LTAyLTE0OjAxOjU1IGRldGVjdGluZyBib290IHN0YXRlIC4uLi4u
Li4uLgkzNAk0OQk1NQk1OAk2MCBTVUNDRVNTCgoKPT09PT09PT09IGxpbnV4LW5leHQgPT09
PT09PT09CkZyb20gZ2l0Oi8vZ2l0bWlycm9yL25leHQKICogW25ldyBicmFuY2hdICAgICAg
YWtwbSAgICAgICAtPiBuZXh0L2FrcG0KICogW25ldyBicmFuY2hdICAgICAgYWtwbS1iYXNl
ICAtPiBuZXh0L2FrcG0tYmFzZQogKiBbbmV3IGJyYW5jaF0gICAgICBtYXN0ZXIgICAgIC0+
IG5leHQvbWFzdGVyCiAqIFtuZXcgYnJhbmNoXSAgICAgIHN0YWJsZSAgICAgLT4gbmV4dC9z
dGFibGUKRnJvbSBnaXQ6Ly9naXRtaXJyb3IvbmV4dAogKiBbbmV3IHRhZ10gICAgICAgICBu
ZXh0LTIwMTMwMzIwIC0+IG5leHQtMjAxMzAzMjAKICogW25ldyB0YWddICAgICAgICAgbmV4
dC0yMDEzMDMyMSAtPiBuZXh0LTIwMTMwMzIxCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQt
MjAxMzAzMjIgLT4gbmV4dC0yMDEzMDMyMgogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIw
MTMwMzI1IC0+IG5leHQtMjAxMzAzMjUKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEz
MDMyNiAtPiBuZXh0LTIwMTMwMzI2CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzAz
MjcgLT4gbmV4dC0yMDEzMDMyNwogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwMzI4
IC0+IG5leHQtMjAxMzAzMjgKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDQwMiAt
PiBuZXh0LTIwMTMwNDAyCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA0MDMgLT4g
bmV4dC0yMDEzMDQwMwogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwNDA0IC0+IG5l
eHQtMjAxMzA0MDQKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDQwNSAtPiBuZXh0
LTIwMTMwNDA1CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA0MDggLT4gbmV4dC0y
MDEzMDQwOAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwNDA5IC0+IG5leHQtMjAx
MzA0MDkKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDQxMCAtPiBuZXh0LTIwMTMw
NDEwCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA0MTEgLT4gbmV4dC0yMDEzMDQx
MQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwNDEyIC0+IG5leHQtMjAxMzA0MTIK
ICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDQxNSAtPiBuZXh0LTIwMTMwNDE1CiAq
IFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA0MTYgLT4gbmV4dC0yMDEzMDQxNgogKiBb
bmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwNDE3IC0+IG5leHQtMjAxMzA0MTcKICogW25l
dyB0YWddICAgICAgICAgbmV4dC0yMDEzMDQxOCAtPiBuZXh0LTIwMTMwNDE4CiAqIFtuZXcg
dGFnXSAgICAgICAgIG5leHQtMjAxMzA0MTkgLT4gbmV4dC0yMDEzMDQxOQogKiBbbmV3IHRh
Z10gICAgICAgICBuZXh0LTIwMTMwNDIyIC0+IG5leHQtMjAxMzA0MjIKICogW25ldyB0YWdd
ICAgICAgICAgbmV4dC0yMDEzMDQyMyAtPiBuZXh0LTIwMTMwNDIzCiAqIFtuZXcgdGFnXSAg
ICAgICAgIG5leHQtMjAxMzA0MjQgLT4gbmV4dC0yMDEzMDQyNAogKiBbbmV3IHRhZ10gICAg
ICAgICBuZXh0LTIwMTMwNDI2IC0+IG5leHQtMjAxMzA0MjYKICogW25ldyB0YWddICAgICAg
ICAgbmV4dC0yMDEzMDQyOSAtPiBuZXh0LTIwMTMwNDI5CiAqIFtuZXcgdGFnXSAgICAgICAg
IG5leHQtMjAxMzA0MzAgLT4gbmV4dC0yMDEzMDQzMAogKiBbbmV3IHRhZ10gICAgICAgICBu
ZXh0LTIwMTMwNTAxIC0+IG5leHQtMjAxMzA1MDEKICogW25ldyB0YWddICAgICAgICAgbmV4
dC0yMDEzMDUwMiAtPiBuZXh0LTIwMTMwNTAyCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQt
MjAxMzA1MDMgLT4gbmV4dC0yMDEzMDUwMwogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIw
MTMwNTA2IC0+IG5leHQtMjAxMzA1MDYKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEz
MDUwNyAtPiBuZXh0LTIwMTMwNTA3CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA1
MDggLT4gbmV4dC0yMDEzMDUwOAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwNTA5
IC0+IG5leHQtMjAxMzA1MDkKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDUxMCAt
PiBuZXh0LTIwMTMwNTEwCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA1MTMgLT4g
bmV4dC0yMDEzMDUxMwogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwNTE0IC0+IG5l
eHQtMjAxMzA1MTQKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDUxNSAtPiBuZXh0
LTIwMTMwNTE1CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA1MTYgLT4gbmV4dC0y
MDEzMDUxNgogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwNTE3IC0+IG5leHQtMjAx
MzA1MTcKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDUyMCAtPiBuZXh0LTIwMTMw
NTIwCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA1MjEgLT4gbmV4dC0yMDEzMDUy
MQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwNTIyIC0+IG5leHQtMjAxMzA1MjIK
ICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDUyMyAtPiBuZXh0LTIwMTMwNTIzCiAq
IFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA1MjcgLT4gbmV4dC0yMDEzMDUyNwogKiBb
bmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwNTI4IC0+IG5leHQtMjAxMzA1MjgKICogW25l
dyB0YWddICAgICAgICAgbmV4dC0yMDEzMDUyOSAtPiBuZXh0LTIwMTMwNTI5CiAqIFtuZXcg
dGFnXSAgICAgICAgIG5leHQtMjAxMzA1MzAgLT4gbmV4dC0yMDEzMDUzMAogKiBbbmV3IHRh
Z10gICAgICAgICBuZXh0LTIwMTMwNTMxIC0+IG5leHQtMjAxMzA1MzEKICogW25ldyB0YWdd
ICAgICAgICAgbmV4dC0yMDEzMDYwMyAtPiBuZXh0LTIwMTMwNjAzCiAqIFtuZXcgdGFnXSAg
ICAgICAgIG5leHQtMjAxMzA2MDQgLT4gbmV4dC0yMDEzMDYwNAogKiBbbmV3IHRhZ10gICAg
ICAgICBuZXh0LTIwMTMwNjA1IC0+IG5leHQtMjAxMzA2MDUKICogW25ldyB0YWddICAgICAg
ICAgbmV4dC0yMDEzMDYwNiAtPiBuZXh0LTIwMTMwNjA2CiAqIFtuZXcgdGFnXSAgICAgICAg
IG5leHQtMjAxMzA2MDcgLT4gbmV4dC0yMDEzMDYwNwogKiBbbmV3IHRhZ10gICAgICAgICBu
ZXh0LTIwMTMwNjE3IC0+IG5leHQtMjAxMzA2MTcKICogW25ldyB0YWddICAgICAgICAgbmV4
dC0yMDEzMDYxOCAtPiBuZXh0LTIwMTMwNjE4CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQt
MjAxMzA2MTkgLT4gbmV4dC0yMDEzMDYxOQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIw
MTMwNjIwIC0+IG5leHQtMjAxMzA2MjAKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEz
MDYyMSAtPiBuZXh0LTIwMTMwNjIxCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA2
MjQgLT4gbmV4dC0yMDEzMDYyNAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwNjI1
IC0+IG5leHQtMjAxMzA2MjUKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDYyNiAt
PiBuZXh0LTIwMTMwNjI2CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA2MjcgLT4g
bmV4dC0yMDEzMDYyNwogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwNjI4IC0+IG5l
eHQtMjAxMzA2MjgKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDcwMSAtPiBuZXh0
LTIwMTMwNzAxCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA3MDIgLT4gbmV4dC0y
MDEzMDcwMgogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwNzAzIC0+IG5leHQtMjAx
MzA3MDMKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDcwNCAtPiBuZXh0LTIwMTMw
NzA0CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA3MDUgLT4gbmV4dC0yMDEzMDcw
NQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwNzA4IC0+IG5leHQtMjAxMzA3MDgK
ICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDcwOSAtPiBuZXh0LTIwMTMwNzA5CiAq
IFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA3MTAgLT4gbmV4dC0yMDEzMDcxMAogKiBb
bmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwNzExIC0+IG5leHQtMjAxMzA3MTEKICogW25l
dyB0YWddICAgICAgICAgbmV4dC0yMDEzMDcxMiAtPiBuZXh0LTIwMTMwNzEyCiAqIFtuZXcg
dGFnXSAgICAgICAgIG5leHQtMjAxMzA3MTUgLT4gbmV4dC0yMDEzMDcxNQogKiBbbmV3IHRh
Z10gICAgICAgICBuZXh0LTIwMTMwNzE2IC0+IG5leHQtMjAxMzA3MTYKICogW25ldyB0YWdd
ICAgICAgICAgbmV4dC0yMDEzMDcxNyAtPiBuZXh0LTIwMTMwNzE3CiAqIFtuZXcgdGFnXSAg
ICAgICAgIG5leHQtMjAxMzA3MTggLT4gbmV4dC0yMDEzMDcxOAogKiBbbmV3IHRhZ10gICAg
ICAgICBuZXh0LTIwMTMwNzE5IC0+IG5leHQtMjAxMzA3MTkKICogW25ldyB0YWddICAgICAg
ICAgbmV4dC0yMDEzMDcyMiAtPiBuZXh0LTIwMTMwNzIyCiAqIFtuZXcgdGFnXSAgICAgICAg
IG5leHQtMjAxMzA3MjMgLT4gbmV4dC0yMDEzMDcyMwogKiBbbmV3IHRhZ10gICAgICAgICBu
ZXh0LTIwMTMwNzI0IC0+IG5leHQtMjAxMzA3MjQKICogW25ldyB0YWddICAgICAgICAgbmV4
dC0yMDEzMDcyNSAtPiBuZXh0LTIwMTMwNzI1CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQt
MjAxMzA3MjYgLT4gbmV4dC0yMDEzMDcyNgogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIw
MTMwNzI5IC0+IG5leHQtMjAxMzA3MjkKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEz
MDczMCAtPiBuZXh0LTIwMTMwNzMwCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA3
MzEgLT4gbmV4dC0yMDEzMDczMQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwODAx
IC0+IG5leHQtMjAxMzA4MDEKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDgwMiAt
PiBuZXh0LTIwMTMwODAyCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA4MDUgLT4g
bmV4dC0yMDEzMDgwNQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwODA2IC0+IG5l
eHQtMjAxMzA4MDYKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDgwNyAtPiBuZXh0
LTIwMTMwODA3CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA4MDggLT4gbmV4dC0y
MDEzMDgwOAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwODA5IC0+IG5leHQtMjAx
MzA4MDkKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDgxMiAtPiBuZXh0LTIwMTMw
ODEyCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA4MTMgLT4gbmV4dC0yMDEzMDgx
MwogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwODE0IC0+IG5leHQtMjAxMzA4MTQK
ICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDgxNSAtPiBuZXh0LTIwMTMwODE1CiAq
IFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA4MTYgLT4gbmV4dC0yMDEzMDgxNgogKiBb
bmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwODE5IC0+IG5leHQtMjAxMzA4MTkKICogW25l
dyB0YWddICAgICAgICAgbmV4dC0yMDEzMDgyMCAtPiBuZXh0LTIwMTMwODIwCiAqIFtuZXcg
dGFnXSAgICAgICAgIG5leHQtMjAxMzA4MjEgLT4gbmV4dC0yMDEzMDgyMQogKiBbbmV3IHRh
Z10gICAgICAgICBuZXh0LTIwMTMwODIyIC0+IG5leHQtMjAxMzA4MjIKICogW25ldyB0YWdd
ICAgICAgICAgbmV4dC0yMDEzMDgyNyAtPiBuZXh0LTIwMTMwODI3CiAqIFtuZXcgdGFnXSAg
ICAgICAgIG5leHQtMjAxMzA4MjggLT4gbmV4dC0yMDEzMDgyOAogKiBbbmV3IHRhZ10gICAg
ICAgICBuZXh0LTIwMTMwODI5IC0+IG5leHQtMjAxMzA4MjkKICogW25ldyB0YWddICAgICAg
ICAgbmV4dC0yMDEzMDgzMCAtPiBuZXh0LTIwMTMwODMwCiAqIFtuZXcgdGFnXSAgICAgICAg
IG5leHQtMjAxMzA5MDIgLT4gbmV4dC0yMDEzMDkwMgogKiBbbmV3IHRhZ10gICAgICAgICBu
ZXh0LTIwMTMwOTAzIC0+IG5leHQtMjAxMzA5MDMKICogW25ldyB0YWddICAgICAgICAgbmV4
dC0yMDEzMDkwNCAtPiBuZXh0LTIwMTMwOTA0CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQt
MjAxMzA5MDUgLT4gbmV4dC0yMDEzMDkwNQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIw
MTMwOTA2IC0+IG5leHQtMjAxMzA5MDYKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEz
MDkwOSAtPiBuZXh0LTIwMTMwOTA5CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA5
MTAgLT4gbmV4dC0yMDEzMDkxMAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwOTEx
IC0+IG5leHQtMjAxMzA5MTEKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDkxMiAt
PiBuZXh0LTIwMTMwOTEyCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA5MTMgLT4g
bmV4dC0yMDEzMDkxMwogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwOTE2IC0+IG5l
eHQtMjAxMzA5MTYKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDkxNyAtPiBuZXh0
LTIwMTMwOTE3CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA5MTggLT4gbmV4dC0y
MDEzMDkxOAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwOTE5IC0+IG5leHQtMjAx
MzA5MTkKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDkyMCAtPiBuZXh0LTIwMTMw
OTIwCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA5MjMgLT4gbmV4dC0yMDEzMDky
MwogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwOTI0IC0+IG5leHQtMjAxMzA5MjQK
ICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMDkyNSAtPiBuZXh0LTIwMTMwOTI1CiAq
IFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzA5MjYgLT4gbmV4dC0yMDEzMDkyNgogKiBb
bmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMwOTI3IC0+IG5leHQtMjAxMzA5MjcKICogW25l
dyB0YWddICAgICAgICAgbmV4dC0yMDEzMTAyOSAtPiBuZXh0LTIwMTMxMDI5CiAqIFtuZXcg
dGFnXSAgICAgICAgIG5leHQtMjAxMzEwMzAgLT4gbmV4dC0yMDEzMTAzMAogKiBbbmV3IHRh
Z10gICAgICAgICBuZXh0LTIwMTMxMDMxIC0+IG5leHQtMjAxMzEwMzEKICogW25ldyB0YWdd
ICAgICAgICAgbmV4dC0yMDEzMTEwMSAtPiBuZXh0LTIwMTMxMTAxCiAqIFtuZXcgdGFnXSAg
ICAgICAgIG5leHQtMjAxMzExMDQgLT4gbmV4dC0yMDEzMTEwNAogKiBbbmV3IHRhZ10gICAg
ICAgICBuZXh0LTIwMTMxMTA1IC0+IG5leHQtMjAxMzExMDUKICogW25ldyB0YWddICAgICAg
ICAgbmV4dC0yMDEzMTEwNiAtPiBuZXh0LTIwMTMxMTA2CiAqIFtuZXcgdGFnXSAgICAgICAg
IG5leHQtMjAxMzExMDcgLT4gbmV4dC0yMDEzMTEwNwogKiBbbmV3IHRhZ10gICAgICAgICBu
ZXh0LTIwMTMxMTA4IC0+IG5leHQtMjAxMzExMDgKICogW25ldyB0YWddICAgICAgICAgbmV4
dC0yMDEzMTExMSAtPiBuZXh0LTIwMTMxMTExCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQt
MjAxMzExMTIgLT4gbmV4dC0yMDEzMTExMgogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIw
MTMxMTEzIC0+IG5leHQtMjAxMzExMTMKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEz
MTExNCAtPiBuZXh0LTIwMTMxMTE0CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzEx
MTUgLT4gbmV4dC0yMDEzMTExNQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMxMTE4
IC0+IG5leHQtMjAxMzExMTgKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMTExOSAt
PiBuZXh0LTIwMTMxMTE5CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzExMjAgLT4g
bmV4dC0yMDEzMTEyMAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMxMTIxIC0+IG5l
eHQtMjAxMzExMjEKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMTEyMiAtPiBuZXh0
LTIwMTMxMTIyCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzExMjUgLT4gbmV4dC0y
MDEzMTEyNQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMxMTI2IC0+IG5leHQtMjAx
MzExMjYKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMTEyNyAtPiBuZXh0LTIwMTMx
MTI3CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzExMjggLT4gbmV4dC0yMDEzMTEy
OAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMxMTI5IC0+IG5leHQtMjAxMzExMjkK
ICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEzMTIwMiAtPiBuZXh0LTIwMTMxMjAyCiAq
IFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzEyMDMgLT4gbmV4dC0yMDEzMTIwMwogKiBb
bmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTMxMjA0IC0+IG5leHQtMjAxMzEyMDQKICogW25l
dyB0YWddICAgICAgICAgbmV4dC0yMDEzMTIwNSAtPiBuZXh0LTIwMTMxMjA1CiAqIFtuZXcg
dGFnXSAgICAgICAgIG5leHQtMjAxMzEyMDYgLT4gbmV4dC0yMDEzMTIwNgogKiBbbmV3IHRh
Z10gICAgICAgICBuZXh0LTIwMTMxMjA5IC0+IG5leHQtMjAxMzEyMDkKICogW25ldyB0YWdd
ICAgICAgICAgbmV4dC0yMDEzMTIxMCAtPiBuZXh0LTIwMTMxMjEwCiAqIFtuZXcgdGFnXSAg
ICAgICAgIG5leHQtMjAxMzEyMTEgLT4gbmV4dC0yMDEzMTIxMQogKiBbbmV3IHRhZ10gICAg
ICAgICBuZXh0LTIwMTMxMjEyIC0+IG5leHQtMjAxMzEyMTIKICogW25ldyB0YWddICAgICAg
ICAgbmV4dC0yMDEzMTIxMyAtPiBuZXh0LTIwMTMxMjEzCiAqIFtuZXcgdGFnXSAgICAgICAg
IG5leHQtMjAxMzEyMTYgLT4gbmV4dC0yMDEzMTIxNgogKiBbbmV3IHRhZ10gICAgICAgICBu
ZXh0LTIwMTMxMjE3IC0+IG5leHQtMjAxMzEyMTcKICogW25ldyB0YWddICAgICAgICAgbmV4
dC0yMDEzMTIxOCAtPiBuZXh0LTIwMTMxMjE4CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQt
MjAxMzEyMTkgLT4gbmV4dC0yMDEzMTIxOQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIw
MTMxMjIwIC0+IG5leHQtMjAxMzEyMjAKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDEz
MTIyMyAtPiBuZXh0LTIwMTMxMjIzCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxMzEy
MjQgLT4gbmV4dC0yMDEzMTIyNAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwMTA2
IC0+IG5leHQtMjAxNDAxMDYKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDEwNyAt
PiBuZXh0LTIwMTQwMTA3CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDAxMDggLT4g
bmV4dC0yMDE0MDEwOAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwMTA5IC0+IG5l
eHQtMjAxNDAxMDkKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDExMCAtPiBuZXh0
LTIwMTQwMTEwCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDAxMTMgLT4gbmV4dC0y
MDE0MDExMwogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwMTE0IC0+IG5leHQtMjAx
NDAxMTQKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDExNSAtPiBuZXh0LTIwMTQw
MTE1CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDAxMTYgLT4gbmV4dC0yMDE0MDEx
NgogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwMTE3IC0+IG5leHQtMjAxNDAxMTcK
ICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDEyMCAtPiBuZXh0LTIwMTQwMTIwCiAq
IFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDAxMjEgLT4gbmV4dC0yMDE0MDEyMQogKiBb
bmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwMTIyIC0+IG5leHQtMjAxNDAxMjIKICogW25l
dyB0YWddICAgICAgICAgbmV4dC0yMDE0MDEyMyAtPiBuZXh0LTIwMTQwMTIzCiAqIFtuZXcg
dGFnXSAgICAgICAgIG5leHQtMjAxNDAxMjQgLT4gbmV4dC0yMDE0MDEyNAogKiBbbmV3IHRh
Z10gICAgICAgICBuZXh0LTIwMTQwMTI4IC0+IG5leHQtMjAxNDAxMjgKICogW25ldyB0YWdd
ICAgICAgICAgbmV4dC0yMDE0MDEyOSAtPiBuZXh0LTIwMTQwMTI5CiAqIFtuZXcgdGFnXSAg
ICAgICAgIG5leHQtMjAxNDAxMzAgLT4gbmV4dC0yMDE0MDEzMAogKiBbbmV3IHRhZ10gICAg
ICAgICBuZXh0LTIwMTQwMTMxIC0+IG5leHQtMjAxNDAxMzEKICogW25ldyB0YWddICAgICAg
ICAgbmV4dC0yMDE0MDIwMyAtPiBuZXh0LTIwMTQwMjAzCiAqIFtuZXcgdGFnXSAgICAgICAg
IG5leHQtMjAxNDAyMDQgLT4gbmV4dC0yMDE0MDIwNAogKiBbbmV3IHRhZ10gICAgICAgICBu
ZXh0LTIwMTQwMjA1IC0+IG5leHQtMjAxNDAyMDUKICogW25ldyB0YWddICAgICAgICAgbmV4
dC0yMDE0MDIwNiAtPiBuZXh0LTIwMTQwMjA2CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQt
MjAxNDAyMDcgLT4gbmV4dC0yMDE0MDIwNwogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIw
MTQwMjEwIC0+IG5leHQtMjAxNDAyMTAKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0
MDIxMSAtPiBuZXh0LTIwMTQwMjExCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDAy
MTIgLT4gbmV4dC0yMDE0MDIxMgogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwMjEz
IC0+IG5leHQtMjAxNDAyMTMKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDIxNCAt
PiBuZXh0LTIwMTQwMjE0CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDAyMTcgLT4g
bmV4dC0yMDE0MDIxNwogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwMjE4IC0+IG5l
eHQtMjAxNDAyMTgKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDIxOSAtPiBuZXh0
LTIwMTQwMjE5CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDAyMjAgLT4gbmV4dC0y
MDE0MDIyMAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwMjIxIC0+IG5leHQtMjAx
NDAyMjEKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDIyNCAtPiBuZXh0LTIwMTQw
MjI0CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDAyMjUgLT4gbmV4dC0yMDE0MDIy
NQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwMjI2IC0+IG5leHQtMjAxNDAyMjYK
ICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDIyNyAtPiBuZXh0LTIwMTQwMjI3CiAq
IFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDAyMjggLT4gbmV4dC0yMDE0MDIyOAogKiBb
bmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwMzAzIC0+IG5leHQtMjAxNDAzMDMKICogW25l
dyB0YWddICAgICAgICAgbmV4dC0yMDE0MDMwNCAtPiBuZXh0LTIwMTQwMzA0CiAqIFtuZXcg
dGFnXSAgICAgICAgIG5leHQtMjAxNDAzMDUgLT4gbmV4dC0yMDE0MDMwNQogKiBbbmV3IHRh
Z10gICAgICAgICBuZXh0LTIwMTQwMzA2IC0+IG5leHQtMjAxNDAzMDYKICogW25ldyB0YWdd
ICAgICAgICAgbmV4dC0yMDE0MDMwNyAtPiBuZXh0LTIwMTQwMzA3CiAqIFtuZXcgdGFnXSAg
ICAgICAgIG5leHQtMjAxNDAzMTEgLT4gbmV4dC0yMDE0MDMxMQogKiBbbmV3IHRhZ10gICAg
ICAgICBuZXh0LTIwMTQwMzEyIC0+IG5leHQtMjAxNDAzMTIKICogW25ldyB0YWddICAgICAg
ICAgbmV4dC0yMDE0MDMxMyAtPiBuZXh0LTIwMTQwMzEzCiAqIFtuZXcgdGFnXSAgICAgICAg
IG5leHQtMjAxNDAzMTQgLT4gbmV4dC0yMDE0MDMxNAogKiBbbmV3IHRhZ10gICAgICAgICBu
ZXh0LTIwMTQwMzE3IC0+IG5leHQtMjAxNDAzMTcKICogW25ldyB0YWddICAgICAgICAgbmV4
dC0yMDE0MDMxOCAtPiBuZXh0LTIwMTQwMzE4CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQt
MjAxNDAzMTkgLT4gbmV4dC0yMDE0MDMxOQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIw
MTQwMzIwIC0+IG5leHQtMjAxNDAzMjAKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0
MDMyMSAtPiBuZXh0LTIwMTQwMzIxCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDAz
MjQgLT4gbmV4dC0yMDE0MDMyNAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwMzI1
IC0+IG5leHQtMjAxNDAzMjUKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDMyNiAt
PiBuZXh0LTIwMTQwMzI2CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDAzMjcgLT4g
bmV4dC0yMDE0MDMyNwogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwMzI4IC0+IG5l
eHQtMjAxNDAzMjgKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDMzMSAtPiBuZXh0
LTIwMTQwMzMxCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDA0MDEgLT4gbmV4dC0y
MDE0MDQwMQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwNDAyIC0+IG5leHQtMjAx
NDA0MDIKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDQwMyAtPiBuZXh0LTIwMTQw
NDAzCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDA0MDcgLT4gbmV4dC0yMDE0MDQw
NwogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwNDA4IC0+IG5leHQtMjAxNDA0MDgK
ICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDQwOSAtPiBuZXh0LTIwMTQwNDA5CiAq
IFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDA0MTAgLT4gbmV4dC0yMDE0MDQxMAogKiBb
bmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwNDExIC0+IG5leHQtMjAxNDA0MTEKICogW25l
dyB0YWddICAgICAgICAgbmV4dC0yMDE0MDQxNCAtPiBuZXh0LTIwMTQwNDE0CiAqIFtuZXcg
dGFnXSAgICAgICAgIG5leHQtMjAxNDA0MTUgLT4gbmV4dC0yMDE0MDQxNQogKiBbbmV3IHRh
Z10gICAgICAgICBuZXh0LTIwMTQwNDE2IC0+IG5leHQtMjAxNDA0MTYKICogW25ldyB0YWdd
ICAgICAgICAgbmV4dC0yMDE0MDQxNyAtPiBuZXh0LTIwMTQwNDE3CiAqIFtuZXcgdGFnXSAg
ICAgICAgIG5leHQtMjAxNDA0MjIgLT4gbmV4dC0yMDE0MDQyMgogKiBbbmV3IHRhZ10gICAg
ICAgICBuZXh0LTIwMTQwNDIzIC0+IG5leHQtMjAxNDA0MjMKICogW25ldyB0YWddICAgICAg
ICAgbmV4dC0yMDE0MDQyNCAtPiBuZXh0LTIwMTQwNDI0CiAqIFtuZXcgdGFnXSAgICAgICAg
IG5leHQtMjAxNDA0MjggLT4gbmV4dC0yMDE0MDQyOAogKiBbbmV3IHRhZ10gICAgICAgICBu
ZXh0LTIwMTQwNDI5IC0+IG5leHQtMjAxNDA0MjkKICogW25ldyB0YWddICAgICAgICAgbmV4
dC0yMDE0MDQzMCAtPiBuZXh0LTIwMTQwNDMwCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQt
MjAxNDA1MDEgLT4gbmV4dC0yMDE0MDUwMQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIw
MTQwNTAyIC0+IG5leHQtMjAxNDA1MDIKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0
MDUwNSAtPiBuZXh0LTIwMTQwNTA1CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDA1
MDYgLT4gbmV4dC0yMDE0MDUwNgogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwNTA3
IC0+IG5leHQtMjAxNDA1MDcKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDUwOCAt
PiBuZXh0LTIwMTQwNTA4CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDA1MDkgLT4g
bmV4dC0yMDE0MDUwOQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwNTEyIC0+IG5l
eHQtMjAxNDA1MTIKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDUxMyAtPiBuZXh0
LTIwMTQwNTEzCiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDA1MTQgLT4gbmV4dC0y
MDE0MDUxNAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwNTE1IC0+IG5leHQtMjAx
NDA1MTUKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDUxNiAtPiBuZXh0LTIwMTQw
NTE2CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDA1MTkgLT4gbmV4dC0yMDE0MDUx
OQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwNTIwIC0+IG5leHQtMjAxNDA1MjAK
ICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDUyMSAtPiBuZXh0LTIwMTQwNTIxCiAq
IFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDA1MjIgLT4gbmV4dC0yMDE0MDUyMgogKiBb
bmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwNTIzIC0+IG5leHQtMjAxNDA1MjMKICogW25l
dyB0YWddICAgICAgICAgbmV4dC0yMDE0MDUyNiAtPiBuZXh0LTIwMTQwNTI2CiAqIFtuZXcg
dGFnXSAgICAgICAgIG5leHQtMjAxNDA1MjcgLT4gbmV4dC0yMDE0MDUyNwogKiBbbmV3IHRh
Z10gICAgICAgICBuZXh0LTIwMTQwNTI4IC0+IG5leHQtMjAxNDA1MjgKICogW25ldyB0YWdd
ICAgICAgICAgbmV4dC0yMDE0MDUyOSAtPiBuZXh0LTIwMTQwNTI5CiAqIFtuZXcgdGFnXSAg
ICAgICAgIG5leHQtMjAxNDA1MzAgLT4gbmV4dC0yMDE0MDUzMApQcmV2aW91cyBIRUFEIHBv
c2l0aW9uIHdhcyBmYWQwMWU4Li4uIExpbnV4IDMuMTUtcmM4CkhFQUQgaXMgbm93IGF0IDMy
MmMwMzAuLi4gQWRkIGxpbnV4LW5leHQgc3BlY2lmaWMgZmlsZXMgZm9yIDIwMTQwNTMwCmxz
IC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzEtMDYw
MjExNDAvbmV4dDptYXN0ZXI6MzIyYzAzMGY1NDYyYTQ0Y2U0MmY4ODA0Mjg0ZWI1MmI3Y2Qy
YmE0MTpiaXNlY3QtbGludXg0CgoyMDE0LTA2LTAyLTE0OjEwOjU0IDMyMmMwMzBmNTQ2MmE0
NGNlNDJmODgwNDI4NGViNTJiN2NkMmJhNDEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNr
IHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWMxLTA2MDIx
MTQwLTMyMmMwMzBmNTQ2MmE0NGNlNDJmODgwNDI4NGViNTJiN2NkMmJhNDEKQ2hlY2sgZm9y
IGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNjAyMTE0MC8zMjJjMDMw
ZjU0NjJhNDRjZTQyZjg4MDQyODRlYjUyYjdjZDJiYTQxCndhaXRpbmcgZm9yIGNvbXBsZXRp
b24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzEtMDYw
MjExNDAtMzIyYzAzMGY1NDYyYTQ0Y2U0MmY4ODA0Mjg0ZWI1MmI3Y2QyYmE0MQp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFu
ZGNvbmZpZy1jMS0wNjAyMTE0MC0zMjJjMDMwZjU0NjJhNDRjZTQyZjg4MDQyODRlYjUyYjdj
ZDJiYTQxCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDYwMjExNDAvMzIy
YzAzMGY1NDYyYTQ0Y2U0MmY4ODA0Mjg0ZWI1MmI3Y2QyYmE0MS92bWxpbnV6LTMuMTUuMC1y
YzctbmV4dC0yMDE0MDUzMAoKMjAxNC0wNi0wMi0xNDoxNzo1NCBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAuLi4uLi4uLgkzCTQJOQkxMgkxMwkyMQk0NAk2MCBTVUNDRVNTCgo=

--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.15.0-rc5-00087-gb739c99"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.15.0-rc5 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
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
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
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
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_FHANDLE=y
# CONFIG_USELIB is not set
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_STALL_COMMON is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
CONFIG_CGROUP_HUGETLB=y
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
# CONFIG_FAIR_GROUP_SCHED is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
# CONFIG_SYSFS_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
CONFIG_SYSTEM_TRUSTED_KEYRING=y
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
CONFIG_HAVE_DMA_CONTIGUOUS=y
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
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
# CONFIG_GCOV_FORMAT_3_4 is not set
CONFIG_GCOV_FORMAT_4_7=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_THROTTLING=y
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
# CONFIG_ACORN_PARTITION_ADFS is not set
# CONFIG_ACORN_PARTITION_POWERTEC is not set
# CONFIG_ACORN_PARTITION_RISCIX is not set
CONFIG_AIX_PARTITION=y
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
# CONFIG_MSDOS_PARTITION is not set
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
CONFIG_CMDLINE_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
CONFIG_GOLDFISH=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_GOLDFISH=y
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_RDC321X=y
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
CONFIG_MWINCHIPC6=y
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=5
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
# CONFIG_CPU_SUP_AMD is not set
CONFIG_CPU_SUP_CENTAUR=y
# CONFIG_CPU_SUP_TRANSMETA_32 is not set
# CONFIG_CPU_SUP_UMC_32 is not set
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_ANCIENT_MCE=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=y
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
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
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_EXTLOG is not set
# CONFIG_SFI is not set
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
# CONFIG_APM_IGNORE_USER_SUSPEND is not set
CONFIG_APM_DO_ENABLE=y
# CONFIG_APM_CPU_IDLE is not set
# CONFIG_APM_DISPLAY_BLANK is not set
CONFIG_APM_ALLOW_INTS=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

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
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOOLPC=y
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_DIRECT=y
CONFIG_PCI_OLPC=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
# CONFIG_HT_IRQ is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_EISA=y
# CONFIG_EISA_VLB_PRIMING is not set
CONFIG_EISA_PCI_EISA=y
# CONFIG_EISA_VIRTUAL_ROOT is not set
CONFIG_EISA_NAMES=y
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_OLPC=y
CONFIG_OLPC_XO1_PM=y
# CONFIG_OLPC_XO1_SCI is not set
# CONFIG_OLPC_XO15_SCI is not set
CONFIG_ALIX=y
CONFIG_NET5501=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
CONFIG_I82092=y
CONFIG_I82365=y
CONFIG_TCIC=y
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
# CONFIG_RAPIDIO_DMA_ENGINE is not set
# CONFIG_RAPIDIO_DEBUG is not set
CONFIG_RAPIDIO_ENUM_BASIC=y

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=y
# CONFIG_RAPIDIO_CPS_XX is not set
# CONFIG_RAPIDIO_TSI568 is not set
CONFIG_RAPIDIO_CPS_GEN2=y
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_USER is not set
CONFIG_XFRM_SUB_POLICY=y
# CONFIG_XFRM_MIGRATE is not set
CONFIG_XFRM_IPCOMP=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
# CONFIG_NET_IPGRE is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_INET_UDP_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=y
CONFIG_TCP_CONG_SCALABLE=y
CONFIG_TCP_CONG_LP=y
CONFIG_TCP_CONG_VENO=y
CONFIG_TCP_CONG_YEAH=y
CONFIG_TCP_CONG_ILLINOIS=y
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HYBLA is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_VENO is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
CONFIG_INET6_IPCOMP=y
CONFIG_IPV6_MIP6=y
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
CONFIG_IPV6_VTI=y
# CONFIG_IPV6_SIT is not set
CONFIG_IPV6_TUNNEL=y
# CONFIG_IPV6_GRE is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE=y
CONFIG_SCTP_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_COOKIE_HMAC_SHA1 is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
CONFIG_ATM_CLIP_NO_ICMP=y
CONFIG_ATM_LANE=y
CONFIG_ATM_MPOA=y
# CONFIG_ATM_BR2684 is not set
# CONFIG_L2TP is not set
CONFIG_MRP=y
# CONFIG_BRIDGE is not set
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
# CONFIG_ATALK is not set
CONFIG_X25=y
# CONFIG_LAPB is not set
CONFIG_PHONET=y
CONFIG_IEEE802154=y
# CONFIG_IEEE802154_6LOWPAN is not set
CONFIG_6LOWPAN_IPHC=y
CONFIG_MAC802154=y
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_BLA=y
CONFIG_BATMAN_ADV_DAT=y
# CONFIG_BATMAN_ADV_NC is not set
CONFIG_BATMAN_ADV_MCAST=y
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_OPENVSWITCH=y
# CONFIG_OPENVSWITCH_GRE is not set
CONFIG_VSOCKETS=y
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=y
# CONFIG_NET_MPLS_GSO is not set
CONFIG_HSR=y
CONFIG_CGROUP_NET_PRIO=y
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_DROP_MONITOR=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=y
CONFIG_BT_6LOWPAN=y
CONFIG_BT_RFCOMM=y
# CONFIG_BT_RFCOMM_TTY is not set
CONFIG_BT_BNEP=y
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIDTL1=y
CONFIG_BT_HCIBT3C=y
# CONFIG_BT_HCIBLUECARD is not set
CONFIG_BT_HCIBTUART=y
# CONFIG_BT_HCIVHCI is not set
CONFIG_BT_MRVL=y
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
# CONFIG_RXKAD is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_RFKILL_GPIO=y
# CONFIG_NET_9P is not set
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=y
CONFIG_CAIF_USB=y
CONFIG_CEPH_LIB=y
CONFIG_CEPH_LIB_PRETTYDEBUG=y
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
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
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
CONFIG_OF_SELFTEST=y
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_ADDRESS_PCI=y
CONFIG_OF_IRQ=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
# CONFIG_PARPORT is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
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
# CONFIG_BLK_DEV_OSD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
# CONFIG_ICS932S401 is not set
CONFIG_ATMEL_SSC=y
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_CS5535_MFGPT is not set
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_INTEL_MEI=y
# CONFIG_INTEL_MEI_ME is not set
CONFIG_INTEL_MEI_TXE=y
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_ECHO=y
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_IDE_LEGACY=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
CONFIG_IDE_GD_ATAPI=y
# CONFIG_BLK_DEV_IDECS is not set
CONFIG_BLK_DEV_DELKIN=y
# CONFIG_BLK_DEV_IDECD is not set
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_PLATFORM=y
CONFIG_BLK_DEV_CMD640=y
CONFIG_BLK_DEV_CMD640_ENHANCED=y
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
CONFIG_BLK_DEV_OFFBOARD=y
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
CONFIG_BLK_DEV_ALI15X3=y
# CONFIG_BLK_DEV_AMD74XX is not set
CONFIG_BLK_DEV_ATIIXP=y
CONFIG_BLK_DEV_CMD64X=y
# CONFIG_BLK_DEV_TRIFLEX is not set
CONFIG_BLK_DEV_CS5520=y
CONFIG_BLK_DEV_CS5530=y
CONFIG_BLK_DEV_CS5535=y
# CONFIG_BLK_DEV_CS5536 is not set
CONFIG_BLK_DEV_HPT366=y
CONFIG_BLK_DEV_JMICRON=y
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
CONFIG_BLK_DEV_IT8172=y
CONFIG_BLK_DEV_IT8213=y
# CONFIG_BLK_DEV_IT821X is not set
CONFIG_BLK_DEV_NS87415=y
CONFIG_BLK_DEV_PDC202XX_OLD=y
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
CONFIG_BLK_DEV_SIS5513=y
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
CONFIG_BLK_DEV_VIA82CXXX=y
CONFIG_BLK_DEV_TC86C001=y

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
# CONFIG_BLK_DEV_4DRIVES is not set
CONFIG_BLK_DEV_ALI14XX=y
CONFIG_BLK_DEV_DTC2278=y
# CONFIG_BLK_DEV_HT6560B is not set
CONFIG_BLK_DEV_QD65XX=y
CONFIG_BLK_DEV_UMC8672=y
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
CONFIG_CHR_DEV_ST=y
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_FC_TGT_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_SRP_TGT_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
# CONFIG_SCSI_DH_HP_SW is not set
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
CONFIG_SATA_AHCI_PLATFORM=y
CONFIG_SATA_INIC162X=y
CONFIG_SATA_ACARD_AHCI=y
CONFIG_SATA_SIL24=y
# CONFIG_ATA_SFF is not set
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
# CONFIG_I2O_EXT_ADAPTEC is not set
CONFIG_I2O_CONFIG=y
CONFIG_I2O_CONFIG_OLD_IOCTL=y
# CONFIG_I2O_BUS is not set
CONFIG_I2O_BLOCK=y
CONFIG_I2O_SCSI=y
CONFIG_I2O_PROC=y
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
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5520=y
CONFIG_KEYBOARD_ADP5588=y
CONFIG_KEYBOARD_ADP5589=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
CONFIG_KEYBOARD_QT2160=y
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_GPIO=y
CONFIG_KEYBOARD_GPIO_POLLED=y
CONFIG_KEYBOARD_TCA6416=y
CONFIG_KEYBOARD_TCA8418=y
CONFIG_KEYBOARD_MATRIX=y
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_LM8333=y
# CONFIG_KEYBOARD_MAX7359 is not set
CONFIG_KEYBOARD_MCS=y
# CONFIG_KEYBOARD_MPR121 is not set
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_OPENCORES=y
CONFIG_KEYBOARD_GOLDFISH_EVENTS=y
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_KEYBOARD_SUNKBD=y
# CONFIG_KEYBOARD_TWL4030 is not set
CONFIG_KEYBOARD_XTKBD=y
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=y
CONFIG_MOUSE_INPORT=y
# CONFIG_MOUSE_ATIXL is not set
# CONFIG_MOUSE_LOGIBM is not set
CONFIG_MOUSE_PC110PAD=y
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=y
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_AD7879=y
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=y
# CONFIG_TOUCHSCREEN_DA9052 is not set
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
# CONFIG_TOUCHSCREEN_EETI is not set
CONFIG_TOUCHSCREEN_EGALAX=y
CONFIG_TOUCHSCREEN_FUJITSU=y
# CONFIG_TOUCHSCREEN_ILI210X is not set
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_INEXIO=y
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_HTCPEN=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_WM831X=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_MC13783=y
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC2007=y
# CONFIG_TOUCHSCREEN_ST1232 is not set
CONFIG_TOUCHSCREEN_TPS6507X=y
CONFIG_TOUCHSCREEN_ZFORCE=y
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM80X_ONKEY=y
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_BMA150=y
# CONFIG_INPUT_MAX8925_ONKEY is not set
# CONFIG_INPUT_MAX8997_HAPTIC is not set
# CONFIG_INPUT_MC13783_PWRBUTTON is not set
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
# CONFIG_INPUT_GP2A is not set
# CONFIG_INPUT_GPIO_BEEPER is not set
CONFIG_INPUT_GPIO_TILT_POLLED=y
CONFIG_INPUT_WISTRON_BTNS=y
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=y
# CONFIG_INPUT_KXTJ9_POLLED_MODE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_RETU_PWRBUTTON=y
CONFIG_INPUT_TWL4030_PWRBUTTON=y
# CONFIG_INPUT_TWL4030_VIBRA is not set
# CONFIG_INPUT_TWL6040_VIBRA is not set
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_PCF50633_PMU is not set
CONFIG_INPUT_PCF8574=y
CONFIG_INPUT_PWM_BEEPER=y
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
CONFIG_INPUT_DA9052_ONKEY=y
CONFIG_INPUT_DA9055_ONKEY=y
CONFIG_INPUT_WM831X_ON=y
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=y
CONFIG_INPUT_CMA3000=y
CONFIG_INPUT_CMA3000_I2C=y
CONFIG_INPUT_IDEAPAD_SLIDEBAR=y
CONFIG_INPUT_SOC_BUTTON_ARRAY=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
# CONFIG_SERIO_APBPS2 is not set
CONFIG_SERIO_OLPC_APSP=y
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_GOLDFISH_TTY is not set
# CONFIG_DEVKMEM is not set

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
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_OF_PLATFORM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_SI_PROBE_DEFAULTS=y
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
# CONFIG_HW_RANDOM_VIRTIO is not set
# CONFIG_HW_RANDOM_TPM is not set
# CONFIG_NVRAM is not set
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
CONFIG_SONYPI=y

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
# CONFIG_MWAVE is not set
# CONFIG_SCx200_GPIO is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_ARB_GPIO_CHALLENGE is not set
CONFIG_I2C_MUX_GPIO=y
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
CONFIG_I2C_DESIGNWARE_PCI=y
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_ELEKTOR=y
# CONFIG_I2C_PCA_ISA is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_SPMI is not set
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
CONFIG_PPS_CLIENT_KTIMER=y
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_DWAPB=y
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_SCH311X=y
CONFIG_GPIO_SYSCON=y
CONFIG_GPIO_SCH=y
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set
CONFIG_GPIO_GRGPIO=y

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
CONFIG_GPIO_LP3943=y
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_SX150X=y
# CONFIG_GPIO_TPS65912 is not set
# CONFIG_GPIO_TWL4030 is not set
# CONFIG_GPIO_TWL6040 is not set
# CONFIG_GPIO_WM831X is not set
CONFIG_GPIO_WM8350=y
# CONFIG_GPIO_ADP5520 is not set
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y
# CONFIG_GPIO_ADNP is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=y
# CONFIG_GPIO_BT8XX is not set
CONFIG_GPIO_AMD8111=y
# CONFIG_GPIO_INTEL_MID is not set
CONFIG_GPIO_PCH=y
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_SODAVILLE is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MCP23S08 is not set

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_JANZ_TTL is not set
CONFIG_GPIO_TPS65910=y
# CONFIG_GPIO_BCM_KONA is not set

#
# USB GPIO expanders:
#
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
CONFIG_GENERIC_ADC_BATTERY=y
# CONFIG_MAX8925_POWER is not set
CONFIG_WM831X_BACKUP=y
# CONFIG_WM831X_POWER is not set
CONFIG_WM8350_POWER=y
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_OLPC=y
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
CONFIG_BATTERY_TWL4030_MADC=y
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_BATTERY_RX51=y
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_TWL4030 is not set
CONFIG_CHARGER_LP8727=y
# CONFIG_CHARGER_LP8788 is not set
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MANAGER=y
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_BQ24735=y
CONFIG_CHARGER_SMB347=y
CONFIG_CHARGER_TPS65090=y
CONFIG_BATTERY_GOLDFISH=y
CONFIG_POWER_RESET=y
CONFIG_POWER_RESET_GPIO=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_DA9055 is not set
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_MC13783_ADC=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
# CONFIG_SENSORS_IIO_HWMON is not set
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4260=y
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_TWL4030_MADC=y
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_WM8350=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
CONFIG_THERMAL_OF=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_EMULATION=y
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_X86_PKG_TEMP_THERMAL=y
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
CONFIG_DA9052_WATCHDOG=y
CONFIG_DA9055_WATCHDOG=y
CONFIG_GPIO_WATCHDOG=y
CONFIG_WM831X_WATCHDOG=y
# CONFIG_WM8350_WATCHDOG is not set
# CONFIG_XILINX_WATCHDOG is not set
CONFIG_DW_WATCHDOG=y
CONFIG_TWL4030_WATCHDOG=y
CONFIG_RETU_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=y
CONFIG_F71808E_WDT=y
CONFIG_SP5100_TCO=y
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
CONFIG_IE6XX_WDT=y
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=y
# CONFIG_IT87_WDT is not set
CONFIG_HP_WATCHDOG=y
# CONFIG_HPWDT_NMI_DECODING is not set
CONFIG_SC1200_WDT=y
CONFIG_SCx200_WDT=y
CONFIG_PC87413_WDT=y
CONFIG_NV_TCO=y
# CONFIG_RDC321X_WDT is not set
# CONFIG_60XX_WDT is not set
CONFIG_SBC8360_WDT=y
CONFIG_SBC7240_WDT=y
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=y
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_MEN_A21_WDT=y

#
# ISA-based Watchdog Cards
#
# CONFIG_PCWATCHDOG is not set
# CONFIG_MIXCOMWD is not set
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
CONFIG_WDTPCI=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
CONFIG_MFD_AS3711=y
# CONFIG_MFD_AS3722 is not set
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_RDC321X is not set
CONFIG_MFD_RTSX_PCI=y
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=y
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65090=y
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS65218 is not set
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
CONFIG_MFD_TWL4030_AUDIO=y
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
# CONFIG_MFD_WM8997 is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_88PM800=y
CONFIG_REGULATOR_ACT8865=y
# CONFIG_REGULATOR_AD5398 is not set
# CONFIG_REGULATOR_ANATOP is not set
CONFIG_REGULATOR_AS3711=y
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=y
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8907=y
# CONFIG_REGULATOR_MAX8925 is not set
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
# CONFIG_REGULATOR_MAX8997 is not set
CONFIG_REGULATOR_MAX77686=y
CONFIG_REGULATOR_MAX77693=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
# CONFIG_REGULATOR_PCF50633 is not set
# CONFIG_REGULATOR_PFUZE100 is not set
CONFIG_REGULATOR_TPS51632=y
# CONFIG_REGULATOR_TPS6105X is not set
CONFIG_REGULATOR_TPS62360=y
# CONFIG_REGULATOR_TPS65023 is not set
# CONFIG_REGULATOR_TPS6507X is not set
# CONFIG_REGULATOR_TPS65090 is not set
CONFIG_REGULATOR_TPS65910=y
CONFIG_REGULATOR_TPS65912=y
# CONFIG_REGULATOR_TWL4030 is not set
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8350=y
CONFIG_REGULATOR_WM8400=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
CONFIG_RC_MAP=y
# CONFIG_RC_DECODERS is not set
CONFIG_RC_DEVICES=y
# CONFIG_RC_ATI_REMOTE is not set
# CONFIG_IR_ENE is not set
# CONFIG_IR_IMON is not set
# CONFIG_IR_MCEUSB is not set
# CONFIG_IR_ITE_CIR is not set
# CONFIG_IR_FINTEK is not set
# CONFIG_IR_NUVOTON is not set
# CONFIG_IR_REDRAT3 is not set
# CONFIG_IR_STREAMZAP is not set
# CONFIG_IR_WINBOND_CIR is not set
# CONFIG_IR_IGUANA is not set
# CONFIG_IR_TTUSBIR is not set
CONFIG_IR_IMG=y
CONFIG_IR_IMG_RAW=y
# CONFIG_IR_IMG_HW is not set
# CONFIG_RC_LOOPBACK is not set
CONFIG_IR_GPIO_CIR=y
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Supported MMC/SDIO adapters
#
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_SI470X is not set
CONFIG_RADIO_SI4713=y
# CONFIG_PLATFORM_SI4713 is not set
CONFIG_I2C_SI4713=y
# CONFIG_RADIO_MAXIRADIO is not set
CONFIG_RADIO_TEA5764=y
CONFIG_RADIO_TEA5764_XTAL=y
CONFIG_RADIO_SAA7706H=y
CONFIG_RADIO_TEF6862=y
# CONFIG_RADIO_WL1273 is not set

#
# Texas Instruments WL128x FM driver (ST based)
#
# CONFIG_RADIO_WL128X is not set
# CONFIG_V4L_RADIO_ISA_DRIVERS is not set

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_VIDEO_IR_I2C=y

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_TVAUDIO is not set
CONFIG_VIDEO_TDA7432=y
CONFIG_VIDEO_TDA9840=y
CONFIG_VIDEO_TEA6415C=y
CONFIG_VIDEO_TEA6420=y
# CONFIG_VIDEO_MSP3400 is not set
CONFIG_VIDEO_CS5345=y
CONFIG_VIDEO_CS53L32A=y
CONFIG_VIDEO_TLV320AIC23B=y
CONFIG_VIDEO_UDA1342=y
CONFIG_VIDEO_WM8775=y
CONFIG_VIDEO_WM8739=y
CONFIG_VIDEO_VP27SMPX=y
CONFIG_VIDEO_SONY_BTF_MPX=y

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=y

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=y
CONFIG_VIDEO_ADV7183=y
CONFIG_VIDEO_BT819=y
# CONFIG_VIDEO_BT856 is not set
CONFIG_VIDEO_BT866=y
# CONFIG_VIDEO_KS0127 is not set
CONFIG_VIDEO_ML86V7667=y
CONFIG_VIDEO_SAA7110=y
CONFIG_VIDEO_SAA711X=y
CONFIG_VIDEO_SAA7191=y
# CONFIG_VIDEO_TVP514X is not set
CONFIG_VIDEO_TVP5150=y
# CONFIG_VIDEO_TVP7002 is not set
CONFIG_VIDEO_TW2804=y
CONFIG_VIDEO_TW9903=y
CONFIG_VIDEO_TW9906=y
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
# CONFIG_VIDEO_SAA717X is not set
CONFIG_VIDEO_CX25840=y

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=y
CONFIG_VIDEO_SAA7185=y
CONFIG_VIDEO_ADV7170=y
CONFIG_VIDEO_ADV7175=y
CONFIG_VIDEO_ADV7343=y
CONFIG_VIDEO_ADV7393=y
# CONFIG_VIDEO_AK881X is not set
CONFIG_VIDEO_THS8200=y

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
CONFIG_VIDEO_UPD64083=y

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=y

#
# Miscellaneous helper chips
#
# CONFIG_VIDEO_THS7303 is not set
# CONFIG_VIDEO_M52790 is not set

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
# CONFIG_MEDIA_TUNER_SIMPLE is not set
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
# CONFIG_MEDIA_TUNER_TEA5761 is not set
# CONFIG_MEDIA_TUNER_TEA5767 is not set
CONFIG_MEDIA_TUNER_MT20XX=y
# CONFIG_MEDIA_TUNER_MT2060 is not set
CONFIG_MEDIA_TUNER_MT2063=y
CONFIG_MEDIA_TUNER_MT2266=y
CONFIG_MEDIA_TUNER_MT2131=y
CONFIG_MEDIA_TUNER_QT1010=y
CONFIG_MEDIA_TUNER_XC2028=y
# CONFIG_MEDIA_TUNER_XC5000 is not set
CONFIG_MEDIA_TUNER_XC4000=y
# CONFIG_MEDIA_TUNER_MXL5005S is not set
# CONFIG_MEDIA_TUNER_MXL5007T is not set
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_MEDIA_TUNER_MAX2165=y
CONFIG_MEDIA_TUNER_TDA18218=y
CONFIG_MEDIA_TUNER_FC0011=y
CONFIG_MEDIA_TUNER_FC0012=y
CONFIG_MEDIA_TUNER_FC0013=y
CONFIG_MEDIA_TUNER_TDA18212=y
CONFIG_MEDIA_TUNER_E4000=y
# CONFIG_MEDIA_TUNER_FC2580 is not set
CONFIG_MEDIA_TUNER_M88TS2022=y
CONFIG_MEDIA_TUNER_TUA9001=y
CONFIG_MEDIA_TUNER_IT913X=y
# CONFIG_MEDIA_TUNER_R820T is not set

#
# Customise DVB Frontends
#
# CONFIG_DVB_AU8522_V4L is not set
CONFIG_DVB_TUNER_DIB0070=y
CONFIG_DVB_TUNER_DIB0090=y

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
# CONFIG_AGP is not set
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
# CONFIG_DRM_I2C_CH7006 is not set
CONFIG_DRM_I2C_SIL164=y
CONFIG_DRM_I2C_NXP_TDA998X=y
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_UMS=y
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
CONFIG_DRM_I915_FBDEV=y
# CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT is not set
CONFIG_DRM_I915_UMS=y
CONFIG_DRM_MGA=y
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
CONFIG_DRM_VMWGFX=y
CONFIG_DRM_VMWGFX_FBCON=y
CONFIG_DRM_GMA500=y
# CONFIG_DRM_GMA600 is not set
# CONFIG_DRM_GMA3600 is not set
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=y
# CONFIG_DRM_MGAG200 is not set
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_DRM_QXL=y
CONFIG_DRM_BOCHS=y
CONFIG_DRM_PTN3460=y

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
CONFIG_FB_HECUBA=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
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
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
CONFIG_FB_VESA=y
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_OPENCORES=y
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
# CONFIG_FB_RIVA is not set
CONFIG_FB_I740=y
# CONFIG_FB_LE80578 is not set
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
CONFIG_FB_MATROX_MYSTIQUE=y
# CONFIG_FB_MATROX_G is not set
CONFIG_FB_MATROX_I2C=y
CONFIG_FB_RADEON=y
# CONFIG_FB_RADEON_I2C is not set
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=y
# CONFIG_FB_ATY_CT is not set
# CONFIG_FB_ATY_GX is not set
# CONFIG_FB_ATY_BACKLIGHT is not set
CONFIG_FB_S3=y
# CONFIG_FB_S3_DDC is not set
CONFIG_FB_SAVAGE=y
# CONFIG_FB_SAVAGE_I2C is not set
CONFIG_FB_SAVAGE_ACCEL=y
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=y
# CONFIG_FB_3DFX is not set
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
# CONFIG_FB_METRONOME is not set
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
CONFIG_FB_AUO_K1901=y
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
# CONFIG_FB_SSD1307 is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_DA9052=y
CONFIG_BACKLIGHT_MAX8925=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
# CONFIG_BACKLIGHT_WM831X is not set
CONFIG_BACKLIGHT_ADP5520=y
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_PCF50633=y
# CONFIG_BACKLIGHT_LM3630A is not set
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_LP855X is not set
CONFIG_BACKLIGHT_LP8788=y
CONFIG_BACKLIGHT_PANDORA=y
# CONFIG_BACKLIGHT_AS3711 is not set
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
# CONFIG_BACKLIGHT_BD6107 is not set
CONFIG_VGASTATE=y
CONFIG_HDMI=y
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
# CONFIG_HID_APPLE is not set
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=y
# CONFIG_HID_ELECOM is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_ORTEK=y
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_PRIMAX=y
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=y
# CONFIG_HID_SENSOR_HUB is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_TAHVO_USB is not set
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
# CONFIG_UWB_WHCI is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
# CONFIG_LEDS_LP8788 is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
# CONFIG_LEDS_PCA9685 is not set
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_PWM=y
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_ADP5520=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_MAX8997=y
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
# CONFIG_LEDS_TRIGGER_IDE_DISK is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_ACCESSIBILITY=y
CONFIG_INFINIBAND=y
# CONFIG_INFINIBAND_USER_MAD is not set
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=y
# CONFIG_INFINIBAND_MTHCA_DEBUG is not set
CONFIG_INFINIBAND_AMSO1100=y
CONFIG_INFINIBAND_AMSO1100_DEBUG=y
CONFIG_INFINIBAND_NES=y
CONFIG_INFINIBAND_NES_DEBUG=y
# CONFIG_INFINIBAND_SRP is not set
CONFIG_INFINIBAND_ISER=y
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
# CONFIG_RTC_INTF_DEV is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM80X=y
CONFIG_RTC_DRV_DS1307=y
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
CONFIG_RTC_DRV_DS3232=y
# CONFIG_RTC_DRV_HYM8563 is not set
# CONFIG_RTC_DRV_LP8788 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_MAX8907 is not set
# CONFIG_RTC_DRV_MAX8925 is not set
CONFIG_RTC_DRV_MAX8997=y
# CONFIG_RTC_DRV_MAX77686 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_ISL12022=y
# CONFIG_RTC_DRV_ISL12057 is not set
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF2127=y
CONFIG_RTC_DRV_PCF8523=y
CONFIG_RTC_DRV_PCF8563=y
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=y
CONFIG_RTC_DRV_M41T80_WDT=y
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_TWL4030=y
CONFIG_RTC_DRV_TPS65910=y
CONFIG_RTC_DRV_S35390A=y
# CONFIG_RTC_DRV_FM3130 is not set
CONFIG_RTC_DRV_RX8581=y
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=y
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_DS1286 is not set
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DA9052=y
CONFIG_RTC_DRV_DA9055=y
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_RP5C01=y
# CONFIG_RTC_DRV_V3020 is not set
CONFIG_RTC_DRV_DS2404=y
# CONFIG_RTC_DRV_WM831X is not set
CONFIG_RTC_DRV_WM8350=y
CONFIG_RTC_DRV_PCF50633=y

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MC13XXX is not set
CONFIG_RTC_DRV_SNVS=y
CONFIG_RTC_DRV_MOXART=y

#
# HID Sensor RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
CONFIG_INTEL_IOATDMA=y
CONFIG_DW_DMAC_CORE=y
# CONFIG_DW_DMAC is not set
CONFIG_DW_DMAC_PCI=y
CONFIG_PCH_DMA=y
CONFIG_FSL_EDMA=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
CONFIG_DMA_OF=y

#
# DMA Clients
#
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_DMA_ENGINE_RAID=y
CONFIG_DCA=y
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ALIENWARE_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
CONFIG_DELL_LAPTOP=y
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
CONFIG_AMILO_RFKILL=y
# CONFIG_TC1100_WMI is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_HP_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
CONFIG_ACPI_WMI=y
# CONFIG_MSI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=y
CONFIG_XO1_RFKILL=y
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_MXM_WMI=y
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
CONFIG_GOLDFISH_PIPE=y
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_PSTORE=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y
CONFIG_OF_IOMMU=y

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
CONFIG_EXTCON_ADC_JACK=y
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
# CONFIG_EXYNOS_ADC is not set
CONFIG_LP8788_ADC=y
# CONFIG_MAX1363 is not set
# CONFIG_MCP3422 is not set
CONFIG_MEN_Z188_ADC=y
# CONFIG_NAU7802 is not set
CONFIG_TI_ADC081C=y
CONFIG_TI_AM335X_ADC=y
CONFIG_TWL4030_MADC=y
# CONFIG_TWL6030_GPADC is not set
# CONFIG_VF610_ADC is not set

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
# CONFIG_AD5064 is not set
CONFIG_AD5380=y
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
# CONFIG_DHT11 is not set
CONFIG_SI7005=y

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
CONFIG_APDS9300=y
# CONFIG_CM32181 is not set
CONFIG_CM36651=y
# CONFIG_GP2AP020A00F is not set
CONFIG_LTR501=y
CONFIG_TCS3472=y
CONFIG_SENSORS_TSL2563=y
CONFIG_TSL4531=y
# CONFIG_VCNL4000 is not set

#
# Magnetometer sensors
#
CONFIG_AK8975=y
# CONFIG_MAG3110 is not set
# CONFIG_IIO_ST_MAGN_3AXIS is not set

#
# Inclinometer sensors
#

#
# Triggers - standalone
#
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
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
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_FSL_FTM=y
# CONFIG_PWM_LP3943 is not set
# CONFIG_PWM_LPSS is not set
CONFIG_PWM_PCA9685=y
# CONFIG_PWM_TWL is not set
CONFIG_PWM_TWL_LED=y
CONFIG_IRQCHIP=y
# CONFIG_IPACK_BUS is not set
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
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
CONFIG_XFS_WARN=y
# CONFIG_XFS_DEBUG is not set
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
# CONFIG_OCFS2_FS_USERSPACE_CLUSTER is not set
# CONFIG_OCFS2_FS_STATS is not set
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
CONFIG_OCFS2_DEBUG_FS=y
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
CONFIG_BTRFS_DEBUG=y
CONFIG_BTRFS_ASSERT=y
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_CACHEFILES=y
CONFIG_CACHEFILES_DEBUG=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
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
# CONFIG_PROC_FS is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
CONFIG_DLM_DEBUG=y

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
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
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
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_HIGHMEM=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
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
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
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
# CONFIG_FUNCTION_TRACER is not set
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
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
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_STRESS=y
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
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
# CONFIG_BIG_KEYS is not set
# CONFIG_TRUSTED_KEYS is not set
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_LSM_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
# CONFIG_SECURITY_SELINUX_BOOTPARAM is not set
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
# CONFIG_SECURITY_SELINUX_AVC_STATS is not set
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
CONFIG_SECURITY_APPARMOR_HASH=y
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_YAMA_STACKED is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
# CONFIG_INTEGRITY_AUDIT is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_LSM_RULES=y
CONFIG_IMA_TEMPLATE=y
# CONFIG_IMA_NG_TEMPLATE is not set
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
CONFIG_IMA_DEFAULT_HASH="sha1"
# CONFIG_IMA_APPRAISE is not set
# CONFIG_EVM is not set
# CONFIG_DEFAULT_SECURITY_SELINUX is not set
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
# CONFIG_DEFAULT_SECURITY_YAMA is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
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
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=y
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
CONFIG_CRYPTO_DEV_GEODE=y
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_CCP_DD=y
# CONFIG_CRYPTO_DEV_CCP_CRYPTO is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
# CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE is not set
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_LGUEST is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_PERCPU_RWSEM=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_AUDIT_GENERIC=y
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y

--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--3MwIy2ne0vdjdPXF--
