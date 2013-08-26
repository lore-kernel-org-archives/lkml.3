Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab3HZA6Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 20:58:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:27007 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754543Ab3HZA6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 20:58:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,954,1367996400"; 
   d="log'?scan'208";a="386331224"
Date: Mon, 26 Aug 2013 08:58:09 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: fengguang.wu@intel.com, Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [accent_init] BUG: unable to handle kernel NULL pointer dereference
 at 00000078
Message-ID: <20130826005809.GA8764@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Russell King,

Here is another bug that's triggered by

commit c817a67ecba7c3c2aaa104796d78f160af60920d
Author: Russell King <rmk+kernel@arm.linux.org.uk>
Date:   Thu Jun 27 15:06:14 2013 +0100

    kobject: delayed kobject release: help find buggy drivers
    
[   50.519381] WARNING: CPU: 0 PID: 1 at lib/debugobjects.c:260 debug_print_object+0x76/0x84()
[   50.519381] ODEBUG: init active (active state 0) object type: timer_list hint:   (null)
[   50.519381] Modules linked in:
[   50.519381] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-rc6-next-20130822-07070-g245f086 #1
[   50.519381] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   50.519381]  40041b68 40041b68 40041b28 41340817 40041b58 41022949 41473af6 40041b84
[   50.519381]  00000001 41473b33 00000104 411e84d7 411e84d7 40085698 414e1f14 41451647
[   50.519381]  40041b70 4102298e 00000009 40041b68 41473af6 40041b84 40041ba4 411e84d7
[   50.519381] Call Trace:
[   50.519381]  [<41340817>] dump_stack+0x16/0x18
[   50.519381]  [<41022949>] warn_slowpath_common+0x70/0x87
[   50.519381]  [<411e84d7>] ? debug_print_object+0x76/0x84
[   50.519381]  [<411e84d7>] ? debug_print_object+0x76/0x84
[   50.519381]  [<4102298e>] warn_slowpath_fmt+0x2e/0x30
[   50.519381]  [<411e84d7>] debug_print_object+0x76/0x84
[   50.519381]  [<411e8762>] __debug_object_init+0x27d/0x2bb
[   50.519381]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.519381]  [<4102925e>] init_timer_key+0x17/0x64
[   50.519381]  [<411db4a5>] kobject_release+0x50/0x78
[   50.519381]  [<411db51c>] kobject_put+0x4f/0x55
[   50.519381]  [<410ad5bc>] cdev_del+0x23/0x26
[   50.519381]  [<41239fb5>] tty_unregister_device+0x33/0x37
[   50.519381]  [<41247439>] uart_remove_one_port+0xa1/0xee
[   50.519381]  [<41249025>] serial8250_register_8250_port+0xc1/0x235
[   50.519381]  [<41249354>] serial8250_probe+0x108/0x16a
[   50.519381]  [<4103f19a>] ? sched_clock_cpu+0xd8/0xee
[   50.519381]  [<4103f19a>] ? sched_clock_cpu+0xd8/0xee
[   50.519381]  [<4125f64a>] platform_drv_probe+0x29/0x4b
[   50.519381]  [<4125e242>] driver_probe_device+0x8f/0x194
[   50.519381]  [<4125f76c>] ? platform_match+0x52/0x66
[   50.519381]  [<4125e363>] __device_attach+0x1c/0x2c
[   50.519381]  [<4125ccb2>] bus_for_each_drv+0x38/0x6b
[   50.519381]  [<4125e17e>] device_attach+0x66/0x83
[   50.519381]  [<4125e347>] ? driver_probe_device+0x194/0x194
[   50.519381]  [<4125d8af>] bus_probe_device+0x25/0x84
[   50.519381]  [<4125c18b>] device_add+0x3e6/0x57b
[   50.519381]  [<411e35b9>] ? kvasprintf+0x3b/0x44
[   50.519381]  [<411db956>] ? kobject_set_name_vargs+0x3d/0x4a
[   50.519381]  [<4125f4ac>] platform_device_add+0x131/0x195
[   50.519381]  [<4125f97f>] platform_device_register+0x1c/0x1f
[   50.519381]  [<41677bb8>] ? setup_early_serial8250_console+0x376/0x376
[   50.519381]  [<41677bc5>] accent_init+0xd/0xf
[   50.519381]  [<410003df>] do_one_initcall+0x7e/0x10c
[   50.519381]  [<4165b400>] ? do_early_param+0x4f/0x7a
[   50.519381]  [<41035bcd>] ? parse_args+0x15d/0x222
[   50.519381]  [<4165ba89>] kernel_init_freeable+0x116/0x1b5
[   50.519381]  [<4165b42b>] ? do_early_param+0x7a/0x7a
[   50.519381]  [<4133b3b4>] kernel_init+0xb/0xc3
[   50.519381]  [<413499bb>] ret_from_kernel_thread+0x1b/0x30
[   50.519381]  [<4133b3a9>] ? rest_init+0xb5/0xb5
[   50.519381] ---[ end trace b81fc16491f309ce ]---

git bisect start 5e8d1acd05687720cbb0b08975eacb7588fdfc42 v3.10 --
git bisect good 8cbd0eefcaf8cc32ded2bf229f0fc379b2ad69f2  # 11:22     60+  Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux
git bisect good 60a2b977533c312d271563d955ef7b8e35a6aa38  # 11:35     60+  Merge remote-tracking branch 'infiniband/for-next'
git bisect  bad 4a225b466e040a70e7d12b159d2a36da1c2ef7dc  # 11:41      0-  next-20130821/driver-core
git bisect good 98246c1ae6f18fe1b710cdff687b6b7077f739c9  # 11:52     60+  Merge remote-tracking branch 'virtio/virtio-next'
git bisect good 38136c1f1471c7dcbe889beb790cc4d331e9d3ad  # 12:20     60+  Merge remote-tracking branch 'spi/for-next'
git bisect good f07762be3b9222a7649cb29a3f5b959204d40446  # 12:29     60+  Merge branch 'x86/asmlinkage'
git bisect good 93d6294dfcdff81194086ed9bd6ceca3bc5e5863  # 12:59     60+  Merge remote-tracking branch 'kvm-ppc/kvm-ppc-next'
git bisect good c57e8c89b271af4ef914c439effffed53c39434c  # 14:10     60+  Merge remote-tracking branch 'leds/for-next'
git bisect  bad 76f411fb3a62711de7f59e0f4c56456fe356675a  # 14:17      0-  x86 / cpu topology: remove the stale macro arch_provides_topology_pointers
git bisect  bad ea1bb7064fd6972ef00a93ba882a2f38450b273e  # 14:23      0-  video: backlight: convert class code to use dev_groups
git bisect good e56341ad380114454119ac043e6d710ddbbb7710  # 14:57     60+  staging: comedi: convert class code to use dev_groups
git bisect  bad c817a67ecba7c3c2aaa104796d78f160af60920d  # 15:09      0-  kobject: delayed kobject release: help find buggy drivers
git bisect good 7c42721fe0c58a848849b43ff558cf2fb86aa35a  # 15:42     60+  char: tile-srom: fix build error
git bisect good 7c42721fe0c58a848849b43ff558cf2fb86aa35a  # 16:11    180+  char: tile-srom: fix build error
git bisect  bad 245f08699d5320f021070ed8698ac89ebf2f0670  # 16:11      0-  Add linux-next specific files for 20130822
git bisect good cac778c7124d65bf7e3cf27b117a1287f202cac2  # 18:26    180+  Revert "kobject: delayed kobject release: help find buggy drivers"
git bisect good 8495e9c4a9616c9d19f23182d0536485902259db  # 22:05    180+  Merge tag 'acpi-3.11-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
git bisect  bad 245f08699d5320f021070ed8698ac89ebf2f0670  # 22:05      0-  Add linux-next specific files for 20130822

Thanks,
Fengguang

--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-ant-6043-20130824160438-3.11.0-rc6-next-20130822-07070-g245f086-1"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.11.0-rc6-next-20130822-07070-g245f086 (kbuil=
d@jaketown) (gcc version 4.8.1 (Debian 4.8.1-8) ) #1 PREEMPT Sat Aug 24 15:=
47:19 CST 2013
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] CPU: vendor_id 'AuthenticAMD' unknown, using generic init.
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
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
[    0.000000] initial memory mapped: [mem 0x00000000-0x023fffff]
[    0.000000] Base memory trampoline at [4009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
[    0.000000]  [mem 0x0e000000-0x0e3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
[    0.000000]  [mem 0x08000000-0x0dffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x07ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
[    0.000000]  [mem 0x0e400000-0x0fbfffff] page 2M
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x01ce7000, 0x01ce7fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128652(98%)
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
[    0.000000] BRK [0x01ce8000, 0x01ce8fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000] free_area_init_node: node 0, pgdat 41655fdc, node_mem_map 4d=
d3f020
[    0.000000]   Normal zone: 512 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 65436 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x10000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64924
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/i386-randconfig-j5-08241525/next:master/.vml=
inuz-245f08699d5320f021070ed8698ac89ebf2f0670-20130824154929-4-ant branch=
=3Dnext/master noapic nolapic nohz=3Doff BOOT_IMAGE=3D/kernel/i386-randconf=
ig-j5-08241525/245f08699d5320f021070ed8698ac89ebf2f0670/vmlinuz-3.11.0-rc6-=
next-20130822-07070-g245f086
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 212660K/261744K available (3369K kernel code, 1588K =
rwdata, 1540K rodata, 364K init, 6300K bss, 49084K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe2000 - 0xfffff000   ( 116 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x507fe000 - 0xff7fe000   (2800 MB)
[    0.000000]     lowmem  : 0x40000000 - 0x4fffe000   ( 255 MB)
[    0.000000]       .init : 0x4165b000 - 0x416b6000   ( 364 kB)
[    0.000000]       .data : 0x4134a99e - 0x4165a240   (3134 kB)
[    0.000000]       .text : 0x41000000 - 0x4134a99e   (3370 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3D40094000 soft=3D40096000
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
[    0.000000] ODEBUG: 7 of 7 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: Detected 3192.049 MHz processor
[    0.049137] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 6384.09 BogoMIPS (lpj=3D12768196)
[    0.053151] pid_max: default: 32768 minimum: 301
[    0.062375] Security Framework initialized
[    0.075107] Mount-cache hash table entries: 512
[    0.182463] Initializing cgroup subsys devices
[    0.186378] Initializing cgroup subsys net_cls
[    0.187391] Initializing cgroup subsys perf_event
[    0.201334] mce: CPU supports 10 MCE banks
[    0.202442] mce: unknown CPU type - not enabling MCE support
[    0.206219] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.206219] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.206219] tlb_flushall_shift: -1
[    0.208340] CPU: AuthenticAMD QEMU Virtual CPU version 1.5.0 (fam: 06, m=
odel: 02, stepping: 03)
[    0.252000] ACPI: Core revision 20130725
[    0.553095] ACPI: All ACPI Tables successfully acquired
[    0.554455] ACPI: setting ELCR to 0200 (from 0c00)
[    0.625797] Performance Events:=20
[    0.701236] NMI watchdog: disabled (cpu0): hardware events not enabled

[    0.805484] atomic64 test passed for i386+ platform with CX8 and with SSE
[    0.864624] regulator-dummy: no parameters
[    0.900893] NET: Registered protocol family 16
[    0.928518] EISA bus registered
[    0.930295] cpuidle: using governor ladder
[    0.932263] cpuidle: using governor menu
[    0.940844] ACPI: bus type PCI registered
[    0.952363] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.953508] PCI: Using configuration type 1 for base access
[    1.101664] bio: create slab <bio-0> at 0
[    1.153149] ACPI: Added _OSI(Module Device)
[    1.153994] ACPI: Added _OSI(Processor Device)
[    1.154709] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.155469] ACPI: Added _OSI(Processor Aggregator Device)
[    1.328615] ACPI: EC: Look up EC in DSDT
[    1.972283] ACPI: Interpreter enabled
[    1.973827] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20130725/hwxface-571)
[    1.975540] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20130725/hwxface-571)
[    1.992386] ACPI: (supports S0 S3 S4 S5)
[    1.993154] ACPI: Using PIC for interrupt routing
[    1.999138] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    3.585652] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    3.688000] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    3.716687] PCI host bridge to bus 0000:00
[    3.720918] pci_bus 0000:00: root bus resource [bus 00-ff]
[    3.724764] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    3.728255] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    3.729146] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    3.732288] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    3.748396] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    3.833309] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    3.868727] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    3.896437] pci 0000:00:01.1: reg 0x20: [io  0xc1e0-0xc1ef]
[    3.946870] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    3.953293] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    3.954564] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    3.983480] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    3.988397] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    3.994402] pci 0000:00:02.0: reg 0x14: [mem 0xfebe0000-0xfebe0fff]
[    4.020326] pci 0000:00:02.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    4.031881] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    4.038199] pci 0000:00:03.0: reg 0x10: [io  0xc1c0-0xc1df]
[    4.042271] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    4.068289] pci 0000:00:03.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    4.098429] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    4.104262] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    4.110521] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    4.134542] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    4.163033] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    4.168318] pci 0000:00:05.0: reg 0x10: [io  0xc040-0xc07f]
[    4.174312] pci 0000:00:05.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    4.236792] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    4.242390] pci 0000:00:06.0: reg 0x10: [io  0xc080-0xc0bf]
[    4.248292] pci 0000:00:06.0: reg 0x14: [mem 0xfebe3000-0xfebe3fff]
[    4.326116] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    4.332271] pci 0000:00:07.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    4.336297] pci 0000:00:07.0: reg 0x14: [mem 0xfebe4000-0xfebe4fff]
[    4.390041] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    4.396303] pci 0000:00:08.0: reg 0x10: [io  0xc100-0xc13f]
[    4.402268] pci 0000:00:08.0: reg 0x14: [mem 0xfebe5000-0xfebe5fff]
[    4.453510] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    4.458252] pci 0000:00:09.0: reg 0x10: [io  0xc140-0xc17f]
[    4.464270] pci 0000:00:09.0: reg 0x14: [mem 0xfebe6000-0xfebe6fff]
[    4.517550] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    4.522446] pci 0000:00:0a.0: reg 0x10: [io  0xc180-0xc1bf]
[    4.528249] pci 0000:00:0a.0: reg 0x14: [mem 0xfebe7000-0xfebe7fff]
[    4.581508] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    4.585476] pci 0000:00:0b.0: reg 0x10: [mem 0xfebe8000-0xfebe800f]
[    4.632822] pci_bus 0000:00: on NUMA node 0
[    4.633733] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    4.745608] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    4.764992] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    4.782968] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    4.801208] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    4.810771] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    4.876000] ACPI: Enabled 16 GPEs in block 00 to 0F
[    4.880884] ACPI: \_SB_.PCI0: notify handler is installed
[    4.896858] Found 1 acpi root devices
[    4.924000] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    4.924686] vgaarb: loaded
[    4.925248] vgaarb: bridge control possible 0000:00:02.0
[    4.946231] pps_core: LinuxPPS API ver. 1 registered
[    4.947010] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    4.964000] PCI: Using ACPI for IRQ routing
[    4.964000] PCI: pci_cache_line_size set to 64 bytes
[    4.964427] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    4.968706] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    5.056000] Switched to clocksource hpet
[    5.083573] pnp: PnP ACPI init
[    5.102676] ACPI: bus type PNP registered
[    5.126186] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    5.133959] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    5.158171] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    5.182886] pnp 00:03: [dma 2]
[    5.194232] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    5.213662] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    5.238648] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    5.317320] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    5.354334] pnp: PnP ACPI: found 7 devices
[    5.355147] ACPI: bus type PNP unregistered
[    5.485842] PM-Timer running at invalid rate: 106% of normal - aborting.
[    5.500992] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    5.501852] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    5.502595] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    5.510058] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    5.514923] NET: Registered protocol family 1
[    5.524010] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    5.525240] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    5.526967] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    5.535137] pci 0000:00:02.0: Boot video device
[    5.537785] PCI: CLS 0 bytes, default 64
[    5.665396] Unpacking initramfs...
[   49.360985] Freeing initrd memory: 25284K (4e73f000 - 4fff0000)
[   49.370217] Machine check injector initialized
[   49.380405] microcode: no support for this CPU vendor
[   49.400227] cryptomgr_test (18) used greatest stack depth: 7144 bytes le=
ft
[   49.492621] Initializing RT-Tester: OK
[   49.494397] audit: initializing netlink socket (disabled)
[   49.501052] type=3D2000 audit(1377330859.492:1): initialized
[   49.813214] Kprobe smoke test started
[   49.960086] Kprobe smoke test passed successfully
[   50.049598] NTFS driver 2.1.30 [Flags: R/O].
[   50.054825] fuse init (API version 7.22)
[   50.061581] JFS: nTxBlock =3D 1858, nTxLock =3D 14871
[   50.141427] cryptomgr_test (39) used greatest stack depth: 6860 bytes le=
ft
[   50.222928] io scheduler noop registered
[   50.229382] io scheduler deadline registered (default)
[   50.274903] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   50.278912] ACPI: Power Button [PWRF]
[   50.323984] r3964: Philips r3964 Driver $Revision: 1.10 $
[   50.325111] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   50.368563] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[   50.389975] tsc: Refined TSC clocksource calibration: 3192.001 MHz
[   50.393234] Switched to clocksource tsc
[   50.518049] ------------[ cut here ]------------
[   50.519381] WARNING: CPU: 0 PID: 1 at lib/debugobjects.c:260 debug_print=
_object+0x76/0x84()
[   50.519381] ODEBUG: init active (active state 0) object type: timer_list=
 hint:   (null)
[   50.519381] Modules linked in:
[   50.519381] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-rc6-next-2013=
0822-07070-g245f086 #1
[   50.519381] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   50.519381]  40041b68 40041b68 40041b28 41340817 40041b58 41022949 41473=
af6 40041b84
[   50.519381]  00000001 41473b33 00000104 411e84d7 411e84d7 40085698 414e1=
f14 41451647
[   50.519381]  40041b70 4102298e 00000009 40041b68 41473af6 40041b84 40041=
ba4 411e84d7
[   50.519381] Call Trace:
[   50.519381]  [<41340817>] dump_stack+0x16/0x18
[   50.519381]  [<41022949>] warn_slowpath_common+0x70/0x87
[   50.519381]  [<411e84d7>] ? debug_print_object+0x76/0x84
[   50.519381]  [<411e84d7>] ? debug_print_object+0x76/0x84
[   50.519381]  [<4102298e>] warn_slowpath_fmt+0x2e/0x30
[   50.519381]  [<411e84d7>] debug_print_object+0x76/0x84
[   50.519381]  [<411e8762>] __debug_object_init+0x27d/0x2bb
[   50.519381]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.519381]  [<4102925e>] init_timer_key+0x17/0x64
[   50.519381]  [<411db4a5>] kobject_release+0x50/0x78
[   50.519381]  [<411db51c>] kobject_put+0x4f/0x55
[   50.519381]  [<410ad5bc>] cdev_del+0x23/0x26
[   50.519381]  [<41239fb5>] tty_unregister_device+0x33/0x37
[   50.519381]  [<41247439>] uart_remove_one_port+0xa1/0xee
[   50.519381]  [<41249025>] serial8250_register_8250_port+0xc1/0x235
[   50.519381]  [<41249354>] serial8250_probe+0x108/0x16a
[   50.519381]  [<4103f19a>] ? sched_clock_cpu+0xd8/0xee
[   50.519381]  [<4103f19a>] ? sched_clock_cpu+0xd8/0xee
[   50.519381]  [<4125f64a>] platform_drv_probe+0x29/0x4b
[   50.519381]  [<4125e242>] driver_probe_device+0x8f/0x194
[   50.519381]  [<4125f76c>] ? platform_match+0x52/0x66
[   50.519381]  [<4125e363>] __device_attach+0x1c/0x2c
[   50.519381]  [<4125ccb2>] bus_for_each_drv+0x38/0x6b
[   50.519381]  [<4125e17e>] device_attach+0x66/0x83
[   50.519381]  [<4125e347>] ? driver_probe_device+0x194/0x194
[   50.519381]  [<4125d8af>] bus_probe_device+0x25/0x84
[   50.519381]  [<4125c18b>] device_add+0x3e6/0x57b
[   50.519381]  [<411e35b9>] ? kvasprintf+0x3b/0x44
[   50.519381]  [<411db956>] ? kobject_set_name_vargs+0x3d/0x4a
[   50.519381]  [<4125f4ac>] platform_device_add+0x131/0x195
[   50.519381]  [<4125f97f>] platform_device_register+0x1c/0x1f
[   50.519381]  [<41677bb8>] ? setup_early_serial8250_console+0x376/0x376
[   50.519381]  [<41677bc5>] accent_init+0xd/0xf
[   50.519381]  [<410003df>] do_one_initcall+0x7e/0x10c
[   50.519381]  [<4165b400>] ? do_early_param+0x4f/0x7a
[   50.519381]  [<41035bcd>] ? parse_args+0x15d/0x222
[   50.519381]  [<4165ba89>] kernel_init_freeable+0x116/0x1b5
[   50.519381]  [<4165b42b>] ? do_early_param+0x7a/0x7a
[   50.519381]  [<4133b3b4>] kernel_init+0xb/0xc3
[   50.519381]  [<413499bb>] ret_from_kernel_thread+0x1b/0x30
[   50.519381]  [<4133b3a9>] ? rest_init+0xb5/0xb5
[   50.519381] ---[ end trace b81fc16491f309ce ]---
[   50.580165] ------------[ cut here ]------------
[   50.580844] WARNING: CPU: 0 PID: 1 at lib/debugobjects.c:260 debug_print=
_object+0x76/0x84()
[   50.582036] ODEBUG: init active (active state 0) object type: timer_list=
 hint:   (null)
[   50.582942] Modules linked in:
[   50.583820] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.11.0-rc=
6-next-20130822-07070-g245f086 #1
[   50.583820] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   50.583820]  40041b18 40041b18 40041ad8 41340817 40041b08 41022949 41473=
af6 40041b34
[   50.583820]  00000001 41473b33 00000104 411e84d7 411e84d7 40085698 414e1=
f14 41451647
[   50.583820]  40041b20 4102298e 00000009 40041b18 41473af6 40041b34 40041=
b54 411e84d7
[   50.583820] Call Trace:
[   50.583820]  [<41340817>] dump_stack+0x16/0x18
[   50.583820]  [<41022949>] warn_slowpath_common+0x70/0x87
[   50.583820]  [<411e84d7>] ? debug_print_object+0x76/0x84
[   50.583820]  [<411e84d7>] ? debug_print_object+0x76/0x84
[   50.583820]  [<4102298e>] warn_slowpath_fmt+0x2e/0x30
[   50.583820]  [<411e84d7>] debug_print_object+0x76/0x84
[   50.583820]  [<411e8762>] __debug_object_init+0x27d/0x2bb
[   50.583820]  [<41345e51>] ? restore_all+0xf/0xf
[   50.583820]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.583820]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.583820]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.583820]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.583820]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.583820]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.583820]  [<4102925e>] init_timer_key+0x17/0x64
[   50.583820]  [<411db4a5>] kobject_release+0x50/0x78
[   50.583820]  [<411db51c>] kobject_put+0x4f/0x55
[   50.583820]  [<410ad5bc>] cdev_del+0x23/0x26
[   50.583820]  [<41239fb5>] tty_unregister_device+0x33/0x37
[   50.583820]  [<41247439>] uart_remove_one_port+0xa1/0xee
[   50.583820]  [<41249025>] serial8250_register_8250_port+0xc1/0x235
[   50.583820]  [<41249354>] serial8250_probe+0x108/0x16a
[   50.583820]  [<4103f19a>] ? sched_clock_cpu+0xd8/0xee
[   50.583820]  [<4103f19a>] ? sched_clock_cpu+0xd8/0xee
[   50.583820]  [<4125f64a>] platform_drv_probe+0x29/0x4b
[   50.583820]  [<4125e242>] driver_probe_device+0x8f/0x194
[   50.583820]  [<4125f76c>] ? platform_match+0x52/0x66
[   50.583820]  [<4125e363>] __device_attach+0x1c/0x2c
[   50.583820]  [<4125ccb2>] bus_for_each_drv+0x38/0x6b
[   50.583820]  [<4125e17e>] device_attach+0x66/0x83
[   50.583820]  [<4125e347>] ? driver_probe_device+0x194/0x194
[   50.583820]  [<4125d8af>] bus_probe_device+0x25/0x84
[   50.583820]  [<4125c18b>] device_add+0x3e6/0x57b
[   50.583820]  [<411e35b9>] ? kvasprintf+0x3b/0x44
[   50.583820]  [<411db956>] ? kobject_set_name_vargs+0x3d/0x4a
[   50.583820]  [<4125f4ac>] platform_device_add+0x131/0x195
[   50.583820]  [<4125f97f>] platform_device_register+0x1c/0x1f
[   50.583820]  [<41677bb8>] ? setup_early_serial8250_console+0x376/0x376
[   50.583820]  [<41677bc5>] accent_init+0xd/0xf
[   50.583820]  [<410003df>] do_one_initcall+0x7e/0x10c
[   50.583820]  [<4165b400>] ? do_early_param+0x4f/0x7a
[   50.583820]  [<41035bcd>] ? parse_args+0x15d/0x222
[   50.583820]  [<4165ba89>] kernel_init_freeable+0x116/0x1b5
[   50.583820]  [<4165b42b>] ? do_early_param+0x7a/0x7a
[   50.583820]  [<4133b3b4>] kernel_init+0xb/0xc3
[   50.583820]  [<413499bb>] ret_from_kernel_thread+0x1b/0x30
[   50.583820]  [<4133b3a9>] ? rest_init+0xb5/0xb5
[   50.583820] ---[ end trace b81fc16491f309cf ]---
[   50.632542] ------------[ cut here ]------------
[   50.633255] WARNING: CPU: 0 PID: 1 at lib/debugobjects.c:260 debug_print=
_object+0x76/0x84()
[   50.634659] ODEBUG: init active (active state 0) object type: timer_list=
 hint:   (null)
[   50.635911] Modules linked in:
[   50.636186] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.11.0-rc=
6-next-20130822-07070-g245f086 #1
[   50.636186] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   50.636186]  40041ac8 40041ac8 40041a88 41340817 40041ab8 41022949 41473=
af6 40041ae4
[   50.636186]  00000001 41473b33 00000104 411e84d7 411e84d7 40085698 414e1=
f14 41451647
[   50.636186]  40041ad0 4102298e 00000009 40041ac8 41473af6 40041ae4 40041=
b04 411e84d7
[   50.636186] Call Trace:
[   50.636186]  [<41340817>] dump_stack+0x16/0x18
[   50.636186]  [<41022949>] warn_slowpath_common+0x70/0x87
[   50.636186]  [<411e84d7>] ? debug_print_object+0x76/0x84
[   50.636186]  [<411e84d7>] ? debug_print_object+0x76/0x84
[   50.636186]  [<4102298e>] warn_slowpath_fmt+0x2e/0x30
[   50.636186]  [<411e84d7>] debug_print_object+0x76/0x84
[   50.636186]  [<411e8762>] __debug_object_init+0x27d/0x2bb
[   50.636186]  [<41345e51>] ? restore_all+0xf/0xf
[   50.636186]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.636186]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.636186]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.636186]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.636186]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.636186]  [<41345e51>] ? restore_all+0xf/0xf
[   50.636186]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.636186]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.636186]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.636186]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.636186]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.636186]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.636186]  [<4102925e>] init_timer_key+0x17/0x64
[   50.636186]  [<411db4a5>] kobject_release+0x50/0x78
[   50.636186]  [<411db51c>] kobject_put+0x4f/0x55
[   50.636186]  [<410ad5bc>] cdev_del+0x23/0x26
[   50.636186]  [<41239fb5>] tty_unregister_device+0x33/0x37
[   50.636186]  [<41247439>] uart_remove_one_port+0xa1/0xee
[   50.636186]  [<41249025>] serial8250_register_8250_port+0xc1/0x235
[   50.636186]  [<41249354>] serial8250_probe+0x108/0x16a
[   50.636186]  [<4103f19a>] ? sched_clock_cpu+0xd8/0xee
[   50.636186]  [<4103f19a>] ? sched_clock_cpu+0xd8/0xee
[   50.636186]  [<4125f64a>] platform_drv_probe+0x29/0x4b
[   50.636186]  [<4125e242>] driver_probe_device+0x8f/0x194
[   50.636186]  [<4125f76c>] ? platform_match+0x52/0x66
[   50.636186]  [<4125e363>] __device_attach+0x1c/0x2c
[   50.636186]  [<4125ccb2>] bus_for_each_drv+0x38/0x6b
[   50.636186]  [<4125e17e>] device_attach+0x66/0x83
[   50.636186]  [<4125e347>] ? driver_probe_device+0x194/0x194
[   50.636186]  [<4125d8af>] bus_probe_device+0x25/0x84
[   50.636186]  [<4125c18b>] device_add+0x3e6/0x57b
[   50.636186]  [<411e35b9>] ? kvasprintf+0x3b/0x44
[   50.636186]  [<411db956>] ? kobject_set_name_vargs+0x3d/0x4a
[   50.636186]  [<4125f4ac>] platform_device_add+0x131/0x195
[   50.636186]  [<4125f97f>] platform_device_register+0x1c/0x1f
[   50.636186]  [<41677bb8>] ? setup_early_serial8250_console+0x376/0x376
[   50.636186]  [<41677bc5>] accent_init+0xd/0xf
[   50.636186]  [<410003df>] do_one_initcall+0x7e/0x10c
[   50.636186]  [<4165b400>] ? do_early_param+0x4f/0x7a
[   50.636186]  [<41035bcd>] ? parse_args+0x15d/0x222
[   50.636186]  [<4165ba89>] kernel_init_freeable+0x116/0x1b5
[   50.636186]  [<4165b42b>] ? do_early_param+0x7a/0x7a
[   50.636186]  [<4133b3b4>] kernel_init+0xb/0xc3
[   50.636186]  [<413499bb>] ret_from_kernel_thread+0x1b/0x30
[   50.636186]  [<4133b3a9>] ? rest_init+0xb5/0xb5
[   50.636186] ---[ end trace b81fc16491f309d0 ]---
[   50.690272] ------------[ cut here ]------------
[   50.690916] WARNING: CPU: 0 PID: 1 at lib/debugobjects.c:260 debug_print=
_object+0x76/0x84()
[   50.692549] ODEBUG: init active (active state 0) object type: timer_list=
 hint:   (null)
