Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546Ab3ETXvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 19:51:21 -0400
Received: from gir.skynet.ie ([193.1.99.77]:50357 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943Ab3ETXvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 19:51:20 -0400
Date: Tue, 21 May 2013 00:51:19 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm radeon and nouveau fixes
Message-ID: <alpine.DEB.2.00.1305210049010.15866@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

This is just a set of nouveau and radeon fixes, the nouveau ones fix some 
suspend/resume regressions since use of copy engines and some fixes for Z 
compression on some newer chipsets.

I've got another pull request for some new AMD radeon hw that shouldn't 
touch any existing hw support that I'll send after this, its based on this 
one, so pulling it will get this + that.

Dave.

The following changes since commit e9ced8e040ebe40e9953db90acbe7d0b58702ebb:

  drm/radeon: restore nomodeset operation (v2) (2013-05-17 11:47:07 +1000)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux.git drm-fixes

for you to fetch changes up to a3f6902672c9fa3868722ef6ab8a7dd9141def6a:

  Merge branch 'drm-fixes-3.10' of git://people.freedesktop.org/~agd5f/linux into drm-next (2013-05-21 09:41:33 +1000)

----------------------------------------------------------------

Alex Deucher (1):
      drm/radeon/dce2: use 10khz units for audio dto calculation

Ben Skeggs (9):
      drm/nouveau/bios: fix thinko in ZM_MASK_ADD opcode
      drm/nvc0/ce: disable ce1 on a number of chipsets
      drm/nvc0/ltcg: fix handling of disabled partitions
      drm/nve0/ltcg: poke the partition count into yet another register
      drm/nve0/fifo: prevent races between clients updating playlists
      drm/nvc0/fifo: prevent races between clients updating playlists
      drm/nvc0/fifo: prevent CHAN_TABLE_ERROR:CHANNEL_PENDING on fifo fini
      drm/nv50/fifo: prevent races between clients updating playlists
      drm/nouveau: ensure channels are stopped before saving fences for suspend

Dave Airlie (3):
      drm/nouveau: fix build with nv50->nvc0
      Merge branch 'drm-nouveau-fixes-3.10' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next
      Merge branch 'drm-fixes-3.10' of git://people.freedesktop.org/~agd5f/linux into drm-next

Niels Ole Salscheider (2):
      drm/radeon: Remove superfluous variable
      drm/radeon: Fix VRAM size calculation for VRAM >= 4GB

 drivers/gpu/drm/nouveau/core/engine/device/nvc0.c |  2 --
 drivers/gpu/drm/nouveau/core/engine/fifo/nv50.c   |  2 ++
 drivers/gpu/drm/nouveau/core/engine/fifo/nvc0.c   | 10 +++++++++
 drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c   |  3 +++
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c   |  4 ++--
 drivers/gpu/drm/nouveau/core/subdev/ltcg/nvc0.c   | 17 ++++++++-------
 drivers/gpu/drm/nouveau/nouveau_drm.c             | 25 ++++++++++++++++++-----
 drivers/gpu/drm/radeon/atombios_crtc.c            |  6 ------
 drivers/gpu/drm/radeon/evergreen.c                |  4 ++--
 drivers/gpu/drm/radeon/evergreen_hdmi.c           |  7 +++----
 drivers/gpu/drm/radeon/r600_hdmi.c                |  9 ++++----
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c       |  4 ----
 drivers/gpu/drm/radeon/radeon_mode.h              |  1 -
 drivers/gpu/drm/radeon/radeon_ttm.c               |  2 +-
 drivers/gpu/drm/radeon/si.c                       |  4 ++--
 15 files changed, 59 insertions(+), 41 deletions(-)
