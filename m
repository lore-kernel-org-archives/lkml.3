Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350Ab3FMB4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 21:56:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:43779 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757019Ab3FMB4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 21:56:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,855,1363158000"; 
   d="log'?scan'208";a="349035620"
Date: Thu, 13 Jun 2013 09:56:02 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: fengguang.wu@intel.com, Peng Tao <bergwolf@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [lustre] WARNING: at kernel/mutex.c:341 mutex_lock_nested()
Message-ID: <20130613015602.GA9024@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit ee04fd11f11fb67ff0ae482a6710f97f499c19e2
Author: Peng Tao <bergwolf@gmail.com>
Date:   Thu Jun 6 22:59:14 2013 +0800

    Revert "Revert "staging/lustre: drop CONFIG_BROKEN dependency""
    
    This reverts commit 37d4093fd34775bbbf99bddb84a711bdb3ec6d5c.
    
    I've verified that we now don't break build on X86_64 allmodconfig.
    
    Cc: Stephen Rothwell <sfr@canb.auug.org.au>
    Signed-off-by: Peng Tao <tao.peng@emc.com>
    Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[   16.644069] alg: No test for adler32 (adler32-zlib)
[   24.640247] ------------[ cut here ]------------
[   24.640960] WARNING: at /c/kernel-tests/src/tip/kernel/mutex.c:341 mutex_lock_nested+0x1cb/0x526()
[   24.642199] DEBUG_LOCKS_WARN_ON(l->magic != l)
[   24.642805] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc5-00678-ge764df6 #78
[   24.647268] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   24.648073]  ffffffff8235d9d1 ffff88000cc65d58 ffffffff81e18a81 ffff88000cc65d98
[   24.649184]  ffffffff810a24a7 0000000000000000 ffff88000cc65da8 ffffffff83ae6c98
[   24.650041]  0000000000000246 0000000000000000 ffffffff83ae6ca0 ffff88000cc65df8
[   24.650041] Call Trace:
[   24.650041]  [<ffffffff81e18a81>] dump_stack+0x27/0x30
[   24.650041]  [<ffffffff810a24a7>] warn_slowpath_common+0x85/0xb5
[   24.650041]  [<ffffffff810a2566>] warn_slowpath_fmt+0x54/0x5d
[   24.650041]  [<ffffffff81e2361f>] mutex_lock_nested+0x1cb/0x526
[   24.650041]  [<ffffffff81c07db1>] ? lnet_register_lnd+0x24/0x1ee
[   24.650041]  [<ffffffff8124f351>] ? __register_sysctl_paths+0x1c4/0x22d
[   24.650041]  [<ffffffff81c07db1>] ? lnet_register_lnd+0x24/0x1ee
[   24.650041]  [<ffffffff81c07db1>] lnet_register_lnd+0x24/0x1ee
[   24.650041]  [<ffffffff82b7d78d>] ? fld_mod_init+0x63/0x63
[   24.650041]  [<ffffffff82b7d824>] ksocknal_module_init+0x97/0xa3
[   24.650041]  [<ffffffff82b103a5>] do_one_initcall+0xb7/0x195
[   24.650041]  [<ffffffff82b1069e>] kernel_init_freeable+0x21b/0x31e
[   24.650041]  [<ffffffff82b0f84e>] ? loglevel+0x46/0x46
[   24.650041]  [<ffffffff81e00bf6>] ? rest_init+0x13a/0x13a
[   24.650041]  [<ffffffff81e00c0b>] kernel_init+0x15/0x16a
[   24.650041]  [<ffffffff81e2a26c>] ret_from_fork+0x7c/0xb0
[   24.650041]  [<ffffffff81e00bf6>] ? rest_init+0x13a/0x13a
[   24.650041] ---[ end trace 87ffcbcb0b7b7e53 ]---

git bisect start 5f43264c5320624f3b458c5794f37220c4fc2934 v3.9 --
git bisect good 7b1e427d685e2aee91f9a622f9c2691130f8e57d  # 19:45     38+  s390/zcore: calculate real memory size using own get_mem_size function
git bisect good a8c4b90e670be3b01e9395c7310639c8109fc77e  # 20:05     38+  Merge tag 'soc-for-linus-2' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect good a87af7c58b1f5af0d6a6093465d1a5ed8054434c  # 20:20     38+  staging/speakup: Replaced deprecated function
git bisect good 11e7064f35bb87da8f427d1aa4bbd8b7473a3993  # 20:38     38+  ALSA: usb-audio - Fix invalid volume resolution on Logitech HD webcam c270
git bisect good 17d8dfcda6ce570ddc4844f490104fed4af215aa  # 21:05     38+  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu
git bisect good 423e118c0be32274de137a4d97f0dcac3edd136a  # 21:24     38+  Staging: csr: fix indentation style issue in bh.c
git bisect  bad 3275b4d3db1f087c67fa115b150a9d2f9d8429f9  # 21:29      0-  staging: comedi: pcmad: tidy up pcmad_ai_insn_read()
git bisect good 3e842f73c68fe44e8569107b94d710f4bbdcbb1f  # 21:50     38+  staging: octeon-usb: fix checkpatch error
git bisect good 15bc85bdb509902e65fcf481c28369093097d92a  # 22:06     38+  staging: comedi: pcmda12: tidy up multi-line comments
git bisect  bad ee04fd11f11fb67ff0ae482a6710f97f499c19e2  # 22:10      0-  Revert "Revert "staging/lustre: drop CONFIG_BROKEN dependency""
git bisect good 88e5a934d3836b9eb948b46f402357c4c0e0eafe  # 22:35     38+  staging: rtl8192u: remove trailing whitespace in r8192U_core.c
git bisect good d29dc2e418a7a4a5a776417dd3574f3e91824088  # 22:47     38+  staging/lustre: remove lu_context_keys_dump and lu_debugging_setup
git bisect good 4a1a01ea52ad3d9bc0ac36f5a9739d6cce0bae75  # 22:57     38+  staging/lustre: surround module_refcount with CONFIG_MODULE_UNLOAD
git bisect good 9c782da4f09d7665eb60b70dd83280b6a819857f  # 01:41     38+  staging/lustre/libcfs: cleanup linux-crypto
git bisect good 9c782da4f09d7665eb60b70dd83280b6a819857f  # 05:21    114+  staging/lustre/libcfs: cleanup linux-crypto
git bisect  bad e764df67963940b4123325710536a9471d1e24ae  # 05:21      0-  iio: frequency: adf4350: Add support for dt bindings
git bisect good be62b98c327bed3d4b749e53b50bead5510aa11f  # 05:50    114+  Revert "Revert "Revert "staging/lustre: drop CONFIG_BROKEN dependency"""
git bisect good 1a9c3d68d65f4b5ce32f7d67ccc730396e04cdd2  # 06:20    114+  Merge branch 'upstream' of git://git.linux-mips.org/pub/scm/ralf/upstream-linus
git bisect good c04efed734409f5a44715b54a6ca1b54b0ccf215  # 06:49    114+  Add linux-next specific files for 20130607

Thanks,
Fengguang

