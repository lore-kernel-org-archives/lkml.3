Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab3JVHBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 03:01:50 -0400
Received: from gir.skynet.ie ([193.1.99.77]:58140 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab3JVHBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 03:01:49 -0400
Date: Tue, 22 Oct 2013 08:01:47 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1310220800120.19505@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1346208047-1382425307=:19505"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1346208047-1382425307=:19505
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

travelling slowed down getting these out,
2 vmwgfx fixes, radeon revert to avoid a regression, i915 fixes, and some 
ioctl sizing issues fixed with 32 on 64.

Dave.

The following changes since commit 61e6cfa80de5760bbe406f4e815b7739205754d2:

  Linux 3.12-rc5 (2013-10-13 15:41:28 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 579123fdfc23ad2147f041dfec305c2308f068ba:

  Merge branch 'drm-fixes-3.12' of git://people.freedesktop.org/~agd5f/linux into drm-fixes (2013-10-22 07:35:17 +0100)

----------------------------------------------------------------

Alex Deucher (6):
      drm/radeon/atom: workaround vbios bug in transmitter table on rs780
      drm/radeon: make missing smc ucode non-fatal (r7xx-SI)
      drm/radeon: make missing smc ucode non-fatal (CI)
      drm/radeon/audio: don't set speaker allocation on DCE3.2
      drm/radeon: rework audio option
      drm/radeon/audio: don't set speaker allocation on DCE4+

Ben Widawsky (2):
      drm/i915: Make PTE valid encoding optional
      drm/i915: Disable GGTT PTEs on GEN6+ suspend

Chris Wilson (2):
      drm: Prevent overwriting from userspace underallocating core ioctl structs
      drm: Pad drm_mode_get_connector to 64-bit boundary

Christian König (2):
      drm/radeon: stop the leaks in cik_ib_test
      drm/radeon/uvd: revert lower msg&fb buffer requirements on UVD3

Dave Airlie (2):
      Merge tag 'drm-intel-fixes-2013-10-21' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes
      Merge branch 'drm-fixes-3.12' of git://people.freedesktop.org/~agd5f/linux into drm-fixes

Jesse Barnes (1):
      drm/i915: disable LVDS clock gating on CPT v2

Thomas Hellstrom (2):
      drm/vmwgfx: Don't put resources with invalid id's on lru list
      drm/vmwgfx: Don't kill clients on VT switch

 drivers/gpu/drm/drm_drv.c                  |   9 ++-
 drivers/gpu/drm/i915/i915_drv.c            |   5 +-
 drivers/gpu/drm/i915/i915_drv.h            |   8 ++-
 drivers/gpu/drm/i915/i915_gem_gtt.c        | 109 ++++++++++++++++++++++-------
 drivers/gpu/drm/i915/i915_reg.h            |   6 ++
 drivers/gpu/drm/i915/intel_pm.c            |   4 +-
 drivers/gpu/drm/radeon/atombios_encoders.c |  54 +++++++++-----
 drivers/gpu/drm/radeon/cik.c               |   4 ++
 drivers/gpu/drm/radeon/dce6_afmt.c         |   3 +
 drivers/gpu/drm/radeon/evergreen_hdmi.c    |   3 +
 drivers/gpu/drm/radeon/ni.c                |   1 +
 drivers/gpu/drm/radeon/r600.c              |   1 +
 drivers/gpu/drm/radeon/r600_hdmi.c         |   3 +
 drivers/gpu/drm/radeon/radeon_connectors.c |  33 +++++----
 drivers/gpu/drm/radeon/radeon_cs.c         |   3 +-
 drivers/gpu/drm/radeon/radeon_drv.c        |   4 +-
 drivers/gpu/drm/radeon/radeon_uvd.c        |   3 +-
 drivers/gpu/drm/radeon/si.c                |   1 +
 drivers/gpu/drm/radeon/uvd_v1_0.c          |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c        |  17 +++--
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c   |   2 +-
 include/uapi/drm/drm_mode.h                |   2 +
 22 files changed, 207 insertions(+), 72 deletions(-)
--29444707-1346208047-1382425307=:19505--
