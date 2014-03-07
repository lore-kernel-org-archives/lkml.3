Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbaCGVxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 16:53:25 -0500
Received: from mga14.intel.com ([143.182.124.37]:30536 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbaCGVxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 16:53:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,610,1389772800"; 
   d="log'?scan'208";a="488181360"
Date: Sat, 8 Mar 2014 05:52:58 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [drm] WARNING: CPU: 0 PID: 0 at kernel/locking/mutex.c:516
 mutex_lock_nested()
Message-ID: <20140307215258.GA9286@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi David,

I got the below dmesg and the first bad commit is

git://people.freedesktop.org/~dvdhrm/linux drm-log
commit 06bdc9aa3cd3a045b4a94bdc4c6c582338cf7992
Author:     David Herrmann <dh.herrmann@gmail.com>
AuthorDate: Wed Mar 5 17:34:49 2014 +0100
Commit:     David Herrmann <dh.herrmann@gmail.com>
CommitDate: Fri Mar 7 11:50:20 2014 +0100

    drm: add kernel-log renderer
    
+-----------------------------------------------------------------------------+------------+------------+------------+
|                                                                             | 32afb1337b | 06bdc9aa3c | 05ffd9cb67 |
+-----------------------------------------------------------------------------+------------+------------+------------+
| boot_successes                                                              | 56         | 0          | 0          |
| boot_failures                                                               | 4          | 20         | 19         |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference                        | 1          |            |            |
| Oops:SMP                                                                    | 1          |            |            |
| EIP_is_at_reset_interrupt                                                   | 1          |            |            |
| Kernel_panic-not_syncing:Fatal_exception                                    | 1          |            |            |
| WARNING:CPU:PID:at_arch/x86/kernel/cpu/amd.c:init_amd()                     | 3          | 0          | 2          |
| backtrace:init_amd                                                          | 3          | 0          | 2          |
| backtrace:warn_slowpath_fmt                                                 | 3          | 0          | 2          |
| WARNING:CPU:PID:at_kernel/locking/mutex.c:mutex_lock_nested()               | 0          | 7          | 8          |
| BUG:sleeping_function_called_from_invalid_context_at_kernel/locking/mutex.c | 0          | 20         | 19         |
| INFO:lockdep_is_turned_off                                                  | 0          | 7          | 10         |
| backtrace:ring_buffer_consumer_thread                                       | 0          | 2          | 1          |
| backtrace:vfs_read                                                          | 0          | 15         | 13         |
| backtrace:SyS_read                                                          | 0          | 15         | 13         |
| backtrace:cpu_startup_entry                                                 | 0          | 5          | 6          |
| backtrace:serio_handle_event                                                | 0          | 5          | 6          |
| backtrace:ring_buffer_producer_thread                                       | 0          | 0          | 1          |
| backtrace:do_group_exit                                                     | 0          | 0          | 1          |
| backtrace:SyS_exit_group                                                    | 0          | 0          | 1          |
+-----------------------------------------------------------------------------+------------+------------+------------+

[   12.906820] ... PIC ELCR: 0c00
[   12.909878] printing local APIC contents on CPU#0/0:
[   12.910508] ------------[ cut here ]------------
[   12.910521] WARNING: CPU: 0 PID: 0 at kernel/locking/mutex.c:516 mutex_lock_nested+0xc7/0x430()
[   12.910523] DEBUG_LOCKS_WARN_ON(in_interrupt())
[   12.910524] Modules linked in:
[   12.910532] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc5-00558-g05ffd9c #230
[   12.910539]  00000000 00000000 79c05d64 798860ec 79c05da4 79c05d94 790414ee 79b1a074
[   12.910544]  79c05dc0 00000000 79b1fbf8 00000204 79892017 79892017 79c499a0 00000001
[   12.910549]  79c096e0 79c05dac 79041543 00000009 79c05da4 79b1a074 79c05dc0 79c05e08
[   12.910550] Call Trace:
[   12.910557]  [<798860ec>] dump_stack+0x48/0x60
[   12.910566]  [<790414ee>] warn_slowpath_common+0x7e/0xa0
[   12.910570]  [<79892017>] ? mutex_lock_nested+0xc7/0x430
[   12.910572]  [<79892017>] ? mutex_lock_nested+0xc7/0x430
[   12.910577]  [<79041543>] warn_slowpath_fmt+0x33/0x40
[   12.910579]  [<79892017>] mutex_lock_nested+0xc7/0x430
[   12.910592]  [<7939d718>] ? io_serial_in+0x8/0x20
[   12.910595]  [<7939e3a2>] ? wait_for_xmitr+0x22/0x90
[   12.910606]  [<793d7744>] ? drm_log_write+0xb4/0xe0
[   12.910613]  [<79093ac2>] ? do_raw_spin_unlock+0xb2/0xe0
[   12.910616]  [<793d7700>] ? drm_log_write+0x70/0xe0
[   12.910618]  [<793d7744>] drm_log_write+0xb4/0xe0
[   12.910621]  [<7939e50a>] ? serial8250_console_write+0xfa/0x120
[   12.910623]  [<7939e530>] ? serial8250_console_write+0x120/0x120
[   12.910627]  [<793d7783>] dlog_con_write+0x13/0x20
[   12.910630]  [<79097a53>] call_console_drivers.constprop.8+0x133/0x1b0
[   12.910633]  [<79098018>] console_unlock+0x328/0x4c0
[   12.910637]  [<790987fa>] vprintk_emit+0x64a/0x680
[   12.910640]  [<79882730>] printk+0x3d/0x3f
[   12.910658]  [<79d02f26>] print_local_APIC+0x29/0x3e6
[   12.910664]  [<790b8510>] generic_smp_call_function_single_interrupt+0xe0/0x230
[   12.910668]  [<7902aa35>] smp_call_function_single_interrupt+0x25/0x40
[   12.910672]  [<798966da>] call_function_single_interrupt+0x32/0x38
[   12.910677]  [<790368e5>] ? native_safe_halt+0x5/0x10
[   12.910682]  [<7900afa3>] default_idle+0x63/0x110
[   12.910685]  [<7900b957>] arch_cpu_idle+0x17/0x40
[   12.910688]  [<79099eae>] cpu_startup_entry+0x20e/0x3c0
[   12.910693]  [<7987d999>] rest_init+0xb9/0xc0
[   12.910696]  [<7987d8e0>] ? reciprocal_value+0x70/0x70
[   12.910700]  [<79cf4aa0>] start_kernel+0x3ba/0x41a
[   12.910703]  [<79cf451d>] ? repair_env_string+0x51/0x51
[   12.910706]  [<79cf4358>] i386_start_kernel+0x12e/0x131
[   12.910714] ---[ end trace bec5db8963544a10 ]---
[   12.919853] ... APIC ID:      00000000 (0)

git bisect start 05ffd9cb67c1bc9a4b4e3007df326e4e6f2d7db0 0414855fdc4a40da05221fc6062cccbc0c30f169 --
git bisect  bad d6624f53631bba754e89f4d204c6248ee0d314f1  # 23:17      0-      8  Merge 'dvdhrm/drm-log' into devel-roam-i386-201403072151
git bisect good 5bbe2fa5f7e2c75a85348e0ae4a1cca7d2a0e4a8  # 23:22     20+      0  0day base guard for 'devel-roam-i386-201403072151'
git bisect good b82a37f7f077567a7f744a98040d2e566632e385  # 23:26     20+      0  Merge 'gfs2/master' into devel-roam-i386-201403072151
git bisect good e81ca8076832ed2197a6bdb05dbc769dad159f7d  # 23:34     20+      2  drm/i915: We implement WaDisableRCCUnitClockGating:snb
git bisect good c1874ed7c987664176bd00301f844e91609fe535  # 23:55     20+      0  drm/i915: factor out valleyview_pipestat_irq_handler
git bisect good c48cdd23ea5006c377b670bc3056fa7b63f92574  # 00:28     20+      0  Merge branch 'tda998x-devel' of git://ftp.arm.linux.org.uk/~rmk/linux-cubox into drm-next
git bisect good 4d538b79197901fecc42e746d515d07fd1089b62  # 00:39     20+      0  Merge branch 'drm-next-3.15' of git://people.freedesktop.org/~deathsimple/linux into drm-next
git bisect  bad 06bdc9aa3cd3a045b4a94bdc4c6c582338cf7992  # 00:41      0-      1  drm: add kernel-log renderer
git bisect good 32afb1337bdffd1df2ac4ae749eace37528c747f  # 00:55     20+      0  lib: remove FBCON dependency for fonts
# first bad commit: [06bdc9aa3cd3a045b4a94bdc4c6c582338cf7992] drm: add kernel-log renderer
git bisect good 32afb1337bdffd1df2ac4ae749eace37528c747f  # 01:06     60+      4  lib: remove FBCON dependency for fonts
git bisect  bad 05ffd9cb67c1bc9a4b4e3007df326e4e6f2d7db0  # 01:06      0-     19  0day head guard for 'devel-roam-i386-201403072151'
git bisect good 6c0eb6436ff95fbd405fd8ac292626247b1e0f96  # 01:27     60+      5  Revert "drm: add kernel-log renderer"
git bisect good c3bebc71c4bcdafa24b506adf0c1de3c1f77e2e0  # 02:28     60+      1  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect good 1b0a7e3263168a06d3858798e48c5a21d1c78d3c  # 02:40     60+      1  Add linux-next specific files for 20140307

Thanks,
Fengguang

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-xian-16:20140307222306:i386-randconfig-r5-0307:3.14.0-rc5-00558-g05ffd9c:230"
Content-Transfer-Encoding: quoted-printable

early console in setup code
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc5-00558-g05ffd9c (kbuild@roam) (gcc v=
ersion 4.8.1 (Debian 4.8.1-8) ) #230 SMP Fri Mar 7 22:10:38 CST 2014
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
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[780fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
[    0.000000] Base memory trampoline at [7809b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0f800000-0x0fbfffff]
[    0.000000]  [mem 0x0f800000-0x0fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0f7fffff]
[    0.000000]  [mem 0x08000000-0x0f7fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x07ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x0237d000, 0x0237dfff] PGTABLE
[    0.000000] cma: CMA: reserved 28 MiB at 0e000000
[    0.000000] RAMDISK: [mem 0x0fcbd000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: FACP 0fffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXP=
C 00000001)
[    0.000000] ACPI: DSDT 0fffe490 0011A9 (v01   BXPC   BXDSDT 00000001 INT=
L 20100528)
[    0.000000] ACPI: FACS 0fffff40 000040
[    0.000000] ACPI: SSDT 0ffff7a0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: APIC 0ffff680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXP=
C 00000001)
[    0.000000] ACPI: HPET 0ffff640 000038 (v01 BOCHS  BXPCHPET 00000001 BXP=
C 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 480 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 334 pages/cpu @85be4000 s1344136 r0 d23928 =
u1368064
[    0.000000] pcpu-alloc: s1344136 r0 d23928 u1368064 alloc=3D334*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr dbe6680
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64924
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-r5-0307/linux-devel:devel-roam-i386-201403072151/.vmlinu=
z-05ffd9cb67c1bc9a4b4e3007df326e4e6f2d7db0-20140307221326-5-xian branch=3Dl=
inux-devel/devel-roam-i386-201403072151 BOOT_IMAGE=3D/kernel/i386-randconfi=
g-r5-0307/05ffd9cb67c1bc9a4b4e3007df326e4e6f2d7db0/vmlinuz-3.14.0-rc5-00558=
-g05ffd9c
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 204800K/261744K available (8821K kernel code, 958K r=
wdata, 3476K rodata, 1840K init, 4788K bss, 56944K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
[    0.000000]     vmalloc : 0x887fe000 - 0xfff14000   (1911 MB)
[    0.000000]     lowmem  : 0x78000000 - 0x87ffe000   ( 255 MB)
[    0.000000]       .init : 0x79cf4000 - 0x79ec0000   (1840 kB)
[    0.000000]       .data : 0x7989d9cd - 0x79cf3b80   (4440 kB)
[    0.000000]       .text : 0x79000000 - 0x7989d9cd   (8822 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3D85404000 soft=3D85406000
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
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
[    0.000000]  memory used by lock dependency info: 3807 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2892.992 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5785.98 Bogo=
MIPS (lpj=3D28929920)
[    0.020449] pid_max: default: 32768 minimum: 301
[    0.021157] Security Framework initialized
[    0.021717] AppArmor: AppArmor disabled by boot time parameter
[    0.030048] Mount-cache hash table entries: 512
[    0.031222] Initializing cgroup subsys freezer
[    0.031886] Initializing cgroup subsys net_prio
[    0.032658] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.032658] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.032658] tlb_flushall_shift: 6
[    0.040251] Freeing SMP alternatives memory: 24K (79ec0000 - 79ec6000)
[    0.050824] Getting VERSION: 50014
[    0.051327] Getting VERSION: 50014
[    0.051993] Getting ID: 0
[    0.052430] Getting ID: f000000
[    0.052876] Getting LVT0: 8700
[    0.053297] Getting LVT1: 8400
[    0.053691] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.060120] enabled ExtINT on CPU#0
[    0.070522] ENABLING IO-APIC IRQs
[    0.070988] init IO_APIC IRQs
[    0.071386]  apic 0 pin 0 not connected
[    0.072082] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.073276] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.080053] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.081175] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.082397] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.083503] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.090057] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.100020] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.101206] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.102428] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.103536] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.110042] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.111156] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.112270] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.120051] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.121124]  apic 0 pin 16 not connected
[    0.121664]  apic 0 pin 17 not connected
[    0.122214]  apic 0 pin 18 not connected
[    0.122792]  apic 0 pin 19 not connected
[    0.123297]  apic 0 pin 20 not connected
[    0.123788]  apic 0 pin 21 not connected
[    0.130017]  apic 0 pin 22 not connected
[    0.130733]  apic 0 pin 23 not connected
[    0.131638] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.136295] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.138273] Using local APIC timer interrupts.
[    0.138273] calibrating APIC timer ...
[    0.150000] ... lapic delta =3D 6722729
[    0.150000] ... PM-Timer delta =3D 385059
[    0.150000] APIC calibration not consistent with PM-Timer: 107ms instead=
 of 100ms