--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-bay-28342-20130610055705-3.10.0-rc5-00678-ge764df6-78"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.10.0-rc5-00678-ge764df6 (kbuild@cairo) (gcc version 4.7.2 (Debian 4.7.2-4) ) #78 SMP Mon Jun 10 05:52:46 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-c22-0609/iio:togreg/.vmlinuz-e764df67963940b4123325710536a9471d1e24ae-20130610055329-8-bay branch=iio/togreg  BOOT_IMAGE=/kernel/x86_64-randconfig-c22-0609/e764df67963940b4123325710536a9471d1e24ae/vmlinuz-3.10.0-rc5-00678-ge764df6
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at [ffff8800000fdab0]
[    0.000000]   mpc: fdac0-fdbec
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x03bf1000, 0x03bf1fff] PGTABLE
[    0.000000] BRK [0x03bf2000, 0x03bf2fff] PGTABLE
[    0.000000] BRK [0x03bf3000, 0x03bf3fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 4k
[    0.000000] BRK [0x03bf4000, 0x03bf4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 4k
[    0.000000] BRK [0x03bf5000, 0x03bf5fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127980(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000000ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000d200000-ffff88000d5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65424
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3986 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 960 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 474 pages/cpu @ffff88000da00000 s1919248 r0 d22256 u2097152
[    0.000000] pcpu-alloc: s1919248 r0 d22256 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64379
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-c22-0609/iio:togreg/.vmlinuz-e764df67963940b4123325710536a9471d1e24ae-20130610055329-8-bay branch=iio/togreg  BOOT_IMAGE=/kernel/x86_64-randconfig-c22-0609/e764df67963940b4123325710536a9471d1e24ae/vmlinuz-3.10.0-rc5-00678-ge764df6
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 175244k/262136k available (14520k kernel code, 440k absent, 86452k reserved, 11288k data, 3240k init)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6335 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2992.686 MHz processor
[    0.020005] Calibrating delay loop (skipped), value calculated using timer frequency.. 5985.37 BogoMIPS (lpj=29926860)
[    0.030436] pid_max: default: 32768 minimum: 301
[    0.031314] Mount-cache hash table entries: 256
[    0.032939] Initializing cgroup subsys devices
[    0.033602] Initializing cgroup subsys blkio
[    0.034230] Initializing cgroup subsys perf_event
[    0.034917] Initializing cgroup subsys net_prio
[    0.035735] mce: CPU supports 10 MCE banks
[    0.036406] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.036406] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.036406] tlb_flushall_shift: 6
[    0.038429] debug: unmapping init [mem 0xffffffff82c64000-0xffffffff82c6dfff]
[    0.039605] ACPI: Core revision 20130328
[    0.042692] ACPI: All ACPI Tables successfully acquired
[    0.043528] ftrace: allocating 35517 entries in 139 pages
[    0.060632] Getting VERSION: 50014
[    0.061167] Getting VERSION: 50014
[    0.061671] Getting ID: 0
[    0.062073] Getting ID: ff000000
[    0.062552] Getting LVT0: 8700
[    0.063009] Getting LVT1: 8400
[    0.063526] enabled ExtINT on CPU#0
[    0.065087] ENABLING IO-APIC IRQs
[    0.065578] init IO_APIC IRQs
[    0.066019]  apic 2 pin 0 not connected
[    0.066589] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.067744] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.068906] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.070028] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.071170] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.072310] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.073452] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.074596] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.075750] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.076895] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.078060] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.079227] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.080028] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.081197] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.082368] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.083531]  apic 2 pin 16 not connected
[    0.084096]  apic 2 pin 17 not connected
[    0.084664]  apic 2 pin 18 not connected
[    0.085227]  apic 2 pin 19 not connected
[    0.085794]  apic 2 pin 20 not connected
[    0.086362]  apic 2 pin 21 not connected
[    0.086923]  apic 2 pin 22 not connected
[    0.087489]  apic 2 pin 23 not connected
[    0.088210] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.190410] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.192270] Using local APIC timer interrupts.
[    0.192270] calibrating APIC timer ...
[    0.200000] ... lapic delta = 6249989
[    0.200000] ... PM-Timer delta = 357954
[    0.200000] ... PM-Timer result ok
[    0.200000] ..... delta 6249989
[    0.200000] ..... mult: 268434983
[    0.200000] ..... calibration result: 9999982
[    0.200000] ..... CPU clock speed is 2992.4875 MHz.
[    0.200000] ..... host bus clock speed is 999.9982 MHz.
[    0.200000] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.200000] ftrace: Allocated trace_printk buffers
[    0.221213] Testing tracer nop: PASSED
[    0.223827] SMP alternatives: lockdep: fixing up alternatives
[    0.225077] smpboot: Booting Node   0, Processors  #1 OK
[    0.030000] masked ExtINT on CPU#1
[    0.030000] calibrate_delay_direct() failed to get a good estimate for loops_per_jiffy.
[    0.030000] Probably due to long platform interrupts. Consider using "lpj=" boot option.
[    0.670098] Brought up 2 CPUs
[    0.670585] smpboot: Total of 2 processors activated (11982.73 BogoMIPS)
[    0.671842] CPU0 attaching sched-domain:
[    0.672411]  domain 0: span 0-1 level CPU
[    0.673009]   groups: 0 1
[    0.673462] CPU1 attaching sched-domain:
[    0.674024]  domain 0: span 0-1 level CPU
[    0.674613]   groups: 1 0
[    0.780061] Testing tracer function: PASSED
[    1.052667] Testing dynamic ftrace: PASSED
[    1.440196] Testing dynamic ftrace ops #1: (1 0 1 1 0) (1 1 2 1 0) (2 1 3 1 21) (2 2 4 1 103) PASSED
[    1.762571] Testing dynamic ftrace ops #2: (1 0 1 9 0) (1 1 2 99 0) (2 1 3 1 8) (2 2 4 92 99) PASSED
[    2.032336] Testing ftrace recursion: PASSED
[    2.052451] Testing ftrace recursion safe: PASSED
[    2.072516] Testing ftrace regs: PASSED
[    2.320236] Testing tracer irqsoff: PASSED
[    2.773339] xor: measuring software checksum speed
[    2.880011]    prefetch64-sse:  7070.000 MB/sec
[    2.980008]    generic_sse:  8846.400 MB/sec
[    2.980626] xor: using function: generic_sse (8846.400 MB/sec)
[    2.981711] regulator-dummy: no parameters
[    2.982581] NET: Registered protocol family 16
[    2.984350] ACPI: bus type PCI registered
[    2.985015] PCI: Using configuration type 1 for base access
[    3.000138] bio: create slab <bio-0> at 0
[    3.170015] raid6: sse2x1    2046 MB/s
[    3.340012] raid6: sse2x2    1486 MB/s
[    3.510039] raid6: sse2x4    2460 MB/s
[    3.510619] raid6: using algorithm sse2x4 (2460 MB/s)
[    3.511379] raid6: using intx1 recovery algorithm
[    3.512484] ACPI: Added _OSI(Module Device)
[    3.513093] ACPI: Added _OSI(Processor Device)
[    3.513735] ACPI: Added _OSI(3.0 _SCP Extensions)
[    3.514410] ACPI: Added _OSI(Processor Aggregator Device)
[    3.518368] ACPI: EC: Look up EC in DSDT
[    3.526589] ACPI: Interpreter enabled
[    3.527136] ACPI: (supports S0 S5)
[    3.527638] ACPI: Using IOAPIC for interrupt routing
[    3.528421] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    3.540312] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    3.541263] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    3.542267] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    3.543265] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    3.544386] acpi PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    3.545513] PCI: root bus 00: using default resources
[    3.546275] PCI host bridge to bus 0000:00
[    3.546882] pci_bus 0000:00: root bus resource [bus 00-ff]
[    3.547661] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    3.548568] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[    3.549633] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    3.550827] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    3.552396] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    3.555126] pci 0000:00:01.1: reg 20: [io  0xc1e0-0xc1ef]
[    3.557094] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    3.558579] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    3.560027] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    3.564679] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    3.570538] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    3.572526] pci 0000:00:02.0: reg 14: [mem 0xfebe4000-0xfebe4fff]
[    3.586680] pci 0000:00:02.0: reg 30: [mem 0xfebc0000-0xfebcffff pref]
[    3.590701] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    3.592270] pci 0000:00:03.0: reg 10: [io  0xc1c0-0xc1df]
[    3.597038] pci 0000:00:03.0: reg 14: [mem 0xfebe5000-0xfebe5fff]
[    3.605839] pci 0000:00:03.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
[    3.607140] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    3.610673] pci 0000:00:04.0: reg 10: [mem 0xfeb80000-0xfeb9ffff]
[    3.612150] pci 0000:00:04.0: reg 14: [io  0xc000-0xc03f]
[    3.622466] pci 0000:00:04.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
[    3.627053] pci 0000:00:05.0: [8086:2668] type 00 class 0x040300
[    3.628341] pci 0000:00:05.0: reg 10: [mem 0xfebe0000-0xfebe3fff]
[    3.635868] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    3.640015] pci 0000:00:06.0: reg 10: [io  0xc040-0xc07f]
[    3.641408] pci 0000:00:06.0: reg 14: [mem 0xfebe6000-0xfebe6fff]
[    3.650133] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    3.651687] pci 0000:00:07.0: reg 10: [io  0xc080-0xc0bf]
[    3.653077] pci 0000:00:07.0: reg 14: [mem 0xfebe7000-0xfebe7fff]
[    3.664752] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    3.666313] pci 0000:00:08.0: reg 10: [io  0xc0c0-0xc0ff]
[    3.670015] pci 0000:00:08.0: reg 14: [mem 0xfebe8000-0xfebe8fff]
[    3.677783] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    3.680704] pci 0000:00:09.0: reg 10: [io  0xc100-0xc13f]
[    3.685477] pci 0000:00:09.0: reg 14: [mem 0xfebe9000-0xfebe9fff]
[    3.692033] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    3.696464] pci 0000:00:0a.0: reg 10: [io  0xc140-0xc17f]
[    3.700643] pci 0000:00:0a.0: reg 14: [mem 0xfebea000-0xfebeafff]
[    3.705953] pci 0000:00:0b.0: [1af4:1001] type 00 class 0x010000
[    3.710728] pci 0000:00:0b.0: reg 10: [io  0xc180-0xc1bf]
[    3.712111] pci 0000:00:0b.0: reg 14: [mem 0xfebeb000-0xfebebfff]
[    3.724741] pci 0000:00:0c.0: [8086:25ab] type 00 class 0x088000
[    3.725974] pci 0000:00:0c.0: reg 10: [mem 0xfebec000-0xfebec00f]
[    3.731507] pci_bus 0000:00: on NUMA node 0
[    3.732136] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    3.740814] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    3.741953] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    3.743077] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    3.747590] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    3.748715] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    3.753034] ACPI: Enabled 16 GPEs in block 00 to 0F
[    3.753793] acpi root: \_SB_.PCI0 notify handler is installed
[    3.757669] Found 1 acpi root devices
[    3.758919] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    3.760028] vgaarb: loaded
[    3.760421] vgaarb: bridge control possible 0000:00:02.0
[    3.765078] pps_core: LinuxPPS API ver. 1 registered
[    3.765785] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    3.767065] PTP clock support registered
[    3.771648] PCI: Using ACPI for IRQ routing
[    3.771648] PCI: pci_cache_line_size set to 64 bytes
[    3.771842] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    3.772689] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    3.780374] NET: Registered protocol family 8
[    3.780999] NET: Registered protocol family 20
[    3.782305] Switching to clocksource hpet
[    3.965848] FS-Cache: Loaded
[    3.966367] CacheFiles: Loaded
[    3.966867] pnp: PnP ACPI init
[    3.967317] ACPI: bus type PNP registered
[    3.968080] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    3.969262] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    3.970505] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    3.981753] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    3.982723] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    3.983891] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    3.984858] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    3.985978] pnp 00:03: [dma 2]
[    3.986438] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    3.987454] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    3.988602] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    3.989608] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    3.990825] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    4.007312] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    4.008526] pnp: PnP ACPI: found 7 devices
[    4.009114] ACPI: bus type PNP unregistered
[    4.014743] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    4.015531] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[    4.026617] NET: Registered protocol family 2
[    4.027802] TCP established hash table entries: 2048 (order: 3, 32768 bytes)
[    4.029318] TCP bind hash table entries: 2048 (order: 5, 163840 bytes)
[    4.030660] TCP: Hash tables configured (established 2048 bind 2048)
[    4.031629] TCP: reno registered
[    4.032211] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    4.033210] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    4.034443] NET: Registered protocol family 1
[    4.035130] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    4.046092] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    4.047001] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    4.047913] pci 0000:00:02.0: Boot video device
[    4.048710] PCI: CLS 0 bytes, default 64
[    4.049557] Trying to unpack rootfs image as initramfs...
[    6.747026] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffeffff]
[    6.749429] Machine check injector initialized
[    6.760131] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
[    6.761413] blowfish-x86_64: performance on this CPU would be suboptimal: disabling blowfish-x86_64.
[    6.762827] cryptomgr_test (22) used greatest stack depth: 6272 bytes left
[    6.765415] twofish-x86_64-3way: performance on this CPU would be suboptimal: disabling twofish-x86_64-3way.
[    6.773479] PCLMULQDQ-NI instructions are not detected.
[    6.774224] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    6.775120] AVX or AES-NI instructions are not detected.
[    6.775877] AVX instructions are not detected.
[    6.776508] AVX instructions are not detected.
[    6.777255] AVX instructions are not detected.
[    6.777887] AVX instructions are not detected.
[    6.778516] AVX2 or AES-NI instructions are not detected.
[    6.779278] AVX2 instructions are not detected.
[    6.779921] AVX2 instructions are not detected.
[    6.781003] audit: initializing netlink socket (disabled)
[    6.781813] type=2000 audit(1370814987.780:1): initialized
[    6.811373] NTFS driver 2.1.30 [Flags: R/O DEBUG].
[    6.812150] fuse init (API version 7.22)
[    6.812975] JFS: nTxBlock = 1369, nTxLock = 10952
[    6.819625] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    6.834534] NILFS version 2 loaded
[    6.835162] bio: create slab <bio-1> at 1
[    6.836133] Btrfs loaded
[    6.838883] GFS2 installed
[    6.845005] cryptomgr_test (45) used greatest stack depth: 5696 bytes left
[    6.884986] cryptomgr_test (71) used greatest stack depth: 5216 bytes left
[    6.951821] alg: No test for crc32 (crc32-table)
[    6.957015] alg: No test for stdrng (krng)
[    6.980702] NET: Registered protocol family 38
[    6.981415] async_tx: api initialized (async)
[    6.982064] Key type asymmetric registered
[    6.982684] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    6.987299] io scheduler noop registered
[    6.987865] io scheduler deadline registered
[    6.988487] io scheduler cfq registered (default)
[    6.989160] list_sort_test: start testing list_sort()
[    6.993281] test_string_helpers: Running tests...
[    6.994510] crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
[    6.995223] crc32: self tests passed, processed 225944 bytes in 232950 nsec
[    6.996429] crc32c: CRC_LE_BITS = 32
[    7.000349] crc32c: self tests passed, processed 225944 bytes in 119510 nsec
[    7.001615] no IO addresses supplied
[    7.173212] uvesafb: failed to execute /sbin/v86d
[    7.173925] uvesafb: make sure that the v86d helper is installed and executable
[    7.174941] uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
[    7.175868] uvesafb: vbe_init() failed with -22
[    7.176507] uvesafb: probe of uvesafb.0 failed with error -22
[    7.180748] ipmi message handler version 39.2
[    7.181379] ipmi device interface
[    7.181909] IPMI System Interface driver.
[    7.182552] ipmi_si: Adding default-specified kcs state machine
[    7.186766] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[    7.188167] ipmi_si: Interface detection failed
[   16.174071] Switching to clocksource tsc
[   16.240133] ipmi_si: Adding default-specified smic state machine
[   16.241014] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[   16.242422] ipmi_si: Interface detection failed
[   16.280042] ipmi_si: Adding default-specified bt state machine
[   16.280893] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[   16.282272] ipmi_si: Interface detection failed
[   16.330095] ipmi_si: Unable to find any System Interface(s)
[   16.330895] IPMI Watchdog: driver initialized
[   16.331514] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[   16.332771] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[   16.333809] ACPI: Power Button [PWRF]
[   16.342154] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   16.409220] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   16.417243] lp: driver loaded but no devices found
[   16.418013] Non-volatile memory driver v1.3
[   16.418611] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[   16.419855] Hangcheck: Using getrawmonotonic().
[   16.420702] [drm] Initialized drm 1.1.0 20060810
[   16.437564] brd: module loaded
[   16.439069] loop: module loaded
[   16.441596] nbd: registered device at major 43
[   16.443260] events: mcg drbd: 3
[   16.546827] drbd: initialized. Version: 8.4.3 (api:1/proto:86-101)
[   16.547717] drbd: built-in
[   16.548109] drbd: registered as block device major 147
[   16.548893] rbd: loaded rbd (rados block device)
[   16.549567] dummy-irq: no IRQ given.  Use irq=N
[   16.550461] lkdtm: No crash points registered, enable through debugfs
[   16.551568] Uniform Multi-Platform E-IDE driver
[   16.552237] ide-gd driver 1.18
[   16.552686] ide-cd driver 5.00
[   16.553181] HSI/SSI char device loaded
[   16.553762] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.tc.umn.edu>
[   16.554972] ipddp0: Appletalk-IP Decap. mode by Jay Schulist <jschlst@samba.org>
[   16.567274] aoe: AoE v81 initialised.
[   16.567905] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[   16.570000] serio: i8042 KBD port at 0x60,0x64 irq 1
[   16.570878] serio: i8042 AUX port at 0x60,0x64 irq 12
[   16.571609] parkbd: no such parport
[   16.572260] mousedev: PS/2 mouse device common for all mice
[   16.573098] evbug: Connected device: input0 (Power Button at LNXPWRBN/button/input0)
[   16.580597] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[   16.581815] evbug: Connected device: input1 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
[   16.590199] walkera0701: parport 0 does not exist
[   16.590878] i2c /dev entries driver
[   16.591458] pps_parport: parallel port PPS client
[   16.592189] Driver for 1-wire Dallas network protocol.
[   16.592958] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[   16.593912] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
[   16.595483] applesmc: supported laptop not found!
[   16.596148] applesmc: driver init failed (ret=-19)!
[   16.597549] pc87360: PC8736x not detected, module not inserted
[   16.598759] md: linear personality registered for level -1
[   16.599536] md: raid0 personality registered for level 0
[   16.600372] md: raid1 personality registered for level 1
[   16.601130] md: raid10 personality registered for level 10
[   16.601904] md: raid6 personality registered for level 6
[   16.602647] md: raid5 personality registered for level 5
[   16.603426] md: raid4 personality registered for level 4
[   16.604172] md: multipath personality registered for level -4
[   16.605057] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
[   16.617881] device-mapper: multipath: version 1.5.1 loaded
[   16.618664] device-mapper: multipath round-robin: version 1.0.0 loaded
[   16.619582] device-mapper: multipath queue-length: version 0.1.0 loaded
[   16.620692] device-mapper: multipath service-time: version 0.2.0 loaded
[   16.621696] device-mapper: dm-log-userspace: version 1.1.0 loaded
[   16.622590] cpuidle: using governor ladder
[   16.630674] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   16.631779] hidraw: raw HID events driver (C) Jiri Kosina
[   16.632910] panel: driver version 0.9.5 not yet registered
[   16.634242] LNet: HW CPU cores: 2, npartitions: 1
[   16.644069] alg: No test for adler32 (adler32-zlib)
[   24.640247] ------------[ cut here ]------------
[   24.640960] WARNING: at /c/kernel-tests/src/tip/kernel/mutex.c:341 mutex_lock_nested+0x1cb/0x526()
[   24.642199] DEBUG_LOCKS_WARN_ON(l->magic != l)
[   24.642805] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc5-00678-ge764df6 #78
[   24.647268] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   24.648073]  ffffffff8235d9d1 ffff88000cc65d58 ffffffff81e18a81 ffff88000cc65d98
[   24.649184]  ffffffff810a24a7 0000000000000000 ffff88000cc65da8 ffffffff83ae6c98
[   24.650041]  0000000000000246 0000000000000000 ffffffff83ae6ca0 ffff88000cc65df8
[   24.650041] Call Trace:
[   24.650041]  [<ffffffff81e18a81>] dump_stack+0x27/0x30
[   24.650041]  [<ffffffff810a24a7>] warn_slowpath_common+0x85/0xb5
[   24.650041]  [<ffffffff810a2566>] warn_slowpath_fmt+0x54/0x5d
[   24.650041]  [<ffffffff81e2361f>] mutex_lock_nested+0x1cb/0x526
[   24.650041]  [<ffffffff81c07db1>] ? lnet_register_lnd+0x24/0x1ee
[   24.650041]  [<ffffffff8124f351>] ? __register_sysctl_paths+0x1c4/0x22d
[   24.650041]  [<ffffffff81c07db1>] ? lnet_register_lnd+0x24/0x1ee
[   24.650041]  [<ffffffff81c07db1>] lnet_register_lnd+0x24/0x1ee
[   24.650041]  [<ffffffff82b7d78d>] ? fld_mod_init+0x63/0x63
[   24.650041]  [<ffffffff82b7d824>] ksocknal_module_init+0x97/0xa3
[   24.650041]  [<ffffffff82b103a5>] do_one_initcall+0xb7/0x195
[   24.650041]  [<ffffffff82b1069e>] kernel_init_freeable+0x21b/0x31e
[   24.650041]  [<ffffffff82b0f84e>] ? loglevel+0x46/0x46
[   24.650041]  [<ffffffff81e00bf6>] ? rest_init+0x13a/0x13a
[   24.650041]  [<ffffffff81e00c0b>] kernel_init+0x15/0x16a
[   24.650041]  [<ffffffff81e2a26c>] ret_from_fork+0x7c/0xb0
[   24.650041]  [<ffffffff81e00bf6>] ? rest_init+0x13a/0x13a
[   24.650041] ---[ end trace 87ffcbcb0b7b7e53 ]---
[   24.650041] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   24.650041] IP: [<ffffffff815eb462>] __list_add+0x4a/0xdc
[   24.650041] PGD 0 
[   24.650041] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   24.650041] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W    3.10.0-rc5-00678-ge764df6 #78
[   24.650041] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   24.650041] task: ffff88000cc68000 ti: ffff88000cc64000 task.ti: ffff88000cc64000
[   24.650041] RIP: 0010:[<ffffffff815eb462>]  [<ffffffff815eb462>] __list_add+0x4a/0xdc
[   24.650041] RSP: 0000:ffff88000cc65dd8  EFLAGS: 00010046
[   24.650041] RAX: ffffffff83ae6ce8 RBX: 0000000000000000 RCX: 0000000000000000
[   24.650041] RDX: ffffffff83ae6ce8 RSI: 0000000000000000 RDI: ffff88000cc65e38
[   24.650041] RBP: ffff88000cc65df8 R08: 0000000000000000 R09: 0000000000000000
[   24.650041] R10: ffff88000cc65da8 R11: ffffffff810daff5 R12: ffffffff83ae6ce8
[   24.650041] R13: ffff88000cc65e38 R14: ffffffff83ae6ca0 R15: ffff88000cc68000
[   24.650041] FS:  0000000000000000(0000) GS:ffff88000dc00000(0000) knlGS:0000000000000000
[   24.650041] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   24.650041] CR2: 0000000000000000 CR3: 00000000024af000 CR4: 00000000000006e0
[   24.650041] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   24.650041] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   24.650041] Stack:
[   24.650041]  0000000000000000 ffffffff83ae6c98 0000000000000246 0000000000000000
[   24.650041]  ffff88000cc65e88 ffffffff81e23668 ffffffff81c07db1 ffffffff8286eaa0
[   24.650041]  ffff88000cc65e78 ffffffff83ae6ce8 ffffffff81c07db1 ffffffff83ae6d10
[   24.650041] Call Trace:
[   24.650041]  [<ffffffff81e23668>] mutex_lock_nested+0x214/0x526
[   24.650041]  [<ffffffff81c07db1>] ? lnet_register_lnd+0x24/0x1ee
[   24.650041]  [<ffffffff81c07db1>] ? lnet_register_lnd+0x24/0x1ee
[   24.650041]  [<ffffffff81c07db1>] lnet_register_lnd+0x24/0x1ee
[   24.650041]  [<ffffffff82b7d78d>] ? fld_mod_init+0x63/0x63
[   24.650041]  [<ffffffff82b7d824>] ksocknal_module_init+0x97/0xa3
[   24.650041]  [<ffffffff82b103a5>] do_one_initcall+0xb7/0x195
[   24.650041]  [<ffffffff82b1069e>] kernel_init_freeable+0x21b/0x31e
[   24.650041]  [<ffffffff82b0f84e>] ? loglevel+0x46/0x46
[   24.650041]  [<ffffffff81e00bf6>] ? rest_init+0x13a/0x13a
[   24.650041]  [<ffffffff81e00c0b>] kernel_init+0x15/0x16a
[   24.650041]  [<ffffffff81e2a26c>] ret_from_fork+0x7c/0xb0
[   24.650041]  [<ffffffff81e00bf6>] ? rest_init+0x13a/0x13a
[   24.650041] Code: 39 f0 74 27 49 89 d1 48 89 f1 48 c7 c2 85 1c 3c 82 be 1d 00 00 00 48 c7 c7 d2 1c 3c 82 31 c0 48 ff 05 5b 6a 0f 02 e8 b0 70 ab ff <4c> 8b 03 4d 39 e0 74 2e 49 89 d9 4c 89 e1 48 c7 c2 fb 1c 3c 82 
[   24.650041] RIP  [<ffffffff815eb462>] __list_add+0x4a/0xdc
[   24.650041]  RSP <ffff88000cc65dd8>
[   24.650041] CR2: 0000000000000000
[   24.650041] ---[ end trace 87ffcbcb0b7b7e54 ]---
[   24.650041] Kernel panic - not syncing: Fatal exception
[   24.650041] Rebooting in 10 seconds..
BUG: kernel boot crashed
Elapsed time: 60

