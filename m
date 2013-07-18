Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965295Ab3GRVAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 17:00:24 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34572 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759384Ab3GRVAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 17:00:20 -0400
Date: Thu, 18 Jul 2013 22:00:15 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1307182158090.8402@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-734857318-1374181215=:8402"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-734857318-1374181215=:8402
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hey Linus,

you'll be terribly disappointed in this, I'm not trying to sneak any 
features in or anything, its mostly radeon and intel fixes, a couple of 
ARM driver fixes.

Dave.

The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 3668f0df6e62cd989909f40669bbe585e8dd51ae:

  Merge branch 'drm/3.11/fixes' of git://linuxtv.org/pinchartl/fbdev into drm-fixes (2013-07-18 20:04:50 +1000)

----------------------------------------------------------------

Alex Deucher (16):
      drm/radeon/hdmi: make sure we have an afmt block assigned
      drm/radeon/dpm: disable gfx PG on PALM
      drm/radeon: Disable dma rings for bo moves on r6xx
      drm/radeon: implement bo copy callback using CP DMA (v2)
      drm/radeon: use CP DMA on r6xx for bo moves
      drm/radeon: add fault decode function for cayman/TN (v2)
      drm/radeon: add fault decode function for SI (v2)
      drm/radeon: add fault decode function for CIK
      drm/radeon: allow selection of alignment in the sub-allocator
      drm/radeon: align VM PTBs (Page Table Blocks) to 32K
      drm/radeon/dpm/sumo: handle boost states properly when forcing a perf level
      drm/radeon: add a module parameter to disable aspm
      drm/radeon: fix an endian bug in atom table parsing
      drm/radeon/dpm: fix atom vram table parsing
      drm/radeon/dpm/atom: fix broken gcc harder
      drm/radeon/dpm: add debugfs support for RS780/RS880 (v3)

Andre Heider (1):
      drm/radeon/dpm/atom: restructure logic to work around a compiler bug

Chris Wilson (3):
      drm/i915: Fix write-read race with multiple rings
      drm/i915: Fix incoherence with fence updates on Sandybridge+
      Revert "drm/i915: Workaround incoherence between fences and LLC across multiple CPUs"

Christian König (2):
      drm/radeon: fix UVD fence emit
      drm/radeon: never unpin UVD bo v3

Daniel Vetter (2):
      drm/i915: reinit status page registers after gpu reset
      drm/i915: fix up ring cleanup for the i830/i845 CS tlb w/a

Dave Airlie (4):
      Merge branch 'drm-fixes-3.11' of git://people.freedesktop.org/~agd5f/linux
      Merge tag 'drm-intel-fixes-2013-07-11' of git://people.freedesktop.org/~danvet/drm-intel
      Merge branch 'drm-fixes-3.11' of git://people.freedesktop.org/~agd5f/linux
      Merge branch 'drm/3.11/fixes' of git://linuxtv.org/pinchartl/fbdev into drm-fixes

Guenter Roeck (1):
      Partially revert "drm/i915: unconditionally use mt forcewake on hsw/ivb"

Imre Deak (1):
      drm/i915: fix lane bandwidth capping for DP 1.2 sinks

Jerome Glisse (1):
      drm/radeon: use radeon device for request firmware

Laurent Pinchart (2):
      drm/shmobile: Use the GEM PRIME helpers
      drm/rcar-du: Use the GEM PRIME helpers

Maarten Lankhorst (1):
      drm/radeon: add missing ttm_eu_backoff_reservation to radeon_bo_list_validate

Paulo Zanoni (1):
      drm/i915: switch disable_power_well default value to 1

Sergey Senozhatsky (1):
      radeon kms: do not flush uninitialized hotplug work

Sylvain 'ythier' Hitier (1):
      uvesafb: Really allow mtrr being 0, as documented and warn()ed

Xiong Zhang (1):
      drm/i915: Correct obj->mm_list link to dev_priv->dev_priv->mm.inactive_list

 drivers/gpu/drm/i915/i915_drv.c          |   4 +-
 drivers/gpu/drm/i915/i915_gem.c          |  83 ++++-----
 drivers/gpu/drm/i915/intel_dp.c          |   5 +
 drivers/gpu/drm/i915/intel_pm.c          |  31 +++-
 drivers/gpu/drm/i915/intel_ringbuffer.c  |  38 ++--
 drivers/gpu/drm/radeon/cik.c             |  59 +++---
 drivers/gpu/drm/radeon/cikd.h            |  16 ++
 drivers/gpu/drm/radeon/evergreen.c       |  13 +-
 drivers/gpu/drm/radeon/evergreen_hdmi.c  |   6 +
 drivers/gpu/drm/radeon/ni.c              | 182 +++++++++++++++++--
 drivers/gpu/drm/radeon/nid.h             |  16 ++
 drivers/gpu/drm/radeon/r100.c            |  11 +-
 drivers/gpu/drm/radeon/r600.c            | 102 +++++++++--
 drivers/gpu/drm/radeon/r600_hdmi.c       |   6 +
 drivers/gpu/drm/radeon/r600d.h           |   1 +
 drivers/gpu/drm/radeon/radeon.h          |  10 +-
 drivers/gpu/drm/radeon/radeon_asic.c     |  13 +-
 drivers/gpu/drm/radeon/radeon_asic.h     |   5 +
 drivers/gpu/drm/radeon/radeon_atombios.c |  40 ++---
 drivers/gpu/drm/radeon/radeon_drv.c      |   4 +
 drivers/gpu/drm/radeon/radeon_fence.c    |   2 +-
 drivers/gpu/drm/radeon/radeon_gart.c     |  11 +-
 drivers/gpu/drm/radeon/radeon_irq_kms.c  |  11 +-
 drivers/gpu/drm/radeon/radeon_object.c   |   1 +
 drivers/gpu/drm/radeon/radeon_object.h   |   2 +-
 drivers/gpu/drm/radeon/radeon_ring.c     |   1 +
 drivers/gpu/drm/radeon/radeon_sa.c       |   7 +-
 drivers/gpu/drm/radeon/radeon_uvd.c      | 111 +++++-------
 drivers/gpu/drm/radeon/rs780_dpm.c       |  25 +++
 drivers/gpu/drm/radeon/rs780d.h          |   3 +
 drivers/gpu/drm/radeon/rv6xx_dpm.c       |  14 +-
 drivers/gpu/drm/radeon/rv770.c           |   2 +-
 drivers/gpu/drm/radeon/rv770_dpm.c       |  14 +-
 drivers/gpu/drm/radeon/si.c              | 298 +++++++++++++++++++++++++++++--
 drivers/gpu/drm/radeon/sid.h             |  14 ++
 drivers/gpu/drm/radeon/sumo_dpm.c        |  14 +-
 drivers/gpu/drm/rcar-du/rcar_du_drv.c    |   9 +-
 drivers/gpu/drm/shmobile/shmob_drm_drv.c |   9 +-
 drivers/video/uvesafb.c                  |   2 +-
 39 files changed, 918 insertions(+), 277 deletions(-)
--29444707-734857318-1374181215=:8402--
