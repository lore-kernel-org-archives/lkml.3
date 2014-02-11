Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbaBKTLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:11:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40661 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbaBKTIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:08:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.4 00/30] 3.4.80-stable review
Date: Tue, 11 Feb 2014 11:06:00 -0800
Message-Id: <20140211184647.149512538@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.80 release.
There are 30 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Feb 13 18:46:37 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.80-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.80-rc1

Colin Cross <ccross@android.com>
    3.4.y: timekeeping: fix 32-bit overflow in get_monotonic_boottime

John Stultz <john.stultz@linaro.org>
    timekeeping: Avoid possible deadlock from clock_was_set_delayed

Borislav Petkov <bp@alien8.de>
    rtc-cmos: Add an alarm disable quirk

Ying Xue <ying.xue@windriver.com>
    sched/rt: Avoid updating RT entry timeout twice within one tick period

Peter Boonstoppel <pboonstoppel@nvidia.com>
    sched: Unthrottle rt runqueues in __disable_runtime()

Mike Galbraith <efault@gmx.de>
    sched,rt: fix isolated CPUs leaving root_task_group indefinitely throttled

Colin Cross <ccross@android.com>
    sched/rt: Fix SCHED_RR across cgroups

Al Viro <viro@zeniv.linux.org.uk>
    hpfs: deadlock and race in directory lseek()

Yijing Wang <wangyijing@huawei.com>
    PCI: Enable ARI if dev and upstream bridge support it; disable otherwise

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/DCE4+: clear bios scratch dpms bit (v2)

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: set the full cache bit for fences on r7xx+

Marek Olšák <marek.olsak@amd.com>
    drm/radeon: skip colorbuffer checking if COLOR_INFO.FORMAT is set to INVALID

Michel Dänzer <michel.daenzer@amd.com>
    radeon/pm: Guard access to rdev->pm.power_state array

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: warn users when hw_i2c is enabled (v2)

Joe Thornber <ejt@redhat.com>
    dm space map common: make sure new space is used during extend

Mikulas Patocka <mpatocka@redhat.com>
    dm: wait until embedded kobject is released before destroying a device

Weston Andros Adamson <dros@netapp.com>
    sunrpc: Fix infinite loop in RPC state machine

Weston Andros Adamson <dros@primarydata.com>
    nfs4.1: properly handle ENOTSUP in SECINFO_NO_NAME

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4: OPEN must handle the NFS4ERR_IO return code correctly

Daniel Santos <daniel.santos@pobox.com>
    spidev: fix hang when transfer_one_message fails

Ira Weiny <ira.weiny@intel.com>
    IB/qib: Fix QP check when looping back to/from QP1

Boaz Harrosh <bharrosh@panasas.com>
    ore: Fix wrong math in allocation of per device BIO

Michael Grzeschik <m.grzeschik@pengutronix.de>
    mtd: mxc_nand: remove duplicated ecc_stats counting

Mark Brown <broonie@linaro.org>
    ACPI / init: Flag use of ACPI and ACPI idioms for power supplies to regulator API

Josh Triplett <josh@joshtriplett.org>
    turbostat: Use GCC's CPUID functions to support PIC

Li Zefan <lizefan@huawei.com>
    slub: Fix calculation of cpu slabs

Ludovic Desroches <ludovic.desroches@atmel.com>
    mmc: atmel-mci: fix timeout errors in SDIO mode when using DMA

AKASHI Takahiro <takahiro.akashi@linaro.org>
    audit: correct a type mismatch in audit_syscall_exit()

Alex Williamson <alex.williamson@redhat.com>
    intel-iommu: fix off-by-one in pagetable freeing

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    SELinux: Fix memory leak upon loading policy


-------------

Diffstat:

 Makefile                                         |  4 +-
 drivers/acpi/bus.c                               |  9 ++++
 drivers/gpu/drm/radeon/evergreen_cs.c            |  5 ++-
 drivers/gpu/drm/radeon/r600.c                    | 13 +++---
 drivers/gpu/drm/radeon/r600_cs.c                 |  5 ++-
 drivers/gpu/drm/radeon/r600d.h                   |  1 +
 drivers/gpu/drm/radeon/radeon_atombios.c         |  4 ++
 drivers/gpu/drm/radeon/radeon_i2c.c              |  3 ++
 drivers/gpu/drm/radeon/radeon_pm.c               |  6 ++-
 drivers/infiniband/hw/qib/qib_ud.c               |  9 +++-
 drivers/iommu/intel-iommu.c                      |  2 +-
 drivers/md/dm-sysfs.c                            | 10 ++++-
 drivers/md/dm.c                                  | 11 +++++
 drivers/md/dm.h                                  |  2 +
 drivers/md/persistent-data/dm-space-map-common.c |  6 ++-
 drivers/mmc/host/atmel-mci.c                     | 13 +++++-
 drivers/mtd/nand/mxc_nand.c                      |  1 -
 drivers/pci/pci.c                                | 14 +++----
 drivers/rtc/rtc-cmos.c                           | 52 +++++++++++++++++++++++-
 drivers/spi/spi.c                                |  4 +-
 fs/exofs/ore.c                                   | 37 +++++++++++------
 fs/hpfs/dir.c                                    | 10 +++--
 fs/nfs/nfs4proc.c                                |  4 +-
 fs/nfs/nfs4xdr.c                                 | 47 +++++++++++++--------
 include/linux/audit.h                            |  2 +-
 include/linux/sched.h                            |  1 +
 include/scsi/osd_ore.h                           |  1 +
 kernel/sched/core.c                              |  3 --
 kernel/sched/fair.c                              |  7 +++-
 kernel/sched/rt.c                                | 35 +++++++++++++---
 kernel/sched/sched.h                             |  1 -
 kernel/time/timekeeping.c                        | 14 ++++---
 mm/slub.c                                        |  8 +++-
 net/sunrpc/clnt.c                                |  8 +++-
 security/selinux/ss/policydb.c                   | 14 ++++++-
 tools/power/x86/turbostat/turbostat.c            | 11 ++---
 36 files changed, 289 insertions(+), 88 deletions(-)