--GvXjxJ+pjyke8COw
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-e764df67963940b4123325710536a9471d1e24ae-x86_64-randconfig-c22-0609-mutex_lock_nested-48452.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDVmNDMyNjRjNTMyMDYyNGYzYjQ1OGM1Nzk0ZjM3MjIwYzRmYzI5MzQK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgZTc2NGRmNi4uLiBpaW86IGZyZXF1ZW5jeTog
YWRmNDM1MDogQWRkIHN1cHBvcnQgZm9yIGR0IGJpbmRpbmdzCkhFQUQgaXMgbm93IGF0IDVm
NDMyNjQuLi4gc3RhZ2luZy9sdXN0cmUvbG5ldDogZml4IGJ1aWxkIGVycm9yIG9uIGkzODYK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMy
Mi0wNjA5L2lpbzp0b2dyZWc6NWY0MzI2NGM1MzIwNjI0ZjNiNDU4YzU3OTRmMzcyMjBjNGZj
MjkzNDpiaXNlY3QtdmZzCiBURVNUIEZBSUxVUkUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1jMjItMDYwOS81ZjQzMjY0YzUzMjA2MjRmM2I0NThjNTc5NGYzNzIyMGM0ZmMyOTM0L2Rt
ZXNnLWt2bS1hdGhlbnMtMTEyODAtMjAxMzA2MTAwNzAwMDctMy4xMC4wLXJjNS0wMDY3Ni1n
NWY0MzI2NC03OQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyMi0wNjA5LzVmNDMyNjRj
NTMyMDYyNGYzYjQ1OGM1Nzk0ZjM3MjIwYzRmYzI5MzQvZG1lc2cta3ZtLWJheS0yODYzNS0y
MDEzMDYxMDA3MDI0MC0zLjEwLjAtcmM1LTAwNjc2LWc1ZjQzMjY0LTc5Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctYzIyLTA2MDkvNWY0MzI2NGM1MzIwNjI0ZjNiNDU4YzU3OTRmMzcy
MjBjNGZjMjkzNC9kbWVzZy1rdm0tcm9hbS01MzA4LTIwMTMwNjEwMDcwMDUyLTMuMTAuMC1y
YzUtMDA2NzYtZzVmNDMyNjQtNzkKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjItMDYw
OS81ZjQzMjY0YzUzMjA2MjRmM2I0NThjNTc5NGYzNzIyMGM0ZmMyOTM0L2RtZXNnLWt2bS1z
bmItMjE2Ni0yMDEzMDYxMDA3MDMwOS0zLjEwLjAtcmM1LTAwNjc2LWc1ZjQzMjY0LTc5Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzIyLTA2MDkvNWY0MzI2NGM1MzIwNjI0ZjNiNDU4
YzU3OTRmMzcyMjBjNGZjMjkzNC9kbWVzZy1rdm0tc25iLTUwNzk4LTIwMTMwNjEwMDcwMzI4
LTMuMTAuMC1yYzUtMDA2NzYtZzVmNDMyNjQtNzkKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1jMjItMDYwOS81ZjQzMjY0YzUzMjA2MjRmM2I0NThjNTc5NGYzNzIyMGM0ZmMyOTM0L2Rt
ZXNnLWt2bS1zbmItNTExNzQtMjAxMzA2MTAwNzAzMDEtMy4xMC4wLXJjNS0wMDY3Ni1nNWY0
MzI2NC03OQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyMi0wNjA5LzVmNDMyNjRjNTMy
MDYyNGYzYjQ1OGM1Nzk0ZjM3MjIwYzRmYzI5MzQvZG1lc2cta3ZtLXNuYi01NDI2My0yMDEz
MDYxMDA3MDMxMS0zLjEwLjAtcmM1LTAwNjc2LWc1ZjQzMjY0LTc5Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctYzIyLTA2MDkvNWY0MzI2NGM1MzIwNjI0ZjNiNDU4YzU3OTRmMzcyMjBj
NGZjMjkzNC9kbWVzZy1rdm0tc25iLTYyNTU2LTIwMTMwNjEwMDcwMzMxLTMuMTAuMC1yYzUt
MDA2NzYtZzVmNDMyNjQtNzkKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjItMDYwOS81
ZjQzMjY0YzUzMjA2MjRmM2I0NThjNTc5NGYzNzIyMGM0ZmMyOTM0L2RtZXNnLWt2bS14Ym0t
MjU5NTctMjAxMzA2MTAwNzAxMzMtMy4xMC4wLXJjNS0wMDY3Ni1nNWY0MzI2NC03OQoKYmlz
ZWN0OiBiYWQgY29tbWl0IDVmNDMyNjRjNTMyMDYyNGYzYjQ1OGM1Nzk0ZjM3MjIwYzRmYzI5
MzQKZ2l0IGNoZWNrb3V0IHYzLjkKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgNWY0MzI2
NC4uLiBzdGFnaW5nL2x1c3RyZS9sbmV0OiBmaXggYnVpbGQgZXJyb3Igb24gaTM4NgpIRUFE
IGlzIG5vdyBhdCBjMWJlNWE1Li4uIExpbnV4IDMuOQpscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzIyLTA2MDkvaWlvOnRvZ3JlZzpjMWJl
NWE1YjFiMzU1ZDQwZTZjZjc5Y2M5NzllYjY2ZGFmYTI0YWQxOmJpc2VjdC12ZnMKCjIwMTMt
MDYtMTItMTk6MTQ6NDMgYzFiZTVhNWIxYjM1NWQ0MGU2Y2Y3OWNjOTc5ZWI2NmRhZmEyNGFk
MSBjb21waWxpbmcKMTQ1IHJlYWwgIDEzNTEgdXNlciAgOTkgc3lzICA5OTkuNjYlIGNwdSAJ
eDg2XzY0LXJhbmRjb25maWctYzIyLTA2MDkKCjIwMTMtMDYtMTItMTk6MTc6MzIgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgMy45LjAuLi4uLi4JMS4JNAkxMAkxNy4uCTE4CTE5CTI2CTI3Li4J
MzAJMzIJMzMuCTM3CTM4IFNVQ0NFU1MKCmJpc2VjdDogZ29vZCBjb21taXQgdjMuOQpnaXQg
YmlzZWN0IHN0YXJ0IDVmNDMyNjRjNTMyMDYyNGYzYjQ1OGM1Nzk0ZjM3MjIwYzRmYzI5MzQg
djMuOSAtLQpCaXNlY3Rpbmc6IDczOTkgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0
aGlzIChyb3VnaGx5IDEzIHN0ZXBzKQpbN2IxZTQyN2Q2ODVlMmFlZTkxZjlhNjIyZjljMjY5
MTEzMGY4ZTU3ZF0gczM5MC96Y29yZTogY2FsY3VsYXRlIHJlYWwgbWVtb3J5IHNpemUgdXNp
bmcgb3duIGdldF9tZW1fc2l6ZSBmdW5jdGlvbgpnaXQgYmlzZWN0IHJ1biAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy92ZnMvb2JqLWJp
c2VjdApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2ggL2hvbWUvd2ZnL3Zmcy9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMjItMDYwOS9paW86dG9ncmVnOjdiMWU0Mjdk
Njg1ZTJhZWU5MWY5YTYyMmY5YzI2OTExMzBmOGU1N2Q6YmlzZWN0LXZmcwoKMjAxMy0wNi0x
Mi0xOTozMDowOCA3YjFlNDI3ZDY4NWUyYWVlOTFmOWE2MjJmOWMyNjkxMTMwZjhlNTdkIGNv
bXBpbGluZwoxNjAgcmVhbCAgMTMyOCB1c2VyICA5NyBzeXMgIDg4OC4zNSUgY3B1IAl4ODZf
NjQtcmFuZGNvbmZpZy1jMjItMDYwOQoKMjAxMy0wNi0xMi0xOTozMzowMiBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAzLjkuMC0wNzM5OS1nN2IxZTQyNy4uLi4uLi4JNAkxMwkxNQkxNy4uCTE4
CTIwLgkyMQkyMwkyOAkzMC4uCTMxCTM3CTM4IFNVQ0NFU1MKCkJpc2VjdGluZzogMzY1OCBy
ZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTIgc3RlcHMpClth
OGM0YjkwZTY3MGJlM2IwMWU5Mzk1YzczMTA2MzljODEwOWZjNzdlXSBNZXJnZSB0YWcgJ3Nv
Yy1mb3ItbGludXMtMicgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9r
ZXJuZWwvZ2l0L2FybS9hcm0tc29jCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdmZzL29iai1iaXNlY3QKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMyMi0wNjA5L2lp
bzp0b2dyZWc6YThjNGI5MGU2NzBiZTNiMDFlOTM5NWM3MzEwNjM5YzgxMDlmYzc3ZTpiaXNl
Y3QtdmZzCgoyMDEzLTA2LTEyLTE5OjQ1OjM1IGE4YzRiOTBlNjcwYmUzYjAxZTkzOTVjNzMx
MDYzOWM4MTA5ZmM3N2UgY29tcGlsaW5nCjIwNiByZWFsICAxMzI0IHVzZXIgIDk5IHN5cyAg
Njg5LjY1JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLWMyMi0wNjA5CgoyMDEzLTA2LTEyLTE5
OjUyOjEyIGRldGVjdGluZyBib290IHN0YXRlIDMuOS4wLTExMTQwLWdhOGM0YjkwLi4uLi4J
MQkzCTYJOQkxMQkxMgkxNgkxOC4JMTkJMjIJMjQuLgkyNwkyOQkzMi4JMzUJMzcJMzggU1VD
Q0VTUwoKQmlzZWN0aW5nOiAxODI5IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSAxMSBzdGVwcykKW2E4N2FmN2M1OGIxZjVhZjBkNmE2MDkzNDY1ZDFhNWVk
ODA1NDQzNGNdIHN0YWdpbmcvc3BlYWt1cDogUmVwbGFjZWQgZGVwcmVjYXRlZCBmdW5jdGlv
bgpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2hvbWUvd2ZnL3Zmcy9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMjItMDYwOS9paW86dG9ncmVnOmE4N2FmN2M1OGIx
ZjVhZjBkNmE2MDkzNDY1ZDFhNWVkODA1NDQzNGM6YmlzZWN0LXZmcwoKMjAxMy0wNi0xMi0y
MDowNToxOCBhODdhZjdjNThiMWY1YWYwZDZhNjA5MzQ2NWQxYTVlZDgwNTQ0MzRjIGNvbXBp
bGluZwoxNzUgcmVhbCAgMTMyNSB1c2VyICAxMDAgc3lzICA4MTMuNzklIGNwdSAJeDg2XzY0
LXJhbmRjb25maWctYzIyLTA2MDkKCjIwMTMtMDYtMTItMjA6MDk6MDAgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgMy4xMC4wLXJjMS0wMDI1NC1nYTg3YWY3Yy4uLi4uLgkyCTUJNgk5CTEwCTEx
CTE1LgkxNi4JMjEJMjgJMzAJMzQJMzYJMzggU1VDQ0VTUwoKQmlzZWN0aW5nOiA5MjAgcmV2
aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEwIHN0ZXBzKQpbMTFl
NzA2NGYzNWJiODdkYThmNDI3ZDFhYTRiYmQ4Yjc0NzNhMzk5M10gQUxTQTogdXNiLWF1ZGlv
IC0gRml4IGludmFsaWQgdm9sdW1lIHJlc29sdXRpb24gb24gTG9naXRlY2ggSEQgd2ViY2Ft
IGMyNzAKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9ob21lL3dmZy92ZnMvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1x
dWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzIyLTA2MDkvaWlvOnRvZ3JlZzoxMWU3MDY0
ZjM1YmI4N2RhOGY0MjdkMWFhNGJiZDhiNzQ3M2EzOTkzOmJpc2VjdC12ZnMKCjIwMTMtMDYt
MTItMjA6MjA6MDQgMTFlNzA2NGYzNWJiODdkYThmNDI3ZDFhYTRiYmQ4Yjc0NzNhMzk5MyBj
b21waWxpbmcKMjkxIHJlYWwgIDEzMDkgdXNlciAgMTAyIHN5cyAgNDg0LjE1JSBjcHUgCXg4
Nl82NC1yYW5kY29uZmlnLWMyMi0wNjA5CgoyMDEzLTA2LTEyLTIwOjI3OjAyIGRldGVjdGlu
ZyBib290IHN0YXRlIDMuMTAuMC1yYzMtMDAwMzEtZzExZTcwNjQuLi4uLi4uLi4JMwk4Lgkx
MgkxMwkxNgkxNwkyMAkyMgkyNAkzMAkzNwkzOCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDQ2MSBy
ZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOSBzdGVwcykKWzE3
ZDhkZmNkYTZjZTU3MGRkYzQ4NDRmNDkwMTA0ZmVkNGFmMjE1YWFdIE1lcmdlIGJyYW5jaCAn
Zm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5l
bC9naXQvZ2VyZy9tNjhrbm9tbXUKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy92ZnMvb2JqLWJpc2VjdApscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzIyLTA2MDkvaWlv
OnRvZ3JlZzoxN2Q4ZGZjZGE2Y2U1NzBkZGM0ODQ0ZjQ5MDEwNGZlZDRhZjIxNWFhOmJpc2Vj
dC12ZnMKCjIwMTMtMDYtMTItMjA6Mzg6MDQgMTdkOGRmY2RhNmNlNTcwZGRjNDg0NGY0OTAx
MDRmZWQ0YWYyMTVhYSBjb21waWxpbmcKMTc1IHJlYWwgIDEzMzYgdXNlciAgMTAyIHN5cyAg
ODIyLjE3JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLWMyMi0wNjA5CgoyMDEzLTA2LTEyLTIw
OjQxOjE1IGRldGVjdGluZyBib290IHN0YXRlIDMuMTAuMC1yYzQtMDAyODItZzE3ZDhkZmMu
Li4uLi4JMgk0Li4JNwk5LgkxMQkxMwkxNwkyMAkyMS4JMjIuCTIzCTI0CTI2Li4uCTMzCTM3
Li4uLi4uLi4uLi4uLi4uLi4uCTM4IFNVQ0NFU1MKCkJpc2VjdGluZzogMjMwIHJldmlzaW9u
cyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpbNDIzZTExOGMw
YmUzMjI3NGRlMTM3YTRkOTdmMGRjYWMzZWRkMTM2YV0gU3RhZ2luZzogY3NyOiBmaXggaW5k
ZW50YXRpb24gc3R5bGUgaXNzdWUgaW4gYmguYwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3Zmcy9vYmotYmlzZWN0Cmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMjIt
MDYwOS9paW86dG9ncmVnOjQyM2UxMThjMGJlMzIyNzRkZTEzN2E0ZDk3ZjBkY2FjM2VkZDEz
NmE6YmlzZWN0LXZmcwoKMjAxMy0wNi0xMi0yMTowNToxNyA0MjNlMTE4YzBiZTMyMjc0ZGUx
MzdhNGQ5N2YwZGNhYzNlZGQxMzZhIGNvbXBpbGluZwoxNzcgcmVhbCAgMTMwMSB1c2VyICA5
OSBzeXMgIDc4OS4yNSUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1jMjItMDYwOQoKMjAxMy0w
Ni0xMi0yMTowODoyNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEwLjAtcmMzLTAwNDg1LWc0
MjNlMTE4Li4uLi4uCTEJMgk0Li4JNwk4LgkxMgkyMAkyOAkzMAkzMS4JMzUJMzcuLi4uLi4u
Li4JMzggU1VDQ0VTUwoKQmlzZWN0aW5nOiAxMTUgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDcgc3RlcHMpClszMjc1YjRkM2RiMWYwODdjNjdmYTExNWIx
NTBhOWQyZjlkODQyOWY5XSBzdGFnaW5nOiBjb21lZGk6IHBjbWFkOiB0aWR5IHVwIHBjbWFk
X2FpX2luc25fcmVhZCgpCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJv
b3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdmZzL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10
ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMyMi0wNjA5L2lpbzp0b2dy
ZWc6MzI3NWI0ZDNkYjFmMDg3YzY3ZmExMTViMTUwYTlkMmY5ZDg0MjlmOTpiaXNlY3QtdmZz
CgoyMDEzLTA2LTEyLTIxOjI0OjI5IDMyNzViNGQzZGIxZjA4N2M2N2ZhMTE1YjE1MGE5ZDJm
OWQ4NDI5ZjkgY29tcGlsaW5nCjE4OCByZWFsICAxNjA5IHVzZXIgIDExOCBzeXMgIDkxNC43
MSUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1jMjItMDYwOQoKMjAxMy0wNi0xMi0yMToyNzo0
NyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEwLjAtcmMzLTAwNjAwLWczMjc1YjRkLi4uIFRF
U1QgRkFJTFVSRQpkbWVzZy1rdm0tbGtwLW5leDA0LTE4Njc1LTIwMTMwNjEyMjAyMTAzLTMu
MTAuMC1yYzMtMDA2MDAtZzMyNzViNGQtOQpkbWVzZy1rdm0tbGtwLW5leDA0LTIzMTM3LTIw
MTMwNjEyMjAyMTA0LTMuMTAuMC1yYzMtMDA2MDAtZzMyNzViNGQtOQpkbWVzZy1rdm0tbGtw
LW5leDA0LTM1NTY4LTIwMTMwNjEyMjAyMTA0LTMuMTAuMC1yYzMtMDA2MDAtZzMyNzViNGQt
OQpkbWVzZy1rdm0teGJtLTI1Mzk4LTIwMTMwNjEyMjEzMDM3LTMuMTAuMC1yYzMtMDA2MDAt
ZzMyNzViNGQtOQoKQmlzZWN0aW5nOiA1NyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgNiBzdGVwcykKWzNlODQyZjczYzY4ZmU0NGU4NTY5MTA3Yjk0ZDcx
MGY0YmJkY2JiMWZdIHN0YWdpbmc6IG9jdGVvbi11c2I6IGZpeCBjaGVja3BhdGNoIGVycm9y
CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAv
aG9tZS93ZmcvdmZzL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUv
a3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMyMi0wNjA5L2lpbzp0b2dyZWc6M2U4NDJmNzNjNjhm
ZTQ0ZTg1NjkxMDdiOTRkNzEwZjRiYmRjYmIxZjpiaXNlY3QtdmZzCgoyMDEzLTA2LTEyLTIx
OjI5OjE4IDNlODQyZjczYzY4ZmU0NGU4NTY5MTA3Yjk0ZDcxMGY0YmJkY2JiMWYgY29tcGls
aW5nCjE3MiByZWFsICAxMzI1IHVzZXIgIDEwMCBzeXMgIDgyNS42OSUgY3B1IAl4ODZfNjQt
cmFuZGNvbmZpZy1jMjItMDYwOQoKMjAxMy0wNi0xMi0yMTozMjoyNyBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAzLjEwLjAtcmMzLTAwNTQyLWczZTg0MmY3Li4uLi4uCTEuLi4JNQk3Li4JOAkx
MQkxNAkxNQkxNgkxOS4uCTIwLi4uCTIyCTIzCTI0CTI3CTI4CTI5LgkzMAkzMwkzNQkzOCBT
VUNDRVNTCgpCaXNlY3Rpbmc6IDI4IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSA1IHN0ZXBzKQpbMTViYzg1YmRiNTA5OTAyZTY1ZmNmNDgxYzI4MzY5MDkz
MDk3ZDkyYV0gc3RhZ2luZzogY29tZWRpOiBwY21kYTEyOiB0aWR5IHVwIG11bHRpLWxpbmUg
Y29tbWVudHMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9ob21lL3dmZy92ZnMvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzIyLTA2MDkvaWlvOnRvZ3JlZzoxNWJj
ODViZGI1MDk5MDJlNjVmY2Y0ODFjMjgzNjkwOTMwOTdkOTJhOmJpc2VjdC12ZnMKCjIwMTMt
MDYtMTItMjE6NTA6NTggMTViYzg1YmRiNTA5OTAyZTY1ZmNmNDgxYzI4MzY5MDkzMDk3ZDky
YSBjb21waWxpbmcKMTc4IHJlYWwgIDEzMjkgdXNlciAgOTkgc3lzICA4MDEuNjMlIGNwdSAJ
eDg2XzY0LXJhbmRjb25maWctYzIyLTA2MDkKCjIwMTMtMDYtMTItMjE6NTQ6MDUgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgMy4xMC4wLXJjMy0wMDU3MS1nMTViYzg1Yi4uLi4uLi4uCTMJNAk2
Lgk4LgkxMi4uCTEzCTI1CTMxCTMyCTM0CTM1CTM3CTM4IFNVQ0NFU1MKCkJpc2VjdGluZzog
MTQgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDQgc3RlcHMp
CltlZTA0ZmQxMWYxMWZiNjdmZjBhZTQ4MmE2NzEwZjk3ZjQ5OWMxOWUyXSBSZXZlcnQgIlJl
dmVydCAic3RhZ2luZy9sdXN0cmU6IGRyb3AgQ09ORklHX0JST0tFTiBkZXBlbmRlbmN5IiIK
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9o
b21lL3dmZy92ZnMvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0veDg2XzY0LXJhbmRjb25maWctYzIyLTA2MDkvaWlvOnRvZ3JlZzplZTA0ZmQxMWYxMWZi
NjdmZjBhZTQ4MmE2NzEwZjk3ZjQ5OWMxOWUyOmJpc2VjdC12ZnMKCjIwMTMtMDYtMTItMjI6
MDY6MzcgZWUwNGZkMTFmMTFmYjY3ZmYwYWU0ODJhNjcxMGY5N2Y0OTljMTllMiBjb21waWxp
bmcKMTkxIHJlYWwgIDE2MTAgdXNlciAgMTE5IHN5cyAgOTAzLjMzJSBjcHUgCXg4Nl82NC1y
YW5kY29uZmlnLWMyMi0wNjA5CgoyMDEzLTA2LTEyLTIyOjA5OjU5IGRldGVjdGluZyBib290
IHN0YXRlIDMuMTAuMC1yYzMtMDA1ODUtZ2VlMDRmZDEuLiBURVNUIEZBSUxVUkUKZG1lc2ct
a3ZtLXhibS0yNTY0Ni0yMDEzMDYxMjIyMTIwNC0zLjEwLjAtcmMzLTAwNTg1LWdlZTA0ZmQx
LTEyCgpCaXNlY3Rpbmc6IDYgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChy
b3VnaGx5IDMgc3RlcHMpCls4OGU1YTkzNGQzODM2YjllYjk0OGI0NmY0MDIzNTdjNGMwZTBl
YWZlXSBzdGFnaW5nOiBydGw4MTkydTogcmVtb3ZlIHRyYWlsaW5nIHdoaXRlc3BhY2UgaW4g
cjgxOTJVX2NvcmUuYwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290
LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3Zmcy9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVz
dHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMjItMDYwOS9paW86dG9ncmVn
Ojg4ZTVhOTM0ZDM4MzZiOWViOTQ4YjQ2ZjQwMjM1N2M0YzBlMGVhZmU6YmlzZWN0LXZmcwoK
MjAxMy0wNi0xMi0yMjoxMTowMCA4OGU1YTkzNGQzODM2YjllYjk0OGI0NmY0MDIzNTdjNGMw
ZTBlYWZlIGNvbXBpbGluZwoxNjggcmVhbCAgMTMwOSB1c2VyICAxMDMgc3lzICA4MzcuNjcl
IGNwdSAJeDg2XzY0LXJhbmRjb25maWctYzIyLTA2MDkKCjIwMTMtMDYtMTItMjI6MTM6NTcg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMC4wLXJjMy0wMDU3OC1nODhlNWE5My4uLi4uLgky
CTkuCTEwCTE4CTI2CTM3Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTM4IFNVQ0NF
U1MKCkJpc2VjdGluZzogMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgMiBzdGVwcykKW2QyOWRjMmU0MThhN2E0YTVhNzc2NDE3ZGQzNTc0ZjNlOTE4MjQw
ODhdIHN0YWdpbmcvbHVzdHJlOiByZW1vdmUgbHVfY29udGV4dF9rZXlzX2R1bXAgYW5kIGx1
X2RlYnVnZ2luZ19zZXR1cApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3Zmcy9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwt
dGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMjItMDYwOS9paW86dG9n
cmVnOmQyOWRjMmU0MThhN2E0YTVhNzc2NDE3ZGQzNTc0ZjNlOTE4MjQwODg6YmlzZWN0LXZm
cwoKMjAxMy0wNi0xMi0yMjozNTo1OSBkMjlkYzJlNDE4YTdhNGE1YTc3NjQxN2RkMzU3NGYz
ZTkxODI0MDg4IGNvbXBpbGluZwoxODMgcmVhbCAgMTMzMiB1c2VyICAxMDYgc3lzICA3ODQu
NDIlIGNwdSAJeDg2XzY0LXJhbmRjb25maWctYzIyLTA2MDkKCjIwMTMtMDYtMTItMjI6Mzk6
MTUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMC4wLXJjMy0wMDU4MS1nZDI5ZGMyZS4uLi4u
CTIuCTUJOQkxMgkyMQkzMAkzMgkzNi4JMzggU1VDQ0VTUwoKQmlzZWN0aW5nOiAxIHJldmlz
aW9uIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKWzRhMWEwMWVh
NTJhZDNkOWJjMGFjMzZmNWE5NzM5ZDZjY2UwYmFlNzVdIHN0YWdpbmcvbHVzdHJlOiBzdXJy
b3VuZCBtb2R1bGVfcmVmY291bnQgd2l0aCBDT05GSUdfTU9EVUxFX1VOTE9BRApydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2Zn
L3Zmcy9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZf
NjQtcmFuZGNvbmZpZy1jMjItMDYwOS9paW86dG9ncmVnOjRhMWEwMWVhNTJhZDNkOWJjMGFj
MzZmNWE5NzM5ZDZjY2UwYmFlNzU6YmlzZWN0LXZmcwoKMjAxMy0wNi0xMi0yMjo0NzoxNyA0
YTFhMDFlYTUyYWQzZDliYzBhYzM2ZjVhOTczOWQ2Y2NlMGJhZTc1IGNvbXBpbGluZwoxNzcg
cmVhbCAgMTMxNyB1c2VyICAxMDMgc3lzICA4MDEuMTMlIGNwdSAJeDg2XzY0LXJhbmRjb25m
aWctYzIyLTA2MDkKCjIwMTMtMDYtMTItMjI6NTA6MjYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
My4xMC4wLXJjMy0wMDU4My1nNGExYTAxZS4uLi4uLi4uLgkxCTE2CTM2LgkzOCBTVUNDRVNT
CgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3Vn
aGx5IDAgc3RlcHMpCls5Yzc4MmRhNGYwOWQ3NjY1ZWI2MGI3MGRkODMyODBiNmE4MTk4NTdm
XSBzdGFnaW5nL2x1c3RyZS9saWJjZnM6IGNsZWFudXAgbGludXgtY3J5cHRvCnJ1bm5pbmcg
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcv
dmZzL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82
NC1yYW5kY29uZmlnLWMyMi0wNjA5L2lpbzp0b2dyZWc6OWM3ODJkYTRmMDlkNzY2NWViNjBi
NzBkZDgzMjgwYjZhODE5ODU3ZjpiaXNlY3QtdmZzCgoyMDEzLTA2LTEyLTIyOjU3OjI5IDlj
NzgyZGE0ZjA5ZDc2NjVlYjYwYjcwZGQ4MzI4MGI2YTgxOTg1N2YgY29tcGlsaW5nCjE3MiBy
ZWFsICAxMzMyIHVzZXIgIDEwNiBzeXMgIDgzNi4wMiUgY3B1IAl4ODZfNjQtcmFuZGNvbmZp
Zy1jMjItMDYwOQoKMjAxMy0wNi0xMi0yMzowMDozNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAz
LjEwLjAtcmMzLTAwNTg0LWc5Yzc4MmRhLi4uLi4uCTMJOAkxNAkxOAkyNwkyOQkzNQkzNy4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSAx
G1swbQouLi4uLi4JMzggU1VDQ0VTUwoKZWUwNGZkMTFmMTFmYjY3ZmYwYWU0ODJhNjcxMGY5
N2Y0OTljMTllMiBpcyB0aGUgZmlyc3QgYmFkIGNvbW1pdApjb21taXQgZWUwNGZkMTFmMTFm
YjY3ZmYwYWU0ODJhNjcxMGY5N2Y0OTljMTllMgpBdXRob3I6IFBlbmcgVGFvIDxiZXJnd29s
ZkBnbWFpbC5jb20+CkRhdGU6ICAgVGh1IEp1biA2IDIyOjU5OjE0IDIwMTMgKzA4MDAKCiAg
ICBSZXZlcnQgIlJldmVydCAic3RhZ2luZy9sdXN0cmU6IGRyb3AgQ09ORklHX0JST0tFTiBk
ZXBlbmRlbmN5IiIKICAgIAogICAgVGhpcyByZXZlcnRzIGNvbW1pdCAzN2Q0MDkzZmQzNDc3
NWJiYmY5OWJkZGI4NGE3MTFiZGIzZWM2ZDVjLgogICAgCiAgICBJJ3ZlIHZlcmlmaWVkIHRo
YXQgd2Ugbm93IGRvbid0IGJyZWFrIGJ1aWxkIG9uIFg4Nl82NCBhbGxtb2Rjb25maWcuCiAg
ICAKICAgIENjOiBTdGVwaGVuIFJvdGh3ZWxsIDxzZnJAY2FuYi5hdXVnLm9yZy5hdT4KICAg
IFNpZ25lZC1vZmYtYnk6IFBlbmcgVGFvIDx0YW8ucGVuZ0BlbWMuY29tPgogICAgU2lnbmVk
LW9mZi1ieTogQW5kcmVhcyBEaWxnZXIgPGFuZHJlYXMuZGlsZ2VyQGludGVsLmNvbT4KICAg
IFNpZ25lZC1vZmYtYnk6IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRh
dGlvbi5vcmc+Cgo6MDQwMDAwIDA0MDAwMCBlMmRiNzM4OTRjYWE5MzgzOTYyOTYwZjJjNzFm
YTc0M2IyNTM0MGI2IDdjZDRhNTFmZGY4NDA5NTIzZGJlNjljZWFhODFiMTc0YzkwOTk4YTgg
TQlkcml2ZXJzCmJpc2VjdCBydW4gc3VjY2VzcwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1x
dWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzIyLTA2MDkvaWlvOnRvZ3JlZzo5Yzc4MmRh
NGYwOWQ3NjY1ZWI2MGI3MGRkODMyODBiNmE4MTk4NTdmOmJpc2VjdC12ZnMKCjIwMTMtMDYt
MTMtMDE6NDE6NTAgOWM3ODJkYTRmMDlkNzY2NWViNjBiNzBkZDgzMjgwYjZhODE5ODU3ZiBy
ZXVzZSAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyMi0wNjA5LzljNzgyZGE0ZjA5ZDc2
NjVlYjYwYjcwZGQ4MzI4MGI2YTgxOTg1N2Yvdm1saW51ei0zLjEwLjAtcmMzLTAwNTg0LWc5
Yzc4MmRhCgoyMDEzLTA2LTEzLTAxOjQxOjUwIGRldGVjdGluZyBib290IHN0YXRlIC4uLi4u
CTM5CTQzCTc0CTk1CTEwOS4JMTEyLi4uCTExMy4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSAxG1swbQouLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTExNCBT
VUNDRVNTCgpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRj
b25maWctYzIyLTA2MDkvaWlvOnRvZ3JlZzplNzY0ZGY2Nzk2Mzk0MGI0MTIzMzI1NzEwNTM2
YTk0NzFkMWUyNGFlOmJpc2VjdC12ZnMKIFRFU1QgRkFJTFVSRQova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWMyMi0wNjA5L2U3NjRkZjY3OTYzOTQwYjQxMjMzMjU3MTA1MzZhOTQ3MWQx
ZTI0YWUvZG1lc2cta3ZtLWF0aGVucy0xNjU2Ni0yMDEzMDYxMjE5MTQwNi0zLjEwLjAtcmM1
LTAwNjc4LWdlNzY0ZGY2LTc4Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzIyLTA2MDkv
ZTc2NGRmNjc5NjM5NDBiNDEyMzMyNTcxMDUzNmE5NDcxZDFlMjRhZS9kbWVzZy1rdm0tYmF5
LTI4MzQyLTIwMTMwNjEwMDU1NzA1LTMuMTAuMC1yYzUtMDA2NzgtZ2U3NjRkZjYtNzgKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjItMDYwOS9lNzY0ZGY2Nzk2Mzk0MGI0MTIzMzI1
NzEwNTM2YTk0NzFkMWUyNGFlL2RtZXNnLWt2bS1iZW5zLTc3MTItMjAxMzA2MTIxOTEyMjkt
My4xMC4wLXJjNS0wMDY3OC1nZTc2NGRmNi03OAova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWMyMi0wNjA5L2U3NjRkZjY3OTYzOTQwYjQxMjMzMjU3MTA1MzZhOTQ3MWQxZTI0YWUvZG1l
c2cta3ZtLXJvYW0tMTQ3NTEtMjAxMzA2MTAwNTU0NTUtMy4xMC4wLXJjNS0wMDY3OC1nZTc2
NGRmNi03OAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyMi0wNjA5L2U3NjRkZjY3OTYz
OTQwYjQxMjMzMjU3MTA1MzZhOTQ3MWQxZTI0YWUvZG1lc2cta3ZtLXJvYW0tMjI1MjItMjAx
MzA2MTAwNTU0NDQtMy4xMC4wLXJjNS0wMDY3OC1nZTc2NGRmNi03OAova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWMyMi0wNjA5L2U3NjRkZjY3OTYzOTQwYjQxMjMzMjU3MTA1MzZhOTQ3
MWQxZTI0YWUvZG1lc2cta3ZtLXJvYW0tMjU3Ny0yMDEzMDYxMDA1NTUxOC0zLjEwLjAtcmM1
LTAwNjc4LWdlNzY0ZGY2LTc4Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzIyLTA2MDkv
ZTc2NGRmNjc5NjM5NDBiNDEyMzMyNTcxMDUzNmE5NDcxZDFlMjRhZS9kbWVzZy1rdm0tcm9h
bS0yNTg1OS0yMDEzMDYxMDA1NTQ1OC0zLjEwLjAtcmM1LTAwNjc4LWdlNzY0ZGY2LTc4Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzIyLTA2MDkvZTc2NGRmNjc5NjM5NDBiNDEyMzMy
NTcxMDUzNmE5NDcxZDFlMjRhZS9kbWVzZy1rdm0tcm9hbS00ODgyLTIwMTMwNjEwMDU1NTAw
LTMuMTAuMC1yYzUtMDA2NzgtZ2U3NjRkZjYtNzgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1jMjItMDYwOS9lNzY0ZGY2Nzk2Mzk0MGI0MTIzMzI1NzEwNTM2YTk0NzFkMWUyNGFlL2Rt
ZXNnLWt2bS1yb2FtLTUwNzktMjAxMzA2MTAwNTU1MDEtMy4xMC4wLXJjNS0wMDY3OC1nZTc2
NGRmNi03OAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyMi0wNjA5L2U3NjRkZjY3OTYz
OTQwYjQxMjMzMjU3MTA1MzZhOTQ3MWQxZTI0YWUvZG1lc2cta3ZtLXNuYi01MDQ5My0yMDEz
MDYxMDA1NTc1NC0zLjEwLjAtcmM1LTAwNjc4LWdlNzY0ZGY2LTc4Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctYzIyLTA2MDkvZTc2NGRmNjc5NjM5NDBiNDEyMzMyNTcxMDUzNmE5NDcx
ZDFlMjRhZS9kbWVzZy1rdm0tdnAtMjY1NzMtMjAxMzA2MTIxOTE2MjAtMy4xMC4wLXJjNS0w
MDY3OC1nZTc2NGRmNi03OAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyMi0wNjA5L2U3
NjRkZjY3OTYzOTQwYjQxMjMzMjU3MTA1MzZhOTQ3MWQxZTI0YWUvZG1lc2cta3ZtLXZwLTI2
NjQzLTIwMTMwNjEyMTkxNTQ5LTMuMTAuMC1yYzUtMDA2NzgtZ2U3NjRkZjYtNzgKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1jMjItMDYwOS9lNzY0ZGY2Nzk2Mzk0MGI0MTIzMzI1NzEw
NTM2YTk0NzFkMWUyNGFlL2RtZXNnLWt2bS12cC0yNjgwNy0yMDEzMDYxMjE5MTU1Mi0zLjEw
LjAtcmM1LTAwNjc4LWdlNzY0ZGY2LTc4Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzIy
LTA2MDkvZTc2NGRmNjc5NjM5NDBiNDEyMzMyNTcxMDUzNmE5NDcxZDFlMjRhZS9kbWVzZy1r
dm0tdnAtMjcyOTYtMjAxMzA2MTIxODU1NDItMy4xMC4wLXJjNS0wMDY3OC1nZTc2NGRmNi03
OAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyMi0wNjA5L2U3NjRkZjY3OTYzOTQwYjQx
MjMzMjU3MTA1MzZhOTQ3MWQxZTI0YWUvZG1lc2cta3ZtLXZwLTI3MzIzLTIwMTMwNjEyMTg1
NTMyLTMuMTAuMC1yYzUtMDA2NzgtZ2U3NjRkZjYtNzgKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1jMjItMDYwOS9lNzY0ZGY2Nzk2Mzk0MGI0MTIzMzI1NzEwNTM2YTk0NzFkMWUyNGFl
L2RtZXNnLWt2bS12cC0yNzc2MS0yMDEzMDYxMjE4NTUzNi0zLjEwLjAtcmM1LTAwNjc4LWdl
NzY0ZGY2LTc4Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzIyLTA2MDkvZTc2NGRmNjc5
NjM5NDBiNDEyMzMyNTcxMDUzNmE5NDcxZDFlMjRhZS9kbWVzZy1rdm0tdnAtMjkwMzktMjAx
MzA2MTIxOTE2MjMtMy4xMC4wLXJjNS0wMDY3OC1nZTc2NGRmNi03OAova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWMyMi0wNjA5L2U3NjRkZjY3OTYzOTQwYjQxMjMzMjU3MTA1MzZhOTQ3
MWQxZTI0YWUvZG1lc2cta3ZtLXZwLTMwOTA3LTIwMTMwNjEyMTg1NTQ2LTMuMTAuMC1yYzUt
MDA2NzgtZ2U3NjRkZjYtNzgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjItMDYwOS9l
NzY0ZGY2Nzk2Mzk0MGI0MTIzMzI1NzEwNTM2YTk0NzFkMWUyNGFlL2RtZXNnLWt2bS12cC0z
MjczMy0yMDEzMDYxMjE5MTYwOC0zLjEwLjAtcmM1LTAwNjc4LWdlNzY0ZGY2LTc4Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctYzIyLTA2MDkvZTc2NGRmNjc5NjM5NDBiNDEyMzMyNTcx
MDUzNmE5NDcxZDFlMjRhZS9kbWVzZy1rdm0tdnAtMzYzODctMjAxMzA2MTIxOTE2MzEtMy4x
MC4wLXJjNS0wMDY3OC1nZTc2NGRmNi03OAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMy
Mi0wNjA5L2U3NjRkZjY3OTYzOTQwYjQxMjMzMjU3MTA1MzZhOTQ3MWQxZTI0YWUvZG1lc2ct
a3ZtLXZwLTM4MTA4LTIwMTMwNjEyMTg1NTU5LTMuMTAuMC1yYzUtMDA2NzgtZ2U3NjRkZjYt
NzgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjItMDYwOS9lNzY0ZGY2Nzk2Mzk0MGI0
MTIzMzI1NzEwNTM2YTk0NzFkMWUyNGFlL2RtZXNnLWt2bS13YWltZWEtMjc2OTYtMjAxMzA2
MTIxOTE2MzktMy4xMC4wLXJjNS0wMDY3OC1nZTc2NGRmNi03OAova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWMyMi0wNjA5L2U3NjRkZjY3OTYzOTQwYjQxMjMzMjU3MTA1MzZhOTQ3MWQx
ZTI0YWUvZG1lc2cta3ZtLXdhaW1lYS0yODE5MC0yMDEzMDYxMjE5MTYyNy0zLjEwLjAtcmM1
LTAwNjc4LWdlNzY0ZGY2LTc4Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzIyLTA2MDkv
ZTc2NGRmNjc5NjM5NDBiNDEyMzMyNTcxMDUzNmE5NDcxZDFlMjRhZS9kbWVzZy1rdm0td2Fp
bWVhLTM3ODUtMjAxMzA2MTIxOTE2NDktMy4xMC4wLXJjNS0wMDY3OC1nZTc2NGRmNi03OAov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMyMi0wNjA5L2U3NjRkZjY3OTYzOTQwYjQxMjMz
MjU3MTA1MzZhOTQ3MWQxZTI0YWUvZG1lc2cta3ZtLXhibS0yNTAxMC0yMDEzMDYxMjE5MTUy
OS0zLjEwLjAtcmM1LTAwNjc4LWdlNzY0ZGY2LTc4Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctYzIyLTA2MDkvZTc2NGRmNjc5NjM5NDBiNDEyMzMyNTcxMDUzNmE5NDcxZDFlMjRhZS9k
bWVzZy1rdm0teGJtLTI1NDc0LTIwMTMwNjEyMTkyNTM4LTMuMTAuMC1yYzUtMDA2NzgtZ2U3
NjRkZjYtNzgKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMjItMDYwOS9lNzY0ZGY2Nzk2
Mzk0MGI0MTIzMzI1NzEwNTM2YTk0NzFkMWUyNGFlL2RtZXNnLWt2bS14Z3dvLTE5NzY2LTIw
MTMwNjEwMDU1NDA5LTMuMTAuMC1yYzUtMDA2NzgtZ2U3NjRkZjYtNzgKCltkZXRhY2hlZCBI
RUFEIGJlNjJiOThdIFJldmVydCAiUmV2ZXJ0ICJSZXZlcnQgInN0YWdpbmcvbHVzdHJlOiBk
cm9wIENPTkZJR19CUk9LRU4gZGVwZW5kZW5jeSIiIgogMSBmaWxlIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMjItMDYwOS9paW86dG9ncmVnOmJlNjJiOThjMzI3
YmVkM2Q0Yjc0OWU1M2I1MGJlYWQ1NTEwYWExMWY6YmlzZWN0LXZmcwoKMjAxMy0wNi0xMy0w
NToyMTozNiBiZTYyYjk4YzMyN2JlZDNkNGI3NDllNTNiNTBiZWFkNTUxMGFhMTFmIGNvbXBp
bGluZwoKMjAxMy0wNi0xMy0wNToyNTowMiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEwLjAt
cmM1LTAwNjc5LWdiZTYyYjk4Li4uLi4uLgkxCTIJNAk4CTEyCTEzLgkxNi4uLgkyNAkyOAkz
MS4uCTMzCTM0CTM1Li4JMzgJNDAJNDMJNDQJNDkJNjAuCTYxCTY5CTc3CTg1CTg5CTkwCTk1
CTEwMwkxMDUuLgkxMDYJMTA4CTExMgkxMTQgU1VDQ0VTUwoKCj09PT09PT09PSB1cHN0cmVh
bSA9PT09PT09PT0KRmV0Y2hpbmcgbGludXMKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMyMi0wNjA5L2lpbzp0b2dyZWc6MWE5YzNkNjhk
NjVmNGI1Y2UzMmY3ZDY3Y2NjNzMwMzk2ZTA0Y2RkMjpiaXNlY3QtdmZzCgoyMDEzLTA2LTEz
LTA1OjUwOjA3IDFhOWMzZDY4ZDY1ZjRiNWNlMzJmN2Q2N2NjYzczMDM5NmUwNGNkZDIgY29t
cGlsaW5nCgoyMDEzLTA2LTEzLTA1OjUzOjIwIGRldGVjdGluZyBib290IHN0YXRlIDMuMTAu
MC1yYzUtMDAwODQtZzFhOWMzZDYuLi4uLi4JMS4JNAk2CTExCTE5Li4JMjAJMjIJMzIJMzYu
LgkzNy4JNDAuCTQxCTQzCTQ1CTQ2CTQ3CTQ5CTU1CTU3Lgk1OS4JNjAJNjcuCTY4CTc1CTc5
CTgxCTgyCTg5CTkyCTkzLgk5NAk5NwkxMDEJMTAyLgkxMDMJMTEzCTExNCBTVUNDRVNTCgoK
PT09PT09PT09IGxpbnV4LW5leHQgPT09PT09PT09CkZldGNoaW5nIG5leHQKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMyMi0wNjA5L2lp
bzp0b2dyZWc6YzA0ZWZlZDczNDQwOWY1YTQ0NzE1YjU0YTZjYTFiNTRiMGNjZjIxNTpiaXNl
Y3QtdmZzCgoyMDEzLTA2LTEzLTA2OjIxOjEyIGMwNGVmZWQ3MzQ0MDlmNWE0NDcxNWI1NGE2
Y2ExYjU0YjBjY2YyMTUgY29tcGlsaW5nCgoyMDEzLTA2LTEzLTA2OjI0OjM1IGRldGVjdGlu
ZyBib290IHN0YXRlIDMuMTAuMC1yYzQtbmV4dC0yMDEzMDYwNy0wNTAwMS1nYzA0ZWZlZC4u
Li4uLgkxCTQJOQkxNAkxOS4JMjMJMjYJMjcJMjkuCTMxCTM0LgkzNwkzOAk0Mgk0NQk0Nwk0
OAk0OQk1Mwk1OAk1OQk2NAk2OAk3Mwk3Ngk4MQk4Mgk4Nwk5Mwk5NS4JOTYJMTAxCTEwNgkx
MDkuLgkxMTAJMTEzCTExNCBTVUNDRVNTCgo=

