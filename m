Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab3HIEyB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 00:54:01 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42466 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab3HIEx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 00:53:57 -0400
Date: Fri, 9 Aug 2013 05:53:54 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1308090550580.3322@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-73257823-1376024034=:3322"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-73257823-1376024034=:3322
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus

mostly radeon, more fixes for dynamic power management which is is off by 
default for this release anyways, but there are a large number of testers, 
so I'd like to keep merging the fixes,

otherwise, radeon UVD fixes affecting suspend/resume regressions, i915 
regression fixes, one for your mac mini, ast,mgag200,cirrus ttm fix and 
one regression fix in the core.

Dave.

The following changes since commit c095ba7224d8edc71dcef0d655911399a8bd4a3f:

  Linux 3.11-rc4 (2013-08-04 13:46:46 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to e42f5814212079aecd5826dba10588a896ac0862:

  Merge tag 'drm-intel-fixes-2013-08-08' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes (2013-08-09 09:09:37 +1000)

----------------------------------------------------------------

Aaron Lu (1):
      drm/i915: avoid brightness overflow when doing scale

Alex Deucher (11):
      drm/radeon: properly handle pm on gpu reset
      drm/radeon: select audio dto based on encoder id for DCE3
      drm/radeon/dpm: adjust thermal protection requirements
      drm/radeon/dpm: fix spread spectrum setup (v2)
      drm/radeon/dpm: adjust power state properly for UVD on SI
      drm/radeon/dpm: disable sclk ss on rv6xx
      drm/radeon: fix audio dto calculation on DCE3+ (v3)
      drm/radeon: always program the MC on startup
      drm/radeon/cik: use a mutex to properly lock srbm instanced registers
      drm/radeon/dpm: require rlc for dpm
      drm/radeon: make missing smc ucode non-fatal

Christian König (5):
      drm/radeon: fix halting UVD
      drm/radeon: only save UVD bo when we have open handles
      drm/radeon: stop sending invalid UVD destroy msg
      drm/radeon: add more UVD CS checking
      drm/radeon: remove unnecessary unpin

Daniel Vetter (1):
      drm/i915: fix gen4 digital port hotplug definitions

Dave Airlie (3):
      drm/ast: invalidate page tables when pinning a BO
      Merge branch 'drm-fixes-3.11' of git://people.freedesktop.org/~agd5f/linux
      Merge tag 'drm-intel-fixes-2013-08-08' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes

Egbert Eich (1):
      drm/mgag200: Invalidate page tables when pinning a BO

Jani Nikula (1):
      drm/i915: do not disable backlight on vgaswitcheroo switch off

Michal Srb (1):
      drm/cirrus: Invalidate page tables when pinning a BO

Michel Dänzer (1):
      drm: Don't pass negative delta to ktime_sub_ns()

Paulo Zanoni (1):
      drm/i915: update last_vblank when disabling the power well

Ville Syrjälä (1):
      drm/i915: Don't call encoder's get_config unless encoder is active

 drivers/gpu/drm/ast/ast_ttm.c           |  1 +
 drivers/gpu/drm/cirrus/cirrus_ttm.c     |  1 +
 drivers/gpu/drm/drm_irq.c               |  5 +-
 drivers/gpu/drm/i915/i915_reg.h         | 12 +++--
 drivers/gpu/drm/i915/intel_display.c    |  4 +-
 drivers/gpu/drm/i915/intel_panel.c      | 18 ++++++-
 drivers/gpu/drm/i915/intel_pm.c         | 18 +++++++
 drivers/gpu/drm/mgag200/mgag200_ttm.c   |  1 +
 drivers/gpu/drm/radeon/btc_dpm.c        | 17 +-----
 drivers/gpu/drm/radeon/cik.c            | 18 +++++--
 drivers/gpu/drm/radeon/cypress_dpm.c    | 17 +-----
 drivers/gpu/drm/radeon/evergreen.c      |  6 ++-
 drivers/gpu/drm/radeon/evergreen_hdmi.c | 26 ++++++++-
 drivers/gpu/drm/radeon/evergreend.h     |  3 ++
 drivers/gpu/drm/radeon/ni.c             | 16 ++++--
 drivers/gpu/drm/radeon/ni_dpm.c         | 17 +-----
 drivers/gpu/drm/radeon/r600.c           | 41 +++++++++++----
 drivers/gpu/drm/radeon/r600_hdmi.c      | 37 +++++++++++--
 drivers/gpu/drm/radeon/r600d.h          |  3 ++
 drivers/gpu/drm/radeon/radeon.h         |  4 +-
 drivers/gpu/drm/radeon/radeon_asic.h    |  2 +-
 drivers/gpu/drm/radeon/radeon_device.c  |  3 ++
 drivers/gpu/drm/radeon/radeon_fence.c   |  2 +-
 drivers/gpu/drm/radeon/radeon_gart.c    |  1 -
 drivers/gpu/drm/radeon/radeon_pm.c      |  9 +++-
 drivers/gpu/drm/radeon/radeon_uvd.c     | 93 +++++++++++++++++++++++++--------
 drivers/gpu/drm/radeon/rv6xx_dpm.c      | 22 ++++----
 drivers/gpu/drm/radeon/rv770.c          |  7 ++-
 drivers/gpu/drm/radeon/rv770_dpm.c      | 33 ++++++------
 drivers/gpu/drm/radeon/rv770_dpm.h      |  1 +
 drivers/gpu/drm/radeon/si.c             | 19 ++++---
 drivers/gpu/drm/radeon/si_dpm.c         | 61 +++++++++++----------
 32 files changed, 353 insertions(+), 165 deletions(-)
--29444707-73257823-1376024034=:3322--
