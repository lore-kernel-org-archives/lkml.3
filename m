Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab3ANCQq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 21:16:46 -0500
Received: from gir.skynet.ie ([193.1.99.77]:49923 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951Ab3ANCQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 21:16:45 -0500
Date: Mon, 14 Jan 2013 02:16:42 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1301140215060.8853@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Nothing too astounding,

nouveau: bunch of regression fixes and oops fixes
radeon: UMS fixes , rn50 fix, dma fix
udl: fix EDID retrieval for large EDIDs.

Dave.

The following changes since commit 82ba789f48de669fd0bbc84c326f07571d078572:

  Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel (2013-01-11 07:52:48 +1000)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 7b4cf994e4c6ba48872bb25253cc393b7fb74c82:

  udldrmfb: udl_get_edid: drop unneeded i-- (2013-01-14 08:45:27 +1000)

----------------------------------------------------------------
Aleksi Torhamo (2):
      drm/nouveau/clock: fix support for more than 2 monitors on nve0
      drm/nvc0/fb: fix crash when different mutex is used to protect same list

Ben Skeggs (2):
      drm/nouveau/devinit: ensure legacy vga control is enabled during post
      drm/nouveau: do not forcibly power on lvds panels

Dave Airlie (2):
      Merge branch 'drm-nouveau-fixes' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next
      Merge branch 'drm-fixes-3.8' of git://people.freedesktop.org/~agd5f/linux into drm-next

Hans de Goede (3):
      udldrmfb: Fix EDID not working with monitors with EDID extension blocks
      udldrmfb: udl_get_edid: usb_control_msg buffer must not be on the stack
      udldrmfb: udl_get_edid: drop unneeded i--

Ilija Hadzic (3):
      drm/radeon: fix NULL pointer dereference in UMS mode
      drm/radeon: fix a bogus kfree
      drm/radeon: fix error path in kpage allocation

Jerome Glisse (2):
      radeon/kms: force rn50 chip to always report connected on analog output
      radeon/kms: fix dma relocation checking

Marcin Slusarz (7):
      drm/nouveau: add locking around instobj list operations
      drm/nouveau/vm: fix memory corruption when pgt allocation fails
      drm/nouveau: don't return freed object from nouveau_handle_create
      drm/nouveau: fix nouveau_client allocation failure path
      drm/nouveau: fix blank LVDS screen regression on pre-nv50 cards
      drm/nv17-50: restore fence buffer on resume
      drm/nv50/disp: fix selection of bios script for analog outputs

 drivers/gpu/drm/nouveau/core/core/client.c         |  4 +-
 drivers/gpu/drm/nouveau/core/core/handle.c         |  5 ++-
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c    | 46 ++++++++++++----------
 drivers/gpu/drm/nouveau/core/include/core/client.h |  3 ++
 .../gpu/drm/nouveau/core/include/subdev/bios/pll.h |  2 +
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c    |  1 -
 drivers/gpu/drm/nouveau/core/subdev/clock/nvc0.c   |  2 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c      |  6 +--
 drivers/gpu/drm/nouveau/core/subdev/instmem/base.c | 35 ++++++++++++----
 drivers/gpu/drm/nouveau/core/subdev/vm/base.c      |  4 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        | 30 ++++++++++++--
 drivers/gpu/drm/nouveau/nouveau_display.c          |  9 -----
 drivers/gpu/drm/nouveau/nouveau_drm.c              |  7 +++-
 drivers/gpu/drm/nouveau/nouveau_fence.h            |  1 +
 drivers/gpu/drm/nouveau/nv04_dfp.c                 |  2 +-
 drivers/gpu/drm/nouveau/nv10_fence.c               |  8 ++++
 drivers/gpu/drm/nouveau/nv50_fence.c               |  1 +
 drivers/gpu/drm/radeon/r600_cs.c                   | 12 +++---
 drivers/gpu/drm/radeon/radeon_cs.c                 |  9 +++--
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c    |  8 ++++
 drivers/gpu/drm/udl/udl_connector.c                | 17 +++++++-
 21 files changed, 149 insertions(+), 63 deletions(-)
