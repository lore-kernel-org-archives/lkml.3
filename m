Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933561Ab3FRQkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:40:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49231 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab3FRQOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:14:31 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/26] 3.4.50-stable review
Date: Tue, 18 Jun 2013 09:14:40 -0700
Message-Id: <20130618161231.154881788@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This is the start of the stable review cycle for the 3.4.50 release.
There are 26 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Jun 20 16:10:38 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.50-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.50-rc1

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    powerpc: Fix missing/delayed calls to irq_work

Michael Ellerman <michael@ellerman.id.au>
    powerpc: Fix stack overflow crash in resume_kernel when ftracing

Sage Weil <sage@inktank.com>
    ceph: fix statvfs fr_size

Sage Weil <sage@inktank.com>
    libceph: wrap auth methods in a mutex

Sage Weil <sage@inktank.com>
    libceph: wrap auth ops in wrapper functions

Sage Weil <sage@inktank.com>
    libceph: add update_authorizer auth method

Sage Weil <sage@inktank.com>
    libceph: fix authorizer invalidation

Sage Weil <sage@inktank.com>
    libceph: clear messenger auth_retry flag when we authenticate

Kees Cook <keescook@chromium.org>
    x86: Fix typo in kexec register clearing

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    mm: migration: add migrate_entry_wait_huge()

Alex Lyakas <alex@zadarastorage.com>
    md/raid1: consider WRITE as successful only if at least one non-Faulty and non-rebuilding drive completed it.

Rafael Aquini <aquini@redhat.com>
    swap: avoid read_swap_cache_async() race to deadlock while waiting on discard I/O completion

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: prefer VBT modes for SVDO-LVDS over EDID

Stephen M. Cameron <scameron@beardog.cce.hp.com>
    cciss: fix broken mutex usage in ioctl

Robin Holt <holt@sgi.com>
    reboot: rigrate shutdown/reboot to boot cpu

Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
    CPU hotplug: provide a generic helper to disable/enable CPU hotplug

Sujith Manoharan <c_manoha@qca.qualcomm.com>
    ath9k: Use minstrel rate control by default

Sujith Manoharan <c_manoha@qca.qualcomm.com>
    ath9k: Disable PowerSave by default

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix mgmt handling of power on failures

Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
    drm/gma500/cdv: Unpin framebuffer on crtc disable

Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
    drm/gma500/psb: Unpin framebuffer on crtc disable

Tony Lindgren <tony@atomide.com>
    drivers/rtc/rtc-twl.c: fix missing device_init_wakeup() when booted with device tree

Jim Schutt <jaschut@sandia.gov>
    ceph: ceph_pagelist_append might sleep while atomic

Jim Schutt <jaschut@sandia.gov>
    ceph: add cpu_to_le32() calls when encoding a reconnect capability

Alex Elder <elder@inktank.com>
    libceph: must hold mutex for reset_changed_osds()

Kees Cook <keescook@chromium.org>
    b43: stop format string leaking into error msgs


-------------

Diffstat:

 Makefile                                   |   4 +-
 arch/powerpc/include/asm/exception-64s.h   |   2 +-
 arch/powerpc/kernel/irq.c                  |   2 +-
 arch/powerpc/kernel/process.c              |   4 +-
 arch/x86/kernel/relocate_kernel_64.S       |   2 +-
 drivers/block/cciss.c                      |  32 ++++----
 drivers/gpu/drm/gma500/cdv_intel_display.c |  14 ++++
 drivers/gpu/drm/gma500/psb_intel_display.c |  14 ++++
 drivers/gpu/drm/i915/intel_sdvo.c          |  10 ++-
 drivers/md/raid1.c                         |  12 ++-
 drivers/md/raid10.c                        |  12 ++-
 drivers/net/wireless/ath/ath9k/Kconfig     |  10 ++-
 drivers/net/wireless/ath/ath9k/Makefile    |   2 +-
 drivers/net/wireless/ath/ath9k/init.c      |   7 +-
 drivers/net/wireless/ath/ath9k/rc.h        |   2 +-
 drivers/net/wireless/b43/main.c            |   2 +-
 drivers/rtc/rtc-twl.c                      |   1 +
 fs/ceph/locks.c                            |  73 +++++++++++-------
 fs/ceph/mds_client.c                       |  90 ++++++++++++----------
 fs/ceph/super.c                            |   7 +-
 fs/ceph/super.h                            |  11 ++-
 include/linux/ceph/auth.h                  |  18 +++++
 include/linux/cpu.h                        |   4 +
 include/linux/swapops.h                    |   3 +
 include/net/bluetooth/hci_core.h           |   1 +
 include/net/bluetooth/mgmt.h               |   1 +
 kernel/cpu.c                               |  55 ++++++--------
 kernel/sys.c                               |  29 ++++++-
 mm/hugetlb.c                               |   2 +-
 mm/migrate.c                               |  23 ++++--
 mm/swap_state.c                            |  18 ++++-
 net/bluetooth/hci_core.c                   |   6 +-
 net/bluetooth/mgmt.c                       |  21 ++++++
 net/ceph/auth.c                            | 117 ++++++++++++++++++++++++-----
 net/ceph/auth_x.c                          |  24 +++++-
 net/ceph/auth_x.h                          |   1 +
 net/ceph/messenger.c                       |   3 +-
 net/ceph/mon_client.c                      |   7 +-
 net/ceph/osd_client.c                      |  29 ++++---
 39 files changed, 479 insertions(+), 196 deletions(-)