[   50.693687] Modules linked in:
[   50.694000] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.11.0-rc=
6-next-20130822-07070-g245f086 #1
[   50.694000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   50.694000]  40041a78 40041a78 40041a38 41340817 40041a68 41022949 41473=
af6 40041a94
[   50.694000]  00000001 41473b33 00000104 411e84d7 411e84d7 40085698 414e1=
f14 41451647
[   50.694000]  40041a80 4102298e 00000009 40041a78 41473af6 40041a94 40041=
ab4 411e84d7
[   50.694000] Call Trace:
[   50.694000]  [<41340817>] dump_stack+0x16/0x18
[   50.694000]  [<41022949>] warn_slowpath_common+0x70/0x87
[   50.694000]  [<411e84d7>] ? debug_print_object+0x76/0x84
[   50.694000]  [<411e84d7>] ? debug_print_object+0x76/0x84
[   50.694000]  [<4102298e>] warn_slowpath_fmt+0x2e/0x30
[   50.694000]  [<411e84d7>] debug_print_object+0x76/0x84
[   50.694000]  [<411e8762>] __debug_object_init+0x27d/0x2bb
[   50.694000]  [<41345e51>] ? restore_all+0xf/0xf
[   50.694000]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.694000]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.694000]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.694000]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.694000]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.694000]  [<41345e51>] ? restore_all+0xf/0xf
[   50.694000]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.694000]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.694000]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.694000]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.694000]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.694000]  [<41345e51>] ? restore_all+0xf/0xf
[   50.694000]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.694000]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.694000]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.694000]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.694000]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.694000]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.694000]  [<4102925e>] init_timer_key+0x17/0x64
[   50.694000]  [<411db4a5>] kobject_release+0x50/0x78
[   50.694000]  [<411db51c>] kobject_put+0x4f/0x55
[   50.694000]  [<410ad5bc>] cdev_del+0x23/0x26
[   50.694000]  [<41239fb5>] tty_unregister_device+0x33/0x37
[   50.694000]  [<41247439>] uart_remove_one_port+0xa1/0xee
[   50.694000]  [<41249025>] serial8250_register_8250_port+0xc1/0x235
[   50.694000]  [<41249354>] serial8250_probe+0x108/0x16a
[   50.694000]  [<4103f19a>] ? sched_clock_cpu+0xd8/0xee
[   50.694000]  [<4103f19a>] ? sched_clock_cpu+0xd8/0xee
[   50.694000]  [<4125f64a>] platform_drv_probe+0x29/0x4b
[   50.694000]  [<4125e242>] driver_probe_device+0x8f/0x194
[   50.694000]  [<4125f76c>] ? platform_match+0x52/0x66
[   50.694000]  [<4125e363>] __device_attach+0x1c/0x2c
[   50.694000]  [<4125ccb2>] bus_for_each_drv+0x38/0x6b
[   50.694000]  [<4125e17e>] device_attach+0x66/0x83
[   50.694000]  [<4125e347>] ? driver_probe_device+0x194/0x194
[   50.694000]  [<4125d8af>] bus_probe_device+0x25/0x84
[   50.694000]  [<4125c18b>] device_add+0x3e6/0x57b
[   50.694000]  [<411e35b9>] ? kvasprintf+0x3b/0x44
[   50.694000]  [<411db956>] ? kobject_set_name_vargs+0x3d/0x4a
[   50.694000]  [<4125f4ac>] platform_device_add+0x131/0x195
[   50.694000]  [<4125f97f>] platform_device_register+0x1c/0x1f
[   50.694000]  [<41677bb8>] ? setup_early_serial8250_console+0x376/0x376
[   50.694000]  [<41677bc5>] accent_init+0xd/0xf
[   50.694000]  [<410003df>] do_one_initcall+0x7e/0x10c
[   50.694000]  [<4165b400>] ? do_early_param+0x4f/0x7a
[   50.694000]  [<41035bcd>] ? parse_args+0x15d/0x222
[   50.694000]  [<4165ba89>] kernel_init_freeable+0x116/0x1b5
[   50.694000]  [<4165b42b>] ? do_early_param+0x7a/0x7a
[   50.694000]  [<4133b3b4>] kernel_init+0xb/0xc3
[   50.694000]  [<413499bb>] ret_from_kernel_thread+0x1b/0x30
[   50.694000]  [<4133b3a9>] ? rest_init+0xb5/0xb5
[   50.694000] ---[ end trace b81fc16491f309d1 ]---
[   50.753189] ------------[ cut here ]------------
[   50.753914] WARNING: CPU: 0 PID: 1 at lib/debugobjects.c:260 debug_print=
_object+0x76/0x84()
[   50.755489] ODEBUG: init active (active state 0) object type: timer_list=
 hint:   (null)
[   50.756635] Modules linked in:
[   50.756885] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.11.0-rc=
6-next-20130822-07070-g245f086 #1
[   50.756885] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   50.756885]  40041a28 40041a28 400419e8 41340817 40041a18 41022949 41473=
af6 40041a44
[   50.756885]  00000001 41473b33 00000104 411e84d7 411e84d7 40085698 414e1=
f14 41451647
[   50.756885]  40041a30 4102298e 00000009 40041a28 41473af6 40041a44 40041=
a64 411e84d7
[   50.756885] Call Trace:
[   50.756885]  [<41340817>] dump_stack+0x16/0x18
[   50.756885]  [<41022949>] warn_slowpath_common+0x70/0x87
[   50.756885]  [<411e84d7>] ? debug_print_object+0x76/0x84
[   50.756885]  [<411e84d7>] ? debug_print_object+0x76/0x84
[   50.756885]  [<4102298e>] warn_slowpath_fmt+0x2e/0x30
[   50.756885]  [<411e84d7>] debug_print_object+0x76/0x84
[   50.756885]  [<411e8762>] __debug_object_init+0x27d/0x2bb
[   50.756885]  [<41345e51>] ? restore_all+0xf/0xf
[   50.756885]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.756885]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.756885]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.756885]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.756885]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.756885]  [<41345e51>] ? restore_all+0xf/0xf
[   50.756885]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.756885]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.756885]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.756885]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.756885]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.756885]  [<41345e51>] ? restore_all+0xf/0xf
[   50.756885]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.756885]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.756885]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.756885]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.756885]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.756885]  [<41345e51>] ? restore_all+0xf/0xf
[   50.756885]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.756885]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.756885]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.756885]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.756885]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.756885]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.756885]  [<4102925e>] init_timer_key+0x17/0x64
[   50.756885]  [<411db4a5>] kobject_release+0x50/0x78
[   50.756885]  [<411db51c>] kobject_put+0x4f/0x55
[   50.756885]  [<410ad5bc>] cdev_del+0x23/0x26
[   50.756885]  [<41239fb5>] tty_unregister_device+0x33/0x37
[   50.756885]  [<41247439>] uart_remove_one_port+0xa1/0xee
[   50.756885]  [<41249025>] serial8250_register_8250_port+0xc1/0x235
[   50.756885]  [<41249354>] serial8250_probe+0x108/0x16a
[   50.756885]  [<4103f19a>] ? sched_clock_cpu+0xd8/0xee
[   50.756885]  [<4103f19a>] ? sched_clock_cpu+0xd8/0xee
[   50.756885]  [<4125f64a>] platform_drv_probe+0x29/0x4b
[   50.756885]  [<4125e242>] driver_probe_device+0x8f/0x194
[   50.756885]  [<4125f76c>] ? platform_match+0x52/0x66
[   50.756885]  [<4125e363>] __device_attach+0x1c/0x2c
[   50.756885]  [<4125ccb2>] bus_for_each_drv+0x38/0x6b
[   50.756885]  [<4125e17e>] device_attach+0x66/0x83
[   50.756885]  [<4125e347>] ? driver_probe_device+0x194/0x194
[   50.756885]  [<4125d8af>] bus_probe_device+0x25/0x84
[   50.756885]  [<4125c18b>] device_add+0x3e6/0x57b
[   50.756885]  [<411e35b9>] ? kvasprintf+0x3b/0x44
[   50.756885]  [<411db956>] ? kobject_set_name_vargs+0x3d/0x4a
[   50.756885]  [<4125f4ac>] platform_device_add+0x131/0x195
[   50.756885]  [<4125f97f>] platform_device_register+0x1c/0x1f
[   50.756885]  [<41677bb8>] ? setup_early_serial8250_console+0x376/0x376
[   50.756885]  [<41677bc5>] accent_init+0xd/0xf
[   50.756885]  [<410003df>] do_one_initcall+0x7e/0x10c
[   50.756885]  [<4165b400>] ? do_early_param+0x4f/0x7a
[   50.756885]  [<41035bcd>] ? parse_args+0x15d/0x222
[   50.756885]  [<4165ba89>] kernel_init_freeable+0x116/0x1b5
[   50.756885]  [<4165b42b>] ? do_early_param+0x7a/0x7a
[   50.756885]  [<4133b3b4>] kernel_init+0xb/0xc3
[   50.756885]  [<413499bb>] ret_from_kernel_thread+0x1b/0x30
[   50.756885]  [<4133b3a9>] ? rest_init+0xb5/0xb5
[   50.756885] ---[ end trace b81fc16491f309d2 ]---
[   50.835528] BUG: unable to handle kernel NULL pointer dereference at 000=
00078
[   50.835528] IP: [<4100367c>] print_context_stack+0x72/0x91
[   50.835528] *pde =3D 00000000=20
[   50.835528] Thread overran stack, or stack corrupted
[   50.835528] Oops: 0000 [#1] PREEMPT=20
[   50.835528] Modules linked in:
[   50.835528] CPU: 0 PID: 942880053 Comm:=20
[   50.835528] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   50.835528] task: 4003e020 ti: 4003e000 task.ti: 40040000
[   50.835528] EIP: 0060:[<4100367c>] EFLAGS: 00000093 CPU: 0
[   50.835528] EIP is at print_context_stack+0x72/0x91
[   50.835528] EAX: ffffe000 EBX: 00000078 ECX: 40040004 EDX: 00000078
[   50.835528] ESI: 40040004 EDI: 4134ca18 EBP: 4003e4e0 ESP: 4003e4c0
[   50.835528]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   50.835528] CR0: 8005003b CR2: 00000078 CR3: 016b9000 CR4: 00000690
[   50.835528] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   50.835528] DR6: 00000000 DR7: 00000000
[   50.835528] Stack:
[   50.835528]  47a25d00 ffffe000 00001ffc 00000000 40040004 00000078 00000=
000 4134ca18
[   50.835528]  4003e508 41002c3d 4134ca18 4196e720 00000000 4003e4f8 00000=
000 4196e720
[   50.835528]  4003e504 00000008 4003e520 41009659 00000000 4134ca18 4196e=
720 4196e720
[   50.835528] Call Trace:
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<41009659>] save_stack_trace+0x2a/0x46
[   50.835528]  [<41054b24>] save_trace+0x34/0x8c
[   50.835528]  [<41056cf9>] mark_lock+0x228/0x530
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4103f242>] ? local_clock+0x36/0x4e
[   50.835528]  [<410579f4>] __lock_acquire+0x555/0x16b5
[   50.835528]  [<41005dd7>] ? sched_clock+0x8/0xb
[   50.835528]  [<4105913c>] lock_acquire+0x76/0x91
[   50.835528]  [<411e8d73>] ? debug_object_assert_init+0x3f/0xa6
[   50.835528]  [<413451ee>] _raw_spin_lock_irqsave+0x55/0x85
[   50.835528]  [<411e8d73>] ? debug_object_assert_init+0x3f/0xa6
[   50.835528]  [<411e8d73>] debug_object_assert_init+0x3f/0xa6
[   50.835528]  [<413453c7>] ? _raw_spin_unlock_irqrestore+0x39/0x62
[   50.835528]  [<410298f4>] del_timer+0x12/0x50
[   50.835528]  [<4102996b>] timer_fixup_init+0x10/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  [<411e89c6>] debug_object_init+0x13/0x15
[   50.835528]  [<41029977>] timer_fixup_init+0x1c/0x29
[   50.835528]  [<4102995b>] ? timer_fixup_free+0x29/0x29
[   50.835528]  [<411e8352>] debug_object_fixup+0x10/0x1d
[   50.835528]  [<411e877f>] __debug_object_init+0x29a/0x2bb
[   50.835528]  <IRQ>=20
[   50.835528]  <IRQ> BUG: unable to handle kernel paging request at c08500=
17
[   50.835528] IP: [<4100367c>] print_context_stack+0x72/0x91
[   50.835528] *pde =3D 00000000=20
[   50.835528] Thread overran stack, or stack corrupted
[   50.835528] Oops: 0000 [#2] PREEMPT=20
[   50.835528] Modules linked in:
[   50.835528] CPU: 0 PID: 1095648740 Comm:  Tainted: G        W    3.11.0-=
rc6-next-20130822-07070-g245f086 #1
[   50.835528] BUG: unable to handle kernel NULL pointer dereference at 000=
0054a
[   50.835528] IP: [<411e71b9>] do_raw_spin_trylock+0x4/0x36
[   50.835528] *pde =3D 00000000=20
[   50.835528] Thread overran stack, or stack corrupted
[   50.835528] Oops: 0000 [#3] PREEMPT=20
[   50.835528] Modules linked in:
[   50.835528] CPU: 0 PID: 1095648740 Comm:  Tainted: G        W    3.11.0-=
rc6-next-20130822-07070-g245f086 #1
[   50.835528] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   50.835528] task: 4003e020 ti: 4003c000 task.ti: 4104c5e5
[   50.835528] EIP: 0060:[<411e71b9>] EFLAGS: 00000006 CPU: 0
[   50.835528] EIP is at do_raw_spin_trylock+0x4/0x36
[   50.835528] EAX: 0000054a EBX: 0000054a ECX: 00000000 EDX: 00000000
[   50.835528] ESI: 00000002 EDI: 0000055a EBP: 4003dca8 ESP: 4003dca4
[   50.835528]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   50.835528] CR0: 8005003b CR2: 0000054a CR3: 016b9000 CR4: 00000690
[   50.835528] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   50.835528] DR6: 00000000 DR7: 00000000
[   50.835528] Stack:
[   50.835528]  0000054a 4003dccc 413451f5 00000000 00000002 00000000 4102b=
7fd 4003e020
[   50.835528]  00000000 0000000b 4003dcec 4102b7fd 00000000 4003dcf4 00000=
000 00000000
[   50.835528]  00000000 4003de84 4003dd78 4133d500 0000000b 00000000 00030=
001 00000000
[   50.835528] Call Trace:
[   50.835528]  [<413451f5>] _raw_spin_lock_irqsave+0x5c/0x85
[   50.835528]  [<4102b7fd>] ? force_sig_info+0x20/0xa0
[   50.835528]  [<4102b7fd>] force_sig_info+0x20/0xa0
[   50.835528]  [<4133d500>] force_sig_info_fault+0x38/0x3e
[   50.835528]  [<4133d566>] ? is_prefetch.isra.20+0x60/0x158
[   50.835528]  [<41035112>] ? search_exception_tables+0x17/0x25
[   50.835528]  [<4101aea3>] ? fixup_exception+0xe/0x44
[   50.835528]  [<4133d6cc>] no_context+0x6e/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4134a24e>] ? iret_exc+0x20e/0x95e
[   50.835528]  [<4103511d>] ? search_exception_tables+0x22/0x25
[   50.835528]  [<4133d6db>] no_context+0x7d/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<41061764>] ? __sprint_symbol+0x83/0xb0
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<411e046c>] ? vsnprintf+0x74/0x2a6
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<411e0a64>] ? sprintf+0x1a/0x1c
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<41248875>] ? serial8250_console_putchar+0x1c/0x20
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  <IRQ>=20
[   50.835528] BUG: unable to handle kernel NULL pointer dereference at 000=
00001
[   50.835528] IP: [<4100367c>] print_context_stack+0x72/0x91
[   50.835528] *pde =3D 00000000=20
[   50.835528] Thread overran stack, or stack corrupted
[   50.835528] Oops: 0000 [#4] PREEMPT=20
[   50.835528] Modules linked in:
[   50.835528] CPU: 0 PID: 1095648740 Comm:  Tainted: G        W    3.11.0-=
rc6-next-20130822-07070-g245f086 #1
[   50.835528] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   50.835528] task: 4003e020 ti: 4003c000 task.ti: 4104c5e5
[   50.835528] EIP: 0060:[<4100367c>] EFLAGS: 00000097 CPU: 0
[   50.835528] EIP is at print_context_stack+0x72/0x91
[   50.835528] EAX: ffffe000 EBX: 00000001 ECX: 4df4f3f9 EDX: 00000001
[   50.835528] ESI: 4df4f3f9 EDI: 4134c144 EBP: 4003da9c ESP: 4003da7c
[   50.835528]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   50.835528] CR0: 8005003b CR2: 00000001 CR3: 016b9000 CR4: 00000690
[   50.835528] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   50.835528] DR6: 00000000 DR7: 00000000
[   50.835528] Stack:
[   50.835528]  00000000 ffffe000 00001ffc 00000000 4df4f3f9 00000001 00000=
000 4134c144
[   50.835528]  4003dac4 41002c3d 4134c144 41443b85 00000000 4003dab4 00000=
000 41443b85
[   50.835528]  00000000 4003dd07 4003dae8 410037a5 00000000 4134c144 41443=
b85 4003dc68
[   50.835528] Call Trace:
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<411e71b9>] ? do_raw_spin_trylock+0x4/0x36
[   50.835528]  [<413451f5>] _raw_spin_lock_irqsave+0x5c/0x85
[   50.835528]  [<4102b7fd>] ? force_sig_info+0x20/0xa0
[   50.835528]  [<4102b7fd>] force_sig_info+0x20/0xa0
[   50.835528]  [<4133d500>] force_sig_info_fault+0x38/0x3e
[   50.835528]  [<4133d566>] ? is_prefetch.isra.20+0x60/0x158
[   50.835528]  [<41035112>] ? search_exception_tables+0x17/0x25
[   50.835528]  [<4101aea3>] ? fixup_exception+0xe/0x44
[   50.835528]  [<4133d6cc>] no_context+0x6e/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4134a24e>] ? iret_exc+0x20e/0x95e
[   50.835528]  [<4103511d>] ? search_exception_tables+0x22/0x25
[   50.835528]  [<4133d6db>] no_context+0x7d/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<41061764>] ? __sprint_symbol+0x83/0xb0
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<411e046c>] ? vsnprintf+0x74/0x2a6
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<411e0a64>] ? sprintf+0x1a/0x1c
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<41248875>] ? serial8250_console_putchar+0x1c/0x20
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  <IRQ>=20
[   50.835528] BUG: unable to handle kernel NULL pointer dereference at 000=
00001
[   50.835528] IP: [<4100367c>] print_context_stack+0x72/0x91
[   50.835528] *pde =3D 00000000=20
[   50.835528] Thread overran stack, or stack corrupted
[   50.835528] Oops: 0000 [#5] PREEMPT=20
[   50.835528] Modules linked in:
[   50.835528] CPU: 0 PID: 1095648740 Comm:  Tainted: G        W    3.11.0-=
rc6-next-20130822-07070-g245f086 #1
[   50.835528] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   50.835528] task: 4003e020 ti: 4003c000 task.ti: 4104c5e5
[   50.835528] EIP: 0060:[<4100367c>] EFLAGS: 00000097 CPU: 0
[   50.835528] EIP is at print_context_stack+0x72/0x91
[   50.835528] EAX: ffffe000 EBX: 00000001 ECX: 4df4f3f9 EDX: 00000001
[   50.835528] ESI: 4df4f3f9 EDI: 4134c144 EBP: 4003d874 ESP: 4003d854
[   50.835528]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   50.835528] CR0: 8005003b CR2: 00000001 CR3: 016b9000 CR4: 00000690
[   50.835528] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   50.835528] DR6: 00000000 DR7: 00000000
[   50.835528] Stack:
[   50.835528]  00000000 ffffe000 00001ffc 00000000 4df4f3f9 00000001 00000=
000 4134c144
[   50.835528]  4003d89c 41002c3d 4134c144 41443b85 00000000 4003d88c 00000=
000 41443b85
[   50.835528]  00000000 4003dadf 4003d8c0 410037a5 00000000 4134c144 41443=
b85 4003da40
[   50.835528] Call Trace:
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<411e71b9>] ? do_raw_spin_trylock+0x4/0x36
[   50.835528]  [<413451f5>] _raw_spin_lock_irqsave+0x5c/0x85
[   50.835528]  [<4102b7fd>] ? force_sig_info+0x20/0xa0
[   50.835528]  [<4102b7fd>] force_sig_info+0x20/0xa0
[   50.835528]  [<4133d500>] force_sig_info_fault+0x38/0x3e
[   50.835528]  [<4133d566>] ? is_prefetch.isra.20+0x60/0x158
[   50.835528]  [<41035112>] ? search_exception_tables+0x17/0x25
[   50.835528]  [<4101aea3>] ? fixup_exception+0xe/0x44
[   50.835528]  [<4133d6cc>] no_context+0x6e/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4134a24e>] ? iret_exc+0x20e/0x95e
[   50.835528]  [<4103511d>] ? search_exception_tables+0x22/0x25
[   50.835528]  [<4133d6db>] no_context+0x7d/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<41061764>] ? __sprint_symbol+0x83/0xb0
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<411e046c>] ? vsnprintf+0x74/0x2a6
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<411e0a64>] ? sprintf+0x1a/0x1c
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<41248875>] ? serial8250_console_putchar+0x1c/0x20
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  <IRQ>=20
[   50.835528] BUG: unable to handle kernel NULL pointer dereference at 000=
00001
[   50.835528] IP: [<4100367c>] print_context_stack+0x72/0x91
[   50.835528] *pde =3D 00000000=20
[   50.835528] Thread overran stack, or stack corrupted
[   50.835528] Oops: 0000 [#6] PREEMPT=20
[   50.835528] Modules linked in:
[   50.835528] CPU: 0 PID: 1095648740 Comm:  Tainted: G        W    3.11.0-=
rc6-next-20130822-07070-g245f086 #1
[   50.835528] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   50.835528] task: 4003e020 ti: 4003c000 task.ti: 4104c5e5
[   50.835528] EIP: 0060:[<4100367c>] EFLAGS: 00000097 CPU: 0
[   50.835528] EIP is at print_context_stack+0x72/0x91
[   50.835528] EAX: ffffe000 EBX: 00000001 ECX: 4df4f3f9 EDX: 00000001
[   50.835528] ESI: 4df4f3f9 EDI: 4134c144 EBP: 4003d64c ESP: 4003d62c
[   50.835528]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   50.835528] CR0: 8005003b CR2: 00000001 CR3: 016b9000 CR4: 00000690
[   50.835528] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   50.835528] DR6: 00000000 DR7: 00000000
[   50.835528] Stack:
[   50.835528]  00000000 ffffe000 00001ffc 00000000 4df4f3f9 00000001 00000=
000 4134c144
[   50.835528]  4003d674 41002c3d 4134c144 41443b85 00000000 4003d664 00000=
000 41443b85
[   50.835528]  00000000 4003d8b7 4003d698 410037a5 00000000 4134c144 41443=
b85 4003d818
[   50.835528] Call Trace:
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<411e71b9>] ? do_raw_spin_trylock+0x4/0x36
[   50.835528]  [<413451f5>] _raw_spin_lock_irqsave+0x5c/0x85
[   50.835528]  [<4102b7fd>] ? force_sig_info+0x20/0xa0
[   50.835528]  [<4102b7fd>] force_sig_info+0x20/0xa0
[   50.835528]  [<4133d500>] force_sig_info_fault+0x38/0x3e
[   50.835528]  [<4133d566>] ? is_prefetch.isra.20+0x60/0x158
[   50.835528]  [<41035112>] ? search_exception_tables+0x17/0x25
[   50.835528]  [<4101aea3>] ? fixup_exception+0xe/0x44
[   50.835528]  [<4133d6cc>] no_context+0x6e/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4134a24e>] ? iret_exc+0x20e/0x95e
[   50.835528]  [<4103511d>] ? search_exception_tables+0x22/0x25
[   50.835528]  [<4133d6db>] no_context+0x7d/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<41061764>] ? __sprint_symbol+0x83/0xb0
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<411e046c>] ? vsnprintf+0x74/0x2a6
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<411e0a64>] ? sprintf+0x1a/0x1c
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<41248875>] ? serial8250_console_putchar+0x1c/0x20
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  <IRQ>=20
[   50.835528] BUG: unable to handle kernel NULL pointer dereference at 000=
00001
[   50.835528] IP: [<4100367c>] print_context_stack+0x72/0x91
[   50.835528] *pde =3D 00000000=20
[   50.835528] Thread overran stack, or stack corrupted
[   50.835528] Oops: 0000 [#7] PREEMPT=20
[   50.835528] Modules linked in:
[   50.835528] CPU: 0 PID: 1095648740 Comm:  Tainted: G        W    3.11.0-=
rc6-next-20130822-07070-g245f086 #1
[   50.835528] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   50.835528] task: 4003e020 ti: 4003c000 task.ti: 4104c5e5
[   50.835528] EIP: 0060:[<4100367c>] EFLAGS: 00000097 CPU: 0
[   50.835528] EIP is at print_context_stack+0x72/0x91
[   50.835528] EAX: ffffe000 EBX: 00000001 ECX: 4df4f3f9 EDX: 00000001
[   50.835528] ESI: 4df4f3f9 EDI: 4134c144 EBP: 4003d424 ESP: 4003d404
[   50.835528]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   50.835528] CR0: 8005003b CR2: 00000001 CR3: 016b9000 CR4: 00000690
[   50.835528] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   50.835528] DR6: 00000000 DR7: 00000000
[   50.835528] Stack:
[   50.835528]  00000000 ffffe000 00001ffc 00000000 4df4f3f9 00000001 00000=
000 4134c144
[   50.835528]  4003d44c 41002c3d 4134c144 41443b85 00000000 4003d43c 00000=
000 41443b85
[   50.835528]  00000000 4003d68f 4003d470 410037a5 00000000 4134c144 41443=
b85 4003d5f0
[   50.835528] Call Trace:
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<411e71b9>] ? do_raw_spin_trylock+0x4/0x36
[   50.835528]  [<413451f5>] _raw_spin_lock_irqsave+0x5c/0x85
[   50.835528]  [<4102b7fd>] ? force_sig_info+0x20/0xa0
[   50.835528]  [<4102b7fd>] force_sig_info+0x20/0xa0
[   50.835528]  [<4133d500>] force_sig_info_fault+0x38/0x3e
[   50.835528]  [<4133d566>] ? is_prefetch.isra.20+0x60/0x158
[   50.835528]  [<41035112>] ? search_exception_tables+0x17/0x25
[   50.835528]  [<4101aea3>] ? fixup_exception+0xe/0x44
[   50.835528]  [<4133d6cc>] no_context+0x6e/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4134a24e>] ? iret_exc+0x20e/0x95e
[   50.835528]  [<4103511d>] ? search_exception_tables+0x22/0x25
[   50.835528]  [<4133d6db>] no_context+0x7d/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<41061764>] ? __sprint_symbol+0x83/0xb0
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<411e046c>] ? vsnprintf+0x74/0x2a6
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<411e0a64>] ? sprintf+0x1a/0x1c
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<41248875>] ? serial8250_console_putchar+0x1c/0x20
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  <IRQ>=20
[   50.835528] BUG: unable to handle kernel NULL pointer dereference at 000=
00001
[   50.835528] IP: [<4100367c>] print_context_stack+0x72/0x91
[   50.835528] *pde =3D 00000000=20
[   50.835528] Thread overran stack, or stack corrupted
[   50.835528] Oops: 0000 [#8] PREEMPT=20
[   50.835528] Modules linked in:
[   50.835528] CPU: 0 PID: 1095648740 Comm:  Tainted: G        W    3.11.0-=
rc6-next-20130822-07070-g245f086 #1
[   50.835528] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   50.835528] task: 4003e020 ti: 4003c000 task.ti: 4104c5e5
[   50.835528] EIP: 0060:[<4100367c>] EFLAGS: 00000097 CPU: 0
[   50.835528] EIP is at print_context_stack+0x72/0x91
[   50.835528] EAX: ffffe000 EBX: 00000001 ECX: 4df4f3f9 EDX: 00000001
[   50.835528] ESI: 4df4f3f9 EDI: 4134c144 EBP: 4003d1fc ESP: 4003d1dc
[   50.835528]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   50.835528] CR0: 8005003b CR2: 00000001 CR3: 016b9000 CR4: 00000690
[   50.835528] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   50.835528] DR6: 00000000 DR7: 00000000
[   50.835528] Stack:
[   50.835528]  00000000 ffffe000 00001ffc 00000000 4df4f3f9 00000001 00000=
000 4134c144
[   50.835528]  4003d224 41002c3d 4134c144 41443b85 00000000 4003d214 00000=
000 41443b85
[   50.835528]  00000000 4003d467 4003d248 410037a5 00000000 4134c144 41443=
b85 4003d3c8
[   50.835528] Call Trace:
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<411e71b9>] ? do_raw_spin_trylock+0x4/0x36
[   50.835528]  [<413451f5>] _raw_spin_lock_irqsave+0x5c/0x85
[   50.835528]  [<4102b7fd>] ? force_sig_info+0x20/0xa0
[   50.835528]  [<4102b7fd>] force_sig_info+0x20/0xa0
[   50.835528]  [<4133d500>] force_sig_info_fault+0x38/0x3e
[   50.835528]  [<4133d566>] ? is_prefetch.isra.20+0x60/0x158
[   50.835528]  [<41035112>] ? search_exception_tables+0x17/0x25
[   50.835528]  [<4101aea3>] ? fixup_exception+0xe/0x44
[   50.835528]  [<4133d6cc>] no_context+0x6e/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4134a24e>] ? iret_exc+0x20e/0x95e
[   50.835528]  [<4103511d>] ? search_exception_tables+0x22/0x25
[   50.835528]  [<4133d6db>] no_context+0x7d/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<41061764>] ? __sprint_symbol+0x83/0xb0
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<411e046c>] ? vsnprintf+0x74/0x2a6
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<411e0a64>] ? sprintf+0x1a/0x1c
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<41248875>] ? serial8250_console_putchar+0x1c/0x20
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  <IRQ>=20
[   50.835528] BUG: unable to handle kernel NULL pointer dereference at 000=
00001
[   50.835528] IP: [<4100367c>] print_context_stack+0x72/0x91
[   50.835528] *pde =3D 00000000=20
[   50.835528] Thread overran stack, or stack corrupted
[   50.835528] Oops: 0000 [#9] PREEMPT=20
[   50.835528] Modules linked in:
[   50.835528] CPU: 0 PID: 1095648740 Comm:  Tainted: G        W    3.11.0-=
rc6-next-20130822-07070-g245f086 #1
[   50.835528] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   50.835528] task: 4003e020 ti: 4003c000 task.ti: 4104c5e5
[   50.835528] EIP: 0060:[<4100367c>] EFLAGS: 00000097 CPU: 0
[   50.835528] EIP is at print_context_stack+0x72/0x91
[   50.835528] EAX: ffffe000 EBX: 00000001 ECX: 4df4f3f9 EDX: 00000001
[   50.835528] ESI: 4df4f3f9 EDI: 4134c144 EBP: 4003cfd4 ESP: 4003cfb4
[   50.835528]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   50.835528] CR0: 8005003b CR2: 00000001 CR3: 016b9000 CR4: 00000690
[   50.835528] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   50.835528] DR6: 00000000 DR7: 00000000
[   50.835528] Stack:
[   50.835528]  00000000 ffffe000 00001ffc 00000000 4df4f3f9 00000001 00000=
000 4134c144
[   50.835528]  4003cffc 41002c3d 4134c144 41443b85 00000000 4003cfec 00000=
000 41443b85
[   50.835528]  00000000 4003d23f 4003d020 410037a5 00000000 4134c144 41443=
b85 4003d1a0
[   50.835528] Call Trace:
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<411e71b9>] ? do_raw_spin_trylock+0x4/0x36
[   50.835528]  [<413451f5>] _raw_spin_lock_irqsave+0x5c/0x85
[   50.835528]  [<4102b7fd>] ? force_sig_info+0x20/0xa0
[   50.835528]  [<4102b7fd>] force_sig_info+0x20/0xa0
[   50.835528]  [<4133d500>] force_sig_info_fault+0x38/0x3e
[   50.835528]  [<4133d566>] ? is_prefetch.isra.20+0x60/0x158
[   50.835528]  [<41035112>] ? search_exception_tables+0x17/0x25
[   50.835528]  [<4101aea3>] ? fixup_exception+0xe/0x44
[   50.835528]  [<4133d6cc>] no_context+0x6e/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4134a24e>] ? iret_exc+0x20e/0x95e
[   50.835528]  [<4103511d>] ? search_exception_tables+0x22/0x25
[   50.835528]  [<4133d6db>] no_context+0x7d/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<41061764>] ? __sprint_symbol+0x83/0xb0
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<411e046c>] ? vsnprintf+0x74/0x2a6
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<411e0a64>] ? sprintf+0x1a/0x1c
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<41248875>] ? serial8250_console_putchar+0x1c/0x20
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  <IRQ>=20
[   50.835528] BUG: unable to handle kernel NULL pointer dereference at 000=
00001
[   50.835528] IP: [<4100367c>] print_context_stack+0x72/0x91
[   50.835528] *pde =3D 00000000=20
[   50.835528] Thread overran stack, or stack corrupted
[   50.835528] Oops: 0000 [#10] PREEMPT=20
[   50.835528] Modules linked in:
[   50.835528] CPU: 0 PID: 1095648740 Comm:  Tainted: G        W    3.11.0-=
rc6-next-20130822-07070-g245f086 #1
[   50.835528] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   50.835528] task: 4003e020 ti: 4003c000 task.ti: 4104c5e5
[   50.835528] EIP: 0060:[<4100367c>] EFLAGS: 00000097 CPU: 0
[   50.835528] EIP is at print_context_stack+0x72/0x91
[   50.835528] EAX: ffffe000 EBX: 00000001 ECX: 4df4f3f9 EDX: 00000001
[   50.835528] ESI: 4df4f3f9 EDI: 4134c144 EBP: 4003cdac ESP: 4003cd8c
[   50.835528]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   50.835528] CR0: 8005003b CR2: 00000001 CR3: 016b9000 CR4: 00000690
[   50.835528] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   50.835528] DR6: 00000000 DR7: 00000000
[   50.835528] Stack:
[   50.835528]  00000000 ffffe000 00001ffc 00000000 4df4f3f9 00000001 00000=
000 4134c144
[   50.835528]  4003cdd4 41002c3d 4134c144 41443b85 00000000 4003cdc4 00000=
000 41443b85
[   50.835528]  00000000 4003d017 4003cdf8 410037a5 00000000 4134c144 41443=
b85 4003cf78
[   50.835528] Call Trace:
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<411e71b9>] ? do_raw_spin_trylock+0x4/0x36
[   50.835528]  [<413451f5>] _raw_spin_lock_irqsave+0x5c/0x85
[   50.835528]  [<4102b7fd>] ? force_sig_info+0x20/0xa0
[   50.835528]  [<4102b7fd>] force_sig_info+0x20/0xa0
[   50.835528]  [<4133d500>] force_sig_info_fault+0x38/0x3e
[   50.835528]  [<4133d566>] ? is_prefetch.isra.20+0x60/0x158
[   50.835528]  [<41035112>] ? search_exception_tables+0x17/0x25
[   50.835528]  [<4101aea3>] ? fixup_exception+0xe/0x44
[   50.835528]  [<4133d6cc>] no_context+0x6e/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4134a24e>] ? iret_exc+0x20e/0x95e
[   50.835528]  [<4103511d>] ? search_exception_tables+0x22/0x25
[   50.835528]  [<4133d6db>] no_context+0x7d/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<41061764>] ? __sprint_symbol+0x83/0xb0
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<411e046c>] ? vsnprintf+0x74/0x2a6
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<411e0a64>] ? sprintf+0x1a/0x1c
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<41248875>] ? serial8250_console_putchar+0x1c/0x20
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  <IRQ>=20
[   50.835528] BUG: unable to handle kernel NULL pointer dereference at 000=
00001
[   50.835528] IP: [<4100367c>] print_context_stack+0x72/0x91
[   50.835528] *pde =3D 00000000=20
[   50.835528] Thread overran stack, or stack corrupted
[   50.835528] Oops: 0000 [#11] PREEMPT=20
[   50.835528] Modules linked in:
[   50.835528] CPU: 0 PID: 1095648740 Comm:  Tainted: G        W    3.11.0-=
rc6-next-20130822-07070-g245f086 #1
[   50.835528] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   50.835528] task: 4003e020 ti: 4003c000 task.ti: 4104c5e5
[   50.835528] EIP: 0060:[<4100367c>] EFLAGS: 00000097 CPU: 0
[   50.835528] EIP is at print_context_stack+0x72/0x91
[   50.835528] EAX: ffffe000 EBX: 00000001 ECX: 4df4f3f9 EDX: 00000001
[   50.835528] ESI: 4df4f3f9 EDI: 4134c144 EBP: 4003cb84 ESP: 4003cb64
[   50.835528]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   50.835528] CR0: 8005003b CR2: 00000001 CR3: 016b9000 CR4: 00000690
[   50.835528] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   50.835528] DR6: 00000000 DR7: 00000000
[   50.835528] Stack:
[   50.835528]  00000000 ffffe000 00001ffc 00000000 4df4f3f9 00000001 00000=
000 4134c144
[   50.835528]  4003cbac 41002c3d 4134c144 41443b85 00000000 4003cb9c 00000=
000 41443b85
[   50.835528]  00000000 4003cdef 4003cbd0 410037a5 00000000 4134c144 41443=
b85 4003cd50
[   50.835528] Call Trace:
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<411e71b9>] ? do_raw_spin_trylock+0x4/0x36
[   50.835528]  [<413451f5>] _raw_spin_lock_irqsave+0x5c/0x85
[   50.835528]  [<4102b7fd>] ? force_sig_info+0x20/0xa0
[   50.835528]  [<4102b7fd>] force_sig_info+0x20/0xa0
[   50.835528]  [<4133d500>] force_sig_info_fault+0x38/0x3e
[   50.835528]  [<4133d566>] ? is_prefetch.isra.20+0x60/0x158
[   50.835528]  [<41035112>] ? search_exception_tables+0x17/0x25
[   50.835528]  [<4101aea3>] ? fixup_exception+0xe/0x44
[   50.835528]  [<4133d6cc>] no_context+0x6e/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4134a24e>] ? iret_exc+0x20e/0x95e
[   50.835528]  [<4103511d>] ? search_exception_tables+0x22/0x25
[   50.835528]  [<4133d6db>] no_context+0x7d/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<41061764>] ? __sprint_symbol+0x83/0xb0
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<411e046c>] ? vsnprintf+0x74/0x2a6
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<411e0a64>] ? sprintf+0x1a/0x1c
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<41248875>] ? serial8250_console_putchar+0x1c/0x20
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  <IRQ>=20
[   50.835528] BUG: unable to handle kernel NULL pointer dereference at 000=
00001
[   50.835528] IP: [<4100367c>] print_context_stack+0x72/0x91
[   50.835528] *pde =3D 00000000=20
[   50.835528] Thread overran stack, or stack corrupted
[   50.835528] Oops: 0000 [#12] PREEMPT=20
[   50.835528] Modules linked in:
[   50.835528] CPU: 0 PID: 1095648740 Comm:  Tainted: G        W    3.11.0-=
rc6-next-20130822-07070-g245f086 #1
[   50.835528] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   50.835528] task: 4003e020 ti: 4003c000 task.ti: 4104c5e5
[   50.835528] EIP: 0060:[<4100367c>] EFLAGS: 00000097 CPU: 0
[   50.835528] EIP is at print_context_stack+0x72/0x91
[   50.835528] EAX: ffffe000 EBX: 00000001 ECX: 4df4f3f9 EDX: 00000001
[   50.835528] ESI: 4df4f3f9 EDI: 4134c144 EBP: 4003c95c ESP: 4003c93c
[   50.835528]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   50.835528] CR0: 8005003b CR2: 00000001 CR3: 016b9000 CR4: 00000690
[   50.835528] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   50.835528] DR6: 00000000 DR7: 00000000
[   50.835528] Stack:
[   50.835528]  00000000 ffffe000 00001ffc 00000000 4df4f3f9 00000001 00000=
000 4134c144
[   50.835528]  4003c984 41002c3d 4134c144 41443b85 00000000 4003c974 00000=
000 41443b85
[   50.835528]  00000000 4003cbc7 4003c9a8 410037a5 00000000 4134c144 41443=
b85 4003cb28
[   50.835528] Call Trace:
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<411e71b9>] ? do_raw_spin_trylock+0x4/0x36
[   50.835528]  [<413451f5>] _raw_spin_lock_irqsave+0x5c/0x85
[   50.835528]  [<4102b7fd>] ? force_sig_info+0x20/0xa0
[   50.835528]  [<4102b7fd>] force_sig_info+0x20/0xa0
[   50.835528]  [<4133d500>] force_sig_info_fault+0x38/0x3e
[   50.835528]  [<4133d566>] ? is_prefetch.isra.20+0x60/0x158
[   50.835528]  [<41035112>] ? search_exception_tables+0x17/0x25
[   50.835528]  [<4101aea3>] ? fixup_exception+0xe/0x44
[   50.835528]  [<4133d6cc>] no_context+0x6e/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4134a24e>] ? iret_exc+0x20e/0x95e
[   50.835528]  [<4103511d>] ? search_exception_tables+0x22/0x25
[   50.835528]  [<4133d6db>] no_context+0x7d/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<41061764>] ? __sprint_symbol+0x83/0xb0
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<411e046c>] ? vsnprintf+0x74/0x2a6
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<411e0a64>] ? sprintf+0x1a/0x1c
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<41248875>] ? serial8250_console_putchar+0x1c/0x20
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  <IRQ>=20
[   50.835528] BUG: unable to handle kernel NULL pointer dereference at 000=
00001
[   50.835528] IP: [<4100367c>] print_context_stack+0x72/0x91
[   50.835528] *pde =3D 00000000=20
[   50.835528] Thread overran stack, or stack corrupted
[   50.835528] Oops: 0000 [#13] PREEMPT=20
[   50.835528] Modules linked in:
[   50.835528] CPU: 0 PID: 1095648740 Comm:  Tainted: G        W    3.11.0-=
rc6-next-20130822-07070-g245f086 #1
[   50.835528] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   50.835528] task: 4003e020 ti: 4003c000 task.ti: 4104c5e5
[   50.835528] EIP: 0060:[<4100367c>] EFLAGS: 00000097 CPU: 0
[   50.835528] EIP is at print_context_stack+0x72/0x91
[   50.835528] EAX: ffffe000 EBX: 00000001 ECX: 4df4f3f9 EDX: 00000001
[   50.835528] ESI: 4df4f3f9 EDI: 4134c144 EBP: 4003c734 ESP: 4003c714
[   50.835528]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   50.835528] CR0: 8005003b CR2: 00000001 CR3: 016b9000 CR4: 00000690
[   50.835528] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   50.835528] DR6: 00000000 DR7: 00000000
[   50.835528] Stack:
[   50.835528]  00000000 ffffe000 00001ffc 00000000 4df4f3f9 00000001 00000=
000 4134c144
[   50.835528]  4003c75c 41002c3d 4134c144 41443b85 00000000 4003c74c 00000=
000 41443b85
[   50.835528]  00000000 4003c99f 4003c780 410037a5 00000000 4134c144 41443=
b85 4003c900
[   50.835528] Call Trace:
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<411e71b9>] ? do_raw_spin_trylock+0x4/0x36
[   50.835528]  [<413451f5>] _raw_spin_lock_irqsave+0x5c/0x85
[   50.835528]  [<4102b7fd>] ? force_sig_info+0x20/0xa0
[   50.835528]  [<4102b7fd>] force_sig_info+0x20/0xa0
[   50.835528]  [<4133d500>] force_sig_info_fault+0x38/0x3e
[   50.835528]  [<4133d566>] ? is_prefetch.isra.20+0x60/0x158
[   50.835528]  [<41035112>] ? search_exception_tables+0x17/0x25
[   50.835528]  [<4101aea3>] ? fixup_exception+0xe/0x44
[   50.835528]  [<4133d6cc>] no_context+0x6e/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4134a24e>] ? iret_exc+0x20e/0x95e
[   50.835528]  [<4103511d>] ? search_exception_tables+0x22/0x25
[   50.835528]  [<4133d6db>] no_context+0x7d/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<41061764>] ? __sprint_symbol+0x83/0xb0
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<411e046c>] ? vsnprintf+0x74/0x2a6
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<411e0a64>] ? sprintf+0x1a/0x1c
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<41248875>] ? serial8250_console_putchar+0x1c/0x20
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  <IRQ>=20
[   50.835528] BUG: unable to handle kernel NULL pointer dereference at 000=
00001
[   50.835528] IP: [<4100367c>] print_context_stack+0x72/0x91
[   50.835528] *pde =3D 00000000=20
[   50.835528] Thread overran stack, or stack corrupted
[   50.835528] Oops: 0000 [#14] PREEMPT=20
[   50.835528] Modules linked in:
[   50.835528] CPU: 0 PID: 1095648740 Comm:  Tainted: G        W    3.11.0-=
rc6-next-20130822-07070-g245f086 #1
[   50.835528] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   50.835528] task: 4003e020 ti: 4003c000 task.ti: 4104c5e5
[   50.835528] EIP: 0060:[<4100367c>] EFLAGS: 00000097 CPU: 0
[   50.835528] EIP is at print_context_stack+0x72/0x91
[   50.835528] EAX: ffffe000 EBX: 00000001 ECX: 4df4f3f9 EDX: 00000001
[   50.835528] ESI: 4df4f3f9 EDI: 4134c144 EBP: 4003c50c ESP: 4003c4ec
[   50.835528]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   50.835528] CR0: 8005003b CR2: 00000001 CR3: 016b9000 CR4: 00000690
[   50.835528] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   50.835528] DR6: 00000000 DR7: 00000000
[   50.835528] Stack:
[   50.835528]  00000000 ffffe000 00001ffc 00000000 4df4f3f9 00000001 00000=
000 4134c144
[   50.835528]  4003c534 41002c3d 4134c144 41443b85 00000000 4003c524 00000=
000 41443b85
[   50.835528]  00000000 4003c777 4003c558 410037a5 00000000 4134c144 41443=
b85 4003c6d8
[   50.835528] Call Trace:
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<411e71b9>] ? do_raw_spin_trylock+0x4/0x36
[   50.835528]  [<413451f5>] _raw_spin_lock_irqsave+0x5c/0x85
[   50.835528]  [<4102b7fd>] ? force_sig_info+0x20/0xa0
[   50.835528]  [<4102b7fd>] force_sig_info+0x20/0xa0
[   50.835528]  [<4133d500>] force_sig_info_fault+0x38/0x3e
[   50.835528]  [<4133d566>] ? is_prefetch.isra.20+0x60/0x158
[   50.835528]  [<41035112>] ? search_exception_tables+0x17/0x25
[   50.835528]  [<4101aea3>] ? fixup_exception+0xe/0x44
[   50.835528]  [<4133d6cc>] no_context+0x6e/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4134a24e>] ? iret_exc+0x20e/0x95e
[   50.835528]  [<4103511d>] ? search_exception_tables+0x22/0x25
[   50.835528]  [<4133d6db>] no_context+0x7d/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<41061764>] ? __sprint_symbol+0x83/0xb0
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<411e046c>] ? vsnprintf+0x74/0x2a6
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<411e0a64>] ? sprintf+0x1a/0x1c
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<41248875>] ? serial8250_console_putchar+0x1c/0x20
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  <IRQ>=20
[   50.835528] BUG: unable to handle kernel paging request at c003c0c2
[   50.835528] IP: [<4100367c>] print_context_stack+0x72/0x91
[   50.835528] *pde =3D 00000000=20
[   50.835528] Thread overran stack, or stack corrupted
[   50.835528] Oops: 0000 [#15] PREEMPT=20
[   50.835528] Modules linked in:
[   50.835528] CPU: 0 PID: 1095648740 Comm:  Tainted: G        W    3.11.0-=
rc6-next-20130822-07070-g245f086 #1
[   50.835528] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   50.835528] task: 4003e020 ti: 4003c000 task.ti: 4104c5e5
[   50.835528] EIP: 0060:[<4100367c>] EFLAGS: 00000097 CPU: 0
[   50.835528] EIP is at print_context_stack+0x72/0x91
[   50.835528] EAX: ffffe000 EBX: c003c0c2 ECX: 4df4f3f9 EDX: c003c0c2
[   50.835528] ESI: 4df4f3f9 EDI: 4134c144 EBP: 4003c2e4 ESP: 4003c2c4
[   50.835528]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   50.835528] CR0: 8005003b CR2: c003c0c2 CR3: 016b9000 CR4: 00000690
[   50.835528] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   50.835528] DR6: 00000000 DR7: 00000000
[   50.835528] Stack:
[   50.835528]  00000000 ffffe000 c003dffc c003c000 4df4f3f9 c003c0c2 c003c=
000 4134c144
[   50.835528]  4003c30c 41002c3d 4134c144 41443b85 00000000 4003c2fc 00000=
000 41443b85
[   50.835528]  00000000 4003c54f 4003c330 410037a5 00000000 4134c144 41443=
b85 4003c4b0
[   50.835528] Call Trace:
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<4105494c>] ? trace_hardirqs_off+0xb/0xd
[   50.835528]  [<413453c0>] ? _raw_spin_unlock_irqrestore+0x32/0x62
[   50.835528]  [<4104c616>] ? console_unlock+0x347/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4100367c>] ? print_context_stack+0x72/0x91
[   50.835528]  [<41002c3d>] dump_trace+0x91/0xc4
[   50.835528]  [<410037a5>] show_trace_log_lvl+0x42/0x49
[   50.835528]  [<41002d08>] show_stack_log_lvl+0x98/0xa0
[   50.835528]  [<41002d94>] show_regs+0x84/0x1ab
[   50.835528]  [<413483f1>] ? notify_die+0x2d/0x2f
[   50.835528]  [<41346916>] __die+0x88/0xf9
[   50.835528]  [<4133d7a4>] no_context+0x146/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<411e71b9>] ? do_raw_spin_trylock+0x4/0x36
[   50.835528]  [<413451f5>] _raw_spin_lock_irqsave+0x5c/0x85
[   50.835528]  [<4102b7fd>] ? force_sig_info+0x20/0xa0
[   50.835528]  [<4102b7fd>] force_sig_info+0x20/0xa0
[   50.835528]  [<4133d500>] force_sig_info_fault+0x38/0x3e
[   50.835528]  [<4133d566>] ? is_prefetch.isra.20+0x60/0x158
[   50.835528]  [<41035112>] ? search_exception_tables+0x17/0x25
[   50.835528]  [<4101aea3>] ? fixup_exception+0xe/0x44
[   50.835528]  [<4133d6cc>] no_context+0x6e/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<4134a24e>] ? iret_exc+0x20e/0x95e
[   50.835528]  [<4103511d>] ? search_exception_tables+0x22/0x25
[   50.835528]  [<4133d6db>] no_context+0x7d/0x172
[   50.835528]  [<4133d908>] __bad_area_nosemaphore+0x138/0x140
[   50.835528]  [<41061764>] ? __sprint_symbol+0x83/0xb0
[   50.835528]  [<4133d922>] bad_area_nosemaphore+0x12/0x14
[   50.835528]  [<41348237>] __do_page_fault+0x476/0x4e3
[   50.835528]  [<411e046c>] ? vsnprintf+0x74/0x2a6
[   50.835528]  [<4104c643>] ? console_unlock+0x374/0x374
[   50.835528]  [<4104c5ef>] ? console_unlock+0x320/0x374
[   50.835528]  [<411e0a64>] ? sprintf+0x1a/0x1c
[   50.835528]  [<412486fa>] ? wait_for_xmitr+0x19/0x77
[   50.835528]  [<41248875>] ? serial8250_console_putchar+0x1c/0x20
[   50.835528]  [<413482a4>] ? __do_page_fault+0x4e3/0x4e3
[   50.835528]  [<413482ac>] do_page_fault+0x8/0xa
[   50.835528]  [<413461ad>] error_code+0x5d/0x70
[   50.835528]  <IRQ>=20
BUG: kernel boot hang
Elapsed time: 675
qemu-system-x86_64 -kernel /tmp//kernel/i386-randconfig-j5-08241525/245f086=
99d5320f021070ed8698ac89ebf2f0670/vmlinuz-3.11.0-rc6-next-20130822-07070-g2=
45f086-6043 -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_timeout=3D10=
0 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_p=
rintk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,1=
15200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests=
/run-queue/kvm/i386-randconfig-j5-08241525/next:master/.vmlinuz-245f08699d5=
320f021070ed8698ac89ebf2f0670-20130824154929-4-ant branch=3Dnext/master noa=
pic nolapic nohz=3Doff BOOT_IMAGE=3D/kernel/i386-randconfig-j5-08241525/245=
f08699d5320f021070ed8698ac89ebf2f0670/vmlinuz-3.11.0-rc6-next-20130822-0707=
0-g245f086'  -initrd /kernel-tests/initrd/quantal-core-i386.cgz -m 256M -sm=
p 2 -net nic,vlan=3D0,macaddr=3D00:00:00:00:00:00,model=3Dvirtio -net user,=
vlan=3D0,hostfwd=3Dtcp::10139-:22 -net nic,vlan=3D1,model=3De1000 -net user=
,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -drive file=3D/fs/=
sdc1/disk0-ant-6043,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdc1/disk1-a=
nt-6043,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdc1/disk2-ant-6043,medi=
a=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdc1/disk3-ant-6043,media=3Ddisk,if=
=3Dvirtio -drive file=3D/fs/sdc1/disk4-ant-6043,media=3Ddisk,if=3Dvirtio -d=
rive file=3D/fs/sdc1/disk5-ant-6043,media=3Ddisk,if=3Dvirtio -pidfile /dev/=
shm/kboot/pid-ant-lkp-6043 -serial file:/dev/shm/kboot/serial-ant-lkp-6043 =
-daemonize -display none -monitor null=20

