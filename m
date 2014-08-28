Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965502AbaH1Cc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 22:32:26 -0400
Received: from gir.skynet.ie ([193.1.99.77]:38502 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965084AbaH1CcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 22:32:24 -0400
Date: Thu, 28 Aug 2014 03:32:21 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1408280329380.28141@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-75658287-1409193141=:28141"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-75658287-1409193141=:28141
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Nothing major, one core oops fixes, some radeon oops fixes, some sti 
driver fixups, msm driver fixes and a minor Kconfig update for the ww 
mutex debugging.

Dave.

The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:

  Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to b8d758d29fda0ece817237718909ed2622f024f1:

  drm/ast: Add missing entry to dclk_table[] (2014-08-28 12:26:42 +1000)

----------------------------------------------------------------
Alex Deucher (1):
      drm/radeon: handle broken disabled rb mask gracefully (6xx/7xx) (v2)

Alex Williamson (1):
      radeon: Test for PCI root bus before assuming bus->self

Christian König (1):
      drm/radeon: save/restore the PD addr on suspend/resume

Dave Airlie (3):
      Merge branch 'drm-fixes-3.17' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
      Merge branch 'msm-fixes-3.17' of git://people.freedesktop.org/~robclark/linux into drm-fixes
      Merge branch 'drm-3.17-rc2-sti-fixes' of git://git.linaro.org/people/benjamin.gaignard/kernel into drm-fixes

David Herrmann (1):
      drm: fix division-by-zero on dumb_create()

Jingoo Han (1):
      drm: sti: Add missing dependency on RESET_CONTROLLER

Kiran Padwal (1):
      drm: sti: Make of_device_id array const

Rob Clark (4):
      drm/msm: avoid flood of kernel logs on faults
      drm/msm/mdp4: request vblank during modeset
      drm/msm: fix compile error for non-dt builds
      ww-mutex: clarify help text for DEBUG_WW_MUTEX_SLOWPATH

Wei Yongjun (5):
      drm: sti: tvout: fix return value check in sti_tvout_probe()
      drm: sti: hdmi: fix return value check in sti_hdmi_probe()
      drm: sti: hda: fix return value check in sti_hda_probe()
      drm: sti: Fix return value check in sti_drm_platform_probe()
      drm/msm: Fix missing unlock on error in msm_fbdev_create()

Y.C. Chen (1):
      drm/ast: Add missing entry to dclk_table[]

 drivers/gpu/drm/ast/ast_tables.h         |  1 +
 drivers/gpu/drm/drm_crtc.c               |  3 ++-
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_crtc.c |  2 ++
 drivers/gpu/drm/msm/msm_drv.c            |  3 +--
 drivers/gpu/drm/msm/msm_fbdev.c          |  2 +-
 drivers/gpu/drm/msm/msm_iommu.c          |  4 ++--
 drivers/gpu/drm/radeon/cik.c             | 26 +++++++++++++++++++-------
 drivers/gpu/drm/radeon/ni.c              |  9 ++++++++-
 drivers/gpu/drm/radeon/r600.c            | 26 ++++++++------------------
 drivers/gpu/drm/radeon/radeon.h          |  2 ++
 drivers/gpu/drm/radeon/rv770.c           | 23 ++++++++---------------
 drivers/gpu/drm/radeon/si.c              | 21 ++++++++++++++++++---
 drivers/gpu/drm/sti/Kconfig              |  1 +
 drivers/gpu/drm/sti/sti_drm_drv.c        |  4 ++--
 drivers/gpu/drm/sti/sti_hda.c            | 10 +++++-----
 drivers/gpu/drm/sti/sti_hdmi.c           | 10 +++++-----
 drivers/gpu/drm/sti/sti_tvout.c          |  6 +++---
 lib/Kconfig.debug                        |  4 ++++
 18 files changed, 92 insertions(+), 65 deletions(-)
--29444707-75658287-1409193141=:28141--
