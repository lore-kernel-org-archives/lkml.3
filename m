Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab3FZAT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 20:19:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:25119 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab3FZATw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 20:19:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,940,1363158000"; 
   d="log'?scan'208";a="355759553"
Date: Wed, 26 Jun 2013 08:19:43 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: fengguang.wu@intel.com, Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: WARNING: at drivers/media/v4l2-core/v4l2-dev.c:775
 __video_register_device()
Message-ID: <20130626001943.GC7188@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="i0/AhcQY5QxfSsSZ"
Content-Disposition: inline
In-Reply-To: <20130622045059.GA21294@localhost>
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

Here is another warning whose first bad commit is

commit 1c1d86a1ea07506c070cfb217a009d53990bdeb0
Author: Hans Verkuil <hans.verkuil@cisco.com>
Date:   Wed Jun 12 11:15:12 2013 -0300

    [media] v4l2: always require v4l2_dev, rename parent to dev_parent
    
[    9.492988] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver chip loaded successfully
[    9.494772] ------------[ cut here ]------------
[    9.500661] WARNING: at /c/kernel-tests/src/linux/drivers/media/v4l2-core/v4l2-dev.c:775 __video_register_device+0x6a3/0x10d0()
[    9.502258] CPU: 0 PID: 1 Comm: swapper Not tainted 3.10.0-rc7-00925-g4c5c6fc #6                                               
[    9.503283] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011                   
[    9.504080]  00000000 4d485dc0 4333ff21 4d485de8 410772f7 43d6e3a5 43ee59d4 00000307
[    9.505368]  42a98273
[    9.510546] usb 1-1: New USB device found, idVendor=0525, idProduct=a4a2
[    9.511662] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    9.512829] usb 1-1: Product: RNDIS/Ethernet Gadget
[    9.513653] usb 1-1: Manufacturer: Linux 3.10.0-rc7-00925-g4c5c6fc with dummy_udc
 42a98273 461ffba8 00000001 00000000 4d485df8 4107749e 00000009
[    9.523915]  00000000 4d485e30 42a98273 43e25cca 4d485e1c 000002b8 461ffba8 42a9785a
[    9.525292] Call Trace:
[    9.530458] g_ether gadget: high-speed config #1: CDC Ethernet (EEM)
[    9.531539] g_ether gadget: init eem
[    9.532137] g_ether gadget: activate eem
[    9.532785] dummy_udc dummy_udc.0: enabled ep1in-bulk (ep1in-bulk) maxpacket 512 stream disabled
[    9.540286] dummy_udc dummy_udc.0: enabled ep2out-bulk (ep2out-bulk) maxpacket 512 stream disabled
[    9.540341] usb0: qlen 10
[    9.544395]  [<4333ff21>] dump_stack+0x32/0x42
[    9.545097]  [<410772f7>] warn_slowpath_common+0xb7/0x100
[    9.551112]  [<42a98273>] ? __video_register_device+0x6a3/0x10d0
[    9.551979]  [<42a98273>] ? __video_register_device+0x6a3/0x10d0
[    9.552834]  [<4107749e>] warn_slowpath_null+0x3e/0x50
[    9.553571]  [<42a98273>] __video_register_device+0x6a3/0x10d0
[    9.554440]  [<42a9785a>] ? video_device_alloc+0x2a/0x40
[    9.555309]  [<42b35117>] m2mtest_probe+0x197/0x430     
[    9.566300] g_ether gadget: reset eem
[    9.566832] usb0: gether_disconnect
[    9.567350] dummy_udc dummy_udc.0: disabled ep1in-bulk
[    9.568222] dummy_udc dummy_udc.0: disabled ep2out-bulk
[    9.569090] g_ether gadget: init eem
[    9.569614] g_ether gadget: activate eem
[    9.570204] dummy_udc dummy_udc.0: enabled ep1in-bulk (ep1in-bulk) maxpacket 512 stream disabled
[    9.571421] dummy_udc dummy_udc.0: enabled ep2out-bulk (ep2out-bulk) maxpacket 512 stream disabled
[    9.572739] usb0: qlen 10
[    9.584457]  [<41389d10>] ? sysfs_do_create_link+0xa0/0xd0
[    9.585389]  [<420a549f>] platform_drv_probe+0x4f/0x150
[    9.586270]  [<420a1d12>] driver_probe_device+0x252/0x5b0
[    9.587034]  [<43395018>] ? mutex_lock_nested+0x68/0x80
[    9.587796]  [<420a21df>] __driver_attach+0x16f/0x1c0
[    9.588544]  [<420a2070>] ? driver_probe_device+0x5b0/0x5b0
[    9.589366]  [<4209d7a4>] bus_for_each_dev+0xe4/0x170
[    9.590098]  [<420a142c>] driver_attach+0x2c/0x40
[    9.597969] cdc_eem 1-1:1.0 usb1: register 'cdc_eem' at usb-dummy_hcd.0-1, CDC EEM Device, d6:43:d6:1b:83:b8
[    9.599758]  [<420a2070>] ? driver_probe_device+0x5b0/0x5b0
[    9.606283]  [<4209f028>] bus_add_driver+0x3f8/0x660
[    9.607097]  [<420a3575>] driver_register+0x125/0x490
[    9.607921]  [<420a6bc0>] platform_driver_register+0xc0/0xd0
[    9.608848]  [<44928d39>] m2mtest_init+0x5f/0xb5
[    9.609607]  [<44928cda>] ? smsdvb_module_init+0xbd/0xbd
[    9.616088]  [<44882a93>] do_one_initcall+0x10a/0x2ce
[    9.616852]  [<44882e9a>] kernel_init_freeable+0x243/0x40a
[    9.617641]  [<448817f3>] ? do_early_param+0x16f/0x16f
[    9.618423]  [<432e5d7e>] kernel_init+0x1e/0x320
[    9.619911]  [<4339edd7>] ret_from_kernel_thread+0x1b/0x28
[    9.620941]  [<432e5d60>] ? rest_init+0x330/0x330
[    9.621791] ---[ end trace 9d702e176aa13169 ]---
[    9.622462] m2m-testdev m2m-testdev.0: Failed to register video device
[    9.623453] m2m-testdev: probe of m2m-testdev.0 failed with error -22

git bisect start 4c5c6fc11ee30ddf47c3772f3b1ec3f76f0e2437 9e895ace5d82df8929b16f58e9f515f6d54ab82d --
git bisect good 0a804654af62dfea4899c66561d74d72273b2921  # 21:13     30+  Bluetooth: Remove unneeded flag
git bisect good 7dd8fbbe50c01ead78483bc42f744d115afec96b  # 21:21     30+  [media] adv7183: fix querystd
git bisect  bad ee17608d6aa04a86e253a9130d6c6d00892f132b  # 21:32      0-  [media] imx074: support asynchronous probing
git bisect good 9592bd0a9e74c344f674663137e5ccff7a39f7d0  # 21:39     30+  [media] zoran: use v4l2_dev instead of the deprecated parent field
git bisect  bad 98505ff9f2fa1a1b33d90d39ab76a54a3b189ee2  # 21:46      0-  [media] soc-camera: remove two unused configs
git bisect  bad 410ca6053e3c216b8ca0b05f45d6cd76b334a459  # 21:51      0-  [media] media: davinci: vpif_capture: move the freeing of irq and global variables to remove()
git bisect  bad 1c1d86a1ea07506c070cfb217a009d53990bdeb0  # 21:56      0-  [media] v4l2: always require v4l2_dev, rename parent to dev_parent
git bisect good a28fbd04facbffe9374f25c3a19c54ce4f186361  # 22:05     30+  [media] pvrusb2: use v4l2_dev instead of the deprecated parent field
git bisect good 7a86969bd65eb7f19ea1c281c686a75429be950a  # 22:13     30+  [media] omap24xxcam: add v4l2_device and replace parent with v4l2_dev
git bisect good d481c581dfe43be11a17728b5c84c2d4b5beecb2  # 22:19     30+  [media] saa7134: use v4l2_dev instead of the deprecated parent field
git bisect good d481c581dfe43be11a17728b5c84c2d4b5beecb2  # 22:26     90+  [media] saa7134: use v4l2_dev instead of the deprecated parent field
git bisect  bad 4c5c6fc11ee30ddf47c3772f3b1ec3f76f0e2437  # 22:26      0-  Merge remote-tracking branch 'regulator/for-next' into devel-xian-i386-201306251905
git bisect good f97f7d2d27bf092b40babda9ded29cc85cf77eec  # 23:11     90+  Merge tag 'spi-v3.10-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi
git bisect good c0a4b933aa6fb8bdc21cb854633ea07779cda2b1  # 02:06     90+  Add linux-next specific files for 20130625

Thanks,
Fengguang

--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-kvm-cairo-17017-20130625202336--
Content-Transfer-Encoding: quoted-printable

[    0.000000] Linux version 3.10.0-rc7-00925-g4c5c6fc (kbuild@xian) (gcc v=
ersion 4.8.1 (Debian 4.8.1-3) ) #6 PREEMPT Tue Jun 25 20:21:07 CST 2013
[    0.000000] KERNEL supported cpus:
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
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
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
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
[    0.000000] initial memory mapped: [mem 0x00000000-0x05ffffff]
[    0.000000] Base memory trampoline at [4009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
[    0.000000]  [mem 0x0e000000-0x0e3fffff] page 4k
[    0.000000] BRK [0x0593e000, 0x0593efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
[    0.000000]  [mem 0x08000000-0x0dffffff] page 4k
[    0.000000] BRK [0x0593f000, 0x0593ffff] PGTABLE
[    0.000000] BRK [0x05940000, 0x05940fff] PGTABLE
[    0.000000] BRK [0x05941000, 0x05941fff] PGTABLE
[    0.000000] BRK [0x05942000, 0x05942fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x07ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
[    0.000000]  [mem 0x0e400000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127876(97%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC=
 00000001)
[    0.000000] ACPI: DSDT 0fffe490 011A9 (v01   BXPC   BXDSDT 00000001 INTL=
 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: APIC 0ffff680 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC=
 00000001)
[    0.000000] ACPI: HPET 0ffff640 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC=
 00000001)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000] free_area_init_node: node 0, pgdat 443fb140, node_mem_map 4e=
4ff024
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 540 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 3f77f80
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64860
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/i386-randconfig-x15-0625/devel-xian-i386-201=
306251905/.vmlinuz-4c5c6fc11ee30ddf47c3772f3b1ec3f76f0e2437-20130625202206-=
4-cairo branch=3Dlinux-devel/devel-xian-i386-201306251905  BOOT_IMAGE=3D/ke=
rnel/i386-randconfig-x15-0625/4c5c6fc11ee30ddf47c3772f3b1ec3f76f0e2437/vmli=
nuz-3.10.0-rc7-00925-g4c5c6fc
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 150472k/262136k available (36479k kernel code, 11127=
2k reserved, 21366k data, 1508k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe0000 - 0xfffff000   ( 124 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x507fe000 - 0xff7fe000   (2800 MB)
[    0.000000]     lowmem  : 0x40000000 - 0x4fffe000   ( 255 MB)
[    0.000000]       .init : 0x44881000 - 0x449fa000   (1508 kB)
[    0.000000]       .data : 0x4339ff99 - 0x4487d7e0   (21366 kB)
[    0.000000]       .text : 0x41000000 - 0x4339ff99   (36479 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3D4d402000 soft=3D4d404000
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
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ODEBUG: 2 of 2 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2893.048 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5786.09 Bogo=
MIPS (lpj=3D28930480)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] Mount-cache hash table entries: 512
[    0.020000] mce: CPU supports 10 MCE banks
[    0.020000] mce: unknown CPU type - not enabling MCE support
[    0.020000] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020000] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020000] tlb_flushall_shift: -1
[    0.020024] CPU: GenuineIntel Common KVM processor (fam: 0f, model: 06, =
stepping: 01)
[    0.034782] ACPI: Core revision 20130328
[    0.066985] ACPI: All ACPI Tables successfully acquired
[    0.067805] ACPI: setting ELCR to 0200 (from 0c00)
[    0.068539] ftrace: allocating 48395 entries in 95 pages
[    0.121186] Performance Events:=20
[    0.123879] ftrace: Allocated trace_printk buffers
[    0.134411] devtmpfs: initialized
[    0.156794] NET: Registered protocol family 16
[    0.164107] ACPI: bus type PCI registered
[    0.167184] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.168283] PCI: Using configuration type 1 for base access
[    0.290958] bio: create slab <bio-0> at 0
[    0.293981] ACPI: Added _OSI(Module Device)
[    0.294565] ACPI: Added _OSI(Processor Device)
[    0.295141] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.295764] ACPI: Added _OSI(Processor Aggregator Device)
[    0.306657] ACPI: EC: Look up EC in DSDT
[    0.366007] ACPI: Interpreter enabled
[    0.366550] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20130328/hwxface-568)
[    0.367785] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20130328/hwxface-568)
[    0.369181] ACPI: (supports S0 S3 S5)
[    0.369661] ACPI: Using PIC for interrupt routing
[    0.370225] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.462580] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.467811] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.470317] PCI host bridge to bus 0000:00
[    0.471145] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.472017] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.473007] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.473935] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.475093] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.476359] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.480666] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.482888] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.488468] pci 0000:00:01.1: reg 20: [io  0xc1e0-0xc1ef]
[    0.493404] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.494858] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.495769] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.497735] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.501223] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.506144] pci 0000:00:02.0: reg 14: [mem 0xfebe0000-0xfebe0fff]
[    0.530074] pci 0000:00:02.0: reg 30: [mem 0xfebc0000-0xfebcffff pref]
[    0.531960] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.534652] pci 0000:00:03.0: reg 10: [io  0xc1c0-0xc1df]
[    0.537341] pci 0000:00:03.0: reg 14: [mem 0xfebe1000-0xfebe1fff]
[    0.549279] pci 0000:00:03.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
[    0.551580] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.554579] pci 0000:00:04.0: reg 10: [mem 0xfeb80000-0xfeb9ffff]
[    0.557363] pci 0000:00:04.0: reg 14: [io  0xc000-0xc03f]
[    0.567454] pci 0000:00:04.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
[    0.570239] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.572824] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    0.575243] pci 0000:00:05.0: reg 14: [mem 0xfebe2000-0xfebe2fff]
[    0.585850] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.588529] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    0.590926] pci 0000:00:06.0: reg 14: [mem 0xfebe3000-0xfebe3fff]
[    0.615431] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.620045] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.623152] pci 0000:00:07.0: reg 14: [mem 0xfebe4000-0xfebe4fff]
[    0.635580] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.638418] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    0.641782] pci 0000:00:08.0: reg 14: [mem 0xfebe5000-0xfebe5fff]
[    0.652923] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.656830] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    0.658917] pci 0000:00:09.0: reg 14: [mem 0xfebe6000-0xfebe6fff]
[    0.668400] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.671725] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    0.674053] pci 0000:00:0a.0: reg 14: [mem 0xfebe7000-0xfebe7fff]
[    0.707303] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    0.709362] pci 0000:00:0b.0: reg 10: [mem 0xfebe8000-0xfebe800f]
[    0.717319] pci_bus 0000:00: on NUMA node 0
[    0.718107] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.741699] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.755604] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.762995] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.771201] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.773540] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.777583] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.778572] acpi root: \_SB_.PCI0 notify handler is installed
[    0.780658] Found 1 acpi root devices
[    0.782753] Error: Driver '88PM80X' is already registered, aborting...
[    0.787792] tps65010: version 2 May 2005
[    0.820289] tps65010: no chip?
[    0.822850] ACPI: bus type USB registered
[    0.823589] usbcore: registered new interface driver usbfs
[    0.829584] usbcore: registered new interface driver hub
[    0.830988] usbcore: registered new device driver usb
[    0.832490] media: Linux media interface: v0.10
[    0.834257] Linux video capture interface: v2.00
[    0.840541] pps_core: LinuxPPS API ver. 1 registered
[    0.841511] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.843518] EDAC MC: Ver: 3.0.0
[    0.846384] PCI: Using ACPI for IRQ routing
[    0.846981] PCI: pci_cache_line_size set to 64 bytes
[    0.848112] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.850112] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.853002] Bluetooth: Core ver 2.16
[    0.853574] NET: Registered protocol family 31
[    0.854162] Bluetooth: HCI device and connection manager initialized
[    0.855040] Bluetooth: HCI socket layer initialized
[    0.855677] Bluetooth: L2CAP socket layer initialized
[    0.856483] Bluetooth: SCO socket layer initialized
[    0.859247] nfc: nfc_init: NFC Core ver 0.1
[    0.860301] NET: Registered protocol family 39
[    0.862803] Switching to clocksource kvm-clock
[    0.870000] cfg80211: Calling CRDA to update world regulatory domain
[    0.870220] Warning: could not register all branches stats
[    0.870990] Warning: could not register annotated branches stats
[    1.360757] pnp: PnP ACPI init
[    1.361187] ACPI: bus type PNP registered
[    1.362001] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.363303] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.364379] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.365328] pnp 00:03: [dma 2]
[    1.365857] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.366900] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.368151] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.370947] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.372751] pnp: PnP ACPI: found 7 devices
[    1.373175] ACPI: bus type PNP unregistered
[    1.412260] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.413006] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.413835] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.414724] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.415743] NET: Registered protocol family 1
[    1.416394] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.417311] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.418110] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.418905] pci 0000:00:02.0: Boot video device
[    1.419751] PCI: CLS 0 bytes, default 64
[    1.421337] Unpacking initramfs...
[    5.326996] debug: unmapping init [mem 0x4e73f000-0x4ffeffff]
[    5.332815] apm: BIOS not found.
[    5.333290] microcode: no support for this CPU vendor
[    5.339304] PCLMULQDQ-NI instructions are not detected.
[    5.340115] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    5.341565] NatSemi SCx200 Driver
[    5.343831] audit: initializing netlink socket (disabled)
[    5.344669] type=3D2000 audit(1372162984.330:1): initialized
[    5.352304] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    5.355912] VFS: Disk quotas dquot_6.5.2
[    5.356330] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    5.359073] NTFS driver 2.1.30 [Flags: R/W DEBUG].
[    5.361017] fuse init (API version 7.22)
[    5.362345] SGI XFS with security attributes, no debug enabled
[    5.365124] NILFS version 2 loaded
[    5.365892] OCFS2 1.5.0
[    5.366757] ocfs2 stack glue: unable to register sysctl
[    5.367553] ocfs2: Registered cluster interface o2cb
[    5.368295] OCFS2 DLMFS 1.5.0
[    5.369150] OCFS2 User DLM kernel interface loaded
[    5.369873] OCFS2 Node Manager 1.5.0
[    5.379208] OCFS2 DLM 1.5.0
[    5.411690] NET: Registered protocol family 38
[    5.412612] Key type asymmetric registered
[    5.413759] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    5.414682] io scheduler noop registered (default)
[    5.415458] io scheduler deadline registered
[    5.417580] io scheduler cfq registered
[    5.427891] test_string_helpers: Running tests...
[    5.429855] crc32: CRC_LE_BITS =3D 32, CRC_BE BITS =3D 32
[    5.430522] crc32: self tests passed, processed 225944 bytes in 541003 n=
sec
[    5.431977] crc32c: CRC_LE_BITS =3D 32
[    5.432437] crc32c: self tests passed, processed 225944 bytes in 397591 =
nsec
[    5.434256] xz_dec_test: module loaded
[    5.434736] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
250 0' and write .xz files to it.
[    5.439416] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.440112] cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
[    5.444070] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver =
version: 0.1
[    5.444813] cpcihp_generic: not configured, disabling.
[    5.446712] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    5.447364] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    5.450252] nvidiafb_setup START
[    5.451776] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    5.454273] vmlfb: initializing
[    5.454979] Could not find Carillo Ranch MCH device.
[    5.456178] no IO addresses supplied
[    5.457456] hgafb: HGA card not detected.
[    5.458109] hgafb: probe of hgafb.0 failed with error -22
[    5.460040] usbcore: registered new interface driver udlfb
[    5.461022] usbcore: registered new interface driver smscufx
[    5.465165] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    5.466514] ACPI: Power Button [PWRF]
[    5.479660] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    5.480413] PCI: setting IRQ 11 as level-triggered
[    5.481817] virtio-pci 0000:00:03.0: setting latency timer to 64
[    5.490529] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    5.491432] PCI: setting IRQ 10 as level-triggered
[    5.493321] virtio-pci 0000:00:05.0: setting latency timer to 64
[    5.504404] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    5.506841] virtio-pci 0000:00:06.0: setting latency timer to 64
[    5.516102] virtio-pci 0000:00:07.0: setting latency timer to 64
[    5.527455] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    5.530354] virtio-pci 0000:00:08.0: setting latency timer to 64
[    5.545617] virtio-pci 0000:00:09.0: setting latency timer to 64
[    5.559184] virtio-pci 0000:00:0a.0: setting latency timer to 64
[    5.889036] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    5.937439] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    5.958440] lp: driver loaded but no devices found
[    5.959124] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    5.960120] ac.o: No PCI boards found.
[    5.960788] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    5.961743] sonypi: Sony Programmable I/O Controller Driver v1.26.
[    5.963049] Non-volatile memory driver v1.3
[    5.966728] ppdev: user-space parallel port driver
[    5.967545] scx200_gpio: no SCx200 gpio present
[    5.968458] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    5.969478] platform pc8736x_gpio.0: no device found
[    5.970369] nsc_gpio initializing
[    5.971233] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    5.973229] Linux agpgart interface v0.103
[    5.979465] [drm] Initialized drm 1.1.0 20060810
[    5.980690] [drm] radeon kernel modesetting enabled.
[    5.989617] [TTM] Zone  kernel: Available graphics memory: 75236 kiB
[    5.990570] [TTM] Initializing pool allocator
[    5.999129] [drm] fb mappable at 0x0
[    5.999697] [drm] vram aper at 0x0
[    6.000189] [drm] size 0
[    6.000583] [drm] fb depth is 24
[    6.001025] [drm]    pitch is 3840
[    6.001568] cirrusdrmfb: enable CONFIG_FB_LITTLE_ENDIAN to support this =
framebuffer
[    6.002705] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on =
minor 0
[    6.005017] usbcore: registered new interface driver udl
[    6.007083] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    6.008475] dummy-irq: no IRQ given.  Use irq=3DN
[    6.010248] lkdtm: No crash points registered, enable through debugfs
[    6.011577] Phantom Linux Driver, version n0.9.8, init OK
[    6.013882] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    6.015945] c2port c2port0: C2 port uc added
[    6.016617] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    6.025131] usbcore: registered new interface driver viperboard
[    6.026091] Uniform Multi-Platform E-IDE driver
[    6.027200] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[    6.028460] piix 0000:00:01.1: not 100% native mode: will probe irqs lat=
er
[    6.033791] pci 0000:00:01.1: setting latency timer to 64
[    6.035225]     ide0: BM-DMA at 0xc1e0-0xc1e7
[    6.036137]     ide1: BM-DMA at 0xc1e8-0xc1ef
[    6.036770] Probing IDE interface ide0...
[    6.386003] tsc: Refined TSC clocksource calibration: 2893.022 MHz
[    6.646227] Probing IDE interface ide1...
[    7.445790] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[    8.230880] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[    8.232073] hdc: MWDMA2 mode selected
[    8.232948] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    8.233754] ide1 at 0x170-0x177,0x376 on irq 15
[    8.258739] ide-gd driver 1.18
[    8.263875] SSFDC read-only Flash Translation layer
[    8.265731] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    8.267020] Could not find PAR responsible for SC520CDP Flash Bank #1
[    8.267981] Trying default address 0x8c00000
[    8.268629] SC520 CDP flash device: 0x800000 at 0x8800000
[    8.270666] Failed to ioremap_nocache
[    8.271282] NetSc520 flash device: 0x100000 at 0x200000
[    8.272078] Failed to ioremap_nocache
[    8.373317] spi_ks8995: Micrel KS8995 Ethernet switch SPI driver version=
 0.1.1
