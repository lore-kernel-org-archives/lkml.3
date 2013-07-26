Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530Ab3GZKwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 06:52:30 -0400
Received: from gir.skynet.ie ([193.1.99.77]:47603 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757844Ab3GZKw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 06:52:28 -0400
Date: Fri, 26 Jul 2013 11:52:25 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes - regular pull req
Message-ID: <alpine.DEB.2.00.1307261150280.5725@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is just a regular fixes pull apart from the qxl one, it has radeon 
and intel bits in it,

the intel fixes are for a regression with the RC6 fix and a 3.10 hdmi 
regression, whereas radeon is more DPM fixes, a few lockup fixes and 
some rn50/r100 DAC fixes.

Dave.

The following changes since commit 07bc9dc1b01bad7084fed3d2659e5d83317869bc:

  Merge branch 'merge' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc (2013-07-24 11:07:18 -0700)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to bf903e4141fce4b35072d5b8fa0ddd299aaf01ea:

  Merge tag 'drm-intel-fixes-2013-07-25' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes (2013-07-26 20:38:14 +1000)

----------------------------------------------------------------

Alex Deucher (8):
      drm/radeon: wait for 3D idle before using CP DMA
      drm/radeon/vm: only align the pt base to 32k
      drm/radeon: fix endian issues with DP handling (v3)
      drm/radeon: improve dac adjust heuristics for legacy pdac
      drm/radeon/dpm: fix a typo in the rv6xx mclk setup
      drm/radeon/dpm: fix displaygap programming on rv6xx
      drm/radeon/dpm: implement force performance levels for rv6xx
      drm/radeon/dpm: fix r600_enable_sclk_control()

Daniel Vetter (1):
      drm/i915: fix hdmi portclock limits

Dave Airlie (2):
      Merge branch 'drm-fixes-3.11' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
      Merge tag 'drm-intel-fixes-2013-07-25' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes

Jani Nikula (1):
      drm/i915: initialize gt_lock early with other spin locks

Mark Kettenis (1):
      drm/radeon: fix combios tables on older cards

Ondrej Zary (1):
      drm/radeon: Another card with wrong primary dac adj

 drivers/gpu/drm/i915/i915_dma.c         |   1 +
 drivers/gpu/drm/i915/intel_hdmi.c       |  19 +++-
 drivers/gpu/drm/i915/intel_pm.c         |   2 -
 drivers/gpu/drm/radeon/atombios_dp.c    |  43 ++++++++-
 drivers/gpu/drm/radeon/r600.c           |   5 +-
 drivers/gpu/drm/radeon/r600_dpm.c       |   4 +-
 drivers/gpu/drm/radeon/radeon_asic.c    |   1 +
 drivers/gpu/drm/radeon/radeon_asic.h    |   2 +
 drivers/gpu/drm/radeon/radeon_combios.c | 159 ++++++++++----------------------
 drivers/gpu/drm/radeon/radeon_gart.c    |   8 +-
 drivers/gpu/drm/radeon/rv6xx_dpm.c      |  41 +++++++-
 11 files changed, 158 insertions(+), 127 deletions(-)
