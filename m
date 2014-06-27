Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaF0Gum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 02:50:42 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44237 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbaF0Gul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 02:50:41 -0400
Date: Fri, 27 Jun 2014 07:50:36 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1406270748210.22306@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

exynos, i915 and msm fixes and one core fix.

exynos: hdmi power off and mixer issues,
msm: iommu, build fixes,
i915: regression races and warns!

Dave.

The following changes since commit a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee:

  Linux 3.16-rc2 (2014-06-21 19:02:54 -1000)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 0fcb70c30131aac40f62ba13f89963d5c13b48a7:

  Merge tag 'drm-intel-fixes-2014-06-26' of git://anongit.freedesktop.org/drm-intel into drm-fixes (2014-06-27 15:04:06 +1000)

----------------------------------------------------------------

Andrzej Hajda (1):
      drm/exynos: disable unused windows on apply

Chris Wilson (2):
      drm/i915: Only mark the ctx as initialised after a SET_CONTEXT operation
      drm/i915: Hold the table lock whilst walking the file's idr and counting the objects in debugfs

Dan Carpenter (1):
      drm/exynos: change zero to NULL for sparse

Dave Airlie (3):
      Merge branch 'msm-fixes-3.16' of git://people.freedesktop.org/~robclark/linux into drm-fixes
      Merge branch 'exynos-drm-fixes' of git://git.kernel.org/.../daeinki/drm-exynos into drm-fixes
      Merge tag 'drm-intel-fixes-2014-06-26' of git://anongit.freedesktop.org/drm-intel into drm-fixes

Fabian Frederick (1):
      drm/msm: use PAGE_ALIGNED instead of IS_ALIGNED(PAGE_SIZE)

Imre Deak (1):
      drm/i915: cache hw power well enabled state

Inki Dae (1):
      drm/exynos: hdmi: fix power order issue

Jani Nikula (1):
      drm/i915: default to having backlight if VBT not available

Matwey V. Kornilov (1):
      drm/msm: Replace type of paddr to uint32_t.

Peter Griffin (1):
      drm/msm: storage class should be before const qualifier

Rahul Sharma (5):
      drm/exynos: set power state variable after enabling clocks and power
      drm/exynos: stop mixer before gating clocks during poweroff
      drm/exynos: allow multiple layer updates per vsync for mixer
      drm/exynos: soft reset mixer before reconfigure after power-on
      drm/exynos: enable vsync interrupt while waiting for vblank

Rodrigo Vivi (1):
      drm/i915: BDW: Adding Reserved PCI IDs.

Sachin Kamat (1):
      drm/exynos: Fix de-registration ordering

Shobhit Kumar (1):
      drm/i915: vlv_prepare_pll is only needed in case of non DSI interfaces

Stephane Viau (2):
      drm/msm/hdmi: set hdp clock rate before prepare_enable
      drm/msm: fix IOMMU cleanup for -EPROBE_DEFER

Tomasz Figa (1):
      drm/exynos: dpi: Fix NULL pointer dereference with legacy bindings

Zhaowei Yuan (1):
      drm: fix NULL pointer access by wrong ioctl

 drivers/gpu/drm/drm_drv.c                 |  3 +-
 drivers/gpu/drm/exynos/exynos_drm_dpi.c   |  2 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.c   |  8 ++---
 drivers/gpu/drm/exynos/exynos_drm_drv.h   |  2 +-
 drivers/gpu/drm/exynos/exynos_drm_fimd.c  |  2 ++
 drivers/gpu/drm/exynos/exynos_hdmi.c      | 19 ++++++++++++
 drivers/gpu/drm/exynos/exynos_mixer.c     | 50 +++++++++++++++++++++----------
 drivers/gpu/drm/exynos/regs-mixer.h       |  1 +
 drivers/gpu/drm/i915/i915_debugfs.c       |  2 ++
 drivers/gpu/drm/i915/i915_drv.h           |  2 ++
 drivers/gpu/drm/i915/i915_gem_context.c   |  8 +++--
 drivers/gpu/drm/i915/intel_bios.c         |  6 ++--
 drivers/gpu/drm/i915/intel_display.c      | 13 ++++----
 drivers/gpu/drm/i915/intel_drv.h          |  4 +--
 drivers/gpu/drm/i915/intel_pm.c           | 37 ++++++++++-------------
 drivers/gpu/drm/msm/hdmi/hdmi.c           |  2 ++
 drivers/gpu/drm/msm/hdmi/hdmi.h           |  1 +
 drivers/gpu/drm/msm/hdmi/hdmi_connector.c |  8 +++++
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c   | 22 ++++++++++----
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h   |  1 +
 drivers/gpu/drm/msm/msm_drv.c             |  2 +-
 drivers/gpu/drm/msm/msm_fbdev.c           |  2 +-
 drivers/gpu/drm/msm/msm_gem.c             |  6 ++++
 drivers/gpu/drm/msm/msm_iommu.c           | 23 ++++++++++++--
 drivers/gpu/drm/msm/msm_mmu.h             |  1 +
 include/drm/i915_pciids.h                 | 12 ++++++--
 26 files changed, 169 insertions(+), 70 deletions(-)
 mode change 100644 => 100755 drivers/gpu/drm/drm_drv.c