--45Z9DzgjV8m4Oswq
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-245f08699d5320f021070ed8698ac89ebf2f0670-i386-randconfig-j5-08241525-BUG:-unable-to-handle-kernel-NULL-pointer-dereference-at-81554.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDVlOGQxYWNkMDU2ODc3MjBjYmIwYjA4OTc1ZWFjYjc1ODhmZGZjNDIK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgMjQ1ZjA4Ni4uLiBBZGQgbGludXgtbmV4dCBz
cGVjaWZpYyBmaWxlcyBmb3IgMjAxMzA4MjIKSEVBRCBpcyBub3cgYXQgNWU4ZDFhYy4uLiBN
ZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdhaW8vbWFzdGVyJwpscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1L25leHQ6
bWFzdGVyOjVlOGQxYWNkMDU2ODc3MjBjYmIwYjA4OTc1ZWFjYjc1ODhmZGZjNDI6YmlzZWN0
LW1tb3RtCgoyMDEzLTA4LTI1LTA5OjUzOjA3IDVlOGQxYWNkMDU2ODc3MjBjYmIwYjA4OTc1
ZWFjYjc1ODhmZGZjNDIgY29tcGlsaW5nCjIyNiByZWFsICAxMjU5IHVzZXIgIDEyNyBzeXMg
IDYxMy4xOSUgY3B1IAlpMzg2LXJhbmRjb25maWctajUtMDgyNDE1MjUKCjIwMTMtMDgtMjUt
MDk6NTc6MjQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLXJjNi0wNjY3Ny1nNWU4ZDFh
Yy4uLi4uLi4uLi4uLi4uLi4uLi4uIFRFU1QgRkFJTFVSRQpbICAgIDMuMTMzNjEyXSBXQVJO
SU5HOiBDUFU6IDAgUElEOiAxIGF0IC9jL3dmZy9saW51eC1tbW90bS9saWIvbGlzdF9kZWJ1
Zy5jOjMzIF9fbGlzdF9hZGQrMHg2Yy8weGFlKCkKWyAgICAzLjEzNDU5MV0gbGlzdF9hZGQg
Y29ycnVwdGlvbi4gcHJldi0+bmV4dCBzaG91bGQgYmUgbmV4dCAoNDE2YzIwZTgpLCBidXQg
d2FzICAgKG51bGwpLiAocHJldj00N2E5MmQwMCkuClsgICAgMy4xMzQ1OTFdIE1vZHVsZXMg
bGlua2VkIGluOgpbICAgIDMuMTM0NTkxXSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIg
Tm90IHRhaW50ZWQgMy4xMS4wLXJjNi0wNjY3Ny1nNWU4ZDFhYyAjMTM0ClsgICAgMy4xMzQ1
OTFdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEK
WyAgICAzLjEzNDU5MV0gIDQwMDQxYjBjIDQwMDQxYjBjIDQwMDQxYWNjIDQxMzQwYzMyIDQw
MDQxYWZjIDQxMDIyYmE5IDQxNDcxZmUwIDQwMDQxYjI4ClsgICAgMy4xMzQ1OTFdICAwMDAw
MDAwMSA0MTQ3MWZiYyAwMDAwMDAyMSA0MTFlODFlZSA0MTFlODFlZSA0N2E5MmQwMCA0MTZj
MjBlOCA0NzhmNTdjOApbICAgIDMuMTM0NTkxXSAgNDAwNDFiMTQgNDEwMjJiZWUgMDAwMDAw
MDkgNDAwNDFiMGMgNDE0NzFmZTAgNDAwNDFiMjggNDAwNDFiNDAgNDExZTgxZWUKWyAgICAz
LjEzNDU5MV0gQ2FsbCBUcmFjZToKWyAgICAzLjEzNDU5MV0gIFs8NDEzNDBjMzI+XSBkdW1w
X3N0YWNrKzB4MTYvMHgxOApbICAgIDMuMTM0NTkxXSAgWzw0MTAyMmJhOT5dIHdhcm5fc2xv
d3BhdGhfY29tbW9uKzB4NzAvMHg4NwpbICAgIDMuMTM0NTkxXSAgWzw0MTFlODFlZT5dID8g
X19saXN0X2FkZCsweDZjLzB4YWUKWyAgICAzLjEzNDU5MV0gIFs8NDExZTgxZWU+XSA/IF9f
bGlzdF9hZGQrMHg2Yy8weGFlClsgICAgMy4xMzQ1OTFdICBbPDQxMDIyYmVlPl0gd2Fybl9z
bG93cGF0aF9mbXQrMHgyZS8weDMwClsgICAgMy4xMzQ1OTFdICBbPDQxMWU4MWVlPl0gX19s
aXN0X2FkZCsweDZjLzB4YWUKWyAgICAzLjEzNDU5MV0gIFs8NDEwMjk2Yjk+XSBfX2ludGVy
bmFsX2FkZF90aW1lcisweDhhLzB4OGUKWyAgICAzLjEzNDU5MV0gIFs8NDEwMjk2Y2I+XSBp
bnRlcm5hbF9hZGRfdGltZXIrMHhlLzB4MjYKWyAgICAzLjEzNDU5MV0gIFs8NDEwMjllNDk+
XSBtb2RfdGltZXIrMHhkYy8weGY4ClsgICAgMy4xMzQ1OTFdICBbPDQxMDI5ZTc3Pl0gYWRk
X3RpbWVyKzB4MTIvMHgxNApbICAgIDMuMTM0NTkxXSAgWzw0MTAzMjQyNT5dIF9fcXVldWVf
ZGVsYXllZF93b3JrKzB4ZGUvMHhmOApbICAgIDMuMTM0NTkxXSAgWzw0MTAzMjQ4Mz5dIHF1
ZXVlX2RlbGF5ZWRfd29ya19vbisweDQ0LzB4NzUKWyAgICAzLjEzNDU5MV0gIFs8NDExZGI1
ZGE+XSBrb2JqZWN0X3JlbGVhc2UrMHg3NC8weDc4ClsgICAgMy4xMzQ1OTFdICBbPDQxMWRi
NjJkPl0ga29iamVjdF9wdXQrMHg0Zi8weDU1ClsgICAgMy4xMzQ1OTFdICBbPDQxMzQ1NzVj
Pl0gPyBfcmF3X3NwaW5fdW5sb2NrKzB4MWQvMHgzZApbICAgIDMuMTM0NTkxXSAgWzw0MTFk
YjY2Zj5dID8ga29ial9rc2V0X2xlYXZlKzB4M2MvMHg0MApbICAgIDMuMTM0NTkxXSAgWzw0
MTFkYjZhOT5dIGtvYmplY3RfZGVsKzB4MjUvMHgyZgpbICAgIDMuMTM0NTkxXSAgWzw0MTI1
YmFkMj5dIGRldmljZV9kZWwrMHgxMjcvMHgxMzMKWyAgICAzLjEzNDU5MV0gIFs8NDEyNWJh
ZTk+XSBkZXZpY2VfdW5yZWdpc3RlcisweGIvMHgxNQpbICAgIDMuMTM0NTkxXSAgWzw0MTI1
YmI0Nj5dIGRldmljZV9kZXN0cm95KzB4MmQvMHgzMgpbICAgIDMuMTM0NTkxXSAgWzw0MTI1
YWQ5OD5dID8gY2xhc3NfZGlyX2NoaWxkX25zX3R5cGUrMHhlLzB4ZQpbICAgIDMuMTM0NTkx
XSAgWzw0MTIzYTA0ZT5dIHR0eV91bnJlZ2lzdGVyX2RldmljZSsweDFmLzB4MzcKWyAgICAz
LjEzNDU5MV0gIFs8NDEyNDc0ZWM+XSB1YXJ0X3JlbW92ZV9vbmVfcG9ydCsweGExLzB4ZWUK
WyAgICAzLjEzNDU5MV0gIFs8NDEyNDkwZDg+XSBzZXJpYWw4MjUwX3JlZ2lzdGVyXzgyNTBf
cG9ydCsweGMxLzB4MjM1ClsgICAgMy4xMzQ1OTFdICBbPDQxMjQ5NDA3Pl0gc2VyaWFsODI1
MF9wcm9iZSsweDEwOC8weDE2YQpbICAgIDMuMTM0NTkxXSAgWzw0MTAzZjNmMz5dID8gc2No
ZWRfY2xvY2tfY3B1KzB4ZDgvMHhlZQpbICAgIDMuMTM0NTkxXSAgWzw0MTAxOWJiMT5dID8g
cHZjbG9ja19jbG9ja3NvdXJjZV9yZWFkKzB4OWQvMHhkNApbICAgIDMuMTM0NTkxXSAgWzw0
MTI1ZjcyMz5dIHBsYXRmb3JtX2Rydl9wcm9iZSsweDI5LzB4NGIKWyAgICAzLjEzNDU5MV0g
IFs8NDEyNWUzMWI+XSBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4OGYvMHgxOTQKWyAgICAzLjEz
NDU5MV0gIFs8NDEyNWY4NDU+XSA/IHBsYXRmb3JtX21hdGNoKzB4NTIvMHg2NgpbICAgIDMu
MTM0NTkxXSAgWzw0MTI1ZTQzYz5dIF9fZGV2aWNlX2F0dGFjaCsweDFjLzB4MmMKWyAgICAz
LjEzNDU5MV0gIFs8NDEyNWNkOGI+XSBidXNfZm9yX2VhY2hfZHJ2KzB4MzgvMHg2YgpbICAg
IDMuMTM0NTkxXSAgWzw0MTI1ZTI1Nz5dIGRldmljZV9hdHRhY2grMHg2Ni8weDgzClsgICAg
My4xMzQ1OTFdICBbPDQxMjVlNDIwPl0gPyBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4MTk0LzB4
MTk0ClsgICAgMy4xMzQ1OTFdICBbPDQxMjVkOTg4Pl0gYnVzX3Byb2JlX2RldmljZSsweDI1
LzB4ODQKWyAgICAzLjEzNDU5MV0gIFs8NDEyNWMyNjQ+XSBkZXZpY2VfYWRkKzB4M2U2LzB4
NTdiClsgICAgMy4xMzQ1OTFdICBbPDQxMWUzNjFiPl0gPyBrdmFzcHJpbnRmKzB4M2IvMHg0
NApbICAgIDMuMTM0NTkxXSAgWzw0MTFkYmE2Nz5dID8ga29iamVjdF9zZXRfbmFtZV92YXJn
cysweDNkLzB4NGEKWyAgICAzLjEzNDU5MV0gIFs8NDEyNWY1ODU+XSBwbGF0Zm9ybV9kZXZp
Y2VfYWRkKzB4MTMxLzB4MTk1ClsgICAgMy4xMzQ1OTFdICBbPDQxMjVmYTU4Pl0gcGxhdGZv
cm1fZGV2aWNlX3JlZ2lzdGVyKzB4MWMvMHgxZgpbICAgIDMuMTM0NTkxXSAgWzw0MTY3NTlm
Nz5dID8gc2V0dXBfZWFybHlfc2VyaWFsODI1MF9jb25zb2xlKzB4Mzc2LzB4Mzc2ClsgICAg
My4xMzQ1OTFdICBbPDQxNjc1YTA0Pl0gYWNjZW50X2luaXQrMHhkLzB4ZgpbICAgIDMuMTM0
NTkxXSAgWzw0MTAwMDNkZj5dIGRvX29uZV9pbml0Y2FsbCsweDdlLzB4MTBjClsgICAgMy4x
MzQ1OTFdICBbPDQxMDU0ZjY0Pl0gPyBsb2NrX3JlbGVhc2VfaG9sZHRpbWUrMHhiZS8weGM0
ClsgICAgMy4xMzQ1OTFdICBbPDQxMDU3NDU2Pl0gPyB0cmFjZV9oYXJkaXJxc19vbl9jYWxs
ZXIrMHgxNDkvMHgxOWIKWyAgICAzLjEzNDU5MV0gIFs8NDE2NTk0MDA+XSA/IGRvX2Vhcmx5
X3BhcmFtKzB4NGYvMHg3YQpbICAgIDMuMTM0NTkxXSAgWzw0MTAzNWUyNT5dID8gcGFyc2Vf
YXJncysweDE1ZC8weDIyMgpbICAgIDMuMTM0NTkxXSAgWzw0MTY1OWE4OT5dIGtlcm5lbF9p
bml0X2ZyZWVhYmxlKzB4MTE2LzB4MWI1ClsgICAgMy4xMzQ1OTFdICBbPDQxNjU5NDJiPl0g
PyBkb19lYXJseV9wYXJhbSsweDdhLzB4N2EKWyAgICAzLjEzNDU5MV0gIFs8NDEzM2I3MzA+
XSBrZXJuZWxfaW5pdCsweGIvMHhjMwpbICAgIDMuMTM0NTkxXSAgWzw0MTM0OWRiYj5dIHJl
dF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDMwClsgICAgMy4xMzQ1OTFdICBbPDQxMzNi
NzI1Pl0gPyByZXN0X2luaXQrMHhiNS8weGI1ClsgICAgMy4xMzQ1OTFdIC0tLVsgZW5kIHRy
YWNlIDBjZTU5YTRjMzgzNGE1NzIgXS0tLQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNS0w
ODI0MTUyNS81ZThkMWFjZDA1Njg3NzIwY2JiMGIwODk3NWVhY2I3NTg4ZmRmYzQyL2RtZXNn
LWt2bS13YWltZWEtMzY0Ny0yMDEzMDgyNTEwMDY1OS0zLjExLjAtcmM2LTA2Njc3LWc1ZThk
MWFjLTEzNAoKYmlzZWN0OiBiYWQgY29tbWl0IDVlOGQxYWNkMDU2ODc3MjBjYmIwYjA4OTc1
ZWFjYjc1ODhmZGZjNDIKZ2l0IGNoZWNrb3V0IHYzLjEwClByZXZpb3VzIEhFQUQgcG9zaXRp
b24gd2FzIDVlOGQxYWMuLi4gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnYWlvL21h
c3RlcicKSEVBRCBpcyBub3cgYXQgOGJiNDk1ZS4uLiBMaW51eCAzLjEwCmxzIC1hIC9rZXJu
ZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajUtMDgyNDE1MjUvbmV4
dDptYXN0ZXI6OGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3NjpiaXNl
Y3QtbW1vdG0KCjIwMTMtMDgtMjUtMTA6MDc6MzcgOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIx
ZDc3ZjNhYzlmMDc5ZTM3NiBjb21waWxpbmcKOTYgcmVhbCAgMTMwMyB1c2VyICAxMzIgc3lz
ICAxNDg1LjYzJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1qNS0wODI0MTUyNQoKMjAxMy0wOC0y
NS0xMDowOTozMiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEwLjAuLi4uLi4uLi4uLi4uLi4u
LgkyLgkzCTQuCTUJNgk3CTguLi4JOQkxNS4JMTYJMjEuCTIyLi4uCTIzLgkyNC4uCTI1Li4u
CTI4LgkzMy4uLi4uCTM0CTM3LgkzOAk0MAk0My4JNDQJNDcJNTAuCTUxLi4JNTIJNTMuLgk1
NAk1Ni4uCTU3Li4uLgk1OAk1OQk2MCBTVUNDRVNTCgpiaXNlY3Q6IGdvb2QgY29tbWl0IHYz
LjEwCmdpdCBiaXNlY3Qgc3RhcnQgNWU4ZDFhY2QwNTY4NzcyMGNiYjBiMDg5NzVlYWNiNzU4
OGZkZmM0MiB2My4xMCAtLQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA4YmI0OTVlLi4u
IExpbnV4IDMuMTAKSEVBRCBpcyBub3cgYXQgODA1YTZhZi4uLiBMaW51eCAzLjIKQmlzZWN0
aW5nOiA5MTMwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAx
MyBzdGVwcykKWzhjYmQwZWVmY2FmOGNjMzJkZWQyYmYyMjlmMGZjMzc5YjJhZDY5ZjJdIE1l
cmdlIGJyYW5jaCAnbmV4dCcgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51
eC9rZXJuZWwvZ2l0L3J6aGFuZy9saW51eApnaXQgYmlzZWN0IHJ1biAvYy9rZXJuZWwtdGVz
dHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9tbW90bS9vYmotYmlz
ZWN0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aCAvaG9tZS93ZmcvbW1vdG0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1x
dWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1L25leHQ6bWFzdGVyOjhjYmQw
ZWVmY2FmOGNjMzJkZWQyYmYyMjlmMGZjMzc5YjJhZDY5ZjI6YmlzZWN0LW1tb3RtCgoyMDEz
LTA4LTI1LTEwOjUzOjI1IDhjYmQwZWVmY2FmOGNjMzJkZWQyYmYyMjlmMGZjMzc5YjJhZDY5
ZjIgY29tcGlsaW5nCjE0NiByZWFsICAxMzI3IHVzZXIgIDEyOSBzeXMgIDk5NC42NCUgY3B1
IAlpMzg2LXJhbmRjb25maWctajUtMDgyNDE1MjUKCjIwMTMtMDgtMjUtMTA6NTY6MTcgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMC4wLTA5MTI3LWc4Y2JkMGVlLi4JMy4JNAk3Lgk4CTkJ
MTAJMTIJMTQJMTcuCTIxCTI3CTMwCTMxCTM2CTM5Li4uCTQwCTQyCTQ1CTQ4CTUwCTU0CTU3
CTU4CTU5Li4uLi4uLi4uLi4uLi4uLi4uLi4JNjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA0NTc4
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMiBzdGVwcykK
WzYwYTJiOTc3NTMzYzMxMmQyNzE1NjNkOTU1ZWY3YjhlMzVhNmFhMzhdIE1lcmdlIHJlbW90
ZS10cmFja2luZyBicmFuY2ggJ2luZmluaWJhbmQvZm9yLW5leHQnCnJ1bm5pbmcgL2Mva2Vy
bmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW1vdG0v
b2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5k
Y29uZmlnLWo1LTA4MjQxNTI1L25leHQ6bWFzdGVyOjYwYTJiOTc3NTMzYzMxMmQyNzE1NjNk
OTU1ZWY3YjhlMzVhNmFhMzg6YmlzZWN0LW1tb3RtCgoyMDEzLTA4LTI1LTExOjIyOjUwIDYw
YTJiOTc3NTMzYzMxMmQyNzE1NjNkOTU1ZWY3YjhlMzVhNmFhMzggY29tcGlsaW5nCjE0NSBy
ZWFsICAxMzQxIHVzZXIgIDEyNiBzeXMgIDEwMDkuMzclIGNwdSAJaTM4Ni1yYW5kY29uZmln
LWo1LTA4MjQxNTI1CgoyMDEzLTA4LTI1LTExOjI1OjM2IGRldGVjdGluZyBib290IHN0YXRl
IDMuMTEuMC1yYzYtMDIwOTgtZzYwYTJiOTcuLgk3CTEzCTE2CTE4CTE5CTIwCTIyCTI1CTI4
CTM0CTM5CTQ2CTUyCTU1CTU2CTU4CTYwIFNVQ0NFU1MKCkJpc2VjdGluZzogMjM2MCByZXZp
c2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTEgc3RlcHMpCls0YTIy
NWI0NjZlMDQwYTcwZTdkMTJiMTU5ZDJhMzZkYTFjMmVmN2RjXSBuZXh0LTIwMTMwODIxL2Ry
aXZlci1jb3JlCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvaG9tZS93ZmcvbW1vdG0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1L25leHQ6bWFzdGVy
OjRhMjI1YjQ2NmUwNDBhNzBlN2QxMmIxNTlkMmEzNmRhMWMyZWY3ZGM6YmlzZWN0LW1tb3Rt
CgoyMDEzLTA4LTI1LTExOjM1OjA5IDRhMjI1YjQ2NmUwNDBhNzBlN2QxMmIxNTlkMmEzNmRh
MWMyZWY3ZGMgY29tcGlsaW5nCjE1MyByZWFsICAxMzE1IHVzZXIgIDEyNiBzeXMgIDkzOS40
MiUgY3B1IAlpMzg2LXJhbmRjb25maWctajUtMDgyNDE1MjUKCjIwMTMtMDgtMjUtMTE6Mzg6
MDAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLXJjNi0wNDMxNi1nNGEyMjViNC4uLi4u
LiBURVNUIEZBSUxVUkUKWyAgICAxLjk5MjU1MV0gV0FSTklORzogQ1BVOiAwIFBJRDogMSBh
dCAvYy93ZmcvbGludXgtbW1vdG0vbGliL2RlYnVnb2JqZWN0cy5jOjI2MCBkZWJ1Z19wcmlu
dF9vYmplY3QrMHg3Ni8weDg0KCkKWyAgICAxLjk5NDA4MV0gT0RFQlVHOiBpbml0IGFjdGl2
ZSAoYWN0aXZlIHN0YXRlIDApIG9iamVjdCB0eXBlOiB0aW1lcl9saXN0IGhpbnQ6ICAgKG51
bGwpClsgICAgMS45OTUzMTVdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDEuOTk1MzM2XSBD
UFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xMS4wLXJjNi0wNDMx
Ni1nNGEyMjViNCAjMTM4ClsgICAgMS45OTUzMzZdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJv
Y2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAxLjk5NTMzNl0gIDQwMDQxYjY4IDQw
MDQxYjY4IDQwMDQxYjI4IDQxMzM3NmY4IDQwMDQxYjU4IDQxMDIyYmE5IDQxNDY3YWY5IDQw
MDQxYjg0ClsgICAgMS45OTUzMzZdICAwMDAwMDAwMSA0MTQ2N2IzNiAwMDAwMDEwNCA0MTFl
Nzg5OSA0MTFlNzg5OSA0MDA4NGUzMCA0MTRkM2VkNCA0MTQ0NWY3ZQpbICAgIDEuOTk1MzM2
XSAgNDAwNDFiNzAgNDEwMjJiZWUgMDAwMDAwMDkgNDAwNDFiNjggNDE0NjdhZjkgNDAwNDFi
ODQgNDAwNDFiYTQgNDExZTc4OTkKWyAgICAxLjk5NTMzNl0gQ2FsbCBUcmFjZToKWyAgICAx
Ljk5NTMzNl0gIFs8NDEzMzc2Zjg+XSBkdW1wX3N0YWNrKzB4MTYvMHgxOApbICAgIDEuOTk1
MzM2XSAgWzw0MTAyMmJhOT5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4NzAvMHg4NwpbICAg
IDEuOTk1MzM2XSAgWzw0MTFlNzg5OT5dID8gZGVidWdfcHJpbnRfb2JqZWN0KzB4NzYvMHg4
NApbICAgIDEuOTk1MzM2XSAgWzw0MTFlNzg5OT5dID8gZGVidWdfcHJpbnRfb2JqZWN0KzB4
NzYvMHg4NApbICAgIDEuOTk1MzM2XSAgWzw0MTAyMmJlZT5dIHdhcm5fc2xvd3BhdGhfZm10
KzB4MmUvMHgzMApbICAgIDEuOTk1MzM2XSAgWzw0MTFlNzg5OT5dIGRlYnVnX3ByaW50X29i
amVjdCsweDc2LzB4ODQKWyAgICAxLjk5NTMzNl0gIFs8NDExZTdiMjQ+XSBfX2RlYnVnX29i
amVjdF9pbml0KzB4MjdkLzB4MmJiClsgICAgMS45OTUzMzZdICBbPDQxMWU3ZDg4Pl0gZGVi
dWdfb2JqZWN0X2luaXQrMHgxMy8weDE1ClsgICAgMS45OTUzMzZdICBbPDQxMDI5NGI5Pl0g
aW5pdF90aW1lcl9rZXkrMHgxNy8weDY0ClsgICAgMS45OTUzMzZdICBbPDQxMWRhOTEwPl0g
a29iamVjdF9yZWxlYXNlKzB4NTAvMHg3OApbICAgIDEuOTk1MzM2XSAgWzw0MTFkYTk4Nz5d
IGtvYmplY3RfcHV0KzB4NGYvMHg1NQpbICAgIDEuOTk1MzM2XSAgWzw0MTBhZDg2MT5dIGNk
ZXZfZGVsKzB4MjMvMHgyNgpbICAgIDEuOTk1MzM2XSAgWzw0MTIzOTNjMj5dIHR0eV91bnJl
Z2lzdGVyX2RldmljZSsweDMzLzB4MzcKWyAgICAxLjk5NTMzNl0gIFs8NDEyNDY5ZDc+XSB1
YXJ0X3JlbW92ZV9vbmVfcG9ydCsweGExLzB4ZWIKWyAgICAxLjk5NTMzNl0gIFs8NDEyNDg1
OWU+XSBzZXJpYWw4MjUwX3JlZ2lzdGVyXzgyNTBfcG9ydCsweGMxLzB4MjM1ClsgICAgMS45
OTUzMzZdICBbPDQxMjQ4OGNkPl0gc2VyaWFsODI1MF9wcm9iZSsweDEwOC8weDE2YQpbICAg
IDEuOTk1MzM2XSAgWzw0MTAzZjNmMz5dID8gc2NoZWRfY2xvY2tfY3B1KzB4ZDgvMHhlZQpb
ICAgIDEuOTk1MzM2XSAgWzw0MTI1ZWI1MD5dIHBsYXRmb3JtX2Rydl9wcm9iZSsweDI5LzB4
NGIKWyAgICAxLjk5NTMzNl0gIFs8NDEyNWQ3NDg+XSBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4
OGYvMHgxOTQKWyAgICAxLjk5NTMzNl0gIFs8NDEyNWVjNzI+XSA/IHBsYXRmb3JtX21hdGNo
KzB4NTIvMHg2NgpbICAgIDEuOTk1MzM2XSAgWzw0MTI1ZDg2OT5dIF9fZGV2aWNlX2F0dGFj
aCsweDFjLzB4MmMKWyAgICAxLjk5NTMzNl0gIFs8NDEyNWMxYjg+XSBidXNfZm9yX2VhY2hf
ZHJ2KzB4MzgvMHg2YgpbICAgIDEuOTk1MzM2XSAgWzw0MTI1ZDY4ND5dIGRldmljZV9hdHRh
Y2grMHg2Ni8weDgzClsgICAgMS45OTUzMzZdICBbPDQxMjVkODRkPl0gPyBkcml2ZXJfcHJv
YmVfZGV2aWNlKzB4MTk0LzB4MTk0ClsgICAgMS45OTUzMzZdICBbPDQxMjVjZGI1Pl0gYnVz
X3Byb2JlX2RldmljZSsweDI1LzB4ODQKWyAgICAxLjk5NTMzNl0gIFs8NDEyNWI2OTE+XSBk
ZXZpY2VfYWRkKzB4M2U2LzB4NTdiClsgICAgMS45OTUzMzZdICBbPDQxMWUyOTdiPl0gPyBr
dmFzcHJpbnRmKzB4M2IvMHg0NApbICAgIDEuOTk1MzM2XSAgWzw0MTFkYWRjMT5dID8ga29i
amVjdF9zZXRfbmFtZV92YXJncysweDNkLzB4NGEKWyAgICAxLjk5NTMzNl0gIFs8NDEyNWU5
YjI+XSBwbGF0Zm9ybV9kZXZpY2VfYWRkKzB4MTMxLzB4MTk1ClsgICAgMS45OTUzMzZdICBb
PDQxMjVlZTg1Pl0gcGxhdGZvcm1fZGV2aWNlX3JlZ2lzdGVyKzB4MWMvMHgxZgpbICAgIDEu
OTk1MzM2XSAgWzw0MTY2ODlmNz5dID8gc2V0dXBfZWFybHlfc2VyaWFsODI1MF9jb25zb2xl
KzB4Mzc2LzB4Mzc2ClsgICAgMS45OTUzMzZdICBbPDQxNjY4YTA0Pl0gYWNjZW50X2luaXQr
MHhkLzB4ZgpbICAgIDEuOTk1MzM2XSAgWzw0MTAwMDNkZj5dIGRvX29uZV9pbml0Y2FsbCsw
eDdlLzB4MTBjClsgICAgMS45OTUzMzZdICBbPDQxMDU0ZjEyPl0gPyBsb2NrX3JlbGVhc2Vf
aG9sZHRpbWUrMHhiZS8weGM0ClsgICAgMS45OTUzMzZdICBbPDQxMDU3NDA0Pl0gPyB0cmFj
ZV9oYXJkaXJxc19vbl9jYWxsZXIrMHgxNDkvMHgxOWIKWyAgICAxLjk5NTMzNl0gIFs8NDE2
NGM0MDA+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4NGYvMHg3YQpbICAgIDEuOTk1MzM2XSAgWzw0
MTAzNWUyNT5dID8gcGFyc2VfYXJncysweDE1ZC8weDIyMgpbICAgIDEuOTk1MzM2XSAgWzw0
MTY0Y2E4OT5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MTE2LzB4MWI1ClsgICAgMS45OTUz
MzZdICBbPDQxNjRjNDJiPl0gPyBkb19lYXJseV9wYXJhbSsweDdhLzB4N2EKWyAgICAxLjk5
NTMzNl0gIFs8NDEzMzIxZmY+XSBrZXJuZWxfaW5pdCsweGIvMHhjMwpbICAgIDEuOTk1MzM2
XSAgWzw0MTM0MDc3Yj5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDMwClsgICAg
MS45OTUzMzZdICBbPDQxMzMyMWY0Pl0gPyByZXN0X2luaXQrMHhiNS8weGI1ClsgICAgMS45
OTUzMzZdIC0tLVsgZW5kIHRyYWNlIDNkYTlkYjU4OWNmMjc0NmEgXS0tLQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1qNS0wODI0MTUyNS80YTIyNWI0NjZlMDQwYTcwZTdkMTJiMTU5ZDJh
MzZkYTFjMmVmN2RjL2RtZXNnLWt2bS1iZW5zLTM0OTAtMjAxMzA4MjUxMTM2MjctMy4xMS4w
LXJjNi0wNDMxNi1nNGEyMjViNC0xMzgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajUtMDgy
NDE1MjUvNGEyMjViNDY2ZTA0MGE3MGU3ZDEyYjE1OWQyYTM2ZGExYzJlZjdkYy9kbWVzZy1r
dm0taW5uLTc4NDEtMjAxMzA4MjUxMTQwMjQtMy4xMS4wLXJjNi0wNDMxNi1nNGEyMjViNC0x
MzgKCkJpc2VjdGluZzogMTExNSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgMTAgc3RlcHMpCls5ODI0NmMxYWU2ZjE4ZmUxYjcxMGNkZmY2ODdiNmI3MDc3
ZjczOWM5XSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICd2aXJ0aW8vdmlydGlvLW5l
eHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aCAvaG9tZS93ZmcvbW1vdG0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1x
dWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1L25leHQ6bWFzdGVyOjk4MjQ2
YzFhZTZmMThmZTFiNzEwY2RmZjY4N2I2YjcwNzdmNzM5Yzk6YmlzZWN0LW1tb3RtCgoyMDEz
LTA4LTI1LTExOjQxOjA0IDk4MjQ2YzFhZTZmMThmZTFiNzEwY2RmZjY4N2I2YjcwNzdmNzM5
YzkgY29tcGlsaW5nCjE0MyByZWFsICAxMzI0IHVzZXIgIDEzMyBzeXMgIDEwMTguNDclIGNw
dSAJaTM4Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1CgoyMDEzLTA4LTI1LTExOjQzOjQ5IGRl
dGVjdGluZyBib290IHN0YXRlIDMuMTEuMC1yYzYtMDMyMDAtZzk4MjQ2YzEuLgkxCTIuLgkz
CTYJOAkxOQkyNQkzMQkzOQk0OAk1Mwk1OAk1OQk2MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDU1
NSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOSBzdGVwcykK
WzM4MTM2YzFmMTQ3MWM3ZGNiZTg4OWJlYjc5MGNjNGQzMzFlOWQzYWRdIE1lcmdlIHJlbW90
ZS10cmFja2luZyBicmFuY2ggJ3NwaS9mb3ItbmV4dCcKcnVubmluZyAvYy9rZXJuZWwtdGVz
dHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9tbW90bS9vYmotYmlz
ZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
ajUtMDgyNDE1MjUvbmV4dDptYXN0ZXI6MzgxMzZjMWYxNDcxYzdkY2JlODg5YmViNzkwY2M0
ZDMzMWU5ZDNhZDpiaXNlY3QtbW1vdG0KCjIwMTMtMDgtMjUtMTE6NTI6NTEgMzgxMzZjMWYx
NDcxYzdkY2JlODg5YmViNzkwY2M0ZDMzMWU5ZDNhZCBjb21waWxpbmcKMTM3IHJlYWwgIDEz
NDUgdXNlciAgMTMzIHN5cyAgMTA3My44OCUgY3B1IAlpMzg2LXJhbmRjb25maWctajUtMDgy
NDE1MjUKCjIwMTMtMDgtMjUtMTE6NTU6MzEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4w
LXJjNi0wMzc2MC1nMzgxMzZjMS4uCTEJMgkzLi4JNAk1Lgk2CTcuLi4uCTgJMTEuLgkxNgkx
OS4JMjIJMjUJMjYJMzAJMzIJMzMJMzQJMzkJNDEuCTQzCTQ1Li4uCTQ3CTQ5Li4uLgk1Mgk1
Mwk1NAk1Nwk2MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDI3NSByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOCBzdGVwcykKW2YwNzc2MmJlM2I5MjIyYTc2NDlj
YjI5YTNmNWI5NTkyMDRkNDA0NDZdIE1lcmdlIGJyYW5jaCAneDg2L2FzbWxpbmthZ2UnCnJ1
bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9t
ZS93ZmcvbW1vdG0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0vaTM4Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1L25leHQ6bWFzdGVyOmYwNzc2MmJlM2I5
MjIyYTc2NDljYjI5YTNmNWI5NTkyMDRkNDA0NDY6YmlzZWN0LW1tb3RtCgoyMDEzLTA4LTI1
LTEyOjIwOjAzIGYwNzc2MmJlM2I5MjIyYTc2NDljYjI5YTNmNWI5NTkyMDRkNDA0NDYgY29t
cGlsaW5nCjE0MCByZWFsICAxMzI2IHVzZXIgIDEyOCBzeXMgIDEwMzguMDAlIGNwdSAJaTM4
Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1CgoyMDEzLTA4LTI1LTEyOjIyOjQwIGRldGVjdGlu
ZyBib290IHN0YXRlIDMuMTEuMC1yYzYtMDAzMDgtZ2YwNzc2MmIuLgk0CTIwCTM0CTQzCTQ2
Li4JNDgJNTMJNTkJNjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxMzggcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDcgc3RlcHMpCls5M2Q2Mjk0ZGZjZGZmODEx
OTQwODZlZDliZDZjZWNhM2JjNWU1ODYzXSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNo
ICdrdm0tcHBjL2t2bS1wcGMtbmV4dCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9tbW90bS9vYmotYmlzZWN0CmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajUtMDgyNDE1
MjUvbmV4dDptYXN0ZXI6OTNkNjI5NGRmY2RmZjgxMTk0MDg2ZWQ5YmQ2Y2VjYTNiYzVlNTg2
MzpiaXNlY3QtbW1vdG0KCjIwMTMtMDgtMjUtMTI6Mjk6MTIgOTNkNjI5NGRmY2RmZjgxMTk0
MDg2ZWQ5YmQ2Y2VjYTNiYzVlNTg2MyBjb21waWxpbmcKMTUzIHJlYWwgIDEzMzEgdXNlciAg
MTMyIHN5cyAgOTU1LjQ3JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1qNS0wODI0MTUyNQoKMjAx
My0wOC0yNS0xMjozMjoxMyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAtcmM2LTA0MTc3
LWc5M2Q2Mjk0Li4JMS4uLi4uLi4uLi4JMi4uLi4uLgkzLi4JNC4uLi4uLi4uLgk1Lgk3Lgk4
CTEwCTExCTEzCTI4CTMzCTQxCTQzCTQ4CTUwCTUxCTUyLgk1NQk1OAk1OS4JNjAgU1VDQ0VT
UwoKQmlzZWN0aW5nOiA1NyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgNiBzdGVwcykKW2M1N2U4Yzg5YjI3MWFmNGVmOTE0YzQzOWVmZmZmZWQ1M2MzOTQz
NGNdIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ2xlZHMvZm9yLW5leHQnCnJ1bm5p
bmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93
ZmcvbW1vdG0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
aTM4Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1L25leHQ6bWFzdGVyOmM1N2U4Yzg5YjI3MWFm
NGVmOTE0YzQzOWVmZmZmZWQ1M2MzOTQzNGM6YmlzZWN0LW1tb3RtCgoyMDEzLTA4LTI1LTEy
OjU5OjQ1IGM1N2U4Yzg5YjI3MWFmNGVmOTE0YzQzOWVmZmZmZWQ1M2MzOTQzNGMgY29tcGls
aW5nCjEzOSByZWFsICAxMzA5IHVzZXIgIDEyNiBzeXMgIDEwMzEuNzMlIGNwdSAJaTM4Ni1y
YW5kY29uZmlnLWo1LTA4MjQxNTI1CgoyMDEzLTA4LTI1LTEzOjAyOjI2IGRldGVjdGluZyBi
b290IHN0YXRlIDMuMTEuMC1yYzYtMDQyNTgtZ2M1N2U4YzguLi4uLi4uLgkxLgkyCTMuLi4J
NAk1Li4uLi4uLi4uLgk2Li4uLi4uLi4uLgk3Li4uLi4uLi4uLi4JMTMuCTIxCTIzCTI0CTI3
CTI4CTMwCTMxCTM1CTM3LgkzOS4JNDEJNDMJNDUJNDcuLi4JNDkJNTAuLi4JNTIJNTMJNTQJ
NTUuLi4uLgk1Ni4JNTcJNTguLi4uCTU5Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4JNjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAyOCByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNSBzdGVwcykKWzc2ZjQxMWZiM2E2MjcxMWRl
N2Y1OWUwZjRjNTY0NTZmZTM1NjY3NWFdIHg4NiAvIGNwdSB0b3BvbG9neTogcmVtb3ZlIHRo
ZSBzdGFsZSBtYWNybyBhcmNoX3Byb3ZpZGVzX3RvcG9sb2d5X3BvaW50ZXJzCnJ1bm5pbmcg
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcv
bW1vdG0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4
Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1L25leHQ6bWFzdGVyOjc2ZjQxMWZiM2E2MjcxMWRl
N2Y1OWUwZjRjNTY0NTZmZTM1NjY3NWE6YmlzZWN0LW1tb3RtCgoyMDEzLTA4LTI1LTE0OjEw
OjM4IDc2ZjQxMWZiM2E2MjcxMWRlN2Y1OWUwZjRjNTY0NTZmZTM1NjY3NWEgY29tcGlsaW5n
CjE3MCByZWFsICAxMzIwIHVzZXIgIDEyNyBzeXMgIDg1MS4xMSUgY3B1IAlpMzg2LXJhbmRj
b25maWctajUtMDgyNDE1MjUKCjIwMTMtMDgtMjUtMTQ6MTM6NDkgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgMy4xMS4wLXJjMy0wMDAyOS1nNzZmNDExZi4uLi4uLi4gVEVTVCBGQUlMVVJFClsg
ICAgMi42NDY0MzZdIFdBUk5JTkc6IENQVTogMCBQSUQ6IDEgYXQgL2Mvd2ZnL2xpbnV4LW1t
b3RtL2xpYi9saXN0X2RlYnVnLmM6MzMgX19saXN0X2FkZCsweDZjLzB4YWUoKQpbICAgIDIu
NjQ4MDQ3XSBsaXN0X2FkZCBjb3JydXB0aW9uLiBwcmV2LT5uZXh0IHNob3VsZCBiZSBuZXh0
ICg0MTZkMGI1OCksIGJ1dCB3YXMgICAobnVsbCkuIChwcmV2PTQ2YTkyMTAwKS4KWyAgICAy
LjY0ODA0N10gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMi42NDgwNDddIENQVTogMCBQSUQ6
IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjExLjAtcmMzLTAwMDI5LWc3NmY0MTFm
ICMxNDQKWyAgICAyLjY0ODA0N10gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1Mg
Qm9jaHMgMDEvMDEvMjAxMQpbICAgIDIuNjQ4MDQ3XSAgNDAwNDFiMGMgNDAwNDFiMGMgNDAw
NDFhY2MgNDEzMzNkNWQgNDAwNDFhZmMgNDEwMjI1MjkgNDE0NjE3YzggNDAwNDFiMjgKWyAg
ICAyLjY0ODA0N10gIDAwMDAwMDAxIDQxNDYxN2E0IDAwMDAwMDIxIDQxMWU1MmM1IDQxMWU1
MmM1IDQ2YTkyMTAwIDQxNmQwYjU4IDQ2YTMzOWM4ClsgICAgMi42NDgwNDddICA0MDA0MWIx
NCA0MTAyMjU2ZSAwMDAwMDAwOSA0MDA0MWIwYyA0MTQ2MTdjOCA0MDA0MWIyOCA0MDA0MWI0
MCA0MTFlNTJjNQpbICAgIDIuNjQ4MDQ3XSBDYWxsIFRyYWNlOgpbICAgIDIuNjQ4MDQ3XSAg
Wzw0MTMzM2Q1ZD5dIGR1bXBfc3RhY2srMHgxNi8weDE4ClsgICAgMi42NDgwNDddICBbPDQx
MDIyNTI5Pl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg3MC8weDg3ClsgICAgMi42NDgwNDdd
ICBbPDQxMWU1MmM1Pl0gPyBfX2xpc3RfYWRkKzB4NmMvMHhhZQpbICAgIDIuNjQ4MDQ3XSAg
Wzw0MTFlNTJjNT5dID8gX19saXN0X2FkZCsweDZjLzB4YWUKWyAgICAyLjY0ODA0N10gIFs8
NDEwMjI1NmU+XSB3YXJuX3Nsb3dwYXRoX2ZtdCsweDJlLzB4MzAKWyAgICAyLjY0ODA0N10g
IFs8NDExZTUyYzU+XSBfX2xpc3RfYWRkKzB4NmMvMHhhZQpbICAgIDIuNjQ4MDQ3XSAgWzw0
MTAyYjhiYj5dIF9faW50ZXJuYWxfYWRkX3RpbWVyKzB4OGEvMHg4ZQpbICAgIDIuNjQ4MDQ3
XSAgWzw0MTAyYjhjZD5dIGludGVybmFsX2FkZF90aW1lcisweGUvMHgyNgpbICAgIDIuNjQ4
MDQ3XSAgWzw0MTAyYzA0Yj5dIG1vZF90aW1lcisweGRjLzB4ZjgKWyAgICAyLjY0ODA0N10g
IFs8NDEwMmMwNzk+XSBhZGRfdGltZXIrMHgxMi8weDE0ClsgICAgMi42NDgwNDddICBbPDQx
MDM0NjI4Pl0gX19xdWV1ZV9kZWxheWVkX3dvcmsrMHhkZS8weGY4ClsgICAgMi42NDgwNDdd
ICBbPDQxMDM0Njg2Pl0gcXVldWVfZGVsYXllZF93b3JrX29uKzB4NDQvMHg3NQpbICAgIDIu
NjQ4MDQ3XSAgWzw0MTFkODdlZT5dIGtvYmplY3RfcmVsZWFzZSsweDc0LzB4NzgKWyAgICAy
LjY0ODA0N10gIFs8NDExZDg4NDE+XSBrb2JqZWN0X3B1dCsweDRmLzB4NTUKWyAgICAyLjY0
ODA0N10gIFs8NDEzMzg4NjQ+XSA/IF9yYXdfc3Bpbl91bmxvY2srMHgxZC8weDNkClsgICAg
Mi42NDgwNDddICBbPDQxMWQ4ODgzPl0gPyBrb2JqX2tzZXRfbGVhdmUrMHgzYy8weDQwClsg
ICAgMi42NDgwNDddICBbPDQxMWQ4OGJkPl0ga29iamVjdF9kZWwrMHgyNS8weDJmClsgICAg
Mi42NDgwNDddICBbPDQxMjU4NjY4Pl0gZGV2aWNlX2RlbCsweDEyNy8weDEzMwpbICAgIDIu
NjQ4MDQ3XSAgWzw0MTI1ODY3Zj5dIGRldmljZV91bnJlZ2lzdGVyKzB4Yi8weDE1ClsgICAg
Mi42NDgwNDddICBbPDQxMjU4NmRjPl0gZGV2aWNlX2Rlc3Ryb3krMHgyZC8weDMyClsgICAg
Mi42NDgwNDddICBbPDQxMjU3OThlPl0gPyBjbGFzc19kaXJfY2hpbGRfbnNfdHlwZSsweGUv
MHhlClsgICAgMi42NDgwNDddICBbPDQxMjM2YjczPl0gdHR5X3VucmVnaXN0ZXJfZGV2aWNl
KzB4MWYvMHgzNwpbICAgIDIuNjQ4MDQ3XSAgWzw0MTI0NDE5Yz5dIHVhcnRfcmVtb3ZlX29u
ZV9wb3J0KzB4YTEvMHhlYgpbICAgIDIuNjQ4MDQ3XSAgWzw0MTI0NWQ2Mz5dIHNlcmlhbDgy
NTBfcmVnaXN0ZXJfODI1MF9wb3J0KzB4YzEvMHgyMzUKWyAgICAyLjY0ODA0N10gIFs8NDEy
NDYwOTI+XSBzZXJpYWw4MjUwX3Byb2JlKzB4MTA4LzB4MTZhClsgICAgMi42NDgwNDddICBb
PDQxMDQxNTg2Pl0gPyBzY2hlZF9jbG9ja19jcHUrMHhkOC8weGVlClsgICAgMi42NDgwNDdd
ICBbPDQxMDE5NTFjPl0gPyBwdmNsb2NrX2Nsb2Nrc291cmNlX3JlYWQrMHg5ZC8weGQ0Clsg
ICAgMi42NDgwNDddICBbPDQxMjVjMWY0Pl0gcGxhdGZvcm1fZHJ2X3Byb2JlKzB4MjkvMHg0
YgpbICAgIDIuNjQ4MDQ3XSAgWzw0MTI1YWUyMT5dIGRyaXZlcl9wcm9iZV9kZXZpY2UrMHg4
Zi8weDE5NApbICAgIDIuNjQ4MDQ3XSAgWzw0MTI1YzMxNj5dID8gcGxhdGZvcm1fbWF0Y2gr
MHg1Mi8weDY2ClsgICAgMi42NDgwNDddICBbPDQxMjVhZjQyPl0gX19kZXZpY2VfYXR0YWNo
KzB4MWMvMHgyYwpbICAgIDIuNjQ4MDQ3XSAgWzw0MTI1OTk1OD5dIGJ1c19mb3JfZWFjaF9k
cnYrMHgzOC8weDZiClsgICAgMi42NDgwNDddICBbPDQxMjVhZDVkPl0gZGV2aWNlX2F0dGFj
aCsweDY2LzB4ODMKWyAgICAyLjY0ODA0N10gIFs8NDEyNWFmMjY+XSA/IGRyaXZlcl9wcm9i
ZV9kZXZpY2UrMHgxOTQvMHgxOTQKWyAgICAyLjY0ODA0N10gIFs8NDEyNWE0ZDc+XSBidXNf
cHJvYmVfZGV2aWNlKzB4MjUvMHg4NApbICAgIDIuNjQ4MDQ3XSAgWzw0MTI1OGU1YT5dIGRl
dmljZV9hZGQrMHgzZTYvMHg1N2IKWyAgICAyLjY0ODA0N10gIFs8NDExZTA2ZjI+XSA/IGt2
YXNwcmludGYrMHgzYi8weDQ0ClsgICAgMi42NDgwNDddICBbPDQxMWQ4YzdiPl0gPyBrb2Jq
ZWN0X3NldF9uYW1lX3ZhcmdzKzB4M2QvMHg0YQpbICAgIDIuNjQ4MDQ3XSAgWzw0MTI1YzA1
Nj5dIHBsYXRmb3JtX2RldmljZV9hZGQrMHgxMzEvMHgxOTUKWyAgICAyLjY0ODA0N10gIFs8
NDEyNWM1Mjk+XSBwbGF0Zm9ybV9kZXZpY2VfcmVnaXN0ZXIrMHgxYy8weDFmClsgICAgMi42
NDgwNDddICBbPDQxNjY0N2IxPl0gPyBzZXR1cF9lYXJseV9zZXJpYWw4MjUwX2NvbnNvbGUr
MHgzNzYvMHgzNzYKWyAgICAyLjY0ODA0N10gIFs8NDE2NjQ3YmU+XSBhY2NlbnRfaW5pdCsw
eGQvMHhmClsgICAgMi42NDgwNDddICBbPDQxMDAwM2RmPl0gZG9fb25lX2luaXRjYWxsKzB4
N2UvMHgxMGMKWyAgICAyLjY0ODA0N10gIFs8NDE2NDg0MDA+XSA/IGRvX2Vhcmx5X3BhcmFt
KzB4NGYvMHg3YQpbICAgIDIuNjQ4MDQ3XSAgWzw0MTAzN2ZjNz5dID8gcGFyc2VfYXJncysw
eDE2Ny8weDIyYwpbICAgIDIuNjQ4MDQ3XSAgWzw0MTY0OGE4OT5dIGtlcm5lbF9pbml0X2Zy
ZWVhYmxlKzB4MTE2LzB4MWI1ClsgICAgMi42NDgwNDddICBbPDQxNjQ4NDJiPl0gPyBkb19l
YXJseV9wYXJhbSsweDdhLzB4N2EKWyAgICAyLjY0ODA0N10gIFs8NDEzMmU4NmQ+XSBrZXJu
ZWxfaW5pdCsweGIvMHhjMwpbICAgIDIuNjQ4MDQ3XSAgWzw0MTMzY2ViYj5dIHJldF9mcm9t
X2tlcm5lbF90aHJlYWQrMHgxYi8weDMwClsgICAgMi42NDgwNDddICBbPDQxMzJlODYyPl0g
PyByZXN0X2luaXQrMHhiNS8weGI1ClsgICAgMi42NDgwNDddIC0tLVsgZW5kIHRyYWNlIGFm
MGI1NWQxNGFhNDU3NzEgXS0tLQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNS0wODI0MTUy
NS83NmY0MTFmYjNhNjI3MTFkZTdmNTllMGY0YzU2NDU2ZmUzNTY2NzVhL2RtZXNnLWt2bS13
YWltZWEtODg1NS0yMDEzMDgyNTE0MTYzMy0zLjExLjAtcmMzLTAwMDI5LWc3NmY0MTFmLTE0
NAoKQmlzZWN0aW5nOiAxNCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgNCBzdGVwcykKW2VhMWJiNzA2NGZkNjk3MmVmMDBhOTNiYTg4MmEyZjM4NDUwYjI3
M2VdIHZpZGVvOiBiYWNrbGlnaHQ6IGNvbnZlcnQgY2xhc3MgY29kZSB0byB1c2UgZGV2X2dy
b3VwcwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2ggL2hvbWUvd2ZnL21tb3RtL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4t
cXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qNS0wODI0MTUyNS9uZXh0Om1hc3RlcjplYTFi
YjcwNjRmZDY5NzJlZjAwYTkzYmE4ODJhMmYzODQ1MGIyNzNlOmJpc2VjdC1tbW90bQoKMjAx
My0wOC0yNS0xNDoxNzoyNCBlYTFiYjcwNjRmZDY5NzJlZjAwYTkzYmE4ODJhMmYzODQ1MGIy
NzNlIGNvbXBpbGluZwoxNTEgcmVhbCAgMTI5OSB1c2VyICAxMjcgc3lzICA5NDAuNTUlIGNw
dSAJaTM4Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1CgoyMDEzLTA4LTI1LTE0OjIyOjAwIGRl
dGVjdGluZyBib290IHN0YXRlIDMuMTEuMC1yYzItMDAwMTQtZ2VhMWJiNzAuLi4gVEVTVCBG
QUlMVVJFClsgICAgMi4wMjYzNjBdIFdBUk5JTkc6IENQVTogMCBQSUQ6IDEgYXQgL2Mvd2Zn
L2xpbnV4LW1tb3RtL2xpYi9saXN0X2RlYnVnLmM6MzMgX19saXN0X2FkZCsweDZjLzB4YWUo
KQpbICAgIDIuMDI3MzMwXSBsaXN0X2FkZCBjb3JydXB0aW9uLiBwcmV2LT5uZXh0IHNob3Vs
ZCBiZSBuZXh0ICg0MTZkMTI2OCksIGJ1dCB3YXMgICAobnVsbCkuIChwcmV2PTQ2YTMzMTAw
KS4KWyAgICAyLjAyODM2NV0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMi4wMjg3MjZdIENQ
VTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjExLjAtcmMyLTAwMDE0
LWdlYTFiYjcwICMxNDUKWyAgICAyLjAyOTMyNl0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9j
aHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDIuMDI5MzI2XSAgNDAwNDFiMGMgNDAw
NDFiMGMgNDAwNDFhY2MgNDEzMzNkOGQgNDAwNDFhZmMgNDEwMjI1MjkgNDE0NjBlZjAgNDAw
NDFiMjgKWyAgICAyLjAyOTMyNl0gIDAwMDAwMDAxIDQxNDYwZWNjIDAwMDAwMDIxIDQxMWU1
MmM1IDQxMWU1MmM1IDQ2YTMzMTAwIDQxNmQxMjY4IDQ2YTJlOWM4ClsgICAgMi4wMjkzMjZd
ICA0MDA0MWIxNCA0MTAyMjU2ZSAwMDAwMDAwOSA0MDA0MWIwYyA0MTQ2MGVmMCA0MDA0MWIy
OCA0MDA0MWI0MCA0MTFlNTJjNQpbICAgIDIuMDI5MzI2XSBDYWxsIFRyYWNlOgpbICAgIDIu
MDI5MzI2XSAgWzw0MTMzM2Q4ZD5dIGR1bXBfc3RhY2srMHgxNi8weDE4ClsgICAgMi4wMjkz
MjZdICBbPDQxMDIyNTI5Pl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg3MC8weDg3ClsgICAg
Mi4wMjkzMjZdICBbPDQxMWU1MmM1Pl0gPyBfX2xpc3RfYWRkKzB4NmMvMHhhZQpbICAgIDIu
MDI5MzI2XSAgWzw0MTFlNTJjNT5dID8gX19saXN0X2FkZCsweDZjLzB4YWUKWyAgICAyLjAy
OTMyNl0gIFs8NDEwMjI1NmU+XSB3YXJuX3Nsb3dwYXRoX2ZtdCsweDJlLzB4MzAKWyAgICAy
LjAyOTMyNl0gIFs8NDExZTUyYzU+XSBfX2xpc3RfYWRkKzB4NmMvMHhhZQpbICAgIDIuMDI5
MzI2XSAgWzw0MTAyYjhiYj5dIF9faW50ZXJuYWxfYWRkX3RpbWVyKzB4OGEvMHg4ZQpbICAg
IDIuMDI5MzI2XSAgWzw0MTAyYjhjZD5dIGludGVybmFsX2FkZF90aW1lcisweGUvMHgyNgpb
ICAgIDIuMDI5MzI2XSAgWzw0MTAyYzA0Yj5dIG1vZF90aW1lcisweGRjLzB4ZjgKWyAgICAy
LjAyOTMyNl0gIFs8NDEwMmMwNzk+XSBhZGRfdGltZXIrMHgxMi8weDE0ClsgICAgMi4wMjkz
MjZdICBbPDQxMDM0NjI4Pl0gX19xdWV1ZV9kZWxheWVkX3dvcmsrMHhkZS8weGY4ClsgICAg
Mi4wMjkzMjZdICBbPDQxMDM0Njg2Pl0gcXVldWVfZGVsYXllZF93b3JrX29uKzB4NDQvMHg3
NQpbICAgIDIuMDI5MzI2XSAgWzw0MTFkODdmMj5dIGtvYmplY3RfcmVsZWFzZSsweDc0LzB4
NzgKWyAgICAyLjAyOTMyNl0gIFs8NDExZDg4NDU+XSBrb2JqZWN0X3B1dCsweDRmLzB4NTUK
WyAgICAyLjAyOTMyNl0gIFs8NDEzMzg4OTQ+XSA/IF9yYXdfc3Bpbl91bmxvY2srMHgxZC8w
eDNkClsgICAgMi4wMjkzMjZdICBbPDQxMWQ4ODg3Pl0gPyBrb2JqX2tzZXRfbGVhdmUrMHgz
Yy8weDQwClsgICAgMi4wMjkzMjZdICBbPDQxMWQ4OGMxPl0ga29iamVjdF9kZWwrMHgyNS8w
eDJmClsgICAgMi4wMjkzMjZdICBbPDQxMjU4Njc4Pl0gZGV2aWNlX2RlbCsweDEyNy8weDEz
MwpbICAgIDIuMDI5MzI2XSAgWzw0MTI1ODY4Zj5dIGRldmljZV91bnJlZ2lzdGVyKzB4Yi8w
eDE1ClsgICAgMi4wMjkzMjZdICBbPDQxMjU4NmVjPl0gZGV2aWNlX2Rlc3Ryb3krMHgyZC8w
eDMyClsgICAgMi4wMjkzMjZdICBbPDQxMjU3OTllPl0gPyBjbGFzc19kaXJfY2hpbGRfbnNf
dHlwZSsweGUvMHhlClsgICAgMi4wMjkzMjZdICBbPDQxMjM2YjgzPl0gdHR5X3VucmVnaXN0
ZXJfZGV2aWNlKzB4MWYvMHgzNwpbICAgIDIuMDI5MzI2XSAgWzw0MTI0NDFhYz5dIHVhcnRf
cmVtb3ZlX29uZV9wb3J0KzB4YTEvMHhlYgpbICAgIDIuMDI5MzI2XSAgWzw0MTI0NWQ3Mz5d
IHNlcmlhbDgyNTBfcmVnaXN0ZXJfODI1MF9wb3J0KzB4YzEvMHgyMzUKWyAgICAyLjAyOTMy
Nl0gIFs8NDEyNDYwYTI+XSBzZXJpYWw4MjUwX3Byb2JlKzB4MTA4LzB4MTZhClsgICAgMi4w
MjkzMjZdICBbPDQxMDQxNTg2Pl0gPyBzY2hlZF9jbG9ja19jcHUrMHhkOC8weGVlClsgICAg
Mi4wMjkzMjZdICBbPDQxMjVjMjA0Pl0gcGxhdGZvcm1fZHJ2X3Byb2JlKzB4MjkvMHg0Ygpb
ICAgIDIuMDI5MzI2XSAgWzw0MTI1YWUzMT5dIGRyaXZlcl9wcm9iZV9kZXZpY2UrMHg4Zi8w
eDE5NApbICAgIDIuMDI5MzI2XSAgWzw0MTI1YzMyNj5dID8gcGxhdGZvcm1fbWF0Y2grMHg1
Mi8weDY2ClsgICAgMi4wMjkzMjZdICBbPDQxMjVhZjUyPl0gX19kZXZpY2VfYXR0YWNoKzB4
MWMvMHgyYwpbICAgIDIuMDI5MzI2XSAgWzw0MTI1OTk2OD5dIGJ1c19mb3JfZWFjaF9kcnYr
MHgzOC8weDZiClsgICAgMi4wMjkzMjZdICBbPDQxMjVhZDZkPl0gZGV2aWNlX2F0dGFjaCsw
eDY2LzB4ODMKWyAgICAyLjAyOTMyNl0gIFs8NDEyNWFmMzY+XSA/IGRyaXZlcl9wcm9iZV9k
ZXZpY2UrMHgxOTQvMHgxOTQKWyAgICAyLjAyOTMyNl0gIFs8NDEyNWE0ZTc+XSBidXNfcHJv
YmVfZGV2aWNlKzB4MjUvMHg4NApbICAgIDIuMDI5MzI2XSAgWzw0MTI1OGU2YT5dIGRldmlj
ZV9hZGQrMHgzZTYvMHg1N2IKWyAgICAyLjAyOTMyNl0gIFs8NDExZTA2ZjI+XSA/IGt2YXNw
cmludGYrMHgzYi8weDQ0ClsgICAgMi4wMjkzMjZdICBbPDQxMWQ4YzdmPl0gPyBrb2JqZWN0
X3NldF9uYW1lX3ZhcmdzKzB4M2QvMHg0YQpbICAgIDIuMDI5MzI2XSAgWzw0MTI1YzA2Nj5d
IHBsYXRmb3JtX2RldmljZV9hZGQrMHgxMzEvMHgxOTUKWyAgICAyLjAyOTMyNl0gIFs8NDEy
NWM1Mzk+XSBwbGF0Zm9ybV9kZXZpY2VfcmVnaXN0ZXIrMHgxYy8weDFmClsgICAgMi4wMjkz
MjZdICBbPDQxNjY0N2U1Pl0gPyBzZXR1cF9lYXJseV9zZXJpYWw4MjUwX2NvbnNvbGUrMHgz
NzUvMHgzNzUKWyAgICAyLjAyOTMyNl0gIFs8NDE2NjQ3ZjI+XSBhY2NlbnRfaW5pdCsweGQv
MHhmClsgICAgMi4wMjkzMjZdICBbPDQxMDAwM2RmPl0gZG9fb25lX2luaXRjYWxsKzB4N2Uv
MHgxMGMKWyAgICAyLjAyOTMyNl0gIFs8NDEwNTQ2ZTg+XSA/IGxvY2tfcmVsZWFzZV9ob2xk
dGltZSsweGJlLzB4YzQKWyAgICAyLjAyOTMyNl0gIFs8NDEwNTZiZGE+XSA/IHRyYWNlX2hh
cmRpcnFzX29uX2NhbGxlcisweDE0OS8weDE5YgpbICAgIDIuMDI5MzI2XSAgWzw0MTY0ODQw
MD5dID8gZG9fZWFybHlfcGFyYW0rMHg0Zi8weDdhClsgICAgMi4wMjkzMjZdICBbPDQxMDM3
ZmM3Pl0gPyBwYXJzZV9hcmdzKzB4MTY3LzB4MjJjClsgICAgMi4wMjkzMjZdICBbPDQxNjQ4
YTg5Pl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgxMTYvMHgxYjUKWyAgICAyLjAyOTMyNl0g
IFs8NDE2NDg0MmI+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4N2EvMHg3YQpbICAgIDIuMDI5MzI2
XSAgWzw0MTMyZTg5ZD5dIGtlcm5lbF9pbml0KzB4Yi8weGMzClsgICAgMi4wMjkzMjZdICBb
PDQxMzNjZWZiPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDFiLzB4MzAKWyAgICAyLjAy
OTMyNl0gIFs8NDEzMmU4OTI+XSA/IHJlc3RfaW5pdCsweGI1LzB4YjUKWyAgICAyLjAyOTMy
Nl0gLS0tWyBlbmQgdHJhY2UgYWI1MTQ4YjRlMzViNjE0MiBdLS0tCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWo1LTA4MjQxNTI1L2VhMWJiNzA2NGZkNjk3MmVmMDBhOTNiYTg4MmEyZjM4
NDUwYjI3M2UvZG1lc2cta3ZtLW5obTQtNTEyMC0yMDEzMDgyNTA2MTgzNC0zLjExLjAtcmMy
LTAwMDE0LWdlYTFiYjcwLTE0NQoKQmlzZWN0aW5nOiA2IHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbZTU2MzQxYWQzODAxMTQ0NTQxMTlh
YzA0M2U2ZDcxMGRkYmJiNzcxMF0gc3RhZ2luZzogY29tZWRpOiBjb252ZXJ0IGNsYXNzIGNv
ZGUgdG8gdXNlIGRldl9ncm91cHMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9tbW90bS9vYmotYmlzZWN0CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajUtMDgyNDE1MjUv
bmV4dDptYXN0ZXI6ZTU2MzQxYWQzODAxMTQ0NTQxMTlhYzA0M2U2ZDcxMGRkYmJiNzcxMDpi
aXNlY3QtbW1vdG0KCjIwMTMtMDgtMjUtMTQ6MjM6MzMgZTU2MzQxYWQzODAxMTQ0NTQxMTlh
YzA0M2U2ZDcxMGRkYmJiNzcxMCBjb21waWxpbmcKMTI2IHJlYWwgIDExNzMgdXNlciAgMTEx
IHN5cyAgMTAxOS44MSUgY3B1IAlpMzg2LXJhbmRjb25maWctajUtMDgyNDE1MjUKCjIwMTMt
MDgtMjUtMTQ6MjU6NTYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLXJjMi0wMDAwNy1n
ZTU2MzQxYS4uLi4uLi4JMQkyLgk1CTYuCTE0CTE2CTIzCTI4CTMyCTQzCTQ3CTU1Lgk1Ni4u
Li4uLi4uLgk1Nwk1OC4uLi4uLi4uLi4uLi4JNTkuLi4uLi4uLi4uLi4uLgk2MCBTVUNDRVNT
CgpCaXNlY3Rpbmc6IDMgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3Vn
aGx5IDIgc3RlcHMpCltjODE3YTY3ZWNiYTdjM2MyYWFhMTA0Nzk2ZDc4ZjE2MGFmNjA5MjBk
XSBrb2JqZWN0OiBkZWxheWVkIGtvYmplY3QgcmVsZWFzZTogaGVscCBmaW5kIGJ1Z2d5IGRy
aXZlcnMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9ob21lL3dmZy9tbW90bS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVu
LXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajUtMDgyNDE1MjUvbmV4dDptYXN0ZXI6Yzgx
N2E2N2VjYmE3YzNjMmFhYTEwNDc5NmQ3OGYxNjBhZjYwOTIwZDpiaXNlY3QtbW1vdG0KCjIw
MTMtMDgtMjUtMTQ6NTc6MjkgYzgxN2E2N2VjYmE3YzNjMmFhYTEwNDc5NmQ3OGYxNjBhZjYw
OTIwZCBjb21waWxpbmcKNjM3IHJlYWwgIDExODggdXNlciAgMTE2IHN5cyAgMjA0Ljc1JSBj
cHUgCWkzODYtcmFuZGNvbmZpZy1qNS0wODI0MTUyNQoKMjAxMy0wOC0yNS0xNTowODo1MyBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAtcmMyLTAwMDEwLWdjODE3YTY3LiBURVNUIEZB
SUxVUkUKWyAgICAyLjAwNjQ4MF0gV0FSTklORzogQ1BVOiAwIFBJRDogMSBhdCAvYy93Zmcv
bGludXgtbW1vdG0vbGliL2xpc3RfZGVidWcuYzozMyBfX2xpc3RfYWRkKzB4NmMvMHhhZSgp
ClsgICAgMi4wMDc4NjldIGxpc3RfYWRkIGNvcnJ1cHRpb24uIHByZXYtPm5leHQgc2hvdWxk
IGJlIG5leHQgKDQxNmQxMjQ4KSwgYnV0IHdhcyAgIChudWxsKS4gKHByZXY9NDZhMzIxMDAp
LgpbICAgIDIuMDA4MTA5XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAyLjAwODEwOV0gQ1BV
OiAwIFBJRDogMSBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTEuMC1yYzItMDAwMTAt
Z2M4MTdhNjcgIzE0NwpbICAgIDIuMDA4MTA5XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2No
cywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMi4wMDgxMDldICA0MDA0MWIwYyA0MDA0
MWIwYyA0MDA0MWFjYyA0MTMzM2Q4ZCA0MDA0MWFmYyA0MTAyMjUyOSA0MTQ2MGU2OCA0MDA0
MWIyOApbICAgIDIuMDA4MTA5XSAgMDAwMDAwMDEgNDE0NjBlNDQgMDAwMDAwMjEgNDExZTUy
YzUgNDExZTUyYzUgNDZhMzIxMDAgNDE2ZDEyNDggNDZhMmQ5YzgKWyAgICAyLjAwODEwOV0g
IDQwMDQxYjE0IDQxMDIyNTZlIDAwMDAwMDA5IDQwMDQxYjBjIDQxNDYwZTY4IDQwMDQxYjI4
IDQwMDQxYjQwIDQxMWU1MmM1ClsgICAgMi4wMDgxMDldIENhbGwgVHJhY2U6ClsgICAgMi4w
MDgxMDldICBbPDQxMzMzZDhkPl0gZHVtcF9zdGFjaysweDE2LzB4MTgKWyAgICAyLjAwODEw
OV0gIFs8NDEwMjI1Mjk+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDcwLzB4ODcKWyAgICAy
LjAwODEwOV0gIFs8NDExZTUyYzU+XSA/IF9fbGlzdF9hZGQrMHg2Yy8weGFlClsgICAgMi4w
MDgxMDldICBbPDQxMWU1MmM1Pl0gPyBfX2xpc3RfYWRkKzB4NmMvMHhhZQpbICAgIDIuMDA4
MTA5XSAgWzw0MTAyMjU2ZT5dIHdhcm5fc2xvd3BhdGhfZm10KzB4MmUvMHgzMApbICAgIDIu
MDA4MTA5XSAgWzw0MTFlNTJjNT5dIF9fbGlzdF9hZGQrMHg2Yy8weGFlClsgICAgMi4wMDgx
MDldICBbPDQxMDJiOGJiPl0gX19pbnRlcm5hbF9hZGRfdGltZXIrMHg4YS8weDhlClsgICAg
Mi4wMDgxMDldICBbPDQxMDJiOGNkPl0gaW50ZXJuYWxfYWRkX3RpbWVyKzB4ZS8weDI2Clsg
ICAgMi4wMDgxMDldICBbPDQxMDJjMDRiPl0gbW9kX3RpbWVyKzB4ZGMvMHhmOApbICAgIDIu
MDA4MTA5XSAgWzw0MTAyYzA3OT5dIGFkZF90aW1lcisweDEyLzB4MTQKWyAgICAyLjAwODEw
OV0gIFs8NDEwMzQ2Mjg+XSBfX3F1ZXVlX2RlbGF5ZWRfd29yaysweGRlLzB4ZjgKWyAgICAy
LjAwODEwOV0gIFs8NDEwMzQ2ODY+XSBxdWV1ZV9kZWxheWVkX3dvcmtfb24rMHg0NC8weDc1
ClsgICAgMi4wMDgxMDldICBbPDQxMWQ4N2YyPl0ga29iamVjdF9yZWxlYXNlKzB4NzQvMHg3
OApbICAgIDIuMDA4MTA5XSAgWzw0MTFkODg0NT5dIGtvYmplY3RfcHV0KzB4NGYvMHg1NQpb
ICAgIDIuMDA4MTA5XSAgWzw0MTMzODg5ND5dID8gX3Jhd19zcGluX3VubG9jaysweDFkLzB4
M2QKWyAgICAyLjAwODEwOV0gIFs8NDExZDg4ODc+XSA/IGtvYmpfa3NldF9sZWF2ZSsweDNj
LzB4NDAKWyAgICAyLjAwODEwOV0gIFs8NDExZDg4YzE+XSBrb2JqZWN0X2RlbCsweDI1LzB4
MmYKWyAgICAyLjAwODEwOV0gIFs8NDEyNTg2Nzg+XSBkZXZpY2VfZGVsKzB4MTI3LzB4MTMz
ClsgICAgMi4wMDgxMDldICBbPDQxMjU4NjhmPl0gZGV2aWNlX3VucmVnaXN0ZXIrMHhiLzB4
MTUKWyAgICAyLjAwODEwOV0gIFs8NDEyNTg2ZWM+XSBkZXZpY2VfZGVzdHJveSsweDJkLzB4
MzIKWyAgICAyLjAwODEwOV0gIFs8NDEyNTc5OWU+XSA/IGNsYXNzX2Rpcl9jaGlsZF9uc190
eXBlKzB4ZS8weGUKWyAgICAyLjAwODEwOV0gIFs8NDEyMzZiODM+XSB0dHlfdW5yZWdpc3Rl
cl9kZXZpY2UrMHgxZi8weDM3ClsgICAgMi4wMDgxMDldICBbPDQxMjQ0MWFjPl0gdWFydF9y
ZW1vdmVfb25lX3BvcnQrMHhhMS8weGViClsgICAgMi4wMDgxMDldICBbPDQxMjQ1ZDczPl0g
c2VyaWFsODI1MF9yZWdpc3Rlcl84MjUwX3BvcnQrMHhjMS8weDIzNQpbICAgIDIuMDA4MTA5
XSAgWzw0MTI0NjBhMj5dIHNlcmlhbDgyNTBfcHJvYmUrMHgxMDgvMHgxNmEKWyAgICAyLjAw
ODEwOV0gIFs8NDEwNDE1ODY+XSA/IHNjaGVkX2Nsb2NrX2NwdSsweGQ4LzB4ZWUKWyAgICAy
LjAwODEwOV0gIFs8NDEyNWMyMDQ+XSBwbGF0Zm9ybV9kcnZfcHJvYmUrMHgyOS8weDRiClsg
ICAgMi4wMDgxMDldICBbPDQxMjVhZTMxPl0gZHJpdmVyX3Byb2JlX2RldmljZSsweDhmLzB4
MTk0ClsgICAgMi4wMDgxMDldICBbPDQxMjVjMzI2Pl0gPyBwbGF0Zm9ybV9tYXRjaCsweDUy
LzB4NjYKWyAgICAyLjAwODEwOV0gIFs8NDEyNWFmNTI+XSBfX2RldmljZV9hdHRhY2grMHgx
Yy8weDJjClsgICAgMi4wMDgxMDldICBbPDQxMjU5OTY4Pl0gYnVzX2Zvcl9lYWNoX2Rydisw
eDM4LzB4NmIKWyAgICAyLjAwODEwOV0gIFs8NDEyNWFkNmQ+XSBkZXZpY2VfYXR0YWNoKzB4
NjYvMHg4MwpbICAgIDIuMDA4MTA5XSAgWzw0MTI1YWYzNj5dID8gZHJpdmVyX3Byb2JlX2Rl
dmljZSsweDE5NC8weDE5NApbICAgIDIuMDA4MTA5XSAgWzw0MTI1YTRlNz5dIGJ1c19wcm9i
ZV9kZXZpY2UrMHgyNS8weDg0ClsgICAgMi4wMDgxMDldICBbPDQxMjU4ZTZhPl0gZGV2aWNl
X2FkZCsweDNlNi8weDU3YgpbICAgIDIuMDA4MTA5XSAgWzw0MTFlMDZmMj5dID8ga3Zhc3By
aW50ZisweDNiLzB4NDQKWyAgICAyLjAwODEwOV0gIFs8NDExZDhjN2Y+XSA/IGtvYmplY3Rf
c2V0X25hbWVfdmFyZ3MrMHgzZC8weDRhClsgICAgMi4wMDgxMDldICBbPDQxMjVjMDY2Pl0g
cGxhdGZvcm1fZGV2aWNlX2FkZCsweDEzMS8weDE5NQpbICAgIDIuMDA4MTA5XSAgWzw0MTI1
YzUzOT5dIHBsYXRmb3JtX2RldmljZV9yZWdpc3RlcisweDFjLzB4MWYKWyAgICAyLjAwODEw
OV0gIFs8NDE2NjQ3ZTU+XSA/IHNldHVwX2Vhcmx5X3NlcmlhbDgyNTBfY29uc29sZSsweDM3
NS8weDM3NQpbICAgIDIuMDA4MTA5XSAgWzw0MTY2NDdmMj5dIGFjY2VudF9pbml0KzB4ZC8w
eGYKWyAgICAyLjAwODEwOV0gIFs8NDEwMDAzZGY+XSBkb19vbmVfaW5pdGNhbGwrMHg3ZS8w
eDEwYwpbICAgIDIuMDA4MTA5XSAgWzw0MTFkZjBjNT5dID8gc3RybGVuKzB4Yi8weDE3Clsg
ICAgMi4wMDgxMDldICBbPDQxNjQ4NDAwPl0gPyBkb19lYXJseV9wYXJhbSsweDRmLzB4N2EK
WyAgICAyLjAwODEwOV0gIFs8NDEwMzdmYzc+XSA/IHBhcnNlX2FyZ3MrMHgxNjcvMHgyMmMK
WyAgICAyLjAwODEwOV0gIFs8NDE2NDhhODk+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDEx
Ni8weDFiNQpbICAgIDIuMDA4MTA5XSAgWzw0MTY0ODQyYj5dID8gZG9fZWFybHlfcGFyYW0r
MHg3YS8weDdhClsgICAgMi4wMDgxMDldICBbPDQxMzJlODlkPl0ga2VybmVsX2luaXQrMHhi
LzB4YzMKWyAgICAyLjAwODEwOV0gIFs8NDEzM2NlZmI+XSByZXRfZnJvbV9rZXJuZWxfdGhy
ZWFkKzB4MWIvMHgzMApbICAgIDIuMDA4MTA5XSAgWzw0MTMyZTg5Mj5dID8gcmVzdF9pbml0
KzB4YjUvMHhiNQpbICAgIDIuMDA4MTA5XSAtLS1bIGVuZCB0cmFjZSBmNDAyMGRmYTg0ODQ1
Y2FmIF0tLS0KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajUtMDgyNDE1MjUvYzgxN2E2N2Vj
YmE3YzNjMmFhYTEwNDc5NmQ3OGYxNjBhZjYwOTIwZC9kbWVzZy1rdm0tYmVucy0zMTc0LTIw
MTMwODI1MTUwNTA1LTMuMTEuMC1yYzItMDAwMTAtZ2M4MTdhNjctMTQ3Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1L2M4MTdhNjdlY2JhN2MzYzJhYWExMDQ3OTZkNzhm
MTYwYWY2MDkyMGQvZG1lc2cta3ZtLWlubi0xMTY5MC0yMDEzMDgyNTE1MDg1OS0zLjExLjAt
cmMyLTAwMDEwLWdjODE3YTY3LTE0Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNS0wODI0
MTUyNS9jODE3YTY3ZWNiYTdjM2MyYWFhMTA0Nzk2ZDc4ZjE2MGFmNjA5MjBkL2RtZXNnLWt2
bS1pbm4tMTIwNzQtMjAxMzA4MjUxNTA5MDQtMy4xMS4wLXJjNi1uZXh0LTIwMTMwODIyLTA3
MDcwLWcyNDVmMDg2LTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajUtMDgyNDE1MjUvYzgx
N2E2N2VjYmE3YzNjMmFhYTEwNDc5NmQ3OGYxNjBhZjYwOTIwZC9kbWVzZy1rdm0taW5uLTkx
MDEtMjAxMzA4MjUxNTA5MDUtMy4xMS4wLXJjNi0wNDMxNi1nNGEyMjViNC0xODQKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctajUtMDgyNDE1MjUvYzgxN2E2N2VjYmE3YzNjMmFhYTEwNDc5
NmQ3OGYxNjBhZjYwOTIwZC9kbWVzZy1rdm0td2FpbWVhLTI3MjEyLTIwMTMwODI1MTUwOTE1
LTMuMTEuMC1yYzItMDAwMTAtZ2M4MTdhNjctMTQ3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWo1LTA4MjQxNTI1L2M4MTdhNjdlY2JhN2MzYzJhYWExMDQ3OTZkNzhmMTYwYWY2MDkyMGQv
ZG1lc2cta3ZtLWJlbnMtMzI3OC0yMDEzMDgyNTE1MDUxMC0zLjEwLjAtcmMzLTAwMDQ3LWdj
MjY1YTBkNS0xMjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajUtMDgyNDE1MjUvYzgxN2E2
N2VjYmE3YzNjMmFhYTEwNDc5NmQ3OGYxNjBhZjYwOTIwZC9kbWVzZy1rdm0tbmhtNC0xMDU1
Mi0yMDEzMDgyNTA3MDUxNi0zLjExLjAtcmMyLTAwMDEwLWdjODE3YTY3LTE0NwoKQmlzZWN0
aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0
ZXApCls3YzQyNzIxZmUwYzU4YTg0ODg0OWI0M2ZmNTU4Y2YyZmI4NmFhMzVhXSBjaGFyOiB0
aWxlLXNyb206IGZpeCBidWlsZCBlcnJvcgpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tb3RtL29iai1iaXNlY3QKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qNS0wODI0
MTUyNS9uZXh0Om1hc3Rlcjo3YzQyNzIxZmUwYzU4YTg0ODg0OWI0M2ZmNTU4Y2YyZmI4NmFh
MzVhOmJpc2VjdC1tbW90bQoKMjAxMy0wOC0yNS0xNTowOToyNiA3YzQyNzIxZmUwYzU4YTg0
ODg0OWI0M2ZmNTU4Y2YyZmI4NmFhMzVhIGNvbXBpbGluZwozMzcgcmVhbCAgMTE5MSB1c2Vy
ICAxMTMgc3lzICAzODYuODIlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1Cgoy
MDEzLTA4LTI1LTE1OjE2OjQzIGRldGVjdGluZyBib290IHN0YXRlIDMuMTEuMC1yYzItMDAw
MDktZzdjNDI3MjEuLgk0CTgJMTAJMTQJMTkJMjEJMjQJMjUJMjYJMzAuCTMzCTM0CTM2CTM4
Li4uCTQyLgk0Mwk0NC4uLi4uLi4JNDcJNTAuLi4uCTUxLi4uLgk1Mi4uCTUzLgk1Ngk1Nwk1
OC4JNjAgU1VDQ0VTUwoKYzgxN2E2N2VjYmE3YzNjMmFhYTEwNDc5NmQ3OGYxNjBhZjYwOTIw
ZCBpcyB0aGUgZmlyc3QgYmFkIGNvbW1pdApjb21taXQgYzgxN2E2N2VjYmE3YzNjMmFhYTEw
NDc5NmQ3OGYxNjBhZjYwOTIwZApBdXRob3I6IFJ1c3NlbGwgS2luZyA8cm1rK2tlcm5lbEBh
cm0ubGludXgub3JnLnVrPgpEYXRlOiAgIFRodSBKdW4gMjcgMTU6MDY6MTQgMjAxMyArMDEw
MAoKICAgIGtvYmplY3Q6IGRlbGF5ZWQga29iamVjdCByZWxlYXNlOiBoZWxwIGZpbmQgYnVn
Z3kgZHJpdmVycwogICAgCiAgICBJbXBsZW1lbnQgZGVidWdnaW5nIGZvciBrb2JqZWN0IHJl
bGVhc2UgZnVuY3Rpb25zLiAga29iamVjdHMgYXJlCiAgICByZWZlcmVuY2UgY291bnRlZCwg
c28gdGhlIGRyb3Agb2YgdGhlIGxhc3QgcmVmZXJlbmNlIHRvIHRoZW0gaXMgbm90CiAgICBw
cmVkaWN0YWJsZS4gSG93ZXZlciwgdGhlIGNvbW1vbiBjYXNlIGlzIGZvciB0aGUgbGFzdCBy
ZWZlcmVuY2UgdG8gYmUKICAgIHRoZSBrb2JqZWN0J3MgcmVtb3ZhbCBmcm9tIGEgc3Vic3lz
dGVtLCB3aGljaCByZXN1bHRzIGluIHRoZSByZWxlYXNlCiAgICBmdW5jdGlvbiBiZWluZyBp
bW1lZGlhdGVseSBjYWxsZWQuCiAgICAKICAgIFRoaXMgY2FuIGhpZGUgc3VidGxlIGJ1Z3Ms
IHdoaWNoIGNhbiBvY2N1ciB3aGVuIGFub3RoZXIgdGhyZWFkIGhvbGRzIGEKICAgIHJlZmVy
ZW5jZSB0byB0aGUga29iamVjdCBhdCB0aGUgc2FtZSB0aW1lIHRoYXQgYSBrb2JqZWN0IGlz
IHJlbW92ZWQuCiAgICBUaGlzIHJlc3VsdHMgaW4gdGhlIHJlbGVhc2UgbWV0aG9kIGJlaW5n
IGRlbGF5ZWQuCiAgICAKICAgIEluIG9yZGVyIHRvIG1ha2UgdGhlc2Uga2luZHMgb2YgcHJv
YmxlbXMgbW9yZSB2aXNpYmxlLCB0aGUgZm9sbG93aW5nCiAgICBwYXRjaCBpbXBsZW1lbnRz
IGEgZGVsYXllZCByZWxlYXNlOyB0aGlzIGhhcyB0aGUgZWZmZWN0IHRoYXQgdGhlCiAgICBy
ZWxlYXNlIGZ1bmN0aW9uIHdpbGwgYmUgb3V0IG9mIG9yZGVyIHdpdGggcmVzcGVjdCB0byB0
aGUgcmVtb3ZhbCBvZgogICAgdGhlIGtvYmplY3QgaW4gdGhlIHNhbWUgbWFubmVyIHRoYXQg
aXQgd291bGQgYmUgaWYgYSByZWZlcmVuY2Ugd2FzCiAgICBiZWluZyBoZWxkLgogICAgCiAg
ICBUaGlzIHByb3ZpZGVzIHVzIHdpdGggYW4gZWFzeSB3YXkgdG8gYWxsb3cgZHJpdmVyIHdy
aXRlcnMgdG8gZGVidWcKICAgIHRoZWlyIGRyaXZlcnMgYW5kIGZpeCBvdGhlcndpc2UgaGlk
ZGVuIHByb2JsZW1zLgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBSdXNzZWxsIEtpbmcgPHJt
aytrZXJuZWxAYXJtLmxpbnV4Lm9yZy51az4KICAgIFNpZ25lZC1vZmYtYnk6IEdyZWcgS3Jv
YWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+Cgo6MDQwMDAwIDA0MDAw
MCBmNmMyM2VmYTEwMmZjMmMyZWFkNWM4NmJkYjY1YWE3MDcxOWIxYWI5IDA0OTg1OWZhN2Ez
YTk1Mzg5MjEyNzQ2N2JhYmJmMDJmNjZhNjliNzYgTQlpbmNsdWRlCjowNDAwMDAgMDQwMDAw
IGE0MWQyMDY2OWYwZjYyNGQyY2U5Y2E3ZTZhNWY5NmU0ZjkxNDMyZTAgYmYyMTY4MTk0Zjgy
OTExY2YyZTE4OTJkODJmMGMxM2QwMGM3NzJhZSBNCWxpYgpiaXNlY3QgcnVuIHN1Y2Nlc3MK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qNS0w
ODI0MTUyNS9uZXh0Om1hc3Rlcjo3YzQyNzIxZmUwYzU4YTg0ODg0OWI0M2ZmNTU4Y2YyZmI4
NmFhMzVhOmJpc2VjdC1tbW90bQoKMjAxMy0wOC0yNS0xNTo0Mjo0NyA3YzQyNzIxZmUwYzU4
YTg0ODg0OWI0M2ZmNTU4Y2YyZmI4NmFhMzVhIHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWo1LTA4MjQxNTI1LzdjNDI3MjFmZTBjNThhODQ4ODQ5YjQzZmY1NThjZjJmYjg2YWEz
NWEvdm1saW51ei0zLjExLjAtcmMyLTAwMDA5LWc3YzQyNzIxCgoyMDEzLTA4LTI1LTE1OjQy
OjQ3IGRldGVjdGluZyBib290IHN0YXRlIC4uLi4JNjEuCTYyLgk2Mwk2Ny4uLgk2OC4uCTY5
Li4JNzAJNzIJNzYJNzkuCTg1CTkzCTk2CTEwMQkxMDUJMTExCTEyMwkxMzUJMTQ4CTE1NQkx
NjYJMTcwLi4uCTE3MS4JMTc2CTE3OC4uLgkxNzkuLi4uLi4uLi4uCTE4MCBTVUNDRVNTCgps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWo1LTA4
MjQxNTI1L25leHQ6bWFzdGVyOjI0NWYwODY5OWQ1MzIwZjAyMTA3MGVkODY5OGFjODllYmYy
ZjA2NzA6YmlzZWN0LW1tb3RtCiBURVNUIEZBSUxVUkUKWyAgIDUwLjUxOTM4MV0gV0FSTklO
RzogQ1BVOiAwIFBJRDogMSBhdCBsaWIvZGVidWdvYmplY3RzLmM6MjYwIGRlYnVnX3ByaW50
X29iamVjdCsweDc2LzB4ODQoKQpbICAgNTAuNTE5MzgxXSBPREVCVUc6IGluaXQgYWN0aXZl
IChhY3RpdmUgc3RhdGUgMCkgb2JqZWN0IHR5cGU6IHRpbWVyX2xpc3QgaGludDogICAobnVs
bCkKWyAgIDUwLjUxOTM4MV0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICA1MC41MTkzODFdIENQ
VTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjExLjAtcmM2LW5leHQt
MjAxMzA4MjItMDcwNzAtZzI0NWYwODYgIzEKWyAgIDUwLjUxOTM4MV0gSGFyZHdhcmUgbmFt
ZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgNTAuNTE5MzgxXSAg
NDAwNDFiNjggNDAwNDFiNjggNDAwNDFiMjggNDEzNDA4MTcgNDAwNDFiNTggNDEwMjI5NDkg
NDE0NzNhZjYgNDAwNDFiODQKWyAgIDUwLjUxOTM4MV0gIDAwMDAwMDAxIDQxNDczYjMzIDAw
MDAwMTA0IDQxMWU4NGQ3IDQxMWU4NGQ3IDQwMDg1Njk4IDQxNGUxZjE0IDQxNDUxNjQ3Clsg
ICA1MC41MTkzODFdICA0MDA0MWI3MCA0MTAyMjk4ZSAwMDAwMDAwOSA0MDA0MWI2OCA0MTQ3
M2FmNiA0MDA0MWI4NCA0MDA0MWJhNCA0MTFlODRkNwpbICAgNTAuNTE5MzgxXSBDYWxsIFRy
YWNlOgpbICAgNTAuNTE5MzgxXSAgWzw0MTM0MDgxNz5dIGR1bXBfc3RhY2srMHgxNi8weDE4
ClsgICA1MC41MTkzODFdICBbPDQxMDIyOTQ5Pl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg3
MC8weDg3ClsgICA1MC41MTkzODFdICBbPDQxMWU4NGQ3Pl0gPyBkZWJ1Z19wcmludF9vYmpl
Y3QrMHg3Ni8weDg0ClsgICA1MC41MTkzODFdICBbPDQxMWU4NGQ3Pl0gPyBkZWJ1Z19wcmlu
dF9vYmplY3QrMHg3Ni8weDg0ClsgICA1MC41MTkzODFdICBbPDQxMDIyOThlPl0gd2Fybl9z
bG93cGF0aF9mbXQrMHgyZS8weDMwClsgICA1MC41MTkzODFdICBbPDQxMWU4NGQ3Pl0gZGVi
dWdfcHJpbnRfb2JqZWN0KzB4NzYvMHg4NApbICAgNTAuNTE5MzgxXSAgWzw0MTFlODc2Mj5d
IF9fZGVidWdfb2JqZWN0X2luaXQrMHgyN2QvMHgyYmIKWyAgIDUwLjUxOTM4MV0gIFs8NDEx
ZTg5YzY+XSBkZWJ1Z19vYmplY3RfaW5pdCsweDEzLzB4MTUKWyAgIDUwLjUxOTM4MV0gIFs8
NDEwMjkyNWU+XSBpbml0X3RpbWVyX2tleSsweDE3LzB4NjQKWyAgIDUwLjUxOTM4MV0gIFs8
NDExZGI0YTU+XSBrb2JqZWN0X3JlbGVhc2UrMHg1MC8weDc4ClsgICA1MC41MTkzODFdICBb
PDQxMWRiNTFjPl0ga29iamVjdF9wdXQrMHg0Zi8weDU1ClsgICA1MC41MTkzODFdICBbPDQx
MGFkNWJjPl0gY2Rldl9kZWwrMHgyMy8weDI2ClsgICA1MC41MTkzODFdICBbPDQxMjM5ZmI1
Pl0gdHR5X3VucmVnaXN0ZXJfZGV2aWNlKzB4MzMvMHgzNwpbICAgNTAuNTE5MzgxXSAgWzw0
MTI0NzQzOT5dIHVhcnRfcmVtb3ZlX29uZV9wb3J0KzB4YTEvMHhlZQpbICAgNTAuNTE5Mzgx
XSAgWzw0MTI0OTAyNT5dIHNlcmlhbDgyNTBfcmVnaXN0ZXJfODI1MF9wb3J0KzB4YzEvMHgy
MzUKWyAgIDUwLjUxOTM4MV0gIFs8NDEyNDkzNTQ+XSBzZXJpYWw4MjUwX3Byb2JlKzB4MTA4
LzB4MTZhClsgICA1MC41MTkzODFdICBbPDQxMDNmMTlhPl0gPyBzY2hlZF9jbG9ja19jcHUr
MHhkOC8weGVlClsgICA1MC41MTkzODFdICBbPDQxMDNmMTlhPl0gPyBzY2hlZF9jbG9ja19j
cHUrMHhkOC8weGVlClsgICA1MC41MTkzODFdICBbPDQxMjVmNjRhPl0gcGxhdGZvcm1fZHJ2
X3Byb2JlKzB4MjkvMHg0YgpbICAgNTAuNTE5MzgxXSAgWzw0MTI1ZTI0Mj5dIGRyaXZlcl9w
cm9iZV9kZXZpY2UrMHg4Zi8weDE5NApbICAgNTAuNTE5MzgxXSAgWzw0MTI1Zjc2Yz5dID8g
cGxhdGZvcm1fbWF0Y2grMHg1Mi8weDY2ClsgICA1MC41MTkzODFdICBbPDQxMjVlMzYzPl0g
X19kZXZpY2VfYXR0YWNoKzB4MWMvMHgyYwpbICAgNTAuNTE5MzgxXSAgWzw0MTI1Y2NiMj5d
IGJ1c19mb3JfZWFjaF9kcnYrMHgzOC8weDZiClsgICA1MC41MTkzODFdICBbPDQxMjVlMTdl
Pl0gZGV2aWNlX2F0dGFjaCsweDY2LzB4ODMKWyAgIDUwLjUxOTM4MV0gIFs8NDEyNWUzNDc+
XSA/IGRyaXZlcl9wcm9iZV9kZXZpY2UrMHgxOTQvMHgxOTQKWyAgIDUwLjUxOTM4MV0gIFs8
NDEyNWQ4YWY+XSBidXNfcHJvYmVfZGV2aWNlKzB4MjUvMHg4NApbICAgNTAuNTE5MzgxXSAg
Wzw0MTI1YzE4Yj5dIGRldmljZV9hZGQrMHgzZTYvMHg1N2IKWyAgIDUwLjUxOTM4MV0gIFs8
NDExZTM1Yjk+XSA/IGt2YXNwcmludGYrMHgzYi8weDQ0ClsgICA1MC41MTkzODFdICBbPDQx
MWRiOTU2Pl0gPyBrb2JqZWN0X3NldF9uYW1lX3ZhcmdzKzB4M2QvMHg0YQpbICAgNTAuNTE5
MzgxXSAgWzw0MTI1ZjRhYz5dIHBsYXRmb3JtX2RldmljZV9hZGQrMHgxMzEvMHgxOTUKWyAg
IDUwLjUxOTM4MV0gIFs8NDEyNWY5N2Y+XSBwbGF0Zm9ybV9kZXZpY2VfcmVnaXN0ZXIrMHgx
Yy8weDFmClsgICA1MC41MTkzODFdICBbPDQxNjc3YmI4Pl0gPyBzZXR1cF9lYXJseV9zZXJp
YWw4MjUwX2NvbnNvbGUrMHgzNzYvMHgzNzYKWyAgIDUwLjUxOTM4MV0gIFs8NDE2NzdiYzU+
XSBhY2NlbnRfaW5pdCsweGQvMHhmClsgICA1MC41MTkzODFdICBbPDQxMDAwM2RmPl0gZG9f
b25lX2luaXRjYWxsKzB4N2UvMHgxMGMKWyAgIDUwLjUxOTM4MV0gIFs8NDE2NWI0MDA+XSA/
IGRvX2Vhcmx5X3BhcmFtKzB4NGYvMHg3YQpbICAgNTAuNTE5MzgxXSAgWzw0MTAzNWJjZD5d
ID8gcGFyc2VfYXJncysweDE1ZC8weDIyMgpbICAgNTAuNTE5MzgxXSAgWzw0MTY1YmE4OT5d
IGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MTE2LzB4MWI1ClsgICA1MC41MTkzODFdICBbPDQx
NjViNDJiPl0gPyBkb19lYXJseV9wYXJhbSsweDdhLzB4N2EKWyAgIDUwLjUxOTM4MV0gIFs8
NDEzM2IzYjQ+XSBrZXJuZWxfaW5pdCsweGIvMHhjMwpbICAgNTAuNTE5MzgxXSAgWzw0MTM0
OTliYj5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDMwClsgICA1MC41MTkzODFd
ICBbPDQxMzNiM2E5Pl0gPyByZXN0X2luaXQrMHhiNS8weGI1ClsgICA1MC41MTkzODFdIC0t
LVsgZW5kIHRyYWNlIGI4MWZjMTY0OTFmMzA5Y2UgXS0tLQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1qNS0wODI0MTUyNS8yNDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYw
NjcwL2RtZXNnLWt2bS1hbnQtNjA0My0yMDEzMDgyNDE2MDQzOC0zLjExLjAtcmM2LW5leHQt
MjAxMzA4MjItMDcwNzAtZzI0NWYwODYtMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNS0w
ODI0MTUyNS8yNDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNn
LWt2bS1iZW5zLTM3MDYtMjAxMzA4MjQxNjA1NTYtMy4xMS4wLXJjNi1uZXh0LTIwMTMwODIy
LTA3MDcwLWcyNDVmMDg2LTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajUtMDgyNDE1MjUv
MjQ1ZjA4Njk5ZDUzMjBmMDIxMDcwZWQ4Njk4YWM4OWViZjJmMDY3MC9kbWVzZy1rdm0tYmVu
cy00MDQwLTIwMTMwODI0MTYwOTE1LTMuMTEuMC1yYzItMDAwMDUtZzg5OTgyNmYtMzUyCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1LzI0NWYwODY5OWQ1MzIwZjAyMTA3
MGVkODY5OGFjODllYmYyZjA2NzAvZG1lc2cta3ZtLWlubi0xMDA1Mi0yMDEzMDgyNTEwMTkx
MS0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjItMDcwNzAtZzI0NWYwODYtMQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1qNS0wODI0MTUyNS8yNDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2OThh
Yzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS1pbm4tMTAxMTUtMjAxMzA4MjUxMDIwNTEtMy4xMS4w
LXJjMy0wMDk3MS1nNWNkOWJiNS0yMAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNS0wODI0
MTUyNS8yNDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2
bS1pbm4tMTAxMTUtMjAxMzA4MjUxMDI0NTItMy4xMS4wLXJjMy0wMDk3MS1nNWNkOWJiNS0y
MAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNS0wODI0MTUyNS8yNDVmMDg2OTlkNTMyMGYw
MjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS1pbm4tMTA1NTYtMjAxMzA4MjUx
MDIyMDMtMy4xMC4wLXJjMS0wMzM0NC1nMTliMmE4OC0zMQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1qNS0wODI0MTUyNS8yNDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYw
NjcwL2RtZXNnLWt2bS1pbm4tMTA4NzEtMjAxMzA4MjUxMDI0MTItMy4xMS4wLXJjMS0wMDA5
OC1nMDA1NzRkYS0xNwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNS0wODI0MTUyNS8yNDVm
MDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS1pbm4tMTE1
NjQtMjAxMzA4MjUxMDE3NTYtMy4xMS4wLXJjNi1uZXh0LTIwMTMwODIyLTA3MDcwLWcyNDVm
MDg2LTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajUtMDgyNDE1MjUvMjQ1ZjA4Njk5ZDUz
MjBmMDIxMDcwZWQ4Njk4YWM4OWViZjJmMDY3MC9kbWVzZy1rdm0taW5uLTExOTQyLTIwMTMw
ODI1MTAyMTM1LTMuMTEuMC1yYzYtbmV4dC0yMDEzMDgyMi0wNzA3MC1nMjQ1ZjA4Ni0xCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1LzI0NWYwODY5OWQ1MzIwZjAyMTA3
MGVkODY5OGFjODllYmYyZjA2NzAvZG1lc2cta3ZtLWlubi02MjYyLTIwMTMwODI1MTAzNjA5
LTMuMTEuMC1yYzMtMDA5NzEtZzVjZDliYjUtMjAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
ajUtMDgyNDE1MjUvMjQ1ZjA4Njk5ZDUzMjBmMDIxMDcwZWQ4Njk4YWM4OWViZjJmMDY3MC9k
bWVzZy1rdm0taW5uLTYzMjUtMjAxMzA4MjUxMDE4MDItMy4xMS4wLXJjNi13bC02ODUyOC1n
ODVhN2QwZC0yMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNS0wODI0MTUyNS8yNDVmMDg2
OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS1pbm4tNjgzMy0y
MDEzMDgyNTEwNDAxMS0zLjExLjAtcmM2LXdsLTY4NTI4LWc4NWE3ZDBkLTIxCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1LzI0NWYwODY5OWQ1MzIwZjAyMTA3MGVkODY5
OGFjODllYmYyZjA2NzAvZG1lc2cta3ZtLWlubi03MjExLTIwMTMwODI1MTAyMTAyLTMuMTEu
MC1yYzYtd2wtNjg1MjgtZzg1YTdkMGQtMTgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajUt
MDgyNDE1MjUvMjQ1ZjA4Njk5ZDUzMjBmMDIxMDcwZWQ4Njk4YWM4OWViZjJmMDY3MC9kbWVz
Zy1rdm0taW5uLTgxNTYtMjAxMzA4MjUxMDI0NTEtMy4xMS4wLXJjMy0wMDk3MS1nNWNkOWJi
NS00NjcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajUtMDgyNDE1MjUvMjQ1ZjA4Njk5ZDUz
MjBmMDIxMDcwZWQ4Njk4YWM4OWViZjJmMDY3MC9kbWVzZy1rdm0taW5uLTkxMDEtMjAxMzA4
MjUxMDM4MDQtMy4xMS4wLXJjMy0wMDk3MS1nNWNkOWJiNS00NjcKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctajUtMDgyNDE1MjUvMjQ1ZjA4Njk5ZDUzMjBmMDIxMDcwZWQ4Njk4YWM4OWVi
ZjJmMDY3MC9kbWVzZy1rdm0taW5uLTkzNTMtMjAxMzA4MjUxMDIwMzEtMy4xMS4wLXJjNi1u
ZXh0LTIwMTMwODIyLTA3MDcwLWcyNDVmMDg2LTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
ajUtMDgyNDE1MjUvMjQ1ZjA4Njk5ZDUzMjBmMDIxMDcwZWQ4Njk4YWM4OWViZjJmMDY3MC9k
bWVzZy1rdm0tbmhtNC0xNTI5Mi0yMDEzMDgyNTAyMzYxNS0zLjExLjAtcmM2LW5leHQtMjAx
MzA4MjItMDcwNzAtZzI0NWYwODYtMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNS0wODI0
MTUyNS8yNDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2
bS1uaG00LTcwMTUtMjAxMzA4MjUwMjEwMzMtMy4xMS4wLXJjNi1uZXh0LTIwMTMwODIyLTA3
MDcwLWcyNDVmMDg2LTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajUtMDgyNDE1MjUvMjQ1
ZjA4Njk5ZDUzMjBmMDIxMDcwZWQ4Njk4YWM4OWViZjJmMDY3MC9kbWVzZy1rdm0tbmhtNC04
MTUzLTIwMTMwODI1MDIzMDI3LTMuMTEuMC1yYzMtMDA5NzEtZzVjZDliYjUtNDcwCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1LzI0NWYwODY5OWQ1MzIwZjAyMTA3MGVk
ODY5OGFjODllYmYyZjA2NzAvZG1lc2cta3ZtLXdhaW1lYS0yMTI5Mi0yMDEzMDgyNTEwMjQz
OC0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjItMDcwNzAtZzI0NWYwODYtMQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1qNS0wODI0MTUyNS8yNDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2OThh
Yzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS13YWltZWEtMzY0Ny0yMDEzMDgyNDE1NTc1OS0zLjEx
LjAtcmM2LW5leHQtMjAxMzA4MjItMDcwNzAtZzI0NWYwODYtMQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1qNS0wODI0MTUyNS8yNDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJm
MmYwNjcwL2RtZXNnLWt2bS13YWltZWEtNDQ4Ny0yMDEzMDgyNDE1NTU1Ni0zLjExLjAtcmM2
LW5leHQtMjAxMzA4MjItMDcwNzAtZzI0NWYwODYtMQova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1qNS0wODI0MTUyNS8yNDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcw
L2RtZXNnLWt2bS13YWltZWEtNDc2MC0yMDEzMDgyNTEwMDQ0NS0zLjExLjAtcmM2LW5leHQt
MjAxMzA4MjItMDcwNzAtZzI0NWYwODYtMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNS0w
ODI0MTUyNS8yNDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNn
LWt2bS13YWltZWEtNzA5Ni0yMDEzMDgyNDE1NTYxMS0zLjExLjAtcmM2LTAwMjA4LWdmZWJh
MjlkLTY1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1LzI0NWYwODY5OWQ1
MzIwZjAyMTA3MGVkODY5OGFjODllYmYyZjA2NzAvZG1lc2cta3ZtLXdhaW1lYS03MzEyLTIw
MTMwODI0MTU1NzM2LTMuMTEuMC1yYzYtbmV4dC0yMDEzMDgyMi0wNzA3MC1nMjQ1ZjA4Ni0x
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1LzI0NWYwODY5OWQ1MzIwZjAy
MTA3MGVkODY5OGFjODllYmYyZjA2NzAvZG1lc2cta3ZtLXdhaW1lYS04ODU1LTIwMTMwODI1
MDk1MTQxLTMuMTEuMC1yYzYtbmV4dC0yMDEzMDgyMi0wNzA3MC1nMjQ1ZjA4Ni0xCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1LzI0NWYwODY5OWQ1MzIwZjAyMTA3MGVk
ODY5OGFjODllYmYyZjA2NzAvZG1lc2cta3ZtLXdhaW1lYS04ODczLTIwMTMwODI0MTU1MDIw
LTMuMTEuMC1yYzYtbmV4dC0yMDEzMDgyMi0wNzA3MC1nMjQ1ZjA4Ni0xCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1LzI0NWYwODY5OWQ1MzIwZjAyMTA3MGVkODY5OGFj
ODllYmYyZjA2NzAvZG1lc2cta3ZtLXdhaW1lYS05OTczLTIwMTMwODI0MTU1ODI3LTMuMTEu
MC1yYzYtbmV4dC0yMDEzMDgyMi0wNzA3MC1nMjQ1ZjA4Ni0xCgpbZGV0YWNoZWQgSEVBRCBj
YWM3NzhjXSBSZXZlcnQgImtvYmplY3Q6IGRlbGF5ZWQga29iamVjdCByZWxlYXNlOiBoZWxw
IGZpbmQgYnVnZ3kgZHJpdmVycyIKIDMgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCsp
LCA0MiBkZWxldGlvbnMoLSkKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kz
ODYtcmFuZGNvbmZpZy1qNS0wODI0MTUyNS9uZXh0Om1hc3RlcjpjYWM3NzhjNzEyNGQ2NWJm
N2UzY2YyN2IxMTdhMTI4N2YyMDJjYWMyOmJpc2VjdC1tbW90bQoKMjAxMy0wOC0yNS0xNjox
MTo1OSBjYWM3NzhjNzEyNGQ2NWJmN2UzY2YyN2IxMTdhMTI4N2YyMDJjYWMyIGNvbXBpbGlu
ZwoKMjAxMy0wOC0yNS0xNjoxNzowOCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjExLjAtcmM2
LW5leHQtMjAxMzA4MjItMDcwNzEtZ2NhYzc3OGMuLi4uLi4uLgkxLi4uLi4uLi4uLi4uLi4u
CTIuCTcJOQkxMgkxNC4JMTYJMTcJMjAJMjIJMjQuLgkyNgkyNwkyOC4uCTI5Li4uLgkzMC4J
MzEJMzMuCTM0CTM1Li4uCTM2LgkzNy4uLi4uCTM4CTM5Li4uLi4uCTQwLi4uLi4uCTQxLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTQyLi4JNDMuLi4uLi4JNDQJNDUuLi4uLi4uLgk0
Ni4uLi4JNDcuLi4uLi4JNDguLgk0OQk1MC4uLgk1MS4uLi4uCTUzLi4JNTQuLgk1NQk1Ny4J
NTgJNjAJNjEuCTYyCTY0CTY1Lgk2OAk2OS4JNzEuCTcyCTc0Lgk3NS4JNzYJNzkJODAJODEJ
ODIJODMuLgk4NAk4NS4uCTg3Lgk4OC4uCTkxCTkyCTk0Li4JOTYJOTcJOTguCTEwMQkxMDIu
CTEwNi4JMTA4Li4uCTExMC4JMTExCTExMi4uLgkxMTUuLi4JMTE2CTExNwkxMTgJMTIwCTEy
MS4uCTEyNAkxMjUuLgkxMjcJMTMzCTEzNi4JMTM5CTE1MwkxNjcJMTc0Li4uCTE3NS4uCTE3
NwkxNzguCTE3OS4JMTgwIFNVQ0NFU1MKCgo9PT09PT09PT0gdXBzdHJlYW0gPT09PT09PT09
CkZldGNoaW5nIGxpbnVzCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWctajUtMDgyNDE1MjUvbmV4dDptYXN0ZXI6ODQ5NWU5YzRhOTYxNmM5ZDE5
ZjIzMTgyZDA1MzY0ODU5MDIyNTlkYjpiaXNlY3QtbW1vdG0KCjIwMTMtMDgtMjUtMTg6MjY6
NDkgODQ5NWU5YzRhOTYxNmM5ZDE5ZjIzMTgyZDA1MzY0ODU5MDIyNTlkYiBjb21waWxpbmcK
CjIwMTMtMDgtMjUtMTg6MzI6NTggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLXJjNi0w
MDE0OC1nODQ5NWU5Yy4uLgkxLgkyLgkzLi4uLgk0Li4uLgk2Li4uLgk4CTkJMTAuLgkxMS4u
CTEyCTEzLi4uLi4JMTUJMTYJMTguCTE5CTIxCTI0CTI3CTI5CTMyCTM1CTM3CTQwCTQxCTQz
CTQ0CTQ1CTQ2Lgk0Ny4JNDgJNDkJNTAJNTEJNTQuCTU1Lgk2Mwk2OQk3NQk3OAk4Mwk4Ngk4
OS4JMTAxCTEwNAkxMDYJMTExLi4JMTE3CTEyNQkxNDAJMTQ2CTE0OQkxNTQJMTYyLgkxNjUu
LgkxNjYJMTY4CTE2OQkxNzEuLgkxNzIJMTczLi4uLi4uLi4uCTE3NwkxNzguLi4uLi4uLgkx
NzkuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1bWFkZF90b19ydW5fcXVl
dWUgMRtbMG0KLi4uLgkxODAgU1VDQ0VTUwoKCj09PT09PT09PSBsaW51eC1uZXh0ID09PT09
PT09PQpGZXRjaGluZyBuZXh0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9p
Mzg2LXJhbmRjb25maWctajUtMDgyNDE1MjUvbmV4dDptYXN0ZXI6MjQ1ZjA4Njk5ZDUzMjBm
MDIxMDcwZWQ4Njk4YWM4OWViZjJmMDY3MDpiaXNlY3QtbW1vdG0KIFRFU1QgRkFJTFVSRQpb
ICAgNTAuNTE5MzgxXSBXQVJOSU5HOiBDUFU6IDAgUElEOiAxIGF0IGxpYi9kZWJ1Z29iamVj
dHMuYzoyNjAgZGVidWdfcHJpbnRfb2JqZWN0KzB4NzYvMHg4NCgpClsgICA1MC41MTkzODFd
IE9ERUJVRzogaW5pdCBhY3RpdmUgKGFjdGl2ZSBzdGF0ZSAwKSBvYmplY3QgdHlwZTogdGlt
ZXJfbGlzdCBoaW50OiAgIChudWxsKQpbICAgNTAuNTE5MzgxXSBNb2R1bGVzIGxpbmtlZCBp
bjoKWyAgIDUwLjUxOTM4MV0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyIE5vdCB0YWlu
dGVkIDMuMTEuMC1yYzYtbmV4dC0yMDEzMDgyMi0wNzA3MC1nMjQ1ZjA4NiAjMQpbICAgNTAu
NTE5MzgxXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8y
MDExClsgICA1MC41MTkzODFdICA0MDA0MWI2OCA0MDA0MWI2OCA0MDA0MWIyOCA0MTM0MDgx
NyA0MDA0MWI1OCA0MTAyMjk0OSA0MTQ3M2FmNiA0MDA0MWI4NApbICAgNTAuNTE5MzgxXSAg
MDAwMDAwMDEgNDE0NzNiMzMgMDAwMDAxMDQgNDExZTg0ZDcgNDExZTg0ZDcgNDAwODU2OTgg
NDE0ZTFmMTQgNDE0NTE2NDcKWyAgIDUwLjUxOTM4MV0gIDQwMDQxYjcwIDQxMDIyOThlIDAw
MDAwMDA5IDQwMDQxYjY4IDQxNDczYWY2IDQwMDQxYjg0IDQwMDQxYmE0IDQxMWU4NGQ3Clsg
ICA1MC41MTkzODFdIENhbGwgVHJhY2U6ClsgICA1MC41MTkzODFdICBbPDQxMzQwODE3Pl0g
ZHVtcF9zdGFjaysweDE2LzB4MTgKWyAgIDUwLjUxOTM4MV0gIFs8NDEwMjI5NDk+XSB3YXJu
X3Nsb3dwYXRoX2NvbW1vbisweDcwLzB4ODcKWyAgIDUwLjUxOTM4MV0gIFs8NDExZTg0ZDc+
XSA/IGRlYnVnX3ByaW50X29iamVjdCsweDc2LzB4ODQKWyAgIDUwLjUxOTM4MV0gIFs8NDEx
ZTg0ZDc+XSA/IGRlYnVnX3ByaW50X29iamVjdCsweDc2LzB4ODQKWyAgIDUwLjUxOTM4MV0g
IFs8NDEwMjI5OGU+XSB3YXJuX3Nsb3dwYXRoX2ZtdCsweDJlLzB4MzAKWyAgIDUwLjUxOTM4
MV0gIFs8NDExZTg0ZDc+XSBkZWJ1Z19wcmludF9vYmplY3QrMHg3Ni8weDg0ClsgICA1MC41
MTkzODFdICBbPDQxMWU4NzYyPl0gX19kZWJ1Z19vYmplY3RfaW5pdCsweDI3ZC8weDJiYgpb
ICAgNTAuNTE5MzgxXSAgWzw0MTFlODljNj5dIGRlYnVnX29iamVjdF9pbml0KzB4MTMvMHgx
NQpbICAgNTAuNTE5MzgxXSAgWzw0MTAyOTI1ZT5dIGluaXRfdGltZXJfa2V5KzB4MTcvMHg2
NApbICAgNTAuNTE5MzgxXSAgWzw0MTFkYjRhNT5dIGtvYmplY3RfcmVsZWFzZSsweDUwLzB4
NzgKWyAgIDUwLjUxOTM4MV0gIFs8NDExZGI1MWM+XSBrb2JqZWN0X3B1dCsweDRmLzB4NTUK
WyAgIDUwLjUxOTM4MV0gIFs8NDEwYWQ1YmM+XSBjZGV2X2RlbCsweDIzLzB4MjYKWyAgIDUw
LjUxOTM4MV0gIFs8NDEyMzlmYjU+XSB0dHlfdW5yZWdpc3Rlcl9kZXZpY2UrMHgzMy8weDM3
ClsgICA1MC41MTkzODFdICBbPDQxMjQ3NDM5Pl0gdWFydF9yZW1vdmVfb25lX3BvcnQrMHhh
MS8weGVlClsgICA1MC41MTkzODFdICBbPDQxMjQ5MDI1Pl0gc2VyaWFsODI1MF9yZWdpc3Rl
cl84MjUwX3BvcnQrMHhjMS8weDIzNQpbICAgNTAuNTE5MzgxXSAgWzw0MTI0OTM1ND5dIHNl
cmlhbDgyNTBfcHJvYmUrMHgxMDgvMHgxNmEKWyAgIDUwLjUxOTM4MV0gIFs8NDEwM2YxOWE+
XSA/IHNjaGVkX2Nsb2NrX2NwdSsweGQ4LzB4ZWUKWyAgIDUwLjUxOTM4MV0gIFs8NDEwM2Yx
OWE+XSA/IHNjaGVkX2Nsb2NrX2NwdSsweGQ4LzB4ZWUKWyAgIDUwLjUxOTM4MV0gIFs8NDEy
NWY2NGE+XSBwbGF0Zm9ybV9kcnZfcHJvYmUrMHgyOS8weDRiClsgICA1MC41MTkzODFdICBb
PDQxMjVlMjQyPl0gZHJpdmVyX3Byb2JlX2RldmljZSsweDhmLzB4MTk0ClsgICA1MC41MTkz
ODFdICBbPDQxMjVmNzZjPl0gPyBwbGF0Zm9ybV9tYXRjaCsweDUyLzB4NjYKWyAgIDUwLjUx
OTM4MV0gIFs8NDEyNWUzNjM+XSBfX2RldmljZV9hdHRhY2grMHgxYy8weDJjClsgICA1MC41
MTkzODFdICBbPDQxMjVjY2IyPl0gYnVzX2Zvcl9lYWNoX2RydisweDM4LzB4NmIKWyAgIDUw
LjUxOTM4MV0gIFs8NDEyNWUxN2U+XSBkZXZpY2VfYXR0YWNoKzB4NjYvMHg4MwpbICAgNTAu
NTE5MzgxXSAgWzw0MTI1ZTM0Nz5dID8gZHJpdmVyX3Byb2JlX2RldmljZSsweDE5NC8weDE5
NApbICAgNTAuNTE5MzgxXSAgWzw0MTI1ZDhhZj5dIGJ1c19wcm9iZV9kZXZpY2UrMHgyNS8w
eDg0ClsgICA1MC41MTkzODFdICBbPDQxMjVjMThiPl0gZGV2aWNlX2FkZCsweDNlNi8weDU3
YgpbICAgNTAuNTE5MzgxXSAgWzw0MTFlMzViOT5dID8ga3Zhc3ByaW50ZisweDNiLzB4NDQK
WyAgIDUwLjUxOTM4MV0gIFs8NDExZGI5NTY+XSA/IGtvYmplY3Rfc2V0X25hbWVfdmFyZ3Mr
MHgzZC8weDRhClsgICA1MC41MTkzODFdICBbPDQxMjVmNGFjPl0gcGxhdGZvcm1fZGV2aWNl
X2FkZCsweDEzMS8weDE5NQpbICAgNTAuNTE5MzgxXSAgWzw0MTI1Zjk3Zj5dIHBsYXRmb3Jt
X2RldmljZV9yZWdpc3RlcisweDFjLzB4MWYKWyAgIDUwLjUxOTM4MV0gIFs8NDE2NzdiYjg+
XSA/IHNldHVwX2Vhcmx5X3NlcmlhbDgyNTBfY29uc29sZSsweDM3Ni8weDM3NgpbICAgNTAu
NTE5MzgxXSAgWzw0MTY3N2JjNT5dIGFjY2VudF9pbml0KzB4ZC8weGYKWyAgIDUwLjUxOTM4
MV0gIFs8NDEwMDAzZGY+XSBkb19vbmVfaW5pdGNhbGwrMHg3ZS8weDEwYwpbICAgNTAuNTE5
MzgxXSAgWzw0MTY1YjQwMD5dID8gZG9fZWFybHlfcGFyYW0rMHg0Zi8weDdhClsgICA1MC41
MTkzODFdICBbPDQxMDM1YmNkPl0gPyBwYXJzZV9hcmdzKzB4MTVkLzB4MjIyClsgICA1MC41
MTkzODFdICBbPDQxNjViYTg5Pl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgxMTYvMHgxYjUK
WyAgIDUwLjUxOTM4MV0gIFs8NDE2NWI0MmI+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4N2EvMHg3
YQpbICAgNTAuNTE5MzgxXSAgWzw0MTMzYjNiND5dIGtlcm5lbF9pbml0KzB4Yi8weGMzClsg
ICA1MC41MTkzODFdICBbPDQxMzQ5OWJiPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDFi
LzB4MzAKWyAgIDUwLjUxOTM4MV0gIFs8NDEzM2IzYTk+XSA/IHJlc3RfaW5pdCsweGI1LzB4
YjUKWyAgIDUwLjUxOTM4MV0gLS0tWyBlbmQgdHJhY2UgYjgxZmMxNjQ5MWYzMDljZSBdLS0t
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1LzI0NWYwODY5OWQ1MzIwZjAy
MTA3MGVkODY5OGFjODllYmYyZjA2NzAvZG1lc2cta3ZtLWFudC02MDQzLTIwMTMwODI0MTYw
NDM4LTMuMTEuMC1yYzYtbmV4dC0yMDEzMDgyMi0wNzA3MC1nMjQ1ZjA4Ni0xCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1LzI0NWYwODY5OWQ1MzIwZjAyMTA3MGVkODY5
OGFjODllYmYyZjA2NzAvZG1lc2cta3ZtLWJlbnMtMzcwNi0yMDEzMDgyNDE2MDU1Ni0zLjEx
LjAtcmM2LW5leHQtMjAxMzA4MjItMDcwNzAtZzI0NWYwODYtMQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1qNS0wODI0MTUyNS8yNDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJm
MmYwNjcwL2RtZXNnLWt2bS1iZW5zLTQwNDAtMjAxMzA4MjQxNjA5MTUtMy4xMS4wLXJjMi0w
MDAwNS1nODk5ODI2Zi0zNTIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajUtMDgyNDE1MjUv
MjQ1ZjA4Njk5ZDUzMjBmMDIxMDcwZWQ4Njk4YWM4OWViZjJmMDY3MC9kbWVzZy1rdm0taW5u
LTEwMDUyLTIwMTMwODI1MTAxOTExLTMuMTEuMC1yYzYtbmV4dC0yMDEzMDgyMi0wNzA3MC1n
MjQ1ZjA4Ni0xCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1LzI0NWYwODY5
OWQ1MzIwZjAyMTA3MGVkODY5OGFjODllYmYyZjA2NzAvZG1lc2cta3ZtLWlubi0xMDExNS0y
MDEzMDgyNTEwMjA1MS0zLjExLjAtcmMzLTAwOTcxLWc1Y2Q5YmI1LTIwCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1LzI0NWYwODY5OWQ1MzIwZjAyMTA3MGVkODY5OGFj
ODllYmYyZjA2NzAvZG1lc2cta3ZtLWlubi0xMDExNS0yMDEzMDgyNTEwMjQ1Mi0zLjExLjAt
cmMzLTAwOTcxLWc1Y2Q5YmI1LTIwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo1LTA4MjQx
NTI1LzI0NWYwODY5OWQ1MzIwZjAyMTA3MGVkODY5OGFjODllYmYyZjA2NzAvZG1lc2cta3Zt
LWlubi0xMDU1Ni0yMDEzMDgyNTEwMjIwMy0zLjEwLjAtcmMxLTAzMzQ0LWcxOWIyYTg4LTMx
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1LzI0NWYwODY5OWQ1MzIwZjAy
MTA3MGVkODY5OGFjODllYmYyZjA2NzAvZG1lc2cta3ZtLWlubi0xMDg3MS0yMDEzMDgyNTEw
MjQxMi0zLjExLjAtcmMxLTAwMDk4LWcwMDU3NGRhLTE3Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWo1LTA4MjQxNTI1LzI0NWYwODY5OWQ1MzIwZjAyMTA3MGVkODY5OGFjODllYmYyZjA2
NzAvZG1lc2cta3ZtLWlubi0xMTU2NC0yMDEzMDgyNTEwMTc1Ni0zLjExLjAtcmM2LW5leHQt
MjAxMzA4MjItMDcwNzAtZzI0NWYwODYtMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNS0w
ODI0MTUyNS8yNDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNn
LWt2bS1pbm4tMTE5NDItMjAxMzA4MjUxMDIxMzUtMy4xMS4wLXJjNi1uZXh0LTIwMTMwODIy
LTA3MDcwLWcyNDVmMDg2LTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajUtMDgyNDE1MjUv
MjQ1ZjA4Njk5ZDUzMjBmMDIxMDcwZWQ4Njk4YWM4OWViZjJmMDY3MC9kbWVzZy1rdm0taW5u
LTYyNjItMjAxMzA4MjUxMDM2MDktMy4xMS4wLXJjMy0wMDk3MS1nNWNkOWJiNS0yMAova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1qNS0wODI0MTUyNS8yNDVmMDg2OTlkNTMyMGYwMjEwNzBl
ZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS1pbm4tNjMyNS0yMDEzMDgyNTEwMTgwMi0z
LjExLjAtcmM2LXdsLTY4NTI4LWc4NWE3ZDBkLTIxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWo1LTA4MjQxNTI1LzI0NWYwODY5OWQ1MzIwZjAyMTA3MGVkODY5OGFjODllYmYyZjA2NzAv
ZG1lc2cta3ZtLWlubi02ODMzLTIwMTMwODI1MTA0MDExLTMuMTEuMC1yYzYtd2wtNjg1Mjgt
Zzg1YTdkMGQtMjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajUtMDgyNDE1MjUvMjQ1ZjA4
Njk5ZDUzMjBmMDIxMDcwZWQ4Njk4YWM4OWViZjJmMDY3MC9kbWVzZy1rdm0taW5uLTcyMTEt
MjAxMzA4MjUxMDIxMDItMy4xMS4wLXJjNi13bC02ODUyOC1nODVhN2QwZC0xOAova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1qNS0wODI0MTUyNS8yNDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2
OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS1pbm4tODE1Ni0yMDEzMDgyNTEwMjQ1MS0zLjEx
LjAtcmMzLTAwOTcxLWc1Y2Q5YmI1LTQ2Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNS0w
ODI0MTUyNS8yNDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNn
LWt2bS1pbm4tOTEwMS0yMDEzMDgyNTEwMzgwNC0zLjExLjAtcmMzLTAwOTcxLWc1Y2Q5YmI1
LTQ2Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNS0wODI0MTUyNS8yNDVmMDg2OTlkNTMy
MGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS1pbm4tOTM1My0yMDEzMDgy
NTEwMjAzMS0zLjExLjAtcmM2LW5leHQtMjAxMzA4MjItMDcwNzAtZzI0NWYwODYtMQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1qNS0wODI0MTUyNS8yNDVmMDg2OTlkNTMyMGYwMjEwNzBl
ZDg2OThhYzg5ZWJmMmYwNjcwL2RtZXNnLWt2bS1uaG00LTE1MjkyLTIwMTMwODI1MDIzNjE1
LTMuMTEuMC1yYzYtbmV4dC0yMDEzMDgyMi0wNzA3MC1nMjQ1ZjA4Ni0xCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1LzI0NWYwODY5OWQ1MzIwZjAyMTA3MGVkODY5OGFj
ODllYmYyZjA2NzAvZG1lc2cta3ZtLW5obTQtNzAxNS0yMDEzMDgyNTAyMTAzMy0zLjExLjAt
cmM2LW5leHQtMjAxMzA4MjItMDcwNzAtZzI0NWYwODYtMQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1qNS0wODI0MTUyNS8yNDVmMDg2OTlkNTMyMGYwMjEwNzBlZDg2OThhYzg5ZWJmMmYw
NjcwL2RtZXNnLWt2bS1uaG00LTgxNTMtMjAxMzA4MjUwMjMwMjctMy4xMS4wLXJjMy0wMDk3
MS1nNWNkOWJiNS00NzAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajUtMDgyNDE1MjUvMjQ1
ZjA4Njk5ZDUzMjBmMDIxMDcwZWQ4Njk4YWM4OWViZjJmMDY3MC9kbWVzZy1rdm0td2FpbWVh
LTIxMjkyLTIwMTMwODI1MTAyNDM4LTMuMTEuMC1yYzYtbmV4dC0yMDEzMDgyMi0wNzA3MC1n
MjQ1ZjA4Ni0xCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1LzI0NWYwODY5
OWQ1MzIwZjAyMTA3MGVkODY5OGFjODllYmYyZjA2NzAvZG1lc2cta3ZtLXdhaW1lYS0zNjQ3
LTIwMTMwODI0MTU1NzU5LTMuMTEuMC1yYzYtbmV4dC0yMDEzMDgyMi0wNzA3MC1nMjQ1ZjA4
Ni0xCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1LzI0NWYwODY5OWQ1MzIw
ZjAyMTA3MGVkODY5OGFjODllYmYyZjA2NzAvZG1lc2cta3ZtLXdhaW1lYS00NDg3LTIwMTMw
ODI0MTU1NTU2LTMuMTEuMC1yYzYtbmV4dC0yMDEzMDgyMi0wNzA3MC1nMjQ1ZjA4Ni0xCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1LzI0NWYwODY5OWQ1MzIwZjAyMTA3
MGVkODY5OGFjODllYmYyZjA2NzAvZG1lc2cta3ZtLXdhaW1lYS00NzYwLTIwMTMwODI1MTAw
NDQ1LTMuMTEuMC1yYzYtbmV4dC0yMDEzMDgyMi0wNzA3MC1nMjQ1ZjA4Ni0xCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWo1LTA4MjQxNTI1LzI0NWYwODY5OWQ1MzIwZjAyMTA3MGVkODY5
OGFjODllYmYyZjA2NzAvZG1lc2cta3ZtLXdhaW1lYS03MDk2LTIwMTMwODI0MTU1NjExLTMu
MTEuMC1yYzYtMDAyMDgtZ2ZlYmEyOWQtNjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajUt
MDgyNDE1MjUvMjQ1ZjA4Njk5ZDUzMjBmMDIxMDcwZWQ4Njk4YWM4OWViZjJmMDY3MC9kbWVz
Zy1rdm0td2FpbWVhLTczMTItMjAxMzA4MjQxNTU3MzYtMy4xMS4wLXJjNi1uZXh0LTIwMTMw
ODIyLTA3MDcwLWcyNDVmMDg2LTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajUtMDgyNDE1
MjUvMjQ1ZjA4Njk5ZDUzMjBmMDIxMDcwZWQ4Njk4YWM4OWViZjJmMDY3MC9kbWVzZy1rdm0t
d2FpbWVhLTg4NTUtMjAxMzA4MjUwOTUxNDEtMy4xMS4wLXJjNi1uZXh0LTIwMTMwODIyLTA3
MDcwLWcyNDVmMDg2LTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajUtMDgyNDE1MjUvMjQ1
ZjA4Njk5ZDUzMjBmMDIxMDcwZWQ4Njk4YWM4OWViZjJmMDY3MC9kbWVzZy1rdm0td2FpbWVh
LTg4NzMtMjAxMzA4MjQxNTUwMjAtMy4xMS4wLXJjNi1uZXh0LTIwMTMwODIyLTA3MDcwLWcy
NDVmMDg2LTEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajUtMDgyNDE1MjUvMjQ1ZjA4Njk5
ZDUzMjBmMDIxMDcwZWQ4Njk4YWM4OWViZjJmMDY3MC9kbWVzZy1rdm0td2FpbWVhLTk5NzMt
MjAxMzA4MjQxNTU4MjctMy4xMS4wLXJjNi1uZXh0LTIwMTMwODIyLTA3MDcwLWcyNDVmMDg2
LTEKCg==