[    0.150000] APIC delta adjusted to PM-Timer: 6249503 (6722729)
[    0.150000] TSC delta adjusted to PM-Timer: 289302833 (311209428)
[    0.150000] ..... delta 6249503
[    0.150000] ..... mult: 268414110
[    0.150000] ..... calibration result: 9999204
[    0.150000] ..... CPU clock speed is 2893.0283 MHz.
[    0.150000] ..... host bus clock speed is 999.9204 MHz.
[    0.150122] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.155295] ftrace: Allocated trace_printk buffers
[    0.164603] CPU 1 irqstacks, hard=3D8574e000 soft=3D85750000
[    0.170018] x86: Booting SMP configuration:
[    0.180016] .... node  #0, CPUs:      #1
[    0.010000] Initializing CPU#1
[    0.020000] kvm-clock: cpu 1, msr 0:fffd041, secondary cpu clock
[    0.020000] masked ExtINT on CPU#1
[    0.230150] x86: Booted up 1 node, 2 CPUs
[    0.230718] ----------------
[    0.231112] | NMI testsuite:
[    0.231491] --------------------
[    0.231920]   remote IPI:
[    0.230114] KVM setup async PF for cpu 1
[    0.230688] kvm-stealtime: cpu 1, msr dd34680
[    0.240059]   ok  |
[    0.240377]    local IPI:  ok  |
[    0.260073] --------------------
[    0.260529] Good, all   2 testcases passed! |
[    0.261101] ---------------------------------
[    0.261669] smpboot: Total of 2 processors activated (11571.96 BogoMIPS)
[    0.270968] EVM: security.selinux
[    0.271440] EVM: security.SMACK64
[    0.271883] EVM: security.capability
[    0.274035] prandom: seed boundary self test passed
[    0.275453] prandom: 100 self tests passed
[    0.290016] regulator-dummy: no parameters
[    0.291482] NET: Registered protocol family 16
[    0.292956] cpuidle: using governor ladder
[    0.293496] cpuidle: using governor menu
[    0.294433] ACPI: bus type PCI registered
[    0.300170] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.360587] bio: create slab <bio-0> at 0
[    0.365890] ACPI: Added _OSI(Module Device)
[    0.366480] ACPI: Added _OSI(Processor Device)
[    0.370012] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.370643] ACPI: Added _OSI(Processor Aggregator Device)
[    0.413244] ACPI: Interpreter enabled
[    0.413768] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20131218/hwxface-580)
[    0.414999] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20131218/hwxface-580)
[    0.416303] ACPI: (supports S0 S3 S5)
[    0.416788] ACPI: Using IOAPIC for interrupt routing
[    0.417511] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.490966] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.491796] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    0.492564] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.494529] PCI host bridge to bus 0000:00
[    0.495092] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.495809] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.496611] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.497416] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.500023] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.501060] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.511091] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.513030] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.520922] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.532425] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.533781] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.534735] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.536418] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.543928] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.546890] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.578365] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.581178] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.586626] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.590021] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.610805] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.612633] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.615168] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.617583] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.641020] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.651646] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.654199] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.674133] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.676558] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.680920] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.710289] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.712735] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.715079] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.735046] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.740019] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.750861] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.761873] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.780015] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.782310] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.802504] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.804148] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.820985] pci_bus 0000:00: on NUMA node 0
[    0.823058] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.824370] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.825552] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.826807] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.830115] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.840665] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.842911] pps_core: LinuxPPS API ver. 1 registered
[    0.843668] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.845055] PTP clock support registered
[    0.845704] wmi: Mapper loaded
[    0.846203] PCI: Using ACPI for IRQ routing
[    0.846790] PCI: pci_cache_line_size set to 64 bytes
[    0.847803] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.850034] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.860838] NET: Registered protocol family 8
[    0.861431] NET: Registered protocol family 20
[    0.868052] NetLabel: Initializing
[    0.868052] NetLabel:  domain hash size =3D 128
[    0.868052] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.870106] NetLabel:  unlabeled traffic allowed by default
[    0.870903] nfc: nfc_init: NFC Core ver 0.1
[    0.871539] NET: Registered protocol family 39
[    0.872625] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.873633] cfg80211: Calling CRDA to update world regulatory domain
[    0.875989] Switched to clocksource kvm-clock
[    0.875989] Warning: could not register annotated branches stats
[    0.987958] pnp: PnP ACPI init
[    0.988443] ACPI: bus type PNP registered
[    0.989141] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    1.000591] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.001954] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    1.003146] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.004101] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    1.005354] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.006369] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    1.007688] pnp 00:03: [dma 2]
[    1.008238] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.009339] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    1.021018] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.022170] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    1.023545] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.025261] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.026709] pnp: PnP ACPI: found 7 devices
[    1.027261] ACPI: bus type PNP unregistered
[    1.079989] PM-Timer running at invalid rate: 118% of normal - aborting.
[    1.081088] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.082029] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.082755] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.083638] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.084566] NET: Registered protocol family 2
[    1.090907] TCP established hash table entries: 2048 (order: 1, 8192 byt=
es)
[    1.092004] TCP bind hash table entries: 2048 (order: 4, 90112 bytes)
[    1.093018] TCP: Hash tables configured (established 2048 bind 2048)
[    1.093929] TCP: reno registered
[    1.094372] UDP hash table entries: 256 (order: 2, 24576 bytes)
[    1.095187] UDP-Lite hash table entries: 256 (order: 2, 24576 bytes)
[    1.096300] NET: Registered protocol family 1
[    1.096909] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.097702] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.098494] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.099346] pci 0000:00:02.0: Boot video device
[    1.110234] PCI: CLS 0 bytes, default 64
[    1.111391] Trying to unpack rootfs image as initramfs...
[    1.443110] Freeing initrd memory: 3276K (87cbd000 - 87ff0000)
[    1.445178] cryptomgr_test (29) used greatest stack depth: 7024 bytes le=
ft
[    1.459981] Initializing RT-Tester: OK
[    1.463943] futex hash table entries: 512 (order: 3, 32768 bytes)
[    1.464851] Initialise system trusted keyring
[    1.465528] audit: initializing netlink subsys (disabled)
[    1.466372] audit: type=3D2000 audit(1394202168.416:1): initialized
[    1.549621] VFS: Disk quotas dquot_6.5.2
[    1.550431] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.553100] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    1.553973] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    1.554698] QNX6 filesystem 1.0.0 registered.
[    1.555701] JFS: nTxBlock =3D 1849, nTxLock =3D 14798
[    1.570710] 9p: Installing v9fs 9p2000 file system support
[    1.571584] msgmni has been set to 462
[    1.572721] cryptomgr_test (48) used greatest stack depth: 6632 bytes le=
ft
[    2.420137] cryptomgr_test (52) used greatest stack depth: 6192 bytes le=
ft
[   11.061624] alg: No test for stdrng (krng)
[   11.119417] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[   11.120465] Key type asymmetric registered
[   11.121135] Asymmetric key parser 'x509' registered
[   11.121933] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[   11.123073] io scheduler noop registered (default)
[   11.123795] list_sort_test: start testing list_sort()
[   11.126382] test_string_helpers: Running tests...
[   11.148855] crc32: CRC_LE_BITS =3D 8, CRC_BE BITS =3D 8
[   11.149589] crc32: self tests passed, processed 225944 bytes in 776454 n=
sec
[   11.151367] crc32c: CRC_LE_BITS =3D 8
[   11.151896] crc32c: self tests passed, processed 225944 bytes in 366129 =
nsec
[   11.736438] crc32_combine: 8373 self tests passed
[   12.287262] crc32c_combine: 8373 self tests passed
[   12.288229] xz_dec_test: module loaded
[   12.288715] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
249 0' and write .xz files to it.
[   12.291433] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   12.292460] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[   12.293386] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   12.295915] no IO addresses supplied
[   12.297050] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   12.298264] ACPI: Power Button [PWRF]
[   12.302849] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[   12.303623] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:3)
[   12.308781] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[   12.309562] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:3)
[   12.317384] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[   12.325899] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[   12.403398] r3964: Philips r3964 Driver $Revision: 1.10 $
[   12.404159] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   12.429357] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[   12.432798] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[   12.433763] platform pc8736x_gpio.0: no device found
[   12.434587] nsc_gpio initializing
[   12.435078] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[   12.435752] Linux agpgart interface v0.103
[   12.437012] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[   12.438193] Hangcheck: Using getrawmonotonic().
[   12.481162] console [drmlog0] enabled
[   12.481761] [drm] Initialized drm 1.1.0 20060810
[   12.499954] Floppy drive(s): fd0 is 1.44M
[   12.512921] brd: module loaded
[   12.513376] HP CISS Driver (v 3.6.26)
[   12.528025] MM: desc_per_page =3D 128
[   12.528882] virtio-pci 0000:00:04.0: irq 40 for MSI/MSI-X
[   12.529632] virtio-pci 0000:00:04.0: irq 41 for MSI/MSI-X
[   12.530903] blk-mq: CPU -> queue map
[   12.531374]   CPU 0 -> Queue 0
[   12.531803]   CPU 1 -> Queue 0
[   12.540770] FDC 0 is a S82078B
[   12.541530]  vda: unknown partition table
[   12.559438] virtio-pci 0000:00:05.0: irq 42 for MSI/MSI-X
[   12.560369] virtio-pci 0000:00:05.0: irq 43 for MSI/MSI-X
[   12.561541] blk-mq: CPU -> queue map
[   12.562095]   CPU 0 -> Queue 0
[   12.562522]   CPU 1 -> Queue 0
[   12.570305]  vdb: unknown partition table
[   12.580234] virtio-pci 0000:00:06.0: irq 44 for MSI/MSI-X
[   12.581020] virtio-pci 0000:00:06.0: irq 45 for MSI/MSI-X
[   12.582097] blk-mq: CPU -> queue map
[   12.582614]   CPU 0 -> Queue 0
[   12.583068]   CPU 1 -> Queue 0
[   12.585151]  vdc: unknown partition table
[   12.592421] virtio-pci 0000:00:07.0: irq 46 for MSI/MSI-X
[   12.593149] virtio-pci 0000:00:07.0: irq 47 for MSI/MSI-X
[   12.594226] blk-mq: CPU -> queue map
[   12.594763]   CPU 0 -> Queue 0
[   12.595161]   CPU 1 -> Queue 0
[   12.604192]  vdd: unknown partition table
[   12.610642] virtio-pci 0000:00:08.0: irq 48 for MSI/MSI-X
[   12.611468] virtio-pci 0000:00:08.0: irq 49 for MSI/MSI-X
[   12.612557] blk-mq: CPU -> queue map
[   12.613057]   CPU 0 -> Queue 0
[   12.613473]   CPU 1 -> Queue 0
[   12.620159]  vde: unknown partition table
[   12.631171] virtio-pci 0000:00:09.0: irq 50 for MSI/MSI-X
[   12.631960] virtio-pci 0000:00:09.0: irq 51 for MSI/MSI-X
[   12.633076] blk-mq: CPU -> queue map
[   12.633525]   CPU 0 -> Queue 0
[   12.633926]   CPU 1 -> Queue 0
[   12.646948]  vdf: unknown partition table
[   12.659859] rbd: loaded
[   12.661701] zram: Created 1 device(s) ...
[   12.662306] dummy-irq: no IRQ given.  Use irq=3DN
[   12.663196] Phantom Linux Driver, version n0.9.8, init OK
[   12.667322] PPP generic driver version 2.4.2
[   12.668278] PPP BSD Compression module registered
[   12.688972] NET: Registered protocol family 24
[   12.689572] PPTP driver version 0.8.5
[   12.690814] Madge ATM Horizon [Ultra] driver version 1.2.1
[   12.691590] hrz: debug bitmap is 0
[   12.692176] idt77252_init: at 79d2d56a
[   12.692793] Solos PCI Driver Version 1.04
[   12.741004] aoe: AoE v85 initialised.
[   12.741668] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   12.758972] serio: i8042 KBD port at 0x60,0x64 irq 1
[   12.759733] serio: i8042 AUX port at 0x60,0x64 irq 12
[   12.761452] mousedev: PS/2 mouse device common for all mice
[   12.764014] i2c /dev entries driver
[   12.764655] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[   12.770745] pps pps0: new PPS source ktimer
[   12.771327] pps pps0: ktimer PPS source registered
[   12.771995] Driver for 1-wire Dallas network protocol.
[   12.773134] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[   12.799370] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   12.802318] Driver for HIFN 795x crypto accelerator chip has been succes=
sfully registered.
[   12.806010] intel_rapl: driver does not support CPU family 15 model 6
[   12.807139] oprofile: using NMI interrupt.
[   12.808001] gre: GRE over IPv4 demultiplexor driver
[   12.820115] TCP: cubic registered
[   12.820635] TCP: highspeed registered
[   12.821222] TCP: hybla registered
[   12.821674] TCP: htcp registered
[   12.822113] TCP: scalable registered
[   12.822605] Initializing XFRM netlink socket
[   12.823349] NET: Registered protocol family 4
[   12.824011] NET: Registered protocol family 5
[   12.837924] NET: Registered protocol family 33
[   12.838548] Key type rxrpc registered
[   12.839016] Key type rxrpc_s registered
[   12.842130] RxRPC: Registered security type 2 'rxkad'
[   12.842879] lec:lane_module_init: lec.c: initialized
[   12.843598] l2tp_core: L2TP core driver, V2.0
[   12.844194] l2tp_ip: L2TP IP encapsulation support (L2TPv3)
[   12.844952] l2tp_netlink: L2TP netlink interface
[   12.845598] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[   12.846714] DECnet: Routing cache hash table of 256 buckets, 11Kbytes
[   12.847617] NET: Registered protocol family 12
[   12.848557] sctp: Hash tables configured (established 1365 bind 1489)
[   12.868140] rds_page_remainder_cpu_notify(): cpu 0 action 0x7
[   12.868954] rds_page_remainder_cpu_notify(): cpu 1 action 0x7
[   12.869699] Registered RDS/tcp transport
[   12.877577] 9pnet: Installing 9P2000 support
[   12.878310] NET: Registered protocol family 37
[   12.878941] NET: Registered protocol family 36
[   12.879562] Key type dns_resolver registered
[   12.880318] Key type ceph registered
[   12.880875] libceph: loaded (mon/osd proto 15/24)
[   12.896975] batman_adv: B.A.T.M.A.N. advanced 2014.1.0 (compatibility ve=
rsion 15) loaded
[   12.898747]=20
[   12.898747] printing PIC contents
[   12.899406] ... PIC  IMR: ffff
[   12.899801] ... PIC  IRR: 1053
[   12.906391] ... PIC  ISR: 0000
[   12.906820] ... PIC ELCR: 0c00
[   12.909878] printing local APIC contents on CPU#0/0:
[   12.910508] ------------[ cut here ]------------
[   12.910521] WARNING: CPU: 0 PID: 0 at kernel/locking/mutex.c:516 mutex_l=
ock_nested+0xc7/0x430()
[   12.910523] DEBUG_LOCKS_WARN_ON(in_interrupt())
[   12.910524] Modules linked in:
[   12.910532] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc5-00558-g=
05ffd9c #230
[   12.910539]  00000000 00000000 79c05d64 798860ec 79c05da4 79c05d94 79041=
4ee 79b1a074
[   12.910544]  79c05dc0 00000000 79b1fbf8 00000204 79892017 79892017 79c49=
9a0 00000001
[   12.910549]  79c096e0 79c05dac 79041543 00000009 79c05da4 79b1a074 79c05=
dc0 79c05e08
[   12.910550] Call Trace:
[   12.910557]  [<798860ec>] dump_stack+0x48/0x60
[   12.910566]  [<790414ee>] warn_slowpath_common+0x7e/0xa0
[   12.910570]  [<79892017>] ? mutex_lock_nested+0xc7/0x430
[   12.910572]  [<79892017>] ? mutex_lock_nested+0xc7/0x430
[   12.910577]  [<79041543>] warn_slowpath_fmt+0x33/0x40
[   12.910579]  [<79892017>] mutex_lock_nested+0xc7/0x430
[   12.910592]  [<7939d718>] ? io_serial_in+0x8/0x20
[   12.910595]  [<7939e3a2>] ? wait_for_xmitr+0x22/0x90
[   12.910606]  [<793d7744>] ? drm_log_write+0xb4/0xe0
[   12.910613]  [<79093ac2>] ? do_raw_spin_unlock+0xb2/0xe0
[   12.910616]  [<793d7700>] ? drm_log_write+0x70/0xe0
[   12.910618]  [<793d7744>] drm_log_write+0xb4/0xe0
[   12.910621]  [<7939e50a>] ? serial8250_console_write+0xfa/0x120
[   12.910623]  [<7939e530>] ? serial8250_console_write+0x120/0x120
[   12.910627]  [<793d7783>] dlog_con_write+0x13/0x20
[   12.910630]  [<79097a53>] call_console_drivers.constprop.8+0x133/0x1b0
[   12.910633]  [<79098018>] console_unlock+0x328/0x4c0
[   12.910637]  [<790987fa>] vprintk_emit+0x64a/0x680
[   12.910640]  [<79882730>] printk+0x3d/0x3f
[   12.910658]  [<79d02f26>] print_local_APIC+0x29/0x3e6
[   12.910664]  [<790b8510>] generic_smp_call_function_single_interrupt+0xe=
0/0x230
[   12.910668]  [<7902aa35>] smp_call_function_single_interrupt+0x25/0x40
[   12.910672]  [<798966da>] call_function_single_interrupt+0x32/0x38
[   12.910677]  [<790368e5>] ? native_safe_halt+0x5/0x10
[   12.910682]  [<7900afa3>] default_idle+0x63/0x110
[   12.910685]  [<7900b957>] arch_cpu_idle+0x17/0x40
[   12.910688]  [<79099eae>] cpu_startup_entry+0x20e/0x3c0
[   12.910693]  [<7987d999>] rest_init+0xb9/0xc0
[   12.910696]  [<7987d8e0>] ? reciprocal_value+0x70/0x70
[   12.910700]  [<79cf4aa0>] start_kernel+0x3ba/0x41a
[   12.910703]  [<79cf451d>] ? repair_env_string+0x51/0x51
[   12.910706]  [<79cf4358>] i386_start_kernel+0x12e/0x131
[   12.910714] ---[ end trace bec5db8963544a10 ]---
[   12.919853] ... APIC ID:      00000000 (0)
[   12.919853] ... APIC VERSION: 00050014
[   12.919853] ... APIC TASKPRI: 00000000 (00)
[   12.919853] ... APIC PROCPRI: 00000000
[   12.919853] ... APIC LDR: 01000000
[   12.919853] ... APIC DFR: ffffffff
[   12.919853] ... APIC SPIV: 000001ff
[   12.919853] ... APIC ISR field:
[   12.919853] 000000000000000000000000000000000000000000000000000000000000=
0000
[   12.919853] ... APIC TMR field:
[   12.919853] 000000000200000000000000000000000000000000000000000000000000=
0000
[   12.919853] ... APIC IRR field:
[   12.919853] 000000000000000000000000000000000000000000000000000000000000=
8000
[   12.919853] ... APIC ESR: 00000000
[   12.919853] ... APIC ICR: 000008fd
[   12.919853] ... APIC ICR2: 02000000
[   12.919853] ... APIC LVTT: 000000ef
[   12.919853] ... APIC LVTPC: 00010000
[   12.919853] ... APIC LVT0: 00010700
[   12.919853] ... APIC LVT1: 00000400
[   12.919853] ... APIC LVTERR: 000000fe
[   12.919853] ... APIC TMICT: 0003f14e
[   12.919853] ... APIC TMCCT: 00000000
[   12.919853] ... APIC TDCR: 00000003
[   12.919853]=20
[   13.057928] number of MP IRQ sources: 15.
[   13.058489] number of IO-APIC #0 registers: 24.
[   13.059088] testing the IO APIC.......................
[   13.059785] IO APIC #0......
[   13.060230] .... register #00: 00000000
[   13.060709] .......    : physical APIC id: 00
[   13.061263] .......    : Delivery Type: 0
[   13.061842] .......    : LTS          : 0
[   13.062395] .... register #01: 00170011
[   13.063011] .......     : max redirection entries: 17
[   13.063655] .......     : PRQ implemented: 0
[   13.064187] .......     : IO APIC version: 11
[   13.064754] .... register #02: 00000000
[   13.065329] .......     : arbitration: 00
[   13.065869] .... IRQ redirection table:
[   13.080387] 1    0    0   0   0    0    0    00
[   13.081006] 0    0    0   0   0    1    1    31
[   13.081578] 0    0    0   0   0    1    1    30
[   13.082179] 0    0    0   0   0    1    1    33
[   13.082842] 1    0    0   0   0    1    1    34
[   13.083496] 1    1    0   0   0    1    1    35
[   13.084078] 0    0    0   0   0    1    1    36
[   13.084663] 0    0    0   0   0    1    1    37
[   13.085415] 0    0    0   0   0    1    1    38
[   13.086072] 0    1    0   0   0    1    1    39
[   13.086669] 1    1    0   0   0    1    1    3A
[   13.087246] 1    1    0   0   0    1    1    3B
[   13.099949] 0    0    0   0   0    1    1    3C
[   13.100616] 0    0    0   0   0    1    1    3D
[   13.101251] 0    0    0   0   0    1    1    3E
[   13.101885] 0    0    0   0   0    1    1    3F
[   13.102520] 1    0    0   0   0    0    0    00
[   13.103230] 1    0    0   0   0    0    0    00
[   13.103866] 1    0    0   0   0    0    0    00
[   13.104461] 1    0    0   0   0    0    0    00
[   13.105051] 1    0    0   0   0    0    0    00
[   13.105666] 1    0    0   0   0    0    0    00
[   13.106330] 1    0    0   0   0    0    0    00
[   13.106940] 1    0    0   0   0    0    0    00
[   13.107492] IRQ to pin mappings:
[   13.107923] IRQ0 -> 0:2
[   13.108370] IRQ1 -> 0:1
[   13.108797] IRQ3 -> 0:3
[   13.109178] IRQ4 -> 0:4
[   13.109553] IRQ5 -> 0:5
[   13.120047] IRQ6 -> 0:6
[   13.120449] IRQ7 -> 0:7
[   13.120823] IRQ8 -> 0:8
[   13.121211] IRQ9 -> 0:9
[   13.121584] IRQ10 -> 0:10
[   13.121989] IRQ11 -> 0:11
[   13.122396] IRQ12 -> 0:12
[   13.122766] IRQ13 -> 0:13
[   13.123161] IRQ14 -> 0:14
[   13.123591] IRQ15 -> 0:15
[   13.123998] .................................... done.
[   13.124714] Using IPI No-Shortcut mode
[   13.125917] Loading compiled-in X.509 certificates
[   13.141271] Loaded X.509 cert 'Magrathea: Glacier signing key: 07005e0ff=
88212a57c52018cc0c40a90881d4a91'
[   13.142654] registered taskstats version 1
[   13.143220] kAFS: Red Hat AFS client v0.1 registering.
[   13.171906] Key type trusted registered
[   13.174571] Key type encrypted registered
[   13.176562] IMA: No TPM chip found, activating TPM-bypass!
[   13.179018] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[   13.180476] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   13.181288] EDD information not available.
[   13.189998] Unregister pv shared memory for cpu 0
[   13.240167] blk-mq: CPU -> queue map
[   13.240681]   CPU 1 -> Queue 0
[   13.241105] blk-mq: CPU -> queue map
[   13.241585]   CPU 1 -> Queue 0
[   13.242011] blk-mq: CPU -> queue map
[   13.242504]   CPU 1 -> Queue 0
[   13.242926] blk-mq: CPU -> queue map
[   13.243409]   CPU 1 -> Queue 0
[   13.243819] blk-mq: CPU -> queue map
[   13.244300]   CPU 1 -> Queue 0
[   13.244706] blk-mq: CPU -> queue map
[   13.245249]   CPU 1 -> Queue 0
[   13.245733] CPU 0 is now offline
[   13.248413] Freeing unused kernel memory: 1840K (79cf4000 - 79ec0000)
[   13.249355] Write protecting the kernel text: 8824k
[   13.260342] Write protecting the kernel read-only data: 3480k

mount: mounting proc on /proc failed: No such device
/etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: No such file or directory

Please wait: booting...
mount: mounting proc on /proc failed: No such device
grep: /proc/filesystems: No such file or directory
Starting Bootlog daemon: bootlogd: cannot allocate pseudo tty: No such file=
 or directory
