Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933991AbaGREXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:23:38 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33925 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933937AbaGREXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:23:36 -0400
Date: Fri, 18 Jul 2014 05:23:33 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1407180521350.4518@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1941498337-1405657413=:4518"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1941498337-1405657413=:4518
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

one nouveau deadlock fix, one qxl irq handling fix,
and a set of radeon pageflipping changes that fix regressions in 
pageflipping since -rc1 along with a leak and backlight fix.

the pageflipping fixes are a bit bigger than I'd like, but
there has been a few people focused on testing them.

Dave.

The following changes since commit 1795cd9b3a91d4b5473c97f491d63892442212ab:

  Linux 3.16-rc5 (2014-07-13 14:04:33 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 3c169e5629d6bce9aede3907aeb38f1c23f61952:

  Merge branch 'drm-fixes-3.16' of git://people.freedesktop.org/~agd5f/linux into drm-fixes (2014-07-18 09:59:21 +1000)

----------------------------------------------------------------

Alex Deucher (2):
      drm/radeon: avoid leaking edid data
      drm/radeon: set default bl level to something reasonable

Dave Airlie (2):
      Merge branch 'linux-3.16' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes
      Merge branch 'drm-fixes-3.16' of git://people.freedesktop.org/~agd5f/linux into drm-fixes

Jason Wang (1):
      drm/qxl: return IRQ_NONE if it was not our irq

Mario Kleiner (4):
      drm/radeon: Prevent too early kms-pageflips triggered by vblank.
      drm/radeon: Remove redundant fence unref in pageflip path.
      drm/radeon: Add missing vblank_put in pageflip ioctl error path.
      drm/radeon: Make classic pageflip completion path less racy.

Martin Peres (1):
      drm/nouveau/therm: fix a potential deadlock in the therm monitoring code

Michel Dänzer (2):
      drm/radeon: Move pinning the BO back to radeon_crtc_page_flip()
      drm/radeon: Complete page flip even if waiting on the BO fence fails

 drivers/gpu/drm/nouveau/core/subdev/therm/temp.c |   6 +-
 drivers/gpu/drm/qxl/qxl_irq.c                    |   3 +
 drivers/gpu/drm/radeon/atombios_crtc.c           |   8 +-
 drivers/gpu/drm/radeon/atombios_encoders.c       |  10 +-
 drivers/gpu/drm/radeon/evergreen.c               |   5 +-
 drivers/gpu/drm/radeon/evergreen_reg.h           |   1 -
 drivers/gpu/drm/radeon/radeon.h                  |   3 +-
 drivers/gpu/drm/radeon/radeon_display.c          | 198 ++++++++++++-----------
 drivers/gpu/drm/radeon/rv515.c                   |   5 +-
 9 files changed, 125 insertions(+), 114 deletions(-)
--29444707-1941498337-1405657413=:4518--