[    8.375018] tun: Universal TUN/TAP device driver, 1.6
[    8.390551] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    8.399343] arcnet loaded.
[    8.399791] arcnet: RFC1201 "standard" (`a') encapsulation support loade=
d.
[    8.400841] arcnet: raw mode (`r') encapsulation support loaded.
[    8.401768] arcnet: cap mode (`c') encapsulation support loaded.
[    8.402721] arcnet: COM90xx chipset support
[    8.732112] S3: No ARCnet cards found.
[    8.732915] arcnet: COM90xx IO-mapped mode support (by David Woodhouse e=
t el.)
[    8.734173] E-mail me if you actually test this driver, please!
[    8.735199]  arc%d: No autoprobe for IO mapped cards; you must specify t=
he base address!
[    8.737853] arcnet: COM20020 PCI support
[    8.739596] ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2.2
[    8.740999] ipw2100: Copyright(c) 2003-2006 Intel Corporation
[    8.742073] libipw: 802.11 data/management/control stack, git-1.1.13
[    8.743000] libipw: Copyright (C) 2004-2005 Intel Corporation <jketreno@=
linux.intel.com>
[    8.744205] orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, P=
avel Roskin <proski@gnu.org>, et al)
[    8.746765] orinoco_pci 0.15 (Pavel Roskin <proski@gnu.org>, David Gibso=
n <hermes@gibson.dropbear.id.au> & Jean Tourrilhes <jt@hpl.hp.com>)
[    8.749547] orinoco_tmd 0.15 (Joerg Dorchain <joerg@dorchain.net>)
[    8.750493] orinoco_nortel 0.15 (Tobias Hoffmann & Christoph Jungegger <=
disdos@traum404.de>)
[    8.751857] usbcore: registered new interface driver orinoco_usb
[    8.752639] airo(): Probing for PCI adapters
[    8.753334] airo(): Finished probing for PCI adapters
[    8.754900] Atmel at76x USB Wireless LAN Driver 0.17 loading
[    8.755889] usbcore: registered new interface driver at76c50x-usb
[    8.756764] Loaded prism54 driver, version 1.2
[    8.758555] Broadcom 43xx driver loaded [ Features: PMNLS ]
[    8.759500] usbcore: registered new interface driver rtl8187
[    8.761537] usbcore: registered new interface driver rndis_wlan
[    8.762796] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection=
 driver for Linux, in-tree:s
[    8.764032] iwl3945: Copyright(c) 2003-2011 Intel Corporation
[    8.766563] usbcore: registered new interface driver rt73usb
[    8.767787] usbcore: registered new interface driver carl9170
[    8.768669] usbcore: registered new interface driver ath6kl_usb
[    8.769964] usbcore: registered new interface driver usb8797
[    8.771540] usbcore: registered new interface driver brcmfmac
[    8.772509] usbcore: registered new interface driver i2400m_usb
[    8.773459] usbcore: registered new interface driver kaweth
[    8.774348] usbcore: registered new interface driver rtl8150
[    8.775226] usbcore: registered new interface driver r8152
[    8.777005] usbcore: registered new interface driver asix
[    8.778046] usbcore: registered new interface driver ax88179_178a
[    8.779071] usbcore: registered new interface driver cdc_ether
[    8.779993] usbcore: registered new interface driver cdc_eem
[    8.780920] usbcore: registered new interface driver smsc95xx
[    8.781836] usbcore: registered new interface driver gl620a
[    8.783620] usbcore: registered new interface driver net1080
[    8.784528] usbcore: registered new interface driver plusb
[    8.785447] usbcore: registered new interface driver rndis_host
[    8.786748] usbcore: registered new interface driver cdc_subset
[    8.787691] usbcore: registered new interface driver zaurus
[    8.788552] usbcore: registered new interface driver MOSCHIP usb-etherne=
t driver
[    8.790390] usbcore: registered new interface driver int51x1
[    8.791299] usbcore: registered new interface driver cdc_phonet
[    8.792245] usbcore: registered new interface driver kalmia
[    8.793185] usbcore: registered new interface driver ipheth
[    8.794071] usbcore: registered new interface driver cdc_ncm
[    8.794977] usbcore: registered new interface driver qmi_wwan
[    8.796887] Generic UIO driver for PCI 2.3 devices version: 0.01.0
[    8.799614] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    8.800572] ehci-pci: EHCI PCI platform driver
[    8.801421] ehci-platform: EHCI generic platform driver
[    8.802493] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    8.804373] uhci_hcd: USB Universal Host Controller Interface driver
[    8.806297] driver u132_hcd
[    8.808423] usbcore: registered new interface driver wusb-cbaf
[    8.809319] usbcore: registered new interface driver usblp
[    8.810179] usbcore: registered new interface driver cdc_wdm
[    8.811034] usbcore: registered new interface driver usbtmc
[    8.812593] usbcore: registered new interface driver appledisplay
[    8.813536] usbcore: registered new interface driver cypress_cy7c63
[    8.814491] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    8.815553] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    8.816884] driver ftdi-elan
[    8.818669] usbcore: registered new interface driver ftdi-elan
[    8.819565] usbcore: registered new interface driver idmouse
[    8.820543] usbcore: registered new interface driver isight_firmware
[    8.821561] usbcore: registered new interface driver usbled
[    8.822565] usbcore: registered new interface driver legousbtower
[    8.823541] usbcore: registered new interface driver trancevibrator
[    8.824713] usbcore: registered new interface driver uss720
[    8.825480] uss720: v0.6:USB Parport Cable driver for Cables using the L=
ucent Technologies USS720 Chip
[    8.826958] uss720: NOTE: this is a special purpose driver to allow nons=
tandard
[    8.827957] uss720: protocols (eg. bitbang) over USS720 usb to parallel =
cables
[    8.828929] uss720: If you just want to connect to a printer, use usblp =
instead
[    8.830005] usbcore: registered new interface driver usbsevseg
[    8.831324] usbcore: registered new interface driver yurex
[    8.832177] usbcore: registered new interface driver sisusb
[    8.834673] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 M=
ay 2005
[    8.837121] dummy_hcd dummy_hcd.0: Dummy host controller
[    8.838435] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus =
number 1
[    8.842134] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    8.843064] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    8.844038] usb usb1: Product: Dummy host controller
[    8.844718] usb usb1: Manufacturer: Linux 3.10.0-rc7-00925-g4c5c6fc dumm=
y_hcd
[    8.848580] usb usb1: SerialNumber: dummy_hcd.0
[    8.854314] hub 1-0:1.0: USB hub found
[    8.855122] hub 1-0:1.0: 1 port detected
[    8.861680] udc dummy_udc.0: registering UDC driver [g_ether]
[    8.862717] g_ether gadget: using random self ethernet address
[    8.863507] g_ether gadget: using random host ethernet address
[    8.866025] usb0: MAC b2:29:e4:f3:c1:d8
[    8.866556] usb0: HOST MAC e2:90:c4:b4:dc:09
[    8.867188] g_ether gadget: adding config #2 'RNDIS'/442ce180
[    8.867945] g_ether gadget: adding 'rndis'/461ddda8 to config 'RNDIS'/44=
2ce180
[    8.869188] rndis_register: configNr =3D 0
[    8.869716] rndis_set_param_medium: 0 0
[    8.870251] g_ether gadget: RNDIS: super speed IN/ep1in-bulk OUT/ep2out-=
bulk NOTIFY/ep5in-int
[    8.871355] g_ether gadget: cfg 2/442ce180 speeds: super high full
[    8.872166] g_ether gadget:   interface 0 =3D rndis/461ddda8
[    8.872876] g_ether gadget:   interface 1 =3D rndis/461ddda8
[    8.873597] g_ether gadget: adding config #1 'CDC Ethernet (EEM)'/442ce1=
00
[    8.874662] g_ether gadget: adding 'cdc_eem'/461de0a0 to config 'CDC Eth=
ernet (EEM)'/442ce100
[    8.876331] g_ether gadget: CDC Ethernet (EEM): super speed IN/ep1in-bul=
k OUT/ep2out-bulk
[    8.877439] g_ether gadget: cfg 1/442ce100 speeds: super high full
[    8.878293] g_ether gadget:   interface 0 =3D cdc_eem/461de0a0
[    8.879218] g_ether gadget: Ethernet Gadget, version: Memorial Day 2008
[    8.880355] g_ether gadget: g_ether ready
[    8.881049] dummy_udc dummy_udc.0: binding gadget driver 'g_ether'
[    8.882098] dummy_udc dummy_udc.0: This device can perform faster if you=
 connect it to a super-speed port...
[    8.883775] dummy_hcd dummy_hcd.0: port status 0x00010101 has changes
[    8.885432] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    8.890074] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.892730] serio: i8042 AUX port at 0x60,0x64 irq 12
[    8.893986] parkbd: no such parport
[    8.960606] dummy_hcd dummy_hcd.0: port status 0x00010101 has changes
[    9.056201] mousedev: PS/2 mouse device common for all mice
[    9.063562] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    9.065600] usbcore: registered new interface driver usb_acecad
[    9.066804] usbcore: registered new interface driver gtco
[    9.068452] usbcore: registered new interface driver hanwang
[    9.069812] usbcore: registered new interface driver kbtab
[    9.070812] usbcore: registered new interface driver wacom
[    9.071536] I2O subsystem v1.325
[    9.071966] i2o: max drivers =3D 8
[    9.075081] I2O Configuration OSM v1.323
[    9.077416] I2O Bus Adapter OSM v1.317
[    9.078016] I2O ProcFS OSM v1.316
[    9.078718] i2c /dev entries driver
[    9.081233] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[    9.125811] g_ether gadget: resume
[    9.126441] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[    9.185842] usb 1-1: new high-speed USB device number 2 using dummy_hcd
[    9.255841] g_ether gadget: resume
[    9.256484] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[    9.326430] dummy_udc dummy_udc.0: set_address =3D 2
[    9.376632] usbcore: registered new interface driver i2c-diolan-u2c
[    9.377635] i2c-parport-light: adapter type unspecified
[    9.378586] usbcore: registered new interface driver i2c-tiny-usb
[    9.380236] scx200_i2c: no SCx200 gpio pins available
[    9.436372] usbcore: registered new interface driver ati_remote
[    9.438009] usbcore: registered new interface driver imon
[    9.438944] usbcore: registered new interface driver streamzap
[    9.459911] Registered IR keymap rc-empty
[    9.462823] input: rc-core loopback device as /devices/virtual/rc/rc0/in=
put2
[    9.464518] rc0: rc-core loopback device as /devices/virtual/rc/rc0
[    9.466975] usbcore: registered new interface driver iguanair
[    9.492181] usbcore: registered new interface driver ttusbir
[    9.492988] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver c=
hip loaded successfully
[    9.494772] ------------[ cut here ]------------
[    9.500661] WARNING: at /c/kernel-tests/src/linux/drivers/media/v4l2-cor=
e/v4l2-dev.c:775 __video_register_device+0x6a3/0x10d0()
[    9.502258] CPU: 0 PID: 1 Comm: swapper Not tainted 3.10.0-rc7-00925-g4c=
5c6fc #6
[    9.503283] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    9.504080]  00000000 4d485dc0 4333ff21 4d485de8 410772f7 43d6e3a5 43ee5=
9d4 00000307
[    9.505368]  42a98273
[    9.510546] usb 1-1: New USB device found, idVendor=3D0525, idProduct=3D=
a4a2
[    9.511662] usb 1-1: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    9.512829] usb 1-1: Product: RNDIS/Ethernet Gadget
[    9.513653] usb 1-1: Manufacturer: Linux 3.10.0-rc7-00925-g4c5c6fc with =
dummy_udc
 42a98273 461ffba8 00000001 00000000 4d485df8 4107749e 00000009
[    9.523915]  00000000 4d485e30 42a98273 43e25cca 4d485e1c 000002b8 461ff=
ba8 42a9785a
[    9.525292] Call Trace:
[    9.530458] g_ether gadget: high-speed config #1: CDC Ethernet (EEM)
[    9.531539] g_ether gadget: init eem
[    9.532137] g_ether gadget: activate eem
[    9.532785] dummy_udc dummy_udc.0: enabled ep1in-bulk (ep1in-bulk) maxpa=
cket 512 stream disabled
[    9.540286] dummy_udc dummy_udc.0: enabled ep2out-bulk (ep2out-bulk) max=
packet 512 stream disabled
[    9.540341] usb0: qlen 10
[    9.544395]  [<4333ff21>] dump_stack+0x32/0x42
[    9.545097]  [<410772f7>] warn_slowpath_common+0xb7/0x100
[    9.551112]  [<42a98273>] ? __video_register_device+0x6a3/0x10d0
[    9.551979]  [<42a98273>] ? __video_register_device+0x6a3/0x10d0
[    9.552834]  [<4107749e>] warn_slowpath_null+0x3e/0x50
[    9.553571]  [<42a98273>] __video_register_device+0x6a3/0x10d0
[    9.554440]  [<42a9785a>] ? video_device_alloc+0x2a/0x40
[    9.555309]  [<42b35117>] m2mtest_probe+0x197/0x430
[    9.566300] g_ether gadget: reset eem
[    9.566832] usb0: gether_disconnect
[    9.567350] dummy_udc dummy_udc.0: disabled ep1in-bulk
[    9.568222] dummy_udc dummy_udc.0: disabled ep2out-bulk
[    9.569090] g_ether gadget: init eem
[    9.569614] g_ether gadget: activate eem
[    9.570204] dummy_udc dummy_udc.0: enabled ep1in-bulk (ep1in-bulk) maxpa=
cket 512 stream disabled
[    9.571421] dummy_udc dummy_udc.0: enabled ep2out-bulk (ep2out-bulk) max=
packet 512 stream disabled
[    9.572739] usb0: qlen 10
[    9.584457]  [<41389d10>] ? sysfs_do_create_link+0xa0/0xd0
[    9.585389]  [<420a549f>] platform_drv_probe+0x4f/0x150
[    9.586270]  [<420a1d12>] driver_probe_device+0x252/0x5b0
[    9.587034]  [<43395018>] ? mutex_lock_nested+0x68/0x80
[    9.587796]  [<420a21df>] __driver_attach+0x16f/0x1c0
[    9.588544]  [<420a2070>] ? driver_probe_device+0x5b0/0x5b0
[    9.589366]  [<4209d7a4>] bus_for_each_dev+0xe4/0x170
[    9.590098]  [<420a142c>] driver_attach+0x2c/0x40
[    9.597969] cdc_eem 1-1:1.0 usb1: register 'cdc_eem' at usb-dummy_hcd.0-=
1, CDC EEM Device, d6:43:d6:1b:83:b8
[    9.599758]  [<420a2070>] ? driver_probe_device+0x5b0/0x5b0
[    9.606283]  [<4209f028>] bus_add_driver+0x3f8/0x660
[    9.607097]  [<420a3575>] driver_register+0x125/0x490
[    9.607921]  [<420a6bc0>] platform_driver_register+0xc0/0xd0
[    9.608848]  [<44928d39>] m2mtest_init+0x5f/0xb5
[    9.609607]  [<44928cda>] ? smsdvb_module_init+0xbd/0xbd
[    9.616088]  [<44882a93>] do_one_initcall+0x10a/0x2ce
[    9.616852]  [<44882e9a>] kernel_init_freeable+0x243/0x40a
[    9.617641]  [<448817f3>] ? do_early_param+0x16f/0x16f
[    9.618423]  [<432e5d7e>] kernel_init+0x1e/0x320
[    9.619911]  [<4339edd7>] ret_from_kernel_thread+0x1b/0x28
[    9.620941]  [<432e5d60>] ? rest_init+0x330/0x330
[    9.621791] ---[ end trace 9d702e176aa13169 ]---
[    9.622462] m2m-testdev m2m-testdev.0: Failed to register video device
[    9.623453] m2m-testdev: probe of m2m-testdev.0 failed with error -22
[    9.636644] nGene PCIE bridge driver, Copyright (C) 2005-2007 Micronas
[    9.637882] saa7146: register extension 'Multimedia eXtension Board'
[    9.639085] saa7146: register extension 'hexium HV-PCI6 Orion'
[    9.640259] saa7146: register extension 'hexium gemini'
[    9.641245] ivtv: Start initialization, version 1.4.3
[    9.642202] ivtv: End initialization
[    9.642732] Zoran MJPEG board driver version 0.10.1
[    9.644675] Linux video codec intermediate layer: v0.2
[    9.645478] cx88/0: cx2388x v4l2 driver version 0.0.9 loaded
[    9.656740] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.9 loaded
[    9.657880] cx2388x blackbird driver version 0.0.9 loaded
[    9.658663] cx88/2: registering cx8802 driver, type: blackbird access: s=
hared
[    9.659784] bttv: driver version 0.9.19 loaded
[    9.661248] bttv: using 8 buffers with 2080k (520 pages) each for capture
[    9.662229] bttv: Host bridge needs ETBF enabled
[    9.663507] saa7164 driver loaded
[    9.671485] smssdio: Siano SMS1xxx SDIO driver
[    9.672075] smssdio: Copyright Pierre Ossman
[    9.672851] usbcore: registered new interface driver radioshark2
[    9.673726] usbcore: registered new interface driver dsbr100
[    9.674562] usbcore: registered new interface driver radio-keene
[    9.682115] pps_parport: parallel port PPS client
[    9.682842] Driver for 1-wire Dallas network protocol.
[    9.684753] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    9.704571] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[   10.119344] i2c i2c-0: w83795: Detection failed at addr 0x2c, check bank
[   10.165865] i2c i2c-0: w83795: Detection failed at addr 0x2d, check bank
[   10.205854] i2c i2c-0: w83795: Detection failed at addr 0x2e, check bank
[   10.265858] i2c i2c-0: w83795: Detection failed at addr 0x2f, check bank
[   10.330357] i2c i2c-0: Detection of w83781d chip failed at step 3
[   10.375839] i2c i2c-0: Detection of w83781d chip failed at step 3
[   10.435847] i2c i2c-0: Detection of w83781d chip failed at step 3
[   10.495824] i2c i2c-0: Detection of w83781d chip failed at step 3
[   10.535797] i2c i2c-0: Detection of w83781d chip failed at step 3
[   10.580345] i2c i2c-0: Detection of w83781d chip failed at step 3
[   10.618584] i2c i2c-0: Detection of w83781d chip failed at step 3
[   10.655757] i2c i2c-0: Detection of w83781d chip failed at step 3
[   10.695799] i2c i2c-0: ADM1025 detection failed at 0x2c
[   10.736428] i2c i2c-0: ADM1025 detection failed at 0x2d
[   10.775810] i2c i2c-0: ADM1025 detection failed at 0x2e
[   10.835809] i2c i2c-0: Detecting device at 0,0x2c with COMPANY: 0xff and=
 VERSTEP: 0xff
[   10.839475] i2c i2c-0: Autodetecting device at 0,0x2c...
[   10.840605] i2c i2c-0: Autodetection failed
[   10.895825] i2c i2c-0: Detecting device at 0,0x2d with COMPANY: 0xff and=
 VERSTEP: 0xff
[   10.899043] i2c i2c-0: Autodetecting device at 0,0x2d...
[   10.899957] i2c i2c-0: Autodetection failed
[   10.961314] i2c i2c-0: Detecting device at 0,0x2e with COMPANY: 0xff and=
 VERSTEP: 0xff
[   10.962593] i2c i2c-0: Autodetecting device at 0,0x2e...
[   10.963410] i2c i2c-0: Autodetection failed
[   12.046757]  (null): Wrong manufacturer ID. Got 255, expected 65
[   12.088330]  (null): Wrong manufacturer ID. Got 255, expected 65
[   12.145800]  (null): Wrong manufacturer ID. Got 255, expected 65
[   12.566783] applesmc: supported laptop not found!
[   12.567563] applesmc: driver init failed (ret=3D-19)!
[   13.405776]  (null): Unknown chip type, skipping
[   13.445784]  (null): Unknown chip type, skipping
[   26.776206] i2c i2c-0: LM83 detection failed at 0x18
[   26.818451] i2c i2c-0: LM83 detection failed at 0x19
[   26.859965] i2c i2c-0: LM83 detection failed at 0x1a
[   26.897155] i2c i2c-0: LM83 detection failed at 0x29
[   26.936279] i2c i2c-0: LM83 detection failed at 0x2a
[   26.978612] i2c i2c-0: LM83 detection failed at 0x2b
[   27.021185] i2c i2c-0: LM83 detection failed at 0x4c
[   27.055616] i2c i2c-0: LM83 detection failed at 0x4d
[   27.101875] i2c i2c-0: LM83 detection failed at 0x4e
[   27.158745] i2c i2c-0: Detecting device at 0x2c with COMPANY: 0xff and V=
ERSTEP: 0xff
[   27.159935] i2c i2c-0: Autodetection failed: unsupported version
[   27.234876] i2c i2c-0: Detecting device at 0x2d with COMPANY: 0xff and V=
ERSTEP: 0xff
[   27.249309] i2c i2c-0: Autodetection failed: unsupported version
[   27.315889] i2c i2c-0: Detecting device at 0x2e with COMPANY: 0xff and V=
ERSTEP: 0xff
[   27.317233] i2c i2c-0: Autodetection failed: unsupported version
[   27.536233] i2c i2c-0: Unsupported chip at 0x18 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   27.654387] i2c i2c-0: Unsupported chip at 0x19 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   27.749616] i2c i2c-0: Unsupported chip at 0x1a (man_id=3D0xFF, chip_id=
=3D0xFF)
[   27.846524] i2c i2c-0: Unsupported chip at 0x29 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   27.949163] i2c i2c-0: Unsupported chip at 0x2a (man_id=3D0xFF, chip_id=
=3D0xFF)
[   28.047228] i2c i2c-0: Unsupported chip at 0x2b (man_id=3D0xFF, chip_id=
=3D0xFF)
[   28.186609] i2c i2c-0: Unsupported chip at 0x48 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   28.304177] i2c i2c-0: Unsupported chip at 0x49 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   28.401552] i2c i2c-0: Unsupported chip at 0x4a (man_id=3D0xFF, chip_id=
=3D0xFF)
[   28.499662] i2c i2c-0: Unsupported chip at 0x4b (man_id=3D0xFF, chip_id=
=3D0xFF)
[   28.596504] i2c i2c-0: Unsupported chip at 0x4c (man_id=3D0xFF, chip_id=
=3D0xFF)
[   28.710791] i2c i2c-0: Unsupported chip at 0x4d (man_id=3D0xFF, chip_id=
=3D0xFF)
[   28.820327] i2c i2c-0: Unsupported chip at 0x4e (man_id=3D0xFF, chip_id=
=3D0xFF)
[   28.925597] i2c i2c-0: Unsupported chip at 0x4f (man_id=3D0xFF, chip_id=
=3D0xFF)
[   29.378171] i2c i2c-0: MAX1619 detection failed at 0x18
[   29.468123] i2c i2c-0: MAX1619 detection failed at 0x19
[   29.589668] i2c i2c-0: MAX1619 detection failed at 0x1a
[   29.682985] i2c i2c-0: MAX1619 detection failed at 0x29
[   29.780882] i2c i2c-0: MAX1619 detection failed at 0x2a
[   29.870616] i2c i2c-0: MAX1619 detection failed at 0x2b
[   29.966104] i2c i2c-0: MAX1619 detection failed at 0x4c
[   30.068912] i2c i2c-0: MAX1619 detection failed at 0x4d
[   30.160130] i2c i2c-0: MAX1619 detection failed at 0x4e
[   31.109014] pc87360: PC8736x not detected, module not inserted
[   31.141614] thmc50: Probing for THMC50 at 0x2C on bus 0
[   31.247164] thmc50: Probing for THMC50 at 0x2D on bus 0
[   31.337743] thmc50: Probing for THMC50 at 0x2E on bus 0
[   31.578715] i2c i2c-0: w83l785ts: Read 0xff from register 0x40.
[   31.579518] i2c i2c-0: W83L785TS-S detection failed at 0x2e
[   31.628367] i2c i2c-0: W83L786NG detection failed at 0x2e
[   31.666202] i2c i2c-0: W83L786NG detection failed at 0x2f
[   31.667223] usbcore: registered new interface driver bpa10x
[   31.675303] usbcore: registered new interface driver bfusb
[   31.677800] usbcore: registered new interface driver btusb
[   31.678591] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[   31.686941] usbcore: registered new interface driver ath3k
[   31.702449] cpufreq-nforce2: No nForce2 chipset.
[   31.703189] cpuidle: using governor ladder
[   31.703863] wbsd: Winbond W83L51xD SD/MMC card interface driver
[   31.708989] wbsd: Copyright(c) Pierre Ossman
[   31.715780] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0400
[   31.725617] usbcore: registered new interface driver vub300
[   31.726567] usbcore: registered new interface driver ushc
[   31.741625] leds_ss4200: no LED devices found
[   31.743553] ledtrig-cpu: registered to indicate activity on CPUs
[   31.749318] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[   31.752277] Driver for HIFN 795x crypto accelerator chip has been succes=
sfully registered.
[   31.753559] cs5535-clockevt: Could not allocate MFGPT timer
[   31.762199] hidraw: raw HID events driver (C) Jiri Kosina
[   31.788792] usbcore: registered new interface driver usbhid
[   31.789893] usbhid: USB HID core driver
[   31.813332] oprofile: using timer interrupt.
[   31.818174] pktgen: Packet Generator for packet performance testing. Ver=
sion: 2.74
[   31.821366] NET: Registered protocol family 26
[   31.822466] Ebtables v2.0 registered
[   31.823965] NET: Registered protocol family 4
[   31.825262] NET: Registered protocol family 5
[   31.826061] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   31.826956] Bluetooth: HIDP socket layer initialized
[   31.827759] NET: Registered protocol family 35
[   31.829172] 8021q: 802.1Q VLAN Support v1.8
[   31.830170] lib80211: common routines for IEEE802.11 drivers
[   31.831293] lib80211_crypt: registered algorithm 'NULL'
[   31.832185] lib80211_crypt: registered algorithm 'WEP'
[   31.832880] lib80211_crypt: registered algorithm 'CCMP'
[   31.833598] lib80211_crypt: registered algorithm 'TKIP'
[   31.835363] NET: Registered protocol family 37
[   31.836656] Key type dns_resolver registered
[   31.838881] batman_adv: B.A.T.M.A.N. advanced 2013.2.0 (compatibility ve=
rsion 14) loaded
[   31.845729] openvswitch: Open vSwitch switching datapath
[   31.856071] registered taskstats version 1
[   31.857299] Key type trusted registered
[   31.858696] Key type encrypted registered
[   31.868575] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   31.876239] EDD information not available.
[   31.895253] debug: unmapping init [mem 0x44881000-0x449f9fff]
[   31.904422] Write protecting the kernel text: 36480k
[   31.909410] Write protecting the kernel read-only data: 12024k
mountall: ply-event-loop.c:497: ply_event_loop_new: Assertion `loop->epoll_=
fd >=3D 0' failed.
General error mounting filesystems.
A maintenance shell will now be started.
CONTROL-D will terminate this shell and reboot the system.
wfg: rebooting
[   32.575457] Unregister pv shared memory for cpu 0
[   32.628296] Restarting system.
[   32.629859] reboot: machine restart
Elapsed time: 45
qemu-system-x86_64-cpukvm64-enable-kvm-kernel/tmp//kernel/i386-randconfig-x=
15-0625/4c5c6fc11ee30ddf47c3772f3b1ec3f76f0e2437/vmlinuz-3.10.0-rc7-00925-g=
4c5c6fc-17017-append'hung_task_panic=3D1 rcutree.rcu_cpu_stall_timeout=3D10=
0 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_p=
rintk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,1=
15200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests=
/run-queue/kvm/i386-randconfig-x15-0625/devel-xian-i386-201306251905/.vmlin=
uz-4c5c6fc11ee30ddf47c3772f3b1ec3f76f0e2437-20130625202206-4-cairo branch=
=3Dlinux-devel/devel-xian-i386-201306251905  BOOT_IMAGE=3D/kernel/i386-rand=
config-x15-0625/4c5c6fc11ee30ddf47c3772f3b1ec3f76f0e2437/vmlinuz-3.10.0-rc7=
-00925-g4c5c6fc'-initrd/kernel-tests/initrd/quantal-core-i386.cgz-m256M-smp=
2-netnic,vlan=3D0,macaddr=3D00:00:00:00:00:00,model=3Dvirtio-netuser,vlan=
=3D0,hostfwd=3Dtcp::21113-:22-netnic,vlan=3D1,model=3De1000-netuser,vlan=3D=
1-bootorder=3Dnc-no-reboot-watchdogi6300esb-drivefile=3D/fs/LABEL=3DKVM/dis=
ka-cairo-17017,media=3Ddisk,if=3Dvirtio-drivefile=3D/fs/LABEL=3DKVM/diskb-c=
airo-17017,media=3Ddisk,if=3Dvirtio-drivefile=3D/fs/LABEL=3DKVM/diskc-cairo=
-17017,media=3Ddisk,if=3Dvirtio-drivefile=3D/fs/LABEL=3DKVM/diskd-cairo-170=
17,media=3Ddisk,if=3Dvirtio-drivefile=3D/fs/LABEL=3DKVM/diske-cairo-17017,m=
edia=3Ddisk,if=3Dvirtio-drivefile=3D/fs/LABEL=3DKVM/diskf-cairo-17017,media=
=3Ddisk,if=3Dvirtio-pidfile/dev/shm/kboot/pid-cairo-lkp-17017-serialfile:/d=
ev/shm/kboot/serial-cairo-lkp-17017-daemonize-displaynone-monitornull

--i0/AhcQY5QxfSsSZ
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-4c5c6fc11ee30ddf47c3772f3b1ec3f76f0e2437-i386-randconfig-x15-0625-__video_register_device+-x-99051.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDllODk1YWNlNWQ4MmRmODkyOWIxNmY1OGU5ZjUxNWY2ZDU0YWI4MmQK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgNGM1YzZmYy4uLiBNZXJnZSByZW1vdGUtdHJh
Y2tpbmcgYnJhbmNoICdyZWd1bGF0b3IvZm9yLW5leHQnIGludG8gZGV2ZWwteGlhbi1pMzg2
LTIwMTMwNjI1MTkwNQpIRUFEIGlzIG5vdyBhdCA5ZTg5NWFjLi4uIExpbnV4IDMuMTAtcmM3
CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWcteDE1
LTA2MjUvbGludXgtZGV2ZWw6ZGV2ZWwteGlhbi1pMzg2LTIwMTMwNjI1MTkwNTo5ZTg5NWFj
ZTVkODJkZjg5MjliMTZmNThlOWY1MTVmNmQ1NGFiODJkOmJpc2VjdC1uZXQKCjIwMTMtMDYt
MjUtMjA6NTU6NTggOWU4OTVhY2U1ZDgyZGY4OTI5YjE2ZjU4ZTlmNTE1ZjZkNTRhYjgyZCBy
ZXVzZSAva2VybmVsL2kzODYtcmFuZGNvbmZpZy14MTUtMDYyNS85ZTg5NWFjZTVkODJkZjg5
MjliMTZmNThlOWY1MTVmNmQ1NGFiODJkL3ZtbGludXotMy4xMC4wLXJjNwoKMjAxMy0wNi0y
NS0yMDo1NTo1OCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4JMTEJMTMJMjQJMjgJMzAgU1VD
Q0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCA5ZTg5NWFjZTVkODJkZjg5MjliMTZmNThlOWY1
MTVmNmQ1NGFiODJkCmdpdCBiaXNlY3Qgc3RhcnQgNGM1YzZmYzExZWUzMGRkZjQ3YzM3NzJm
M2IxZWMzZjc2ZjBlMjQzNyA5ZTg5NWFjZTVkODJkZjg5MjliMTZmNThlOWY1MTVmNmQ1NGFi
ODJkIC0tClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDllODk1YWMuLi4gTGludXggMy4x
MC1yYzcKU3dpdGNoZWQgdG8gYnJhbmNoICdtYXN0ZXInCllvdXIgYnJhbmNoIGlzIGJlaGlu
ZCAnb3JpZ2luL21hc3RlcicgYnkgMzA0OCBjb21taXRzLCBhbmQgY2FuIGJlIGZhc3QtZm9y
d2FyZGVkLgpCaXNlY3Rpbmc6IDQ2MiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgOSBzdGVwcykKWzBhODA0NjU0YWY2MmRmZWE0ODk5YzY2NTYxZDc0ZDcy
MjczYjI5MjFdIEJsdWV0b290aDogUmVtb3ZlIHVubmVlZGVkIGZsYWcKZ2l0IGJpc2VjdCBy
dW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93
ZmcvbmV0L29iai1iaXNlY3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9uZXQvb2JqLWJpc2VjdApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXgxNS0wNjI1L2xpbnV4LWRl
dmVsOmRldmVsLXhpYW4taTM4Ni0yMDEzMDYyNTE5MDU6MGE4MDQ2NTRhZjYyZGZlYTQ4OTlj
NjY1NjFkNzRkNzIyNzNiMjkyMTpiaXNlY3QtbmV0CgoyMDEzLTA2LTI1LTIxOjAwOjEzIDBh
ODA0NjU0YWY2MmRmZWE0ODk5YzY2NTYxZDc0ZDcyMjczYjI5MjEgY29tcGlsaW5nCjM3NyBy
ZWFsICAzMzQxIHVzZXIgIDIwMiBzeXMgIDkzOC41NiUgY3B1IAlpMzg2LXJhbmRjb25maWct
eDE1LTA2MjUKCjIwMTMtMDYtMjUtMjE6MDY6NTAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4x
MC4wLXJjMS0wMDU0NC1nMGE4MDQ2NS4uLgkyCTYJOAk5LgkxNgkxOAkyMgkyNQkzMCBTVUND
RVNTCgpCaXNlY3Rpbmc6IDIzMSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgOCBzdGVwcykKWzdkZDhmYmJlNTBjMDFlYWQ3ODQ4M2JjNDJmNzQ0ZDExNWFm
ZWM5NmJdIFttZWRpYV0gYWR2NzE4MzogZml4IHF1ZXJ5c3RkCnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbmV0L29iai1i
aXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZp
Zy14MTUtMDYyNS9saW51eC1kZXZlbDpkZXZlbC14aWFuLWkzODYtMjAxMzA2MjUxOTA1Ojdk
ZDhmYmJlNTBjMDFlYWQ3ODQ4M2JjNDJmNzQ0ZDExNWFmZWM5NmI6YmlzZWN0LW5ldAoKMjAx
My0wNi0yNS0yMToxMzoyMiA3ZGQ4ZmJiZTUwYzAxZWFkNzg0ODNiYzQyZjc0NGQxMTVhZmVj
OTZiIGNvbXBpbGluZwoxMDEgcmVhbCAgNzc0IHVzZXIgIDQ4IHN5cyAgODA3LjYxJSBjcHUg
CWkzODYtcmFuZGNvbmZpZy14MTUtMDYyNQoKMjAxMy0wNi0yNS0yMToxNToxNyBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAzLjEwLjAtcmMxLTAwMjMxLWc3ZGQ4ZmJiLi4uLgkyCTUJNy4JOAkx
NgkxOQkyOAkzMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDExNSByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNyBzdGVwcykKW2VlMTc2MDhkNmFhMDRhODZlMjUz
YTkxMzBkNmM2ZDAwODkyZjEzMmJdIFttZWRpYV0gaW14MDc0OiBzdXBwb3J0IGFzeW5jaHJv
bm91cyBwcm9iaW5nCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvaG9tZS93ZmcvbmV0L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14MTUtMDYyNS9saW51eC1kZXZlbDpk
ZXZlbC14aWFuLWkzODYtMjAxMzA2MjUxOTA1OmVlMTc2MDhkNmFhMDRhODZlMjUzYTkxMzBk
NmM2ZDAwODkyZjEzMmI6YmlzZWN0LW5ldAoKMjAxMy0wNi0yNS0yMToyMTo1NSBlZTE3NjA4
ZDZhYTA0YTg2ZTI1M2E5MTMwZDZjNmQwMDg5MmYxMzJiIGNvbXBpbGluZwo0NzQgcmVhbCAg
MzM0MyB1c2VyICAyMDkgc3lzICA3NDguOTUlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXgxNS0w
NjI1CgoyMDEzLTA2LTI1LTIxOjMxOjEyIGRldGVjdGluZyBib290IHN0YXRlIDMuMTAuMC1y
YzYtMDAzOTctZ2VlMTc2MDguLi4gVEVTVCBGQUlMVVJFClsgICAgOS4wNjExNTddIC0tLS0t
LS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDkuMDcxMzc4XSBkdW1teV91
ZGMgZHVtbXlfdWRjLjA6IHNldF9hZGRyZXNzID0gMgpbICAgIDkuMDcyNjA1XSBXQVJOSU5H
OiBhdCAvYy93ZmcvbmV0L2RyaXZlcnMvbWVkaWEvdjRsMi1jb3JlL3Y0bDItZGV2LmM6Nzc1
IF9fdmlkZW9fcmVnaXN0ZXJfZGV2aWNlKzB4NmEzLzB4MTBkMCgpClsgICAgOS4wNzM5OTdd
IENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjEwLjAtcmM2LTAw
Mzk3LWdlZTE3NjA4ICM2MApbICAgIDkuMDc1MTA0XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBC
b2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgOS4wNzU5NzhdICAwMDAwMDAwMCA0
ZDQ4NWRjMCA0MzMzNjJmMSA0ZDQ4NWRlOCA0MTA3NzM2NyA0M2Q1OTk2YiA0M2ViM2JjMCAw
MDAwMDMwNwpbICAgIDkuMDc3MjM5XSAgNDJhOGU0MzMgNDJhOGU0MzMgNDYxZjY0OTggMDAw
MDAwMDEgMDAwMDAwMDAgNGQ0ODVkZjggNDEwNzc1MGUgMDAwMDAwMDkKWyAgICA5LjA3ODU0
MV0gIDAwMDAwMDAwIDRkNDg1ZTMwIDQyYThlNDMzIDQzZTA1NjAzIDRkNDg1ZTFjIDAwMDAw
MmI4IDQ2MWY2NDk4IDQyYThkYTFhClsgICAgOS4wNzk5MzJdIENhbGwgVHJhY2U6ClsgICAg
OS4wODAyMzVdICBbPDQzMzM2MmYxPl0gZHVtcF9zdGFjaysweDMyLzB4NDIKWyAgICA5LjA4
MDkyNF0gIFs8NDEwNzczNjc+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweGI3LzB4MTAwClsg
ICAgOS4wODE3NzBdICBbPDQyYThlNDMzPl0gPyBfX3ZpZGVvX3JlZ2lzdGVyX2RldmljZSsw
eDZhMy8weDEwZDAKWyAgICA5LjA4MjY0N10gIFs8NDJhOGU0MzM+XSA/IF9fdmlkZW9fcmVn
aXN0ZXJfZGV2aWNlKzB4NmEzLzB4MTBkMApbICAgIDkuMDgzNDU3XSAgWzw0MTA3NzUwZT5d
IHdhcm5fc2xvd3BhdGhfbnVsbCsweDNlLzB4NTAKWyAgICA5LjA4NDE1NV0gIFs8NDJhOGU0
MzM+XSBfX3ZpZGVvX3JlZ2lzdGVyX2RldmljZSsweDZhMy8weDEwZDAKWyAgICA5LjA4NTA3
OF0gIFs8NDJhOGRhMWE+XSA/IHZpZGVvX2RldmljZV9hbGxvYysweDJhLzB4NDAKWyAgICA5
LjA4NTg2MV0gIFs8NDJiMmIyZDc+XSBtMm10ZXN0X3Byb2JlKzB4MTk3LzB4NDMwClsgICAg
OS4wODY1MDhdICBbPDQxMzg5NTgwPl0gPyBzeXNmc19kb19jcmVhdGVfbGluaysweGEwLzB4
ZDAKWyAgICA5LjA4NzI5M10gIFs8NDIwYTRhOWY+XSBwbGF0Zm9ybV9kcnZfcHJvYmUrMHg0
Zi8weDE1MApbICAgIDkuMDg4MDgzXSAgWzw0MjBhMTMxMj5dIGRyaXZlcl9wcm9iZV9kZXZp
Y2UrMHgyNTIvMHg1YjAKWyAgICA5LjA4ODkxM10gIFs8NDMzODljNjg+XSA/IG11dGV4X2xv
Y2tfbmVzdGVkKzB4NjgvMHg4MApbICAgIDkuMDg5NjgyXSAgWzw0MjBhMTdkZj5dIF9fZHJp
dmVyX2F0dGFjaCsweDE2Zi8weDFjMApbICAgIDkuMDkwMzA3XSAgWzw0MjBhMTY3MD5dID8g
ZHJpdmVyX3Byb2JlX2RldmljZSsweDViMC8weDViMApbICAgIDkuMDkxMTgwXSAgWzw0MjA5
Y2RhND5dIGJ1c19mb3JfZWFjaF9kZXYrMHhlNC8weDE3MApbICAgIDkuMDkyMDMzXSAgWzw0
MjBhMGEyYz5dIGRyaXZlcl9hdHRhY2grMHgyYy8weDQwClsgICAgOS4wOTI5MTldICBbPDQy
MGExNjcwPl0gPyBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4NWIwLzB4NWIwClsgICAgOS4wOTM1
NjNdICBbPDQyMDllNjI4Pl0gYnVzX2FkZF9kcml2ZXIrMHgzZjgvMHg2NjAKWyAgICA5LjA5
NDM2OF0gIFs8NDIwYTJiNzU+XSBkcml2ZXJfcmVnaXN0ZXIrMHgxMjUvMHg0OTAKWyAgICA5
LjA5NTA5OV0gIFs8NDIwYTYxYzA+XSBwbGF0Zm9ybV9kcml2ZXJfcmVnaXN0ZXIrMHhjMC8w
eGQwClsgICAgOS4wOTU5MjddICBbPDQ0OGU5MzQ3Pl0gbTJtdGVzdF9pbml0KzB4NWYvMHhi
NQpbICAgIDkuMDk2NTM3XSAgWzw0NDhlOTJlOD5dID8gc21zZHZiX21vZHVsZV9pbml0KzB4
YmQvMHhiZApbICAgIDkuMDk3Mjg3XSAgWzw0NDg0M2E5Mz5dIGRvX29uZV9pbml0Y2FsbCsw
eDEwYS8weDJjZQpbICAgIDkuMDk4MDQ2XSAgWzw0NDg0M2U5YT5dIGtlcm5lbF9pbml0X2Zy
ZWVhYmxlKzB4MjQzLzB4NDBhClsgICAgOS4wOTg4MTVdICBbPDQ0ODQyN2YzPl0gPyBkb19l
YXJseV9wYXJhbSsweDE2Zi8weDE2ZgpbICAgIDkuMDk5NjE2XSAgWzw0MzJkYzExZT5dIGtl
cm5lbF9pbml0KzB4MWUvMHgzMjAKWyAgICA5LjEwMDIwN10gIFs8NDMzOTNhMzc+XSByZXRf
ZnJvbV9rZXJuZWxfdGhyZWFkKzB4MWIvMHgyOApbICAgIDkuMTAxMDY1XSAgWzw0MzJkYzEw
MD5dID8gcmVzdF9pbml0KzB4MzMwLzB4MzMwClsgICAgOS4xMDE4ODZdIC0tLVsgZW5kIHRy
YWNlIGUzZTg2NGJjMmIxY2FlMmEgXS0tLQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MTUt
MDYyNS9lZTE3NjA4ZDZhYTA0YTg2ZTI1M2E5MTMwZDZjNmQwMDg5MmYxMzJiL2RtZXNnLWt2
bS1sa3Atc2J4MDQtNDk0NDUtMjAxMzA2MjYwMTM2MDgtMy4xMC4wLXJjNi0wMDM5Ny1nZWUx
NzYwOC02MAoKQmlzZWN0aW5nOiA1NyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgNiBzdGVwcykKWzk1OTJiZDBhOWU3NGMzNDRmNjc0NjYzMTM3ZTVjY2Zm
N2EzOWY3ZDBdIFttZWRpYV0gem9yYW46IHVzZSB2NGwyX2RldiBpbnN0ZWFkIG9mIHRoZSBk
ZXByZWNhdGVkIHBhcmVudCBmaWVsZApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL25ldC9vYmotYmlzZWN0CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWcteDE1LTA2MjUvbGlu
dXgtZGV2ZWw6ZGV2ZWwteGlhbi1pMzg2LTIwMTMwNjI1MTkwNTo5NTkyYmQwYTllNzRjMzQ0
ZjY3NDY2MzEzN2U1Y2NmZjdhMzlmN2QwOmJpc2VjdC1uZXQKCjIwMTMtMDYtMjUtMjE6MzI6
NDkgOTU5MmJkMGE5ZTc0YzM0NGY2NzQ2NjMxMzdlNWNjZmY3YTM5ZjdkMCBjb21waWxpbmcK
MTQ2IHJlYWwgIDE5MiB1c2VyICAxNyBzeXMgIDE0My41MiUgY3B1IAlpMzg2LXJhbmRjb25m
aWcteDE1LTA2MjUKCjIwMTMtMDYtMjUtMjE6MzU6MzAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
My4xMC4wLXJjNi0wMDMzOS1nOTU5MmJkMC4uCTMJNwkxNAkyMQkzMCBTVUNDRVNTCgpCaXNl
Y3Rpbmc6IDI4IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA1
IHN0ZXBzKQpbOTg1MDVmZjlmMmZhMWExYjMzZDkwZDM5YWI3NmE1NGEzYjE4OWVlMl0gW21l
ZGlhXSBzb2MtY2FtZXJhOiByZW1vdmUgdHdvIHVudXNlZCBjb25maWdzCnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbmV0
L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFu
ZGNvbmZpZy14MTUtMDYyNS9saW51eC1kZXZlbDpkZXZlbC14aWFuLWkzODYtMjAxMzA2MjUx
OTA1Ojk4NTA1ZmY5ZjJmYTFhMWIzM2Q5MGQzOWFiNzZhNTRhM2IxODllZTI6YmlzZWN0LW5l
dAoKMjAxMy0wNi0yNS0yMTozOTowMiA5ODUwNWZmOWYyZmExYTFiMzNkOTBkMzlhYjc2YTU0
YTNiMTg5ZWUyIGNvbXBpbGluZwoxMjYgcmVhbCAgMjEyIHVzZXIgIDE3IHN5cyAgMTgxLjg4
JSBjcHUgCWkzODYtcmFuZGNvbmZpZy14MTUtMDYyNQoKMjAxMy0wNi0yNS0yMTo0NToxNSBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEwLjAtcmM2LTAwMzY4LWc5ODUwNWZmLi4uIFRFU1Qg
RkFJTFVSRQpbICAgMTIuOTYzOTY3XSBiMmMyLWZsZXhjb3A6IEIyQzIgRmxleGNvcElJL0lJ
KGIpL0lJSSBkaWdpdGFsIFRWIHJlY2VpdmVyIGNoaXAgbG9hZGVkIHN1Y2Nlc3NmdWxseQpb
ICAgMTIuOTY1OTE4XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAg
IDEyLjk2NjU5MF0gV0FSTklORzogYXQgL2Mvd2ZnL25ldC9kcml2ZXJzL21lZGlhL3Y0bDIt
Y29yZS92NGwyLWRldi5jOjc3NSBfX3ZpZGVvX3JlZ2lzdGVyX2RldmljZSsweDZhMy8weDEw
ZDAoKQpbICAgMTIuOTY3OTE3XSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRh
aW50ZWQgMy4xMC4wLXJjNi0wMDM2OC1nOTg1MDVmZiAjNjIKWyAgIDEyLjk2ODkwMF0gSGFy
ZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgMTIu
OTY5NjYwXSAgMDAwMDAwMDAgNGQ0ODVkYzAgNDMzMzQ0ZTEgNGQ0ODVkZTggNDEwNzczNjcg
NDNkNTY0YzcgNDNlYjA2YjAgMDAwMDAzMDcKWyAgIDEyLjk3MDg2Ml0gIDQyYThlNDIzIDQy
YThlNDIzIDQ2MWY0Njk4IDAwMDAwMDAxIDAwMDAwMDAwIDRkNDg1ZGY4IDQxMDc3NTBlIDAw
MDAwMDA5ClsgICAxMi45NzIxNzVdICAwMDAwMDAwMCA0ZDQ4NWUzMCA0MmE4ZTQyMyA0M2Uw
MjBmMSA0ZDQ4NWUxYyAwMDAwMDJiOCA0NjFmNDY5OCA0MmE4ZGEwYQpbICAgMTIuOTczMzc1
XSBDYWxsIFRyYWNlOgpbICAgMTIuOTczNzI3XSAgWzw0MzMzNDRlMT5dIGR1bXBfc3RhY2sr
MHgzMi8weDQyClsgICAxMi45NzQzNDVdICBbPDQxMDc3MzY3Pl0gd2Fybl9zbG93cGF0aF9j
b21tb24rMHhiNy8weDEwMApbICAgMTIuOTc1MDYzXSAgWzw0MmE4ZTQyMz5dID8gX192aWRl
b19yZWdpc3Rlcl9kZXZpY2UrMHg2YTMvMHgxMGQwClsgICAxMi45NzU4NjFdICBbPDQyYThl
NDIzPl0gPyBfX3ZpZGVvX3JlZ2lzdGVyX2RldmljZSsweDZhMy8weDEwZDAKWyAgIDEyLjk3
NjY2Ml0gIFs8NDEwNzc1MGU+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgzZS8weDUwClsgICAx
Mi45NzczNTNdICBbPDQyYThlNDIzPl0gX192aWRlb19yZWdpc3Rlcl9kZXZpY2UrMHg2YTMv
MHgxMGQwClsgICAxMi45NzgxMzNdICBbPDQyYThkYTBhPl0gPyB2aWRlb19kZXZpY2VfYWxs
b2MrMHgyYS8weDQwClsgICAxMi45Nzg4NDJdICBbPDQyYjI5NGQ3Pl0gbTJtdGVzdF9wcm9i
ZSsweDE5Ny8weDQzMApbICAgMTIuOTc5NTA1XSAgWzw0MTM4OTU4MD5dID8gc3lzZnNfZG9f
Y3JlYXRlX2xpbmsrMHhhMC8weGQwClsgICAxMi45ODAyNTZdICBbPDQyMGE0YTlmPl0gcGxh
dGZvcm1fZHJ2X3Byb2JlKzB4NGYvMHgxNTAKWyAgIDEyLjk4MDk1MV0gIFs8NDIwYTEzMTI+
XSBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4MjUyLzB4NWIwClsgICAxMi45ODE2NzVdICBbPDQz
Mzg3ZTU4Pl0gPyBtdXRleF9sb2NrX25lc3RlZCsweDY4LzB4ODAKWyAgIDEyLjk4MjQzMV0g
IFs8NDIwYTE3ZGY+XSBfX2RyaXZlcl9hdHRhY2grMHgxNmYvMHgxYzAKWyAgIDEyLjk4MzEw
OF0gIFs8NDIwYTE2NzA+XSA/IGRyaXZlcl9wcm9iZV9kZXZpY2UrMHg1YjAvMHg1YjAKWyAg
IDEyLjk4Mzg0Nl0gIFs8NDIwOWNkYTQ+XSBidXNfZm9yX2VhY2hfZGV2KzB4ZTQvMHgxNzAK
WyAgIDEyLjk4NDUyNV0gIFs8NDIwYTBhMmM+XSBkcml2ZXJfYXR0YWNoKzB4MmMvMHg0MApb
ICAgMTIuOTg1MTYwXSAgWzw0MjBhMTY3MD5dID8gZHJpdmVyX3Byb2JlX2RldmljZSsweDVi
MC8weDViMApbICAgMTIuOTg1OTAyXSAgWzw0MjA5ZTYyOD5dIGJ1c19hZGRfZHJpdmVyKzB4
M2Y4LzB4NjYwClsgICAxMi45ODY1NzZdICBbPDQyMGEyYjc1Pl0gZHJpdmVyX3JlZ2lzdGVy
KzB4MTI1LzB4NDkwClsgICAxMi45ODcyNThdICBbPDQyMGE2MWMwPl0gcGxhdGZvcm1fZHJp
dmVyX3JlZ2lzdGVyKzB4YzAvMHhkMApbICAgMTIuOTg4MDM4XSAgWzw0NDhlNTM0Nz5dIG0y
bXRlc3RfaW5pdCsweDVmLzB4YjUKWyAgIDEyLjk4ODY2NF0gIFs8NDQ4ZTUyZTg+XSA/IHNt
c2R2Yl9tb2R1bGVfaW5pdCsweGJkLzB4YmQKWyAgIDEyLjk4OTM4NF0gIFs8NDQ4M2ZhOTM+
XSBkb19vbmVfaW5pdGNhbGwrMHgxMGEvMHgyY2UKWyAgIDEyLjk5MDA1NF0gIFs8NDQ4M2Zl
OWE+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDI0My8weDQwYQpbICAgMTIuOTkwNzg1XSAg
Wzw0NDgzZTdmMz5dID8gZG9fZWFybHlfcGFyYW0rMHgxNmYvMHgxNmYKWyAgIDEyLjk5MTQ3
OF0gIFs8NDMyZGEzMGU+XSBrZXJuZWxfaW5pdCsweDFlLzB4MzIwClsgICAxMi45OTIxNThd
ICBbPDQzMzkxYzE3Pl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDFiLzB4MjgKWyAgIDEy
Ljk5Mjg5Ml0gIFs8NDMyZGEyZjA+XSA/IHJlc3RfaW5pdCsweDMzMC8weDMzMApbICAgMTIu
OTkzNTgwXSAtLS1bIGVuZCB0cmFjZSA2NGJiODcwZTI2Y2RiMDEwIF0tLS0KL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWcteDE1LTA2MjUvOTg1MDVmZjlmMmZhMWExYjMzZDkwZDM5YWI3NmE1
NGEzYjE4OWVlMi9kbWVzZy1rdm0tYmF5LTE3NDE5LTIwMTMwNjI1MjE0ODUxLTMuMTAuMC1y
YzYtMDAzNjgtZzk4NTA1ZmYtNjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDE1LTA2MjUv
OTg1MDVmZjlmMmZhMWExYjMzZDkwZDM5YWI3NmE1NGEzYjE4OWVlMi9kbWVzZy1rdm0tbGtw
LXNieDA0LTk3ODYtMjAxMzA2MjYwMTUwMjYtLQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14
MTUtMDYyNS85ODUwNWZmOWYyZmExYTFiMzNkOTBkMzlhYjc2YTU0YTNiMTg5ZWUyL2RtZXNn
LWt2bS1sa3Atc2J4MDQtMjkxNjQtMjAxMzA2MjYwMTUwMTctMy4xMC4wLXJjNy0wMDU1MC1n
ZGM3MzA1Zi04Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxNS0wNjI1Lzk4NTA1ZmY5ZjJm
YTFhMWIzM2Q5MGQzOWFiNzZhNTRhM2IxODllZTIvZG1lc2cta3ZtLWxrcC1zYngwNC0yOTgz
My0yMDEzMDYyNjAxNTAxMS0zLjEwLjAtcmM3LTAwOTk4LWcwOWQxNDFlLTYKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWcteDE1LTA2MjUvOTg1MDVmZjlmMmZhMWExYjMzZDkwZDM5YWI3NmE1
NGEzYjE4OWVlMi9kbWVzZy1rdm0tbGtwLXNieDA0LTM4MTAxLTIwMTMwNjI2MDE1MDE2LTMu
MTAuMC1yYzYtMDAzNjgtZzk4NTA1ZmYtNjIKCkJpc2VjdGluZzogMTQgcmV2aXNpb25zIGxl
ZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDQgc3RlcHMpCls0MTBjYTYwNTNlM2My
MTZiOGNhMGIwNWY0NWQ2Y2Q3NmIzMzRhNDU5XSBbbWVkaWFdIG1lZGlhOiBkYXZpbmNpOiB2
cGlmX2NhcHR1cmU6IG1vdmUgdGhlIGZyZWVpbmcgb2YgaXJxIGFuZCBnbG9iYWwgdmFyaWFi
bGVzIHRvIHJlbW92ZSgpCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJv
b3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbmV0L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10
ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy14MTUtMDYyNS9saW51eC1kZXZl
bDpkZXZlbC14aWFuLWkzODYtMjAxMzA2MjUxOTA1OjQxMGNhNjA1M2UzYzIxNmI4Y2EwYjA1
ZjQ1ZDZjZDc2YjMzNGE0NTk6YmlzZWN0LW5ldAoKMjAxMy0wNi0yNS0yMTo0Njo0OCA0MTBj
YTYwNTNlM2MyMTZiOGNhMGIwNWY0NWQ2Y2Q3NmIzMzRhNDU5IGNvbXBpbGluZwoxMjEgcmVh
bCAgODcgdXNlciAgMTAgc3lzICA4MC4zNiUgY3B1IAlpMzg2LXJhbmRjb25maWcteDE1LTA2
MjUKCjIwMTMtMDYtMjUtMjE6NDk6MjAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMC4wLXJj
Ni0wMDM1My1nNDEwY2E2MC4uLi4gVEVTVCBGQUlMVVJFClsgICAxMC45NTc0NDVdIGIyYzIt
ZmxleGNvcDogQjJDMiBGbGV4Y29wSUkvSUkoYikvSUlJIGRpZ2l0YWwgVFYgcmVjZWl2ZXIg
Y2hpcCBsb2FkZWQgc3VjY2Vzc2Z1bGx5ClsgICAxMC45NjI3MzNdIC0tLS0tLS0tLS0tLVsg
Y3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgMTAuOTYzMzY1XSBXQVJOSU5HOiBhdCAvYy93
ZmcvbmV0L2RyaXZlcnMvbWVkaWEvdjRsMi1jb3JlL3Y0bDItZGV2LmM6Nzc1IF9fdmlkZW9f
cmVnaXN0ZXJfZGV2aWNlKzB4NmEzLzB4MTBkMCgpClsgICAxMC45NjQ2NjZdIENQVTogMCBQ
SUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjEwLjAtcmM2LTAwMzUzLWc0MTBj
YTYwICM2MwpbICAgMTAuOTY1NjAwXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklP
UyBCb2NocyAwMS8wMS8yMDExClsgICAxMC45NzEzMjFdICAwMDAwMDAwMCA0ZDQ4NWRjMCA0
MzMzNDUwMSA0ZDQ4NWRlOCA0MTA3NzM2NyA0M2Q1NjRjYiA0M2ViMDZjYyAwMDAwMDMwNwpb
ICAgMTAuOTc1OTM1XSAgNDJhOGU0NDMgNDJhOGU0NDMgNDYxZjM3ZDggMDAwMDAwMDEgMDAw
MDAwMDAgNGQ0ODVkZjggNDEwNzc1MGUgMDAwMDAwMDlnX2V0aGVyIGdhZGdldDogaGlnaC1z
cGVlZCBjb25maWcgIzE6IENEQyBFdGhlcm5ldCAoRUVNKQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy14MTUtMDYyNS80MTBjYTYwNTNlM2MyMTZiOGNhMGIwNWY0NWQ2Y2Q3NmIzMzRhNDU5
L2RtZXNnLWt2bS1sa3Atc2J4MDQtMzgxMDEtMjAxMzA2MjYwMTU0NDUtMy4xMC4wLXJjNi0w
MDM2OC1nOTg1MDVmZi02Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MTUtMDYyNS80MTBj
YTYwNTNlM2MyMTZiOGNhMGIwNWY0NWQ2Y2Q3NmIzMzRhNDU5L2RtZXNnLWt2bS1sa3Atc2J4
MDQtMzkyMTQtMjAxMzA2MjYwMTU0NDQtMy4xMC4wLXJjNy0wMDU1MC1nNmQ3ODM0Ni0yMAov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy14MTUtMDYyNS80MTBjYTYwNTNlM2MyMTZiOGNhMGIw
NWY0NWQ2Y2Q3NmIzMzRhNDU5L2RtZXNnLWt2bS12cC0yMjA3Mi0yMDEzMDYyNTIxNTE0OC0t
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxNS0wNjI1LzQxMGNhNjA1M2UzYzIxNmI4Y2Ew
YjA1ZjQ1ZDZjZDc2YjMzNGE0NTkvZG1lc2cta3ZtLXZwLTkwMTItMjAxMzA2MjUyMTUxNDgt
My4xMC4wLXJjNi0wMDM1My1nNDEwY2E2MC02Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy14
MTUtMDYyNS80MTBjYTYwNTNlM2MyMTZiOGNhMGIwNWY0NWQ2Y2Q3NmIzMzRhNDU5L2RtZXNn
LWt2bS1sa3Atc2J4MDQtNjU4Mi0yMDEzMDYyNjAxNTQ0NC0zLjEwLjAtcmM2LTAwMzUzLWc0
MTBjYTYwLTYzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxNS0wNjI1LzQxMGNhNjA1M2Uz
YzIxNmI4Y2EwYjA1ZjQ1ZDZjZDc2YjMzNGE0NTkvZG1lc2cta3ZtLWxrcC1zYngwNC0xMTgz
OC0yMDEzMDYyNjAxNTQ0NS0tCgpCaXNlY3Rpbmc6IDYgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3RlcHMpClsxYzFkODZhMWVhMDc1MDZjMDcwY2Zi
MjE3YTAwOWQ1Mzk5MGJkZWIwXSBbbWVkaWFdIHY0bDI6IGFsd2F5cyByZXF1aXJlIHY0bDJf
ZGV2LCByZW5hbWUgcGFyZW50IHRvIGRldl9wYXJlbnQKcnVubmluZyAvYy9rZXJuZWwtdGVz
dHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9uZXQvb2JqLWJpc2Vj
dApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXgx
NS0wNjI1L2xpbnV4LWRldmVsOmRldmVsLXhpYW4taTM4Ni0yMDEzMDYyNTE5MDU6MWMxZDg2
YTFlYTA3NTA2YzA3MGNmYjIxN2EwMDlkNTM5OTBiZGViMDpiaXNlY3QtbmV0CgoyMDEzLTA2
LTI1LTIxOjUxOjI0IDFjMWQ4NmExZWEwNzUwNmMwNzBjZmIyMTdhMDA5ZDUzOTkwYmRlYjAg
Y29tcGlsaW5nCjE0NyByZWFsICA5MSB1c2VyICAxMCBzeXMgIDY5LjUwJSBjcHUgCWkzODYt
cmFuZGNvbmZpZy14MTUtMDYyNQoKMjAxMy0wNi0yNS0yMTo1NDo1MiBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAzLjEwLjAtcmM2LTAwMzQ2LWcxYzFkODZhLi4uIFRFU1QgRkFJTFVSRQpbICAg
MTAuNjMwOTA4XSBiMmMyLWZsZXhjb3A6IEIyQzIgRmxleGNvcElJL0lJKGIpL0lJSSBkaWdp
dGFsIFRWIHJlY2VpdmVyIGNoaXAgbG9hZGVkIHN1Y2Nlc3NmdWxseQpbICAgMTAuNjM0NDY5
XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgIDEwLjYzNjE0MF0g
V0FSTklORzogYXQgL2Mvd2ZnL25ldC9kcml2ZXJzL21lZGlhL3Y0bDItY29yZS92NGwyLWRl
di5jOjc3NSBfX3ZpZGVvX3JlZ2lzdGVyX2RldmljZSsweDZhMy8weDEwZDAoKQpbICAgMTAu
NjM4Njk1XSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xMC4w
LXJjNi0wMDM0Ni1nMWMxZDg2YSAjNjQKWyAgIDEwLjY0MDcxNV0gSGFyZHdhcmUgbmFtZTog
Qm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgMTAuNjQyNDU2XSAgMDAw
MDAwMDAgNGQ0ODVkYzAgNDMzMzQ0ZjEgNGQ0ODVkZTggNDEwNzczNjcgNDNkNTY0Y2IgNDNl
YjA2Y2MgMDAwMDAzMDcKWyAgIDEwLjY0NDY3OV0gIDQyYThlNDQzIDQyYThlNDQzIDQ2MWYy
OWQ4IDAwMDAwMDAxIDAwMDAwMDAwIDRkNDg1ZGY4IDQxMDc3NTBlIDAwMDAwMDA5ClsgICAx
MC42NDcxNzNdICAwMDAwMDAwMCA0ZDQ4NWUzMCA0MmE4ZTQ0MyA0M2UwMjEwZiA0ZDQ4NWUx
YyAwMDAwMDJiOCA0NjFmMjlkOCA0MmE4ZGEyYQpbICAgMTAuNjQ5MzEzXSBDYWxsIFRyYWNl
OgpbICAgMTAuNjQ5NjI5XSAgWzw0MzMzNDRmMT5dIGR1bXBfc3RhY2srMHgzMi8weDQyClsg
ICAxMC42NTIyMzNdICBbPDQxMDc3MzY3Pl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHhiNy8w
eDEwMApbICAgMTAuNjUzMzY4XSB1c2IgMS0xOiBOZXcgVVNCIGRldmljZSBmb3VuZCwgaWRW
ZW5kb3I9MDUyNSwgaWRQcm9kdWN0PWE0YTIKWyAgIDEwLjY1NTIzNl0gdXNiIDEtMTogTmV3
IFVTQiBkZXZpY2Ugc3RyaW5nczogTWZyPTEsIFByb2R1Y3Q9MiwgU2VyaWFsTnVtYmVyPTAK
WyAgIDEwLjY1NzkyM10gdXNiIDEtMTogUHJvZHVjdDogUk5ESVMvRXRoZXJuZXQgR2FkZ2V0
ClsgICAxMC42NTg1NTNdIHVzYiAxLTE6IE1hbnVmYWN0dXJlcjogTGludXggMy4xMC4wLXJj
Ni0wMDM0Ni1nMWMxZDg2YSB3aXRoIGR1bW15X3VkYwpbICAgMTAuNjYyNjU2XSAgWzw0MmE4
ZTQ0Mz5dID8gX192aWRlb19yZWdpc3Rlcl9kZXZpY2UrMHg2YTMvMHgxMGQwClsgICAxMC42
NjU3MThdICBbPDQyYThlNDQzPl0gPyBfX3ZpZGVvX3JlZ2lzdGVyX2RldmljZSsweDZhMy8w
eDEwZDAKWyAgIDEwLjY2NjQ3NV0gIFs8NDEwNzc1MGU+XSB3YXJuX3Nsb3dwYXRoX251bGwr
MHgzZS8weDUwClsgICAxMC42NjcxNzNdICBbPDQyYThlNDQzPl0gX192aWRlb19yZWdpc3Rl
cl9kZXZpY2UrMHg2YTMvMHgxMGQwClsgICAxMC42Njc4NjRdICBbPDQyYThkYTJhPl0gPyB2
aWRlb19kZXZpY2VfYWxsb2MrMHgyYS8weDQwClsgICAxMC42Njg2NTJdICBbPDQyYjI5NGY3
Pl0gbTJtdGVzdF9wcm9iZSsweDE5Ny8weDQzMApbICAgMTAuNjY5MjY4XSAgWzw0MTM4OTU4
MD5dID8gc3lzZnNfZG9fY3JlYXRlX2xpbmsrMHhhMC8weGQwClsgICAxMC42Njk5MzhdICBb
PDQyMGE0YTlmPl0gcGxhdGZvcm1fZHJ2X3Byb2JlKzB4NGYvMHgxNTAKWyAgIDEwLjY3MDU4
OF0gIFs8NDIwYTEzMTI+XSBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4MjUyLzB4NWIwClsgICAx
MC42NzEyNjVdICBbPDQzMzg3ZTY4Pl0gPyBtdXRleF9sb2NrX25lc3RlZCsweDY4LzB4ODAK
WyAgIDEwLjY3ODA3MV0gIFs8NDIwYTE3ZGY+XSBfX2RyaXZlcl9hdHRhY2grMHgxNmYvMHgx
YzAKWyAgIDEwLjY4MjMzNV0gIFs8NDIwYTE2NzA+XSA/IGRyaXZlcl9wcm9iZV9kZXZpY2Ur
MHg1YjAvMHg1YjAKWyAgIDEwLjY4MzI2MF0gZ19ldGhlciBnYWRnZXQ6IGhpZ2gtc3BlZWQg
Y29uZmlnICMxOiBDREMgRXRoZXJuZXQgKEVFTSkKWyAgIDEwLjY4NDA5M10gZ19ldGhlciBn
YWRnZXQ6IGluaXQgZWVtCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxNS0wNjI1LzFjMWQ4
NmExZWEwNzUwNmMwNzBjZmIyMTdhMDA5ZDUzOTkwYmRlYjAvZG1lc2cta3ZtLWxrcC1zYngw
NC0yMzYxNS0yMDEzMDYyNjAxNTk1Ny0zLjEwLjAtcmM3LTAwNTUwLWdkYzczMDVmLTgKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWcteDE1LTA2MjUvMWMxZDg2YTFlYTA3NTA2YzA3MGNmYjIx
N2EwMDlkNTM5OTBiZGViMC9kbWVzZy1rdm0tbGtwLXNieDA0LTc4MTctMjAxMzA2MjYwMjAw
MjMtLQoKQmlzZWN0aW5nOiAzIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAo
cm91Z2hseSAyIHN0ZXBzKQpbYTI4ZmJkMDRmYWNiZmZlOTM3NGYyNWMzYTE5YzU0Y2U0ZjE4
NjM2MV0gW21lZGlhXSBwdnJ1c2IyOiB1c2UgdjRsMl9kZXYgaW5zdGVhZCBvZiB0aGUgZGVw
cmVjYXRlZCBwYXJlbnQgZmllbGQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9uZXQvb2JqLWJpc2VjdApscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXgxNS0wNjI1L2xpbnV4
LWRldmVsOmRldmVsLXhpYW4taTM4Ni0yMDEzMDYyNTE5MDU6YTI4ZmJkMDRmYWNiZmZlOTM3
NGYyNWMzYTE5YzU0Y2U0ZjE4NjM2MTpiaXNlY3QtbmV0CgoyMDEzLTA2LTI1LTIxOjU2OjI3
IGEyOGZiZDA0ZmFjYmZmZTkzNzRmMjVjM2ExOWM1NGNlNGYxODYzNjEgY29tcGlsaW5nCjEz
MyByZWFsICAyMTEgdXNlciAgMTcgc3lzICAxNzEuNzQlIGNwdSAJaTM4Ni1yYW5kY29uZmln
LXgxNS0wNjI1CgoyMDEzLTA2LTI1LTIyOjAxOjI2IGRldGVjdGluZyBib290IHN0YXRlIDMu
MTAuMC1yYzYtMDAzNDItZ2EyOGZiZDAuLgkyCTExCTE5CTI3CTI4CTMwIFNVQ0NFU1MKCkJp
c2VjdGluZzogMSByZXZpc2lvbiBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAx
IHN0ZXApCls3YTg2OTY5YmQ2NWViN2YxOWVhMWMyODFjNjg2YTc1NDI5YmU5NTBhXSBbbWVk
aWFdIG9tYXAyNHh4Y2FtOiBhZGQgdjRsMl9kZXZpY2UgYW5kIHJlcGxhY2UgcGFyZW50IHdp
dGggdjRsMl9kZXYKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9ob21lL3dmZy9uZXQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXgxNS0wNjI1L2xpbnV4LWRldmVsOmRl
dmVsLXhpYW4taTM4Ni0yMDEzMDYyNTE5MDU6N2E4Njk2OWJkNjVlYjdmMTllYTFjMjgxYzY4
NmE3NTQyOWJlOTUwYTpiaXNlY3QtbmV0CgoyMDEzLTA2LTI1LTIyOjA1OjI5IDdhODY5Njli
ZDY1ZWI3ZjE5ZWExYzI4MWM2ODZhNzU0MjliZTk1MGEgY29tcGlsaW5nCjExNyByZWFsICA5
MyB1c2VyICAxMSBzeXMgIDg5LjIxJSBjcHUgCWkzODYtcmFuZGNvbmZpZy14MTUtMDYyNQoK
MjAxMy0wNi0yNS0yMjowODoxNiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEwLjAtcmM2LTAw
MzQ0LWc3YTg2OTY5Li4uCTcJMTEJMjUJMjgJMjkuLgkzMCBTVUNDRVNTCgpCaXNlY3Rpbmc6
IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDAgc3RlcHMp
CltkNDgxYzU4MWRmZTQzYmUxMWExNzcyOGI1Yzg0YzJkNGI1YmVlY2IyXSBbbWVkaWFdIHNh
YTcxMzQ6IHVzZSB2NGwyX2RldiBpbnN0ZWFkIG9mIHRoZSBkZXByZWNhdGVkIHBhcmVudCBm
aWVsZApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2ggL2hvbWUvd2ZnL25ldC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWcteDE1LTA2MjUvbGludXgtZGV2ZWw6ZGV2ZWwteGlh
bi1pMzg2LTIwMTMwNjI1MTkwNTpkNDgxYzU4MWRmZTQzYmUxMWExNzcyOGI1Yzg0YzJkNGI1
YmVlY2IyOmJpc2VjdC1uZXQKCjIwMTMtMDYtMjUtMjI6MTM6NTEgZDQ4MWM1ODFkZmU0M2Jl
MTFhMTc3MjhiNWM4NGMyZDRiNWJlZWNiMiBjb21waWxpbmcKNjAgcmVhbCAgODQgdXNlciAg
MTAgc3lzICAxNTguOTYlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXgxNS0wNjI1CgoyMDEzLTA2
LTI1LTIyOjE1OjAyIGRldGVjdGluZyBib290IHN0YXRlIDMuMTAuMC1yYzYtMDAzNDUtZ2Q0
ODFjNTguLgkyCTUJOAkxMgkyMAkyNAkzMCBTVUNDRVNTCgoxYzFkODZhMWVhMDc1MDZjMDcw
Y2ZiMjE3YTAwOWQ1Mzk5MGJkZWIwIGlzIHRoZSBmaXJzdCBiYWQgY29tbWl0CmNvbW1pdCAx
YzFkODZhMWVhMDc1MDZjMDcwY2ZiMjE3YTAwOWQ1Mzk5MGJkZWIwCkF1dGhvcjogSGFucyBW
ZXJrdWlsIDxoYW5zLnZlcmt1aWxAY2lzY28uY29tPgpEYXRlOiAgIFdlZCBKdW4gMTIgMTE6
MTU6MTIgMjAxMyAtMDMwMAoKICAgIFttZWRpYV0gdjRsMjogYWx3YXlzIHJlcXVpcmUgdjRs
Ml9kZXYsIHJlbmFtZSBwYXJlbnQgdG8gZGV2X3BhcmVudAogICAgCiAgICBUaGUgbGFzdCBz
ZXQgb2YgZHJpdmVycyBzdGlsbCB1c2luZyB0aGUgcGFyZW50IGZpZWxkIG9mIHZpZGVvX2Rl
dmljZSBpbnN0ZWFkCiAgICBvZiB0aGUgdjRsMl9kZXYgZmllbGQgaGF2ZSBiZWVuIGNvbnZl
cnRlZCwgc28gdjRsMl9kZXYgaXMgbm93IGFsd2F5cyBzZXQuCiAgICBBIHByb3BlciBwb2lu
dGVyIHRvIHY0bDJfZGV2IGlzIG5lY2Vzc2FyeSB0aGVzZSBkYXlzIG90aGVyd2lzZSB0aGUg
YWR2YW5jZWQKICAgIGRlYnVnZ2luZyBpb2N0bHMgd2lsbCBub3Qgd29yayB3aGVuIGFkZHJl
c3Npbmcgc3ViLWRldmljZXMuIEl0IGFsc28gZW5zdXJlcwogICAgdGhhdCB0aGUgY29yZSBj
YW4gYWx3YXlzIGdvIGZyb20gYSB2aWRlb19kZXZpY2Ugc3RydWN0IHRvIHRoZSB0b3AtbGV2
ZWwKICAgIHY0bDJfZGV2aWNlIHN0cnVjdC4KICAgIFRoZXJlIGlzIHN0aWxsIG9uZSBzaW5n
bGUgdXNlIGNhc2UgZm9yIHRoZSBwYXJlbnQgcG9pbnRlcjogaWYgdGhlcmUgYXJlCiAgICBt
dWx0aXBsZSBidXNzZXMsIGVhY2ggYmVpbmcgdGhlIHBhcmVudCBvZiBvbmUgb3IgbW9yZSB2
aWRlbyBub2RlcywgYW5kIGlmCiAgICB0aGV5IGFsbCBzaGFyZSB0aGUgc2FtZSB2NGwyX2Rl
dmljZSBzdHJ1Y3QuIEluIHRoYXQgY2FzZSBvbmUgc3RpbGwgbmVlZHMgYQogICAgcGFyZW50
IHBvaW50ZXIgc2luY2UgdGhlIHY0bDJfZGV2aWNlIHN0cnVjdCBjYW4gb25seSByZWZlciB0
byBhIHNpbmdsZQogICAgcGFyZW50IGRldmljZS4gVGhlIGN4ODggZHJpdmVyIGlzIG9uZSBz
dWNoIGNhc2UuIFVuZm9ydHVuYXRlbHksIHRoZSBjeDg4CiAgICBmYWlsZWQgdG8gc2V0IHRo
ZSBwYXJlbnQgcG9pbnRlciBzaW5jZSAzLjYuIFRoZSBuZXh0IHBhdGNoIHdpbGwgY29ycmVj
dCB0aGlzLgogICAgSW4gb3JkZXIgdG8gc3VwcG9ydCB0aGlzIHVzZS1jYXNlIHRoZSBwYXJl
bnQgcG9pbnRlciBpcyBvbmx5IHJlbmFtZWQgdG8KICAgIGRldl9wYXJlbnQsIG5vdCByZW1v
dmVkIGFsdG9nZXRoZXIuIEl0IGhhcyBiZWVuIHJlbmFtZWQgdG8gZW5zdXJlIHRoYXQgdGhl
CiAgICBjb21waWxlciB3aWxsIGNhdGNoIGFueSAocG9zc2libHkgb3V0LW9mLXRyZWUpIGRy
aXZlcnMgdGhhdCB3ZXJlIG1pc3NlZCBkdXJpbmcKICAgIHRoZSBjb252ZXJzaW9uLgogICAg
CiAgICBTaWduZWQtb2ZmLWJ5OiBIYW5zIFZlcmt1aWwgPGhhbnMudmVya3VpbEBjaXNjby5j
b20+CiAgICBBY2tlZC1ieTogU2FrYXJpIEFpbHVzIDxzYWthcmkuYWlsdXNAaWtpLmZpPgog
ICAgQWNrZWQtYnk6IExhdXJlbnQgUGluY2hhcnQgPGxhdXJlbnQucGluY2hhcnRAaWRlYXNv
bmJvYXJkLmNvbT4KICAgIFNpZ25lZC1vZmYtYnk6IE1hdXJvIENhcnZhbGhvIENoZWhhYiA8
bWNoZWhhYkByZWRoYXQuY29tPgoKOjA0MDAwMCAwNDAwMDAgZGU0YzNlYjA4YjVlYTUyY2Nj
ZGQ5MmMwNWMzMzczNTgzY2E0MTgwNyAxNTVhOTRjYjI0NjUzMTgxYWY5NzgyZTUyMjZhYTAx
NjNjYjZiNjk1IE0JZHJpdmVycwo6MDQwMDAwIDA0MDAwMCA2YmNiNjFkMjk3NThiNGUzYTlk
ODA0N2E2YzY2NGVjZjBiOTEyOWE5IDhlMmM2NDMxMDg5MzgzMDRjNTYxMGQwNmMyNzViMzJl
ZmEwY2JmOWYgTQlpbmNsdWRlCmJpc2VjdCBydW4gc3VjY2VzcwpscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXgxNS0wNjI1L2xpbnV4LWRldmVs
OmRldmVsLXhpYW4taTM4Ni0yMDEzMDYyNTE5MDU6ZDQ4MWM1ODFkZmU0M2JlMTFhMTc3Mjhi
NWM4NGMyZDRiNWJlZWNiMjpiaXNlY3QtbmV0CgoyMDEzLTA2LTI1LTIyOjE5OjM1IGQ0ODFj
NTgxZGZlNDNiZTExYTE3NzI4YjVjODRjMmQ0YjViZWVjYjIgcmV1c2UgL2tlcm5lbC9pMzg2
LXJhbmRjb25maWcteDE1LTA2MjUvZDQ4MWM1ODFkZmU0M2JlMTFhMTc3MjhiNWM4NGMyZDRi
NWJlZWNiMi92bWxpbnV6LTMuMTAuMC1yYzYtMDAzNDUtZ2Q0ODFjNTgKCjIwMTMtMDYtMjUt
MjI6MTk6MzUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uCTMyLgkzMwk0Mgk0Mwk0NQk1Mgk3
Mgk4Mgk5MCBTVUNDRVNTCgpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4
Ni1yYW5kY29uZmlnLXgxNS0wNjI1L2xpbnV4LWRldmVsOmRldmVsLXhpYW4taTM4Ni0yMDEz
MDYyNTE5MDU6NGM1YzZmYzExZWUzMGRkZjQ3YzM3NzJmM2IxZWMzZjc2ZjBlMjQzNzpiaXNl
Y3QtbmV0CiBURVNUIEZBSUxVUkUKWyAgIDExLjE2OTMwM10gYjJjMi1mbGV4Y29wOiBCMkMy
IEZsZXhjb3BJSS9JSShiKS9JSUkgZGlnaXRhbCBUViByZWNlaXZlciBjaGlwIGxvYWRlZCBz
dWNjZXNzZnVsbHkKWyAgIDExLjE3MDkyOV0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0t
LS0tLS0tLS0tClsgICAxMS4xNzE2MDhdIFdBUk5JTkc6IGF0IC9jL2tlcm5lbC10ZXN0cy9z
cmMvbGludXgvZHJpdmVycy9tZWRpYS92NGwyLWNvcmUvdjRsMi1kZXYuYzo3NzUgX192aWRl
b19yZWdpc3Rlcl9kZXZpY2UrMHg2YTMvMHgxMGQwKCkKWyAgIDExLjE3MzEyNl0gQ1BVOiAw
IFBJRDogMSBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTAuMC1yYzctMDA5MjUtZzRj
NWM2ZmMgIzYKWyAgIDExLjE3NDExMl0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJ
T1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgMTEuMTc0ODg1XSAgMDAwMDAwMDAgNGQ0ODVkYzAg
NDMzM2ZmMjEgNGQ0ODVkZTggNDEwNzcyZjcgNDNkNmUzYTUgNDNlZTU5ZDQgMDAwMDAzMDcK
WyAgIDExLjE3NjA5Nl0gIDQyYTk4MjczIDQyYTk4MjczIDQ2MjAwYmQ4IDAwMDAwMDAxIDAw
MDAwMDAwIDRkNDg1ZGY4IDQxMDc3NDllIDAwMDAwMDA5ClsgICAxMS4xNzc0MTddICAwMDAw
MDAwMCA0ZDQ4NWUzMCA0MmE5ODI3MyA0M2UyNWNjYSA0ZDQ4NWUxYyAwMDAwMDJiOCA0NjIw
MGJkOCA0MmE5Nzg1YQpbICAgMTEuMTc4NjMzXSBDYWxsIFRyYWNlOgpbICAgMTEuMTc4OTg5
XSAgWzw0MzMzZmYyMT5dIGR1bXBfc3RhY2srMHgzMi8weDQyClsgICAxMS4xNzk2MDldICBb
PDQxMDc3MmY3Pl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHhiNy8weDEwMApbICAgMTEuMTgw
MzMzXSAgWzw0MmE5ODI3Mz5dID8gX192aWRlb19yZWdpc3Rlcl9kZXZpY2UrMHg2YTMvMHgx
MGQwClsgICAxMS4xODExMzhdICBbPDQyYTk4MjczPl0gPyBfX3ZpZGVvX3JlZ2lzdGVyX2Rl
dmljZSsweDZhMy8weDEwZDAKWyAgIDExLjE4MTk0Nl0gIFs8NDEwNzc0OWU+XSB3YXJuX3Ns
b3dwYXRoX251bGwrMHgzZS8weDUwClsgICAxMS4xODI2NDVdICBbPDQyYTk4MjczPl0gX192
aWRlb19yZWdpc3Rlcl9kZXZpY2UrMHg2YTMvMHgxMGQwClsgICAxMS4xODM0MjFdICBbPDQy
YTk3ODVhPl0gPyB2aWRlb19kZXZpY2VfYWxsb2MrMHgyYS8weDQwClsgICAxMS4xODQxNDRd
ICBbPDQyYjM1MTE3Pl0gbTJtdGVzdF9wcm9iZSsweDE5Ny8weDQzMApbICAgMTEuMTg0ODIw
XSAgWzw0MTM4OWQxMD5dID8gc3lzZnNfZG9fY3JlYXRlX2xpbmsrMHhhMC8weGQwClsgICAx
MS4xODU1NzBdICBbPDQyMGE1NDlmPl0gcGxhdGZvcm1fZHJ2X3Byb2JlKzB4NGYvMHgxNTAK
WyAgIDExLjE4NjI3MV0gIFs8NDIwYTFkMTI+XSBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4MjUy
LzB4NWIwClsgICAxMS4xODcxMjddICBbPDQzMzk1MDE4Pl0gPyBtdXRleF9sb2NrX25lc3Rl
ZCsweDY4LzB4ODAKWyAgIDExLjE4NzgzOF0gIFs8NDIwYTIxZGY+XSBfX2RyaXZlcl9hdHRh
Y2grMHgxNmYvMHgxYzAKWyAgIDExLjE4ODUyMl0gIFs8NDIwYTIwNzA+XSA/IGRyaXZlcl9w
cm9iZV9kZXZpY2UrMHg1YjAvMHg1YjAKWyAgIDExLjE4OTI2OV0gIFs8NDIwOWQ3YTQ+XSBi
dXNfZm9yX2VhY2hfZGV2KzB4ZTQvMHgxNzAKWyAgIDExLjE4OTk1Ml0gIFs8NDIwYTE0MmM+
XSBkcml2ZXJfYXR0YWNoKzB4MmMvMHg0MApbICAgMTEuMTkwNTkyXSAgWzw0MjBhMjA3MD5d
ID8gZHJpdmVyX3Byb2JlX2RldmljZSsweDViMC8weDViMApbICAgMTEuMTkxMzQ0XSAgWzw0
MjA5ZjAyOD5dIGJ1c19hZGRfZHJpdmVyKzB4M2Y4LzB4NjYwClsgICAxMS4xOTIwMTZdICBb
PDQyMGEzNTc1Pl0gZHJpdmVyX3JlZ2lzdGVyKzB4MTI1LzB4NDkwClsgICAxMS4xOTI3MDBd
ICBbPDQyMGE2YmMwPl0gcGxhdGZvcm1fZHJpdmVyX3JlZ2lzdGVyKzB4YzAvMHhkMApbICAg
MTEuMTkzNDg5XSAgWzw0NDkyOGQzOT5dIG0ybXRlc3RfaW5pdCsweDVmLzB4YjUKWyAgIDEx
LjE5NDExNF0gIFs8NDQ5MjhjZGE+XSA/IHNtc2R2Yl9tb2R1bGVfaW5pdCsweGJkLzB4YmQK
WyAgIDExLjE5NDgzN10gIFs8NDQ4ODJhOTM+XSBkb19vbmVfaW5pdGNhbGwrMHgxMGEvMHgy
Y2UKWyAgIDExLjE5NTUxOV0gIFs8NDQ4ODJlOWE+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsw
eDI0My8weDQwYQpbICAgMTEuMTk2MjUzXSAgWzw0NDg4MTdmMz5dID8gZG9fZWFybHlfcGFy
YW0rMHgxNmYvMHgxNmYKWyAgIDExLjE5NzAwMl0gZHVtbXlfdWRjIGR1bW15X3VkYy4wOiBz
ZXRfYWRkcmVzcyA9IDIKWyAgIDExLjE5NzcyN10gIFs8NDMyZTVkN2U+XSBrZXJuZWxfaW5p
dCsweDFlLzB4MzIwClsgICAxMS4xOTgzNTddICBbPDQzMzllZGQ3Pl0gcmV0X2Zyb21fa2Vy
bmVsX3RocmVhZCsweDFiLzB4MjgKWyAgIDExLjE5OTEwMV0gIFs8NDMyZTVkNjA+XSA/IHJl
c3RfaW5pdCsweDMzMC8weDMzMApbICAgMTEuMTk5ODAyXSAtLS1bIGVuZCB0cmFjZSA0YmYy
YTk5MTNmNmY0Yzk0IF0tLS0KL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDE1LTA2MjUvNGM1
YzZmYzExZWUzMGRkZjQ3YzM3NzJmM2IxZWMzZjc2ZjBlMjQzNy9kbWVzZy1rdm0tYmF5LTE3
NDE1LTIwMTMwNjI1MjA1NzUxLTMuMTAuMC1yYzctMDA5MjUtZzRjNWM2ZmMtNgova2VybmVs
L2kzODYtcmFuZGNvbmZpZy14MTUtMDYyNS80YzVjNmZjMTFlZTMwZGRmNDdjMzc3MmYzYjFl
YzNmNzZmMGUyNDM3L2RtZXNnLWt2bS1jYWlyby0xNzAxNy0yMDEzMDYyNTIwMjMzNi0tCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxNS0wNjI1LzRjNWM2ZmMxMWVlMzBkZGY0N2MzNzcy
ZjNiMWVjM2Y3NmYwZTI0MzcvZG1lc2cta3ZtLWNhaXJvLTE5NDQ5LTIwMTMwNjI1MjAyMzQ2
LTMuMTAuMC1yYzctMDA5MjUtZzRjNWM2ZmMtNgova2VybmVsL2kzODYtcmFuZGNvbmZpZy14
MTUtMDYyNS80YzVjNmZjMTFlZTMwZGRmNDdjMzc3MmYzYjFlYzNmNzZmMGUyNDM3L2RtZXNn
LWt2bS1jYWlyby0yMTMxNC0yMDEzMDYyNTIwMjMzNi0zLjEwLjAtcmM3LTAwOTI1LWc0YzVj
NmZjLTYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDE1LTA2MjUvNGM1YzZmYzExZWUzMGRk
ZjQ3YzM3NzJmM2IxZWMzZjc2ZjBlMjQzNy9kbWVzZy1rdm0tY2Fpcm8tMjcxMjMtMjAxMzA2
MjUyMDIzNTAtMy4xMC4wLXJjNy0wMDkyNS1nNGM1YzZmYy02Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXgxNS0wNjI1LzRjNWM2ZmMxMWVlMzBkZGY0N2MzNzcyZjNiMWVjM2Y3NmYwZTI0
MzcvZG1lc2cta3ZtLWNhaXJvLTI3ODAyLTIwMTMwNjI1MjAyMzUwLTMuMTAuMC1yYzctMDAz
NjctZ2IyZTBiM2MtOAova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MTUtMDYyNS80YzVjNmZj
MTFlZTMwZGRmNDdjMzc3MmYzYjFlYzNmNzZmMGUyNDM3L2RtZXNnLWt2bS1jYWlyby0zNjE0
OS0yMDEzMDYyNTIwMjMzNi0zLjEwLjAtcmM3LTAwMzY3LWdiMmUwYjNjLTgKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWcteDE1LTA2MjUvNGM1YzZmYzExZWUzMGRkZjQ3YzM3NzJmM2IxZWMz
Zjc2ZjBlMjQzNy9kbWVzZy1rdm0tbGtwLXNieDA0LTEwOTY1LTIwMTMwNjI2MDA1OTM1LTMu
MTAuMC1yYzUtMDAwNzctZ2FkNDJmYzYtMTgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDE1
LTA2MjUvNGM1YzZmYzExZWUzMGRkZjQ3YzM3NzJmM2IxZWMzZjc2ZjBlMjQzNy9kbWVzZy1r
dm0tbGtwLXNieDA0LTExNDQ5LTIwMTMwNjI2MDA1OTM5LTMuMTAuMC1yYzUtMDAwNzctZ2Fk
NDJmYzYtMTcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWcteDE1LTA2MjUvNGM1YzZmYzExZWUz
MGRkZjQ3YzM3NzJmM2IxZWMzZjc2ZjBlMjQzNy9kbWVzZy1rdm0tbGtwLXNieDA0LTExNDQ5
LTIwMTMwNjI2MDEwMDM1LTMuMTAuMC1yYzUtMDAwNzctZ2FkNDJmYzYtMTcKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWcteDE1LTA2MjUvNGM1YzZmYzExZWUzMGRkZjQ3YzM3NzJmM2IxZWMz
Zjc2ZjBlMjQzNy9kbWVzZy1rdm0tbGtwLXNieDA0LTExNjctMjAxMzA2MjYwMDU5NDgtLQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy14MTUtMDYyNS80YzVjNmZjMTFlZTMwZGRmNDdjMzc3
MmYzYjFlYzNmNzZmMGUyNDM3L2RtZXNnLWt2bS1sa3Atc2J4MDQtMTE4MzgtMjAxMzA2MjYw
MTAwNDctLQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MTUtMDYyNS80YzVjNmZjMTFlZTMw
ZGRmNDdjMzc3MmYzYjFlYzNmNzZmMGUyNDM3L2RtZXNnLWt2bS1sa3Atc2J4MDQtMTQ2MTct
MjAxMzA2MjYwMDU5NDgtLQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MTUtMDYyNS80YzVj
NmZjMTFlZTMwZGRmNDdjMzc3MmYzYjFlYzNmNzZmMGUyNDM3L2RtZXNnLWt2bS1sa3Atc2J4
MDQtMjkxNjQtMjAxMzA2MjYwMDU5NDktLQova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MTUt
MDYyNS80YzVjNmZjMTFlZTMwZGRmNDdjMzc3MmYzYjFlYzNmNzZmMGUyNDM3L2RtZXNnLWt2
bS1sa3Atc2J4MDQtMzcwNjYtMjAxMzA2MjYwMTAwMjYtLQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy14MTUtMDYyNS80YzVjNmZjMTFlZTMwZGRmNDdjMzc3MmYzYjFlYzNmNzZmMGUyNDM3
L2RtZXNnLWt2bS1sa3Atc2J4MDQtMzkyMTQtMjAxMzA2MjYwMTAwMjgtLQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy14MTUtMDYyNS80YzVjNmZjMTFlZTMwZGRmNDdjMzc3MmYzYjFlYzNm
NzZmMGUyNDM3L2RtZXNnLWt2bS1sa3Atc2J4MDQtNDE5MzktMjAxMzA2MjYwMDU5MjQtMy4x
MC4wLXJjNy0wMDkyNS1nNGM1YzZmYy02Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxNS0w
NjI1LzRjNWM2ZmMxMWVlMzBkZGY0N2MzNzcyZjNiMWVjM2Y3NmYwZTI0MzcvZG1lc2cta3Zt
LWxrcC1zYngwNC00NDUwOC0yMDEzMDYyNjAxMDAzNS0tCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLXgxNS0wNjI1LzRjNWM2ZmMxMWVlMzBkZGY0N2MzNzcyZjNiMWVjM2Y3NmYwZTI0Mzcv
ZG1lc2cta3ZtLWxrcC1zYngwNC00NTAxMy0yMDEzMDYyNjAxMDA0MC0tCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXgxNS0wNjI1LzRjNWM2ZmMxMWVlMzBkZGY0N2MzNzcyZjNiMWVjM2Y3
NmYwZTI0MzcvZG1lc2cta3ZtLWxrcC1zYngwNC01MTIzNy0yMDEzMDYyNjAxMDA0Mi0tCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxNS0wNjI1LzRjNWM2ZmMxMWVlMzBkZGY0N2MzNzcy
ZjNiMWVjM2Y3NmYwZTI0MzcvZG1lc2cta3ZtLWxrcC1zYngwNC01MjI2LTIwMTMwNjI2MDAy
NzAxLTMuMTAuMC1yYzctMDA1NjgtZ2U5ZTRmYjEtMTQKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWcteDE1LTA2MjUvNGM1YzZmYzExZWUzMGRkZjQ3YzM3NzJmM2IxZWMzZjc2ZjBlMjQzNy9k
bWVzZy1rdm0tbGtwLXNieDA0LTU0MTYyLTIwMTMwNjI2MDA1OTMyLS0KL2tlcm5lbC9pMzg2
LXJhbmRjb25maWcteDE1LTA2MjUvNGM1YzZmYzExZWUzMGRkZjQ3YzM3NzJmM2IxZWMzZjc2
ZjBlMjQzNy9kbWVzZy1rdm0tbGtwLXNieDA0LTU3NjU5LTIwMTMwNjI2MDAyNjU2LTMuMTAu
MC1yYzctMDA5MjUtZzRjNWM2ZmMtNgova2VybmVsL2kzODYtcmFuZGNvbmZpZy14MTUtMDYy
NS80YzVjNmZjMTFlZTMwZGRmNDdjMzc3MmYzYjFlYzNmNzZmMGUyNDM3L2RtZXNnLWt2bS1s
a3Atc2J4MDQtNjA3NjEtMjAxMzA2MjYwMDU5MzEtLQova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy14MTUtMDYyNS80YzVjNmZjMTFlZTMwZGRmNDdjMzc3MmYzYjFlYzNmNzZmMGUyNDM3L2Rt
ZXNnLWt2bS1sa3Atc2J4MDQtNjIyNy0yMDEzMDYyNjAxMDAzMi0tCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLXgxNS0wNjI1LzRjNWM2ZmMxMWVlMzBkZGY0N2MzNzcyZjNiMWVjM2Y3NmYw
ZTI0MzcvZG1lc2cta3ZtLWxrcC1zYngwNC02OTcwLTIwMTMwNjI2MDEwMDQxLS0KL2tlcm5l
bC9pMzg2LXJhbmRjb25maWcteDE1LTA2MjUvNGM1YzZmYzExZWUzMGRkZjQ3YzM3NzJmM2Ix
ZWMzZjc2ZjBlMjQzNy9kbWVzZy1rdm0tbGtwLXNieDA0LTkyMTItMjAxMzA2MjYwMDI2NTYt
My4xMC4wLXJjNy0wMDU3NS1nZTliZDdkMC04Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgx
NS0wNjI1LzRjNWM2ZmMxMWVlMzBkZGY0N2MzNzcyZjNiMWVjM2Y3NmYwZTI0MzcvZG1lc2ct
a3ZtLXJvYW0tMTk0MjgtMjAxMzA2MjUyMDU0MTAtMy4xMC4wLXJjNy0wMDkyNS1nNGM1YzZm
Yy02Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXgxNS0wNjI1LzRjNWM2ZmMxMWVlMzBkZGY0
N2MzNzcyZjNiMWVjM2Y3NmYwZTI0MzcvZG1lc2cta3ZtLXJvYW0tNjA4LTIwMTMwNjI1MjA1
NDIxLTMuOS4wLXJjNC0wMDIyNy1nNjdlMTdjMS02MgoKW2RldGFjaGVkIEhFQUQgM2YwMjk2
Ml0gUmV2ZXJ0ICJbbWVkaWFdIHY0bDI6IGFsd2F5cyByZXF1aXJlIHY0bDJfZGV2LCByZW5h
bWUgcGFyZW50IHRvIGRldl9wYXJlbnQiCiAzIGZpbGVzIGNoYW5nZWQsIDI3IGluc2VydGlv
bnMoKyksIDE4IGRlbGV0aW9ucygtKQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0vaTM4Ni1yYW5kY29uZmlnLXgxNS0wNjI1L2xpbnV4LWRldmVsOmRldmVsLXhpYW4taTM4
Ni0yMDEzMDYyNTE5MDU6M2YwMjk2Mjk1MWQxYTY3ZGNjYWU2OWJkYjM2NDUzMjU5OTk1ODc0
YjpiaXNlY3QtbmV0CgoyMDEzLTA2LTI1LTIyOjI2OjE1IDNmMDI5NjI5NTFkMWE2N2RjY2Fl
NjliZGIzNjQ1MzI1OTk5NTg3NGIgY29tcGlsaW5nCjIwMTMtMDYtMjUtMjI6MzE6MjQgM2Yw
Mjk2Mjk1MWQxYTY3ZGNjYWU2OWJkYjM2NDUzMjU5OTk1ODc0YiBTS0lQIEJST0tFTiBCVUlM
RApDaGVjayBlcnJvcyBpbiAvY2Mvd2ZnL25ldC1iaXNlY3QgYW5kIC90bXAva2VybmVsL2kz
ODYtcmFuZGNvbmZpZy14MTUtMDYyNS8zZjAyOTYyOTUxZDFhNjdkY2NhZTY5YmRiMzY0NTMy
NTk5OTU4NzRiCgo9PT09PT09PT0gdXBzdHJlYW0gPT09PT09PT09CkZldGNoaW5nIGxpbnVz
CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWcteDE1
LTA2MjUvbGludXgtZGV2ZWw6ZGV2ZWwteGlhbi1pMzg2LTIwMTMwNjI1MTkwNTpmOTdmN2Qy
ZDI3YmYwOTJiNDBiYWJkYTlkZWQyOWNjODVjZjc3ZWVjOmJpc2VjdC1uZXQKCjIwMTMtMDYt
MjUtMjI6MzE6MzUgZjk3ZjdkMmQyN2JmMDkyYjQwYmFiZGE5ZGVkMjljYzg1Y2Y3N2VlYyBj
b21waWxpbmcKCjIwMTMtMDYtMjUtMjI6MzM6NTAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4x
MC4wLXJjNy0wMDAxNC1nZjk3ZjdkMi4uCTEJMTUJMjEJMjcJMzMJMzkJNDMJNTAJNTYJNjEJ
NjcuCTc2CTgxCTg1CTg5Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4JOTAgU1VDQ0VTUwoKCj09PT09PT09PSBsaW51eC1uZXh0ID09
PT09PT09PQpGZXRjaGluZyBuZXh0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2
bS9pMzg2LXJhbmRjb25maWcteDE1LTA2MjUvbGludXgtZGV2ZWw6ZGV2ZWwteGlhbi1pMzg2
LTIwMTMwNjI1MTkwNTpjMGE0YjkzM2FhNmZiOGJkYzIxY2I4NTQ2MzNlYTA3Nzc5Y2RhMmIx
OmJpc2VjdC1uZXQKCjIwMTMtMDYtMjUtMjM6MTE6MzMgYzBhNGI5MzNhYTZmYjhiZGMyMWNi
ODU0NjMzZWEwNzc3OWNkYTJiMSBjb21waWxpbmcKCjIwMTMtMDYtMjUtMjM6MjE6MjQgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMC4wLXJjNy1uZXh0LTIwMTMwNjI1LTA4NTk0LWdjMGE0
YjkzLi4uCTIJNQkxMQkyMAkyNgkzMwkzNQk0NQk0OAk1Nwk2MQk2Nwk2OAk2OQk3Mgk3NAk3
Ngk3Nwk4Mgk4NQk4Ny4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7MzVtYWRk
X3RvX3J1bl9xdWV1ZSAzG1swbQouLgk4OC4JODkJOTAgU1VDQ0VTUwoK

--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.10.0-rc7 Kernel Configuration
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
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
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
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set
# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
# CONFIG_TREE_PREEMPT_RCU is not set
CONFIG_TINY_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HOTPLUG=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
# CONFIG_EVENTFD is not set
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
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
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
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
# CONFIG_ACORN_PARTITION_POWERTEC is not set
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
# CONFIG_MSDOS_PARTITION is not set
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
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
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
CONFIG_CPU_SUP_CYRIX_32=y
# CONFIG_CPU_SUP_AMD is not set
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
# CONFIG_X86_UP_APIC is not set
CONFIG_X86_MCE=y
# CONFIG_X86_ANCIENT_MCE is not set
# CONFIG_X86_MCE_INJECT is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
CONFIG_MICROCODE_INTEL_EARLY=y
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
CONFIG_VMSPLIT_1G=y
CONFIG_PAGE_OFFSET=0x40000000
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
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
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
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
CONFIG_APM_IGNORE_USER_SUSPEND=y
CONFIG_APM_DO_ENABLE=y
# CONFIG_APM_CPU_IDLE is not set
# CONFIG_APM_DISPLAY_BLANK is not set
# CONFIG_APM_ALLOW_INTS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
CONFIG_X86_GX_SUSPMOD=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=y
CONFIG_X86_P4_CLOCKMOD=y
CONFIG_X86_CPUFREQ_NFORCE2=y
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
# CONFIG_PCI_ATS is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=y
# CONFIG_SCx200HR_TIMER is not set
# CONFIG_OLPC is not set
# CONFIG_ALIX is not set
CONFIG_NET5501=y
# CONFIG_GEOS is not set
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
# CONFIG_YENTA_TOSHIBA is not set
CONFIG_PD6729=y
CONFIG_I82092=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_COMPAQ is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=y
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=y
# CONFIG_HOTPLUG_PCI_SHPC is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
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
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_NETFILTER_XTABLES=y
CONFIG_BRIDGE_NF_EBTABLES=y
CONFIG_BRIDGE_EBT_BROUTE=y
CONFIG_BRIDGE_EBT_T_FILTER=y
CONFIG_BRIDGE_EBT_T_NAT=y
CONFIG_BRIDGE_EBT_802_3=y
CONFIG_BRIDGE_EBT_AMONG=y
CONFIG_BRIDGE_EBT_ARP=y
# CONFIG_BRIDGE_EBT_IP is not set
# CONFIG_BRIDGE_EBT_LIMIT is not set
CONFIG_BRIDGE_EBT_MARK=y
CONFIG_BRIDGE_EBT_PKTTYPE=y
CONFIG_BRIDGE_EBT_STP=y
CONFIG_BRIDGE_EBT_VLAN=y
CONFIG_BRIDGE_EBT_DNAT=y
CONFIG_BRIDGE_EBT_MARK_T=y
CONFIG_BRIDGE_EBT_REDIRECT=y
CONFIG_BRIDGE_EBT_SNAT=y
CONFIG_BRIDGE_EBT_LOG=y
CONFIG_BRIDGE_EBT_ULOG=y
CONFIG_BRIDGE_EBT_NFLOG=y
# CONFIG_ATM is not set
CONFIG_STP=y
CONFIG_MRP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=y
# CONFIG_DEV_APPLETALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
CONFIG_PHONET=y
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_NC=y
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=y
# CONFIG_VSOCKETS is not set
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=y
# CONFIG_BT_RFCOMM is not set
# CONFIG_BT_BNEP is not set
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
CONFIG_BT_HCIBTSDIO=y
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM203X is not set
CONFIG_BT_HCIBPA10X=y
CONFIG_BT_HCIBFUSB=y
CONFIG_BT_HCIDTL1=y
CONFIG_BT_HCIBT3C=y
CONFIG_BT_HCIBLUECARD=y
# CONFIG_BT_HCIBTUART is not set
# CONFIG_BT_HCIVHCI is not set
# CONFIG_BT_MRVL is not set
CONFIG_BT_ATH3K=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=y
CONFIG_NL80211_TESTMODE=y
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_CFG80211_CERTIFICATION_ONUS=y
# CONFIG_CFG80211_DEFAULT_PS is not set
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
CONFIG_LIB80211_DEBUG=y
CONFIG_MAC80211=y
# CONFIG_MAC80211_RC_PID is not set
# CONFIG_MAC80211_RC_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT=""

#
# Some wireless drivers require a rate control algorithm
#
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=y
# CONFIG_CAIF_USB is not set
CONFIG_NFC=y
# CONFIG_NFC_NCI is not set
CONFIG_NFC_HCI=y
# CONFIG_NFC_SHDLC is not set

#
# Near Field Communication (NFC) devices
#
# CONFIG_NFC_PN533 is not set
# CONFIG_NFC_SIM is not set
CONFIG_NFC_PN544=y
CONFIG_NFC_MICROREAD=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_CMA is not set

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
# CONFIG_FTL is not set
CONFIG_NFTL=y
# CONFIG_NFTL_RW is not set
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
CONFIG_SSFDC=y
CONFIG_SM_FTL=y
CONFIG_MTD_OOPS=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_GEN_PROBE=y
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
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
# CONFIG_MTD_RAM is not set
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
CONFIG_MTD_SC520CDP=y
CONFIG_MTD_NETSC520=y
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_SCx200_DOCFLASH is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=y
# CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
# CONFIG_MTD_DATAFLASH_OTP is not set
# CONFIG_MTD_M25P80 is not set
# CONFIG_MTD_SST25L is not set
# CONFIG_MTD_SLRAM is not set
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
# CONFIG_MTD_NAND is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
CONFIG_MTD_UBI_GLUEBI=y
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
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
CONFIG_AD525X_DPOT_SPI=y
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
CONFIG_CS5535_CLOCK_EVENT_SRC=y
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_BMP085_SPI=y
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_LATTICE_ECP3_CONFIG=y
CONFIG_SRAM=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_93XX46=y
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
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
# CONFIG_VMWARE_VMCI is not set
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
# CONFIG_BLK_DEV_IDECD is not set
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
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
CONFIG_BLK_DEV_GENERIC=y
CONFIG_BLK_DEV_OPTI621=y
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
CONFIG_BLK_DEV_AMD74XX=y
CONFIG_BLK_DEV_ATIIXP=y
CONFIG_BLK_DEV_CMD64X=y
# CONFIG_BLK_DEV_TRIFLEX is not set
CONFIG_BLK_DEV_CS5520=y
CONFIG_BLK_DEV_CS5530=y
CONFIG_BLK_DEV_CS5535=y
CONFIG_BLK_DEV_CS5536=y
CONFIG_BLK_DEV_HPT366=y
CONFIG_BLK_DEV_JMICRON=y
CONFIG_BLK_DEV_SC1200=y
CONFIG_BLK_DEV_PIIX=y
CONFIG_BLK_DEV_IT8172=y
CONFIG_BLK_DEV_IT8213=y
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
CONFIG_BLK_DEV_PDC202XX_NEW=y
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
CONFIG_BLK_DEV_SIS5513=y
CONFIG_BLK_DEV_SLC90E66=y
CONFIG_BLK_DEV_TRM290=y
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_ATA is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
# CONFIG_BCACHE is not set
# CONFIG_BLK_DEV_DM is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_CONFIG=y
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=y
# CONFIG_I2O_BLOCK is not set
CONFIG_I2O_PROC=y
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_DUMMY=y
# CONFIG_EQUALIZER is not set
CONFIG_MII=y
CONFIG_NET_TEAM=y
CONFIG_NET_TEAM_MODE_BROADCAST=y
# CONFIG_NET_TEAM_MODE_ROUNDROBIN is not set
CONFIG_NET_TEAM_MODE_RANDOM=y
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=y
CONFIG_NET_TEAM_MODE_LOADBALANCE=y
CONFIG_MACVLAN=y
CONFIG_MACVTAP=y
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
CONFIG_TUN=y
CONFIG_VETH=y
CONFIG_VIRTIO_NET=y
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
# CONFIG_ARCNET_1051 is not set
CONFIG_ARCNET_RAW=y
CONFIG_ARCNET_CAP=y
CONFIG_ARCNET_COM90xx=y
CONFIG_ARCNET_COM90xxIO=y
# CONFIG_ARCNET_RIM_I is not set
CONFIG_ARCNET_COM20020=y
CONFIG_ARCNET_COM20020_PCI=y
CONFIG_ARCNET_COM20020_CS=y

#
# CAIF transport drivers
#
# CONFIG_CAIF_TTY is not set
# CONFIG_CAIF_SPI_SLAVE is not set
CONFIG_CAIF_HSI=y
# CONFIG_CAIF_VIRTIO is not set

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
# CONFIG_NET_DSA_MV88E6060 is not set
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
# CONFIG_ETHERNET is not set
CONFIG_FDDI=y
CONFIG_DEFXX=y
CONFIG_DEFXX_MMIO=y
CONFIG_SKFP=y
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
# CONFIG_AMD_PHY is not set
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
# CONFIG_LXT_PHY is not set
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM87XX_PHY is not set
# CONFIG_ICPLUS_PHY is not set
CONFIG_REALTEK_PHY=y
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=y
CONFIG_MICREL_KS8995MA=y
CONFIG_PLIP=y
# CONFIG_PPP is not set
# CONFIG_SLIP is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
CONFIG_USB_KAWETH=y
# CONFIG_USB_PEGASUS is not set
CONFIG_USB_RTL8150=y
CONFIG_USB_RTL8152=y
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=y
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=y
# CONFIG_USB_NET_CDC_MBIM is not set
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SMSC75XX is not set
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
# CONFIG_USB_AN2720 is not set
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
# CONFIG_USB_EPSON2888 is not set
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=y
# CONFIG_USB_NET_CX82310_ETH is not set
CONFIG_USB_NET_KALMIA=y
CONFIG_USB_NET_QMI_WWAN=y
CONFIG_USB_NET_INT51X1=y
CONFIG_USB_CDC_PHONET=y
CONFIG_USB_IPHETH=y
# CONFIG_USB_SIERRA_NET is not set
# CONFIG_USB_VL600 is not set
CONFIG_WLAN=y
# CONFIG_PCMCIA_RAYCS is not set
CONFIG_LIBERTAS_THINFIRM=y
CONFIG_LIBERTAS_THINFIRM_DEBUG=y
# CONFIG_LIBERTAS_THINFIRM_USB is not set
CONFIG_AIRO=y
CONFIG_ATMEL=y
# CONFIG_PCI_ATMEL is not set
# CONFIG_PCMCIA_ATMEL is not set
CONFIG_AT76C50X_USB=y
CONFIG_AIRO_CS=y
# CONFIG_PCMCIA_WL3501 is not set
CONFIG_PRISM54=y
# CONFIG_USB_ZD1201 is not set
CONFIG_USB_NET_RNDIS_WLAN=y
CONFIG_RTL8180=y
CONFIG_RTL8187=y
CONFIG_RTL8187_LEDS=y
CONFIG_ADM8211=y
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
CONFIG_ATH_COMMON=y
CONFIG_ATH_CARDS=y
CONFIG_ATH_DEBUG=y
# CONFIG_ATH5K is not set
CONFIG_ATH5K_PCI=y
CONFIG_ATH9K_HW=y
CONFIG_ATH9K_COMMON=y
CONFIG_ATH9K_DFS_DEBUGFS=y
# CONFIG_ATH9K_BTCOEX_SUPPORT is not set
CONFIG_ATH9K=y
CONFIG_ATH9K_PCI=y
# CONFIG_ATH9K_AHB is not set
CONFIG_ATH9K_DEBUGFS=y
CONFIG_ATH9K_DFS_CERTIFIED=y
# CONFIG_ATH9K_LEGACY_RATE_CONTROL is not set
# CONFIG_ATH9K_HTC is not set
CONFIG_CARL9170=y
# CONFIG_CARL9170_LEDS is not set
CONFIG_CARL9170_DEBUGFS=y
CONFIG_CARL9170_WPC=y
CONFIG_CARL9170_HWRNG=y
CONFIG_ATH6KL=y
# CONFIG_ATH6KL_SDIO is not set
CONFIG_ATH6KL_USB=y
# CONFIG_ATH6KL_DEBUG is not set
# CONFIG_ATH6KL_TRACING is not set
CONFIG_ATH6KL_REGDOMAIN=y
# CONFIG_AR5523 is not set
CONFIG_WIL6210=y
# CONFIG_WIL6210_ISR_COR is not set
CONFIG_WIL6210_TRACING=y
# CONFIG_ATH10K is not set
CONFIG_B43=y
CONFIG_B43_SSB=y
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_PCMCIA=y
CONFIG_B43_SDIO=y
CONFIG_B43_PIO=y
CONFIG_B43_PHY_N=y
CONFIG_B43_PHY_LP=y
CONFIG_B43_LEDS=y
CONFIG_B43_HWRNG=y
# CONFIG_B43_DEBUG is not set
# CONFIG_B43LEGACY is not set
CONFIG_BRCMUTIL=y
CONFIG_BRCMFMAC=y
# CONFIG_BRCMFMAC_SDIO is not set
CONFIG_BRCMFMAC_USB=y
# CONFIG_BRCM_TRACING is not set
CONFIG_BRCMDBG=y
CONFIG_HOSTAP=y
# CONFIG_HOSTAP_FIRMWARE is not set
CONFIG_HOSTAP_PLX=y
CONFIG_HOSTAP_PCI=y
# CONFIG_HOSTAP_CS is not set
CONFIG_IPW2100=y
CONFIG_IPW2100_MONITOR=y
CONFIG_IPW2100_DEBUG=y
# CONFIG_IPW2200 is not set
CONFIG_LIBIPW=y
# CONFIG_LIBIPW_DEBUG is not set
# CONFIG_IWLWIFI is not set
CONFIG_IWLEGACY=y
# CONFIG_IWL4965 is not set
CONFIG_IWL3945=y

#
# iwl3945 / iwl4965 Debugging Options
#
# CONFIG_IWLEGACY_DEBUG is not set
# CONFIG_IWLEGACY_DEBUGFS is not set
# CONFIG_LIBERTAS is not set
CONFIG_HERMES=y
CONFIG_HERMES_PRISM=y
# CONFIG_HERMES_CACHE_FW_ON_INIT is not set
# CONFIG_PLX_HERMES is not set
CONFIG_TMD_HERMES=y
CONFIG_NORTEL_HERMES=y
CONFIG_PCI_HERMES=y
CONFIG_PCMCIA_HERMES=y
CONFIG_PCMCIA_SPECTRUM=y
CONFIG_ORINOCO_USB=y
# CONFIG_P54_COMMON is not set
CONFIG_RT2X00=y
CONFIG_RT2400PCI=y
CONFIG_RT2500PCI=y
CONFIG_RT61PCI=y
# CONFIG_RT2800PCI is not set
# CONFIG_RT2500USB is not set
CONFIG_RT73USB=y
# CONFIG_RT2800USB is not set
CONFIG_RT2X00_LIB_MMIO=y
CONFIG_RT2X00_LIB_PCI=y
CONFIG_RT2X00_LIB_USB=y
CONFIG_RT2X00_LIB=y
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_LEDS=y
CONFIG_RT2X00_LIB_DEBUGFS=y
CONFIG_RT2X00_DEBUG=y
# CONFIG_RTLWIFI is not set
# CONFIG_WL_TI is not set
# CONFIG_ZD1211RW is not set
CONFIG_MWIFIEX=y
CONFIG_MWIFIEX_SDIO=y
CONFIG_MWIFIEX_PCIE=y
CONFIG_MWIFIEX_USB=y
# CONFIG_CW1200 is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=y
CONFIG_WIMAX_I2400M_USB=y
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
# CONFIG_WAN is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
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
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
# CONFIG_TABLET_USB_AIPTEK is not set
CONFIG_TABLET_USB_GTCO=y
CONFIG_TABLET_USB_HANWANG=y
CONFIG_TABLET_USB_KBTAB=y
CONFIG_TABLET_USB_WACOM=y
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PARKBD=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
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
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MRST_MAX3110 is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=y
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_GEODE is not set
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y
CONFIG_SONYPI=y

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_INFINEON=y
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
CONFIG_I2C_MUX_PCA9541=y
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=y
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_EG20T=y
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_INTEL_MID=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=y
CONFIG_I2C_VIPERBOARD=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_SCx200_I2C=y
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
CONFIG_SCx200_ACB=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_LM70_LLP=y
CONFIG_SPI_OC_TINY=y
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
CONFIG_SPI_PXA2XX_PCI=y
CONFIG_SPI_SC18IS602=y
CONFIG_SPI_TOPCLIFF_PCH=y
CONFIG_SPI_XCOMM=y
CONFIG_SPI_XILINX=y
CONFIG_SPI_DESIGNWARE=y
CONFIG_SPI_DW_PCI=y

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=y

#
# Qualcomm MSM SSBI bus support
#
CONFIG_SSBI=y
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_PARPORT=y
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
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_TS5500=y
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=y
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_RC5T583 is not set
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_STMPE=y
CONFIG_GPIO_TC3589X=y
# CONFIG_GPIO_TPS65912 is not set
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM831X=y
# CONFIG_GPIO_WM8350 is not set
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5520=y
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=y
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_LANGWELL=y
CONFIG_GPIO_PCH=y
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MCP23S08=y
CONFIG_GPIO_MC33880=y
CONFIG_GPIO_74X164=y

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_JANZ_TTL is not set
CONFIG_GPIO_PALMAS=y
# CONFIG_GPIO_TPS65910 is not set

#
# USB GPIO expanders:
#
CONFIG_GPIO_VIPERBOARD=y
CONFIG_W1=y

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
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
CONFIG_WM8350_POWER=y
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_88PM860X=y
CONFIG_BATTERY_DS2760=y
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
CONFIG_BATTERY_DA9052=y
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_88PM860X=y
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_LP8727=y
# CONFIG_CHARGER_LP8788 is not set
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_SMB347 is not set
CONFIG_BATTERY_GOLDFISH=y
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADCXX=y
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IIO_HWMON=y
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM70=y
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX1111=y
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_NCT6775 is not set
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SHT21 is not set
CONFIG_SENSORS_SIS5595=y
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
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
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_CPU_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
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
CONFIG_MFD_CS5535=y
CONFIG_MFD_AS3711=y
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
CONFIG_MFD_CROS_EC_SPI=y
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_HTC_PASIC3 is not set
CONFIG_HTC_I2CPLD=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_EZX_PCAP=y
CONFIG_MFD_VIPERBOARD=y
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
CONFIG_STMPE_SPI=y
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
# CONFIG_TPS6105X is not set
CONFIG_TPS65010=y
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS65912_SPI=y
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_ARIZONA_SPI=y
# CONFIG_MFD_WM5102 is not set
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM831X_SPI is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=y
# CONFIG_VIDEO_V4L2_SUBDEV_API is not set
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_TUNER=y
CONFIG_V4L2_MEM2MEM_DEV=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_VIDEOBUF_DVB=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_CONTIG=y
CONFIG_VIDEOBUF2_VMALLOC=y
# CONFIG_VIDEO_V4L2_INT_DEVICE is not set
CONFIG_DVB_CORE=y
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
CONFIG_RC_MAP=y
# CONFIG_RC_DECODERS is not set
CONFIG_RC_DEVICES=y
CONFIG_RC_ATI_REMOTE=y
# CONFIG_IR_ENE is not set
CONFIG_IR_IMON=y
# CONFIG_IR_MCEUSB is not set
# CONFIG_IR_ITE_CIR is not set
# CONFIG_IR_FINTEK is not set
# CONFIG_IR_NUVOTON is not set
# CONFIG_IR_REDRAT3 is not set
CONFIG_IR_STREAMZAP=y
# CONFIG_IR_WINBOND_CIR is not set
CONFIG_IR_IGUANA=y
CONFIG_IR_TTUSBIR=y
CONFIG_RC_LOOPBACK=y
CONFIG_IR_GPIO_CIR=y
# CONFIG_MEDIA_USB_SUPPORT is not set
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#

#
# Media capture/analog TV support
#
CONFIG_VIDEO_IVTV=y
# CONFIG_VIDEO_FB_IVTV is not set
CONFIG_VIDEO_ZORAN=y
CONFIG_VIDEO_ZORAN_DC30=y
# CONFIG_VIDEO_ZORAN_ZR36060 is not set
CONFIG_VIDEO_HEXIUM_GEMINI=y
CONFIG_VIDEO_HEXIUM_ORION=y
CONFIG_VIDEO_MXB=y

#
# Media capture/analog/hybrid TV support
#
# CONFIG_VIDEO_CX18 is not set
# CONFIG_VIDEO_CX25821 is not set
CONFIG_VIDEO_CX88=y
CONFIG_VIDEO_CX88_BLACKBIRD=y
# CONFIG_VIDEO_CX88_DVB is not set
CONFIG_VIDEO_CX88_MPEG=y
CONFIG_VIDEO_BT848=y
# CONFIG_DVB_BT8XX is not set
# CONFIG_VIDEO_SAA7134 is not set
CONFIG_VIDEO_SAA7164=y

#
# Media digital TV PCI Adapters
#
# CONFIG_DVB_AV7110 is not set
# CONFIG_DVB_BUDGET_CORE is not set
CONFIG_DVB_B2C2_FLEXCOP_PCI=y
# CONFIG_DVB_B2C2_FLEXCOP_PCI_DEBUG is not set
CONFIG_DVB_PLUTO2=y
CONFIG_DVB_DM1105=y
# CONFIG_DVB_PT1 is not set
# CONFIG_MANTIS_CORE is not set
CONFIG_DVB_NGENE=y
# CONFIG_DVB_DDBRIDGE is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
CONFIG_V4L_MEM2MEM_DRIVERS=y
CONFIG_VIDEO_SH_VEU=y
CONFIG_V4L_TEST_DRIVERS=y
CONFIG_VIDEO_MEM2MEM_TESTDEV=y

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=y
# CONFIG_MEDIA_PARPORT_SUPPORT is not set
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_SI470X is not set
# CONFIG_USB_MR800 is not set
CONFIG_USB_DSBR=y
CONFIG_RADIO_SHARK2=y
# CONFIG_I2C_SI4713 is not set
# CONFIG_RADIO_SI4713 is not set
CONFIG_USB_KEENE=y
# CONFIG_USB_MA901 is not set
CONFIG_RADIO_TEA5764=y
# CONFIG_RADIO_TEA5764_XTAL is not set
CONFIG_RADIO_SAA7706H=y
CONFIG_RADIO_TEF6862=y
CONFIG_RADIO_WL1273=y

#
# Texas Instruments WL128x FM driver (ST based)
#
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_VIDEO_CX2341X=y
CONFIG_VIDEO_BTCX=y
CONFIG_VIDEO_TVEEPROM=y
CONFIG_CYPRESS_FIRMWARE=y
CONFIG_DVB_B2C2_FLEXCOP=y
CONFIG_VIDEO_SAA7146=y
CONFIG_VIDEO_SAA7146_VV=y
CONFIG_SMS_SIANO_MDTV=y
# CONFIG_SMS_SIANO_RC is not set

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
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
CONFIG_VIDEO_MSP3400=y
CONFIG_VIDEO_CS5345=y
CONFIG_VIDEO_CS53L32A=y
CONFIG_VIDEO_TLV320AIC23B=y
# CONFIG_VIDEO_UDA1342 is not set
CONFIG_VIDEO_WM8775=y
CONFIG_VIDEO_WM8739=y
CONFIG_VIDEO_VP27SMPX=y
CONFIG_VIDEO_SONY_BTF_MPX=y

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=y
# CONFIG_VIDEO_ADV7183 is not set
CONFIG_VIDEO_BT819=y
# CONFIG_VIDEO_BT856 is not set
CONFIG_VIDEO_BT866=y
CONFIG_VIDEO_KS0127=y
# CONFIG_VIDEO_ML86V7667 is not set
# CONFIG_VIDEO_SAA7110 is not set
CONFIG_VIDEO_SAA711X=y
# CONFIG_VIDEO_SAA7191 is not set
CONFIG_VIDEO_TVP514X=y
CONFIG_VIDEO_TVP5150=y
CONFIG_VIDEO_TVP7002=y
# CONFIG_VIDEO_TW2804 is not set
CONFIG_VIDEO_TW9903=y
# CONFIG_VIDEO_TW9906 is not set
CONFIG_VIDEO_VPX3220=y

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=y
CONFIG_VIDEO_CX25840=y

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=y
CONFIG_VIDEO_SAA7185=y
CONFIG_VIDEO_ADV7170=y
# CONFIG_VIDEO_ADV7175 is not set
# CONFIG_VIDEO_ADV7343 is not set
CONFIG_VIDEO_ADV7393=y
CONFIG_VIDEO_AK881X=y
# CONFIG_VIDEO_THS8200 is not set

#
# Camera sensor devices
#
CONFIG_VIDEO_OV7640=y
CONFIG_VIDEO_OV7670=y
CONFIG_VIDEO_VS6624=y
CONFIG_VIDEO_MT9V011=y
# CONFIG_VIDEO_SR030PC30 is not set

#
# Flash devices
#
# CONFIG_VIDEO_ADP1653 is not set
CONFIG_VIDEO_AS3645A=y

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=y
CONFIG_VIDEO_UPD64083=y

#
# Miscelaneous helper chips
#
CONFIG_VIDEO_THS7303=y
CONFIG_VIDEO_M52790=y

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
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
# CONFIG_MEDIA_TUNER_MT2060 is not set
CONFIG_MEDIA_TUNER_MT2063=y
CONFIG_MEDIA_TUNER_MT2266=y
CONFIG_MEDIA_TUNER_MT2131=y
CONFIG_MEDIA_TUNER_QT1010=y
# CONFIG_MEDIA_TUNER_XC2028 is not set
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
# CONFIG_MEDIA_TUNER_MXL5005S is not set
# CONFIG_MEDIA_TUNER_MXL5007T is not set
# CONFIG_MEDIA_TUNER_MC44S803 is not set
CONFIG_MEDIA_TUNER_MAX2165=y
CONFIG_MEDIA_TUNER_TDA18218=y
# CONFIG_MEDIA_TUNER_FC0011 is not set
CONFIG_MEDIA_TUNER_FC0012=y
CONFIG_MEDIA_TUNER_FC0013=y
CONFIG_MEDIA_TUNER_TDA18212=y
CONFIG_MEDIA_TUNER_E4000=y
CONFIG_MEDIA_TUNER_FC2580=y
# CONFIG_MEDIA_TUNER_TUA9001 is not set
CONFIG_MEDIA_TUNER_IT913X=y
CONFIG_MEDIA_TUNER_R820T=y

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=y
CONFIG_DVB_STB6100=y
CONFIG_DVB_STV090x=y
# CONFIG_DVB_STV6110x is not set

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=y
# CONFIG_DVB_TDA18271C2DD is not set

#
# DVB-S (satellite) frontends
#
# CONFIG_DVB_CX24110 is not set
CONFIG_DVB_CX24123=y
CONFIG_DVB_MT312=y
CONFIG_DVB_ZL10036=y
CONFIG_DVB_ZL10039=y
CONFIG_DVB_S5H1420=y
CONFIG_DVB_STV0288=y
# CONFIG_DVB_STB6000 is not set
# CONFIG_DVB_STV0299 is not set
CONFIG_DVB_STV6110=y
CONFIG_DVB_STV0900=y
# CONFIG_DVB_TDA8083 is not set
CONFIG_DVB_TDA10086=y
CONFIG_DVB_TDA8261=y
# CONFIG_DVB_VES1X93 is not set
CONFIG_DVB_TUNER_ITD1000=y
CONFIG_DVB_TUNER_CX24113=y
CONFIG_DVB_TDA826X=y
# CONFIG_DVB_TUA6100 is not set
# CONFIG_DVB_CX24116 is not set
CONFIG_DVB_SI21XX=y
CONFIG_DVB_TS2020=y
CONFIG_DVB_DS3000=y
CONFIG_DVB_MB86A16=y
CONFIG_DVB_TDA10071=y

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=y
CONFIG_DVB_SP887X=y
CONFIG_DVB_CX22700=y
CONFIG_DVB_CX22702=y
CONFIG_DVB_S5H1432=y
CONFIG_DVB_DRXD=y
# CONFIG_DVB_L64781 is not set
CONFIG_DVB_TDA1004X=y
CONFIG_DVB_NXT6000=y
# CONFIG_DVB_MT352 is not set
CONFIG_DVB_ZL10353=y
CONFIG_DVB_DIB3000MB=y
# CONFIG_DVB_DIB3000MC is not set
# CONFIG_DVB_DIB7000M is not set
# CONFIG_DVB_DIB7000P is not set
CONFIG_DVB_DIB9000=y
CONFIG_DVB_TDA10048=y
CONFIG_DVB_AF9013=y
CONFIG_DVB_EC100=y
CONFIG_DVB_HD29L2=y
# CONFIG_DVB_STV0367 is not set
CONFIG_DVB_CXD2820R=y
# CONFIG_DVB_RTL2830 is not set
# CONFIG_DVB_RTL2832 is not set

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=y
CONFIG_DVB_TDA10021=y
# CONFIG_DVB_TDA10023 is not set
CONFIG_DVB_STV0297=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=y
CONFIG_DVB_OR51211=y
# CONFIG_DVB_OR51132 is not set
CONFIG_DVB_BCM3510=y
CONFIG_DVB_LGDT330X=y
CONFIG_DVB_LGDT3305=y
# CONFIG_DVB_LG2160 is not set
# CONFIG_DVB_S5H1409 is not set
# CONFIG_DVB_AU8522_DTV is not set
# CONFIG_DVB_AU8522_V4L is not set
CONFIG_DVB_S5H1411=y

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=y
CONFIG_DVB_DIB8000=y
CONFIG_DVB_MB86A20S=y

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=y
# CONFIG_DVB_TUNER_DIB0070 is not set
CONFIG_DVB_TUNER_DIB0090=y

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=y
# CONFIG_DVB_LNBP22 is not set
# CONFIG_DVB_ISL6405 is not set
# CONFIG_DVB_ISL6421 is not set
CONFIG_DVB_ISL6423=y
# CONFIG_DVB_A8293 is not set
# CONFIG_DVB_LGS8GL5 is not set
CONFIG_DVB_LGS8GXX=y
CONFIG_DVB_ATBM8830=y
# CONFIG_DVB_TDA665x is not set
# CONFIG_DVB_IX2505V is not set
CONFIG_DVB_IT913X_FE=y
# CONFIG_DVB_M88RS2000 is not set
CONFIG_DVB_AF9033=y

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_ALI=y
# CONFIG_AGP_ATI is not set
CONFIG_AGP_AMD=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_NVIDIA=y
CONFIG_AGP_SIS=y
CONFIG_AGP_SWORKS=y
# CONFIG_AGP_VIA is not set
CONFIG_AGP_EFFICEON=y
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_USB=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
# CONFIG_DRM_TTM is not set

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_I2C_NXP_TDA998X is not set
CONFIG_DRM_TDFX=y
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
# CONFIG_DRM_RADEON_UMS is not set
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
CONFIG_DRM_MGA=y
# CONFIG_DRM_SIS is not set
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
CONFIG_DRM_VMWGFX=y
CONFIG_DRM_VMWGFX_FBCON=y
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=y
CONFIG_DRM_AST=y
# CONFIG_DRM_MGAG200 is not set
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_DRM_QXL=y
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
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
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
CONFIG_FB_BIG_ENDIAN=y
# CONFIG_FB_LITTLE_ENDIAN is not set
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
CONFIG_FB_PM2=y
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=y
# CONFIG_FB_CYBER2000_DDC is not set
# CONFIG_FB_ARC is not set
CONFIG_FB_ASILIANT=y
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=y
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
CONFIG_FB_NVIDIA_DEBUG=y
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
# CONFIG_FB_RIVA is not set
CONFIG_FB_I740=y
CONFIG_FB_I810=y
CONFIG_FB_I810_GTF=y
CONFIG_FB_I810_I2C=y
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
CONFIG_FB_MATROX_MYSTIQUE=y
# CONFIG_FB_MATROX_G is not set
CONFIG_FB_MATROX_I2C=y
# CONFIG_FB_RADEON is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
# CONFIG_FB_ATY_GENERIC_LCD is not set
CONFIG_FB_ATY_GX=y
# CONFIG_FB_ATY_BACKLIGHT is not set
CONFIG_FB_S3=y
CONFIG_FB_S3_DDC=y
CONFIG_FB_SAVAGE=y
# CONFIG_FB_SAVAGE_I2C is not set
# CONFIG_FB_SAVAGE_ACCEL is not set
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
# CONFIG_FB_SIS_315 is not set
CONFIG_FB_VIA=y
CONFIG_FB_VIA_DIRECT_PROCFS=y
CONFIG_FB_VIA_X_COMPATIBILITY=y
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
# CONFIG_FB_3DFX is not set
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
CONFIG_FB_CARMINE=y
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_SM501=y
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=y
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
# CONFIG_FB_METRONOME is not set
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_L4F00242T03 is not set
CONFIG_LCD_LMS283GF05=y
# CONFIG_LCD_LTV350QV is not set
CONFIG_LCD_ILI922X=y
CONFIG_LCD_ILI9320=y
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=y
CONFIG_LCD_S6E63M0=y
CONFIG_LCD_LD9040=y
CONFIG_LCD_AMS369FG06=y
CONFIG_LCD_LMS501KF03=y
CONFIG_LCD_HX8357=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_LM3533 is not set
CONFIG_BACKLIGHT_CARILLO_RANCH=y
CONFIG_BACKLIGHT_DA9052=y
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_WM831X is not set
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_88PM860X=y
# CONFIG_BACKLIGHT_AAT2870 is not set
CONFIG_BACKLIGHT_LM3630=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_LP8788=y
CONFIG_BACKLIGHT_OT200=y
# CONFIG_BACKLIGHT_TPS65217 is not set
# CONFIG_BACKLIGHT_AS3711 is not set
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
# CONFIG_LOGO_LINUX_CLUT224 is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
CONFIG_HID_APPLEIR=y
CONFIG_HID_AUREAL=y
# CONFIG_HID_BELKIN is not set
CONFIG_HID_CHERRY=y
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CYPRESS is not set
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EMS_FF=y
# CONFIG_HID_ELECOM is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_HOLTEK=y
# CONFIG_HOLTEK_FF is not set
CONFIG_HID_KEYTOUCH=y
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=y
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LCPOWER=y
# CONFIG_HID_LENOVO_TPKBD is not set
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
# CONFIG_HID_NTRIG is not set
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
# CONFIG_HID_PICOLCD_LCD is not set
# CONFIG_HID_PICOLCD_LEDS is not set
# CONFIG_HID_PICOLCD_CIR is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_PS3REMOTE is not set
CONFIG_HID_ROCCAT=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=y
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=y
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_HID_SENSOR_HUB=y

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
CONFIG_I2C_HID=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=y
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_XHCI_HCD_DEBUGGING is not set
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_SSB=y
CONFIG_USB_OHCI_HCD_PLATFORM=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=y
CONFIG_USB_SL811_HCD=y
CONFIG_USB_SL811_HCD_ISO=y
CONFIG_USB_SL811_CS=y
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_WHCI_HCD=y
# CONFIG_USB_HWA_HCD is not set
CONFIG_USB_HCD_SSB=y
CONFIG_USB_MUSB_HDRC=y
CONFIG_USB_MUSB_TUSB6010=y
# CONFIG_USB_MUSB_DSPS is not set
# CONFIG_USB_MUSB_UX500 is not set
CONFIG_MUSB_PIO_ONLY=y
# CONFIG_USB_RENESAS_USBHS is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
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
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_DWC3 is not set
CONFIG_USB_CHIPIDEA=y
# CONFIG_USB_CHIPIDEA_UDC is not set
# CONFIG_USB_CHIPIDEA_HOST is not set
CONFIG_USB_CHIPIDEA_DEBUG=y

#
# USB port drivers
#
CONFIG_USB_USS720=y
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
# CONFIG_USB_ADUTUX is not set
CONFIG_USB_SEVSEG=y
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=y
# CONFIG_USB_LCD is not set
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=y
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HSIC_USB3503 is not set
# CONFIG_USB_PHY is not set
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_DEBUG=y
# CONFIG_USB_GADGET_DEBUG_FILES is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FUSB300=y
CONFIG_USB_R8A66597=y
CONFIG_USB_PXA27X=y
CONFIG_USB_MV_UDC=y
CONFIG_USB_MV_U3D=y
# CONFIG_USB_GADGET_MUSB_HDRC is not set
CONFIG_USB_M66592=y
# CONFIG_USB_AMD5536UDC is not set
CONFIG_USB_NET2272=y
# CONFIG_USB_NET2272_DMA is not set
CONFIG_USB_NET2280=y
CONFIG_USB_GOKU=y
# CONFIG_USB_EG20T is not set
CONFIG_USB_DUMMY_HCD=y
CONFIG_USB_LIBCOMPOSITE=y
# CONFIG_USB_ZERO is not set
CONFIG_USB_ETH=y
CONFIG_USB_ETH_RNDIS=y
CONFIG_USB_ETH_EEM=y
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_NOKIA is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_USB_G_WEBCAM is not set
CONFIG_UWB=y
# CONFIG_UWB_HWA is not set
CONFIG_UWB_WHCI=y
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_UNSAFE_RESUME=y
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_WBSD=y
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_SDRICOH_CS=y
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MMC_VUB300=y
CONFIG_MMC_USHC=y
CONFIG_MMC_REALTEK_PCI=y
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_MEMSTICK_R592=y
CONFIG_MEMSTICK_REALTEK_PCI=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3533 is not set
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_NET48XX=y
CONFIG_LEDS_WRAP=y
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8788=y
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA9633=y
CONFIG_LEDS_WM831X_STATUS=y
# CONFIG_LEDS_WM8350 is not set
# CONFIG_LEDS_DA9052 is not set
# CONFIG_LEDS_DAC124S085 is not set
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_INTEL_SS4200=y
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_ADP5520 is not set
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_MAX8997=y
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
# CONFIG_LEDS_TRIGGER_CAMERA is not set
CONFIG_ACCESSIBILITY=y
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
# CONFIG_INFINIBAND_USER_ACCESS is not set
CONFIG_INFINIBAND_MTHCA=y
# CONFIG_INFINIBAND_MTHCA_DEBUG is not set
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_AMD76X=y
CONFIG_EDAC_E7XXX=y
CONFIG_EDAC_E752X=y
CONFIG_EDAC_I82875P=y
CONFIG_EDAC_I82975X=y
CONFIG_EDAC_I3000=y
CONFIG_EDAC_I3200=y
CONFIG_EDAC_X38=y
CONFIG_EDAC_I5400=y
# CONFIG_EDAC_I82860 is not set
CONFIG_EDAC_R82600=y
CONFIG_EDAC_I5000=y
# CONFIG_EDAC_I5100 is not set
CONFIG_EDAC_I7300=y
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV is not set
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
CONFIG_UIO_AEC=y
# CONFIG_UIO_SERCOS3 is not set
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
CONFIG_EXTCON_ADC_JACK=y
CONFIG_EXTCON_MAX77693=y
CONFIG_EXTCON_MAX8997=y
CONFIG_MEMORY=y
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
CONFIG_HID_SENSOR_ACCEL_3D=y
# CONFIG_KXSD9 is not set
# CONFIG_IIO_ST_ACCEL_3AXIS is not set

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
CONFIG_AD7266=y
# CONFIG_AD7298 is not set
CONFIG_AD7923=y
CONFIG_AD7791=y
CONFIG_AD7793=y
CONFIG_AD7476=y
CONFIG_AD7887=y
CONFIG_LP8788_ADC=y
CONFIG_MAX1363=y
# CONFIG_TI_ADC081C is not set
CONFIG_TI_AM335X_ADC=y
CONFIG_VIPERBOARD_ADC=y

#
# Amplifiers
#
# CONFIG_AD8366 is not set

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
# CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS is not set
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_SPI=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
CONFIG_AD5360=y
CONFIG_AD5380=y
CONFIG_AD5421=y
# CONFIG_AD5624R_SPI is not set
CONFIG_AD5446=y
CONFIG_AD5449=y
# CONFIG_AD5504 is not set
CONFIG_AD5755=y
# CONFIG_AD5764 is not set
CONFIG_AD5791=y
CONFIG_AD5686=y
CONFIG_MAX517=y
# CONFIG_MCP4725 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
# CONFIG_AD9523 is not set

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=y

#
# Digital gyroscope sensors
#
CONFIG_ADIS16080=y
CONFIG_ADIS16136=y
CONFIG_ADXRS450=y
CONFIG_HID_SENSOR_GYRO_3D=y
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_IIO_ST_GYRO_SPI_3AXIS=y
CONFIG_ITG3200=y

#
# Inertial measurement units
#
CONFIG_ADIS16400=y
CONFIG_ADIS16480=y
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y
CONFIG_INV_MPU6050_IIO=y

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
CONFIG_SENSORS_LM3533=y
CONFIG_SENSORS_TSL2563=y
# CONFIG_VCNL4000 is not set
# CONFIG_HID_SENSOR_ALS is not set

#
# Magnetometer sensors
#
CONFIG_AK8975=y
CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
# CONFIG_IIO_ST_MAGN_3AXIS is not set
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
CONFIG_VME_TSI148=y

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=y

#
# VME Device Drivers
#
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
CONFIG_EXT4_FS_SECURITY=y
CONFIG_EXT4_DEBUG=y
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
# CONFIG_OCFS2_FS_STATS is not set
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

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
# CONFIG_PROC_SYSCTL is not set
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
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
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
# CONFIG_NLS_UTF8 is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_PREEMPT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
# CONFIG_PROVE_RCU_DELAY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_LKDTM=y
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAIL_MMC_REQUEST=y
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
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
# CONFIG_SCHED_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
# CONFIG_TRACER_SNAPSHOT is not set
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
CONFIG_STACK_TRACER=y
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
# CONFIG_EARLY_PRINTK is not set
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
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
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
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
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER_X86=y
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
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
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
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=y
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
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
CONFIG_CRYPTO_DEV_GEODE=y
CONFIG_CRYPTO_DEV_HIFN_795X=y
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
CONFIG_ASYMMETRIC_KEY_TYPE=y
# CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
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
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
CONFIG_DDR=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_ATA_SFF is not set
# CONFIG_ISDN_DRV_LOOP is not set

--i0/AhcQY5QxfSsSZ--