bootlogd.
mount: can't read '/proc/mounts': No such file or directory
/etc/rcS.d/S37populate-volatile.sh: line 172: /proc/cmdline: No such file o=
r directory
grep: /proc/filesystems: No such file or directory
Configuring network interfaces... ifup: can't open '/var/run/ifstate': No s=
uch file or directory
done.
hwclock: can't open '/dev/misc/rtc': No such file or directory
Running postinst /etc/rpm-postinsts/100...

mount: no /proc/mounts
wfg: skip syslogd
Kernel tests: Boot OK!
Kernel tests: Boot OK!
mount: mounting proc on /proc failed: No such device
/etc/rc5.d/S99-rc.local: line 19: /proc/214/oom_score_adj: No such file or =
directory
sed: /lib/modules/3.14.0-rc5-00558-g05ffd9c/modules.dep: No such file or di=
rectory
xargs: modprobe: No such file or directory
run-parts: /etc/kernel-tests/01-modprobe exited with code 127
grep: /proc/cmdline: No such file or directory
grep: /proc/cmdline: No such file or directory
Trinity v1.4pre  Dave Jones <davej@redhat.com>
[   13.739647] random: trinity urandom read with 3 bits of entropy available
[   13.740018] BUG: sleeping function called from invalid context at kernel=
/locking/mutex.c:616
[   13.740018] in_atomic(): 0, irqs_disabled(): 1, pid: 232, name: trinity
[   13.740018] INFO: lockdep is turned off.
[   13.740018] CPU: 1 PID: 232 Comm: trinity Tainted: G        W    3.14.0-=
rc5-00558-g05ffd9c #230
[   13.740018]  00000000 00000000 83d53dd8 798860ec 000000e8 83d53e00 7906d=
845 79b1f734
[   13.740018]  00000000 00000001 000000e8 83d5529c 79c499a0 00000000 83d55=
000 83d53e5c
[   13.740018]  79891f7a 00000000 7fffffff fa2f4e3f 79b1a80c 6c0a0100 ffff0=
006 7939d718
[   13.740018] Call Trace:
[   13.740018]  [<798860ec>] dump_stack+0x48/0x60
[   13.740018]  [<7906d845>] __might_sleep+0x105/0x110
[   13.740018]  [<79891f7a>] mutex_lock_nested+0x2a/0x430
[   13.740018]  [<7939d718>] ? io_serial_in+0x8/0x20
[   13.740018]  [<7939e3a2>] ? wait_for_xmitr+0x22/0x90
[   13.740018]  [<79093ac2>] ? do_raw_spin_unlock+0xb2/0xe0
[   13.740018]  [<793d7700>] ? drm_log_write+0x70/0xe0
[   13.740018]  [<793d7744>] drm_log_write+0xb4/0xe0
[   13.740018]  [<7939e50a>] ? serial8250_console_write+0xfa/0x120
[   13.740018]  [<7939e530>] ? serial8250_console_write+0x120/0x120
[   13.740018]  [<793d7783>] dlog_con_write+0x13/0x20
[   13.740018]  [<79097a53>] call_console_drivers.constprop.8+0x133/0x1b0
[   13.740018]  [<79098018>] console_unlock+0x328/0x4c0
[   13.740018]  [<790987fa>] vprintk_emit+0x64a/0x680
[   13.740018]  [<79882730>] printk+0x3d/0x3f
[   13.740018]  [<793a51eb>] urandom_read+0x6b/0x110
[   13.740018]  [<793a5180>] ? random_read+0x1c0/0x1c0
[   13.740018]  [<7914672b>] vfs_read+0xbb/0x150
[   13.740018]  [<79146e49>] SyS_read+0x49/0x80
[   13.740018]  [<79896448>] syscall_call+0x7/0xb
[   13.788141] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
Trinity v1.4pre  Dave Jones <davej@redhat.com>
Trinity v1.4pre  Dave Jones <davej@redhat.com>
Done parsing arguments.
Marking all syscalls as enabled.
[init] Enabled 351 syscalls. Disabled 0 syscalls.
DANGER: RUNNING AS ROOT.
Unless you are running in a virtual machine, this could cause serious probl=
ems such as overwriting CMOS
or similar which could potentially make this machine unbootable without a f=
irmware reset.

ctrl-c now unless you really know what you are doing.
Continuing in 10 seconds.
[init] Marking syscall get_robust_list (312) as to be disabled.
Done parsing arguments.
Marking all syscalls as enabled.
[init] Disabling syscalls marked as disabled by command line options
[init] Marked syscall get_robust_list (312) as deactivated.
[init] Enabled 350 syscalls. Disabled 1 syscalls.
DANGER: RUNNING AS ROOT.
Unless you are running in a virtual machine, this could cause serious probl=
ems such as overwriting CMOS
or similar which could potentially make this machine unbootable without a f=
irmware reset.

ctrl-c now unless you really know what you are doing.
Continuing in 10 seconds.
Done parsing arguments.
## couldn't open logfile trinity.log
Done parsing arguments.
## couldn't open logfile trinity.log
Continuing in 9 seconds.
Elapsed time: 20
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-r=
5-0307/05ffd9cb67c1bc9a4b4e3007df326e4e6f2d7db0/vmlinuz-3.14.0-rc5-00558-g0=
5ffd9c -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=3D1 nmi_watchdog=
=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dno=
rmal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/i386-randconfi=
g-r5-0307/linux-devel:devel-roam-i386-201403072151/.vmlinuz-05ffd9cb67c1bc9=
a4b4e3007df326e4e6f2d7db0-20140307221326-5-xian branch=3Dlinux-devel/devel-=
roam-i386-201403072151 BOOT_IMAGE=3D/kernel/i386-randconfig-r5-0307/05ffd9c=
b67c1bc9a4b4e3007df326e4e6f2d7db0/vmlinuz-3.14.0-rc5-00558-g05ffd9c'  -init=
rd /kernel-tests/initrd/yocto-minimal-i386.cgz -m 256 -smp 2 -net nic,vlan=
=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::25887-:22 -boot order=
=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs=
/LABEL=3DKVM/disk0-yocto-xian-16,media=3Ddisk,if=3Dvirtio -drive file=3D/fs=
/LABEL=3DKVM/disk1-yocto-xian-16,media=3Ddisk,if=3Dvirtio -drive file=3D/fs=
/LABEL=3DKVM/disk2-yocto-xian-16,media=3Ddisk,if=3Dvirtio -drive file=3D/fs=
/LABEL=3DKVM/disk3-yocto-xian-16,media=3Ddisk,if=3Dvirtio -drive file=3D/fs=
/LABEL=3DKVM/disk4-yocto-xian-16,media=3Ddisk,if=3Dvirtio -drive file=3D/fs=
/LABEL=3DKVM/disk5-yocto-xian-16,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm=
/kboot/pid-yocto-xian-16 -serial file:/dev/shm/kboot/serial-yocto-xian-16 -=
daemonize -display none -monitor null=20

