Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbaLRRIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 12:08:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:7388 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaLRRIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 12:08:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,601,1413270000"; 
   d="scan'208";a="626085911"
Date: Thu, 18 Dec 2014 09:03:49 -0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Thierry Reding <treding@nvidia.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, LKP <lkp@01.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [drm/fb-helper] WARNING: CPU: 1 PID: 1 at lib/idr.c:506 idr_remove()
Message-ID: <20141218170349.GC9298@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

git://anongit.freedesktop.org/drm-intel topic/core-stuff

commit 7bf2844ed14de049a4ccec26eb3d8b4c3d5c1971
Author:     Thierry Reding <treding@nvidia.com>
AuthorDate: Wed Dec 17 16:39:59 2014 +0100
Commit:     Daniel Vetter <daniel.vetter@ffwll.ch>
CommitDate: Wed Dec 17 22:05:08 2014 +0100

    drm/fb-helper: Propagate errors from initial config failure
    
    Make drm_fb_helper_initial_config() return an int rather than a bool so
    that the error can be properly propagated. While at it, update drivers
    to propagate errors further rather than just ignore them.
    
    Cc: David Airlie <airlied@linux.ie>
    Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
    Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
    Cc: Rob Clark <robdclark@gmail.com>
    Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
    Cc: Alex Deucher <alexander.deucher@amd.com>
    Cc: Christian König <christian.koenig@amd.com>
    Cc: Ben Skeggs <bskeggs@redhat.com>
    Signed-off-by: Thierry Reding <treding@nvidia.com>
    Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
    Reviewed-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Attached dmesg for the parent commit, too, to help confirm whether it is a noise error.
Judging from the kernel boot hang timestamps, that looks like an noise.

+------------------------------------------------+------------+------------+------------+
|                                                | 7552e7dd95 | 7bf2844ed1 | 7bf2844ed1 |
+------------------------------------------------+------------+------------+------------+
| boot_successes                                 | 0          | 0          | 0          |
| boot_failures                                  | 80         | 12         | 12         |
| BUG:kernel_boot_hang                           | 80         |            |            |
| WARNING:at_lib/idr.c:#idr_remove()             | 0          | 12         | 12         |
| RIP:strcmp                                     | 0          | 5          | 5          |
| Kernel_panic-not_syncing:softlockup:hung_tasks | 0          | 11         | 11         |
| backtrace:__pci_register_driver                | 0          | 12         | 12         |
| backtrace:drm_pci_init                         | 0          | 12         | 12         |
| backtrace:cirrus_init                          | 0          | 12         | 12         |
| backtrace:kernel_init_freeable                 | 0          | 12         | 12         |
| backtrace:i2c_register_driver                  | 0          | 5          | 5          |
| backtrace:bh1780_driver_init                   | 0          | 2          | 2          |
| RIP:kset_find_obj                              | 0          | 6          | 6          |
| backtrace:i2o_pci_init                         | 0          | 2          | 2          |
| backtrace:i2o_iop_init                         | 0          | 2          | 2          |
| backtrace:lm3642_i2c_driver_init               | 0          | 1          | 1          |
| BUG:kernel_test_hang                           | 0          | 1          | 1          |
| backtrace:usb_register_driver                  | 0          | 2          | 2          |
| backtrace:hanwang_driver_init                  | 0          | 2          | 2          |
| backtrace:__gameport_register_driver           | 0          | 1          | 1          |
| backtrace:grip_drv_init                        | 0          | 1          | 1          |
| backtrace:w83l785ts_driver_init                | 0          | 2          | 2          |
| backtrace:spi_register_driver                  | 0          | 1          | 1          |
| backtrace:dac7512_driver_init                  | 0          | 1          | 1          |
+------------------------------------------------+------------+------------+------------+

[    4.754439] cirrus 0000:00:02.0: Fatal error during modeset init: -22
[    4.756061] ------------[ cut here ]------------
[    4.756061] ------------[ cut here ]------------
[    4.756800] WARNING: CPU: 1 PID: 1 at lib/idr.c:506 idr_remove+0x384/0x3b0()
[    4.756800] WARNING: CPU: 1 PID: 1 at lib/idr.c:506 idr_remove+0x384/0x3b0()
[    4.758132] idr_remove called for id=20 which is not allocated.
[    4.758132] idr_remove called for id=20 which is not allocated.
[    4.759056] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc4-g7bf2844 #20
[    4.759056] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc4-g7bf2844 #20
[    4.760184]  0000000000000009
[    4.760184]  0000000000000009 ffff88001147fa08 ffff88001147fa08 ffffffff824ce992 ffffffff824ce992 ffffffff81151538 ffffffff81151538

[    4.761391]  ffff88001147fa58
[    4.761391]  ffff88001147fa58 ffff88001147fa48 ffff88001147fa48 ffffffff810dac1a ffffffff810dac1a ffff88001147fa78 ffff88001147fa78

[    4.762593]  ffff88001147fac8
[    4.762593]  ffff88001147fac8 ffff880012c916f8 ffff880012c916f8 ffff880012d01310 ffff880012d01310 ffff880012c91060 ffff880012c91060

[    4.763796] Call Trace:
[    4.763796] Call Trace:
[    4.764187]  [<ffffffff824ce992>] dump_stack+0x86/0xbc
[    4.764187]  [<ffffffff824ce992>] dump_stack+0x86/0xbc
[    4.764995]  [<ffffffff81151538>] ? console_unlock+0x3b8/0x7a0
[    4.764995]  [<ffffffff81151538>] ? console_unlock+0x3b8/0x7a0
[    4.765908]  [<ffffffff810dac1a>] warn_slowpath_common+0x9a/0xd0
[    4.765908]  [<ffffffff810dac1a>] warn_slowpath_common+0x9a/0xd0
[    4.766846]  [<ffffffff810dace1>] warn_slowpath_fmt+0x51/0x60
[    4.766846]  [<ffffffff810dace1>] warn_slowpath_fmt+0x51/0x60
[    4.767740]  [<ffffffff819b7c7c>] ? drm_mode_object_put+0x2c/0x70
[    4.767740]  [<ffffffff819b7c7c>] ? drm_mode_object_put+0x2c/0x70
[    4.768689]  [<ffffffff8170f7c4>] idr_remove+0x384/0x3b0
[    4.768689]  [<ffffffff8170f7c4>] idr_remove+0x384/0x3b0
[    4.769521]  [<ffffffff81738039>] ? debug_check_no_obj_freed+0x29/0x40
[    4.769521]  [<ffffffff81738039>] ? debug_check_no_obj_freed+0x29/0x40
[    4.770551]  [<ffffffff819b7c94>] drm_mode_object_put+0x44/0x70
[    4.770551]  [<ffffffff819b7c94>] drm_mode_object_put+0x44/0x70
[    4.771473]  [<ffffffff819c1bba>] drm_mode_destroy+0x2a/0x50
[    4.771473]  [<ffffffff819c1bba>] drm_mode_destroy+0x2a/0x50
[    4.772358]  [<ffffffff8199d155>] drm_fb_helper_crtc_free+0xc5/0x110
[    4.772358]  [<ffffffff8199d155>] drm_fb_helper_crtc_free+0xc5/0x110
[    4.773348]  [<ffffffff8199e724>] drm_fb_helper_fini+0x74/0xc0
[    4.773348]  [<ffffffff8199e724>] drm_fb_helper_fini+0x74/0xc0
[    4.774259]  [<ffffffff81cbaa73>] cirrus_fbdev_fini+0x193/0x230
[    4.774259]  [<ffffffff81cbaa73>] cirrus_fbdev_fini+0x193/0x230
[    4.775186]  [<ffffffff81cb98c9>] cirrus_modeset_fini+0x19/0x50
[    4.775186]  [<ffffffff81cb98c9>] cirrus_modeset_fini+0x19/0x50
[    4.776117]  [<ffffffff81cb7afb>] cirrus_driver_unload+0x2b/0x80
[    4.776117]  [<ffffffff81cb7afb>] cirrus_driver_unload+0x2b/0x80
[    4.777061]  [<ffffffff81cb7c97>] cirrus_driver_load+0x147/0x220
[    4.777061]  [<ffffffff81cb7c97>] cirrus_driver_load+0x147/0x220
[    4.778004]  [<ffffffff819b0515>] drm_dev_register+0x115/0x1c0
[    4.778004]  [<ffffffff819b0515>] drm_dev_register+0x115/0x1c0
[    4.778917]  [<ffffffff819b3c8c>] drm_get_pci_dev+0xcc/0x300
[    4.778917]  [<ffffffff819b3c8c>] drm_get_pci_dev+0xcc/0x300
[    4.779807]  [<ffffffff824e3361>] ? mutex_unlock+0x11/0x20
[    4.779807]  [<ffffffff824e3361>] ? mutex_unlock+0x11/0x20
[    4.780675]  [<ffffffff81cb9b7a>] cirrus_pci_probe+0x13a/0x180
[    4.780675]  [<ffffffff81cb9b7a>] cirrus_pci_probe+0x13a/0x180
[    4.781586]  [<ffffffff817893fc>] pci_device_probe+0xbc/0x180
[    4.781586]  [<ffffffff817893fc>] pci_device_probe+0xbc/0x180
[    4.782482]  [<ffffffff81e470bb>] really_probe+0x7b/0x340
[    4.782482]  [<ffffffff81e470bb>] really_probe+0x7b/0x340
[    4.783327]  [<ffffffff81e47481>] __driver_attach+0x101/0x110
[    4.783327]  [<ffffffff81e47481>] __driver_attach+0x101/0x110
[    4.784228]  [<ffffffff81e47380>] ? really_probe+0x340/0x340
[    4.784228]  [<ffffffff81e47380>] ? really_probe+0x340/0x340
[    4.785110]  [<ffffffff81e4477b>] bus_for_each_dev+0xab/0x100
[    4.785110]  [<ffffffff81e4477b>] bus_for_each_dev+0xab/0x100
[    4.786004]  [<ffffffff81e477a1>] driver_attach+0x21/0x30
[    4.786004]  [<ffffffff81e477a1>] driver_attach+0x21/0x30
[    4.786846]  [<ffffffff81e458a0>] bus_add_driver+0x2a0/0x3e0
[    4.786846]  [<ffffffff81e458a0>] bus_add_driver+0x2a0/0x3e0
[    4.787721]  [<ffffffff81e48397>] driver_register+0xa7/0x190
[    4.787721]  [<ffffffff81e48397>] driver_register+0xa7/0x190
[    4.788618]  [<ffffffff8178988f>] __pci_register_driver+0x6f/0x80
[    4.788618]  [<ffffffff8178988f>] __pci_register_driver+0x6f/0x80
[    4.789564]  [<ffffffff819b3ff9>] drm_pci_init+0x139/0x170
[    4.789564]  [<ffffffff819b3ff9>] drm_pci_init+0x139/0x170
[    4.790445]  [<ffffffff839234c6>] ? mgag200_init+0x3c/0x3c
[    4.790445]  [<ffffffff839234c6>] ? mgag200_init+0x3c/0x3c
[    4.791306]  [<ffffffff839234f9>] cirrus_init+0x33/0x3c
[    4.791306]  [<ffffffff839234f9>] cirrus_init+0x33/0x3c
[    4.792129]  [<ffffffff838d88d6>] do_one_initcall+0x176/0x247
[    4.792129]  [<ffffffff838d88d6>] do_one_initcall+0x176/0x247
[    4.793030]  [<ffffffff838d8b79>] kernel_init_freeable+0x1d2/0x2d4
[    4.793030]  [<ffffffff838d8b79>] kernel_init_freeable+0x1d2/0x2d4
[    4.793999]  [<ffffffff824c2750>] ? rest_init+0x130/0x130
[    4.793999]  [<ffffffff824c2750>] ? rest_init+0x130/0x130
[    4.794847]  [<ffffffff824c2761>] kernel_init+0x11/0x1a0
[    4.794847]  [<ffffffff824c2761>] kernel_init+0x11/0x1a0
[    4.795676]  [<ffffffff824e7f3c>] ret_from_fork+0x7c/0xb0
[    4.795676]  [<ffffffff824e7f3c>] ret_from_fork+0x7c/0xb0
[    4.796523]  [<ffffffff824c2750>] ? rest_init+0x130/0x130
[    4.796523]  [<ffffffff824c2750>] ? rest_init+0x130/0x130
[    4.797374] ---[ end trace 84335bfc53d465fe ]---
[    4.797374] ---[ end trace 84335bfc53d465fe ]---

git bisect start 7bf2844ed14de049a4ccec26eb3d8b4c3d5c1971 955289c7cfad158dc939e150896a240f549ccc60 --
git bisect good a18c0af171bfb875012da26f23df051004726973  # 06:09     20+     20  drm: Zero out DRM object memory upon cleanup
git bisect good ae28290be3871969fc3f64b480d42575a16ae990  # 06:21     20+     20  drm: bit of spell-check / editorializing.
git bisect good 05acaec334fcc1132d1e48c5042e044651e0b75b  # 06:32     20+     20  drm: Reorganize probed mode validation
git bisect good 261ea74f3689a997502f1264494f1749951a05a8  # 06:47     20+     20  drm: Remove stale comment
git bisect good 6d11a2f00724d52b988b5fedc6e6a050e1a46389  # 06:59     20+     20  drm: Make drm_crtc_helper.h standalone includible
git bisect good 7552e7dd9527c41f891c87854418896eaf309c20  # 07:07     20+     20  drm: Include drm_crtc_helper.h in DocBook
# first bad commit: [7bf2844ed14de049a4ccec26eb3d8b4c3d5c1971] drm/fb-helper: Propagate errors from initial config failure
git bisect good 7552e7dd9527c41f891c87854418896eaf309c20  # 07:13     60+     80  drm: Include drm_crtc_helper.h in DocBook
# extra tests on HEAD of drm-intel/topic/core-stuff
git bisect  bad 7bf2844ed14de049a4ccec26eb3d8b4c3d5c1971  # 07:13      0-     12  drm/fb-helper: Propagate errors from initial config failure
# extra tests on tree/branch drm-intel/topic/core-stuff
git bisect  bad 7bf2844ed14de049a4ccec26eb3d8b4c3d5c1971  # 07:13      0-     12  drm/fb-helper: Propagate errors from initial config failure
# extra tests on tree/branch linus/master
git bisect good 87c31b39abcb6fb6bd7d111200c9627a594bf6a9  # 07:19     60+     64  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace
# extra tests on tree/branch next/master
git bisect good 5fef85d456eedf616809f7bf722b6f6a782d8a93  # 07:30     60+     60  Add linux-next specific files for 20141217


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=quantal-core-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-cpu kvm64
	-enable-kvm
	-kernel $kernel
	-initrd $initrd
	-m 320
	-smp 2
	-net nic,vlan=1,model=e1000
	-net user,vlan=1
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-rtc base=localtime
	-serial stdio
	-display none
	-monitor null 
)

append=(
	hung_task_panic=1
	earlyprintk=ttyS0,115200
	debug
	apic=debug
	sysrq_always_enabled
	rcupdate.rcu_cpu_stall_timeout=100
	panic=-1
	softlockup_panic=1
	nmi_watchdog=panic
	oops=panic
	load_ramdisk=2
	prompt_ramdisk=0
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
	drbd.minor_count=8
)

"${kvm[@]}" --append "${append[*]}"
----------------------------------------------------------------------------

Thanks,
Fengguang

--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-client6-7:20141218055208:x86_64-randconfig-n0-12152252:3.18.0-rc4-g7bf2844:20"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc4-g7bf2844 (kbuild@lkp-nhm1) (gcc ver=
sion 4.9.1 (Debian 4.9.1-19) ) #20 SMP Thu Dec 18 05:42:46 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-n0-12152252/drm-intel:topic:core-stuff:7bf2844ed14de049a4ccec26eb3d8b4=
c3d5c1971:bisect-linux-0/.vmlinuz-7bf2844ed14de049a4ccec26eb3d8b4c3d5c1971-=
20141218055117-9-client6 branch=3Ddrm-intel/topic/core-stuff BOOT_IMAGE=3D/=
kernel/x86_64-randconfig-n0-12152252/7bf2844ed14de049a4ccec26eb3d8b4c3d5c19=
71/vmlinuz-3.18.0-rc4-g7bf2844 drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   Centaur CentaurHauls
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x400000000
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
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[ffff8800000f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x04e25000, 0x04e25fff] PGTABLE
[    0.000000] BRK [0x04e26000, 0x04e26fff] PGTABLE
[    0.000000] BRK [0x04e27000, 0x04e27fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13fdffff]
[    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13fdffff] page 4k
[    0.000000] BRK [0x04e28000, 0x04e28fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x12925000-0x13fd7fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0C90 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FE18BD 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FE0B37 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FE0000 000040
[    0.000000] ACPI: SSDT 0x0000000013FE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FE1805 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FE1885 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13fdf001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1064 pages used for memmap
[    0.000000]   DMA32 zone: 77792 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff880012400000 s1917568 r0=
 d32128 u2097152
[    0.000000] pcpu-alloc: s1917568 r0 d32128 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1240db40
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80649
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-n0-12152252/drm-intel:topic:core-stuff:7bf2844ed14de049a4ccec26=
eb3d8b4c3d5c1971:bisect-linux-0/.vmlinuz-7bf2844ed14de049a4ccec26eb3d8b4c3d=
5c1971-20141218055117-9-client6 branch=3Ddrm-intel/topic/core-stuff BOOT_IM=
AGE=3D/kernel/x86_64-randconfig-n0-12152252/7bf2844ed14de049a4ccec26eb3d8b4=
c3d5c1971/vmlinuz-3.18.0-rc4-g7bf2844 drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 230136K/327160K available (21426K kernel code, 7169K=
 rwdata, 8372K rodata, 2932K init, 20728K bss, 97024K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:440 0
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc4-g7bf2844 (kbuild@lkp-nhm1) (gcc ver=
sion 4.9.1 (Debian 4.9.1-19) ) #20 SMP Thu Dec 18 05:42:46 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-n0-12152252/drm-intel:topic:core-stuff:7bf2844ed14de049a4ccec26eb3d8b4=
c3d5c1971:bisect-linux-0/.vmlinuz-7bf2844ed14de049a4ccec26eb3d8b4c3d5c1971-=
20141218055117-9-client6 branch=3Ddrm-intel/topic/core-stuff BOOT_IMAGE=3D/=
kernel/x86_64-randconfig-n0-12152252/7bf2844ed14de049a4ccec26eb3d8b4c3d5c19=
71/vmlinuz-3.18.0-rc4-g7bf2844 drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   Centaur CentaurHauls
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x400000000
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
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[ffff8800000f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x04e25000, 0x04e25fff] PGTABLE
[    0.000000] BRK [0x04e26000, 0x04e26fff] PGTABLE
[    0.000000] BRK [0x04e27000, 0x04e27fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13fdffff]
[    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13fdffff] page 4k
[    0.000000] BRK [0x04e28000, 0x04e28fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x12925000-0x13fd7fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0C90 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FE18BD 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FE0B37 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FE0000 000040
[    0.000000] ACPI: SSDT 0x0000000013FE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FE1805 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FE1885 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13fdf001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1064 pages used for memmap
[    0.000000]   DMA32 zone: 77792 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff880012400000 s1917568 r0=
 d32128 u2097152
[    0.000000] pcpu-alloc: s1917568 r0 d32128 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1240db40
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80649
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-n0-12152252/drm-intel:topic:core-stuff:7bf2844ed14de049a4ccec26=
eb3d8b4c3d5c1971:bisect-linux-0/.vmlinuz-7bf2844ed14de049a4ccec26eb3d8b4c3d=
5c1971-20141218055117-9-client6 branch=3Ddrm-intel/topic/core-stuff BOOT_IM=
AGE=3D/kernel/x86_64-randconfig-n0-12152252/7bf2844ed14de049a4ccec26eb3d8b4=
c3d5c1971/vmlinuz-3.18.0-rc4-g7bf2844 drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 230136K/327160K available (21426K kernel code, 7169K=
 rwdata, 8372K rodata, 2932K init, 20728K bss, 97024K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:440 0
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8639 kB
[    0.000000]  memory used by lock dependency info: 8639 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ODEBUG: selftest passed
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2925.998 MHz processor
[    0.000000] tsc: Detected 2925.998 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.020000] Calibrating delay loop (skipped) preset value..=20
[    0.020000] Calibrating delay loop (skipped) preset value.. 5851.99 Bogo=
MIPS (lpj=3D29259980)
5851.99 BogoMIPS (lpj=3D29259980)
[    0.020000] pid_max: default: 4096 minimum: 301
[    0.020000] pid_max: default: 4096 minimum: 301
[    0.020000] ACPI: Core revision 20140926
[    0.020000] ACPI: Core revision 20140926
[    0.020000] ACPI:=20
[    0.020000] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.020023] Security Framework initialized
[    0.020023] Security Framework initialized
[    0.020754] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.020754] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.021882] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.021882] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.023366] Initializing cgroup subsys devices
[    0.023366] Initializing cgroup subsys devices
[    0.024150] Initializing cgroup subsys freezer
[    0.024150] Initializing cgroup subsys freezer
[    0.024921] Initializing cgroup subsys perf_event
[    0.024921] Initializing cgroup subsys perf_event
[    0.025743] Initializing cgroup subsys hugetlb
[    0.025743] Initializing cgroup subsys hugetlb
[    0.026505] Initializing cgroup subsys debug
[    0.026505] Initializing cgroup subsys debug
[    0.027277] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.027277] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.027277] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.027277] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.029303] Freeing SMP alternatives memory: 28K (ffffffff839df000 - fff=
fffff839e6000)
[    0.029303] Freeing SMP alternatives memory: 28K (ffffffff839df000 - fff=
fffff839e6000)
[    0.032353] Getting VERSION: 1050014
[    0.032353] Getting VERSION: 1050014
[    0.032975] Getting VERSION: 1050014
[    0.032975] Getting VERSION: 1050014
[    0.033590] Getting ID: 0
[    0.033590] Getting ID: 0
[    0.034045] Getting ID: ff000000
[    0.034045] Getting ID: ff000000
[    0.034604] Getting LVT0: 8700
[    0.034604] Getting LVT0: 8700
[    0.035130] Getting LVT1: 8400
[    0.035130] Getting LVT1: 8400
[    0.035694] enabled ExtINT on CPU#0
[    0.035694] enabled ExtINT on CPU#0
[    0.036964] ENABLING IO-APIC IRQs
[    0.036964] ENABLING IO-APIC IRQs
[    0.037553] init IO_APIC IRQs
[    0.037553] init IO_APIC IRQs
[    0.038061]  apic 0 pin 0 not connected
[    0.038061]  apic 0 pin 0 not connected
[    0.038727] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.038727] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.040029] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.040029] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.041385] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.041385] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.042727] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.042727] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.044070] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.044070] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.045419] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.045419] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.046766] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.046766] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.048122] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.048122] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.050023] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.050023] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.051365] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.051365] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.052698] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.052698] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.054062] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.054062] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.055423] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.055423] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.056795] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.056795] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.058152] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.058152] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.059521] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.059521] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.060021]  apic 0 pin 16 not connected
[    0.060021]  apic 0 pin 16 not connected
[    0.060687]  apic 0 pin 17 not connected
[    0.060687]  apic 0 pin 17 not connected
[    0.061345]  apic 0 pin 18 not connected
[    0.061345]  apic 0 pin 18 not connected
[    0.062007]  apic 0 pin 19 not connected
[    0.062007]  apic 0 pin 19 not connected
[    0.062668]  apic 0 pin 20 not connected
[    0.062668]  apic 0 pin 20 not connected
[    0.063321]  apic 0 pin 21 not connected
[    0.063321]  apic 0 pin 21 not connected
[    0.063978]  apic 0 pin 22 not connected
[    0.063978]  apic 0 pin 22 not connected
[    0.064636]  apic 0 pin 23 not connected
[    0.064636]  apic 0 pin 23 not connected
[    0.065435] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.065435] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.066617] smpboot: CPU0:=20
[    0.066617] smpboot: CPU0: GenuineIntel GenuineIntel Common KVM processo=
rCommon KVM processor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.068393] Using local APIC timer interrupts.
[    0.068393] calibrating APIC timer ...
[    0.068393] Using local APIC timer interrupts.
[    0.068393] calibrating APIC timer ...
[    0.080000] ... lapic delta =3D 6251091
[    0.080000] ... lapic delta =3D 6251091
[    0.080000] ... PM-Timer delta =3D 357986
[    0.080000] ... PM-Timer delta =3D 357986
[    0.080000] ... PM-Timer result ok
[    0.080000] ... PM-Timer result ok
[    0.080000] ..... delta 6251091
[    0.080000] ..... delta 6251091
[    0.080000] ..... mult: 268482314
[    0.080000] ..... mult: 268482314
[    0.080000] ..... calibration result: 10001745
[    0.080000] ..... calibration result: 10001745
[    0.080000] ..... CPU clock speed is 2926.2700 MHz.
[    0.080000] ..... CPU clock speed is 2926.2700 MHz.
[    0.080000] ..... host bus clock speed is 1000.1745 MHz.
[    0.080000] ..... host bus clock speed is 1000.1745 MHz.
[    0.080000] Performance Events:=20
[    0.080000] Performance Events: no PMU driver, software events only.
no PMU driver, software events only.
[    0.080000] x86: Booting SMP configuration:
[    0.080000] x86: Booting SMP configuration:
[    0.080000] .... node  #0, CPUs: =20
[    0.080000] .... node  #0, CPUs:         #1 #1
[    0.080000] kvm-clock: cpu 1, msr 0:13fdf041, secondary cpu clock
[    0.085130] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.080000] masked ExtINT on CPU#1
[    0.086841] x86: Booted up 1 node, 2 CPUs
[    0.086841] x86: Booted up 1 node, 2 CPUs
[    0.086788] KVM setup async PF for cpu 1
[    0.086788] KVM setup async PF for cpu 1
[    0.086788] kvm-stealtime: cpu 1, msr 1260db40
[    0.086788] kvm-stealtime: cpu 1, msr 1260db40
[    0.088891] ----------------
[    0.088891] ----------------
[    0.089372] | NMI testsuite:
[    0.089372] | NMI testsuite:
[    0.089850] --------------------
[    0.089850] --------------------
[    0.090005]   remote IPI:
[    0.090005]   remote IPI:  ok  |  ok  |

