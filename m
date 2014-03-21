Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965082AbaCUFaC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 01:30:02 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56154 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964998AbaCUF37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 01:29:59 -0400
Date: Fri, 21 Mar 2014 05:29:57 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1403210523570.13860@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-2096126696-1395379797=:13860"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-2096126696-1395379797=:13860
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Some final few intel fixes, all regressions, all stable cc, and one exynos 
oops fixer, the biggest is probably the intel display error irqs one, but 
it seems to fix a few crashes on startup, and one use after free in drm 
core.

Dave.

The following changes since commit dcb99fd9b08cfe1afe426af4d8d3cbc429190f15:

  Linux 3.14-rc7 (2014-03-16 18:51:24 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 004e5cf743086990e5fc04a14437b3966d7fa9a2:

  Merge branch 'exynos-drm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/daeinki/drm-exynos into drm-fixes (2014-03-20 13:20:00 +1000)

----------------------------------------------------------------

Ben Widawsky (1):
      drm/i915: Fix PSR programming

Chris Wilson (1):
      drm/i915: Disable stolen memory when DMAR is active

Daniel Kurtz (1):
      drm/exynos: Fix (more) freeing issues in exynos_drm_drv.c

Daniel Vetter (2):
      drm/i915: Don't enable display error interrupts from the start
      drm: Fix use-after-free in the shadow-attache exit code

Dave Airlie (3):
      Merge tag 'drm-intel-fixes-2014-03-17' of git://anongit.freedesktop.org/drm-intel into drm-fixes
      Merge tag 'drm-intel-fixes-2014-03-19' of git://anongit.freedesktop.org/drm-intel into drm-fixes
      Merge branch 'exynos-drm-fixes' of git://git.kernel.org/.../daeinki/drm-exynos into drm-fixes

Jani Nikula (1):
      Revert "drm/i915: don't touch the VDD when disabling the panel"

Ville Syrjälä (2):
      drm/i915: Add a workaround for HSW scanline counter weirdness
      drm/i915: Fix scanline counter fixup on BDW

 drivers/gpu/drm/drm_pci.c               |  2 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.c | 10 +++--
 drivers/gpu/drm/i915/i915_gem_stolen.c  |  7 ++++
 drivers/gpu/drm/i915/i915_irq.c         | 71 +++++++++++++++++++--------------
 drivers/gpu/drm/i915/intel_ddi.c        |  1 +
 drivers/gpu/drm/i915/intel_dp.c         | 12 +++++-
 6 files changed, 67 insertions(+), 36 deletions(-)
--29444707-2096126696-1395379797=:13860--