--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.11.0-rc6-next-20130822-07070-g245f086"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.11.0-rc6 Kernel Configuration
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
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
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
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_BOOST is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
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
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
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
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_BSGLIB is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
# CONFIG_CMDLINE_PARSER is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=m
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
# CONFIG_SMP is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
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
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
CONFIG_MGEODEGX1=y
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_TSC=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_CYRIX_32 is not set
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_CENTAUR is not set
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
CONFIG_X86_ANCIENT_MCE=y
CONFIG_X86_MCE_INJECT=y
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
CONFIG_MICROCODE_INTEL_EARLY=y
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_MICROCODE_EARLY=y
# CONFIG_X86_MSR is not set
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
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
# CONFIG_BOUNCE is not set
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=y
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
CONFIG_FRONTSWAP=y
# CONFIG_ZBUD is not set
# CONFIG_ZSWAP is not set
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
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
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=m
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
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
CONFIG_APM=m
# CONFIG_APM_IGNORE_USER_SUSPEND is not set
# CONFIG_APM_DO_ENABLE is not set
# CONFIG_APM_CPU_IDLE is not set
# CONFIG_APM_DISPLAY_BLANK is not set
CONFIG_APM_ALLOW_INTS=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K6=y
CONFIG_X86_POWERNOW_K7=m
CONFIG_X86_POWERNOW_K7_ACPI=y
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=m
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
CONFIG_X86_LONGRUN=m
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
CONFIG_CPU_IDLE_GOV_LADDER=y
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
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
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
CONFIG_EISA_VLB_PRIMING=y
CONFIG_EISA_PCI_EISA=y
CONFIG_EISA_VIRTUAL_ROOT=y
# CONFIG_EISA_NAMES is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
# CONFIG_GEOS is not set
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

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
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_ATM=m
CONFIG_ATM_LANE=m
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_MRP=m
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=m
CONFIG_LLC2=m
CONFIG_IPX=m
CONFIG_IPX_INTERN=y
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
# CONFIG_LTPC is not set
# CONFIG_COPS is not set
# CONFIG_IPDDP is not set
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_PHONET=m
CONFIG_IEEE802154=m
# CONFIG_MAC802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_ATM=m
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=m
# CONFIG_NET_SCH_TBF is not set
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=y
# CONFIG_NET_SCH_MQPRIO is not set
CONFIG_NET_SCH_CHOKE=m
# CONFIG_NET_SCH_QFQ is not set
CONFIG_NET_SCH_CODEL=y
CONFIG_NET_SCH_FQ_CODEL=m
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
# CONFIG_CLS_U32_PERF is not set
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=y
# CONFIG_NET_CLS_RSVP6 is not set
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
# CONFIG_NET_EMATCH_NBYTE is not set
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=y
CONFIG_NET_EMATCH_TEXT=y
CONFIG_NET_EMATCH_CANID=m
# CONFIG_NET_CLS_ACT is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=m
CONFIG_BATMAN_ADV=m
# CONFIG_BATMAN_ADV_NC is not set
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_OPENVSWITCH=m
CONFIG_VSOCKETS=m
CONFIG_NETLINK_MMAP=y
# CONFIG_NETLINK_DIAG is not set
CONFIG_NET_MPLS_GSO=m
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
CONFIG_CAN_SLCAN=m
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
# CONFIG_CFG80211_REG_DEBUG is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_LIB80211=m
CONFIG_LIB80211_CRYPT_WEP=m
CONFIG_LIB80211_CRYPT_CCMP=m
CONFIG_LIB80211_CRYPT_TKIP=m
CONFIG_LIB80211_DEBUG=y
# CONFIG_MAC80211 is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=m
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_REGULATOR=m
# CONFIG_NET_9P is not set
CONFIG_CAIF=m
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=m
CONFIG_CAIF_USB=m
CONFIG_NFC=m
CONFIG_NFC_NCI=m
CONFIG_NFC_HCI=m
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_WILINK=m
CONFIG_NFC_SIM=m
CONFIG_NFC_PN544=m
CONFIG_NFC_PN544_I2C=m
# CONFIG_NFC_MICROREAD is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_CMA is not set

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=y
# CONFIG_MTD_TESTS is not set
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_CMDLINE_PARTS=m
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
# CONFIG_MTD_BLOCK is not set
CONFIG_MTD_BLOCK_RO=y
CONFIG_FTL=y
CONFIG_NFTL=y
CONFIG_NFTL_RW=y
# CONFIG_INFTL is not set
CONFIG_RFD_FTL=y
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
CONFIG_MTD_OOPS=y
CONFIG_MTD_SWAP=y

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
CONFIG_MTD_JEDECPROBE=y
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
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=m
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_TS5500=y
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=m
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
CONFIG_MTD_NETtel=m
# CONFIG_MTD_L440GX is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=m
# CONFIG_MTD_NAND_DENALI_PCI is not set
CONFIG_MTD_NAND_GPIO=m
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
# CONFIG_MTD_NAND_DISKONCHIP is not set
CONFIG_MTD_NAND_DOCG4=m
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_CS553X=m
# CONFIG_MTD_NAND_NANDSIM is not set
CONFIG_MTD_NAND_PLATFORM=m
CONFIG_MTD_ONENAND=m
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=m
CONFIG_MTD_ONENAND_OTP=y
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
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
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
CONFIG_PARIDE=m