--/04w6evG8XlLl3ft
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-r5-0307-05ffd9cb67c1bc9a4b4e3007df326e4e6f2d7db0-BUG:-sleeping-function-called-from-invalid-context-at-10547.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDA0MTQ4NTVmZGM0YTQwZGEwNTIyMWZjNjA2MmNjY2JjMGMzMGYxNjkK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yNS0w
MzA3L2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0MDMwNzIxNTE6MDQxNDg1NWZk
YzRhNDBkYTA1MjIxZmM2MDYyY2NjYmMwYzMwZjE2OTpiaXNlY3QtbGludXg1CgoyMDE0LTAz
LTA3LTIzOjA4OjAxIDA0MTQ4NTVmZGM0YTQwZGEwNTIyMWZjNjA2MmNjY2JjMGMzMGYxNjkg
Y29tcGlsaW5nCjE1NCByZWFsICAyNjc5IHVzZXIgIDIyMCBzeXMgIDE4NzcuMDUlIGNwdSAJ
aTM4Ni1yYW5kY29uZmlnLXI1LTAzMDcKCjIwMTQtMDMtMDctMjM6MTE6MDAgZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgMy4xNC4wLXJjNS4uLgk2CTE3CTIwIFNVQ0NFU1MKCmJpc2VjdDogZ29v
ZCBjb21taXQgMDQxNDg1NWZkYzRhNDBkYTA1MjIxZmM2MDYyY2NjYmMwYzMwZjE2OQpnaXQg
YmlzZWN0IHN0YXJ0IDA1ZmZkOWNiNjdjMWJjOWE0YjRlMzAwN2RmMzI2ZTRlNmYyZDdkYjAg
MDQxNDg1NWZkYzRhNDBkYTA1MjIxZmM2MDYyY2NjYmMwYzMwZjE2OSAtLQovYy9rZXJuZWwt
dGVzdHMvbGluZWFyLWJpc2VjdDogWyItYiIsICIwNWZmZDljYjY3YzFiYzlhNGI0ZTMwMDdk
ZjMyNmU0ZTZmMmQ3ZGIwIiwgIi1nIiwgIjA0MTQ4NTVmZGM0YTQwZGEwNTIyMWZjNjA2MmNj
Y2JjMGMzMGYxNjkiLCAiL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVy
ZS5zaCIsICIva2VybmVsLXRlc3RzL2xpbnV4NS9vYmotYmlzZWN0Il0KQmlzZWN0aW5nOiA1
NTggcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEwIHN0ZXBz
KQpbZDY2MjRmNTM2MzFiYmE3NTRlODlmNGQyMDRjNjI0OGVlMGQzMTRmMV0gTWVyZ2UgJ2R2
ZGhybS9kcm0tbG9nJyBpbnRvIGRldmVsLXJvYW0taTM4Ni0yMDE0MDMwNzIxNTEKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwt
dGVzdHMvbGludXg1L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUv
a3ZtL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA3L2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4
Ni0yMDE0MDMwNzIxNTE6ZDY2MjRmNTM2MzFiYmE3NTRlODlmNGQyMDRjNjI0OGVlMGQzMTRm
MTpiaXNlY3QtbGludXg1CgoyMDE0LTAzLTA3LTIzOjE0OjA4IGQ2NjI0ZjUzNjMxYmJhNzU0
ZTg5ZjRkMjA0YzYyNDhlZTBkMzE0ZjEgY29tcGlsaW5nCjc1IHJlYWwgIDM1NyB1c2VyICAz
NiBzeXMgIDUyMy44MCUgY3B1IAlpMzg2LXJhbmRjb25maWctcjUtMDMwNwoKMjAxNC0wMy0w
Ny0yMzoxNjo0MyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmM1LTAwMjQwLWdkNjYy
NGY1Li4gVEVTVCBGQUlMVVJFClsgICAxNC4zMzAzODZdIFdyaXRlIHByb3RlY3RpbmcgdGhl
IGtlcm5lbCB0ZXh0OiA4ODI0awpbICAgMTQuMzMxOTAwXSBXcml0ZSBwcm90ZWN0aW5nIHRo
ZSBrZXJuZWwgcmVhZC1vbmx5IGRhdGE6IDM0NzJrClsgICAxNC4zNzQwNjJdIHJhbmRvbTog
aW5pdCB1cmFuZG9tIHJlYWQgd2l0aCAwIGJpdHMgb2YgZW50cm9weSBhdmFpbGFibGUKWyAg
IDE0LjM4MDAzOV0gQlVHOiBzbGVlcGluZyBmdW5jdGlvbiBjYWxsZWQgZnJvbSBpbnZhbGlk
IGNvbnRleHQgYXQgL2tlcm5lbC10ZXN0cy9saW51eDUva2VybmVsL2xvY2tpbmcvbXV0ZXgu
Yzo2MTYKWyAgIDE0LjM4MDAzOV0gaW5fYXRvbWljKCk6IDAsIGlycXNfZGlzYWJsZWQoKTog
MSwgcGlkOiAxLCBuYW1lOiBpbml0ClsgICAxNC4zODAwMzldIG5vIGxvY2tzIGhlbGQgYnkg
aW5pdC8xLgpbICAgMTQuMzgwMDM5XSBDUFU6IDEgUElEOiAxIENvbW06IGluaXQgTm90IHRh
aW50ZWQgMy4xNC4wLXJjNS0wMDI0MC1nZDY2MjRmNSAjMTAzClsgICAxNC4zODAwMzldICAw
MDAwMDAwMCAwMDAwMDAwMCA4N2MyZGRkOCA3OTg4NjQ5YyAwMDAwMDAwMSA4N2MyZGUwMCA3
OTA2ZDg1NSA3OWIxZjAyYwpbICAgMTQuMzgwMDM5XSAgMDAwMDAwMDAgMDAwMDAwMDEgMDAw
MDAwMDEgODdjMWUyOWMgNzljNDc5YTAgMDAwMDAwMDAgODdjMWUwMDAgODdjMmRlNWMKWyAg
IDE0LjM4MDAzOV0gIDc5ODkyMzJhIDAwMDAwMDAwIDdmZmZmZmZmIGZhMmYyZTNmIDc5YjFh
MTk0IDZjMGEwMTAwIGZmZmYwMDA2IDc5MzlkNmQ4ClsgICAxNC4zODAwMzldIENhbGwgVHJh
Y2U6ClsgICAxNC4zODAwMzldICBbPDc5ODg2NDljPl0gZHVtcF9zdGFjaysweDQ4LzB4NjAK
WyAgIDE0LjM4MDAzOV0gIFs8NzkwNmQ4NTU+XSBfX21pZ2h0X3NsZWVwKzB4MTA1LzB4MTEw
ClsgICAxNC4zODAwMzldICBbPDc5ODkyMzJhPl0gbXV0ZXhfbG9ja19uZXN0ZWQrMHgyYS8w
eDQzMApbICAgMTQuMzgwMDM5XSAgWzw3OTM5ZDZkOD5dID8gaW9fc2VyaWFsX2luKzB4OC8w
eDIwClsgICAxNC4zODAwMzldICBbPDc5MzllMzYyPl0gPyB3YWl0X2Zvcl94bWl0cisweDIy
LzB4OTAKWyAgIDE0LjM4MDAzOV0gIFs8NzkwOTNiNjI+XSA/IGRvX3Jhd19zcGluX3VubG9j
aysweGIyLzB4ZTAKWyAgIDE0LjM4MDAzOV0gIFs8NzkzZDc3MDA+XSA/IGRybV9sb2dfd3Jp
dGUrMHg4MC8weGUwClsgICAxNC4zODAwMzldICBbPDc5M2Q3NzM0Pl0gZHJtX2xvZ193cml0
ZSsweGI0LzB4ZTAKWyAgIDE0LjM4MDAzOV0gIFs8NzkzOWU0Y2E+XSA/IHNlcmlhbDgyNTBf
Y29uc29sZV93cml0ZSsweGZhLzB4MTIwClsgICAxNC4zODAwMzldICBbPDc5MzllNGYwPl0g
PyBzZXJpYWw4MjUwX2NvbnNvbGVfd3JpdGUrMHgxMjAvMHgxMjAKWyAgIDE0LjM4MDAzOV0g
IFs8NzkzZDc3NzM+XSBkbG9nX2Nvbl93cml0ZSsweDEzLzB4MjAKWyAgIDE0LjM4MDAzOV0g
IFs8NzkwOTdhZjM+XSBjYWxsX2NvbnNvbGVfZHJpdmVycy5jb25zdHByb3AuOCsweDEzMy8w
eDFiMApbICAgMTQuMzgwMDM5XSAgWzw3OTA5ODBjMD5dIGNvbnNvbGVfdW5sb2NrKzB4MzMw
LzB4NGUwClsgICAxNC4zODAwMzldICBbPDc5MDk4OGJhPl0gdnByaW50a19lbWl0KzB4NjRh
LzB4NjgwClsgICAxNC4zODAwMzldICBbPDc5ODgyYWUwPl0gcHJpbnRrKzB4M2QvMHgzZgpb
ICAgMTQuMzgwMDM5XSAgWzw3OTNhNTE5Yj5dIHVyYW5kb21fcmVhZCsweDZiLzB4MTEwClsg
ICAxNC4zODAwMzldICBbPDc5M2E1MTMwPl0gPyByYW5kb21fcmVhZCsweDFjMC8weDFjMApb
ICAgMTQuMzgwMDM5XSAgWzw3OTE0NjgzYj5dIHZmc19yZWFkKzB4YmIvMHgxNTAKWyAgIDE0
LjM4MDAzOV0gIFs8NzkxNDZmNTk+XSBTeVNfcmVhZCsweDQ5LzB4ODAKWyAgIDE0LjM4MDAz
OV0gIFs8Nzk4OWNjOGE+XSBzeXNlbnRlcl9kb19jYWxsKzB4MTIvMHgzYwovYmluL3NoOiAv
cHJvYy9zZWxmL2ZkLzk6IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkKL2Jpbi9zaDogL3By
b2Mvc2VsZi9mZC85OiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5ClsgICAxNC44MzI2NTRd
IGlucHV0OiBJbUV4UFMvMiBHZW5lcmljIEV4cGxvcmVyIE1vdXNlIGFzIC9kZXZpY2VzL3Bs
YXRmb3JtL2k4MDQyL3NlcmlvMS9pbnB1dC9pbnB1dDMKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctcjUtMDMwNy9kNjYyNGY1MzYzMWJiYTc1NGU4OWY0ZDIwNGM2MjQ4ZWUwZDMxNGYxL2Rt
ZXNnLXF1YW50YWwtc25iLTI1OjIwMTQwMzA3MjMxNzEzOmkzODYtcmFuZGNvbmZpZy1yNS0w
MzA3OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjUtMDMwNy9kNjYyNGY1MzYzMWJiYTc1
NGU4OWY0ZDIwNGM2MjQ4ZWUwZDMxNGYxL2RtZXNnLXF1YW50YWwtc25iLTQ0OjIwMTQwMzA3
MjMxNzE0OmkzODYtcmFuZGNvbmZpZy1yNS0wMzA3OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctcjUtMDMwNy9kNjYyNGY1MzYzMWJiYTc1NGU4OWY0ZDIwNGM2MjQ4ZWUwZDMxNGYxL2Rt
ZXNnLXF1YW50YWwtc25iLTQ3OjIwMTQwMzA3MjMxNzIwOmkzODYtcmFuZGNvbmZpZy1yNS0w
MzA3OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjUtMDMwNy9kNjYyNGY1MzYzMWJiYTc1
NGU4OWY0ZDIwNGM2MjQ4ZWUwZDMxNGYxL2RtZXNnLXF1YW50YWwtYmVucy00OjIwMTQwMzA3
MjMxNzI5OmkzODYtcmFuZGNvbmZpZy1yNS0wMzA3OjMuMTQuMC1yYzUtMDAyNDAtZ2Q2NjI0
ZjU6MTAzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDcvZDY2MjRmNTM2MzFiYmE3
NTRlODlmNGQyMDRjNjI0OGVlMGQzMTRmMS9kbWVzZy1xdWFudGFsLXNuYi0yNToyMDE0MDMw
NzIzMTczMzppMzg2LXJhbmRjb25maWctcjUtMDMwNzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLXI1LTAzMDcvZDY2MjRmNTM2MzFiYmE3NTRlODlmNGQyMDRjNjI0OGVlMGQzMTRmMS9k
bWVzZy1xdWFudGFsLXNuYi00NDoyMDE0MDMwNzIzMTczOTppMzg2LXJhbmRjb25maWctcjUt
MDMwNzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDcvZDY2MjRmNTM2MzFiYmE3
NTRlODlmNGQyMDRjNjI0OGVlMGQzMTRmMS9kbWVzZy1xdWFudGFsLXNuYi00NzoyMDE0MDMw
NzIzMTc0MDppMzg2LXJhbmRjb25maWctcjUtMDMwNzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLXI1LTAzMDcvZDY2MjRmNTM2MzFiYmE3NTRlODlmNGQyMDRjNjI0OGVlMGQzMTRmMS9k
bWVzZy1xdWFudGFsLXNuYi00OjIwMTQwMzA3MjMxNzQwOmkzODYtcmFuZGNvbmZpZy1yNS0w
MzA3OjoKMDo4OjggYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDMt
MDcgMjM6MTc6NDUgUkVQRUFUIENPVU5UOiAyMCAgIyAva2VybmVsLXRlc3RzL2xpbnV4NS9v
YmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDI0MCByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOCBzdGVwcykKWzViYmUyZmE1ZjdlMmM3NWE4
NTM0OGUwYWU0YTFjY2E3ZDJhMGU0YThdIDBkYXkgYmFzZSBndWFyZCBmb3IgJ2RldmVsLXJv
YW0taTM4Ni0yMDE0MDMwNzIxNTEnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4NS9vYmotYmlzZWN0Cmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctcjUtMDMw
Ny9saW51eC1kZXZlbDpkZXZlbC1yb2FtLWkzODYtMjAxNDAzMDcyMTUxOjViYmUyZmE1Zjdl
MmM3NWE4NTM0OGUwYWU0YTFjY2E3ZDJhMGU0YTg6YmlzZWN0LWxpbnV4NQoKMjAxNC0wMy0w
Ny0yMzoxNzo0NiA1YmJlMmZhNWY3ZTJjNzVhODUzNDhlMGFlNGExY2NhN2QyYTBlNGE4IGNv
bXBpbGluZwo0NiByZWFsICAzNjYgdXNlciAgMzggc3lzICA4NzEuMjklIGNwdSAJaTM4Ni1y
YW5kY29uZmlnLXI1LTAzMDcKCjIwMTQtMDMtMDctMjM6MTg6NTMgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgMy4xNC4wLXJjNS0wMDAwMS1nNWJiZTJmYS4uLgk1CTEyCTE3CTIwIFNVQ0NFU1MK
CkJpc2VjdGluZzogMjM5IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSA4IHN0ZXBzKQpbYjgyYTM3ZjdmMDc3NTY3YTdmNzQ0YTk4MDQwZDJlNTY2NjMyZTM4
NV0gTWVyZ2UgJ2dmczIvbWFzdGVyJyBpbnRvIGRldmVsLXJvYW0taTM4Ni0yMDE0MDMwNzIx
NTEKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9rZXJuZWwtdGVzdHMvbGludXg1L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA3L2xpbnV4LWRldmVsOmRldmVs
LXJvYW0taTM4Ni0yMDE0MDMwNzIxNTE6YjgyYTM3ZjdmMDc3NTY3YTdmNzQ0YTk4MDQwZDJl
NTY2NjMyZTM4NTpiaXNlY3QtbGludXg1CgoyMDE0LTAzLTA3LTIzOjIyOjI1IGI4MmEzN2Y3
ZjA3NzU2N2E3Zjc0NGE5ODA0MGQyZTU2NjYzMmUzODUgY29tcGlsaW5nCjM5IHJlYWwgIDE5
NSB1c2VyICAyNiBzeXMgIDU2Mi4zOCUgY3B1IAlpMzg2LXJhbmRjb25maWctcjUtMDMwNwoK
MjAxNC0wMy0wNy0yMzoyMzozMCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmM1LTAw
MDIyLWdiODJhMzdmNy4uLgkyCTE2CTIwIFNVQ0NFU1MKCmxpbmVhci1iaXNlY3Q6IGJhZCBi
cmFuY2ggbWF5IGJlIGR2ZGhybS9kcm0tbG9nCmxpbmVhci1iaXNlY3Q6IGhhbmRsZSBvdmVy
IHRvIGdpdCBiaXNlY3QKbGluZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBzdGFydCBkNjYyNGY1
MzYzMWJiYTc1NGU4OWY0ZDIwNGM2MjQ4ZWUwZDMxNGYxIGI4MmEzN2Y3ZjA3NzU2N2E3Zjc0
NGE5ODA0MGQyZTU2NjYzMmUzODUgLS0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgYjgy
YTM3ZjcuLi4gTWVyZ2UgJ2dmczIvbWFzdGVyJyBpbnRvIGRldmVsLXJvYW0taTM4Ni0yMDE0
MDMwNzIxNTEKSEVBRCBpcyBub3cgYXQgYzIzNmUzYy4uLiBNZXJnZSAndGlwL3g4Ni9lZmkn
IGludG8gZGV2ZWwtaG91cmx5LTIwMTQwMzA2MTIKQmlzZWN0aW5nOiAxMDggcmV2aXNpb25z
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDcgc3RlcHMpCltlODFjYTgwNzY4
MzJlZDIxOTdhNmJkYjA1ZGJjNzY5ZGFkMTU5ZjdkXSBkcm0vaTkxNTogV2UgaW1wbGVtZW50
IFdhRGlzYWJsZVJDQ1VuaXRDbG9ja0dhdGluZzpzbmIKbGluZWFyLWJpc2VjdDogZ2l0IGJp
c2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAv
a2VybmVsLXRlc3RzL2xpbnV4NS9vYmotYmlzZWN0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4NS9vYmot
YmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctcjUtMDMwNy9saW51eC1kZXZlbDpkZXZlbC1yb2FtLWkzODYtMjAxNDAzMDcyMTUxOmU4
MWNhODA3NjgzMmVkMjE5N2E2YmRiMDVkYmM3NjlkYWQxNTlmN2Q6YmlzZWN0LWxpbnV4NQoK
MjAxNC0wMy0wNy0yMzoyNzoxNSBlODFjYTgwNzY4MzJlZDIxOTdhNmJkYjA1ZGJjNzY5ZGFk
MTU5ZjdkIGNvbXBpbGluZwoxNzUgcmVhbCAgMjY1NCB1c2VyICAyMjcgc3lzICAxNjM4LjI2
JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1yNS0wMzA3CgoyMDE0LTAzLTA3LTIzOjMxOjMwIGRl
dGVjdGluZyBib290IHN0YXRlIDMuMTMuMC1yYzgtMDA3MjAtZ2U4MWNhODAuLi4JMgkxMgky
MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDU0IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIg
dGhpcyAocm91Z2hseSA2IHN0ZXBzKQpbYzE4NzRlZDdjOTg3NjY0MTc2YmQwMDMwMWY4NDRl
OTE2MDlmZTUzNV0gZHJtL2k5MTU6IGZhY3RvciBvdXQgdmFsbGV5dmlld19waXBlc3RhdF9p
cnFfaGFuZGxlcgpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDUvb2JqLWJpc2VjdApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDcvbGludXgtZGV2
ZWw6ZGV2ZWwtcm9hbS1pMzg2LTIwMTQwMzA3MjE1MTpjMTg3NGVkN2M5ODc2NjQxNzZiZDAw
MzAxZjg0NGU5MTYwOWZlNTM1OmJpc2VjdC1saW51eDUKCjIwMTQtMDMtMDctMjM6MzQ6Mzkg
YzE4NzRlZDdjOTg3NjY0MTc2YmQwMDMwMWY4NDRlOTE2MDlmZTUzNSBjb21waWxpbmcKMjQ4
IHJlYWwgIDI2NjMgdXNlciAgMjI4IHN5cyAgMTE2NS44MCUgY3B1IAlpMzg2LXJhbmRjb25m
aWctcjUtMDMwNwoKMjAxNC0wMy0wNy0yMzo0MDozOCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAz
LjEzLjAtMDA4ODAtZ2MxODc0ZWQuLi4JMi4uLi4uLi4uLi4uCTMJNQk4CTExCTEyLgkxNAkx
Ni4JMTcuLgkxOQkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDIyIHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA1IHN0ZXBzKQpbYzQ4Y2RkMjNlYTUwMDZjMzc3
YjY3MGJjMzA1NmZhN2I2M2Y5MjU3NF0gTWVyZ2UgYnJhbmNoICd0ZGE5OTh4LWRldmVsJyBv
ZiBnaXQ6Ly9mdHAuYXJtLmxpbnV4Lm9yZy51ay9+cm1rL2xpbnV4LWN1Ym94IGludG8gZHJt
LW5leHQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9rZXJuZWwtdGVzdHMvbGludXg1L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA3L2xpbnV4LWRldmVsOmRl
dmVsLXJvYW0taTM4Ni0yMDE0MDMwNzIxNTE6YzQ4Y2RkMjNlYTUwMDZjMzc3YjY3MGJjMzA1
NmZhN2I2M2Y5MjU3NDpiaXNlY3QtbGludXg1CgoyMDE0LTAzLTA3LTIzOjU1OjExIGM0OGNk
ZDIzZWE1MDA2YzM3N2I2NzBiYzMwNTZmYTdiNjNmOTI1NzQgY29tcGlsaW5nCjI5NSByZWFs
ICAyNzAyIHVzZXIgIDIxOSBzeXMgIDk5MC42MiUgY3B1IAlpMzg2LXJhbmRjb25maWctcjUt
MDMwNwoKMjAxNC0wMy0wOC0wMDowMDo0MCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAt
cmM0LTAwMTk1LWdjNDhjZGQyLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMS4JMi4uLgkzLi4u
Lgk0CTUuLi4uLi4JNi4uCTgJOS4JMTIuLgkxNgkxOS4uCTIwIFNVQ0NFU1MKCkJpc2VjdGlu
ZzogMTEgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDQgc3Rl
cHMpCltlZTM1YjAwMjRhOWQ4NWY5Yzg3NDVlMDQ4MWMwOWQ2NWYyNTA3YmQzXSBkcm0vcmFk
ZW9uOiBlbmFibGUgdmNlIGRwbSBvbiBDSQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDUvb2JqLWJpc2Vj
dApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXI1
LTAzMDcvbGludXgtZGV2ZWw6ZGV2ZWwtcm9hbS1pMzg2LTIwMTQwMzA3MjE1MTplZTM1YjAw
MjRhOWQ4NWY5Yzg3NDVlMDQ4MWMwOWQ2NWYyNTA3YmQzOmJpc2VjdC1saW51eDUKCjIwMTQt
MDMtMDgtMDA6Mjg6NDMgZWUzNWIwMDI0YTlkODVmOWM4NzQ1ZTA0ODFjMDlkNjVmMjUwN2Jk
MyBjb21waWxpbmcKMTcwIHJlYWwgIDI3MjggdXNlciAgMjI0IHN5cyAgMTczMS4yOSUgY3B1
IAlpMzg2LXJhbmRjb25maWctcjUtMDMwNwoyMDE0LTAzLTA4LTAwOjMxOjQ4IGVlMzViMDAy
NGE5ZDg1ZjljODc0NWUwNDgxYzA5ZDY1ZjI1MDdiZDMgU0tJUCBCUk9LRU4gQlVJTEQKQ2hl
Y2sgZXJyb3MgaW4gL2tlcm5lbC10ZXN0cy9saW51eDUvb2JqLWJpc2VjdCBhbmQgL3RtcC9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDcvZWUzNWIwMDI0YTlkODVmOWM4NzQ1ZTA0
ODFjMDlkNjVmMjUwN2JkMwpCaXNlY3Rpbmc6IDEwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3Qg
YWZ0ZXIgdGhpcyAocm91Z2hseSA0IHN0ZXBzKQpbNDIzMzI5MDUxOWM3NzllNDRhMDE4MTZj
ZjgyNWY2ZGYwNjdhMDg4Nl0gZHJtL3JhZGVvbjogYWRkIHZjZSBkcG0gc3VwcG9ydCBmb3Ig
S1YvS0IKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9rZXJuZWwtdGVzdHMvbGludXg1L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA3L2xpbnV4LWRldmVsOmRl
dmVsLXJvYW0taTM4Ni0yMDE0MDMwNzIxNTE6NDIzMzI5MDUxOWM3NzllNDRhMDE4MTZjZjgy
NWY2ZGYwNjdhMDg4NjpiaXNlY3QtbGludXg1CgoyMDE0LTAzLTA4LTAwOjMxOjQ5IDQyMzMy
OTA1MTljNzc5ZTQ0YTAxODE2Y2Y4MjVmNmRmMDY3YTA4ODYgY29tcGlsaW5nCjM1IHJlYWwg
IDczIHVzZXIgIDkgc3lzICAyMzEuNjglIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDcK
MjAxNC0wMy0wOC0wMDozMjozNiA0MjMzMjkwNTE5Yzc3OWU0NGEwMTgxNmNmODI1ZjZkZjA2
N2EwODg2IFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9rZXJuZWwtdGVzdHMv
bGludXg1L29iai1iaXNlY3QgYW5kIC90bXAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1yNS0w
MzA3LzQyMzMyOTA1MTljNzc5ZTQ0YTAxODE2Y2Y4MjVmNmRmMDY3YTA4ODYKQmlzZWN0aW5n
OiAxMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNCBzdGVw
cykKWzRkNTM4Yjc5MTk3OTAxZmVjYzQyZTc0NmQ1MTVkMDdmZDEwODliNjJdIE1lcmdlIGJy
YW5jaCAnZHJtLW5leHQtMy4xNScgb2YgZ2l0Oi8vcGVvcGxlLmZyZWVkZXNrdG9wLm9yZy9+
ZGVhdGhzaW1wbGUvbGludXggaW50byBkcm0tbmV4dApydW5uaW5nIC9jL2tlcm5lbC10ZXN0
cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDUvb2Jq
LWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLXI1LTAzMDcvbGludXgtZGV2ZWw6ZGV2ZWwtcm9hbS1pMzg2LTIwMTQwMzA3MjE1MTo0
ZDUzOGI3OTE5NzkwMWZlY2M0MmU3NDZkNTE1ZDA3ZmQxMDg5YjYyOmJpc2VjdC1saW51eDUK
CjIwMTQtMDMtMDgtMDA6MzI6MzcgNGQ1MzhiNzkxOTc5MDFmZWNjNDJlNzQ2ZDUxNWQwN2Zk
MTA4OWI2MiBjb21waWxpbmcKMTcyIHJlYWwgIDI4OTQgdXNlciAgMjQ5IHN5cyAgMTgxOS4y
OSUgY3B1IAlpMzg2LXJhbmRjb25maWctcjUtMDMwNwoKMjAxNC0wMy0wOC0wMDozNTo1MyBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmM0LTAwMjE1LWc0ZDUzOGI3Li4uCTIJOAkx
NAkxOAkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKWzA2YmRjOWFhM2NkM2EwNDViNGE5NGJkYzRj
NmM1ODIzMzhjZjc5OTJdIGRybTogYWRkIGtlcm5lbC1sb2cgcmVuZGVyZXIKcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVz
dHMvbGludXg1L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3Zt
L2kzODYtcmFuZGNvbmZpZy1yNS0wMzA3L2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0y
MDE0MDMwNzIxNTE6MDZiZGM5YWEzY2QzYTA0NWI0YTk0YmRjNGM2YzU4MjMzOGNmNzk5Mjpi
aXNlY3QtbGludXg1CgoyMDE0LTAzLTA4LTAwOjM5OjU0IDA2YmRjOWFhM2NkM2EwNDViNGE5
NGJkYzRjNmM1ODIzMzhjZjc5OTIgY29tcGlsaW5nCjM1IHJlYWwgIDIwNSB1c2VyICAyNyBz
eXMgIDY2NC4wMCUgY3B1IAlpMzg2LXJhbmRjb25maWctcjUtMDMwNwoKMjAxNC0wMy0wOC0w
MDo0MDo0NyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmM0LTAwMjE3LWcwNmJkYzlh
Li4gVEVTVCBGQUlMVVJFClsgICAxNS4xODMwMDRdIFdyaXRlIHByb3RlY3RpbmcgdGhlIGtl
cm5lbCB0ZXh0OiA4ODI0awpbICAgMTUuMTg0MzI2XSBXcml0ZSBwcm90ZWN0aW5nIHRoZSBr
ZXJuZWwgcmVhZC1vbmx5IGRhdGE6IDM0NzJrClsgICAxNS4yMDA0OTRdIHJhbmRvbTogaW5p
dCB1cmFuZG9tIHJlYWQgd2l0aCAxIGJpdHMgb2YgZW50cm9weSBhdmFpbGFibGUKWyAgIDE1
LjIwMTQxNV0gQlVHOiBzbGVlcGluZyBmdW5jdGlvbiBjYWxsZWQgZnJvbSBpbnZhbGlkIGNv
bnRleHQgYXQgL2tlcm5lbC10ZXN0cy9saW51eDUva2VybmVsL2xvY2tpbmcvbXV0ZXguYzo2
MTYKWyAgIDE1LjIwMTQxNl0gaW5fYXRvbWljKCk6IDAsIGlycXNfZGlzYWJsZWQoKTogMSwg
cGlkOiAxLCBuYW1lOiBpbml0ClsgICAxNS4yMDE0MThdIG5vIGxvY2tzIGhlbGQgYnkgaW5p
dC8xLgpbICAgMTUuMjAxNDI1XSBDUFU6IDEgUElEOiAxIENvbW06IGluaXQgTm90IHRhaW50
ZWQgMy4xNC4wLXJjNC0wMDIxNy1nMDZiZGM5YSAjMTEyClsgICAxNS4yMDE0MzNdICAwMDAw
MDAwMCAwMDAwMDAwMCA4NDAyM2RkOCA3OTg4NjQ4YyAwMDAwMDAwMSA4NDAyM2UwMCA3OTA2
ZDgyNSA3OWIxZjAxYwpbICAgMTUuMjAxNDM5XSAgMDAwMDAwMDAgMDAwMDAwMDEgMDAwMDAw
MDEgODQwMWUyOWMgNzljNDc5YTAgMDAwMDAwMDAgODQwMWUwMDAgODQwMjNlNWMKWyAgIDE1
LjIwMTQ0NV0gIDc5ODkyMzFhIDAwMDAwMDAwIDdmZmZmZmZmIGZhMmYyZTNmIDc5YjFhMTg0
IDZjMGEwMTAwIGZmZmYwMDA2IDc5MzlkNmM4ClsgICAxNS4yMDE0NDddIENhbGwgVHJhY2U6
ClsgICAxNS4yMDE0NThdICBbPDc5ODg2NDhjPl0gZHVtcF9zdGFjaysweDQ4LzB4NjAKWyAg
IDE1LjIwMTQ2N10gIFs8NzkwNmQ4MjU+XSBfX21pZ2h0X3NsZWVwKzB4MTA1LzB4MTEwClsg
ICAxNS4yMDE0NzNdICBbPDc5ODkyMzFhPl0gbXV0ZXhfbG9ja19uZXN0ZWQrMHgyYS8weDQz
MApbICAgMTUuMjAxNDg4XSAgWzw3OTM5ZDZjOD5dID8gaW9fc2VyaWFsX2luKzB4OC8weDIw
ClsgICAxNS4yMDE0OTJdICBbPDc5MzllMzUyPl0gPyB3YWl0X2Zvcl94bWl0cisweDIyLzB4
OTAKWyAgIDE1LjIwMTUwMF0gIFs8NzkwOTNiMzI+XSA/IGRvX3Jhd19zcGluX3VubG9jaysw
eGIyLzB4ZTAKWyAgIDE1LjIwMTUxM10gIFs8NzkzZDc3MDA+XSA/IGRybV9sb2dfd3JpdGUr
MHg5MC8weGUwClsgICAxNS4yMDE1MTZdICBbPDc5M2Q3NzI0Pl0gZHJtX2xvZ193cml0ZSsw
eGI0LzB4ZTAKWyAgIDE1LjIwMTUyMF0gIFs8NzkzOWU0YmE+XSA/IHNlcmlhbDgyNTBfY29u
c29sZV93cml0ZSsweGZhLzB4MTIwClsgICAxNS4yMDE1MjRdICBbPDc5MzllNGUwPl0gPyBz
ZXJpYWw4MjUwX2NvbnNvbGVfd3JpdGUrMHgxMjAvMHgxMjAKWyAgIDE1LjIwMTUyN10gIFs8
NzkzZDc3NjM+XSBkbG9nX2Nvbl93cml0ZSsweDEzLzB4MjAKWyAgIDE1LjIwMTUzMV0gIFs8
NzkwOTdhYzM+XSBjYWxsX2NvbnNvbGVfZHJpdmVycy5jb25zdHByb3AuOCsweDEzMy8weDFi
MApbICAgMTUuMjAxNTM1XSAgWzw3OTA5ODA5MD5dIGNvbnNvbGVfdW5sb2NrKzB4MzMwLzB4
NGUwClsgICAxNS4yMDE1MzldICBbPDc5MDk4ODhhPl0gdnByaW50a19lbWl0KzB4NjRhLzB4
NjgwClsgICAxNS4yMDE1NDRdICBbPDc5ODgyYWQwPl0gcHJpbnRrKzB4M2QvMHgzZgpbICAg
MTUuMjAxNTQ5XSAgWzw3OTNhNTE4Yj5dIHVyYW5kb21fcmVhZCsweDZiLzB4MTEwClsgICAx
NS4yMDE1NTNdICBbPDc5M2E1MTIwPl0gPyByYW5kb21fcmVhZCsweDFjMC8weDFjMApbICAg
MTUuMjAxNTc2XSAgWzw3OTE0NjgzYj5dIHZmc19yZWFkKzB4YmIvMHgxNTAKWyAgIDE1LjIw
MTU4MF0gIFs8NzkxNDZmNTk+XSBTeVNfcmVhZCsweDQ5LzB4ODAKWyAgIDE1LjIwMTU4NV0g
IFs8Nzk4OWNjOGE+XSBzeXNlbnRlcl9kb19jYWxsKzB4MTIvMHgzYwovYmluL3NoOiAvcHJv
Yy9zZWxmL2ZkLzk6IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkKL2Jpbi9zaDogL3Byb2Mv
c2VsZi9mZC85OiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5Ci9iaW4vc2g6IC9wcm9jL3Nl
bGYvZmQvOTogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1yNS0wMzA3LzA2YmRjOWFhM2NkM2EwNDViNGE5NGJkYzRjNmM1ODIzMzhjZjc5OTIv
ZG1lc2ctcXVhbnRhbC1zbmItMTY6MjAxNDAzMDgwMDQxMjY6aTM4Ni1yYW5kY29uZmlnLXI1
LTAzMDc6OgowOjE6MSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0w
My0wOCAwMDo0MTo0OCBSRVBFQVQgQ09VTlQ6IDIwICAjIC9rZXJuZWwtdGVzdHMvbGludXg1
L29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMCBzdGVwcykKWzMyYWZiMTMzN2JkZmZkMWRm
MmFjNGFlNzQ5ZWFjZTM3NTI4Yzc0N2ZdIGxpYjogcmVtb3ZlIEZCQ09OIGRlcGVuZGVuY3kg
Zm9yIGZvbnRzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4NS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwt
dGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctcjUtMDMwNy9saW51eC1kZXZl
bDpkZXZlbC1yb2FtLWkzODYtMjAxNDAzMDcyMTUxOjMyYWZiMTMzN2JkZmZkMWRmMmFjNGFl
NzQ5ZWFjZTM3NTI4Yzc0N2Y6YmlzZWN0LWxpbnV4NQoKMjAxNC0wMy0wOC0wMDo0MTo0OSAz
MmFmYjEzMzdiZGZmZDFkZjJhYzRhZTc0OWVhY2UzNzUyOGM3NDdmIGNvbXBpbGluZwozOSBy
ZWFsICAyMDQgdXNlciAgMjggc3lzICA1OTQuMjQlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXI1
LTAzMDcKCjIwMTQtMDMtMDgtMDA6NDI6NTAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4w
LXJjNC0wMDIxNi1nMzJhZmIxMy4uLgkyCTQJNS4uLi4uLi4uLgk2Lgk4CTExCTEyLgkxMwkx
NwkxOAkxOQkyMCBTVUNDRVNTCgowNmJkYzlhYTNjZDNhMDQ1YjRhOTRiZGM0YzZjNTgyMzM4
Y2Y3OTkyIGlzIHRoZSBmaXJzdCBiYWQgY29tbWl0CmNvbW1pdCAwNmJkYzlhYTNjZDNhMDQ1
YjRhOTRiZGM0YzZjNTgyMzM4Y2Y3OTkyCkF1dGhvcjogRGF2aWQgSGVycm1hbm4gPGRoLmhl
cnJtYW5uQGdtYWlsLmNvbT4KRGF0ZTogICBXZWQgTWFyIDUgMTc6MzQ6NDkgMjAxNCArMDEw
MAoKICAgIGRybTogYWRkIGtlcm5lbC1sb2cgcmVuZGVyZXIKICAgIAogICAgT24gbW9kZXJu
IGxpbnV4IHVzZXItc3BhY2UsIHRoZSBWVCBzdWJzeXN0ZW0gaXMgbm8gbG9uZ2VyIG5lZWRl
ZCBmb3IKICAgIHN5c3RlbSBjb25zb2xlcy4gQWx0aG91Z2ggbW9zdCBERXMgd2lsbCBmYWls
IGlmIFZUcyBhcmUgZGlzYWJsZWQsIHRoZXJlCiAgICBhcmUgc2V2ZXJhbCBnZngtc3lzdGVt
cyB0aGF0IHN1cHBvcnQgdGhpcyBtb2RlLiBFc3BlY2lhbGx5IHRoZSBsb3dlcgogICAgc3lz
dGVtIHN0YWNrIGhhcyBiZWVuIGV4dGVuZGVkIHRvIHdvcmsgd2l0aG91dCBWVHMuCiAgICAK
ICAgIEhvd2V2ZXIsIHRoZXJlIGlzIG9uZSBtYWpvciBkcmF3YmFjayBpZiBWVHMgYXJlIGRp
c2FibGVkOiBZb3UgZG9uJ3QgZ2V0CiAgICBvb3BzL3BhbmljLXNjcmVlbnMgbm9yIGVhcmx5
IGJvb3QtZGVidWdnaW5nLiBUaGUgVlQgc3Vic3lzdGVtIHJlZ2lzdGVycyBhCiAgICBjb25z
b2xlLWRyaXZlciwgdGh1cyBkaXNwbGF5cyB0aGUga2VybmVsIGxvZyBhbmQgb29wcy9wYW5p
YyBzY3JlZW5zIGluCiAgICB0aG9zZSBzaXR1YXRpb25zLiBUaGlzIHBhdGNoIGludHJvZHVj
ZXMgYSBmYWxsYmFjayBmb3IgQ09ORklHX1ZUPW4uCiAgICAKICAgIEEgbmV3IERSTS1Mb2cg
Y29yZSBpcyBhZGRlZC4gQXQgaXRzIGhlYXJ0LCBEUk0tTG9nIG1haW50YWlucyBhIGxvZy1i
dWZmZXIKICAgIG9mIGtlcm5lbC1sb2cgbWVzc2FnZXMuIEl0IHJlZ2lzdGVycyBhIGNvbnNv
bGUtZHJpdmVyIGFuZCBwdXNoZXMgbmV3CiAgICBtZXNzYWdlcyBpbnRvIHRoaXMgYnVmZmVy
IHdoZW5ldmVyIHRoZXkgYXBwZWFyLiBUaGUgc2l6ZSBvZiB0aGUgbG9nLWJ1ZmZlcgogICAg
Y2FuIGJlIGNoYW5nZWQgdmlhIGRybV9sb2dfZW5zdXJlX3NpemUoKS4gSW5pdGlhbGx5LCBh
IHN1aXRhYmxlIGJ1ZmZlciBpcwogICAgY2hvc2VuLCBidXQgd2hlbmV2ZXIgZHJpdmVycyBy
ZWdpc3RlciBoaWdoLXJlcyBDUlRDcywgdGhleSBvdWdodCB0bwogICAgaW5jcmVhc2UgdGhh
dCBidWZmZXIgdG8gZ3VhcmFudGVlIHRoZXJlJ3MgYWx3YXlzIGVub3VnaCBkYXRhIHRvIHJl
bmRlciB0aGUKICAgIHdob2xlIHNjcmVlbi4KICAgIFRoaXMgbG9nLWJ1ZmZlciBpcyBtYW5h
Z2VkIGF0IHRoZSBjaGFyYWN0ZXItbGV2ZWwsIG5vdCBwaXhlbC1sZXZlbC4gSXQgaXMKICAg
IHNoYXJlZCBhY3Jvc3MgYWxsIHVzZXJzLCBzdXBwb3J0cyBwYXJhbGxlbCwgYXRvbWljIHJl
YWRlcnMgYW5kIHdyaXRlcnMgYW5kCiAgICBzdXBwb3J0cyBzZWFtbGVzcyByZXNpemluZy4K
ICAgIAogICAgQWRkaXRpb25hbGx5IHRvIHRoZSBsb2ctYnVmZmVyIGhhbmRsaW5nLCBhIGdl
bmVyaWMgc29mdHdhcmUgcmVuZGVyZXIgaXMKICAgIGludHJvZHVjZWQuIGRybV9sb2dfZHJh
dygpIHJlbmRlcnMgdGhlIGN1cnJlbnQgbG9nLWJ1ZmZlciBpbnRvIGFueQogICAgbWVtb3J5
LW1hcHBlZCBmcmFtZWJ1ZmZlciB5b3Ugd2FudC4gTm90ZSB0aGF0IGl0IHN1cHBvcnRzIHNw
bGl0dGluZyBsaW5lcwogICAgaW4gY2FzZSB5b3VyIGZyYW1lYnVmZmVyIGlzIHNtYWxsZXIg
dGhhbiB0aGUgbG9nLWJ1ZmZlciwgYnV0IGFsc28gbWVyZ2luZwogICAgY29udGludWF0aW9u
IGxpbmVzIGluIGNhc2UgeW91ciBmcmFtZWJ1ZmZlciBpcyB3aWRlci4gVGhpcyBhbGxvd3MK
ICAgIHJlbmRlcmluZyBhbiA4MHgyNSBsb2ctYnVmZmVyIGluIGZ1bGwtd2lkdGggb24gaGln
aC1yZXMgZGlzcGxheXMuIE9uIHRoZQogICAgb3RoZXIgaGFuZCwgODAweDI1MCBsb2ctYnVm
ZmVycyBjYW4gYmUgcmVuZGVyZWQgd2l0aG91dCBpbmZvcm1hdGlvbiBsb3NzCiAgICAoYXBh
cnQgZnJvbSBhIHNob3J0ZXIgYmFja2xvZykgb24gbG93LXJlcyBkaXNwbGF5cy4KICAgIAog
ICAgTm8gaGlnaC1sZXZlbCBBUEkgaXMgaW50cm9kdWNlZCwgeWV0LiBTbyBmb3Igbm93IGRy
aXZlcnMgbmVlZCB0byBkZWNpZGUKICAgIHdoZW4gYW5kIHdoZXJlIHRvIHJlbmRlciBvbiB0
aGVpciBvd24uIEEgZ2VuZXJpYyBpbnRlcmZhY2Ugd2l0aAogICAgcGFuaWMtaGFuZGxlcnMs
IHNjaGVkdWxlZCByZWRyYXdpbmcgYW5kIGF1dG9tYXRpYyBtb2Rlc2V0dGluZyB3aWxsIGJl
CiAgICBhZGRlZCBpbiBmb2xsb3ctdXBzLgogICAgCiAgICBBIGZldyBtb3JlIG5vdGVzOgog
ICAgIC0gVGhpcyBpcyBmb3IgKmRlYnVnZ2luZyosIGFuZCBmb3IgZGVidWdnaW5nIG9ubHkh
IFlvdSBjYW4gdXNlIHRoaXMKICAgICAgIHJlbmRlcmVyIHRvIGdldCBhIGtlcm5lbC1sb2cg
b250byB5b3VyIGZyYW1lYnVmZmVycy4gSG93ZXZlciwgdGhlCiAgICAgICByZW5kZXJlciBp
cyBob3JyaWJseSBzbG93ISBUaGVyZSBpcyBubyBpbnRlbnRpb24gdG8gc3BlZWQgaXQgdXAu
IE5vLW9uZQogICAgICAgY2FyZXMgd2hldGhlciBpdCB0YWtlcyA1MDBtcyB0byByZW5kZXIg
eW91ciBwYW5pYy1zY3JlZW4hCiAgICAgLSBJZiB5b3UgZW5hYmxlIHRoZSBsb2ctcmVuZGVy
ZXIgZm9yIGEgY29udGlub3VzIGJvb3QtbG9nLCB5b3UncmUKICAgICAgIHN1cHBvc2VkIHRv
IHJlZHJhdyBvbiB2YmxhbmtzLiBUaGUgcmVuZGVyZXIgZG9lcyBub3Qgc3VwcG9ydAogICAg
ICAgZGFtYWdlLXRyYWNraW5nIGFzIGVhY2ggbmV3LWxpbmUgY2F1c2VzIGEgc2Nyb2xsLXVw
LCBhbnl3YXkuCiAgICAgLSBUaGUgcmVuZGVyZXIgd29ya3MgYm90dG9tLXVwIGFuZCByaWdo
dC10by1sZWZ0LiBUaGlzIGlzIHJlcXVpcmVkIHRvCiAgICAgICBhdm9pZCBwcmUtY2FsY3Vs
YXRpbmcgbG9nIHNpemVzLgogICAgIC0gVGhlIHJlbmRlcmVyIHN1cHBvcnRzIG11bHRpcGxl
IGNvbHVtbnMuIFRoaXMgaXMgcXVpdGUgaGFuZHkgb24gaGlnaC1yZXMKICAgICAgIHNjcmVl
bnMgd2hlcmUgeW91IGNhbiBnZXQgYmlnZ2VyIGJhY2tsb2dzIHRoaXMgd2F5LiBVc3VhbGx5
IDgwJSBvZiB0aGUKICAgICAgIHNjcmVlbiBhcmUgYmxhY2suIE5vdyB5b3UgY2FuIHJldXNl
IHRoaXMgZm9yIHRoZSBuZXh0IGxvZy1jb2x1bW4uCiAgICAgLSBUaGUgcmVuZGVyZXIgc3Vw
cG9ydHMgaW50ZWdlci1zY2FsaW5nIGZvciBoaWdoLURQSSBzY3JlZW5zLiBJbnN0ZWFkIG9m
CiAgICAgICB1c2luZyBoaWdoLXJlcyBmb250cyB3ZSBzaW1wbHkgc2NhbGUgZm9udHMuIFRo
aXMgaXMgKm5vdCogaW50ZW5kZWQgdG8KICAgICAgIGluY3JlYXNlIHJlc29sdXRpb24gYnV0
IHJhdGhlciB0byBtYWtlIHRoZSBsb2cgcmVhZGFibGUuCiAgICAgLSBJIGhhdmUgc29tZSB3
cmFwcGVycyB0byB1c2UgdGhpcyBpbiB1c2VyLXNwYWNlLiBJIGRpZCBzZXZlcmFsIHRlc3Rz
CiAgICAgICB3aXRoIHJlc2l6aW5nIGFuZCBkaWZmZXJlbnQgYnVmZmVyLXNpemVzIGFuZCB2
YWxncmluZCBkaWRuJ3QgY29tcGxhaW4uCiAgICAgICBSZXN1bHRzIGxvb2tlZCBhbGwgZmlu
ZS4KICAgICAtIFRoZSByZW5kZXJlciBzdXBwb3J0cyAqYW55KiBSR0IgdGFyZ2V0LCBmcm9t
IDhiaXQgdG8gMzJiaXQgd2l0aAogICAgICAgYmlnLWVuZGlhbiBhbmQgbGl0dGxlLWVuZGlh
biBzdXBwb3J0LiBUaGUgcmVsYXRlZCBwaXhlbC1yZW5kZXJlciB3aWxsCiAgICAgICBwcm9i
YWJseSBuZXZlciB3aW4gYSBiZWF1dHktY29udGVzdCwgYnV0IGl0IHdvcmtzLi4gQWdhaW4s
IHdobyBjYXJlcwogICAgICAgZm9yIGRlYnVnLWxvZyByZW5kZXJpbmcgc3BlZWQ/CiAgICAg
LSBJZiB5b3Ugd2FudCBhIG5vcm1hbCBib290LWxvZywgdXNlIGEgdXNlci1zcGFjZSBsb2ct
cmVuZGVyZXIgKGxpa2UKICAgICAgIGV4cGVyaW1lbnRpYWwgc3lzdGVtZC1lciAobm8gbWVy
Z2VkLCB5ZXQpKS4gVGhleSBjYW4gcmVuZGVyIHdpdGggcHJvcGVyCiAgICAgICBzcGVlZCwg
Y2FuIGRvIGh3LXNjcm9sbGluZyBhbmQgbW9yZS4KICAgICAgIE9yOiBFbmFibGUgVlRzISBT
ZXJpb3VzbHksIGlmIHlvdSB3YW50IGFsbCB0aGUgVlQgZmVhdHVyZXMsIHVzZSBWVHMhIEkK
ICAgICAgIHdpbGwgbm90IHRlbGwgeW91IHRvIGRpc2FibGUgdGhlbS4KICAgIAogICAgT24g
YSBsYXN0IG5vdGU6CiAgICAgIFdpdGggdGhpcyAoYW5kIHRoZSBoaWdoLWxldmVsIGludGVn
cmF0aW9uKSBpbiBwbGFjZSwgeW91IGNhbiBlYXNpbHkKICAgICAgZGlzYWJsZSBDT05GSUdf
RkIsIENPTkZJR19WVCBhbmQgQ09ORklHX0ZSQU1FQlVGRkVSX0NPTlNPTEUuIENvbWJpbmVk
CiAgICAgIHdpdGggYSBwcm9wZXIgdXNlci1zcGFjZSBzeXN0ZW0tY29uc29sZSwgeW91IHdp
bGwgZW5kIHVwIHdpdGggbW9yZQogICAgICBmZWF0dXJlcywgbGVzcyBidWdzIGFuZCBkZWZp
bml0ZWx5IHNvbWUgaGFwcHkga2VybmVsIG1haW50YWluZXJzLgogICAgCiAgICBTaWduZWQt
b2ZmLWJ5OiBEYXZpZCBIZXJybWFubiA8ZGguaGVycm1hbm5AZ21haWwuY29tPgoKOjA0MDAw
MCAwNDAwMDAgOGZmNjBkYmEzYzFhMTBmMjQ3NzUwOWVjMTU4Mzg2MmM3YjU1NjdkYSAyOWNl
ZWUwYWYyNTBhYWYwZDFhM2I3ZTRiZTMwN2Y5M2JmODE2YjczIE0JZHJpdmVycwo6MDQwMDAw
IDA0MDAwMCA4YjkwZWIxNzQ4NDUyNGUzYjUwOGJhY2YxNWM0MjQ3ODFmMTEyNTQ0IGI5OGNi
YjZkZTFjOWZkMmQwNDZmNzQ5YTRiMTY4MzZhZTJhOTBhZTMgTQlpbmNsdWRlCmJpc2VjdCBy
dW4gc3VjY2VzcwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5k
Y29uZmlnLXI1LTAzMDcvbGludXgtZGV2ZWw6ZGV2ZWwtcm9hbS1pMzg2LTIwMTQwMzA3MjE1
MTozMmFmYjEzMzdiZGZmZDFkZjJhYzRhZTc0OWVhY2UzNzUyOGM3NDdmOmJpc2VjdC1saW51
eDUKCjIwMTQtMDMtMDgtMDA6NTU6NTEgMzJhZmIxMzM3YmRmZmQxZGYyYWM0YWU3NDllYWNl
Mzc1MjhjNzQ3ZiByZXVzZSAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA3LzMyYWZi
MTMzN2JkZmZkMWRmMmFjNGFlNzQ5ZWFjZTM3NTI4Yzc0N2Yvdm1saW51ei0zLjE0LjAtcmM0
LTAwMjE2LWczMmFmYjEzCgoyMDE0LTAzLTA4LTAwOjU1OjUxIGRldGVjdGluZyBib290IHN0
YXRlIC4uLi4uLi4uLi4uLi4uLi4uLgkyMQk0Ngk2MCBTVUNDRVNTCgpscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDcvbGludXgtZGV2
ZWw6ZGV2ZWwtcm9hbS1pMzg2LTIwMTQwMzA3MjE1MTowNWZmZDljYjY3YzFiYzlhNGI0ZTMw
MDdkZjMyNmU0ZTZmMmQ3ZGIwOmJpc2VjdC1saW51eDUKIFRFU1QgRkFJTFVSRQpbICAgIDMu
MjU3MDc2XSAuLi4gUElDIEVMQ1I6IDBjMDAKWyAgICAzLjI1MDAxNl0gcHJpbnRpbmcgbG9j
YWwgQVBJQyBjb250ZW50cyBvbiBDUFUjMC8wOgpbICAgIDMuMjUwMDE2XSAtLS0tLS0tLS0t
LS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAzLjI1MDAxNl0gV0FSTklORzogQ1BV
OiAwIFBJRDogMzkgYXQga2VybmVsL2xvY2tpbmcvbXV0ZXguYzo1MTYgbXV0ZXhfbG9ja19u
ZXN0ZWQrMHhjNy8weDQzMCgpClsgICAgMy4yNTAwMTZdIERFQlVHX0xPQ0tTX1dBUk5fT04o
aW5faW50ZXJydXB0KCkpClsgICAgMy4yNTAwMTZdIE1vZHVsZXMgbGlua2VkIGluOgpbICAg
IDMuMjUwMDE2XSBDUFU6IDAgUElEOiAzOSBDb21tOiByYl9jb25zdW1lciBOb3QgdGFpbnRl
ZCAzLjE0LjAtcmM1LTAwNTU4LWcwNWZmZDljICMyMzAKWyAgICAzLjI1MDAxNl0gIDAwMDAw
MDAwIDAwMDAwMDAwIDg3ODUzY2IwIDc5ODg2MGVjIDg3ODUzY2YwIDg3ODUzY2UwIDc5MDQx
NGVlIDc5YjFhMDc0ClsgICAgMy4yNTAwMTZdICA4Nzg1M2QwYyAwMDAwMDAyNyA3OWIxZmJm
OCAwMDAwMDIwNCA3OTg5MjAxNyA3OTg5MjAxNyA3OWM0OTlhMCAwMDAwMDAwMQpbICAgIDMu
MjUwMDE2XSAgODNmODYwMDAgODc4NTNjZjggNzkwNDE1NDMgMDAwMDAwMDkgODc4NTNjZjAg
NzliMWEwNzQgODc4NTNkMGMgODc4NTNkNTQKWyAgICAzLjI1MDAxNl0gQ2FsbCBUcmFjZToK
WyAgICAzLjI1MDAxNl0gIFs8Nzk4ODYwZWM+XSBkdW1wX3N0YWNrKzB4NDgvMHg2MApbICAg
IDMuMjUwMDE2XSAgWzw3OTA0MTRlZT5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4N2UvMHhh
MApbICAgIDMuMjUwMDE2XSAgWzw3OTg5MjAxNz5dID8gbXV0ZXhfbG9ja19uZXN0ZWQrMHhj
Ny8weDQzMApbICAgIDMuMjUwMDE2XSAgWzw3OTg5MjAxNz5dID8gbXV0ZXhfbG9ja19uZXN0
ZWQrMHhjNy8weDQzMApbICAgIDMuMjUwMDE2XSAgWzw3OTA0MTU0Mz5dIHdhcm5fc2xvd3Bh
dGhfZm10KzB4MzMvMHg0MApbICAgIDMuMjUwMDE2XSAgWzw3OTg5MjAxNz5dIG11dGV4X2xv
Y2tfbmVzdGVkKzB4YzcvMHg0MzAKWyAgICAzLjI1MDAxNl0gIFs8NzkzOWQ3MTg+XSA/IGlv
X3NlcmlhbF9pbisweDgvMHgyMApbICAgIDMuMjUwMDE2XSAgWzw3OTM5ZTNhMj5dID8gd2Fp
dF9mb3JfeG1pdHIrMHgyMi8weDkwClsgICAgMy4yNTAwMTZdICBbPDc5M2Q3NzQ0Pl0gPyBk
cm1fbG9nX3dyaXRlKzB4YjQvMHhlMApbICAgIDMuMjUwMDE2XSAgWzw3OTA5M2FjMj5dID8g
ZG9fcmF3X3NwaW5fdW5sb2NrKzB4YjIvMHhlMApbICAgIDMuMjUwMDE2XSAgWzw3OTNkNzcw
MD5dID8gZHJtX2xvZ193cml0ZSsweDcwLzB4ZTAKWyAgICAzLjI1MDAxNl0gIFs8NzkzZDc3
NDQ+XSBkcm1fbG9nX3dyaXRlKzB4YjQvMHhlMApbICAgIDMuMjUwMDE2XSAgWzw3OTM5ZTUw
YT5dID8gc2VyaWFsODI1MF9jb25zb2xlX3dyaXRlKzB4ZmEvMHgxMjAKWyAgICAzLjI1MDAx
Nl0gIFs8NzkzOWU1MzA+XSA/IHNlcmlhbDgyNTBfY29uc29sZV93cml0ZSsweDEyMC8weDEy
MApbICAgIDMuMjUwMDE2XSAgWzw3OTNkNzc4Mz5dIGRsb2dfY29uX3dyaXRlKzB4MTMvMHgy
MApbICAgIDMuMjUwMDE2XSAgWzw3OTA5N2E1Mz5dIGNhbGxfY29uc29sZV9kcml2ZXJzLmNv
bnN0cHJvcC44KzB4MTMzLzB4MWIwClsgICAgMy4yNTAwMTZdICBbPDc5MDk4MDE4Pl0gY29u
c29sZV91bmxvY2srMHgzMjgvMHg0YzAKWyAgICAzLjI1MDAxNl0gIFs8NzkwOTg3ZmE+XSB2
cHJpbnRrX2VtaXQrMHg2NGEvMHg2ODAKWyAgICAzLjI1MDAxNl0gIFs8Nzk4ODI3MzA+XSBw
cmludGsrMHgzZC8weDNmClsgICAgMy4yNTAwMTZdICBbPDc5ZDAyZjI2Pl0gcHJpbnRfbG9j
YWxfQVBJQysweDI5LzB4M2U2ClsgICAgMy4yNTAwMTZdICBbPDc5MGI4NTEwPl0gZ2VuZXJp
Y19zbXBfY2FsbF9mdW5jdGlvbl9zaW5nbGVfaW50ZXJydXB0KzB4ZTAvMHgyMzAKWyAgICAz
LjI1MDAxNl0gIFs8NzkwMmFhMzU+XSBzbXBfY2FsbF9mdW5jdGlvbl9zaW5nbGVfaW50ZXJy
dXB0KzB4MjUvMHg0MApbICAgIDMuMjUwMDE2XSAgWzw3OTg5NjZkYT5dIGNhbGxfZnVuY3Rp
b25fc2luZ2xlX2ludGVycnVwdCsweDMyLzB4MzgKWyAgICAzLjI1MDAxNl0gIFs8NzkwOTAw
N2I+XSA/IGRlYnVnX3Nob3dfYWxsX2xvY2tzKzB4ZmIvMHgxOTAKWyAgICAzLjI1MDAxNl0g
IFs8NzkwZDkwYWE+XSA/IHJpbmdfYnVmZmVyX2NvbnN1bWUrMHgxMWEvMHgxNTAKWyAgICAz
LjI1MDAxNl0gIFs8NzkwZGE2YTM+XSByaW5nX2J1ZmZlcl9jb25zdW1lcl90aHJlYWQrMHg4
My8weDUwMApbICAgIDMuMjUwMDE2XSAgWzw3OTBkYTYyMD5dID8gcmluZ19idWZmZXJfcHJv
ZHVjZXJfdGhyZWFkKzB4NWEwLzB4NWEwClsgICAgMy4yNTAwMTZdICBbPDc5MDY0MjIzPl0g
a3RocmVhZCsweGIzLzB4YzAKWyAgICAzLjI1MDAxNl0gIFs8Nzk4OWM4Mzc+XSByZXRfZnJv
bV9rZXJuZWxfdGhyZWFkKzB4MWIvMHgyOApbICAgIDMuMjUwMDE2XSAgWzw3OTA2NDE3MD5d
ID8gX19rdGhyZWFkX3VucGFyaysweDUwLzB4NTAKWyAgICAzLjI1MDAxNl0gLS0tWyBlbmQg
dHJhY2UgYmExN2NlMjRlZmFhODg5NiBdLS0tClsgICAgMy4yNTAwMTZdIC4uLiBBUElDIElE
OiAgICAgIDAwMDAwMDAwICgwKQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA3LzA1
ZmZkOWNiNjdjMWJjOWE0YjRlMzAwN2RmMzI2ZTRlNmYyZDdkYjAvZG1lc2cteW9jdG8td2Fp
bWVhLTE0OjIwMTQwMzA3MjMxMDI2OmkzODYtcmFuZGNvbmZpZy1yNS0wMzA3OjMuMTQuMC1y
YzUtMDA1NTgtZzA1ZmZkOWM6MjMwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDcv
MDVmZmQ5Y2I2N2MxYmM5YTRiNGUzMDA3ZGYzMjZlNGU2ZjJkN2RiMC9kbWVzZy1xdWFudGFs
LWF0aGVucy00MzoyMDE0MDMwNzIzMDg1ODppMzg2LXJhbmRjb25maWctcjUtMDMwNzozLjE0
LjAtcmM1LTAwNTU4LWcwNWZmZDljOjIzMAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yNS0w
MzA3LzA1ZmZkOWNiNjdjMWJjOWE0YjRlMzAwN2RmMzI2ZTRlNmYyZDdkYjAvZG1lc2cteW9j
dG8teGlhbi0xNjoyMDE0MDMwNzIyMjMwNjppMzg2LXJhbmRjb25maWctcjUtMDMwNzozLjE0
LjAtcmM1LTAwNTU4LWcwNWZmZDljOjIzMAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yNS0w
MzA3LzA1ZmZkOWNiNjdjMWJjOWE0YjRlMzAwN2RmMzI2ZTRlNmYyZDdkYjAvZG1lc2cteW9j
dG8tc25iLTMyOjIwMTQwMzA3MjIyMzMxOmkzODYtcmFuZGNvbmZpZy1yNS0wMzA3OjoKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctcjUtMDMwNy8wNWZmZDljYjY3YzFiYzlhNGI0ZTMwMDdk
ZjMyNmU0ZTZmMmQ3ZGIwL2RtZXNnLXF1YW50YWwtc25iLTI1OjIwMTQwMzA3MjIyMzQ3Omkz
ODYtcmFuZGNvbmZpZy1yNS0wMzA3OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjUtMDMw
Ny8wNWZmZDljYjY3YzFiYzlhNGI0ZTMwMDdkZjMyNmU0ZTZmMmQ3ZGIwL2RtZXNnLXlvY3Rv
LWF0aGVucy0xMToyMDE0MDMwNzIzMTAwOTppMzg2LXJhbmRjb25maWctcjUtMDMwNzozLjE0
LjAtcmM1LTAwNTU4LWcwNWZmZDljOjIzMAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yNS0w
MzA3LzA1ZmZkOWNiNjdjMWJjOWE0YjRlMzAwN2RmMzI2ZTRlNmYyZDdkYjAvZG1lc2cteW9j
dG8tYXRoZW5zLTM3OjIwMTQwMzA3MjMwNzU0OmkzODYtcmFuZGNvbmZpZy1yNS0wMzA3OjMu
MTQuMC1yYzUtMDA1NTgtZzA1ZmZkOWM6MjMwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI1
LTAzMDcvMDVmZmQ5Y2I2N2MxYmM5YTRiNGUzMDA3ZGYzMjZlNGU2ZjJkN2RiMC9kbWVzZy15
b2N0by14aWFuLTE2OjIwMTQwMzA3MjIyMTM1OmkzODYtcmFuZGNvbmZpZy1yNS0wMzA3OjMu
MTQuMC1yYzUtMDA1NTgtZzA1ZmZkOWM6MjMwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI1
LTAzMDcvMDVmZmQ5Y2I2N2MxYmM5YTRiNGUzMDA3ZGYzMjZlNGU2ZjJkN2RiMC9kbWVzZy15
b2N0by1yb2FtLTIyOjIwMTQwMzA3MjMwNzUxOmkzODYtcmFuZGNvbmZpZy1yNS0wMzA3OjMu
MTQuMC1yYzUtMDA1NTgtZzA1ZmZkOWM6MjMwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI1
LTAzMDcvMDVmZmQ5Y2I2N2MxYmM5YTRiNGUzMDA3ZGYzMjZlNGU2ZjJkN2RiMC9kbWVzZy15
b2N0by1zbmItMTc6MjAxNDAzMDcyMjIzMzA6aTM4Ni1yYW5kY29uZmlnLXI1LTAzMDc6Ogov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA3LzA1ZmZkOWNiNjdjMWJjOWE0YjRlMzAw
N2RmMzI2ZTRlNmYyZDdkYjAvZG1lc2cteW9jdG8teGlhbi0yODoyMDE0MDMwNzIyMjIwOTpp
Mzg2LXJhbmRjb25maWctcjUtMDMwNzozLjE0LjAtcmM1LTAwNTU4LWcwNWZmZDljOjIzMAov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA3LzA1ZmZkOWNiNjdjMWJjOWE0YjRlMzAw
N2RmMzI2ZTRlNmYyZDdkYjAvZG1lc2cteW9jdG8teGlhbi00NzoyMDE0MDMwNzIyMjMxMzpp
Mzg2LXJhbmRjb25maWctcjUtMDMwNzozLjE0LjAtcmM1LTAwNTU4LWcwNWZmZDljOjIzMAov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA3LzA1ZmZkOWNiNjdjMWJjOWE0YjRlMzAw
N2RmMzI2ZTRlNmYyZDdkYjAvZG1lc2ctcXVhbnRhbC1pbm4tMzA6MjAxNDAzMDcyMzA3NTk6
aTM4Ni1yYW5kY29uZmlnLXI1LTAzMDc6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yNS0w
MzA3LzA1ZmZkOWNiNjdjMWJjOWE0YjRlMzAwN2RmMzI2ZTRlNmYyZDdkYjAvZG1lc2cteW9j
dG8teGlhbi00NToyMDE0MDMwNzIzMDgwODppMzg2LXJhbmRjb25maWctcjUtMDMwNzozLjE0
LjAtcmM1LTAwNTU4LWcwNWZmZDljOjIzMAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yNS0w
MzA3LzA1ZmZkOWNiNjdjMWJjOWE0YjRlMzAwN2RmMzI2ZTRlNmYyZDdkYjAvZG1lc2cteW9j
dG8teGJtLTE6MjAxNDAzMDcyMjE3MzM6aTM4Ni1yYW5kY29uZmlnLXI1LTAzMDc6My4xNC4w
LXJjNS0wMDU1OC1nMDVmZmQ5YzoyMzAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjUtMDMw
Ny8wNWZmZDljYjY3YzFiYzlhNGI0ZTMwMDdkZjMyNmU0ZTZmMmQ3ZGIwL2RtZXNnLXlvY3Rv
LXdhaW1lYS0xMDoyMDE0MDMwNzIzMDk1ODppMzg2LXJhbmRjb25maWctcjUtMDMwNzozLjE0
LjAtcmM1LTAwNTU4LWcwNWZmZDljOjIzMAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yNS0w
MzA3LzA1ZmZkOWNiNjdjMWJjOWE0YjRlMzAwN2RmMzI2ZTRlNmYyZDdkYjAvZG1lc2ctcXVh
bnRhbC1zbmItMTY6MjAxNDAzMDcyMjIzMjE6aTM4Ni1yYW5kY29uZmlnLXI1LTAzMDc6Ogov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA3LzA1ZmZkOWNiNjdjMWJjOWE0YjRlMzAw
N2RmMzI2ZTRlNmYyZDdkYjAvZG1lc2cteW9jdG8tcm9hbS00MjoyMDE0MDMwNzIzMDc1Njpp
Mzg2LXJhbmRjb25maWctcjUtMDMwNzozLjE0LjAtcmM1LTAwNTU4LWcwNWZmZDljOjIzMAov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA3LzA1ZmZkOWNiNjdjMWJjOWE0YjRlMzAw
N2RmMzI2ZTRlNmYyZDdkYjAvZG1lc2cteW9jdG8tc3RvYWtsZXktNzoyMDE0MDMwNzIzMDkw
NzppMzg2LXJhbmRjb25maWctcjUtMDMwNzozLjE0LjAtcmM1LTAwNTU4LWcwNWZmZDljOjIz
MAowOjE5OjE5IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpbZGV0YWNoZWQgSEVBRCA2
YzBlYjY0XSBSZXZlcnQgImRybTogYWRkIGtlcm5lbC1sb2cgcmVuZGVyZXIiCiBDb21taXR0
ZXI6IFd1IEZlbmdndWFuZyA8a2J1aWxkQGJlZT4KWW91ciBuYW1lIGFuZCBlbWFpbCBhZGRy
ZXNzIHdlcmUgY29uZmlndXJlZCBhdXRvbWF0aWNhbGx5IGJhc2VkCm9uIHlvdXIgdXNlcm5h
bWUgYW5kIGhvc3RuYW1lLiBQbGVhc2UgY2hlY2sgdGhhdCB0aGV5IGFyZSBhY2N1cmF0ZS4K
WW91IGNhbiBzdXBwcmVzcyB0aGlzIG1lc3NhZ2UgYnkgc2V0dGluZyB0aGVtIGV4cGxpY2l0
bHk6CgogICAgZ2l0IGNvbmZpZyAtLWdsb2JhbCB1c2VyLm5hbWUgIllvdXIgTmFtZSIKICAg
IGdpdCBjb25maWcgLS1nbG9iYWwgdXNlci5lbWFpbCB5b3VAZXhhbXBsZS5jb20KCkFmdGVy
IGRvaW5nIHRoaXMsIHlvdSBtYXkgZml4IHRoZSBpZGVudGl0eSB1c2VkIGZvciB0aGlzIGNv
bW1pdCB3aXRoOgoKICAgIGdpdCBjb21taXQgLS1hbWVuZCAtLXJlc2V0LWF1dGhvcgoKIDUg
ZmlsZXMgY2hhbmdlZCwgMTI1MiBkZWxldGlvbnMoLSkKIGRlbGV0ZSBtb2RlIDEwMDY0NCBk
cml2ZXJzL2dwdS9kcm0vZHJtX2xvZy5jCiBkZWxldGUgbW9kZSAxMDA2NDQgaW5jbHVkZS9k
cm0vZHJtX2xvZy5oCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJh
bmRjb25maWctcjUtMDMwNy9saW51eC1kZXZlbDpkZXZlbC1yb2FtLWkzODYtMjAxNDAzMDcy
MTUxOjZjMGViNjQzNmZmOTVmYmQ0MDVmZDhhYzI5MjYyNjI0N2IxZTBmOTY6YmlzZWN0LWxp
bnV4NQoKMjAxNC0wMy0wOC0wMTowNjo1NiA2YzBlYjY0MzZmZjk1ZmJkNDA1ZmQ4YWMyOTI2
MjYyNDdiMWUwZjk2IGNvbXBpbGluZwoKMjAxNC0wMy0wOC0wMToxNTo0NCBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAzLjE0LjAtcmM1LTAwNTU5LWc2YzBlYjY0Li4uLi4uLi4uLi4uLi4uCTQJ
MTQJMjQJMzQJNDEJNDcJNTYJNjAgU1VDQ0VTUwoKCj09PT09PT09PSB1cHN0cmVhbSA9PT09
PT09PT0KV2FybmluZzogeW91IGFyZSBsZWF2aW5nIDEgY29tbWl0IGJlaGluZCwgbm90IGNv
bm5lY3RlZCB0bwphbnkgb2YgeW91ciBicmFuY2hlczoKCiAgNmMwZWI2NCBSZXZlcnQgImRy
bTogYWRkIGtlcm5lbC1sb2cgcmVuZGVyZXIiCgpJZiB5b3Ugd2FudCB0byBrZWVwIHRoZW0g
YnkgY3JlYXRpbmcgYSBuZXcgYnJhbmNoLCB0aGlzIG1heSBiZSBhIGdvb2QgdGltZQp0byBk
byBzbyB3aXRoOgoKIGdpdCBicmFuY2ggbmV3X2JyYW5jaF9uYW1lIDZjMGViNjQKCkhFQUQg
aXMgbm93IGF0IGMzYmViYzcuLi4gTWVyZ2UgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3Nj
bS9saW51eC9rZXJuZWwvZ2l0L2RhdmVtL25ldApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1x
dWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDcvbGludXgtZGV2ZWw6ZGV2ZWwtcm9h
bS1pMzg2LTIwMTQwMzA3MjE1MTpjM2JlYmM3MWM0YmNkYWZhMjRiNTA2YWRmMGMxZGUzYzFm
NzdlMmUwOmJpc2VjdC1saW51eDUKCjIwMTQtMDMtMDgtMDE6Mjc6MjIgYzNiZWJjNzFjNGJj
ZGFmYTI0YjUwNmFkZjBjMWRlM2MxZjc3ZTJlMCBjb21waWxpbmcKCjIwMTQtMDMtMDgtMDE6
Mzc6MDggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjNS0wMDE4NS1nYzNiZWJjNy4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTMJMTYJMzQJNTEJ
NjAgU1VDQ0VTUwoKCj09PT09PT09PSBsaW51eC1uZXh0ID09PT09PT09PQpQcmV2aW91cyBI
RUFEIHBvc2l0aW9uIHdhcyBjM2JlYmM3Li4uIE1lcmdlIGdpdDovL2dpdC5rZXJuZWwub3Jn
L3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9kYXZlbS9uZXQKSEVBRCBpcyBub3cgYXQgMWIw
YTdlMy4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAxNDAzMDcKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA3
L2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0MDMwNzIxNTE6MWIwYTdlMzI2MzE2
OGEwNmQzODU4Nzk4ZTQ4YzVhMjFkMWM3OGQzYzpiaXNlY3QtbGludXg1CgoyMDE0LTAzLTA4
LTAyOjI4OjQyIDFiMGE3ZTMyNjMxNjhhMDZkMzg1ODc5OGU0OGM1YTIxZDFjNzhkM2MgY29t
cGlsaW5nCgoyMDE0LTAzLTA4LTAyOjM0OjI3IGRldGVjdGluZyBib290IHN0YXRlIDMuMTQu
MC1yYzUtbmV4dC0yMDE0MDMwNy4uCTIJOQkxNgkyNAkzMwkzNgk0MQk1MAk1Mwk2MCBTVUND
RVNTCgo=

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc5-00558-g05ffd9c"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.14.0-rc5 Kernel Configuration
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
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
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
CONFIG_KERNEL_XZ=y
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set

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
CONFIG_KTIME_SCALAR=y
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
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
# CONFIG_RCU_NOCB_CPU_ZERO is not set
CONFIG_RCU_NOCB_CPU_ALL=y
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
# CONFIG_SCHED_AUTOGROUP is not set
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
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
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
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_OPTPROBES=y
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
# CONFIG_GCOV_PROFILE_ALL is not set
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
CONFIG_GCOV_FORMAT_3_4=y
# CONFIG_GCOV_FORMAT_4_7 is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
CONFIG_MODULE_SIG_FORCE=y
CONFIG_MODULE_SIG_ALL=y
CONFIG_MODULE_SIG_SHA1=y
# CONFIG_MODULE_SIG_SHA224 is not set
# CONFIG_MODULE_SIG_SHA256 is not set
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha1"
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_AMIGA_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=m
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_BIGSMP is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_RDC321X=y
# CONFIG_X86_32_NON_STANDARD is not set
CONFIG_X86_32_IRIS=m
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
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
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
# CONFIG_X86_PPRO_FENCE is not set
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=m
CONFIG_I8K=m
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_MICROCODE_EARLY is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
CONFIG_VMSPLIT_2G_OPT=y
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x78000000
# CONFIG_X86_PAE is not set
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_CLEANCACHE=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
# CONFIG_X86_PAT is not set
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
CONFIG_DEBUG_HOTPLUG_CPU0=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
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
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=m
CONFIG_APM_IGNORE_USER_SUSPEND=y
# CONFIG_APM_DO_ENABLE is not set
# CONFIG_APM_CPU_IDLE is not set
# CONFIG_APM_DISPLAY_BLANK is not set
# CONFIG_APM_ALLOW_INTS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K6=m
# CONFIG_X86_POWERNOW_K7 is not set
CONFIG_X86_GX_SUSPMOD=m
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=m
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
CONFIG_X86_CPUFREQ_NFORCE2=m
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
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_GOBIOS=y
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_BIOS=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
# CONFIG_PCIEAER is not set
# CONFIG_PCIEASPM is not set
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=y
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
CONFIG_PCI_PASID=y
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
# CONFIG_ALIX is not set
CONFIG_NET5501=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_COMPAQ=m
# CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM is not set
CONFIG_HOTPLUG_PCI_IBM=m
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y
CONFIG_RAPIDIO=y
# CONFIG_RAPIDIO_TSI721 is not set
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
CONFIG_RAPIDIO_DMA_ENGINE=y
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_ENUM_BASIC=m