--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.10.0-rc5 Kernel Configuration
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
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
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
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
CONFIG_AUDIT_LOGINUID_IMMUTABLE=y
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
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
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ_FULL is not set
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
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
# CONFIG_RCU_USER_QS is not set
CONFIG_CONTEXT_TRACKING_FORCE=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_RCU_FAST_NO_HZ is not set
CONFIG_TREE_RCU_TRACE=y
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
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HOTPLUG=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
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
CONFIG_USE_GENERIC_SMP_HELPERS=y
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
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLK_DEV_THROTTLING=y

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
# CONFIG_HYPERVISOR_GUEST is not set
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
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_I8K=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
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
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_HWPOISON_INJECT is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_HOTPLUG_CPU is not set
CONFIG_COMPAT_VDSO=y
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
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
CONFIG_X86_X32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_KEYS_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_USER is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
# CONFIG_IP_MULTIPLE_TABLES is not set
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
CONFIG_NET_IPGRE=y
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
CONFIG_NET_IPVTI=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_INET_UDP_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=y
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=y
CONFIG_TCP_CONG_SCALABLE=y
CONFIG_TCP_CONG_LP=y
CONFIG_TCP_CONG_VENO=y
CONFIG_TCP_CONG_YEAH=y
CONFIG_TCP_CONG_ILLINOIS=y
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_HYBLA is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_VENO is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=y

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
# CONFIG_IP_DCCP_CCID3 is not set

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
# CONFIG_IP_SCTP is not set
CONFIG_RDS=y
CONFIG_RDS_TCP=y
CONFIG_RDS_DEBUG=y
CONFIG_TIPC=y
CONFIG_TIPC_PORTS=8191
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
CONFIG_ATM_CLIP_NO_ICMP=y
CONFIG_ATM_LANE=y
CONFIG_ATM_MPOA=y
CONFIG_ATM_BR2684=y
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=y
# CONFIG_L2TP_DEBUGFS is not set
# CONFIG_L2TP_V3 is not set
CONFIG_STP=y
CONFIG_MRP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_IPDDP=y
# CONFIG_IPDDP_ENCAP is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
CONFIG_PHONET=y
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_BLA=y
CONFIG_BATMAN_ADV_DAT=y
# CONFIG_BATMAN_ADV_NC is not set
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
CONFIG_XPS=y
CONFIG_NETPRIO_CGROUP=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
# CONFIG_NET_DROP_MONITOR is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=y
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
# CONFIG_CAN_SLCAN is not set
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_NET_9P=y
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=y
CONFIG_CEPH_LIB_PRETTYDEBUG=y
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

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
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
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
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
CONFIG_BLK_DEV_DRBD=y
CONFIG_DRBD_FAULT_INJECTION=y
CONFIG_BLK_DEV_NBD=y
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
CONFIG_ATA_OVER_ETH=y
CONFIG_BLK_DEV_HD=y
CONFIG_BLK_DEV_RBD=y
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29020=y
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_SRAM=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
# CONFIG_CB710_CORE is not set

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
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
CONFIG_BLK_DEV_PLATFORM=y
# CONFIG_BLK_DEV_CMD640 is not set
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
# CONFIG_BLK_DEV_IDEDMA is not set

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
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MD_MULTIPATH=y
# CONFIG_MD_FAULTY is not set
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=y
CONFIG_DM_BIO_PRISON=y
CONFIG_DM_PERSISTENT_DATA=y
CONFIG_DM_CRYPT=y
# CONFIG_DM_SNAPSHOT is not set
CONFIG_DM_THIN_PROVISIONING=y
# CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
# CONFIG_DM_CACHE is not set
CONFIG_DM_MIRROR=y
# CONFIG_DM_RAID is not set
CONFIG_DM_LOG_USERSPACE=y
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
CONFIG_DM_MULTIPATH_QL=y
CONFIG_DM_MULTIPATH_ST=y
CONFIG_DM_DELAY=y
# CONFIG_DM_UEVENT is not set
CONFIG_DM_FLAKEY=y
CONFIG_DM_VERITY=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
# CONFIG_INPUT_SPARSEKMAP is not set
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
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
# CONFIG_MOUSE_PS2_SYNAPTICS is not set
# CONFIG_MOUSE_PS2_CYPRESS is not set
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
CONFIG_MOUSE_PS2_TOUCHKIT=y
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
CONFIG_MOUSE_VSXXXAA=y
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=y
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
CONFIG_JOYSTICK_TMDC=y
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=y
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=y
CONFIG_JOYSTICK_GAMECON=y
# CONFIG_JOYSTICK_TURBOGRAFX is not set
# CONFIG_JOYSTICK_AS5011 is not set
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_JOYSTICK_WALKERA0701=y
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
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
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

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
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
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
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
# CONFIG_PPDEV is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_ST33_I2C is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
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
CONFIG_I2C_CBUS_GPIO=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set