[    0.100205]    local IPI:
[    0.100205]    local IPI:  ok  |  ok  |

[    0.120043] --------------------
[    0.120043] --------------------
[    0.120605] Good, all   2 testcases passed! |
[    0.120605] Good, all   2 testcases passed! |
[    0.121316] ---------------------------------
[    0.121316] ---------------------------------
[    0.122044] smpboot: Total of 2 processors activated (11703.99 BogoMIPS)
[    0.122044] smpboot: Total of 2 processors activated (11703.99 BogoMIPS)
[    0.123688] devtmpfs: initialized
[    0.123688] devtmpfs: initialized
[    0.123688] gcov: version magic: 0x3430392a
[    0.123688] gcov: version magic: 0x3430392a
[    0.124115] xor: measuring software checksum speed
[    0.124115] xor: measuring software checksum speed
[    0.220012]    prefetch64-sse: 11678.400 MB/sec
[    0.220012]    prefetch64-sse: 11678.400 MB/sec
[    0.320014]    generic_sse: 10448.800 MB/sec
[    0.320014]    generic_sse: 10448.800 MB/sec
[    0.320752] xor: using function: prefetch64-sse (11678.400 MB/sec)
[    0.320752] xor: using function: prefetch64-sse (11678.400 MB/sec)
[    0.321787] prandom: seed boundary self test passed
[    0.321787] prandom: seed boundary self test passed
[    0.323140] prandom: 100 self tests passed
[    0.323140] prandom: 100 self tests passed
[    0.324150] regulator-dummy: no parameters
[    0.324150] regulator-dummy: no parameters
[    0.325134] NET: Registered protocol family 16
[    0.325134] NET: Registered protocol family 16
[    0.330057] cpuidle: using governor ladder
[    0.330057] cpuidle: using governor ladder
[    0.340088] cpuidle: using governor menu
[    0.340088] cpuidle: using governor menu
[    0.341997] ACPI: bus type PCI registered
[    0.341997] ACPI: bus type PCI registered
[    0.343367] dca service started, version 1.12.1
[    0.343367] dca service started, version 1.12.1
[    0.344685] PCI: Using configuration type 1 for base access
[    0.344685] PCI: Using configuration type 1 for base access
[    0.540031] raid6: sse2x1    2496 MB/s
[    0.540031] raid6: sse2x1    2496 MB/s
[    0.710012] raid6: sse2x2    2677 MB/s
[    0.710012] raid6: sse2x2    2677 MB/s
[    0.880012] raid6: sse2x4    2628 MB/s
[    0.880012] raid6: sse2x4    2628 MB/s
[    0.880651] raid6: using algorithm sse2x2 (2677 MB/s)
[    0.880651] raid6: using algorithm sse2x2 (2677 MB/s)
[    0.881477] raid6: using intx1 recovery algorithm
[    0.881477] raid6: using intx1 recovery algorithm
[    0.882345] gpio-f7188x: Not a Fintek device at 0x0000002e
[    0.882345] gpio-f7188x: Not a Fintek device at 0x0000002e
[    0.883275] gpio-f7188x: Not a Fintek device at 0x0000004e
[    0.883275] gpio-f7188x: Not a Fintek device at 0x0000004e
[    0.884393] ACPI: Added _OSI(Module Device)
[    0.884393] ACPI: Added _OSI(Module Device)
[    0.885089] ACPI: Added _OSI(Processor Device)
[    0.885089] ACPI: Added _OSI(Processor Device)
[    0.885820] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.885820] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.886594] ACPI: Added _OSI(Processor Aggregator Device)
[    0.886594] ACPI: Added _OSI(Processor Aggregator Device)
[    0.889328] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:3)
[    0.889328] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:3)
[    0.893590] ACPI: Interpreter enabled
[    0.893590] ACPI: Interpreter enabled
[    0.894243] ACPI: (supports S0 S4 S5)
[    0.894243] ACPI: (supports S0 S4 S5)
[    0.894850] ACPI: Using IOAPIC for interrupt routing
[    0.894850] ACPI: Using IOAPIC for interrupt routing
[    0.895693] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.895693] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.907158] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.907158] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.908211] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.908211] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.909128] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.909128] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.910345] PCI host bridge to bus 0000:00
[    0.910345] PCI host bridge to bus 0000:00
[    0.911030] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.911030] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.911925] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.911925] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.912933] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.912933] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.913938] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.913938] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.914949] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.914949] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.915956] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.915956] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.916969] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.916969] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.918102] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.918102] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.919262] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.919262] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.920547] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.920547] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.922133] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.922133] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.925537] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.925537] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.927290] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.927290] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.928432] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.928432] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.929482] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.929482] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.930014] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.930014] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.931406] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.931406] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.932686] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.932686] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.933850] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.933850] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.935353] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.935353] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.937330] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.937330] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.940018] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.940018] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.945478] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.945478] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.946969] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.946969] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.948725] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.948725] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.950754] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.950754] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.955426] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.955426] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.956965] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.956965] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.958354] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.958354] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.962278] pci_bus 0000:00: on NUMA node 0
[    0.962278] pci_bus 0000:00: on NUMA node 0
[    0.963768] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.963768] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.964923] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.964923] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.966068] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.966068] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.967243] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.967243] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.968300] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.968300] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.969878] ACPI:=20
[    0.969878] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    0.970797] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.970797] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.971128] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.971128] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.972688] vgaarb: loaded
[    0.972688] vgaarb: loaded
[    0.973138] vgaarb: bridge control possible 0000:00:02.0
[    0.973138] vgaarb: bridge control possible 0000:00:02.0
[    0.975031] SCSI subsystem initialized
[    0.975031] SCSI subsystem initialized
[    0.975031] ACPI: bus type USB registered
[    0.975031] ACPI: bus type USB registered
[    0.975031] usbcore: registered new interface driver usbfs
[    0.975031] usbcore: registered new interface driver usbfs
[    0.975031] usbcore: registered new interface driver hub
[    0.975031] usbcore: registered new interface driver hub
[    0.980033] usbcore: registered new device driver usb
[    0.980033] usbcore: registered new device driver usb
[    0.980033] Linux video capture interface: v2.00
[    0.980033] Linux video capture interface: v2.00
[    0.980033] wmi: Mapper loaded
[    0.980033] wmi: Mapper loaded
[    0.982376] PCI: Using ACPI for IRQ routing
[    0.982376] PCI: Using ACPI for IRQ routing
[    0.982376] PCI: pci_cache_line_size set to 64 bytes
[    0.982376] PCI: pci_cache_line_size set to 64 bytes
[    0.982376] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.982376] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.982906] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    0.982906] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    0.984606] Switched to clocksource kvm-clock
[    0.984606] Switched to clocksource kvm-clock
[    0.984606] pnp: PnP ACPI init
[    0.984606] pnp: PnP ACPI init
[    0.984606] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.984606] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.984606] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.984606] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.984606] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.984606] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.985484] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.985484] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.986612] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.986612] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.988031] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.988031] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.989181] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.989181] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.990508] pnp 00:03: [dma 2]
[    0.990508] pnp 00:03: [dma 2]
[    0.991057] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.991057] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.992226] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.992226] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.993577] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.993577] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.994725] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.994725] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.996094] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.996094] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.997758] pnp: PnP ACPI: found 6 devices
[    0.997758] pnp: PnP ACPI: found 6 devices
[    1.004185] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.004185] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.005419] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    1.005419] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    1.006650] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    1.006650] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    1.007564] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    1.007564] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    1.008525] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    1.008525] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    1.009439] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    1.009439] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    1.010500] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    1.010500] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    1.011677] NET: Registered protocol family 1
[    1.011677] NET: Registered protocol family 1
[    1.012416] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.012416] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.013406] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.013406] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.014375] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.014375] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.015419] pci 0000:00:02.0: Video device with shadowed ROM
[    1.015419] pci 0000:00:02.0: Video device with shadowed ROM
[    1.016381] PCI: CLS 0 bytes, default 64
[    1.016381] PCI: CLS 0 bytes, default 64
[    1.017201] Unpacking initramfs...
[    1.017201] Unpacking initramfs...
[    1.561679] Freeing initrd memory: 23244K (ffff880012925000 - ffff880013=
fd8000)
[    1.561679] Freeing initrd memory: 23244K (ffff880012925000 - ffff880013=
fd8000)
[    1.569621] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usab=
le.
[    1.569621] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usab=
le.
[    1.570830] PCLMULQDQ-NI instructions are not detected.
[    1.570830] PCLMULQDQ-NI instructions are not detected.
[    1.571699] AVX or AES-NI instructions are not detected.
[    1.571699] AVX or AES-NI instructions are not detected.
[    1.572576] AVX instructions are not detected.
[    1.572576] AVX instructions are not detected.
[    1.573312] AVX instructions are not detected.
[    1.573312] AVX instructions are not detected.
[    1.574044] AVX instructions are not detected.
[    1.574044] AVX instructions are not detected.
[    1.574770] AVX2 or AES-NI instructions are not detected.
[    1.574770] AVX2 or AES-NI instructions are not detected.
[    1.576245] futex hash table entries: 16 (order: -1, 2048 bytes)
[    1.576245] futex hash table entries: 16 (order: -1, 2048 bytes)
[    2.066634] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.066634] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.067977] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    2.067977] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    2.069390] ntfs: driver 2.1.31 [Flags: R/W DEBUG].
[    2.069390] ntfs: driver 2.1.31 [Flags: R/W DEBUG].
[    2.070301] efs: 1.0a - http://aeschi.ch.eu.org/efs/
[    2.070301] efs: 1.0a - http://aeschi.ch.eu.org/efs/
[    2.072541] qnx6: QNX6 filesystem 1.0.0 registered.
[    2.072541] qnx6: QNX6 filesystem 1.0.0 registered.
[    2.073502] fuse init (API version 7.23)
[    2.073502] fuse init (API version 7.23)
[    2.074501] JFS: nTxBlock =3D 1979, nTxLock =3D 15838
[    2.074501] JFS: nTxBlock =3D 1979, nTxLock =3D 15838
[    2.076431] SGI XFS with ACLs, security attributes, realtime, no debug e=
nabled
[    2.076431] SGI XFS with ACLs, security attributes, realtime, no debug e=
nabled
[    2.078979] gfs2: GFS2 installed
[    2.078979] gfs2: GFS2 installed
[    2.079642] msgmni has been set to 494
[    2.079642] msgmni has been set to 494
[    2.080310] Key type big_key registered
[    2.080310] Key type big_key registered
[    2.085827] Key type asymmetric registered
[    2.085827] Key type asymmetric registered
[    2.086514] Asymmetric key parser 'x509' registered
[    2.086514] Asymmetric key parser 'x509' registered
[    2.087371] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 252)
[    2.087371] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 252)
[    2.088603] io scheduler noop registered
[    2.088603] io scheduler noop registered
[    2.089268] io scheduler cfq registered (default)
[    2.089268] io scheduler cfq registered (default)
[    2.090063] start plist test
[    2.090063] start plist test
[    2.092106] end plist test
[    2.092106] end plist test
[    2.092561] test_string_helpers: Running tests...
[    2.092561] test_string_helpers: Running tests...
[    2.093673] test_firmware: interface ready
[    2.093673] test_firmware: interface ready
[    2.094448] xz_dec_test: module loaded
[    2.094448] xz_dec_test: module loaded
[    2.095081] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
251 0' and write .xz files to it.
[    2.095081] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
251 0' and write .xz files to it.
[    2.096713] rbtree testing
[    2.096713] rbtree testing -> 29779 cycles
 -> 29779 cycles
[    3.166821] augmented rbtree testing
[    3.166821] augmented rbtree testing -> 39309 cycles
 -> 39309 cycles
[    4.578829] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    4.578829] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    4.579678] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    4.579678] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    4.581103] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    4.581103] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    4.582384] vmlfb: initializing
[    4.582384] vmlfb: initializing
[    4.582923] Could not find Carillo Ranch MCH device.
[    4.582923] Could not find Carillo Ranch MCH device.
[    4.583730] no IO addresses supplied
[    4.583730] no IO addresses supplied
[    4.584412] hgafb: HGA card not detected.
[    4.584412] hgafb: HGA card not detected.
[    4.585059] hgafb: probe of hgafb.0 failed with error -22
[    4.585059] hgafb: probe of hgafb.0 failed with error -22
[    4.586007] usbcore: registered new interface driver udlfb
[    4.586007] usbcore: registered new interface driver udlfb
[    4.586899] usbcore: registered new interface driver smscufx
[    4.586899] usbcore: registered new interface driver smscufx
[    4.587880] ipmi message handler version 39.2
[    4.587880] ipmi message handler version 39.2
[    4.588575] ipmi device interface
[    4.588575] ipmi device interface
[    4.589156] IPMI System Interface driver.
[    4.589156] IPMI System Interface driver.
[    4.589859] ipmi_si: Adding default-specified kcs state machine
[    4.589859] ipmi_si: Adding default-specified kcs state machine

[    4.590848] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    4.590848] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    4.592411] ipmi_si: Interface detection failed
[    4.592411] ipmi_si: Interface detection failed
[    4.640212] ipmi_si: Adding default-specified smic state machine
[    4.640212] ipmi_si: Adding default-specified smic state machine

[    4.641218] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    4.641218] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    4.642841] ipmi_si: Interface detection failed
[    4.642841] ipmi_si: Interface detection failed
[    4.670081] ipmi_si: Adding default-specified bt state machine
[    4.670081] ipmi_si: Adding default-specified bt state machine

[    4.671055] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    4.671055] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    4.672700] ipmi_si: Interface detection failed
[    4.672700] ipmi_si: Interface detection failed
[    4.690192] ipmi_si: Unable to find any System Interface(s)
[    4.690192] ipmi_si: Unable to find any System Interface(s)
[    4.691292] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    4.691292] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    4.692483] ACPI: Power Button [PWRF]
[    4.692483] ACPI: Power Button [PWRF]
[    4.693656] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    4.693656] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    4.694726] xenfs: not registering filesystem on non-xen platform
[    4.694726] xenfs: not registering filesystem on non-xen platform
[    4.695939] r3964: Philips r3964 Driver $Revision: 1.10 $
[    4.695939] r3964: Philips r3964 Driver $Revision: 1.10 $
[    4.696800] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    4.696800] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    4.724385] serial 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 1=
15200) is a 16550A
[    4.724385] serial 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 1=
15200) is a 16550A
[    4.727539] serial: Freescale lpuart driver
[    4.727539] serial: Freescale lpuart driver
[    4.728291] Initializing Nozomi driver 2.1d
[    4.728291] Initializing Nozomi driver 2.1d
[    4.729440] lp: driver loaded but no devices found
[    4.729440] lp: driver loaded but no devices found
[    4.730241] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    4.730241] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    4.731356] ac.o: No PCI boards found.
[    4.731356] ac.o: No PCI boards found.
[    4.731947] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    4.731947] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    4.733369] ppdev: user-space parallel port driver
[    4.733369] ppdev: user-space parallel port driver
[    4.734161] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    4.734161] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    4.734973] smapi::smapi_init, ERROR invalid usSmapiID
[    4.734973] smapi::smapi_init, ERROR invalid usSmapiID
[    4.735779] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    4.735779] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    4.737262] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    4.737262] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    4.738403] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    4.738403] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    4.739386] Linux agpgart interface v0.103
[    4.739386] Linux agpgart interface v0.103
[    4.740297] SyncLink PC Card driver $Revision: 4.34 $, tty major#244
[    4.740297] SyncLink PC Card driver $Revision: 4.34 $, tty major#244
[    4.741367] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    4.741367] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    4.742923] [drm] Initialized drm 1.1.0 20060810
[    4.742923] [drm] Initialized drm 1.1.0 20060810
[    4.743801] [drm] radeon kernel modesetting enabled.
[    4.743801] [drm] radeon kernel modesetting enabled.
[    4.744644] drm/i810 does not support SMP
[    4.744644] drm/i810 does not support SMP
[    4.746178] [TTM] Zone  kernel: Available graphics memory: 126704 kiB
[    4.746178] [TTM] Zone  kernel: Available graphics memory: 126704 kiB
[    4.747200] [TTM] Initializing pool allocator
[    4.747200] [TTM] Initializing pool allocator
[    4.747910] [TTM] Initializing DMA pool allocator
[    4.747910] [TTM] Initializing DMA pool allocator
[    4.749257] [drm] fb mappable at 0xFC000000
[    4.749257] [drm] fb mappable at 0xFC000000
[    4.749947] [drm] vram aper at 0xFC000000
[    4.749947] [drm] vram aper at 0xFC000000
[    4.750603] [drm] size 33554432
[    4.750603] [drm] size 33554432
[    4.751111] [drm] fb depth is 24
[    4.751111] [drm] fb depth is 24
[    4.751616] [drm]    pitch is 3072
[    4.751616] [drm]    pitch is 3072
[    4.752192] cirrusdrmfb: enable CONFIG_FB_LITTLE_ENDIAN to support this =
framebuffer
[    4.752192] cirrusdrmfb: enable CONFIG_FB_LITTLE_ENDIAN to support this =
framebuffer
[    4.753421] [drm:cirrus_modeset_init] *ERROR* cirrus_fbdev_init failed
[    4.753421] [drm:cirrus_modeset_init] *ERROR* cirrus_fbdev_init failed
[    4.754439] cirrus 0000:00:02.0: Fatal error during modeset init: -22
[    4.754439] cirrus 0000:00:02.0: Fatal error during modeset init: -22
[    4.756061] ------------[ cut here ]------------
[    4.756061] ------------[ cut here ]------------
[    4.756800] WARNING: CPU: 1 PID: 1 at lib/idr.c:506 idr_remove+0x384/0x3=
b0()
[    4.756800] WARNING: CPU: 1 PID: 1 at lib/idr.c:506 idr_remove+0x384/0x3=
b0()
[    4.758132] idr_remove called for id=3D20 which is not allocated.
[    4.758132] idr_remove called for id=3D20 which is not allocated.
[    4.759056] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc4-g7bf284=
4 #20
[    4.759056] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc4-g7bf284=
4 #20
[    4.760184]  0000000000000009
[    4.760184]  0000000000000009 ffff88001147fa08 ffff88001147fa08 ffffffff=
824ce992 ffffffff824ce992 ffffffff81151538 ffffffff81151538