#
# Parallel IDE high-level drivers
#
CONFIG_PARIDE_PD=m
CONFIG_PARIDE_PCD=m
CONFIG_PARIDE_PF=m
# CONFIG_PARIDE_PT is not set
# CONFIG_PARIDE_PG is not set

#
# Parallel IDE protocol modules
#
CONFIG_PARIDE_ATEN=m
CONFIG_PARIDE_BPCK=m
# CONFIG_PARIDE_BPCK6 is not set
CONFIG_PARIDE_COMM=m
CONFIG_PARIDE_DSTR=m
CONFIG_PARIDE_FIT2=m
# CONFIG_PARIDE_FIT3 is not set
# CONFIG_PARIDE_EPAT is not set
# CONFIG_PARIDE_EPIA is not set
CONFIG_PARIDE_FRIQ=m
CONFIG_PARIDE_FRPW=m
# CONFIG_PARIDE_KBIC is not set
CONFIG_PARIDE_KTTI=m
# CONFIG_PARIDE_ON20 is not set
CONFIG_PARIDE_ON26=m
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
CONFIG_ATA_OVER_ETH=m
CONFIG_VIRTIO_BLK=m
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RSXX is not set
CONFIG_BLOCKCONSOLE=y

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=m
CONFIG_AD525X_DPOT_I2C=m
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=m
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_IDE_LEGACY=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=m
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
# CONFIG_BLK_DEV_PLATFORM is not set
CONFIG_BLK_DEV_CMD640=m
# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
# CONFIG_BLK_DEV_IDEPNP is not set