#
# Qualcomm MSM SSBI bus support
#
CONFIG_SSBI=y
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
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_TS5500=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_RC5T583=y
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_STMPE=y
# CONFIG_GPIO_TC3589X is not set
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_WM8350=y
CONFIG_GPIO_WM8994=y
# CONFIG_GPIO_ADP5588 is not set

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
CONFIG_GPIO_MCP23S08=y

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_TPS6586X is not set

#
# USB GPIO expanders:
#
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_MAX8925_POWER=y
CONFIG_WM831X_BACKUP=y
# CONFIG_WM831X_POWER is not set
# CONFIG_WM8350_POWER is not set
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=y
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=y
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
# CONFIG_CHARGER_PCF50633 is not set
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_LP8788=y
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_SMB347=y
# CONFIG_BATTERY_GOLDFISH is not set
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IIO_HWMON=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=y
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1275=y
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
# CONFIG_SENSORS_MAX8688 is not set
# CONFIG_SENSORS_UCD9000 is not set
# CONFIG_SENSORS_UCD9200 is not set
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_DME1737=y
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=y
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
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_WM831X is not set
CONFIG_SENSORS_WM8350=y
CONFIG_SENSORS_APPLESMC=y

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
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
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
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_GPIO is not set
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_ANATOP is not set
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
# CONFIG_REGULATOR_MAX77686 is not set
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_LP8788=y
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_RC5T583=y
# CONFIG_REGULATOR_TPS51632 is not set
# CONFIG_REGULATOR_TPS6105X is not set
CONFIG_REGULATOR_TPS62360=y
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65217=y
# CONFIG_REGULATOR_TPS6586X is not set
CONFIG_REGULATOR_WM831X=y
# CONFIG_REGULATOR_WM8350 is not set
# CONFIG_REGULATOR_WM8994 is not set
CONFIG_REGULATOR_AS3711=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#

