Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab3CYGw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 02:52:57 -0400
Received: from gir.skynet.ie ([193.1.99.77]:54729 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299Ab3CYGw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 02:52:56 -0400
Date: Mon, 25 Mar 2013 06:52:47 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm exynos + intel fixes
Message-ID: <alpine.DEB.2.00.1303250651190.17260@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

The intel fixes are fairly straightforward, mostly reverts due to bugs 
found, the exynos one is a big larger since they found some issues with 
the G2D engine and iommu interaction, and needed to verify the operations 
a lot better than they were previously, otherwise a user app can just 
crash the kernel with an iommu fault.

Dave.

The following changes since commit 8bb9660418e05bb1845ac1a2428444d78e322cc7:

  Linux 3.9-rc4 (2013-03-23 16:52:44 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux.git drm-fixes

for you to fetch changes up to 7ac8833f5920a4a58190743697c9c8920c2fab4e:

  Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into HEAD (2013-03-25 12:20:00 +1000)

----------------------------------------------------------------

Alexandru Gheorghiu (1):
      drm/exynos: Replaced kzalloc & memcpy with kmemdup

Daniel Vetter (2):
      Revert "drm/i915: set TRANSCODER_EDP even earlier"
      Revert "drm/i915: write backlight harder"

Dave Airlie (2):
      Merge branch 'exynos-drm-fixes' of git://git.kernel.org/.../daeinki/drm-exynos into HEAD
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into HEAD

Inki Dae (1):
      drm/exynos: Add a new function to get gem buffer size

Leela Krishna Amudala (1):
      drm/exynos: fimd: calculate the correct address offset

Paulo Zanoni (1):
      drm/i915: don't disable the power well yet

Sachin Kamat (1):
      drm/exynos: Make mixer_check_timing static

Vikas Sajjan (1):
      drm/exynos: modify the compatible string for exynos fimd

YoungJun Cho (6):
      drm/exynos: Fix error routine to getting dma addr.
      drm/exynos: clear node object type at gem unmap
      drm/exynos: Fix G2D core malfunctioning issue
      drm/exynos: Clean up some G2D codes for readability
      drm/exynos: Deal with g2d buffer info more efficiently
      drm/exynos: Check g2d cmd list for g2d restrictions

 drivers/gpu/drm/exynos/exynos_drm_fimd.c |  21 +-
 drivers/gpu/drm/exynos/exynos_drm_g2d.c  | 370 +++++++++++++++++++++++++++----
 drivers/gpu/drm/exynos/exynos_drm_gem.c  |  21 ++
 drivers/gpu/drm/exynos/exynos_drm_gem.h  |   5 +
 drivers/gpu/drm/exynos/exynos_drm_vidi.c |   6 +-
 drivers/gpu/drm/exynos/exynos_mixer.c    |   2 +-
 drivers/gpu/drm/i915/i915_drv.c          |   5 +
 drivers/gpu/drm/i915/i915_drv.h          |   1 +
 drivers/gpu/drm/i915/intel_display.c     |  10 +-
 drivers/gpu/drm/i915/intel_panel.c       |  13 +-
 drivers/gpu/drm/i915/intel_pm.c          |   3 +
 11 files changed, 384 insertions(+), 73 deletions(-)