#
# RapidIO Switch drivers
#
# CONFIG_RAPIDIO_TSI57X is not set
CONFIG_RAPIDIO_CPS_XX=m
# CONFIG_RAPIDIO_TSI568 is not set
CONFIG_RAPIDIO_CPS_GEN2=m
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=m
# CONFIG_BINFMT_MISC is not set
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
# CONFIG_IP_ROUTE_VERBOSE is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=m
# CONFIG_NET_IPGRE is not set
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
# CONFIG_IP_PIMSM_V2 is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_NET_IPVTI is not set
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_INET_UDP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=y
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=y
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_HYBLA is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
# CONFIG_IPV6 is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
# CONFIG_SCTP_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_RDS=y
# CONFIG_RDS_RDMA is not set
CONFIG_RDS_TCP=y
CONFIG_RDS_DEBUG=y
CONFIG_TIPC=m
CONFIG_TIPC_PORTS=8191
CONFIG_TIPC_MEDIA_IB=y
CONFIG_ATM=y
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=y
CONFIG_ATM_MPOA=m
CONFIG_ATM_BR2684=y
CONFIG_ATM_BR2684_IPFILTER=y
CONFIG_L2TP=y
# CONFIG_L2TP_DEBUGFS is not set
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=y
CONFIG_L2TP_ETH=m
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=m
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=y
# CONFIG_DEV_APPLETALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
CONFIG_PHONET=m
CONFIG_IEEE802154=y
CONFIG_6LOWPAN_IPHC=m
# CONFIG_MAC802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_BLA is not set
CONFIG_BATMAN_ADV_DAT=y
# CONFIG_BATMAN_ADV_NC is not set
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=m
# CONFIG_OPENVSWITCH_GRE is not set
CONFIG_VSOCKETS=y
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=m
CONFIG_NET_MPLS_GSO=m
CONFIG_HSR=m
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=y
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_NET_DROP_MONITOR is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=m
# CONFIG_CAN_CALC_BITTIMING is not set
# CONFIG_CAN_LEDS is not set
CONFIG_CAN_JANZ_ICAN3=m
CONFIG_PCH_CAN=m
CONFIG_CAN_SJA1000=m
CONFIG_CAN_SJA1000_ISA=m
# CONFIG_CAN_SJA1000_PLATFORM is not set
CONFIG_CAN_EMS_PCI=m
CONFIG_CAN_PEAK_PCI=m
CONFIG_CAN_PEAK_PCIEC=y
CONFIG_CAN_KVASER_PCI=m
# CONFIG_CAN_PLX_PCI is not set
CONFIG_CAN_C_CAN=m
# CONFIG_CAN_C_CAN_PLATFORM is not set
CONFIG_CAN_C_CAN_PCI=m
# CONFIG_CAN_CC770 is not set
CONFIG_CAN_SOFTING=m
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
# CONFIG_IRNET is not set
CONFIG_IRCOMM=m
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
# CONFIG_IRDA_FAST_RR is not set
CONFIG_IRDA_DEBUG=y

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=m