[    4.761391]  ffff88001147fa58
[    4.761391]  ffff88001147fa58 ffff88001147fa48 ffff88001147fa48 ffffffff=
810dac1a ffffffff810dac1a ffff88001147fa78 ffff88001147fa78

[    4.762593]  ffff88001147fac8
[    4.762593]  ffff88001147fac8 ffff880012c916f8 ffff880012c916f8 ffff8800=
12d01310 ffff880012d01310 ffff880012c91060 ffff880012c91060

[    4.763796] Call Trace:
[    4.763796] Call Trace:
[    4.764187]  [<ffffffff824ce992>] dump_stack+0x86/0xbc
[    4.764187]  [<ffffffff824ce992>] dump_stack+0x86/0xbc
[    4.764995]  [<ffffffff81151538>] ? console_unlock+0x3b8/0x7a0
[    4.764995]  [<ffffffff81151538>] ? console_unlock+0x3b8/0x7a0
[    4.765908]  [<ffffffff810dac1a>] warn_slowpath_common+0x9a/0xd0
[    4.765908]  [<ffffffff810dac1a>] warn_slowpath_common+0x9a/0xd0
[    4.766846]  [<ffffffff810dace1>] warn_slowpath_fmt+0x51/0x60
[    4.766846]  [<ffffffff810dace1>] warn_slowpath_fmt+0x51/0x60
[    4.767740]  [<ffffffff819b7c7c>] ? drm_mode_object_put+0x2c/0x70
[    4.767740]  [<ffffffff819b7c7c>] ? drm_mode_object_put+0x2c/0x70
[    4.768689]  [<ffffffff8170f7c4>] idr_remove+0x384/0x3b0
[    4.768689]  [<ffffffff8170f7c4>] idr_remove+0x384/0x3b0
[    4.769521]  [<ffffffff81738039>] ? debug_check_no_obj_freed+0x29/0x40
[    4.769521]  [<ffffffff81738039>] ? debug_check_no_obj_freed+0x29/0x40
[    4.770551]  [<ffffffff819b7c94>] drm_mode_object_put+0x44/0x70
[    4.770551]  [<ffffffff819b7c94>] drm_mode_object_put+0x44/0x70
[    4.771473]  [<ffffffff819c1bba>] drm_mode_destroy+0x2a/0x50
[    4.771473]  [<ffffffff819c1bba>] drm_mode_destroy+0x2a/0x50
[    4.772358]  [<ffffffff8199d155>] drm_fb_helper_crtc_free+0xc5/0x110
[    4.772358]  [<ffffffff8199d155>] drm_fb_helper_crtc_free+0xc5/0x110
[    4.773348]  [<ffffffff8199e724>] drm_fb_helper_fini+0x74/0xc0
[    4.773348]  [<ffffffff8199e724>] drm_fb_helper_fini+0x74/0xc0
[    4.774259]  [<ffffffff81cbaa73>] cirrus_fbdev_fini+0x193/0x230
[    4.774259]  [<ffffffff81cbaa73>] cirrus_fbdev_fini+0x193/0x230
[    4.775186]  [<ffffffff81cb98c9>] cirrus_modeset_fini+0x19/0x50
[    4.775186]  [<ffffffff81cb98c9>] cirrus_modeset_fini+0x19/0x50
[    4.776117]  [<ffffffff81cb7afb>] cirrus_driver_unload+0x2b/0x80
[    4.776117]  [<ffffffff81cb7afb>] cirrus_driver_unload+0x2b/0x80
[    4.777061]  [<ffffffff81cb7c97>] cirrus_driver_load+0x147/0x220
[    4.777061]  [<ffffffff81cb7c97>] cirrus_driver_load+0x147/0x220
[    4.778004]  [<ffffffff819b0515>] drm_dev_register+0x115/0x1c0
[    4.778004]  [<ffffffff819b0515>] drm_dev_register+0x115/0x1c0
[    4.778917]  [<ffffffff819b3c8c>] drm_get_pci_dev+0xcc/0x300
[    4.778917]  [<ffffffff819b3c8c>] drm_get_pci_dev+0xcc/0x300
[    4.779807]  [<ffffffff824e3361>] ? mutex_unlock+0x11/0x20
[    4.779807]  [<ffffffff824e3361>] ? mutex_unlock+0x11/0x20
[    4.780675]  [<ffffffff81cb9b7a>] cirrus_pci_probe+0x13a/0x180
[    4.780675]  [<ffffffff81cb9b7a>] cirrus_pci_probe+0x13a/0x180
[    4.781586]  [<ffffffff817893fc>] pci_device_probe+0xbc/0x180
[    4.781586]  [<ffffffff817893fc>] pci_device_probe+0xbc/0x180
[    4.782482]  [<ffffffff81e470bb>] really_probe+0x7b/0x340
[    4.782482]  [<ffffffff81e470bb>] really_probe+0x7b/0x340
[    4.783327]  [<ffffffff81e47481>] __driver_attach+0x101/0x110
[    4.783327]  [<ffffffff81e47481>] __driver_attach+0x101/0x110
[    4.784228]  [<ffffffff81e47380>] ? really_probe+0x340/0x340
[    4.784228]  [<ffffffff81e47380>] ? really_probe+0x340/0x340
[    4.785110]  [<ffffffff81e4477b>] bus_for_each_dev+0xab/0x100
[    4.785110]  [<ffffffff81e4477b>] bus_for_each_dev+0xab/0x100
[    4.786004]  [<ffffffff81e477a1>] driver_attach+0x21/0x30
[    4.786004]  [<ffffffff81e477a1>] driver_attach+0x21/0x30
[    4.786846]  [<ffffffff81e458a0>] bus_add_driver+0x2a0/0x3e0
[    4.786846]  [<ffffffff81e458a0>] bus_add_driver+0x2a0/0x3e0
[    4.787721]  [<ffffffff81e48397>] driver_register+0xa7/0x190
[    4.787721]  [<ffffffff81e48397>] driver_register+0xa7/0x190
[    4.788618]  [<ffffffff8178988f>] __pci_register_driver+0x6f/0x80
[    4.788618]  [<ffffffff8178988f>] __pci_register_driver+0x6f/0x80
[    4.789564]  [<ffffffff819b3ff9>] drm_pci_init+0x139/0x170
[    4.789564]  [<ffffffff819b3ff9>] drm_pci_init+0x139/0x170
[    4.790445]  [<ffffffff839234c6>] ? mgag200_init+0x3c/0x3c
[    4.790445]  [<ffffffff839234c6>] ? mgag200_init+0x3c/0x3c
[    4.791306]  [<ffffffff839234f9>] cirrus_init+0x33/0x3c
[    4.791306]  [<ffffffff839234f9>] cirrus_init+0x33/0x3c
[    4.792129]  [<ffffffff838d88d6>] do_one_initcall+0x176/0x247
[    4.792129]  [<ffffffff838d88d6>] do_one_initcall+0x176/0x247
[    4.793030]  [<ffffffff838d8b79>] kernel_init_freeable+0x1d2/0x2d4
[    4.793030]  [<ffffffff838d8b79>] kernel_init_freeable+0x1d2/0x2d4
[    4.793999]  [<ffffffff824c2750>] ? rest_init+0x130/0x130
[    4.793999]  [<ffffffff824c2750>] ? rest_init+0x130/0x130
[    4.794847]  [<ffffffff824c2761>] kernel_init+0x11/0x1a0
[    4.794847]  [<ffffffff824c2761>] kernel_init+0x11/0x1a0
[    4.795676]  [<ffffffff824e7f3c>] ret_from_fork+0x7c/0xb0
[    4.795676]  [<ffffffff824e7f3c>] ret_from_fork+0x7c/0xb0
[    4.796523]  [<ffffffff824c2750>] ? rest_init+0x130/0x130
[    4.796523]  [<ffffffff824c2750>] ? rest_init+0x130/0x130
[    4.797374] ---[ end trace 84335bfc53d465fe ]---
[    4.797374] ---[ end trace 84335bfc53d465fe ]---
[    4.798167] [TTM] Finalizing pool allocator
[    4.798167] [TTM] Finalizing pool allocator
[    4.798879] [TTM] Finalizing DMA pool allocator
[    4.798879] [TTM] Finalizing DMA pool allocator
[    4.799835] [TTM] Zone  kernel: Used memory at exit: 0 kiB
[    4.799835] [TTM] Zone  kernel: Used memory at exit: 0 kiB
[    4.801475] cirrus: probe of 0000:00:02.0 failed with error -22
[    4.801475] cirrus: probe of 0000:00:02.0 failed with error -22
[    4.802585] usbcore: registered new interface driver udl
[    4.802585] usbcore: registered new interface driver udl
[    4.804060] parport_pc 00:04: reported by Plug and Play ACPI
[    4.804060] parport_pc 00:04: reported by Plug and Play ACPI
[    4.805041] parport0: PC-style at 0x378
[    4.805041] parport0: PC-style at 0x378, irq 7, irq 7 [ [PCSPPPCSPP,TRIS=
TATE,TRISTATE]
]
[    4.880298] lp0: using parport0 (interrupt-driven).
[    4.880298] lp0: using parport0 (interrupt-driven).
[    4.881121] lp0: console ready
[    4.881121] lp0: console ready
[    4.882274] Phantom Linux Driver, version n0.9.8, init OK
[    4.882274] Phantom Linux Driver, version n0.9.8, init OK
[    4.883325] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    4.883325] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    4.884561] c2port c2port0: C2 port uc added
[    4.884561] c2port c2port0: C2 port uc added
[    4.885249] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    4.885249] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    4.886661] Guest personality initialized and is inactive
[    4.886661] Guest personality initialized and is inactive
[    4.887611] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D60)
[    4.887611] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D60)
[    4.888745] Initialized host personality
[    4.888745] Initialized host personality
[    4.889572] usbcore: registered new interface driver rtsx_usb
[    4.889572] usbcore: registered new interface driver rtsx_usb
[    4.891158] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[    4.891158] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[    4.892046] Detecting Adaptec I2O RAID controllers...
[    4.892046] Detecting Adaptec I2O RAID controllers...
[    4.892953] Adaptec aacraid driver 1.2-0[30300]-ms
[    4.892953] Adaptec aacraid driver 1.2-0[30300]-ms
[    4.893749] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    4.893749] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    4.894972] DC390: clustering now enabled by default. If you get problem=
s load
[    4.894972] DC390: clustering now enabled by default. If you get problem=
s load
[    4.896108]        with "disable_clustering=3D1" and report to maintaine=
rs
[    4.896108]        with "disable_clustering=3D1" and report to maintaine=
rs
[    4.897228] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 ES=
T 2006)
[    4.897228] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 ES=
T 2006)
[    4.898448] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 20=
06)
[    4.898448] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 20=
06)
[    4.899616] megasas: 06.805.06.00-rc1 Thu. Sep. 4 17:00:00 PDT 2014
[    4.899616] megasas: 06.805.06.00-rc1 Thu. Sep. 4 17:00:00 PDT 2014
[    4.900671] mpt2sas version 18.100.00.00 loaded
[    4.900671] mpt2sas version 18.100.00.00 loaded
[    4.901532] mpt3sas version 04.100.00.00 loaded
[    4.901532] mpt3sas version 04.100.00.00 loaded
[    4.902401] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    4.902401] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    4.903408] 3ware Storage Controller device driver for Linux v1.26.02.00=
3.
[    4.903408] 3ware Storage Controller device driver for Linux v1.26.02.00=
3.
[    4.904517] 3ware 9000 Storage Controller device driver for Linux v2.26.=
02.014.
[    4.904517] 3ware 9000 Storage Controller device driver for Linux v2.26.=
02.014.
[    4.905701] ppa: Version 2.07 (for Linux 2.4.x)
[    4.905701] ppa: Version 2.07 (for Linux 2.4.x)
[    4.908624] imm: Version 2.05 (for Linux 2.4.0)
[    4.908624] imm: Version 2.05 (for Linux 2.4.0)
[    4.909891] RocketRAID 3xxx/4xxx Controller driver v1.8
[    4.909891] RocketRAID 3xxx/4xxx Controller driver v1.8
[    4.910748] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
[    4.910748] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
[    4.911851] esas2r: driver will not be loaded because no ATTO esas2r dev=
ices were found
[    4.911851] esas2r: driver will not be loaded because no ATTO esas2r dev=
ices were found
[    4.913169] VMware PVSCSI driver - version 1.0.5.0-k
[    4.913169] VMware PVSCSI driver - version 1.0.5.0-k
[    4.913981] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    4.913981] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    4.915040] osst :I: Tape driver with OnStream support version 0.99.4
[    4.915040] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    4.915040] osst :I: Tape driver with OnStream support version 0.99.4
[    4.915040] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    4.917135] SCSI Media Changer driver v0.25=20
[    4.917135] SCSI Media Changer driver v0.25=20
[    4.917864] osd: LOADED open-osd 0.2.1
[    4.917864] osd: LOADED open-osd 0.2.1
[    4.918672] SSFDC read-only Flash Translation layer
[    4.918672] SSFDC read-only Flash Translation layer
[    4.919713] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    4.919713] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    4.920823] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    4.920823] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    4.922046] device id =3D 2440
[    4.922046] device id =3D 2440
[    4.922507] device id =3D 2480
[    4.922507] device id =3D 2480
[    4.922982] device id =3D 24c0
[    4.922982] device id =3D 24c0
[    4.923443] device id =3D 24d0
[    4.923443] device id =3D 24d0
[    4.923909] device id =3D 25a1
[    4.923909] device id =3D 25a1
[    4.924372] device id =3D 2670
[    4.924372] device id =3D 2670
[    4.924943] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel =
Networks.
[    4.924943] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel =
Networks.
[    4.926173] pmc551: not detected
[    4.926173] pmc551: not detected
[    4.927388] ftl_cs: FTL header not found.
[    4.927388] ftl_cs: FTL header not found.
[    4.929450] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    4.929450] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    4.931009] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    4.931009] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    4.932472] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    4.932472] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    4.933976] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    4.933976] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    4.935432] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    4.935432] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    4.936932] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    4.936932] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    4.938412] nand: device found, Manufacturer ID: 0x98, Chip ID: 0x39
[    4.938412] nand: device found, Manufacturer ID: 0x98, Chip ID: 0x39
[    4.939412] nand: Toshiba NAND 128MiB 1,8V 8-bit
[    4.939412] nand: Toshiba NAND 128MiB 1,8V 8-bit
[    4.940155] nand: 128MiB, SLC, page size: 512, OOB size: 16
[    4.940155] nand: 128MiB, SLC, page size: 512, OOB size: 16
[    4.941084] flash size: 128 MiB
[    4.941084] flash size: 128 MiB
[    4.941578] page size: 512 bytes
[    4.941578] page size: 512 bytes
[    4.942093] OOB area size: 16 bytes
[    4.942093] OOB area size: 16 bytes
[    4.942636] sector size: 16 KiB
[    4.942636] sector size: 16 KiB
[    4.943153] pages number: 262144
[    4.943153] pages number: 262144
[    4.943678] pages per sector: 32
[    4.943678] pages per sector: 32
[    4.944191] bus width: 8
[    4.944191] bus width: 8
[    4.944589] bits in sector size: 14
[    4.944589] bits in sector size: 14
[    4.945147] bits in page size: 9
[    4.945147] bits in page size: 9
[    4.945670] bits in OOB size: 4
[    4.945670] bits in OOB size: 4
[    4.946186] flash size with OOB: 135168 KiB
[    4.946186] flash size with OOB: 135168 KiB
[    4.946866] page address bytes: 4
[    4.946866] page address bytes: 4
[    4.947401] sector address bytes: 3
[    4.947401] sector address bytes: 3
[    4.948062] options: 0x42
[    4.948062] options: 0x42
[    4.949009] Scanning device for bad blocks
[    4.949009] Scanning device for bad blocks
[    4.970580] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    4.970580] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    4.971597] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    4.971597] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    4.973161] ftl_cs: FTL header not found.
[    4.973161] ftl_cs: FTL header not found.
[    4.974578] parport0: powerup/reset Butterfly
[    4.974578] parport0: powerup/reset Butterfly
[    5.100214] parport_pc 00:04: registered master spi42
[    5.100214] parport_pc 00:04: registered master spi42
[    5.101545] spi spi42.1: spi_bitbang_setup, 66 nsec/bit
[    5.101545] spi spi42.1: spi_bitbang_setup, 66 nsec/bit
[    5.102940] spi spi42.1: setup mode 0, 8 bits/w, 15000000 Hz max --> 0
[    5.102940] spi spi42.1: setup mode 0, 8 bits/w, 15000000 Hz max --> 0
[    5.104946] parport_pc 00:04: registered child spi42.1
[    5.104946] parport_pc 00:04: registered child spi42.1
[    5.105769] parport0: dataflash at spi42.1
[    5.105769] parport0: dataflash at spi42.1
[    5.106431] parport0: AVR Butterfly
[    5.106431] parport0: AVR Butterfly
[    5.107638] HSI/SSI char device loaded
[    5.107638] HSI/SSI char device loaded
[    5.108648] usbcore: registered new interface driver hwa-rc
[    5.108648] usbcore: registered new interface driver hwa-rc
[    5.109628] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.109628] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.110686] ehci-pci: EHCI PCI platform driver
[    5.110686] ehci-pci: EHCI PCI platform driver
[    5.111533] ehci-platform: EHCI generic platform driver
[    5.111533] ehci-platform: EHCI generic platform driver
[    5.112410] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.112410] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.113413] ohci-pci: OHCI PCI platform driver
[    5.113413] ohci-pci: OHCI PCI platform driver
[    5.114176] ohci-platform: OHCI generic platform driver
[    5.114176] ohci-platform: OHCI generic platform driver
[    5.115212] usbcore: registered new interface driver hwa-hc
[    5.115212] usbcore: registered new interface driver hwa-hc
[    5.116138] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    5.116138] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    5.117108] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[    5.117108] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[    5.119328] usbcore: registered new interface driver wusb-cbaf
[    5.119328] usbcore: registered new interface driver wusb-cbaf
[    5.120341] usbcore: registered new interface driver cdc_acm
[    5.120341] usbcore: registered new interface driver cdc_acm
[    5.121290] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    5.121290] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    5.122582] usbcore: registered new interface driver usblp
[    5.122582] usbcore: registered new interface driver usblp
[    5.123493] usbcore: registered new interface driver cdc_wdm
[    5.123493] usbcore: registered new interface driver cdc_wdm
[    5.124421] usbcore: registered new interface driver usbtmc
[    5.124421] usbcore: registered new interface driver usbtmc
[    5.125335] usbcore: registered new interface driver mdc800
[    5.125335] usbcore: registered new interface driver mdc800
[    5.126234] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    5.126234] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    5.127474] usbcore: registered new interface driver microtekX6
[    5.127474] usbcore: registered new interface driver microtekX6
[    5.128563] usbcore: registered new interface driver adutux
[    5.128563] usbcore: registered new interface driver adutux
[    5.129685] usbcore: registered new interface driver appledisplay
[    5.129685] usbcore: registered new interface driver appledisplay
[    5.130712] usbcore: registered new interface driver cypress_cy7c63
[    5.130712] usbcore: registered new interface driver cypress_cy7c63
[    5.131713] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    5.131713] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    5.132897] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    5.132897] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    5.134076] usbcore: registered new interface driver ldusb
[    5.134076] usbcore: registered new interface driver ldusb
[    5.134977] usbcore: registered new interface driver legousbtower
[    5.134977] usbcore: registered new interface driver legousbtower
[    5.136003] usbcore: registered new interface driver rio500
[    5.136003] usbcore: registered new interface driver rio500
[    5.136911] usbcore: registered new interface driver usbtest
[    5.136911] usbcore: registered new interface driver usbtest
[    5.137842] usbcore: registered new interface driver usbsevseg
[    5.137842] usbcore: registered new interface driver usbsevseg
[    5.138788] usbcore: registered new interface driver sisusb
[    5.138788] usbcore: registered new interface driver sisusb
[    5.139952] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    5.139952] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    5.142038] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.142038] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.142862] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.142862] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.185151] mousedev: PS/2 mouse device common for all mice
[    5.185151] mousedev: PS/2 mouse device common for all mice
[    5.186062] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    5.186062] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    5.187555] parport0: cannot grant exclusive access for device walkera07=
01
[    5.187555] parport0: cannot grant exclusive access for device walkera07=
01
[    5.188731] walkera0701: failed to register parport device
[    5.188731] walkera0701: failed to register parport device
[    5.189643] usbcore: registered new interface driver usb_acecad
[    5.189643] usbcore: registered new interface driver usb_acecad
[    5.190650] usbcore: registered new interface driver gtco
[    5.190650] usbcore: registered new interface driver gtco
[    5.191552] usbcore: registered new interface driver hanwang
[    5.191552] usbcore: registered new interface driver hanwang
[    5.192482] usbcore: registered new interface driver kbtab
[    5.192482] usbcore: registered new interface driver kbtab
[    5.193787] mk712: device not present
[    5.193787] mk712: device not present
[    5.194440] usbcore: registered new interface driver usbtouchscreen
[    5.194440] usbcore: registered new interface driver usbtouchscreen
[    5.195524] usbcore: registered new interface driver sur40
[    5.195524] usbcore: registered new interface driver sur40
[    5.196549] I2O subsystem v1.325
[    5.196549] I2O subsystem v1.325
[    5.197072] i2o: max drivers =3D 8
[    5.197072] i2o: max drivers =3D 8
[   32.080009] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [swapp=
er/0:1]
[   32.080009] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [swapp=
er/0:1]
[   32.080009] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W      3.18.=
0-rc4-g7bf2844 #20
[   32.080009] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W      3.18.=
0-rc4-g7bf2844 #20
[   32.080009] task: ffff88001147a010 ti: ffff88001147c000 task.ti: ffff880=
01147c000
[   32.080009] task: ffff88001147a010 ti: ffff88001147c000 task.ti: ffff880=
01147c000
[   32.080009] RIP: 0010:[<ffffffff81711f93>]=20
[   32.080009] RIP: 0010:[<ffffffff81711f93>]  [<ffffffff81711f93>] kset_fi=
nd_obj+0x83/0x130
 [<ffffffff81711f93>] kset_find_obj+0x83/0x130
