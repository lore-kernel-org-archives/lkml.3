Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaITHq4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 03:46:56 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34773 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbaITHqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 03:46:55 -0400
Date: Sat, 20 Sep 2014 08:46:52 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1409200844350.9263@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-151056956-1411199212=:9263"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-151056956-1411199212=:9263
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hey Linus,

A bunch of radeon fixes for oops on module unload, and problems with 
resetting the dma engine, one nouveau fix for black boxes in rendering on 
my mbp retina, one sti fix, and a couple of intel fixes.

Dave.


The following changes since commit 37504a3be90b69438426d74ccf467a9fe192932b:

  Merge tag 'gfs2-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes (2014-09-16 07:47:04 -0700)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to fe3d9c4b87bb98222a502cc585844a0b950786fb:

  drm/nouveau: ltc/gf100-: fix cbc issues on certain boards (2014-09-20 17:42:25 +1000)

----------------------------------------------------------------
Alex Deucher (7):
      drm/radeon/dpm: fix resume on mullins
      drm/radeon: don't reset dma on NI/SI init
      drm/radeon: don't reset sdma on CIK init
      drm/radeon: don't reset dma on r6xx-evergreen init
      vgaswitcheroo: add vga_switcheroo_fini_domain_pm_ops
      drm/radeon/px: fix module unload
      drm/nouveau/runpm: fix module unload

Ben Skeggs (1):
      drm/nouveau: ltc/gf100-: fix cbc issues on certain boards

Benjamin Gaignard (1):
      drm: sti: do not iterate over the info frame array

Chris Wilson (1):
      drm/i915: Fix SRC_COPY width on 830/845g

Dave Airlie (3):
      Merge branch 'drm-fixes-3.17' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
      Merge tag 'drm-intel-fixes-2014-09-18' of git://anongit.freedesktop.org/drm-intel into drm-fixes
      Merge branch 'drm-fixes-3.17' of git://people.freedesktop.org/~agd5f/linux into drm-fixes

Gerd Hoffmann (2):
      drm/cirrus: add missing drm_connector_register call
      drm/bochs: add missing drm_connector_register call

Kyle McMartin (1):
      drm/radeon: delete unused PTE_* defines

Michel Dänzer (2):
      drm/radeon: Disable HDP flush before every CS again for < r600
      drm/radeon: Fix typo 'addr' -> 'entry' in rs400_gart_set_page

Ville Syrjälä (1):
      drm/i915: Add limited color range readout for HDMI/DP ports on g4x/vlv/chv

 drivers/gpu/drm/bochs/bochs_kms.c               |  1 +
 drivers/gpu/drm/cirrus/cirrus_mode.c            |  1 +
 drivers/gpu/drm/i915/intel_dp.c                 |  4 ++++
 drivers/gpu/drm/i915/intel_hdmi.c               |  7 ++++++-
 drivers/gpu/drm/i915/intel_ringbuffer.c         |  2 +-
 drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c  |  1 -
 drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c   |  1 +
 drivers/gpu/drm/nouveau/core/subdev/ltc/gf100.c |  2 ++
 drivers/gpu/drm/nouveau/core/subdev/ltc/gk104.c |  2 ++
 drivers/gpu/drm/nouveau/core/subdev/ltc/gm107.c |  2 ++
 drivers/gpu/drm/nouveau/nouveau_vga.c           |  9 ++++++++
 drivers/gpu/drm/radeon/cik_sdma.c               |  7 -------
 drivers/gpu/drm/radeon/kv_dpm.c                 | 28 ++++++++++++++++++-------
 drivers/gpu/drm/radeon/ni_dma.c                 |  6 ------
 drivers/gpu/drm/radeon/r100.c                   | 28 ++++++++++++-------------
 drivers/gpu/drm/radeon/r600_dma.c               |  9 --------
 drivers/gpu/drm/radeon/r600d.h                  |  7 -------
 drivers/gpu/drm/radeon/radeon_asic.c            |  2 --
 drivers/gpu/drm/radeon/radeon_asic.h            |  3 +--
 drivers/gpu/drm/radeon/radeon_device.c          | 11 ++++++++--
 drivers/gpu/drm/radeon/radeon_drv.c             |  2 +-
 drivers/gpu/drm/radeon/rs400.c                  |  4 ++--
 drivers/gpu/drm/sti/sti_hdmi.c                  |  1 -
 drivers/gpu/vga/vga_switcheroo.c                |  6 ++++++
 include/linux/vga_switcheroo.h                  |  2 ++
 25 files changed, 85 insertions(+), 63 deletions(-)
--29444707-151056956-1411199212=:9263--
