Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbaCSHfS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 03:35:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:40318 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbaCSHfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 03:35:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,684,1389772800"; 
   d="log'?scan'208";a="475451090"
Date: Wed, 19 Mar 2014 15:34:31 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Alex Deucher <alexander.deucher@amd.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [cirrus_init] WARNING: CPU: 0 PID: 1 at
 drivers/gpu/drm/drm_crtc.c:94 drm_warn_on_modeset_not_all_locked()
Message-ID: <20140319073431.GA32427@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Daniel,

FYI, this patch triggers a new warning (in addition to some other old warnings).

git://people.freedesktop.org/~danvet/drm drm-docs

commit 62ff94a5492175759546f8bc61383189d6b49122
Author:     Daniel Vetter <daniel.vetter@ffwll.ch>
AuthorDate: Thu Jan 23 22:18:47 2014 +0100
Commit:     Daniel Vetter <daniel.vetter@ffwll.ch>
CommitDate: Thu Mar 13 12:48:47 2014 +0100

    drm/crtc-helper: remove LOCKING from kerneldoc
    
    - It yells.
    - WARNing about incorrect locking is harder to ignore, so better
      than kerneldoc.
    - Since those have been written per-crtc locks were added ...
    
    So remove them and replace them by appropriate WARNs.
    
    Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

===================================================
PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
===================================================

+------------------------------------------------------------------------------------------------+------------+------------+------------+
|                                                                                                | 9fd93784f1 | 62ff94a549 | ac96a27ebf |
+------------------------------------------------------------------------------------------------+------------+------------+------------+
| boot_successes                                                                                 | 0          | 0          | 0          |
| boot_failures                                                                                  | 80         | 20         | 19         |
| WARNING:CPU:PID:at_drivers/gpu/drm/drm_modes.c:drm_mode_probed_add()                           | 80         | 20         | 19         |
| WARNING:CPU:PID:at_drivers/gpu/drm/drm_modes.c:drm_mode_connector_list_update()                | 80         | 20         | 19         |
| WARNING:CPU:PID:at_kernel/events/core.c:perf_swevent_add()                                     | 1          |            |            |
| backtrace:drm_fb_helper_initial_config                                                         | 80         | 20         | 19         |
| backtrace:cirrus_fbdev_init                                                                    | 80         | 20         | 19         |
| backtrace:cirrus_modeset_init                                                                  | 80         | 20         | 19         |
| backtrace:__pci_register_driver                                                                | 80         | 20         | 19         |
| backtrace:drm_pci_init                                                                         | 80         | 20         | 19         |
| backtrace:cirrus_init                                                                          | 80         | 20         | 19         |
| backtrace:kernel_init_freeable                                                                 | 80         | 20         | 19         |
| WARNING:CPU:PID:at_drivers/gpu/drm/drm_crtc.c:drm_warn_on_modeset_not_all_locked()             | 0          | 20         | 19         |
| WARNING:CPU:PID:at_drivers/gpu/drm/drm_crtc_helper.c:drm_helper_encoder_in_use()               | 0          | 20         | 19         |
| WARNING:CPU:PID:at_drivers/gpu/drm/drm_crtc_helper.c:drm_helper_crtc_in_use()                  | 0          | 20         | 19         |
| WARNING:CPU:PID:at_drivers/gpu/drm/drm_crtc_helper.c:drm_helper_probe_single_connector_modes() | 0          | 20         | 19         |
| backtrace:drm_helper_disable_unused_functions                                                  | 0          | 20         | 19         |
+------------------------------------------------------------------------------------------------+------------+------------+------------+

[    2.954664] [TTM] Initializing pool allocator
[    2.955049] [TTM] Initializing DMA pool allocator
[    2.955512] ------------[ cut here ]------------
[    2.955944] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_crtc.c:94 drm_warn_on_modeset_not_all_locked+0x3c/0x61()
[    2.957017] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc7-00703-gac96a27 #103
[    2.957683] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.958187]  00000000 00000000 7803fcd4 79cea3b4 00000000 7803fd04 79055a84 7a04f050
[    2.958965]  00000000 00000001 7a0c8835 0000005e 794f37b2 794f37b2 781c7000 869f3800
[    2.959733]  869f39cc 7803fd14 79055b39 00000009 00000000 7803fd28 794f37b2 869f4180
[    2.960514] Call Trace:
[    2.960759]  [<79cea3b4>] dump_stack+0x48/0x60
[    2.961156]  [<79055a84>] warn_slowpath_common+0x6f/0x86
[    2.961619]  [<794f37b2>] ? drm_warn_on_modeset_not_all_locked+0x3c/0x61
[    2.962196]  [<794f37b2>] ? drm_warn_on_modeset_not_all_locked+0x3c/0x61
[    2.962777]  [<79055b39>] warn_slowpath_null+0x1d/0x1f
[    2.963217]  [<794f37b2>] drm_warn_on_modeset_not_all_locked+0x3c/0x61
[    2.963787]  [<794e5815>] drm_helper_disable_unused_functions+0xd/0xcf
[    2.964357]  [<7961ba05>] cirrus_fbdev_init+0x61/0x7c
[    2.964802]  [<7961b314>] cirrus_modeset_init+0x13f/0x188
[    2.965270]  [<7961a686>] cirrus_driver_load+0x89/0xd4
[    2.965723]  [<794f012f>] drm_dev_register+0x67/0xc9
[    2.966154]  [<794f1aa6>] drm_get_pci_dev+0xd7/0x18a
[    2.966589]  [<79d01f3c>] ? mutex_unlock+0x8/0xa
[    2.966997]  [<7961b40b>] cirrus_pci_probe+0x7d/0x89
[    2.967440]  [<793f03a1>] pci_device_probe+0x44/0x85
[    2.967886]  [<791234fd>] ? sysfs_create_link+0x27/0x2f
[    2.968341]  [<796cf0f4>] driver_probe_device+0x88/0x17a
[    2.968813]  [<793f0222>] ? pci_match_device+0x97/0x9d
[    2.969257]  [<796cf259>] __driver_attach+0x47/0x63
[    2.969687]  [<796cdf74>] bus_for_each_dev+0x55/0x5f
[    2.970132]  [<796cf02d>] driver_attach+0x17/0x19
[    2.970544]  [<796cf212>] ? __device_attach+0x2c/0x2c
[    2.970989]  [<796ce566>] bus_add_driver+0xd1/0x198
[    2.971414]  [<796cf807>] driver_register+0x7a/0xae
[    2.971845]  [<793f027b>] __pci_register_driver+0x2d/0x30
[    2.972324]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    2.972748]  [<794f1bb5>] drm_pci_init+0x5c/0xd3
[    2.973143]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    2.973562]  [<7a2f95c4>] cirrus_init+0x1b/0x23
[    2.973962]  [<7a2cca6c>] do_one_initcall+0x82/0x10b
[    2.974391]  [<793bf7e3>] ? strlen+0xd/0x17
[    2.974760]  [<7a2cc430>] ? repair_env_string+0x12/0x51
[    2.975222]  [<79066f76>] ? parse_args+0x168/0x224
[    2.975641]  [<7a2ccc43>] kernel_init_freeable+0x14e/0x1e5
[    2.976115]  [<7a2cc41e>] ? do_early_param+0x78/0x78
[    2.976546]  [<79ce1ad4>] kernel_init+0xb/0xc6
[    2.976941]  [<79d03b77>] ret_from_kernel_thread+0x1b/0x28
[    2.977415]  [<79ce1ac9>] ? rest_init+0x6d/0x6d
[    2.977818] ---[ end trace b419620760c3adbd ]---
[    2.978217] ------------[ cut here ]------------

git bisect start ac96a27ebfe1ac1631a679f24991143c124127b5 dcb99fd9b08cfe1afe426af4d8d3cbc429190f15 --
git bisect  bad 836bf362b72114e5d4cdb6895fbd26e9a415e854  # 23:32      0-     14  Merge 'drm-intel/drm-intel-nightly' into devel-roam-i386-201403182248
git bisect good 5f85f4962e667de0adda472a5f9dee73f9815ec5  # 00:07     20+      2  0day base guard for 'devel-roam-i386-201403182248'
git bisect good e9dbd2b20201b49b04476d2e5763faa822967913  # 00:27     20+      1  drm/i915: Fix forcewake counts for gen8
git bisect good a1a8bdf355e75037538aaa602baeeda447da8346  # 00:52     20+      1  Merge remote-tracking branch 'origin/drm-intel-fixes' into drm-intel-nightly
git bisect good 3a05700dc874f377b13e4368550e8c7228826ab4  # 00:57     20+      1  drm/doc: Update copyright
git bisect  bad 978c6050165bba52eab7ef3581d447eb215def77  # 01:04      0-      1  Merge branch 'drm-docs' of ssh://people.freedesktop.org/~danvet/drm into drm-next
git bisect good e40d641099213145a034981e646dc2180a488152  # 01:14     20+      1  Merge branch 'drm-minor' of git://people.freedesktop.org/~dvdhrm/linux into drm-next
git bisect good 3e70292cd4a002cd799a1cd4115286cba3933d6d  # 01:23     20+     20  drm/modes: drop maxPitch from drm_mode_validate_size
git bisect  bad 00d762cbd1fb5df63bf005ffa1c8d0275f79890e  # 01:30      0-      3  drm: drop error code for drm_helper_resume_force_mode
git bisect good 9ee984a5f735d6afc6f889e179b2e4b1f2ec335f  # 01:40     20+     20  drm/doc: Fix misplaced </para>
git bisect  bad 62ff94a5492175759546f8bc61383189d6b49122  # 02:03      0-      2  drm/crtc-helper: remove LOCKING from kerneldoc
git bisect good 9fd93784f1719532d796914935f87cc1c6afd687  # 02:26     20+     20  drm: remove return value from drm_helper_mode_fill_fb_struct
# first bad commit: [62ff94a5492175759546f8bc61383189d6b49122] drm/crtc-helper: remove LOCKING from kerneldoc
git bisect good 9fd93784f1719532d796914935f87cc1c6afd687  # 02:44     60+     80  drm: remove return value from drm_helper_mode_fill_fb_struct
git bisect  bad ac96a27ebfe1ac1631a679f24991143c124127b5  # 02:44      0-     19  0day head guard for 'devel-roam-i386-201403182248'
git bisect good 9a15c944f76cffa5581959cefe709c7c4ea26994  # 03:14     60+      5  Merge branch 'for-linus' of git://git.kernel.dk/linux-block
git bisect good 3bd688c0bfa306c861da2311afbaa4413768dc7c  # 04:00     60+      3  Add linux-next specific files for 20140318

Thanks,
Fengguang

--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-cairo-10:20140318230122:i386-randconfig-r0-0318:3.14.0-rc7-00703-gac96a27:103"
Content-Transfer-Encoding: quoted-printable

early console in setup code
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc7-00703-gac96a27 (kbuild@roam) (gcc v=
ersion 4.8.2 (Debian 4.8.2-16) ) #103 SMP Tue Mar 18 22:58:13 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
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
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
[    0.000000] initial memory mapped: [mem 0x00000000-0x02bfffff]
[    0.000000] Base memory trampoline at [7809b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0f800000-0x0fbfffff]
[    0.000000]  [mem 0x0f800000-0x0fbfffff] page 4k
[    0.000000] BRK [0x02416000, 0x02416fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0f7fffff]
[    0.000000]  [mem 0x08000000-0x0f7fffff] page 4k
[    0.000000] BRK [0x02417000, 0x02417fff] PGTABLE
[    0.000000] BRK [0x02418000, 0x02418fff] PGTABLE
[    0.000000] BRK [0x02419000, 0x02419fff] PGTABLE
[    0.000000] BRK [0x0241a000, 0x0241afff] PGTABLE
[    0.000000] BRK [0x0241b000, 0x0241bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x07ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x0fcbd000-0x0ffeffff]
[    0.000000] ACPI: RSDP 0x000FD930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0FFFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x0FFFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x0FFFE490 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x0FFFFF40 000040
[    0.000000] ACPI: SSDT 0x0FFFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x0FFFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x0FFFF640 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x0fffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   Normal zone: 576 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 65436 pages, LIFO batch:15
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
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 10 pages/cpu @87c19000 s25760 r0 d15200 u40=
960
[    0.000000] pcpu-alloc: s25760 r0 d15200 u40960 alloc=3D10*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr fc1b500
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64860
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/i386-randconfig-r0-0318/linux-devel=
:devel-roam-i386-201403182248/.vmlinuz-ac96a27ebfe1ac1631a679f24991143c1241=
27b5-20140318225854-7-cairo branch=3Dlinux-devel/devel-roam-i386-2014031822=
48 BOOT_IMAGE=3D/kernel/i386-randconfig-r0-0318/ac96a27ebfe1ac1631a679f2499=
1143c124127b5/vmlinuz-3.14.0-rc7-00703-gac96a27
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 235016K/261744K available (13330K kernel code, 1007K=
 rwdata, 4904K rodata, 744K init, 484K bss, 26728K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd35000 - 0xfffff000   (2856 kB)
[    0.000000]     vmalloc : 0x887fe000 - 0xffd33000   (1909 MB)
[    0.000000]     lowmem  : 0x78000000 - 0x87ffe000   ( 255 MB)
[    0.000000]       .init : 0x7a2cc000 - 0x7a386000   ( 744 kB)
[    0.000000]       .data : 0x79d04c1d - 0x7a2cbd80   (5916 kB)
[    0.000000]       .text : 0x79000000 - 0x79d04c1d   (13331 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3D78094000 soft=3D78096000
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2892.990 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5785.98 Bogo=
MIPS (lpj=3D28929900)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] ACPI: Core revision 20140214
[    0.020000] ACPI: All ACPI Tables successfully acquired
[    0.020000] Security Framework initialized
[    0.020000] AppArmor: AppArmor disabled by boot time parameter
[    0.020000] Yama: becoming mindful.
[    0.020000] Mount-cache hash table entries: 512
[    0.020000] Initializing cgroup subsys debug
[    0.020010] Initializing cgroup subsys freezer
[    0.020693] Initializing cgroup subsys net_cls
[    0.021357] Initializing cgroup subsys blkio
[    0.021997] Initializing cgroup subsys hugetlb
[    0.022749] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.022749] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.022749] tlb_flushall_shift: 6
[    0.026314] debug: unmapping init [mem 0x7a386000-0x7a390fff]
[    0.032370] Getting VERSION: 50014
[    0.033050] Getting VERSION: 50014
[    0.033688] Getting ID: 0
[    0.034161] Getting ID: f000000
[    0.034748] Getting LVT0: 8700
[    0.035310] Getting LVT1: 8400
[    0.035877] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.036921] enabled ExtINT on CPU#0
[    0.038970] ENABLING IO-APIC IRQs
[    0.039474] init IO_APIC IRQs
[    0.039901]  apic 0 pin 0 not connected
[    0.040011] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.041236] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.042435] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.043635] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.044764] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.045941] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.047091] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.048370] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.050030] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.051180] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.052382] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.053577] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.054749] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.055977] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.057169] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.058393]  apic 0 pin 16 not connected
[    0.059023]  apic 0 pin 17 not connected
[    0.059617]  apic 0 pin 18 not connected
[    0.060005]  apic 0 pin 19 not connected
[    0.060600]  apic 0 pin 20 not connected
[    0.061180]  apic 0 pin 21 not connected
[    0.061785]  apic 0 pin 22 not connected
[    0.062400]  apic 0 pin 23 not connected
[    0.063112] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.064257] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.065853] Using local APIC timer interrupts.
[    0.065853] calibrating APIC timer ...
[    0.070000] ... lapic delta =3D 6249989
[    0.070000] ... PM-Timer delta =3D 357954
[    0.070000] ... PM-Timer result ok
[    0.070000] ..... delta 6249989
[    0.070000] ..... mult: 268434983
[    0.070000] ..... calibration result: 9999982
[    0.070000] ..... CPU clock speed is 2892.9816 MHz.
[    0.070000] ..... host bus clock speed is 999.9982 MHz.
[    0.070000] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.070000] CPU 1 irqstacks, hard=3D78078000 soft=3D7807a000
[    0.070000] x86: Booting SMP configuration:
[    0.070000] .... node  #0, CPUs:      #1
[    0.010000] Initializing CPU#1
[    0.020000] kvm-clock: cpu 1, msr 0:fffd021, secondary cpu clock
[    0.020000] masked ExtINT on CPU#1
[    0.080084] x86: Booted up 1 node, 2 CPUs
[    0.080056] KVM setup async PF for cpu 1
[    0.080056] kvm-stealtime: cpu 1, msr fc25500
[    0.081947] smpboot: Total of 2 processors activated (11571.96 BogoMIPS)
[    0.092258] xor: measuring software checksum speed
[    0.190005]    pIII_sse  :  6341.600 MB/sec
[    0.290005]    prefetch64-sse:  7731.200 MB/sec
[    0.290701] xor: using function: prefetch64-sse (7731.200 MB/sec)
[    0.291623] pinctrl core: initialized pinctrl subsystem
[    0.292440] reg-dummy reg-dummy: no of_node; not parsing pinctrl DT
[    0.293435] regulator-dummy: no parameters
[    0.294294] NET: Registered protocol family 16
[    0.296127] cpuidle: using governor ladder
[    0.297884] ACPI: bus type PCI registered
[    0.298497] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.299638] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.300005] PCI: Using configuration type 1 for base access
[    0.310432] bio: create slab <bio-0> at 0
[    0.480009] raid6: mmxx1     2614 MB/s
[    0.650013] raid6: mmxx2     2922 MB/s
[    0.820019] raid6: sse1x1    2207 MB/s
[    0.990008] raid6: sse1x2    2854 MB/s
[    1.160015] raid6: sse2x1    4360 MB/s
[    1.330005] raid6: sse2x2    5750 MB/s
[    1.330479] raid6: using algorithm sse2x2 (5750 MB/s)
[    1.331101] raid6: using intx1 recovery algorithm
[    1.331888] ACPI: Added _OSI(Module Device)
[    1.332412] ACPI: Added _OSI(Processor Device)
[    1.332972] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.333544] ACPI: Added _OSI(Processor Aggregator Device)
[    1.337765] ACPI: Interpreter enabled
[    1.338258] ACPI: (supports S0 S4 S5)
[    1.338706] ACPI: Using IOAPIC for interrupt routing
[    1.339342] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.344480] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.345249] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    1.345970] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.347027] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    1.348570] acpiphp: Slot [3] registered
[    1.349093] acpiphp: Slot [4] registered
[    1.350046] acpiphp: Slot [5] registered
[    1.350572] acpiphp: Slot [6] registered
[    1.351114] acpiphp: Slot [7] registered
[    1.351638] acpiphp: Slot [8] registered
[    1.352183] acpiphp: Slot [9] registered
[    1.352712] acpiphp: Slot [10] registered
[    1.353270] acpiphp: Slot [11] registered
[    1.353814] acpiphp: Slot [12] registered
[    1.354349] acpiphp: Slot [13] registered
[    1.354892] acpiphp: Slot [14] registered
[    1.355424] acpiphp: Slot [15] registered
[    1.355967] acpiphp: Slot [16] registered
[    1.356493] acpiphp: Slot [17] registered
[    1.357041] acpiphp: Slot [18] registered
[    1.357567] acpiphp: Slot [19] registered
[    1.358114] acpiphp: Slot [20] registered
[    1.358643] acpiphp: Slot [21] registered
[    1.359189] acpiphp: Slot [22] registered
[    1.359726] acpiphp: Slot [23] registered
[    1.360045] acpiphp: Slot [24] registered
[    1.360582] acpiphp: Slot [25] registered
[    1.361115] acpiphp: Slot [26] registered
[    1.361659] acpiphp: Slot [27] registered
[    1.362182] acpiphp: Slot [28] registered
[    1.362740] acpiphp: Slot [29] registered
[    1.363275] acpiphp: Slot [30] registered
[    1.363819] acpiphp: Slot [31] registered
[    1.364319] PCI host bridge to bus 0000:00
[    1.364834] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.365496] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.366244] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.367023] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.367857] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    1.368727] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.370180] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.371508] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.376375] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    1.378892] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.380017] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    1.380911] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    1.382048] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.386575] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.389406] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.399456] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.400577] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.402897] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    1.405217] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.413850] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    1.414945] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    1.417297] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    1.419539] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    1.428113] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.430793] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    1.433032] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    1.441956] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.444331] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    1.446573] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    1.455851] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.458176] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    1.460006] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    1.468883] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.471598] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    1.473847] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    1.482714] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.485064] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    1.487280] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    1.495783] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    1.497326] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    1.503513] pci_bus 0000:00: on NUMA node 0
[    1.504589] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.505533] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.506504] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.507436] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.508282] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    1.509540] ACPI: Enabled 16 GPEs in block 00 to 0F
[    1.510429] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.511414] vgaarb: loaded
[    1.511762] vgaarb: bridge control possible 0000:00:02.0
[    1.513303] SCSI subsystem initialized
[    1.513936] libata version 3.00 loaded.
[    1.514547] pps_core: LinuxPPS API ver. 1 registered
[    1.515158] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.516267] PTP clock support registered
[    1.516881] wmi: Mapper loaded
[    1.517301] Advanced Linux Sound Architecture Driver Initialized.
[    1.518053] PCI: Using ACPI for IRQ routing
[    1.518569] PCI: pci_cache_line_size set to 64 bytes
[    1.519399] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.520009] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    1.521022] NET: Registered protocol family 23
[    1.521601] NetLabel: Initializing
[    1.522019] NetLabel:  domain hash size =3D 128
[    1.522574] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    1.523197] NetLabel:  unlabeled traffic allowed by default
[    1.525188] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    1.526077] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    1.526750] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    1.533166] Switched to clocksource kvm-clock
[    1.533205] FS-Cache: Loaded
[    1.533205] CacheFiles: Loaded
[    1.533205] pnp: PnP ACPI init
[    1.533205] ACPI: bus type PNP registered
[    1.533205] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    1.533205] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.533283] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    1.534041] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.534651] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    1.535388] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.535997] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    1.536709] pnp 00:03: [dma 2]
[    1.537004] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.537629] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    1.538343] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.538972] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    1.539702] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.540446] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.541146] pnp: PnP ACPI: found 7 devices
[    1.541512] ACPI: bus type PNP unregistered
[    1.576690] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.577182] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.577669] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.578215] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.578913] NET: Registered protocol family 2
[    1.579520] TCP established hash table entries: 2048 (order: 1, 8192 byt=
es)
[    1.580155] TCP bind hash table entries: 2048 (order: 2, 16384 bytes)
[    1.580734] TCP: Hash tables configured (established 2048 bind 2048)
[    1.581320] TCP: reno registered
[    1.581618] UDP hash table entries: 256 (order: 1, 8192 bytes)
[    1.582141] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
[    1.582793] NET: Registered protocol family 1
[    1.583384] RPC: Registered named UNIX socket transport module.
[    1.583906] RPC: Registered udp transport module.
[    1.584313] RPC: Registered tcp transport module.
[    1.584728] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.585287] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.585815] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.586329] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.586886] pci 0000:00:02.0: Boot video device
[    1.587338] PCI: CLS 0 bytes, default 64
[    1.587780] Trying to unpack rootfs image as initramfs...
[    1.669089] debug: unmapping init [mem 0x87cbd000-0x87feffff]
[    1.670596] apm: BIOS not found.
[    1.673202] PCLMULQDQ-NI instructions are not detected.
[    1.673700] NatSemi SCx200 Driver
[    1.674144] alarmtimer alarmtimer: no of_node; not parsing pinctrl DT
[    1.674762] futex hash table entries: 512 (order: 2, 16384 bytes)
[    1.675311] Initialise system trusted keyring
[    1.675721] audit: initializing netlink subsys (disabled)
[    1.676211] audit: type=3D2000 audit(1395154785.524:1): initialized
[    1.676929] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.677504] zbud: loaded
[    1.678021] VFS: Disk quotas dquot_6.5.2
[    1.678418] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.679167] DLM installed
[    1.679991] FS-Cache: Netfs 'nfs' registered for caching
[    1.680753] NTFS driver 2.1.30 [Flags: R/O DEBUG].
[    1.681307] fuse init (API version 7.22)
[    1.681801] JFS: nTxBlock =3D 1836, nTxLock =3D 14688
[    1.683679] NILFS version 2 loaded
[    1.684171] ocfs2 stack glue: unable to register sysctl
[    1.684753] OCFS2 User DLM kernel interface loaded
[    1.685382] ceph: loaded (mds proto 32)
[    1.685741] msgmni has been set to 459
[    1.695450] alg: No test for crc32 (crc32-table)
[    1.696632] alg: No test for lz4hc (lz4hc-generic)
[    1.697455] alg: No test for stdrng (krng)
[    1.704637] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    1.705856] NET: Registered protocol family 38
[    1.706262] Key type asymmetric registered
[    1.706662] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    1.707396] io scheduler noop registered
[    1.707754] io scheduler deadline registered
[    1.708194] io scheduler cfq registered (default)
[    1.708610] test_string_helpers: Running tests...
[    1.709130] rbtree testing -> 12983 cycles
[    2.192540] augmented rbtree testing -> 15731 cycles
[    2.780405] tsc: Refined TSC clocksource calibration: 2892.979 MHz
[    2.780856] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.780857] cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
[    2.780885] ibmphpd: IBM Hot Plug PCI Controller Driver version: 0.6
[    2.782705] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver =
version: 0.1
[    2.784543] cpcihp_generic: not configured, disabling.
[    2.787399] acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
[    2.788862] cr_backlight cr_backlight: no of_node; not parsing pinctrl DT
[    2.789465] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    2.789932] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    2.790697] rivafb_setup START
[    2.791033] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    2.791700] vmlfb: initializing
[    2.791995] Could not find Carillo Ranch MCH device.
[    2.792451] no IO addresses supplied
[    2.792798] hgafb hgafb.0: no of_node; not parsing pinctrl DT
[    2.793333] hgafb: HGA card not detected.
[    2.793691] hgafb: probe of hgafb.0 failed with error -22
[    2.794231] ipmi message handler version 39.2
[    2.794612] ipmi device interface
[    2.794933] IPMI System Interface driver.
[    2.795317] ipmi_si: Adding default-specified kcs state machine
[    2.795852] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    2.796714] ipmi_si: Interface detection failed
[    2.830084] ipmi_si: Adding default-specified smic state machine
[    2.830674] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    2.832650] ipmi_si: Interface detection failed
[    2.860084] ipmi_si: Adding default-specified bt state machine
[    2.861307] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    2.863249] ipmi_si: Interface detection failed
[    2.890090] ipmi_si: Unable to find any System Interface(s)
[    2.891569] button LNXPWRBN:00: no of_node; not parsing pinctrl DT
[    2.892969] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    2.894422] ACPI: Power Button [PWRF]
[    2.895343] virtio-pci 0000:00:04.0: no of_node; not parsing pinctrl DT
[    2.897502] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    2.898581] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:3)
[    2.900506] virtio-pci 0000:00:05.0: no of_node; not parsing pinctrl DT
[    2.901423] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    2.901937] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:3)
[    2.904079] virtio-pci 0000:00:06.0: no of_node; not parsing pinctrl DT
[    2.905002] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    2.907254] virtio-pci 0000:00:07.0: no of_node; not parsing pinctrl DT
[    2.908164] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    2.910825] virtio-pci 0000:00:08.0: no of_node; not parsing pinctrl DT
[    2.914132] virtio-pci 0000:00:09.0: no of_node; not parsing pinctrl DT
[    2.922587] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.923204] serial 00:05: no of_node; not parsing pinctrl DT
[    2.944941] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    2.945870] serial8250 serial8250: no of_node; not parsing pinctrl DT
[    2.946480] lp: driver loaded but no devices found
[    2.946927] hpet PNP0103:00: no of_node; not parsing pinctrl DT
[    2.947522] Non-volatile memory driver v1.3
[    2.947901] toshiba: not a supported Toshiba laptop
[    2.948346] ppdev: user-space parallel port driver
[    2.948775] scx200_gpio: no SCx200 gpio present
[    2.949168] nsc_gpio initializing
[    2.949456] Linux agpgart interface v0.103
[    2.949865] agpgart-intel 0000:00:00.0: no of_node; not parsing pinctrl =
DT
[    2.950543] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    2.951323] Hangcheck: Using getrawmonotonic().
[    2.951800] [drm] Initialized drm 1.1.0 20060810
[    2.952243] [drm] radeon kernel modesetting enabled.
[    2.952729] drm/i810 does not support SMP
[    2.953125] cirrus 0000:00:02.0: no of_node; not parsing pinctrl DT
[    2.954091] [TTM] Zone  kernel: Available graphics memory: 117508 kiB
[    2.954664] [TTM] Initializing pool allocator
[    2.955049] [TTM] Initializing DMA pool allocator
[    2.955512] ------------[ cut here ]------------
[    2.955944] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_crtc.c:94 drm_=
warn_on_modeset_not_all_locked+0x3c/0x61()
[    2.957017] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc7-00703-g=
ac96a27 #103
[    2.957683] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.958187]  00000000 00000000 7803fcd4 79cea3b4 00000000 7803fd04 79055=
a84 7a04f050
[    2.958965]  00000000 00000001 7a0c8835 0000005e 794f37b2 794f37b2 781c7=
000 869f3800
[    2.959733]  869f39cc 7803fd14 79055b39 00000009 00000000 7803fd28 794f3=
7b2 869f4180
[    2.960514] Call Trace:
[    2.960759]  [<79cea3b4>] dump_stack+0x48/0x60
[    2.961156]  [<79055a84>] warn_slowpath_common+0x6f/0x86
[    2.961619]  [<794f37b2>] ? drm_warn_on_modeset_not_all_locked+0x3c/0x61
[    2.962196]  [<794f37b2>] ? drm_warn_on_modeset_not_all_locked+0x3c/0x61
[    2.962777]  [<79055b39>] warn_slowpath_null+0x1d/0x1f
[    2.963217]  [<794f37b2>] drm_warn_on_modeset_not_all_locked+0x3c/0x61
[    2.963787]  [<794e5815>] drm_helper_disable_unused_functions+0xd/0xcf
[    2.964357]  [<7961ba05>] cirrus_fbdev_init+0x61/0x7c
[    2.964802]  [<7961b314>] cirrus_modeset_init+0x13f/0x188
[    2.965270]  [<7961a686>] cirrus_driver_load+0x89/0xd4
[    2.965723]  [<794f012f>] drm_dev_register+0x67/0xc9
[    2.966154]  [<794f1aa6>] drm_get_pci_dev+0xd7/0x18a
[    2.966589]  [<79d01f3c>] ? mutex_unlock+0x8/0xa
[    2.966997]  [<7961b40b>] cirrus_pci_probe+0x7d/0x89
[    2.967440]  [<793f03a1>] pci_device_probe+0x44/0x85
[    2.967886]  [<791234fd>] ? sysfs_create_link+0x27/0x2f
[    2.968341]  [<796cf0f4>] driver_probe_device+0x88/0x17a
[    2.968813]  [<793f0222>] ? pci_match_device+0x97/0x9d
[    2.969257]  [<796cf259>] __driver_attach+0x47/0x63
[    2.969687]  [<796cdf74>] bus_for_each_dev+0x55/0x5f
[    2.970132]  [<796cf02d>] driver_attach+0x17/0x19
[    2.970544]  [<796cf212>] ? __device_attach+0x2c/0x2c
[    2.970989]  [<796ce566>] bus_add_driver+0xd1/0x198
[    2.971414]  [<796cf807>] driver_register+0x7a/0xae
[    2.971845]  [<793f027b>] __pci_register_driver+0x2d/0x30
[    2.972324]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    2.972748]  [<794f1bb5>] drm_pci_init+0x5c/0xd3
[    2.973143]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    2.973562]  [<7a2f95c4>] cirrus_init+0x1b/0x23
[    2.973962]  [<7a2cca6c>] do_one_initcall+0x82/0x10b
[    2.974391]  [<793bf7e3>] ? strlen+0xd/0x17
[    2.974760]  [<7a2cc430>] ? repair_env_string+0x12/0x51
[    2.975222]  [<79066f76>] ? parse_args+0x168/0x224
[    2.975641]  [<7a2ccc43>] kernel_init_freeable+0x14e/0x1e5
[    2.976115]  [<7a2cc41e>] ? do_early_param+0x78/0x78
[    2.976546]  [<79ce1ad4>] kernel_init+0xb/0xc6
[    2.976941]  [<79d03b77>] ret_from_kernel_thread+0x1b/0x28
[    2.977415]  [<79ce1ac9>] ? rest_init+0x6d/0x6d
[    2.977818] ---[ end trace b419620760c3adbd ]---
[    2.978217] ------------[ cut here ]------------
[    2.978634] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_crtc.c:96 drm_=
warn_on_modeset_not_all_locked+0x5c/0x61()
[    2.979706] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.14.0-=
rc7-00703-gac96a27 #103
[    2.980473] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.980972]  00000000 00000000 7803fcd4 79cea3b4 00000000 7803fd04 79055=
a84 7a04f050
[    2.981739]  00000000 00000001 7a0c8835 00000060 794f37d2 794f37d2 869f3=
9c8 869f3800
[    2.982501]  869f39cc 7803fd14 79055b39 00000009 00000000 7803fd28 794f3=
7d2 869f4180
[    2.983267] Call Trace:
[    2.983487]  [<79cea3b4>] dump_stack+0x48/0x60
[    2.983876]  [<79055a84>] warn_slowpath_common+0x6f/0x86
[    2.984335]  [<794f37d2>] ? drm_warn_on_modeset_not_all_locked+0x5c/0x61
[    2.984919]  [<794f37d2>] ? drm_warn_on_modeset_not_all_locked+0x5c/0x61
[    2.985489]  [<79055b39>] warn_slowpath_null+0x1d/0x1f
[    2.985934]  [<794f37d2>] drm_warn_on_modeset_not_all_locked+0x5c/0x61
[    2.986494]  [<794e5815>] drm_helper_disable_unused_functions+0xd/0xcf
[    2.987055]  [<7961ba05>] cirrus_fbdev_init+0x61/0x7c
[    2.987493]  [<7961b314>] cirrus_modeset_init+0x13f/0x188
[    2.987961]  [<7961a686>] cirrus_driver_load+0x89/0xd4
[    2.988406]  [<794f012f>] drm_dev_register+0x67/0xc9
[    2.988846]  [<794f1aa6>] drm_get_pci_dev+0xd7/0x18a
[    2.989278]  [<79d01f3c>] ? mutex_unlock+0x8/0xa
[    2.989685]  [<7961b40b>] cirrus_pci_probe+0x7d/0x89
[    2.990131]  [<793f03a1>] pci_device_probe+0x44/0x85
[    2.990562]  [<791234fd>] ? sysfs_create_link+0x27/0x2f
[    2.991015]  [<796cf0f4>] driver_probe_device+0x88/0x17a
[    2.991477]  [<793f0222>] ? pci_match_device+0x97/0x9d
[    2.991927]  [<796cf259>] __driver_attach+0x47/0x63
[    2.992347]  [<796cdf74>] bus_for_each_dev+0x55/0x5f
[    2.992783]  [<796cf02d>] driver_attach+0x17/0x19
[    2.993188]  [<796cf212>] ? __device_attach+0x2c/0x2c
[    2.993627]  [<796ce566>] bus_add_driver+0xd1/0x198
[    2.994049]  [<796cf807>] driver_register+0x7a/0xae
[    2.994469]  [<793f027b>] __pci_register_driver+0x2d/0x30
[    2.994945]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    2.995359]  [<794f1bb5>] drm_pci_init+0x5c/0xd3
[    2.995766]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    2.996177]  [<7a2f95c4>] cirrus_init+0x1b/0x23
[    2.996563]  [<7a2cca6c>] do_one_initcall+0x82/0x10b
[    2.996999]  [<793bf7e3>] ? strlen+0xd/0x17
[    2.997360]  [<7a2cc430>] ? repair_env_string+0x12/0x51
[    2.997820]  [<79066f76>] ? parse_args+0x168/0x224
[    2.998236]  [<7a2ccc43>] kernel_init_freeable+0x14e/0x1e5
[    2.998723]  [<7a2cc41e>] ? do_early_param+0x78/0x78
[    2.999150]  [<79ce1ad4>] kernel_init+0xb/0xc6
[    2.999533]  [<79d03b77>] ret_from_kernel_thread+0x1b/0x28
[    3.000030]  [<79ce1ac9>] ? rest_init+0x6d/0x6d
[    3.000425] ---[ end trace b419620760c3adbe ]---
[    3.000831] ------------[ cut here ]------------
[    3.001231] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_crtc_helper.c:=
232 drm_helper_encoder_in_use+0x21/0x51()
[    3.002287] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.14.0-=
rc7-00703-gac96a27 #103
[    3.003033] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.003529]  00000000 00000000 7803fcd8 79cea3b4 00000000 7803fd08 79055=
a84 7a04f050
[    3.004294]  00000000 00000001 7a0c66ad 000000e8 794e577d 794e577d 869f3=
800 869bca00
[    3.005060]  869f39b4 7803fd18 79055b39 00000009 00000000 7803fd28 794e5=
77d 869bca00
[    3.005834] Call Trace:
[    3.006054]  [<79cea3b4>] dump_stack+0x48/0x60
[    3.006440]  [<79055a84>] warn_slowpath_common+0x6f/0x86
[    3.006905]  [<794e577d>] ? drm_helper_encoder_in_use+0x21/0x51
[    3.007417]  [<794e577d>] ? drm_helper_encoder_in_use+0x21/0x51
[    3.007935]  [<79055b39>] warn_slowpath_null+0x1d/0x1f
[    3.008382]  [<794e577d>] drm_helper_encoder_in_use+0x21/0x51
[    3.008889]  [<794e5869>] drm_helper_disable_unused_functions+0x61/0xcf
[    3.009459]  [<7961ba05>] cirrus_fbdev_init+0x61/0x7c
[    3.009900]  [<7961b314>] cirrus_modeset_init+0x13f/0x188
[    3.010383]  [<7961a686>] cirrus_driver_load+0x89/0xd4
[    3.010836]  [<794f012f>] drm_dev_register+0x67/0xc9
[    3.011265]  [<794f1aa6>] drm_get_pci_dev+0xd7/0x18a
[    3.011698]  [<79d01f3c>] ? mutex_unlock+0x8/0xa
[    3.012098]  [<7961b40b>] cirrus_pci_probe+0x7d/0x89
[    3.012528]  [<793f03a1>] pci_device_probe+0x44/0x85
[    3.012964]  [<791234fd>] ? sysfs_create_link+0x27/0x2f
[    3.013415]  [<796cf0f4>] driver_probe_device+0x88/0x17a
[    3.013879]  [<793f0222>] ? pci_match_device+0x97/0x9d
[    3.014324]  [<796cf259>] __driver_attach+0x47/0x63
[    3.014757]  [<796cdf74>] bus_for_each_dev+0x55/0x5f
[    3.015187]  [<796cf02d>] driver_attach+0x17/0x19
[    3.015597]  [<796cf212>] ? __device_attach+0x2c/0x2c
[    3.016038]  [<796ce566>] bus_add_driver+0xd1/0x198
[    3.016458]  [<796cf807>] driver_register+0x7a/0xae
[    3.016888]  [<793f027b>] __pci_register_driver+0x2d/0x30
[    3.017355]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.017776]  [<794f1bb5>] drm_pci_init+0x5c/0xd3
[    3.018178]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.018593]  [<7a2f95c4>] cirrus_init+0x1b/0x23
[    3.018997]  [<7a2cca6c>] do_one_initcall+0x82/0x10b
[    3.019428]  [<793bf7e3>] ? strlen+0xd/0x17
[    3.019801]  [<7a2cc430>] ? repair_env_string+0x12/0x51
[    3.020268]  [<79066f76>] ? parse_args+0x168/0x224
[    3.020689]  [<7a2ccc43>] kernel_init_freeable+0x14e/0x1e5
[    3.021164]  [<7a2cc41e>] ? do_early_param+0x78/0x78
[    3.021598]  [<79ce1ad4>] kernel_init+0xb/0xc6
[    3.021989]  [<79d03b77>] ret_from_kernel_thread+0x1b/0x28
[    3.022467]  [<79ce1ac9>] ? rest_init+0x6d/0x6d
[    3.022865] ---[ end trace b419620760c3adbf ]---
[    3.023266] ------------[ cut here ]------------
[    3.023671] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_crtc_helper.c:=
256 drm_helper_crtc_in_use+0x22/0x5b()
[    3.024716] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.14.0-=
rc7-00703-gac96a27 #103
[    3.025453] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.025951]  00000000 00000000 7803fcd4 79cea3b4 00000000 7803fd04 79055=
a84 7a04f050
[    3.026720]  00000000 00000001 7a0c66ad 00000100 794e57cf 794e57cf 781c7=
000 869f3800
[    3.027479]  781c7000 7803fd14 79055b39 00000009 00000000 7803fd28 794e5=
7cf 781c7000
[    3.028246] Call Trace:
[    3.028465]  [<79cea3b4>] dump_stack+0x48/0x60
[    3.028865]  [<79055a84>] warn_slowpath_common+0x6f/0x86
[    3.029324]  [<794e57cf>] ? drm_helper_crtc_in_use+0x22/0x5b
[    3.029815]  [<794e57cf>] ? drm_helper_crtc_in_use+0x22/0x5b
[    3.030321]  [<79055b39>] warn_slowpath_null+0x1d/0x1f
[    3.030769]  [<794e57cf>] drm_helper_crtc_in_use+0x22/0x5b
[    3.031241]  [<794e58a6>] drm_helper_disable_unused_functions+0x9e/0xcf
[    3.031812]  [<7961ba05>] cirrus_fbdev_init+0x61/0x7c
[    3.032248]  [<7961b314>] cirrus_modeset_init+0x13f/0x188
[    3.032717]  [<7961a686>] cirrus_driver_load+0x89/0xd4
[    3.033166]  [<794f012f>] drm_dev_register+0x67/0xc9
[    3.033592]  [<794f1aa6>] drm_get_pci_dev+0xd7/0x18a
[    3.034029]  [<79d01f3c>] ? mutex_unlock+0x8/0xa
[    3.034430]  [<7961b40b>] cirrus_pci_probe+0x7d/0x89
[    3.034866]  [<793f03a1>] pci_device_probe+0x44/0x85
[    3.035297]  [<791234fd>] ? sysfs_create_link+0x27/0x2f
[    3.035755]  [<796cf0f4>] driver_probe_device+0x88/0x17a
[    3.036212]  [<793f0222>] ? pci_match_device+0x97/0x9d
[    3.036662]  [<796cf259>] __driver_attach+0x47/0x63
[    3.037087]  [<796cdf74>] bus_for_each_dev+0x55/0x5f
[    3.037517]  [<796cf02d>] driver_attach+0x17/0x19
[    3.037930]  [<796cf212>] ? __device_attach+0x2c/0x2c
[    3.038367]  [<796ce566>] bus_add_driver+0xd1/0x198
[    3.038802]  [<796cf807>] driver_register+0x7a/0xae
[    3.039225]  [<793f027b>] __pci_register_driver+0x2d/0x30
[    3.039698]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.040128]  [<794f1bb5>] drm_pci_init+0x5c/0xd3
[    3.040530]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.040948]  [<7a2f95c4>] cirrus_init+0x1b/0x23
[    3.041344]  [<7a2cca6c>] do_one_initcall+0x82/0x10b
[    3.041780]  [<793bf7e3>] ? strlen+0xd/0x17
[    3.042144]  [<7a2cc430>] ? repair_env_string+0x12/0x51
[    3.042600]  [<79066f76>] ? parse_args+0x168/0x224
[    3.043019]  [<7a2ccc43>] kernel_init_freeable+0x14e/0x1e5
[    3.043493]  [<7a2cc41e>] ? do_early_param+0x78/0x78
[    3.043926]  [<79ce1ad4>] kernel_init+0xb/0xc6
[    3.044312]  [<79d03b77>] ret_from_kernel_thread+0x1b/0x28
[    3.044794]  [<79ce1ac9>] ? rest_init+0x6d/0x6d
[    3.045188] ---[ end trace b419620760c3adc0 ]---
[    3.045636] ------------[ cut here ]------------
[    3.046040] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_crtc_helper.c:=
131 drm_helper_probe_single_connector_modes+0x34/0x2bf()
[    3.047200] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.14.0-=
rc7-00703-gac96a27 #103
[    3.047945] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.048434]  00000000 00000000 7803fc28 79cea3b4 00000000 7803fc58 79055=
a84 7a04f050
[    3.049206]  00000000 00000001 7a0c66ad 00000083 794e689a 794e689a 86a03=
c00 7a222974
[    3.049971]  869f3800 7803fc68 79055b39 00000009 00000000 7803fca4 794e6=
89a 0000ffff
[    3.050751] Call Trace:
[    3.050970]  [<79cea3b4>] dump_stack+0x48/0x60
[    3.051356]  [<79055a84>] warn_slowpath_common+0x6f/0x86
[    3.051821]  [<794e689a>] ? drm_helper_probe_single_connector_modes+0x34=
/0x2bf
[    3.052444]  [<794e689a>] ? drm_helper_probe_single_connector_modes+0x34=
/0x2bf
[    3.053068]  [<79055b39>] warn_slowpath_null+0x1d/0x1f
[    3.053513]  [<794e689a>] drm_helper_probe_single_connector_modes+0x34/0=
x2bf
[    3.054123]  [<794e74f0>] drm_fb_helper_probe_connector_modes+0x3b/0x49
[    3.054701]  [<794e8c4d>] drm_fb_helper_initial_config+0x16f/0x3d2
[    3.055228]  [<79055a93>] ? warn_slowpath_common+0x7e/0x86
[    3.055708]  [<794e57cf>] ? drm_helper_crtc_in_use+0x22/0x5b
[    3.056191]  [<794e57cf>] ? drm_helper_crtc_in_use+0x22/0x5b
[    3.056683]  [<794e58c3>] ? drm_helper_disable_unused_functions+0xbb/0xcf
[    3.057264]  [<7961ba11>] cirrus_fbdev_init+0x6d/0x7c
[    3.057703]  [<7961b314>] cirrus_modeset_init+0x13f/0x188
[    3.058170]  [<7961a686>] cirrus_driver_load+0x89/0xd4
[    3.058611]  [<794f012f>] drm_dev_register+0x67/0xc9
[    3.059051]  [<794f1aa6>] drm_get_pci_dev+0xd7/0x18a
[    3.059478]  [<79d01f3c>] ? mutex_unlock+0x8/0xa
[    3.059891]  [<7961b40b>] cirrus_pci_probe+0x7d/0x89
[    3.060337]  [<793f03a1>] pci_device_probe+0x44/0x85
[    3.060775]  [<791234fd>] ? sysfs_create_link+0x27/0x2f
[    3.061225]  [<796cf0f4>] driver_probe_device+0x88/0x17a
[    3.061698]  [<793f0222>] ? pci_match_device+0x97/0x9d
[    3.062143]  [<796cf259>] __driver_attach+0x47/0x63
[    3.062567]  [<796cdf74>] bus_for_each_dev+0x55/0x5f
[    3.063003]  [<796cf02d>] driver_attach+0x17/0x19
[    3.063410]  [<796cf212>] ? __device_attach+0x2c/0x2c
[    3.063857]  [<796ce566>] bus_add_driver+0xd1/0x198
[    3.064281]  [<796cf807>] driver_register+0x7a/0xae
[    3.064713]  [<793f027b>] __pci_register_driver+0x2d/0x30
[    3.065179]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.065598]  [<794f1bb5>] drm_pci_init+0x5c/0xd3
[    3.066008]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.066422]  [<7a2f95c4>] cirrus_init+0x1b/0x23
[    3.066823]  [<7a2cca6c>] do_one_initcall+0x82/0x10b
[    3.067256]  [<793bf7e3>] ? strlen+0xd/0x17
[    3.067624]  [<7a2cc430>] ? repair_env_string+0x12/0x51
[    3.068077]  [<79066f76>] ? parse_args+0x168/0x224
[    3.068495]  [<7a2ccc43>] kernel_init_freeable+0x14e/0x1e5
[    3.068983]  [<7a2cc41e>] ? do_early_param+0x78/0x78
[    3.069411]  [<79ce1ad4>] kernel_init+0xb/0xc6
[    3.069812]  [<79d03b77>] ret_from_kernel_thread+0x1b/0x28
[    3.070308]  [<79ce1ac9>] ? rest_init+0x6d/0x6d
[    3.070709] ---[ end trace b419620760c3adc1 ]---
[    3.071166] ------------[ cut here ]------------
[    3.072164] WARNING: CPU: 1 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x23/0x34()
[    3.074551] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W    3.14.0-=
rc7-00703-gac96a27 #103
[    3.076426] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.077562]  00000000 00000000 7803fbe8 79cea3b4 00000000 7803fc18 79055=
a84 7a04f050
[    3.078968]  00000001 00000001 7a0c8f62 00000077 794f80e6 794f80e6 86a03=
c00 86953280
[    3.079733]  00000400 7803fc28 79055b39 00000009 00000000 7803fc38 794f8=
0e6 79dc5a08
[    3.080515] Call Trace:
[    3.080742]  [<79cea3b4>] dump_stack+0x48/0x60
[    3.081130]  [<79055a84>] warn_slowpath_common+0x6f/0x86
[    3.081593]  [<794f80e6>] ? drm_mode_probed_add+0x23/0x34
[    3.082066]  [<794f80e6>] ? drm_mode_probed_add+0x23/0x34
[    3.082531]  [<79055b39>] warn_slowpath_null+0x1d/0x1f
[    3.082983]  [<794f80e6>] drm_mode_probed_add+0x23/0x34
[    3.083428]  [<794fb951>] drm_add_modes_noedid+0x63/0x7f
[    3.083890]  [<7961a8e9>] cirrus_vga_get_modes+0x16/0x2f
[    3.084349]  [<794e6994>] drm_helper_probe_single_connector_modes+0x12e/=
0x2bf
[    3.084970]  [<794e74f0>] drm_fb_helper_probe_connector_modes+0x3b/0x49
[    3.085537]  [<794e8c4d>] drm_fb_helper_initial_config+0x16f/0x3d2
[    3.086074]  [<79055a93>] ? warn_slowpath_common+0x7e/0x86
[    3.086551]  [<794e57cf>] ? drm_helper_crtc_in_use+0x22/0x5b
[    3.087047]  [<794e57cf>] ? drm_helper_crtc_in_use+0x22/0x5b
[    3.087532]  [<794e58c3>] ? drm_helper_disable_unused_functions+0xbb/0xcf
[    3.088122]  [<7961ba11>] cirrus_fbdev_init+0x6d/0x7c
[    3.088560]  [<7961b314>] cirrus_modeset_init+0x13f/0x188
[    3.089038]  [<7961a686>] cirrus_driver_load+0x89/0xd4
[    3.089485]  [<794f012f>] drm_dev_register+0x67/0xc9
[    3.089924]  [<794f1aa6>] drm_get_pci_dev+0xd7/0x18a
[    3.090370]  [<79d01f3c>] ? mutex_unlock+0x8/0xa
[    3.090778]  [<7961b40b>] cirrus_pci_probe+0x7d/0x89
[    3.091209]  [<793f03a1>] pci_device_probe+0x44/0x85
[    3.091649]  [<791234fd>] ? sysfs_create_link+0x27/0x2f
[    3.092105]  [<796cf0f4>] driver_probe_device+0x88/0x17a
[    3.092572]  [<793f0222>] ? pci_match_device+0x97/0x9d
[    3.093020]  [<796cf259>] __driver_attach+0x47/0x63
[    3.093444]  [<796cdf74>] bus_for_each_dev+0x55/0x5f
[    3.093883]  [<796cf02d>] driver_attach+0x17/0x19
[    3.094294]  [<796cf212>] ? __device_attach+0x2c/0x2c
[    3.094739]  [<796ce566>] bus_add_driver+0xd1/0x198
[    3.095167]  [<796cf807>] driver_register+0x7a/0xae
[    3.095593]  [<793f027b>] __pci_register_driver+0x2d/0x30
[    3.096067]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.096486]  [<794f1bb5>] drm_pci_init+0x5c/0xd3
[    3.096899]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.097320]  [<7a2f95c4>] cirrus_init+0x1b/0x23
[    3.097726]  [<7a2cca6c>] do_one_initcall+0x82/0x10b
[    3.098161]  [<793bf7e3>] ? strlen+0xd/0x17
[    3.098528]  [<7a2cc430>] ? repair_env_string+0x12/0x51
[    3.098992]  [<79066f76>] ? parse_args+0x168/0x224
[    3.099411]  [<7a2ccc43>] kernel_init_freeable+0x14e/0x1e5
[    3.099893]  [<7a2cc41e>] ? do_early_param+0x78/0x78
[    3.100339]  [<79ce1ad4>] kernel_init+0xb/0xc6
[    3.100732]  [<79d03b77>] ret_from_kernel_thread+0x1b/0x28
[    3.101213]  [<79ce1ac9>] ? rest_init+0x6d/0x6d
[    3.101607] ---[ end trace b419620760c3adc2 ]---
[    3.102014] ------------[ cut here ]------------
[    3.102413] WARNING: CPU: 1 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x23/0x34()
[    3.103387] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W    3.14.0-=
rc7-00703-gac96a27 #103
[    3.104134] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.104633]  00000000 00000000 7803fbe8 79cea3b4 00000000 7803fc18 79055=
a84 7a04f050
[    3.105400]  00000001 00000001 7a0c8f62 00000077 794f80e6 794f80e6 86a03=
c00 86953180
[    3.106164]  00000400 7803fc28 79055b39 00000009 00000000 7803fc38 794f8=
0e6 79dc5d08
[    3.106932] Call Trace:
[    3.107150]  [<79cea3b4>] dump_stack+0x48/0x60
[    3.107536]  [<79055a84>] warn_slowpath_common+0x6f/0x86
[    3.108000]  [<794f80e6>] ? drm_mode_probed_add+0x23/0x34
[    3.108466]  [<794f80e6>] ? drm_mode_probed_add+0x23/0x34
[    3.108945]  [<79055b39>] warn_slowpath_null+0x1d/0x1f
[    3.109392]  [<794f80e6>] drm_mode_probed_add+0x23/0x34
[    3.109848]  [<794fb951>] drm_add_modes_noedid+0x63/0x7f
[    3.110319]  [<7961a8e9>] cirrus_vga_get_modes+0x16/0x2f
[    3.110787]  [<794e6994>] drm_helper_probe_single_connector_modes+0x12e/=
0x2bf
[    3.111400]  [<794e74f0>] drm_fb_helper_probe_connector_modes+0x3b/0x49
[    3.111971]  [<794e8c4d>] drm_fb_helper_initial_config+0x16f/0x3d2
[    3.112503]  [<79055a93>] ? warn_slowpath_common+0x7e/0x86
[    3.112980]  [<794e57cf>] ? drm_helper_crtc_in_use+0x22/0x5b
[    3.113466]  [<794e57cf>] ? drm_helper_crtc_in_use+0x22/0x5b
[    3.113961]  [<794e58c3>] ? drm_helper_disable_unused_functions+0xbb/0xcf
[    3.114544]  [<7961ba11>] cirrus_fbdev_init+0x6d/0x7c
[    3.114990]  [<7961b314>] cirrus_modeset_init+0x13f/0x188
[    3.115460]  [<7961a686>] cirrus_driver_load+0x89/0xd4
[    3.115909]  [<794f012f>] drm_dev_register+0x67/0xc9
[    3.116341]  [<794f1aa6>] drm_get_pci_dev+0xd7/0x18a
[    3.116776]  [<79d01f3c>] ? mutex_unlock+0x8/0xa
[    3.117176]  [<7961b40b>] cirrus_pci_probe+0x7d/0x89
[    3.117605]  [<793f03a1>] pci_device_probe+0x44/0x85
[    3.118042]  [<791234fd>] ? sysfs_create_link+0x27/0x2f
[    3.118498]  [<796cf0f4>] driver_probe_device+0x88/0x17a
[    3.118971]  [<793f0222>] ? pci_match_device+0x97/0x9d
[    3.119418]  [<796cf259>] __driver_attach+0x47/0x63
[    3.119849]  [<796cdf74>] bus_for_each_dev+0x55/0x5f
[    3.120295]  [<796cf02d>] driver_attach+0x17/0x19
[    3.120712]  [<796cf212>] ? __device_attach+0x2c/0x2c
[    3.121153]  [<796ce566>] bus_add_driver+0xd1/0x198
[    3.121577]  [<796cf807>] driver_register+0x7a/0xae
[    3.122005]  [<793f027b>] __pci_register_driver+0x2d/0x30
[    3.122473]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.122903]  [<794f1bb5>] drm_pci_init+0x5c/0xd3
[    3.123302]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.123724]  [<7a2f95c4>] cirrus_init+0x1b/0x23
[    3.124118]  [<7a2cca6c>] do_one_initcall+0x82/0x10b
[    3.124545]  [<793bf7e3>] ? strlen+0xd/0x17
[    3.124915]  [<7a2cc430>] ? repair_env_string+0x12/0x51
[    3.125364]  [<79066f76>] ? parse_args+0x168/0x224
[    3.125783]  [<7a2ccc43>] kernel_init_freeable+0x14e/0x1e5
[    3.126255]  [<7a2cc41e>] ? do_early_param+0x78/0x78
[    3.126687]  [<79ce1ad4>] kernel_init+0xb/0xc6
[    3.127072]  [<79d03b77>] ret_from_kernel_thread+0x1b/0x28
[    3.127545]  [<79ce1ac9>] ? rest_init+0x6d/0x6d
[    3.127942] ---[ end trace b419620760c3adc3 ]---
[    3.128343] ------------[ cut here ]------------
[    3.128751] WARNING: CPU: 1 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x23/0x34()
[    3.129727] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W    3.14.0-=
rc7-00703-gac96a27 #103
[    3.130478] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.130982]  00000000 00000000 7803fbe8 79cea3b4 00000000 7803fc18 79055=
a84 7a04f050
[    3.131753]  00000001 00000001 7a0c8f62 00000077 794f80e6 794f80e6 86a03=
c00 86953080
[    3.132517]  00000400 7803fc28 79055b39 00000009 00000000 7803fc38 794f8=
0e6 79dc5dc8
[    3.133291] Call Trace:
[    3.133512]  [<79cea3b4>] dump_stack+0x48/0x60
[    3.133906]  [<79055a84>] warn_slowpath_common+0x6f/0x86
[    3.134368]  [<794f80e6>] ? drm_mode_probed_add+0x23/0x34
[    3.134845]  [<794f80e6>] ? drm_mode_probed_add+0x23/0x34
[    3.135313]  [<79055b39>] warn_slowpath_null+0x1d/0x1f
[    3.135764]  [<794f80e6>] drm_mode_probed_add+0x23/0x34
[    3.136217]  [<794fb951>] drm_add_modes_noedid+0x63/0x7f
[    3.136686]  [<7961a8e9>] cirrus_vga_get_modes+0x16/0x2f
[    3.137139]  [<794e6994>] drm_helper_probe_single_connector_modes+0x12e/=
0x2bf
[    3.137751]  [<794e74f0>] drm_fb_helper_probe_connector_modes+0x3b/0x49
[    3.138322]  [<794e8c4d>] drm_fb_helper_initial_config+0x16f/0x3d2
[    3.138867]  [<79055a93>] ? warn_slowpath_common+0x7e/0x86
[    3.139339]  [<794e57cf>] ? drm_helper_crtc_in_use+0x22/0x5b
[    3.139830]  [<794e57cf>] ? drm_helper_crtc_in_use+0x22/0x5b
[    3.140328]  [<794e58c3>] ? drm_helper_disable_unused_functions+0xbb/0xcf
[    3.140917]  [<7961ba11>] cirrus_fbdev_init+0x6d/0x7c
[    3.141348]  [<7961b314>] cirrus_modeset_init+0x13f/0x188
[    3.141818]  [<7961a686>] cirrus_driver_load+0x89/0xd4
[    3.142263]  [<794f012f>] drm_dev_register+0x67/0xc9
[    3.142698]  [<794f1aa6>] drm_get_pci_dev+0xd7/0x18a
[    3.143128]  [<79d01f3c>] ? mutex_unlock+0x8/0xa
[    3.143529]  [<7961b40b>] cirrus_pci_probe+0x7d/0x89
[    3.143964]  [<793f03a1>] pci_device_probe+0x44/0x85
[    3.144394]  [<791234fd>] ? sysfs_create_link+0x27/0x2f
[    3.144856]  [<796cf0f4>] driver_probe_device+0x88/0x17a
[    3.145316]  [<793f0222>] ? pci_match_device+0x97/0x9d
[    3.145764]  [<796cf259>] __driver_attach+0x47/0x63
[    3.146188]  [<796cdf74>] bus_for_each_dev+0x55/0x5f
[    3.146620]  [<796cf02d>] driver_attach+0x17/0x19
[    3.147026]  [<796cf212>] ? __device_attach+0x2c/0x2c
[    3.147464]  [<796ce566>] bus_add_driver+0xd1/0x198
[    3.147893]  [<796cf807>] driver_register+0x7a/0xae
[    3.148318]  [<793f027b>] __pci_register_driver+0x2d/0x30
[    3.148798]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.149215]  [<794f1bb5>] drm_pci_init+0x5c/0xd3
[    3.149629]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.150056]  [<7a2f95c4>] cirrus_init+0x1b/0x23
[    3.150452]  [<7a2cca6c>] do_one_initcall+0x82/0x10b
[    3.150888]  [<793bf7e3>] ? strlen+0xd/0x17
[    3.151253]  [<7a2cc430>] ? repair_env_string+0x12/0x51
[    3.151713]  [<79066f76>] ? parse_args+0x168/0x224
[    3.152130]  [<7a2ccc43>] kernel_init_freeable+0x14e/0x1e5
[    3.152606]  [<7a2cc41e>] ? do_early_param+0x78/0x78
[    3.153039]  [<79ce1ad4>] kernel_init+0xb/0xc6
[    3.153427]  [<79d03b77>] ret_from_kernel_thread+0x1b/0x28
[    3.153907]  [<79ce1ac9>] ? rest_init+0x6d/0x6d
[    3.154299] ---[ end trace b419620760c3adc4 ]---
[    3.154718] ------------[ cut here ]------------
[    3.155123] WARNING: CPU: 1 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x23/0x34()
[    3.156102] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W    3.14.0-=
rc7-00703-gac96a27 #103
[    3.156853] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.157340]  00000000 00000000 7803fbe8 79cea3b4 00000000 7803fc18 79055=
a84 7a04f050
[    3.158110]  00000001 00000001 7a0c8f62 00000077 794f80e6 794f80e6 86a03=
c00 869e3e80
[    3.158882]  00000400 7803fc28 79055b39 00000009 00000000 7803fc38 794f8=
0e6 79dc6188
[    3.159652] Call Trace:
[    3.159871]  [<79cea3b4>] dump_stack+0x48/0x60
[    3.160271]  [<79055a84>] warn_slowpath_common+0x6f/0x86
[    3.160740]  [<794f80e6>] ? drm_mode_probed_add+0x23/0x34
[    3.161206]  [<794f80e6>] ? drm_mode_probed_add+0x23/0x34
[    3.161674]  [<79055b39>] warn_slowpath_null+0x1d/0x1f
[    3.162121]  [<794f80e6>] drm_mode_probed_add+0x23/0x34
[    3.162574]  [<794fb951>] drm_add_modes_noedid+0x63/0x7f
[    3.163042]  [<7961a8e9>] cirrus_vga_get_modes+0x16/0x2f
[    3.163506]  [<794e6994>] drm_helper_probe_single_connector_modes+0x12e/=
0x2bf
[    3.164120]  [<794e74f0>] drm_fb_helper_probe_connector_modes+0x3b/0x49
[    3.164698]  [<794e8c4d>] drm_fb_helper_initial_config+0x16f/0x3d2
[    3.165231]  [<79055a93>] ? warn_slowpath_common+0x7e/0x86
[    3.165709]  [<794e57cf>] ? drm_helper_crtc_in_use+0x22/0x5b
[    3.166196]  [<794e57cf>] ? drm_helper_crtc_in_use+0x22/0x5b
[    3.166691]  [<794e58c3>] ? drm_helper_disable_unused_functions+0xbb/0xcf
[    3.167272]  [<7961ba11>] cirrus_fbdev_init+0x6d/0x7c
[    3.167711]  [<7961b314>] cirrus_modeset_init+0x13f/0x188
[    3.168178]  [<7961a686>] cirrus_driver_load+0x89/0xd4
[    3.168632]  [<794f012f>] drm_dev_register+0x67/0xc9
[    3.169064]  [<794f1aa6>] drm_get_pci_dev+0xd7/0x18a
[    3.169491]  [<79d01f3c>] ? mutex_unlock+0x8/0xa
[    3.169901]  [<7961b40b>] cirrus_pci_probe+0x7d/0x89
[    3.170343]  [<793f03a1>] pci_device_probe+0x44/0x85
[    3.170782]  [<791234fd>] ? sysfs_create_link+0x27/0x2f
[    3.171233]  [<796cf0f4>] driver_probe_device+0x88/0x17a
[    3.171703]  [<793f0222>] ? pci_match_device+0x97/0x9d
[    3.172145]  [<796cf259>] __driver_attach+0x47/0x63
[    3.172570]  [<796cdf74>] bus_for_each_dev+0x55/0x5f
[    3.173004]  [<796cf02d>] driver_attach+0x17/0x19
[    3.173412]  [<796cf212>] ? __device_attach+0x2c/0x2c
[    3.173856]  [<796ce566>] bus_add_driver+0xd1/0x198
[    3.174279]  [<796cf807>] driver_register+0x7a/0xae
[    3.174706]  [<793f027b>] __pci_register_driver+0x2d/0x30
[    3.175177]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.175592]  [<794f1bb5>] drm_pci_init+0x5c/0xd3
[    3.176000]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.176416]  [<7a2f95c4>] cirrus_init+0x1b/0x23
[    3.176822]  [<7a2cca6c>] do_one_initcall+0x82/0x10b
[    3.177251]  [<793bf7e3>] ? strlen+0xd/0x17
[    3.177622]  [<7a2cc430>] ? repair_env_string+0x12/0x51
[    3.178074]  [<79066f76>] ? parse_args+0x168/0x224
[    3.178485]  [<7a2ccc43>] kernel_init_freeable+0x14e/0x1e5
[    3.178968]  [<7a2cc41e>] ? do_early_param+0x78/0x78
[    3.179397]  [<79ce1ad4>] kernel_init+0xb/0xc6
[    3.179789]  [<79d03b77>] ret_from_kernel_thread+0x1b/0x28
[    3.180276]  [<79ce1ac9>] ? rest_init+0x6d/0x6d
[    3.180677] ---[ end trace b419620760c3adc5 ]---
[    3.181075] ------------[ cut here ]------------
[    3.181479] WARNING: CPU: 1 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x23/0x34()
[    3.182449] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W    3.14.0-=
rc7-00703-gac96a27 #103
[    3.183198] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.183697]  00000000 00000000 7803fbe8 79cea3b4 00000000 7803fc18 79055=
a84 7a04f050
[    3.184458]  00000001 00000001 7a0c8f62 00000077 794f80e6 794f80e6 86a03=
c00 869e3d80
[    3.185226]  00000400 7803fc28 79055b39 00000009 00000000 7803fc38 794f8=
0e6 79dc6308
[    3.185992] Call Trace:
[    3.186212]  [<79cea3b4>] dump_stack+0x48/0x60
[    3.186601]  [<79055a84>] warn_slowpath_common+0x6f/0x86
[    3.187066]  [<794f80e6>] ? drm_mode_probed_add+0x23/0x34
[    3.187534]  [<794f80e6>] ? drm_mode_probed_add+0x23/0x34
[    3.188009]  [<79055b39>] warn_slowpath_null+0x1d/0x1f
[    3.188453]  [<794f80e6>] drm_mode_probed_add+0x23/0x34
[    3.188917]  [<794fb951>] drm_add_modes_noedid+0x63/0x7f
[    3.189379]  [<7961a8e9>] cirrus_vga_get_modes+0x16/0x2f
[    3.189850]  [<794e6994>] drm_helper_probe_single_connector_modes+0x12e/=
0x2bf
[    3.190482]  [<794e74f0>] drm_fb_helper_probe_connector_modes+0x3b/0x49
[    3.191059]  [<794e8c4d>] drm_fb_helper_initial_config+0x16f/0x3d2
[    3.191588]  [<79055a93>] ? warn_slowpath_common+0x7e/0x86
[    3.192075]  [<794e57cf>] ? drm_helper_crtc_in_use+0x22/0x5b
[    3.192564]  [<794e57cf>] ? drm_helper_crtc_in_use+0x22/0x5b
[    3.193057]  [<794e58c3>] ? drm_helper_disable_unused_functions+0xbb/0xcf
[    3.193650]  [<7961ba11>] cirrus_fbdev_init+0x6d/0x7c
[    3.194090]  [<7961b314>] cirrus_modeset_init+0x13f/0x188
[    3.194554]  [<7961a686>] cirrus_driver_load+0x89/0xd4
[    3.195009]  [<794f012f>] drm_dev_register+0x67/0xc9
[    3.195444]  [<794f1aa6>] drm_get_pci_dev+0xd7/0x18a
[    3.195884]  [<79d01f3c>] ? mutex_unlock+0x8/0xa
[    3.196288]  [<7961b40b>] cirrus_pci_probe+0x7d/0x89
[    3.196726]  [<793f03a1>] pci_device_probe+0x44/0x85
[    3.197156]  [<791234fd>] ? sysfs_create_link+0x27/0x2f
[    3.197607]  [<796cf0f4>] driver_probe_device+0x88/0x17a
[    3.198072]  [<793f0222>] ? pci_match_device+0x97/0x9d
[    3.198518]  [<796cf259>] __driver_attach+0x47/0x63
[    3.198951]  [<796cdf74>] bus_for_each_dev+0x55/0x5f
[    3.199382]  [<796cf02d>] driver_attach+0x17/0x19
[    3.199798]  [<796cf212>] ? __device_attach+0x2c/0x2c
[    3.200252]  [<796ce566>] bus_add_driver+0xd1/0x198
[    3.200686]  [<796cf807>] driver_register+0x7a/0xae
[    3.201111]  [<793f027b>] __pci_register_driver+0x2d/0x30
[    3.201581]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.202007]  [<794f1bb5>] drm_pci_init+0x5c/0xd3
[    3.202410]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.202835]  [<7a2f95c4>] cirrus_init+0x1b/0x23
[    3.203229]  [<7a2cca6c>] do_one_initcall+0x82/0x10b
[    3.203666]  [<793bf7e3>] ? strlen+0xd/0x17
[    3.204032]  [<7a2cc430>] ? repair_env_string+0x12/0x51
[    3.204481]  [<79066f76>] ? parse_args+0x168/0x224
[    3.204903]  [<7a2ccc43>] kernel_init_freeable+0x14e/0x1e5
[    3.205383]  [<7a2cc41e>] ? do_early_param+0x78/0x78
[    3.205822]  [<79ce1ad4>] kernel_init+0xb/0xc6
[    3.206212]  [<79d03b77>] ret_from_kernel_thread+0x1b/0x28
[    3.206692]  [<79ce1ac9>] ? rest_init+0x6d/0x6d
[    3.207089] ---[ end trace b419620760c3adc6 ]---
[    3.207489] ------------[ cut here ]------------
[    3.207899] WARNING: CPU: 1 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x23/0x34()
[    3.208873] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W    3.14.0-=
rc7-00703-gac96a27 #103
[    3.209623] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.210127]  00000000 00000000 7803fbe8 79cea3b4 00000000 7803fc18 79055=
a84 7a04f050
[    3.210896]  00000001 00000001 7a0c8f62 00000077 794f80e6 794f80e6 86a03=
c00 869e3c80
[    3.211663]  00000400 7803fc28 79055b39 00000009 00000000 7803fc38 794f8=
0e6 79dc6788
[    3.212432] Call Trace:
[    3.212656]  [<79cea3b4>] dump_stack+0x48/0x60
[    3.213043]  [<79055a84>] warn_slowpath_common+0x6f/0x86
[    3.213503]  [<794f80e6>] ? drm_mode_probed_add+0x23/0x34
[    3.213977]  [<794f80e6>] ? drm_mode_probed_add+0x23/0x34
[    3.214446]  [<79055b39>] warn_slowpath_null+0x1d/0x1f
[    3.214901]  [<794f80e6>] drm_mode_probed_add+0x23/0x34
[    3.215357]  [<794fb951>] drm_add_modes_noedid+0x63/0x7f
[    3.215824]  [<7961a8e9>] cirrus_vga_get_modes+0x16/0x2f
[    3.216286]  [<794e6994>] drm_helper_probe_single_connector_modes+0x12e/=
0x2bf
[    3.216905]  [<794e74f0>] drm_fb_helper_probe_connector_modes+0x3b/0x49
[    3.217473]  [<794e8c4d>] drm_fb_helper_initial_config+0x16f/0x3d2
[    3.218012]  [<79055a93>] ? warn_slowpath_common+0x7e/0x86
[    3.218486]  [<794e57cf>] ? drm_helper_crtc_in_use+0x22/0x5b
[    3.218983]  [<794e57cf>] ? drm_helper_crtc_in_use+0x22/0x5b
[    3.219472]  [<794e58c3>] ? drm_helper_disable_unused_functions+0xbb/0xcf
[    3.220068]  [<7961ba11>] cirrus_fbdev_init+0x6d/0x7c
[    3.220509]  [<7961b314>] cirrus_modeset_init+0x13f/0x188
[    3.220982]  [<7961a686>] cirrus_driver_load+0x89/0xd4
[    3.221427]  [<794f012f>] drm_dev_register+0x67/0xc9
[    3.221863]  [<794f1aa6>] drm_get_pci_dev+0xd7/0x18a
[    3.222294]  [<79d01f3c>] ? mutex_unlock+0x8/0xa
[    3.222703]  [<7961b40b>] cirrus_pci_probe+0x7d/0x89
[    3.223138]  [<793f03a1>] pci_device_probe+0x44/0x85
[    3.223574]  [<791234fd>] ? sysfs_create_link+0x27/0x2f
[    3.224035]  [<796cf0f4>] driver_probe_device+0x88/0x17a
[    3.224496]  [<793f0222>] ? pci_match_device+0x97/0x9d
[    3.224946]  [<796cf259>] __driver_attach+0x47/0x63
[    3.225371]  [<796cdf74>] bus_for_each_dev+0x55/0x5f
[    3.225807]  [<796cf02d>] driver_attach+0x17/0x19
[    3.226220]  [<796cf212>] ? __device_attach+0x2c/0x2c
[    3.226667]  [<796ce566>] bus_add_driver+0xd1/0x198
[    3.227092]  [<796cf807>] driver_register+0x7a/0xae
[    3.227512]  [<793f027b>] __pci_register_driver+0x2d/0x30
[    3.227986]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.228405]  [<794f1bb5>] drm_pci_init+0x5c/0xd3
[    3.228817]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.229230]  [<7a2f95c4>] cirrus_init+0x1b/0x23
[    3.229630]  [<7a2cca6c>] do_one_initcall+0x82/0x10b
[    3.230067]  [<793bf7e3>] ? strlen+0xd/0x17
[    3.230436]  [<7a2cc430>] ? repair_env_string+0x12/0x51
[    3.230894]  [<79066f76>] ? parse_args+0x168/0x224
[    3.231313]  [<7a2ccc43>] kernel_init_freeable+0x14e/0x1e5
[    3.231793]  [<7a2cc41e>] ? do_early_param+0x78/0x78
[    3.232222]  [<79ce1ad4>] kernel_init+0xb/0xc6
[    3.232611]  [<79d03b77>] ret_from_kernel_thread+0x1b/0x28
[    3.233085]  [<79ce1ac9>] ? rest_init+0x6d/0x6d
[    3.233478] ---[ end trace b419620760c3adc7 ]---
[    3.233882] ------------[ cut here ]------------
[    3.234284] WARNING: CPU: 1 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x23/0x34()
[    3.235260] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W    3.14.0-=
rc7-00703-gac96a27 #103
[    3.236007] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.236500]  00000000 00000000 7803fbe8 79cea3b4 00000000 7803fc18 79055=
a84 7a04f050
[    3.237271]  00000001 00000001 7a0c8f62 00000077 794f80e6 794f80e6 86a03=
c00 869e3b80
[    3.238038]  00000400 7803fc28 79055b39 00000009 00000000 7803fc38 794f8=
0e6 79dc6848
[    3.238812] Call Trace:
[    3.239033]  [<79cea3b4>] dump_stack+0x48/0x60
[    3.239423]  [<79055a84>] warn_slowpath_common+0x6f/0x86
[    3.239892]  [<794f80e6>] ? drm_mode_probed_add+0x23/0x34
[    3.240373]  [<794f80e6>] ? drm_mode_probed_add+0x23/0x34
[    3.240849]  [<79055b39>] warn_slowpath_null+0x1d/0x1f
[    3.241291]  [<794f80e6>] drm_mode_probed_add+0x23/0x34
[    3.241750]  [<794fb951>] drm_add_modes_noedid+0x63/0x7f
[    3.242210]  [<7961a8e9>] cirrus_vga_get_modes+0x16/0x2f
[    3.242674]  [<794e6994>] drm_helper_probe_single_connector_modes+0x12e/=
0x2bf
[    3.243288]  [<794e74f0>] drm_fb_helper_probe_connector_modes+0x3b/0x49
[    3.243859]  [<794e8c4d>] drm_fb_helper_initial_config+0x16f/0x3d2
[    3.244391]  [<79055a93>] ? warn_slowpath_common+0x7e/0x86
[    3.244868]  [<794e57cf>] ? drm_helper_crtc_in_use+0x22/0x5b
[    3.245359]  [<794e57cf>] ? drm_helper_crtc_in_use+0x22/0x5b
[    3.245853]  [<794e58c3>] ? drm_helper_disable_unused_functions+0xbb/0xcf
[    3.246433]  [<7961ba11>] cirrus_fbdev_init+0x6d/0x7c
[    3.246876]  [<7961b314>] cirrus_modeset_init+0x13f/0x188
[    3.247343]  [<7961a686>] cirrus_driver_load+0x89/0xd4
[    3.247794]  [<794f012f>] drm_dev_register+0x67/0xc9
[    3.248225]  [<794f1aa6>] drm_get_pci_dev+0xd7/0x18a
[    3.248667]  [<79d01f3c>] ? mutex_unlock+0x8/0xa
[    3.249067]  [<7961b40b>] cirrus_pci_probe+0x7d/0x89
[    3.249500]  [<793f03a1>] pci_device_probe+0x44/0x85
[    3.249934]  [<791234fd>] ? sysfs_create_link+0x27/0x2f
[    3.250400]  [<796cf0f4>] driver_probe_device+0x88/0x17a
[    3.250869]  [<793f0222>] ? pci_match_device+0x97/0x9d
[    3.251317]  [<796cf259>] __driver_attach+0x47/0x63
[    3.251749]  [<796cdf74>] bus_for_each_dev+0x55/0x5f
[    3.252182]  [<796cf02d>] driver_attach+0x17/0x19
[    3.252592]  [<796cf212>] ? __device_attach+0x2c/0x2c
[    3.253035]  [<796ce566>] bus_add_driver+0xd1/0x198
[    3.253460]  [<796cf807>] driver_register+0x7a/0xae
[    3.253891]  [<793f027b>] __pci_register_driver+0x2d/0x30
[    3.254358]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.254790]  [<794f1bb5>] drm_pci_init+0x5c/0xd3
[    3.255190]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.255603]  [<7a2f95c4>] cirrus_init+0x1b/0x23
[    3.256004]  [<7a2cca6c>] do_one_initcall+0x82/0x10b
[    3.256433]  [<793bf7e3>] ? strlen+0xd/0x17
[    3.256805]  [<7a2cc430>] ? repair_env_string+0x12/0x51
[    3.257257]  [<79066f76>] ? parse_args+0x168/0x224
[    3.257678]  [<7a2ccc43>] kernel_init_freeable+0x14e/0x1e5
[    3.258151]  [<7a2cc41e>] ? do_early_param+0x78/0x78
[    3.258589]  [<79ce1ad4>] kernel_init+0xb/0xc6
[    3.258988]  [<79d03b77>] ret_from_kernel_thread+0x1b/0x28
[    3.259462]  [<79ce1ac9>] ? rest_init+0x6d/0x6d
[    3.259862] ---[ end trace b419620760c3adc8 ]---
[    3.260277] ------------[ cut here ]------------
[    3.260686] WARNING: CPU: 1 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x23/0x34()
[    3.261657] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W    3.14.0-=
rc7-00703-gac96a27 #103
[    3.262399] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.262900]  00000000 00000000 7803fbe8 79cea3b4 00000000 7803fc18 79055=
a84 7a04f050
[    3.263669]  00000001 00000001 7a0c8f62 00000077 794f80e6 794f80e6 86a03=
c00 869e3a80
[    3.264432]  00000400 7803fc28 79055b39 00000009 00000000 7803fc38 794f8=
0e6 79dc6b48
[    3.265204] Call Trace:
[    3.265428]  [<79cea3b4>] dump_stack+0x48/0x60
[    3.265819]  [<79055a84>] warn_slowpath_common+0x6f/0x86
[    3.266280]  [<794f80e6>] ? drm_mode_probed_add+0x23/0x34
[    3.266758]  [<794f80e6>] ? drm_mode_probed_add+0x23/0x34
[    3.267223]  [<79055b39>] warn_slowpath_null+0x1d/0x1f
[    3.267672]  [<794f80e6>] drm_mode_probed_add+0x23/0x34
[    3.268125]  [<794fb951>] drm_add_modes_noedid+0x63/0x7f
[    3.268591]  [<7961a8e9>] cirrus_vga_get_modes+0x16/0x2f
[    3.269063]  [<794e6994>] drm_helper_probe_single_connector_modes+0x12e/=
0x2bf
[    3.269679]  [<794e74f0>] drm_fb_helper_probe_connector_modes+0x3b/0x49
[    3.270264]  [<794e8c4d>] drm_fb_helper_initial_config+0x16f/0x3d2
[    3.270802]  [<79055a93>] ? warn_slowpath_common+0x7e/0x86
[    3.271280]  [<794e57cf>] ? drm_helper_crtc_in_use+0x22/0x5b
[    3.271779]  [<794e57cf>] ? drm_helper_crtc_in_use+0x22/0x5b
[    3.272264]  [<794e58c3>] ? drm_helper_disable_unused_functions+0xbb/0xcf
[    3.272848]  [<7961ba11>] cirrus_fbdev_init+0x6d/0x7c
[    3.273285]  [<7961b314>] cirrus_modeset_init+0x13f/0x188
[    3.273754]  [<7961a686>] cirrus_driver_load+0x89/0xd4
[    3.274199]  [<794f012f>] drm_dev_register+0x67/0xc9
[    3.274636]  [<794f1aa6>] drm_get_pci_dev+0xd7/0x18a
[    3.275064]  [<79d01f3c>] ? mutex_unlock+0x8/0xa
[    3.275466]  [<7961b40b>] cirrus_pci_probe+0x7d/0x89
[    3.275905]  [<793f03a1>] pci_device_probe+0x44/0x85
[    3.276337]  [<791234fd>] ? sysfs_create_link+0x27/0x2f
[    3.276796]  [<796cf0f4>] driver_probe_device+0x88/0x17a
[    3.277254]  [<793f0222>] ? pci_match_device+0x97/0x9d
[    3.277704]  [<796cf259>] __driver_attach+0x47/0x63
[    3.278128]  [<796cdf74>] bus_for_each_dev+0x55/0x5f
[    3.278553]  [<796cf02d>] driver_attach+0x17/0x19
[    3.278970]  [<796cf212>] ? __device_attach+0x2c/0x2c
[    3.279407]  [<796ce566>] bus_add_driver+0xd1/0x198
[    3.279838]  [<796cf807>] driver_register+0x7a/0xae
[    3.280277]  [<793f027b>] __pci_register_driver+0x2d/0x30
[    3.280752]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.281169]  [<794f1bb5>] drm_pci_init+0x5c/0xd3
[    3.281569]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.281988]  [<7a2f95c4>] cirrus_init+0x1b/0x23
[    3.282380]  [<7a2cca6c>] do_one_initcall+0x82/0x10b
[    3.282814]  [<793bf7e3>] ? strlen+0xd/0x17
[    3.283179]  [<7a2cc430>] ? repair_env_string+0x12/0x51
[    3.283635]  [<79066f76>] ? parse_args+0x168/0x224
[    3.284052]  [<7a2ccc43>] kernel_init_freeable+0x14e/0x1e5
[    3.284523]  [<7a2cc41e>] ? do_early_param+0x78/0x78
[    3.284959]  [<79ce1ad4>] kernel_init+0xb/0xc6
[    3.285345]  [<79d03b77>] ret_from_kernel_thread+0x1b/0x28
[    3.285823]  [<79ce1ac9>] ? rest_init+0x6d/0x6d
[    3.286220] ---[ end trace b419620760c3adc9 ]---
[    3.286624] ------------[ cut here ]------------
[    3.287028] WARNING: CPU: 1 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x23/0x34()
[    3.288000] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W    3.14.0-=
rc7-00703-gac96a27 #103
[    3.288750] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.289243]  00000000 00000000 7803fbe8 79cea3b4 00000000 7803fc18 79055=
a84 7a04f050
[    3.290024]  00000001 00000001 7a0c8f62 00000077 794f80e6 794f80e6 86a03=
c00 869e3980
[    3.290791]  00000400 7803fc28 79055b39 00000009 00000000 7803fc38 794f8=
0e6 79dc6c08
[    3.291552] Call Trace:
[    3.291776]  [<79cea3b4>] dump_stack+0x48/0x60
[    3.292163]  [<79055a84>] warn_slowpath_common+0x6f/0x86
[    3.292628]  [<794f80e6>] ? drm_mode_probed_add+0x23/0x34
[    3.293094]  [<794f80e6>] ? drm_mode_probed_add+0x23/0x34
[    3.293562]  [<79055b39>] warn_slowpath_null+0x1d/0x1f
[    3.294011]  [<794f80e6>] drm_mode_probed_add+0x23/0x34
[    3.294463]  [<794fb951>] drm_add_modes_noedid+0x63/0x7f
[    3.294927]  [<7961a8e9>] cirrus_vga_get_modes+0x16/0x2f
[    3.295385]  [<794e6994>] drm_helper_probe_single_connector_modes+0x12e/=
0x2bf
[    3.296001]  [<794e74f0>] drm_fb_helper_probe_connector_modes+0x3b/0x49
[    3.296570]  [<794e8c4d>] drm_fb_helper_initial_config+0x16f/0x3d2
[    3.297107]  [<79055a93>] ? warn_slowpath_common+0x7e/0x86
[    3.297583]  [<794e57cf>] ? drm_helper_crtc_in_use+0x22/0x5b
[    3.298080]  [<794e57cf>] ? drm_helper_crtc_in_use+0x22/0x5b
[    3.298571]  [<794e58c3>] ? drm_helper_disable_unused_functions+0xbb/0xcf
[    3.299161]  [<7961ba11>] cirrus_fbdev_init+0x6d/0x7c
[    3.299596]  [<7961b314>] cirrus_modeset_init+0x13f/0x188
[    3.300083]  [<7961a686>] cirrus_driver_load+0x89/0xd4
[    3.300535]  [<794f012f>] drm_dev_register+0x67/0xc9
[    3.300972]  [<794f1aa6>] drm_get_pci_dev+0xd7/0x18a
[    3.301404]  [<79d01f3c>] ? mutex_unlock+0x8/0xa
[    3.301812]  [<7961b40b>] cirrus_pci_probe+0x7d/0x89
[    3.302242]  [<793f03a1>] pci_device_probe+0x44/0x85
[    3.302679]  [<791234fd>] ? sysfs_create_link+0x27/0x2f
[    3.303131]  [<796cf0f4>] driver_probe_device+0x88/0x17a
[    3.303596]  [<793f0222>] ? pci_match_device+0x97/0x9d
[    3.304045]  [<796cf259>] __driver_attach+0x47/0x63
[    3.304468]  [<796cdf74>] bus_for_each_dev+0x55/0x5f
[    3.304907]  [<796cf02d>] driver_attach+0x17/0x19
[    3.305315]  [<796cf212>] ? __device_attach+0x2c/0x2c
[    3.305763]  [<796ce566>] bus_add_driver+0xd1/0x198
[    3.306188]  [<796cf807>] driver_register+0x7a/0xae
[    3.306613]  [<793f027b>] __pci_register_driver+0x2d/0x30
[    3.307090]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.307508]  [<794f1bb5>] drm_pci_init+0x5c/0xd3
[    3.307913]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.308328]  [<7a2f95c4>] cirrus_init+0x1b/0x23
[    3.308738]  [<7a2cca6c>] do_one_initcall+0x82/0x10b
[    3.309170]  [<793bf7e3>] ? strlen+0xd/0x17
[    3.309535]  [<7a2cc430>] ? repair_env_string+0x12/0x51
[    3.309996]  [<79066f76>] ? parse_args+0x168/0x224
[    3.310432]  [<7a2ccc43>] kernel_init_freeable+0x14e/0x1e5
[    3.310913]  [<7a2cc41e>] ? do_early_param+0x78/0x78
[    3.311345]  [<79ce1ad4>] kernel_init+0xb/0xc6
[    3.311738]  [<79d03b77>] ret_from_kernel_thread+0x1b/0x28
[    3.312212]  [<79ce1ac9>] ? rest_init+0x6d/0x6d
[    3.312601] ---[ end trace b419620760c3adca ]---
[    3.313006] ------------[ cut here ]------------
[    3.313409] WARNING: CPU: 1 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x23/0x34()
[    3.314379] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W    3.14.0-=
rc7-00703-gac96a27 #103
[    3.315129] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.315627]  00000000 00000000 7803fbe8 79cea3b4 00000000 7803fc18 79055=
a84 7a04f050
[    3.316389]  00000001 00000001 7a0c8f62 00000077 794f80e6 794f80e6 86a03=
c00 869e3880
[    3.317157]  00000400 7803fc28 79055b39 00000009 00000000 7803fc38 794f8=
0e6 79dc6f08
[    3.317928] Call Trace:
[    3.318148]  [<79cea3b4>] dump_stack+0x48/0x60
[    3.318534]  [<79055a84>] warn_slowpath_common+0x6f/0x86
[    3.319009]  [<794f80e6>] ? drm_mode_probed_add+0x23/0x34
[    3.319477]  [<794f80e6>] ? drm_mode_probed_add+0x23/0x34
[    3.319948]  [<79055b39>] warn_slowpath_null+0x1d/0x1f
[    3.320408]  [<794f80e6>] drm_mode_probed_add+0x23/0x34
[    3.320870]  [<794fb951>] drm_add_modes_noedid+0x63/0x7f
[    3.321332]  [<7961a8e9>] cirrus_vga_get_modes+0x16/0x2f
[    3.321793]  [<794e6994>] drm_helper_probe_single_connector_modes+0x12e/=
0x2bf
[    3.322406]  [<794e74f0>] drm_fb_helper_probe_connector_modes+0x3b/0x49
[    3.322982]  [<794e8c4d>] drm_fb_helper_initial_config+0x16f/0x3d2
[    3.323517]  [<79055a93>] ? warn_slowpath_common+0x7e/0x86
[    3.324000]  [<794e57cf>] ? drm_helper_crtc_in_use+0x22/0x5b
[    3.324482]  [<794e57cf>] ? drm_helper_crtc_in_use+0x22/0x5b
[    3.324976]  [<794e58c3>] ? drm_helper_disable_unused_functions+0xbb/0xcf
[    3.325562]  [<7961ba11>] cirrus_fbdev_init+0x6d/0x7c
[    3.326005]  [<7961b314>] cirrus_modeset_init+0x13f/0x188
[    3.326473]  [<7961a686>] cirrus_driver_load+0x89/0xd4
[    3.326922]  [<794f012f>] drm_dev_register+0x67/0xc9
[    3.327355]  [<794f1aa6>] drm_get_pci_dev+0xd7/0x18a
[    3.327789]  [<79d01f3c>] ? mutex_unlock+0x8/0xa
[    3.328188]  [<7961b40b>] cirrus_pci_probe+0x7d/0x89
[    3.328630]  [<793f03a1>] pci_device_probe+0x44/0x85
[    3.329064]  [<791234fd>] ? sysfs_create_link+0x27/0x2f
[    3.329514]  [<796cf0f4>] driver_probe_device+0x88/0x17a
[    3.329981]  [<793f0222>] ? pci_match_device+0x97/0x9d
[    3.330441]  [<796cf259>] __driver_attach+0x47/0x63
[    3.330872]  [<796cdf74>] bus_for_each_dev+0x55/0x5f
[    3.331300]  [<796cf02d>] driver_attach+0x17/0x19
[    3.331710]  [<796cf212>] ? __device_attach+0x2c/0x2c
[    3.332146]  [<796ce566>] bus_add_driver+0xd1/0x198
[    3.332563]  [<796cf807>] driver_register+0x7a/0xae
[    3.332989]  [<793f027b>] __pci_register_driver+0x2d/0x30
[    3.333455]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.333876]  [<794f1bb5>] drm_pci_init+0x5c/0xd3
[    3.334276]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.334695]  [<7a2f95c4>] cirrus_init+0x1b/0x23
[    3.335086]  [<7a2cca6c>] do_one_initcall+0x82/0x10b
[    3.335511]  [<793bf7e3>] ? strlen+0xd/0x17
[    3.335884]  [<7a2cc430>] ? repair_env_string+0x12/0x51
[    3.336331]  [<79066f76>] ? parse_args+0x168/0x224
[    3.336751]  [<7a2ccc43>] kernel_init_freeable+0x14e/0x1e5
[    3.337221]  [<7a2cc41e>] ? do_early_param+0x78/0x78
[    3.337656]  [<79ce1ad4>] kernel_init+0xb/0xc6
[    3.338040]  [<79d03b77>] ret_from_kernel_thread+0x1b/0x28
[    3.338515]  [<79ce1ac9>] ? rest_init+0x6d/0x6d
[    3.338919] ---[ end trace b419620760c3adcb ]---
[    3.339323] ------------[ cut here ]------------
[    3.339732] WARNING: CPU: 1 PID: 1 at drivers/gpu/drm/drm_modes.c:119 dr=
m_mode_probed_add+0x23/0x34()
[    3.340723] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W    3.14.0-=
rc7-00703-gac96a27 #103
[    3.341479] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.341978]  00000000 00000000 7803fbe8 79cea3b4 00000000 7803fc18 79055=
a84 7a04f050
[    3.342747]  00000001 00000001 7a0c8f62 00000077 794f80e6 794f80e6 86a03=
c00 869e3780
[    3.343510]  00000400 7803fc28 79055b39 00000009 00000000 7803fc38 794f8=
0e6 79dc7148
[    3.344280] Call Trace:
[    3.344500]  [<79cea3b4>] dump_stack+0x48/0x60
[    3.344894]  [<79055a84>] warn_slowpath_common+0x6f/0x86
[    3.345351]  [<794f80e6>] ? drm_mode_probed_add+0x23/0x34
[    3.345828]  [<794f80e6>] ? drm_mode_probed_add+0x23/0x34
[    3.346290]  [<79055b39>] warn_slowpath_null+0x1d/0x1f
[    3.346741]  [<794f80e6>] drm_mode_probed_add+0x23/0x34
[    3.347189]  [<794fb951>] drm_add_modes_noedid+0x63/0x7f
[    3.347656]  [<7961a8e9>] cirrus_vga_get_modes+0x16/0x2f
[    3.348115]  [<794e6994>] drm_helper_probe_single_connector_modes+0x12e/=
0x2bf
[    3.348740]  [<794e74f0>] drm_fb_helper_probe_connector_modes+0x3b/0x49
[    3.349315]  [<794e8c4d>] drm_fb_helper_initial_config+0x16f/0x3d2
[    3.349854]  [<79055a93>] ? warn_slowpath_common+0x7e/0x86
[    3.350343]  [<794e57cf>] ? drm_helper_crtc_in_use+0x22/0x5b
[    3.350840]  [<794e57cf>] ? drm_helper_crtc_in_use+0x22/0x5b
[    3.351328]  [<794e58c3>] ? drm_helper_disable_unused_functions+0xbb/0xcf
[    3.351919]  [<7961ba11>] cirrus_fbdev_init+0x6d/0x7c
[    3.352358]  [<7961b314>] cirrus_modeset_init+0x13f/0x188
[    3.352832]  [<7961a686>] cirrus_driver_load+0x89/0xd4
[    3.353281]  [<794f012f>] drm_dev_register+0x67/0xc9
[    3.353719]  [<794f1aa6>] drm_get_pci_dev+0xd7/0x18a
[    3.354154]  [<79d01f3c>] ? mutex_unlock+0x8/0xa
[    3.354556]  [<7961b40b>] cirrus_pci_probe+0x7d/0x89
[    3.354992]  [<793f03a1>] pci_device_probe+0x44/0x85
[    3.355425]  [<791234fd>] ? sysfs_create_link+0x27/0x2f
[    3.355886]  [<796cf0f4>] driver_probe_device+0x88/0x17a
[    3.356343]  [<793f0222>] ? pci_match_device+0x97/0x9d
[    3.356796]  [<796cf259>] __driver_attach+0x47/0x63
[    3.357217]  [<796cdf74>] bus_for_each_dev+0x55/0x5f
[    3.357657]  [<796cf02d>] driver_attach+0x17/0x19
[    3.358067]  [<796cf212>] ? __device_attach+0x2c/0x2c
[    3.358505]  [<796ce566>] bus_add_driver+0xd1/0x198
[    3.358935]  [<796cf807>] driver_register+0x7a/0xae
[    3.359358]  [<793f027b>] __pci_register_driver+0x2d/0x30
[    3.359835]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.360267]  [<794f1bb5>] drm_pci_init+0x5c/0xd3
[    3.360671]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.361091]  [<7a2f95c4>] cirrus_init+0x1b/0x23
[    3.361486]  [<7a2cca6c>] do_one_initcall+0x82/0x10b
[    3.361923]  [<793bf7e3>] ? strlen+0xd/0x17
[    3.362286]  [<7a2cc430>] ? repair_env_string+0x12/0x51
[    3.362741]  [<79066f76>] ? parse_args+0x168/0x224
[    3.363160]  [<7a2ccc43>] kernel_init_freeable+0x14e/0x1e5
[    3.363639]  [<7a2cc41e>] ? do_early_param+0x78/0x78
[    3.364069]  [<79ce1ad4>] kernel_init+0xb/0xc6
[    3.364453]  [<79d03b77>] ret_from_kernel_thread+0x1b/0x28
[    3.364934]  [<79ce1ac9>] ? rest_init+0x6d/0x6d
[    3.365328] ---[ end trace b419620760c3adcc ]---
[    3.365739] ------------[ cut here ]------------
[    3.366141] WARNING: CPU: 1 PID: 1 at drivers/gpu/drm/drm_modes.c:1030 d=
rm_mode_connector_list_update+0x25/0x9a()
[    3.367200] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W    3.14.0-=
rc7-00703-gac96a27 #103
[    3.367949] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.368442]  00000000 00000000 7803fc08 79cea3b4 00000000 7803fc38 79055=
a84 7a04f050
[    3.369215]  00000001 00000001 7a0c8f62 00000406 794f8a87 794f8a87 86a03=
c00 86a03c00
[    3.369992]  869f3800 7803fc48 79055b39 00000009 00000000 7803fc68 794f8=
a87 86a03c2c
[    3.370776] Call Trace:
[    3.370995]  [<79cea3b4>] dump_stack+0x48/0x60
[    3.371382]  [<79055a84>] warn_slowpath_common+0x6f/0x86
[    3.371850]  [<794f8a87>] ? drm_mode_connector_list_update+0x25/0x9a
[    3.372403]  [<794f8a87>] ? drm_mode_connector_list_update+0x25/0x9a
[    3.372956]  [<79055b39>] warn_slowpath_null+0x1d/0x1f
[    3.373402]  [<794f8a87>] drm_mode_connector_list_update+0x25/0x9a
[    3.373943]  [<794e69c8>] drm_helper_probe_single_connector_modes+0x162/=
0x2bf
[    3.374558]  [<794e74f0>] drm_fb_helper_probe_connector_modes+0x3b/0x49
[    3.375135]  [<794e8c4d>] drm_fb_helper_initial_config+0x16f/0x3d2
[    3.375674]  [<79055a93>] ? warn_slowpath_common+0x7e/0x86
[    3.376145]  [<794e57cf>] ? drm_helper_crtc_in_use+0x22/0x5b
[    3.376638]  [<794e57cf>] ? drm_helper_crtc_in_use+0x22/0x5b
[    3.377132]  [<794e58c3>] ? drm_helper_disable_unused_functions+0xbb/0xcf
[    3.377724]  [<7961ba11>] cirrus_fbdev_init+0x6d/0x7c
[    3.378161]  [<7961b314>] cirrus_modeset_init+0x13f/0x188
[    3.378644]  [<7961a686>] cirrus_driver_load+0x89/0xd4
[    3.379090]  [<794f012f>] drm_dev_register+0x67/0xc9
[    3.379519]  [<794f1aa6>] drm_get_pci_dev+0xd7/0x18a
[    3.379955]  [<79d01f3c>] ? mutex_unlock+0x8/0xa
[    3.380370]  [<7961b40b>] cirrus_pci_probe+0x7d/0x89
[    3.380811]  [<793f03a1>] pci_device_probe+0x44/0x85
[    3.381244]  [<791234fd>] ? sysfs_create_link+0x27/0x2f
[    3.381706]  [<796cf0f4>] driver_probe_device+0x88/0x17a
[    3.382166]  [<793f0222>] ? pci_match_device+0x97/0x9d
[    3.382611]  [<796cf259>] __driver_attach+0x47/0x63
[    3.383040]  [<796cdf74>] bus_for_each_dev+0x55/0x5f
[    3.383475]  [<796cf02d>] driver_attach+0x17/0x19
[    3.383889]  [<796cf212>] ? __device_attach+0x2c/0x2c
[    3.384329]  [<796ce566>] bus_add_driver+0xd1/0x198
[    3.384759]  [<796cf807>] driver_register+0x7a/0xae
[    3.385184]  [<793f027b>] __pci_register_driver+0x2d/0x30
[    3.385659]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.386076]  [<794f1bb5>] drm_pci_init+0x5c/0xd3
[    3.386477]  [<7a2f95a9>] ? mgag200_init+0x23/0x23
[    3.386900]  [<7a2f95c4>] cirrus_init+0x1b/0x23
[    3.387298]  [<7a2cca6c>] do_one_initcall+0x82/0x10b
[    3.387737]  [<793bf7e3>] ? strlen+0xd/0x17
[    3.388103]  [<7a2cc430>] ? repair_env_string+0x12/0x51
[    3.388558]  [<79066f76>] ? parse_args+0x168/0x224
[    3.388982]  [<7a2ccc43>] kernel_init_freeable+0x14e/0x1e5
[    3.389459]  [<7a2cc41e>] ? do_early_param+0x78/0x78
[    3.389902]  [<79ce1ad4>] kernel_init+0xb/0xc6
[    3.390307]  [<79d03b77>] ret_from_kernel_thread+0x1b/0x28
[    3.390789]  [<79ce1ac9>] ? rest_init+0x6d/0x6d
[    3.391183] ---[ end trace b419620760c3adcd ]---
[    3.392212] [drm] fb mappable at 0xFC000000
[    3.392584] [drm] vram aper at 0xFC000000
[    3.392942] [drm] size 4194304
[    3.393213] [drm] fb depth is 24
[    3.393500] [drm]    pitch is 3072
[    3.393806] cirrusdrmfb: enable CONFIG_FB_LITTLE_ENDIAN to support this =
framebuffer
[    3.394465] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on =
minor 0
[    3.396559] brd: module loaded
[    3.397565] loop: module loaded
[    3.397859] HP CISS Driver (v 3.6.26)
[    3.398360] MM: desc_per_page =3D 128
[    3.399244] nbd: registered device at major 43
[    3.400858] rbd: loaded
[    3.401088] mtip32xx Version 1.3.0
[    3.401465] blk-mq: CPU -> queue map
[    3.401793]   CPU 0 -> Queue 0
[    3.402063]   CPU 1 -> Queue 0
[    3.402590]  nullb0: unknown partition table
[    3.403127] blk-mq: CPU -> queue map
[    3.403450]   CPU 0 -> Queue 0
[    3.403727]   CPU 1 -> Queue 0
[    3.404168]  nullb1: unknown partition table
[    3.404644] null: module loaded
[    3.404952] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    3.405547] dummy-irq: no IRQ given.  Use irq=3DN
[    3.405954] lkdtm: No crash points registered, enable through debugfs
[    3.406535] Phantom Linux Driver, version n0.9.8, init OK
[    3.407059] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    3.407735] c2port c2port0: C2 port uc added
[    3.408113] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    3.408838] Guest personality initialized and is inactive
[    3.409329] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D56)
[    3.409906] Initialized host personality
[    3.410454] Uniform Multi-Platform E-IDE driver
[    3.411059] PCI_IDE 0000:00:01.1: no of_node; not parsing pinctrl DT
[    3.411955] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[    3.412791] ide-gd driver 1.18
[    3.413064] ide-cd driver 5.00
[    3.413597] Loading iSCSI transport class v2.0-870.
[    3.414209] hp_sw: device handler registered
[    3.414587] emc: device handler registered
[    3.414949] alua: device handler registered
[    3.415315] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    3.416257] ata_generic 0000:00:01.1: no of_node; not parsing pinctrl DT
[    3.417186] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    3.418168] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    3.418749] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    3.419407] device id =3D 2440
[    3.419669] device id =3D 2480
[    3.419925] device id =3D 24c0
[    3.420199] device id =3D 24d0
[    3.420456] device id =3D 25a1
[    3.420718] device id =3D 2670
[    3.421020] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel =
Networks.
[    3.421679] pmc551: not detected
[    3.460574] No valid DiskOnChip devices found
[    3.460992] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.461803] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.462600] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.463408] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.464215] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.465021] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.465838] nand: device found, Manufacturer ID: 0x98, Chip ID: 0x39
[    3.466391] nand: Toshiba NAND 128MiB 1,8V 8-bit
[    3.466800] nand: 128MiB, SLC, page size: 512, OOB size: 16
[    3.467299] flash size: 128 MiB
[    3.467580] page size: 512 bytes
[    3.467870] OOB area size: 16 bytes
[    3.468177] sector size: 16 KiB
[    3.468453] pages number: 262144
[    3.468749] pages per sector: 32
[    3.469035] bus width: 8
[    3.469260] bits in sector size: 14
[    3.469566] bits in page size: 9
[    3.469857] bits in OOB size: 4
[    3.470148] flash size with OOB: 135168 KiB
[    3.470513] page address bytes: 4
[    3.470810] sector address bytes: 3
[    3.471116] options: 0x42
[    3.472606] Scanning device for bad blocks
[    3.484545] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    3.485095] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    3.486116] HSI/SSI char device loaded
[    3.486579] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S.=
 Miller (davem@redhat.com)
[    3.487743] arcnet loaded.
[    3.487993] arcnet: RFC1201 "standard" (`a') encapsulation support loade=
d.
[    3.488580] arcnet: RFC1051 "simple standard" (`s') encapsulation suppor=
t loaded.
[    3.489230] arcnet: cap mode (`c') encapsulation support loaded.
[    3.489763] arcnet: COM90xx IO-mapped mode support (by David Woodhouse e=
t el.)
[    3.490404] E-mail me if you actually test this driver, please!
[    3.490924]  arc%d: No autoprobe for IO mapped cards; you must specify t=
he base address!
[    3.491630] arcnet: RIM I (entirely mem-mapped) support
[    3.492085] E-mail me if you actually test the RIM I driver, please!
[    3.492640] Given: node 00h, shmem 0h, irq 0
[    3.493013] No autoprobe for RIM I; you must specify the shmem and irq!
[    3.493578] arcnet: COM20020 PCI support
[    3.493960] vcan: Virtual CAN interface driver
[    3.494421] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.19 (Decemb=
er 19, 2013)
[    3.495257] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ether=
net Driver bnx2x 1.78.17-0 (2013/04/11)
[    3.496302] enic: Cisco VIC Ethernet NIC Driver, ver 2.1.1.50
[    3.496846] vxge: Copyright(c) 2002-2010 Exar Corp.
[    3.497275] vxge: Driver version: 2.5.3.22640-k
[    3.497685] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-=
NAPI
[    3.498290] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    3.498810] e1000 0000:00:03.0: no of_node; not parsing pinctrl DT
[    3.865139] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56
[    3.865778] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
[    3.866380] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    3.866893] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    3.867435] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.=
5-k
[    3.868040] igb: Copyright (c) 2007-2013 Intel Corporation.
[    3.868535] igbvf: Intel(R) Gigabit Virtual Function Network Driver - ve=
rsion 2.0.2-k
[    3.869216] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[    3.869745] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - vers=
ion 3.19.1-k
[    3.870433] ixgbe: Copyright (c) 1999-2013 Intel Corporation.
[    3.870958] ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function Ne=
twork Driver - version 2.12.1-k
[    3.871771] ixgbevf: Copyright (c) 2009 - 2012 Intel Corporation.
[    3.872314] i40e: Intel(R) Ethernet Connection XL710 Network Driver - ve=
rsion 0.3.30-k
[    3.873001] i40e: Copyright (c) 2013 - 2014 Intel Corporation.
[    3.873528] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2=
-NAPI
[    3.874149] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    3.874650] i40evf: Intel(R) XL710 X710 Virtual Function Network Driver =
- version 0.9.11
[    3.875346] Copyright (c) 2013 Intel Corporation.
[    3.875819] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[    3.876523] tehuti: Tehuti Networks(R) Network Driver, 7.29.3
[    3.877031] tehuti: Options: hw_csum=20
[    3.877363] tlan: ThunderLAN driver v1.17
[    3.877732] tlan: 0 devices installed, PCI: 0  EISA: 0
[    3.878225] YAM driver version 0.8 by F1OAT/F6FBB
[    3.878956] AX.25: bpqether driver version 004
[    3.879349] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    3.879349] baycom_ser_fdx: version 0.10
[    3.880548] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[    3.881061] hdlcdrv: version 0.8
[    3.881346] baycom_epp: (C) 1998-2000 Thomas Sailer, HB9JNX/AE4WA
[    3.881346] baycom_epp: version 0.7
[    3.882764] PPP generic driver version 2.4.2
[    3.883174] PPP BSD Compression module registered
[    3.883586] PPP Deflate Compression module registered
[    3.884032] NET: Registered protocol family 24
[    3.884486] ieee802154fakelb ieee802154fakelb: no of_node; not parsing p=
inctrl DT
[    3.885267] ieee802154fakelb ieee802154fakelb: added ieee802154 hardware
[    3.885882] VMware vmxnet3 virtual NIC driver - version 1.2.0.0-k-NAPI
[    3.886460] I2O subsystem v1.325
[    3.886758] i2o: max drivers =3D 8
[    3.887159] I2O Configuration OSM v1.323
[    3.887531] I2O Bus Adapter OSM v1.317
[    3.887879] I2O Block Device OSM v1.325
[    3.888377] I2O SCSI Peripheral OSM v1.316
[    3.888764] I2O ProcFS OSM v1.316
[    3.889071] Fusion MPT base driver 3.04.20
[    3.889432] Copyright (c) 1999-2008 LSI Corporation
[    3.889868] Fusion MPT SPI Host driver 3.04.20
[    3.890294] Fusion MPT FC Host driver 3.04.20
[    3.890707] Fusion MPT SAS Host driver 3.04.20
[    3.891121] Fusion MPT misc device (ioctl) driver 3.04.20
[    3.891599] mptctl: Registered with Fusion MPT base driver
[    3.892080] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[    3.892626] VFIO - User Level meta-driver version: 0.3
[    3.893180] i8042 kbd 00:01: no of_node; not parsing pinctrl DT
[    3.893728] i8042 aux 00:02: no of_node; not parsing pinctrl DT
[    3.894251] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    3.895026] i8042 i8042: no of_node; not parsing pinctrl DT
[    3.896054] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.896491] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.940125] mousedev: PS/2 mouse device common for all mice
[    3.940682] atkbd serio0: no of_node; not parsing pinctrl DT
[    3.941414] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    3.942186] atkbd serio1: no of_node; not parsing pinctrl DT
[    3.943101] walkera0701: parport 0 does not exist
[    3.943803] i2c /dev entries driver
[    3.944224] piix4_smbus 0000:00:01.3: no of_node; not parsing pinctrl DT
[    3.944852] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[    3.960139] eeprom 0-0050: no of_node; not parsing pinctrl DT
[    3.980199] eeprom 0-0051: no of_node; not parsing pinctrl DT
[    4.000228] eeprom 0-0052: no of_node; not parsing pinctrl DT
[    4.020192] eeprom 0-0053: no of_node; not parsing pinctrl DT
[    4.040221] eeprom 0-0054: no of_node; not parsing pinctrl DT
[    4.060195] eeprom 0-0055: no of_node; not parsing pinctrl DT
[    4.080223] eeprom 0-0056: no of_node; not parsing pinctrl DT
[    4.100195] eeprom 0-0057: no of_node; not parsing pinctrl DT
[    4.180355] i2c-parport: adapter type unspecified
[    4.181362] i2c-parport-light: adapter type unspecified
[    4.182455] scx200_i2c: no SCx200 gpio pins available
[    4.183627] pps pps0: new PPS source ktimer
[    4.184470] pps pps0: ktimer PPS source registered
[    4.185473] Driver for 1-wire Dallas network protocol.
[    4.186586] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    4.188408] power_supply test_ac: uevent
[    4.188936] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    4.189430] power_supply test_ac: prop ONLINE=3D1
[    4.189843] power_supply test_ac: power_supply_changed
[    4.190313] power_supply test_ac: power_supply_changed_work
[    4.190803] power_supply test_ac: power_supply_update_gen_leds 1
[    4.191318] power_supply test_ac: uevent
[    4.191668] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    4.192158] power_supply test_ac: prop ONLINE=3D1
[    4.192600] power_supply test_battery: uevent
[    4.192991] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    4.193550] power_supply test_battery: prop STATUS=3DDischarging
[    4.194065] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    4.194560] power_supply test_battery: prop HEALTH=3DGood
[    4.195026] power_supply test_battery: prop PRESENT=3D1
[    4.195468] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    4.195972] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    4.196505] power_supply test_battery: prop CHARGE_FULL=3D100
[    4.196995] power_supply test_battery: prop CHARGE_NOW=3D50
[    4.197462] power_supply test_battery: prop CAPACITY=3D50
[    4.197921] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    4.198449] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    4.198999] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    4.199526] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    4.200093] power_supply test_battery: prop MANUFACTURER=3DLinux
[    4.200606] power_supply test_battery: prop SERIAL_NUMBER=3D3.14.0-rc7-0=
0703-gac96a27
[    4.201274] power_supply test_battery: prop TEMP=3D26
[    4.201704] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    4.202268] power_supply test_battery: power_supply_changed
[    4.202770] power_supply test_battery: power_supply_changed_work
[    4.203289] power_supply test_battery: power_supply_update_bat_leds 2
[    4.203856] power_supply test_battery: uevent
[    4.204238] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    4.204810] power_supply test_battery: prop STATUS=3DDischarging
[    4.205316] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    4.205818] power_supply test_battery: prop HEALTH=3DGood
[    4.206272] power_supply test_battery: prop PRESENT=3D1
[    4.206716] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    4.207214] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    4.207754] power_supply test_battery: prop CHARGE_FULL=3D100
[    4.208234] power_supply test_battery: prop CHARGE_NOW=3D50
[    4.208713] power_supply test_battery: prop CAPACITY=3D50
[    4.209165] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    4.209699] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    4.210282] power_supply test_usb: uevent
[    4.210646] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    4.211151] power_supply test_usb: prop ONLINE=3D1
[    4.211559] power_supply test_usb: power_supply_changed
[    4.212187] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    4.212719] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    4.213259] power_supply test_battery: prop MANUFACTURER=3DLinux
[    4.213768] power_supply test_battery: prop SERIAL_NUMBER=3D3.14.0-rc7-0=
0703-gac96a27
[    4.214427] power_supply test_battery: prop TEMP=3D26
[    4.214863] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    4.215362] power_supply test_usb: power_supply_changed_work
[    4.215862] power_supply test_usb: power_supply_update_gen_leds 1
[    4.216395] power_supply test_usb: uevent
[    4.216752] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    4.217246] power_supply test_usb: prop ONLINE=3D1
[    7.040066] i2c i2c-0: detect fail: address match, 0x2c
[    7.080060] i2c i2c-0: detect fail: address match, 0x2d
[    7.120061] i2c i2c-0: detect fail: address match, 0x2e
[    7.160061] i2c i2c-0: detect fail: address match, 0x2f
[    7.480064] applesmc: supported laptop not found!
[    7.480499] applesmc: driver init failed (ret=3D-19)!
[    8.440151] i5k_amb i5k_amb.0: no of_node; not parsing pinctrl DT
[   28.500174] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[   28.500915] acquirewdt acquirewdt: no of_node; not parsing pinctrl DT
[   28.501496] acquirewdt: I/O address 0x0043 already in use
[   28.501979] acquirewdt: probe of acquirewdt failed with error -5
[   28.502498] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[   28.503212] advantechwdt advantechwdt: no of_node; not parsing pinctrl DT
[   28.503901] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D1)
[   28.504437] alim7101_wdt: Steve Hill <steve@navaho.co.uk>
[   28.504954] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[   28.505554] geodewdt geodewdt: no of_node; not parsing pinctrl DT
[   28.506093] geodewdt: No timers were available
[   28.506493] sc520_wdt: cannot register miscdev on minor=3D130 (err=3D-16)
[   28.507105] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[   28.507767] ib700wdt ib700wdt: no of_node; not parsing pinctrl DT
[   28.508311] ib700wdt: START method I/O 443 is not available
[   28.508814] ib700wdt: probe of ib700wdt failed with error -5
[   28.509302] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[   28.509982] wafer5823wdt: I/O address 0x0443 already in use
[   28.510492] i6300ESB timer 0000:00:0a.0: no of_node; not parsing pinctrl=
 DT
[   28.511101] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[   28.511722] i6300esb: cannot register miscdev on minor=3D130 (err=3D-16)
[   28.512322] i6300ESB timer: probe of 0000:00:0a.0 failed with error -16
[   28.512965] sc1200wdt: build 20020303
[   28.513305] sc1200wdt: io parameter must be specified
[   28.513759] pc87413_wdt: Version 1.1 at io 0x2E
[   28.514156] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[   28.514728] sbc60xxwdt: I/O address 0x0443 already in use
[   28.515220] sbc8360: failed to register misc device
[   28.515650] sbc7240_wdt: I/O address 0x0443 already in use
[   28.516129] cpu5wdt: misc_register failed
[   28.516514] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[   28.518224] smsc37b787_wdt: Unable to register miscdev on minor 130
[   28.518793] w83877f_wdt: I/O address 0x0443 already in use
[   28.519272] machzwd: MachZ ZF-Logic Watchdog driver initializing
[   28.519802] machzwd: no ZF-Logic found
[   28.520145] sbc_epx_c3: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[   28.520755] sdhci: Secure Digital Host Controller Interface driver
[   28.521289] sdhci: Copyright(c) Pierre Ossman
[   28.521762] sdhci-pltfm: SDHCI platform and OF driver helper
[   28.522600] leds_ss4200: no LED devices found
[   28.523315] alg: skcipher: encryption failed on test 1 for ecb-aes-ccp: =
ret=3D19
[   28.524825] alg: hash: digest failed on test 1 for cmac-aes-ccp: ret=3D19
[   28.525605] alg: hash: digest failed on test 1 for sha1-ccp: ret=3D19
[   28.526264] alg: hash: digest failed on test 1 for hmac-sha1-ccp: ret=3D=
19
[   28.526968] alg: hash: digest failed on test 1 for sha224-ccp: ret=3D19
[   28.527701] alg: hash: digest failed on test 1 for hmac-sha224-ccp: ret=
=3D19
[   28.528454] alg: hash: digest failed on test 1 for sha256-ccp: ret=3D19
[   28.529204] alg: hash: digest failed on test 1 for hmac-sha256-ccp: ret=
=3D19
[   28.529896] Driver for HIFN 795x crypto accelerator chip has been succes=
sfully registered.
[   28.530684] hidraw: raw HID events driver (C) Jiri Kosina
[   28.531404] panel: driver version 0.9.5 not yet registered
[   28.531901] rts5208: Initializing Realtek PCIE storage driver...
[   28.532723] asus_wmi: Asus Management GUID not found
[   28.533210] asus-nb-wmi asus-nb-wmi: no of_node; not parsing pinctrl DT
[   28.533811] asus_wmi: Management GUID not found
[   28.534283] eeepc-wmi eeepc-wmi: no of_node; not parsing pinctrl DT
[   28.534846] asus_wmi: Management GUID not found
[   28.535295] msi_laptop: Brightness ignored, must be controlled by ACPI v=
ideo driver
[   28.536000] msi-laptop-pf msi-laptop-pf: no of_node; not parsing pinctrl=
 DT
[   28.536670] compal_laptop: Motherboard not recognized (You could try the=
 module's force-parameter)
[   28.537441] dell_wmi_aio: No known WMI GUID found
[   28.537858] acerhdf: Acer Aspire One Fan driver, v.0.5.26
[   28.538334] acerhdf: unknown (unsupported) BIOS version Bochs/Bochs/Boch=
s, please report, aborting!
[   28.539121] Initializing HPQ6001 module
[   28.539501] hdaps: supported laptop not found!
[   28.539899] hdaps: driver init failed (ret=3D-19)!
[   28.540427] fujitsu-laptop fujitsu-laptop: no of_node; not parsing pinct=
rl DT
[   28.541080] FUJ02B1: call_fext_func: FUNC interface is not present
[   28.541628] fujitsu_laptop: driver 0.6.0 successfully loaded
[   28.542128] msi_wmi: This machine doesn't have neither MSI-hotkeys nor b=
acklight through WMI
[   28.542885] intel_oaktrail: Platform not recognized (You could try the m=
odule's force-parameter) fake-fmc-carrier: mezzanine 0
[   28.544062]       Manufacturer: fake-vendor
[   28.544430]       Product name: fake-design-for-testing
[   28.544911] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   28.545540] fmc_trivial fake-design-for-testing-f001: no of_node; not pa=
rsing pinctrl DT
[   28.546248] fmc_trivial: probe of fake-design-for-testing-f001 failed wi=
th error -95
[   28.546930] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   28.547538] fmc_chardev fake-design-for-testing-f001: no of_node; not pa=
rsing pinctrl DT
[   28.548263] fmc_chardev fake-design-for-testing-f001: Created misc devic=
e "fake-design-for-testing-f001"
[   28.549152] Audio Excel DSP 16 init driver Copyright (C) Riccardo Facche=
tti 1995-98
[   28.549815] aedsp16: I/O, IRQ and DMA are mandatory
[   28.550254] MediaTrix audio driver Copyright (C) by Hannu Savolainen 199=
3-1996
[   28.550882] I/O, IRQ, DMA and type are mandatory
[   28.551290] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen=
 1993-1996
[   28.551948] ad1848: No ISAPnP cards found, trying standard ones...
[   28.552485] sb: Init: Starting Probe...
[   28.552836] sb: Init: Done
[   28.553086] Cyrix Kahlua VSA1 XpressAudio support (c) Copyright 2003 Red=
 Hat Inc
[   28.553747] uart6850: irq and io must be set.
[   28.554129] YM3812 and OPL-3 driver Copyright (C) by Hannu Savolainen, R=
ob Hooft 1993-1996
[   28.554846] MIDI Loopback device driver
[   28.555319] snd_aloop snd_aloop.0: no of_node; not parsing pinctrl DT
[   28.556348] snd_mtpav snd_mtpav: no of_node; not parsing pinctrl DT
[   28.557340] unable to register OSS rawmidi device 1:0
[   28.557914] Motu MidiTimePiece on parallel port irq: 7 ioport: 0x378
[   28.558559] snd-soc-dummy snd-soc-dummy: no of_node; not parsing pinctrl=
 DT
[   28.559282] Netfilter messages via NETLINK v0.30.
[   28.559724] nf_conntrack version 0.5.0 (3672 buckets, 14688 max)
[   28.560396] ctnetlink v0.93: registering with nfnetlink.
[   28.560907] nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>
[   28.561479] nf_tables_compat: (c) 2012 Pablo Neira Ayuso <pablo@netfilte=
r.org>
[   28.562127] ip_set: protocol 6
[   28.562419] IPVS: Registered protocols (UDP)
[   28.562859] IPVS: Connection hash table configured (size=3D4096, memory=
=3D32Kbytes)
[   28.563491] IPVS: Each connection entry needs 196 bytes at least
[   28.564023] IPVS: Creating netns size=3D816 id=3D0
[   28.564889] IPVS: ipvs loaded.
[   28.565189] IPVS: [lc] scheduler registered.
[   28.565565] IPVS: [wlc] scheduler registered.
[   28.565945] IPVS: [lblcr] scheduler registered.
[   28.566345] IPVS: [sh] scheduler registered.
[   28.566724] IPVS: [sed] scheduler registered.
[   28.567100] IPVS: [nq] scheduler registered.
[   28.567472] ipip: IPv4 over IPv4 tunneling driver
[   28.567991] gre: GRE over IPv4 demultiplexor driver
[   28.568423] ip_gre: GRE over IPv4 tunneling driver
[   28.569325] ip_tables: (C) 2000-2006 Netfilter Core Team
[   28.569836] TCP: bic registered
[   28.570132] TCP: cubic registered
[   28.570424] TCP: highspeed registered
[   28.570751] TCP: htcp registered
[   28.571034] TCP: veno registered
[   28.571316] TCP: scalable registered
[   28.571634] NET: Registered protocol family 17
[   28.600425] NET: Registered protocol family 6
[   28.600847] NET: Registered protocol family 3
[   28.601235] can: controller area network core (rev 20120528 abi 9)
[   28.601831] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
[   28.602413] NET: Registered protocol family 29
[   28.603001] NET: Registered protocol family 33
[   28.603393] Key type rxrpc registered
[   28.603720] Key type rxrpc_s registered
[   28.604070] l2tp_core: L2TP core driver, V2.0
[   28.604452] l2tp_ip: L2TP IP encapsulation support (L2TPv3)
[   28.604996] l2tp_netlink: L2TP netlink interface
[   28.605403] l2tp_eth: L2TP ethernet pseudowire support (L2TPv3)
[   28.605936] l2tp_debugfs: L2TP debugfs support
[   28.606329] 8021q: 802.1Q VLAN Support v1.8
[   28.607233] DCCP: Activated CCID 2 (TCP-like)
[   28.607667] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
[   28.608428] sctp: Hash tables configured (established 8192 bind 8192)
[   28.609116] NET: Registered protocol family 37
[   28.609585] NET: Registered protocol family 36
[   28.609984] Key type dns_resolver registered
[   28.610398] Key type ceph registered
[   28.610868] libceph: loaded (mon/osd proto 15/24)
[   28.611476] batman_adv: B.A.T.M.A.N. advanced 2014.1.0 (compatibility ve=
rsion 15) loaded
[   28.612193] openvswitch: Open vSwitch switching datapath
[   28.613473]=20
[   28.613473] printing PIC contents
[   28.613906] ... PIC  IMR: ffff
[   28.614180] ... PIC  IRR: 1013
[   28.614456] ... PIC  ISR: 0000
[   28.614735] ... PIC ELCR: 0c00
[   28.615012] printing local APIC contents on CPU#0/0:
[   28.615445] ... APIC ID:      00000000 (0)
[   28.615809] ... APIC VERSION: 00050014
[   28.616137] ... APIC TASKPRI: 00000000 (00)
[   28.616560] ... APIC PROCPRI: 00000000
[   28.616891] ... APIC LDR: 01000000
[   28.617193] ... APIC DFR: ffffffff
[   28.617494] ... APIC SPIV: 000001ff
[   28.617802] ... APIC ISR field:
[   28.618082] 000000000000000000000000000000000000000000000000000000000000=
0000
[   28.618816] ... APIC TMR field:
[   28.619093] 000000000200000000000000000000000000000000000000000000000000=
0000
[   28.619816] ... APIC IRR field:
[   28.620099] 000000000000000000000000000000000000000000000000000000000000=
8000
[   28.620365] ... APIC ESR: 00000000
[   28.620365] ... APIC ICR: 000008fb
[   28.620365] ... APIC ICR2: 02000000
[   28.620365] ... APIC LVTT: 000000ef
[   28.620365] ... APIC LVTPC: 00010000
[   28.620365] ... APIC LVT0: 00010700
[   28.620365] ... APIC LVT1: 00000400
[   28.620365] ... APIC LVTERR: 000000fe
[   28.620365] ... APIC TMICT: 00092f8a
[   28.620365] ... APIC TMCCT: 00000000
[   28.620365] ... APIC TDCR: 00000003
[   28.620365]=20
[   28.624436] number of MP IRQ sources: 15.
[   28.624795] number of IO-APIC #0 registers: 24.
[   28.625188] testing the IO APIC.......................
[   28.625653] IO APIC #0......
[   28.625910] .... register #00: 00000000
[   28.626243] .......    : physical APIC id: 00
[   28.626629] .......    : Delivery Type: 0
[   28.626978] .......    : LTS          : 0
[   28.627327] .... register #01: 00170011
[   28.627666] .......     : max redirection entries: 17
[   28.628101] .......     : PRQ implemented: 0
[   28.628471] .......     : IO APIC version: 11
[   28.628865] .... register #02: 00000000
[   28.629198] .......     : arbitration: 00
[   28.629553] .... IRQ redirection table:
[   28.629895] 1    0    0   0   0    0    0    00
[   28.630315] 0    0    0   0   0    1    1    31
[   28.630726] 0    0    0   0   0    1    1    30
[   28.631128] 0    0    0   0   0    1    1    33
[   28.631532] 1    0    0   0   0    1    1    34
[   28.631936] 1    1    0   0   0    1    1    35
[   28.632341] 0    0    0   0   0    1    1    36
[   28.632750] 0    0    0   0   0    1    1    37
[   28.633155] 0    0    0   0   0    1    1    38
[   28.633561] 0    1    0   0   0    1    1    39
[   28.633966] 1    1    0   0   0    1    1    3A
[   28.634366] 1    1    0   0   0    1    1    3B
[   28.634772] 0    0    0   0   0    1    1    3C
[   28.635175] 0    0    0   0   0    1    1    3D
[   28.635583] 0    0    0   0   0    1    1    3E
[   28.635988] 0    0    0   0   0    1    1    3F
[   28.636391] 1    0    0   0   0    0    0    00
[   28.636796] 1    0    0   0   0    0    0    00
[   28.637197] 1    0    0   0   0    0    0    00
[   28.637606] 1    0    0   0   0    0    0    00
[   28.638009] 1    0    0   0   0    0    0    00
[   28.638413] 1    0    0   0   0    0    0    00
[   28.638826] 1    0    0   0   0    0    0    00
[   28.639227] 1    0    0   0   0    0    0    00
[   28.639622] IRQ to pin mappings:
[   28.639906] IRQ0 -> 0:2
[   28.640161] IRQ1 -> 0:1
[   28.640404] IRQ3 -> 0:3
[   28.640653] IRQ4 -> 0:4
[   28.640894] IRQ5 -> 0:5
[   28.641137] IRQ6 -> 0:6
[   28.641379] IRQ7 -> 0:7
[   28.641625] IRQ8 -> 0:8
[   28.641868] IRQ9 -> 0:9
[   28.642112] IRQ10 -> 0:10
[   28.642368] IRQ11 -> 0:11
[   28.642630] IRQ12 -> 0:12
[   28.642889] IRQ13 -> 0:13
[   28.643146] IRQ14 -> 0:14
[   28.643402] IRQ15 -> 0:15
[   28.643665] .................................... done.
[   28.644112] Using IPI No-Shortcut mode
[   28.644500] Loading compiled-in X.509 certificates
[   28.644930] Problem loading in-kernel X.509 certificate (-74)
[   28.645428] registered taskstats version 1
[   28.645796] kAFS: Red Hat AFS client v0.1 registering.
[   28.680047] kAFS: failed to register: -12
[   28.680936] bio: create slab <bio-1> at 1
[   28.681661] Btrfs loaded, assert=3Don
[   28.682340] Key type trusted registered
[   28.683069] Key type encrypted registered
[   28.683974] RIO: rio_register_scan for mport_id=3D-1
[   28.684402] regulator-dummy: disabling
[   28.684917] console [netcon0] enabled
[   28.685243] netconsole: network logging started
[   28.685665] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[   28.686422] ### dt-test ### No testcase data in device tree; not running=
 tests
[   28.687081] ALSA device list:
[   28.687348]   #0: Loopback 1
[   28.687617]   #1: MTPAV on parallel port at 0x378
[   28.688337] debug: unmapping init [mem 0x7a2cc000-0x7a385fff]
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
/etc/rc5.d/S99-rc.local: line 19: /proc/211/oom_score_adj: No such file or =
directory
sed: /lib/modules/3.14.0-rc7-00703-gac96a27/modules.dep: No such file or di=
rectory
xargs: modprobe: No such file or directory
run-parts: /etc/kernel-tests/01-modprobe exited with code 127
grep: /proc/cmdline: No such file or directory
grep: /proc/cmdline: No such file or directory
Trinity v1.4pre  Dave Jones <davej@redhat.com>
Trinity v1.4pre  Dave Jones <davej@redhat.com>
[   28.771223] random: trinity urandom read with 2 bits of entropy available
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
Marking all syscalls as enabled.
[init] Enabled 351 syscalls. Disabled 0 syscalls.
DANGER: RUNNING AS ROOT.
Unless you are running in a virtual machine, this could cause serious probl=
ems such as overwriting CMOS
or similar which could potentially make this machine unbootable without a f=
irmware reset.

ctrl-c now unless you really know what you are doing.
Trinity v1.4pre  Dave Jones <davej@redhat.com>
[init] Marking syscall get_robust_list (312) as to be disabled.
Done parsing arguments.
## couldn't open logfile trinity.log
Done parsing arguments.
## couldn't open logfile trinity.log
Couldn't read pid_max from proc
[init] Using pid_max =3D 32768
[init] Kernel was tainted on startup. Will ignore flags that are already se=
t.
[init] Started watchdog process, PID is 229
[main] Main thread is alive.
[main] Couldn't find socket cachefile. Regenerating.
[main] Setsockopt(6 1 80d1000 4) on fd 7 [2:1:0]
[main] Setsockopt(101 8 80d1000 4) on fd 8 [3:2:0]
[main] Setsockopt(1 23 80d1000 67) on fd 10 [23:1:2]
[main] Setsockopt(116 7f 80d1000 de) on fd 12 [37:1:5]
[main] Setsockopt(1 1 80d1000 54) on fd 14 [2:1:6]
[main] Setsockopt(1 a 80d1000 91) on fd 15 [3:5:1]
[main] Setsockopt(1 f 80d1000 25) on fd 16 [16:2:21]
[main] Setsockopt(107 7 80d1000 4) on fd 17 [17:2:768]
[main] Setsockopt(116 80 80d1000 4) on fd 19 [37:5:3]
[main] Setsockopt(1 c 80d1000 4) on fd 20 [1:1:1]
[main] Setsockopt(1 22 80d1000 4) on fd 21 [2:3:26]
[main] Setsockopt(1 2c 80d1000 4) on fd 22 [3:5:6]
[main] Setsockopt(1 2 80d1000 95) on fd 23 [16:3:11]
[main] Setsockopt(1 20 80d1000 4) on fd 24 [17:10:768]
[main] Setsockopt(1 29 80d1000 4) on fd 25 [23:5:193]
[main] Setsockopt(116 80 80d1000 17) on fd 26 [37:5:3]
[main] Setsockopt(1 9 80d1000 aa) on fd 27 [1:5:1]
[main] Setsockopt(1 8 80d1000 7f) on fd 28 [2:3:159]
[main] Setsockopt(1 2 80d1000 e8) on fd 29 [3:3:159]
[main] Setsockopt(1 9 80d1000 d7) on fd 30 [16:2:9]
[main] Setsockopt(1 29 80d1000 4) on fd
[   38.787277] sock: process `trinity-main' is using obsolete setsockopt SO=
_BSDCOMPAT
 31 [17:3:768]
[main] Setsockopt(0 1 80d1000 1) on fd 36 [2:1:0]
[main] Setsockopt(10e 3 80d1000 a5) on fd 38 [16:2:8]
[main] Setsockopt(107 11 80d1000 4) on fd 39 [17:3:768]
[main] Setsockopt(116 7f 80d1000 4) on fd 40 [37:1:0]
[main] Setsockopt(1 6 80d1000 6d) on fd 41 [1:2:1]
[main] Setsockopt(1 d 80d1000 8) on fd 43 [16:3:21]
[main] Setsockopt(10a 4 80d1000 1e) on fd 45 [23:1:116]
[main] Setsockopt(1 1d 80d1000 4) on fd 46 [36:3:191]
[main] Setsockopt(1 21 80d1000 4) on fd 47 [37:5:1]
[main] Setsockopt(1 7 80d1000 c) on fd 48 [1:2:1]
[main] Setsockopt(6 c 80d1000 4) on fd 49 [2:1:6]
[main] Setsockopt(1 28 80d1000 4) on fd 50 [3:2:0]
[main] Setsockopt(1 2f 80d1000 4) on fd 51 [16:3:5]
[main] Setsockopt(107 9 80d1000 4) on fd 52 [17:3:768]
[main] Setsockopt(6 8 80d1000 4) on fd 57 [2:1:6]
[main] Setsockopt(1 7 80d1000 b5) on fd 58 [3:3:6]
[main] Setsockopt(10e 3 80d1000 b1) on fd 59 [16:3:0]
[main] Setsockopt(1 7 80d1000 a7) on fd 60 [17:2:768]
[main] Setsockopt(1 23 80d1000 4) on fd 62 [37:1:1]
[main] Setsockopt(1 e 80d1000 4) on fd 64 [2:1:0]
[main] Setsockopt(116 7f 80d1000 57) on fd 69 [37:5:0]
[main] Setsockopt(1 6 80d1000 4) on fd 73 [17:3:768]
[main] Setsockopt(10a 7 80d1000 4) on fd 74 [23:2:0]
[main] Setsockopt(116 7f 80d1000 4) on fd 76 [37:1:2]
[main] Setsockopt(1 10 80d1000 9c) on fd 77 [1:5:1]
[main] Setsockopt(6 1 80d1000 2a) on fd 78 [2:1:0]
[main] Setsockopt(1 2 80d1000 a5) on fd 79 [17:2:768]
[main] Setsockopt(1 29 80d1000 4) on fd 80 [23:5:135]
[main] Setsockopt(116 7f 80d1000 f4) on fd 82 [37:1:2]
[main] Setsockopt(1 10 80d1000 a4) on fd 83 [1:1:1]
[main] Setsockopt(1 21 80d1000 4) on fd 84 [2:1:0]
[main] Setsockopt(1 21 80d1000 78) on fd 85 [3:3:0]
[main] Setsockopt(10e 3 80d1000 4) on fd 86 [16:2:18]
[main] Setsockopt(107 9 80d1000 4) on fd 87 [17:3:768]
[main] Setsockopt(10a a 80d1000 3b) on fd 88 [23:2:0]
[main] Setsockopt(1 7 80d1000 16) on fd 90 [37:5:0]
[main] Setsockopt(0 1 80d1000 4) on fd 92 [2:2:17]
[main] Setsockopt(10e 5 80d1000 4) on fd 94 [16:2:10]
[main] Setsockopt(107 11 80d1000 4) on fd 95 [17:3:768]
[main] Setsockopt(10a 4 80d1000 e4) on fd 96 [23:2:0]
[main] Setsockopt(1 d 80d1000 8) on fd 98 [37:5:1]
[main] Setsockopt(6 9 80d1000 4) on fd 100 [2:1:6]
[main] Setsockopt(1 1d 80d1000 4) on fd 101 [3:3:6]
[main] Setsockopt(1 28 80d1000 d8) on fd 104 [37:1:2]
[main] Setsockopt(1 7 80d1000 4) on fd 106 [2:2:0]
[main] Setsockopt(10e 3 80d1000 4) on fd 108 [16:3:2]
[main] Setsockopt(1 2 80d1000 4) on fd 109 [17:2:768]
[main] Setsockopt(116 7f 80d1000 5e) on fd 111 [37:1:4]
[main] Setsockopt(1 e 80d1000 4) on fd 112 [1:5:1]
[main] Setsockopt(0 b 80d1000 1) on fd 113 [2:2:17]
[main] Setsockopt(10e 3 80d1000 4) on fd 115 [16:2:12]
[main] Setsockopt(1 7 80d1000 4) on fd 116 [17:3:768]
[main] Setsockopt(1 d 80d1000 8) on fd 119 [37:1:5]
[main] Setsockopt(1 f 80d1000 4) on fd 123 [16:3:8]
[main] Setsockopt(107 e 80d1000 4) on fd 124 [17:2:768]
[main] Setsockopt(1 2 80d1000 55) on fd 125 [23:2:0]
[main] Setsockopt(1 a 80d1000 4) on fd 126 [37:5:3]
[main] Setsockopt(1 9 80d1000 e2) on fd 127 [1:1:1]
[main] Setsockopt(6 3 80d1000 4) on fd 128 [2:1:0]
[main] Setsockopt(107 7 80d1000 4) on fd 130 [17:3:768]
[main] Setsockopt(10a 4 80d1000 30) on fd 131 [23:5:233]
[main] Setsockopt(1 6 80d1000 4) on fd 133 [1:5:1]
[main] Setsockopt(88 1 80d1000 76) on fd 134 [2:2:17]
[main] Setsockopt(1 29 80d1000 3e) on fd 135 [3:2:0]
[main] Setsockopt(107 e 80d1000 4) on fd 136 [17:2:768]
[main] Setsockopt(1 1d 80d1000 4) on fd 137 [23:5:184]
[main] Setsockopt(1 9 80d1000 4) on fd 138 [37:1:5]
[main] Setsockopt(1 23 80d1000 6f) on fd 139 [1:5:1]
[main] Setsockopt(6 a 80d1000 4d) on fd 140 [2:1:6]
[main] Setsockopt(1 8 80d1000 4) on fd 141 [17:3:768]
[main] Setsockopt(10a 4 80d1000 4) on fd 142 [23:5:53]
[main] Setsockopt(0 1 80d1000 12) on fd 146 [2:1:6]
[main] Setsockopt(1 2f 80d1000 4) on fd 147 [3:5:7]
[main] Setsockopt(1 20 80d1000 4) on fd 149 [23:1:103]
[main] Setsockopt(1 2d 80d1000 4) on fd 150 [36:2:213]
[main] Setsockopt(1 5 80d1000 98) on fd 151 [37:5:4]
[main] Setsockopt(1 2d 80d1000 4) on fd 152 [1:1:1]
[main] Setsockopt(1 20 80d1000 14) on fd 153 [2:2:17]
[main] Setsockopt(10e 3 80d1000 4) on fd 155 [16:2:16]
[main] Setsockopt(107 e 80d1000 4) on fd 156 [17:2:2048]
[main] Setsockopt(1 1 80d1000 4) on fd 157 [23:2:0]
[main] Setsockopt(116 7f 80d1000 8d) on fd 158 [37:5:0]
[main] Setsockopt(1 2 80d1000 c1) on fd 159 [1:1:1]
[main] Setsockopt(0 21 80d1000 1) on fd 160 [2:3:127]
[main] Setsockopt(1 22 80d1000 4) on fd 162 [17:10:34878]
[main] Setsockopt(1 10 80d1000 f7) on fd 164 [36:3:71]
[main] Setsockopt(1 2 80d1000 4) on fd 165 [37:5:3]
[main] Setsockopt(1 9 80d1000 dc) on fd 166 [1:2:1]
[main] Setsockopt(1 10 80d1000 4) on fd 169 [16:2:5]
[main] Setsockopt(107 e 80d1000 4) on fd 170 [17:2:768]
[main] Setsockopt(116 7f 80d1000 b3) on fd 171 [37:5:0]
[main] Setsockopt(1 e 80d1000 19) on fd 172 [1:1:1]
[main] Setsockopt(1 c 80d1000 1e) on fd 173 [2:1:6]
[main] Setsockopt(1 2c 80d1000 4) on fd 175 [17:10:768]
[main] Setsockopt(1 6 80d1000 4) on fd 176 [23:5:227]
[main] Setsockopt(116 7f 80d1000 a5) on fd 177 [37:5:2]
[main] Setsockopt(6 3 80d1000 4c) on fd 179 [2:1:6]
[main] Setsockopt(1 9 80d1000 4) on fd 183 [23:1:40]
[main] Setsockopt(1 e 80d1000 8a) on fd 186 [2:3:113]
[main] Setsockopt(107 9 80d1000 25) on fd 187 [17:3:768]
[main] Setsockopt(1 9 80d1000 3b) on fd 188 [23:5:188]
[main] Setsockopt(1 28 80d1000 77) on fd 189 [37:5:2]
[main] Setsockopt(1 c 80d1000 fc) on fd 195 [36:2:200]
[main] Setsockopt(116 7f 80d1000 4) on fd 196 [37:5:0]
[main] Setsockopt(1 2d 80d1000 4) on fd 197 [1:1:1]
[main] Setsockopt(1 20 80d1000 4) on fd 198 [2:1:0]
[main] Setsockopt(1 7 80d1000 41) on fd 199 [3:5:7]
[main] Setsockopt(1 12 80d1000 45) on fd 200 [16:3:21]
[main] Setsockopt(116 7f 80d1000 d8) on fd 203 [37:5:3]
[main] Setsockopt(0 1 80d1000 4) on fd 205 [2:1:6]
[main] Setsockopt(1 29 80d1000 fa) on fd 206 [3:5:6]
[main] Setsockopt(1 b 80d1000 4) on fd 209 [23:5:71]
[main] Setsockopt(1 9 80d1000 4) on fd 210 [37:5:4]
[main] Setsockopt(1 6 80d1000 c) on fd 211 [1:1:1]
[main] Setsockopt(0 22 80d1000 4) on fd 212 [2:2:0]
[main] Setsockopt(1 20 80d1000 4) on fd 213 [16:3:9]
[main] Setsockopt(1 2b 80d1000 4) on fd 216 [37:5:0]
[main] Setsockopt(1 24 80d1000 4) on fd 217 [1:2:1]
[main] Setsockopt(1 2b 80d1000 4) on fd 218 [2:3:42]
[main] Setsockopt(101 8 80d1000 29) on fd 219 [3:5:203]
[main] Setsockopt(10e 3 80d1000 4) on fd 220 [16:2:21]
[main] Setsockopt(1 a 80d1000 dd) on fd 221 [17:2:768]
[main] Setsockopt(116 7f 80d1000 23) on fd 223 [37:5:1]
[main] Setsockopt(1 d 80d1000 8) on fd 225 [2:1:0]
[main] Setsockopt(1 6 80d1000 4) on fd 228 [23:5:23]
[main] Setsockopt(1 19 80d1000 f3) on fd 231 [2:1:0]
[main] Setsockopt(1 2d 80d1000 4) on fd 232 [3:2:0]
[main] Setsockopt(1 2f 80d1000 4) on fd 233 [16:2:8]
[main] Setsockopt(1 f 80d1000 98) on fd 234 [17:2:768]
[main] Setsockopt(1 f 80d1000 c0) on fd 235 [23:5:10]
[main] Setsockopt(1 e 80d1000 4) on fd 237 [1:5:1]
[main] Setsockopt(1 12 80d1000 c4) on fd 241 [23:1:201]
[main] Setsockopt(116 7f 80
[   38.808557] serial8250: too much work for irq4
d1000 4) on fd 243 [37:1:3]
[main] Setsockopt(1 29 80d1000 a1) on fd 245 [2:3:64]
[main] Setsockopt(101 c 80d1000 3f) on fd 246 [3:2:0]
[main] Setsockopt(1 5 80d1000 4) on fd 248 [17:3:768]
[main] Setsockopt(1 9 80d1000 31) on fd 250 [37:5:3]
[main] Setsockopt(1 e 80d1000 e1) on fd 251 [1:2:1]
[main] Setsockopt(0 3 80d1000 ef) on fd 252 [2:3:12]
[main] Setsockopt(1 20 80d1000 6b) on fd 253 [3:3:12]
[main] Setsockopt(107 8 80d1000 ab) on fd 254 [17:3:768]
[main] Setsockopt(1 a 80d1000 4) on fd 256 [1:5:1]
[main] Setsockopt(1 1d 80d1000 4) on fd 257 [2:3:162]
[main] Setsockopt(1 7 80d1000 e) on fd 258 [3:3:162]
[main] Setsockopt(10a a 80d1000 97) on fd 261 [23:1:204]
[main] Setsockopt(1 e 80d1000 c4) on fd 263 [1:1:1]
[main] Setsockopt(1 23 80d1000 4) on fd 264 [2:1:0]
[main] Setsockopt(1 8 80d1000 4) on fd 266 [17:10:768]
[main] Setsockopt(1 e 80d1000 9c) on fd 268 [36:3:174]
[main] Setsockopt(1 2f 80d1000 1f) on fd 269 [37:5:1]
[main] Setsockopt(1 a 80d1000 4) on fd 270 [1:2:1]
[main] Setsockopt(1 f 80d1000 4) on fd 274 [17:3:768]
[main] Setsockopt(1 20 80d1000 4) on fd 278 [2:1:6]
[main] Setsockopt(10a 4 80d1000 4) on fd 281 [23:1:236]
[main] Setsockopt(116 7f 80d1000 88) on fd 282 [37:1:2]
[main] Setsockopt(1 12 80d1000 4) on fd 284 [2:2:17]
[main] Setsockopt(10e 5 80d1000 4) on fd 286 [16:2:4]
[main] Setsockopt(1 5 80d1000 93) on fd 287 [17:10:768]
[main] Setsockopt(1 2c 80d1000 4) on fd 288 [23:2:0]
[main] Setsockopt(102 0 80d1000 6d) on fd 289 [36:2:87]
[main] Setsockopt(116 7f 80d1000 4) on fd 290 [37:1:4]
[main] Setsockopt(1 2a 80d1000 fe) on fd 291 [1:2:1]
[main] Setsockopt(1 7 80d1000 78) on fd 293 [3:3:226]
[main] Setsockopt(116 7f 80d1000 4) on fd 296 [37:5:4]
[main] Setsockopt(1 f 80d1000 67) on fd 298 [2:2:0]
[main] Setsockopt(1 2f 80d1000 4) on fd 300 [16:2:10]
[main] Setsockopt(1 24 80d1000 4) on fd 301 [17:3:768]
[main] Setsockopt(1 5 80d1000 4) on fd 302 [23:1:110]
[main] Setsockopt(116 7f 80d1000 6a) on fd 303 [37:1:4]
[main] Setsockopt(1 8 80d1000 b4) on fd 304 [1:5:1]
[main] Setsockopt(1 d 80d1000 8) on fd 305 [2:2:0]
[main] Setsockopt(1 24 80d1000 64) on fd 306 [3:2:0]
[main] Setsockopt(107 c 80d1000 4) on fd 307 [17:3:768]
[main] Setsockopt(1 d 80d1000 8) on fd 309 [37:1:2]
[main] Setsockopt(1 2 80d1000 7a) on fd 310 [1:1:1]
[main] Setsockopt(88 1 80d1000 4) on fd 311 [2:2:0]
[main] Setsockopt(1 12 80d1000 4) on fd 312 [3:5:240]
[main] Setsockopt(107 8 80d1000 4) on fd 313 [17:2:768]
[main] Setsockopt(10a 4 80d1000 df) on fd 314 [23:1:248]
[main] Setsockopt(1 8 80d1000 51) on fd 318 [3:2:0]
[main] Setsockopt(1 29 80d1000 8b) on fd 319 [17:2:768]
[main] Setsockopt(1 2b 80d1000 fe) on fd 320 [23:5:2]
[main] Setsockopt(116 80 80d1000 4) on fd 321 [37:1:3]
[main] Setsockopt(1 2c 80d1000 4) on fd 322 [1:1:1]
[main] Setsockopt(11 1 80d1000 4) on fd 323 [2:2:0]
[main] Setsockopt(101 c 80d1000 4) on fd 324 [3:3:0]
[main] Setsockopt(10e 5 80d1000 47) on fd 325 [16:2:11]
[main] Setsockopt(1 8 80d1000 4) on fd 326 [17:2:768]
[main] Setsockopt(116 7f 80d1000 d8) on fd 328 [37:5:5]
[main] Setsockopt(0 f 80d1000 1) on fd 330 [2:2:0]
[main] Setsockopt(1 5 80d1000 49) on fd 332 [16:2:10]
[main] Setsockopt(116 80 80d1000 6d) on fd 336 [37:5:3]
[main] Setsockopt(1 2c 80d1000 4f) on fd 339 [16:2:21]
[main] Setsockopt(1 2 80d1000 e7) on fd 341 [23:1:181]
[main] Setsockopt(116 7f 80d1000 4) on fd 342 [37:5:3]
[main] Setsockopt(1 5 80d1000 4) on fd 343 [1:5:1]
[main] Setsockopt(0 c 80d1000 1) on fd 344 [2:2:17]
[main] Setsockopt(1 d 80d1000 8) on fd 345 [3:3:17]
[main] Setsockopt(1 10 80d1000 4) on fd 346 [17:2:768]
[main] Setsockopt(1 12 80d1000 8b) on fd 347 [23:5:136]
[main] Setsockopt(116 7f 80d1000 4) on fd 348 [37:1:0]
[main] Setsockopt(1 2b 80d1000 bc) on fd 349 [1:5:1]
[main] Setsockopt(1 9 80d1000 4) on fd 351 [3:3:0]
[main] Setsockopt(10e 4 80d1000 4) on fd 352 [16:3:5]
[main] Setsockopt(1 d 80d1000 8) on fd 354 [23:2:0]
[main] Setsockopt(1 8 80d1000 4) on fd 356 [1:2:1]
[main] Setsockopt(0 1 80d1000 f2) on fd 357 [2:1:6]
[main] Setsockopt(1 e 80d1000 4) on fd 359 [16:2:12]
[main] Setsockopt(107 7 80d1000 4) on fd 360 [17:2:768]
[main] Setsockopt(116 7f 80d1000 4) on fd 361 [37:1:1]
[main] Setsockopt(1 a 80d1000 ba) on fd 362 [1:2:1]
[main] Setsockopt(0 c 80d1000 4) on fd 363 [2:2:0]
[main] Setsockopt(1 8 80d1000 4) on fd 365 [16:3:11]
[main] Setsockopt(1 20 80d1000 52) on fd 367 [23:2:0]
[main] Setsockopt(1 2c 80d1000 4) on fd 368 [36:3:246]
[main] Setsockopt(1 24 80d1000 22) on fd 369 [37:1:1]
[main] Setsockopt(1 a 80d1000 67) on fd 370 [1:1:1]
[main] Setsockopt(11 1 80d1000 4) on fd 371 [2:2:0]
[main] Setsockopt(101 8 80d1000 2f) on fd 372 [3:2:0]
[main] Setsockopt(10e 3 80d1000 8c) on fd 373 [16:3:18]
[main] Setsockopt(1 1d 80d1000 19) on fd 374 [17:3:768]
[main] Setsockopt(116 7f 80d1000 4) on fd 376 [37:5:0]
[main] Setsockopt(1 2 80d1000 c0) on fd 377 [1:1:1]
[main] Setsockopt(1 e 80d1000 4) on fd 378 [2:3:243]
[main] Setsockopt(101 c 80d1000 c2) on fd 379 [3:5:196]
[main] Setsockopt(1 12 80d1000 8c) on fd 380 [16:2:21]
[main] created 375 sockets
fopen: No such file or directory
Couldn't read pid_max from proc
[init] Using pid_max =3D 32768
[init] Kernel was tainted on startup. Will ignore flags that are already se=
t.
[init] Started watchdog process, PID is 231
[main] Main thread is alive.
[main] Setsockopt(0 13 80d1000 4) on fd 7 [2:1:0]
[main] Setsockopt(1 5 80d1000 4) on fd 8 [3:2:0]
[main] Setsockopt(1 2 80d1000 7c) on fd 13 [1:1:1]
[main] Setsockopt(1 2f 80d1000 4) on fd 14 [2:1:6]
[main] Setsockopt(1 21 80d1000 4) on fd 15 [3:5:1]
[main] Setsockopt(1 a 80d1000 4) on fd 16 [16:2:21]
[main] Setsockopt(1 19 80d1000 4) on fd 17 [17:2:768]
[main] Setsockopt(1 24 80d1000 4) on fd 19 [37:5:3]
[main] Setsockopt(1 24 80d1000 4) on fd 21 [2:3:26]
[main] Setsockopt(1 21 80d1000 67) on fd 23 [16:3:11]
[main] Setsockopt(1 2b 80d1000 4) on fd 25 [23:5:193]
[main] Setsockopt(116 7f 80d1000 4) on fd 26 [37:5:3]
[main] Setsockopt(1 2e 80d1000 4) on fd 27 [1:5:1]
[main] Setsockopt(1 23 80d1000 4) on fd 29 [3:3:159]
[main] Setsockopt(1 2e 80d1000 4) on fd 32 [23:2:0]
[main] Setsockopt(1 a 80d1000 1f) on fd 33 [36:3:184]
[main] Setsockopt(116 7f 80d1000 4) on fd 34 [37:1:1]
[main] Setsockopt(1 2f 80d1000 4) on fd 35 [1:5:1]
[main] Setsockopt(1 19 80d1000 4) on fd 36 [2:1:0]
[main] Setsockopt(1 9 80d1000 4) on fd 38 [16:2:8]
[main] Setsockopt(1 6 80d1000 b8) on fd 39 [17:3:768]
[main] Setsockopt(0 13 80d1000 1) on fd 42 [2:2:17]
[main] Setsockopt(107 e 80d1000 4) on fd 44 [17:3:768]
[main] Setsockopt(10a a 80d1000 26) on fd 45 [23:1:116]
[main] Setsockopt(1 29 80d1000 79) on fd 46 [36:3:191]
[main] Setsockopt(116 7f 80d1000 4) on fd 47 [37:5:1]
[main] Setsockopt(0 4 80d1000 1c) on fd 49 [2:1:6]
[main] Setsockopt(101 7 80d1000 d0) on fd 50 [3:2:0]
[main] Setsockopt(1 6 80d1000 12) on fd 52 [17:3:768]
[main] Setsockopt(10a 7 80d1000 4) on fd 53 [23:2:0]
[main] Setsockopt(1 12 80d1000 4) on fd 54 [36:3:29]
[main] Setsockopt(1 c 80d1000 4) on fd 55 [37:1:3]
[main] Setsockopt(1 c 80d1000 4) on fd 56 [1:2:1]
[main] Setsockopt(6 2 80d1000 15) on fd 57 [2:1:6]
[main] Setsockopt(1 a 80d1000 4) on fd 58 [3:3:6]
[main] Setsockopt(10e 4 80d1000 23) on fd 59 [16:3:0]
[main] Setsockopt(1 1 80d1000 4) on fd 61 [23:5:111]
[main] Setsockopt(1 23 80d1000 4) on fd 62 [37:1:1]
[main] Setsockopt(6 1 80d1000 6c) on fd 64 [2:1:0]
[main] Setsockopt(101 8 80d1000 4) on fd 65 [3:3:0]
[main] Setsockopt(107 e 80d1000 4) on fd 66 [17:2:768]
[main] Setsockopt(1 21 80d1000 4) on fd 68 [36:2:26]
[main] Setsockopt(116 7f 80d1000 83) on fd 69 [37:5:0]
[main] Setsockopt(1 d 80d1000 8) on fd 70 [1:5:1]
[main] Setsockopt(6 4 80d1000 4) on fd 71 [2:1:0]
[main] Setsockopt(107 12 80d1000 4) on fd 73 [17:3:768]
[main] Setsockopt(10a 4 80d1000 4) on fd 74 [23:2:0]
[main] Setsockopt(1 20 80d1000 4) on fd 76 [37:1:2]
[main] Setsockopt(1 1d 80d1000 ea) on fd 77 [1:5:1]
[main] Setsockopt(0 13 80d1000 1) on fd 78 [2:1:0]
[main] Setsockopt(1 a 80d1000 78) on fd 79 [17:2:768]
[main] Setsockopt(1 9 80d1000 80) on fd 82 [37:1:2]
[main] Setsockopt(1 10 80d1000 16) on fd 83 [1:1:1]
[main] Setsockopt(1 10 80d1000 ee) on fd 85 [3:3:0]
[main] Setsockopt(1 24 80d1000 4) on fd 87 [17:3:768]
[main] Setsockopt(1 23 80d1000 4) on fd 88 [23:2:0]
[main] Setsockopt(116 7f 80d1000 13) on fd 90 [37:5:0]
[main] Setsockopt(1 c 80d1000 4) on fd 91 [1:2:1]
[main] Setsockopt(11 1 80d1000 d0) on fd 92 [2:2:17]
[main] Setsockopt(1 12 80d1000 4) on fd 93 [3:2:0]
[main] Setsockopt(1 6 80d1000 69) on fd 95 [17:3:768]
[main] Setsockopt(1 23 80d1000 4) on fd 97 [36:3:213]
[main] Setsockopt(1 20 80d1000 4) on fd 98 [37:5:1]
[main] Setsockopt(1 c 80d1000 4) on fd 100 [2:1:6]
[main] Setsockopt(101 2 80d1000 4) on fd 101 [3:3:6]
[main] Setsockopt(1 5 80d1000 4) on fd 103 [17:2:768]
[main] Setsockopt(116 7f 80d1000 7e) on fd 104 [37:1:2]
[main] Setsockopt(1 22 80d1000 4) on fd 105 [1:5:1]
[main] Setsockopt(11 1 80d1000 7e) on fd 106 [2:2:0]
[main] Setsockopt(1 5 80d1000 4) on fd 107 [3:5:7]
[main] Setsockopt(1 2d 80d1000 6b) on fd 110 [23:1:75]
[main] Setsockopt(116 7f 80d1000 5c) on fd 111 [37:1:4]
[main] Setsockopt(88 1 80d1000 db) on fd 113 [2:2:17]
[main] Setsockopt(1 20 80d1000 76) on fd 114 [3:2:0]
[main] Setsockopt(1 23 80d1000 4) on fd 115 [16:2:12]
[main] Setsockopt(1 5 80d1000 a0) on fd 117 [23:1:100]
[main] Setsockopt(1 2d 80d1000 4) on fd 120 [1:1:1]
[main] Setsockopt(1 b 80d1000 4) on fd 121 [2:1:0]
[main] Setsockopt(101 8 80d1000 dd) on fd 122 [3:5:240]
[main] Setsockopt(1 10 80d1000 e6) on fd 123 [16:3:8]
[main] Setsockopt(1 2b 80d1000 4) on fd 124 [17:2:768]
[main] Setsockopt(10a 4 80d1000 76) on fd 125 [23:2:0]
[main] Setsockopt(1 2c 80d1000 c7) on fd 127 [1:1:1]
[main] Setsockopt(6 3 80d1000 b1) on fd 128 [2:1:0]
[main] Setsockopt(1 1d 80d1000 e6) on fd 129 [16:3:16]
[main] Setsockopt(1 23 80d1000 f2) on fd 130 [17:3:768]
[main] Setsockopt(1 2 80d1000 4) on fd 131 [23:5:233]
[main] Setsockopt(1 24 80d1000 4) on fd 132 [37:1:2]
[main] Setsockopt(1 f 80d1000 4) on fd 133 [1:5:1]
[main] Setsockopt(11 64 80d1000 4) on fd 134 [2:2:17]
[main] Setsockopt(101 4 80d1000 c2) on fd 135 [3:2:0]
[main] Setsockopt(1 2c 80d1000 4) on fd 136 [17:2:768]
[main] Setsockopt(1 a 80d1000 4) on fd 137 [23:5:184]
[main] Setsockopt(1 2b 80d1000 d1) on fd 138 [37:1:5]
[main] Setsockopt(1 9 80d1000 4) on fd 139 [1:5:1]
[main] Setsockopt(6 3 80d1000 2c) on fd 140 [2:1:6]
[main] Setsockopt(107 f 80d1000 43) on fd 141 [17:3:768]
[main] Setsockopt(1 2f 80d1000 4) on fd 143 [36:2:59]
[main] Setsockopt(1 12 80d1000 f8) on fd 147 [3:5:7]
[main] Setsockopt(1 20 80d1000 4) on fd 149 [23:1:103]
[main] Setsockopt(1 e 80d1000 4) on fd 150 [36:2:213]
[main] Setsockopt(116 7f 80d1000 39) on fd 151 [37:5:4]
[main] Setsockopt(1 2 80d1000 a6) on fd 152 [1:1:1]
[main] Setsockopt(11 1 80d1000 4) on fd 153 [2:2:17]
[main] Setsockopt(101 4 80d1000 4) on fd 154 [3:5:6]
[main] Setsockopt(10e 5 80d1000 4) on fd 155 [16:2:16]
[main] Setsockopt(1 c 80d1000 4) on fd 156 [17:2:2048]
[main] Setsockopt(1 7 80d1000 4) on fd 157 [23:2:0]
[main] Setsockopt(116 7f 80d1000 9e) on fd 158 [37:5:0]
[main] Setsockopt(1 6 80d1000 98) on fd 159 [1:1:1]
[main] Setsockopt(1 28 80d1000 9c) on fd 160 [2:3:127]
[main] Setsockopt(1 28 80d1000 bb) on fd 161 [3:3:127]
[main] Setsockopt(1 2f 80d1000 4) on fd 163 [23:1:164]
[main] Setsockopt(1 2b 80d1000 4) on fd 164 [36:3:71]
[main] Setsockopt(116 80 80d1000 2d) on fd 165 [37:5:3]
[main] Setsockopt(1 21 80d1000 e9) on fd 166 [1:2:1]
[main] Setsockopt(1 a 80d1000 4f) on fd 168 [3:2:0]
[main] Setsockopt(10e 4 80d1000 4) on fd 169 [16:2:5]
[main] Setsockopt(1 b 80d1000 4) on fd 172 [1:1:1]
[main] Setsockopt(1 2b 80d1000 d9) on fd 173 [2:1:6]
[main] Setsockopt(101 c 80d1000 84) on fd 174 [3:5:7]
[main] Setsockopt(1 9 80d1000 d0) on fd 176 [23:5:227]
[main] Setsockopt(1 c 80d1000 4) on fd 177 [37:5:2]
[main] Setsockopt(6 c 80d1000 ef) on fd 179 [2:1:6]
[main] Setsockopt(1 10 80d1000 19) on fd 181 [16:3:16]
[main] Setsockopt(1 a 80d1000 32) on fd 182 [17:2:768]
[main] Setsockopt(10a 7 80d1000 4) on fd 183 [23:1:40]
[main] Setsockopt(116 7f 80d1000 4) on fd 184 [37:5:3]
[main] Setsockopt(1 2f 80d1000 4) on fd 185 [1:1:1]
[main] Setsockopt(0 d 80d1000 4) on fd 186 [2:3:113]
[main] Setsockopt(107 f 80d1000 f5) on fd 187 [17:3:768]
[main] Setsockopt(1 22 80d1000 9b) on fd 189 [37:5:2]
[main] Setsockopt(1 2a 80d1000 4) on fd 190 [1:5:1]
[main] Setsockopt(1 20 80d1000 4) on fd 191 [2:3:28]
[main] Setsockopt(1 d 80d1000 8) on fd 192 [3:2:0]
[main] Setsockopt(1 b 80d1000 f6) on fd 193 [17:3:768]
[main] Setsockopt(1 2 80d1000 5) on fd 198 [2:1:0]
[main] Setsockopt(1 f 80d1000 39) on fd 199 [3:5:7]
[main] Setsockopt(1 2c 80d1000 4) on fd 203 [37:5:3]
[main] Setsockopt(1 6 80d1000 41) on fd 204 [1:1:1]
[main] Setsockopt(0 7 80d1000 4) on fd 205 [2:1:6]
[main] Setsockopt(1 2c 80d1000 4) on fd 206 [3:5:6]
[main] Setsockopt(1 6 80d1000 4) on fd 207 [16:2:18]
[main] Setsockopt(1 2 80d1000 6f) on fd 208 [17:3:768]
[main] Setsockopt(1 2f 80d1000 4) on fd 209 [23:5:71]
[main] Setsockopt(1 23 80d1000 4) on fd 210 [37:5:4]
[main] Setsockopt(1 e 80d1000 4) on fd 211 [1:1:1]
[main] Setsockopt(88 1 80d1000 4) on fd 212 [2:2:0]
[main] Setsockopt(1 2f 80d1000 4) on fd 213 [16:3:9]
[main] Setsockopt(1 23 80d1000 37) on fd 216 [37:5:0]
[main] Setsockopt(1 d 80d1000 8) on fd 218 [2:3:42]
[main] Setsockopt(1 10 80d1000 4) on fd 219 [3:5:203]
[main] Setsockopt(1 8 80d1000 4) on fd 220 [16:2:21]
[main] Setsockopt(1 12 80d1000 4) on fd 221 [17:2:768]
[main] Setsockopt(1 6 80d1000 4) on fd 222 [23:1:96]
[main] Setsockopt(1 23 80d1000 b7) on fd 223 [37:5:1]
[main] Setsockopt(1 2c 80d1000 4) on fd 226 [3:3:0]
[main] Setsockopt(116 7f 80d1000 7b) on fd 229 [37:5:2]
[main] Setsockopt(6 c 80d1000 4c) on fd 231 [2:1:0]
[main] Setsockopt(1 d 80d1000 8) on fd 232 [3:2:0]
[main] Setsockopt(1 9 80d1000 12) on fd 234 [17:2:768]
[main] Setsockopt(1 20 80d1000 2a) on fd 235 [23:5:10]
[main] Setsockopt(1 2 80d1000 56) on fd 236 [37:5:4]
[main] Setsockopt(1 9 80d1000 85) on fd 238 [2:1:0]
[main] Setsockopt(1 23 80d1000 57) on fd 239 [3:2:0]
[main] Setsockopt(107 11 80d1000 4) on fd 240 [17:2:768]
[main] Setsockopt(1 2f 80d1000 1a) on fd 241 [23:1:201]
[main] Setsockopt(116 7f 80d1000 4) on fd 243 [37:1:3]
[main] Setsockopt(1 9 80d1000 4) on fd 244 [1:5:1]
[main] Setsockopt(0 3 80d1000 4) on fd 245 [2:3:64]
[main] Setsockopt(101 c 80d1000 d9) on fd 246 [3:2:0]
[main] Setsockopt(1 7 80d1000 4) on fd 247 [16:3:4]
[main] Setsockopt(10a 4 80d1000 4) on fd 249 [23:5:148]
[main] Setsockopt(1 2b 80d1000 65) on fd 252 [2:3:12]
[main] Setsockopt(101 c 80d1000 4) on fd 253 [3:3:12]
[main] Setsockopt(1 21 80d1000 87) on fd 254 [17:3:768]
[main] Setsockopt(1 9 80d1000 4) on fd 256 [1:5:1]
[main] Setsockopt(0 3 80d1000 4d) on fd 257 [2:3:162]
[main] Setsockopt(1 e 80d1000 4) on fd 258 [3:3:162]
[main] Setsockopt(107 12 80d1000 4) on fd 260 [17:2:34878]
[main] Setsockopt(1 24 80d1000 c6) on fd 261 [23:1:204]
[main] Setsockopt(1 2b 80d1000 4) on fd 262 [37:1:1]
[main] Setsockopt(6 3 80d1000 4) on fd 264 [2:1:0]
[main] Setsockopt(101 8 80d1000 e3) on fd 265 [3:2:0]
[main] Setsockopt(1 29 80d1000 4) on fd 267 [23:1:65]
[main] Setsockopt(88 1 80d1000 c8) on fd 271 [2:2:0]
[main] Setsockopt(1 22 80d1000 3b) on fd 272 [3:2:0]
[main] Setsockopt(1 28 80d1000 4) on fd 273 [16:3:9]
[main] Setsockopt(1 5 80d1000 b7) on fd 275 [23:2:0]
[main] Setsockopt(6 8 80d1000 4) on fd 278 [2:1:6]
[main] Setsockopt(1 2f 80d1000 6c) on fd 279 [3:2:0]
[main] Setsockopt(1 12 80d1000 4) on fd 280 [17:10:768]
[main] Setsockopt(1 20 80d1000 6f) on fd 281 [23:1:236]
[main] Setsockopt(1 2d 80d1000 c8) on fd 283 [1:2:1]
[main] Setsockopt(1 5 80d1000 8a) on fd 284 [2:2:17]
[main] Setsockopt(1 8 80d1000 4) on fd 285 [3:2:0]
[main] Setsockopt(1 1d 80d1000 15) on fd 287 [17:10:768]
[main] Setsockopt(1 28 80d1000 bb) on fd 288 [23:2:0]
[main] Setsockopt(1 10 80d1000 4) on fd 289 [36:2:87]
[main] Setsockopt(1 f 80d1000 fa) on fd 290 [37:1:4]
[main] Setsockopt(1 23 80d1000 4) on fd 291 [1:2:1]
[main] Setsockopt(0 22 80d1000 4) on fd 292 [2:3:226]
[main] Setsockopt(101 a 80d1000 4) on fd 293 [3:3:226]
[main] Setsockopt(10a 7 80d1000 24) on fd 295 [23:2:0]
[main] Setsockopt(116 7f 80d1000 8) on fd 296 [37:5:4]
[main] Setsockopt(1 7 80d1000 17) on fd 298 [2:2:0]
[main] Setsockopt(1 9 80d1000 90) on fd 299 [3:3:0]
[main] Setsockopt(1 5 80d1000 4) on fd 301 [17:3:768]
[main] Setsockopt(1 28 80d1000 26) on fd 302 [23:1:110]
[main] Setsockopt(116 7f 80d1000 ea) on fd 303 [37:1:4]
[main] Setsockopt(11 1 80d1000 b0) on fd 305 [2:2:0]
[main] Setsockopt(1 2 80d1000 4) on fd 306 [3:2:0]
[main] Setsockopt(1 a 80d1000 4) on fd 307 [17:3:768]
[main] Setsockopt(116 7f 80d1000 4) on fd 309 [37:1:2]
[main] Setsockopt(0 7 80d1000 1) on fd 311 [2:2:0]
[main] Setsockopt(1 20 80d1000 4) on fd 314 [23:1:248]
[main] Setsockopt(1 24 80d1000 4) on fd 316 [1:2:1]
[main] Setsockopt(0 22 80d1000 4) on fd 317 [2:1:0]
[main] Setsockopt(101 a 80d1000 4) on fd 318 [3:2:0]
[main] Setsockopt(1 12 80d1000 8f) on fd 320 [23:5:2]
[main] Setsockopt(1 8 80d1000 df) on fd 321 [37:1:3]
[main] Setsockopt(1 a 80d1000 13) on fd 322 [1:1:1]
[main] Setsockopt(88 1 80d1000 4) on fd 323 [2:2:0]
[main] Setsockopt(116 7f 80d1000 4) on fd 328 [37:5:5]
[main] Setsockopt(1 9 80d1000 4) on fd 329 [1:2:1]
[main] Setsockopt(11 1 80d1000 4) on fd 330 [2:2:0]
[main] Setsockopt(1 23 80d1000 4) on fd 331 [3:5:195]
[main] Setsockopt(1 d 80d1000 8) on fd 334 [23:1:216]
[main] Setsockopt(1 1 80d1000 4) on fd 335 [36:3:195]
[main] Setsockopt(116 80 80d1000 e6) on fd 336 [37:5:3]
[main] Setsockopt(1 12 80d1000 5f) on fd 337 [1:5:1]
[main] Setsockopt(10a 7 80d1000 4) on fd 341 [23:1:181]
[main] Setsockopt(116 7f 80d1000 6e) on fd 342 [37:5:3]
[main] Setsockopt(1 6 80d1000 4) on fd 343 [1:5:1]
[main] Setsockopt(0 1 80d1000 b8) on fd 344 [2:2:17]
[main] Setsockopt(101 2 80d1000 4) on fd 345 [3:3:17]
[main] Setsockopt(1 7 80d1000 4) on fd 346 [17:2:768]
[main] Setsockopt(1 b 80d1000 f7) on fd 347 [23:5:136]
[main] Setsockopt(6 8 80d1000 4) on fd 350 [2:1:0]
[main] Setsockopt(1 24 80d1000 b6) on fd 351 [3:3:0]
[main] Setsockopt(1 2b 80d1000 61) on=20
[   38.878847] serial8250: too much work for irq4
fd 352 [16:3:5]
[main] Setsockopt(1 d 80d1000 8) on fd 353 [17:3:768]
[main] Setsockopt(10a 7 80d1000 ec) on fd 354 [23:2:0]
[main] Setsockopt(1 29 80d1000 4) on fd 355 [37:5:3]
[main] Setsockopt(1 1d 80d1000 4) on fd 356 [1:2:1]
[main] Setsockopt(1 12 80d1000 3d) on fd 357 [2:1:6]
[main] Setsockopt(1 23 80d1000 67) on fd 361 [37:1:1]
[main] Setsockopt(1 b 80d1000 25) on fd 362 [1:2:1]
[main] Setsockopt(1 2 80d1000 4) on fd 363 [2:2:0]
[main] Setsockopt(1 c 80d1000 4) on fd 364 [3:5:196]
[main] Setsockopt(1 21 80d1000 4) on fd 365 [16:3:11]
[main] Setsockopt(1 2f 80d1000 4) on fd 367 [23:2:0]
[main] Setsockopt(1 d 80d1000 8) on fd 369 [37:1:1]
[main] Setsockopt(1 2d 80d1000 4) on fd 370 [1:1:1]
[main] Setsockopt(0 f 80d1000 4) on fd 371 [2:2:0]
[main] Setsockopt(101 c 80d1000 f6) on fd 372 [3:2:0]
[main] Setsockopt(10e 5 80d1000 4) on fd 373 [16:3:18]
[main] Setsockopt(1 24 80d1000 51) on fd 374 [17:3:768]
[main] Setsockopt(1 2f 80d1000 77) on fd 375 [23:5:5]
[main] Setsockopt(1 6 80d1000 16) on fd 376 [37:5:0]
[main] Setsockopt(0 c 80d1000 1) on fd 378 [2:3:243]
[main] Setsockopt(1 2 80d1000 4) on fd 379 [3:5:196]
[main] 375 sockets created based on info from socket cachefile.
lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 09:22:10 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 09:22:10 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 09:22:10 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

run-parts: /etc/kernel-tests/99-rmmod exited with code 123
shutdown: warning: cannot open /var/run/shutdown.pid
mount: no /proc/mounts
wfg: skip syslogd
sed: /proc/mounts: No such file or directory
sed: /proc/mounts: No such file or directory
sed: /proc/mounts: No such file or directory
Deconfiguring network interfaces... ifdown: interface lo not configured
done.
Sending all processes the TERM signal...
mount: mounting proc on /proc failed: No such device
Sending all processes the KILL signal...
mount: mounting proc on /proc failed: No such device
Unmounting remote filesystems...
Deactivating swap...
Unmounting local filesystems...
grep: /proc/mounts: No such file or directory
mount: can't read '/proc/mounts': No such file or directory
Rebooting...=20
[   96.976665] Unregister pv shared memory for cpu 1
[   96.977125] Unregister pv shared memory for cpu 0
[   96.980793] reboot: Restarting system
[   96.981123] reboot: machine restart
Elapsed time: 100
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-r=
0-0318/ac96a27ebfe1ac1631a679f24991143c124127b5/vmlinuz-3.14.0-rc7-00703-ga=
c96a27 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D=
10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3D=
ttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kerne=
l-tests/run-queue/kvm/i386-randconfig-r0-0318/linux-devel:devel-roam-i386-2=
01403182248/.vmlinuz-ac96a27ebfe1ac1631a679f24991143c124127b5-2014031822585=
4-7-cairo branch=3Dlinux-devel/devel-roam-i386-201403182248 BOOT_IMAGE=3D/k=
ernel/i386-randconfig-r0-0318/ac96a27ebfe1ac1631a679f24991143c124127b5/vmli=
nuz-3.14.0-rc7-00703-gac96a27'  -initrd /kernel-tests/initrd/yocto-minimal-=
i386.cgz -m 256 -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1,h=
ostfwd=3Dtcp::10501-:22 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc=
 base=3Dlocaltime -drive file=3D/fs/LABEL=3DKVM/disk0-yocto-cairo-10,media=
=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1-yocto-cairo-10,medi=
a=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk2-yocto-cairo-10,med=
ia=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-yocto-cairo-10,me=
dia=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk4-yocto-cairo-10,m=
edia=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk5-yocto-cairo-10,=
media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-yocto-cairo-10 -serial=
 file:/dev/shm/kboot/serial-yocto-cairo-10 -daemonize -display none -monito=
r null=20

--nFreZHaLTZJo0R7j
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-r0-0318-ac96a27ebfe1ac1631a679f24991143c124127b5-WARNING:---at----drm_warn_on_modeset_not_all_locked+-x-113476.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IGRjYjk5ZmQ5YjA4Y2ZlMWFmZTQyNmFmNGQ4ZDNjYmM0MjkxOTBmMTUK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yMC0w
MzE4L2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0MDMxODIyNDg6ZGNiOTlmZDli
MDhjZmUxYWZlNDI2YWY0ZDhkM2NiYzQyOTE5MGYxNTpiaXNlY3QtbGludXg2CgoyMDE0LTAz
LTE4LTIzOjE2OjM3IGRjYjk5ZmQ5YjA4Y2ZlMWFmZTQyNmFmNGQ4ZDNjYmM0MjkxOTBmMTUg
cmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAtMDMxOC9kY2I5OWZkOWIwOGNmZTFh
ZmU0MjZhZjRkOGQzY2JjNDI5MTkwZjE1L3ZtbGludXotMy4xNC4wLXJjNwoKMjAxNC0wMy0x
OC0yMzoxNjozNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4JMTIJMjAgU1VDQ0VTUwoKYmlz
ZWN0OiBnb29kIGNvbW1pdCBkY2I5OWZkOWIwOGNmZTFhZmU0MjZhZjRkOGQzY2JjNDI5MTkw
ZjE1CmdpdCBiaXNlY3Qgc3RhcnQgYWM5NmEyN2ViZmUxYWMxNjMxYTY3OWYyNDk5MTE0M2Mx
MjQxMjdiNSBkY2I5OWZkOWIwOGNmZTFhZmU0MjZhZjRkOGQzY2JjNDI5MTkwZjE1IC0tCi9j
L2tlcm5lbC10ZXN0cy9saW5lYXItYmlzZWN0OiBbIi1iIiwgImFjOTZhMjdlYmZlMWFjMTYz
MWE2NzlmMjQ5OTExNDNjMTI0MTI3YjUiLCAiLWciLCAiZGNiOTlmZDliMDhjZmUxYWZlNDI2
YWY0ZDhkM2NiYzQyOTE5MGYxNSIsICIvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIiwgIi9rZXJuZWwtdGVzdHMvbGludXg2L29iai1iaXNlY3QiXQpCaXNl
Y3Rpbmc6IDcwMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
MTAgc3RlcHMpCls4MzZiZjM2MmI3MjExNGU1ZDRjZGI2ODk1ZmJkMjZlOWE0MTVlODU0XSBN
ZXJnZSAnZHJtLWludGVsL2RybS1pbnRlbC1uaWdodGx5JyBpbnRvIGRldmVsLXJvYW0taTM4
Ni0yMDE0MDMxODIyNDgKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg2L29iai1iaXNlY3QKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yMC0wMzE4L2xpbnV4
LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0MDMxODIyNDg6ODM2YmYzNjJiNzIxMTRlNWQ0
Y2RiNjg5NWZiZDI2ZTlhNDE1ZTg1NDpiaXNlY3QtbGludXg2CgoyMDE0LTAzLTE4LTIzOjE5
OjA4IDgzNmJmMzYyYjcyMTE0ZTVkNGNkYjY4OTVmYmQyNmU5YTQxNWU4NTQgY29tcGlsaW5n
ClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1y
YW5kY29uZmlnLXIwLTAzMTgtODM2YmYzNjJiNzIxMTRlNWQ0Y2RiNjg5NWZiZDI2ZTlhNDE1
ZTg1NApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIwLTAz
MTgvODM2YmYzNjJiNzIxMTRlNWQ0Y2RiNjg5NWZiZDI2ZTlhNDE1ZTg1NAp3YWl0aW5nIGZv
ciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29u
ZmlnLXIwLTAzMTgtODM2YmYzNjJiNzIxMTRlNWQ0Y2RiNjg5NWZiZDI2ZTlhNDE1ZTg1NAp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkz
ODYtcmFuZGNvbmZpZy1yMC0wMzE4LTgzNmJmMzYyYjcyMTE0ZTVkNGNkYjY4OTVmYmQyNmU5
YTQxNWU4NTQKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMC0wMzE4LzgzNmJm
MzYyYjcyMTE0ZTVkNGNkYjY4OTVmYmQyNmU5YTQxNWU4NTQvdm1saW51ei0zLjE0LjAtcmM3
LTAwNTQyLWc4MzZiZjM2CgoyMDE0LTAzLTE4LTIzOjMwOjA5IGRldGVjdGluZyBib290IHN0
YXRlIC4uLi4gVEVTVCBGQUlMVVJFClsgICAgNi4yMzQwMTFdIFtUVE1dIEluaXRpYWxpemlu
ZyBwb29sIGFsbG9jYXRvcgpbICAgIDYuMjM0NTQ3XSBbVFRNXSBJbml0aWFsaXppbmcgRE1B
IHBvb2wgYWxsb2NhdG9yClsgICAgNi4yMzUxNjZdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUg
XS0tLS0tLS0tLS0tLQpbICAgIDYuMjM1NzIwXSBXQVJOSU5HOiBDUFU6IDEgUElEOiAxIGF0
IGRyaXZlcnMvZ3B1L2RybS9kcm1fY3J0Yy5jOjk0IGRybV93YXJuX29uX21vZGVzZXRfbm90
X2FsbF9sb2NrZWQrMHgzYy8weDYxKCkKWyAgICA2LjIzNzIxMV0gQ1BVOiAxIFBJRDogMSBD
b21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xNC4wLXJjNy0wMDU0Mi1nODM2YmYzNiAj
MTA2ClsgICAgNi4yMzgwNjNdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJv
Y2hzIDAxLzAxLzIwMTEKWyAgICA2LjIzODc2MF0gIDAwMDAwMDAwIDAwMDAwMDAwIDc4MDNm
Y2Q0IDc5Y2U5NjYxIDAwMDAwMDAwIDc4MDNmZDA0IDc5MDU1YTg0IDdhMDRkODg2ClsgICAg
Ni4yMzk3ODldICAwMDAwMDAwMSAwMDAwMDAwMSA3YTBjNjM0ZiAwMDAwMDA1ZSA3OTRmMzA2
NCA3OTRmMzA2NCA4MGMzOTgwMCA4MGRkYTQwMApbICAgIDYuMjQxODI2XSAgODBkZGE1Y2Mg
NzgwM2ZkMTQgNzkwNTViMzkgMDAwMDAwMDkgMDAwMDAwMDAgNzgwM2ZkMjggNzk0ZjMwNjQg
ODBlYWFhODAKWyAgICA2LjI0MjkzNV0gQ2FsbCBUcmFjZToKWyAgICA2LjI0MzI2OF0gIFs8
NzljZTk2NjE+XSBkdW1wX3N0YWNrKzB4NDgvMHg2MApbICAgIDYuMjQzNzgzXSAgWzw3OTA1
NWE4ND5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4NmYvMHg4NgpbICAgIDYuMjQ0NDQ5XSAg
Wzw3OTRmMzA2ND5dID8gZHJtX3dhcm5fb25fbW9kZXNldF9ub3RfYWxsX2xvY2tlZCsweDNj
LzB4NjEKWyAgICA2LjI0NTIzMF0gIFs8Nzk0ZjMwNjQ+XSA/IGRybV93YXJuX29uX21vZGVz
ZXRfbm90X2FsbF9sb2NrZWQrMHgzYy8weDYxClsgICAgNi4yNDU5NzFdICBbPDc5MDU1YjM5
Pl0gd2Fybl9zbG93cGF0aF9udWxsKzB4MWQvMHgxZgpbICAgIDYuMjQ2NjMwXSAgWzw3OTRm
MzA2ND5dIGRybV93YXJuX29uX21vZGVzZXRfbm90X2FsbF9sb2NrZWQrMHgzYy8weDYxClsg
ICAgNi4yNDczOTZdICBbPDc5NGU1MGM3Pl0gZHJtX2hlbHBlcl9kaXNhYmxlX3VudXNlZF9m
dW5jdGlvbnMrMHhkLzB4Y2YKWyAgICA2LjI0ODE0NF0gIFs8Nzk2MWIyYjc+XSBjaXJydXNf
ZmJkZXZfaW5pdCsweDYxLzB4N2MKWyAgICA2LjI0ODc4MV0gIFs8Nzk2MWFiYzY+XSBjaXJy
dXNfbW9kZXNldF9pbml0KzB4MTNmLzB4MTg4ClsgICAgNi4yNDk0MjFdICBbPDc5NjE5ZjM4
Pl0gY2lycnVzX2RyaXZlcl9sb2FkKzB4ODkvMHhkNApbICAgIDYuMjUwMDAzXSAgWzw3OTRl
ZjllMT5dIGRybV9kZXZfcmVnaXN0ZXIrMHg2Ny8weGM5ClsgICAgNi4yNTE1NTFdICBbPDc5
NGYxMzU4Pl0gZHJtX2dldF9wY2lfZGV2KzB4ZDcvMHgxOGEKWyAgICA2LjI1MjEyMF0gIFs8
NzlkMDExZWM+XSA/IG11dGV4X3VubG9jaysweDgvMHhhClsgICAgNi4yNTI2NTBdICBbPDc5
NjFhY2JkPl0gY2lycnVzX3BjaV9wcm9iZSsweDdkLzB4ODkKWyAgICA2LjI1MzMwNl0gIFs8
NzkzZjAzYTE+XSBwY2lfZGV2aWNlX3Byb2JlKzB4NDQvMHg4NQpbICAgIDYuMjUzOTAxXSAg
Wzw3OTEyMzUwMD5dID8gc3lzZnNfY3JlYXRlX2xpbmsrMHgyNy8weDJmClsgICAgNi4yNTQ1
MDhdICBbPDc5NmNlOWE2Pl0gZHJpdmVyX3Byb2JlX2RldmljZSsweDg4LzB4MTdhClsgICAg
Ni4yNTUxNTVdICBbPDc5M2YwMjIyPl0gPyBwY2lfbWF0Y2hfZGV2aWNlKzB4OTcvMHg5ZApb
ICAgIDYuMjU1NzkxXSAgWzw3OTZjZWIwYj5dIF9fZHJpdmVyX2F0dGFjaCsweDQ3LzB4NjMK
WyAgICA2LjI1NjM0OF0gIFs8Nzk2Y2Q4MjY+XSBidXNfZm9yX2VhY2hfZGV2KzB4NTUvMHg1
ZgpbICAgIDYuMjU2OTA0XSAgWzw3OTZjZThkZj5dIGRyaXZlcl9hdHRhY2grMHgxNy8weDE5
ClsgICAgNi4yNTc0OTJdICBbPDc5NmNlYWM0Pl0gPyBfX2RldmljZV9hdHRhY2grMHgyYy8w
eDJjClsgICAgNi4yNTgwOTBdICBbPDc5NmNkZTE4Pl0gYnVzX2FkZF9kcml2ZXIrMHhkMS8w
eDE5OApbICAgIDYuMjU4NjUxXSAgWzw3OTZjZjBiOT5dIGRyaXZlcl9yZWdpc3RlcisweDdh
LzB4YWUKWyAgICA2LjI1OTIxMV0gIFs8NzkzZjAyN2I+XSBfX3BjaV9yZWdpc3Rlcl9kcml2
ZXIrMHgyZC8weDMwClsgICAgNi4yNTk4NzNdICBbPDdhMmY3NThiPl0gPyBtZ2FnMjAwX2lu
aXQrMHgyMy8weDIzClsgICAgNi4yNjE0MDZdICBbPDc5NGYxNDY3Pl0gZHJtX3BjaV9pbml0
KzB4NWMvMHhkMwpbICAgIDYuMjYyMTQ0XSAgWzw3YTJmNzU4Yj5dID8gbWdhZzIwMF9pbml0
KzB4MjMvMHgyMwpbICAgIDYuMjYyNzE3XSAgWzw3YTJmNzVhNj5dIGNpcnJ1c19pbml0KzB4
MWIvMHgyMwpbICAgIDYuMjYzMjgyXSAgWzw3YTJjYWE2Yz5dIGRvX29uZV9pbml0Y2FsbCsw
eDgyLzB4MTBiClsgICAgNi4yNjM4ODhdICBbPDc5M2JmN2UzPl0gPyBzdHJsZW4rMHhkLzB4
MTcKWyAgICA2LjI2NDQ4Ml0gIFs8N2EyY2E0MzA+XSA/IHJlcGFpcl9lbnZfc3RyaW5nKzB4
MTIvMHg1MQpbICAgIDYuMjY1MjU5XSAgWzw3OTA2NmY3Nj5dID8gcGFyc2VfYXJncysweDE2
OC8weDIyNApbICAgIDYuMjY1ODY2XSAgWzw3YTJjYWM0Mz5dIGtlcm5lbF9pbml0X2ZyZWVh
YmxlKzB4MTRlLzB4MWU1ClsgICAgNi4yNjY1OTddICBbPDdhMmNhNDFlPl0gPyBkb19lYXJs
eV9wYXJhbSsweDc4LzB4NzgKWyAgICA2LjI2NzIzM10gIFs8NzljZTBkODQ+XSBrZXJuZWxf
aW5pdCsweGIvMHhjNgpbICAgIDYuMjY3NzU3XSAgWzw3OWQwMmUxNz5dIHJldF9mcm9tX2tl
cm5lbF90aHJlYWQrMHgxYi8weDI4ClsgICAgNi4yNjg0OTFdICBbPDc5Y2UwZDc5Pl0gPyBy
ZXN0X2luaXQrMHg2ZC8weDZkClsgICAgNi4yNjkwMDddIC0tLVsgZW5kIHRyYWNlIDQ5MTcz
N2E2N2M2NTFiMGQgXS0tLQpbICAgIDYuMjY5NTg2XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJl
IF0tLS0tLS0tLS0tLS0KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAtMDMxOC84MzZiZjM2
MmI3MjExNGU1ZDRjZGI2ODk1ZmJkMjZlOWE0MTVlODU0L2RtZXNnLXlvY3RvLWl2eXRvd24y
LTI6MjAxNDAzMTgyMzMxNDc6aTM4Ni1yYW5kY29uZmlnLXIwLTAzMTg6My4xNC4wLXJjNy0w
MDU0Mi1nODM2YmYzNjoxMDYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAtMDMxOC84MzZi
ZjM2MmI3MjExNGU1ZDRjZGI2ODk1ZmJkMjZlOWE0MTVlODU0L2RtZXNnLXlvY3RvLWl2eXRv
d24yLTY6MjAxNDAzMTgyMzMxNDc6aTM4Ni1yYW5kY29uZmlnLXIwLTAzMTg6My4xNC4wLXJj
Ny0wMDU0Mi1nODM2YmYzNjoxMDYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAtMDMxOC84
MzZiZjM2MmI3MjExNGU1ZDRjZGI2ODk1ZmJkMjZlOWE0MTVlODU0L2RtZXNnLXlvY3RvLWl2
eXRvd24yLTg6MjAxNDAzMTgyMzMxNDc6aTM4Ni1yYW5kY29uZmlnLXIwLTAzMTg6My4xNC4w
LXJjNy0wMDU0Mi1nODM2YmYzNjoxMDYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAtMDMx
OC84MzZiZjM2MmI3MjExNGU1ZDRjZGI2ODk1ZmJkMjZlOWE0MTVlODU0L2RtZXNnLXlvY3Rv
LWl2eXRvd24yLTEzOjIwMTQwMzE4MjMzMTQ5OmkzODYtcmFuZGNvbmZpZy1yMC0wMzE4OjMu
MTQuMC1yYzctMDA1NDItZzgzNmJmMzY6MTA2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIw
LTAzMTgvODM2YmYzNjJiNzIxMTRlNWQ0Y2RiNjg5NWZiZDI2ZTlhNDE1ZTg1NC9kbWVzZy1x
dWFudGFsLWNhaXJvLTI4OjIwMTQwMzE4MjMzMTU2OmkzODYtcmFuZGNvbmZpZy1yMC0wMzE4
OjMuMTQuMC1yYzctMDA1NDItZzgzNmJmMzY6MTA2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXIwLTAzMTgvODM2YmYzNjJiNzIxMTRlNWQ0Y2RiNjg5NWZiZDI2ZTlhNDE1ZTg1NC9kbWVz
Zy1xdWFudGFsLWNhaXJvLTQ1OjIwMTQwMzE4MjMzMjAwOmkzODYtcmFuZGNvbmZpZy1yMC0w
MzE4OjMuMTQuMC1yYzctMDA1NDItZzgzNmJmMzY6MTA2Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLXIwLTAzMTgvODM2YmYzNjJiNzIxMTRlNWQ0Y2RiNjg5NWZiZDI2ZTlhNDE1ZTg1NC9k
bWVzZy1xdWFudGFsLWNhaXJvLTQ2OjIwMTQwMzE4MjMzMTU1OmkzODYtcmFuZGNvbmZpZy1y
MC0wMzE4OjMuMTQuMC1yYzctMDA1NDItZzgzNmJmMzY6MTA2Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXIwLTAzMTgvODM2YmYzNjJiNzIxMTRlNWQ0Y2RiNjg5NWZiZDI2ZTlhNDE1ZTg1
NC9kbWVzZy15b2N0by1jYWlyby0yMjoyMDE0MDMxODIzMzE1NzppMzg2LXJhbmRjb25maWct
cjAtMDMxODozLjE0LjAtcmM3LTAwNTQyLWc4MzZiZjM2OjEwNgova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1yMC0wMzE4LzgzNmJmMzYyYjcyMTE0ZTVkNGNkYjY4OTVmYmQyNmU5YTQxNWU4
NTQvZG1lc2cteW9jdG8tY2Fpcm8tNDY6MjAxNDAzMTgyMzMxNTU6aTM4Ni1yYW5kY29uZmln
LXIwLTAzMTg6My4xNC4wLXJjNy0wMDU0Mi1nODM2YmYzNjoxMDYKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctcjAtMDMxOC84MzZiZjM2MmI3MjExNGU1ZDRjZGI2ODk1ZmJkMjZlOWE0MTVl
ODU0L2RtZXNnLXlvY3RvLWNhaXJvLTU6MjAxNDAzMTgyMzMxNTc6aTM4Ni1yYW5kY29uZmln
LXIwLTAzMTg6My4xNC4wLXJjNy0wMDU0Mi1nODM2YmYzNjoxMDYKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctcjAtMDMxOC84MzZiZjM2MmI3MjExNGU1ZDRjZGI2ODk1ZmJkMjZlOWE0MTVl
ODU0L2RtZXNnLXlvY3RvLWl2eXRvd24yLTI2OjIwMTQwMzE4MjMzMTUxOmkzODYtcmFuZGNv
bmZpZy1yMC0wMzE4OjMuMTQuMC1yYzctMDA1NDItZzgzNmJmMzY6MTA2Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXIwLTAzMTgvODM2YmYzNjJiNzIxMTRlNWQ0Y2RiNjg5NWZiZDI2ZTlh
NDE1ZTg1NC9kbWVzZy1xdWFudGFsLWNhaXJvLTEwOjIwMTQwMzE4MjMzMjAyOmkzODYtcmFu
ZGNvbmZpZy1yMC0wMzE4OjMuMTQuMC1yYzctMDA1NDItZzgzNmJmMzY6MTA2Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXIwLTAzMTgvODM2YmYzNjJiNzIxMTRlNWQ0Y2RiNjg5NWZiZDI2
ZTlhNDE1ZTg1NC9kbWVzZy1xdWFudGFsLWNhaXJvLTI1OjIwMTQwMzE4MjMzMjAzOmkzODYt
cmFuZGNvbmZpZy1yMC0wMzE4OjMuMTQuMC1yYzctMDA1NDItZzgzNmJmMzY6MTA2Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXIwLTAzMTgvODM2YmYzNjJiNzIxMTRlNWQ0Y2RiNjg5NWZi
ZDI2ZTlhNDE1ZTg1NC9kbWVzZy1xdWFudGFsLWNhaXJvLTM4OjIwMTQwMzE4MjMzMjA0Omkz
ODYtcmFuZGNvbmZpZy1yMC0wMzE4OjMuMTQuMC1yYzctMDA1NDItZzgzNmJmMzY6MTA2CjA6
MTQ6MTQgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDMtMTggMjM6
MzI6MTAgUkVQRUFUIENPVU5UOiAyMCAgIyAva2VybmVsLXRlc3RzL2xpbnV4Ni9vYmotYmlz
ZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDU0MiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0
IGFmdGVyIHRoaXMgKHJvdWdobHkgMTAgc3RlcHMpCls1Zjg1ZjQ5NjJlNjY3ZGUwYWRkYTQ3
MmE1ZjlkZWU3M2Y5ODE1ZWM1XSAwZGF5IGJhc2UgZ3VhcmQgZm9yICdkZXZlbC1yb2FtLWkz
ODYtMjAxNDAzMTgyMjQ4JwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDYvb2JqLWJpc2VjdApscyAtYSAv
a2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXIwLTAzMTgvbGlu
dXgtZGV2ZWw6ZGV2ZWwtcm9hbS1pMzg2LTIwMTQwMzE4MjI0ODo1Zjg1ZjQ5NjJlNjY3ZGUw
YWRkYTQ3MmE1ZjlkZWU3M2Y5ODE1ZWM1OmJpc2VjdC1saW51eDYKCjIwMTQtMDMtMTgtMjM6
MzI6MTIgNWY4NWY0OTYyZTY2N2RlMGFkZGE0NzJhNWY5ZGVlNzNmOTgxNWVjNSBjb21waWxp
bmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2
LXJhbmRjb25maWctcjAtMDMxOC01Zjg1ZjQ5NjJlNjY3ZGUwYWRkYTQ3MmE1ZjlkZWU3M2Y5
ODE1ZWM1CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAt
MDMxOC81Zjg1ZjQ5NjJlNjY3ZGUwYWRkYTQ3MmE1ZjlkZWU3M2Y5ODE1ZWM1CndhaXRpbmcg
Zm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRj
b25maWctcjAtMDMxOC01Zjg1ZjQ5NjJlNjY3ZGUwYWRkYTQ3MmE1ZjlkZWU3M2Y5ODE1ZWM1
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8u
aTM4Ni1yYW5kY29uZmlnLXIwLTAzMTgtNWY4NWY0OTYyZTY2N2RlMGFkZGE0NzJhNWY5ZGVl
NzNmOTgxNWVjNQprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIwLTAzMTgvNWY4
NWY0OTYyZTY2N2RlMGFkZGE0NzJhNWY5ZGVlNzNmOTgxNWVjNS92bWxpbnV6LTMuMTQuMC1y
YzctMDAwMDEtZzVmODVmNDkKCjIwMTQtMDMtMTktMDA6MDE6MTIgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgLi4uLi4uLi4uLgkxOQkyMCBTVUNDRVNTCgpsaW5lYXItYmlzZWN0OiBiYWQgYnJh
bmNoIG1heSBiZSBkcm0taW50ZWwvZHJtLWludGVsLW5pZ2h0bHkKbGluZWFyLWJpc2VjdDog
aGFuZGxlIG92ZXIgdG8gZ2l0IGJpc2VjdApsaW5lYXItYmlzZWN0OiBnaXQgYmlzZWN0IHN0
YXJ0IDgzNmJmMzYyYjcyMTE0ZTVkNGNkYjY4OTVmYmQyNmU5YTQxNWU4NTQgNWY4NWY0OTYy
ZTY2N2RlMGFkZGE0NzJhNWY5ZGVlNzNmOTgxNWVjNSAtLQpQcmV2aW91cyBIRUFEIHBvc2l0
aW9uIHdhcyA1Zjg1ZjQ5Li4uIDBkYXkgYmFzZSBndWFyZCBmb3IgJ2RldmVsLXJvYW0taTM4
Ni0yMDE0MDMxODIyNDgnCkhFQUQgaXMgbm93IGF0IDFlNTAwNTkuLi4gTWVyZ2UgZ2l0Oi8v
Z2l0Lmtlcm5lbC5vcmcvcHViL3NjbS92aXJ0L2t2bS9rdm0KQmlzZWN0aW5nOiAyNzAgcmV2
aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDggc3RlcHMpCltlOWRi
ZDJiMjAyMDFiNDliMDQ0NzZkMmU1NzYzZmFhODIyOTY3OTEzXSBkcm0vaTkxNTogRml4IGZv
cmNld2FrZSBjb3VudHMgZm9yIGdlbjgKbGluZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBydW4g
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRl
c3RzL2xpbnV4Ni9vYmotYmlzZWN0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4Ni9vYmotYmlzZWN0Cmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctcjAtMDMx
OC9saW51eC1kZXZlbDpkZXZlbC1yb2FtLWkzODYtMjAxNDAzMTgyMjQ4OmU5ZGJkMmIyMDIw
MWI0OWIwNDQ3NmQyZTU3NjNmYWE4MjI5Njc5MTM6YmlzZWN0LWxpbnV4NgoKMjAxNC0wMy0x
OS0wMDowNzoyNiBlOWRiZDJiMjAyMDFiNDliMDQ0NzZkMmU1NzYzZmFhODIyOTY3OTEzIGNv
bXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVl
L2kzODYtcmFuZGNvbmZpZy1yMC0wMzE4LWU5ZGJkMmIyMDIwMWI0OWIwNDQ3NmQyZTU3NjNm
YWE4MjI5Njc5MTMKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1yMC0wMzE4L2U5ZGJkMmIyMDIwMWI0OWIwNDQ3NmQyZTU3NjNmYWE4MjI5Njc5MTMKd2Fp
dGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYt
cmFuZGNvbmZpZy1yMC0wMzE4LWU5ZGJkMmIyMDIwMWI0OWIwNDQ3NmQyZTU3NjNmYWE4MjI5
Njc5MTMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1
ZXVlLy5pMzg2LXJhbmRjb25maWctcjAtMDMxOC1lOWRiZDJiMjAyMDFiNDliMDQ0NzZkMmU1
NzYzZmFhODIyOTY3OTEzCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAtMDMx
OC9lOWRiZDJiMjAyMDFiNDliMDQ0NzZkMmU1NzYzZmFhODIyOTY3OTEzL3ZtbGludXotMy4x
My4wLTAwMDM2LWdlOWRiZDJiCgoyMDE0LTAzLTE5LTAwOjIyOjI2IGRldGVjdGluZyBib290
IHN0YXRlIC4uLi4uLi4JNS4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxNTcgcmV2aXNpb25z
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDcgc3RlcHMpClthMWE4YmRmMzU1
ZTc1MDM3NTM4YWFhNjAyYmFlZWRhNDQ3ZGE4MzQ2XSBNZXJnZSByZW1vdGUtdHJhY2tpbmcg
YnJhbmNoICdvcmlnaW4vZHJtLWludGVsLWZpeGVzJyBpbnRvIGRybS1pbnRlbC1uaWdodGx5
CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAv
a2VybmVsLXRlc3RzL2xpbnV4Ni9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVu
LXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctcjAtMDMxOC9saW51eC1kZXZlbDpkZXZlbC1y
b2FtLWkzODYtMjAxNDAzMTgyMjQ4OmExYThiZGYzNTVlNzUwMzc1MzhhYWE2MDJiYWVlZGE0
NDdkYTgzNDY6YmlzZWN0LWxpbnV4NgoKMjAxNC0wMy0xOS0wMDoyNzozMCBhMWE4YmRmMzU1
ZTc1MDM3NTM4YWFhNjAyYmFlZWRhNDQ3ZGE4MzQ2IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQg
dGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1yMC0w
MzE4LWExYThiZGYzNTVlNzUwMzc1MzhhYWE2MDJiYWVlZGE0NDdkYTgzNDYKQ2hlY2sgZm9y
IGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMC0wMzE4L2ExYThiZGYzNTVl
NzUwMzc1MzhhYWE2MDJiYWVlZGE0NDdkYTgzNDYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1yMC0wMzE4LWEx
YThiZGYzNTVlNzUwMzc1MzhhYWE2MDJiYWVlZGE0NDdkYTgzNDYKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWct
cjAtMDMxOC1hMWE4YmRmMzU1ZTc1MDM3NTM4YWFhNjAyYmFlZWRhNDQ3ZGE4MzQ2Cmtlcm5l
bDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAtMDMxOC9hMWE4YmRmMzU1ZTc1MDM3NTM4
YWFhNjAyYmFlZWRhNDQ3ZGE4MzQ2L3ZtbGludXotMy4xNC4wLXJjNi0wMDM4My1nYTFhOGJk
ZgoKMjAxNC0wMy0xOS0wMDo0NjozMCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgkxCTcJMTAu
Li4uCTExCTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogNzggcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDYgc3RlcHMpClszYTA1NzAwZGM4NzRmMzc3YjEzZTQz
Njg1NTBlOGM3MjI4ODI2YWI0XSBkcm0vZG9jOiBVcGRhdGUgY29weXJpZ2h0CnJ1bm5pbmcg
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRl
c3RzL2xpbnV4Ni9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2
bS9pMzg2LXJhbmRjb25maWctcjAtMDMxOC9saW51eC1kZXZlbDpkZXZlbC1yb2FtLWkzODYt
MjAxNDAzMTgyMjQ4OjNhMDU3MDBkYzg3NGYzNzdiMTNlNDM2ODU1MGU4YzcyMjg4MjZhYjQ6
YmlzZWN0LWxpbnV4NgoKMjAxNC0wMy0xOS0wMDo1MjoxOCAzYTA1NzAwZGM4NzRmMzc3YjEz
ZTQzNjg1NTBlOGM3MjI4ODI2YWI0IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1yMC0wMzE4LTNhMDU3
MDBkYzg3NGYzNzdiMTNlNDM2ODU1MGU4YzcyMjg4MjZhYjQKQ2hlY2sgZm9yIGtlcm5lbCBp
biAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMC0wMzE4LzNhMDU3MDBkYzg3NGYzNzdiMTNl
NDM2ODU1MGU4YzcyMjg4MjZhYjQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVs
LXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1yMC0wMzE4LTNhMDU3MDBkYzg3
NGYzNzdiMTNlNDM2ODU1MGU4YzcyMjg4MjZhYjQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWctcjAtMDMxOC0z
YTA1NzAwZGM4NzRmMzc3YjEzZTQzNjg1NTBlOGM3MjI4ODI2YWI0Cmtlcm5lbDogL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctcjAtMDMxOC8zYTA1NzAwZGM4NzRmMzc3YjEzZTQzNjg1NTBl
OGM3MjI4ODI2YWI0L3ZtbGludXotMy4xNC4wLXJjNC0wMDMxMy1nM2EwNTcwMAoKMjAxNC0w
My0xOS0wMDo1NToxOSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4JMTIJMjAgU1VDQ0VTUwoK
QmlzZWN0aW5nOiAzMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdo
bHkgNSBzdGVwcykKWzk3OGM2MDUwMTY1YmJhNTJlYWI3ZWYzNTgxZDQ0N2ViMjE1ZGVmNzdd
IE1lcmdlIGJyYW5jaCAnZHJtLWRvY3MnIG9mIHNzaDovL3Blb3BsZS5mcmVlZGVza3RvcC5v
cmcvfmRhbnZldC9kcm0gaW50byBkcm0tbmV4dApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDYvb2JqLWJp
c2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmln
LXIwLTAzMTgvbGludXgtZGV2ZWw6ZGV2ZWwtcm9hbS1pMzg2LTIwMTQwMzE4MjI0ODo5Nzhj
NjA1MDE2NWJiYTUyZWFiN2VmMzU4MWQ0NDdlYjIxNWRlZjc3OmJpc2VjdC1saW51eDYKCjIw
MTQtMDMtMTktMDA6NTc6NTEgOTc4YzYwNTAxNjViYmE1MmVhYjdlZjM1ODFkNDQ3ZWIyMTVk
ZWY3NyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWls
ZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctcjAtMDMxOC05NzhjNjA1MDE2NWJiYTUyZWFiN2Vm
MzU4MWQ0NDdlYjIxNWRlZjc3CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctcjAtMDMxOC85NzhjNjA1MDE2NWJiYTUyZWFiN2VmMzU4MWQ0NDdlYjIxNWRl
Zjc3CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1
ZS9pMzg2LXJhbmRjb25maWctcjAtMDMxOC05NzhjNjA1MDE2NWJiYTUyZWFiN2VmMzU4MWQ0
NDdlYjIxNWRlZjc3CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9i
dWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLXIwLTAzMTgtOTc4YzYwNTAxNjViYmE1MmVh
YjdlZjM1ODFkNDQ3ZWIyMTVkZWY3NwprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXIwLTAzMTgvOTc4YzYwNTAxNjViYmE1MmVhYjdlZjM1ODFkNDQ3ZWIyMTVkZWY3Ny92bWxp
bnV6LTMuMTQuMC1yYzQtMTE5MjYtZzk3OGM2MDUKCjIwMTQtMDMtMTktMDE6MDI6NTIgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uIFRFU1QgRkFJTFVSRQpbICAgIDMuODkxOTg2XSBbVFRN
XSBJbml0aWFsaXppbmcgcG9vbCBhbGxvY2F0b3IKWyAgICAzLjg5MjYwMl0gW1RUTV0gSW5p
dGlhbGl6aW5nIERNQSBwb29sIGFsbG9jYXRvcgpbICAgIDMuODkzMzM1XSAtLS0tLS0tLS0t
LS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAzLjg5NDAxNV0gV0FSTklORzogQ1BV
OiAxIFBJRDogMSBhdCBkcml2ZXJzL2dwdS9kcm0vZHJtX2NydGMuYzo5NCBkcm1fd2Fybl9v
bl9tb2Rlc2V0X25vdF9hbGxfbG9ja2VkKzB4M2MvMHg2MSgpClsgICAgMy44OTU3NjldIENQ
VTogMSBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTQuMC1yYzQtMTE5
MjYtZzk3OGM2MDUgIzQKWyAgICAzLjg5Njc4NV0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9j
aHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDMuODk3NTgzXSAgMDAwMDAwMDAgMDAw
MDAwMDAgNzgwM2JjZDQgNzljZTZlYmUgMDAwMDAwMDAgNzgwM2JkMDQgNzkwNTVhNDEgN2Ew
M2I0ZjkKWyAgICAzLjg5ODg1N10gIDAwMDAwMDAxIDAwMDAwMDAxIDdhMGIzZWZhIDAwMDAw
MDVlIDc5NGYyMzc3IDc5NGYyMzc3IDgwZThkODAwIDgwZTdlODAwClsgICAgMy45MDAxNzhd
ICA4MGU3ZTllOCA3ODAzYmQxNCA3OTA1NWFmNiAwMDAwMDAwOSAwMDAwMDAwMCA3ODAzYmQy
OCA3OTRmMjM3NyA4MGU4NDg4MApbICAgIDMuOTAxMzg2XSBDYWxsIFRyYWNlOgpbICAgIDMu
OTAxNzU1XSAgWzw3OWNlNmViZT5dIGR1bXBfc3RhY2srMHg0OC8weDYwClsgICAgMy45MDIz
ODZdICBbPDc5MDU1YTQxPl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg2Zi8weDg2ClsgICAg
My45MDMxMjVdICBbPDc5NGYyMzc3Pl0gPyBkcm1fd2Fybl9vbl9tb2Rlc2V0X25vdF9hbGxf
bG9ja2VkKzB4M2MvMHg2MQpbICAgIDMuOTA0MDI5XSAgWzw3OTRmMjM3Nz5dID8gZHJtX3dh
cm5fb25fbW9kZXNldF9ub3RfYWxsX2xvY2tlZCsweDNjLzB4NjEKWyAgICAzLjkwNDg5NF0g
IFs8NzkwNTVhZjY+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgxZC8weDFmClsgICAgMy45MDU1
OTddICBbPDc5NGYyMzc3Pl0gZHJtX3dhcm5fb25fbW9kZXNldF9ub3RfYWxsX2xvY2tlZCsw
eDNjLzB4NjEKWyAgICAzLjkwNjQ4OF0gIFs8Nzk0ZTQ1MTY+XSBkcm1faGVscGVyX2Rpc2Fi
bGVfdW51c2VkX2Z1bmN0aW9ucysweGQvMHhjZgpbICAgIDMuOTA3NDE2XSAgWzw3OTYxOWEy
YT5dIGNpcnJ1c19mYmRldl9pbml0KzB4NjEvMHg3YwpbICAgIDMuOTA4MTMzXSAgWzw3OTYx
OTMzOT5dIGNpcnJ1c19tb2Rlc2V0X2luaXQrMHgxM2YvMHgxODgKWyAgICAzLjkwODg2OV0g
IFs8Nzk2MTg2YWI+XSBjaXJydXNfZHJpdmVyX2xvYWQrMHg4OS8weGQ0ClsgICAgMy45MDk1
OTddICBbPDc5NGVlZDIxPl0gZHJtX2Rldl9yZWdpc3RlcisweDY3LzB4YzkKWyAgICAzLjkx
MDMxNV0gIFs8Nzk0ZjA2NmI+XSBkcm1fZ2V0X3BjaV9kZXYrMHhkNy8weDE4YQpbICAgIDMu
OTExMDI3XSAgWzw3OWNmZWE3Yz5dID8gbXV0ZXhfdW5sb2NrKzB4OC8weGEKWyAgICAzLjkx
MTY3N10gIFs8Nzk2MTk0MzA+XSBjaXJydXNfcGNpX3Byb2JlKzB4N2QvMHg4OQpbICAgIDMu
OTEyNDA0XSAgWzw3OTNlZmEwMT5dIHBjaV9kZXZpY2VfcHJvYmUrMHg0NC8weDg1ClsgICAg
My45MTMxNDBdICBbPDc5MTIyZjk3Pl0gPyBzeXNmc19jcmVhdGVfbGluaysweDI3LzB4MmYK
WyAgICAzLjkxMzg4OF0gIFs8Nzk2Y2QwZTc+XSBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4ODgv
MHgxN2EKWyAgICAzLjkxNDYyOV0gIFs8NzkzZWY4ODI+XSA/IHBjaV9tYXRjaF9kZXZpY2Ur
MHg5Ny8weDlkClsgICAgMy45MTUzNjddICBbPDc5NmNkMjRjPl0gX19kcml2ZXJfYXR0YWNo
KzB4NDcvMHg2MwpbICAgIDMuOTE2MDU5XSAgWzw3OTZjYmY2Nz5dIGJ1c19mb3JfZWFjaF9k
ZXYrMHg1NS8weDVmClsgICAgMy45MTY3MzddICBbPDc5NmNkMDIwPl0gZHJpdmVyX2F0dGFj
aCsweDE3LzB4MTkKWyAgICAzLjkxNzQwM10gIFs8Nzk2Y2QyMDU+XSA/IF9fZGV2aWNlX2F0
dGFjaCsweDJjLzB4MmMKWyAgICAzLjkxODExNV0gIFs8Nzk2Y2M1NTk+XSBidXNfYWRkX2Ry
aXZlcisweGQxLzB4MTk4ClsgICAgMy45MTg3OTldICBbPDc5NmNkN2ZhPl0gZHJpdmVyX3Jl
Z2lzdGVyKzB4N2EvMHhhZQpbICAgIDMuOTE5NDg4XSAgWzw3OTNlZjhkYj5dIF9fcGNpX3Jl
Z2lzdGVyX2RyaXZlcisweDJkLzB4MzAKWyAgICAzLjkyMDMwMl0gIFs8N2EyZTU1ODM+XSA/
IG1nYWcyMDBfaW5pdCsweDIzLzB4MjMKWyAgICAzLjkyMDk5MV0gIFs8Nzk0ZjA3N2E+XSBk
cm1fcGNpX2luaXQrMHg1Yy8weGQzClsgICAgMy45MjE2NTddICBbPDdhMmU1NTgzPl0gPyBt
Z2FnMjAwX2luaXQrMHgyMy8weDIzClsgICAgMy45MjIzNjZdICBbPDdhMmU1NTllPl0gY2ly
cnVzX2luaXQrMHgxYi8weDIzClsgICAgMy45MjMwMzFdICBbPDdhMmI4YTY0Pl0gZG9fb25l
X2luaXRjYWxsKzB4ODIvMHgxMGIKWyAgICAzLjkyMzcxOV0gIFs8N2EyYjg0Mjg+XSA/IHJl
cGFpcl9lbnZfc3RyaW5nKzB4MTIvMHg1MQpbICAgIDMuOTI0NDM0XSAgWzw3OTA2NmYzMT5d
ID8gcGFyc2VfYXJncysweDE2OC8weDIyNApbICAgIDMuOTI1MTI1XSAgWzw3YTJiOGMzYj5d
IGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MTRlLzB4MWU1ClsgICAgMy45MjU4NzhdICBbPDdh
MmI4NDE2Pl0gPyBkb19lYXJseV9wYXJhbSsweDc4LzB4NzgKWyAgICAzLjkyNjU4MV0gIFs8
NzljZGU3YzA+XSBrZXJuZWxfaW5pdCsweGIvMHhjNgpbICAgIDMuOTI3MjQzXSAgWzw3OWQw
MDZiNz5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDI4ClsgICAgMy45MjgwMjBd
ICBbPDc5Y2RlN2I1Pl0gPyByZXN0X2luaXQrMHg2ZC8weDZkClsgICAgMy45Mjg2NzldIC0t
LVsgZW5kIHRyYWNlIGM5YTVmNDczODRiZmNlZDEgXS0tLQpbICAgIDMuOTI5MzQxXSAtLS0t
LS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctcjAtMDMxOC85NzhjNjA1MDE2NWJiYTUyZWFiN2VmMzU4MWQ0NDdlYjIxNWRlZjc3L2Rt
ZXNnLXF1YW50YWwtcm9hbS0yNjoyMDE0MDMxOTAxMDQwMDppMzg2LXJhbmRjb25maWctcjAt
MDMxODozLjE0LjAtcmM0LTExOTI2LWc5NzhjNjA1OjQKMDoxOjEgYWxsX2dvb2Q6YmFkOmFs
bF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDMtMTkgMDE6MDQ6MjQgUkVQRUFUIENPVU5UOiAy
MCAgIyAva2VybmVsLXRlc3RzL2xpbnV4Ni9vYmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNl
Y3Rpbmc6IDIyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA1
IHN0ZXBzKQpbZTQwZDY0MTA5OTIxMzE0NWEwMzQ5ODFlNjQ2ZGMyMTgwYTQ4ODE1Ml0gTWVy
Z2UgYnJhbmNoICdkcm0tbWlub3InIG9mIGdpdDovL3Blb3BsZS5mcmVlZGVza3RvcC5vcmcv
fmR2ZGhybS9saW51eCBpbnRvIGRybS1uZXh0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4Ni9vYmotYmlz
ZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
cjAtMDMxOC9saW51eC1kZXZlbDpkZXZlbC1yb2FtLWkzODYtMjAxNDAzMTgyMjQ4OmU0MGQ2
NDEwOTkyMTMxNDVhMDM0OTgxZTY0NmRjMjE4MGE0ODgxNTI6YmlzZWN0LWxpbnV4NgoKMjAx
NC0wMy0xOS0wMTowNDoyNSBlNDBkNjQxMDk5MjEzMTQ1YTAzNDk4MWU2NDZkYzIxODBhNDg4
MTUyIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxk
LXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1yMC0wMzE4LWU0MGQ2NDEwOTkyMTMxNDVhMDM0OTgx
ZTY0NmRjMjE4MGE0ODgxNTIKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1yMC0wMzE4L2U0MGQ2NDEwOTkyMTMxNDVhMDM0OTgxZTY0NmRjMjE4MGE0ODgx
NTIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVl
L2kzODYtcmFuZGNvbmZpZy1yMC0wMzE4LWU0MGQ2NDEwOTkyMTMxNDVhMDM0OTgxZTY0NmRj
MjE4MGE0ODgxNTIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1
aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWctcjAtMDMxOC1lNDBkNjQxMDk5MjEzMTQ1YTAz
NDk4MWU2NDZkYzIxODBhNDg4MTUyCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
cjAtMDMxOC9lNDBkNjQxMDk5MjEzMTQ1YTAzNDk4MWU2NDZkYzIxODBhNDg4MTUyL3ZtbGlu
dXotMy4xNC4wLXJjNC0wMDMyMS1nZTQwZDY0MQoKMjAxNC0wMy0xOS0wMToxMToyNiBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAuLi4JMwk4CTkJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxMSBy
ZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNCBzdGVwcykKWzNl
NzAyOTJjZDRhMDAyY2Q3OTlhMWNkNDExNTI4NmNiYTM5MzNkNmRdIGRybS9tb2RlczogZHJv
cCBtYXhQaXRjaCBmcm9tIGRybV9tb2RlX3ZhbGlkYXRlX3NpemUKcnVubmluZyAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGlu
dXg2L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYt
cmFuZGNvbmZpZy1yMC0wMzE4L2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0MDMx
ODIyNDg6M2U3MDI5MmNkNGEwMDJjZDc5OWExY2Q0MTE1Mjg2Y2JhMzkzM2Q2ZDpiaXNlY3Qt
bGludXg2CgoyMDE0LTAzLTE5LTAxOjE1OjAyIDNlNzAyOTJjZDRhMDAyY2Q3OTlhMWNkNDEx
NTI4NmNiYTM5MzNkNmQgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwt
dGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXIwLTAzMTgtM2U3MDI5MmNkNGEw
MDJjZDc5OWExY2Q0MTE1Mjg2Y2JhMzkzM2Q2ZApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXIwLTAzMTgvM2U3MDI5MmNkNGEwMDJjZDc5OWExY2Q0MTE1
Mjg2Y2JhMzkzM2Q2ZAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMv
YnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXIwLTAzMTgtM2U3MDI5MmNkNGEwMDJjZDc5
OWExY2Q0MTE1Mjg2Y2JhMzkzM2Q2ZAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJu
ZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1yMC0wMzE4LTNlNzAyOTJj
ZDRhMDAyY2Q3OTlhMWNkNDExNTI4NmNiYTM5MzNkNmQKa2VybmVsOiAva2VybmVsL2kzODYt
cmFuZGNvbmZpZy1yMC0wMzE4LzNlNzAyOTJjZDRhMDAyY2Q3OTlhMWNkNDExNTI4NmNiYTM5
MzNkNmQvdm1saW51ei0zLjE0LjAtcmM0LTAwMzI0LWczZTcwMjkyCgoyMDE0LTAzLTE5LTAx
OjIwOjA0IGRldGVjdGluZyBib290IHN0YXRlIC4uCTYJMTQJMTYJMTkJMjAgU1VDQ0VTUwoK
QmlzZWN0aW5nOiA1IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hs
eSAzIHN0ZXBzKQpbMDBkNzYyY2JkMWZiNWRmNjNiZjAwNWZmYTFjOGQwMjc1Zjc5ODkwZV0g
ZHJtOiBkcm9wIGVycm9yIGNvZGUgZm9yIGRybV9oZWxwZXJfcmVzdW1lX2ZvcmNlX21vZGUK
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9r
ZXJuZWwtdGVzdHMvbGludXg2L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4t
cXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yMC0wMzE4L2xpbnV4LWRldmVsOmRldmVsLXJv
YW0taTM4Ni0yMDE0MDMxODIyNDg6MDBkNzYyY2JkMWZiNWRmNjNiZjAwNWZmYTFjOGQwMjc1
Zjc5ODkwZTpiaXNlY3QtbGludXg2CgoyMDE0LTAzLTE5LTAxOjIzOjQxIDAwZDc2MmNiZDFm
YjVkZjYzYmYwMDVmZmExYzhkMDI3NWY3OTg5MGUgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0
YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXIwLTAz
MTgtMDBkNzYyY2JkMWZiNWRmNjNiZjAwNWZmYTFjOGQwMjc1Zjc5ODkwZQpDaGVjayBmb3Ig
a2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIwLTAzMTgvMDBkNzYyY2JkMWZi
NWRmNjNiZjAwNWZmYTFjOGQwMjc1Zjc5ODkwZQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9m
IC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXIwLTAzMTgtMDBk
NzYyY2JkMWZiNWRmNjNiZjAwNWZmYTFjOGQwMjc1Zjc5ODkwZQp3YWl0aW5nIGZvciBjb21w
bGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1y
MC0wMzE4LTAwZDc2MmNiZDFmYjVkZjYzYmYwMDVmZmExYzhkMDI3NWY3OTg5MGUKa2VybmVs
OiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMC0wMzE4LzAwZDc2MmNiZDFmYjVkZjYzYmYw
MDVmZmExYzhkMDI3NWY3OTg5MGUvdm1saW51ei0zLjE0LjAtcmM0LTAwMzMwLWcwMGQ3NjJj
CgoyMDE0LTAzLTE5LTAxOjI4OjQyIGRldGVjdGluZyBib290IHN0YXRlIC4uLi4gVEVTVCBG
QUlMVVJFClsgICAgMy41NzIwMTBdIFtUVE1dIEluaXRpYWxpemluZyBwb29sIGFsbG9jYXRv
cgpbICAgIDMuNTcyNTQ2XSBbVFRNXSBJbml0aWFsaXppbmcgRE1BIHBvb2wgYWxsb2NhdG9y
ClsgICAgMy41NzMxOTNdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpb
ICAgIDMuNTczNzkwXSBXQVJOSU5HOiBDUFU6IDEgUElEOiAxIGF0IGRyaXZlcnMvZ3B1L2Ry
bS9kcm1fY3J0Yy5jOjg5IGRybV93YXJuX29uX21vZGVzZXRfbm90X2FsbF9sb2NrZWQrMHgz
Yy8weDYxKCkKWyAgICAzLjU3NTI3M10gQ1BVOiAxIFBJRDogMSBDb21tOiBzd2FwcGVyLzAg
Tm90IHRhaW50ZWQgMy4xNC4wLXJjNC0wMDMzMC1nMDBkNzYyYyAjNwpbICAgIDMuNTc2MTc3
XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsg
ICAgMy41NzY4NjVdICAwMDAwMDAwMCAwMDAwMDAwMCA3ODAzYmNkOCA3OWNlN2JiZSAwMDAw
MDAwMCA3ODAzYmQwOCA3OTA1NWE0MSA3YTAzYmU5NwpbICAgIDMuNTc3OTI5XSAgMDAwMDAw
MDEgMDAwMDAwMDEgN2EwYjQ4YjYgMDAwMDAwNTkgNzk0ZjI0MjIgNzk0ZjI0MjIgODBlOTA4
MDAgODBlODI4MDAKWyAgICAzLjU3ODk4OV0gIDgwZTgyOWUwIDc4MDNiZDE4IDc5MDU1YWY2
IDAwMDAwMDA5IDAwMDAwMDAwIDc4MDNiZDJjIDc5NGYyNDIyIDgwZTg4ODgwClsgICAgMy41
ODAwNzVdIENhbGwgVHJhY2U6ClsgICAgMy41ODA0MDFdICBbPDc5Y2U3YmJlPl0gZHVtcF9z
dGFjaysweDQ4LzB4NjAKWyAgICAzLjU4MDk1M10gIFs8NzkwNTVhNDE+XSB3YXJuX3Nsb3dw
YXRoX2NvbW1vbisweDZmLzB4ODYKWyAgICAzLjU4MTYwNF0gIFs8Nzk0ZjI0MjI+XSA/IGRy
bV93YXJuX29uX21vZGVzZXRfbm90X2FsbF9sb2NrZWQrMHgzYy8weDYxClsgICAgMy41ODI0
MTBdICBbPDc5NGYyNDIyPl0gPyBkcm1fd2Fybl9vbl9tb2Rlc2V0X25vdF9hbGxfbG9ja2Vk
KzB4M2MvMHg2MQpbICAgIDMuNTgzMjEyXSAgWzw3OTA1NWFmNj5dIHdhcm5fc2xvd3BhdGhf
bnVsbCsweDFkLzB4MWYKWyAgICAzLjU4MzgzNl0gIFs8Nzk0ZjI0MjI+XSBkcm1fd2Fybl9v
bl9tb2Rlc2V0X25vdF9hbGxfbG9ja2VkKzB4M2MvMHg2MQpbICAgIDMuNTg0NjM0XSAgWzw3
OTRlNDUxNj5dIGRybV9oZWxwZXJfZGlzYWJsZV91bnVzZWRfZnVuY3Rpb25zKzB4ZC8weGNm
ClsgICAgMy41ODU0MjddICBbPDc5NjE5ZTc0Pl0gY2lycnVzX2ZiZGV2X2luaXQrMHg2MS8w
eDdjClsgICAgMy41ODYwNDZdICBbPDc5NjE5NzgwPl0gY2lycnVzX21vZGVzZXRfaW5pdCsw
eDE0Mi8weDE4YgpbICAgIDMuNTg2NzAwXSAgWzw3OTYxOGFlMD5dIGNpcnJ1c19kcml2ZXJf
bG9hZCsweDhjLzB4ZDcKWyAgICAzLjU4NzMxM10gIFs8Nzk0ZWVkNmQ+XSBkcm1fZGV2X3Jl
Z2lzdGVyKzB4YjEvMHgxMTQKWyAgICAzLjU4NzkyNV0gIFs8Nzk0ZjA2ZjE+XSBkcm1fZ2V0
X3BjaV9kZXYrMHhkZC8weDE5YQpbICAgIDMuNTg4NTI0XSAgWzw3OWNmZjkyYz5dID8gbXV0
ZXhfdW5sb2NrKzB4OC8weGEKWyAgICAzLjU4OTA4OV0gIFs8Nzk2MTk4Nzc+XSBjaXJydXNf
cGNpX3Byb2JlKzB4N2QvMHg4OQpbICAgIDMuNTg5NzA1XSAgWzw3OTNlZmEwMT5dIHBjaV9k
ZXZpY2VfcHJvYmUrMHg0NC8weDg1ClsgICAgMy41OTAzMzVdICBbPDc5MTIyZjk3Pl0gPyBz
eXNmc19jcmVhdGVfbGluaysweDI3LzB4MmYKWyAgICAzLjU5MDk3N10gIFs8Nzk2Y2RkZjA+
XSBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4ODgvMHgxN2EKWyAgICAzLjU5MTYzNF0gIFs8Nzkz
ZWY4ODI+XSA/IHBjaV9tYXRjaF9kZXZpY2UrMHg5Ny8weDlkClsgICAgMy41OTIyNTJdICBb
PDc5NmNkZjU1Pl0gX19kcml2ZXJfYXR0YWNoKzB4NDcvMHg2MwpbICAgIDMuNTkyODQ4XSAg
Wzw3OTZjY2M3MD5dIGJ1c19mb3JfZWFjaF9kZXYrMHg1NS8weDVmClsgICAgMy41OTM0NDRd
ICBbPDc5NmNkZDI5Pl0gZHJpdmVyX2F0dGFjaCsweDE3LzB4MTkKWyAgICAzLjU5NDAxNl0g
IFs8Nzk2Y2RmMGU+XSA/IF9fZGV2aWNlX2F0dGFjaCsweDJjLzB4MmMKWyAgICAzLjU5NDYz
Ml0gIFs8Nzk2Y2QyNjI+XSBidXNfYWRkX2RyaXZlcisweGQxLzB4MTk4ClsgICAgMy41OTUy
MTddICBbPDc5NmNlNTAzPl0gZHJpdmVyX3JlZ2lzdGVyKzB4N2EvMHhhZQpbICAgIDMuNTk1
ODExXSAgWzw3OTNlZjhkYj5dIF9fcGNpX3JlZ2lzdGVyX2RyaXZlcisweDJkLzB4MzAKWyAg
ICAzLjU5NjQ3N10gIFs8N2EyZTU1ODM+XSA/IG1nYWcyMDBfaW5pdCsweDIzLzB4MjMKWyAg
ICAzLjU5NzA2NV0gIFs8Nzk0ZjA4MGE+XSBkcm1fcGNpX2luaXQrMHg1Yy8weGQzClsgICAg
My41OTc2MjZdICBbPDdhMmU1NTgzPl0gPyBtZ2FnMjAwX2luaXQrMHgyMy8weDIzClsgICAg
My41OTgyMDNdICBbPDdhMmU1NTllPl0gY2lycnVzX2luaXQrMHgxYi8weDIzClsgICAgMy41
OTg3NThdICBbPDdhMmI4YTY0Pl0gZG9fb25lX2luaXRjYWxsKzB4ODIvMHgxMGIKWyAgICAz
LjU5OTM1MV0gIFs8N2EyYjg0Mjg+XSA/IHJlcGFpcl9lbnZfc3RyaW5nKzB4MTIvMHg1MQpb
ICAgIDMuNTk5OTg2XSAgWzw3OTA2NmYzMT5dID8gcGFyc2VfYXJncysweDE2OC8weDIyNApb
ICAgIDMuNjAwNTg1XSAgWzw3YTJiOGMzYj5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MTRl
LzB4MWU1ClsgICAgMy42MDEyNTJdICBbPDdhMmI4NDE2Pl0gPyBkb19lYXJseV9wYXJhbSsw
eDc4LzB4NzgKWyAgICAzLjYwMTg3Ml0gIFs8NzljZGY0YzA+XSBrZXJuZWxfaW5pdCsweGIv
MHhjNgpbICAgIDMuNjAyNDA2XSAgWzw3OWQwMTU1Nz5dIHJldF9mcm9tX2tlcm5lbF90aHJl
YWQrMHgxYi8weDI4ClsgICAgMy42MDMwNjhdICBbPDc5Y2RmNGI1Pl0gPyByZXN0X2luaXQr
MHg2ZC8weDZkClsgICAgMy42MDM2MjJdIC0tLVsgZW5kIHRyYWNlIDVjOGIyZWNmMzM4Yzlj
NTQgXS0tLQpbICAgIDMuNjA0MTczXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0t
LS0tLS0KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAtMDMxOC8wMGQ3NjJjYmQxZmI1ZGY2
M2JmMDA1ZmZhMWM4ZDAyNzVmNzk4OTBlL2RtZXNnLXF1YW50YWwtY2Fpcm8tODoyMDE0MDMx
OTAxMzAyNzppMzg2LXJhbmRjb25maWctcjAtMDMxODozLjE0LjAtcmM0LTAwMzMwLWcwMGQ3
NjJjOjcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAtMDMxOC8wMGQ3NjJjYmQxZmI1ZGY2
M2JmMDA1ZmZhMWM4ZDAyNzVmNzk4OTBlL2RtZXNnLXlvY3RvLWF0aGVucy0zOToyMDE0MDMx
OTAxMzAyMjppMzg2LXJhbmRjb25maWctcjAtMDMxODozLjE0LjAtcmM0LTAwMzMwLWcwMGQ3
NjJjOjcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAtMDMxOC8wMGQ3NjJjYmQxZmI1ZGY2
M2JmMDA1ZmZhMWM4ZDAyNzVmNzk4OTBlL2RtZXNnLXF1YW50YWwtYXRoZW5zLTE1OjIwMTQw
MzE5MDEzMDMzOmkzODYtcmFuZGNvbmZpZy1yMC0wMzE4OjMuMTQuMC1yYzQtMDAzMzAtZzAw
ZDc2MmM6Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMC0wMzE4LzAwZDc2MmNiZDFmYjVk
ZjYzYmYwMDVmZmExYzhkMDI3NWY3OTg5MGUvZG1lc2ctcXVhbnRhbC1hdGhlbnMtMjY6MjAx
NDAzMTkwMTMwMzk6aTM4Ni1yYW5kY29uZmlnLXIwLTAzMTg6My4xNC4wLXJjNC0wMDMzMC1n
MDBkNzYyYzo3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIwLTAzMTgvMDBkNzYyY2JkMWZi
NWRmNjNiZjAwNWZmYTFjOGQwMjc1Zjc5ODkwZS9kbWVzZy1xdWFudGFsLWNhaXJvLTQ1OjIw
MTQwMzE5MDEzMDQzOmkzODYtcmFuZGNvbmZpZy1yMC0wMzE4OjMuMTQuMC1yYzQtMDAzMzAt
ZzAwZDc2MmM6NwowOjU6MyBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKQmlzZWN0aW5n
OiAyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAyIHN0ZXBz
KQpbOWVlOTg0YTVmNzM1ZDZhZmM2Zjg4OWUxNzliMmU0YjFmMmVjMzM1Zl0gZHJtL2RvYzog
Rml4IG1pc3BsYWNlZCA8L3BhcmE+CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4Ni9vYmotYmlzZWN0Cmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctcjAtMDMx
OC9saW51eC1kZXZlbDpkZXZlbC1yb2FtLWkzODYtMjAxNDAzMTgyMjQ4OjllZTk4NGE1Zjcz
NWQ2YWZjNmY4ODllMTc5YjJlNGIxZjJlYzMzNWY6YmlzZWN0LWxpbnV4NgoKMjAxNC0wMy0x
OS0wMTozMTowMCA5ZWU5ODRhNWY3MzVkNmFmYzZmODg5ZTE3OWIyZTRiMWYyZWMzMzVmIGNv
bXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVl
L2kzODYtcmFuZGNvbmZpZy1yMC0wMzE4LTllZTk4NGE1ZjczNWQ2YWZjNmY4ODllMTc5YjJl
NGIxZjJlYzMzNWYKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1yMC0wMzE4LzllZTk4NGE1ZjczNWQ2YWZjNmY4ODllMTc5YjJlNGIxZjJlYzMzNWYKd2Fp
dGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYt
cmFuZGNvbmZpZy1yMC0wMzE4LTllZTk4NGE1ZjczNWQ2YWZjNmY4ODllMTc5YjJlNGIxZjJl
YzMzNWYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1
ZXVlLy5pMzg2LXJhbmRjb25maWctcjAtMDMxOC05ZWU5ODRhNWY3MzVkNmFmYzZmODg5ZTE3
OWIyZTRiMWYyZWMzMzVmCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAtMDMx
OC85ZWU5ODRhNWY3MzVkNmFmYzZmODg5ZTE3OWIyZTRiMWYyZWMzMzVmL3ZtbGludXotMy4x
NC4wLXJjNC0wMDMyNy1nOWVlOTg0YQoKMjAxNC0wMy0xOS0wMTozODowMSBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAuLi4JNAkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxl
ZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKWzYyZmY5NGE1NDkyMTc1
NzU5NTQ2ZjhiYzYxMzgzMTg5ZDZiNDkxMjJdIGRybS9jcnRjLWhlbHBlcjogcmVtb3ZlIExP
Q0tJTkcgZnJvbSBrZXJuZWxkb2MKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg2L29iai1iaXNlY3QKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yMC0wMzE4
L2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0MDMxODIyNDg6NjJmZjk0YTU0OTIx
NzU3NTk1NDZmOGJjNjEzODMxODlkNmI0OTEyMjpiaXNlY3QtbGludXg2CgoyMDE0LTAzLTE5
LTAxOjQwOjMzIDYyZmY5NGE1NDkyMTc1NzU5NTQ2ZjhiYzYxMzgzMTg5ZDZiNDkxMjIgY29t
cGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUv
aTM4Ni1yYW5kY29uZmlnLXIwLTAzMTgtNjJmZjk0YTU0OTIxNzU3NTk1NDZmOGJjNjEzODMx
ODlkNmI0OTEyMgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXIwLTAzMTgvNjJmZjk0YTU0OTIxNzU3NTk1NDZmOGJjNjEzODMxODlkNmI0OTEyMgp3YWl0
aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1y
YW5kY29uZmlnLXIwLTAzMTgtNjJmZjk0YTU0OTIxNzU3NTk1NDZmOGJjNjEzODMxODlkNmI0
OTEyMgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVl
dWUvLmkzODYtcmFuZGNvbmZpZy1yMC0wMzE4LTYyZmY5NGE1NDkyMTc1NzU5NTQ2ZjhiYzYx
MzgzMTg5ZDZiNDkxMjIKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMC0wMzE4
LzYyZmY5NGE1NDkyMTc1NzU5NTQ2ZjhiYzYxMzgzMTg5ZDZiNDkxMjIvdm1saW51ei0zLjE0
LjAtcmM0LTAwMzI5LWc2MmZmOTRhCgoyMDE0LTAzLTE5LTAyOjAxOjM0IGRldGVjdGluZyBi
b290IHN0YXRlIC4uLiBURVNUIEZBSUxVUkUKWyAgICAzLjQ2MDE0NF0gW1RUTV0gSW5pdGlh
bGl6aW5nIHBvb2wgYWxsb2NhdG9yClsgICAgMy40NjA1MzhdIFtUVE1dIEluaXRpYWxpemlu
ZyBETUEgcG9vbCBhbGxvY2F0b3IKWyAgICAzLjQ2MTAxN10gLS0tLS0tLS0tLS0tWyBjdXQg
aGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMy40NjE0NDddIFdBUk5JTkc6IENQVTogMCBQSUQ6
IDEgYXQgZHJpdmVycy9ncHUvZHJtL2RybV9jcnRjLmM6ODkgZHJtX3dhcm5fb25fbW9kZXNl
dF9ub3RfYWxsX2xvY2tlZCsweDNjLzB4NjEoKQpbICAgIDMuNDYyNTI5XSBDUFU6IDAgUElE
OiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE0LjAtcmM0LTAwMzI5LWc2MmZm
OTRhICMxMApbICAgIDMuNDYzMTg4XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklP
UyBCb2NocyAwMS8wMS8yMDExClsgICAgMy40NjM2ODVdICAwMDAwMDAwMCAwMDAwMDAwMCA3
ODAzYmNkOCA3OWNlN2JiZSAwMDAwMDAwMCA3ODAzYmQwOCA3OTA1NWE0MSA3YTAzYmU5Nwpb
ICAgIDMuNDY0NDU1XSAgMDAwMDAwMDAgMDAwMDAwMDEgN2EwYjQ4YjYgMDAwMDAwNTkgNzk0
ZjI0MjQgNzk0ZjI0MjQgNzgxYzYwMDAgODBkZDQ4MDAKWyAgICAzLjQ2NTIxOV0gIDgwZGQ0
OWUwIDc4MDNiZDE4IDc5MDU1YWY2IDAwMDAwMDA5IDAwMDAwMDAwIDc4MDNiZDJjIDc5NGYy
NDI0IDgwZGQ1MTgwClsgICAgMy40NjU5ODVdIENhbGwgVHJhY2U6ClsgICAgMy40NjYyMTld
ICBbPDc5Y2U3YmJlPl0gZHVtcF9zdGFjaysweDQ4LzB4NjAKWyAgICAzLjQ2NjYxNl0gIFs8
NzkwNTVhNDE+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDZmLzB4ODYKWyAgICAzLjQ2NzA4
M10gIFs8Nzk0ZjI0MjQ+XSA/IGRybV93YXJuX29uX21vZGVzZXRfbm90X2FsbF9sb2NrZWQr
MHgzYy8weDYxClsgICAgMy40Njc2NTddICBbPDc5NGYyNDI0Pl0gPyBkcm1fd2Fybl9vbl9t
b2Rlc2V0X25vdF9hbGxfbG9ja2VkKzB4M2MvMHg2MQpbICAgIDMuNDY4MjM5XSAgWzw3OTA1
NWFmNj5dIHdhcm5fc2xvd3BhdGhfbnVsbCsweDFkLzB4MWYKWyAgICAzLjQ2ODY4Ml0gIFs8
Nzk0ZjI0MjQ+XSBkcm1fd2Fybl9vbl9tb2Rlc2V0X25vdF9hbGxfbG9ja2VkKzB4M2MvMHg2
MQpbICAgIDMuNDY5MjUyXSAgWzw3OTRlNDUxNj5dIGRybV9oZWxwZXJfZGlzYWJsZV91bnVz
ZWRfZnVuY3Rpb25zKzB4ZC8weGNmClsgICAgMy40Njk4MjhdICBbPDc5NjE5ZTc2Pl0gY2ly
cnVzX2ZiZGV2X2luaXQrMHg2MS8weDdjClsgICAgMy40NzAyODZdICBbPDc5NjE5NzgyPl0g
Y2lycnVzX21vZGVzZXRfaW5pdCsweDE0Mi8weDE4YgpbICAgIDMuNDcwNzc4XSAgWzw3OTYx
OGFlMj5dIGNpcnJ1c19kcml2ZXJfbG9hZCsweDhjLzB4ZDcKWyAgICAzLjQ3MTI0NF0gIFs8
Nzk0ZWVkNmY+XSBkcm1fZGV2X3JlZ2lzdGVyKzB4YjEvMHgxMTQKWyAgICAzLjQ3MTY4MV0g
IFs8Nzk0ZjA2ZjM+XSBkcm1fZ2V0X3BjaV9kZXYrMHhkZC8weDE5YQpbICAgIDMuNDcyMTI2
XSAgWzw3OWNmZjkyYz5dID8gbXV0ZXhfdW5sb2NrKzB4OC8weGEKWyAgICAzLjQ3MjUzOV0g
IFs8Nzk2MTk4Nzk+XSBjaXJydXNfcGNpX3Byb2JlKzB4N2QvMHg4OQpbICAgIDMuNDcyOTgx
XSAgWzw3OTNlZmEwMT5dIHBjaV9kZXZpY2VfcHJvYmUrMHg0NC8weDg1ClsgICAgMy40NzM0
MjZdICBbPDc5MTIyZjk3Pl0gPyBzeXNmc19jcmVhdGVfbGluaysweDI3LzB4MmYKWyAgICAz
LjQ3Mzg4N10gIFs8Nzk2Y2RkZjI+XSBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4ODgvMHgxN2EK
WyAgICAzLjQ3NDM1MF0gIFs8NzkzZWY4ODI+XSA/IHBjaV9tYXRjaF9kZXZpY2UrMHg5Ny8w
eDlkClsgICAgMy40NzQ4MDFdICBbPDc5NmNkZjU3Pl0gX19kcml2ZXJfYXR0YWNoKzB4NDcv
MHg2MwpbICAgIDMuNDc1MjI2XSAgWzw3OTZjY2M3Mj5dIGJ1c19mb3JfZWFjaF9kZXYrMHg1
NS8weDVmClsgICAgMy40NzU2NThdICBbPDc5NmNkZDJiPl0gZHJpdmVyX2F0dGFjaCsweDE3
LzB4MTkKWyAgICAzLjQ3NjA3OV0gIFs8Nzk2Y2RmMTA+XSA/IF9fZGV2aWNlX2F0dGFjaCsw
eDJjLzB4MmMKWyAgICAzLjQ3NjUxOF0gIFs8Nzk2Y2QyNjQ+XSBidXNfYWRkX2RyaXZlcisw
eGQxLzB4MTk4ClsgICAgMy40NzY5NDZdICBbPDc5NmNlNTA1Pl0gZHJpdmVyX3JlZ2lzdGVy
KzB4N2EvMHhhZQpbICAgIDMuNDc3MzY2XSAgWzw3OTNlZjhkYj5dIF9fcGNpX3JlZ2lzdGVy
X2RyaXZlcisweDJkLzB4MzAKWyAgICAzLjQ3Nzg1OF0gIFs8N2EyZTU1ODM+XSA/IG1nYWcy
MDBfaW5pdCsweDIzLzB4MjMKWyAgICAzLjQ3ODI3NV0gIFs8Nzk0ZjA4MGM+XSBkcm1fcGNp
X2luaXQrMHg1Yy8weGQzClsgICAgMy40Nzg2NzNdICBbPDdhMmU1NTgzPl0gPyBtZ2FnMjAw
X2luaXQrMHgyMy8weDIzClsgICAgMy40NzkwOTZdICBbPDdhMmU1NTllPl0gY2lycnVzX2lu
aXQrMHgxYi8weDIzClsgICAgMy40Nzk1MTJdICBbPDdhMmI4YTY0Pl0gZG9fb25lX2luaXRj
YWxsKzB4ODIvMHgxMGIKWyAgICAzLjQ3OTk1N10gIFs8N2EyYjg0Mjg+XSA/IHJlcGFpcl9l
bnZfc3RyaW5nKzB4MTIvMHg1MQpbICAgIDMuNDgwNDMyXSAgWzw3OTA2NmYzMT5dID8gcGFy
c2VfYXJncysweDE2OC8weDIyNApbICAgIDMuNDgwODU4XSAgWzw3YTJiOGMzYj5dIGtlcm5l
bF9pbml0X2ZyZWVhYmxlKzB4MTRlLzB4MWU1ClsgICAgMy40ODEzMzZdICBbPDdhMmI4NDE2
Pl0gPyBkb19lYXJseV9wYXJhbSsweDc4LzB4NzgKWyAgICAzLjQ4MTc3NV0gIFs8NzljZGY0
YzA+XSBrZXJuZWxfaW5pdCsweGIvMHhjNgpbICAgIDMuNDgyMTYzXSAgWzw3OWQwMTU1Nz5d
IHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDI4ClsgICAgMy40ODI2NDVdICBbPDc5
Y2RmNGI1Pl0gPyByZXN0X2luaXQrMHg2ZC8weDZkClsgICAgMy40ODMwNjBdIC0tLVsgZW5k
IHRyYWNlIDFhYjQyZTE3NmUwODFjZDMgXS0tLQpbICAgIDMuNDgzNDY1XSAtLS0tLS0tLS0t
LS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAt
MDMxOC82MmZmOTRhNTQ5MjE3NTc1OTU0NmY4YmM2MTM4MzE4OWQ2YjQ5MTIyL2RtZXNnLXF1
YW50YWwtY2Fpcm8tMjk6MjAxNDAzMTkwMjAyNDk6aTM4Ni1yYW5kY29uZmlnLXIwLTAzMTg6
My4xNC4wLXJjNC0wMDMyOS1nNjJmZjk0YToxMAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1y
MC0wMzE4LzYyZmY5NGE1NDkyMTc1NzU5NTQ2ZjhiYzYxMzgzMTg5ZDZiNDkxMjIvZG1lc2ct
cXVhbnRhbC1jYWlyby0zNToyMDE0MDMxOTAyMDI1MDppMzg2LXJhbmRjb25maWctcjAtMDMx
ODozLjE0LjAtcmM0LTAwMzI5LWc2MmZmOTRhOjEwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXIwLTAzMTgvNjJmZjk0YTU0OTIxNzU3NTk1NDZmOGJjNjEzODMxODlkNmI0OTEyMi9kbWVz
Zy15b2N0by1pdnl0b3duMi0xNzoyMDE0MDMxOTAyMDI1OTppMzg2LXJhbmRjb25maWctcjAt
MDMxODozLjE0LjAtcmM0LTAwMzI5LWc2MmZmOTRhOjEwCjA6MzoyIGFsbF9nb29kOmJhZDph
bGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRl
ciB0aGlzIChyb3VnaGx5IDAgc3RlcHMpCls5ZmQ5Mzc4NGYxNzE5NTMyZDc5NjkxNDkzNWY4
N2NjMWM2YWZkNjg3XSBkcm06IHJlbW92ZSByZXR1cm4gdmFsdWUgZnJvbSBkcm1faGVscGVy
X21vZGVfZmlsbF9mYl9zdHJ1Y3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg2L29iai1iaXNlY3QKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yMC0wMzE4
L2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0MDMxODIyNDg6OWZkOTM3ODRmMTcx
OTUzMmQ3OTY5MTQ5MzVmODdjYzFjNmFmZDY4NzpiaXNlY3QtbGludXg2CgoyMDE0LTAzLTE5
LTAyOjAzOjA4IDlmZDkzNzg0ZjE3MTk1MzJkNzk2OTE0OTM1Zjg3Y2MxYzZhZmQ2ODcgY29t
cGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUv
aTM4Ni1yYW5kY29uZmlnLXIwLTAzMTgtOWZkOTM3ODRmMTcxOTUzMmQ3OTY5MTQ5MzVmODdj
YzFjNmFmZDY4NwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXIwLTAzMTgvOWZkOTM3ODRmMTcxOTUzMmQ3OTY5MTQ5MzVmODdjYzFjNmFmZDY4Nwp3YWl0
aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1y
YW5kY29uZmlnLXIwLTAzMTgtOWZkOTM3ODRmMTcxOTUzMmQ3OTY5MTQ5MzVmODdjYzFjNmFm
ZDY4Nwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVl
dWUvLmkzODYtcmFuZGNvbmZpZy1yMC0wMzE4LTlmZDkzNzg0ZjE3MTk1MzJkNzk2OTE0OTM1
Zjg3Y2MxYzZhZmQ2ODcKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMC0wMzE4
LzlmZDkzNzg0ZjE3MTk1MzJkNzk2OTE0OTM1Zjg3Y2MxYzZhZmQ2ODcvdm1saW51ei0zLjE0
LjAtcmM0LTAwMzI4LWc5ZmQ5Mzc4CgoyMDE0LTAzLTE5LTAyOjI0OjA5IGRldGVjdGluZyBi
b290IHN0YXRlIC4uLgkyMCBTVUNDRVNTCgo2MmZmOTRhNTQ5MjE3NTc1OTU0NmY4YmM2MTM4
MzE4OWQ2YjQ5MTIyIGlzIHRoZSBmaXJzdCBiYWQgY29tbWl0CmNvbW1pdCA2MmZmOTRhNTQ5
MjE3NTc1OTU0NmY4YmM2MTM4MzE4OWQ2YjQ5MTIyCkF1dGhvcjogRGFuaWVsIFZldHRlciA8
ZGFuaWVsLnZldHRlckBmZndsbC5jaD4KRGF0ZTogICBUaHUgSmFuIDIzIDIyOjE4OjQ3IDIw
MTQgKzAxMDAKCiAgICBkcm0vY3J0Yy1oZWxwZXI6IHJlbW92ZSBMT0NLSU5HIGZyb20ga2Vy
bmVsZG9jCiAgICAKICAgIC0gSXQgeWVsbHMuCiAgICAtIFdBUk5pbmcgYWJvdXQgaW5jb3Jy
ZWN0IGxvY2tpbmcgaXMgaGFyZGVyIHRvIGlnbm9yZSwgc28gYmV0dGVyCiAgICAgIHRoYW4g
a2VybmVsZG9jLgogICAgLSBTaW5jZSB0aG9zZSBoYXZlIGJlZW4gd3JpdHRlbiBwZXItY3J0
YyBsb2NrcyB3ZXJlIGFkZGVkIC4uLgogICAgCiAgICBTbyByZW1vdmUgdGhlbSBhbmQgcmVw
bGFjZSB0aGVtIGJ5IGFwcHJvcHJpYXRlIFdBUk5zLgogICAgCiAgICBSZXZpZXdlZC1ieTog
QWxleCBEZXVjaGVyIDxhbGV4YW5kZXIuZGV1Y2hlckBhbWQuY29tPgogICAgU2lnbmVkLW9m
Zi1ieTogRGFuaWVsIFZldHRlciA8ZGFuaWVsLnZldHRlckBmZndsbC5jaD4KCjowNDAwMDAg
MDQwMDAwIDExMmI1ZWIzNWE2MzM1NjgxODNjZGM3YmEzOGQyYzIwMmIzZmYxYmMgYjlkMzBh
YzU3ZDZmZmIzMTk1YTk1MDIyMTM3NWFhZjhiYjkyNjliZSBNCWRyaXZlcnMKYmlzZWN0IHJ1
biBzdWNjZXNzCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWctcjAtMDMxOC9saW51eC1kZXZlbDpkZXZlbC1yb2FtLWkzODYtMjAxNDAzMTgyMjQ4
OjlmZDkzNzg0ZjE3MTk1MzJkNzk2OTE0OTM1Zjg3Y2MxYzZhZmQ2ODc6YmlzZWN0LWxpbnV4
NgoKMjAxNC0wMy0xOS0wMjoyNjoxMiA5ZmQ5Mzc4NGYxNzE5NTMyZDc5NjkxNDkzNWY4N2Nj
MWM2YWZkNjg3IHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIwLTAzMTgvOWZkOTM3
ODRmMTcxOTUzMmQ3OTY5MTQ5MzVmODdjYzFjNmFmZDY4Ny92bWxpbnV6LTMuMTQuMC1yYzQt
MDAzMjgtZzlmZDkzNzgKCjIwMTQtMDMtMTktMDI6MjY6MTIgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgLi4uCTEJMTAJMTcJMjMJMjUJMjcJMzUJNDAJNDQJNTIJNTkuLi4uLi4uLi4uLi4uLi4u
Li4uLi4JNjAgU1VDQ0VTUwoKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kz
ODYtcmFuZGNvbmZpZy1yMC0wMzE4L2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0
MDMxODIyNDg6YWM5NmEyN2ViZmUxYWMxNjMxYTY3OWYyNDk5MTE0M2MxMjQxMjdiNTpiaXNl
Y3QtbGludXg2CiBURVNUIEZBSUxVUkUKWyAgICA1Ljk4ODMxNV0gW1RUTV0gSW5pdGlhbGl6
aW5nIHBvb2wgYWxsb2NhdG9yClsgICAgNS45ODkwMTFdIFtUVE1dIEluaXRpYWxpemluZyBE
TUEgcG9vbCBhbGxvY2F0b3IKWyAgICA1Ljk5MDAzNF0gLS0tLS0tLS0tLS0tWyBjdXQgaGVy
ZSBdLS0tLS0tLS0tLS0tClsgICAgNS45OTA4MTJdIFdBUk5JTkc6IENQVTogMCBQSUQ6IDEg
YXQgZHJpdmVycy9ncHUvZHJtL2RybV9jcnRjLmM6OTQgZHJtX3dhcm5fb25fbW9kZXNldF9u
b3RfYWxsX2xvY2tlZCsweDNjLzB4NjEoKQpbICAgIDUuOTkyNzYwXSBDUFU6IDAgUElEOiAx
IENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE0LjAtcmM3LTAwNzAzLWdhYzk2YTI3
ICMxMDMKWyAgICA1Ljk5Mzk2NV0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1Mg
Qm9jaHMgMDEvMDEvMjAxMQpbICAgIDUuOTk0ODY4XSAgMDAwMDAwMDAgMDAwMDAwMDAgNzgw
M2ZjZDQgNzljZWEzYjQgMDAwMDAwMDAgNzgwM2ZkMDQgNzkwNTVhODQgN2EwNGYwNTAKWyAg
ICA1Ljk5NjI1Ml0gIDAwMDAwMDAwIDAwMDAwMDAxIDdhMGM4ODM1IDAwMDAwMDVlIDc5NGYz
N2IyIDc5NGYzN2IyIDc4MWM3MDAwIDg0ZTkyODAwClsgICAgNS45OTc2NDVdICA4NGU5Mjlj
YyA3ODAzZmQxNCA3OTA1NWIzOSAwMDAwMDAwOSAwMDAwMDAwMCA3ODAzZmQyOCA3OTRmMzdi
MiA4NGU5MzE4MApbICAgIDUuOTk5MDMxXSBDYWxsIFRyYWNlOgpbICAgIDUuOTk5NDYxXSAg
Wzw3OWNlYTNiND5dIGR1bXBfc3RhY2srMHg0OC8weDYwClsgICAgNi4wMDAxOTFdICBbPDc5
MDU1YTg0Pl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg2Zi8weDg2ClsgICAgNi4wMDEwMzFd
ICBbPDc5NGYzN2IyPl0gPyBkcm1fd2Fybl9vbl9tb2Rlc2V0X25vdF9hbGxfbG9ja2VkKzB4
M2MvMHg2MQpbICAgIDYuMDAyMDg2XSAgWzw3OTRmMzdiMj5dID8gZHJtX3dhcm5fb25fbW9k
ZXNldF9ub3RfYWxsX2xvY2tlZCsweDNjLzB4NjEKWyAgICA2LjAwMzEzOV0gIFs8NzkwNTVi
Mzk+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgxZC8weDFmClsgICAgNi4wMDM5NTRdICBbPDc5
NGYzN2IyPl0gZHJtX3dhcm5fb25fbW9kZXNldF9ub3RfYWxsX2xvY2tlZCsweDNjLzB4NjEK
WyAgICA2LjAwNDk4M10gIFs8Nzk0ZTU4MTU+XSBkcm1faGVscGVyX2Rpc2FibGVfdW51c2Vk
X2Z1bmN0aW9ucysweGQvMHhjZgpbICAgIDYuMDA2MDI0XSAgWzw3OTYxYmEwNT5dIGNpcnJ1
c19mYmRldl9pbml0KzB4NjEvMHg3YwpbICAgIDYuMDA2ODI1XSAgWzw3OTYxYjMxND5dIGNp
cnJ1c19tb2Rlc2V0X2luaXQrMHgxM2YvMHgxODgKWyAgICA2LjAwNzY3Nl0gIFs8Nzk2MWE2
ODY+XSBjaXJydXNfZHJpdmVyX2xvYWQrMHg4OS8weGQ0ClsgICAgNi4wMDg0OTZdICBbPDc5
NGYwMTJmPl0gZHJtX2Rldl9yZWdpc3RlcisweDY3LzB4YzkKWyAgICA2LjAwOTI4MF0gIFs8
Nzk0ZjFhYTY+XSBkcm1fZ2V0X3BjaV9kZXYrMHhkNy8weDE4YQpbICAgIDYuMDEwMDkwXSAg
Wzw3OWQwMWYzYz5dID8gbXV0ZXhfdW5sb2NrKzB4OC8weGEKWyAgICA2LjAxMDgyN10gIFs8
Nzk2MWI0MGI+XSBjaXJydXNfcGNpX3Byb2JlKzB4N2QvMHg4OQpbICAgIDYuMDExNjM5XSAg
Wzw3OTNmMDNhMT5dIHBjaV9kZXZpY2VfcHJvYmUrMHg0NC8weDg1ClsgICAgNi4wMTI0MzRd
ICBbPDc5MTIzNGZkPl0gPyBzeXNmc19jcmVhdGVfbGluaysweDI3LzB4MmYKWyAgICA2LjAx
MzI1OV0gIFs8Nzk2Y2YwZjQ+XSBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4ODgvMHgxN2EKWyAg
ICA2LjAxNDA5N10gIFs8NzkzZjAyMjI+XSA/IHBjaV9tYXRjaF9kZXZpY2UrMHg5Ny8weDlk
ClsgICAgNi4wMTQ5MTVdICBbPDc5NmNmMjU5Pl0gX19kcml2ZXJfYXR0YWNoKzB4NDcvMHg2
MwpbICAgIDYuMDE1NjkyXSAgWzw3OTZjZGY3ND5dIGJ1c19mb3JfZWFjaF9kZXYrMHg1NS8w
eDVmClsgICAgNi4wMTY0ODBdICBbPDc5NmNmMDJkPl0gZHJpdmVyX2F0dGFjaCsweDE3LzB4
MTkKWyAgICA2LjAxNzIyMV0gIFs8Nzk2Y2YyMTI+XSA/IF9fZGV2aWNlX2F0dGFjaCsweDJj
LzB4MmMKWyAgICA2LjAxODAyNV0gIFs8Nzk2Y2U1NjY+XSBidXNfYWRkX2RyaXZlcisweGQx
LzB4MTk4ClsgICAgNi4wMTg4MDNdICBbPDc5NmNmODA3Pl0gZHJpdmVyX3JlZ2lzdGVyKzB4
N2EvMHhhZQpbICAgIDYuMDE5NTgxXSAgWzw3OTNmMDI3Yj5dIF9fcGNpX3JlZ2lzdGVyX2Ry
aXZlcisweDJkLzB4MzAKWyAgICA2LjAyMDQ2OF0gIFs8N2EyZjk1YTk+XSA/IG1nYWcyMDBf
aW5pdCsweDIzLzB4MjMKWyAgICA2LjAyMTIyNF0gIFs8Nzk0ZjFiYjU+XSBkcm1fcGNpX2lu
aXQrMHg1Yy8weGQzClsgICAgNi4wMjE5NjNdICBbPDdhMmY5NWE5Pl0gPyBtZ2FnMjAwX2lu
aXQrMHgyMy8weDIzClsgICAgNi4wMjI3MjFdICBbPDdhMmY5NWM0Pl0gY2lycnVzX2luaXQr
MHgxYi8weDIzClsgICAgNi4wMjM0NDNdICBbPDdhMmNjYTZjPl0gZG9fb25lX2luaXRjYWxs
KzB4ODIvMHgxMGIKWyAgICA2LjAyNDIyM10gIFs8N2EyY2M0MzA+XSA/IHJlcGFpcl9lbnZf
c3RyaW5nKzB4MTIvMHg1MQpbICAgIDYuMDI1MDUzXSAgWzw3OTA2NmY3Nj5dID8gcGFyc2Vf
YXJncysweDE2OC8weDIyNApbICAgIDYuMDI1ODE1XSAgWzw3YTJjY2M0Mz5dIGtlcm5lbF9p
bml0X2ZyZWVhYmxlKzB4MTRlLzB4MWU1ClsgICAgNi4wMjY2ODJdICBbPDdhMmNjNDFlPl0g
PyBkb19lYXJseV9wYXJhbSsweDc4LzB4NzgKWyAgICA2LjAyNzQ3MV0gIFs8NzljZTFhZDQ+
XSBrZXJuZWxfaW5pdCsweGIvMHhjNgpbICAgIDYuMDI4MTg0XSAgWzw3OWQwM2I3Nz5dIHJl
dF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDI4ClsgICAgNi4wMjkwNDhdICBbPDc5Y2Ux
YWM5Pl0gPyByZXN0X2luaXQrMHg2ZC8weDZkClsgICAgNi4wMjk3NzVdIC0tLVsgZW5kIHRy
YWNlIGVmZTk2MzRmZjljMjIzYjggXS0tLQpbICAgIDYuMDMwNTI4XSAtLS0tLS0tLS0tLS1b
IGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAtMDMx
OC9hYzk2YTI3ZWJmZTFhYzE2MzFhNjc5ZjI0OTkxMTQzYzEyNDEyN2I1L2RtZXNnLXlvY3Rv
LWNhaXJvLTIzOjIwMTQwMzE4MjMxNjIzOmkzODYtcmFuZGNvbmZpZy1yMC0wMzE4OjMuMTQu
MC1yYzctMDA3MDMtZ2FjOTZhMjc6MTAzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIwLTAz
MTgvYWM5NmEyN2ViZmUxYWMxNjMxYTY3OWYyNDk5MTE0M2MxMjQxMjdiNS9kbWVzZy1xdWFu
dGFsLWNhaXJvLTI1OjIwMTQwMzE4MjMxNjIyOmkzODYtcmFuZGNvbmZpZy1yMC0wMzE4OjMu
MTQuMC1yYzctMDA3MDMtZ2FjOTZhMjc6MTAzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIw
LTAzMTgvYWM5NmEyN2ViZmUxYWMxNjMxYTY3OWYyNDk5MTE0M2MxMjQxMjdiNS9kbWVzZy15
b2N0by1jYWlyby0xMDoyMDE0MDMxODIzMDEyMjppMzg2LXJhbmRjb25maWctcjAtMDMxODoz
LjE0LjAtcmM3LTAwNzAzLWdhYzk2YTI3OjEwMwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1y
MC0wMzE4L2FjOTZhMjdlYmZlMWFjMTYzMWE2NzlmMjQ5OTExNDNjMTI0MTI3YjUvZG1lc2ct
cXVhbnRhbC1pdnl0b3duMi0xMToyMDE0MDMxODIzMDExMzppMzg2LXJhbmRjb25maWctcjAt
MDMxODozLjE0LjAtcmM3LTAwNzAzLWdhYzk2YTI3OjEwMwova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1yMC0wMzE4L2FjOTZhMjdlYmZlMWFjMTYzMWE2NzlmMjQ5OTExNDNjMTI0MTI3YjUv
ZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0yMzoyMDE0MDMxODIzMDA0NzppMzg2LXJhbmRjb25m
aWctcjAtMDMxODozLjE0LjAtcmM3LTAwNzAzLWdhYzk2YTI3OjEwMwova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1yMC0wMzE4L2FjOTZhMjdlYmZlMWFjMTYzMWE2NzlmMjQ5OTExNDNjMTI0
MTI3YjUvZG1lc2ctcXVhbnRhbC1jYWlyby0xMjoyMDE0MDMxODIzMTYzNTppMzg2LXJhbmRj
b25maWctcjAtMDMxODozLjE0LjAtcmM3LTAwNzAzLWdhYzk2YTI3OjEwMwova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1yMC0wMzE4L2FjOTZhMjdlYmZlMWFjMTYzMWE2NzlmMjQ5OTExNDNj
MTI0MTI3YjUvZG1lc2ctcXVhbnRhbC1jYWlyby00NzoyMDE0MDMxODIzMTYyODppMzg2LXJh
bmRjb25maWctcjAtMDMxODozLjE0LjAtcmM3LTAwNzAzLWdhYzk2YTI3OjEwMwova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1yMC0wMzE4L2FjOTZhMjdlYmZlMWFjMTYzMWE2NzlmMjQ5OTEx
NDNjMTI0MTI3YjUvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0zOjIwMTQwMzE4MjMwMTIzOmkz
ODYtcmFuZGNvbmZpZy1yMC0wMzE4OjMuMTQuMC1yYzctMDA3MDMtZ2FjOTZhMjc6MTAzCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIwLTAzMTgvYWM5NmEyN2ViZmUxYWMxNjMxYTY3OWYy
NDk5MTE0M2MxMjQxMjdiNS9kbWVzZy1xdWFudGFsLWNhaXJvLTQyOjIwMTQwMzE4MjMxNjI3
OmkzODYtcmFuZGNvbmZpZy1yMC0wMzE4OjMuMTQuMC1yYzctMDA3MDMtZ2FjOTZhMjc6MTAz
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIwLTAzMTgvYWM5NmEyN2ViZmUxYWMxNjMxYTY3
OWYyNDk5MTE0M2MxMjQxMjdiNS9kbWVzZy1xdWFudGFsLWNhaXJvLTM4OjIwMTQwMzE4MjMx
NjM0OmkzODYtcmFuZGNvbmZpZy1yMC0wMzE4OjMuMTQuMC1yYzctMDA3MDMtZ2FjOTZhMjc6
MTAzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIwLTAzMTgvYWM5NmEyN2ViZmUxYWMxNjMx
YTY3OWYyNDk5MTE0M2MxMjQxMjdiNS9kbWVzZy15b2N0by1jYWlyby0zNToyMDE0MDMxODIz
MDA0ODppMzg2LXJhbmRjb25maWctcjAtMDMxODozLjE0LjAtcmM3LTAwNzAzLWdhYzk2YTI3
OjEwMwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMC0wMzE4L2FjOTZhMjdlYmZlMWFjMTYz
MWE2NzlmMjQ5OTExNDNjMTI0MTI3YjUvZG1lc2ctcXVhbnRhbC1jYWlyby0yNjoyMDE0MDMx
ODIzMTYyMzppMzg2LXJhbmRjb25maWctcjAtMDMxODozLjE0LjAtcmM3LTAwNzAzLWdhYzk2
YTI3OjEwMwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMC0wMzE4L2FjOTZhMjdlYmZlMWFj
MTYzMWE2NzlmMjQ5OTExNDNjMTI0MTI3YjUvZG1lc2ctcXVhbnRhbC1jYWlyby0yNDoyMDE0
MDMxODIzMTYyMjppMzg2LXJhbmRjb25maWctcjAtMDMxODozLjE0LjAtcmM3LTAwNzAzLWdh
Yzk2YTI3OjEwMwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMC0wMzE4L2FjOTZhMjdlYmZl
MWFjMTYzMWE2NzlmMjQ5OTExNDNjMTI0MTI3YjUvZG1lc2ctcXVhbnRhbC1jYWlyby00MDoy
MDE0MDMxODIzMDEyNzppMzg2LXJhbmRjb25maWctcjAtMDMxODozLjE0LjAtcmM3LTAwNzAz
LWdhYzk2YTI3OjEwMwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMC0wMzE4L2FjOTZhMjdl
YmZlMWFjMTYzMWE2NzlmMjQ5OTExNDNjMTI0MTI3YjUvZG1lc2ctcXVhbnRhbC1iZW5zLTQ6
MjAxNDAzMTgyMzAwNTQ6aTM4Ni1yYW5kY29uZmlnLXIwLTAzMTg6My4xNC4wLXJjNy0wMDcw
My1nYWM5NmEyNzoxMDMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAtMDMxOC9hYzk2YTI3
ZWJmZTFhYzE2MzFhNjc5ZjI0OTkxMTQzYzEyNDEyN2I1L2RtZXNnLXlvY3RvLWNhaXJvLTY6
MjAxNDAzMTgyMzAwMzc6aTM4Ni1yYW5kY29uZmlnLXIwLTAzMTg6My4xNC4wLXJjNy0wMDcw
My1nYWM5NmEyNzoxMDMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAtMDMxOC9hYzk2YTI3
ZWJmZTFhYzE2MzFhNjc5ZjI0OTkxMTQzYzEyNDEyN2I1L2RtZXNnLXF1YW50YWwtY2Fpcm8t
MTY6MjAxNDAzMTgyMzE2MTI6aTM4Ni1yYW5kY29uZmlnLXIwLTAzMTg6My4xNC4wLXJjNy0w
MDcwMy1nYWM5NmEyNzoxMDMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAtMDMxOC9hYzk2
YTI3ZWJmZTFhYzE2MzFhNjc5ZjI0OTkxMTQzYzEyNDEyN2I1L2RtZXNnLXF1YW50YWwtY2Fp
cm8tMTk6MjAxNDAzMTgyMzAxMDg6aTM4Ni1yYW5kY29uZmlnLXIwLTAzMTg6My4xNC4wLXJj
Ny0wMDcwMy1nYWM5NmEyNzoxMDMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAtMDMxOC9h
Yzk2YTI3ZWJmZTFhYzE2MzFhNjc5ZjI0OTkxMTQzYzEyNDEyN2I1L2RtZXNnLXF1YW50YWwt
Y2Fpcm8tMjk6MjAxNDAzMTgyMzE2MzE6aTM4Ni1yYW5kY29uZmlnLXIwLTAzMTg6My4xNC4w
LXJjNy0wMDcwMy1nYWM5NmEyNzoxMDMKMDoxOToxOSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBi
b290cwoKSEVBRCBpcyBub3cgYXQgYWM5NmEyNyAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZl
bC1yb2FtLWkzODYtMjAxNDAzMTgyMjQ4JwoKPT09PT09PT09IHVwc3RyZWFtID09PT09PT09
PQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBhYzk2YTI3Li4uIDBkYXkgaGVhZCBndWFy
ZCBmb3IgJ2RldmVsLXJvYW0taTM4Ni0yMDE0MDMxODIyNDgnCkhFQUQgaXMgbm93IGF0IDlh
MTVjOTQuLi4gTWVyZ2UgYnJhbmNoICdmb3ItbGludXMnIG9mIGdpdDovL2dpdC5rZXJuZWwu
ZGsvbGludXgtYmxvY2sKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYt
cmFuZGNvbmZpZy1yMC0wMzE4L2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0MDMx
ODIyNDg6OWExNWM5NDRmNzZjZmZhNTU4MTk1OWNlZmU3MDljN2M0ZWEyNjk5NDpiaXNlY3Qt
bGludXg2CgoyMDE0LTAzLTE5LTAyOjQ0OjI3IDlhMTVjOTQ0Zjc2Y2ZmYTU1ODE5NTljZWZl
NzA5YzdjNGVhMjY5OTQgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwt
dGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXIwLTAzMTgtOWExNWM5NDRmNzZj
ZmZhNTU4MTk1OWNlZmU3MDljN2M0ZWEyNjk5NApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXIwLTAzMTgvOWExNWM5NDRmNzZjZmZhNTU4MTk1OWNlZmU3
MDljN2M0ZWEyNjk5NAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMv
YnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXIwLTAzMTgtOWExNWM5NDRmNzZjZmZhNTU4
MTk1OWNlZmU3MDljN2M0ZWEyNjk5NAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJu
ZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1yMC0wMzE4LTlhMTVjOTQ0
Zjc2Y2ZmYTU1ODE5NTljZWZlNzA5YzdjNGVhMjY5OTQKa2VybmVsOiAva2VybmVsL2kzODYt
cmFuZGNvbmZpZy1yMC0wMzE4LzlhMTVjOTQ0Zjc2Y2ZmYTU1ODE5NTljZWZlNzA5YzdjNGVh
MjY5OTQvdm1saW51ei0zLjE0LjAtcmM3LTAwMDIzLWc5YTE1Yzk0CgoyMDE0LTAzLTE5LTAz
OjAwOjI4IGRldGVjdGluZyBib290IHN0YXRlIC4uLi4uCTEJMwk4CTkJMTEJMTMJMTguLgkx
OS4JMjAJMjEuCTIzCTI0LgkyNi4JMzAJNTEJNjAgU1VDQ0VTUwoKCj09PT09PT09PSBsaW51
eC1uZXh0ID09PT09PT09PQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA5YTE1Yzk0Li4u
IE1lcmdlIGJyYW5jaCAnZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2VybmVsLmRrL2xpbnV4
LWJsb2NrCkhFQUQgaXMgbm93IGF0IDNiZDY4OGMuLi4gQWRkIGxpbnV4LW5leHQgc3BlY2lm
aWMgZmlsZXMgZm9yIDIwMTQwMzE4CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2
bS9pMzg2LXJhbmRjb25maWctcjAtMDMxOC9saW51eC1kZXZlbDpkZXZlbC1yb2FtLWkzODYt
MjAxNDAzMTgyMjQ4OjNiZDY4OGMwYmZhMzA2Yzg2MWRhMjMxMWFmYmFhNDQxMzc2OGRjN2M6
YmlzZWN0LWxpbnV4NgoKMjAxNC0wMy0xOS0wMzoxNDoxMyAzYmQ2ODhjMGJmYTMwNmM4NjFk
YTIzMTFhZmJhYTQ0MTM3NjhkYzdjIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1yMC0wMzE4LTNiZDY4
OGMwYmZhMzA2Yzg2MWRhMjMxMWFmYmFhNDQxMzc2OGRjN2MKQ2hlY2sgZm9yIGtlcm5lbCBp
biAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMC0wMzE4LzNiZDY4OGMwYmZhMzA2Yzg2MWRh
MjMxMWFmYmFhNDQxMzc2OGRjN2MKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2VybmVs
LXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1yMC0wMzE4LTNiZDY4OGMwYmZh
MzA2Yzg2MWRhMjMxMWFmYmFhNDQxMzc2OGRjN2MKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2VybmVsLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWctcjAtMDMxOC0z
YmQ2ODhjMGJmYTMwNmM4NjFkYTIzMTFhZmJhYTQ0MTM3NjhkYzdjCmtlcm5lbDogL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctcjAtMDMxOC8zYmQ2ODhjMGJmYTMwNmM4NjFkYTIzMTFhZmJh
YTQ0MTM3NjhkYzdjL3ZtbGludXotMy4xNC4wLXJjNy1uZXh0LTIwMTQwMzE4CgoyMDE0LTAz
LTE5LTAzOjI2OjE0IGRldGVjdGluZyBib290IHN0YXRlIC4uCTEJNgkxNAkxOC4uCTIwLi4J
MjEJMjUuCTI3CTMyCTQzCTQ2CTQ4Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uCTQ5Li4uLi4uCTU0Lgk1Nwk1OAk1OQk2MCBTVUNDRVNTCgo=

--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc7-00703-gac96a27"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.14.0-rc7 Kernel Configuration
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
CONFIG_NEED_DMA_MAP_STATE=y
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
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
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
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=y
CONFIG_FHANDLE=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
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
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
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
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
CONFIG_CGROUP_HUGETLB=y
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
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
# CONFIG_ELF_CORE is not set
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
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
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_USER_RETURN_NOTIFIER=y
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
CONFIG_HAVE_CLK=y
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
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_SYSTEM_TRUSTED_KEYRING=y
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_CMDLINE_PARSER is not set

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
CONFIG_IOSCHED_CFQ=y
# CONFIG_CFQ_GROUP_IOSCHED is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_BIGSMP=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_INTEL_LPSS=y
# CONFIG_X86_32_IRIS is not set
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
CONFIG_MEMTEST=y
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
CONFIG_MPENTIUMIII=y
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
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_CYRIX_32 is not set
# CONFIG_CPU_SUP_AMD is not set
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
# CONFIG_CPU_SUP_UMC_32 is not set
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=32
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=y
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
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
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
CONFIG_ZBUD=y
CONFIG_ZSWAP=y
# CONFIG_ZSMALLOC is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
# CONFIG_SECCOMP is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_DOCK is not set
# CONFIG_ACPI_PROCESSOR is not set
CONFIG_ACPI_IPMI=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=y
CONFIG_ACPI_BGRT=y
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
# CONFIG_APM_IGNORE_USER_SUSPEND is not set
# CONFIG_APM_DO_ENABLE is not set
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
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_CPU_IDLE_GOV_MENU is not set
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_OLPC=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
# CONFIG_PCI_PRI is not set
CONFIG_PCI_PASID=y
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_OLPC=y
CONFIG_OLPC_XO1_PM=y
# CONFIG_OLPC_XO1_SCI is not set
CONFIG_OLPC_XO15_SCI=y
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
# CONFIG_GEOS is not set
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_COMPAQ=y
# CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM is not set
CONFIG_HOTPLUG_PCI_IBM=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=y
CONFIG_HOTPLUG_PCI_CPCI=y
# CONFIG_HOTPLUG_PCI_CPCI_ZT5550 is not set
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=y
# CONFIG_HOTPLUG_PCI_SHPC is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
# CONFIG_RAPIDIO_DMA_ENGINE is not set
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_ENUM_BASIC=y

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=y
# CONFIG_RAPIDIO_CPS_XX is not set
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=y
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
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
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_PNP=y
# CONFIG_IP_PNP_DHCP is not set
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
CONFIG_NET_IPGRE=y
# CONFIG_NET_IPGRE_BROADCAST is not set
CONFIG_IP_MROUTE=y
# CONFIG_IP_PIMSM_V1 is not set
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=y
# CONFIG_INET_LRO is not set
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=y
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
CONFIG_TCP_CONG_SCALABLE=y
# CONFIG_TCP_CONG_LP is not set
CONFIG_TCP_CONG_VENO=y
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
# CONFIG_DEFAULT_BIC is not set
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HTCP is not set
CONFIG_DEFAULT_VENO=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="veno"
CONFIG_TCP_MD5SIG=y
# CONFIG_IPV6 is not set
CONFIG_NETLABEL=y
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_FTP=y
CONFIG_NF_CONNTRACK_IRC=y
CONFIG_NF_CONNTRACK_BROADCAST=y
CONFIG_NF_CONNTRACK_NETBIOS_NS=y
# CONFIG_NF_CONNTRACK_SIP is not set
CONFIG_NF_CT_NETLINK=y
CONFIG_NF_NAT=y
CONFIG_NF_NAT_NEEDED=y
# CONFIG_NF_NAT_AMANDA is not set
CONFIG_NF_NAT_FTP=y
CONFIG_NF_NAT_IRC=y
# CONFIG_NF_NAT_SIP is not set
# CONFIG_NF_NAT_TFTP is not set
CONFIG_NF_TABLES=y
# CONFIG_NFT_EXTHDR is not set
CONFIG_NFT_META=y
CONFIG_NFT_CT=y
CONFIG_NFT_RBTREE=y
# CONFIG_NFT_HASH is not set
# CONFIG_NFT_COUNTER is not set
CONFIG_NFT_LOG=y
# CONFIG_NFT_LIMIT is not set
CONFIG_NFT_NAT=y
# CONFIG_NFT_REJECT is not set
CONFIG_NFT_COMPAT=y
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
# CONFIG_NETFILTER_XT_MARK is not set

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_LOG is not set
CONFIG_NETFILTER_XT_TARGET_NETMAP=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
# CONFIG_NETFILTER_XT_TARGET_REDIRECT is not set
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_CONNTRACK is not set
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_IP_SET=y
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=y
# CONFIG_IP_SET_BITMAP_IPMAC is not set
# CONFIG_IP_SET_BITMAP_PORT is not set
# CONFIG_IP_SET_HASH_IP is not set
CONFIG_IP_SET_HASH_IPPORT=y
# CONFIG_IP_SET_HASH_IPPORTIP is not set
CONFIG_IP_SET_HASH_IPPORTNET=y
CONFIG_IP_SET_HASH_NETPORTNET=y
CONFIG_IP_SET_HASH_NET=y
CONFIG_IP_SET_HASH_NETNET=y
CONFIG_IP_SET_HASH_NETPORT=y
CONFIG_IP_SET_HASH_NETIFACE=y
# CONFIG_IP_SET_LIST_SET is not set
CONFIG_IP_VS=y
CONFIG_IP_VS_DEBUG=y
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
# CONFIG_IP_VS_PROTO_TCP is not set
CONFIG_IP_VS_PROTO_UDP=y
# CONFIG_IP_VS_PROTO_AH_ESP is not set
# CONFIG_IP_VS_PROTO_ESP is not set
# CONFIG_IP_VS_PROTO_AH is not set
# CONFIG_IP_VS_PROTO_SCTP is not set

#
# IPVS scheduler
#
# CONFIG_IP_VS_RR is not set
# CONFIG_IP_VS_WRR is not set
CONFIG_IP_VS_LC=y
CONFIG_IP_VS_WLC=y
# CONFIG_IP_VS_LBLC is not set
CONFIG_IP_VS_LBLCR=y
# CONFIG_IP_VS_DH is not set
CONFIG_IP_VS_SH=y
CONFIG_IP_VS_SED=y
CONFIG_IP_VS_NQ=y

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#
CONFIG_IP_VS_NFCT=y

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
# CONFIG_NF_TABLES_IPV4 is not set
CONFIG_NF_TABLES_ARP=y
CONFIG_IP_NF_IPTABLES=y
# CONFIG_IP_NF_FILTER is not set
CONFIG_IP_NF_TARGET_ULOG=y
CONFIG_NF_NAT_IPV4=y
CONFIG_IP_NF_TARGET_MASQUERADE=y
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
# CONFIG_IP_NF_MANGLE is not set
CONFIG_IP_NF_RAW=y
# CONFIG_NF_TABLES_BRIDGE is not set
# CONFIG_BRIDGE_NF_EBTABLES is not set
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=y

#
# DCCP CCIDs Configuration
#
CONFIG_IP_DCCP_CCID2_DEBUG=y
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_TFRC_LIB=y

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
CONFIG_IP_SCTP=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_L2TP=y
CONFIG_L2TP_DEBUGFS=y
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=y
CONFIG_L2TP_ETH=y
CONFIG_STP=y
CONFIG_MRP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
# CONFIG_PHONET is not set
CONFIG_IEEE802154=y
CONFIG_MAC802154=y
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_BLA is not set
# CONFIG_BATMAN_ADV_DAT is not set
CONFIG_BATMAN_ADV_NC=y
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_OPENVSWITCH=y
# CONFIG_OPENVSWITCH_GRE is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=y
# CONFIG_NET_MPLS_GSO is not set
CONFIG_HSR=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
CONFIG_CGROUP_NET_CLASSID=y
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
# CONFIG_AX25_DAMA_SLAVE is not set
CONFIG_NETROM=y
# CONFIG_ROSE is not set

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
# CONFIG_6PACK is not set
CONFIG_BPQETHER=y
CONFIG_BAYCOM_SER_FDX=y
# CONFIG_BAYCOM_SER_HDX is not set
# CONFIG_BAYCOM_PAR is not set
CONFIG_BAYCOM_EPP=y
CONFIG_YAM=y
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
# CONFIG_CAN_BCM is not set
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
# CONFIG_CAN_SLCAN is not set
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
# CONFIG_IRNET is not set
# CONFIG_IRCOMM is not set
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
# CONFIG_IRDA_FAST_RR is not set
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#

#
# FIR device drivers
#
CONFIG_NSC_FIR=y
# CONFIG_WINBOND_FIR is not set
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=y
# CONFIG_ALI_FIR is not set
# CONFIG_VLSI_FIR is not set
CONFIG_VIA_FIR=y
# CONFIG_BT is not set
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
# CONFIG_RXKAD is not set
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
CONFIG_RFKILL_REGULATOR=y
CONFIG_RFKILL_GPIO=y
# CONFIG_NET_9P is not set
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=y
CONFIG_CAIF_USB=y
CONFIG_CEPH_LIB=y
CONFIG_CEPH_LIB_PRETTYDEBUG=y
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
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
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
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
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_OF_PARTS=y
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
# CONFIG_MTD_BLOCK is not set
CONFIG_MTD_BLOCK_RO=y
# CONFIG_FTL is not set
CONFIG_NFTL=y
# CONFIG_NFTL_RW is not set
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
CONFIG_MTD_OOPS=y
# CONFIG_MTD_SWAP is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
CONFIG_MTD_CFI_BE_BYTE_SWAP=y
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
CONFIG_MTD_CFI_GEOMETRY=y
# CONFIG_MTD_MAP_BANK_WIDTH_1 is not set
CONFIG_MTD_MAP_BANK_WIDTH_2=y
# CONFIG_MTD_MAP_BANK_WIDTH_4 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
# CONFIG_MTD_CFI_I1 is not set
# CONFIG_MTD_CFI_I2 is not set
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_OTP=y
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PHYSMAP is not set
# CONFIG_MTD_PHYSMAP_OF is not set
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
CONFIG_MTD_ESB2ROM=y
CONFIG_MTD_CK804XROM=y
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
CONFIG_MTD_PCI=y
# CONFIG_MTD_GPIO_ADDR is not set
CONFIG_MTD_INTEL_VR_NOR=y
CONFIG_MTD_PLATRAM=y
# CONFIG_MTD_LATCH_ADDR is not set

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
CONFIG_MTD_PMC551_BUGFIX=y
# CONFIG_MTD_PMC551_DEBUG is not set
# CONFIG_MTD_DATAFLASH is not set
CONFIG_MTD_M25P80=y
# CONFIG_MTD_SST25L is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=y
# CONFIG_MTD_NAND_ECC_BCH is not set
CONFIG_MTD_SM_COMMON=y
# CONFIG_MTD_NAND_DENALI is not set
CONFIG_MTD_NAND_GPIO=y
CONFIG_MTD_NAND_IDS=y
CONFIG_MTD_NAND_RICOH=y
CONFIG_MTD_NAND_DISKONCHIP=y
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
# CONFIG_MTD_NAND_DOCG4 is not set
CONFIG_MTD_NAND_CAFE=y
CONFIG_MTD_NAND_CS553X=y
CONFIG_MTD_NAND_NANDSIM=y
CONFIG_MTD_NAND_PLATFORM=y
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
# CONFIG_MTD_UBI is not set
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
CONFIG_OF_SELFTEST=y
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_NET=y
CONFIG_OF_MDIO=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
CONFIG_OF_MTD=y
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
CONFIG_BLK_DEV_NULL_BLK=y
# CONFIG_BLK_DEV_FD is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
CONFIG_BLK_CPQ_CISS_DA=y
CONFIG_BLK_DEV_DAC960=y
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=y

#
# DRBD disabled because PROC_FS or INET not selected
#
CONFIG_BLK_DEV_NBD=y
# CONFIG_BLK_DEV_NVME is not set
CONFIG_BLK_DEV_SX8=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_BLK_DEV_RBD=y
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_AD525X_DPOT_SPI=y
CONFIG_ATMEL_PWM=y
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
# CONFIG_ICS932S401 is not set
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
# CONFIG_CS5535_CLOCK_EVENT_SRC is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
# CONFIG_BMP085_I2C is not set
CONFIG_BMP085_SPI=y
CONFIG_PCH_PHUB=y
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_LATTICE_ECP3_CONFIG=y
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_AT25 is not set
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
# CONFIG_ALTERA_STAPL is not set
CONFIG_INTEL_MEI=y
# CONFIG_INTEL_MEI_ME is not set
CONFIG_VMWARE_VMCI=y

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
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
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECD=y
# CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS is not set
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set

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
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
CONFIG_BLK_DEV_OFFBOARD=y
CONFIG_BLK_DEV_GENERIC=y
CONFIG_BLK_DEV_OPTI621=y
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
CONFIG_BLK_DEV_ALI15X3=y
CONFIG_BLK_DEV_AMD74XX=y
CONFIG_BLK_DEV_ATIIXP=y
CONFIG_BLK_DEV_CMD64X=y
CONFIG_BLK_DEV_TRIFLEX=y
CONFIG_BLK_DEV_CS5520=y
# CONFIG_BLK_DEV_CS5530 is not set
CONFIG_BLK_DEV_CS5535=y
CONFIG_BLK_DEV_CS5536=y
CONFIG_BLK_DEV_HPT366=y
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
CONFIG_BLK_DEV_IT8172=y
# CONFIG_BLK_DEV_IT8213 is not set
CONFIG_BLK_DEV_IT821X=y
CONFIG_BLK_DEV_NS87415=y
CONFIG_BLK_DEV_PDC202XX_OLD=y
CONFIG_BLK_DEV_PDC202XX_NEW=y
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
CONFIG_BLK_DEV_VIA82CXXX=y
CONFIG_BLK_DEV_TC86C001=y
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
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
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_ENCLOSURE=y
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_FC_TGT_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_SRP_TGT_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
# CONFIG_ATA_ACPI is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
CONFIG_SATA_AHCI_PLATFORM=y
CONFIG_SATA_INIC162X=y
CONFIG_SATA_ACARD_AHCI=y
CONFIG_SATA_SIL24=y
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=y
# CONFIG_SATA_QSTOR is not set
CONFIG_SATA_SX4=y
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
# CONFIG_ATA_PIIX is not set
CONFIG_SATA_HIGHBANK=y
CONFIG_SATA_MV=y
CONFIG_SATA_NV=y
CONFIG_SATA_PROMISE=y
CONFIG_SATA_RCAR=y
CONFIG_SATA_SIL=y
CONFIG_SATA_SIS=y
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
CONFIG_SATA_VIA=y
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
CONFIG_PATA_CS5520=y
CONFIG_PATA_CS5530=y
CONFIG_PATA_CS5535=y
# CONFIG_PATA_CS5536 is not set
CONFIG_PATA_CYPRESS=y
# CONFIG_PATA_EFAR is not set
CONFIG_PATA_HPT366=y
CONFIG_PATA_HPT37X=y
CONFIG_PATA_HPT3X2N=y
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
CONFIG_PATA_IT821X=y
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
CONFIG_PATA_NETCELL=y
CONFIG_PATA_NINJA32=y
# CONFIG_PATA_NS87415 is not set
CONFIG_PATA_OLDPIIX=y
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
CONFIG_PATA_RADISYS=y
CONFIG_PATA_RDC=y
CONFIG_PATA_SC1200=y
CONFIG_PATA_SCH=y
# CONFIG_PATA_SERVERWORKS is not set
CONFIG_PATA_SIL680=y
CONFIG_PATA_SIS=y
CONFIG_PATA_TOSHIBA=y
CONFIG_PATA_TRIFLEX=y
CONFIG_PATA_VIA=y
CONFIG_PATA_WINBOND=y

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PLATFORM is not set
CONFIG_PATA_RZ1000=y

#
# Generic fallback / legacy drivers
#
CONFIG_ATA_GENERIC=y
CONFIG_PATA_LEGACY=y
# CONFIG_MD is not set
CONFIG_TARGET_CORE=y
# CONFIG_TCM_IBLOCK is not set
CONFIG_TCM_FILEIO=y
# CONFIG_TCM_PSCSI is not set
CONFIG_LOOPBACK_TARGET=y
# CONFIG_ISCSI_TARGET is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
# CONFIG_FUSION_LAN is not set
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
# CONFIG_I2O_EXT_ADAPTEC is not set
CONFIG_I2O_CONFIG=y
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=y
CONFIG_I2O_BLOCK=y
CONFIG_I2O_SCSI=y
CONFIG_I2O_PROC=y
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
CONFIG_DUMMY=y
CONFIG_EQUALIZER=y
CONFIG_NET_FC=y
CONFIG_NET_TEAM=y
# CONFIG_NET_TEAM_MODE_BROADCAST is not set
CONFIG_NET_TEAM_MODE_ROUNDROBIN=y
# CONFIG_NET_TEAM_MODE_RANDOM is not set
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=y
CONFIG_NET_TEAM_MODE_LOADBALANCE=y
# CONFIG_MACVLAN is not set
# CONFIG_VXLAN is not set
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_RIONET is not set
# CONFIG_TUN is not set
CONFIG_VETH=y
CONFIG_VIRTIO_NET=y
CONFIG_NLMON=y
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
CONFIG_ARCNET_1051=y
# CONFIG_ARCNET_RAW is not set
CONFIG_ARCNET_CAP=y
# CONFIG_ARCNET_COM90xx is not set
CONFIG_ARCNET_COM90xxIO=y
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=y
CONFIG_ARCNET_COM20020_PCI=y

#
# CAIF transport drivers
#
# CONFIG_CAIF_TTY is not set
CONFIG_CAIF_SPI_SLAVE=y
CONFIG_CAIF_SPI_SYNC=y
CONFIG_CAIF_HSI=y
CONFIG_CAIF_VIRTIO=y
# CONFIG_VHOST_NET is not set
CONFIG_VHOST_RING=y

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
# CONFIG_NET_DSA_MV88E6060 is not set
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_ETHERNET=y
CONFIG_MDIO=y
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=y
CONFIG_TYPHOON=y
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_NET_VENDOR_AMD is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_ARC_EMAC=y
# CONFIG_NET_VENDOR_ATHEROS is not set
# CONFIG_NET_CADENCE is not set
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=y
CONFIG_CNIC=y
CONFIG_TIGON3=y
CONFIG_BNX2X=y
CONFIG_BNX2X_SRIOV=y
# CONFIG_NET_VENDOR_BROCADE is not set
CONFIG_NET_CALXEDA_XGMAC=y
CONFIG_NET_VENDOR_CHELSIO=y
CONFIG_CHELSIO_T1=y
CONFIG_CHELSIO_T1_1G=y
CONFIG_CHELSIO_T3=y
# CONFIG_CHELSIO_T4 is not set
CONFIG_CHELSIO_T4VF=y
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=y
CONFIG_DNET=y
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
# CONFIG_NET_VENDOR_DLINK is not set
# CONFIG_NET_VENDOR_EMULEX is not set
CONFIG_NET_VENDOR_EXAR=y
CONFIG_S2IO=y
CONFIG_VXGE=y
CONFIG_VXGE_DEBUG_TRACE_ALL=y
# CONFIG_NET_VENDOR_HP is not set
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_IGB=y
# CONFIG_IGB_HWMON is not set
CONFIG_IGBVF=y
CONFIG_IXGB=y
CONFIG_IXGBE=y
# CONFIG_IXGBE_HWMON is not set
# CONFIG_IXGBE_DCB is not set
CONFIG_IXGBEVF=y
CONFIG_I40E=y
CONFIG_I40E_DCB=y
CONFIG_I40EVF=y
# CONFIG_NET_VENDOR_I825XX is not set
CONFIG_IP1000=y
# CONFIG_JME is not set
# CONFIG_NET_VENDOR_MARVELL is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MICROCHIP is not set
# CONFIG_NET_VENDOR_MYRI is not set
CONFIG_FEALNX=y
CONFIG_NET_VENDOR_NATSEMI=y
CONFIG_NATSEMI=y
CONFIG_NS83820=y
# CONFIG_NET_VENDOR_8390 is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
# CONFIG_NET_VENDOR_OKI is not set
# CONFIG_ETHOC is not set
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=y
# CONFIG_QLCNIC is not set
CONFIG_QLGE=y
# CONFIG_NETXEN_NIC is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
CONFIG_8139TOO_TUNE_TWISTER=y
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=y
CONFIG_SH_ETH=y
CONFIG_NET_VENDOR_RDC=y
CONFIG_R6040=y
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
CONFIG_SC92031=y
# CONFIG_NET_VENDOR_SIS is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
CONFIG_EPIC100=y
CONFIG_SMSC911X=y
# CONFIG_SMSC911X_ARCH_HOOKS is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_STMICRO=y
CONFIG_STMMAC_ETH=y
# CONFIG_STMMAC_PLATFORM is not set
# CONFIG_STMMAC_PCI is not set
CONFIG_STMMAC_DEBUG_FS=y
CONFIG_STMMAC_DA=y
# CONFIG_NET_VENDOR_SUN is not set
CONFIG_NET_VENDOR_TEHUTI=y
CONFIG_TEHUTI=y
CONFIG_NET_VENDOR_TI=y
CONFIG_TLAN=y
CONFIG_NET_VENDOR_VIA=y
CONFIG_VIA_RHINE=y
CONFIG_VIA_RHINE_MMIO=y
CONFIG_VIA_VELOCITY=y
# CONFIG_NET_VENDOR_WIZNET is not set
CONFIG_FDDI=y
CONFIG_DEFXX=y
CONFIG_DEFXX_MMIO=y
# CONFIG_SKFP is not set
# CONFIG_HIPPI is not set
CONFIG_NET_SB1000=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=y
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
CONFIG_BROADCOM_PHY=y
CONFIG_BCM87XX_PHY=y
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
# CONFIG_MDIO_GPIO is not set
CONFIG_MDIO_BUS_MUX=y
# CONFIG_MDIO_BUS_MUX_GPIO is not set
CONFIG_MDIO_BUS_MUX_MMIOREG=y
# CONFIG_MICREL_KS8995MA is not set
CONFIG_PLIP=y
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_DEFLATE=y
# CONFIG_PPP_FILTER is not set
# CONFIG_PPP_MPPE is not set
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPPOE=y
# CONFIG_PPTP is not set
# CONFIG_PPPOL2TP is not set
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=y
# CONFIG_IEEE802154_FAKEHARD is not set
CONFIG_IEEE802154_FAKELB=y
CONFIG_IEEE802154_AT86RF230=y
CONFIG_IEEE802154_MRF24J40=y
CONFIG_VMXNET3=y
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
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ADP5589=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
CONFIG_KEYBOARD_QT2160=y
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_GPIO=y
CONFIG_KEYBOARD_GPIO_POLLED=y
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
CONFIG_KEYBOARD_LM8323=y
# CONFIG_KEYBOARD_LM8333 is not set
CONFIG_KEYBOARD_MAX7359=y
CONFIG_KEYBOARD_MCS=y
CONFIG_KEYBOARD_MPR121=y
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_SAMSUNG=y
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_STMPE is not set
CONFIG_KEYBOARD_TC3589X=y
CONFIG_KEYBOARD_TWL4030=y
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=y
CONFIG_MOUSE_SYNAPTICS_I2C=y
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=y
# CONFIG_JOYSTICK_ADI is not set
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=y
CONFIG_JOYSTICK_GAMECON=y
CONFIG_JOYSTICK_TURBOGRAFX=y
# CONFIG_JOYSTICK_AS5011 is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
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
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_SERIO_APBPS2=y
CONFIG_SERIO_OLPC_APSP=y
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
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_OF_PLATFORM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
# CONFIG_IPMI_WATCHDOG is not set
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_ATMEL is not set
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_HW_RANDOM_EXYNOS is not set
# CONFIG_HW_RANDOM_TPM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=y
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=y
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HPET_MMAP_DEFAULT=y
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=y
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
CONFIG_TCG_INFINEON=y
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
# CONFIG_I2C_ARB_GPIO_CHALLENGE is not set
CONFIG_I2C_MUX_GPIO=y
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
CONFIG_I2C_MUX_PINCTRL=y
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
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=y
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
# CONFIG_I2C_KEMPLD is not set
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set

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
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_BUTTERFLY is not set
CONFIG_SPI_GPIO=y
CONFIG_SPI_LM70_LLP=y
# CONFIG_SPI_FSL_SPI is not set
CONFIG_SPI_OC_TINY=y
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=y
# CONFIG_SPI_TOPCLIFF_PCH is not set
# CONFIG_SPI_XCOMM is not set
CONFIG_SPI_XILINX=y
CONFIG_SPI_DESIGNWARE=y
# CONFIG_SPI_DW_PCI is not set
CONFIG_SPI_DW_MMIO=y

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_TLE62X0=y
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
CONFIG_PPS_CLIENT_KTIMER=y
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_PARPORT is not set
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
CONFIG_PINCTRL=y

#
# Pin controllers
#
CONFIG_PINMUX=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
CONFIG_DEBUG_PINCTRL=y
# CONFIG_PINCTRL_AS3722 is not set
CONFIG_PINCTRL_BAYTRAIL=y
CONFIG_PINCTRL_CAPRI=y
CONFIG_PINCTRL_MSM=y
CONFIG_PINCTRL_MSM8X74=y
CONFIG_PINCTRL_SINGLE=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
# CONFIG_GPIO_F7188X is not set
CONFIG_GPIO_SCH311X=y
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
CONFIG_GPIO_ICH=y
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set
# CONFIG_GPIO_GRGPIO is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_LP3943=y
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_RC5T583 is not set
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_STMPE=y
# CONFIG_GPIO_TC3589X is not set
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TWL4030=y
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5520=y
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y
CONFIG_GPIO_ADNP=y

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=y
CONFIG_GPIO_BT8XX=y
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_INTEL_MID is not set
# CONFIG_GPIO_PCH is not set
CONFIG_GPIO_ML_IOH=y
# CONFIG_GPIO_SODAVILLE is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
# CONFIG_GPIO_MCP23S08 is not set
CONFIG_GPIO_MC33880=y
CONFIG_GPIO_74X164=y

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
# CONFIG_GPIO_KEMPLD is not set

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=y
# CONFIG_GPIO_TPS6586X is not set
CONFIG_GPIO_BCM_KONA=y

#
# USB GPIO expanders:
#
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_DS1WM is not set
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_88PM860X is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_OLPC=y
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9030=y
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
# CONFIG_BATTERY_TWL4030_MADC is not set
# CONFIG_BATTERY_RX51 is not set
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_TWL4030 is not set
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_MANAGER is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24190 is not set
CONFIG_CHARGER_BQ24735=y
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_CHARGER_TPS65090 is not set
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADCXX=y
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_DA9055=y
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=y
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM70=y
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=y
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_MAX1111=y
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
# CONFIG_SENSORS_PMBUS is not set
CONFIG_SENSORS_ADM1275=y
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
# CONFIG_SENSORS_MAX8688 is not set
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_TWL4030_MADC=y
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
CONFIG_SENSORS_ATK0110=y
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_OF is not set
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_ACPI_INT3403_THERMAL is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_DA9052_WATCHDOG=y
CONFIG_DA9055_WATCHDOG=y
CONFIG_GPIO_WATCHDOG=y
CONFIG_DW_WATCHDOG=y
CONFIG_TWL4030_WATCHDOG=y
# CONFIG_RETU_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=y
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
CONFIG_GEODE_WDT=y
CONFIG_SC520_WDT=y
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=y
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
# CONFIG_IT87_WDT is not set
CONFIG_HP_WATCHDOG=y
CONFIG_KEMPLD_WDT=y
# CONFIG_HPWDT_NMI_DECODING is not set
CONFIG_SC1200_WDT=y
CONFIG_SCx200_WDT=y
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
CONFIG_SBC7240_WDT=y
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
CONFIG_VIA_WDT=y
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=y
# CONFIG_W83977F_WDT is not set
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y
# CONFIG_MEN_A21_WDT is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
CONFIG_WDTPCI=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
CONFIG_SSB_SILENT=y
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
CONFIG_MFD_AS3722=y
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
# CONFIG_MFD_CROS_EC_SPI is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX14577 is not set
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_RETU=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
# CONFIG_MFD_SM501 is not set
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
CONFIG_STMPE_SPI=y
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=y
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS65912_SPI is not set
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
CONFIG_TWL4030_MADC=y
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8400=y
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_88PM8607 is not set
CONFIG_REGULATOR_ACT8865=y
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_AAT2870=y
# CONFIG_REGULATOR_ARIZONA is not set
CONFIG_REGULATOR_AS3711=y
# CONFIG_REGULATOR_AS3722 is not set
CONFIG_REGULATOR_DA903X=y
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9063=y
# CONFIG_REGULATOR_DA9210 is not set
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=y
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
# CONFIG_REGULATOR_MAX1586 is not set
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=y
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8973=y
# CONFIG_REGULATOR_MAX77686 is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_RC5T583=y
# CONFIG_REGULATOR_TPS51632 is not set
# CONFIG_REGULATOR_TPS6105X is not set
CONFIG_REGULATOR_TPS62360=y
# CONFIG_REGULATOR_TPS65023 is not set
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65090=y
CONFIG_REGULATOR_TPS65217=y
CONFIG_REGULATOR_TPS6524X=y
# CONFIG_REGULATOR_TPS6586X is not set
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_TPS80031=y
# CONFIG_REGULATOR_TWL4030 is not set
CONFIG_REGULATOR_WM8400=y
CONFIG_REGULATOR_WM8994=y
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
CONFIG_AGP_ATI=y
CONFIG_AGP_AMD=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_NVIDIA=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
CONFIG_AGP_VIA=y
CONFIG_AGP_EFFICEON=y
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
# CONFIG_DRM_I2C_SIL164 is not set
CONFIG_DRM_I2C_NXP_TDA998X=y
CONFIG_DRM_TDFX=y
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
# CONFIG_DRM_RADEON_UMS is not set
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
CONFIG_DRM_I810=y
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
# CONFIG_DRM_I915_FBDEV is not set
CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT=y
# CONFIG_DRM_I915_UMS is not set
CONFIG_DRM_MGA=y
CONFIG_DRM_SIS=y
# CONFIG_DRM_VIA is not set
CONFIG_DRM_SAVAGE=y
CONFIG_DRM_VMWGFX=y
CONFIG_DRM_VMWGFX_FBCON=y
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=y
CONFIG_DRM_MGAG200=y
CONFIG_DRM_CIRRUS_QEMU=y
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=y
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
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
CONFIG_FB_CYBER2000=y
# CONFIG_FB_CYBER2000_DDC is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_EFI=y
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_OPENCORES=y
CONFIG_FB_S1D13XXX=y
# CONFIG_FB_NVIDIA is not set
CONFIG_FB_RIVA=y
# CONFIG_FB_RIVA_I2C is not set
CONFIG_FB_RIVA_DEBUG=y
# CONFIG_FB_RIVA_BACKLIGHT is not set
CONFIG_FB_I740=y
CONFIG_FB_I810=y
# CONFIG_FB_I810_GTF is not set
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=y
# CONFIG_FB_RADEON_I2C is not set
# CONFIG_FB_RADEON_BACKLIGHT is not set
CONFIG_FB_RADEON_DEBUG=y
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=y
# CONFIG_FB_ATY_CT is not set
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=y
CONFIG_FB_S3_DDC=y
CONFIG_FB_SAVAGE=y
# CONFIG_FB_SAVAGE_I2C is not set
# CONFIG_FB_SAVAGE_ACCEL is not set
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=y
CONFIG_FB_VIA_DIRECT_PROCFS=y
# CONFIG_FB_VIA_X_COMPATIBILITY is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=y
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
# CONFIG_FB_GOLDFISH is not set
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
CONFIG_FB_SIMPLE=y
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
CONFIG_LCD_ILI922X=y
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=y
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=y
# CONFIG_LCD_S6E63M0 is not set
CONFIG_LCD_LD9040=y
CONFIG_LCD_AMS369FG06=y
CONFIG_LCD_LMS501KF03=y
CONFIG_LCD_HX8357=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_ATMEL_PWM=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_CARILLO_RANCH=y
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_DA903X=y
CONFIG_BACKLIGHT_DA9052=y
CONFIG_BACKLIGHT_APPLE=y
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_ADP5520=y
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_88PM860X=y
CONFIG_BACKLIGHT_AAT2870=y
CONFIG_BACKLIGHT_LM3630A=y
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_LP855X is not set
CONFIG_BACKLIGHT_OT200=y
CONFIG_BACKLIGHT_PANDORA=y
CONFIG_BACKLIGHT_TPS65217=y
CONFIG_BACKLIGHT_AS3711=y
CONFIG_BACKLIGHT_GPIO=y
# CONFIG_BACKLIGHT_LV5207LP is not set
CONFIG_BACKLIGHT_BD6107=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_FB_SSD1307=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=y
CONFIG_SND_JACK=y
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_HRTIMER=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_DRIVERS=y
# CONFIG_SND_DUMMY is not set
CONFIG_SND_ALOOP=y
CONFIG_SND_MTPAV=y
CONFIG_SND_MTS64=y
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
CONFIG_SND_PORTMAN2X4=y
# CONFIG_SND_PCI is not set
# CONFIG_SND_SPI is not set
CONFIG_SND_SOC=y
CONFIG_SND_ATMEL_SOC=y
CONFIG_SND_DESIGNWARE_I2S=y
CONFIG_SND_SOC_I2C_AND_SPI=y
# CONFIG_SND_SIMPLE_CARD is not set
CONFIG_SOUND_PRIME=y
CONFIG_SOUND_OSS=y
CONFIG_SOUND_TRACEINIT=y
# CONFIG_SOUND_DMAP is not set
CONFIG_SOUND_VMIDI=y
CONFIG_SOUND_TRIX=y
# CONFIG_TRIX_HAVE_BOOT is not set
CONFIG_SOUND_MSS=y
# CONFIG_SOUND_MPU401 is not set
# CONFIG_SOUND_PAS is not set
# CONFIG_SOUND_PSS is not set
CONFIG_SOUND_SB=y
CONFIG_SOUND_YM3812=y
CONFIG_SOUND_UART6850=y
CONFIG_SOUND_AEDSP16=y
CONFIG_SC6600=y
CONFIG_SC6600_JOY=y
CONFIG_SC6600_CDROM=4
CONFIG_SC6600_CDROMBASE=0
CONFIG_SOUND_KAHLUA=y

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=y
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
# CONFIG_HID_APPLE is not set
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_PRODIKEYS=y
# CONFIG_HID_CYPRESS is not set
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=y
# CONFIG_HID_ELECOM is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_KEYTOUCH=y
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
# CONFIG_HID_LOGITECH is not set
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
# CONFIG_HID_MONTEREY is not set
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
# CONFIG_HID_PICOLCD_LCD is not set
# CONFIG_HID_PICOLCD_LEDS is not set
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_HID_SENSOR_HUB=y

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
CONFIG_MMC_BLOCK_BOUNCE=y
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
# CONFIG_MMC_RICOH_MMC is not set
CONFIG_MMC_SDHCI_ACPI=y
CONFIG_MMC_SDHCI_PLTFM=y
# CONFIG_MMC_SDHCI_OF_ARASAN is not set
CONFIG_MMC_SDHCI_PXAV3=y
CONFIG_MMC_SDHCI_PXAV2=y
# CONFIG_MMC_WBSD is not set
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_SPI=y
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MMC_REALTEK_PCI=y
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=y
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
CONFIG_MEMSTICK_JMICRON_38X=y
# CONFIG_MEMSTICK_R592 is not set
# CONFIG_MEMSTICK_REALTEK_PCI is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_88PM860X is not set
CONFIG_LEDS_ATMEL_PWM=y
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_NET48XX=y
CONFIG_LEDS_WRAP=y
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
# CONFIG_LEDS_PCA9685 is not set
CONFIG_LEDS_DA903X=y
CONFIG_LEDS_DA9052=y
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_INTEL_SS4200=y
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_ADP5520=y
CONFIG_LEDS_DELL_NETBOOKS=y
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_LM355x=y
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_IDE_DISK=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_GPIO=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
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
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_88PM860X is not set
# CONFIG_RTC_DRV_AS3722 is not set
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
# CONFIG_RTC_DRV_DS1672 is not set
CONFIG_RTC_DRV_DS3232=y
CONFIG_RTC_DRV_HYM8563=y
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_MAX8907 is not set
CONFIG_RTC_DRV_MAX77686=y
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=y
# CONFIG_RTC_DRV_ISL12057 is not set
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF2127=y
CONFIG_RTC_DRV_PCF8523=y
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
CONFIG_RTC_DRV_M41T80_WDT=y
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_TWL4030=y
# CONFIG_RTC_DRV_TPS6586X is not set
CONFIG_RTC_DRV_TPS80031=y
CONFIG_RTC_DRV_RC5T583=y
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=y
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
CONFIG_RTC_DRV_M41T94=y
CONFIG_RTC_DRV_DS1305=y
CONFIG_RTC_DRV_DS1390=y
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_R9701 is not set
CONFIG_RTC_DRV_RS5C348=y
# CONFIG_RTC_DRV_DS3234 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
CONFIG_RTC_DRV_RX4581=y

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=y
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=y
# CONFIG_RTC_DRV_DA9052 is not set
CONFIG_RTC_DRV_DA9055=y
CONFIG_RTC_DRV_STK17TA8=y
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_DS2404 is not set

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=y
CONFIG_RTC_DRV_SNVS=y
CONFIG_RTC_DRV_MOXART=y

#
# HID Sensor RTC drivers
#
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
CONFIG_UIO_CIF=y
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=y
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
# CONFIG_UIO_NETX is not set
CONFIG_UIO_MF624=y
CONFIG_VFIO_IOMMU_TYPE1=y
CONFIG_VFIO=y
CONFIG_VFIO_PCI=y
CONFIG_VFIO_PCI_VGA=y
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_ET131X is not set
CONFIG_SLICOSS=y
CONFIG_ECHO=y
# CONFIG_FB_OLPC_DCON is not set
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
CONFIG_PANEL_CHANGE_MESSAGE=y
CONFIG_PANEL_BOOT_MESSAGE=""
CONFIG_RTS5208=y
# CONFIG_RTS5208_DEBUG is not set
CONFIG_IDE_PHISON=y
# CONFIG_DX_SEP is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
CONFIG_FB_XGI=y
CONFIG_ACPI_QUICKSTART=y
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
CONFIG_STAGING_MEDIA=y

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
# CONFIG_ASHMEM is not set
# CONFIG_ANDROID_LOGGER is not set
# CONFIG_ANDROID_TIMED_OUTPUT is not set
# CONFIG_ANDROID_LOW_MEMORY_KILLER is not set
# CONFIG_ANDROID_INTF_ALARM_DEV is not set
CONFIG_SYNC=y
CONFIG_SW_SYNC=y
CONFIG_SW_SYNC_USER=y
# CONFIG_ION is not set
CONFIG_WIMAX_GDM72XX=y
# CONFIG_WIMAX_GDM72XX_QOS is not set
# CONFIG_WIMAX_GDM72XX_K_MODE is not set
# CONFIG_WIMAX_GDM72XX_WIMAX2 is not set
CONFIG_WIMAX_GDM72XX_SDIO=y
# CONFIG_NET_VENDOR_SILICOM is not set
# CONFIG_DGRP is not set
CONFIG_MTD_SPINAND_MT29F=y
# CONFIG_MTD_SPINAND_ONDIEECC is not set
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
CONFIG_ACERHDF=y
CONFIG_ASUS_LAPTOP=y
# CONFIG_DELL_WMI is not set
CONFIG_DELL_WMI_AIO=y
CONFIG_FUJITSU_LAPTOP=y
CONFIG_FUJITSU_LAPTOP_DEBUG=y
# CONFIG_FUJITSU_TABLET is not set
CONFIG_AMILO_RFKILL=y
CONFIG_TC1100_WMI=y
# CONFIG_HP_ACCEL is not set
CONFIG_HP_WIRELESS=y
CONFIG_HP_WMI=y
CONFIG_MSI_LAPTOP=y
CONFIG_PANASONIC_LAPTOP=y
CONFIG_COMPAL_LAPTOP=y
CONFIG_SONY_LAPTOP=y
# CONFIG_SONYPI_COMPAT is not set
CONFIG_IDEAPAD_LAPTOP=y
CONFIG_THINKPAD_ACPI=y
# CONFIG_THINKPAD_ACPI_ALSA_SUPPORT is not set
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
# CONFIG_THINKPAD_ACPI_HOTKEY_POLL is not set
CONFIG_SENSORS_HDAPS=y
CONFIG_EEEPC_LAPTOP=y
CONFIG_ASUS_WMI=y
CONFIG_ASUS_NB_WMI=y
CONFIG_EEEPC_WMI=y
CONFIG_ACPI_WMI=y
CONFIG_MSI_WMI=y
CONFIG_TOPSTAR_LAPTOP=y
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_TOSHIBA_BT_RFKILL=y
CONFIG_ACPI_CMPC=y
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=y
CONFIG_XO1_RFKILL=y
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_MXM_WMI=y
CONFIG_INTEL_OAKTRAIL=y
CONFIG_SAMSUNG_Q10=y
CONFIG_APPLE_GMUX=y
CONFIG_INTEL_RST=y
CONFIG_INTEL_SMARTCONNECT=y
CONFIG_PVPANIC=y
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_LAPTOP=y
# CONFIG_CHROMEOS_PSTORE is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
CONFIG_COMMON_CLK_MAX77686=y
CONFIG_COMMON_CLK_SI5351=y
CONFIG_COMMON_CLK_SI570=y
CONFIG_COMMON_CLK_QCOM=y
CONFIG_MSM_GCC_8660=y
CONFIG_MSM_GCC_8960=y
CONFIG_MSM_MMCC_8960=y
CONFIG_MSM_GCC_8974=y
CONFIG_MSM_MMCC_8974=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_OF_IOMMU=y
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
CONFIG_INTEL_IOMMU_DEFAULT_ON=y
CONFIG_INTEL_IOMMU_FLOPPY_WA=y

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_LP3943 is not set
CONFIG_PWM_PCA9685=y
# CONFIG_PWM_TWL is not set
# CONFIG_PWM_TWL_LED is not set
CONFIG_IRQCHIP=y
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
CONFIG_FMC_TRIVIAL=y
# CONFIG_FMC_WRITE_EEPROM is not set
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_EXYNOS_MIPI_VIDEO=y
# CONFIG_PHY_EXYNOS_DP_VIDEO is not set
CONFIG_BCM_KONA_USB2_PHY=y
# CONFIG_POWERCAP is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
CONFIG_EXT2_FS_XIP=y
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4_USE_FOR_EXT23 is not set
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_FS_XIP=y
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
CONFIG_OCFS2_FS=y
# CONFIG_OCFS2_FS_O2CB is not set
# CONFIG_OCFS2_FS_USERSPACE_CLUSTER is not set
# CONFIG_OCFS2_FS_STATS is not set
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
CONFIG_OCFS2_DEBUG_FS=y
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
CONFIG_BTRFS_ASSERT=y
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set

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
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V2=y
# CONFIG_NFS_V3 is not set
# CONFIG_NFS_V4 is not set
# CONFIG_NFS_SWAP is not set
# CONFIG_ROOT_NFS is not set
CONFIG_NFS_FSCACHE=y
# CONFIG_NFSD is not set
CONFIG_LOCKD=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_CEPH_FS=y
# CONFIG_CEPH_FSCACHE is not set
CONFIG_CEPH_FS_POSIX_ACL=y
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
CONFIG_CODA_FS=y
CONFIG_AFS_FS=y
CONFIG_AFS_DEBUG=y
# CONFIG_AFS_FSCACHE is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
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
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
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
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
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
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
# CONFIG_BIG_KEYS is not set
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_INTEL_TXT=y
# CONFIG_SECURITY_SELINUX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
CONFIG_SECURITY_APPARMOR_HASH=y
CONFIG_SECURITY_YAMA=y
CONFIG_SECURITY_YAMA_STACKED=y
# CONFIG_IMA is not set
# CONFIG_EVM is not set
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
CONFIG_DEFAULT_SECURITY_YAMA=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="yama"
CONFIG_XOR_BLOCKS=y
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
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
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
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
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
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
CONFIG_CRYPTO_DEV_HIFN_795X=y
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_CCP_DD=y
CONFIG_CRYPTO_DEV_CCP_CRYPTO=y
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
# CONFIG_X509_CERTIFICATE_PARSER is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
# CONFIG_KVM_INTEL is not set
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_DEVICE_ASSIGNMENT is not set
# CONFIG_LGUEST is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_RATIONAL=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_AUDIT_GENERIC=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_UCS2_STRING=y

--nFreZHaLTZJo0R7j--
