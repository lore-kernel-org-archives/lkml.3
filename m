Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaAWTGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:06:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbaAWTGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:06:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.12 00/27] 3.12.9-stable review
Date: Thu, 23 Jan 2014 11:06:37 -0800
Message-Id: <20140123190648.720195687@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.12.9 release.
There are 27 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Jan 25 19:06:36 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.9-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.12.9-rc1

Taras Kondratiuk <taras.kondratiuk@linaro.org>
    ARM: 7938/1: OMAP4/highbank: Flush L2 cache before disabling

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Don't grab crtc mutexes in intel_modeset_gem_init()

Sudeep Holla <sudeep.holla@arm.com>
    ARM: 7934/1: DT/kernel: fix arch_match_cpu_phys_id to avoid erroneous match

Jon Medhurst <tixy@linaro.org>
    serial: amba-pl011: use port lock to guard control register access

Geert Uytterhoeven <geert@linux-m68k.org>
    mm: Make {,set}page_address() static inline if WANT_PAGE_VIRTUAL

NeilBrown <neilb@suse.de>
    md/raid5: Fix possible confusion when multiple write errors occur.

NeilBrown <neilb@suse.de>
    md/raid10: fix two bugs in handling of known-bad-blocks.

NeilBrown <neilb@suse.de>
    md/raid10: fix bug when raid10 recovery fails to recover a block.

NeilBrown <neilb@suse.de>
    md: fix problem when adding device to read-only array with bitmap.

Paulo Zanoni <paulo.r.zanoni@intel.com>
    drm/i915: fix DDI PLLs HW state readout code

Andreas Rohner <andreas.rohner@gmx.net>
    nilfs2: fix segctor bug that causes file system corruption

Mikulas Patocka <mpatocka@redhat.com>
    mm: fix crash when using XFS on loopback

Qais Yousef <qais.yousef@imgtec.com>
    crash_dump: fix compilation error (on MIPS at least)

Steven Rostedt <rostedt@goodmis.org>
    ftrace/x86: Load ftrace_ops in parameter not the variable holding it

Hugh Dickins <hughd@google.com>
    thp: fix copy_page_rep GPF by testing is_huge_zero_pmd once only

Steven Rostedt <rostedt@goodmis.org>
    SELinux: Fix possible NULL pointer dereference in selinux_inode_permission()

Jan Kara <jack@suse.cz>
    writeback: Fix data corruption on NFS

Jean Delvare <khali@linux-fr.org>
    hwmon: (coretemp) Fix truncated name of alarm attributes

Stephen Warren <swarren@nvidia.com>
    i2c: Re-instate body of i2c_parent_is_i2c_adapter()

Eric W. Biederman <ebiederm@xmission.com>
    fork: Allow CLONE_PARENT after setns(CLONE_NEWPID)

Eric W. Biederman <ebiederm@xmission.com>
    vfs: Fix a regression in mounting proc

Eric W. Biederman <ebiederm@xmission.com>
    vfs: In d_path don't call d_dname on a mount point

H Hartley Sweeten <hsweeten@visionengravers.com>
    staging: comedi: adl_pci9111: fix incorrect irq passed to request_irq()

H Hartley Sweeten <hsweeten@visionengravers.com>
    staging: comedi: addi_apci_1032: fix subdevice type/flags bug

Bob Peterson <rpeterso@redhat.com>
    GFS2: Increase i_writecount during gfs2_setattr_chown

Robert Richter <rric@kernel.org>
    perf/x86/amd/ibs: Fix waking up from S3 for AMD family 10h

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Revert "ACPI: Add BayTrail SoC GPIO and LPSS ACPI IDs"


-------------

Diffstat:

 Makefile                                        |  4 +-
 arch/arm/kernel/devtree.c                       |  2 +-
 arch/arm/mach-highbank/highbank.c               |  1 +
 arch/arm/mach-omap2/omap4-common.c              |  1 +
 arch/x86/kernel/cpu/perf_event_amd_ibs.c        | 53 +++++++++++++++++++++----
 arch/x86/kernel/entry_32.S                      |  4 +-
 arch/x86/kernel/entry_64.S                      |  2 +-
 drivers/acpi/acpi_lpss.c                        |  1 -
 drivers/gpu/drm/i915/intel_ddi.c                |  8 +++-
 drivers/gpu/drm/i915/intel_display.c            |  4 +-
 drivers/hwmon/coretemp.c                        |  2 +-
 drivers/md/md.c                                 | 18 +++++++--
 drivers/md/md.h                                 |  3 ++
 drivers/md/raid10.c                             | 12 +++---
 drivers/md/raid5.c                              |  4 +-
 drivers/pinctrl/pinctrl-baytrail.c              |  1 -
 drivers/staging/comedi/drivers/addi_apci_1032.c |  4 +-
 drivers/staging/comedi/drivers/adl_pci9111.c    |  2 +-
 drivers/tty/serial/amba-pl011.c                 |  6 +++
 fs/dcache.c                                     |  7 +++-
 fs/fs-writeback.c                               | 15 ++++---
 fs/gfs2/inode.c                                 | 16 +++++++-
 fs/namespace.c                                  |  2 +-
 fs/nilfs2/segment.c                             | 10 +++--
 include/linux/crash_dump.h                      |  2 +
 include/linux/i2c.h                             |  2 +-
 include/linux/mm.h                              | 13 +++---
 kernel/fork.c                                   |  2 +-
 mm/huge_memory.c                                |  6 +--
 mm/util.c                                       |  5 ++-
 security/selinux/hooks.c                        | 20 +++++++++-
 security/selinux/include/objsec.h               |  5 ++-
 32 files changed, 176 insertions(+), 61 deletions(-)


