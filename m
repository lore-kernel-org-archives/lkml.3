Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172AbaLCBKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 20:10:37 -0500
Received: from gir.skynet.ie ([193.1.99.77]:53630 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbaLCBKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 20:10:34 -0500
Date: Wed, 3 Dec 2014 01:10:30 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm radeon + nouveau fixes
Message-ID: <alpine.DEB.2.00.1412030106390.4466@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1902007354-1417569030=:4466"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1902007354-1417569030=:4466
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi,

so nouveau had a few regression introduced, Ben and Maarten
finally tracked down the one that was causing problems on my
MacBookPro, also nvidia gave some info on the an engine we
were using incorrectly, so disable our use of it, and
one regresion with pci hotplug affecting optimus users.

radeon has an oops fixs, sync fix, and one workaround to
avoid broken functionality on 32-bit x86, this needs
better root causing and a better fix, but the bandaid
is a lot safer at this point.

Dave.

The following changes since commit 009d0431c3914de64666bec0d350e54fdd59df6a:

  Linux 3.18-rc7 (2014-11-30 16:42:27 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 00d6a9b6be5885ad38234cd171f6fb18a87faa7c:

  Merge branch 'drm-fixes-3.18' of git://people.freedesktop.org/~agd5f/linux into drm-fixes (2014-12-03 11:03:24 +1000)

----------------------------------------------------------------

Ben Skeggs (1):
      drm/nouveau/fifo/g84-: ack non-stall interrupt before handling it

Christian König (1):
      drm/radeon: sync all BOs involved in a CS v2

Dave Airlie (3):
      Merge branch 'linux-3.18' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes
      nouveau: move the hotplug ignore to correct place.
      Merge branch 'drm-fixes-3.18' of git://people.freedesktop.org/~agd5f/linux into drm-fixes

Ilia Mirkin (1):
      drm/nouveau/gf116: remove copy1 engine

Maarten Lankhorst (1):
      drm/nouveau: prevent stale fence->channel pointers, and protect with rcu

Michel Dänzer (1):
      drm/radeon: Ignore RADEON_GEM_GTT_WC on 32-bit x86

Petr Mladek (1):
      drm/radeon: kernel panic in drm_calc_vbltimestamp_from_scanoutpos with 3.18.0-rc6

 drivers/gpu/drm/nouveau/core/engine/device/nvc0.c |  1 -
 drivers/gpu/drm/nouveau/core/engine/fifo/nv04.c   |  2 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nvc0.c   |  4 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c   |  2 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c             |  2 +-
 drivers/gpu/drm/nouveau/nouveau_fence.c           | 92 ++++++++++++++++-------
 drivers/gpu/drm/nouveau/nouveau_fence.h           |  4 +-
 drivers/gpu/drm/radeon/radeon_cs.c                | 17 ++---
 drivers/gpu/drm/radeon/radeon_kms.c               |  2 +
 drivers/gpu/drm/radeon/radeon_object.c            |  7 ++
 10 files changed, 88 insertions(+), 45 deletions(-)

--29444707-1902007354-1417569030=:4466--