[   32.080009] RSP: 0000:ffff88001147fdd8  EFLAGS: 00000202
[   32.080009] RSP: 0000:ffff88001147fdd8  EFLAGS: 00000202
[   32.080009] RAX: ffff8800115f9c40 RBX: ffff88001147a778 RCX: 00000000000=
00050
[   32.080009] RAX: ffff8800115f9c40 RBX: ffff88001147a778 RCX: 00000000000=
00050
[   32.080009] RDX: 0000000000000031 RSI: ffffffff82d282f5 RDI: ffff880012d=
2d460
[   32.080009] RDX: 0000000000000031 RSI: ffffffff82d282f5 RDI: ffff880012d=
2d460
[   32.080009] RBP: ffff88001147fe08 R08: 0000000000000000 R09: 00000000000=
00001
[   32.080009] RBP: ffff88001147fe08 R08: 0000000000000000 R09: 00000000000=
00001
[   32.080009] R10: ffff88001147a778 R11: 000000000014a621 R12: 00000000000=
00206
[   32.080009] R10: ffff88001147a778 R11: 000000000014a621 R12: 00000000000=
00206
[   32.080009] R13: ffff88001147fdc8 R14: ffff88001147a010 R15: ffff8800115=
08c68
[   32.080009] R13: ffff88001147fdc8 R14: ffff88001147a010 R15: ffff8800115=
08c68
[   32.080009] FS:  0000000000000000(0000) GS:ffff880012400000(0000) knlGS:=
0000000000000000
[   32.080009] FS:  0000000000000000(0000) GS:ffff880012400000(0000) knlGS:=
0000000000000000
[   32.080009] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   32.080009] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   32.080009] CR2: 00000000ffffffff CR3: 000000000300c000 CR4: 00000000000=
006b0
[   32.080009] CR2: 00000000ffffffff CR3: 000000000300c000 CR4: 00000000000=
006b0
[   32.080009] Stack:
[   32.080009] Stack:
[   32.080009]  0000000000000000
[   32.080009]  0000000000000000 ffffffff835b2768 ffffffff835b2768 ffff8800=
0b828b20 ffff88000b828b20 0000000000000000 0000000000000000

[   32.080009]  ffffffff8393b971
[   32.080009]  ffffffff8393b971 0000000000000000 0000000000000000 ffff8800=
1147fe28 ffff88001147fe28 ffffffff81e482aa ffffffff81e482aa

[   32.080009]  ffff88001147fe48
[   32.080009]  ffff88001147fe48 ffffffff835b2768 ffffffff835b2768 ffff8800=
1147fe48 ffff88001147fe48 ffffffff81e4837e ffffffff81e4837e

[   32.080009] Call Trace:
[   32.080009] Call Trace:
[   32.080009]  [<ffffffff8393b971>] ? tps6507x_ts_driver_init+0x22/0x22
[   32.080009]  [<ffffffff8393b971>] ? tps6507x_ts_driver_init+0x22/0x22
[   32.080009]  [<ffffffff81e482aa>] driver_find+0x2a/0x70
[   32.080009]  [<ffffffff81e482aa>] driver_find+0x2a/0x70
[   32.080009]  [<ffffffff81e4837e>] driver_register+0x8e/0x190
[   32.080009]  [<ffffffff81e4837e>] driver_register+0x8e/0x190
[   32.080009]  [<ffffffff8178988f>] __pci_register_driver+0x6f/0x80
[   32.080009]  [<ffffffff8178988f>] __pci_register_driver+0x6f/0x80
[   32.080009]  [<ffffffff8393bb37>] i2o_pci_init+0x20/0x29
[   32.080009]  [<ffffffff8393bb37>] i2o_pci_init+0x20/0x29
[   32.080009]  [<ffffffff8393b9ca>] i2o_iop_init+0x59/0x8d
[   32.080009]  [<ffffffff8393b9ca>] i2o_iop_init+0x59/0x8d
[   32.080009]  [<ffffffff838d88d6>] do_one_initcall+0x176/0x247
[   32.080009]  [<ffffffff838d88d6>] do_one_initcall+0x176/0x247
[   32.080009]  [<ffffffff838d8b79>] kernel_init_freeable+0x1d2/0x2d4
[   32.080009]  [<ffffffff838d8b79>] kernel_init_freeable+0x1d2/0x2d4
[   32.080009]  [<ffffffff824c2750>] ? rest_init+0x130/0x130
[   32.080009]  [<ffffffff824c2750>] ? rest_init+0x130/0x130
[   32.080009]  [<ffffffff824c2761>] kernel_init+0x11/0x1a0
[   32.080009]  [<ffffffff824c2761>] kernel_init+0x11/0x1a0
[   32.080009]  [<ffffffff824e7f3c>] ret_from_fork+0x7c/0xb0
[   32.080009]  [<ffffffff824e7f3c>] ret_from_fork+0x7c/0xb0
[   32.080009]  [<ffffffff824c2750>] ? rest_init+0x130/0x130
[   32.080009]  [<ffffffff824c2750>] ? rest_init+0x130/0x130
[   32.080009] Code:=20
[   32.080009] Code: 08 08 03 03 48 48 85 85 ff ff 74 74 14 14 4c 4c 89 89 =
f6 f6 48 48 83 83 05 05 d6 d6 b6 b6 08 08 03 03 01 01 e8 e8 21 21 95 95 00 =
00 00 00 85 85 c0 c0 74 74 3d 3d 48 48 8b 8b 43 43 08 08 49 49 83 83 c4 c4 =
01 01 48 48 83 83 05 05 cd cd b6 b6 08 08 03 03 01 01 <49> <49> 39 39 c5 c5=
 48 48 8d 8d 58 58 f8 f8 75 75 c4 c4 31 31 db db 4c 4c 89 89 ff ff e8 e8 1a=
 1a 44 44 dd dd 00 00 48 48 83 83=20

[   32.080009] Kernel panic - not syncing: softlockup: hung tasks
[   32.080009] Kernel panic - not syncing: softlockup: hung tasks
[   32.080009] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    L 3.18.=
0-rc4-g7bf2844 #20
[   32.080009] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    L 3.18.=
0-rc4-g7bf2844 #20
[   32.080009]  0000000000000007
[   32.080009]  0000000000000007 ffff880012403df8 ffff880012403df8 ffffffff=
824ce992 ffffffff824ce992 ffffffff81151538 ffffffff81151538

[   32.080009]  ffffffff82c82e33
[   32.080009]  ffffffff82c82e33 ffff880012403e78 ffff880012403e78 ffffffff=
824c71ee ffffffff824c71ee ffffffff81151538 ffffffff81151538

[   32.080009]  0000000000000008
[   32.080009]  0000000000000008 ffff880012403e88 ffff880012403e88 ffff8800=
12403e28 ffff880012403e28 ffff880012403e78 ffff880012403e78

[   32.080009] Call Trace:
[   32.080009] Call Trace:
[   32.080009]  <IRQ>=20
[   32.080009]  <IRQ>  [<ffffffff824ce992>] dump_stack+0x86/0xbc
 [<ffffffff824ce992>] dump_stack+0x86/0xbc
[   32.080009]  [<ffffffff81151538>] ? console_unlock+0x3b8/0x7a0
[   32.080009]  [<ffffffff81151538>] ? console_unlock+0x3b8/0x7a0
[   32.080009]  [<ffffffff824c71ee>] panic+0x12c/0x316
[   32.080009]  [<ffffffff824c71ee>] panic+0x12c/0x316
[   32.080009]  [<ffffffff81151538>] ? console_unlock+0x3b8/0x7a0
[   32.080009]  [<ffffffff81151538>] ? console_unlock+0x3b8/0x7a0
[   32.080009]  [<ffffffff81151538>] ? console_unlock+0x3b8/0x7a0
[   32.080009]  [<ffffffff81151538>] ? console_unlock+0x3b8/0x7a0
[   32.080009]  [<ffffffff811a874c>] watchdog_timer_fn+0x2ec/0x340
[   32.080009]  [<ffffffff811a874c>] watchdog_timer_fn+0x2ec/0x340
[   32.080009]  [<ffffffff811a8460>] ? watchdog+0x40/0x40
[   32.080009]  [<ffffffff811a8460>] ? watchdog+0x40/0x40
[   32.080009]  [<ffffffff811a8460>] ? watchdog+0x40/0x40
[   32.080009]  [<ffffffff811a8460>] ? watchdog+0x40/0x40
[   32.080009]  [<ffffffff8116d4c8>] __run_hrtimer+0x88/0x1a0
[   32.080009]  [<ffffffff8116d4c8>] __run_hrtimer+0x88/0x1a0
[   32.080009]  [<ffffffff8116e33f>] hrtimer_interrupt+0x12f/0x320
[   32.080009]  [<ffffffff8116e33f>] hrtimer_interrupt+0x12f/0x320
[   32.080009]  [<ffffffff8111d19f>] ? vtime_common_account_irq_enter+0x3f/=
0x90
[   32.080009]  [<ffffffff8111d19f>] ? vtime_common_account_irq_enter+0x3f/=
0x90
[   32.080009]  [<ffffffff81043dc1>] local_apic_timer_interrupt+0x41/0x90
[   32.080009]  [<ffffffff81043dc1>] local_apic_timer_interrupt+0x41/0x90
[   32.080009]  [<ffffffff8104486e>] smp_apic_timer_interrupt+0x6e/0xa0
[   32.080009]  [<ffffffff8104486e>] smp_apic_timer_interrupt+0x6e/0xa0
[   32.080009]  [<ffffffff824e8dca>] apic_timer_interrupt+0x6a/0x70
[   32.080009]  [<ffffffff824e8dca>] apic_timer_interrupt+0x6a/0x70
[   32.080009]  <EOI>=20
[   32.080009]  <EOI>  [<ffffffff81711f93>] ? kset_find_obj+0x83/0x130
 [<ffffffff81711f93>] ? kset_find_obj+0x83/0x130
[   32.080009]  [<ffffffff81711f7f>] ? kset_find_obj+0x6f/0x130
[   32.080009]  [<ffffffff81711f7f>] ? kset_find_obj+0x6f/0x130
[   32.080009]  [<ffffffff8393b971>] ? tps6507x_ts_driver_init+0x22/0x22
[   32.080009]  [<ffffffff8393b971>] ? tps6507x_ts_driver_init+0x22/0x22
[   32.080009]  [<ffffffff81e482aa>] driver_find+0x2a/0x70
[   32.080009]  [<ffffffff81e482aa>] driver_find+0x2a/0x70
[   32.080009]  [<ffffffff81e4837e>] driver_register+0x8e/0x190
[   32.080009]  [<ffffffff81e4837e>] driver_register+0x8e/0x190
[   32.080009]  [<ffffffff8178988f>] __pci_register_driver+0x6f/0x80
[   32.080009]  [<ffffffff8178988f>] __pci_register_driver+0x6f/0x80
[   32.080009]  [<ffffffff8393bb37>] i2o_pci_init+0x20/0x29
[   32.080009]  [<ffffffff8393bb37>] i2o_pci_init+0x20/0x29
[   32.080009]  [<ffffffff8393b9ca>] i2o_iop_init+0x59/0x8d
[   32.080009]  [<ffffffff8393b9ca>] i2o_iop_init+0x59/0x8d
[   32.080009]  [<ffffffff838d88d6>] do_one_initcall+0x176/0x247
[   32.080009]  [<ffffffff838d88d6>] do_one_initcall+0x176/0x247
[   32.080009]  [<ffffffff838d8b79>] kernel_init_freeable+0x1d2/0x2d4
[   32.080009]  [<ffffffff838d8b79>] kernel_init_freeable+0x1d2/0x2d4
[   32.080009]  [<ffffffff824c2750>] ? rest_init+0x130/0x130
[   32.080009]  [<ffffffff824c2750>] ? rest_init+0x130/0x130
[   32.080009]  [<ffffffff824c2761>] kernel_init+0x11/0x1a0
[   32.080009]  [<ffffffff824c2761>] kernel_init+0x11/0x1a0
[   32.080009]  [<ffffffff824e7f3c>] ret_from_fork+0x7c/0xb0
[   32.080009]  [<ffffffff824e7f3c>] ret_from_fork+0x7c/0xb0
[   32.080009]  [<ffffffff824c2750>] ? rest_init+0x130/0x130
[   32.080009]  [<ffffffff824c2750>] ? rest_init+0x130/0x130
[   32.080009] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range=
: 0xffffffff80000000-0xffffffff9fffffff)
[   32.080009] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range=
: 0xffffffff80000000-0xffffffff9fffffff)

Elapsed time: 40
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-n0-12152252/7bf2844ed14de049a4ccec26eb3d8b4c3d5c1971/vmlinuz-3.18.0-rc4-g7=
bf2844 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D=
-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 =
prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=
=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-n0-121=
52252/drm-intel:topic:core-stuff:7bf2844ed14de049a4ccec26eb3d8b4c3d5c1971:b=
isect-linux-0/.vmlinuz-7bf2844ed14de049a4ccec26eb3d8b4c3d5c1971-20141218055=
117-9-client6 branch=3Ddrm-intel/topic/core-stuff BOOT_IMAGE=3D/kernel/x86_=
64-randconfig-n0-12152252/7bf2844ed14de049a4ccec26eb3d8b4c3d5c1971/vmlinuz-=
3.18.0-rc4-g7bf2844 drbd.minor_count=3D8'  -initrd /kernel-tests/initrd/qua=
ntal-core-x86_64.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=3De1000 -net use=
r,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocal=
time -pidfile /dev/shm/kboot/pid-quantal-client6-7 -serial file:/dev/shm/kb=
oot/serial-quantal-client6-7 -daemonize -display none -monitor null=20