#
# Customise DVB Frontends
#
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
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
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
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_HDMI=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
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
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
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
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
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
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_SM501=y
CONFIG_FB_GOLDFISH=y
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
# CONFIG_BACKLIGHT_PWM is not set
# CONFIG_BACKLIGHT_MAX8925 is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP8860=y
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_PCF50633 is not set
# CONFIG_BACKLIGHT_LM3630 is not set
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_LP8788=y
# CONFIG_BACKLIGHT_TPS65217 is not set
# CONFIG_BACKLIGHT_AS3711 is not set
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
# CONFIG_LOGO_LINUX_CLUT224 is not set
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_SND is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
CONFIG_HID_KEYTOUCH=y
# CONFIG_HID_KYE is not set
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
# CONFIG_HID_LOGITECH is not set
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_PS3REMOTE is not set
CONFIG_HID_SAITEK=y
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SPEEDLINK=y
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
# CONFIG_HID_WIIMOTE_EXT is not set
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# I2C HID support
#
CONFIG_I2C_HID=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
# CONFIG_MSPRO_BLOCK is not set

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
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8788=y
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA9633 is not set
CONFIG_LEDS_WM831X_STATUS=y
# CONFIG_LEDS_WM8350 is not set
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
# CONFIG_LEDS_BLINKM is not set

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
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_LEDS_TRIGGER_CAMERA=y
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_DW_DMAC is not set
CONFIG_TIMB_DMA=y
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set
# CONFIG_VIRT_DRIVERS is not set

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
CONFIG_ECHO=y
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
CONFIG_PANEL_CHANGE_MESSAGE=y
CONFIG_PANEL_BOOT_MESSAGE=""
# CONFIG_DX_SEP is not set

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
CONFIG_AD7606=y
CONFIG_AD7606_IFACE_PARALLEL=y
CONFIG_AD799X=y
CONFIG_AD799X_RING_BUFFER=y

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=y
# CONFIG_ADT7316_I2C is not set

