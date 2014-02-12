Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaBLG2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 01:28:47 -0500
Received: from gir.skynet.ie ([193.1.99.77]:40420 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbaBLG2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 01:28:45 -0500
Date: Wed, 12 Feb 2014 06:28:42 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1402120626560.10262@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1676349140-1392186522=:10262"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1676349140-1392186522=:10262
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

nothing too crazy, radeon irq fixes, i915 regression fixes, exynos fixes,
tda998x chip fixes, and a bunch of msm fixes.

Dave.

The following changes since commit 7c4c62a04a2a80e3feb5d6c97aca1e413b11c790:

  drm/radeon: allow geom rings to be setup on r600/r700 (v2) (2014-02-06 12:13:52 +1000)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 9b244b5dc720f2b2135b2e64d44ab10220c2bf21:

  Merge branch 'tda998x-fixes' of git://ftp.arm.linux.org.uk/~rmk/linux-cubox into drm-next (2014-02-12 09:51:51 +1000)

----------------------------------------------------------------

Alex Deucher (5):
      drm/radeon: fix UVD IRQ support on 7xx
      drm/radeon/dpm: use the driver state for dpm debugfs
      drm/radeon/dpm: use stored max_vddc rather than looking it up
      drm/radeon: remove useless return
      drm/radeon: add missing include in btc_dpm.c

Christian König (1):
      drm/radeon: fix UVD IRQ support on SI

Daniel Vetter (3):
      MAINTAINERS: Update drm/i915 git repo
      drm/i915: Disable dp aux irq on g4x
      drm/i915: Fix intel_pipe_to_cpu_transcoder for UMS

Dave Airlie (6):
      Merge branch 'drm-fixes-3.14' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge branch 'msm-next' of git://people.freedesktop.org/~robclark/linux into drm-next
      Merge branch 'exynos-drm-fixes' of git://git.kernel.org/.../daeinki/drm-exynos into drm-next
      Merge tag 'drm-intel-fixes-2014-02-06' of ssh://git.freedesktop.org/git/drm-intel into drm-next
      Merge tag 'drm-intel-fixes-2014-02-11' of ssh://git.freedesktop.org/git/drm-intel into drm-next
      Merge branch 'tda998x-fixes' of git://ftp.arm.linux.org.uk/~rmk/linux-cubox into drm-next

Dave Jones (1):
      drm/radeon/dpm: fix uninitialized read from stack in kv_dpm_late_enable

Imre Deak (1):
      drm/i915: vlv: fix DP PHY lockup due to invalid PP sequencer setup

Jani Nikula (2):
      drm: add DRM_INFO_ONCE() to print a one-time DRM_INFO() message
      drm/i915: demote opregion excessive timeout WARN_ONCE to DRM_INFO_ONCE

Jean-Francois Moine (6):
      drm/i2c: tda998x: fix bad value in the AIF
      drm/i2c: tda998x: check the CEC device creation
      drm/i2c: tda998x: free the CEC device on encoder_destroy
      drm/i2c: tda998x: force the page register at startup time
      drm/i2c: tda998x: set the PLL division factor in range 0..3
      drm/i2c: tda998x: fix the ENABLE_SPACE register

Mika Kuoppala (1):
      drm/i915: Pair va_copy with va_end in i915_error_vprintf

Rob Clark (6):
      drm/msm: fix inconsequential typo
      drm/msm/mdp5: fix ref leaks in error paths
      drm/msm/mdp4: pageflip fixes
      drm/msm/mdp4: cursor fixes
      drm/msm: fix deadlock in bo create fail path
      drm/msm: bigger synchronization hammer

Sachin Kamat (4):
      drm/exynos: Fix freeing issues in exynos_drm_drv.c
      drm/exynos: Remove unnecessary semicolon
      drm/exynos: Fix trivial typo
      drm/exynos: Convert to use the standard hdmi.h header

Tushar Behera (1):
      drm/exynos: Fix multiplatform breakage for ipp/gsc

 MAINTAINERS                               |   2 +-
 drivers/gpu/drm/exynos/Kconfig            |   4 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.c   |  14 ++-
 drivers/gpu/drm/exynos/exynos_drm_g2d.c   |   2 +-
 drivers/gpu/drm/exynos/exynos_drm_ipp.c   |   3 +-
 drivers/gpu/drm/exynos/exynos_hdmi.c      |  66 +++++------
 drivers/gpu/drm/i2c/tda998x_drv.c         |  17 ++-
 drivers/gpu/drm/i915/i915_drv.h           |   8 ++
 drivers/gpu/drm/i915/i915_gpu_error.c     |   5 +-
 drivers/gpu/drm/i915/i915_irq.c           |   3 +-
 drivers/gpu/drm/i915/intel_dp.c           |  12 +-
 drivers/gpu/drm/i915/intel_i2c.c          |   7 --
 drivers/gpu/drm/i915/intel_opregion.c     |   9 +-
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_crtc.c  | 179 +++++++++++++++++++-----------
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_plane.c |   4 +-
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c  |   7 +-
 drivers/gpu/drm/msm/msm_gem.c             |   2 +-
 drivers/gpu/drm/msm/msm_gem_submit.c      |   9 +-
 drivers/gpu/drm/msm/msm_gpu.c             |   3 -
 drivers/gpu/drm/radeon/btc_dpm.c          |  32 ++++++
 drivers/gpu/drm/radeon/btcd.h             |   4 +
 drivers/gpu/drm/radeon/kv_dpm.c           |   2 +-
 drivers/gpu/drm/radeon/ni_dpm.c           |   8 +-
 drivers/gpu/drm/radeon/r600.c             |   4 +
 drivers/gpu/drm/radeon/radeon_asic.c      |   2 +-
 drivers/gpu/drm/radeon/radeon_asic.h      |   2 +
 drivers/gpu/drm/radeon/rv770_dpm.c        |   5 +-
 drivers/gpu/drm/radeon/si.c               |   4 +
 drivers/gpu/drm/radeon/si_dpm.c           |   3 +-
 drivers/gpu/drm/radeon/sumo_dpm.c         |   2 +-
 drivers/gpu/drm/radeon/trinity_dpm.c      |   3 +-
 drivers/gpu/drm/radeon/uvd_v2_2.c         |   1 -
 include/drm/drmP.h                        |   3 +
 33 files changed, 270 insertions(+), 161 deletions(-)
--29444707-1676349140-1392186522=:10262--