--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-client6-10:20141218071302:x86_64-randconfig-n0-12152252:3.18.0-rc4-g7552e7d:30"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc4-g7552e7d (kbuild@lkp-nhm1) (gcc ver=
sion 4.9.1 (Debian 4.9.1-19) ) #30 SMP Thu Dec 18 06:58:08 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-n0-12152252/drm-intel:topic:core-stuff:7552e7dd9527c41f891c87854418896=
eaf309c20:bisect-linux-0/.vmlinuz-7552e7dd9527c41f891c87854418896eaf309c20-=
20141218070725-57-client6 branch=3Ddrm-intel/topic/core-stuff BOOT_IMAGE=3D=
/kernel/x86_64-randconfig-n0-12152252/7552e7dd9527c41f891c87854418896eaf309=
c20/vmlinuz-3.18.0-rc4-g7552e7d drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   Centaur CentaurHauls
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x400000000
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
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[ffff8800000f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x04e25000, 0x04e25fff] PGTABLE
[    0.000000] BRK [0x04e26000, 0x04e26fff] PGTABLE
[    0.000000] BRK [0x04e27000, 0x04e27fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13fdffff]
[    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13fdffff] page 4k
[    0.000000] BRK [0x04e28000, 0x04e28fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x12925000-0x13fd7fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0C90 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FE18BD 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FE0B37 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FE0000 000040
[    0.000000] ACPI: SSDT 0x0000000013FE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FE1805 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FE1885 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13fdf001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1064 pages used for memmap
[    0.000000]   DMA32 zone: 77792 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff880012400000 s1917568 r0=
 d32128 u2097152
[    0.000000] pcpu-alloc: s1917568 r0 d32128 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1240db40
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80649
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-n0-12152252/drm-intel:topic:core-stuff:7552e7dd9527c41f891c8785=
4418896eaf309c20:bisect-linux-0/.vmlinuz-7552e7dd9527c41f891c87854418896eaf=
309c20-20141218070725-57-client6 branch=3Ddrm-intel/topic/core-stuff BOOT_I=
MAGE=3D/kernel/x86_64-randconfig-n0-12152252/7552e7dd9527c41f891c8785441889=
6eaf309c20/vmlinuz-3.18.0-rc4-g7552e7d drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 230136K/327160K available (21426K kernel code, 7169K=
 rwdata, 8372K rodata, 2932K init, 20728K bss, 97024K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:440 0
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc4-g7552e7d (kbuild@lkp-nhm1) (gcc ver=
sion 4.9.1 (Debian 4.9.1-19) ) #30 SMP Thu Dec 18 06:58:08 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-n0-12152252/drm-intel:topic:core-stuff:7552e7dd9527c41f891c87854418896=
eaf309c20:bisect-linux-0/.vmlinuz-7552e7dd9527c41f891c87854418896eaf309c20-=
20141218070725-57-client6 branch=3Ddrm-intel/topic/core-stuff BOOT_IMAGE=3D=
/kernel/x86_64-randconfig-n0-12152252/7552e7dd9527c41f891c87854418896eaf309=
c20/vmlinuz-3.18.0-rc4-g7552e7d drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   Centaur CentaurHauls
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x400000000
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
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[ffff8800000f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x04e25000, 0x04e25fff] PGTABLE
[    0.000000] BRK [0x04e26000, 0x04e26fff] PGTABLE
[    0.000000] BRK [0x04e27000, 0x04e27fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13fdffff]
[    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13fdffff] page 4k
[    0.000000] BRK [0x04e28000, 0x04e28fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x12925000-0x13fd7fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0C90 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FE18BD 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FE0B37 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FE0000 000040
[    0.000000] ACPI: SSDT 0x0000000013FE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FE1805 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FE1885 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13fdf001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1064 pages used for memmap
[    0.000000]   DMA32 zone: 77792 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff880012400000 s1917568 r0=
 d32128 u2097152
[    0.000000] pcpu-alloc: s1917568 r0 d32128 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1240db40
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80649
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-n0-12152252/drm-intel:topic:core-stuff:7552e7dd9527c41f891c8785=
4418896eaf309c20:bisect-linux-0/.vmlinuz-7552e7dd9527c41f891c87854418896eaf=
309c20-20141218070725-57-client6 branch=3Ddrm-intel/topic/core-stuff BOOT_I=
MAGE=3D/kernel/x86_64-randconfig-n0-12152252/7552e7dd9527c41f891c8785441889=
6eaf309c20/vmlinuz-3.18.0-rc4-g7552e7d drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 230136K/327160K available (21426K kernel code, 7169K=
 rwdata, 8372K rodata, 2932K init, 20728K bss, 97024K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:440 0
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8639 kB
[    0.000000]  memory used by lock dependency info: 8639 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ODEBUG: selftest passed
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2925.998 MHz processor
[    0.000000] tsc: Detected 2925.998 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.020000] Calibrating delay loop (skipped) preset value..=20
[    0.020000] Calibrating delay loop (skipped) preset value.. 5851.99 Bogo=
MIPS (lpj=3D29259980)
5851.99 BogoMIPS (lpj=3D29259980)
[    0.020000] pid_max: default: 4096 minimum: 301
[    0.020000] pid_max: default: 4096 minimum: 301
[    0.020000] ACPI: Core revision 20140926
[    0.020000] ACPI: Core revision 20140926
[    0.020000] ACPI:=20
[    0.020000] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.020209] Security Framework initialized
[    0.020209] Security Framework initialized
[    0.020953] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.020953] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.022097] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.022097] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.023644] Initializing cgroup subsys devices
[    0.023644] Initializing cgroup subsys devices
[    0.024429] Initializing cgroup subsys freezer
[    0.024429] Initializing cgroup subsys freezer
[    0.025236] Initializing cgroup subsys perf_event
[    0.025236] Initializing cgroup subsys perf_event
[    0.026050] Initializing cgroup subsys hugetlb
[    0.026050] Initializing cgroup subsys hugetlb
[    0.026817] Initializing cgroup subsys debug
[    0.026817] Initializing cgroup subsys debug
[    0.027600] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.027600] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.027600] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.027600] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.030139] Freeing SMP alternatives memory: 28K (ffffffff839df000 - fff=
fffff839e6000)
[    0.030139] Freeing SMP alternatives memory: 28K (ffffffff839df000 - fff=
fffff839e6000)
[    0.033984] Getting VERSION: 1050014
[    0.033984] Getting VERSION: 1050014
[    0.034614] Getting VERSION: 1050014
[    0.034614] Getting VERSION: 1050014
[    0.035237] Getting ID: 0
[    0.035237] Getting ID: 0
[    0.035711] Getting ID: ff000000
[    0.035711] Getting ID: ff000000
[    0.036278] Getting LVT0: 8700
[    0.036278] Getting LVT0: 8700
[    0.036828] Getting LVT1: 8400
[    0.036828] Getting LVT1: 8400
[    0.037399] enabled ExtINT on CPU#0
[    0.037399] enabled ExtINT on CPU#0
[    0.038696] ENABLING IO-APIC IRQs
[    0.038696] ENABLING IO-APIC IRQs
[    0.039288] init IO_APIC IRQs
[    0.039288] init IO_APIC IRQs
[    0.039806]  apic 0 pin 0 not connected
[    0.039806]  apic 0 pin 0 not connected
[    0.040033] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.040033] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.041412] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.041412] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.042790] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.042790] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.044188] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.044188] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.045593] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.045593] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.046989] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.046989] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.048386] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.048386] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.050033] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.050033] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.051443] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.051443] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.052849] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.052849] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.054256] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.054256] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.055659] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.055659] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.057080] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.057080] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.058523] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.058523] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.060032] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.060032] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.061456] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.061456] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.062862]  apic 0 pin 16 not connected
[    0.062862]  apic 0 pin 16 not connected
[    0.063536]  apic 0 pin 17 not connected
[    0.063536]  apic 0 pin 17 not connected
[    0.064220]  apic 0 pin 18 not connected
[    0.064220]  apic 0 pin 18 not connected
[    0.064888]  apic 0 pin 19 not connected
[    0.064888]  apic 0 pin 19 not connected
[    0.065561]  apic 0 pin 20 not connected
[    0.065561]  apic 0 pin 20 not connected
[    0.066238]  apic 0 pin 21 not connected
[    0.066238]  apic 0 pin 21 not connected
[    0.066916]  apic 0 pin 22 not connected
[    0.066916]  apic 0 pin 22 not connected
[    0.067609]  apic 0 pin 23 not connected
[    0.067609]  apic 0 pin 23 not connected
[    0.068438] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.068438] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.070017] smpboot: CPU0:=20
[    0.070017] smpboot: CPU0: GenuineIntel GenuineIntel Common KVM processo=
rCommon KVM processor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.072939] Using local APIC timer interrupts.
[    0.072939] calibrating APIC timer ...
[    0.072939] Using local APIC timer interrupts.
[    0.072939] calibrating APIC timer ...
[    0.080000] ... lapic delta =3D 6254451
[    0.080000] ... lapic delta =3D 6254451
[    0.080000] ... PM-Timer delta =3D 358206
[    0.080000] ... PM-Timer delta =3D 358206
[    0.080000] ... PM-Timer result ok
[    0.080000] ... PM-Timer result ok
[    0.080000] ..... delta 6254451
[    0.080000] ..... delta 6254451
[    0.080000] ..... mult: 268626624
[    0.080000] ..... mult: 268626624
[    0.080000] ..... calibration result: 10007121
[    0.080000] ..... calibration result: 10007121
[    0.080000] ..... CPU clock speed is 2927.9672 MHz.
[    0.080000] ..... CPU clock speed is 2927.9672 MHz.
[    0.080000] ..... host bus clock speed is 1000.7121 MHz.
[    0.080000] ..... host bus clock speed is 1000.7121 MHz.
[    0.080000] Performance Events:=20
[    0.080000] Performance Events: no PMU driver, software events only.
no PMU driver, software events only.
[    0.080000] x86: Booting SMP configuration:
[    0.080000] x86: Booting SMP configuration:
[    0.080000] .... node  #0, CPUs: =20
[    0.080000] .... node  #0, CPUs:         #1 #1
[    0.080000] kvm-clock: cpu 1, msr 0:13fdf041, secondary cpu clock
[    0.085357] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.080000] masked ExtINT on CPU#1
[    0.087736] x86: Booted up 1 node, 2 CPUs
[    0.087736] x86: Booted up 1 node, 2 CPUs
[    0.087709] KVM setup async PF for cpu 1
[    0.087709] KVM setup async PF for cpu 1
[    0.087709] kvm-stealtime: cpu 1, msr 1260db40
[    0.087709] kvm-stealtime: cpu 1, msr 1260db40
[    0.089864] ----------------
[    0.089864] ----------------
[    0.090006] | NMI testsuite:
[    0.090006] | NMI testsuite:
[    0.090485] --------------------
[    0.090485] --------------------
[    0.091031]   remote IPI:
[    0.091031]   remote IPI:  ok  |  ok  |

[    0.100222]    local IPI:
[    0.100222]    local IPI:  ok  |  ok  |

[    0.120031] --------------------
[    0.120031] --------------------
[    0.120593] Good, all   2 testcases passed! |
[    0.120593] Good, all   2 testcases passed! |
[    0.121339] ---------------------------------
[    0.121339] ---------------------------------
[    0.122107] smpboot: Total of 2 processors activated (11703.99 BogoMIPS)
[    0.122107] smpboot: Total of 2 processors activated (11703.99 BogoMIPS)
[    0.123835] devtmpfs: initialized
[    0.123835] devtmpfs: initialized
[    0.123835] gcov: version magic: 0x3430392a
[    0.123835] gcov: version magic: 0x3430392a
[    0.124029] xor: measuring software checksum speed
[    0.124029] xor: measuring software checksum speed
[    0.220015]    prefetch64-sse: 11554.400 MB/sec
[    0.220015]    prefetch64-sse: 11554.400 MB/sec
[    0.320015]    generic_sse: 10462.400 MB/sec
[    0.320015]    generic_sse: 10462.400 MB/sec
[    0.320750] xor: using function: prefetch64-sse (11554.400 MB/sec)
[    0.320750] xor: using function: prefetch64-sse (11554.400 MB/sec)
[    0.321784] prandom: seed boundary self test passed
[    0.321784] prandom: seed boundary self test passed
[    0.323147] prandom: 100 self tests passed
[    0.323147] prandom: 100 self tests passed
[    0.324182] regulator-dummy: no parameters
[    0.324182] regulator-dummy: no parameters
[    0.325158] NET: Registered protocol family 16
[    0.325158] NET: Registered protocol family 16
[    0.330041] cpuidle: using governor ladder
[    0.330041] cpuidle: using governor ladder
[    0.340045] cpuidle: using governor menu
[    0.340045] cpuidle: using governor menu
[    0.341212] ACPI: bus type PCI registered
[    0.341212] ACPI: bus type PCI registered
[    0.342006] dca service started, version 1.12.1
[    0.342006] dca service started, version 1.12.1
[    0.342815] PCI: Using configuration type 1 for base access
[    0.342815] PCI: Using configuration type 1 for base access
[    0.520029] raid6: sse2x1    2476 MB/s
[    0.520029] raid6: sse2x1    2476 MB/s
[    0.690012] raid6: sse2x2    2700 MB/s
[    0.690012] raid6: sse2x2    2700 MB/s
[    0.860019] raid6: sse2x4    2582 MB/s
[    0.860019] raid6: sse2x4    2582 MB/s
[    0.860673] raid6: using algorithm sse2x2 (2700 MB/s)
[    0.860673] raid6: using algorithm sse2x2 (2700 MB/s)
[    0.861505] raid6: using intx1 recovery algorithm
[    0.861505] raid6: using intx1 recovery algorithm
[    0.862406] gpio-f7188x: Not a Fintek device at 0x0000002e
[    0.862406] gpio-f7188x: Not a Fintek device at 0x0000002e
[    0.863358] gpio-f7188x: Not a Fintek device at 0x0000004e
[    0.863358] gpio-f7188x: Not a Fintek device at 0x0000004e
[    0.864517] ACPI: Added _OSI(Module Device)
[    0.864517] ACPI: Added _OSI(Module Device)
[    0.865223] ACPI: Added _OSI(Processor Device)
[    0.865223] ACPI: Added _OSI(Processor Device)
[    0.865964] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.865964] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.866749] ACPI: Added _OSI(Processor Aggregator Device)
[    0.866749] ACPI: Added _OSI(Processor Aggregator Device)
[    0.869771] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:3)
[    0.869771] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:3)
[    0.873607] ACPI: Interpreter enabled
[    0.873607] ACPI: Interpreter enabled
[    0.874257] ACPI: (supports S0 S4 S5)
[    0.874257] ACPI: (supports S0 S4 S5)
[    0.874875] ACPI: Using IOAPIC for interrupt routing
[    0.874875] ACPI: Using IOAPIC for interrupt routing
[    0.875740] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.875740] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.887542] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.887542] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.888572] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.888572] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.889471] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.889471] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.890311] PCI host bridge to bus 0000:00
[    0.890311] PCI host bridge to bus 0000:00
[    0.891003] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.891003] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.891900] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.891900] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.892922] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.892922] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.893941] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.893941] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.894963] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.894963] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.895974] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.895974] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.896987] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.896987] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.898108] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.898108] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.899272] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.899272] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.900512] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.900512] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.902107] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.902107] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.905516] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.905516] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.907265] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.907265] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.908407] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.908407] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.910005] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.910005] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.911141] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.911141] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.912488] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.912488] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.913766] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.913766] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.914927] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.914927] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.916433] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.916433] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.918348] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.918348] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.920461] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.920461] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.925902] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.925902] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.927320] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.927320] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.929083] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.929083] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.930752] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.930752] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.935411] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.935411] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.936810] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.936810] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.938182] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.938182] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.942230] pci_bus 0000:00: on NUMA node 0
[    0.942230] pci_bus 0000:00: on NUMA node 0
[    0.943691] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.943691] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.944850] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.944850] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.945994] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.945994] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.947144] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.947144] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.948204] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.948204] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.949757] ACPI:=20
[    0.949757] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    0.950764] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.950764] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.951126] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.951126] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.952453] vgaarb: loaded
[    0.952453] vgaarb: loaded
[    0.952905] vgaarb: bridge control possible 0000:00:02.0
[    0.952905] vgaarb: bridge control possible 0000:00:02.0
[    0.954701] SCSI subsystem initialized
[    0.954701] SCSI subsystem initialized
[    0.954701] ACPI: bus type USB registered
[    0.954701] ACPI: bus type USB registered
[    0.954701] usbcore: registered new interface driver usbfs
[    0.954701] usbcore: registered new interface driver usbfs
[    0.954701] usbcore: registered new interface driver hub
[    0.954701] usbcore: registered new interface driver hub
[    0.954701] usbcore: registered new device driver usb
[    0.954701] usbcore: registered new device driver usb
[    0.954701] Linux video capture interface: v2.00
[    0.954701] Linux video capture interface: v2.00
[    0.954701] wmi: Mapper loaded
[    0.954701] wmi: Mapper loaded
[    0.961700] PCI: Using ACPI for IRQ routing
[    0.961700] PCI: Using ACPI for IRQ routing
[    0.961700] PCI: pci_cache_line_size set to 64 bytes
[    0.961700] PCI: pci_cache_line_size set to 64 bytes
[    0.961847] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.961847] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.962847] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    0.962847] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    0.964671] Switched to clocksource kvm-clock
[    0.964671] Switched to clocksource kvm-clock
[    0.965531] pnp: PnP ACPI init
[    0.965531] pnp: PnP ACPI init
[    0.966051] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.966051] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.966051] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.966051] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.966051] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.966051] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.966051] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.966051] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.966623] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.966623] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.967998] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.967998] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.969137] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.969137] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.970467] pnp 00:03: [dma 2]
[    0.970467] pnp 00:03: [dma 2]
[    0.971019] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.971019] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.972175] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.972175] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.973570] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.973570] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.974731] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.974731] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.976091] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.976091] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.977738] pnp: PnP ACPI: found 6 devices
[    0.977738] pnp: PnP ACPI: found 6 devices
[    0.983974] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.983974] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.984896] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    0.984896] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    0.985822] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    0.985822] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    0.986747] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    0.986747] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    0.987674] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    0.987674] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    0.988603] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    0.988603] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    0.989654] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    0.989654] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    0.990815] NET: Registered protocol family 1
[    0.990815] NET: Registered protocol family 1
[    0.991552] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.991552] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.992580] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.992580] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.993812] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.993812] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.994840] pci 0000:00:02.0: Video device with shadowed ROM
[    0.994840] pci 0000:00:02.0: Video device with shadowed ROM
[    0.995793] PCI: CLS 0 bytes, default 64
[    0.995793] PCI: CLS 0 bytes, default 64
[    0.996607] Unpacking initramfs...
[    0.996607] Unpacking initramfs...
[    1.524565] Freeing initrd memory: 23244K (ffff880012925000 - ffff880013=
fd8000)
[    1.524565] Freeing initrd memory: 23244K (ffff880012925000 - ffff880013=
fd8000)
[    1.538528] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usab=
le.
[    1.538528] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usab=
le.
[    1.539710] PCLMULQDQ-NI instructions are not detected.
[    1.539710] PCLMULQDQ-NI instructions are not detected.
[    1.540597] AVX or AES-NI instructions are not detected.
[    1.540597] AVX or AES-NI instructions are not detected.
[    1.541478] AVX instructions are not detected.
[    1.541478] AVX instructions are not detected.
[    1.542215] AVX instructions are not detected.
[    1.542215] AVX instructions are not detected.
[    1.542945] AVX instructions are not detected.
[    1.542945] AVX instructions are not detected.
[    1.543681] AVX2 or AES-NI instructions are not detected.
[    1.543681] AVX2 or AES-NI instructions are not detected.
[    1.545136] futex hash table entries: 16 (order: -1, 2048 bytes)
[    1.545136] futex hash table entries: 16 (order: -1, 2048 bytes)
[    2.035914] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.035914] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.037237] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    2.037237] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    2.038816] ntfs: driver 2.1.31 [Flags: R/W DEBUG].
[    2.038816] ntfs: driver 2.1.31 [Flags: R/W DEBUG].
[    2.039760] efs: 1.0a - http://aeschi.ch.eu.org/efs/
[    2.039760] efs: 1.0a - http://aeschi.ch.eu.org/efs/
[    2.042185] qnx6: QNX6 filesystem 1.0.0 registered.
[    2.042185] qnx6: QNX6 filesystem 1.0.0 registered.
[    2.043161] fuse init (API version 7.23)
[    2.043161] fuse init (API version 7.23)
[    2.044194] JFS: nTxBlock =3D 1979, nTxLock =3D 15838
[    2.044194] JFS: nTxBlock =3D 1979, nTxLock =3D 15838
[    2.046043] SGI XFS with ACLs, security attributes, realtime, no debug e=
nabled
[    2.046043] SGI XFS with ACLs, security attributes, realtime, no debug e=
nabled
[    2.049541] gfs2: GFS2 installed
[    2.049541] gfs2: GFS2 installed
[    2.050280] msgmni has been set to 494
[    2.050280] msgmni has been set to 494
[    2.050918] Key type big_key registered
[    2.050918] Key type big_key registered
[    2.058285] Key type asymmetric registered
[    2.058285] Key type asymmetric registered
[    2.058974] Asymmetric key parser 'x509' registered
[    2.058974] Asymmetric key parser 'x509' registered
[    2.059828] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 252)
[    2.059828] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 252)
[    2.061080] io scheduler noop registered
[    2.061080] io scheduler noop registered
[    2.061737] io scheduler cfq registered (default)
[    2.061737] io scheduler cfq registered (default)
[    2.062514] start plist test
[    2.062514] start plist test
[    2.065111] end plist test
[    2.065111] end plist test
[    2.065566] test_string_helpers: Running tests...
[    2.065566] test_string_helpers: Running tests...
[    2.066665] test_firmware: interface ready
[    2.066665] test_firmware: interface ready
[    2.067436] xz_dec_test: module loaded
[    2.067436] xz_dec_test: module loaded
[    2.068064] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
251 0' and write .xz files to it.
[    2.068064] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
251 0' and write .xz files to it.
[    2.069801] rbtree testing
[    2.069801] rbtree testing -> 29640 cycles
 -> 29640 cycles
[    3.141852] augmented rbtree testing
[    3.141852] augmented rbtree testing -> 48009 cycles
 -> 48009 cycles
[    4.876155] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    4.876155] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    4.877071] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    4.877071] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    4.878433] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    4.878433] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    4.879799] vmlfb: initializing
[    4.879799] vmlfb: initializing
[    4.880586] Could not find Carillo Ranch MCH device.
[    4.880586] Could not find Carillo Ranch MCH device.
[    4.881441] no IO addresses supplied
[    4.881441] no IO addresses supplied
[    4.882169] hgafb: HGA card not detected.
[    4.882169] hgafb: HGA card not detected.
[    4.882833] hgafb: probe of hgafb.0 failed with error -22
[    4.882833] hgafb: probe of hgafb.0 failed with error -22
[    4.883829] usbcore: registered new interface driver udlfb
[    4.883829] usbcore: registered new interface driver udlfb
[    4.884769] usbcore: registered new interface driver smscufx
[    4.884769] usbcore: registered new interface driver smscufx
[    4.885799] ipmi message handler version 39.2
[    4.885799] ipmi message handler version 39.2
[    4.886533] ipmi device interface
[    4.886533] ipmi device interface
[    4.887150] IPMI System Interface driver.
[    4.887150] IPMI System Interface driver.
[    4.887879] ipmi_si: Adding default-specified kcs state machine
[    4.887879] ipmi_si: Adding default-specified kcs state machine

[    4.888876] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    4.888876] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    4.890553] ipmi_si: Interface detection failed
[    4.890553] ipmi_si: Interface detection failed
[    4.910262] ipmi_si: Adding default-specified smic state machine
[    4.910262] ipmi_si: Adding default-specified smic state machine

[    4.911810] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    4.911810] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    4.914335] ipmi_si: Interface detection failed
[    4.914335] ipmi_si: Interface detection failed
[    4.920167] ipmi_si: Adding default-specified bt state machine
[    4.920167] ipmi_si: Adding default-specified bt state machine

