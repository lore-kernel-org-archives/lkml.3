Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175AbaAWSrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:47:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34669 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbaAWSjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:39:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/23] 3.10.28-stable review
Date: Thu, 23 Jan 2014 10:39:33 -0800
Message-Id: <20140123183859.635713053@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.28 release.
There are 23 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Jan 25 18:38:43 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.28-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.28-rc1

Taras Kondratiuk <taras.kondratiuk@linaro.org>
    ARM: 7938/1: OMAP4/highbank: Flush L2 cache before disabling

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Don't grab crtc mutexes in intel_modeset_gem_init()

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

Hugh Dickins <hughd@google.com>
    thp: fix copy_page_rep GPF by testing is_huge_zero_pmd once only

Steven Rostedt <rostedt@goodmis.org>
    ftrace/x86: Load ftrace_ops in parameter not the variable holding it

Steven Rostedt <rostedt@goodmis.org>
    SELinux: Fix possible NULL pointer dereference in selinux_inode_permission()

Jan Kara <jack@suse.cz>
    writeback: Fix data corruption on NFS

Jean Delvare <khali@linux-fr.org>
    hwmon: (coretemp) Fix truncated name of alarm attributes

Eric W. Biederman <ebiederm@xmission.com>
    vfs: In d_path don't call d_dname on a mount point

H Hartley Sweeten <hsweeten@visionengravers.com>
    staging: comedi: adl_pci9111: fix incorrect irq passed to request_irq()

H Hartley Sweeten <hsweeten@visionengravers.com>
    staging: comedi: addi_apci_1032: fix subdevice type/flags bug

Jianguo Wu <wujianguo@huawei.com>
    mm/memory-failure.c: recheck PageHuge() after hugetlb page migrate successfully

Bob Peterson <rpeterso@redhat.com>
    GFS2: Increase i_writecount during gfs2_setattr_chown

Robert Richter <rric@kernel.org>
    perf/x86/amd/ibs: Fix waking up from S3 for AMD family 10h

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf scripting perl: Fix build error on Fedora 12

Vijaya Kumar K <vijay.kilari@gmail.com>
    ARM: 7815/1: kexec: offline non panic CPUs on Kdump panic


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/kernel/machine_kexec.c                    |  1 +
 arch/arm/mach-highbank/highbank.c                  |  1 +
 arch/arm/mach-omap2/omap4-common.c                 |  1 +
 arch/x86/kernel/cpu/perf_event_amd_ibs.c           | 53 ++++++++++++++++++----
 arch/x86/kernel/entry_32.S                         |  4 +-
 arch/x86/kernel/entry_64.S                         |  2 +-
 drivers/gpu/drm/i915/intel_ddi.c                   |  8 +++-
 drivers/gpu/drm/i915/intel_display.c               |  4 +-
 drivers/hwmon/coretemp.c                           |  2 +-
 drivers/md/md.c                                    | 18 ++++++--
 drivers/md/md.h                                    |  3 ++
 drivers/md/raid10.c                                | 12 ++---
 drivers/md/raid5.c                                 |  4 +-
 drivers/staging/comedi/drivers/addi_apci_1032.c    |  4 +-
 drivers/staging/comedi/drivers/adl_pci9111.c       |  2 +-
 drivers/tty/serial/amba-pl011.c                    |  6 +++
 fs/dcache.c                                        |  7 ++-
 fs/fs-writeback.c                                  | 15 +++---
 fs/gfs2/inode.c                                    | 16 ++++++-
 fs/nilfs2/segment.c                                | 10 ++--
 include/linux/mm.h                                 | 13 ++++--
 mm/huge_memory.c                                   |  6 +--
 mm/memory-failure.c                                | 14 ++++--
 security/selinux/hooks.c                           | 20 +++++++-
 security/selinux/include/objsec.h                  |  5 +-
 .../perf/util/scripting-engines/trace-event-perl.c |  2 +-
 27 files changed, 178 insertions(+), 59 deletions(-)