#
# Capacitance to digital converters
#
CONFIG_AD7150=y
CONFIG_AD7152=y
CONFIG_AD7746=y

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
# CONFIG_SENSORS_ISL29018 is not set
CONFIG_SENSORS_ISL29028=y
# CONFIG_TSL2583 is not set
# CONFIG_TSL2x7x is not set

#
# Magnetometer sensors
#
# CONFIG_SENSORS_HMC5843 is not set

#
# Active energy metering IC
#
CONFIG_ADE7854=y
CONFIG_ADE7854_I2C=y

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
CONFIG_ZSMALLOC=y
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_FT1000=y

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_NET_VENDOR_SILICOM is not set
CONFIG_LUSTRE_FS=y
CONFIG_LUSTRE_OBD_MAX_IOCTL_BUFFER=8192
# CONFIG_LUSTRE_DEBUG_EXPENSIVE_CHECK is not set
CONFIG_LNET=y
CONFIG_LNET_MAX_PAYLOAD=1048576
# CONFIG_LNET_SELFTEST is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
# CONFIG_EXTCON is not set
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
CONFIG_HID_SENSOR_ACCEL_3D=y

#
# Analog to digital converters
#
CONFIG_LP8788_ADC=y
# CONFIG_MAX1363 is not set
# CONFIG_TI_ADC081C is not set
CONFIG_TI_AM335X_ADC=y

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
# CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS is not set

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
# CONFIG_AD5380 is not set
# CONFIG_AD5446 is not set
CONFIG_MAX517=y
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
CONFIG_HID_SENSOR_GYRO_3D=y
CONFIG_ITG3200=y