[    4.921661] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    4.921661] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    4.924207] ipmi_si: Interface detection failed
[    4.924207] ipmi_si: Interface detection failed
[    4.930323] ipmi_si: Unable to find any System Interface(s)
[    4.930323] ipmi_si: Unable to find any System Interface(s)
[    4.932145] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    4.932145] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    4.933789] ACPI: Power Button [PWRF]
[    4.933789] ACPI: Power Button [PWRF]
[    4.934974] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    4.934974] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    4.936183] xenfs: not registering filesystem on non-xen platform
[    4.936183] xenfs: not registering filesystem on non-xen platform
[    4.937449] r3964: Philips r3964 Driver $Revision: 1.10 $
[    4.937449] r3964: Philips r3964 Driver $Revision: 1.10 $
[    4.938338] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    4.938338] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    4.964827] serial 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 1=
15200) is a 16550A
[    4.964827] serial 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 1=
15200) is a 16550A
[    4.967470] serial: Freescale lpuart driver
[    4.967470] serial: Freescale lpuart driver
[    4.968231] Initializing Nozomi driver 2.1d
[    4.968231] Initializing Nozomi driver 2.1d
[    4.970137] lp: driver loaded but no devices found
[    4.970137] lp: driver loaded but no devices found
[    4.970937] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    4.970937] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    4.972121] ac.o: No PCI boards found.
[    4.972121] ac.o: No PCI boards found.
[    4.972735] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    4.972735] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    4.974122] ppdev: user-space parallel port driver
[    4.974122] ppdev: user-space parallel port driver
[    4.974926] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    4.974926] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    4.975788] smapi::smapi_init, ERROR invalid usSmapiID
[    4.975788] smapi::smapi_init, ERROR invalid usSmapiID
[    4.976633] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    4.976633] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    4.978166] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    4.978166] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    4.979356] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    4.979356] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    4.980407] Linux agpgart interface v0.103
[    4.980407] Linux agpgart interface v0.103
[    4.981307] SyncLink PC Card driver $Revision: 4.34 $, tty major#244
[    4.981307] SyncLink PC Card driver $Revision: 4.34 $, tty major#244
[    4.982420] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    4.982420] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    4.984061] [drm] Initialized drm 1.1.0 20060810
[    4.984061] [drm] Initialized drm 1.1.0 20060810
[    4.984977] [drm] radeon kernel modesetting enabled.
[    4.984977] [drm] radeon kernel modesetting enabled.
[    4.986132] drm/i810 does not support SMP
[    4.986132] drm/i810 does not support SMP
[    4.987542] [TTM] Zone  kernel: Available graphics memory: 126704 kiB
[    4.987542] [TTM] Zone  kernel: Available graphics memory: 126704 kiB
[    4.988596] [TTM] Initializing pool allocator
[    4.988596] [TTM] Initializing pool allocator
[    4.989328] [TTM] Initializing DMA pool allocator
[    4.989328] [TTM] Initializing DMA pool allocator
[    4.990744] [drm] fb mappable at 0xFC000000
[    4.990744] [drm] fb mappable at 0xFC000000
[    4.991441] [drm] vram aper at 0xFC000000
[    4.991441] [drm] vram aper at 0xFC000000
[    4.992110] [drm] size 33554432
[    4.992110] [drm] size 33554432
[    4.992628] [drm] fb depth is 24
[    4.992628] [drm] fb depth is 24
[    4.993168] [drm]    pitch is 3072
[    4.993168] [drm]    pitch is 3072
[    4.993727] cirrusdrmfb: enable CONFIG_FB_LITTLE_ENDIAN to support this =
framebuffer
[    4.993727] cirrusdrmfb: enable CONFIG_FB_LITTLE_ENDIAN to support this =
framebuffer
[    4.994986] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on =
minor 0
[    4.994986] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on =
minor 0
[    4.996371] usbcore: registered new interface driver udl
[    4.996371] usbcore: registered new interface driver udl
[    4.997926] parport_pc 00:04: reported by Plug and Play ACPI
[    4.997926] parport_pc 00:04: reported by Plug and Play ACPI
[    4.998977] parport0: PC-style at 0x378
[    4.998977] parport0: PC-style at 0x378, irq 7, irq 7 [ [PCSPPPCSPP,TRIS=
TATE,TRISTATE]
]
[    5.080550] lp0: using parport0 (interrupt-driven).
[    5.080550] lp0: using parport0 (interrupt-driven).
[    5.081803] lp0: console ready
[    5.081803] lp0: console ready
[    5.083914] Phantom Linux Driver, version n0.9.8, init OK
[    5.083914] Phantom Linux Driver, version n0.9.8, init OK
[    5.085625] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    5.085625] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    5.088013] c2port c2port0: C2 port uc added
[    5.088013] c2port c2port0: C2 port uc added
[    5.089155] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    5.089155] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    5.091531] Guest personality initialized and is inactive
[    5.091531] Guest personality initialized and is inactive
[    5.093107] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D60)
[    5.093107] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D60)
[    5.094776] Initialized host personality
[    5.094776] Initialized host personality
[    5.096139] usbcore: registered new interface driver rtsx_usb
[    5.096139] usbcore: registered new interface driver rtsx_usb
[    5.098607] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[    5.098607] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[    5.100153] Detecting Adaptec I2O RAID controllers...
[    5.100153] Detecting Adaptec I2O RAID controllers...
[    5.101588] Adaptec aacraid driver 1.2-0[30300]-ms
[    5.101588] Adaptec aacraid driver 1.2-0[30300]-ms
[    5.102863] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    5.102863] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    5.104761] DC390: clustering now enabled by default. If you get problem=
s load
[    5.104761] DC390: clustering now enabled by default. If you get problem=
s load
[    5.106629]        with "disable_clustering=3D1" and report to maintaine=
rs
[    5.106629]        with "disable_clustering=3D1" and report to maintaine=
rs
[    5.108547] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 ES=
T 2006)
[    5.108547] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 ES=
T 2006)
[    5.110611] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 20=
06)
[    5.110611] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 20=
06)
[    5.112424] megasas: 06.805.06.00-rc1 Thu. Sep. 4 17:00:00 PDT 2014
[    5.112424] megasas: 06.805.06.00-rc1 Thu. Sep. 4 17:00:00 PDT 2014
[    5.114091] mpt2sas version 18.100.00.00 loaded
[    5.114091] mpt2sas version 18.100.00.00 loaded
[    5.115541] mpt3sas version 04.100.00.00 loaded
[    5.115541] mpt3sas version 04.100.00.00 loaded
[    5.117078] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    5.117078] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    5.118674] 3ware Storage Controller device driver for Linux v1.26.02.00=
3.
[    5.118674] 3ware Storage Controller device driver for Linux v1.26.02.00=
3.
[    5.120481] 3ware 9000 Storage Controller device driver for Linux v2.26.=
02.014.
[    5.120481] 3ware 9000 Storage Controller device driver for Linux v2.26.=
02.014.
[    5.122402] ppa: Version 2.07 (for Linux 2.4.x)
[    5.122402] ppa: Version 2.07 (for Linux 2.4.x)
[    5.125925] imm: Version 2.05 (for Linux 2.4.0)
[    5.125925] imm: Version 2.05 (for Linux 2.4.0)
[    5.127825] RocketRAID 3xxx/4xxx Controller driver v1.8
[    5.127825] RocketRAID 3xxx/4xxx Controller driver v1.8
[    5.129267] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
[    5.129267] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
[    5.131011] esas2r: driver will not be loaded because no ATTO esas2r dev=
ices were found
[    5.131011] esas2r: driver will not be loaded because no ATTO esas2r dev=
ices were found
[    5.133057] VMware PVSCSI driver - version 1.0.5.0-k
[    5.133057] VMware PVSCSI driver - version 1.0.5.0-k
[    5.134245] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    5.134245] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    5.135349] osst :I: Tape driver with OnStream support version 0.99.4
[    5.135349] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    5.135349] osst :I: Tape driver with OnStream support version 0.99.4
[    5.135349] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    5.137485] SCSI Media Changer driver v0.25=20
[    5.137485] SCSI Media Changer driver v0.25=20
[    5.138236] osd: LOADED open-osd 0.2.1
[    5.138236] osd: LOADED open-osd 0.2.1
[    5.139130] SSFDC read-only Flash Translation layer
[    5.139130] SSFDC read-only Flash Translation layer
[    5.140131] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    5.140131] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    5.141234] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    5.141234] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    5.142496] device id =3D 2440
[    5.142496] device id =3D 2440
[    5.142999] device id =3D 2480
[    5.142999] device id =3D 2480
[    5.143489] device id =3D 24c0
[    5.143489] device id =3D 24c0
[    5.143972] device id =3D 24d0
[    5.143972] device id =3D 24d0
[    5.144452] device id =3D 25a1
[    5.144452] device id =3D 25a1
[    5.144931] device id =3D 2670
[    5.144931] device id =3D 2670
[    5.145533] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel =
Networks.
[    5.145533] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel =
Networks.
[    5.146777] pmc551: not detected
[    5.146777] pmc551: not detected
[    5.148225] ftl_cs: FTL header not found.
[    5.148225] ftl_cs: FTL header not found.
[    5.150127] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    5.150127] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    5.151705] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    5.151705] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    5.153263] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    5.153263] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    5.154775] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    5.154775] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    5.156316] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    5.156316] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    5.157884] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    5.157884] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    5.159663] nand: device found, Manufacturer ID: 0x98, Chip ID: 0x39
[    5.159663] nand: device found, Manufacturer ID: 0x98, Chip ID: 0x39
[    5.161454] nand: Toshiba NAND 128MiB 1,8V 8-bit
[    5.161454] nand: Toshiba NAND 128MiB 1,8V 8-bit
[    5.162643] nand: 128MiB, SLC, page size: 512, OOB size: 16
[    5.162643] nand: 128MiB, SLC, page size: 512, OOB size: 16
[    5.164120] flash size: 128 MiB
[    5.164120] flash size: 128 MiB
[    5.164947] page size: 512 bytes
[    5.164947] page size: 512 bytes
[    5.165784] OOB area size: 16 bytes
[    5.165784] OOB area size: 16 bytes
[    5.166684] sector size: 16 KiB
[    5.166684] sector size: 16 KiB
[    5.167511] pages number: 262144
[    5.167511] pages number: 262144
[    5.168325] pages per sector: 32
[    5.168325] pages per sector: 32
[    5.169142] bus width: 8
[    5.169142] bus width: 8
[    5.169804] bits in sector size: 14
[    5.169804] bits in sector size: 14
[    5.170768] bits in page size: 9
[    5.170768] bits in page size: 9
[    5.171649] bits in OOB size: 4
[    5.171649] bits in OOB size: 4
[    5.172480] flash size with OOB: 135168 KiB
[    5.172480] flash size with OOB: 135168 KiB
[    5.173530] page address bytes: 4
[    5.173530] page address bytes: 4
[    5.174377] sector address bytes: 3
[    5.174377] sector address bytes: 3
[    5.175257] options: 0x42
[    5.175257] options: 0x42
[    5.177037] Scanning device for bad blocks
[    5.177037] Scanning device for bad blocks
[    5.211097] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    5.211097] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    5.212279] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    5.212279] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    5.215086] ftl_cs: FTL header not found.
[    5.215086] ftl_cs: FTL header not found.
[    5.217033] parport0: powerup/reset Butterfly
[    5.217033] parport0: powerup/reset Butterfly
[    5.340301] parport_pc 00:04: registered master spi42
[    5.340301] parport_pc 00:04: registered master spi42
[    5.348045] spi spi42.1: spi_bitbang_setup, 66 nsec/bit
[    5.348045] spi spi42.1: spi_bitbang_setup, 66 nsec/bit
[    5.349451] spi spi42.1: setup mode 0, 8 bits/w, 15000000 Hz max --> 0
[    5.349451] spi spi42.1: setup mode 0, 8 bits/w, 15000000 Hz max --> 0
[    5.352597] parport_pc 00:04: registered child spi42.1
[    5.352597] parport_pc 00:04: registered child spi42.1
[    5.353897] parport0: dataflash at spi42.1
[    5.353897] parport0: dataflash at spi42.1
[    5.354934] parport0: AVR Butterfly
[    5.354934] parport0: AVR Butterfly
[    5.356075] HSI/SSI char device loaded
[    5.356075] HSI/SSI char device loaded
[    5.357542] usbcore: registered new interface driver hwa-rc
[    5.357542] usbcore: registered new interface driver hwa-rc
[    5.359109] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.359109] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.360813] ehci-pci: EHCI PCI platform driver
[    5.360813] ehci-pci: EHCI PCI platform driver
[    5.362039] ehci-platform: EHCI generic platform driver
[    5.362039] ehci-platform: EHCI generic platform driver
[    5.363677] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.363677] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.365323] ohci-pci: OHCI PCI platform driver
[    5.365323] ohci-pci: OHCI PCI platform driver
[    5.366849] ohci-platform: OHCI generic platform driver
[    5.366849] ohci-platform: OHCI generic platform driver
[    5.368565] usbcore: registered new interface driver hwa-hc
[    5.368565] usbcore: registered new interface driver hwa-hc
[    5.370076] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    5.370076] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    5.371592] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[    5.371592] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[    5.374351] usbcore: registered new interface driver wusb-cbaf
[    5.374351] usbcore: registered new interface driver wusb-cbaf
[    5.375931] usbcore: registered new interface driver cdc_acm
[    5.375931] usbcore: registered new interface driver cdc_acm
[    5.377391] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    5.377391] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    5.379453] usbcore: registered new interface driver usblp
[    5.379453] usbcore: registered new interface driver usblp
[    5.381064] usbcore: registered new interface driver cdc_wdm
[    5.381064] usbcore: registered new interface driver cdc_wdm
[    5.382560] usbcore: registered new interface driver usbtmc
[    5.382560] usbcore: registered new interface driver usbtmc
[    5.384054] usbcore: registered new interface driver mdc800
[    5.384054] usbcore: registered new interface driver mdc800
[    5.385499] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    5.385499] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    5.387501] usbcore: registered new interface driver microtekX6
[    5.387501] usbcore: registered new interface driver microtekX6
[    5.389061] usbcore: registered new interface driver adutux
[    5.389061] usbcore: registered new interface driver adutux
[    5.390741] usbcore: registered new interface driver appledisplay
[    5.390741] usbcore: registered new interface driver appledisplay
[    5.392369] usbcore: registered new interface driver cypress_cy7c63
[    5.392369] usbcore: registered new interface driver cypress_cy7c63
[    5.394042] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    5.394042] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    5.395901] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    5.395901] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    5.397761] usbcore: registered new interface driver ldusb
[    5.397761] usbcore: registered new interface driver ldusb
[    5.399217] usbcore: registered new interface driver legousbtower
[    5.399217] usbcore: registered new interface driver legousbtower
[    5.400842] usbcore: registered new interface driver rio500
[    5.400842] usbcore: registered new interface driver rio500
[    5.402498] usbcore: registered new interface driver usbtest
[    5.402498] usbcore: registered new interface driver usbtest
[    5.404024] usbcore: registered new interface driver usbsevseg
[    5.404024] usbcore: registered new interface driver usbsevseg
[    5.405536] usbcore: registered new interface driver sisusb
[    5.405536] usbcore: registered new interface driver sisusb
[    5.407610] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    5.407610] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    5.410783] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.410783] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.412080] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.412080] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.466479] mousedev: PS/2 mouse device common for all mice
[    5.466479] mousedev: PS/2 mouse device common for all mice
[    5.467944] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    5.467944] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    5.470085] parport0: cannot grant exclusive access for device walkera07=
01
[    5.470085] parport0: cannot grant exclusive access for device walkera07=
01
[    5.471226] walkera0701: failed to register parport device
[    5.471226] walkera0701: failed to register parport device
[    5.472174] usbcore: registered new interface driver usb_acecad
[    5.472174] usbcore: registered new interface driver usb_acecad
[    5.473223] usbcore: registered new interface driver gtco
[    5.473223] usbcore: registered new interface driver gtco
[    5.474149] usbcore: registered new interface driver hanwang
[    5.474149] usbcore: registered new interface driver hanwang
[    5.475108] usbcore: registered new interface driver kbtab
[    5.475108] usbcore: registered new interface driver kbtab
[    5.476511] mk712: device not present
[    5.476511] mk712: device not present
[    5.477185] usbcore: registered new interface driver usbtouchscreen
[    5.477185] usbcore: registered new interface driver usbtouchscreen
[    5.478318] usbcore: registered new interface driver sur40
[    5.478318] usbcore: registered new interface driver sur40
[    5.479370] I2O subsystem v1.325
[    5.479370] I2O subsystem v1.325
[    5.479907] i2o: max drivers =3D 8
[    5.479907] i2o: max drivers =3D 8
[    5.481097] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    5.481097] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    5.482523] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    5.482523] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    5.484344] I2O Configuration OSM v1.323
[    5.484344] I2O Configuration OSM v1.323
[    5.485055] I2O Bus Adapter OSM v1.317
[    5.485055] I2O Bus Adapter OSM v1.317
[    5.485695] I2O SCSI Peripheral OSM v1.316
[    5.485695] I2O SCSI Peripheral OSM v1.316
[    5.486422] i2c /dev entries driver
[    5.486422] i2c /dev entries driver
[    5.487216] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0x700, re=
vision 0
[    5.487216] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0x700, re=
vision 0
[    5.740721] usbcore: registered new interface driver i2c-diolan-u2c
[    5.740721] usbcore: registered new interface driver i2c-diolan-u2c
[    5.742317] i2c-parport: adapter type unspecified
[    5.742317] i2c-parport: adapter type unspecified
[    5.743565] i2c-parport-light: adapter type unspecified
[    5.743565] i2c-parport-light: adapter type unspecified
[    5.745039] usbcore: registered new interface driver i2c-tiny-usb
[    5.745039] usbcore: registered new interface driver i2c-tiny-usb
[    5.746733] Driver for 1-wire Dallas network protocol.
[    5.746733] Driver for 1-wire Dallas network protocol.
[    5.748186] usbcore: registered new interface driver DS9490R
[    5.748186] usbcore: registered new interface driver DS9490R
[    5.749671] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    5.749671] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    5.751539] 1-Wire driver for the DS2760 battery monitor chip - (c) 2004=
-2005, Szabolcs Gyurko
[    5.751539] 1-Wire driver for the DS2760 battery monitor chip - (c) 2004=
-2005, Szabolcs Gyurko
[    8.690520] pc87360: PC8736x not detected, module not inserted
[    8.690520] pc87360: PC8736x not detected, module not inserted
[    8.692130] sch56xx_common: Unsupported device id: 0xff
[    8.692130] sch56xx_common: Unsupported device id: 0xff
[    8.693574] sch56xx_common: Unsupported device id: 0xff
[    8.693574] sch56xx_common: Unsupported device id: 0xff
[    9.130385] usbcore: registered new interface driver pcwd_usb
[    9.130385] usbcore: registered new interface driver pcwd_usb
[    9.131886] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    9.131886] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    9.133928] acquirewdt: I/O address 0x0043 already in use
[    9.133928] acquirewdt: I/O address 0x0043 already in use
[    9.135255] acquirewdt: probe of acquirewdt failed with error -5
[    9.135255] acquirewdt: probe of acquirewdt failed with error -5
[    9.136828] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[    9.136828] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[    9.139063] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D1)
[    9.139063] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D1)
[    9.140615] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[    9.140615] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[    9.142510] ib700wdt: START method I/O 443 is not available
[    9.142510] ib700wdt: START method I/O 443 is not available
[    9.143876] ib700wdt: probe of ib700wdt failed with error -5
[    9.143876] ib700wdt: probe of ib700wdt failed with error -5
[    9.145348] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    9.145348] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    9.146831] it87_wdt: no device
[    9.146831] it87_wdt: no device
[    9.147714] pc87413_wdt: Version 1.1 at io 0x2E
[    9.147714] pc87413_wdt: Version 1.1 at io 0x2E
[    9.148827] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    9.148827] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    9.150451] nv_tco: NV TCO WatchDog Timer Driver v0.01
[    9.150451] nv_tco: NV TCO WatchDog Timer Driver v0.01
[    9.151999] cpu5wdt: misc_register failed
[    9.151999] cpu5wdt: misc_register failed
[    9.153112] w83877f_wdt: I/O address 0x0443 already in use
[    9.153112] w83877f_wdt: I/O address 0x0443 already in use
[    9.154453] w83977f_wdt: driver v1.00
[    9.154453] w83977f_wdt: driver v1.00
[    9.155353] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    9.155353] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    9.157192] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    9.157192] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    9.159227] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    9.159227] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    9.161362] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D1)
[    9.161362] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D1)
[    9.183151] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    9.183151] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    9.186042] hidraw: raw HID events driver (C) Jiri Kosina
[    9.186042] hidraw: raw HID events driver (C) Jiri Kosina
[    9.189113] usbcore: registered new interface driver usbhid
[    9.189113] usbcore: registered new interface driver usbhid
[    9.190080] usbhid: USB HID core driver
[    9.190080] usbhid: USB HID core driver
[    9.192348]  fake-fmc-carrier: mezzanine 0
[    9.192348]  fake-fmc-carrier: mezzanine 0
[    9.193107]       Manufacturer: fake-vendor
[    9.193107]       Manufacturer: fake-vendor
[    9.193834]       Product name: fake-design-for-testing
[    9.193834]       Product name: fake-design-for-testing
[    9.194764] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    9.194764] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    9.195987] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[    9.195987] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[    9.197709] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    9.197709] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    9.199014] fmc_chardev fake-design-for-testing-f001: Created misc devic=
e "fake-design-for-testing-f001"
[    9.199014] fmc_chardev fake-design-for-testing-f001: Created misc devic=
e "fake-design-for-testing-f001"
[    9.200755] oprofile: using timer interrupt.
[    9.200755] oprofile: using timer interrupt.
[    9.201836]=20
[    9.201836] printing PIC contents
[    9.201836]=20
[    9.201836] printing PIC contents
[    9.202712] ... PIC  IMR: ffff
[    9.202712] ... PIC  IMR: ffff
[    9.203243] ... PIC  IRR: 1013
[    9.203243] ... PIC  IRR: 1013
[    9.203762] ... PIC  ISR: 0000
[    9.203762] ... PIC  ISR: 0000
[    9.204281] ... PIC ELCR: 0c00
[    9.204281] ... PIC ELCR: 0c00
[    9.204855] printing local APIC contents on CPU#0/0:
[    9.204855] printing local APIC contents on CPU#0/0:
[    9.206140] ... APIC ID:      00000000 (0)
[    9.206140] ... APIC ID:      00000000 (0)
[    9.206831] ... APIC VERSION: 01050014
[    9.206831] ... APIC VERSION: 01050014
[    9.207472] ... APIC TASKPRI: 00000000 (00)
[    9.207472] ... APIC TASKPRI: 00000000 (00)
[    9.208182] ... APIC PROCPRI: 00000000
[    9.208182] ... APIC PROCPRI: 00000000
[    9.208832] ... APIC LDR: 01000000
[    9.208832] ... APIC LDR: 01000000
[    9.209412] ... APIC DFR: ffffffff
[    9.209412] ... APIC DFR: ffffffff
[    9.209978] ... APIC SPIV: 000001ff
[    9.209978] ... APIC SPIV: 000001ff
[    9.210555] ... APIC ISR field:
[    9.210555] ... APIC ISR field:
[    9.211103] 00000000
[    9.211103] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    9.212448] ... APIC TMR field:
[    9.212448] ... APIC TMR field:
[    9.213026] 00000000
[    9.213026] 000000000e2000000e200000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    9.214337] ... APIC IRR field:
[    9.214337] ... APIC IRR field:
[    9.214840] 00000000
[    9.214840] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000002000000020000000