#
# PCI IDE chipsets support
#
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_CS5536 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
# CONFIG_BLK_DEV_4DRIVES is not set
CONFIG_BLK_DEV_ALI14XX=m
CONFIG_BLK_DEV_DTC2278=m
CONFIG_BLK_DEV_HT6560B=m
# CONFIG_BLK_DEV_QD65XX is not set
# CONFIG_BLK_DEV_UMC8672 is not set
# CONFIG_BLK_DEV_IDEDMA is not set

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
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
# CONFIG_MD_RAID0 is not set
# CONFIG_MD_RAID1 is not set
CONFIG_MD_RAID10=m
# CONFIG_MD_RAID456 is not set
CONFIG_MD_MULTIPATH=m
# CONFIG_MD_FAULTY is not set
CONFIG_BCACHE=m
# CONFIG_BCACHE_DEBUG is not set
# CONFIG_BCACHE_EDEBUG is not set
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=m
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
# CONFIG_DM_CRYPT is not set
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
# CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
# CONFIG_DM_CACHE is not set
# CONFIG_DM_MIRROR is not set
# CONFIG_DM_RAID is not set
# CONFIG_DM_ZERO is not set
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
CONFIG_DM_DELAY=m
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
CONFIG_DM_SWITCH=m
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=m
CONFIG_NETDEVICES=y
CONFIG_MII=y
# CONFIG_NET_CORE is not set
# CONFIG_ARCNET is not set
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#
# CONFIG_CAIF_TTY is not set
CONFIG_CAIF_SPI_SLAVE=m
CONFIG_CAIF_SPI_SYNC=y
CONFIG_CAIF_HSI=m
CONFIG_CAIF_VIRTIO=m
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y
CONFIG_VHOST=y

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=m
CONFIG_NET_DSA_MV88E6060=y
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
CONFIG_NET_DSA_MV88E6123_61_65=m
CONFIG_ETHERNET=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_VENDOR_ARC is not set
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_ALX is not set
# CONFIG_NET_CADENCE is not set
# CONFIG_NET_VENDOR_BROADCOM is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_CALXEDA_XGMAC=y
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CIRRUS=y
# CONFIG_CS89x0 is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
# CONFIG_DNET is not set
# CONFIG_NET_VENDOR_DEC is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
# CONFIG_NET_VENDOR_FUJITSU is not set
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
# CONFIG_NET_VENDOR_INTEL is not set
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_MLX5_CORE is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
CONFIG_ETHOC=y
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_NET_VENDOR_REALTEK is not set
# CONFIG_SH_ETH is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
# CONFIG_NET_VENDOR_SEEQ is not set
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
# CONFIG_SFC is not set
# CONFIG_NET_VENDOR_SMSC is not set
# CONFIG_NET_VENDOR_STMICRO is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
CONFIG_WIZNET_W5100=y
CONFIG_WIZNET_W5300=m
CONFIG_WIZNET_BUS_DIRECT=y
# CONFIG_WIZNET_BUS_INDIRECT is not set
# CONFIG_WIZNET_BUS_ANY is not set
CONFIG_FDDI=y
CONFIG_DEFXX=m
CONFIG_DEFXX_MMIO=y
# CONFIG_SKFP is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
CONFIG_AMD_PHY=y
# CONFIG_MARVELL_PHY is not set
CONFIG_DAVICOM_PHY=y
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=m
# CONFIG_SMSC_PHY is not set
CONFIG_BROADCOM_PHY=y
CONFIG_BCM87XX_PHY=y
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=m
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=m
CONFIG_LSI_ET1011C_PHY=y
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_PLIP=m
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
# CONFIG_PPP_DEFLATE is not set
# CONFIG_PPP_FILTER is not set
CONFIG_PPP_MPPE=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=m
# CONFIG_PPPOE is not set
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=y
CONFIG_SLIP=y
CONFIG_SLHC=y
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y
CONFIG_WLAN=y
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
CONFIG_ATH_CARDS=m
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K_PCI is not set
CONFIG_ATH6KL=m
CONFIG_ATH6KL_SDIO=m
CONFIG_ATH6KL_DEBUG=y
# CONFIG_WIL6210 is not set
CONFIG_BRCMUTIL=m
CONFIG_BRCMFMAC=m
CONFIG_BRCMFMAC_SDIO=y
# CONFIG_BRCM_TRACING is not set
# CONFIG_BRCMDBG is not set
CONFIG_HOSTAP=m
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_HOSTAP_FIRMWARE_NVRAM=y
# CONFIG_HOSTAP_PLX is not set
# CONFIG_HOSTAP_PCI is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_HERMES is not set
CONFIG_WL_TI=y
CONFIG_MWIFIEX=m
CONFIG_MWIFIEX_SDIO=m
# CONFIG_MWIFIEX_PCIE is not set

