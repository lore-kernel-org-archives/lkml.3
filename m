Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965242AbaGOXgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:36:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45209 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933982AbaGOXON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.15 00/84] 3.15.6-stable review
Date: Tue, 15 Jul 2014 16:16:57 -0700
Message-Id: <20140715231713.193785557@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.15.6 release.
There are 84 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Jul 17 23:17:00 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.15.6-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.15.6-rc1

Lan Tianyu <tianyu.lan@intel.com>
    ACPI / battery: Retry to get battery information if failed during probing

Roland Dreier <roland@purestorage.com>
    x86, ioremap: Speed up check for RAM pages

H. Peter Anvin <hpa@zytor.com>
    x86, espfix: Make it possible to disable 16-bit support

H. Peter Anvin <hpa@zytor.com>
    x86, espfix: Make espfix64 a Kconfig option, fix UML

H. Peter Anvin <hpa@linux.intel.com>
    x86, espfix: Fix broken header guard

H. Peter Anvin <hpa@linux.intel.com>
    x86, espfix: Move espfix definitions into a separate header file

H. Peter Anvin <hpa@linux.intel.com>
    x86-64, espfix: Don't leak bits 31:16 of %esp returning to 16-bit stack

H. Peter Anvin <hpa@zytor.com>
    Revert "x86-64, modify_ldt: Make support for 16-bit segments a runtime option"

Guenter Roeck <linux@roeck-us.net>
    powerpc: Disable RELOCATABLE for COMPILE_TEST with PPC64

Chen Gang <gang.chen.5i5j@gmail.com>
    drivers/rtc/rtc-puv3.c: use dev_dbg() instead of dev_debug() for typo issue

Chen Gang <gang.chen.5i5j@gmail.com>
    drivers/rtc/rtc-puv3.c: remove "&dev->" for typo issue

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: check bdi->dirty_exceeded when trying to skip data writes

Jaegeuk Kim <jaegeuk.kim@samsung.com>
    f2fs: adjust free mem size to flush dentry blocks

Li Zefan <lizefan@huawei.com>
    cgroup: fix a race between cgroup_mount() and cgroup_kill_sb()

Li Zefan <lizefan@huawei.com>
    kernfs: introduce kernfs_pin_sb()

Tejun Heo <tj@kernel.org>
    kernfs: implement kernfs_root->supers list

Li Zefan <lizefan@huawei.com>
    cgroup: fix mount failure in a corner case

Ted Juan <ted.juan@gmail.com>
    mtd: nand: omap: fix omap_calculate_ecc_bch() for-loop error

Jean Sacren <sakiwit@gmail.com>
    i40e: fix passing wrong error code to i40e_open()

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ring-buffer: Check if buffer exists before polling

Joonsoo Kim <iamjoonsoo.kim@lge.com>
    DMA, CMA: fix possible memory leak

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Don't clobber the GTT when it's within stolen memory

Scot Doyle <lkml14@scotdoyle.com>
    drm/i915: Toshiba CB35 has a controllable backlight

Scot Doyle <lkml14@scotdoyle.com>
    drm/i915: Acer C720 and C720P have controllable backlights

Scot Doyle <lkml14@scotdoyle.com>
    drm/i915: quirk asserts controllable backlight presence, overriding VBT

Christian König <christian.koenig@amd.com>
    drm/radeon: stop poisoning the GART TLB

Christian König <christian.koenig@amd.com>
    drm/radeon: page table BOs are kernel allocations

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix typo in golden register setup on evergreen

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix typo in ci_stop_dpm()

Alexandre Demers <alexandre.f.demers@gmail.com>
    drm/radeon/dpm: Reenabling SS on Cayman

Theodore Ts'o <tytso@mit.edu>
    ext4: fix a potential deadlock in __ext4_es_shrink()

Theodore Ts'o <tytso@mit.edu>
    ext4: revert commit which was causing fs corruption after journal replays

Eric Sandeen <sandeen@redhat.com>
    ext4: disable synchronous transaction batching if max_batch_time==0

