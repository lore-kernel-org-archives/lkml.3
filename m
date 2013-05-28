Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207Ab3E1HHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 03:07:40 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33862 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932959Ab3E1HHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 03:07:39 -0400
Date: Tue, 28 May 2013 08:07:39 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
cc: linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1305280805370.23573@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

this is mostly exynos and intel fixes, along with some vblank patches I 
lost from Rob a few months ago that make wayland work better on lots of 
GPUs, also a qxl kconfig fix.

Dave.

The following changes since commit b91fd4d5aad0c1124654341814067ca3f59490fc:

  Merge tag 'pci-v3.10-fixes-2' of git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci (2013-05-23 13:50:53 -0700)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux.git drm-fixes

for you to fetch changes up to c89b65e7fffef745bdd36c372aa0dea778fecbab:

  qxl: fix Kconfig deps - select FB_DEFERRED_IO (2013-05-28 17:03:37 +1000)

----------------------------------------------------------------
Andrew Jones (1):
      qxl: fix Kconfig deps - select FB_DEFERRED_IO

Chris Wilson (1):
      drm/i915: Propagate errors back from fb set-base

Dave Airlie (3):
      Merge remote-tracking branch 'pfdo/drm-fixes' into drm-next
      Merge branch 'exynos-drm-fixes' of git://git.kernel.org/.../daeinki/drm-exynos into drm-next
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-next

Imre Deak (5):
      drm/i915: force full modeset if the connector is in DPMS OFF mode
      drm/i915: add msecs_to_jiffies_timeout to guarantee minimum duration
      drm/i915: use msecs_to_jiffies_timeout instead of open coding the same
      drm/i915: avoid premature timeouts in __wait_seqno()
      drm/i915: avoid premature DP AUX timeouts

Inki Dae (1):
      drm/exynos: wait for the completion of pending page flip

Lars-Peter Clausen (1):
      drm/exynos: exynos_hdmi: Pass correct pointer to free_irq()

Rob Clark (6):
      drm/nouveau: use drm_send_vblank_event() helper
      drm/radeon: use drm_send_vblank_event() helper
      drm/shmob: use drm_send_vblank_event() helper
      drm/imx: use drm_send_vblank_event() helper
      drm/exynos: page flip fixes
      drm/exynos: use drm_send_vblank_event() helper

Rodrigo Vivi (1):
      drm/i915: Adding more reserved PCI IDs for Haswell.

Sachin Kamat (2):
      drm/exynos: exynos_drm_fbdev: Fix incorrect usage of IS_ERR_OR_NULL
      drm/exynos: exynos_drm_ipp: Fix incorrect usage of IS_ERR_OR_NULL

Seung-Woo Kim (4):
      drm/exynos: cleanup device pointer usages
      drm/exynos: fix build warnings from ipp fimc
      drm/exynos: remove unnecessary devm_kfree
      drm/exynos: replace request_threaded_irq with devm function

 drivers/gpu/drm/exynos/exynos_drm_crtc.c    | 27 ++++++++++------
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c   |  2 +-
 drivers/gpu/drm/exynos/exynos_drm_fimc.c    | 12 +++----
 drivers/gpu/drm/exynos/exynos_drm_fimd.c    | 10 +++---
 drivers/gpu/drm/exynos/exynos_drm_g2d.c     |  6 ++--
 drivers/gpu/drm/exynos/exynos_drm_gsc.c     | 12 ++-----
 drivers/gpu/drm/exynos/exynos_drm_hdmi.c    |  2 +-
 drivers/gpu/drm/exynos/exynos_drm_ipp.c     | 18 +++++------
 drivers/gpu/drm/exynos/exynos_drm_rotator.c | 13 ++------
 drivers/gpu/drm/exynos/exynos_drm_vidi.c    |  4 +--
 drivers/gpu/drm/exynos/exynos_hdmi.c        | 21 +++++--------
 drivers/gpu/drm/exynos/exynos_mixer.c       | 14 ++++-----
 drivers/gpu/drm/i915/i915_drv.c             | 46 ++++++++++++++++++++-------
 drivers/gpu/drm/i915/i915_drv.h             | 15 +++++++++
 drivers/gpu/drm/i915/i915_gem.c             |  2 +-
 drivers/gpu/drm/i915/intel_display.c        | 49 +++++++++++++++++++----------
 drivers/gpu/drm/i915/intel_dp.c             |  2 +-
 drivers/gpu/drm/i915/intel_i2c.c            |  5 +--
 drivers/gpu/drm/nouveau/nouveau_display.c   | 13 ++------
 drivers/gpu/drm/qxl/Kconfig                 |  1 +
 drivers/gpu/drm/radeon/radeon_display.c     | 13 ++------
 drivers/gpu/drm/shmobile/shmob_drm_crtc.c   | 19 +++--------
 drivers/staging/imx-drm/ipuv3-crtc.c        | 21 ++-----------
 23 files changed, 163 insertions(+), 164 deletions(-)