[    9.214840] ... APIC ESR: 00000000
[    9.214840] ... APIC ESR: 00000000
[    9.214840] ... APIC ICR: 000008fd
[    9.214840] ... APIC ICR: 000008fd
[    9.214840] ... APIC ICR2: 02000000
[    9.214840] ... APIC ICR2: 02000000
[    9.214840] ... APIC LVTT: 000000ef
[    9.214840] ... APIC LVTT: 000000ef
[    9.214840] ... APIC LVTPC: 00010000
[    9.214840] ... APIC LVTPC: 00010000
[    9.214840] ... APIC LVT0: 00010700
[    9.214840] ... APIC LVT0: 00010700
[    9.214840] ... APIC LVT1: 00000400
[    9.214840] ... APIC LVT1: 00000400
[    9.214840] ... APIC LVTERR: 000000fe
[    9.214840] ... APIC LVTERR: 000000fe
[    9.214840] ... APIC TMICT: 032382f5
[    9.214840] ... APIC TMICT: 032382f5
[    9.214840] ... APIC TMCCT: 03038657
[    9.214840] ... APIC TMCCT: 03038657
[    9.214840] ... APIC TDCR: 00000003
[    9.214840] ... APIC TDCR: 00000003
[    9.214840]=20
[    9.214840]=20
[    9.223109] number of MP IRQ sources: 15.
[    9.223109] number of MP IRQ sources: 15.
[    9.224122] number of IO-APIC #0 registers: 24.
[    9.224122] number of IO-APIC #0 registers: 24.
[    9.225199] testing the IO APIC.......................
[    9.225199] testing the IO APIC.......................
[    9.226454] IO APIC #0......
[    9.226454] IO APIC #0......
[    9.227147] .... register #00: 00000000
[    9.227147] .... register #00: 00000000
[    9.228115] .......    : physical APIC id: 00
[    9.228115] .......    : physical APIC id: 00
[    9.229174] .......    : Delivery Type: 0
[    9.229174] .......    : Delivery Type: 0
[    9.230211] .......    : LTS          : 0
[    9.230211] .......    : LTS          : 0
[    9.231188] .... register #01: 00170011
[    9.231188] .... register #01: 00170011
[    9.232122] .......     : max redirection entries: 17
[    9.232122] .......     : max redirection entries: 17
[    9.233391] .......     : PRQ implemented: 0
[    9.233391] .......     : PRQ implemented: 0
[    9.234456] .......     : IO APIC version: 11
[    9.234456] .......     : IO APIC version: 11
[    9.235513] .... register #02: 00000000
[    9.235513] .... register #02: 00000000
[    9.236482] .......     : arbitration: 00
[    9.236482] .......     : arbitration: 00
[    9.237428] .... IRQ redirection table:
[    9.237428] .... IRQ redirection table:
[    9.238412] 1    0    0   0   0    0    0    00
[    9.238412] 1    0    0   0   0    0    0    00
[    9.239556] 0    0    0   0   0    1    1    31
[    9.239556] 0    0    0   0   0    1    1    31
[    9.240696] 0    0    0   0   0    1    1    30
[    9.240696] 0    0    0   0   0    1    1    30
[    9.241794] 0    0    0   0   0    1    1    33
[    9.241794] 0    0    0   0   0    1    1    33
[    9.242937] 1    0    0   0   0    1    1    34
[    9.242937] 1    0    0   0   0    1    1    34
[    9.244042] 1    1    0   0   0    1    1    35
[    9.244042] 1    1    0   0   0    1    1    35
[    9.245262] 0    0    0   0   0    1    1    36
[    9.245262] 0    0    0   0   0    1    1    36
[    9.246356] 0    0    0   0   0    1    1    37
[    9.246356] 0    0    0   0   0    1    1    37
[    9.247486] 0    0    0   0   0    1    1    38
[    9.247486] 0    0    0   0   0    1    1    38
[    9.248616] 0    1    0   0   0    1    1    39
[    9.248616] 0    1    0   0   0    1    1    39
[    9.249724] 1    1    0   0   0    1    1    3A
[    9.249724] 1    1    0   0   0    1    1    3A
[    9.250868] 1    1    0   0   0    1    1    3B
[    9.250868] 1    1    0   0   0    1    1    3B
[    9.251965] 0    0    0   0   0    1    1    3C
[    9.251965] 0    0    0   0   0    1    1    3C
[    9.253108] 0    0    0   0   0    1    1    3D
[    9.253108] 0    0    0   0   0    1    1    3D
[    9.254198] 0    0    0   0   0    1    1    3E
[    9.254198] 0    0    0   0   0    1    1    3E
[    9.255316] 0    0    0   0   0    1    1    3F
[    9.255316] 0    0    0   0   0    1    1    3F
[    9.256465] 1    0    0   0   0    0    0    00
[    9.256465] 1    0    0   0   0    0    0    00
[    9.257567] 1    0    0   0   0    0    0    00
[    9.257567] 1    0    0   0   0    0    0    00
[    9.258674] 1    0    0   0   0    0    0    00
[    9.258674] 1    0    0   0   0    0    0    00
[    9.259790] 1    0    0   0   0    0    0    00
[    9.259790] 1    0    0   0   0    0    0    00
[    9.260959] 1    0    0   0   0    0    0    00
[    9.260959] 1    0    0   0   0    0    0    00
[    9.262062] 1    0    0   0   0    0    0    00
[    9.262062] 1    0    0   0   0    0    0    00
[    9.263193] 1    0    0   0   0    0    0    00
[    9.263193] 1    0    0   0   0    0    0    00
[    9.264309] 1    0    0   0   0    0    0    00
[    9.264309] 1    0    0   0   0    0    0    00
[    9.265416] IRQ to pin mappings:
[    9.265416] IRQ to pin mappings:
[    9.266192] IRQ0=20
[    9.266192] IRQ0 -> 0:2-> 0:2

[    9.266846] IRQ1=20
[    9.266846] IRQ1 -> 0:1-> 0:1

[    9.267520] IRQ3=20
[    9.267520] IRQ3 -> 0:3-> 0:3

[    9.268161] IRQ4=20
[    9.268161] IRQ4 -> 0:4-> 0:4

[    9.268790] IRQ5=20
[    9.268790] IRQ5 -> 0:5-> 0:5

[    9.269426] IRQ6=20
[    9.269426] IRQ6 -> 0:6-> 0:6

[    9.270208] IRQ7=20
[    9.270208] IRQ7 -> 0:7-> 0:7

[    9.270840] IRQ8=20
[    9.270840] IRQ8 -> 0:8-> 0:8

[    9.271486] IRQ9=20
[    9.271486] IRQ9 -> 0:9-> 0:9

[    9.272120] IRQ10=20
[    9.272120] IRQ10 -> 0:10-> 0:10

[    9.272820] IRQ11=20
[    9.272820] IRQ11 -> 0:11-> 0:11

[    9.273504] IRQ12=20
[    9.273504] IRQ12 -> 0:12-> 0:12

[    9.274187] IRQ13=20
[    9.274187] IRQ13 -> 0:13-> 0:13

[    9.274853] IRQ14=20
[    9.274853] IRQ14 -> 0:14-> 0:14

[    9.275541] IRQ15=20
[    9.275541] IRQ15 -> 0:15-> 0:15

[    9.276228] .................................... done.
[    9.276228] .................................... done.
[    9.280434] bootconsole [earlyser0] disabled
[    9.280434] bootconsole [earlyser0] disabled
[    9.284396] Btrfs loaded, debug=3Don, assert=3Don, integrity-checker=3Don
[    9.285341] BTRFS: selftest: Running btrfs free space cache tests
[    9.286124] BTRFS: selftest: Running extent only tests
[    9.286803] BTRFS: selftest: Running bitmap only tests
[    9.287466] BTRFS: selftest: Running bitmap and extent tests
[    9.288187] BTRFS: selftest: Running space stealing from bitmap to extent
[    9.289471] BTRFS: selftest: Free space cache tests finished
[    9.290244] BTRFS: selftest: Running extent buffer operation tests
[    9.291006] BTRFS: selftest: Running btrfs_split_item tests
[    9.291818] BTRFS: selftest: Running find delalloc tests

BUG: kernel boot hang
Elapsed time: 305
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-n0-12152252/7552e7dd9527c41f891c87854418896eaf309c20/vmlinuz-3.18.0-rc4-g7=
552e7d -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D=
-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 =
prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=
=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-n0-121=
52252/drm-intel:topic:core-stuff:7552e7dd9527c41f891c87854418896eaf309c20:b=
isect-linux-0/.vmlinuz-7552e7dd9527c41f891c87854418896eaf309c20-20141218070=
725-57-client6 branch=3Ddrm-intel/topic/core-stuff BOOT_IMAGE=3D/kernel/x86=
_64-randconfig-n0-12152252/7552e7dd9527c41f891c87854418896eaf309c20/vmlinuz=
-3.18.0-rc4-g7552e7d drbd.minor_count=3D8'  -initrd /kernel-tests/initrd/qu=
antal-core-x86_64.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=3De1000 -net us=
er,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dloca=
ltime -pidfile /dev/shm/kboot/pid-quantal-client6-10 -serial file:/dev/shm/=
kboot/serial-quantal-client6-10 -daemonize -display none -monitor null=20

--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.18.0-rc4-g7bf2844"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.18.0-rc4 Kernel Configuration
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
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
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
CONFIG_KERNEL_LZMA=y
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_FHANDLE is not set
# CONFIG_USELIB is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
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
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_TASKS_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_RCU_USER_QS=y
CONFIG_CONTEXT_TRACKING_FORCE=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_RCU_FAST_NO_HZ=y
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
CONFIG_RCU_NOCB_CPU_ZERO=y
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
CONFIG_CGROUP_HUGETLB=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
# CONFIG_EVENTFD is not set
# CONFIG_BPF_SYSCALL is not set
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_ADVISE_SYSCALLS=y
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
# CONFIG_UPROBES is not set
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
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
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
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
CONFIG_GCOV_FORMAT_3_4=y
# CONFIG_GCOV_FORMAT_4_7 is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_CMDLINE_PARSER is not set

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
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
CONFIG_QUEUE_RWLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_IOSF_MBI is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_DEBUG=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=500
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
# CONFIG_XEN_PVH is not set
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
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
# CONFIG_CPU_SUP_AMD is not set
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
# CONFIG_X86_16BIT is not set
CONFIG_I8K=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CLEANCACHE is not set
CONFIG_FRONTSWAP=y
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
CONFIG_CMA_AREAS=7
# CONFIG_ZSWAP is not set
# CONFIG_ZPOOL is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
# CONFIG_X86_PAT is not set
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
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
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

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
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

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
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=y
# CONFIG_PCIEASPM is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=y
# CONFIG_XEN_PCIDEV_FRONTEND is not set
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
CONFIG_YENTA=y
# CONFIG_YENTA_O2 is not set
# CONFIG_YENTA_RICOH is not set
CONFIG_YENTA_TI=y
# CONFIG_YENTA_TOSHIBA is not set
CONFIG_PD6729=y
CONFIG_I82092=y
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set
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
# CONFIG_RAPIDIO_TSI57X is not set
CONFIG_RAPIDIO_CPS_XX=y
# CONFIG_RAPIDIO_TSI568 is not set
CONFIG_RAPIDIO_CPS_GEN2=y
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_PMC_ATOM=y
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
# CONFIG_NET_PTP_CLASSIFY is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y
CONFIG_ALLOW_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_FENCE_TRACE is not set
# CONFIG_DMA_CMA is not set

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
CONFIG_FTL=y
CONFIG_NFTL=y
# CONFIG_NFTL_RW is not set
# CONFIG_INFTL is not set
CONFIG_RFD_FTL=y
CONFIG_SSFDC=y
CONFIG_SM_FTL=y
CONFIG_MTD_OOPS=y
CONFIG_MTD_SWAP=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
CONFIG_MTD_CFI_LE_BYTE_SWAP=y
# CONFIG_MTD_CFI_GEOMETRY is not set
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
# CONFIG_MTD_OTP is not set
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=y
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
# CONFIG_MTD_RAM is not set
CONFIG_MTD_ROM=y
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PHYSMAP is not set
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
CONFIG_MTD_ESB2ROM=y
CONFIG_MTD_CK804XROM=y
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
# CONFIG_MTD_PCI is not set
CONFIG_MTD_PCMCIA=y
CONFIG_MTD_PCMCIA_ANONYMOUS=y
CONFIG_MTD_GPIO_ADDR=y
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set
# CONFIG_MTD_LATCH_ADDR is not set

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
CONFIG_MTD_PMC551_BUGFIX=y
# CONFIG_MTD_PMC551_DEBUG is not set
CONFIG_MTD_DATAFLASH=y
# CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
# CONFIG_MTD_DATAFLASH_OTP is not set
# CONFIG_MTD_M25P80 is not set
CONFIG_MTD_SST25L=y
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
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
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
CONFIG_MTD_SM_COMMON=y
CONFIG_MTD_NAND_DENALI=y
CONFIG_MTD_NAND_DENALI_PCI=y
CONFIG_MTD_NAND_DENALI_SCRATCH_REG_ADDR=0xFF108018
CONFIG_MTD_NAND_GPIO=y
# CONFIG_MTD_NAND_OMAP_BCH_BUILD is not set
CONFIG_MTD_NAND_IDS=y
CONFIG_MTD_NAND_RICOH=y
# CONFIG_MTD_NAND_DISKONCHIP is not set
CONFIG_MTD_NAND_DOCG4=y
CONFIG_MTD_NAND_CAFE=y
CONFIG_MTD_NAND_NANDSIM=y
CONFIG_MTD_NAND_PLATFORM=y
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
CONFIG_MTD_ONENAND_GENERIC=y
CONFIG_MTD_ONENAND_OTP=y
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_SPI_NOR=y
CONFIG_MTD_SPI_NOR_USE_4K_SECTORS=y
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
# CONFIG_MTD_UBI_GLUEBI is not set
# CONFIG_MTD_UBI_BLOCK is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_PC_PCMCIA is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
# CONFIG_PARIDE is not set
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
# CONFIG_BLK_DEV_SKD is not set
# CONFIG_BLK_DEV_OSD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=y
# CONFIG_XEN_BLKDEV_BACKEND is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_HP_ILO=y
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_DS1682=y
CONFIG_TI_DAC7512=y
CONFIG_VMWARE_BALLOON=y
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_BMP085_SPI=y
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_LATTICE_ECP3_CONFIG=y
CONFIG_SRAM=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
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
# CONFIG_ALTERA_STAPL is not set
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
CONFIG_INTEL_MEI_TXE=y
CONFIG_VMWARE_VMCI=y

#
# Intel MIC Bus Driver
#
# CONFIG_INTEL_MIC_BUS is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_GENWQE=y
CONFIG_GENWQE_PLATFORM_ERROR_RECOVERY=0
CONFIG_ECHO=y
# CONFIG_CXL_BASE is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_MQ_DEFAULT=y

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
CONFIG_BLK_DEV_3W_XXXX_RAID=y
CONFIG_SCSI_HPSA=y
CONFIG_SCSI_3W_9XXX=y
# CONFIG_SCSI_3W_SAS is not set
CONFIG_SCSI_ACARD=y
CONFIG_SCSI_AACRAID=y
# CONFIG_SCSI_AIC7XXX is not set
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC94XX=y
CONFIG_AIC94XX_DEBUG=y
# CONFIG_SCSI_MVSAS is not set
CONFIG_SCSI_MVUMI=y
CONFIG_SCSI_DPT_I2O=y
CONFIG_SCSI_ADVANSYS=y
CONFIG_SCSI_ARCMSR=y
CONFIG_SCSI_ESAS2R=y
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS_LOGGING is not set
CONFIG_SCSI_MPT3SAS=y
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_LOGGING=y
CONFIG_SCSI_UFSHCD=y
# CONFIG_SCSI_UFSHCD_PCI is not set
CONFIG_SCSI_UFSHCD_PLATFORM=y
CONFIG_SCSI_HPTIOP=y
CONFIG_SCSI_BUSLOGIC=y
# CONFIG_SCSI_FLASHPOINT is not set
CONFIG_VMWARE_PVSCSI=y
# CONFIG_XEN_SCSI_FRONTEND is not set
# CONFIG_SCSI_DMX3191D is not set
CONFIG_SCSI_EATA=y
# CONFIG_SCSI_EATA_TAGGED_QUEUE is not set
# CONFIG_SCSI_EATA_LINKED_COMMANDS is not set
CONFIG_SCSI_EATA_MAX_TAGS=16
# CONFIG_SCSI_FUTURE_DOMAIN is not set
CONFIG_SCSI_GDTH=y
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
CONFIG_SCSI_PPA=y
CONFIG_SCSI_IMM=y
# CONFIG_SCSI_IZIP_EPP16 is not set
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
CONFIG_SCSI_STEX=y
# CONFIG_SCSI_SYM53C8XX_2 is not set
CONFIG_SCSI_QLOGIC_1280=y
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_DC395x is not set
CONFIG_SCSI_DC390T=y
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
CONFIG_SCSI_VIRTIO=y
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
# CONFIG_I2O_EXT_ADAPTEC_DMA64 is not set
CONFIG_I2O_CONFIG=y
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
CONFIG_I2O_BUS=y
# CONFIG_I2O_BLOCK is not set
CONFIG_I2O_SCSI=y
# CONFIG_I2O_PROC is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_NETDEVICES is not set

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
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

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
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=y
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=y
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=y
# CONFIG_JOYSTICK_SIDEWINDER is not set
CONFIG_JOYSTICK_TMDC=y
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=y
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
CONFIG_JOYSTICK_SPACEBALL=y
# CONFIG_JOYSTICK_STINGER is not set
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=y
CONFIG_JOYSTICK_GAMECON=y
# CONFIG_JOYSTICK_TURBOGRAFX is not set
# CONFIG_JOYSTICK_AS5011 is not set
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_JOYSTICK_WALKERA0701=y
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
# CONFIG_TABLET_USB_AIPTEK is not set
CONFIG_TABLET_USB_GTCO=y
CONFIG_TABLET_USB_HANWANG=y
CONFIG_TABLET_USB_KBTAB=y
CONFIG_TABLET_SERIAL_WACOM4=y
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=y
CONFIG_TOUCHSCREEN_ADS7846=y
# CONFIG_TOUCHSCREEN_AD7877 is not set
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
CONFIG_TOUCHSCREEN_AD7879_SPI=y
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
# CONFIG_TOUCHSCREEN_BU21013 is not set
CONFIG_TOUCHSCREEN_CY8CTMG110=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP_I2C=y
CONFIG_TOUCHSCREEN_CYTTSP_SPI=y
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=y
CONFIG_TOUCHSCREEN_CYTTSP4_SPI=y
CONFIG_TOUCHSCREEN_DA9052=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=y
CONFIG_TOUCHSCREEN_FUJITSU=y
CONFIG_TOUCHSCREEN_ILI210X=y
CONFIG_TOUCHSCREEN_GUNZE=y
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=y
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
CONFIG_TOUCHSCREEN_MMS114=y
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_WM831X=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_MC13783=y
# CONFIG_TOUCHSCREEN_USB_EGALAX is not set
CONFIG_TOUCHSCREEN_USB_PANJIT=y
# CONFIG_TOUCHSCREEN_USB_3M is not set
# CONFIG_TOUCHSCREEN_USB_ITM is not set
# CONFIG_TOUCHSCREEN_USB_ETURBO is not set
# CONFIG_TOUCHSCREEN_USB_GUNZE is not set
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
# CONFIG_TOUCHSCREEN_USB_IRTOUCH is not set
# CONFIG_TOUCHSCREEN_USB_IDEALTEK is not set
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
# CONFIG_TOUCHSCREEN_USB_GOTOP is not set
CONFIG_TOUCHSCREEN_USB_JASTEC=y
# CONFIG_TOUCHSCREEN_USB_ELO is not set
CONFIG_TOUCHSCREEN_USB_E2I=y
# CONFIG_TOUCHSCREEN_USB_ZYTRONIC is not set
# CONFIG_TOUCHSCREEN_USB_ETT_TC45USB is not set
# CONFIG_TOUCHSCREEN_USB_NEXIO is not set
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2005 is not set
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_ST1232=y
CONFIG_TOUCHSCREEN_SUR40=y
CONFIG_TOUCHSCREEN_TPS6507X=y
# CONFIG_TOUCHSCREEN_ZFORCE is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PARKBD is not set
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
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
# CONFIG_UNIX98_PTYS is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=y
# CONFIG_N_GSM is not set
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
# CONFIG_SERIAL_8250_DMA is not set
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_DW=y
# CONFIG_SERIAL_8250_FINTEK is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=y
CONFIG_SERIAL_MAX310X=y
CONFIG_SERIAL_MRST_MAX3110=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_SERIAL_SCCNXP=y
CONFIG_SERIAL_SCCNXP_CONSOLE=y
# CONFIG_SERIAL_SC16IS7XX is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS=y
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
# CONFIG_SERIAL_IFX6X60 is not set
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
# CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
CONFIG_SERIAL_MEN_Z135=y
CONFIG_TTY_PRINTK=y
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=y
# CONFIG_HVC_XEN is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_SI_PROBE_DEFAULTS=y
# CONFIG_IPMI_WATCHDOG is not set
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_TPM=y
# CONFIG_NVRAM is not set
CONFIG_R3964=y
CONFIG_APPLICOM=y

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
CONFIG_MWAVE=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_ATMEL is not set
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_TIS_I2C_NUVOTON=y
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
CONFIG_TCG_XEN=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_XILLYBUS=y

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
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
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_ISMT=y
CONFIG_I2C_PIIX4=y
# CONFIG_I2C_NFORCE2 is not set
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
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_GPIO=y
CONFIG_I2C_KEMPLD=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
CONFIG_SPI_OC_TINY=y
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_SC18IS602 is not set
CONFIG_SPI_XCOMM=y
CONFIG_SPI_XILINX=y
CONFIG_SPI_DESIGNWARE=y
CONFIG_SPI_DW_PCI=y
# CONFIG_SPI_DW_MMIO is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=y
CONFIG_SPMI=y
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
CONFIG_HSI_CHAR=y