Theodore Ts'o <tytso@mit.edu>
    ext4: clarify ext4_error message in ext4_mb_generate_buddy_error()

Theodore Ts'o <tytso@mit.edu>
    ext4: clarify error count warning messages

Theodore Ts'o <tytso@mit.edu>
    ext4: fix unjournalled bg descriptor while initializing inode bitmap

Alex Williamson <alex.williamson@redhat.com>
    PCI: Fix unaligned access in AF transaction pending test

Vincent Minet <vincent@vincent-minet.net>
    intel_pstate: Set CPU number before accessing MSRs

Dirk Brandewie <dirk.j.brandewie@intel.com>
    intel_pstate: Update documentation of {max,min}_perf_pct sysfs files

Dirk Brandewie <dirk.j.brandewie@intel.com>
    intel_pstate: don't touch turbo bit if turbo disabled or unavailable.

Dirk Brandewie <dirk.j.brandewie@intel.com>
    intel_pstate: Fix setting VID

Mikulas Patocka <mpatocka@redhat.com>
    dm: allocate a special workqueue for deferred device removal

Joe Thornber <thornber@redhat.com>
    dm io: fix a race condition in the wake up code for sync_io

Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
    dm mpath: fix IO hang due to logic bug in multipath_busy

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: hv: vmbus: Fix a bug in the channel callback dispatch code

Stephen Boyd <sboyd@codeaurora.org>
    clk: qcom: HDMI source sel is 3 not 2

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    clk: s2mps11: Fix double free corruption during driver unbind

Thomas Gleixner <tglx@linutronix.de>
    clk: spear3xx: Use proper control register offset

Roger Quadros <rogerq@ti.com>
    phy: core: Fix error path in phy_create()

Colin Cross <ccross@android.com>
    arm64: implement TASK_SIZE_OF

Cristian Stoica <cristian.stoica@freescale.com>
    crypto: caam - fix memleak in caam_jr module

Jussi Kivilinna <jussi.kivilinna@iki.fi>
    crypto: sha512_ssse3 - fix byte count to bit count conversion

Prabhakar Lad <prabhakar.csengg@gmail.com>
    cpufreq: Makefile: fix compilation for davinci platform

Joel Stanley <joel@jms.id.au>
    powerpc/perf: Clear MMCR2 when enabling PMU

Joel Stanley <joel@jms.id.au>
    powerpc/perf: Add PPMU_ARCH_207S define

Anton Blanchard <anton@samba.org>
    powerpc/perf: Never program book3s PMCs with values >= 0x80000000

Joel Stanley <joel@jms.id.au>
    powerpc/kvm: Remove redundant save of SIER AND MMCR2

Lv Zheng <lv.zheng@intel.com>
    ACPI / EC: Fix race condition in ec_transaction_completed()

Lv Zheng <lv.zheng@intel.com>
    ACPI / EC: Remove duplicated ec_wait_ibf0() waiter

Lv Zheng <lv.zheng@intel.com>
    ACPI / EC: Add asynchronous command byte write support

Lv Zheng <lv.zheng@intel.com>
    ACPI / EC: Avoid race condition related to advance_transaction()

Andy Whitcroft <apw@canonical.com>
    ACPI / resources: only reject zero length resources based at address zero

Lan Tianyu <tianyu.lan@intel.com>
    Revert "ACPI / AC: Remove AC's proc directory."

Axel Lin <axel.lin@ingics.com>
    hwmon: (adm1021) Fix cache problem when writing temperature limits

Axel Lin <axel.lin@ingics.com>
    hwmon: (adm1029) Ensure the fan_div cache is updated in set_fan_div

Guenter Roeck <linux@roeck-us.net>
    hwmon: (adm1031) Fix writes to limit registers

Guenter Roeck <linux@roeck-us.net>
    hwmon: (emc2103) Clamp limits instead of bailing out

Axel Lin <axel.lin@ingics.com>
    hwmon: (amc6821) Fix permissions for temp2_input

Guenter Roeck <linux@roeck-us.net>
    hwmon: (adc128d818) Drop write support on inX_input attributes

