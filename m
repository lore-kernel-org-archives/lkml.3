Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbaJVBPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 21:15:47 -0400
Received: from gir.skynet.ie ([193.1.99.77]:52759 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbaJVBPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 21:15:46 -0400
Date: Wed, 22 Oct 2014 02:15:43 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1410220213000.10336@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-704953486-1413940543=:10336"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-704953486-1413940543=:10336
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

intel, nouveau, radeon and qxl,

mostly for bugs introduced in the merge window, nothing too shocking.

Dave.

The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to c572aaf46f71f63ae5914d4e194a955e0ba1b519:

  qxl: don't create too large primary surface (2014-10-22 11:11:50 +1000)

----------------------------------------------------------------
Alex Deucher (6):
      Revert "drm/radeon: drop btc_get_max_clock_from_voltage_dependency_table"
      Revert "drm/radeon/dpm: drop clk/voltage dependency filters for SI"
      drm/radeon: initialize sadb to NULL in the audio code
      drm/radeon: fix speaker allocation setup
      drm/radeon: use gart memory for DMA ring tests
      drm/radeon: fix vm page table block size calculation

Ben Skeggs (2):
      drm/gt215/gr: fix initialisation on gddr5 boards
      drm/nouveau: fix regression on agp boards

Dave Airlie (3):
      Merge branch 'drm-fixes-3.18' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
      Merge tag 'drm-intel-next-fixes-2014-10-17' of git://anongit.freedesktop.org/drm-intel into drm-fixes
      Merge branch 'linux-3.18' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes

Jani Nikula (1):
      drm/i915: fix short vs. long hpd detection

Marc-André Lureau (1):
      qxl: don't create too large primary surface

Michel Dänzer (2):
      drm/ttm: Don't skip fpfn check if lpfn is 0 in ttm_bo_mem_compat
      drm/ttm: Don't evict BOs outside of the requested placement range

Michele Curti (1):
      drm/radeon: reduce sparse false positive warnings

Paulo Zanoni (1):
      drm/i915: properly reenable gen8 pipe IRQs

U. Artie Eoff (2):
      drm/i915: intel_backlight scale() math WA
      drm/i915: Move DIV_ROUND_CLOSEST_ULL macro to header

Ville Syrjälä (1):
      drm/i915: Don't trust the DP_DETECT bit for eDP ports on CHV

 drivers/gpu/drm/i915/i915_irq.c                    | 19 ++++++------
 drivers/gpu/drm/i915/intel_display.c               | 36 +++++++++++++---------
 drivers/gpu/drm/i915/intel_drv.h                   |  3 ++
 drivers/gpu/drm/i915/intel_panel.c                 |  5 ++-
 .../gpu/drm/nouveau/core/engine/graph/ctxnv50.c    | 10 ++++--
 drivers/gpu/drm/nouveau/nouveau_chan.c             | 12 ++++++--
 drivers/gpu/drm/qxl/qxl_display.c                  | 16 +++++-----
 drivers/gpu/drm/radeon/btc_dpm.c                   | 18 +++++++++++
 drivers/gpu/drm/radeon/btc_dpm.h                   |  2 ++
 drivers/gpu/drm/radeon/ci_dpm.c                    |  1 +
 drivers/gpu/drm/radeon/cik_sdma.c                  | 21 +++++++------
 drivers/gpu/drm/radeon/cypress_dpm.c               |  1 +
 drivers/gpu/drm/radeon/dce3_1_afmt.c               |  6 ++--
 drivers/gpu/drm/radeon/dce6_afmt.c                 |  8 ++---
 drivers/gpu/drm/radeon/evergreen_hdmi.c            |  8 ++---
 drivers/gpu/drm/radeon/ni_dpm.c                    |  1 +
 drivers/gpu/drm/radeon/r600_dma.c                  | 21 +++++++------
 drivers/gpu/drm/radeon/r600_dpm.c                  |  1 +
 drivers/gpu/drm/radeon/radeon.h                    |  2 ++
 drivers/gpu/drm/radeon/radeon_device.c             |  2 +-
 drivers/gpu/drm/radeon/rs780_dpm.c                 |  1 +
 drivers/gpu/drm/radeon/rv6xx_dpm.c                 |  1 +
 drivers/gpu/drm/radeon/rv770_dpm.c                 |  1 +
 drivers/gpu/drm/radeon/si_dpm.c                    | 25 +++++++++++++++
 drivers/gpu/drm/radeon/sumo_dpm.c                  |  1 +
 drivers/gpu/drm/radeon/trinity_dpm.c               |  1 +
 drivers/gpu/drm/ttm/ttm_bo.c                       | 28 ++++++++++++-----
 27 files changed, 174 insertions(+), 77 deletions(-)
--29444707-704953486-1413940543=:10336--
