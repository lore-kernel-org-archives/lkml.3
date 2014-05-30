Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934901AbaE3X2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 19:28:47 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56477 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934345AbaE3X2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 19:28:46 -0400
Date: Sat, 31 May 2014 00:28:42 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: [git pull] drm i915 and radeon fixes
Message-ID: <alpine.DEB.2.00.1405310026540.29993@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-268084354-1401492522=:29993"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-268084354-1401492522=:29993
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Mostly quiet now,

i915: fixing userspace visiblie issues, all stable marked
radeon: one more pll fix, two crashers, one suspend/resume regression.

Dave.

The following changes since commit c7208164e66f63e3ec1759b98087849286410741:

  Linux 3.15-rc7 (2014-05-25 16:06:00 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 18ee37a485653aa635cfab9a3710e9bcf5fbca01:

  drm/radeon: Resume fbcon last (2014-05-31 09:19:51 +1000)

----------------------------------------------------------------
Chris Wilson (3):
      drm/i915: Fix dynamic allocation of physical handles
      drm/i915: Only copy back the modified fields to userspace from execbuffer
      drm/i915: Prevent negative relocation deltas from wrapping

Christian König (3):
      drm/radeon: lower the ref * post PLL maximum once more
      drm/radeon: avoid crash if VM command submission isn't available
      drm/radeon: only allocate necessary size for vm bo list

Daniel Vetter (1):
      drm/radeon: Resume fbcon last

Dave Airlie (2):
      Merge tag 'drm-intel-fixes-2014-05-27' of git://anongit.freedesktop.org/drm-intel into drm-fixes
      Merge branch 'drm-fixes-3.15' of git://people.freedesktop.org/~deathsimple/linux into drm-fixes

Marek Ol¨ák (1):
      drm/radeon: don't allow RADEON_GEM_DOMAIN_CPU for command submission

 drivers/gpu/drm/i915/i915_dma.c            |   1 -
 drivers/gpu/drm/i915/i915_drv.h            |  30 +--
 drivers/gpu/drm/i915/i915_gem.c            | 365 +++++++++++++----------------
 drivers/gpu/drm/i915/i915_gem_evict.c      |   9 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c | 130 ++++++----
 drivers/gpu/drm/i915/i915_gem_gtt.c        |   4 +-
 drivers/gpu/drm/i915/intel_display.c       |  11 +-
 drivers/gpu/drm/i915/intel_overlay.c       |  12 +-
 drivers/gpu/drm/radeon/radeon_cs.c         |  21 +-
 drivers/gpu/drm/radeon/radeon_device.c     |  11 +-
 drivers/gpu/drm/radeon/radeon_display.c    |   2 +-
 drivers/gpu/drm/radeon/radeon_vm.c         |   6 +-
 12 files changed, 298 insertions(+), 304 deletions(-)
--29444707-268084354-1401492522=:29993--