Aaron Lu <aaron.lu@intel.com>
    thermal: hwmon: Make the check for critical temp valid consistent

Peter Hurley <peter@hurleysoftware.com>
    serial: imx: Fix build breakage

Guenter Roeck <linux@roeck-us.net>
    i8k: Fix non-SMP operation

Shawn Guo <shawn.guo@freescale.com>
    ahci: imx: manage only sata_ref_clk in imx_sata_enable[disable]

Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
    workqueue: zero cpumask of wq_numa_possible_cpumask on init

Gu Zheng <guz.fnst@cn.fujitsu.com>
    cpuset,mempolicy: fix sleeping function called from invalid context

Maxime Bizon <mbizon@freebox.fr>
    workqueue: fix dev_set_uevent_suppress() imbalance

Helge Deller <deller@gmx.de>
    parisc: fix fanotify_mark() syscall on 32bit compat kernel

Helge Deller <deller@gmx.de>
    parisc: add serial ports of C8000/1GHz machine to hardware database

Peter Hurley <peter@hurleysoftware.com>
    serial: Test for no tx data on tx restart

Jan Kardell <jan.kardell@telliq.com>
    iio: ti_am335x_adc: Fix: Use same step id at FIFOs both ends

Michal Sojka <sojkam1@fel.cvut.cz>
    USB: serial: ftdi_sio: Add Infineon Triboard

Bert Vermeulen <bert@biot.com>
    USB: ftdi_sio: Add extra PID.

Andras Kovacs <andras@sth.sze.hu>
    USB: cp210x: add support for Corsair usb dongle

Bernd Wachter <bernd.wachter@jolla.com>
    usb: option: Add ID for Telewell TW-LTE 4G v2


-------------