#
# WiMAX Wireless Broadband devices
#

#
# Enable USB support to see WiMAX USB drivers
#
CONFIG_WAN=y
# CONFIG_HDLC is not set
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
CONFIG_SDLA=m
# CONFIG_LAPBETHER is not set
CONFIG_X25_ASY=y
CONFIG_SBNI=y
# CONFIG_SBNI_MULTILINE is not set
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
CONFIG_INPUT_MOUSEDEV=m
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=m
CONFIG_KEYBOARD_ADP5589=m
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_GPIO=m
CONFIG_KEYBOARD_GPIO_POLLED=y
# CONFIG_KEYBOARD_TCA6416 is not set
CONFIG_KEYBOARD_TCA8418=m
CONFIG_KEYBOARD_MATRIX=y
CONFIG_KEYBOARD_LM8323=m
CONFIG_KEYBOARD_LM8333=m
CONFIG_KEYBOARD_MAX7359=m
CONFIG_KEYBOARD_MCS=m
CONFIG_KEYBOARD_MPR121=m
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_KEYBOARD_OPENCORES=m
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_XTKBD=m
CONFIG_KEYBOARD_CROS_EC=m
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
# CONFIG_JOYSTICK_SIDEWINDER is not set
CONFIG_JOYSTICK_TMDC=y
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
# CONFIG_JOYSTICK_DB9 is not set
CONFIG_JOYSTICK_GAMECON=m
# CONFIG_JOYSTICK_TURBOGRAFX is not set
# CONFIG_JOYSTICK_AS5011 is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=m
CONFIG_TOUCHSCREEN_AUO_PIXCIR=m
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP_I2C=m
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=m
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=m
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=m
CONFIG_TOUCHSCREEN_EETI=m
CONFIG_TOUCHSCREEN_FUJITSU=y
CONFIG_TOUCHSCREEN_ILI210X=m
CONFIG_TOUCHSCREEN_GUNZE=m
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_WACOM_I2C=m
# CONFIG_TOUCHSCREEN_MAX11801 is not set
CONFIG_TOUCHSCREEN_MCS5000=m
CONFIG_TOUCHSCREEN_MMS114=m
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_INEXIO=m
CONFIG_TOUCHSCREEN_MK712=y
# CONFIG_TOUCHSCREEN_HTCPEN is not set
CONFIG_TOUCHSCREEN_PENMOUNT=m
CONFIG_TOUCHSCREEN_EDT_FT5X06=m
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_MC13783=m
CONFIG_TOUCHSCREEN_TOUCHIT213=y
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
CONFIG_TOUCHSCREEN_TSC2007=m
CONFIG_TOUCHSCREEN_ST1232=m
CONFIG_TOUCHSCREEN_TPS6507X=m
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=m
CONFIG_SERIO_ARC_PS2=m
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
# CONFIG_GAMEPORT_L4 is not set
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
CONFIG_ROCKETPORT=m
CONFIG_CYCLADES=y
# CONFIG_CYZ_INTR is not set
CONFIG_MOXA_INTELLIO=y
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
# CONFIG_N_HDLC is not set
CONFIG_N_GSM=m
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_FOURPORT=m
CONFIG_SERIAL_8250_ACCENT=y
# CONFIG_SERIAL_8250_BOCA is not set
CONFIG_SERIAL_8250_EXAR_ST16C554=y
CONFIG_SERIAL_8250_HUB6=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
# CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
# CONFIG_SERIAL_ST_ASC is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
CONFIG_HVC_DRIVER=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_DTLK=m
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
CONFIG_MWAVE=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=m
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_NSC=m
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=m
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
CONFIG_I2C_MUX_PCA9541=m
CONFIG_I2C_MUX_PCA954x=m
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

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
CONFIG_I2C_CBUS_GPIO=m
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=m
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_TAOS_EVM=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_ELEKTOR=m
CONFIG_I2C_PCA_ISA=m
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
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
CONFIG_NTP_PPS=y

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
CONFIG_PTP_1588_CLOCK=m

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_PCH=m
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=m
CONFIG_GPIO_TS5500=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX7300=m
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
CONFIG_GPIO_ADP5588=m

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MCP23S08=m

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#

