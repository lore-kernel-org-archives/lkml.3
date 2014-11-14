Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935387AbaKNXYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 18:24:32 -0500
Received: from gir.skynet.ie ([193.1.99.77]:40195 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935316AbaKNXYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 18:24:31 -0500
Date: Fri, 14 Nov 2014 23:24:28 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1411142322510.8843@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

exynos infinite loop regressions fixed
i915: one regression
radeon: one race condition on monitor probing
noveau: two regressions
tegra: one vblank regression fix.

Dave.

The following changes since commit 03dca708521d30153fc5c7e2ff136f780a7372c9:

  Merge tag 'drm-intel-fixes-2014-11-07' of git://anongit.freedesktop.org/drm-intel into drm-fixes (2014-11-10 10:05:37 +1000)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to bcfef97398972de555e6e1dbf4dac33f0db38d52:

  Merge tag 'drm/tegra/for-3.18-rc5' of git://people.freedesktop.org/~tagr/linux into drm-fixes (2014-11-14 07:03:02 +1000)

----------------------------------------------------------------

Alexandre Courbot (1):
      drm/gk20a/fb: fix setting of large page size bit

Chris Wilson (1):
      drm/i915: Fix obj->map_and_fenceable across tiling changes

Dave Airlie (6):
      drm/radeon: add locking around atombios scratch space usage
      Merge branch 'exynos-drm-fixes' of git://git.kernel.org/.../daeinki/drm-exynos into drm-fixes
      Merge branch 'drm-fixes-3.18' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
      Merge tag 'drm-intel-fixes-2014-11-13' of git://anongit.freedesktop.org/drm-intel into drm-fixes
      Merge branch 'linux-3.18' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes
      Merge tag 'drm/tegra/for-3.18-rc5' of git://people.freedesktop.org/~tagr/linux into drm-fixes

Inki Dae (4):
      drm/exynos: resolve infinite loop issue on multi-platform
      drm/exynos: resolve infinite loop issue on non multi-platform
      drm/exynos: g2d: fix null pointer dereference
      drm/exynos: fix possible infinite loop issue

Roy Spliet (1):
      drm/nouveau/nv50/disp: Fix modeset on G94

Thierry Reding (1):
      drm/tegra: dc: Add missing call to drm_vblank_on()

 drivers/gpu/drm/exynos/exynos_drm_drv.c        | 49 +++++++++++++++++---------
 drivers/gpu/drm/exynos/exynos_drm_g2d.c        |  9 +++--
 drivers/gpu/drm/i915/i915_gem_tiling.c         | 19 ++--------
 drivers/gpu/drm/nouveau/core/subdev/fb/gk20a.c | 16 ++++++++-
 drivers/gpu/drm/nouveau/nv50_display.c         | 25 +++++++++++--
 drivers/gpu/drm/radeon/atom.c                  | 11 +++++-
 drivers/gpu/drm/radeon/atom.h                  |  2 ++
 drivers/gpu/drm/radeon/atombios_dp.c           |  4 ++-
 drivers/gpu/drm/radeon/atombios_i2c.c          |  4 ++-
 drivers/gpu/drm/radeon/radeon_device.c         |  1 +
 drivers/gpu/drm/tegra/dc.c                     |  9 +++--
 11 files changed, 103 insertions(+), 46 deletions(-)
