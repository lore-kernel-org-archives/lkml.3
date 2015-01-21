Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbbAUABj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 19:01:39 -0500
Received: from gir.skynet.ie ([193.1.99.77]:52421 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbbAUABh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 19:01:37 -0500
Date: Wed, 21 Jan 2015 00:01:35 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
cc: linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1501202347050.13523@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-500988603-1421798495=:13523"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-500988603-1421798495=:13523
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Just back from LCA + some days off, had some fixes from the past 2 weeks,

some amdkfd code removal for a feature that wasn't ready,
otherwise just one fix for core helper sleeping,
exynos, i915, and radeon fixes.

I thought I had some sti fixes but they were already in, and it confused
me for a few mins this morning,

Dave.

The following changes since commit ec6f34e5b552fb0a52e6aae1a5afbbb1605cc6cc:

  Linux 3.19-rc5 (2015-01-18 18:02:20 +1200)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 67cf2d391292f8bf0598236e7b4ec343eae6234f:

  Merge tag 'drm-amdkfd-fixes-2015-01-13' of git://people.freedesktop.org/~gabbayo/linux into drm-fixes (2015-01-21 09:26:47 +1000)

----------------------------------------------------------------

Alex Deucher (6):
      drm/radeon: fix VM flush on cayman/aruba (v3)
      drm/radeon: fix VM flush on SI (v3)
      drm/radeon: fix VM flush on CIK (v3)
      drm/radeon: add a dpm quirk list
      drm/radeon: add si dpm quirk list
      drm/radeon: use rv515_ring_start on r5xx

Chris Wilson (2):
      drm/i915: Ban Haswell from using RCS flips
      drm/i915: Fix mutex->owner inspection race under DEBUG_MUTEXES

Christian König (1):
      drm/radeon: don't print error on -ERESTARTSYS

Dave Airlie (4):
      Merge branch 'drm-fixes-3.19' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
      Merge branch 'exynos-drm-fixes' of git://git.kernel.org/.../daeinki/drm-exynos into drm-fixes
      Merge tag 'drm-intel-fixes-2015-01-15' of git://anongit.freedesktop.org/drm-intel into drm-fixes
      Merge tag 'drm-amdkfd-fixes-2015-01-13' of git://people.freedesktop.org/~gabbayo/linux into drm-fixes

Hyungwon Hwang (1):
      drm/exynos: remove the redundant machine checking code

Imre Deak (3):
      drm/i915: gen9: fix RPS interrupt routing to CPU vs. GT
      drm/i915: fix HW lockup due to missing RPS IRQ workaround on GEN6
      drm/i915: vlv: sanitize RPS interrupt mask during GPU idling

Joonyoung Shim (3):
      drm/exynos: fix reset codes for memory mapped hdmi phy
      drm/exynos: remove unnecessary runtime pm operations
      drm/exynos: fix warning of vblank reference count

Michel Dänzer (1):
      drm/amdkfd: Drop interrupt SW ring buffer

Oded Gabbay (1):
      drm/amdkfd: Fix sparse warning (different address space)

Rui Wang (1):
      drm: fb helper should avoid sleeping in panic context

 drivers/gpu/drm/amd/amdkfd/Makefile                |   3 +-
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |  20 +--
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c         | 176 ---------------------
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |  15 --
 drivers/gpu/drm/drm_fb_helper.c                    |   8 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.c            |  12 --
 drivers/gpu/drm/exynos/exynos_hdmi.c               |   8 +-
 drivers/gpu/drm/exynos/exynos_mixer.c              |  11 +-
 drivers/gpu/drm/i915/i915_gem.c                    |   2 +-
 drivers/gpu/drm/i915/i915_irq.c                    |  20 ++-
 drivers/gpu/drm/i915/intel_display.c               |   2 +-
 drivers/gpu/drm/i915/intel_drv.h                   |   1 +
 drivers/gpu/drm/i915/intel_pm.c                    |  14 +-
 drivers/gpu/drm/radeon/cik.c                       |  11 ++
 drivers/gpu/drm/radeon/cik_sdma.c                  |  10 ++
 drivers/gpu/drm/radeon/ni.c                        |  10 ++
 drivers/gpu/drm/radeon/ni_dma.c                    |   6 +
 drivers/gpu/drm/radeon/nid.h                       |  24 +++
 drivers/gpu/drm/radeon/radeon_asic.c               |  18 ++-
 drivers/gpu/drm/radeon/radeon_gem.c                |   2 +-
 drivers/gpu/drm/radeon/radeon_pm.c                 |  33 ++++
 drivers/gpu/drm/radeon/si.c                        |  10 ++
 drivers/gpu/drm/radeon/si_dma.c                    |   8 +
 drivers/gpu/drm/radeon/si_dpm.c                    |  39 +++++
 drivers/gpu/drm/radeon/sid.h                       |  18 +++
 26 files changed, 227 insertions(+), 256 deletions(-)
 delete mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c
--29444707-500988603-1421798495=:13523--