#
# MODULbus GPIO expanders:
#

#
# USB GPIO expanders:
#
CONFIG_W1=m
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=m
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=m
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
# CONFIG_W1_SLAVE_DS2413 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=m
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=m
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=m
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=m
CONFIG_TEST_POWER=m
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_DS2780=m
CONFIG_BATTERY_DS2781=m
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_SBS=m
CONFIG_BATTERY_BQ27x00=m
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_MAX17040=m
CONFIG_BATTERY_MAX17042=m
CONFIG_CHARGER_PCF50633=m
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_LP8727=m
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_BQ2415X=m
CONFIG_CHARGER_SMB347=m
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_GPIO_FAN=m
CONFIG_SENSORS_HIH6130=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IBMAEM=m
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
CONFIG_SENSORS_MCP3021=m
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
# CONFIG_SENSORS_PMBUS is not set
CONFIG_SENSORS_ADM1275=m
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
# CONFIG_SENSORS_MAX16064 is not set
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=m
CONFIG_SENSORS_ZL6100=m
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=m
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_ADS1015=m
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=m
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_MC13783_ADC=m

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
# CONFIG_INTEL_POWERCLAMP is not set

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
CONFIG_RETU_WATCHDOG=m
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=m
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=m
CONFIG_WAFER_WDT=m
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=m
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
CONFIG_SC1200_WDT=m
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=m
# CONFIG_SBC8360_WDT is not set
# CONFIG_SBC7240_WDT is not set
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=m
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=m
CONFIG_W83697HF_WDT=m
CONFIG_W83697UG_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=m
CONFIG_SBC_EPX_C3_WATCHDOG=y
CONFIG_MEN_A21_WDT=m

#
# ISA-based Watchdog Cards
#
# CONFIG_PCWATCHDOG is not set
# CONFIG_MIXCOMWD is not set
# CONFIG_WDT is not set

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
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_HOST_SOC=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
CONFIG_BCMA_DRIVER_GPIO=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=m
CONFIG_MFD_MC13783=m
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_I2C=m
# CONFIG_HTC_PASIC3 is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_RETU=m
CONFIG_MFD_PCF50633=m
# CONFIG_PCF50633_ADC is not set
CONFIG_PCF50633_GPIO=m
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_SI476X_CORE=m
# CONFIG_MFD_SM501 is not set
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_TPS6105X=m
CONFIG_TPS65010=m
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=m
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
# CONFIG_REGULATOR_AD5398 is not set
# CONFIG_REGULATOR_ANATOP is not set
CONFIG_REGULATOR_DA9210=m
CONFIG_REGULATOR_FAN53555=m
CONFIG_REGULATOR_GPIO=m
CONFIG_REGULATOR_ISL6271A=m
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=m
CONFIG_REGULATOR_LP8755=m
CONFIG_REGULATOR_MAX1586=m
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8952=m
CONFIG_REGULATOR_MAX8973=m
CONFIG_REGULATOR_MC13XXX_CORE=m
CONFIG_REGULATOR_MC13783=m
# CONFIG_REGULATOR_MC13892 is not set
# CONFIG_REGULATOR_PCF50633 is not set
CONFIG_REGULATOR_PFUZE100=m
CONFIG_REGULATOR_TPS51632=m
# CONFIG_REGULATOR_TPS6105X is not set
CONFIG_REGULATOR_TPS62360=m
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=m
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_DVB_CORE=m
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
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
# CONFIG_MEDIA_TUNER_MT20XX is not set
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2063=m
# CONFIG_MEDIA_TUNER_MT2266 is not set
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
# CONFIG_MEDIA_TUNER_XC2028 is not set
# CONFIG_MEDIA_TUNER_XC5000 is not set
CONFIG_MEDIA_TUNER_XC4000=m
# CONFIG_MEDIA_TUNER_MXL5005S is not set
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
# CONFIG_MEDIA_TUNER_MAX2165 is not set
# CONFIG_MEDIA_TUNER_TDA18218 is not set
CONFIG_MEDIA_TUNER_FC0011=m
# CONFIG_MEDIA_TUNER_FC0012 is not set
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=m
CONFIG_MEDIA_TUNER_E4000=m
CONFIG_MEDIA_TUNER_FC2580=m
CONFIG_MEDIA_TUNER_TUA9001=m
CONFIG_MEDIA_TUNER_IT913X=m
CONFIG_MEDIA_TUNER_R820T=m

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=m
# CONFIG_DVB_STB6100 is not set
CONFIG_DVB_STV090x=m
# CONFIG_DVB_STV6110x is not set

#
# Multistandard (cable + terrestrial) frontends
#
# CONFIG_DVB_DRXK is not set
CONFIG_DVB_TDA18271C2DD=m

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
# CONFIG_DVB_CX24123 is not set
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=m
CONFIG_DVB_ZL10039=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=m
# CONFIG_DVB_STB6000 is not set
# CONFIG_DVB_STV0299 is not set
# CONFIG_DVB_STV6110 is not set
# CONFIG_DVB_STV0900 is not set
# CONFIG_DVB_TDA8083 is not set
CONFIG_DVB_TDA10086=m
# CONFIG_DVB_TDA8261 is not set
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TUNER_CX24113=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
# CONFIG_DVB_CX24116 is not set
CONFIG_DVB_SI21XX=m
CONFIG_DVB_TS2020=m
CONFIG_DVB_DS3000=m
# CONFIG_DVB_MB86A16 is not set
CONFIG_DVB_TDA10071=m

#
# DVB-T (terrestrial) frontends
#
# CONFIG_DVB_SP8870 is not set
CONFIG_DVB_SP887X=m
# CONFIG_DVB_CX22700 is not set
CONFIG_DVB_CX22702=m
CONFIG_DVB_S5H1432=m
CONFIG_DVB_DRXD=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
# CONFIG_DVB_NXT6000 is not set
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
# CONFIG_DVB_DIB3000MB is not set
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
# CONFIG_DVB_DIB7000P is not set
CONFIG_DVB_DIB9000=m
# CONFIG_DVB_TDA10048 is not set
CONFIG_DVB_AF9013=m
CONFIG_DVB_EC100=m
CONFIG_DVB_HD29L2=m
# CONFIG_DVB_STV0367 is not set
CONFIG_DVB_CXD2820R=m
# CONFIG_DVB_RTL2830 is not set
CONFIG_DVB_RTL2832=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
# CONFIG_DVB_STV0297 is not set

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
# CONFIG_DVB_NXT200X is not set
CONFIG_DVB_OR51211=m
# CONFIG_DVB_OR51132 is not set
# CONFIG_DVB_BCM3510 is not set
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_LGDT3305=m
# CONFIG_DVB_LG2160 is not set
# CONFIG_DVB_S5H1409 is not set
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_DTV=m
CONFIG_DVB_S5H1411=m

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m
# CONFIG_DVB_DIB8000 is not set
# CONFIG_DVB_MB86A20S is not set

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# SEC control devices for DVB-S
#
# CONFIG_DVB_LNBP21 is not set
# CONFIG_DVB_LNBP22 is not set
# CONFIG_DVB_ISL6405 is not set
CONFIG_DVB_ISL6421=m
# CONFIG_DVB_ISL6423 is not set
# CONFIG_DVB_A8293 is not set
CONFIG_DVB_LGS8GL5=m
CONFIG_DVB_LGS8GXX=m
CONFIG_DVB_ATBM8830=m
CONFIG_DVB_TDA665x=m
# CONFIG_DVB_IX2505V is not set
CONFIG_DVB_IT913X_FE=m
CONFIG_DVB_M88RS2000=m
# CONFIG_DVB_AF9033 is not set

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
CONFIG_DRM=m
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
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
CONFIG_FB=m
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=m
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=m
CONFIG_FB_N411=m
# CONFIG_FB_HGA is not set
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
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=m
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_GOLDFISH=m
CONFIG_FB_VIRTUAL=m
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=m
CONFIG_FB_AUO_K190X=m
CONFIG_FB_AUO_K1900=m
CONFIG_FB_AUO_K1901=m
CONFIG_EXYNOS_VIDEO=y
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=m
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_GENERIC=m

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=m
CONFIG_HID_EZKEY=m
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
CONFIG_HID_LOGITECH=m
# CONFIG_HID_LOGITECH_DJ is not set
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=m
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
CONFIG_HID_ORTEK=m
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=m
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SPEEDLINK=m
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_GREENASIA=m
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=m
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
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
# CONFIG_AM335X_PHY_USB is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
# CONFIG_MMC_BLOCK_BOUNCE is not set
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=m
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MEMSTICK=m
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
# CONFIG_MSPRO_BLOCK is not set
# CONFIG_MS_BLOCK is not set

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
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3533=m
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_PCA9532_GPIO=y
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP55XX_COMMON=m
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8501=m
CONFIG_LEDS_CLEVO_MAIL=y
CONFIG_LEDS_PCA955X=m
CONFIG_LEDS_PCA963X=m
CONFIG_LEDS_PWM=m
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=m
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_MC13783=m
CONFIG_LEDS_TCA6507=m
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=m

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_MM_EDAC=m
# CONFIG_EDAC_AMD76X is not set
# CONFIG_EDAC_E7XXX is not set
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82875P is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I82860 is not set
# CONFIG_EDAC_R82600 is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
# CONFIG_KS0108 is not set
# CONFIG_UIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_STAGING=y
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
CONFIG_ECHO=m
CONFIG_COMEDI=m
CONFIG_COMEDI_DEBUG=y
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
# CONFIG_COMEDI_MISC_DRIVERS is not set
# CONFIG_COMEDI_ISA_DRIVERS is not set
# CONFIG_COMEDI_PCI_DRIVERS is not set
CONFIG_COMEDI_8255=m
CONFIG_PANEL=m
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
CONFIG_PANEL_CHANGE_MESSAGE=y
CONFIG_PANEL_BOOT_MESSAGE=""
# CONFIG_R8187SE is not set
# CONFIG_RTLLIB is not set
# CONFIG_VT6655 is not set
# CONFIG_DX_SEP is not set
# CONFIG_ZSMALLOC is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=m
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
CONFIG_ANDROID_LOGGER=y
# CONFIG_ANDROID_TIMED_OUTPUT is not set
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
CONFIG_SYNC=y
CONFIG_SW_SYNC=y
CONFIG_SW_SYNC_USER=y
CONFIG_WIMAX_GDM72XX=m
# CONFIG_WIMAX_GDM72XX_QOS is not set
CONFIG_WIMAX_GDM72XX_K_MODE=y
CONFIG_WIMAX_GDM72XX_WIMAX2=y
CONFIG_WIMAX_GDM72XX_SDIO=y
# CONFIG_NET_VENDOR_SILICOM is not set
CONFIG_DGRP=m
# CONFIG_XILLYBUS is not set
CONFIG_DGNC=y
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
CONFIG_CHROMEOS_LAPTOP=m
CONFIG_DELL_LAPTOP=m
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
CONFIG_AMILO_RFKILL=m
# CONFIG_HP_ACCEL is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=m
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=m
# CONFIG_INTEL_OAKTRAIL is not set
CONFIG_SAMSUNG_Q10=y
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
# CONFIG_IOMMU_SUPPORT is not set

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
CONFIG_DEVFREQ_GOV_POWERSAVE=m
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=m
CONFIG_FMC_FAKEDEV=m
CONFIG_FMC_TRIVIAL=m
CONFIG_FMC_WRITE_EEPROM=m
# CONFIG_FMC_CHARDEV is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=m
# CONFIG_DMIID is not set
CONFIG_DMI_SYSFS=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
# CONFIG_EXT3_FS_POSIX_ACL is not set
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_WARN=y
# CONFIG_XFS_DEBUG is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
# CONFIG_QUOTA is not set
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=m
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=y
# CONFIG_HFSPLUS_FS_POSIX_ACL is not set
CONFIG_BEFS_FS=m
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=m
CONFIG_EFS_FS=m
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
# CONFIG_JFFS2_SUMMARY is not set
# CONFIG_JFFS2_FS_XATTR is not set
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
# CONFIG_UBIFS_FS is not set
CONFIG_LOGFS=y
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_XATTR is not set
# CONFIG_SQUASHFS_ZLIB is not set
# CONFIG_SQUASHFS_LZO is not set
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=m
CONFIG_MINIX_FS=m
CONFIG_OMFS_FS=m
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
CONFIG_ROMFS_FS=m
# CONFIG_ROMFS_BACKED_BY_BLOCK is not set
# CONFIG_ROMFS_BACKED_BY_MTD is not set
CONFIG_ROMFS_BACKED_BY_BOTH=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_ROMFS_ON_MTD=y
# CONFIG_PSTORE is not set
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
CONFIG_UFS_DEBUG=y
# CONFIG_F2FS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NCP_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=m
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=m
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=m
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=y
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
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_PREEMPT is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_KOBJECT_RELEASE=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
CONFIG_PROVE_RCU_DELAY=y
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=m
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAIL_MMC_REQUEST=y
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
CONFIG_LKDTM=m
# CONFIG_TEST_LIST_SORT is not set
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=m
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_SET_MODULE_RONX is not set
CONFIG_DEBUG_NX_TEST=m
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_TRUSTED_KEYS=m
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
# CONFIG_IMA is not set
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
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=m
CONFIG_CRYPTO_XCBC=y
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_586=m
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_ZLIB=y
# CONFIG_CRYPTO_LZO is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=m
CONFIG_CRYPTO_USER_API_HASH=m
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_LGUEST=m
# CONFIG_BINARY_PRINTF is not set

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
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=m
# CONFIG_CRC8 is not set
CONFIG_CRC64_ECMA=y
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
CONFIG_DDR=y

--45Z9DzgjV8m4Oswq--