#
# Dongle support
#
CONFIG_DONGLE=y
CONFIG_ESI_DONGLE=m
CONFIG_ACTISYS_DONGLE=m
CONFIG_TEKRAM_DONGLE=m
CONFIG_TOIM3232_DONGLE=m
CONFIG_LITELINK_DONGLE=m
CONFIG_MA600_DONGLE=m
# CONFIG_GIRBIL_DONGLE is not set
CONFIG_MCP2120_DONGLE=m
CONFIG_OLD_BELKIN_DONGLE=m
CONFIG_ACT200L_DONGLE=m

#
# FIR device drivers
#
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=m
CONFIG_TOSHIBA_FIR=m
CONFIG_SMC_IRCC_FIR=m
# CONFIG_ALI_FIR is not set
CONFIG_VLSI_FIR=m
CONFIG_VIA_FIR=m
CONFIG_BT=m
CONFIG_BT_RFCOMM=m
# CONFIG_BT_RFCOMM_TTY is not set
CONFIG_BT_BNEP=m
# CONFIG_BT_BNEP_MC_FILTER is not set
# CONFIG_BT_BNEP_PROTO_FILTER is not set
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUART=m
# CONFIG_BT_HCIUART_H4 is not set
CONFIG_BT_HCIUART_BCSP=y
# CONFIG_BT_HCIUART_ATH3K is not set
CONFIG_BT_HCIUART_LL=y
# CONFIG_BT_HCIUART_3WIRE is not set
CONFIG_BT_HCIVHCI=m
# CONFIG_BT_MRVL is not set
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_REG_DEBUG=y
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_PID=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_PID=y
# CONFIG_MAC80211_RC_DEFAULT_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT="pid"
CONFIG_MAC80211_MESH=y
# CONFIG_MAC80211_LEDS is not set
CONFIG_MAC80211_DEBUGFS=y
CONFIG_MAC80211_MESSAGE_TRACING=y
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
CONFIG_RFKILL_REGULATOR=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_NET_9P_RDMA=m
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=m
CONFIG_CAIF_USB=y
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
CONFIG_NFC=y
CONFIG_NFC_DIGITAL=m
CONFIG_NFC_NCI=m
CONFIG_NFC_HCI=m
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
# CONFIG_NFC_SIM is not set
CONFIG_NFC_PN544=m
CONFIG_NFC_PN544_I2C=m
CONFIG_NFC_MICROREAD=m
CONFIG_NFC_MICROREAD_I2C=m
# CONFIG_NFC_MRVL is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
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
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_DMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=16
CONFIG_CMA_SIZE_PERCENTAGE=10
# CONFIG_CMA_SIZE_SEL_MBYTES is not set
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
CONFIG_CMA_SIZE_SEL_MAX=y
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7