#
# PPS support
#
# CONFIG_PPS is not set

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
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_DA9055=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_SCH311X=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
CONFIG_GPIO_LP3943=y
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_RC5T583 is not set
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TWL4030=y
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_WM8350=y
CONFIG_GPIO_ADP5520=y
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_INTEL_MID=y
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MCP23S08 is not set
# CONFIG_GPIO_MC33880 is not set

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
# CONFIG_GPIO_JANZ_TTL is not set
# CONFIG_GPIO_PALMAS is not set

#
# USB GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2406=y
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
# CONFIG_WM831X_BACKUP is not set
CONFIG_WM831X_POWER=y
CONFIG_WM8350_POWER=y
CONFIG_TEST_POWER=y
CONFIG_BATTERY_88PM860X=y
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
CONFIG_BATTERY_BQ27X00_PLATFORM=y
# CONFIG_BATTERY_DA9052 is not set
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_BATTERY_TWL4030_MADC=y
CONFIG_CHARGER_88PM860X=y
CONFIG_CHARGER_PCF50633=y
CONFIG_BATTERY_RX51=y
# CONFIG_CHARGER_ISP1704 is not set
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_TWL4030 is not set
CONFIG_CHARGER_LP8727=y
# CONFIG_CHARGER_GPIO is not set
CONFIG_CHARGER_MAX14577=y
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_BQ24735=y
# CONFIG_CHARGER_SMB347 is not set
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
CONFIG_SENSORS_ADT7410=y
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_DA9052_ADC is not set
CONFIG_SENSORS_DA9055=y
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_MC13783_ADC=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_G762=y
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IIO_HWMON=y
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_POWR1220 is not set
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4260=y
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX16065=y
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=y
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=y
# CONFIG_SENSORS_HTU21 is not set
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_MENF21BMC_HWMON=y
CONFIG_SENSORS_ADCXX=y
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM70=y
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_NTC_THERMISTOR=y
# CONFIG_SENSORS_NCT6683 is not set
# CONFIG_SENSORS_NCT6775 is not set
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=y
# CONFIG_SENSORS_SHT21 is not set
CONFIG_SENSORS_SHTC1=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_ADS7871=y
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP103=y
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_TWL4030_MADC is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_WM831X is not set
CONFIG_SENSORS_WM8350=y

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
# CONFIG_THERMAL_GOV_BANG_BANG is not set
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INT340X_THERMAL is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_DA9052_WATCHDOG=y
CONFIG_DA9055_WATCHDOG=y
# CONFIG_DA9063_WATCHDOG is not set
CONFIG_MENF21BMC_WATCHDOG=y
# CONFIG_WM831X_WATCHDOG is not set
# CONFIG_WM8350_WATCHDOG is not set
CONFIG_XILINX_WATCHDOG=y
CONFIG_DW_WATCHDOG=y
CONFIG_TWL4030_WATCHDOG=y
# CONFIG_RETU_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
CONFIG_ITCO_WDT=y
# CONFIG_ITCO_VENDOR_SUPPORT is not set
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
CONFIG_HP_WATCHDOG=y
CONFIG_KEMPLD_WDT=y
CONFIG_HPWDT_NMI_DECODING=y
# CONFIG_SC1200_WDT is not set
CONFIG_PC87413_WDT=y
CONFIG_NV_TCO=y
# CONFIG_60XX_WDT is not set
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_MEN_A21_WDT=y
# CONFIG_XEN_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
CONFIG_WDTPCI=y

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
# CONFIG_SSB_PCMCIAHOST is not set
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
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
CONFIG_MFD_AS3711=y
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_BCM590XX=y
# CONFIG_MFD_AXP20X is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
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
# CONFIG_INTEL_SOC_PMIC is not set
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_MENF21BMC=y
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_VIPERBOARD is not set
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
CONFIG_PCF50633_GPIO=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RTSX_USB=y
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_RN5T618 is not set
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=y
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS65218=y
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
# CONFIG_MFD_TWL4030_AUDIO is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_ARIZONA_SPI=y
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_88PM800=y
CONFIG_REGULATOR_88PM8607=y
# CONFIG_REGULATOR_ACT8865 is not set
# CONFIG_REGULATOR_AD5398 is not set
# CONFIG_REGULATOR_AAT2870 is not set
CONFIG_REGULATOR_AS3711=y
CONFIG_REGULATOR_BCM590XX=y
# CONFIG_REGULATOR_DA9052 is not set
# CONFIG_REGULATOR_DA9055 is not set
CONFIG_REGULATOR_DA9063=y
# CONFIG_REGULATOR_DA9210 is not set
CONFIG_REGULATOR_DA9211=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL9305=y
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LTC3589=y
CONFIG_REGULATOR_MAX14577=y
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX77693=y
# CONFIG_REGULATOR_MC13783 is not set
# CONFIG_REGULATOR_MC13892 is not set
# CONFIG_REGULATOR_PALMAS is not set
# CONFIG_REGULATOR_PCF50633 is not set
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_RC5T583=y
# CONFIG_REGULATOR_S2MPA01 is not set
CONFIG_REGULATOR_S2MPS11=y
CONFIG_REGULATOR_S5M8767=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=y
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS6524X=y
# CONFIG_REGULATOR_TPS65912 is not set
CONFIG_REGULATOR_TWL4030=y
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8350=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_SDR_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_RADIO_ADAPTERS is not set
CONFIG_CYPRESS_FIRMWARE=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

#
# Audio decoders, processors and mixers
#

#
# RDS decoders
#

#
# Video decoders
#

#
# Video and audio decoders
#

#
# Video encoders
#

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#

#
# Audio/Video compression chips
#

#
# Miscellaneous helper chips
#

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MC44S803=y

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
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
CONFIG_DRM_PTN3460=y
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_UMS=y
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
CONFIG_DRM_I810=y
CONFIG_DRM_I915=y
# CONFIG_DRM_I915_KMS is not set
CONFIG_DRM_I915_FBDEV=y
CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT=y
CONFIG_DRM_MGA=y
# CONFIG_DRM_SIS is not set
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
CONFIG_DRM_VMWGFX=y
# CONFIG_DRM_VMWGFX_FBCON is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=y
CONFIG_DRM_AST=y
CONFIG_DRM_MGAG200=y
CONFIG_DRM_CIRRUS_QEMU=y
# CONFIG_DRM_QXL is not set
CONFIG_DRM_BOCHS=y

#
# Frame buffer Devices
#
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_CMDLINE=y
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
# CONFIG_FB_SVGALIB is not set
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
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=y
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
# CONFIG_FB_RIVA is not set
CONFIG_FB_I740=y
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
CONFIG_FB_MATROX=y
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
# CONFIG_FB_MATROX_G is not set
CONFIG_FB_MATROX_I2C=y
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=y
# CONFIG_FB_ATY128_BACKLIGHT is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=y
# CONFIG_FB_VIA_DIRECT_PROCFS is not set
CONFIG_FB_VIA_X_COMPATIBILITY=y
CONFIG_FB_NEOMAGIC=y
# CONFIG_FB_KYRO is not set
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
# CONFIG_FB_3DFX_I2C is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
CONFIG_FB_TRIDENT=y
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
# CONFIG_FB_SM501 is not set
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=y
# CONFIG_FB_VIRTUAL is not set
CONFIG_XEN_FBDEV_FRONTEND=y
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
# CONFIG_FB_AUO_K1901 is not set
# CONFIG_FB_SIMPLE is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_L4F00242T03 is not set
CONFIG_LCD_LMS283GF05=y
# CONFIG_LCD_LTV350QV is not set
CONFIG_LCD_ILI922X=y
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=y
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=y
# CONFIG_LCD_S6E63M0 is not set
# CONFIG_LCD_LD9040 is not set
CONFIG_LCD_AMS369FG06=y
CONFIG_LCD_LMS501KF03=y
CONFIG_LCD_HX8357=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_CARILLO_RANCH=y
# CONFIG_BACKLIGHT_DA9052 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
# CONFIG_BACKLIGHT_WM831X is not set
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_88PM860X=y
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_AAT2870=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_PANDORA=y
CONFIG_BACKLIGHT_AS3711=y
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
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
CONFIG_HID_APPLEIR=y
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=y
CONFIG_HID_CP2112=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=y
CONFIG_HID_ELO=y
# CONFIG_HID_EZKEY is not set
CONFIG_HID_HOLTEK=y
CONFIG_HOLTEK_FF=y
CONFIG_HID_GT683R=y
CONFIG_HID_HUION=y
CONFIG_HID_KEYTOUCH=y
# CONFIG_HID_KYE is not set
CONFIG_HID_UCLOGIC=y
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO=y
# CONFIG_HID_LOGITECH is not set
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
# CONFIG_HID_MONTEREY is not set
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PENMOUNT=y
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_PRIMAX=y
CONFIG_HID_ROCCAT=y
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
# CONFIG_SONY_FF is not set
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_RMI=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
# CONFIG_HID_THRUSTMASTER is not set
CONFIG_HID_WACOM=y
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=y
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_OTG_FSM=y
# CONFIG_USB_MON is not set
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
# CONFIG_USB_OXU210HP_HCD is not set
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_FUSBH200_HCD=y
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_MAX3421_HCD=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
CONFIG_USB_OHCI_HCD_SSB=y
CONFIG_USB_OHCI_HCD_PLATFORM=y
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_WHCI_HCD=y
CONFIG_USB_HWA_HCD=y
CONFIG_USB_HCD_SSB=y
CONFIG_USB_HCD_TEST_MODE=y

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
# CONFIG_USB_STORAGE is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y
# CONFIG_USBIP_CORE is not set
CONFIG_USB_MUSB_HDRC=y
CONFIG_USB_MUSB_HOST=y
CONFIG_USB_MUSB_TUSB6010=y
# CONFIG_USB_MUSB_UX500 is not set
CONFIG_MUSB_PIO_ONLY=y
CONFIG_USB_DWC3=y
CONFIG_USB_DWC3_HOST=y

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_PCI=y

#
# Debugging features
#
CONFIG_USB_DWC3_DEBUG=y
# CONFIG_USB_DWC3_VERBOSE is not set
CONFIG_DWC3_HOST_USB3_LPM_ENABLE=y
# CONFIG_USB_DWC2 is not set
CONFIG_USB_CHIPIDEA=y
# CONFIG_USB_CHIPIDEA_HOST is not set
# CONFIG_USB_CHIPIDEA_DEBUG is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
CONFIG_USB_CYPRESS_CY7C63=y
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=y
CONFIG_USB_LD=y
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HSIC_USB3503 is not set
# CONFIG_USB_LINK_LAYER_TEST is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
# CONFIG_NOP_USB_XCEIV is not set
CONFIG_USB_GPIO_VBUS=y
CONFIG_USB_ISP1301=y
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
# CONFIG_UWB_I1480U is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
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
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DA9052=y
# CONFIG_LEDS_DAC124S085 is not set
CONFIG_LEDS_REGULATOR=y
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_ADP5520 is not set
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_MC13783=y
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_MENF21BMC=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=y

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
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_INTEL_IOATDMA=y
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
CONFIG_DW_DMAC_PCI=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
CONFIG_DMA_ENGINE_RAID=y
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set

#
# Xen driver support
#
# CONFIG_XEN_BALLOON is not set
# CONFIG_XEN_DEV_EVTCHN is not set
CONFIG_XEN_BACKEND=y
CONFIG_XENFS=y
CONFIG_XEN_COMPAT_XENFS=y
# CONFIG_XEN_SYS_HYPERVISOR is not set
CONFIG_XEN_XENBUS_FRONTEND=y
CONFIG_XEN_GNTDEV=y
CONFIG_XEN_GRANT_DEV_ALLOC=y
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_TMEM=y
CONFIG_XEN_PCIDEV_BACKEND=y
CONFIG_XEN_PRIVCMD=y
CONFIG_XEN_ACPI_PROCESSOR=y
CONFIG_XEN_HAVE_PVMMU=y
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ALIENWARE_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_DELL_SMO8800 is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_HP_WMI is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
CONFIG_ACPI_WMI=y
# CONFIG_MSI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_MXM_WMI=y
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# SOC (System On Chip) specific Drivers
#
# CONFIG_SOC_TI is not set

#
# Hardware Spinlock drivers
#

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_ATMEL_PIT is not set
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#

#
# SOC (System On Chip) specific Drivers
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
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
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
CONFIG_BMA180=y
CONFIG_BMC150_ACCEL=y
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
CONFIG_KXSD9=y
# CONFIG_MMA8452 is not set
# CONFIG_KXCJK1013 is not set

#
# Analog to digital converters
#
# CONFIG_AD7266 is not set
CONFIG_AD7291=y
CONFIG_AD7298=y
CONFIG_AD7476=y
# CONFIG_AD7791 is not set
# CONFIG_AD7793 is not set
# CONFIG_AD7887 is not set
# CONFIG_AD7923 is not set
# CONFIG_AD799X is not set
# CONFIG_MAX1027 is not set
# CONFIG_MAX1363 is not set
CONFIG_MCP320X=y
CONFIG_MCP3422=y
CONFIG_MEN_Z188_ADC=y
CONFIG_NAU7802=y
CONFIG_TI_ADC081C=y
# CONFIG_TI_ADC128S052 is not set
# CONFIG_TI_AM335X_ADC is not set
CONFIG_TWL4030_MADC=y
CONFIG_TWL6030_GPADC=y

#
# Amplifiers
#
# CONFIG_AD8366 is not set

#
# Hid Sensor IIO Common
#
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_SPI=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
CONFIG_AD5360=y
# CONFIG_AD5380 is not set
CONFIG_AD5421=y
CONFIG_AD5446=y
# CONFIG_AD5449 is not set
# CONFIG_AD5504 is not set
CONFIG_AD5624R_SPI=y
# CONFIG_AD5686 is not set
CONFIG_AD5755=y
CONFIG_AD5764=y
# CONFIG_AD5791 is not set
CONFIG_AD7303=y
# CONFIG_MAX517 is not set
CONFIG_MCP4725=y
# CONFIG_MCP4922 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
CONFIG_AD9523=y

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=y

#
# Digital gyroscope sensors
#
# CONFIG_ADIS16080 is not set
CONFIG_ADIS16130=y
# CONFIG_ADIS16136 is not set
CONFIG_ADIS16260=y
# CONFIG_ADXRS450 is not set
CONFIG_BMG160=y
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_IIO_ST_GYRO_SPI_3AXIS=y
# CONFIG_ITG3200 is not set

#
# Humidity sensors
#
CONFIG_DHT11=y
# CONFIG_SI7005 is not set

#
# Inertial measurement units
#
CONFIG_ADIS16400=y
CONFIG_ADIS16480=y
CONFIG_INV_MPU6050_IIO=y
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
CONFIG_AL3320A=y
# CONFIG_APDS9300 is not set
CONFIG_CM32181=y
CONFIG_CM36651=y
CONFIG_GP2AP020A00F=y
# CONFIG_ISL29125 is not set
CONFIG_SENSORS_LM3533=y
CONFIG_LTR501=y
CONFIG_TCS3414=y
# CONFIG_TCS3472 is not set
CONFIG_SENSORS_TSL2563=y
# CONFIG_TSL4531 is not set
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
CONFIG_AK09911=y
# CONFIG_MAG3110 is not set
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
CONFIG_IIO_ST_MAGN_SPI_3AXIS=y

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
CONFIG_MPL115=y
CONFIG_MPL3115=y
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y
CONFIG_IIO_ST_PRESS_SPI=y
CONFIG_T5403=y

#
# Lightning sensors
#
# CONFIG_AS3935 is not set

#
# Temperature sensors
#
CONFIG_MLX90614=y
CONFIG_TMP006=y
CONFIG_NTB=y
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
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_POWERCAP=y
# CONFIG_INTEL_RAPL is not set
CONFIG_MCB=y
CONFIG_MCB_PCI=y
CONFIG_RAS=y
# CONFIG_THUNDERBOLT is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4_FS is not set
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=y
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
CONFIG_BTRFS_DEBUG=y
CONFIG_BTRFS_ASSERT=y
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
# CONFIG_FSNOTIFY is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y
CONFIG_OVERLAYFS_FS=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
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
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
CONFIG_ADFS_FS_RW=y
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
CONFIG_HFSPLUS_FS_POSIX_ACL=y
# CONFIG_BEFS_FS is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_JFFS2_FS_WRITEBUFFER is not set
# CONFIG_JFFS2_SUMMARY is not set
# CONFIG_JFFS2_FS_XATTR is not set
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
CONFIG_UBIFS_FS=y
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
CONFIG_SQUASHFS_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
# CONFIG_SQUASHFS_XATTR is not set
# CONFIG_SQUASHFS_ZLIB is not set
CONFIG_SQUASHFS_LZO=y
# CONFIG_SQUASHFS_XZ is not set
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
# CONFIG_QNX4FS_FS is not set
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_RAM=y
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=y
CONFIG_UFS_FS_WRITE=y
CONFIG_UFS_DEBUG=y
# CONFIG_EXOFS_FS is not set
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
# CONFIG_F2FS_FS_XATTR is not set
# CONFIG_F2FS_CHECK_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
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
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
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
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
# CONFIG_SCHED_STACK_END_CHECK is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_PI_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_TORTURE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
# CONFIG_FAULT_INJECTION is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_TEST_RHASHTABLE is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_FIRMWARE=y
CONFIG_TEST_UDELAY=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_STRESS is not set
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
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
CONFIG_BIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
# CONFIG_IMA is not set
# CONFIG_EVM is not set
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
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_MCRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
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
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA1_MB=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_DES3_EDE_X86_64=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
# CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

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
# CONFIG_CRYPTO_DRBG_MENU is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
# CONFIG_CRYPTO_DEV_CCP is not set
CONFIG_CRYPTO_DEV_QAT=y
CONFIG_CRYPTO_DEV_QAT_DH895xCC=y
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_PKCS7_MESSAGE_PARSER=y
# CONFIG_PKCS7_TEST_KEY is not set
# CONFIG_SIGNED_PE_FILE_VERIFICATION is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_BINARY_PRINTF is not set

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
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
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
CONFIG_CRC8=y
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
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
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_INTERVAL_TREE=y
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
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_OID_REGISTRY=y
CONFIG_ARCH_HAS_SG_CHAIN=y

--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--T4sUOijqQbZv57TR--
