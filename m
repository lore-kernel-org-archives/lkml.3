Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab3CGWid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 17:38:33 -0500
Received: from gir.skynet.ie ([193.1.99.77]:58178 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab3CGWib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 17:38:31 -0500
Date: Thu, 7 Mar 2013 22:38:29 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1303072237160.5819@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-904281072-1362695909=:5819"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-904281072-1362695909=:5819
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

misc radeon, nouveau, mgag200 and intel fixes,

the intel fixes should contain the fix for the touchpad on the Chromebook 
- hey I'm an input maintainer now!

Dave.

The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux.git drm-fixes

for you to fetch changes up to 36c1813bb453dd078e49bc5b3c1bf7d13535d9ff:

  drm/tegra: drop "select DRM_HDMI" (2013-03-08 08:36:01 +1000)

----------------------------------------------------------------
Alex Deucher (3):
      drm/radeon: don't set hpd, afmt interrupts when interrupts are disabled
      drm/radeon: add primary dac adj quirk for R200 board
      drm/radeon: skip MC reset as it's probably not hung

Ben Skeggs (4):
      drm/nve0/graph: some random reg moved on kepler
      drm/nv84: fix regression in page flipping
      drm/nouveau/i2c: drop parent refcount when creating ports
      drm/nv50-: prevent some races between modesetting and page flipping

Christopher Harvey (3):
      drm/mgag200: 'fbdev_list' in 'struct mga_fbdev' is not used
      drm/mgag200: Reject modes that are too big for VRAM
      drm: Documentation typo fixes

Daniel Vetter (1):
      drm/i915: enable irqs earlier when resuming

Dave Airlie (3):
      Merge branch 'drm-nouveau-fixes-3.9' of git://anongit.freedesktop.org/git/nouveau/linux-2.6
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      Merge branch 'drm-fixes-3.9' of git://people.freedesktop.org/~agd5f/linux into drm-next

Egbert Eich (1):
      DRM/i915: On G45 enable cursor plane briefly after enabling the display plane.

Francisco Jerez (2):
      drm/nouveau: Disable AGP on PowerPC again.
      drm/nouveau: Fix typo in init_idx_addr_latched().

Julia Lemire (1):
      drm/mgag200: Bug fix: Renesas board now selects native resolution.

Kenneth Graunke (1):
      drm/i915: Fix Haswell/CRW PCI IDs.

Marek Ol¨ák (1):
      drm/radeon: don't check mipmap alignment if MIP_ADDRESS is FMASK

Patrik Jakobsson (2):
      drm/i915: Fix incorrect definition of ADPA HSYNC and VSYNC bits
      drm/i915: Turn off hsync and vsync on ADPA when disabling crt

Paul Bolle (1):
      drm/tegra: drop "select DRM_HDMI"

Paulo Zanoni (2):
      drm/i915: wait_event_timeout's timeout is in jiffies
      drm/i915: also disable south interrupts when handling them

Stéphane Marchesin (1):
      drm/i915: Increase the RC6p threshold.

Syam Sidhardhan (1):
      drm/i915: Fix missing variable initilization

Ville Syrjälä (1):
      drm/i915: Don't clobber crtc->fb when queue_flip fails

 drivers/gpu/drm/i915/i915_drv.c                  |  25 +++-
 drivers/gpu/drm/i915/i915_irq.c                  |  26 +++-
 drivers/gpu/drm/i915/i915_reg.h                  |   4 +-
 drivers/gpu/drm/i915/intel_crt.c                 |   2 +-
 drivers/gpu/drm/i915/intel_ddi.c                 |   2 +-
 drivers/gpu/drm/i915/intel_display.c             |  37 ++++-
 drivers/gpu/drm/i915/intel_dp.c                  |   3 +-
 drivers/gpu/drm/i915/intel_pm.c                  |   2 +-
 drivers/gpu/drm/mgag200/mgag200_drv.h            |   1 -
 drivers/gpu/drm/mgag200/mgag200_i2c.c            |   1 +
 drivers/gpu/drm/mgag200/mgag200_mode.c           |  27 ++++
 drivers/gpu/drm/nouveau/core/engine/graph/nve0.c |   2 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c  |   2 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/base.c   |   1 +
 drivers/gpu/drm/nouveau/nouveau_agp.c            |  12 ++
 drivers/gpu/drm/nouveau/nv50_display.c           | 173 +++++++++++++----------
 drivers/gpu/drm/radeon/evergreen.c               |   6 +
 drivers/gpu/drm/radeon/evergreen_cs.c            |   2 +-
 drivers/gpu/drm/radeon/ni.c                      |   6 +
 drivers/gpu/drm/radeon/r600.c                    |   6 +
 drivers/gpu/drm/radeon/radeon_combios.c          |   9 ++
 drivers/gpu/drm/radeon/radeon_drv.c              |   3 +-
 drivers/gpu/drm/radeon/radeon_irq_kms.c          |  12 ++
 drivers/gpu/drm/radeon/si.c                      |   6 +
 drivers/gpu/drm/tegra/Kconfig                    |   1 -
 include/drm/drm_crtc.h                           |   6 +-
 26 files changed, 275 insertions(+), 102 deletions(-)
--29444707-904281072-1362695909=:5819--