#
# Bus devices
#
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
CONFIG_BLK_DEV_FD=y
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
CONFIG_ZRAM=y
CONFIG_ZRAM_DEBUG=y
CONFIG_BLK_CPQ_CISS_DA=y
CONFIG_BLK_DEV_DAC960=y
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
CONFIG_BLK_DEV_SX8=m
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
CONFIG_ATA_OVER_ETH=y
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
CONFIG_BLK_DEV_RBD=y
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=m
# CONFIG_TIFM_7XX1 is not set
CONFIG_ICS932S401=m
CONFIG_ATMEL_SSC=m
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_CS5535_MFGPT is not set
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=m
CONFIG_DS1682=m
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=m
# CONFIG_SRAM is not set
CONFIG_C2PORT=m
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=m
CONFIG_CB710_CORE=m
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_HAVE_IDE=y
CONFIG_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=m
CONFIG_IDE_GD_ATA=y
CONFIG_IDE_GD_ATAPI=y
# CONFIG_BLK_DEV_IDECD is not set
CONFIG_BLK_DEV_IDETAPE=m
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
CONFIG_BLK_DEV_PLATFORM=m
CONFIG_BLK_DEV_CMD640=m
# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_BLK_DEV_OFFBOARD=y
# CONFIG_BLK_DEV_GENERIC is not set
CONFIG_BLK_DEV_OPTI621=m
CONFIG_BLK_DEV_RZ1000=m
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=m
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
CONFIG_BLK_DEV_ATIIXP=m
CONFIG_BLK_DEV_CMD64X=m
CONFIG_BLK_DEV_TRIFLEX=m
CONFIG_BLK_DEV_CS5520=m
CONFIG_BLK_DEV_CS5530=m
CONFIG_BLK_DEV_CS5535=m
CONFIG_BLK_DEV_CS5536=m
# CONFIG_BLK_DEV_HPT366 is not set
CONFIG_BLK_DEV_JMICRON=m
CONFIG_BLK_DEV_SC1200=m
CONFIG_BLK_DEV_PIIX=m
CONFIG_BLK_DEV_IT8172=m
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
CONFIG_BLK_DEV_NS87415=m
CONFIG_BLK_DEV_PDC202XX_OLD=m
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
CONFIG_BLK_DEV_SVWKS=m
CONFIG_BLK_DEV_SIIMAGE=m
CONFIG_BLK_DEV_SIS5513=m
CONFIG_BLK_DEV_SLC90E66=m
CONFIG_BLK_DEV_TRM290=m
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=m
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=m
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=m
# CONFIG_SCSI_OSD_ULD is not set
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
CONFIG_SATA_AHCI_PLATFORM=m
CONFIG_SATA_INIC162X=m
CONFIG_SATA_ACARD_AHCI=m
CONFIG_SATA_SIL24=m
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
# CONFIG_MD_RAID0 is not set
# CONFIG_MD_RAID1 is not set
CONFIG_MD_RAID10=m
# CONFIG_MD_RAID456 is not set
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BCACHE=y
CONFIG_BCACHE_DEBUG=y
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
# CONFIG_BLK_DEV_DM is not set
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
# CONFIG_TCM_FILEIO is not set
# CONFIG_TCM_PSCSI is not set
CONFIG_LOOPBACK_TARGET=m
CONFIG_ISCSI_TARGET=m
CONFIG_SBP_TARGET=m
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
CONFIG_FUSION_FC=m
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=m
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
# CONFIG_I2O_EXT_ADAPTEC is not set
CONFIG_I2O_CONFIG=m
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=m
CONFIG_I2O_BLOCK=m
CONFIG_I2O_SCSI=m
# CONFIG_I2O_PROC is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_NET_CORE is not set
CONFIG_ARCNET=m
CONFIG_ARCNET_1201=m
# CONFIG_ARCNET_1051 is not set
CONFIG_ARCNET_RAW=m
# CONFIG_ARCNET_CAP is not set
CONFIG_ARCNET_COM90xx=m
CONFIG_ARCNET_COM90xxIO=m
CONFIG_ARCNET_RIM_I=m
CONFIG_ARCNET_COM20020=m
CONFIG_ARCNET_COM20020_PCI=m
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
# CONFIG_ATM_TCP is not set
# CONFIG_ATM_LANAI is not set
CONFIG_ATM_ENI=m
CONFIG_ATM_ENI_DEBUG=y
# CONFIG_ATM_ENI_TUNE_BURST is not set
CONFIG_ATM_FIRESTREAM=y
CONFIG_ATM_ZATM=y
CONFIG_ATM_ZATM_DEBUG=y
# CONFIG_ATM_NICSTAR is not set
CONFIG_ATM_IDT77252=y
CONFIG_ATM_IDT77252_DEBUG=y
CONFIG_ATM_IDT77252_RCV_ALL=y
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=m
CONFIG_ATM_AMBASSADOR_DEBUG=y
CONFIG_ATM_HORIZON=y
CONFIG_ATM_HORIZON_DEBUG=y
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
CONFIG_ATM_HE=m
# CONFIG_ATM_HE_USE_SUNI is not set
CONFIG_ATM_SOLOS=y

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=y
CONFIG_CAIF_SPI_SLAVE=y
# CONFIG_CAIF_SPI_SYNC is not set
# CONFIG_CAIF_HSI is not set
# CONFIG_CAIF_VIRTIO is not set

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=m
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=m
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
# CONFIG_ETHERNET is not set
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
CONFIG_SKFP=y
CONFIG_HIPPI=y
# CONFIG_ROADRUNNER is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
# CONFIG_AMD_PHY is not set
CONFIG_MARVELL_PHY=m
# CONFIG_DAVICOM_PHY is not set
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM87XX_PHY is not set
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=m
CONFIG_STE10XP=m
# CONFIG_LSI_ET1011C_PHY is not set
CONFIG_MICREL_PHY=m
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
# CONFIG_MDIO_GPIO is not set
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
# CONFIG_PPP_DEFLATE is not set
# CONFIG_PPP_FILTER is not set
CONFIG_PPP_MPPE=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=y
CONFIG_PPPOE=m
CONFIG_PPTP=y
CONFIG_PPPOL2TP=m
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
# CONFIG_SLIP is not set
CONFIG_SLHC=y
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#

