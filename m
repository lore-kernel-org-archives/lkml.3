Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbaD3ABF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 20:01:05 -0400
Received: from gir.skynet.ie ([193.1.99.77]:37615 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbaD3ABC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 20:01:02 -0400
Date: Wed, 30 Apr 2014 01:00:57 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: inki.dae@samsung.com, DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1404300059440.20360@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1526972717-1398816057=:20360"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1526972717-1398816057=:20360
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

smattering of fixes, i915, exynos, tegra, msm, vmwgfx,

bit of framebuffer reference counting fallout fixes, i915 GM45 regression
fix, DVI regression fix, vmware info leak between processes fix.

Inki, I've cherry-picked and signed off some of the stuff from the exynos
fixes pull request, since I know Linus is already unhappy with me, please
put the rest of those in -next.

Dave.

The following changes since commit abaafc0af9f74f8e6212a3bf54fb907358b40ad7:

  Merge branch 'drm-fixes-3.15' of git://people.freedesktop.org/~deathsimple/linux into drm-next (2014-04-23 07:39:12 +1000)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to b8eade24c9891b8f153c40cf310ef4696c873af9:

  drm/exynos: use %pad for dma_addr_t (2014-04-30 09:48:54 +1000)

----------------------------------------------------------------
Andrzej Hajda (1):
      drm/exynos: balance framebuffer refcount

Ben Widawsky (1):
      drm/i915: Allow full PPGTT with param override

Chris Wilson (2):
      drm/i915: Discard BIOS framebuffers too small to accommodate chosen mode
      drm/i915: Move all ring resets before setting the HWS page

Daniel Vetter (3):
      drm/i915: Don't check gmch state on inherited configs
      drm/tegra: restrict plane loops to legacy planes
      drm/i915: Don't WARN nor handle unexpected hpd interrupts on gmch platforms

Dave Airlie (4):
      Merge tag 'drm-intel-fixes-2014-04-25' of git://anongit.freedesktop.org/drm-intel into drm-next
      Merge branch 'msm-fixes-3.15-rc3' of git://people.freedesktop.org/~robclark/linux into drm-next
      Merge tag 'drm/tegra/for-3.15-rc3' of git://anongit.freedesktop.org/tegra/linux into drm-next
      Merge branch 'vmwgfx-fixes-3.15' of git://people.freedesktop.org/~thomash/linux into drm-next

Jingoo Han (3):
      MAINTAINERS: update maintainer entry for Exynos DP driver
      drm/exynos: dsi: use IS_ERR() to check devm_ioremap_resource() results
      drm/exynos: use %pad for dma_addr_t

Micah Richert (1):
      drm/msm: fix memory leak

Paulo Zanoni (1):
      drm/i915: get power domain in case the BIOS enabled eDP VDD

Rob Clark (2):
      drm/msm: default to XR24 rather than AR24
      drm/msm/mdp4: cure for the cursor blues (v2)

Thomas Hellstrom (1):
      drm/vmwgfx: Make sure user-space can't DMA across buffer object boundaries v2

Ville Syrjälä (1):
      drm/i915: Allow user modes to exceed DVI 165MHz limit

 MAINTAINERS                                |  6 ++++
 drivers/gpu/drm/exynos/exynos_drm_crtc.c   |  1 +
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c |  2 +-
 drivers/gpu/drm/exynos/exynos_drm_dsi.c    |  4 +--
 drivers/gpu/drm/exynos/exynos_drm_vidi.c   |  2 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c        |  2 +-
 drivers/gpu/drm/i915/i915_irq.c            | 18 +++++++---
 drivers/gpu/drm/i915/i915_reg.h            |  1 +
 drivers/gpu/drm/i915/intel_display.c       | 23 ++++++++++---
 drivers/gpu/drm/i915/intel_dp.c            | 11 +++++-
 drivers/gpu/drm/i915/intel_drv.h           |  3 +-
 drivers/gpu/drm/i915/intel_fbdev.c         | 10 ++++++
 drivers/gpu/drm/i915/intel_hdmi.c          |  9 ++---
 drivers/gpu/drm/i915/intel_ringbuffer.c    | 54 +++++++++++++++++++-----------
 drivers/gpu/drm/i915/intel_ringbuffer.h    |  1 +
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_crtc.c   |  9 ++---
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_irq.c    |  4 +--
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.c    | 21 ++++++++++++
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.h    |  4 +++
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_irq.c    |  4 +--
 drivers/gpu/drm/msm/msm_fbdev.c            |  5 +--
 drivers/gpu/drm/msm/msm_gem.c              |  4 ++-
 drivers/gpu/drm/tegra/dc.c                 |  2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c    | 22 ++++++++++++
 24 files changed, 166 insertions(+), 56 deletions(-)
--29444707-1526972717-1398816057=:20360--
