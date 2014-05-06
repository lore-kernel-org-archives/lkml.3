Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbaEFXKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 19:10:19 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59665 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949AbaEFXKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 19:10:18 -0400
Date: Wed, 7 May 2014 00:10:15 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1405070008010.22006@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-460328292-1399417815=:22006"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-460328292-1399417815=:22006
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

radeon, i915 and nouveau fixes, all fixes for regressions or black 
screens, or possible oopses,

I have an optional follow up to this for AMD as they have some new HW 
support they'd like in, but I'm not sure how you are feeling at the 
moment!

Dave.

The following changes since commit 0384dcae2b18db80c49117ac57ea15211ca48751:

  Merge branch 'irq-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2014-05-03 08:32:48 -0700)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 2a1235e53bed8fa111e1c1ee2e7d8d91efa71ebc:

  Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes (2014-05-07 09:06:21 +1000)

----------------------------------------------------------------

Alex Deucher (1):
      drm/radeon/dp: check for errors in dpcd reads

Ben Skeggs (2):
      drm/nouveau/bios: fix shadowing from PROM on big-endian systems
      drm/gm107/gr: bump attrib cb size quite a bit

Christian König (5):
      drm/radeon/uvd: use lower clocks on old UVD to boot v2
      drm/radeon: use pflip irq on R600+ v2
      drm/radeon: avoid high jitter with small frac divs
      drm/radeon: check that we have a clock before PLL setup
      drm/radeon: lower the ref * post PLL maximum

Dan Carpenter (1):
      agp: info leak in agpioc_info_wrap()

Daniel Vetter (1):
      drm/i915: Sanitize the enable_ppgtt module option once

Dave Airlie (3):
      Merge branch 'drm-fixes-3.15' of git://people.freedesktop.org/~deathsimple/linux into drm-fixes
      Merge tag 'topc/core-stuff-2014-05-05' of git://anongit.freedesktop.org/drm-intel into drm-fixes
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes

Egbert Eich (1):
      drm/i915: Break encoder->crtc link separately in intel_sanitize_crtc()

Ilia Mirkin (1):
      drm/nouveau/acpi: allow non-optimus setups to load vbios from acpi

Leo Liu (1):
      drm/radeon: check buffer relocation offset

Maarten Lankhorst (2):
      drm/nouveau: fix another lock unbalance in nouveau_crtc_page_flip
      drm/radeon: drm/radeon: add missing radeon_semaphore_free to error path

Michel Dänzer (1):
      drm/radeon: Fix num_banks calculation for SI

Paulo Zanoni (1):
      drm/i915: don't try DP_LINK_BW_5_4 on HSW ULX

 drivers/char/agp/frontend.c                        |  1 +
 drivers/gpu/drm/i915/i915_drv.h                    |  3 +
 drivers/gpu/drm/i915/i915_gem_gtt.c                | 32 +++++++--
 drivers/gpu/drm/i915/intel_display.c               | 26 ++++----
 drivers/gpu/drm/i915/intel_dp.c                    |  3 +-
 .../gpu/drm/nouveau/core/engine/graph/ctxgm107.c   |  4 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/base.c    | 10 +--
 drivers/gpu/drm/nouveau/nouveau_acpi.c             |  3 -
 drivers/gpu/drm/nouveau/nouveau_display.c          |  2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c             | 49 +++++++++-----
 drivers/gpu/drm/radeon/atombios_dp.c               | 44 +++++++------
 drivers/gpu/drm/radeon/cik.c                       | 77 ++++++++++++++++++++++
 drivers/gpu/drm/radeon/cik_sdma.c                  |  1 +
 drivers/gpu/drm/radeon/cikd.h                      |  9 +++
 drivers/gpu/drm/radeon/evergreen.c                 | 28 ++++++--
 drivers/gpu/drm/radeon/evergreen_dma.c             |  1 +
 drivers/gpu/drm/radeon/r600.c                      | 14 +++-
 drivers/gpu/drm/radeon/r600_dma.c                  |  1 +
 drivers/gpu/drm/radeon/radeon.h                    |  6 ++
 drivers/gpu/drm/radeon/radeon_display.c            | 20 +++++-
 drivers/gpu/drm/radeon/radeon_uvd.c                |  4 ++
 drivers/gpu/drm/radeon/rv770_dma.c                 |  1 +
 drivers/gpu/drm/radeon/si.c                        | 28 ++++++--
 drivers/gpu/drm/radeon/si_dma.c                    |  1 +
 drivers/gpu/drm/radeon/uvd_v1_0.c                  | 10 ++-
 include/drm/i915_pciids.h                          |  4 +-
 26 files changed, 295 insertions(+), 87 deletions(-)
--29444707-460328292-1399417815=:22006--