#
# Enable USB support to see WiMAX USB drivers
#
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=y
# CONFIG_IEEE802154_FAKEHARD is not set
CONFIG_VMXNET3=m
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
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
# CONFIG_INPUT_EVDEV is not set
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
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
CONFIG_N_GSM=m
CONFIG_TRACE_ROUTER=m
CONFIG_TRACE_SINK=y
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
# CONFIG_SERIAL_8250_PCI is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MFD_HSU=m
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_TIMBERDALE=m
CONFIG_SERIAL_ALTERA_JTAGUART=m
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=m
# CONFIG_TTY_PRINTK is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_GEODE=m
CONFIG_HW_RANDOM_VIA=m
# CONFIG_HW_RANDOM_VIRTIO is not set
# CONFIG_HW_RANDOM_TPM is not set
# CONFIG_NVRAM is not set
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
CONFIG_MWAVE=m
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_TIS_I2C_NUVOTON=m
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_ST33_I2C is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
# CONFIG_I2C_MUX is not set
# CONFIG_I2C_HELPER_AUTO is not set
# CONFIG_I2C_SMBUS is not set

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
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=m
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=m
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=y
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=y
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EG20T=m
CONFIG_I2C_GPIO=y
# CONFIG_I2C_KEMPLD is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_SCx200_ACB=y
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
CONFIG_HSI_CHAR=m

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_GPIO=m

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
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9052=m

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=m
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_SCH311X=y
# CONFIG_GPIO_TS5500 is not set
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=y
CONFIG_GPIO_VX855=m
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=m
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_RC5T583 is not set
CONFIG_GPIO_SX150X=y
# CONFIG_GPIO_STMPE is not set
# CONFIG_GPIO_WM831X is not set
CONFIG_GPIO_ADP5520=m
CONFIG_GPIO_ADP5588=m

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_CS5535 is not set
# CONFIG_GPIO_BT8XX is not set
CONFIG_GPIO_AMD8111=m
CONFIG_GPIO_INTEL_MID=y
CONFIG_GPIO_PCH=y
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
CONFIG_GPIO_KEMPLD=m

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=m
CONFIG_GPIO_TPS65910=y

#
# USB GPIO expanders:
#
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=m
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=m
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
# CONFIG_GENERIC_ADC_BATTERY is not set
CONFIG_WM831X_BACKUP=m
CONFIG_WM831X_POWER=m
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=m
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=y
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9052=m
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=m
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_CHARGER_MAX8903=m
CONFIG_CHARGER_LP8727=m
# CONFIG_CHARGER_GPIO is not set
CONFIG_CHARGER_MANAGER=y
CONFIG_CHARGER_MAX14577=m
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_BQ24735=m
# CONFIG_CHARGER_SMB347 is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=m
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DA9052_ADC=m
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_GPIO_FAN=m
CONFIG_SENSORS_HIH6130=m
# CONFIG_SENSORS_HTU21 is not set
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IIO_HWMON=m
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM73=m
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=m
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=m
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=m
CONFIG_SENSORS_LTC4261=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_MAX16065=m
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=m
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=m
CONFIG_SENSORS_MCP3021=m
CONFIG_SENSORS_NCT6775=m
CONFIG_SENSORS_PC87360=m
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
# CONFIG_SENSORS_ADM1275 is not set
# CONFIG_SENSORS_LM25066 is not set
# CONFIG_SENSORS_LTC2978 is not set
CONFIG_SENSORS_MAX16064=m
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
CONFIG_SENSORS_UCD9000=m
# CONFIG_SENSORS_UCD9200 is not set
CONFIG_SENSORS_ZL6100=m
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=m
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_DME1737=m
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=m
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_AMC6821=m
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
CONFIG_SENSORS_W83795_FANCTRL=y
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=m
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_WM831X is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_SENSORS_MC13783_ADC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_ACPI_INT3403_THERMAL is not set

#
# Texas Instruments thermal drivers
#
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
# CONFIG_SSB_PCIHOST is not set
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
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
CONFIG_MFD_CS5535=m
CONFIG_MFD_AS3711=y
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=m
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
CONFIG_PCF50633_GPIO=m
# CONFIG_MFD_RDC321X is not set
CONFIG_MFD_RTSX_PCI=m
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=m
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=m
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=m
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=m
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=m
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=m
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_88PM800=y
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=m
CONFIG_REGULATOR_AS3711=m
CONFIG_REGULATOR_DA9052=m
CONFIG_REGULATOR_DA9210=y
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL6271A=m
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=m
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_LP8788=m
CONFIG_REGULATOR_MAX14577=m
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_MAX8649=m
CONFIG_REGULATOR_MAX8660=m
CONFIG_REGULATOR_MAX8952=m
# CONFIG_REGULATOR_MAX8973 is not set
# CONFIG_REGULATOR_MAX8997 is not set
# CONFIG_REGULATOR_MAX77686 is not set
# CONFIG_REGULATOR_MC13783 is not set
# CONFIG_REGULATOR_MC13892 is not set
# CONFIG_REGULATOR_PCF50633 is not set
# CONFIG_REGULATOR_PFUZE100 is not set
# CONFIG_REGULATOR_RC5T583 is not set
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=m
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=m
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65217=m
CONFIG_REGULATOR_TPS65910=m
# CONFIG_REGULATOR_WM831X is not set
CONFIG_REGULATOR_WM8400=y
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_ALI=y
CONFIG_AGP_ATI=m
# CONFIG_AGP_AMD is not set
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=y
CONFIG_AGP_NVIDIA=y
CONFIG_AGP_SIS=m
CONFIG_AGP_SWORKS=m
# CONFIG_AGP_VIA is not set
CONFIG_AGP_EFFICEON=m
CONFIG_INTEL_GTT=y
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_LOG=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=y
# CONFIG_DRM_I2C_NXP_TDA998X is not set
CONFIG_DRM_TDFX=m
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=m
CONFIG_DRM_RADEON_UMS=y
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
# CONFIG_DRM_I810 is not set
CONFIG_DRM_I915=y
# CONFIG_DRM_I915_KMS is not set
CONFIG_DRM_I915_FBDEV=y
# CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT is not set
CONFIG_DRM_I915_UMS=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
CONFIG_DRM_VIA=m
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
CONFIG_DRM_GMA500=m
# CONFIG_DRM_GMA600 is not set
CONFIG_DRM_GMA3600=y
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
CONFIG_DRM_MGAG200=y
CONFIG_DRM_CIRRUS_QEMU=m
# CONFIG_DRM_QXL is not set
CONFIG_DRM_BOCHS=y
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=m
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
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
CONFIG_FB_CIRRUS=m
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=m
CONFIG_FB_ASILIANT=y
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=m
CONFIG_FB_VESA=y
CONFIG_FB_N411=y
CONFIG_FB_HGA=m
CONFIG_FB_OPENCORES=m
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=m
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=m
# CONFIG_FB_RIVA_I2C is not set
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_I740=m
CONFIG_FB_I810=y
# CONFIG_FB_I810_GTF is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=y
# CONFIG_FB_RADEON_I2C is not set
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
# CONFIG_FB_ATY128 is not set
CONFIG_FB_ATY=m
# CONFIG_FB_ATY_CT is not set
CONFIG_FB_ATY_GX=y
# CONFIG_FB_ATY_BACKLIGHT is not set
CONFIG_FB_S3=y
# CONFIG_FB_S3_DDC is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=m
# CONFIG_FB_VIA_DIRECT_PROCFS is not set
CONFIG_FB_VIA_X_COMPATIBILITY=y
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
CONFIG_FB_TRIDENT=y
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=m
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=y
CONFIG_FB_GEODE_GX=m
CONFIG_FB_GEODE_GX1=m
CONFIG_FB_TMIO=m
CONFIG_FB_TMIO_ACCELL=y
CONFIG_FB_SM501=m
CONFIG_FB_GOLDFISH=y
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=m
CONFIG_FB_AUO_K1900=m
CONFIG_FB_AUO_K1901=m
# CONFIG_FB_SIMPLE is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_LM3533=m
CONFIG_BACKLIGHT_PWM=m
# CONFIG_BACKLIGHT_DA9052 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=m
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP5520=m
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_PCF50633=m
CONFIG_BACKLIGHT_LM3630A=m
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=m
CONFIG_BACKLIGHT_LP8788=y
CONFIG_BACKLIGHT_TPS65217=m
# CONFIG_BACKLIGHT_AS3711 is not set
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
# CONFIG_BACKLIGHT_BD6107 is not set
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
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_XINMO is not set
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
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_TAHVO_USB is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=m
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_MEMSTICK_R592=m
CONFIG_MEMSTICK_REALTEK_PCI=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=m
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=y
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8501=m
CONFIG_LEDS_LP8788=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_PCA9685=m
CONFIG_LEDS_WM831X_STATUS=m
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_PWM=y
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_ADP5520=m
# CONFIG_LEDS_DELL_NETBOOKS is not set
# CONFIG_LEDS_MC13783 is not set
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_MAX8997=y
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=m

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=m
# CONFIG_INFINIBAND_USER_MAD is not set
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
# CONFIG_INFINIBAND_MTHCA_DEBUG is not set
# CONFIG_INFINIBAND_AMSO1100 is not set
CONFIG_INFINIBAND_NES=m
CONFIG_INFINIBAND_NES_DEBUG=y
CONFIG_INFINIBAND_IPOIB=m
CONFIG_INFINIBAND_IPOIB_CM=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_SRPT=m
CONFIG_INFINIBAND_ISER=m
CONFIG_INFINIBAND_ISERT=m
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
# CONFIG_RTC_SYSTOHC is not set
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_88PM80X is not set
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1374=m
# CONFIG_RTC_DRV_DS1672 is not set
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_LP8788=m
# CONFIG_RTC_DRV_MAX6900 is not set
CONFIG_RTC_DRV_MAX8997=y
CONFIG_RTC_DRV_MAX77686=y
CONFIG_RTC_DRV_RS5C372=m
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_ISL12022=m
# CONFIG_RTC_DRV_ISL12057 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_PCF8523=y
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=m
# CONFIG_RTC_DRV_M41T80_WDT is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_TPS65910 is not set
CONFIG_RTC_DRV_RC5T583=y
CONFIG_RTC_DRV_S35390A=m
# CONFIG_RTC_DRV_FM3130 is not set
CONFIG_RTC_DRV_RX8581=y
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_DA9052=y
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=m
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=y
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=m
CONFIG_RTC_DRV_DS2404=y
CONFIG_RTC_DRV_WM831X=y
# CONFIG_RTC_DRV_PCF50633 is not set

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=y
CONFIG_RTC_DRV_MOXART=m

#
# HID Sensor RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
CONFIG_INTEL_IOATDMA=m
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
CONFIG_DW_DMAC_PCI=y
# CONFIG_TIMB_DMA is not set
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
CONFIG_DMA_ENGINE_RAID=y
CONFIG_DCA=m
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=m
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
CONFIG_ET131X=m
CONFIG_SLICOSS=m
# CONFIG_ECHO is not set
CONFIG_COMEDI=m
CONFIG_COMEDI_DEBUG=y
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
# CONFIG_COMEDI_MISC_DRIVERS is not set
# CONFIG_COMEDI_ISA_DRIVERS is not set
# CONFIG_COMEDI_PCI_DRIVERS is not set
CONFIG_COMEDI_8255=m
CONFIG_RTS5208=m
CONFIG_RTS5208_DEBUG=y
CONFIG_DX_SEP=m

#
# IIO staging drivers
#

#
# Accelerometers
#

#
# Analog to digital converters
#
CONFIG_AD7291=m
CONFIG_AD7606=y
CONFIG_AD7606_IFACE_PARALLEL=y
# CONFIG_AD799X is not set

#
# Analog digital bi-direction converters
#
# CONFIG_ADT7316 is not set

#
# Capacitance to digital converters
#
CONFIG_AD7150=y
# CONFIG_AD7152 is not set
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
CONFIG_AD5933=m

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=y
CONFIG_SENSORS_ISL29028=y
# CONFIG_TSL2583 is not set
CONFIG_TSL2x7x=m

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
CONFIG_IIO_PERIODIC_RTC_TRIGGER=y
CONFIG_IIO_SIMPLE_DUMMY=y
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
# CONFIG_FB_SM7XX is not set
CONFIG_CRYSTALHD=m
CONFIG_FB_XGI=y
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_NET_VENDOR_SILICOM is not set
# CONFIG_DGRP is not set
CONFIG_FIREWIRE_SERIAL=m
CONFIG_FWTTY_MAX_TOTAL_PORTS=64
CONFIG_FWTTY_MAX_CARD_PORTS=32
# CONFIG_LUSTRE_FS is not set
CONFIG_XILLYBUS=y
# CONFIG_XILLYBUS_PCIE is not set
CONFIG_DGNC=m
CONFIG_DGAP=m
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_HP_WMI is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ASUS_WMI is not set
CONFIG_ACPI_WMI=y
# CONFIG_MSI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=y
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_PSTORE=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
# CONFIG_IOMMU_SUPPORT is not set

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
CONFIG_EXTCON_ADC_JACK=y
CONFIG_EXTCON_MAX14577=m
CONFIG_EXTCON_MAX8997=m
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
# CONFIG_BMA180 is not set
CONFIG_IIO_ST_ACCEL_3AXIS=m
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=m

#
# Analog to digital converters
#
# CONFIG_LP8788_ADC is not set
CONFIG_MAX1363=y
# CONFIG_MCP3422 is not set
CONFIG_NAU7802=m
CONFIG_TI_ADC081C=y

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Digital to analog converters
#
CONFIG_AD5064=m
# CONFIG_AD5380 is not set
CONFIG_AD5446=y
# CONFIG_MAX517 is not set
# CONFIG_MCP4725 is not set

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
# CONFIG_IIO_ST_GYRO_3AXIS is not set
# CONFIG_ITG3200 is not set

#
# Humidity sensors
#
# CONFIG_DHT11 is not set

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=m

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
# CONFIG_APDS9300 is not set
CONFIG_CM32181=m
CONFIG_CM36651=m
CONFIG_GP2AP020A00F=y
CONFIG_SENSORS_LM3533=m
CONFIG_TCS3472=y
# CONFIG_SENSORS_TSL2563 is not set
CONFIG_TSL4531=y
# CONFIG_VCNL4000 is not set

#
# Magnetometer sensors
#
CONFIG_AK8975=m
CONFIG_MAG3110=y
CONFIG_IIO_ST_MAGN_3AXIS=m
CONFIG_IIO_ST_MAGN_I2C_3AXIS=m

#
# Inclinometer sensors
#

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=m

#
# Pressure sensors
#
CONFIG_MPL3115=m
CONFIG_IIO_ST_PRESS=m
CONFIG_IIO_ST_PRESS_I2C=m

#
# Temperature sensors
#
CONFIG_TMP006=m
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=m
CONFIG_FMC_FAKEDEV=m
CONFIG_FMC_TRIVIAL=m
CONFIG_FMC_WRITE_EEPROM=m
CONFIG_FMC_CHARDEV=m

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_EXYNOS_MIPI_VIDEO=y
# CONFIG_BCM_KONA_USB2_PHY is not set
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=m
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
CONFIG_EXT2_FS_XIP=y
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4_FS is not set
CONFIG_FS_XIP=y
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_REISERFS_FS=m
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
# CONFIG_REISERFS_FS_SECURITY is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
# CONFIG_XFS_FS is not set
CONFIG_OCFS2_FS=m
# CONFIG_OCFS2_FS_O2CB is not set
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
# CONFIG_OCFS2_FS_STATS is not set
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=m
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=m
# CONFIG_QFMT_V1 is not set
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=m
# CONFIG_CUSE is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
# CONFIG_JOLIET is not set
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
CONFIG_NTFS_FS=m
CONFIG_NTFS_DEBUG=y
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=m
CONFIG_ECRYPT_FS_MESSAGING=y
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=m
# CONFIG_HFSPLUS_FS_POSIX_ACL is not set
# CONFIG_BEFS_FS is not set
CONFIG_BFS_FS=m
CONFIG_EFS_FS=y
CONFIG_LOGFS=y
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_FILE_CACHE=y
# CONFIG_SQUASHFS_FILE_DIRECT is not set
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
CONFIG_SQUASHFS_DECOMP_MULTI=y
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
# CONFIG_SQUASHFS_XATTR is not set
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZO is not set
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=m
CONFIG_MINIX_FS=m
CONFIG_OMFS_FS=m
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=m
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_F2FS_FS=y
# CONFIG_F2FS_STAT_FS is not set
# CONFIG_F2FS_FS_XATTR is not set
CONFIG_F2FS_CHECK_FS=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V2=m
CONFIG_NFS_V3=m
# CONFIG_NFS_V3_ACL is not set
# CONFIG_NFS_V4 is not set
# CONFIG_NFS_SWAP is not set
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_XPRT_RDMA=m
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_CEPH_FS=m
CONFIG_CEPH_FS_POSIX_ACL=y
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
CONFIG_AFS_FS=y
# CONFIG_AFS_DEBUG is not set
CONFIG_9P_FS=y
CONFIG_9P_FS_POSIX_ACL=y
CONFIG_9P_FS_SECURITY=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=m
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=m
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
# CONFIG_DLM_DEBUG is not set

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
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
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
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=m
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
# CONFIG_FAULT_INJECTION is not set
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
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
# CONFIG_KPROBE_EVENT is not set
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
# CONFIG_DYNAMIC_FTRACE is not set
CONFIG_FUNCTION_PROFILER=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_LKDTM=m
CONFIG_TEST_LIST_SORT=y
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=m
# CONFIG_INTERVAL_TREE_TEST is not set
CONFIG_PERCPU_TEST=m
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_MODULE=m
CONFIG_TEST_USER_COPY=m
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_NMI_SELFTEST=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
# CONFIG_BIG_KEYS is not set
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_LSM_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
CONFIG_SECURITY_SMACK=y
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
CONFIG_SECURITY_APPARMOR_HASH=y
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_YAMA_STACKED is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_AUDIT=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_LSM_RULES=y
# CONFIG_IMA_TEMPLATE is not set
# CONFIG_IMA_NG_TEMPLATE is not set
CONFIG_IMA_SIG_TEMPLATE=y
CONFIG_IMA_DEFAULT_TEMPLATE="ima-sig"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
# CONFIG_IMA_DEFAULT_HASH_SHA256 is not set
# CONFIG_IMA_DEFAULT_HASH_SHA512 is not set
CONFIG_IMA_DEFAULT_HASH="sha1"
# CONFIG_IMA_APPRAISE is not set
CONFIG_EVM=y
CONFIG_EVM_HMAC_VERSION=2
# CONFIG_DEFAULT_SECURITY_SELINUX is not set
# CONFIG_DEFAULT_SECURITY_SMACK is not set
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
# CONFIG_DEFAULT_SECURITY_YAMA is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
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
CONFIG_CRYPTO_USER=m
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER=m

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
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=m
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=m
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=m
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_586=m
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=m
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
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
CONFIG_CRYPTO_DEV_HIFN_795X=y
# CONFIG_CRYPTO_DEV_HIFN_795X_RNG is not set
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_CCP_DD=y
CONFIG_CRYPTO_DEV_CCP_CRYPTO=m
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
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
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=y
CONFIG_CRC8=m
CONFIG_AUDIT_GENERIC=y
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=m
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_BTREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
# CONFIG_CPUMASK_OFFSTACK is not set
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_OID_REGISTRY=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--/04w6evG8XlLl3ft--