Diffstat:

 Documentation/cpu-freq/intel-pstate.txt      |   7 +-
 Documentation/x86/x86_64/mm.txt              |   2 +
 Makefile                                     |   4 +-
 arch/arm64/include/asm/memory.h              |   2 +
 arch/parisc/kernel/hardware.c                |   3 +-
 arch/parisc/kernel/sys_parisc32.c            |  10 ++
 arch/parisc/kernel/syscall_table.S           |   2 +-
 arch/powerpc/Kconfig                         |   3 +-
 arch/powerpc/include/asm/perf_event_server.h |   3 +-
 arch/powerpc/kvm/book3s_hv_interrupts.S      |   5 -
 arch/powerpc/perf/core-book3s.c              |  26 +++-
 arch/powerpc/perf/power8-pmu.c               |   2 +-
 arch/x86/Kconfig                             |  25 +++-
 arch/x86/crypto/sha512_ssse3_glue.c          |   2 +-
 arch/x86/include/asm/espfix.h                |  16 ++
 arch/x86/include/asm/pgtable_64_types.h      |   2 +
 arch/x86/include/asm/setup.h                 |   2 +
 arch/x86/kernel/Makefile                     |   1 +
 arch/x86/kernel/entry_32.S                   |  12 ++
 arch/x86/kernel/entry_64.S                   |  81 ++++++++++-
 arch/x86/kernel/espfix_64.c                  | 209 +++++++++++++++++++++++++++
 arch/x86/kernel/ldt.c                        |  10 +-
 arch/x86/kernel/smpboot.c                    |   7 +
 arch/x86/mm/dump_pagetables.c                |  44 ++++--
 arch/x86/mm/ioremap.c                        |  26 +++-
 arch/x86/vdso/vdso32-setup.c                 |   8 -
 drivers/acpi/ac.c                            | 130 ++++++++++++++++-
 drivers/acpi/battery.c                       |  27 +++-
 drivers/acpi/ec.c                            | 128 ++++++++--------
 drivers/acpi/resource.c                      |  10 +-
 drivers/ata/ahci_imx.c                       |  35 ++++-
 drivers/base/dma-contiguous.c                |  12 +-
 drivers/char/i8k.c                           |   4 +-
 drivers/clk/clk-s2mps11.c                    |   7 +-
 drivers/clk/qcom/mmcc-msm8960.c              |   2 +-
 drivers/clk/spear/spear3xx_clock.c           |   2 +-
 drivers/cpufreq/Makefile                     |   2 +-
 drivers/cpufreq/intel_pstate.c               |  35 +++--
 drivers/crypto/caam/jr.c                     |   8 +-
 drivers/gpu/drm/i915/i915_drv.h              |   1 +
 drivers/gpu/drm/i915/i915_gem_stolen.c       |  44 ++++++
 drivers/gpu/drm/i915/i915_reg.h              |   3 +
 drivers/gpu/drm/i915/intel_display.c         |  14 ++
 drivers/gpu/drm/i915/intel_panel.c           |   8 +-
 drivers/gpu/drm/radeon/ci_dpm.c              |   2 +-
 drivers/gpu/drm/radeon/evergreen.c           |   8 +-
 drivers/gpu/drm/radeon/radeon_vm.c           |   4 +-
 drivers/gpu/drm/radeon/rs600.c               |   6 +-
 drivers/gpu/drm/radeon/rv770_dpm.c           |   6 -
 drivers/hv/connection.c                      |   8 +-
 drivers/hwmon/adc128d818.c                   |  28 ++--
 drivers/hwmon/adm1021.c                      |  14 +-
 drivers/hwmon/adm1029.c                      |   3 +
 drivers/hwmon/adm1031.c                      |   8 +-
 drivers/hwmon/amc6821.c                      |   2 +-
 drivers/hwmon/emc2103.c                      |  15 +-
 drivers/iio/adc/ti_am335x_adc.c              |   2 +-
 drivers/md/dm-io.c                           |  22 +--
 drivers/md/dm-mpath.c                        |   5 +-
 drivers/md/dm.c                              |  15 +-
 drivers/mtd/nand/omap2.c                     |  10 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c  |   2 +-
 drivers/pci/pci.c                            |   9 +-
 drivers/phy/phy-core.c                       |   7 +-
 drivers/rtc/rtc-puv3.c                       |   4 +-
 drivers/thermal/thermal_hwmon.c              |  33 +++--
 drivers/tty/serial/imx.c                     |   3 +
 drivers/tty/serial/ip22zilog.c               |   2 +
 drivers/tty/serial/m32r_sio.c                |   8 +-
 drivers/tty/serial/pmac_zilog.c              |   3 +
 drivers/tty/serial/sunsab.c                  |   3 +
 drivers/tty/serial/sunzilog.c                |   2 +
 drivers/usb/serial/cp210x.c                  |   1 +
 drivers/usb/serial/ftdi_sio.c                |   5 +-
 drivers/usb/serial/ftdi_sio_ids.h            |   9 +-
 drivers/usb/serial/option.c                  |   2 +
 fs/ext4/extents_status.c                     |   4 +-
 fs/ext4/ialloc.c                             |  14 +-
 fs/ext4/mballoc.c                            |   4 +-
 fs/ext4/super.c                              |  60 ++++----
 fs/f2fs/data.c                               |   3 +-
 fs/f2fs/f2fs.h                               |   1 +
 fs/f2fs/node.c                               |  46 +++---
 fs/f2fs/node.h                               |   5 +-
 fs/jbd2/transaction.c                        |   5 +-
 fs/kernfs/dir.c                              |   1 +
 fs/kernfs/kernfs-internal.h                  |   5 +
 fs/kernfs/mount.c                            |  41 ++++++
 include/linux/kernfs.h                       |   5 +
 include/linux/ring_buffer.h                  |   2 +-
 init/main.c                                  |   4 +
 kernel/cgroup.c                              |  53 ++++++-
 kernel/cpuset.c                              |   8 +-
 kernel/trace/ring_buffer.c                   |   5 +-
 kernel/trace/trace.c                         |  25 +++-
 kernel/trace/trace.h                         |   4 +-
 kernel/workqueue.c                           |   3 +-
 mm/mempolicy.c                               |   2 -
 98 files changed, 1180 insertions(+), 357 deletions(-)


