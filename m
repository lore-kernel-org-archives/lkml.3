Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaEVDN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 23:13:26 -0400
Received: from gir.skynet.ie ([193.1.99.77]:57759 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160AbaEVDNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 23:13:25 -0400
Date: Thu, 22 May 2014 04:13:22 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm radeon and nouveau fixes
Message-ID: <alpine.DEB.2.00.1405220410520.25062@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1545182257-1400728402=:25062"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1545182257-1400728402=:25062
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Fixes for the other big two, the radeon VCE one is large but it fixes some 
userspace triggerable issues, otherwise its blackscreens and oopses,

nouveau fixes a bleeding laptop panel issue when displayport is used 
sometimes,

Dave.

The following changes since commit 4b660a7f5c8099d88d1a43d8ae138965112592c7:

  Linux 3.15-rc6 (2014-05-22 06:42:02 +0900)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 77c01bef72a5ce5cb24adae6066ed81a52004d30:

  Merge branch 'drm-fixes-3.15' of git://people.freedesktop.org/~deathsimple/linux into drm-fixes (2014-05-22 09:15:57 +1000)

----------------------------------------------------------------

Alex Deucher (4):
      drm/radeon: fix DCE83 check for mullins
      drm/radeon: handle non-VGA class pci devices with ATRM
      drm/radeon: fix register typo on si
      drm/radeon/pm: don't allow debugfs/sysfs access when PX card is off (v2)

Ben Skeggs (1):
      drm/gf119-/disp: fix nasty bug which can clobber SOR0's clock setup

Christian König (4):
      drm/radeon: also try GART for CPU accessed buffers
      drm/radeon: fix page directory update size estimation
      drm/radeon: fix buffer placement under memory pressure v2
      drm/radeon: fix typo in finding PLL params

Dave Airlie (2):
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes
      Merge branch 'drm-fixes-3.15' of git://people.freedesktop.org/~deathsimple/linux into drm-fixes

Jérôme Glisse (1):
      drm/radeon: avoid segfault on device open when accel is not working.

Leo Liu (1):
      drm/radeon: check VCE relocation buffer range v3

Martin Peres (1):
      drm/nvd9/therm: handle another kind of PWM fan

 drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c  |   2 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/nvd0.c |   1 +
 drivers/gpu/drm/radeon/radeon.h                  |   6 +-
 drivers/gpu/drm/radeon/radeon_bios.c             |  14 +++
 drivers/gpu/drm/radeon/radeon_display.c          |   2 +-
 drivers/gpu/drm/radeon/radeon_kms.c              |  55 +++++-----
 drivers/gpu/drm/radeon/radeon_object.c           |  40 ++++---
 drivers/gpu/drm/radeon/radeon_pm.c               |  42 +++++++-
 drivers/gpu/drm/radeon/radeon_vce.c              | 130 +++++++++++++++++------
 drivers/gpu/drm/radeon/radeon_vm.c               |   2 +-
 drivers/gpu/drm/radeon/sid.h                     |   4 +-
 11 files changed, 218 insertions(+), 80 deletions(-)
--29444707-1545182257-1400728402=:25062--