#
# Inertial measurement units
#

#
# Light sensors
#
CONFIG_ADJD_S311=y
CONFIG_SENSORS_LM3533=y
CONFIG_SENSORS_TSL2563=y
CONFIG_VCNL4000=y
# CONFIG_HID_SENSOR_ALS is not set

#
# Magnetometer sensors
#
CONFIG_AK8975=y
CONFIG_HID_SENSOR_MAGNETOMETER_3D=y

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y

#
# Pressure Sensors
#
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
# CONFIG_GOOGLE_SMI is not set
CONFIG_GOOGLE_MEMCONSOLE=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
# CONFIG_EXT3_FS_SECURITY is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4_USE_FOR_EXT23 is not set
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
CONFIG_XFS_WARN=y
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=y
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
CONFIG_BTRFS_DEBUG=y
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
CONFIG_FSCACHE_DEBUG=y
CONFIG_FSCACHE_OBJECT_LIST=y
CONFIG_CACHEFILES=y
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
# CONFIG_SYSFS is not set
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
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
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_LIST=y
CONFIG_TEST_LIST_SORT=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set

#
# RCU Debugging
#
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_BLOCK_EXT_DEVT=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_LKDTM=y
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
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
# CONFIG_FUNCTION_GRAPH_TRACER is not set
CONFIG_IRQSOFF_TRACER=y
# CONFIG_SCHED_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_EVENT_TRACE_TEST_SYSCALLS=y
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=y
CONFIG_RING_BUFFER_STARTUP_TEST=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_ASYNC_RAID6_TEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
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
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
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
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
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
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
# CONFIG_CRYPTO_BLOWFISH_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
# CONFIG_CRYPTO_DES is not set
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y
CONFIG_CRYPTO_TWOFISH_AVX2_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
# CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
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
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_LRU_CACHE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
CONFIG_DDR=y
# CONFIG_ATA_SFF is not set
# CONFIG_DRM_TTM is not set
# CONFIG_ISDN_DRV_LOOP is not set
# CONFIG_PCI_ATS is not set

--GvXjxJ+pjyke8COw--
