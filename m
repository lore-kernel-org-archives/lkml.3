Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab3AUDtY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 22:49:24 -0500
Received: from gir.skynet.ie ([193.1.99.77]:55853 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649Ab3AUDtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 22:49:23 -0500
Date: Mon, 21 Jan 2013 03:49:20 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1301210346500.6221@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1632967662-1358740160=:6221"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1632967662-1358740160=:6221
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

A bunch of intel and radeon fixes, along with two fixes to TTM code.

The correct fix for the Intel ironlake failure is in this, and should make 
things more stable, along with some misc radeon fixes.

Dave.

The following changes since commit 7b4cf994e4c6ba48872bb25253cc393b7fb74c82:

  udldrmfb: udl_get_edid: drop unneeded i-- (2013-01-14 08:45:27 +1000)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux.git drm-fixes

for you to fetch changes up to 014b34409fb2015f63663b6cafdf557fdf289628:

  ttm: on move memory failure don't leave a node dangling (2013-01-21 13:45:23 +1000)

----------------------------------------------------------------
Alex Deucher (2):
      drm/radeon: clear reset flags if engines are idle
      Revert "drm/radeon: do not move bo to different placement at each cs"

Chris Wilson (2):
      drm/i915: Record DERRMR, FORCEWAKE and RING_CTL in error-state
      drm/i915: Invalidate the relocation presumed_offsets along the slow path

Dave Airlie (4):
      Merge branch 'drm-fixes-3.8' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      ttm: don't destroy old mm_node on memcpy failure
      ttm: on move memory failure don't leave a node dangling

Jani Nikula (2):
      drm/i915/eDP: do not write power sequence registers for ghost eDP
      drm/i915: fix FORCEWAKE posting reads

Jerome Glisse (1):
      drm/radeon: improve semaphore debugging on lockup

Marek Ol¨ák (1):
      drm/radeon: allow FP16 color clear registers on r500

 drivers/gpu/drm/i915/i915_debugfs.c        |  3 ++
 drivers/gpu/drm/i915/i915_drv.h            |  3 ++
 drivers/gpu/drm/i915/i915_gem_execbuffer.c | 21 +++++++++++++
 drivers/gpu/drm/i915/i915_irq.c            | 11 +++++++
 drivers/gpu/drm/i915/i915_reg.h            |  2 ++
 drivers/gpu/drm/i915/intel_dp.c            | 47 ++++++++++++++++++++----------
 drivers/gpu/drm/i915/intel_pm.c            | 17 +++++++----
 drivers/gpu/drm/radeon/evergreen.c         |  6 ++++
 drivers/gpu/drm/radeon/ni.c                |  6 ++++
 drivers/gpu/drm/radeon/r600.c              |  6 ++++
 drivers/gpu/drm/radeon/radeon.h            |  3 +-
 drivers/gpu/drm/radeon/radeon_drv.c        |  3 +-
 drivers/gpu/drm/radeon/radeon_object.c     | 18 +++++++-----
 drivers/gpu/drm/radeon/radeon_ring.c       |  2 ++
 drivers/gpu/drm/radeon/radeon_semaphore.c  |  4 +++
 drivers/gpu/drm/radeon/reg_srcs/rv515      |  2 ++
 drivers/gpu/drm/radeon/si.c                |  6 ++++
 drivers/gpu/drm/ttm/ttm_bo.c               |  1 +
 drivers/gpu/drm/ttm/ttm_bo_util.c          | 11 +++++--
 19 files changed, 140 insertions(+), 32 deletions(-)
--29444707-1632967662-1358740160=:6221--
